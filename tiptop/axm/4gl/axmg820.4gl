# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmg820.4gl
# Descriptions...: 三角貿易採購單明細表(axmg820)
# Date & Author..: 98/12/31  By Billy
# Date & Author..: 03/09/30  By ching No.7946
# Modify.........: No.FUN-4C0096 05/03/03 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/15 By vivien 報表轉XML格式
# Modify.........: No.TQC-5C0087 06/03/21 By Ray AR月底重評價
# Modify.........: NO.FUN-630086 06/04/04 By Niocla 多工廠客戶信用查詢
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-690060 06/10/30 By Rayven 有非一單到底的情況出現，因此采購單與訂單鉤稽時使用pmm99，而非pmm01
# Modify.........: No.MOD-710194 07/01/31 By claire addr1 LIKE occ241
# Modify.........: No.FUN-720014 07/04/09 By rainy 地址擴充成5欄
# Modify.........: No.FUN-750012 07/06/22 By jamie 轉為CR
# Modify.........: No.FUN-780035 07/08/15 By jamie 將畫面上的pmm011(no use)移除
# Modify.........: NO.TQC-7C0026 07/12/05 by fangyan 崝增加開窗查詢脤戙
# Modify.........: NO.MOD-830175 08/03/21 by claire 取位應參考原幣,追加顯示幣別於報表
# Modify.........: NO.MOD-860167 08/06/19 by claire 非一單到底的單號由訂單確認後,串此報表會找不到資料印出
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980020 09/08/31 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-A10056 10/01/13 By lutingting 跨DB寫法修改
# Modify.........: NO:MOD-A20019 10/02/03 by Dido 調整開窗資料 
# Modify.........: No.TQC-A50044 10/05/18 By Carrier MAIN中结构调整
# Modify.........: No.FUN-B40092 11/06/01 By xujing 憑證類報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No:CHI-B70039 11/08/30 By johung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/05 By wangrr GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                              # Print condition RECORD
              wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500) # Where condition
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
   #-----No.FUN-630086 Mark-----
   #      g_ocg
   #                  RECORD
   #           ocg48  LIKE ocg_file.ocg48 ,
   #           ocg49  LIKE ocg_file.ocg49 ,
   #           ocg50  LIKE ocg_file.ocg50 ,
   #           ocg51  LIKE ocg_file.ocg51 ,
   #           ocg52  LIKE ocg_file.ocg52 ,
   #           ocg53  LIKE ocg_file.ocg53 ,
   #           ocg54  LIKE ocg_file.ocg54 ,
   #           ocg55  LIKE ocg_file.ocg55
   #                  END RECORD
   #-----No.FUN-630086 Mark END-----
 
DEFINE   g_i          LIKE type_file.num5                      #count/index for any purpose #No.FUN-680137 SMALLINT
DEFINE   g_msg        LIKE type_file.chr1000                   #No.FUN-680137 VARCHAR(72)
DEFINE   i            LIKE type_file.num5                      #No.FUN-680137 SMALLINT
DEFINE   l_j          LIKE type_file.num5,                     #No.FUN-630086               #No.FUN-680137 SMALLINT
         l_plant      DYNAMIC ARRAY OF LIKE faj_file.faj02     # No.FUN-680137 VARCHAR(10)     #No.FUN-630086
 
#FUN-750012---add---str---
DEFINE   l_table      STRING
DEFINE   g_str        STRING
DEFINE   g_sql        STRING
#FUN-750012---add---end---
 
DEFINE   t_azi        RECORD LIKE azi_file.*                    #MOD-830175
DEFINE   l_pmm22      LIKE pmm_file.pmm22                       #MOD-830175
 
###GENGRE###START
TYPE sr1_t RECORD
    company LIKE cob_file.cob01,
    pmm01 LIKE pmm_file.pmm01,
    pmm09 LIKE pmm_file.pmm09,
    pmm16 LIKE pmm_file.pmm16,
    pmm20 LIKE pmm_file.pmm20,
    pmm41 LIKE pmm_file.pmm41,
    oea01 LIKE oea_file.oea01,
    oea03 LIKE oea_file.oea03,
    oea04 LIKE oea_file.oea04,
    oea044 LIKE oea_file.oea044,
    oea06 LIKE oea_file.oea06,
    oea19 LIKE oea_file.oea19,
    oea38 LIKE oea_file.oea38,
    pmn02 LIKE pmn_file.pmn02,
    pmn04 LIKE pmn_file.pmn04,
    pmn20 LIKE pmn_file.pmn20,
    pmn31 LIKE pmn_file.pmn31,
    pmn33 LIKE pmn_file.pmn33,
    oap041 LIKE oap_file.oap041,
    oap042 LIKE oap_file.oap042,
    oap043 LIKE oap_file.oap043,
    occ01 LIKE occ_file.occ01,
    occ02 LIKE occ_file.occ02,
    occ18 LIKE occ_file.occ18,
    occ61 LIKE occ_file.occ61,
    occg03 LIKE occ_file.occ63,
    occg04 LIKE occ_file.occ64,
    pmc03 LIKE pmc_file.pmc03,
    oah02 LIKE oah_file.oah02,
    pma02 LIKE pma_file.pma02,
    oao06 LIKE oao_file.oao06,
    amn LIKE pmn_file.pmn20,
    cred LIKE occ_file.occ63,
    t62 LIKE type_file.num10,
    dbs LIKE faj_file.faj02,
    oea904 LIKE oea_file.oea904,
    oea904_no LIKE type_file.num5,
    addr1 LIKE occ_file.occ241,
    addr2 LIKE occ_file.occ241,
    addr3 LIKE occ_file.occ241,
    addr4 LIKE occ_file.occ241,
    addr5 LIKE occ_file.occ241,
    occ02_2 LIKE occ_file.occ02,
    occ18_2 LIKE occ_file.occ18,
    addr1_2 LIKE occ_file.occ241,
    addr2_2 LIKE occ_file.occ241,
    addr3_2 LIKE occ_file.occ241,
    addr4_2 LIKE occ_file.occ241,
    addr5_2 LIKE occ_file.occ241,
    oea43 LIKE oea_file.oea43,
    oed021 LIKE oed_file.oed021,
    oed022 LIKE oed_file.oed022,
    oed023 LIKE oed_file.oed023,
    oed031 LIKE oed_file.oed031,
    oed032 LIKE oed_file.oed032,
    oed033 LIKE oed_file.oed033,
    oed034 LIKE oed_file.oed034,
    oed041 LIKE oed_file.oed041,
    oed042 LIKE oed_file.oed042,
    oed043 LIKE oed_file.oed043,
    oed044 LIKE oed_file.oed044,
    oed051 LIKE oed_file.oed051,
    oed052 LIKE oed_file.oed052,
    oed053 LIKE oed_file.oed053,
    oed054 LIKE oed_file.oed054,
    oed055 LIKE oed_file.oed055,
    oed056 LIKE oed_file.oed056,
    oed057 LIKE oed_file.oed057,
    oed058 LIKE oed_file.oed058,
    oed061 LIKE oed_file.oed061,
    oed062 LIKE oed_file.oed062,
    oed063 LIKE oed_file.oed063,
    oed064 LIKE oed_file.oed064,
    oed065 LIKE oed_file.oed065,
    oed066 LIKE oed_file.oed066,
    oed067 LIKE oed_file.oed067,
    oed068 LIKE oed_file.oed068,
    occ02_t LIKE occ_file.occ02,
    occ18_t LIKE occ_file.occ18,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    pmm22 LIKE pmm_file.pmm22,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50044  --Begin
#---------------No.TQC-610089 modify
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#---------------No.TQC-610089 modify

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
  #No.FUN-750012--begin--
   LET g_sql=   "company.cob_file.cob01,  pmm01.pmm_file.pmm01,   pmm09.pmm_file.pmm09,",
       "pmm16.pmm_file.pmm16,    pmm20.pmm_file.pmm20,   pmm41.pmm_file.pmm41,",
       "oea01.oea_file.oea01,    oea03.oea_file.oea03,   oea04.oea_file.oea04,",
       "oea044.oea_file.oea044,  oea06.oea_file.oea06,   oea19.oea_file.oea19,",
       "oea38.oea_file.oea38,    pmn02.pmn_file.pmn02,   pmn04.pmn_file.pmn04,",
       "pmn20.pmn_file.pmn20,    pmn31.pmn_file.pmn31,   pmn33.pmn_file.pmn33,",
       "oap041.oap_file.oap041,  oap042.oap_file.oap042, oap043.oap_file.oap043,",
       "occ01.occ_file.occ01,    occ02.occ_file.occ02,   occ18.occ_file.occ18,",
       "occ61.occ_file.occ61,    occg03.occ_file.occ63,  occg04.occ_file.occ64,",
       "pmc03.pmc_file.pmc03,    oah02.oah_file.oah02,   pma02.pma_file.pma02,",
       "oao06.oao_file.oao06,    amn.pmn_file.pmn20,     cred.occ_file.occ63,",
       " t62.type_file.num10,    dbs.faj_file.faj02,     oea904.oea_file.oea904,",
       "oea904_no.type_file.num5,addr1.occ_file.occ241,  addr2.occ_file.occ241,",
       "addr3.occ_file.occ241,   addr4.occ_file.occ241,  addr5.occ_file.occ241,",
       "occ02_2.occ_file.occ02,  occ18_2.occ_file.occ18,",
       "addr1_2.occ_file.occ241, addr2_2.occ_file.occ241,addr3_2.occ_file.occ241,",
       "addr4_2.occ_file.occ241, addr5_2.occ_file.occ241,  oea43.oea_file.oea43,",
       "oed021.oed_file.oed021,  oed022.oed_file.oed022,  oed023.oed_file.oed023,",
       "oed031.oed_file.oed031,  oed032.oed_file.oed032,  oed033.oed_file.oed033,",
       "oed034.oed_file.oed034,  ",
       "oed041.oed_file.oed041,  oed042.oed_file.oed042,  oed043.oed_file.oed043,",
       "oed044.oed_file.oed044,  ",
       "oed051.oed_file.oed051,  oed052.oed_file.oed052,  oed053.oed_file.oed053,",
       "oed054.oed_file.oed054,  oed055.oed_file.oed055,  oed056.oed_file.oed056,",
       "oed057.oed_file.oed057,  oed058.oed_file.oed058,",
       "oed061.oed_file.oed061,  oed062.oed_file.oed062,  oed063.oed_file.oed063,",
       "oed064.oed_file.oed064,  oed065.oed_file.oed065,  oed066.oed_file.oed066,",
       "oed067.oed_file.oed067,  oed068.oed_file.oed068,",
       "occ02_t.occ_file.occ02,  occ18_t.occ_file.occ18,  azi03.azi_file.azi03  ,", #MOD-830175 modify        
       "azi04.azi_file.azi04  ,  azi05.azi_file.azi05  ,  pmm22.pmm_file.pmm22, ",  #MOD-830175 add   
       "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
       "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
 
 
   LET  l_table = cl_prt_temptable('axmg820',g_sql) CLIPPED
   IF l_table=-1 THEN 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",  #MOD-830175 
               "        ?,?,?,?, ?,?,?) "            # No.FUN-C40020 add4?                         #MOD-830175
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
  #No.FUN-750012--end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
   #No.TQC-A50044  --End  

   #No.TQC-5C0087 --Begin                                                                                                           
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'                                                                              
   #No.TQC-5C0087 --End 
 # IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
   IF cl_null(tm.wc)
      THEN CALL axmg820_tm(0,0)                # Input print condition
      ELSE
          LET tm.more = 'N'
          LET g_pdate = g_today
          LET g_rlang = g_lang
          LET g_bgjob = 'N'
          LET g_copies = '1'
         #LET tm.wc=" pmm01='",tm.wc CLIPPED,"' "   #No.TQC-610089 mark
           CALL axmg820()                           # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION axmg820_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 6  LET p_col = 17
 
   OPEN WINDOW axmg820_w AT p_row,p_col WITH FORM "axm/42f/axmg820"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
  #CONSTRUCT BY NAME tm.wc ON pmm01, pmm04, pmm09, pmm12, pmm13, pmm011,  #FUN-780035 mark
   CONSTRUCT BY NAME tm.wc ON pmm01, pmm04, pmm09, pmm13, pmm12,          #FUN-780035 mod
                              oea904
    #No.FUN-580031 --start--
    BEFORE CONSTRUCT
        CALL cl_qbe_init()
    #No.FUN-580031 ---end---
 
 #..NO.TQC-7C0026.....BEGIN....
    ON ACTION controlp
       CASE 
          WHEN INFIELD(pmm01)
            CALL cl_init_qry_var()
            LET  g_qryparam.state = 'c'
           #LET  g_qryparam.form = "q_pmm01"          #MOD-A20019 mark
            LET  g_qryparam.form = "q_pmm03"          #MOD-A20019
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pmm01
            NEXT FIELD pmm01
       END CASE
   #..NO.TQC-7C0026.....END...
            
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg820_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.more         # Condition
 
#UI
   INPUT BY NAME tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
 
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
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmg820_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmg820'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg820','9031',1)
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
                        #" '",tm.more CLIPPED,"'",              #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg820',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg820_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL axmg820()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg820_w
END FUNCTION
 
FUNCTION axmg820()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   #LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_name    LIKE type_file.chr20,                # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
         #l_time    LIKE type_file.chr8                  #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,              # RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1500)
          l_chr     LIKE type_file.chr1,                 # No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,              # No.FUN-680137 VARCHAR(40)
          l_azp     ARRAY[7] OF LIKE type_file.chr20,    # No.FUN-680137 VARCHAR(20)
          l_dbs     ARRAY[7] OF LIKE type_file.chr20,    # No.FUN-680137 VARCHAR(20)
          l_azp01   ARRAY[7] OF LIKE type_file.chr10,    # No.FUN-980020
          l_t62     LIKE type_file.num10,                # No.FUN-680137 INT
          l_last    LIKE type_file.num5,                 # No.FUN-680137 SMALLINT
          l_company LIKE cob_file.cob01,                 # No.FUN-680137 VARCHAR(36)  # Company name
          l_oea     RECORD LIKE oea_file.*,
          l_oed     RECORD LIKE oed_file.*,
          l_ocf     RECORD LIKE ocf_file.*,
          l_occ02   LIKE occ_file.occ02,
          l_occ18   LIKE occ_file.occ18,
          l_oah02   LIKE oah_file.oah02, 
          l_pma02   LIKE oag_file.oag02,
          l_gaz03   LIKE gaz_file.gaz03,                 #FUN-750012 add
          sr       RECORD
                     pmm01  LIKE  pmm_file.pmm01 ,  #採購單號
                     pmm20  LIKE  pmm_file.pmm20 ,  #採購單號
                     pmm99  LIKE  pmm_file.pmm99 ,  #流程序號  #MOD-860167
                     oea04  LIKE  oea_file.oea04,   #
                     oea044 LIKE  oea_file.oea044,  #
                     oea904 LIKE  oea_file.oea904,  #流程代碼
                     poy03_1 LIKE poy_file.poy03 ,  #下游廠商
                     poy03_2 LIKE poy_file.poy03 ,  #下游廠商
                     poy03_3 LIKE poy_file.poy03 ,  #下游廠商
                     poy03_4 LIKE poy_file.poy03 ,  #下游廠商
                     poy03_5 LIKE poy_file.poy03 ,  #下游廠商
                     poy03_6 LIKE poy_file.poy03 ,  #下游廠商
                     poy04_1 LIKE poy_file.poy04 ,  #下游工廠
                     poy04_2 LIKE poy_file.poy04 ,  #下游工廠
                     poy04_3 LIKE poy_file.poy04 ,  #下游工廠
                     poy04_4 LIKE poy_file.poy04 ,  #下游工廠
                     poy04_5 LIKE poy_file.poy04 ,  #下游工廠
                     poy04_6 LIKE poy_file.poy04    #下游工廠
                   END RECORD ,
          sr1      RECORD
                    pmm01  LIKE  pmm_file.pmm01 ,  #採購單號
                    pmm09  LIKE  pmm_file.pmm09 ,  #共應廠商
                    pmm16  LIKE  pmm_file.pmm16 ,  #運送方式
                    pmm20  LIKE  pmm_file.pmm20 ,
                    pmm41  LIKE  pmm_file.pmm41 ,
                    oea01  LIKE  oea_file.oea01 ,  #訂單單號/合約單號
                    oea03  LIKE  oea_file.oea03 ,
                    oea04  LIKE  oea_file.oea04 ,  #送貨客戶單號
                    oea044 LIKE  oea_file.oea044,  #
                    oea06  LIKE  oea_file.oea06 ,  #修改版本
                    oea19  LIKE  oea_file.oea19 ,  #NOTIFY
                    oea38  LIKE  oea_file.oea38 ,  #FORWARDER
                    pmn02  LIKE  pmn_file.pmn02 ,  #項次
                    pmn04  LIKE  pmn_file.pmn04 ,  #料見編號
                    pmn20  LIKE  pmn_file.pmn20 ,  #訂購量
                    pmn31  LIKE  pmn_file.pmn31 ,  #單價
                    pmn33  LIKE  pmn_file.pmn33 ,  #交貨日
                    pmn87  LIKE  pmn_file.pmn87 ,  #CHI-B70039 add
                    oap041 LIKE  oap_file.oap041 , #地址
                    oap042 LIKE  oap_file.oap042 , #地址
                    oap043 LIKE  oap_file.oap043 , #地址
                    occ01  LIKE  occ_file.occ01  , #
                    occ02  LIKE  occ_file.occ02  , #客戶簡稱
                    occ18  LIKE  occ_file.occ18  , #公司全名
                    occ61  LIKE  occ_file.occ61  , #信用評等
                    occg03 LIKE  occ_file.occ63  , #信用額度
                    occg04 LIKE  occ_file.occ64  , #信用額度可超出率
                    pmc03  LIKE  pmc_file.pmc03  , #簡稱
                    oah02  LIKE  oah_file.oah02  , #說明  
                    pma02  LIKE  pma_file.pma02  , #付款方式說明
                    oao06  LIKE  oao_file.oao06  , #備註
                    amn    LIKE  pmn_file.pmn20  , #金額
                    cred   LIKE  occ_file.occ63  , #信用
                    l_t62  LIKE  type_file.num10,  # No.FUN-680137 INT
                    l_dbs  LIKE  faj_file.faj02,   # No.FUN-680137 VARCHAR(10)
                    oea904 LIKE  oea_file.oea904 , #流程代碼
                    oea904_no  LIKE type_file.num5, # No.FUN-680137 SMALLINT
                   #MOD-710194-begin
                    addr1   LIKE occ_file.occ241,  
                    addr2   LIKE occ_file.occ241,  
                    addr3   LIKE occ_file.occ241,  
                   #FUN-720014 begin
                    addr4   LIKE occ_file.occ241,  
                    addr5   LIKE occ_file.occ241,  
                   #FUN-720014 end
                    occ02_2 LIKE  occ_file.occ02,
                    occ18_2  LIKE  occ_file.occ18,
                    addr1_2 LIKE occ_file.occ241,  
                    addr2_2 LIKE occ_file.occ241,  
                    addr3_2 LIKE occ_file.occ241,   
                   #FUN-720014 begin
                    addr4_2 LIKE occ_file.occ241,  
                    addr5_2 LIKE occ_file.occ241  
                   #FUN-720014 end
                   #MOD-710194-end
          END RECORD
 
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
     CALL cl_wait()
 
     CALL cl_del_data(l_table)                                    #No.FUN-750012 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmg820'    #No.FUN-750012 add 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT " ,
                 " pmm01, pmm20,pmm99,oea04,oea044,oea904, " , #MOD-860167 add pmm99
                 " ''   , ''   , ''   , ''   , ''   , ''   , " ,
                 " ''   , ''   , ''   , ''   , ''   , ''   , " ,
                 " oea_file.*, pmm22 ",            #MOD-830175 add pmm22
                 " FROM pmm_file, oea_file " ,
                 " WHERE pmm99 = oea99 " ,         #No.TQC-690060 pmm01=oea01 -> pmm99=oea99
                 "   AND pmm02 = 'TRI' " ,
                 "   AND oea906 = 'Y' " ,
                 "   AND oeaconf = 'Y' ",          #01/08/16 mandy
                 "   AND pmm18 <> 'X' AND ", tm.wc  CLIPPED
 
     PREPARE axmg820_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        CALL cl_gre_drop_temptable(l_table)  
      EXIT PROGRAM
     END IF 
    #FUN-750012---mark---str---
    #CALL cl_outnam('axmg820') RETURNING l_name
    #START REPORT axmg820_rep TO l_name
    #FUN-750012---mark---end---
     DECLARE axmg820_curs1 CURSOR FOR axmg820_prepare1

   #FUN-C50008--add--str
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 =? ",
                "   AND och02 = 6"
    PREPARE t62_poch FROM l_sql
    DECLARE t62_och CURSOR FOR t62_poch
   #FUN-C50008--add--end   

     FOREACH axmg820_curs1 INTO sr.*,l_oea.*,l_pmm22  #MOD-830175
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
       #MOD-830175-begin-add
        SELECT *  INTO t_azi.*  FROM azi_file  
         WHERE azi01 = l_pmm22 
       #MOD-830175-end-add
        #NO.7946
        SELECT  poy03 , poy04 INTO sr.poy03_1 , sr.poy04_1
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 1
        SELECT  poy03 , poy04 INTO sr.poy03_2 , sr.poy04_2
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 2
        SELECT  poy03 , poy04 INTO sr.poy03_3 , sr.poy04_3
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 3
        SELECT  poy03 , poy04 INTO sr.poy03_4 , sr.poy04_4
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 4
        SELECT  poy03 , poy04 INTO sr.poy03_5 , sr.poy04_5
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 5
        SELECT  poy03 , poy04 INTO sr.poy03_6 , sr.poy04_6
          FROM poy_file WHERE poy01 = l_oea.oea904 AND poy02 = 6
 
        IF cl_null(l_oea.oea43) THEN LET l_oea.oea43=' ' END IF #FUN-750012 add
 
        #讀取該訂單之Consignee/Notify/Remark/Shipping Mark
        INITIALIZE l_oed.* TO NULL
        SELECT * INTO l_oed.*
          FROM oed_file
         WHERE oed01=l_oea.oea01
        #讀取來源廠之客戶簡稱/全名
        SELECT occ02,occ18 INTO l_occ02,l_occ18
          FROM occ_file
         WHERE occ01=l_oea.oea04
        IF cl_null(l_occ02) THEN LET l_occ02=' ' END IF  #FUN-750012 add
        IF cl_null(l_occ18) THEN LET l_occ18=' ' END IF  #FUN-750012 add
        #讀取來源廠之價格條件名稱
        SELECT oah02 INTO l_oah02 
          FROM oah_file 
         WHERE oah01=l_oea.oea31 
        IF cl_null(l_oah02) THEN LET l_oah02=' ' END IF  #FUN-750012 add 
        #讀取來源廠之付款條件名稱
       #SELECT pma02 INTO l_pma02
       #  FROM pma_file
       # WHERE pma01=sr.pmm20
        #讀取來源廠之價格條件名稱
        SELECT oag02 INTO l_pma02
          FROM oag_file
         WHERE oag01=l_oea.oea32
        IF cl_null(l_pma02) THEN LET l_pma02=' ' END IF  #FUN-750012 add
                    
        #判斷 shipping mark 的資料
        IF cl_null(l_oed.oed061) AND cl_null(l_oed.oed062)
           AND cl_null(l_oed.oed063) AND cl_null(l_oed.oed064)
           AND cl_null(l_oed.oed065) AND cl_null(l_oed.oed066)
           AND cl_null(l_oed.oed067) AND cl_null(l_oed.oed068) THEN
           #三角貿易的其他資料若沒有設定
           SELECT * INTO l_ocf.* FROM ocf_file
            WHERE ocf01=l_oea.oea04 AND ocf02=l_oea.oea44
           LET l_oed.oed061=l_ocf.ocf101  LET l_oed.oed062=l_ocf.ocf102
           LET l_oed.oed063=l_ocf.ocf103  LET l_oed.oed064=l_ocf.ocf104
           LET l_oed.oed065=l_ocf.ocf105  LET l_oed.oed066=l_ocf.ocf106
           LET l_oed.oed067=l_ocf.ocf107  LET l_oed.oed068=l_ocf.ocf108
        END IF
 
       #FUN-750012---add---str---   
 
        IF cl_null(l_oed.oed021) THEN LET l_oed.oed021 = ' '  END IF
        IF cl_null(l_oed.oed022) THEN LET l_oed.oed022 = ' '  END IF
        IF cl_null(l_oed.oed023) THEN LET l_oed.oed023 = ' '  END IF
 
        IF cl_null(l_oed.oed031) THEN LET l_oed.oed031 = ' '  END IF
        IF cl_null(l_oed.oed032) THEN LET l_oed.oed032 = ' '  END IF
        IF cl_null(l_oed.oed033) THEN LET l_oed.oed033 = ' '  END IF
        IF cl_null(l_oed.oed034) THEN LET l_oed.oed034 = ' '  END IF
 
        IF cl_null(l_oed.oed041) THEN LET l_oed.oed041 = ' '  END IF
        IF cl_null(l_oed.oed042) THEN LET l_oed.oed042 = ' '  END IF
        IF cl_null(l_oed.oed043) THEN LET l_oed.oed043 = ' '  END IF
        IF cl_null(l_oed.oed044) THEN LET l_oed.oed044 = ' '  END IF
 
        IF cl_null(l_oed.oed051) THEN LET l_oed.oed051 = ' '  END IF
        IF cl_null(l_oed.oed052) THEN LET l_oed.oed052 = ' '  END IF
        IF cl_null(l_oed.oed053) THEN LET l_oed.oed053 = ' '  END IF
        IF cl_null(l_oed.oed054) THEN LET l_oed.oed054 = ' '  END IF
        IF cl_null(l_oed.oed055) THEN LET l_oed.oed055 = ' '  END IF
        IF cl_null(l_oed.oed056) THEN LET l_oed.oed056 = ' '  END IF
        IF cl_null(l_oed.oed057) THEN LET l_oed.oed057 = ' '  END IF
        IF cl_null(l_oed.oed058) THEN LET l_oed.oed058 = ' '  END IF
 
        IF cl_null(l_oed.oed061) THEN LET l_oed.oed061 = ' '  END IF
        IF cl_null(l_oed.oed062) THEN LET l_oed.oed062 = ' '  END IF
        IF cl_null(l_oed.oed063) THEN LET l_oed.oed063 = ' '  END IF
        IF cl_null(l_oed.oed064) THEN LET l_oed.oed064 = ' '  END IF
        IF cl_null(l_oed.oed065) THEN LET l_oed.oed065 = ' '  END IF
        IF cl_null(l_oed.oed066) THEN LET l_oed.oed066 = ' '  END IF
        IF cl_null(l_oed.oed067) THEN LET l_oed.oed067 = ' '  END IF
        IF cl_null(l_oed.oed068) THEN LET l_oed.oed068 = ' '  END IF
      #FUN-750012---add---end---   
 
     CALL s_mtrade_last_plant(l_oea.oea904) RETURNING l_last,g_msg
        #抓另外六個工廠的DATABASE
         FOR i = 1 TO 7
            IF i = 7 THEN  LET l_azp[i] = 'local ' END IF
            IF i = 1 AND sr.poy03_1 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_1
               LET l_azp01[i] = sr.poy04_1                      #FUN-980020 
            END IF
            IF i = 2 AND sr.poy03_2 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_2
               LET l_azp01[i] = sr.poy04_2                      #FUN-980020 
            END IF
            IF i = 3 AND sr.poy03_3 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_3
               LET l_azp01[i] = sr.poy04_3                      #FUN-980020 
            END IF
            IF i = 4 AND sr.poy03_4 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_4
               LET l_azp01[i] = sr.poy04_4                      #FUN-980020 
            END IF
            IF i = 5 AND sr.poy03_5 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_5
               LET l_azp01[i] = sr.poy04_5                      #FUN-980020 
            END IF
            IF i = 6 AND sr.poy03_6 IS NOT NULL THEN
               SELECT azp03 INTO l_azp[i] FROM azp_file WHERE azp01 = sr.poy04_6
               LET l_azp01[i] = sr.poy04_6                      #FUN-980020 
            END IF
            #三角貿易最後一家不印PO
            IF i=l_last THEN LET i=6 CONTINUE FOR END IF
         
            #99.03.01 P/O只印最後一張
            IF l_last >1  AND  (i <l_last-1 OR i =7)  THEN
               CONTINUE FOR
            END IF
         
            IF cl_null(l_azp[i]) THEN CONTINUE FOR END IF
            IF i != 7 THEN
                  LET l_dbs[i] = s_dbstring(l_azp[i] CLIPPED)
            ELSE
                  LET l_dbs[i] = ''
            END IF
            LET sr1.l_dbs=l_dbs[i]
            IF cl_null(sr1.l_dbs) THEN LET sr1.l_dbs=' ' END IF  #FUN-750012 add
            
            LET l_sql = " SELECT pmm01, pmm09, pmm16 , pmm20, pmm41, " ,
                              " oea01, oea04, oea044,oea03, oea06, oea19, oea38, " ,
                               " pmn02, pmn04, pmn20, pmn31, pmn33, ",
                               " pmn87, ",                                            #CHI-B70039 add
                               " '', '', '',  '', '', '', '', '', '', ",
                               " '', '', '' ,'','', '', '','',oea904,0, ",
                               " '','','','','','','','' ",
                         #FUN-A10056--mod--str--
                         #" FROM ", l_dbs[i] CLIPPED, "pmm_file , " ,
                         #          l_dbs[i] CLIPPED, "oea_file , " ,
                         #          l_dbs[i] CLIPPED, "pmn_file   " ,
                          " FROM ",cl_get_target_table(l_azp01[i],'pmm_file'),",",
                                   cl_get_target_table(l_azp01[i],'oea_file'),",",
                                   cl_get_target_table(l_azp01[i],'pmn_file'),
                         #FUN-A10056--mod--end
                        #" WHERE pmm01 = '",sr.pmm01,"'",   #MOD-860167 mark
                         " WHERE pmm99 = '",sr.pmm99,"'",   #MOD-860167
                           " AND pmm99 = oea99 ",   #No.TQC-690060 pmm01=oea01 -> pmm99=oea99
                           " AND pmm01 = pmn01 ",
                           " AND oeaconf = 'Y' " #01/08/16 mandy
         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
            PREPARE axmg820_prepare2 FROM l_sql
            IF STATUS THEN CALL cl_err('axmg820_prepare2',STATUS,1) END IF
            DECLARE axmg820_curs2 CURSOR FOR axmg820_prepare2
               FOREACH axmg820_curs2 INTO sr1.*
               IF STATUS THEN CALL cl_err('foreach',STATUS,1) END IF
               
               LET l_sql = "SELECT oap041, oap042, oap043 ",
                          #" FROM ", l_dbs[i] CLIPPED, " oap_file " ,  #FUN-A10056 
                           " FROM ",cl_get_target_table(l_azp01[i],'oap_file'),
                           " WHERE oap01 = '",sr1.pmm01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg820_prepare3 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg820_prepare3',STATUS,1) END IF
               DECLARE axmg820_curs3 CURSOR FOR axmg820_prepare3
               OPEN axmg820_curs3
               FETCH axmg820_curs3 INTO sr1.oap041, sr1.oap042, sr1.oap043
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.oap041 IS NULL THEN  LET sr1.oap041=' ' END IF
               IF sr1.oap042 IS NULL THEN  LET sr1.oap042=' ' END IF
               IF sr1.oap043 IS NULL THEN  LET sr1.oap043=' ' END IF
               
               LET l_sql = " SELECT occ01, occ02, occ18, occ61 ",
                          #" FROM ", l_dbs[i] CLIPPED , " occ_file " ,   #FUN-A10056
                           " FROM ",cl_get_target_table(l_azp01[i],'occ_file'), #FUN-A10056
                           " WHERE  occ01 = '", sr1.oea03 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg820_prepare4 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg820_prepare4',STATUS,1) END IF
               DECLARE axmg820_curs4 CURSOR FOR axmg820_prepare4
               OPEN axmg820_curs4
               FETCH axmg820_curs4 INTO sr1.occ01, sr1.occ02, sr1.occ18, sr1.occ61
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.occ01 IS NULL THEN LET sr1.occ01 = ' ' END IF
               IF sr1.occ02 IS NULL THEN LET sr1.occ02 = ' ' END IF
               IF sr1.occ18 IS NULL THEN LET sr1.occ18 = ' ' END IF
               IF sr1.occ61 IS NULL THEN LET sr1.occ61 = ' ' END IF #FUN-750012 add
               
              #No.9072
              #LET l_sql = "SELECT occg03, occg04 ",
               LET l_sql = "SELECT occ63, occ64 ",
                          #" FROM ", l_dbs[i] CLIPPED , " occ_file ",    #FUN-A10056
                           "  FROM ",cl_get_target_table(l_azp01[i],'occ_file'), #FUN-A10056
                           " WHERE occ01 = '",sr1.oea03 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg820_prepare5 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg820_prepare5',STATUS,1) END IF
               DECLARE axmg820_curs5 CURSOR FOR axmg820_prepare5
               OPEN axmg820_curs5
               FETCH axmg820_curs5 INTO sr1.occg03, sr1.occg04
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.occg03 IS NULL THEN LET sr1.occg03 = 0 END IF
               IF sr1.occg04 IS NULL THEN LET sr1.occg04 = 0 END IF
               LET sr1.cred = sr1.occg03*(1+sr1.occg04/100)
               IF sr1.cred IS NULL THEN LET sr1.cred = 0 END IF   #FUN-750012 add
               
               LET l_sql = " SELECT pmc03 " ,
                          #"  FROM ", l_dbs[i] CLIPPED , " pmc_file ",   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_azp01[i],'pmc_file'), #FUN-A10056
                           " WHERE pmc01 = '", sr1.pmm09 , "'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg820_prepare6 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg820_prepare6',STATUS,1) END IF
               DECLARE axmg820_curs6 CURSOR FOR axmg820_prepare6
               OPEN axmg820_curs6
               FETCH axmg820_curs6 INTO sr1.pmc03
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.pmc03 IS NULL THEN LET sr1.pmc03 = ' ' END IF
               
               LET l_sql = "SELECT zo02 ",
                          #" FROM ", l_dbs[i] CLIPPED , " zo_file ",   #FUN-A10056
                           "  FROM ",cl_get_target_table(l_azp01[i],'zo_file'), #FUN-A10056
                           " WHERE zo01 = '1'"             #FUN-750012 mark
                          #"WHERE zo01 = '",g_lang ,"'"   #FUN-750012 mod
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg820_zo6 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg820_zo6',STATUS,1) END IF
               DECLARE axmg820_czo6 CURSOR FOR axmg820_zo6
               OPEN axmg820_czo6
               FETCH axmg820_czo6 INTO l_company
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               
               LET l_sql = " SELECT oao06 ",
                          #" FROM ", l_dbs[i] , " oao_file ",    #FUN-A10056
                           "  FROM ",cl_get_target_table(l_azp01[i],'oao_file'), #FUN-A10056
                           " WHERE oao01 = '", sr1.oea01 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
               PREPARE axmg820_prepare9 FROM l_sql
               IF STATUS THEN CALL cl_err('axmg820_prepare9',STATUS,1) END IF
               DECLARE axmg820_curs9 CURSOR FOR axmg820_prepare9
               OPEN axmg820_curs9
               FETCH axmg820_curs9 INTO sr1.oao06
              #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
               IF sr1.oao06 IS NULL THEN LET sr1.oao06 = ' '  END IF
               
                   #-----No.FUN-630086-----
                  #LET l_sql = " SELECT ocg48, ocg49, ocg50, ocg51, ocg52 ",
                  #            " ocg53, ocg54, ocg55 " ,
                  #            " FROM ", l_dbs[i] , " ocg_file ",
                  #            " WHERE ocg01 = '", sr1.occ61 ,"'"
                  #PREPARE axmg820_prepare11 FROM l_sql
                  #IF STATUS THEN CALL cl_err('axmg820_prepare11',STATUS,1) END IF
                  #DECLARE axmg820_curs11 CURSOR FOR axmg820_prepare11
                  #OPEN axmg820_curs11
                  #FETCH axmg820_curs11 INTO g_ocg.ocg48, g_ocg.ocg49,
                  #      g_ocg.ocg50, g_ocg.ocg51, g_ocg.ocg52, g_ocg.ocg53,
                  #      g_ocg.ocg54, g_ocg.ocg55
              #FUN-C50008--mark--str 
              #  LET l_sql = "SELECT och03 FROM och_file",
              #              " WHERE och01 ='",sr1.occ61,"'",
              #              "   AND och02 = 6"
              #  PREPARE t62_poch FROM l_sql
              #  DECLARE t62_och CURSOR FOR t62_poch
              #FUN-C50008--mark--end 
                LET l_j = 1
               
               #FOREACH t62_och INTO l_plant[l_j] #FUN-C50008 mark--
               FOREACH t62_och USING sr1.occ61 INTO l_plant[l_j] #FUN-C50008 add
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach t62_och:',SQLCA.sqlcode,1)
                     EXIT FOREACH
                  END IF
               
                  LET l_j = l_j +1
                END FOREACH          
 
                IF l_j > 1 THEN       #FUN-750012 add
                   LET l_j = l_j - 1
                END IF                #FUN-750012 add
               #-----No.FUN-630086 END-----
               
               #送貨客戶
                LET l_sql = " SELECT occ02, occ18 ",
                           #" FROM ", l_dbs[i] CLIPPED , " occ_file " ,   #FUN-A10056
                            "  FROM ",cl_get_target_table(l_azp01[i],'occ_file'), #FUN-A10056
                            " WHERE  occ01 = '", sr1.oea04 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,l_azp01[i]) RETURNING l_sql    #FUN-A10056
                PREPARE axmg820_pre14 FROM l_sql
                IF STATUS THEN CALL cl_err('axmg820_prepare4',STATUS,1) END IF
                DECLARE axmg820_curs14 CURSOR FOR axmg820_pre14
                OPEN axmg820_curs14
                FETCH axmg820_curs14 INTO sr1.occ02_2, sr1.occ18_2
               #IF STATUS THEN CALL cl_err('fetch',STATUS,1) END IF
                IF sr1.occ02_2 IS NULL THEN LET sr1.occ02_2 = ' ' END IF
                IF sr1.occ18_2 IS NULL THEN LET sr1.occ18_2 = ' ' END IF
                IF sr1.pmn20 IS NULL THEN LET sr1.pmn20 = 0 END IF
                IF sr1.pmn31 IS NULL THEN LET sr1.pmn31 = 0 END IF
                IF sr1.pmn87 IS NULL THEN LET sr1.pmn87 = 0 END IF   #CHI-B70039 add
 
#               LET sr1.amn = sr1.pmn20 * sr1.pmn31   #CHI-B70039 mark
                LET sr1.amn = sr1.pmn87 * sr1.pmn31   #CHI-B70039
                CALL cal_t62(sr1.occ01) RETURNING l_t62
                LET sr1.l_t62 = l_t62
                IF sr1.amn IS NULL THEN LET sr1.amn = 0 END IF   #FUN-750012 add
                
                IF i=7 THEN LET sr1.oea904_no=0 ELSE LET sr1.oea904_no=i END IF
                LET sr1.addr1=' '
                LET sr1.addr2=' '
                LET sr1.addr3=' '
               #FUN-720014 begin
                LET sr1.addr4=' '
                LET sr1.addr5=' '
               #FUN-720014 end
                LET sr1.addr1_2=' '
                LET sr1.addr2_2=' '
                LET sr1.addr3_2=' '
               #FUN-720014 begin
                LET sr1.addr4_2=' '
                LET sr1.addr5_2=' '
               #FUN-720014 end
               #讀取地址資料
                CALL s_addrm(sr1.oea01,l_oea.oea04,l_oea.oea044,'')
                     RETURNING sr1.addr1,sr1.addr2,sr1.addr3,sr1.addr4,sr1.addr5  #FUN-720014
                IF cl_null(sr1.oea04) THEN LET sr1.oea04=sr1.oea03 END IF
#               CALL s_addrm(sr1.oea01,sr1.oea04,sr1.oea044,l_dbs[i])       #FUN-980020 mark
                CALL s_addrm(sr1.oea01,sr1.oea04,sr1.oea044,l_azp01[i])     #FUN-980020
                     RETURNING sr1.addr1_2,sr1.addr2_2,sr1.addr3_2,sr1.addr4_2,sr1.addr5_2  #FUN-720014
               #指定價格條件/付款條件為來源工廠
                LET sr1.pma02 = l_pma02
                LET sr1.oah02 = l_oah02  
               
               #FUN-750012---add---str---
                IF cl_null(sr1.pmm01) THEN LET sr1.pmm01=' ' END IF
                IF cl_null(sr1.pmm09) THEN LET sr1.pmm09=' ' END IF
                IF cl_null(sr1.pmm16) THEN LET sr1.pmm16=' ' END IF
                IF cl_null(sr1.pmm20) THEN LET sr1.pmm20=' ' END IF
                IF cl_null(sr1.pmm41) THEN LET sr1.pmm41=' ' END IF
 
                IF cl_null(sr1.oea01) THEN LET sr1.oea01=' ' END IF
                IF cl_null(sr1.oea03) THEN LET sr1.oea03=' ' END IF
                IF cl_null(sr1.oea04) THEN LET sr1.oea04=' ' END IF
                IF cl_null(sr1.oea044) THEN LET sr1.oea044=' ' END IF
                IF cl_null(sr1.oea06) THEN LET sr1.oea06=0 END IF
                IF cl_null(sr1.oea19) THEN LET sr1.oea19=' ' END IF
                IF cl_null(sr1.oea38) THEN LET sr1.oea38=' ' END IF
         
                IF cl_null(sr1.pmn02) THEN LET sr1.pmn02=' ' END IF
                IF cl_null(sr1.pmn04) THEN LET sr1.pmn04=' ' END IF
                IF cl_null(sr1.pmn33) THEN LET sr1.pmn33=' ' END IF
 
                IF cl_null(sr1.addr1) THEN LET sr1.addr1=' ' END IF
                IF cl_null(sr1.addr2) THEN LET sr1.addr2=' ' END IF
                IF cl_null(sr1.addr3) THEN LET sr1.addr3=' ' END IF
                IF cl_null(sr1.addr4) THEN LET sr1.addr4=' ' END IF
                IF cl_null(sr1.addr5) THEN LET sr1.addr5=' ' END IF
                IF cl_null(sr1.addr1_2) THEN LET sr1.addr1_2=' ' END IF
                IF cl_null(sr1.addr2_2) THEN LET sr1.addr2_2=' ' END IF
                IF cl_null(sr1.addr3_2) THEN LET sr1.addr3_2=' ' END IF
                IF cl_null(sr1.addr4_2) THEN LET sr1.addr4_2=' ' END IF
                IF cl_null(sr1.addr5_2) THEN LET sr1.addr5_2=' ' END IF
               #FUN-750012---add---end---
                
               #OUTPUT TO REPORT axmg820_rep(l_company,sr1.*,  #FUN-750012 mark
               #     l_oea.*,l_oed.*,l_occ02,l_occ18)          #FUN-750012 mark
               #FUN-750012---add---str---
               EXECUTE insert_prep USING 
                       l_company,   sr1.pmm01,   sr1.pmm09,    sr1.pmm16,
                       sr1.pmm20,   sr1.pmm41,   sr1.oea01,    sr1.oea03,
                       sr1.oea04,   sr1.oea044,  sr1.oea06,    sr1.oea19,
                       sr1.oea38,   sr1.pmn02,   sr1.pmn04,    sr1.pmn20, 
                       sr1.pmn31,   sr1.pmn33,   sr1.oap041,   sr1.oap042, 
                       sr1.oap043,  sr1.occ01,   sr1.occ02,    sr1.occ18, 
                       sr1.occ61,   sr1.occg03,  sr1.occg04,   sr1.pmc03,
                       sr1.oah02,   sr1.pma02,   sr1.oao06,    sr1.amn,  
                       sr1.cred,    sr1.l_t62,   sr1.l_dbs,    sr1.oea904,sr1.oea904_no,
                       sr1.addr1,   sr1.addr2,   sr1.addr3,    sr1.addr4,
                       sr1.addr5,   sr1.occ02_2, sr1.occ18_2,
                       sr1.addr1_2, sr1.addr2_2, sr1.addr3_2,  sr1.addr4_2,
                       sr1.addr5_2, l_oea.oea43,
                       l_oed.oed021,l_oed.oed022,l_oed.oed023, 
                       l_oed.oed031,l_oed.oed032,l_oed.oed033,l_oed.oed034,
                       l_oed.oed041,l_oed.oed042,l_oed.oed043,l_oed.oed044,
                       l_oed.oed051,l_oed.oed052,l_oed.oed053,l_oed.oed054,
                       l_oed.oed055,l_oed.oed056,l_oed.oed057,l_oed.oed058,
                       l_oed.oed061,l_oed.oed062,l_oed.oed063,l_oed.oed064,
                       l_oed.oed065,l_oed.oed066,l_oed.oed067,l_oed.oed068,
                       l_occ02,     l_occ18     ,t_azi.azi03 ,t_azi.azi04 ,  #MOD-830175
                       t_azi.azi05 ,l_pmm22   ,"",  l_img_blob,"N",""  # No.FUN-C40020 add                               #MOD-830175  
               #FUN-750012---add---end---
               END FOREACH 
         END FOR
     END FOREACH  
 
    #No.FUN-750012--add---str---
    #FINISH REPORT axmr310_rep
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
       #CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09,pmm12,pmm13,pmm011,oea904')  #FUN-780035 mark
        CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09,pmm13,pmm12,oea904')         #FUN-780035 mod
             RETURNING tm.wc
     ELSE 
        LET tm.wc = ''
     END IF
     SELECT gaz03 INTO l_gaz03 FROM gaz_file WHERE gaz01 = g_prog AND gaz02='1'
###GENGRE###     LET g_str = tm.wc,";",g_azi03,";",g_azi04,";",g_azi05,";",l_gaz03    
###GENGRE###     CALL cl_prt_cs3('axmg820','axmg820',g_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "pmm01"                    # No.FUN-C40020 add
    CALL axmg820_grdata()    ###GENGRE###
    #No.FUN-750012--add---end---
 
    #FINISH REPORT axmg820_rep                         #FUN-750012 mark
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #FUN-750012 mark
END FUNCTION
 
#FUN-750012---mark---str---
#REPORT axmg820_rep(sr1,l_oea,l_oed,l_occ02,l_occ18)
#   DEFINE  p_mode    LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
#   DEFINE  l_last_sw LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#           l_cnt     LIKE type_file.num10,       # No.FUN-680137 INT
#           l_amt01   LIKE pmn_file.pmn20 ,
#           l_amt02   LIKE pmn_file.pmn31 ,
#           l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1500)
#           l_oao06   LIKE oao_file.oao06 ,
#           l_i       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#           l_i2      LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#           l_oea     RECORD LIKE oea_file.*,
#           l_oed     RECORD LIKE oed_file.*,
#           l_occ02   LIKE occ_file.occ02,
#           l_occ18   LIKE occ_file.occ18,
#           sr1              RECORD
#                     company   LIKE oed_file.oed031,   # No.FUN-680137 VARCHAR(36)
#                     pmm01     LIKE  pmm_file.pmm01 ,  #採購單號
#                     pmm09     LIKE  pmm_file.pmm09 ,  #共應廠商
#                     pmm16     LIKE  pmm_file.pmm16 ,  #運送方式
#                     pmm20     LIKE  pmm_file.pmm20 ,
#                     pmm41     LIKE  pmm_file.pmm41 ,
#                     oea01     LIKE  oea_file.oea01 ,  #訂單單號/合約單號
#                     oea03     LIKE  oea_file.oea03 ,
#                     oea04     LIKE  oea_file.oea04 ,  #送貨客戶單號
#                     oea044    LIKE  oea_file.oea044 ,  #
#                     oea06     LIKE  oea_file.oea06 ,  #修改版本
#                     oea19     LIKE  oea_file.oea19 ,  #NOTIFY
#                     oea38     LIKE  oea_file.oea38 ,  #FORWARDER
#                     pmn02     LIKE  pmn_file.pmn02 ,  #項次
#                     pmn04     LIKE  pmn_file.pmn04 ,  #料見編號
#                     pmn20     LIKE  pmn_file.pmn20 ,  #訂購量
#                     pmn31     LIKE  pmn_file.pmn31 ,  #單價
#                     pmn33     LIKE  pmn_file.pmn33 ,  #交貨日
#                     oap041    LIKE  oap_file.oap041 , #地址
#                     oap042    LIKE  oap_file.oap042 , #地址
#                     oap043    LIKE  oap_file.oap043 , #地址
#                     occ01     LIKE  occ_file.occ01 ,
#                     occ02     LIKE  occ_file.occ02  , #客戶簡稱
#                     occ18     LIKE  occ_file.occ18  , #公司全名
#                     occ61     LIKE  occ_file.occ61  , #信用評等
#                     occg03    LIKE  occ_file.occ63 ,  #信用額度
#                     occg04    LIKE  occ_file.occ64 ,  #信用額度可超出率
#                     pmc03     LIKE  pmc_file.pmc03 ,  #簡稱
#                     oah02     LIKE  oah_file.oah02 ,  #說明
#                     pma02     LIKE  pma_file.pma02 ,  #付款方式說明
#                     oao06     LIKE  oao_file.oao06 ,  #備註
#                     amn       LIKE  pmn_file.pmn20 ,  #金額
#                     cred      LIKE  occ_file.occ63,   #性用
#                     l_t62     LIKE  type_file.num10,  # No.FUN-680137 INT
#                     l_dbs     LIKE  faj_file.faj02,   # No.FUN-680137 VARCHAR(10)
#                     oea904    LIKE  oea_file.oea904 , #流程代碼
#                     oea904_no LIKE  type_file.num5,   # No.FUN-680137 SMALLINT
#                    #MOD-710194-begin
#                     addr1     LIKE  occ_file.occ241,  
#                     addr2     LIKE  occ_file.occ241,  
#                     addr3     LIKE  occ_file.occ241,  
#                    #FUN-720014 begin
#                     addr4     LIKE  occ_file.occ241,  
#                     addr5     LIKE  occ_file.occ241,  
#                    #FUN-720014 end
#                     occ02_2   LIKE  occ_file.occ02,
#                     occ18_2   LIKE  occ_file.occ18,
#                     addr1_2   LIKE  occ_file.occ241,  
#                     addr2_2   LIKE  occ_file.occ241,  
#                     addr3_2   LIKE  occ_file.occ241,   
#                    #FUN-720014 begin
#                     addr4_2   LIKE  occ_file.occ241,  
#                     addr5_2   LIKE  occ_file.occ241  
#                    #FUN-720014 end
#                    #MOD-710194-end
#           END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr1.pmm01,sr1.oea904,sr1.oea904_no,sr1.pmn02  #以採購單號跳頁
#  FORMAT
#   PAGE HEADER
#      PRINT ''
#      PRINT COLUMN 19 , sr1.company CLIPPED ,
#            COLUMN 55 , g_x[12] CLIPPED ,     #PO NUM
#            COLUMN 63 , sr1.pmm01 CLIPPED
#      PRINT g_x[13] CLIPPED
#      PRINT COLUMN 23 , g_x[14] CLIPPED ,     #PURCHASE ORDER
#            COLUMN 55 , g_x[15] CLIPPED ,     #DATE
#            COLUMN 64,g_pdate USING"yyyymmdd"CLIPPED
#      PRINT g_x[16] CLIPPED ,                 #P/O TO
#            COLUMN 9 , sr1.pmm09 CLIPPED ,    #供應廠商
#            COLUMN 20 , sr1.pmc03 CLIPPED     #簡稱
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[18] CLIPPED ,                 #SHIP TO
#            COLUMN 14 , sr1.oea04 CLIPPED ,   #送貨客戶
#            COLUMN 38 , g_x[19] CLIPPED ,     #CEC NUMBER
#            COLUMN 50 , sr1.oea01 CLIPPED ,   #訂單單號
#            COLUMN 62 , '-' ,
#            COLUMN 64 , sr1.oea06 CLIPPED
#      PRINT g_dash2[1,g_len]
#      PRINT "(",sr1.oea04 CLIPPED," ",sr1.occ02 CLIPPED,")",
#            COLUMN 38,"SHIPPING INFORMATION"
#      PRINT l_occ18 CLIPPED ,
#            COLUMN 38 , "TYPE      :",l_oea.oea43    #交運方式
#      PRINT sr1.addr1 CLIPPED ,
#            COLUMN 38 , "FORWARDER :",l_oed.oed021 CLIPPED
#      PRINT sr1.addr2 CLIPPED ,
#            COLUMN 49 , l_oed.oed022 CLIPPED
#      PRINT sr1.addr3 CLIPPED ,
#            COLUMN 49 , l_oed.oed023 CLIPPED
#    #FUN-720014 begin
#      PRINT sr1.addr4 CLIPPED 
#      PRINT sr1.addr5 CLIPPED 
#    #FUN-720014 end
#      PRINT " "
#      PRINT "CREDIT  :",
#            COLUMN 11 , sr1.cred ,
#            COLUMN 38 , "PRICE TERM:",sr1.oah02  CLIPPED
#      PRINT g_x[28] CLIPPED  ,
#            COLUMN 11 , sr1.l_t62,             #計算信用
#            COLUMN 38 , "PAYMENT TO CEC:",sr1.pma02  CLIPPED
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[29] CLIPPED ,    #Consignee
#            COLUMN 38,'NOTIFY PARTY:'
#      PRINT l_oed.oed031[1,36], COLUMN 38,l_oed.oed041[1,36]
#      PRINT l_oed.oed032[1,36], COLUMN 38,l_oed.oed042[1,36]
#      PRINT l_oed.oed033[1,36], COLUMN 38,l_oed.oed043[1,36]
#      PRINT l_oed.oed034[1,36], COLUMN 38,l_oed.oed044[1,36]
#
##No.FUN-580013  --begin
#      PRINT g_dash[1,g_len]
#      PRINT g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55]
#      PRINT g_dash1
#      LET l_last_sw = 'n'                #FUN-550127
##No.FUN-580013  --end
#
#   #BEFORE GROUP OF sr1.pmm09
#    BEFORE GROUP OF sr1.oea904_no
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
##No.FUN-580013  --begin
#     PRINT
#           COLUMN g_c[50] , sr1.pmn02 CLIPPED,
#           COLUMN g_c[51] , sr1.pmn04 CLIPPED ,
#           COLUMN g_c[52] , cl_numfor(sr1.pmn20,52,g_azi04),
#           COLUMN g_c[53] , cl_numfor(sr1.pmn31,53,g_azi03),
#           COLUMN g_c[54] , cl_numfor(sr1.amn,54,g_azi04),
#           COLUMN g_c[55] , sr1.pmn33 USING'yyyymmdd' CLIPPED
##No.FUN-580013  --end
# 
#     AFTER GROUP OF sr1.oea904_no
#      LET l_amt01 = GROUP SUM(sr1.pmn20)
#      LET l_amt02 = GROUP SUM(sr1.amn)
#
#      PRINT ''
#      PRINT ''
#      PRINT ''
#      PRINT g_x[39] CLIPPED
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[40] CLIPPED ,
##No.FUN-580013  --begin
#            COLUMN g_c[52] , cl_numfor(l_amt01,52,g_azi05),
#            COLUMN g_c[54] , cl_numfor(l_amt02,54,g_azi05)
##No.FUN-580013  --end
#      PRINT g_dash2[1,g_len]
#      PRINT g_x[41] CLIPPED ,
#            COLUMN 60 , g_x[45] CLIPPED
#      PRINT g_dash2[1,g_len]
# 
#      #REMARK /SHIPPING MARK
#      PRINT COLUMN 1,"1.",l_oed.oed051 CLIPPED,COLUMN 64,l_oed.oed061[1,20]
#      PRINT COLUMN 1,"2.",l_oed.oed052 CLIPPED,COLUMN 64,l_oed.oed062[1,20]
#      PRINT COLUMN 1,"3.",l_oed.oed053 CLIPPED,COLUMN 64,l_oed.oed063[1,20]
#      PRINT COLUMN 1,"4.",l_oed.oed054 CLIPPED,COLUMN 64,l_oed.oed064[1,20]
#      PRINT COLUMN 1,"5.",l_oed.oed055 CLIPPED,COLUMN 64,l_oed.oed065[1,20]
#      PRINT COLUMN 1,"6.",l_oed.oed056 CLIPPED,COLUMN 64,l_oed.oed066[1,20]
#      PRINT COLUMN 1,"7.",l_oed.oed057 CLIPPED,COLUMN 64,l_oed.oed067[1,20]
#      PRINT COLUMN 1,"8.",l_oed.oed058 CLIPPED,COLUMN 64,l_oed.oed068[1,20]
# 
#      PRINT ''
#      PRINT ''
#      PRINT ''
#      PRINT g_x[42] CLIPPED ,
#            COLUMN 45 , g_x[43] CLIPPED
#      PRINT ''
#      PRINT g_x[44] CLIPPED
#
### FUN-550127
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[48]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[48]
#             PRINT g_memo
#      END IF
### END FUN-550127
#
#END REPORT
#FUN-750012---mark---end---
 
#---------------------------------------#
# 多工廠發票應收帳計算 by WUPN 96-05-23 #
#---------------------------------------#
 
FUNCTION cal_t62(l_occ01)
   DEFINE l_occ01 LIKE occ_file.occ01,
          l_t62,l_tmp  LIKE type_file.num10,            #No.FUN-680137 INTEGER
          l_i          LIKE type_file.num10,            #No.FUN-680137 INTEGER
          l_sql           LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1500)
          l_azp01         LIKE azp_file.azp01,
          l_azp03         LIKE azp_file.azp03
   #      l_plant         ARRAY[8] OF LIKE faj_file.faj02      # No.FUN-680137    # 工廠編號
 
   #-----No.FUN-630086 Mark-----
   #LET l_plant[1]=g_ocg.ocg48    LET l_plant[2]=g_ocg.ocg49
   #LET l_plant[3]=g_ocg.ocg50    LET l_plant[4]=g_ocg.ocg51
   #LET l_plant[5]=g_ocg.ocg52    LET l_plant[6]=g_ocg.ocg53
   #LET l_plant[7]=g_ocg.ocg54    LET l_plant[8]=g_ocg.ocg55
   #-----No.FUN-630086 Mark END-----
 
    LET l_t62=0
    LET l_j = 1   #FUN-750012 add
    
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF   #No.TQC-A50044
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
      #LET l_sql=" SELECT SUM(oma56t-oma57) FROM ",l_azp03 CLIPPED,".dbo.oma_file",
       #No.TQC-5C0087  --Begin                                                                                                      
       IF g_ooz.ooz07 = 'N' THEN                                                                                                    
         #LET l_sql=" SELECT SUM(oma56t-oma57) FROM ",l_azp03 CLIPPED,".dbo.oma_file",            #TQC-950032 MARK                      
         #LET l_sql=" SELECT SUM(oma56t-oma57) FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file", #TQC-950032 ADD   #FUN-A10056
          LET l_sql=" SELECT SUM(oma56t-oma57) ",    #FUN-A10056
                    "   FROM ",cl_get_target_table(l_plant[l_i],'oma_file'),   #FUN-A10056
                    " WHERE oma03='",l_occ01,"'",                                                                                   
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       ELSE                                                                                                                         
         #LET l_sql=" SELECT SUM(oma61) FROM ",l_azp03 CLIPPED,".dbo.oma_file",             #TQC-950032 MARK                            
         #LET l_sql=" SELECT SUM(oma61) FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",  #TQC-950032 ADD  #FUN-A10056
          LET l_sql=" SELECT SUM(oma61) ",     #FUN-A10056
                    "   FROM ",cl_get_target_table(l_plant[l_i],'oma_file'),   #FUN-A10056 
                    " WHERE oma03='",l_occ01,"'",                                                                                   
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       END IF                                                                                                                       
      #No.TQC-5C0087  --End 
       CALL cl_parse_qry_sql(l_sql,l_plant[l_i]) RETURNING l_sql    #FUN-A10056
       PREPARE t62_pre FROM l_sql
       DECLARE t62_curs CURSOR FOR t62_pre
       OPEN t62_curs LET l_tmp=0
       FETCH t62_curs INTO l_tmp IF cl_null(l_tmp) THEN LET l_tmp=0 END IF
       LET l_t62=l_t62+l_tmp
       CLOSE t62_curs
    END FOR
    RETURN l_t62
END FUNCTION
 
#Patch....NO.TQC-610037 <> #

###GENGRE###START
FUNCTION axmg820_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg820")
        IF handler IS NOT NULL THEN
            START REPORT axmg820_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY pmm01,pmn02"
            DECLARE axmg820_datacur1 CURSOR FROM l_sql
            FOREACH axmg820_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg820_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg820_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg820_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno        LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_pmn20_sum     LIKE pmn_file.pmn20
    DEFINE l_amn_sum       LIKE pmn_file.pmn20
    DEFINE l_p5            LIKE gaz_file.gaz03 
    DEFINE l_pmn20_fmt     STRING
    DEFINE l_pmn31_fmt     STRING
    DEFINE l_amn_fmt       STRING
    DEFINE l_pmn20_sum_fmt STRING
    DEFINE l_amn_sum_fmt   STRING
    #FUN-B40092------add------end 
    
    ORDER EXTERNAL BY sr1.pmm01,sr1.oea904
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            
              
        BEFORE GROUP OF sr1.pmm01
            #FUN-B40092------add------str
            LET l_pmn20_fmt = cl_gr_numfmt('pmn_file','pmn20',g_azi04)
            LET l_pmn31_fmt = cl_gr_numfmt('pmn_file','pmn31',sr1.azi03)
            LET l_amn_fmt = cl_gr_numfmt('pmn_file','pmn20',sr1.azi04)
            PRINTX l_pmn20_fmt
            PRINTX l_pmn31_fmt
            PRINTX l_amn_fmt
            SELECT gaz03 INTO l_p5 FROM gaz_file WHERE gaz01 = g_prog AND gaz02='1'
            PRINTX l_p5
            #FUN-B40092------add------end
            LET l_lineno = 0
        BEFORE GROUP OF sr1.oea904

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.pmm01
        AFTER GROUP OF sr1.oea904
            #FUN-B40092------add------str
            LET l_pmn20_sum = GROUP SUM(sr1.pmn20)
            LET l_amn_sum   = GROUP SUM(sr1.amn)
            PRINTX l_pmn20_sum
            PRINTX l_amn_sum
            LET l_pmn20_sum_fmt = cl_gr_numfmt('pmn_file','pmn20',g_azi05)
            LET l_amn_sum_fmt = cl_gr_numfmt('pmn_file','pmn20',sr1.azi05)
            PRINTX l_pmn20_sum_fmt
            PRINTX l_amn_sum_fmt
            #FUN-B40092------add------end
        ON LAST ROW

END REPORT
###GENGRE###END

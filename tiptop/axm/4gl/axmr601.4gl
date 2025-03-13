# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr601.4gl
# Descriptions...: Delivery Note 
# Date & Author..: No.FUN-6C0005 06/12/05 by rainy  ref. axmr600
# Modify.........: No.FUN-710090 07/02/27 By chenl 報表輸出至Crystal Reports功能
#                                                  注意，axmr600和axmr601共用一個axmr600.ttx數據類型文件，若對此ttx文件有所改動而影響程序，請一并修改其他共用ttx的相關程序。
# Modify.........: No.FUN-730014 07/03/06 By chenl s_addr傳回5個參數
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.FUN-860026 08/07/25 By baofei 增加子報表-列印批序號明細    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80088 10/08/17 By yinhy 畫面條件選項增加一個選項，Additional Description Category
# Modify.........: No.TQC-B30065 11/03/09 By zhangll l_sql -> STRING
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.MOD-BB0031 11/11/03 By Sakura 報表總計不正確,增加出貨單項次key值join
# Modify.........: No.MOD-BB0046 11/12/28 By Summer 請增加rvbs00<>'aqct800'的條件,排除QC的rvbs
# Modify.........: No.TQC-C10039 12/01/12 By JinJJ  EasyFlow列印簽核
 
DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-680137 SMALLINT
END GLOBALS
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)    # Where condition
              wc      STRING,  #Mod No.TQC-B30065
              a       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # print price
              d       LIKE type_file.chr1,        # No.FUN-690032 客戶料號
              b       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # print memo
              c       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)     # print Sub Item#      #No.FUN-5C0075
              e       LIKE type_file.chr1,        #FUN-740057 add              # 列印公司對內全名
              f       LIKE type_file.chr1,        #FUN-740057 add              # 列印公司對外全名
              g       LIKE type_file.chr1,        #No.FUN-860026 
              h       LIKE type_file.chr1,        #No.FUN-A80088  
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)     # Input more condition(Y/N)
              END RECORD,
          g_m  ARRAY[40] OF LIKE oao_file.oao06,   #No.MOD-610046
          l_outbill   LIKE oga_file.oga01    # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137  VARCHAR(72)
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oga01     LIKE oga_file.oga01,
          oga03     LIKE oga_file.oga03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE  g_oga01     LIKE oga_file.oga01   #FUN-650020
#FUN-6C0005
#No.FUN-710090--begin-- 
DEFINE  g_sql1      STRING
DEFINE  g_sql       STRING
DEFINE  g_str       STRING
DEFINE  l_table     STRING
DEFINE  l_table1    STRING
DEFINE  l_table2    STRING
DEFINE  l_table3    STRING                 #No.FUN-860026    
DEFINE  l_table4    STRING                 #No.FUN-A80088  
#No.FUN-710090--end--
 
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
  
  #No.FUN-710090--begin--
    LET g_sql1="oga01.oga_file.oga01,",
               "oga011.oga_file.oga011,",
               "oga02.oga_file.oga02,",
               "oga16.oga_file.oga16,",
               "oga021.oga_file.oga021,",
               "oga15.oga_file.oga15,",
               "gem02.gem_file.gem02,",
               "oga032.oga_file.oga032,",
               "oga033.oga_file.oga033,",
               "oga045.oga_file.oga45,",
               "oga03.oga_file.oga03,",
               "oga04.oga_file.oga04,",
               "oga14.oga_file.oga14,",
               "gen02.gen_file.gen02,",
               "occ02.occ_file.occ02,",
               "addr1.aaf_file.aaf03,",
               "addr2.aaf_file.aaf03,",
               "addr3.aaf_file.aaf03,",
               "ogb03.ogb_file.ogb03,",
               "ogb04.ogb_file.ogb04,",
               "donum.type_file.chr20,",
               "ogb12.ogb_file.ogb12,",
               "ogb05.ogb_file.ogb05,",
               "ima02.ima_file.ima02,",
               "weight.ogb_file.ogb12,",
               "ogb19.ogb_file.ogb19,",
               "ima021.ima_file.ima021,",
               "note.type_file.chr37,",
               "str3.type_file.chr1000,",
               "ogb11.ogb_file.ogb11,",
               "oga09.oga_file.oga09,",      #FUN-740057 add
#               "oaydesc.oay_file.oaydesc,",   #FUN-740057 add
               "oaydesc.oay_file.oaydesc,",  #No.FUN-860026
               "flag.type_file.num5,",       #No.FUN-860026 
               "ogb07.ogb_file.ogb07,",      #No.FUN-A80088 
               "l_count.type_file.num5,",      #No.FUN-A80088
              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #TQC-C10039
              "sign_show.type_file.chr1,sign_str.type_file.chr1000"   #是否顯示簽核資料(Y/N)  #TQC-C10039
   LET l_table = cl_prt_temptable('axmr601',g_sql1) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql1="ogc01.ogc_file.ogc01,",
              "i1.type_file.num5,",
              "loc.type_file.chr37,",
              "ogc16.ogc_file.ogc16,",
              "ogc03.ogc_file.ogc03" #No.MOD-BB0031 add
   LET l_table1 = cl_prt_temptable('axmr6011',g_sql1) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   LET g_sql1 ="ogc01.ogc_file.ogc01,",
              "i2.type_file.num5,",
              "ogc17.ogc_file.ogc17,",
              "ogc12.ogc_file.ogc12,",
              "ima02t.ima_file.ima02"
   LET l_table2 = cl_prt_temptable('axmr6012',g_sql1) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
  #No.FUN-710090--end--
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                          
               "rvbs04.rvbs_file.rvbs04,",                                                                                          
               "rvbs06.rvbs_file.rvbs06,",                                                                                          
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ogb06.ogb_file.ogb06,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "ogb05.ogb_file.ogb05,",                                                                                             
               "ogb12.ogb_file.ogb12,",                                                                                             
               "img09.img_file.img09"                                                                                               
   LET l_table3 = cl_prt_temptable('axmr6013',g_sql) CLIPPED                                                                        
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF                                                                                       
#No.FUN-860026---end  
   #No.FUN-A80088 --start--
   LET g_sql1 = "imc01.imc_file.imc01,",
                "imc02.imc_file.imc02,",
                "imc03.imc_file.imc03,",
                "imc04.imc_file.imc04,",
                "oga01.oga_file.oga01,",
                "ogb03.ogb_file.ogb03"
    LET l_table4 = cl_prt_temptable('axmr6014',g_sql1) CLIPPED
    IF  l_table4 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-A80088 --end--   
   INITIALIZE tm.* TO NULL                # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.c    = ARG_VAL(10)
   LET tm.e    = ARG_VAL(11)   #FUN-740057 add
   LET tm.f    = ARG_VAL(12)   #FUN-740057 add
   LET tm.g    = ARG_VAL(13)   #No.FUN-860026 
   LET tm.h    = ARG_VAL(14)   #No.FUN-A80088 
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
 
   IF cl_null(tm.wc) THEN
      CALL axmr601_tm(0,0)             # Input print condition
   ELSE
     #LET tm.wc="oga01 ='",tm.wc CLIPPED,"' " CLIPPED    #No.TQC-610089 mark
      LET tm.a = "1"    #No.MOD-580084
      CALL axmr601()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr601_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr601_w AT p_row,p_col WITH FORM "axm/42f/axmr601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
#No.FUN-5C0075--begin
   SELECT oaz23 INTO l_oaz23 FROM oaz_file
   IF l_oaz23 = 'N' THEN
      CALL cl_set_comp_visible("c",FALSE)
   END IF
#No.FUN-5C0075--end
 
   CALL cl_opmsg('p')
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oga01,oga02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         #### No.FUN-4A0020
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"  #No.TQC-5B0095
                 LET g_qryparam.arg1 = "2','3','4','6','7','8"   #No.TQC-5B0095 #No.FUN-610020
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
            END CASE
         ### END  No.FUN-4A0020
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW axmr601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET tm.a = '1'
      LET tm.d = 'N'   #FUN-690032 add
      LET tm.b = 'Y'
      LET tm.c = 'N'   #No.FUN-5C0075
      LET tm.e = 'Y'   #FUN-740057 add
      LET tm.f = 'Y'   #FUN-740057 add
      LET tm.g = 'N'  #No.FUN-860026  
      LET tm.h = 'N'  #No.FUN-A80088
      INPUT BY NAME tm.a,tm.d,tm.b,tm.c,tm.e,tm.f,tm.g,tm.h,tm.more WITHOUT DEFAULTS   #No.FUN-5C0075  #FUN-690032 add tm.d   #FUN-740057 add tm.e,tm.f  #No.FUN-860026  add tm.g  #FUN-A80088 add tm.h
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
               NEXT FIELD a
            END IF
 
        #FUN-690032 add--begin
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
               NEXT FIELD d
            END IF
        #FUN-690032 add--end 
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
 
#No.FUN-5C0075--begin
        AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
             NEXT FIELD c
          END IF
#No.FUN-5C0075--end
 
        #str FUN-740057 add
        AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN 
               NEXT FIELD e 
            END IF
   
        AFTER FIELD f
            IF cl_null(tm.f) OR tm.f NOT MATCHES '[YN]' THEN 
               NEXT FIELD f 
            END IF
        #end FUN-740057 add
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD g    #列印批序號明細                                                                                              
         IF tm.g NOT MATCHES "[YN]" OR cl_null(tm.g)                                                                                
            THEN NEXT FIELD g                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END  
        #FUN-A80088 add--begin
         AFTER FIELD h
            IF cl_null(tm.h) OR tm.h NOT MATCHES '[YN]' THEN
               NEXT FIELD h
            END IF
        #FUN-A80088 add--end       
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW axmr601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'axmr601'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr601','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.a CLIPPED,"'" ,
                        " '",tm.d CLIPPED,"'" ,  #FUN-690032 add
                       #---------
                        " '",tm.b CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                       #------------No.TQC-610089 end
                        " '",tm.e CLIPPED,"'" ,                #FUN-740057 add
                        " '",tm.f CLIPPED,"'" ,                #FUN-740057 add
                        " '",tm.g CLIPPED,"'" ,                #No.FUN-860026
                        " '",tm.h CLIPPED,"'" ,                #No.FUN-A80088 
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmr601',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW axmr601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL axmr601()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW axmr601_w
 
END FUNCTION
 
FUNCTION axmr601()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
     #     l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,  #Mod No.TQC-B30065
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_count   LIKE type_file.num5,          #No.FUN-A80088 
          sr        RECORD
                       oga01     LIKE oga_file.oga01,
                       oaydesc   LIKE oay_file.oaydesc,
                       oga02     LIKE oga_file.oga02,
                       oga021    LIKE oga_file.oga021,
                       oga011    LIKE oga_file.oga011,
                       oga14     LIKE oga_file.oga14,
                       oga15     LIKE oga_file.oga15,
                       oga16     LIKE oga_file.oga16,
                       oga032    LIKE oga_file.oga032,
                       oga03     LIKE oga_file.oga03,
                       oga033    LIKE oga_file.oga033,   #統一編號
                       oga45     LIKE oga_file.oga45,    #聯絡人
                       occ02     LIKE occ_file.occ02,
                       oga04     LIKE oga_file.oga04,
                       oga044    LIKE oga_file.oga044,
                       ogb03     LIKE ogb_file.ogb03,
                       ogb07     LIKE ogb_file.ogb07,   #No.FUN-A80088
                       ogb31     LIKE ogb_file.ogb31,
                       ogb32     LIKE ogb_file.ogb32,
                       ogb04     LIKE ogb_file.ogb04,
                       ogb092    LIKE ogb_file.ogb092,
                       ogb05     LIKE ogb_file.ogb05,
                       ogb12     LIKE ogb_file.ogb12,
                       ogb06     LIKE ogb_file.ogb06,
                       ogb11     LIKE ogb_file.ogb11,
                       ogb17     LIKE ogb_file.ogb17,
                       ogb19     LIKE ogb_file.ogb19,      #No.FUN-5C0075
                       ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                       ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                       ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                       ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
                       ogb916    LIKE ogb_file.ogb916,     #No.TQC-5B0127
                       ima18     LIKE ima_file.ima18
                    END RECORD,
         #No.FUN-A80088  --start--
           sr1        RECORD
                      imc01     LIKE imc_file.imc01,
                      imc02     LIKE imc_file.imc02,
                      imc03     LIKE imc_file.imc03,
                      imc04     LIKE imc_file.imc04
                      END RECORD
          #No.FUN-A80088  --end--
   DEFINE l_msg    STRING    #FUN-650020
   DEFINE l_msg2   STRING    #FUN-650020
   DEFINE lc_gaq03 LIKE gaq_file.gaq03   #FUN-650020
  #No.FUN-710090--begin--
   DEFINE  l_ogb       RECORD LIKE ogb_file.*
   DEFINE         l_addr1    LIKE aaf_file.aaf03
   DEFINE         l_addr2    LIKE aaf_file.aaf03
   DEFINE         l_addr3    LIKE aaf_file.aaf03
   DEFINE         l_addr4    LIKE aaf_file.aaf03      #No.FUN-730014
   DEFINE         l_addr5    LIKE aaf_file.aaf03      #No.FUN-730014
   DEFINE         l_gen02    LIKE gen_file.gen02
   DEFINE         l_oag02    LIKE oag_file.oag02
   DEFINE         l_gem02    LIKE gem_file.gem02
   DEFINE         l_ogb12    LIKE ogb_file.ogb12
   DEFINE         l_str2     STRING
   DEFINE         l_str3     LIKE type_file.chr1000
   DEFINE         l_ogc      RECORD
                          ogc09     LIKE ogc_file.ogc09,
                          ogc091    LIKE ogc_file.ogc091,
                          ogc16     LIKE ogc_file.ogc16,
                          ogc092    LIKE ogc_file.ogc092,
                          ogc03    LIKE ogc_file.ogc03 #No.MOD-BB0031 add
                       END RECORD
   DEFINE         l_loc      LIKE type_file.chr37
   DEFINE         l_weight   LIKE ogb_file.ogb12
   DEFINE         l_donum    LIKE type_file.chr20
   DEFINE         l_ima906    LIKE ima_file.ima906
   DEFINE         l_ima021    LIKE ima_file.ima021  
   DEFINE         l_ima02     LIKE ima_file.ima02
   DEFINE         l_ogb915    STRING
   DEFINE         l_ogb912    STRING
   DEFINE         l_note      LIKE type_file.chr37
   DEFINE         l_oga09     LIKE oga_file.oga09
   DEFINE         l_oaz23     LIKE oaz_file.oaz23
   DEFINE         g_ogc       RECORD
                   ogc12 LIKE ogc_file.ogc12,
                   ogc17 LIKE ogc_file.ogc17
              END RECORD
   DEFINE l_zo12   LIKE zo_file.zo12   #FUN-740057 add
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09                                                                                  
     DEFINE        flag        LIKE type_file.num5
     DEFINE        l_img_blob         LIKE type_file.blob  #TQC-C10039
#No.FUN-860026---end    
  #No.FUN-710090--end--
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)   #No.FUN-860026  
   CALL cl_del_data(l_table4)   #No.FUN-A80088 
   LOCATE l_img_blob IN MEMORY    #TQC-C10039
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #str FUN-740057 add
   SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
   IF cl_null(l_zo12) THEN
      SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
   END IF
   #end FUN-740057 add
 
   #MOD-540174..................begin
#  DECLARE axmr600_za_cur CURSOR FOR
#          SELECT za02,za05 FROM za_file
#           WHERE za01 = "axmr600" AND za03 = g_rlang
#  FOREACH axmr600_za_cur INTO g_i,l_za05
#     LET g_x[g_i] = l_za05
#  END FOREACH
   #MOD-540174..................end
  #No.FUN-710090--begin--
  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr601'  #No.FUN-710090 mark
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr601'
   LET g_sql1= "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, 
                                                                 ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "   #FUN-740057 add ?,?   #No.FUN-860026 add ,?  #FUN-A80088 add 2?  #TQC-C10039 add 4?
   PREPARE insert_prep FROM g_sql1
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   LET g_sql1= "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED," values(?,?,?,?,?) " #No.MOD-BB0031 add ?
   PREPARE insert1 FROM g_sql1
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF   
   LET g_sql1= "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED," values(?,?,?,?,?) "
   PREPARE insert2 FROM g_sql1
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF  
  #LET g_len = 134           #No.FUN-570176                    #No.FUN-710090 mark  
  #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR      #No.FUN-710090 mark 
  #No.FUN-710090--end--
#No.FUN-860026---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep3 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep3:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-860026---END 
#No.FUN-A80088---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep4 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep4:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-A80088---END
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
 
   LET l_sql="SELECT oga01,oaydesc,oga02,oga021,oga011,oga14,oga15,oga16, ",
             "       oga032,oga03,oga033,oga45,occ02,oga04,oga044,ogb03,ogb07,   ",   #No.FUN-A80088 add ogb07
             "       ogb31,ogb32,ogb04,ogb092,ogb05,ogb12,ogb06,ogb11,ogb17,ogb19,ogb910,ogb912,ogb913,ogb915,ogb916,ima18",        #No.FUN-580004 #TQC-5B0127 add ogb916 AND FUN-5C0075
" FROM oga_file LEFT OUTER JOIN oay_file ON oga_file.oga01 LIKE  ltrim(rtrim(oay_file.oayslip)) || '-%' LEFT OUTER JOIN occ_file ON oga_file.oga04 = occ_file.occ01,ogb_file LEFT OUTER JOIN ima_file ON ogb_file.ogb04 = ima_file.ima01 WHERE oga01 = ogb01 ", 
#No.FUN-550070--end
             "   AND oga09 != '1' AND  oga09 != '5' AND oga09 !='9'", #No.FUN-610020
             "   AND ",tm.wc CLIPPED,
             "   AND ogaconf != 'X' " #01/08/20 mandy
 
   LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "
 
   PREPARE axmr601_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   DECLARE axmr601_curs1 CURSOR FOR axmr601_prepare1
 
 ##No.FUN-710090--begin-- mark
 # #CALL cl_outnam('axmr601') RETURNING l_name    #No.FUN-710090 mark
 
 #  #FUN-580004--begin
 #  SELECT sma115 INTO g_sma115 FROM sma_file
 #  IF g_sma115 = "Y" THEN
 #     LET g_zaa[34].zaa06 = "N"
 #    #LET g_zaa[45].zaa06 = "N" #FUN-5A0181 mark
 #  ELSE
 #     LET g_zaa[34].zaa06 = "Y"
 #    #LET g_zaa[45].zaa06 = "Y" #FUN-5A0181 mark
 #  END IF
 
 ##FUN-690032 add--begin  #列印客戶料號
 # IF tm.d = 'N' THEN
 #    LET g_zaa[56].zaa06 = 'Y'
 # ELSE
 #    LET g_zaa[56].zaa06 = 'N'
 # END IF
 ##FUN-690032 add--end
 
 #  CALL cl_prt_pos_len()
 #  #No.FUN-580004--end
 
 #  START REPORT axmr601_rep TO l_name
 
 #  LET g_pageno = 0
    CALL g_show_msg.clear() #FUN-650020
 ##No.FUN-710090--end--  
 
   FOREACH axmr601_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF sr.ogb092 IS NULL THEN
         LET sr.ogb092 = ' '
      END IF
  #No.FUN-710090--begin--
         SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
         IF STATUS THEN
            LET l_gen02 = ''
         END IF
 
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
         IF STATUS THEN
            LET l_gem02 = ''
         END IF
 
         CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
              RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5   #No.FUN-730014  addr4/addr5
         IF SQLCA.SQLCODE THEN
            LET l_addr1 = ''
            LET l_addr2 = ''
            LET l_addr3 = ''
            LET l_addr4 = ''     #o.FUN-730014 
            LET l_addr5 = ''     #o.FUN-730014  
         END IF
         
 
#TQC-5B0127--add
 
      SELECT ima02,ima021,ima906 #FUN-650005 add ima02
        INTO l_ima02,l_ima021,l_ima906 #FUN-650005 add ima02
        FROM ima_file
       WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                  END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
           #IF sr.ogb910 <> sr.ogb916 THEN   #NO.TQC-6B0137 mark
            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
      LET l_donum = sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###'
      LET l_weight = sr.ogb12*sr.ima18
      LET l_note = l_str2 clipped
#TQC-5B0127--end
         #No.FUN-610020  --Begin 打印客戶驗退數量
         IF l_oga09 = '8' THEN
            SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
             WHERE oga01 = ogb01 AND oga011 = sr.oga011
               AND ogb03 = sr.ogb03 AND oga09 = '9'
            IF SQLCA.sqlcode = 0 THEN
               IF g_sma115 = "Y" THEN
                  CASE l_ima906
                     WHEN "2"
                         CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                         LET l_str3 = l_ogb915 , l_ogb.ogb913 CLIPPED
                         IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915 = 0 THEN
                             CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                             LET l_str3 = l_ogb912, l_ogb.ogb910 CLIPPED
                         ELSE
                            IF NOT cl_null(l_ogb.ogb912) AND l_ogb.ogb912 > 0 THEN
                               CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
                               LET l_str3 = l_str3 CLIPPED,',',l_ogb912, l_ogb.ogb910 CLIPPED
                            END IF
                           END IF
                     WHEN "3"
                         IF NOT cl_null(l_ogb.ogb915) AND l_ogb.ogb915 > 0 THEN
                             CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
                             LET l_str3 = l_ogb915 , l_ogb.ogb913 CLIPPED
                         END IF
                  END CASE
               END IF
               IF g_sma.sma116 MATCHES '[23]' THEN           #No.FUN-610076
                    #IF l_ogb.ogb910 <> l_ogb.ogb916 THEN    #No.TQC-6B0137 mark
                     IF l_ogb.ogb05  <> l_ogb.ogb916 THEN    #NO.TQC-6B0137 mod
                        CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
                        LET l_str3 = l_str3 CLIPPED,"(",l_ogb12,l_ogb.ogb05 CLIPPED,")"
                     END IF
               END IF
               LET l_str3=l_str3 CLIPPED,(21-LENGTH(l_str3 CLIPPED)) SPACES,l_ogb.ogb12 * -1 USING '---,---,--&.###'
            END IF
         END IF
         #No.FUN-610020  --End
         IF tm.a ='1' THEN
            CASE sr.ogb17 #多倉儲批出貨否 (Y/N)
               WHEN 'Y'
                  LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092,ogc03  FROM ogc_file ", #No.MOD-BB0031 add ogc03
                            " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
               WHEN 'N'
                  LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092,ogb03 FROM ogb_file", #No.MOD-BB0031 add ogb03 
                            " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
            END CASE
         ELSE
            LET l_sql=" SELECT img02,img03,img10,img04  FROM img_file ",
                      " WHERE img01= '",sr.ogb04,"' AND img04 ='",sr.ogb092,"'",
                      "   AND img10 > 0 "
         END IF
 
         PREPARE r601_p2 FROM l_sql
         DECLARE r601_c2 CURSOR FOR r601_p2
         LET i=1
         FOREACH r601_c2 INTO l_ogc.*
           LET l_loc = "(",l_ogc.ogc09 clipped
           IF l_ogc.ogc091 IS NOT NULL THEN
              LET l_loc = l_loc clipped,"/",l_ogc.ogc091 clipped
           END IF
           IF l_ogc.ogc092 IS NOT NULL THEN
              LET l_loc = l_loc clipped,"/",l_ogc.ogc092 clipped
           END IF
           LET l_loc = l_loc clipped,")"
           IF STATUS THEN EXIT FOREACH END IF
           IF tm.a ='1' THEN
              EXECUTE insert1 USING sr.oga01,i,l_loc,l_ogc.ogc16   
           ELSE  
            	EXECUTE insert1 USING sr.ogb04,i,l_loc,l_ogc.ogc16  
           END IF
           LET i = i+1
        END FOREACH
#No.FUN-5C0075--begin
        SELECT oaz23 INTO l_oaz23 FROM oaz_file
        IF l_oaz23 = 'Y'  AND tm.c = 'Y' THEN
            LET g_sql = "SELECT ogc12,ogc17 ",
                        "  FROM ogc_file",
                        " WHERE ogc01 = '",sr.oga01,"'"
         PREPARE ogc_prepare FROM g_sql
         DECLARE ogc_cs CURSOR FOR ogc_prepare
         LET i = 1
         FOREACH ogc_cs INTO g_ogc.*
            SELECT ima02 INTO l_ima02 FROM ima_file
             WHERE ima01 = g_ogc.ogc17 
             EXECUTE insert2 USING sr.oga01,i,g_ogc.ogc17,g_ogc.ogc12,l_ima02                
            LET i = i+1
         END FOREACH
         END IF
#No.FUN-5C0075--end           
#No.FUN-860026---begin                                                                                                              
    LET flag = 0                                                                                                                                 
    SELECT img09 INTO l_img09  FROM img_file,ogb_file                                                                               
               WHERE img01 = sr.ogb04                                                                                               
               AND img02 = ogb09 AND img03 = ogb091                                                                                 
               AND img04 = ogb092 AND ogb01 = sr.oga01                                                                              
               AND ogb03 = sr.ogb03                                                                                                 
    DECLARE r920_c  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = sr.oga01 AND rvbs02 = sr.ogb03                                                                     
                    AND rvbs00 <> 'aqct800' #MOD-BB0046 add
                  ORDER BY  rvbs04                                                                                                  
    FOREACH  r920_c INTO l_rvbs.*       
         LET flag = 1                                                                                            
         EXECUTE insert_prep3 USING  sr.oga01,sr.ogb03,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     l_ima02,l_ima021,sr.ogb05,sr.ogb12,                                                            
                                     l_img09                                                                                        
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end  
      #No.FUN-A80088  --start  列印額外品名規格說明
      IF tm.f = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM imc_file
             WHERE imc01=sr.ogb04 AND imc02=sr.ogb07
          IF l_count !=0  THEN
            DECLARE imc_cur CURSOR FOR
            SELECT * FROM imc_file    
              WHERE imc01=sr.ogb04 AND imc02=sr.ogb07 
            ORDER BY imc03                                        
            FOREACH imc_cur INTO sr1.*                            
              EXECUTE insert_prep4 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,sr.oga01,sr.ogb03
            END FOREACH
          END IF
       END IF    
       #No.FUN-A80088  --end
       EXECUTE insert_prep USING sr.oga01,sr.oga011,sr.oga02,sr.oga16,sr.oga021,sr.oga15,
                                 l_gem02,sr.oga032,sr.oga033,sr.oga45,sr.oga03,sr.oga04,
                                 sr.oga14,l_gen02,sr.occ02,l_addr1,
                                 l_addr2,l_addr3,sr.ogb03,sr.ogb04,l_donum,
                                 sr.ogb12,sr.ogb05,l_ima02,l_weight,sr.ogb19,
                                 l_ima021,l_note,l_str3,sr.ogb11,
                                 l_oga09,sr.oaydesc,flag,sr.ogb07,l_count,    #FUN-740057 add   #No.FUN-860026  add flag  #FUN-A80088 add sr.ogb07,l_count
                                  "",           l_img_blob,   "N",""    #TQC-C10039
                                                
     #OUTPUT TO REPORT axmr601_rep(sr.*)  #No.FUN-710090 mark
   END FOREACH
 
  #str FUN-740057 mark   #報表轉CR後g_x不用了,直接去CR組這個字串
  #IF l_oga09 = '7' THEN
  #   LET g_str = sr.oaydesc CLIPPED," ",g_x[26]
  #ELSE
  #   IF l_oga09 = '8' THEN
  #      LET g_str = sr.oaydesc CLIPPED," ",g_x[27]
  #   ELSE
  #   	 LET g_str = sr.oaydesc CLIPPED," ",g_x[1]
  #   END IF
  #END IF
  #end FUN-740057 mark
  
   LET g_str = '1' 
   IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'oga01,oga02')                                            
      RETURNING tm.wc 
   ELSE
      LET tm.wc = ''
   END IF 
   LET g_str = g_str CLIPPED,";",tm.wc
   LET g_str = g_str CLIPPED,";",tm.c,";",tm.d,";",l_oaz23 CLIPPED,";",l_oga09
#   LET g_str = g_str ,";",tm.e,";",tm.f,";",l_zo12   #FUN-740057 add #No.FUN-860026
 
   LET g_str = g_str ,";",tm.e,";",tm.f,";",l_zo12,";",tm.g,";",tm.h   #FUN-740057 add  #No.FUN-860026  #FUN-A80088 add tm.h
   LET g_msg=NULL
   IF g_oaz.oaz141 = "1" THEN
      CALL s_ccc_logerr() #FUN-650020
      LET g_oga01=sr.oga01 #FUN-650020
      CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
      IF r601_err_ana(g_showmsg) THEN
         
      END IF
      IF g_errno = 'N' THEN
         CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
      END IF
   END IF
#No.FUN-860026---begin
#   LET g_sql1= " SELECT A.*,B.i1,B.loc,B.ogc16,C.i2,C.ogc17,C.ogc12,C.ima02t ",
# #TQC-730088## "   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C",
#               "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A, ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B, ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C",
#               " WHERE A.oga01 = B.ogc01(+)",
#               " AND A.oga01 = C.ogc01(+)"
  LET g_sql1= " SELECT A.*,B.i1,B.loc,B.ogc16,C.i2,C.ogc17,C.ogc12,C.ima02t ",
              "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
              " B ON A.oga01 = B.ogc01 AND A.ogb03 = B.ogc03 LEFT OUTER JOIN " #No.MOD-BB0031 add  A.ogb03=B.ogc03
              ,g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON A.oga01 = C.ogc01 | ",
               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED ,"|",
               " SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED       #No.FUN-A80088 add
#No.FUN-860026---end
   LET g_cr_table = l_table                 #主報表的temp table名稱   #TQC-C10039
   #LET g_cr_gcx01 = "axmi010"               #單別維護程式   #TQC-C10039
   LET g_cr_apr_key_f = "oga01"       #報表主鍵欄位名稱   #TQC-C10039
 # CALL cl_prt_cs3('axmr601',g_sql1,g_str)      #TQC-730088
   CALL cl_prt_cs3('axmr601','axmr601',g_sql1,g_str)    
  #FINISH REPORT axmr601_rep   #No.FUN-710090 mark
  #No.FUN-710090--end--
 
   #FUN-650020...............begin
   IF g_show_msg.getlength()>0 THEN
      CALL cl_get_feldname("oga01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("oga03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
      CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
   END IF
   #FUN-650020...............end
 
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710090 mark
 
END FUNCTION
 
#No.FUN-710090--begin-- mark
#REPORT axmr601_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          sr           RECORD
#                          oga01     LIKE oga_file.oga01,
#                          oaydesc   LIKE oay_file.oaydesc,
#                          oga02     LIKE oga_file.oga02,
#                          oga021    LIKE oga_file.oga021,
#                          oga011    LIKE oga_file.oga011,
#                          oga14     LIKE oga_file.oga14,
#                          oga15     LIKE oga_file.oga15,
#                          oga16     LIKE oga_file.oga16,
#                          oga032    LIKE oga_file.oga032,
#                          oga03     LIKE oga_file.oga03,
#                          oga033    LIKE oga_file.oga033,  #統一編號
#                          oga45     LIKE oga_file.oga45,   #聯絡人
#                          occ02     LIKE occ_file.occ02,
#                          oga04     LIKE oga_file.oga04,
#                          oga044    LIKE oga_file.oga044,
#                          ogb03     LIKE ogb_file.ogb03,
#                          ogb31     LIKE ogb_file.ogb31,
#                          ogb32     LIKE ogb_file.ogb32,
#                          ogb04     LIKE ogb_file.ogb04,
#                          ogb092    LIKE ogb_file.ogb092,
#                          ogb05     LIKE ogb_file.ogb05,
#                          ogb12     LIKE ogb_file.ogb12,
#                          ogb06     LIKE ogb_file.ogb06,
#                          ogb11     LIKE ogb_file.ogb11,
#                          ogb17     LIKE ogb_file.ogb17,
#                          ogb19     LIKE ogb_file.ogb19,      #No.FUN-5C0075
#                          ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
#                          ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
#                          ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
#                          ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
#                          ogb916    LIKE ogb_file.ogb916,     #No.TQC-5B0127
#                          ima18     LIKE ima_file.ima18
#                       END RECORD,
#            l_ogc      RECORD
#                          ogc09     LIKE ogc_file.ogc09,
#                          ogc091    LIKE ogc_file.ogc091,
#                          ogc16     LIKE ogc_file.ogc16,
#                          ogc092    LIKE ogc_file.ogc092
#                       END RECORD,
#           #MOD-680081-begin
#           #l_buf      ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)
#           #l_buf3     ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)   #FUN-5A0143 add
#           #l_buf4     ARRAY[10] OF LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(46)   #FUN-5A0143 add
#           #l_buf2     ARRAY[10] OF LIKE ogc_file.ogc16,
#            l_buf   DYNAMIC  ARRAY OF LIKE type_file.chr1000,
#            l_buf3  DYNAMIC  ARRAY OF LIKE type_file.chr1000,
#            l_buf4  DYNAMIC  ARRAY OF LIKE type_file.chr1000,
#            l_buf2  DYNAMIC  ARRAY OF LIKE ogc_file.ogc16,
#           #MOD-680081-end
#            l_flag     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
#            l_addr1    LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(36)
#            l_addr2    LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(36)
#            l_addr3    LIKE aaf_file.aaf03,      # No.FUN-680137 VARCHAR(36)
#            l_gen02    LIKE gen_file.gen02,
#            l_oag02    LIKE oag_file.oag02,
#            l_gem02    LIKE gem_file.gem02,
#            l_ogb12    LIKE ogb_file.ogb12,
#            l_sql      LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(1000)
#            i,j,l_n    LIKE type_file.num5        #No.FUN-680137 SMALLINT
##No.FUN-580004--begin
#   DEFINE  l_ogb915    STRING
#   DEFINE  l_ogb912    STRING
#   DEFINE  l_str2      STRING
#   DEFINE  l_ima906    LIKE ima_file.ima906
#   DEFINE  l_ima021    LIKE ima_file.ima021 #TQC-5B0127
##No.FUN-580004--end
#   DEFINE  l_oga09     LIKE oga_file.oga09
#   DEFINE  l_ogb       RECORD LIKE ogb_file.*
##No.FUN-5C0075--begin
# DEFINE
##     g_ogg        RECORD
##                  ogg10 LIKE ogg_file.ogg10,
##                  ogg12 LIKE ogg_file.ogg12,
##                  ogg17 LIKE ogg_file.ogg17
##             END RECORD,
#      g_ogc        RECORD
#                   ogc12 LIKE ogc_file.ogc12,
#                   ogc17 LIKE ogc_file.ogc17
#              END RECORD,
#      l_oaz23  LIKE oaz_file.oaz23,
#      l_ima02  LIKE ima_file.ima02,
#      g_sql    LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
##No.FUN-5C0075--end
#
#   OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN 5
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.oga01,sr.ogb03
#
#   FORMAT
#      PAGE HEADER
#         LET g_pageno= g_pageno+1
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2)+1,g_company CLIPPED           #No.FUN-580004
#         PRINT g_x[11] CLIPPED,sr.oga01 CLIPPED,
#               COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#         #No.FUN-610020  -Begin
#         SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
#         IF l_oga09 = '7' THEN
#               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
#                     ((g_len-FGL_WIDTH(g_x[26]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[26]
#         ELSE
#            IF l_oga09 = '8' THEN
#               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
#                     ((g_len-FGL_WIDTH(g_x[27]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[27]
#            ELSE
#               PRINT COLUMN 10,sr.oaydesc  CLIPPED,
#                     ((g_len-FGL_WIDTH(g_x[1]))/2-FGL_WIDTH(sr.oaydesc)-10) SPACES,g_x[1]
#            END IF
#         END IF
#         #No.FUN-610020  -End
#         LET g_msg=NULL
#         IF g_oaz.oaz141 = "1" THEN
#            CALL s_ccc_logerr() #FUN-650020
#            LET g_oga01=sr.oga01 #FUN-650020
#            CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
#            #FUN-650020...............begin
#            IF r601_err_ana(g_showmsg) THEN
#               
#            END IF
#            #FUN-650020...............end
#            IF g_errno = 'N' THEN
#               CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
#            END IF
#         END IF
#         PRINT g_msg CLIPPED
#         LET l_last_sw = 'n'                    #FUN-550127
#
#      BEFORE GROUP OF sr.oga01
#         SKIP TO TOP OF PAGE
#
#         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
#         IF STATUS THEN
#            LET l_gen02 = ''
#         END IF
#
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
#         IF STATUS THEN
#            LET l_gem02 = ''
#         END IF
#
#         CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
#              RETURNING l_addr1,l_addr2,l_addr3
#         IF SQLCA.SQLCODE THEN
#            LET l_addr1 = ''
#            LET l_addr2 = ''
#            LET l_addr3 = ''
#         END IF
#
#         PRINT g_x[12] CLIPPED,sr.oga02 CLIPPED,
#               COLUMN 28,g_x[13] CLIPPED,sr.oga032 CLIPPED,sr.oga033 CLIPPED, ##TQC-5B0110&051112 ##
#               sr.oga45 CLIPPED,##sr.oga032 CLIPPED,
#               COLUMN 71,'(',sr.oga03 CLIPPED,')'
#         PRINT g_x[14] CLIPPED,sr.oga021,
#               COLUMN 28,g_x[15] CLIPPED,sr.occ02 CLIPPED, ##TQC-5B0110&051112 ##
#               COLUMN 71,'(',sr.oga04 CLIPPED,')'
#         PRINT g_x[16] CLIPPED,sr.oga011,
#               COLUMN 28,g_x[17] CLIPPED,l_addr1 ##TQC-5B0110&051112 ##
#         PRINT g_x[18] CLIPPED,sr.oga16,
#               COLUMN 35,l_addr2
#         PRINT g_x[19] CLIPPED,l_gen02 CLIPPED,
#               COLUMN 28,g_x[20] CLIPPED,l_gem02 CLIPPED, #MOD-560074 19->26 ##TQC-5B0110&051112 ##
#               COLUMN 35,l_addr3
#
#         IF tm.b = 'Y'  THEN     #列印備註於表頭
#            CALL r601_oao(sr.oga01,0,'1')
#            FOR l_n = 1 TO 40
#               IF NOT cl_null(g_m[l_n]) THEN
#                  PRINT g_m[l_n]  CLIPPED
#               ELSE
#                  LET l_n = 40
#               END IF
#            END FOR
#         END IF
#
#         PRINT g_dash[1,g_len]
##no.FUN-550070-begin
##no.FUN-580004--begin
#         #FUN-650005...............begin
#         #FUN-5A0143 add
#         #PRINTX name = H1 g_x[31],g_x[32],g_x[35],g_x[36],g_x[38],g_x[40]
#         #PRINTX name = H2 g_x[39],g_x[51],g_x[37],g_x[47],g_x[48],g_x[52]    #No.FUN-5C0075
#         #PRINTX name = H3 g_x[43],g_x[33],g_x[34]
#         #PRINTX name = H4 g_x[50],g_x[41]
#         #FUN-5A0143 end
#         PRINTX name = H1 g_x[31],g_x[32],g_x[52],g_x[35],g_x[36],g_x[40]
#         PRINTX name = H2 g_x[39],g_x[33],g_x[34]
#         PRINTX name = H3 g_x[43],g_x[41]
#         PRINTX name = H4 g_x[50],g_x[51]
#        #FUN-690032 --begin
#         PRINTX name = H5 g_x[55],g_x[56]
#        #H5->H6 
#        #PRINTX name = H5 g_x[53],g_x[54],g_x[37],g_x[47],g_x[48],g_x[38]
#         PRINTX name = H6 g_x[53],g_x[54],g_x[37],g_x[47],g_x[48],g_x[38]
#        #FUN-690032 --end 
#        #FUN-650005...............end
#         PRINT g_dash1
##no.FUN-580004--end
#
#      ON EVERY ROW
#        #MOD-680081-begin-add
#         #FOR i = 1 TO 10
#         #    INITIALIZE l_buf[i]  TO NULL
#         #    INITIALIZE l_buf2[i] TO NULL
#         #    INITIALIZE l_buf3[i] TO NULL   #FUN-5A0143 add
#         #    INITIALIZE l_buf4[i]  TO NULL  #FUN-5A0143 add
#         #END FOR
#          CALL l_buf.clear()
#          CALL l_buf2.clear()
#          CALL l_buf3.clear()
#          CALL l_buf4.clear()
#        #MOD-680081-end-add
#
#         IF tm.a ='1' THEN
#            CASE sr.ogb17 #多倉儲批出貨否 (Y/N)
#               WHEN 'Y'
#                  LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
#                            " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
#               WHEN 'N'
#                  LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file",
#                            " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
#            END CASE
#         ELSE
#            LET l_sql=" SELECT img02,img03,img10,img04  FROM img_file ",
#                      " WHERE img01= '",sr.ogb04,"' AND img04 ='",sr.ogb092,"'",
#                      "   AND img10 > 0 "
#         END IF
#
#         PREPARE r601_p2 FROM l_sql
#         DECLARE r601_c2 CURSOR FOR r601_p2
#         #FUN-650005...............begin  #本段移到下面去做
#         #LET i = 1
#         #FOREACH r601_c2 INTO l_ogc.*
#         #   IF STATUS THEN EXIT FOREACH END IF
#         #   LET l_buf[i][ 1,10]=l_ogc.ogc09  #FUN-5A0143 add
#         #   LET l_buf3[i]=l_ogc.ogc091       #FUN-5A0143add
#         #   LET l_buf4[i]=l_ogc.ogc092       #FUN-5A0143add
#         #   LET l_buf2[i]=l_ogc.ogc16
#         #   LET i=i+1
#         #   IF i > 10 THEN LET i=10 EXIT FOREACH END IF
#         #END FOREACH
#         #FUN-650005...............end
#         IF tm.b = 'Y'  THEN     #列印備註於單身前
#            CALL r601_oao(sr.oga01,sr.ogb03,'1')
#            FOR l_n = 1 TO 40
#               IF NOT cl_null(g_m[l_n]) THEN
#                  PRINT g_m[l_n]  CLIPPED
#               ELSE
#                  LET l_n = 40
#               END IF
#            END FOR
#         END IF
##TQC-5B0127--add
#
#      SELECT ima02,ima021,ima906 #FUN-650005 add ima02
#        INTO l_ima02,l_ima021,l_ima906 #FUN-650005 add ima02
#        FROM ima_file
#       WHERE ima01=sr.ogb04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
#                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
#                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
#                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
#                   END IF
#                  END IF
#            WHEN "3"
#                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
#                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
#                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#           #IF sr.ogb910 <> sr.ogb916 THEN   #NO.TQC-6B0137 mark
#            IF sr.ogb05  <> sr.ogb916 THEN   #No.TQC-6B0137 mod
#               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
#               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
#            END IF
#      END IF
##TQC-5B0127--end
#
##no.FUN-570176--start--
##no.FUN-580004--begin
#         #FUN-5A0143 add
#         PRINTX name = D1
#               #FUN-650005...............begin
#               #COLUMN g_c[31],sr.ogb03 USING '####',
#               #COLUMN g_c[32],sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###',
#               #COLUMN g_c[35],sr.ogb05,
#               #COLUMN g_c[36],sr.ogb12 USING '###,###,##&.###',
#               #COLUMN g_c[38],l_buf2[1] USING '###,###,##&.###',
#               #COLUMN g_c[40],sr.ima18*sr.ogb12 USING '#####.###'
#               COLUMN g_c[31],cl_numfor(sr.ogb03,31,0),
#               COLUMN g_c[32],sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###',
#               COLUMN g_c[52],sr.ogb19,
#               COLUMN g_c[35],sr.ogb05,
#               COLUMN g_c[36],cl_numfor(sr.ogb12,36,3),
#               COLUMN g_c[40],cl_numfor(sr.ima18*sr.ogb12,40,3)
#               #FUN-650005...............end
#         #FUN-5A0143 end
#         #FUN-5A0143 add
#         PRINTX name = D2
#               #FUN-650005...............begin
#               #COLUMN g_c[39], '',
#               #COLUMN g_c[37],l_buf[1] CLIPPED,
#               #COLUMN g_c[47],l_buf3[1] CLIPPED,
#               #COLUMN g_c[48],l_buf4[1] CLIPPED,
#               #COLUMN g_c[52],sr.ogb19
#                COLUMN g_c[33],sr.ogb04 CLIPPED,
#                COLUMN g_c[34],l_str2 CLIPPED
#               #FUN-650005...............end
#         #FUN-5A0143 end
#         #FUN-5A0143 add
#         PRINTX name = D3
#              #FUN-650005...............begin
#              #COLUMN g_c[33],sr.ogb04 CLIPPED,
#              #COLUMN g_c[34],l_str2 CLIPPED
#               COLUMN g_c[41],l_ima02 CLIPPED
#              #FUN-650005...............end
#         PRINTX name = D4
#              #FUN-650005...............begin
#              #COLUMN g_c[41],sr.ogb06 CLIPPED
#              COLUMN g_c[51],l_ima021 CLIPPED
#              #FUN-650005...............end
#
#         PRINTX name = D5 COLUMN g_c[56],sr.ogb11 CLIPPED  #FUN-690032 add
#
#         #FUN-650005...............begin     
#         #FOR j = 3 TO i
#         #    PRINTX name = D2
#         #          COLUMN g_c[37],l_buf[j] CLIPPED,
#         #          COLUMN g_c[47],l_buf3[j] CLIPPED,
#         #          COLUMN g_c[48],l_buf4[j] CLIPPED
#         #    PRINTX name = D1
#         #          COLUMN g_c[38],l_buf2[j] USING '###,###,##&.###'
#         ##FUN-5A0143 end
#         #END FOR
#          LET i=0
#          FOREACH r601_c2 INTO l_ogc.*
#             IF STATUS THEN EXIT FOREACH END IF
#            
#            #FUN-690032 D5->D6
#            #PRINTX name = D5
#             PRINTX name = D6
#                   COLUMN g_c[37],l_ogc.ogc09,
#                   COLUMN g_c[47],l_ogc.ogc091,
#                   COLUMN g_c[48],l_ogc.ogc092,
#                   COLUMN g_c[38],cl_numfor(l_ogc.ogc16,38,3)
#             LET i=i+1
#            #IF i > 10 THEN LET i=10 EXIT FOREACH END IF   #MOD-680081 add
#          END FOREACH         
#         #FUN-650005...............end
##no.FUN-580004--end
#         #No.FUN-610020  --Begin 打印客戶驗退數量
#         IF l_oga09 = '8' THEN
#            SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
#             WHERE oga01 = ogb01 AND oga011 = sr.oga011
#               AND ogb03 = sr.ogb03 AND oga09 = '9'
#            IF SQLCA.sqlcode = 0 THEN
#               IF g_sma115 = "Y" THEN
#                  CASE l_ima906
#                     WHEN "2"
#                         CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
#                         LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
#                         IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915 = 0 THEN
#                             CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
#                             LET l_str2 = l_ogb912, l_ogb.ogb910 CLIPPED
#                         ELSE
#                            IF NOT cl_null(l_ogb.ogb912) AND l_ogb.ogb912 > 0 THEN
#                               CALL cl_remove_zero(l_ogb.ogb912) RETURNING l_ogb912
#                               LET l_str2 = l_str2 CLIPPED,',',l_ogb912, l_ogb.ogb910 CLIPPED
#                            END IF
#                           END IF
#                     WHEN "3"
#                         IF NOT cl_null(l_ogb.ogb915) AND l_ogb.ogb915 > 0 THEN
#                             CALL cl_remove_zero(l_ogb.ogb915) RETURNING l_ogb915
#                             LET l_str2 = l_ogb915 , l_ogb.ogb913 CLIPPED
#                         END IF
#                  END CASE
#               END IF
#               IF g_sma.sma116 MATCHES '[23]' THEN           #No.FUN-610076
#                    #IF l_ogb.ogb910 <> l_ogb.ogb916 THEN    #No.TQC-6B0137 mark
#                     IF l_ogb.ogb05  <> l_ogb.ogb916 THEN    #NO.TQC-6B0137 mod
#                        CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
#                        LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,l_ogb.ogb05 CLIPPED,")"
#                     END IF
#               END IF
#               LET l_str2=l_str2 CLIPPED,(21-LENGTH(l_str2 CLIPPED)) SPACES,l_ogb.ogb12 * -1 USING '---,---,--&.###'
#               PRINTX name = D3
#                     COLUMN g_c[33],g_x[28] CLIPPED,
#                     COLUMN g_c[34],l_str2 CLIPPED
#               PRINTX name = D2
#                     COLUMN g_c[37],l_ogb.ogb09,
#                     COLUMN g_c[47],l_ogb.ogb091,
#                     COLUMN g_c[48],l_ogb.ogb092
#            END IF
#         END IF
#         #No.FUN-610020  --End
#
##No.FUN-5C0075--begin
#            SELECT oaz23 INTO l_oaz23 FROM oaz_file
#            IF l_oaz23 = 'Y' AND tm.c = 'Y' THEN
#              PRINTX name = S1
#                    COLUMN g_c[32],g_x[23],
#                    COLUMN g_c[36],g_x[24]
#            END IF
#            IF l_oaz23 = 'Y'  AND tm.c = 'Y' THEN
#               LET g_sql = "SELECT ogc12,ogc17 ",
#                           "  FROM ogc_file",
#                           " WHERE ogc01 = '",sr.oga01,"'"
#            PREPARE ogc_prepare FROM g_sql
#            DECLARE ogc_cs CURSOR FOR ogc_prepare
#            FOREACH ogc_cs INTO g_ogc.*
#               SELECT ima02 INTO l_ima02 FROM ima_file
#                WHERE ima01 = g_ogc.ogc17
#               PRINTX name = D1
#                     COLUMN g_c[32],g_ogc.ogc17,
#                     COLUMN g_c[36],g_ogc.ogc12 USING '###,###,##&.###'
#               PRINTX name = D1
#                     COLUMN g_c[32],l_ima02
#            END FOREACH
#            END IF
##No.FUN-5C0075--end
##no.FUN-570176--end--
#         IF tm.b = 'Y'  THEN     #列印備註於單身後
#            CALL r601_oao(sr.oga01,sr.ogb03,'2')
#            FOR l_n = 1 TO 40
#               IF NOT cl_null(g_m[l_n]) THEN
#                  PRINT g_m[l_n] CLIPPED
#               ELSE
#                  LET l_n = 40
#               END IF
#            END FOR
#         END IF
#
#      AFTER GROUP OF sr.oga01
#         LET l_ogb12= GROUP SUM(sr.ogb12)
##no.FUN-580004--begin
#         #PRINT  COLUMN g_c[36],'---------------',COLUMN g_c[40],'--------------------' #FUN-650005
#         #PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],COLUMN g_c[40],g_dash2[1,g_w[40]] #FUN-650005
##no.FUN-570176--start--
#         #FUN-5A0143 add
#         PRINTX name = D1 COLUMN g_c[35],g_x[21] CLIPPED,
#                          COLUMN g_c[36],l_ogb12 USING '###,###,##&.###',
#                          COLUMN g_c[40]-7,g_x[22] ClIPPED,
#                          COLUMN g_c[40],GROUP SUM(sr.ima18*sr.ogb12) USING '#####.###';
#         #FUN-5A0143 end
##no.FUN-580004--end
##no.FUN-570176--end--
##no.FUN-550070-end
# 
#         PRINT ''
#         IF tm.b = 'Y'  THEN     #列印備註於表尾
#            CALL r601_oao(sr.oga01,0,'2')
#            FOR l_n = 1 TO 40
#                IF NOT cl_null(g_m[l_n]) THEN
#                   PRINT g_m[l_n] CLIPPED
#                ELSE
#                   LET l_n = 40
#                END IF
#            END FOR
#         END IF
### FUN-550127
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
##     PRINT g_x[4] CLIPPED,COLUMN 41,g_x[5]
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#         ELSE
#            PRINT
#            PRINT
#         END IF
#      ELSE
#         PRINT g_x[4]
#         PRINT g_memo
#      END IF
### END FUN-550127
#
#END REPORT
#No.FUN-710090--end-- mark
 
FUNCTION r601_oao(l_p1,l_p3,l_p5)
   DEFINE l_p1   LIKE oao_file.oao01,
          l_p3   LIKE oao_file.oao03,
          l_p5   LIKE oao_file.oao05,
          l_n    LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   FOR l_n = 1 TO 40
      LET g_m[l_n] = ''
   END FOR
 
   DECLARE r601_c5 CURSOR FOR SELECT oao06 FROM oao_file
                               WHERE oao01 = l_p1
                                 AND oao03 = l_p3
                                 AND oao05 = l_p5
 
   LET l_n = 1
 
   FOREACH r601_c5 INTO g_m[l_n]
      LET l_n = l_n + 1
   END FOREACH
 
END FUNCTION
 
FUNCTION r601_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oga03    LIKE oga_file.oga03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5        # No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oga03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=lc_oga03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oga01   = g_oga01
   LET g_show_msg[li_newerrno].oga03   = lc_oga03
   LET g_show_msg[li_newerrno].occ02   = lc_occ02
   LET g_show_msg[li_newerrno].occ18   = lc_occ18
   LET g_show_msg[li_newerrno].ze01    = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03    = ls_showmsg.trim(),ls_tmpstr.trim()
   #kim test
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
#Patch....NO.TQC-610037 <> #

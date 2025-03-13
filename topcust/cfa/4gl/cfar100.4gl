# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: cfar100.4gl
# Descriptions...: 資產底稿資料清單
# Date & Author..: 96/06/13 By Lynn
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin 以za_file方式取代PRINT中文字的部份  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   TYPE type_faj_file RECORD 
               pmm04_o    LIKE pmm_file.pmm04,
               pmc03_o    LIKE pmc_file.pmc03,
               faj02_o    LIKE faj_file.faj02,
               faj26_o    LIKE faj_file.faj26,
               rvu01_o    LIKE rvu_file.rvu01,
               rvv02_o    LIKE rvv_file.rvv02,
               apa01_o    LIKE apa_file.apa01,
               pmm01      LIKE pmm_file.pmm01,
               pmm04      LIKE pmm_file.pmm04,
               pmm09      LIKE pmm_file.pmm09,
               pmc03      LIKE pmc_file.pmc03,
               pmn02      LIKE pmn_file.pmn02,
               pmn04      LIKE pmn_file.pmn04,
               ima02      LIKE ima_file.ima02,
               ima021     LIKE ima_file.ima021,
               pmn20      LIKE pmn_file.pmn20,
               #TAG:入库
               rvu00      LIKE rvu_file.rvu00,
               rvu01      LIKE rvu_file.rvu01,
               rvu03      LIKE rvu_file.rvu03,
               rvv02      LIKE rvv_file.rvv02,
               rvv17      LIKE rvv_file.rvv17,
               rvv38      LIKE rvv_file.rvv38,
               rvv39      LIKE rvv_file.rvv39,
               #TAG:入库
               #TAG:固资
               faj02      LIKE faj_file.faj02,
               faj06      LIKE faj_file.faj06,
               faj04      LIKE faj_file.faj04,
               faj43      LIKE faj_file.faj43,
               faj26      LIKE faj_file.faj26,
               faj20      LIKE faj_file.faj20,
               faj52      LIKE faj_file.faj52,
               faj14      LIKE faj_file.faj14,
               #TAG:固资
               #TAG:预付
               apa01      LIKE apa_file.apa01,
               apa02      LIKE apa_file.apa02,
               apa31      LIKE apa_file.apa31,
               apa44      LIKE apa_file.apa44,
               #TAG:预付
               #TAG:请款
               apa01_1    LIKE apa_file.apa01,
               apa02_1    LIKE apa_file.apa02,
               apa08_1    LIKE apa_file.apa08,
               apa31_1    LIKE apa_file.apa31,
               apa32_1    LIKE apa_file.apa32,
               apa44_1    LIKE apa_file.apa44,
               apb02_1    LIKE apb_file.apb02,
               apb10_1    LIKE apb_file.apb10,
               #TAG:请款
               #TAG:付款
               apf01      LIKE apf_file.apf01,
               apf02      LIKE apf_file.apf02,
               apf44      LIKE apf_file.apf44,
               apg05      LIKE apg_file.apg05,
               #TAG:付款
               #TAG:暂估
               apa01_2    LIKE apa_file.apa01,
               apa02_2    LIKE apa_file.apa02,
               apa44_2    LIKE apa_file.apa44,
               apb10_2    LIKE apb_file.apb10
               #TAG:暂估
   END RECORD

    DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,    # Where condition       #No.FUN-680070 VARCHAR(1000)
              s       LIKE type_file.chr4,          # Order by sequence       #No.FUN-680070 VARCHAR(3) 
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt       #No.FUN-680070 VARCHAR(14)
          g_tot_bal LIKE type_file.num20_6,      # User defined variable       #No.FUN-680070 DECIMAL(20,6)
          g_k     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_str           STRING                  #No.FUN-770033                                                                  
DEFINE   l_table         STRING                  #No.FUN-770033
DEFINE   g_sql           STRING                  #No.FUN-770033
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("cfa")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
#No.FUN-770033--start--                                                                                                             
    LET g_sql= "pmm04_o.pmm_file.pmm04,",
               "pmc03_o.pmc_file.pmc03,",
               "faj02_o.faj_file.faj02,",
               "faj26_o.faj_file.faj26,",
               "rvu01_o.rvu_file.rvu01,",
               "rvv02_o.rvv_file.rvv02,",
               "apa01_o.apa_file.apa01,",
               "pmm01.pmm_file.pmm01,",
               "pmm04.pmm_file.pmm04,",
               "pmm09.pmm_file.pmm09,",
               "pmc03.pmc_file.pmc03,",
               "pmn02.pmn_file.pmn02,",
               "pmn04.pmn_file.pmn04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "pmn20.pmn_file.pmn20,",
               "rvu00.rvu_file.rvu00,",
               "rvu01.rvu_file.rvu01,",
               "rvu03.rvu_file.rvu03,",
               "rvv02.rvv_file.rvv02,",
               "rvv17.rvv_file.rvv17,",
               "rvv38.rvv_file.rvv38,",
               "rvv39.rvv_file.rvv39,",
               "faj02.faj_file.faj02,",
               "faj06.faj_file.faj06,",
               "faj04.faj_file.faj04,",
               "faj43.faj_file.faj43,",
               "faj26.faj_file.faj26,",
               "faj20.faj_file.faj20,",
               "faj52.faj_file.faj52,",
               "faj14.faj_file.faj14,",
               "apa01.apa_file.apa01,",
               "apa02.apa_file.apa02,",
               "apa31.apa_file.apa31,",
               "apa44.apa_file.apa44,",
               "apa01_1.apa_file.apa01,",
               "apa02_1.apa_file.apa02,",
               "apa08_1.apa_file.apa08,",
               "apa31_1.apa_file.apa31,",
               "apa32_1.apa_file.apa32,",
               "apa44_1.apa_file.apa44,",
               "apb02_1.apb_file.apb02,",
               "apb10_1.apb_file.apb10,",
               "apf01.apf_file.apf01,",
               "apf02.apf_file.apf02,",
               "apf44.apf_file.apf44,",
               "apg05.apg_file.apg05,",
               "apa01_2.apa_file.apa01,",
               "apa02_2.apa_file.apa02,",
               "apa44_2.apa_file.apa44,",
               "apb10_2.apb_file.apb10"                                                                                  
                                                                                                                                    
     LET l_table = cl_prt_temptable('cfar100',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
               "        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
               "        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,? ,?)"                                                                                     
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF                                                                                                                          
#No.FUN-770033--end-- 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)  
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL cfar100_tm(0,0)        # Input print condition
      ELSE CALL cfar100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION cfar100_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
   DEFINE   l_faa02b      LIKE faa_file.faa02b         #No.TQC-780067
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW cfar100_w AT p_row,p_col WITH FORM "cfa/42f/cfar100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '4321' 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]  
   LET tm2.s3   = tm.s[3,3]  
   LET tm2.s4   = tm.s[4,4]  

   CALL r100_set_comp()
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON pmn01,pmm09,faj02,faj26,faj20,pmm04,pmn04,faj04,faj43


         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
#No.TQC-780067--begin
      ON ACTION controlp
         CASE
           WHEN INFIELD(pmn01) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_pmm01_1'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn01
              NEXT FIELD pmn01 
            #pmn01,pmm09,faj02,pmm04,faj20 

            WHEN INFIELD(faj02) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_faj02_1'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj02
              NEXT FIELD faj02 
            
            WHEN INFIELD(faj20) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_faj20'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj20
              NEXT FIELD faj20

            WHEN INFIELD(pmn04) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_ima'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn04
              NEXT FIELD pmn04

            WHEN INFIELD(pmn09) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_pmc01_1'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn09
              NEXT FIELD pmn09

           OTHERWISE EXIT CASE
          END CASE 
#No.TQC-780067--end
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
      ON ACTION cancel
         EXIT PROGRAM
 
      END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW cfar100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
     #DISPLAY BY NAME tm.s,tm.t,tm.sum,tm.more
                     # Condition
 
         INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
            AFTER FIELD more
               IF tm.more NOT MATCHES "[YN]" THEN
                  NEXT FIELD FORMONLY.more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
 
           #-----MOD-640006---------
           AFTER INPUT
              LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1]
           #-----END MOD-640006-----
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()    # Command execution
#           ON ACTION CONTROLP CALL cfar100_wc()   # Input detail Where Condition
 
            #-----MOD-640006---------
            #ON ACTION CONTROLT
            #   LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            #   LET tm.t = tm2.t1,tm2.t2
            #-----END MOD-640006-----
 
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
         LET INT_FLAG = 0 CLOSE WINDOW cfar100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='cfar100'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('cfar100','9031',1)
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
                            " '",tm.s CLIPPED,"'", 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('cfar100',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW cfar100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL cfar100()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW cfar100_w
END FUNCTION

FUNCTION r100_cursor()
   DEFINE l_sql      STRING 

   #NOTE:固资编号
   LET l_sql = "SELECT faj02,faj06,faj04,faj43,faj26,faj20,faj52,faj14 
                  FROM faj_file WHERE faj47 = ? AND faj471=? AND fajconf ='Y' "
   PREPARE r100_i100 FROM l_sql 
   DECLARE r100_i100_d CURSOR FOR r100_i100
   #NOTE:预付
   LET l_sql = "SELECT UNIQUE apa01,apa02,apa31,apa44 FROM apa_file,apb_file
               WHERE apa01 = apb01 AND apa41='Y'  AND apa00='15'
               AND apb06 = ? "
   PREPARE r100_t150 FROM l_sql 
   DECLARE r100_t150_d CURSOR FOR r100_t150
   #NOTE:入库单
   LET l_sql ="SELECT rvu00,rvu01,rvu03,rvv02,
               CASE rvu00 WHEN '1' THEN rvv17 ELSE -1*rvv17 END rvv17,
               CASE rvu00 WHEN '1' THEN rvv38 ELSE -1*rvv38 END rvv38,
               CASE rvu00 WHEN '1' THEN rvv39 ELSE -1*rvv39 END rvv39  FROM rvv_file,rvu_file                
               WHERE rvu01 =rvv01 AND rvuconf ='Y'
               AND rvv36 = ? AND rvv37 = ? "
   PREPARE r100_t720 FROM l_sql
   DECLARE r100_t720_d CURSOR FOR r100_t720 
   #NOTE:暂估单
   LET l_sql = "SELECT apa01,apa02,apa44,apb10 FROM apa_file,apb_file
                WHERE apa01=apb01 AND apa41 ='Y' AND apa00='16'
                AND apb21 = ? AND apb22= ? "
   PREPARE r100_t160 FROM l_sql
   DECLARE r100_t160_d CURSOR FOR r100_t160
   #NOTE:请款单
   LET l_sql = "SELECT apa01,apa02,apa08,apa31,apa32,apa44,apb02,apb10 FROM apa_file,apb_file
                WHERE apa01=apb01 AND apa41 ='Y' AND apa00='11'
                AND apb21 = ? AND apb22= ? "
   PREPARE r100_t110 FROM l_sql
   DECLARE r100_t110_d CURSOR FOR r100_t110
   #NOTE:付款单
   LET l_sql = "SELECT apf01,apf02,apf44,apg05 FROM apg_file,apf_file
                WHERE apg01 = apf01 AND apf41 ='Y' 
                AND apg04 = ? "
   PREPARE r100_t330 FROM l_sql 
   DECLARE r100_t330_d CURSOR FOR r100_t330

END FUNCTION
 
FUNCTION cfar100()
   DEFINE l_name    LIKE type_file.chr20,
          l_sql     LIKE type_file.chr1000,
          l_chr     LIKE type_file.chr1,
          l_za05    LIKE type_file.chr1000,
          l_order   ARRAY[5] OF LIKE fak_file.fak53,
          sr        RECORD
                  pmm01      LIKE pmm_file.pmm01,
                  pmm04      LIKE pmm_file.pmm04,
                  pmm09      LIKE pmm_file.pmm09,
                  pmc03      LIKE pmc_file.pmc03,
                  pmn02      LIKE pmn_file.pmn02,
                  pmn04      LIKE pmn_file.pmn04,
                  ima02      LIKE ima_file.ima02,
                  ima021     LIKE ima_file.ima021,
                  pmn20      LIKE pmn_file.pmn20
               END RECORD,
          l_faj     DYNAMIC ARRAY OF type_faj_file,
          l_t160_t  RECORD
                  apa01_2    LIKE apa_file.apa01,
                  apa02_2    LIKE apa_file.apa02,
                  apa44_2    LIKE apa_file.apa44,
                  apb10_2    LIKE apb_file.apb10
                  END RECORD,
          l_t720_t   RECORD
                  rvu00      LIKE rvu_file.rvu00,
                  rvu01      LIKE rvu_file.rvu01,
                  rvu03      LIKE rvu_file.rvu03,
                  rvv02      LIKE rvv_file.rvv02,
                  rvv17      LIKE rvv_file.rvv17,
                  rvv38      LIKE rvv_file.rvv38,
                  rvv39      LIKE rvv_file.rvv39
                  END RECORD,
          l_t110_t RECORD
                  apa01_1    LIKE apa_file.apa01,
                  apa02_1    LIKE apa_file.apa02,
                  apa08_1    LIKE apa_file.apa08,
                  apa31_1    LIKE apa_file.apa31,
                  apa32_1    LIKE apa_file.apa32,
                  apa44_1    LIKE apa_file.apa44,
                  apb02_1    LIKE apb_file.apb02,
                  apb10_1    LIKE apb_file.apb10
                  END RECORD,
          l_t330_t RECORD
                  apf01      LIKE apf_file.apf01,
                  apf02      LIKE apf_file.apf02,
                  apf44      LIKE apf_file.apf44,
                  apg05      LIKE apg_file.apg05
                  END RECORD
   DEFINE l_gen02  LIKE gen_file.gen02
   DEFINE l_pmc03  LIKE pmc_file.pmc03
   DEFINE l_cnt    LIKE type_file.num5  #一笔采购单的遍历下标
   DEFINE i,j,k,l,m,n    LIKE type_file.num5
   DEFINE l_i100,l_t150,l_t720,l_t160,l_t160_i,l_t110,l_t110_i,l_t330,l_t330_i LIKE type_file.num5
   DEFINE l_t160_s DYNAMIC ARRAY OF INTEGER #保存暂估单项次 
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL cl_del_data(l_table) 

   CALL r100_cursor()                                   

   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')
   #TODO:采购明细
   LET l_sql = "SELECT pmm01,pmm04,pmm09,pmc03,pmn02,pmn04,ima02,ima021,pmn20
                  FROM pmn_file,pmm_file ,faj_file ,pmc_file,ima_file
                 WHERE pmm01 = pmn01 AND pmm18 ='Y' and pmc01 = pmm09  AND ima01 = pmn04
                   AND faj47 = pmn01 AND faj471=pmn02 AND ",tm.wc 
   PREPARE cfar100_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE cfar100_curs1 CURSOR FOR cfar100_prepare1
 
   FOREACH cfar100_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #TAG: 固资编号前处理
      CALL l_faj.clear()
      LET l_i100 = 0
      LET l_t150 = 0
      LET l_t720 = 0
      LET l_t160 = 0
      LET l_t110 = 0
      LET l_t330 = 0
      LET l_cnt = 1
      #DONE:固资编号
      FOREACH r100_i100_d USING  sr.pmm01,sr.pmn02
        INTO l_faj[l_cnt].faj02,l_faj[l_cnt].faj06,l_faj[l_cnt].faj04,l_faj[l_cnt].faj43,l_faj[l_cnt].faj26,l_faj[l_cnt].faj20,l_faj[l_cnt].faj52,l_faj[l_cnt].faj14
         IF STATUS THEN 
            CALL cl_err("r100_i100_d","!",1)
            RETURN
         END IF 

         #TAG: 排序字段都有值
         LET l_faj[l_cnt].pmm04_o = sr.pmm04
         LET l_faj[l_cnt].pmc03_o = sr.pmc03
         LET l_faj[l_cnt].faj02_o = l_faj[l_cnt].faj02
         LET l_faj[l_cnt].faj26_o = l_faj[l_cnt].faj26
         #TAG:只有第一笔,不可能没有
         IF l_cnt = 1 THEN 
            LET l_faj[l_cnt].pmm01 = sr.pmm01
            LET l_faj[l_cnt].pmm04 = sr.pmm04
            LET l_faj[l_cnt].pmm09 = sr.pmm09
            LET l_faj[l_cnt].pmc03 = sr.pmc03
            LET l_faj[l_cnt].pmn02 = sr.pmn02
            LET l_faj[l_cnt].pmn04 = sr.pmn04
            LET l_faj[l_cnt].ima02 = sr.ima02
            LET l_faj[l_cnt].ima021 =sr.ima021
            LET l_faj[l_cnt].pmn20 = sr.pmn20
         END IF 
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_faj.deleteElement(l_cnt)
      LET l_i100 = l_cnt - 1 #固定资产笔数
      LET l_cnt = 1
      #DONE:预付
      FOREACH r100_t150_d USING sr.pmm01 INTO l_faj[l_cnt].apa01,l_faj[l_cnt].apa02,l_faj[l_cnt].apa31,l_faj[l_cnt].apa44
         IF STATUS THEN
            CALL cl_err("r100_t150_d","!",1)
            RETURN
         END IF
         IF l_cnt > l_i100 THEN 
            #超过最大长度,需要给采购信息，不关联固资和采购项次
            LET l_faj[l_cnt].pmm04_o = sr.pmm04
            LET l_faj[l_cnt].pmc03_o = sr.pmc03
         END IF 
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_faj.deleteElement(l_cnt)
      LET l_t150 = l_cnt -1
      # IF l_t150 > l_i100 THEN
      #    CALL l_faj.deleteElement(l_cnt)
      # END IF
      LET l_cnt = 1
      
      #DONE:入库单
      LET l_t720 = 0
      LET i = 0
      LET j = 1 
      LET l_t160 = 0
      LET l_t110 = 0
      LET l_t330 = 0 
      FOREACH r100_t720_d USING sr.pmm01,sr.pmn02
         INTO l_t720_t.*
         IF STATUS THEN
            CALL cl_err("r100_t720_d","!",1)
            RETURN 
         END IF   
         LET l_t720 = l_t720 + 1    
         
         IF l_t720 <= IIF(l_i100>l_t150,l_i100,l_t150)  THEN 
         #不需要新增
            LET i = i + 1
            LET l_faj[i].rvu01_o = l_t720_t.rvu01
            LET l_faj[i].rvv02_o = l_t720_t.rvv02

            LET l_faj[i].rvu00 = l_t720_t.rvu00
            LET l_faj[i].rvu01 = l_t720_t.rvu01
            LET l_faj[i].rvu03 = l_t720_t.rvu03
            LET l_faj[i].rvv02 = l_t720_t.rvv02
            LET l_faj[i].rvv17 = l_t720_t.rvv17
            LET l_faj[i].rvv38 = l_t720_t.rvv38
            LET l_faj[i].rvv39 = l_t720_t.rvv39
            LET k = i
         ELSE 
         #需要新增一行 
            LET j = l_faj.getLength() + 1
            
            LET l_faj[j].pmm04_o = l_faj[1].pmm04_o
            LET l_faj[j].pmc03_o = l_faj[1].pmc03_o
            LET l_faj[j].rvu01_o = l_t720_t.rvu00
            LET l_faj[j].rvv02_o = l_t720_t.rvu01
            
            LET l_faj[j].rvu00 = l_t720_t.rvu00
            LET l_faj[j].rvu01 = l_t720_t.rvu01
            LET l_faj[j].rvu03 = l_t720_t.rvu03
            LET l_faj[j].rvv02 = l_t720_t.rvv02
            LET l_faj[j].rvv17 = l_t720_t.rvv17
            LET l_faj[j].rvv38 = l_t720_t.rvv38
            LET l_faj[j].rvv39 = l_t720_t.rvv39

            LET k = j
         END IF 
         #DONE:暂估单 
         LET l_t160_i = 0
         FOREACH r100_t160_d USING l_t720_t.rvu01,l_t720_t.rvv02 #darcy:2022/04/02 传值错误
            INTO l_t160_t.*
            IF STATUS THEN 
               CALL cl_err("r100_t160_d","!",1)
            END IF
            LET l_t160 = l_t160 + 1
            LET l_t160_i = l_t160_i + 1
            
            IF l_t160_i > 1 THEN 
               #新增空行
               LET j = l_faj.getLength() + 1

               LET l_faj[j].pmm04_o = sr.pmm04
               LET l_faj[j].pmc03_o = sr.pmc03
               LET l_faj[j].rvu01_o = l_t720_t.rvu01
               LET l_faj[j].rvv02_o = l_t720_t.rvv02

               LET l_faj[j].apa01_2 = l_t160_t.apa01_2
               LET l_faj[j].apa02_2 = l_t160_t.apa02_2
               LET l_faj[j].apa44_2 = l_t160_t.apa44_2
               LET l_faj[j].apb10_2 = l_t160_t.apb10_2
               LET l_t160_s[l_t160_i] = j

            ELSE 
               #入库单当前行
               LET l_faj[k].apa01_2 = l_t160_t.apa01_2
               LET l_faj[k].apa02_2 = l_t160_t.apa02_2
               LET l_faj[k].apa44_2 = l_t160_t.apa44_2
               LET l_faj[k].apb10_2 = l_t160_t.apb10_2
               LET l_t160_s[l_t160_i] = k
            END IF 
         END FOREACH
         #DONE:请款单
         LET l_t110_i = 1
         LET l = 1 
         FOREACH r100_t110_d USING l_t720_t.rvu01,l_t720_t.rvv02
            INTO l_t110_t.*
            IF STATUS THEN 
               CALL cl_err("r100_t110_d","!",1)
            END IF
            LET l_t110 = l_t110 + 1 
            LET m = IIF(l_t160>1,l_t160,1)
            IF l_t110_i > IIF(l_t160>1,l_t160,1)  THEN 
               #大于暂估单，或者大于1笔，需要另起一行
               LET j = l_faj.getLength() + 1
               
               LET l_faj[j].pmm04_o = sr.pmm04
               LET l_faj[j].pmc03_o = sr.pmc03
               LET l_faj[j].rvu01_o = l_t720_t.rvu01
               LET l_faj[j].rvv02_o = l_t720_t.rvv02
               LET l_faj[j].apa01_o = l_t110_t.apa01_1

               LET l_faj[j].apa01_1 = l_t110_t.apa01_1
               LET l_faj[j].apa02_1 = l_t110_t.apa02_1
               LET l_faj[j].apa08_1 = l_t110_t.apa08_1
               LET l_faj[j].apa31_1 = l_t110_t.apa31_1
               LET l_faj[j].apa32_1 = l_t110_t.apa32_1
               LET l_faj[j].apa44_1 = l_t110_t.apa44_1
               LET l_faj[j].apb02_1 = l_t110_t.apb02_1
               LET l_faj[j].apb10_1 = l_t110_t.apb10_1

               LET m = j
            ELSE 
               #FIXME: 要考虑没有暂估单情况
               IF l_t160 > 0 THEN 
                  LET m = l_t160_s[m]
                  #在暂估单后面赋值 
               ELSE 
                  LET m = k
               END IF
               LET l_faj[m].apa01_o = l_t110_t.apa01_1
               LET l_faj[m].apa01_1 = l_t110_t.apa01_1
               LET l_faj[m].apa02_1 = l_t110_t.apa02_1
               LET l_faj[m].apa08_1 = l_t110_t.apa08_1
               LET l_faj[m].apa31_1 = l_t110_t.apa31_1
               LET l_faj[m].apa32_1 = l_t110_t.apa32_1
               LET l_faj[m].apa44_1 = l_t110_t.apa44_1
               LET l_faj[m].apb02_1 = l_t110_t.apb02_1
               LET l_faj[m].apb10_1 = l_t110_t.apb10_1 
            END IF 

            #DONE:付款单
            LET l_t330_i = 0
            FOREACH r100_t330_d USING l_t110_t.apa01_1
               INTO l_t330_t.*
               IF STATUS THEN 
                  CALL cl_err("r100_t330_d","!",1)
                  RETURN
               END IF
               LET l_t330 = l_t330 + 1
               LET l_t330_i = l_t330_i +1

               IF l_t330_i > 1 THEN 
                  #另起一行
                  LET j = l_faj.getLength() + 1

                  LET l_faj[j].pmm04_o = sr.pmm04
                  LET l_faj[j].pmc03_o = sr.pmc03
                  LET l_faj[j].rvu01_o = l_t720_t.rvu01
                  LET l_faj[j].rvv02_o = l_t720_t.rvv02
                  LET l_faj[j].apa01_o = l_t110_t.apa01_1

                  LET l_faj[j].apf01 = l_t330_t.apf01
                  LET l_faj[j].apf02 = l_t330_t.apf02
                  LET l_faj[j].apf44 = l_t330_t.apf44
                  LET l_faj[j].apg05 = l_t330_t.apg05

               ELSE
                  #跟随请款单后面
                  LET l_faj[m].apf01 = l_t330_t.apf01
                  LET l_faj[m].apf02 = l_t330_t.apf02
                  LET l_faj[m].apf44 = l_t330_t.apf44
                  LET l_faj[m].apg05 = l_t330_t.apg05

               END IF 

            END FOREACH

            LET l_t110_i = l_t110_i + 1
         END FOREACH
      END FOREACH 
      # IF l_t720 > l_i100 AND l_t720 >l_t150 THEN 
      #    CALL l_faj.deleteElement(l_cnt)
      # END IF 
      # EXECUTE insert_prep USING
      FOR m =1 TO l_faj.getLength()
            EXECUTE insert_prep USING l_faj[m].*
            IF STATUS THEN
               CALL cl_err("insert_prep","!",1)
               RETURN
            END IF 
      END FOR 
          
   END FOREACH 
                                                                                                           
   # LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",tm.t[2,2],";",g_azi04,";",tm.sum,";",g_str                                                                                                                 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
   CALL cl_prt_cs3('cfar100','cfar100',g_sql,g_str) 
END FUNCTION

FUNCTION r100_set_comp() 
   DEFINE l_sql            STRING
   DEFINE l_fab01          LIKE fab_file.fab01,
          l_fab02          LIKE fab_file.fab02
   DEFINE l_values,l_items STRING

   DECLARE t100_fab_d CURSOR FOR 
      SELECT fab01,fab02 FROM fab_file WHERE fabacti ='Y'

   LET l_values =""
   LET l_items = ""
   FOREACH t100_fab_d INTO l_fab01,l_fab02
      IF STATUS THEN
         CALL cl_err("t100_fab_d","!",1)
      END IF 
      LET l_values=IIF(cl_null(l_values),l_fab01,l_values||","||l_fab01) 
      LET l_items=IIF(cl_null(l_items),l_fab01||"."||l_fab02,l_items||","||l_fab01||"."||l_fab02) 
   END FOREACH 
   CALL cl_set_combo_items("faj04",l_values,l_items)
   CALl cl_set_combo_items("faj43","0,1,2,3,4,5,6,7,8,9,X,Z","0.取得,1.资本化,2.折旧中,3.外送,4.折毕,5.出售,6.销账,7.折毕再提,8.改良,9.重估,X.被资本,Z.停用")
   CALL cl_set_combo_items("s1","pmm04,pmc03,faj02,faj26","订单日期,供应商简称,固资编号,固资入账日期")
   CALL cl_set_combo_items("s2","pmm04,pmc03,faj02,faj26","订单日期,供应商简称,固资编号,固资入账日期")
   CALL cl_set_combo_items("s3","pmm04,pmc03,faj02,faj26","订单日期,供应商简称,固资编号,固资入账日期")
   CALL cl_set_combo_items("s4","pmm04,pmc03,faj02,faj26","订单日期,供应商简称,固资编号,固资入账日期")
   
END FUNCTION

# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: afar401.4gl
# Descriptions...: 固定財產目錄(稅簽)
# Date & Author..: 96/06/08 By Charis
# Modify.........: No.CHI-480001 04/08/11 By Danny  增加資產停用選項/
#                                                   新增大陸版報表段(減值準備)
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No: FUN-580010 05/08/15 BY Nigel 改用新報表格式
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-770015 07/07/06 By Smampin 依afar201規格修改
# Modify.........: No.FUN-770052 07/07/27 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-8A0055 08/12/31 By shiwuying 修改g_head1 中文傳入參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0112 09/11/19 By Sarah 資產狀態原先抓faj43改成抓faj201
# Modify.........: No:CHI-A30006 10/04/30 By Summer 成本計算邏輯調整
# Modify.........: No:MOD-B20086 11/02/18 By Dido 預設值與檢核應改用 faa11/faa12 
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark 
# Modify.........: No:MOD-C20017 12/02/04 By Polly SQL中不可使用MATCHES改用IN
# Modify.........: No:FUN-C50089 12/06/14 By Lori 新增族群編號列印功能
# Modify.........: No:FUN-C90088 12/12/18 By Belle  列印年限需有回溯功能
# Modify.........: No:MOD-D20155 13/02/26 By Polly 報廢後資產仍有剩餘數量，狀態應仍為折舊中，並調整本期折舊與累計折計算
# Modify.........: No.CHI-D30018 13/03/11 By Polly 調整資產狀態抓取條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD                                   # Print condition RECORD
             wc      LIKE type_file.chr1000,       # Where condition         #No.FUN-680070 VARCHAR(1000)
             s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
             t       LIKE type_file.chr3,          # Eject sw                #No.FUN-680070 VARCHAR(3)
             v       LIKE type_file.chr3,          # Group total sw          #No.FUN-680070 VARCHAR(3)
             yy1     LIKE type_file.num5,          #No.FUN-680070 SMALLINT
             mm1     LIKE type_file.num5,          #No.FUN-680070 SMALLINT
             c       LIKE type_file.chr1,          # No.CHI-480001               #No.FUN-680070 VARCHAR(1)
             e       LIKE type_file.chr1,          #FUN-C50089 add
             more    LIKE type_file.chr1           # Input more condition(Y/N)   #No.FUN-680070 VARCHAR(1)
          END RECORD,
        g_descripe ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt #No.FUN-680070 VARCHAR(14)
        g_tot_bal    LIKE type_file.num20_6,       # User defined variable       #No.FUN-680070(13,3)
        g_fap660     LIKE fap_file.fap66,
        g_fap34      LIKE fap_file.fap34,      #CHI-A30006 add
        g_fap661     LIKE fap_file.fap661,     #CHI-A30006 add
        g_fap54_7    LIKE fap_file.fap54,      #CHI-A30006 add
        g_fap731     LIKE fap_file.fap73,      #CHI-A30006 add
        g_fap670     LIKE fap_file.fap67,
        g_fap662     LIKE fap_file.fap66,
        g_fap67,g_fap671,l_curr_qty LIKE fap_file.fap67,
        g_fap71      LIKE fap_file.fap71,
        g_fap73      LIKE fap_file.fap73,
        g_fap74      LIKE fap_file.fap74,
        g_fap79      LIKE fap_file.fap79,          #No.CHI-480001
        g_bdate,g_edate LIKE type_file.dat         #No.FUN-680070 DATE
#       g_dash1      LIKE type_file.chr1000        #No.FUN-680070 VARCHAR(240)
 
DEFINE  g_i          LIKE type_file.num5           #count/index for any purpose  #No.FUN-680070 SMALLINT
DEFINE  g_head1      LIKE type_file.chr1000        #No.FUN-680070 VARCHAR(400)
DEFINE   l_table         STRING,                   ### FUN-770052 ###                                                                    
         g_str           STRING,                   ### FUN-770052 ###                                                                    
         g_sql           STRING                    ### FUN-770052 ### 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
### *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   LET g_sql = "fab02.fab_file.fab02,faj02.faj_file.faj02,",
               "faj022.faj_file.faj022,faj20.faj_file.faj20,",
               "gen02.gen_file.gen02,faj07.faj_file.faj07,",
               "faj06.faj_file.faj06,faj17.faj_file.faj17,",
               "faj08.faj_file.faj08,faj27.faj_file.faj27,",
               "faj64.faj_file.faj64,faj60.faj_file.faj60,",
               "faj60b.faj_file.faj60,faj60c.faj_file.faj60,",
               "faj60d.faj_file.faj60,faj60e.faj_file.faj60,",
               "faj60f.faj_file.faj60,faf02.faf_file.faf02,",
               "faj04.faj_file.faj04,faj05.faj_file.faj05,",
               "faj21.faj_file.faj21,faj19.faj_file.faj19,",
               "faj62.faj_file.faj62,faj22.faj_file.faj22,",
               "faj43.faj_file.faj43,faj93.faj_file.faj93"   #FUN-C50089 add faj93   #MOD-9B0112 add
   LET l_table = cl_prt_temptable('afar401',g_sql) CLIPPED   # 產生Temp Table                                                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?,?)"                        #FUN-C50089 add ?       #MOD-9B0112 add ?
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
   END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.v  = ARG_VAL(10)
   LET tm.yy1= ARG_VAL(11)
   LET tm.mm1= ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)                     #No.CHI-480001
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar401_tm(0,0)        # Input print condition
      ELSE CALL afar401()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar401_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afar401_w AT p_row,p_col WITH FORM "afa/42f/afar401"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.t    = 'Y  '
   LET tm.v    = 'Y  '
   LET tm.c    = '0'                         #No.CHI-480001
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy1   = g_faa.faa11   #MOD-B20086 mod faa07 -> faa11
   LET tm.mm1   = g_faa.faa12   #MOD-B20086 mod faa08 -> faa12
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.v[1,1]
   LET tm2.u2   = tm.v[2,2]
   LET tm2.u3   = tm.v[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj20,faj19,faj93,faj06,faj27,     #FUN-C50089 add faj93
                                 faj62,faj21,faj22
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
     #-----MOD-610033---------
     ON ACTION CONTROLP
        CASE
              WHEN INFIELD(faj22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_azp"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj22
                   NEXT FIELD faj22
        END CASE
     #-----END MOD-610033-----
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afar401_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
   #  DISPLAY BY NAME tm.s,tm.t,tm.v,tm.yy1,tm.mm1,tm.more
      INPUT BY NAME
         tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
         tm2.u1,tm2.u2,tm2.u3,tm.yy1,tm.mm1,tm.c,tm.e,tm.more   #FUN-C50089 add tm.e   #No.CHI-480001
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy1
            IF cl_null(tm.yy1) THEN
               NEXT FIELD FORMONLY.yy1
            END IF
            IF tm.yy1> g_faa.faa11  THEN    ##不可大於固定資產年度  #MOD-B20086 mod faa07 -> faa11
               NEXT FIELD FORMONLY.yy1
            END IF
 
         AFTER FIELD mm1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.mm1 > 12 OR tm.mm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm1
               END IF
            ELSE
               IF tm.mm1 > 13 OR tm.mm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.mm1) THEN
               NEXT FIELD FORMONLY.mm1
            END IF
 
         #No.CHI-480001
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[012]" THEN
               NEXT FIELD FORMONLY.c
            END IF
         #end

         #FUN-C50089--add begin---
         ON CHANGE e
            IF cl_null(tm.e) THEN
               LET tm2.s1 = 'B'
               LET tm2.s2 = '3'
               LET tm2.s3 = '1'
               LET tm2.u1 = 'Y'
            ELSE
               IF tm.e = '1' THEN
                  LET tm2.s1 = 'B'
                  LET tm2.u1 = 'Y'
               ELSE
                  LET tm2.s1 = '3'
                  LET tm2.u1 = 'N'
               END IF
               LET tm2.s2 = 'N'
               LET tm2.s3 = 'N'
              #LET tm2.u1 = 'N'
            END IF

            LET tm2.t1 = 'Y'
            LET tm2.t2 = 'N'
            LET tm2.t3 = 'N'
            LET tm2.u2 = 'N'
            LET tm2.u3 = 'N'
            DISPLAY BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3

            IF NOT cl_null(tm.e) THEN
               CALL cl_set_comp_entry('s1,s2,s3,t1,t2,t3,u1,u2,u3',FALSE)
            ELSE
               CALL cl_set_comp_entry('s1,s2,s3,t1,t2,t3,u1,u2,u3',TRUE)
            END IF
         #FUN-C50089--add end-----
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.v = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW afar401_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar401'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar401','9031',1)
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
                            " '",tm.t CLIPPED,"'",
                            " '",tm.v CLIPPED,"'",
                            " '",tm.yy1 CLIPPED,"'",
                            " '",tm.mm1 CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",     #No.CHI-480001
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar401',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar401_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar401()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar401_w
END FUNCTION
 
FUNCTION afar401()
   DEFINE l_name     LIKE type_file.chr20,                # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0069
          l_name1       LIKE type_file.chr20,             #FUN-770052
          l_sql      LIKE type_file.chr1000,              # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr      LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,              #No.FUN-680070 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE faj_file.faj06,     #No.FUN-680070 VARCHAR(30)
          l_bdate,l_edate LIKE type_file.dat,             #No.FUN-680070 DATE
          l_fao08    LIKE fao_file.fao08,
          l_fao14    LIKE fao_file.fao14,
          l_fao15    LIKE fao_file.fao15,
          l_fao17    LIKE fao_file.fao17,                 #No.CHI-480001
          l_cnt      LIKE type_file.num5,                 #No.FUN-680070 SMALLINT
          l_fap03    LIKE fap_file.fap03,
          l_fap04    LIKE fap_file.fap04,
          l_fap06    LIKE fap_file.fap06,              #CHI-D30018 add
          l_faj34    LIKE faj_file.faj34,              #CHI-A30006 add
          l_year,l_mon LIKE type_file.num5,            #MOD-770015
          l_fao04    LIKE fao_file.fao04,              #MOD-770015
          l_fao03    LIKE fao_file.fao03,              #CHI-A30006 add
          sr         RECORD
                      order1 LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(30)
                      order2 LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(30)
                      order3 LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(30)
                      faj04  LIKE faj_file.faj04,      # 資產分類
                      fab02  LIKE fab_file.fab02,      #
                      faj05  LIKE faj_file.faj05,      # 資產分類
                      faj02  LIKE faj_file.faj02,      # 財產編號
                      faj022 LIKE faj_file.faj022,     # 財產附號
                      faj20  LIKE faj_file.faj20,      # 保管部門
                      faj21  LIKE faj_file.faj21,      # 存放位置
                      faf02  LIKE faf_file.faf02,      # 名稱
                      faj19  LIKE faj_file.faj19,      # 保管人
                      gen02  LIKE gen_file.gen02,      # 保管人姓名
                      faj07  LIKE faj_file.faj07,      # 英文名稱
                      faj06  LIKE faj_file.faj06,      # 中文名稱
                      faj17  LIKE faj_file.faj17,      # 數量
                      faj58  LIKE faj_file.faj58,      # 銷帳數量
                      faj08  LIKE faj_file.faj08,      # 規格型號
                      faj27  LIKE faj_file.faj27,      # 折舊年月
                      faj64  LIKE faj_file.faj64,      # 耐用年限
                      faj62  LIKE faj_file.faj62,      # 本幣成本
                      faj63  LIKE faj_file.faj63,      # 調整成本
                     #faj59  LIKE faj_file.faj59,      # 銷帳成本  #CHI-A30006 mark
                      faj69  LIKE faj_file.faj69,      # 銷帳成本   #CHI-A30006 add
                      faj67  LIKE faj_file.faj67,      # 累績折舊
                      faj43  LIKE faj_file.faj43,      # 狀態
                      faj201 LIKE faj_file.faj201,     # 稅簽資產狀態  #MOD-9B0112 add
                      faj74  LIKE faj_file.faj74,
                      faj741 LIKE faj_file.faj741,
                      faj100 LIKE faj_file.faj100,
                      faj60  LIKE faj_file.faj60,      # 銷帳累折
                      tmp01  LIKE faj_file.faj60,      # 數量
                      tmp02  LIKE faj_file.faj60,      # 成本
                      tmp03  LIKE faj_file.faj60,      # 前期累折
                      tmp04  LIKE faj_file.faj60,      # 本期累折
                      tmp05  LIKE faj_file.faj60,      # 累積折舊
                      tmp06  LIKE faj_file.faj60,      # 帳面價值
                      #No.CHI-480001
                      tmp07  LIKE faj_file.faj60,      # 減值準備
                      tmp08  LIKE faj_file.faj60,      # 資產淨額
                      faj103 LIKE faj_file.faj103,     # 減值準備
                      faj104 LIKE faj_file.faj104,     # 銷帳減值
                      faj22  LIKE faj_file.faj22,      #MOD-770015
                      faj93  LIKE faj_file.faj93,      # 族群編號      #FUN-C50089 add
                      faj66  LIKE faj_file.faj66,      #CHI-D30018 add
                      faj71  LIKE faj_file.faj71       #CHI-D30018 add
                      #end
                     END RECORD
     DEFINE l_fap94  LIKE fap_file.fap94    #FUN-C90088
     #FUN-C90088--B--
     LET l_sql = " SELECT fap94 FROM fap_file"
                ,"  WHERE fap03 ='9'"
                ,"    AND fap02 = ? AND fap021= ? AND fap04 < ?"
                ,"  ORDER BY fap04 desc"
     PREPARE r401_p01 FROM l_sql
     DECLARE r401_c01 SCROLL CURSOR WITH HOLD FOR r401_p01
     #FUN-C90088--E--

 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                                        #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                                        #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN                           #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     CALL s_azn01(tm.yy1,tm.mm1) RETURNING g_bdate,g_edate
 
     LET l_sql = "SELECT '','','',",
                 "       faj04, fab02, faj05,",
                 "       faj02, faj022,faj20, faj21,faf02, faj19,gen02,faj07, ",
                 "       faj06, faj17, faj58,",
                 "       faj08, faj27, faj64, faj62,faj63, faj69,",                           #CHI-A30006 mod faj59->faj69
                 "       faj67, faj43, faj201,faj74,faj741,faj100,faj60,0,0,0,0,0,0,",        #MOD-9B0112 add faj201
                #"       0,0,faj103,faj104 ",                                                 #No.CHI-480001   #MOD-770015
                #"       0,0,faj103,faj104,faj22 ",                                           #No.CHI-480001  #MOD-770015 #CHI-D30018 mark
                #"       faj93 ",                                                             #FUN-C50089 add faj93 #CHI-D30018 mark
                 "       0,0,faj103,faj104,faj22,",                                           #CHI-D30018 add ,
                 "       faj93,faj66,faj71 ",                                                 #CHI-D30018 add faj66,faj71
                 "  FROM faj_file,OUTER fab_file,OUTER gen_file,OUTER faf_file",
                 " WHERE fajconf='Y' AND ",tm.wc CLIPPED,
                 "   AND faj26 <='",g_edate,"'",
                 "   AND faj_file.faj19=gen_file.gen01 ",
                 "   AND faj_file.faj21=faf_file.faf01 ",
                 "   AND faj_file.faj04=fab_file.fab01 "
     #No.CHI-480001
     IF tm.c = '1' THEN    #停用
        #LET l_sql = l_sql CLIPPED," AND faj105 = 'Y' " #No.FUN-B80081 mark
         LET l_sql = l_sql CLIPPED," AND faj43 = 'Z' "  #No.FUN-B80081 add
     END IF
     IF tm.c = '0' THEN    #正常使用
        LET l_sql = l_sql CLIPPED,
                    #" AND (faj105 = 'N' OR faj105 IS NULL OR faj105 = ' ') " #No.FUN-B80081 mark
                     " AND faj43<>'Z' " #No.FUN-B80081 add
     END IF
     #end
 
     PREPARE afar401_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar401_curs1 CURSOR FOR afar401_prepare1
     #--------------取得當時的資料狀態
      LET l_sql = " SELECT fap04,fap03,fap06 FROM fap_file ",            #CHI-D30018 add fap06
                  "  WHERE fap02 = ? AND fap021= ? ",
                  "    AND fap04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",  #CHI-A30006 add
                  "  ORDER BY fap04 DESC  "
     PREPARE r401_pre2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE r401_curs2 SCROLL CURSOR FOR r401_pre2
 
#    CALL cl_outnam('afar401') RETURNING l_name                    #FUN-770052
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
     #------------------------------ CR (2) ------------------------------#   
 #No.FUN-580010 --start
     IF cl_null(tm.e) THEN               #FUN-C50089 add
           IF g_aza.aza26 = '2' THEN
            LET g_zaa[69].zaa06 = "N"
            LET l_name1 = 'afar401'
           ELSE
            LET g_zaa[69].zaa06 = "Y"
            LET l_name1 = 'afar401_1'
           END IF
      ELSE                               #FUN-C50089 add
         IF tm.e = '1' THEN              #FUN-C50089 add
            LET l_name1 = 'afar401_2'    #FUN-C50089 add
         ELSE  #tm.e=2                   #FUN-C50089 add
            LET l_name1 = 'afar401_3'    #FUN-C50089 add
         END IF                          #FUN-C50089 add
      END IF                             #FUN-C50089 add
#    CALL cl_prt_pos_len()                                         #FUN-770052
#No.FUN-580010 --end
#    START REPORT afar401_rep TO l_name                            #FUN-770052
     LET g_pageno = 0
     FOREACH afar401_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #---上線後(5)出售(6)銷帳報廢不包含
        SELECT count(*) INTO l_cnt FROM fap_file
         WHERE fap02=sr.faj02 AND fap021=sr.faj022
          #-----MOD-770015---------
          #AND fap04 < g_bdate AND fap77 IN ('5','6')
          #AND fap77 MATCHES '[56]' AND (YEAR(fap04) < tm.yy1      #MOD-C20017 mark
           AND fap77 IN ('5','6') AND (YEAR(fap04) < tm.yy1        #MOD-C20017 add
           #OR (YEAR(fap04) = tm.yy1 AND MONTH(fap04) <= tm.mm1))  #MOD-710104  #CHI-A30006 mark
            OR (YEAR(fap04) = tm.yy1 AND MONTH(fap04) <  tm.mm1))              #CHI-A30006
          #-----END MOD-770015-----
        IF l_cnt > 0 THEN CONTINUE FOREACH END IF
        #---上線期初值
        CALL s_azn01(sr.faj74,sr.faj741) RETURNING l_bdate,l_edate
       #-----MOD-770015---------
       #IF l_edate < g_edate AND sr.faj43 matches '[56]' AND
       #   (sr.faj100 <=l_edate   OR sr.faj100 IS NULL OR sr.faj100 = ' ') THEN
       #   CONTINUE FOREACH
       #END IF
       #-----END MOD-770015-----
        LET sr.faj43 = sr.faj201   #MOD-9B0112 add
 
       #CHI-A30006 add --start--
        LET g_fap34 = 0
        LET g_fap661= 0
        LET g_fap731 = 0
        LET g_fap660= 0 LET g_fap661= 0 LET g_fap662= 0
       #CHI-A30006 add --end--

        #----推算至截止日期之資產數量
        CALL r401_cal(sr.faj02,sr.faj022)
 
        #數量=目前數量-銷帳數量-大於當期(異動值)+大於當期(銷帳)-大於當期(調整)
        LET sr.tmp01=sr.faj17-sr.faj58 - g_fap660 + g_fap670 - g_fap662
 
        #----本期累折/成本/累折
        #CHI-A30006 add --start--
        LET l_fao14 = 0
        SELECT fao14
          INTO l_fao14 FROM fao_file
         WHERE fao01=sr.faj02 AND fao02=sr.faj022
           AND fao03 = tm.yy1 AND fao04 = tm.mm1
           AND fao041 IN ('0','1') 
           AND fao05 IN ('1','2')
        IF cl_null(l_fao14) THEN LET l_fao14=0 END IF
        #CHI-A30006 add --end--

        LET l_fao08 = 0    LET l_fao15 = 0    LET l_fao17 = 0  #CHI-A30006 add


        #SELECT SUM(fao08),SUM(fao14),SUM(fao15),SUM(fao17)     #No:CHI-480001 #CHI-A30006 mark
        #  INTO l_fao08,l_fao14,l_fao15,l_fao17 FROM fao_file                  #CHI-A30006 mark
        SELECT SUM(fao08),SUM(fao15),SUM(fao17)         #CHI-A30006
          INTO l_fao08,l_fao15,l_fao17 FROM fao_file    #CHI-A30006
         WHERE fao01=sr.faj02 AND fao02=sr.faj022
           AND fao03 = tm.yy1 AND fao04 = tm.mm1
           AND fao041 IN ('0','1')  #CHI-A30006 add
           AND fao05 IN ('1','2')   #MOD-770015
       #-----MOD-770015---------
       #IF SQLCA.sqlcode THEN
       #   #----視為折畢
       #   LET l_fao14 = sr.faj62 + sr.faj63  #成本
       #   LET l_fao08 = 0                     #本期折舊
       #   LET l_fao15 = sr.faj67              #累折
       #   LET l_fao17 = sr.faj103             #減值準備    No.CHI-480001
       #   LET g_fap71 = 0                     #本期折舊
       #END IF
        IF SQLCA.sqlcode OR cl_null(l_fao08) THEN
           #CHI-A30006 add --start--
           SELECT faj34 INTO l_faj34 FROM faj_file
            WHERE faj02 = sr.faj02 ANd faj022 = sr.faj022
           IF l_faj34 = 'Y' THEN   #折畢再提,不考慮年度往前抓最后一期折舊年月
              LET l_sql="SELECT fao03,fao04 FROM fao_file",
                        " WHERE fao01 = '",sr.faj02,"' AND fao02 = '",sr.faj022,"'",
                        "   AND fao03*12+fao04 <= ",tm.yy1*12+tm.mm1,
                        "   AND fao041 IN ('0','1') ",
                        "   AND fao05 IN ('1','2') ",
                        " ORDER BY fao03 desc,fao04 desc "
           ELSE
              LET l_sql="SELECT fao03,fao04 FROM fao_file",
                        " WHERE fao01 = '",sr.faj02,"' AND fao02 = '",sr.faj022,"'",
                        "   AND fao03 = ",tm.yy1," AND fao04 < ",tm.mm1,
                        "   AND fao041 IN ('0','1') ",
                        "   AND fao05 IN ('1','2') ",
                        " ORDER BY fao03 desc,fao04 desc "
           END IF
           PREPARE afar401_prepare_fan FROM l_sql
           DECLARE afar401_curs_fan CURSOR FOR afar401_prepare_fan
           LET l_fao03=''  LET l_fao04=''
           FOREACH afar401_curs_fan INTO l_fao03,l_fao04
              EXIT FOREACH
           END FOREACH

           IF cl_null(l_fao03) THEN LET l_fao03 = 0 END IF
           #CHI-A30006 add --end--

           #CHI-A30006 mark --start--
           #SELECT MAX(fao04) INTO l_fao04 FROM fao_file
           #  WHERE fao01=sr.faj02 AND fao02=sr.faj022
           #    AND fao03=tm.yy1 AND fao04 < tm.mm1
           #    AND fao05 IN ('1','2')
           #CHI-A30006 mark --end--

           IF cl_null(l_fao04) THEN LET l_fao04 = 0 END IF
           IF SQLCA.sqlcode OR l_fao04 = 0 THEN
              #----視為折畢
              LET l_fao14 = sr.faj62 + sr.faj63  #成本
              LET l_fao08 = 0                     #本期折舊
              LET l_fao15 = sr.faj67              #累折
              LET l_fao17 = sr.faj103             #減值準備    No.CHI-480001
              LET g_fap71 = 0                     #本期折舊
           ELSE
              #----本期累折/成本/累折
              LET l_fao14 = 0
              SELECT fao14
                INTO l_fao14 FROM fao_file
               WHERE fao01=sr.faj02 AND fao02=sr.faj022
                 #AND fao03 = tm.yy1 AND fao04=l_fao04   #CHI-A30006 mark
                 AND fao03 = l_fao03 AND fao04=l_fao04   #CHI-A30006
                 AND fao041 IN ('0','1')                 #CHI-A30006 add
                 AND fao05 IN ('1','2')
              LET l_fao08=0   LET l_fao15=0   LET l_fao17=0
              SELECT SUM(fao08),SUM(fao15),SUM(fao17)
                INTO l_fao08,l_fao15,l_fao17 FROM fao_file
               WHERE fao01=sr.faj02 AND fao02=sr.faj022
                 #AND fao03=tm.yy1 AND fao04=l_fao04     #CHI-A30006 mark
                 AND fao03=l_fao03 AND fao04=l_fao04     #CHI-A30006
                 AND fao05 IN ('1','2')
           END IF
        ELSE   #CHI-A30006 add
           LET l_fao03 = tm.yy1   #CHI-A30006 add
           LET l_fao04 = tm.mm1   #CHI-A30006 add
        END IF
        #-----END MOD-770015-----
        #LET sr.tmp02 = l_fao14 - g_fap73       #成本  #CHI-A30006 mark
        #CHI-A30006 add --start--
        IF cl_null(l_fao08) THEN LET l_fao08 = 0 END IF
        IF l_fao03 < tm.yy1 THEN LET l_fao08 = 0 END IF
        IF cl_null(l_fao17) THEN LET l_fao17 = 0 END IF
        #IF g_fap09=0 THEN LET g_fap09=l_fao14 END IF
        #成本=目前成本+調整成本-銷帳成本-(大於當期(調整)-大於當期(前一次調整))-大於當期(改良)
        LET sr.tmp02 = sr.faj62+sr.faj63-sr.faj69-(g_fap661-g_fap34)-g_fap54_7 + g_fap731
        #CHI-A30006 add --end--
        #--->成本為零
        IF sr.tmp02 <=0 THEN CONTINUE FOREACH END IF
        #-----MOD-770015---------
        LET l_year = sr.faj27[1,4]
        LET l_mon  = sr.faj27[5,6]
        IF (l_year=tm.yy1 AND l_mon > tm.mm1) OR l_year > tm.yy1 THEN
           LET sr.tmp05=0
           LET sr.tmp07=0
        ELSE
        #-----END MOD-770015-----
           LET sr.tmp05 = l_fao15 - g_fap74    #累折
           LET sr.tmp07 = l_fao17 - g_fap79    #減值準備    No.CHI-480001
        END IF   #MOD-770015
        #-->本期累折
        IF l_fao08 = 0 THEN
            LET sr.tmp04 = 0
        ELSE
           #LET sr.tmp04 = l_fao08 - g_fap71   #本期折舊 #MOD-D20155 mark
            LET sr.tmp04 = l_fao08             #本期折舊 #MOD-D20155 add
        END IF
        LET sr.tmp03 = sr.tmp05- sr.tmp04      #前期折舊 = 累折 - 本期累折
        LET sr.tmp06 = sr.tmp02- sr.tmp05      #帳面價值 (成本-累折)
        #No.CHI-480001
        LET sr.tmp08 = sr.tmp06- sr.tmp07      #資產淨額 (帳面價值-減值準備)
        #end
        #----取得當時的資料狀態
        LET l_fap04 = NULL LET l_fap03 = NULL
        LET l_fap06 = NULL                                                    #CHI-D30018 add
        OPEN r401_curs2  USING sr.faj02,sr.faj022
       #FETCH FIRST r401_curs2 INTO l_fap04,l_fap03                           #CHI-D30018 mark
        FETCH FIRST r401_curs2 INTO l_fap04,l_fap03,l_fap06                   #CHI-D30018 add fap06
        CLOSE r401_curs2
        # 若有當時的歷史資料則將當時情況帶入
        IF sr.faj17 = sr.faj58 THEN                                      #MOD-D20155 add
           IF NOT cl_null(l_fap04) THEN LET sr.faj43 = l_fap03 END IF
           #No.CHI-480001
           IF NOT cl_null(l_fap04) THEN
              CASE l_fap03
                 WHEN '4'  LET sr.faj43 = '5'
                 WHEN '5'  LET sr.faj43 = '6'
                 WHEN '6'  LET sr.faj43 = '6'
                 WHEN '7'  LET sr.faj43 = '8'
                 WHEN '8'  LET sr.faj43 = '9'
                 OTHERWISE LET sr.faj43 = sr.faj43   #MOD-9B0112 add
              END CASE
           END IF
        END IF                             #MOD-D20155 add
       #end
       #----------------------CHI-D30018-------------(S)
        IF l_fap03 = '9' THEN
           IF l_fap06 <> '0' THEN
              CASE
                WHEN (sr.tmp06 = 0 )
                  LET sr.faj43 = '4'
                WHEN (sr.tmp06 = sr.faj66 )
                  IF sr.faj71 = 'Y' THEN
                     LET sr.faj43 = '7'
                  ELSE
                     LET sr.faj43 = '4'
                  END IF
                OTHERWISE
                     LET sr.faj43 = '2'
              END CASE
           END IF
        END IF
        IF l_fap03 = 'C' THEN
           LET sr.faj43 = '7'
        END IF
       #----------------------CHI-D30018-------------(E)
 
       #FOR g_i = 1 TO 3                                                 #FUN-770052
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
       #                                 LET g_descripe[g_i]=g_x[21]
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
       #                                 LET g_descripe[g_i]=g_x[44]
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
       #                                 LET g_descripe[g_i]=g_x[22]
       #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj20
       #                                 LET g_descripe[g_i]=g_x[23]
       #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj19
       #                                 LET g_descripe[g_i]=g_x[24]
       #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.faj06
       #                                 LET g_descripe[g_i]=g_x[45]
       #        WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.faj27
       #                                 LET g_descripe[g_i]=g_x[25]
       #        WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.faj62
       #                                 LET g_descripe[g_i]=g_x[47]
       #        WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.faj21
       #                                 LET g_descripe[g_i]=g_x[48]
       #        WHEN tm.s[g_i,g_i] = 'A' LET l_order[g_i] = sr.faj22   #MOD-770015
       #                                 LET g_descripe[g_i]=g_x[49]
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #LET sr.order3 = l_order[3]
       #IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       #IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       #IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF                  #FUN-770052
   #    LET g_head1=tm.yy1 USING '####','年',tm.mm1 USING '##','月'  #FUN-770052  #FUN-8A0055       
#       OUTPUT TO REPORT afar401_rep(sr.*)                                     #FUN-770052
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
        #FUN-C90088--B--
        #耐用年限回溯
        LET l_fap94 = ""
        OPEN r401_c01 USING sr.faj02 ,sr.faj022,g_edate
        FETCH FIRST r401_c01 INTO l_fap94
        IF NOT cl_null(l_fap94) THEN LET sr.faj64 = l_fap94 END IF
        #FUN-C90088--E--

        EXECUTE insert_prep USING                                                                                                
           sr.fab02,sr.faj02,sr.faj022,sr.faj20,sr.gen02,
           #sr.faj07,sr.faj06,sr.faj17, sr.faj08,sr.faj27,  #CHI-A30006 mark
           sr.faj07,sr.faj06,sr.tmp01, sr.faj08,sr.faj27,   #CHI-A30006
           sr.faj64,sr.tmp02,sr.tmp03, sr.tmp04,sr.tmp05,
           sr.tmp06,sr.tmp08,sr.faf02, sr.faj04,sr.faj05,
           sr.faj21,sr.faj19,sr.faj62, sr.faj22,sr.faj43,   #MOD-9B0112 add sr.faj43
           sr.faj93                                         #FUN-C50089 ass sr.faj93
        #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
#    FINISH REPORT afar401_rep                                                #FUN-770052
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                              #FUN-770052
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                               #FUN-770072                                                     
#No.FUN-770052--begin                                                                                                               
     IF g_zz05 = 'Y' THEN                                                                                                          
        CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj20,faj19,faj06,faj27,faj62,faj21,faj22')                                                                                   
             RETURNING tm.wc                                                                                                       
#       CALL cl_prt_pos_wc(tm.wc)                                            #FUN-770052                                                      
     END IF            
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     LET g_str = ''                                                                                                                  
  #  LET g_str = g_head1,";",sr.faj43,";",tm.wc,";",g_azi05,";",tm.s[1,1],";",    #FUN-8A0055                                                      
     LET g_str = tm.yy1,";",sr.faj43,";",tm.wc,";",g_azi05,";",tm.s[1,1],";",   #FUN-8A0055
                 tm.s[2,2],";",tm.s[3,3],";",                                                                                        
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.v[1,1],";",
                 tm.v[2,2],";",tm.v[3,3],";",g_azi03,";",g_azi04,";",tm.mm1     #FUN-8A0055 --add                                     
     CALL cl_prt_cs3('afar401',l_name1,l_sql,g_str)                                                                                  
     #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
FUNCTION r401_cal(l_faj02,l_faj022)
  DEFINE l_faj02  LIKE faj_file.faj02,
         l_faj022 LIKE faj_file.faj022
  DEFINE l_cnt    LIKE type_file.num5      #MOD-D20155 add
 
       #----盤點、出售、報廢、銷帳(數量)
       SELECT SUM(fap66),SUM(fap67) INTO g_fap660,g_fap670
            FROM fap_file
           WHERE fap03 IN ('2','4','5','6') AND fap02=l_faj02
             AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap660) THEN LET g_fap660=0  END IF
       IF cl_null(g_fap670) THEN LET g_fap670=0  END IF
 
       #----出售、報廢、銷帳(數量)
       SELECT SUM(fap67) INTO g_fap671 FROM fap_file
           WHERE fap03 IN ('2','4','5','6') AND fap02=l_faj02
             AND fap021=l_faj022 AND fap04 < g_bdate
       IF cl_null(g_fap671) THEN LET g_fap671=0  END IF
 
       #----調整(數量)
       SELECT SUM(fap66) INTO g_fap662 FROM fap_file
          WHERE fap03 IN ('9') AND fap02=l_faj02
            AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap662) THEN LET g_fap662=0  END IF
 
       #CHI-A30006 add --start--
       #----調整(金額)
       SELECT SUM(fap661),SUM(fap34) INTO g_fap661,g_fap34 FROM fap_file
          WHERE fap03 IN ('9') AND fap02=l_faj02
            AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap661) THEN LET g_fap661 = 0 END IF
       IF cl_null(g_fap34) THEN LET g_fap34 = 0 END IF

       SELECT SUM(fap73) INTO g_fap731 FROM fap_file
        WHERE fap03 IN ('4','5','6','7','8','9')  AND fap02=l_faj02
          AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap731) THEN LET g_fap731 = 0  END IF

       SELECT SUM(fap54) INTO g_fap54_7 FROM fap_file
         WHERE fap03 IN ('7') AND fap02=l_faj02
           AND fap021=l_faj022 AND fap04 > g_edate
       IF cl_null(g_fap54_7) THEN LET g_fap54_7 = 0 END IF
       #CHI-A30006 add --end--

       #----出售、報廢、銷帳(成本)
      #SELECT SUM(fap71),SUM(fap73),SUM(fap74),SUM(fap79)    #No.CHI-480001 #MOD-D20155 mark
      #  INTO g_fap71,g_fap73,g_fap74,g_fap79                #MOD-D20155 mark
       SELECT SUM(fap71),SUM(fap79)                          #MOD-D20155 add
         INTO g_fap71,g_fap79                                #MOD-D20155 add
         FROM fap_file
       #WHERE fap03 IN ('2','4','5','6') AND fap02=l_faj02   #MOD-D20155 mark
        WHERE fap03 IN ('4','5','6') AND fap02 = l_faj02     #MOD-D20155 add
          AND fap021=l_faj022
          AND fap04 between g_bdate AND g_edate
        ORDER BY fap04 DESC                                  #MOD-D20155 add
      #-------------------------MOD-D20155----------------(S)
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM fao_file
        WHERE fao01 = l_faj02 AND fao02 = l_faj022
          AND fao03 = tm.yy1 AND fao04 = tm.mm1
          AND fao041 IN ('0','1')
          AND fao05 IN ('1','2')

       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       IF l_cnt = 0 THEN
          SELECT SUM(fap74) INTO g_fap74 FROM fap_file
            WHERE fap03 IN ('4','5','6') AND fap02=l_faj02
             AND fap021 = l_faj022
             AND fap04 < g_bdate
       END IF
      #-------------------------MOD-D20155----------------(E)
       IF cl_null(g_fap71) THEN LET g_fap71=0  END IF
       IF cl_null(g_fap73) THEN LET g_fap73=0  END IF
       IF cl_null(g_fap74) THEN LET g_fap74=0  END IF
       IF cl_null(g_fap79) THEN LET g_fap79=0  END IF       #No.CHI-480001
END FUNCTION
 
{REPORT afar401_rep(sr)                                     #FUN-770052
   DEFINE l_last_sw    LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          sr           RECORD order1 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(30)
                              order2 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(30)
                              order3 LIKE faj_file.faj06,   #No.FUN-680070 VARCHAR(30)
                              faj04 LIKE faj_file.faj04,    # 資產分類
                              fab02 LIKE fab_file.fab02,    #
                              faj05 LIKE faj_file.faj05,    # 資產分類
                              faj02 LIKE faj_file.faj02,    # 財產編號
                              faj022 LIKE faj_file.faj022,  # 財產附號
                              faj20 LIKE faj_file.faj20,    # 保管部門
                              faj21 LIKE faj_file.faj21,    # 存放位置
                              faf02 LIKE faf_file.faf02,    # 名稱
                              faj19 LIKE faj_file.faj19,    # 保管人
                              gen02 LIKE gen_file.gen02,    #
                              faj07 LIKE faj_file.faj07,    # 英文名稱
                              faj06 LIKE faj_file.faj06,    # 中文名稱
                              faj17 LIKE faj_file.faj17,    # 數量
                              faj58 LIKE faj_file.faj58,    # 銷帳數量
                              faj08 LIKE faj_file.faj08,    # 規格型號
                              faj27 LIKE faj_file.faj27,    # 折舊年月
                              faj64 LIKE faj_file.faj64,    # 耐用年限
                              faj62 LIKE faj_file.faj62,    # 本幣成本
                              faj63 LIKE faj_file.faj63,    # 調整成本
                             #faj59 LIKE faj_file.faj59,    # 銷帳成本  #CHI-A30006 mark
                              faj69 LIKE faj_file.faj69,    # 銷帳成本   #CHI-A30006 add
                              faj67 LIKE faj_file.faj67,    # 累績折舊
                              faj43 LIKE faj_file.faj43,
                              faj74 LIKE faj_file.faj74,
                              faj741 LIKE faj_file.faj741,
                              faj100 LIKE faj_file.faj100,
                              faj60 LIKE faj_file.faj60,    # 銷帳累折
                              tmp01 LIKE faj_file.faj60,    # 數量
                              tmp02 LIKE faj_file.faj60,    # 成本
                              tmp03 LIKE faj_file.faj60,    # 前期累折
                              tmp04 LIKE faj_file.faj60,    # 本期累折
                              tmp05 LIKE faj_file.faj60,    # 累積折舊
                              tmp06 LIKE faj_file.faj60,    # 帳面價值
                              #No.CHI-480001
                              tmp07 LIKE faj_file.faj60,    # 減值準備
                              tmp08 LIKE faj_file.faj60,    # 資產淨額
                              faj103 LIKE faj_file.faj103,  # 減值準備
                              faj104 LIKE faj_file.faj104,  # 銷帳減值
                              faj22  LIKE faj_file.faj22    #MOD-770015
                                  #end
                       END RECORD,
      l_sts        LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(08)
      l_chr        LIKE type_file.chr1          #No.FUN-680070 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
# No: FUN-580010 --start--
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=tm.yy1 USING '####',g_x[26] CLIPPED,tm.mm1 USING '##',g_x[27]
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],
            g_x[58],g_x[59],g_x[60],g_x[61],g_x[62],g_x[63],g_x[64],
            g_x[65],g_x[66],g_x[67],g_x[68],g_x[69]
      PRINT g_dash1
# No: FUN-580010 --end--
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
         CASE
            WHEN sr.faj43 = '0' LET l_sts = g_x[50] clipped
            WHEN sr.faj43 = '1' LET l_sts = g_x[40] clipped
            WHEN sr.faj43 = '2' LET l_sts = g_x[41] clipped
            WHEN sr.faj43 = '4' LET l_sts = g_x[42] clipped
            WHEN sr.faj43 = '5' LET l_sts = g_x[51] clipped
            WHEN sr.faj43 = '6' LET l_sts = g_x[52] clipped
            WHEN sr.faj43 = '7' LET l_sts = g_x[43] clipped
            OTHERWISE EXIT CASE
         END CASE
# No: FUN-580010 --start--
         PRINT COLUMN g_c[51],sr.fab02[1,12],
               COLUMN g_c[52],sr.faj02,
               COLUMN g_c[53],sr.faj022,
               COLUMN g_c[54],sr.faj20,
               COLUMN g_c[55],sr.gen02[1,8],
               COLUMN g_c[56],sr.faj07,
               COLUMN g_c[57],sr.faj06[1,25],
               COLUMN g_c[58],sr.faj17,
               COLUMN g_c[59],sr.faj08[1,20],
               COLUMN g_c[60],sr.faj27,
               COLUMN g_c[61],sr.faj64 USING '---&',g_x[19] clipped,
               COLUMN g_c[62],cl_numfor(sr.tmp02,62,g_azi03),   #成本
               COLUMN g_c[63],cl_numfor(sr.tmp03,63,g_azi04),   #前期
               COLUMN g_c[64],cl_numfor(sr.tmp04,64,g_azi04),   #本期折舊
               COLUMN g_c[65],cl_numfor(sr.tmp05,65,g_azi04),   #累折
               #No.CHI-480001
               COLUMN g_c[66],cl_numfor(sr.tmp06,66,g_azi04),   #帳面
               COLUMN g_c[67],sr.faf02,
               COLUMN g_c[68],l_sts,
               COLUMN g_c[69],cl_numfor(sr.tmp08,69,g_azi04)
             {  IF g_aza.aza26 = '2' THEN
                  PRINT COLUMN 246,cl_numfor(sr.tmp08,18,g_azi04),   #帳面
                        COLUMN 266,sr.faf02,
                        COLUMN 287,l_sts
               ELSE
                  PRINT COLUMN 246,sr.faf02,
                        COLUMN 267,l_sts
               END IF    }
               #end
 
#    AFTER GROUP OF sr.order1
#      IF tm.v[1,1] = 'Y'
#      THEN PRINT ' '
#           PRINT COLUMN 1,g_descripe[1],
#                 COLUMN g_c[62],cl_numfor(GROUP SUM(sr.tmp02),62,g_azi05),   #成本
#                 COLUMN g_c[63],cl_numfor(GROUP SUM(sr.tmp03),63,g_azi05),   #前期
#                 COLUMN g_c[64],cl_numfor(GROUP SUM(sr.tmp04),64,g_azi05),   #本期折舊
#                 COLUMN g_c[65],cl_numfor(GROUP SUM(sr.tmp05),65,g_azi05),   #累折
#               #No.CHI-480001
#                 COLUMN g_c[66],cl_numfor(GROUP SUM(sr.tmp06),66,g_azi05),   #帳面
#                 COLUMN g_c[69],cl_numfor(GROUP SUM(sr.tmp08),69,g_azi05)
#           {      COLUMN 146,cl_numfor(GROUP SUM(sr.tmp02),18,g_azi05),
#                 COLUMN 166,cl_numfor(GROUP SUM(sr.tmp03),18,g_azi05),
#                 COLUMN 186,cl_numfor(GROUP SUM(sr.tmp04),18,g_azi05),
#                 COLUMN 206,cl_numfor(GROUP SUM(sr.tmp05),18,g_azi05),
#                 #No.CHI-480001
#                 COLUMN 226,cl_numfor(GROUP SUM(sr.tmp06),18,g_azi05);
#                 IF g_aza.aza26 = '2' THEN
#                    PRINT COLUMN 246,cl_numfor(GROUP SUM(sr.tmp08),18,g_azi05)
#                 ELSE
#                    PRINT
#                 END IF    }
#                 #end
#           PRINT
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.v[2,2] = 'Y'
#      THEN PRINT ' '
#           PRINT COLUMN 1,g_descripe[2],
#                 COLUMN g_c[62],cl_numfor(GROUP SUM(sr.tmp02),62,g_azi05),   #成
#                 COLUMN g_c[63],cl_numfor(GROUP SUM(sr.tmp03),63,g_azi05),   #前
#                 COLUMN g_c[64],cl_numfor(GROUP SUM(sr.tmp04),64,g_azi05),   #本
#                 COLUMN g_c[65],cl_numfor(GROUP SUM(sr.tmp05),65,g_azi05),   #累
#               #No.CHI-480001
#                 COLUMN g_c[66],cl_numfor(GROUP SUM(sr.tmp06),66,g_azi05),   #帳
#                 COLUMN g_c[69],cl_numfor(GROUP SUM(sr.tmp08),69,g_azi05)
#            {     COLUMN 146,cl_numfor(GROUP SUM(sr.tmp02),18,g_azi05),
#                 COLUMN 166,cl_numfor(GROUP SUM(sr.tmp03),18,g_azi05),
#                 COLUMN 186,cl_numfor(GROUP SUM(sr.tmp04),18,g_azi05),
#                 COLUMN 206,cl_numfor(GROUP SUM(sr.tmp05),18,g_azi05),
#                 #No.CHI-480001
#                 COLUMN 226,cl_numfor(GROUP SUM(sr.tmp06),18,g_azi05);
#                 IF g_aza.aza26 = '2' THEN
#                    PRINT COLUMN 246,cl_numfor(GROUP SUM(sr.tmp08),18,g_azi05)
#                 ELSE
#                    PRINT
#                 END IF     }
#                 #end
#           PRINT
#        #PRINT g_dash1[1,g_len]
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.v[3,3] = 'Y'
#      THEN PRINT ' '
#           PRINT g_descripe[3],
#                 COLUMN g_c[62],cl_numfor(GROUP SUM(sr.tmp02),62,g_azi05),   #成
#                 COLUMN g_c[63],cl_numfor(GROUP SUM(sr.tmp03),63,g_azi05),   #前
#                 COLUMN g_c[64],cl_numfor(GROUP SUM(sr.tmp04),64,g_azi05),   #本
#                 COLUMN g_c[65],cl_numfor(GROUP SUM(sr.tmp05),65,g_azi05),   #累
#               #No.CHI-480001
#                 COLUMN g_c[66],cl_numfor(GROUP SUM(sr.tmp06),66,g_azi05),   #帳
#                 COLUMN g_c[69],cl_numfor(GROUP SUM(sr.tmp08),69,g_azi05)
#            PRINT
#         {        COLUMN 146,cl_numfor(GROUP SUM(sr.tmp02),18,g_azi05),
#                 COLUMN 166,cl_numfor(GROUP SUM(sr.tmp03),18,g_azi05),
#                 COLUMN 186,cl_numfor(GROUP SUM(sr.tmp04),18,g_azi05),
#                 COLUMN 206,cl_numfor(GROUP SUM(sr.tmp05),18,g_azi05),
#                 #No.CHI-480001
#                 COLUMN 226,cl_numfor(GROUP SUM(sr.tmp06),18,g_azi05);
#                 IF g_aza.aza26 = '2' THEN
#                    PRINT COLUMN 246,cl_numfor(GROUP SUM(sr.tmp08),18,g_azi05)
#                 ELSE
#                    PRINT
#                 END IF   }
#                 #end
#           PRINT
#      END IF
# No: FUN-580010 --end--
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT}                                                         #FUN-770052
#Patch....NO.TQC-610035 <> #

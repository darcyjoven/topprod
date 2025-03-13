# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrg300.4gl
# Descriptions...: 發票列印
# Date & Author..: 95/02/07 by Nick
# Modify.........: No.MOD-4B0196 04/11/18 By ching 訂金發票金額乘其比率
# Modify.........: No.FUN-530042 05/04/12 By Nicola 顯示發票號碼的檢查碼
# Modify.........: No.MOD-4C0042 05/04/28 By ching 訂金發票不印明細
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.TQC-5B0181 05/11/23 By yoyo 有中文寫死的地方
# Modify.........: No.FUN-5B0139 05/12/05 By ice 有發票待扺時,報表應負值呈現對應的待扺資料
# Modify.........: No.MOD-620006 06/02/10 By Smapmin 發票金額修正
# Modify.........: No.TQC-660010 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.FUN-720053 07/02/28 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730113 07/03/26 By Nicole 增加CR參數
# Modify.........: No.MOD-810057 08/01/17 By Smapmin 單身發票金額omb18應為發票數量omb12*發票單價omb17
# Modify.........: No.FUN-820021 08/02/20 By baofei 改成子報表的寫法 
# Modify.........: No.MOD-840365 08/04/24 By hellen 多張應收帳款合并開立發票時，本幣發票未稅金額oma59，本幣發票稅額oma59t，本幣發票含稅金額oma59x，未匯總顯示
# Modify.........: No.FUN-860063 08/06/17 By Carol 民國年欄位放大
# Modify.........: No.FUN-870171 08/07/31 By chenmoyan 改變零時表中year的定義，使此欄位與相應的變量類型相同
# Modify.........: No.MOD-890027 08/09/04 By Sarah 1.若oma213='Y'時LET sr.omb18 = sr.omb12 * sr.omb17,否則直接抓取單身sr.omb18
#                                                  2.若oma01不同時才需要累加l_sum59,l_sum59x,l_sum59t
# Modify.........: No.MOD-8A0116 08/10/16 By Sarah 發票未稅金額(omb18)直接抓憑證資料顯示,最後一筆用單頭總額累減方式計算
# Modify.........: No.MOD-890122 08/10/21 By Sarah 1.報表一頁最多四筆明細
#                                                  2.未稅金額,稅額,合計採單張計算,不累計
# Modify.........: No.MOD-8C0099 08/12/15 By Sarah 未稅金額,稅額,合計最後一頁為總計金額
# Modify.........: No.FUN-8C0083 09/03/20 By Sarah CR Temptable增加omb01,omb03欄位,報表改以ome01,omb01,omb03排序
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼 
# Modify.........: No:MOD-A50054 10/05/13 By sabrina 發票金額會依應收比率不同而呈現不同金額 
# Modify.........: No:MOD-A60065 10/06/10 By Dido l_per 預設為 100 
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No:CHI-A70015 10/07/06 By Nicola 需考慮無訂單出貨
# Modify.........: No:CHI-A70056 10/08/02 By Summer ome01增加開窗選項,對應為q_ome
# Modify.........: No:MOD-B30640 11/03/22 By Dido omeprsw 累計有誤 
# Modify.........: No:FUN-B40097 11/05/19 By chenying 憑證類報表轉GRW
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B90130 11/12/12 By wujie  增加oma75的条件
# Modify.........: No:FUN-C10036 12/01/12 By yangtt MOD-B80247、MOD-BB0201追單
# Modify.........: No:FUN-C10036 12/01/12 By qirl CHI-B80052追單
# Modify.........: No:FUN-C10036 12/02/02 By yangtt MOD-B50168追單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD                         # Print condition RECORD
                   wc    LIKE type_file.chr1000, # Where condition #No.FUN-680123 VARCHAR(1000)
                   more  LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-680123 VARCHAR(01)
                  END RECORD
DEFINE g_i        LIKE type_file.num5            #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE l_table1   STRING                         #FUN-720053 add
DEFINE l_table2   STRING                         #FUN-720053 add
DEFINE g_sql      STRING                         #FUN-720053 add
DEFINE g_str      STRING                         #FUN-720053 add
 
###GENGRE###START
TYPE sr1_t RECORD
    ome01 LIKE ome_file.ome01,
    ome042 LIKE ome_file.ome042,
    ome043 LIKE ome_file.ome043,
    ome044 LIKE ome_file.ome044,
    omb06 LIKE omb_file.omb06,
    omb12 LIKE omb_file.omb12,
    omb17 LIKE omb_file.omb17,
    omb18 LIKE omb_file.omb18,
    chkcode LIKE type_file.num5,
    year LIKE type_file.chr3,
    month LIKE type_file.chr2,
    day LIKE type_file.chr2,
    tax LIKE type_file.chr1,
    oma59 LIKE oma_file.oma59,
    oma59x LIKE oma_file.oma59x,
    oma59t LIKE oma_file.oma59t,
    tot1 LIKE type_file.chr1,
    tot2 LIKE type_file.chr1,
    tot3 LIKE type_file.chr1,
    tot4 LIKE type_file.chr1,
    tot5 LIKE type_file.chr1,
    tot6 LIKE type_file.chr1,
    tot7 LIKE type_file.chr1,
    tot8 LIKE type_file.chr1,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    omb01 LIKE omb_file.omb01,
    omb03 LIKE omb_file.omb03
END RECORD

TYPE sr2_t RECORD
    ome01 LIKE ome_file.ome01,
    omb06 LIKE omb_file.omb06,
    omb12 LIKE omb_file.omb12,
    omb17 LIKE omb_file.omb17,
    omb18 LIKE omb_file.omb18
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   LET g_sql = "ome01.ome_file.ome01,  ome042.ome_file.ome042,",
               "ome043.ome_file.ome043,ome044.ome_file.ome044,",
               "omb06.omb_file.omb06,  omb12.omb_file.omb12,",
               "omb17.omb_file.omb17,  omb18.omb_file.omb18,",
               "chkcode.type_file.num5,year.type_file.chr3,",  #No.FUN-870171 year chr2->chr3
               "month.type_file.chr2,  day.type_file.chr2,",
               "tax.type_file.chr1,    oma59.oma_file.oma59,",
               "oma59x.oma_file.oma59x,oma59t.oma_file.oma59t,",
               "tot1.type_file.chr1,   tot2.type_file.chr1,",
               "tot3.type_file.chr1,   tot4.type_file.chr1,",
               "tot5.type_file.chr1,   tot6.type_file.chr1,",
               "tot7.type_file.chr1,   tot8.type_file.chr1,",
               "azi03.azi_file.azi03,  azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,  omb01.omb_file.omb01,",  #FUN-8C0083 add omb01
               "omb03.omb_file.omb03"                           #FUN-8C0083 add omb03
   LET l_table1= cl_prt_temptable('axrg3001',g_sql) CLIPPED  
   IF l_table1= -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B40097
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)      #FUN-B40097
      EXIT PROGRAM 
   END IF                
 
   LET g_sql = "ome01.ome_file.ome01,",
               "omb06.omb_file.omb06,",
               "omb12.omb_file.omb12,",
               "omb17.omb_file.omb17,",
               "omb18.omb_file.omb18"
   LET l_table2= cl_prt_temptable('axrg3002',g_sql) CLIPPED  
   IF l_table2= -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B40097
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)      #FUN-B40097
      EXIT PROGRAM 
   END IF                

   DROP TABLE g300_tmp
   CREATE TEMP TABLE g300_tmp
     (ome01   LIKE ome_file.ome01,
      ome042  LIKE ome_file.ome042,
      ome043  LIKE ome_file.ome043,
      ome044  LIKE ome_file.ome044,
      omb06   LIKE omb_file.omb06,
      omb12   LIKE omb_file.omb12,
      omb17   LIKE omb_file.omb17,
      omb18o  LIKE omb_file.omb18,
      omb18   LIKE omb_file.omb18,
      omb18x  LIKE omb_file.omb18t,
      omb18t  LIKE omb_file.omb18t,
      chkcode LIKE type_file.num5,
      year    LIKE type_file.chr3,
      month   LIKE type_file.chr2,
      day     LIKE type_file.chr2,
      tax     LIKE type_file.chr1,
      page    LIKE type_file.num5,
      omb01   LIKE omb_file.omb01,   #FUN-8C0083 add
      omb03   LIKE omb_file.omb03,   #FUN-8C0083 add
      oma212  LIKE oma_file.oma212,  #FUN-C10036 add
      oma213  LIKE oma_file.oma213)  #FUN-C10036 add
   CREATE unique index g300_tmp_01 on g300_temp(ome01,omb06);
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
 
   IF cl_null(tm.wc) THEN
      CALL axrg300_tm(0,0)
   ELSE
      CALL axrg300()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
   CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)
END MAIN
 
FUNCTION axrg300_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,     #No.FUN-580031
          p_row,p_col    LIKE type_file.num5,     #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(1000)
 
   LET p_row = 6 LET p_col = 15
 
   OPEN WINDOW axrg300_w AT p_row,p_col WITH FORM "axr/42f/axrg300"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ome212,ome05,ome02,ome00,omeuser,ome01
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         #CHI-A70056 add --start--
         ON ACTION controlp
            CASE
               WHEN INFIELD(ome01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ome"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ome01
                  NEXT FIELD ome01
            END CASE
         #CHI-A70056 add --end--
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axrg300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axrg300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axrg300'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axrg300','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axrg300',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axrg300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axrg300()
      ERROR ""
   END WHILE
   CLOSE WINDOW axrg300_w
 
END FUNCTION
 
FUNCTION axrg300()
   DEFINE l_name    LIKE type_file.chr20,     # External(Disk) file name  #No.FUN-680123 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(40)
          sr        RECORD
                     occ18     LIKE occ_file.occ18,
                     occ231    LIKE occ_file.occ231,
                     ome03     LIKE ome_file.ome03,    #No.FUN-B90130
                     ome04     LIKE ome_file.ome04,
                     ome042    LIKE ome_file.ome042,
                     ome043    LIKE ome_file.ome043,
                     ome044    LIKE ome_file.ome044,
                     ome02     LIKE ome_file.ome02,
                     ome01     LIKE ome_file.ome01,
                     ome21     LIKE ome_file.ome21,
                     ome59x    LIKE ome_file.ome59x,     #No.FUN-680123 DEC(20,6)
                     omeprsw   LIKE ome_file.omeprsw,
                     omb06     LIKE omb_file.omb06,
                     omb12     LIKE omb_file.omb12,
                     omb17     LIKE omb_file.omb17,
                     omb18     LIKE omb_file.omb18,
                     omb18x    LIKE omb_file.omb18t,     #MOD-890122 add
                     omb18t    LIKE omb_file.omb18t,     #MOD-890122 add
                     occ11     LIKE occ_file.occ11,
                     chkcode   LIKE type_file.num5,      #No.FUN-680123 SMALLINT 
                     omb01     LIKE omb_file.omb01,      #FUN-8C0083 add
                     omb03     LIKE omb_file.omb03       #FUN-8C0083 add
                    END RECORD,
          sr1       RECORD                               #MOD-890122 add
                     ome01     LIKE ome_file.ome01,
                     ome042    LIKE ome_file.ome042,
                     ome043    LIKE ome_file.ome043,
                     ome044    LIKE ome_file.ome044,
                     omb06     LIKE omb_file.omb06,
                     omb12     LIKE omb_file.omb12,
                     omb17     LIKE omb_file.omb17,
                     omb18o    LIKE omb_file.omb18,
                     omb18     LIKE omb_file.omb18,
                     omb18x    LIKE omb_file.omb18t,
                     omb18t    LIKE omb_file.omb18t,
                     chkcode   LIKE type_file.num5,
                     year      LIKE type_file.chr3,
                     month     LIKE type_file.chr2,
                     day       LIKE type_file.chr2,
                     tax       LIKE type_file.chr1,
                     l_page    LIKE type_file.num5,
                     omb01     LIKE omb_file.omb01,      #FUN-8C0083 add
                     omb03     LIKE omb_file.omb03,      #FUN-8C0083 add
                     oma212    LIKE oma_file.oma212,     #FUN-C10036 add
                     oma213    LIKE oma_file.oma213      #FUN-C10036 add
                    END RECORD
   DEFINE l_n       LIKE type_file.num5,    
          l1_n      LIKE type_file.num5,    
          l1_omb18  LIKE omb_file.omb18,
          sr2       RECORD
                     omb06     LIKE omb_file.omb06,
                     omb12     LIKE omb_file.omb12,
                     omb17     LIKE omb_file.omb17,
                     omb18     LIKE omb_file.omb18
                    END RECORD,
          l_year    LIKE type_file.chr3,       #FUN-860063-modify chr2->chr3
          l_month   LIKE type_file.chr2,  
          l_day     LIKE type_file.chr2,  
          l_tot     LIKE type_file.chr8,    
          l_oma00   LIKE oma_file.oma00,   
          l_oma161  LIKE oma_file.oma161,  
          l_oma162  LIKE oma_file.oma162,     #MOD-A50054 add   
          l_oma163  LIKE oma_file.oma163,     #MOD-A50054 add  
        # l_per     LIKE oma_file.oma161,     #MOD-A50054 add
          l_per     LIKE oea_file.oea261,     #MOD-A50054 add    #No:FUN-A50103
          l_per1    LIKE oea_file.oea261,    #No:FUN-A50103
          l_oma16   LIKE oma_file.oma16,     #No:FUN-A50103
          l_omb18   LIKE omb_file.omb18,
          l_i       LIKE type_file.num5,   
          l_num     LIKE type_file.num5,   
          l_tax     LIKE type_file.chr1,   
          l_oma59   LIKE oma_file.oma59,       #單頭發票金額
          l_oma59x  LIKE oma_file.oma59x,      #單頭發票稅額
          l_oma59t  LIKE oma_file.oma59t,      #單頭發票稅額
          l_oma01   LIKE oma_file.oma01,       #帳款編號     #MOD-890027 add
          l_oma01_o LIKE oma_file.oma01,       #帳款編號舊值 #MOD-890027 add
          l_oma212  LIKE oma_file.oma212,                    #FUN-C10036 add
          l_oma213  LIKE oma_file.oma213,      #含稅否       #MOD-890027 add
          l_oea213  LIKE oea_file.oea213,      #含稅否       #FUN-C10036 add
          l_p       LIKE type_file.num20_6,  
          l_j       LIKE type_file.num20_6,    #MOD-A50054 add  
          t_omb18   LIKE omb_file.omb18,       #MOD-A50054 add
          t_omb18x  LIKE omb_file.omb18,       #MOD-A50054 add
          t_omb18t  LIKE omb_file.omb18t,       #MOD-A50054 add
          l_cnt     LIKE type_file.num5,     
          l_cnt2    LIKE type_file.num5,       #單身總筆數
          l_sum     LIKE omb_file.omb18        #單身發票金額累計
   DEFINE l_total   ARRAY[8] OF RECORD
                     num  LIKE type_file.chr1
                    END RECORD
   DEFINE l_sum59   LIKE oma_file.oma59       #本幣發票稅前金額合計
   DEFINE l_sum59x  LIKE oma_file.oma59x      #本幣發票稅額合計
   DEFINE l_sum59t  LIKE oma_file.oma59t      #本幣發票含稅金額合計
   DEFINE l_psum18  LIKE omb_file.omb18,      #單頁本幣發票稅前金額合計
          l_psum18x LIKE omb_file.omb18t,     #單頁本幣發票稅額合計
          l_psum18t LIKE omb_file.omb18t,     #單頁本幣發票含稅金額合計
          l_page    LIKE type_file.num5,
          l_cntp    LIKE type_file.num5,
          l_omb18o  LIKE omb_file.omb18,      #含稅發票原始單身omb18
          l_ome01_o LIKE ome_file.ome01,
          l_maxpage LIKE type_file.num5       #MOD-8C0099 add

   DELETE FROM g300_tmp   #MOD-890122 add   
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"  #FUN-8C0083 add 2?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)      #FUN-B40097
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)      #FUN-B40097
      EXIT PROGRAM
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrg300'
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omeuser', 'omegrup')
 
 
   LET l_sql="SELECT occ18,occ231,ome03,ome04,ome042,ome043,ome044,ome02,ome01, ",  #No.FUN-B90130 add ome03
#將FOREACH中對oma00,oma161,oma59,oma59x,oma59t的撈取，放在這個sql里，防止有多筆
             "       ome21,ome59x,omeprsw,omb06,omb12,omb17,omb18,",
             "       omb18t-omb18,omb18t,",   #MOD-890122 add
             "       occ11,'', ",
             "       omb01,omb03,",   #FUN-8C0083 add
            #"       oma00,oma161,oma59,oma59x,oma59t,oma01,oma213,",        #MOD-890027 add oma01,oma213 #MOD-B50168 mark
            #"       oma00,oma161,ome59,ome59x,ome59t,oma01,oma213,",        #MOD-890027 add oma01,oma213 #MOD-B50168 #FUN-C10036 mark
             "       oma00,oma161,ome59,ome59x,ome59t,oma01,oma212,oma213,", #FUN-C10036 add oma212
             "       oma162,oma163,oma16 ",         #MOD-A50054 add    #No:FUN-A50103
             #----------------------------------------------FUN-C10036------------------------------------start
            #"  FROM ome_file,occ_file,oma_file,omb_file ",
            #" WHERE ome01=oma_file.oma10 AND oma_file.oma01=omb_file.omb01 AND ome04=occ_file.occ01 ",
            #"   AND omevoid = 'N'",
            #"   AND ",tm.wc CLIPPED,
             "  FROM ome_file LEFT OUTER JOIN occ_file ON occ_file.occ01 = ome_file.ome04 ",
             "  LEFT OUTER JOIN ( SELECT oma10,omb06,omb12,omb17,omb18,omb18t-omb18,omb18t,omb01, ",
             "                           omb03,oma00,oma161,oma01,oma212,oma213,oma162,oma163,oma16 ",
             "                      FROM oma_file,omb_file  WHERE oma01 = omb01) tmp ",
             "       ON ome_file.ome01=tmp.oma10 WHERE ",tm.wc CLIPPED,
            #----------------------------------------------FUN-C10036--------------------------------------end
            #" ORDER BY ome01,omb06,oma01"   #MOD-890027 add oma01     #FUN-C10036 FROM MOD-B50168 mark
             " ORDER BY ome01,omb01,omb03"     #FUN-C10036 FROM MOD-B50168
 
   PREPARE axrg300_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
 
   DECLARE axrg300_curs1 CURSOR FOR axrg300_prepare1
 
#  DISPLAY "prog:",g_prog   #FUN-C10036 FROM MOD-B50168 mark
 
   LET l_sum59  = 0   LET l_sum59x = 0   LET l_sum59t = 0   #add by hellen
   LET l_page   = 0                      #FUN-C10036 FROM MOD-B50168  mod 1 -> 0                      
   LET l_cntp   = 1                      #MOD-890122 add
   LET l_oma01_o = ' '   #MOD-890027 add
   LET l_ome01_o = ' '   #MOD-A50054 add
   FOREACH axrg300_curs1 INTO sr.*,l_oma00,l_oma161,l_oma59,l_oma59x,l_oma59t
                                  ,l_oma01,l_oma212,l_oma213,l_oma162,l_oma163,l_oma16   #MOD-890027 add  #MOD-A50054 add l_oma162,l_oma163    #No:FUN-A50103 #FUN-C10036 add oma212
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      CALL s_chkinvoice(sr.ome01) RETURNING sr.chkcode   #No.FUN-530042
      LET sr.chkcode = sr.chkcode USING '&&'             #No.FUN-720053
 
      IF sr.ome04 != 'MISC' THEN
         LET sr.ome042 = sr.occ11
         LET sr.ome043 = sr.occ18
         LET sr.ome044 = sr.occ231
      END IF
 
      LET l_year = YEAR(sr.ome02)-1911 USING '&&&'   #FUN-860063-modify
      LET l_month = MONTH(sr.ome02) USING '&&'
      LET l_day = DAY(sr.ome02) USING '&&'
      LET l_cnt2 = 0  
      LET l_sum  = 0  
      LET l_n = 0     
      LET l1_omb18 = 0
 
      IF l_oma00 = '12' THEN 
#No.FUN-B90130 --begin 
         IF g_aza.aza26 ='2' THEN 
            SELECT COUNT(*) INTO l_cnt FROM omb_file,oma_file
             WHERE oma01=omb01 AND oma10=sr.ome01 
               AND oma75 = sr.ome03 
         ELSE
            SELECT COUNT(*) INTO l_cnt FROM omb_file,oma_file
             WHERE oma01=omb01 AND oma10=sr.ome01  
         END IF   
#No.FUN-B90130 --end
         SELECT COUNT(*) INTO l_cnt FROM omb_file,oma_file
          WHERE oma01=omb01 AND oma10=sr.ome01
         LET l_cnt2 = l_cnt2 + 1
         LET l_sum  = l_sum + sr.omb18
         IF l_cnt2 >= l_cnt THEN
            LET sr.omb18 = sr.omb18 + (l_oma59 - l_sum)
         END IF
         #只有大陸功能才有發票待扺
         IF g_aza.aza26 = '2' THEN
            SELECT COUNT(*) INTO l1_n
              FROM omb_file
             WHERE omb01 IN (SELECT DISTINCT oma01
              FROM oma_file
             WHERE oma10 = sr.ome01 AND oma75 = sr.ome03 )   #No.FUN-B90130
            IF l1_n = l_n + 1 THEN
               LET l_sql = "SELECT omb06,-omb12,omb17,-omb18 ",
                           "  FROM omb_file ",
                           " WHERE omb01 IN (SELECT DISTINCT oot01 ",
                           "  FROM oot_file ",
                           " WHERE oot03 IN (SELECT DISTINCT oma01 ",
                           "  FROM oma_file ",
                           " WHERE oma10 = '",sr.ome01,"' AND oma75 ='",sr.ome03,"')) ",  #No.FUN-B90130 
                        #  " ORDER BY omb06 "       #FUN-C10036 FROM MOD-B50168 mark
                           " ORDER BY omb01,omb03"  #FUN-C10036 FROM MOD-B50168
               PREPARE g300_prepare_omb FROM l_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('g300_prepare_omb:',SQLCA.sqlcode,1) RETURN
               END IF
               DECLARE axrg300_cur2 CURSOR FOR g300_prepare_omb
               FOREACH axrg300_cur2 INTO sr2.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,1)
                     EXIT FOREACH
                  END IF
                  IF l_oma213 = 'Y' THEN   #MOD-890027 add
                     LET sr2.omb18 = sr2.omb12 * sr2.omb17   #MOD-810057
                  END IF                   #MOD-890027 add
                  EXECUTE insert_prep2 USING  sr.ome01,sr2.*
                  LET l1_omb18 = l1_omb18 + sr2.omb18
               END FOREACH
            END IF
            LET l_n = l_n + 1
         END IF
      END IF  
 
      SELECT gec06 INTO l_tax FROM gec_file
       WHERE gec01 = sr.ome21
         AND gec011 = '2'  #銷項
 
     #MOD-A50054---add---start---
      LET l_per = 100             #MOD-A60065
      #-----No:FUN-A50103-----
      LET l_per1 = 100
      #-FUN-C10036-add-
      IF l_oma00 = '11' OR l_oma00 = '13' THEN
         SELECT oea213 INTO l_oea213
           FROM oea_file
          WHERE oea01 = l_oma16
      END IF
      IF l_oma00 = '12' THEN
         SELECT oea213 INTO l_oea213
           FROM oea_file,oga_file
          WHERE oea01 = oga16
            AND oga01 = l_oma16
      END IF
      IF l_oma213 <> l_oea213 THEN
         LET l_oma213 = l_oea213
      END IF
     #-FUN-C10036-end-
      CASE l_oma00
         WHEN '11'
            IF l_oma213 = "Y" THEN
               SELECT oea261,oea1008 INTO l_per,l_per1
                 FROM oea_file
                WHERE oea01 = l_oma16
            ELSE
               SELECT oea261,oea61 INTO l_per,l_per1
                 FROM oea_file
                WHERE oea01 = l_oma16
            END IF
         WHEN '12'
            IF l_oma213 = "Y" THEN
               SELECT oea262,oea1008 INTO l_per,l_per1
                 FROM oea_file,oga_file
                WHERE oea01 = oga16
                  AND oga01 = l_oma16
            ELSE
               SELECT oea262,oea61 INTO l_per,l_per1
                 FROM oea_file,oga_file
                WHERE oea01 = oga16
                  AND oga01 = l_oma16
            END IF
         WHEN '13'
            IF l_oma213 = "Y" THEN
               SELECT oea263,oea1008 INTO l_per,l_per1
                 FROM oea_file
                WHERE oea01 = l_oma16
            ELSE
               SELECT oea263,oea61 INTO l_per,l_per1
                 FROM oea_file
                WHERE oea01 = l_oma16
            END IF
      END CASE
 
      #-----No:CHI-A70015-----
      IF cl_null(l_per) THEN
         LET l_per = 100
      END IF

      IF cl_null(l_per1) THEN
         LET l_per1 = 100
      END IF
      #-----No:CHI-A70015 END-----
      
     #CASE l_oma00
     #   WHEN '11'
     #      LET l_per = l_oma161
     #   WHEN '12'
     #      LET l_per = l_oma162
     #   WHEN '13'
     #      LET l_per = l_oma163
     #END CASE
     ##-----No:FUN-A50103 END-----
      IF l_ome01_o != sr.ome01 THEN
#No.FUN-B90130 --begin  
         IF g_aza.aza26 ='2' THEN 
            SELECT COUNT(*) INTO l_cnt  FROM ome_file,oma_file,omb_file 
             WHERE ome01 = sr.ome01 AND ome01 = oma10 AND oma01 = omb01 AND ome03 = sr.ome03 AND ome03 = oma75  
         ELSE 
            SELECT COUNT(*) INTO l_cnt  FROM ome_file,oma_file,omb_file 
             WHERE ome01 = sr.ome01 AND ome01 = oma10 AND oma01 = omb01
         END IF 
#No.FUN-B90130 --end 
         LET l_j = 1
         LET t_omb18 = 0
         LET t_omb18x = 0
         LET t_omb18t = 0
      END IF 
     #LET sr.omb12 = (sr.omb12 * l_per) / 100  
      LET sr.omb12 = (sr.omb12 * l_per) / l_per1    #No:FUN-A50103
      IF l_j = l_cnt THEN
         LET sr.omb18 = l_oma59 - t_omb18
         CALL cl_digcut(sr.omb18,g_azi04) RETURNING sr.omb18
      #  LET sr.omb18x = l_oma59 - t_omb18x    #FUN-C10036 FROM MOD-B50168 mark
         LET sr.omb18x = l_oma59x - t_omb18x   #FUN-C10036 FROM MOD-B50168 
         CALL cl_digcut(sr.omb18x,g_azi04) RETURNING sr.omb18x
      #  LET sr.omb18t = l_oma59 - t_omb18t    #FUN-C10036 FROM MOD-B50168 mark
         LET sr.omb18t = l_oma59t - t_omb18t   #FUN-C10036 FROM MOD-B50168
         CALL cl_digcut(sr.omb18t,g_azi04) RETURNING sr.omb18t
      ELSE
        #LET sr.omb18 = (sr.omb18 * l_per) / 100
         LET sr.omb18 = (sr.omb18 * l_per) / l_per1    #No:FUN-A50103
         CALL cl_digcut(sr.omb18,g_azi04) RETURNING sr.omb18
        #LET sr.omb18x = (sr.omb18x * l_per) / 100 
         LET sr.omb18x = (sr.omb18x * l_per) / l_per1    #No:FUN-A50103
         CALL cl_digcut(sr.omb18x,g_azi04) RETURNING sr.omb18x
         LET sr.omb18t = sr.omb18 + sr.omb18x 
         CALL cl_digcut(sr.omb18t,g_azi04) RETURNING sr.omb18t
         LET t_omb18 = t_omb18 + sr.omb18
         LET t_omb18x = t_omb18x + sr.omb18x
         LET t_omb18t = t_omb18t + sr.omb18t
         LET l_j = l_j + 1
      END IF
     #MOD-A50054---add---end---
      LET l_omb18o = sr.omb18  #MOD-890122 add  #含稅發票原始單身omb18
      IF l_oma213 = 'Y' THEN   #MOD-890027 add  #含稅
         LET sr.omb18x= sr.omb18t- sr.omb18   #MOD-890122 add
         LET sr.omb18 = sr.omb12 * sr.omb17   #MOD-810057
      END IF                   #MOD-890027 add
      IF sr.ome01 != l_ome01_o OR l_cntp > 4 THEN
         LET l_page = l_page + 1
         LET l_cntp = 1
      END IF

      INSERT INTO g300_tmp VALUES
         (sr.ome01, sr.ome042, sr.ome043,sr.ome044,sr.omb06,
          sr.omb12, sr.omb17,  l_omb18o, sr.omb18, sr.omb18x,
          sr.omb18t,sr.chkcode,l_year,   l_month,  l_day,
          l_tax,    l_page,    sr.omb01, sr.omb03,   #FUN-8C0083 add sr.omb01,sr.omb03
          l_oma212,l_oma213)                         #FUN-C10036 add 
 
      LET l_ome01_o = sr.ome01
      LET l_cntp = l_cntp + 1
   END FOREACH
 
   LET l_psum18 = 0   LET l_psum18x= 0   LET l_psum18t= 0   #MOD-890122 add
   LET l_ome01_o = ' '   #MOD-B30640
   DECLARE g300_tmp_cs CURSOR FOR
      SELECT * FROM g300_tmp ORDER BY ome01,omb01,omb03   #FUN-8C0083
   FOREACH g300_tmp_cs INTO sr1.*
      SELECT MAX(page) INTO l_maxpage FROM g300_tmp
       WHERE ome01=sr1.ome01
      IF sr1.l_page != l_maxpage THEN
         #不是最後一頁的話,就呈現各頁合計
         SELECT SUM(omb18o),SUM(omb18x),SUM(omb18t)
           INTO l_psum18,l_psum18x,l_psum18t
           FROM g300_tmp
          WHERE ome01=sr1.ome01
            AND page =sr1.l_page
      ELSE
         #最後一頁的話,就呈現總合計
         SELECT SUM(omb18o),SUM(omb18x),SUM(omb18t)
           INTO l_psum18,l_psum18x,l_psum18t
           FROM g300_tmp
          WHERE ome01=sr1.ome01
      END IF
      LET l_tot = l_psum18t USING '&&&&&&&&'
      IF cl_null(l_tot) THEN
         LET l_tot = '00000000'
      END IF
 
      FOR l_i =1 to 8
         LET l_total[l_i].num = l_tot[l_i]
      END FOR
      LET g_i = g_i
     #------------------FUN-C10036---------------------start
      IF sr1.oma212 = '2' AND sr1.oma213 = 'Y' THEN
         LET l_psum18 = l_psum18t
         LET l_psum18x = 0
      END IF
     #------------------FUN-C10036---------------------end
 
      IF l_ome01_o != sr1.ome01 THEN  #MOD-B30640
         UPDATE ome_file SET omeprsw = omeprsw + 1
          WHERE ome01 = sr1.ome01
      END IF                          #MOD-B30640
      LET l_ome01_o = sr1.ome01       #MOD-B30640
 
      EXECUTE insert_prep1 USING
         sr1.ome01,  sr1.ome042,sr1.ome043,sr1.ome044,
         sr1.omb06,  sr1.omb12, sr1.omb17, sr1.omb18,
         sr1.chkcode,sr1.year,  sr1.month, sr1.day,
         sr1.tax,    l_psum18,  l_psum18x, l_psum18t,
         l_total[1].num,l_total[2].num,l_total[3].num,l_total[4].num,
         l_total[5].num,l_total[6].num,l_total[7].num,l_total[8].num,
         g_azi03,g_azi04,g_azi05,sr1.omb01,sr1.omb03   #FUN-8C0083 add sr1.omb01,sr1.omb03
 
   END FOREACH
 
   CALL cl_wcchp(tm.wc,'ome212,ome05,ome02,ome00,omeuser,ome01') 
        RETURNING tm.wc 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                        
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED                                                             
###GENGRE###   LET g_str = tm.wc
###GENGRE###   CALL cl_prt_cs3('axrg300','axrg300',g_sql,g_str)
    CALL axrg300_grdata()    ###GENGRE###
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION axrg300_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axrg300")
        IF handler IS NOT NULL THEN
            START REPORT axrg300_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " ORDER BY lower(ome01)"          #FUN-C10036 add lower()
            DECLARE axrg300_datacur1 CURSOR FROM l_sql
            FOREACH axrg300_datacur1 INTO sr1.*
                OUTPUT TO REPORT axrg300_rep(sr1.*)
            END FOREACH
            FINISH REPORT axrg300_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axrg300_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40097----add---str------------------
    DEFINE l_tot1   STRING
    DEFINE l_tot2   STRING
    DEFINE l_tot3   STRING
    DEFINE l_tot4   STRING
    DEFINE l_tot5   STRING
    DEFINE l_tot6   STRING
    DEFINE l_tot7   STRING
    DEFINE l_tot8   STRING
    DEFINE l_sql    STRING
    DEFINE l_omb18_fmt STRING
    DEFINE l_omb17_fmt STRING
    DEFINE l_oma59_fmt STRING
    DEFINE l_oma59x_fmt STRING
    DEFINE l_oma59t_fmt STRING
    #FUN-B40097----add---end-------------------
    ORDER EXTERNAL BY sr1.ome01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ome01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40097-----add----str------------
            LET l_omb18_fmt = cl_gr_numfmt('omb_file','omb18',g_azi04)
            PRINTX l_omb18_fmt
            LET l_omb17_fmt = cl_gr_numfmt('omb_file','omb17',g_azi03)
            PRINTX l_omb17_fmt
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE ome01 = '",sr1.ome01 CLIPPED,"'"
            START REPORT axrg300_subrep01
            DECLARE axrg300_repcur1 CURSOR FROM l_sql
            FOREACH axrg300_repcur1 INTO sr2.*
                OUTPUT TO REPORT axrg300_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axrg300_subrep01
            #FUN-B40097-----add----end------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.ome01
           #FUN-B40097----add---str----------------------
           LET l_oma59_fmt = cl_gr_numfmt('oma_file','oma59',g_azi04)
           PRINTX l_oma59_fmt
           LET l_oma59x_fmt = cl_gr_numfmt('oma_file','oma59x',g_azi04)
           PRINTX l_oma59x_fmt
           LET l_oma59t_fmt = cl_gr_numfmt('oma_file','oma59t',g_azi04)
           PRINTX l_oma59t_fmt 
           LET l_tot1 = cl_gr_getmsg("gre-029",g_lang,sr1.tot1)
           LET l_tot2 = cl_gr_getmsg("gre-029",g_lang,sr1.tot2)
           LET l_tot3 = cl_gr_getmsg("gre-029",g_lang,sr1.tot3)
           LET l_tot4 = cl_gr_getmsg("gre-029",g_lang,sr1.tot4)
           LET l_tot5 = cl_gr_getmsg("gre-029",g_lang,sr1.tot5)
           LET l_tot6 = cl_gr_getmsg("gre-029",g_lang,sr1.tot6)
           LET l_tot7 = cl_gr_getmsg("gre-029",g_lang,sr1.tot7)
           LET l_tot8 = cl_gr_getmsg("gre-029",g_lang,sr1.tot8)
           PRINTX  l_tot1     
           PRINTX  l_tot2     
           PRINTX  l_tot3     
           PRINTX  l_tot4     
           PRINTX  l_tot5     
           PRINTX  l_tot6     
           PRINTX  l_tot7     
           PRINTX  l_tot8     
           #FUN-B40097----add---end----------------------
 
        ON LAST ROW

END REPORT
###GENGRE###END

#FUN-B40097----add----str-------------
REPORT axrg300_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_omb18_fmt STRING
    DEFINE l_omb17_fmt STRING
    
    FORMAT
        ON EVERY ROW
            LET l_omb17_fmt = cl_gr_numfmt('omb_file','omb17',g_azi03)
            PRINTX l_omb17_fmt
            LET l_omb18_fmt = cl_gr_numfmt('omb_file','omb18',g_azi04)
            PRINTX l_omb18_fmt
            PRINTX sr2.*
END REPORT
#FUN-B40097---add---end-------------------

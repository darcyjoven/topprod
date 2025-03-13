# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmr761.4gl
# Descriptions...: 短期借款明細表(anmr761)
# Date & Author..: 99/02/02 By Billy
# 增加幣別,借款原幣,擔當行庫,LC號碼,且依到期日排序 02/01/22 LJC MOD
# Modify.........: No.FUN-4C0098 05/01/05 By pengu 報表轉XML
# Modify.........: No.FUN-550114 05/06/11 By echo 新增報表備註
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.MOD-5B0225 05/11/22 By Smapmin 小計與合計未依照小數位數取位
# Modify.........: No.MOD-650014 06/05/04 By Smapmin 修正SQL語法
# Modify.........: No.FUN-650184 06/06/15 By Smapmin 報表應採用餘額角度來看
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.TQC-680077 06/08/22 By Sarah anmr761_prepare2前面的l_sql有改變,但ora沒有隨之修改導致轉不成功
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-720033 06/11/06 By jamie 增加本幣合計
# Modify.........: No.CHI-7C0026 07/12/24 By Smapmin 增加是否列印餘額為零的選項
# Modify.........: No.FUN-830156 08/04/03 By Sunyanchun 老報表改CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-8B0166 08/11/18 By Sarah SQL增加排除作廢資料的條件
# Modify.........: No.MOD-8C0090 08/12/15 By Sarah 計算sr.nne20時,不需-l_nmd26_tot1
# Modify.........: No.MOD-960265 09/06/23 By mike 計算sr.nne20與sr.nne27時,改成只抓還款的本金 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40115 10/04/26 By Carrier MOD-990008追单
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-C90052 12/09/10 By lujh 1.tm.wc/l_buf 改為 STRING 宣告
#                                                 2.l_buf 改用 getlength 與 substring 應用
# Modify.........: No.MOD-D10119 13/01/15 By Polly 調整報表餘額抓取條件
# Modify.........: No.MOD-C90016 13/04/08 By apo l_sql改為STRING型態

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              #wc      LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(600) #Where Condiction   #TQC-C90052  mark
              wc      STRING,                    #TQC-C90052  add
              edate   LIKE type_file.dat,        #No.FUN-680107 DATE
              a       LIKE type_file.chr1,       #CHI-7C0026
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)   #
              END RECORD,
          g_day       LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          g_day01     LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          g_day02     LIKE type_file.num5        #No.FUN-680107 SMALLINT
 
   DEFINE g_i         LIKE type_file.num5        #count/index for any purpose #No.FUN-680107 SMALLINT
   DEFINE g_head1     STRING
   DEFINE g_sql       STRING
   DEFINE l_table     STRING
   DEFINE l_table1    STRING
   DEFINE l_table2    STRING
   DEFINE g_str       STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   #No.TQC-A40115  --Begin
   #FUN-830156-----END-------
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8)   #TQC-610058
   LET tm.a = ARG_VAL(9)   #CHI-7C0026
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF

   #FUN-830156-----BEGIN-----
   LET g_sql = "nne01.nne_file.nne01,",
               "nne02.nne_file.nne02,",
               "nne112.nne_file.nne112,",
       	       "alg01.alg_file.alg01,",
               "alg02.alg_file.alg02,", 
               "nnn02.nnn_file.nnn02,",
               "nne16.nne_file.nne16,", 
               "nne12.nne_file.nne12,",
               "nne19.nne_file.nne19,",                       
               "nne14.nne_file.nne14,",
               "t_alg02.alg_file.alg02,", 
               "nne15.nne_file.nne15,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05 "    #No.TQC-A40115

   LET l_table = cl_prt_temptable('anmr761',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
  
   #No.TQC-A40115  --Begin
   #LET g_sql = "nne112.nne_file.nne112,",
   #            "l_curr.nne_file.nne16,",
   #            "l_oamt.nne_file.nne12,",
   #            "l_lamt.nne_file.nne19,",
   #            "l_ramt.nne_file.nne20,", 
   #            "azi05.azi_file.azi05"  
   #LET l_table1 = cl_prt_temptable('anmr761_1',g_sql) CLIPPED                   
   #IF  l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #LET g_sql = "alg02.alg_file.alg02,",
   #            "l_curr.nne_file.nne16,",
   #            "l_oamt.nne_file.nne12,",
   #            "l_lamt.nne_file.nne19,",
   #            "l_ramt.nne_file.nne20,",
   #            "azi05.azi_file.azi05" 
   #LET l_table2 = cl_prt_temptable('anmr761_2',g_sql) CLIPPED                   
   #IF  l_table2 = -1 THEN EXIT PROGRAM END IF
   #No.TQC-A40115  --End
 
   DROP TABLE r761_tmp
#No.FUN-680107 --start
#  CREATE TEMP TABLE r761_tmp
#  (
#  bank    VARCHAR(10),    {銀行代號}
#  tmp01   VARCHAR(02),    {融資種類}
#  tmp03   dec(20,6),   {金額}
#  tmp04   dec(5,3));   {利率}
  
   CREATE TEMP TABLE r761_tmp(
    bank LIKE nne_file.nne04,
    tmp01 LIKE nne_file.nne06,
    tmp03 LIKE nne_file.nne12,
    tmp04 LIKE nne_file.nne23);
#No.FUN-680107 --end
 
 # CREATE UNIQUE INDEX r761_01 ON r761_tmp (tmp01);
   # Jason 020507
   DROP TABLE r761_tmp1
#No.FUN-680107 --start
  #CREATE TEMP TABLE r761_tmp1     
  # Jason 020805
  #(bank VARCHAR(08), curr VARCHAR(05),oamt DEC(15,3),lamt DEC(15,3),ramt DEC(15,3));
#  (bank VARCHAR(08), edate DATE,curr VARCHAR(05),oamt DEC(20,6),lamt DEC(20,6),ramt DEC(20,6));
   
   #No.FUN-680107--欄位類型修改                                                    
   #CREATE TEMP TABLE r761_tmp(     #FUN-720033 mark
    CREATE TEMP TABLE r761_tmp1(    #FUN-720033 mod
    bank LIKE nne_file.nne04,
    edate LIKE type_file.dat,   
    curr LIKE nne_file.nne16,
    oamt LIKE nne_file.nne12,
    lamt LIKE nne_file.nne19,
    ramt LIKE nne_file.nne19);
#No.FUN-680107 --end
  #create index r761_01 on r761_tmp1 (bank)
   create index r761_01 on r761_tmp1 (bank,edate)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
   #No.TQC-A40115  --End
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL anmr761_tm()                    # Input print condition
      ELSE CALL anmr761()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr761_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,       #No.FUN-680107 SMALLINT
       l_cmd         LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(400)
       l_jmp_flag    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW anmr761_w AT p_row,p_col
        WITH FORM "anm/42f/anmr761"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.edate= g_today
   LET tm.a = 'N'   #CHI-7C0026
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON
         nne01, nne02, nne03, nne06
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr761_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   #INPUT BY NAME tm.edate,tm.more WITHOUT DEFAULTS   #CHI-7C0026
   INPUT BY NAME tm.edate,tm.a,tm.more WITHOUT DEFAULTS   #CHI-7C0026
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr761_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr761'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr761','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",   #TQC-610058
                         " '",tm.a CLIPPED,"'",   #CHI-7C0026
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr761',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr761_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr761()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr761_w
END FUNCTION
#No.FUN-830156------BEGIN--------------
FUNCTION anmr761()
   DEFINE l_name        LIKE type_file.chr20,      # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
         #l_sql         LIKE type_file.chr1000,    #RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200) #MOD-C90016 mark
          l_sql         STRING,                    #MOD-C90016 add
          l_za05        LIKE type_file.chr1000,    #標題內容 #No.FUN-680107 VARCHAR(40)
          l_day         LIKE type_file.num5,       #No.FUN-680107 SMALLINT  #計算每月日數
          #l_buf         LIKE type_file.chr1000,    # RDSQL STATEMENT #No.FUN-680107 VARCHAR(600)    #TQC-C90052 mark
          l_buf         STRING,                    #TQC-C90052 add
          l_alg011      LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3) #因alg01為012-5804
          l_alg012      LIKE type_file.chr4,       #No.FUN-680107 VARCHAR(4) #而nnf05為0125804-01
          l_i           LIKE type_file.num5,       #No.FUN-680107 SMALLINT
          l_ramt        LIKE nne_file.nne20,
          sr            RECORD
                        nne02   LIKE  nne_file.nne02 ,  #申請日期
                        nne01   LIKE  nne_file.nne01 ,  #融資單號
                        nne04   LIKE  nne_file.nne04 ,  #信貸銀行編號
                        nne06   LIKE  nne_file.nne06 ,  #融資種類
                        nne112  LIKE  nne_file.nne112,  #融資到期日
                        nne12   LIKE  nne_file.nne12 ,  #借款原幣
                        nne14   LIKE  nne_file.nne14 ,  #還款利率
                        nne15   LIKE  nne_file.nne15 ,  #LC NO
                        nne16   LIKE  nne_file.nne16 ,  #幣別
                        nne19   LIKE  nne_file.nne19 ,  #本幣融資金額
                        nne20   LIKE  nne_file.nne20 ,  #本幣已還餘額
                        nne22   LIKE  nne_file.nne22 ,  #還息日
                        nne27   LIKE  nne_file.nne27 ,  #原幣已還餘額
                        nnn02   LIKE  nnn_file.nnn02 ,  #授信類別名稱
                        nnn03   LIKE  nnn_file.nnn03 ,  #記息方式
                        alg01   LIKE  alg_file.alg01 ,  #銀行代號
                        alg02   LIKE  alg_file.alg02 ,  #銀行名稱
                      t_alg01   LIKE  alg_file.alg01 ,  #擔當銀行代號
                      t_alg02   LIKE  alg_file.alg02 ,  #擔當銀行名稱
                        day01   LIKE type_file.dat,     #No.FUN-680107               #應息始日
                        day02   LIKE type_file.num5,    #No.FUN-680107               #應息日數
                        int01   LIKE type_file.num20_6, #No.FUN-680107               #應付利息
                        int02   LIKE type_file.num20_6  #No.FUN-680107               #每月利息
                        END RECORD
DEFINE l_nmd26_tot       LIKE nmd_file.nmd26
DEFINE l_nmd26_tot1      LIKE nmd_file.nmd26
DEFINE l_nmd04_tot       LIKE nmd_file.nmd04
DEFINE l_nmd04_tot1      LIKE nmd_file.nmd04
DEFINE l_nnl14_tot       LIKE nnl_file.nnl14
DEFINE l_nnl12_tot       LIKE nnl_file.nnl12
DEFINE l_len             LIKE type_file.num5  #FUN-720033 mark
DEFINE l_curr     LIKE nne_file.nne16
DEFINE l_oamt     LIKE nne_file.nne12
DEFINE l_lamt     LIKE nne_file.nne19
DEFINE l_ro       LIKE nne_file.nne20
DEFINE l_sum1     LIKE nne_file.nne20
DEFINE l_amt      LIKE nne_file.nne19
DEFINE l_bank     LIKE nne_file.nne04 
DEFINE l_bank_t   LIKE nne_file.nne04
DEFINE l_alg02    LIKE alg_file.alg02
DEFINE l_nne112_t LIKE nne_file.nne112
 
   CALL cl_del_data(l_table)    #MOD-8B0166 add
   #No.TQC-A40115  --Begin
   #CALL cl_del_data(l_table1)   #MOD-8B0166 add
   #CALL cl_del_data(l_table2)   #MOD-8B0166 add
   #No.TQC-A40115  --End  
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#  SELECT azi04 , azi05 INTO g_azi04, g_azi05 FROM azi_file
#   WHERE  azi01=g_aza.aza17
#NO.CHI-6A0004--BEGIN
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND nneuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND nnegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND nnegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
   #End:FUN-980030
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?)"  #No.TQC-A40115
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
      EXIT PROGRAM                                                                                                                 
   END IF
 
   #No.TQC-A40115  --Begin
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
   #            " VALUES(?, ?, ?, ?, ?, ?)"                    
   #PREPARE insert_prep1 FROM g_sql                                               
   #IF STATUS THEN                                                               
   #   CALL cl_err('insert_prep1:',status,1)                                      
   #   EXIT PROGRAM                                                              
   #END IF
 
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,             
   #            " VALUES(?, ?, ?, ?, ?, ?)"                                         
   #PREPARE insert_prep2 FROM g_sql                                              
   #IF STATUS THEN                                                               
   #   CALL cl_err('insert_prep2:',status,1)                                     
   #   EXIT PROGRAM                                                              
   #END IF
   #No.TQC-A40115  --End  
 
#No.FUN-680107 --start
   DROP TABLE r761_tmp
#  CREATE TEMP TABLE r761_tmp
#  (
#  bank    VARCHAR(10),    {銀行代號}
#  tmp01   VARCHAR(02),    {融資種類}
#  tmp03   dec(20,6),   {金額}
#  tmp04   dec(5,3));   {利率}
 
   CREATE TEMP TABLE r761_tmp(
    bank LIKE nne_file.nne04,
    tmp01 LIKE nne_file.nne06,
    tmp03 LIKE nne_file.nne12,
    tmp04 LIKE nne_file.nne23);
#No.FUN-680107 --end
 # CREATE UNIQUE INDEX r761_01 ON r761_tmp (tmp01);
   # Jason 020507
   DROP TABLE r761_tmp1
#No.FUN-680107 --start
#   CREATE TEMP TABLE r761_tmp1
  # Jason 020805
  #(bank VARCHAR(08), curr VARCHAR(05),oamt DEC(15,3),lamt DEC(15,3),ramt DEC(15,3));
#   (bank VARCHAR(08), edate DATE,curr VARCHAR(05),oamt DEC(15,3),lamt DEC(15,3),ramt DEC(15,3));
 
  #CREATE TEMP TABLE r761_tmp(  #FUN-720033 mark
   CREATE TEMP TABLE r761_tmp1( #FUN-720033 mod
    bank LIKE nne_file.nne04,
    edate LIKE type_file.dat,   
    curr LIKE nne_file.nne16,
    oamt LIKE nne_file.nne12,
    lamt LIKE nne_file.nne19,
    ramt LIKE nne_file.nne19);
#No.FUN-680107 --end
  #create index r761_01 on r761_tmp1 (bank)
   create index r761_01 on r761_tmp1 (bank,edate)
  #LET l_sql = " SELECT ",
  #            " nne02,nne01, nne04, nne06, nne112, nne14, nne19, nne22, ",
  #            " '', '', '', '', '', '', '', '' ",
  #            " ,nne16 ",
  #            " FROM nne_file ",
  #            " WHERE nneconf <> 'X' AND ", tm.wc CLIPPED
   LET l_sql = " SELECT ",
               " nne111,nne01, nne04, nne06, nne112, nne12, nne14, nne15, ",
               " nne16, nne19, nne20,nne22,nne27, '','', '', '', '', '', '', '', '' ",
               " ,'' FROM nne_file ",
               " WHERE ", tm.wc CLIPPED ,
               "   AND nneconf <> 'X'",   #MOD-8B0166 add
               "   AND nne111 <= '",tm.edate,"'"
# Joan 020827 end -----------------------------------------------------------*
   # ------end
   LET l_sql = l_sql CLIPPED, " ORDER BY nne112 "  # Jason 020619
   PREPARE anmr761_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE anmr761_curs1 CURSOR FOR anmr761_prepare1
 
   #CALL cl_outnam('anmr761') RETURNING l_name
   #START REPORT anmr761_rep TO l_name
   LET l_nne112_t = ' '
   LET g_pageno = 0
   FOREACH anmr761_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #-----FUN-650184---------
      SELECT SUM(nnl11),SUM(nnl13) INTO l_nnl12_tot,l_nnl14_tot
       FROM nnl_file,nnk_file
      WHERE nnl01=nnk01  
        AND nnl04 = sr.nne01 
        AND nnk02 <=tm.edate
        AND nnk21 IS NULL                                #MOD-D10119 add
        AND nnkconf= 'Y'
   
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot,l_nmd26_tot
        FROM nmd_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
   
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot1,l_nmd26_tot1
        FROM nmd_file,nnf_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
         AND nnf06 = nmd01 AND nnf08 = '1'
   
      IF cl_null(l_nnl14_tot) THEN LET l_nnl14_tot = 0 END IF
      IF cl_null(l_nmd26_tot) THEN LET l_nmd26_tot = 0 END IF
      IF cl_null(l_nmd26_tot1) THEN LET l_nmd26_tot1 = 0 END IF
      IF cl_null(l_nnl12_tot) THEN LET l_nnl12_tot = 0 END IF
      IF cl_null(l_nmd04_tot) THEN LET l_nmd04_tot = 0 END IF
      IF cl_null(l_nmd04_tot1) THEN LET l_nmd04_tot1 = 0 END IF
     #str MOD-8C0090 mod
     #LET sr.nne20 = l_nnl14_tot + l_nmd26_tot - l_nmd26_tot1
     #LET sr.nne27 = l_nnl12_tot + l_nmd04_tot - l_nmd04_tot1
     #MOD-960265   ---start     
      LET sr.nne20 = l_nnl14_tot + l_nmd26_tot1         #MOD-D10119 l_nmd26_tot mod l_nmd26_tot1
      LET sr.nne27 = l_nnl12_tot + l_nmd04_tot1         #MOD-D10119 l_nmd04_tot mod l_nmd04_tot1
     #LET sr.nne20 = l_nnl14_tot                        #MOD-D10119 mark
     #LET sr.nne27 = l_nnl12_tot                        #MOD-D10119 mark
     #MOD-960265   ---end        
     #end MOD-8C0090 mod
      #-----END FUN-650184-----
      LET sr.day01 = MDY( month(tm.edate), sr.nne22, year(tm.edate))
      LET sr.day02 = tm.edate - sr.day01
     #LET sr.int01 = sr.nne19 * sr.nne14 /365 * sr.day02
      # Jason  020517
      LET sr.int01 = sr.nne19 * sr.nne14 /365 * sr.day02 /100
 
      ###計算每月日數
      LET g_day01 = MONTH(tm.edate)
      IF g_day01 = 12 THEN LET g_day01 = 0 END IF  ###12月的下個月是1月
 
      LET g_day = MDY(g_day01 + 1,1,YEAR(tm.edate)) -
                  MDY(g_day01,1,YEAR(tm.edate))
     #LET sr.int02 = sr.nne19 * sr.nne14 /365 * g_day
      # Jason  020517
      LET sr.int02 = sr.nne19 * sr.nne14 /365 * g_day /100
      SELECT alg01,alg02 INTO sr.alg01,sr.alg02 FROM alg_file
       WHERE alg01 = sr.nne04
      SELECT nnn02, nnn03 INTO sr.nnn02, sr.nnn03 FROM nnn_file
       WHERE nnn01 = sr.nne06
      #-----CHI-7C0026---------
      IF tm.a = 'N' AND sr.nne19 - sr.nne20 = 0 THEN
         CONTINUE FOREACH
      END IF
      #-----END CHI-7C0026----- 
      IF sr.nnn03 = '2' THEN
         INSERT INTO r761_tmp
         VALUES(sr.nne04,sr.nne06,sr.nne19,sr.nne14)
      END IF
 
      IF sr.nnn03 IS NULL THEN LET sr.nnn03 = ' ' END IF
      IF sr.nne14 IS NULL THEN LET sr.nne14 = 0 END IF
      IF sr.nne19 IS NULL THEN LET sr.nne19 = 0 END IF
      #-----FUN-650184---------
      IF sr.nne12 IS NULL THEN LET sr.nne12 = 0 END IF
      LET sr.nne19 = sr.nne19 - sr.nne20
      LET sr.nne12 = sr.nne12 - sr.nne27
      #-----END FUN-650184-----
      IF sr.int01 IS NULL THEN LET sr.int01 = 0 END IF
      IF sr.int02 IS NULL THEN LET sr.int02 = 0 END IF
      IF sr.nnn03 = '2' THEN
         INSERT INTO r761_tmp
         VALUES(sr.nne04,sr.nne06,sr.nne19,sr.nne14)
      END IF
      # 擔當行庫
      LET l_alg011 = ''
      LET l_alg012 = ''
      SELECT nnf05  INTO sr.t_alg01
       FROM nnf_file
       WHERE nnf01 = sr.nne01 and nnf02=1
      LET l_alg011 = sr.t_alg01[1,3]
      LET l_alg012 = sr.t_alg01[4,7]
      SELECT alg02 INTO  sr.t_alg02
        FROM alg_file
       WHERE alg01[1,3]=l_alg011 AND alg01[5,8]=l_alg012
  #    WHERE alg01[1,3]='012'    AND alg01[5,8]='5804'
      LET l_ramt = sr.nne14*sr.nne12  # Jason 020619
 
      UPDATE r761_tmp1 SET oamt = oamt +sr.nne12,
                           lamt = lamt +sr.nne19,
                           ramt = ramt +l_ramt
      #WHERE curr = sr.nne16
       WHERE curr = sr.nne16 AND bank =sr.nne04 # Jason 020430
         AND edate = sr.nne112  # Jason 020805
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
         INSERT INTO r761_tmp1
         VALUES(sr.nne04,sr.nne112,sr.nne16,sr.nne12,sr.nne19,l_ramt)
      END IF
 
#     OUTPUT TO REPORT anmr761_rep(sr.*)
      #No.TQC-A40115  --Begin
      SELECT azi04,azi05 INTO t_azi04,t_azi05  #add azi05
        FROM azi_file WHERE azi01 = sr.nne16
      #No.TQC-A40115  --End
 
      IF sr.nnn03 <> '2' THEN
         EXECUTE insert_prep USING
            sr.nne01,sr.nne02,sr.nne112,sr.alg01,
            sr.alg02,sr.nnn02,sr.nne16,sr.nne12,sr.nne19,sr.nne14,
            sr.t_alg02,sr.nne15,t_azi04,t_azi05    #No.TQC-A40115
      END IF
 
      #No.TQC-A40115  --Begin
      ##after group of nne112
      #DECLARE r761_cur2 CURSOR FOR
      #   SELECT curr,SUM(oamt),SUM(lamt),SUM(ramt) FROM r761_tmp1
      #    WHERE edate = sr.nne112
      #    GROUP BY curr
      #    ORDER BY curr
      #LET l_ro  = 0 
      #LET l_sum1= 0
      #LET l_oamt= 0
      #LET l_lamt= 0
      #LET l_ramt= 0
      #LET l_curr = ''
      #FOREACH r761_cur2 INTO l_curr,l_oamt,l_lamt,l_ramt
      #   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr
      #   LET l_ro = l_ramt/l_oamt
      #   IF cl_null(l_ro) THEN LET l_ro = 0 END IF
      #   EXECUTE insert_prep1 USING sr.nne112,l_curr,l_oamt,l_lamt,l_ro,t_azi05
      #END FOREACH
      #No.TQC-A40115  --End  
   END FOREACH
 
#---新增...
   LET l_nne112_t = ' '
   #LET l_buf = tm.wc[1,300]                 #TQC-C90052  mark
   LET l_buf = tm.wc.substring(1,300)        #TQC-C90052  add
   LET l_buf = tm.wc CLIPPED
  #FUN-720033---mod---str---
   LET l_len =length(l_buf CLIPPED)-4
  #TQC-C90052--mark--str--
  #FOR l_i = 1 TO l_len
  #   IF l_buf[l_i,l_i+4] = 'nne01' THEN LET l_buf[l_i,l_i+4] ='nng01' END IF
  #   IF l_buf[l_i,l_i+4] = 'nne02' THEN LET l_buf[l_i,l_i+4] ='nng02' END IF
  #   IF l_buf[l_i,l_i+4] = 'nne03' THEN LET l_buf[l_i,l_i+4] ='nng03' END IF
  #   IF l_buf[l_i,l_i+4] = 'nne06' THEN LET l_buf[l_i,l_i+4] ='nng24' END IF
  #END FOR
  #TQC-C90052--mark--end-- 
  #TQC-C90052--add--str--
   FOR l_i = 1 TO l_len
      IF l_buf.substring(l_i,l_i+4) = 'nne01' THEN LET l_buf = cl_replace_str(l_buf,"nne01","nng01") END IF
      IF l_buf.substring(l_i,l_i+4) = 'nne02' THEN LET l_buf = cl_replace_str(l_buf,"nne02","nng02") END IF
      IF l_buf.substring(l_i,l_i+4) = 'nne03' THEN LET l_buf = cl_replace_str(l_buf,"nne03","nng03") END IF
      IF l_buf.substring(l_i,l_i+4) = 'nne06' THEN LET l_buf = cl_replace_str(l_buf,"nne06","nng24") END IF
   END FOR
   #TQC-C90052--add--end--

  #FOR l_i = 1 TO 296
  #  IF l_buf[l_i,l_i+4] = 'nne01' THEN LET l_buf[l_i,l_i+4] ='nng01' END IF
  #  IF l_buf[l_i,l_i+4] = 'nne02' THEN LET l_buf[l_i,l_i+4] ='nng02' END IF
  #  IF l_buf[l_i,l_i+4] = 'nne03' THEN LET l_buf[l_i,l_i+4] ='nng03' END IF
  #  IF l_buf[l_i,l_i+4] = 'nne06' THEN LET l_buf[l_i,l_i+4] ='nng24' END IF
  #END FOR
  #FUN-720033---mod---end---
 
   LET l_buf = l_buf CLIPPED
   LET l_sql = "SELECT DISTINCT",
               " nng081,nng01, nng04, nng24, nng082, nng20, nng53, '', ",
               " nng18, nng22,0,nng13,0, '','', alg01, alg02, '', '', '',",
               " '','','' ",
              #" FROM nng_file, OUTER (nnl_file,nnk_file),OUTER alg_file ",   #MOD-650014
               " FROM nng_file, OUTER nnl_file,OUTER alg_file ",   #MOD-650014
               " WHERE ",l_buf CLIPPED,
               " AND nngconf<> 'X'",    #MOD-8B0166 add
               " AND nng081 <= '",tm.edate,"'",
	       " AND nng_file.nng01 = nnl_file.nnl04 ",
              #" AND nnl01 = nnk01 ",   #MOD-650014
	       " AND alg_file.alg01 = nng_file.nng04 "
              #" AND nnk02 <= '",tm.edate,"'",   #MOD-650014
              #" AND nnkconf = 'Y'"   #MOD-650014
# Joan 020827 end --------------------------------------------------------*
 
   PREPARE anmr761_prepare2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE anmr761_curs2 CURSOR FOR anmr761_prepare2
   FOREACH anmr761_curs2 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      SELECT nnn02, nnn03 INTO sr.nnn02, sr.nnn03 FROM nnn_file
       WHERE nnn01 = sr.nne06
     # Jason 020805
     #SELECT SUM(nnl12),SUM(nnl14) INTO l_nnl12_tot,l_nnl14_tot   #FUN-650184
      SELECT SUM(nnl11),SUM(nnl13) INTO l_nnl12_tot,l_nnl14_tot   #FUN-650184
        FROM nnl_file,nnk_file
       WHERE nnl01=nnk01  AND nnl04 = sr.nne01 AND nnk02 <=tm.edate   # Jason0806
         AND nnk21 IS NULL                                            #MOD-D10119 add
         AND nnkconf= 'Y' # Jason 020807
 
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot,l_nmd26_tot
        FROM nmd_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
                        # 支票不可當作已還啦
      SELECT SUM(nmd04),SUM(nmd26) INTO l_nmd04_tot1,l_nmd26_tot1
        FROM nmd_file,nnf_file
       WHERE nmd10 = sr.nne01 AND nmd05  <= tm.edate AND nmd12 ='8'
         AND nnf06 = nmd01 AND nnf08 = '1'
 
      IF cl_null(l_nnl14_tot) THEN LET l_nnl14_tot = 0 END IF
      IF cl_null(l_nmd26_tot) THEN LET l_nmd26_tot = 0 END IF
      IF cl_null(l_nmd26_tot1) THEN LET l_nmd26_tot1 = 0 END IF
      IF cl_null(l_nnl12_tot) THEN LET l_nnl12_tot = 0 END IF
      IF cl_null(l_nmd04_tot) THEN LET l_nmd04_tot = 0 END IF
      IF cl_null(l_nmd04_tot1) THEN LET l_nmd04_tot1 = 0 END IF
     #str MOD-8C0090 mod
     #LET sr.nne20 = l_nnl14_tot + l_nmd26_tot - l_nmd26_tot1
     #LET sr.nne27 = l_nnl12_tot + l_nmd04_tot - l_nmd04_tot1
     #MOD-960265    ---start      
      LET sr.nne20 = l_nnl14_tot + l_nmd26_tot          #MOD-D10119 remark
      LET sr.nne27 = l_nnl12_tot + l_nmd04_tot          #MOD-D10119 remark
     #LET sr.nne20 = l_nnl14_tot                        #MOD-D10119 mark
     #LET sr.nne27 = l_nnl12_tot                        #MOD-D10119 mark
     #MOD-960265   ---end     
     #end MOD-8C0090 mod
# End
      # Jason 020507
      IF sr.nnn03 IS NULL THEN LET sr.nnn03 = ' ' END IF
      IF sr.nne14 IS NULL THEN LET sr.nne14 = 0 END IF
      IF sr.nne19 IS NULL THEN LET sr.nne19 = 0 END IF
      IF sr.nne12 IS NULL THEN LET sr.nne12 = 0 END IF   #FUN-650184
      LET sr.nne19 = sr.nne19 - sr.nne20
      #-----CHI-7C0026---------
      IF tm.a = 'N' AND sr.nne19 = 0 THEN
         CONTINUE FOREACH
      END IF
      #-----END CHI-7C0026-----
      LET sr.nne12 = sr.nne12 - sr.nne27
      #----end
     #IF sr.nnn03 IS NULL THEN LET sr.nnn03 = ' ' END IF
     #IF sr.nne14 IS NULL THEN LET sr.nne14 = 0 END IF
     #IF sr.nne19 IS NULL THEN LET sr.nne19 = 0 END IF
 
      IF sr.nnn03 = '2' THEN
         INSERT INTO r761_tmp
         VALUES(sr.nne04,sr.nne06,sr.nne19,sr.nne14)
      END IF
 
      IF sr.int01 IS NULL THEN LET sr.int01 = 0 END IF
      IF sr.int02 IS NULL THEN LET sr.int02 = 0 END IF
      # 擔當行庫
      LET l_alg011 = ''
      LET l_alg012 = ''
      SELECT nnf05  INTO sr.t_alg01
        FROM nnf_file
       WHERE nnf01 = sr.nne01 and nnf02=1
      LET l_alg011 = sr.t_alg01[1,3]
      LET l_alg012 = sr.t_alg01[4,7]
      SELECT alg02 INTO  sr.t_alg02
        FROM alg_file
       WHERE alg01[1,3]=l_alg011 AND alg01[5,8]=l_alg012
  #    WHERE alg01[1,3]='012'    AND alg01[5,8]='5804'
      LET l_ramt = sr.nne14*sr.nne12  # Jason 020619
 
      UPDATE r761_tmp1 SET oamt = oamt +sr.nne12,
                           lamt = lamt +sr.nne19,
                           ramt = ramt +l_ramt
      #WHERE curr = sr.nne16
       WHERE curr = sr.nne16 AND bank =sr.nne04 # Jason 020430
         AND edate = sr.nne112  # Jason 020805
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
         INSERT INTO r761_tmp1
         VALUES(sr.nne04,sr.nne112,sr.nne16,sr.nne12,sr.nne19,l_ramt)
      END IF
 
      #OUTPUT TO REPORT anmr761_rep(sr.*)
      #No.TQC-A40115  --Begin                                                   
      SELECT azi04,azi05 INTO t_azi04,t_azi05                                   
        FROM azi_file WHERE azi01 = sr.nne16                                    
      #No.TQC-A40115  --End   
      IF sr.nnn03 <> '2' THEN                                                  
         EXECUTE insert_prep USING
            sr.nne01,sr.nne02,sr.nne112,sr.alg01,sr.alg02,       
            sr.nnn02,sr.nne16,sr.nne12,sr.nne19,sr.nne14,sr.t_alg02,        
            sr.nne15,t_azi04,t_azi05   #No.TQC-A40115                       
      END IF 
 
      #No.TQC-A40115  --Begin
      ##after group of nne112                                                   
      #DECLARE r761_cur3 CURSOR FOR
      #   SELECT curr,SUM(oamt),SUM(lamt),SUM(ramt) FROM r761_tmp1
      #    WHERE edate = sr.nne112   
      #    GROUP BY curr
      #    ORDER BY curr                                        
      #LET l_ro  = 0                                                         
      #LET l_sum1= 0                                                         
      #LET l_oamt= 0                                                         
      #LET l_lamt= 0                                                         
      #LET l_ramt= 0                                                         
      #LET l_curr = ''                                                                        
      #FOREACH r761_cur3 INTO l_curr,l_oamt,l_lamt,l_ramt                    
      #   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=l_curr
      #   LET l_ro = l_ramt/l_oamt                                           
      #   IF cl_null(l_ro) THEN LET l_ro = 0 END IF                          
      #   EXECUTE insert_prep1 USING sr.nne112,l_curr,l_oamt,l_lamt,l_ro,t_azi05
      #END FOREACH                                                           
      #No.TQC-A40115  --End  
   END FOREACH
#--新增
  
   #No.TQC-A40115  --Begin
   #DECLARE r761_cur CURSOR FOR
   #   SELECT bank,curr,SUM(oamt),SUM(lamt),SUM(ramt) FROM r761_tmp1
   #    GROUP BY bank,curr
   #    ORDER BY bank,curr
   #LET l_ro  = 0
   #LET l_sum1= 0
   #LET l_oamt= 0
   #LET l_lamt= 0
   #LET l_ramt= 0
   #LET l_bank_t = ' '
   #No.TQC-A40115  --End  
 
   #No.TQC-A40115  --Begin
   #FOREACH r761_cur INTO l_bank,l_curr,l_oamt,l_lamt,l_ramt
   #   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = l_curr
   #   LET l_alg02 = '' 
   #   SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01 = l_bank 
   #   IF cl_null(l_bank) THEN LET l_bank = '( )' END IF  
   #   LET l_alg02 = l_bank CLIPPED,' ',l_alg02          
 
   #   LET l_ro = l_ramt/l_oamt
   #   IF cl_null(l_ro) THEN LET l_ro = 0 END IF
   #     
   #   LET l_sum1=l_sum1+ (l_ro*l_lamt)
 
   #   IF l_bank <> l_bank_t THEN  
   #      EXECUTE insert_prep2 USING l_alg02,l_curr,l_oamt,l_lamt,l_ro,t_azi05
   #   ELSE 
   #      EXECUTE insert_prep2 USING ' ',l_curr,l_oamt,l_lamt,l_ro,t_azi05
   #   END IF
   #   LET l_bank_t = l_bank
   #END FOREACH
 
   #SELECT SUM(lamt) INTO l_amt FROM r761_tmp1
   #IF cl_null(l_amt)  THEN LET l_amt =0 END IF   #MOD-8B0166 add
   #IF l_amt <> 0 THEN
   #   LET l_sum1 = l_sum1/l_amt
   #END IF
   #IF cl_null(l_sum1) THEN LET l_sum1=0 END IF   #MOD-8B0166 add
   #No.TQC-A40115  --End  
 
   #No.TQC-A40115  --Begin
   #LET g_sql = "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
   #            "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
   #            "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
   LET g_sql = "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #No.TQC-A40115  --End  
    
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'nne01,nne02,nne03,nne06')
          RETURNING tm.wc
   ELSE
      LET tm.wc = ""
   END IF
   LET g_str = tm.wc,";",tm.edate,";",g_azi05,";",g_azi04
#              ,";",l_amt,";", l_sum1  #No.TQC-A40115
   CALL cl_prt_cs3('anmr761','anmr761',g_sql,g_str)
#  FINISH REPORT anmr761_rep
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT anmr761_rep(sr)
#  DEFINE l_last_sw     LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
#         l_amt01       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
#         l_amt02       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) #LIKE nne_file.nne19 ,
#         l_amt03       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) #LIKE nne_file.nne19 ,
#         l_amt04       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) #LIKE nne_file.nne19 ,
#         l_amt05       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) #LIKE nne_file.nne19 ,
#         l_amt06       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) #LIKE nne_file.nne19 ,
#         l_int01       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) #LIKE nne_file.nne14 ,
#         l_int02       LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6) #LIKE nne_file.nne14 ,
#         l_sum         LIKE type_file.num20_6,    #No.FUN-680107 DEC(20,6)
#         l_avg         LIKE nne_file.nne14,       #No.FUN-680107 DEC(5,3)
#         l_avg01       LIKE nne_file.nne14,       #No.FUN-680107 DEC(5,3)
#         l_alg02       LIKE alg_file.alg02,
#         l_nnn02       LIKE nnn_file.nnn02,
#         sr1           RECORD
#                       bank    LIKE nne_file.nne04,    #No.FUN-680107 VARCHAR(10)
#                       tmp01   LIKE nne_file.nne06,    #No.FUN-680107 VARCHAR(2)   {融資種類}
#                       tmp03   LIKE nne_file.nne12,    #No.FUN-680107 DEC(20,6) {金額}
#                       tmp04   LIKE nne_file.nne23     #No.FUN-680107 DEC(5,3)  {利率}
#                       END RECORD ,
#         sr            RECORD
#                       nne02   LIKE  nne_file.nne02 ,  #申請日期
#                       nne01   LIKE  nne_file.nne01 ,  #融資單號
#                       nne04   LIKE  nne_file.nne04 ,  #信貸銀行編號
#                       nne06   LIKE  nne_file.nne06 ,  #融資種類
#                       nne112  LIKE  nne_file.nne112 , #融資到期日
#                       nne12   LIKE  nne_file.nne12 ,  #借款原幣
#                       nne14   LIKE  nne_file.nne14 ,  #還款利率
#                       nne15   LIKE  nne_file.nne15 ,  #LC NO
#                       nne16   LIKE  nne_file.nne16 ,  #幣別
#                       nne19   LIKE  nne_file.nne19 ,  #本幣融資金額
#                       nne20   LIKE  nne_file.nne20 ,  #本幣已還餘額
#                       nne22   LIKE  nne_file.nne22 ,  #還息日
#                       nne27   LIKE  nne_file.nne27 ,  #原幣已還餘額
#                       nnn02   LIKE  nnn_file.nnn02 ,  #授信類別名稱
#                       nnn03   LIKE  nnn_file.nnn03 ,  #記息方式
#                       alg01   LIKE  alg_file.alg01 ,  #銀行代號
#                       alg02   LIKE  alg_file.alg02 ,  #銀行名稱
#                     t_alg01   LIKE  alg_file.alg01 ,  #擔當銀行代號
#                     t_alg02   LIKE  alg_file.alg02 ,  #擔當銀行名稱
#                       day01   LIKE type_file.dat ,                  #應息始日
#                       day02   LIKE type_file.num5,    #No.FUN-680107 SMALLINT #應息日數
#                       int01   LIKE type_file.num20_6, #No.FUN-680107 DEC(20,6)#應付利息
#                       int02   LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6)#每月利息
#                       END RECORD
# DEFINE l_curr   LIKE nne_file.nne16
# DEFINE l_oamt   LIKE nne_file.nne12
# DEFINE l_lamt   LIKE nne_file.nne19
# DEFINE l_ramt   LIKE nne_file.nne20
# DEFINE l_ro     LIKE nne_file.nne20
# DEFINE l_sum1   LIKE nne_file.nne20
# DEFINE l_cnt    LIKE type_file.chr20  #No.FUN-680107 VARCHAR(10)
# DEFINE l_cnt1   LIKE type_file.num5   #FUN-720033 add
# DEFINE l_amt    LIKE nne_file.nne19
# DEFINE l_bank   LIKE nne_file.nne04   #FUN-720033 add
# DEFINE l_bank_t LIKE nne_file.nne04   #FUN-720033 add
 
# OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
# ORDER BY sr.nne112,sr.nne01
# ORDER BY sr.nne04,sr.nne01   #modi by kitty
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1=g_x[18] CLIPPED,' ', tm.edate USING'yyyymmdd'
#     PRINT g_head1
# Joan 020827 --------------------------------------------------------*
# Joan 020827 end ----------------------------------------------------*
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED
#
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     SELECT azi04 INTO t_azi04  #No.MOD-580211
#       FROM azi_file WHERE azi01 = sr.nne16
#     IF sr.nnn03 != '2' THEN
#            PRINT COLUMN g_c[31],sr.nne02  ,
#                  COLUMN g_c[32],sr.nne112 ,
#                  COLUMN g_c[33],sr.alg01,
#                  COLUMN g_c[34],sr.alg02,
#                  COLUMN g_c[35],sr.nnn02,
#                  COLUMN g_c[36],sr.nne16,
#                 #Joan 020828-------------------------------*
#                 #COLUMN ,sr.nne12 ,
#                  COLUMN g_c[37],cl_numfor(sr.nne12,37,t_azi04) ,  #No.MOD-580211
#                 #Joan 020828 end --------------------------*
#                  COLUMN g_c[38],cl_numfor(sr.nne19,38,g_azi04)  ,
#                  COLUMN g_c[39],sr.nne14 USING '##&.##&',
#                  COLUMN g_c[40],sr.t_alg02 ,
#                  COLUMN g_c[41],sr.nne15
#     END IF
 
## Jason 020805 依到期日小計
#  AFTER GROUP OF sr.nne112
#     DECLARE r761_cur6 CURSOR FOR SELECT curr,SUM(oamt),SUM(lamt),SUM(ramt)
#     FROM r761_tmp1 
#     WHERE edate = sr.nne112
#     GROUP BY 1  ORDER BY 1
#      LET l_ro  = 0
#      LET l_sum1= 0
#      LET l_oamt= 0
#      LET l_lamt= 0
#      LET l_ramt= 0
#     #mod by evechu 020824 移到下面
#     FOREACH r761_cur6 INTO l_curr,l_oamt,l_lamt,l_ramt
#          SELECT azi05 INTO t_azi05 FROM azi_file   #MOD-5B0225
#           WHERE azi01=l_curr                       #MOD-5B0225
#          
#            LET l_ro = l_ramt/l_oamt
#            IF cl_null(l_ro) THEN LET l_ro = 0 END IF
#            LET l_sum1=l_sum1+ l_ro
#            PRINT COLUMN g_c[34], g_x[19] CLIPPED ;
#            PRINT COLUMN g_c[36], l_curr,
#                  COLUMN g_c[37], cl_numfor(l_oamt,37,t_azi05) ,  #No.MOD-580211
#                  COLUMN g_c[38], cl_numfor(l_lamt,38,g_azi05),
#                  COLUMN g_c[39], l_ro USING '##&.##&'
#     PRINT
#     END FOREACH
 
#  ON LAST ROW
#     IF  l_amt02 IS NULL THEN LET l_amt02 = 0 END IF
#     LET l_avg01 = AVG(sr.nne14)
#     LET l_amt03 = SUM(sr.nne19) + l_amt02
#     LET l_amt04 = SUM(sr.int01) WHERE sr.nnn03 = '1'
#     LET l_amt05 = SUM(sr.int02)
#     IF l_avg01 IS NULL THEN LET l_avg01 = 0 END IF
#     IF l_amt03 IS NULL THEN LET l_amt03 = 0 END IF
#     IF l_amt04 IS NULL THEN LET l_amt04 = 0 END IF
#     IF l_amt05 IS NULL THEN LET l_amt05 = 0 END IF
#     PRINT ''
#     ## modi 020626 sammi
#     LET l_cnt = 0
#         SELECT count(DISTINCT curr) INTO l_cnt FROM r761_tmp1
#     ##end 020626
#     #幣別合計
#     # Jason 020507
#    #--------#FUN-720033---str---
#    #DECLARE r761_cur CURSOR FOR SELECT curr,SUM(oamt),SUM(lamt),SUM(ramt)
#    #FROM r761_tmp1
#    #GROUP BY 1  ORDER BY 1
#     #DECLARE r761_cur CURSOR FOR SELECT bank,curr,SUM(oamt),SUM(lamt),SUM(ramt)
#     #FROM r761_tmp1
#     #GROUP BY bank,curr
#     #ORDER BY bank,curr
#    #--------#FUN-720033---end---
#     LET l_ro  = 0
#     LET l_sum1= 0
#     LET l_oamt= 0
#     LET l_lamt= 0
#     LET l_ramt= 0
#     LET l_bank_t = ' '
 
#     PRINT COLUMN g_c[34], g_x[13] CLIPPED ; 
#    #FOREACH r761_cur INTO l_curr,l_oamt,l_lamt,l_ramt          #FUN-720033 mark
#     FOREACH r761_cur INTO l_bank,l_curr,l_oamt,l_lamt,l_ramt   #FUN-720033 mod
#      SELECT azi05 INTO t_azi05 FROM azi_file   #MOD-5B0225
#       WHERE azi01 = l_curr                     #MOD-5B0225
#       
#     #FUN-720033---add---str---  
#      LET l_alg02 = '' 
#      SELECT alg02 INTO l_alg02 FROM alg_file   
#       WHERE alg01 = l_bank                      
 
#      IF cl_null(l_bank) THEN LET l_bank = '( )' END IF  
#      LET l_alg02 = l_bank CLIPPED,' ',l_alg02          
#     #FUN-720033---add---end---  
 
#            LET l_ro = l_ramt/l_oamt
#            IF cl_null(l_ro) THEN LET l_ro = 0 END IF
#          # Joan 020827 -------------------------------------*
#          # LET l_sum1=l_sum1+ l_ro
#            LET l_sum1=l_sum1+ (l_ro*l_lamt)
#          # Joan 020827 end----------------------------------*
 
#       #FUN-720033---mod---str---
#         IF l_bank <> l_bank_t THEN  
#           PRINT  COLUMN g_c[35], l_alg02 ,      #FUN-720033 add  銀行
#                  COLUMN g_c[36], l_curr,' ',
#                  COLUMN g_c[37], cl_numfor(l_oamt,37,t_azi05) ,  #No.MOD-580211
#                  COLUMN g_c[38], cl_numfor(l_lamt,38,g_azi05),
#                  COLUMN g_c[39], l_ro USING  '##&.##&'
#       ELSE 
#           PRINT  COLUMN g_c[35],' ',  
#                  COLUMN g_c[36], l_curr,' ',
#                  COLUMN g_c[37], cl_numfor(l_oamt,37,t_azi05) ,  #No.MOD-580211
#                  COLUMN g_c[38], cl_numfor(l_lamt,38,g_azi05),
#                  COLUMN g_c[39], l_ro USING  '##&.##&'
#       END IF
#       LET l_bank_t = l_bank
#       #FUN-720033---mod---end---
#     END FOREACH
#     #總合計  
#     #add by evechu 020824
#     SELECT SUM(lamt) INTO l_amt
#     FROM r761_tmp1
#     PRINT COLUMN g_c[34],g_x[21] CLIPPED,
#          #COLUMN ,SUM(sr.nne12) USING '##,###,###,##&.###',## 020626 sammi
#          #COLUMN , cl_numfor(SUM(sr.nne19),,g_azi04),
#           COLUMN g_c[38], cl_numfor(l_amt,38,g_azi05),   #No.MOD-580211
#          #COLUMN ,l_sum1 USING  '##&.##&'
#          # Joan 020827 -------------------------------------------------*
#          #COLUMN 86,l_sum1/l_cnt USING  '##&.##&' ##modi 020626 sammi
#           COLUMN g_c[39],l_sum1/l_amt USING  '##&.##&'
#          # Joan 020827 end----------------------------------------------*
## FUN-550114
#         LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
#       SKIP 1 LINE
#      # PRINT COLUMN 11, g_x[14] CLIPPED ,
#      #       COLUMN 41, g_x[15] CLIPPED ,
#      #       COLUMN 71, g_x[16] CLIPPED ,
#      #       COLUMN 101, g_x[17] CLIPPED
#       IF l_last_sw = 'n' THEN
#          PRINT g_x[09] CLIPPED ,COLUMN g_len-9,g_x[6]   #FUN-650184
#          IF g_memo_pagetrailer THEN
#              PRINT g_x[14]
#              PRINT g_memo
#          ELSE
#              PRINT
#              PRINT
#          END IF
#       ELSE
#              PRINT g_x[09] CLIPPED ,COLUMN g_len-9,g_x[7]   #FUN-650184
#              PRINT g_x[14]
#              PRINT g_memo
#       END IF
## END FUN-550114
#END REPORT
#No.FUN-830156------END----------------
#FUN-870144

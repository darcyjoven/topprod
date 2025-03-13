# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdr200.4gl
# Descriptions...: 銷項憑證明細表列印
# Date & Author..: 98/03/24 BY HJC
# Modify.........: No.FUN-510019 05/01/12 By Smapmin 報表轉XML格式
# Modify         : No.MOD-530869 05/03/30 by alexlin VARCHAR->CHAR
# Modify         : No.MOD-590359 05/09/21 by Dido 統一編號擴為20位元
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/26 By rainy 期間置於中間
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-6C0038 07/01/05 By jamie 將【資料選項一】選項移除
# Modify.........: No.FUN-850048 08/05/16 By destiny 報表改為CR輸出
# Modify.........: No.FUN-860041 08/06/11 By Carol 民國年欄位放大為3位
# Modify.........: No.MOD-880093 08/08/14 By Sarah CR Temptable增加amd06,amd04欄位
# Modify.........: No.MOD-8C0173 08/12/18 By Sarah l_sql需增加ORDER BY amd25,amd171,amd172,amd01,amd28,amd03
# Modify.........: No.MOD-930128 09/03/12 By lilingyu add amd30 = Y'
# Modify.........: No:CHI-940024 09/07/09 By Sarah 先判斷32格式合計與明細逐筆合計差異多少,有差異的話,找出32格式金額最大的那幾筆(差幾元找幾筆),在明細前面加秀*
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0039 09/10/19 By mike 若勾选要列印空白发票(tm.j='Y')时,须串到发票簿档(oom_file)抓取该发票簿的截止发票号(
#                                                 然后计算从已开发票号(oom09,若此栏位为Null时,改抓oom07)到截止发票号(oom08)应该有几>
#                                                 再呈现到报表的空白笔数(l_cnt_4,lt_cnt_4)   
# Modify.........: No:FUN-A10039 10/01/20 By jan 程式段中用到amd172 = 'D'或amd172 <> 'D'皆改為amd172 = 'F'或amd172 <> 'F'
# Modify.........: No:FUN-A10098 10/01/20 By chenls 以unique amd25 FOREACH 抓 oom_file 的 foreach 拿掉，抓oom_file 的跨DB SQL 語法改成不跨
# Modify.........: No:TQC-A40101 10/04/21 BY Carrier GP5.2报表追单
# Modify.........: No:MOD-A60172 10/06/28 By Dido lt_cnt_3 寫入 temptable 位置調整;作廢取消 amd04 判斷 
# Modify.........: No:CHI-A80044 10/09/01 By Summer 增加資料狀態1.已確認 2.未確認 3.全部
# Modify.........: No:CHI-AB0030 10/12/13 By Summer 增加amd22(申報部門),要有開窗功能q_amd
# Modify.........: No:MOD-B80224 11/08/24 By Dido 若輸入發票區間時,oom_pre 須依此範圍為主 
# Modify.........: No:MOD-C30790 12/03/20 By Polly 新增的37、38類型供user勾選列印
# Modify.........: No:MOD-C30798 12/03/20 By Polly oom07新舊值不同時，也需重新產生lt_cnt_4的值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc          STRING,                    #No.FUN-680074 VARCHAR(1000) #MOD-B80224 mod chr1000 -> STRING
           amd22       LIKE amd_file.amd22,       #CHI-AB0030 add
           amd01_y_b   LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           amd01_m_b   LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           amd01_y_e   LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           amd01_m_e   LIKE type_file.num5,       #No.FUN-680074 SMALLINT
           f           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(01)
           g           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(01)
           i           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(01)
           j           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(01)
          # Prog. Version..: '5.30.06-13.03.12(01) #CHI-6C0038 mark  
           h          LIKE type_file.chr1,       # (1)已確認 (2)未確認 (3)全部 #CHI-A80044 add
           more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(01)
 
           END RECORD,
 
       l_cnt_11       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_12       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_13       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_14       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_15       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_16       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_21       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_22       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_23       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_24       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_25       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_26       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_3        LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_4        LIKE type_file.num10,      #No.FUN-680074 INTEGER
       l_cnt_5        LIKE type_file.num10,      #No.FUN-680074 INTEGER# 直接外銷
 
       lt_cnt_11       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_12       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_13       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_14       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_15       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_16       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_21       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_22       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_23       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_24       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_25       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_26       LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_3        LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_4        LIKE type_file.num10,      #No.FUN-680074 INTEGER
       lt_cnt_5        LIKE type_file.num10,      #No.FUN-680074 INTEGER# 直接外銷
 
       l_cnt    LIKE type_file.num5          #No.FUN-680074 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680074 SMALLINT
#No.FUN-850048--begin--
DEFINE g_sql       STRING
DEFINE l_table     STRING
DEFINE g_str       STRING
#No.FUN-850048--end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-850048--begin--
   LET g_sql= "amd25.amd_file.amd25,    amd171.amd_file.amd171,",
              "amd173.amd_file.amd173,  amd01.amd_file.amd01,",
              "amd28.amd_file.amd28,    amd03.amd_file.amd03,",
              "ome042.ome_file.ome042,  amd174.amd_file.amd174,",
              "amd172.amd_file.amd172,  amd08.amd_file.amd08,",
              "amd07.amd_file.amd07,    amd06.amd_file.amd06,",   #MOD-880093 add amd06      
              "amd04.amd_file.amd04,",                            #MOD-880093 add amd04
              "l_cnt_11.type_file.num10,l_cnt_12.type_file.num10,",
              "l_cnt_13.type_file.num10,l_cnt_14.type_file.num10,",
              "l_cnt_15.type_file.num10,l_cnt_16.type_file.num10,",
              "l_cnt_21.type_file.num10,l_cnt_22.type_file.num10,",
              "l_cnt_23.type_file.num10,l_cnt_24.type_file.num10,",
              "l_cnt_25.type_file.num10,l_cnt_26.type_file.num10,",
              "l_cnt_5.type_file.num10, l_cnt_4.type_file.num10,",
              "l_cnt_3.type_file.num10, ",
              "lt_cnt_11.type_file.num10,lt_cnt_12.type_file.num10,",
              "lt_cnt_13.type_file.num10,lt_cnt_14.type_file.num10,",
              "lt_cnt_15.type_file.num10,lt_cnt_16.type_file.num10,",
              "lt_cnt_21.type_file.num10,lt_cnt_22.type_file.num10,",
              "lt_cnt_23.type_file.num10,lt_cnt_24.type_file.num10,",
              "lt_cnt_25.type_file.num10,lt_cnt_26.type_file.num10,",
              "lt_cnt_5.type_file.num10, lt_cnt_4.type_file.num10,",
              "lt_cnt_3.type_file.num10, l_chr.type_file.chr1"   #CHI-940024 add l_chr
   LET l_table = cl_prt_temptable('amdr200',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,? )"   #MOD-880093 add 2?   #CHI-940024 add ? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-850048--end--

  #str CHI-940024 add
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               "   SET l_chr='*'",
               " WHERE amd25=? AND amd171=? AND amd01=?",
               "   AND amd28=? AND amd03 =? " 
   PREPARE update_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('update_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
  #end CHI-940024 add

  #CHI-9A0039   ---start                                                                                                            
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                       
               "   SET l_cnt_4=? ",                                                                                                 
               " WHERE amd25=? "                                                                                                    
   PREPARE update_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('update_prep1:',status,1) EXIT PROGRAM                                                                            
   END IF                                                                                                                           
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                       
               "   SET lt_cnt_4=? "                                                                                                 
   PREPARE update_prep2 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('update_prep2:',status,1) EXIT PROGRAM                                                                            
   END IF                                                                                                                           
  #CHI-9A0039   ---end       

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
#-----TQC-610057---------
   LET tm.amd01_y_b = ARG_VAL(8)
   LET tm.amd01_m_b = ARG_VAL(9)
   LET tm.amd01_y_e = ARG_VAL(10)
   LET tm.amd01_m_e = ARG_VAL(11)
   LET tm.f = ARG_VAL(12)
   LET tm.g = ARG_VAL(13)
   LET tm.i = ARG_VAL(14)
   LET tm.j = ARG_VAL(15)
  #LET tm.k = ARG_VAL(16)     #CHI-6C0038 mark
   LET tm.h = ARG_VAL(17) #CHI-A80044 add
#CHI-A80044 mod +1 --start--
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   #No.FUN-570264 ---end---
#CHI-A80044 mod +1 --end--
#-----END TQC-610057-----
   IF cl_null(g_bgjob) OR g_bgjob='N'  THEN
       CALL amdr200_tm(0,0)    # Input print condition
   ELSE
       LET tm.wc="amd28= '",tm.wc CLIPPED,"'"
       CALL r200()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
 
FUNCTION amdr200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
 
    IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 3 LET p_col = 8
   END IF
   OPEN WINDOW amdr200_w AT p_row,p_col
           WITH FORM "amd/42f/amdr200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   LET tm.f='Y'
   LET tm.g='N'
   LET tm.i='N'
   LET tm.j='N'
  #LET tm.k='1'   #CHI-6C0038 mark
   LET tm.amd01_y_b = YEAR(g_today)
   LET tm.amd01_m_b = MONTH(g_today) - 1
   LET tm.amd01_y_e = YEAR(g_today)
   LET tm.amd01_m_e = MONTH(g_today) - 1
   LET tm.h = '3' #CHI-A80044 add
   LET tm.more= 'N'
   LET g_pdate=g_today
   LET g_rlang=g_lang
   LET g_bgjob='N'
   LET g_copies='1'
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON amd28,amd03,amd01,amd05,
#                               amd25,amd171,amd17           #No.FUN-A10098  ---mark
                                amd171,amd17                 #No.FUN-A10098  ---add
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
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

#No.FUN-A10098 --mark 
#     #-----MOD-610033---------
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(amd25)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.form = "q_azp"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO amd25
#                 NEXT FIELD amd25
#         END CASE
#     #-----END MOD-610033-----
#No.FUN-A10098 --mark end
 
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
         LET INT_FLAG = 0 CLOSE WINDOW amdr200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM
       END IF
 
    IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.amd22,tm.amd01_y_b,tm.amd01_m_b, #CHI-AB0030 add amd22
         tm.amd01_y_e,tm.amd01_m_e,
        #tm.f,tm.g,tm.i,tm.j,tm.k,tm.more   #CHI-6C0038 mark
         tm.f,tm.g,tm.i,tm.j,tm.h,tm.more   #CHI-6C0038 mod #CHI-A80044 add tm.h
 
   WHILE TRUE
    INPUT BY NAME tm.amd22,tm.amd01_y_b,tm.amd01_m_b, #CHI-AB0030 add amd22
         tm.amd01_y_e,tm.amd01_m_e,
        #tm.f,tm.g,tm.i,tm.j,tm.k,tm.more   #CHI-6C0038 mark
         tm.f,tm.g,tm.i,tm.j,tm.h,tm.more   #CHI-6C0038 mod  #CHI-A80044 add tm.h
    WITHOUT DEFAULTS
 
    #No.FUN-580031 --start--
    BEFORE INPUT
        CALL cl_qbe_display_condition(lc_qbe_sn)
    #No.FUN-580031 ---end---
      #CHI-AB0030 add --start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(amd22)
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_amd"
               CALL cl_create_qry() RETURNING tm.amd22
               DISPLAY g_qryparam.multiret TO tm.amd22
               NEXT FIELD amd22
         END CASE

      AFTER FIELD amd22
         IF cl_null(tm.amd22) THEN NEXT FIELD amd22 END IF
      #CHI-AB0030 add --end--
 
      AFTER FIELD amd01_y_b
         IF cl_null(tm.amd01_y_b) THEN NEXT FIELD amd01_y_b END IF
      AFTER FIELD amd01_m_b
         IF cl_null(tm.amd01_m_b) THEN NEXT FIELD amd01_m_b END IF
      AFTER FIELD amd01_y_e
         IF cl_null(tm.amd01_y_e) THEN NEXT FIELD amd01_y_e END IF
      AFTER FIELD amd01_m_e
         IF cl_null(tm.amd01_m_e) THEN NEXT FIELD amd01_m_e END IF
         IF tm.amd01_y_b+tm.amd01_m_b > tm.amd01_y_e+tm.amd01_m_e THEN
            NEXT FIELD amd01_m_e
         END IF
      AFTER FIELD f
         IF cl_null(tm.f) OR tm.f NOT MATCHES '[YN]' THEN
            NEXT FIELD f
         END IF
      AFTER FIELD g
         IF cl_null(tm.g) OR tm.g NOT MATCHES '[YN]' THEN
            NEXT FIELD g
         END IF
      AFTER FIELD i
         IF cl_null(tm.i) OR tm.i NOT MATCHES '[YN]' THEN
            NEXT FIELD i
         END IF
      AFTER FIELD j
         IF cl_null(tm.j) OR tm.j NOT MATCHES '[YN]' THEN
            NEXT FIELD j
         END IF
     #CHI-6C0038---mark---str---
     #AFTER FIELD k
     #   IF cl_null(tm.k) OR tm.k NOT MATCHES '[12]' THEN
     #      NEXT FIELD k
     #   END IF
     #CHI-6C0038---mark---end---
      #CHI-A80044 add --start--
      AFTER FIELD h
         IF tm.h NOT MATCHES "[123]" OR cl_null(tm.h)
            THEN NEXT FIELD h
         END IF
      #CHI-A80044 add --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW kxrr485_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
    #No.MOD-480459
   IF tm.f='N' AND tm.g='N' AND tm.i='N' THEN
      CALL cl_err('','amd-014',1)
      CONTINUE WHILE
   END IF
   EXIT WHILE
    #No.MOD-480459 (end)
   END WHILE
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amdr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr200','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.amd01_y_b CLIPPED,"'" ,
                         " '",tm.amd01_m_b CLIPPED,"'" ,
                         " '",tm.amd01_y_e CLIPPED,"'" ,
                         " '",tm.amd01_m_e CLIPPED,"'" ,
                         " '",tm.f CLIPPED,"'" ,
                         " '",tm.g CLIPPED,"'" ,
                         " '",tm.i CLIPPED,"'" ,
                         " '",tm.j CLIPPED,"'" ,
                        #" '",tm.k CLIPPED,"'" ,
			 " '",tm.h CLIPPED,"'",                 #CHI-A80044 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amdr200',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amdr200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
      LET l_cnt_11 = 0
      LET l_cnt_12 = 0
      LET l_cnt_13 = 0
      LET l_cnt_14 = 0
      LET l_cnt_15 = 0
      LET l_cnt_16 = 0
      LET l_cnt_21 = 0
      LET l_cnt_22 = 0
      LET l_cnt_23 = 0
      LET l_cnt_24 = 0
      LET l_cnt_25 = 0
      LET l_cnt_26 = 0
      LET l_cnt_3  = 0
      LET l_cnt_4  = 0
      LET l_cnt_5  = 0
 
      LET lt_cnt_11 = 0
      LET lt_cnt_12 = 0
      LET lt_cnt_13 = 0
      LET lt_cnt_14 = 0
      LET lt_cnt_15 = 0
      LET lt_cnt_16 = 0
      LET lt_cnt_21 = 0
      LET lt_cnt_22 = 0
      LET lt_cnt_23 = 0
      LET lt_cnt_24 = 0
      LET lt_cnt_25 = 0
      LET lt_cnt_26 = 0
      LET lt_cnt_3  = 0
      LET lt_cnt_4  = 0
      LET lt_cnt_5  = 0
   CALL r200()
   ERROR ""
END WHILE
   CLOSE WINDOW amdr200_w
END FUNCTION
 
FUNCTION r200()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074  VARCHAR(20) # External(Disk) file name
#         l_time    LIKE type_file.chr8        #No.FUN-6A0068
          l_sql     STRING,                    # RDSQL STATEMENT        #No.FUN-680074
          l_wc      STRING,                    #No.FUN-680074 VARCHAR(200) #MOD-B80224 mod chr1000 -> STRING
          l_st      LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_chr     LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          sr        RECORD
                     amd25  LIKE amd_file.amd25,  #營運中心編號
                     amd171 LIKE amd_file.amd171, #格式
                     amd01  LIKE amd_file.amd01,  #帳款單號/傳票編號
                     amd28  LIKE amd_file.amd28,  #傳票號碼
                     amd03  LIKE amd_file.amd03,  #發票號碼
                     ome042 LIKE ome_file.ome042, #發票客戶統一編號
                     amd173 LIKE amd_file.amd173, #資料年
                     amd174 LIKE amd_file.amd174, #資料月份
                     amd172 LIKE amd_file.amd172, #課稅別
                     amd08  LIKE amd_file.amd08,  #未稅金額
                     amd07  LIKE amd_file.amd07,  #稅
                     amd06  LIKE amd_file.amd06,  #含稅金額      #MOD-880093 add
                     amd04  LIKE amd_file.amd04   #廠商統一編號
                    END RECORD,
          l_byy     LIKE type_file.num5,          #No.FUN-850048
          l_eyy     LIKE type_file.num5,          #No.FUN-850048
          l_amd06   LIKE amd_file.amd06,          #CHI-940024 add
          l_amd07   LIKE amd_file.amd07,          #CHI-940024 add
          l_amd08   LIKE amd_file.amd08,          #CHI-940024 add
          l_amd08_1 LIKE amd_file.amd08,          #CHI-940024 add
          l_amd03   LIKE amd_file.amd03,          #MOD-B80224                                                                                
          l_amd25   LIKE amd_file.amd25,          #CHI-9A0039                                                                                         
          l_amd25_o LIKE amd_file.amd25,          #MOD-B80224
          l_oom07_o LIKE oom_file.oom07,          #MOD-C30798 add
          l_azp03   LIKE azp_file.azp03,          #CHI-9A0039                                                                                         
          l_oom     RECORD LIKE oom_file.*        #CHI-9A0039
   DEFINE l_str      STRING                       #MOD-B80224
   DEFINE l_str2     STRING                       #MOD-B80224
   DEFINE l_wc2      STRING                       #MOD-B80224
   DEFINE l_leng     LIKE type_file.num5          #MOD-B80224
   DEFINE l_pos      LIKE type_file.num5          #MOD-B80224 

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog          #No.FUN-850048
   CALL cl_del_data(l_table)                                         #No.FUN-850048
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND amduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND amdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND amdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('amduser', 'amdgrup')
   #End:FUN-980030
 
   #-->銷項
   LET l_sql = "SELECT amd25,amd171,amd01,amd28,amd03, ",
             # " ome042,amd173,amd174,amd172,amd08,amd07,amd06,amd04",   #MOD-880093 add amd06  #No.TQC-A40101
               " ''    ,amd173,amd174,amd172,amd08,amd07,amd06,amd04",   #MOD-880093 add amd06  #No.TQC-A40101
             # " FROM amd_file, OUTER ome_file ",                        #No.TQC-A40101
               " FROM amd_file ",                                        #No.TQC-A40101
               " WHERE (amd173*12+amd174) BETWEEN ",
                       (tm.amd01_y_b*12+tm.amd01_m_b)," AND ",
                       (tm.amd01_y_e*12+tm.amd01_m_e),
               "   AND amd171 LIKE '3%'",        # 因係銷項憑證
             # "   AND amd_file.amd03=ome_file.ome01",                   #No.TQC-A40101
              #"   AND amd30 = 'Y'",                #MOD-930128 #CHI-A80044 mark
               "   AND amd22 = '",tm.amd22,"'",     #CHI-AB0030 add
               "   AND ",tm.wc CLIPPED
   #CHI-A80044 add --start--
   IF tm.h = '1' THEN
      LET l_sql = l_sql CLIPPED," AND amd30 = 'Y'"
   END IF
   IF tm.h = '2' THEN
      LET l_sql = l_sql CLIPPED," AND amd30 = 'N'"
   END IF
   #CHI-A80044 add --end--
   #No.MOD-480459
   LET l_st = 'N'
   IF tm.f= 'Y' OR tm.g='Y' OR tm.i= 'Y' THEN
      LET l_wc = l_wc CLIPPED, " AND ("
      IF tm.f = 'Y' THEN
        #LET l_wc = l_wc CLIPPED,"(amd171='31' OR amd171='32' OR amd171='35')"                 #MOD-C30790 mark
         LET l_wc = l_wc CLIPPED,"(amd171='31' OR amd171='32' OR amd171='35' OR amd171='37')"  #MOD-C30790 add
         LET l_st = 'Y'
      END IF
      IF tm.g = 'Y' THEN
         IF l_st = 'Y' THEN
           #LET l_wc = l_wc CLIPPED,"OR (amd171='33' OR amd171='34')"                   #MOD-C30790 mark
            LET l_wc = l_wc CLIPPED,"OR (amd171='33' OR amd171='34' OR amd171='38')"    #MOD-C30790 add
            LET l_st = 'Y'
         ELSE
           #LET l_wc = l_wc CLIPPED,"(amd171='33' OR amd171='34')"                      #MOD-C30790 mark
            LET l_wc = l_wc CLIPPED,"(amd171='33' OR amd171='34' OR amd171='38')"       #MOD-C30790 add
            LET l_st = 'Y'
         END IF
      END IF
      IF tm.i = 'Y' THEN
         IF l_st='Y' THEN
            LET l_wc = l_wc CLIPPED,"OR amd171='36'"
            LET l_st = 'Y'
         ELSE
            LET l_wc = l_wc CLIPPED,"amd171='36'"
            LET l_st = 'Y'
         END IF
      END IF
      LET l_wc = l_wc CLIPPED,")"
   END IF
   LET l_sql = l_sql CLIPPED,l_wc CLIPPED
   LET l_sql = l_sql CLIPPED," ORDER BY amd25,amd171,amd172,amd01,amd28,amd03"   #MOD-8C0173 add
   #No.MOD-480459 (end)
 
   PREPARE r200_prepare  FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
   DECLARE r200_curs CURSOR FOR r200_prepare
#No.FUN-850048--begin--
#  CALL cl_outnam('amdr200') RETURNING l_name
#  START REPORT r200_rep TO l_name
#  LET g_pageno = 0
 
   LET l_chr = ' '                                     #CHI-940024 add
   LET l_amd06 = 0  LET l_amd07 = 0  LET l_amd08 = 0   #CHI-940024 add
   FOREACH r200_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#     OUTPUT TO REPORT r200_rep(sr.*)
      #-----MOD-9C0028---------                                                 
      LET sr.ome042 = ''                                                        
      SELECT ome042 INTO sr.ome042 FROM ome_file                                
        WHERE ome01 = sr.amd03                                                  
          AND ome00 = '1'                                                       
      #-----END MOD-9C0028-----
      IF cl_null(sr.ome042) THEN LET sr.ome042=sr.amd04 END IF
      CASE
         WHEN sr.amd172 = '1'
              CASE
                 WHEN sr.amd171 = '31' OR sr.amd171='35'
                      LET l_cnt_11 = l_cnt_11 + 1
                      LET lt_cnt_11 = lt_cnt_11 + 1
                 WHEN sr.amd171 = '32'
                      LET l_cnt_12 = l_cnt_12 + 1
                      LET lt_cnt_12 = lt_cnt_12 + 1
                 WHEN sr.amd171 = '33'
                      LET l_cnt_21 = l_cnt_21 + 1
                      LET lt_cnt_21 = lt_cnt_21 + 1
                 WHEN sr.amd171 = '34'
                      LET l_cnt_22 = l_cnt_22 + 1
                      LET lt_cnt_22 = lt_cnt_22 + 1
                 WHEN sr.amd171 = '36'
                      LET l_cnt_5 = l_cnt_5 + 1
                      LET lt_cnt_5 = lt_cnt_5 + 1
              END CASE
         WHEN sr.amd172 = '2'
              CASE
                 WHEN sr.amd171 = '31' OR sr.amd171='35'
                #No.+144 ..end
                      LET l_cnt_13 = l_cnt_13 + 1
                      LET lt_cnt_13 = lt_cnt_13 + 1
                 WHEN sr.amd171 = '32'
                      LET l_cnt_14 = l_cnt_14 + 1
                      LET lt_cnt_14 = lt_cnt_14 + 1
                 WHEN sr.amd171 = '33'
                      LET l_cnt_23 = l_cnt_23 + 1
                      LET lt_cnt_23 = lt_cnt_23 + 1
                 WHEN sr.amd171 = '34'
                      LET l_cnt_24 = l_cnt_24 + 1
                      LET lt_cnt_24 = lt_cnt_24 + 1
                 WHEN sr.amd171 = '36'
                      LET l_cnt_5 = l_cnt_5 + 1
                      LET lt_cnt_5 = lt_cnt_5 + 1
              END CASE
         WHEN sr.amd172 = '3'
              CASE
                 WHEN sr.amd171 = '31' OR sr.amd171='35'
                #No.+144 ..end
                      LET l_cnt_15 = l_cnt_15 + 1
                      LET lt_cnt_15 = lt_cnt_15 + 1
                 WHEN sr.amd171 = '32'
                      LET l_cnt_16 = l_cnt_16 + 1
                      LET lt_cnt_16 = lt_cnt_16 + 1
                 WHEN sr.amd171 = '33'
                      LET l_cnt_25 = l_cnt_25 + 1
                      LET lt_cnt_25 = lt_cnt_25 + 1
                 WHEN sr.amd171 = '34'
                      LET l_cnt_26 = l_cnt_26 + 1
                      LET lt_cnt_26 = lt_cnt_26 + 1
                 WHEN sr.amd171 = '36'
                      LET l_cnt_5 = l_cnt_5 + 1
                      LET lt_cnt_5 = lt_cnt_5 + 1
              END CASE
         WHEN sr.amd172 = 'F'  #FUN-A10039
             #CHI-9A0039   ---START     
             #IF sr.amd04 IS NULL THEN
             #   LET l_cnt_4 = l_cnt_4 + 1
             #   LET lt_cnt_4 = lt_cnt_4 + 1
             #ELSE
             #IF sr.amd04 IS NOT NULL THEN      #MOD-A60172 mark 
             #CHI-9A0039   ---END         
              LET l_cnt_3 = l_cnt_3 + 1
              LET lt_cnt_3 = lt_cnt_3 + 1
             #END IF                            #MOD-A60172 mark
      END CASE

     #str CHI-940024 add
      IF (sr.amd171='31' AND sr.amd172='1' AND sr.amd04='00000000') OR
         (sr.amd171='32' AND sr.amd172='1') THEN
         LET l_amd06 = l_amd06 + sr.amd06
         LET l_amd07 = l_amd07 + sr.amd07
         LET l_amd08 = l_amd08 + sr.amd08
      END IF
     #end CHI-940024 add

      EXECUTE insert_prep USING
         sr.amd25,sr.amd171,sr.amd173,sr.amd01, sr.amd28,
         sr.amd03,sr.ome042,sr.amd174,sr.amd172,sr.amd08,
         sr.amd07,sr.amd06, sr.amd04,   #MOD-880093 add sr.amd06,sr.amd04
         l_cnt_11, l_cnt_12, l_cnt_13, l_cnt_14, l_cnt_15, l_cnt_16,
         l_cnt_21, l_cnt_22, l_cnt_23, l_cnt_24, l_cnt_25, l_cnt_26,
        #l_cnt_5,  l_cnt_3,  l_cnt_4,                                    #MOD-A60172 mark
         l_cnt_5,  l_cnt_4,  l_cnt_3,                                    #MOD-A60172 
         lt_cnt_11,lt_cnt_12,lt_cnt_13,lt_cnt_14,lt_cnt_15,lt_cnt_16,
         lt_cnt_21,lt_cnt_22,lt_cnt_23,lt_cnt_24,lt_cnt_25,lt_cnt_26,
        #lt_cnt_5, lt_cnt_3, lt_cnt_4,                                   #MOD-A60172 mark
         lt_cnt_5, lt_cnt_4, lt_cnt_3,                                   #MOD-A60172
         l_chr   #CHI-940024 add
#     LET l_cnt_11 = 0
#     LET l_cnt_12 = 0
#     LET l_cnt_13 = 0
#     LET l_cnt_14 = 0
#     LET l_cnt_15 = 0
#     LET l_cnt_16 = 0
#     LET l_cnt_21 = 0
#     LET l_cnt_22 = 0
#     LET l_cnt_23 = 0
#     LET l_cnt_24 = 0
#     LET l_cnt_25 = 0
#     LET l_cnt_26 = 0
#     LET l_cnt_5 = 0
#     LET l_cnt_3 = 0
#     LET l_cnt_4 = 0
   END FOREACH

  #CHI-9A0039   ---start                                                                                                            
   IF tm.j='Y' THEN                                                                                                                 
#No.FUN-A10098 -------------mark start
#
#      LET l_sql="SELECT UNIQUE amd25 FROM amd_file ",                                                                               
#                " WHERE (amd173*12+amd174) BETWEEN ",                                                                               
#                       (tm.amd01_y_b*12+tm.amd01_m_b)," AND ",                                                                      
#                       (tm.amd01_y_e*12+tm.amd01_m_e),                                                                              
#                "   AND amd171 MATCHES '3*'",        # 因系销项凭证                                                                 
#                "   AND amd30 = 'Y'",                                                                                               
#                "   AND ",tm.wc CLIPPED                                                                                             
#      LET l_st = 'N'                                                                                                                
#      IF tm.f= 'Y' OR tm.g='Y' OR tm.i= 'Y' THEN                                                                                    
#         LET l_wc = l_wc CLIPPED, " AND ("                                                                                          
#         IF tm.f = 'Y' THEN                                                                                                         
#            LET l_wc = l_wc CLIPPED,"(amd171='31' OR amd171='32' OR amd171='35')"                                                   
#            LET l_st = 'Y'                                                                                                          
#         END IF                                                                                                                     
#         IF tm.g = 'Y' THEN                                                                                                         
#            IF l_st = 'Y' THEN         
#               LET l_wc = l_wc CLIPPED,"OR (amd171='33' OR amd171='34')"                                                            
#               LET l_st = 'Y'                                                                                                       
#            ELSE                                                                                                                    
#               LET l_wc = l_wc CLIPPED,"(amd171='33' OR amd171='34')"                                                               
#               LET l_st = 'Y'                                                                                                       
#            END IF                                                                                                                  
#         END IF                                                                                                                     
#         IF tm.i = 'Y' THEN                                                                                                         
#            IF l_st='Y' THEN                                                                                                        
#               LET l_wc = l_wc CLIPPED,"OR amd171='36'"                                                                             
#               LET l_st = 'Y'                                                                                                       
#            ELSE                                                                                                                    
#               LET l_wc = l_wc CLIPPED,"amd171='36'"                                                                                
#               LET l_st = 'Y'                                                                                                       
#            END IF                                                                                                                  
#         END IF                                                                                                                     
#         LET l_wc = l_wc CLIPPED,")"                                                                                                
#      END IF                                                                                                                        
#      LET l_sql = l_sql CLIPPED,l_wc CLIPPED                                                                                        
#      LET l_sql = l_sql CLIPPED," ORDER BY amd25"                                                                                   
#      PREPARE amd25_pre FROM l_sql                                                                                                  
#      DECLARE amd25_cs CURSOR FOR amd25_pre                                                                                         
#      FOREACH amd25_cs INTO l_amd25                                                                                                 
#         IF SQLCA.sqlcode != 0 THEN      
#             CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                 
#            EXIT FOREACH                                                                                                            
#         END IF                                                                                                                     
#         SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=l_amd25                                                                
#         IF SQLCA.sqlcode !=0 THEN                                                                                                  
#            CALL cl_err('sel azp03',SQLCA.sqlcode,1)                                                                                
#            EXIT FOREACH                                                                                                            
#         END IF                                                                                                                     
#No.FUN-A10098 -------------mark end 
         #-MOD-B80224-add-
          LET l_sql = "SELECT amd25,amd03",
                      "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     #" ORDER BY amd25 "                                  #MOD-C30798 mark
                      " ORDER BY amd25,amd03"                             #MOD-C30798 add
          PREPARE r200_pre_oom  FROM l_sql
          IF SQLCA.SQLCODE THEN CALL cl_err('pre_oom',STATUS,0) END IF
          DECLARE r200_cur_oom CURSOR FOR r200_pre_oom

          LET l_str = cl_replace_str(tm.wc, "amd03", "oom07") 
          LET l_leng = l_str.getlength() 
          LET l_pos = l_str.getindexof('oom07',1) 
          LET l_str2 = l_str.substring(l_pos,l_leng)
          LET l_pos = l_str2.getindexof('amd',1) 
          IF l_pos > 0 THEN
             LET l_wc2 = l_str2.substring(1,l_pos-5)
          ELSE
             LET l_wc2 = l_str2 
          END IF
         #-MOD-B80224-end-
#         LET l_sql ="SELECT * ",                                         #No.FUN-A10098 -------------mark 
#                    "  FROM ",s_dbstring(l_azp03 CLIPPED),"oom_file",    #No.FUN-A10098 -------------mark
          LET l_sql ="SELECT * FROM oom_file",                            #No.FUN-A10098 -------------add 
                    " WHERE oom01 BETWEEN ",tm.amd01_y_b," AND ",tm.amd01_y_e,                                                      
                    "   AND oom02 >=",tm.amd01_m_b,                                                                                 
                    "   AND oom021<=",tm.amd01_m_e,                                                                                 
                    "   AND oom04 <> 'X' ",                                                                                         
                    "   AND (oom08 <> oom09 OR oom09 IS NULL)", 
         #-MOD-B80224-add-
                    "   AND ? BETWEEN oom07 AND oom08 " 
          IF NOT cl_null(l_wc2) THEN                 
             LET l_sql = l_sql CLIPPED,"   AND ",l_wc2 CLIPPED
          END IF                                 
          #-MOD-B80224-end-
          PREPARE oom_pre FROM l_sql                                                                                                 
          DECLARE oom_cs CURSOR FOR oom_pre                                                                                          
          LET l_amd25_o = ''                              #MOD-B80224
          LET l_oom07_o = ''                              #MOD-C30798
          FOREACH r200_cur_oom INTO l_amd25,l_amd03       #MOD-B80224 
            #FOREACH oom_cs INTO l_oom.*                  #MOD-B80224 mark           
             FOREACH oom_cs USING l_amd03 INTO l_oom.*    #MOD-B80224 
                IF SQLCA.sqlcode != 0 THEN                                                                                              
                   CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                              
                   EXIT FOREACH                                                                                                         
                END IF                                                                                                                  
                LET l_oom.oom08=l_oom.oom08[3,10]                                                                                       
                IF l_oom.oom09 IS NOT NULL THEN   
                   LET l_oom.oom09=l_oom.oom09[3,10]                                                                                    
                   LET l_cnt_4=l_cnt_4+(l_oom.oom08-l_oom.oom09)                                                                        
                ELSE                                                                                                                    
                   LET l_oom.oom07=l_oom.oom07[3,10]                                                                                    
                   LET l_cnt_4=l_cnt_4+(l_oom.oom08-l_oom.oom07+1)                                                                      
                END IF                                                                                                                  
             END FOREACH                                                                                                                
             EXECUTE update_prep1 USING l_cnt_4,l_amd25     #No.FUN-A10098 -------------mark #MOD-B80224 remark 
            #IF cl_null(l_amd25_o) OR l_amd25 <> l_amd25_o THEN       #MOD-B80224 #MOD-C30798 mark
             IF cl_null(l_amd25_o) OR l_amd25 <> l_amd25_o OR         #MOD-C30798
                cl_null(l_oom07_o) OR l_oom.oom07 <> l_oom07_o THEN   #MOD-C30798
                LET lt_cnt_4=lt_cnt_4+l_cnt_4                                                                                              
             END IF                             #MOD-B80224
             LET l_cnt_4=0                                                                                                              
             LET l_amd25_o = l_amd25            #MOD-B80224
             LET l_oom07_o = l_oom.oom07        #MOD-C30798 add
          END FOREACH                                 #No.FUN-A10098 -------------mark #MOD-B80224 remark
      EXECUTE update_prep2 USING lt_cnt_4                                                                                           
      LET lt_cnt_4=0                                                                                                                
   END IF                                                                                                                           
  #CHI-9A0039   ---end        

  #str CHI-940024 add
   LET l_amd08_1 = cl_digcut(l_amd06/1.05,0) 
   #計算後合計(l_amd08_1)與明細逐筆合計(l_amd08)相比有差異,
   #看相差幾元,差幾元找幾筆,在明細前面加秀*
  #IF l_amd08_1 - l_amd08 > 0 THEN    #MOD-B50125 mark
   IF l_amd08_1 - l_amd08 != 0 THEN   #MOD-B50125
      LET l_sql = "SELECT amd25,amd171,amd01,amd28,amd03",
                  "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " WHERE (amd171='31' AND amd172='1' AND amd04='00000000')",
                  "    OR (amd171='32' AND amd172='1')",
                  " ORDER BY amd08 DESC"
      PREPARE r200_prepare_x  FROM l_sql
      IF SQLCA.SQLCODE THEN CALL cl_err('prepare_x',STATUS,0) END IF
      DECLARE r200_curs_x CURSOR FOR r200_prepare_x

      LET l_cnt = l_amd08_1 - l_amd08    #差異金額
      IF l_cnt < 0 THEN LET l_cnt = l_cnt * -1 END IF
         
      LET g_i = 1
      FOREACH r200_curs_x INTO sr.amd25,sr.amd171,sr.amd01,sr.amd28,sr.amd03
         EXECUTE UPDATE_prep USING
            sr.amd25,sr.amd171,sr.amd01,sr.amd28,sr.amd03
         LET g_i = g_i + 1
         IF g_i > l_cnt THEN EXIT FOREACH END IF
      END FOREACH 
   END IF
  #end CHI-940024 add

#  FINISH REPORT r200_rep
  
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'amd28,amd03,amd01,amd05,amd25,amd171,amd17')
      RETURNING tm.wc
      LET g_str = tm.wc
   END IF
#FUN-860041-modify
#  LET l_byy = tm.amd01_y_b - 1911 USING '##'
#  LET l_eyy = tm.amd01_y_e - 1911 USING '##'
   LET l_byy = tm.amd01_y_b - 1911
   LET l_eyy = tm.amd01_y_e - 1911
#FUN-860041-modify-end
   LET g_str = g_str,";",l_byy,";",tm.amd01_m_b,";",l_eyy,";",tm.amd01_m_e,";",
               tm.f,";",tm.g,";",tm.i,";",tm.j,";",g_azi05
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('amdr200','amdr200',g_sql,g_str)
#No.FUN-850048--end--
END FUNCTION
#No.FUN-850048--begin--
#REPORT r200_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
#       l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#          sr        RECORD
#                    amd25  LIKE amd_file.amd25,   #
#                    amd171 LIKE amd_file.amd171,  #
#                    amd01  LIKE amd_file.amd01,   #
#                    amd28  LIKE amd_file.amd28,   #
#                    amd03  LIKE amd_file.amd03,   #
#                    ome042 LIKE ome_file.ome042,  #
#                    amd173 LIKE amd_file.amd173,  #
#                    amd174 LIKE amd_file.amd174,  #
#                    amd172 LIKE amd_file.amd172,  #
#                    amd08  LIKE amd_file.amd08,   #
#                    amd07  LIKE amd_file.amd07,   #
#                    amd04  LIKE amd_file.amd04    #
#         END RECORD,
# 
# 
#       l_amt_11     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_amt_12     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_amt_13     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_amt_14     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_amt_21     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_amt_22     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_amt_31     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_amt_32     LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_11    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_12    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_13    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_14    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_21    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_22    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_31    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       lt_amt_32    LIKE type_file.num20_6,    #No.FUN-680074 DECIMAL(20,6)
#       l_byy        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#       l_eyy        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#       g_head1      STRING,                    #No.FUN-680074
#       l_str        STRING                     #No.FUN-680074
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#   ORDER BY sr.amd25,sr.amd171,sr.amd172,sr.amd03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET l_byy = tm.amd01_y_b - 1911
#      LET l_eyy = tm.amd01_y_e - 1911
#
##FUN-860041-modify
##     LET g_head1 = g_x[9] CLIPPED, l_byy USING '##',
#      LET g_head1 = g_x[9] CLIPPED, l_byy USING '###',
#                    g_x[10] CLIPPED, tm.amd01_m_b USING '##',
##                   g_x[11] CLIPPED,l_eyy  USING '##',
#                   g_x[11] CLIPPED,l_eyy  USING '###',
#                   g_x[10] CLIPPED,tm.amd01_m_e USING '##',g_x[12] CLIPPED
##FUN-860041-modify-end
#
#     #PRINT g_head1                      #FUN-660060 remark
#     PRINT COLUMN (g_len-25)/2+1,g_head1 #FUN-660060
#     PRINT g_dash[1,g_len]
#     PRINT g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],
#           g_x[55],g_x[56]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.amd25
#    #IF tm.k = '1' THEN                                  #CHI-6C0038 mark
#    #   IF PAGENO > 0 THEN SKIP TO TOP OF PAGE END IF    #CHI-6C0038 mark 
#    #ELSE                                                #CHI-6C0038 mark
#        PRINT COLUMN g_c[47],sr.amd25[1,8]; 
#    #END IF                                              #CHI-6C0038 mark
#
#  BEFORE GROUP OF sr.amd171
#    #IF tm.k = '2' THEN                                  #CHI-6C0038 mark
#        PRINT COLUMN g_c[48],sr.amd171;
#    #END IF                                              #CHI-6C0038 mark
#
#  AFTER GROUP OF sr.amd03
#     LET l_byy = sr.amd173-1911
#    #CHI-6C0038---mark---str---
#    #IF tm.k = '1' THEN
#    #   PRINT COLUMN g_c[47],sr.amd25[1,8];
#    #   PRINT COLUMN g_c[48],sr.amd171;
#    #END IF
#    #CHI-6C0038---mark---end---
#     IF cl_null(sr.ome042) THEN LET sr.ome042=sr.amd04 END IF #NO:7486若不是AR/AP拋時抓amd04來取代
#     PRINT COLUMN g_c[49],sr.amd01,
#           COLUMN g_c[50],sr.amd28,
#           COLUMN g_c[51],sr.amd03[1,10],
##MOD-590359
#            COLUMN g_c[52],sr.ome042,
##           COLUMN g_c[52],sr.ome042[1,10],
##MOD-590359 End
##FUN-860041-modify
##           COLUMN g_c[53],l_byy USING '&&',sr.amd174 USING '&&',
#            COLUMN g_c[53],l_byy USING '&&&',sr.amd174 USING '&&',
##FUN-860041-modify-end
#           COLUMN g_c[54],sr.amd172,
#           COLUMN g_c[55],cl_numfor(group sum(sr.amd08),55,g_azi05),
#           COLUMN g_c[56],cl_numfor(group sum(sr.amd07),56,g_azi05)
#
#     CASE
#        WHEN sr.amd172 = '1'
#             CASE
#               #No.+144 by plum 010528 mod
#               #WHEN sr.amd171 = '31'
#                WHEN sr.amd171 = '31' OR sr.amd171='35'
#               #No.+144..end
#                     LET l_cnt_11 = l_cnt_11 + 1
#                     LET lt_cnt_11 = lt_cnt_11 + 1
#                WHEN sr.amd171 = '32'
#                     LET l_cnt_12 = l_cnt_12 + 1
#                     LET lt_cnt_12 = lt_cnt_12 + 1
#                WHEN sr.amd171 = '33'
#                     LET l_cnt_21 = l_cnt_21 + 1
#                     LET lt_cnt_21 = lt_cnt_21 + 1
#                WHEN sr.amd171 = '34'
#                     LET l_cnt_22 = l_cnt_22 + 1
#                     LET lt_cnt_22 = lt_cnt_22 + 1
#                WHEN sr.amd171 = '36'
#                     LET l_cnt_5 = l_cnt_5 + 1
#                     LET lt_cnt_5 = lt_cnt_5 + 1
#             END CASE
#        WHEN sr.amd172 = '2'
#             CASE
#               #No.+144 by plum 010528 mod
#               #WHEN sr.amd171 = '31'
#                WHEN sr.amd171 = '31' OR sr.amd171='35'
#               #No.+144 ..end
#                     LET l_cnt_13 = l_cnt_13 + 1
#                     LET lt_cnt_13 = lt_cnt_13 + 1
#                WHEN sr.amd171 = '32'
#                     LET l_cnt_14 = l_cnt_14 + 1
#                     LET lt_cnt_14 = lt_cnt_14 + 1
#                WHEN sr.amd171 = '33'
#                     LET l_cnt_23 = l_cnt_23 + 1
#                     LET lt_cnt_23 = lt_cnt_23 + 1
#                WHEN sr.amd171 = '34'
#                     LET l_cnt_24 = l_cnt_24 + 1
#                     LET lt_cnt_24 = lt_cnt_24 + 1
#                WHEN sr.amd171 = '36'
#                     LET l_cnt_5 = l_cnt_5 + 1
#                     LET lt_cnt_5 = lt_cnt_5 + 1
#             END CASE
#        WHEN sr.amd172 = '3'
#             CASE
#               #No.+144 plum 010528 mod
#               #WHEN sr.amd171 = '31'
#                WHEN sr.amd171 = '31' OR sr.amd171='35'
#               #No.+144 ..end
#                     LET l_cnt_15 = l_cnt_15 + 1
#                     LET lt_cnt_15 = lt_cnt_15 + 1
#                WHEN sr.amd171 = '32'
#                     LET l_cnt_16 = l_cnt_16 + 1
#                     LET lt_cnt_16 = lt_cnt_16 + 1
#                WHEN sr.amd171 = '33'
#                     LET l_cnt_25 = l_cnt_25 + 1
#                     LET lt_cnt_25 = lt_cnt_25 + 1
#                WHEN sr.amd171 = '34'
#                     LET l_cnt_26 = l_cnt_26 + 1
#                     LET lt_cnt_26 = lt_cnt_26 + 1
#                WHEN sr.amd171 = '36'
#                     LET l_cnt_5 = l_cnt_5 + 1
#                     LET lt_cnt_5 = lt_cnt_5 + 1
#             END CASE
#        WHEN sr.amd172 = 'D'
#             IF sr.amd04 IS NULL THEN
#                LET l_cnt_4 = l_cnt_4 + 1
#                LET lt_cnt_4 = lt_cnt_4 + 1
#             ELSE
#                LET l_cnt_3 = l_cnt_3 + 1
#                LET lt_cnt_3 = lt_cnt_3 + 1
#             END IF
#     END CASE
#
#  AFTER GROUP OF sr.amd25
#
# #IF tm.k = '1' THEN            #CHI-6C0038 mark
#     IF LINENO < 8 THEN
#        SKIP TO TOP OF PAGE
#     END IF
#     SKIP 2 LINE
#
#   #銷項
#    IF tm.f='Y' THEN
#    #No.+144 BY plum 010528 31/35
#     LET l_amt_11 = GROUP SUM(sr.amd08)  WHERE sr.amd172='1' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#     LET l_amt_12 = GROUP SUM(sr.amd07)  WHERE sr.amd172='1' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#     LET l_amt_21 = GROUP SUM(sr.amd08)  WHERE sr.amd172='2' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#     LET l_amt_31 = GROUP SUM(sr.amd08)  WHERE sr.amd172='3' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#    #No.+144.end
#     LET l_amt_13 = GROUP SUM(sr.amd08)  WHERE sr.amd172='1' AND sr.amd171='32'
#     LET l_amt_14 = GROUP SUM(sr.amd07)  WHERE sr.amd172='1' AND sr.amd171='32'
#     LET l_amt_22 = GROUP SUM(sr.amd08)  WHERE sr.amd172='2' AND sr.amd171='32'
#     LET l_amt_32 = GROUP SUM(sr.amd08)  WHERE sr.amd172='3' AND sr.amd171='32'
#     LET l_str = g_x[13] CLIPPED,l_cnt_11 USING '######','     ',
#                 g_x[14] CLIPPED,cl_numfor(l_amt_11,55,0),'     ',
#                 g_x[15] CLIPPED,cl_numfor(l_amt_12,56,0)
#     PRINT l_str
#     LET l_str = g_x[16] CLIPPED,l_cnt_12 USING '######','     ',
#                 g_x[14] CLIPPED,cl_numfor(l_amt_13,55,0),'     ',
#                 g_x[15] CLIPPED,cl_numfor(l_amt_14,56,0)
#     PRINT l_str
#     LET l_str = g_x[17] CLIPPED,l_cnt_13 USING '######','     ',
#                 g_x[14] CLIPPED,cl_numfor(l_amt_21,55,0)
#     PRINT l_str
#     LET l_str = g_x[18] CLIPPED,l_cnt_14 USING '######','     ',
#                 g_x[14] CLIPPED,cl_numfor(l_amt_22,55,0)
#     PRINT l_str
#     LET l_str = g_x[19] CLIPPED,l_cnt_15 USING '######','     ',
#                 g_x[14] CLIPPED,cl_numfor(l_amt_31,55,0)
#     PRINT l_str
#     LET l_str = g_x[20] CLIPPED,l_cnt_16 USING '######','     ',
#                 g_x[14] CLIPPED,cl_numfor(l_amt_32,55,0)
#     LET l_cnt_11 = 0
#     LET l_cnt_12 = 0
#     LET l_cnt_13 = 0
#     LET l_cnt_14 = 0
#     LET l_cnt_15 = 0
#     LET l_cnt_16 = 0
#  #END IF              #CHI-6C0038 mark
#     PRINT ' '         #CHI-6C0038 add 
#
#    #折讓
#    IF tm.g='Y' THEN
#       LET l_amt_11=GROUP SUM(sr.amd08) WHERE sr.amd172='1' AND sr.amd171='33'
#       LET l_amt_12=GROUP SUM(sr.amd07) WHERE sr.amd172='1' AND sr.amd171='33'
#       LET l_amt_13=GROUP SUM(sr.amd08) WHERE sr.amd172='1' AND sr.amd171='34'
#       LET l_amt_14=GROUP SUM(sr.amd07) WHERE sr.amd172='1' AND sr.amd171='34'
#       LET l_amt_21=GROUP SUM(sr.amd08) WHERE sr.amd172='2' AND sr.amd171='33'
#       LET l_amt_22=GROUP SUM(sr.amd08) WHERE sr.amd172='2' AND sr.amd171='34'
#       LET l_amt_31=GROUP SUM(sr.amd08) WHERE sr.amd172='3' AND sr.amd171='33'
#       LET l_amt_32=GROUP SUM(sr.amd08) WHERE sr.amd172='3' AND sr.amd171='34'
#       LET l_str = g_x[21] CLIPPED,l_cnt_21 USING '######','     ',
#                   g_x[14] CLIPPED,cl_numfor(l_amt_11,55,0),'     ',
#                   g_x[15] CLIPPED,cl_numfor(l_amt_12,56,0)
#       PRINT l_str
#       LET l_str = g_x[22] CLIPPED,l_cnt_22 USING '######','     ',
#                   g_x[14] CLIPPED,cl_numfor(l_amt_13,55,0),'     ',
#                   g_x[15] CLIPPED,cl_numfor(l_amt_14,56,0)
#       PRINT l_str
#       LET l_str = g_x[23] CLIPPED,l_cnt_23 USING '######','     ',
#                   g_x[14] CLIPPED,cl_numfor(l_amt_21,55,0)
#       PRINT l_str
#       LET l_str = g_x[24] CLIPPED,l_cnt_24 USING '######','     ',
#                   g_x[14] CLIPPED,cl_numfor(l_amt_22,55,0)
#       PRINT l_str
#       LET l_str = g_x[25] CLIPPED,l_cnt_25 USING '######','     ',
#                   g_x[14] CLIPPED,cl_numfor(l_amt_31,55,0)
#       PRINT l_str
#       LET l_str = g_x[26] CLIPPED,l_cnt_26 USING '######','     ',
#                   g_x[14] CLIPPED,cl_numfor(l_amt_32,55,0)
#       PRINT l_str
#       LET l_cnt_21 = 0
#       LET l_cnt_22 = 0
#       LET l_cnt_23 = 0
#       LET l_cnt_24 = 0
#       LET l_cnt_25 = 0
#       LET l_cnt_26 = 0
#    END IF
#    IF tm.i='Y' THEN
#       LET l_amt_11 = GROUP SUM(sr.amd08) WHERE sr.amd171='36'
#         LET l_str = g_x[27] CLIPPED,l_cnt_5 USING '#####','      ',
#                     g_x[14] CLIPPED,cl_numfor(l_amt_11,55,0)
#         PRINT l_str
#       LET l_cnt_5 = 0
#    END IF
#    IF tm.j='Y' THEN
#         PRINT COLUMN 01,g_x[28] CLIPPED,l_cnt_3 USING '####'
#         PRINT COLUMN 01,g_x[29] CLIPPED,l_cnt_4 USING '####'
#       LET l_cnt_3 = 0
#       LET l_cnt_4 = 0
#    END IF
#  END IF
#
#  ON LAST ROW
###     IF g_idx > 1 THEN
#       SKIP 2 LINES
#       PRINT g_dash[1,g_len]
#       SKIP 1 LINES
#    IF tm.f='Y' THEN
#      #No.+144 plum 010528 31/35
#      #LET lt_amt_11 = SUM(sr.amd08) WHERE sr.amd172='1' AND sr.amd171='31'
#      #LET lt_amt_12 = SUM(sr.amd07) WHERE sr.amd172='1' AND sr.amd171='31'
#      #LET lt_amt_21 = SUM(sr.amd08) WHERE sr.amd172='2' AND sr.amd171='31'
#      #LET lt_amt_31 = SUM(sr.amd08) WHERE sr.amd172='3' AND sr.amd171='31'
#       LET lt_amt_11 = SUM(sr.amd08) WHERE sr.amd172='1' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#       LET lt_amt_12 = SUM(sr.amd07) WHERE sr.amd172='1' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#       LET lt_amt_21 = SUM(sr.amd08) WHERE sr.amd172='2' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#       LET lt_amt_31 = SUM(sr.amd08) WHERE sr.amd172='3' AND
#                                         (sr.amd171='31' OR sr.amd171='35')
#      #No.+144...end
#       LET lt_amt_13 = SUM(sr.amd08) WHERE sr.amd172='1' AND sr.amd171='32'
#       LET lt_amt_14 = SUM(sr.amd07) WHERE sr.amd172='1' AND sr.amd171='32'
#       LET lt_amt_22 = SUM(sr.amd08) WHERE sr.amd172='2' AND sr.amd171='32'
#       LET lt_amt_32 = SUM(sr.amd08) WHERE sr.amd172='3' AND sr.amd171='32'
#       LET l_str = g_x[30] CLIPPED,lt_cnt_11 USING '######','     ',
#                   g_x[31] CLIPPED,cl_numfor(lt_amt_11,55,0),'     ',
#                   g_x[32] CLIPPED,cl_numfor(lt_amt_12,56,0)
#       PRINT l_str
#       LET l_str = g_x[33] CLIPPED,lt_cnt_12 USING '######','     ',
#                   g_x[31] CLIPPED,cl_numfor(lt_amt_13,55,0),'     ',
#                   g_x[32] CLIPPED,cl_numfor(lt_amt_14,56,0)
#       PRINT l_str
#       LET l_str = g_x[34] CLIPPED,lt_cnt_13 USING '######','     ',
#                   g_x[31] CLIPPED,cl_numfor(lt_amt_21,55,0)
#       PRINT l_str
#       LET l_str = g_x[35] CLIPPED,lt_cnt_14 USING '######','     ',
#                   g_x[31] CLIPPED,cl_numfor(lt_amt_22,55,0)
#       PRINT l_str
#       LET l_str = g_x[36] CLIPPED,lt_cnt_15 USING '######','     ',
#                   g_x[31] CLIPPED,cl_numfor(lt_amt_31,55,0)
#       PRINT l_str
#       LET l_str = g_x[37] CLIPPED,lt_cnt_16 USING '######','     ',
#                   g_x[31] CLIPPED,cl_numfor(lt_amt_32,55,0)
#       PRINT l_str
#    END IF
#
#      #折讓
#      IF tm.g='Y' THEN
#         LET l_amt_11 = SUM(sr.amd08) WHERE sr.amd172='1' AND sr.amd171='33'
#         LET l_amt_12 = SUM(sr.amd07) WHERE sr.amd172='1' AND sr.amd171='33'
#         LET l_amt_13 = SUM(sr.amd08) WHERE sr.amd172='1' AND sr.amd171='34'
#         LET l_amt_14 = SUM(sr.amd07) WHERE sr.amd172='1' AND sr.amd171='34'
#         LET l_amt_21 = SUM(sr.amd08) WHERE sr.amd172='2' AND sr.amd171='33'
#         LET l_amt_22 = SUM(sr.amd08) WHERE sr.amd172='2' AND sr.amd171='34'
#         LET l_amt_31 = SUM(sr.amd08) WHERE sr.amd172='3' AND sr.amd171='33'
#         LET l_amt_32 = SUM(sr.amd08) WHERE sr.amd172='3' AND sr.amd171='34'
#         LET l_str = g_x[38] CLIPPED,lt_cnt_21 USING '######',' ',
#                     g_x[31] CLIPPED,cl_numfor(l_amt_11,12,0),'           ',
#                     g_x[32] CLIPPED,cl_numfor(l_amt_12,12,0)
#         PRINT l_str
#         LET l_str = g_x[39] CLIPPED,lt_cnt_22 USING '######',' ',
#                     g_x[31] CLIPPED,cl_numfor(l_amt_13,12,0),'           ',
#                     g_x[32] CLIPPED,cl_numfor(l_amt_14,12,0)
#         PRINT l_str
#         LET l_str = g_x[40] CLIPPED,lt_cnt_23 USING '######','   ',
#                     g_x[31] CLIPPED,cl_numfor(l_amt_21,12,0)
#         PRINT l_str
#         LET l_str = g_x[41] CLIPPED,lt_cnt_24 USING '######','   ',
#                     g_x[31] CLIPPED,cl_numfor(l_amt_22,12,0)
#         PRINT l_str
#         LET l_str = g_x[42] CLIPPED,lt_cnt_25 USING '######','   ',
#                     g_x[31] CLIPPED,cl_numfor(l_amt_31,12,0)
#         PRINT l_str
#         LET l_str = g_x[43] CLIPPED,lt_cnt_26 USING '######','   ',
#                     g_x[31] CLIPPED,cl_numfor(l_amt_32,12,0)
#         PRINT l_str
#      END IF
#      IF tm.i='Y' THEN
#         LET l_amt_11 = SUM(sr.amd08) WHERE sr.amd171='36'
#         LET l_str = g_x[44] CLIPPED,lt_cnt_5 USING '#####','        ',
#                     g_x[31] CLIPPED,cl_numfor(l_amt_11,12,0)
#         PRINT l_str
#      END IF
#      IF tm.j='Y' THEN
#           PRINT COLUMN 01,g_x[45] CLIPPED,lt_cnt_3 USING '####'
#           PRINT COLUMN 01,g_x[46] CLIPPED,lt_cnt_4 USING '####'
#      END IF
#    PRINT g_dash[1,g_len]
#    LET l_last_sw = 'y'
#       PRINT COLUMN g_c[47],g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT COLUMN g_c[47],g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850048--end--

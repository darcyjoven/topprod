# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr020.4gl
# Descriptions...: 工單領料差異表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/10 By Nick
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/24 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為dec(20,6)
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-610092 06/05/25 By Joe 增加庫存單位欄位
# Modify.........: No.FUN-670094 06/07/25 By Sarah 增加計算拆件式工單本月投入、本月轉出之數量/金額
# Modify.........: No.FUN-680007 06/08/03 By Sarah 將FUN-670094抓ccu_file的部份改成抓cch_file
# Modify.........: No.FUN-680122 06/08/31 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-750098 07/06/25 By hongmei Crystal Report修改
# Modify.........: No.FUN-7C0101 08/01/23 By ChenMoyan 成本改善
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860318 08/06/27 By wujie 多抓一次cch，導致數據翻倍
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A50166 10/04/26 By Carrier LIKE 用%,追单FUN-7C0101
# Modify.........: No:MOD-A90104 10/09/16 By Summer 調整axcr020_prepare1的l_sql,GROUP BY 1,2,3,5改為GROUP BY 1,2,3,4,5,7
# Modify.........: No:MOD-AB0030 10/11/03 By sabrina axcr020_prepare2的sql少抓ccc07,ccc08
# Modify.........: No:MOD-C30729 12/03/15 By ck2yuan 若未AFTER FIELD mm 不會是畫面上年度期別,改在AFTER INPUT才CALL s_azm
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(600)      # Where condition
              yy,mm   LIKE type_file.num5,           #No.FUN-680122SMALLINT
              n       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              d_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)         # Input more condition(Y/N)
             ,type    LIKE type_file.chr1            #No.FUN-7C0101
              END RECORD,
          g_tot_bal LIKE type_file.num20_6        #No.FUN-680122DECIMAL(20,6)     # User defined variable
   DEFINE bdate   LIKE type_file.dat            #No.FUN-680122DATE
   DEFINE edate   LIKE type_file.dat            #No.FUN-680122DATE
   DEFINE g_argv1 LIKE type_file.chr20          #No.FUN-680122CHAR(20)
   DEFINE g_argv2 LIKE type_file.num5           #No.FUN-680122SMALLINT
   DEFINE g_argv3 LIKE type_file.num5           #No.FUN-680122SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
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
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
#No.FUN-750098-------Begin 
   LET g_sql = "ima01.ima_file.ima01,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "l_ima25.ima_file.ima25,",
               "type.type_file.chr1,",
               "ccc08.ccc_file.ccc08,",           #No.FUN-7C0101
            #   "qty1.ima_file.ima26,",#FUN-A20044
               "qty1.type_file.num15_3,",#FUN-A20044
            #   "qty2.ima_file.ima26,",  #FUN-A20044
               "qty2.type_file.num15_3,",  #FUN-A20044
               "amt1.type_file.num20_6,",
               "amt2.type_file.num20_6"
   LET l_table = cl_prt_temptable('axcr020',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
#              " VALUES(?,?,?,?,?,?,?,?,?)"       #No.FUN-7C0101
               " VALUES(?,?,?,?,?,?,?,?,?,?)"     #No.FUN-7C0101                                                                 
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-750098---------End            
   
   #TQC-610051-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.more = 'N'
   #LET tm.n = 3 
   #LET tm.d_sw = 'Y' 
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_argv1 = ARG_VAL(1)        # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)        # Get arguments from command line
   #LET g_argv3 = ARG_VAL(3)        # Get arguments from command line
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(4)
   #LET g_rep_clas = ARG_VAL(5)
   #LET g_template = ARG_VAL(6)
   ##No.FUN-570264 ---end---
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)        # Get arguments from command line
   LET tm.yy   = ARG_VAL(8)        # Get arguments from command line
   LET tm.mm   = ARG_VAL(9)        # Get arguments from command line
   LET tm.n    = ARG_VAL(10)        # Get arguments from command line
   LET tm.d_sw = ARG_VAL(11)        # Get arguments from command line
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.type = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #IF cl_null(g_argv1)
   # Prog. Version..: '5.30.06-13.03.12(0,0)        # Input print condition
   #   ELSE LET tm.wc=" ima01='",g_argv1,"'"
   #        LET tm.yy=g_argv2
   #        LET tm.mm=g_argv3
   #        CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
   #        CALL axcr020()            # Read data and create out-file
   #END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL axcr020_tm(0,0)          # Input print condition
      ELSE 
           CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
           CALL axcr020()                # Read data and create out-file
   END IF
   #TQC-610051-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr020_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr020_w AT p_row,p_col
        WITH FORM "axc/42f/axcr020" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
 
   #TQC-610051-begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.n = 3 
   LET tm.yy = YEAR(g_today)          #No.FUN-7C0101
   LET tm.mm = MONTH(g_today)         #No.FUN-7C0101
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101
   LET tm.d_sw = 'Y' 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #TQC-610051-begin
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01, ima06, ima10, ima12, ima08, ima09, ima11
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
            IF INFIELD(ima01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO ima01                                                                                 
               NEXT FIELD ima01                                                                                                     
            END IF  
#No.FUN-570240 --end-- 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr020_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
  #LET tm.wc=tm.wc CLIPPED," AND ima01 NOT LIKE 'MISC*'"  #No.TQC-A50166
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT LIKE 'MISC%'"  #No.TQC-A50166
#  INPUT BY NAME tm.yy,tm.mm,tm.n,tm.d_sw,tm.more WITHOUT DEFAULTS         #No.FUN-7C0101
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.n,tm.d_sw,tm.more WITHOUT DEFAULTS #No.FUN-7C0101
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      #No.FUN-7C0101 --Begin
      AFTER FIELD type                                                                                                                 
         IF tm.type NOT MATCHES "[12345]" THEN NEXT FIELD type END IF 
      #No.FUN-7C0101 --End
      AFTER FIELD n
         IF tm.n IS NULL OR tm.n NOT MATCHES "[123]" THEN NEXT FIELD n END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      AFTER INPUT                                               #MOD-C30729 add
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate    #MOD-C30729 add

################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr020_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr020'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr020','9031',1)   
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
                         #TQC-610051-begin
                         " '",tm.yy  CLIPPED,"'",
                         " '",tm.mm  CLIPPED,"'",
                         " '",tm.type  CLIPPED,"'",
                         " '",tm.n   CLIPPED,"'",
                         " '",tm.d_sw CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr020',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr020_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr020()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr020_w
END FUNCTION
 
FUNCTION axcr020()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680122CHAR(1200)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1) #TQC-840066
          u_sign    LIKE type_file.num5,           #No.FUN-680122 SMALLINT
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
          l_ima53   LIKE ima_file.ima53,
          l_ima91   LIKE ima_file.ima91,
          l_ima531  LIKE ima_file.ima531,
          l_dmy1    LIKE smy_file.smydmy1,
       ## sr               RECORD ima01 LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)             ##NO.FUN-610092
          sr               RECORD 
                                  ima01  LIKE ima_file.ima01,           ##NO.FUN-610092
                                  type   LIKE type_file.chr1,           #No.FUN-680122CHAR(1) #1.工單領用 2.重工領出
                                  ccc07	 LIKE ccc_file.ccc07,           #No.FUN-7C0101
                                  ccc08	 LIKE ccc_file.ccc08,           #No.FUN-7C0101
                                #  qty1   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)      # 領出#FUN-A20044
                                  qty1   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)      # 領出#FUN-A20044
                               #   qty2   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)      # 投入#FUN-A20044
                                  qty2   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)      # 投入#FUN-A20044
                                  amt1   LIKE type_file.num20_6,          #No.FUN-680122DEC(20,6)      # 領出
                                  amt2   LIKE type_file.num20_6           #No.FUN-680122DEC(20,6)       # 投入
                           END RECORD
  # DEFINE l_qty2,l_qty3   LIKE ima_file.ima26           #No.FUN-680122DEC(15,3)   #FUN-670094 add#FUN-A20044
   DEFINE l_qty2,l_qty3   LIKE type_file.num15_3           #No.FUN-680122DEC(15,3)   #FUN-670094 add#FUN-A20044
   DEFINE l_amt2,l_amt3   LIKE type_file.num20_6        #No.FUN-680122DEC(20,6)   #FUN-670094 add
   DEFINE l_ima02         LIKE ima_file.ima02
   DEFINE l_ima021        LIKE ima_file.ima021
   DEFINE l_ima25         LIKE ima_file.ima25
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-750098
#    CALL cl_outnam('axcr020') RETURNING l_name       #No.FUN-750098
#    START REPORT axcr020_rep TO l_name               #No.FUN-750098
     CALL cl_del_data(l_table)     #No.FUN-750098
     LET g_pageno = 0
     IF tm.n = '1' OR tm.n = '3'  THEN
     # LET l_sql = "SELECT ima01,'1',ccc31*-1,sum(cch21),",               #No.TQC-A50166
       LET l_sql = "SELECT ima01,'1',ccc07,ccc08,ccc31*-1,sum(cch21),",   #No.TQC-A50166
                   "                 ccc32*-1,sum(cch22) ",
     #             "  FROM ima_file, ccc_file LEFT OUTER JOIN cch_file ON ccc01=cch04 AND ccc02=cch02 AND ccc03=cch03 AND cch05 = 'R' ",  #No.TQC-A50166
                   "  FROM ima_file, ccc_file LEFT OUTER JOIN cch_file ON ccc01=cch04 AND ccc02=cch02 AND ccc03=cch03 ",                  #No.TQC-A50166
                    "                                                 AND ccc07=cch06 AND ccc08=cch07",                                   #No.TQC-A50166
                   " WHERE ",tm.wc CLIPPED,
                   "   AND ima01=ccc01 AND ccc02=",tm.yy," AND ccc03=",tm.mm,
     #             "   AND ccc01=cch_file.cch04  ",                           #No.TQC-A50166
     #             "   AND ccc02=cch_file.cch02 AND ccc03=cch_file.cch03",    #No.TQC-A50166
                   "   AND ccc07='",tm.type,"'",                              #No.TQC-A50166
                   "   AND cch05 IN ('P','M','S') ",
                   " GROUP BY ima01,ccc07,ccc08,ccc31*-1,ccc32*-1,ccc32*-1 "  #MOD-A90104
                  #" GROUP BY ima01,'1',ccc07,ccc08,ccc31*-1,ccc32*-1 "       #No.TQC-A50166 #MOD-A90104 mark
     #             " GROUP BY 1,2,3,5"                                        #No.TQC-A50166
       PREPARE axcr020_prepare1 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM 
       END IF
       DECLARE axcr020_curs1 CURSOR FOR axcr020_prepare1
       FOREACH axcr020_curs1 INTO sr.*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
         IF sr.qty1 IS NULL THEN LET sr.qty1=0 END IF
         IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
         IF sr.qty2 IS NULL THEN LET sr.qty2=0 END IF
         IF sr.amt2 IS NULL THEN LET sr.amt2=0 END IF
        #start FUN-680007 modify
        #start FUN-670094 add
#No.MOD-860318 --begin
#        SELECT sum(cch21),sum(cch22),sum(cch31*-1),sum(cch32*-1)
#          INTO l_qty2 ,l_amt2,l_qty3,l_amt3
#          FROM cch_file
#         WHERE cch04 = sr.ima01 AND cch02 = tm.yy AND cch03 = tm.mm
#           AND cch05 IN ('P','M','S')  
#        IF l_amt2 IS NULL THEN LET l_amt2 =0 END IF
#        IF l_qty2 IS NULL THEN LET l_qty2 =0 END IF
#        IF l_amt3 IS NULL THEN LET l_amt3 =0 END IF
#        IF l_qty3 IS NULL THEN LET l_qty3 =0 END IF
#        LET sr.qty1= sr.qty1 + l_qty3
#        LET sr.amt1= sr.amt1 + l_amt3
#        LET sr.amt2= sr.amt2 + l_amt2
#        LET sr.qty2= sr.qty2 + l_qty2
#No.MOD-860318 --end
        #end FUN-670094 add
        #end FUN-680007 modify
         IF sr.qty1=0 AND sr.qty2=0 AND sr.amt1=0 AND sr.amt2=0 THEN
            CONTINUE FOREACH 
         END IF
#No.MOD-860318 --begin
         CALL cl_digcut(sr.amt1,g_ccz.ccz26) RETURNING sr.amt1 #CHI-C30012 g_azi03->g_ccz.ccz26
         CALL cl_digcut(sr.amt2,g_ccz.ccz26) RETURNING sr.amt2 #CHI-C30012 g_azi03->g_ccz.ccz26
#No.MOD-860318 --end
         #No.+028 010328 by linda add
         IF tm.d_sw='Y' AND (sr.qty1=sr.qty2 AND sr.amt1=sr.amt2) THEN
            CONTINUE FOREACH
         END IF
         #No.+028 end---
#No.FUN-750098 -- begin --
#        OUTPUT TO REPORT axcr020_rep(sr.*)
         SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file 
          WHERE ima01=sr.ima01
         IF SQLCA.sqlcode THEN
            LET l_ima02  = NULL
            LET l_ima021 = NULL
            LET l_ima25  = NULL  
         END IF
         EXECUTE insert_prep USING 
                 sr.ima01,l_ima02,l_ima021,l_ima25,
#                sr.type,sr.qty1,sr.qty2,sr.amt1,sr.amt2          #No.FUN-7C0101
                 sr.type,sr.ccc08,sr.qty1,sr.qty2,sr.amt1,sr.amt2 #No.FUN-7C0101
#No.FUN-750098 -- end --
       END FOREACH
       CLOSE axcr020_curs1 
     END IF
 
     IF tm.n = '2' OR tm.n = '3'  THEN
       LET l_sql = "SELECT ima01,'2',ccc07,ccc08,ccc25*-1,sum(cch21),",        #MOD-AB0030 add ccc07,ccc08
                   "                 ccc26*-1,sum(cch22) ",
                   "  FROM ima_file, ccc_file LEFT OUTER JOIN cch_file ON ccc01=cch04 AND ccc02=cch02 AND ccc03=cch03 AND cch05 = 'R' ",
                   " WHERE ",tm.wc CLIPPED,
                   "   AND ima01=ccc01 AND ccc02=",tm.yy," AND ccc03=",tm.mm,
                   " GROUP BY ima01,ccc07,ccc08,ccc25*-1,ccc26*-1 "            #MOD-AB0030 add ccc07,ccc08
       PREPARE axcr020_prepare2 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM 
       END IF
       DECLARE axcr020_curs2 CURSOR FOR axcr020_prepare2
       FOREACH axcr020_curs2 INTO sr.*
         IF STATUS THEN CALL cl_err('foreach2:',STATUS,1) EXIT FOREACH END IF
         IF sr.qty1 IS NULL THEN LET sr.qty1=0 END IF
         IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
         IF sr.qty2 IS NULL THEN LET sr.qty2=0 END IF
         IF sr.amt2 IS NULL THEN LET sr.amt2=0 END IF
        #start FUN-670094 add
#No.MOD-860318 --begin
#        SELECT sum(ccu21),sum(ccu22),sum(ccu31*-1),sum(ccu32*-1)
#          INTO l_qty2 ,l_amt2,l_qty3,l_amt3
#          FROM ccu_file
#         WHERE ccu04 = sr.ima01 AND ccu02 = tm.yy AND ccu03 = tm.mm
#           AND ccu05= 'R'
#        IF l_amt2 IS NULL THEN LET l_amt2 =0 END IF
#        IF l_qty2 IS NULL THEN LET l_qty2 =0 END IF
#        IF l_amt3 IS NULL THEN LET l_amt3 =0 END IF
#        IF l_qty3 IS NULL THEN LET l_qty3 =0 END IF
#        LET sr.qty1= sr.qty1 + l_qty3
#        LET sr.amt1= sr.amt1 + l_amt3
#        LET sr.amt2= sr.amt2 + l_amt2
#        LET sr.qty2= sr.qty2 + l_qty2
#No.MOD-860318 --end
        #end FUN-670094 add
         IF sr.qty1=0 AND sr.qty2=0 AND sr.amt1=0 AND sr.amt2=0 THEN
            CONTINUE FOREACH 
         END IF
#No.MOD-860318 --begin
         CALL cl_digcut(sr.amt1,g_ccz.ccz26) RETURNING sr.amt1 #CHI-C30012 g_azi03->g_ccz.ccz26                                                                        
         CALL cl_digcut(sr.amt2,g_ccz.ccz26) RETURNING sr.amt2 #CHI-C30012 g_azi03->g_ccz.ccz26
#No.MOD-860318 --end
         #No.+028 010328 by linda add
         IF tm.d_sw='Y' AND (sr.qty1=sr.qty2 AND sr.amt1=sr.amt2) THEN
            CONTINUE FOREACH
         END IF
         #No.+028 end---
#No.FUN-750098 -- begin --
#        OUTPUT TO REPORT axcr020_rep(sr.*)
         SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file                                                      
          WHERE ima01=sr.ima01                                                                                                      
         IF SQLCA.sqlcode THEN                                                                                                      
            LET l_ima02  = NULL                                                                                                     
            LET l_ima021 = NULL                                                                                                     
            LET l_ima25  = NULL                                                                                                     
         END IF                                                                                                                     
         EXECUTE insert_prep USING                                                                                                  
                 sr.ima01,l_ima02,l_ima021,l_ima25,                                                                              
                 sr.type,sr.ccc08,sr.qty1,sr.qty2,sr.amt1,sr.amt2   #No.TQC-A50166
#No.FUN-750098 -- end --
       END FOREACH
     END IF
#No.FUN-750098 -- begin --
#   FINISH REPORT axcr020_rep
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #是否列印選擇條件                                                            
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'ima01, ima06, ima10, ima12, ima08, ima09, ima11')                               
            RETURNING tm.wc                                                     
       LET g_str = tm.wc                                                        
    END IF
#   LET g_str = tm.yy,';',tm.mm,';',g_ccz.ccz27,';',g_azi03,';',g_str
    #LET g_str = tm.yy,';',tm.mm,';',g_ccz.ccz27,';',g_azi04,';',g_str      #No.MOD-860318 #CHI-C30012
    LET g_str = tm.yy,';',tm.mm,';',g_ccz.ccz27,';',g_ccz.ccz26,';',g_str   #CHI-C30012
                ,';',tm.type
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF tm.type MATCHES '[12]' THEN        #No.FUN-7C0101
       CALL cl_prt_cs3('axcr020','axcr020',l_sql,g_str)
    END IF                                #No.FUN-7C0101
    IF tm.type MATCHES '[345]' THEN        #No.FUN-7C0101
       CALL cl_prt_cs3('axcr020','axcr020_1',l_sql,g_str) #No.FUN-7C0101
    END IF                                #No.FUN-7C0101
#No.FUN-750098 -- end --
END FUNCTION
 
#No.8741
#No.FUN-750098 -- begin --
{
REPORT axcr020_rep(sr)
  # DEFINE qty      LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3)#FUN-A20044
   DEFINE qty      LIKE type_file.num15_3,           #No.FUN-680122 DEC(15,3)#FUN-A20044
          u_p      LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)
          amt      LIKE type_file.num20_6         #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
          l_ima02      LIKE ima_file.ima02,   #FUN-4C0099
          l_ima021     LIKE ima_file.ima021,   #FUN-4C0099
          l_ima25      LIKE ima_file.ima25,    #NO.FUN-610092
       ## sr               RECORD ima01 LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          sr               RECORD ima01 LIKE ima_file.ima01,   ##NO.FUN-610092
                                  type  LIKE type_file.chr1,           #No.FUN-680122CHAR(1)      #1.工單領用 2.重工領出
                              #    qty1  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)      # 領出#FUN-A20044
                                  qty1  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)      # 領出#FUN-A20044
                               #   qty2  LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)      # 投入#FUN-A20044
                                qty2  LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)      # 投入#FUN-A20044
                                  amt1  LIKE type_file.num20_6,          #No.FUN-680122DEC(20,6)      # 領出
                                  amt2  LIKE type_file.num20_6           #No.FUN-680122DEC(20,6)      # 投入
                        END RECORD,
      t_ima01	   LIKE ima_file.ima01,         #No.FUN-680122CHAR(20)
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ima01,sr.type
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0078
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.yy USING '&&&&',g_x[10] CLIPPED,tm.mm USING '&&'
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
    ##PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],         ##NO.FUN-610092
      PRINT g_x[31],g_x[32],g_x[33],g_x[40],g_x[34],g_x[35], ##NO.FUN-610092
            g_x[36],g_x[37],g_x[38],g_x[39]
      PRINT g_dash1 
      LET l_last_sw = 'n'
   BEFORE GROUP OF sr.ima01
   #  LET t_ima01=sr.ima01
   #No.+028 010328 by linda mod
#FUN-4C0099
    ##SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file               ##NO.FUN-610092
      SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file ##NO.FUN-610092
         WHERE ima01=sr.ima01
      IF SQLCA.sqlcode THEN
         LET l_ima02  = NULL
         LET l_ima021 = NULL
         LET l_ima25  = NULL  ##NO.FUN-610092
      END IF
 
      PRINT COLUMN g_c[31],sr.ima01 CLIPPED,
            COLUMN g_c[32],l_ima02 CLIPPED,
            COLUMN g_c[33],l_ima021 CLIPPED,
            COLUMN g_c[40],l_ima25 CLIPPED;   ##NO.FUN-610092
 
   ON EVERY ROW
    #No.+028 010328 by linda mark 
    # IF tm.d_sw='Y' AND (sr.qty1=sr.qty2 AND sr.amt1=sr.amt2) THEN
    #   ELSE
    #    PRINT t_ima01 CLIPPED, COLUMN 14,sr.type,
         PRINT COLUMN g_c[34],sr.type,
               COLUMN g_c[35],cl_numfor(sr.qty1,35,g_ccz.ccz27),      #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
               COLUMN g_c[36],cl_numfor(sr.qty2,36,g_ccz.ccz27),     #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
               COLUMN g_c[37],cl_numfor(sr.amt1,37,g_azi03),     #FUN-570190
               COLUMN g_c[38],cl_numfor(sr.amt2,38,g_azi03),     #FUN-570190
               COLUMN g_c[39],cl_numfor(sr.amt1-sr.amt2,39,g_azi03)     #FUN-570190
     #   LET t_ima01=NULL
     #END IF
 
   ON LAST ROW
      PRINT
      PRINT COLUMN g_c[34],g_x[11] CLIPPED,
            COLUMN g_c[35],cl_numfor(SUM(sr.qty1),35,g_ccz.ccz27),     #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[36],cl_numfor(SUM(sr.qty2),36,g_ccz.ccz27),     #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[37],cl_numfor(SUM(sr.amt1),37,g_azi03),     #FUN-570190
            COLUMN g_c[38],cl_numfor(SUM(sr.amt2),38,g_azi03),     #FUN-570190
            COLUMN g_c[39],cl_numfor(SUM(sr.amt1-sr.amt2),39,g_azi03)     #FUN-570190
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED    #No.TQC-6A0078
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]   #No.TQC-6A0078
              PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED    #No.TQC-6A0078
         ELSE SKIP 2 LINE
      END IF
#No.8741
END REPORT
}
#No.FUN-750098 -- end -- 

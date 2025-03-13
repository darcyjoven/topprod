# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: axcr005.4gl
# Descriptions...: 部門出庫成本統計表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/10 By Nick
# Modify.........: No:8741 04/06/07 By Melody 修改列印部份
# Modify.........: No.FUN-4C0099 04/12/24 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為dec(20,6)
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-650056 06/05/08 By Sarah tlf19有可能是廠商/客戶/部門,所以後面l_gem02需對這三個主檔做抓取,不然除了部門之外的名稱都會秀不出來
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-720042 07/02/06 By TSD.Sora 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.MOD-7B0160 07/11/20 By Carol add委外代買的處理
# Modify.........: No.TQC-820007 08/02/14 By Carol SQL tlf02,tlf03 add 條件 '80'->for 借料還料
# Modify.........: No.MOD-930233 09/05/26 By Pengu 數量未考慮單位轉換率
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.TQC-A40130 10/04/27 By Carrier 追单 FUN-9A0067
# Modify.........: No:FUN-B90029 11/11/01 By jason 單價要加製費
# Modify.........: No:MOD-C30027 12/03/03 By ck2yuan 若是看工單領用 遇到重工工單 單價應該是ccc26/ccc5 非用月平均單價
# Modify.........: No:MOD-C30729 12/03/15 By ck2yuan 若未AFTER FIELD mm 不會是畫面上年度期別,改在AFTER INPUT才CALL s_azm
# Modify.........: No:MOD-C40197 12/05/03 By ck2yuan 1.修改MOD-C30027錯誤  2.針對數量與金額取為 3.當tlf13=aimt309時，單位成本抓imp09
#                                                    4. axcr005_curs1在判斷u_sign為1或-1的部分 條件判斷修改
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-C80074 12/08/10 By ck2yuan 當出庫類別為銷貨出庫 抓取順序不同
# Modify.........: No:MOD-D20092 13/02/19 By bart 修改sql條件
# Modify.........: N0:MOD-D20142 13/02/23 By Alberti 修改選擇出庫類別是“工單領用“
# Modify.........: N0:MOD-D20146 13/02/26 By bart 加distinct
# Modify.........: No:MOD-D20119 13/02/26 By bart 計算銷售成本時 (出貨)，如果oga65='Y'就不計算
# Modify.........: No:MOD-D20093 13/02/26 By bart 當是雜項領用時，應依ccz08判斷是否應在axct500重取單價
# Modify.........: No:MOD-D30239 13/03/28 By ck2yuan 單別改抓tlf026資料 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000,   #No.FUN-680122 VARCHAR(600),  # Where condition
           yy,mm   LIKE type_file.num5,      #No.FUN-680122SMALLINT,
           o       LIKE type_file.chr1,      #No.FUN-680122CHAR(1),     # (1)工單領用 (2)雜項領用 (3)其他調整 (4)銷售出庫
           a       LIKE type_file.chr1,      #No.FUN-680122CHAR(1),
           b       LIKE type_file.chr1,      #No.FUN-680122CHAR(1),
           c       LIKE type_file.chr1,      #No.FUN-680122CHAR(1),
           stock   LIKE type_file.chr1,      #No:FUN-B90029
           more    LIKE type_file.chr1       #No.FUN-680122CHAR(1)      # Input more condition(Y/N)
           END RECORD,
       g_tot_bal LIKE type_file.num20_6      #No.FUN-680122DECIMAL(20,6)   # User defined variable
DEFINE bdate       LIKE type_file.dat            #No.FUN-680122DATE 
DEFINE edate       LIKE type_file.dat            #No.FUN-680122DATE 
DEFINE g_argv1     LIKE type_file.chr20          #No.FUN-680122 VARCHAR(20)  
DEFINE g_argv2     LIKE type_file.num5           #No.FUN-680122SMALLINT
DEFINE g_argv3     LIKE type_file.num5           #No.FUN-680122SMALLINT
DEFINE g_chr       LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#No.MOd-720042 BY TSD.Sora---start---
DEFINE l_table     STRING  
DEFINE g_sql       STRING 
DEFINE g_str       STRING
#No.MOD-720042 BY TSD.Sora---end---
 
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
  
   #No.MOD-720042 BY TSD.Sora---start---
   LET g_sql = "tlf19.tlf_file.tlf19,",           
               "gem02.gem_file.gem02,",
               "tlf14.tlf_file.tlf14,",           
               "tlf01.tlf_file.tlf01,",           
               "ima02.ima_file.ima02,",           
               "ima021.ima_file.ima021,",          
               "ima25.ima_file.ima25,",           
             #  "qty.ima_file.ima26,",#FUN-A20044           
               "qty.type_file.num15_3,",#FUN-A20044           
               "up.oeb_file.oeb13,",           
               "amt.type_file.num20_6"
 
   LET l_table = cl_prt_temptable('axcr005',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.MOD-720042 BY TSD.Sora---end---
 
   #TQC-610051-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #LET tm.o    = '1'
   #LET tm.a    = 'Y'
   #LET tm.b    = 'Y'
   #LET tm.c    = 'Y'
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET g_argv1 = ARG_VAL(1)        # Get arguments from command line
   #LET g_argv2 = ARG_VAL(2)        # Get arguments from command line
   #LET g_argv3 = ARG_VAL(3)        # Get arguments from command line
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)    
   LET tm.yy = ARG_VAL(8)       
   LET tm.mm = ARG_VAL(9)        
   LET tm.o = ARG_VAL(10)        
   LET tm.a = ARG_VAL(11)        
   LET tm.b = ARG_VAL(12)        
   LET tm.c = ARG_VAL(13)        
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET tm.stock = ARG_VAL(17)   #FUN-B90029
   #TQC-610051-end
   #IF cl_null(g_argv1)
   #   THEN CALL axcr005_tm(0,0)        # Input print condition
   #   ELSE LET tm.wc=" ima01='",g_argv1,"'"
   #        LET tm.yy=g_argv2
   #        LET tm.mm=g_argv3
   #       LET tm.o =ARG_VAL(4)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(5)
   #LET g_rep_clas = ARG_VAL(6)
   #LET g_template = ARG_VAL(7)
   LET g_rpt_name = ARG_VAL(8)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #        CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
   #        CALL axcr005()            # Read data and create out-file
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL axcr005_tm(0,0)          # Input print condition
   ELSE
      CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      CALL axcr005()                # Read data and create out-file
   END IF
   #TQC-610051-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr005_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 15
   END IF
   OPEN WINDOW axcr005_w AT p_row,p_col
        WITH FORM "axc/42f/axcr005" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
 
   #TQC-610051-begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.o    = '1'
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.stock = '1'   #FUN-B90029
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #TQC-610051-end
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tlf19,tlf14,ima01,ima39
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
   LET tm.yy=g_ccz.ccz01 #No.TQC-A40130
   LET tm.mm=g_ccz.ccz02 #No.TQC-A40130
   INPUT BY NAME tm.yy,tm.mm,tm.o,tm.a,tm.b,tm.c,tm.stock,tm.more WITHOUT DEFAULTS   #FUN-B90029 add tm.stock 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      AFTER FIELD o
         IF cl_null(tm.o) OR tm.o NOT MATCHES '[1-4]' THEN
            NEXT FIELD o
         END IF
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF
      #FUN-B90029 --START--
      AFTER FIELD stock
         IF cl_null(tm.stock) OR tm.stock NOT MATCHES '[1-3]' THEN
            NEXT FIELD stock
         END IF
      #FUN-B90029 --END--
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr005_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr005'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr005','9031',1)   
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
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",            #No.FUN-7C0078
                         " '",tm.stock CLIPPED,"'"              #No:FUN-B90029
         CALL cl_cmdat('axcr005',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr005_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr005()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr005_w
END FUNCTION
 
FUNCTION axcr005()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20),      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680122CHAR(1200),
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          xxx       LIKE aab_file.aab02,         #No.FUN-680122 VARCHAR(5),         # No.FUN-550025
          u_sign    LIKE type_file.num5,           #No.FUN-680122SMALLINT,
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10),
          l_ima53   LIKE ima_file.ima53,  
          l_ima91   LIKE ima_file.ima91,  
          l_ima531  LIKE ima_file.ima531,  
          l_dmy1    LIKE smy_file.smydmy1,
          sr        RECORD tlf19  LIKE tlf_file.tlf19,           #No.FUN-680122CHAR(06),
                           tlf14  LIKE tlf_file.tlf14,           #No.FUN-680122CHAR(04),
                           tlf01  LIKE tlf_file.tlf01,           #No.FUN-680122CHAR(20),
                           ima02  LIKE ima_file.ima02,           #No.FUN-680122CHAR(30),
                           ima021 LIKE ima_file.ima021,          #No.FUN-680122CHAR(30),  #FUN-5A0059
                           ima25  LIKE ima_file.ima25,           #No.FUN-680122CHAR(4),
                           tlf06  LIKE tlf_file.tlf06,           #No.FUN-680122 DATE,     #MOD-480342
                           tlf02  LIKE tlf_file.tlf02,           #No.FUN-680122SMALLINT,
                           tlf03  LIKE tlf_file.tlf03,           #No.FUN-680122SMALLINT,
                           tlf026 LIKE tlf_file.tlf026,          #No.FUN-680122 VARCHAR(16), #No.FUN-550025
                           tlf027 LIKE tlf_file.tlf027,          #No.FUN-680122SMALLINT,
                           tlf036 LIKE tlf_file.tlf036,          #No.FUN-680122CHAR(16),  #No.FUN-550025
                           tlf037 LIKE tlf_file.tlf037,          #No.FUN-680122SMALLINT,
                           tlf11  LIKE tlf_file.tlf11,           #No.FUN-680122 VARCHAR(4),
                         #  qty    LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3), #No.FUN-A20044
                           qty    LIKE type_file.num15_3,        #No.FUN-A20044
                           up     LIKE oeb_file.oeb13,           #No.FUN-680122DECIMAL(20,6)  #MOD-480342
                           amt    LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
                           gem02  LIKE gem_file.gem02,
                           tlf13  LIKE tlf_file.tlf13            #No:FUN-B90029
                    END RECORD
   DEFINE l_where STRING                                         #No:FUN-B90029
   DEFINE l_sfb99 LIKE sfb_file.sfb99                            #MOD-C30027 add
   DEFINE l_ccc26 LIKE ccc_file.ccc26                            #MOD-C30027 add
   DEFINE l_ccc25 LIKE ccc_file.ccc25                            #MOD-C30027 add
   DEFINE l_cch05 LIKE cch_file.cch05                            #MOD-C40197 add
   DEFINE l_oga65 LIKE oga_file.oga65     #MOD-D20119
   
   #No.MOD-720042 BY TSD.Sora---start---
   CALL cl_del_data(l_table) 
   #No.MOD-720042 BY TSD.Sora---end---
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr005'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
 
  #LET l_sql = "SELECT tlf19,tlf14,tlf01,ima02,ima25,tlf06,tlf02,tlf03,",          #FUN-5A0059 mark
   LET l_sql = "SELECT tlf19,tlf14,tlf01,ima02,ima021,ima25,tlf06,tlf02,tlf03,",   #FUN-5A0059
              #-----------No.MOD-930233 modify
              #"       tlf026,tlf027,tlf036,tlf037,tlf11,tlf10,0,0,''",
               "       tlf026,tlf027,tlf036,tlf037,tlf11,(tlf10*tlf60),0,0,''",
               "       ,tlf13 ",   #FUN-B90029
              #-----------No.MOD-930233 end
               "  FROM tlf_file, ima_file",
               " WHERE ",tm.wc,
               "   AND ((tlf02=50 OR tlf02=57 OR tlf02=80 ) OR (tlf03=50 OR tlf03=57 OR tlf03=80 )) ",  #TQC-820007-modify add 80
               "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"'",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
               "   AND tlf01=ima01"
   #FUN-B90029(S)
   CASE tm.stock
      WHEN "2"
         LET l_where = " "
      WHEN "3"
         LET l_where = "   AND (tlf13='asft700')"
      OTHERWISE
         LET l_where = "   AND tlf13<>'asft700'"
   END CASE
   LET l_sql = l_sql CLIPPED, l_where CLIPPED
   #FUN-B90029(E)               
   PREPARE axcr005_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr005_curs1 CURSOR FOR axcr005_prepare1
 
   LET g_pageno = 0
   FOREACH axcr005_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #IF tm.a='N' THEN LET sr.tlf19=' ' END IF
     #IF tm.b='N' THEN LET sr.tlf14=' ' END IF
      LET u_sign=0  
     #IF sr.tlf02 = 50 OR sr.tlf02 = 57 OR sr.tlf02 = 80     #TQC-820007-moidfy-->add 80  #MOD-C40197 mark
      IF sr.tlf03 = 50 OR sr.tlf02 = 57 OR sr.tlf02 = 80     #MOD-C40197 add
         THEN LET u_sign=1 LET sr.tlf036=sr.tlf026 LET sr.tlf037=sr.tlf027
         #FUN-B90029(S)
         IF sr.tlf13='asft700' THEN
            LET u_sign=-1
         END IF
         #FUN-B90029(E)
         SELECT oga65 INTO l_oga65 FROM oga_file WHERE oga01=sr.tlf036  #MOD-D20119
      END IF
     #IF sr.tlf03 = 50 OR sr.tlf03 = 57 OR sr.tlf03 = 80     #TQC-820007-moidfy-->add 80  #MOD-C40197 mark
      IF sr.tlf02 = 50 OR sr.tlf03 = 57 OR sr.tlf03 = 80     #MOD-C40197 add
         THEN LET u_sign=-1  
         SELECT oga65 INTO l_oga65 FROM oga_file WHERE oga01=sr.tlf026  #MOD-D20119
      END IF
      IF u_sign=0 THEN CONTINUE FOREACH END IF
      LET sr.qty = sr.qty * u_sign
    #MOD-D30239 str  -------
    ##No.FUN-550025 --start--
    ##LET xxx=sr.tlf036[1,3] 
    # IF tm.o = 1 THEN                                  #MOD-D20142 
    #    CALL s_get_doc_no(sr.tlf026) RETURNING xxx     #MOD-D20142
    # ELSE                                              #MOD-D20142
    #    CALL s_get_doc_no(sr.tlf036) RETURNING xxx
    # END IF                                            #MOD-D20142   
    ##No.FUN-550025 --end-- 

      CALL s_get_doc_no(sr.tlf026) RETURNING xxx
    #MOD-D30239 end --------- 
      LET g_chr = ''
   
      #No.MOD-720042 BY TSD.Sora---start---
      #MOD-C80074 當是銷貨出庫,抓的順序應為 客戶主檔->廠商主檔->部門主檔.  其餘是廠商主檔->客戶主檔->部門主檔.
      IF tm.o ='4' THEN                                                 #MOD-C80074 add
         SELECT occ02 INTO sr.gem02 FROM occ_file WHERE occ01=sr.tlf19  #MOD-C80074 add
      ELSE                                                              #MOD-C80074 add
         SELECT pmc03 INTO sr.gem02 FROM pmc_file WHERE pmc01=sr.tlf19
      END IF                                                            #MOD-C80074 add
      IF SQLCA.sqlcode THEN
         #廠商主檔裡找不到,換找客戶主檔
         IF tm.o ='4' THEN                                                 #MOD-C80074 add
            SELECT pmc03 INTO sr.gem02 FROM pmc_file WHERE pmc01=sr.tlf19  #MOD-C80074 add
         ELSE                                                              #MOD-C80074 add
            SELECT occ02 INTO sr.gem02 FROM occ_file WHERE occ01=sr.tlf19
         END IF                                                            #MOD-C80074 add
         IF SQLCA.sqlcode THEN
         #end FUN-650056 add
            #客戶主檔裡找不到,換找部門主檔
            SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.tlf19
            IF SQLCA.sqlcode THEN
               LET sr.gem02 = NULL
            END IF
         #start FUN-650056 add
         END IF
      END IF
      #No.MOD-720042 BY TSD.Sora---end---
 
      IF sr.tlf13<>'asft700' THEN  #FUN-B90029
      SELECT smydmy2,smydmy1 INTO g_chr,l_dmy1
        FROM smy_file WHERE smyslip=xxx
      IF g_chr = '1' OR g_chr IS NULL THEN CONTINUE FOREACH END IF
      END IF   #FUN-B90029       
###951108 Add by Jackson 成本
      IF l_dmy1 != 'Y' THEN CONTINUE FOREACH END IF
      IF tm.o='1' THEN 		#(1)工單領用
         IF g_chr != '3' THEN CONTINUE FOREACH END IF
         IF (sr.tlf02 >= 60 AND sr.tlf02 <= 69) OR
            ((sr.tlf03 >= 60 AND sr.tlf03 <= 69) OR sr.tlf03 = 18 ) THEN   #MOD-7B0160-modify add sr.tlf03=18
            LET g_chr=''
         ELSE 
            CONTINUE FOREACH
         END IF
      END IF
      IF tm.o='2' THEN 		#(2)雜項領用
         IF g_chr != '3' THEN CONTINUE FOREACH END IF
         IF (sr.tlf02 >= 60 AND sr.tlf02 <= 69) OR
            ((sr.tlf03 >= 60 AND sr.tlf03 <= 69) OR sr.tlf03 = 18 ) THEN  #MOD-7B0160-modify add sr.tlf03=18
            CONTINUE FOREACH
         ELSE 
            LET g_chr=''
         END IF
      END IF
      IF tm.o='3' THEN 		#(3)其他調整
         IF g_chr != '5' THEN CONTINUE FOREACH END IF
      END IF
      IF tm.o='4' THEN 		#(4)銷售出庫
         IF g_chr != '2' THEN CONTINUE FOREACH END IF
         IF l_oga65 ='Y' THEN CONTINUE FOREACH END IF    #MOD-D20119
      END IF
     #MOD-C30027 str add-----
     #SELECT ccc23 INTO sr.up FROM ccc_file
     #       WHERE ccc01=sr.tlf01 AND ccc02=tm.yy AND ccc03=tm.mm

      SELECT sfb99 INTO l_sfb99 FROM sfb_file
       #WHERE sfb01 = (SELECT sfe01 FROM sfe_file WHERE sfe02=sr.tlf026 AND sfe07=sr.tlf01)  #MOD-D20146
       WHERE sfb01 = (SELECT DISTINCT(sfe01) FROM sfe_file WHERE sfe02=sr.tlf026 AND sfe07=sr.tlf01)  #MOD-D20146
     #MOD-C40197 str add-----
      SELECT cch05 INTO l_cch05 FROM cch_file
       WHERE cch04=sr.tlf01 AND cch02=tm.yy AND cch03=tm.mm
         #AND cch01=sr.tlf026 AND cch06=g_ccz.ccz28  #MOD-D20092
         AND cch01=sr.tlf036 AND cch06=g_ccz.ccz28  #MOD-D20092
     #MOD-C40197 end add-----
     #IF sr.tlf13[1,5] = 'asfi5' AND l_sfb99 = 'Y' THEN                   #MOD-C40197 mark
      IF sr.tlf13[1,5] = 'asfi5' AND l_sfb99 = 'Y' AND l_cch05='R' THEN   #MOD-C40197 add
        SELECT ccc25,ccc26 INTO l_ccc25,l_ccc26 FROM ccc_file
         WHERE ccc01 = sr.tlf01 AND ccc02 = tm.yy  AND ccc03 = tm.mm
        LET sr.up= l_ccc26/l_ccc25
      ELSE
         SELECT ccc23 INTO sr.up FROM ccc_file
          WHERE ccc01=sr.tlf01 AND ccc02=tm.yy AND ccc03=tm.mm
      END IF
     #MOD-C30027 end add-----
     #MOD-C40197 str add-----
     #同業間借入(aimt306)，來源狀況(tlf02)=80，
     #於上面判斷CONTINUE FOREACH掉了,故借入時無計算成本
     #借料償還時，抓取原於aimt306的預計單位成本
      IF  sr.tlf13 = 'aimt309' THEN
         SELECT imp09 INTO sr.up FROM imp_file,imq_file
          WHERE imq01 = l_tlf905
           AND  imq02 = l_tlf906
           AND  imq03 = imp01
           AND  imq04 = imp02
      END IF
     #MOD-C40197 end add-----
      #MOD-D20093---begin
      IF tm.o='2' AND g_ccz.ccz08 = '2' THEN
         LET sr.up = 0
         SELECT inb13+inb132+inb133+inb134+inb135+inb136+inb137+inb138
           INTO sr.up FROM inb_file WHERE inb01= sr.tlf036 AND inb04=sr.tlf01
      END IF
      #MOD-D20093---end
      IF sr.up IS NULL THEN LET sr.up=0 END IF
      LET sr.amt = sr.qty * sr.up
   
      LET sr.amt = cl_digcut(sr.amt,g_ccz.ccz26)    #MOD-C40197 add

     #No.MOD-720042 BY TSD.Sora---start---
      EXECUTE insert_prep USING
            sr.tlf19 ,sr.gem02,sr.tlf14,sr.tlf01,sr.ima02,
            sr.ima021,sr.ima25,sr.qty  ,sr.up   ,sr.amt
     #No.MOD-720042 BY TSD.Sora---end---
   END FOREACH
 
   #No.MOD-720042 BY TSD.Sora---start---
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'tlf19,tlf14,ima01,ima39')
      RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.yy,";",tm.mm,";",tm.o,";",tm.a,";",tm.b,";",tm.c
                   #,";",g_azi03   #FUN-710080 add   #MOD-C40197 mark
                    #,";",g_azi03,";",g_ccz.ccz27     #MOD-C40197 add #CHI-C30012 mark
                    ,";",g_ccz.ccz26,";",g_ccz.ccz27 #CHI-C30012
   CALL cl_prt_cs3('axcr005','axcr005',l_sql,g_str)   #FUN-710080 modify
   #No.MOD-720042 BY TSD.Sora---end---
 
END FUNCTION
 
#No.8741
{ 
REPORT axcr005_rep(sr)
  # DEFINE qty          LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3), 
   DEFINE qty          LIKE type_file.num15_3,           #No.FUN-A20044, 
          u_p          LIKE oeb_file.oeb13,         #No.FUN-680122DECIMAL(20,6) 
          amt          LIKE type_file.num20_6         #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680122CHAR(1),
          l_gem02      LIKE gem_file.gem02,  #FUN-4C0099
          sr           RECORD tlf19  LIKE tlf_file.tlf19,          #No.FUN-680122CHAR(06),
                              tlf14  LIKE tlf_file.tlf14,          #No.FUN-680122 VARCHAR(04),
                              tlf01  LIKE tlf_file.tlf01,          #No.FUN-680122CHAR(20),
                              ima02  LIKE ima_file.ima02,          #No.FUN-680122CHAR(30), 
                              ima021 LIKE ima_file.ima021,         #No.FUN-680122CHAR(30),   #FUN-5A0059
                              ima25  LIKE ima_file.ima25,          #No.FUN-680122CHAR(4),
                              tlf06  LIKE tlf_file.tlf06,          #No.FUN-680122DATE   ,   #MOD-480342
                              tlf02  LIKE tlf_file.tlf02,          #No.FUN-680122SMALLINT,
                              tlf03  LIKE tlf_file.tlf03,          #No.FUN-680122SMALLINT,
                              tlf026 LIKE tlf_file.tlf026,         #No.FUN-680122CHAR(16),  #No.FUN-550025
                              tlf027 LIKE tlf_file.tlf027,         #No.FUN-680122SMALLINT,
                              tlf036 LIKE tlf_file.tlf036,         #No.FUN-680122CHAR(16),  #No.FUN-550025
                              tlf037 LIKE tlf_file.tlf037,         #No.FUN-680122SMALLINT,
                              tlf11  LIKE tlf_file.tlf11,          #No.FUN-680122CHAR(4),
                             # qty    LIKE ima_file.ima26,          #No.FUN-680122DEC(15,3),#No.FUN-A20044
                              qty    LIKE type_file.num15_3,       #No.FUN-A20044
                              up     LIKE oeb_file.oeb13,          #No.FUN-680122DEC(20,6),	#MOD-480342
                              amt    LIKE type_file.num20_6,       #No.FUN-680122 DEC(20,6)
                              gem02  LIKE gem_file.gem02        #No.FUN-680122 DEC(20,6)
                       END RECORD,
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 6 PAGE LENGTH g_page_line
  ORDER BY sr.tlf19,sr.tlf14,sr.tlf01
  FORMAT
   PAGE HEADER
     # CASE WHEN tm.o='1' LET g_x[1]="工單領用成本明細表"
     #      WHEN tm.o='2' LET g_x[1]="雜項領用成本明細表"
     #      WHEN tm.o='3' LET g_x[1]="其他調整成本明細表"
     #      WHEN tm.o='4' LET g_x[1]="銷售出庫成本明細表"
     # END CASE
      CASE WHEN tm.o='1' LET g_x[1]=g_x[14]
           WHEN tm.o='2' LET g_x[1]=g_x[15]
           WHEN tm.o='3' LET g_x[1]=g_x[16]
           WHEN tm.o='4' LET g_x[1]=g_x[17]
      END CASE
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.yy USING '&&&&',
            g_x[10] CLIPPED,tm.mm USING '&&'
 
      PRINT g_dash   #FUN-4C0099
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]   #FUN-4C0099
           ,g_x[40]   #FUN-5A0059
      PRINT g_dash1   #FUN-4C0099
      LET l_last_sw = 'n'
 
#FUN-4C0099
   BEFORE GROUP OF sr.tlf19
     #start FUN-650056 add
      SELECT pmc03 INTO l_gem02 FROM pmc_file WHERE pmc01=sr.tlf19
      IF SQLCA.sqlcode THEN
         #廠商主檔裡找不到,換找客戶主檔
         SELECT occ02 INTO l_gem02 FROM occ_file WHERE occ01=sr.tlf19
         IF SQLCA.sqlcode THEN
     #end FUN-650056 add
            #客戶主檔裡找不到,換找部門主檔
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.tlf19
            IF SQLCA.sqlcode THEN
               LET l_gem02 = NULL
            END IF
     #start FUN-650056 add
         END IF
      END IF
     #end FUN-650056 add
      PRINT COLUMN g_c[31],sr.tlf19,
            COLUMN g_c[32],l_gem02;
   BEFORE GROUP OF sr.tlf14
      PRINT COLUMN g_c[33],sr.tlf14;
   AFTER GROUP OF sr.tlf01
      IF tm.c='Y' THEN
         LET qty=GROUP SUM(sr.qty)
         IF qty = 0 THEN LET qty = NULL END IF
         PRINT COLUMN g_c[34],sr.tlf01,
               COLUMN g_c[35],sr.ima02,
              #start FUN-5A0059
               COLUMN g_c[36],sr.ima021,
               COLUMN g_c[37],sr.ima25,
              #COLUMN 39,GROUP SUM(sr.qty) USING '--,---,---.--',
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty),38,g_azi03),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.amt)/qty,39,g_azi03), #No.8741
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt),40,g_azi03)      ##No.8741    #FUN-570190
              #end FUN-5A0059
      END IF
   AFTER GROUP OF sr.tlf14
      IF tm.b = 'Y' THEN
      PRINT
      PRINT COLUMN g_c[33],sr.tlf14,
           #start FUN-5A0059
            COLUMN g_c[37],g_x[11] CLIPPED,
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty),38,g_azi03),    #FUN-570190
            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt),40,g_azi03)      #No.8741    #FUN-570190
           #end FUN-5A0059
      PRINT
      END IF
   AFTER GROUP OF sr.tlf19
      IF tm.a = 'Y' THEN
      PRINT COLUMN g_c[31],sr.tlf19,
            COLUMN g_c[32],l_gem02,
           #start FUN-5A0059
            COLUMN g_c[37],g_x[12] CLIPPED,
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty),38,g_azi03),    #FUN-570190
            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt),40,g_azi03)      #No.8741    #FUN-570190
           #end FUN-5A0059
      PRINT
      END IF
 
   ON LAST ROW
     #start FUN-5A0059
      PRINT COLUMN g_c[37],g_x[13] CLIPPED,
            COLUMN g_c[38],cl_numfor(SUM(sr.qty),38,g_azi03),    #FUN-570190
            COLUMN g_c[40],cl_numfor(SUM(sr.amt),40,g_azi03)     #FUN-570190          #No.8741
     #end FUN-5A0059
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
#FUN-4C0099
END REPORT
}

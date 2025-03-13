# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr815.4gl
# Descriptions...: Run Card 良率分析表
# Date & Author..: 00/08/18 By Mandy
# Mosify.........: No:7782 03/08/14 Carol:第152行的shm_file
#                                         不知道要做啥用?沒條件式-->拿掉shm_file
#                                         140行後的權限一併修改
# Modify.........: NO.FUN-510040 05/02/16 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0026 05/12/06 By kevin 結束位置調整
# Modify.........: No.FUN-540012 06/06/09 By Sarah 增加"作業編號"、"機器編號"、"工作中心編號"三個選項,增加排序,跳頁,小計功能
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0102 06/11/21 By johnray 報表修改
# Modify.........: No.FUN-720005 07/02/06 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-770003 07/07/03 By zhoufeng 維護幫助按鈕
# Modify.........: No.MOD-940391 09/04/30 By Smapmin 該報表無法呈現在線別/班別的資料,否則會造成資料重複
# Modify.........: No.TQC-940163 09/05/11 By mike sr.sfb06回傳值不唯一     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50156 10/05/28 By Carrier main结构调整
# Modify.........: No.FUN-A60080 10/07/08 By destiny 报表显示增加制程段号字段
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm      RECORD                  # Print condition RECORD
                  wc     LIKE type_file.chr1000,         #No.FUN-680121 VARCHAR(600)# Where condition
                  s      LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(3)# Order by sequence   #FUN-540012 add
                  t      LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(3)# Eject sw            #FUN-540012 add
                  u      LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(3)# Subtotal            #FUN-540012 add
                  more   LIKE type_file.chr1             #No.FUN-680121 VARCHAR(1)#Input more condition(Y/N)
                 END RECORD,
         l_sum   LIKE eco_file.eco05,        #No.FUN-680121 DECIMAL(7,2)
         g_sum   LIKE eco_file.eco05,        #No.FUN-680121 DECIMAL(7,2)
         g_tot2  LIKE ste_file.ste06         #No.FUN-680121 DEC(9,2)
DEFINE   g_count LIKE type_file.num5         #No.FUN-680121 SMALLINT
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE    l_table     STRING,                 ### FUN-720005 ###
          g_str       STRING,                 ### FUN-720005 ###
          g_sql       STRING                  ### FUN-720005 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                 # Supress DEL key function
 
   #No.TQC-A50156  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #str FUN-720005 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/02/06 TSD.Martin  *** ##
   LET g_sql  = "sgm01.sgm_file.sgm01,",     #Run Card
                "sgm02.sgm_file.sgm02,",     #工單編號
                "sfb06.sfb_file.sfb06,",     #製程編號
                "sgm03.sgm_file.sgm03,",     #製程序
                "sgm04.sgm_file.sgm04,",     #作業編號
                "sgm45.sgm_file.sgm45,",     #作業說明
                "sgm05.sgm_file.sgm05,",     #機械編號
                "shb10.shb_file.shb10,",     #生產料件
                "ima02.ima_file.ima02,",     #料件名稱
                "ima021.ima_file.ima021,",    #料件規格
                "sgm311.sgm_file.sgm311,",    #良品轉出
                "sgm302.sgm_file.sgm302,",    #重工轉入
                "sgm301.sgm_file.sgm301,",    #良品轉入
                "sgm302_l.sgm_file.sgm302,",    #重工轉入
                "sgm_k.sgm_file.sgm311,", 
                #"shb08.shb_file.shb08,",     #線/班別        #FUN-540012 add   #MOD-940391
                "sgm06.sgm_file.sgm06,",      #工作中心編號   #FUN-540012 add
                "sgm012.sgm_file.sgm012 "      #NO.FUN-A60080  
   LET l_table = cl_prt_temptable('asfr815',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?,? ,", 
               #"        ?, ?, ?, ?, ?,  ?, ?)"   #MOD-940391
               "        ?, ?, ?, ?, ?,  ?,?)"   #MOD-940391 #NO.FUN-A60080 add ?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-720005 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
   #No.TQC-A50156  --End  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r700_tm(0,0)        # Input print condition
      ELSE CALL asfr815()        # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r700_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE 
      LET p_row = 6 LET p_col = 14
   END IF
 
   OPEN WINDOW r700_w AT p_row,p_col
        WITH FORM "asf/42f/asfr815"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL            # Default condition
    LET tm.s    = '123'   #FUN-540012 add
    LET tm.t    = ''      #FUN-540012 add
    LET tm.u    = ''      #FUN-540012 add
    LET tm.more = 'N'
    LET g_pdate = g_today
    LET g_rlang = g_lang
    LET g_bgjob = 'N'
    LET g_copies = '1'
   #start FUN-540012 add
    #genero版本default 排序,跳頁,合計值
    LET tm2.s1   = tm.s[1,1]
    LET tm2.s2   = tm.s[2,2]
    LET tm2.s3   = tm.s[3,3]
    LET tm2.t1   = tm.t[1,1]
    LET tm2.t2   = tm.t[2,2]
    LET tm2.t3   = tm.t[3,3]
    IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
    IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
    IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
    IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
    IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
    IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
    IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
    IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
    IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   #end FUN-540012 add
 
WHILE TRUE
    DISPLAY BY NAME tm.more # Condition
    CONSTRUCT BY NAME tm.wc ON shb16,shb05,shb10,shb08,sgm04,sgm05,sgm06   #FUN-540012 add sgm04,sgm05,sgm06
#No.FUN-570240 --start--
       #No.FUN-580031 --start--
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
       #No.FUN-580031 ---end---
 
       ON ACTION controlp
          IF INFIELD(shb10) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO shb10
             NEXT FIELD shb10
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
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
        
       ON ACTION help
          CALL cl_show_help()                   #No.TQC-770003
 
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
 
    IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r700_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM 
    END IF
    IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
 
    DISPLAY BY NAME tm.more # Condition
   #start FUN-540012 modify
   #INPUT BY NAME tm.more WITHOUT DEFAULTS
    INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                  tm2.t1,tm2.t2,tm2.t3,
                  tm2.u1,tm2.u2,tm2.u3,
                  tm.more WITHOUT DEFAULTS
   #end FUN-540012 modify
       #No.FUN-580031 --start--
       BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.FUN-580031 ---end---
 
       AFTER FIELD more
           IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
           END IF
           IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
           END IF
 
      #start FUN-540012 add
      AFTER INPUT
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
           LET tm.t = tm2.t1,tm2.t2,tm2.t3
           LET tm.u = tm2.u1,tm2.u2,tm2.u3
      #end FUN-540012 add
 
################################################################################
# START genero shell script ADD
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
       ON ACTION CONTROLG 
          CALL cl_cmdask()    # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
       
       ON ACTION help
          CALL cl_show_help()          #No.TQC-770003
       #No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r700_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM 
    END IF
 
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr815'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asfr815','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'",                 #FUN-540012 add
                         " '",tm.t CLIPPED,"'",                 #FUN-540012 add
                         " '",tm.u CLIPPED,"'",                 #FUN-540012 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('asfr815',g_time,l_cmd)      # Execute cmd at later time
        END IF
        CLOSE WINDOW r700_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
    END IF
    CALL cl_wait()
    CALL asfr815()
    ERROR ""
END WHILE
    CLOSE WINDOW r700_w
END FUNCTION
 
FUNCTION asfr815()
    DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time           LIKE type_file.chr8        #No.FUN-6A0090
           l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
           l_order   ARRAY[3] OF LIKE sgm_file.sgm03_par,        #No.FUN-680121 VARCHAR(40)#FUN-540012 add
           sr        RECORD
                      order1     LIKE sgm_file.sgm03_par,        #No.FUN-680121 VARCHAR(40)#FUN-540012 add
                      order2     LIKE sgm_file.sgm03_par,        #No.FUN-680121 VARCHAR(40)#FUN-540012 add
                      order3     LIKE sgm_file.sgm03_par,        #No.FUN-680121 VARCHAR(40)#FUN-540012 add
                      sgm01      LIKE sgm_file.sgm01,     #Run Card
                      sgm02      LIKE sgm_file.sgm02,     #工單編號
                      sfb06      LIKE sfb_file.sfb06,     #製程編號
                      sgm03      LIKE sgm_file.sgm03,     #製程序
                      sgm04      LIKE sgm_file.sgm04,     #作業編號
                      sgm45      LIKE sgm_file.sgm45,     #作業說明
                      sgm05      LIKE sgm_file.sgm05,     #機械編號
                      shb10      LIKE shb_file.shb10,     #生產料件
                      ima02      LIKE ima_file.ima02,     #料件名稱
                      ima021     LIKE ima_file.ima021,    #料件規格
                      sgm311     LIKE sgm_file.sgm311,    #良品轉出
                      sgm302     LIKE sgm_file.sgm302,    #重工轉入
                      sgm301     LIKE sgm_file.sgm301,    #良品轉入
                      sgm302_l   LIKE sgm_file.sgm302,    #重工轉入
                      sgm_k      LIKE sgm_file.sgm311,    #No.FUN-680121 DECIMAL(9,2)#生產良率
                      #shb08      LIKE shb_file.shb08,     #線/班別        #FUN-540012 add   #MOD-940391
                      sgm06      LIKE sgm_file.sgm06,      #工作中心編號   #FUN-540012 add
                      sgm012     like sgm_file.sgm012     #NO.FUN-A60080
                     END RECORD
   DEFINE  l_t       STRING      #NO.FUN-A60080
   
   #str FUN-720005 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720005 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720005 add ###
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                #No:7782    # 只能使用自己的資料
   #       LET tm.wc= tm.wc clipped," AND sgmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                #No:7782    # 只能使用相同群的資料
   #       LET tm.wc= tm.wc clipped," AND sgmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc= tm.wc clipped," AND sgmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sgmuser', 'sgmgrup')
   #End:FUN-980030
 
   LET l_sum = 0
   LET g_sum = 0
 
  #LET l_sql =" SELECT sgm01,sgm02,'',sgm03,sgm04,sgm45,sgm05,shb10,'','',",            #FUN-540012 mark 
   #LET l_sql =" SELECT '','','',sgm01,sgm02,'',sgm03,sgm04,sgm45,sgm05,shb10,'','',",   #FUN-540012    #MOD-940391
   LET l_sql =" SELECT DISTINCT '','','',sgm01,sgm02,'',sgm03,sgm04,sgm45,sgm05,shb10,'','',",   #FUN-540012    #MOD-940391
              #"        sgm311,sgm302,sgm301,sgm302,'',shb08,sgm06",   #FUN-540012 add shb08,sgm06   #MOD-940391
              "        sgm311,sgm302,sgm301,sgm302,'',sgm06,sgm012",   #MOD-940391 #NO.FUN-A60080 add sgm012
              " FROM sgm_file, shb_file",  #No:7782
              " WHERE shb16 = sgm01 ",
              "   AND shb06 = sgm03 ",
              "   AND shbconf = 'Y' ",  #FUN-A70095 
              "   AND ",tm.wc CLIPPED ,
              "   ORDER BY sgm01"
   PREPARE r700_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE r700_cs1 CURSOR FOR r700_prepare1
 
   LET g_tot2 = 0
   LET g_count=0
   FOREACH r700_cs1 INTO sr.*
      SELECT sfb06 INTO sr.sfb06 FROM sfb_file
      #WHERE sfb05 = sr.shb10 #TQC-940163     
       WHERE sfb01 = sr.sgm02     #TQC-940163    
      SELECT ima01,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
       WHERE ima01 = sr.shb10
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) CONTINUE FOREACH
      END IF
      IF sr.sgm301+sr.sgm302_l <> 0 THEN
         LET sr.sgm_k = (sr.sgm311 - sr.sgm302) / (sr.sgm301 + sr.sgm302_l)*100
      END IF
      IF sr.sgm_k IS NULL THEN LET sr.sgm_k = 0 END IF
     #start FUN-540012 add
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.sgm01   #RUN CARD
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.sgm03   #製程序號
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.shb10   #生產料件
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.sgm02   #工單號碼
              #WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.shb08   #線/班別   #MOD-940391
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.sgm04   #作業編號
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.sgm05   #機器編號
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.sgm06   #工作中心編號
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
     #end FUN-540012 add
   
      #str FUN-720005 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
      EXECUTE insert_prep USING 
            sr.sgm01,sr.sgm02,sr.sfb06,sr.sgm03,sr.sgm04,sr.sgm45,
            sr.sgm05,sr.shb10,sr.ima02,sr.ima021,sr.sgm311,sr.sgm302,
            #sr.sgm301,sr.sgm302_l,sr.sgm_k,sr.shb08,sr.sgm06   #MOD-940391
            sr.sgm301,sr.sgm302_l,sr.sgm_k,sr.sgm06,sr.sgm012   #MOD-940391  #NO.FUN-A60080
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720005 add
   END FOREACH
 
   #str FUN-720005 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'shb16,shb05,shb10,shb08,sgm04,sgm05,sgm06') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u 
   #NO.FUN-A60080--begin
   IF g_sma.sma541='Y' THEN  
      LET l_t='asfr815_1'
   ELSE 
   	  LET l_t='asfr815'
   END IF 
   CALL cl_prt_cs3('asfr815',l_t,l_sql,g_str) 
   #NO.FUN-A60080--end
   #CALL cl_prt_cs3('asfr815','asfr815',l_sql,g_str)   #FUN-710080 modify  #NO.FUN-A60080--mark
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720005 add
END FUNCTION

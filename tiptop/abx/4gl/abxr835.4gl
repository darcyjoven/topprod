# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abxr835.4gl
# Descriptions...: 盤存統計表列印作業(abxr835)
# Date & Author..: 
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima021
# Modify.........: No.FUN-530012 05/03/16 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-5A0233 05/10/21 By Nicola 加入ima106='2'時的SQL
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/25 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: NO.FUN-740077 07/04/23 BY TSD.c123k 改為crystal report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C20179 12/02/22 By ck2yuan 每次計算 清空 sr.l_bwf02_1,sr.l_bwf02_2
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE xxx LIKE type_file.chr1000         #No.FUN-680062     VARCHAR(30) 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc     STRING,            # Where condition   #No.FUN-680062   VARCHAR(1000)   
              a      LIKE type_file.chr1,                                   #No.FUN-680062   VARCHAR(1)    
            #FUN-6A0007...............begin
              c       LIKE type_file.chr1,
              yy      LIKE type_file.chr4,
              u       LIKE type_file.chr2,
              s       LIKE type_file.chr2
            #FUN-6A0007...............end
              END RECORD,
          g_count  LIKE type_file.num5,                     #No.FUN-680062          smallint
          l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用        
 
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
#FUN-740077 TSD.c123k add ----------------
DEFINE   l_table    STRING
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
#FUN-740077 TSD.c123k end ----------------
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
#FUN-740077 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740077 *** ##
   LET g_sql = "l_bxz101.bxz_file.bxz101,",
               "l_bxz100.bxz_file.bxz100,", 
               "l_bxz102.bxz_file.bxz102,", 
               "bwf01.bwf_file.bwf01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
               "l_bwf02_1.bwf_file.bwf02,",
               "l_bwf02_2.bwf_file.bwf02,",
               "bwf03.bwf_file.bwf03,",
               "bwf06.bwf_file.bwf06,",
               "bwf07.bwf_file.bwf07,",
               "bwf08.bwf_file.bwf08,",
               "bwf05.bwf_file.bwf05,",
               "bwf09.bwf_file.bwf09,",
               "l_total.type_file.num10,",
               "l_bxe02.bxe_file.bxe02,",
               "l_bxe03.bxe_file.bxe03,",
               "ima01.ima_file.ima01,",
               "ima1916.ima_file.ima1916"
 
   LET l_table = cl_prt_temptable('abxr835',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
#FUN-740077 end
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
   let tm.a ='N'                                         
   #FUN-6A0007...............begin
   LET tm.yy=YEAR(g_today)
   LET tm.c ='Y'
   LET tm2.s1='2'
   LET tm2.s2='1'
   LET tm2.u1='N'
   LET tm2.u2='N'              
   #FUN-6A0007...............end                
   IF cl_null(tm.wc)
   THEN 
       CALL abxr835_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr835_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 8 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 18
   END IF
   OPEN WINDOW abxr835_w AT p_row,p_col
        WITH FORM "abx/42f/abxr835" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
WHILE TRUE
   #FUN-6A0007...............begin
  #CONSTRUCT BY NAME tm.wc ON ima01,ima106
   CONSTRUCT BY NAME tm.wc ON ima01,ima1916,ima106
   #FUN-6A0007...............end
 
#No.FUN-570243 --start                                                          
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP                                                      
            IF INFIELD(ima01) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO ima01                             
               NEXT FIELD ima01                                                 
            END IF                                                              
#No.FUN-570243 --end     
 
            #FUN-6A0007...............begin
            IF INFIELD(ima1916) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_bxe01"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO ima1916                             
               NEXT FIELD ima1916                                                 
            END IF                     
            #FUN-6A0007...............end                                         
 
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
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr835_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" 
   THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
   #FUN-6A0007...............begin
   #INPUT BY NAME tm.a WITHOUT DEFAULTS 
    INPUT BY NAME tm.yy,tm.a,tm.c,tm2.s1,tm2.s2,tm2.u1,tm2.u2 WITHOUT DEFAULTS
 
    AFTER INPUT
       IF INT_FLAG THEN EXIT INPUT END IF 
       LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
       LET tm.u = tm2.u1[1,1],tm2.u2[1,1]
   #FUN-6A0007...............end
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD a
           if tm.a NOT MATCHES '[YNyn]' THEN
              next field a
           end if
        #FUN-6A0007...............begin
        AFTER FIELD c
           IF cl_null(tm.c) OR tm.c NOT MATCHES '[YNyn]' THEN
              next field c
           END IF
 
        AFTER FIELD s1
           IF NOT cl_null(tm2.s1) AND tm2.s1 NOT MATCHES '[12]' THEN
              next field s1
           END IF
 
        AFTER FIELD s2
           IF NOT cl_null(tm2.s2) AND tm2.s2 NOT MATCHES '[12]' THEN
              next field s2
           END IF
 
        AFTER FIELD u1
           IF cl_null(tm2.u1) OR tm2.u1 NOT MATCHES '[YNyn]' THEN
              next field u1
           END IF
 
        AFTER FIELD u2
           IF cl_null(tm2.u2) OR tm2.u2 NOT MATCHES '[YNyn]' THEN
              next field u2
           END IF
 
        #FUN-6A0007...............end
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT 
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr835_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL abxr835()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr835_w
END FUNCTION
 
FUNCTION abxr835()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name              #No.FUN-680062      VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,        #No.FUN-680062 VARCHAR(1000)
          #l_za05    LIKE za_file.za05,             #No.FUN-680062 VARCHAR(40)  #FUN-6A0007
          l_order   ARRAY[2] OF LIKE ima_file.ima01, #FUN-6A0007
          bwf       RECORD LIKE bwf_file.*,   
          ima       RECORD LIKE ima_file.*
  #FUN-6A0007...............begin
  DEFINE sr RECORD
            l_total   LIKE type_file.num10,
            l_bwf02_1 LIKE bwf_file.bwf02,
            l_bwf02_2 LIKE bwf_file.bwf02,
            order1    LIKE ima_file.ima01,
            order2    LIKE ima_file.ima01
            END RECORD
  #FUN-6A0007...............end
  #FUN-740077 TSD.c123k add --------------------------------------------
  DEFINE l_bxz100  LIKE bxz_file.bxz100,             #監管單位
         l_bxz102  LIKE bxz_file.bxz102,             #保稅類型
         l_bxz101  LIKE bxz_file.bxz101              #海關廠監管編號
  DEFINE l_bxe02   LIKE bxe_file.bxe02,
         l_bxe03   LIKE bxe_file.bxe03
  #FUN-740077 TSD.c123k end --------------------------------------------
 
#FUN-740077 - add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740077 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
#FUN-740077 - END
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #FUN-6A0007...............begin
     #LET l_sql = "select * from ima_file where ",tm.wc clipped 
     LET l_sql = "SELECT bwf_file.*,ima_file.* ",
                 "  FROM bwf_file,ima_file ",
                 " WHERE ",tm.wc clipped, 
                 "   AND ima01 = bwf01 ",
                 "   AND bwf011 = ",tm.yy
     #FUN-6A0007...............end
 
     if tm.a = 'Y' THEN
        let l_sql = l_sql clipped ," AND ima15='Y'  "
     end if
 
     PREPARE abxr835_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
     END IF
     LET g_count = 0
     DECLARE abxr835_curs1 CURSOR FOR abxr835_prepare1
    
    #CALL cl_outnam('abxr835') RETURNING l_name
    #START REPORT abxr835_rep TO l_name  #FUN-740077 TSD.c123k mark
 
     LET g_pageno = 0
 
     #FUN-740077 TSD.c123k add -----------------------------------------
     SELECT bxz100,bxz102,bxz101 
       INTO l_bxz100,l_bxz102,l_bxz101 FROM bxz_file
     #FUN-740077 TSD.c123k end -----------------------------------------
 
    #FOREACH abxr835_curs1 INTO ima.*  #FUN-6A0007
     FOREACH abxr835_curs1 INTO bwf.*,ima.*  #FUN-6A0007
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       LET bwf.bwf01 = ima.ima01 
      #FUN-6A0007...............begin mark
      #LET bwf.bwf02 = 0 
      #LET bwf.bwf03 = 0 
      #LET bwf.bwf04 = 0 
      #LET bwf.bwf05 = 0   
      #FUN-6A0007...............end
       LET sr.l_bwf02_1 = 0        #MOD-C20179 add
       LET sr.l_bwf02_2 = 0        #MOD-C20179 add
       CASE 
          WHEN ima.ima106 = "1"
               #原料倉存量
              #FUN-6A0007...............begin
              #SELECT SUM(bwa06) INTO bwf.bwf02 FROM bwa_file 
               SELECT SUM(bwa06) INTO sr.l_bwf02_1 FROM bwa_file 
               WHERE  bwa02 = bwf.bwf01 
                 AND  bwa17='Y'     
                 AND  bwa011=tm.yy   
              #FUN-6A0007...............end
              
               #生產線上原料型態
               #生產線上半成品和成品
               #成品倉庫存折合原料量
               #FUN-6A0007...............begin 
              #select sum(bwe04) INTO bwf.bwf05 
              #FROM bwe_file,bwa_file 
              #WHERE (bwe01 = bwa01 AND bwa02 <> bwf.bwf01) 
              #AND    bwe03 = bwf.bwf01 
              #AND    bwe00 = "S"
               
               SELECT SUM(bwa06) INTO sr.l_bwf02_2 FROM bwa_file
                WHERE bwa02=bwf.bwf01
                  AND bwa17='N'
                  AND bwa011=tm.yy
               #FUN-6A0007...............end
 
          WHEN ima.ima106 = "2"
               #FUN-6A0007...............begin
               #-----No.MOD-5A0233-----
              #SELECT SUM(bwf02),SUM(bwf03),SUM(bwf04),SUM(bwf05)
              #  INTO bwf.bwf02,bwf.bwf03,bwf.bwf04,bwf.bwf05
              #  FROM bwf_file
              # WHERE bwf01 = bwf.bwf01
               #-----No.MOD-5A0233 END-----
               #FUN-6A0007...............end
          WHEN ima.ima106 = "3"
               #FUN-6A0007...............begin
              #SELECT SUM(bwa06) INTO bwf.bwf05 FROM bwa_file 
              #WHERE  bwa02 = bwf.bwf01 
               #FUN-6A0007...............end
       END CASE 
       #FUN-6A0007...............begin
      #IF bwf.bwf02 is null then let bwf.bwf02 = 0 END IF 
      #IF bwf.bwf03 is null then let bwf.bwf03 = 0 END IF 
      #IF bwf.bwf04 is null then let bwf.bwf04 = 0 END IF 
      #IF bwf.bwf05 is null then let bwf.bwf05 = 0 END IF 
 
       IF cl_null(sr.l_bwf02_1) THEN LET sr.l_bwf02_1 = 0 END IF 
       IF cl_null(sr.l_bwf02_2) THEN LET sr.l_bwf02_2 = 0 END IF 
       IF cl_null(bwf.bwf03) THEN LET bwf.bwf03 = 0 END IF 
       IF cl_null(bwf.bwf06) THEN LET bwf.bwf06 = 0 END IF
       IF cl_null(bwf.bwf07) THEN LET bwf.bwf07 = 0 END IF
       IF cl_null(bwf.bwf08) THEN LET bwf.bwf08 = 0 END IF
       IF cl_null(bwf.bwf05) THEN LET bwf.bwf05 = 0 END IF
       IF cl_null(bwf.bwf09) THEN LET bwf.bwf09 = 0 END IF
       LET sr.l_total =
           sr.l_bwf02_1+sr.l_bwf02_2+bwf.bwf03+bwf.bwf06+bwf.bwf07+bwf.bwf08+bwf.bwf05+bwf.bwf09 
 
      #IF bwf.bwf02=0 AND bwf.bwf03=0 AND bwf.bwf04=0 AND bwf.bwf05=0 
       IF bwf.bwf02=0 AND bwf.bwf03=0 AND bwf.bwf04=0 AND bwf.bwf05=0
          AND bwf.bwf06=0 AND bwf.bwf07=0 AND bwf.bwf08=0 
          AND bwf.bwf09=0 
      #FUN-6A0007...............end
       THEN
           CONTINUE FOREACH 
       END IF 
 
       #FUN-6A0007...............begin
       FOR g_i = 1 TO 2
           CASE WHEN tm.s[g_i,g_i] = '1' 
                     LET l_order[g_i] = ima.ima01
                WHEN tm.s[g_i,g_i] = '2' 
                     LET l_order[g_i] = ima.ima1916
                OTHERWISE
                     LET l_order[g_i]  = '-'
           END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       #FUN-6A0007...............end
 
       message g_x[9],bwf.bwf01," ",ima.ima106
       CALL ui.Interface.refresh()
      #OUTPUT TO REPORT abxr835_rep(bwf.*)   #FUN-6A0007 mark
      #OUTPUT TO REPORT abxr835_rep(bwf.*,ima.*,sr.*)   #FUN-6A0007  #FUN-740077 TSD.c123k mark
 
      #FUN-740077 add
      LET l_bxe02 = NULL
      LET l_bxe03 = NULL
      SELECT bxe02,bxe03 INTO l_bxe02,l_bxe03
        FROM bxe_file WHERE bxe01 = ima.ima1916
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         l_bxz101,      l_bxz100,    l_bxz102,      bwf.bwf01,     ima.ima02, 
         ima.ima021,    ima.ima25,   sr.l_bwf02_1,  sr.l_bwf02_2,  bwf.bwf03, 
         bwf.bwf06,     bwf.bwf07,   bwf.bwf08,     bwf.bwf05,     bwf.bwf09,
         sr.l_total,    l_bxe02,     l_bxe03,       ima.ima01,     ima.ima1916
      #------------------------------ CR (3) ------------------------------#
      #FUN-740077 end
 
     END FOREACH
 
    #FINISH REPORT abxr835_rep #FUN-740077 TSD.c123k mark
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-740077 TSD.c123k mark
 
    # FUN-740077 add
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima01,ima1916,ima106')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.s,";",tm.u,";",tm.a,";",tm.c,";",tm.yy
 
    CALL cl_prt_cs3('abxr835','abxr835',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    # FUN-740077 end
 
END FUNCTION

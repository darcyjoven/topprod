# Prog. Version..: '5.30.06-13.03.12(00005)'     #
# 
# Pattern name...: abxr003.4gl
# Descriptions...: 存倉保稅原料成品結算報告表
# 1998.07.20 BY CHIAYI
# Modify.........: No.FUN-530012 05/03/22 By kim 報表轉XML功能
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/17 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0083 06/11/09 By xumin 報表標題居中 
# Modify.........: No.FUN-850089 08/05/30 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B30019 11/03/03 By sabrina 判斷是否要抓保稅資料應改為"1"
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
           g_count     LIKE  type_file.num10, #No.FUN-680062  INTEGER
           yy          LIKE  type_file.num5,  #No.FUN-680062  SMALLINT
           yy2         LIKE  type_file.num5,  #No.FUN-680062  SMALLINT
           mm          LIKE  type_file.num5,  #No.FUN-680062  SMALLINT
           kk          LIKE  type_file.chr1,  #No.FUN-680062  VARCHAR(1)
           ima15       LIKE  ima_file.ima15   #No.FUN-680062  VARCHAR(40)
           #g_conut     LIKE  type_file.num10  #No.FUN-680062  INTEGER #FUN-6A0007
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE tm  RECORD                         # Print condition RECORD
           wc      STRING,                # Where condition
           u       LIKE type_file.chr2,
           s       LIKE type_file.chr2
           END RECORD
DEFINE   l_table      STRING,    #FUN-850089 add
         g_str        STRING,    #FUN-850089 add
         g_sql        STRING     #FUN-850089 add 
MAIN
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
  LET g_sql = "bwa01.bwa_file.bwa01,",           #標籤編號
              "bwa02.bwa_file.bwa02,",           #料件編號
              "ima02.ima_file.ima02,",           #品名
              "ima021.ima_file.ima021,",         #規格
              "iam25.ima_file.ima25,",           #庫存單位
              "bnf07.bnf_file.bnf07,",           #期末數量
              "bwa06.bwa_file.bwa06,",           #盤存數量
              "diff2.type_file.num20_6,",        #帳面結存數3%數量
              "ima95.ima_file.ima95,",           #保稅單價
              "diff_1.type_file.num20_6,",       #盤盈
              "diff_2.type_file.num20_6,",       #盤虧
              "diff3.type_file.num20_6,",        #盤虧逾帳面結存數3%以上數量
              "diff4.type_file.num20_6,",        #盤虧逾帳面結存3%以上數量總價(新台幣元)
              "diff1.type_file.num20_6,",        #盤存數量-期末數量
              "l_bxe02.bxe_file.bxe02,",         #群組品名 
              "l_bxe03.bxe_file.bxe03,",         #群組規格
              "ima1916.ima_file.ima1916,",      #保稅群組代碼
              "ima01.ima_file.ima01 "
                                          #18 items
  LET l_table = cl_prt_temptable('abxr003',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
   CALL abxr003_tm(4,15)        # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr003_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062
 
   LET p_row = 6 LET p_col = 20
 
   OPEN WINDOW abxr003_w AT p_row,p_col WITH FORM "abx/42f/abxr003"  
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
WHILE TRUE
   LET yy   = YEAR(TODAY)
   LET yy2  = YEAR(TODAY)-1
   #LET mm   = 06 #FUN-6A0007
   LET mm   = MONTH(g_today) #FUN-6A0007
   LET kk   = "1"
   LET ima15= "1"
 
   #FUN-6A0007...............begin
   LET tm2.s1='2'
   LET tm2.s2='1'
   LET tm2.u1='N'
   LET tm2.u2='N'
 
   CONSTRUCT BY NAME tm.wc ON ima01,ima1916
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
 
            WHEN INFIELD(ima1916)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bxe01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima1916
               NEXT FIELD ima1916
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION locale
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about     
         CALL cl_about() 
 
      ON ACTION help   
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr003_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" 
   THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #FUN-6A0007...............end
 
   #FUN-6A0007...............begin
   #INPUT yy,yy2,mm,kk,ima15 WITHOUT DEFAULTS
   #FROM formonly.yy,formonly.yy2,formonly.mm,formonly.kk,formonly.ima15
   INPUT BY NAME yy,yy2,mm,kk,ima15,tm2.s1,tm2.s2,tm2.u1,tm2.u2 WITHOUT DEFAULTS
   #FUN-6A0007...............end
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
 
   AFTER FIELD mm 
      IF mm > 12 or mm<= 00 
      THEN
          NEXT FIELD mm 
      END IF 
   AFTER FIELD KK
      IF kk NOT MATCHES "[123456]" THEN #FUN-6A0007
          NEXT FIELD kk
      END IF 
   AFTER FIELD ima15
      IF ima15 NOT MATCHES "[12]" THEN
          NEXT FIELD ima15
      END IF 
   #FUN-6A0007...............begin
   AFTER FIELD s1
      IF NOT cl_null(tm2.s1) AND tm2.s1 NOT MATCHES '[12]' THEN
         NEXT FIELD s1
      END IF
 
   AFTER FIELD s2
      IF NOT cl_null(tm2.s2) AND tm2.s2 NOT MATCHES '[12]' THEN
         NEXT FIELD s2
      END IF
 
   AFTER FIELD u1
      IF cl_null(tm2.u1) OR tm2.u1 NOT MATCHES '[YNyn]' THEN
         NEXT FIELD u1
      END IF
 
   AFTER FIELD u2
      IF cl_null(tm2.u2) OR tm2.u2 NOT MATCHES '[YNyn]' THEN
         NEXT FIELD u2
      END IF
   AFTER INPUT
       LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
       LET tm.u = tm2.u1[1,1],tm2.u2[1,1]
       
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION help
        CALL cl_show_help()
 
   #FUN-6A0007...............end
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
      ON ACTION locale
        #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT 
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
  
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW abxr003_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr003()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr003_w
END FUNCTION
 
FUNCTION abxr003()
   DEFINE l_name   LIKE type_file.chr20,   # External(Disk) file name               #No.FUN-680062 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     STRING,      # RDSQL STATEMENT             #No.FUN-680062char(1000) 
          l_chr     LIKE type_file.chr1,                                      #No.FUN-680062 VARCHAR(1)
          l_ima15   LIKE ima_file.ima15,                                      #No.FUN-680062 VARCHAR(1)
          bwa       RECORD LIKE bwa_file.*,
          bnf       RECORD LIKE bnf_file.*,
          ima       RECORD LIKE ima_file.* 
   #FUN-6A0007...............begin
   DEFINE l_order     ARRAY[2] OF LIKE ima_file.ima01
   DEFINE sr RECORD
             order1    LIKE ima_file.ima01,
             order2    LIKE ima_file.ima01,
             diff1     LIKE type_file.num20_6,
             diff_1    LIKE type_file.num20_6,
             diff_2    LIKE type_file.num20_6,
             diff2     LIKE type_file.num20_6,
             diff3     LIKE type_file.num20_6,
             diff4     LIKE type_file.num20_6
             END RECORD
   #FUN-6A0007...............end
#FUN-850089 add---START
   DEFINE l_bxe02 LIKE bxe_file.bxe02,
          l_bxe03 LIKE bxe_file.bxe03
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT bwa_file.*,bnf_file.*,ima_file.* ",
                 " FROM bwa_file,bnf_file,ima_file ",
                 " WHERE bwa02 = bnf01 ",
                 " AND bwa02 = ima01 ",
                 " AND ",tm.wc,  #FUN-6A0007 
                 " AND bwa011 = ",yy,  #FUN-6A0007
                 " AND bnf03 = ",yy2," AND bnf04 =",mm   #FUN-6A0007
                  
    #IF ima15 = "Y"  #保稅      #MOD-B30019 mark
     IF ima15 = "1"  #保稅      #MOD-B30019 add
     THEN
          LET l_sql = l_sql CLIPPED," AND ima15 = 'Y' " clipped           
     END IF 
     #FUN-6A0007...............begin
     #IF kk = "1"
     #THEN
     #     LET l_sql = l_sql CLIPPED," AND ima106 ='1' " clipped 
     #ELSE 
     #     LET l_sql = l_sql CLIPPED," AND ima106 ='3' " clipped 
     #END IF 
     CASE WHEN kk ='1' 
          LET l_sql = l_sql CLIPPED," AND ima106 ='1' "
          WHEN kk ='2' 
          LET l_sql = l_sql CLIPPED," AND ima106 ='3' "
          WHEN kk ='3' 
          LET l_sql = l_sql CLIPPED," AND ima106 ='5' "
          WHEN kk ='4' 
          LET l_sql = l_sql CLIPPED," AND ima106 ='7' "
          WHEN kk ='5' 
          LET l_sql = l_sql CLIPPED," AND ima106 ='2' "
          WHEN kk ='6' 
          LET l_sql = l_sql CLIPPED," AND ima106 IN('2','3') "
          OTHERWISE EXIT CASE
     END CASE
     #FUN-6A0007...............end
     LET g_count = 0 
     PREPARE abxr003_prepare1 FROM l_sql
 
     IF SQLCA.sqlcode != 0 
     THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
 
     DECLARE abxr003_curs1 CURSOR FOR abxr003_prepare1
 
     FOREACH abxr003_curs1 INTO bwa.*,bnf.*,ima.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       #FUN-6A0007...............begin
       IF cl_null(bnf.bnf07) THEN LET bnf.bnf07=0 END IF
       IF cl_null(bwa.bwa06) THEN LET bwa.bwa06=0 END IF
       IF cl_null(ima.ima95) THEN LET ima.ima95=0 END IF
       LET sr.diff1 = bwa.bwa06 - bnf.bnf07
       LET sr.diff_1=0
       LET sr.diff_2=0
       LET sr.diff2 =0
       LET sr.diff3 =0
       LET sr.diff4 =0
       LET sr.diff2 = bnf.bnf07 * 0.03 
       CASE 
          WHEN sr.diff1 > 0   #盤盈
               LET sr.diff_1 = sr.diff1
          WHEN sr.diff1 < 0   #盤虧
               LET sr.diff_2=sr.diff1 * (-1)
         OTHERWISE EXIT CASE
       END CASE
       IF (sr.diff_2-sr.diff2)>0 THEN
          LET sr.diff3 = sr.diff_2-sr.diff2
       END IF
       IF sr.diff3>0 THEN
          LET sr.diff4 = sr.diff3 * ima.ima95 
       ELSE
          LET sr.diff4 = 0 
       END IF
 
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
      #---FUN-850089 add---START
       LET l_bxe02 = NULL
       LET l_bxe03 = NULL
       SELECT bxe02,bxe03 INTO l_bxe02,l_bxe03
         FROM bxe_file WHERE bxe01 = ima.ima1916
       EXECUTE insert_prep USING bwa.bwa01,  bwa.bwa02, ima.ima02, ima.ima021,
                                 ima.ima25,  bnf.bnf07, bwa.bwa06,   sr.diff2, 
                                 ima.ima95,  sr.diff_1, sr.diff_2,   sr.diff3, 
                                  sr.diff4,   sr.diff1,   l_bxe02,    l_bxe03,
                                 ima.ima1916,ima.ima01 
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
     END FOREACH
 
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY 'sr.order1','sr.order2',bwa01"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima01,ima1916')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
                #p1       #p2      #p3      #p4    #p5     #p6    #p7
    LET g_str = g_str,";",tm.s,";",tm.u,";",yy,";",yy2,";",mm,";",kk,";",
                #p8              #p9
                g_bxz.bxz100,";",g_bxz.bxz102,";",
                #p10
                YEAR(g_pdate)-1911 USING '<<<;',
                #p11
                MONTH(g_pdate) USING '<<;',
                #p12
                DAY(g_pdate) USING '<<'
    CALL cl_prt_cs3('abxr003','abxr003',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---
END FUNCTION
#No.FUN-870144 

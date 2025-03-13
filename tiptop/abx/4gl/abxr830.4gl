# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abxr830.4gl
# Descriptions...: 庫存盤存清冊列印作業(abxr830)
# Date & Author..: 
# Modify.........: 05/02/25 By cate 報表標題標準化
# Modify.........: No.FUN-530012 05/03/16 By kim 報表轉XML功能
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/17 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/29 By TSD.sar2436 報表改由CR產出
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-BB0315 11/11/30 By ck2yuan 條件選擇標籤 應為bwa01 而非bwa02

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,             # Where condition        #No.FUN-680062  VARCHAR(1000)
              x       LIKE type_file.chr1,                # 盤點數量為零是否列印        #No.FUN-680062  VARCHAR(1)
              #FUN-6A0007...............begin
              yy       LIKE type_file.chr4,            #盤點年度
              ima106   LIKE type_file.chr1,            #料件型態
              u        LIKE type_file.chr2,            #小計否
              s        LIKE type_file.chr2              # 排列順序        
              #s       LIKE type_file.chr5                 # 排列順序           #No.FUN-680062   VARCHAR(5)
              #FUN-6A0007...............end
          END RECORD,
          l_outbill     LIKE oga_file.oga01               # 出貨單號,傳參數用
 
DEFINE   g_i     LIKE type_file.num5          #count/index for any purpose    #No.FUN-680062 smallint
DEFINE   g_msg   LIKE type_file.chr1000
DEFINE   l_table      STRING,    #FUN-850089 add
         g_str        STRING,    #FUN-850089 add
         g_sql        STRING     #FUN-850089 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
---FUN-850089 add ---start
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
 LET g_sql = "bwa01.bwa_file.bwa01,",
             "bwa011.bwa_file.bwa011,",
             "bwa02.bwa_file.bwa02,",
             "bwa03.bwa_file.bwa03,",
             "bwa04.bwa_file.bwa04,",
 
             "bwa05.bwa_file.bwa05,",
             "bwa06.bwa_file.bwa06,",
             "bwa17.bwa_file.bwa17,",
             "bwa18.bwa_file.bwa18,",
             "ima02.ima_file.ima02,",
 
             "ima021.ima_file.ima021,",
             "ima1916.ima_file.ima1916,",
             "ima25.ima_file.ima25,",
             "bxe02.bxe_file.bxe02,",
             "bxe03.bxe_file.bxe03,",
 
             "order1.bwa_file.bwa02,",
             "order2.bwa_file.bwa02"
 
             
        
 LET l_table = cl_prt_temptable('abxr830',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
 LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?  ,?,?,?,?,?  ,?,?)"   #17?
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1)
    EXIT PROGRAM
 END IF
#------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.x     = 'Y'
   #LET tm.s     = '12345' #FUN-6A0007
   LET tm.wc= ARG_VAL(1)
   #genero版本default 排序,跳頁,合計值
   
  #FUN-6A0007...............begin
  #LET tm2.s1   = tm.s[1,1]
  #LET tm2.s2   = tm.s[2,2]
  #LET tm2.s3   = tm.s[3,3]
  #LET tm2.s4   = tm.s[4,4]
  #LET tm2.s5   = tm.s[5,5]
   LET tm.ima106='0'
   LET tm2.s1='2'
   LET tm2.s2='1'
   LET tm2.u1='N'
   LET tm2.u2='N'
   LET tm.yy=YEAR(g_today)
 
  #IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
  #IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
  #IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
  #IF cl_null(tm2.s4) THEN LET tm2.s4 = ""  END IF
  #IF cl_null(tm2.s5) THEN LET tm2.s5 = ""  END IF
  #FUN-6A0007...............end
 
   
   IF cl_null(tm.wc)
   THEN 
       CALL abxr830_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr830_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680062  smallint
          l_cmd          LIKE type_file.chr1000        #No.FUN-680062  VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW abxr830_w AT p_row,p_col
        WITH FORM "abx/42f/abxr830" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON bwa01 #FUN-6A0007
   CONSTRUCT BY NAME tm.wc ON ima01,ima1916,bwa01 #FUN-6A0007
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr830_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" 
   THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF 
   #FUN-6A0007...............begin
   #INPUT BY NAME tm.x,
   #              tm2.s1,tm2.s2,tm2.s3,tm2.s4,tm2.s5
    INPUT BY NAME tm.yy,
                  tm2.s1,tm2.s2,tm2.u1,tm2.u2,tm.x,tm.ima106
                  WITHOUT DEFAULTS
   #FUN-6A0007...............end
      #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
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
 
      AFTER FIELD ima106
         IF cl_null(tm.ima106) OR tm.ima106 NOT MATCHES '[0123567]' THEN
            NEXT FIELD ima106
         END IF
      #FUN-6A0007...............end
      
      AFTER FIELD x
         #if cl_null(tm.x) THEN NEXT FIELD x END IF #FUN-6A0007
         if cl_null(tm.x) OR tm.x NOT MATCHES '[YNyn]' THEN NEXT FIELD x END IF #FUN-6A0007
      AFTER INPUT
         #FUN-6A0007...............begin
         #LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],tm2.s4[1,1],tm2.s5[1,1] 
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.u = tm2.u1[1,1],tm2.u2[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr830_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL abxr830()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr830_w
END FUNCTION
 
FUNCTION abxr830()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name   #No.FUN-680062 VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     STRING,        #No.FUN-680062  VARCHAR(1000)
          l_za05    LIKE za_file.za05,             #No.FUN-680062  VARCHAR(40)
          #FUN-6A0007...............begin
          #l_order ARRAY[5] of LIKE type_file.chr20,                #No.FUN-680062  VARCHAR(20)
          l_order ARRAY[2] of  LIKE bwa_file.bwa02,
          #x_ima25  LIKE ima_file.ima25,
          #x_ima15  LIKE ima_file.ima15, 
          #x_ima02  LIKE ima_file.ima02, 
          #x_ima021 LIKE ima_file.ima02, 
          #x_ima106 LIKE ima_file.ima106,
          #x_ima1061  LIKE zaa_file.zaa08,            #No.FUN-680062  VARCHAR(6)          
          #x_bwa03    LIKE bwa_file.bwa03,           #No.FUN-680062  VARCHAR(20)          
          #x_bwa04    LIKE bwa_file.bwa04,           #No.FUN-680062  VARCHAR(10)
          #FUN-6A0007...............end
          bwa       RECORD LIKE bwa_file.*  
   #FUN-6A0007...............begin
   DEFINE l_title   STRING   #FUN-850089 add
   DEFINE l_bxz100  LIKE   bxz_file.bxz100   #FUN-850089 add
   DEFINE l_bxz101  LIKE   bxz_file.bxz101   #FUN-850089 add
   DEFINE l_bxz102  LIKE   bxz_file.bxz102   #FUN-850089 add
   DEFINE sr RECORD
             order1      LIKE bwa_file.bwa02,
             order2      LIKE bwa_file.bwa02,
             ima02       LIKE ima_file.ima02, 
             ima021      LIKE ima_file.ima021, 
             ima25       LIKE ima_file.ima25,
             ima1916     LIKE ima_file.ima1916, 
             bxe02       LIKE bxe_file.bxe02,
             bxe03       LIKE bxe_file.bxe03
             END RECORD
   #FUN-6A0007...............end
 
#FUN-850089 add---START
DEFINE l_sql2    STRING
## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql="SELECT bwa_file.* ",
             #"  FROM bwa_file  ", #FUN-6A0007
             "  FROM bwa_file,ima_file ", #FUN-6A0007
             " WHERE ima01=bwa02 AND ",tm.wc clipped #FUN-6A0007 ADD "ima01=bwa02 AND "
 
   #FUN-6A0007...............begin
   IF NOT cl_null(tm.yy) THEN
      LET l_sql=l_sql," AND bwa011=",tm.yy
   END IF
   IF tm.ima106 <> '0' THEN
      LET l_sql = l_sql CLIPPED," AND ima106='",tm.ima106,"' "  #符合料件型態
   END IF
   #FUN-6A0007...............end
 
   PREPARE abxr830_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   DECLARE abxr830_curs1 CURSOR FOR abxr830_prepare1
 
   FOREACH abxr830_curs1 INTO bwa.*
     MESSAGE g_x[12],bwa.bwa02,g_x[13],bwa.bwa06 
     CALL ui.Interface.refresh()
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) 
        EXIT FOREACH 
     END IF
     
    #FUN-6A0007...............mark begin
    #select ima02,ima021,ima25,ima15,ima106 into 
    #       x_ima02,x_ima021,x_ima25,x_ima15,x_ima106 
    #from ima_file
    #where ima01 = bwa.bwa02
    
    #CASE WHEN x_ima106 = '1'
    #          LET x_ima1061 = g_x[14]
    #     WHEN x_ima106 = '2'
    #          LET x_ima1061 = g_x[15]
    #     WHEN x_ima106 = '3'
    #          LET x_ima1061 = g_x[16]
    #     OTHERWISE
    #          LET x_ima1061 = x_ima106
    #END CASE
 
    #IF x_ima106 = '2' THEN
    #   let x_bwa03 = g_x[17]
    #   IF bwa.bwa03 = 'B' THEN
    #      let x_bwa04 = g_x[18]
    #   ELSE                                  ## 除B倉外,全用原倉庫名稱
    #      select imd02[1,10] into x_bwa04 from imd_file
    #                          where bwa.bwa03=imd01     
    #   END IF
    #ELSE
    #   IF x_ima15='Y' THEN 
    #      let x_bwa03 = g_x[19],x_ima1061 CLIPPED,g_x[20]
    #      let x_bwa04 = bwa.bwa04        
    #   else 
    #      let x_bwa03 = bwa.bwa03
    #      select imd02 into x_bwa03 from imd_file
    #                              where bwa.bwa03=imd01
    #      let x_bwa04 = bwa.bwa04
    #   end if
    #end if
 
    #FOR g_i = 1 TO 5
    #    CASE WHEN tm.s[g_i,g_i] = '1'
    #              IF x_ima15='Y' THEN
    #                 let l_order[g_i] = '1'     
    #              else
    #                 let l_order[g_i] = '2'     
    #              end if
    #         WHEN tm.s[g_i,g_i] = '2'
    #              let l_order[g_i] = bwa.bwa01
    #         WHEN tm.s[g_i,g_i] = '3'
    #              let l_order[g_i] = x_ima106
    #         WHEN tm.s[g_i,g_i] = '4'
    #              let l_order[g_i] = x_bwa03
    #         WHEN tm.s[g_i,g_i] = '5'
    #              let l_order[g_i] = x_bwa04
    #         OTHERWISE
    #              let l_order[g_i] = '  '
    #    END CASE
    #END FOR
    #FUN-6A0007...............mark end
    
     #FUN-6A0007...............begin
     SELECT ima02,ima021,ima25,ima1916 INTO 
             sr.ima02,sr.ima021,sr.ima25,sr.ima1916
        FROM ima_file
       WHERE ima01 = bwa.bwa02
 
     IF (tm.x='Y' AND (bwa.bwa06=0 OR cl_null(bwa.bwa06))) THEN
        CONTINUE FOREACH 
     END IF
       FOR g_i = 1 TO 2
          CASE
             WHEN tm.s[g_i,g_i] = '1'
                #LET l_order[g_i] = bwa.bwa02      #MOD-BB0315 mark
                LET l_order[g_i] = sr.ima1916      #MOD-BB0315 add 1為保稅
             WHEN tm.s[g_i,g_i] = '2'
                #LET l_order[g_i] = sr.ima1916     #MOD-BB0315 mark
                LET l_order[g_i] = bwa.bwa01       #MOD-BB0315 add 2為標籤
             OTHERWISE
                LET l_order[g_i]  = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
 
     #---FUN-850089 add---START
 
       EXECUTE insert_prep USING bwa.bwa01,   bwa.bwa011,    bwa.bwa02,  bwa.bwa03,    bwa.bwa04,
                                 bwa.bwa05,   bwa.bwa06,     bwa.bwa17,  bwa.bwa18,    sr.ima02,
                                 sr.ima021,   sr.ima1916,    sr.ima25,   sr.bxe02,     sr.bxe03,
                                 sr.order1,   sr.order2
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
     #---FUN-850089 add---END
 
   END FOREACH
 
 #FUN-850089  ---start---
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
   LET l_sql2= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   SELECT bxz100,bxz102,bxz101
     INTO l_bxz100,l_bxz102,l_bxz101 FROM bxz_file
   LET l_title = l_bxz100 CLIPPED,g_company CLIPPED,l_bxz102 CLIPPED
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ima01,ima1916,bwa01')
           RETURNING g_str
   ELSE
      LET g_str = ''
   END IF
              
               #P1             #P2                           #P3       
   LET g_str = g_str,";",      tm.yy-1911 USING '<<<',";",   tm.s[1,1],";",
               #P4             #P5             #P6           #P7
               tm.s[2,2],";",  tm.u[1,1],";",  tm.u[2,2],";",l_title,";",
               #P8             #P9
               l_bxz101,";",   tm.ima106,";",
               #P10
               YEAR(g_pdate)-1911 USING '<<<;',
               #P11
               MONTH(g_pdate) USING '<<;',
               #P12
               DAY(g_pdate) USING '<<'
   CALL cl_prt_cs3('abxr830','abxr830',l_sql2,g_str)
   #------------------------------ CR (4) ------------------------------#
 #FUN-850089  ----end---
END FUNCTION
#No.FUN-870144

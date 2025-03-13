# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
#Pattern name...: abxr840.4gl
# Descriptions...:年度保稅原料結算報告表(abxr840) 
# Date & Author..: 
# Modify.........: No.FUN-530012 05/03/17 By kim 報表轉XML功能
# Modify.........: No.MOD-580323 05/08/30 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-680038 06/08/15 By Claire ima20替換 bwh13
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/25 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-850089 08/05/28 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-BC0049 11/12/07 By ck2yuan Mark FOREACH abxr840_curs1段的IF判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              g_yy  LIKE type_file.num5,     #No.FUN-680062    smallint
             #FUN-6A0007...............begin
              wc      STRING,
              a       LIKE type_file.chr1,
              c       LIKE type_file.chr1,
              u       LIKE type_file.chr2,
              s       LIKE type_file.chr2,
            #FUN-6A0007...............end
              yn    LIKE type_file.chr1      #No.FUN-680062    VARCHAR(1)
              END RECORD,
          g_count       LIKE type_file.num5,             #No.FUN-680062  smallint
          l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用
 
DEFINE   g_i     LIKE type_file.num5    #count/index for any purpose   #No.FUN-680062 smallint
DEFINE   l_table      STRING,    #FUN-850089 add
         g_sql        STRING,    #FUN-850089 add
         g_str        STRING     #FUN-850089 add
 
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
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bwh02.bwh_file.bwh02,",         #料件編號         
              "x_ima02.ima_file.ima02,",       #品名
              "x_ima021.ima_file.ima021,",     #規格
              "x_ima25.ima_file.ima25,",       #單位
              "bwh04.bwh_file.bwh04,",         #期初非保稅結存數
              "bwh06.bwh_file.bwh06,",         #本期非保稅進貨數
              "bwh03.bwh_file.bwh03,",         #期初保稅結存數 
              "bwh05.bwh_file.bwh05,",         #本期保稅進貨數
              "bwh07.bwh_file.bwh07,",         #本期外銷使用數
              "bwh08.bwh_file.bwh08,",         #本期內銷使用數
              "bwh09.bwh_file.bwh09,",         #本期外運數
              "bwh10.bwh_file.bwh10,",         #本期報廢數
              "l_tmp.bwh_file.bwh03,",         #本年度帳面結存數
              "bwh11.bwh_file.bwh11,",         #本期盤存數
              "bwh121.bwh_file.bwh12,",        #帳面數與盤存數比較---盤盈
              "bwh122.bwh_file.bwh12,",        #帳面數與盤存數比較---盤虧
              "ima20.ima_file.ima20,",         #保稅料件年度盤差容許率
              "bwh13.bwh_file.bwh13,",         #盤差容許數量
              "bwh14.bwh_file.bwh14,",         #本期盤差補稅數
              "bwh15.bwh_file.bwh15,",         #期末應結轉下期保稅數
              "bwh16.bwh_file.bwh16,",         #期末應結轉下期非保稅數
              "ima1916.ima_file.ima1916,",     #保稅群組代碼
              "bwh01.bwh_file.bwh01,",         #年度
              "l_bxe02.bxe_file.bxe02,",       #群組品名
              "l_bxe03.bxe_file.bxe03,",       #群組規格
              "bwh12.bwh_file.bwh12 "          #本期盤盈虧數
                                          #27 items
  LET l_table = cl_prt_temptable('abxr840',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   CALL abxr840_tm(0,0)             # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr840_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,       #No.FUN-680062 smallint
          l_cmd         LIKE type_file.chr1000     #No.FUN-680062 VARCHAR(1000)
   DEFINE l_str1         STRING   #No.MOD-580323
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 9 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 19
   END IF
   OPEN WINDOW abxr840_w AT p_row,p_col
        WITH FORM "abx/42f/abxr840" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
WHILE TRUE
   LET tm.g_yy = YEAR(TODAY)
   LET tm.yn   = "N"
   #FUN-6A0007...............begin
   LET tm.c ='Y'
   LET tm2.s1='2'
   LET tm2.s2='1'
   LET tm2.u1='N'
   LET tm2.u2='N'
 
   CONSTRUCT BY NAME tm.wc ON ima01,ima1916
 
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
         
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr840_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM         
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
  #input tm.g_yy,tm.yn without defaults from formonly.g_yy,formonly.yn
   INPUT BY NAME tm.g_yy,tm.c,tm.yn,tm2.s1,tm2.s2,tm2.u1,tm2.u2 WITHOUT DEFAULTS
 
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.u = tm2.u1[1,1],tm2.u2[1,1]
 
       AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[YNyn]' THEN
             NEXT FIELD c
          END IF
 
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
 
   #FUN-6A0007...............end
   after field yn
     if tm.yn not matches "[YyNn]" 
     then
 #No.MOD-580323 --start--                                                                                                           
         CALL cl_getmsg('mfg1601',g_lang) RETURNING l_str1                                                                          
         ERROR l_str1                                                                                                               
#         ERROR "請輸入Y/N"                                                                                                    
 #No.MOD-580323 --end--  
         next field yn 
     end if 
     ON ACTION locale
        CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      #FUN-6A0007...............begin
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg    
         CALL cl_cmdask()  
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      #FUN-6A0007...............end
 
   end input 
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr840_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM         
   END IF
   CALL cl_wait()
   CALL abxr840()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr840_w
END FUNCTION
 
FUNCTION abxr840()
   DEFINE l_name   LIKE type_file.chr20,      # External(Disk) file name       #No.FUN-680062   VARCHAR(20)
#       l_time          LIKE type_file.chr8       #No.FUN-6A0062
          l_sql    LIKE type_file.chr1000,    #No.FUN-680062 VARCHAR(1000)
          #l_za05   LIKE za_file.za05,         #No.FUN-680062 VARCHAR(40) #FUN-6A0007
          l_order   ARRAY[2] OF LIKE ima_file.ima01, #FUN-6A0007
          bwh      RECORD LIKE bwh_file.*    
   #FUN-6A0007...............begin
   DEFINE sr RECORD 
             order1 LIKE ima_file.ima01,
             order2 LIKE ima_file.ima01,
             l_tmp     LIKE bwh_file.bwh03,
             ima20     LIKE ima_file.ima20,
             bwh121    LIKE bwh_file.bwh12,
             bwh122    LIKE bwh_file.bwh12,
             l_ima1916 LIKE ima_file.ima1916
             END RECORD
   #FUN-6A0007...............end
#FUN-850089 add---START
DEFINE    x_ima25 LIKE ima_file.ima25,
          x_ima15 LIKE ima_file.ima15, 
          x_ima02 LIKE ima_file.ima02, 
          x_ima021 LIKE ima_file.ima021,   
          x_bxe02 LIKE bxe_file.bxe02,
          x_bxe03 LIKE bxe_file.bxe03
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   DEFINE l_bxz100  LIKE bxz_file.bxz100,#監管單位
          l_bxz102  LIKE bxz_file.bxz102,#保稅類型
          l_bxz101  LIKE bxz_file.bxz101 #海關廠監管編號
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #FUN-6A0007...............begin 
    #DECLARE abxr840_curs1 CURSOR FOR SELECT * FROM bwh_file 
    #WHERE bwh01 = tm.g_yy 
     LET l_sql = "SELECT bwh_file.*,ima1916 ",
                 "  FROM bwh_file,ima_file ",
                 " WHERE ",tm.wc clipped,
                 "   AND ima01 = bwh02 ",
                 "   AND bwh01 = ",tm.g_yy
 
    if tm.yn = 'Y' THEN
       let l_sql = l_sql clipped ," AND ima15='Y'  "
    end if
 
    PREPARE abxr840_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare1:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
       EXIT PROGRAM
    END IF
    DECLARE abxr840_curs1 CURSOR FOR abxr840_prepare1
 
    #FOREACH abxr840_curs1 INTO bwh.*
     FOREACH abxr840_curs1 INTO bwh.*,sr.l_ima1916
   #FUN-6A0007...............end
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
      #IF  tm.yn = "Y" AND bwh.bwh14 <=0        #MOD-BC0049 mark 
      #THEN                                     #MOD-BC0049 mark
      #     CONTINUE FOREACH                    #MOD-BC0049 mark
      #ELSE                                     #MOD-BC0049 mark
           #FUN-6A0007...............begin
            
           FOR g_i = 1 TO 2
              CASE 
                 WHEN tm.s[g_i,g_i] = '1'
                    LET l_order[g_i] = bwh.bwh02
                 WHEN tm.s[g_i,g_i] = '2'
                    LET l_order[g_i] = sr.l_ima1916
                 OTHERWISE
                    LET l_order[g_i]  = '-'
              END CASE
           END FOR
           LET sr.order1 = l_order[1]
           LET sr.order2 = l_order[2]
 
           #FUN-6A0007...............end
 
           message g_x[11] CLIPPED,bwh.bwh02
           CALL ui.Interface.refresh()
           #FUN-6A0007...............begin
           LET sr.ima20 = 0
           LET sr.l_tmp = 0
           LET sr.bwh121= 0
           LET sr.bwh122= 0
           SELECT ima20 INTO sr.ima20 
           FROM ima_file WHERE ima01 = bwh.bwh02
           IF cl_null(sr.ima20) THEN LET sr.ima20 = 0 END IF 
 
          
           IF cl_null(bwh.bwh12) THEN LET bwh.bwh12 = 0 END IF 
           IF bwh.bwh12>=0 THEN
              LET sr.bwh121 = bwh.bwh12
              LET sr.bwh122 = NULL
           ELSE 
              LET sr.bwh122 = bwh.bwh12
              LET sr.bwh121 = NULL
           END IF
 
           IF cl_null(bwh.bwh03) THEN LET bwh.bwh03 = 0 END IF
           IF cl_null(bwh.bwh04) THEN LET bwh.bwh04 = 0 END IF
           IF cl_null(bwh.bwh05) THEN LET bwh.bwh05 = 0 END IF
           IF cl_null(bwh.bwh06) THEN LET bwh.bwh06 = 0 END IF
           IF cl_null(bwh.bwh07) THEN LET bwh.bwh07 = 0 END IF
           IF cl_null(bwh.bwh08) THEN LET bwh.bwh08 = 0 END IF
           IF cl_null(bwh.bwh09) THEN LET bwh.bwh09 = 0 END IF
           IF cl_null(bwh.bwh10) THEN LET bwh.bwh10 = 0 END IF
 
           LET sr.l_tmp = bwh.bwh03+bwh.bwh04+bwh.bwh05+bwh.bwh06-bwh.bwh07-bwh.bwh08-bwh.bwh09-bwh.bwh10
           #FUN-6A0007...............end
       #END IF                                #MOD-BC0049 mark
      #---FUN-850089 add---START
           SELECT ima02,ima021,ima25,ima15 INTO x_ima02,x_ima021,x_ima25,x_ima15
           from ima_file where ima01 = bwh.bwh02
       LET x_bxe02 = NULL
       LET x_bxe03 = NULL
           SELECT bxe02,bxe03 INTO x_bxe02,x_bxe03
           FROM bxe_file WHERE bxe01 = sr.l_ima1916
       EXECUTE insert_prep USING   bwh.bwh02,  x_ima02,    x_ima021,
                                     x_ima25,bwh.bwh04,   bwh.bwh06, bwh.bwh03, 
                                   bwh.bwh05,bwh.bwh07,   bwh.bwh08, bwh.bwh09,
                                   bwh.bwh10, sr.l_tmp,   bwh.bwh11, sr.bwh121,
                                   sr.bwh122, sr.ima20,   bwh.bwh13, bwh.bwh14,
                                   bwh.bwh15,bwh.bwh16,sr.l_ima1916, bwh.bwh01,
                                     x_bxe02,  x_bxe03,   bwh.bwh12 
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
     END FOREACH
 
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
 
    SELECT bxz100,bxz102,bxz101
      INTO l_bxz100,l_bxz102,l_bxz101 FROM bxz_file
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bwh01,'sr.order1','sr.order2'"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima01,ima1916')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
                 #P1       #P2      #P3     #P4       #P5       #P6
    LET g_str = g_str,";",tm.s,";",tm.u,";",tm.c,";",tm.yn,";",tm.g_yy,";",
                  #P7          #P8          #P9
                l_bxz100,";",l_bxz102,";",l_bxz101,";",
                #p10
                YEAR(g_pdate)-1911 USING '<<<;',
                #p11
                MONTH(g_pdate) USING '&&;',
                #p12
                DAY(g_pdate) USING '&&'
 
    CALL cl_prt_cs3('abxr840','abxr840',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---
END FUNCTION
#No.FUN-870144

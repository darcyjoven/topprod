# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: abxr603.4gl
# Descriptions...: 保稅原料結算報告表(園區用)
# Date & Author..: 2012/01/05 FUN-BC0115 By Sakura
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              g_yy  LIKE type_file.num5,
              wc      STRING,
              a       LIKE type_file.chr1,
              c       LIKE type_file.chr1,
              u       LIKE type_file.chr2,
              s       LIKE type_file.chr2,
              yn    LIKE type_file.chr1
              END RECORD,
          g_count       LIKE type_file.num5,
          l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用
 
DEFINE   g_i     LIKE type_file.num5    #count/index for any purpose
DEFINE   l_table      STRING,
         g_sql        STRING,
         g_str        STRING
 
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
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bwh02.bwh_file.bwh02,",         #料件編號         
              "x_ima02.ima_file.ima02,",       #品名
              "x_ima021.ima_file.ima021,",     #規格
              "x_ima25.ima_file.ima25,",       #單位
              "bwh04.bwh_file.bwh04,",         #期初非保稅結存數
              "bwh06.bwh_file.bwh06,",         #上期非保稅進貨數
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
              "bwh01.bwh_file.bwh01,",         #年度
              "bwh12.bwh_file.bwh12 "          #本期盤盈虧數
                                               #25 items
  LET l_table = cl_prt_temptable('abxr603',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   CALL abxr603_tm(0,0)             # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION abxr603_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,
          l_cmd         LIKE type_file.chr1000
   DEFINE l_str1         STRING
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 9 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 19
   END IF
   OPEN WINDOW abxr603_w AT p_row,p_col
        WITH FORM "abx/42f/abxr603" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
WHILE TRUE
   LET tm.g_yy = YEAR(TODAY)
   LET tm.yn   = "N"
 
   CONSTRUCT BY NAME tm.wc ON ima01
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
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

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr603_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM         
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF

   INPUT BY NAME tm.g_yy,tm.yn WITHOUT DEFAULTS
          
       AFTER FIELD yn
          IF tm.yn NOT MATCHES "[YyNn]" THEN
             CALL cl_getmsg('mfg1601',g_lang) RETURNING l_str1                                                                          
             ERROR l_str1 #ERROR "請輸入Y/N"                                                                                                    
             NEXT FIELD yn 
          END IF  
     ON ACTION locale
        CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

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
 
   end input 
 
   IF INT_FLAG 
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr603_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM         
   END IF
   CALL cl_wait()
   CALL abxr603()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr603_w
END FUNCTION
 
FUNCTION abxr603()
   DEFINE l_name   LIKE type_file.chr20,      # External(Disk) file name
          l_sql    STRING,
          l_order   ARRAY[2] OF LIKE ima_file.ima01,
          bwh      RECORD LIKE bwh_file.*
   DEFINE sr RECORD
             l_tmp     LIKE bwh_file.bwh03,
             ima20     LIKE ima_file.ima20,
             bwh121    LIKE bwh_file.bwh12,
             bwh122    LIKE bwh_file.bwh12
             END RECORD
             
DEFINE    x_ima25 LIKE ima_file.ima25,
          x_ima15 LIKE ima_file.ima15, 
          x_ima02 LIKE ima_file.ima02, 
          x_ima021 LIKE ima_file.ima021,
          l_bwh06  LIKE bwh_file.bwh06
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   DEFINE l_bxz100  LIKE bxz_file.bxz100,#監管單位
          l_bxz102  LIKE bxz_file.bxz102,#保稅類型
          l_bxz101  LIKE bxz_file.bxz101 #海關廠監管編號
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
     LET l_sql = "SELECT bwh_file.* ",
                 "  FROM bwh_file,ima_file ",
                 " WHERE ",tm.wc clipped,
                 "   AND ima01 = bwh02 ",
                 "   AND bwh01 = ",tm.g_yy
 
    if tm.yn = 'Y' THEN
       let l_sql = l_sql clipped ," AND ima15='Y'  "
    end if
 
    PREPARE abxr603_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare1:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE abxr603_curs1 CURSOR FOR abxr603_prepare1

     FOREACH abxr603_curs1 INTO bwh.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
           
           message g_x[11] CLIPPED,bwh.bwh02
           CALL ui.Interface.refresh()
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
           #上年度非保稅進貨數
           SELECT bwh06 INTO l_bwh06
           FROM bwh_file WHERE  bwh01 = (bwh.bwh01-1) AND bwh02 = bwh.bwh02
 
           IF cl_null(bwh.bwh03) THEN LET bwh.bwh03 = 0 END IF
           IF cl_null(bwh.bwh04) THEN LET bwh.bwh04 = 0 END IF
           IF cl_null(bwh.bwh05) THEN LET bwh.bwh05 = 0 END IF
           IF cl_null(bwh.bwh06) THEN LET bwh.bwh06 = 0 END IF
           IF cl_null(l_bwh06)   THEN LET l_bwh06   = 0 END IF
           IF cl_null(bwh.bwh07) THEN LET bwh.bwh07 = 0 END IF
           IF cl_null(bwh.bwh08) THEN LET bwh.bwh08 = 0 END IF
           IF cl_null(bwh.bwh09) THEN LET bwh.bwh09 = 0 END IF
           IF cl_null(bwh.bwh10) THEN LET bwh.bwh10 = 0 END IF
 
           LET sr.l_tmp = bwh.bwh03+bwh.bwh04+bwh.bwh05+bwh.bwh06-bwh.bwh07-bwh.bwh08-bwh.bwh09-bwh.bwh10

           SELECT ima02,ima021,ima25,ima15 INTO x_ima02,x_ima021,x_ima25,x_ima15
           from ima_file where ima01 = bwh.bwh02
       EXECUTE insert_prep USING   bwh.bwh02,  x_ima02,   x_ima021,
                                     x_ima25,bwh.bwh04,   l_bwh06, bwh.bwh03, 
                                   bwh.bwh05,bwh.bwh07,   bwh.bwh08, bwh.bwh09,
                                   bwh.bwh10, sr.l_tmp,   bwh.bwh11, sr.bwh121,
                                   sr.bwh122, sr.ima20,   bwh.bwh13, bwh.bwh14,
                                   bwh.bwh15,bwh.bwh16, bwh.bwh01,
                                   bwh.bwh12 
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
     END FOREACH

    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
 
    SELECT bxz100,bxz102,bxz101
      INTO l_bxz100,l_bxz102,l_bxz101 FROM bxz_file
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bwh01 "
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ima01')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
                        
    LET g_str = g_str,";",    #P1
                 tm.yn,";",   #P2
                 tm.g_yy,";", #P3
                l_bxz100,";", #P4          
                l_bxz102,";", #P5
                l_bxz101,";", #P6
                #p7
                YEAR(g_pdate)-1911 USING '<<<;',
                #p8
                MONTH(g_pdate) USING '&&;',
                #p9
                DAY(g_pdate) USING '&&'
 
    CALL cl_prt_cs3('abxr603','abxr603',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
#FUN-BC0115

# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimr881.4gl
# Descriptions...: 批/序號初盤差異分析表
# Input parameter: 
# Return code....: 
# Date & Author..: 08/05/28 #FUN-850151 By jamie
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40038 10/04/20 By houlia 追單MOD-9B0013
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-850151 ref.aimr820
DEFINE tm  RECORD                           # Print condition RECORD
           wc      STRING,                  # Where Condition
           diff    LIKE type_file.chr1,     #
           s       LIKE type_file.chr3,     # Order by sequence  
           t       LIKE type_file.chr3,     # Eject sw  
           more    LIKE type_file.chr1      # Input more condition(Y/N)  
           END RECORD
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE g_q_point       LIKE zaa_file.zaa08     #                      
DEFINE g_star          LIKE zaa_file.zaa08     #                      
DEFINE l_orderA      ARRAY[3] OF LIKE imm_file.imm13  
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET g_sql = "pias01.pias_file.pias01,",
               "pias02.pias_file.pias02,",
               "pias03.pias_file.pias03,",
               "pias04.pias_file.pias04,",
               "pias05.pias_file.pias05,",
               "pias08.pias_file.pias08,",
               "pias30.pias_file.pias30,",
               "pias31.pias_file.pias31,",
               "pias34.pias_file.pias34,",
               "pias35.pias_file.pias35,",
               "pias40.pias_file.pias40,",
               "pias41.pias_file.pias41,",
               "pias44.pias_file.pias44,",
               "pias45.pias_file.pias45,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "gen02_1.gen_file.gen02,",
               "gen02_2.gen_file.gen02,",
               "gen02_pias31.gen_file.gen02,",
               "gen02_pias41.gen_file.gen02,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('aimr881',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,              #CHI-A40038
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    #CHI-A40038
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.diff  = ARG_VAL(8)      
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN     # If background job sw is off
      CALL r881_tm(0,0)                          # Input print condition
   ELSE 
      CALL r881()                                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r881_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01                   
DEFINE p_row,p_col    LIKE type_file.num5,                           
       l_cmd          LIKE type_file.chr1000                           
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18 
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r881_w AT p_row,p_col
        WITH FORM "aim/42f/aimr881" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.diff = 'N'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pias01,pias03,pias04,pias05,pias02,pias31,pias41
 
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(pias02) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO pias02                                                                                 
            NEXT FIELD pias02                                                                                                     
         END IF                                                            
 
      ON ACTION locale
         CALL cl_show_fld_cont()  
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
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r881_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.diff, tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3 ,tm.more 
         WITHOUT DEFAULTS 
 
        BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD diff 
         IF tm.diff IS NULL OR tm.diff NOT MATCHES'[YNyn]'
         THEN NEXT FIELD diff
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r881_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr881'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr881','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.diff CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",                         
                         " '",g_rep_clas CLIPPED,"'",                         
                         " '",g_template CLIPPED,"'",                         
                         " '",g_rpt_name CLIPPED,"'"                          
         CALL cl_cmdat('aimr881',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r881_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r881()
   ERROR ""
END WHILE
   CLOSE WINDOW r881_w
END FUNCTION
 
FUNCTION r881()
   DEFINE l_name    LIKE type_file.chr20,              # External(Disk) file name 
          l_sql     STRING,                            # RDSQL STATEMENT   
          l_chr     LIKE type_file.chr1,                                     
          l_za05    LIKE za_file.za05,                                        
          l_order   ARRAY[5] OF LIKE ima_file.ima01,                                              
          sr        RECORD order1 LIKE ima_file.ima01,                                            
                           order2 LIKE ima_file.ima01,                                            
                           order3 LIKE ima_file.ima01,                                            
                           pias01  LIKE pias_file.pias01,
                           pias02  LIKE pias_file.pias02,
                           pias03  LIKE pias_file.pias03,
                           pias04  LIKE pias_file.pias04,
                           pias05  LIKE pias_file.pias05,
                           pias08  LIKE pias_file.pias08,
                           pias30  LIKE pias_file.pias30,
                           pias31  LIKE pias_file.pias31,
                           pias34  LIKE pias_file.pias34,
                           pias35  LIKE pias_file.pias35,
                           pias40  LIKE pias_file.pias40,
                           pias41  LIKE pias_file.pias41,
                           pias44  LIKE pias_file.pias44,
                           pias45  LIKE pias_file.pias45,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           gen02_1 LIKE gen_file.gen02,
                           gen02_2 LIKE gen_file.gen02,
                           gen02_pias31 LIKE gen_file.gen02,
                           gen02_pias41 LIKE gen_file.gen02
                        END RECORD
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr881'
     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
       FROM azi_file WHERE azi01 = g_aza.aza17
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT '','','',",
                 "pias01, pias02, pias03, pias04,",
                 "pias05, pias08, pias30, pias31, pias34, pias35,",
                 "pias40, pias41, pias44, pias45, ima02,ima021,",
                 "gen02,' ',' ',' ' ",
                 "  FROM pias_file ,OUTER gen_file ,OUTER ima_file",
                 " WHERE pias_file.pias34 = gen_file.gen01 AND pias_file.pias02=ima_file.ima01",
                 "  AND (pias02 IS NOT NULL AND pias02 != ' ') ",
                 "  AND ( (pias30 IS NOT NULL ) ",
                 "        OR (pias40 IS NOT NULL )) ",
                 "   AND ",tm.wc
 
     #初盤資料輸入員(一)與資料輸入員(二)
     IF tm.diff ='N' THEN 
        LET l_sql = l_sql clipped," AND (pias30 != pias40 OR ",
     #----------------- CHI-A40038------modify
                             #" pias30 IS NULL OR pias30 = ' ' OR",
                             #" pias40 IS NULL OR pias40 = ' ' )"
                              " pias30 IS NULL OR",
                              " pias40 IS NULL)"
     #----------------- CHI-A40038------end
     END IF
 
     PREPARE r881_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r881_curs1 CURSOR FOR r881_prepare1
 
     FOR g_i = 1 TO 80 LET g_q_point[g_i,g_i] = '?' END FOR
     FOR g_i = 1 TO 80 LET g_star[g_i,g_i] = '*' END FOR
 
     LET g_pageno = 0
     FOREACH r881_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pias01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pias03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pias04
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pias05
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pias02
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.pias31
               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.pias41
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       SELECT gen02 INTO sr.gen02_2 FROM gen_file WHERE gen01 = sr.pias44
       SELECT gen02 INTO sr.gen02_pias31 FROM gen_file WHERE gen01 = sr.pias31
       SELECT gen02 INTO sr.gen02_pias41 FROM gen_file WHERE gen01 = sr.pias41
 
       EXECUTE insert_prep USING
           sr.pias01,sr.pias02,sr.pias03,sr.pias04,sr.pias05,sr.pias08,sr.pias30,
           sr.pias31,sr.pias34,sr.pias35,sr.pias40,sr.pias41,sr.pias44,sr.pias45,
           sr.ima02,sr.ima021,sr.gen02_1,sr.gen02_2,sr.gen02_pias31,
           sr.gen02_pias41,g_azi03,g_azi04,g_azi05    
          
     END FOREACH
  
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pias01,pias03,pias04,pias05,pias02,pias31,pias41')
          RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t
     CALL cl_prt_cs3('aimr881','aimr881',l_sql,g_str)
 
END FUNCTION
 

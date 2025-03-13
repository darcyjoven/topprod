# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimr884.4gl
# Descriptions...: 盤點資料清單－現有庫存
# Input parameter: 
# Return code....: 
# Date & Author..: 08/05/28 #FUN-850151 By jamie
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-B50008 11/07/07 By Summer temptable欄位名稱不符
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-850151 ref.aimr823
 
DEFINE tm     RECORD                           # Print condition RECORD
              wc   STRING,                     # Where Condition 
              data     LIKE type_file.chr20,                           
              choice   LIKE type_file.chr1,                          
              user     LIKE type_file.chr1,                          
              type     LIKE type_file.chr1,                          
              tot      LIKE type_file.chr1,                          
              s        LIKE type_file.chr3,    # Order by sequence
              t        LIKE type_file.chr3,    # Eject sw  
              more     LIKE type_file.chr1     # Input more condition(Y/N)  
              END RECORD
 
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose 
DEFINE g_q_point       LIKE zaa_file.zaa08,    
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13   
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
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
              #"pias09.pias_file.pias09,",#CHI-B50008 mark    
               "pias10.pias_file.pias10,", 
               "l_piaa10.piaa_file.piaa10,", #CHI-B50008 add
               "count.pias_file.pias30,",                                      
               "l_piaa09.piaa_file.piaa09,",  
               "l_count1.piaa_file.piaa30,",                                        
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                         
               "ima25.ima_file.ima25,",
               "flag.type_file.chr1"                                           
                                                        
   LET l_table = cl_prt_temptable('aimr884',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "pias01.pias_file.pias01,", 
              #CHI-B50008 mod --start--
              #"l_piaa09.piaa_file.piaa09,",  
              #"l_count1.piaa_file.piaa30"    
               "piaa09.piaa_file.piaa09,",  
               "piaa30.piaa_file.piaa30"    
              #CHI-B50008 mod --end--
   LET l_table1 = cl_prt_temptable('aimr8841',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                    
 
   LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.data  = ARG_VAL(8)
   LET tm.choice= ARG_VAL(9)
   LET tm.user  = ARG_VAL(10)
   LET tm.type  = ARG_VAL(11)
   LET tm.tot   = ARG_VAL(12)
   LET tm.s     = ARG_VAL(13)
   LET tm.t     = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18) 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r884_tm(0,0)              # Input print condition
      ELSE CALL r884()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION r884_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01                   
   DEFINE p_row,p_col    LIKE type_file.num5,                           
          l_cmd          LIKE type_file.chr1000                           
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 17 
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r884_w AT p_row,p_col
        WITH FORM "aim/42f/aimr884" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.choice= '1'
   LET tm.user  = '1'
   LET tm.type  = 'N'
   LET tm.tot   = 'N'
   LET tm.s     = '1'
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
   CONSTRUCT BY NAME tm.wc ON pias02,pias03,pias04,pias05,pias01
 
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
 
     #jamie
     #PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
     #                 '-',l_orderA[2] CLIPPED,'-',l_orderA[3] CLIPPED 
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
      LET INT_FLAG = 0 CLOSE WINDOW r884_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.data,tm.choice,tm.user,tm.type,tm.tot,
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more 
                 WITHOUT DEFAULTS 
 
      BEFORE INPUT
        CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD choice
         IF tm.choice IS NULL OR tm.choice NOT MATCHES'[123]'
         THEN NEXT FIELD choice
         END IF
 
      AFTER FIELD user  
         IF tm.user   IS NULL OR tm.user   NOT MATCHES'[12]'
         THEN NEXT FIELD user  
         END IF
 
      AFTER FIELD type  
         IF tm.type   IS NULL OR tm.type   NOT MATCHES'[YN]'
         THEN NEXT FIELD type  
         END IF
 
      AFTER FIELD tot   
         IF tm.tot   IS NULL OR tm.tot   NOT MATCHES'[YN]'
         THEN NEXT FIELD tot   
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
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
   
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r884_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file            #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr884'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr884','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,                  #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.data   CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.user   CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",                         
                         " '",tm.tot CLIPPED,"'",                          
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",                         
                         " '",g_rep_clas CLIPPED,"'",                         
                         " '",g_template CLIPPED,"'",                         
                         " '",g_rpt_name CLIPPED,"'"                          
         CALL cl_cmdat('aimr884',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r884_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r884()
   ERROR ""
END WHILE
   CLOSE WINDOW r884_w
END FUNCTION
 
FUNCTION r884()
   DEFINE l_name    LIKE type_file.chr20,            # External(Disk) file name  
          l_sql     STRING,                          # RDSQL STATEMENT  
          l_cnt     LIKE type_file.num5,                           
          l_chr     LIKE type_file.chr1,                                   
          l_za05    LIKE za_file.za05,                                      
          l_order   ARRAY[5] OF LIKE ima_file.ima01,                                            
          sr        RECORD 
                    order1 LIKE ima_file.ima01,                                              
                    order2 LIKE ima_file.ima01,                                              
                    order3 LIKE ima_file.ima01,                                              
                    pias01  LIKE pias_file.pias01,   #標籤號碼
                    pias02  LIKE pias_file.pias02,   #料件編號
                    pias03  LIKE pias_file.pias03,   #倉庫
                    pias04  LIKE pias_file.pias04,   #儲位
                    pias05  LIKE pias_file.pias05,   #批號
                    pias09  LIKE pias_file.pias09,   #單位
                    pias10  LIKE pias_file.pias10,   #factor
                    pias30  LIKE pias_file.pias30,   #初盤量(一)
                    pias40  LIKE pias_file.pias40,   #初盤量(二)
                    pias50  LIKE pias_file.pias50,   #複盤量(一)
                    pias60  LIKE pias_file.pias60,   #複盤量(二)
                    ima02  LIKE ima_file.ima02,      #品名規格
                    ima021 LIKE ima_file.ima021,     #品名規格
                    ima25  LIKE ima_file.ima25,      #庫存單位
                    count  LIKE pias_file.pias30,
                    flag   LIKE type_file.chr1    
                    END RECORD                    
  #CHI-B50008 mark --start--
  #DEFINE          l_piaa09  LIKE pias_file.pias09, 
  #                l_piaa30  LIKE pias_file.pias30,  
  #                l_piaa40  LIKE pias_file.pias40, 
  #                l_piaa50  LIKE pias_file.pias50,  
  #                l_piaa60  LIKE pias_file.pias60, 
  #CHI-B50008 mark --end--
  #CHI-B50008 add --start--
   DEFINE          l_piaa09  LIKE piaa_file.piaa09,  
                   l_piaa10  LIKE piaa_file.piaa10, 
                   l_piaa30  LIKE piaa_file.piaa30,  
                   l_piaa40  LIKE piaa_file.piaa40, 
                   l_piaa50  LIKE piaa_file.piaa50,  
                   l_piaa60  LIKE piaa_file.piaa60, 
  #CHI-B50008 add --end--
                   l_count1  LIKE  pias_file.pias30   
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM                         
   END IF  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
               " VALUES(?,?,?) "      
   PREPARE insert_prep1 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM                         
   END IF  
     CALL cl_del_data(l_table)     
     CALL cl_del_data(l_table1)    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    	
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT '','','',",
                 "pias01, pias02, pias03, pias04,",
                 "pias05, pias09, pias10, pias30, pias40,",
                 "pias50, pias60, ima02, ima021,ima25, '','Y'",
                 "  FROM pias_file ,OUTER ima_file",
                 " WHERE pias_file.pias02=ima_file.ima01",
                 "   AND pias02 IS NOT NULL ",
                 "   AND ",tm.wc
     IF tm.type ='N'
     THEN  CASE tm.choice    
           WHEN  '1'  IF tm.user = '1' THEN 
                         LET l_sql =l_sql clipped,  
                                    "AND pias30 IS NOT NULL "
                      ELSE 
                         LET l_sql =l_sql clipped,
                                    "AND pias40 IS NOT NULL "
                      END IF
           WHEN  '2'  IF tm.user = '1' THEN 
                         LET l_sql =l_sql clipped,
                                    "AND pias50 IS NOT NULL "
                      ELSE 
                         LET l_sql =l_sql clipped,
                                    "AND pias60 IS NOT NULL "
                      END IF
           WHEN  '3' LET l_sql = l_sql clipped,
                                 " AND pias19='Y'"   #已過帳
           OTHERWISE EXIT CASE
           END CASE
     END IF
     PREPARE r884_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  
        EXIT PROGRAM 
           
     END IF
     DECLARE r884_curs1 CURSOR FOR r884_prepare1
 
     IF g_sma.sma115 = "Y" THEN
         LET l_name = 'aimr884'
  
     ELSE
         LET l_name = 'aimr884_1'
 
     END IF
 
     FOREACH r884_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF tm.user = '1' THEN 
          CASE 
            WHEN tm.choice = '1'
                 LET sr.count = sr.pias30
            WHEN tm.choice = '2'
                 LET sr.count = sr.pias50
            WHEN tm.choice = '3'
                 IF sr.pias50 IS NULL OR sr.pias50 = ' ' THEN  
                    LET sr.count = sr.pias30
                 ELSE 
                    LET sr.count = sr.pias50
                 END IF
             OTHERWISE EXIT CASE
          END CASE
       ELSE 
          CASE
            WHEN tm.choice ='1'
                 LET sr.count = sr.pias40
            WHEN tm.choice ='2'
                 LET sr.count = sr.pias60
            WHEN tm.choice ='3'
                 IF sr.pias50 IS NULL OR sr.pias50 = ' ' THEN 
                    LET sr.count = sr.pias30
                 ELSE 
                    LET sr.count = sr.pias50
                 END IF
            OTHERWISE EXIT CASE
          END CASE
       END IF
       IF sr.count IS NULL THEN LET sr.count = 0 LET sr.flag = 'N' END IF
       IF sr.pias10 IS NULL THEN LET sr.pias10 = 1 END IF
       IF g_sma.sma115='Y' THEN
             LET l_cnt = 0
             LET l_sql = "SELECT piaa09,piaa10,piaa30,piaa40,piaa50,piaa60 ", #CHI-B50008 add piaa10
                         "  FROM piaa_file ",
                         " WHERE piaa01= '",sr.pias01,"'"
 
             PREPARE r884_piaa_p FROM l_sql
             IF SQLCA.sqlcode != 0 THEN 
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time  
                EXIT PROGRAM 
             END IF
 
             DECLARE r884_piaa_c CURSOR FOR r884_piaa_p
             FOREACH r884_piaa_c INTO l_piaa09,l_piaa10,l_piaa30,l_piaa40,l_piaa50,l_piaa60 #CHI-B50008 add l_piaa10
             IF SQLCA.sqlcode != 0 THEN 
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
             END IF
             LET l_cnt = l_cnt + 1
       
             IF tm.user = '1' THEN 
                CASE 
                  WHEN tm.choice = '1'
                       LET l_count1 = l_piaa30
                  WHEN tm.choice = '2'
                       LET l_count1 = l_piaa50
                  WHEN tm.choice = '3'
                       IF l_piaa50 IS NULL OR l_piaa50 = ' ' THEN 
                          LET l_count1 = l_piaa30
                       ELSE 
                          LET l_count1 = l_piaa50
                       END IF
                  OTHERWISE EXIT CASE
                END CASE
             ELSE
                CASE
                  WHEN tm.choice ='1'
                       LET l_count1 = l_piaa40
                  WHEN tm.choice ='2'
                       LET l_count1 = l_piaa60
                  WHEN tm.choice ='3'
                       IF l_piaa50 IS NULL OR l_piaa50 = ' ' THEN 
                          LET l_count1 = l_piaa30
                       ELSE 
                          LET l_count1 = l_piaa50
                       END IF
                  OTHERWISE EXIT CASE
                END CASE
             END IF
             EXECUTE insert_prep1 USING  sr.pias01,l_piaa09,l_count1
             END FOREACH
       END IF
 
       EXECUTE insert_prep USING sr.pias01,sr.pias02,sr.pias03,sr.pias04,
                                #sr.pias05,sr.pias09,sr.pias10,sr.count, #CHI-B50008 mark
                                 sr.pias05,sr.pias10,l_piaa10,sr.count,  #CHI-B50008
                                 l_piaa09, l_count1, sr.ima02, sr.ima021,
                                 sr.ima25, sr.flag
     END FOREACH
 
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'pias02,pias03,pias04,pias05,pias01')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc,";",tm.data,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                      tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                      tm.tot,";",g_q_point,";",l_cnt
                                                                          
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",
                 "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED  
     
     CALL cl_prt_cs3('aimr884',l_name,l_sql,g_str) 
END FUNCTION

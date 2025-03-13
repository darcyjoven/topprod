# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg100.4gl
# Descriptions...: 產品資料表
# Date & Author..: FUN-A60075 10/06/24 By sunchenxu
# Modify.........: TQC-B30087 11/03/09 By lilingyu 抓取報表資料的sql語句錯誤 
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: NO.FUN-BA0061 11/10/17 By qirl  明細CR報表轉GR
# Modify.........: No.FUN-C50005 12/05/15 By qirl GR程式優化

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,    
              s       LIKE type_file.chr3, # Order by sequence
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING


###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr20,
    order2 LIKE type_file.chr20,
    order3 LIKE type_file.chr20,
    ima01 LIKE ima_file.ima01,
    ima02 LIKE ima_file.ima02,
    ima1004 LIKE ima_file.ima1004,
    ima1005 LIKE ima_file.ima1005,
    ima1006 LIKE ima_file.ima1006,
    ima1007 LIKE ima_file.ima1007,
    ima1008 LIKE ima_file.ima1008,
    ima1009 LIKE ima_file.ima1009,
    ima131  LIKE ima_file.ima131,
    oba02   LIKE oba_file.oba02,            # No.FUN-C50005 add
    ima130 LIKE ima_file.ima130,
    ima154 LIKE ima_file.ima154,
    ima127 LIKE ima_file.ima127,
    ima128 LIKE ima_file.ima128
END RECORD
###GENGRE###END


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "order1.type_file.chr20,",        
                "order2.type_file.chr20,",       
                "order3.type_file.chr20,",  
                "ima01.ima_file.ima01,",   
                "ima02.ima_file.ima02,",    
                "ima1004.ima_file.ima1004,",  
                "ima1005.ima_file.ima1005,",  
                "ima1006.ima_file.ima1006,",  
                "ima1007.ima_file.ima1007,",  
                "ima1008.ima_file.ima1008,",  
                "ima1009.ima_file.ima1009,",  
                "ima131.ima_file.ima131,",   
                "oba02.oba_file.oba02,",          # No.FUN-C50005 add
                "ima130.ima_file.ima130,",
                "ima154.ima_file.ima154,",
                "ima127.ima_file.ima127,",
                "ima128.ima_file.ima128"     
 
   LET l_table = cl_prt_temptable('artg100',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artg100_tm(0,0)        # Input print condition
      ELSE CALL artg100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
END MAIN

FUNCTION artg100_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg100_w AT p_row,p_col WITH FORM "art/42f/artg100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01,ima02,ima1004,ima1005,
                                 ima1006,ima1007,ima1008,ima1009,
                                 ima131

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima02
            END IF
            
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

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artg100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF
      
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm2.s1,tm2.s2,tm2.s3,tm.more 
      
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
            
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            
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
         LET INT_FLAG = 0 CLOSE WINDOW artg100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg100'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg100','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg100',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg100()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg100_w
END FUNCTION

FUNCTION artg100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,      
          l_order   ARRAY[5] OF LIKE type_file.chr20,       
          sr        RECORD 
                    order1   LIKE type_file.chr20,        
                    order2   LIKE type_file.chr20,       
                    order3   LIKE type_file.chr20,  
                    ima01    LIKE ima_file.ima01,    #產品編號
                    ima02    LIKE ima_file.ima02,    #品名
                    ima1004  LIKE ima_file.ima1004,  #品類
                    ima1005  LIKE ima_file.ima1005,  #品牌
                    ima1006  LIKE ima_file.ima1006,  #系列
                    ima1007  LIKE ima_file.ima1007,  #型別
                    ima1008  LIKE ima_file.ima1008,  #規格
                    ima1009  LIKE ima_file.ima1009,  #屬性
                    ima131   LIKE ima_file.ima131,   #產品分類碼
                    oba02    LIKE oba_file.oba02,  # No.FUN-C50005 add
                    ima130   LIKE ima_file.ima130,
                    ima154   LIKE ima_file.ima154,
                    ima127   LIKE ima_file.ima127,
                    ima128   LIKE ima_file.ima128          
                    END RECORD
                    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                "        ?, ?, ?, ?, ?, ?, ?)"            # No.FUN-C50005 add ?                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)            
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-BA0061--add--                                                                            
       CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
       EXIT PROGRAM                                                                                                                 
    END IF

    LET l_sql = "SELECT '','','',",
                " ima01,ima02,ima1004,ima1005,ima1006,",
#                " ima1007,ima1008,ima1009,ima131,ima130",   #TQC-B30087 
                 " ima1007,ima1008,ima1009,ima131,oba02,ima130,",  #TQC-B30087# No.FUN-C50005 add  oba02 
                " ima154,ima127,ima128",
                " FROM ima_file LEFT OUTER JOIN oba_file ON ima131 = oba01",       # No.FUN-C50005 add
                " WHERE ",tm.wc CLIPPED
    PREPARE artg100_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)  #FUN-BA0061
       EXIT PROGRAM
    END IF
    DECLARE artg100_curs1 CURSOR FOR artg100_prepare1

    FOREACH artg100_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima02
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima1004
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima1005
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ima1006
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ima1007
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.ima1008
              WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.ima1009
              WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.ima131
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR

      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]

      EXECUTE  insert_prep  USING  
      sr.order1,sr.order2,sr.order3,sr.ima01,sr.ima02,sr.ima1004,
      sr.ima1005,sr.ima1006,sr.ima1007,sr.ima1008,sr.ima1009,
      sr.ima131,sr.oba02,sr.ima130,sr.ima154,sr.ima127,sr.ima128          # No.FUN-C50005 add  oba02
   END FOREACH
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str = tm.wc
###GENGRE###   CALL cl_prt_cs3('artg100','artg100',l_sql,g_str) 
    CALL artg100_grdata()    ###GENGRE###
END FUNCTION
#FUN-A60075

###GENGRE###START
FUNCTION artg100_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg100")
        IF handler IS NOT NULL THEN
            START REPORT artg100_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3"
          
            DECLARE artg100_datacur1 CURSOR FROM l_sql
            FOREACH artg100_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg100_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg100_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg100_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_oba02  STRING                       # No.FUN-C50005 add
    
    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3

    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0061 add g_ptime,g_user_name
            PRINTX tm.*
            
        BEFORE GROUP OF sr1.order1
        BEFORE GROUP OF sr1.order2
        BEFORE GROUP OF sr1.order3   
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            LET l_oba02 = sr1.ima131,' ',sr1.oba02  # No.FUN-C50005 add
            PRINTX l_oba02                          # No.FUN-C50005 add 
            PRINTX sr1.*                            # No.FUN-C50005 add

        AFTER GROUP OF sr1.order1
        AFTER GROUP OF sr1.order2
        AFTER GROUP OF sr1.order3        
        ON LAST ROW

END REPORT
###GENGRE###END

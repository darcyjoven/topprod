# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aapr312.4gl
# Descriptions...: 應付款退單列印作業
# Date & Author..: No:FUN-B20020 11/02/14  By destiny
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10034 12/01/17 By zhuhao 簽核調整
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                             # Print condition RECORD                
           wc      LIKE type_file.chr1000,    # Where condition              
           h       LIKE type_file.chr1,       # 資料狀態(1.已確認 2.位確認 3.全部     
           more    LIKE type_file.chr1        # Input more condition(Y/N)             
           END RECORD
DEFINE g_i           LIKE type_file.num5      #count/index for any purpose            
DEFINE l_table       STRING                   #FUN-710086 add 
DEFINE l_table1      STRING                   #FUN-710086 add 
DEFINE l_table2      STRING                   #FUN-710086 add 
DEFINE l_table3      STRING                   #FUN-710086 add 
DEFINE g_sql         STRING                   #FUN-710086 add
DEFINE g_str         STRING                   #FUN-710086 add
DEFINE g_bookno1     LIKE aza_file.aza81      #FUN-730064
DEFINE g_bookno2     LIKE aza_file.aza82      #FUN-730064
DEFINE g_flag        LIKE type_file.chr1      #FUN-B20020 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 mark
 
   LET g_sql = "apf01.apf_file.apf01,",    
               "apf02.apf_file.apf02,",    
               "apf03.apf_file.apf03,",    
               "apf04.apf_file.apf04,",    
               "gen02.gen_file.gen02,",   
               "apf05.apf_file.apf05,",    
               "apf06.apf_file.apf06,",    
               "apf07.apf_file.apf07,",    
               "apf08f.apf_file.apf08f,",  
               "apf09f.apf_file.apf09f,",  
               "apf10f.apf_file.apf10f,",  
               "apf08.apf_file.apf08,",    
               "apf09.apf_file.apf09,",    
               "apf10.apf_file.apf10,",    
               "apf43.apf_file.apf43,",    
               "apf44.apf_file.apf44,",    
               "apf41.apf_file.apf41,",    
               "apfmksg.apf_file.apfmksg,",
               "apfprno.apf_file.apfprno,",
               "apf12.apf_file.apf12,",    
               "azi03_t.azi_file.azi03,",
               "azi04_t.azi_file.azi04,",
               "azi05_t.azi_file.azi05,",
               "azi03_g.azi_file.azi03,",
               "azi04_g.azi_file.azi04,",
               "azi05_g.azi_file.azi05,",                                  
               "sign_type.type_file.chr1, ", #簽核方式  #FUN-940041
               "sign_img.type_file.blob,",   #簽核圖檔  #FUN-940041 
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)  #FUN-940041
               "sign_str.type_file.chr1000"  #TQC-C10034 add
   LET l_table = cl_prt_temptable('aapr312',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF 
 
   #付款部份
   LET g_sql = "aph01.aph_file.aph01,",    
               "aph02.aph_file.aph02,",    
               "aph03.aph_file.aph03,",    
               "aph04.aph_file.aph04,",    
               "aph05.aph_file.aph05,",    
               "aph05f.aph_file.aph05f,",  
               "aph06.aph_file.aph06,",    
               "aph07.aph_file.aph07,",    
               "aph08.aph_file.aph08,",    
               "aph09.aph_file.aph09,",    
               "aph13.aph_file.aph13,",    
               "aph14.aph_file.aph14,",    
               "aag02.aag_file.aag02,",    
               "nma02.nma_file.nma02,",   
               "azi03_2.azi_file.azi03,",                 
               "azi04_2.azi_file.azi04,",                 
               "azi05_2.azi_file.azi05,",
               "azi07_2.azi_file.azi07,",   #MOD-720121                  
               "azi03_g.azi_file.azi03,",
               "azi04_g.azi_file.azi04,",
               "azi05_g.azi_file.azi05,",                                   
               "apw02.apw_file.apw02"   #MOD-840125
   LET l_table1 = cl_prt_temptable('aapr3121',g_sql) CLIPPED 
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
 
   #帳款部份
   LET g_sql = "apg01.apg_file.apg01,",      #MOD-7A0137 add
               "apg02.apg_file.apg02,",      #MOD-7A0137 add
               "apg03.apg_file.apg03,",      #MOD-7A0137 add
               "apg04.apg_file.apg04,",      
               "apg05f.apg_file.apg05f,",    #MOD-7A0137 add
               "apg05.apg_file.apg05,",      #MOD-7A0137 add
               "apa02.apa_file.apa02,",    
               "apa08.apa_file.apa08,",    
               "apa09.apa_file.apa09,",    
               "apa12.apa_file.apa12,",    
               "apa13.apa_file.apa13,",    
               "apa14.apa_file.apa14,",    
               "apa24.apa_file.apa24,",    
               "apa31.apa_file.apa31,",    
               "apa32.apa_file.apa32,",    
               "apa34.apa_file.apa34,",    
               "apa60.apa_file.apa60,",    
               "apa61.apa_file.apa61,",    
               "apb04.apb_file.apb04,",    
               "apb06.apb_file.apb06,",    
               "apb08.apb_file.apb08,",    
               "apb09.apb_file.apb09,",    
               "apb10.apb_file.apb10,",    
               "apb13.apb_file.apb13,",    
               "apb15.apb_file.apb15,",    
               "apb14.apb_file.apb14,",    
               "rvb05.rvb_file.rvb05,",    
               "apk03.apk_file.apk03,",  
               "apk05.apk_file.apk05,",  
               "apk06.apk_file.apk06,",  
               "apk07.apk_file.apk07,",  
               "apk08.apk_file.apk08,",  
               "azi03_1.azi_file.azi03,",
               "azi04_1.azi_file.azi04,",                 
               "azi05_1.azi_file.azi05,",     
               "azi03_t.azi_file.azi03,",   #MOD-7A0137 add                
               "azi04_t.azi_file.azi04,",   #MOD-7A0137 add                
               "azi05_t.azi_file.azi05,",   #MOD-7A0137 add
               "azi03_g.azi_file.azi03,",   #MOD-7A0137 add                
               "azi04_g.azi_file.azi04,",   #MOD-7A0137 add                
               "azi05_g.azi_file.azi05"     #MOD-7A0137 add
   LET l_table2 = cl_prt_temptable('aapr3122',g_sql) CLIPPED 
   IF l_table2 = -1 THEN EXIT PROGRAM END IF 
 
   LET g_sql = "apd01.apd_file.apd01,",    
               "apd02.apd_file.apd02,",   #MOD-7A0137 add    
               "apd03.apd_file.apd03"    
   LET l_table3 = cl_prt_temptable('aapr3123',g_sql) CLIPPED 
   IF l_table3 = -1 THEN EXIT PROGRAM END IF 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.h  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   
      THEN CALL r312_tm(0,0)        # Input print condition
      ELSE CALL r312()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r312_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,    #No.FUN-580031
       p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 18
   ELSE 
      LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW r312_w AT p_row,p_col WITH FORM "aap/42f/aapr312"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.h    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apf01,apf02,apf03,apf04,apf05,apf06
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()                   
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r312_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.h,tm.more
            WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD h
            IF tm.h NOT MATCHES '[123]'  OR cl_null(tm.h) THEN
               NEXT FIELD h
            END IF
            
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
    
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
         LET INT_FLAG = 0 CLOSE WINDOW r312_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='aapr312'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr312','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",     #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",     #No.FUN-570264
                        " '",g_template CLIPPED,"'",     #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr312',g_time,l_cmd)    #Execute cmd at later time
         END IF
         CLOSE WINDOW r312_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r312()
      ERROR ""
   END WHILE
   CLOSE WINDOW r312_w
END FUNCTION
 
FUNCTION r312()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF    LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
          sr1       RECORD apf01   LIKE apf_file.apf01, #付款單單頭檔
                           apf02   LIKE apf_file.apf02,
                           apf03   LIKE apf_file.apf03,
                           apf04   LIKE apf_file.apf04,
                           gen02   LIKE gen_file.gen02,   #no.TQC-750115
                           apf05   LIKE apf_file.apf05,
                           apf06   LIKE apf_file.apf06,
                           apf07   LIKE apf_file.apf07,
                           apf08f  LIKE apf_file.apf08f,
                           apf09f  LIKE apf_file.apf09f,
                           apf10f  LIKE apf_file.apf10f,
                           apf08   LIKE apf_file.apf08,
                           apf09   LIKE apf_file.apf09,
                           apf10   LIKE apf_file.apf10,
                           apf43   LIKE apf_file.apf43,
                           apf44   LIKE apf_file.apf44,
                           apf41   LIKE apf_file.apf41,
                           apfmksg LIKE apf_file.apfmksg,
                           apfprno LIKE apf_file.apfprno,
                           apf12   LIKE apf_file.apf12,
                           azi03_t LIKE azi_file.azi03,
                           azi04_t LIKE azi_file.azi04,
                           azi05_t LIKE azi_file.azi05,
                           azi03_g LIKE azi_file.azi03,
                           azi04_g LIKE azi_file.azi04,
                           azi05_g LIKE azi_file.azi05
                     END RECORD                                                                       #FUN-A10098 ----add
#                    END RECORD,                                                                      #FUN-A10098 ----mark
#          l_dbs_anm,l_dbs LIKE type_file.chr21       # No.FUN-690028 VARCHAR(20)  #No.FUN-7B0012     #FUN-A10098 ----mark

   DEFINE sr2       RECORD aph01  LIKE aph_file.aph01,
                           aph02  LIKE aph_file.aph02,
                           aph03  LIKE aph_file.aph03,
                           aph04  LIKE aph_file.aph04,
                           aph05  LIKE aph_file.aph05,   #MOD-810217
                           aph05f LIKE aph_file.aph05f,  #MOD-810217
                           aph06  LIKE aph_file.aph06,
                           aph07  LIKE aph_file.aph07,
                           aph08  LIKE aph_file.aph08,
                           aph09  LIKE aph_file.aph09,
                           aph13  LIKE aph_file.aph13,
                           aph14  LIKE aph_file.aph14,
                           aag02  LIKE aag_file.aag02,
                           nma02  LIKE nma_file.nma02,
                           azi03  LIKE azi_file.azi03,
                           azi04  LIKE azi_file.azi04,
                           azi05  LIKE azi_file.azi05,
                           azi07  LIKE azi_file.azi07   #MOD-720121
                    END RECORD,
          srapg     RECORD LIKE apg_file.*,             #MOD-7A0137 add
          sr12      RECORD apa02 LIKE apa_file.apa02,
                           apa08 LIKE apa_file.apa08,
                           apa09 LIKE apa_file.apa09, 
                           apa12 LIKE apa_file.apa12,
                           apa13 LIKE apa_file.apa13,
                           apa14 LIKE apa_file.apa14,
                           apa24 LIKE apa_file.apa24,
                           apa31 LIKE apa_file.apa31,
                           apa32 LIKE apa_file.apa32,
                           apa34 LIKE apa_file.apa34,
                           apa60 LIKE apa_file.apa60,
                           apa61 LIKE apa_file.apa61,
                           apb04 LIKE apb_file.apb04,   #應付帳款單身檔
                           apb06 LIKE apb_file.apb06,
                           apb08 LIKE apb_file.apb08,
                           apb09 LIKE apb_file.apb09,
                           apb10 LIKE apb_file.apb10,
                           apb13 LIKE apb_file.apb13,
                           apb15 LIKE apb_file.apb15,
                           apb14 LIKE apb_file.apb14,
                           rvb05 LIKE rvb_file.rvb05    #驗收單身檔
                    END RECORD,
      l_flag_apk    LIKE type_file.chr1,                #MOD-7A0137 add
      l_flag        LIKE type_file.chr1,        
      l_pritem      LIKE type_file.num5,        
      l_miscnum     LIKE type_file.num5,        
      l_amt         LIKE type_file.num20_6,     
      l_tot1f,l_tot2f,l_tot3f  LIKE type_file.num20_6,   
      l_tot1,l_tot2,l_tot3     LIKE type_file.num20_6, 
      l_apa08       LIKE apa_file.apa08,
      l_apk03       LIKE apk_file.apk03,
      l_apk05       LIKE apk_file.apk05,
      l_apk06       LIKE apk_file.apk06,
      l_apk07       LIKE apk_file.apk07,
      l_apk08       LIKE apk_file.apk08,
      l_apd         RECORD LIKE apd_file.*,    #備註檔   #MOD-7A0137 add
      l_azi03       LIKE azi_file.azi03,
      l_azi04       LIKE azi_file.azi04,
      l_azi05       LIKE azi_file.azi05,
      l_apw02       LIKE apw_file.apw02        #MOD-840125
 DEFINE l_img_blob     LIKE type_file.blob
 DEFINE l_sign_type    LIKE type_file.chr1   #CHI-A40017 add
 DEFINE l_sign_show    LIKE type_file.chr1   #CHI-A40017 add
#TQC-C10034--mark--begin
#DEFINE l_ii           INTEGER
#DEFINE l_key          RECORD                  #主鍵
#          v1          LIKE apf_file.apf01 
#          END RECORD
#TQC-C10034--mark--end
 DEFINE l_plant     LIKE type_file.chr10       #FUN-980020
 
 
   #清除CR暫存檔裡的資料
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?", #NO.TQC-750115 加上一個?   #MOD-7A0137 mod 31?->26?
               "        ,?,?,?,?)"  #FUN-940041 加三個?   #TQC-C10034 add ?
   PREPARE insert_prep FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM    
   END IF                           
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",   #MOD-7A0137 mod 
               "        ?,?)"  #MOD-720121                                #MOD-7A0137 mod 19?->21?   #MOD-840125
   PREPARE insert_prep1 FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM    
   END IF                           
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?)"   #TQC-750030 35個?->30個?   #MOD-7A0137 mod 30?->41?
   PREPARE insert_prep2 FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM    
   END IF                           
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED, 
               " VALUES(?,?,?)"   #MOD-7A0137 add 1?  
   PREPARE insert_prep3 FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep3:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM    
   END IF                           
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr312'
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
 
   LET l_sql = "SELECT ",
              #" apf01, apf02, apf03, apf04,  apf05,  apf06,",
               " apf01, apf02, apf03, apf04,  '',     apf05, apf06,",   #NO.TQC-750115
               " apf07, apf08f,apf09f,apf10f, apf08,  apf09, apf10,",
               " apf43, apf44, apf41, apfmksg,apfprno,apf12",
               " FROM apf_file",  # ,apg_file ",            #MOD-7A0137 mod
               " WHERE apf41 <> 'X' ",                     #MOD-7A0137 mod
               "   AND apf00 <> '11' ",   #MOD-810257
               "   AND apf00 ='32' ",
               "   AND ",tm.wc CLIPPED

   CASE WHEN tm.h ='1' LET l_sql = l_sql CLIPPED, " AND apf41 ='Y' "
        WHEN tm.h ='2' LET l_sql = l_sql CLIPPED, " AND apf41 ='N' "
        OTHERWISE EXIT CASE
   END CASE
   PREPARE r312_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r312_curs1 CURSOR FOR r312_prepare1
 
   #-->列印付款單的貸方
   LET l_plant = g_apz.apz04p                       #FUN-980020
   
        CALL s_get_bookno1(NULL,l_plant)     #FUN-980020
             RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag = '1' THEN
           CALL  cl_err(g_aza.aza01,'aoo-081',1)
        END IF
   LET l_sql = " SELECT aph_file.aph01, aph_file.aph02,",
               "        aph_file.aph03, aph_file.aph04,",  
               "        aph_file.aph05,aph_file.aph05f,",    #MOD-810217
               "        aph_file.aph06, aph_file.aph07,",
               "        aph_file.aph08, aph_file.aph09,", 
               "        aph_file.aph13, aph_file.aph14,", 
               "        aag02,nma02 ",
               "   FROM aph_file, OUTER aag_file, OUTER nma_file ",   
               " WHERE aph01 = ?  ",
               "   AND aph_file.aph04 = aag_file.aag01 AND aph_file.aph08 = nma_file.nma01 ",
               "   AND aag_file.aag00 = '",g_bookno1,"' "         
   PREPARE aph_prepare FROM l_sql
   DECLARE aph_curs CURSOR FOR aph_prepare
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('perpare aph_fiie error!',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
  #-->抓取帳款部份(apg_file)的資料
   LET l_sql = "SELECT * FROM apg_file WHERE apg01 = ?"
   PREPARE apg_prepare FROM l_sql
   DECLARE apg_curs CURSOR FOR apg_prepare
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('perpare apg_fiie error!',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   #-->額外備註列印
   LET l_sql = " SELECT * FROM apd_file ",
               "  WHERE apd01 =  ? "
   PREPARE apd_prepare FROM l_sql
   DECLARE apd_curs CURSOR FOR apd_prepare
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('perpare apd_fiie error!',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 

   FOREACH r312_curs1 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT FOREACH
      END IF

      SELECT gen02 INTO sr1.gen02
        FROM gen_file
       WHERE gen01 = sr1.apf04
      
      SELECT azi03,azi04,azi05
        INTO sr1.azi03_t,sr1.azi04_t,sr1.azi05_t
        FROM azi_file
       WHERE azi01=sr1.apf06
      LET sr1.azi03_g =g_azi03
      LET sr1.azi04_g =g_azi04
      LET sr1.azi05_g =g_azi05
   
      LET l_sign_type = ''    #CHI-A40017 add
      LET l_sign_show = 'N'   #CHI-A40017 add 
      EXECUTE insert_prep USING sr1.*
                         #,l_sign_type,l_img_blob,l_sign_show,""    #FUN-940041  #CHI-A40017 mod   #TQC-C10034 add ""
                           ,"",l_img_blob,"N",""    #FUN-940041
 
      #--->列印付款單貸方資料
      FOREACH aph_curs USING sr1.apf01 INTO sr2.*
         SELECT azi03,azi04,azi05,azi07   #MOD-720121
           INTO sr2.azi03,sr2.azi04,sr2.azi05,sr2.azi07    #MOD-720121
           FROM azi_file
          WHERE azi01=sr2.aph13
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err3("sel","azi_file",sr2.aph13,"",SQLCA.sqlcode,"","foreach apf_file error !",1)  
            EXIT FOREACH
         END IF
         IF sr2.aph03 NOT MATCHES "[123456789ABCZ]" THEN
            LET l_apw02 = ''
            SELECT apw02 INTO l_apw02 FROM apw_file
              WHERE apw01=sr2.aph03
            IF NOT cl_null(l_apw02) THEN
               LET l_apw02 = sr2.aph03 CLIPPED,'.',l_apw02 CLIPPED
            END IF
         END IF
         EXECUTE insert_prep1 USING sr2.*,g_azi03,g_azi04,g_azi05,l_apw02   #MOD-7A0137   #MOD-840125
      END FOREACH
 
      #以帳款部份的帳款編號去抓取各廠的帳款資料
      FOREACH apg_curs USING sr1.apf01 INTO srapg.*   
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach pag:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_flag_apk = 'N'        #MOD-7A0137 add
         INITIALIZE sr12.* TO NULL   #MOD-7A0137 add
         LET l_azi03 = '' LET l_azi04 = '' LET l_azi05 = ''
         LET g_plant_new = srapg.apg03   #MOD-7A0137
#         CALL s_getdbs()                                            #No.FUN-A10098 -----mark
         LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08 ",
#                   " FROM  ",g_dbs_new CLIPPED," apk_file ",        #No.FUN-A10098 -----mark
                   " FROM  apk_file ",                               #No.FUN-A10098 -----add 
                   " WHERE apk01 =  ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE r312_premisc FROM l_sql
         DECLARE r312_misc CURSOR FOR r312_premisc
 
         #-->各廠的請款資料讀取
         LET l_sql = " SELECT apa02, apa08, apa09, apa12, apa13,apa14,apa24,",
                     " apa31, apa32, apa34, apa60, apa61,",           
                     " apb04, apb06, apb08, apb09, apb10, apb13, apb15, apb14,",
                     " rvb05, azi03, azi04, azi05 ",
                     " FROM  apa_file LEFT OUTER JOIN apb_file LEFT OUTER JOIN  ",
                                             cl_get_target_table(srapg.apg03,'rvb_file'),
                     "                        ON apb05 = rvb_file.rvb02 ",
                     "           ON apa_file.apa01 = apb_file.apb01 ",
                     " LEFT OUTER JOIN  azi_file ON apa13=azi01",
                     " WHERE apa01 = '",srapg.apg04,"'", 
                     "   AND apa41 = 'Y' AND apa42='N'"
#FUN-A60056--mod--end
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,srapg.apg03) RETURNING l_sql   #FUN-A60056
         PREPARE r312_ppay FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
            EXIT PROGRAM
         END IF
         DECLARE r312_cpay CURSOR FOR r312_ppay
         FOREACH r312_cpay INTO sr12.*,l_azi03,l_azi04,l_azi05
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreac r312_cpay',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            LET l_flag_apk = "Y"   #MOD-7A0137 add
            LET l_amt = sr12.apa31 + sr12.apa32 - sr12.apa60 - sr12.apa61
            IF sr12.apa08 = 'MISC' THEN   #表示是多發票,需抓apk_file
               LET l_flag =0
               FOREACH r312_misc USING srapg.apg04   #MOD-7A0137
                            INTO l_apk03,l_apk05,l_apk06,l_apk07,l_apk08
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  EXECUTE insert_prep2 USING 
                     srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                     srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                     sr12.*,l_apk03,l_apk05,l_apk06,l_apk07,l_apk08,
                     l_azi03,l_azi04,l_azi05,
                     sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                     g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
                  LET l_flag =1
               END FOREACH
               IF l_flag =0 THEN
                  EXECUTE insert_prep2 USING  
                     srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
                     srapg.apg05f,srapg.apg05,                         #MOD-7A0137
                     sr12.*,'',g_today,'','','',
                     l_azi03,l_azi04,l_azi05,
                     sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
                     g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
               END IF
            ELSE   #表示是單張發票,直接抓帳款單頭發票資訊寫入
               EXECUTE insert_prep2 USING 
                  srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,
                  srapg.apg05f,srapg.apg05,
                  sr12.*,
                  sr12.apa08,sr12.apa09,sr12.apa34,sr12.apa32,sr12.apa31,
                  l_azi03,l_azi04,l_azi05,
                  sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,
                  g_azi03,g_azi04,g_azi05
            END IF
         END FOREACH
         IF l_flag_apk = 'N' THEN
            EXECUTE insert_prep2 USING
               srapg.apg01,srapg.apg02,srapg.apg03,srapg.apg04,  #MOD-7A0137
               srapg.apg05f,srapg.apg05,                         #MOD-7A0137
               sr12.*,'',g_today,'','','',
               l_azi03,l_azi04,l_azi05,
               sr1.azi03_t,sr1.azi04_t,sr1.azi05_t,              #MOD-7A0137 add
               g_azi03,g_azi04,g_azi05                           #MOD-7A0137 add
            LET l_flag_apk = 'Y'
         END IF
      END FOREACH   #MOD-7A0137 add
      CALL r312_upd(sr1.apf01)       #更改"列印次數"
   END FOREACH
 

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3,"|",     #CHI-A10034 取消l_table3後面的mark
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1          #CHI-A10034 add

   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apf01,apf02,apf03,apf04,apf05,apf06') RETURNING tm.wc     #MOD-810257
   ELSE
      LET tm.wc = ' '
   END IF
   LET g_str = '1',";",tm.wc,";",tm.wc         
 
  LET g_cr_table = l_table                 #主報表的temp table名稱
 #LET g_cr_gcx01 = "aapi103"               #單別維護程式   #TQC-C10034 mark
  LET g_cr_apr_key_f = "apf01"             #報表主鍵欄位名稱，用"|"隔開
#TQC-C10034---mark--begin
 #LET l_sql = "SELECT DISTINCT apf01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 #PREPARE key_pr FROM l_sql
 #DECLARE key_cs CURSOR FOR key_pr
 #LET l_ii = 1
 ##報表主鍵值
 #CALL g_cr_apr_key.clear()                #清空
 #FOREACH key_cs INTO l_key.*
 #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
 #   LET l_ii = l_ii + 1
 #END FOREACH
#TQC-C10034---mark--end
 
   CALL cl_prt_cs3('aapr312','aapr312',g_sql,g_str)  
 # CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B80105  MARK
END FUNCTION
 
FUNCTION r312_upd(l_apf01)
   DEFINE l_apf01 LIKE apf_file.apf01
 
   UPDATE apf_file SET apfprno = apfprno + 1 WHERE apf01 = l_apf01
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err3("upd","apf_file",l_apf01,"",SQLCA.sqlcode,"","update apfprno:",1)  #No.FUN-660122
   END IF
END FUNCTION
 

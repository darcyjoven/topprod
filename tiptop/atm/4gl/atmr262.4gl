# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr262.4gl
# Descriptions...: 
# Date & Author..: 06/04/06 By Rayven
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.FUN-860020 08/06/04 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                      # Print condition RECORD
           wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)         # Where condition
           more    LIKE type_file.chr1              # Prog. Version..: '5.30.06-13.03.12(01)          # Input more condition(Y/N)
           END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         #No.FUN-680120 VARCHAR(20)              # For TIPTOP 串 EasyFlow
DEFINE g_cnt       LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i         LIKE type_file.num5          #count/index for any purpose         #No.FUN-680120 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_sma115    LIKE  sma_file.sma115
DEFINE l_table     STRING                       #No.FUN-860020                                                             
DEFINE l_sql       STRING                       #No.FUN-860020 
DEFINE g_sql       STRING                       #No.FUN-860020                                                           
DEFINE g_str       STRING                       #No.FUN-860020
 
MAIN
   OPTIONS 
       
       INPUT NO WRAP
   DEFER INTERRUPT                      # Supress DEL key function
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
#No.FUN-860020---Begin 
   LET g_sql = " tsc01.tsc_file.tsc01,",
               " tsc02.tsc_file.tsc02,",
               " tsc15.tsc_file.tsc15,",
               " l_gem02.gem_file.gem02,",
               " tsc17.tsc_file.tsc17,",
               " l_azf03.azf_file.azf03,",
               " tsc03.tsc_file.tsc03,",
               " l_ima135a.ima_file.ima135,",
               " tsc12.tsc_file.tsc12,",
               " l_imd02a.imd_file.imd02,",
               " tsc13.tsc_file.tsc13,",
               " l_ime02a.ime_file.ime02,",
               " tsc14.tsc_file.tsc14,",
               " tsc04.tsc_file.tsc04,",
               " tsc05.tsc_file.tsc05,",
               " l_ima02a.ima_file.ima02,",
               " l_ima021a.ima_file.ima021,",
               " tsd02.tsd_file.tsd02,",
               " tsd03.tsd_file.tsd03,",
               " l_ima135b.ima_file.ima135,",
               " tsd12.tsd_file.tsd12,",
               " l_imd02b.imd_file.imd02,",
               " tsd13.tsd_file.tsd13,",
               " l_ime02b.ime_file.ime02,",
               " tsd14.tsd_file.tsd14,",
               " tsd04.tsd_file.tsd04,",
               " tsd05.tsd_file.tsd05,",
               " l_ima02b.ima_file.ima02,",
               " l_ima021b.ima_file.ima021,", 
               " l_tot2.tsc_file.tsc15 "
   LET l_table = cl_prt_temptable('atmr262',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-860020---End    
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ARG_VAL(1)
   LET g_rpt_name = ARG_VAL(2)        
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   IF cl_null(tm.wc) THEN
        CALL r262_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tsc01= '",tm.wc CLIPPED,"'"
        CALL r262()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r262_tm(p_row,p_col)
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01
DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680120 SMALLINT
       l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
       
  LET p_row=7 LET p_col=7
  
  OPEN WINDOW r262_w AT p_row,p_col WITH FORM "atm/42f/atmr262"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
  CALL cl_ui_init()
  
  CALL cl_opmsg('p')
  
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON tsc01,tsc02,tsc03,tsc15,tsc16,tsc17
    
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tsc01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tsc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsc01
            WHEN INFIELD(tsc03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsc03
            WHEN INFIELD(tsc15)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsc15
            WHEN INFIELD(tsc16)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsc16
            WHEN INFIELD(tsc17)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 ="1"
               #No.FUN-6B0065 --begin                                                                                                          
#              LET g_qryparam.form ="q_tqe01"
               LET g_qryparam.form ="q_azf01"
               #No.FUN-6B0065 --end
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsc17
             OTHERWISE EXIT CASE
         END CASE
        
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
    
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW r262_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM
    END IF
 
    IF tm.wc=" 1=1" THEN
       CALL cl_err('','9046',0)   #本作業查詢條件不可空白
       CONTINUE WHILE
    END IF
    
    INPUT BY NAME tm.more WITHOUT DEFAULTS  
             
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
         CALL cl_cmdask()   
 
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
         
    END INPUT
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0 
       CLOSE WINDOW r262_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd
         FROM zz_file  
        WHERE zz01='atmr262'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('atmr262','9031',1)  #無系統執行指令,無法執行,請檢查程式資料!
       ELSE
          LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      " '",g_lang CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.wc CLIPPED,"'" ,
                      " '",tm.more CLIPPED,"'"  ,
                      " '",g_rep_user CLIPPED,"'",
                      " '",g_rep_clas CLIPPED,"'",
                      " '",g_template CLIPPED,"'"  
          CALL cl_cmdat('atmr262',g_time,l_cmd)    
       END IF
       CLOSE WINDOW r262_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124"
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL r262()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW r262_w
 
END FUNCTION
 
FUNCTION r262()
DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)
#       l_time       LIKE type_file.chr8,       #No.FUN-6B0014
       #No.FUN-860020---Begin
       l_gem02     LIKE gem_file.gem02,
       l_gen02     LIKE gen_file.gen02,
       l_azf03     LIKE azf_file.azf03,
       l_imd02a    LIKE imd_file.imd02,
       l_ime02a    LIKE ime_file.ime02,
       l_ima02a    LIKE ima_file.ima02,
       l_ima021a   LIKE ima_file.ima021,
       l_ima135a   LIKE ima_file.ima135,
       l_ima02b    LIKE ima_file.ima02,
       l_ima021b   LIKE ima_file.ima021,
       l_ima135b   LIKE ima_file.ima135,
       l_imd02b    LIKE imd_file.imd02,
       l_ime02b    LIKE ime_file.ime02,
       l_tot1      LIKE tsd_file.tsd05,
       l_tot2      LIKE tsc_file.tsc05,
       #No.FUN-860020---End 
       l_sql     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(3000)
       sr        RECORD
                 tsc01     LIKE tsc_file.tsc01,
                 tsc02     LIKE tsc_file.tsc02,
                 tsc15     LIKE tsc_file.tsc15,
                 tsc17     LIKE tsc_file.tsc17,
                 tsc03     LIKE tsc_file.tsc03,
                 tsc12     LIKE tsc_file.tsc12,
                 tsc13     LIKE tsc_file.tsc13,
                 tsc14     LIKE tsc_file.tsc14,
                 tsc04     LIKE tsc_file.tsc04,
                 tsc05     LIKE tsc_file.tsc05,
                 tsd02     LIKE tsd_file.tsd02,
                 tsd03     LIKE tsd_file.tsd03,
                 tsd12     LIKE tsd_file.tsd12,
                 tsd13     LIKE tsd_file.tsd13,
                 tsd14     LIKE tsd_file.tsd14,
                 tsd04     LIKE tsd_file.tsd04,
                 tsd05     LIKE tsd_file.tsd05
                 END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tscuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tscgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN      #群組權限
     #         LET tm.wc = tm.wc clipped," AND tscgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tscuser', 'tscgrup')
     #End:FUN-980030
 
     LET l_sql=" SELECT tsc01,tsc02,tsc15,tsc17,tsc03,tsc12,tsc13,tsc14,tsc04,",
               "        tsc05,tsd02,tsd03,tsd12,tsd13,tsd14,tsd04,tsd05 ",
               " FROM tsc_file, tsd_file ",
               " WHERE tsc01 = tsd01 ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY tsc03,tsc01,tsc02,tsd03,tsd02 "
     PREPARE r262_prepare1 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     DECLARE r262_curs1 CURSOR FOR r262_prepare1
     IF STATUS THEN
        CALL cl_err('declare:',STATUS,1)
        RETURN
     END IF
     
#    IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱   #No.FUN-860020
#       THEN                                              #No.FUN-860020
#       LET l_name = g_rpt_name                           #No.FUN-860020
#    ELSE                                                 #No.FUN-860020
#       CALL cl_outnam('atmr262') RETURNING l_name        #No.FUN-860020
#    END IF                                               #No.FUN-860020
 
#    START REPORT r262_rep TO l_name                      #No.FUN-860020
     CALL cl_del_data(l_table)                            #No.FUN-860020
     LET g_pageno = 0
 
     FOREACH r262_curs1 INTO sr.*
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF 
#No.FUN-860020---Begin
         LET l_gem02=''
         LET l_azf03=''
         LET l_ima02a=''
         LET l_ima021a=''
         LET l_ima135a=''
         LET l_imd02a=''
         LET l_ime02a=''
         LET l_ima02b=''
         LET l_ima021b=''
         LET l_ima135b=''
         LET l_imd02b=''
         LET l_ime02b=''
         SELECT gem02 INTO l_gem02        #部門名稱
           FROM gem_file
          WHERE gem01=sr.tsc15                                                                                                          
         SELECT azf03 INTO l_azf03        #理由描述
           FROM azf_file
          WHERE azf01=sr.tsc17 
            AND azf09='1'
         SELECT ima02 INTO l_ima02a       #品名
           FROM ima_file
          WHERE ima01=sr.tsc03
         SELECT ima021 INTO l_ima021a     #規格
           FROM ima_file
          WHERE ima01=sr.tsc03
         SELECT ima135 INTO l_ima135a     #產品條碼
           FROM ima_file
          WHERE ima01=sr.tsc03
         SELECT imd02 INTO l_imd02a       #入庫倉庫名稱
           FROM imd_file
          WHERE imd01=sr.tsc12
         SELECT ime03 INTO l_ime02a       #入庫倉儲位名稱
           FROM ime_file
          WHERE ime01=sr.tsc12
            AND ime02=sr.tsc13
         SELECT ima02 INTO l_ima02b       #品名
           FROM ima_file
          WHERE ima01=sr.tsd03
         SELECT ima021 INTO l_ima021b     #規格
           FROM ima_file
          WHERE ima01=sr.tsd03
         SELECT ima135 INTO l_ima135b     #產品條碼
           FROM ima_file
          WHERE ima01=sr.tsd03
         SELECT imd02 INTO l_imd02b       #出庫倉庫名稱
           FROM imd_file
          WHERE imd_file.imd01=sr.tsd12  
         SELECT ime03 INTO l_ime02b       #出庫倉儲位名稱
           FROM ime_file
          WHERE ime01=sr.tsd12
            AND ime02=sr.tsd13  
               
        LET l_sql=" SELECT SUM(tsc05) ",
         "   FROM tsc_file ",
         "  WHERE tsc01 IN( ",
         " SELECT tsd01 ",
         "   FROM tsc_file, tsd_file ",
         "  WHERE tsc01 = tsd01 ",
         "    AND tsc03 = '",sr.tsc03,"'",
         "    AND ",tm.wc CLIPPED,")",
         "    AND tsc03 = '",sr.tsc03,"'",
         "    AND ",tm.wc CLIPPED
         PREPARE tsc_pre FROM l_sql                                                                                                 
         DECLARE tsc_cs CURSOR FOR tsc_pre
         OPEN tsc_cs
         FETCH tsc_cs INTO l_tot2
#      OUTPUT TO REPORT r262_rep(sr.*)
       EXECUTE insert_prep USING sr.tsc01, sr.tsc02, sr.tsc15, l_gem02, sr.tsc17, l_azf03,  sr.tsc03, 
                                 l_ima135a,sr.tsc12, l_imd02a, sr.tsc13,l_ime02a, sr.tsc14, sr.tsc04,
                                 sr.tsc05, l_ima02a, l_ima021a,sr.tsd02,sr.tsd03, l_ima135b,sr.tsd12,
                                 l_imd02b, sr.tsd13, l_ime02b, sr.tsd14,sr.tsd04, sr.tsd05, l_ima02b,
                                 l_ima021b,l_tot2    
     END FOREACH
 
#    FINISH REPORT r262_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'tsc01,tsc02,tsc03,tsc15,tsc16,tsc17')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc                                                         
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('atmr262','atmr262',l_sql,g_str) 
#No.FUN-860020---End  
END FUNCTION
#No.FUN-860020---Begin
#REPORT r262_rep(sr)
#DEFINE l_tsc01     LIKE tsc_file.tsc01,
#       l_tsc03     LIKE tsc_file.tsc03,
#       l_gem02     LIKE gem_file.gem02,
#       l_gen02     LIKE gen_file.gen02,
#       #No.FUN-6B0065 --begin                                                                                                          
##      l_tqe02     LIKE tqe_file.tqe02,
#       l_azf03     LIKE azf_file.azf03,
#       #No.FUN-6B0065 --end
#       l_imd02a    LIKE imd_file.imd02,
#       l_ime02a    LIKE ime_file.ime02,
#       l_ima02a    LIKE ima_file.ima02,
#       l_ima021a   LIKE ima_file.ima021,
#       l_ima135a   LIKE ima_file.ima135,
#       l_ima02b    LIKE ima_file.ima02,
#       l_ima021b   LIKE ima_file.ima021,
#       l_ima135b   LIKE ima_file.ima135,
#       l_imd02b    LIKE imd_file.imd02,
#       l_ime02b    LIKE ime_file.ime02,
#       l_tot1      LIKE tsd_file.tsd05,
#       l_tot2      LIKE tsc_file.tsc05,
#       l_sql      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(3000)
#DEFINE l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680120 VARCHAR(1)
#       sr        RECORD
#                 tsc01     LIKE tsc_file.tsc01,
#                 tsc02     LIKE tsc_file.tsc02,
#                 tsc15     LIKE tsc_file.tsc15,
#                 tsc17     LIKE tsc_file.tsc17,
#                 tsc03     LIKE tsc_file.tsc03,
#                 tsc12     LIKE tsc_file.tsc12,
#                 tsc13     LIKE tsc_file.tsc13,
#                 tsc14     LIKE tsc_file.tsc14,
#                 tsc04     LIKE tsc_file.tsc04,
#                 tsc05     LIKE tsc_file.tsc05,
#                 tsd02     LIKE tsd_file.tsd02,
#                 tsd03     LIKE tsd_file.tsd03,
#                 tsd12     LIKE tsd_file.tsd12,
#                 tsd13     LIKE tsd_file.tsd13,
#                 tsd14     LIKE tsd_file.tsd14,
#                 tsd04     LIKE tsd_file.tsd04,
#                 tsd05     LIKE tsd_file.tsd05
#                 END RECORD
#
#    OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#      
#    ORDER BY sr.tsc03,sr.tsc01,sr.tsc02,sr.tsd03,sr.tsd02
#    
#    FORMAT
#      PAGE HEADER
#         PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#
#         PRINT g_dash[1,g_len]
#         PRINTX name=H1
#            g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],                                                                                                                
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#            g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],
#            g_x[52],g_x[53],g_x[54],g_x[55]
#               
#         PRINTX name=H2
#            g_x[56],g_x[57],g_x[58],g_x[59],g_x[60]
#
#         PRINTX name=H3
#            g_x[61],g_x[62],g_x[63],g_x[64],g_x[65]
#
#         PRINT g_dash1 
#         LET l_trailer_sw = 'N' 
#            
#      BEFORE GROUP OF sr.tsc01
#         LET l_gem02=''
#         #No.FUN-6B0065 --begin                                                                                                          
##        LET l_tqe02=''
#         LET l_azf03=''
#         #No.FUN-6B0065 --end
#         LET l_ima02a=''
#         LET l_ima021a=''
#         LET l_ima135a=''
#         LET l_imd02a=''
#         LET l_ime02a=''
#         LET l_ima02b=''
#         LET l_ima021b=''
#         LET l_ima135b=''
#         LET l_imd02b=''
#         LET l_ime02b=''
#    
#         SELECT gem02 INTO l_gem02        #部門名稱
#           FROM gem_file
#          WHERE gem01=sr.tsc15
#         #No.FUN-6B0065 --begin                                                                                                          
#         SELECT azf03 INTO l_azf03        #理由描述
#           FROM azf_file
#          WHERE azf01=sr.tsc17 
#            AND azf09='1'
#         #No.FUN-6B0065 --end
#         SELECT ima02 INTO l_ima02a       #品名
#           FROM ima_file
#          WHERE ima01=sr.tsc03
#         SELECT ima021 INTO l_ima021a     #規格
#           FROM ima_file
#          WHERE ima01=sr.tsc03
#         SELECT ima135 INTO l_ima135a     #產品條碼
#           FROM ima_file
#          WHERE ima01=sr.tsc03
#         SELECT imd02 INTO l_imd02a       #入庫倉庫名稱
#           FROM imd_file
#          WHERE imd01=sr.tsc12
#         SELECT ime03 INTO l_ime02a       #入庫倉儲位名稱
#           FROM ime_file
#          WHERE ime01=sr.tsc12
#            AND ime02=sr.tsc13
#
#         PRINTX name=D1
#            COLUMN g_c[31],sr.tsc01 CLIPPED,
#            COLUMN g_c[32],sr.tsc02 CLIPPED,
#            COLUMN g_c[33],sr.tsc15 CLIPPED,
#            COLUMN g_c[34],l_gem02 CLIPPED,
#            COLUMN g_c[35],sr.tsc17 CLIPPED,
##           COLUMN g_c[36],l_tqe02 CLIPPED,     #No.FUN-6B0065
#            COLUMN g_c[36],l_azf03 CLIPPED,     #No.FUN-6B0065
#            COLUMN g_c[37],sr.tsc03 CLIPPED,
#            COLUMN g_c[38],l_ima135a CLIPPED,
#            COLUMN g_c[39],sr.tsc12 CLIPPED,
#            COLUMN g_c[40],l_imd02a CLIPPED,
#            COLUMN g_c[41],sr.tsc13 CLIPPED,
#            COLUMN g_c[42],l_ime02a CLIPPED,
#            COLUMN g_c[43],sr.tsc14 CLIPPED,
#            COLUMN g_c[44],sr.tsc04 CLIPPED,
#            COLUMN g_c[45],sr.tsc05 CLIPPED USING '##########&.&&&';
#
#         PRINTX name=D2
#            COLUMN g_c[57],l_ima02a CLIPPED;
#
#         PRINTX name=D3
#            COLUMN g_c[62],l_ima021a CLIPPED;
#
#      ON EVERY ROW
#         SELECT ima02 INTO l_ima02b       #品名
#           FROM ima_file
#          WHERE ima01=sr.tsd03
#         SELECT ima021 INTO l_ima021b     #規格
#           FROM ima_file
#          WHERE ima01=sr.tsd03
#         SELECT ima135 INTO l_ima135b     #產品條碼
#           FROM ima_file
#          WHERE ima01=sr.tsd03
#         SELECT imd02 INTO l_imd02b       #出庫倉庫名稱
#           FROM imd_file
#          WHERE imd_file.imd01=sr.tsd12  
#         SELECT ime03 INTO l_ime02b       #出庫倉儲位名稱
#           FROM ime_file
#          WHERE ime01=sr.tsd12
#            AND ime02=sr.tsd13
#
#         PRINTX name=D1
#            COLUMN g_c[46],sr.tsd02 USING '#####',
#            COLUMN g_c[47],sr.tsd03 CLIPPED,
#            COLUMN g_c[48],l_ima135b CLIPPED,
#            COLUMN g_c[49],sr.tsd12 CLIPPED,
#            COLUMN g_c[50],l_imd02b CLIPPED,
#            COLUMN g_c[51],sr.tsd13 CLIPPED,
#            COLUMN g_c[52],l_ime02b CLIPPED,
#            COLUMN g_c[53],sr.tsd14 CLIPPED,
#            COLUMN g_c[54],sr.tsd04 CLIPPED,
#            COLUMN g_c[55],sr.tsd05 CLIPPED USING '##########&.&&&'
#
#         PRINTX name=D2
#            COLUMN g_c[60],l_ima02b CLIPPED
#
#         PRINTX name=D3
#            COLUMN g_c[65],l_ima021b CLIPPED
#
#      AFTER GROUP OF sr.tsc03
#         LET l_sql=" SELECT SUM(tsc05) ",
#                   "   FROM tsc_file ",
#                   "  WHERE tsc01 IN( ",
#                   " SELECT tsd01 ",
#                   "   FROM tsc_file, tsd_file ",
#                   "  WHERE tsc01 = tsd01 ",
#                   "    AND tsc03 = '",sr.tsc03,"'",
#                   "    AND ",tm.wc CLIPPED,")",
#                   "    AND tsc03 = '",sr.tsc03,"'",
#                   "    AND ",tm.wc CLIPPED
#         PREPARE tsc_pre FROM l_sql                                                                                                 
#         DECLARE tsc_cs CURSOR FOR tsc_pre
#         OPEN tsc_cs
#         FETCH tsc_cs INTO l_tot2
#         PRINT COLUMN g_c[37],g_x[09] CLIPPED,
#               COLUMN g_c[45],l_tot2 CLIPPED USING '##########&.&&&'
#
#      AFTER GROUP OF sr.tsd03 
#         LET l_tot1 = GROUP SUM(sr.tsd05)
#         PRINT COLUMN g_c[47],g_x[10] CLIPPED,
#               COLUMN g_c[55],l_tot1 CLIPPED USING '##########&.&&&'
#
#      ON LAST ROW
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#      PAGE TRAILER
#         IF l_trailer_sw ='N' THEN
#            PRINT g_dash[1,g_len]
#            PRINT COLUMN (g_len-9),g_x[6] CLIPPED 
#         ELSE
#            SKIP 2 LINE
#         END IF
#         PRINT 
#         IF l_trailer_sw = 'N' THEN
#            IF g_memo_pagetrailer THEN
#               PRINT g_x[11]
#               PRINT g_memo
#            ELSE
#               PRINT
#               PRINT
#            END IF
#         ELSE
#            PRINT g_x[11]
#            PRINT g_memo
#         END IF
#END REPORT
#No.FUN-860020---End 
#No.FUN-870144

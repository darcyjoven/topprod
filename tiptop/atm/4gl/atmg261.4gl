# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: atmg261.4gl
# Descriptions...: 
# Date & Author..: 06/03/14 By cl
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.FUN-850163 08/06/06 By lilingyu 改成CR報表
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-CB0074 12/12/05 By lujh  CR轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                      # Print condition RECORD
           wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)         # Where condition
           more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(01)          # Input more condition(Y/N)
           END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20             #No.FUN-680120 VARCHAR(20)            # For TIPTOP 串 EasyFlow
DEFINE g_cnt       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE g_i         LIKE type_file.num5              #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(72)
DEFINE g_sma115    LIKE  sma_file.sma115
DEFINE gg_sql      STRING                           #NO.FUN-850163
DEFINE l_table     STRING                           #NO.FUN-850163
DEFINE l_table1    STRING                           #NO.FUN-850163
DEFINE g_str       STRING                           #NO.FUN-850163
 
###GENGRE###START
TYPE sr1_t RECORD
    tse01 LIKE tse_file.tse01,
    l_tse01 LIKE tse_file.tse01,
    l_tse03 LIKE tse_file.tse03,
    tse12 LIKE tse_file.tse12,
    l_imd02a LIKE imd_file.imd02,
    tse02 LIKE tse_file.tse02,
    l_ima02a LIKE ima_file.ima02,
    tse13 LIKE tse_file.tse13,
    l_ime02a LIKE ime_file.ime03,
    tse15 LIKE tse_file.tse15,
    l_gem02 LIKE gem_file.gem02,
    l_ima021a LIKE ima_file.ima021,
    tse14 LIKE tse_file.tse14,
    tse16 LIKE tse_file.tse16,
    l_gen02 LIKE gen_file.gen02,
    l_ima135a LIKE ima_file.ima135,
    tse04 LIKE tse_file.tse04,
    tse17 LIKE tse_file.tse17,
    l_azf03 LIKE azf_file.azf03,
    tse05 LIKE tse_file.tse05,
    tse18 LIKE tse_file.tse18,
    l_str2 LIKE type_file.chr1000,
    l_memo LIKE type_file.chr1000,
#FUN-CB0074--cj--add--
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000
#FUN-CB0074--cj--end--
END RECORD

TYPE sr2_t RECORD
    tsf01 LIKE tsf_file.tsf01,
    l_str3 LIKE type_file.chr1000,
    tsf02 LIKE tsf_file.tsf02,
    tsf03 LIKE tsf_file.tsf03,
    l_ima135b LIKE ima_file.ima135,
    tsf12 LIKE tsf_file.tsf12,
    l_imd02b LIKE imd_file.imd02,
    tsf13 LIKE tsf_file.tsf13,
    l_ime02b LIKE ime_file.ime03,
    tsf14 LIKE tsf_file.tsf14,
    tsf04 LIKE tsf_file.tsf04,
    tsf05 LIKE tsf_file.tsf05,
    tsf15 LIKE tsf_file.tsf15,
    l_ima02b LIKE ima_file.ima02,
    l_ima021b LIKE ima_file.ima021
END RECORD
###GENGRE###END

MAIN
   OPTIONS 
       
       INPUT NO WRAP
   DEFER INTERRUPT                      # Supress DEL key function
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   
#NO.FUN-850163  --Begin--
   LET gg_sql = "tse01.tse_file.tse01,", 
                "l_tse01.tse_file.tse01,", 
                "l_tse03.tse_file.tse03,", 
                "tse12.tse_file.tse12,", 
                "l_imd02a.imd_file.imd02,",
                "tse02.tse_file.tse02,", 
                "l_ima02a.ima_file.ima02,", 
                "tse13.tse_file.tse13,", 
                "l_ime02a.ime_file.ime03,",
                "tse15.tse_file.tse15,", 
                "l_gem02.gem_file.gem02,", 
                "l_ima021a.ima_file.ima021,", 
                "tse14.tse_file.tse14,",
                "tse16.tse_file.tse16,", 
                "l_gen02.gen_file.gen02,", 
                "l_ima135a.ima_file.ima135,", 
                "tse04.tse_file.tse04,", 
                "tse17.tse_file.tse17,", 
                "l_azf03.azf_file.azf03,", 
                "tse05.tse_file.tse05,",
                "tse18.tse_file.tse18,",
                "l_str2.type_file.chr1000,",
                "l_memo.type_file.chr1000,",                
         #FUN-CB0074--cj--add--
                "sign_type.type_file.chr1,", #簽核方式
                "sign_img.type_file.blob,",   #簽核圖檔
                "sign_show.type_file.chr1,",  #是否顯示簽核資料(Y/N)
                "sign_str.type_file.chr1000"  #簽核字串
         #FUN-CB0074--cj--end--
   LET l_table = cl_prt_temptable('atmg261',gg_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF                 
                
   LET gg_sql = "tsf01.tsf_file.tsf01,",
                "l_str3.type_file.chr1000,",
                "tsf02.tsf_file.tsf02,", 
                "tsf03.tsf_file.tsf03,", 
                "l_ima135b.ima_file.ima135,", 
                "tsf12.tsf_file.tsf12,",
                "l_imd02b.imd_file.imd02,", 
                "tsf13.tsf_file.tsf13,", 
                "l_ime02b.ime_file.ime03,", 
                "tsf14.tsf_file.tsf14,", 
                "tsf04.tsf_file.tsf04,", 
                "tsf05.tsf_file.tsf05,", 
                "tsf15.tsf_file.tsf15,",
                "l_ima02b.ima_file.ima02,",
                "l_ima021b.ima_file.ima021"                    
  LET l_table1 = cl_prt_temptable('atmg2611',gg_sql) CLIPPED
  IF  l_table1 = -1 THEN EXIT PROGRAM END IF 
                  
#NO.FUN-850163  ---End---   
   
   
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
        CALL atmg261_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tse01= '",tm.wc CLIPPED,"'"
        CALL atmg261()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmg261_tm(p_row,p_col)
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01
DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680120 SMALLINT
       l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
       
  LET p_row=7 LET p_col=7
  
  OPEN WINDOW atmg261_w AT p_row,p_col WITH FORM "atm/42f/atmg261"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
  CALL cl_ui_init()
  
  CALL cl_opmsg('p')
  
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON tse01,tse02,tse03,tse15,tse16,tse17
    
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tse01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tse"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tse01
            WHEN INFIELD(tse03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tse03
            WHEN INFIELD(tse15)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tse15
            WHEN INFIELD(tse16)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tse16
            WHEN INFIELD(tse17)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 ="1"
               #No.FUN-6B0065 --begin                                                                                                          
#              LET g_qryparam.form ="q_tqe01"
               LET g_qryparam.form ="q_azf01"
               #No.FUN-6B0065 --end
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tse17
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
       LET INT_FLAG = 0 CLOSE WINDOW atmg261_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM
          
    END IF
    IF tm.wc=" 1=1" THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
    
    INPUT BY NAME tm.more WITHOUT DEFAULTS  #BugNo:6289
             
      AFTER FIELD more
        IF tm.more = 'Y' THEN 
           CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                RETURNING g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies
        END IF
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()   
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
      LET INT_FLAG = 0 CLOSE WINDOW atmg261_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='atmg261'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmg261','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
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
         CALL cl_cmdat('atmg261',g_time,l_cmd)    
      END IF
      CLOSE WINDOW atmg261_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmg261()
   ERROR ""
END WHILE
   CLOSE WINDOW atmg261_w
END FUNCTION
 
FUNCTION atmg261()
DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6B0014
       l_sql     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(3000)
       sr        RECORD
                 tse01     LIKE tse_file.tse01,
                 tse02     LIKE tse_file.tse02,
                 tse15     LIKE tse_file.tse15,
                 tse17     LIKE tse_file.tse17,
                 tse12     LIKE tse_file.tse12,
                 tse16     LIKE tse_file.tse16,
                 tse04     LIKE tse_file.tse04,
                 tse13     LIKE tse_file.tse13,
                 tse14     LIKE tse_file.tse14,
                 tse05     LIKE tse_file.tse05,
                 tse03     LIKE tse_file.tse03,
                 tse18     LIKE tse_file.tse18,
                 tse06     LIKE tse_file.tse06,   #單頭子單位
                 tse08     LIKE tse_file.tse08,   #單頭子單位數量
                 tse09     LIKE tse_file.tse09,   #單頭母單位
                 tse11     LIKE tse_file.tse11    #單頭母單位數量  
                 END RECORD,
       sr1       RECORD
                 tsf01     LIKE tsf_file.tsf01,        #NO.FUN-850163
                 tsf02     LIKE tsf_file.tsf02,
                 tsf03     LIKE tsf_file.tsf03,
                 tsf12     LIKE tsf_file.tsf12,
                 tsf13     LIKE tsf_file.tsf13,
                 tsf14     LIKE tsf_file.tsf14,
                 tsf04     LIKE tsf_file.tsf04,
                 tsf05     LIKE tsf_file.tsf05,
                 tsf15     LIKE tsf_file.tsf15,
                 tsf06     LIKE tsf_file.tsf06,   #子單位
                 tsf08     LIKE tsf_file.tsf08,   #子單位數量
                 tsf09     LIKE tsf_file.tsf09,   #母單位
                 tsf11     LIKE tsf_file.tsf11    #母單位數量  
                 END RECORD 
                 
#NO.FUN-850163  --Begin--
DEFINE l_tse01     LIKE tse_file.tse01,
       l_tse03     LIKE tse_file.tse03,
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
       l_ima906    LIKE ima_file.ima906,
       l_tsf08     LIKE tsf_file.tsf08,
       l_tsf11     LIKE tsf_file.tsf11,
       l_tse08     LIKE tse_file.tse08,
       l_tse11     LIKE tse_file.tse11,
       l_str2      LIKE type_file.chr1000, 
       l_str3      LIKE type_file.chr1000,         
       #l_sql1      LIKE type_file.chr1000, 
       l_sql1      STRING,     #NO.FUN-910082         
       l_memo      LIKE type_file.chr1000
       
   DEFINE  l_img_blob     LIKE type_file.blob    #FUN-CB0073 cj add

     LOCATE l_img_blob    IN MEMORY              #FUN-CB0073 cj add
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     
     LET gg_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)"   #FUN-CB0074 cj add 4?
     PREPARE insert_prep FROM gg_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
        EXIT PROGRAM
     END IF
     
     LET gg_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert_prep1 FROM gg_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
        EXIT PROGRAM
     END IF  
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmg261'                          
#NO.FUN-850163  --End---
                 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tseuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tsegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN      #群組權限
     #         LET tm.wc = tm.wc clipped," AND tsegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tseuser', 'tsegrup')
     #End:FUN-980030
 
     LET l_sql=" SELECT tse01,tse02,tse15,tse17,tse12,tse16,tse04,tse13,",
               "        tse14,tse05,tse03,tse18,tse06,tse08,tse09,tse11 ",
               " FROM tse_file  ",    
               " WHERE ",tm.wc CLIPPED,
               " ORDER BY tse01, tse02 "  
     PREPARE atmg261_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmg261_curs1 CURSOR FOR atmg261_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
#NO.FUN-850163  --Begin--     
    #IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
    #    THEN
    #    LET l_name = g_rpt_name
    # ELSE
    #    CALL cl_outnam('atmg261') RETURNING l_name
    # END IF
 
    # START REPORT atmg261_rep TO l_name
    
#NO.FUN-850163  --End--
 
     LET g_pageno = 0
     FOREACH atmg261_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF 
       #是否使用多單位
       SELECT sma115 INTO g_sma115 FROM sma_file 
 
#NO.FUN-850163  --Begin--
#       OUTPUT TO REPORT atmg261_rep(sr.*)
       LET l_memo = g_memo 
       LET l_gem02=''                                                                                                         
       LET l_azf03=''
       LET l_gen02=''
       LET l_imd02a=''
       LET l_ime02a=''
       LET l_ima02a=''
       LET l_ima021a=''
       LET l_ima135a=''
       LET l_imd02b=''
       LET l_ime02b=''
       LET l_ima02b=''
       LET l_ima021b=''
       LET l_ima135b=''
    
      SELECT gem02 INTO l_gem02        #部門名稱
        FROM gem_file
       WHERE gem01=sr.tse15
      SELECT azf03 INTO l_azf03        #理由描述
        FROM azf_file
       WHERE azf01=sr.tse17 
         AND azf09='1'
      SELECT gen02 INTO l_gen02        #員工姓名
        FROM gen_file
       WHERE gen01=sr.tse16
      SELECT imd02 INTO l_imd02a       #入庫倉庫名稱
        FROM imd_file
       WHERE imd01=sr.tse12
      SELECT ime03 INTO l_ime02a       #入庫倉儲位名稱
        FROM ime_file
       WHERE ime01=sr.tse12
         AND ime02=sr.tse13
      SELECT ima02 INTO l_ima02a       #品名
        FROM ima_file
       WHERE ima01=sr.tse03
      SELECT ima021 INTO l_ima021a     #規格
        FROM ima_file
       WHERE ima01=sr.tse03
      SELECT ima135 INTO l_ima135a     #產品條碼
        FROM ima_file
       WHERE ima01=sr.tse03
      
      #單位注解            
      SELECT ima906 INTO l_ima906
        FROM ima_file           
       WHERE ima01=sr.tse03    
       
      LET l_str2 = ""         
      IF g_sma115 = "Y" THEN 
         CASE l_ima906      
           WHEN "2"       
             CALL cl_remove_zero(sr.tse11) RETURNING l_tse11 
             LET l_str2 = l_tse11 , sr.tse09 CLIPPED 
             IF cl_null(sr.tse11) OR sr.tse11 = 0 THEN          
                CALL cl_remove_zero(sr.tse08) RETURNING l_tse08
                LET l_str2 = l_tse08 , sr.tse06 CLIPPED        
             ELSE                                             
                IF NOT cl_null(sr.tse08) AND sr.tse08 > 0 THEN   
                   CALL cl_remove_zero(sr.tse08) RETURNING l_tse08            
                   LET l_str2 = l_str2 CLIPPED,',',l_tse08 , sr.tse06 CLIPPED                                                 
                END IF               
             END IF               
           WHEN "3"
             IF NOT cl_null(sr.tse11) AND sr.tse11 > 0 THEN
                CALL cl_remove_zero(sr.tse11) RETURNING l_tse11
                LET l_str2 = l_tse11 , sr.tse09 CLIPPED 
             END IF 
          END CASE
       ELSE       
       END IF       
       
       LET l_tse01=sr.tse01[1,16] 
       LET l_tse03=sr.tse03[1,20]     
       
       ###########r261_sub###############begin
        LET l_sql1= " SELECT tsf01,tsf02,tsf03,tsf12,tsf13,tsf14,tsf04,tsf05, ",
                    "        tsf15,tsf06,tsf08,tsf09,tsf11  ",
                    " FROM tsf_file ",
                    " WHERE tsf01='",sr.tse01,"'",
                    " ORDER BY tsf02 "
        PREPARE atmg261_prepare2 FROM l_sql1
        IF STATUS THEN
           CALL cl_err('prepare2:',STATUS,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time 
           EXIT PROGRAM 
        END IF
        DECLARE atmg261_curs2 CURSOR FOR atmg261_prepare2
        IF STATUS THEN 
           CALL cl_err('declare:',STATUS,1) 
           RETURN
        END IF
        FOREACH atmg261_curs2 INTO sr1.*
              IF STATUS THEN
                 CALL cl_err('foreach:',STATUS,1)
                 EXIT FOREACH
              END IF 
            #單位注解            
           SELECT ima906 INTO l_ima906
             FROM ima_file           
            WHERE ima01=sr1.tsf03    
           LET l_str3 = ""         
           IF g_sma115 = "Y" THEN 
              CASE l_ima906      
                 WHEN "2"       
                   CALL cl_remove_zero(sr1.tsf11) RETURNING l_tsf11      
                   LET l_str3 = l_tsf11 , sr1.tsf09 CLIPPED 
                     IF cl_null(sr1.tsf11) OR sr1.tsf11 = 0 THEN          
                         CALL cl_remove_zero(sr1.tsf08) RETURNING l_tsf08
                         LET l_str3 = l_tsf08 , sr1.tsf06 CLIPPED        
                     ELSE                                             
                        IF NOT cl_null(sr1.tsf08) AND sr1.tsf08 > 0 THEN   
                           CALL cl_remove_zero(sr1.tsf08) RETURNING l_tsf08            
                           LET l_str3 = l_str3 CLIPPED,',',l_tsf08 , sr1.tsf06 CLIPPED                                                 
                        END IF               
                     END IF               
                 WHEN "3"
                     IF NOT cl_null(sr1.tsf11) AND sr1.tsf11 > 0 THEN
                        CALL cl_remove_zero(sr1.tsf11) RETURNING l_tsf11
                        LET l_str3 = l_tsf11 , sr1.tsf09 CLIPPED 
                     END IF 
              END CASE
           ELSE       
           END IF        
 
            SELECT ima02 INTO l_ima02b       #品名
              FROM ima_file
             WHERE ima01=sr1.tsf03
            SELECT ima021 INTO l_ima021b     #規格
              FROM ima_file
             WHERE ima01=sr1.tsf03
            SELECT ima135 INTO l_ima135b     #產品條碼
              FROM ima_file
             WHERE ima01=sr1.tsf03
            SELECT imd02 INTO l_imd02b       #出庫倉庫名稱
              FROM imd_file
             WHERE imd_file.imd01=sr1.tsf12  
            SELECT ime03 INTO l_ime02b       #出庫倉儲位名稱
              FROM ime_file
             WHERE ime01=sr1.tsf12
               AND ime02=sr1.tsf13
            
            EXECUTE insert_prep1 USING 
                    sr1.tsf01,l_str3,sr1.tsf02,sr1.tsf03, l_ima135b,sr1.tsf12,l_imd02b, 
                    sr1.tsf13,l_ime02b,sr1.tsf14,sr1.tsf04,sr1.tsf05,sr1.tsf15,
                    l_ima02b ,l_ima021b         
             
        END FOREACH  
       ############r261_sub##############end        
        
        EXECUTE insert_prep USING
                sr.tse01,l_tse01,  l_tse03, sr.tse12,l_imd02a, sr.tse02,l_ima02a,
                sr.tse13,l_ime02a, sr.tse15,l_gem02 ,l_ima021a,sr.tse14,sr.tse16,
                l_gen02 ,l_ima135a,sr.tse04,sr.tse17,l_azf03  ,sr.tse05,sr.tse18,
                l_str2,l_memo
                 ,"",l_img_blob,"N",""               #FUN-CB0074 cj add
     
#NO.FUN-850163  --End--
     END FOREACH
 
#NO.FUN-850163  --Begin--
    # FINISH REPORT atmg261_rep
 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###GENGRE###    LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                 
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'tse01,tse02,tse03,tse15,tse16,tse17')                  
       RETURNING tm.wc
    ELSE
       LET tm.wc = ""
    END IF
    
###GENGRE###    LET g_str = tm.wc
    
###GENGRE###    CALL cl_prt_cs3('atmg261','atmg261',gg_sql,g_str)
    LET g_cr_table = l_table                   #主報表的temp table名稱         #FUN-CB0074 cj add
    LET g_cr_apr_key_f = "tse01"       #報表主鍵欄位名稱，用"|"隔開            #FUN-CB0074 cj add
    CALL atmg261_grdata()    ###GENGRE###
#NO.FUN-850163  --End--
END FUNCTION
 
#NO.FUN-850163  --Begin--
#REPORT atmg261_rep(sr)
#DEFINE l_tse01     LIKE tse_file.tse01,
#       l_tse03     LIKE tse_file.tse03,
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
#       l_ima906    LIKE ima_file.ima906,
#       l_tsf08     LIKE tsf_file.tsf08,
#       l_tsf11     LIKE tsf_file.tsf11,
#       l_tse08     LIKE tse_file.tse08,
#       l_tse11     LIKE tse_file.tse11,
#       l_str2      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(100)
#       l_sql1      LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(3000)
#DEFINE l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
#       sr        RECORD
#                 tse01     LIKE tse_file.tse01,
#                 tse02     LIKE tse_file.tse02,
#                 tse15     LIKE tse_file.tse15,
#                 tse17     LIKE tse_file.tse17,
#                 tse12     LIKE tse_file.tse12,
#                 tse16     LIKE tse_file.tse16,
#                 tse04     LIKE tse_file.tse04,
#                 tse13     LIKE tse_file.tse13,
#                 tse14     LIKE tse_file.tse14,
#                 tse05     LIKE tse_file.tse05,
#                 tse03     LIKE tse_file.tse03,
#                 tse18     LIKE tse_file.tse18,
#                 tse06     LIKE tse_file.tse06,   #單頭子單位
#                 tse08     LIKE tse_file.tse08,   #單頭子單位數量
#                 tse09     LIKE tse_file.tse09,   #單頭母單位
#                 tse11     LIKE tse_file.tse11    #單頭母單位數量  
#                 END RECORD,
#       sr1       RECORD
#                 tsf02     LIKE tsf_file.tsf02,
#                 tsf03     LIKE tsf_file.tsf03,
#                 tsf12     LIKE tsf_file.tsf12,
#                 tsf13     LIKE tsf_file.tsf13,
#                 tsf14     LIKE tsf_file.tsf14,
#                 tsf04     LIKE tsf_file.tsf04,
#                 tsf05     LIKE tsf_file.tsf05,
#                 tsf15     LIKE tsf_file.tsf15,
#                 tsf06     LIKE tsf_file.tsf06,   #子單位
#                 tsf08     LIKE tsf_file.tsf08,   #子單位數量
#                 tsf09     LIKE tsf_file.tsf09,   #母單位
#                 tsf11     LIKE tsf_file.tsf11    #母單位數量  
#                 END RECORD 
#
#    OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#      
#    ORDER BY sr.tse01
#    
#    FORMAT
#      PAGE HEADER
#            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            PRINT g_dash[1,g_len]
#            
#      BEFORE GROUP OF sr.tse01
#           SKIP TO TOP OF PAGE
#           LET l_gem02=''
#           #No.FUN-6B0065 --begin                                                                                                          
##          LET l_tqe02=''
#           LET l_azf03=''
#           #No.FUN-6B0065 --end
#           LET l_gen02=''
#           LET l_imd02a=''
#           LET l_ime02a=''
#           LET l_ima02a=''
#           LET l_ima021a=''
#           LET l_ima135a=''
#           LET l_imd02b=''
#           LET l_ime02b=''
#           LET l_ima02b=''
#           LET l_ima021b=''
#           LET l_ima135b=''
#    
#            SELECT gem02 INTO l_gem02        #部門名稱
#              FROM gem_file
#             WHERE gem01=sr.tse15
##           LET l_tqe02=''     #No.FUN-6B0065
#            #No.FUN-6B0065 --begin                                                                                                          
#            SELECT azf03 INTO l_azf03        #理由描述
#              FROM azf_file
#             WHERE azf01=sr.tse17 
#               AND azf09='1'
#            #No.FUN-6B0065 --end
#            SELECT gen02 INTO l_gen02        #員工姓名
#              FROM gen_file
#             WHERE gen01=sr.tse16
#            SELECT imd02 INTO l_imd02a       #入庫倉庫名稱
#              FROM imd_file
#             WHERE imd01=sr.tse12
#            SELECT ime03 INTO l_ime02a       #入庫倉儲位名稱
#              FROM ime_file
#             WHERE ime01=sr.tse12
#               AND ime02=sr.tse13
#            SELECT ima02 INTO l_ima02a       #品名
#              FROM ima_file
#             WHERE ima01=sr.tse03
#            SELECT ima021 INTO l_ima021a     #規格
#              FROM ima_file
#             WHERE ima01=sr.tse03
#            SELECT ima135 INTO l_ima135a     #產品條碼
#              FROM ima_file
#             WHERE ima01=sr.tse03
#            #單位注解            
#            SELECT ima906 INTO l_ima906
#              FROM ima_file           
#              WHERE ima01=sr.tse03    
#            LET l_str2 = ""         
#            IF g_sma115 = "Y" THEN 
#              CASE l_ima906      
#                 WHEN "2"       
#                     CALL cl_remove_zero(sr.tse11) RETURNING l_tse11 
#                     LET l_str2 = l_tse11 USING '<<<<<<<<.<<' , sr.tse09 CLIPPED 
#                     IF cl_null(sr.tse11) OR sr.tse11 = 0 THEN          
#                         CALL cl_remove_zero(sr.tse08) RETURNING l_tse08
#                         LET l_str2 = l_tse08 USING '<<<<<<<<.<<', sr.tse06 CLIPPED        
#                     ELSE                                             
#                        IF NOT cl_null(sr.tse08) AND sr.tse08 > 0 THEN   
#                           CALL cl_remove_zero(sr.tse08) RETURNING l_tse08            
#                           LET l_str2 = l_str2 CLIPPED,',',l_tse08 USING '<<<<<<<<<.<<', sr.tse06 CLIPPED                                                 
#                        END IF               
#                     END IF               
#                 WHEN "3"
#                     IF NOT cl_null(sr.tse11) AND sr.tse11 > 0 THEN
#                        CALL cl_remove_zero(sr.tse11) RETURNING l_tse11
#                        LET l_str2 = l_tse11 USING '<<<<<<<<.<<' , sr.tse09 CLIPPED 
#                     END IF 
#              END CASE
#            ELSE       
#            END IF       
#       
#
#            LET l_tse01=sr.tse01[1,16] 
#            LET l_tse03=sr.tse03[1,20] 
#            PRINT COLUMN   1,g_x[11] CLIPPED,l_tse01 CLIPPED,
#                  COLUMN  61,g_x[18] CLIPPED,l_tse03 CLIPPED,
#                  COLUMN 131,g_x[15] CLIPPED,sr.tse12 CLIPPED,
#                             ' ',l_imd02a CLIPPED 
#            PRINT COLUMN   1,g_x[12] CLIPPED,sr.tse02 CLIPPED,
#                  COLUMN  61,g_x[22] CLIPPED,l_ima02a CLIPPED,
#                  COLUMN 131,g_x[16] CLIPPED,sr.tse13 CLIPPED,
#                             ' ',l_ime02a CLIPPED
#            PRINT COLUMN   1,g_x[13] CLIPPED,sr.tse15 CLIPPED,
#                             ' ',l_gem02 CLIPPED,
#                  COLUMN  61,g_x[23] CLIPPED,l_ima021a CLIPPED,
#                  COLUMN 131,g_x[17] CLIPPED,sr.tse14 CLIPPED
#            PRINT COLUMN   1,g_x[25] CLIPPED,sr.tse16 CLIPPED,
#                             ' ',l_gen02 CLIPPED,
#                  COLUMN  61,g_x[45] CLIPPED,l_ima135a CLIPPED,
#                  COLUMN 131,g_x[19] CLIPPED,sr.tse04 CLIPPED
#            PRINT COLUMN   1,g_x[14] CLIPPED,sr.tse17 CLIPPED,
##                            ' ',l_tqe02 CLIPPED,
#                             ' ',l_azf03 CLIPPED,
#                  COLUMN 131,g_x[20] CLIPPED,sr.tse05 USING '<<<<<<<<<<<<<<<' 
#            PRINT COLUMN   1,g_x[21] CLIPPED,sr.tse18 CLIPPED,
#                  COLUMN 131,g_x[51] CLIPPED,l_str2 CLIPPED 
#            PRINT
#            PRINT g_dash2[1,g_len]
#            PRINTX name=H1 g_x[31],g_x[32],g_x[24],g_x[34],
#                           g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]  
#            PRINTX name=H2 g_x[46],g_x[33],g_x[50],g_x[49]
#            PRINTX name=H3 g_x[47],g_x[41]
#            PRINT g_dash1 	
#            LET l_trailer_sw = 'n'
#
#        ON EVERY ROW
#            LET l_sql1=" SELECT tsf02,tsf03,tsf12,tsf13,tsf14,tsf04,tsf05, ",
#                      "        tsf15,tsf06,tsf08,tsf09,tsf11  ",
#                      " FROM tsf_file ",
#                      " WHERE tsf01='",sr.tse01,"'",
#                      " ORDER BY tsf02 "
#            PREPARE atmg261_prepare2 FROM l_sql1
#            IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
#               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#               EXIT PROGRAM 
#            END IF
#            DECLARE atmg261_curs2 CURSOR FOR atmg261_prepare2
#            IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#            FOREACH atmg261_curs2 INTO sr1.*
#              IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF 
#            #單位注解            
#           SELECT ima906 INTO l_ima906
#             FROM ima_file           
#             WHERE ima01=sr1.tsf03    
#           LET l_str2 = ""         
#           IF g_sma115 = "Y" THEN 
#              CASE l_ima906      
#                 WHEN "2"       
#                     CALL cl_remove_zero(sr1.tsf11) RETURNING l_tsf11      
#                     LET l_str2 = l_tsf11 USING '<<<<<<<<.<<' , sr1.tsf09 CLIPPED 
#                     IF cl_null(sr1.tsf11) OR sr1.tsf11 = 0 THEN          
#                         CALL cl_remove_zero(sr1.tsf08) RETURNING l_tsf08
#                         LET l_str2 = l_tsf08 USING '<<<<<<<<.<<', sr1.tsf06 CLIPPED        
#                     ELSE                                             
#                        IF NOT cl_null(sr1.tsf08) AND sr1.tsf08 > 0 THEN   
#                           CALL cl_remove_zero(sr1.tsf08) RETURNING l_tsf08            
#                           LET l_str2 = l_str2 CLIPPED,',',l_tsf08 USING '<<<<<<<<.<<', sr1.tsf06 CLIPPED                                                 
#                        END IF               
#                     END IF               
#                 WHEN "3"
#                     IF NOT cl_null(sr1.tsf11) AND sr1.tsf11 > 0 THEN
#                        CALL cl_remove_zero(sr1.tsf11) RETURNING l_tsf11
#                        LET l_str2 = l_tsf11 USING '<<<<<<<<.<<' , sr1.tsf09 CLIPPED 
#                     END IF 
#              END CASE
#           ELSE       
#           END IF        
#
#            SELECT ima02 INTO l_ima02b       #品名
#              FROM ima_file
#             WHERE ima01=sr1.tsf03
#            SELECT ima021 INTO l_ima021b     #規格
#              FROM ima_file
#             WHERE ima01=sr1.tsf03
#            SELECT ima135 INTO l_ima135b     #產品條碼
#              FROM ima_file
#             WHERE ima01=sr1.tsf03
#            SELECT imd02 INTO l_imd02b       #出庫倉庫名稱
#              FROM imd_file
#             WHERE imd_file.imd01=sr1.tsf12  
#            SELECT ime03 INTO l_ime02b       #出庫倉儲位名稱
#              FROM ime_file
#             WHERE ime01=sr1.tsf12
#               AND ime02=sr1.tsf13
#            PRINTX name=D1
#                  COLUMN g_c[31],sr1.tsf02 USING '#####',
#                  COLUMN g_c[32],sr1.tsf03 CLIPPED,
#                  COLUMN g_c[24],l_ima135b CLIPPED,
#                  COLUMN g_c[34],sr1.tsf12 CLIPPED,'  ',l_imd02b CLIPPED,
#                  COLUMN g_c[35],sr1.tsf13 CLIPPED,'  ',l_ime02b CLIPPED,
#                  COLUMN g_c[36],sr1.tsf14 CLIPPED,
#                  COLUMN g_c[37],sr1.tsf04 CLIPPED,
#                  COLUMN g_c[38],sr1.tsf05 CLIPPED USING '##########&.&&&',
#                  COLUMN g_c[39],sr1.tsf15 CLIPPED
#
#            PRINTX name=D2
#                  COLUMN g_c[33],l_ima02b CLIPPED,
#                  COLUMN g_c[49],l_str2 CLIPPED
#
#            PRINTX name=D3
#                  COLUMN g_c[41],l_ima021b CLIPPED
#
#            END FOREACH
#         ON LAST ROW
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#         PAGE TRAILER
#            IF l_trailer_sw ='n' THEN
#               PRINT g_dash[1,g_len]
#               PRINT COLUMN (g_len-9),g_x[6] CLIPPED 
#            ELSE
#               SKIP 2 LINE
#            END IF
#            PRINT 
#            IF l_trailer_sw = 'N' THEN
#               IF g_memo_pagetrailer THEN
#                  PRINT g_x[48]
#                  PRINT g_memo
#               ELSE
#                  PRINT
#                  PRINT
#               END IF
#            ELSE
#               PRINT g_x[48]
#               PRINT g_memo
#            END IF
#
#END REPORT
#NO.FUN-850163  --End--
 
#No.FUN-870144


###GENGRE###START
FUNCTION atmg261_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY   #FUN-CB0074  cj add
    CALL cl_gre_init_apr()          #FUN-CB0074 cj add

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("atmg261")
        IF handler IS NOT NULL THEN
            START REPORT atmg261_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY tse01"    #FUN-CB0074
          
            DECLARE atmg261_datacur1 CURSOR FROM l_sql
            FOREACH atmg261_datacur1 INTO sr1.*
                OUTPUT TO REPORT atmg261_rep(sr1.*)
            END FOREACH
            FINISH REPORT atmg261_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT atmg261_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sql         STRING   #FUN-CB0074  add

    
    ORDER EXTERNAL BY sr1.tse01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.tse01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-CB0074--add--str--
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE tsf01='",sr1.tse01,"'",
                        " ORDER BY tsf02"
            START REPORT atmg261_subrep01
            DECLARE atmg261_subrep01 CURSOR FROM l_sql
            FOREACH atmg261_subrep01 INTO sr2.*
                OUTPUT TO REPORT atmg261_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT atmg261_subrep01
            #FUN-CB0074--add--end--
            PRINTX sr1.*

        AFTER GROUP OF sr1.tse01

        
        ON LAST ROW

END REPORT
#FUN-CB0074--add--str--
REPORT atmg261_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
           
           PRINTX sr2.*
END REPORT
#FUN-CB0074--add--end--
###GENGRE###END

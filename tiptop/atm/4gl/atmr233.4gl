# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: atmr233.4gl
# Descriptions...: 合約/訂單確認書
# Date & Author..: 06/03/14 By Vivien
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-710082 07/03/06 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/12 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.TQC-C10039 12/01/20 By wangrr 整合單據列印EF簽核
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)            # Where condition
            a       LIKE type_file.chr1,             # Prog. Version..: '5.30.06-13.03.12(01)             # 列印單價
            more    LIKE type_file.chr1              # Prog. Version..: '5.30.06-13.03.12(01)             # Input more condition(Y/N)
            END RECORD
 DEFINE g_rpt_name  LIKE bnb_file.bnb06,             #No.FUN-680120 VARCHAR(20) # For TIPTOP 串 EasyFlow
        g_po_no,g_ctn_no1,g_ctn_no2        LIKE bnb_file.bnb06       #No.FUN-680120 VARCHAR(20)     #No:7674
 DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
 DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680120 SMALLINT
 DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_str      STRING   
#No.FUN-710082--end  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.a = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ARG_VAL(1)
   LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   LET g_rpt_name = ARG_VAL(6)  #No.FUN-7C0078
 
   #No.FUN-710082--begin
   LET g_sql ="tqx01.tqx_file.tqx01,",
              "tqx02.tqx_file.tqx02,",
              "tqx03.tqx_file.tqx03,",
              "tqx04.tqx_file.tqx04,",
              "tqx05.tqx_file.tqx05,",
 
              "tqx06.tqx_file.tqx06,",
              "tqx07.tqx_file.tqx07,",
              "tqx08.tqx_file.tqx08,",
              "tqx09.tqx_file.tqx09,",
              "tqx10.tqx_file.tqx10,",
 
              "tqx11.tqx_file.tqx11,",
              "tqx12.tqx_file.tqx12,",
              "tqx13.tqx_file.tqx13,",
              "tqx15.tqx_file.tqx15,",
              "tsa02.tsa_file.tsa02,",
 
              "tsa03.tsa_file.tsa03,",
              "tsa04.tsa_file.tsa04,",
              "tsa05.tsa_file.tsa05,",
              "tsa08.tsa_file.tsa08,",
              "tqy03.tqy_file.tqy03,",
 
              "tqy04.tqy_file.tqy04,",
              "tqy05.tqy_file.tqy05,",
              "tqy06.tqy_file.tqy06,",
              "tqy36.tqy_file.tqy36,",
              "tqy37.tqy_file.tqy37,",
 
              "tqy38.tqy_file.tqy38,",
              "tqz03.tqz_file.tqz03,",
              "tqz031.tqz_file.tqz031,",
              "tqz04.tqz_file.tqz04,",
              "tqz05.tqz_file.tqz05,",
 
              "tqz06.tqz_file.tqz06,",
              "tqz07.tqz_file.tqz07,",
              "tqz08.tqz_file.tqz08,",
              "tqz09.tqz_file.tqz09,",
              "tqz10.tqz_file.tqz10,",
 
              "tqz11.tqz_file.tqz11,",
              "tqz12.tqz_file.tqz12,",
              "tqz13.tqz_file.tqz13,",
              "tqz14.tqz_file.tqz14,",
              "tqz15.tqz_file.tqz15,",
 
              "tqz16.tqz_file.tqz16,",
              "tqz17.tqz_file.tqz17,",
              "tqz18.tqz_file.tqz18,",
              "ima021.ima_file.ima021,",
              "tsb03.tsb_file.tsb03,",
 
              "tsb04.tsb_file.tsb04,",
              "tsb05.tsb_file.tsb05,",
              "tsb06.tsb_file.tsb06,",
              "tsb08.tsb_file.tsb08,",
              "tsb09.tsb_file.tsb09,",
 
              "tsb10.tsb_file.tsb10,",
              "tsb11.tsb_file.tsb11,",
              "tsb12.tsb_file.tsb12,",
              "tqa02.tqa_file.tqa02,",
              "tqa02a.tqa_file.tqa02,",
 
              "tqa02b.tqa_file.tqa02,",
              "tqb02.tqb_file.tqb02,",
              "gec02.gec_file.gec02,",
              "occ02.occ_file.occ02,",
              "azp02.azp_file.azp02,",
 
              "too02.too_file.too02,",
              "top02.top_file.top02,",
              "tqa02c.tqa_file.tqa02,",
              "tqa02d.tqa_file.tqa02,",
              "oaj02.oaj_file.oaj02,",
 
              "tqa02e.tqa_file.tqa02,",
              "tqa02f.tqa_file.tqa02,",
              "tqa02g.tqa_file.tqa02,",
              "sum1.tsb_file.tsb06,",

              "sign_type.type_file.chr1,",  #TQC-C10039 簽核方式
              "sign_img.type_file.blob,",   #TQC-C10039 簽核圖檔
              "sign_show.type_file.chr1,",  #TQC-C10039 是否顯示簽核資料(Y/N)
              "sign_str.type_file.chr1000"  #TQC-C10039 sign_str
 
   LET l_table = cl_prt_temptable('atmr233',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #TQC-C10039 add 4?

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   #No.FUN-710082--end  
 
   IF cl_null(tm.wc) THEN
        CALL atmr233_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tqx01= '",tm.wc CLIPPED,"'"
        CALL atmr233()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr233_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmr233_w AT p_row,p_col WITH FORM "atm/42f/atmr233"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tqx01,tqx02,tqx03,tqx04,tqx12,tqx13
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION CONTROLP    
          IF INFIELD(tqx01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqx"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx01
             NEXT FIELD tqx01
          END IF
          IF INFIELD(tqx03) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqa"
             LET g_qryparam.arg1 = "15"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx03
             NEXT FIELD tqx03
          END IF
          IF INFIELD(tqx04) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqa"
             LET g_qryparam.arg1 = "17"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx04
             NEXT FIELD tqx04
          END IF
          IF INFIELD(tqx12) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqb"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx12
             NEXT FIELD tqx12
          END IF
          IF INFIELD(tqx13) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_tqa"
             LET g_qryparam.arg1 = "20"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO FORMONLY.tqx13
             NEXT FIELD tqx13
          END IF
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr233_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr233_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr233'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr233','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.more CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('atmr233',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW atmr233_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr233()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr233_w
END FUNCTION
 
FUNCTION atmr233()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(3000)
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)
          sr        RECORD
                    tqx01     LIKE tqx_file.tqx01,
                    tqx02     LIKE tqx_file.tqx02,
                    tqx03     LIKE tqx_file.tqx03,
                    tqx04     LIKE tqx_file.tqx04,
                    tqx05     LIKE tqx_file.tqx05,
                    tqx06     LIKE tqx_file.tqx06,
                    tqx07     LIKE tqx_file.tqx07,
                    tqx08     LIKE tqx_file.tqx08,
                    tqx09     LIKE tqx_file.tqx09,
                    tqx10     LIKE tqx_file.tqx10,   
                    tqx11     LIKE tqx_file.tqx11,
                    tqx12     LIKE tqx_file.tqx12,
                    tqx13     LIKE tqx_file.tqx13,
                    tqx15     LIKE tqx_file.tqx15,
                    tsa02     LIKE tsa_file.tsa02,
                    tsa03     LIKE tsa_file.tsa03,
                    tsa04     LIKE tsa_file.tsa04,
                    tsa05     LIKE tsa_file.tsa05,
                    tsa08     LIKE tsa_file.tsa08,
                    tqy03     LIKE tqy_file.tqy03,
                    tqy04     LIKE tqy_file.tqy04,
                    tqy05     LIKE tqy_file.tqy05,
                    tqy06     LIKE tqy_file.tqy06,
                    tqy36     LIKE tqy_file.tqy36,
                    tqy37     LIKE tqy_file.tqy37,
                    tqy38     LIKE tqy_file.tqy38,
                    tqz03     LIKE tqz_file.tqz03,
                    tqz031    LIKE tqz_file.tqz031,
                    tqz04     LIKE tqz_file.tqz04,
                    tqz05     LIKE tqz_file.tqz05,
                    tqz06     LIKE tqz_file.tqz06,
                    tqz07     LIKE tqz_file.tqz07,
                    tqz08     LIKE tqz_file.tqz08,
                    tqz09     LIKE tqz_file.tqz09,
                    tqz10     LIKE tqz_file.tqz10,
                    tqz11     LIKE tqz_file.tqz11,
                    tqz12     LIKE tqz_file.tqz12,
                    tqz13     LIKE tqz_file.tqz13,
                    tqz14     LIKE tqz_file.tqz14,
                    tqz15     LIKE tqz_file.tqz15,
                    tqz16     LIKE tqz_file.tqz16,
                    tqz17     LIKE tqz_file.tqz17,
                    tqz18     LIKE tqz_file.tqz18,
                    ima021    LIKE ima_file.ima021
                    END RECORD
#No.FUN-710082--begin
DEFINE    sr2       RECORD
                    tsb03     LIKE tsb_file.tsb03,
                    tsb04     LIKE tsb_file.tsb04,
                    tsb05     LIKE tsb_file.tsb05,
                    tsb06     LIKE tsb_file.tsb06,
                    tsb08     LIKE tsb_file.tsb08,
                    tsb09     LIKE tsb_file.tsb09,
                    tsb10     LIKE tsb_file.tsb10,
                    tsb11     LIKE tsb_file.tsb11,
                    tsb12     LIKE tsb_file.tsb12
                    END RECORD
DEFINE    l_flag    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_t1      STRING,  
          l_t2      STRING,  
          l_t3      STRING,  
          l_t4      STRING,  
          l_t5      STRING,  
          l_t6      STRING,  
          l_t7      STRING,  
          l_t8      STRING,  
          l_too02   LIKE too_file.too02,
          l_top02   LIKE top_file.top02,
          l_oaj02   LIKE oaj_file.oaj02,
          l_occ02   LIKE occ_file.occ02,
          l_azp02   LIKE azp_file.azp02,
          l_gec02   LIKE gec_file.gec02,
          l_tqa02   LIKE tqa_file.tqa02,
          l_tqa02a  LIKE tqa_file.tqa02,
          l_tqa02b  LIKE tqa_file.tqa02,
          l_tqa02c  LIKE tqa_file.tqa02,
          l_tqa02d  LIKE tqa_file.tqa02,
          l_tqa02e  LIKE tqa_file.tqa02,
          l_tqa02f  LIKE tqa_file.tqa02,
          l_tqa02g  LIKE tqa_file.tqa02,
          l_tqa02h  LIKE tqa_file.tqa02,
          l_tqb02   LIKE tqb_file.tqb02,
          l_azp     LIKE azp_file.azp03,
          l_sum     LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
          l_sum1    LIKE tsb_file.tsb06,             #No.FUN-680120 DECIMAL(20,6)
          l_sumt    LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
          l_total   LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
          l_totalt  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
          l_total1  LIKE tsb_file.tsb06              #No.FUN-680120 DECIMAL(20,6)
#No.FUN-710082--end  
#TQC-C10039--add--start---
   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
#TQC-C10039--add--end---
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tqxuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tqxgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND tqxgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqxuser', 'tqxgrup')
     #End:FUN-980030
 
      LET l_sql="SELECT UNIQUE tqx01,tqx02,tqx03,tqx04,tqx05,tqx06,tqx07,tqx08,",   
               "        tqx09,tqx10,tqx11,tqx12,tqx13,tqx15,tsa02,tsa03,tsa04,tsa05,",   
               "        tsa08,tqy03,tqy04,tqy05,tqy06,tqy36,tqy37,tqy38,tqz03,",
               "        tqz031,tqz04,tqz05,tqz06,tqz07,tqz08,tqz09,tqz10,tqz11,",
               "        tqz12,tqz13,tqz14,tqz15,tqz16,tqz17,tqz18,ima021",
               "  FROM tqx_file,tqy_file,tqz_file,tsa_file,OUTER ima_file ",
               " WHERE tqx01=tsa01 ",
               "   AND tqx01=tqy01 ",
               "   AND tqx01=tqz01 ",
               "   AND tqy02=tsa02 ",
               "   AND tqz02=tsa03 ",
               "   AND tqz_file.tqz03=ima_file.ima01 ",
               "   AND ",tm.wc CLIPPED,
               " ORDER BY tqx01,tsa02,tsa03 "
     PREPARE atmr233_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmr233_curs1 CURSOR FOR atmr233_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
     #No.FUN-710082--begin
     CALL cl_del_data(l_table) 
 
#    IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
#       THEN
#       LET l_name = g_rpt_name
#    ELSE
#       CALL cl_outnam('atmr233') RETURNING l_name
#    END IF
 
#    START REPORT atmr233_rep TO l_name
 
#    LET g_pageno = 0
     FOREACH atmr233_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       LET l_sum1 = 0
       SELECT SUM(tsb06) INTO l_sum1 FROM tsb_file WHERE tsb01=sr.tqx01
       IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
 
       SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01=sr.tqx03 AND tqa03='15'
       SELECT tqa02 INTO l_tqa02a FROM tqa_file WHERE tqa01=sr.tqx04 AND tqa03='17'
       SELECT tqa02 INTO l_tqa02b FROM tqa_file WHERE tqa01=sr.tqx13 AND tqa03='20'
       SELECT tqb02 INTO l_tqb02  FROM tqb_file WHERE tqb01=sr.tqx12
       SELECT gec02 INTO l_gec02  FROM gec_file WHERE gec01=sr.tqx08 AND gec011='2'
 
       LET g_plant_new=sr.tqy36
       CALL s_getdbs()
   
       LET l_sql="SELECT occ02",
                 #"  FROM ",g_dbs_new CLIPPED,"occ_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(g_plant_new, 'occ_file'), #FUN-A50102
                 " WHERE occ01='",sr.tqy03,"' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE imd_pre FROM l_sql                                                                                                       
       DECLARE imd_cs CURSOR FOR imd_pre                                                                                                
       OPEN imd_cs                                                                                                                      
       FETCH imd_cs INTO l_occ02 
       LET l_sql="SELECT too02",
                 #"  FROM ",g_dbs_new CLIPPED,"too_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(g_plant_new, 'too_file'), #FUN-A50102
                 " WHERE too01='",sr.tqy05,"' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE too_pre FROM l_sql                                                                                                       
       DECLARE too_cs CURSOR FOR too_pre                                                                                                
       OPEN too_cs                                                                                                                      
       FETCH too_cs INTO l_too02
       LET l_sql="SELECT top02",
                 #"  FROM ",g_dbs_new CLIPPED,"top_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(g_plant_new, 'top_file'), #FUN-A50102
                 " WHERE top01='",sr.tqy06,"' " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql  #FUN-A50102
       PREPARE top_pre FROM l_sql                                                                                                       
       DECLARE top_cs CURSOR FOR top_pre                                                                                                
       OPEN top_cs                                                                                                                      
       FETCH top_cs INTO l_top02 
       SELECT azp02 INTO l_azp02  FROM azp_file WHERE azp01=sr.tqy36
       SELECT tqa02 INTO l_tqa02c FROM tqa_file WHERE tqa01=sr.tqz10 AND tqa03='18'    
 
       LET l_sql="SELECT tsb03,tsb04,tsb05,tsb06,tsb08,tsb09,tsb10,tsb11,tsb12",
                 "  FROM tsb_file ",
                 " WHERE tsb01='",sr.tqx01,"' AND tsb03='",sr.tsa02,"'"
       PREPARE atmr233_prepare2 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
          EXIT PROGRAM 
       END IF
       DECLARE atmr233_curs2 CURSOR FOR atmr233_prepare2
       LET l_flag=0
       FOREACH atmr233_curs2 INTO sr2.*
       IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
       LET l_flag=1
       SELECT tqa02 INTO l_tqa02d FROM tqa_file WHERE tqa01=sr2.tsb04 AND tqa03='1'
       SELECT oaj02 INTO l_oaj02  FROM oaj_file WHERE oaj01=sr2.tsb05
       SELECT tqa02 INTO l_tqa02e FROM tqa_file WHERE tqa01=sr2.tsb08 AND tqa03='8'
       SELECT tqa02 INTO l_tqa02f FROM tqa_file WHERE tqa01=sr2.tsb10 AND tqa03='16'
       SELECT tqa02 INTO l_tqa02g FROM tqa_file WHERE tqa01=sr2.tsb09 AND tqa03='7'
 
#      OUTPUT TO REPORT atmr233_rep(sr.*)
          EXECUTE insert_prep USING sr.*,sr2.*,
                                    l_tqa02,l_tqa02a,l_tqa02b,l_tqb02,l_gec02,
                                    l_occ02,l_azp02,l_too02,l_top02,l_tqa02c,
                                    l_tqa02d,l_oaj02,l_tqa02e,l_tqa02f,l_tqa02g,
                                    l_sum1,"",l_img_blob,"N",""       #TQC-C10039 ADD "",l_img_blob,"N",""
           LET sr2.tsb04=''
           LET sr2.tsb05=''
           LET sr2.tsb06=''
           LET sr2.tsb08=''
           LET sr2.tsb09=''
           LET sr2.tsb10=''
           LET sr2.tsb11=''
           LET sr2.tsb12=''
         END FOREACH
         IF l_flag=0 AND cl_null(sr2.tsb04) THEN
            EXECUTE insert_prep USING sr.*,sr2.*,
                                    l_tqa02,l_tqa02a,l_tqa02b,l_tqb02,l_gec02,
                                    l_occ02,l_azp02,l_too02,l_top02,l_tqa02c,
                                    l_tqa02d,l_oaj02,l_tqa02e,l_tqa02f,l_tqa02g,
                                    l_sum1,"",l_img_blob,"N",""       #TQC-C10039 ADD "",l_img_blob,"N",""
            LET l_flag=1
         END IF
 
     END FOREACH
 
#    FINISH REPORT atmr233_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730113                    
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                 
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'tqx01,tqx02,tqx03,tqx04,tqx12,tqx13')  
        RETURNING tm.wc                                                           
     END IF                      
     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.a CLIPPED
#TQC-C10039--add--start---
     LET g_cr_table = l_table      #主報表的temp table名稱
     LET g_cr_apr_key_f = "tqx01"  #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--add--end---
   # CALL cl_prt_cs3(g_prog,l_sql,l_str)  #TQC-730113
     CALL cl_prt_cs3(g_prog,'atmr233',l_sql,l_str) 
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT atmr233_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#         sr2       RECORD
#                   tsb03     LIKE tsb_file.tsb03,
#                   tsb04     LIKE tsb_file.tsb04,
#                   tsb05     LIKE tsb_file.tsb05,
#                   tsb06     LIKE tsb_file.tsb06,
#                   tsb08     LIKE tsb_file.tsb08,
#                   tsb09     LIKE tsb_file.tsb09,
#                   tsb10     LIKE tsb_file.tsb10,
#                   tsb11     LIKE tsb_file.tsb11,
#                   tsb12     LIKE tsb_file.tsb12
#                   END RECORD,
#         sr        RECORD
#                   tqx01     LIKE tqx_file.tqx01,
#                   tqx02     LIKE tqx_file.tqx02,
#                   tqx03     LIKE tqx_file.tqx03,
#                   tqx04     LIKE tqx_file.tqx04,
#                   tqx05     LIKE tqx_file.tqx05,
#                   tqx06     LIKE tqx_file.tqx06,
#                   tqx07     LIKE tqx_file.tqx07,
#                   tqx08     LIKE tqx_file.tqx08,
#                   tqx09     LIKE tqx_file.tqx09,
#                   tqx10     LIKE tqx_file.tqx10,   
#                   tqx11     LIKE tqx_file.tqx11,
#                   tqx12     LIKE tqx_file.tqx12,
#                   tqx13     LIKE tqx_file.tqx13,
#                   tqx15     LIKE tqx_file.tqx15,
#                   tsa02     LIKE tsa_file.tsa02,
#                   tsa03     LIKE tsa_file.tsa03,
#                   tsa04     LIKE tsa_file.tsa04,
#                   tsa05     LIKE tsa_file.tsa05,
#                   tsa08     LIKE tsa_file.tsa08,
#                   tqy03     LIKE tqy_file.tqy03,
#                   tqy04     LIKE tqy_file.tqy04,
#                   tqy05     LIKE tqy_file.tqy05,
#                   tqy06     LIKE tqy_file.tqy06,
#                   tqy36     LIKE tqy_file.tqy36,
#                   tqy37     LIKE tqy_file.tqy37,
#                   tqy38     LIKE tqy_file.tqy38,
#                   tqz03     LIKE tqz_file.tqz03,
#                   tqz031    LIKE tqz_file.tqz031,
#                   tqz04     LIKE tqz_file.tqz04,
#                   tqz05     LIKE tqz_file.tqz05,
#                   tqz06     LIKE tqz_file.tqz06,
#                   tqz07     LIKE tqz_file.tqz07,
#                   tqz08     LIKE tqz_file.tqz08,
#                   tqz09     LIKE tqz_file.tqz09,
#                   tqz10     LIKE tqz_file.tqz10,
#                   tqz11     LIKE tqz_file.tqz11,
#                   tqz12     LIKE tqz_file.tqz12,
#                   tqz13     LIKE tqz_file.tqz13,
#                   tqz14     LIKE tqz_file.tqz14,
#                   tqz15     LIKE tqz_file.tqz15,
#                   tqz16     LIKE tqz_file.tqz16,
#                   tqz17     LIKE tqz_file.tqz17,
#                   tqz18     LIKE tqz_file.tqz18,
#                   ima021    LIKE ima_file.ima021
#                   END RECORD,
#         l_flag    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
#         l_t1      STRING,  
#         l_t2      STRING,  
#         l_t3      STRING,  
#         l_t4      STRING,  
#         l_t5      STRING,  
#         l_t6      STRING,  
#         l_t7      STRING,  
#         l_t8      STRING,  
#         l_too02   LIKE too_file.too02,
#         l_top02   LIKE top_file.top02,
#         l_oaj02   LIKE oaj_file.oaj02,
#         l_occ02   LIKE occ_file.occ02,
#         l_azp02   LIKE azp_file.azp02,
#         l_gec02   LIKE gec_file.gec02,
#         l_tqa02   LIKE tqa_file.tqa02,
#         l_tqa02a  LIKE tqa_file.tqa02,
#         l_tqa02b  LIKE tqa_file.tqa02,
#         l_tqa02c  LIKE tqa_file.tqa02,
#         l_tqa02d  LIKE tqa_file.tqa02,
#         l_tqa02e  LIKE tqa_file.tqa02,
#         l_tqa02f  LIKE tqa_file.tqa02,
#         l_tqa02g  LIKE tqa_file.tqa02,
#         l_tqa02h  LIKE tqa_file.tqa02,
#         l_tqb02   LIKE tqb_file.tqb02,
#         l_azp     LIKE azp_file.azp03,
#         l_sum     LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
#         l_sum1    LIKE tsb_file.tsb06,             #No.FUN-680120 DECIMAL(20,6)
#         l_sumt    LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
#         l_total   LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
#         l_totalt  LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
#         l_sql     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(1000)
#         l_total1  LIKE tsb_file.tsb06              #No.FUN-680120 DECIMAL(20,6)
#  DEFINE l_gfe03   LIKE gfe_file.gfe03
 
#  OUTPUT
#     TOP MARGIN 0
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN 5
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.tqx01,sr.tsa02,sr.tsa03
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_msg))/2+1),g_msg
#        PRINT g_head CLIPPED,pageno_total  
#        PRINT
#        PRINT g_dash[1,g_len]
#           SELECT tqa02 INTO l_tqa02  FROM tqa_file WHERE tqa01=sr.tqx03 AND tqa03='15'
#           SELECT tqa02 INTO l_tqa02a FROM tqa_file WHERE tqa01=sr.tqx04 AND tqa03='17'
#           SELECT tqa02 INTO l_tqa02b FROM tqa_file WHERE tqa01=sr.tqx13 AND tqa03='20'
#           SELECT tqb02 INTO l_tqb02  FROM tqb_file WHERE tqb01=sr.tqx12
#           SELECT gec02 INTO l_gec02  FROM gec_file WHERE gec01=sr.tqx08 AND gec011='2'
#        LET l_last_sw = 'n'
#           PRINT COLUMN 01,g_x[11] CLIPPED,sr.tqx01 CLIPPED,
#                 COLUMN 34,g_x[12] CLIPPED,sr.tqx03 CLIPPED,'  ',l_tqa02  CLIPPED,
#                 COLUMN 96,g_x[13] CLIPPED,sr.tqx04 CLIPPED,'  ',l_tqa02a CLIPPED
#           PRINT COLUMN 01,g_x[14] CLIPPED,sr.tqx02 CLIPPED,
#                 COLUMN 34,g_x[15] CLIPPED,sr.tqx13 CLIPPED,'  ',l_tqa02b CLIPPED,
#                 COLUMN 96,g_x[16] CLIPPED,sr.tqx06
#           PRINT COLUMN 01,g_x[17] CLIPPED,sr.tqx12 CLIPPED,'  ',l_tqb02  CLIPPED,
#                 COLUMN 34,g_x[18] CLIPPED,sr.tqx08 CLIPPED,'  ',l_gec02  CLIPPED,
#                 COLUMN 96,g_x[19] CLIPPED,sr.tqx09
#           PRINT COLUMN 01,g_x[20] CLIPPED,sr.tqx10
#           PRINT COLUMN 01,g_x[21] CLIPPED,sr.tqx11
#           PRINT COLUMN 01,g_x[22] CLIPPED,sr.tqx05
#           PRINT g_dash2[1,g_len]
#           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#           PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#           PRINTX name=H3 g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
#           PRINTX name=H4 g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58]
#           PRINT g_dash1
 
#     BEFORE GROUP OF sr.tqx01
#        SKIP TO TOP OF PAGE
         
#     BEFORE GROUP OF sr.tsa02
#     SELECT azp03 INTO l_azp FROM azp_File WHERE azp01=sr.tqy36
#        LET l_sql="SELECT occ02",
#                  "  FROM ",l_azp CLIPPED,"occ_file",
#                  " WHERE occ01=tqy03 " 
#        PREPARE imd_pre FROM l_sql                                                                                                       
#        DECLARE imd_cs CURSOR FOR imd_pre                                                                                                
#        OPEN imd_cs                                                                                                                      
#        FETCH imd_cs INTO l_occ02 
#        LET l_sql="SELECT too02",
#                  "  FROM ",l_azp CLIPPED,"too_file",
#                  " WHERE too01=tqy05 " 
#        PREPARE too_pre FROM l_sql                                                                                                       
#        DECLARE too_cs CURSOR FOR too_pre                                                                                                
#        OPEN too_cs                                                                                                                      
#        FETCH too_cs INTO l_too02
#        LET l_sql="SELECT top02",
#                  "  FROM ",l_azp CLIPPED,"top_file",
#                  " WHERE top01=tqy06 " 
#        PREPARE top_pre FROM l_sql                                                                                                       
#        DECLARE top_cs CURSOR FOR top_pre                                                                                                
#        OPEN top_cs                                                                                                                      
#        FETCH top_cs INTO l_top02 
#        SELECT azp02 INTO l_azp02  FROM azp_File WHERE azp01=sr.tqy36
#        SELECT tqa02 INTO l_tqa02c FROM tqa_File WHERE tqa01=tqz10 AND tqa03='18'    
#        LET l_t1=sr.tqy03 CLIPPED,'  ',l_occ02 CLIPPED 
#        LET l_t2=sr.tqy36 CLIPPED,'  ',l_azp02 CLIPPED
#        LET l_t3=sr.tqy05 CLIPPED,'  ',l_too02 CLIPPED
#        LET l_t4=sr.tqy06 CLIPPED,'  ',l_top02 CLIPPED
#        PRINTX name=D1 COLUMN g_c[31],sr.tsa02 USING '###&', 
#                       COLUMN g_c[32],l_t1 CLIPPED,
#                       COLUMN g_c[33],l_t2 CLIPPED,
#                       COLUMN g_c[34],l_t3 CLIPPED,
#                       COLUMN g_c[35],l_t4 CLIPPED,
#                       COLUMN g_c[36],sr.tqy38 CLIPPED,
#                       COLUMN g_c[37],sr.tqy37 CLIPPED
 
#     ON EVERY ROW
#        LET l_t5=sr.tsa03 CLIPPED,'  ',l_occ02 CLIPPED
#        LET l_t6=sr.tqz03 CLIPPED,'  ',sr.tqz18 CLIPPED
#        PRINTX name=D2  
#                       COLUMN g_c[39],l_t5 CLIPPED,
#                       COLUMN g_c[40],l_t6 CLIPPED,
#                       COLUMN g_c[41],sr.tqz04 CLIPPED,
#                       COLUMN g_c[42],sr.tqz06 CLIPPED,
#                       COLUMN g_c[43],sr.tqz11 CLIPPED,
#                       COLUMN g_c[44],sr.tqz16 CLIPPED
#        PRINTX name=D3 
#                       COLUMN g_c[46],sr.tsa05 CLIPPED,
#                       COLUMN g_c[47],sr.tqz031 CLIPPED,
#                       COLUMN g_c[48],sr.tqz05 CLIPPED,
#                       COLUMN g_c[49],sr.tqz07 CLIPPED,
#                       COLUMN g_c[50],sr.tqz09 CLIPPED,
#                       COLUMN g_c[51],sr.tqz15 CLIPPED
#        LET l_t7=sr.tqz08 CLIPPED,' ',sr.tsa04 CLIPPED
#        LET l_t8=sr.tqz10 CLIPPED,'  ',l_tqa02c CLIPPED
#        PRINTX name=D4  
#                       COLUMN g_c[53],sr.tsa08 CLIPPED,
#                       COLUMN g_c[54],sr.ima021 CLIPPED,
#                       COLUMN g_c[55],l_t7 CLIPPED,
#                       COLUMN g_c[56],l_t8 CLIPPED,
#                       COLUMN g_c[57],cl_numfor(sr.tqz12,57,3) CLIPPED,
#                       COLUMN g_c[58],cl_numfor(sr.tqz17,58,3) CLIPPED
#        PRINT 
 
#     AFTER GROUP OF sr.tsa02
#        LET l_sum = GROUP SUM(sr.tsa05)
#        LET l_sumt= GROUP SUM(sr.tsa08)
#        PRINT         
#        PRINT COLUMN 01,g_x[59] CLIPPED,l_sum
#        PRINT COLUMN 01,g_x[60] CLIPPED,l_sumt
#        PRINT g_dash2[1,g_len]
#        LET l_sql="SELECT tsb03,tsb04,tsb05,tsb06,tsb08,tsb09,tsb10,tsb11,tsb12",
#                  "  FROM tsb_file ",
#                  " WHERE tsb01='",sr.tqx01,"' AND tsb03='",sr.tsa02,"'"
#        PREPARE atmr233_prepare2 FROM l_sql
#        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#           EXIT PROGRAM 
#        END IF
#        DECLARE atmr233_curs2 CURSOR FOR atmr233_prepare2
#        FOREACH atmr233_curs2 INTO sr2.*
#        IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#        SELECT tqa02 INTO l_tqa02d FROM tqa_file WHERE tqa01=sr2.tsb04 AND tqa03='1'
#        SELECT oaj02 INTO l_oaj02  FROM oaj_file WHERE oaj01=sr2.tsb05
#        SELECT tqa02 INTO l_tqa02e FROM tqa_file WHERE tqa01=sr2.tsb08 AND tqa03='8'
#        SELECT tqa02 INTO l_tqa02f FROM tqa_file WHERE tqa01=sr2.tsb10 AND tqa03='16'
#        SELECT tqa02 INTO l_tqa02g FROM tqa_file WHERE tqa01=sr2.tsb09 AND tqa03='7'
#        SELECT sum(sr2.tsb06) INTO l_sum1 FROM tsb_file WHERE tsb03=sr2.tsb03 and tsb01=sr.tqx01
#        IF tm.a ='Y' THEN
#              PRINT COLUMN 10 ,g_x[61] CLIPPED,
#                    COLUMN 53 ,g_x[62] CLIPPED,
#                    COLUMN 100,g_x[63] CLIPPED,
#                    COLUMN 123,g_x[64] CLIPPED,
#                    COLUMN 168,g_x[65] CLIPPED,
#                    COLUMN 211,g_x[66] CLIPPED
#              PRINT COLUMN 123,g_x[67] CLIPPED,
#                    COLUMN 211,g_x[68] CLIPPED
#              PRINT COLUMN 10,'------------------------------------------ ----------------------------------------------',
#                              ' ---------------------- --------------------------------------------',
#                              ' ------------------------------------------ ----------'
#              PRINT COLUMN 10,sr2.tsb04 CLIPPED,'  ',l_tqa02d CLIPPED,
#                    COLUMN 53,sr2.tsb05 CLIPPED,'  ',l_oaj02 CLIPPED,
#                    COLUMN 100,sr2.tsb06 CLIPPED,
#                    COLUMN 123,sr2.tsb08 CLIPPED,'  ',l_tqa02e CLIPPED,
#                    COLUMN 168,sr2.tsb10 CLIPPED,'  ',l_tqa02f CLIPPED,
#                    COLUMN 211,sr2.tsb11
#              PRINT COLUMN 123,sr2.tsb09 CLIPPED,'  ',l_tqa02g CLIPPED,
#                    COLUMN 211,sr2.tsb12
#              PRINT COLUMN 01,g_x[69],
#                    COLUMN 100,l_sum1
#        END IF
#        END FOREACH
#              PRINT g_dash2[1,g_len]  
#        LET l_flag='N'
         
#     AFTER GROUP OF sr.tqx01  
#        LET l_total =GROUP SUM(sr.tsa05)
#        LET l_totalt=GROUP SUM(sr.tsa08)
#        SELECT SUM(tsb06) INTO l_total1 FROM tsb_file WHERE tsb01=sr.tqx01
#        IF cl_null(l_total)  THEN LET l_total =0 END IF
#        IF cl_null(l_totalt) THEN LET l_totalt=0 END IF
#        IF cl_null(l_total1) THEN LET l_total1=0 END IF
#        PRINT COLUMN 01,g_x[70] CLIPPED,l_total
#        PRINT COLUMN 01,g_x[71] CLIPPED,l_totalt
#        IF tm.a='Y' THEN
#           PRINT COLUMN 01,g_x[72] CLIPPED,l_total1
#        END IF
 
#     ON LAST ROW
#        PRINT 
#        PRINT g_dash[1,g_len]
#        LET l_flag='Y'
#        PRINT g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         
#     PAGE TRAILER
#        IF l_flag ='N' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE 
#        END IF
#        IF l_flag = 'N' THEN
#           IF g_memo_pagetrailer THEN
#              PRINT g_x[4]
#              PRINT g_memo
#           ELSE
#              PRINT
#              PRINT
#           END IF
#        ELSE
#           PRINT g_x[4]
#           PRINT g_memo
#        END IF
#END REPORT
#No.FUN-710082--end  

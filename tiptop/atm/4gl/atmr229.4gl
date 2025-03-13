# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: atmr229.4gl
# Descriptions...: 合約/訂單確認書
# Date & Author..: 06/03/08 By Ray
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-770088 07/07/31 By Rayven 打印全部時有空白頁，有時打印會超出長度
# Modify.........: No.TQC-810004 08/02/27 By baofei 報表輸出至 Crystal Reports功能
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/12 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:CHI-AB0028 10/11/18 By Summer 增加列印物返資料 
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C10039 12/01/16 By wangrr 整合單據列印EF簽核
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)           # Where condition
            a       LIKE type_file.chr1,             # Prog. Version..: '5.30.06-13.03.12(01)            # 列印現返資料
            b       LIKE type_file.chr1,             # Prog. Version..: '5.30.06-13.03.12(01)            # 列印費用資料
            d       LIKE type_file.chr1,             #CHI-AB0028 add                    # 列印物返資料
            c       LIKE type_file.chr1,             # Prog. Version..: '5.30.06-13.03.12(01)            # 列印使用系列資料
            more    LIKE type_file.chr1              # Prog. Version..: '5.30.06-13.03.12(01)            # Input more condition(Y/N)
            END RECORD
 DEFINE g_rpt_name  LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)  # For TIPTOP 串 EasyFlow
          g_po_no,g_ctn_no1,g_ctn_no2        LIKE bnb_file.bnb06             #No.FUN-680120 VARCHAR(20)    
 DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680120 INTEGER
 DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680120 SMALLINT
 DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
 DEFINE l_dbs_new       LIKE type_file.chr21         #No.FUN-680120 VARCHAR(21)
 DEFINE l_azp  RECORD LIKE azp_file.*
 #No.TQC-810004---Begin                                                                                                             
 DEFINE l_table        STRING,                                                                                                      
        l_table1       STRING,                                                                                                      
        l_table2       STRING,                                                                                                      
        l_table3       STRING,                                                                                                      
        l_table4       STRING,                                                                                                      
        l_table5       STRING, #CHI-AB0028 add                                                                                                   
        g_str          STRING,                                                                                                      
        g_sql          STRING                                                                                                       
 #No.TQC-810004---End    
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function

   #CHI-AB0028 add --start--
   LET g_pdate  = ARG_VAL(1)      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.d = ARG_VAL(10)
   LET tm.c = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)
   #CHI-AB0028 add --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#No.TQC-810004---Begin                                                                                                              
   LET g_sql = "tqp01.tqp_file.tqp01,",                                                                                             
               "tqp02.tqp_file.tqp02,",                                                                                             
               "tqp03.tqp_file.tqp03,",                                                                                             
               "tqp05.tqp_file.tqp05,",                                                                                             
               "tqp06.tqp_file.tqp06,",                                                                                             
               "tqp07.tqp_file.tqp07,",                                                                                             
               "tqp12.tqp_file.tqp12,",                                                                                             
               "tqp13.tqp_file.tqp13,",                                                                                             
               "tqp21.tqp_file.tqp21,",                                                                                             
               "tqp22.tqp_file.tqp22,",                                                                                             
               "tqa02.tqa_file.tqa02,",                                                                                             
               "tqa021.tqa_file.tqa02,",                                                                                            
               "gec02.gec_file.gec02,",
               "sign_type.type_file.chr1,",  #TQC-C10039 簽核方式
               "sign_img.type_file.blob,",   #TQC-C10039 簽核圖檔
               "sign_show.type_file.chr1,",  #TQC-C10039 是否顯示簽核資料(Y/N)
               "sign_str.type_file.chr1000"  #TQC-C10039 sign_str                                                                                               
   LET l_table = cl_prt_temptable('atmr229',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "tqq01.tqq_file.tqq01,",                                                                                             
               "tqq02.tqq_file.tqq02,",                                                                                             
               "tqq03.tqq_file.tqq03,",                                                                                             
               "tqq04.tqq_file.tqq04,",                                                                                             
               "tqq05.tqq_file.tqq05,",                                                                                             
               "tqq06.tqq_file.tqq06,",                                                                                             
               "azp02.azp_file.azp02,",                                                                                             
               "occ02.occ_file.occ02,",                                                                                             
               "too02.too_file.too02,",                                                                                             
               "top02.top_file.top02"                                                                                               
   LET l_table1 = cl_prt_temptable('atmr2291',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
   LET g_sql = "tqr01.tqr_file.tqr01,",                                                                                             
               "tqr02.tqr_file.tqr02,",                                                                                             
               "tqr03.tqr_file.tqr03,",                                                                                             
               "tqr04.tqr_file.tqr04,",                                                                                             
               "tqr05.tqr_file.tqr05,",                                                                                             
               "azi04.azi_file.azi04,",                                                                                             
               "azi07.azi_file.azi07,",                                                                                             
               "tqr_n.type_file.num10"                                                                                              
   LET l_table2 = cl_prt_temptable('atmr2292',g_sql) CLIPPED                                                                        
   IF l_table2 = -1 THEN EXIT PROGRAM END IF  
   LET g_sql = "tqs01.tqs_file.tqs01,",                                                                                             
               "tqs02.tqs_file.tqs02,",                                                                                             
               "tqs03.tqs_file.tqs03,",                                                                                             
               "tqs04.tqs_file.tqs04,",                                                                                             
               "tqs05.tqs_file.tqs05,",                                                                                             
               "tqs06.tqs_file.tqs06,",                                                                                             
               "tqs07.tqs_file.tqs07,",                                                                                             
               "tqs08.tqs_file.tqs08,",                                                                                             
               "tqs09.tqs_file.tqs09,",                                                                                             
               "tqa022.tqa_file.tqa02,",                                                                                            
               "azi07.azi_file.azi07,",                                                                                             
               "tqs_n.type_file.num10"                                                                                              
   LET l_table3 = cl_prt_temptable('atmr2293',g_sql) CLIPPED                                                                        
   IF l_table3 = -1 THEN EXIT PROGRAM END IF                                                                                        
   LET g_sql = "tqt01.tqt_file.tqt01,",                                                                                             
               "tqt02.tqt_file.tqt02,",                                                                                             
               "tqa023.tqa_file.tqa02,",                                                                                            
               "tqt_n.type_file.num10"                                                                                              
   LET l_table4 = cl_prt_temptable('atmr2294',g_sql) CLIPPED                                                                        
   IF l_table4 = -1 THEN EXIT PROGRAM END IF                                                                                        
#No.TQC-810004---End                     
   #CHI-AB0028 add --start--
   LET g_sql = "tqu14.tqu_file.tqu14,",                                                                                             
               "tqu02.tqu_file.tqu02,",                                                                                             
               "tqu03.tqu_file.tqu03,",                                                                                             
               "tqu04.tqu_file.tqu04,",                                                                                             
               "tqu05.tqu_file.tqu05,",                                                                                             
               "tqu07.tqu_file.tqu07,",                                                                                             
               "tqu06.tqu_file.tqu06,",                                                                                             
               "tqu08.tqu_file.tqu08,",                                                                                             
               "tqu09.tqu_file.tqu09,",                                                                                             
               "tqu11.tqu_file.tqu11,",                                                                                             
               "tqu12.tqu_file.tqu12,",                                                                                             
               "tqu_n.type_file.num10"                                                                                              
   LET l_table5 = cl_prt_temptable('atmr2295',g_sql) CLIPPED                                                                        
   IF l_table5 = -1 THEN EXIT PROGRAM END IF                                                                                        
   #CHI-AB0028 add --end--
  #CHI-AB0028 mark --start--
  #LET g_rpt_name = ''
  #INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.a ='Y'
  #LET tm.b ='Y'
  #LET tm.c ='Y'
  #LET tm.wc = ARG_VAL(1)
  #LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱
  #LET g_rep_user = ARG_VAL(3)
  #LET g_rep_clas = ARG_VAL(4)
  #LET g_template = ARG_VAL(5)
  #LET g_rpt_name = ARG_VAL(6)  #No.FUN-7C0078
  #CHI-AB0028 mark --end--

  #CHI-AB0028 mark --start-- 
  #IF cl_null(tm.wc) THEN
  # Prog. Version..: '5.30.06-13.03.12(0,0)             # Input print condition
  #ELSE LET tm.wc="tqp01= '",tm.wc CLIPPED,"'"
  #     CALL atmr229()                   # Read data and create out-file
  #END IF
  #CHI-AB0028 mark --end--
  #CHI-AB0028 add --start--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
        CALL atmr229_tm(0,0)             # Input print condition
   ELSE
        CALL atmr229()                   # Read data and create out-file
   END IF
  #CHI-AB0028 add --end--
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr229_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680120 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW atmr229_w AT p_row,p_col WITH FORM "atm/42f/atmr229"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
WHILE TRUE
   INITIALIZE tm.* TO NULL  #CHI-AB0028 add
   CONSTRUCT BY NAME tm.wc ON tqp01,tqp06,tqp07 
       BEFORE CONSTRUCT
         CALL cl_qbe_init()
       ON ACTION controlp
          CASE
             WHEN INFIELD(tqp01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_tqp02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqp01
                 NEXT FIELD tqp01
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr229_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF

   #CHI-AB0028 add --start--
   LET tm.a ='Y'
   LET tm.b ='Y'
   LET tm.d ='Y' 
   LET tm.c ='Y'
   LET tm.more = 'N'
   #CHI-AB0028 add --end--

   INPUT BY NAME tm.a,tm.b,tm.d,tm.c,tm.more WITHOUT DEFAULTS  #CHI-AB0028 add tm.d
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b 
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      #CHI-AB0028 add --start--
      AFTER FIELD d 
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
      #CHI-AB0028 add --end--
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr229_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr229'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr229','9031',1)
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
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'" , #CHI-AB0028 add
                         " '",tm.c CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,  #CHI-AB0028 mark
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'", #CHI-AB0028 add ,
                         " '",g_rpt_name CLIPPED,"'"  #CHI-AB0028 add
         CALL cl_cmdat('atmr229',g_time,l_cmd)    
      END IF
      CLOSE WINDOW atmr229_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr229()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr229_w
END FUNCTION
 
FUNCTION atmr229()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(3000)
          l_za05    LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)  
          sr        RECORD
                    tqp01     LIKE tqp_file.tqp01,
                    tqp02     LIKE tqp_file.tqp02,
                    tqp03     LIKE tqp_file.tqp03,
                    tqp05     LIKE tqp_file.tqp05,   
                    tqp06     LIKE tqp_file.tqp06,
                    tqp22     LIKE tqp_file.tqp22,
                    tqp07     LIKE tqp_file.tqp07,
                    tqp21     LIKE tqp_file.tqp21,
                    tqp12     LIKE tqp_file.tqp12,
                    tqp13     LIKE tqp_file.tqp13
                    END RECORD
#No.TQC-810004---Begin                                                                                                              
   DEFINE l_tqa02  LIKE tqa_file.tqa02                                                                                              
   DEFINE l_tqa021 LIKE tqa_file.tqa02                                                                                              
   DEFINE l_gec02  LIKE gec_file.gec02                                                                                              
   DEFINE l_azp02  LIKE azp_file.azp02                                                                                              
   DEFINE l_occ02  LIKE occ_file.occ02                                                                                              
   DEFINE l_too02  LIKE too_file.too02                                                                                              
   DEFINE l_top02  LIKE top_file.top02                                                                                              
   DEFINE l_tqa022 LIKE tqa_file.tqa02                                                                                              
   DEFINE l_tqa023 LIKE tqa_file.tqa02                                                                                              
   DEFINE l_tqq    RECORD LIKE tqq_file.*                                                                                           
   DEFINE l_tqr    RECORD LIKE tqr_file.*                                                                                           
   DEFINE l_tqs    RECORD LIKE tqs_file.*                                                                                           
   DEFINE l_tqu    RECORD LIKE tqu_file.*  #CHI-AB0028 add                                                                                         
   DEFINE l_tqt    RECORD LIKE tqt_file.*,                                                                                          
          l_tqq_n    LIKE type_file.num10,                                                                                          
          l_tqr_n    LIKE type_file.num10,                                                                                          
          l_tqs_n    LIKE type_file.num10,                                                                                          
          l_tqu_n    LIKE type_file.num10, #CHI-AB0028 add                                                                                         
          l_tqt_n    LIKE type_file.num10    
#TQC-C10039--add--start---
   DEFINE l_img_blob     LIKE type_file.blob  
   LOCATE l_img_blob IN MEMORY               
#TQC-C10039--add--end---
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "       #TQC-C10039 add 4?                                                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD      
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?,?,?,?,?,?,?,?,?,?) "                                                                                      
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
               " VALUES(?,?,?,?,?,?,?,?) "                                                                                          
   PREPARE insert_prep2 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_pre2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
      EXIT PROGRAM                                                                             
   END IF                                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                                 
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?) "                                                                                  
   PREPARE insert_prep3 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,                                                                 
               " VALUES(?,?,?,?) "                                                                                                  
   PREPARE insert_prep4 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep4:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
   #CHI-AB0028 add --start--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,                                                                 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?) "                                                                                  
   PREPARE insert_prep5 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep5:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
   #CHI-AB0028 add --end--
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)                                                                                                     
     CALL cl_del_data(l_table2)                                                                                                     
     CALL cl_del_data(l_table3)                                                                                                     
     CALL cl_del_data(l_table4)                                                                                                     
     CALL cl_del_data(l_table5) #CHI-AB0028 add                                                                                                    
#No.TQC-810004---End     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.TQC-810004
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tqpuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tqpgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND tqpgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqpuser', 'tqpgrup')
     #End:FUN-980030
 
      LET l_sql="SELECT tqp01,tqp02,tqp03,tqp05,tqp06,tqp22,",  
               "       tqp07,tqp21,tqp12,tqp13", 
               "  FROM tqp_file ",
               " WHERE ",tm.wc CLIPPED,
               " ORDER BY tqp01 "
     PREPARE atmr229_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM 
     END IF
     DECLARE atmr229_curs1 CURSOR FOR atmr229_prepare1
     IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#No.TQC-810004---Begin 
#     IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
#        THEN
#        LET l_name = g_rpt_name
#     ELSE
#        CALL cl_outnam('atmr229') RETURNING l_name
#     END IF
 
#     START REPORT atmr229_rep TO l_name
 
#     LET g_pageno = 0
#No.TQC-810004---End 
     FOREACH atmr229_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.TQC-810004---Begin                                                                                                              
         SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01=sr.tqp03 and tqa03='13'                                                
         SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01=sr.tqp05 and tqa03='20'                                               
         SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01=sr.tqp22 and gec011='2'                                                
            LET l_sql = "SELECT * ",                                                                                                
                          " FROM tqq_file ",                                                                                        
                          " WHERE tqq01 = '",sr.tqp01,"' "                                                                          
            PREPARE tqq_p1 FROM l_sql                                                                                               
            IF SQLCA.SQLCODE THEN CALL cl_err('tqq_p1',SQLCA.SQLCODE,1) END IF                                                      
            DECLARE tqq_c1  CURSOR FOR tqq_p1                                                                                       
            OPEN tqq_c1                                                                                                             
            FOREACH tqq_c1 INTO l_tqq.*                                                                                             
              SELECT COUNT(*) INTO l_tqq_n FROM tqq_file WHERE tqq01 = sr.tqp01                                                     
              IF l_tqq_n=0 THEN                                                                                                     
              ELSE                                                                                                                  
               SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=l_tqq.tqq06                                                      
               SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = l_tqq.tqq06                                                        
                LET l_dbs_new = FGL_GETENV("MSSQLAREA") CLIPPED,'_', l_azp.azp03 CLIPPED,'.dbo.'                                                                              
                  LET l_sql = "SELECT occ02 ",                                                                                      
                            #" FROM ",l_dbs_new CLIPPED,"occ_file ",  #FUN-A50102                                                                
                            " FROM ",cl_get_target_table(l_tqq.tqq06, 'occ_file'),  #FUN-A50102  
                            " WHERE occ01 = '",l_tqq.tqq03,"' "                                                                     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(l_sql, l_tqq.tqq06) RETURNING l_sql  #FUN-A50102
               PREPARE occ_p1 FROM l_sql           
               IF SQLCA.SQLCODE THEN CALL cl_err('occ_p1',SQLCA.SQLCODE,1) END IF                                                   
               DECLARE occ_c1  CURSOR FOR occ_p1                                                                                    
               OPEN occ_c1                                                                                                          
               FOREACH occ_c1 INTO l_occ02                                                                                          
               END FOREACH                                                                                                          
               CLOSE occ_c1                                                                                                         
               IF cl_null(l_tqq.tqq04) THEN                                                                                         
                  LET l_tqq.tqq04 = ' '                                                                                             
                  LET l_too02 = ' '                                                                                                 
                                                                                                                                    
               END IF                                                                                                               
               LET l_sql = "SELECT too02 ",                                                                                         
                            #" FROM ",l_dbs_new CLIPPED,"too_file ",  #FUN-A50102                                                                
                            " FROM ",cl_get_target_table(l_tqq.tqq06, 'too_file'),  #FUN-A50102
                            " WHERE too01 = '",l_tqq.tqq04,"' "                                                                     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(l_sql, l_tqq.tqq06) RETURNING l_sql  #FUN-A50102
               PREPARE too_p1 FROM l_sql                                                                                            
               IF SQLCA.SQLCODE THEN CALL cl_err('too_p1',SQLCA.SQLCODE,1) END IF                                                   
               DECLARE too_c1  CURSOR FOR too_p1                                                                                    
               OPEN too_c1                                                                                                          
               FOREACH too_c1 INTO l_too02                                                                                          
                                                                                                                                    
               END FOREACH                                                                                                          
               CLOSE too_c1               
               IF cl_null(l_tqq.tqq05) THEN                                                                                         
                  LET l_tqq.tqq05 = ' '                                                                                             
                  LET l_top02 = ' '                                                                                                 
                                                                                                                                    
               END IF                                                                                                               
               LET l_sql = "SELECT top02 ",                                                                                         
                            #" FROM ",l_dbs_new CLIPPED,"top_file ",  #FUN-A50102                                                                
                            " FROM ",cl_get_target_table(l_tqq.tqq06, 'top_file'),  #FUN-A50102  
                            " WHERE top01 = '",l_tqq.tqq05,"' "                                                                     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 	 CALL cl_parse_qry_sql(l_sql, l_tqq.tqq06) RETURNING l_sql  #FUN-A50102
               PREPARE top_p1 FROM l_sql                                                                                            
               IF SQLCA.SQLCODE THEN CALL cl_err('top_p1',SQLCA.SQLCODE,1) END IF                                                   
               DECLARE top_c1  CURSOR FOR top_p1                                                                                    
               OPEN top_c1                                                                                                          
               FOREACH top_c1 INTO l_top02                                                                                          
                                                                                                                                    
               END FOREACH                                                                                                          
               CLOSE top_c1                                                                                                         
                                                                                                                                    
              END IF                                                                                                                
              EXECUTE insert_prep1 USING  l_tqq.tqq01,                                                                              
                                          l_tqq.tqq02,l_tqq.tqq03,l_tqq.tqq04,                                                      
                                          l_tqq.tqq05,l_tqq.tqq06,l_azp02,                                                          
                                          l_occ02,l_too02,l_top02  
            END FOREACH                                                                                                             
            CLOSE tqq_c1                                                                                                            
            IF tm.a = 'Y' THEN                                                                                                      
                                                                                                                                    
                  LET l_sql = "SELECT * ",                                                                                          
                              " FROM tqr_file ",                                                                                    
                              " WHERE tqr01 = '",sr.tqp01,"' "                                                                      
                  PREPARE tqr_p1 FROM l_sql                                                                                         
                  IF SQLCA.SQLCODE THEN CALL cl_err('tqr_p1',SQLCA.SQLCODE,1) END IF                                                
                  DECLARE tqr_c1  CURSOR FOR tqr_p1                                                                                 
                  OPEN tqr_c1                                                                                                       
                  FOREACH tqr_c1 INTO l_tqr.*                                                                                       
                    SELECT COUNT(*) INTO l_tqr_n FROM tqr_file WHERE tqr01 = sr.tqp01                                               
                    EXECUTE insert_prep2 USING  l_tqr.tqr01,l_tqr.tqr02,l_tqr.tqr03,                                                
                                                l_tqr.tqr04,l_tqr.tqr05,t_azi04,                                                    
                                                t_azi07,l_tqr_n                                                                     
                  END FOREACH                                                                                                       
                  CLOSE tqr_c1                                                                                                      
                                                                                                                                    
            END IF                 
     IF tm.b = 'Y' THEN                                                                                                      
                                                                                                                                    
                  LET l_sql = "SELECT * ",                                                                                          
                              " FROM tqs_file ",                                                                                    
                              " WHERE tqs01 = '",sr.tqp01,"' "                                                                      
                  PREPARE tqs_p1 FROM l_sql                                                                                         
                  IF SQLCA.SQLCODE THEN CALL cl_err('tqs_p1',SQLCA.SQLCODE,1) END IF                                                
                  DECLARE tqs_c1  CURSOR FOR tqs_p1                                                                                 
                  OPEN tqs_c1                                                                                                       
                  FOREACH tqs_c1 INTO l_tqs.*                                                                                       
                     SELECT COUNT(*) INTO l_tqs_n FROM tqs_file WHERE tqs01 = sr.tqp01                                              
                     SELECT oaj02 INTO l_tqa022 FROM oaj_file WHERE oaj01=l_tqs.tqs03                                               
                     EXECUTE insert_prep3 USING  l_tqs.tqs01,l_tqs.tqs02,l_tqs.tqs03,                                               
                                                 l_tqs.tqs04,l_tqs.tqs05,l_tqs.tqs06,                                               
                                                 l_tqs.tqs07,l_tqs.tqs08,l_tqs.tqs09,                                               
                                                 l_tqa022,t_azi07,l_tqs_n                                                           
                  END FOREACH                                                                                                       
                CLOSE tqs_c1                                                                                                        
                                                                                                                                    
            END IF                                                                                                                  
          IF tm.c = 'Y' THEN                                                                                                        
                                                                                                                                    
                LET l_sql = "SELECT * ",                                                                                            
                              " FROM tqt_file ",                                                                                    
                              " WHERE tqt01 = '",sr.tqp01,"' "                                                                      
                PREPARE tqt_p1 FROM l_sql                                                                                           
                IF SQLCA.SQLCODE THEN CALL cl_err('tqt_p1',SQLCA.SQLCODE,1) END IF                                                  
                DECLARE tqt_c1  CURSOR FOR tqt_p1                                                                                   
                OPEN tqt_c1                                                                                                         
                FOREACH tqt_c1 INTO l_tqt.*                                                                                         
                  SELECT COUNT(*) INTO l_tqt_n FROM tqt_file WHERE tqt01 = sr.tqp01                                                 
                  SELECT tqa02 INTO l_tqa023 FROM tqa_file WHERE tqa01=l_tqt.tqt02 and tqa03='3'                                    
                  EXECUTE insert_prep4 USING  l_tqt.tqt01,l_tqt.tqt02,l_tqa023,l_tqt_n                                              
                END FOREACH                                                                                                         
                CLOSE tqt_c1                                                                                                        
                                                                                                                                    
          END IF                                                                                                                    
            #CHI-AB0028 add --start--
            IF tm.d = 'Y' THEN                                                                                                        
                LET l_sql = "SELECT * ",                                                                                            
                              " FROM tqu_file ",                                                                                    
                              " WHERE tqu01 = '",sr.tqp01,"' "                                                                      
                PREPARE tqu_p1 FROM l_sql                                                                                           
                IF SQLCA.SQLCODE THEN CALL cl_err('tqu_p1',SQLCA.SQLCODE,1) END IF                                                  
                DECLARE tqu_c1  CURSOR FOR tqu_p1                                                                                   
                OPEN tqu_c1                                                                                                         
                FOREACH tqu_c1 INTO l_tqu.*                                                                                         
                   SELECT COUNT(*) INTO l_tqu_n FROM tqu_file WHERE tqu01 = sr.tqp01                                                 
                   EXECUTE insert_prep5 USING  l_tqu.tqu14,l_tqu.tqu02,l_tqu.tqu03,                                               
                                               l_tqu.tqu04,l_tqu.tqu05,l_tqu.tqu07,                                               
                                               l_tqu.tqu06,l_tqu.tqu08,l_tqu.tqu09,                                               
                                               l_tqu.tqu11,l_tqu.tqu12,l_tqu_n      
                END FOREACH                                                                                                         
                CLOSE tqu_c1                                                                                                        
                                                                                                                                    
            END IF                                                                                                                    
            #CHI-AB0028 add --end--
        EXECUTE insert_prep USING sr.tqp01,sr.tqp02,sr.tqp03,sr.tqp05,sr.tqp06,                                                     
                                  sr.tqp07,sr.tqp12,sr.tqp13,sr.tqp21,sr.tqp22,                                                     
                                  l_tqa02,l_tqa021,l_gec02,"",l_img_blob,"N",""   #TQC-C10039 ADD "",l_img_blob,"N",""                                                                          
#       OUTPUT TO REPORT atmr229_rep(sr.*)                                                                                          
#No.TQC-810004---End      
     END FOREACH
#No.TQC-810004---Begin                                                                                                              
#     FINISH REPORT atmr229_rep                                                                                                     
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'tqp01,tqp06,tqp07')                                                                                   
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
      LET g_str=tm.wc ,";",tm.a,";",tm.b,";",tm.c,";",tm.d  #CHI-AB0028 add tm.d                                                                                   
                                                                                                                                    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",                                                         
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED, "|",                                                        
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table2 CLIPPED, "|",                                                        
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table3 CLIPPED, "|",                                                        
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table4 CLIPPED, "|", #CHI-AB0028 add ,"|",                                                              
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table5 CLIPPED       #CHI-AB0028 add 
#TQC-C10039--add--start---
     LET g_cr_table = l_table      #主報表的temp table名稱
     LET g_cr_apr_key_f = "tqp01"  #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--add--end---                                                      
   CALL cl_prt_cs3('atmr229','atmr229',l_sql,g_str)                                                                                 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                                                                   
#No.TQC-810004---End  
END FUNCTION
#No.TQC-810004---Begin 
#REPORT atmr229_rep(sr)
#   DEFINE l_tqa02  LIKE tqa_file.tqa02
#   DEFINE l_tqa021 LIKE tqa_file.tqa02
#   DEFINE l_gec02  LIKE gec_file.gec02
#   DEFINE l_azp02  LIKE azp_file.azp02
#   DEFINE l_occ02  LIKE occ_file.occ02
#  DEFINE l_too02  LIKE too_file.too02
#  DEFINE l_top02  LIKE top_file.top02
#  DEFINE l_tqa022 LIKE tqa_file.tqa02
#  DEFINE l_tqa023 LIKE tqa_file.tqa02
#  DEFINE l_tqq    RECORD LIKE tqq_file.*
#  DEFINE l_tqr    RECORD LIKE tqr_file.*
#  DEFINE l_tqs    RECORD LIKE tqs_file.*
#  DEFINE l_tqt    RECORD LIKE tqt_file.*
#  DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#         sr        RECORD
#                   tqp01     LIKE tqp_file.tqp01,
#                   tqp02     LIKE tqp_file.tqp02,
#                   tqp03     LIKE tqp_file.tqp03,
#                   tqp05     LIKE tqp_file.tqp05,   
#                   tqp06     LIKE tqp_file.tqp06,
#                   tqp22     LIKE tqp_file.tqp22,
#                   tqp07     LIKE tqp_file.tqp07,
#                   tqp21     LIKE tqp_file.tqp21,
#                   tqp12     LIKE tqp_file.tqp12,
#                   tqp13     LIKE tqp_file.tqp13
#                   END RECORD,         
#         l_n        LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         l_tqs04    LIKE bnb_file.bnb06,          #No.FUN-680120 VARCHAR(20)
#         l_sql      LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(800)
#         l_tqq_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         l_tqr_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         l_tqs_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         l_tqt_n    LIKE type_file.num10,         #No.FUN-680120 INTEGER
#         i          LIKE type_file.num10,         #No.FUN-680120 INTEGER #TQC-840066
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.tqp01
#
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2+1),g_company CLIPPED 
#        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED 
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        PRINT ' '
#        PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#              COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#        FOR i=1 TO g_len
#            LET g_dash[i,i]='='
#        END FOR 
#        PRINT g_dash
#  	 SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01=sr.tqp03 and tqa03='13'
#        SELECT tqa02 INTO l_tqa021 FROM tqa_file WHERE tqa01=sr.tqp05 and tqa03='20'
#        SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01=sr.tqp22 and gec011='2'
#                 
#        PRINT COLUMN 01,g_x[11] CLIPPED,sr.tqp01 CLIPPED,' ',sr.tqp02 CLIPPED,
#              COLUMN 40,g_x[12] CLIPPED,sr.tqp03,' ',l_tqa02 CLIPPED,
#              COLUMN 83,g_x[13] CLIPPED,sr.tqp05,' ',l_tqa021
#           
#        PRINT COLUMN 01,g_x[14] CLIPPED,sr.tqp06,
#              COLUMN 40,g_x[15] CLIPPED,sr.tqp22 CLIPPED,' ',l_gec02 CLIPPED
#   
#        PRINT COLUMN 01,g_x[16] CLIPPED,sr.tqp07 CLIPPED,
#              COLUMN 40,g_x[17] CLIPPED,sr.tqp21 CLIPPED,
#              COLUMN 83,g_x[18] CLIPPED,sr.tqp12
#                 
#        PRINT COLUMN 01,g_x[19] CLIPPED,sr.tqp13 CLIPPED
#                          
#        LET l_last_sw = 'n'
#            
#     BEFORE GROUP OF sr.tqp01
#        SKIP TO TOP OF PAGE
#        LET l_n = 0   
#        
#     ON EVERY ROW
#        IF l_n = 0 THEN
#           FOR i=1 TO g_len
#               IF i = g_len THEN
#                  PRINT '-'
#               ELSE
#                  PRINT '-';
#               END IF
#           END FOR 
#           PRINT COLUMN 01,g_x[20] CLIPPED,
#                 COLUMN 06,g_x[21] CLIPPED,
#              	  COLUMN 38,g_x[22] CLIPPED,
#                 COLUMN 80,g_x[23] CLIPPED,
#                 COLUMN 112,g_x[24] CLIPPED
#           PRINT '---- ------------------------------- ----------------------------------------- ------------------------------- -------------------------------'
#           LET l_n = l_n + 1
#           
#           LET l_sql = "SELECT * ",                         
#                	  " FROM tqq_file ",
#              		  " WHERE tqq01 = '",sr.tqp01,"' "
#           PREPARE tqq_p1 FROM l_sql
#           IF SQLCA.SQLCODE THEN CALL cl_err('tqq_p1',SQLCA.SQLCODE,1) END IF
#           DECLARE tqq_c1  CURSOR FOR tqq_p1
#           OPEN tqq_c1         
#           FOREACH tqq_c1 INTO l_tqq.*
#             SELECT COUNT(*) INTO l_tqq_n FROM tqq_file WHERE tqq01 = sr.tqp01
#             IF l_tqq_n=0 THEN
#             ELSE
#              SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=l_tqq.tqq06
#              PRINT COLUMN 01,l_tqq.tqq02 USING '###&',
#                    COLUMN 06,l_tqq.tqq06,' ',l_azp02 CLIPPED;
#              SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = l_tqq.tqq06
#               LET l_dbs_new = FGL_GETENV("MSSQLAREA") CLIPPED,'_', l_azp.azp03 CLIPPED,'.dbo.'
#   	       LET l_sql = "SELECT occ02 ",                         
#                           " FROM ",l_dbs_new CLIPPED,"occ_file ",
#              	            " WHERE occ01 = '",l_tqq.tqq03,"' " 
#              PREPARE occ_p1 FROM l_sql
#              IF SQLCA.SQLCODE THEN CALL cl_err('occ_p1',SQLCA.SQLCODE,1) END IF
#              DECLARE occ_c1  CURSOR FOR occ_p1
#              OPEN occ_c1
#              FOREACH occ_c1 INTO l_occ02
#                 PRINT COLUMN 38,l_tqq.tqq03,' ',l_occ02 CLIPPED;
#              END FOREACH
#              CLOSE occ_c1
#              IF cl_null(l_tqq.tqq04) THEN
#                 LET l_tqq.tqq04 = ' '
#                 LET l_too02 = ' '
#                 PRINT COLUMN 80,l_tqq.tqq04,' ',l_too02 CLIPPED;
#              END IF			 
#              LET l_sql = "SELECT too02 ",                         
#                 	    " FROM ",l_dbs_new CLIPPED,"too_file ",
#              		    " WHERE too01 = '",l_tqq.tqq04,"' "
#              PREPARE too_p1 FROM l_sql
#              IF SQLCA.SQLCODE THEN CALL cl_err('too_p1',SQLCA.SQLCODE,1) END IF
#              DECLARE too_c1  CURSOR FOR too_p1
#              OPEN too_c1         
#              FOREACH too_c1 INTO l_too02
#                      PRINT COLUMN 80,l_tqq.tqq04,' ',l_too02 CLIPPED;
#              END FOREACH
#              CLOSE too_c1
#              IF cl_null(l_tqq.tqq05) THEN
#                 LET l_tqq.tqq05 = ' '
#                 LET l_top02 = ' '
# #                 PRINT COLUMN 112,l_tqq.tqq05,' ',l_top02 CLIPPED   #No.TQC-770088
#                 PRINT COLUMN 112,l_tqq.tqq05,' ',l_top02 CLIPPED;  #No.TQC-770088 mark
#              END IF			 
#              LET l_sql = "SELECT top02 ",                         
#                	    " FROM ",l_dbs_new CLIPPED,"top_file ",
#              		    " WHERE top01 = '",l_tqq.tqq05,"' "
#              PREPARE top_p1 FROM l_sql
#              IF SQLCA.SQLCODE THEN CALL cl_err('top_p1',SQLCA.SQLCODE,1) END IF
#              DECLARE top_c1  CURSOR FOR top_p1
#              OPEN top_c1
#               FOREACH top_c1 INTO l_top02
# #                 PRINT COLUMN 112,l_tqq.tqq05,' ',l_top02 CLIPPED   #No.TQC-770088
#                 PRINT COLUMN 112,l_tqq.tqq05,' ',l_top02 CLIPPED;  #No.TQC-770088 mark
#              END FOREACH
#      	       CLOSE top_c1   
#              PRINT ''    #No.TQC-770088
#             END IF
# 	    END FOREACH    
#           CLOSE tqq_c1   
#           END IF
#           IF tm.a = 'Y' THEN
#              IF l_n = 1 THEN
#                 FOR i=1 TO g_len
#                   IF i = g_len THEN
#                      PRINT '-'
#                   ELSE
#                      PRINT '-';
#                   END IF
#                 END FOR 
#                 PRINT COLUMN 01,g_x[25] CLIPPED,
#             	        COLUMN 10,g_x[26] CLIPPED,
#                       COLUMN 38,g_x[27] CLIPPED,
#                 	COLUMN 66,g_x[28] CLIPPED
#                 PRINT '-------- -------------------------- -------------------------- ------------------'
#                 LET l_n = l_n + 1
#               
#               
#                 LET l_sql = "SELECT * ",                         
#                  	      " FROM tqr_file ",
#              		      " WHERE tqr01 = '",sr.tqp01,"' "
#        	  PREPARE tqr_p1 FROM l_sql
#        	  IF SQLCA.SQLCODE THEN CALL cl_err('tqr_p1',SQLCA.SQLCODE,1) END IF
#        	  DECLARE tqr_c1  CURSOR FOR tqr_p1
#          	  OPEN tqr_c1         
#        	  FOREACH tqr_c1 INTO l_tqr.*
#                   SELECT COUNT(*) INTO l_tqr_n FROM tqr_file WHERE tqr01 = sr.tqp01 
#                   IF l_tqr_n=0 THEN
#                      PRINT
#                      PRINT
#                   ELSE   
#                   IF l_tqr.tqr02 = '1' THEN LET l_tqr02 = g_x[39] END IF
#                   IF l_tqr.tqr02 = '2' THEN LET l_tqr02 = g_x[40] END IF
#                   IF l_tqr.tqr02 = '3' THEN LET l_tqr02 = g_x[41] END IF
#                   PRINT COLUMN 01,l_tqr02 CLIPPED,
#            	          COLUMN 10,cl_numfor(l_tqr.tqr03,25,t_azi04) CLIPPED,
#                         COLUMN 38,cl_numfor(l_tqr.tqr04,24,t_azi04) CLIPPED,
#                         COLUMN 66,cl_numfor(l_tqr.tqr05,15,t_azi07) CLIPPED
#                   END IF
#                 END FOREACH
#                 CLOSE tqr_c1                
#             END IF    
#           END IF  		  
#           IF tm.b = 'Y' THEN
#              IF tm.a = 'N' THEN LET l_n =2 END IF
#              IF l_n = 2 THEN
#                 FOR i=1 TO g_len
#                   IF i = g_len THEN
#                      PRINT '-'
#                   ELSE
#                      PRINT '-';
#                   END IF
#                 END FOR 
#                 PRINT COLUMN 01,g_x[20] CLIPPED,
#             	        COLUMN 06,g_x[29] CLIPPED,
#                       COLUMN 49,g_x[30] CLIPPED,
#                       COLUMN 61,g_x[31] CLIPPED,
#                	COLUMN 70,g_x[32] CLIPPED,
#                	COLUMN 79,g_x[33] CLIPPED,
#                	COLUMN 98,g_x[34] CLIPPED
#                 PRINT '---- ------------------------------------------ ----------- -------- -------- ------------------ --------'
#                 LET l_n = l_n + 1 	
#               
#                 LET l_sql = "SELECT * ",                         
#                	      " FROM tqs_file ",
#              		      " WHERE tqs01 = '",sr.tqp01,"' "
#        	  PREPARE tqs_p1 FROM l_sql
#        	  IF SQLCA.SQLCODE THEN CALL cl_err('tqs_p1',SQLCA.SQLCODE,1) END IF
#        	  DECLARE tqs_c1  CURSOR FOR tqs_p1
#        	  OPEN tqs_c1         
#        	  FOREACH tqs_c1 INTO l_tqs.*
#                    SELECT COUNT(*) INTO l_tqs_n FROM tqs_file WHERE tqs01 = sr.tqp01
#                    IF l_tqs_n=0 THEN
#                       PRINT
#                       PRINT
#                    ELSE   
#                    IF l_tqs.tqs04 = '1' THEN LET l_tqs04 = g_x[42] END IF
#                    IF l_tqs.tqs04 = '2' THEN LET l_tqs04 = g_x[43] END IF
#                    IF l_tqs.tqs04 = '3' THEN LET l_tqs04 = g_x[44] END IF
#                    IF l_tqs.tqs04 = '4' THEN LET l_tqs04 = g_x[45] END IF
#                    IF l_tqs.tqs04 = '5' THEN LET l_tqs04 = g_x[46] END IF
#                    IF l_tqs.tqs04 = '6' THEN LET l_tqs04 = g_x[47] END IF
#                    IF l_tqs.tqs04 = '7' THEN LET l_tqs04 = g_x[48] END IF
#                    SELECT oaj02 INTO l_tqa022 FROM oaj_file WHERE oaj01=l_tqs.tqs03    
#                    PRINT COLUMN 01,l_tqs.tqs02 USING '###&',
#                          COLUMN 06,l_tqs.tqs03,' ',l_tqa022 CLIPPED,
#                          COLUMN 49,l_tqs04 CLIPPED,
#                          COLUMN 61,l_tqs.tqs09 CLIPPED,
#                          COLUMN 70,l_tqs.tqs07 CLIPPED,
#                 	   COLUMN 79,cl_numfor(l_tqs.tqs08,17,t_azi07) CLIPPED,
#                 	   COLUMN 98,l_tqs.tqs06 CLIPPED
#                    PRINT COLUMN 06,l_tqs.tqs05 CLIPPED
#                  END IF
#               END FOREACH
#               CLOSE tqs_c1
#             END IF
#           END IF 
#           IF tm.c = 'Y' THEN
#              IF tm.a = 'N' OR tm.b = 'N' THEN LET l_n = 3 END IF
#              IF l_n = 3 THEN
#                 FOR i=1 TO g_len
#                   IF i = g_len THEN
#                      PRINT '-'
#                   ELSE
#                      PRINT '-';
#                   END IF
#                 END FOR 
#                 PRINT COLUMN 01,g_x[35] CLIPPED
#                 PRINT '----------------------------------------'
#                 LET l_n = l_n + 1
#               
#               LET l_sql = "SELECT * ",                         
#         		      " FROM tqt_file ",
#              		      " WHERE tqt01 = '",sr.tqp01,"' "
#        	PREPARE tqt_p1 FROM l_sql
#        	IF SQLCA.SQLCODE THEN CALL cl_err('tqt_p1',SQLCA.SQLCODE,1) END IF
#        	DECLARE tqt_c1  CURSOR FOR tqt_p1
#        	OPEN tqt_c1         
#        	FOREACH tqt_c1 INTO l_tqt.*
#                 SELECT COUNT(*) INTO l_tqt_n FROM tqt_file WHERE tqt01 = sr.tqp01
#                 IF l_tqt_n=0 THEN
#                    PRINT
#                    PRINT
#                 ELSE
#                    SELECT tqa02 INTO l_tqa023 FROM tqa_file WHERE tqa01=l_tqt.tqt02 and tqa03='3'
#               	PRINT COLUMN 01,l_tqt.tqt02,' ',l_tqa023 CLIPPED
#                 END IF
#                 END FOREACH
#               CLOSE tqt_c1
#           END IF
#           END IF   	  
 
#     ON LAST ROW
#           LET l_last_sw = 'y'
 
#     PAGE TRAILER
#           PRINT g_dash[1,g_len]
#           PRINT 
#           PRINT COLUMN 01,g_x[36] CLIPPED,
#                 COLUMN 30,g_x[37] CLIPPED,
#                 COLUMN 60,g_x[38] CLIPPED	
#           LET l_n = 0
          
#END REPORT
#No.TQC-810004---End
 

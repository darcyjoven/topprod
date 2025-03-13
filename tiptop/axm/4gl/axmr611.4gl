# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr611.4gl
# Descriptions...: 檢貨清單
# Date & Author..: 95/02/08 by Roger
# Modify.........: 01-04-06 BY ANN CHEN No.B316 1.不應包含作廢資料
# Modify.........: FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580004 05/08/08 By wujie 雙單位報表結構修改
# Modify.........: No.FUN-580121 05/08/22 by saki 報表背景執行功能
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-5A0060 06/06/15 By Sarah 增加列印ima02品名
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.FUN-7B0026 07/10/30 By baofei 報表輸出至Crystal Reports功能
# Modify.........: No.MOD-970094 09/07/16 By Smapmin 子報表多增加ogb03這個欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0186 09/10/30 By Smapmin 變數定義錯誤
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B60051 11/09/15 By pauline增加列印批序號明細
# Modify.........: No.MOD-BB0203 12/01/30 By Vampire 顯示批序號時會有重複
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004--begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580004--end
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING,                # Where condition
              a       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)              #
              b       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)              #
              c       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)              #
              d       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)              #
              e       LIKE type_file.chr1,        #FUN-B60051 add
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)              # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#FUN-580004--begin
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_sql            LIKE type_file.chr1000     #No.FUN-680137  VARCHAR(1000)
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
#FUN-580004--end
#No.FUN-7B0026---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       l_table1       STRING,                                                                                                       
       l_table2       STRING,                 #FUN-B60051 add
       g_str          STRING,                                                                                                       
       g_sql          STRING,                                                                                                       
       l_str2    LIKE type_file.chr1000                                                                                                        
#No.FUN-7B0026---End 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_lang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.c = ARG_VAL(10)
   LET tm.d = ARG_VAL(11)
#-----------No.TQC-610089 modify
  #LET tm.more = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(12)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(13)           #No.FUN-570264
   LET g_template = ARG_VAL(14)           #No.FUN-570264
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-580121 ---end---
#-----------No.TQC-610089 end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#No.FUN-7B0026---Begin                                                                                                              
   LET g_sql = "oga01.oga_file.oga01,",                                                                                           
               "oga011.oga_file.oga011,",                                                                                             
               "oga02.oga_file.oga02,",                                                                                             
               "oga03.oga_file.oga03,",                                                                                             
               "oga032.oga_file.oga032,",
               "oga17.oga_file.oga17,",                                                                                             
               "oga41.oga_file.oga41,",                                                                                             
               "oga42.oga_file.oga42,",                                                                                             
               "ogb03.ogb_file.ogb03,",                                                                                             
               "ogb04.ogb_file.ogb04,",                                                                                             
               "ogb05.ogb_file.ogb05,",                                                                                             
               "ogb06.ogb_file.ogb06,",                                                                                             
               "ogb092.ogb_file.ogb092,",                                                                                             
               "ogb16.ogb_file.ogb16,",                                                                                             
               "kgs.ogb_file.ogb16,",                                                                                             
               "l_str2.type_file.chr1000,",                                                                                             
               "ima02.ima_file.ima02,",     #MOD-9A0186 l_ima02-->ima02                                                                                           
               "ima021.ima_file.ima021,",   #MOD-9A0186 l_ima021-->ima021
               "l_addr.type_file.chr1000,",
               "order1.type_file.chr20"  
   LET l_table = cl_prt_temptable('axmr611',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "oga01.oga_file.oga01,",                                                                                             
               "ogb03.ogb_file.ogb03,",   #MOD-970094
               "l_msg1.occ_file.occ02,",                                                                                             
               "l_msg2.occ_file.occ02"                                                                                               
   LET l_table1 = cl_prt_temptable('axmr6111',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
#FUN-B60051 add START
   LET g_sql = "oga01.oga_file.oga01,",
               "ogb03.ogb_file.ogb03,",   #MOD-970094
               "rvbs04.rvbs_file.rvbs04,",
               "rvbs03.rvbs_file.rvbs03,",
               "rvbs06.rvbs_file.rvbs06"
   LET l_table2 = cl_prt_temptable('axmr6111',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
#FUN-B60051 add END
#No.FUN-7B0026---End   
 
   #No.FUN-580121 --start--
   IF cl_null(g_bgjob) OR g_bgjob = "N" THEN
      CALL axmr611_tm(0,0)             # Input print condition
   ELSE
      CALL axmr611()
   END IF
   #No.FUN-580121 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr611_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW axmr611_w AT p_row,p_col WITH FORM "axm/42f/axmr611"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a ='Y'
   LET tm.b ='Y'
   LET tm.c ='3'
   LET tm.d ='Y'
   LET tm.e = 'N'  #FUN-B60051 add
   #No.FUN-580121 ---end---
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga00,oga02,oga17,oga01,oga41,oga42,oga09
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr611_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.a,tm.b,tm.c,tm.d, tm.e,tm.more WITHOUT DEFAULTS   #FUN-B60051 add tm.e
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[123]' THEN NEXT FIELD c END IF
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
      AFTER FIELD e   #FUN-B60051  add
         IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN NEXT FIELD e END IF     #FUN-B60051  add
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr611_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr611'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr611','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
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
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'" ,
                       #------------No.TQC-610089 modify
                        #" '",tm.more CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
                       #------------No.TQC-610089 end
 
         CALL cl_cmdat('axmr611',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr611_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr611()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr611_w
END FUNCTION
 
FUNCTION axmr611()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
 #         l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
#No.FUN-7B0026---Begin
          l_img      RECORD                                                                                                          
                     img02     LIKE img_file.img02,                                                                                  
                     img03     LIKE img_file.img03,                                                                                  
                     img10     LIKE img_file.img10                                                                                   
                     END RECORD,
          l_ogb915   STRING,                                                                                                       
          l_ogb912   STRING,                       
          l_addr     LIKE type_file.chr1000,                                                                                 
          l_ima906   LIKE ima_file.ima906,  
          l_str      LIKE aaf_file.aaf03, 
          l_ima02    LIKE ima_file.ima02,                                                                     
          l_ima021   LIKE ima_file.ima021, 
          l_occ02    LIKE occ_file.occ02,                                                                                            
          l_gen02    LIKE type_file.chr8,                                                             
          l_gem02    LIKE type_file.chr8,                                                             
          i,j,k      LIKE type_file.num5,                                                            
          l_i,l_j,l_n  LIKE type_file.num5,
          l_msg1    LIKE occ_file.occ02,                                     
          l_msg2    LIKE occ_file.occ02, 
          l_buf1 DYNAMIC ARRAY OF RECORD                                                                                            
                 img10  LIKE img_file.img10,                                                                                        
                 img02  LIKE img_file.img02,                                                                                        
                 img03  LIKE img_file.img03                                                                                         
                 END RECORD,                                                                                                        
          l_buf2 DYNAMIC ARRAY OF RECORD                                                                                            
                 img10  LIKE img_file.img10,                                                                                        
                 img02  LIKE img_file.img02,                                                                                        
                 img03  LIKE img_file.img03                                                                                         
                 END RECORD,
#No.FUN-7B0026---End   
          sr        RECORD
                    order1    LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
                    oga01     LIKE oga_file.oga01,
                    oga02     LIKE oga_file.oga02,
                    oga011    LIKE oga_file.oga011,
                    oga03     LIKE oga_file.oga03,
                    oga032    LIKE oga_file.oga032,
                    oga04     LIKE oga_file.oga04,
                    oga044    LIKE oga_file.oga044,
                    oga14     LIKE oga_file.oga14,
                    oga15     LIKE oga_file.oga15,
                    oga17     LIKE oga_file.oga17,
                    oga41     LIKE oga_file.oga41,
                    oga42     LIKE oga_file.oga42,
                    ogb03     LIKE ogb_file.ogb03,
                    ogb04     LIKE ogb_file.ogb04,
                    ogb05     LIKE ogb_file.ogb05,
		    ogb06     LIKE ogb_file.ogb06,
                    ogb09     LIKE ogb_file.ogb09,
                    ogb091    LIKE ogb_file.ogb091,
                    ogb092    LIKE ogb_file.ogb092,
                    ogb12     LIKE ogb_file.ogb12,
                    ogb16     LIKE ogb_file.ogb16,
                    kgs       LIKE ogb_file.ogb16,
                    ogb17     LIKE ogb_file.ogb17,
                    ogb31     LIKE ogb_file.ogb31,
                    ogb32     LIKE ogb_file.ogb32,
                    ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                    ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                    ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                    ogb915    LIKE ogb_file.ogb915      #No.FUN-580004
                    END RECORD
DEFINE l_rvbs03  LIKE rvbs_file.rvbs03  #FUN-B60051 add
DEFINE l_rvbs04  LIKE rvbs_file.rvbs04  #FUN-B60051 add
DEFINE l_rvbs06  LIKE rvbs_file.rvbs06  #FUN-B60051 add
#No.FUN-7B0026---Begin                                                                                                              
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               #" VALUES(?,?,?) "    #MOD-970094                                                                                            
               " VALUES(?,?,?,?) "    #MOD-970094                                                                                            
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
#FUN-B60051 add START
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?) "    
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
#FUN-B60051 add END
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)                      
     CALL cl_del_data(l_table2)   #FUN-B60051 add                                                                            
#No.FUN-7B0026---End          
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr611'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-7B0026  
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT '',oga01,oga02,oga011,oga03,oga032,oga04,oga044,oga14,",
               "       oga15,oga17,oga41,oga42,",
               "       ogb03,ogb04,ogb05,ogb06,ogb09,ogb091,ogb092,",
               "       ogb12,ogb16,ogb16*ima18,ogb17,ogb31,ogb32,ogb910,ogb912,ogb913,ogb915",             #No.FUN-580004
               "  FROM oga_file,ogb_file, OUTER ima_file ",
               " WHERE oga01=ogb01 AND ogb_file.ogb04=ima_file.ima01",
               "   AND ogaconf !='X' ",     #No.B316
			   " AND ",tm.wc
	 LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "
     PREPARE axmr611_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr611_curs1 CURSOR FOR axmr611_prepare1
#No.FUN_7B0026---Begin
{
     CALL cl_outnam('axmr611') RETURNING l_name
#No.FUN-550070-begin
     LET g_len = 172
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550070-end
 
#FUN-580004--begin
     SELECT sma115 INTO g_sma115 FROM sma_file
     IF g_sma115 = "Y"  THEN
            LET g_zaa[39].zaa06 = "N"
     ELSE
            LET g_zaa[39].zaa06 = "Y"
     END IF
      CALL cl_prt_pos_len()
#No.FUN-580004--end
     START REPORT axmr611_rep TO l_name
 
     LET g_pageno = 0
}
     SELECT sma115 INTO g_sma115 FROM sma_file                                                                                      
     IF g_sma115 = "Y"  THEN                                                                                                        
        LET  l_name = 'axmr611'            
     ELSE                                                                                                                           
        LET  l_name = 'axmr611_1'                                                                                           
     END IF 
#No.FUN-7B0026---End
     FOREACH axmr611_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       CASE WHEN tm.c='1' LET sr.order1=sr.oga01
            WHEN tm.c='2' LET sr.order1=sr.oga41,sr.oga42
            OTHERWISE     LET sr.order1=sr.oga17
       END CASE
#No.FUN-7B0026---Begin
      LET l_occ02=NULL                                                                                                              
      LET l_gem02=NULL                                                                                                              
      LET l_gen02=NULL                                                                                                              
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oga04                                                                  
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14                                                                  
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15                                                                  
      SELECT oac02 INTO sr.oga41 FROM oac_file WHERE oac01=sr.oga41                                                                 
      SELECT oac02 INTO sr.oga42 FROM oac_file WHERE oac01=sr.oga42                                                                 
                                                                                                                                    
      LET l_str = sr.oga41 CLIPPED,'-',sr.oga42    
      IF sr.ogb04[1,4] !='MISC' THEN                                                                                                
         SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                                         
          WHERE ima01 = sr.ogb04                                                                                                    
      ELSE                                                                                                                          
         LET l_ima02  = ' '                                                                                    
         LET l_ima021 = ' '                                                                                                         
      END IF                                                                                                                        
                                                                                                                                    
      SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
                         WHERE ima01=sr.ogb04                                                                                       
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915                                                                   
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED                                                                           
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN                                                                         
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912                                                               
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED                                                                        
                ELSE 
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN                                                                 
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912                                                             
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED                                                   
                   END IF                                                                                                           
                END IF                                                                                                              
            WHEN "3"                                                                                                                
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN                                                                    
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915                                                               
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED                                                                       
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF   
      CALL l_buf1.clear()                                                                                                           
      CALL l_buf2.clear()                                                                                                           
                                                                                                                                    
      LET i = 0                                                                                                                     
      LET j = 0                                                                                                                     
      LET l_n = 0                                                                                                                   
      IF tm.a ='Y' THEN                                                                                                             
         IF sr.ogb17='N' THEN                                                                                                       
            LET i=1                                                                                                                 
            LET l_buf1[i].img10 = sr.ogb16                                                                                          
            LET l_buf1[i].img02 = sr.ogb09                                                                                          
            LET l_buf1[i].img03 = sr.ogb091                                                                                         
         ELSE                                                                                                                       
            IF sr.ogb17='Y' THEN                                                                                                    
               DECLARE r611_c2 CURSOR FOR                                                                                           
                 SELECT ogc09,ogc091,ogc16 FROM ogc_file                                                                            
                  WHERE ogc01 = sr.oga01 AND ogc03 = sr.ogb03                                                                       
               LET i = 1                                                                                                            
               FOREACH r611_c2 INTO l_img.*                                                                                         
                  IF STATUS THEN EXIT FOREACH END IF                                                                                
                  LET l_buf1[i].img10 = l_img.img10                                                                                 
                  LET l_buf1[i].img02 = l_img.img02                                                                                 
                  LET l_buf1[i].img03 = l_img.img03    
                  LET i = i + 1                                                                                                     
               END FOREACH                                                                                                          
               LET i = i - 1                                                                                                        
            END IF                                                                                                                  
         END IF                                                                                                                     
      END IF                                                                                                                        
      IF tm.b ='Y' THEN                                                                                                             
         LET l_sql=" SELECT img02,img03,img10,img28 FROM img_file ",                                                                
                   "  WHERE img01 = '",sr.ogb04 CLIPPED,"'",                                                                        
                   "    AND img10 > 0 AND img23='Y'",                                                                               
                   "  ORDER BY img28"                                                                                               
         IF NOT cl_null(sr.ogb092) THEN                                                                                             
            LET l_sql=l_sql CLIPPED," AND img04 ='",sr.ogb092,"'"                                                                   
         END IF                                                                                                                     
         PREPARE r611_p3 FROM l_sql                                                                                                 
         DECLARE r611_c3 CURSOR FOR r611_p3                                                                                         
         LET j = 1                                                                                                                  
         FOREACH r611_c3 INTO l_img.*, k                                                                                            
            IF STATUS THEN EXIT FOREACH END IF                                                                                      
            LET l_buf2[j].img10 = l_img.img10                                                                                       
            LET l_buf2[j].img02 = l_img.img02                                                                                       
            LET l_buf2[j].img03 = l_img.img03                                                                                       
            LET j=j+1           
         END FOREACH                                                                                                                
         LET j = j - 1                                                                                                              
      END IF                                                                                                                        

#FUN-B60051 add START
      IF tm.e ='Y' THEN
         LET l_sql=" SELECT rvbs04,rvbs03, rvbs06 FROM rvbs_file ",
                   "  WHERE rvbs01 = '",sr.oga01 CLIPPED,"'",
                   "    AND rvbs00 <> 'aqct800'",   #MOD-BB0203 add
                   "    AND rvbs02 = '",sr.ogb03 CLIPPED,"'"
         PREPARE r611_p4 FROM l_sql
         DECLARE r611_c4 CURSOR FOR r611_p4
         FOREACH r611_c4 INTO l_rvbs04, l_rvbs03, l_rvbs06
            IF STATUS THEN EXIT FOREACH END IF
            EXECUTE  insert_prep2 USING sr.oga01,sr.ogb03,l_rvbs04, l_rvbs03, l_rvbs06
         END FOREACH
      END IF
#FUN-B60051 add END
                                                                                                                                    
      LET l_n = i                                                                                                                   
      IF i < j THEN                                                                                                                 
         LET l_n = j                                                                                                                
      END IF                                                                                                                        
                                                                                                                                    
      IF l_n = 0  THEN 
         EXECUTE  insert_prep USING sr.oga01,sr.oga011,sr.oga02,sr.oga03,
                                    sr.oga032,sr.oga17,sr.oga41,sr.oga42,sr.ogb03,
                                    sr.ogb04,sr.ogb05,sr.ogb06,sr.ogb092,
                                    sr.ogb16,sr.kgs,l_str2,l_ima02,l_ima021,l_addr,sr.order1           
      ELSE        
            FOR l_i = 1 TO l_n                                                                                                      
                IF l_i = 2 THEN                                                                                                     
                   EXECUTE  insert_prep USING sr.oga01,sr.oga011,sr.oga02,sr.oga03,                                                 
                                              sr.oga032,sr.oga17,sr.oga41,sr.oga42,sr.ogb03,                                        
                                              sr.ogb04,sr.ogb05,sr.ogb06,sr.ogb092,                                                 
                                              sr.ogb16,sr.kgs,l_str2,l_ima02,l_ima021,l_addr,sr.order1                              
                END IF                                                                                                              
                LET l_msg1 = ''                                                                                                     
                LET l_msg2 = ''                                                                                                     
                LET l_msg1 = l_buf1[l_i].img10 USING '########',' ',                                                                
                             l_buf1[l_i].img02 CLIPPED,' ',                                                                         
                             l_buf1[l_i].img03 CLIPPED                                                                              
                LET l_msg2 = l_buf2[l_i].img10 USING '########',' ',                                                                
                             l_buf2[l_i].img02 CLIPPED,' ',                                                                         
                             l_buf2[l_i].img03 CLIPPED                                                                              
                    #EXECUTE  insert_prep1 USING sr.oga01,l_msg1,l_msg2    #MOD-970094                                                          
                    EXECUTE  insert_prep1 USING sr.oga01,sr.ogb03,l_msg1,l_msg2    #MOD-970094                                                          
            END FOR                                                                                                                       
         IF l_n = 1 THEN   
            EXECUTE  insert_prep USING sr.oga01,sr.oga011,sr.oga02,sr.oga03,                                                           
                                       sr.oga032,sr.oga17,sr.oga41,sr.oga42,sr.ogb03,                                                           
                                       sr.ogb04,sr.ogb05,sr.ogb06,sr.ogb092,                                                           
                                       sr.ogb16,sr.kgs,l_str2,l_ima02,l_ima021,l_addr,sr.order1                                                                                                   
         END IF                                                                                                                     
      END IF     
#       OUTPUT TO REPORT axmr611_rep(sr.*)
#No.FUN-7B0026---End
     END FOREACH
#No.FUN-7B0026---Begin
#     FINISH REPORT axmr611_rep
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'oga00,oga02,oga17,oga01,oga41,oga42,oga09')                                                                       
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
      LET g_str=tm.wc ,";",tm.d,";",tm.e    #FUN-B60051 add tm.e                   
                                                                                        
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",                                                         
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED, "|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table2 CLIPPED     #FUN-B60051 add                                                                                                                                 
   CALL cl_prt_cs3('axmr611','axmr611',l_sql,g_str)  
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7B0026---End
END FUNCTION
#No.FUN-7B0026
{
REPORT axmr611_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          l_buf1 DYNAMIC ARRAY OF RECORD
                 img10  LIKE img_file.img10,
                 img02  LIKE img_file.img02,
                 img03  LIKE img_file.img03
                 END RECORD,
          l_buf2 DYNAMIC ARRAY OF RECORD
                 img10  LIKE img_file.img10,
                 img02  LIKE img_file.img02,
                 img03  LIKE img_file.img03
                 END RECORD,
          sr        RECORD
                    order1    LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
                    oga01     LIKE oga_file.oga01,
                    oga02     LIKE oga_file.oga02,
                    oga011    LIKE oga_file.oga011,
                    oga03     LIKE oga_file.oga03,
                    oga032    LIKE oga_file.oga032,
                    oga04     LIKE oga_file.oga04,
                    oga044    LIKE oga_file.oga044,
                    oga14     LIKE oga_file.oga14,
                    oga15     LIKE oga_file.oga15,
                    oga17     LIKE oga_file.oga17,
                    oga41     LIKE oga_file.oga41,
                    oga42     LIKE oga_file.oga42,
                    ogb03     LIKE ogb_file.ogb03,
                    ogb04     LIKE ogb_file.ogb04,
                    ogb05     LIKE ogb_file.ogb05,
                    ogb06     LIKE ogb_file.ogb06,
                    ogb09     LIKE ogb_file.ogb09,
                    ogb091    LIKE ogb_file.ogb091,
                    ogb092    LIKE ogb_file.ogb092,
                    ogb12     LIKE ogb_file.ogb12,
                    ogb16     LIKE ogb_file.ogb16,
                    kgs       LIKE ogb_file.ogb16,
                    ogb17     LIKE ogb_file.ogb17,
                    ogb31     LIKE ogb_file.ogb31,
                    ogb32     LIKE ogb_file.ogb32,
                    ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                    ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                    ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                    ogb915    LIKE ogb_file.ogb915      #No.FUN-580004
                    END RECORD,
         l_img      RECORD
                    img02     LIKE img_file.img02,
                    img03     LIKE img_file.img03,
                    img10     LIKE img_file.img10
                    END RECORD,
         l_ima02    LIKE ima_file.ima02,   #FUN-5A0060 add
         l_ima021   LIKE ima_file.ima021,
         l_flag     LIKE type_file.chr1,      #No.FUN-680137 VARCHAR(1)
         l_str      LIKE aaf_file.aaf03,     # No.FUN-680137 VARCHAR(40)
         l_addr     LIKE type_file.chr1000,  # No.FUN-680137 VARCHAR(120)
         l_addr1    LIKE aaf_file.aaf03,     # No.FUN-680137 VARCHAR(36)
         l_addr2     LIKE aaf_file.aaf03,    # No.FUN-680137 VARCHAR(36)
         l_addr3     LIKE aaf_file.aaf03,    # No.FUN-680137 VARCHAR(36)
         l_occ02    LIKE occ_file.occ02,
         l_gen02    LIKE type_file.chr8,     # No.FUN-680137 VARCHAR(8)
         l_gem02    LIKE type_file.chr8,     # No.FUN-680137 VARCHAR(8)
         l_sql	    LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(1000)
         i,j,k      LIKE type_file.num5,      #No.FUN-680137 SMALLINT
         l_i,l_j,l_n  LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_rowno    LIKE type_file.num5,     # No.FUN-680137 SMALLINT
         l_ogb04092 LIKE type_file.chr1000   # No.FUN-680137 VARCHAR(50)
#No.FUN-580004--begin
   DEFINE  l_ogb915    STRING
   DEFINE  l_ogb912    STRING
   DEFINE  l_str2      STRING
   DEFINE  l_ima906    LIKE ima_file.ima906
#No.FUN-580004--end
   DEFINE  l_msg1     LIKE occ_file.occ02     # No.FUN-680137 VARCHAR(30)   #FUN-5A0060 add
   DEFINE  l_msg2     LIKE occ_file.occ02     # No.FUN-680137 VARCHAR(30)   #FUN-5A0060 add
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.oga01,sr.ogb03
  FORMAT
    PAGE HEADER
#FUN-580004--begin
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno= g_pageno+1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#         COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     PRINT g_dash[1,g_len]
#No.FUN-550070-begin
#  PRINT g_x[09],
#               COLUMN 47,g_x[10] CLIPPED,
#               COLUMN 87,g_x[11] CLIPPED,
#               COLUMN 126,g_x[12] CLIPPED,
#               COLUMN 166,g_x[13] CLIPPED
#  PRINT g_x[14],
#        g_x[15],
#               g_x[16],
#               g_x[17],
#               g_x[18] CLIPPED
#     LET l_last_sw = 'n'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT g_dash[1,g_len]
            PRINT g_x[31],
                  g_x[32],
                  g_x[33],
                  g_x[34],
                  g_x[35],
                  g_x[36],
                  g_x[37],
                  g_x[38],   #FUN-5A0060 add
                  g_x[39],
                  g_x[40],
                  g_x[41],
                  g_x[42],
                  g_x[43],
                  g_x[44]
          PRINT g_dash1
          LET l_last_sw = 'n'
#FUN-580004--end
    BEFORE GROUP OF sr.oga01
      LET l_occ02=NULL
      LET l_gem02=NULL
      LET l_gen02=NULL
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oga04
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
      SELECT oac02 INTO sr.oga41 FROM oac_file WHERE oac01=sr.oga41
      SELECT oac02 INTO sr.oga42 FROM oac_file WHERE oac01=sr.oga42
 
      LET l_str = sr.oga41 CLIPPED,'-',sr.oga42
#FUN-580004--begin
      PRINT COLUMN g_c[31],sr.oga01,
            COLUMN g_c[32],sr.oga02,
            COLUMN g_c[33],sr.oga41[1,6],
            COLUMN g_c[34],sr.oga03;
#     PRINT COLUMN 01,sr.oga01,
#           COLUMN 18,sr.oga02,
#           COLUMN 31,sr.oga41[1,6],
#           COLUMN 36,sr.oga03;
#No.FUN-580004--end
   ON EVERY ROW
 
      IF sr.ogb04[1,4] !='MISC' THEN
         SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file   #FUN-5A0060 add ima02
          WHERE ima01 = sr.ogb04
      ELSE
         LET l_ima02  = ' '   #FUN-5A0060 add
         LET l_ima021 = ' '
      END IF
 
#FUN-580004--begin
 
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      PRINT COLUMN g_c[35],sr.ogb03 USING '####',
            #COLUMN g_c[36],sr.ogb04[1,20],
            COLUMN g_c[36],sr.ogb04 CLIPPED, #NO.FUN-5B0015
            COLUMN g_c[37],sr.ogb06 CLIPPED,
            COLUMN g_c[39],l_str2 CLIPPED,
            COLUMN g_c[40],sr.ogb05 CLIPPED,
            COLUMN g_c[41],sr.ogb16 USING '###########&.##',
            COLUMN g_c[41],sr.kgs   USING '###########&.##';
#     PRINT COLUMN 47,sr.ogb03 USING '####',
#           COLUMN 52,sr.ogb04,
#           COLUMN 73,sr.ogb06 CLIPPED,
#           COLUMN 104,sr.ogb05 CLIPPED,
#           COLUMN 109,sr.ogb16 USING '########.##',
#           COLUMN 121,sr.kgs   USING '#######.##';
#FUN-580004--end
 
      CALL l_buf1.clear()
      CALL l_buf2.clear()
 
      LET i = 0
      LET j = 0
      LET l_n = 0
      IF tm.a ='Y' THEN
         IF sr.ogb17='N' THEN
            LET i=1
            LET l_buf1[i].img10 = sr.ogb16
            LET l_buf1[i].img02 = sr.ogb09
            LET l_buf1[i].img03 = sr.ogb091
         ELSE
            IF sr.ogb17='Y' THEN
               DECLARE r611_c2 CURSOR FOR
                 SELECT ogc09,ogc091,ogc16 FROM ogc_file
                  WHERE ogc01 = sr.oga01 AND ogc03 = sr.ogb03
               LET i = 1
               FOREACH r611_c2 INTO l_img.*
                  IF STATUS THEN EXIT FOREACH END IF
                  LET l_buf1[i].img10 = l_img.img10
                  LET l_buf1[i].img02 = l_img.img02
                  LET l_buf1[i].img03 = l_img.img03
                  LET i = i + 1
               END FOREACH
               LET i = i - 1
            END IF
         END IF
      END IF
      IF tm.b ='Y' THEN
         LET l_sql=" SELECT img02,img03,img10,img28 FROM img_file ",
                   "  WHERE img01 = '",sr.ogb04 CLIPPED,"'",
                   "    AND img10 > 0 AND img23='Y'",
                   "  ORDER BY img28"
         IF NOT cl_null(sr.ogb092) THEN
            LET l_sql=l_sql CLIPPED," AND img04 ='",sr.ogb092,"'"
         END IF
         PREPARE r611_p3 FROM l_sql
         DECLARE r611_c3 CURSOR FOR r611_p3
         LET j = 1
         FOREACH r611_c3 INTO l_img.*, k
            IF STATUS THEN EXIT FOREACH END IF
            LET l_buf2[j].img10 = l_img.img10
            LET l_buf2[j].img02 = l_img.img02
            LET l_buf2[j].img03 = l_img.img03
            LET j=j+1
         END FOREACH
         LET j = j - 1
      END IF
 
      LET l_n = i
      IF i < j THEN
         LET l_n = j
      END IF
 
      IF l_n = 0  THEN
         PRINT ''
#No.FUN-580004--begin
                PRINT COLUMN g_c[31],sr.oga011,
                      COLUMN g_c[33],sr.oga42[1,6],
                      COLUMN g_c[34],sr.oga032,
                      COLUMN g_c[36],sr.ogb092,
                      COLUMN g_c[37],l_ima02,   #FUN-5A0060 add 
                      COLUMN g_c[38],l_ima021
#               PRINT COLUMN 01,sr.oga011,
#                     COLUMN 29,sr.oga42[1,6],
#                     COLUMN 36,sr.oga032,
#                     COLUMN 52,sr.ogb092,
#                     COLUMN 73,l_ima021
#        PRINT COLUMN 01,sr.oga011,
#              COLUMN 29,sr.oga42[1,6],
#              COLUMN 36,sr.oga032,
#              COLUMN 52,sr.ogb092,
#              COLUMN 73,l_ima021
#No.FUN-580004--end
         IF tm.d='Y' THEN
            PRINT COLUMN 29,g_x[20] CLIPPED,l_addr CLIPPED
         END IF
      ELSE
         FOR l_i = 1 TO l_n
             IF l_i = 2 THEN
#No.FUN-580004--begin
                PRINT COLUMN g_c[31],sr.oga011,
                      COLUMN g_c[33],sr.oga42[1,6],
                      COLUMN g_c[34],sr.oga032,
                      COLUMN g_c[36],sr.ogb092,
                      COLUMN g_c[37],l_ima02,   #FUN-5A0060 add
                      COLUMN g_c[38],l_ima021
#               PRINT COLUMN 01,sr.oga011,
#                     COLUMN 29,sr.oga42[1,6],
#                     COLUMN 36,sr.oga032,
#                     COLUMN 52,sr.ogb092,
#                     COLUMN 73,l_ima021
#No.FUN-580004--end
             END IF
#No.FUN-580004--begin
            #start FUN-5A0060 modify
             LET l_msg1 = ''
             LET l_msg2 = ''
             LET l_msg1 = l_buf1[l_i].img10 USING '########',' ',
                          l_buf1[l_i].img02 CLIPPED,' ',
                          l_buf1[l_i].img03 CLIPPED 
             LET l_msg2 = l_buf2[l_i].img10 USING '########',' ',
                          l_buf2[l_i].img02 CLIPPED,' ',
                          l_buf2[l_i].img03 CLIPPED
             PRINT COLUMN g_c[43],l_msg1,
                   COLUMN g_c[44],l_msg2
            #PRINT COLUMN g_c[43],l_buf1[l_i].img10 USING '########',' ',
            #                     l_buf1[l_i].img02 CLIPPED,' ',
            #                     l_buf1[l_i].img03 CLIPPED,
            #      COLUMN g_c[44],l_buf2[l_i].img10 USING '########',' ',
            #                     l_buf2[l_i].img02 CLIPPED,' ',
            #                     l_buf2[l_i].img03 CLIPPED
            #end FUN-5A0060 modify
#            PRINT COLUMN 223,l_buf1[l_i].img10 USING '########',' ',
#                             l_buf1[l_i].img02 CLIPPED,' ',
#                             l_buf1[l_i].img03 CLIPPED,
#                  COLUMN 254,l_buf2[l_i].img10 USING '########',' ',
#                             l_buf2[l_i].img02 CLIPPED,' ',
#                             l_buf2[l_i].img03 CLIPPED
#No.FUN-580004--end
         END FOR
         IF l_n < 2 THEN
#No.FUN-580004--begin
                PRINT COLUMN g_c[31],sr.oga011,
                      COLUMN g_c[33],sr.oga42[1,6],
                      COLUMN g_c[34],sr.oga032,
                      COLUMN g_c[36],sr.ogb092,
                      COLUMN g_c[37],l_ima02,   #FUN-5A0060 add
                      COLUMN g_c[38],l_ima021
#               PRINT COLUMN 01,sr.oga011,
#                     COLUMN 29,sr.oga42[1,6],
#                     COLUMN 36,sr.oga032,
#                     COLUMN 52,sr.ogb092,
#                     COLUMN 73,l_ima021
         END IF
         IF tm.d='Y' THEN
#           PRINT COLUMN 29,g_x[20] CLIPPED,l_addr CLIPPED
            PRINT COLUMN g_c[33],g_x[9] CLIPPED,l_addr CLIPPED
         END IF
      END IF
 
   AFTER GROUP OF sr.oga01
      PRINT COLUMN g_c[36],g_x[10],
            COLUMN g_c[41],GROUP SUM(sr.ogb16) USING'##########$&.##',#No.TQC-6A0087 USING'###########$.##'
            COLUMN g_c[42],GROUP SUM(sr.kgs) USING'##########$&.##'   #No.TQC-6A0087 USING'###########$.##'
#     PRINT COLUMN 52,g_x[19] CLIPPED,
#    COLUMN 108,GROUP SUM(sr.ogb16) USING '#########.##',
#           COLUMN 120,GROUP SUM(sr.kgs  ) USING '########.##'
#No.FUN-580004--end
      PRINT
#No.FUN-550070-end
 
   ON LAST ROW
      #是否列印選擇條件
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
## FUN-550127
     #PRINT COLUMN 01,g_x[04] CLIPPED,
     #      COLUMN 41,g_x[05] CLIPPED,
     #      COLUMN 81,g_x[21] CLIPPED,
     #      COLUMN 121,g_x[22] CLIPPED
      LET l_last_sw = 'y'
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
        #PRINT COLUMN 01,g_x[04] CLIPPED,
        #      COLUMN 41,g_x[05] CLIPPED,
        #      COLUMN 81,g_x[21] CLIPPED,
        #      COLUMN 121,g_x[22] CLIPPED
      ELSE
         SKIP 1 LINE
      END IF
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[4]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[4]
             PRINT g_memo
      END IF
## END FUN-550127
 
END REPORT
}
#No.FUN-7B0026---End

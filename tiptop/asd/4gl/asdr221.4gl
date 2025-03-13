# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdr221.4gl
# Descriptions...: 在製品明細表
# Date & Author..: 99/03/24 By Eric
# Modify.........: No.FUN-510037 05/01/24 By pengu 報表轉XML
# Modify.........: No.MOD-530125  05/03/17 By Carol QBE欄位順序調整
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-770001 07/07/02 By sherry "幫助"按鈕為灰色，不可使用
# Modify.........: No.FUN-850155 08/06/10 By destiny 報表改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              jump    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          tr  RECORD
              ste05     LIKE cre_file.cre08,         #No.FUN-690010char(10),          
              ste06     LIKE oqu_file.oqu12,         #No.FUN-690010decimal(12,2),     
              ste07     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),     
              ste08     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),     
              ste09     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste10     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste11     LIKE oqu_file.oqu12,         #No.FUN-690010decimal(12,2),    
              ste12     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),      
              ste13     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),      
              ste14     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),      
              ste15     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),      
              ste16     LIKE oqu_file.oqu12,         #No.FUN-690010decimal(12,2),     
              ste17     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste18     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste19     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste20     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste22     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste23     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),    
              ste24     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),   
              ste25     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),   
              ste26     LIKE oqu_file.oqu12,         #No.FUN-690010decimal(12,2),     
              ste27     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),     
              ste28     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),     
              ste29     LIKE alb_file.alb06,         #No.FUN-690010decimal(20,6),     
              ste30     LIKE alb_file.alb06          #No.FUN-690010decimal(20,6)      
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#No.FUN-850155--begin--                                                                                                             
DEFINE   g_sql           STRING                                                                                                     
DEFINE   l_table         STRING                                                                                                     
DEFINE   g_sql1          STRING                                                                                                     
DEFINE   g_sql2          STRING                                                                                                     
DEFINE   l_table1        STRING                                                                                                     
DEFINE   l_table2        STRING                                                                                                     
DEFINE   g_str           STRING                                                                                                     
#No.FUN-850155--end--
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80062    ADD #FUN-BB0047 mark
#No.FUN-850155--begin--
   LET g_sql ="ste05.ste_file.ste05,",
              "ima02.ima_file.ima02,",
              "ste04.ste_file.ste04,",
              "sfb08.sfb_file.sfb08,",
              "ste06.ste_file.ste06,",
              "ste11.ste_file.ste11,",
              "ste16.ste_file.ste16,", 
              "ste26.ste_file.ste26,",
              "ste07.ste_file.ste07,",
              "ste12.ste_file.ste12,",
              "ste17.ste_file.ste17,",
              "ste22.ste_file.ste22,",
              "ste27.ste_file.ste27,",
              "ste08.ste_file.ste08,",
              "ste13.ste_file.ste13,",
              "ste18.ste_file.ste18,",
              "ste23.ste_file.ste23,",
              "ste28.ste_file.ste28,",
              "ste09.ste_file.ste09,",
              "ste14.ste_file.ste14,",
              "ste19.ste_file.ste19,",
              "ste24.ste_file.ste24,",
              "ste29.ste_file.ste29,",
              "ste10.ste_file.ste10,",
              "ste15.ste_file.ste15,",
              "ste20.ste_file.ste20,",
              "ste25.ste_file.ste25,",
              "ste30.ste_file.ste30,",
              "ima12.ima_file.ima12,",
              "ima131.ima_file.ima131"
   LET l_table = cl_prt_temptable('asdr221',g_sql) CLIPPED                                                                          
   IF l_table=-1 THEN EXIT PROGRAM END IF     
   LET g_sql1="ste04.ste_file.ste04,",
              "ste05.ste_file.ste05,",
              "ste06.ste_file.ste06,",                                                                                              
              "ste11.ste_file.ste11,",                                                                                              
              "ste16.ste_file.ste16,",                                                                                              
              "ste26.ste_file.ste26,",                                                                                              
              "ste07.ste_file.ste07,",                                                                                              
              "ste12.ste_file.ste12,",                                                                                              
              "ste17.ste_file.ste17,",                                                                                              
              "ste22.ste_file.ste22,",                                                                                              
              "ste27.ste_file.ste27,",                                                                                              
              "ste08.ste_file.ste08,",                                                                                              
              "ste13.ste_file.ste13,",                                                                                              
              "ste18.ste_file.ste18,",                                                                                              
              "ste23.ste_file.ste23,",                                                                                              
              "ste28.ste_file.ste28,",                                                                                              
              "ste09.ste_file.ste09,",                                                                                              
              "ste14.ste_file.ste14,", 
              "ste19.ste_file.ste19,",                                                                                              
              "ste24.ste_file.ste24,",                                                                                              
              "ste29.ste_file.ste29,",                                                                                              
              "ste10.ste_file.ste10,",                                                                                              
              "ste15.ste_file.ste15,",                                                                                              
              "ste20.ste_file.ste20,",                                                                                              
              "ste25.ste_file.ste25,",                                                                                              
              "ste30.ste_file.ste30"
   LET l_table1 = cl_prt_temptable('asdr2211',g_sql1) CLIPPED                                                                          
   IF l_table1=-1 THEN EXIT PROGRAM END IF
   LET g_sql2="ste04.ste_file.ste04,",                                                                                              
              "ste05.ste_file.ste05,",                                                                                              
              "ste06.ste_file.ste06,",                                                                                              
              "ste11.ste_file.ste11,",                                                                                              
              "ste16.ste_file.ste16,",                                                                                              
              "ste26.ste_file.ste26,",                                                                                              
              "ste07.ste_file.ste07,",                                                                                              
              "ste12.ste_file.ste12,",
              "ste17.ste_file.ste17,",                                                                                              
              "ste22.ste_file.ste22,",                                                                                              
              "ste27.ste_file.ste27,",                                                                                              
              "ste08.ste_file.ste08,",                                                                                              
              "ste13.ste_file.ste13,",                                                                                              
              "ste18.ste_file.ste18,",                                                                                              
              "ste23.ste_file.ste23,",                                                                                              
              "ste28.ste_file.ste28,",                                                                                              
              "ste09.ste_file.ste09,",                                                                                              
              "ste14.ste_file.ste14,",
              "ste19.ste_file.ste19,",                                                                                              
              "ste24.ste_file.ste24,",                                                                                              
              "ste29.ste_file.ste29,",                                                                                              
              "ste10.ste_file.ste10,",                                                                                              
              "ste15.ste_file.ste15,",                                                                                              
              "ste20.ste_file.ste20,",                                                                                              
              "ste25.ste_file.ste25,",                                                                                              
              "ste30.ste_file.ste30"                                                                                                
   LET l_table2 = cl_prt_temptable('asdr2212',g_sql2) CLIPPED                                                                       
   IF l_table2=-1 THEN EXIT PROGRAM END IF
#No.FUN-850155--end--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610079-begin
   LET tm.yea = ARG_VAL(8)
   LET tm.mo  = ARG_VAL(9)
   LET tm.jump = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610079-end
   #-->依產品分類
#No.FUN-690010----Begin----
#   CREATE TEMP TABLE r221_tmp
#    (
#     ima131    VARCHAR(10), 
#     ste06     decimal(12,2),     
#     ste07     decimal(20,6),     
#     ste08     decimal(20,6),     
#     ste09     decimal(20,6),    
#     ste10     decimal(20,6),    
#     ste11     decimal(12,2),    
#     ste12     decimal(20,6),      
#     ste13     decimal(20,6),      
#     ste14     decimal(20,6),      
#     ste15     decimal(20,6),      
#     ste16     decimal(12,2),      
#     ste17     decimal(20,6),      
#     ste18     decimal(20,6),      
#     ste19     decimal(20,6),      
#     ste20     decimal(20,6),      
#     ste22     decimal(20,6),      
#     ste23     decimal(20,6),      
#     ste24     decimal(20,6),      
#     ste25     decimal(20,6),      
#     ste26     decimal(12,2),     
#     ste27     decimal(20,6),     
#     ste28     decimal(20,6),     
#     ste29     decimal(20,6),     
#     ste30     decimal(20,6)      
#    );
   CREATE TEMP TABLE r221_tmp(
     ima131    LIKE ima_file.ima131,
     ste06     LIKE ste_file.ste06,
     ste07     LIKE type_file.num20_6,
     ste08     LIKE type_file.num20_6,
     ste09     LIKE type_file.num20_6,
     ste10     LIKE type_file.num20_6,
     ste11     LIKE ste_file.ste11,
     ste12     LIKE type_file.num20_6,
     ste13     LIKE type_file.num20_6,
     ste14     LIKE type_file.num20_6,
     ste15     LIKE type_file.num20_6,
     ste16     LIKE ste_file.ste16,
     ste17     LIKE type_file.num20_6,
     ste18     LIKE type_file.num20_6,
     ste19     LIKE type_file.num20_6,
     ste20     LIKE type_file.num20_6,
     ste22     LIKE type_file.num20_6,
     ste23     LIKE type_file.num20_6,
     ste24     LIKE type_file.num20_6,
     ste25     LIKE type_file.num20_6,
     ste26     LIKE ste_file.ste26,
     ste27     LIKE type_file.num20_6,
     ste28     LIKE type_file.num20_6,
     ste29     LIKE type_file.num20_6,
     ste30     LIKE type_file.num20_6);
    
#No.FUN-690010------End--------
     create unique index r221_tmp  on r221_tmp(ima131) 
 
   #-->依成本分群
#No.FUN-690010-----Begin------
#   CREATE TEMP TABLE r221_tmp2
#    (
#     ima12     VARCHAR(04), 
#     ste06     decimal(12,2),     
#     ste07     decimal(20,6),     
#     ste08     decimal(20,6),     
#     ste09     decimal(20,6),    
#     ste10     decimal(20,6),    
#     ste11     decimal(12,2),    
#     ste12     decimal(20,6),      
#     ste13     decimal(20,6),      
#     ste14     decimal(20,6),      
#     ste15     decimal(20,6),      
#     ste16     decimal(12,2),      
#     ste17     decimal(20,6),      
#     ste18     decimal(20,6),      
#     ste19     decimal(20,6),      
#     ste20     decimal(20,6),      
#     ste22     decimal(20,6),      
#     ste23     decimal(20,6),      
#     ste24     decimal(20,6),      
#     ste25     decimal(20,6),      
#     ste26     decimal(12,2),     
#     ste27     decimal(20,6),     
#     ste28     decimal(20,6),     
#     ste29     decimal(20,6),     
#     ste30     decimal(20,6)      
#    );
   CREATE TEMP TABLE r221_tmp2(
     ima12     LIKE ima_file.ima12,
     ste06     LIKE ste_file.ste06,
     ste07     LIKE type_file.num20_6,
     ste08     LIKE type_file.num20_6,
     ste09     LIKE type_file.num20_6,
     ste10     LIKE type_file.num20_6,
     ste11     LIKE ste_file.ste11,
     ste12     LIKE type_file.num20_6,
     ste13     LIKE type_file.num20_6,
     ste14     LIKE type_file.num20_6,
     ste15     LIKE type_file.num20_6,
     ste16     LIKE ste_file.ste16,
     ste17     LIKE type_file.num20_6,
     ste18     LIKE type_file.num20_6,
     ste19     LIKE type_file.num20_6,
     ste20     LIKE type_file.num20_6,
     ste22     LIKE type_file.num20_6,
     ste23     LIKE type_file.num20_6,
     ste24     LIKE type_file.num20_6,
     ste25     LIKE type_file.num20_6,
     ste26     LIKE type_file.num20_6,
     ste27     LIKE type_file.num20_6,
     ste28     LIKE type_file.num20_6,
     ste29     LIKE type_file.num20_6,
     ste30     LIKE type_file.num20_6);
 
#No.FUN-690010------End--------    
     create unique index r221_tmp2  on r221_tmp2(ima12) 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN         # If background job sw is off
      CALL asdr221_tm()        # Input print condition
   ELSE 
      CALL asdr221()           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr221_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW asdr221_w AT p_row,p_col WITH FORM "asd/42f/asdr221" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.mo   = MONTH(g_today)
   LET tm.more = 'N'
   LET tm.jump = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 #MOD-530125
     CONSTRUCT BY NAME tm.wc ON ste04,ima131,ima12 
##
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
       ON ACTION help              #No.TQC-770001                                            
          CALL cl_show_help()      #No.TQC-770001
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
  
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
 
     INPUT BY NAME tm.yea,tm.mo,tm.jump,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD yea
           IF NOT cl_null(tm.yea) THEN
              IF tm.yea=0 THEN
                 NEXT FIELD yea
              END IF
           END IF
        AFTER FIELD mo
           IF NOT cl_null(tm.mo) THEN 
              IF tm.mo=0 THEN
                  NEXT FIELD mo
              END IF
           END IF
 
        AFTER FIELD jump
           IF NOT cl_null(tm.jump) THEN
              IF tm.jump NOT MATCHES '[YN]' THEN
                 LET tm.jump='Y'
                 NEXT FIELD jump
              END IF
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
 
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
     
        ON ACTION help                #No.TQC-770001                                              
            CALL cl_show_help()       #No.TQC-770001
 
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE   
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
         WHERE zz01='asdr221'
        IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
          CALL cl_err('asdr221','9031',1)   
           
           CONTINUE WHILE   
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           " '",g_lang CLIPPED,"'",
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           #TQC-610079-begin
                           " '",tm.yea CLIPPED,"'",
                           " '",tm.mo CLIPPED,"'",
                           " '",tm.jump CLIPPED,"'",
                           #TQC-610079-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
  
           CALL cl_cmdat('asdr221',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE 
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr221()
 
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr221_w
 
END FUNCTION
 
FUNCTION asdr221()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
           g_sql     string,        # RDSQL STATEMENT  #No.FUN-580092 HCN
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_i       LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima12   LIKE ima_file.ima12,
          l_ima131  LIKE ima_file.ima131,
          sr RECORD LIKE ste_file.*
#No.FUN-850155--begin--
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_sfb08   LIKE sfb_file.sfb08,
          tr1  RECORD LIKE ste_file.*, 
          tr2  RECORD LIKE ste_file.*
#No.FUN-850155--end--
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
   #No.FUN-BB0047--mark--End-----
#No.FUN-850155--begin--                                                                                                             
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_del_data(l_table)                                                                                                        
   CALL cl_del_data(l_table1)                                                                                                       
   CALL cl_del_data(l_table2)                                                                                                       
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,                                                                 
               "  VALUES(?,?,?,?,?,  ?,?,?,?,?,",                                                                                   
               "         ?,?,?,?,?,  ?,?,?,?,?,",                                                                                    
               "         ?,?,?,?,?,  ?,?,?,?,?)"                                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
     CALL cl_err('insert_prep:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
     EXIT PROGRAM                                                                              
   END IF                                                                                                                           
                                                                                                                                    
   LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table1 CLIPPED,                                                               
                "  VALUES(?,?,?,?,?,  ?,?,?,?,?,",                                                                                   
                "         ?,?,?,?,?,  ?,?,?,?,?,",                                                                                   
                "         ?,?,?,?,?,  ?)" 
   PREPARE insert_prep1 FROM g_sql1                                                                                                 
   IF STATUS THEN                                                                                                                   
     CALL cl_err('insert_prep1:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
     EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql2 = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table2 CLIPPED,                                                               
                "  VALUES(?,?,?,?,?,  ?,?,?,?,?,",                                                                                  
                "         ?,?,?,?,?,  ?,?,?,?,?,",                                                                                  
                "         ?,?,?,?,?,  ?)"
   PREPARE insert_prep2 FROM g_sql2                                                                                                 
   IF STATUS THEN                                                                                                                   
     CALL cl_err('insert_prep2:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
     EXIT PROGRAM                                                                             
   END IF
#No.FUN-850155--end-- 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DELETE FROM r221_tmp
     DELETE FROM r221_tmp2
     LET l_sql = "SELECT ste_file.* FROM ste_file,ima_file",
                 " WHERE ste02=",tm.yea," AND ste03=",tm.mo,
                 "   AND ste05=ima01 ", 
                 "   AND ste31='N'   ", 
                 "   AND ",tm.wc CLIPPED
 
     PREPARE asdr221_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
        
     END IF
     DECLARE asdr221_curs1 CURSOR FOR asdr221_prepare1
#No.FUN-850155--begin--
#    CALL cl_outnam('asdr221') RETURNING l_name
 
#    START REPORT asdr221_rep TO l_name
#    LET g_pageno = 0
     FOREACH asdr221_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.ste16) THEN LET sr.ste16 = 0  END  IF  #add
       IF cl_null(sr.ste17) THEN LET sr.ste17 = 0  END  IF  #add
       IF cl_null(sr.ste18) THEN LET sr.ste18 = 0  END  IF  #add
       IF cl_null(sr.ste19) THEN LET sr.ste19 = 0  END  IF  #add
       IF cl_null(sr.ste20) THEN LET sr.ste20 = 0  END  IF  #add
       IF cl_null(sr.ste22) THEN LET sr.ste22 = 0  END  IF  #add
       IF cl_null(sr.ste23) THEN LET sr.ste23 = 0  END  IF  #add
       IF cl_null(sr.ste24) THEN LET sr.ste24 = 0  END  IF  #add
       IF cl_null(sr.ste25) THEN LET sr.ste25 = 0  END  IF  #add
       IF cl_null(tr1.ste16) THEN LET tr1.ste16 = 0  END  IF                                                                
       IF cl_null(tr1.ste17) THEN LET tr1.ste17 = 0  END  IF                                                               
       IF cl_null(tr1.ste18) THEN LET tr1.ste18 = 0  END  IF                                                                 
       IF cl_null(tr1.ste19) THEN LET tr1.ste19 = 0  END  IF                                                             
       IF cl_null(tr1.ste20) THEN LET tr1.ste20 = 0  END  IF                                                               
       IF cl_null(tr1.ste22) THEN LET tr1.ste22 = 0  END  IF                                                                 
       IF cl_null(tr1.ste23) THEN LET tr1.ste23 = 0  END  IF                                                              
       IF cl_null(tr1.ste24) THEN LET tr1.ste24 = 0  END  IF                                                           
       IF cl_null(tr1.ste25) THEN LET tr1.ste25 = 0  END  IF
       IF cl_null(tr2.ste16) THEN LET tr2.ste16 = 0  END  IF                                                            
       IF cl_null(tr2.ste17) THEN LET tr2.ste17 = 0  END  IF                                                           
       IF cl_null(tr2.ste18) THEN LET tr2.ste18 = 0  END  IF                                                            
       IF cl_null(tr2.ste19) THEN LET tr2.ste19 = 0  END  IF                                                             
       IF cl_null(tr2.ste20) THEN LET tr2.ste20 = 0  END  IF                                                   
       IF cl_null(tr2.ste22) THEN LET tr2.ste22 = 0  END  IF                                                          
       IF cl_null(tr2.ste23) THEN LET tr2.ste23 = 0  END  IF                                                             
       IF cl_null(tr2.ste24) THEN LET tr2.ste24 = 0  END  IF                                                             
       IF cl_null(tr2.ste25) THEN LET tr2.ste25 = 0  END  IF
       LET l_ima131=' '    LET l_ima12=' '
       SELECT ima12,ima131 INTO l_ima12,l_ima131 
         FROM ima_file WHERE ima01=sr.ste05
       IF SQLCA.sqlcode THEN LET l_ima131=' ' LET l_ima12=' ' END IF
       IF l_ima131 IS NULL THEN LET l_ima131=' ' END IF
       IF l_ima12 IS NULL THEN LET l_ima12=' ' END IF
       #-->依產品分類小計 
       INSERT INTO r221_tmp VALUES(l_ima131,
                        sr.ste06,sr.ste07,sr.ste08,sr.ste09,sr.ste10,
                        sr.ste11,sr.ste12,sr.ste13,sr.ste14,sr.ste15,
                        sr.ste16,sr.ste17,sr.ste18,sr.ste19,sr.ste20,
                        sr.ste22,sr.ste23,sr.ste24,sr.ste25,
                        sr.ste26,sr.ste27,sr.ste28,sr.ste29,sr.ste30)
       IF SQLCA.sqlcode THEN 
          UPDATE r221_tmp
             SET ste06=ste06+sr.ste06, ste07=ste07+sr.ste07,
                 ste08=ste08+sr.ste08, ste09=ste09+sr.ste09,
                 ste10=ste10+sr.ste10, ste11=ste11+sr.ste11,
                 ste12=ste12+sr.ste12, ste13=ste13+sr.ste13,
                 ste14=ste14+sr.ste14, ste15=ste15+sr.ste15,
                 ste16=ste16+sr.ste16, ste17=ste17+sr.ste17,
                 ste18=ste18+sr.ste18, ste19=ste19+sr.ste19,
                 ste20=ste20+sr.ste20, 
                 ste22=ste22+sr.ste22, ste23=ste23+sr.ste23,
                 ste24=ste24+sr.ste24, ste25=ste25+sr.ste25,
                 ste26=ste26+sr.ste26, ste27=ste27+sr.ste27, 
                 ste28=ste28+sr.ste28, ste29=ste29+sr.ste29, 
                 ste30=ste30+sr.ste30
          WHERE ima131=l_ima131
       END IF
 
       #-->依成本分群小計 
       INSERT INTO r221_tmp2 VALUES(l_ima12,
                        sr.ste06,sr.ste07,sr.ste08,sr.ste09,sr.ste10,
                        sr.ste11,sr.ste12,sr.ste13,sr.ste14,sr.ste15,
                        sr.ste16,sr.ste17,sr.ste18,sr.ste19,sr.ste20,
                        sr.ste22,sr.ste23,sr.ste24,sr.ste25,
                        sr.ste26,sr.ste27,sr.ste28,sr.ste29,sr.ste30)
       IF SQLCA.sqlcode THEN 
          UPDATE r221_tmp2
             SET ste06=ste06+sr.ste06, ste07=ste07+sr.ste07,
                 ste08=ste08+sr.ste08, ste09=ste09+sr.ste09,
                 ste10=ste10+sr.ste10, ste11=ste11+sr.ste11,
                 ste12=ste12+sr.ste12, ste13=ste13+sr.ste13,
                 ste14=ste14+sr.ste14, ste15=ste15+sr.ste15,
                 ste16=ste16+sr.ste16, ste17=ste17+sr.ste17,
                 ste18=ste18+sr.ste18, ste19=ste19+sr.ste19,
                 ste20=ste20+sr.ste20, 
                 ste22=ste22+sr.ste22, ste23=ste23+sr.ste23,
                 ste24=ste24+sr.ste24, ste25=ste25+sr.ste25,
                 ste26=ste26+sr.ste26, ste27=ste27+sr.ste27, 
                 ste28=ste28+sr.ste28, ste29=ste29+sr.ste29, 
                 ste30=ste30+sr.ste30
          WHERE ima12=l_ima12 
       END IF
     SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = sr.ste04
     SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.ste05
     IF SQLCA.sqlcode THEN LET l_sfb08 =0 END IF
      DECLARE r221_cur CURSOR FOR
        SELECT * FROM r221_tmp ORDER BY ima131
      FOREACH r221_cur INTO tr1.*
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep1 USING tr1.ste04,tr1.ste05,tr1.ste06,tr1.ste11,tr1.ste16,tr1.ste26,tr1.ste07,tr1.ste12,
                                   tr1.ste17,tr1.ste22,tr1.ste27,tr1.ste08,tr1.ste13,tr1.ste18,tr1.ste23,tr1.ste28,
                                   tr1.ste09,tr1.ste14,tr1.ste19,tr1.ste24,tr1.ste29,tr1.ste10,tr1.ste15,tr1.ste20,
                                   tr1.ste25,tr1.ste30
      END FOREACH
      DECLARE r221_cur2 CURSOR FOR
        SELECT * FROM r221_tmp2 ORDER BY ima12
      FOREACH r221_cur2 INTO tr2.*
        IF STATUS <> 0 THEN EXIT FOREACH END IF
        EXECUTE insert_prep2 USING tr2.ste04,tr2.ste05,tr2.ste06,tr2.ste11,tr2.ste16,tr2.ste26,tr2.ste07,tr2.ste12,                         
                                   tr2.ste17,tr2.ste22,tr2.ste27,tr2.ste08,tr2.ste13,tr2.ste18,tr2.ste23,tr2.ste28,                         
                                   tr2.ste09,tr2.ste14,tr2.ste19,tr2.ste24,tr2.ste29,tr2.ste10,tr2.ste15,tr2.ste20,                         
                                   tr2.ste25,tr2.ste30
      END FOREACH
      EXECUTE insert_prep USING sr.ste05,l_ima02,sr.ste04,l_sfb08,sr.ste06,sr.ste11,sr.ste16,sr.ste26,sr.ste07,              
                                sr.ste12,sr.ste17,sr.ste22,sr.ste27,sr.ste08,sr.ste13,sr.ste18,sr.ste23,sr.ste28,                       
                                sr.ste09,sr.ste14,sr.ste19,sr.ste24,sr.ste29,sr.ste10,sr.ste15,sr.ste20,sr.ste25,                    
                                sr.ste30,l_ima12,l_ima131 
#       OUTPUT TO REPORT asdr221_rep(l_ima12,l_ima131,sr.*)
     END FOREACH
#    FINISH REPORT asdr221_rep
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     #No.FUN-BB0047--mark--End-----
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                                                                          
        CALL cl_wcchp(tm.wc,'ste04,ima131,ima12')                                                                       
             RETURNING tm.wc                                                                                                       
     END IF                                                                                                                        
     LET g_str=tm.wc,";",tm.yea,";",tm.mo,";",tm.jump,";",g_azi04                                                                                                               
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," | ",                                                       
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," | ",                                                      
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED                                                             
     CALL cl_prt_cs3('asdr221','asdr221',l_sql,g_str)
#No.FUN-850155--end--
END FUNCTION
#No.FUN-850155--begin--
#REPORT asdr221_rep(l_ima12,l_ima131,sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_cnt        LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#         l_group      LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
#         l_bamt, l_camt,l_oamt,l_damt,l_eamt   LIKE ste_file.ste07,
#         l_ima12   LIKE ima_file.ima12 ,
#         l_ima02   LIKE ima_file.ima02,
#         l_ima131  LIKE ima_file.ima131,
#         l_sfb08   LIKE sfb_file.sfb08,
#         sr RECORD LIKE ste_file.*,
#         tt RECORD LIKE ste_file.*
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY l_ima12,l_ima131,sr.ste05,sr.ste04
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1=g_x[10] CLIPPED,tm.yea USING '&&&&','/',tm.mo USING '&&'
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#           g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#           g_x[39] clipped,g_x[40] clipped
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF l_ima12 #成本分群
#    IF tm.jump='Y' THEN SKIP TO TOP OF PAGE END IF
 
#  ON EVERY ROW
#    SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = sr.ste04
#    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=sr.ste05
#    IF SQLCA.sqlcode THEN LET l_sfb08 =0 END IF
#      IF cl_null(l_bamt) THEN LET l_bamt = 0  END  IF  #add                                                                        
#      IF cl_null(l_camt) THEN LET l_camt = 0  END  IF  #add                                                                        
#      IF cl_null(l_oamt) THEN LET l_oamt = 0  END  IF  #add                                                                        
#      IF cl_null(l_damt) THEN LET l_damt = 0  END  IF  #add                                                                        
#      IF cl_null(l_eamt) THEN LET l_eamt = 0  END  IF  #add
#  
#    LET l_bamt = sr.ste07+sr.ste08+sr.ste09+sr.ste10
#    LET l_camt = sr.ste12+sr.ste13+sr.ste14+sr.ste15 
#    LET l_oamt = sr.ste17+sr.ste18+sr.ste19+sr.ste20 
#    LET l_damt = sr.ste22+sr.ste23+sr.ste24+sr.ste25 
#    LET l_eamt = sr.ste27+sr.ste28+sr.ste29+sr.ste30 
 
#    PRINT COLUMN g_c[31],sr.ste05,                  #料號
#          COLUMN g_c[32],l_ima02,
#          COLUMN g_c[33],sr.ste04,                  #工單編號
#          COLUMN g_c[34],cl_numfor(l_sfb08,33,0),   #生產數量
#          column g_c[35],g_x[14] clipped,
#          COLUMN g_c[36],cl_numfor(sr.ste06,36,0),        #期初數量
#          COLUMN g_c[37],cl_numfor(sr.ste11,37,0),        #本月投入數量
#          COLUMN g_c[38],cl_numfor(sr.ste16,38,0),        #本月投入數量
#          COLUMN g_c[40],cl_numfor(sr.ste26,40,0)       #期末數量
 
#    PRINT COLUMN g_c[35],g_x[15] clipped,
#          COLUMN g_c[36],cl_numfor(sr.ste07,36 ,g_azi04),  #期初材料
#          COLUMN g_c[37],cl_numfor(sr.ste12,37 ,g_azi04),  #本期投入材料
#          COLUMN g_c[38],cl_numfor(sr.ste17,38 ,g_azi04),  #本期轉出材料
#          COLUMN g_c[39],cl_numfor(sr.ste22,39 ,g_azi04),  #本期差異
#          COLUMN g_c[40],cl_numfor(sr.ste27,40 ,g_azi04)  #期末材料
 
#    PRINT column g_c[35],g_x[16] clipped,
#          COLUMN g_c[36],cl_numfor(sr.ste08,36 ,g_azi04),  #期初人工
#          COLUMN g_c[37],cl_numfor(sr.ste13,37 ,g_azi04),  #本月投入人工 
#          COLUMN g_c[38],cl_numfor(sr.ste18,38 ,g_azi04),  #本期轉出人工
#          COLUMN g_c[39],cl_numfor(sr.ste23,39 ,g_azi04),  #本期差異
#          COLUMN g_c[40],cl_numfor(sr.ste28,40 ,g_azi04)  #期末人工
 
#    PRINT column g_c[35],g_x[17] clipped,
#          COLUMN g_c[36],cl_numfor(sr.ste09,36 ,g_azi04),  #期初製費一
#          COLUMN g_c[37],cl_numfor(sr.ste14,37 ,g_azi04),  #本月投入製費一
#          COLUMN g_c[38],cl_numfor(sr.ste19,38 ,g_azi04),  #本期轉出製費一
#          COLUMN g_c[39],cl_numfor(sr.ste24,39 ,g_azi04),  #本期差異
#          COLUMN g_c[40],cl_numfor(sr.ste29,40 ,g_azi04)  #期末製費一
 
#    PRINT column g_c[35],g_x[18] clipped,
#          COLUMN g_c[36],cl_numfor(sr.ste10,36 ,g_azi04),  #期初製費二
#          COLUMN g_c[37],cl_numfor(sr.ste15,37 ,g_azi04),  #本月投入製費二
#          COLUMN g_c[38],cl_numfor(sr.ste20,38 ,g_azi04),  #本期轉出製費二
#          COLUMN g_c[39],cl_numfor(sr.ste25,39 ,g_azi04),  #本期差異
#          COLUMN g_c[40],cl_numfor(sr.ste30,40 ,g_azi04)  #期末材料
 
#    PRINT column g_c[35],g_x[19] clipped,
#          COLUMN g_c[36],cl_numfor(l_bamt,36 ,g_azi04),  #合計
#          COLUMN g_c[37],cl_numfor(l_camt,37 ,g_azi04),  #合計
#          COLUMN g_c[38],cl_numfor(l_oamt,38 ,g_azi04),  #合計
#          COLUMN g_c[39],cl_numfor(l_damt,39 ,g_azi04),  #合計
#          COLUMN g_c[40],cl_numfor(l_eamt,40 ,g_azi04)  #合計
 
#  AFTER GROUP OF l_ima12   
#        LET tr.ste06=GROUP SUM(sr.ste06)
#        LET tr.ste07=GROUP SUM(sr.ste07)
#        LET tr.ste08=GROUP SUM(sr.ste08)
#        LET tr.ste09=GROUP SUM(sr.ste09)
#        LET tr.ste10=GROUP SUM(sr.ste10)
#        LET tr.ste11=GROUP SUM(sr.ste11)
#        LET tr.ste12=GROUP SUM(sr.ste12)
#        LET tr.ste13=GROUP SUM(sr.ste13)
#        LET tr.ste14=GROUP SUM(sr.ste14)
#        LET tr.ste15=GROUP SUM(sr.ste15)
#        LET tr.ste16=GROUP SUM(sr.ste16)
#        LET tr.ste17=GROUP SUM(sr.ste17)
#        LET tr.ste18=GROUP SUM(sr.ste18)
#        LET tr.ste19=GROUP SUM(sr.ste19)
#        LET tr.ste20=GROUP SUM(sr.ste20)
#        LET tr.ste22=GROUP SUM(sr.ste22)
#        LET tr.ste23=GROUP SUM(sr.ste23)
#        LET tr.ste24=GROUP SUM(sr.ste24)
#        LET tr.ste25=GROUP SUM(sr.ste25)
#        LET tr.ste26=GROUP SUM(sr.ste26)
#        LET tr.ste27=GROUP SUM(sr.ste27)
#        LET tr.ste28=GROUP SUM(sr.ste28)
#        LET tr.ste29=GROUP SUM(sr.ste29)
#        LET tr.ste30=GROUP SUM(sr.ste30)
#        LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10
#        LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#        LET l_oamt = tr.ste17+tr.ste18+tr.ste19+tr.ste20 
#        LET l_damt = tr.ste22+tr.ste23+tr.ste24+tr.ste25 
#        LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30
#     #-->列印小計
#        PRINT ' '
#        LET l_group=g_x[20] CLIPPED,'(',l_ima12,')'
#        PRINT COLUMN g_c[32],l_group,
#              COLUMN g_c[35],g_x[14] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste06,36 ,0),
#              COLUMN g_c[37],cl_numfor(tr.ste11,37 ,0),
#              COLUMN g_c[40],cl_numfor(tr.ste26,40 ,0) 
 
#        PRINT COLUMN g_c[35],g_x[15] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste07,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste12,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste17,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste22,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste27,40 ,g_azi04)
 
#        PRINT COLUMN g_c[35],g_x[16] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste08,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste13,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste18,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste23,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste28,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[17] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste09,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste14,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste19,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste24,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste29,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[18] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste10,36 ,g_azi04), 
#              COLUMN g_c[37],cl_numfor(tr.ste15,37 ,g_azi04), 
#              COLUMN g_c[38],cl_numfor(tr.ste20,38 ,g_azi04), 
#              COLUMN g_c[39],cl_numfor(tr.ste25,39 ,g_azi04), 
#              COLUMN g_c[40],cl_numfor(tr.ste30,40 ,g_azi04)  
 
#        PRINT COLUMN g_c[35],g_x[19] clipped,
#             COLUMN g_c[36],cl_numfor(l_bamt,36 ,g_azi04), 
#             COLUMN g_c[37],cl_numfor(l_camt,37 ,g_azi04), 
#             COLUMN g_c[38],cl_numfor(l_oamt,38 ,g_azi04), 
#             COLUMN g_c[39],cl_numfor(l_damt,39 ,g_azi04), 
#             COLUMN g_c[40],cl_numfor(l_eamt,40 ,g_azi04)  
 
#  ON LAST ROW
#     LET tr.ste06=SUM(sr.ste06)
#     LET tr.ste07=SUM(sr.ste07)
#     LET tr.ste08=SUM(sr.ste08)
#     LET tr.ste09=SUM(sr.ste09)
#     LET tr.ste10=SUM(sr.ste10)
#     LET tr.ste11=SUM(sr.ste11)
#     LET tr.ste12=SUM(sr.ste12)
#     LET tr.ste13=SUM(sr.ste13)
#     LET tr.ste14=SUM(sr.ste14)
#     LET tr.ste15=SUM(sr.ste15)
#     LET tr.ste16=SUM(sr.ste16)
#     LET tr.ste17=SUM(sr.ste17)
#     LET tr.ste18=SUM(sr.ste18)
#     LET tr.ste19=SUM(sr.ste19)
#     LET tr.ste20=SUM(sr.ste20)
#     LET tr.ste22=SUM(sr.ste22)
#     LET tr.ste23=SUM(sr.ste23)
#     LET tr.ste24=SUM(sr.ste24)
#     LET tr.ste25=SUM(sr.ste25)
#     LET tr.ste26=SUM(sr.ste26)
#     LET tr.ste27=SUM(sr.ste27)
#     LET tr.ste28=SUM(sr.ste28)
#     LET tr.ste29=SUM(sr.ste29)
#     LET tr.ste30=SUM(sr.ste30)
#     #-->列印總計
#     PRINT g_dash2[1,g_len]
#     LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10 
#     LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#     LET l_oamt = tr.ste17+tr.ste18+tr.ste19+tr.ste20 
#     LET l_damt = tr.ste22+tr.ste23+tr.ste24+tr.ste25 
#     LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30 
 
#        PRINT COLUMN g_c[32],g_x[21] CLIPPED,
#              COLUMN g_c[35],g_x[14] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste06,36 ,0),
#              COLUMN g_c[37],cl_numfor(tr.ste11,37 ,0),
#              COLUMN g_c[40],cl_numfor(tr.ste26,40 ,0) 
 
#        PRINT COLUMN g_c[35],g_x[15] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste07,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste12,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste17,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste22,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste27,40 ,g_azi04)
 
#        PRINT COLUMN g_c[35],g_x[16] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste08,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste13,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste18,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste23,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste28,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[17] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste09,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste14,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste19,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste24,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste29,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[18] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste10,36 ,g_azi04), 
#              COLUMN g_c[37],cl_numfor(tr.ste15,37 ,g_azi04), 
#              COLUMN g_c[38],cl_numfor(tr.ste20,38 ,g_azi04), 
#              COLUMN g_c[39],cl_numfor(tr.ste25,39 ,g_azi04), 
#              COLUMN g_c[40],cl_numfor(tr.ste30,40 ,g_azi04)  
 
#        PRINT COLUMN g_c[35],g_x[19] clipped,
#             COLUMN g_c[36],cl_numfor(l_bamt,36 ,g_azi04), 
#             COLUMN g_c[37],cl_numfor(l_camt,37 ,g_azi04), 
#             COLUMN g_c[38],cl_numfor(l_oamt,38 ,g_azi04), 
#             COLUMN g_c[39],cl_numfor(l_damt,39 ,g_azi04), 
#             COLUMN g_c[40],cl_numfor(l_eamt,40 ,g_azi04)  
 
 
 
#     PRINT g_dash[1,g_len]
 
#     #-->列印產品分類小計
#     LET l_cnt = 0
#     DECLARE r221_cur CURSOR FOR
#       SELECT * FROM r221_tmp ORDER BY ima131
#     FOREACH r221_cur INTO tr.*
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT column g_c[32],g_x[24] clipped END IF
#       LET l_cnt = l_cnt + 1
#       LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10 
#       LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#       LET l_oamt = tr.ste17+tr.ste18+tr.ste19+tr.ste20 
#       LET l_damt = tr.ste22+tr.ste23+tr.ste24+tr.ste25 
#       LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30 
 
#        PRINT COLUMN g_c[32],tr.ste05 CLIPPED,
#              COLUMN g_c[35],g_x[14] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste06,36 ,0),
#              COLUMN g_c[37],cl_numfor(tr.ste11,37 ,0),
#              COLUMN g_c[40],cl_numfor(tr.ste26,40 ,0) 
 
#        PRINT COLUMN g_c[35],g_x[15] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste07,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste12,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste17,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste22,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste27,40 ,g_azi04)
 
#        PRINT COLUMN g_c[35],g_x[16] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste08,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste13,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste18,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste23,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste28,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[17] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste09,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste14,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste19,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste24,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste29,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[18] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste10,36 ,g_azi04), 
#              COLUMN g_c[37],cl_numfor(tr.ste15,37 ,g_azi04), 
#              COLUMN g_c[38],cl_numfor(tr.ste20,38 ,g_azi04), 
#              COLUMN g_c[39],cl_numfor(tr.ste25,39 ,g_azi04), 
#              COLUMN g_c[40],cl_numfor(tr.ste30,40 ,g_azi04)  
 
#        PRINT COLUMN g_c[35],g_x[19] clipped,
#             COLUMN g_c[36],cl_numfor(l_bamt,36 ,g_azi04), 
#             COLUMN g_c[37],cl_numfor(l_camt,37 ,g_azi04), 
#             COLUMN g_c[38],cl_numfor(l_oamt,38 ,g_azi04), 
#             COLUMN g_c[39],cl_numfor(l_damt,39 ,g_azi04), 
#             COLUMN g_c[40],cl_numfor(l_eamt,40 ,g_azi04)  
#     END FOREACH
 
#     #-->列印成本分群小計
#     PRINT g_dash2[1,g_len]
#     LET l_cnt = 0
#     DECLARE r221_cur2 CURSOR FOR
#       SELECT * FROM r221_tmp2 ORDER BY ima12
#     FOREACH r221_cur2 INTO tr.*
#       IF STATUS <> 0 THEN EXIT FOREACH END IF
#       IF l_cnt = 0 THEN PRINT column g_c[32],g_x[25] clipped END IF
#       LET l_cnt = l_cnt + 1
#       LET l_bamt = tr.ste07+tr.ste08+tr.ste09+tr.ste10 
#       LET l_camt = tr.ste12+tr.ste13+tr.ste14+tr.ste15 
#       LET l_oamt = tr.ste17+tr.ste18+tr.ste19+tr.ste20 
#       LET l_damt = tr.ste22+tr.ste23+tr.ste24+tr.ste25 
#       LET l_eamt = tr.ste27+tr.ste28+tr.ste29+tr.ste30 
 
#        PRINT COLUMN g_c[32],tr.ste05 CLIPPED,
#              COLUMN g_c[35],g_x[14] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste06,36 ,0),
#              COLUMN g_c[37],cl_numfor(tr.ste11,37 ,0),
#              COLUMN g_c[40],cl_numfor(tr.ste26,40 ,0) 
 
#        PRINT COLUMN g_c[35],g_x[15] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste07,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste12,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste17,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste22,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste27,40 ,g_azi04)
 
#        PRINT COLUMN g_c[35],g_x[16] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste08,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste13,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste18,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste23,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste28,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[17] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste09,36 ,g_azi04),
#              COLUMN g_c[37],cl_numfor(tr.ste14,37 ,g_azi04),
#              COLUMN g_c[38],cl_numfor(tr.ste19,38 ,g_azi04),
#              COLUMN g_c[39],cl_numfor(tr.ste24,39 ,g_azi04),
#              COLUMN g_c[40],cl_numfor(tr.ste29,40 ,g_azi04) 
 
#        PRINT COLUMN g_c[35],g_x[18] clipped,
#              COLUMN g_c[36],cl_numfor(tr.ste10,36 ,g_azi04), 
#              COLUMN g_c[37],cl_numfor(tr.ste15,37 ,g_azi04), 
#              COLUMN g_c[38],cl_numfor(tr.ste20,38 ,g_azi04), 
#              COLUMN g_c[39],cl_numfor(tr.ste25,39 ,g_azi04), 
#              COLUMN g_c[40],cl_numfor(tr.ste30,40 ,g_azi04)  
 
#        PRINT COLUMN g_c[35],g_x[19] clipped,
#             COLUMN g_c[36],cl_numfor(l_bamt,36 ,g_azi04), 
#             COLUMN g_c[37],cl_numfor(l_camt,37 ,g_azi04), 
#             COLUMN g_c[38],cl_numfor(l_oamt,38 ,g_azi04), 
#             COLUMN g_c[39],cl_numfor(l_damt,39 ,g_azi04), 
#             COLUMN g_c[40],cl_numfor(l_eamt,40 ,g_azi04)  
 
#     END FOREACH
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850155--end--
#No.FUN-870144

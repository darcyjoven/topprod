# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmr650.4gl
# Descriptions...: 應付佣金明細表列印
# Date & Author..: 02/12/10 By Danny
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: NO.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550070 05/05/27 By ice   單據編號格式放大,報表修改
# Modify.........: No.MOD-560211 05/06/29 By pengu  報表各欄位之標題位置，往右偏移許多
# Modify.........: No.MOD-580212 05/09/08 By ice  修改報表列印格式
# Modify.........: No.FUN-640014 06/04/20 By Sarah 畫面增加佣金年度、佣金月份、產生對象三個選項
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850014 08/05/05 By xiaofeizhu 報表輸出改為CR
#                                08/09/26 By Cockroach 21-->31 CR
             
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改 
# Modify.........: No:TQC-D50057 13/07/16 By yangtt 增加傭金編號出貨單號、業務員、代理商開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc     STRING,     # Where condition
              c      LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)   # Input condition   #FUN-640014 add
              bdate  LIKE type_file.dat,         # No.FUN-680137 DATE      # Input condition
              edate  LIKE type_file.dat,         # No.FUN-680137 DATE      # Input condition
              a      LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)  # Input condition
              b      LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)  # Input condition
              more   LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01)  # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
 
#No.FUN-850014 --Add--Begin--                                                                                                       
  DEFINE   l_table1        STRING                                                                                                     
  DEFINE   g_str           STRING                                                                                                     
  DEFINE   g_sql           STRING                                                                                                     
#No.FUN-850014 --Add--End--
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
 #--------------No.TQC-610089 modify
  #LET tm.c     = ARG_VAL(2)   #FUN-640014 add
  #LET tm.wc    = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   LET tm.bdate= ARG_VAL(9)
   LET tm.edate= ARG_VAL(10)
   LET tm.a    = ARG_VAL(11)
   LET tm.c    = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#No.FUN-850014 --Add--Begin--                                                                                                       
#--------------------------CR(1)--------------------------------#                                                                   
   LET g_sql = " oft16.oft_file.oft16,",
               " oft14.oft_file.oft14,", 
               " oft05.oft_file.oft05,",
               " oft04.oft_file.oft04,",
               " oft03.oft_file.oft03,",
               " oft02.oft_file.oft02,",
               " oft01.oft_file.oft01,",
               " oft03_desc.pmc_file.pmc03,",
               " gen02.gen_file.gen02,",
               " occ02.occ_file.occ02,",
               " azi04.azi_file.azi04,",
               "l_azi05.azi_file.azi05"
 
   LET l_table1 = cl_prt_temptable('axmr6501',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
#--------------------------CR(1)--------------------------------#
#No.FUN-850014 --Add--End--
 
# No.FUN-680137 --start--
   CREATE TEMP TABLE r650_tmp( 
      tmp1   LIKE faj_file.faj02,     
      tmp2   LIKE azi_file.azi01,       #TQC-840066
      tmp3   LIKE type_file.num20_6)
# No.FUN-680137 ---end---
   IF STATUS THEN CALL cl_err('create table',STATUS,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
 
   INITIALIZE tm.* TO NULL                # Default condition
  #start FUN-640014 add
   IF cl_null(tm.c) THEN   
      LET tm.c    = '1'
   END IF
  #end FUN-640014 add
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.more = 'N'
   LET tm.a    = '1'
   LET tm.b    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL axmr650_tm(0,0)             # Input print condition
      ELSE CALL axmr650()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr650_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 30
 
   OPEN WINDOW axmr650_w AT p_row,p_col WITH FORM "axm/42f/axmr650" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   WHILE TRUE
      DELETE FROM r650_tmp
      CONSTRUCT BY NAME tm.wc ON oft01,oft04,oft03,oft18,oft19   #FUN-640014 add oft18,oft19 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

   #TQC-D50057--add--start
      ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oft03)   #對象編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oft03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oft03
                  NEXT FIELD oft03
               WHEN INFIELD(oft04)   #業務員
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oft04
                  NEXT FIELD oft04
               WHEN INFIELD(oft01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oft01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oft01
                  NEXT FIELD oft01
            END CASE
   #TQC-D50057--add--end
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmr650_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
 
      INPUT BY NAME tm.c,tm.bdate,tm.edate,tm.a,tm.b,tm.more   #FUN-640014 add tm.c
            WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
        #start FUN-640014 add
         AFTER FIELD c                                                          
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[12]" THEN NEXT FIELD c END IF
        #end FUN-640014 add
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.bdate > tm.edate THEN
               NEXT FIELD edate
            END IF
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[12]" THEN NEXT FIELD a END IF
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
               THEN NEXT FIELD more
            END IF
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr650_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axmr650'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axmr650','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate  CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang   CLIPPED,"'",
                            " '",g_bgjob  CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc    CLIPPED,"'" ,
                            " '",tm.c     CLIPPED,"'" ,   #FUN-640014 add
                            " '",tm.bdate CLIPPED,"'" ,
                            " '",tm.edate CLIPPED,"'" ,
                            " '",tm.a     CLIPPED,"'" ,
                            " '",tm.b     CLIPPED,"'" ,
                           #" '",tm.more  CLIPPED,"'"  ,           #No.TQC-610089 mark
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('axmr650',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axmr650_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmr650()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmr650_w
END FUNCTION
 
FUNCTION axmr650()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,        #No.FUN-680137 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    oft         RECORD LIKE oft_file.*,
                   #pmc03       LIKE pmc_file.pmc03,   #FUN-640014 mark
                    oft03_desc  LIKE pmc_file.pmc03,   #FUN-640014
                    gen02       LIKE gen_file.gen02,
                    occ02       LIKE occ_file.occ02,
                    azi04       LIKE azi_file.azi04,
                    order1      LIKE faj_file.faj02,     # No.FUN-680137 VARCHAR(10)
                    order2      LIKE type_file.chr8      # No.FUN-680137 VARCHAR(8)
                    END RECORD 
   DEFINE l_azi05   LIKE azi_file.azi05             #No.FUN-850014
 
#No.FUN-850014 --Add--Begin--                                                                                                       
#--------------------------CR(2)--------------------------------#                                                                   
     CALL cl_del_data(l_table1)                                                                                                     
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "                                                                           
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                           
     END IF                                                                                                                         
                                                                                                                                    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#------------------------CR(2)------------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660167
        CALL cl_err3("sel","zo_file",g_rlang,"",SQLCA.sqlcode,"","",0)  #No.FUN-660167 
     END IF     
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR             #No.FUN-850014
 
    #start FUN-640014 modify
    #LET l_sql="SELECT oft_file.*,pmc03,gen02,occ02,azi04,'','' ",
    #          "  FROM oft_file,OUTER pmc_file,OUTER gen_file,",
    #          "       OUTER occ_file b,OUTER azi_file",
    #          " WHERE pmc_file.pmc01 = oft_file.oft03 ",
    #          "   AND gen_file.gen01 = oft_file.oft04 ",
    #          "   AND occ_file.occ01 = oft_file.oft05 ",
    #          "   AND azi_file.azi01 = oft_file.oft14 ",
    #          "   AND oft02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
    #          "   AND ",tm.wc CLIPPED
     IF tm.c = '1' THEN
        LET l_sql="SELECT oft_file.*,a.occ02,gen02,b.occ02,azi04,'','' ",
                  "  FROM oft_file,OUTER occ_file a,OUTER gen_file,",
                  "       OUTER occ_file b,OUTER azi_file",
                  " WHERE a.occ01 = oft_file.oft03 ",
                  "   AND gen_file.gen01 = oft_file.oft04 ",
                  "   AND b.occ01 = oft_file.oft05 ",
                  "   AND azi_file.azi01 = oft_file.oft14 ",
                  "   AND oft02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                  "   AND ",tm.wc CLIPPED,
                  "   AND oft17='",tm.c,"'"
     ELSE
        LET l_sql="SELECT oft_file.*,pmc03,gen02,occ02,azi04,'','' ",
                  "  FROM oft_file,OUTER pmc_file,OUTER gen_file,",
                  "       OUTER occ_file ,OUTER azi_file",
                  " WHERE pmc_file.pmc01 = oft_file.oft03 ",
                  "   AND gen_file.gen01 = oft_file.oft04 ",
                  "   AND occ_file.occ01 = oft_file.oft05 ",
                  "   AND azi_file.azi01 = oft_file.oft14 ",
                  "   AND oft02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                  "   AND ",tm.wc CLIPPED,
                  "   AND oft17='",tm.c,"'"
     END IF
    #end FUN-640014 modify
     DISPLAY 'l_sql:',l_sql 
     PREPARE axmr650_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE axmr650_curs1 CURSOR FOR axmr650_prepare1
 
#     CALL cl_outnam('axmr650') RETURNING l_name             #No.FUN-850014
#     START REPORT axmr650_rep TO l_name                     #No.FUN-850014
#     LET g_pageno = 0                                       #No.FUN-850014
     FOREACH axmr650_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
#No.FUN-850014--mark--begin--#
#        IF tm.a = '1' THEN 
#           LET sr.order1 = sr.oft.oft03
#          #LET sr.order2 = sr.pmc03        #FUN-640014 mark
#           LET sr.order2 = sr.oft03_desc   #FUN-640014
#        ELSE
#           LET sr.order1 = sr.oft.oft04
#           LET sr.order2 = sr.gen02
#        END IF
 
#        OUTPUT TO REPORT axmr650_rep(sr.*)
#No.FUN-850014--mark--end--#
 
#No.FUN-850014--Add--Begin--#
       SELECT azi05 INTO l_azi05 FROM azi_file                                                                    
        WHERE azi01 = sr.oft.oft14
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850014 *** ##                                                   
           EXECUTE insert_prep USING                                                                                               
                   sr.oft.oft16,sr.oft.oft14,sr.oft.oft05,sr.oft.oft04,sr.oft.oft03,sr.oft.oft02,
                   sr.oft.oft01,sr.oft03_desc,sr.gen02,sr.occ02,sr.azi04,l_azi05                                                                                             
          #------------------------------ CR (3) ------------------------------#
 
#No.FUN-850014--Add--End--#
     END FOREACH
 
#     FINISH REPORT axmr650_rep                       #No.FUN-850014
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #No.FUN-850014
#No.FUN-850014 --Add--Begin--                                                                                                       
#----------------------CR(3)------------------------------#                                                                         
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1                  # CLIPPED,"|",                                                         
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'oft01,oft04,oft03,oft18,oft19')                                                                             
             RETURNING tm.wc                                                                                                        
     END IF                                                                                                                         
     LET g_str = tm.wc,";",tm.a,";",tm.b,";",tm.c,";",tm.bdate,";",tm.edate                           
     CALL cl_prt_cs3('axmr650','axmr650',g_sql,g_str)                                                                               
#----------------------CR(3)------------------------------#                                                                         
#No.FUN-850014 --Add--End-- 
 
END FUNCTION
 
#No.FUN-850014--Mark--Begin--#
#REPORT axmr650_rep(sr)
#  DEFINE l_last_sw LIKE type_file.chr1,      # No.FUN-680137 VARCHAR(1)
# Prog. Version..: '5.30.06-13.03.12(04) #TQC-840066
#         l_sum     LIKE oft_file.oft16,
#         l_azi05   LIKE azi_file.azi05,
#         sr        RECORD
#                   oft         RECORD LIKE oft_file.*,
#                  #pmc03       LIKE pmc_file.pmc03,   #FUN-640014 mark
#                   oft03_desc  LIKE pmc_file.pmc03,   #FUN-640014
#                   gen02       LIKE gen_file.gen02,
#                   occ02       LIKE occ_file.occ02,
#                   azi04       LIKE azi_file.azi04,
#                   order1      LIKE faj_file.faj02,      # No.FUN-680137 VARCHAR(10)
#                   order2      LIKE type_file.chr8       # No.FUN-680137 VARCHAR(8)
#                   END RECORD 
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2
# FORMAT
#  PAGE HEADER 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT ''
##---No.MOD-560211---------------
#     PRINT g_dash[1,g_len]
#     #No.MOD-580212 --start--
#     IF tm.a = '2' THEN
#        LET g_zaa[31].zaa08 = g_x[12] CLIPPED
#        LET g_zaa[32].zaa08 = g_x[13] CLIPPED
#     END IF                                                                                                                        
#     PRINT g_x[31] CLIPPED,   
#           g_x[32] CLIPPED;
#     #No.MOD-580212 --end--
#     PRINT g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38]
 
##     PRINT g_dash[1,g_len]
##     IF tm.a = '1' THEN
##        PRINT g_x[31],g_x[32],
##              g_x[33],g_x[34],g_x[35],
##              g_x[36],g_x[37],g_x[38]
##     ELSE
##        LET g_x[32] = g_x[39]
##        PRINT COLUMN g_c[31],g_x[12] CLIPPED,
##              COLUMN g_c[32],g_x[13] CLIPPED;
##        PRINT g_x[31],g_x[32],
##              g_x[33],g_x[34],g_x[35],
##              g_x[36],g_x[37],g_x[38]
##        PRINT COLUMN g_c[33],g_x[33],
##              COLUMN g_c[34],g_x[34],
##              COLUMN g_c[35],g_x[35],
##              COLUMN g_c[36],g_x[36],
##              COLUMN g_c[37],g_x[37],
##              COLUMN g_c[38],g_x[38]
##     END IF
##--end
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.b = 'Y' THEN SKIP TO TOP OF PAGE END IF
#     PRINT COLUMN g_c[31],sr.order1,
#           COLUMN g_c[32],sr.order2;
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[33],sr.oft.oft05,
#           COLUMN g_c[34],sr.occ02,
#           COLUMN g_c[35],sr.oft.oft02,
#           COLUMN g_c[36],sr.oft.oft01,
#           COLUMN g_c[37],sr.oft.oft14,
#           COLUMN g_c[38],cl_numfor(sr.oft.oft16,38,sr.azi04)
#     INSERT INTO r650_tmp VALUES(sr.order1,sr.oft.oft14,sr.oft.oft16)
#     IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
##        CALL cl_err('ins tmp',STATUS,0)    #No.FUN-660167
#        CALL cl_err3("ins","r650_tmp","","",STATUS,"","ins tmp",0)   #No.FUN-660167
#     END IF
 
#  AFTER GROUP OF sr.order1
#     DECLARE tmp_curs1 CURSOR FOR
#      SELECT tmp2,azi05,SUM(tmp3) FROM r650_tmp,OUTER azi_file
#       WHERE tmp1 = sr.order1 AND azi_file.azi01 = tmp2
#       GROUP BY tmp2,azi05
#     PRINT 
#     PRINT COLUMN g_c[36],g_x[10];
#     FOREACH tmp_curs1 INTO l_curr,l_azi05,l_sum
#        PRINT COLUMN g_c[37],l_curr,
#              COLUMN g_c[38],cl_numfor(l_sum,38,l_azi05)
#     END FOREACH
#     PRINT 
 
#  ON LAST ROW
#     DECLARE tmp_curs2 CURSOR FOR
#      SELECT tmp2,azi05,SUM(tmp3) FROM r650_tmp,OUTER azi_file
#       WHERE azi_file.azi01 = tmp2 GROUP BY tmp2,azi05
#     PRINT COLUMN g_c[36],g_x[11];
#     FOREACH tmp_curs2 INTO l_curr,l_azi05,l_sum
#        PRINT COLUMN g_c[37],l_curr,
#              COLUMN g_c[38],cl_numfor(l_sum,38,l_azi05)
#     END FOREACH
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.MOD-580212
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.MOD-580212
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850014--Mark--End--#

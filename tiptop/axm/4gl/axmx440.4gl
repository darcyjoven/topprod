# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: axmx440.4gl
# Descriptions...: 產品別預計出貨表
# Date & Author..: 95/01/24 By Danny
# Modify.........: No.FUN-4A0026 04/10/07 Echo 產品編號,訂單單號, 人員編號要開窗
# Modify.........: No.FUN-4C0096 05/03/03 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-580013 05/08/11 By will 報表轉XML格式
# Modify.........: No.FUN-650013 06/05/15 By Sam_Lin 修改報表列印時距條件
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0039 06/12/08 By Judy 調整報表格式
# Modify.........: No.MOD-820058 08/02/21 By claire 將第二行表頭與第一行表頭合併,使用單行列印時才不會不美觀
# Modify.........: No.FUN-840039 08/04/15 By Sunyanchun  老報表轉CR
#                                08/09/24 By Cockroach  CR 21-->31
# Modify.........: No.MOD-890099 08/10/17 By liuxqa 修改sql條件
# Modify.........: No.MOD-8A0178 08/11/20 By liuxqa 修改總計的算法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990073 09/09/29 By chenmoyan 在產品編號后加上品名/規格
# Modify.........: No:MOD-A30040 10/03/10 By Smapmin 報表結果資料重複
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.TQC-C70003 12/07/17 By zhuhao l_sql定義問題
# Modify.........: No.FUN-CB0003 12/12/17 By chenjing CR轉XtraGrid

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,
           c       LIKE type_file.chr1,        # Prog. Version..: '5.30.07-13.05.16(01)    #NO.FUN-650013     
           rpg01   LIKE rpg_file.rpg01,
           date    LIKE type_file.dat,         # No.FUN-680137 DATE
           a       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
           b       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
           o       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
           more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)
           END RECORD
DEFINE     g_rpg    RECORD LIKE rpg_file.*
DEFINE     g_before LIKE type_file.dat         # No.FUN-680137 DATE 
         # START NO.FUN-650013
         # g_date1,g_date2   DATE,
         # g_date3,g_date4   DATE,
         # g_date5,g_date6   DATE,
         # g_date7,g_date8   DATE,
         # g_date9,g_date10  DATE
DEFINE     g_date   ARRAY[10] OF LIKE type_file.dat      # No.FUN-680137 DATE
         # END NO.FUN-650013
 
DEFINE     g_i             LIKE type_file.num5,     #count/index for any purpose        #No.FUN-680137 SMALLINT
           i               LIKE type_file.num5           #No.FUN-680137 SMALLINT
DEFINE     g_before_input_done  LIKE type_file.chr1000   # No.FUN-680137 STRING #NO: FUN-650013
#No.FUN-580013  --begin
#DEFINE   g_dash          VARCHAR(400)   #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580013  --end
DEFINE g_sql       STRING  #NO.FUN-840039
DEFINE l_table     STRING  #NO.FUN-840039
DEFINE g_str       STRING  #NO.FUN-840039
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   #NO.FUN-840039----BEGIN----
   LET g_sql = "betot.oeb_file.oeb12,",
               "tot1.oeb_file.oeb12,",
               "tot2.oeb_file.oeb12,",
               "tot3.oeb_file.oeb12,",
               "tot4.oeb_file.oeb12,",
               "tot5.oeb_file.oeb12,",
               "tot6.oeb_file.oeb12,",
               "tot7.oeb_file.oeb12,",
               "tot8.oeb_file.oeb12,",
               "tot9.oeb_file.oeb12,",
               "tot10.oeb_file.oeb12,",
               "total.oeb_file.oeb12,",
#No.FUN-990073 --Begin
#              "oeb04.oeb_file.oeb04"
               "oeb04.oeb_file.oeb04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "oeb01.oeb_file.oeb01"    #FUN-CB0003
#No.FUN-990073 --End
   LET l_table = cl_prt_temptable('axmx440',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   #NO.FUN-840039----END------   
   
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.c  = ARG_VAL(8)		#NO.FUN-650013	
   LET tm.rpg01  = ARG_VAL(9)
   LET tm.date   = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   LET tm.o  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL x440_tm(0,0)
      ELSE CALL x440()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION x440_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW x440_w AT p_row,p_col WITH FORM "axm/42f/axmx440"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   SELECT MIN(rpg01) INTO tm.rpg01 FROM rpg_file
   LET tm.date = g_today
   LET tm.a	   = '3'
   LET tm.b	   = '3'
   LET tm.c	   = '1'
   LET tm.o	   = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oeb04,oea01,oea02,oea14,oea15
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
       #### No.FUN-4A0017
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oea01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oea7"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea01
                NEXT FIELD oea01
 
              WHEN INFIELD(oea14)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea14
                NEXT FIELD oea14
 
              WHEN INFIELD(oea15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oea15
                NEXT FIELD oea15
 
              WHEN INFIELD(oeb04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oeb04
                NEXT FIELD oeb04
 
           END CASE
      ### END  No.FUN-4A0017
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW x440_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.c, tm.rpg01,tm.date,tm.a,tm.b,tm.o,tm.more
             WITHOUT DEFAULTS
         #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         #START NO.FUN-650013
  	 LET g_before_input_done = FALSE
	 CALL x440_set_entry()
         CALL x440_set_no_entry()
         LET g_before_input_done = TRUE     
      BEFORE FIELD c                            
         CALL x440_set_entry()
      AFTER  FIELD c                            
         CALL x440_set_no_entry()
      AFTER FIELD rpg01                          
         IF NOT cl_null(tm.rpg01) THEN
            SELECT * FROM rpg_file WHERE rpg01 = tm.rpg01
            IF STATUS THEN
               CALL cl_err('sel rpg:',STATUS,0) NEXT FIELD tm.rpg01
            END IF
         END IF
      #END OF NO.FUN-650013 
      AFTER FIELD date
         IF cl_null(tm.date) THEN NEXT FIELD date END IF
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES '[123]' THEN NEXT FIELD b END IF
      AFTER FIELD o
         IF tm.o NOT MATCHES '[12]' THEN NEXT FIELD o END IF
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
      ON ACTION CONTROLP
        CASE WHEN INFIELD(rpg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_rpg'
                  LET g_qryparam.default1 = tm.rpg01
                  CALL cl_create_qry() RETURNING tm.rpg01
#                  CALL FGL_DIALOG_SETBUFFER( tm.rpg01 )
                  DISPLAY BY NAME tm.rpg01
                  NEXT FIELD rpg01
        END CASE
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
      LET INT_FLAG = 0
      CLOSE WINDOW x440_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axmx440'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmx440','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",                #NO.FUN-650013 
                         " '",tm.rpg01 CLIPPED,"'",
                         " '",tm.date CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.o CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmx440',g_time,l_cmd)
      END IF
      CLOSE WINDOW x440_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x440()
   ERROR ""
END WHILE
   CLOSE WINDOW x440_w
END FUNCTION
 
#START NO.FUN-650013
FUNCTION x440_set_entry()                                        
   IF INFIELD(c) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rpg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION x440_set_no_entry()                               
   IF INFIELD(c) OR (NOT g_before_input_done) THEN
      IF tm.c != '1' THEN
         LET tm.rpg01 = NULL
         DISPLAY BY NAME tm.rpg01
         CALL cl_set_comp_entry("rpg01",FALSE)
      END IF
   END IF
END FUNCTION
# END NO.FUN-650013
 
FUNCTION x440()
DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0094
      #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT     #No.FUN-680137 VARCHAR(1000)    #TQC-C70003 mark
      #l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)                            #TQC-C70003 mark
       l_sql     STRING,                       #TQC-C70003 add
       sr        RECORD
                        oeb04   LIKE oeb_file.oeb04,
                        oeb12   LIKE oeb_file.oeb12,
                        oeb15   LIKE oeb_file.oeb15,
                        oeb16   LIKE oeb_file.oeb16,
                        oeahold LIKE oea_file.oeahold,
                        oeaconf LIKE oea_file.oeaconf,
                        oeb01   LIKE oeb_file.oeb01    #FUN-CB0003 add
                        END RECORD
DEFINE  l_betot,l_tot10        LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_tot1,l_tot2          LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_tot3,l_tot4          LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_tot5,l_tot6          LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_tot7,l_tot8          LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_tot9,l_total         LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_betotal,l_total10    LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_total1,l_total2      LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_total3,l_total4      LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_total5,l_total6      LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_total7,l_total8      LIKE oeb_file.oeb12,     #NO.FUN-840039
        l_total9,l_tototal     LIKE oeb_file.oeb12,      #NO.FUN-840039
        l_oeb04_t              LIKE oeb_file.oeb04      #NO.FUN-840039
DEFINE  l_title1               STRING                   #NO.FUN-840039
DEFINE  l_title2               STRING                   #NO.FUN-840039
DEFINE  l_title3               STRING                   #NO.FUN-840039
DEFINE  l_title4               STRING                   #NO.FUN-840039
DEFINE  l_title5               STRING                   #NO.FUN-840039
DEFINE  l_title6               STRING                   #NO.FUN-840039
DEFINE  l_title7               STRING                   #NO.FUN-840039
DEFINE  l_title8               STRING                   #NO.FUN-840039
DEFINE  l_title9               STRING                   #NO.FUN-840039
DEFINE  l_title10              STRING                   #NO.FUN-840039
DEFINE  l_title11              STRING                   #NO.FUN-840039
#No.FUN-990073 --Begin
DEFINE  l_ima02                LIKE ima_file.ima02
DEFINE  l_ima021               LIKE ima_file.ima021
#No.FUN-990073 --End
DEFINE  l_str1                 STRING                   #NO.FUN-CB0003
DEFINE  l_str2                 STRING                   #NO.FUN-CB0003
DEFINE  l_str3                 STRING                   #NO.FUN-CB0003
DEFINE  l_str4                 STRING                   #NO.FUN-CB0003
 
     CALL cl_del_data(l_table)   #MOD-A30040 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580013  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmx440'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580013  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
     #NO.FUN-840039-------BEGIN------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?)"#No.FUN-990073 add ?, ?   #FUN-CB0003 add ?                                                                                                      
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep1:',status,1)           
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD                                                                             
        EXIT PROGRAM                                                                                                                 
     END IF
     #NO.FUN-840039------END---------------
#     LET l_sql = "SELECT oeb04,oeb12,oeb15,oeb16,oeahold,oeaconf ",  #No.MOD-890099 mark by liuxqa
      LET l_sql = "SELECT oeb04,oeb12-oeb24+oeb25,oeb15,oeb16,oeahold,oeaconf,oeb01", #No.MOD-890099 modify by liuxqa #FUN-CB0003 add oeb01
                 "  FROM oea_file,oeb_file ",
                 " WHERE oea01=oeb01 ",
                 "   AND oeb12 > oeb24-oeb25 ",
                 "   AND oea00<>'0' ",
                 "   AND oeb70='N' ",           #未結案
                 "   AND ",tm.wc CLIPPED,
                 "   AND oeaconf != 'X' ", #01/08/16 mandy
                 " ORDER BY oeb04"
 
     PREPARE x440_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE x440_curs1 CURSOR FOR x440_prepare1
 
     SELECT * INTO g_rpg.* FROM rpg_file WHERE rpg01=tm.rpg01
 
#     CALL cl_outnam('axmx440') RETURNING l_name            #NO.FUN-840039
 
#     START REPORT x440_rep TO l_name                       #NO.FUN-840039
#     LET g_pageno = 0                                      #NO.FUN-840039
     # START NO.FUN-650013
     LET g_before=tm.date
     #LET g_date1 =tm.date +g_rpg.rpg101 - 1
     #LET g_date2 =g_date1 +g_rpg.rpg102
     #LET g_date3 =g_date2 +g_rpg.rpg103
     #LET g_date4 =g_date3 +g_rpg.rpg104
     #LET g_date5 =g_date4 +g_rpg.rpg105
     #LET g_date6 =g_date5 +g_rpg.rpg106
     #LET g_date7 =g_date6 +g_rpg.rpg107
     #LET g_date8 =g_date7 +g_rpg.rpg108
     #LET g_date9 =g_date8 +g_rpg.rpg109
     #LET g_date10=g_date9 +g_rpg.rpg110
     FOR i = 1 TO 10 LET g_date[i]= 0 END FOR   
     CASE WHEN tm.c = '1'
          LET g_date[1] =tm.date +g_rpg.rpg101 - 1
          LET g_date[2] =g_date[1] +g_rpg.rpg102
          LET g_date[3] =g_date[2] +g_rpg.rpg103
          LET g_date[4] =g_date[3] +g_rpg.rpg104
          LET g_date[5] =g_date[4] +g_rpg.rpg105
          LET g_date[6] =g_date[5] +g_rpg.rpg106
          LET g_date[7] =g_date[6] +g_rpg.rpg107
          LET g_date[8] =g_date[7] +g_rpg.rpg108
          LET g_date[9] =g_date[8] +g_rpg.rpg109
          LET g_date[10]=g_date[9] +g_rpg.rpg110
        
          WHEN tm.c='2'
          FOR i = 1 TO 10
              LET g_date[i] =tm.date-1+i*1
          END FOR
      
          WHEN tm.c='3'
          FOR i = 1 TO 10
              LET g_date[i] =tm.date-1+i*7
          END FOR
         
          WHEN tm.c='4'
          FOR i = 1 TO 10
              LET g_date[i] =tm.date-1+i*10
          END FOR
         
          WHEN tm.c='5'
          FOR i = 1  TO 10
              LET g_date[i] =tm.date-1+i*30
          END FOR	
     END CASE
     # END NO.FUN-650013
#No.FUN-580013  -begin
#     LET g_zaa[33].zaa08 = tm.date USING 'MM/DD'
#     LET g_zaa[34].zaa08 = g_date1+1 USING 'MM/DD'
#     LET g_zaa[35].zaa08 = g_date2+1 USING 'MM/DD'
#     LET g_zaa[36].zaa08 = g_date3+1 USING 'MM/DD'
#     LET g_zaa[37].zaa08 = g_date4+1 USING 'MM/DD'
#     LET g_zaa[38].zaa08 = g_date5+1 USING 'MM/DD'
#     LET g_zaa[39].zaa08 = g_date6+1 USING 'MM/DD'
#     LET g_zaa[40].zaa08 = g_date7+1 USING 'MM/DD'
#     LET g_zaa[41].zaa08 = g_date8+1 USING 'MM/DD'
#     LET g_zaa[42].zaa08 = g_date9+1 USING 'MM/DD'
#
#     LET g_zaa[45].zaa08 = g_before-1 USING 'MM/DD'
#     LET g_zaa[46].zaa08 = g_date1 USING 'MM/DD'
#     LET g_zaa[47].zaa08 = g_date2 USING 'MM/DD'
#     LET g_zaa[48].zaa08 = g_date3 USING 'MM/DD'
#     LET g_zaa[49].zaa08 = g_date4 USING 'MM/DD'
#     LET g_zaa[50].zaa08 = g_date5 USING 'MM/DD'
#     LET g_zaa[51].zaa08 = g_date6 USING 'MM/DD'
#     LET g_zaa[52].zaa08 = g_date7 USING 'MM/DD'
#     LET g_zaa[53].zaa08 = g_date8 USING 'MM/DD'
#     LET g_zaa[54].zaa08 = g_date9 USING 'MM/DD'
#     LET g_zaa[55].zaa08 = g_date10 USING 'MM/DD'
#No.FUN-580013  -end
#No.FUN-650013  -begin
    #MOD-820058-begin-modify 
#NO.FUN-840039----BEGIN----mark-----
#     LET g_zaa[32].zaa08 = g_before-1 USING 'MM/DD'
#     LET g_zaa[33].zaa08 = tm.date USING 'MM/DD' , ' - '    , g_date[1] USING 'MM/DD'
#     LET g_zaa[34].zaa08 = g_date[1]+1 USING 'MM/DD' , ' - ', g_date[2] USING 'MM/DD'  
#     LET g_zaa[35].zaa08 = g_date[2]+1 USING 'MM/DD' , ' - ', g_date[3] USING 'MM/DD'  
#     LET g_zaa[36].zaa08 = g_date[3]+1 USING 'MM/DD' , ' - ', g_date[4] USING 'MM/DD'  
#     LET g_zaa[37].zaa08 = g_date[4]+1 USING 'MM/DD' , ' - ', g_date[5] USING 'MM/DD'  
#     LET g_zaa[38].zaa08 = g_date[5]+1 USING 'MM/DD' , ' - ', g_date[6] USING 'MM/DD'  
#     LET g_zaa[39].zaa08 = g_date[6]+1 USING 'MM/DD' , ' - ', g_date[7] USING 'MM/DD'  
#     LET g_zaa[40].zaa08 = g_date[7]+1 USING 'MM/DD' , ' - ', g_date[8] USING 'MM/DD'  
#     LET g_zaa[41].zaa08 = g_date[8]+1 USING 'MM/DD' , ' - ', g_date[9] USING 'MM/DD'  
#     LET g_zaa[42].zaa08 = g_date[9]+1 USING 'MM/DD' , ' - ', g_date[10] USING 'MM/DD' 
#NO.FUN-840039--------END-------------
     #LET g_zaa[33].zaa08 = tm.date USING 'MM/DD'
     #LET g_zaa[34].zaa08 = g_date[1]+1 USING 'MM/DD'
     #LET g_zaa[35].zaa08 = g_date[2]+1 USING 'MM/DD'
     #LET g_zaa[36].zaa08 = g_date[3]+1 USING 'MM/DD'
     #LET g_zaa[37].zaa08 = g_date[4]+1 USING 'MM/DD'
     #LET g_zaa[38].zaa08 = g_date[5]+1 USING 'MM/DD'
     #LET g_zaa[39].zaa08 = g_date[6]+1 USING 'MM/DD'
     #LET g_zaa[40].zaa08 = g_date[7]+1 USING 'MM/DD'
     #LET g_zaa[41].zaa08 = g_date[8]+1 USING 'MM/DD'
     #LET g_zaa[42].zaa08 = g_date[9]+1 USING 'MM/DD'
 
     #LET g_zaa[45].zaa08 = g_before-1 USING 'MM/DD'
     #LET g_zaa[46].zaa08 = g_date[1] USING 'MM/DD'
     #LET g_zaa[47].zaa08 = g_date[2] USING 'MM/DD'
     #LET g_zaa[48].zaa08 = g_date[3] USING 'MM/DD'
     #LET g_zaa[49].zaa08 = g_date[4] USING 'MM/DD'
     #LET g_zaa[50].zaa08 = g_date[5] USING 'MM/DD'
     #LET g_zaa[51].zaa08 = g_date[6] USING 'MM/DD'
     #LET g_zaa[52].zaa08 = g_date[7] USING 'MM/DD'
     #LET g_zaa[53].zaa08 = g_date[8] USING 'MM/DD'
     #LET g_zaa[54].zaa08 = g_date[9] USING 'MM/DD'
     #LET g_zaa[55].zaa08 = g_date[10] USING 'MM/DD'
    #MOD-820058-end-mark-modify
#No.FUN-650013
#NO.FUN-840039------BEGIN-----------
     LET l_title1 = g_before-1 USING 'MM/DD'
     LET l_title2 = tm.date USING 'MM/DD' , ' - '    , g_date[1] USING 'MM/DD'
     LET l_title3 = g_date[1]+1 USING 'MM/DD' , ' - ', g_date[2] USING 'MM/DD' 
     LET l_title4 = g_date[2]+1 USING 'MM/DD' , ' - ', g_date[3] USING 'MM/DD'
     LET l_title5 = g_date[3]+1 USING 'MM/DD' , ' - ', g_date[4] USING 'MM/DD'
     LET l_title6 = g_date[4]+1 USING 'MM/DD' , ' - ', g_date[5] USING 'MM/DD'
     LET l_title7 = g_date[5]+1 USING 'MM/DD' , ' - ', g_date[6] USING 'MM/DD'
     LET l_title8 = g_date[6]+1 USING 'MM/DD' , ' - ', g_date[7] USING 'MM/DD'
     LET l_title9 = g_date[7]+1 USING 'MM/DD' , ' - ', g_date[8] USING 'MM/DD'
     LET l_title10 = g_date[8]+1 USING 'MM/DD' , ' - ', g_date[9] USING 'MM/DD'
     LET l_title11 = g_date[9]+1 USING 'MM/DD' , ' - ', g_date[10] USING 'MM/DD' 
#NO.FUN-840039------END-----------
        FOREACH x440_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
         #-->已確認
         IF tm.a = '1' AND sr.oeaconf = 'N' THEN CONTINUE FOREACH END IF
         #-->未確認
         IF tm.a = '2' AND sr.oeaconf = 'Y' THEN CONTINUE FOREACH END IF
         #-->被留置
         IF tm.b = '1' AND cl_null(sr.oeahold) THEN CONTINUE FOREACH END IF
         #-->未留置
	 IF tm.b = '2' AND NOT cl_null(sr.oeahold) THEN CONTINUE FOREACH END IF
         #-->依約定/排定交貨日
         IF tm.o = '2' THEN LET sr.oeb15=sr.oeb16 END IF
#         OUTPUT TO REPORT x440_rep(sr.*)             #NO.FUN-840039--
         #NO.FUN-840039-------------BEGIN-------------------
#         IF cl_null(l_oeb04_t) OR sr.oeb04 <> l_oeb04_t THEN   #No.MOD-8A0178 mark by liuxqa
            LET l_betot=0  LET l_tot1=0  LET l_tot2=0 LET l_tot3=0
            LET l_tot4=0   LET l_tot5=0  LET l_tot6=0 LET l_tot7=0
            LET l_tot8=0   LET l_tot9=0  LET l_tot10=0
#         END IF                                                #No.MOD-8A0178 mark by liuxqa
         LET l_oeb04_t = sr.oeb04
         IF sr.oeb15 < g_before THEN LET l_betot=l_betot+sr.oeb12 END IF
         IF sr.oeb15 >=g_before  AND sr.oeb15 <= g_date[1] THEN
            LET l_tot1=l_tot1+sr.oeb12
         END IF
         IF sr.oeb15 > g_date[1] AND sr.oeb15 <= g_date[2] THEN
            LET l_tot2=l_tot2+sr.oeb12
         END IF
         IF sr.oeb15 > g_date[2] AND sr.oeb15 <= g_date[3] THEN
            LET l_tot3=l_tot3+sr.oeb12
         END IF
         IF sr.oeb15 > g_date[3] AND sr.oeb15 <= g_date[4] THEN
            LET l_tot4=l_tot4+sr.oeb12
         END IF   
         IF sr.oeb15 > g_date[4] AND sr.oeb15 <= g_date[5] THEN
            LET l_tot5=l_tot5+sr.oeb12
         END IF 
         IF sr.oeb15 > g_date[5] AND sr.oeb15 <= g_date[6] THEN
            LET l_tot6=l_tot6+sr.oeb12
         END IF
         IF sr.oeb15 > g_date[6] AND sr.oeb15 <= g_date[7] THEN
            LET l_tot7=l_tot7+sr.oeb12
         END IF
         IF sr.oeb15 > g_date[7] AND sr.oeb15 <= g_date[8] THEN
            LET l_tot8=l_tot8+sr.oeb12
         END IF
         IF sr.oeb15 > g_date[8] AND sr.oeb15 <= g_date[9] THEN
            LET l_tot9=l_tot9+sr.oeb12
         END IF
         IF sr.oeb15 > g_date[9] AND sr.oeb15 <= g_date[10] THEN
            LET l_tot10=l_tot10+sr.oeb12
         END IF
         LET l_total=l_betot+l_tot1+l_tot2+l_tot3+l_tot4+l_tot5+
                   l_tot6 +l_tot7+l_tot8+l_tot9+l_tot10
#No.FUN-990073 --Begin
         SELECT ima02,ima021 INTO l_ima02,l_ima021
           FROM ima_file
          WHERE ima01=sr.oeb04
         IF STATUS=100 THEN
            LET l_ima02=''
            LET l_ima021=''
         END IF
#No.FUN-990073 --End
 
         EXECUTE insert_prep USING l_betot,l_tot1,l_tot2,l_tot3,l_tot4,
              l_tot5,l_tot6,l_tot7,l_tot8,l_tot9,l_tot10,l_total,sr.oeb04
             ,l_ima02,l_ima021,sr.oeb01             #No.FUN-990073 #FUN-CB0003 add sr.oeb01
 
         LET l_betotal=l_betotal+l_betot
         LET l_total1=l_total1+l_tot1
         LET l_total2=l_total2+l_tot2
         LET l_total3=l_total3+l_tot3
         LET l_total4=l_total4+l_tot4
         LET l_total5=l_total5+l_tot5
         LET l_total6=l_total6+l_tot6
         LET l_total7=l_total7+l_tot7
         LET l_total8=l_total8+l_tot8
         LET l_total9=l_total9+l_tot9
         LET l_total10=l_total10+l_tot10
         LET l_tototal=l_betotal+l_total1+l_total2+l_total3+l_total4+l_total5+
                       l_total6 +l_total7+l_total8+l_total9+l_total10
         #NO.FUN-840039-------------END----------------------
     END FOREACH
         #NO.FUN-840039-------------BEGIN-------------------    
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     LET g_xgrid.table = l_table    ###XtraGrid###
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oeb04,oea01,oea02,oea14,oea15')
            RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
###XtraGrid###     LET g_str = tm.wc,";",l_title1,";",l_title2,";",l_title3,";",l_title4,";",
###XtraGrid###                 l_title5,";",l_title6,";",l_title7,";",l_title8,";",
###XtraGrid###                 l_title9,";",l_title10,";",l_title11,";",tm.c,";",
###XtraGrid###                 tm.date,";",tm.a,";",tm.b,";",tm.o
###XtraGrid###     CALL cl_prt_cs3('axmx440','axmx440',g_sql,g_str)
#FUN-CB0003--add--str--

    LET l_str1 = cl_gr_getmsg('gre-320',g_lang,tm.c)
    LET l_str2 = cl_gr_getmsg('gre-321',g_lang,tm.a)
    LET l_str3 = cl_gr_getmsg('gre-322',g_lang,tm.b)
    LET l_str4 = cl_gr_getmsg('gre-323',g_lang,tm.o)
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'betot',l_title1,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot1',l_title2,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot2',l_title3,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot3',l_title4,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot4',l_title5,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot5',l_title6,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot6',l_title7,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot7',l_title8,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot8',l_title9,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot9',l_title10,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'tot10',l_title11,'')
    LET g_xgrid.order_field = 'oeb04'
    LET g_xgrid.grup_field = 'oeb04'
    LET g_xgrid.footerinfo1 = cl_getmsg("lib-081",g_lang),l_str1,"|",cl_getmsg("lib-082",g_lang),tm.date,"|",cl_getmsg("lib-083",g_lang),l_str2,"|",
                              cl_getmsg("lib-084",g_lang),l_str3,"|",cl_getmsg("lib-085",g_lang),l_str4
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
#FUN-CB0003--add--end--
    CALL cl_xg_view()    ###XtraGrid###
         #NO.FUN-840039-------------END----------------------     
#     FINISH REPORT x440_rep                               #NO.FUN-840039
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-840039
END FUNCTION
 
#No.FUN-840039------------BEGIN-----------------------------
#REPORT x440_rep(sr)
#DEFINE l_last_sw   LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(1)
#      sr        RECORD
#                       oeb04   LIKE oeb_file.oeb04,
#                       oeb12   LIKE oeb_file.oeb12,
#                       oeb15   LIKE oeb_file.oeb15,
#                       oeb16   LIKE oeb_file.oeb16,
#                       oeahold LIKE oea_file.oeahold,
#                       oeaconf LIKE oea_file.oeaconf
#                       END RECORD,
#       l_betot,l_tot10    LIKE oeb_file.oeb12,
#       l_tot1,l_tot2      LIKE oeb_file.oeb12,
#       l_tot3,l_tot4      LIKE oeb_file.oeb12,
#       l_tot5,l_tot6      LIKE oeb_file.oeb12,
#       l_tot7,l_tot8      LIKE oeb_file.oeb12,
#       l_tot9,l_total     LIKE oeb_file.oeb12,
#       l_betotal,l_total10    LIKE oeb_file.oeb12,
#       l_total1,l_total2      LIKE oeb_file.oeb12,
#       l_total3,l_total4      LIKE oeb_file.oeb12,
#       l_total5,l_total6      LIKE oeb_file.oeb12,
#       l_total7,l_total8      LIKE oeb_file.oeb12,
#       l_total9,l_tototal     LIKE oeb_file.oeb12,
#       	l_rowno     LIKE type_file.num5        # No.FUN-680137 SMALLINT
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.oeb04
# FORMAT
#  PAGE HEADER
##No.FUN-580013  -begin
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
##      PRINT    #TQC-6C0039
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'   #TQC-6C0039
#     PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT g_dash
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##        COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##     PRINT g_dash[1,g_len]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                    g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#     #MOD-820058-begin-mark
#     #PRINTX name=H2 g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],
#     #               g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56]
#     #MOD-820058-end-mark
#     PRINT g_dash1
##     PRINT g_x[11] CLIPPED,
##           COLUMN 34,tm.date USING 'MM/DD',
##           COLUMN 43,g_date1+1 USING 'MM/DD',
##           COLUMN 52,g_date2+1 USING 'MM/DD',
##           COLUMN 61,g_date3+1 USING 'MM/DD',
##           COLUMN 70,g_date4+1 USING 'MM/DD',
##           COLUMN 79,g_date5+1 USING 'MM/DD',
##           COLUMN 88,g_date6+1 USING 'MM/DD',
##           COLUMN 97,g_date7+1 USING 'MM/DD',
##           COLUMN 106,g_date8+1 USING 'MM/DD',
##           COLUMN 115,g_date9+1 USING 'MM/DD',COLUMN 125,g_x[12] CLIPPED
##     PRINT COLUMN 25,g_before-1 USING 'MM/DD',
##           COLUMN 34,g_date1 USING 'MM/DD',
##           COLUMN 43,g_date2 USING 'MM/DD',COLUMN 52,g_date3 USING 'MM/DD',
##           COLUMN 61,g_date4 USING 'MM/DD',COLUMN 70,g_date5 USING 'MM/DD',
##           COLUMN 79,g_date6 USING 'MM/DD',COLUMN 88,g_date7 USING 'MM/DD',
##           COLUMN 97,g_date8 USING 'MM/DD',COLUMN 106,g_date9 USING 'MM/DD',
##           COLUMN 115,g_date10 USING 'MM/DD'
 
##     PRINT '-------------------- -------- -------- -------- -------- ',
##           '-------- -------- -------- -------- -------- -------- ',
##           '-------- --------'
##No.FUN-580013  -end
#     LET l_last_sw = 'n'
#     IF l_betotal IS NULL OR l_total1 IS NULL THEN
#        LET l_betotal=0   LET l_total1=0  LET l_total2=0  LET l_total3=0
#        LET l_total4=0    LET l_total5=0  LET l_total6=0  LET l_total7=0
#        LET l_total8=0    LET l_total9=0  LET l_total10=0 LET l_tototal=0
#     END IF
 
#  BEFORE GROUP OF sr.oeb04
#        LET l_betot=0  LET l_tot1=0  LET l_tot2=0 LET l_tot3=0
#        LET l_tot4=0   LET l_tot5=0  LET l_tot6=0 LET l_tot7=0
#        LET l_tot8=0   LET l_tot9=0  LET l_tot10=0
 
#  ON EVERY ROW
#        IF sr.oeb15 < g_before THEN LET l_betot=l_betot+sr.oeb12 END IF
#  #     IF sr.oeb15 >=g_before  AND sr.oeb15 <= g_date1 THEN NO.FUN-650013
#        IF sr.oeb15 >=g_before  AND sr.oeb15 <= g_date[1] THEN
#           LET l_tot1=l_tot1+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date1 AND sr.oeb15 <= g_date2 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[1] AND sr.oeb15 <= g_date[2] THEN
#           LET l_tot2=l_tot2+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date2 AND sr.oeb15 <= g_date3 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[2] AND sr.oeb15 <= g_date[3] THEN
#           LET l_tot3=l_tot3+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date3 AND sr.oeb15 <= g_date4 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[3] AND sr.oeb15 <= g_date[4] THEN
#           LET l_tot4=l_tot4+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date4 AND sr.oeb15 <= g_date5 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[4] AND sr.oeb15 <= g_date[5] THEN
#           LET l_tot5=l_tot5+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date5 AND sr.oeb15 <= g_date6 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[5] AND sr.oeb15 <= g_date[6] THEN
#           LET l_tot6=l_tot6+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date6 AND sr.oeb15 <= g_date7 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[6] AND sr.oeb15 <= g_date[7] THEN
#           LET l_tot7=l_tot7+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date7 AND sr.oeb15 <= g_date8 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[7] AND sr.oeb15 <= g_date[8] THEN
#           LET l_tot8=l_tot8+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date8 AND sr.oeb15 <= g_date9 THEN   NO.FUN-650013
#        IF sr.oeb15 > g_date[8] AND sr.oeb15 <= g_date[9] THEN
#           LET l_tot9=l_tot9+sr.oeb12
#        END IF
#  #     IF sr.oeb15 > g_date9 AND sr.oeb15 <= g_date10 THEN  NO.FUN-650013
#        IF sr.oeb15 > g_date[9] AND sr.oeb15 <= g_date[10] THEN
#           LET l_tot10=l_tot10+sr.oeb12
#        END IF
 
#  AFTER GROUP OF sr.oeb04
#     LET l_total=l_betot+l_tot1+l_tot2+l_tot3+l_tot4+l_tot5+
#                  l_tot6 +l_tot7+l_tot8+l_tot9+l_tot10
#     LET l_betotal=l_betotal+l_betot
#     LET l_total1=l_total1+l_tot1
#     LET l_total2=l_total2+l_tot2
#     LET l_total3=l_total3+l_tot3
#     LET l_total4=l_total4+l_tot4
#     LET l_total5=l_total5+l_tot5
#     LET l_total6=l_total6+l_tot6
#     LET l_total7=l_total7+l_tot7
#     LET l_total8=l_total8+l_tot8
#     LET l_total9=l_total9+l_tot9
#     LET l_total10=l_total10+l_tot10
#     LET l_tototal=l_betotal+l_total1+l_total2+l_total3+l_total4+l_total5+
#                   l_total6 +l_total7+l_total8+l_total9+l_total10
##No.FUN-580013  -begin
##     PRINT COLUMN 01,sr.oeb04,
##           COLUMN 22,l_betot USING '#######&',
##           COLUMN 31,l_tot1  USING '#######&',
##           COLUMN 40,l_tot2  USING '#######&',
##           COLUMN 49,l_tot3  USING '#######&',
##           COLUMN 58,l_tot4  USING '#######&',
##           COLUMN 67,l_tot5  USING '#######&',
##           COLUMN 76,l_tot6  USING '#######&',
##           COLUMN 85,l_tot7  USING '#######&',
##           COLUMN 94,l_tot8  USING '#######&',
##           COLUMN 103,l_tot9 USING '#######&',
##           COLUMN 112,l_tot10 USING '#######&',
##           COLUMN 121,l_total USING '#######&'
#     PRINTX name=D1 COLUMN g_c[31],sr.oeb04 CLIPPED,   #TQC-6C0039
#                    COLUMN g_c[32],cl_numfor(l_betot,32,0),
#                    COLUMN g_c[33],cl_numfor(l_tot1,33,0),
#                    COLUMN g_c[34],cl_numfor(l_tot2,34,0),
#                    COLUMN g_c[35],cl_numfor(l_tot3,35,0),
#                    COLUMN g_c[36],cl_numfor(l_tot4,36,0),
#                    COLUMN g_c[37],cl_numfor(l_tot5,37,0),
#                    COLUMN g_c[38],cl_numfor(l_tot6,38,0),
#                    COLUMN g_c[39],cl_numfor(l_tot7,39,0),
#                    COLUMN g_c[40],cl_numfor(l_tot8,40,0),
#                    COLUMN g_c[41],cl_numfor(l_tot9,41,0),
#                    COLUMN g_c[42],cl_numfor(l_tot10,42,0),
#                    COLUMN g_c[43],cl_numfor(l_total,43,0)
##No.FUN-580013  -end
 
#  ON LAST ROW
##No.FUN-580013  -begin
##     PRINT COLUMN 22,'-------- -------- -------- -------- ',
##                     '-------- -------- -------- -------- -------- -------- ',
##                     '-------- --------'
##     PRINT COLUMN 15,g_x[13] CLIPPED,
##           COLUMN 22,l_betotal USING '#######&',
##           COLUMN 31,l_total1  USING '#######&',
##           COLUMN 40,l_total2  USING '#######&',
##           COLUMN 49,l_total3  USING '#######&',
##           COLUMN 58,l_total4  USING '#######&',
##           COLUMN 67,l_total5  USING '#######&',
##           COLUMN 76,l_total6  USING '#######&',
##           COLUMN 85,l_total7  USING '#######&',
##           COLUMN 94,l_total8  USING '#######&',
##           COLUMN 103,l_total9 USING '#######&',
##           COLUMN 112,l_total10 USING '#######&',
##           COLUMN 121,l_tototal USING '#######&'
#     PRINT g_dash1
#     PRINTX name=D1 COLUMN g_c[31],g_x[13] CLIPPED,   #TQC-6C0039
#                    COLUMN g_c[32],cl_numfor(l_betotal,32,0),
#                    COLUMN g_c[33],cl_numfor(l_total1,33,0),
#                    COLUMN g_c[34],cl_numfor(l_total2,34,0),
#                    COLUMN g_c[35],cl_numfor(l_total3,35,0),
#                    COLUMN g_c[36],cl_numfor(l_total4,36,0),
#                    COLUMN g_c[37],cl_numfor(l_total5,37,0),
#                    COLUMN g_c[38],cl_numfor(l_total6,38,0),
#                    COLUMN g_c[39],cl_numfor(l_total7,39,0),
#                    COLUMN g_c[40],cl_numfor(l_total8,40,0),
#                    COLUMN g_c[41],cl_numfor(l_total9,41,0),
#                    COLUMN g_c[42],cl_numfor(l_total10,42,0),
#                    COLUMN g_c[43],cl_numfor(l_tototal,43,0)
##No.FUN-580013  -end
 
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'oeb04,oea01,oea02,oea14,oea15')
#             RETURNING tm.wc
#        PRINT g_dash
#       #TQC-630166
#       #      IF tm.wc[001,120] > ' ' THEN            # for 132
#       #  PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#       #      IF tm.wc[121,240] > ' ' THEN
#       #  PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#       #      IF tm.wc[241,300] > ' ' THEN
#       #  PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#       CALL cl_prt_pos_wc(tm.wc)
#       #END TQC-630166
 
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     # START NO.FUN-650013
#        LET l_betotal=0   LET l_total1=0  LET l_total2=0  LET l_total3=0
#        LET l_total4=0    LET l_total5=0  LET l_total6=0  LET l_total7=0
#        LET l_total8=0    LET l_total9=0  LET l_total10=0 LET l_tototal=0
#     # END NO.FUN-650013
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#Patch....NO.TQC-610037 <> #
#No.FUN-840039----------END------------


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

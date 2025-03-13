# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfr818.4gl
# Descriptions...: Run Card預計最大產量狀況表列印  
# Date & Author..: 00/08/17 By Mandy 
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima021
# Modify.........: NO.FUN-510040 05/02/16 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
#
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-770003 07/07/03 By zhoufeng 維護幫助按鈕
# Modify.........: No.FUN-840039 08/04/20 By Sunyanchun 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.FUN-A60080 10/07/08 By destiny 报表显示增加制程段号字段
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              #wc       VARCHAR(600),   # Where condition  #NO.TQC-630166 MARK
              wc       STRING,  # Where condition
              s        LIKE type_file.chr2,            #No.FUN-680121 VARCHAR(2)# Order by sequence
              t        LIKE type_file.chr2,            #No.FUN-680121 VARCHAR(2)# Eject sw
              more     LIKE type_file.chr1             #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
 
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
DEFINE   g_str            STRING    #NO.FUN-840039
DEFINE   g_sql            STRING    #NO.FUN-840039
DEFINE   l_table          STRING    #NO.FUN-840039
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
   #NO.FUN-840039-----BEGIN----
   LET g_sql = "order1.shm_file.shm05,",     
                "order2.shm_file.shm05,", 
                "shm01.shm_file.shm01,", 
                "shm05.shm_file.shm05,", 
                "shm08.shm_file.shm08,",
                "l_wipqty.shm_file.shm09,",
                "shm09.shm_file.shm09,",
                "sgm45_1.sgm_file.sgm45,",
                "sgm45_2.sgm_file.sgm45,",
                "sgm45_3.sgm_file.sgm45,",
                "sgm45_4.sgm_file.sgm45,",
                "sgm45_5.sgm_file.sgm45,",
                "sgm45_6.sgm_file.sgm45,",
                "sgm45_7.sgm_file.sgm45,",
                "sgm45_8.sgm_file.sgm45,",
                "sgm45_9.sgm_file.sgm45,",
                "sgm45_10.sgm_file.sgm45,",
                "shm012.shm_file.shm012,", 
                "ima02 .ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "wipqty_1.shm_file.shm09,",
                "wipqty_2.shm_file.shm09,", 
                "wipqty_3.shm_file.shm09,",
                "wipqty_4.shm_file.shm09,",
                "wipqty_5.shm_file.shm09,",
                "wipqty_6.shm_file.shm09,",
                "wipqty_7.shm_file.shm09,",
                "wipqty_8.shm_file.shm09,",
                "wipqty_9.shm_file.shm09,",
                "wipqty_10.shm_file.shm09,",
                "sgm03_1.sgm_file.sgm03,",
                "sgm03_2.sgm_file.sgm03,",
                "sgm03_3.sgm_file.sgm03,",
                "sgm03_4.sgm_file.sgm03,",
                "sgm03_5.sgm_file.sgm03,",
                "sgm03_6.sgm_file.sgm03,",
                "sgm03_7.sgm_file.sgm03,",
                "sgm03_8.sgm_file.sgm03,",
                "sgm03_9.sgm_file.sgm03,",
                "sgm03_10.sgm_file.sgm03,",
                "sgm012_1.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_2.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_3.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_4.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_5.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_6.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_7.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_8.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_9.sgm_file.sgm012,",  #NO.FUN-A60080
                "sgm012_10.sgm_file.sgm012"   #NO.FUN-A60080
   LET l_table = cl_prt_temptable('asfr818',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
               "?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,? " ,
               " ,?,?,?,?,?, ?,?,?,?,?) "  #NO.FUN-A60080
               
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep',status,1)
      EXIT PROGRAM
   END IF
   #NO.FUN-840039-----END------
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r818_tm(0,0)        # Input print condition
      ELSE CALL r818()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r818_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,           #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000,        #No.FUN-680121 VARCHAR(400)
          l_n,l_cnt      LIKE type_file.num5,           #No.FUN-680121 SMALLINT
          l_a            LIKE type_file.chr1            #No.FUN-680121 VARCHAR(1)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r818_w AT p_row,p_col
        WITH FORM "asf/42f/asfr818" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '12'
   LET tm.t    = ''
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shm01,shm012,shm05,shm15 
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
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
         ON ACTION help
            CALL cl_show_help()                          #No.TQC-770003
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shmuser', 'shmgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r818_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,
                   tm2.t1,tm2.t2,
                   tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
         ON ACTION help
            CALL cl_show_help()                    #No.TQC-770003
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r818_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr818'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr818','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr818',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r818_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r818()
   ERROR ""
END WHILE
   CLOSE WINDOW r818_w
END FUNCTION
 
FUNCTION r818()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
          l_n       LIKE type_file.num5,           #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,        #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE shm_file.shm05,                 #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          sr        RECORD        order1 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  order2 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                  shm01  LIKE shm_file.shm01,  
                                  shm012 LIKE shm_file.shm012,  
                                  shm05  LIKE shm_file.shm05,  
                                  shm08  LIKE shm_file.shm08,  
                                  shm09  LIKE shm_file.shm09,  
                                  shm15  LIKE shm_file.shm15,  
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021
                    END RECORD
#NO.FUN-840039----BEGIN----
DEFINE    sr1   DYNAMIC ARRAY OF RECORD 
                   sgm03         LIKE sgm_file.sgm03,
                   sgm45         LIKE sgm_file.sgm45,
                   sgm012        LIKE sgm_file.sgm012, #NO.FUN-A60080
                   wipqty        LIKE shm_file.shm09
                END RECORD,
          l_wipqty   LIKE shm_file.shm09,
          l_shm01_t  LIKE shm_file.shm01,
          i          LIKE type_file.num5
#NO.FUN-840039----END------
   ###TQC-9C0179 START ###
   DEFINE l_sgm45_1  LIKE sgm_file.sgm45
   DEFINE l_sgm45_2  LIKE sgm_file.sgm45
   DEFINE l_sgm45_3  LIKE sgm_file.sgm45
   DEFINE l_sgm45_4  LIKE sgm_file.sgm45
   DEFINE l_sgm45_5  LIKE sgm_file.sgm45
   DEFINE l_sgm45_6  LIKE sgm_file.sgm45
   DEFINE l_sgm45_7  LIKE sgm_file.sgm45
   DEFINE l_sgm45_8  LIKE sgm_file.sgm45
   DEFINE l_sgm45_9  LIKE sgm_file.sgm45
   DEFINE l_sgm45_10 LIKE sgm_file.sgm45
   ###TQC-9C0179 END ###
   DEFINE l_t        STRING  #NO.FUN-A60080
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr818'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 180 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     CALL cl_del_data(l_table)
     LET l_sql = "SELECT '','',shm01,shm012,shm05,shm08,shm09,shm15, ",
                 "ima02,ima021 ",
                 "  FROM shm_file,OUTER ima_file ",
                 " WHERE ",tm.wc CLIPPED, 
                 "  AND shm_file.shm05 = ima_file.ima01 " CLIPPED 
 
     PREPARE r818_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE r818_curs1 CURSOR FOR r818_prepare1
 
     #WIP量(wipqty)=  總投入量(良品轉入量sgm301+重工轉入量sgm302+分割轉入sgm303+合併轉入sgm304)
     #               -總轉出量(良品轉出量sgm311+重工轉出量sgm312+分割轉出sgm316+合併轉出sgm317)
     #               -當站報廢量sgm313
     #               -當站下線量(入庫量)sgm314
     LET l_sql = "SELECT sgm03,sgm45,sgm012, ", #NO.FUN-A60080
                 "SUM((sgm301+sgm302+sgm303+sgm304)-sgm59*(sgm311+sgm312+sgm316+sgm317+sgm313+sgm314)) ", 
                 "  FROM sgm_file WHERE sgm01 = ? ",
                 "GROUP BY sgm03,sgm45,sgm012  ORDER BY sgm03" CLIPPED #NO.FUN-A60080
 
     PREPARE r818_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE r818_curs2 CURSOR FOR r818_prepare2      
 
#     CALL cl_outnam('asfr818') RETURNING l_name    #NO.FUN-840039
#     START REPORT r818_rep TO l_name               #NO.FUN-840039 
 
#    LET g_pageno = 0                               #NO.FUN-840039
     FOREACH r818_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.shm01 
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.shm012 
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.shm05 
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.shm15 
               OTHERWISE LET l_order[g_i] = '-'
         END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       #NO.FUN-840039-----BEGIN-----
       #GROUP sr.shm01
       IF cl_null(l_shm01_t) OR l_shm01_t <> sr.shm01 THEN
          LET l_n = 1 
          LET l_wipqty=sr.shm09 
          FOR i = 1 TO 10
             INITIALIZE sr1[i].* TO NULL 
          END FOR
          FOREACH r818_curs2 USING sr.shm01 INTO sr1[l_n].*
             IF STATUS THEN EXIT FOREACH END IF 
             IF cl_null(sr1[l_n].wipqty)  THEN LET sr1[l_n].wipqty=0 END IF
             IF NOT cl_null(sr1[l_n].wipqty) THEN             
                LET l_wipqty=l_wipqty+sr1[l_n].wipqty
                LET l_n = l_n + 1 
                IF l_n > 10 THEN EXIT FOREACH END IF 
             END IF
          END FOREACH
       END IF
       FOR i = 1 TO 10
          IF NOT cl_null(sr1[i].sgm03) THEN 
             LET sr1[i].sgm45 = sr1[i].sgm45[1,10];
          END IF 
       END FOR
       ###TQC-9C0179 START ###
       LET l_sgm45_1 = sr1[2].sgm45[1,10]
       LET l_sgm45_2 = sr1[2].sgm45[1,10]
       LET l_sgm45_3 = sr1[2].sgm45[1,10]
       LET l_sgm45_4 = sr1[2].sgm45[1,10]
       LET l_sgm45_5 = sr1[2].sgm45[1,10]
       LET l_sgm45_6 = sr1[2].sgm45[1,10]
       LET l_sgm45_7 = sr1[2].sgm45[1,10]
       LET l_sgm45_8 = sr1[2].sgm45[1,10]
       LET l_sgm45_9 = sr1[2].sgm45[1,10]
       LET l_sgm45_10 = sr1[2].sgm45[1,10]
       ###TQC-9C0179 END ###
       EXECUTE insert_prep USING sr.order1,sr.order2,sr.shm01,sr.shm05,sr.shm08,
            ###TQC-9C0179 mark START ###
            #l_wipqty,sr.shm09,sr1[1].sgm45[1,10],sr1[2].sgm45[1,10],
            #sr1[3].sgm45[1,10],sr1[4].sgm45[1,10],sr1[5].sgm45[1,10],
            #sr1[6].sgm45[1,10],sr1[7].sgm45[1,10],sr1[8].sgm45[1,10],
            #sr1[9].sgm45[1,10],sr1[10].sgm45[1,10],sr.shm012,sr.ima02,
            ###TQC-9C0179 mark END ###
            ###TQC-9C0179 START ###
            l_wipqty,sr.shm09,l_sgm45_1,l_sgm45_2,
            l_sgm45_3,l_sgm45_4,l_sgm45_5,
            l_sgm45_6,l_sgm45_7,l_sgm45_8,
            l_sgm45_9,l_sgm45_10,sr.shm012,sr.ima02,
            ###TQC-9C0179 END ###
            sr.ima021,sr1[1].wipqty,sr1[2].wipqty,sr1[3].wipqty,sr1[4].wipqty,
            sr1[5].wipqty,sr1[6].wipqty,sr1[7].wipqty,sr1[8].wipqty,
            sr1[9].wipqty,sr1[10].wipqty,sr1[1].sgm03,sr1[2].sgm03,
            sr1[3].sgm03,sr1[4].sgm03,sr1[5].sgm03,sr1[6].sgm03,
            sr1[7].sgm03,sr1[8].sgm03,sr1[9].sgm03,sr1[10].sgm03,
            sr1[1].sgm012,sr1[2].sgm012,sr1[3].sgm012,sr1[4].sgm012,
            sr1[5].sgm012,sr1[6].sgm012,sr1[7].sgm012,sr1[8].sgm012,
            sr1[9].sgm012,sr1[10].sgm012
            
       #OUTPUT TO REPORT r818_rep(sr.*)
       #NO.FUN-840039-----END-------   
     END FOREACH
     #NO.FUN-840039-----begin-------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'shm01,shm131,shm06,shm133,shm134')
            RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     LET g_str=tm.wc,";",tm.t[1,1],";",tm.t[2,2]
     #NO.FUN-A60080--begin
     IF g_sma.sma541='Y' THEN  
        LET l_t='asfr818_1'
     ELSE 
     	  LET l_t='asfr818'
     END IF 
     #CALL cl_prt_cs3('asfr818','asfr818',g_sql,g_str)
     CALL cl_prt_cs3('asfr818',l_t,g_sql,g_str)
     #NO.FUN-A60080--end
     #FINISH REPORT r818_rep                                                                                                         
                                                                                                                                    
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-840039-----END------- 
 
END FUNCTION
#NO.FUN-840039----------BEGIN------------
#REPORT r818_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,                          #No.FUN-680121 VARCHAR(1)
#       sr        RECORD          order1 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                                 order2 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                                 shm01  LIKE shm_file.shm01,  
#                                 shm012 LIKE shm_file.shm012,  
#                                 shm05  LIKE shm_file.shm05,  
#                                 shm08  LIKE shm_file.shm08,  
#                                 shm09  LIKE shm_file.shm09,  
#                                 shm15  LIKE shm_file.shm15,  
#                                 ima02  LIKE ima_file.ima02,
#                                 ima021 LIKE ima_file.ima021
#                 END RECORD,
#      sr1        DYNAMIC ARRAY OF RECORD 
#                 sgm03         LIKE sgm_file.sgm03,
#                 sgm45         LIKE sgm_file.sgm45,
#                 wipqty        LIKE shm_file.shm09        #No.FUN-680121 DEC(12,2)
#                 END RECORD,
#     l_wipqty   LIKE shm_file.shm09,         #No.FUN-680121 DEC(12,2)
#     i,j,l_n    LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
# ORDER BY sr.order1,sr.order2,sr.shm01 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT ' '
#     PRINT g_dash[1,g_len]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#     PRINTX name=H2 g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],
#            g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],g_x[60]
#     PRINT g_dash1  
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#  BEFORE GROUP OF sr.shm01    
#     LET l_n = 1 
#     LET l_wipqty=sr.shm09 
#     FOR i = 1 TO 10
#         INITIALIZE sr1[i].* TO NULL 
#     END FOR
#     FOREACH r818_curs2 USING sr.shm01 INTO sr1[l_n].*
#         IF STATUS THEN EXIT FOREACH END IF 
#         IF NOT cl_null(sr1[l_n].wipqty) THEN 
#            IF cl_null(sr1[l_n].wipqty)  THEN LET sr1[l_n].wipqty=0 END IF 
#            LET l_wipqty=l_wipqty+sr1[l_n].wipqty
#            LET l_n = l_n + 1 
#            IF l_n > 10 THEN EXIT FOREACH END IF 
#         END IF 
#     END FOREACH 
#     PRINTX name=D1 COLUMN g_c[31],sr.shm01,
#           COLUMN g_c[32],sr.shm05,
#           COLUMN g_c[33],sr.shm08 USING '--------------------------&.&&',
#           COLUMN g_c[34],l_wipqty USING '--------&.&&',
#           COLUMN g_c[35],sr.shm09 USING '--------&.&&';
 
#  ON EVERY ROW
#     LET j = 36
#     FOR i = 1 TO 10       #check 單號其每個 sgm45 print 位置
#      IF NOT cl_null(sr1[i].sgm03) THEN 
#         PRINTX name=D1 COLUMN g_c[j], sr1[i].sgm45[1,10];
#         LET j = j + 1
#      END IF 
#     END FOR      
#     PRINT '' 
#    #print 品名/規格 
#     PRINTX name=D2 COLUMN g_c[46], sr.shm012,
#           COLUMN g_c[47],sr.ima02 CLIPPED,
#            COLUMN g_c[48],sr.ima021 CLIPPED;  #MOD-4A0238
#     LET j = 51
#     FOR i = 1 TO 10      #check 單號其每個 sgm45之wipqty print 位置
#      IF NOT cl_null(sr1[i].sgm03) THEN 
#         PRINTX name=D2 COLUMN g_c[j], sr1[i].wipqty USING '------&.&&';
#         LET j = j+1
#      END IF 
#     END FOR      
#     LET j = 0
#     PRINT '' 
 
#  AFTER GROUP OF sr.order1
#     PRINT ''
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#      CALL cl_wcchp(tm.wc,'shm01,shm131,shm06,shm133,shm134') RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#NO.TQC-631066 start-
#              IF tm.wc[001,120] > ' ' THEN            # for 132
#          PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              IF tm.wc[121,240] > ' ' THEN
#          PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#              IF tm.wc[241,300] > ' ' THEN
#          PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#          CALL cl_prt_pos_wc(tm.wc)
#NO.TQC-630166 end--
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-840039----END---------
#No.FUN-870144

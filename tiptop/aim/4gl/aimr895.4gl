# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimr895.4gl
# Descriptions...: 盤點資料產生參數列印作業
# Input parameter:
# Return code....:
# Date & Author..: 93/05/17 By Apple
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-740129 07/04/21 By sherry  打印中“FROM”跟頁次不在同一行，頁次格式有誤。
# Modify.........: No.FUN-7B0138 07/12/14 By Lutingting 轉為用Crystal Report 輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD                            # Print condition RECORD
              wc   STRING,                      # Where Condition  #TQC-630166
              more    LIKE type_file.chr1       # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
              END RECORD,
       g_pic  RECORD LIKE pic_file.*
DEFINE g_i    LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE l_table  STRING                #No.FUN-7B0138
DEFINE g_str    STRING                #No.FUN-7B0138
DEFINE g_sql    STRING                #No.FUN-7B0138 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#No.FUN-7B0138--start--
   LET g_sql = "pic01.pic_file.pic01,",     
               "pic02.pic_file.pic02,",     
               "pic03.pic_file.pic03,",     
               "pic04.pic_file.pic04,",     
               "pic05.pic_file.pic05,",     
               "pic25.pic_file.pic25,",     
               "pic06.pic_file.pic06,",     
               "pic26.pic_file.pic26,",     
               "pic08.pic_file.pic08,",     
               "pic07.pic_file.pic07,",     
               "pic27.pic_file.pic27,",     
               "pic11.pic_file.pic11,",     
               "pic31.pic_file.pic31,",     
               "pic12.pic_file.pic12,",     
               "pic32.pic_file.pic32,",     
               "pic13.pic_file.pic13,",     
               "pic33.pic_file.pic33,",     
               "pic14.pic_file.pic14,",     
               "pic34.pic_file.pic34,",     
               "pic15.pic_file.pic15,",     
               "pic35.pic_file.pic35,",     
               "pic17.pic_file.pic17,",     
               "pic37.pic_file.pic37,",     
               "pic20.pic_file.pic20,",     
               "pic40.pic_file.pic40,",     
               "pic16.pic_file.pic16,",     
               "pic36.pic_file.pic36,",     
               "pic18.pic_file.pic18,",     
               "pic38.pic_file.pic38,",     
               "pic19.pic_file.pic19,",     
               "pic39.pic_file.pic39,",     
               "g_pic211.pic_file.pic21,",  
               "g_pic212.pic_file.pic21,",  
               "g_pic213.pic_file.pic21,",  
               "g_pic214.pic_file.pic21,",  
               "g_pic215.pic_file.pic21," , 
               "g_pic216.pic_file.pic21,",  
               "pic22.pic_file.pic22,",
               "g_pic411.pic_file.pic41,",   
               "g_pic412.pic_file.pic41,",   
               "g_pic413.pic_file.pic41,",   
               "g_pic414.pic_file.pic41,",   
               "g_pic415.pic_file.pic41,",   
               "g_pic416.pic_file.pic41"
   LET l_table = cl_prt_temptable('aimr895',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1)  EXIT PROGRAM
   END IF
#No.FUN-7B0138--end
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)          #TQC-610072
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr895_tm(0,0)        # Input print condition
      ELSE CALL aimr895()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr895_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 9 LET p_col = 22
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW aimr895_w AT p_row,p_col
        WITH FORM "aim/42f/aimr895"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pic01,pic03,pic04
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimr895_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr895_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr895'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr895','9031',1)
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
                         " '",tm.wc CLIPPED,"'",                #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr895',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr895_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr895()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr895_w
END FUNCTION
 
FUNCTION aimr895()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                       # RDSQL STATEMENT     #TQC-630166
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[6] OF LIKE zaa_file.zaa08,      #No.FUN-690026 VARCHAR(12)
          sr        RECORD
                    times  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
                    g_pic  RECORD LIKE pic_file.*,
                    stk1   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    stk2   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    stk3   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    stk4   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    stk5   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    stk6   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    wip1   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    wip2   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    wip3   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    wip4   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    wip5   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
                    wip6   LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(12)
                    END RECORD
   ###TQC-9C0179 START ###
   DEFINE l_pic21_1 LIKE pic_file.pic21  
   DEFINE l_pic21_2 LIKE pic_file.pic21 
   DEFINE l_pic21_3 LIKE pic_file.pic21 
   DEFINE l_pic21_4 LIKE pic_file.pic21 
   DEFINE l_pic21_5 LIKE pic_file.pic21 
   DEFINE l_pic21_6 LIKE pic_file.pic21
   DEFINE l_pic41_1 LIKE pic_file.pic41  
   DEFINE l_pic41_2 LIKE pic_file.pic41 
   DEFINE l_pic41_3 LIKE pic_file.pic41 
   DEFINE l_pic41_4 LIKE pic_file.pic41 
   DEFINE l_pic41_5 LIKE pic_file.pic41 
   DEFINE l_pic41_6 LIKE pic_file.pic41
   ###TQC-9C0179 END ###
 
     CALL cl_del_data(l_table)                                    #No.FUN-7B0138
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr895'  #No.FUN-7B0138
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr895'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     LET l_sql = "SELECT 0,pic_file.* ",
                 "  FROM pic_file ",
                 " WHERE ",tm.wc clipped
     PREPARE aimr895_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE aimr895_curs1 CURSOR FOR aimr895_prepare1
 
#     CALL cl_outnam('aimr895') RETURNING l_name  #No.FUN-7B0138
#     START REPORT aimr895_rep TO l_name          #No.FUN-7B0138
 
#     LET g_pageno = 0                            #No.FUN-7B0138
     FOREACH aimr895_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
       LET sr.times = sr.times + 1
#No.FUN-7B0138--START--
#      FOR g_i = 1 TO 6
#         CASE WHEN sr.g_pic.pic21[g_i,g_i] = '1' LET l_order[g_i] = g_x[30]
#              WHEN sr.g_pic.pic21[g_i,g_i] = '2' LET l_order[g_i] = g_x[31]
#              WHEN sr.g_pic.pic21[g_i,g_i] = '3' LET l_order[g_i] = g_x[32]
#              WHEN sr.g_pic.pic21[g_i,g_i] = '4' LET l_order[g_i] = g_x[33]
#              WHEN sr.g_pic.pic21[g_i,g_i] = '5' LET l_order[g_i] = g_x[34]
#              WHEN sr.g_pic.pic21[g_i,g_i] = '6'
#                  CASE
#                   WHEN sr.g_pic.pic22 = '0' LET l_order[g_i] = g_x[35]
#                   WHEN sr.g_pic.pic22 = '1' LET l_order[g_i] = g_x[36]
#                   WHEN sr.g_pic.pic22 = '2' LET l_order[g_i] = g_x[37]
#                   WHEN sr.g_pic.pic22 = '3' LET l_order[g_i] = g_x[38]
#                   WHEN sr.g_pic.pic22 = '4' LET l_order[g_i] = g_x[39]
#                  END CASE
#              OTHERWISE LET l_order[g_i] = ''
#         END CASE
#      END FOR
#      LET sr.stk1 = l_order[1] LET sr.stk2 = l_order[2]
#      LET sr.stk3 = l_order[3] LET sr.stk4 = l_order[4]
#      LET sr.stk5 = l_order[5] LET sr.stk6 = l_order[6]
#      FOR g_i = 1 TO 6
#         CASE WHEN sr.g_pic.pic41[g_i,g_i] = '1'
#                   LET l_order[g_i] = g_x[40]
#              WHEN sr.g_pic.pic41[g_i,g_i] = '2'
#                   LET l_order[g_i] = g_x[41]
#              WHEN sr.g_pic.pic41[g_i,g_i] = '3'
#                   LET l_order[g_i] = g_x[42]
#              WHEN sr.g_pic.pic41[g_i,g_i] = '4'
#                   LET l_order[g_i] = g_x[43]
#              WHEN sr.g_pic.pic41[g_i,g_i] = '5'
#                   LET l_order[g_i] = g_x[44]
#              WHEN sr.g_pic.pic41[g_i,g_i] = '6'
#                   LET l_order[g_i] = g_x[45]
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.wip1 = l_order[1] LET sr.wip2 = l_order[2]
#      LET sr.wip3 = l_order[3] LET sr.wip4 = l_order[4]
#      LET sr.wip5 = l_order[5] LET sr.wip6 = l_order[6]
 
#      OUTPUT TO REPORT aimr895_rep(sr.*)
       ###TQC-9C0179 START ###
       LET l_pic21_1 = sr.g_pic.pic21[1,1]
       LET l_pic21_2 = sr.g_pic.pic21[2,2]
       LET l_pic21_3 = sr.g_pic.pic21[3,3]
       LET l_pic21_4 = sr.g_pic.pic21[4,4]
       LET l_pic21_5 = sr.g_pic.pic21[5,5]
       LET l_pic21_6 = sr.g_pic.pic21[6,6]
       LET l_pic41_1 = sr.g_pic.pic41[1,1]
       LET l_pic41_2 = sr.g_pic.pic41[2,2]
       LET l_pic41_3 = sr.g_pic.pic41[3,3]
       LET l_pic41_4 = sr.g_pic.pic41[4,4]
       LET l_pic41_5 = sr.g_pic.pic41[5,5]
       LET l_pic41_6 = sr.g_pic.pic41[6,6]
       ###TQC-9C0179 END ###
       EXECUTE insert_prep USING
         sr.g_pic.pic01,sr.g_pic.pic02,sr.g_pic.pic03,sr.g_pic.pic04,    
         sr.g_pic.pic05,sr.g_pic.pic25,sr.g_pic.pic06,sr.g_pic.pic26,    
         sr.g_pic.pic08,sr.g_pic.pic07,sr.g_pic.pic27,sr.g_pic.pic11,    
         sr.g_pic.pic31,sr.g_pic.pic12,sr.g_pic.pic32,sr.g_pic.pic13,    
         sr.g_pic.pic33,sr.g_pic.pic14,sr.g_pic.pic34,sr.g_pic.pic15,    
         sr.g_pic.pic35,sr.g_pic.pic17,sr.g_pic.pic37,sr.g_pic.pic20,    
         sr.g_pic.pic40,sr.g_pic.pic16,sr.g_pic.pic36,sr.g_pic.pic18,    
         #sr.g_pic.pic38,sr.g_pic.pic19,sr.g_pic.pic39,sr.g_pic.pic21[1,1],                #TQC-9C0179 mark
         #sr.g_pic.pic21[2,2],sr.g_pic.pic21[3,3],sr.g_pic.pic21[4,4],                     #TQC-9C0179 mark
         #sr.g_pic.pic21[5,5],sr.g_pic.pic21[6,6],sr.g_pic.pic22,sr.g_pic.pic41[1,1],      #TQC-9C0179 mark
         #sr.g_pic.pic41[2,2],sr.g_pic.pic41[3,3],sr.g_pic.pic41[4,4],sr.g_pic.pic41[5,5], #TQC-9C0179 mark
         #sr.g_pic.pic41[6,6]                                                              #TQC-9C0179 mark
         sr.g_pic.pic38,sr.g_pic.pic19,sr.g_pic.pic39,l_pic21_1, #TQC-9C0179
         l_pic21_2,l_pic21_3,l_pic21_4,                          #TQC-9C0179
         l_pic21_5,l_pic21_6,sr.g_pic.pic22,l_pic41_1,           #TQC-9C0179
         l_pic41_2,l_pic41_3,l_pic41_4,l_pic41_5,                #TQC-9C0179
         l_pic41_6                                               #TQC-9C0179 
#No.FUN-7B0138--end             
     END FOREACH
#No.FUN-7B0138--start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'pic01,pic03,pic04')
 
         RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('aimr895','aimr895',g_sql,g_str)
#     FINISH REPORT aimr895_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7B0138--end
END FUNCTION
 
#No.FUN-7B0138--START--
#REPORT aimr895_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#         sr           RECORD
#                      times  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#                      g_pic  RECORD LIKE pic_file.*,
#                      stk1   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      stk2   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      stk3   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      stk4   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      stk5   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      stk6   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      wip1   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      wip2   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      wip3   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      wip4   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      wip5   LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(12)
#                      wip6   LIKE zaa_file.zaa08     #No.FUN-690026 VARCHAR(12)
#                      END RECORD
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.times
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#   # PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED    #No.TQC-740129
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED    #No.TQC-740129
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     IF (PAGENO > 1 OR LINENO > 7)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#     PRINT sr.g_pic.pic01,column 20,g_x[11] clipped
#     PRINT sr.g_pic.pic02,column 20,g_x[12] clipped
#     PRINT sr.g_pic.pic03,column 20,g_x[13] clipped
#     PRINT sr.g_pic.pic04,column 20,g_x[14] clipped
#     PRINT ' '
#     IF sr.g_pic.pic05 matches'[Yy]' THEN
#          PRINT column 2,g_x[15] clipped ;
#     ELSE PRINT column 2,g_x[28] clipped ;
#     END IF
#     IF sr.g_pic.pic25 matches'[Yy]' THEN
#          PRINT column 42,g_x[16] clipped
#     ELSE PRINT column 42,g_x[29] clipped
#     END IF
#     PRINT '---------------- ',column 42,'----------------'
 
#     IF sr.g_pic.pic05 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic06, column 20,g_x[17] clipped;
#     END IF
#     IF sr.g_pic.pic25 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic26,
#              column 61,g_x[17] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic05 matches'[Yy]' THEN
#        IF sr.g_pic.pic08 matches'[Yy]' THEN
#            PRINT column 2,g_x[19] clipped,column 20,g_x[20] clipped
#        ELSE
#            PRINT column 2,g_x[18] clipped,column 20,g_x[20] clipped
#        END IF
#     END IF
 
#     IF sr.g_pic.pic05 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic07, column 20,g_x[21] clipped;
#     END IF
#     IF sr.g_pic.pic25 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic27,
#              column 61,g_x[21] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic05 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic11, column 20,g_x[22] clipped;
#     END IF
#     IF sr.g_pic.pic25 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic31,
#              column 61,g_x[22] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic05 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic12, column 20,g_x[23] clipped;
#     END IF
#     IF sr.g_pic.pic25 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic32,
#              column 61,g_x[23] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic05 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic13, column 20,g_x[24] clipped;
#     END IF
#     IF sr.g_pic.pic25 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic33,
#              column 61,g_x[24] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic14 matches'[Yy]' THEN
#          PRINT column 2,g_x[25] clipped;
#     ELSE PRINT column 2,g_x[18] clipped,g_x[25] clipped;
#     END IF
 
#     IF sr.g_pic.pic25 matches'[Yy]' THEN
#        IF sr.g_pic.pic34 matches'[Yy]' THEN
#             PRINT column 42,g_x[25] clipped
#        ELSE PRINT column 42,g_x[18] clipped,g_x[25] clipped
#        END IF
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic14 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic15, column 20,g_x[17] clipped;
#     END IF
#     IF sr.g_pic.pic34 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic35, column 61,g_x[17] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic14 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic17, column 20,g_x[26] clipped;
#     END IF
#     IF sr.g_pic.pic34 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic37, column 61,g_x[26] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic14 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic20, column 20,g_x[24] clipped;
#     END IF
#     IF sr.g_pic.pic34 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic40, column 61,g_x[24] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic14 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic16, column 20,g_x[21] clipped;
#     END IF
#     IF sr.g_pic.pic34 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic36, column 61,g_x[21] clipped
#     ELSE PRINT ''
#     END IF
 
#     IF sr.g_pic.pic14 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic18, column 20,g_x[22] clipped;
#     END IF
#     IF sr.g_pic.pic34 matches'[Yy]' THEN
#        PRINT column 44,sr.g_pic.pic38, column 61,g_x[22] clipped
#     ELSE PRINT ' '
#     END IF
 
#     IF sr.g_pic.pic14 matches'[Yy]' THEN
#        PRINT column 2,sr.g_pic.pic19, column 20,g_x[23] clipped;
#     END IF
#     IF sr.g_pic.pic34 matches'[Yy]' THEN
#          PRINT column 44,sr.g_pic.pic39, column 61,g_x[23] clipped
#     ELSE PRINT ' '
#     END IF
#     PRINT column 2,g_x[27] clipped;
#        IF sr.g_pic.pic25 matches '[Yy]' THEN
#             PRINT column 42,g_x[27] clipped
#        ELSE PRINT ' '
#     END IF
#     PRINT column 4,sr.stk1 clipped;
#        IF sr.g_pic.pic25 matches '[Yy]' THEN
#             PRINT column 44,sr.wip1 clipped
#        ELSE PRINT ' '
#        END IF
#     PRINT column 4,sr.stk2 clipped;
#        IF sr.g_pic.pic25 matches '[Yy]' THEN
#             PRINT column 44,sr.wip2 clipped
#        ELSE PRINT ' '
#        END IF
#     PRINT column 4,sr.stk3 clipped;
#        IF sr.g_pic.pic25 matches '[Yy]' THEN
#             PRINT column 44,sr.wip3 clipped
#        ELSE PRINT ' '
#        END IF
#     PRINT column 4,sr.stk4 clipped;
#        IF sr.g_pic.pic25 matches '[Yy]' THEN
#             PRINT column 44,sr.wip4 clipped
#        ELSE PRINT ' '
#        END IF
#     PRINT column 4,sr.stk5 clipped;
#        IF sr.g_pic.pic25 matches '[Yy]' THEN
#             PRINT column 44,sr.wip5 clipped
#        ELSE PRINT ' '
#        END IF
#     PRINT column 4,sr.stk6 clipped;
#        IF sr.g_pic.pic25 matches '[Yy]' THEN
#             PRINT column 44,sr.wip6 clipped
#        ELSE PRINT ' '
#        END IF
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'pic01,pic03,pic04')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
##TQC-630166
##            IF tm.wc[001,120] > ' ' THEN            # for 132
##        PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##            IF tm.wc[121,240] > ' ' THEN
##        PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##            IF tm.wc[241,300] > ' ' THEN
##        PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)
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
# END REPORT
#Patch....NO.TQC-610036 <001> #
#No.FUN-7B0138--end
 

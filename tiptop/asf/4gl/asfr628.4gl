# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asfr628.4gl
# Descriptions...: 工單完工/入庫/入庫退回明細表列印
# Date & Author..: 98/06/11  By  Star
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-560069 05/06/24 By jackie 雙單位報表格式修改
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-580005 05/08/05 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660134 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-6A0102 06/11/15 By johnray 報表修改
# Modify.........: No.TQC-760202 07/06/29 By chenl   報表格式修改。
# Modify.........: No.FUN-840049 08/04/14 By xiaofeizhu 報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 過單到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C20217 12/02/16 By destiny ksc03 >ksd17 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17          #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680121 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
   DEFINE tm  RECORD                   # Print condition RECORD
#             wc      VARCHAR(800),       # Where condition   #TQC-630166
              wc      STRING,          # Where condition   #TQC-630166
              s       LIKE type_file.chr3,           #No.FUN-680121 VARCHAR(3)
              t       LIKE type_file.chr3,           #No.FUN-680121 VARCHAR(3)
              u       LIKE type_file.chr3,           #No.FUN-680121 VARCHAR(3)
              more    LIKE type_file.chr1            #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
          g_ordera   ARRAY[6] OF LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#FUN-5B0105 10->40
          g_ksc00 LIKE ksc_file.ksc00,
          g_program      LIKE zaa_file.zaa01                   #No.FUN-680121 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5                   #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-580005 --start--
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580005 --end--
DEFINE   l_table         STRING,                     ### FUN-840049 ###                                                                
         g_str           STRING,                     ### FUN-840049 ###                                                                
         g_sql           STRING                      ### FUN-840049 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
### *** FUN-840049 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "ksc00.ksc_file.ksc00,",
                "ksc03.ksc_file.ksc03,",
                "ksc01.ksc_file.ksc01,",
                "ksc02.ksc_file.ksc02,",
                "ksc04.ksc_file.ksc04,",
                "ksd03.ksd_file.ksd03,",
                "ksd11.ksd_file.ksd11,",
                "ksd14.ksd_file.ksd14,",
                "ksd15.ksd_file.ksd15,",
                "ksd04.ksd_file.ksd04,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "ksd08.ksd_file.ksd08,",
                "ksd09.ksd_file.ksd09,",
                "ksd13.ksd_file.ksd13,",
                "ksd12.ksd_file.ksd12,",
                "ksd05.ksd_file.ksd05,",
                "ksd06.ksd_file.ksd06,",
                "ksd07.ksd_file.ksd07,",
                "l_gem02.gem_file.gem02,",
                "l_str2.type_file.chr1000"
 
    LET l_table = cl_prt_temptable('asfr628',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                             
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                           
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_program = ARG_VAL(1)
   LET g_ksc00 = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)            # Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET tm.wc = ARG_VAL(9)
   LET tm.s  = ARG_VAL(10)
   #TQC-610080-begin
   LET tm.t  = ARG_VAL(11)
   LET tm.u  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(11)
   #LET g_rep_clas = ARG_VAL(12)
   #LET g_template = ARG_VAL(13)
   ##No.FUN-570264 ---end---
   #LET tm.t  = ARG_VAL(10)
   #LET tm.u  = ARG_VAL(10)
   #TQC-610080-end
   IF cl_null(g_program) THEN LET g_program = 'asfr628' END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r628_tm(0,0)        # Input print condition
      ELSE CALL r628()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r628_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 CAHR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW r628_w AT p_row,p_col
      WITH FORM "asf/42f/asfr628"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ksc01,ksc02,ksc03,ksd11,ksc04,ksd04
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(ksd04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ksd04
               NEXT FIELD ksd04
            END IF
#No.FUN-570240 --end--
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
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r628_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r628_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr628'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr628','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_program CLIPPED,"'",            #TQC-610080   
                         " '",g_ksc00   CLIPPED,"'",            #TQC-610080
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr628',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r628_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r628()
   ERROR ""
END WHILE
   CLOSE WINDOW r628_w
END FUNCTION
 
FUNCTION r628()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQAC-630166        #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,          # RDSQL STATEMENT    #TQAC-630166
          l_order   ARRAY[6] OF LIKE ksd_file.ksd04,    #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          sr        RECORD
                    order1  LIKE ksd_file.ksd04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order2  LIKE ksd_file.ksd04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order3  LIKE ksd_file.ksd04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    ksc00   LIKE ksc_file.ksc00,
                   #ksc03   LIKE ksc_file.ksc03, #TQC-C20217
                    ksd17   LIKE ksd_file.ksd17, #TQC-C20217
                    ksc01   LIKE ksc_file.ksc01,
                    ksc02   LIKE ksc_file.ksc02,
                    ksc04   LIKE ksc_file.ksc04,
                    ksd03   LIKE ksd_file.ksd03,
                    ksd11   LIKE ksd_file.ksd11,
                    ksd14   LIKE ksd_file.ksd14,
                    ksd15   LIKE ksd_file.ksd15,
                    ksd04   LIKE ksd_file.ksd04,
                    ima02   LIKE ima_file.ima02,
                    ima021  LIKE ima_file.ima021,
                    ksd08   LIKE ksd_file.ksd08,
                    ksd09   LIKE ksd_file.ksd09,
                    ksd13   LIKE ksd_file.ksd13,
                    ksd12   LIKE ksd_file.ksd12,
                    ksd05   LIKE ksd_file.ksd05,
                    ksd06   LIKE ksd_file.ksd06,
#No.FUN-560069 --start--
                    ksd07   LIKE ksd_file.ksd07,
                    ksd30   LIKE ksd_file.ksd30,
                    ksd31   LIKE ksd_file.ksd31,
                    ksd32   LIKE ksd_file.ksd32,
                    ksd33   LIKE ksd_file.ksd33,
                    ksd34   LIKE ksd_file.ksd34,
                    ksd35   LIKE ksd_file.ksd35
#No.FUN-560069 ---end--
                    END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580005        #No.FUN-680121 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580005
     DEFINE l_str2             LIKE type_file.chr1000   #No.FUN-840049
     DEFINE l_gem02            LIKE gem_file.gem02      #No.FUN-840049
     DEFINE l_ima906           LIKE ima_file.ima906     #No.FUN-840049
     DEFINE l_ksd35            STRING                   #No.FUN-840049                                                                                   
     DEFINE l_ksd32            STRING                   #No.FUN-840049
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-840049 *** ##                                                      
     CALL cl_del_data(l_table)                                                                                                        
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           #FUN-840049                                   
     #------------------------------ CR (2) ------------------------------#
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND kscuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND kscgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND kscgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('kscuser', 'kscgrup')
     #End:FUN-980030

     LET tm.wc=cl_replace_str(tm.wc, 'ksc03', 'ksd17') #TQC-C20238
 
     LET l_sql = "SELECT '','','',",
                #"ksc00,ksc03,ksc01,ksc02,ksc04,ksd03,ksd11,ksd14,ksd15,",         #TQC-C20217
                 "ksc00,ksd17,ksc01,ksc02,ksc04,ksd03,ksd11,ksd14,ksd15,",         #TQC-C20217
                 "ksd04,ima02,ima021,ksd08,ksd09,ksd13,ksd12,ksd05,ksd06,ksd07,",  #No.FUN-560069
                 "ksd30,ksd31,ksd32,ksd33,ksd34,ksd35 ", #No.FUN-560069
                 " FROM ksc_file, ksd_file, ",
                 "  OUTER ima_file ",
                 " WHERE ksc01 = ksd01 ",
                 "   AND  ksd_file.ksd04 = ima_file.ima01  AND kscconf!='X' ", #FUN-660134
                 "   AND ",tm.wc clipped
     IF NOT cl_null(g_ksc00) THEN
        LET l_sql=l_sql, " AND ksc00='",g_ksc00,"'"
     END IF
 
     PREPARE r628_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r628_curs1 CURSOR FOR r628_prepare1
 
#    CALL cl_outnam('asfr628') RETURNING l_name                             #No.FUN-840049 Mark
     #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
     IF g_sma115 = "Y" THEN
#       LET g_zaa[48].zaa06 = "N"
        LET l_name = 'asfr628_1'
     ELSE
#       LET g_zaa[48].zaa06 = "Y"
        LET l_name = 'asfr628' 
     END IF
#    CALL cl_prt_pos_len()                                                   #No.FUN-840049 Mark
     #No.FUN-580005 --end--
 
#    START REPORT r628_rep TO l_name                                         #No.FUN-840049 Mark
     LET g_pageno = 0
     FOREACH r628_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#No.FUN-840049 Mark--Begin--
#         FOR g_i = 1 TO 3
#             CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ksc01
#                                           LET g_ordera[g_i]= g_x[12]
#                  WHEN tm.s[g_i,g_i] = '2'
#                       LET l_order[g_i] = sr.ksc02 USING 'YYYYMMDD'
#                       LET g_ordera[g_i]= g_x[13]
#                  WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ksc03
#                                           LET g_ordera[g_i]= g_x[14]
#                  WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ksd11
#                                           LET g_ordera[g_i]= g_x[15]
#                  WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ksc04
#                                           LET g_ordera[g_i]= g_x[16]
#                  WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ksd04
#                                           LET g_ordera[g_i]= g_x[17]
#                  OTHERWISE LET l_order[g_i]  = '-'
#                            LET g_ordera[g_i] = ' '          #清為空白
#             END CASE
#         END FOR
#         LET sr.order1 = l_order[1]
#         LET sr.order2 = l_order[2]
#         LET sr.order3 = l_order[3]
 
#          OUTPUT TO REPORT r628_rep(sr.*)
#No.FUN-840049 Mark--End--
 
#No.FUN-840049 Add--End--
      IF g_sma115 = "Y" THEN                                                                                                        
         SELECT ima906 INTO l_ima906 FROM ima_file                                                                                  
          WHERE ima01 = sr.ksd04                                                                                                    
         LET l_str2 = " "                                                                                                           
         IF NOT cl_null(sr.ksd35) AND sr.ksd35 <> 0 THEN                                                                            
            CALL cl_remove_zero(sr.ksd35) RETURNING l_ksd35                                                                         
            LET l_str2 = l_ksd35, sr.ksd33 CLIPPED                                                                                  
         END IF                                                                                                                     
         IF l_ima906 = "2" THEN                                                                                                     
            IF cl_null(sr.ksd35) OR sr.ksd35 = 0 THEN                                                                               
               CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32                                                                      
               LET l_str2 = l_ksd32, sr.ksd30 CLIPPED                                                                               
            ELSE                                                                                                                    
               IF NOT cl_null(sr.ksd32) AND sr.ksd32 <> 0 THEN                                                                      
                  CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32                                                                   
                  LET l_str2 = l_str2 CLIPPED,',',l_ksd32, sr.ksd30 CLIPPED                                                         
               END IF                                                                                                               
            END IF                                                                                                                  
         END IF                                                                                                                     
      END IF                                                                                                                        
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.ksc04
#No.FUN-840049 Add--End--
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-840049 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                #sr.ksc00,sr.ksc03,sr.ksc01,sr.ksc02,sr.ksc04,sr.ksd03,sr.ksd11,sr.ksd14, #TQC-C20217
                 sr.ksc00,sr.ksd17,sr.ksc01,sr.ksc02,sr.ksc04,sr.ksd03,sr.ksd11,sr.ksd14, #TQC-C20217
                 sr.ksd15,sr.ksd04,sr.ima02,sr.ima021,sr.ksd08,sr.ksd09,sr.ksd13,sr.ksd12,
                 sr.ksd05,sr.ksd06,sr.ksd07,l_gem02,l_str2
     #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
#No.FUN-840049--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
        #CALL cl_wcchp(tm.wc,'ksc01,ksc02,ksc03,ksd11,ksc04,ksd04')             #TQC-C20217 
         CALL cl_wcchp(tm.wc,'ksc01,ksc02,ksd17,ksd11,ksc04,ksd04')             #TQC-C20217 
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-840049--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-840049 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]                                                                                                               
    CALL cl_prt_cs3('asfr628',l_name,g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
#    FINISH REPORT r628_rep                                                           #No.FUN-840049 Mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                      #No.FUN-840049 Mark
END FUNCTION
 
#NO.FUN-840049 -Mark--Begin--#
#REPORT r628_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,               #No.FUN-680121 VARCHAR(1)
#         sr        RECORD
#                   order1  LIKE ksd_file.ksd04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                   order2  LIKE ksd_file.ksd04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                   order3  LIKE ksd_file.ksd04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                   ksc00   LIKE ksc_file.ksc00,
#                   ksc03   LIKE ksc_file.ksc03,
#                   ksc01   LIKE ksc_file.ksc01,
#                   ksc02   LIKE ksc_file.ksc02,
#                   ksc04   LIKE ksc_file.ksc04,
#                   ksd03   LIKE ksd_file.ksd03,
#                   ksd11   LIKE ksd_file.ksd11,
#                   ksd14   LIKE ksd_file.ksd14,
#                   ksd15   LIKE ksd_file.ksd15,
#                   ksd04   LIKE ksd_file.ksd04,
#                   ima02   LIKE ima_file.ima02,
#                   ima021  LIKE ima_file.ima021,
#                   ksd08   LIKE ksd_file.ksd08,
#                   ksd09   LIKE ksd_file.ksd09,
#                   ksd13   LIKE ksd_file.ksd13,
#                   ksd12   LIKE ksd_file.ksd12,
#                   ksd05   LIKE ksd_file.ksd05,
#                   ksd06   LIKE ksd_file.ksd06,
#No.FUN-560069 --start--
#                   ksd07   LIKE ksd_file.ksd07,
#                   ksd30   LIKE ksd_file.ksd30,
#                   ksd31   LIKE ksd_file.ksd31,
#                   ksd32   LIKE ksd_file.ksd32,
#                   ksd33   LIKE ksd_file.ksd33,
#                   ksd34   LIKE ksd_file.ksd34,
#                   ksd35   LIKE ksd_file.ksd35
#No.FUN-560069 ---end--
#                   END RECORD,
#            l_gem02       LIKE gem_file.gem02,
#            l_str         LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(40)
#            l_cnt         LIKE type_file.num5          #No.FUN-680121 SMALLINT
#  DEFINE l_str2        LIKE type_file.chr1000,         #No.FUN-680121 VARCHAR(100)#No.FUN-580005
#         l_ksd35       STRING,    #No.FUN-580005
#         l_ksd32       STRING     #No.FUN-580005
#  DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
# ORDER BY sr.order1,sr.order2,sr.order3
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     IF sr.ksc00='0' THEN LET l_str=g_x[09] END IF
#     IF sr.ksc00='1' THEN LET l_str=g_x[10] END IF
#     IF sr.ksc00='2' THEN LET l_str=g_x[11] END IF
#     LET g_x[1] = l_str CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]          #No.TQC-6A0102
#     PRINT ''                                                      #No.TQC-760202
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]           #No.TQC-760202 
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#    #PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]          #No.TQC-6A0102   #No.TQC-760202 mark
#    #PRINT ''                                                     #No.TQC-760202 mark
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38],
#           g_x[39],
#           g_x[40],
#           g_x[41],
#           g_x[42],
#           g_x[43],
#           g_x[44],
#           g_x[48],
#           g_x[45],
#           g_x[46],
#           g_x[47]
#     PRINT g_dash1
#
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#No.FUN-580005 ---start--
#     IF g_sma115 = "Y" THEN
#        SELECT ima906 INTO l_ima906 FROM ima_file
#         WHERE ima01 = sr.ksd04
#        LET l_str2 = " "
#        IF NOT cl_null(sr.ksd35) AND sr.ksd35 <> 0 THEN
#           CALL cl_remove_zero(sr.ksd35) RETURNING l_ksd35
#           LET l_str2 = l_ksd35, sr.ksd33 CLIPPED
#        END IF
#        IF l_ima906 = "2" THEN
#           IF cl_null(sr.ksd35) OR sr.ksd35 = 0 THEN
#              CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32
#              LET l_str2 = l_ksd32, sr.ksd30 CLIPPED
#           ELSE
#              IF NOT cl_null(sr.ksd32) AND sr.ksd32 <> 0 THEN
#                 CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32
#                 LET l_str2 = l_str2 CLIPPED,',',l_ksd32, sr.ksd30 CLIPPED
#              END IF
#           END IF
#        END IF
#     END IF
#No.FUN-580005 ---end--
#     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.ksc04
#     LET l_str = sr.ksd05 CLIPPED,'/',sr.ksd06 CLIPPED,'/',sr.ksd07 CLIPPED
#
#     PRINT COLUMN g_c[31],sr.ksc03,
#           COLUMN g_c[32],sr.ksc01,
#           COLUMN g_c[33],sr.ksc02,
#           COLUMN g_c[34],sr.ksc04,
#           COLUMN g_c[35],l_gem02,
#           COLUMN g_c[36],sr.ksd03 USING '###&',
#           COLUMN g_c[37],sr.ksd11,
#           COLUMN g_c[38],sr.ksd14 USING '#######&',
#           COLUMN g_c[39],sr.ksd15 USING '###########&',
#           COLUMN g_c[40],sr.ksd04,
#           COLUMN g_c[41],sr.ima02,
#           COLUMN g_c[42],sr.ima021,
#           COLUMN g_c[43],sr.ksd08,
#           COLUMN g_c[44],cl_numfor(sr.ksd09,44,3),
#           COLUMN g_c[48],l_str2 CLIPPED,
#           COLUMN g_c[45],sr.ksd13 USING '--------------&',
#           COLUMN g_c[46],sr.ksd12,
#           COLUMN g_c[47],l_str CLIPPED
 
#  AFTER GROUP OF sr.order1
#     IF tm.u[1,1] = 'Y' THEN
#        LET l_str = g_ordera[1] CLIPPED,g_x[20] CLIPPED
#        PRINT COLUMN g_c[42],l_str CLIPPED,
#              COLUMN g_c[44],GROUP SUM(sr.ksd09) USING '--------------&',
#              COLUMN g_c[45],GROUP SUM(sr.ksd13) USING '--------------&'
#        PRINT ''
#     END IF
#
#  AFTER GROUP OF sr.order2
#     IF tm.u[2,2] = 'Y' THEN
#        LET l_str = g_ordera[2] CLIPPED,g_x[19] CLIPPED
#        PRINT COLUMN g_c[42],l_str CLIPPED,
#              COLUMN g_c[44],GROUP SUM(sr.ksd09) USING '--------------&',
#              COLUMN g_c[45],GROUP SUM(sr.ksd13) USING '--------------&'
#        PRINT ''
#     END IF
#
#  AFTER GROUP OF sr.order3
#     IF tm.u[3,3] = 'Y' THEN
#        LET l_str = g_ordera[3] CLIPPED,g_x[18] CLIPPED
#        PRINT COLUMN g_c[42],l_str CLIPPED,
#              COLUMN g_c[44],GROUP SUM(sr.ksd09) USING '--------------&',
#              COLUMN g_c[45],GROUP SUM(sr.ksd13) USING '--------------&'
#        PRINT ''
#     END IF
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#TQC-630166-start
#        CALL cl_wcchp(tm.wc,'ksc01,ksc02,ksc03,ksd11,ksc04,ksd04')  
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        CALL cl_prt_pos_wc(tm.wc)
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#TQC-630166-end
#     END IF
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.FUN-580005
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.FUN-580005
#        ELSE SKIP 2 LINE
#     END IF
 
#END REPORT
#NO.FUN-840049 -Mark--End--#
#No.FUN-870144

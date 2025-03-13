# Prog. Version..: '5.30.07-13.05.16(00002)'     #
#
# Pattern name...: asfx623.4gl
# Descriptions...: 工單完工/入庫/入庫退回明細表列印
# Date & Author..: 97/07/24  By  Sophia
# Modify.........: No.FUN-4B0022 04/11/05 By Yuna 新增入庫單號,工單編號開窗
# Modify.........: No.MOD-4B0092 抓相關zz資料時應改用 g_prog
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-530635 05/03/31 By pengu 將原本cl_outnam()所傳參數g_prog，改成asfx623
# Modify.........: No.FUN-550012 05/05/20 By Carol sfu03 -> sfv17
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-580005 05/08/05 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660137 06/06/21 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-6B0002 06/11/15 By johnray 報表修改
# Modify.........: No.TQC-750041 07/05/15 By mike  報表格式修改
# Modify.........: No.MOD-7B0053 07/11/07 By Pengu select zz08時改用g_prog作為KEY值
# Modify.........: NO.FUN-850139 08/06/02 By zhaijie老報表修改為CR
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-CB0004 12/12/20 By dongsz CR轉XtraGrid
# Modify.........: No:FUN-D30070 13/03/21 By wangrr XtraGrid報表畫面檔上小計條件去除，4gl中并去除grup_sum_field
# Modify.........: No.TQC-D40018 13/04/08 By zhangweib 補過到正式區
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5   #No.FUN-680121 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
   #DEFINE g_dash1       VARCHAR(300)         #No.TQC-D40018
   DEFINE tm  RECORD                   # Print condition RECORD
#             wc      VARCHAR(800),       # Where condition  #TQC-630166
              wc      STRING,          # Where condition  #TQC-630166
              s       LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(03)
              t       LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(03)
             # Prog. Version..: '5.30.07-13.05.16(03) #FUN-D30070 mark
              more    LIKE type_file.chr1             # Prog. Version..: '5.30.07-13.05.16(01)# Input more condition(Y/N)
              END RECORD,
          g_ordera   ARRAY[6] OF LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#FUN-5B0105 10->40
          g_sfu00 LIKE sfu_file.sfu00,
          g_program      LIKE type_file.chr10                  #No.FUN-680121 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-580005 --start--
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580005 --end--
#NO.FUN-850139--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-850139--END---
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   LET g_program = ARG_VAL(1)
   LET g_sfu00 = ARG_VAL(2)
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
  #LET tm.u  = ARG_VAL(12)      #FUN-D30070 mark
   LET g_rep_user = ARG_VAL(12) #FUN-D30070 mod 13->12
   LET g_rep_clas = ARG_VAL(13) #FUN-D30070 mod 14->13
   LET g_template = ARG_VAL(14) #FUN-D30070 mod 15->14
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(11)
   #LET g_rep_clas = ARG_VAL(12)
   #LET g_template = ARG_VAL(13)
   ##No.FUN-570264 ---end---
   #LET tm.t  = ARG_VAL(10)
   #LET tm.u  = ARG_VAL(10)
   #TQC-610080-end
 
   LET g_prog=g_program
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
#NO.FUN-850139--START---
   LET g_sql = "sfu00.sfu_file.sfu00,",
               "sfv17.sfv_file.sfv17,",
               "sfu01.sfu_file.sfu01,",
               "sfu02.sfu_file.sfu02,",
               "sfu04.sfu_file.sfu04,",
               "sfv03.sfv_file.sfv03,",
               "sfv11.sfv_file.sfv11,",
               "sfv14.sfv_file.sfv14,",
               "sfv15.sfv_file.sfv15,",
               "sfv04.sfv_file.sfv04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "sfv08.sfv_file.sfv08,",
               "sfv09.sfv_file.sfv09,",
               "sfv33.sfv_file.sfv33,",
               "sfv35.sfv_file.sfv35,",
               "sfv30.sfv_file.sfv30,",
               "sfv32.sfv_file.sfv32,",
               "sfv13.sfv_file.sfv13,",
               "sfv12.sfv_file.sfv12,",
               "sfv05.sfv_file.sfv05,",
               "imd02.imd_file.imd02,",         #FUN-CB0004 add
               "sfv06.sfv_file.sfv06,",
               "ime03.ime_file.ime03,",         #FUN-CB0004 add
               "sfv07.sfv_file.sfv07,",
               "l_gem02.gem_file.gem02,",
               "l_str.type_file.chr1000,",
               "l_str2.type_file.chr1000,",
               "l_sfv13.sfv_file.sfv13,",       #FUN-CB0004 add
               "num1.type_file.num5"            #FUN-CB0004 add
   LET l_table = cl_prt_temptable('asfx623',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"             #FUN-CB0004 add 5?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF            
#NO.FUN-850139--end----
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL x623_tm(0,0)        # Input print condition
      ELSE CALL x623()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION x623_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW x623_w AT p_row,p_col WITH FORM "asf/42f/asfx623"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   # 2004/06/02 共用程式時呼叫
   CALL cl_set_locale_frm_name("asfx623")
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET g_sfu00 = '1'                  #TQC-610080    #No.MOD-7B0053 modify
   LET g_sfu00 = '1'                  #FUN-850139填資料用
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
  #LET tm2.u1   = tm.u[1,1] #FUN-D30070 mark
  #LET tm2.u2   = tm.u[2,2] #FUN-D30070 mark
  #LET tm2.u3   = tm.u[3,3] #FUN-D30070 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF #FUN-D30070 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF #FUN-D30070 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF #FUN-D30070 mark
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfu01,sfu02,sfv17,sfv11,sfu04,sfv04   #No.FUN-550012
     #--No.FUN-4B0022-------
     ON ACTION CONTROLP
       CASE WHEN INFIELD(sfu01)      #入庫單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_sfu"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfu01
                 NEXT FIELD sfu01
            WHEN INFIELD(sfv11)      #工單編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_sfv"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfv11
                 NEXT FIELD sfv11
#No.FUN-570240 --start--
            WHEN INFIELD(sfv04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfv04
                 NEXT FIELD sfv04
#No.FUN-570240 --end--
           #FUN-CB0004--add--str---
            WHEN INFIELD(sfv17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfv17"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfv17
                 NEXT FIELD sfv17

            WHEN INFIELD(sfu04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem3"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfu04
                 NEXT FIELD sfu04
           #FUN-CB0004--add--end---
       OTHERWISE EXIT CASE
       END CASE
     #--END---------------
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW x623_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                  #tm2.u1,tm2.u2,tm2.u3, #FUN-D30070 mark
                   tm.more  WITHOUT DEFAULTS
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
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3 #FUN-D30070 mark
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
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
      #WHERE zz01='asfx623' #MOD-4B0092     #No.MOD-7B0053 mark
         WHERE zz01=g_prog    #MOD-4B0092   #No.MOD-7B0053 add
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfx623','9031',1)
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
                         " '",tm.t CLIPPED,"'",
                        #" '",tm.u CLIPPED,"'", #FUN-D30070 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfx623',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW x623_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x623()
   ERROR ""
END WHILE
   CLOSE WINDOW x623_w
END FUNCTION
 
FUNCTION x623()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)#External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,          # RDSQL STATEMENT   #TQC-630166
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_prog    LIKE type_file.chr20,          #No.FUN-680121 VARCHAR(20)
          l_order   ARRAY[6] OF LIKE sfv_file.sfv04,      #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          sr        RECORD
                    order1  LIKE sfv_file.sfv04,          #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order2  LIKE sfv_file.sfv04,          #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order3  LIKE sfv_file.sfv04,          #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    sfu00   LIKE sfu_file.sfu00,
                    sfv17   LIKE sfv_file.sfv17,        #No.FUN-550012
                    sfu01   LIKE sfu_file.sfu01,
                    sfu02   LIKE sfu_file.sfu02,
                    sfu04   LIKE sfu_file.sfu04,
                    sfv03   LIKE sfv_file.sfv03,
                    sfv11   LIKE sfv_file.sfv11,
                    sfv14   LIKE sfv_file.sfv14,
                    sfv15   LIKE sfv_file.sfv15,
                    sfv04   LIKE sfv_file.sfv04,
                    ima02   LIKE ima_file.ima02,
                    ima021  LIKE ima_file.ima021,
                    sfv08   LIKE sfv_file.sfv08,
                    sfv09   LIKE sfv_file.sfv09,
                    #No.FUN-580005 --start--
                    sfv33 LIKE sfv_file.sfv33,
                    sfv35 LIKE sfv_file.sfv35,
                    sfv30 LIKE sfv_file.sfv30,
                    sfv32 LIKE sfv_file.sfv32,
                    #No.FUN-580005 --end--
                    sfv13   LIKE sfv_file.sfv13,
                    sfv12   LIKE sfv_file.sfv12,
                    sfv05   LIKE sfv_file.sfv05,
                    imd02   LIKE imd_file.imd02,        #FUN-CB0004 add
                    sfv06   LIKE sfv_file.sfv06,
                    ime03   LIKE ime_file.ime03,        #FUN-CB0004 add
                    sfv07   LIKE sfv_file.sfv07
                    END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580005        #No.FUN-680121 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580005
#NO.FUN-850139----start---
   DEFINE l_str         LIKE type_file.chr1000
   DEFINE l_str2        LIKE type_file.chr1000
   DEFINE l_sfv35       STRING
   DEFINE l_sfv32       STRING
   DEFINE l_ima906      LIKE ima_file.ima906
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_sfv13       LIKE sfv_file.sfv13             #FUN-CB0004 add
   DEFINE l_str3        STRING                          #FUN-CB0004 add
   DEFINE l_num1        LIKE type_file.num5             #FUN-CB0004 add
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asfx623'
#NO.FUN-850139----end----   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfuuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfugrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfugrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')
     #End:FUN-980030
 
    LET l_sql = "SELECT '','','',",
                "sfu00,sfv17,sfu01,sfu02,sfu04,sfv03,sfv11,sfv14,sfv15,",
                "sfv04,ima02,ima021,sfv08,sfv09, ",
                "sfv33,sfv35,sfv30,sfv32, ",     #No.FUN-580005
                "sfv13,sfv12,sfv05,imd02,sfv06,ime03,sfv07",              #FUN-CB0004 add imd02,ime03
                " FROM sfu_file, sfv_file, ",
                "  OUTER ima_file,OUTER imd_file,OUTER ime_file ",        #FUN-CB0004 add OUTER imd_file,OUTER ime_file
               #" ima_file,imd_file,ime_file ",                           #FUN-CB0004 add
               #" WHERE sfu01 = sfv01 AND sfv04=ima01 AND sfupost!='X' ", #FUN-660137
                " WHERE sfu01 = sfv01 AND  sfv_file.sfv04=ima_file.ima01  AND sfuconf!='X' ", #FUN-660137
                " AND sfv_file.sfv05 = imd_file.imd01 AND sfv_file.sfv05 = ime_file.ime01 AND sfv_file.sfv06 = ime_file.ime02 ",  #FUN-CB0004 add
               #" AND ",tm.wc clipped         #No.FUN-550012       #No.MOD-7B0053 mark                 
                "   AND sfu00='",g_sfu00,"' AND ",tm.wc clipped    #No.FUN-550012   #No.MOD-7B0053 add
 
     PREPARE x623_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE x623_curs1 CURSOR FOR x623_prepare1
      #-----No.MOD-530635-------------------------------------
      #----FUN-550012
       LET g_rlang = g_lang                               #FUN-4C0096 add
       LET l_prog  = g_prog
       LET g_prog = 'asfx623'
      #----FUN-550012
#        CALL cl_outnam('asfx623') RETURNING l_name #MOD-4B0092  #NO.FUN-850139
      # CALL cl_outnam(g_prog) RETURNING l_name    #MOD-4B0092
      #-------------No.MOD-530635----------------------------
     #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
     #NO.FUN-850139---mark--start--
     #IF g_sma115 = "Y" THEN
     #   LET g_zaa[46].zaa06 = "N" 
     #ELSE
     #   LET g_zaa[46].zaa06 = "Y"
     #END IF
     #NO.FUN-850139--end--mark--
     CALL cl_prt_pos_len()
     #No.FUN-580005 --end--
 
#     START REPORT x623_rep TO l_name                       #NO.FUN-850139
#     LET g_pageno = 0                                      #NO.FUN-850139
     FOREACH x623_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#NO.FUN-850139----START--MARK---
#          FOR g_i = 1 TO 3
#              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.sfu01
#                                            LET g_ordera[g_i]= g_x[12]
#                   WHEN tm.s[g_i,g_i] = '2'
#                        LET l_order[g_i] = sr.sfu02 USING 'YYYYMMDD'
#                        LET g_ordera[g_i]= g_x[13]
#                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.sfv17
#                                            LET g_ordera[g_i]= g_x[14]
#                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.sfv11
#                                            LET g_ordera[g_i]= g_x[15]
#                   WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.sfu04
#                                            LET g_ordera[g_i]= g_x[16]
#                   WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.sfv04
#                                            LET g_ordera[g_i]= g_x[17]
#                   OTHERWISE LET l_order[g_i]  = '-'
#                             LET g_ordera[g_i] = ' '          #清為空白
#              END CASE
#          END FOR
#          LET sr.order1 = l_order[1]
#          LET sr.order2 = l_order[2]
#          LET sr.order3 = l_order[3]
#
#          OUTPUT TO REPORT x623_rep(sr.*)
#NO.FUN-850139---END---MARK--
#NO.FUN-850139---START---
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.sfu04
      IF cl_null(sr.sfv06) THEN
         LET sr.sfv06 = '  '
      END IF
      IF cl_null(sr.sfv07) THEN
         LET sr.sfv07 = '  '
      END IF
      LET l_str = sr.sfv05,'/',sr.sfv06,'/',sr.sfv07 CLIPPED
      IF g_sma115 = "Y" THEN
         SELECT ima906 INTO l_ima906 FROM ima_file
          WHERE ima01 = sr.sfv04
         LET l_str2 = " "
         IF NOT cl_null(sr.sfv35) AND sr.sfv35 <> 0 THEN
            CALL cl_remove_zero(sr.sfv35) RETURNING l_sfv35
            LET l_str2 = l_sfv35, sr.sfv33 CLIPPED
         END IF
         IF l_ima906 = "2" THEN
            IF cl_null(sr.sfv35) OR sr.sfv35 = 0 THEN
               CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
               LET l_str2 = l_sfv32, sr.sfv30 CLIPPED
            ELSE
               IF NOT cl_null(sr.sfv32) AND sr.sfv32 <> 0 THEN
                  CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
                  LET l_str2 = l_str2 CLIPPED,',',l_sfv32, sr.sfv30 CLIPPED
               END IF
            END IF
         END IF
      END IF
     #FUN-CB0004--add--str---
      IF cl_null(sr.sfv13) THEN
         LET l_sfv13 = 0 
      ELSE
         LET l_sfv13 = sr.sfv13
      END IF
      LET l_num1 = 3 
     #FUN-CB0004--add--end---
      EXECUTE insert_prep USING
        sr.sfu00,sr.sfv17,sr.sfu01,sr.sfu02,sr.sfu04,sr.sfv03,sr.sfv11,
        sr.sfv14,sr.sfv15,sr.sfv04,sr.ima02,sr.ima021,sr.sfv08,sr.sfv09,
        sr.sfv33,sr.sfv35,sr.sfv30,sr.sfv32,sr.sfv13,sr.sfv12,sr.sfv05,sr.imd02,    #FUN-CB0004 add sr.imd02
        sr.sfv06,sr.ime03,sr.sfv07,l_gem02,l_str,l_str2,l_sfv13,l_num1              #FUN-CB0004 add sr.ime03,l_sfv13,l_num1
#NO.FUN-850139---END---
     END FOREACH
 
#     FINISH REPORT x623_rep                                #NO.FUN-850139
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850139
#NO.FUN-850139----start----
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_xgrid.table = l_table    ###XtraGrid###
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'sfu01,sfu02,sfv17,sfv11,sfu04,sfv04')
           RETURNING tm.wc
     END IF
###XtraGrid###     LET g_str = tm.wc,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
###XtraGrid###                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",tm.s[1,1],";",
###XtraGrid###                 tm.s[2,2],";",tm.s[3,3],";",g_sma115
###XtraGrid###     CALL cl_prt_cs3('asfx623','asfx623',g_sql,g_str) 
   #FUN-CB0004--add--str---
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"sfu01,sfu02,sfv17,sfv11,sfu04,sfv04")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"sfu01,sfu02,sfv17,sfv11,sfu04,sfv04")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"sfu01,sfu02,sfv17,sfv11,sfu04,sfv04") #FUN-D30070 mark
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"sfu01,sfu02,sfv17,sfv11,sfu04,sfv04")
   #LET l_str3 = cl_wcchp(g_xgrid.order_field,"sfu01,sfu02,sfv17,sfv11,sfu04,sfv04") #FUN-D30070 mark
   #LET l_str3 = cl_replace_str(l_str3,',','-') #FUN-D30070 mark
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str3 #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
#NO.FUN-850139--end---
     LET g_prog = l_prog   #FUN-550012
END FUNCTION
#NO.FUN-850139---START---MARK----
#REPORT x623_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,               #No.FUN-680121 VARCHAR(1)
#          l_gem02      LIKE gem_file.gem02,
#          sr        RECORD
#                    order1  LIKE sfv_file.sfv04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    order2  LIKE sfv_file.sfv04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    order3  LIKE sfv_file.sfv04,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    sfu00   LIKE sfu_file.sfu00,
#                    sfv17   LIKE sfv_file.sfv17,    #No.FUN-550012
#                    sfu01   LIKE sfu_file.sfu01,
#                    sfu02   LIKE sfu_file.sfu02,
#                    sfu04   LIKE sfu_file.sfu04,
#                    sfv03   LIKE sfv_file.sfv03,
#                    sfv11   LIKE sfv_file.sfv11,
#                    sfv14   LIKE sfv_file.sfv14,
#                    sfv15   LIKE sfv_file.sfv15,
#                    sfv04   LIKE sfv_file.sfv04,
#                    ima02   LIKE ima_file.ima02,
#                    ima021  LIKE ima_file.ima021,
#                    sfv08   LIKE sfv_file.sfv08,
#                    sfv09   LIKE sfv_file.sfv09,
#                    #No.FUN-580005 --start--
#                    sfv33 LIKE sfv_file.sfv33,
#                    sfv35 LIKE sfv_file.sfv35,
#                    sfv30 LIKE sfv_file.sfv30,
#                    sfv32 LIKE sfv_file.sfv32,
#                    #No.FUN-580005 --end--
#                    sfv13   LIKE sfv_file.sfv13,
#                    sfv12   LIKE sfv_file.sfv12,
#                    sfv05   LIKE sfv_file.sfv05,
#                    sfv06   LIKE sfv_file.sfv06,
#                    sfv07   LIKE sfv_file.sfv07
#                    END RECORD,
#             l_str         LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(80)
#             l_cnt         LIKE type_file.num5          #No.FUN-680121 SMALLINT
#   DEFINE l_str2        LIKE type_file.chr1000,         #No.FUN-680121 VARCHAR(100)#No.FUN-580005
#          l_sfv35       STRING,    #No.FUN-580005
#          l_sfv32       STRING     #No.FUN-580005
#   DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.order1,sr.order2,sr.order3
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET l_str = g_x[1] CLIPPED              #No.TQC-6B0002
#      IF sr.sfu00='0' THEN LET l_str=g_x[09] END IF
#      IF sr.sfu00='1' THEN LET l_str=g_x[10] END IF
#      IF sr.sfu00='2' THEN LET l_str=g_x[11] END IF
#      LET g_x[1] = l_str CLIPPED
##      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6B0002
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6B0002
#      PRINT ''
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39],
#            g_x[40],
#            g_x[41],
#            g_x[42],
#            g_x[46],
#            g_x[43],
#            g_x[44],
#            g_x[45]
#      PRINT g_dash1
# 
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.sfu04
#      IF cl_null(sr.sfv06) THEN
#         LET sr.sfv06 = '  '
#      END IF
#      IF cl_null(sr.sfv07) THEN
#         LET sr.sfv07 = '  '
#      END IF
#      LET l_str = sr.sfv05,'/',sr.sfv06,'/',sr.sfv07 CLIPPED
##No.FUN-580005 ---start--
#      IF g_sma115 = "Y" THEN
#         SELECT ima906 INTO l_ima906 FROM ima_file
#          WHERE ima01 = sr.sfv04
#         LET l_str2 = " "
#         IF NOT cl_null(sr.sfv35) AND sr.sfv35 <> 0 THEN
#            CALL cl_remove_zero(sr.sfv35) RETURNING l_sfv35
#            LET l_str2 = l_sfv35, sr.sfv33 CLIPPED
#         END IF
#         IF l_ima906 = "2" THEN
#            IF cl_null(sr.sfv35) OR sr.sfv35 = 0 THEN
#               CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
#               LET l_str2 = l_sfv32, sr.sfv30 CLIPPED
#            ELSE
#               IF NOT cl_null(sr.sfv32) AND sr.sfv32 <> 0 THEN
#                  CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
#                  LET l_str2 = l_str2 CLIPPED,',',l_sfv32, sr.sfv30 CLIPPED
#               END IF
#            END IF
#         END IF
#      END IF
##No.FUN-580005 ---end--
#      PRINT COLUMN g_c[31],sr.sfv17,   #No.FUN-550012
#            COLUMN g_c[32],sr.sfu01,
#            COLUMN g_c[33],sr.sfu02,
#            COLUMN g_c[34],sr.sfu04,
#            COLUMN g_c[35],l_gem02,
#            COLUMN g_c[36],sr.sfv03 USING '###&',
#            COLUMN g_c[37],sr.sfv11,
#            COLUMN g_c[38],sr.sfv04,
#            COLUMN g_c[39],sr.ima02,
#            COLUMN g_c[40],sr.ima021,
#            COLUMN g_c[41],sr.sfv08,
#            COLUMN g_c[42],cl_numfor(sr.sfv09,42,3),
#            COLUMN g_c[46],l_str2 CLIPPED,    #No.FUN-580005
#            COLUMN g_c[43],sr.sfv13 USING '#########&',
#            COLUMN g_c[44],sr.sfv12,
#            COLUMN g_c[45],l_str CLIPPED
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_str = g_ordera[1] CLIPPED,g_x[20] CLIPPED
#         PRINT COLUMN g_c[40],l_str CLIPPED,
#               COLUMN g_c[42],GROUP SUM(sr.sfv09) USING '--------------&',
#               COLUMN g_c[43],GROUP SUM(sr.sfv13) USING '--------------&'
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_str = g_ordera[2] CLIPPED,g_x[19] CLIPPED
#         PRINT COLUMN g_c[40],l_str CLIPPED,
#               COLUMN g_c[42],GROUP SUM(sr.sfv09) USING '--------------&',
#               COLUMN g_c[43],GROUP SUM(sr.sfv13) USING '--------------&'
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         LET l_str = g_ordera[3] CLIPPED,g_x[18] CLIPPED
#         PRINT COLUMN g_c[40],l_str CLIPPED,
#               COLUMN g_c[42],GROUP SUM(sr.sfv09) USING '--------------&',
#               COLUMN g_c[43],GROUP SUM(sr.sfv13) USING '--------------&'
#         PRINT ''
#      END IF
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
##TQC-630166-start
#         CALL cl_wcchp(tm.wc,'fu01,sfu02,sfv17,sfv11,sfu04,sfv04')  
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         CALL cl_prt_pos_wc(tm.wc)
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
##TQC-630166-end
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.FUN-580005   #No.TQC-750041
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.FUN-580005  #No.TQC-750041
#         ELSE SKIP 2 LINE
#      END IF
#
#END REPORT
##NO.FUN-850139---END--MARK--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

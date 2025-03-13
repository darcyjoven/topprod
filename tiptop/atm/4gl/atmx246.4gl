# Prog. Version..: '5.30.07-13.05.30(00007)'     #
#
# Pattern name...: atmx246.4gl
# Descriptions...: 提案明細表打印
# Date & Author..: 06/03/30 by Ray
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: NO.FUN-860008 08/06/19 By zhaijie老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0003 12/11/06 By chenjing CR轉XtraGrid
# Modify.........: No.FUN-D40020 13/02/01 By chenying 添加門店項次排序
# Modify.........: No:FUN-D30070 13/03/21 By wangrr XtraGrid報表畫面檔上小計條件去除，4gl中并去除grup_sum_field
# Modify.........: No:FUN-D40128 13/05/16 By wangrr 報表中增加"狀態碼"
# Modify.........: No:FUN-D40129 13/05/28 By yangtt sql里增加排序  
# Modify.........: No:FUN-D50099 13/05/30 By chenying 門店項次重複不顯示調整  
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
DEFINE tm         RECORD
                     wc      LIKE type_file.chr1000, #No.FUN-680120 VARCHAR(1000) # QBE 條件
                     s       LIKE type_file.chr4,      #No.FUN-680120 VARCHAR(03)   # 排列 (INPUT 條件)
                     t       LIKE type_file.chr4,      #No.FUN-680120 VARCHAR(03)   # 跳頁 (INPUT 條件)
                    #u       LIKE type_file.chr4,      #No.FUN-680120 VARCHAR(03)   # 合計 (INPUT 條件) #FUN-D30070 mark
                     a       LIKE type_file.chr1,    #No.FUN-680120 VARCHAR(01)
                     more    LIKE type_file.chr1     #No.FUN-680120 VARCHAR(01)   # 輸入其它特殊列印條件
                  END RECORD                         
DEFINE g_orderA   ARRAY[3] OF LIKE zaa_file.zaa08    #No.FUN-680120 VARCHAR(10)# TQC-6A0079# 篩選排序條件用變數
DEFINE g_i        LIKE type_file.num5                  #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_head1    STRING                               
DEFINE l_sql      LIKE type_file.chr1000          #No.FUN-680120 VARCHAR(1000)
DEFINE i          LIKE type_file.num10            #No.FUN-680120 INTEGER
#NO.FUN-860008---start---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-860008---end---
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   #--外部程式傳遞參數或 Background Job 時接受參數 --#
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
  #LET tm.u     = ARG_VAL(10)   #FUN-D30070 mark
   LET tm.a     = ARG_VAL(10)   #FUN-D30070 mod 11->10
   LET tm.more  = ARG_VAL(11)   #FUN-D30070 mod 12->11
   LET g_rep_user = ARG_VAL(12) #FUN-D30070 mod 13->12
   LET g_rep_clas = ARG_VAL(13) #FUN-D30070 mod 14->13
   LET g_template = ARG_VAL(14) #FUN-D30070 mod 15->14
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 # No.FUN-680120-BEGIN 
   CREATE TEMP TABLE curr_tmp(
     curr    LIKE ade_file.ade04,
     amt     LIKE type_file.num20_6,
     amt_t   LIKE type_file.num20_6,
     order1  LIKE ima_file.ima01,
     order2  LIKE ima_file.ima01,
     order3  LIKE ima_file.ima01);
 # No.FUN-680120-END   
#NO.FUN-860008--start--
   LET g_sql = "tqx01.tqx_file.tqx01,",
               "tqx02.tqx_file.tqx02,",
               "tqx05.tqx_file.tqx05,",
               "tqx09.tqx_file.tqx09,",
               "tsa02.tsa_file.tsa02,",
               "tqy03.tqy_file.tqy03,",
               "tqy38.tqy_file.tqy38,",
               "tqy37.tqy_file.tqy37,",
               "tsa03.tsa_file.tsa03,",
               "tqz03.tqz_file.tqz03,",
               "tqz04.tqz_file.tqz04,",
               "tqz06.tqz_file.tqz06,",
               "tqz07.tqz_file.tqz07,",
               "tqz05.tqz_file.tqz05,",
               "tqz11.tqz_file.tqz11,",
               "tqz09.tqz_file.tqz09,",
               "tqz08.tqz_file.tqz08,",
               "tqz12.tqz_file.tqz12,",
               "tqz16.tqz_file.tqz16,",
               "tqz15.tqz_file.tqz15,",
               "tqz17.tqz_file.tqz17,",
               "tqz10.tqz_file.tqz10,",
               "tqz031.tqz_file.tqz031,",
               "tsa04.tsa_file.tsa04,",
               "tsa05.tsa_file.tsa05,",
               "tsa08.tsa_file.tsa08,",
               "tqy36.tqy_file.tqy36,",
               "l_occ021.occ_file.occ02,",
               "l_tqa02.tqa_file.tqa02,",
               "l_ima021.ima_file.ima021,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05,", 
        #FUN-CB0003--add--str---
               "tqy_occ.type_file.chr100,",
               "l_tqz031.type_file.chr100,",
               "l_tqa021.type_file.chr100,",
               "l_num.type_file.num5,",
               "flag.type_file.chr1,",
               "flag1.type_file.chr1"
        #FUN-CB0003--add--end---
              ,",tqx07.type_file.chr100" #FUN-D40128
 
   LET l_table =cl_prt_temptable('atmx246',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,? ,?,?,?,?)"   #FUN-CB0003 add 6? #FUN-D40128 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                      
#NO.FUN-860008---end---
   IF NOT cl_null(tm.wc) THEN
      CALL x246()
      DROP TABLE curr_tmp
   ELSE
      CALL x246_tm(0,0)
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION x246_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW x246_w AT p_row,p_col WITH FORM "atm/42f/atmx246"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '1'
  #LET tm2.u1  = 'Y' #FUN-D30070 mark
  #LET tm2.u2  = 'N' #FUN-D30070 mark
  #LET tm2.u3  = 'N' #FUN-D30070 mark
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tqx01,tqx02,tqx03,tqx04,
                                 tqx12,tqx13,tqx07
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tqx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqx"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx01
                 NEXT FIELD tqx01
 
               WHEN INFIELD(tqx03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa5"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx03
                 NEXT FIELD tqx03
 
               WHEN INFIELD(tqx04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa6"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx04
                 NEXT FIELD tqx04
 
               WHEN INFIELD(tqx12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqb1"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx12
                 NEXT FIELD tqx12
 
               WHEN INFIELD(tqx13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa04"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx13
                 NEXT FIELD tqx13
 
            END CASE
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW x246_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,#tm2.u1,tm2.u2,tm2.u3, #FUN-D30070 mark
                    tm2.t1,tm2.t2,tm2.t3,tm.a,tm.more
            WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[123]' THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD more    #是否輸入其它特殊條件
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
           #LET tm.u = tm2.u1,tm2.u2,tm2.u3 #FUN-D30070 mark
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW x246_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='atmx246'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmx246','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
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
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('atmx246',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW x246_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL x246()
 
      ERROR ""
   END WHILE
 
   DROP TABLE curr_tmp   
 
   CLOSE WINDOW x246_w
 
END FUNCTION
 
FUNCTION x246()
DEFINE l_name    LIKE type_file.chr20             #No.FUN-680120 VARCHAR(20)        # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6B0014
DEFINE l_sql     LIKE type_file.chr1000           # SQL STATEMENT        #No.FUN-680120 VARCHAR(1000)
DEFINE l_n       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE l_i       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE l_order   ARRAY[5] OF    LIKE ima_file.ima01    #No.FUN-680120 VARCHAR(40)        
DEFINE sr        RECORD order1  LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)         
                        order2  LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)   
                        order3  LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40) 
                        tqx01   LIKE tqx_file.tqx01,
                        tqx02   LIKE tqx_file.tqx02,
                        tqx05   LIKE tqx_file.tqx05,
                        tqx07   LIKE tqx_file.tqx07, #FUN-D40128
                        tqx09   LIKE tqx_file.tqx09,
                        tsa02   LIKE tsa_file.tsa02,
                        tqy03   LIKE tqy_file.tqy03,
                        tqy38   LIKE tqy_file.tqy38,
                        tqy37   LIKE tqy_file.tqy37,
                        tsa03   LIKE tsa_file.tsa03,
                        tqz03   LIKE tqz_file.tqz03,
                        tqz04   LIKE tqz_file.tqz04,
                        tqz06   LIKE tqz_file.tqz06,
                        tqz07   LIKE tqz_file.tqz07,
                        tqz05   LIKE tqz_file.tqz05,
                        tqz11   LIKE tqz_file.tqz11,
                        tqz09   LIKE tqz_file.tqz09,
                        tqz08   LIKE tqz_file.tqz08,
                        tqz12   LIKE tqz_file.tqz12,
                        tqz16   LIKE tqz_file.tqz16,
                        tqz15   LIKE tqz_file.tqz15,
                        tqz17   LIKE tqz_file.tqz17,
                        tqz10   LIKE tqz_file.tqz10,
                        tqz031  LIKE tqz_file.tqz031,
                        tsa04   LIKE tsa_file.tsa04,
                        tsa05   LIKE tsa_file.tsa05,
                        tsa08   LIKE tsa_file.tsa08,
                        tqy36   LIKE tqy_file.tqy36
                        END RECORD
#NO.FUN-860008---start---
   DEFINE  l_occ021    LIKE occ_file.occ02 
   DEFINE  l_tqa02     LIKE tqa_file.tqa02
   DEFINE  l_occ02     LIKE occ_file.occ02
   DEFINE  l_ima021    LIKE ima_file.ima021
   DEFINE  tqx01_t     LIKE tqx_file.tqx01
   DEFINE  tsa02_t     LIKE tsa_file.tsa02
   DEFINE  l_flag      LIKE type_file.chr1
   DEFINE  l_flag1     LIKE type_file.chr1   
#FUN-CB0003---str---
   DEFINE  l_tqy_occ   LIKE type_file.chr1000,
           l_tqz031    LIKE type_file.chr1000,
           l_tqa021    LIKE type_file.chr1000,
           l_num       LIKE type_file.num5,
           l_str       STRING
#FUN-CB0003---end---
   DEFINE  l_tqx07     LIKE type_file.chr100  #FUN-D40128

    CALL  cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmx246'
#NO.FUN-860008---end----
   #抓取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND tqxuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND tqxgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND tqxgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqxuser', 'tqxgrup')
   #End:FUN-980030
 
   DELETE FROM curr_tmp;
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt_t) FROM curr_tmp ",    #group 1 小計
             "  WHERE order1=? ",
             "  GROUP BY curr"
   PREPARE tmp1_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt_t) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "  GROUP BY curr  "
   PREPARE tmp2_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt_t) FROM curr_tmp ",    #group 3 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND order3=? ",
             "  GROUP BY curr  "
   PREPARE tmp3_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_3:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt_t) FROM curr_tmp ",    #on last row 總計
             "  GROUP BY curr  "
   PREPARE tmp4_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_4:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp4_cs CURSOR FOR tmp4_pre
#NO.CHI-6A0004 --START
#  SELECT azi03,azi04,azi05
#    INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#    FROM azi_file
#   WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = "tqx01"
                                       LET g_orderA[g_i]= g_x[20]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = "tqx02"
                                       LET g_orderA[g_i]= g_x[21]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = "tsa02"
                                       LET g_orderA[g_i]= g_x[22]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = "tqy03"
                                       LET g_orderA[g_i]= g_x[23]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = "tsa03"
                                       LET g_orderA[g_i]= g_x[24]
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = "tqz03"
                                       LET g_orderA[g_i]= g_x[25]
              OTHERWISE LET l_order[g_i]  = ''
                        LET g_orderA[g_i] = ' '          #清為空白
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
 
   LET l_sql = "SELECT '','','',                                ",
               "      tqx01,tqx02,tqx05,tqx07,tqx09,",   #FUN-D40128 add tqx07
               "      tsa02,tqy03,tqy38,tqy37,tsa03,tqz03,",
               "      tqz04,tqz06,tqz07,tqz05,tqz11,tqz09,tqz08,", 
               "      tqz12,tqz16,tqz15,tqz17,tqz10,",                
               "      tqz031,tsa04,tsa05,tsa08,tqy36",
               " FROM tqx_file,tsa_file, tqy_file,tqz_file",
               " WHERE tqx01 = tsa01 ",
               "   AND tqx01 = tqy_file.tqy01 ",
               "   AND tqx01 = tqz_file.tqz01 ",
               "   AND tsa02 = tqy_file.tqy02 ",
               "   AND tsa03 = tqz_file.tqz02 ",
               "   AND ", tm.wc CLIPPED
   CASE tm.a
        WHEN '1'
             LET l_sql=l_sql CLIPPED, " AND tqy_file.tqy37 = 'Y' AND tqy_file.tqy38 IS NOT NULL AND tqy_file.tqy38 <= '",g_today,"'"
        WHEN '2'
             LET l_sql=l_sql CLIPPED, " AND tqy_file.tqy37 = 'N'"
   END CASE
   IF NOT cl_null(sr.order1) THEN
      LET l_sql = l_sql CLIPPED," ORDER BY " ,sr.order1
      IF NOT cl_null(sr.order2) THEN
          LET l_sql = l_sql CLIPPED,",",sr.order2
      END IF
      IF NOT cl_null(sr.order3) THEN
          LET l_sql = l_sql CLIPPED,",",sr.order3
       END IF
   ELSE
     IF NOT cl_null(sr.order2) THEN
         LET l_sql = l_sql CLIPPED," ORDER BY " ,sr.order2
         IF NOT cl_null(sr.order3) THEN
             LET l_sql = l_sql CLIPPED,",",sr.order3
          END IF
     ELSE
       IF NOT cl_null(sr.order3) THEN
          LET l_sql = l_sql CLIPPED," ORDER BY " ,sr.order3
       END IF
     END IF
   END IF
   #FUN-D40129----add---str---
   IF NOT cl_null(sr.order1) OR NOT cl_null(sr.order2) OR NOT cl_null(sr.order3) THEN
      LET l_sql = l_sql CLIPPED,",tsa02,tsa03"
   ELSE
      LET l_sql = l_sql CLIPPED," ORDER BY tqx01,tsa02,tsa03"
   END IF
   #FUN-D40129----add---end---
{
   #FUN-D40020--add---
   IF cl_null(sr.order1) AND cl_null(sr.order2) AND cl_null(sr.order3) THEN
      LET l_sql = l_sql CLIPPED," ORDER BY tqx01,tsa02"
   ELSE
      LET l_sql = l_sql CLIPPED,", tqx01,tsa02 "
   END IF
   #FUN-D40020--add---
}
#NO.FUN-860008------START----MARK---
#  LET l_n =0
#  FOR l_i = 1 TO 966
#      IF l_sql[l_i,l_i+4] = 'tqx01' THEN
#         LET l_n = l_n+1
#      END IF
#  END FOR
#  IF l_n = 4 THEN
#     LET l_sql=l_sql,',tqx01'
#  END IF
#  LET l_n = 0
#  FOR l_i = 1 TO 996
#      IF l_sql[l_i,l_i+4] = 'tsa02' THEN
#         LET l_n = l_n+1
#      END IF
#  END FOR
#  IF l_n = 2 THEN
#     LET l_sql=l_sql,',tsa02'
#  END IF
#  LET l_n = 0
#  FOR l_i = 1 TO 996
#      IF l_sql[l_i,l_i+4] = 'tsa03' THEN
#         LET l_n = l_n+1
#      END IF
#  END FOR
#  IF l_n = 2 THEN
#     LET l_sql=l_sql,',tsa03'
#  END IF
#NO.FUN-860008---END---MARK-----
   PREPARE x246_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   DECLARE x246_curs1 CURSOR FOR x246_prepare1
 
#   CALL cl_outnam('atmx246') RETURNING l_name              #NO.FUN-860008
 
   CALL cl_prt_pos_len()
 
#   START REPORT x246_rep TO l_name                         #NO.FUN-860008
#   LET g_pageno = 0                                        #NO.FUN-860008
   FOREACH x246_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF tm.a = '1' AND sr.tqy37 = 'N' THEN
         CONTINUE FOREACH
      END IF
 
      IF tm.a = '2' AND sr.tqy37 = 'Y' THEN
         CONTINUE FOREACH
      END IF
#NO.FUN-860008---start--mark--
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.tqx01
#                                       LET g_orderA[g_i]= g_x[20]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.tqx02
#                                       LET g_orderA[g_i]= g_x[21]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.tsa02
#                                       LET g_orderA[g_i]= g_x[22]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.tqy03
#                                       LET g_orderA[g_i]= g_x[23]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.tsa03
#                                       LET g_orderA[g_i]= g_x[24]
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.tqz03
#                                       LET g_orderA[g_i]= g_x[25]
#              OTHERWISE LET l_order[g_i]  = '-'
#                        LET g_orderA[g_i] = ' '          #清為空白
#         END CASE
#      END FOR
#
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#NO.FUN-860008---end---mark--
#      OUTPUT TO REPORT x246_rep(sr.*)                      #NO.FUN-860008
#NO.FUN-860008---START--
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05
        FROM azi_file
       WHERE azi01=sr.tqx09
      SELECT azp03 INTO l_occ02 FROM azp_file WHERE azp01 = sr.tqy36
      LET l_occ02 = l_occ02 CLIPPED,'.' 
      LET l_sql = " SELECT occ02 FROM ",l_occ02 CLIPPED,"occ_file ",
                  "  WHERE occ01 = '",sr.tqy03,"' "
      PREPARE occ02_pre FROM l_sql
      EXECUTE occ02_pre INTO l_occ021
 
      SELECT ima021 INTO l_ima021 FROM ima_file
       WHERE ima01 = sr.tqz03
      SELECT tqa02 INTO l_tqa02 FROM tqa_file
       WHERE tqa01 = sr.tqz10 AND tqa03 = '18'
      IF cl_null(sr.tqz10) THEN
         LET l_tqa02 = NULL
      END IF
#FUN-CB0003--add--str---
     LET l_tqy_occ = sr.tqy03 CLIPPED,' ',l_occ021 CLIPPED
     LET l_tqz031 = sr.tqz031 CLIPPED,'/',l_ima021 CLIPPED
     LET l_tqa021 = sr.tqz10 CLIPPED,' ',l_tqa02 CLIPPED
     LET l_num = 0
     IF NOT cl_null(tqx01_t) THEN 
        IF sr.tqx01 != tqx01_t THEN 
           LET l_flag = 'Y'
        ELSE
           LET l_flag = 'N'
        END IF
     ELSE
        LET l_flag = 'Y'
     END IF
     IF NOT cl_null(tqx01_t) AND NOT cl_null(tsa02_t) THEN 
       #IF sr.tsa02 != tsa02_t THEN  #FUN-D50099
        IF sr.tqx01 = tqx01_t THEN   #FUN-D50099
           IF sr.tsa02 != tsa02_t THEN  #FUN-D50099
              LET l_flag1 = 'Y'
           ELSE
              LET l_flag1 = 'N'
           END IF
        ELSE
           LET l_flag1 = 'Y'
        END IF  
     ELSE                  #FUN-D50099
        LET l_flag1 = 'Y'  #FUN-D50099
     END IF                #FUN-D50099
     LET tqx01_t = sr.tqx01
     LET tsa02_t = sr.tsa02
     LET l_tqx07=cl_gr_getmsg('atm-159',g_lang,sr.tqx07) #FUN-D40128
#FUN-CB0003--add--end---
      EXECUTE insert_prep USING
        sr.tqx01,sr.tqx02,sr.tqx05,sr.tqx09,sr.tsa02,sr.tqy03,sr.tqy38,sr.tqy37,
        sr.tsa03,sr.tqz03,sr.tqz04,sr.tqz06,sr.tqz07,sr.tqz05,sr.tqz11,sr.tqz09,
        sr.tqz08,sr.tqz12,sr.tqz16,sr.tqz15,sr.tqz17,sr.tqz10,sr.tqz031,sr.tsa04,
        sr.tsa05,sr.tsa08,sr.tqy36,l_occ021,l_tqa02,l_ima021,t_azi04,t_azi05
        ,l_tqy_occ, l_tqz031,l_tqa021,l_num,l_flag,l_flag1                 #FUN-CB0003  add 
        ,l_tqx07  #FUN-D40128
#NO.FUN-860008---END--
   END FOREACH
 
#   FINISH REPORT x246_rep                                  #NO.FUN-860008
#NO.FUN-860008--start--
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'tqx01,tqx02,tqx03,tqx04,tqx12,tqx13,tqx07')
           RETURNING tm.wc
     END IF
###XtraGrid###     LET g_str = tm.wc,";", tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
###XtraGrid###                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
###XtraGrid###                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
###XtraGrid###     CALL cl_prt_cs3('atmx246','atmx246',g_sql,g_str) 
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CB0003--add--str---
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"tqx01,tqx02,tsa02,tqy_occ,tsa03,tqz03")
    LET g_xgrid.order_field = g_xgrid.order_field,",","tqx01,tsa02,tsa03"  #FUN-D40020  #FUN-D40129 add tsa03
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"tqx01,tqx02,tsa02,tqy_occ,tsa03,tqz03")
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"tqx01,tqx02,tsa02,tqy_occ,tsa03,tqz03")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"tqx01,tqx02,tsa02,tqy_occ,tsa03,tqz03") #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #LET l_str = cl_wcchp(g_xgrid.order_field,"tqx01,tqx02,tsa02,tqy_occ,tsa03,tqz03") #FUN-D30070 mark
   #LET l_str = cl_replace_str(l_str,',','-') #FUN-D30070 mark
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str #FUN-D30070 mark
#FUN-CB0003--add--end---
    CALL cl_xg_view()    ###XtraGrid###
#NO.FUN-860008---end---
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)             #NO.FUN-860008
 
END FUNCTION
#NO.FUN-860008---start---
#REPORT x246_rep(sr)
#DEFINE l_last_sw                LIKE type_file.chr1        #No.FUN-680120 VARCHAR(1)
#DEFINE sr        RECORD order1  LIKE ima_file.ima01,       #No.FUN-680120 VARCHAR(40)       
#                        order2  LIKE ima_file.ima01,       #No.FUN-680120 VARCHAR(40) 
#                        order3  LIKE ima_file.ima01,       #No.FUN-680120 VARCHAR(40)
#                        tqx01   LIKE tqx_file.tqx01,
#                        tqx02   LIKE tqx_file.tqx02,
#                        tqx05   LIKE tqx_file.tqx05,
#                        tqx09   LIKE tqx_file.tqx09,
#                        tsa02   LIKE tsa_file.tsa02,
#                        tqy03   LIKE tqy_file.tqy03,
#                        tqy38   LIKE tqy_file.tqy38,
#                        tqy37   LIKE tqy_file.tqy37,
#                        tsa03   LIKE tsa_file.tsa03,
#                        tqz03   LIKE tqz_file.tqz03,
#                        tqz04   LIKE tqz_file.tqz04,
#                        tqz06   LIKE tqz_file.tqz06,
#                        tqz07   LIKE tqz_file.tqz07,
#                        tqz05   LIKE tqz_file.tqz05,
#                        tqz11   LIKE tqz_file.tqz11,
#                        tqz09   LIKE tqz_file.tqz09,
#                        tqz08   LIKE tqz_file.tqz08,
#                        tqz12   LIKE tqz_file.tqz12,
#                        tqz16   LIKE tqz_file.tqz16,
#                        tqz15   LIKE tqz_file.tqz15,
#                        tqz17   LIKE tqz_file.tqz17,
#                        tqz10   LIKE tqz_file.tqz10,
#                        tqz031  LIKE tqz_file.tqz031,
#                        tsa04   LIKE tsa_file.tsa04,
#                        tsa05   LIKE tsa_file.tsa05,
#                        tsa08   LIKE tsa_file.tsa08,
#                        tqy36   LIKE tqy_file.tqy36
#                        END RECORD,
#          sr1           RECORD                 
#                           curr      LIKE azi_file.azi01,   #No.FUN-680120 VARCHAR(04) 
#                           amt       LIKE tsa_file.tsa05,
#                           amt_t     LIKE tsa_file.tsa08
#                    END RECORD,
#                l_str   LIKE ima_file.ima01,       #No.FUN-680120 VARCHAR(40)         
#                l_str1  LIKE ima_file.ima01,       #No.FUN-680120 VARCHAR(40)      
#                l_str2  LIKE gbc_file.gbc05,       #No.FUN-680120 VARCHAR(100)           
#                l_str3  LIKE ima_file.ima01,       #No.FUN-680120        
#                l_ima021 LIKE ima_file.ima021, 
#		l_rowno LIKE type_file.num5,       #No.FUN-680120 SMALLINT
#		l_amt_1 LIKE oeb_file.oeb14,   
#		l_amt_2 LIKE tsa_file.tsa04    
#   DEFINE  l_occ021    LIKE occ_file.occ02 
#   DEFINE  l_tqa02     LIKE tqa_file.tqa02 
#   DEFINE  l_tsa02_t   LIKE tsa_file.tsa02 
#   DEFINE  l_tqx01_t   LIKE tqx_file.tqx01 
#   DEFINE  l_tqx01_o   LIKE type_file.num10        #No.FUN-680120 INTEGER
#   DEFINE  l_occ02     LIKE occ_file.occ02       #No.FUN-680120 VARCHAR(21)
#   DEFINE  l_tqa021    LIKE gbc_file.gbc05         #No.FUN-680120 VARCHAR(100)
#   DEFINE  l_tqy_occ02 LIKE gbc_file.gbc05         #No.FUN-680120 VARCHAR(100)
# 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
##     ORDER BY sr.tqx01,sr.tsa02,sr.tsa03
#  #格式設定
#  FORMAT
#   #列印表頭
#   PAGE HEADER
#      IF g_pageno = 0 THEN
#         LET l_tsa02_t = 0
#         LET l_tqx01_t = ' '
#         LET l_tqx01_o = 9
#      END IF
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[13] CLIPPED,
#                    g_orderA[1] CLIPPED,'-',
#                    g_orderA[2] CLIPPED,'-',
#                    g_orderA[3] CLIPPED
#      PRINT g_head1
#
#      PRINT g_dash[1,g_len]
#      PRINTX name =H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#                      g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#                      g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],
#                      g_x[55]
#      PRINTX name =H2 g_x[58],g_x[60],g_x[56]
#      PRINTX name =H3 g_x[59],g_x[61],g_x[57]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'           #跳頁控制
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2       #跳頁控制
#      IF tm.t[2,2] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3       #跳頁控制
#      IF tm.t[3,3] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.tqx01
#      SELECT azi03,azi04,azi05
##       INTO g_azi03,g_azi04,g_azi05   #NO.CHI-6A0004
#        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.tqx09
#      IF l_tqx01_t <> sr.tqx01 THEN
#         PRINTX name =D1
#               COLUMN g_c[31],sr.tqx01 CLIPPED,
#               COLUMN g_c[32],sr.tqx02 CLIPPED,
#               COLUMN g_c[33],sr.tqx05 CLIPPED,
#               COLUMN g_c[34],sr.tqx09 CLIPPED;
#         LET l_tqx01_t = sr.tqx01
#         LET l_tqx01_o = 1
#      ELSE
#         PRINTX name =D1
#               COLUMN g_c[31],' ',
#               COLUMN g_c[32],' ',
#               COLUMN g_c[33],' ',
#               COLUMN g_c[34],' ';
#         LET l_tqx01_o = 0
#      END IF
#   BEFORE GROUP OF sr.tsa02
#      SELECT azp03 INTO l_occ02 FROM azp_file WHERE azp01 = sr.tqy36
#      LET l_occ02 = l_occ02 CLIPPED,'.' 
#      LET l_sql = " SELECT occ02 FROM ",l_occ02 CLIPPED,"occ_file ",
#                  "  WHERE occ01 = '",sr.tqy03,"' "
#      PREPARE occ02_pre FROM l_sql
#      EXECUTE occ02_pre INTO l_occ021
#      LET l_tqy_occ02 = sr.tqy03 CLIPPED,' ',l_occ021 CLIPPED
#      IF l_tqx01_o = 1 OR (l_tqx01_o = 0 AND l_tsa02_t <> sr.tsa02) THEN
#         PRINTX name =D1 
#               COLUMN g_c[35],sr.tsa02 CLIPPED USING "########",
#               COLUMN g_c[36],l_tqy_occ02,
#               COLUMN g_c[37],sr.tqy38 CLIPPED,
#               COLUMN g_c[38],sr.tqy37 CLIPPED;
#         LET l_tsa02_t = sr.tsa02
#      ELSE
#         PRINTX name =D1 
#               COLUMN g_c[35],' ',
#               COLUMN g_c[36],' ',
#               COLUMN g_c[37],' ',
#               COLUMN g_c[38],' ';
#      END IF
# 
#   ON EVERY ROW
#      SELECT ima021 INTO l_ima021 FROM ima_file
#       WHERE ima01 = sr.tqz03
#      SELECT tqa02 INTO l_tqa02 FROM tqa_file
#       WHERE tqa01 = sr.tqz10 AND tqa03 = '18'
#      IF cl_null(sr.tqz10) THEN
#         LET l_tqa02 = NULL
#      END IF
#      LET l_tqa021 = sr.tqz10 CLIPPED,' ',l_tqa02 CLIPPED
#      PRINTX name =D1 COLUMN g_c[39],sr.tsa03 CLIPPED USING "########",
#                      COLUMN g_c[40],sr.tqz03 CLIPPED,
#                      COLUMN g_c[41],sr.tqz04 CLIPPED,
#                      COLUMN g_c[42],sr.tqz06 CLIPPED,
#                      COLUMN g_c[43],sr.tqz07 CLIPPED,
#                      COLUMN g_c[44],sr.tqz05 CLIPPED,
##NO.CHI-6A0004 --START
##                     COLUMN g_c[45],cl_numfor(sr.tqz11,20,g_azi05) CLIPPED,
##                     COLUMN g_c[46],cl_numfor(sr.tqz09,20,g_azi05) CLIPPED,
##                     COLUMN g_c[47],cl_numfor(sr.tqz12,18,g_azi04) CLIPPED,
##                     COLUMN g_c[48],cl_numfor(sr.tqz16,20,g_azi05) CLIPPED,
##                     COLUMN g_c[49],cl_numfor(sr.tqz15,20,g_azi05) CLIPPED,
##                     COLUMN g_c[50],cl_numfor(sr.tqz17,18,g_azi04) CLIPPED,
#                      COLUMN g_c[45],cl_numfor(sr.tqz11,20,t_azi05) CLIPPED,
#                      COLUMN g_c[46],cl_numfor(sr.tqz09,20,t_azi05) CLIPPED,
#                      COLUMN g_c[47],cl_numfor(sr.tqz12,18,t_azi04) CLIPPED,
#                      COLUMN g_c[48],cl_numfor(sr.tqz16,20,t_azi05) CLIPPED,
#                      COLUMN g_c[49],cl_numfor(sr.tqz15,20,t_azi05) CLIPPED,
#                      COLUMN g_c[50],cl_numfor(sr.tqz17,18,t_azi04) CLIPPED,
#                      COLUMN g_c[51],sr.tqz08 CLIPPED,
##                     COLUMN g_c[52],cl_numfor(sr.tsa04,18,g_azi04) CLIPPED,
##                     COLUMN g_c[53],cl_numfor(sr.tsa05,24,g_azi05) CLIPPED,
##                     COLUMN g_c[54],cl_numfor(sr.tsa08,20,g_azi05) CLIPPED,
#                      COLUMN g_c[52],cl_numfor(sr.tsa04,18,t_azi04) CLIPPED,
#                      COLUMN g_c[53],cl_numfor(sr.tsa05,24,t_azi05) CLIPPED,
#                      COLUMN g_c[54],cl_numfor(sr.tsa08,20,t_azi05) CLIPPED,
##NO.CHI-6A0004 --END
#                      COLUMN g_c[55],l_tqa021
#    
#      PRINTX name =D2 COLUMN g_c[56],sr.tqz031 CLIPPED
#      PRINTX name =D3 COLUMN g_c[57],l_ima021 CLIPPED
#      INSERT INTO curr_tmp VALUES(sr.tqx09,sr.tsa05,sr.tsa08,
#                                  sr.order1,sr.order2,sr.order3)
#		
#   AFTER GROUP OF sr.order1            #金額小計
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_amt_2 = GROUP SUM(sr.tsa04)
#         PRINT COLUMN g_c[50],g_x[29] CLIPPED
#         PRINT COLUMN g_c[50],g_orderA[1] CLIPPED,
#               COLUMN g_c[51],g_x[11] CLIPPED,
##              COLUMN g_c[52],cl_numfor(l_amt_2,18,g_azi05);   #NO.CHI-6A0004
#               COLUMN g_c[52],cl_numfor(l_amt_2,18,t_azi05);   #NO.CHI-6A0004
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_str = sr1.curr CLIPPED,':'
##            PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,g_azi05),   #NO.CHI-6A0004
#             PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,t_azi05),   #NO.CHI-6A0004
##                  COLUMN g_c[54],cl_numfor(sr1.amt_t,20,g_azi05) CLIPPED        #NO.CHI-6A0004
#                   COLUMN g_c[54],cl_numfor(sr1.amt_t,20,t_azi05) CLIPPED        #NO.CHI-6A0004
#         END FOREACH
#	 PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order2            #金額小計
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_amt_2 = GROUP SUM(sr.tsa04)
#         PRINT COLUMN g_c[50],g_x[29] CLIPPED
#         PRINT COLUMN g_c[50],g_orderA[2] CLIPPED,
#               COLUMN g_c[51],g_x[11] CLIPPED,
##              COLUMN g_c[52],cl_numfor(l_amt_2 ,18,g_azi05);   #NO.CHI-6A0004
#               COLUMN g_c[52],cl_numfor(l_amt_2 ,18,t_azi05);   #NO.CHI-6A0004
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_str = sr1.curr CLIPPED,':'
##            PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,g_azi05),   #NO.CHI-6A0004
#             PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,t_azi05),   #NO.CHI-6A0004
##                  COLUMN g_c[54],cl_numfor(sr1.amt_t,20,g_azi05) CLIPPED        #NO.CHI-6A0004
#                   COLUMN g_c[54],cl_numfor(sr1.amt_t,20,t_azi05) CLIPPED        #NO.CHI-6A0004
#         END FOREACH
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order3            #金額小計
#      IF tm.u[3,3] = 'Y' THEN
#         LET l_amt_2 = GROUP SUM(sr.tsa04)
#         PRINT COLUMN g_c[50],g_x[29] CLIPPED
#         PRINT COLUMN g_c[50],g_orderA[3] CLIPPED,
#               COLUMN g_c[51],g_x[11] CLIPPED,
##              COLUMN g_c[52],cl_numfor(l_amt_2,18,g_azi05);   #NO.CHI-6A0004
#               COLUMN g_c[52],cl_numfor(l_amt_2,18,t_azi05);   #NO.CHI-6A0004
#         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_str = sr1.curr CLIPPED,':'
##            PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,g_azi05),   #NO.CHI-6A0004
#             PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,t_azi05),   #NO.CHI-6A0004
##                  COLUMN g_c[54],cl_numfor(sr1.amt_t,20,g_azi05) CLIPPED        #NO.CHI-6A0004
#                   COLUMN g_c[54],cl_numfor(sr1.amt_t,20,t_azi05) CLIPPED        #NO.CHI-6A0004
#         END FOREACH
#         PRINT ''
#      END IF
#
#   ON LAST ROW                         #金額總計
#      PRINT ''
#      LET l_amt_2 = SUM(sr.tsa04)
#
#      PRINT COLUMN g_c[51],g_x[30] CLIPPED
#      PRINT COLUMN g_c[51],g_x[12] CLIPPED,
##           COLUMN g_c[52],cl_numfor(l_amt_2,18,g_azi04);   #NO.CHI-6A0004
#            COLUMN g_c[52],cl_numfor(l_amt_2,18,t_azi04);   #NO.CHI-6A0004
#      
#      FOREACH tmp4_cs INTO sr1.*
##         SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#          SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#           WHERE azi01 = sr1.curr
#          LET l_str = sr1.curr CLIPPED,':'
##         PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,g_azi05),   #NO.CHI-6A0004
#          PRINT COLUMN g_c[53],l_str CLIPPED,cl_numfor(sr1.amt,20,t_azi05),   #NO.CHI-6A0004
##               COLUMN g_c[54],cl_numfor(sr1.amt_t,20,g_azi05) CLIPPED        #NO.CHI-6A0004
#                COLUMN g_c[54],cl_numfor(sr1.amt_t,20,t_azi05) CLIPPED        #NO.CHI-6A0004
#      END FOREACH
#      PRINT ''
#
#      #是否列印選擇條件
#      IF g_zz05 = 'Y' THEN
#         CALL cl_wcchp(tm.wc,'tqx01,tqx02,tqx03,tqx04,tqx05')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#   	 CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#     PRINT  COLUMN (g_len-9),g_x[7] CLIPPED  
#
#   #表尾列印
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT COLUMN (g_len-9),g_x[6] CLIPPED  
#      ELSE
#         SKIP 2 LINE
#      END IF
#      PRINT
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[4]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[4]
#             PRINT g_memo
#      END IF
#
#END REPORT
#NO.FUN-860008---end----
#No.FUN-870144


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

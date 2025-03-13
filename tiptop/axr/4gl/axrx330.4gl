# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: axrx330.4gl
# Descriptions...: 客戶對帳單
# Date & Author..: 95/02/14 by Nick
# Modify.........: No.FUN-4C0100 05/03/02 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.MOD-540183 05/05/10 By ching add oma10
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570177 05/07/19 By Trisy 項次位數加大
# Modify.........: No:2005/07/19 No.MOD-4A0082 By coco change l_str 100->150
# Modify.........: No.FUN-590110 05/09/23 By jackie 報表轉XML格式
# Modify.........: No.FUN-5B0139 05/12/05 By ice 有發票待扺時,報表應負值呈現對應的待扺資料
# Modify.........: No.TQC-630006 06/03/02 By alex 移除 cat /dev/null 寫法
# Modify.........: No.TQC-630185 06/03/21 By Echo 將echo '' 改為 echo -n ''
# Modify.........: No.TQC-5C0086 05/12/20 By Carrier AR月底重評修改
# Modify.........: No.MOD-650098 06/05/25 By Echo 恢復 cat /dev/null 寫法
# Modify.........: No.FUN-5C0014 06/05030 By rainy 新增顯示INVOICE No.
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/12 By xufeng 修改報表
# Modify.........: No.FUN-710080 07/03/26 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.TQC-750177 07/05/29 By rainy 類別列印異常
# Modify.........: No.MOD-7C0041 07/12/06 By Smapmin 增加規格欄位
# Modify.........: No.MOD-810074 08/01/10 By Smapmin 單身資料以子報表呈現
# Modify.........: No.MOD-850306 08/06/02 By Sarah 移除tm.x 選項
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_oma24應給予預設值'',抓不到也不可為'1'
# Modify.........: No:CHI-B50043 11/05/27 By Sarah 增加抓取pmc232~pmc235
# Modify.........: No.FUN-C40001 12/04/13 By yinhy 增加開窗功能
# Modify.........: No.MOD-C50056 12/05/09 By Elise PREPARE x330_prepare2的aza26 = '2'的SQL取消aza34條件 
# Modify.........: No.FUN-C30037 12/05/22 By wangrr 添加oma032賬款客戶簡稱
# Modify.........: No.TQC-CA0058 12/10/29 By wangrr 查詢條件賬款客戶簡稱轉換為漢字不正確，默認排序為oma032，oma02
# Modify.........: No.MOD-CC0024 12/12/05 By Polly 選擇將原幣金額轉換成本幣金額時，金額取位與小數位數應抓取原幣
# Modify.........: No.FUN-D30070 13/03/21 By yangtt 去除畫面檔上小計欄位，并去除4gl中grup_sum_field

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD
            wc       LIKE type_file.chr1000,   # Where condition #No.FUN-680123 VARCHAR(300)
            s        LIKE type_file.chr3,      # Order by sequence #No.FUN-680123 VARCHAR(3)
            t        LIKE type_file.chr3,      # Eject sw #No.FUN-680123 VARCHAR(3)
           #u        LIKE type_file.chr3,      # Group total sw #No.FUN-680123 VARCHAR(3) #FUN-D30070 mark
            deadline LIKE type_file.dat,      # 截止日期 #No.FUN-680123 DATE
  	    n        LIKE type_file.chr1,     # 是否列印產品明細 #No.FUN-680123 VARCHAR(01)
      	    y        LIKE type_file.chr1,     # 是否將原幣金額轉成本幣金額 #No.FUN-680123 VARCHAR(01)
           # Prog. Version..: '5.30.07-13.05.16(01)   #MOD-850306 mark
            more     LIKE type_file.chr1      # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
           END RECORD,
       headtag       LIKE type_file.chr1,     # 判斷XML的HEAD是否列印過 #No.FUN-680123 VARCHAR(1)
       xml_name      LIKE type_file.chr20     # For XML File Name #No.FUN-680123 VARCHAR(20)
DEFINE g_i           LIKE type_file.num5      #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE i             LIKE type_file.num5      #No.FUN-680123 SMALLINT
#str FUN-710080 add
DEFINE l_table       STRING
DEFINE l_table2      STRING   #MOD-810074
DEFINE g_sql         STRING
DEFINE g_str         STRING
DEFINE g_oma00       LIKE oma_file.oma00   #MOD-810074
 
#end FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oma03.oma_file.oma03,oma032.oma_file.oma032,",
               "oma044.oma_file.oma044,occ231.occ_file.occ231,",
               "occ232.occ_file.occ232,occ233.occ_file.occ233,",  #CHI-B50043 add
               "occ234.occ_file.occ234,occ235.occ_file.occ235,",  #CHI-B50043 add
               "occ29.occ_file.occ29,occ261.occ_file.occ261,",
               "occ292.occ_file.occ292,oma02.oma_file.oma02,",
               "oma00_d.type_file.chr4,oma01.oma_file.oma01,",
               "oma11.oma_file.oma11,oma15.oma_file.oma15,",
               "oma14.oma_file.oma14,gem02.gem_file.gem02,",
               "gen02.gen_file.gen02,oma23.oma_file.oma23,",
               "oma24.oma_file.oma24,oma54t.oma_file.oma54t,",
               "balance.oma_file.oma54,oma56t.oma_file.oma56t,",
               "balance2.oma_file.oma54,oox10.oox_file.oox10,",
               "oma10.oma_file.oma10,oma67.oma_file.oma67,",
               #-----MOD-810074---------
               #"omb03.omb_file.omb03,omb31.omb_file.omb31,",
               #"omb04.omb_file.omb04,omb05.omb_file.omb05,",
               #"omb12.omb_file.omb12,omb13.omb_file.omb13,",
               #"omb14t.omb_file.omb14t,omb06.omb_file.omb06,",
               #"omb06.omb_file.omb06,ima021.ima_file.ima021,",   #MOD-7C0041 add ima021
               #-----END MOD-810074-----
               "azi03.azi_file.azi03,azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,azi07.azi_file.azi07,",
               "occ29_occ261_occ292.type_file.chr100,",   #No.
               "feyfd.type_file.chr100,",   #No.FUN-
               "addr.type_file.chr100"                    #No.FUN-
 
   LET l_table = cl_prt_temptable('axrx3301',g_sql) CLIPPED   # 產生Temp Table   #MOD-810074
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #-----MOD-810074---------
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
   #            " VALUES(?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?,",
   #            "        ?,?,?,?,?, ?,?,?,?,?,",   
   #            #"        ?,?,?,?,?, ?)"   #MOD-7C0041
   #            "        ?,?,?,?,?, ?,?)"   #MOD-7C0041
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   #END IF
   #-----END MOD-810074-----
   #------------------------------ CR (1) ------------------------------#
   #end FUN-710080 add
 
   #-----MOD-810074---------
   LET g_sql = "oma01.oma_file.oma01,omb03.omb_file.omb03,",
               "omb31.omb_file.omb31,omb04.omb_file.omb04,",
               "omb05.omb_file.omb05,omb12.omb_file.omb12,",
               "omb13.omb_file.omb13,omb14t.omb_file.omb14t,",
               "omb06.omb_file.omb06,ima021.ima_file.ima021,",
               "azi03.azi_file.azi03,azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,azi07.azi_file.azi07"
   LET l_table2 = cl_prt_temptable('axrx3302',g_sql) CLIPPED   # 產生Temp Table
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #CHI-B50043 add 4?   #No.FUN-
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)" 
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) EXIT PROGRAM
   END IF
   #-----END MOD-810074-----
 
   #-----TQC-610059---------
   LET g_pdate =ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang =ARG_VAL(3)
   LET g_bgjob =ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc   =ARG_VAL(7)
   LET tm.s    =ARG_VAL(8)
   LET tm.t    =ARG_VAL(9)
  #LET tm.u    =ARG_VAL(10) #FUN-D30070 mark
  #FUN-D30070---mod---str--
  #LET tm.deadline = ARG_VAL(11)
  #LET tm.n    =ARG_VAL(12)
  #LET tm.y    =ARG_VAL(13)
 ##LET tm.x    =ARG_VAL(14)   #MOD-850306 mark
  ##-----END TQC-610059-----
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(14)
  #LET g_rep_clas = ARG_VAL(15)
  #LET g_template = ARG_VAL(16)
  #LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
  ##No.FUN-570264 ---end---
   LET tm.deadline = ARG_VAL(10)
   LET tm.n    =ARG_VAL(11)
   LET tm.y    =ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16) 
  #FUN-D30070---mod---end--
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
  #LET tm2.u1   = tm.u[1,1]  #FUN-D30070 mark
  #LET tm2.u2   = tm.u[2,2]  #FUN-D30070 mark
  #LET tm2.u3   = tm.u[3,3]  #FUN-D30070 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF  #FUN-D30070 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF  #FUN-D30070 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF  #FUN-D30070 mark
   #no.5196 #No.FUN-680123
   DROP TABLE curr_tmp
   CREATE TEMP TABLE curr_tmp(
     curr LIKE azi_file.azi01,
     amt1 LIKE oma_file.oma54,
     amt2 LIKE oma_file.oma54x,
     amt3 LIKE oma_file.oma61,
     oma03 LIKE oma_file.oma03,
     order1 LIKE type_file.chr20, 
     order2 LIKE type_file.chr20, 
     order3 LIKE type_file.chr20)
   #no.5196(end)  #No.FUN-680123 end
 
   IF cl_null(tm.wc)
      THEN CALL axrx330_tm(0,0)                 # Input print condition
   ELSE
      CALL axrx330()                            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrx330_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(400)
 
   LET p_row = 3 LET p_col =16
 
   OPEN WINDOW axrx330_w AT p_row,p_col WITH FORM "axr/42f/axrx330"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s ='12 '
   LET tm.t ='Y  '
  #LET tm.u ='Y  '  #FUN-D30070 mark
   LET tm.n	='N'
   LET tm.y ='N'
  #LET tm.x ='N'   #MOD-850306 mark
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.deadline = g_today
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma03,oma032,oma23,oma01,oma00,oma15,oma14   #FUN-C30037 add oma032
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
        #No.FUN-C40001  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oma01)  #genero要改查單據單(未改)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_oma6'
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry()  RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma01
                   NEXT FIELD oma01
              WHEN INFIELD(oma03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma03
         #FUN-C30037--add--str
              WHEN INFIELD(oma032)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oma032"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma032
         #FUN-C30037--add--end
              WHEN INFIELD(oma14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma14
                   NEXT FIELD oma14
              WHEN INFIELD(oma15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem3"
                   LET g_qryparam.plant = g_plant
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma15
                   NEXT FIELD oma15
              WHEN INFIELD(oma23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oma23
                   NEXT FIELD oma23
              END CASE
        #No.FUN-C40001  --End
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrx330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                #tm2.u1,tm2.u2,tm2.u3,tm.deadline,tm.n,tm.y,   #tm.x,   #MOD-850306 mark tm.x  #FUN-D30070 mark
                 tm.deadline,tm.n,tm.y,   #tm.x,   #MOD-850306 mark tm.x   #FUN-D30070 add
                 tm.more WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD deadline
         IF cl_null(tm.deadline) THEN
            NEXT FIELD deadline
         END IF
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[YN]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD y
         IF cl_null(tm.y) OR tm.y NOT MATCHES '[YN]' THEN
            NEXT FIELD y
         END IF
     #str MOD-850306 mark
     #AFTER FIELD x
     #   IF cl_null(tm.x) OR tm.x NOT MATCHES '[YN]' THEN
     #      NEXT FIELD x
     #   END IF
     #end MOD-850306 mark
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION controlg
         CALL cl_cmdask()    # Command execution
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-D30070 mark
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axrx330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrx330'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrx330','9031',1)
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
                         " '",tm.s CLIPPED,"'" ,   #TQC-610059
                         " '",tm.t CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.u CLIPPED,"'" ,   #TQC-610059  #FUN-D30070 mark
                         " '",tm.deadline CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,   #TQC-610059
                         " '",tm.y CLIPPED,"'" ,   #TQC-610059
                        #" '",tm.x CLIPPED,"'" ,   #TQC-610059  #MOD-850306 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrx330',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrx330_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrx330()
   ERROR ""
END WHILE
   CLOSE WINDOW axrx330_w
END FUNCTION
 
FUNCTION axrx330()
   DEFINE
          l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
          l_str     LIKE type_file.chr1000,       # Temp String #No.FUN-680123 VARCHAR(100)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
	  l_oma03   LIKE oma_file.oma03,
         #l_order   ARRAY[5] OF VARCHAR(20),
          l_order   ARRAY[5] OF LIKE type_file.chr20,     #No.FUN-680123 VARCHAR(20)
          sr        RECORD
		    order1        LIKE type_file.chr20,   #No.FUN-680123 VARCHAR(20)
		    order2        LIKE type_file.chr20,   #No.FUN-680123 VARCHAR(20)
		    order3        LIKE type_file.chr20,   #No.FUN-680123 VARCHAR(20)
		    oma03         LIKE oma_file.oma03,    #1
                    oma032        LIKE oma_file.oma032,	  #2
                    oma044        LIKE oma_file.oma044,	  #3
		    occ231        LIKE occ_file.occ231,
		    occ232        LIKE occ_file.occ232,   #CHI-B50043 add
		    occ233        LIKE occ_file.occ233,   #CHI-B50043 add
		    occ234        LIKE occ_file.occ234,   #CHI-B50043 add
		    occ235        LIKE occ_file.occ235,   #CHI-B50043 add
                    occ29         LIKE occ_file.occ29,	  #4
                    occ261        LIKE occ_file.occ261,	  #5
                    occ292        LIKE occ_file.occ292,	  #6
		    oma02         LIKE oma_file.oma02,	  #7
                    #oma00         LIKE oma_file.oma00,    #8 #No.FUN-680123 VARCHAR(4)
                    oma00         LIKE type_file.chr4,    #8 #No.FUN-680123 VARCHAR(4)  #TQC-750177
                    oma01         LIKE oma_file.oma01,    #9
		    oma11         LIKE oma_file.oma11,	  #10
		    oma15         LIKE oma_file.oma15,	  #10
		    oma14         LIKE oma_file.oma14,	  #10
                    gem02         LIKE gem_file.gem02,	  #11
                    gen02         LIKE gen_file.gen02,	  #12
                    oma23         LIKE oma_file.oma23,	  #13
                    oma24         LIKE oma_file.oma24,	  #14
                    oma54t        LIKE oma_file.oma54t,	  #15
                    balance       LIKE oma_file.oma54,	  #16
	     	    oma56t        LIKE oma_file.oma56t,	  #17
		    balance2      LIKE oma_file.oma54,	  #18
		    oox10         LIKE oox_file.oox10,	  #19 bug no:A057
 		    oma10         LIKE oma_file.oma10,	  #MOD-540183
                    oma67         LIKE oma_file.oma67,    #FUN-5C0014
		    azi03         LIKE azi_file.azi03,
		    azi04         LIKE azi_file.azi04,
		    azi05         LIKE azi_file.azi05,
		    azi07         LIKE azi_file.azi07
                    END RECORD,
     #str FUN-710080 add
          sr2       RECORD
                    omb03         LIKE omb_file.omb03,
                    omb31         LIKE omb_file.omb31,
                    omb04         LIKE omb_file.omb04,
                    omb05         LIKE omb_file.omb05,
                    omb12         LIKE omb_file.omb12,
                    omb13         LIKE omb_file.omb13,
                    omb14t        LIKE omb_file.omb14t,
                    omb06         LIKE omb_file.omb06
                    END RECORD,
          l_omb03   LIKE omb_file.omb03,   #No.FUN-5B0139 記錄帳款單身項次
          l1_omb03  LIKE omb_file.omb03,   #No.FUN-5B0139 記錄帳款單身項次
          l_flag    LIKE type_file.chr1
     #end FUN-710080 add
     DEFINE l_ima021 LIKE ima_file.ima021   #MOD-7C0041
     DEFINE l_oox01    STRING                 #CHI-830003 add
     DEFINE l_oox02    STRING                 #CHI-830003 add
     DEFINE l_str_1    STRING                 #CHI-830003 add
     DEFINE l_sql_1    STRING                 #CHI-830003 add
     DEFINE l_sql_2    STRING                 #CHI-830003 add
     DEFINE l_omb03_1  LIKE omb_file.omb03    #CHI-830003 add
     DEFINE l_count    LIKE type_file.num5    #CHI-830003 add
     DEFINE l_oma24    LIKE oma_file.oma24    #CHI-830003 add     
     DEFINE l_occ29_occ261_occ292   LIKE type_file.chr200   #No.FUN-
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table2)   #MOD-810074
   #------------------------------ CR (2) ------------------------------#
   #end FUN-710080 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-710080 add
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
   #End:FUN-980030
 
  #str FUN-710080 mark
  ##no.5196
  #DELETE FROM curr_tmp;
  #
  #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ",  #bug no:A057
  #          "   FROM curr_tmp ",
  #          "  WHERE order1=? ",
  #          "  GROUP BY curr  "
  #PREPARE r320_prepare_1 FROM l_sql
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('prepare_1:',SQLCA.sqlcode,1) RETURN
  #END IF
  #DECLARE curr_temp1 CURSOR FOR r320_prepare_1
  #
  #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ", #bug no:A057
  #          "   FROM curr_tmp ",
  #          "  WHERE order1=? ",
  #          "    AND order2=? ",
  #          "  GROUP BY curr  "
  #PREPARE r320_prepare_2 FROM l_sql
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('prepare_2:',SQLCA.sqlcode,1) RETURN
  #END IF
  #DECLARE curr_temp2 CURSOR FOR r320_prepare_2
  #
  #LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3) ", #bug no:A057
  #          "   FROM curr_tmp ",
  #          "  WHERE order1=? ",
  #          "    AND order2=? ",
  #          "    AND order3=? ",
  #          "  GROUP BY curr  "
  #PREPARE r320_prepare_3 FROM l_sql
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('prepare_3:',SQLCA.sqlcode,1) RETURN
  #END IF
  #DECLARE curr_temp3 CURSOR FOR r320_prepare_3
  ##no.5196(end)
  #end FUN-710080 mark
 
   #No.TQC-5C0086  --Begin                                                                                                        
   IF g_ooz.ooz07 = 'N' THEN
      LET l_sql="SELECT '','','',oma03,oma032,oma044,",
                "occ231,occ232,occ233,occ234,occ235,",   #CHI-B50043 add occ232~occ235
      		"occ29,occ261,occ292,oma02,oma00,oma01,",
      		"oma11,oma15,oma14,gem02,gen02,oma23,oma24,",
    		"oma54t,oma54t-oma55,",
                #--modi by kitty Bug NO:A057
      		"oma56t,oma56t-oma57,0,oma10,oma67,",#FUN-5C0014 add oma67
              # "oma56t,oma61,0,oma10,",  #MOD-540183
      	        "azi03,azi04,azi05,azi07",
                " FROM oma_file,OUTER gem_file,OUTER gen_file,OUTER azi_file,",
                "      OUTER occ_file ",
                " WHERE oma_file.oma15=gem_file.gem01 AND oma_file.oma14=gen_file.gen01 ",
                "   AND omaconf = 'Y' AND omavoid = 'N'",  #97/07/29 modify
      	         "   AND oma54t>oma55 AND occ_file.occ01=oma_file.oma03",
                "   AND oma_file.oma23=azi_file.azi01 AND oma02 <='",tm.deadline,"' AND ",
         	   	   	  #tm.wc CLIPPED," ORDER BY oma03,oma032,oma02"  #FUN-C30037 add oma032 #TQC-CA0058 mark
                                  tm.wc CLIPPED," ORDER BY oma032,oma02"  #TQC-CA0058 add
   ELSE                                                                                                                           
      LET l_sql="SELECT '','','',oma03,oma032,oma044,",
                "occ231,occ232,occ233,occ234,occ235,",   #CHI-B50043 add occ232~occ235
      		"occ29,occ261,occ292,oma02,oma00,oma01,",
                "oma11,oma15,oma14,gem02,gen02,oma23,oma60,",                                                            
                "oma54t,oma54t-oma55,",                                                                                  
                "oma56t,oma61,0,oma10,oma67,",  #MOD-540183 #FUN-5C0014 add oma67                                                                   
                "azi03,azi04,azi05,azi07",                                                                               
                " FROM oma_file,OUTER gem_file,OUTER gen_file,OUTER azi_file,",                                                    
                "      OUTER occ_file ",                                                                                          
                " WHERE oma_file.oma15=gem_file.gem01 AND oma_file.oma14=gen_file.gen01 ",                                                          
                "   AND omaconf = 'Y' AND omavoid = 'N'",  #97/07/29 modify                                                       
                "   AND oma54t>oma55 AND occ_file.occ01=oma_file.oma03",                                                         
                "   AND oma_file.oma23=azi_file.azi01 AND oma02 <='",tm.deadline,"' AND ",                                                   
                             # tm.wc CLIPPED," ORDER BY oma03,oma032,oma02"      #FUN-C30037 add oma032 #TQC-CA0058 mark
                             tm.wc CLIPPED," ORDER BY oma032,oma02"    #TQC-CA0058 add                                                       
   END IF                                                                                                                         
   #No.TQC-5C0086  --End 
       LET l_sql= l_sql CLIPPED
   PREPARE axrx330_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   DECLARE axrx330_curs1 CURSOR FOR axrx330_prepare1
 
  #str FUN-710080 mark
  ##No.FUN-590110 --start--
  #IF tm.y='Y' THEN
  #   LET g_zaa[49].zaa06='N'
  #   IF tm.n='Y' THEN
  #      LET g_zaa[52].zaa06='N'
  #      LET g_zaa[53].zaa06='N'
  #      LET g_zaa[54].zaa06='N'
  #      LET g_zaa[55].zaa06='N'
  #      LET g_zaa[56].zaa06='N'
  #      LET g_zaa[57].zaa06='N'
  #      LET g_zaa[58].zaa06='N'
  #      LET g_zaa[59].zaa06='N'
  #   ELSE
  #      LET g_zaa[52].zaa06='Y'
  #      LET g_zaa[53].zaa06='Y'
  #      LET g_zaa[54].zaa06='Y'
  #      LET g_zaa[55].zaa06='Y'
  #      LET g_zaa[56].zaa06='Y'
  #      LET g_zaa[57].zaa06='Y'
  #      LET g_zaa[58].zaa06='Y'
  #      LET g_zaa[59].zaa06='Y'
  #   END IF
  #ELSE
  #   LET g_zaa[49].zaa06='Y'
  #   IF tm.n='Y' THEN
  #      LET g_zaa[52].zaa06='N'
  #      LET g_zaa[53].zaa06='N'
  #      LET g_zaa[54].zaa06='N'
  #      LET g_zaa[55].zaa06='N'
  #      LET g_zaa[56].zaa06='N'
  #      LET g_zaa[57].zaa06='N'
  #      LET g_zaa[58].zaa06='N'
  #      LET g_zaa[59].zaa06='N'
  #   ELSE
  #      LET g_zaa[52].zaa06='Y'
  #      LET g_zaa[53].zaa06='Y'
  #      LET g_zaa[54].zaa06='Y'
  #      LET g_zaa[55].zaa06='Y'
  #      LET g_zaa[56].zaa06='Y'
  #      LET g_zaa[57].zaa06='Y'
  #      LET g_zaa[58].zaa06='Y'
  #      LET g_zaa[59].zaa06='Y'
  #   END IF
  #END IF
  #CALL cl_prt_pos_len()
  ##No.FUN-590110 --end--
  #end FUN-710080 mark
 
### ******** Word Process Console 2002/07/31 ******** ###
  #str FUN-710080 mark
  #LET xml_name=l_name CLIPPED,'.xml'
  #IF tm.x = 'N' THEN
  #   START REPORT axrx330_rep1 TO l_name
  #ELSE
  #   START REPORT axrx330_rep2 TO l_name
  #END IF
  #end FUN-710080 mark
### ************************************************* ###
 
  #LET headtag = '0'   #FUN-710080 mark
   FOREACH axrx330_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      #CHI-830003--Add--Begin--#    
      IF g_ooz.ooz07 = 'Y' THEN
         LET l_oox01 = YEAR(tm.deadline)
         LET l_oox02 = MONTH(tm.deadline)                     	 
         LET l_oma24 = ''        #TQC-B10083 add
         WHILE cl_null(l_oma24)
            IF g_ooz.ooz62 = 'N' THEN
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 = '0'"
               PREPARE x330_prepare7 FROM l_sql_2
               DECLARE x330_oox7 CURSOR FOR x330_prepare7
               OPEN x330_oox7
               FETCH x330_oox7 INTO l_count
               CLOSE x330_oox7                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'    #TQC-B10083 mark 
                  EXIT WHILE            #TQC-B10083 add
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '0'"
               END IF                 
            ELSE
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 <> '0'"
               PREPARE x330_prepare8 FROM l_sql_2
               DECLARE x330_oox8 CURSOR FOR x330_prepare8
               OPEN x330_oox8
               FETCH x330_oox8 INTO l_count
               CLOSE x330_oox8                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'   #TQC-B10083 mark 
                  EXIT WHILE           #TQC-B10083 add
               ELSE            
                  SELECT MIN(omb03) INTO l_omb03_1 FROM omb_file
                   WHERE omb01 = sr.oma01
                  IF cl_null(l_omb03_1) THEN
                     LET l_omb03_1 = 0
                  END IF       
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '",l_omb03_1,"'"                                      
               END IF
            END IF   
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE x330_prepare07 FROM l_sql_1
               DECLARE x330_oox07 CURSOR FOR x330_prepare07
               OPEN x330_oox07
               FETCH x330_oox07 INTO l_oma24
               CLOSE x330_oox07
            END IF              
         END WHILE                       
      END IF
      #CHI-830003--Add--End--#
      
      #CHI-830003--Add--Begin--#
      #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN            #TQC-B10083 mark
      IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN     #TQC-B10083 mod 
         LET sr.oma56t = sr.oma54t * l_oma24
         LET sr.balance2 = sr.balance * l_oma24 
      END IF   
      #CHI-830003--Add--End--#      
      
      IF sr.oma00 MATCHES '2*' THEN
      	LET sr.oma54t  =-sr.oma54t
      	LET sr.balance =-sr.balance
      END IF
      IF tm.y='Y' THEN
      	LET sr.oma23=g_aza.aza17
      	LET sr.oma54t=sr.oma56t
      	LET sr.balance=sr.balance2
        #No.+141 010523 by plum
         IF sr.oma00 MATCHES '2*' THEN
            LET sr.oma54t  =-sr.oma54t
            LET sr.balance =-sr.balance
         END IF
        #No.+141..end
         LET sr.azi04 = g_azi04                                            #MOD-CC0024 add
         LET sr.azi05 = g_azi05                                            #MOD-CC0024 add
      END IF
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oma03
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oma032  #FUN-C30037 add 
             #WHEN tm.s[g_i,g_i] = '2'      #FUN-C30037 mark
              WHEN tm.s[g_i,g_i] = '3'      #FUN-C30037 add
                 LET l_order[g_i] = sr.oma23
             #WHEN tm.s[g_i,g_i] = '3'      #FUN-C30037 mark
              WHEN tm.s[g_i,g_i] = '4'      #FUN-C30037 add
                 LET l_order[g_i] = sr.oma01
             #WHEN tm.s[g_i,g_i] = '4'      #FUN-C30037 mark
              WHEN tm.s[g_i,g_i] = '5'      #FUN-C30037 add
                 LET l_order[g_i] = sr.oma00
             #WHEN tm.s[g_i,g_i] = '5'      #FUN-C30037 mark
              WHEN tm.s[g_i,g_i] = '6'      #FUN-C30037 add
                 LET l_order[g_i] = sr.oma15
             #WHEN tm.s[g_i,g_i] = '6'      #FUN-C30037 mark
              WHEN tm.s[g_i,g_i] = '7'      #FUN-C30037 add
                 LET l_order[g_i] = sr.oma14
              OTHERWISE                LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      LET g_oma00 = sr.oma00   #MOD-810074
      CALL axmx330_getdesc(sr.oma00) RETURNING sr.oma00			
      #no.5196
      #--modi by kitty Bug NO:A057
      SELECT SUM(oox10) INTO sr.oox10 FROM oox_file
       WHERE oox00='AR' AND oox03=sr.oma01
      IF cl_null(sr.oox10) THEN LET sr.oox10=0 END IF
      INSERT INTO curr_tmp VALUES (sr.oma23,sr.oma54t,sr.balance,sr.oox10,
                                   sr.oma03,sr.order1,sr.order2,sr.order3)
      #---end
      #no.5196(end)
      IF cl_null(sr.oma044) THEN LET sr.oma044=sr.occ231 END IF   #FUN-710080 add
      IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
      IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
      IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
 
      #str FUN-710080 add
      LET l_omb03 = 0     #No.FUN-5B0139 Default項次初值
      LET l1_omb03 = 0    #No.FUN-5B0139 Default項次初值
      #No.FUN-5B0139 --start--
      LET l_sql = "SELECT omb03,omb31,omb04,omb05,omb12,omb13,omb14t,omb06 ",
                  "  FROM omb_file ",
                  " WHERE omb01 = '",sr.oma01,"' "
      #只有大陸功能才有發票待扺
      IF g_aza.aza26 = '2' THEN
         LET l_sql = l_sql CLIPPED,
                     " UNION ",
                    #"SELECT ",g_aza.aza34," omb03,omb31,omb04,omb05,-omb12,omb13,-omb14t,omb06 ",  #MOD-C50056 mark
                     "SELECT omb03,omb31,omb04,omb05,-omb12,omb13,-omb14t,omb06 ",                  #MOD-C50056
                     "  FROM omb_file ",
                     " WHERE omb01 IN (SELECT DISTINCT oot01 ",
                     "  FROM oot_file ",
                     " WHERE oot03 = '",sr.oma01,"') "
      END IF
      PREPARE x330_prepare2 FROM l_sql
      IF SQLCA.sqlcode THEN
          CALL cl_err('x330_prepare2:',SQLCA.sqlcode,1) RETURN
      END IF
      DECLARE axrx330_cur2 CURSOR FOR x330_prepare2
      #No.FUN-5B0139 --end--
 
      LET l_flag = 'N'
      FOREACH axrx330_cur2 INTO sr2.*
         #-----MOD-810074---------
         IF l_flag = 'N' THEN 
           #No.FUN-
            IF cl_null(sr.OCC29) AND cl_null(sr.OCC261) AND cl_null(sr.OCC292) THEN
               LET l_occ29_occ261_occ292 = ""
            ELSE
               IF cl_null(sr.OCC29) THEN
                  IF cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC292
                  END IF
                  IF not cl_null(sr.OCC261) AND cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC261
                  END IF
                  IF not cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 =sr.OCC292 + " " + sr.OCC261
                  END IF
               ELSE
                  IF cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC29 + " " + sr.OCC292
                  END IF
                  IF not cl_null(sr.OCC261) AND cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC29 + " " + sr.OCC261
                  END IF
                  IF not cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC29 + " " + sr.OCC292 + " " + sr.OCC261
                  END IF
               END IF
            END IF
            LET l_str = Null
            IF tm.t[1] = 'Y' THEN
               CASE tm.s[1]
                  WHEN '1' LET l_str = sr.oma03
                  WHEN '2' LET l_str = sr.oma032
                 #WHEN '3' LET l_str = sr.oma23 #FUN-D30070 幣別已有固定群組
                  WHEN '4' LET l_str = sr.oma01
                  WHEN '5' LET l_str = sr.oma00
                  WHEN '6' LET l_str = sr.oma15
                  WHEN '7' LET l_str = sr.oma14
               END CASE
            END IF
            IF tm.t[2] = 'Y' THEN
               CASE tm.s[2]
                  WHEN '1' LET l_str = l_str,sr.oma03
                  WHEN '2' LET l_str = l_str,sr.oma032
                 #WHEN '3' LET l_str = l_str,sr.oma23 #FUN-D30070 幣別已有固定群組
                  WHEN '4' LET l_str = l_str,sr.oma01
                  WHEN '5' LET l_str = l_str,sr.oma00
                  WHEN '6' LET l_str = l_str,sr.oma15
                  WHEN '7' LET l_str = l_str,sr.oma14
               END CASE
            END IF
            IF tm.t[3] = 'Y' THEN
               CASE tm.s[3]
                  WHEN '1' LET l_str = l_str,sr.oma03
                  WHEN '2' LET l_str = l_str,sr.oma032
             #    WHEN '3' LET l_str = l_str,sr.oma23  #FUN-D30070 幣別已有固定群組
                  WHEN '4' LET l_str = l_str,sr.oma01
                  WHEN '5' LET l_str = l_str,sr.oma00
                  WHEN '6' LET l_str = l_str,sr.oma15
                  WHEN '7' LET l_str = l_str,sr.oma14
               END CASE
            END IF
            LET l_str = l_str,sr.oma23
           #No.FUN-
            EXECUTE insert_prep USING
               sr.oma03 ,sr.oma032,sr.oma044 ,sr.occ231 ,sr.occ232  ,   #CHI-B50043 add occ232
               sr.occ233,sr.occ234,sr.occ235 ,sr.occ29  ,sr.occ261  ,   #CHI-B50043 add occ233~occ235
               sr.occ292,sr.oma02 ,sr.oma00  ,sr.oma01  ,sr.oma11   ,
               sr.oma15 ,sr.oma14 ,sr.gem02  ,sr.gen02  ,sr.oma23   ,
               sr.oma24 ,sr.oma54t,sr.balance,sr.oma56t ,sr.balance2,
               sr.oox10 ,sr.oma10 ,sr.oma67  ,sr.azi03  ,sr.azi04   ,
               sr.azi05 ,sr.azi07 ,l_occ29_occ261_occ292,l_str      ,tm.deadline    #No.FUN-
         END IF
         #-----END MOD-810074-----
 
         LET l_flag = 'Y'
         #No.FUN-5B0139 --start--
         #發票待扺資料分配項次
         LET l1_omb03 = l_omb03
         LET l_omb03 = sr2.omb03
         IF sr2.omb03 = g_aza.aza34 THEN
            LET sr2.omb03 = l1_omb03 + 1
            LET l_omb03 = sr2.omb03
         END IF
         #No.FUN-5B0139 --end--
         #-----MOD-7C0041---------
         LET l_ima021 = ''
         SELECT ima021 INTO l_ima021 FROM ima_file
           WHERE ima01=sr2.omb04
         #-----END MOD-7C0041-----
 
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         #-----MOD-810074--------- 
         #EXECUTE insert_prep USING
         #   sr.oma03   ,sr.oma032,sr.oma044,sr.occ231 ,sr.occ29 ,
         #   sr.occ261  ,sr.occ292,sr.oma02 ,sr.oma00  ,sr.oma01 ,
         #   sr.oma11   ,sr.oma15 ,sr.oma14 ,sr.gem02  ,sr.gen02 ,
         #   sr.oma23   ,sr.oma24 ,sr.oma54t,sr.balance,sr.oma56t,
         #   sr.balance2,sr.oox10 ,sr.oma10 ,sr.oma67  ,sr2.omb03,
         #   sr2.omb31  ,sr2.omb04,sr2.omb05,sr2.omb12 ,sr2.omb13,
         #   #sr2.omb14t ,sr2.omb06,sr.azi03 ,sr.azi04  ,sr.azi05 ,   #MOD-7C0041
         #   sr2.omb14t ,sr2.omb06,l_ima021,sr.azi03 ,sr.azi04  ,sr.azi05 ,   #MOD-7C0041
         #   sr.azi07
 
         IF g_oma00 MATCHES '2*' THEN
            LET sr2.omb13 = -sr2.omb13
            LET sr2.omb14t = -sr2.omb14t
         END IF
 
         EXECUTE insert_prep2 USING
             sr.oma01 ,sr2.omb03 ,sr2.omb31 ,sr2.omb04 ,sr2.omb05 ,
             sr2.omb12 ,sr2.omb13 ,sr2.omb14t ,sr2.omb06 ,l_ima021,
             sr.azi03 ,sr.azi04 ,sr.azi05 ,sr.azi07
         #-----END MOD-810074----- 
         #------------------------------ CR (3) ------------------------------#
      END FOREACH
 
      IF l_flag='N' THEN
         INITIALIZE sr2.* TO NULL
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         #-----MOD-810074---------
         #EXECUTE insert_prep USING
         #   sr.oma03   ,sr.oma032,sr.oma044,sr.occ231 ,sr.occ29 ,
         #   sr.occ261  ,sr.occ292,sr.oma02 ,sr.oma00  ,sr.oma01 ,
         #   sr.oma11   ,sr.oma15 ,sr.oma14 ,sr.gem02  ,sr.gen02 ,
         #   sr.oma23   ,sr.oma24 ,sr.oma54t,sr.balance,sr.oma56t,
         #   sr.balance2,sr.oox10 ,sr.oma10 ,sr.oma67  ,sr2.omb03,
         #   sr2.omb31  ,sr2.omb04,sr2.omb05,sr2.omb12 ,sr2.omb13,
         #   #sr2.omb14t ,sr2.omb06,sr.azi03 ,sr.azi04  ,sr.azi05 ,   #MOD-7C0041
         #   sr2.omb14t ,sr2.omb06,'',sr.azi03 ,sr.azi04  ,sr.azi05 ,   #MOD-7C0041
         #   sr.azi07
           #No.FUN-
            IF cl_null(sr.OCC29) AND cl_null(sr.OCC261) AND cl_null(sr.OCC292) THEN
               LET l_occ29_occ261_occ292 = ""
            ELSE
               IF cl_null(sr.OCC29) THEN
                  IF cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC292
                  END IF
                  IF not cl_null(sr.OCC261) AND cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC261
                  END IF
                  IF not cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 =sr.OCC292 + " " + sr.OCC261
                  END IF
               ELSE
                  IF cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC29 + " " + sr.OCC292
                  END IF
                  IF not cl_null(sr.OCC261) AND cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC29 + " " + sr.OCC261
                  END IF
                  IF not cl_null(sr.OCC261) AND not cl_null(sr.OCC292) THEN
                     LET l_occ29_occ261_occ292 = sr.OCC29 + " " + sr.OCC292 + " " + sr.OCC261
                  END IF
               END IF
            END IF
            LET l_str = Null
            IF tm.t[1] = 'Y' THEN
               CASE tm.s[1]
                  WHEN '1' LET l_str = sr.oma03
                  WHEN '2' LET l_str = sr.oma032
                  WHEN '3' LET l_str = sr.oma23
                  WHEN '4' LET l_str = sr.oma01
                  WHEN '5' LET l_str = sr.oma00
                  WHEN '6' LET l_str = sr.oma15
                  WHEN '7' LET l_str = sr.oma14
               END CASE
            END IF
            IF tm.t[2] = 'Y' THEN
               CASE tm.s[2]
                  WHEN '1' LET l_str = l_str,sr.oma03
                  WHEN '2' LET l_str = l_str,sr.oma032
                  WHEN '3' LET l_str = l_str,sr.oma23
                  WHEN '4' LET l_str = l_str,sr.oma01
                  WHEN '5' LET l_str = l_str,sr.oma00
                  WHEN '6' LET l_str = l_str,sr.oma15
                  WHEN '7' LET l_str = l_str,sr.oma14
               END CASE
            END IF
            IF tm.t[3] = 'Y' THEN
               CASE tm.s[3]
                  WHEN '1' LET l_str = l_str,sr.oma03
                  WHEN '2' LET l_str = l_str,sr.oma032
                  WHEN '3' LET l_str = l_str,sr.oma23
                  WHEN '4' LET l_str = l_str,sr.oma01
                  WHEN '5' LET l_str = l_str,sr.oma00
                  WHEN '6' LET l_str = l_str,sr.oma15
                  WHEN '7' LET l_str = l_str,sr.oma14
               END CASE
            END IF
            LET l_str = l_str,sr.oma23
           #No.FUN-
         EXECUTE insert_prep USING
            sr.oma03 ,sr.oma032,sr.oma044 ,sr.occ231 ,sr.occ232  ,   #CHI-B50043 add occ232
            sr.occ233,sr.occ234,sr.occ235 ,sr.occ29  ,sr.occ261  ,   #CHI-B50043 add occ233~occ235
            sr.occ292,sr.oma02 ,sr.oma00  ,sr.oma01  ,sr.oma11   ,
            sr.oma15 ,sr.oma14 ,sr.gem02  ,sr.gen02  ,sr.oma23   ,
            sr.oma24 ,sr.oma54t,sr.balance,sr.oma56t ,sr.balance2,
            sr.oox10 ,sr.oma10 ,sr.oma67  ,sr.azi03  ,sr.azi04   ,
            sr.azi05 ,sr.azi07 ,l_occ29_occ261_occ292,l_str      ,tm.deadline    #No.FUN-
         #-----END MOD-810074----- 
         #------------------------------ CR (3) ------------------------------#
      END IF
      #end FUN-710080 add
 
   END FOREACH
 
### ******** Word Process Console 2002/07/31 ******** ###
  #str FUN-710080 mark
  #IF tm.x='N' then
  #   FINISH REPORT axrx330_rep1
  #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #ELSE
  #   FINISH REPORT axrx330_rep2
  #   LET l_sql = "p000 ",l_name CLIPPED," f"
  #   RUN l_sql
  #END IF
  #end FUN-710080 mark
## ************************************************* ###
 
   #str FUN-710080 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   #-----MOD-810074---------
   #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###XtraGrid###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
###XtraGrid###              #" ORDER BY oma03,oma032 nulls first,oma02 |",  #FUN-C30037 add  ORDER BY 'oma03,oma032 nulls first,oma02' #TQC-CA0058 mark
###XtraGrid###               " ORDER BY oma032 nulls first,oma02 |",  #TQC-CA0058 add
###XtraGrid###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
   #-----END MOD-810074-----
   #傳per檔的排序、跳頁、小計、帳款截止日等參數
   LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
              #tm.t,";",tm.u,";",tm.deadline,";",tm.n,";",tm.y,";",  #FUN-D30070 mark
               tm.t,";",tm.deadline,";",tm.n,";",tm.y,";",  #FUN-D30070 add
               t_azi05,";",g_azi07
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma032,oma03,oma23,oma01,oma00,oma15,oma14') #TQC-CA0058 add oma032
           RETURNING tm.wc
###XtraGrid###      LET g_str = g_str ,";",tm.wc
   END IF
 
   IF tm.y = 'Y' THEN
###XtraGrid###      CALL cl_prt_cs3('axrx330','axrx330_1',l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    CALL cl_xg_view()    ###XtraGrid###
   ELSE
 
###XtraGrid###      CALL cl_prt_cs3('axrx330','axrx330_2',l_sql,g_str)
    LET g_xgrid.table = l_table,"|",l_table2
    CALL cl_get_order_field(tm.s,"oma03,oma032,oma23,oma01,oma00_d,oma15,oma14") RETURNING g_xgrid.order_field
    LET g_xgrid.skippage_field = "keyfd"
    CALL cl_xg_view()    ###XtraGrid###
   END IF
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
 
FUNCTION axmx330_getdesc(l_oma00)
   DEFINE l_oma00      LIKE oma_file.oma00,
          l_desc       LIKE type_file.chr4          #No.FUN-680123 VARCHAR(4)
 
   CASE l_oma00
	WHEN '11' LET l_desc=cl_getmsg('axr-231',g_lang)
	WHEN '12' LET l_desc=cl_getmsg('axr-232',g_lang)
	WHEN '13' LET l_desc=cl_getmsg('axr-233',g_lang)
	WHEN '14' LET l_desc=cl_getmsg('axr-234',g_lang)
	WHEN '21' LET l_desc=cl_getmsg('axr-257',g_lang)
	WHEN '22' LET l_desc=cl_getmsg('axr-253',g_lang)
	WHEN '23' LET l_desc=cl_getmsg('axr-237',g_lang)
	WHEN '24' LET l_desc=cl_getmsg('axr-238',g_lang)
   END CASE
   RETURN l_desc
 
END FUNCTION
 
{
REPORT axrx330_rep1(sr)
   DEFINE 
           l_last_sw       LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1)
           l_curr          LIKE azi_file.azi01,        #No.FUN-680123 VARCHAR(4)
           sr   RECORD
		 order1    LIKE type_file.chr20,       #No.FUN-680123 VARCHAR(20)
		 order2    LIKE type_file.chr20,       #No.FUN-680123 VARCHAR(20)
                 order3    LIKE type_file.chr20,       #No.FUN-680123 VARCHAR(20)
	         oma03     LIKE oma_file.oma03,
                 oma032    LIKE oma_file.oma032,
                 oma044    LIKE oma_file.oma044,
	         occ231    LIKE occ_file.occ231,
                 occ29     LIKE occ_file.occ29,
                 occ261    LIKE occ_file.occ261,
                 occ292    LIKE occ_file.occ292,
	         oma02     LIKE oma_file.oma02,
                 oma00     LIKE oma_file.oma00,        #No.FUN-680123 VARCHAR(4)
                 oma01     LIKE oma_file.oma01,
	         oma11     LIKE oma_file.oma11,
	         oma15     LIKE oma_file.oma15,
	         oma14     LIKE oma_file.oma14,
                 gem02     LIKE gem_file.gem02,
                 gen02     LIKE gen_file.gen02,
                 oma23     LIKE oma_file.oma23,
                 oma24     LIKE oma_file.oma24,
                 oma54t    LIKE oma_file.oma54t,
                 balance   LIKE oma_file.oma54,
	         oma56t    LIKE oma_file.oma54t,
	         balance2  LIKE oma_file.oma54,
                 oox10     LIKE oox_file.oox10,       #bug no:A057
 	         oma10     LIKE oma_file.oma10,	      #MOD-540183
                 oma67     LIKE oma_file.oma67,       #FUN-5C0014
	         azi03     LIKE azi_file.azi03,
	         azi04     LIKE azi_file.azi04,
	         azi05     LIKE azi_file.azi05,
	         azi07     LIKE azi_file.azi07
                END RECORD,
          sr2   RECORD
                 omb03     LIKE omb_file.omb03,
                 omb31     LIKE omb_file.omb31,
                 omb04     LIKE omb_file.omb04,
                 omb05     LIKE omb_file.omb05,
                 omb12     LIKE omb_file.omb12,
                 omb13     LIKE omb_file.omb13,
                 omb14t    LIKE omb_file.omb14t,
                 omb06     LIKE omb_file.omb06
                END RECORD,
          l_flag           LIKE type_file.chr1,               #No.FUN-680123 VARCHAR(01)
	  l_oma54t         LIKE oma_file.oma54t,
	  l_balance 	   LIKE oma_file.oma54t,
	  l_amt1	   LIKE oma_file.oma54,
	  l_amt2	   LIKE oma_file.oma54x,
	  l_amt3	   LIKE oma_file.oma61,   #bug no:A057
	  l_buf	           LIKE type_file.chr1000,#No.FUN-680123 VARCHAR(10)
          l_time	   LIKE type_file.chr8,	           
          l_str            LIKE type_file.chr1000 # Temp String #No.FUN-680123 VARCHAR(100)
   DEFINE l_sql            LIKE type_file.chr1000,#No.FUN-5B0139 #No.FUN-680123 VARCHAR(400)
          l_omb03          LIKE omb_file.omb03,   #No.FUN-5B0139 記錄帳款單身項次
          l1_omb03         LIKE omb_file.omb03    #No.FUN-5B0139 記錄帳款單身項次
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
 
  FORMAT
   PAGE HEADER
	  LET l_flag = 'N'
#No.FUN-590110 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[30] CLIPPED;
      FOR i=1 TO 3
       CASE tm.s[i,i]
               WHEN '1' PRINT g_x[24] CLIPPED,' ';
               WHEN '2' PRINT g_x[25] CLIPPED,' ';
               WHEN '3' PRINT g_x[26] CLIPPED,' ';
               WHEN '4' PRINT g_x[27] CLIPPED,' ';
               WHEN '5' PRINT g_x[28] CLIPPED,' ';
               WHEN '6' PRINT g_x[29] CLIPPED,' ';
               OTHERWISE PRINT '';
       END CASE
      END FOR
      PRINT
#No.FUN-590110 --end--
      IF cl_null(sr.oma044) THEN LET sr.oma044=sr.occ231 END IF
      LET l_time = TIME
      PRINT COLUMN 01,g_x[11] CLIPPED,'(',sr.oma03 CLIPPED,')',
			   sr.oma032 CLIPPED
      PRINT COLUMN 01,g_x[12] CLIPPED,sr.oma044 CLIPPED
      PRINT COLUMN 01,g_x[14] CLIPPED,sr.occ29 CLIPPED,' ',
           sr.occ261 CLIPPED,' ',sr.occ292 CLIPPED
      PRINT g_x[13] CLIPPED,tm.deadline
       PRINT g_dash[1,g_len]
#No.FUN-590110 --start--
      PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],
            g_x[50],g_x[51],g_x[60],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],g_x[59] #FUN-5C0015 add g_x[60]
      PRINT g_dash1
#No.FUN-590110 --end--
      LET l_last_sw = 'n'       #FUN-550111
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y'
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
#No.FUN-590110 --start--
         PRINT COLUMN g_c[41],sr.oma02,
               COLUMN g_c[42],sr.oma00,
               COLUMN g_c[43],sr.oma01,
        #No.FUN-550071 --start--
               COLUMN g_c[44],sr.oma11,
               COLUMN g_c[45],sr.gem02 CLIPPED,
               COLUMN g_c[46],sr.gen02 CLIPPED,
               COLUMN g_c[47],sr.oma23,
               COLUMN g_c[48],cl_numfor(sr.oma54t,18,sr.azi04),
        #No.FUN-550071 --end--
           #MOD-490424
               COLUMN g_c[49],cl_numfor(sr.oox10,10,sr.azi07),    #No.FUN-550071
               COLUMN g_c[50],cl_numfor(sr.balance,18,sr.azi04),
               COLUMN g_c[51],sr.oma10,
               COLUMN g_c[60],sr.oma67; #FUN-5C0014
               
          #--
           #MOD-540183
          #--
 
          LET l_omb03 = 0     #No.FUN-5B0139 Default項次初值
          LET l1_omb03 = 0    #No.FUN-5B0139 Default項次初值
          #No.FUN-5B0139 --start--
	  LET l_sql = "SELECT omb03,omb31,omb04,omb05,omb12,omb13,omb14t,omb06 ",
	              "  FROM omb_file ",
		      " WHERE omb01 = '",sr.oma01,"' "
          #只有大陸功能才有發票待扺
          IF g_aza.aza26 = '2' THEN
             LET l_sql = l_sql CLIPPED,
                         " UNION ",
	                #"SELECT ",g_aza.aza34," omb03,omb31,omb04,omb05,-omb12,omb13,-omb14t,omb06 ",  #MOD-C50056 mark
                         "SELECT omb03,omb31,omb04,omb05,-omb12,omb13,-omb14t,omb06 ",                  #MOD-C50056
                         "  FROM omb_file ",
                         " WHERE omb01 IN (SELECT DISTINCT oot01 ",
                         "  FROM oot_file ",
                         " WHERE oot03 = '",sr.oma01,"') "
          END IF
          PREPARE x330_prepare2 FROM l_sql
          IF SQLCA.sqlcode THEN
              CALL cl_err('x330_prepare2:',SQLCA.sqlcode,1) RETURN
          END IF
          DECLARE axrx330_cur2 CURSOR FOR x330_prepare2
          #No.FUN-5B0139 --end--
          FOREACH axrx330_cur2 INTO sr2.*
             #No.FUN-5B0139 --start--
             #發票待扺資料分配項次
             LET l1_omb03 = l_omb03
             LET l_omb03 = sr2.omb03
             IF sr2.omb03 = g_aza.aza34 THEN
                LET sr2.omb03 = l1_omb03 + 1
                LET l_omb03 = sr2.omb03
             END IF
             #No.FUN-5B0139 --end--
      			PRINT COLUMN g_c[52],sr2.omb03 USING '###&', #No.FUN-570177
                              COLUMN g_c[53],sr2.omb31,
                   #No.FUN-550071 --start--
                              COLUMN g_c[54],sr2.omb04 CLIPPED,
	                      COLUMN g_c[55],sr2.omb06,
                              COLUMN g_c[56],sr2.omb05 CLIPPED,
                              COLUMN g_c[57],cl_numfor(sr2.omb12,57,3),
                              COLUMN g_c[58],cl_numfor(sr2.omb13,58,sr.azi03),
                              COLUMN g_c[59],cl_numfor(sr2.omb14t,59,sr.azi04)
#No.FUN-590110 --end--
                   #No.FUN-550071 --end--
            	END FOREACH
	#	PRINT ''	

   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
	 CASE tm.s[1,1]
			WHEN '1' LET l_buf= g_x[24] CLIPPED
			WHEN '2' LET l_buf= g_x[25] CLIPPED
			WHEN '3' LET l_buf= g_x[26] CLIPPED
			WHEN '4' LET l_buf= g_x[27] CLIPPED
			WHEN '5' LET l_buf= g_x[28] CLIPPED
			WHEN '6' LET l_buf= g_x[29] CLIPPED
		 END CASE
       #no.5196
       #modi by kitty bug no:A057
       IF tm.y='Y' THEN
#No.FUN-590110 --start--
         PRINT COLUMN g_c[46],g_dash2[1,g_w[46]+1+g_w[47]+1+g_w[48]+1+g_w[49]+1+g_w[50]]
       ELSE
         PRINT COLUMN g_c[46],g_dash2[1,g_w[46]+1+g_w[47]+1+g_w[48]+1+g_w[50]]
       END IF
         FOREACH curr_temp1 USING sr.order1
                             INTO l_curr,l_amt1,l_amt2,l_amt3
             SELECT azi05 into t_azi05    #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
         PRINT COLUMN g_c[46],l_curr CLIPPED,g_x[23] CLIPPED,
               COLUMN g_c[48], cl_numfor(l_amt1,48,t_azi05);
         #--modi by kitty Bug NO:A057
         IF tm.y='Y' THEN
               PRINT COLUMN g_c[49], cl_numfor(l_amt3,49,g_azi07),
                     COLUMN g_c[50],cl_numfor(l_amt2,50,t_azi05)     #No.CHI-6A0004 
         ELSE  
               PRINT COLUMN g_c[50], cl_numfor(l_amt2,50,t_azi05)    #No.CHI-6A0004  
         END IF
         END FOREACH
         PRINT ''
      END IF
      #no.5196(end)
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
		 CASE tm.s[2,2]
			WHEN '1' LET l_buf= g_x[24] CLIPPED
			WHEN '2' LET l_buf= g_x[25] CLIPPED
			WHEN '3' LET l_buf= g_x[26] CLIPPED
			WHEN '4' LET l_buf= g_x[27] CLIPPED
			WHEN '5' LET l_buf= g_x[28] CLIPPED
			WHEN '6' LET l_buf= g_x[29] CLIPPED
		 END CASE
       #no.5196
         FOREACH curr_temp2 USING sr.order1,sr.order2
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05     #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
           PRINT COLUMN g_c[46], l_curr CLIPPED,g_x[23] CLIPPED,
                 COLUMN g_c[48], cl_numfor(l_amt1,48,t_azi05);       #No.CHI-6A0004 
         #--modi by kitty Bug NO:A057
         IF tm.y='Y' THEN
               PRINT COLUMN g_c[49], cl_numfor(l_amt3,49,g_azi07),
                     COLUMN g_c[50],cl_numfor(l_amt2,50,t_azi05)     #No.CHI-6A0004
         ELSE
               PRINT COLUMN g_c[50], cl_numfor(l_amt2,18,t_azi05)    #No.CHI-6A0004 
         END IF
 
         END FOREACH
         PRINT ''
      END IF
      #no.5196(end)
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
		 CASE tm.s[3,3]
			WHEN '1' LET l_buf= g_x[24] CLIPPED
			WHEN '2' LET l_buf= g_x[25] CLIPPED
			WHEN '3' LET l_buf= g_x[26] CLIPPED
			WHEN '4' LET l_buf= g_x[27] CLIPPED
			WHEN '5' LET l_buf= g_x[28] CLIPPED
			WHEN '6' LET l_buf= g_x[29] CLIPPED
		 END CASE
       #no.5196
         FOREACH curr_temp3 USING sr.order1,sr.order2,sr.order3
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05       #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
         PRINT COLUMN g_c[46], l_curr CLIPPED,g_x[23] CLIPPED,
               COLUMN g_c[48], cl_numfor(l_amt1,48,t_azi05);        #No.CHI-6A0004 
         #--modi by kitty Bug NO:A057
         IF tm.y='Y' THEN
               PRINT COLUMN g_c[49], cl_numfor(l_amt3,49,g_azi07),  
                     COLUMN g_c[50],cl_numfor(l_amt2,50,t_azi05)    #No.CHI-6A0004
         ELSE
               PRINT COLUMN g_c[50], cl_numfor(l_amt2,50,t_azi05)   #No.CHI-6A0004 
         END IF
#No.FUN-590110 --end--
         END FOREACH
         PRINT ''
      END IF
      #no.5196(end)
 
## FUN-550111
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
#               PRINT '(axrx330)'   #No.TQC-6B0051
         PRINT g_dash[1,g_len]
       #  PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
      IF l_last_sw = 'n' THEN
         PRINT g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED  #No.TQC-6B0051
         IF g_memo_pagetrailer THEN
             PRINT g_x[4]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED  #No.TQC-6B0051
             PRINT g_x[4]
             PRINT g_memo
      END IF
## END FUN-550111
END REPORT
 
REPORT axrx330_rep2(sr)
   DEFINE 
          l_last_sw       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)  
          l_curr          LIKE azi_file.azi01,          #No.FUN-680123 VARCHAR(4) 
          l_cmd           LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          sr              RECORD
          order1          LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20)
          order2          LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20)
          order3          LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20)
          oma03           LIKE oma_file.oma03,
          oma032          LIKE oma_file.oma032,
          oma044          LIKE oma_file.oma044,
          occ231          LIKE occ_file.occ231,
          occ29           LIKE occ_file.occ29,
          occ261          LIKE occ_file.occ261,
          occ292          LIKE occ_file.occ292,
          oma02           LIKE oma_file.oma02,
          oma00           LIKE oma_file.oma00,           #No.FUN-680123 VARCHAR(4)
          oma01           LIKE oma_file.oma01,
          oma11           LIKE oma_file.oma11,
          oma15           LIKE oma_file.oma15,
          oma14           LIKE oma_file.oma14,
          gem02           LIKE gem_file.gem02,
          gen02           LIKE gen_file.gen02,
          oma23           LIKE oma_file.oma23,
          oma24           LIKE oma_file.oma24,
          oma54t          LIKE oma_file.oma54t,
          balance         LIKE oma_file.oma54,
          oma56t          LIKE oma_file.oma56t,
          balance2        LIKE oma_file.oma54,
          oox10           LIKE oox_file.oox10,     #bug no:A057
          oma10           LIKE oma_file.oma10,	   #MOD-540183\
          oma67           LIKE oma_file.oma67,     #FUN-5C0014
          azi03	          LIKE azi_file.azi03,
          azi04	          LIKE azi_file.azi04,
          azi05	          LIKE azi_file.azi05,
          azi07	          LIKE azi_file.azi07
                    END RECORD,
          sr2       RECORD
          omb03           LIKE omb_file.omb03,
          omb31           LIKE omb_file.omb31,
          omb04           LIKE omb_file.omb04,
          omb05           LIKE omb_file.omb05,
          omb12           LIKE omb_file.omb12,
          omb13           LIKE omb_file.omb13,
          omb14t          LIKE omb_file.omb14t,
          omb06           LIKE omb_file.omb06
             END RECORD,
          l_oma54t        LIKE oma_file.oma54t,
          l_balance       LIKE oma_file.oma54t,
          l_amt1          LIKE oma_file.oma54,
          l_amt2          LIKE oma_file.oma54x,
          l_amt3          LIKE oma_file.oma61,          #bug no:A057
          l_buf           LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(10)
          l_time          LIKE type_file.chr8,  
          l_str           LIKE type_file.chr1000        # Temp String #No.FUN-680123 VARCHAR(150)
   DEFINE l_channel       base.Channel
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.order2,sr.order3
 
  FORMAT
   PAGE HEADER
	  IF cl_null(sr.oma044) THEN LET sr.oma044=sr.occ231 END IF
	  LET l_time = TIME
 
### ******** Word Process Console 2002/07/31 ******** ###
       IF headtag='0' AND tm.x='Y' THEN
          LET l_cmd = 'cat /dev/null>',xml_name CLIPPED   #TQC-630006 #MOD-650098
#         LET l_cmd = 'echo -n "">',xml_name CLIPPED      #TQC-630185 #MOD-650098
 
          LET l_channel = base.Channel.create()
          CALL l_channel.openFile( xml_name CLIPPED, "a" )
          CALL l_channel.setDelimiter("")
 
          CALL l_channel.write( "<?xml version=""1.0"" encoding=""BIG5""?>" )
          CALL l_channel.write( "<!DOCTYPE wordProcess SYSTEM ""wordProcess.dtd"">" )
          CALL l_channel.write( "<wordProcess reportName=""axrx330"">" )
          CALL l_channel.write( "		<page pageNo=""1"">" )
          CALL l_channel.write( "			<!--*******************單頭 ***************** -->" )
          CALL l_channel.write( "			<Header PrintPerPage=""true"">")
          CALL l_channel.write( "				<dynamicText>")
          Let l_str ='					<text id="_中文公司名_" value="',g_company CLIPPED,'" keywordType="WordHeader"/>'
          CALL l_channel.write( l_str CLIPPED)
          LET l_str ='					<text id="客戶" value="','(',sr.oma03 CLIPPED,')',sr.oma032 CLIPPED,'" keywordType="Bookmark"/>'
          CALL l_channel.write( l_str)
          LET l_str = '					<text id="帳款截止" value="',tm.deadline,'" keywordType="Bookmark"/>'
          CALL l_channel.write( l_str)
          LET l_str = '					<text id="地址" value="',sr.oma044 CLIPPED,'" keywordType="Bookmark"/>'
          CALL l_channel.write( l_str)
          LET l_str = ''
	      FOR i=1 TO 3
                 CASE tm.s[i,i]
                      WHEN '1' IF headtag='0' THEN LET l_str = l_str CLIPPED,g_x[24],' ' END IF
                      WHEN '2' IF headtag='0' THEN LET l_str = l_str CLIPPED,g_x[25],' ' END IF
                      WHEN '3' IF headtag='0' THEN LET l_str = l_str CLIPPED,g_x[26],' ' END IF
                      WHEN '4' IF headtag='0' THEN LET l_str = l_str CLIPPED,g_x[27],' ' END IF
                      WHEN '5' IF headtag='0' THEN LET l_str = l_str CLIPPED,g_x[28],' ' END IF
                      WHEN '6' IF headtag='0' THEN LET l_str = l_str CLIPPED,g_x[29],' ' END IF
                 END CASE
              END FOR
          LET l_str = '					<text id="排列順序" value="',l_str CLIPPED,'" keywordType="Bookmark"/>'
          CALL l_channel.write( l_str)
          LET l_str = '					<text id="聯絡" value="',sr.occ29 CLIPPED,' ',sr.occ261 CLIPPED,' ',sr.occ292 CLIPPED,'" keywordType="Bookmark"/>'
          CALL l_channel.write( l_str)
          LET l_str = '					<text id="製表日期" value="',g_pdate,' ',l_time[1,5],' ','" keywordType="Bookmark"/>'
          CALL l_channel.write( l_str)
          CALL l_channel.write( "				</dynamicText>")
          CALL l_channel.write( "			</Header>")
          CALL l_channel.write( "			<!--*******************單身 ***************** -->" )
          CALL l_channel.write( "			<Detail>" )
          CALL l_channel.write( ' 				<Table StartPoint="StartOfTable1">')
          LET headtag = '1'
       END IF
### ************************************************* ###
 
   ON EVERY ROW
      IF tm.y='Y' THEN LET sr.azi04=t_azi04 LET sr.azi05=t_azi05 END IF
 
### ******** Word Process Console 2002/07/31 ******** ###
      IF tm.x = 'Y' THEN
         CALL l_channel.write( "				<tr>")
         LET l_str = '						<td value="',sr.oma02,'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',sr.oma00,'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',sr.oma01,'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',sr.oma11,'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',sr.gem02,'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',sr.gen02,'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',sr.oma23,'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',cl_numfor(sr.oma54t,15,sr.azi04),'"/>'
         CALL l_channel.write(l_str)
         LET l_str = '						<td value="',cl_numfor(sr.balance,15,sr.azi04),'"/>'
         CALL l_channel.write(l_str)
         CALL l_channel.write( "				</tr>")
      END IF
### ************************************************* ###
		
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
		 CASE tm.s[1,1]
			WHEN '1' LET l_buf= g_x[24] CLIPPED
			WHEN '2' LET l_buf= g_x[25] CLIPPED
			WHEN '3' LET l_buf= g_x[26] CLIPPED
			WHEN '4' LET l_buf= g_x[27] CLIPPED
			WHEN '5' LET l_buf= g_x[28] CLIPPED
			WHEN '6' LET l_buf= g_x[29] CLIPPED
		 END CASE
       #no.5196
         FOREACH curr_temp1 USING sr.order1
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05    #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
### ******** Word Process Console 2002/07/31 ******** ###
           CALL l_channel.write( "				<tr>")
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',l_curr CLIPPED,'"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',g_x[23] CLIPPED,'"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',cl_numfor(l_amt1,15,t_azi05),'"/>'     #No.CHI-6A0004
           CALL l_channel.write(l_str)
       #modi by kitty bug no:A057
        IF tm.y='Y' THEN
           LET l_str = '						<td value="',cl_numfor(l_amt3,15,t_azi05),'"/>'     #No.CHI-6A0004 
           CALL l_channel.write(l_str)
        END IF
           LET l_str = '						<td value="',cl_numfor(l_amt2,15,t_azi05),'"/>'     #No.CHI-6A0004 
           CALL l_channel.write(l_str)
 
           CALL l_channel.write( "				</tr>")
### ************************************************* ###
         END FOREACH
      END IF
      #no.5196(end)
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
		 CASE tm.s[2,2]
			WHEN '1' LET l_buf= g_x[24] CLIPPED
			WHEN '2' LET l_buf= g_x[25] CLIPPED
			WHEN '3' LET l_buf= g_x[26] CLIPPED
			WHEN '4' LET l_buf= g_x[27] CLIPPED
			WHEN '5' LET l_buf= g_x[28] CLIPPED
			WHEN '6' LET l_buf= g_x[29] CLIPPED
		 END CASE
       #no.5196
         FOREACH curr_temp2 USING sr.order1,sr.order2
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05     #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
### ******** Word Process Console 2002/07/31 ******** ###
           CALL l_channel.write( "				<tr>")
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',l_curr CLIPPED,'"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',g_x[23] CLIPPED,'"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',cl_numfor(l_amt1,15,t_azi05),'"/>'    #No.CHI-6A0004
           CALL l_channel.write(l_str)
       #modi by kitty bug no:A057
        IF tm.y='Y' THEN
           LET l_str = '						<td value="',cl_numfor(l_amt3,15,t_azi05),'"/>'    #No.CHI-6A0004
           CALL l_channel.write(l_str)
        END IF
           LET l_str = '						<td value="',cl_numfor(l_amt2,15,t_azi05),'"/>'    #No.CHI-6A0004
           CALL l_channel.write(l_str)
           CALL l_channel.write( "				</tr>")
### ************************************************* ###
         END FOREACH
      END IF
      #no.5196(end)
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
		 CASE tm.s[3,3]
			WHEN '1' LET l_buf= g_x[24] CLIPPED
			WHEN '2' LET l_buf= g_x[25] CLIPPED
			WHEN '3' LET l_buf= g_x[26] CLIPPED
			WHEN '4' LET l_buf= g_x[27] CLIPPED
			WHEN '5' LET l_buf= g_x[28] CLIPPED
			WHEN '6' LET l_buf= g_x[29] CLIPPED
		 END CASE
       #no.5196
         PRINT COLUMN 50,"-----------------------------------------"
         FOREACH curr_temp3 USING sr.order1,sr.order2,sr.order3
                             INTO l_curr,l_amt1,l_amt2
             SELECT azi05 into t_azi05    #No.CHI-6A0004
               FROM azi_file
               WHERE azi01=l_curr
 
### ******** Word Process Console 2002/07/31 ******** ###
           CALL l_channel.write( "				<tr>")
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',' ','"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',l_curr CLIPPED,'"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',g_x[23] CLIPPED,'"/>'
           CALL l_channel.write(l_str)
           LET l_str = '						<td value="',cl_numfor(l_amt1,15,t_azi05),'"/>'   #No.CHI-6A0004 
           CALL l_channel.write(l_str)
       #modi by kitty bug no:A057
        IF tm.y='Y' THEN
           LET l_str = '						<td value="',cl_numfor(l_amt3,15,t_azi05),'"/>'   #No.CHI-6A0004
           CALL l_channel.write(l_str)
        END IF
           LET l_str = '						<td value="',cl_numfor(l_amt2,15,t_azi05),'"/>'   #No.CHI-6A0004
           CALL l_channel.write(l_str)
           CALL l_channel.write( "				</tr>")
### ************************************************* ###
         END FOREACH
      END IF
      #no.5196(end)
 
    ON LAST ROW
        CALL l_channel.write( ' 				</Table>')
        CALL l_channel.write( "			</Detail>" )
        CALL l_channel.write( ' 			<Footer PrintPerPage="true">')
        CALL l_channel.write( " 			</Footer>")
        CALL l_channel.write( "	</page>")
        CALL l_channel.write( "</wordProcess>")
        CALL l_channel.close()
 
END REPORT
}
#Patch....NO.TQC-610037 <> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

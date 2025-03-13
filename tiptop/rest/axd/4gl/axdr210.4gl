# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdr210.4gl
# Descriptions...: 集團調撥進度追蹤表
# Date & Author..: 04/01/17 By Carrier
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No:FUN-520024 05/02/24 By Day 修改報表中排序顯示錯誤
# Modify.........: No.FUN-550026 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No:TQC-5B0045 05/11/08 By Smapmin 調整報表
# Modify.........: NO:FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying 欄位形態定義為LIKE
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/10 By xumin報表項次靠右顯示,下一頁改成跳頁
DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD				# Print condition RECORD
              wc   LIKE type_file.chr1000,      # Where Condition    #No.FUN-680108 VARCHAR(500)
              s    LIKE type_file.chr3,         # 排列項目           #No.FUN-680108 VARCHAR(03)  
              t    LIKE type_file.chr3,         # 同項目是否跳頁     #No.FUN-680108 VARCHAR(03)
              a    LIKE type_file.chr1,         # 排列項目           #No.FUN-680108 VARCHAR(01)    
              b    LIKE type_file.chr1,         # 排列項目           #No.FUN-680108 VARCHAR(01)
              more LIKE type_file.chr1          # 特殊列印條件       #No.FUN-680108 VARCHAR(01)
              END RECORD                        # No:FUN-520024
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_head1         STRING  
#DEFINE   g_orderA ARRAY[6] OF VARCHAR(10)
DEFINE   g_orderA ARRAY[6] OF LIKE pmn_file.pmn04  #No.FUN-680108 VARCHAR(40) #No.FUN-550026#FUN-5B0105 16->40 
MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#-------------No:TQC-610088 modify
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No:FUN-570264 ---end---
#-------------No:TQC-610088 end
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
#  IF g_bgjob = ' ' OR g_bgjob = 'N'		# If background job sw is off
   IF cl_null(tm.wc)
      THEN CALL r210_tm(0,0)		# Input print condition
      ELSE CALL r210()			# Read data and create out-file
   END IF
END MAIN

FUNCTION r210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680108 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

       LET p_row = 4 LET p_col = 14

   OPEN WINDOW r210_w AT p_row,p_col
        WITH FORM "axd/42f/axdr210"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s      = '123'
   LET tm.t      = '   '
   LET tm.a      = '3'
   LET tm.b      = 'N'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON pmm01,pmm04,pmn04,pmm12,pmm13,pmn16
             HELP 1

      #No:FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No:FUN-580031 ---end---

      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
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

#No.FUN-570243  --start-
      ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
#No.FUN-570243 --end--

      #No:FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No:FUN-580031 ---end---

 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r210_w
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#  DISPLAY BY NAME tm.s,tm.a,tm.b,tm.more
 

      INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
            tm.b,tm.more
            WITHOUT DEFAULTS HELP 1

         #No:FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No:FUN-580031 ---end---

         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF

         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()
         #UI

      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3

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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

      END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r210_w EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axdr210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr210','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",      #No:TQC-610088 add
                         " '",tm.s     CLIPPED,"'",
                         " '",tm.t     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr210',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r210_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r210()
   ERROR ""
END WHILE
   CLOSE WINDOW r210_w
END FUNCTION

FUNCTION r210()
   DEFINE l_name     LIKE type_file.chr20, # External(Disk) file name     #No.FUN-680108 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0091
          l_i        LIKE type_file.num5,  #                              #No.FUN-680108 SMALLINT
          l_sql      LIKE type_file.chr1000,# RDSQL STATEMENT              #No.FUN-680108 VARCHAR(1000)
          l_za05     LIKE za_file.za05,    # NO.MOD-4B0067
          l_order    ARRAY[3] of LIKE pmn_file.pmn04, #No.FUN-680108  #FUN-5B0105 20->40 VARCHAR(40)
          sr         RECORD
                     order1    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40 #No.FUN-680108 VARCHAR(40)
                     order2    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40 #No.FUN-680108 VARCHAR(40)
                     order3    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40 #No.FUN-680108 VARCHAR(40)
                     pmm09     LIKE pmm_file.pmm09,   #撥出工廠
                     azp02     LIKE azp_file.azp02,   #撥出工廠
                     pmm01     LIKE pmm_file.pmm01,   #採購單號
                     pmm04     LIKE pmm_file.pmm04,   #採購日期
                     pmm12     LIKE pmm_file.pmm12,   #採購員
                     gen02     LIKE gen_file.gen02,   #姓名
                     pmm13     LIKE pmm_file.pmm13,   #採購員
                     pmm25     LIKE pmm_file.pmm25,   #狀況碼
                     pmn02     LIKE pmn_file.pmn02,   #項次
                     pmn04     LIKE pmn_file.pmn04,   #料件編號
                     pmn041    LIKE pmn_file.pmn041,  #品名規格
                     pmn16     LIKE pmn_file.pmn16,   #狀態
                     pmn20     LIKE pmn_file.pmn20,   #採購量
                     pmn33     LIKE pmn_file.pmn33,   #交貨日
                     rvb08     LIKE rvb_file.rvb08,   #收貨數量
                     amount    LIKE rvb_file.rvb08,   #未交量
                     pmn58     LIKE pmn_file.pmn58
                     END RECORD,
          sr1        RECORD
                     order1    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40     #No.FUN-680108 VARCHAR(40)
                     order2    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40     #No.FUN-680108 VARCHAR(40)
                     order3    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40     #No.FUN-680108 VARCHAR(40)
                     pmm09     LIKE pmm_file.pmm09,   #撥出工廠
                     azp02     LIKE azp_file.azp02,   #撥出工廠
                     pmm01     LIKE pmm_file.pmm01,   #採購單號
                     pmm04     LIKE pmm_file.pmm04,   #採購日期
                     pmm12     LIKE pmm_file.pmm12,   #採購員
                     gen02     LIKE gen_file.gen02,   #姓名
                     pmm13     LIKE pmm_file.pmm13,   #採購員
                     pmm25     LIKE pmm_file.pmm25,   #狀況碼
                     pmn02     LIKE pmn_file.pmn02,   #項次
                     pmn04     LIKE pmn_file.pmn04,   #料件編號
                     pmn041    LIKE pmn_file.pmn041,  #品名規格
                     pmn16     LIKE pmn_file.pmn16,   #狀態
                     pmn20     LIKE pmn_file.pmn20,   #採購量
                     pmn33     LIKE pmn_file.pmn33,   #交貨日
                     amount1   LIKE rvb_file.rvb08,   #收貨數量
                     amount2   LIKE rvb_file.rvb08,   #未交量
                     pmn58     LIKE pmn_file.pmn58,
                     rvb01     LIKE rvb_file.rvb01,
                     rvb02     LIKE rvb_file.rvb02,
                     rva06     LIKE rva_file.rva06,
                     rvb08     LIKE rvb_file.rvb08
                     END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   {  FOR g_i = 1 TO 3
        CASE
           WHEN tm.s[g_i,g_i]='1'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[17]
           WHEN tm.s[g_i,g_i]='2'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[18]
           WHEN tm.s[g_i,g_i]='3'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[19]
           WHEN tm.s[g_i,g_i]='4'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[20]
           WHEN tm.s[g_i,g_i]='5'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[21]
           WHEN tm.s[g_i,g_i]='6'  LET g_x[16]=g_x[16] CLIPPED,' ',g_x[28]
        END CASE
     END FOR
   }
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axdr210'
 #NO.MOD-4B0067  --begin
 #NO.MOD-4B0067  --end
     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     END IF

     IF tm.b='N' THEN
        LET l_sql = " SELECT '','','',pmm09,azp02,pmm01,pmm04,pmm12,",
                    "        gen02,pmm13,pmm25,pmn02,pmn04,pmn041,",
                    "        pmn16,pmn20,pmn33,0,0,pmn58",
                    "   FROM pmm_file,pmn_file,OUTER azp_file,",
                    "        OUTER gen_file ",
                    "  WHERE pmm01 = pmn01 ",
                    "    AND pmm12 = gen_file.gen01 AND pmm09 = azp_file.azp01",
                    "    AND pmm02 = 'ICT' ",
                    "    AND ",tm.wc CLIPPED,
                    " ORDER BY pmm09,pmm01,pmn02"
     ELSE
        LET l_sql = " SELECT '','','',pmm09,azp02,pmm01,pmm04,pmm12,",
                    "        gen02,pmm13,pmm25,pmn02,pmn04,pmn041,pmn16,",
                    "        pmn20,pmn33,0,0,pmn58,rvb01,rvb02,rva06,rvb08",
                    "   FROM pmm_file,pmn_file,OUTER azp_file,",
                    "        OUTER gen_file,OUTER (rva_file,rvb_file) ",
                    "  WHERE pmm01 = pmn01 AND pmn01 = rvb_file.rvb04",
                    "    AND pmn02 = rvb_file.rvb03 AND rva_file.rva01 = rvb_file.rvb01",
                    "    AND pmm12 = gen_file.gen01 AND pmm09 = azp_file.azp01",
                    "    AND pmm02 = 'ICT' ",
                    "    AND ",tm.wc CLIPPED,
                    " ORDER BY pmm09,pmm01,pmn02,rvb01,rvb02"
     END IF

     PREPARE r210_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE r210_c1 CURSOR FOR r210_p1

     CALL cl_outnam('axdr210') RETURNING l_name
 #     IF tm.b = 'N' THEN LET g_len = 182 ELSE LET g_len = 205 END IF #MOD-4B0067
#      IF tm.b = 'N' THEN LET g_len = 190 ELSE LET g_len = 219 END IF #MOD-4B0067,#No.FUN-550026   #TQC-5B0045
      IF tm.b = 'N' THEN LET g_len = 198 ELSE LET g_len = 229 END IF #MOD-4B0067,#No.FUN-550026   #TQC-5B0045
     FOR  l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR

     IF tm.b='N' THEN
        START REPORT r210_rep1 TO l_name
        LET g_pageno = 0
        FOREACH r210_c1 INTO sr.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          FOR l_i = 1 TO 3
             CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr.pmm01
                                           LET g_orderA[l_i] = g_x[17]
                  WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr.pmm04
                                           LET g_orderA[l_i] = g_x[18]
                  WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr.pmm12
                                           LET g_orderA[l_i] = g_x[21]
                  WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr.pmm13
                                           LET g_orderA[l_i] = g_x[19]
                  WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr.pmn04
                                           LET g_orderA[l_i] = g_x[20]
                  WHEN tm.s[l_i,l_i] = '6' LET l_order[l_i] = sr.pmn16
                  OTHERWISE LET l_order[l_i] = '-'
             END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          SELECT SUM(rvb08) INTO sr.rvb08
            FROM pmm_file,pmn_file,rva_file,rvb_file
           WHERE pmm01=pmn01    AND pmn01=rvb04
             AND pmn02=rvb03    AND rva01=rvb01
             AND pmm01=sr.pmm01 AND pmn02=sr.pmn02
          IF cl_null(sr1.amount1) THEN LET sr1.amount1=0 END IF
          IF cl_null(sr.pmn20) THEN LET sr.pmn20=0 END IF
          IF cl_null(sr.rvb08) THEN LET sr.rvb08=0 END IF
          LET sr.amount=sr.pmn20-sr.rvb08
          OUTPUT TO REPORT r210_rep1(sr.*)
        END FOREACH
        FINISH REPORT r210_rep1
     ELSE
        START REPORT r210_rep2 TO l_name
        LET g_pageno = 0
        FOREACH r210_c1 INTO sr1.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          FOR l_i = 1 TO 3
             CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr1.pmm01
                                           LET g_orderA[l_i] = g_x[17]
                  WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr1.pmm04
                                           LET g_orderA[l_i] = g_x[18]
                  WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr1.pmm12
                                           LET g_orderA[l_i] = g_x[21]
                  WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr1.pmm13
                                           LET g_orderA[l_i] = g_x[19]
                  WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr1.pmn04
                                           LET g_orderA[l_i] = g_x[20]
                  WHEN tm.s[l_i,l_i] = '6' LET l_order[l_i] = sr1.pmn16
 
                  OTHERWISE LET l_order[l_i] = '-'
             END CASE
          END FOR
          LET sr1.order1 = l_order[1]
          LET sr1.order2 = l_order[2]
          LET sr1.order3 = l_order[3]
          IF cl_null(sr1.pmn20) THEN LET sr1.pmn20=0 END IF
          IF cl_null(sr1.rvb08) THEN LET sr1.rvb08=0 END IF
          SELECT SUM(rvb08) INTO sr1.amount1
            FROM pmm_file,pmn_file,rva_file,rvb_file
           WHERE pmm01=pmn01     AND pmn01=rvb04
             AND pmn02=rvb03     AND rva01=rvb01
             AND pmm01=sr1.pmm01 AND pmn02=sr1.pmn02
        #     AND rva01=sr1.rvb01 AND rvb02=sr1.rvb02
          IF cl_null(sr1.amount1) THEN LET sr1.amount1=0 END IF
          LET sr1.amount2=sr1.pmn20-sr1.amount1
          OUTPUT TO REPORT r210_rep2(sr1.*)
        END FOREACH
        FINISH REPORT r210_rep2
     END IF

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r210_rep1(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
          l_sw          LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
          l_sql         LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(200)
          l_str         LIKE ze_file.ze03,            #No.FUN-680108 VARCHAR(30)
          l_i1,l_i2     LIKE type_file.num5,          #No.FUN-680108 SMALLINT
       sr            RECORD
                        order1    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40   #No.FUN-680108 VARCHAR(40)
                        order2    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40   #No.FUN-680108 VARCHAR(40)
                        order3    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40   #No.FUN-680108 VARCHAR(40)
                        pmm09     LIKE pmm_file.pmm09,   #撥出工廠
                        azp02     LIKE azp_file.azp02,   #撥出工廠
                        pmm01     LIKE pmm_file.pmm01,   #採購單號
                        pmm04     LIKE pmm_file.pmm04,   #採購日期
                        pmm12     LIKE pmm_file.pmm12,   #採購員
                        gen02     LIKE gen_file.gen02,   #姓名
                        pmm13     LIKE pmm_file.pmm13,   #採購員
                        pmm25     LIKE pmm_file.pmm25,   #狀況碼
                        pmn02     LIKE pmn_file.pmn02,   #項次
                        pmn04     LIKE pmn_file.pmn04,   #料件編號
                        pmn041    LIKE pmn_file.pmn041,  #品名規格
                        pmn16     LIKE pmn_file.pmn16,   #狀態
                        pmn20     LIKE pmn_file.pmn20,   #採購量
                        pmn33     LIKE pmn_file.pmn33,   #交貨日
                        rvb08     LIKE rvb_file.rvb08,   #收貨數量
                        amount    LIKE rvb_file.rvb08,   #未交量
                        pmn58     LIKE pmn_file.pmn58
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
         ORDER BY sr.pmm09,sr.order1,sr.order2,sr.order3,sr.pmm01,sr.pmn02
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[24] CLIPPED,sr.pmm09 CLIPPED,' ',sr.azp02
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
#TQC-6A00095--END
      LET g_head1 = g_x[16] CLIPPED, g_orderA[1] CLIPPED, '-',
                    g_orderA[2] CLIPPED, '-', g_orderA[3] CLIPPED
      PRINT COLUMN 1,g_head1
      PRINT g_dash[1,g_len]
 #NO.MOD-4B0067  --begin
   PRINT COLUMN  1,g_x[11] CLIPPED,
#No.FUN-550026 --start--
            COLUMN 36,g_x[12] CLIPPED,
            COLUMN 60,g_x[14] CLIPPED,
            COLUMN 90,g_x[15] CLIPPED,
            COLUMN 143,g_x[25] CLIPPED,   #TQC-5B0045
            COLUMN 171,g_x[13] CLIPPED    #TQC-5B0045
#            COLUMN 133,g_x[25] CLIPPED,   #TQC-5B0045
#            COLUMN 161,g_x[13] CLIPPED    #TQC-5B0045
      PRINT '---------------- -------- -------- -------- ',
#            '-------------- ---- -------------------- ------------------------------ ',   #TQC-5B0045
            '-------------- ---- ------------------------------ ------------------------------ ',   #TQC-5B0045
            '--------------- -------- --------------- ',
            '--------------- ---------------'
#No.FUN-550026 --end--
 #NO.MOD-4B0067  --end
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.pmm09
      SKIP TO TOP OF PAGE

   BEFORE GROUP OF sr.pmm01
 #     LET l_i2=0        #NO.MOD-4B0067

   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF

   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF

   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF

   ON EVERY ROW
 #NO.MOD-4B0067  --begin
#     IF l_i2=0 THEN
         CASE sr.pmm25
              WHEN 'X' CALL cl_getmsg('axd-060',g_lang) RETURNING l_str
              WHEN '0' CALL cl_getmsg('axd-061',g_lang) RETURNING l_str
              WHEN '1' CALL cl_getmsg('axd-062',g_lang) RETURNING l_str
              WHEN '2' CALL cl_getmsg('axd-063',g_lang) RETURNING l_str
              WHEN '6' CALL cl_getmsg('axd-064',g_lang) RETURNING l_str
              WHEN '9' CALL cl_getmsg('axd-065',g_lang) RETURNING l_str
              WHEN 'S' CALL cl_getmsg('axd-066',g_lang) RETURNING l_str
              WHEN 'R' CALL cl_getmsg('axd-067',g_lang) RETURNING l_str
              WHEN 'W' CALL cl_getmsg('axd-068',g_lang) RETURNING l_str
         END CASE
#No.FUN-550026 --start--
         PRINT COLUMN 01,sr.pmm01 CLIPPED,  #TQC-6A0095
               COLUMN 18,sr.pmm04 CLIPPED,  #TQC-6A0095
               COLUMN 27,sr.pmm12 CLIPPED,  #TQC-6A0095
               COLUMN 36,sr.gen02 CLIPPED, #TQC-6A0095
               COLUMN 45,sr.pmm25 CLIPPED,' ',l_str[1,12];  #TQC-6A0095
#     END IF
 #     PRINT COLUMN 60,sr.pmn02 USING "<<<<",
      PRINT COLUMN 60,cl_numfor(sr.pmn02,4,0),  #TQC-6A0095
            COLUMN 65,sr.pmn04 CLIPPED,   #TQC-6A0095
#TQC-5B0045
#           COLUMN 86,sr.pmn041,
#           COLUMN 117,sr.pmn20 USING "----------&.&&&",
#           COLUMN 133,sr.pmn33,
#           COLUMN 142,sr.rvb08 USING "----------&.&&&",
#           COLUMN 158,sr.amount USING "----------&.&&&",
#           COLUMN 174,sr.pmn58 USING "----------&.&&&"
            COLUMN 96,sr.pmn041 CLIPPED,  #TQC-6A0095
            COLUMN 127,sr.pmn20 USING "----------&.&&&",
            COLUMN 143,sr.pmn33 CLIPPED,  #TQC-6A0095
            COLUMN 152,sr.rvb08 USING "----------&.&&&",
            COLUMN 168,sr.amount USING "----------&.&&&",
            COLUMN 184,sr.pmn58 USING "----------&.&&&"
#TQC-5B0045
 #NO.MOD-4B0067  --end
#No.FUN-550026 --end--
   AFTER GROUP OF sr.pmm01
      PRINT

   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT

REPORT r210_rep2(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
          l_sw          LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
          l_sql         LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(200)
          l_str         LIKE ze_file.ze03,            #No.FUN-680108 VARCHAR(30)
          l_i1,l_i2     LIKE type_file.num5,          #No.FUN-680108 SMALLINT
          l_pmn58       LIKE pmn_file.pmn58,
       sr            RECORD
                        order1    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40   #No.FUN-680108 VARCHAR(40)
                        order2    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40   #No.FUN-680108 VARCHAR(40)
                        order3    LIKE pmn_file.pmn04,   #FUN-5B0105 20->40   #No.FUN-680108 VARCHAR(40)
                        pmm09     LIKE pmm_file.pmm09,   #撥出工廠
                        azp02     LIKE azp_file.azp02,   #撥出工廠
                        pmm01     LIKE pmm_file.pmm01,   #採購單號
                        pmm04     LIKE pmm_file.pmm04,   #採購日期
                        pmm12     LIKE pmm_file.pmm12,   #採購員
                        gen02     LIKE gen_file.gen02,   #姓名
                        pmm13     LIKE pmm_file.pmm13,   #採購員
                        pmm25     LIKE pmm_file.pmm25,   #狀況碼
                        pmn02     LIKE pmn_file.pmn02,   #項次
                        pmn04     LIKE pmn_file.pmn04,   #料件編號
                        pmn041    LIKE pmn_file.pmn041,  #品名規格
                        pmn16     LIKE pmn_file.pmn16,   #狀態
                        pmn20     LIKE pmn_file.pmn20,   #採購量
                        pmn33     LIKE pmn_file.pmn33,   #交貨日
                        amount1   LIKE rvb_file.rvb08,   #收貨數量
                        amount2   LIKE rvb_file.rvb08,   #未交量
                        pmn58     LIKE pmn_file.pmn58,
                        rvb01     LIKE rvb_file.rvb01,
                        rvb02     LIKE rvb_file.rvb02,
                        rva06     LIKE rva_file.rva06,
                        rvb08     LIKE rvb_file.rvb08
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
         ORDER BY sr.pmm09,sr.order1,sr.order2,sr.order3,
                  sr.pmm01,sr.pmn02,sr.rvb01,sr.rvb02
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[27]))/2 SPACES,g_x[27]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[24] CLIPPED,sr.pmm09 CLIPPED,' ',sr.azp02
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[27]))/2 SPACES,g_x[27]
      PRINT ' '
#TQC-6A0095--END
      LET g_head1 = g_x[16] CLIPPED, g_orderA[1] CLIPPED, '-',
                    g_orderA[2] CLIPPED, '-', g_orderA[3] CLIPPED
      PRINT COLUMN 1,g_head1
      PRINT g_dash[1,g_len]
 #NO.MOD-4B0067  --begin
   PRINT COLUMN  1,g_x[11] CLIPPED,
#No.FUN-550026 --start--
            COLUMN 36,g_x[12] CLIPPED,
            COLUMN 60,g_x[14] CLIPPED,
            COLUMN 89,g_x[15] CLIPPED,
            COLUMN 133,g_x[10] CLIPPED,
            COLUMN 146,g_x[09] CLIPPED;
      PRINT COLUMN 158,g_x[22] CLIPPED,
            COLUMN 181,g_x[30] CLIPPED,
            COLUMN 206,g_x[26]
      PRINT '---------------- -------- -------- -------- ',
#            '-------------- ---- -------------------- ------------------------------ ',   #TQC-5B0045
            '-------------- ---- ------------------------------ ------------------------------ ',   #TQC-5B0045
            '--------------- -------- ',
            '--------------- ',
            '---------------------- ',
            '-------- -------------- ---------------'
 #NO.MOD-4B0067  --end
#No.FUN-550026 --end--
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF

   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF

   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF

   BEFORE GROUP OF sr.pmm09
      SKIP TO TOP OF PAGE

   BEFORE GROUP OF sr.pmm01
 #NO.MOD-4B0067  --begin
#     LET l_i2=0

   BEFORE GROUP OF sr.pmn02

   ON EVERY ROW
#     IF l_i2=0 THEN
         CASE sr.pmm25
              WHEN 'X' CALL cl_getmsg('axd-060',g_lang) RETURNING l_str
              WHEN '0' CALL cl_getmsg('axd-061',g_lang) RETURNING l_str
              WHEN '1' CALL cl_getmsg('axd-062',g_lang) RETURNING l_str
              WHEN '2' CALL cl_getmsg('axd-063',g_lang) RETURNING l_str
              WHEN '6' CALL cl_getmsg('axd-064',g_lang) RETURNING l_str
              WHEN '9' CALL cl_getmsg('axd-065',g_lang) RETURNING l_str
              WHEN 'S' CALL cl_getmsg('axd-066',g_lang) RETURNING l_str
              WHEN 'R' CALL cl_getmsg('axd-067',g_lang) RETURNING l_str
              WHEN 'W' CALL cl_getmsg('axd-068',g_lang) RETURNING l_str
         END CASE
         PRINT COLUMN 01,sr.pmm01 CLIPPED, #TQC-6A0095
               COLUMN 18,sr.pmm04 CLIPPED, #TQC-6A0095
               COLUMN 27,sr.pmm12 CLIPPED, #TQC-6A0095
               COLUMN 36,sr.gen02 CLIPPED, #TQC-6A0095
               COLUMN 45,sr.pmm25 CLIPPED,' ',l_str[1,12];  #TQC-6A0095
      PRINT COLUMN 60,sr.pmn02 CLIPPED USING "<<<<",  #TQC-6A0095
            COLUMN 65,sr.pmn04 CLIPPED,  #TQC-6A0095
#TQC-5B0045
#           COLUMN 86,sr.pmn041,
#           COLUMN 117,sr.pmn20 USING "----------&.&&&",
#           COLUMN 133,sr.pmn33,
#           COLUMN 142,sr.amount2 USING "----------&.&&&";

#     PRINT COLUMN 158,sr.rvb01,'-',sr.rvb02 USING "<<<",
#           COLUMN 181,sr.rva06,
#           COLUMN 190,sr.rvb08 USING "---------&.&&&";

            COLUMN 96,sr.pmn041 CLIPPED,  #TQC-6A0095
            COLUMN 127,sr.pmn20 USING "----------&.&&&",
            COLUMN 143,sr.pmn33 CLIPPED, #TQC-6A0095
            COLUMN 152,sr.amount2 USING "----------&.&&&";

      PRINT COLUMN 168,sr.rvb01 CLIPPED,'-',sr.rvb02 USING "<<<",  #TQC-6A0095
            COLUMN 191,sr.rva06 CLIPPED,  #TQC-6A0095
            COLUMN 200,sr.rvb08 USING "---------&.&&&";
#TQC-5B0045
#No.FUN-550026 --end--
      SELECT SUM(rvv17) INTO l_pmn58 FROM rvv_file,rvu_file     #計算倉退
       WHERE rvv04=sr.rvb01 AND rvv05=sr.rvb02
         AND rvuconf ='Y' AND rvu00='3' AND rvv01=rvu01 AND rvv25='N'
      IF cl_null(l_pmn58) THEN LET l_pmn58=0 END IF
#      PRINT COLUMN 191,l_pmn58 USING "---------&.&&&"
#      PRINT COLUMN 206,l_pmn58 USING "---------&.&&&"          #No.FUN-550026   #TQC-5B0045
      PRINT COLUMN 216,l_pmn58 USING "---------&.&&&"          #No.FUN-550026   #TQC-5B0045

 #NO.MOD-4B0067  --end

   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT

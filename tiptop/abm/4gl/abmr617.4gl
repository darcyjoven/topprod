# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abmr617.4gl
# Descriptions...: 主件插件位置差異分析查詢
# Input parameter:
# Return code....:
# Date & Author..: 92/11/10 By Apple
# Modify.........: 93/09/14 By Apple (更動時請告知 THANKS)
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE _NO INTEGER  應該轉為char(18)
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-560028 05/06/07 By Mandy 插件位置及元件編號沒有對齊
# Modify.........: No.MOD-560036 05/06/08 By Mandy 選項:選擇尾階時,列印不出資料.
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加開窗查詢
# Modify.........: NO.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-590110 05/10/09 By yoyo 報表修改，轉XML
# Modify.........: No.TQC-5A0031 05/10/13 By Carrier 報表格式調整
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/08 By xumin 報表寬度調整
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,           # Where condition No.TQC-630166
              part1   LIKE bma_file.bma01,      # 主件料件-1
              code1   LIKE bma_file.bma06,      #FUN-550095
              part2   LIKE bma_file.bma01,      # 主件料件-2
              code2   LIKE bma_file.bma06,      #FUN-550095
              part3   LIKE bma_file.bma01,      # 主件料件-3
              code3   LIKE bma_file.bma06,      #FUN-550095
              part4   LIKE bma_file.bma01,      # 主件料件-4
              code4   LIKE bma_file.bma06,      #FUN-550095
              part5   LIKE bma_file.bma01,      # 主件料件-5
              code5   LIKE bma_file.bma06,      #FUN-550095
              num     LIKE type_file.num5,      #No.FUN-680096 SMALLINT
              vdate   LIKE bmb_file.bmb04,      # 有效日期
              choice  LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
              diff    LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
              s       LIKE type_file.chr2,      #No.FUN-680096 VARCHAR(2)
              more    LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_str      LIKE type_file.chr1000,    #No.FUN-680096 VARCHAR(240)   
          g_str_code LIKE type_file.chr1000,    #No.FUN-680096 VARCHAR(240)
          g_str2,g_str3,g_str4    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(240)
          g_tot     LIKE type_file.num5         #No.FUN-680096 SMALLINT
 
DEFINE   g_chr       LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-680096 SMALLINT
 
MAIN
#     DEFINE    l_time   LIKE type_file.chr8       #No.FUN-6A0060
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.part1 = ARG_VAL(8)
   LET tm.part2 = ARG_VAL(9)
   LET tm.part3 = ARG_VAL(10)
   LET tm.part4 = ARG_VAL(11)
   LET tm.part5 = ARG_VAL(12)
   LET tm.num   = ARG_VAL(13)
   LET tm.vdate = ARG_VAL(14)
   LET tm.choice= ARG_VAL(15)
   LET tm.diff  = ARG_VAL(16)
   LET tm.s     = ARG_VAL(17)
  #TQC-610068-begin
   LET tm.code1 = ARG_VAL(18)
   LET tm.code2 = ARG_VAL(19)
   LET tm.code3 = ARG_VAL(20)
   LET tm.code4 = ARG_VAL(21)
   LET tm.code5 = ARG_VAL(22)
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(18)
   #LET g_rep_clas = ARG_VAL(19)
   #LET g_template = ARG_VAL(20)
   ##No.FUN-570264 ---end---
  #TQC-610068-end
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
      CALL abmr617_tm(0,0)                      # Input print condition
   ELSE
      IF tm.choice = '1' THEN
          CALL abmr617()                        # Read data and create out-file
      ELSE
          CALL abmr617_2()
      END IF
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION abmr617_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_cmd       LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW abmr617_w AT p_row,p_col WITH FORM "abm/42f/abmr617"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.num  = 1
   LET tm.vdate= g_today
   LET tm.choice = '1'
   LET tm.diff = 'Y'
   LET tm.s    = '12'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
 
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON bmt06,bmb03
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
 
#No.FUN-570240  --start-
     ON ACTION controlp
           IF INFIELD(bmb03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bmb03
              NEXT FIELD bmb03
           END IF
#No.FUN-570240 --end--
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
       LET INT_FLAG = 0 CLOSE WINDOW abmr617_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
          
    END IF
    IF tm.wc = " 1=1" THEN
       CALL cl_err('','9046',0)
       CONTINUE WHILE
    END IF
#UI
   INPUT BY NAME tm.part1,tm.code1,tm.part2,tm.code2,tm.part3,tm.code3,tm.part4,tm.code4,
                 tm.part5,tm.code5,tm.num,tm.vdate,tm.choice,tm.diff,tm2.s1,tm2.s2,tm.more #FUN-550095 add code
                 WITHOUT DEFAULTS
#FUN-550095 MARK
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
#               AFTER FIELD part1
#       	    IF NOT cl_null(tm.part1) THEN
#                       CALL r617_item(tm.part1)
#                       IF NOT cl_null(g_errno) THEN
#                          CALL cl_err(tm.part1,g_errno,0)
#                          DISPLAY BY NAME tm.part1
#                          NEXT FIELD part1
#                       END IF
#       	    END IF
 
#       	AFTER FIELD part2
#           IF tm.part2 IS NOT NULL AND tm.part2 != ' '
#               AND (tm.part1 IS NULL OR tm.part1 = ' ')
#           THEN CALL cl_err('','mfg2746',0)
#                NEXT FIELD part1
#           END IF
#           IF tm.part2 = tm.part1  AND
#             (tm.part2 IS NOT NULL AND tm.part2 != ' ')
#           THEN CALL cl_err('','mfg2745',0)
#                NEXT FIELD part2
#           END IF
#       		IF NOT cl_null(tm.part2) THEN
#              CALL r617_item(tm.part2)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(tm.part2,g_errno,0)
#                 DISPLAY BY NAME tm.part2
#                 NEXT FIELD part2
#              END IF
#       		END IF
 
#       	AFTER FIELD part3
#           IF tm.part3 IS NOT NULL AND tm.part3 != ' '
#               AND (tm.part2 IS NULL OR tm.part2 = ' ' )
#           THEN CALL cl_err('','mfg2746',0)
#                NEXT FIELD part2
#           END IF
#           IF tm.part3 = tm.part1  OR tm.part3 = tm.part2
#              AND (tm.part3 IS NOT NULL AND tm.part3 != ' ')
#           THEN CALL cl_err('','mfg2745',0)
#                NEXT FIELD part3
#           END IF
#       		IF NOT cl_null(tm.part3) THEN
#              CALL r617_item(tm.part3)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(tm.part3,g_errno,0)
#                 DISPLAY BY NAME tm.part3
#                 NEXT FIELD part3
#              END IF
#       		END IF
 
#       	AFTER FIELD part4
#           IF tm.part4 IS NOT NULL AND tm.part4 != ' '
#               AND (tm.part3 IS NULL OR tm.part3 = ' ' )
#           THEN CALL cl_err('','mfg2746',0)
#                NEXT FIELD part3
#           END IF
#           IF tm.part4 = tm.part1  OR tm.part4 = tm.part2
#              OR tm.part4 = tm.part3
#              AND (tm.part4 IS NOT NULL AND tm.part4 != ' ')
#           THEN CALL cl_err('','mfg2745',0)
#                NEXT FIELD part4
#           END IF
#       		IF NOT cl_null(tm.part4) THEN
#              CALL r617_item(tm.part4)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(tm.part4,g_errno,0)
#                 DISPLAY BY NAME tm.part4
#                 NEXT FIELD part4
#              END IF
#       		END IF
 
#       	AFTER FIELD part5
#           IF tm.part5 IS NOT NULL AND tm.part5 != ' '
#               AND (tm.part4 IS NULL OR tm.part4 = ' ')
#           THEN CALL cl_err('','mfg2746',0)
#                NEXT FIELD part4
#           END IF
#           IF tm.part5 = tm.part1  OR tm.part5 = tm.part2
#              OR tm.part5 = tm.part3 OR tm.part5 = tm.part4
#              AND (tm.part5 IS NOT NULL AND tm.part5 != ' ')
#           THEN CALL cl_err('','mfg2745',0)
#                NEXT FIELD part5
#           END IF
#       		IF NOT cl_null(tm.part5) THEN
#              CALL r617_item(tm.part5)
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err(tm.part5,g_errno,0)
#                 DISPLAY BY NAME tm.part5
#                 NEXT FIELD part5
#              END IF
#           END IF
#FUN-550095 MARK(end)
 
		AFTER FIELD num
            IF tm.num <=0 THEN
               NEXT FIELD num
            END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
		AFTER INPUT
			IF INT_FLAG THEN CLOSE WINDOW q617_w2 EXIT INPUT END IF
            LET l_flag = 'N'
			IF cl_null(tm.num) OR tm.num <= 0 THEN
                 LET l_flag = 'Y'
                 DISPLAY BY NAME tm.part2
            END IF
			IF cl_null(tm.choice) OR tm.choice NOT MATCHES'[12]' THEN
                 LET l_flag = 'Y'
                 DISPLAY BY NAME tm.part2
            END IF
            IF tm.part1 IS NULL AND tm.part2 IS NULL AND tm.part3 IS NULL
               AND tm.part4 IS NULL AND tm.part5 IS NULL THEN
               LET l_flag = 'Y'
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD part1
            END IF
            #FUN-550095 add
            IF NOT cl_null(tm.part1) THEN
                IF tm.code1 IS NULL THEN LET tm.code1=' ' END IF
                CALL r617_item(tm.part1,tm.code1)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(tm.part1,g_errno,0)
                   DISPLAY BY NAME tm.part1,tm.code1
                   NEXT FIELD part1
                END IF
            END IF
            IF NOT cl_null(tm.part2) THEN
                IF tm.code2 IS NULL THEN LET tm.code2=' ' END IF
                CALL r617_item(tm.part2,tm.code2)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(tm.part2,g_errno,0)
                   DISPLAY BY NAME tm.part2,tm.code2
                   NEXT FIELD part2
                END IF
            END IF
            IF NOT cl_null(tm.part3) THEN
                IF tm.code3 IS NULL THEN LET tm.code3=' ' END IF
                CALL r617_item(tm.part3,tm.code3)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(tm.part3,g_errno,0)
                   DISPLAY BY NAME tm.part3,tm.code3
                   NEXT FIELD part3
                END IF
            END IF
            IF NOT cl_null(tm.part4) THEN
                IF tm.code4 IS NULL THEN LET tm.code4=' ' END IF
                CALL r617_item(tm.part4,tm.code4)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(tm.part4,g_errno,0)
                   DISPLAY BY NAME tm.part4,tm.code4
                   NEXT FIELD part4
                END IF
            END IF
            IF NOT cl_null(tm.part5) THEN
                IF tm.code5 IS NULL THEN LET tm.code5=' ' END IF
                CALL r617_item(tm.part5,tm.code5)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(tm.part5,g_errno,0)
                   DISPLAY BY NAME tm.part5,tm.code5
                   NEXT FIELD part5
                END IF
            END IF
            #FUN-550095(end)
            #UI
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
#FUN-550095 add
      ON ACTION CONTROLP     #查詢條件
         CASE
            WHEN INFIELD(part1) #主件-1
               CALL cl_init_qry_var()
               IF g_sma.sma118 = 'Y' THEN
                   LET g_qryparam.form = "q_bma6"            #FUN-550095
                   LET g_qryparam.default1 = tm.part1
                   CALL cl_create_qry() RETURNING tm.part1,tm.code1
                   DISPLAY BY NAME tm.part1,tm.code1
               ELSE
                   LET g_qryparam.form = "q_bma2"            #FUN-550095
                   LET g_qryparam.default1 = tm.part1
                   CALL cl_create_qry() RETURNING tm.part1
                   DISPLAY BY NAME tm.part1
               END IF
               NEXT FIELD part1
            WHEN INFIELD(part2) #主件-2
               CALL cl_init_qry_var()
               IF g_sma.sma118 = 'Y' THEN
                   LET g_qryparam.form = "q_bma6"            #FUN-550095
                   LET g_qryparam.default1 = tm.part2
                   CALL cl_create_qry() RETURNING tm.part2,tm.code2
                   DISPLAY BY NAME tm.part2,tm.code2
               ELSE
                   LET g_qryparam.form = "q_bma2"            #FUN-550095
                   LET g_qryparam.default1 = tm.part2
                   CALL cl_create_qry() RETURNING tm.part2
                   DISPLAY BY NAME tm.part2
               END IF
               NEXT FIELD part2
            WHEN INFIELD(part3) #主件-3
               CALL cl_init_qry_var()
               IF g_sma.sma118 = 'Y' THEN
                   LET g_qryparam.form = "q_bma6"            #FUN-550095
                   LET g_qryparam.default1 = tm.part3
                   CALL cl_create_qry() RETURNING tm.part3,tm.code3
                   DISPLAY BY NAME tm.part3,tm.code3
               ELSE
                   LET g_qryparam.form = "q_bma2"            #FUN-550095
                   LET g_qryparam.default1 = tm.part3
                   CALL cl_create_qry() RETURNING tm.part3
                   DISPLAY BY NAME tm.part3
               END IF
               NEXT FIELD part3
            WHEN INFIELD(part4) #主件-4
               CALL cl_init_qry_var()
               IF g_sma.sma118 = 'Y' THEN
                   LET g_qryparam.form = "q_bma6"            #FUN-550095
                   LET g_qryparam.default1 = tm.part4
                   CALL cl_create_qry() RETURNING tm.part4,tm.code4
                   DISPLAY BY NAME tm.part4,tm.code4
               ELSE
                   LET g_qryparam.form = "q_bma2"            #FUN-550095
                   LET g_qryparam.default1 = tm.part4
                   CALL cl_create_qry() RETURNING tm.part4
                   DISPLAY BY NAME tm.part4
               END IF
               NEXT FIELD part4
            WHEN INFIELD(part5) #主件-5
               CALL cl_init_qry_var()
               IF g_sma.sma118 = 'Y' THEN
                   LET g_qryparam.form = "q_bma6"            #FUN-550095
                   LET g_qryparam.default1 = tm.part5
                   CALL cl_create_qry() RETURNING tm.part5,tm.code5
                   DISPLAY BY NAME tm.part5,tm.code5
               ELSE
                   LET g_qryparam.form = "q_bma2"            #FUN-550095
                   LET g_qryparam.default1 = tm.part5
                   CALL cl_create_qry() RETURNING tm.part5
                   DISPLAY BY NAME tm.part5,tm.code5
               END IF
               NEXT FIELD part5
            OTHERWISE EXIT CASE
         END CASE
#FUN-550095(end)
 
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
      LET INT_FLAG = 0 CLOSE WINDOW abmr617_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abmr617'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr617','9031',1)
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
                         " '",tm.part1 CLIPPED,"'",
                         " '",tm.part2 CLIPPED,"'",
                         " '",tm.part3 CLIPPED,"'",
                         " '",tm.part4 CLIPPED,"'",
                         " '",tm.part5 CLIPPED,"'",
                         " '",tm.num   CLIPPED,"'",
                         " '",tm.vdate CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.diff  CLIPPED,"'",    #TQC-610068
                         " '",tm.s     CLIPPED,"'",    #TQC-610068
                         " '",tm.code1 CLIPPED,"'",    #TQC-610068
                         " '",tm.code2 CLIPPED,"'",    #TQC-610068
                         " '",tm.code3 CLIPPED,"'",    #TQC-610068
                         " '",tm.code4 CLIPPED,"'",    #TQC-610068
                         " '",tm.code5 CLIPPED,"'",    #TQC-610068
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr617',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abmr617_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   IF tm.choice = '1' THEN
      CALL abmr617()
   ELSE
      CALL abmr617_2()
   END IF
   ERROR ""
END WHILE
   CLOSE WINDOW abmr617_w
END FUNCTION
 
FUNCTION r617_item(p_item,p_code)    #主件編號 #FUN-550095 add p_code
    DEFINE p_item    LIKE bma_file.bma01,
           p_code    LIKE bma_file.bma06, #FUN-550095 add
           l_bmaacti LIKE bma_file.bmaacti
 
    LET g_errno = ' '
    SELECT bmaacti INTO l_bmaacti
           FROM bma_file WHERE bma01 = p_item
                           AND bma06 = p_code #FUN-550095 add
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno  = 'mfg2744'
                                   LET l_bmaacti= NULL
         WHEN l_bmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION abmr617()
   DEFINE l_name    LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0060
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT     #No.FUN-680096 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_k       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_i       LIKE type_file.num5,    #MOD-560028        #No.FUN-680096 SMALLINT
          l_j       LIKE type_file.num5,    #MOD-560028        #No.FUN-680096 SMALLINT
          l_order   ARRAY[5] OF LIKE bmb_file.bmb03,    #FUN-560011 #No.FUN-680096 VARCHAR(40)
          sr               RECORD
                                seq     LIKE type_file.num5,   #虛設       #No.FUN-680096 SMALLINT
                                order1  LIKE bmb_file.bmb03, #FUN-560011 #No.FUN-680096 VARCHAR(40)
                                order2  LIKE bmb_file.bmb03, #FUN-560011 #No.FUN-680096 VARCHAR(40)
                                bmb01   LIKE bmb_file.bmb01,
                                bmb29   LIKE bmb_file.bmb29,   #FUN-550095 add
                                bmt06   LIKE bmt_file.bmt06,
                                bmb03   LIKE bmb_file.bmb03,    #元件
                                ima02   LIKE ima_file.ima02,    #品名規格
                                bmt07   LIKE bmt_file.bmt07,    #QPA
                                ima25   LIKE ima_file.ima25     #庫存單位
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_tot = 0
     IF tm.part1 IS NULL OR tm.part1 = ' ' THEN
          LET tm.part1 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     IF tm.part2 IS NULL OR tm.part2 = ' ' THEN
          LET tm.part2 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     IF tm.part3 IS NULL OR tm.part3 = ' ' THEN
          LET tm.part3 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     IF tm.part4 IS NULL OR tm.part4 = ' ' THEN
          LET tm.part4 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     IF tm.part5 IS NULL OR tm.part5 = ' ' THEN
          LET tm.part5 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     #MOD-560028 MARK
    #LET g_str = tm.part1,tm.part2,tm.part3,tm.part4,tm.part5 clipped
    #LET g_str2 = ' '  LET g_str3 = ' '  LET g_str4 =' '
    #FOR l_k= 1 TO g_tot
    #    LET g_str2 = ' ',g_str2 clipped,'           ',g_x[14] clipped
    #    LET g_str3 = ' ',g_str3 clipped,'           ',g_x[15] clipped
    #    LET g_str4 = g_str4 clipped,' -------------------' clipped
    #END FOR
	 LET l_sql=
		" SELECT 1,'','',bmb01,bmb29,bmt06,bmb03,ima02,", #FUN-550095 add bmb29
        " (bmt07*bmb10_fac),ima25,'' ",
		" FROM bmb_file , OUTER ima_file, bmt_file ",
		" WHERE bmb_file.bmb03 = ima_file.ima01 AND  ",
 		"       bmb01 = bmt01 AND  ",
		"       bmb02 = bmt02 AND  ",
		"       bmb03 = bmt03 AND  ",
		"       bmb04 = bmt04 AND  ",
		"       bmb29 = bmt08 AND  ", #FUN-550095 add
       #FUN-550095
       #"      ( bmb01 ='",tm.part1,"' OR ",
       #"       bmb01 ='",tm.part2 ,"' OR",
       #"       bmb01 ='",tm.part3 ,"' OR",
       #"       bmb01 ='",tm.part4 ,"' OR",
       #"       bmb01 ='",tm.part5 ,"' )"
        "      (( bmb01 ='",tm.part1,"'",
        "    AND bmb29 ='",tm.code1,"'",") OR (",
        "        bmb01 ='",tm.part2 ,"'",
        "    AND bmb29 ='",tm.code2,"'",") OR (",
        "        bmb01 ='",tm.part3 ,"'",
        "    AND bmb29 ='",tm.code3,"'",") OR (",
        "        bmb01 ='",tm.part4 ,"'",
        "    AND bmb29 ='",tm.code4,"'",") OR (",
        "        bmb01 ='",tm.part5 ,"'",
        "    AND bmb29 ='",tm.code5,"'"," ))   "
 
       #FUN-550095(end)
 
        IF tm.vdate IS NOT NULL THEN
            LET l_sql=l_sql CLIPPED,
                      " AND (bmb04 <='",tm.vdate,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",tm.vdate,"' OR bmb05 IS NULL)"
        END IF
     LET l_sql = l_sql clipped ," ORDER BY 2,3 "
     PREPARE abmr617_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE abmr617_curs1 CURSOR FOR abmr617_prepare1
 
     CALL cl_outnam('abmr617') RETURNING l_name
     #No.TQC-5A0031  --begin
     #FUN-550095 add
     LET g_str_code=''
     LET g_str_code[1,40] =tm.code1
     LET g_str_code[41,41]=' '
     LET g_str_code[42,81]=tm.code2
     LET g_str_code[82,82]=' '
     LET g_str_code[83,122]=tm.code3
     LET g_str_code[123,123]=' '
     LET g_str_code[124,163]=tm.code4
     LET g_str_code[164,164]=' '
     LET g_str_code[165,204]=tm.code5
     #FUN-550095(end)
      #MOD-560028 add
     LET g_str  = ''
     LET g_str2 = ''  LET g_str3 = ''  LET g_str4 =''
     LET g_str[1,40] =tm.part1
     LET g_str[41,41]=' '
     LET g_str[42,81]=tm.part2
     LET g_str[82,82]=' '
     LET g_str[83,122]=tm.part3
     LET g_str[123,123]=' '
     LET g_str[124,163]=tm.part4
     LET g_str[164,164]=' '
     LET g_str[165,204]=tm.part5
     #No.TQC-5A0031  --end
     LET l_i=0
     LET l_j=0
     FOR l_k= 1 TO g_tot
         LET l_i=l_j+1
         #No.TQC-5A0031  --begin
         #LET l_j=l_i+19
         LET l_j=l_i+39   #ima01變為40碼了
         #No.TQC-5A0031  --end
         LET g_str2[l_i,l_j]     =g_x[14] clipped
         LET g_str2[l_j+1,l_j+1] =' '
         LET g_str3[l_i,l_j]     =g_x[15] clipped
         LET g_str3[l_j+1,l_j+1] =' '
         LET g_str4[l_i,l_j]     ='----------------------------------------'#No.TQC-5A0031
         LET g_str4[l_j+1,l_j+1] =' '
         LET l_j=l_j+1
     END FOR
      #MOD-560028(end)
#No.FUN-590110--start
      #No.TQC-5A0031  --begin
      LET g_zaa[37].zaa08=g_str3[1,40]
      LET g_zaa[38].zaa08=g_str3[42,81]
      LET g_zaa[39].zaa08=g_str3[83,122]
      LET g_zaa[40].zaa08=g_str3[124,163]
      LET g_zaa[41].zaa08=g_str3[165,204]
      #No.TQC-5A0031  --end
      FOR l_k=37 TO 41
          IF cl_null(g_zaa[l_k].zaa08) THEN
             LET g_zaa[l_k].zaa06='Y'
          END IF
      END FOR
      CALL cl_prt_pos_len()
#No.FUN-590110--end
 
     START REPORT abmr617_rep TO l_name
     CALL r617_temp()
     LET g_pageno = 0
     FOREACH abmr617_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0
       THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.bmt07 IS NULL THEN LET sr.bmt07 = 0 END IF
       FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bmt06
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.bmb03
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       INSERT INTO r617_file VALUES(sr.*)
     END FOREACH
	   LET l_sql=
	    	" SELECT *  FROM r617_file ",
		    " WHERE ",tm.wc clipped
       PREPARE r617_p2 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('p2:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       DECLARE r617_c2 CURSOR FOR r617_p2
       FOREACH r617_c2 INTO sr.*
          IF SQLCA.sqlcode != 0
          THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          OUTPUT TO REPORT abmr617_rep(sr.*)
       END FOREACH
     FINISH REPORT abmr617_rep
     DROP TABLE r617_file
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION abmr617_2()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql         LIKE type_file.chr1000,	# RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_k           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
           l_i          LIKE type_file.num5,    #MOD-560028     #No.FUN-680096 SMALLINT
           l_j          LIKE type_file.num5,    #MOD-560028     #No.FUN-680096 SMALLINT
          sr               RECORD
                                seq     LIKE type_file.num5,    #虛設       #No.FUN-680096 SMALLINT
                                order1  LIKE bmb_file.bmb03,  #FUN-560011 #No.FUN-680096 VARCHAR(40)
                                order2  LIKE bmb_file.bmb03,  #FUN-560011 #No.FUN-680096 VARCHAR(40)
                                bmb01   LIKE bmb_file.bmb01,
                                bmb29   LIKE bmb_file.bmb29,    #FUN-550095 add
                                bmt06   LIKE bmt_file.bmt06,
                                bmb03   LIKE bmb_file.bmb03,    #元件
                                ima02   LIKE ima_file.ima02,    #品名規格
                                bmt07   LIKE bmt_file.bmt07,    #QPA
                                ima25   LIKE ima_file.ima25     #庫存單位
                        END RECORD,
          l_bma01 LIKE bma_file.bma01           #主件料件
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      #MOD-560036
      #MOD-560036(end)
     #MOD-560028 MARK
    #DECLARE r617_za_cur CURSOR FOR
    #        SELECT za02,za05 FROM za_file
    #         WHERE za01 = "abmr617" AND za03 = g_rlang
    #FOREACH r617_za_cur INTO g_i,l_za05
    #   LET g_x[g_i] = l_za05
    #END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr617'
      LET g_tot=0 #MOD-560028 add
      #MOD-560036 add
     IF tm.part1 IS NULL OR tm.part1 = ' ' THEN
          LET tm.part1 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
      #MOD-560036(end)
     IF tm.part2 IS NULL OR tm.part2 = ' ' THEN
          LET tm.part2 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     IF tm.part3 IS NULL OR tm.part3 = ' ' THEN
          LET tm.part3 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     IF tm.part4 IS NULL OR tm.part4 = ' ' THEN
          LET tm.part4 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     IF tm.part5 IS NULL OR tm.part5 = ' ' THEN
          LET tm.part5 = NULL
     ELSE LET g_tot = g_tot + 1
     END IF
     #MOD-560028 MARK
    #LET g_str = tm.part1,tm.part2,tm.part3,tm.part4,tm.part5 clipped
    #LET g_str2 = ' '  LET g_str3 = ' '  LET g_str4 =' '
    #FOR l_k= 1 TO g_tot
    #    LET g_str2 = ' ',g_str2 clipped,'           ',g_x[14] clipped
    #    LET g_str3 = ' ',g_str3 clipped,'           ',g_x[15] clipped
    #    LET g_str4 = g_str4 clipped,' -------------------' clipped
    #END FOR
     CALL cl_outnam('abmr617') RETURNING l_name
     #FUN-550095 add
     LET g_str_code=''
     #No.TQC-5A0031  --begin
     LET g_str_code[1,40] =tm.code1
     LET g_str_code[41,41]=' '
     LET g_str_code[42,81]=tm.code2
     LET g_str_code[82,82]=' '
     LET g_str_code[83,122]=tm.code3
     LET g_str_code[123,123]=' '
     LET g_str_code[124,163]=tm.code4
     LET g_str_code[164,164]=' '
     LET g_str_code[165,204]=tm.code5
     #FUN-550095(end)
      #MOD-560028 add
     LET g_str  = ''
     LET g_str2 = ''  LET g_str3 = ''  LET g_str4 =''
     LET g_str[1,40] =tm.part1
     LET g_str[41,41]=' '
     LET g_str[42,81]=tm.part2
     LET g_str[82,82]=' '
     LET g_str[83,122]=tm.part3
     LET g_str[123,123]=' '
     LET g_str[124,163]=tm.part4
     LET g_str[164,164]=' '
     LET g_str[165,204]=tm.part5
     #No.TQC-5A0031  --end
     LET l_i=0
     LET l_j=0
     FOR l_k= 1 TO g_tot
         LET l_i=l_j+1
         #No.TQC-5A0031  --begin
         #LET l_j=l_i+19
         LET l_j=l_i+39
         #No.TQC-5A0031  --end
         LET g_str2[l_i,l_j]     =g_x[14] clipped
         LET g_str2[l_j+1,l_j+1] =' '
         LET g_str3[l_i,l_j]     =g_x[15] clipped
         LET g_str3[l_j+1,l_j+1] =' '
         LET g_str4[l_i,l_j]     ='----------------------------------------' #No.TQC-5A0031
         LET g_str4[l_j+1,l_j+1] =' '
         LET l_j=l_j+1
     END FOR
#No.FUN-590110--start
      #No.TQC-5A0031  --begin
      LET g_zaa[37].zaa08=g_str3[1,40]
      LET g_zaa[38].zaa08=g_str3[42,81]
      LET g_zaa[39].zaa08=g_str3[83,122]
      LET g_zaa[40].zaa08=g_str3[124,163]
      LET g_zaa[41].zaa08=g_str3[165,204]
      #No.TQC-5A0031  --end
      FOR l_k=37 TO 41
          IF cl_null(g_zaa[l_k].zaa08) THEN
             LET g_zaa[l_k].zaa06='Y'
          END IF
      END FOR
      CALL cl_prt_pos_len()
#No.FUN-590110--end
      #MOD-560028(end)
  	START REPORT abmr617_rep TO l_name
        CALL r617_temp()
        LET l_sql = "SELECT '','','',bmt01,bmt08,bmt06,bmt03,ima02,bmt07,ima25 ", #FUN-550095 add bmt08
                    " FROM bmt_file,OUTER ima_file ",
                    " WHERE bmt01 = ? ",
                    "   AND bmt02 = ? ",
                    "   AND bmt03 = ? ",
                    "   AND bmt04 = ? ",
                    "   AND bmt08 = ? ", #FUN-550095 add
                    "   AND bmt_file.bmt03 = ima_file.ima01 "
 
        PREPARE r617_pre_bal FROM l_sql
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('p4:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
           EXIT PROGRAM
              
        END IF
        DECLARE r617_balloon CURSOR FOR r617_pre_bal
        CALL r617_bom(1,tm.part1,tm.code1) #FUN-550095 add code
        CALL r617_bom(2,tm.part2,tm.code2) #FUN-550095 add code
        CALL r617_bom(3,tm.part3,tm.code3) #FUN-550095 add code
        CALL r617_bom(4,tm.part4,tm.code4) #FUN-550095 add code
        CALL r617_bom(5,tm.part5,tm.code5) #FUN-550095 add code
  	    LET l_sql=
	    	" SELECT *  FROM r617_file " ,
		    " WHERE ",tm.wc clipped
       PREPARE r617_p4 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('p4:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       DECLARE r617_c4 CURSOR FOR r617_p4
       FOREACH r617_c4 INTO sr.*
          IF SQLCA.sqlcode != 0
          THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          OUTPUT TO REPORT abmr617_rep(sr.*)
       END FOREACH
   FINISH REPORT abmr617_rep
     DROP TABLE r617_file
            LET INT_FLAG = 0  ######add for prompt bug
     IF INT_FLAG THEN
        LET INT_FLAG = 0
     END IF
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION r617_bom(p_order,p_item,p_code) #FUN-550095 add
   DEFINE p_level	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          p_item	LIKE bma_file.bma01,     #主件料件編號
          p_code	LIKE bma_file.bma06,     #FUN-550095 add
          p_order       LIKE type_file.num5,     #No.FUN-680096 SMALLINT 
          l_total       LIKE csa_file.csa0301,   #No.FUN-680096 DEC(13,5)
          l_ac,i	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_order    ARRAY[5] OF LIKE bmb_file.bmb03,   #No.FUN-680096 VARCHAR(40)
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
                            bma01   LIKE bma_file.bma01,
          		    bmb01   LIKE bmb_file.bmb01,    #主件
          		    bmb29   LIKE bmb_file.bmb29,    #FUN-550095 add
          		    bmb02   LIKE bmb_file.bmb02,    #項次
          		    bmb03   LIKE bmb_file.bmb03,    #元件
          		    bmb04   LIKE bmb_file.bmb04    #生效日
                    #   INTEGER    #MOD-4A0041
          END RECORD,
          sr2     RECORD
                    seq     LIKE type_file.num5,   #虛設         #No.FUN-680096 SMALLINT
                    order1  LIKE bmb_file.bmb03, #FUN-560011   #No.FUN-680096 VARCHAR(40)
                    order2  LIKE bmb_file.bmb03, #FUN-560011   #No.FUN-680096 VARCHAR(40)
                    bmb01   LIKE bmb_file.bmb01,
                    bmb29   LIKE bmb_file.bmb29, #FUN-550095 add
                    bmt06   LIKE bmt_file.bmt06,
                    bmb03   LIKE bmb_file.bmb03,    #元件
                    ima02   LIKE ima_file.ima02,    #品名規格
                    bmt07   LIKE bmt_file.bmt07,    #QPA
                    ima25   LIKE ima_file.ima25     #庫存單位
                  END RECORD,
          l_cmd	   LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(60)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
 
    IF cl_null(p_item) THEN RETURN END IF
	IF p_level > 20 THEN
		CALL cl_err('','mfg2733',1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM
   
	END IF
 
    LET arrno = 600
    WHILE TRUE
	    LET l_cmd=
	    	" SELECT bma01,bmb01,bmb29,bmb02,bmb03,bmb04 ", #FUN-550095 add bmb29
    		" FROM   bmb_file,OUTER bma_file ",
             #MOD-560036
    		" WHERE bmb_file.bmb03 = bma_file.bma01 ",
                "   AND bmb01='",p_item,"'",
                "   AND bmb29='",p_code,"'"  #FUN-550095 add
            IF 1=2 THEN
            END IF
             #MOD-560036(end)
 
 
        #生效日及失效日的判斷
        IF tm.vdate IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED,
                      " AND (bmb04 <='",tm.vdate,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",tm.vdate,"' OR bmb05 IS NULL)"
        END IF
        #排列方式
        PREPARE r617_precur2 FROM l_cmd
        IF SQLCA.sqlcode THEN
			 CALL cl_err('P1:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM 
   END IF
        DECLARE r617_cur2 CURSOR FOR r617_precur2
        LET l_ac = 1
        FOREACH r617_cur2 INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            IF SQLCA.sqlcode != 0
            THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            #FUN-8B0015--BEGIN--
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #FUN-8B0015--END-- 
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac = arrno THEN EXIT FOREACH END IF
        END FOREACH
 
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            IF sr[i].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭)
               #CALL r617_bom(p_order,sr[i].bmb03,' ')  #FUN-550095 add ' '#FUN-8B0015
                CALL r617_bom(p_order,sr[i].bmb03,l_ima910[i])  #FUN-550095 add ' '#FUN-8B0015
            ELSE
                FOREACH r617_balloon
                USING sr[i].bmb01,sr[i].bmb02,
                      sr[i].bmb03,sr[i].bmb04,sr[i].bmb29 #FUN-550095 add bmb29
                INTO sr2.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('r617_balloon',SQLCA.sqlcode,0)
                  END IF
                  LET sr2.bmb01 = p_item
                  FOR g_i = 1 TO 2
                     CASE WHEN tm.s[g_i,g_i] = '1'
                               LET l_order[g_i] = sr2.bmt06
                          WHEN tm.s[g_i,g_i] = '2'
                               LET l_order[g_i] = sr2.bmb03
                          OTHERWISE LET l_order[g_i] = '-'
                     END CASE
                  END FOR
                  LET sr2.order1 = l_order[1]
                  LET sr2.order2 = l_order[2]
                  LET sr2.seq = p_order
                  INSERT INTO r617_file VALUES(sr2.*)
               END FOREACH
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        ELSE
        END IF
    END WHILE
END FUNCTION
 
REPORT abmr617_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          sr               RECORD
                                seq     LIKE type_file.num5,   #No.FUN-680096 SMALLINT
                                order1  LIKE bmb_file.bmb03, #FUN-560011 #No.FUN-680096 VARCHAR(40)
                                order2  LIKE bmb_file.bmb03, #FUN-560011 #No.FUN-680096 VARCHAR(40)
		                bmb01   LIKE bmb_file.bmb01,   #主件
                                bmb29   LIKE bmb_file.bmb29,    #FUN-550095 add
		                bmt06   LIKE bmt_file.bmt06,   #主件
                      		bmb03   LIKE bmb_file.bmb03,   #元件
                      		ima02   LIKE ima_file.ima02,   #品名規格
                                bmt07   LIKE bmt_file.bmt07,   #QPA
                                ima25   LIKE ima_file.ima25    #庫存單位
                        END RECORD,
         l_bmb DYNAMIC ARRAY OF RECORD       #每階存放資料
		            bmb01   LIKE bmb_file.bmb01,    #上階主件
                   #bmb06   DECIMAL(15,5),          #QPA
                    bmb06   LIKE bmb_file.bmb06,    #QPA #FUN-560227
                    ima25   LIKE ima_file.ima25     #庫存單位
          END RECORD,
      l_i,l_k      LIKE type_file.num5,         #No.FUN-680096 SMALLINT
      l_b          DYNAMIC ARRAY OF LIKE type_file.chr1000,  #No.TQC-5A0031 #No.FUN-680096 VARCHAR(40)
      l_exit,l_qpa LIKE type_file.chr1,         #No.FUN-680096 VARCHAR(01),
      l_chr        LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.bmt06,sr.bmb03
  FORMAT
   PAGE HEADER
#No.FUN-590110--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED   #TQC-6A0083
      LET g_pageno = g_pageno + 1
      LET pageno_total= PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      IF tm.choice = '1' THEN
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
      ELSE
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[13]))/2+1),g_x[13]
      END IF
      PRINT COLUMN 01,g_x[12] clipped,tm.vdate,'  ',
            g_x[16] clipped,tm.num,'  ',g_x[17] clipped
#No.FUN-590110--end
      PRINT g_dash[1,g_len]
      #MOD-560028 MARK
     #PRINT column 36,g_str2[12,120] clipped
     #PRINT column 33,g_str clipped
     #PRINT g_x[11] clipped,column 36,g_str3 [12,120] clipped
#No.FUN-590110--start
#     PRINT column 33,g_str2 clipped
#     PRINT column 33,g_str clipped
      #No.TQC-5A0031  --begin
      LET g_x[20]=g_str2[1,40]
      LET g_x[21]=g_str2[42,81]
      LET g_x[22]=g_str2[83,122]
      LET g_x[23]=g_str2[124,163]
      LET g_x[24]=g_str2[165,204]
      LET g_x[25]=g_str[1,40]
      LET g_x[26]=g_str[42,81]
      LET g_x[27]=g_str[83,122]
      LET g_x[28]=g_str[124,163]
      LET g_x[29]=g_str[165,204]
      LET g_x[30]=g_str_code[1,40]
      LET g_x[31]=g_str_code[42,81]
      LET g_x[32]=g_str_code[83,122]
      LET g_x[33]=g_str_code[124,163]
      LET g_x[34]=g_str_code[165,204]
      #No.TQC-5A0031  --end
      PRINT COLUMN g_c[37],g_x[20],
            COLUMN g_c[38],g_x[21],
            COLUMN g_c[39],g_x[22],
            COLUMN g_c[40],g_x[23],
            COLUMN g_c[41],g_x[24]
      PRINT COLUMN g_c[37],g_x[25],
            COLUMN g_c[38],g_x[26],
            COLUMN g_c[39],g_x[27],
            COLUMN g_c[40],g_x[28],
            COLUMN g_c[41],g_x[29]
      IF g_sma.sma118 = 'Y' THEN
#         PRINT column 33,g_str_code clipped
      PRINT COLUMN g_c[37],g_x[30],
            COLUMN g_c[38],g_x[31],
            COLUMN g_c[39],g_x[32],
            COLUMN g_c[40],g_x[33],
            COLUMN g_c[41],g_x[34]
      ELSE
          PRINT ''
      END IF
#     PRINT g_x[11] clipped,column 33,g_str3 clipped
#     PRINT '---------- --------------------',COLUMN 33,g_str4 clipped
      PRINT g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
      PRINT g_dash1
#No.FUN-590110--end
      #MOD-560028(end)
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order2
      FOR l_i= 1 TO 5
          INITIALIZE l_bmb[l_i].* TO  NULL
          LET l_bmb[l_i].bmb06 = 0
      END FOR
 
   ON EVERY ROW
      IF tm.choice = '1' THEN
         IF sr.bmb01 = tm.part1 AND sr.bmb29 = tm.code1 THEN  #FUN-550095
            LET l_bmb[1].bmb06 = l_bmb[1].bmb06 + (sr.bmt07 * tm.num)
            LET l_bmb[1].ima25 = sr.ima25
         END IF
         IF sr.bmb01 = tm.part2 AND sr.bmb29 = tm.code2 THEN  #FUN-550095
            LET l_bmb[2].bmb06 = l_bmb[2].bmb06 + (sr.bmt07 * tm.num)
            LET l_bmb[2].ima25 = sr.ima25
         END IF
         IF sr.bmb01 = tm.part3 AND sr.bmb29 = tm.code3 THEN  #FUN-550095
            LET l_bmb[3].bmb06 = l_bmb[3].bmb06 + (sr.bmt07 * tm.num)
            LET l_bmb[3].ima25 = sr.ima25
         END IF
         IF sr.bmb01 = tm.part4 AND sr.bmb29 = tm.code4 THEN  #FUN-550095
            LET l_bmb[4].bmb06 = l_bmb[4].bmb06 + (sr.bmt07 * tm.num)
            LET l_bmb[4].ima25 = sr.ima25
         END IF
         IF sr.bmb01 = tm.part5 AND sr.bmb29 = tm.code5 THEN  #FUN-550095
            LET l_bmb[5].bmb06 = l_bmb[5].bmb06 + (sr.bmt07 * tm.num)
            LET l_bmb[5].ima25 = sr.ima25
         END IF
      ELSE
         LET l_k = sr.seq
         LET l_bmb[l_k].bmb06 = l_bmb[l_k].bmb06 + (sr.bmt07 * tm.num)
         LET l_bmb[l_k].ima25 = sr.ima25
      END IF
 
   AFTER GROUP OF sr.order2
       FOR l_k = 1 TO 5
          IF l_bmb[l_k].bmb06 = 0 THEN LET l_bmb[l_k].bmb06 = ' ' END IF
       END FOR
       LET l_qpa ='N'
       LET l_exit ='N'
       FOR l_k = 1 TO g_tot
           FOR l_i = l_k TO g_tot
               IF l_i = 1 THEN CONTINUE FOR END IF
               IF l_bmb[l_i].bmb06 = l_bmb[l_i-1].bmb06
               THEN LET l_qpa ='Y'
               ELSE LET l_exit ='Y' LET l_qpa ='N' EXIT FOR
               END IF
           END FOR
           IF l_exit = 'Y' THEN EXIT FOR END IF
       END FOR
       IF (l_qpa ='N' and tm.diff ='Y') OR tm.diff ='N'
        #MOD-560028
#No.FUN-590110--start
       THEN  LET  l_b[1]=l_bmb[1].bmb06 using'##############################&.&&&',' ',(4-LENGTH(l_bmb[1].ima25)) SPACES,l_bmb[1].ima25
             LET  l_b[2]=l_bmb[2].bmb06 using'##############################&.&&&',' ',(4-LENGTH(l_bmb[2].ima25)) SPACES,l_bmb[2].ima25
             LET  l_b[3]=l_bmb[3].bmb06 using'##############################&.&&&',' ',(4-LENGTH(l_bmb[3].ima25)) SPACES,l_bmb[3].ima25
             LET  l_b[4]=l_bmb[4].bmb06 using'##############################&.&&&',' ',(4-LENGTH(l_bmb[4].ima25)) SPACES,l_bmb[4].ima25
             LET  l_b[5]=l_bmb[5].bmb06 using'##############################&.&&&',' ',(4-LENGTH(l_bmb[5].ima25)) SPACES,l_bmb[5].ima25
#TQC-6A0083--add CLIPPED--BEGIN
             PRINT column g_c[35],sr.bmt06 CLIPPED,
                   column g_c[36],sr.bmb03 CLIPPED,  #No.TQC-5A0031
                   column g_c[37],l_b[1] CLIPPED,
                   column g_c[38],l_b[2] CLIPPED,
                   column g_c[39],l_b[3] CLIPPED,
                   column g_c[40],l_b[4] CLIPPED,
                   column g_c[41],l_b[5] CLIPPED
#TQC-6A0083--add CLIPPED--END
#No.FUN-590110--end
        #MOD-560028(end)
       END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'bmb03,bmt06') RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #No.TQC-630166 --start--
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #No.TQC-630166 ---end---
      END IF
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
 
FUNCTION r617_temp()
#No.FUN-680096-----------------begin-----------------
CREATE TEMP TABLE r617_file(
       seq      LIKE type_file.num5,  
       order1   LIKE type_file.chr1000,
       order2   LIKE type_file.chr1000,
       bmb01    LIKE bmb_file.bmb01,
       bmb29    LIKE bmb_file.bmb29,
       bmt06    LIKE bmt_file.bmt06,
       bmb03    LIKE bmb_file.bmb03,
       ima02    LIKE ima_file.ima02,
       bmt07    LIKE bmt_file.bmt07,
       ima25    LIKE ima_file.ima25)
#No.FUN-680096----------------end------------------   
  IF SQLCA.sqlcode THEN
     CALL cl_err('cannot create',SQLCA.sqlcode,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
     EXIT PROGRAM
  END IF
END FUNCTION
#Patch....NO.TQC-610035 <> #

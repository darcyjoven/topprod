# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: afax300.4gl
# Desc/riptions...: 固定資產折舊費用明細表
# Date & Author..: 96/06/12 By WUPN
# Modify.........: No:7661 03/07/18 By Wiky 列印的英文名稱改為中文名稱
# Modify.........: No:8541 03/10/22 By Kitty 列印分攤後的前期折舊改SUM(fan07)
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.MOD-490182 04/09/09 By Yuna 1.在表尾加上總計
#						  2.表頭的'年''月'中文不應該寫死在程式裡面
#                                                 3.小計那列的中文顯示有錯誤
# Modify.........: No.FUN-FUN-510035 05/03/05 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.MOD-530529 05/03/30 By Smapmin 前期折舊不應以負數呈現
# Modify.........: No.FUN-560268 05/07/07 By Nicola 新增資料抓取fan_file 開帳資料(fan041='0' OR fan041='1')
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.TQC-610106 06/01/20 By Smapmin 成本欄位依金額方式取位
# Modify.........: No.MOD-620069 06/02/23 By Smapmin 將報表改為template,新增"已折月數"欄,修改"前期折舊"
# Modify.........: No.TQC-630111 06/04/04 By Smapmin 沒有fan_file的資料時,要顯示fan_file最後一個月的資料
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.TQC-680084 06/08/21 By Smapmin 拿掉已折月數欄位
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-710052 07/07/08 By Smapmin 修改SQL語法
# Modify.........: No.MOD-710104 07/07/17 By Dido 當月出售/銷帳有折舊時須顯示,以後則不可顯示
# Modify.........: No.MOD-730123 07/03/27 By Smapmin 前期折舊 = (累折 - 本期累折)
# Modify.........: No.MOD-740026 07/04/10 By Smapmin 修改SELECT條件
# Modify.........: NO.FUN-7B0139 07/11/30 By zhaijie 報表輸出改為Crystal Report
# Modify.........: No.MOD-820130 08/02/22 By dxfwo   afax300 當某一資產在一年內提完折舊以后，
#                                                    次年在打印的時候 前期折舊為0，
#                                                    應該是有折舊的。
# Modify.........: No.MOD-870156 08/07/17 By Sarah 當aza26='2'時,l_name='afax300',aza26!='2'時,l_name='afax300_1'
# Modify.........: No.MOD-890112 08/10/29 By wujie 從fan_file中選取資料時，應區分附號
# Modify.........: No.FUN-890122 08/11/26 By Sarah 調整增加條件查詢與條件儲存功能
# Modify.........: No.MOD-920105 09/02/07 By Sarah 判斷fan_file資料年度與畫面輸入年度相同時,就把這筆資料放在本期折舊,不同時就放在前期折舊
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980136 09/09/03 By sabrina x300_presum的SQL條件下錯了。
# Modify.........: No:MOD-A40056 10/04/13 By sabrina 若附件已報廢，則主件無法印出
# Modify.........: No:CHI-A50027 10/05/26 By Summer 增加"區別部門"
# Modify.........: No:MOD-B70046 11/07/06 By Dido 區別部門改用預設值給予,不用手動調整 
# Modify.........: No:CHI-B70033 11/09/26 By johung 需考慮當月有作折舊調整的fan資料
# Modify.........: No:MOD-BA0059 11/10/11 By johung 當月出售也需納入
# Modify.........: No:CHI-BA0048 11/12/23 By ck2yuan 增加faj04/faj05/faj02/faj022 開窗
# Modify.........: No:MOD-C30055 12/03/09 By Polly 調整判斷，上線前已銷帳者，不可印出
# Modify.........: No:MOD-C30794 12/03/20 By Polly 調整日期抓取的格式判斷
# Modify.........: No:MOD-C40030 12/04/05 By Polly 當月有提折舊且做銷帳，也需列印出來
# Modify.........: No:MOD-C40130 12/04/26 By Polly 上月有調整折舊資產，印出本期折舊金額會錯誤
# Modify.........: No:TQC-C50106 12/05/14 By xuxz 隱藏tm.b對應欄位
# Modify.........: NO.CHI-CA0063 12/11/02 By Belle 修改折舊金額計算方式
# Modify.........: No:MOD-CB0043 12/11/08 by Polly 調整抓取資產日期判斷
# Modify.........: No:CHI-CB0023 13/01/30 by Lori  資產有調整帳時，應納入擷取範圍
# Modify.........: No:FUN-D30060 13/03/20 By wangrr CR转为XtraGrid報表,畫面檔上小計條件去除  
# Modify.........: No:FUN-D40129 13/05/15 By yangtt 1、fan06欄位新增開窗
#                                                   2、報表中添加【資產類型說明】【次類型說明】【部門名稱】欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580010  --start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5         #No.FUN-680070 SMALLINT
END GLOBALS
 
    DEFINE tm  RECORD                           # Print condition RECORD
                wc      STRING,                 # Where condition
                wc2     STRING,                 # Where condition
                yyyy    LIKE type_file.num5,                 # 資料年度       #No.FUN-680070 SMALLINT
                mm      LIKE type_file.num5,                 # 資料月份       #No.FUN-680070 SMALLINT
                s       LIKE type_file.chr3,                  # Order by sequence       #No.FUN-680070 VARCHAR(3)
                t       LIKE type_file.chr3,                  # Eject sw       #No.FUN-680070 VARCHAR(3)
               #c       LIKE type_file.chr3,                  # subtotal       #No.FUN-680070 VARCHAR(3) #FUN-D30060 mark
                a       LIKE type_file.chr1,                  # 1.明細 2.彙總       #No.FUN-680070 VARCHAR(1)
                b       LIKE type_file.chr1,                  # 1.管理部門 2.被分攤部門 #CHI-A50027 add
                more    LIKE type_file.chr1                   # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20   # Report Heading & prompt       #No.FUN-680070 VARCHAR(15)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_head1         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(400)
#No.FUN-580010  --end
 
DEFINE   l_table         STRING                      #NO.FUN-7B0139
DEFINE   g_sql           STRING                      #NO.FUN-7B0139
DEFINE   g_str           STRING                      #NO.FUN-7B0139
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
#NO.FUN-7B0139-------start-------
   LET g_sql = "faj02.faj_file.faj02,",
               "faj022.faj_file.faj022,",
               "faj04.faj_file.faj04,",
               "faj05.faj_file.faj05,",
               "faj06.faj_file.faj06,",
               "faj07.faj_file.faj07,",
               "faj14.faj_file.faj14,",
               "faj20.faj_file.faj20,",
               "faj23.faj_file.faj23,",
               "faj24.faj_file.faj24,",
               "faj26.faj_file.faj26,",
               "faj29.faj_file.faj29,",
               "fan03.fan_file.fan03,",
               "fan04.fan_file.fan04,",
               "fan05.fan_file.fan05,",
               "fan06.fan_file.fan06,",
               "fan07.fan_file.fan07,",
               "fan09.fan_file.fan09,",
               "fan14.fan_file.fan14,",
               "fan15.fan_file.fan15,",
               "pre_d.fan_file.fan15,",
               "curr_d.fan_file.fan15,",
               "curr.fan_file.fan15,",
               "curr_val.fan_file.fan15,",
               "cost.fan_file.fan15,",
               "fan17.fan_file.fan17,",
               "str01.type_file.chr100,", #FUN-D30060 存儲faj29+'月'字符串
               "azi04.azi_file.azi04,",   #FUN-D30060
               "azi05.azi_file.azi05,",   #FUN-D30060
               "fab02.fab_file.fab02,",   #FUN-D40129
               "fac02.fac_file.fac02,",   #FUN-D40129
               "gem02.gem_file.gem02"     #FUN-D40129

   LET l_table = cl_prt_temptable('afax300',g_sql) CLIPPED                                                                          
   IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                              
             " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                           
             "        ?,?,?,?,?, ?,?,?,?,?,",                                                                                           
             "        ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?)"   #FUN-D30060 add 3?   #FUN-D40129 add 3?
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                              
   END IF                                 
#NO.FUN-7B0139-------end-------
 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.yyyy  = ARG_VAL(9)
   LET tm.mm    = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)   #TQC-610055
   LET tm.t  = ARG_VAL(12)
  #LET tm.c  = ARG_VAL(13) #FUN-D30060 mark
   LET tm.a  = ARG_VAL(13) #FUN-D30060 mod 14->13
  #LET tm.b  = ARG_VAL(15)   #CHI-A50027 add#TQC-C50106 mark
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)  #CHI-A50027 mod 15->16 #FUN-D30060 mod 16->14
   LET g_rep_clas = ARG_VAL(15)  #CHI-A50027 mod 16->17 #FUN-D30060 mod 17->15
   LET g_template = ARG_VAL(16)  #CHI-A50027 mod 17->18 #FUN-D30060 mod 18->16
   LET g_rpt_name = ARG_VAL(17)  #No:FUN-7C0078  #CHI-A50027 mod 18->19 #FUN-D30060 mod 19->17
   #No.FUN-570264 ---end---
   #Polly
#No.CHI-6A0004--begin
#   SELECT azi03,azi04,azi05
#     INTO g_azi03,g_azi04,g_azi05#幣別檔小數位數讀取
#     FROM azi_file
#    WHERE azi01=g_aza.aza17
#No.CHI-6A0004--end
   #
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL x300_tm(0,0)            # Input print condition
      ELSE CALL afax300()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION x300_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
            lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-890122 add
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW x300_w AT p_row,p_col WITH FORM "afa/42f/afax300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '123'
  #LET tm.c    = 'Y  ' #FUN-D30060 mark
   LET tm.t    = 'Y  '
   LET tm.a    = '1'
  #LET tm.b    = '1'  #CHI-A50027 add#TQC-C50106 mark
   LET tm.yyyy = g_faa.faa07
   LET tm.mm   = g_faa.faa08
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
  #LET tm2.u1   = tm.c[1,1]  #FUN-D30060 mark
  #LET tm2.u2   = tm.c[2,2]  #FUN-D30060 mark
  #LET tm2.u3   = tm.c[3,3]  #FUN-D30060 mark
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF #FUN-D30060 mark
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF #FUN-D30060 mark
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF #FUN-D30060 mark
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj022,faj06
         #No.FUN-890122 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-890122 ---end---
 
         ON ACTION locale
           #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
         #-----CHI-BA0048 str  add -----
         ON ACTION controlp
           CASE 
              WHEN INFIELD(faj02)   #財產編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.multiret_index = 1
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj02
                 NEXT FIELD faj02
              WHEN INFIELD(faj022)   #財產編號附號
                 CALL cl_init_qry_var() 
                 LET g_qryparam.state = "c" 
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.multiret_index = 2
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj022
                 NEXT FIELD faj022
              WHEN INFIELD(faj04)   #資產類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fab"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj04
                 NEXT FIELD faj04
              WHEN INFIELD(faj05)   #次要類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fac"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO faj05
                 NEXT FIELD faj05

              OTHERWISE EXIT CASE
          END CASE
         #-----CHI-BA0048 end  add ----- 
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
 
         #No.FUN-890122 --start--
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW x300_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      CONSTRUCT BY NAME tm.wc2 ON fan06
         #No.FUN-890122 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
         #FUN-D40129---add---str--
         ON ACTION controlp
           CASE
              WHEN INFIELD(fan06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fan06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fan06
                 NEXT FIELD fan06
           END CASE
         #FUN-D40129---add---end--
 
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
 
         #No.FUN-890122 --start--
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW x300_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME
            tm.yyyy,tm.mm,tm.a,tm2.s1,tm2.s2,tm2.s3,   #CHI-A50027 add tm.b  #TQC-C50106 del tm.b
           #tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.more #FUN-D30060 mark
            tm2.t1,tm2.t2,tm2.t3,tm.more  #FUN-D30060
            WITHOUT DEFAULTS
         #No.FUN-890122 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-890122 ---end---
         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN
               NEXT FIELD mm
            END IF
         AFTER FIELD a
            IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL THEN
               NEXT FIELD a
          #TQC-C50106 mark---str
          ##-MOD-B70046-add-
          # ELSE
          #    IF tm.a = '1' THEN 
          #       LET tm.b = '1' 
          #    END IF
          #    IF tm.a = '2' THEN 
          #       LET tm.b = '2' 
          #    END IF
          #    DISPLAY BY NAME tm.b
          ##-MOD-B70046-end-
          #TQC-C50106 mark--end
            END IF
        #-MOD-B70046-mark-
        ##CHI-A50027 add --start--
        #AFTER FIELD b
        #   IF tm.b NOT MATCHES "[12]" OR tm.b IS NULL THEN
        #      NEXT FIELD b
        #   END IF
        ##CHI-A50027 add --end--
        #-MOD-B70046-end-
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()        # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            #LET tm.c = tm2.u1,tm2.u2,tm2.u3  #FUN-D30060 mark
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
         #No.FUN-890122 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-890122 ---end---
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW x300_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afax300'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afax300','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                       #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.wc2 CLIPPED,"'",
                        " '",tm.yyyy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                       #" '",tm.c CLIPPED,"'", #FUN-D30060 mark
                        " '",tm.a CLIPPED,"'",
                       #" '",tm.b CLIPPED,"'",  #CHI-A50027 add#TQC-C50106 mark
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afax300',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW x300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afax300()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW x300_w
END FUNCTION
 
FUNCTION afax300()
   DEFINE l_name        LIKE type_file.chr20,                 # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#         l_time        LIKE type_file.chr8                   #No.FUN-6A0069
#         l_sql         LIKE type_file.chr1000,               # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_sql         STRING,                               # MOD-710104 
          l_chr         LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
          l_flag        LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,               #No.FUN-680070 VARCHAR(40)
          l_order       ARRAY[6] OF LIKE faj_file.faj06,      #No.FUN-680070 VARCHAR(20)
          sr            RECORD order1 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               order3 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
                               faj02  LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,   #附號
                               faj04  LIKE faj_file.faj04,    #主類別
                               faj05  LIKE faj_file.faj05,    #次類別
                               faj06  LIKE faj_file.faj06,    #中文名稱
                               faj07  LIKE faj_file.faj07,    #英文名稱
                               faj14  LIKE faj_file.faj14,
                               faj20  LIKE faj_file.faj20,    #保管部門
                               faj23  LIKE faj_file.faj23,    #分攤方式
                               faj24  LIKE faj_file.faj24,    #分攤部門(類別)
                               faj26  LIKE faj_file.faj26,    #入帳日期
                               faj29  LIKE faj_file.faj29     #耐用年限
                        END RECORD,
          sr2           RECORD
                               fan03    LIKE fan_file.fan03,    #年度
                               fan04    LIKE fan_file.fan04,    #月份
                               fan05    LIKE fan_file.fan05,    #分攤方式
                               fan06    LIKE fan_file.fan06,    #部門
                               fan07    LIKE fan_file.fan07,    #折舊金額
                               fan09    LIKE fan_file.fan09,    #被攤部門
                               fan14    LIKE fan_file.fan14,    #成本
                               fan15    LIKE fan_file.fan15,    #累折
                               pre_d    LIKE fan_file.fan15,    #前期折舊
                               curr_d   LIKE fan_file.fan15,    #本期折舊
                               curr     LIKE fan_file.fan15,    #本月折舊
                               curr_val LIKE fan_file.fan15,    #帳面價值
                               cost     LIKE fan_file.fan15,    #No.CHI-480001
                               fan17    LIKE fan_file.fan17     #No.CHI-480001
                        END RECORD
   DEFINE l_i,l_cnt     LIKE type_file.num5     #No.FUN-680070 SMALLINT
   DEFINE l_zaa02       LIKE zaa_file.zaa02
   DEFINE l_fan03       LIKE type_file.chr4     #TQC-630111       #No.FUN-680070 VARCHAR(4)
   DEFINE l_fan04       LIKE type_file.chr2     #TQC-630111       #No.FUN-680070 VARCHAR(2)
   DEFINE l_fan03_fan04 LIKE type_file.chr6     #TQC-630111       #No.FUN-680070 VARCHAR(6)
   DEFINE l_faj27       LIKE type_file.chr6     #MOD-710104
   DEFINE l_faj272      LIKE type_file.chr6     #MOD-C30794 add
   DEFINE l_count       LIKE type_file.num5     #MOD-A40056 add
   #CHI-B70033 -- begin --
   DEFINE l_adj_fan07   LIKE fan_file.fan07,
          l_adj_fan07_1 LIKE fan_file.fan07,
          l_adj_fap54   LIKE fap_file.fap54,
          l_curr_fan07  LIKE fan_file.fan07,
          l_pre_fan15   LIKE fan_file.fan15
   #CHI-B70033 -- end --
  DEFINE l_fan07_sum   LIKE fan_file.fan07    #CHI-CB0023
  DEFINE l_str01       LIKE type_file.chr100  #FUN-D30060
  DEFINE l_fab02       LIKE fab_file.fab02    #FUN-D40129
  DEFINE l_fac02       LIKE fac_file.fac02    #FUN-D40129
  DEFINE l_gem02       LIKE gem_file.gem02    #FUN-D40129
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-7B0139                                                     
     CALL cl_del_data(l_table)                                  #No.FUN-7B0139
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     LET l_faj27 = tm.yyyy||(tm.mm USING '&&')  #MOD-710104
     LET l_faj272 = tm.yyyy||tm.mm              #MOD-C30794 add
 
     LET l_sql = "SELECT '','','',",
                 " faj02,faj022,faj04,faj05,faj06,faj07,faj14,faj20,",
                 " faj23,faj24,faj26,faj29",
                 " FROM faj_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND fajconf = 'Y'",
                 " AND faj28 <> '0'",   #MOD-740026
                #MOD-710104 start
                #" AND ((faj27[1,4]='",tm.yyyy USING '&&&&',"' ",
                #"      AND faj27[5,6]<='",tm.mm USING '&&',"')",
                #"      AND (faj43 <> '5' OR faj43 <> '6')",   #TQC-630111
                #"      OR (faj27[1,4]<'",tm.yyyy USING '&&&&',"'))"
                 " AND faj27 <= '",l_faj27,"'",
                 " AND (faj02 NOT IN (SELECT fap02 FROM fap_file ",
                #"      WHERE CONVERT(CHAR(6),fap04,112) <= '",l_faj27,"'",   #MOD-A40056 mark
                #"      WHERE (YEAR(fap04)||MONTH(fap04)) <= '",l_faj27,"'",   #MOD-A40056 add #MOD-C30794 mark
                #"      WHERE (YEAR(fap04)||MONTH(fap04)) <= '",l_faj272,"'",                                                 #MOD-C30794 add ##MOD-CB0043 mark
                 "      WHERE ((YEAR(fap04) < ",tm.yyyy,") OR (YEAR(fap04) = ",tm.yyyy," AND MONTH(fap04) < ",tm.mm,"))",     #MOD-CB0043 add
                #"      AND fap77 IN ('5','6')) ",        #MOD-A40056 mark       
                 "      AND fap77 IN ('5','6') ",         #MOD-A40056 add    
                 "      AND fap021 = faj022) ",           #MOD-A40056 add     
                 "      OR faj02 IN (SELECT fan01 FROM fan_file ",
                 "      WHERE fan03 = ",tm.yyyy," AND fan04 = ",tm.mm,
#                "        AND fan07 > 0 )) "
                 "        AND fan07 > 0 AND fan02 =faj022)) "     #No.MOD-890112
                #MOD-710104 end
     PREPARE x300_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
     END IF
     DECLARE x300_cs1 CURSOR FOR x300_prepare1
 
     #--->取每筆資產本年度月份折舊
     LET l_sql = " SELECT fan03, fan04, fan05, fan06, fan07,",
                 #" fan09, fan14, fan15,0,fan08,0,0,fan17 ",   #No.CHI-480001   #MOD-730123
                 " fan09, fan14, fan15,0,fan08,0,0,0,fan17 ",   #No.CHI-480001   #MOD-730123
                 " FROM fan_file ",
                 " WHERE fan01 = ? AND fan02 = ? ",
                 "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
                 "   AND (fan041 = '1' OR fan041 = '0') ",   #No.FUN-560268
                 "   AND ",tm.wc2
     CASE
        WHEN tm.a = '1' #--->分攤前
          LET l_sql = l_sql clipped ," AND fan05 != '3' " clipped
        WHEN tm.a = '2' #--->分攤後
          LET l_sql = l_sql clipped ," AND fan05 != '2' " clipped
        OTHERWISE EXIT CASE
     END CASE
     PREPARE x300_prefan  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
     END IF
     DECLARE x300_csfan CURSOR FOR x300_prefan
 
     LET l_sql = "SELECT SUM(fan15),SUM(fan17) FROM fan_file ",  #No.CHI-480001
                 " WHERE fan01 = ? AND fan02 = ? ",
                 "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
                #"   AND fan041 = '1'",                    #MOD-980136 mark
                 "   AND (fan041 = '1' OR fan041 = '0')",  #MOD-980136 add
                 "   AND fan06 = ? "
     CASE
        WHEN tm.a = '1' #--->分攤前
           LET l_sql = l_sql CLIPPED ," AND fan05 != '3' " CLIPPED
        WHEN tm.a = '2' #--->分攤後
           LET l_sql = l_sql CLIPPED ," AND fan05 != '2' " CLIPPED
        OTHERWISE EXIT CASE
     END CASE
     PREPARE x300_presum FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('presum:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
     END IF
     DECLARE x300_cssum CURSOR FOR x300_presum
 
#NO.FUN-7B0139---------mark---start-----
#    CALL cl_outnam('afax300') RETURNING l_name
 
#No.FUN-580010 --start
     IF g_aza.aza26 = '2' THEN
#       LET g_zaa[44].zaa06 = "N"   #MOD-620069
       #LET l_name = 'afax300_1'    #NO.FUN-7B0139   #MOD-870156 mark
        LET l_name = 'afax300'      #NO.FUN-7B0139   #MOD-870156
     ELSE
#       LET g_zaa[44].zaa06 = "Y"   #MOD-620069
       #LET l_name = 'afax300'      #NO.FUN-7B0139   #MOD-870156 mark
        LET l_name = 'afax300_1'    #NO.FUN-7B0139   #MOD-870156
     END IF
#    CALL cl_prt_pos_len()
#No.FUN-580010 --end
#
#    START REPORT x300_rep TO l_name
#    LET g_pageno = 0
#O.FUN-7B0139------end------
 
     FOREACH x300_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_flag = 'Y'
#NO.FUN-7B0139-------mark---start----
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
#                                       LET g_descripe[g_i]=g_x[15]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
#                                       LET g_descripe[g_i]=g_x[16]
#              #--No.MOD-490182
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
#                                       LET g_descripe[g_i]=g_x[17]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
#                                       LET g_descripe[g_i]=g_x[21]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
#                                       LET g_descripe[g_i]=g_x[18]
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fan06
#                                       LET g_descripe[g_i]=g_x[19]
#              #--END
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#+NO.FUN-7B0139-------end----------------
      #MOD-A40056---add---satrt---
      #上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_count FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022  
          AND fap77 IN ('5','6') 
         #AND (YEAR(fap04)||MONTH(fap04)) <= l_faj27   #MOD-BA0059 mark
         #AND (YEAR(fap04)||MONTH(fap04)) < l_faj27    #MOD-BA0059 #MOD-C30794 mark
         #AND (YEAR(fap04)||MONTH(fap04)) < l_faj272                                           #MOD-C30794 add #MOD-CB0043 mark
          AND ((YEAR(fap04) < tm.yyyy) OR (YEAR(fap04) = tm.yyyy AND MONTH(fap04) < tm.mm))    #MOD-CB0043 add
      #上線前已銷帳者，應不可印出
      #----------------MOD-C40030----------------(M)
      #IF l_count=0 THEN
      #   SELECT COUNT(*) INTO l_count FROM faj_file
      #    WHERE faj02=sr.faj02 AND faj022=sr.faj022
      #      AND faj43='6' 
      #     #AND (YEAR(fap04)||MONTH(fap04)) <= l_faj27   #MOD-C30055 mark
      #      AND faj27 <= l_faj27                         #MOD-C30055 add
      #END IF
      #----------------MOD-C40030----------------(M)
       IF l_count > 0 THEN 
          CONTINUE FOREACH 
       END IF
      #MOD-A40056---add---end---
       #--->篩選部門
       INITIALIZE sr2.* TO NULL
       FOREACH x300_csfan USING sr.faj02,sr.faj022
          INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('x300_csfan:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET l_flag = 'N'
          OPEN x300_cssum USING sr.faj02,sr.faj022,sr2.fan06
          FETCH x300_cssum INTO sr2.fan15,sr2.fan17        #No.CHI-480001
 
          IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
          IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
          IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
          IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
          IF cl_null(sr2.fan14) THEN LET sr2.fan14 = 0 END IF
          IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
          IF cl_null(sr2.fan17) THEN LET sr2.fan17 = 0 END IF    #No.CHI-480001
         #---------------------------MOD-C40130---------------------(S)
         #CHI-B70033 -- begin --
         #LET l_adj_fan07 = 0
         #LET l_adj_fap54 = 0
         #CALL x300_chk_adj(sr.faj02,sr.faj022,sr2.fan15)           #MOD-C40130 mark
         #   RETURNING l_adj_fan07,l_adj_fan07_1,l_adj_fap54        #MOD-C40130 mark
         #CALL x300_chk_adj(sr.faj02,sr.faj022,sr2.fan15,tm.mm)               #CHI-CA0063 mark #MOD-C40130 add
          CALL x300_chk_adj(sr.faj02,sr.faj022,sr2.fan15,tm.mm,sr2.fan06)     #CHI-CA0063
             RETURNING l_adj_fan07,l_adj_fan07_1,l_adj_fap54
         #LET sr2.fan15 = sr2.fan15 + l_adj_fan07                   #MOD-C40130 mark
          LET sr2.fan07 = sr2.fan07 + l_adj_fan07_1                 #MOD-C40130 mark
         #LET sr2.curr_d = sr2.curr_d + l_adj_fan07                 #MOD-C40130 mark
         #LET sr2.fan14 = sr2.fan14 + l_adj_fap54                   #MOD-C40130 mark
          LET sr2.fan15 = sr2.fan15
          LET sr2.curr_d = sr2.curr_d
          LET sr2.fan14 = sr2.fan14
         #CHI-B70033 -- end --
         #---------------------------MOD-C40130---------------------(S)
          #--->本月折舊
          LET sr2.curr = sr2.fan07
#-----MOD-620069---------
          #--->前期折舊 = (累折 - 本期累折)
          IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN
             LET sr2.pre_d = 0
          ELSE
#            IF sr2.curr_d > 0 THEN                      #MOD-820130
                #LET sr2.pre_d = sr2.curr_d - sr2.fan07   #MOD-730123
                LET sr2.pre_d = sr2.fan15 - sr2.curr_d   #MOD-730123
#            ELSE                                        #MOD-820130           
#               LET sr2.pre_d = 0                        #MOD-820130
#            END IF                                      #MOD-820130       
          END IF
#MOD-530529
#         #--->前期折舊 = (累折 - 本期折舊)
#         IF sr2.fan15 > 0 THEN
#            LET sr2.pre_d   = sr2.fan15 - sr2.curr_d
#         ELSE
#            LET sr2.pre_d = 0
#         END IF
#END MOD-530529
#-----END MOD-620069-----
          #--->帳面價值 = (成本 - 累積折舊)
          LET sr2.curr_val = sr2.fan14-sr2.fan15
          #No.CHI-480001
          #--->資產淨額 = (帳面價值 - 減值準備)
          LET sr2.cost = sr2.curr_val - sr2.fan17
          #end
          #No.+364 010705 add by linda 不加此段無法依部門合計
#NO.FUN-7B0139--------start------mark----------
#         FOR g_i = 1 TO 3
#            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
#                                          LET g_descripe[g_i]=g_x[15]
#                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
#                                          LET g_descripe[g_i]=g_x[16]
#                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
#                                          LET g_descripe[g_i]=g_x[18]
#                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
#                                          LET g_descripe[g_i]=g_x[21]
#                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
#                                          LET g_descripe[g_i]=g_x[19]
#                 WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fan06
#                                          LET g_descripe[g_i]=g_x[20]
#                 OTHERWISE LET l_order[g_i] = '-'
#            END CASE
#         END FOR
#         LET sr.order1 = l_order[1]
#         LET sr.order2 = l_order[2]
#         LET sr.order3 = l_order[3]
          #No.+364 end---
#         OUTPUT TO REPORT x300_rep(sr.*,sr2.*)
#NO.FUN-7B0139------------------end-------------
          #FUN-D40129---add---str--
          SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01 = sr.faj04
          SELECT fac02 INTO l_fac02 FROM fac_file WHERE fac01 = sr.faj05
          SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr2.fan06
          #FUN-D40129---add---end--
#NO.FUN-7B0139------start-------
          LET l_str01=sr.faj29,cl_getmsg('anm-157',g_lang) #FUN-D30060
          EXECUTE insert_prep USING
             sr.faj02, sr.faj022, sr.faj04, sr.faj05,    sr.faj06,
             sr.faj07, sr.faj14,  sr.faj20, sr.faj23,    sr.faj24,
             sr.faj26, sr.faj29,  sr2.fan03,sr2.fan04,   sr2.fan05,
             sr2.fan06,sr2.fan07, sr2.fan09,sr2.fan14,   sr2.fan15,
             sr2.pre_d,sr2.curr_d,sr2.curr, sr2.curr_val,sr2.cost,
             sr2.fan17,l_str01,g_azi04,g_azi05  #FUN-D30060 add l_str01,g_azi04,g_azi05
             ,l_fab02,l_fac02,l_gem02  #FUN-D40129
#NO.FUN-7B0139-------end--------
       END FOREACH
       IF l_flag ='Y' THEN
          #-----TQC-630111---------
          #--->若已折畢,抓取每筆資產最後一次折舊資料
          #LET l_sql = " SELECT MAX(fan03||fan04) FROM fan_file ",   #MOD-710052
          LET l_sql = " SELECT MAX(fan03*100+fan04) FROM fan_file ",   #MOD-710052
                      " WHERE fan01 = ? AND fan02 = ?",
                     #"   AND (fan041 = '1' OR fan041 = '0') ",        #CHI-CB0023 mark
                      "   AND (fan03*100+fan04) < ?",                  #MOD-C40130 add
                      "   AND ",tm.wc2
          PREPARE pre_fan03_fan04 FROM l_sql
         #EXECUTE pre_fan03_fan04 USING sr.faj02,sr.faj022 INTO l_fan03_fan04           #MOD-C40130 mark
          EXECUTE pre_fan03_fan04 USING sr.faj02,sr.faj022,l_faj27 INTO l_fan03_fan04   #MOD-C40130 add
          LET l_fan03 = l_fan03_fan04[1,4]
          LET l_fan04 = l_fan03_fan04[5,6]
 
         #str MOD-920105 mod
         #LET l_sql = " SELECT fan03, fan04, fan05, fan06, 0,",
         #            " fan09, fan14, fan15,0,fan08,0,0,0,fan17 "
          IF l_fan03 = tm.yyyy THEN
             LET l_sql = " SELECT fan03, fan04, fan05, fan06, 0,",
                         " fan09, fan14, fan15,0,fan08,0,0,0,fan17 "
          ELSE
             LET l_sql = " SELECT fan03, fan04, fan05, fan06, 0,",
                         " fan09, fan14, fan15,fan08,0,0,0,0,fan17 "
          END IF
         #end MOD-920105 mod
          LET l_sql = l_sql CLIPPED,
                      " FROM fan_file ",
                      " WHERE fan01 = ? AND fan02 = ? ",
                      "   AND fan03 = ? AND fan04 = ? ",
                      "   AND (fan041 = '1' OR fan041 = '0') ",
                      "   AND ",tm.wc2
          CASE
             WHEN tm.a = '1' #--->分攤前
                LET l_sql = l_sql clipped ," AND fan05 != '3' " clipped
             WHEN tm.a = '2' #--->分攤後
                LET l_sql = l_sql clipped ," AND fan05 != '2' " clipped
             OTHERWISE EXIT CASE
          END CASE
          PREPARE x300_prefan2  FROM l_sql
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
             EXIT PROGRAM
          END IF
          DECLARE x300_csfan2 CURSOR FOR x300_prefan2
 
          FOREACH x300_csfan2 USING sr.faj02,sr.faj022,l_fan03,l_fan04
             INTO sr2.*
          #-----END TQC-630111-----
             IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
             IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
             IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
             IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
             IF cl_null(sr2.fan14) THEN LET sr2.fan14 = 0 END IF
             IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
             IF cl_null(sr2.fan17) THEN LET sr2.fan17 = 0 END IF    #No.CHI-480001

             #CHI-B70033 -- begin --
             LET l_adj_fan07 = 0
             LET l_adj_fap54 = 0
            #CALL x300_chk_adj(sr.faj02,sr.faj022,sr2.fan15)           #MOD-C40130 mark
            #CALL x300_chk_adj(sr.faj02,sr.faj022,sr2.fan15,l_fan04)      #CHI-CA0063 mark #MOD-C40130 add
             CALL x300_chk_adj(sr.faj02,sr.faj022,sr2.fan15,l_fan04,'')   #CHI-CA0063
                RETURNING l_adj_fan07,l_adj_fan07_1,l_adj_fap54
             LET sr2.fan15 = sr2.fan15 + l_adj_fan07
             LET sr2.fan07 = sr2.fan07 + l_adj_fan07_1
             LET sr2.curr_d = sr2.curr_d + l_adj_fan07
             LET sr2.fan14 = sr2.fan14 + l_adj_fap54
             #CHI-B70033 -- end --

             #--->本月折舊
             LET sr2.curr = sr2.fan07
             #-----MOD-620069---------
             #--->前期折舊 = (累折 - 本期累折)
             IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN
                LET sr2.pre_d = 0
             ELSE
#               IF sr2.curr_d > 0 THEN                      #MOD-820130   
                   #LET sr2.pre_d = sr2.curr_d - sr2.fan07   #MOD-730123
                   LET sr2.pre_d = sr2.fan15 - sr2.curr_d   #MOD-730123
#               ELSE                                        #MOD-820130      
#                  LET sr2.pre_d = 0                        #MOD-820130
#               END IF                                      #MOD-820130
             END IF
             ##MOD-530529
             #         #--->前期折舊 = (累折 - 本期折舊)
             #         IF sr2.fan15 > 0 THEN
             #            LET sr2.pre_d   = sr2.fan15 - sr2.curr_d
             #         ELSE
             #            LET sr2.pre_d = 0
             #         END IF
             ##END MOD-530529
             #-----END MOD-620069-----
             #--->帳面價值 = (成本 - 累積折舊)
             LET sr2.curr_val = sr2.fan14-sr2.fan15
             #No.CHI-480001
             #--->資產淨額 = (帳面價值 - 減值準備)
             LET sr2.cost = sr2.curr_val - sr2.fan17
             #end
#            OUTPUT TO REPORT x300_rep(sr.*,sr2.*)     #NO.FUN-7B0139
 
#NO.FUN-7B0139------start-------
             LET l_str01=sr.faj29,cl_getmsg('anm-157',g_lang) #FUN-D30060
             #FUN-D40129---add---str--
             SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01 = sr.faj04
             SELECT fac02 INTO l_fac02 FROM fac_file WHERE fac01 = sr.faj05
             SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr2.fan06
             #FUN-D40129---add---end--
             EXECUTE insert_prep USING
                sr.faj02, sr.faj022, sr.faj04, sr.faj05,    sr.faj06,
                sr.faj07, sr.faj14,  sr.faj20, sr.faj23,    sr.faj24,
                sr.faj26, sr.faj29,  sr2.fan03,sr2.fan04,   sr2.fan05,
                sr2.fan06,sr2.fan07, sr2.fan09,sr2.fan14,   sr2.fan15,
                sr2.pre_d,sr2.curr_d,sr2.curr, sr2.curr_val,sr2.cost,
                sr2.fan17,l_str01,g_azi04,g_azi05  #FUN-D30060 add l_str01,g_azi04,g_azi05
                ,l_fab02,l_fac02,l_gem02  #FUN-D40129
#NO.FUN-7B0139-------end--------
          END FOREACH   #TQC-630111
       END IF
    END FOREACH
 
#   FINISH REPORT x300_rep                            #NO.FUN-7B0139
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)       #NO.FUN-7B0139
#NO.FUN-7B0139-----------start-----
    IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06')                                                                 
       RETURNING tm.wc                                                                                                             
    END IF                                                                                                                         
###XtraGrid###    LET g_str = tm.wc,";",tm.yyyy,";",tm.mm,";",tm.s[1,1],";",                                                 
###XtraGrid###                tm.s[2,2],";",tm.s[3,3],";",g_azi04,";",g_azi05,";",
###XtraGrid###                tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",                                             
###XtraGrid###                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.a   #CHI-A50027 add tm.b #TQC-C50106 mod  tm.b---->tm.a                                            
                                                                                                             
###XtraGrid###    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
###XtraGrid###    CALL cl_prt_cs3('afax300',l_name,g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    #FUN-D30060--add--str--
    LET g_xgrid.order_field=cl_get_order_field(tm.s,"faj04,faj05,faj02,faj022,faj06,fan06")
    LET g_xgrid.grup_field=cl_get_order_field(tm.s,"faj04,faj05,faj02,faj022,faj06,fan06")
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"faj04,faj05,faj02,faj022,faj06,fan06")
    LET g_xgrid.condition=cl_getmsg('lib-160',g_lang),tm.wc
    LET g_xgrid.headerinfo1=tm.yyyy,cl_getmsg('anm-156',g_lang),tm.mm,cl_getmsg('anm-157',g_lang)
    IF g_aza.aza26='2' THEN
       LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"cost","Y")
    ELSE
       LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"cost","N")
    END IF
    #FUN-D30060--add--end
    CALL cl_xg_view()    ###XtraGrid###
#NO.FUN-7B0139----------end----
END FUNCTION
 
#CHI-B70033 -- begin --
#判斷是否要回傳調整金額
#FUNCTION x300_chk_adj(p_faj02,p_faj022,p_fan15)          #MOD-C40130 mark
#FUNCTION x300_chk_adj(p_faj02,p_faj022,p_fan15,p_fan04)          #CHI-CA0063 mark #MOD-C40130 add
FUNCTION x300_chk_adj(p_faj02,p_faj022,p_fan15,p_fan04,p_fan06)   #CHI-CA0063
   DEFINE p_faj02       LIKE faj_file.faj02,
          p_faj022      LIKE faj_file.faj022,
          p_fan15       LIKE fan_file.fan15,
          l_adj_fan07   LIKE fan_file.fan07,
          l_adj_fan07_1 LIKE fan_file.fan07,
          l_adj_fap54   LIKE fap_file.fap54,
          l_curr_fan07  LIKE fan_file.fan07,
          l_pre_fan15   LIKE fan_file.fan15,
          l_cnt         LIKE type_file.num5,
          p_fan04       LIKE type_file.num5,              #MOD-C40130 add
          l_yy          LIKE type_file.num5               #MOD-C40130 add
         ,p_fan06       LIKE fan_file.fan06               #CHI-CA0063

   LET l_cnt = 0
   LET l_adj_fan07 = 0
   SELECT COUNT(*) INTO l_cnt FROM fan_file
    WHERE fan01 = p_faj02 AND fan02 = p_faj022
      AND fan03 = tm.yyyy AND fan04 = tm.mm
      AND fan041 = '1'

   
  #-----------------------MOD-C40130-----------------------(S)

  #調整折舊
  #SELECT fan07 INTO l_adj_fan07 FROM fan_file         #MOD-C40130 mark
  # WHERE fan01 = p_faj02 AND fan02 = p_faj022         #MOD-C40130 mark
  #   AND fan03 = tm.yyyy AND fan04 = tm.mm            #MOD-C40130 mark
  #   AND fan03 = l_yy                                 #MOD-C40130 mark
  #   AND fan041 = '2'                                 #MOD-C40130 mark

   LET p_fan04 = p_fan04 + 1
   LET l_yy = tm.yyyy
   IF p_fan04 = '13' THEN
      LET p_fan04 = '1'
      LET l_yy = l_yy + 1
   END IF

   #調整本期折舊
   SELECT SUM(fan07) INTO l_adj_fan07 FROM fan_file
    WHERE fan01 = p_faj02 AND fan02 = p_faj022
      AND fan03 = l_yy
      AND fan04 BETWEEN p_fan04 AND tm.mm
      AND fan041 = '2'

   #調整折舊
   IF cl_null(p_fan06) THEN 		   #CHI-CA0063
   SELECT fan07 INTO l_adj_fan07_1 FROM fan_file
    WHERE fan01 = p_faj02 AND fan02 = p_faj022
      AND fan03 = tm.yyyy AND fan04 = tm.mm
      AND fan041 = '2'
  #CHI-CA0063--(B)--
   ELSE
      SELECT fan07 INTO l_adj_fan07_1 FROM fan_file
       WHERE fan01 = p_faj02 AND fan02 = p_faj022
         AND fan03 = tm.yyyy AND fan04 = tm.mm         
         AND fan041 = '2'
         AND fan06 = p_fan06
   END IF
  #CHI-CA0063--(E)--
  #-----------------------MOD-C40130-----------------------(E)
   IF cl_null(l_adj_fan07) THEN LET l_adj_fan07 = 0 END IF
   IF cl_null(l_adj_fan07_1) THEN LET l_adj_fan07_1 = 0 END IF    #MOD-C40130 add
  #LET l_adj_fan07_1 = l_adj_fan07                                #MOD-C40130 mark

   #調整成本
   SELECT fap54 INTO l_adj_fap54 FROM fap_file
    WHERE fap02 = p_faj02 AND fap021 = p_faj022
      AND YEAR(fap04) = tm.yyyy AND MONTH(fap04) = tm.mm
   IF cl_null(l_adj_fap54) THEN LET l_adj_fap54 = 0 END IF

   IF l_cnt > 0 THEN
      IF g_aza.aza26 <> '2' THEN
         LET l_adj_fan07 = 0
         LET l_adj_fap54 = 0
      ELSE
         #大陸版有可能先折舊再調整
         SELECT fan15 INTO l_pre_fan15 FROM fan_file
          WHERE fan01 = p_faj02 AND fan02 = p_faj022
            AND fan041 = '1'
            AND fan03 || fan04 IN (
                  SELECT MAX(fan03) || MAX(fan04) FROM fan_File
                   WHERE fan01 = p_faj02 AND fan02 = p_faj022
                     AND ((fan03 < tm.yyyy) OR (fan03 = tm.yyyy AND fan04 < tm.mm))
                     AND fan041 = '1')

         SELECT fan07 INTO l_curr_fan07 FROM fan_file
          WHERE fan01 = p_faj02 AND fan02 = p_faj022
            AND fan03 = tm.yyyy AND fan04 = tm.mm
            AND fan041 = '1'
         IF cl_null(l_curr_fan07) THEN LET l_curr_fan07 = 0 END IF

         IF p_fan15 = (l_pre_fan15 + l_curr_fan07 + l_adj_fan07) THEN
            LET l_adj_fan07 = 0
            LET l_adj_fap54 = 0
         END IF
      END IF
   END IF
   RETURN l_adj_fan07,l_adj_fan07_1,l_adj_fap54
END FUNCTION
#CHI-B70033 -- end --

#NO.FUN-7B0139-----------mark-----start-------------------
#REPORT x300_rep(sr,sr2)
#   DEFINE l_last_sw     LIKE type_file.chr1,                  #No.FUN-680070 VARCHAR(1)
#          l_str         LIKE type_file.chr50,                 #列印排列順序說明       #No.FUN-680070 VARCHAR(50)
#          sr            RECORD order1 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
#                               order2 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
#                               order3 LIKE faj_file.faj06,    #No.FUN-680070 VARCHAR(20)
#                               faj02  LIKE faj_file.faj02,    #財編
#                               faj022 LIKE faj_file.faj022,   #附號
#                               faj04  LIKE faj_file.faj04,    #主類別
#                               faj05  LIKE faj_file.faj05,    #次類別
#                               faj06  LIKE faj_file.faj06,    #中文名稱
#                               faj07  LIKE faj_file.faj07,    #英文名稱
#                               faj14  LIKE faj_file.faj14,
#                               faj20  LIKE faj_file.faj20,    #保管部門
#                               faj23  LIKE faj_file.faj23,    #分攤方式
#                               faj24  LIKE faj_file.faj24,    #分攤部門(類別)
#                               faj26  LIKE faj_file.faj26,    #入帳日期
#                               faj29  LIKE faj_file.faj29     #耐用年限
#                        END RECORD,
#          sr2           RECORD
#                               fan03    LIKE fan_file.fan03,    #年度
#                               fan04    LIKE fan_file.fan04,    #月份
#                               fan05    LIKE fan_file.fan05,    #分攤方式
#                               fan06    LIKE fan_file.fan06,    #部門
#                               fan07    LIKE fan_file.fan07,    #折舊金額
#                               fan09    LIKE fan_file.fan09,    #被攤部門
#                               fan14    LIKE fan_file.fan14,    #成本
#                               fan15    LIKE fan_file.fan15,    #累折
#                               pre_d    LIKE fan_file.fan15,    #前期折舊
#                               curr_d   LIKE fan_file.fan15,    #本期折舊
#                               curr     LIKE fan_file.fan15,    #本月折舊
#                               curr_val LIKE fan_file.fan15,    #帳面價值
#                               cost     LIKE fan_file.fan15,    #No.CHI-480001
#                               fan17    LIKE fan_file.fan17     #No.CHI-480001
#                        END RECORD
#-----TQC-680084---------
##-----MOD-620069---------
#DEFINE l_faj29   LIKE faj_file.faj29
#DEFINE l_faj30   LIKE faj_file.faj30
#DEFINE l_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
#DEFINE l_mm      LIKE faj_file.faj29
##-----END MOD-620069-----
#-----END TQC-680084-----
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#No.FUN-580010 --start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=tm.yyyy USING '####',g_x[23] CLIPPED,tm.mm USING '##',g_x[20] CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            #g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],   #TQC-680084
#            g_x[36],g_x[37],g_x[39],g_x[40],   #TQC-680084
#            g_x[41],g_x[42],g_x[43],g_x[44]   #MOD-620069
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.faj04,                                  #主類別
#               COLUMN g_c[32],sr2.fan06,                                #部門
#               COLUMN g_c[33],sr.faj02,                                 #財產編號
#               COLUMN g_c[34],sr.faj022,                                #附號
#               COLUMN g_c[35],YEAR(sr.faj26) USING '####','/',          #入帳年月
#                      MONTH(sr.faj26) USING '&&',
#               COLUMN g_c[36],sr.faj06,                                 #中文名稱No:7661
#            # COLUMN ,sr.faj07,                                 #英文名稱
#               COLUMN g_c[37],sr.faj29 USING '###&',g_x[20] clipped;#耐用年限
#        #-----TQC-680084---------
#       ##-----MOD-620069---------
#       #SELECT faj29,faj30 INTO l_faj29,l_faj30 FROM faj_file
#       #   WHERE faj02=sr.faj02 AND faj022=sr.faj022
#       #LET l_cnt=0
#       #SELECT COUNT(*) INTO l_cnt FROM fan_file
#       #   WHERE fan01=sr.faj02 AND fan02 = sr.faj022 AND
#       #       ((fan03 = tm.yyyy AND fan04>tm.mm) OR
#       #         fan03 > tm.yyyy)
#       #LET l_mm = 0
#       #LET l_mm = l_faj29-l_faj30-l_cnt
#       ##-----END MOD-620069-----
#       #PRINT COLUMN g_c[38],l_mm,   #MOD-620069
#       #-----END TQC-680084-----
#        PRINT  COLUMN g_c[39],cl_numfor(sr2.fan14 ,39,g_azi04),          #成本    #TQC-610106
#               COLUMN g_c[40],cl_numfor(sr2.pre_d ,40,g_azi04),          #前期折舊
#               COLUMN g_c[41],cl_numfor(sr2.curr_d,41,g_azi04),        #本期折舊
#               COLUMN g_c[42],cl_numfor(sr2.curr  ,42,g_azi04) ,         #本月折舊
#               #No.CHI-480001
#               COLUMN g_c[43],cl_numfor(sr2.curr_val,43,g_azi04),      #帳面價值
#               COLUMN g_c[44],cl_numfor(sr2.cost,44,g_azi04)  #資產淨額
#               #end
#
#  AFTER GROUP OF sr.order1
#      IF tm.c[1,1] = 'Y'  THEN
#         PRINTX name=S1
#               COLUMN g_c[33],g_descripe[1],
#               COLUMN g_c[39],cl_numfor(GROUP SUM(sr2.fan14)  ,39,g_azi05),   #成本
#               COLUMN g_c[40],cl_numfor(GROUP SUM(sr2.pre_d)  ,40,g_azi05),   #前期折舊
#               COLUMN g_c[41],cl_numfor(GROUP SUM(sr2.curr_d),41,g_azi05), #本期折舊
#               COLUMN g_c[42],cl_numfor(GROUP SUM(sr2.curr)  ,42,g_azi05),   #本月折舊
#               #No.CHI-480001
#               COLUMN g_c[43],cl_numfor(GROUP SUM(sr2.curr_val),43,g_azi05), #帳值
#               COLUMN g_c[44],cl_numfor(GROUP SUM(sr2.cost),44,g_azi05)
#         PRINT
#       END IF
#
#   AFTER GROUP OF sr.order2
#      PRINT g_dash[1,g_len]
#      IF tm.c[2,2] = 'Y' THEN
#         PRINTX name=S2
#               COLUMN g_c[33],g_descripe[2],
#               COLUMN g_c[39],cl_numfor(GROUP SUM(sr2.fan14) ,39,g_azi05),   #成本
#               COLUMN g_c[40],cl_numfor(GROUP SUM(sr2.pre_d) ,40,g_azi05),   #前期折舊
#               COLUMN g_c[41],cl_numfor(GROUP SUM(sr2.curr_d),41,g_azi05), #本期折舊
#               COLUMN g_c[42],cl_numfor(GROUP SUM(sr2.curr)  ,42,g_azi05),   #本月折舊
#               #No.CHI-480001
#               COLUMN g_c[43],cl_numfor(GROUP SUM(sr2.curr_val),43,g_azi05), #帳值
#               COLUMN g_c[44],cl_numfor(GROUP SUM(sr2.cost),44,g_azi05)
#         PRINT
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.c[3,3] = 'Y'  THEN
#         PRINTX name=S3
#               COLUMN g_c[33],g_descripe[3],
#               COLUMN g_c[39],cl_numfor(GROUP SUM(sr2.fan14) ,39,g_azi05),   #成本
#               COLUMN g_c[40],cl_numfor(GROUP SUM(sr2.pre_d) ,40,g_azi05),   #前期折舊
#               COLUMN g_c[41],cl_numfor(GROUP SUM(sr2.curr_d),41,g_azi05), #本期折舊
#               COLUMN g_c[42],cl_numfor(GROUP SUM(sr2.curr)  ,42,g_azi05),   #本月折舊
#               #No.CHI-480001
#               COLUMN g_c[43],cl_numfor(GROUP SUM(sr2.curr_val),43,g_azi05), #帳值
#               COLUMN g_c[44],cl_numfor(GROUP SUM(sr2.cost),44,g_azi05)
#         PRINT
#      END IF
#
#ON LAST ROW
#      #--No.MOD-490182
#       PRINTX name=S1
#               COLUMN g_c[33],g_x[24] CLIPPED,
#               COLUMN g_c[39],cl_numfor(SUM(sr2.fan14) ,39,g_azi05),   #成本
#               COLUMN g_c[40],cl_numfor(SUM(sr2.pre_d) ,40,g_azi05),   #前期折舊
#               COLUMN g_c[41],cl_numfor(SUM(sr2.curr_d),41,g_azi05), #本期折舊
#               COLUMN g_c[42],cl_numfor(SUM(sr2.curr)  ,42,g_azi05),   #本月折舊
#               COLUMN g_c[43],cl_numfor(SUM(sr2.curr_val),43,g_azi05), #帳值
#               COLUMN g_c[44],cl_numfor(SUM(sr2.cost),44,g_azi05)
##No.FUN-580010 --end
#      #--END
#      IF g_zz05 = 'Y'     # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
#            #-- TQC-630166 begin
#              #IF tm.wc[001,120] > ' ' THEN                      # for 132
#              #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              #IF tm.wc[121,240] > ' ' THEN
#             #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             #IF tm.wc[241,300] > ' ' THEN
#             #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
#           #-- TQC-630166 end
#     END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#    IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINES
#     END IF
#END REPORT
#Patch....NO.TQC-610035 <> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

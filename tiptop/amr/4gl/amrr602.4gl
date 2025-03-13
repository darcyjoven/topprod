# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amrr602.4gl
# Descriptions...: 料需求計劃－獨立性需求彙總表
# Input parameter:
# Return code....:
# Date & Author..: 93/05/11 By Apple
# Modify.........: No.FUN-510046 05/03/01 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580014 05/08/16 By jackie 轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 將印報表名稱那一行移到印製表日期的前面一行
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl   修改報表格式
# Modify.........: No.FUN-860061 08/06/17 By lutingting報表轉為使用CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-920046 09/02/04 By Smapmin 報表結果皆為0,因為變數傳遞錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50037 10/05/10 By liuxqa add FUN-920045 

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
              wc       STRING,   # Where condition          
              opunit   LIKE type_file.chr1,     # 單位基準                   #NO.FUN-680082 VARCHAR(01)
              bdate    LIKE type_file.dat,      # 起始日期                   #NO.FUN-680082 DATE
              edate    LIKE type_file.dat,      # 截止日期                   #NO.FUN-680082 DATE
              days     LIKE type_file.num5,     # 天數                       #NO.FUN-680082 SMALLINT
              week     LIKE type_file.num5,     # 週                         #NO.FUN-680082 SMALLINT
              mons     LIKE type_file.num5,     # 月                         #NO.FUN-680082 SMALLINT
              a        LIKE type_file.chr1,     #FUN-A50037 add
              b        LIKE type_file.chr1,     #FUN-A50037 add
              s        LIKE type_file.chr3,     # Order by sequence          #NO.FUN-680082 VARCHAR(03)
              t        LIKE type_file.chr3,     # Eject sw                   #NO.FUN-680082 VARCHAR(03) 
              more     LIKE type_file.chr1      # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(1)
              END RECORD,
          g_bdate,g_edate LIKE type_file.dat,                                #NO.FUN-680082 DATE
          g_tot        LIKE type_file.num5,     #NO.FUN-680082 SMALLINT 
          g_tit1       LIKE type_file.chr1000,  #NO.FUN-680082 VARCHAR(120)
          g_tit2       LIKE type_file.chr1000,  #NO.FUN-680082 VARCHAR(130)
          g_desc       LIKE zaa_file.zaa08,     #NO.FUN-680082 VARCHAR(05)
          g_unit       LIKE zaa_file.zaa08,     #NO.FUN-680082 VARCHAR(08)
          p_wc         LIKE type_file.chr1000,  #NO.FUN-680082 VARCHAR(200)
          g_buck   DYNAMIC ARRAY OF RECORD      #存放時距的單頭資料
              tot      LIKE rpc_file.rpc13,     #NO.FUN-680082 DECIMAL(12,3)
              strt     LIKE type_file.dat,      #該時距的起時日期            #NO.FUN-680082 DATE
              ends     LIKE type_file.dat       #該時距的截止日期            #NO.FUN-680082 DATE
          END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #NO.FUN-680082 SMALLINT
DEFINE   g_sql           STRING                  #No.FUN-860061
DEFINE   g_str           STRING                  #No.FUN-860061
DEFINE   l_table         STRING                  #No.FUN-860061
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   #No.FUN-860061-----------start--
   LET g_sql = "rpc01.rpc_file.rpc01,", 
               "ima02.ima_file.ima02,", 
               "buck1.rpc_file.rpc13,", 
               "buck2.rpc_file.rpc13,",  
               "buck3.rpc_file.rpc13,",  
               "buck4.rpc_file.rpc13,",  
               "buck5.rpc_file.rpc13,",  
               "buck6.rpc_file.rpc13,",  
               "buck7.rpc_file.rpc13,",  
               "ima25.ima_file.ima25,", 
               "ima31.ima_file.ima31,", 
               "strt.type_file.dat,", 
               "g_desc.zaa_file.zaa08,",
               "ima16.ima_file.ima16,", 
               "ima06.ima_file.ima06,", 
               "ima08.ima_file.ima08,", 
               "ima67.ima_file.ima67" 
   LET l_table = cl_prt_temptable('amrr602',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
   #No.FUN-860061-----------end
   
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.opunit= ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.days  = ARG_VAL(11)
   LET tm.week  = ARG_VAL(12)
   LET tm.mons  = ARG_VAL(13)
   LET tm.a     = ARG_VAL(14)   #FUN-A50037 add
   LET tm.b     = ARG_VAL(15)   #FUN-A50037 add
   LET tm.s     = ARG_VAL(16)
   LET tm.t     = ARG_VAL(17)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL r602_tm(0,0)        # Input print condition
      ELSE CALL r602()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r602_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          l_i            LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          l_base         LIKE type_file.num5,   #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r602_w AT p_row,p_col
        WITH FORM "amr/42f/amrr602"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.opunit = '1'
   LET tm.bdate = g_today
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima16,ima08,rpc01,rpc02,ima06,ima67
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
         IF INFIELD(rpc01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rpc01
            NEXT FIELD rpc01
         END IF
#No.FUN-570240 --end
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r602_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET tm.days = ' '
   LET tm.week = ' '
   LET tm.mons = ' '
   LET tm.a = '3'     #FUN-A50037 add
   LET tm.b = '3'     #FUN-A50037 add
#  LET tm.edate = ' '
   FOR l_i = 1 TO  7
       LET g_buck[l_i].tot = 0
       LET g_buck[l_i].strt = ' '
       LET g_buck[l_i].ends = ' '
   END FOR
   LET l_base = 0
   INPUT BY NAME tm.opunit,tm.bdate,tm.edate,tm.days,tm.week,
                 tm.mons,tm.a,tm.b,            #FUN-A50037 add
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD opunit
         IF tm.opunit IS NULL OR tm.opunit NOT MATCHES "[12]"
            THEN NEXT FIELD opunit
         END IF
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
      AFTER FIELD edate
         IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.days  IS NOT NULL AND tm.days != ' ' AND tm.days > 0
         THEN LET l_base = l_base + 1
         END IF
         IF tm.week  IS NOT NULL AND tm.week != ' ' AND tm.week > 0
         THEN LET l_base = l_base + 1
         END IF
         IF tm.mons  IS NOT NULL AND tm.mons != ' ' AND tm.mons > 0
         THEN LET l_base = l_base + 1
         END IF
         IF l_base != 1 THEN
            CALL cl_err(' ','amr-076',1)
            NEXT FIELD days
         END IF
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         IF cl_null(tm.edate) THEN LET tm.edate = g_lastdat END IF
         IF (cl_null(tm.days) OR tm.days < 0 ) AND
            (cl_null(tm.week) OR tm.week < 0 ) AND
            (cl_null(tm.mons) OR tm.mons < 0 )
         THEN CALL cl_err('','amr-073',1)
              NEXT FIELD days
         END IF
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
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
      LET INT_FLAG = 0 CLOSE WINDOW r602_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr602'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr602','9031',1)
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
                         " '",tm.opunit CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.days CLIPPED,"'",
                         " '",tm.week CLIPPED,"'",
                         " '",tm.mons CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",   #FUN-A50037 add
                         " '",tm.b CLIPPED,"'",   #FUN-A50037 add
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrr602',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r602_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r602()
   ERROR ""
END WHILE
   CLOSE WINDOW r602_w
END FUNCTION
 
FUNCTION r602()
   DEFINE l_name     LIKE type_file.chr20,   # External(Disk) file name       #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0076
          l_sql      LIKE type_file.chr1000, # RDSQL STATEMENT                #NO.FUN-680082 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000, #NO.FUN-680082  VARCHAR(40)
          l_k,l_m,l_i,l_j  LIKE type_file.num10,                              #NO.FUN-680082 INTEGER
          l_old      LIKE rpc_file.rpc01,
          l_order    ARRAY[5] OF LIKE ima_file.ima16,     #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
          l_base     LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_strt     LIKE type_file.chr8,    #NO.FUN-680082 VARCHAR(08)
          l_ends     LIKE type_file.chr8,    #NO.FUN-680082 VARCHAR(08)
          mon_bdate,mon_edate,l_date  LIKE type_file.dat,                     #NO.FUN-680082 DATE
          l_sw       LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_factor   LIKE rpc_file.rpc16_fac,
          sr RECORD
             order1     LIKE ima_file.ima16,  #FUN-5B0105 20->40            #NO.FUN-680082 VARCHAR(40)
             order2     LIKE ima_file.ima16,  #FUN-5B0105 20->40            #NO.FUN-680082 VARCHAR(40)
             order3     LIKE ima_file.ima16,  #FUN-5B0105 20->40            #NO.FUN-680082 VARCHAR(40)
             rpc01      LIKE rpc_file.rpc01,
             rpc12      LIKE rpc_file.rpc12,
             rpc13      LIKE rpc_file.rpc13,
             rpc16      LIKE rpc_file.rpc16,
             rpc16_fac  LIKE rpc_file.rpc16_fac,
             ima02      LIKE ima_file.ima02,
             ima06      LIKE ima_file.ima06,
             ima08      LIKE ima_file.ima08,
             ima16      LIKE ima_file.ima16,
             ima67      LIKE ima_file.ima67,
             ima25      LIKE ima_file.ima25,
             ima31      LIKE ima_file.ima31,
             buck1      LIKE rpc_file.rpc13,
             buck2      LIKE rpc_file.rpc13,
             buck3      LIKE rpc_file.rpc13,
             buck4      LIKE rpc_file.rpc13,
             buck5      LIKE rpc_file.rpc13,
             buck6      LIKE rpc_file.rpc13,
             buck7      LIKE rpc_file.rpc13
            END RECORD,
          sr2 RECORD
             order1     LIKE ima_file.ima16,  #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
             order2     LIKE ima_file.ima16,  #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
             order3     LIKE ima_file.ima16,  #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
             rpc01      LIKE rpc_file.rpc01,
             rpc12      LIKE rpc_file.rpc12,
             rpc13      LIKE rpc_file.rpc13,
             rpc16      LIKE rpc_file.rpc16,
             rpc16_fac  LIKE rpc_file.rpc16_fac,
             ima02      LIKE ima_file.ima02,
             ima06      LIKE ima_file.ima06,
             ima08      LIKE ima_file.ima08,
             ima16      LIKE ima_file.ima16,
             ima67      LIKE ima_file.ima67,
             ima25      LIKE ima_file.ima25,
             ima31      LIKE ima_file.ima31,
             buck1      LIKE rpc_file.rpc13,
             buck2      LIKE rpc_file.rpc13,
             buck3      LIKE rpc_file.rpc13,
             buck4      LIKE rpc_file.rpc13,
             buck5      LIKE rpc_file.rpc13,
             buck6      LIKE rpc_file.rpc13,
             buck7      LIKE rpc_file.rpc13
            END RECORD
     #No.FUN-860061------start--
    DEFINE l_num       LIKE type_file.num5
    DEFINE l_str1      LIKE zaa_file.zaa08
    DEFINE l_str2      LIKE zaa_file.zaa08
    DEFINE l_str3      LIKE zaa_file.zaa08
    DEFINE l_str4      LIKE zaa_file.zaa08
    DEFINE l_str5      LIKE zaa_file.zaa08
    
     CALL cl_del_data(l_table)   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amrr602'     
     #No.FUN-860061------end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_getmsg('amr-203',g_lang)  RETURNING l_str4    #No.FUN-860061
     CALL cl_getmsg('amr-204',g_lang)  RETURNING l_str5    #No.FUN-860061
     IF tm.opunit = '1' THEN
        #LET g_unit = g_x[17]   #No.FUN-860061
        LET g_unit = l_str4     #No.FUN-860061
     ELSE
        #LET g_unit = g_x[18]   #No.FUN-860061
        LET g_unit = l_str5     #No.FUN-860061
     END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     LET g_tot = 0
     CALL cl_getmsg('amr-200',g_lang) RETURNING l_str1             #No.FUN-860061
     #LET g_desc = tm.mons USING'#&',' ',g_x[16].SubString(5,6)    #No.FUN-860061
     LET g_desc = tm.mons USING'#&',' ',l_str1
     LET l_base = 0
     LET g_edate = ' '
     LET g_tit1 = ' '
     LET g_tit2 = ' '
     IF tm.days > 0 THEN    #天
        LET l_base = tm.days -1       #每一bucket 的間隔天數
        FOR l_k =1 TO 7
           IF l_k = 1 THEN
              LET g_buck[l_k].strt = tm.bdate
           ELSE
              LET g_buck[l_k].strt =  DATE (g_buck[l_k-1].ends +1 )
           END IF
           LET g_buck[l_k].ends =  DATE (g_buck[l_k].strt + l_base )
           LET g_tot = g_tot + 1
           IF  g_buck[l_k].ends > tm.edate THEN EXIT FOR END IF
        END FOR
        LET g_edate = g_buck[g_tot].ends
        CALL cl_getmsg('amr-201',g_lang) RETURNING l_str2     #No.FUN-860061
        #LET g_desc = tm.days USING'#&',' ',g_x[16].SubString(1,2)   #No.FUN-860061
        LET g_desc = tm.days USING'#&',' ',l_str2         #No.FUN-860061
     END IF
     IF tm.week > 0 THEN    #週
        LET l_base = (tm.week * 7) - 1    #每一bucket 的間隔天數
        LET l_i=WEEKDAY(tm.bdate)
        IF l_i = 0 THEN LET l_i = 7 END IF
        IF l_i != 1 THEN
           LET g_bdate   = DATE (tm.bdate - l_i + 1)
        ELSE LET g_bdate = tm.bdate
        END IF
        FOR l_k =1 TO 7
           IF l_k = 1 THEN
              LET g_buck[l_k].strt = g_bdate
           ELSE
              LET g_buck[l_k].strt =  DATE (g_buck[l_k-1].ends +1 )
           END IF
           LET g_buck[l_k].ends =  DATE (g_buck[l_k].strt + l_base )
           LET g_tot = g_tot + 1
           IF  g_buck[l_k].ends > tm.edate THEN EXIT FOR END IF
        END FOR
        LET g_edate = g_buck[g_tot].ends
        CALL cl_getmsg('amr-202',g_lang) RETURNING l_str3    #No.FUN-860061
        #LET g_desc = tm.week USING'#&',' ',g_x[16].SubString(3,4)    #No.FUN-860061
        LET g_desc = tm.week USING'#&',' ',l_str3         #No.FUN-860061
     END IF
     IF tm.mons > 0 THEN    #月
        FOR l_k =1 TO 7
            IF l_k =1 THEN
                CALL s_first(tm.bdate) RETURNING g_buck[l_k].strt
            ELSE
                LET l_date = DATE (g_buck[l_k-1].ends + 1)
                CALL s_first(l_date)  RETURNING g_buck[l_k].strt
            END IF
            LET mon_bdate = g_buck[l_k].strt
            #計算時距最後一天
            FOR  l_m = 1 TO tm.mons
                 LET l_base=s_months(mon_bdate) #取得該月份的天數
                 LET l_date = DATE (mon_bdate + l_base -1 )
                 CALL s_last(l_date)  RETURNING mon_edate
                 LET mon_bdate= DATE (mon_edate + 1)
            END FOR
            LET g_buck[l_k].ends = mon_edate
            LET g_tot = g_tot + 1
            IF  g_buck[l_k].ends > tm.edate THEN EXIT FOR END IF
        END FOR
        LET g_edate = g_buck[g_tot].ends
        #LET g_desc = tm.mons USING'#&',' ',g_x[16].SubString(5,6)   #No.FUN-860061
        LET g_desc = tm.mons USING'#&',' ',l_str1   #No.FUN-860061
     END IF
 
     FOR l_k = 1 TO g_tot
         LET l_strt = g_buck[l_k].strt
         LET l_ends = g_buck[l_k].ends
#No.FUN-580014 --start--
#         LET g_tit1 = g_tit1 clipped,'   ',l_strt[4,5],l_strt[7,8],
#                                      '  -  ',l_ends[4,5],l_ends[7,8]
#         LET g_tit2 = g_tit2 clipped,' ','---------------'
#No.FUN-580014 --end--
     END FOR
 
     LET l_sql = "SELECT '','','',",
                 "       rpc01,rpc12,rpc13,rpc16,rpc16_fac, ",
                 "       ima02,ima06,ima08,ima16,ima67,ima25,ima31,",
                 "       '','','','','','','' ",
                 "  FROM rpc_file, ima_file ",
                 " WHERE rpc01 = ima01",
#                "  AND (rpc13 - rpc131 - rpc14) > 0 ",
                 "  AND (rpc13 - rpc131) > 0 ",  #No:8531
                 "  AND ",tm.wc CLIPPED
 
     IF NOT cl_null(tm.bdate) THEN
        LET l_sql = l_sql clipped," AND rpc12 >= '",tm.bdate,"'"
     END IF
 
     IF NOT cl_null(tm.edate) THEN
        LET l_sql = l_sql clipped," AND rpc12 <= '",tm.edate,"'"
     END IF

     #FUN-A50037 ---str ---add
     CASE tm.a
       WHEN '1'
          LET l_sql = l_sql clipped," AND rpc18 = 'Y' "
       WHEN '2'
          LET l_sql = l_sql clipped," AND rpc18 = 'N' "
     END CASE
     CASE tm.b
       WHEN '1'
          LET l_sql = l_sql clipped," AND rpc19 = 'Y' "
       WHEN '2'
          LET l_sql = l_sql clipped," AND rpc19 = 'N' "
     END CASE
     #FUN-A50037 ---end -----add      

     LET l_sql = l_sql CLIPPED," ORDER BY rpc01,rpc12"
 
     PREPARE r602_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
           
     END IF
     DECLARE r602_curs CURSOR FOR r602_prepare
 
     #CALL cl_outnam('amrr602') RETURNING l_name     #No.FUN-860061
     #START REPORT r602_rep TO l_name                #No.FUN-860061
        LET g_pageno = 0
        LET g_cnt=0
        LET sr2.rpc01 ='$'
       FOREACH r602_curs INTO sr.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF tm.opunit = '1' THEN
              LET sr.rpc13 = sr.rpc13 * sr.rpc16_fac
         ELSE
              IF sr.rpc16 != sr.ima31 THEN
                 CALL s_umfchk(sr.rpc01,sr.rpc16,sr.ima31)
                      RETURNING l_sw,l_factor
                 IF l_sw THEN
                 ###Modify:98/11/13---------換算率抓不到------####
                    CALL cl_err(sr.rpc01,'amr-074',0)
                    EXIT FOREACH
                #### LET l_factor = 1
                 END IF
                 LET sr.rpc13 = sr.rpc13 * l_factor
              END IF
         END IF
         IF (sr.rpc01 !=sr2.rpc01 AND sr2.rpc01 != '$') THEN
            #No.FUN-860061-----start--
            #FOR g_i = 1 TO 3
            #  CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr2.ima16
            #       WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr2.ima06
            #       WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr2.ima08
            #       WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr2.ima67
            #       WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr2.rpc01
            #       OTHERWISE LET l_order[g_i] = '-'
            #  END CASE
            #END FOR
            #LET sr2.order1 = l_order[1]
            #LET sr2.order2 = l_order[2]
            #LET sr2.order3 = l_order[3]
            #No.FUN-860061-----end
            LET sr2.buck1  = g_buck[1].tot
            LET sr2.buck2  = g_buck[2].tot
            LET sr2.buck3  = g_buck[3].tot
            LET sr2.buck4  = g_buck[4].tot
            LET sr2.buck5  = g_buck[5].tot
            LET sr2.buck6  = g_buck[6].tot
            LET sr2.buck7  = g_buck[7].tot
            IF sr2.buck1 =0 THEN LET sr2.buck1 = ' ' END IF
            IF sr2.buck2 =0 THEN LET sr2.buck2 = ' ' END IF
            IF sr2.buck3 =0 THEN LET sr2.buck3 = ' ' END IF
            IF sr2.buck4 =0 THEN LET sr2.buck4 = ' ' END IF
            IF sr2.buck5 =0 THEN LET sr2.buck5 = ' ' END IF
            IF sr2.buck6 =0 THEN LET sr2.buck6 = ' ' END IF
            IF sr2.buck7 =0 THEN LET sr2.buck7 = ' ' END IF
            #No.FUN-860061-----start--
            #OUTPUT TO REPORT r602_rep(sr2.*)
            FOR l_num = 1 TO g_tot
                LET l_strt = g_buck[l_num].strt
                LET l_ends = g_buck[l_num].ends
                LET g_zaa[32+l_num].zaa08=l_strt[4,5],l_strt[7,8],' - ',l_ends[4,5],l_ends[7,8]
            END FOR  
            #-----MOD-920046---------
            #IF cl_null(sr.buck1) THEN LET sr.buck1 = 0  END IF  
            #IF cl_null(sr.buck2) THEN LET sr.buck2 = 0  END IF
            #IF cl_null(sr.buck3) THEN LET sr.buck3 = 0  END IF
            #IF cl_null(sr.buck4) THEN LET sr.buck4 = 0  END IF
            #IF cl_null(sr.buck5) THEN LET sr.buck5 = 0  END IF
            #IF cl_null(sr.buck6) THEN LET sr.buck6 = 0  END IF
            #IF cl_null(sr.buck7) THEN LET sr.buck7 = 0  END IF
            #EXECUTE insert_prep USING  
            #    sr.rpc01, sr.ima02,sr.buck1,sr.buck2,sr.buck3,sr.buck4,
            #    sr.buck5,sr.buck6,sr.buck7,sr.ima25,sr.ima31,g_buck[1].strt,
            #    g_desc,sr.ima16,sr.ima06,sr.ima08,sr.ima67       
            EXECUTE insert_prep USING  
                sr2.rpc01, sr2.ima02,sr2.buck1,sr2.buck2,sr2.buck3,sr2.buck4,
                sr2.buck5,sr2.buck6,sr2.buck7,sr2.ima25,sr2.ima31,g_buck[1].strt,
                g_desc,sr2.ima16,sr2.ima06,sr2.ima08,sr2.ima67       
            #-----END MOD-920046-----
            #NO.FUN-860061-----end
            FOR l_i = 1 TO  g_tot LET g_buck[l_i].tot = 0 END FOR
            FOR l_k =1 TO g_tot
                IF (sr.rpc12 >= g_buck[l_k].strt)
                  AND (sr.rpc12 <= g_buck[l_k].ends) THEN
                  LET g_buck[l_k].tot = g_buck[l_k].tot + sr.rpc13
                  EXIT FOR
                END IF
            END FOR
         ELSE
            FOR l_k =1 TO g_tot
                IF (sr.rpc12 >= g_buck[l_k].strt)
                  AND (sr.rpc12 <= g_buck[l_k].ends) THEN
                  LET g_buck[l_k].tot = g_buck[l_k].tot + sr.rpc13
                END IF
            END FOR
         END IF
         LET sr2.* = sr.*
       END FOREACH
       
       #No.FUN-850143-----start--MARK
       #FOR g_i = 1 TO 3
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr2.ima16
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr2.ima06
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr2.ima08
       #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr2.ima67
       #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr2.rpc01
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       # END FOR
       # LET sr2.order1 = l_order[1]
       # LET sr2.order2 = l_order[2]
       # LET sr2.order3 = l_order[3]
       #No.FUN-850143-----end
       
        LET sr2.buck1  = g_buck[1].tot
        LET sr2.buck2  = g_buck[2].tot
        LET sr2.buck3  = g_buck[3].tot
        LET sr2.buck4  = g_buck[4].tot
        LET sr2.buck5  = g_buck[5].tot
        LET sr2.buck6  = g_buck[6].tot
        LET sr2.buck7  = g_buck[7].tot
        IF sr2.buck1 =0 THEN LET sr2.buck1 = ' ' END IF
        IF sr2.buck2 =0 THEN LET sr2.buck2 = ' ' END IF
        IF sr2.buck3 =0 THEN LET sr2.buck3 = ' ' END IF
        IF sr2.buck4 =0 THEN LET sr2.buck4 = ' ' END IF
        IF sr2.buck5 =0 THEN LET sr2.buck5 = ' ' END IF
        IF sr2.buck6 =0 THEN LET sr2.buck6 = ' ' END IF
        IF sr2.buck7 =0 THEN LET sr2.buck7 = ' ' END IF
        
        #No.FUN-860061-----start--
        #OUTPUT TO REPORT r602_rep(sr2.*)
        FOR l_num = 1 TO g_tot
            LET l_strt = g_buck[l_num].strt
            LET l_ends = g_buck[l_num].ends
            LET g_zaa[32+l_num].zaa08=l_strt[4,5],l_strt[7,8],' - ',l_ends[4,5],l_ends[7,8]
        END FOR 
        #-----MOD-920046---------
        #IF cl_null(sr.buck1) THEN LET sr.buck1 = 0   END IF
        #IF cl_null(sr.buck2) THEN LET sr.buck2 = 0   END IF
        #IF cl_null(sr.buck3) THEN LET sr.buck3 = 0   END IF
        #IF cl_null(sr.buck4) THEN LET sr.buck4 = 0   END IF
        #IF cl_null(sr.buck5) THEN LET sr.buck5 = 0   END IF
        #IF cl_null(sr.buck6) THEN LET sr.buck6 = 0   END IF
        #IF cl_null(sr.buck7) THEN LET sr.buck7 = 0   END IF
        #EXECUTE insert_prep USING
        #        sr.rpc01, sr.ima02,sr.buck1,sr.buck2,sr.buck3,sr.buck4,
        #        sr.buck5,sr.buck6,sr.buck7,sr.ima25,sr.ima31,g_buck[1].strt,
        #        g_desc,sr.ima16,sr.ima06,sr.ima08,sr.ima67  
        EXECUTE insert_prep USING
                sr2.rpc01, sr2.ima02,sr2.buck1,sr2.buck2,sr2.buck3,sr2.buck4,
                sr2.buck5,sr2.buck6,sr2.buck7,sr2.ima25,sr2.ima31,g_buck[1].strt,
                g_desc,sr2.ima16,sr2.ima06,sr2.ima08,sr2.ima67  
        #-----END MOD-920046-----
        #No.FUN-860061-----end
        FOR l_i = 1 TO  g_tot LET g_buck[l_i].tot = 0 END FOR
        MESSAGE ""
     
     #No.FUN-860061-------start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima16,ima08,rpc01,rpc02,ima06,ima67')
        RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.opunit,";",
                 g_unit,";",g_edate,";",g_zaa[33].zaa08,";",g_zaa[34].zaa08,";",
                 g_zaa[35].zaa08,";",g_zaa[36].zaa08,";",g_zaa[37].zaa08,";",
                 g_zaa[38].zaa08,";",g_zaa[39].zaa08
     
     CALL cl_prt_cs3('amrr602','amrr602',g_sql,g_str)
     #FINISH REPORT r602_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-860061-------	end
END FUNCTION
 
#No.FUN-860061-----start--
#REPORT r602_rep(sr)
#DEFINE
#      l_last_sw     LIKE type_file.chr1,   #NO.FUN-680082 VARCHAR(1) 
#      sr RECORD
#         order1     LIKE ima_file.ima16, #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
#         order2     LIKE ima_file.ima16, #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
#         order3     LIKE ima_file.ima16, #FUN-5B0105 20->40  #NO.FUN-680082 VARCHAR(40)
#         rpc01      LIKE rpc_file.rpc01,
#         rpc12      LIKE rpc_file.rpc12,
#         rpc13      LIKE rpc_file.rpc13,
#         rpc16      LIKE rpc_file.rpc16,
#         rpc16_fac  LIKE rpc_file.rpc16_fac,
#         ima02      LIKE ima_file.ima02,
#         ima06      LIKE ima_file.ima06,
#         ima08      LIKE ima_file.ima08,
#         ima16      LIKE ima_file.ima16,
#         ima67      LIKE ima_file.ima67,
#         ima25      LIKE ima_file.ima25,
#         ima31      LIKE ima_file.ima31,
#         buck1      LIKE rpc_file.rpc13,
#         buck2      LIKE rpc_file.rpc13,
#         buck3      LIKE rpc_file.rpc13,
#         buck4      LIKE rpc_file.rpc13,
#         buck5      LIKE rpc_file.rpc13,
#         buck6      LIKE rpc_file.rpc13,
#         buck7      LIKE rpc_file.rpc13
#        END RECORD,
#        l_unit      LIKE ima_file.ima25,
#        l_i,l_j,l_skip LIKE type_file.num5,                     #NO.FUN-680082 SMALLINT
#        l_chr       LIKE type_file.chr1    #NO.FUN-680082 VARCHAR(1)
# DEFINE l_num       LIKE type_file.num5,   #No.FUN-580014       #NO.FUN-680082 SMALLINT
#        l_strt      LIKE type_file.chr8,   #NO.FUN-680082 VARCHAR(08)
#        l_ends      LIKE type_file.chr8    #NO.FUN-680082 VARCHAR(08)
#
# OUTPUT TOP MARGIN g_top_margin
# LEFT MARGIN g_left_margin
# BOTTOM MARGIN g_bottom_margin
# PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.rpc01
# FORMAT
#
# PAGE HEADER
##No.FUN-580014 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED      #No.TQC-6A0080
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2+1),g_x[1] CLIPPED   #TQC-5B0019    #No.TQC-6A0080
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      IF tm.opunit = '1' THEN
#           LET l_unit = sr.ima25
#      ELSE LET l_unit = sr.ima31
#      END IF
#      PRINT g_x[13] clipped,g_unit CLIPPED,'(',l_unit clipped,')','    ',   #No.TQC-6A0080
#            g_x[14] clipped,g_buck[1].strt CLIPPED,'－',g_edate CLIPPED,'    ', #No.TQC-6A0080
#            g_x[15] clipped,g_desc  CLIPPED   #No.TQC-6A0080
#      PRINT g_dash[1,g_len]
# 
#      FOR l_num = 1 TO g_tot
#          LET l_strt = g_buck[l_num].strt
#          LET l_ends = g_buck[l_num].ends
#          LET g_zaa[32+l_num].zaa08=l_strt[4,5],l_strt[7,8],' - ',l_ends[4,5],l_ends[7,8]
#      END FOR
#
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,g_x[39] CLIPPED   #No.TQC-6A0080
#      PRINT g_dash1
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
#   BEFORE GROUP OF sr.rpc01
#      PRINT COLUMN g_c[31],sr.rpc01 CLIPPED, #FUN-5B0014 [1,20],
#            COLUMN g_c[32],sr.ima02 CLIPPED; #No.TQC-6A0080
#
#   ON EVERY ROW
#      PRINT
#            COLUMN g_c[33],cl_numfor(sr.buck1 ,33,1) CLIPPED,    #No.TQC-6A0080
#            COLUMN g_c[34],cl_numfor(sr.buck2 ,34,1) CLIPPED,    #No.TQC-6A0080
#            COLUMN g_c[35],cl_numfor(sr.buck3 ,35,1) CLIPPED,    #No.TQC-6A0080
#            COLUMN g_c[36],cl_numfor(sr.buck4 ,36,1) CLIPPED,    #No.TQC-6A0080
#            COLUMN g_c[37],cl_numfor(sr.buck5 ,37,1) CLIPPED,    #No.TQC-6A0080
#            COLUMN g_c[38],cl_numfor(sr.buck6 ,38,1) CLIPPED,    #No.TQC-6A0080
#            COLUMN g_c[39],cl_numfor(sr.buck7 ,39,1) CLIPPED     #No.TQC-6A0080
##No.FUN-580014 --end--
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'ima16,ima06,ima08,ima67,rpc01,rpc02')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         #TQC-630166 Start
#         #     IF tm.wc[001,120] > ' ' THEN            # for 132
#         # PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#         #     IF tm.wc[121,240] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#         #     IF tm.wc[241,300] > ' ' THEN
#         # PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         
#          CALL cl_prt_pos_wc(tm.wc)
#    
#         #TQC-630166 End
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED       #No.TQC-6A0080
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED     #No.TQC-6A0080
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-860061------end
#Patch....NO.TQC-610035 <> #
#FUN-870144

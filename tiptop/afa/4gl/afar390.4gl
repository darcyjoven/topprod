# Prog. Version..: '5.30.06-13.03.28(00005)'     #
# Pattern name...: afar390.4gl
# Desc/riptions...: 財稅折舊差異報表
# Date & Author..: 11/12/02 FUN-BB0051 By Sakura
# Modify.........: No:FUN-BB0163 11/12/02 By Sakura 金額計算改用除的(除匯率),after field sub取不到匯率預設值給1
# Modify.........: No:FUN-C20029 12/02/08 By Sakura 新增本月折舊、本月折舊差異、取消本期折舊差異
# Modify.........: No:CHI-C60010 12/06/12 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: NO.CHI-CA0063 12/11/02 By Belle 修改折舊金額計算方式
# Modify.........: No.MOD-D10174 13/01/21 By Polly 無資料需寫入0以致可以計算差異
   
DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD                           # Print condition RECORD
                wc      STRING,                 # Where condition
                wc2     STRING,                 # Where condition
                yyyy    LIKE type_file.num5,    # 資料年度
                mm      LIKE type_file.num5,    # 資料月份
                s       LIKE type_file.chr3,    # Order by sequence
                t       LIKE type_file.chr3,    # Eject sw
                c       LIKE type_file.chr3,    # subtotal
                a       LIKE type_file.chr1,    # 1.明細 2.彙總
                b       LIKE type_file.chr1,    # 1.管理部門 2.被分攤部門
                sub  	LIKE type_file.chr1,    # 1.財簽VS財簽2 2.財簽VS稅簽 3.稅簽VS財簽
                #rate    LIKE type_file.num5,    # 換算匯率 #No:FUN-C20029 mark
                rate    LIKE azj_file.azj03,    # 換算匯率 #No:FUN-C20029 add
                more    LIKE type_file.chr1     # Input more condition(Y/N)
                END RECORD
DEFINE g_before_input_done   LIKE type_file.num5


DEFINE   l_table         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   g_faj143        LIKE faj_file.faj143 
#CHI-C60010---str---
DEFINE   g_azi04_1  LIKE azi_file.azi04,
         g_azi05_1  LIKE azi_file.azi05
#CHI-C60010---end---

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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = "faj04.faj_file.faj04,",
               "faj93.faj_file.faj93,", 
               "faj02.faj_file.faj02,",
               "faj022.faj_file.faj022,",
               "faj26.faj_file.faj26,",
               "faj05.faj_file.faj05,",
               "faj06.faj_file.faj06,",
               "faj29.faj_file.faj29,",
               "faj31.faj_file.faj31,",
               "faj32.faj_file.faj32,",
               "faj29_1.faj_file.faj29,",
               "faj31_1.faj_file.faj31,",
               "faj32_1.faj_file.faj32,",
               "fan06.fan_file.fan06,",
               "fan09.fan_file.fan09,",
               "fan14.fan_file.fan14,",
               "fan14_1.fan_file.fan14,",
               "pre_d.fan_file.fan15,",
               "pre_d_1.fan_file.fan15,",
               "curr_d.fan_file.fan15,",
               "curr_d_1.fan_file.fan15,",
               "curr.fan_file.fan15,",   #No:FUN-C20029 add
               "curr_1.fan_file.fan15,", #No:FUN-C20029 add               
               "curr_val.fan_file.fan15,",
               "curr_val_1.fan_file.fan15,",
               "gem02_06.gem_file.gem02,",
               "gem02_09.gem_file.gem02"
               
   LET l_table = cl_prt_temptable('afar390',g_sql) CLIPPED
   IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                              
             " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                           
             "        ?,?,?,?,?, ?,?,?,?,?,",                                                                                           
             "        ?,?,?,?,?, ?,?)" #No:FUN-C20029 add 2?
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                              
   END IF

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
   LET tm.s  = ARG_VAL(11)
   LET tm.t  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   LET tm.a  = ARG_VAL(14)
   LET tm.b  = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)
   LET tm.sub  = ARG_VAL(20)
   LET tm.rate  = ARG_VAL(21)

   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL r390_tm(0,0)            # Input print condition
      ELSE CALL afar390()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r390_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_cmd         LIKE type_file.chr1000,
            lc_qbe_sn     LIKE gbm_file.gbm01

   LET p_row = 4 LET p_col = 14

   OPEN WINDOW r390_w AT p_row,p_col WITH FORM "afa/42f/afar390"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   IF g_faa.faa31 = 'N' THEN
      LET tm.sub = '2'
      LET tm.rate = 1
      CALL r390_set_no_entry()
   ELSE 
      LET tm.sub = '1'
      SELECT aaa03 INTO g_faj143 FROM aaa_file
        WHERE aaa01 = g_faa.faa02c 
      CALL s_curr(g_faj143,g_today) RETURNING tm.rate
      IF cl_null(tm.rate) THEN
         LET tm.rate = 1
      END IF       
   END IF
   LET tm.s    = '123'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.a    = '1'
   LET tm.b    = '1'
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
   LET tm2.u1   = tm.c[1,1]
   LET tm2.u2   = tm.c[2,2]
   LET tm2.u3   = tm.c[3,3]
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
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj022,faj06,faj93

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT

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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r390_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME tm.wc2 ON fan06
      
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r390_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      INPUT BY NAME
            tm.yyyy,tm.mm,tm.a,tm.b,tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.sub,tm.rate,tm.more
            WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            LET g_before_input_done = FALSE
            CALL r390_set_entry()
            CALL r390_set_no_entry()
            LET g_before_input_done = TRUE

         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN
               NEXT FIELD mm
            END IF
         AFTER FIELD a
            IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL THEN
               NEXT FIELD a
            ELSE
               IF tm.a = '1' THEN 
                  LET tm.b = '1' 
               END IF
               IF tm.a = '2' THEN 
                  LET tm.b = '2' 
               END IF
               DISPLAY BY NAME tm.b
            END IF
         BEFORE FIELD sub
            CALL r390_set_entry()
         AFTER FIELD sub
            IF tm.sub IS NULL OR tm.sub not matches'[123]' THEN 
               NEXT FIELD sub
            END IF
            IF tm.sub = '2' THEN
               LET tm.rate = 1
            ELSE
               SELECT aaa03 INTO g_faj143 FROM aaa_file
                  WHERE aaa01 = g_faa.faa02c
               CALL s_curr(g_faj143,g_today) RETURNING tm.rate
               #No:FUN-BB0163---being  add
               IF cl_null(tm.rate) THEN
                  LET tm.rate = 1
               END IF
               #No:FUN-BB0163---end  add                  
            END IF            
            CALL r390_set_no_entry()
            DISPLAY BY NAME tm.rate            
         AFTER FIELD rate
            IF tm.rate <= 0 THEN
               CALL cl_err(' ','axm-987',0)
               NEXT FIELD rate
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()        # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.c = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW r390_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar390'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar390','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.wc2 CLIPPED,"'",
                        " '",tm.yyyy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.sub CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('afar390',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r390_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar390()
      ERROR ""
   END WHILE

   CLOSE WINDOW r390_w
END FUNCTION

FUNCTION r390_set_entry()
    CALL cl_set_comp_entry("rate",TRUE)
END FUNCTION

FUNCTION r390_set_no_entry()
   IF tm.sub = '2' THEN
      CALL cl_set_comp_entry("rate",FALSE)
      LET tm.rate = 1
   END IF
   IF g_faa.faa31 = 'N' THEN
      CALL cl_set_comp_entry("sub",FALSE)
   END IF
END FUNCTION

FUNCTION afar390()
   DEFINE l_sql         STRING,
          l_flag        LIKE type_file.chr1,
          sr            RECORD faj02  LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,   #附號
                               faj93 LIKE faj_file.faj93,     #族群編號
                               faj04  LIKE faj_file.faj04,    #主類別
                               faj05  LIKE faj_file.faj05,    #次類別
                               faj06  LIKE faj_file.faj06,    #中文名稱
                               faj07  LIKE faj_file.faj07,    #英文名稱
                               faj14  LIKE faj_file.faj14,    #本幣成本
                               faj20  LIKE faj_file.faj20,    #保管部門
                               faj23  LIKE faj_file.faj23,    #分攤方式
                               faj24  LIKE faj_file.faj24,    #分攤部門(類別)
                               faj26  LIKE faj_file.faj26,    #入帳日期
                               faj29  LIKE faj_file.faj29,    #耐用年限
                               faj31  LIKE faj_file.faj31,    #預留殘值 
                               faj32  LIKE faj_file.faj32     #累計折舊
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
                               fan041   LIKE fan_file.fan041    #來源#FUN-C20029 add fan041
                        END RECORD,
          sr3           RECORD
                               faj04      LIKE faj_file.faj04,
                               faj93      LIKE faj_file.faj93,
                               faj02      LIKE faj_file.faj02,
                               faj022     LIKE faj_file.faj022,
                               faj26      LIKE faj_file.faj26,
                               faj05      LIKE faj_file.faj05,
                               faj06      LIKE faj_file.faj06,
                               faj29      LIKE faj_file.faj29,
                               faj31      LIKE faj_file.faj31,
                               faj32      LIKE faj_file.faj32,
                               faj29_1    LIKE faj_file.faj29,
                               faj31_1    LIKE faj_file.faj31,
                               faj32_1    LIKE faj_file.faj32,
                               fan06      LIKE fan_file.fan06,
                               fan09      LIKE fan_file.fan09,
                               fan14      LIKE fan_file.fan14,
                               fan14_1    LIKE fan_file.fan14,
                               pre_d      LIKE fan_file.fan15,
                               pre_d_1    LIKE fan_file.fan15,
                               curr_d     LIKE fan_file.fan15,
                               curr_d_1   LIKE fan_file.fan15,
                               curr       LIKE fan_file.fan15, #No:FUN-C20029 add
                               curr_1     LIKE fan_file.fan15, #No:FUN-C20029 add                              
                               curr_val   LIKE fan_file.fan15,
                               curr_val_1 LIKE fan_file.fan15,
                               gem02_06   LIKE gem_file.gem02,
                               gem02_09   LIKE gem_file.gem02,
                               fan041     LIKE fan_file.fan041 #來源#FUN-C20029 add fan041 
                        END RECORD          
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_fan03       LIKE type_file.chr4
   DEFINE l_fbn03       LIKE type_file.chr4
   DEFINE l_fan04       LIKE type_file.chr2
   DEFINE l_fbn04       LIKE type_file.chr2
   DEFINE l_fan03_fan04 LIKE type_file.chr6
   DEFINE l_fbn03_fbn04 LIKE type_file.chr6
   DEFINE l_faj27       LIKE type_file.chr6
   DEFINE l_faj272       LIKE type_file.chr6
   DEFINE l_count       LIKE type_file.num5
   DEFINE l_adj_fan07   LIKE fan_file.fan07,
          l_adj_fan07_1 LIKE fan_file.fan07,
          l_adj_fap54   LIKE fap_file.fap54,
          l_curr_fan07  LIKE fan_file.fan07,
          l_pre_fan15   LIKE fan_file.fan15   
   #FUN-C20029--start---add
   DEFINE l_faj02       LIKE faj_file.faj02,
          l_faj022      LIKE faj_file.faj022,
          l_fan06       LIKE fan_file.fan06,
          l_fan041       LIKE fan_file.fan041
   #FUN-C20029--start---end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                     
     CALL cl_del_data(l_table)

   DROP TABLE afar390_tmp1
#存放財簽資料
   CREATE TEMP TABLE afar390_tmp1(
               faj02  LIKE faj_file.faj02,
               faj022 LIKE faj_file.faj022,
               faj93 LIKE faj_file.faj93,
               faj04  LIKE faj_file.faj04,
               faj05  LIKE faj_file.faj05,
               faj06  LIKE faj_file.faj06,
               faj07  LIKE faj_file.faj07,
               faj14  LIKE faj_file.faj14,
               faj20  LIKE faj_file.faj20,
               faj23  LIKE faj_file.faj23,
               faj24  LIKE faj_file.faj24,
               faj26  LIKE faj_file.faj26,
               faj29  LIKE faj_file.faj29,
               faj31  LIKE faj_file.faj31,
               faj32  LIKE faj_file.faj32,
               fan03  LIKE fan_file.fan03,
               fan04  LIKE fan_file.fan04,
               fan05  LIKE fan_file.fan05,
               fan06  LIKE fan_file.fan06,
               fan07  LIKE fan_file.fan07,
               fan09  LIKE fan_file.fan09,
               fan14  LIKE fan_file.fan14,
               fan15  LIKE fan_file.fan15,
               pre_d  LIKE fan_file.fan15,
               curr_d LIKE fan_file.fan15,
               curr   LIKE fan_file.fan15,
               curr_val LIKE fan_file.fan15,
               fan041 LIKE fan_file.fan041) #FUN-C20029 add fan041

   DELETE FROM afar390_tmp1
   
   DROP TABLE afar390_tmp2
#存放財簽2資料
   CREATE TEMP TABLE afar390_tmp2(
               faj02  LIKE faj_file.faj02,
               faj022 LIKE faj_file.faj022,
               faj93 LIKE faj_file.faj93,
               faj04  LIKE faj_file.faj04,
               faj05  LIKE faj_file.faj05,
               faj06  LIKE faj_file.faj06,
               faj07  LIKE faj_file.faj07,
               faj14  LIKE faj_file.faj14,
               faj20  LIKE faj_file.faj20,
               faj23  LIKE faj_file.faj23,
               faj24  LIKE faj_file.faj24,
               faj26  LIKE faj_file.faj26,
               faj292  LIKE faj_file.faj292,
               faj312  LIKE faj_file.faj31,
               faj322  LIKE faj_file.faj32,               
               fan03  LIKE fan_file.fan03,
               fan04  LIKE fan_file.fan04,
               fan05  LIKE fan_file.fan05,
               fan06  LIKE fan_file.fan06,
               fan07  LIKE fan_file.fan07,
               fan09  LIKE fan_file.fan09,
               fan14  LIKE fan_file.fan14,
               fan15  LIKE fan_file.fan15,
               pre_d  LIKE fan_file.fan15,
               curr_d LIKE fan_file.fan15,
               curr   LIKE fan_file.fan15,
               curr_val LIKE fan_file.fan15,
               fan041 LIKE fan_file.fan041) #FUN-C20029 add fan041

   DELETE FROM afar390_tmp2

   DROP TABLE afar390_tmp3
#存放稅簽資料
   CREATE TEMP TABLE afar390_tmp3(
               faj02  LIKE faj_file.faj02,
               faj022 LIKE faj_file.faj022,
               faj93 LIKE faj_file.faj93,
               faj04  LIKE faj_file.faj04,
               faj05  LIKE faj_file.faj05,
               faj06  LIKE faj_file.faj06,
               faj07  LIKE faj_file.faj07,
               faj14  LIKE faj_file.faj14,
               faj20  LIKE faj_file.faj20,
               faj23  LIKE faj_file.faj23,
               faj24  LIKE faj_file.faj24,
               faj26  LIKE faj_file.faj26,
               faj64  LIKE faj_file.faj64,
               faj66  LIKE faj_file.faj66,
               faj67  LIKE faj_file.faj67,               
               fan03  LIKE fan_file.fan03,
               fan04  LIKE fan_file.fan04,
               fan05  LIKE fan_file.fan05,
               fan06  LIKE fan_file.fan06,
               fan07  LIKE fan_file.fan07,
               fan09  LIKE fan_file.fan09,
               fan14  LIKE fan_file.fan14,
               fan15  LIKE fan_file.fan15,
               pre_d  LIKE fan_file.fan15,
               curr_d LIKE fan_file.fan15,
               curr   LIKE fan_file.fan15,
               curr_val LIKE fan_file.fan15,
               fan041 LIKE fan_file.fan041) #FUN-C20029 add fan041

   DELETE FROM afar390_tmp3   

     IF g_priv2='4' THEN                           #只能使用自己的資料
        LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF
     IF g_priv3 MATCHES "[5678]" THEN              #群組權限
        LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     END IF

##財簽
     LET l_faj27 = tm.yyyy||(tm.mm USING '&&')

     LET l_sql = "SELECT faj02,faj022,faj93,faj04,faj05,faj06,faj07,faj14,faj20,",
                 " faj23,faj24,faj26,faj29,faj31,faj32",
                 " FROM faj_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND fajconf = 'Y'",
                 " AND faj28 <> '0'",
                 " AND faj27 <= '",l_faj27,"'",
                 " AND (faj02 NOT IN (SELECT fap02 FROM fap_file ",
                 "      WHERE (YEAR(fap04)||MONTH(fap04)) <= '",l_faj27,"'",				 
                 "      AND fap77 IN ('5','6') ",
                 "      AND fap021 = faj022) ",     
                 "      OR faj02 IN (SELECT fan01 FROM fan_file ",
                 "      WHERE fan03 = ",tm.yyyy," AND fan04 = ",tm.mm,
                 "        AND fan07 > 0 AND fan02 =faj022)) "
     PREPARE r390_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r390_cs1 CURSOR FOR r390_prepare1

     #--->取每筆資產本年度月份折舊
     LET l_sql = " SELECT fan03, fan04, fan05, fan06, fan07,",
                 " fan09, fan14, fan15,0,fan08,0,0,fan041 ", #FUN-C20029 add fan041
                 " FROM fan_file ",
                 " WHERE fan01 = ? AND fan02 = ? ",
                 "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
                 "   AND (fan041 = '1' OR fan041 = '0') ",
                 "   AND ",tm.wc2
     CASE
        WHEN tm.a = '1' #--->分攤前
          LET l_sql = l_sql clipped ," AND fan05 != '3' " clipped
        WHEN tm.a = '2' #--->分攤後
          LET l_sql = l_sql clipped ," AND fan05 != '2' " clipped
        OTHERWISE EXIT CASE
     END CASE
     
     PREPARE r390_prefan  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r390_csfan CURSOR FOR r390_prefan

     LET l_sql = "SELECT SUM(fan15) FROM fan_file ",
                 " WHERE fan01 = ? AND fan02 = ? ",
                 "   AND fan03 = ", tm.yyyy," AND fan04=",tm.mm,
                 "   AND (fan041 = '1' OR fan041 = '0')",
                 "   AND fan06 = ? "
     CASE
        WHEN tm.a = '1' #--->分攤前
           LET l_sql = l_sql CLIPPED ," AND fan05 != '3' " CLIPPED
        WHEN tm.a = '2' #--->分攤後
           LET l_sql = l_sql CLIPPED ," AND fan05 != '2' " CLIPPED
        OTHERWISE EXIT CASE
     END CASE
     PREPARE r390_presum1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('presum:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r390_cssum1 CURSOR FOR r390_presum1

     INITIALIZE sr.* TO NULL
     FOREACH r390_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_flag = 'Y'

      #上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_count FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022  
          AND fap77 IN ('5','6')
		  AND (YEAR(fap04)||MONTH(fap04)) < l_faj27
      #上線前已銷帳者，應不可印出
       IF l_count=0 THEN
          SELECT COUNT(*) INTO l_count FROM faj_file
           WHERE faj02=sr.faj02 AND faj022=sr.faj022
             AND faj43='6'
			 AND (YEAR(fap04)||MONTH(fap04)) <= l_faj27
       END IF
       IF l_count > 0 THEN 
          CONTINUE FOREACH 
       END IF
       #--->篩選部門
       INITIALIZE sr2.* TO NULL
       FOREACH r390_csfan USING sr.faj02,sr.faj022 INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r390_csfan:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET l_flag = 'N'
          OPEN r390_cssum1 USING sr.faj02,sr.faj022,sr2.fan06
          FETCH r390_cssum1 INTO sr2.fan15

          IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
          IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
          IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
          IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
          IF cl_null(sr2.fan14) THEN LET sr2.fan14 = 0 END IF
          IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
          LET l_adj_fan07 = 0
          LET l_adj_fap54 = 0
         #CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.fan15)             #CHI-CA0063 mark
          CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.fan15,sr2.fan06)   #CHI-CA0063
             RETURNING l_adj_fan07,l_adj_fan07_1,l_adj_fap54
          LET sr2.fan15 = sr2.fan15 + l_adj_fan07
          LET sr2.fan07 = sr2.fan07 + l_adj_fan07_1
         #LET sr2.curr_d = sr2.curr_d + l_adj_fan07                   #CHI-CA0063 mark
          LET sr2.fan14 = sr2.fan14 + l_adj_fap54

          #--->本月折舊
          LET sr2.curr = sr2.fan07

          #--->前期折舊 = (累折 - 本期累折)
          IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN
             LET sr2.pre_d = 0
          ELSE
             LET sr2.pre_d = sr2.fan15 - sr2.curr_d
          END IF

          #--->帳面價值 = (成本 - 累積折舊)
          LET sr2.curr_val = sr2.fan14-sr2.fan15

             INSERT INTO afar390_tmp1
              VALUES(sr.faj02,  sr.faj022, sr.faj93,  sr.faj04,  sr.faj05,   
                     sr.faj06,  sr.faj07,  sr.faj14,  sr.faj20,  sr.faj23,   
                     sr.faj24,  sr.faj26,  sr.faj29,  sr.faj31,  sr.faj32,   
                     sr2.fan03, sr2.fan04, sr2.fan05, sr2.fan06, sr2.fan07,  
                     sr2.fan09, sr2.fan14, sr2.fan15, sr2.pre_d, sr2.curr_d, 
                     sr2.curr,  sr2.curr_val,sr2.fan041)
       END FOREACH
       IF l_flag ='Y' THEN
          #--->若已折畢,抓取每筆資產最後一次折舊資料
          LET l_sql = " SELECT MAX(fan03*100+fan04) FROM fan_file ",
                      " WHERE fan01 = ? AND fan02 = ?",
                      "   AND (fan041 = '1' OR fan041 = '0')",
                      "   AND ",tm.wc2
          PREPARE pre_fan03_fan04 FROM l_sql
          EXECUTE pre_fan03_fan04 USING sr.faj02,sr.faj022 INTO l_fan03_fan04
          LET l_fan03 = l_fan03_fan04[1,4]
          LET l_fan04 = l_fan03_fan04[5,6]
 
          IF l_fan03 = tm.yyyy THEN
             LET l_sql = " SELECT fan03, fan04, fan05, fan06, 0,",
                         " fan09, fan14, fan15,0,fan08,0,0,fan041 " #FUN-C20029 add fan041
          ELSE
             LET l_sql = " SELECT fan03, fan04, fan05, fan06, 0,",
                         " fan09, fan14, fan15,fan08,0,0,0,fan041 " #FUN-C20029 add fan041
          END IF
          LET l_sql = l_sql CLIPPED,
                      " FROM fan_file ",
                      " WHERE fan01 = ? AND fan02 = ? ",
                      "   AND fan03 = ? AND fan04 = ? ",
                      "   AND (fan041 = '1' OR fan041 = '0')",
                      "   AND ",tm.wc2
          CASE
             WHEN tm.a = '1' #--->分攤前
                LET l_sql = l_sql clipped ," AND fan05 != '3' " clipped
             WHEN tm.a = '2' #--->分攤後
                LET l_sql = l_sql clipped ," AND fan05 != '2' " clipped
             OTHERWISE EXIT CASE
          END CASE
          PREPARE r390_prefan2  FROM l_sql
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time
             EXIT PROGRAM
          END IF
          DECLARE r390_csfan2 CURSOR FOR r390_prefan2

          FOREACH r390_csfan2 USING sr.faj02,sr.faj022,l_fan03,l_fan04 INTO sr2.*
             IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
             IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
             IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
             IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
             IF cl_null(sr2.fan14) THEN LET sr2.fan14 = 0 END IF
             IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
             LET l_adj_fan07 = 0
             LET l_adj_fap54 = 0
            #CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.fan15)           #CHI-CA0063 mark
             CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.fan15,sr2.fan06) #CHI-CA0063
                RETURNING l_adj_fan07,l_adj_fan07_1,l_adj_fap54
             LET sr2.fan15 = sr2.fan15 + l_adj_fan07
             LET sr2.fan07 = sr2.fan07 + l_adj_fan07_1
            #LET sr2.curr_d = sr2.curr_d + l_adj_fan07                 #CHI-CA0063 mark
             LET sr2.fan14 = sr2.fan14 + l_adj_fap54

             #--->本月折舊
             LET sr2.curr = sr2.fan07
             
             #--->前期折舊 = (累折 - 本期累折)
             IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN
                LET sr2.pre_d = 0
             ELSE
                LET sr2.pre_d = sr2.fan15 - sr2.curr_d
             END IF

             #--->帳面價值 = (成本 - 累積折舊)
             LET sr2.curr_val = sr2.fan14-sr2.fan15

             INSERT INTO afar390_tmp1
              VALUES(sr.faj02,  sr.faj022, sr.faj93,  sr.faj04,  sr.faj05,   
                     sr.faj06,  sr.faj07,  sr.faj14,  sr.faj20,  sr.faj23,   
                     sr.faj24,  sr.faj26,  sr.faj29,  sr.faj31,  sr.faj32,   
                     sr2.fan03, sr2.fan04, sr2.fan05, sr2.fan06, sr2.fan07,  
                     sr2.fan09, sr2.fan14, sr2.fan15, sr2.pre_d, sr2.curr_d, 
                     sr2.curr,  sr2.curr_val,sr2.fan041)

          END FOREACH
       END IF
    END FOREACH
    
##財簽二
     LET l_faj272 = tm.yyyy||(tm.mm USING '&&')

     LET l_sql = "SELECT faj02,faj022,faj93,faj04,faj05,faj06,faj07,faj142,faj20,",
                 " faj232,faj242,faj262,faj292,faj312,faj322",
                 " FROM faj_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND fajconf = 'Y'",
                 " AND faj282 <> '0'",
                 " AND faj272 <= '",l_faj272,"'",
                 " AND (faj02 NOT IN (SELECT fap02 FROM fap_file ",
                 "      WHERE (YEAR(fap04)||MONTH(fap04)) <= '",l_faj272,"'",       
                 "      AND fap772 IN ('5','6') ",
                 "      AND fap021 = faj022) ",
                 "      OR faj02 IN (SELECT fbn01 FROM fbn_file ",
                 "      WHERE fbn03 = ",tm.yyyy," AND fbn04 = ",tm.mm,
                 "        AND fbn07 > 0 AND fbn02 =faj022)) "
     PREPARE r390_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r390_cs2 CURSOR FOR r390_prepare2

     #--->取每筆資產本年度月份折舊
     LET tm.wc2 = cl_replace_str(tm.wc2,"fan06","fbn06")
     LET l_sql = " SELECT fbn03, fbn04, fbn05, fbn06, fbn07,",
                 " fbn09, fbn14, fbn15,0,fbn08,0,0,fbn041 ", #FUN-C20029 add fbn041
                 " FROM fbn_file ",
                 " WHERE fbn01 = ? AND fbn02 = ? ",
                 "   AND fbn03 = ", tm.yyyy," AND fbn04=",tm.mm,
                 "   AND (fbn041 = '1' OR fbn041 = '0') ",
                 "   AND ",tm.wc2
     CASE
        WHEN tm.a = '1' #--->分攤前
          LET l_sql = l_sql clipped ," AND fbn05 != '3' " clipped
        WHEN tm.a = '2' #--->分攤後
          LET l_sql = l_sql clipped ," AND fbn05 != '2' " clipped
        OTHERWISE EXIT CASE
     END CASE
     PREPARE r390_prefbn  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r390_csfbn CURSOR FOR r390_prefbn

     LET l_sql = "SELECT SUM(fbn15) FROM fbn_file ",
                 " WHERE fbn01 = ? AND fbn02 = ? ",
                 "   AND fbn03 = ", tm.yyyy," AND fbn04=",tm.mm,
                 "   AND (fbn041 = '1' OR fbn041 = '0')",
                 "   AND fbn06 = ? "
     CASE
        WHEN tm.a = '1' #--->分攤前
           LET l_sql = l_sql CLIPPED ," AND fbn05 != '3' " CLIPPED
        WHEN tm.a = '2' #--->分攤後
           LET l_sql = l_sql CLIPPED ," AND fbn05 != '2' " CLIPPED
        OTHERWISE EXIT CASE
     END CASE
     PREPARE r390_presum2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('presum:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r390_cssum2 CURSOR FOR r390_presum2

     INITIALIZE sr.* TO NULL
     FOREACH r390_cs2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
      #LET l_flag = 'Y'   #MOD-D10174 mark

      #上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_count FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022  
          AND fap772 IN ('5','6')
          AND (YEAR(fap04)||MONTH(fap04)) <= l_faj272 		  
      #上線前已銷帳者，應不可印出
       IF l_count=0 THEN
          SELECT COUNT(*) INTO l_count FROM faj_file
           WHERE faj02=sr.faj02 AND faj022=sr.faj022
             AND faj432='6'
			 AND (YEAR(faj100)||MONTH(faj100)) <= l_faj272
       END IF
       IF l_count > 0 THEN 
          CONTINUE FOREACH 
       END IF
       #--->篩選部門
       INITIALIZE sr2.* TO NULL
       FOREACH r390_csfbn USING sr.faj02,sr.faj022 INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r390_csfbn:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
         #LET l_flag = 'N' #MOD-D10174 mark
          OPEN r390_cssum2 USING sr.faj02,sr.faj022,sr2.fan06
          FETCH r390_cssum2 INTO sr2.fan15

          IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
          IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
          IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
          IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
          IF cl_null(sr2.fan14) THEN LET sr2.fan14 = 0 END IF
          IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
          #--->本月折舊
          LET sr2.curr = sr2.fan07
          
          #--->前期折舊 = (累折 - 本期累折)
          IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN
             LET sr2.pre_d = 0
          ELSE
             LET sr2.pre_d = sr2.fan15 - sr2.curr_d       
          END IF
          
          #--->帳面價值 = (成本 - 累積折舊)
          LET sr2.curr_val = sr2.fan14-sr2.fan15
          
             INSERT INTO afar390_tmp2
              VALUES(sr.faj02,  sr.faj022, sr.faj93,  sr.faj04,  sr.faj05,   
                     sr.faj06,  sr.faj07,  sr.faj14,  sr.faj20,  sr.faj23,   
                     sr.faj24,  sr.faj26,  sr.faj29,  sr.faj31,  sr.faj32,   
                     sr2.fan03, sr2.fan04, sr2.fan05, sr2.fan06, sr2.fan07,  
                     sr2.fan09, sr2.fan14, sr2.fan15, sr2.pre_d, sr2.curr_d, 
                     sr2.curr,  sr2.curr_val,sr2.fan041) #FUN-C20029 add fbn041
       END FOREACH
       
      #-MOD-D10174-mark-
      #IF l_flag ='Y' THEN
      #   #--->若已折畢,抓取每筆資產最後一次折舊資料
      #   LET l_sql = " SELECT MAX(fbn03*100+fbn04) FROM fbn_file ",
      #               " WHERE fbn01 = ? AND fbn02 = ?",
      #               "   AND (fbn041 = '1' OR fbn041 = '0') ",
      #               "   AND ",tm.wc2
      #   PREPARE pre_fbn03_fbn04 FROM l_sql
      #   EXECUTE pre_fbn03_fbn04 USING sr.faj02,sr.faj022 INTO l_fbn03_fbn04
      #   LET l_fbn03 = l_fbn03_fbn04[1,4]
      #   LET l_fbn04 = l_fbn03_fbn04[5,6]
 
      #   IF l_fbn03 = tm.yyyy THEN
      #      LET l_sql = " SELECT fbn03, fbn04, fbn05, fbn06, 0,",
      #                  " fbn09, fbn14, fbn15,0,fbn08,0,0,fbn041 " #FUN-C20029 add fbn041
      #   ELSE
      #      LET l_sql = " SELECT fbn03, fbn04, fbn05, fbn06, 0,",
      #                  " fbn09, fbn14, fbn15,fbn08,0,0,0,fbn041 " #FUN-C20029 add fbn041
      #   END IF
 
      #   LET l_sql = l_sql CLIPPED,
      #               " FROM fbn_file ",
      #               " WHERE fbn01 = ? AND fbn02 = ? ",
      #               "   AND fbn03 = ? AND fbn04 = ? ",
      #               "   AND (fbn041 = '1' OR fbn041 = '0') ",
      #               "   AND ",tm.wc2
      #   CASE
      #      WHEN tm.a = '1' #--->分攤前
      #         LET l_sql = l_sql clipped ," AND fbn05 != '3' " clipped
      #      WHEN tm.a = '2' #--->分攤後
      #         LET l_sql = l_sql clipped ," AND fbn05 != '2' " clipped
      #      OTHERWISE EXIT CASE
      #   END CASE
      #   PREPARE r390_prefbn2  FROM l_sql
      #   IF SQLCA.sqlcode != 0 THEN
      #      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      #      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      #      EXIT PROGRAM
      #   END IF
      #   DECLARE r390_csfbn2 CURSOR FOR r390_prefbn2

      #   FOREACH r390_csfbn2 USING sr.faj02,sr.faj022,l_fbn03,l_fbn04 INTO sr2.*
      #      IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
      #      IF cl_null(sr2.fan07) THEN LET sr2.fan07 = 0 END IF
      #      IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
      #      IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
      #      IF cl_null(sr2.fan14) THEN LET sr2.fan14 = 0 END IF
      #      IF cl_null(sr2.fan15) THEN LET sr2.fan15 = 0 END IF
      #      #--->本月折舊
      #      LET sr2.curr = sr2.fan07
      #      
      #      #--->前期折舊 = (累折 - 本期累折)
      #      IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN
      #         LET sr2.pre_d = 0
      #      ELSE
      #         LET sr2.pre_d = sr2.fan15 - sr2.curr_d
      #      END IF
      #      #--->帳面價值 = (成本 - 累積折舊)
      #      LET sr2.curr_val = sr2.fan14-sr2.fan15
      #      
      #      INSERT INTO afar390_tmp2
      #       VALUES(sr.faj02,  sr.faj022, sr.faj93,  sr.faj04,  sr.faj05,   
      #              sr.faj06,  sr.faj07,  sr.faj14,  sr.faj20,  sr.faj23,   
      #              sr.faj24,  sr.faj26,  sr.faj29,  sr.faj31,  sr.faj32,   
      #              sr2.fan03, sr2.fan04, sr2.fan05, sr2.fan06, sr2.fan07,  
      #              sr2.fan09, sr2.fan14, sr2.fan15, sr2.pre_d, sr2.curr_d, 
      #              sr2.curr,  sr2.curr_val,sr2.fan041)
      #   END FOREACH
      #END IF
      #-MOD-D10174-mark-
    END FOREACH


##稅簽
     LET l_sql = "SELECT faj02,faj022,faj93,faj04,faj05,faj06,faj07,faj14,faj20,",
                 " faj23,faj24,faj26,faj64,faj66,faj67",
                 " FROM faj_file",
                 " WHERE ",tm.wc
     PREPARE r390_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
           
     END IF
     DECLARE r390_cs3 CURSOR FOR r390_prepare3

     #--->取每筆資產本年度月份折舊
     LET tm.wc2 = cl_replace_str(tm.wc2,"fbn06","fao06")
     LET l_sql = " SELECT fao03, fao04, fao05, fao06, fao07,",
                 "  fao09,fao14, fao15,0,fao08,0,0,fao041 ", #FUN-C20029 add fao041
                 " FROM fao_file ",
                 " WHERE fao01 = ? AND fao02 = ? ",
                 "   AND fao03 = ", tm.yyyy," AND fao04=",tm.mm,
                 "   AND (fao041='0' OR fao041='1')",
                 "   AND ",tm.wc2
    CASE
      WHEN tm.a = '1' #--->分攤前
       LET l_sql = l_sql clipped ," AND fao05 != '3' " clipped
      WHEN tm.a = '2' #--->分攤後
       LET l_sql = l_sql clipped ," AND fao05 != '2' " clipped
      OTHERWISE EXIT CASE
    END CASE

     PREPARE r390_prefao  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
           
     END IF
     DECLARE r390_csfao CURSOR FOR r390_prefao
                                                   
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

     LET g_pageno = 0
     
     INITIALIZE sr.* TO NULL
     FOREACH r390_cs3 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #--->篩選部門
       FOREACH r390_csfao USING sr.faj02,sr.faj022 INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r390_csfao:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          #--->本月折舊
          LET sr2.curr = sr2.fan07
          #--->前期折舊 = (累折 - 本期折舊)
          LET sr2.pre_d   = sr2.fan15 - sr2.curr_d
          #--->帳面價值 = (成本 - 累積折舊)
          LET sr2.curr_val = sr2.fan14-sr2.fan15
          
             INSERT INTO afar390_tmp3
              VALUES(sr.faj02,  sr.faj022, sr.faj93,  sr.faj04,  sr.faj05,   
                     sr.faj06,  sr.faj07,  sr.faj14,  sr.faj20,  sr.faj23,   
                     sr.faj24,  sr.faj26,  sr.faj29,  sr.faj31,  sr.faj32,   
                     sr2.fan03, sr2.fan04, sr2.fan05, sr2.fan06, sr2.fan07,  
                     sr2.fan09, sr2.fan14, sr2.fan15, sr2.pre_d, sr2.curr_d, 
                     sr2.curr,  sr2.curr_val,sr2.fan041)
       END FOREACH
    END FOREACH    

    IF cl_null(tm.rate) THEN LET tm.rate = 1 END IF #FUN-BB0163 add

    #FUN-C20029--start---add
    CASE 
       WHEN tm.sub = '1'
          LET l_sql = "SELECT faj02,faj022,fan06,fan041",
                      " FROM afar390_tmp1 ",
                      "UNION ",
                      "SELECT faj02,faj022,fan06,fan041",
                      " FROM afar390_tmp2 "
       WHEN tm.sub = '2'
          LET l_sql = "SELECT faj02,faj022,fan06,fan041",
                      " FROM afar390_tmp1 ",
                      "UNION ",
                      "SELECT faj02,faj022,fan06,fan041",
                      " FROM afar390_tmp3 "       
       WHEN tm.sub = '3'
          LET l_sql = "SELECT faj02,faj022,fan06,fan041",
                      " FROM afar390_tmp3 ",
                      "UNION ",
                      "SELECT faj02,faj022,fan06,fan041",
                      " FROM afar390_tmp2 "       
    END CASE
    PREPARE r390_prepare5 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE r390_curs5 CURSOR FOR r390_prepare5
    FOREACH r390_curs5 INTO l_faj02,l_faj022,l_fan06,l_fan041
    #FUN-C20029--start---end      
    
    CASE 
       WHEN tm.sub = '1' #財簽VS財簽2
         #FUN-C20029--start---add
         LET l_sql =  "SELECT A.faj04,A.faj93,A.faj02,A.faj022,A.faj26,A.faj05,A.faj06,",
                      "   A.faj29,A.faj31,A.faj32,",
                      "   B.faj292,B.faj312,B.faj322,",
                      "   A.fan06,A.fan09,A.fan14,B.fan14*",tm.rate,
                      "   ,A.pre_d,B.pre_d*",tm.rate,",A.curr_d,B.curr_d*",tm.rate,
                      "   ,A.curr,B.curr*",tm.rate,
                      "   ,A.curr_val,B.curr_val*",tm.rate,
                      " FROM ",
                      "(SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
                      "   faj29,faj31,faj32,",
                      "   fan06,fan09,fan14,",
                      "   pre_d,curr_d,curr,curr_val,fan041", 
                      " FROM afar390_tmp1 ",
                      " WHERE faj02='",l_faj02,"'",
                      " AND faj022 ='",l_faj022,"'",
                      " AND fan06 ='",l_fan06,"'",
                      " AND fan041 ='",l_fan041,"'",") A",
                      " FULL OUTER JOIN ",
                      "(SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
                      "   faj292,faj312,faj322,",
                      "   fan06,fan09,fan14,",
                      "   pre_d,curr_d,curr,curr_val,fan041", 
                      " FROM afar390_tmp2 ",
                      " WHERE faj02='",l_faj02,"'",
                      " AND faj022 ='",l_faj022,"'",
                      " AND fan06 ='",l_fan06,"'",
                      " AND fan041 ='",l_fan041,"'",") B",
                      " ON A.faj02=B.faj02 AND A.faj022=B.faj022 AND A.fan06=B.fan06"
         #FUN-C20029--end---add
         #FUN-C20029--start---mark         
         #LET l_sql = "SELECT A.faj04,A.faj93,A.faj02,A.faj022,A.faj26,A.faj05,A.faj06,",
         #            "   A.faj29,A.faj31,A.faj32,",
         #            "   B.faj292,B.faj312,B.faj322,",
         #            "   A.fan06,A.fan09,A.fan14,B.fan14*",tm.rate,
         #            "   ,A.pre_d,B.pre_d*",tm.rate,",A.curr_d,B.curr_d*",tm.rate,
         #            "   ,A.curr_val,B.curr_val*",tm.rate,
         #            " FROM afar390_tmp1 A",
         #            " LEFT OUTER JOIN afar390_tmp2 B ON A.faj02 = B.faj02",
         #            "    AND A.faj022 = B.faj022 ",
         #            " UNION ALL ",
         #            "SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
         #            "   null,null,null,",
         #            "   faj292,faj312,faj322,",
         #            "   fan06,fan09,null,fan14*",tm.rate,
         #            "   ,null,pre_d*",tm.rate,",null,curr_d*",tm.rate,
         #            "   ,null,curr_val*",tm.rate,
         #            " FROM afar390_tmp2 ",
         #            " WHERE faj02 not in (SELECT faj02 FROM afar390_tmp1)"
         #No:FUN-C20029---end---mark                      
       WHEN tm.sub = '2' #財簽VS稅簽
         #FUN-C20029--start---add
          LET l_sql = "SELECT A.faj04,A.faj93,A.faj02,A.faj022,A.faj26,A.faj05,A.faj06,",
                      "   A.faj29,A.faj31,A.faj32,",
                      "   B.faj64,B.faj66,B.faj67,",
                      "   A.fan06,A.fan09,A.fan14,B.fan14,",
                      "   A.pre_d,B.pre_d,A.curr_d,B.curr_d,",
                      "   A.curr,B.curr,",
                      "   A.curr_val,B.curr_val",
                      " FROM ",
                      "(SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
                      "   faj29,faj31,faj32,",
                      "   fan06,fan09,fan14,",
                      "   pre_d,curr_d,curr,curr_val,fan041", 
                      " FROM afar390_tmp1 ",
                      " WHERE faj02='",l_faj02,"'",
                      " AND faj022 ='",l_faj022,"'",
                      " AND fan06 ='",l_fan06,"'",
                      " AND fan041 ='",l_fan041,"'",") A",
                      " FULL OUTER JOIN ",
                      "(SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
                      "   faj64,faj66,faj67,",
                      "   fan06,fan09,fan14,",
                      "   pre_d,curr_d,curr,curr_val,fan041", 
                      " FROM afar390_tmp3 ",
                      " WHERE faj02='",l_faj02,"'",
                      " AND faj022 ='",l_faj022,"'",
                      " AND fan06 ='",l_fan06,"'",
                      " AND fan041 ='",l_fan041,"'",") B",
                      " ON A.faj02=B.faj02 AND A.faj022=B.faj022 AND A.fan06=B.fan06"
         #FUN-C20029--end---add       
         #FUN-C20029--start---mark
         #LET l_sql = "SELECT A.faj04,A.faj93,A.faj02,A.faj022,A.faj26,A.faj05,A.faj06,",
         #            "   A.faj29,A.faj31,A.faj32,",
         #            "   B.faj64,B.faj66,B.faj67,",
         #            "   A.fan06,A.fan09,A.fan14,B.fan14,",
         #            "   A.pre_d,B.pre_d,A.curr_d,B.curr_d,A.curr_val,B.curr_val",
         #            " FROM afar390_tmp1 A",
         #            " LEFT OUTER JOIN afar390_tmp3 B ON A.faj02 = B.faj02",
         #            "    AND A.faj022 = B.faj022 ",
         #            " UNION ALL ",
         #            "SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
         #            "   null,null,null,",
         #            "   faj64,faj66,faj67,",
         #            "   fan06,fan09,null,fan14",
         #            "   ,null,pre_d,null,curr_d,null,curr_val",
         #            " FROM afar390_tmp3 ",
         #            " WHERE faj02 not in (SELECT faj02 FROM afar390_tmp1)"
         #FUN-C20029---end---mark                       
       WHEN tm.sub = '3' #稅簽VS財簽2
         #FUN-C20029--start---add
          LET l_sql = "SELECT A.faj04,A.faj93,A.faj02,A.faj022,A.faj26,A.faj05,A.faj06,",
                      "   A.faj64,A.faj66,A.faj67,",
                      "   B.faj292,B.faj312,B.faj322,",
                      "   A.fan06,A.fan09,A.fan14,B.fan14*",tm.rate, 
                      "   ,A.pre_d,B.pre_d*",tm.rate,",A.curr_d,B.curr_d*",tm.rate,
                      "   ,A.curr,B.curr*",tm.rate,
                      "   ,A.curr_val,B.curr_val*",tm.rate,
                      " FROM ",
                      "(SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
                      "   faj64,faj66,faj67,",
                      "   fan06,fan09,fan14,",
                      "   pre_d,curr_d,curr,curr_val,fan041", 
                      " FROM afar390_tmp3 ",
                      " WHERE faj02='",l_faj02,"'",
                      " AND faj022 ='",l_faj022,"'",
                      " AND fan06 ='",l_fan06,"'",
                      " AND fan041 ='",l_fan041,"'",") A",
                      " FULL OUTER JOIN ",
                      "(SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
                      "   faj292,faj312,faj322,",
                      "   fan06,fan09,fan14,",
                      "   pre_d,curr_d,curr,curr_val,fan041", 
                      " FROM afar390_tmp2 ",
                      " WHERE faj02='",l_faj02,"'",
                      " AND faj022 ='",l_faj022,"'",
                      " AND fan06 ='",l_fan06,"'",
                      " AND fan041 ='",l_fan041,"'",") B",
                      " ON A.faj02=B.faj02 AND A.faj022=B.faj022 AND A.fan06=B.fan06"
         #FUN-C20029--end---add
         #No:FUN-C20029---start---mark         
         #LET l_sql = "SELECT A.faj04,A.faj93,A.faj02,A.faj022,A.faj26,A.faj05,A.faj06,",
         #            "   A.faj64,A.faj66,A.faj67,",
         #            "   B.faj292,B.faj312,B.faj322,",
         #            "   A.fan06,A.fan09,A.fan14,B.fan14*",tm.rate,
         #            "   ,A.pre_d,B.pre_d*",tm.rate,",A.curr_d,B.curr_d*",tm.rate,
         #            "   ,A.curr_val,B.curr_val*",tm.rate,
         #            " FROM afar390_tmp3 A",
         #            " LEFT OUTER JOIN afar390_tmp2 B ON A.faj02 = B.faj02",
         #            "    AND A.faj022 = B.faj022 ",
         #            " UNION ALL ",
         #            "SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06,",
         #            "   null,null,null,",
         #            "   faj292,faj312,faj322,",
         #            "   fan06,fan09,null,fan14*",tm.rate,
         #            "   ,null,pre_d*",tm.rate,",null,curr_d*",tm.rate,
         #            "   ,null,curr_val*",tm.rate,
         #            " FROM afar390_tmp2 ",
         #            " WHERE faj02 not in (SELECT faj02 FROM afar390_tmp3)"
         #No:FUN-C20029---end---mark                      
       OTHERWISE EXIT CASE
    END CASE
     PREPARE r390_prepare4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r390_cs4 CURSOR FOR r390_prepare4

     FOREACH r390_cs4 INTO sr3.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       #FUN-C20029--start--add
       #抓取只有右邊資料的基本資料
       IF cl_null(sr3.faj29) THEN 
         SELECT faj04,faj93,faj02,faj022,faj26,faj05,faj06
           INTO sr3.faj04,sr3.faj93,sr3.faj02,sr3.faj022,sr3.faj26,sr3.faj05,sr3.faj06
             FROM faj_file
           WHERE faj02=l_faj02 AND faj022=l_faj022
         IF tm.sub = '1' OR tm.sub = '3' THEN
         #財簽二資料
            SELECT fbn06,fbn09
              INTO l_fan06,sr3.fan09
                FROM fbn_file
              WHERE fbn01=l_faj02 AND fbn02=l_faj022 AND fbn06=l_fan06 AND fbn041=l_fan041
              AND fbn03=tm.yyyy AND fbn04=tm.mm
         ELSE
            SELECT fao06,fao09
              INTO l_fan06,sr3.fan09
                FROM fao_file
              WHERE fao01=l_faj02 AND fao02=l_faj022 AND fao06=l_fan06 AND fao041=l_fan041          
         #稅簽資料
         END IF  
       END IF
       #FUN-C20029--start--end       

       LET sr3.gem02_06 = ' ' #FUN-C20029 add
       SELECT gem02 INTO sr3.gem02_06  FROM gem_file
         WHERE gem01 = l_fan06 #FUN-C20029 sr3.fan06-->l_fan06
          
       LET sr3.gem02_09 = ' ' #FUN-C20029 add
       SELECT gem02 INTO sr3.gem02_09  FROM gem_file
         WHERE gem01 = sr3.fan09

       IF cl_null(sr3.gem02_06) THEN LET sr3.gem02_06 = ' ' END IF
       IF cl_null(sr3.gem02_09) THEN LET sr3.gem02_09 = ' ' END IF     
      #-----------------------MOD-D10174---------------------(S)
       IF cl_null(sr3.faj29) THEN LET sr3.faj29 = 0 END IF
       IF cl_null(sr3.faj29_1) THEN LET sr3.faj29_1 = 0 END IF
       IF cl_null(sr3.faj31) THEN LET sr3.faj31 = 0 END IF
       IF cl_null(sr3.faj31_1) THEN LET sr3.faj31_1 = 0 END IF
       IF cl_null(sr3.faj32) THEN LET sr3.faj32 = 0 END IF
       IF cl_null(sr3.faj32_1) THEN LET sr3.faj32_1 = 0 END IF
       IF cl_null(sr3.fan14) THEN LET sr3.fan14 = 0 END IF
       IF cl_null(sr3.fan14_1) THEN LET sr3.fan14_1 = 0 END IF
       IF cl_null(sr3.pre_d) THEN LET sr3.pre_d = 0 END IF
       IF cl_null(sr3.pre_d_1) THEN LET sr3.pre_d_1 = 0 END IF
       IF cl_null(sr3.curr_d) THEN LET sr3.curr_d = 0 END IF
       IF cl_null(sr3.curr_d_1) THEN LET sr3.curr_d_1 = 0 END IF
       IF cl_null(sr3.curr) THEN LET sr3.curr = 0 END IF
       IF cl_null(sr3.curr_1) THEN LET sr3.curr_1 = 0 END IF
       IF cl_null(sr3.curr_val) THEN LET sr3.curr_val = 0 END IF
       IF cl_null(sr3.curr_val_1) THEN LET sr3.curr_val_1 = 0 END IF
      #-----------------------MOD-D10174---------------------(E)

       EXECUTE insert_prep USING
               sr3.faj04    ,sr3.faj93    ,l_faj02      ,l_faj022    ,sr3.faj26, #FUN-C20029 sr3.faj02-->l_faj02,sr3.faj022-->l_faj022
               sr3.faj05    ,sr3.faj06    ,sr3.faj29     ,sr3.faj31   ,sr3.faj32,
               sr3.faj29_1  ,sr3.faj31_1  ,sr3.faj32_1  ,l_fan06     ,sr3.fan09, #FUN-C20029 sr3.fan06-->l_fan06
               sr3.fan14    ,sr3.fan14_1  ,sr3.pre_d     ,sr3.pre_d_1 ,sr3.curr_d,
               sr3.curr_d_1 ,sr3.curr     ,sr3.curr_1,
               sr3.curr_val ,sr3.curr_val_1,sr3.gem02_06,sr3.gem02_09
     END FOREACH
  END FOREACH #FUN-C20029 add

    IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06,faj93')                                                                 
       RETURNING tm.wc                                                                                                             
    END IF                                    

   #CHI-C60010---str---
     IF NOT cl_null(g_faj143) THEN
       SELECT azi04,azi05 INTO g_azi04_1,g_azi05_1 FROM azi_file
        WHERE azi01 = g_faj143
     END IF
    #CHI-C60010---end---
                                                                                     
    LET g_str = tm.wc,";",tm.yyyy,";",tm.mm,";",tm.s[1,1],";",                                                 
                tm.s[2,2],";",tm.s[3,3],";",g_azi04,";",g_azi05,";",
                tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",                                             
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.b,";",
                tm.rate,";",tm.sub,";",g_azi04_1,";",g_azi05_1     #CHI-C60010 add 'g_azi04_1,g_azi05_1'
                                                                                                             
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
    CALL cl_prt_cs3('afar390','afar390',g_sql,g_str)
END FUNCTION

#FUNCTION r300_chk_adj(p_faj02,p_faj022,p_fan15)            #CHI-CA0063 mark
FUNCTION r300_chk_adj(p_faj02,p_faj022,p_fan15,p_fan06)     #CHI-CA0063
   DEFINE p_faj02       LIKE faj_file.faj02,
          p_faj022      LIKE faj_file.faj022,
          p_fan15       LIKE fan_file.fan15,
          l_adj_fan07   LIKE fan_file.fan07,
          l_adj_fan07_1 LIKE fan_file.fan07,
          l_adj_fap54   LIKE fap_file.fap54,
          l_curr_fan07  LIKE fan_file.fan07,
          l_pre_fan15   LIKE fan_file.fan15,
          l_cnt         LIKE type_file.num5
         ,p_fan06       LIKE fan_file.fan06                 #CHI-CA0063

   LET l_cnt = 0
   LET l_adj_fan07 = 0
   SELECT COUNT(*) INTO l_cnt FROM fan_file
    WHERE fan01 = p_faj02 AND fan02 = p_faj022
      AND fan03 = tm.yyyy AND fan04 = tm.mm
      AND fan041 = '1'

   #調整折舊
   SELECT fan07 INTO l_adj_fan07 FROM fan_file
    WHERE fan01 = p_faj02 AND fan02 = p_faj022
      AND fan03 = tm.yyyy AND fan04 = tm.mm
      AND fan041 = '2'
      AND fan06 = p_fan06                       #CHI-CA0063
   IF cl_null(l_adj_fan07) THEN LET l_adj_fan07 = 0 END IF
   LET l_adj_fan07_1 = l_adj_fan07
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
#FUN-BB0051

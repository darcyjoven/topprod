# Prog. Version..: '5.30.06-13.03.18(00004)'     #
#
# Pattern name...: almg640.4gl
# Descriptions...: 贈品兌換報表 
# Date & Author..: No.FUN-CA0158 12/10/31 By pauline
# Modify.........: No.FUN-CC0023 12/12/06 By pauline 取兌換價值順序由參數決定
# Modify.........: No.FUN-D10011 13/01/03 By pauline 需求調整
# Modify.........: No.FUN-D10104 13/01/22 By pauline 製表日期印製錯誤
 
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                       # Print condition RECORD
           plant       STRING,
           year_sta    LIKE type_file.chr4,
           mon_sta     LIKE type_file.chr2,
           year_end    LIKE type_file.chr4, 
           mon_end     LIKE type_file.chr2, 
           ima01       STRING,
          #FUN-D10011 add START
           a           LIKE type_file.chr1,
           year_sta_a  LIKE type_file.chr4,
           mon_sta_a   LIKE type_file.chr2,
           year_end_a  LIKE type_file.chr4,
           mon_end_a   LIKE type_file.chr2,
          #FUN-D10011 add END
           more        LIKE type_file.chr1  # Input more condition(Y/N)
           END RECORD
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   l_store         STRING
DEFINE   g_wc            STRING        
DEFINE   g_lld01         LIKE lld_file.lld01   #兌換價值取價順序   #FUN-CC0023 add
DEFINE   g_ave_price     LIKE type_file.num20_6   #FUN-D10011 add   #平均公允價值
###GENGRE###START
TYPE sr_t RECORD
   ima01      LIKE ima_file.ima01,          #贈品編號
   ima02      LIKE ima_file.ima02,          #品名 
   plant      LIKE lrj_file.lrjplant,       #所屬營運中心
   azw08      LIKE azw_file.azw08,          #營運中心名稱
   tot_point  LIKE lrj_file.lrj07,          #總兌換點數
   tot_sum    LIKE type_file.num20,         #總兌換份數
   price      LIKE type_file.num20_6,       #兌換價值
   price_1    LIKE type_file.num20_6,       #公允價值
   tot_price  LIKE type_file.num20_6,       #總兌換價值
   source     LIKE type_file.chr1,          #來源項目
   year1      LIKE ccc_file.ccc02,          #西元年份
   month1     LIKE ccc_file.ccc03,          #月份
   flag       LIKE type_file.chr1           #FUN-D10011 add 
END RECORD
###GENGRE###END

MAIN

   OPTIONS
      INPUT NO WRAP          #输入的方式：不打转
   DEFER INTERRUPT           #撷取中断键

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.plant = ARG_VAL(7)
   LET tm.year_sta = ARG_VAL(8)
   LET tm.mon_sta = ARG_VAL(9)
   LET tm.year_end = ARG_VAL(10)
   LET tm.mon_end = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "ima01.ima_file.ima01,",          #贈品編號
                "ima02.ima_file.ima02,",          #贈品品名
                "plant.lrj_file.lrjplant,",       #所屬營運中心
                "azw08.azw_file.azw08,",          #營運中心名稱
                "tot_point.lrj_file.lrj07,",      #總兌換點數
                "tot_sum.type_file.num20,",       #總兌換份數
                "price.type_file.num20_6,",       #兌換價值
                "price_1.type_file.num20_6,",     #公允價值
                "tot_price.type_file.num20_6,",   #總兌換價值
                "source.type_file.chr1,",         #來源項目
                "year1.ccc_file.ccc02,",          #西元年份
                "month1.ccc_file.ccc03,",         #月份
                "flag.type_file.chr1 "             #FUN-D10011 add

   LET l_table = cl_prt_temptable('almg640',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   SELECT lld01 INTO g_lld01 FROM lld_file   #FUN-CC0023 add

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN #判斷是否是背景運行
      CALL g640_tm(5,10)                      #非背景運行，錄入打印報表條件
   ELSE
      CALL g640()                             #按傳入條件背景列印報表
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time


END MAIN
 

FUNCTION g640_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000 
   DEFINE l_date1        LIKE type_file.dat
   DEFINE l_date2        LIKE type_file.dat
   DEFINE l_j            LIKE type_file.num5
   DEFINE l_plant        STRING
   DEFINE l_i            LIKE type_file.num5   #FUN-CC0023 add
   DEFINE l_ze_all       LIKE ze_file.ze03     #FUN-CC0023 add
   DEFINE l_ze03         LIKE ze_file.ze03     #FUN-CC0023 add
   DEFINE l_aaa07        LIKE aaa_file.aaa07   #FUN-D10011 add
 

   OPEN WINDOW g640_w AT p_row,p_col WITH FORM "alm/42f/almg640"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition

  #FUN-CC0023 add START
   LET l_i = length(g_lld01) 
   LET l_ze_all = cl_getmsg('alm-h96',g_lang)
   FOR l_j = 1 TO l_i  
      IF g_lld01[l_j,l_j] = '1' THEN
         LET l_ze03  = cl_getmsg('alm-h92',g_lang) 
      END IF
      IF g_lld01[l_j,l_j] = '2' THEN
         LET l_ze03  = cl_getmsg('alm-h93',g_lang)
      END IF
      IF g_lld01[l_j,l_j] = '3' THEN
         LET l_ze03  = cl_getmsg('alm-h94',g_lang)
      END IF
      IF g_lld01[l_j,l_j] = '4' THEN
         LET l_ze03  = cl_getmsg('alm-h95',g_lang)
      END IF
      LET l_ze_all = l_ze_all, " ",l_ze03
   END FOR 
   CALL cl_set_comp_lab_text('dummy2',l_ze_all) 
  #FUN-CC0023 add END

   LET tm.year_sta = YEAR(g_today)
  #LET tm.mon_sta  = MONTH(g_today)   #FUN-D10011 mark 
   LET tm.mon_sta  = MONTH(g_today) USING "&&"   #FUN-D10011 add
   LET tm.year_end = YEAR(g_today)
  #LET tm.mon_end  = MONTH(g_today)   #FUN-D10011 mark 
   LET tm.mon_end  = MONTH(g_today) USING "&&"   #FUN-D10011
   LET tm.more = 'N'
  #FUN-D10011 add sTART
   SELECT aaa07 INTO l_aaa07 FROM aaa_file
      WHERE aaa01 = g_aza.aza81
   LET tm.a = 'N' 
   IF tm.a = 'N' THEN
      CALL cl_set_comp_entry("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",FALSE)
      CALL cl_set_comp_required("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",FALSE)
   ELSE
      CALL cl_set_comp_entry("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",TRUE)
      CALL cl_set_comp_required("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",TRUE)
   END IF
  #FUN-D10011 add END
   WHILE TRUE
      DIALOG ATTRIBUTE(UNBUFFERED)

         CONSTRUCT BY NAME tm.plant on azw01 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

         END CONSTRUCT 

         INPUT BY NAME tm.year_sta, tm.mon_sta,tm.year_end,
                       tm.mon_end  
                       ATTRIBUTE(WITHOUT DEFAULTS)
    
            AFTER FIELD year_sta
               IF NOT cl_null(tm.year_sta) THEN
                  IF length(tm.year_sta) <> 4 THEN
                     CALL cl_err('','alm-h79',0)
                     NEXT FIELD year_sta
                  END IF
                  FOR l_j = 1 TO 4
                      IF tm.year_sta[l_j,l_j] NOT MATCHES '[0-9]' THEN
                         CALL cl_err('','alm-h80',0)
                         NEXT FIELD year_sta
                      END IF
                  END FOR
                  IF NOT cl_null(tm.year_end) THEN
                     IF tm.year_sta > tm.year_end THEN
                         CALL cl_err('','alm-h78',0)
                         NEXT FIELD year_sta
                     END IF
                  END IF
               END IF
       
            AFTER FIELD mon_sta
               IF NOT cl_null(tm.mon_sta) THEN
                  IF length(tm.mon_sta) <> 2 THEN
                     CALL cl_err('','alm-h81',0)
                     NEXT FIELD mon_sta
                  END IF
                  IF tm.mon_sta[1,1] NOT MATCHES '[01]' THEN
                     CALL cl_err('','alm-h82',0)
                     NEXT FIELD mon_sta
                  END IF
                  IF tm.mon_sta[1,1] = '1' THEN
                     IF tm.mon_sta[2,2] NOT MATCHES '[012]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_sta
                     END IF
                  ELSE
                     IF tm.mon_sta[2,2] NOT MATCHES '[1-9]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_sta
                     END IF
                  END IF
                  IF NOT cl_null(tm.year_sta) AND NOT cl_null(tm.year_sta)
                     AND NOT cl_null(tm.mon_end) THEN
                     IF tm.mon_sta > tm.mon_end AND 
                        (tm.year_sta = tm.year_end OR tm.year_sta > tm.year_end ) THEN
                        CALL cl_err('','alm-h78',0)
                        NEXT FIELD mon_sta
                     END IF
                  END IF
               END IF
       
            AFTER FIELD year_end
               IF NOT cl_null(tm.year_end) THEN
                  IF length(tm.year_end) <> 4 THEN
                     CALL cl_err('','alm-h79',0)
                     NEXT FIELD year_end
                  END IF
                  FOR l_j = 1 TO 4
                      IF tm.year_end[l_j,l_j] NOT MATCHES '[0-9]' THEN
                         CALL cl_err('','alm-h80',0)
                         NEXT FIELD year_end
                      END IF
                  END FOR
                  IF NOT cl_null(tm.year_sta) THEN
                     IF tm.year_sta > tm.year_end THEN
                         CALL cl_err('','alm-h78',0)
                         NEXT FIELD year_end
                     END IF
                  END IF
               END IF
       
            AFTER FIELD mon_end
               IF NOT cl_null(tm.mon_end) THEN
                  IF length(tm.mon_end) <> 2 THEN
                     CALL cl_err('','alm-h81',0)
                     NEXT FIELD mon_end
                  END IF
                  IF tm.mon_end[1,1] NOT MATCHES '[01]' THEN
                     CALL cl_err('','alm-h82',0)
                     NEXT FIELD mon_end
                  END IF
                  IF tm.mon_end[1,1] = '1' THEN
                     IF tm.mon_end[2,2] NOT MATCHES '[012]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_end
                     END IF
                  ELSE
                     IF tm.mon_end[2,2] NOT MATCHES '[1-9]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_end
                     END IF
                  END IF
                  IF NOT cl_null(tm.year_sta) AND NOT cl_null(tm.year_sta)
                     AND NOT cl_null(tm.mon_sta) THEN
                     IF tm.mon_sta > tm.mon_end AND 
                        (tm.year_sta = tm.year_end OR tm.year_sta > tm.year_end ) THEN
                        CALL cl_err('','alm-h78',0)
                        NEXT FIELD mon_end
                     END IF
                  END IF
               END IF
       
         END INPUT 


         CONSTRUCT BY NAME tm.ima01 on ima01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

         END CONSTRUCT

        #FUN-D10011 add START
         INPUT BY NAME tm.a, tm.year_sta_a, tm.mon_sta_a,             
                       tm.year_end_a,tm.mon_end_a                     
                       ATTRIBUTE(WITHOUT DEFAULTS)
            ON CHANGE a 
               IF tm.a = 'N' THEN
                  CALL cl_set_comp_entry("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",FALSE)
                  CALL cl_set_comp_required("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",FALSE)
               ELSE
                  CALL cl_set_comp_entry("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",TRUE)
                  CALL cl_set_comp_required("year_sta_a, mon_sta_a, year_end_a, mon_end_a ",TRUE)
               END IF

            AFTER FIELD year_sta_a
               IF NOT cl_null(tm.year_sta_a) AND tm.a = 'Y' THEN
                  IF length(tm.year_sta_a) <> 4 THEN
                     CALL cl_err('','alm-h79',0)
                     NEXT FIELD year_sta_a
                  END IF
                  FOR l_j = 1 TO 4
                      IF tm.year_sta_a[l_j,l_j] NOT MATCHES '[0-9]' THEN
                         CALL cl_err('','alm-h80',0)
                         NEXT FIELD year_sta_a
                      END IF
                  END FOR
                  IF NOT cl_null(tm.year_end_a) THEN
                     IF tm.year_sta_a > tm.year_end_a THEN
                         CALL cl_err('','alm-h78',0)
                         NEXT FIELD year_sta_a
                     END IF
                  END IF
                  IF tm.year_sta_a < YEAR(l_aaa07) THEN
                     CALL cl_err('','alm1392',0) 
                     NEXT FIELD year_sta_a
                  END IF
                  IF tm.year_sta_a = YEAR(l_aaa07) 
                     AND NOT cl_null(tm.mon_sta_a) THEN
                     IF tm.mon_sta_a < MONTH(l_aaa07) OR tm.mon_sta_a = MONTH(l_aaa07) THEN
                        CALL cl_err('','alm1392',0)
                        NEXT FIELD year_sta_a
                     END IF
                  END IF
               END IF

            AFTER FIELD mon_sta_a
               IF NOT cl_null(tm.mon_sta_a) AND tm.a = 'Y' THEN
                  IF length(tm.mon_sta_a) <> 2 THEN
                     CALL cl_err('','alm-h81',0)
                     NEXT FIELD mon_sta_a
                  END IF
                  IF tm.mon_sta_a[1,1] NOT MATCHES '[01]' THEN
                     CALL cl_err('','alm-h82',0)
                     NEXT FIELD mon_sta_a
                  END IF
                  IF tm.mon_sta_a[1,1] = '1' THEN
                     IF tm.mon_sta_a[2,2] NOT MATCHES '[012]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_sta_a
                     END IF
                  ELSE
                     IF tm.mon_sta_a[2,2] NOT MATCHES '[1-9]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_sta_a
                     END IF
                  END IF
                  IF NOT cl_null(tm.year_sta_a) AND NOT cl_null(tm.year_sta_a)
                     AND NOT cl_null(tm.mon_end_a) THEN
                     IF tm.mon_sta_a > tm.mon_end_a AND
                        (tm.year_sta_a = tm.year_end_a OR tm.year_sta_a > tm.year_end_a ) THEN
                        CALL cl_err('','alm-h78',0)
                        NEXT FIELD mon_sta_a
                     END IF
                  END IF
                  IF NOT cl_null(tm.year_sta_a) AND tm.year_sta_a = YEAR(l_aaa07) 
                     AND NOT cl_null(tm.mon_sta_a) THEN
                     IF tm.mon_sta_a < MONTH(l_aaa07) OR tm.mon_sta_a = MONTH(l_aaa07) THEN
                        CALL cl_err('','alm1392',0)
                        NEXT FIELD mon_sta_a
                     END IF
                  END IF
               END IF

            AFTER FIELD year_end_a
               IF NOT cl_null(tm.year_end_a) AND tm.a = 'Y' THEN
                  IF length(tm.year_end_a) <> 4 THEN
                     CALL cl_err('','alm-h79',0)
                     NEXT FIELD year_end_a
                  END IF
                  FOR l_j = 1 TO 4
                      IF tm.year_end_a[l_j,l_j] NOT MATCHES '[0-9]' THEN
                         CALL cl_err('','alm-h80',0)
                         NEXT FIELD year_end_a
                      END IF
                  END FOR
                  IF NOT cl_null(tm.year_sta_a) THEN
                     IF tm.year_sta_a > tm.year_end_a THEN
                         CALL cl_err('','alm-h78',0)
                         NEXT FIELD year_end_a
                     END IF
                  END IF
               END IF

            AFTER FIELD mon_end_a
               IF NOT cl_null(tm.mon_end_a) THEN
                  IF length(tm.mon_end_a) <> 2 THEN
                     CALL cl_err('','alm-h81',0)
                     NEXT FIELD mon_end_a
                  END IF
                  IF tm.mon_end_a[1,1] NOT MATCHES '[01]' THEN
                     CALL cl_err('','alm-h82',0)
                     NEXT FIELD mon_end_a
                  END IF
                  IF tm.mon_end_a[1,1] = '1' THEN
                     IF tm.mon_end_a[2,2] NOT MATCHES '[012]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_end_a
                     END IF
                  ELSE
                     IF tm.mon_end_a[2,2] NOT MATCHES '[1-9]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon_end_a
                     END IF
                  END IF
                  IF NOT cl_null(tm.year_sta_a) AND NOT cl_null(tm.year_sta_a)
                     AND NOT cl_null(tm.mon_sta_a) THEN
                     IF tm.mon_sta_a > tm.mon_end_a AND
                        (tm.year_sta_a = tm.year_end_a OR tm.year_sta_a > tm.year_end_a ) THEN
                        CALL cl_err('','alm-h78',0)
                        NEXT FIELD mon_end_a
                     END IF
                  END IF
               END IF


            AFTER INPUT 
               IF tm.a = 'Y' THEN
                  IF cl_null(tm.year_sta_a) THEN 
                     NEXT FIELD year_sta_a
                  END IF
                  IF cl_null(tm.mon_sta_a) THEN 
                     NEXT FIELD mon_sta_a
                  END IF
                  IF cl_null(tm.year_end_a) THEN
                     NEXT FIELD year_end_a
                  END IF
                  IF cl_null(tm.mon_sta_a) THEN
                     NEXT FIELD mon_sta_a
                  END IF
               END IF   
         END INPUT
        #FUN-D10011 add END

         CONSTRUCT BY NAME tm.ima01 on ima01 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

         END CONSTRUCT

         INPUT BY NAME tm.more ATTRIBUTE(WITHOUT DEFAULTS)

         END INPUT
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(azw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azw"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azw01 
                  NEXT FIELD azw01  
       
               WHEN INFIELD(ima01) 
                  CALL GET_FLDBUF(azw01) RETURNING l_plant 
                  CALL q_lrg(TRUE,TRUE,l_plant,tm.year_sta,tm.mon_sta,tm.year_end,tm.mon_end)
                     RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO ima01 
                  NEXT FIELD ima01 
            END CASE
       
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT DIALOG 
       
         ON ACTION CONTROLG
            CALL cl_cmdask()
       
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
       
         ON ACTION about
            CALL cl_about()
       
         ON ACTION HELP
            CALL cl_show_help()
       
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT DIALOG 

         ON ACTION ACCEPT
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
                   RETURNING g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies
            END IF
            EXIT DIALOG
       
         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG 
       

      END DIALOG
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW g640_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='almg640'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('almg640','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.plant CLIPPED,"'" ,
                       " '",tm.year_sta CLIPPED,"'" ,
                       " '",tm.mon_sta CLIPPED,"'" ,
                       " '",tm.year_end CLIPPED,"'" ,
                       " '",tm.mon_end CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('almg640',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g640_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g640()
      ERROR ""
    
   END WHILE
   
   CLOSE WINDOW g640_w
END FUNCTION


FUNCTION g640() 
   DEFINE l_n           LIKE type_file.num5    #計算月
   DEFINE l_sql         STRING  
   DEFINE l_i           LIKE type_file.num5  
   DEFINE l_plant       LIKE azp_file.azp01,
          l_azp02       LIKE azp_file.azp02
   DEFINE l_date1       LIKE type_file.dat
   DEFINE l_date2       LIKE type_file.dat
   DEFINE l_wc1         STRING
   DEFINE l_wc2         STRING
   DEFINE l_lrg03       LIKE lrg_file.lrg03 
   DEFINE l_lrg04       LIKE lrg_file.lrg04
   DEFINE l_sum         LIKE type_file.num5
   DEFINE l_i2          LIKE type_file.num5 
   DEFINE l_n2          LIKE type_file.num5
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE l_year        LIKE ccc_file.ccc02
   DEFINE l_month       LIKE ccc_file.ccc03
   DEFINE l_lrf01       LIKE lrf_file.lrf01
   DEFINE l_lrj07       LIKE lrj_file.lrj07
   DEFINE lpx32         LIKE lpx_file.lpx32
   DEFINE l_lrz02       LIKE lrz_file.lrz02
   DEFINE l_sum_lrf03   LIKE lrf_file.lrf03
   DEFINE l_point       LIKE type_file.num5   
   DEFINE l_lrf01_old   LIKE lrf_file.lrf01
   DEFINE l_n3          LIKE type_file.num5  #計算單身筆數
   DEFINE l_n4          LIKE type_file.num5  #計算目前單身筆數
   DEFINE l_point2      LIKE lsm_file.lsm04  #計算目前兌換點數
   DEFINE l_j           LIKE type_file.num5  #FUN-CC0023 add
   DEFINE l_sum2        LIKE type_file.num20_6 #FUN-D10011 add
   DEFINE l_sum3        LIKE type_file.num20_6 #FUN-D10011 add 
 
   DEFINE sr RECORD
      ima01      LIKE ima_file.ima01,          #贈品編號
      ima02      LIKE ima_file.ima02,          #贈品品名
      plant      LIKE lrj_file.lrjplant,       #所屬營運中心
      azw08      LIKE azw_file.azw08,          #營運中心名稱
      tot_point  LIKE lrj_file.lrj07,          #總兌換點數
      tot_sum    LIKE type_file.num20,         #總兌換份數
      price      LIKE type_file.num20_6,       #兌換價值
      price_1    LIKE type_file.num20_6,       #公允價值
      tot_price  LIKE type_file.num20_6,       #總兌換價值
      source     LIKE type_file.chr1,          #來源項目
      year1      LIKE ccc_file.ccc02,          #西元年份
      month1     LIKE ccc_file.ccc03,          #月份
      flag       LIKE type_file.chr1           #FUN-D10011 add
   END RECORD


   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?) "    #FUN-D10011 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET g_pdate = g_today    #FUN-D10104 add
 
   LET l_wc1 = cl_replace_str(tm.ima01, 'ima01 ' ,'lrg02 ')
   LET l_wc2 = cl_replace_str(tm.ima01, 'ima01 ' ,'lpx32 ') 
  #LET g_wc = l_wc1 CLIPPED," AND ",l_wc2 CLIPPED   #FUN-D10104 mark 
  #FUN-D10104 add START
   LET g_wc = tm.ima01, " AND ",tm.plant  #FUN-D10104 add
   LET g_wc = g_wc, " AND lrl13 BETWEEN ",MDY(tm.mon_sta,'1',tm.year_sta)," AND ",MDY(tm.mon_end+1,'1',tm.year_end)-1   
   IF tm.mon_end = 12 THEN
      LET g_wc = g_wc, " AND ",MDY('12','31',tm.year_end)
   ELSE
      LET g_wc = g_wc, " AND ",MDY(tm.mon_end+1,'1',tm.year_end)-1  
   END IF
  #FUN-D10104 add END

   #計算起迄時間內共經過幾個月份
   IF tm.mon_sta > tm.mon_end THEN 
      LET tm.mon_end = tm.mon_end + 12
      LET tm.year_end = tm.year_end - 1
   END IF
   LET l_n = tm.mon_end - tm.mon_sta + 1 
   LET l_n = l_n + (tm.year_end - tm.year_sta) * 12
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF
   IF l_n = 0 OR l_n < 0 THEN 
      CALL cl_err('','',0)
      RETURN 
   END IF

   IF tm.mon_sta = 12 THEN
      LET l_date1 = MDY('1','1',tm.year_sta +1) 
   ELSE
      LET l_date1 = MDY(tm.mon_sta,'1',tm.year_sta) 
   END IF


   FOR l_i = 1 TO l_n  

      #計算每個月份的起始
      IF l_i = 1 THEN
         IF MONTH(l_date1) = 12 THEN
            LET l_date2 = MDY('1','1',YEAR(l_date1)+1 )-1 
         ELSE
            LET l_date2 = MDY(MONTH(l_date1) +1,'1',YEAR(l_date1))-1         
         END IF
      ELSE
         IF MONTH(l_date1) = 12 THEN
            LET l_date1 = MDY('1','1',YEAR(l_date1)+1 )                
         ELSE
            LET l_date1 = MDY(MONTH(l_date1) +1,'1',YEAR(l_date1))
         END IF

         IF MONTH(l_date1) = 12 THEN
            LET l_date2 = MDY('1','1',YEAR(l_date1)+1 )-1                
         ELSE
            LET l_date2 = MDY(MONTH(l_date1) +1,'1',YEAR(l_date1))-1
         END IF

      END IF

      LET l_year = YEAR(l_date1)
      LET l_month = MONTH(l_date1)
      LET sr.year1 = l_year
      LET sr.month1 = l_month
      LET sr.flag = 'Y'   #FUN-D10011 add
      LET l_sql = "SELECT DISTINCT azw01,azw08 FROM azw_file,rtz_file ",
                 " WHERE azw01 = rtz01  ",
                 " AND ",tm.plant,
                 " AND azw01 IN ",g_auth,
                 " ORDER BY azw01 "
      PREPARE sel_azp01_pre FROM l_sql
      DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
      FOREACH sel_azp01_cs INTO l_plant,l_azp02
         LET sr.plant = l_plant
         LET sr.azw08 = l_azp02
        #撈取almt605的資料,寫入temp table內
         LET l_sql = " SELECT  lrg02,lrg03,sum(lrg04),lrg03 * lrg04  ",
                     "  FROM   " ,cl_get_target_table(l_plant, 'lrg_file'),
                     "    JOIN  ",cl_get_target_table(l_plant, 'lrl_file'),
                     "      ON lrg01 = lrl01 ",
                     "    JOIN ima_file ",
                     "      ON ima01 = lrg02 ",
                     "   WHERE  lrl11  = 'Y' ",
                     "     AND lrl13 BETWEEN CAST('",l_date1,"' AS DATE) AND CAST('",l_date2,"' AS DATE)", 
                     "     AND lrlplant = '",l_plant,"' ",
                     "     AND lrl15 = '0' ",
                     "     AND ",l_wc1,
                     " GROUP BY lrg01,lrg02,lrg03,lrg04  "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE almg640_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
         DECLARE almg640_curs1 CURSOR FOR almg640_prepare1
         FOREACH almg640_curs1 INTO sr.ima01,l_lrg03,l_lrg04,l_sum
            IF cl_null(sr.ima01) THEN CONTINUE FOREACH END IF
            SELECT ima02 INTO sr.ima02 FROM ima_file WHERE ima01 = sr.ima01
            LET l_n2 = 0
            LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,
                        "   WHERE ima01 = '",sr.ima01,"' ",
                        "     AND plant = '",sr.plant,"' "
            PREPARE g640_prepare2 FROM l_sql
            EXECUTE g640_prepare2 INTO l_n2  

           #以年,月,料號,營運中心為pk值,若已經存在直接update總兌換點數,總兌換數量,公允價值,總兌換價值
            IF l_n2 > 0 THEN  
               CALL g640_upd_temp(l_sum,l_lrg04,sr.ima01,sr.plant,'1','')

            ELSE
               LET sr.tot_point = l_sum
               LET sr.tot_sum = l_lrg04
               LET l_flag = FALSE
              #取兌換價值
              #抓取的順序為 1.市價、2.最近銷售單價、3.最近採購單價、4.月加權平均成本
              #FUN-CC0023 mark START
              #兌換價值順序改為由lld01參數決定順序
              #CALL g640_get_cmf(sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
              #IF l_flag THEN
              #   LET sr.source = '1' 
              #END IF
              #IF NOT l_flag THEN
              #   CALL g640_get_ccc('1',sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
              #   IF l_flag THEN
              #      LET sr.source = '2' 
              #   END IF
              #END IF
              #IF NOT l_flag THEN
              #   CALL g640_get_ccc('2',sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
              #   IF l_flag THEN
              #      LET sr.source = '3'
              #   END IF
              #END IF
              #IF NOT l_flag THEN
              #   CALL g640_get_ccc('3',sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
              #   IF l_flag THEN
              #      LET sr.source = '4'
              #   ELSE
              #      LET sr.price = 0
              #      LET sr.source = ' '
              #   END IF
              #END IF
              #FUN-CC0023 mark END
              #FUN-CC0023 add START
               LET l_i = length(g_lld01)
               FOR l_j = 1 TO l_i
                  IF cl_null(g_lld01[l_j,l_j]) THEN CONTINUE FOR END IF
                 #市價
                  IF g_lld01[l_j,l_j] = '1' THEN
                     CALL g640_get_cmf(sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
                     IF l_flag THEN
                        LET sr.source = '1'
                     END IF
                  END IF
                 #2.最近銷售單價
                  IF g_lld01[l_j,l_j] = '2' THEN
                     IF NOT l_flag THEN
                        CALL g640_get_ccc('1',sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
                        IF l_flag THEN
                           LET sr.source = '2'
                        END IF
                     END IF
                  END IF
                 #3.最近採購單價
                  IF g_lld01[l_j,l_j] = '3' THEN
                     IF NOT l_flag THEN
                        CALL g640_get_ccc('2',sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
                        IF l_flag THEN
                           LET sr.source = '3'
                        END IF
                     END IF
                  END IF
                 #4.月加權平均成本
                  IF g_lld01[l_j,l_j] = '4' THEN
                     IF NOT l_flag THEN
                        CALL g640_get_ccc('1',sr.ima01,l_year,l_month) RETURNING l_flag,sr.price
                        IF l_flag THEN
                           LET sr.source = '4'
                        END IF
                     END IF
                  END IF
               END FOR
              #FUN-CC0023 add END
              #公允價值 = 兌換價值 * 兌換份數 / 總兌換點數
               LET sr.price_1 = sr.price * sr.tot_sum / sr.tot_point
              #總兌換價值 =  兌換價值 * 總兌換份數
               LET sr.tot_price = sr.price * sr.tot_sum
               EXECUTE  insert_prep  USING sr.*
            END IF           
         END FOREACH

        #撈取almt595的資料寫入temp table
         LET l_sql = " SELECT  lrf01,lrj07,lpx32,lrz02",
                     "  FROM   " ,cl_get_target_table(l_plant, 'lrf_file'),
                     "    JOIN  ",cl_get_target_table(l_plant, 'lrj_file'),
                     "      ON lrj01= lrf01 ",
                     "    JOIN  ",cl_get_target_table(l_plant, 'lqe_file'),
                     "      ON lqe01 = lrf02 ",
                     "    JOIN  ",cl_get_target_table(l_plant, 'lpx_file'),
                     "      ON lpx01 = lqe02 ",
                     "    JOIN  ",cl_get_target_table(l_plant, 'lrz_file'),
                     "      ON lqe03 = lrz01 ",
                     "    JOIN ima_file ",
                     "      ON lpx32 = ima01" ,
                     "   WHERE  lrj10  = 'Y' ",
                     "     AND lrj12 BETWEEN CAST('",l_date1,"' AS DATE) AND CAST('",l_date2,"' AS DATE)",
                     "     AND lrjplant = '",l_plant,"' ",
                     "     AND lrj14 = '0' ",
                     "     AND ",l_wc2 ,
                     "   ORDER BY lrf01 "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE almg640_prepare6 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
         DECLARE almg640_curs6 CURSOR FOR almg640_prepare6
         FOREACH almg640_curs6 INTO l_lrf01,l_lrj07,sr.ima01,l_lrz02 
            IF cl_null(sr.ima01) THEN CONTINUE FOREACH END IF
            IF cl_null(l_lrf01) THEN CONTINUE FOREACH END IF
           #判斷是否來自於同一張兌換單
            IF l_lrf01_old = l_lrf01 THEN
               LET l_n4 = l_n4 + 1
            ELSE
               LET l_n4 = 1
               LET l_point2 = 0 
               LET l_lrf01_old = l_lrf01  #記錄舊值
            END IF
            SELECT ima02 INTO sr.ima02 FROM ima_file WHERE ima01 = sr.ima01
            LET l_sql = " SELECT SUM(lrf03) FROM ",cl_get_target_table(l_plant, 'lrf_file'), 
                        "   WHERE lrf01 = '",l_lrf01,"' " 
            PREPARE g640_prepare7 FROM l_sql
            EXECUTE g640_prepare7 INTO l_sum_lrf03             

           #計算此張單單身比數
            LET l_sql = " SELECT COUNT(lrf02) FROM ",cl_get_target_table(l_plant, 'lrf_file'),
                        "   WHERE lrf01 = '",l_lrf01,"' "
            PREPARE g640_prepare8 FROM l_sql
            EXECUTE g640_prepare8 INTO l_n3            
           
           #當單身只有一筆資料時,兌換積分 = 兌換總積分
            IF l_n3 = 1 THEN 
               LET l_point = l_lrj07
            ELSE 
              #以比例計算出各券面額所需的兌換積分 
              #兌換積分 = 總兌換積分 / 總兌換面額 * 券面額
              #如果是此張單最後一筆兌換記錄,兌換積分 = 總兌換積分 - 之前的兌換積分
               IF l_n4 = l_n3 THEN
                  LET l_point = l_lrj07 - l_point2 
               ELSE
                  LET l_point = l_lrj07 / l_sum_lrf03 * l_lrz02
                  LET l_point2 = l_point2 + l_point 
               END IF
            END IF
            LET l_n2 = 0 
            LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,
                        "   WHERE ima01 = '",sr.ima01,"' ",
                        "     AND plant = '",sr.plant,"' ",
                        "     AND price = ",l_lrz02," AND source = '1'  "

            PREPARE g640_prepare9 FROM l_sql
            EXECUTE g640_prepare9 INTO l_n2
            IF l_n2 > 0 THEN
               CALL g640_upd_temp(l_point,1,sr.ima01,sr.plant,'2',l_lrz02)
            ELSE
               LET sr.tot_point = l_point 
               LET sr.tot_sum = 1 
               LET l_flag = FALSE
              #禮券來源項目為1.市價,兌換價值為面額
               LET sr.source = '1'
               LET sr.price = l_lrz02 
              #公允價值 = 兌換價值 * 兌換份數 / 總兌換點數
               LET sr.price_1 = sr.price * sr.tot_sum / sr.tot_point
              #總兌換價值 =  兌換價值 * 總兌換份數
               LET sr.tot_price = sr.price * sr.tot_sum
               EXECUTE  insert_prep  USING sr.*
            END IF
         END FOREACH         
 
      END FOREACH      

   END FOR

  #FUN-D10011 add START
  #計算公允價值平均
   LET l_sum2 = 0  
   LET g_ave_price = 0
   LET l_sum3 = 0
   LET l_sql = " SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE g640_prepare10 FROM l_sql
   EXECUTE g640_prepare10 INTO l_sum2 

   IF NOT cl_null(l_sum2) AND l_sum2 > 0 THEN
      LET l_sql = " SELECT SUM(price_1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
      PREPARE g640_prepare11 FROM l_sql
      EXECUTE g640_prepare11 INTO l_sum3 
      IF cl_null(l_sum3) THEN LET l_sum3 = 0 END IF
      LET g_ave_price = l_sum3 / l_sum2 
   END IF
   IF tm.a = 'Y' THEN
      CALL g640_upd_price()
   END IF
   
  #FUN-D10011 add END

  #FUN-D10104 add START
   CALL cl_wcchp(g_wc,'ima01,azw01,lrl13') RETURNING g_wc
   IF g_wc.getLength() > 1000 THEN
       LET g_wc = g_wc.subString(1,600)
       LET g_wc = g_wc,"..."
   END IF
  #FUN-D10104 add END

   CALL g640_grdata()

END FUNCTION


FUNCTION g640_grdata()
   DEFINE sr1      sr_t
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_msg    STRING

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN RETURN END IF

   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("almg640")
       IF handler IS NOT NULL THEN
           START REPORT almg640_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       "  ORDER BY ima01"

           DECLARE almg640_datacur1 CURSOR FROM l_sql
           FOREACH almg640_datacur1 INTO sr1.*
               OUTPUT TO REPORT almg640_rep(sr1.*)
           END FOREACH
           FINISH REPORT almg640_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()

END FUNCTION


REPORT almg640_rep(sr1)
   DEFINE sr1 sr_t
   DEFINE l_lineno LIKE type_file.num5
   DEFINE l_source LIKE ze_file.ze03
   DEFINE l_azw08  LIKE azw_file.azw08 
   DEFINE l_date   STRING
   DEFINE l_sum    LIKE type_file.num20_6   #FUN-D10011 add 
   DEFINE l_desc   LIKE ze_file.ze03        #FUN-D10011 add 

   ORDER EXTERNAL BY sr1.flag,sr1.ima01,sr1.plant   #FUN-D10011 add flag
   FORMAT
       FIRST PAGE HEADER
           LET l_date = tm.year_sta,"/",tm.mon_sta,"~",tm.year_end,"/",tm.mon_end
           PRINTX g_grPageHeader.*
           PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
           PRINTX tm.*
           PRINTX g_wc
           PRINTX l_date

       ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno
           LET l_source = cl_gr_getmsg('alm-h77',g_lang,sr1.source) 
           PRINTX l_source                                          
           PRINTX sr1.*

       ON LAST ROW
      
      #FUN-D10011 add START
       AFTER GROUP OF sr1.flag   
           LET l_desc = cl_getmsg('alm1394',g_lang)
           PRINTX g_ave_price 
           PRINTX l_desc 
      #FUN-D10011 add END

END REPORT

FUNCTION g640_get_cmf(p_ima01,p_year,p_month)
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_ima01     LIKE ima_file.ima01
   DEFINE p_month     LIKE cmf_file.cmf02
   DEFINE p_year      LIKE cmf_file.cmf01
   DEFINE l_cmf05     LIKE cmf_file.cmf05
   

   SELECT COUNT(*) INTO l_n FROM cmf_file
     WHERE cmf01 = p_year AND cmf02 = p_month 
       AND cmf04 = p_ima01
   IF l_n = 0 OR cl_null(l_n) THEN
      RETURN FALSE,0
   END IF   
   SELECT cmf05 INTO l_cmf05 FROM cmf_file
     WHERE cmf01 = p_year AND cmf02 = p_month
       AND cmf04 = p_ima01

   RETURN TRUE, l_cmf05 

END FUNCTION

FUNCTION g640_get_ccc(p_flag,p_ima01,p_year,p_month)
   DEFINE l_n         LIKE type_file.num5
   DEFINE p_ima01     LIKE ima_file.ima01
   DEFINE p_month     LIKE cmf_file.cmf02
   DEFINE p_year      LIKE cmf_file.cmf01
   DEFINE p_flag      LIKE type_file.chr1
   DEFINE l_ccc07     LIKE ccc_file.ccc07
   DEFINE l_ccc62     LIKE ccc_file.ccc62
   DEFINE l_ccc61     LIKE ccc_file.ccc61
   DEFINE l_ccc211    LIKE ccc_file.ccc211
   DEFINE l_ccc221    LIKE ccc_file.ccc221
   DEFINE l_ccc23     LIKE ccc_file.ccc23

   CASE p_flag 
      WHEN '1'
        #最近銷售單價:ccc62(銷售成本)/ccc61(銷售數量).
         SELECT COUNT(*) INTO l_n FROM ccc_file 
           WHERE ccc01 = p_ima01 AND ccc02 = p_year 
             AND ccc03 = p_month
             AND ccc07 = '1' AND ccc08 = ' ' 
         IF l_n = 0 OR cl_null(l_n) THEN
            RETURN FALSE, 0
         END IF
         SELECT ccc61,ccc62 INTO l_ccc61,l_ccc62  
           FROM ccc_file
           WHERE ccc01 = p_ima01 AND ccc02 = p_year
             AND ccc03 = p_month
             AND ccc07 = '1' AND ccc08 = ' ' 
         IF l_ccc61 = 0 OR cl_null(l_ccc61) THEN
            RETURN FALSE,0 
         END IF
         RETURN TRUE, l_ccc62/l_ccc61

      WHEN '2'
        #最近採購單價:ccc221(採購入庫金額)/ccc211(採購入庫數量).
         SELECT COUNT(*) INTO l_n FROM ccc_file
           WHERE ccc01 = p_ima01 AND ccc02 = p_year
             AND ccc03 = p_month
             AND ccc07 = '1' AND ccc08 = ' '
         IF l_n = 0 OR cl_null(l_n) THEN
            RETURN FALSE, 0
         END IF
         SELECT ccc221,ccc211 INTO l_ccc221,l_ccc211
           FROM ccc_file
           WHERE ccc01 = p_ima01 AND ccc02 = p_year
             AND ccc03 = p_month 
             AND ccc07 = '1' AND ccc08 = ' ' 
         IF l_ccc211 = 0 OR cl_null(l_ccc211) THEN
            RETURN FALSE,0
         END IF
         RETURN TRUE, l_ccc221/l_ccc211

      WHEN '3'  
        #月加權平均成本
         SELECT COUNT(*) INTO l_n FROM ccc_file
           WHERE ccc01 = p_ima01 AND ccc02 = p_year
             AND ccc03 = p_month AND ccc07 = '1'
             AND ccc07 = '1' AND ccc08 = ' '
         IF l_n = 0 OR cl_null(l_n) THEN
            RETURN FALSE, 0
         END IF
         SELECT ccc23 INTO l_ccc23
           FROM ccc_file
           WHERE ccc01 = p_ima01 AND ccc02 = p_year
             AND ccc03 = p_month AND ccc07 = '1'
             AND ccc08 = ' '
         RETURN TRUE, l_ccc23
   END CASE
 
END FUNCTION

FUNCTION g640_upd_temp(p_sum,p_lrg04,p_ima01,p_plant,p_type,p_lrz02)
   DEFINE l_sql      STRING
   DEFINE p_sum      LIKE type_file.num5 
   DEFINE p_lrg04    LIKE lrg_file.lrg04
   DEFINE p_ima01    LIKE ima_file.ima01
   DEFINE p_plant    LIKE azp_file.azp01 
   DEFINE p_type     LIKE type_file.chr1    #1:積分換物,2.積分換券
   DEFINE p_lrz02    LIKE lrz_file.lrz02

   LET l_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ,
               "    SET tot_point =  tot_point + ",p_sum," ,",
               "        tot_sum =  tot_sum + ",p_lrg04," ",
               "   WHERE ima01 = '",p_ima01,"' ",
               "     AND plant = '",p_plant,"' " 
   IF p_type = '2' THEN
      LET l_sql = l_sql, " AND price =  ",p_lrz02," AND source = '1'  "
   END IF
   PREPARE g640_prepare3 FROM l_sql
   EXECUTE g640_prepare3

  #公允價值 = 兌換價值 * 兌換份數 / 總兌換點數
   LET l_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ,
               "    SET price_1 = price * tot_sum  / tot_point ",
               "   WHERE ima01 = '",p_ima01,"' " ,
               "     AND plant = '",p_plant,"' "
   IF p_type = '2' THEN
      LET l_sql = l_sql, " AND price =  ",p_lrz02," "
   END IF
   PREPARE g640_prepare4 FROM l_sql
   EXECUTE g640_prepare4

  #總兌換價值 =  兌換價值 * 總兌換份數
   LET l_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ,
               "    SET tot_price = price * tot_sum ",
               "   WHERE ima01 = '",p_ima01,"' ",
               "     AND plant = '",p_plant,"' "
   IF p_type = '2' THEN
      LET l_sql = l_sql, " AND price =  ",p_lrz02," "
   END IF
   PREPARE g640_prepare5 FROM l_sql
   EXECUTE g640_prepare5

END FUNCTION


#FUN-CA0158

#FUN-D10011 add START
FUNCTION g640_upd_price()

   IF tm.a = 'N' THEN RETURN END IF
   IF cl_null(tm.year_sta_a) OR cl_null(tm.mon_sta_a) OR
      cl_null(tm.year_end_a) OR cl_null(tm.mon_end_a)  THEN
      RETURN 
   END IF
   LET g_success = 'Y'
   LET tm.mon_sta_a = tm.mon_sta_a USING "&&"
   LET tm.mon_end_a = tm.mon_end_a USING "&&"
   BEGIN WORK

   UPDATE ltx_file SET ltx03 = g_ave_price 
     WHERE (ltx01 BETWEEN tm.year_sta_a AND tm.year_end_a )
       AND (ltx02 BETWEEN tm.mon_sta_a AND tm.mon_end_a ) 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ltx_file",tm.year_sta_a ,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF 

   IF g_success = 'Y' AND tm.a = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK 
   END IF

END FUNCTION 
#FUN-D10011 add END


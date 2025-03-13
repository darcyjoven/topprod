# Prog. Version..: '5.30.06-13.03.18(00003)'     #
# prog. Version..: '5.30.04-12.11.13(00000)'     #
#
# Pattern name...: almg645.4gl
# Descriptions...: 積分異動報表 
# Date & Author..: No.FUN-CB0062 12/11/14 By pauline
# Modify.........: No.FUN-D10002 13/01/03 By pauline 增加列印積分異動明細
# Modify.........: No.FUN-D10104 13/01/22 By pauline 製表日期印製錯誤 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                       # Print condition RECORD
           plant       STRING,
          #FUN-D10002 mark START
          #year        LIKE type_file.chr4,
          #mon         LIKE type_file.chr2,
          #FUN-D10002 mark END
          #FUN-D10002 add START
           date_sta    LIKE type_file.dat,
           date_end    LIKE type_file.dat,
           a           LIKE type_file.chr1,
          #FUN-D10002 add END
           more        LIKE type_file.chr1  # Input more condition(Y/N)
           END RECORD
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   g_wc            STRING
DEFINE   g_store         STRING 
###GENGRE###START
TYPE sr_t RECORD
   plant      LIKE lrj_file.lrjplant,       #所屬營運中心
   azw08      LIKE azw_file.azw08,          #營運中心名稱
   ini_point  LIKE lsm_file.lsm04,          #期初點數
   add_point  LIKE type_file.num20,         #增加點數
   out_point  LIKE type_file.num20,         #兌換點數
   void_point LIKE type_file.num20,         #失效點數  
   last_point LIKE type_file.num20,         #剩餘點數 
  #mon        LIKE type_file.chr2,          #月份   #FUN-D10002 mark 
#FUN-D10002 add START
    mon        LIKE type_file.chr20,        #年/月
    lsm01      LIKE lsm_file.lsm01,         #卡號
    lsm15      LIKE ze_file.ze03,           #來源類型
    lsm02      LIKE ze_file.ze03,           #異動別
    lsm03      LIKE lsm_file.lsm03,         #交易單號
    lsm05      LIKE lsm_file.lsm05,         #異動日期
    lsm04      LIKE lsm_file.lsm04,         #異動積分
    lsmstore   LIKE ze_file.ze03            #營運中心
#FUN-D10002 add END
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
  #FUN-D10002 mark START
  #LET tm.year = ARG_VAL(8)
  #LET tm.mon = ARG_VAL(9)
  #FUN-D10002 mark START
  #FUN-D10002 add START
   LET tm.date_sta = ARG_VAL(8)
   LET tm.date_end = ARG_VAL(9)
  #FUN-D10002 add END
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "plant.lrj_file.lrjplant,",       #所屬營運中心
                "azw08.azw_file.azw08,",          #營運中心名稱
                "ini_point.lsm_file.lsm04,",      #期初點數
                "add_point.type_file.num20,",     #增加點數  
                "out_point.type_file.num20,",     #兌換點數  
                "void_point.type_file.num20,",    #失效點數 
                "last_point.type_file.num20,",    #剩餘點數 
               #"mon.type_file.chr2," ,           #月份  #FUN-D10002 mark 
#FUN-D10002 add START
                "mon.type_file.chr20," ,          #年/月  #FUN-D10002 add
                "lsm01.lsm_file.lsm01,",          #卡號
                "lsm15.lsm_file.lsm15,",          #來源類型
                "lsm02.lsm_file.lsm02,",          #異動別
                "lsm03.lsm_file.lsm03,",          #交易單號
                "lsm05.lsm_file.lsm05,",          #異動日期
                "lsm04.lsm_file.lsm04,",          #本次異動積分
                "lsmstore.ze_file.ze03  "         #所屬門店
#FUN-D10002 add END
 
   LET l_table = cl_prt_temptable('almg645',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN #判斷是否是背景運行
      CALL g645_tm(5,10)                      #非背景運行，錄入打印報表條件
   ELSE
      CALL g645()                             #按傳入條件背景列印報表
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time


END MAIN

FUNCTION g645_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE l_date1        LIKE type_file.dat
   DEFINE l_date2        LIKE type_file.dat
   DEFINE l_j            LIKE type_file.num5

   OPEN WINDOW g645_w AT p_row,p_col WITH FORM "alm/42f/almg645"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition

  #LET tm.year = YEAR(g_today)   #FUN-D10002 mark
  #LET tm.mon  = MONTH(g_today)  #FUN-D10002 mark 
   LET tm.date_sta = g_today     #FUN-D10002 add
   LET tm.date_end = g_today     #FUN-D10002 add
   LET tm.more = 'N'
   LET tm.a = '1'                #FUN-D10002 add
 
   WHILE TRUE
      DIALOG ATTRIBUTE(UNBUFFERED)

         CONSTRUCT BY NAME tm.plant on azw01
            BEFORE CONSTRUCT
              #CALL cl_qbe_init()   

           #FUN-D10002 add START
            BEFORE FIELD azw01 
               DISPLAY g_store TO azw01 
            AFTER FIELD azw01 
               LET g_store = GET_FLDBUF(azw01)

           #FUN-D10002 add END 
 
         END CONSTRUCT

        #FUN-D10002 mark START
        #INPUT BY NAME tm.year, tm.mon, tm.more  ATTRIBUTE(WITHOUT DEFAULTS)

        #   AFTER FIELD year
        #      IF NOT cl_null(tm.year) THEN
        #         IF length(tm.year) <> 4 THEN
        #            CALL cl_err('','alm-h79',0)
        #            NEXT FIELD year
        #         END IF
        #         FOR l_j = 1 TO 4
        #             IF tm.year[l_j,l_j] NOT MATCHES '[0-9]' THEN
        #                CALL cl_err('','alm-h80',0)
        #                NEXT FIELD year
        #             END IF
        #         END FOR
        #      END IF

        #   AFTER FIELD mon
        #      IF NOT cl_null(tm.mon) THEN
        #         IF length(tm.mon) <> 2 THEN
        #            CALL cl_err('','alm-h81',0)
        #            NEXT FIELD mon
        #         END IF
        #         IF tm.mon[1,1] NOT MATCHES '[01]' THEN
        #            CALL cl_err('','alm-h82',0)
        #            NEXT FIELD mon
        #         END IF
        #         IF tm.mon[2,2] NOT MATCHES '[0-9]' THEN
        #            CALL cl_err('','alm-h82',0)
        #            NEXT FIELD mon
        #         END IF
        #      END IF
        #END INPUT
        #FUN-D10002 mark END

        #FUN-D10002 add START
         INPUT BY NAME tm.date_sta,tm.date_end,tm.a, tm.more  ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD date_sta
               IF NOT cl_null(tm.date_sta) AND NOT cl_null(tm.date_end) THEN 
                  IF tm.date_sta > tm.date_end THEN
                     CALL cl_err('','alm1391',0) 
                     NEXT FIELD date_sta
                  END IF
               END IF
 
            AFTER FIELD date_end
               IF NOT cl_null(tm.date_sta) AND NOT cl_null(tm.date_end) THEN
                  IF tm.date_sta > tm.date_end THEN
                     CALL cl_err('','alm1391',0)
                     NEXT FIELD date_end
                  END IF
               END IF
  
            AFTER FIELD a  
              IF NOT cl_null(tm.a) THEN
                 IF tm.a NOT MATCHES '[12]' THEN
                    NEXT FIELD a
                 END IF 
              END IF
         END INPUT
        #FUN-D10002 add END

         ON ACTION controlp
            CASE
               WHEN INFIELD(azw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azw"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET g_store = g_qryparam.multiret  #FUN-D10002 add 
                  DISPLAY g_qryparam.multiret TO azw01
                  NEXT FIELD azw01
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
         LET INT_FLAG = 0 CLOSE WINDOW g645_w
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
          WHERE zz01='almg645'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('almg645','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.plant CLIPPED,"'" ,
                      #" '",tm.year CLIPPED,"'" ,     #FUN-D10002 mark 
                      #" '",tm.mon CLIPPED,"'" ,      #FUN-D10002 mark 
                       " '",tm.date_sta CLIPPED,"'" ,      #FUN-D10002 add
                       " '",tm.date_end CLIPPED,"'" ,      #FUN-D10002 add                    
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('almg645',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g645_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g645()
      ERROR ""
   END WHILE 

   CLOSE WINDOW g645_w
END FUNCTION

FUNCTION g645()
   DEFINE l_sql                 STRING
   DEFINE l_plant               LIKE azw_file.azw01
   DEFINE l_azp02               LIKE azw_file.azw08
   DEFINE l_yy                  LIKE type_file.chr4 
   DEFINE l_mm                  LIKE type_file.chr2
   DEFINE l_where               STRING   #FUN-D10002 add
   DEFINE sr                    RECORD
            plant      LIKE lrj_file.lrjplant,       #所屬營運中心
            azw08      LIKE azw_file.azw08,          #營運中心名稱
            ini_point  LIKE lsm_file.lsm04,          #期初點數
            add_point  LIKE type_file.num20,         #增加點數
            out_point  LIKE type_file.num20,         #兌換點數
            void_point LIKE type_file.num20,         #失效點數
            last_point LIKE type_file.num20,         #剩餘點數
           #mon        LIKE type_file.chr2,          #月份  #FUN-D10002 mark
  #FUN-D10002 add START
            mon        LIKE type_file.chr20,         #年/月
            lsm01      LIKE lsm_file.lsm01,          #卡號
            lsm15      LIKE lsm_file.lsm15,          #來源類型
            lsm02      LIKE lsm_file.lsm02,          #異動別
            lsm03      LIKE lsm_file.lsm03,          #交易單號
            lsm05      LIKE lsm_file.lsm05,          #異動日期
            lsm04      LIKE lsm_file.lsm04,          #異動積分
            lsmstore   LIKE ze_file.ze03             #營運中心
                                END RECORD
  DEFINE    l_yy2      LIKE type_file.chr4           #結束年份  
  DEFINE    l_mm2      LIKE type_file.chr2           #結束月份
  DEFINE    l_year     LIKE type_file.chr4           #年
  DEFINE    l_mon      LIKE type_file.chr2           #月
  DEFINE    l_n        LIKE type_file.num5 
  DEFINE    l_n2       LIKE type_file.num5
  DEFINE    l_n3       LIKE type_file.num5
  DEFINE    l_date1    LIKE type_file.dat 
  DEFINE    l_date2    LIKE type_file.dat
  #FUN-D10002 add END
                               #END RECORD       #FUN-D10002 mark
  #IF cl_null(tm.year) OR cl_null(tm.mon) THEN   #FUN-D10002 mark 
   IF cl_null(tm.date_sta) OR cl_null(tm.date_end) THEN   #FUN-D10002 add 
      RETURN
   END IF 
   LET g_pdate = g_today    #FUN-D10104 add

   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,   ?,?,?,   ",
               "        ?,?,?,?,?,   ?,? ) "       #FUN-D10002 add
   PREPARE insert_prep FROM g_sql
DISPLAY g_cr_db_str CLIPPED,l_table CLIPPED
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

  #FUN-D10002 mark START
  #LET sr.mon = tm.mon
  #IF tm.mon = '12' THEN
  #   LET l_yy = tm.year - 1
  #   LET l_mm = '01'
  #ELSE
  #   LET l_yy = tm.year 
  #   LET l_mm = tm.mon - 1 
  #   LET l_mm = l_mm USING "&&"
  #END IF
  #FUN-D10002 mark END
  #FUN-D10002 add START
   LET g_wc = tm.plant, " AND lsm05 BETWEEN CAST('",tm.date_sta,"' AS DATE) AND CAST('",tm.date_end,"' AS DATE) " 
   CALL cl_wcchp(g_wc,'azw01,lsm05') RETURNING g_wc
   LET l_yy = YEAR(tm.date_sta)
   LET l_mm = MONTH(tm.date_sta) 
   LET l_yy2 = YEAR(tm.date_end)
   LET l_mm2 = MONTH(tm.date_end)  
   LET l_mm = l_mm USING "&&"
   LET l_mm2 = l_mm2 USING "&&"
 
   LET l_n  = l_yy2 - l_yy
   LET l_n2 = l_mm2 - l_mm
   LET l_n3 = l_n2 + (12 * l_n)
    
   FOR l_n = 0 TO l_n3 
      LET sr.mon = ''
      LET l_year = l_yy
      LET l_mon = l_mm + l_n
      LET l_mon = l_mon USING "&&"
      IF l_mon > 12 THEN
         LET l_mon = l_mon - 12
         LET l_year = l_year + 1 
      END IF
      LET l_date1 = MDY(l_mon,'1',l_year)
      IF l_mon = '12' THEN
         LET l_date2 = MDY('12','31',l_year) 
      ELSE
         LET l_date2 = MDY(l_mon + 1,'1',l_year)-1
      END IF
      IF l_mon = l_mm AND l_year = l_yy THEN
         LET l_date1 = tm.date_sta
      END IF
      IF l_mon = l_mm2 AND l_year = l_yy2 THEN
         LET l_date2 = tm.date_end
      END IF 
      LET l_mon = l_mon USING "&&"
      LET sr.mon = " ",l_date1,"~",l_date2 
      LET l_where = " lsm05 BETWEEN CAST('",l_date1,"' AS DATE) AND CAST('",l_date2,"' AS DATE) " 
  #FUN-D10002 add END

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
        #FUN-D10002 add START
         IF tm.a = '1' THEN
            LET sr.lsm01 = NULL
            LET sr.lsm15  = NULL
            LET sr.lsm02 = NULL
            LET sr.lsm03 = NULL
            LET sr.lsm04 = NULL
            LET sr.lsmstore = NULL
           #FUN-D10002 add END
           #計算期初點數
            LET sr.ini_point = 0   
           #FUN-D10002 mark START
           #LET l_sql = " SELECT SUM(ltw05) FROM ltw_file " 
           #            "     WHERE ltw01 = '",l_yy,"' AND ltw02 = '",l_mm,"'",  
           #            "       AND ltw04 = '",sr.plant,"' "                     
           #PREPARE g645_prepare FROM l_sql 
           #EXECUTE g645_prepare INTO sr.ini_point
           #FUN-D10002 mark END
            CALL g645_get_ini_point(l_date1,l_plant) RETURNING sr.ini_point #FUN-D10002 add 
            IF cl_null(sr.ini_point) THEN LET sr.ini_point = 0 END IF 
           #計算增加點數
            LET l_sql = " SELECT SUM(lsm04) FROM lsm_file ",
                       #"   WHERE YEAR(lsm05) = '",tm.year,"' AND MONTH(lsm05) = '",tm.mon,"'",  #FUN-D10002 mark 
                        "   WHERE ",l_where,                #FUN-D10002 add
                        "     AND ( lsm02 IN ('1','2','7','8')",
                        "           OR (lsm02 = '4' AND lsm04 > 0 ))",
                        "     AND lsmstore = '",l_plant,"'  " 
            PREPARE g645_prepare1 FROM l_sql
            EXECUTE g645_prepare1 INTO sr.add_point
            IF cl_null(sr.add_point) THEN LET sr.add_point = 0 END IF
         
           #計算兌換點數 
            LET l_sql = " SELECT SUM(lsm04) FROM lsm_file ",
                       #"   WHERE YEAR(lsm05) = '",tm.year,"' AND MONTH(lsm05) = '",tm.mon,"'",   #FUN-D10002 mark
                        "   WHERE ",l_where,                #FUN-D10002 add
                        "     AND lsm02 IN ('5','6','9','A')",   #異動別為積分換物/換券
                        "     AND lsmstore = '",l_plant,"'  " 
            PREPARE g645_prepare2 FROM l_sql
            EXECUTE g645_prepare2 INTO sr.out_point
            IF cl_null(sr.out_point) THEN LET sr.out_point = 0 END IF
            LET sr.out_point = sr.out_point * (-1)
                    
           #計算失效點數
            LET l_sql = " SELECT SUM(lsm04) FROM lsm_file ",
                       #"   WHERE YEAR(lsm05) = '",tm.year,"' AND MONTH(lsm05) = '",tm.mon,"'",   #FUN-D10002 mark
                        "   WHERE ",l_where,                #FUN-D10002 add
                        "     AND ( lsm02 IN ('3')",   #異動別為積分清零
                        "          OR (lsm02 = '4' AND lsm04 < 0 ))",
                        "     AND lsmstore = '",l_plant,"'  "
            PREPARE g645_prepare3 FROM l_sql
            EXECUTE g645_prepare3 INTO sr.void_point
            IF cl_null(sr.void_point) THEN LET sr.void_point = 0 END IF
            LET sr.void_point = sr.void_point * (-1)
         
            LET sr.last_point = sr.ini_point + sr.add_point - sr.out_point - sr.void_point 
            #當所有點數都為0時不印出資料
            IF sr.ini_point = 0 AND sr.add_point = 0 AND sr.out_point = 0 
               AND sr.void_point = 0 AND sr.last_point = 0  THEN
               CONTINUE FOREACH
            END IF
            EXECUTE  insert_prep  USING sr.*  
        #FUN-D10002 add START
         END IF
         IF tm.a = '2' THEN
            LET l_sql = " SELECT '','','','','','','','', ",
                        "        lsm01,lsm15,lsm02,lsm03,lsm05,lsm04,lsmstore FROM lsm_file ",
                        "   WHERE ",l_where, 
                        "     AND lsmstore = '",l_plant,"'  "
            PREPARE g645_prepare4 FROM l_sql
            DECLARE g645_cs4 CURSOR FOR g645_prepare4 
            FOREACH g645_cs4 INTO sr.* 
               LET sr.mon = tm.date_sta,"~",tm.date_end 
               LET sr.azw08 = l_azp02
               EXECUTE  insert_prep USING sr.* 
            END FOREACH
         END IF
        #FUN-D10002 add END
      END FOREACH
   END FOR   #FUN-D10002 add
  #FUN-D10002 add START
  ##計算匯總
   IF tm.a = '1' THEN
      LET l_sql = " SELECT plant,azw08,'',SUM(add_point),",
                  "        SUM(out_point),SUM(void_point),SUM(last_point),'', ",
                  "        '','','','','','','' ",
                  " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  ,
                  " WHERE RTRIM(plant) IS NOT NULL ",
                  " GROUP BY plant,azw08 " 
      PREPARE g645_prepare5 FROM l_sql
      DECLARE g645_cs5 CURSOR FOR g645_prepare5 
      FOREACH g645_cs5  INTO sr.*
         CALL g645_get_ini_point(tm.date_sta,sr.plant) RETURNING sr.ini_point  #FUN-D10002 add
         LET sr.mon = tm.date_sta,"~",tm.date_end 
         EXECUTE insert_prep USING sr.*
      END FOREACH
   END IF 
  #FUN-D10002 add END
   CALL g645_grdata()

END FUNCTION

FUNCTION g645_grdata()
   DEFINE sr1      sr_t
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_msg    STRING

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN RETURN END IF

   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("almg645")
       IF handler IS NOT NULL THEN
           START REPORT almg645_rep TO XML HANDLER handler
             #FUN-D10002 add START
              IF tm.a = '1' THEN
                 LET l_sql = "SELECT DISTINCT plant,azw08,ini_point,add_point,out_point,void_point,last_point,mon, " ,
                             "      '','','','','','','' FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  ,
                             "  WHERE RTRIM(ini_point) IS NOT NULL ",
                             " ORDER BY mon,plant " 
              ELSE
                 LET l_sql = "SELECT DISTINCT '',azw08,'','','','','',mon,",
                             "       lsm01,lsm15,lsm02,lsm03,lsm05,lsm04,lsmstore FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                             "  WHERE RTRIM(lsm01) IS NOT NULL ",
                             " ORDER BY lsm05 "
              END IF
             #FUN-D10002 add END
              DECLARE almg645_datacur1 CURSOR FROM l_sql
              FOREACH almg645_datacur1 INTO sr1.*
                  OUTPUT TO REPORT almg645_rep(sr1.*)
              END FOREACH
              FINISH REPORT almg645_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()

END FUNCTION

REPORT almg645_rep(sr1)
   DEFINE sr1 sr_t
   DEFINE l_lineno LIKE type_file.num5
   DEFINE l_sum1   LIKE type_file.num20    #期初點數總計
   DEFINE l_sum2   LIKE type_file.num20    #新增點數總計
   DEFINE l_sum3   LIKE type_file.num20    #兌換點數總計
   DEFINE l_sum4   LIKE type_file.num20    #失效點數總計
   DEFINE l_sum5   LIKE type_file.num20    #剩餘點數總計
   DEFINE l_desc   LIKE ze_file.ze03       
   DEFINE l_lsmstore LIKE azw_file.azw08   #FUN-D10002 add

   ORDER EXTERNAL BY sr1.mon,sr1.plant
   FORMAT
       FIRST PAGE HEADER
           LET l_desc = cl_getmsg('alm-h87',g_lang)
           PRINTX g_grPageHeader.*
           PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
           PRINTX tm.*
           PRINTX g_wc
           PRINTX l_desc

       ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno
           LET sr1.lsm15 = cl_gr_getmsg('alm1001',g_lang,sr1.lsm15)   #FUN-D10002 add 
           LET sr1.lsm02 = cl_gr_getmsg('alm1390',g_lang,sr1.lsm02)   #FUN-D10002 add 
           LET l_lsmstore = sr1.azw08   #FUN-D10002 add 
           PRINTX sr1.*
           PRINTX l_lsmstore            #FUN-D10002 add

       AFTER GROUP OF sr1.mon
           LET l_sum1 = GROUP SUM(sr1.ini_point)
           LET l_sum2 = GROUP SUM(sr1.add_point) 
           LET l_sum3 = GROUP SUM(sr1.out_point)
           LET l_sum4 = GROUP SUM(sr1.void_point)
           LET l_sum5 = GROUP SUM(sr1.last_point)
           PRINTX l_sum1
           PRINTX l_sum2
           PRINTX l_sum3
           PRINTX l_sum4
           PRINTX l_sum5

       ON LAST ROW

END REPORT

#FUN-CB0062
#FUN-D10002 add START
#計算期初點數
FUNCTION g645_get_ini_point(p_date,p_plant)
DEFINE l_ini_point     LIKE ltw_file.ltw05
DEFINE p_date          LIKE type_file.dat 
DEFINE p_plant         LIKE azw_file.azw01
DEFINE l_yy            LIKE type_file.chr4
DEFINE l_mm            LIKE type_file.chr2
DEFINE l_sql           STRING

    LET l_yy = YEAR(p_date)
    LET l_mm = MONTH(p_date)
    LET l_ini_point = 0 
    LET l_mm = l_mm USING "&&"

    LET l_sql = " SELECT SUM(ltw05) FROM ltw_file "
    IF l_mm = '01' THEN
       LET l_sql = l_sql ," WHERE ltw01 = ",l_yy-1," AND ltw02 =  12  "
    ELSE
       LET l_sql = l_sql ," WHERE ltw01 = ",l_yy," AND ltw02 = ",l_mm - 1 ," "
    END IF
    LET l_sql = l_sql ," AND ltw04 = '",p_plant,"' "
    PREPARE g645_prepare FROM l_sql
    EXECUTE g645_prepare INTO l_ini_point
    IF cl_null(l_ini_point) THEN LET l_ini_point = 0 END IF
   RETURN l_ini_point 
END FUNCTION
#FUN-D10002 add END

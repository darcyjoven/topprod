# Prog. Version..: '5.30.06-13.03.18(00002)'     #
# prog. Version..: '5.30.04-12.11.13(00000)'     #
#
# Pattern name...: almg681.4gl
# Descriptions...: 禮券異動報表 
# Date & Author..: 12/11/14 FUN-CB0126 By Sakura
# Modify.........: No.FUN-D10104 13/01/22 By pauline 製表日期印製錯誤 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                       # Print condition RECORD
           plant       STRING,
           year        LIKE type_file.chr4,
           mon         LIKE type_file.chr2,
           more        LIKE type_file.chr1  # Input more condition(Y/N)
           END RECORD
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   l_store         STRING
DEFINE   g_wc            STRING

###GENGRE###START
TYPE sr_t RECORD
   plant      LIKE lrj_file.lrjplant,       #所屬營運中心
   azw08      LIKE azw_file.azw08,          #營運中心名稱
   add_lqe23  LIKE lqe_file.lqe23,          #新增金額
   ret_lqe23  LIKE lqe_file.lqe23,          #退還金額
   all_lqe23  LIKE lqe_file.lqe23,          #新增遞延金額            
   out_lqe23  LIKE lqe_file.lqe23,          #兌換遞延金額
   mat_lqe23  LIKE lqe_file.lqe23           #到期遞延金額   
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
   LET tm.year = ARG_VAL(8)
   LET tm.mon = ARG_VAL(9)
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
                "add_lqe23.lqe_file.lqe23,",      #新增金額
                "ret_lqe23.lqe_file.lqe23,",      #退還金額
                "all_lqe23.lqe_file.lqe23,",      #新增遞延金額            
                "out_lqe23.lqe_file.lqe23,",      #兌換遞延金額
                "mat_lqe23.lqe_file.lqe23"        #到期遞延金額                  
 
   LET l_table = cl_prt_temptable('almg681',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN #判斷是否是背景運行
      CALL g681_tm(5,10)                      #非背景運行，錄入打印報表條件
   ELSE
      CALL g681()                             #按傳入條件背景列印報表
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time


END MAIN

FUNCTION g681_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE l_date1        LIKE type_file.dat
   DEFINE l_date2        LIKE type_file.dat
   DEFINE l_j            LIKE type_file.num5

   OPEN WINDOW g681_w AT p_row,p_col WITH FORM "alm/42f/almg681"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition

   LET tm.year = YEAR(g_today)
   LET tm.mon  = MONTH(g_today)
   LET tm.more = 'N'
 
   WHILE TRUE
      DIALOG ATTRIBUTE(UNBUFFERED)

         CONSTRUCT BY NAME tm.plant on azw01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

         END CONSTRUCT

         INPUT BY NAME tm.year, tm.mon, tm.more  ATTRIBUTE(WITHOUT DEFAULTS)

            AFTER FIELD year
               IF NOT cl_null(tm.year) THEN
                  IF length(tm.year) <> 4 THEN
                     CALL cl_err('','alm-h79',0)
                     NEXT FIELD year
                  END IF
                  FOR l_j = 1 TO 4
                      IF tm.year[l_j,l_j] NOT MATCHES '[0-9]' THEN
                         CALL cl_err('','alm-h80',0)
                         NEXT FIELD year
                      END IF
                  END FOR
               END IF

            AFTER FIELD mon
               IF NOT cl_null(tm.mon) THEN
                  IF length(tm.mon) <> 2 THEN
                     CALL cl_err('','alm-h81',0)
                     NEXT FIELD mon
                  END IF
                  IF tm.mon[1,1] NOT MATCHES '[01]' THEN
                     CALL cl_err('','alm-h82',0)
                     NEXT FIELD mon
                  END IF
                  IF tm.mon[2,2] NOT MATCHES '[0-9]' THEN
                     CALL cl_err('','alm-h82',0)
                     NEXT FIELD mon
                  END IF
               END IF
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
         LET INT_FLAG = 0 CLOSE WINDOW g681_w
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
          WHERE zz01='almg681'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('almg681','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.plant CLIPPED,"'" ,
                       " '",tm.year CLIPPED,"'" ,
                       " '",tm.mon CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('almg681',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g681_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g681()
      ERROR ""
   END WHILE 

   CLOSE WINDOW g681_w
END FUNCTION

FUNCTION g681()
   DEFINE l_sql                 STRING
   DEFINE l_plant               LIKE azw_file.azw01
   DEFINE l_azp02               LIKE azw_file.azw08
   DEFINE l_yy                  LIKE type_file.chr4 
   DEFINE l_mm                  LIKE type_file.chr2
   DEFINE sr                    RECORD
            plant      LIKE lrj_file.lrjplant,       #所屬營運中心
            azw08      LIKE azw_file.azw08,          #營運中心名稱
            add_lqe23  LIKE lqe_file.lqe23,          #新增金額
            ret_lqe23  LIKE lqe_file.lqe23,          #退還金額
            all_lqe23  LIKE lqe_file.lqe23,          #新增遞延金額            
            out_lqe23  LIKE lqe_file.lqe23,          #兌換遞延金額
            mat_lqe23  LIKE lqe_file.lqe23           #到期遞延金額
                                END RECORD
    
   IF cl_null(tm.year) OR cl_null(tm.mon) THEN
      RETURN
   END IF 

  #FUN-D10104 add START
   LET g_pdate = g_today    #FUN-D10104 add

   LET g_wc = tm.plant, " AND lqe07 BETWEEN ",MDY(tm.mon,'1',tm.year) 
   IF tm.mon = '12' THEN
      LET g_wc = g_wc, " AND ",MDY(12,'31',tm.year)
   ELSE 
      LET g_wc = g_wc, " AND ",MDY(tm.mon+1 ,'1',tm.year)-1   
   END IF  
  #FUN-D10104 add END
 
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,   ?,? ) " 
   PREPARE insert_prep FROM g_sql
DISPLAY g_cr_db_str CLIPPED,l_table CLIPPED
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

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
     #計算新增金額
      LET sr.add_lqe23 = 0
      LET l_sql = " SELECT SUM(lqe23) FROM lqe_file ",
                  "   WHERE (lqe17 = '1' OR lqe17 = '4') ",
                  "     AND (lqe22 = '1' OR lqe22 = '3') ",
                  "     AND YEAR(lqe07) = '",tm.year,"' AND MONTH(lqe07) = '",tm.mon,"'",
                  "     AND lqe06 = '",l_plant,"'  " 
      PREPARE g681_prepare FROM l_sql
      EXECUTE g681_prepare INTO sr.add_lqe23
      IF cl_null(sr.add_lqe23) THEN LET sr.add_lqe23 = 0 END IF 
     #計算退還金額
      LET sr.ret_lqe23 = 0
      LET l_sql = " SELECT SUM(lqe23) FROM lqe_file ",
                  "   WHERE lqe17 = '2' ", 
                  "     AND (lqe22 = '1' OR lqe22 = '3') ",                  
                  "     AND YEAR(lqe10) = '",tm.year,"' AND MONTH(lqe10) = '",tm.mon,"'",
                  "     AND (lqe10 > lqe07 ) ",
                  "     AND lqe09 = '",l_plant,"'  " 
      PREPARE g681_prepare1 FROM l_sql
      EXECUTE g681_prepare1 INTO sr.ret_lqe23
      IF cl_null(sr.ret_lqe23) THEN LET sr.ret_lqe23 = 0 END IF 
     #新增遞延金額
      LET sr.all_lqe23 = sr.add_lqe23 - sr.ret_lqe23  
     #兌換遞延金額
      LET sr.out_lqe23 = 0
      LET l_sql = " SELECT SUM(lqe23) FROM lqe_file ",
                  "   WHERE lqe17 = '4' ", 
                  "     AND (lqe22 = '1' OR lqe22 = '3') ",                  
                  "     AND YEAR(lqe19) = '",tm.year,"' AND MONTH(lqe19) = '",tm.mon,"'",
                  "     AND lqe18 = '",l_plant,"'  " 
      PREPARE g681_prepare2 FROM l_sql
      EXECUTE g681_prepare2 INTO sr.out_lqe23
      IF cl_null(sr.out_lqe23) THEN LET sr.out_lqe23 = 0 END IF       
     #到期遞延金額
      LET sr.mat_lqe23 = 0
      LET l_sql = " SELECT SUM(lqe23) FROM lqe_file ",
                  "   WHERE lqe17 = '1' ", 
                  "     AND (lqe22 = '1' OR lqe22 = '3') ",                  
                  "     AND YEAR(lqe21) = '",tm.year,"' AND MONTH(lqe21) = '",tm.mon,"'",
                  "     AND lqe06 = '",l_plant,"'  " 
      PREPARE g681_prepare3 FROM l_sql
      EXECUTE g681_prepare3 INTO sr.mat_lqe23
      IF cl_null(sr.mat_lqe23) THEN LET sr.mat_lqe23 = 0 END IF      
     #當所有點數都為0時不印出資料
      IF sr.add_lqe23 = 0 AND sr.ret_lqe23 = 0 AND sr.all_lqe23 = 0 
         AND sr.out_lqe23 = 0 AND sr.mat_lqe23 = 0  THEN
         CONTINUE FOREACH
      END IF
    
      EXECUTE  insert_prep  USING sr.*  
   END FOREACH
  #FUN-D10104 add START
   CALL cl_wcchp(g_wc,'azw01,lqe07') RETURNING g_wc
   IF g_wc.getLength() > 1000 THEN
       LET g_wc = g_wc.subString(1,600)
       LET g_wc = g_wc,"..."
   END IF
  #FUN-D10104 add END

   CALL g681_grdata()

END FUNCTION

FUNCTION g681_grdata()
   DEFINE sr1      sr_t
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_msg    STRING

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN RETURN END IF

   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("almg681")
       IF handler IS NOT NULL THEN
           START REPORT almg681_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       "  ORDER BY plant"

           DECLARE almg681_datacur1 CURSOR FROM l_sql
           FOREACH almg681_datacur1 INTO sr1.*
               OUTPUT TO REPORT almg681_rep(sr1.*)
           END FOREACH
           FINISH REPORT almg681_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()

END FUNCTION

REPORT almg681_rep(sr1)
   DEFINE sr1 sr_t
   DEFINE l_lineno LIKE type_file.num5   
   DEFINE l_date   STRING
   FORMAT
       FIRST PAGE HEADER
           LET l_date = tm.year,"/",tm.mon
          #LET g_wc = tm.*   #FUN-D10104 mark 
           PRINTX g_grPageHeader.*
           PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
           PRINTX tm.*
           PRINTX g_wc
           PRINTX l_date

       ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno
           PRINTX sr1.*

       ON LAST ROW

END REPORT
#FUN-CB0126

# Prog. Version..: '5.30.06-13.03.18(00002)'     #
# prog. Version..: '5.30.04-12.11.13(00000)'     #
#
# Pattern name...: almg644.4gl
# Descriptions...: 積分月結報表 
# Date & Author..: No.FUN-CB0092 12/11/23 By pauline
# Modify.........: No.FUN-D10104 13/01/22 By pauline 製表日期印製錯誤 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                       # Print condition RECORD
          #wc          STRING,
           ltv01       LIKE ltv_file.ltv01,
           ltv02       LIKE ltv_file.ltv02,
           value       LIKE type_file.num20_6,
           more        LIKE type_file.chr1  # Input more condition(Y/N)
           END RECORD
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   g_wc            STRING

###GENGRE###START
TYPE sr_t RECORD
   ltv07                LIKE ltv_file.ltv07,          #分配營運中心
   azw08                LIKE azw_file.azw08,          #分配營運中心名稱
   ltv06                LIKE ltv_file.ltv06,          #異動營運中心
   azw08_1              LIKE azw_file.azw08,          #異動營運中心名稱
   add_point            LIKE type_file.num20,         #增加點數
   add_price            LIKE type_file.num20_6,       #增加金額
   out_point            LIKE type_file.num20,         #兌換點數
   out_price            LIKE type_file.num20_6,       #兌換金額
   void_point           LIKE type_file.num20,         #失效點數
   void_price           LIKE type_file.num20_6,       #失效金額
   last_point           LIKE type_file.num20,         #當期異動總點數
   last_price           LIKE type_file.num20_6        #當期異動總金額

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
   LET tm.ltv01 = ARG_VAL(7)
   LET tm.ltv02 = ARG_VAL(8)
  #LET tm.wc = ARG_VAL(7)
   LET tm.value = ARG_VAL(9)
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

   LET g_sql =  "ltv07.ltv_file.ltv07,",             #分配營運中心
                "azw08.azw_file.azw08,",             #分配營運中心名稱
                "ltv06.ltv_file.ltv07,",             #異動營運中心
                "azw08_1.azw_file.azw08,",           #異動營運中心名稱
                "add_point.type_file.num20,",        #增加點數
                "add_value.type_file.num20_6,",      #金額
                "out_point.type_file.num20,",        #兌換點數
                "out_value.type_file.num20_6,",      #期初金額
                "void_point.type_file.num20,",       #失效點數
                "void_value.type_file.num20_6,",     #失效金額
                "last_point.type_file.num20, ",      #當期異動總點數
                "last_value.type_file.num20_6 "      #當期異動總金額

   LET l_table = cl_prt_temptable('almg644',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN #判斷是否是背景運行
      CALL g644_tm(5,10)                      #非背景運行，錄入打印報表條件
   ELSE
      CALL g644()                             #按傳入條件背景列印報表
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time


END MAIN


FUNCTION g644_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000


   OPEN WINDOW g644_w AT p_row,p_col WITH FORM "alm/42f/almg644"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition

   LET tm.ltv01 = YEAR(g_today)
   LET tm.ltv02 = MONTH(g_today)
   LET tm.value = 1
   LET tm.more = 'N'

   WHILE TRUE
      DIALOG ATTRIBUTE(UNBUFFERED)

        #CONSTRUCT BY NAME tm.wc ON ltv01,ltv02 
        #   BEFORE CONSTRUCT
        #      DISPLAY l_y TO ltv01
        #      DISPLAY l_m TO ltv02
        #      CALL cl_qbe_init()

        #END CONSTRUCT

         INPUT BY NAME tm.ltv01,tm.ltv02,tm.value,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)

            AFTER FIELD ltv01
               IF NOT cl_null(tm.ltv01) THEN 
                  IF tm.ltv01 < 0 OR tm.ltv01 = 0 THEN 
                     CALL cl_err('','alm-h80',0)
                     NEXT FIELD ltv01
                  END IF
               END IF

            AFTER FIELD ltv02
               IF NOT cl_null(tm.ltv02) THEN
                  IF tm.ltv02 > 12 OR tm.ltv02 < 0 OR tm.ltv02 = 0 THEN
                     CALL cl_err('','alm-h82',0)
                     NEXT FIELD ltv02
                  END IF
               END IF
           
            AFTER FIELD value
               IF NOT cl_null(tm.value) THEN
                  IF tm.value < 0 THEN
                      CALL cl_err('','',0)
                      NEXT FIELD value
                  END IF 
               END IF
         END INPUT
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
         LET INT_FLAG = 0 CLOSE WINDOW g644_w
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
          WHERE zz01='almg644'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('almg644','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                      #" '",tm.wc CLIPPED,"'" ,
                       " '",tm.ltv01 CLIPPED,"'" ,
                       " '",tm.ltv02 CLIPPED,"'" ,
                       " '",tm.value CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('almg644',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g644_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g644()
      ERROR ""
   END WHILE

   CLOSE WINDOW g644_w
END FUNCTION

FUNCTION g644()
DEFINE l_sql                    STRING
DEFINE l_plant                  LIKE azw_file.azw01
DEFINE l_azp02                  LIKE azw_file.azw08
DEFINE l_n                      LIKE type_file.num5
DEFINE l_wc                     STRING                        #取前期點數的where條件
DEFINE l_y                      LIKE ltv_file.ltv01
DEFINE l_m                      LIKE ltv_file.ltv02 
DEFINE l_ltx03                  LIKE ltx_file.ltx03           #前期公允價值 
DEFINE sr                       RECORD
           ltv07                LIKE ltv_file.ltv07,          #分配營運中心
           azw08                LIKE azw_file.azw08,          #分配營運中心名稱
           ltv06                LIKE ltv_file.ltv06,          #異動營運中心
           azw08_1              LIKE azw_file.azw08,          #異動營運中心名稱
           add_point            LIKE type_file.num20,         #增加點數
           add_price            LIKE type_file.num20_6,       #增加金額
           out_point            LIKE type_file.num20,         #兌換點數
           out_price            LIKE type_file.num20_6,       #兌換金額
           void_point           LIKE type_file.num20,         #失效點數
           void_price           LIKE type_file.num20_6,       #失效金額
           last_point           LIKE type_file.num20,         #當期異動總點數
           last_price           LIKE type_file.num20_6        #當期異動總金額
                                END RECORD
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?                   ) "
   PREPARE insert_prep FROM g_sql
DISPLAY g_cr_db_str CLIPPED,l_table CLIPPED
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF 
  #LET g_wc = tm.wc
   LET g_pdate = g_today    #FUN-D10104 add
   LET g_wc = " ltv01 = ",tm.ltv01,"  AND ltv02 = ",tm.ltv02," " 
   IF tm.ltv02 = 1 THEN
      LET l_wc = " ltv01 = ",tm.ltv01 - 1,"  AND ltv02 = 12 "  
      SELECT ltx03 INTO l_ltx03 FROM ltx_file 
         WHERE ltx01 = tm.ltv01 - 1 
           AND ltx02 = '01'
   ELSE
      LET l_wc = " ltv01 = ",tm.ltv01,"  AND ltv02 = ",tm.ltv02 - 1," " 
      SELECT ltx03 INTO l_ltx03 FROM ltx_file
         WHERE ltx01 = tm.ltv01 AND ltx02 = tm.ltv02 - 1
   END IF 
   IF cl_null(l_ltx03) THEN
      LET g_success = 'N' 
      CALL cl_err('','alm-h90',1)
      RETURN
   END IF
   IF cl_null(g_wc) THEN LET g_wc = " l=1" END IF
   LET l_sql = " SELECT DISTINCT azw01,azw08 FROM azw_file ",
               "    WHERE azw01 IN( SELECT ltv07 FROM ltv_file ",
               "                       WHERE ",g_wc CLIPPED," )",
               " ORDER BY azw01" 
   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
   FOREACH sel_azp01_cs INTO sr.ltv07,sr.azw08 
      LET l_sql = " SELECT DISTINCT ltv06 FROM ltv_file ",
                  "   WHERE ltv07 = '",sr.ltv07,"' ",
                  "     AND ",g_wc CLIPPED  
      PREPARE sel_ltv06_pre FROM l_sql
      DECLARE sel_ltv06_cs CURSOR FOR sel_ltv06_pre
      FOREACH sel_ltv06_cs INTO sr.ltv06
         SELECT azw08 INTO sr.azw08_1 FROM azw_file 
           WHERE azw01 = sr.ltv06
        #計算新增積分/金額
         LET l_sql = " SELECT SUM(ltv08) FROM ltv_file ",
                     "   WHERE ltv07 = '",sr.ltv07,"'",
                     "     AND ltv06 = '",sr.ltv06,"'",
                     "     AND ltv04 = '1'    ",    #1.新增,2.兌換,3.失效
                     "     AND ", g_wc CLIPPED           
         PREPARE g644_prepare1 FROM l_sql
         EXECUTE g644_prepare1 INTO sr.add_point
         IF cl_null(sr.add_point) THEN LET sr.add_point = 0 END IF
         LET sr.add_price = sr.add_point * tm.value
        #計算兌換積分/金額
         LET l_sql = " SELECT SUM(ltv08) FROM ltv_file ",
                     "   WHERE ltv07 = '",sr.ltv07,"'",
                     "     AND ltv06 = '",sr.ltv06,"'",
                     "     AND ltv04 = '2'    ",    #1.新增,2.兌換,3.失效
                     "     AND ", g_wc CLIPPED
         PREPARE g644_prepare2 FROM l_sql
         EXECUTE g644_prepare2 INTO sr.out_point
         IF cl_null(sr.out_point) THEN LET sr.out_point = 0 END IF
         LET sr.out_price = sr.out_point * tm.value
        #計算失效積分/金額
         LET l_sql = " SELECT SUM(ltv08) FROM ltv_file ",
                     "   WHERE ltv07 = '",sr.ltv07,"'",
                     "     AND ltv06 = '",sr.ltv06,"'",
                     "     AND ltv04 = '3'    ",    #1.新增,2.兌換,3.失效
                     "     AND ", g_wc CLIPPED
         PREPARE g644_prepare3 FROM l_sql
         EXECUTE g644_prepare3 INTO sr.void_point
         IF cl_null(sr.void_point) THEN LET sr.void_point = 0 END IF
         LET sr.void_price = sr.void_point * tm.value
        #計算當期異動總點數/金額
         LET sr.last_point = sr.add_point + sr.out_point + sr.void_point
         LET sr.last_price = sr.add_price + sr.out_point + sr.void_point
        #若都沒有資料則跳過不顯示
         IF sr.add_point = 0 AND sr.out_point = 0 AND sr.void_point = 0 THEN 
            CONTINUE FOREACH 
         END IF
         EXECUTE  insert_prep  USING sr.* 
      END FOREACH
      #計算期初點數/金額
      PREPARE g644_prepare4 FROM l_sql
      EXECUTE g644_prepare4 INTO sr.void_point
      LET sr.ltv06 = ' '  #期初
      LET sr.azw08_1 = cl_getmsg('alm-h88',g_lang)
      LET sr.add_point = 0 
      LET sr.out_point = 0
      LET sr.void_point = 0  
     #期初上期增加
      LET l_sql = " SELECT SUM(ltv08) FROM ltv_file ",
                  "   WHERE ltv07 = '",sr.ltv07,"' ",
                  "     AND ltv04 = '1'    ",    #1.新增,2.兌換,3.失效
                  "     AND ", l_wc CLIPPED
      PREPARE g644_prepare5 FROM l_sql
      EXECUTE g644_prepare5 INTO sr.add_point
      IF cl_null(sr.add_point) THEN LET sr.add_point = 0 END IF
      LET sr.add_price = sr.add_point * l_ltx03 
     #期初上期兌換
      LET l_sql = " SELECT SUM(ltv08) FROM ltv_file ",
                  "   WHERE ltv07 = '",sr.ltv07,"' ",
                  "     AND ltv04 = '2'    ",    #1.新增,2.兌換,3.失效 
                  "     AND ", l_wc CLIPPED
      PREPARE g644_prepare6 FROM l_sql
      EXECUTE g644_prepare6 INTO sr.out_point

      IF cl_null(sr.out_point) THEN LET sr.out_point = 0 END IF
      LET sr.out_price = sr.out_point * l_ltx03 
     #期初上期失效
      LET l_sql = " SELECT SUM(ltv08) FROM ltv_file ",
                  "   WHERE ltv07 = '",sr.ltv07,"' ",
                  "     AND ltv04 = '3'    ",    #1.新增,2.兌換,3.失效 
                  "     AND ", l_wc CLIPPED
      PREPARE g644_prepare7 FROM l_sql
      EXECUTE g644_prepare7 INTO sr.void_point
      IF cl_null(sr.void_point) THEN LET sr.void_point = 0 END IF
      LET sr.void_price = sr.void_point * l_ltx03 
     #期初上期異動
      LET sr.last_point = sr.add_point + sr.out_point + sr.void_point
      LET sr.last_price = sr.add_price + sr.out_point + sr.void_point
     #若都沒有資料則跳過不顯示 
      LET l_sql = " SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,
                  "   WHERE ltv07 = '",sr.ltv07 CLIPPED,"'"
      PREPARE g644_prepare8 FROM l_sql
      EXECUTE g644_prepare8 INTO l_n      
      IF l_n = 0 AND sr.add_point = 0 AND sr.out_point = 0 AND sr.void_point = 0 THEN
         CONTINUE FOREACH
      END IF 
      EXECUTE  insert_prep  USING sr.*
   END FOREACH 
   CALL cl_wcchp(g_wc,'ltv01,ltv02') RETURNING g_wc
   IF g_wc.getLength() > 1000 THEN
       LET g_wc = g_wc.subString(1,600)
       LET g_wc = g_wc,"..."
   END IF
   CALL g644_grdata()
END FUNCTION

FUNCTION g644_grdata()
   DEFINE sr1      sr_t
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_msg    STRING

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN RETURN END IF

   WHILE TRUE
       CALL cl_gre_init_pageheader()
       LET handler = cl_gre_outnam("almg644")
       IF handler IS NOT NULL THEN
           START REPORT almg644_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY ltv07,ltv06" 

           DECLARE almg644_datacur1 CURSOR FROM l_sql
           FOREACH almg644_datacur1 INTO sr1.*
               OUTPUT TO REPORT almg644_rep(sr1.*)
           END FOREACH
           FINISH REPORT almg644_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()

END FUNCTION

REPORT almg644_rep(sr1)
   DEFINE sr1 sr_t
   DEFINE l_lineno LIKE type_file.num5
   DEFINE l_sum1   LIKE type_file.num20    #新增點數總計
   DEFINE l_sum2   LIKE type_file.num20    #兌換點數總計
   DEFINE l_sum3   LIKE type_file.num20    #失效點數總計
   DEFINE l_sum4   LIKE type_file.num20    #當期異動點數總計
   DEFINE l_sum5   LIKE type_file.num20    #兌換金額總計
   DEFINE l_sum6   LIKE type_file.num20    #失效金額總計
   DEFINE l_sum7   LIKE type_file.num20    #剩餘金額總計
   DEFINE l_sum8   LIKE type_file.num20    #當期異動金額總計
   DEFINE l_desc   LIKE ze_file.ze03
   DEFINE l_desc1  LIKE ze_file.ze03
   DEFINE l_desc2  LIKE ze_file.ze03
   DEFINE l_desc3  LIKE ze_file.ze03
   DEFINE l_desc4  LIKE ze_file.ze03

   ORDER EXTERNAL BY sr1.ltv07,sr1.ltv06 

   FORMAT
       FIRST PAGE HEADER
           LET l_desc = cl_getmsg('alm-h89',g_lang)
           LET l_desc1 = ' ' 
           LET l_desc2 = ' '
           LET l_desc3 = ' '
           LET l_desc4 = ' '
           PRINTX g_grPageHeader.*
           PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
           PRINTX tm.*
           PRINTX g_wc
           PRINTX l_desc
           PRINTX l_desc1
           PRINTX l_desc2
           PRINTX l_desc3
           PRINTX l_desc4

       BEFORE GROUP OF sr1.ltv07

       ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno
           PRINTX sr1.*

       AFTER GROUP OF sr1.ltv07
           LET l_sum1 = GROUP SUM(sr1.add_point)
           LET l_sum2 = GROUP SUM(sr1.out_point)
           LET l_sum3 = GROUP SUM(sr1.void_point)
           LET l_sum4 = GROUP SUM(sr1.last_point)
           LET l_sum5 = GROUP SUM(sr1.add_price)
           LET l_sum6 = GROUP SUM(sr1.out_price)
           LET l_sum7 = GROUP SUM(sr1.void_price)
           LET l_sum8 = GROUP SUM(sr1.last_price)
           PRINTX l_sum1
           PRINTX l_sum2
           PRINTX l_sum3
           PRINTX l_sum4
           PRINTX l_sum5
           PRINTX l_sum6
           PRINTX l_sum7
           PRINTX l_sum8

       ON LAST ROW

END REPORT
#FUN-CB0092 

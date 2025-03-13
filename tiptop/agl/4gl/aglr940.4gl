# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr940.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 12/01/03 By Belle(FUN-BC0123)
# Modify.........: NO.FUN-C30098 12/03/26 by belle 總帳不需做期初開帳數
# Modify.........: NO.CHI-C40004 12/04/05 by Belle 修改負數顯示方式
# Modify.........: No:CHI-C40011 12/04/11 By Belle 起迄(月，季，半年)結束不可小於起始
# Modify.........: No:TQC-C50059 12/05/15 By xuxz 勾選要印明細，只有營業活動才會出現科目，其它的投資和理財活動不會出現科目的問題
# Modify.........: No:TQC-C50139 12/05/16 By xuxz 當 giq04 = '4'不需區分 tm.t 應只需列印一筆
# Modify.........: No:MOD-C60050 12/06/08 By Elise 修正本期現金及約當現金淨增數
# Modify.........: No:MOD-C70041 12/07/04 By Polly 抓取gix05金額增加帳別條件抓取
# Modify.........: No:FUN-C70092 12/08/07 By Belle 增加期末餘額差異數
# Modify.........: No:MOD-CA0082 12/10/12 By Polly 調整總帳科餘期未數的抓取
# Modify.........: No:CHI-D10045 13/01/25 By apo 調整營運中心顯示
# Modify.........: No:CHI-D10047 13/01/31 By apo 修改附註揭露顯示方式

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE tm  RECORD
           title   LIKE type_file.chr50,  #輸入報表名稱
           y1      LIKE aah_file.aah02,   #輸入起始年度
           m1      LIKE aah_file.aah03,   #Begin 期別
           y2      LIKE aah_file.aah02,   #輸入截止年度
           m2      LIKE aah_file.aah03,   #End   期別
           y11     LIKE aah_file.aah02,   #輸入起始年度
           y21     LIKE aah_file.aah02,   #輸入截止年度
           m11     LIKE aah_file.aah03,   #Begin 期別
           m21     LIKE aah_file.aah03,   #End   期別
           b       LIKE aaa_file.aaa01,   #帳別編號
           c       LIKE type_file.chr1,   #異動額及餘額為0者是否列印
           e       LIKE azi_file.azi05,   #小數位數
           d       LIKE type_file.chr1,   #金額單位
           o       LIKE type_file.chr1,   #轉換幣別否
           r       LIKE azi_file.azi01,   #總帳幣別
           p       LIKE azi_file.azi01,   #轉換幣別
           q       LIKE azj_file.azj03,   #匯率
           amt     LIKE type_file.num20_6,#現金流量期初餘額
           s       LIKE type_file.chr1,   #是否有揭露事項
           t       LIKE type_file.chr1,   #列印明細
           more    LIKE type_file.chr1    #Input more condition(Y/N)   #CHI-C40011
           END RECORD,
       bdate,edate LIKE type_file.dat,
       i,j,k       LIKE type_file.num5,
       g_unit      LIKE type_file.num10,  #金額單位基數
       l_za05      LIKE za_file.za05,
       g_bookno    LIKE aah_file.aah00,   #帳別
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_giy       DYNAMIC ARRAY OF RECORD
                    giy01   LIKE giy_file.giy01,
                    giy02   LIKE giy_file.giy02,
                    giy03   LIKE giy_file.giy03,
                    giy031  LIKE giy_file.giy03   #CHI-D10047
                   END RECORD,
       g_tot1      ARRAY[100] OF LIKE type_file.num20_6,
       g_tot1_1    ARRAY[100] OF LIKE type_file.num20_6
DEFINE g_aaa03     LIKE aaa_file.aaa03
DEFINE g_aaa15     LIKE aaa_file.aaa15
DEFINE g_cnt       LIKE type_file.num10
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000
DEFINE g_name      LIKE type_file.chr20
DEFINE g_flag      LIKE type_file.chr1     #Y:產生接口數據 N:正常打印
DEFINE g_ym        LIKE type_file.chr6     #年期
DEFINE g_ym1       LIKE type_file.chr6     #年期
DEFINE l_table     STRING
DEFINE g_str       STRING
DEFINE g_sql       STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET tm.b = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   INITIALIZE tm.* TO NULL
   LET tm.y1 = ARG_VAL(8)
   LET tm.m1 = ARG_VAL(9)
   LET g_name= ARG_VAL(10)
   IF NOT (cl_null(tm.y1) OR cl_null(tm.m1)) THEN
      LET g_flag = 'Y'
      IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
      IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF
      LET g_ym = tm.y1 USING '&&&&',tm.m1 USING '&&'
      LET g_ym1= tm.y11 USING '&&&&',tm.m1 USING '&&'
      SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
      SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
      IF cl_null(tm.m2) THEN LET tm.m2 = tm.m1 END IF
      IF cl_null(tm.title) THEN LET tm.title = g_name END IF
      LET tm.r = g_aaa03
      LET tm.c = 'N'              #CHI-C40011 Y->N
      LET tm.d = '1'
      LET tm.o = 'N'
      LET tm.p = tm.r
      LET tm.q = 1
      LET tm.amt  = 0
      LET g_pdate  = g_today
      LET g_bgjob  = 'N'
      LET g_copies = '1'
      LET tm.t = 'N'
      LET tm.more  = 'N'          #CHI-C40011
      IF tm.d = '1' THEN LET g_unit = 1 END IF
      IF tm.d = '2' THEN LET g_unit = 1000 END IF
      IF tm.d = '3' THEN LET g_unit = 1000000 END IF
   ELSE
      LET g_flag = 'N'
   END IF

   LET g_rlang  = g_lang
   IF g_flag = 'N' THEN
      IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
      IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
         THEN CALL r940_tm()         # Input print condition
         ELSE CALL r940()            # Read data and create out-file
      END IF
   ELSE
      CALL r940()                    # Read data and create out-file
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r940_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_sw           LIKE type_file.chr1     #重要欄位是否空白
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5

   CALL s_dsmark(tm.b)

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE
      LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r940_w AT p_row,p_col WITH FORM "agl/42f/aglr940"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL  s_shwact(0,0,tm.b)
   CALL cl_opmsg('p')

   LET g_sql = "type.type_file.chr1,",
               "str1.type_file.chr50,",
               "giq02.type_file.chr1000,",
               "str2.type_file.chr50,",
               "giq04.giq_file.giq04,",
               "str3.type_file.chr50,",
               "str4.type_file.chr50"
   LET l_table = cl_prt_temptable('aglr940',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,? ,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF       
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) 
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)  
   END IF
   LET tm.c = 'N'          #CHI-C40011 Y->N
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.amt  = 0
   LET tm.s    = 'N'
   LET tm.t    = 'N'
   LET tm.more = 'N'       #CHI-C40011
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_sw = 1
     #INPUT BY NAME tm.title,tm.y1,tm.m1,tm.m2,           #FUN-C30098 mark
     #              tm.b,tm.e,tm.d,tm.c,tm.s,tm.t,        #FUN-C30098 mark
      INPUT BY NAME tm.b,tm.title,tm.y1,tm.m1,tm.m2,      #FUN-C30098
                    tm.e,tm.d,tm.c,tm.s,tm.t,             #FUN-C30098
                    tm.o,tm.r,tm.p,tm.q,tm.more           #CHI-C40011 add tm.more
                    WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT

         BEFORE FIELD title
            IF cl_null(tm.title) THEN 
               SELECT gaz06 INTO tm.title FROM gaz_file
                 WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05='Y'
               IF cl_null(tm.title) THEN
                  SELECT gaz06 INTO tm.title FROM gaz_file
                    WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05='N'
               END IF
            END IF

        #FUN-C30098---
         BEFORE FIELD q
            IF tm.o = 'N' THEN
               NEXT FIELD o
            END IF
        #FUN-C30098---
        #CHI-C40011---
         BEFORE FIELD p
            IF tm.o = 'N' THEN NEXT FIELD more END IF
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
            END IF
        #CHI-C40011---

         AFTER FIELD title
            IF tm.title IS NULL THEN NEXT FIELD title END IF

         AFTER FIELD y1
            IF tm.y1 IS NULL OR tm.y1 = 0 THEN
               NEXT FIELD y1
            END IF
            IF tm.y1 > YEAR(g_pdate) THEN
               CALL cl_err('','agl-920',0)
               NEXT FIELD y1
            END IF
            LET tm.y2  = tm.y1
            LET tm.y11 = tm.y1 - 1
            LET tm.y21 = tm.y11
            DISPLAY BY NAME tm.y11

         AFTER FIELD m1
            IF NOT cl_null(tm.m1) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.y1
               IF g_azm.azm02 = 1 THEN
                  IF tm.m1 > 12 OR tm.m1 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m1
                  END IF
               ELSE
                  IF tm.m1 > 13 OR tm.m1 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m1
                  END IF
               END IF
            END IF
            IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
            IF tm.y1 = YEAR(g_pdate) AND tm.m1 > MONTH(g_pdate) THEN
               CALL cl_err('','agl-920',0)
               NEXT FIELD m1
            END IF
            LET tm.m11 = tm.m1
            DISPLAY BY NAME tm.m11
 
         AFTER FIELD m2
            IF NOT cl_null(tm.m2) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.y1
               IF g_azm.azm02 = 1 THEN
                  IF tm.m2 > 12 OR tm.m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               ELSE
                  IF tm.m2 > 13 OR tm.m2 < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m2
                  END IF
               END IF
            END IF
            IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
            IF tm.y2 = YEAR(g_pdate) AND tm.m2 > MONTH(g_pdate) THEN
               CALL cl_err('','agl-920',0)
               NEXT FIELD m2
            END IF
            IF tm.y1 = tm.y2 AND tm.m1 > tm.m2 THEN
               CALL cl_err('','9011',0) NEXT FIELD m1
            END IF
            LET tm.m21 = tm.m2
            DISPLAY BY NAME tm.m21

         AFTER FIELD b
            IF tm.b IS NULL THEN NEXT FIELD b END IF
               CALL s_check_bookno(tm.b,g_user,g_plant) 
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b 
               END IF 
            SELECT aaa02 FROM aaa_file
             WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
               NEXT FIELD b
            END IF

         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF

         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF

         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF

         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN  
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)  # NO.FUN-660123 
              NEXT FIELD p
            END IF

         AFTER FIELD q
            IF tm.q <= 0 THEN
               NEXT FIELD q
            END IF

         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF

         AFTER FIELD t
            IF tm.t IS NULL OR tm.t NOT MATCHES'[YN]' THEN 
               NEXT FIELD t
            END IF 
         
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
            IF tm.o = 'N' THEN
               LET tm.p = g_aaa03
               LET tm.q = 1
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution

         ON ACTION mntn_labor_amount
            CALL cl_cmdrun("agli942")

         ON ACTION mntn_expose_item
            CALL cl_cmdrun("agli944")

         ON ACTION CONTROLP
            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF
            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF

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

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r940_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r940()
      ERROR ""
   END WHILE
   CLOSE WINDOW r940_w
END FUNCTION

#CHI-D10045--Mark--
#FUNCTION r940()
#  DEFINE l_name    LIKE type_file.chr20         
#  DEFINE l_chr     LIKE type_file.chr1          
#  DEFINE amt1      LIKE type_file.num20_6       
#  DEFINE amt1_1    LIKE type_file.num20_6       
#  DEFINE l_tmp     LIKE type_file.num20_6       

#  #移至前面主要因為tm.title 多語言的關係
#  SELECT aaf03 INTO g_company FROM aaf_file
#   WHERE aaf01 = tm.b  
#     AND aaf02 = g_rlang
#
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr940'

#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR  
#   CALL cl_outnam('aglr940') RETURNING l_name
#   CALL cl_del_data(l_table)
#   CALL r940_cr()

#END FUNCTION

#FUNCTION r940_cr()
#CHI-D10045--Mark--
FUNCTION r940()      #CHI-D10045
   DEFINE l_sql       LIKE type_file.chr1000,      # RDSQL STATEMENT
          l_unit      LIKE zaa_file.zaa08,        
          l_str1      LIKE type_file.chr50,
          l_str2      LIKE type_file.chr50,
          l_str3      LIKE type_file.chr50,
          l_str4      LIKE type_file.chr50,
          l_d1        LIKE type_file.num5,        
          l_d2        LIKE type_file.num5,        
          l_flag      LIKE type_file.chr1,        
          l_str       LIKE type_file.chr21,       
          l_bdate     LIKE type_file.dat,         
          l_edate     LIKE type_file.dat,         
          l_type      LIKE aag_file.aag06,          #正常餘額型態(1.借餘/2.貨餘) 
          l_cnt       LIKE type_file.num5,          #揭露事項筆數       
          l_last_y    LIKE type_file.num5,          #期初年份 
          l_last_m    LIKE type_file.num5,          #期初月份 
          l_this      LIKE type_file.num20_6,       #本期餘額 
          l_last      LIKE type_file.num20_6,       #期初餘額 
          l_next      LIKE type_file.num20_6,       #期末餘額 
          l_diff      LIKE type_file.num20_6,       #差異 
          l_modamt    LIKE type_file.num20_6,       #調整金額
          l_amt       LIKE type_file.num20_6,       #科目現金流量 
          l_amt_s     LIKE type_file.num20_6,       #群組現金流量 
          l_sub_amt   LIKE type_file.num20_6,       #各活動產生之淨現金 
          l_tot_amt   LIKE type_file.num20_6,       #本期現金淨增數 
          l_last_y1   LIKE type_file.num5,
          l_str_1     LIKE type_file.chr21,       
          l_this_1    LIKE type_file.num20_6,       #本期餘額 
          l_last_1    LIKE type_file.num20_6,       #期初餘額 
          l_next_1    LIKE type_file.num20_6,       #期末餘額 
          l_diff_1    LIKE type_file.num20_6,       #差異 
          l_modamt_1  LIKE type_file.num20_6,       #調整金額  
          l_amt_1     LIKE type_file.num20_6,       #科目現金流量(前期)
          l_amt_s_1   LIKE type_file.num20_6,       #群組現金流量(前期)
          l_sub_amt_1 LIKE type_file.num20_6,       #各活動產生之淨現金 
          l_tot_amt_1 LIKE type_file.num20_6        #本期現金淨增數 
   DEFINE tmp         RECORD
          aag01       LIKE aag_file.aag01,
          aag02       LIKE aag_file.aag02,
          giw03       LIKE giw_file.giw03,
          giw04       LIKE giw_file.giw04
                  END RECORD
   DEFINE giq         RECORD                         #群組代號
          giq01       LIKE giq_file.giq01,
          giq02       LIKE giq_file.giq02,
          giq04       LIKE giq_file.giq04
                  END RECORD
   DEFINE l_giq02     LIKE type_file.chr1000                   
   DEFINE l_gix       DYNAMIC ARRAY OF RECORD 
          giq02       LIKE type_file.chr1000,
          gix05       LIKE gix_file.gix05,
          gix051      LIKE gix_file.gix05
                  END RECORD       
   DEFINE l_i_1       LIKE type_file.num5       
   DEFINE l_i_2       LIKE type_file.num5
   DEFINE l_space     STRING
   DEFINE l_len       LIKE type_file.num5 
   DEFINE l_num       LIKE type_file.num5 
   DEFINE l_giq04     LIKE giq_file.giq04      #行次
   DEFINE tmp1        RECORD
          type        LIKE type_file.chr1,
          str1        LIKE type_file.chr50,
          giq02       LIKE type_file.chr1000,
          str2        LIKE type_file.chr50,
          giq04       LIKE giq_file.giq04,
          str3        LIKE type_file.chr50,
          str4        LIKE type_file.chr50
                  END RECORD

  #CHI-D10045--   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL cl_del_data(l_table)
  #CHI-D10045--  

   CALL r940_create_temp_table()

   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y1,tm.m1,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate
   END IF
   LET l_d1 = DAY(l_bdate)
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y2,tm.m2,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
   ELSE
      CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate
   END IF
   LET l_d2 = DAY(l_edate)
   IF tm.m1=1 THEN
      LET l_last_y = tm.y1 - 1
      LET l_last_y1= tm.y11- 1
      LET l_last_m = 12
   ELSE
      LET l_last_y = tm.y1
      LET l_last_y1= tm.y11
      LET l_last_m = tm.m1 - 1
   END IF

   LET l_amt = 0
   LET l_amt_s = 0
   LET l_this = 0
   LET l_last = 0
   LET l_next = 0
   LET l_sub_amt = 0
   LET l_tot_amt = 0
   LET l_this_1 = 0
   LET l_last_1 = 0
   LET l_next_1 = 0
   LET l_amt_1 = 0
   LET l_amt_s_1 = 0
   LET l_sub_amt_1 = 0
   LET l_tot_amt_1 = 0
   LET l_giq04 = 0
  #營業活動之現金流量
  #---------------------本期淨利(損)------------------------------
   LET l_type = '1'
   LET l_flag = 'N'
   SELECT aaa15 INTO g_aaa15 FROM aaa_file WHERE aaa01 = tm.b
   CALL r940_aah(g_aaa15,tm.y1,tm.m2) RETURNING l_amt
   IF cl_null(l_amt) THEN LET l_amt = 0 END IF
   CALL r940_aah(g_aaa15,tm.y11,tm.m2) RETURNING l_amt_1
   IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
  #將本期淨利(損)金額加至 營業活動產生之淨現金l_sub_amt
   LET l_sub_amt = l_sub_amt + l_amt
  #FUN-C30098--
  #LET l_amt = l_amt*tm.q/g_unit                #依匯率及單位換算
   LET l_amt = l_amt/g_unit                     #依單位換算
   IF tm.o = 'Y' THEN
       LET l_amt = l_amt*tm.q                   #依匯率換算
   END IF
  #FUN-C30098--
   LET l_sub_amt_1 = l_sub_amt_1 + l_amt_1
  #FUN-C30098--
  #LET l_amt_1 = l_amt_1*tm.q/g_unit            #依匯率及單位換算
   LET l_amt_1 = l_amt_1/g_unit                 #依單位換算
   IF tm.o = 'Y' THEN
       LET l_amt_1 = l_amt_1*tm.q               #依匯率換算
   END IF
  #FUN-C30098--
   IF l_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_amt,20,tm.e)
   ELSE
      CALL r940_str(l_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   IF l_amt_1 >= 0 THEN
      LET l_str3 = cl_numfor(l_amt_1,20,tm.e)
   ELSE
      CALL r940_str(l_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   
   #調整項目
   #-------------------------營業科目-------------------------------
   LET l_sql= " SELECT giq01,giq02,giq04 FROM giq_file "
             ,"  WHERE giq03 = '1'"
             ,"  ORDER BY giq04,giq02"
   PREPARE r940_giq_p1 FROM l_sql
   DECLARE r940_giq_c1 CURSOR FOR r940_giq_p1

   LET l_sql = "SELECT aag01,aag02,giw03,giw04 "
              ,"  FROM aag_file,giw_file,giq_file"
              ," WHERE aag01=giw02 AND giq01=giw01 "
              ,"   AND aag00=giw00 AND aag00 = '",tm.b,"' "
              ,"   AND giw01 = ?"
   PREPARE r940_giw_p1 FROM l_sql
   DECLARE r940_giw_c1 CURSOR FOR r940_giw_p1
   FOREACH r940_giq_c1 INTO giq.*
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      LET l_i_1 = 1
      FOREACH r940_giw_c1 USING giq.giq01 INTO tmp.*
         LET l_amt = 0
         LET l_amt_1 = 0
         CASE tmp.giw04  
           WHEN '1'
              CALL r940_aah(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
              CALL r940_aah(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
           WHEN '2'
              CALL r940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
              CALL r940_aah2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1
           WHEN '3'
              CALL r940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
              CALL r940_aah2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
           WHEN '4'
              LET l_str_1 = tmp.aag01
              LET l_len = LENGTH(l_str_1)
              LET l_num = 26 - l_len
              LET l_space = l_num spaces
              LET l_gix[l_i_1].giq02 = tmp.aag01||l_space||tmp.aag02
              SELECT SUM(gix05) INTO l_amt 
                FROM gix_file,giq_file
               WHERE gix01 = giq.giq01 
                 AND gix02 = tmp.aag01
                 AND gix06 = tm.y1 
                 AND gix07 BETWEEN tm.m1 AND tm.m2
                 AND gix01 = giq01
                 AND gix00 = tm.b                     #MOD-C70041 add
              LET l_gix[l_i_1].gix05=l_amt
              SELECT SUM(gix05) INTO l_amt_1 
                FROM gix_file,giq_file
               WHERE gix01 = giq.giq01 
                 AND gix02 = tmp.aag01
                 AND gix06 = tm.y11 
                 AND gix07 BETWEEN tm.m1 AND tm.m2
                 AND gix01 = giq01
                 AND gix00 = tm.b                     #MOD-C70041 add
              LET l_gix[l_i_1].gix051=l_amt_1
              LET l_i_1 = l_i_1 + 1
           WHEN '5'  #借方異動
              SELECT SUM(aah04) INTO l_amt FROM aah_file
               WHERE aah00=tm.b AND aah01=tmp.aag01
                 AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
              SELECT SUM(aah04) INTO l_amt_1 FROM aah_file
               WHERE aah00=tm.b AND aah01=tmp.aag01
                 AND aah02=tm.y11 AND aah03 BETWEEN tm.m11 AND tm.m2
           WHEN '6'  #貸方異動
              SELECT SUM(aah05) INTO l_amt FROM aah_file
               WHERE aah00=tm.b AND aah01=tmp.aag01
                 AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
              SELECT SUM(aah05) INTO l_amt_1 FROM aah_file
               WHERE aah00=tm.b AND aah01=tmp.aag01
                 AND aah02=tm.y11 AND aah03 BETWEEN tm.m11 AND tm.m2
         END CASE
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
         IF tmp.giw04 <> '4' THEN
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_gix[l_i_1].giq02 = tmp.aag01||l_space||tmp.aag02
            SELECT SUM(gix05) INTO l_modamt 
              FROM gix_file,giq_file
             WHERE gix01 = giq.giq01 
               AND gix02 = tmp.aag01
               AND gix06 = tm.y1 
               AND gix07 BETWEEN tm.m1 AND tm.m2
               AND gix01 = giq01
               AND gix00 = tm.b                     #MOD-C70041 add
            IF cl_null(l_modamt) THEN LET l_modamt = 0 END IF
            LET l_amt = l_amt + l_modamt
            LET l_gix[l_i_1].gix05=l_amt
            SELECT SUM(gix05) INTO l_modamt_1 
              FROM gix_file,giq_file
             WHERE gix01 = giq.giq01 
               AND gix02 = tmp.aag01
               AND gix06 = tm.y11 
               AND gix07 BETWEEN tm.m1 AND tm.m2
               AND gix01 = giq01
               AND gix00 = tm.b                     #MOD-C70041 add
            IF cl_null(l_modamt_1) THEN LET l_modamt_1 = 0 END IF
            LET l_amt_1 = l_amt_1 + l_modamt_1
            LET l_gix[l_i_1].gix051=l_amt_1
            LET l_i_1 = l_i_1 + 1
         END IF
        #若為減項
         IF tmp.giw03 = '-' THEN 
            LET l_amt  = l_amt * -1
            LET l_amt_1  = l_amt_1 * -1
         END IF
         LET l_amt_s = l_amt_s + l_amt
         LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1   

      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      LET l_sub_amt = l_sub_amt + l_amt_s         #計算營業活動產生之淨現金
     #FUN-C30098--
     #LET l_amt_s = l_amt_s*tm.q/g_unit           #依匯率及單位換算
      LET l_amt_s = l_amt_s/g_unit                #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s = l_amt_s*tm.q               #依匯率換算
      END IF 
     #FUN-C30098--
      LET l_sub_amt_1 = l_sub_amt_1 + l_amt_s_1   #計算營業活動產生之淨現金
     #FUN-C30098--
     #LET l_amt_s_1 = l_amt_s_1*tm.q/g_unit       #依匯率及單位換算
      LET l_amt_s_1 = l_amt_s_1/g_unit            #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s_1 = l_amt_s_1*tm.q           #依匯率換算
      END IF
     #FUN-C30098--
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,')'
      END IF
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,')'
      END IF
      LET l_flag = 'Y'
      IF tm.t = 'N' THEN 
         INSERT INTO r940_tmp VALUES (l_type,l_str1,giq.giq02,l_str2,giq.giq04,l_str3,l_str4)
      ELSE 
      	 FOR l_i_2 = 1 TO l_i_1
            IF cl_null(l_gix[l_i_2].gix05) THEN
               LET l_gix[l_i_2].gix05 = 0
            END IF
            IF cl_null(l_gix[l_i_2].gix051) THEN
               LET l_gix[l_i_2].gix051 = 0
            END IF
            IF l_gix[l_i_2].gix05 >= 0 THEN
               LET l_str2 = cl_numfor(l_gix[l_i_2].gix05,20,tm.e)
            ELSE
               CALL r940_str(l_gix[l_i_2].gix05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
            END IF
            IF l_gix[l_i_2].gix051 >= 0 THEN
               LET l_str4 = cl_numfor(l_gix[l_i_2].gix051,20,tm.e)
            ELSE
               CALL r940_str(l_gix[l_i_2].gix051,l_str4) RETURNING l_str4
               LET l_str4 = l_str4 CLIPPED,')'
            END IF
            INSERT INTO r940_tmp VALUES (l_type,l_str1,l_gix[l_i_2].giq02,l_str2,giq.giq04,l_str3,l_str4)
      	 END FOR     
      END IF
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO r940_tmp VALUES (l_type,l_str1,'','',l_giq04,l_str3,'')
   END IF

   #營業活動產生之淨現金
   LET l_type = '2' 
   LET l_tot_amt = l_tot_amt + l_sub_amt        #計算本期現金淨增數
  #FUN-C30098--
  #LET l_sub_amt = l_sub_amt*tm.q/g_unit        #依匯率及單位換算
   LET l_sub_amt = l_sub_amt/g_unit             #依單位換算
   IF tm.o = 'Y' THEN
      LET l_sub_amt = l_sub_amt*tm.q            #依匯率換算
   END IF
  #FUN-C30098-- 
   LET l_tot_amt_1 = l_tot_amt_1 + l_sub_amt_1  #計算本期現金淨增數
  #FUN-C30098--
  #LET l_sub_amt_1 = l_sub_amt_1*tm.q/g_unit    #依匯率及單位換算
   LET l_sub_amt_1 = l_sub_amt_1/g_unit         #依單位換算
   IF tm.o = 'Y' THEN
      LET l_sub_amt_1 = l_sub_amt_1*tm.q        #依匯率換算
   END IF
  #FUN-C30098--
   IF l_sub_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL r940_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   IF l_sub_amt_1 >= 0 THEN
      LET l_str3 = cl_numfor(l_sub_amt_1,20,tm.e)
   ELSE
      CALL r940_str(l_sub_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO r940_tmp VALUES (l_type,l_str1,'','',l_giq04,l_str3,'')
   LET l_sub_amt = 0
   LET l_amt_s = 0
   LET l_sub_amt_1 = 0
   LET l_amt_s_1 = 0

   #----------------------投資活動之現金流量-----------------------
   LET l_type = '3'
   LET l_flag = 'N'
   LET l_sql = "SELECT giq01,giq02,giq04 FROM giq_file "
              ," WHERE giq03 = '2'"
              ," ORDER BY giq04,giq02"
   PREPARE r940_giq_p2 FROM l_sql
   DECLARE r940_giq_c2 CURSOR FOR r940_giq_p2
   LET l_sql = "SELECT aag01,aag02,giw03,giw04 "
              ,"  FROM aag_file,giw_file,giq_file"
              ," WHERE aag01=giw02 AND giw01=giq01 "
              ,"   AND aag00=giw00 AND aag00 = '",tm.b,"' "
              ,"   AND giw01 = ?" 
   PREPARE r940_giw_p2 FROM l_sql
   DECLARE r940_giw_c2 CURSOR FOR r940_giw_p2

   FOREACH r940_giq_c2 INTO giq.*
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      LET l_i_1 = 1
      FOREACH r940_giw_c2 USING giq.giq01 INTO tmp.*
        LET l_amt = 0
        LET l_amt_1 = 0
        CASE tmp.giw04
          WHEN '1'
            CALL r940_aah(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
            CALL r940_aah(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
          WHEN '2'
            CALL r940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
            CALL r940_aah2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1
          WHEN '3'
            CALL r940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
            CALL r940_aah2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
          WHEN '4'
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_gix[l_i_1].giq02 = tmp.aag01||l_space||tmp.aag02   
            SELECT SUM(gix05) INTO l_amt 
              FROM gix_file,giq_file
             WHERE gix01 = giq.giq01 
               AND gix02 = tmp.aag01
               AND gix06 = tm.y1 
               AND gix07 BETWEEN tm.m1 AND tm.m2
               AND gix01 = giq01
               AND gix00 = tm.b                     #MOD-C70041 add
            LET l_gix[l_i_1].gix05=l_amt
            SELECT SUM(gix05) INTO l_amt_1 
              FROM gix_file,giq_file
             WHERE gix01 = giq.giq01 
               AND gix02 = tmp.aag01
               AND gix06 = tm.y11 
               AND gix07 BETWEEN tm.m1 AND tm.m2
               AND gix01 = giq01
               AND gix00 = tm.b                     #MOD-C70041 add
            LET l_gix[l_i_1].gix051=l_amt_1
            LET l_i_1 = l_i_1 + 1
          WHEN '5'  #借方異動
            SELECT SUM(aah04) INTO l_amt FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
            SELECT SUM(aah04) INTO l_amt_1 FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y11 AND aah03 BETWEEN tm.m1 AND tm.m2
          WHEN '6'  #貸方異動
            SELECT SUM(aah05) INTO l_amt FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
            SELECT SUM(aah05) INTO l_amt_1 FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y11 AND aah03 BETWEEN tm.m1 AND tm.m2
        END CASE
        #若為減項
        IF cl_null(l_amt) THEN LET l_amt = 0 END IF
        IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
        #TQC-C50059--add--str
        IF tmp.giw04 <> '4' THEN
           LET l_str_1 = tmp.aag01
           LET l_len = LENGTH(l_str_1)
           LET l_num = 26 - l_len
           LET l_space = l_num spaces
           LET l_gix[l_i_1].giq02 = tmp.aag01||l_space||tmp.aag02
           SELECT SUM(gix05) INTO l_modamt
             FROM gix_file,giq_file
            WHERE gix01 = giq.giq01 
              AND gix02 = tmp.aag01
              AND gix06 = tm.y1 
              AND gix07 BETWEEN tm.m1 AND tm.m2
              AND gix01 = giq01
              AND gix00 = tm.b                     #MOD-C70041 add
           IF cl_null(l_modamt) THEN LET l_modamt = 0 END IF
           LET l_amt = l_amt + l_modamt
           LET l_gix[l_i_1].gix05=l_amt
           SELECT SUM(gix05) INTO l_modamt_1
             FROM gix_file,giq_file
            WHERE gix01 = giq.giq01 
              AND gix02 = tmp.aag01
              AND gix06 = tm.y11 
              AND gix07 BETWEEN tm.m1 AND tm.m2
              AND gix01 = giq01
              AND gix00 = tm.b                     #MOD-C70041 add
           IF cl_null(l_modamt_1) THEN LET l_modamt_1 = 0 END IF
           LET l_amt_1 = l_amt_1 + l_modamt_1
           LET l_gix[l_i_1].gix051=l_amt_1
           LET l_i_1 = l_i_1 + 1
        END IF
        #TQC-C50059--add--end
        IF tmp.giw03 = '-' THEN 
           LET l_amt  = l_amt * -1
           LET l_amt_1= l_amt_1 * -1
        END IF
        LET l_amt_s = l_amt_s + l_amt
        LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1
      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      #計算投資活動產生之淨現金
      LET l_sub_amt = l_sub_amt + l_amt_s
     #FUN-C30098--
     #LET l_amt_s = l_amt_s*tm.q/g_unit       #依匯率及單位換算
      LET l_amt_s = l_amt_s/g_unit            #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s = l_amt_s*tm.q           #依匯率換算
      END IF
     #FUN-C30098--
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")" 
      END IF
      LET l_sub_amt_1 = l_sub_amt_1 + l_amt_s_1
     #FUN-C30098--
     #LET l_amt_s_1 = l_amt_s_1*tm.q/g_unit       #依匯率及單位換算
      LET l_amt_s_1 = l_amt_s_1/g_unit            #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s_1 = l_amt_s_1*tm.q           #依匯率換算
      END IF
     #FUN-C30098--
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,")" 
      END IF
      LET l_flag = 'Y'
      IF tm.t = 'N' THEN 
         INSERT INTO r940_tmp VALUES (l_type,'',giq.giq02,l_str2,giq.giq04,'',l_str4)
      ELSE 
      	 FOR l_i_2 = 1 TO l_i_1
            IF cl_null(l_gix[l_i_2].gix05) THEN
               LET l_gix[l_i_2].gix05 = 0
            END IF
            IF cl_null(l_gix[l_i_2].gix051) THEN
               LET l_gix[l_i_2].gix051 = 0
            END IF
     	    IF l_gix[l_i_2].gix05 >= 0 THEN
               LET l_str2 = cl_numfor(l_gix[l_i_2].gix05,20,tm.e)
            ELSE
               CALL r940_str(l_gix[l_i_2].gix05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
            END IF
     	    IF l_gix[l_i_2].gix051 >= 0 THEN
               LET l_str4 = cl_numfor(l_gix[l_i_2].gix051,20,tm.e)
            ELSE
               CALL r940_str(l_gix[l_i_2].gix051,l_str2) RETURNING l_str4
               LET l_str4 = l_str4 CLIPPED,')'
            END IF
      	    INSERT INTO r940_tmp VALUES (l_type,'',l_gix[l_i_2].giq02,l_str2,giq.giq04,'',l_str4)
     	 END FOR     
      END IF
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO r940_tmp VALUES (l_type,'','','',l_giq04,'','')
   END IF
   
   #----------------------投資活動之淨現金-----------------------
   LET l_type = '4'
   LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
  #FUN-C30098--
  #LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
   LET l_sub_amt = l_sub_amt/g_unit       #依單位換算
   IF tm.o = 'Y' THEN
      LET l_sub_amt = l_sub_amt*tm.q      #依匯率換算
   END IF
  #FUN-C30098--
   IF l_sub_amt >= 0 THEN
      LET l_str1 =cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL r940_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   LET l_tot_amt_1 = l_tot_amt_1 + l_sub_amt_1    #計算本期現金淨增數
  #FUN-C30098--
  #LET l_sub_amt_1 = l_sub_amt_1*tm.q/g_unit      #依匯率及單位換算
   LET l_sub_amt_1 = l_sub_amt_1/g_unit           #依單位換算
   IF tm.o = 'Y' THEN
      LET l_sub_amt_1 = l_sub_amt_1*tm.q          #依匯率換算
   END IF
  #FUN-C30098--
   IF l_sub_amt_1 >= 0 THEN
      LET l_str3 =cl_numfor(l_sub_amt_1,20,tm.e)
   ELSE
      CALL r940_str(l_sub_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO r940_tmp VALUES (l_type,l_str1,'','',l_giq04,l_str3,'')
   LET l_sub_amt = 0
   LET l_amt_s = 0
   LET l_sub_amt_1 = 0
   LET l_amt_s_1 = 0
   
   #-------------------理財活動之現金流量------------------------------
   #理財活動之現金流量
   LET l_type = '5'
   LET l_flag = 'N'
   LET l_sql = "SELECT giq01,giq02,giq04 FROM giq_file "
              ," WHERE giq03 = '3'"
              ," ORDER BY giq04,giq04"
   PREPARE r940_giq_p3 FROM l_sql
   DECLARE r940_giq_c3 CURSOR FOR r940_giq_p3
   LET l_sql = "SELECT aag01,aag02,giw03,giw04 "
              ," FROM aag_file,giw_file,giq_file"
              ," WHERE aag01=giw02 AND giw01=giq01 "
              ,"   AND aag00=giw00 AND aag00 = '",tm.b,"' "
              ,"   AND giw01 = ?"
   PREPARE r940_giw_p3 FROM l_sql
   DECLARE r940_giw_c3 CURSOR FOR r940_giw_p3
   FOREACH r940_giq_c3 INTO giq.*
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      LET l_i_1 = 1
      FOREACH r940_giw_c3 USING giq.giq01 INTO tmp.*
        LET l_amt = 0
        LET l_amt_1 = 0
        CASE tmp.giw04  
          WHEN '1'
            CALL r940_aah(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
            CALL r940_aah(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
          WHEN '2'
            CALL r940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
            CALL r940_aah2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1
          WHEN '3'
            CALL r940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
            CALL r940_aah2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
          WHEN '4'
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_gix[l_i_1].giq02 = tmp.aag01||l_space||tmp.aag02
            SELECT SUM(gix05) INTO l_amt 
              FROM gix_file,giq_file
             WHERE gix01 = giq.giq01 
               AND gix02 = tmp.aag01
               AND gix06 = tm.y1 
               AND gix07 BETWEEN tm.m1 AND tm.m2
               AND gix01 = giq01
               AND gix00 = tm.b                     #MOD-C70041 add
            LET l_gix[l_i_1].gix05=l_amt
            SELECT SUM(gix05) INTO l_amt_1 
              FROM gix_file,giq_file
             WHERE gix01 = giq.giq01 
               AND gix02 = tmp.aag01
               AND gix06 = tm.y11 
               AND gix07 BETWEEN tm.m1 AND tm.m2
               AND gix01 = giq01
               AND gix00 = tm.b                     #MOD-C70041 add
            LET l_gix[l_i_1].gix051=l_amt_1
            LET l_i_1 = l_i_1 + 1  
          WHEN '5'  #借方異動
            SELECT SUM(aah04) INTO l_amt FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
            SELECT SUM(aah04) INTO l_amt_1 FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y11 AND aah03 BETWEEN tm.m1 AND tm.m2
          WHEN '6'  #貸方異動
            SELECT SUM(aah05) INTO l_amt FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
            SELECT SUM(aah05) INTO l_amt_1 FROM aah_file
             WHERE aah00=tm.b AND aah01=tmp.aag01
               AND aah02=tm.y11 AND aah03 BETWEEN tm.m1 AND tm.m2
        END CASE
       #若為減項
        IF cl_null(l_amt) THEN LET l_amt = 0 END IF
        IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
        #TQC-C50059--add--str
           IF tmp.giw04 <> '4' THEN
           LET l_str_1 = tmp.aag01
           LET l_len = LENGTH(l_str_1)
           LET l_num = 26 - l_len
           LET l_space = l_num spaces
           LET l_gix[l_i_1].giq02 = tmp.aag01||l_space||tmp.aag02
           SELECT SUM(gix05) INTO l_modamt
             FROM gix_file,giq_file
            WHERE gix01 = giq.giq01 
              AND gix02 = tmp.aag01
              AND gix06 = tm.y1 
              AND gix07 BETWEEN tm.m1 AND tm.m2
              AND gix01 = giq01
              AND gix00 = tm.b                     #MOD-C70041 add
           IF cl_null(l_modamt) THEN LET l_modamt = 0 END IF
           LET l_amt = l_amt + l_modamt
           LET l_gix[l_i_1].gix05=l_amt
           SELECT SUM(gix05) INTO l_modamt_1
             FROM gix_file,giq_file
            WHERE gix01 = giq.giq01 
              AND gix02 = tmp.aag01
              AND gix06 = tm.y11 
              AND gix07 BETWEEN tm.m1 AND tm.m2
              AND gix01 = giq01
              AND gix00 = tm.b                     #MOD-C70041 add
           IF cl_null(l_modamt_1) THEN LET l_modamt_1 = 0 END IF
           LET l_amt_1 = l_amt_1 + l_modamt_1
           LET l_gix[l_i_1].gix051=l_amt_1
           LET l_i_1 = l_i_1 + 1
        END IF
        #TQC-C50059--add--end
        IF tmp.giw03 = '-' THEN 
           LET l_amt  = l_amt * -1
           LET l_amt_1  = l_amt_1 * -1
        END IF
        LET l_amt_s = l_amt_s + l_amt
        LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1
      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      #計算理財活動產生之淨現金
      LET l_sub_amt = l_sub_amt + l_amt_s
     #FUN-C30098--
     #LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
      LET l_amt_s= l_amt_s/g_unit            #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s= l_amt_s*tm.q           #依匯率換算
      END IF
     #FUN-C30098--
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
      LET l_sub_amt_1 = l_sub_amt_1 + l_amt_s_1
     #FUN-C30098--
     #LET l_amt_s_1= l_amt_s_1*tm.q/g_unit       #依匯率及單位換算
      LET l_amt_s_1= l_amt_s_1/g_unit            #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s_1= l_amt_s_1*tm.q           #依匯率換算
      END IF
     #FUN-C30098--
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,")"
      END IF
      LET l_flag = 'Y'
      IF tm.t = 'N' THEN 
         INSERT INTO r940_tmp VALUES (l_type,'',giq.giq02,l_str2,giq.giq04,'',l_str4)
      ELSE 
         FOR l_i_2 = 1 TO l_i_1
            IF cl_null(l_gix[l_i_2].gix05) THEN
               LET l_gix[l_i_2].gix05 = 0
            END IF
            IF cl_null(l_gix[l_i_2].gix051) THEN
               LET l_gix[l_i_2].gix051 = 0
            END IF
    	    IF l_gix[l_i_2].gix05 >= 0 THEN
               LET l_str2 = cl_numfor(l_gix[l_i_2].gix05,20,tm.e)
            ELSE
               CALL r940_str(l_gix[l_i_2].gix05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
            END IF
    	    IF l_gix[l_i_2].gix051 >= 0 THEN
               LET l_str4 = cl_numfor(l_gix[l_i_2].gix051,20,tm.e)
            ELSE
               CALL r940_str(l_gix[l_i_2].gix051,l_str4) RETURNING l_str4
               LET l_str4 = l_str4 CLIPPED,')'
            END IF
            INSERT INTO r940_tmp VALUES (l_type,'',l_gix[l_i_2].giq02,l_str2,giq.giq04,'',l_str4)
    	 END FOR     
      END IF
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO r940_tmp VALUES (l_type,'','','',l_giq04,'','')
   END IF
   LET l_type = '6'
   LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
  #FUN-C30098--
  #LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
   LET l_sub_amt = l_sub_amt/g_unit       #依單位換算
   IF tm.o = 'Y' THEN
       LET l_sub_amt = l_sub_amt*tm.q     #依匯率換算
   END IF
   LET l_tot_amt_1 = l_tot_amt_1 + l_sub_amt_1  #計算本期現金淨增數
   LET l_sub_amt_1 = l_sub_amt_1/g_unit         #依單位換算
   IF tm.o = 'Y' THEN
       LET l_sub_amt_1 = l_sub_amt_1*tm.q       #依匯率換算
   END IF
  #FUN-C30098--
   IF l_sub_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL r940_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF

   IF l_sub_amt_1 >= 0 THEN
      LET l_str3 = cl_numfor(l_sub_amt_1,20,tm.e)
   ELSE
      CALL r940_str(l_sub_amt_1,l_str3) RETURNING l_str3
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO r940_tmp VALUES (l_type,l_str1,'','',l_giq04,l_str3,'')

   LET l_type = '7'
   LET l_flag = 'N'
   LET l_amt = l_tot_amt                  #本期現金淨增數
  #FUN-C30098--
  #LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
   LET l_amt = l_amt/g_unit               #依單位換算
   IF tm.o = 'Y' THEN
      LET l_amt = l_amt*tm.q              #依匯率換算
   END IF
  #FUN-C30098--
   LET l_amt_1 = l_tot_amt_1              #本期現金淨增數
  #FUN-C30098--
  #LET l_amt_1 = l_amt_1*tm.q/g_unit      #依匯率及單位換算
   LET l_amt_1 = l_amt_1/g_unit           #依單位換算
   IF tm.o = 'Y' THEN
      LET l_amt_1 = l_amt_1*tm.q          #依匯率換算
   END IF
  #FUN-C30098--
   IF l_amt >=0 THEN
      LET l_str1 = cl_numfor(l_amt,20,tm.e)
   ELSE
      CALL r940_str(l_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   IF l_amt_1 >=0 THEN
      LET l_str3 = cl_numfor(l_amt_1,20,tm.e)
   ELSE
      CALL r940_str(l_amt_1,l_str3) RETURNING l_str3  #MOD-C60050 l_amt -> l_amt_1
      LET l_str3 = l_str3 CLIPPED,')'
   END IF
   INSERT INTO r940_tmp VALUES (l_type,l_str1,'','',l_giq04,l_str3,'')

   #-------------------期初現金及約當現金餘額 -------------------------
   LET l_type = '8'
  #FUN-C30098--Mark--
  #LET g_sql = " SELECT giz03 FROM giz_file"
  #            ," WHERE giz00 = ? AND giz01 = ? "
  #            ," AND giz02 <  (SELECT MAX(giz02) FROM giz_file"
  #            ,"                WHERE giz00 = ? AND giz01 = ?"
  #            ,"                  AND giz02 = ?)"
  #PREPARE i940_giz03_p1 FROM g_sql
  #DECLARE i940_giz03_c1 SCROLL CURSOR FOR i940_giz03_p1
  #OPEN i940_giz03_c1 USING tm.b,l_last_y,tm.b,l_last_y,l_last_m
  #FETCH i940_giz03_c1 INTO l_last
  #OPEN i940_giz03_c1 USING tm.b,l_last_y1,tm.b,l_last_y1,l_last_m
  #FETCH i940_giz03_c1 INTO l_last_1
  #FUN-C30098--Mark--

   IF cl_null(l_last)   THEN LET l_last   = 0 END IF
   IF cl_null(l_last_1) THEN LET l_last_1 = 0 END IF
   
   LET l_sql = "SELECT giq01,giq02,giq04 FROM giq_file "
              ," WHERE giq03 = '4'"
              ," ORDER BY giq04,giq04"
   PREPARE r940_giq_p4 FROM l_sql
   DECLARE r940_giq_c4 CURSOR FOR r940_giq_p4
   LET l_sql = "SELECT aag01,aag02,giw03,giw04 "
              ,"  FROM aag_file,giw_file,giq_file"
              ," WHERE aag01=giw02 AND giq01=giw01 "
              ,"   AND aag00=giw00 AND aag00 = '",tm.b,"' "
              ,"   AND giw01 = ?"
   PREPARE r940_giw_p4 FROM l_sql
   DECLARE r940_giw_c4 CURSOR FOR r940_giw_p4
   FOREACH r940_giq_c4 INTO giq.*
      LET l_amt_s = 0
      LET l_amt_s_1 = 0
      LET l_i_1 = 1
      FOREACH r940_giw_c4 USING giq.giq01 INTO tmp.*
         LET l_amt = 0
         LET l_amt_1 = 0
         CASE tmp.giw04
           WHEN '1'
              IF l_last = 0 THEN
                 CALL r940_aah(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
              END IF
              IF l_last_1 = 0 THEN
                 CALL r940_aah(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
              END IF
           WHEN '2'
              IF l_last = 0 THEN
                 CALL r940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
              END IF
              IF l_last_1 = 0 THEN
                 CALL r940_aah2(tmp.aag01,l_last_y1,l_last_m) RETURNING l_amt_1
              END IF
           WHEN '3'
              IF l_last = 0 THEN
                 CALL r940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
              END IF
              IF l_last_1 = 0 THEN
                 CALL r940_aah2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1
              END IF
           WHEN '4'
             LET l_str_1 = tmp.aag01
             LET l_len = LENGTH(l_str_1)
             LET l_num = 26 - l_len
             LET l_space = l_num spaces
             LET l_gix[l_i_1].giq02 = tmp.aag01||l_space||tmp.aag02
             IF l_last = 0 THEN
                SELECT SUM(gix05) INTO l_amt 
                  FROM gix_file,giq_file
                 WHERE gix01 = giq.giq01 
                   AND gix02 = tmp.aag01
                   AND gix06 = tm.y1 
                   AND gix07 BETWEEN tm.m1 AND tm.m2
                   AND gix01 = giq01
                   AND gix00 = tm.b                     #MOD-C70041 add
                LET l_gix[l_i_1].gix05=l_amt
             END IF
             IF l_last_1 = 0 THEN
                SELECT SUM(gix05) INTO l_amt_1 
                  FROM gix_file,giq_file
                 WHERE gix01 = giq.giq01 
                   AND gix02 = tmp.aag01
                   AND gix06 = tm.y11 
                   AND gix07 BETWEEN tm.m1 AND tm.m2
                   AND gix01 = giq01
                   AND gix00 = tm.b                     #MOD-C70041 add
                LET l_gix[l_i_1].gix051=l_amt_1
             END IF
             LET l_i_1 = l_i_1 + 1
           WHEN '5'  #借方異動
             IF l_last = 0 THEN
                SELECT SUM(aah04) INTO l_amt FROM aah_file
                 WHERE aah00=tm.b AND aah01=tmp.aag01
                   AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
             END IF
             IF l_last_1 = 0 THEN
                SELECT SUM(aah04) INTO l_amt_1 FROM aah_file
                 WHERE aah00=tm.b AND aah01=tmp.aag01
                   AND aah02=tm.y11 AND aah03 BETWEEN tm.m1 AND tm.m2
             END IF
           WHEN '6'  #貸方異動
             IF l_last = 0 THEN
                SELECT SUM(aah05) INTO l_amt FROM aah_file
                  WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
             END IF
             IF l_last_1 = 0 THEN
                SELECT SUM(aah05) INTO l_amt_1 FROM aah_file
                 WHERE aah00=tm.b AND aah01=tmp.aag01
                   AND aah02=tm.y11 AND aah03 BETWEEN tm.m1 AND tm.m2
             END IF
         END CASE
        #若為減項
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
         IF tmp.giw03 = '-' THEN 
            LET l_amt  = l_amt * -1
            LET l_amt_1  = l_amt_1 * -1
         END IF
         LET l_amt_s = l_amt_s + l_amt
         LET l_amt_s_1 = l_amt_s_1 + l_amt_1
      END FOREACH
      LET l_i_1 = l_i_1 - 1
      IF l_amt_s = 0 AND l_amt_s_1 = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
     #FUN-C30098--
     #LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
      LET l_amt_s= l_amt_s/g_unit            #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s= l_amt_s*tm.q           #依匯率換算
      END IF
     #FUN-C30098--
      LET l_this = l_this + l_amt_s
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
     #FUN-C30098--
     #LET l_amt_s_1= l_amt_s_1*tm.q/g_unit    #依匯率及單位換算
      LET l_amt_s_1= l_amt_s_1/g_unit         #依單位換算
      IF tm.o = 'Y' THEN
         LET l_amt_s_1= l_amt_s_1*tm.q        #依單位換算
      END IF
     #FUN-C30098--
      LET l_this_1 = l_this_1 + l_amt_s_1
      IF l_amt_s_1 >= 0 THEN
         LET l_str4 = cl_numfor(l_amt_s_1,20,tm.e)
      ELSE
         CALL r940_str(l_amt_s_1,l_str4) RETURNING l_str4
         LET l_str4 = l_str4 CLIPPED,")"
      END IF
      LET l_flag = 'Y'
     #IF tm.t = 'N' THEN #TQC-C50139 mark
         INSERT INTO r940_tmp VALUES (l_type,l_str1,giq.giq02,l_str2,giq.giq04,l_str3,l_str4)
     #TQC-C50139--mark--str
     #ELSE 
     #   FOR l_i_2 = 1 TO l_i_1
     #      IF cl_null(l_gix[l_i_2].gix05) THEN
     #         LET l_gix[l_i_2].gix05 = 0
     #      END IF
     #      IF cl_null(l_gix[l_i_2].gix051) THEN
     #         LET l_gix[l_i_2].gix051 = 0
     #      END IF
     #      IF l_gix[l_i_2].gix05 >= 0 THEN
     #         LET l_str2 = cl_numfor(l_gix[l_i_2].gix05,20,tm.e)
     #      ELSE
     #         CALL r940_str(l_gix[l_i_2].gix05,l_str2) RETURNING l_str2
     #         LET l_str2 = l_str2 CLIPPED,')'
     #      END IF
     #      IF l_gix[l_i_2].gix051 >= 0 THEN
     #         LET l_str4 = cl_numfor(l_gix[l_i_2].gix051,20,tm.e)
     #      ELSE
     #         CALL r940_str(l_gix[l_i_2].gix051,l_str4) RETURNING l_str4
     #         LET l_str4 = l_str4 CLIPPED,')'
     #      END IF
     #      INSERT INTO r940_tmp VALUES (l_type,l_str1,l_gix[l_i_2].giq02,l_str2,giq.giq04,l_str3,l_str4)
     #   END FOR     
     #END IF 
     #TQC-C50139--mar--end
   END FOREACH
   IF l_flag = 'N' THEN
      INSERT INTO r940_tmp VALUES (l_type,l_str1,'','',l_giq04,l_str3,'')
   END IF

   #--------------------期末現金及約當現金餘額---------------------
   LET l_type ='9'
   LET l_flag = 'N'

   IF l_flag = 'N' THEN
      INSERT INTO r940_tmp VALUES (l_type,'','','',l_giq04,'','')
   END IF

   IF tm.s = 'Y' THEN
      LET l_type = 'A'
      LET l_flag = 'N'
      LET g_cnt = 1
      DECLARE r940_giy CURSOR FOR
        #CHI-D10047--mark
        #SELECT giy01,giy02,giy03 FROM giy_file
        # WHERE giy04=tm.y1 AND giy05 BETWEEN tm.m1 AND tm.m2     #FUN-C30098
        # ORDER BY giy01                                          #FUN-C30098
        #CHI-D10047--mark
        #CHI-D10047--
         SELECT giy01,giy02,giy03,
          (SELECT giy03 FROM giy_file WHERE giy04= tm.y1-1 AND giy05 BETWEEN tm.m1 AND tm.m2 AND giy02=a.giy02) AS giy031
           FROM giy_file a
          WHERE a.giy04 = tm.y1 AND a.giy05 BETWEEN tm.m1 AND tm.m2 
          ORDER BY giy05,giy01
        #CHI-D10047--
      FOREACH r940_giy INTO g_giy[g_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)  
             EXIT FOREACH
         END IF
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('','9035',0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_cnt = g_cnt - 1
      FOR i = 1 TO g_cnt
         IF cl_null(g_giy[i].giy03) THEN LET g_giy[i].giy03 = 0 END IF     #CHI-D10047
         IF cl_null(g_giy[i].giy031) THEN LET g_giy[i].giy031 = 0 END IF   #CHI-D10047
         LET l_str2 = cl_numfor(g_giy[i].giy03,20,tm.e)
        #LET l_str4= cl_numfor(g_giy[i].giy03,20,tm.e)    #CHI-D10047 mark
         LET l_str4= cl_numfor(g_giy[i].giy031,20,tm.e)   #CHI-D10047
         LET l_flag = 'Y'
         INSERT INTO r940_tmp VALUES (l_type,'',g_giy[i].giy02,l_str2,g_giy[i].giy01,'',l_str4)
      END FOR
     #CHI-D10047--str
      LET l_cnt = 1
      DECLARE r940_giy_1 CURSOR FOR
         SELECT giy01,giy02,'',giy03 FROM giy_file a
          WHERE giy04 = tm.y1-1 AND giy05 BETWEEN tm.m1 AND tm.m2
             AND NOT EXISTS(SELECT * FROM giy_file WHERE giy04 = tm.y1 AND giy05 BETWEEN tm.m1 AND tm.m2 AND giy02 = a.giy02)
            ORDER BY giy05,giy01   
      FOREACH r940_giy_1 INTO g_giy[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)  
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
         IF l_cnt > g_max_rec THEN
            CALL cl_err('','9035',0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET l_cnt = l_cnt - 1
      FOR i = 1 TO l_cnt
         IF cl_null(g_giy[i].giy03) THEN LET g_giy[i].giy03 = 0 END IF     
         IF cl_null(g_giy[i].giy031) THEN LET g_giy[i].giy031 = 0 END IF   
         LET l_str2 = cl_numfor(g_giy[i].giy03,20,tm.e)
         LET l_str4= cl_numfor(g_giy[i].giy031,20,tm.e)  
         LET l_flag = 'Y'
         INSERT INTO r940_tmp VALUES (l_type,'',g_giy[i].giy02,l_str2,g_giy[i].giy01,'',l_str4)
      END FOR
     #CHI-D10047--end
      IF l_flag = 'N' THEN
         INSERT INTO r940_tmp VALUES (l_type,'','','',l_giq04,'','')
      END IF
   END IF
   IF l_last = 0 THEN
      SELECT SUM(str2) INTO l_last  FROM r940_tmp WHERE l_type ='8'
   END IF
   IF l_last_1 = 0 THEN
      SELECT SUM(str4) INTO l_last_1  FROM r940_tmp WHERE l_type ='8'
   END IF
   IF cl_null(l_last) THEN LET l_last = 0 END IF
   IF cl_null(l_last_1) THEN LET l_last_1 = 0 END IF
   LET l_flag = 'N'

   LET l_sql = " SELECT * FROM r940_tmp "
              ," ORDER BY type,giq04,giq02 "
   PREPARE r940_p1 FROM l_sql
   DECLARE r940_c1 CURSOR FOR r940_p1
   FOREACH r940_c1 INTO tmp1.*
      CASE tmp1.type
         WHEN '8'
            IF l_last >=0 THEN
               LET tmp1.str1 = cl_numfor(l_last,20,tm.e)
            ELSE
               CALL r940_str(l_last,tmp1.str1) RETURNING tmp1.str1
               LET tmp1.str1 = tmp1.str1 CLIPPED,')'                   #FUN-C40004 l_str-->tmp1.str1
            END IF
            IF l_last_1 >=0 THEN
               LET tmp1.str3 = cl_numfor(l_last_1,20,tm.e)
            ELSE
               CALL r940_str(l_last_1,tmp1.str3) RETURNING tmp1.str3 
               LET tmp1.str3 = tmp1.str3 CLIPPED,')'                   #FUN-C40004 l_str-->tmp1.str3
            END IF
         WHEN '9'
           #FUN-C70092--Begin--
            IF tm.o = 'Y' THEN
               LET l_tot_amt   = l_tot_amt  * tm.q     #依匯率換算
               LET l_tot_amt_1 = l_tot_amt_1* tm.q     #依單位換算
            END IF
           #FUN-C70092---End---
            LET l_amt = l_tot_amt + l_this
            LET l_amt_1 = l_tot_amt_1 + l_this_1
            IF cl_null(l_amt) THEN LET l_amt = 0 END IF
            IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
            IF l_amt >=0 THEN
               LET tmp1.str1 = cl_numfor(l_amt,20,tm.e)
            ELSE
               CALL r940_str(l_amt,tmp1.str1) RETURNING tmp1.str1
               LET tmp1.str1 = tmp1.str1 CLIPPED,')'                    #FUN-C40004 l_str-->tmp1.str1
            END IF
            IF l_amt_1 >=0 THEN
               LET tmp1.str3 = cl_numfor(l_amt_1,20,tm.e)
            ELSE
               CALL r940_str(l_amt_1,tmp1.str3) RETURNING tmp1.str3 
               LET tmp1.str3 = tmp1.str3 CLIPPED,')'                    #FUN-C40004 l_str-->tmp1.str3
            END IF
      END CASE
      IF (tmp1.type = '8') THEN
         IF (l_flag = 'N') THEN
           #EXECUTE insert_prep USING tmp1.type,tmp1.str1,tmp1.giq02,tmp1.str2,tmp1.giq04,tmp1.str3,tmp1.str4  #FUN-C30098 mark 
            EXECUTE insert_prep USING tmp1.type,tmp1.str2,'','','0',tmp1.str4,''                               #FUN-C30098 mod
            LET l_flag = 'Y'
         END IF
      ELSE
         EXECUTE insert_prep USING tmp1.type,tmp1.str1,tmp1.giq02,tmp1.str2,tmp1.giq04,tmp1.str3,tmp1.str4 
      END IF
   END FOREACH
  #FUN-C70092--Begin--
  #---------------------期初餘額+本期現金凈增數與總帳科餘期末數差異數---------------------
   LET l_diff   = 0
   LET l_diff_1 = 0
   LET l_type = 'B'
   IF cl_null(l_last)   THEN LET l_last   = 0 END IF
   IF cl_null(l_last_1) THEN LET l_last_1 = 0 END IF
   LET l_amt_s   = 0
   LET l_amt_s_1 = 0
   LET l_sql = "SELECT aag01,aag02,giw03,giw04 "
              ,"  FROM aag_file,giw_file,giq_file"
              ," WHERE aag01=giw02 AND giq01=giw01"
              ,"   AND aag00=giw00 AND aag00 = '",tm.b,"' "
              ,"   AND giq03 = '4'"
   PREPARE r940_giw_p5 FROM l_sql
   DECLARE r940_giw_c5 CURSOR FOR r940_giw_p5
   FOREACH r940_giw_c5 INTO tmp.*
      LET l_amt   = 0
      LET l_amt_1 = 0
     #CALL r940_aah(tmp.aag01,tm.y2,tm.m2)  RETURNING l_amt             #MOD-CA0082 mark
     #CALL r940_aah(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1           #MOD-CA0082 mark
      CALL r940_aah2(tmp.aag01,tm.y2,tm.m2)  RETURNING l_amt            #MOD-CA0082 add
      CALL r940_aah2(tmp.aag01,tm.y21,tm.m2) RETURNING l_amt_1          #MOD-CA0082 add
     #若為減項
      IF cl_null(l_amt)   THEN LET l_amt   = 0 END IF
      IF cl_null(l_amt_1) THEN LET l_amt_1 = 0 END IF
      IF tmp.giw03 = '-' THEN 
         LET l_amt   = l_amt   * -1
         LET l_amt_1 = l_amt_1 * -1
      END IF
      LET l_amt_s   = l_amt_s   + l_amt
      LET l_amt_s_1 = l_amt_s_1 + l_amt_1
   END FOREACH
     
   LET l_amt_s   = l_amt_s  /g_unit       #依單位換算
   LET l_amt_s_1 = l_amt_s_1/g_unit       #依單位換算
   IF tm.o = 'Y' THEN
      LET l_amt_s   = l_amt_s  * tm.q     #依匯率換算
      LET l_amt_s_1 = l_amt_s_1* tm.q     #依單位換算
   END IF
   LET l_diff   = l_amt_s   - (l_tot_amt   + l_this)
   LET l_diff_1 = l_amt_s_1 - (l_tot_amt_1 + l_this_1)
   
   IF l_diff >= 0 THEN
      LET l_str2 = cl_numfor(l_diff,20,tm.e)
   ELSE
      CALL r940_str(l_diff,l_str2) RETURNING l_str2
      LET l_str2 = l_str2 CLIPPED,")"
   END IF
   IF l_diff_1 >= 0 THEN
      LET l_str4 = cl_numfor(l_diff_1,20,tm.e)
   ELSE
      CALL r940_str(l_diff_1,l_str4) RETURNING l_str4
      LET l_str4 = l_str4 CLIPPED,")"
   END IF
   EXECUTE insert_prep USING l_type,l_str2,'','','',l_str4,''
  #FUN-C70092---End---
  #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                            #FUN-C30098 mark
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY type,giq04"                     #FUN-C30098 mod 
   LET g_str = ''
   LET g_str = tm.d,";",tm.title,";",tm.p,";","",";",tm.y1,";",tm.m1,";",
               l_d1,";",tm.y2,";",tm.m2,";",l_d2
   CALL cl_prt_cs3('aglr940','aglr940',g_sql,g_str)
        
END FUNCTION

FUNCTION r940_aah(p_aah01,p_aah02,p_aah03)
   DEFINE p_aah01     LIKE aah_file.aah01,
          p_aah02     LIKE aah_file.aah02,
          p_aah03     LIKE aah_file.aah03,
          p_value     LIKE aah_file.aah04      
   DEFINE l_type      LIKE aag_file.aag06   

   LET p_value = 0
   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_aah01
                                            AND aag00= tm.b 
   IF l_type = '1' THEN
      SELECT SUM(aah04-aah05) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 BETWEEN tm.m1 AND tm.m2
   ELSE
      SELECT SUM(aah05-aah04) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 BETWEEN tm.m1 AND tm.m2
   END IF
   RETURN p_value
END FUNCTION

FUNCTION r940_aah2(p_aah01,p_aah02,p_aah03)
   DEFINE p_aah01     LIKE aah_file.aah01,
          p_aah02     LIKE aah_file.aah02,
          p_aah03     LIKE aah_file.aah03,
          p_value     LIKE aah_file.aah04   
   DEFINE l_type      LIKE aag_file.aag06   

   LET p_value = 0
   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_aah01
                                            AND aag00=tm.b  

   IF l_type = '1' THEN
      SELECT SUM(aah04-aah05) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 <= p_aah03
   ELSE
      SELECT SUM(aah05-aah04) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 <= p_aah03
   END IF
   IF cl_null(p_value) THEN LET p_value = 0 END IF
   RETURN p_value
END FUNCTION

FUNCTION r940_str(p_amt,p_str)
   DEFINE p_amt LIKE type_file.num20_6,   
          p_str LIKE type_file.chr1000,  
          l_x   LIKE type_file.num5  

   LET p_str = cl_numfor(p_amt*(-1),20,tm.e)
   FOR l_x = 1 TO 20
       IF cl_null(p_str[l_x,l_x]) THEN
           LET l_x = l_x - 1
           EXIT FOR
       END IF
   END FOR
   IF l_x != 0 THEN
      LET p_str[l_x,l_x] = '('
   ELSE
      LET p_str[1,1] = '('
   END IF

   RETURN p_str

END FUNCTION

FUNCTION r940_numfor(p_value,p_n)
   DEFINE p_value	LIKE type_file.num26_10,    #No.FUN-680098 dec(26,10) 
          p_len,p_n     LIKE type_file.num20_6,     #No.FUN-680098 smallint  
          l_len 	LIKE type_file.num5,        #No.FUN-680098 smallint
          l_str		LIKE type_file.chr1000,     #No.FUN-680098 VARCHAR(37)
          l_str1        LIKE type_file.chr1,        #No.FUN-680098 VARCHAR(1)
          l_length      LIKE type_file.num5,        #No.FUN-680098 smallint    
          i,j,k         LIKE type_file.num5         #No.FUN-680098 smallint
     
   LET p_value = cl_digcut(p_value,p_n)
   CASE WHEN p_n = 0  LET l_str = p_value USING '------------------------------------&'
        WHEN p_n = 10 LET l_str = p_value USING '-------------------------&.&&&&&&&&&&'
        WHEN p_n = 9  LET l_str = p_value USING '--------------------------&.&&&&&&&&&'
        WHEN p_n = 8  LET l_str = p_value USING '---------------------------&.&&&&&&&&'
        WHEN p_n = 7  LET l_str = p_value USING '----------------------------&.&&&&&&&'
        WHEN p_n = 6  LET l_str = p_value USING '-----------------------------&.&&&&&&'
        WHEN p_n = 5  LET l_str = p_value USING '------------------------------&.&&&&&'
        WHEN p_n = 4  LET l_str = p_value USING '-------------------------------&.&&&&'
        WHEN p_n = 3  LET l_str = p_value USING '--------------------------------&.&&&'
        WHEN p_n = 2  LET l_str = p_value USING '---------------------------------&.&&'
        WHEN p_n = 1  LET l_str = p_value USING '----------------------------------&.&'
   END CASE
   LET j=37                    #TQC-640038 
   LET p_len = FGL_WIDTH(p_value)
   LET i = j - p_len + 9
   IF i < 0 THEN               #FUN-560048
        IF not cl_null(g_xml_rep) THEN
          LET i = 0
        ELSE
          LET i = 1
        END IF
   END IF
 
   LET l_length = 0
   #當傳進的金額位數實際上大於所要求回傳的位數時，該欄位應show"*****" NO:0508
   FOR k = 37 TO 1 STEP -1 
       LET l_str1 = l_str[k,k]
       IF cl_null(l_str1) THEN EXIT FOR END IF
       LET l_length = l_length + 1
   END FOR
   IF l_length > p_len THEN
      LET i = j - l_length
      IF i < 0 THEN
            RETURN l_str
      END IF
   END IF
   IF not cl_null(g_xml_rep) THEN
      RETURN l_str[i+1,j]
   ELSE 
      RETURN l_str[i,j]
   END IF
END FUNCTION

FUNCTION r940_create_temp_table()
   DROP TABLE r940_tmp
   CREATE TEMP TABLE r940_tmp(
   type   LIKE type_file.chr1,
   str1   LIKE type_file.chr50,
   giq02  LIKE type_file.chr1000,
   str2   LIKE type_file.chr50,
   giq04  LIKE giq_file.giq04,
   str3   LIKE type_file.chr50,
   str4   LIKE type_file.chr50)
END FUNCTION

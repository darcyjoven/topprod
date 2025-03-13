# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglg116.4gl
# Descriptions...: 試算表列印  
# Date & Author..: 07/10/18 By Nicola(FUN-7A0035)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-950048 09/05/25 By jan 拿掉‘版本’欄位 
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No.FUN-B80158 11/08/26 By yangtt  明細類CR轉換成GRW
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No:CHI-CC0023 13/01/29 By Lori tm.c欄位未依據aglr110的條件做設定;
#                                                 判斷式條件IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"改MATCHES "[0125]"

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              axa01    LIKE axa_file.axa01,    #FUN-A90032
              a        LIKE mai_file.mai01,    #報表結構編號 
              b        LIKE aaa_file.aaa01,    #帳別編號     
              yy       LIKE type_file.num5,    #輸入年度  
              axa06    LIKE axa_file.axa06,    #FUN-A90032   
              bm       LIKE type_file.num5,    #Begin 期別   
              em       LIKE type_file.num5,    # End  期別 
              q1       LIKE type_file.chr1,    #FUN-A90032
              h1       LIKE type_file.chr1,    #FUN-A90032  
              dd       LIKE type_file.num5,    #截止日       
              c        LIKE type_file.chr1,    #異動額及餘額為0者是否列印
              d        LIKE type_file.chr1,    #金額單位    
              e        LIKE type_file.num5,    #小數位數    
              f        LIKE type_file.num5,    #列印最小階數
              h        LIKE type_file.chr4,    #額外說明類別
              o        LIKE type_file.chr1,    #轉換幣別否  
              p        LIKE azi_file.azi01,    #幣別  
              q        LIKE azj_file.azj03,    #匯率
              r        LIKE azi_file.azi01,    #幣別
              i        LIKE axh_file.axh01,
              j        LIKE axh_file.axh02,
              k        LIKE axh_file.axh03,
              l        LIKE axh_file.axh04,
              m        LIKE axh_file.axh041,
              n        LIKE axh_file.axh12,
             #s        LIKE axh_file.axh13, #FUN-950048
              more     LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD,
       bdate,edate     LIKE type_file.dat, 
       i,j,k,g_mm      LIKE type_file.num5,
       g_unit          LIKE type_file.num10,   #金額單位基數
       g_bookno        LIKE axh_file.axh00,    #帳別
       g_mai02         LIKE mai_file.mai02,
       g_mai03         LIKE mai_file.mai03,
       g_tot1_1        ARRAY[100] OF LIKE type_file.num20_6,
       g_tot1_2        ARRAY[100] OF LIKE type_file.num20_6,
       g_tot2_1        ARRAY[100] OF LIKE type_file.num20_6,
       g_tot2_2        ARRAY[100] OF LIKE type_file.num20_6,
       g_tot3_1        ARRAY[100] OF LIKE type_file.num10, 
       g_tot3_2        ARRAY[100] OF LIKE type_file.num10,
       g_tot4_1        ARRAY[100] OF LIKE type_file.num20_6,
       g_tot4_2        ARRAY[100] OF LIKE type_file.num20_6
DEFINE g_aaa03         LIKE aaa_file.aaa03   
DEFINE g_i             LIKE type_file.num10             
DEFINE g_aaa09         LIKE aaa_file.aaa09             
DEFINE l_table         STRING                                 
DEFINE g_sql           STRING  
DEFINE g_str           STRING 
DEFINE g_axa05         LIKE axa_file.axa05  #FUN-A90032 
 
###GENGRE###START
TYPE sr1_t RECORD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal1_1 LIKE axh_file.axh08,
    bal1_2 LIKE axh_file.axh08,
    bal2_1 LIKE axh_file.axh08,
    bal2_2 LIKE axh_file.axh09,
    bal3_1 LIKE axh_file.axh10,
    bal3_2 LIKE axh_file.axh11,
    bal4_1 LIKE axh_file.axh08,
    bal4_2 LIKE axh_file.axh08,
    line LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "maj20.maj_file.maj20,",
               "maj20e.maj_file.maj20e,",
               "maj02.maj_file.maj02,",   #項次(排序要用的)
               "maj03.maj_file.maj03,",   #列印碼
               "bal1_1.axh_file.axh08,",  #期初借 
               "bal1_2.axh_file.axh08,",  #期初貸 
               "bal2_1.axh_file.axh08,",  #本期借 
               "bal2_2.axh_file.axh09,",  #本期貸 
               "bal3_1.axh_file.axh10,",  #筆數借 
               "bal3_2.axh_file.axh11,",  #筆數貸 
               "bal4_1.axh_file.axh08,",  #期末借 
               "bal4_2.axh_file.axh08,",  #期末貸 
               "line.type_file.num5"      #1:表示此筆為空行 2:表示此筆不為空行
 
   LET l_table = cl_prt_temptable('aglg116',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,    #TQC-A40133 mark
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.yy = ARG_VAL(10)
#  LET tm.bm = ARG_VAL(11)    #FUN-A90032
   LET tm.axa06 = ARG_VAL(11) #FUN-A90032
   LET tm.em = ARG_VAL(12)
   LET tm.dd = ARG_VAL(13)
   LET tm.c  = ARG_VAL(14)
   LET tm.d  = ARG_VAL(15)
   LET tm.e  = ARG_VAL(16)
   LET tm.f  = ARG_VAL(17)
   LET tm.h  = ARG_VAL(18)
   LET tm.o  = ARG_VAL(19)
   LET tm.p  = ARG_VAL(20)
   LET tm.q  = ARG_VAL(21)
   LET tm.r  = ARG_VAL(22)
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
   LET tm.q1 = ARG_VAL(27)       #FUN-A90032
   LET tm.h1 = ARG_VAL(28)       #FUN-A90032
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b)  THEN LET tm.b=g_aza.aza81  END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g116_tm()                   # Input print condition
      ELSE CALL g116()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION g116_tm()
   DEFINE p_row,p_col  LIKE type_file.num5,  
          l_sw         LIKE type_file.chr1,  
          l_cmd        LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5 
   DEFINE li_result    LIKE type_file.num5   
   DEFINE l_aaa05      LIKE aaa_file.aaa05     #FUN-A90032
   DEFINE l_aznn01     LIKE aznn_file.aznn01   #FUN-A90032
   DEFINE l_cnt        LIKE type_file.num5     #FUN-A90032
   DEFINE l_axz03      LIKE axz_file.axz03     #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW g116_w AT p_row,p_col WITH FORM "agl/42f/aglg116" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) 
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0) 
   END IF
 
   LET tm.b = g_aza.aza81
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bm = 0           #FUN-A90032
   WHILE TRUE
       LET l_sw = 1
       INPUT BY NAME tm.axa01,tm.b,tm.i,tm.a,tm.j,tm.k,tm.l,tm.m,tm.n, #FUN-A90032 add axa01
                    #tm.s,tm.yy,tm.bm,tm.em,tm.dd,   #FUN-950048
#                    tm.yy,tm.bm,tm.em,tm.dd,        #FUN-950048 #FUN-A90032 mark
                     tm.yy,tm.em,tm.q1,tm.h1,tm.dd,        #FUN-950048 #FUN-A90032
                     tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                     tm.p,tm.q,tm.more WITHOUT DEFAULTS  
 
         BEFORE INPUT
             CALL cl_qbe_init()
             CALL g116_set_entry()    #FUN-A90032
             CALL g116_set_no_entry() #FUN-A90032
 
       ON ACTION locale
          CALL cl_show_fld_cont() 
         LET g_action_choice = "locale"
        
#FUN-A90032 --Begin
         AFTER FIELD axa01
            IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
            SELECT COUNT(*) INTO l_cnt FROM axa_file 
             WHERE axa01=tm.axa01
            IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
            LET tm.axa06 = '2'
            SELECT axa05,axa06 
              INTO g_axa05,tm.axa06
             FROM axa_file
            WHERE axa01 = tm.axa01
              AND axa04 = 'Y'
            DISPLAY BY NAME tm.axa06
            CALL g116_set_entry()
            CALL g116_set_no_entry()
            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET l_aaa05 = 0
                SELECT aaa05 INTO l_aaa05 FROM aaa_file 
                 WHERE aaa01=tm.b 
#                  AND aaaacti MATCHES '[Yy]'  #No.TQC-B30100 Mark 
                   AND aaaacti IN ('Y','y')       #No.TQC-B30100 add
                LET tm.em = l_aaa05
            END IF
            IF tm.axa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.axa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.axa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1

         AFTER FIELD q1
         IF cl_null(tm.q1) AND  tm.axa06 = '2' THEN
            NEXT FIELD q1
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF

         AFTER FIELD h1
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
#FUN-A90032 --End        
 
         AFTER FIELD a
            IF tm.a IS NULL THEN NEXT FIELD a END IF
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                   WHERE mai01 = tm.a 
                     AND mai00 = tm.b
                     AND maiacti IN ('Y','y')
            IF STATUS THEN 
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0) 
               NEXT FIELD a 
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF
 
          AFTER FIELD b
            IF tm.b IS NULL THEN 
               NEXT FIELD b END IF
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b 
                                         AND aaaacti IN ('Y','y')
            IF STATUS THEN 
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
         AFTER FIELD i
            IF tm.i IS NULL THEN NEXT FIELD i END IF
 
         AFTER FIELD j
            IF tm.j IS NULL THEN NEXT FIELD j END IF
 
         AFTER FIELD k
            IF tm.k IS NULL THEN NEXT FIELD k END IF
 
         AFTER FIELD l
            IF tm.l IS NULL THEN NEXT FIELD l END IF
 
         AFTER FIELD m
            IF tm.m IS NULL THEN NEXT FIELD m END IF
 
         AFTER FIELD n
            IF tm.n IS NULL THEN NEXT FIELD n END IF
 
        #AFTER FIELD s   #FUN-950048
        #   IF tm.s IS NULL THEN NEXT FIELD s END IF #FUN-950048
 
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF
 
#FUN-A90032 --Begin 
#         AFTER FIELD bm
#         IF NOT cl_null(tm.bm) THEN
#            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = tm.yy
#            IF g_azm.azm02 = 1 THEN
#               IF tm.bm > 12 OR tm.bm < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD bm
#               END IF
#            ELSE
#               IF tm.bm > 13 OR tm.bm < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD bm
#               END IF
#            END IF
#         END IF
# 
#            IF tm.bm IS NULL THEN NEXT FIELD bm END IF
#FUN-A90032 --End            
  
         AFTER FIELD em
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
            IF tm.em IS NULL THEN NEXT FIELD em END IF
#            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF #FUN-A90032 mark
 
         AFTER FIELD dd
            IF tm.dd IS NOT NULL THEN
               IF tm.dd <0 OR tm.dd > 31 THEN NEXT FIELD dd END IF
            END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         AFTER FIELD e
            IF tm.e < 0 OR cl_null(tm.e) THEN 
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
 
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0  THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
 
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
   
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
 
         BEFORE FIELD p
            IF tm.o = 'N' THEN NEXT FIELD more END IF
   
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)
               NEXT FIELD p 
            END IF
 
         BEFORE FIELD q
            IF tm.o = 'N' THEN NEXT FIELD o END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
   
         AFTER INPUT 
            IF INT_FLAG THEN EXIT INPUT END IF
            IF tm.yy IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy 
               CALL cl_err('',9033,0)
           END IF
#FUN-A90032 --Begin           
#            IF tm.bm IS NULL THEN 
#               LET l_sw = 0 
#               DISPLAY BY NAME tm.bm 
#           END IF
#            IF tm.em IS NULL THEN 
#               LET l_sw = 0 
#               DISPLAY BY NAME tm.em 
#           END IF
#FUN-A90032 --End           
           IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
           END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
            #--FUN-A90032 start--
            IF NOT cl_null(tm.axa06) THEN
                CASE
                    WHEN tm.axa06 = '1'
                         LET tm.bm = 0
                   #CHI-B10030 add --start--
                    OTHERWISE      
                         CALL s_axz03_dbs(tm.j) RETURNING l_axz03 
                         CALL s_get_aznn01(l_axz03,tm.axa06,tm.k,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                   #CHI-B10030 add --end--
                END CASE
            END IF
            #--FUN-A90032            
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution
 
         ON ACTION CONTROLP
            CASE 
            #FUN-A90032 --Begin
             WHEN INFIELD(axa01)#OR INFIELD(axa02)          #No:MOD-4C0156
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_axa'
                LET g_qryparam.default1 = tm.axa01
                LET g_qryparam.default2 = tm.j
                LET g_qryparam.default3 = tm.i
                CALL cl_create_qry() RETURNING tm.axa01,tm.j,tm.j
                DISPLAY BY NAME tm.axa01
                DISPLAY BY NAME tm.i
                DISPLAY BY NAME tm.j
                NEXT FIELD axa01
            #FUN-A90032 --End
            
            WHEN INFIELD(a) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a 
               DISPLAY BY NAME tm.a
               NEXT FIELD a
 
            WHEN INFIELD(b) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
               DISPLAY BY NAME tm.b
               NEXT FIELD b
   
            WHEN INFIELD(p) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p 
               DISPLAY BY NAME tm.p
               NEXT FIELD p
          END CASE
 
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
       IF INT_FLAG THEN
          LET INT_FLAG = 0 CLOSE WINDOW g116_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
          EXIT PROGRAM
             
       END IF
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file
              WHERE zz01='aglg116'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('aglg116','9031',1)   
          ELSE
             LET l_cmd = l_cmd CLIPPED,     
                             " '",g_bookno CLIPPED,"'" ,
                             " '",g_pdate CLIPPED,"'",
                             " '",g_towhom CLIPPED,"'",
                             #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                             " '",g_bgjob CLIPPED,"'",
                             " '",g_prtway CLIPPED,"'",
                             " '",g_copies CLIPPED,"'",
                             " '",tm.a CLIPPED,"'",
                             " '",tm.b CLIPPED,"'",
                             " '",tm.yy CLIPPED,"'",
#                            " '",tm.bm CLIPPED,"'",    #FUN-A90032
                             " '",tm.axa06 CLIPPED,"'", #FUN-A90032
                             " '",tm.em CLIPPED,"'",
                             " '",tm.dd CLIPPED,"'",
                             " '",tm.c CLIPPED,"'",
                             " '",tm.d CLIPPED,"'",
                             " '",tm.e CLIPPED,"'",
                             " '",tm.f CLIPPED,"'",
                             " '",tm.h CLIPPED,"'",
                             " '",tm.o CLIPPED,"'",
                             " '",tm.p CLIPPED,"'",
                             " '",tm.q CLIPPED,"'",
                             " '",tm.r CLIPPED,"'", 
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
                        ," '",tm.q1 CLIPPED,"'",   #FUN-A90032
                         " '",tm.h1 CLIPPED,"'"    #FUN-A90032
            CALL cl_cmdat('aglg116',g_time,l_cmd)   
         END IF
         CLOSE WINDOW g116_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g116()
      ERROR ""
   END WHILE
   CLOSE WINDOW g116_w
END FUNCTION
 
FUNCTION g116()
   DEFINE l_name    LIKE type_file.chr20    # External(Disk) file name 
   DEFINE l_sql     LIKE type_file.chr1000  # RDSQL STATEMENT         
   DEFINE l_chr     LIKE type_file.chr1   
   DEFINE amt1_1    LIKE axh_file.axh08
   DEFINE amt1_2    LIKE axh_file.axh08
   DEFINE amt2_1    LIKE axh_file.axh08
   DEFINE amt2_2    LIKE axh_file.axh09
   DEFINE amt3_1    LIKE axh_file.axh10
   DEFINE amt3_2    LIKE axh_file.axh11
   DEFINE amt4_1    LIKE axh_file.axh08
   DEFINE amt4_2    LIKE axh_file.axh08
   DEFINE l_tmp1    LIKE aas_file.aas04
   DEFINE l_tmp2    LIKE aas_file.aas05
   DEFINE l_endy1   LIKE axh_file.axh08
   DEFINE l_endy2   LIKE axh_file.axh08
   DEFINE l_tmp3    LIKE aas_file.aas06
   DEFINE l_tmp4    LIKE aas_file.aas07
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       bal1_1   LIKE axh_file.axh08,   #--- 期初借 
                       bal1_2   LIKE axh_file.axh08,   #--- 期初貸 
                       bal2_1   LIKE axh_file.axh08,   #--- 本期借 
                       bal2_2   LIKE axh_file.axh09,   #--- 本期貸 
                       bal3_1   LIKE axh_file.axh10,   #--- 筆數借 
                       bal3_2   LIKE axh_file.axh11,   #--- 筆數貸 
                       bal4_1   LIKE axh_file.axh08,   #--- 期末借 
                       bal4_2   LIKE axh_file.axh08    #--- 期末貸 
                    END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   SELECT aaf03 INTO g_company FROM aaf_file 
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"' ORDER BY maj02"
   PREPARE g116_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   DECLARE g116_c CURSOR FOR g116_p
 
   IF tm.dd IS NULL THEN
      LET g_mm = tm.em
   ELSE 
      LET g_mm = tm.em - 1
      LET bdate = MDY(tm.em, 01,    tm.yy)
      LET edate = MDY(tm.em, tm.dd, tm.yy)
   END IF
   FOR g_i = 1 TO 100 
      LET g_tot1_1[g_i] = 0 LET g_tot1_2[g_i] = 0 
      LET g_tot2_1[g_i] = 0 LET g_tot2_2[g_i] = 0 
      LET g_tot3_1[g_i] = 0 LET g_tot3_2[g_i] = 0 
      LET g_tot4_1[g_i] = 0 LET g_tot4_2[g_i] = 0 
   END FOR
 
   FOREACH g116_c INTO maj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
      END IF
      LET amt1_1=0 LET amt1_2=0 LET amt2_1=0 LET amt2_2=0 
      LET amt3_1=0 LET amt3_2=0 LET amt4_1=0 LET amt4_2=0 
      IF NOT cl_null(maj.maj21) THEN
         IF maj.maj24 IS NULL THEN
            #--- 期初
            SELECT SUM(axh08-axh09) INTO amt1_1 FROM axh_file,aag_file
                WHERE axh00 = tm.b
                  AND axh05 BETWEEN maj.maj21 AND maj.maj22
                  AND axh06 = tm.yy AND axh07 < tm.bm                
                  AND axh05 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b AND axh01=tm.i  
                  AND axh02=tm.j AND axh03=tm.k  
                  AND axh04=tm.l AND axh041=tm.m  
                  AND axh12=tm.n   #AND axh13=tm.s   #FUN-950048
            #--- 本期  
            SELECT SUM(axh08),SUM(axh09),SUM(axh10),SUM(axh11) 
                INTO amt2_1,amt2_2,amt3_1,amt3_2 FROM axh_file,aag_file
                WHERE axh00 = tm.b
                  AND axh05 BETWEEN maj.maj21 AND maj.maj22
                  AND axh06 = tm.yy AND axh07 >=tm.bm AND axh07 <=g_mm 
                  AND axh05 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b AND axh01=tm.i  
                  AND axh02=tm.j AND axh03=tm.k  
                  AND axh04=tm.l AND axh041=tm.m  
                  AND axh12=tm.n  #AND axh13=tm.s  #FUN-950048
            LET g_aaa09 = ''
            SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
            IF g_aaa09 = '2' THEN
              SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file,aag_file
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01
                 AND aag03 <> '4' 
                 AND aag00=tm.b 
         
              SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file,aag_file 
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01
                 AND aag03 <> '4' 
                 AND aag00=tm.b  
              IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
              IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
              LET amt2_1 = amt2_1 - l_endy1
              LET amt2_2 = amt2_2 - l_endy2
            END IF
         ELSE
            SELECT SUM(aao05-aao06) INTO amt1_1 FROM aao_file,aag_file
                WHERE aao00 = tm.b
                  AND aao01 BETWEEN maj.maj21 AND maj.maj22
                  AND aao02 BETWEEN maj.maj24 AND maj.maj25
                  AND aao03 = tm.yy AND aao04 < tm.bm
                  AND aao01 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b
            SELECT SUM(aao05),SUM(aao06) INTO amt2_1,amt2_2
                FROM aao_file,aag_file
                WHERE aao00 = tm.b
                  AND aao01 BETWEEN maj.maj21 AND maj.maj22
                  AND aao02 BETWEEN maj.maj24 AND maj.maj25
                  AND aao03 = tm.yy AND aao04 >=tm.bm AND aao04 <=g_mm 
                  AND aao01 = aag01 AND aag07 IN ('2','3')
                  AND aag00=tm.b
            SELECT COUNT(*) INTO amt3_1 FROM aba_file,abb_file,aag_file
                WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                  AND abb03 = aag01 AND aag07 IN ('2','3')
                  AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                  AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                  AND abb06='1' AND aba04 >=tm.bm AND aba04 <=g_mm 
                  AND abaacti = 'Y'  #no.4868
                  AND aag00=tm.b
                  AND aba19 <> 'X'  #CHI-C80041
            SELECT COUNT(*) INTO amt3_2 FROM aba_file,abb_file,aag_file
                WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                  AND abb03 = aag01 AND aag07 IN ('2','3')
                  AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                  AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                  AND abb06='2' AND aba04 >=tm.bm AND aba04 <=g_mm 
                  AND abaacti = 'Y'
                  AND aag00=tm.b  
                  AND aba19 <> 'X'  #CHI-C80041
            LET g_aaa09 = ''
            SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
            IF g_aaa09 = '2' THEN
              
              SELECT SUM(abb07) INTO l_endy1 FROM abb_file,aba_file,aag_file 
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND aba06 = 'CE' AND abb06 = '1' AND aba03 = tm.yy
                 AND abb05 BETWEEN maj.maj24 AND maj.maj25
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01
                 AND aag03 <> '4'
                 AND aag00=tm.b 
      
              SELECT SUM(abb07) INTO l_endy2 FROM abb_file,aba_file,aag_file
               WHERE abb00 = tm.b
                 AND aba00 = abb00 AND aba01 = abb01
                 AND abb03 BETWEEN maj.maj21 AND maj.maj22
                 AND abb05 BETWEEN maj.maj24 AND maj.maj25
                 AND aba06 = 'CE' AND abb06 = '2' AND aba03 = tm.yy
                 AND aba04 BETWEEN tm.bm AND g_mm
                 AND abapost = 'Y'
                 AND abb03 = aag01 
                 AND aag03 <> '4' 
                 AND aag00=tm.b  
              IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
              IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
              LET amt3_1 = amt3_1 - l_endy1
              LET amt3_2 = amt3_2 - l_endy2
            END IF
         END IF
         IF STATUS THEN CALL cl_err('sel axh:',STATUS,1) EXIT FOREACH END IF
         IF amt1_1 IS NULL THEN LET amt1_1=0 END IF
         IF amt2_1 IS NULL THEN LET amt2_1=0 END IF
         IF amt2_2 IS NULL THEN LET amt2_2=0 END IF
         IF amt3_1 IS NULL THEN LET amt3_1=0 END IF
         IF amt3_2 IS NULL THEN LET amt3_2=0 END IF
         #--- 日餘額
         IF tm.dd IS NOT NULL THEN
            IF maj.maj24 IS NULL THEN
               SELECT SUM(aas04),SUM(aas05),SUM(aas06),SUM(aas07) 
                   INTO l_tmp1,l_tmp2,l_tmp3,l_tmp4
                   FROM aas_file,aag_file WHERE aas00 = tm.b
                    AND aas01 BETWEEN maj.maj21 AND maj.maj22
                    AND aas02 BETWEEN bdate AND edate
                    AND aas01 = aag01 AND aag07 IN ('2','3')
                    AND aag00=tm.b 
            ELSE
               SELECT SUM(abb07) INTO l_tmp1 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='1' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b
                     AND aba19 <> 'X'  #CHI-C80041
               SELECT SUM(abb07) INTO l_tmp2 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='2' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b
                     AND aba19 <> 'X'  #CHI-C80041
               SELECT COUNT(*) INTO l_tmp3 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='1' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b 
                     AND aba19 <> 'X'  #CHI-C80041
               SELECT COUNT(*) INTO l_tmp4 FROM aba_file,abb_file,aag_file
                   WHERE aba00 = abb00 AND aba01 = abb01 AND abb00 = tm.b
                     AND abb03 = aag01 AND aag07 IN ('2','3')
                     AND abb03 BETWEEN maj.maj21 AND maj.maj22 
                     AND abb05 BETWEEN maj.maj24 AND maj.maj25 
                     AND aba02 BETWEEN bdate AND edate AND abb06='2' 
                     AND abaacti = 'Y'  #no.4868
                     AND aag00=tm.b 
                     AND aba19 <> 'X'  #CHI-C80041
            END IF
            IF STATUS THEN CALL cl_err('aas',STATUS,1) EXIT FOREACH END IF
            IF l_tmp1 IS NULL THEN LET l_tmp1 = 0 END IF
            IF l_tmp2 IS NULL THEN LET l_tmp2 = 0 END IF
            IF l_tmp3 IS NULL THEN LET l_tmp3 = 0 END IF
            IF l_tmp4 IS NULL THEN LET l_tmp4 = 0 END IF
            LET amt2_1 = amt2_1 + l_tmp1
            LET amt2_2 = amt2_2 + l_tmp2
            LET amt3_1 = amt3_1 + l_tmp3
            LET amt3_2 = amt3_2 + l_tmp4
         END IF
         IF amt1_1<0 THEN LET amt1_2=amt1_1*-1 LET amt1_1=0 END IF
         #--- 期末  
         LET amt4_1=amt1_1+amt2_1-amt1_2-amt2_2
         IF amt4_1<0 THEN LET amt4_2=amt4_1*-1 LET amt4_1=0 END IF
      END IF
 
      IF tm.o = 'Y' THEN                                  #匯率的轉換
         LET amt1_1 = amt1_1 * tm.q LET amt1_2 = amt1_2 * tm.q
         LET amt2_1 = amt2_1 * tm.q LET amt2_2 = amt2_2 * tm.q
         LET amt4_1 = amt4_1 * tm.q LET amt4_2 = amt4_2 * tm.q
      END IF 
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN #合計階數處理
         FOR i = 1 TO 100
            #CHI-A70050---add---start---
             IF maj.maj09 = '-' THEN
                LET g_tot1_1[i] = g_tot1_1[i] - amt1_1 
                LET g_tot1_2[i] = g_tot1_2[i] - amt1_2 
                LET g_tot2_1[i] = g_tot2_1[i] - amt2_1 
                LET g_tot2_2[i] = g_tot2_2[i] - amt2_2 
                LET g_tot3_1[i] = g_tot3_1[i] - amt3_1 
                LET g_tot3_2[i] = g_tot3_2[i] - amt3_2 
                LET g_tot4_1[i] = g_tot4_1[i] - amt4_1 
                LET g_tot4_2[i] = g_tot4_2[i] - amt4_2 
             ELSE
            #CHI-A70050---add---end---
                LET g_tot1_1[i]=g_tot1_1[i]+amt1_1 
                LET g_tot1_2[i]=g_tot1_2[i]+amt1_2 
                LET g_tot2_1[i]=g_tot2_1[i]+amt2_1 
                LET g_tot2_2[i]=g_tot2_2[i]+amt2_2 
                LET g_tot3_1[i]=g_tot3_1[i]+amt3_1 
                LET g_tot3_2[i]=g_tot3_2[i]+amt3_2 
                LET g_tot4_1[i]=g_tot4_1[i]+amt4_1 
                LET g_tot4_2[i]=g_tot4_2[i]+amt4_2 
             END IF     #CHI-A70050 add
         END FOR
         LET k=maj.maj08  
         LET sr.bal1_1=g_tot1_1[k] LET sr.bal1_2=g_tot1_2[k]
         LET sr.bal2_1=g_tot2_1[k] LET sr.bal2_2=g_tot2_2[k]
         LET sr.bal3_1=g_tot3_1[k] LET sr.bal3_2=g_tot3_2[k]
         LET sr.bal4_1=g_tot4_1[k] LET sr.bal4_2=g_tot4_2[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1_1 = sr.bal1_1 *-1
            LET sr.bal2_1 = sr.bal2_1 *-1
            LET sr.bal3_1 = sr.bal3_1 *-1
            LET sr.bal4_1 = sr.bal4_1 *-1
            LET sr.bal1_2 = sr.bal1_2 *-1
            LET sr.bal2_2 = sr.bal2_2 *-1
            LET sr.bal3_2 = sr.bal3_2 *-1
            LET sr.bal4_2 = sr.bal4_2 *-1
         END IF
        #CHI-A70050---add---end---
         FOR i = 1 TO maj.maj08 
            LET g_tot1_1[i]=0 LET g_tot1_2[i]=0 LET g_tot2_1[i]=0 
            LET g_tot2_2[i]=0 LET g_tot3_1[i]=0 LET g_tot3_2[i]=0 
            LET g_tot4_1[i]=0 LET g_tot4_2[i]=0 
         END FOR
      ELSE 
         LET sr.bal1_1=NULL LET sr.bal1_2=NULL LET sr.bal2_1=NULL 
         LET sr.bal2_2=NULL LET sr.bal3_1=NULL LET sr.bal3_2=NULL
         LET sr.bal4_1=NULL LET sr.bal4_2=NULL
      END IF
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF    #本行不印出
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"                  #CHI-CC0023 add maj03 match 5 
         AND sr.bal1_1=0 AND sr.bal1_2=0 AND sr.bal2_1=0 AND sr.bal2_2=0
         AND sr.bal3_1=0 AND sr.bal3_2=0 AND sr.bal4_1=0 AND sr.bal4_2=0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
 
      IF tm.h = 'Y' THEN
         LET maj.maj20 = maj.maj20e
      END IF
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
      LET sr.bal1_1=sr.bal1_1/g_unit
      LET sr.bal1_2=sr.bal1_2/g_unit
      LET sr.bal2_1=sr.bal2_1/g_unit
      LET sr.bal2_2=sr.bal2_2/g_unit
      LET sr.bal4_1=sr.bal4_1/g_unit
      LET sr.bal4_2=sr.bal4_2/g_unit
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      IF maj.maj04 = 0 THEN 
         EXECUTE insert_prep USING 
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
            sr.bal1_1,sr.bal1_2 ,sr.bal2_1,sr.bal2_2,
            sr.bal3_1,sr.bal3_2 ,sr.bal4_1,sr.bal4_2,
            '2'
      ELSE   
         EXECUTE insert_prep USING 
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,
            sr.bal1_1,sr.bal1_2 ,sr.bal2_1,sr.bal2_2,
            sr.bal3_1,sr.bal3_2 ,sr.bal4_1,sr.bal4_2,
            '2'
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            EXECUTE insert_prep USING 
               maj.maj20,maj.maj20e,maj.maj02,'',
               '0','0','0','0',
               '0','0','0','0',
               '1'
         END FOR
      END IF
   END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   #報表名稱是否以報表結構名稱列印
   IF g_aaz.aaz77 = 'N' THEN LET g_mai02 = '' END IF
   IF tm.dd IS NULL THEN LET tm.dd=' ' END IF
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.d,";",tm.yy,";",tm.bm,";",
###GENGRE###               tm.em,";",tm.dd,";",tm.e
###GENGRE###   CALL cl_prt_cs3('aglg116','aglg116',g_sql,g_str)
    CALL aglg116_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION

#FUN-A90032 --Begin
FUNCTION g116_set_entry()                                                                                                           
   CALL cl_set_comp_entry("q1,em,h1",TRUE)
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION g116_set_no_entry()                                                                                                        
   IF tm.axa06 ="1" THEN
      CALL cl_set_comp_entry("q1,h1",FALSE)
   END IF
   IF tm.axa06 ="2" THEN
      CALL cl_set_comp_entry("em,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN
      CALL cl_set_comp_entry("em,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN
      CALL cl_set_comp_entry("q1,em,h1",FALSE)
   END IF
END FUNCTION
#FUN-A90032 --End
#No.FUN-7A0035 

###GENGRE###START
FUNCTION aglg116_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg116")
        IF handler IS NOT NULL THEN
            START REPORT aglg116_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY maj02,line"
          
            DECLARE aglg116_datacur1 CURSOR FROM l_sql
            FOREACH aglg116_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg116_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg116_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg116_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50158------add----str-----
    DEFINE l_bal4c        LIKE axh_file.axh08
    DEFINE l_bal4d        LIKE axh_file.axh08
    DEFINE l_period1      STRING
    DEFINE l_period2      STRING
    DEFINE l_unit         STRING    
    DEFINE l_bal1_1_fmt   STRING
    DEFINE l_bal1_2_fmt   STRING
    DEFINE l_bal2_1_fmt   STRING
    DEFINE l_bal2_2_fmt   STRING
    DEFINE l_em           STRING
    DEFINE l_bm           STRING
    DEFINE l_dd           STRING
    #FUN-B50158------end----str-----

    
    ORDER EXTERNAL BY sr1.maj02,sr1.line
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B50158------add----str-----
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit

            LET l_bm = tm.bm
            LET l_bm = l_bm.trim()
            IF cl_null(tm.dd) THEN
               IF tm.bm < 10 THEN
                  LET l_period1 = tm.yy,"/0",l_bm
               ELSE
                  LET l_period1 = tm.yy,'/',l_bm
               END IF
            ELSE
               IF tm.bm < 10 THEN
                  LET l_period1 = tm.yy,"/0",tm.bm,"/01"
               ELSE
                  LET l_period1 = tm.yy,'/',tm.bm,"/01"
               END IF
            END IF
            LET l_period1 = l_period1.trim()
            PRINTX l_period1

            LET l_em = tm.em
            LET l_em = l_em.trim()
            LET l_dd = tm.dd
            LET l_dd = l_dd.trim()
            IF cl_null(tm.dd) THEN
               IF tm.em < 10 THEN
                  LET l_period2 = tm.yy,"/0",l_em
               ELSE
                  LET l_period2 = tm.yy,'/',l_em
               END IF
            ELSE
               IF tm.em < 10 THEN
                  IF tm.dd < 10 THEN
                     LET l_period2 = tm.yy,"/0",l_em,"/0",l_dd
                  ELSE
                     LET l_period2 = tm.yy,"/0",l_em,"/",l_dd
                  END IF
               ELSE
                  IF tm.dd < 10 THEN
                     LET l_period2 = tm.yy,"/",l_em,"/0",l_dd
                  ELSE
                     LET l_period2 = tm.yy,"/",l_em,"/",l_dd
                  END IF
               END IF
            END IF
            LET l_period2 = l_period2.trim()
            PRINTX l_period2
            #FUN-B50158------end----str-----
              
        BEFORE GROUP OF sr1.maj02
        BEFORE GROUP OF sr1.line

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B50158------add----str-----
            IF (sr1.bal4_2 - sr1.bal4_1) > 0 THEN
               LET l_bal4c = sr1.bal4_2 - sr1.bal4_1
            ELSE
               LET l_bal4c = 0 
            END IF
            PRINTX l_bal4c

            IF (sr1.bal4_1 - sr1.bal4_2) > 0 THEN
               LET l_bal4d = sr1.bal4_1 - sr1.bal4_2
            ELSE
               LET l_bal4d = 0
            END IF
            PRINTX l_bal4d

            LET l_bal1_1_fmt = cl_gr_numfmt("axh_file","axh08",tm.e)
            PRINTX l_bal1_1_fmt
            LET l_bal1_2_fmt = cl_gr_numfmt("axh_file","axh08",tm.e)
            PRINTX l_bal1_2_fmt
            LET l_bal2_1_fmt = cl_gr_numfmt("axh_file","axh08",tm.e)
            PRINTX l_bal2_1_fmt
            LET l_bal2_2_fmt = cl_gr_numfmt("axh_file","axh08",tm.e)
            PRINTX l_bal2_2_fmt
            #FUN-B50158------end----str-----

            PRINTX sr1.*

        AFTER GROUP OF sr1.maj02
        AFTER GROUP OF sr1.line

        
        ON LAST ROW

END REPORT
###GENGRE###END

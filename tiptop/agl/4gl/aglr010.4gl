# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: aglr010.4gl
# Descriptions...: 合并后財務比率分析表
# Date & Author..: No.FUN-9A0036 By vealxu  
# Modify.........: No.FUN-A30122 10/08/25 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No.MOD-AB0186 10/11/19 By Dido 貸餘科目應呈現正數,在計算上再 * -1
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: No.FUN-AB0091 11/01/26 By vealxu 選半年報時,計算期別寫法錯誤
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.MOD-C30048 12/03/06 By Polly axa02的帳別不一定為合併帳別，因此將axh03改抓回tm.axa03值
# Modify.........: No.MOD-C30895 12/04/02 By Polly 1.取消重復減1的動作 2.依axa06的值抓取起初日期
# Modify.........: No.MOD-C80102 12/08/14 By Polly 調整營業利益=(23類*-1)+(24類*-1)-25類-26類-27類

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
DEFINE tm  RECORD                      # Print condition RECORD
           axa01 LIKE axa_file.axa01,  #族群代號
           axa02 LIKE axa_file.axa02,  #上層公司編號
           axa06 LIKE axa_file.axa06,  #FUN-A90032
           axa03 LIKE axa_file.axa03,  #帳別
           b     LIKE aaz_file.aaz641, #合并帳別 
           s1    LIKE type_file.num5,  #來源方式     
           s2    LIKE type_file.num5,  #來源方式    
           s3    LIKE type_file.num5,  #來源方式   
           s4    LIKE type_file.num5,  #來源方式  
           s5    LIKE type_file.num5,  #來源方式 
           n1    LIKE zaa_file.zaa08,  #來源方式名稱 
           n2    LIKE zaa_file.zaa08,  #來源方式名稱
           n3    LIKE zaa_file.zaa08,  #來源方式名稱 
           n4    LIKE zaa_file.zaa08,  #來源方式名稱
           n5    LIKE zaa_file.zaa08,  #來源方式名稱 
           yy1   LIKE axh_file.axh06,  #第一期輸入年度
           yy2   LIKE axh_file.axh06,  #第二期輸入年度
           yy3   LIKE axh_file.axh06,  #第三期輸入年度
           yy4   LIKE axh_file.axh06,  #第四期輸入年度
           yy5   LIKE axh_file.axh06,  #第五期輸入年度
           m1    LIKE axh_file.axh07,  #第一期本期起始期別
           m4    LIKE axh_file.axh07,  #第一期本期截止期別
           m2    LIKE axh_file.axh07,  #第二期起始期別
           m5    LIKE axh_file.axh07,  #第二期截止期別
           m3    LIKE axh_file.axh07,  #第三期起始期別
           m6    LIKE axh_file.axh07,  #第三期截止期別
           m7    LIKE axh_file.axh07,  #第四期起始期別
           m9    LIKE axh_file.axh07,  #第四期截止期別
           m8    LIKE axh_file.axh07,  #第五期起始期別
           m10   LIKE axh_file.axh07,  #第五期截止期別
           q1    LIKE type_file.chr1,  #FUN-A90032
           q2    LIKE type_file.chr1,  #FUN-A90032
           q3    LIKE type_file.chr1,  #FUN-A90032
           q4    LIKE type_file.chr1,  #FUN-A90032
           h1    LIKE type_file.chr1,  #FUN-A90032
           h2    LIKE type_file.chr1,  #FUN-A90032
           h3    LIKE type_file.chr1,  #FUN-A90032
           h4    LIKE type_file.chr1,  #FUN-A90032
           a     LIKE type_file.chr1,  #銷貨淨額與銷貨成本依平均存貨方式計算   
           more  LIKE type_file.chr1   #Input more condition(Y/N)
           END RECORD,
       g_tot     ARRAY[5,37] OF LIKE axh_file.axh08,  #合計     
       g_tot_b   ARRAY[5,37] OF LIKE axh_file.axh08,  #上期合計
       g_eff     ARRAY[5] OF LIKE axh_file.axh08      #合計
DEFINE g_cnt     LIKE type_file.num10  
DEFINE g_i       LIKE type_file.num5   #count/index for any purpose 
DEFINE g_sql     STRING               
DEFINE g_str     STRING              
DEFINE l_table   STRING             
DEFINE x_aaa03   LIKE axz_file.axz06
DEFINE g_axz03   LIKE axz_file.axz03
DEFINE g_dbs_axz03 STRING
DEFINE g_plant_axz03 LIKE type_file.chr21   #FUN-A30122 add
DEFINE g_axa09   LIKE axa_file.axa09
DEFINE g_aaz641  LIKE aaz_file.aaz641
DEFINE g_bookno  LIKE axa_file.axa03 
DEFINE g_axa05   LIKE axa_file.axa05 #FUN-A90032

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_sql = "title.ze_file.ze03,     msg01.ze_file.ze03,",
               "msg02.ze_file.ze03,     msg03.ze_file.ze03,",
               "num01.type_file.num20_6,num02.type_file.num20_6,", 
               "tot01.type_file.num20_6,tot02.type_file.num20_6,",
               "tot03.type_file.num20_6,tot04.type_file.num20_6,",
               "tot05.type_file.num20_6,unit.type_file.chr5,",   
               "sort.type_file.num5,    sort2.type_file.num5,",
               "azi04.azi_file.azi04"   
   LET l_table = cl_prt_temptable('aglr010',g_sql) CLIPPED    
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF 

   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   #--FUN-A90032 start----------
   LET tm.axa01 = ARG_VAL(8)
   LET tm.axa02 = ARG_VAL(9)
   LET tm.axa06 = ARG_VAL(10)
   LET tm.axa03 = ARG_VAL(11)
   LET tm.b = ARG_VAL(12)
   LET tm.yy1 = ARG_VAL(13)
   LET tm.m4 = ARG_VAL(14)
   LET tm.q1 = ARG_VAL(15)
   LET tm.h1 = ARG_VAL(16)
   LET tm.yy2 = ARG_VAL(17)
   LET tm.m5 = ARG_VAL(18)
   LET tm.q2 = ARG_VAL(19)
   LET tm.h2 = ARG_VAL(20)
   LET tm.yy3 = ARG_VAL(21)
   LET tm.m6 = ARG_VAL(22)
   LET tm.q3 = ARG_VAL(23)
   LET tm.h3 = ARG_VAL(24)
   LET tm.yy4 = ARG_VAL(25)
   LET tm.m7 = ARG_VAL(26)
   LET tm.q4 = ARG_VAL(27)
   LET tm.h4 = ARG_VAL(28)
   LET tm.a = ARG_VAL(29)
   LET g_rep_user = ARG_VAL(30)
   LET g_rep_clas = ARG_VAL(31)
   LET g_template = ARG_VAL(32)
   LET g_rpt_name = ARG_VAL(33)
#--FUN-A90032 end--------------
#--FUN-A90032 mark---
#   LET tm.s1    = ARG_VAL(8)
#   LET tm.s2    = ARG_VAL(9)
#   LET tm.s3    = ARG_VAL(10)
#   LET tm.s4    = ARG_VAL(11)
#   LET tm.s5    = ARG_VAL(12)
#   LET tm.n1    = ARG_VAL(13)
#   LET tm.n2    = ARG_VAL(14)
#   LET tm.n3    = ARG_VAL(15)
#   LET tm.n4    = ARG_VAL(16)
#   LET tm.n5    = ARG_VAL(17)
#   LET tm.yy1   = ARG_VAL(18)
#   LET tm.yy2   = ARG_VAL(19)
#   LET tm.yy3   = ARG_VAL(20)
#   LET tm.yy4   = ARG_VAL(21)
#   LET tm.yy5   = ARG_VAL(22)
#   LET tm.m1    = ARG_VAL(23)
#   LET tm.m2    = ARG_VAL(24)
#   LET tm.m3    = ARG_VAL(25)
#   LET tm.m7    = ARG_VAL(26)
#   LET tm.m8    = ARG_VAL(27)
#   LET tm.m4    = ARG_VAL(28)
#   LET tm.m5    = ARG_VAL(29)
#   LET tm.m6    = ARG_VAL(30)
#   LET tm.m9    = ARG_VAL(31)
#   LET tm.m10   = ARG_VAL(32)
#   LET tm.a     = ARG_VAL(33)   
#   LET g_rep_user = ARG_VAL(34)
#   LET g_rep_clas = ARG_VAL(35)
#   LET g_template = ARG_VAL(36)
#   LET g_rpt_name = ARG_VAL(37)
#--FUN-A90032 mark-------------   
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL aglr010_tm()                    # Input print condition
      ELSE CALL aglr010()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION aglr010_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,     
          l_sw          LIKE type_file.chr1,          #重要欄位是否空白 
          l_cnt         LIKE type_file.num5,
          l_cmd         LIKE type_file.chr1000  
   DEFINE l_aznn01_1    LIKE aznn_file.aznn01         #FUN-A90032
   DEFINE l_aznn01_2    LIKE aznn_file.aznn01         #FUN-A90032
   DEFINE l_aznn01_3    LIKE aznn_file.aznn01         #FUN-A90032
   DEFINE l_aznn01_4    LIKE aznn_file.aznn01         #FUN-A90032
   DEFINE l_aaa05       LIKE aaa_file.aaa05           #FUN-A90032       
   DEFINE l_axz03       LIKE axz_file.axz03           #FUN-AB0091

   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 5
   END IF

   OPEN WINDOW aglr010_w AT p_row,p_col WITH FORM "agl/42f/aglr010"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition

   LET tm.a    = 'N'  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET l_sw    = 1
WHILE TRUE
#FUN-A90032 --Begin 
#  INPUT BY NAME tm.axa01,tm.axa02,tm.axa03,tm.b,
#                tm.s1,tm.n1,tm.yy1,tm.m1,tm.m4,
#                tm.s2,tm.n2,tm.yy2,tm.m2,tm.m5,
#                tm.s3,tm.n3,tm.yy3,tm.m3,tm.m6,
#                tm.s4,tm.n4,tm.yy4,tm.m7,tm.m9,
#                tm.s5,tm.n5,tm.yy5,tm.m8,tm.m10,
#                tm.a,tm.more WITHOUT DEFAULTS    
   INPUT BY NAME tm.axa01,tm.axa02,tm.axa03,tm.b,
                 tm.yy1,tm.m4,tm.q1,tm.h1,
                 tm.yy2,tm.m5,tm.q2,tm.h2,
                 tm.yy3,tm.m6,tm.q3,tm.h3,
                 tm.yy4,tm.m9,tm.q4,tm.h4,
                 tm.a,tm.more WITHOUT DEFAULTS    
#FUN-A90032 --End
       BEFORE INPUT
          CALL cl_qbe_init()

       ON ACTION locale
          CALL cl_show_fld_cont()             
          LET g_action_choice = "locale"
          EXIT INPUT

       AFTER FIELD axa01
          IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
          SELECT COUNT(*) INTO l_cnt FROM axa_file
           WHERE axa01=tm.axa01
          IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
          IF l_cnt <=0  THEN
             CALL cl_err(tm.axa01,'agl-223',0) 
             NEXT FIELD axa01
          END IF
#FUN-A90032 --Begin
          LET tm.axa06 = '2'
          SELECT axa05,axa06 
            INTO g_axa05,tm.axa06
           FROM axa_file
          WHERE axa01 = tm.axa01
            AND axa04 = 'Y'
          DISPLAY BY NAME tm.axa06
          CALL r010_set_entry()
          CALL r010_set_no_entry()
          IF tm.axa06 = '1' THEN
              LET tm.q1 = '' 
              LET tm.h1 = '' 
              LET tm.q2 = '' 
              LET tm.h2 = '' 
              LET tm.q3 = '' 
              LET tm.h3 = '' 
              LET tm.q4 = '' 
              LET tm.h4 = '' 
              LET l_aaa05 = 0
              SELECT aaa05 INTO l_aaa05 FROM aaa_file 
               WHERE aaa01=tm.b 
#                AND aaaacti MATCHES '[Yy]'     #No.TQC-B30100 Mark
                 AND aaaacti IN ('Y','y')       #No.TQC-B30100 add 
              LET tm.m4 = l_aaa05
              LET tm.m5 = l_aaa05
              LET tm.m6 = l_aaa05
              LET tm.m9 = l_aaa05
          END IF
          IF tm.axa06 = '2' THEN
              LET tm.h1 = '' 
              LET tm.m4 = '' 
              LET tm.h2 = '' 
              LET tm.m5 = '' 
              LET tm.h3 = '' 
              LET tm.m6 = '' 
              LET tm.h4 = '' 
              LET tm.m9 = '' 
          END IF
          IF tm.axa06 = '3' THEN
              LET tm.m4 = '' 
              LET tm.q1 = ''
              LET tm.m4 = '' 
              LET tm.q1 = ''
          END IF
          IF tm.axa06 = '4' THEN
              LET tm.m4 = '' 
              LET tm.q1 = ''
              let tm.h1 = ''
              LET tm.m5 = '' 
              LET tm.q2 = ''
              let tm.h2 = ''
              LET tm.m6 = '' 
              LET tm.q3 = ''
              let tm.h3 = ''
              LET tm.m9 = '' 
              LET tm.q4 = ''
              let tm.h4 = ''
          END IF
          DISPLAY BY NAME tm.m4
          DISPLAY BY NAME tm.q1
          DISPLAY BY NAME tm.h1
          DISPLAY BY NAME tm.m5
          DISPLAY BY NAME tm.q2
          DISPLAY BY NAME tm.h2
          DISPLAY BY NAME tm.m6
          DISPLAY BY NAME tm.q3
          DISPLAY BY NAME tm.h3
          DISPLAY BY NAME tm.m9
          DISPLAY BY NAME tm.q4
          DISPLAY BY NAME tm.h4

         AFTER FIELD q1    #﹗
         IF tm.axa06  = '2' THEN
            IF NOT cl_null(tm.yy1) THEN 
                IF cl_null(tm.q1) THEN
                    NEXT FIELD q1
                END IF
            END IF
         END IF
         CASE tm.q1
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n1
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n1
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n1
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n1
            OTHERWISE LET tm.n1 = ' '
         END CASE
      AFTER FIELD q2
         IF tm.axa06  = '2' THEN
            IF NOT cl_null(tm.yy2) THEN 
                IF cl_null(tm.q2) THEN
                    NEXT FIELD q2
                END IF
            END IF
         END IF
         CASE tm.q2
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n2
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n2
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n2
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n2
            OTHERWISE LET tm.n2 = ' '
         END CASE

      AFTER FIELD q3
         IF tm.axa06  = '2' THEN
            IF NOT cl_null(tm.yy3) THEN 
                IF cl_null(tm.q3) THEN
                    NEXT FIELD q3
                END IF
            END IF
         END IF
         CASE tm.q3
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n3
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n3
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n3
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n3
            OTHERWISE LET tm.n3 = ' '
         END CASE

      AFTER FIELD q4
         IF tm.axa06  = '2' THEN
            IF NOT cl_null(tm.yy4) THEN 
                IF cl_null(tm.q4) THEN
                    NEXT FIELD q4
                END IF
            END IF
         END IF
         CASE tm.q4
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n4
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n4
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n4
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n4
            OTHERWISE LET tm.n4 = ' '
         END CASE

         AFTER FIELD h1
            IF tm.axa06 = '3' THEN
                IF NOT cl_null(tm.yy1) THEN
                    IF cl_null(tm.h1) THEN
                        NEXT FIELD h1 
                    END IF
                END IF
            END IF
            CASE tm.h1
               WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n1
               WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n1
               OTHERWISE LET tm.n1 = ' '
            END CASE

         AFTER FIELD h2
            IF tm.axa06 = '3' THEN
                IF NOT cl_null(tm.yy2) THEN
                    IF cl_null(tm.h2) THEN
                        NEXT FIELD h2 
                    END IF
                END IF
            END IF
            CASE tm.h2
               WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n2
               WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n2
               OTHERWISE LET tm.n2 = ' '
            END CASE

         AFTER FIELD h3
            IF tm.axa06 = '3' THEN
                IF NOT cl_null(tm.yy3) THEN
                    IF cl_null(tm.h3) THEN
                        NEXT FIELD h3 
                    END IF
                END IF
            END IF
            CASE tm.h3
               WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n3
               WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n3
               OTHERWISE LET tm.n3 = ' '
            END CASE

         AFTER FIELD h4
            IF tm.axa06 = '3' THEN
                IF NOT cl_null(tm.yy4) THEN
                    IF cl_null(tm.h4) THEN
                        NEXT FIELD h4 
                    END IF
                END IF
            END IF
            CASE tm.h4
               WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n4
               WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n4
               OTHERWISE LET tm.n4 = ' '
            END CASE
#FUN-A90032 --End          

       AFTER FIELD axa02
          IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
          SELECT COUNT(*) INTO l_cnt FROM axa_file
           WHERE axa01=tm.axa01 AND axa02=tm.axa02
          IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
          IF l_cnt <=0  THEN
             CALL cl_err(tm.axa02,'agl-223',0)
             NEXT FIELD axa02
          ELSE
             SELECT axa03 INTO tm.axa03 FROM axa_file
              WHERE axa01=tm.axa01 AND axa02=tm.axa02
             DISPLAY BY NAME tm.axa03
          END IF
        # CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03   #FUN-A30122 mark
        # CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641            #FUN-A30122 mark
          CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03  #FUN-A30122 add
          CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641           #FUN-A30122 add
          IF cl_null(g_aaz641) THEN
             CALL cl_err(g_axz03,'agl-601',1)
             NEXT FIELD axa02
          ELSE
             LET tm.b = g_aaz641
             DISPLAY BY NAME tm.b
          END IF
          SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02
          
#FUN-A90032 --Begin mark                                                                             
#       AFTER FIELD s1
#          IF tm.s1 IS NULL OR tm.s1 <1 OR tm.s1 > 14 THEN NEXT FIELD s1 END IF
#          CASE tm.s1
#               WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n1
#               WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n1
#               WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n1
#               WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n1
#               WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n1
#               WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n1
#               WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n1
#               WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n1
#               WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n1
#               WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n1
#               WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n1
#               WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n1
#               WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n1
#               WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n1
#               OTHERWISE LET tm.n1 = ' '
#          END CASE
#          DISPLAY BY NAME tm.n1
#
#       AFTER FIELD s2
#          IF tm.s2 <1 OR tm.s2 > 14 THEN NEXT FIELD s2 END IF
#          CASE tm.s2
#               WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n2
#               WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n2
#               WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n2
#               WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n2
#               WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n2
#               WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n2
#               WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n2
#               WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n2
#               WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n2
#               WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n2
#               WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n2
#               WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n2
#               WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n2
#               WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n2
#               OTHERWISE LET tm.n2 = ' '
#          END CASE
#          DISPLAY BY NAME tm.n2
#
#       AFTER FIELD s3
#          IF tm.s3 <1 OR tm.s3 > 14 THEN NEXT FIELD s3 END IF
#          CASE tm.s3
#               WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n3
#               WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n3
#               WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n3
#               WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n3
#               WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n3
#               WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n3
#               WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n3
#               WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n3
#               WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n3
#               WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n3
#               WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n3
#               WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n3
#               WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n3
#               WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n3
#               OTHERWISE LET tm.n3 = ' '
#          END CASE
#          DISPLAY BY NAME tm.n3
#
#       AFTER FIELD s4
#          IF tm.s4 <1 OR tm.s4 > 14 THEN NEXT FIELD s4 END IF
#          CASE tm.s4
#               WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n4
#               WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n4
#               WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n4
#               WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n4
#               WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n4
#               WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n4
#               WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n4
#               WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n4
#               WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n4
#               WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n4
#               WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n4
#               WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n4
#               WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n4
#               WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n4
#               OTHERWISE LET tm.n4 = ' '
#          END CASE
#          DISPLAY BY NAME tm.n4
#
#       AFTER FIELD s5
#          IF tm.s5 <1 OR tm.s5 > 14 THEN NEXT FIELD s5 END IF
#          CASE tm.s5
#               WHEN 1  CALL cl_getmsg('agl-071',g_lang) RETURNING tm.n5
#               WHEN 2  CALL cl_getmsg('agl-072',g_lang) RETURNING tm.n5
#               WHEN 3  CALL cl_getmsg('agl-073',g_lang) RETURNING tm.n5
#               WHEN 4  CALL cl_getmsg('agl-074',g_lang) RETURNING tm.n5
#               WHEN 5  CALL cl_getmsg('agl-075',g_lang) RETURNING tm.n5
#               WHEN 6  CALL cl_getmsg('agl-076',g_lang) RETURNING tm.n5
#               WHEN 7  CALL cl_getmsg('agl-077',g_lang) RETURNING tm.n5
#               WHEN 8  CALL cl_getmsg('agl-078',g_lang) RETURNING tm.n5
#               WHEN 9  CALL cl_getmsg('agl-079',g_lang) RETURNING tm.n5
#               WHEN 10 CALL cl_getmsg('agl-080',g_lang) RETURNING tm.n5
#               WHEN 11 CALL cl_getmsg('agl-081',g_lang) RETURNING tm.n5
#               WHEN 12 CALL cl_getmsg('agl-082',g_lang) RETURNING tm.n5
#               WHEN 13 CALL cl_getmsg('agl-083',g_lang) RETURNING tm.n5
#               WHEN 14 CALL cl_getmsg('agl-084',g_lang) RETURNING tm.n5
#               OTHERWISE LET tm.n5 = ' '
#          END CASE
#          DISPLAY BY NAME tm.n5
#
#       AFTER FIELD n1
#          IF cl_null(tm.n1) THEN
#             NEXT FIELD n1
#          END IF
#FUN-A90032 --End mark

       AFTER FIELD yy1
          IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
             NEXT FIELD yy1
          END IF

#FUN-A90032 --Begin
#       AFTER FIELD m1
#          IF NOT cl_null(tm.m1) THEN
#             SELECT azm02 INTO g_azm.azm02 FROM azm_file
#               WHERE azm01 = tm.yy1
#             IF g_azm.azm02 = 1 THEN
#                IF tm.m1 > 12 OR tm.m1 < 1 THEN
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD m1
#                END IF
#             ELSE
#                IF tm.m1 > 13 OR tm.m1 < 1 THEN
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD m1
#                END IF
#             END IF
#          END IF
#          IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
#
#       AFTER FIELD m2
#          IF NOT cl_null(tm.m2) THEN
#             SELECT azm02 INTO g_azm.azm02 FROM azm_file
#               WHERE azm01 = tm.yy1
#             IF g_azm.azm02 = 1 THEN
#                IF tm.m2 > 12 OR tm.m2 < 1 THEN
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD m2
#                END IF
#             ELSE
#                IF tm.m2 > 13 OR tm.m2 < 1 THEN
#                   CALL cl_err('','agl-020',0)
#                   NEXT FIELD m2
#                END IF
#             END IF
#          END IF
#          IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
#
#       AFTER FIELD m3
#          IF tm.m3 IS NOT NULL AND (tm.m3 <1 OR tm.m3 > 13) THEN
#             CALL cl_err('','agl-013',0)
#             NEXT FIELD m3
#          END IF
#
#       AFTER FIELD m7
#          IF tm.m7 IS NOT NULL AND (tm.m7 <1 OR tm.m7 > 13) THEN
#             CALL cl_err('','agl-013',0)
#             NEXT FIELD m7
#          END IF
#
#       AFTER FIELD m8
#          IF tm.m8 IS NOT NULL AND (tm.m8 <1 OR tm.m8 > 13) THEN
#             CALL cl_err('','agl-013',0)
#             NEXT FIELD m8
#          END IF
#FUN-A90032 --End

       AFTER FIELD m4
          IF tm.m4 IS NOT NULL AND (tm.m4 <1 OR tm.m4 > 13) THEN
             CALL cl_err('','agl-013',0)
             NEXT FIELD m4
          END IF

       AFTER FIELD m5
          IF tm.m5 IS NOT NULL AND (tm.m5 <1 OR tm.m5 > 13) THEN
             CALL cl_err('','agl-013',0)
             NEXT FIELD m5
          END IF

       AFTER FIELD m6
          IF tm.m6 IS NOT NULL AND (tm.m6 <1 OR tm.m6 > 13) THEN
             CALL cl_err('','agl-013',0)
             NEXT FIELD m6
          END IF

       AFTER FIELD m9
          IF tm.m9 IS NOT NULL AND (tm.m9 <1 OR tm.m9 > 13) THEN
             CALL cl_err('','agl-013',0)
             NEXT FIELD m9
          END IF
          
#FUN-A90032 --Begin
#       AFTER FIELD m10
#          IF tm.m10 IS NOT NULL AND (tm.m10 <1 OR tm.m10 > 13) THEN
#             CALL cl_err('','agl-013',0)
#             NEXT FIELD m10
#          END IF
#FUN-A90032 --End          

       AFTER FIELD a
          IF tm.a IS NULL OR tm.a NOT MATCHES '[YN]' THEN
             NEXT FIELD a
          END IF

       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF

       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
#--FUN-A90032 mark          
#          IF tm.s1 IS NULL THEN
#             LET l_sw = 0
#             DISPLAY BY NAME tm.s1
#             CALL cl_err('',9033,0)
#          END IF
#--FUN-A90032 mark          
          IF tm.yy1 IS NULL THEN
             LET l_sw = 0
             DISPLAY BY NAME tm.yy1
             CALL cl_err('',9033,0)
          END IF
#FUN-A90032 --Begin          
#          IF tm.m1 IS NULL THEN
#             LET l_sw = 0
#             DISPLAY BY NAME tm.m1
#             CALL cl_err('',9033,0)
#          END IF
#          IF tm.m4 IS NULL THEN
#             LET l_sw = 0
#             DISPLAY BY NAME tm.m4
#             CALL cl_err('',9033,0)
#          END IF
#FUN-A90032 --End          
          IF l_sw = 0 THEN
             LET l_sw = 1
             NEXT FIELD s1
             CALL cl_err('',9033,0)
          END IF
          #FUN-AB0091 ----------add start-------
          IF NOT cl_null(tm.axa06) THEN
             CASE
                WHEN tm.axa06 = '1'  #月
                     LET tm.m1 = 0
                     LET tm.m2 = 0
                     LET tm.m3 = 0
                     LET tm.m7 = 0 
                OTHERWISE
                   CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03
                   CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy1,tm.q1,tm.h1) RETURNING tm.m4
                   CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy2,tm.q2,tm.h2) RETURNING tm.m5
                   CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy3,tm.q3,tm.h3) RETURNING tm.m6
                   CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy4,tm.q4,tm.h4) RETURNING tm.m9   
             END CASE
          END IF 
          #FUN-AB0091 ----------add end----------           

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()        # Command execution

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

       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axa01) OR INFIELD(axa02)         
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_axa'
                LET g_qryparam.default1 = tm.axa01
                LET g_qryparam.default2 = tm.axa02
                LET g_qryparam.default3 = tm.axa03
                CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                DISPLAY BY NAME tm.axa01
                DISPLAY BY NAME tm.axa02
                DISPLAY BY NAME tm.axa03
                NEXT FIELD axa01
          END CASE

   END INPUT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr010_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr010'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr010','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                     " '",g_bookno CLIPPED,"'",
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_rlang CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.axa01 CLIPPED,"'",  
                     " '",tm.axa02 CLIPPED,"'",  
                     " '",tm.axa06 CLIPPED,"'",  
                     " '",tm.axa03 CLIPPED,"'",  
                     " '",tm.b CLIPPED,"'",  
                     " '",tm.yy1 CLIPPED,"'",  
                     " '",tm.m4 CLIPPED,"'",  
                     " '",tm.q1 CLIPPED,"'",  
                     " '",tm.h1 CLIPPED,"'",  
                     " '",tm.yy2 CLIPPED,"'",  
                     " '",tm.m5 CLIPPED,"'",  
                     " '",tm.q2 CLIPPED,"'",  
                     " '",tm.h2 CLIPPED,"'",  
                     " '",tm.yy3 CLIPPED,"'",  
                     " '",tm.m6 CLIPPED,"'",  
                     " '",tm.q3 CLIPPED,"'",  
                     " '",tm.h3 CLIPPED,"'",  
                     " '",tm.yy4 CLIPPED,"'",  
                     " '",tm.m7 CLIPPED,"'",  
                     " '",tm.q4 CLIPPED,"'",  
                     " '",tm.h4 CLIPPED,"'",  
                     #---FUN-A90036 end------
#-------------------FUN-A90032 mark------------------
#                     " '",tm.s1 CLIPPED,"'",
#                     " '",tm.s2 CLIPPED,"'",
#                     " '",tm.s3 CLIPPED,"'",
#                     " '",tm.s4 CLIPPED,"'",
#                     " '",tm.s5 CLIPPED,"'",
#                     " '",tm.n1 CLIPPED,"'",
#                     " '",tm.n2 CLIPPED,"'",
#                     " '",tm.n3 CLIPPED,"'",
#                     " '",tm.n4 CLIPPED,"'",
#                     " '",tm.n5 CLIPPED,"'",
#                     " '",tm.yy1 CLIPPED,"'",
#                     " '",tm.yy2 CLIPPED,"'",
#                     " '",tm.yy3 CLIPPED,"'",
#                     " '",tm.yy4 CLIPPED,"'",
#                     " '",tm.yy5 CLIPPED,"'",
#                     " '",tm.m1 CLIPPED,"'",
#                     " '",tm.m2 CLIPPED,"'",
#                     " '",tm.m3 CLIPPED,"'",
#                     " '",tm.m7 CLIPPED,"'",
##                    " '",tm.m8 CLIPPED,"'", #FUN-A90032
#                     " '",tm.m4 CLIPPED,"'",
#                     " '",tm.m5 CLIPPED,"'",
#                     " '",tm.m6 CLIPPED,"'",
#                     " '",tm.m9 CLIPPED,"'",
##                    " '",tm.m10 CLIPPED,"'",#FUN-A90032
#---------------------FUN-A90032 mark----------------
                     " '",tm.a CLIPPED,"'",   
                     " '",g_rep_user CLIPPED,"'",          
                     " '",g_rep_clas CLIPPED,"'",         
                     " '",g_template CLIPPED,"'",        
                     " '",g_rpt_name CLIPPED,"'"     
         CALL cl_cmdat('aglr010',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr010_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr010()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr010_w
END FUNCTION

FUNCTION aglr010()
   DEFINE l_name        LIKE type_file.chr20,             # External(Disk) file name    
          l_sql         LIKE type_file.chr1000,           # RDSQL STATEMENT        
          l_yy          ARRAY[5] OF LIKE type_file.num5,  #年度   
          l_bm          ARRAY[5] OF LIKE type_file.num5,  #起始期別
          l_em          ARRAY[5] OF LIKE type_file.num5,  #截止期別
          l_tot         LIKE axh_file.axh08,              #合計
          l_aag06       LIKE aag_file.aag06,              #借貸別
          l_aag19       LIKE aag_file.aag19,              #財務比率分析類別
          l_yyb,l_yy1,l_bm1         LIKE type_file.num5, 
          l_chr         LIKE type_file.chr1,            
          l_za05        LIKE za_file.za05              

   CALL cl_del_data(l_table)                           

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang

   FOR g_i = 1 to 37   
       LET g_tot[1,g_i]   = 0 LET g_tot[2,g_i]   = 0 LET g_tot[3,g_i]   = 0
       LET g_tot[4,g_i]   = 0 LET g_tot[5,g_i]   = 0
       LET g_tot_b[1,g_i] = 0 LET g_tot_b[2,g_i] = 0 LET g_tot_b[3,g_i] = 0
       LET g_tot_b[4,g_i] = 0 LET g_tot_b[5,g_i] = 0
       IF g_i <= 5 THEN
          LET g_eff[g_i] = 0
       END IF
   END FOR
   LET g_pageno = 0
   LET g_cnt    = 1
#---FUN-A90032 mark---
   #LET l_yy[1]  = tm.yy1 LET l_bm[1] = tm.m1 LET l_em[1]= tm.m4
   #LET l_yy[2]  = tm.yy2 LET l_bm[2] = tm.m2 LET l_em[2]= tm.m5
   #LET l_yy[3]  = tm.yy3 LET l_bm[3] = tm.m3 LET l_em[3]= tm.m6
   #LET l_yy[4]  = tm.yy4 LET l_bm[4] = tm.m7 LET l_em[4]= tm.m9
   #LET l_yy[5]  = tm.yy5 LET l_bm[5] = tm.m8 LET l_em[5]= tm.m10 
#--FUN-A90032 mark--
#--FUN-A90032 start--
   LET l_yy[1]  = tm.yy1 LET l_bm[1] = 0 LET l_em[1]= tm.m4
   LET l_yy[2]  = tm.yy2 LET l_bm[2] = 0 LET l_em[2]= tm.m5
   LET l_yy[3]  = tm.yy3 LET l_bm[3] = 0 LET l_em[3]= tm.m6
   LET l_yy[4]  = tm.yy4 LET l_bm[4] = 0 LET l_em[4]= tm.m9
#--FUN-A90032 end---

   FOR g_i = 1 TO 5
      IF l_yy[g_i] IS NULL OR l_yy[g_i]=0 THEN EXIT FOR END IF
      # 全數計算
      IF tm.a = 'Y' THEN
         LET g_eff[g_i] = 1
      ELSE
         LET g_eff[g_i] = (l_em[g_i] - l_bm[g_i]+1) / 12
      END IF   
      LET l_sql = "SELECT aag06,aag19,SUM(axh08-axh09)",
                # " FROM axh_file,",g_dbs_axz03,"aag_file",  #FUN-A30122 mark
                  " FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),   #FUN-A30122 add
                  " WHERE axh00 = '",tm.b,"'",
                  "   AND axh00 = aag00",  
                  "   AND axh01 = '",tm.axa01,"'",
                  "   AND axh02 = '",tm.axa02,"'",
                  "   AND axh03 = '",tm.axa03,"'",      #FUN-A90032 mark #MOD-C30048 remark
                 #"   AND axh03 = '",tm.b,"'",          #FUN-A90032 mod  #MOD-C30048 mark
                  "   AND axh05 = aag01",
                  "   AND axh06 = ? ",
                 #"   AND axh07 <=  ? ",      #FUN-A90032 mark
                  "   AND axh07 =  ? ",        #FUN-A90032 
                  "   AND aag04 = '1'",
                  "   AND aag07 != '1'",  
                  "   AND aag09 = 'Y'",  
                  "   AND axh12 = '",x_aaa03,"'", 
                  "   GROUP BY 1,2"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql    #FUN-A30122 add 
      PREPARE aglr010_p1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      DECLARE aglr010_c1 CURSOR FOR aglr010_p1
      FOREACH aglr010_c1 USING l_yy[g_i],l_em[g_i] INTO l_aag06,l_aag19,l_tot
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF

         IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF   
        #-MOD-AB0186-mark-
        #IF l_aag06 ='2' THEN   
        #   LET l_tot =l_tot*-1  
        #END IF   
        #-MOD-AB0186-end-
         LET g_tot[g_i,l_aag19] = g_tot[g_i,l_aag19] + l_tot
      END FOREACH
      CLOSE aglr010_c1

      # 期初
      #--------------------------MOD-C30895-------------------(S)
       IF NOT cl_null(tm.axa06) THEN
          LET l_yy1= l_yy[g_i]
          CASE
             WHEN tm.axa06 = '1'             #月
               LET l_bm1 = l_em[g_i]  - 1
             WHEN tm.axa06 = '2'             #季
               LET l_bm1 = l_em[g_i] - 3
             WHEN tm.axa06 = '3'             #半年
               LET l_bm1 = l_em[g_i] - 6
             WHEN tm.axa06 = '4'             #年
               LET l_bm1 = l_em[g_i] - 12
          END CASE
          IF l_bm1 < 1 THEN
             LET l_bm1 = 12
             LET l_yy1 = l_yy1 -1
          END IF
       END IF

      #LET l_yy1= l_yy[g_i]          #MOD-C30895 mark
      #LET l_bm1= l_bm[g_i]  - 1     #MOD-C30895 mark
      #IF l_bm1< 1 THEN              #MOD-C30895 mark
      #   LET l_bm1= 12              #MOD-C30895 mark
      #   LET l_yy1= l_yy1 -1        #MOD-C30895 mark
      #END IF                        #MOD-C30895 mark
     #--------------------------MOD-C30895-------------------(E)
      FOREACH aglr010_c1 USING l_yy1,l_bm1 INTO l_aag06,l_aag19,l_tot
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF

         IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF  
        #-MOD-AB0186-mark-
        #IF l_aag06 ='2' THEN   
        #   LET l_tot =l_tot*-1  
        #END IF   
        #-MOD-AB0186-end-
         LET g_tot_b[g_i,l_aag19] = g_tot_b[g_i,l_aag19] + l_tot
      END FOREACH
      CLOSE aglr010_c1
   END FOR

   FOR g_i = 1 TO 5
      IF l_yy[g_i] IS NULL OR l_yy[g_i]=0 THEN EXIT FOR END IF
      LET l_sql = "SELECT aag06,aag19,SUM(axh08-axh09)",
                # " FROM axh_file,",g_dbs_axz03,"aag_file",      #FUN-A30122 mark
                  " FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),   #FUN-A30122 add
                  " WHERE axh00 = '",tm.b,"'",
                  "   AND axh00 = aag00",
                  "   AND axh01 = '",tm.axa01,"'",
                  "   AND axh02 = '",tm.axa02,"'",
                  #"   AND axh03 = '",tm.axa03,"'",   #FUN-A90032    
                  "   AND axh03 = '",tm.b,"'",        #FUN-A90032       
                  "   AND axh05 = aag01",
                  "   AND axh06 = ? ",
                  #"   AND axh07 >= ",l_bm[g_i],      #FUN-A90032 mark
                  #"   AND axh07 <= ",l_em[g_i],      #FUN-A90032 mark
                  "   AND axh07 = ",l_em[g_i],        #FUN-A90032 mod
                  "   AND aag04 = '2'",
                  "   AND aag07 != '1'", 
                  "   AND aag09 = 'Y'", 
                  "   AND axh12 = '",x_aaa03,"'", 
                  "   GROUP BY 1,2"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
      CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql     #FUN-A30122 add
      PREPARE aglr010_p2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      DECLARE aglr010_c2 CURSOR FOR aglr010_p2
      FOREACH aglr010_c2 USING l_yy[g_i] INTO l_aag06,l_aag19,l_tot
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF

         IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF   
        #-MOD-AB0186-mark-
        #IF l_aag06 ='2' THEN   
        #   LET l_tot =l_tot*-1  
        #END IF   
        #-MOD-AB0186-end-
         LET g_tot[g_i,l_aag19] = g_tot[g_i,l_aag19] + l_tot
      END FOREACH
      CLOSE aglr010_c2

      #去年同期
      LET l_yyb = l_yy[g_i] -1
      FOREACH aglr010_c2 USING l_yyb INTO l_aag06,l_aag19,l_tot
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         IF l_aag19 IS NULL THEN CONTINUE FOREACH END IF

         IF l_aag19 < 1 OR l_aag19 > 37 THEN CONTINUE FOREACH END IF   
        #-MOD-AB0186-mark-
        #IF l_aag06 ='2' THEN   
        #   LET l_tot =l_tot*-1  
        #END IF   
        #-MOD-AB0186-end-
         LET g_tot_b[g_i,l_aag19] = g_tot_b[g_i,l_aag19] + l_tot
      END FOREACH
      CLOSE aglr010_c2
   END FOR

   CALL aglr010_ins_temp()
   LET g_str = tm.n5,";",tm.yy1,";",tm.yy2,";",tm.yy3,";",tm.yy4,";",
               tm.yy5,";",tm.m1,";",tm.m2,";",tm.m3,";",                                 
               tm.m4,";",tm.m5,";",tm.m6,";",tm.m7,";",tm.m8,";",tm.m9,";",   
               tm.m10,";",tm.n1,";",tm.n2,";",tm.n3,";",tm.n4
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aglr010','aglr010',l_sql,g_str)
END FUNCTION

FUNCTION aglr010_ins_temp()
   DEFINE l_last_sw     LIKE type_file.chr1  
   DEFINE l_tot         ARRAY[5,36] OF LIKE type_file.num20_6 #財務比率(五年)(34項比率)
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_azi04       LIKE azi_file.azi04   
   DEFINE l_format1     LIKE type_file.chr20 
   DEFINE l_format2     LIKE type_file.chr20
   DEFINE sr    DYNAMIC ARRAY OF RECORD
                 a      LIKE type_file.num20_6,   #流動資產    
                 b      LIKE type_file.num20_6,   #流動負債   
                 c      LIKE type_file.num20_6,   #速動資產  
                 d      LIKE type_file.num20_6,   #營運資金 
                 e      LIKE type_file.num20_6,   #資產總額
                 f      LIKE type_file.num20_6,   #營業毛利  
                 g      LIKE type_file.num20_6,   #平均應收帳款 
                 h      LIKE type_file.num20_6,   #平均存貨    
                 i      LIKE type_file.num20_6,   #基金及長期投資
                 j      LIKE type_file.num20_6,   #負債總額    
                 k      LIKE type_file.num20_6,   #業主權益   
                 l      LIKE type_file.num20_6,   #淨利      
                 m      LIKE type_file.num20_6,   #平均應收款項 
                 n      LIKE type_file.num20_6,   #營業利益    
                 o      LIKE type_file.num20_6,   #稅前淨利   
                 p      LIKE type_file.num20_6,   #純益      
                 t      LIKE type_file.num20_6,   #上期資產總額 
                 u      LIKE type_file.num20_6    #上期業主權益
                END RECORD 
   DEFINE sr1   RECORD
                 title  LIKE ze_file.ze03,                      
                 msg01  LIKE ze_file.ze03,                      
                 msg02  LIKE ze_file.ze03,                      
                 msg03  LIKE ze_file.ze03,                      
                 num01  LIKE type_file.num20_6,                 
                 num02  LIKE type_file.num20_6,   
                 tot01  LIKE type_file.num20_6,  
                 tot02  LIKE type_file.num20_6, 
                 tot03  LIKE type_file.num20_6,
                 tot04  LIKE type_file.num20_6,
                 tot05  LIKE type_file.num20_6, 
                 unit   LIKE type_file.chr5,   
                 sort   LIKE type_file.num5,
                 sort2  LIKE type_file.num5,
                 azi04  LIKE azi_file.azi04   
                END RECORD 

   #歸零
   FOR g_i = 1 TO 5
       LET sr[g_i].a = 0  LET sr[g_i].b = 0 LET sr[g_i].c = 0
       LET sr[g_i].d = 0  LET sr[g_i].e = 0 LET sr[g_i].f = 0
       LET sr[g_i].g = 0  LET sr[g_i].h = 0 LET sr[g_i].i = 0
       LET sr[g_i].j = 0  LET sr[g_i].k = 0 LET sr[g_i].l = 0
       LET sr[g_i].m = 0  LET sr[g_i].n = 0 LET sr[g_i].o = 0
       LET sr[g_i].p = 0  LET sr[g_i].t = 0 LET sr[g_i].u = 0
   END FOR
   FOR g_i = 1 TO 36
       LET l_tot[1,g_i] = 0 LET l_tot[2,g_i] = 0 LET l_tot[3,g_i] = 0
       LET l_tot[4,g_i] = 0 LET l_tot[5,g_i] = 0
   END FOR
   #流動資產的運算=1類+2類+3類+4類+5類+6類+7類+8類
   FOR g_i = 1 TO 8
       LET sr[1].a = sr[1].a + g_tot[1,g_i]   #第一期
       LET sr[2].a = sr[2].a + g_tot[2,g_i]   #第二期
       LET sr[3].a = sr[3].a + g_tot[3,g_i]   #第三期
       LET sr[4].a = sr[4].a + g_tot[4,g_i]   #第四期
       LET sr[5].a = sr[5].a + g_tot[5,g_i]   #第五期
   END FOR
   #流動負債的運算=14類+15類+16類+18類
   FOR g_i = 14 TO 16
       LET sr[1].b = sr[1].b + g_tot[1,g_i]*-1   #第一期   #MOD-AB0186 mod
       LET sr[2].b = sr[2].b + g_tot[2,g_i]*-1   #第二期   #MOD-AB0186 mod
       LET sr[3].b = sr[3].b + g_tot[3,g_i]*-1   #第三期   #MOD-AB0186 mod
       LET sr[4].b = sr[4].b + g_tot[4,g_i]*-1   #第四期   #MOD-AB0186 mod
       LET sr[5].b = sr[5].b + g_tot[5,g_i]*-1   #第五期   #MOD-AB0186 mod
   END FOR
  #流動負債的運算增加 18
   LET sr[1].b = sr[1].b + g_tot[1,18]*-1        #第一期   #MOD-AB0186 mod
   LET sr[2].b = sr[2].b + g_tot[2,18]*-1        #第二期   #MOD-AB0186 mod
   LET sr[3].b = sr[3].b + g_tot[3,18]*-1        #第三期   #MOD-AB0186 mod
   LET sr[4].b = sr[4].b + g_tot[4,18]*-1        #第四期   #MOD-AB0186 mod
   LET sr[5].b = sr[5].b + g_tot[5,18]*-1        #第五期   #MOD-AB0186 mod

   #速動資產的運算=1類+2類+3類+4類+8類
   LET sr[1].c =  sr[1].a - (g_tot[1,5] + g_tot[1,6] + g_tot[1,7])   #第一期
   LET sr[2].c =  sr[2].a - (g_tot[2,5] + g_tot[2,6] + g_tot[2,7])   #第二期
   LET sr[3].c =  sr[3].a - (g_tot[3,5] + g_tot[3,6] + g_tot[3,7])   #第三期
   LET sr[4].c =  sr[4].a - (g_tot[4,5] + g_tot[4,6] + g_tot[4,7])   #第四期
   LET sr[5].c =  sr[5].a - (g_tot[5,5] + g_tot[5,6] + g_tot[5,7])   #第五期
   #營運資金=(1類+2類+3類+4類+5類+6類+7類+8類)-(14類+15類+16類+18類)*-1
  #-----------------------MOD-C30895------------------------(S)
  #---MOD-C30895--mark
  #LET sr[1].d = sr[1].a - sr[1].b*-1          #第一期  
  #LET sr[2].d = sr[2].a - sr[2].b*-1          #第二期
  #LET sr[3].d = sr[3].a - sr[3].b*-1          #第三期
  #LET sr[4].d = sr[4].a - sr[4].b*-1          #第四期
  #LET sr[5].d = sr[5].a - sr[5].b*-1          #第五期
  #---MOD-C30895--mark
   LET sr[1].d = sr[1].a - sr[1].b             #第一期
   LET sr[2].d = sr[2].a - sr[2].b             #第二期
   LET sr[3].d = sr[3].a - sr[3].b             #第三期
   LET sr[4].d = sr[4].a - sr[4].b             #第四期
   LET sr[5].d = sr[5].a - sr[5].b             #第五期
  #-----------------------MOD-C30895------------------------(S)
   #資產總額=1類+2類+3類+4類+5類+6類+7類+8類+9類+10類+11類+12類+13類+32類
   FOR g_i = 1 TO 13
       LET sr[1].e = sr[1].e + g_tot[1,g_i]   #第一期
       LET sr[2].e = sr[2].e + g_tot[2,g_i]   #第二期
       LET sr[3].e = sr[3].e + g_tot[3,g_i]   #第三期
       LET sr[4].e = sr[4].e + g_tot[4,g_i]   #第四期
       LET sr[5].e = sr[5].e + g_tot[5,g_i]   #第五期
   END FOR
   LET sr[1].e = sr[1].e + g_tot[1,32]
   LET sr[2].e = sr[2].e + g_tot[2,32]
   LET sr[3].e = sr[3].e + g_tot[3,32]
   LET sr[4].e = sr[4].e + g_tot[4,32]
   LET sr[5].e = sr[5].e + g_tot[5,32]
   #上期資產總額
   FOR g_i = 1 TO 13
       LET sr[1].t = sr[1].t + g_tot_b[1,g_i]   #第一期
       LET sr[2].t = sr[2].t + g_tot_b[2,g_i]   #第二期
       LET sr[3].t = sr[3].t + g_tot_b[3,g_i]   #第三期
       LET sr[4].t = sr[4].t + g_tot_b[4,g_i]   #第四期
       LET sr[5].t = sr[5].t + g_tot_b[5,g_i]   #第五期
   END FOR
   LET sr[1].t = sr[1].t + g_tot_b[1,32]
   LET sr[2].t = sr[2].t + g_tot_b[2,32]
   LET sr[3].t = sr[3].t + g_tot_b[3,32]
   LET sr[4].t = sr[4].t + g_tot_b[4,32]
   LET sr[5].t = sr[5].t + g_tot_b[5,32]

   #銷貨淨額
   #當tm.a(銷貨淨額與銷貨成本依平均存貨方式計算)=Y,銷貨淨額=23類/期數*12
   #                                            =N,銷貨淨額=23類
   IF tm.a = 'Y' THEN
      LET sr[1].f = g_tot[1,23]*-1 /(tm.m4-tm.m1 +1) * 12   #第一期   #MOD-AB0186 mod
      LET sr[2].f = g_tot[2,23]*-1 /(tm.m5-tm.m2 +1) * 12   #第二期   #MOD-AB0186 mod
      LET sr[3].f = g_tot[3,23]*-1 /(tm.m6-tm.m3 +1) * 12   #第三期   #MOD-AB0186 mod
      LET sr[4].f = g_tot[4,23]*-1 /(tm.m9-tm.m7 +1) * 12   #第四期   #MOD-AB0186 mod
      LET sr[5].f = g_tot[5,23]*-1 /(tm.m10-tm.m8 +1) * 12  #第五期   #MOD-AB0186 mod
   ELSE
      LET sr[1].f = g_tot[1,23]*-1                         #第一期    #MOD-AB0186 mod
      LET sr[2].f = g_tot[2,23]*-1                         #第二期    #MOD-AB0186 mod
      LET sr[3].f = g_tot[3,23]*-1                         #第三期    #MOD-AB0186 mod
      LET sr[4].f = g_tot[4,23]*-1                         #第四期    #MOD-AB0186 mod
      LET sr[5].f = g_tot[5,23]*-1                         #第五期    #MOD-AB0186 mod
   END IF  

   #@@平均應收款項=(上期3類+本期3類)/2
   LET sr[1].g = (g_tot_b[1,3]+g_tot[1,3])/2             #第一期
   LET sr[2].g = (g_tot_b[2,3]+g_tot[2,3])/2             #第一期
   LET sr[3].g = (g_tot_b[3,3]+g_tot[3,3])/2             #第一期
   LET sr[4].g = (g_tot_b[4,3]+g_tot[4,3])/2             #第一期
   LET sr[5].g = (g_tot_b[5,3]+g_tot[5,3])/2             #第一期
   #@@平均存貨(上期5類+本期5類)/2
   LET sr[1].h =(g_tot_b[1,5] + g_tot[1,5])/2             #第一期
   LET sr[2].h =(g_tot_b[2,5] + g_tot[2,5])/2             #第二期
   LET sr[3].h =(g_tot_b[3,5] + g_tot[3,5])/2             #第三期
   LET sr[4].h =(g_tot_b[4,5] + g_tot[4,5])/2             #第四期
   LET sr[5].h =(g_tot_b[5,5] + g_tot[5,5])/2             #第五期
   #基金及長期投資=9類+10類+11類
   FOR g_i = 9 TO 11
       LET sr[1].i = sr[1].i + g_tot[1,g_i]   #第一期
       LET sr[2].i = sr[2].i + g_tot[2,g_i]   #第二期
       LET sr[3].i = sr[3].i + g_tot[3,g_i]   #第三期
       LET sr[4].i = sr[4].i + g_tot[4,g_i]   #第四期
       LET sr[5].i = sr[5].i + g_tot[5,g_i]   #第五期
   END FOR
   #負債總額=14類+15類+16類+17類+18類+33類
   FOR g_i = 14 TO 18
       LET sr[1].j = sr[1].j + g_tot[1,g_i]*-1   #第一期     #MOD-AB0186 mod
       LET sr[2].j = sr[2].j + g_tot[2,g_i]*-1   #第二期     #MOD-AB0186 mod
       LET sr[3].j = sr[3].j + g_tot[3,g_i]*-1   #第三期     #MOD-AB0186 mod
       LET sr[4].j = sr[4].j + g_tot[4,g_i]*-1   #第四期     #MOD-AB0186 mod
       LET sr[5].j = sr[5].j + g_tot[5,g_i]*-1   #第五期     #MOD-AB0186 mod
   END FOR
   LET sr[1].j = sr[1].j + g_tot[1,33]*-1                    #MOD-AB0186 mod
   LET sr[2].j = sr[2].j + g_tot[2,33]*-1                    #MOD-AB0186 mod
   LET sr[3].j = sr[3].j + g_tot[3,33]*-1                    #MOD-AB0186 mod
   LET sr[4].j = sr[4].j + g_tot[4,33]*-1                    #MOD-AB0186 mod
   LET sr[5].j = sr[5].j + g_tot[5,33]*-1                    #MOD-AB0186 mod
   #業主權益=19類+20類+21類+22類+34類+35類+36類
   FOR g_i = 19 TO 22
       LET sr[1].k = sr[1].k + g_tot[1,g_i]*-1   #第一期     #MOD-AB0186 mod
       LET sr[2].k = sr[2].k + g_tot[2,g_i]*-1   #第二期     #MOD-AB0186 mod
       LET sr[3].k = sr[3].k + g_tot[3,g_i]*-1   #第三期     #MOD-AB0186 mod
       LET sr[4].k = sr[4].k + g_tot[4,g_i]*-1   #第四期     #MOD-AB0186 mod
       LET sr[5].k = sr[5].k + g_tot[5,g_i]*-1   #第五期     #MOD-AB0186 mod
   END FOR
   FOR g_i = 34 TO 36
       LET sr[1].k = sr[1].k + g_tot[1,g_i]*-1               #MOD-AB0186 mod
       LET sr[2].k = sr[2].k + g_tot[2,g_i]*-1               #MOD-AB0186 mod
       LET sr[3].k = sr[3].k + g_tot[3,g_i]*-1               #MOD-AB0186 mod
       LET sr[4].k = sr[4].k + g_tot[4,g_i]*-1               #MOD-AB0186 mod
       LET sr[5].k = sr[5].k + g_tot[5,g_i]*-1               #MOD-AB0186 mod
   END FOR
   #上期業主權益
   FOR g_i = 19 TO 22
       LET sr[1].u = sr[1].u + g_tot_b[1,g_i]*-1   #第一期   #MOD-AB0186 mod
       LET sr[2].u = sr[2].u + g_tot_b[2,g_i]*-1   #第二期   #MOD-AB0186 mod
       LET sr[3].u = sr[3].u + g_tot_b[3,g_i]*-1   #第三期   #MOD-AB0186 mod
       LET sr[4].u = sr[4].u + g_tot_b[4,g_i]*-1   #第四期   #MOD-AB0186 mod 
       LET sr[5].u = sr[5].u + g_tot_b[5,g_i]*-1   #第五期   #MOD-AB0186 mod
   END FOR
   FOR g_i = 34 TO 36
       LET sr[1].u = sr[1].u + g_tot_b[1,g_i]*-1   #第一期   #MOD-AB0186 mod
       LET sr[2].u = sr[2].u + g_tot_b[2,g_i]*-1   #第二期   #MOD-AB0186 mod
       LET sr[3].u = sr[3].u + g_tot_b[3,g_i]*-1   #第三期   #MOD-AB0186 mod
       LET sr[4].u = sr[4].u + g_tot_b[4,g_i]*-1   #第四期   #MOD-AB0186 mod
       LET sr[5].u = sr[5].u + g_tot_b[5,g_i]*-1   #第五期   #MOD-AB0186 mod
   END FOR

   IF tm.a = 'Y' THEN
      LET g_tot[1,25] = g_tot[1,25]/(tm.m4-tm.m1 +1) * 12   #第一期
      LET g_tot[2,25] = g_tot[2,25]/(tm.m5-tm.m2 +1) * 12   #第二期
      LET g_tot[3,25] = g_tot[3,25]/(tm.m6-tm.m3 +1) * 12   #第三期
      LET g_tot[4,25] = g_tot[4,25]/(tm.m9-tm.m7 +1) * 12   #第四期
      LET g_tot[5,25] = g_tot[5,25]/(tm.m10-tm.m8 +1) * 12  #第五期
   END IF

   #淨利(收入-成本)=(23類*-1)+(24類*-1)-25類-26類
   LET sr[1].l =(g_tot[1,23] * -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]
   LET sr[2].l =(g_tot[2,23] * -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]
   LET sr[3].l =(g_tot[3,23] * -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]
   LET sr[4].l =(g_tot[4,23] * -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]
   LET sr[5].l =(g_tot[5,23] * -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]
  #------------------------MOD-C80102---------------------------(S)
  #-----MOD-C80102-----mark
  ##營業利益=(23類*-1)-25類-27類
  #LET sr[1].n =(g_tot[1,23]* -1)-g_tot[1,25]-g_tot[1,27]    #第一期
  #LET sr[2].n =(g_tot[2,23]* -1)-g_tot[2,25]-g_tot[2,27]    #第二期
  #LET sr[3].n =(g_tot[3,23]* -1)-g_tot[3,25]-g_tot[3,27]    #第三期
  #LET sr[4].n =(g_tot[4,23]* -1)-g_tot[4,25]-g_tot[4,27]    #第四期
  #LET sr[5].n =(g_tot[5,23]* -1)-g_tot[5,25]-g_tot[5,27]    #第五期
  #-----MOD-C80102-----mark
  #營業利益=(23類*-1)+(24類*-1)-25類-26類-27類
   LET sr[1].n =(g_tot[1,23]* -1) + (g_tot[1,24]* -1) - g_tot[1,25] - g_tot[1,26] - g_tot[1,27]    #第一期
   LET sr[2].n =(g_tot[2,23]* -1) + (g_tot[2,24]* -1) - g_tot[2,25] - g_tot[2,26] - g_tot[2,27]    #第二期
   LET sr[3].n =(g_tot[3,23]* -1) + (g_tot[3,24]* -1) - g_tot[3,25] - g_tot[3,26] - g_tot[3,27]    #第三期
   LET sr[4].n =(g_tot[4,23]* -1) +( g_tot[4,24]* -1) - g_tot[4,25] - g_tot[4,26] - g_tot[4,27]    #第四期
   LET sr[5].n =(g_tot[5,23]* -1) +( g_tot[5,24]* -1) - g_tot[5,25] - g_tot[5,26] - g_tot[5,27]    #第五期
  #------------------------MOD-C80102---------------------------(E)
   #稅前淨利=(23類*-1)+(24類*-1)-25類-26類-27類-28類-31類-37類
   LET sr[1].o =(g_tot[1,23]* -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]-   #第一期
                 g_tot[1,27]-g_tot[1,28]-g_tot[1,31]-g_tot[1,37]   
   LET sr[2].o =(g_tot[2,23]* -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]-   #第二期
                 g_tot[2,27]-g_tot[2,28]-g_tot[2,31]-g_tot[2,37]  
   LET sr[3].o =(g_tot[3,23]* -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]-   #第三期
                 g_tot[3,27]-g_tot[3,28]-g_tot[3,31]-g_tot[3,37] 
   LET sr[4].o =(g_tot[4,23]* -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]-   #第四期
                 g_tot[4,27]-g_tot[4,28]-g_tot[4,31]-g_tot[4,37]  
   LET sr[5].o =(g_tot[5,23]* -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]-   #第五期
                 g_tot[5,27]-g_tot[5,28]-g_tot[5,31]-g_tot[5,37]  

   #純益=(23類*-1)+(24類*-1)-25類-26類-27類-28類-29類-31類-37類
   LET sr[1].p =(g_tot[1,23]* -1)+(g_tot[1,24]* -1)-g_tot[1,25]-g_tot[1,26]-   #第一期
                 g_tot[1,27]-g_tot[1,28]-g_tot[1,29]-g_tot[1,31]-
                 g_tot[1,37]  
   LET sr[2].p =(g_tot[2,23]* -1)+(g_tot[2,24]* -1)-g_tot[2,25]-g_tot[2,26]-   #第二期
                 g_tot[2,27]-g_tot[2,28]-g_tot[2,29]-g_tot[2,31]-
                 g_tot[2,37] 
   LET sr[3].p =(g_tot[3,23]* -1)+(g_tot[3,24]* -1)-g_tot[3,25]-g_tot[3,26]-   #第三期
                 g_tot[3,27]-g_tot[3,28]-g_tot[3,29]-g_tot[3,31]-
                 g_tot[3,37]
   LET sr[4].p =(g_tot[4,23]* -1)+(g_tot[4,24]* -1)-g_tot[4,25]-g_tot[4,26]-   #第四期
                 g_tot[4,27]-g_tot[4,28]-g_tot[4,29]-g_tot[4,31]-
                 g_tot[4,37]  
   LET sr[5].p =(g_tot[5,23]* -1)+(g_tot[5,24]* -1)-g_tot[5,25]-g_tot[5,26]-   #第五期
                 g_tot[5,27]-g_tot[5,28]-g_tot[5,29]-g_tot[5,31]-
                 g_tot[5,37] 

  #-MOD-AB0186-add-
   LET g_tot[1,17] = g_tot[1,17]*-1
   LET g_tot[2,17] = g_tot[2,17]*-1
   LET g_tot[3,17] = g_tot[3,17]*-1
   LET g_tot[4,17] = g_tot[4,17]*-1
   LET g_tot[5,17] = g_tot[5,17]*-1
   LET g_tot[1,19] = g_tot[1,19]*-1
   LET g_tot[2,19] = g_tot[2,19]*-1
   LET g_tot[3,19] = g_tot[3,19]*-1
   LET g_tot[4,19] = g_tot[4,19]*-1
   LET g_tot[5,19] = g_tot[5,19]*-1
   LET g_tot[1,23] = g_tot[1,23]*-1
   LET g_tot[2,23] = g_tot[2,23]*-1
   LET g_tot[3,23] = g_tot[3,23]*-1
   LET g_tot[4,23] = g_tot[4,23]*-1
   LET g_tot[5,23] = g_tot[5,23]*-1
  #-MOD-AB0186-end-

   #五年度的財務比率計算
   FOR g_i = 1 TO 5
       #流動負債不為零
       IF sr[g_i].b != 0 THEN
                             #流動比率 (流動資產/流動負債)
          LET l_tot[g_i,1] = sr[g_i].a/sr[g_i].b * 100
                             #酸性測驗 (速動資產/流動負債)
          LET l_tot[g_i,2] = sr[g_i].c/sr[g_i].b * 100
       END IF
       #資產總額不為零
       IF sr[g_i].e != 0 THEN
                      #營運資金比率 (營運資金/資產總額)
          LET l_tot[g_i,3] = sr[g_i].d/sr[g_i].e * 100
                      #流動資產佔資產總額比率 (流動資產/資產總額)
          LET l_tot[g_i,9] = sr[g_i].a/sr[g_i].e * 100
                      #基金及長期投資佔資產總額比率 (基金及長期投資/資產總額)
          LET l_tot[g_i,10] = sr[g_i].i/sr[g_i].e * 100
                      #固定資產佔資產總額比率 (固定資產/資產總額)
          LET l_tot[g_i,11] = g_tot[g_i,12]/sr[g_i].e * 100
                      #其它資產佔資產總額比率 (其它資產/資產總額)
          LET l_tot[g_i,12] = g_tot[g_i,13]/sr[g_i].e * 100
                      #負債總額佔資產總額比率 (負債總額/資產總額)
          LET l_tot[g_i,19] = sr[g_i].j/sr[g_i].e * 100
                      #業主權益佔資產總額比率 (業主權益/資產總額)
          LET l_tot[g_i,20] = sr[g_i].k/sr[g_i].e * 100
                      #資產報酬率 (淨利/資產總額)
                      #資產報酬率 [(純益+利息費用(1-25%)]/平均資產總額)
          LET l_tot[g_i,25] = (sr[g_i].p+(g_tot[g_i,31]*0.75))/
                              ((sr[g_i].e+sr[g_i].t)/2) * 100
                      #資產週轉率 (銷貨淨額/資產總額)
          LET l_tot[g_i,27] = (sr[g_i].f/sr[g_i].e)
       END IF
       #流動資產不為零
       IF sr[g_i].a != 0 THEN
                      #流動資產週轉率 (銷貨淨額/流動資產)
          LET l_tot[g_i,6] = (sr[g_i].f/sr[g_i].a)
                      #現金佔流動資產比率 (現金/流動資產)
          LET l_tot[g_i,13] = g_tot[g_i,1]/sr[g_i].a * 100
                      #短期投資佔流動資產比率 (短期投資/流動資產)
          LET l_tot[g_i,14] = g_tot[g_i,2]/sr[g_i].a * 100
                      #應收款項佔流動資產比率 (應收款項/流動資產)
          LET l_tot[g_i,15] =(g_tot[g_i,3]+g_tot[g_i,4])/sr[g_i].a * 100
                      #存貨佔流動資產比率 (存貨/流動資產)
          LET l_tot[g_i,16] = (g_tot[g_i,5]+g_tot[g_i,6])/sr[g_i].a * 100
                      #預付款項佔流動資產比率 (預付款項/流動資產)
          LET l_tot[g_i,17] = g_tot[g_i,7]/sr[g_i].a * 100
                      #其它流動資產佔流動資產比率 (其它流動資產/流動資產)
          LET l_tot[g_i,18] = g_tot[g_i,8]/sr[g_i].a * 100
       END IF
       #固定資產不為零
       IF g_tot[g_i,12] != 0 THEN
              #固定資產週轉率 (銷貨淨額/固定資產)
          LET l_tot[g_i,28] = (sr[g_i].f/g_tot[g_i,12])
              #長期資金佔固定資產比率 (股東權益+長期負債/固定資產)
          LET l_tot[g_i,29] = (sr[g_i].k+g_tot[g_i,17])/g_tot[g_i,12] * 100
       END IF
       #負債總額不為零
       IF sr[g_i].j != 0 THEN
                      #業主權益佔負債總額比率 (業主權益/流動負債)
          LET l_tot[g_i,21] = sr[g_i].k/sr[g_i].j * 100
       END IF
       #長期負債不為零
       IF g_tot[g_i,17] != 0 THEN
                      #固定資產對長期負債比率 (固定資產/長期負債)
          LET l_tot[g_i,22] = g_tot[g_i,12]/g_tot[g_i,17] * 100
       END IF
       #業主權益不為零
       IF sr[g_i].k != 0 THEN
                      #固定資產對業主權益的比率 (固定資產/業主權益)
          LET l_tot[g_i,23] = g_tot[g_i,12]/sr[g_i].k * 100
                      #資本報酬率 (淨利/平均業主權益)
          LET l_tot[g_i,26] = sr[g_i].p/
                              ((sr[g_i].k+sr[g_i].u)/2) * 100
       END IF
       #銷貨淨額不為零
       IF sr[g_i].f != 0 THEN
                      #利潤率 (淨利/銷貨淨額)
          LET l_tot[g_i,24] = sr[g_i].l/sr[g_i].f * 100
       END IF
       #平均存貨不為零
       IF sr[g_i].h != 0 THEN
                      #存貨週轉率 (銷貨成本/平均存貨)
          LET l_tot[g_i,7] = (g_tot[g_i,25]/sr[g_i].h)
       END IF
       #存貨週轉率不為零
       IF l_tot[g_i,7] != 0 THEN
                      #存貨維持日數 (日數/存貨週轉率)
          LET l_tot[g_i,8] = 365*g_eff[g_i]/l_tot[g_i,7]
       END IF
       #應收款項不為零
       IF sr[g_i].g != 0 THEN
                      #應收款項週轉率 (銷貨淨額/應收款項)
          LET l_tot[g_i,4] = (sr[g_i].f/sr[g_i].g)
       END IF
       #應收款項率不為零
       IF l_tot[g_i,4] != 0 THEN
              #應收款項維持日數 (日數/應收款項週轉率)
          LET l_tot[g_i,5] = 365*g_eff[g_i]/l_tot[g_i,4]
       END IF
       #股本不為零
       IF g_tot[g_i,19] != 0 THEN
              #營業利益佔實收資本比率 (營業利益/股本)
          LET l_tot[g_i,30] = sr[g_i].n/g_tot[g_i,19] * 100
              #稅前淨利佔實收資本比率 (稅前淨利/股本)
          LET l_tot[g_i,31] = sr[g_i].o/g_tot[g_i,19] * 100
              #稅前每股盈餘           (稅前淨利/股數)
          LET l_tot[g_i,34] = sr[g_i].o/g_tot[g_i,19]*10
              #稅後每股盈餘           (稅前淨利-所得稅)/股數)
          LET l_tot[g_i,35] =(sr[g_i].o-g_tot[g_i,29])/g_tot[g_i,19]*10
       END IF
       #銷貨淨額不為零
       IF g_tot[g_i,23] != 0 THEN
              #毛利率 (營業毛利/銷貨淨額)
          LET l_tot[g_i,32] = sr[g_i].l /g_tot[g_i,23] * 100
              #營業利益率 (營業利益/銷貨淨額)
          LET l_tot[g_i,33] = sr[g_i].n/g_tot[g_i,23] * 100
       END IF
       #利息費用不為零
       IF g_tot[g_i,31] != 0 THEN
              #利息保障倍數 (稅前淨利+利息費用)/利息費用
          LET l_tot[g_i,36] = (sr[g_i].o+g_tot[g_i,31]) /g_tot[g_i,31]
       END IF
   END FOR

  #決定金額取位的FORMAT
   CALL aglr010_get_format()
        RETURNING sr1.azi04,l_format1,l_format2

   #股東權益對資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)
   LET sr1.msg01 = cl_getmsg('abg-022',g_lang)
   LET sr1.msg02 = cl_getmsg('abg-023',g_lang)
   LET sr1.msg03 = cl_getmsg('abg-024',g_lang)
   LET sr1.num01 = sr[1].k USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,20]  
   LET sr1.tot02 = l_tot[2,20] 
   LET sr1.tot03 = l_tot[3,20]
   LET sr1.tot04 = l_tot[4,20]
   LET sr1.tot05 = l_tot[5,20] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 1
   LET sr1.sort2 = 1
   EXECUTE insert_prep USING sr1.*

   #負債總額對資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-025',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-026',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-027',g_lang)   
   LET sr1.num01 = sr[1].j USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,19]  
   LET sr1.tot02 = l_tot[2,19] 
   LET sr1.tot03 = l_tot[3,19]
   LET sr1.tot04 = l_tot[4,19] 
   LET sr1.tot05 = l_tot[5,19]
   LET sr1.unit  = '%'       
   LET sr1.sort = 2                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*

   #長期資金對固定資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-028',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-029',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-030',g_lang)                              
   LET sr1.num01 = sr[1].k+g_tot[1,17] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,12] USING l_format2          #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,29] 
   LET sr1.tot02 = l_tot[2,29]
   LET sr1.tot03 = l_tot[3,29]
   LET sr1.tot04 = l_tot[4,29] 
   LET sr1.tot05 = l_tot[5,29] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 3                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*

   #營運資金比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-031',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-032',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-033',g_lang)                              
   LET sr1.num01 = sr[1].d USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,3]   
   LET sr1.tot02 = l_tot[2,3]  
   LET sr1.tot03 = l_tot[3,3] 
   LET sr1.tot04 = l_tot[4,3] 
   LET sr1.tot05 = l_tot[5,3]  
   LET sr1.unit  = '%'        
   LET sr1.sort = 4                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*

   #流動資產佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-034',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-035',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-036',g_lang)                              
   LET sr1.num01 = sr[1].a USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,9]  
   LET sr1.tot02 = l_tot[2,9] 
   LET sr1.tot03 = l_tot[3,9]
   LET sr1.tot04 = l_tot[4,9] 
   LET sr1.tot05 = l_tot[5,9] 
   LET sr1.unit  = '%'       
   LET sr1.sort = 5                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*

   #基金及長期投資佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-037',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-038',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-039',g_lang)                              
   LET sr1.num01 = sr[1].i USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,10] 
   LET sr1.tot02 = l_tot[2,10]
   LET sr1.tot03 = l_tot[3,10]  
   LET sr1.tot04 = l_tot[4,10] 
   LET sr1.tot05 = l_tot[5,10]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 6                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*
  
   #固定資產佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-040',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-041',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-042',g_lang)                              
   LET sr1.num01 = g_tot[1,12] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,11]  
   LET sr1.tot02 = l_tot[2,11] 
   LET sr1.tot03 = l_tot[3,11]
   LET sr1.tot04 = l_tot[4,11]  
   LET sr1.tot05 = l_tot[5,11] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 7                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*

   #其它資產佔資產總額比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-043',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-044',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-045',g_lang)
   LET sr1.num01 = g_tot[1,13] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,12]  
   LET sr1.tot02 = l_tot[2,12] 
   LET sr1.tot03 = l_tot[3,12]
   LET sr1.tot04 = l_tot[4,12] 
   LET sr1.tot05 = l_tot[5,12] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 8                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*

   #現金佔流動資產比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-046',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-047',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-048',g_lang)                              
   LET sr1.num01 = g_tot[1,1] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,13] 
   LET sr1.tot02 = l_tot[2,13]
   LET sr1.tot03 = l_tot[3,13] 
   LET sr1.tot04 = l_tot[4,13] 
   LET sr1.tot05 = l_tot[5,13]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 9                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*

   #短期投資佔流動資產比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-049',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-050',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-051',g_lang)                              
   LET sr1.num01 = g_tot[1,2] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,14]  
   LET sr1.tot02 = l_tot[2,14] 
   LET sr1.tot03 = l_tot[3,14]
   LET sr1.tot04 = l_tot[4,14] 
   LET sr1.tot05 = l_tot[5,14]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 10                                                         
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #應收款項占流動資產比率                                                   
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-052',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-053',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-054',g_lang)                              
   LET sr1.num01 = g_tot[1,3]+g_tot[1,4] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2                #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,15]   
   LET sr1.tot02 = l_tot[2,15]  
   LET sr1.tot03 = l_tot[3,15] 
   LET sr1.tot04 = l_tot[4,15]
   LET sr1.tot05 = l_tot[5,15]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 11                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #存貨占流動資產比率                                                       
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-055',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-056',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-057',g_lang)                              
   LET sr1.num01 = g_tot[1,5]+g_tot[1,6] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2                #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,16]   
   LET sr1.tot02 = l_tot[2,16]  
   LET sr1.tot03 = l_tot[3,16] 
   LET sr1.tot04 = l_tot[4,16]
   LET sr1.tot05 = l_tot[5,16]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 12                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #預付款項占流動資產比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-058',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-059',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-060',g_lang)                              
   LET sr1.num01 = g_tot[1,7] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,17]   
   LET sr1.tot02 = l_tot[2,17]  
   LET sr1.tot03 = l_tot[3,17] 
   LET sr1.tot04 = l_tot[4,17]
   LET sr1.tot05 = l_tot[5,17]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 13                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #其它流動資產占流動資產比率                                               
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-061',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-062',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-063',g_lang)                              
   LET sr1.num01 = g_tot[1,8] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2     #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,18]   
   LET sr1.tot02 = l_tot[2,18]  
   LET sr1.tot03 = l_tot[3,18] 
   LET sr1.tot04 = l_tot[4,18]
   LET sr1.tot05 = l_tot[5,18]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 14                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #固定資產對長期負債之比率                                                 
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-064',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-065',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-066',g_lang)                              
   LET sr1.num01 = g_tot[1,12] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,17] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,22]  
   LET sr1.tot02 = l_tot[2,22] 
   LET sr1.tot03 = l_tot[3,22]
   LET sr1.tot04 = l_tot[4,22]  
   LET sr1.tot05 = l_tot[5,22] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 15                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #固定資產對業主益權比率
   LET sr1.title = cl_getmsg('abg-021',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-067',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-068',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-069',g_lang)                              
   LET sr1.num01 = g_tot[1,12] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].k USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,23]  
   LET sr1.tot02 = l_tot[2,23] 
   LET sr1.tot03 = l_tot[3,23]
   LET sr1.tot04 = l_tot[4,23]  
   LET sr1.tot05 = l_tot[5,23] 
   LET sr1.unit  = '%'         
   LET sr1.sort = 16                                                        
   LET sr1.sort2 = 1                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                                
   #流動比率                                                                 
   LET sr1.title = cl_getmsg('abg-070',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-071',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-072',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-073',g_lang)                              
   LET sr1.num01 = sr[1].a USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].b USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,1]   
   LET sr1.tot02 = l_tot[2,1]  
   LET sr1.tot03 = l_tot[3,1] 
   LET sr1.tot04 = l_tot[4,1]
   LET sr1.tot05 = l_tot[5,1] 
   LET sr1.unit  = '%'       
   LET sr1.sort = 17                                                        
   LET sr1.sort2 = 2                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #酸性測驗                                                                 
   LET sr1.title = cl_getmsg('abg-070',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-074',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-075',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-076',g_lang)                              
   LET sr1.num01 = sr[1].c USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].b USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,2]   
   LET sr1.tot02 = l_tot[2,2]  
   LET sr1.tot03 = l_tot[3,2] 
   LET sr1.tot04 = l_tot[4,2]
   LET sr1.tot05 = l_tot[5,2]  
   LET sr1.unit  = '%'        
   LET sr1.sort = 18                                                        
   LET sr1.sort2 = 2                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #利息保障倍數
   LET sr1.title = cl_getmsg('abg-070',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-127',g_lang)   
   LET sr1.msg02 = cl_getmsg('abg-128',g_lang)  
   LET sr1.msg03 = cl_getmsg('abg-129',g_lang) 
   LET sr1.num01 = sr[1].o + g_tot[1,31] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,31] USING l_format2            #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,36]   
   LET sr1.tot02 = l_tot[2,36]  
   LET sr1.tot03 = l_tot[3,36] 
   LET sr1.tot04 = l_tot[4,36]
   LET sr1.tot05 = l_tot[5,36] 
   LET sr1.unit  = ' '        
   LET sr1.sort = 19                                                        
   LET sr1.sort2 = 2                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #應收款項周轉率                                                           
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-078',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-079',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-080',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].g USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,4]    
   LET sr1.tot02 = l_tot[2,4]   
   LET sr1.tot03 = l_tot[3,4]  
   LET sr1.tot04 = l_tot[4,4] 
   LET sr1.tot05 = l_tot[5,4]
   LET sr1.unit  = cl_getmsg('abg-131',g_lang)  #次
   LET sr1.sort = 20                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #平均收款日數                                                             
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-081',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-082',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-083',g_lang)                              
   LET sr1.num01 = 365*g_eff[1] USING '###'                                            
   LET sr1.num02 = l_tot[1,4] USING '-,--&.&&'  
   LET sr1.tot01 = l_tot[1,5]                  
   LET sr1.tot02 = l_tot[2,5]                 
   LET sr1.tot03 = l_tot[3,5]                
   LET sr1.tot04 = l_tot[4,5]               
   LET sr1.tot05 = l_tot[5,5]              
   LET sr1.unit  = cl_getmsg('amr-201',g_lang) #天
   LET sr1.sort = 21                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #存貨周轉率
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-084',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-085',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-086',g_lang)                              
   LET sr1.num01 = g_tot[1,25] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].h USING l_format2      #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,7]              
   LET sr1.tot02 = l_tot[2,7]             
   LET sr1.tot03 = l_tot[3,7]            
   LET sr1.tot04 = l_tot[4,7]           
   LET sr1.tot05 = l_tot[5,7]          
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次
   LET sr1.sort = 22                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #存貨維持日數                                                             
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-087',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-088',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-089',g_lang)                              
   LET sr1.num01 = 365*g_eff[1] USING '###'                                            
   LET sr1.num02 = l_tot[1,7] USING '-,--&.&&'  
   LET sr1.tot01 = l_tot[1,8]                  
   LET sr1.tot02 = l_tot[2,8]                 
   LET sr1.tot03 = l_tot[3,8]                
   LET sr1.tot04 = l_tot[4,8]               
   LET sr1.tot05 = l_tot[5,8]              
   LET sr1.unit  = cl_getmsg('amr-201',g_lang) #天
   LET sr1.sort = 23                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #流動資產周轉率                                                           
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-090',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-091',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-092',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].a USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,6]          
   LET sr1.tot02 = l_tot[2,6]         
   LET sr1.tot03 = l_tot[3,6]        
   LET sr1.tot04 = l_tot[4,6]       
   LET sr1.tot05 = l_tot[5,6]      
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次
   LET sr1.sort = 24                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #固定資產周轉率
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-093',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-094',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-095',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,12] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,28]               
   LET sr1.tot02 = l_tot[2,28]              
   LET sr1.tot03 = l_tot[3,28]             
   LET sr1.tot04 = l_tot[4,28]            
   LET sr1.tot05 = l_tot[5,28]           
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次
   LET sr1.sort = 25                                                        
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #資產周轉率                                                               
   LET sr1.title = cl_getmsg('abg-077',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-096',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-097',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-098',g_lang)                              
   LET sr1.num01 = sr[1].f USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].e USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,27]       
   LET sr1.tot02 = l_tot[2,27]      
   LET sr1.tot03 = l_tot[3,27]     
   LET sr1.tot04 = l_tot[4,27]    
   LET sr1.tot05 = l_tot[5,27]   
   LET sr1.unit  = cl_getmsg('abg-131',g_lang) #次
   LET sr1.sort = 26                            
   LET sr1.sort2 = 3                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #四.獲利能力%                                                             
   #資產報酬率                                                               
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-100',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-101',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-102',g_lang)                              
   LET sr1.num01 = sr[1].p+(g_tot[1,31]*0.75) USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = (sr[1].e+sr[1].t)/2 USING l_format2         #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,25]  
   LET sr1.tot02 = l_tot[2,25] 
   LET sr1.tot03 = l_tot[3,25]  
   LET sr1.tot04 = l_tot[4,25]  
   LET sr1.tot05 = l_tot[5,25]  
   LET sr1.unit  = '%'          
   LET sr1.sort = 27                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*

   #股東權益報酬率                                                           
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-103',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-104',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-105',g_lang)                              
   LET sr1.num01 = sr[1].p USING l_format1              #'##,###,###,###,##&'
   LET sr1.num02 = (sr[1].k+sr[1].u)/2 USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,26]  
   LET sr1.tot02 = l_tot[2,26] 
   LET sr1.tot03 = l_tot[3,26]  
   LET sr1.tot04 = l_tot[4,26]  
   LET sr1.tot05 = l_tot[5,26]  
   LET sr1.unit  = '%'          
   LET sr1.sort = 28                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #營業利益占實收資本比率                                                   
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-106',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-107',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-108',g_lang)                              
   LET sr1.num01 = sr[1].n USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,30]   
   LET sr1.tot02 = l_tot[2,30]  
   LET sr1.tot03 = l_tot[3,30] 
   LET sr1.tot04 = l_tot[4,30]  
   LET sr1.tot05 = l_tot[5,30]  
   LET sr1.unit  = '%'         
   LET sr1.sort = 29                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #稅前純益占實收資本比率                                                   
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-109',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-110',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-111',g_lang)                              
   LET sr1.num01 = sr[1].o USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,31]   
   LET sr1.tot02 = l_tot[2,31]  
   LET sr1.tot03 = l_tot[3,31] 
   LET sr1.tot04 = l_tot[4,31]  
   LET sr1.tot05 = l_tot[5,31] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 30                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
    
   #毛利率                                                                   
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-112',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-113',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-114',g_lang)                              
   LET sr1.num01 = sr[1].l USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,23] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,32]  
   LET sr1.tot02 = l_tot[2,32] 
   LET sr1.tot03 = l_tot[3,32] 
   LET sr1.tot04 = l_tot[4,32]  
   LET sr1.tot05 = l_tot[5,32]  
   LET sr1.unit  = '%'          
   LET sr1.sort = 31                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #營業利益率                                                               
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-115',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-116',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-117',g_lang)                              
   LET sr1.num01 = sr[1].n USING l_format1      #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,23] USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,33]   
   LET sr1.tot02 = l_tot[2,33]  
   LET sr1.tot03 = l_tot[3,33] 
   LET sr1.tot04 = l_tot[4,33]  
   LET sr1.tot05 = l_tot[5,33] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 32                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #稅前每股盈餘                                                             
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-118',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-119',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-120',g_lang)                              
   LET sr1.num01 = sr[1].o USING l_format1         #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19]/10 USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,34]   
   LET sr1.tot02 = l_tot[2,34]  
   LET sr1.tot03 = l_tot[3,34] 
   LET sr1.tot04 = l_tot[4,34]  
   LET sr1.tot05 = l_tot[5,34] 
   LET sr1.unit  = ' '        
   LET sr1.sort = 33                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*

   #稅後每股盈餘                                                             
   LET sr1.title = cl_getmsg('abg-099',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-124',g_lang)  
   LET sr1.msg02 = cl_getmsg('abg-125',g_lang)  
   LET sr1.msg03 = cl_getmsg('abg-126',g_lang) 
   LET sr1.num01 = sr[1].o-g_tot[1,29] USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = g_tot[1,19]/10 USING l_format2       #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,35] 
   LET sr1.tot02 = l_tot[2,35]
   LET sr1.tot03 = l_tot[3,35]  
   LET sr1.tot04 = l_tot[4,35]  
   LET sr1.tot05 = l_tot[5,35] 
   LET sr1.unit  = ' '        
   LET sr1.sort = 34                                                        
   LET sr1.sort2 = 4                                                        
   EXECUTE insert_prep USING sr1.*                                          
                                                                            
   #五.業主權益對負債總額比率                                                
   LET sr1.title = cl_getmsg('abg-121',g_lang)                              
   LET sr1.msg01 = cl_getmsg('abg-121',g_lang)                              
   LET sr1.msg02 = cl_getmsg('abg-122',g_lang)                              
   LET sr1.msg03 = cl_getmsg('abg-123',g_lang)                              
   LET sr1.num01 = sr[1].k USING l_format1  #'##,###,###,###,##&'
   LET sr1.num02 = sr[1].j USING l_format2  #'<<,<<<,<<<,<<<,<<&'
   LET sr1.tot01 = l_tot[1,21]  
   LET sr1.tot02 = l_tot[2,21] 
   LET sr1.tot03 = l_tot[3,21]
   LET sr1.tot04 = l_tot[4,21]  
   LET sr1.tot05 = l_tot[5,21] 
   LET sr1.unit  = '%'        
   LET sr1.sort = 34                                                        
   LET sr1.sort2 = 5                                                        
   EXECUTE insert_prep USING sr1.* 

END FUNCTION

FUNCTION aglr010_get_format()
   DEFINE l_azi04   LIKE azi_file.azi04
   DEFINE l_format1 LIKE type_file.chr20
   DEFINE l_format2 LIKE type_file.chr20

   #抓取本國幣金額取位小數位數
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=g_aza.aza17
   #決定金額取位的FORMAT
   CASE l_azi04
      WHEN 0  LET l_format1 =  '--,---,---,---,--&'
              LET l_format2 = '-<<,<<<,<<<,<<<,<<&'
      WHEN 1  LET l_format1 =  '----,---,---,--&.&'
              LET l_format2 = '-<<<<,<<<,<<<,<<&.&'
      WHEN 2  LET l_format1 =  '---,---,---,--&.&&'
              LET l_format2 = '-<<<,<<<,<<<,<<&.&&'
      WHEN 3  LET l_format1 =  '--,---,---,--&.&&&'
              LET l_format2 = '-<<,<<<,<<<,<<&.&&&'
      WHEN 4  LET l_format1 =  '-,---,---,--&.&&&&'
              LET l_format2 = '-<,<<<,<<<,<<&.&&&&'
      WHEN 5  LET l_format1 =  '----,---,--&.&&&&&'
              LET l_format2 = '-<<<<,<<<,<<&.&&&&&'
      WHEN 6  LET l_format1 =  '---,---,--&.&&&&&&'
              LET l_format2 = '-<<<,<<<,<<&.&&&&&&'
   END CASE
   RETURN l_azi04,l_format1,l_format2
END FUNCTION

#FUN-A90032 --Begin
FUNCTION r010_set_entry()                                                                                                           
   CALL cl_set_comp_entry("q1,m4,h1,q2,m5,h2,q3,m6,h3,q4,m9,h4",TRUE)
END FUNCTION                                                                                                                        

FUNCTION r010_set_no_entry()
   IF tm.axa06 ="1" THEN
      CALL cl_set_comp_entry("q1,h1,q2,h2,q3,h3,q4,h4",FALSE)
   END IF
   IF tm.axa06 ="2" THEN
      CALL cl_set_comp_entry("m4,h1,m5,h2,m6,h3,m9,h4",FALSE)
   END IF
   IF tm.axa06 ="3" THEN
      CALL cl_set_comp_entry("m4,q1,m5,q2,m6,q3,m9,q4",FALSE)
   END IF
   IF tm.axa06 ="4" THEN
   CALL cl_set_comp_entry("q1,m4,h1,q2,m5,h2,q3,m6,h3,q4,m9,h4",FALSE)
   END IF

END FUNCTION

FUNCTION i012_set_n()
   CASE tm.axa06
      WHEN 2
         CASE tm.q1
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n1
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n1
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n1
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n1
         END CASE
         CASE tm.q2
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n2
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n2
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n2
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n2
         END CASE
         CASE tm.q3
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n3
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n3
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n3
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n3
         END CASE
         CASE tm.q4
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.n4
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.n4
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.n4
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.n4
         END CASE
      WHEN 3
         CASE tm.h1
            WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n1
            WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n1
         END CASE
         CASE tm.h2
            WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n2
            WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n2
         END CASE
         CASE tm.h3
            WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n3
            WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n3
         END CASE
         CASE tm.h4
            WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.n4
            WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.n4
         END CASE
         OTHERWISE LET tm.n1= ' ' LET tm.n2= ' ' LET tm.n3 = ' ' LET tm.n4 = ' '
      END CASE
END FUNCTION
#FUN-A90032 --End
#FUN-9A0036 

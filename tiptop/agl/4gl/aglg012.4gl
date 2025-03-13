# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg012.4gl
# Descriptions...: 合并后兩期財務報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 10/08/11 FUN-9A0036 By vealxu 
# Modify.........: No.FUN-A30122 10/04/07 By vealxu 1、合并帳別/合并資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No:CHI-A60013 10/07/19 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: No:CHI-A70061 10/08/25 By Summer 先列印空白再列印資料
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: No:FUN-AB0085 11/01/26 By lixia 追單yy2,em2,h2,q2 皆設noentry,由yy1,em1,h1,q1做預設(去年同期)
# Modify.........: No.FUN-AB0091 11/01/26 By vealxu 選半年報時,計算期別寫法錯誤
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No.FUN-B50001 11/05/10 By lutngting agls101參數檔改為aaw_fil
# Modify.........: No.FUN-B90028 11/09/19 By qirl明細CR報表轉GR
# Modify.........: No.FUN-B90028 12/01/13 By xuxz  FUN-B50001 rollback
# Modify.........: No.FUN-C50004 12/05/04 By nanbing GR優化
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD
                 rtype  LIKE type_file.chr1,             #報表結構編號 
                 axa01  LIKE axa_file.axa01,             #族群編號
                 axa02  LIKE axa_file.axa02,             #上層公司編號
                 axa03  LIKE axa_file.axa03,             #帳別
                 aaz641 LIKE aaz_file.aaz641,            #合并帳別  #FUN-B50001 #FUN-B90028 (FUN-B50001) rollback
                 #aaw01 LIKE aaw_file.aaw01,            #合并帳別 #FUN-B90028 (FUN-B50001) rollback
                 a      LIKE mai_file.mai01,             #報表結構編號
#                title1  LIKE type_file.chr8,            #FUN-A90032 mark
                 title1  LIKE type_file.chr20,           #FUN-A90032
                 yy1     LIKE type_file.num5,            #輸入年度
                 axa06   LIKE axa_file.axa06,            #FUN-A90032
                 bm1     LIKE type_file.num5,            #Begin 期別
                 em1     LIKE type_file.num5,            # End  期別
                 q1      LIKE type_file.chr1,            #FUN-A90032
                 h1      LIKE type_file.chr1,            #FUN-A90032
#                title2  LIKE type_file.chr8,            #FUN-A90032
                 title2  LIKE type_file.chr20,           #FUN-A90032
                 yy2     LIKE type_file.num5,            #輸入年度
                 bm2     LIKE type_file.num5,            #Begin 期別
                 em2     LIKE type_file.num5,            # End  期別
                 q2      LIKE type_file.chr1,            #FUN-A90032
                 h2      LIKE type_file.chr1,            #FUN-A90032
                 c       LIKE type_file.chr1,            #異動額及餘額為0者是否列印
                 d       LIKE type_file.chr1,            #金額單位
                 e       LIKE type_file.num5,            #小數位數
                 f       LIKE type_file.num5,            #列印最小階數
                 h       LIKE type_file.chr4,            #額外說明類別
                 o       LIKE type_file.chr1,            #轉換幣別否
                 p      LIKE azi_file.azi01,  #幣別
                 q      LIKE azj_file.azj03,  #匯率
                 r      LIKE azi_file.azi01,  #幣別
                 more    LIKE type_file.chr1            #Input more condition(Y/N)
              END RECORD,
          bdate,edate     LIKE type_file.dat,          
          i,j,k            LIKE type_file.num5,       
          g_unit     LIKE type_file.num10,              #金額單位基數  
          g_bookno   LIKE axh_file.axh00, #帳別
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_tot1     ARRAY[100] OF LIKE type_file.num20_6,
          g_tot2     ARRAY[100] OF LIKE type_file.num20_6,
          g_tot3     ARRAY[100] OF LIKE type_file.num20_6,
          g_basetot1 LIKE axh_file.axh08,
          g_basetot2 LIKE axh_file.axh08,
          g_basetot3 LIKE axh_file.axh08
   DEFINE g_aaa03    LIKE aaa_file.aaa03   
   DEFINE g_i        LIKE type_file.num5    #count/index for any purpose 
   DEFINE g_msg      LIKE type_file.chr1000 
   DEFINE l_table    STRING                
   DEFINE g_str      STRING               
   DEFINE g_sql      STRING              
   DEFINE x_aaa03    LIKE aaa_file.aaa03
   DEFINE g_aaz641   LIKE aaz_file.aaz641   #FUN-B50001#FUN-B90028 (FUN-B50001) rollback
   #DEFINE g_aaw01   LIKE aaw_file.aaw01#FUN-B90028 (FUN-B50001) rollback
   DEFINE g_axz03    LIKE axz_file.axz03
   DEFINE g_dbs_axz03 STRING
   DEFINE g_plant_axz03 LIKE type_file.chr21   #FUN-A30122 add by vealxu
   DEFINE g_axa09    LIKE axa_file.axa09 
   DEFINE g_axa05    LIKE axa_file.axa05    #FUN-A90032
###GENGRE###START
TYPE sr1_t RECORD
    maj01 LIKE maj_file.maj01,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    maj04 LIKE maj_file.maj04,
    maj05 LIKE maj_file.maj05,
    maj06 LIKE maj_file.maj06,
    maj07 LIKE maj_file.maj07,
    maj08 LIKE maj_file.maj08,
    maj09 LIKE maj_file.maj09,
    maj10 LIKE maj_file.maj10,
    maj11 LIKE maj_file.maj11,
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj21 LIKE maj_file.maj21,
    maj22 LIKE maj_file.maj22,
    maj23 LIKE maj_file.maj23,
    maj24 LIKE maj_file.maj24,
    maj25 LIKE maj_file.maj25,
    maj26 LIKE maj_file.maj26,
    maj27 LIKE maj_file.maj27,
    maj28 LIKE maj_file.maj28,
    maj29 LIKE maj_file.maj29,
    maj30 LIKE maj_file.maj30,
    line LIKE type_file.num5,
    bal1 LIKE axh_file.axh08,
    bal2 LIKE axh_file.axh08,
    bal3 LIKE axh_file.axh08,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05
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

   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " maj01.maj_file.maj01, ",
               " maj02.maj_file.maj02, ",
               " maj03.maj_file.maj03, ",
               " maj04.maj_file.maj04, ",
               " maj05.maj_file.maj05, ",
               " maj06.maj_file.maj06, ",
               " maj07.maj_file.maj07, ",
               " maj08.maj_file.maj08, ",
               " maj09.maj_file.maj09, ",
               " maj10.maj_file.maj10, ",
               " maj11.maj_file.maj11, ",
               " maj20.maj_file.maj20, ",
               " maj20e.maj_file.maj20e, ",
               " maj21.maj_file.maj21, ",
               " maj22.maj_file.maj22, ",
               " maj23.maj_file.maj23, ",
               " maj24.maj_file.maj24, ",
               " maj25.maj_file.maj25, ",
               " maj26.maj_file.maj26, ",
               " maj27.maj_file.maj27, ",
               " maj28.maj_file.maj28, ",
               " maj29.maj_file.maj29, ",
               " maj30.maj_file.maj30, ",
               " line.type_file.num5, ", #CHI-A70061 add
               " bal1.axh_file.axh08,  ",
               " bal2.axh_file.axh08,  ",
               " bal3.axh_file.axh08,  ",
               " azi03.azi_file.azi03, ",
               " azi04.azi_file.azi04, ",
               " azi05.azi_file.azi05  " 
  
   LET l_table = cl_prt_temptable('aglg012',g_sql) CLIPPED  # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生有錯
  #LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED, #CHI-A70061 mark
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #CHI-A70061
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?) " #CHI-A70061 add ?
  
   PREPARE insert_prep FROM g_sql
   IF sqlca.sqlcode THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF

   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.aaz641  = ARG_VAL(10)    #FUN-B50001 #FUN-B90028 (FUN-B50001) rollback
   #LET tm.aaw01  = ARG_VAL(10)       #FUN-B50001 #FUN-B90028 (FUN-B50001) rollback
   LET tm.title1 = ARG_VAL(11)   
   LET tm.yy1 = ARG_VAL(12)
#  LET tm.bm1 = ARG_VAL(13) #FUN-A90032
   LET tm.axa06=ARG_VAL(13) #FUN-A90032
   LET tm.em1 = ARG_VAL(14)
   LET tm.title2 = ARG_VAL(15)  
   LET tm.yy2 = ARG_VAL(16)  
   LET tm.bm2 = ARG_VAL(17) 
   LET tm.em2 = ARG_VAL(18)
   LET tm.c  = ARG_VAL(19)
   LET tm.d  = ARG_VAL(20)
   LET tm.e  = ARG_VAL(21)
   LET tm.f  = ARG_VAL(22)
   LET tm.h  = ARG_VAL(23)
   LET tm.o  = ARG_VAL(24)
   LET tm.p  = ARG_VAL(25)
   LET tm.q  = ARG_VAL(26)
   LET tm.r  = ARG_VAL(27) 
   LET g_rep_user = ARG_VAL(28)
   LET g_rep_clas = ARG_VAL(29)
   LET g_template = ARG_VAL(30)
   LET g_rpt_name = ARG_VAL(31) 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
#FUN-B50001--mod--str--#FUN-B90028 (FUN-B50001) rollback
   IF cl_null(tm.aaz641) THEN
      LET tm.aaz641 = g_aza.aza81
   END IF 
#  IF cl_null(tm.aaw01) THEN
#     LET tm.aaw01 = g_aza.aza81
#  END IF 
#FUN-B50001--mod--end#FUN-B90028 (FUN-B50001) rollback
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g012_tm()                # Input print condition
      ELSE CALL g012()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
END MAIN

FUNCTION g012_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,     
          l_sw          LIKE type_file.chr1,     #重要欄位是否空白  
          l_cmd         LIKE type_file.chr1000   
   DEFINE li_chk_bookno   LIKE type_file.num5   
   DEFINE li_result     LIKE type_file.num5    
   DEFINE l_cnt         LIKE type_file.num5 
   DEFINE l_aaa05       LIKE aaa_file.aaa05      #FUN-A90032
   DEFINE l_aznn01_1    LIKE aznn_file.aznn01    #FUN-A90032
   DEFINE l_aznn01_2    LIKE aznn_file.aznn01    #FUN-A90032
   DEFINE l_axz03       LIKE axz_file.axz03      #FUN-AB0091
   
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 11

   END IF
   OPEN WINDOW g012_w AT p_row,p_col
        WITH FORM "agl/42f/aglg012" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()

# END genero shell script ADD
################################################################################
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) 
   END IF
   LET tm.title1 = 'M.T.D.'
   LET tm.title2 = 'Y.T.D.'
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.e = 0
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
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.axa03,tm.aaz641,tm.a,  #FUN-B50001 #FUN-B90028 (FUN-B50001) rollback
    #INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.axa03,tm.aaw01,tm.a,   #FUN-B90028 (FUN-B50001) rollback
#                 tm.title1,tm.yy1,tm.bm1,tm.em1, #FUN-A90032
#                 tm.title2,tm.yy2,tm.bm2,tm.em2, #FUN-A90032
                  tm.yy1,tm.em1,tm.q1,tm.h1, #FUN-A90032
                  tm.yy2,tm.em2,tm.q2,tm.h2, #FUN-A90032
                  tm.e,tm.f,tm.d,tm.c,tm.h,tm.o,tm.r,
                  tm.p,tm.q,tm.more WITHOUT DEFAULTS  
       BEFORE INPUT
          CALL cl_qbe_init()
          CALL g012_set_entry()       #FUN-A90032
          CALL g012_set_no_entry()    #FUN-A90032
       ON ACTION locale
          CALL cl_dynamic_locale()       #FUN-9A0036 add
          CALL cl_show_fld_cont()                   
       # LET g_action_choice = "locale"  #FUN-9A0036 mark
          CALL i012_set_title()       #FUN-A90032

#FUN-A90032 --Begin
#       BEFORE FIELD rtype 
#          CALL g012_set_entry()  
#
#       AFTER FIELD rtype 
#          IF tm.rtype='1' THEN
#             LET tm.bm1=0
#             LET tm.bm2=0
#             CALL g012_set_no_entry()
#          END IF
#FUN-A90032 --End          

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
          CALL g012_set_entry()
          CALL g012_set_no_entry()
          IF tm.axa06 = '1' THEN
              LET tm.q1 = '' 
              LET tm.h1 = '' 
              LET tm.q2 = '' 
              LET tm.h2 = '' 
              LET l_aaa05 = 0
              SELECT aaa05 INTO l_aaa05 FROM aaa_file 
               WHERE aaa01=tm.axa03 
#                AND aaaacti MATCHES '[Yy]'    #No.TQC-B30100 Mark
                 AND aaaacti IN ('Y','y')       #No.TQC-B30100 add
              LET tm.em1 = l_aaa05
              LET tm.em2 = l_aaa05
          END IF
          IF tm.axa06 = '2' THEN
              LET tm.h1 = '' 
              LET tm.em1= '' 
              LET tm.h2 = '' 
              LET tm.em2= '' 
          END IF
          IF tm.axa06 = '3' THEN
              LET tm.em1= '' 
              LET tm.q1 = ''
              LET tm.em2= '' 
              LET tm.q2 = ''
          END IF
          IF tm.axa06 = '4' THEN
              LET tm.em1= '' 
              LET tm.q1 = ''
              LET tm.h1 = ''
              LET tm.em2= '' 
              LET tm.q2 = ''
              LET tm.h2 = ''
          END IF
          DISPLAY BY NAME tm.em1
          DISPLAY BY NAME tm.q1
          DISPLAY BY NAME tm.h1
          DISPLAY BY NAME tm.em2
          DISPLAY BY NAME tm.q2
          DISPLAY BY NAME tm.h2

         AFTER FIELD em2
            CASE tm.em2
               WHEN 1  CALL cl_getmsg('agl-319',g_lang) RETURNING tm.title2
               WHEN 2  CALL cl_getmsg('agl-320',g_lang) RETURNING tm.title2
               WHEN 3  CALL cl_getmsg('agl-321',g_lang) RETURNING tm.title2
               WHEN 4  CALL cl_getmsg('agl-322',g_lang) RETURNING tm.title2
               WHEN 5  CALL cl_getmsg('agl-323',g_lang) RETURNING tm.title2
               WHEN 6  CALL cl_getmsg('agl-324',g_lang) RETURNING tm.title2
               WHEN 7  CALL cl_getmsg('agl-325',g_lang) RETURNING tm.title2
               WHEN 8  CALL cl_getmsg('agl-326',g_lang) RETURNING tm.title2
               WHEN 9  CALL cl_getmsg('agl-327',g_lang) RETURNING tm.title2
               WHEN 10  CALL cl_getmsg('agl-328',g_lang) RETURNING tm.title2
               WHEN 11 CALL cl_getmsg('agl-329',g_lang) RETURNING tm.title2
               WHEN 12 CALL cl_getmsg('agl-330',g_lang) RETURNING tm.title2
               WHEN 13 CALL cl_getmsg('agl-331',g_lang) RETURNING tm.title2
               OTHERWISE LET tm.title2 = ' '
            END CASE

         AFTER FIELD q1
            IF cl_null(tm.q1) AND  tm.axa06 = '2' THEN
               NEXT FIELD q1
            END IF
            IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
               NEXT FIELD q1
            END IF
            LET tm.q2 = tm.q1      #FUN-AB0085
            DISPLAY BY NAME tm.q2  #FUN-AB0085
            CASE tm.q1
               WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title1
               WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title1
               WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title1
               WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title1
               OTHERWISE LET tm.title1 = ' '
            END CASE
            CASE tm.q2
               WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title2
               WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title2
               WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title2
               WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title2
               OTHERWISE LET tm.title2 = ' '
            END CASE

         AFTER FIELD q2
            IF cl_null(tm.q2) AND  tm.axa06 = '2' THEN
               NEXT FIELD q2
            END IF
            IF cl_null(tm.q2) OR tm.q2 NOT MATCHES '[1234]' THEN
               NEXT FIELD q2
            END IF
            CASE tm.q2
               WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title2
               WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title2
               WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title2
               WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title2
               OTHERWISE LET tm.title2 = ' '
            END CASE

         AFTER FIELD h1
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
            CASE tm.h1
               WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title1
               WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title1
               OTHERWISE LET tm.title1 = ' '
            END CASE
            CASE tm.h2
               WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title2
               WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title2
               OTHERWISE LET tm.title2 = ' '
            END CASE
            LET tm.h2 = tm.h1     
            DISPLAY BY NAME tm.h2 
         AFTER FIELD h2
            IF (cl_null(tm.h2) OR tm.h2>2 OR tm.h2<0) AND tm.axa06='4' THEN
               NEXT FIELD h2
            END IF
            CASE tm.h2
               WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title2
               WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title2
               OTHERWISE LET tm.title2 = ' '
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
          SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02
#FUN-A30122 --Begin
#         CALL g012_getdbs()
          CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03      #FUN-A30122 mod g_dbs_axz03 ->g_plant_axz03 by vealxu
          CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641               #FUN-A30122 mod g_dbs_axz03 ->g_plant_axz03 by vealxu   #FUN-B50001#FUN-B90028 (FUN-B50001) rollback
          #CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaw01#FUN-B90028 (FUN-B50001) rollback
#FUN-A30122 --End
          IF cl_null(g_aaz641) THEN   #FUN-B50001 AAZ641->AAW01#FUN-B90028 (FUN-B50001) rollback
             CALL cl_err(g_axz03,'agl-601',1)
             NEXT FIELD axa02
          ELSE
            #FUN-B50001--mod--str--#FUN-B90028 (FUN-B50001) rollback
             LET tm.aaz641= g_aaz641
             DISPLAY BY NAME tm.aaz641
            #LET tm.aaw01= g_aaw01
            #DISPLAY BY NAME tm.aaw01
            #FUN-B50001--mod--end#FUN-B90028 (FUN-B50001) rollback
          END IF


       AFTER FIELD a
          IF tm.a IS NULL THEN NEXT FIELD a END IF
          CALL s_chkmai(tm.a,'RGL') RETURNING li_result
          IF NOT li_result THEN
             CALL cl_err(tm.a,g_errno,1)
             NEXT FIELD a
          END IF
          SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
           WHERE mai01 = tm.a 
             AND mai00 = tm.aaz641  #FUN-B50001 #FUN-B90028 (FUN-B50001) rollback
             #AND mai00 = tm.aaw01#FUN-B90028 (FUN-B50001) rollback
            #AND maiacti MATCHES'[Yy]'
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

      AFTER FIELD aaz641    #FUN-B50001#FUN-B90028 (FUN-B50001) rollback
      #AFTER FIELD aaw01#FUN-B90028 (FUN-B50001) rollback
       # LET g_sql ="SELECT COUNT(*) FROM ",g_dbs_axz03,"aaz_file",    #FUN-A30122 mark by vealxu
#FUN-B50001--mod--str--#FUN-B90028 (FUN-B50001) rollback
         LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_axz03,'aaz_file'),   #FUN-A30122 add by vealxu
                    " WHERE aaz641 = '",tm.aaz641,"'"
#        LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_axz03,'aaw_file'),  
#                   " WHERE aaw01 = '",tm.aaw01,"'"
#FUN-B50001--mod--end#FUN-B90028 (FUN-B50001) rollback
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
         CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql    #FUN-A30122 add
         PREPARE g012_cnt_p FROM g_sql
         DECLARE g012_cnt_c CURSOR FOR g012_cnt_p
         OPEN g012_cnt_c
         FETCH g012_cnt_c INTO l_cnt
         IF cl_null(l_cnt) OR l_cnt=0 THEN
            CALL cl_err('','agl-965',1)
            NEXT FIELD aaz641   #FUN-B50001#FUN-B90028 (FUN-B50001) rollback
            #NEXT FIELD aaw01#FUN-B90028 (FUN-B50001) rollback
         END IF         

      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF

      AFTER FIELD yy1
         IF tm.yy1 IS NULL OR tm.yy1 = 0 THEN
            NEXT FIELD yy1
         END IF
         LET tm.yy2 = tm.yy1-1      #FUN-AB0085
         DISPLAY BY NAME tm.yy2     #FUN-AB0085

#FUN-A90032 --Begin
#      BEFORE FIELD bm1
#         IF tm.rtype='1' THEN
#            LET tm.bm1 = 0 DISPLAY '' TO bm1
#         END IF
#      AFTER FIELD bm1
#         IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
#         IF NOT cl_null(tm.bm1) THEN
#            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = tm.yy1
#            IF g_azm.azm02 = 1 THEN
#               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD bm1
#               END IF
#            ELSE
#               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD bm1
#               END IF
#            END IF
#         END IF
#FUN-A90032 --End         
  
      AFTER FIELD em1
         IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
         LET tm.em2 = tm.em1      #FUN-AB0085
         DISPLAY BY NAME tm.em2   #FUN-AB0085
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
#         IF tm.bm1 > tm.em1 THEN CALL cl_err('','9011',0) NEXT FIELD bm1 END IF  #FUN-A90032 mark
#---------FUN-A90032 mark-----
#         IF tm.yy2 IS NULL THEN  
#            LET tm.yy2 = tm.yy1
#            LET tm.bm2 = tm.bm1
#            LET tm.em2 = 12
#           DISPLAY BY NAME tm.yy2,tm.bm2,tm.em2 #FUN-A90032
#           DISPLAY BY NAME tm.yy2,tm.em2        #FUN-A90032
#         END IF                                
#---------FUN-A90032 mark-----
         #--FUN-A90032 start--
         CASE tm.em1
            WHEN 1  CALL cl_getmsg('agl-319',g_lang) RETURNING tm.title1
            WHEN 2  CALL cl_getmsg('agl-320',g_lang) RETURNING tm.title1
            WHEN 3  CALL cl_getmsg('agl-321',g_lang) RETURNING tm.title1
            WHEN 4  CALL cl_getmsg('agl-322',g_lang) RETURNING tm.title1
            WHEN 5  CALL cl_getmsg('agl-323',g_lang) RETURNING tm.title1
            WHEN 6  CALL cl_getmsg('agl-324',g_lang) RETURNING tm.title1
            WHEN 7  CALL cl_getmsg('agl-325',g_lang) RETURNING tm.title1
            WHEN 8  CALL cl_getmsg('agl-326',g_lang) RETURNING tm.title1
            WHEN 9  CALL cl_getmsg('agl-327',g_lang) RETURNING tm.title1
            WHEN 10  CALL cl_getmsg('agl-328',g_lang) RETURNING tm.title1
            WHEN 11 CALL cl_getmsg('agl-329',g_lang) RETURNING tm.title1
            WHEN 12 CALL cl_getmsg('agl-330',g_lang) RETURNING tm.title1
            WHEN 13 CALL cl_getmsg('agl-331',g_lang) RETURNING tm.title1
            OTHERWISE LET tm.title1 = ' '
         END CASE
         CASE tm.em2
            WHEN 1  CALL cl_getmsg('agl-319',g_lang) RETURNING tm.title2
            WHEN 2  CALL cl_getmsg('agl-320',g_lang) RETURNING tm.title2
            WHEN 3  CALL cl_getmsg('agl-321',g_lang) RETURNING tm.title2
            WHEN 4  CALL cl_getmsg('agl-322',g_lang) RETURNING tm.title2
            WHEN 5  CALL cl_getmsg('agl-323',g_lang) RETURNING tm.title2
            WHEN 6  CALL cl_getmsg('agl-324',g_lang) RETURNING tm.title2
            WHEN 7  CALL cl_getmsg('agl-325',g_lang) RETURNING tm.title2
            WHEN 8  CALL cl_getmsg('agl-326',g_lang) RETURNING tm.title2
            WHEN 9  CALL cl_getmsg('agl-327',g_lang) RETURNING tm.title2
            WHEN 10  CALL cl_getmsg('agl-328',g_lang) RETURNING tm.title2
            WHEN 11 CALL cl_getmsg('agl-329',g_lang) RETURNING tm.title2
            WHEN 12 CALL cl_getmsg('agl-330',g_lang) RETURNING tm.title2
            WHEN 13 CALL cl_getmsg('agl-331',g_lang) RETURNING tm.title2
            OTHERWISE LET tm.title2 = ' '
         END CASE
         #--FUN-A90032 end--

      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
            NEXT FIELD d
         END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF

      AFTER FIELD e
         IF tm.e < 0 THEN
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
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)   
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
         IF tm.yy1 IS NULL THEN 
            LET l_sw = 0 
            DISPLAY BY NAME tm.yy1 
            CALL cl_err('',9033,0)
        END IF
#FUN-A90032 --Begin
#         IF tm.bm1 IS NULL THEN 
#            LET l_sw = 0 
#            DISPLAY BY NAME tm.bm1 
#        END IF
#         IF tm.em1 IS NULL THEN 
#            LET l_sw = 0 
#            DISPLAY BY NAME tm.em1 
#        END IF
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
                      LET tm.bm1 = 0
                      LET tm.bm2 = 0
             #FUN-AB0091 -------add start--------------
             OTHERWISE
                 CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03
                 CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy1,tm.q1,tm.h1) RETURNING tm.em1
                 CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy2,tm.q2,tm.h2) RETURNING tm.em2
                 IF tm.axa06 = '4' THEN
                    IF tm.rtype = '1' THEN
                       LET tm.bm1 = 0
                       LET tm.bm2 = 0
                    ELSE
                       LET tm.bm1 = 1
                       LET tm.bm2 = 1
                    END IF
                 END IF
             #FUN-AB0091 -------add end-------------- 
             END CASE
         END IF
       #--FUN-A90032  

################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLP
         IF (INFIELD(axa01) OR INFIELD(axa02)) THEN         
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
         END IF 
         IF INFIELD(a) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_mai'
            LET g_qryparam.default1 = tm.a
            LET g_qryparam.where = " mai00 = '",tm.aaz641,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
           #LET g_qryparam.where = " mai00 = '",tm.aaz641,"'"  #FUN-B50001 #FUN-B90028 (FUN-B50001) rollback   #No.TQC-C50042   Mark
           #LET g_qryparam.where = " mai00 = '",tm.aaw01,"'"  #FUN-B90028 (FUN-B50001) rollback
            CALL cl_create_qry() RETURNING tm.a
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
# FUN-B50001--mod--str--#FUN-B90028 (FUN-B50001) rollback
         IF INFIELD(aaz641) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.aaz641
            CALL cl_create_qry() RETURNING tm.aaz641 
            DISPLAY BY NAME tm.aaz641
            NEXT FIELD aaz641
         END IF
#        IF INFIELD(aaw01) THEN
#           CALL cl_init_qry_var()
#           LET g_qryparam.form = 'q_aaa'
#           LET g_qryparam.default1 = tm.aaw01
#           CALL cl_create_qry() RETURNING tm.aaw01
#           DISPLAY BY NAME tm.aaw01
#           NEXT FIELD aaw01
#        END IF
#FUN-B50001--mod--end#FUN-B90028 (FUN-B50001) rollback
         IF INFIELD(p) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_azi'
            LET g_qryparam.default1 = tm.p
            CALL cl_create_qry() RETURNING tm.p
            DISPLAY BY NAME tm.p
            NEXT FIELD p
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g012_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg012'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg012','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.rtype CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.aaz641 CLIPPED,"'", #FUN-B50001 #FUN-B90028 (FUN-B50001) rollback
                         #" '",tm.aaw01 CLIPPED,"'", #FUN-B90028 (FUN-B50001) rollback 
                         " '",tm.title1 CLIPPED,"'",   
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.bm1 CLIPPED,"'",
                         " '",tm.em1 CLIPPED,"'",
                         " '",tm.title2 CLIPPED,"'",  
                         " '",tm.yy2 CLIPPED,"'",   
                         " '",tm.bm2 CLIPPED,"'",  
                         " '",tm.em2 CLIPPED,"'", 
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
                         " '",g_template CLIPPED,"'",         
                         " '",g_rpt_name CLIPPED,"'"         
         CALL cl_cmdat('aglg012',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g012_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g012()
   ERROR ""
END WHILE
   CLOSE WINDOW g012_w
END FUNCTION

FUNCTION g012()
   DEFINE l_name     LIKE type_file.chr20     # External(Disk) file name
   DEFINE l_sql      LIKE type_file.chr1000   # RDSQL STATEMENT   
   DEFINE l_chr      LIKE type_file.chr1    
   DEFINE amt1,amt2  LIKE axh_file.axh08
   DEFINE amt3       LIKE axh_file.axh08
   DEFINE maj        RECORD LIKE maj_file.*
   DEFINE sr         RECORD
                       bal1      LIKE axh_file.axh08,
                       bal2      LIKE axh_file.axh08,
                       bal3      LIKE axh_file.axh08
                     END RECORD
   DEFINE l_endy1   LIKE abb_file.abb07
   DEFINE l_endy2   LIKE abb_file.abb07

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.aaz641    #FUN-B50001#FUN-B90028 (FUN-B50001) rollback
    #WHERE aaf01 = tm.aaw01#FUN-B90028 (FUN-B50001) rollback
      AND aaf02 = g_rlang

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 

   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g012_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
      EXIT PROGRAM 
   END IF
   DECLARE g012_c CURSOR FOR g012_p
   #FUN-C50004 sta
   LET g_sql="SELECT SUM(axh08-axh09)",
             "  FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),  
             " WHERE axh00 = '",tm.aaz641,"'",  
             "   AND axh00 = aag00 ",
             "   AND axh01 = '",tm.axa01,"'",
             "   AND axh02 = '",tm.axa02,"'",
             "   AND axh03 = '",tm.axa03,"'",     
             "   AND axh05 BETWEEN ? AND ? ",
             "   AND axh06 = ",tm.yy1," AND axh07 = ",tm.em1, 
             "   AND axh05 = aag01 AND aag07 !='1'",
             "   AND axh12 = '",x_aaa03,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql     
   PREPARE sel_axh_pre FROM g_sql
   DECLARE sel_axh_cs CURSOR FOR sel_axh_pre   

   LET g_sql="SELECT SUM(axh08-axh09)",
             "  FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),   
             " WHERE axh00 = '",tm.aaz641,"'",   
             "   AND aag00 = axh00 ",
             "   AND axh01 = '",tm.axa01,"'",
             "   AND axh02 = '",tm.axa02,"'",
             "   AND axh03 = '",tm.axa03,"'",    
             "   AND axh05 BETWEEN ? AND ? ",
             "   AND axh06 = ",tm.yy2," AND axh07 = ",tm.em2,  
             "   AND axh05 = aag01 AND aag07 !='1' ",
             "   AND axh12 = '",x_aaa03,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
        CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql       
        PREPARE sel_amt_pre FROM g_sql
        DECLARE sel_amt_cs CURSOR FOR sel_amt_pre   
   #FUN-C50004 end

   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot2[g_i] = 0 END FOR
   FOR g_i = 1 TO 100 LET g_tot3[g_i] = 0 END FOR 

   FOREACH g012_c INTO maj.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     LET amt1 = 0 LET amt2 = 0 LET amt3 = 0 
     IF NOT cl_null(maj.maj21) THEN
        #FUN-C50004 mark sta
        #LET g_sql="SELECT SUM(axh08-axh09)",
        #         #"  FROM axh_file,",g_dbs_axz03,"aag_file",   #FUN-A30122 mark by velaxu
        #          "  FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),   #FUN-A30122 mark by vealxu
        #          " WHERE axh00 = '",tm.aaz641,"'",   #FUN-B50001#FUN-B90028 (FUN-B50001) rollback
        #          #" WHERE axh00 = '",tm.aaw01,"'",#FUN-B90028 (FUN-B50001) rollback
        #          "   AND axh00 = aag00 ",
        #          "   AND axh01 = '",tm.axa01,"'",
        #          "   AND axh02 = '",tm.axa02,"'",
        #          "   AND axh03 = '",tm.axa03,"'",     
        #          "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
#       #          "   AND axh06 = '",tm.yy1,"' AND axh07 BETWEEN '",tm.bm1,"' AND '",tm.em1,"'", #FUN-A90032 
        #          "   AND axh06 = ",tm.yy1," AND axh07 = ",tm.em1, #FUN-A90032
        #          "   AND axh05 = aag01 AND aag07 !='1'",
        #          "   AND axh12 = '",x_aaa03,"'"
        #CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
        #CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql     #FUN-A30122 add by vealxu
        #PREPARE sel_axh_pre FROM g_sql
        #DECLARE sel_axh_cs CURSOR FOR sel_axh_pre

        #OPEN sel_axh_cs
        #FUN-C50004 mark end
        OPEN sel_axh_cs USING maj.maj21,maj.maj22 #FUN-C50004 add
        FETCH sel_axh_cs INTO amt1
        IF STATUS THEN CALL cl_err('sel amt1:',STATUS,1) EXIT FOREACH END IF
        IF amt1 IS NULL THEN LET amt1 = 0 END IF
     END IF
     IF NOT cl_null(maj.maj21) AND tm.yy2 IS NOT NULL THEN
        #FUN-C50004 mark sta
        #LET g_sql="SELECT SUM(axh08-axh09)",
                 #"  FROM axh_file,",g_dbs_axz03,"aag_file",   #FUN-A30122 mark by vealxu
        #          "  FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),   #FUN-A30122 add by vealxu
        #          " WHERE axh00 = '",tm.aaz641,"'",   #FUN-B50001#FUN-B90028 (FUN-B50001) rollback
                  #" WHERE axh00 = '",tm.aaw01,"'",#FUN-B90028 (FUN-B50001) rollback
        #          "   AND aag00 = axh00 ",
        #          "   AND axh01 = '",tm.axa01,"'",
        #          "   AND axh02 = '",tm.axa02,"'",
        #          "   AND axh03 = '",tm.axa03,"'",    
        #          "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
#                 "   AND axh06 = '",tm.yy2,"' AND axh07 BETWEEN '",tm.bm2,"' AND '",tm.em2,"'", #FUN-A90032
        #          "   AND axh06 = ",tm.yy2," AND axh07 = ",tm.em2,    #FUN-A90032
        #          "   AND axh05 = aag01 AND aag07 !='1' ",
        #          "   AND axh12 = '",x_aaa03,"'"
        #CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
        #CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql       #FUN-A30122 add by vealxu
        #PREPARE sel_amt_pre FROM g_sql
        #DECLARE sel_amt_cs CURSOR FOR sel_amt_pre
        #OPEN sel_amt_cs 
        #FUN-C50004 mark end
        OPEN sel_amt_cs USING maj.maj21,maj.maj22 #FUN-C50004 add
        FETCH sel_amt_cs INTO amt2
        IF STATUS THEN CALL cl_err('sel amt2:',STATUS,1) EXIT FOREACH END IF
        IF amt2 IS NULL THEN LET amt2 = 0 END IF
     END IF
     IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF #匯率的轉換
     IF tm.o = 'Y' THEN LET amt2 = amt2 * tm.q END IF #匯率的轉換
     LET amt3 = amt1 - amt2    
     IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0      #合計階數處理
       #CHI-A70050---modify---start---
       #THEN FOR i = 1 TO 100 LET g_tot1[i]=g_tot1[i]+amt1 END FOR
       #     FOR i = 1 TO 100 LET g_tot2[i]=g_tot2[i]+amt2 END FOR
       #     FOR i = 1 TO 100 LET g_tot3[i]=g_tot3[i]+amt3 END FOR 
        THEN FOR i = 1 TO 100 
              IF maj.maj09 = '-' THEN
                 LET g_tot1[i] = g_tot1[i] - amt1
                 LET g_tot2[i] = g_tot2[i] - amt2 
                 LET g_tot3[i] = g_tot3[i] - amt3 
              ELSE
                 LET g_tot1[i] = g_tot1[i] + amt1
                 LET g_tot2[i] = g_tot2[i] + amt2 
                 LET g_tot3[i] = g_tot3[i] + amt3 
              END IF
        END FOR
       #CHI-A70050---modify---end---
             LET k=maj.maj08  LET sr.bal1=g_tot1[k] LET sr.bal2=g_tot2[k]
                              LET sr.bal3=g_tot3[k]               
            #CHI-A70050---add---start---
             IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
                LET sr.bal1 = sr.bal1 *-1
                LET sr.bal2 = sr.bal2 *-1
                LET sr.bal3 = sr.bal3 *-1
             END IF
            #CHI-A70050---add---end---
             FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
             FOR i = 1 TO maj.maj08 LET g_tot2[i]=0 END FOR
             FOR i = 1 TO maj.maj08 LET g_tot3[i]=0 END FOR      
        ELSE 
        IF maj.maj03='5' THEN
            LET sr.bal1=amt1
            LET sr.bal2=amt2
            LET sr.bal3=amt3 
        ELSE
            LET sr.bal1=NULL        
            LET sr.bal2=NULL       
            LET sr.bal3=NULL 
        END IF
     END IF
     IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
        LET g_basetot1=sr.bal1
        LET g_basetot2=sr.bal2
        LET g_basetot3=sr.bal3
        IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
        IF maj.maj07='2' THEN LET g_basetot2=g_basetot2*-1 END IF
        IF maj.maj07='2' THEN LET g_basetot3=g_basetot3*-1 END IF 
     END IF
     IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
     IF (tm.c='N' OR maj.maj03='2') AND
        maj.maj03 MATCHES "[0125]" AND sr.bal1=0 AND sr.bal2=0 THEN 
        CONTINUE FOREACH                        #餘額為 0 者不列印
     END IF
     IF tm.f>0 AND maj.maj08 < tm.f THEN
        CONTINUE FOREACH                        #最小階數起列印
     END IF

     IF maj.maj07 = '2' THEN
        LET sr.bal1 = sr.bal1 * -1
        LET sr.bal2 = sr.bal2 * -1
     END IF
  
     LET sr.bal3 = sr.bal1 - sr.bal2
  
     LET maj.maj20 = maj.maj05 SPACES,maj.maj20 CLIPPED
  
     IF tm.h = 'Y' THEN
        LET maj.maj20 = maj.maj20e
     END IF
  
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
     EXECUTE insert_prep USING
        maj.maj01,maj.maj02,maj.maj03,maj.maj04,maj.maj05,
        maj.maj06,maj.maj07,maj.maj08,maj.maj09,maj.maj10,
        maj.maj11,maj.maj20,maj.maj20e,maj.maj21,maj.maj22,
        maj.maj23,maj.maj24,maj.maj25,maj.maj26,maj.maj27,
        maj.maj28,maj.maj29,maj.maj30,'2',sr.bal1,sr.bal2,sr.bal3, #CHI-A70061 add '2'
        g_azi03,g_azi04,g_azi05
     #CHI-A70061 add --start--
     IF maj.maj04 > 0 THEN
        #空行的部份,以寫入同樣的maj20資料列進Temptable,
        #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
        #讓空行的這筆資料排在正常的資料前面印出
        FOR i = 1 TO maj.maj04
           EXECUTE insert_prep USING
              maj.maj01,maj.maj02,maj.maj03,maj.maj04,maj.maj05,
              maj.maj06,maj.maj07,maj.maj08,maj.maj09,maj.maj10,
              maj.maj11,maj.maj20,maj.maj20e,maj.maj21,maj.maj22,
              maj.maj23,maj.maj24,maj.maj25,maj.maj26,maj.maj27,
              maj.maj28,maj.maj29,maj.maj30,'1',sr.bal1,sr.bal2,sr.bal3,
              g_azi03,g_azi04,g_azi05
           IF STATUS THEN
              CALL cl_err("execute insert_prep:",STATUS,1)
              EXIT FOR
           END IF
        END FOR
     END IF
     #CHI-A70061 add --end--

   END FOREACH
   IF cl_null(g_basetot1) THEN LET g_basetot1 = 0 END IF
   IF cl_null(g_basetot2) THEN LET g_basetot2 = 0 END IF
   IF cl_null(g_basetot3) THEN LET g_basetot3 = 0 END IF

   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
   LET g_str = NULL
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
###GENGRE###   LET g_str = g_str,";",
###GENGRE###               tm.title1,";",tm.yy1,";",tm.bm1 USING '&&',";",tm.em1 USING '&&',";",
###GENGRE###               tm.title2,";",tm.yy2,";",tm.bm2 USING '&&',";",tm.em2 USING '&&',";",
###GENGRE###               tm.a,";",tm.d,";",tm.e,";",tm.h,";",tm.p,";",
###GENGRE###               g_mai02,";",g_basetot1,";",g_basetot2,";",g_basetot3
  
###GENGRE###   CALL cl_prt_cs3('aglg012','aglg012',l_sql,g_str)   
    CALL aglg012_grdata()    ###GENGRE###


END FUNCTION

FUNCTION g012_set_entry() 
#FUN-A90032 --Begin
#    IF INFIELD(rtype) THEN
#      CALL cl_set_comp_entry("bm1,bm2",TRUE)
#    END IF 
     CALL cl_set_comp_entry("q1,em1,h1",TRUE)           
#FUN-A90032 --End
END FUNCTION

FUNCTION g012_set_no_entry()
#FUN-A90032 --Begin
#    IF INFIELD(rtype) AND tm.rtype='1' THEN
#      CALL cl_set_comp_entry("bm1,bm2",FALSE)
#    END IF 
   IF tm.axa06 ="1" THEN
      CALL cl_set_comp_entry("q1,h1,q2,h2",FALSE)
   END IF
   IF tm.axa06 ="2" THEN
      CALL cl_set_comp_entry("em1,h1,em2,h2",FALSE)
   END IF
   IF tm.axa06 ="3" THEN
      CALL cl_set_comp_entry("em1,q1,em2,q2",FALSE)
   END IF
   IF tm.axa06 ="4" THEN
      CALL cl_set_comp_entry("q1,em1,h1,q2,em2,h2",FALSE)
   END IF
#FUN-A90032 --End

END FUNCTION

#FUN-A90032 --Begin
FUNCTION i012_set_title()
   CASE tm.axa06
      WHEN 2
         CASE tm.q1
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title1
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title1
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title1
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title1
         END CASE
         CASE tm.q2
            WHEN 1  CALL cl_getmsg('agl-304',g_lang) RETURNING tm.title2
            WHEN 2  CALL cl_getmsg('agl-305',g_lang) RETURNING tm.title2
            WHEN 3  CALL cl_getmsg('agl-306',g_lang) RETURNING tm.title2
            WHEN 4  CALL cl_getmsg('agl-307',g_lang) RETURNING tm.title2
         END CASE
      WHEN 3
         CASE tm.h2
            WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title2
            WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title2
         END CASE
         CASE tm.h1
            WHEN 1  CALL cl_getmsg('agl-308',g_lang) RETURNING tm.title1
            WHEN 2  CALL cl_getmsg('agl-309',g_lang) RETURNING tm.title1
         END CASE
         OTHERWISE LET tm.title1 = ' ' LET tm.title2 = ' '
      END CASE
END FUNCTION
#FUN-A90032 --End

#FUN-A30122 --Begin
#FUNCTION g012_getdbs()
#DEFINE  l_cnt    LIKE type_file.num5
#DEFINE  l_axa02  LIKE axa_file.axa02
#DEFINE  l_axa02_cnt  LIKE type_file.num5
#　	　	　
#  #判斷是否合并會科獨立(axa09)
#  #IF axa09 = 'Y' 則取axa02的上層公司，代表合并帳別建立于上層公司
#  #IF axa09 = 'N' 則取目前所在DB
#  #抓出axa09值判斷Y/N
#      SELECT axa09 INTO g_axa09 FROM axa_file
#       WHERE axa01 = tm.axa01
#         AND axa02 = tm.axa02        #上層公司編號
#      IF g_axa09 = 'N' THEN          #合并會科不獨立
#          SELECT azp03 INTO g_dbs_new FROM azp_file
#           WHERE azp01 = g_plant
#          LET g_dbs_axz03 = s_dbstring(g_dbs_new CLIPPED)
#      ELSE	　
#          SELECT axz03               #上層公司數據庫
#            INTO g_axz03
#            FROM axz_file
#            WHERE axz01 = tm.axa02
#          SELECT azp03 INTO g_dbs_new FROM azp_file
#           WHERE azp01 = g_axz03
#          IF STATUS THEN
#             LET g_dbs_new = NULL
#          END IF	　
#          LET g_dbs_axz03 = s_dbstring(g_dbs_new CLIPPED)
#      END IF	　
#  LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#              " WHERE aaz00 = '0'"
#  PREPARE g012_pre_11 FROM g_sql
#  DECLARE g012_cur_11 CURSOR FOR g012_pre_11
#  OPEN g012_cur_11
#  FETCH g012_cur_11 INTO g_aaz641
#END FUNCTION	　
#FUN-A30122 --End
#FUN-9A0036  

###GENGRE###START
FUNCTION aglg012_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg012")
        IF handler IS NOT NULL THEN
            START REPORT aglg012_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY maj02,line"    #FUN-B90028 add
          
            DECLARE aglg012_datacur1 CURSOR FROM l_sql
            FOREACH aglg012_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg012_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg012_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg012_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-B90028-------STAR-------
   DEFINE sr         RECORD
                       bal1      LIKE axh_file.axh08,
                       bal2      LIKE axh_file.axh08,
                       bal3      LIKE axh_file.axh08
                     END RECORD
    DEFINE l_unit    STRING
    DEFINE l_date1   STRING
    DEFINE l_date2   STRING
    DEFINE l_bal1    LIKE axh_file.axh08
    DEFINE l_bal2    LIKE axh_file.axh08
    DEFINE l_per1    LIKE axh_file.axh08
    DEFINE l_bal3    LIKE axh_file.axh08
    DEFINE l_per2    LIKE axh_file.axh08
    DEFINE l_per3    LIKE axh_file.axh08
    DEFINE l_per_1   LIKE axh_file.axh08
    DEFINE l_per_2   LIKE axh_file.axh08
    DEFINE l_fmt     STRING

#FUN-B90028-------END---------  

    ORDER EXTERNAL BY sr1.maj02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name    #FUN-B90028 add g_ptime,g_used_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.maj02
            #FUN-B90028-------STAR-------
            LET l_unit = cl_gr_getmsg("gre-208",g_lang,tm.d)
            PRINTX l_unit
            LET l_date1 = tm.yy1,'/',tm.bm1 USING '&&','-',tm.em1 USING '&&'
            PRINTX l_date1
            LET l_date2 = tm.yy2,'/',tm.bm2 USING '&&','-',tm.em2 USING '&&'
            PRINTX l_date2
            #FUN-B90028-------END---------
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B90028-------STAR-------
            CASE tm.d
               WHEN '1'
                  LET l_bal1 = sr1.bal1/1
               WHEN '2'
                  LET l_bal1 = sr1.bal1/1000
               WHEN '3'
                  LET l_bal1 = sr1.bal1/1000000
            END CASE
            PRINTX l_bal1

            IF NOT cl_null(l_bal1) THEN
               IF NOT cl_null(g_basetot1) AND sr1.bal1 != 0 AND g_basetot1 != 0 AND NOT cl_null(sr1.bal1) THEN
                  LET l_per_1 = g_basetot1
                  LET l_per1 = (sr1.bal1/l_per_1)*100 USING '###.&&'
               ELSE
                LET l_per1 = 0
               END IF
            ELSE
               LET l_per1 = NULL
            END IF
            PRINTX l_per1


            CASE tm.d
               WHEN '1'
                  LET l_bal2 = sr1.bal2/1
               WHEN '2'
                  LET l_bal2 = sr1.bal2/1000
               WHEN '3'
                  LET l_bal2 = sr1.bal2/1000000
            END CASE
            PRINTX l_bal2

            IF NOT cl_null(l_bal2) THEN
               IF NOT cl_null(g_basetot2) AND sr1.bal2 != 0 AND g_basetot2 != 0 AND NOT cl_null(sr1.bal2) THEN
                  LET l_per_2 = g_basetot2
                  LET l_per2 = (sr1.bal2/l_per_2)*100 USING '###.&&'
               ELSE
                  LET l_per2 = 0
               END IF
            ELSE
               LET l_per2 = NULL
            END IF
            PRINTX l_per2
            LET l_fmt = cl_gr_numfmt("axh_file","axh08",tm.e)
            PRINTX l_fmt

            CASE tm.d
               WHEN '1'
                  LET l_bal3 = sr1.bal3/1
               WHEN '2'
                  LET l_bal3 = sr1.bal3/1000
               WHEN '3'
                  LET l_bal3 = sr1.bal3/1000000
            END CASE
            PRINTX l_bal3
    
            IF NOT cl_null(l_bal3) THEN
               IF sr1.bal2 != 0 THEN 
                  LET l_per3 = (sr1.bal3/sr1.bal2) * 100 
               ELSE
                  LET l_per3 = 0
               END IF
            ELSE
               LET l_per3 = NULL
            END IF
            PRINTX l_per3
            PRINTX g_mai02
            #FUN-B90028--------END------

            PRINTX sr1.*

        AFTER GROUP OF sr1.maj02

        
        ON LAST ROW

END REPORT
###GENGRE###END

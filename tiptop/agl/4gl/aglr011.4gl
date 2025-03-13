# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr011.4gl
# Descriptions...: 合并后帳戶式資產負債表
# Date & Author..: 10/08/10 FUN-9A0036  By vealxu 
# Modify.........: No.FUN-A30122 10/04/07 By vealxu 1、合并帳別/合并資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No.MOD-A70060 10/07/08 By Dido 合併帳別變數有誤 
# Modify.........: No:CHI-A60013 10/07/19 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: No:CHI-A70046 10/08/04 By Summer 百分比需依金額單位顯示
# Modify.........: No:CHI-A70061 10/08/25 By Summer 先列印空白再列印資料
# Modify.........: No.FUN-A50102 10/09/28 By vealxu 跨db处理 
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:MOD-AB0198 10/10/22 By Dido 微調清空位置 
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.MOD-B80133 11/08/15 By Polly 報表排序問題,CR Temptable增加l_n來排序
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006
DEFINE tm  RECORD
            axa01  LIKE axa_file.axa01,        #族群編號
            axa02  LIKE axa_file.axa02,        #上層公司編號
            b      LIKE aaa_file.aaa01,        #帳別編號    
            aaz641 LIKE aaz_file.aaz641,       #合并帳別
            a      LIKE mai_file.mai01,        #報表結構編號     
            yy     LIKE type_file.num5,        #輸入年度  
            axa06  LIKE axa_file.axa06,        #FUN-A90032   
            bm     LIKE type_file.num5,        #Begin 期別
            em     LIKE type_file.num5,        #FUN-A90032
            q1     LIKE type_file.chr1,        #FUN-A90032
            h1     LIKE type_file.chr1,        #FUN-A90032  
            e      LIKE type_file.num5,        #小數位數     
            f      LIKE type_file.num5,        #列印最小階數
            d      LIKE type_file.chr1,        #金額單位
            c      LIKE type_file.chr1,        #異動額及餘額為0者是否列印   
            h      LIKE type_file.chr4,        #額外說明類別  
            o      LIKE type_file.chr1,        #轉換幣別否   
            r      LIKE azi_file.azi01,        #幣別    
            p      LIKE azi_file.azi01,        #幣別
            q      LIKE azj_file.azj03,        #匯率
            more   LIKE type_file.chr1         #Input more condition(Y/N) 
           END RECORD,
       i,j,k      LIKE type_file.num5,       
       g_unit     LIKE type_file.num10,       #金額單位基數  
       l_row      LIKE type_file.num5,                      
       r_row      LIKE type_file.num5,                     
       g_bookno   LIKE axh_file.axh00,        #帳別
       g_mai02    LIKE mai_file.mai02,
       g_mai03    LIKE mai_file.mai03,
       g_tot1     ARRAY[100] OF LIKE type_file.num20_6,   
       g_basetot1 LIKE axh_file.axh08
DEFINE g_aaa03    LIKE aaa_file.aaa03   
DEFINE g_i        LIKE type_file.num5         #count/index for any purpose  
DEFINE l_table    STRING              
DEFINE g_sql      STRING             
DEFINE g_str      STRING            
DEFINE g_aaz641   LIKE aaz_file.aaz641
DEFINE g_axz03    LIKE axz_file.axz03
DEFINE g_dbs_axz03 STRING
DEFINE g_plant_axz03 LIKE type_file.chr21   #FUN-A30122 add by vealxu 
DEFINE g_axa09    LIKE axa_file.axa09
DEFINE g_axa05    LIKE axa_file.axa05      #FUN-A90032

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

   LET g_sql = "maj20_l.type_file.chr50,",
               "bal_l.type_file.num20_6,",  
               "per_l.type_file.num20_6,", 
               "maj03_l.maj_file.maj03,",
               "maj02_l.maj_file.maj02,",
               "line_l.type_file.num5,",  
               "maj20_r.type_file.chr50,",
               "bal_r.type_file.num20_6,",  
               "per_r.type_file.num20_6,", 
               "maj03_r.maj_file.maj03,",
               "maj02_r.maj_file.maj02,",
               "line_r.type_file.num5,",    
               "l_n.type_file.num5"         #No.MOD-B80133 add
               
   LET l_table = cl_prt_temptable('aglr011',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"        #No.MOD-B80133 add ?   
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
  
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.yy = ARG_VAL(10)
#  LET tm.bm = ARG_VAL(11)   #FUN-A90032
   LET tm.axa06= ARG_VAL(11) #FUN-A90032
   LET tm.c  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.f  = ARG_VAL(15)
   LET tm.h  = ARG_VAL(16)
   LET tm.o  = ARG_VAL(17)
   LET tm.p  = ARG_VAL(18)
   LET tm.q  = ARG_VAL(19)
   LET tm.r  = ARG_VAL(20)  
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24) 
   LET tm.q1 = ARG_VAL(25)   #FUN-A90032
   LET tm.h1 = ARG_VAL(26)   #FUN-A90032 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.aaz641) THEN LET tm.aaz641 = g_aza.aza81 END IF    
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r011_tm()                   # Input print condition
      ELSE CALL r011()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r011_tm()
   DEFINE p_row,p_col    LIKE type_file.num5     
   DEFINE l_sw           LIKE type_file.chr1      #重要欄位是否空白  
   DEFINE l_cmd          LIKE type_file.chr1000   
   DEFINE li_chk_bookno  LIKE type_file.num5     
   DEFINE li_result      LIKE type_file.num5    
   DEFINE l_aaa03        LIKE aaa_file.aaa03   
   DEFINE l_azi05        LIKE azi_file.azi05  
   DEFINE l_cnt          LIKE type_file.num5 
   DEFINE l_aaa05        LIKE aaa_file.aaa05   #FUN-A90032
   DEFINE l_aznn01       LIKE aznn_file.aznn01 #FUN-A90032
   DEFINE l_axz03        LIKE axz_file.axz03   #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)

    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 11
   END IF

   OPEN WINDOW r011_w AT p_row,p_col WITH FORM "agl/42f/aglr011"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別                                                                                                              
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno                                                                   
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   
   END IF              
   LET tm.c = 'N'
   LET tm.e = 2
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.q = 1
   LET tm.p = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      LET l_row=0
      LET r_row=0
      LET l_sw = 1
      INPUT BY NAME tm.axa01,tm.axa02,tm.b,tm.aaz641,
#              tm.a,tm.yy,tm.bm,tm.e,tm.f,                #FUN-A90032 mark
               tm.a,tm.yy,tm.em,tm.q1,tm.h1,tm.e,tm.f,    #FUN-A90032   
               tm.d,tm.c,tm.h,tm.o,tm.r,
               tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_init()
#FUN-A90032 --Begin
            CALL r011_set_entry()
            CALL r011_set_no_entry()
#FUN-A90032 --End

         ON ACTION locale
           #LET g_action_choice = "locale"   #FUN-9A0036 mark
            CALL cl_dynamic_locale()         #FUN-9A0036 add  
            CALL cl_show_fld_cont()                

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
            CALL r011_set_entry()
            CALL r011_set_no_entry()
            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET l_aaa05 = 0
                SELECT aaa05 INTO l_aaa05 FROM aaa_file 
                 WHERE aaa01=tm.b 
#                  AND aaaacti MATCHES '[Yy]'    #No.TQC-B30100 Mark
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

         AFTER FIELD axa02
            IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
            SELECT COUNT(*) INTO l_cnt FROM axa_file
             WHERE axa01=tm.axa01 AND axa02=tm.axa02
            IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
            IF l_cnt <=0  THEN
               CALL cl_err(tm.axa02,'agl-223',0)
               NEXT FIELD axa02
            ELSE
               SELECT axa03 INTO tm.b FROM axa_file
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               DISPLAY BY NAME tm.b
            END IF
#FUN-A30122 --Begin
#           CALL r011_getdbs()
           #CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03    #FUN-A30122 mod by vealxu
            CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03  #FUN-A30122 add by vealxu 
           #CALL s_get_aaz641(g_dbs_axz03) RETURNING tm.aaz641            #MOD-A70060 mark
           #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641             #MOD-A70060 #FUN-A30122  mark by vealxu
            CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641           #FUN-A30122 add by velaxu
  
#FUN-A30122 --End
            IF cl_null(g_aaz641) THEN
               CALL cl_err(g_axz03,'agl-601',1)
               NEXT FIELD axa02
            ELSE
               LET tm.aaz641 = g_aaz641
               DISPLAY BY NAME tm.aaz641
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
               AND mai00 = tm.aaz641    
             # AND maiacti MATCHES'[Yy]'   #FUN-9A0036
               AND maiacti IN ('Y','y')    #FUN-9A0036 
            IF STATUS THEN 
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)  
               NEXT FIELD a
            END IF

         AFTER FIELD aaz641
          # LET g_sql ="SELECT COUNT(*) FROM ",g_dbs_axz03,"aaz_file",      #FUN-A50102 mark
             LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_axz03,'aaz_file'), #FUN-A50102 
                       " WHERE aaz641 = '",tm.aaz641,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
            CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql   #FUN-A50102 add
            PREPARE r011_cnt_p FROM g_sql
            DECLARE r011_cnt_c CURSOR FOR r011_cnt_p
            OPEN r011_cnt_c
            FETCH r011_cnt_c INTO l_cnt
            IF cl_null(l_cnt) OR l_cnt=0 THEN
               CALL cl_err('','agl-965',1)
               NEXT FIELD aaz641
            END IF   

         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF

         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF

#FUN-A90032 --Begin
#         AFTER FIELD bm
#            IF NOT cl_null(tm.bm) THEN
#               SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                 WHERE azm01 = tm.yy
#               IF g_azm.azm02 = 1 THEN
#                  IF tm.bm > 12 OR tm.bm < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD bm
#                  END IF
#               ELSE
#                  IF tm.bm > 13 OR tm.bm < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD bm
#                  END IF
#               END IF
#            END IF
#            IF tm.bm IS NULL THEN NEXT FIELD bm END IF
#FUN-A90032 --End mark            

         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF

         AFTER FIELD e
            IF tm.e IS NULL THEN NEXT FIELD e END IF     
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
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel mai:",0)  
               NEXT FIELD p
            END IF

         BEFORE FIELD q
            IF tm.o = 'N' THEN NEXT FIELD o END IF

         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
#            END IF
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
                    WHEN tm.axa06 = '1'  #る 
                         LET tm.bm = 0
                   #CHI-B10030 add --start--
                    OTHERWISE      
                         CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                         CALL s_get_aznn01(l_axz03,tm.axa06,tm.b,tm.yy,tm.q1,tm.h1) RETURNING tm.em
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
               WHEN INFIELD(axa01) OR INFIELD(axa02)         
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_axa'
                  LET g_qryparam.default1 = tm.axa01
                  LET g_qryparam.default2 = tm.axa02
                  LET g_qryparam.default3 = tm.b
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.b
                  DISPLAY BY NAME tm.axa01
                  DISPLAY BY NAME tm.axa02
                  DISPLAY BY NAME tm.b
                  NEXT FIELD axa01

               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                  LET g_qryparam.where = " mai00 = '",tm.aaz641,"'"  
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               WHEN INFIELD(aaz641)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.aaz641
                  CALL cl_create_qry() RETURNING tm.aaz641 
                  DISPLAY BY NAME tm.aaz641
                  NEXT FIELD aaz641
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form =  'q_azi'
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
         LET INT_FLAG = 0 CLOSE WINDOW r011_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='aglr011'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglr011','9031',1)   
         ELSE
          LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                      " '",g_bookno CLIPPED,"'" ,
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      " '",g_rlang CLIPPED,"'", 
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",   
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.axa06 CLIPPED,"'", #FUN-A90032
#                     " '",tm.bm CLIPPED,"'",    #FUN-A90032 mark
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
                      " '",g_rpt_name CLIPPED,"'",
                      " '",tm.q1 CLIPPED,"'",    #FUN-A90032
                      " '",tm.h1 CLIPPED,"'"     #FUN-A90032   
          CALL cl_cmdat('aglr011',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r011_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r011()
      ERROR ""
   END WHILE
   CLOSE WINDOW r011_w
END FUNCTION

FUNCTION r011()
   DEFINE l_name    LIKE type_file.chr20         #External(Disk) file name     
   DEFINE l_sql     LIKE type_file.chr1000       #RDSQL STATEMENT             
   DEFINE l_chr     LIKE type_file.chr1         
   DEFINE amt1      LIKE axh_file.axh08
   DEFINE per1      LIKE fid_file.fid03        
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_last    LIKE type_file.num5       
   DEFINE l_lastday LIKE type_file.dat       
   DEFINE sr        RECORD
                       bal1      LIKE axh_file.axh08
                    END RECORD
   DEFINE prt_l     DYNAMIC ARRAY OF RECORD                   #--- 陣列 for 資產類 (左)
                       maj20    LIKE type_file.chr50,    
                       bal      LIKE type_file.num20_6, 
                       per      LIKE type_file.num20_6,   
                       maj03    LIKE maj_file.maj03,     
                       maj02    LIKE maj_file.maj02,    
                       line     LIKE type_file.num5    
                    END RECORD
   DEFINE prt_r     DYNAMIC ARRAY OF RECORD         #--- 陣列 for 負債&業主權益類 (右)
                       maj20    LIKE type_file.chr50,    
                       bal      LIKE type_file.num20_6, 
                       per      LIKE type_file.num20_6, 
                       maj03    LIKE maj_file.maj03,   
                       maj02    LIKE maj_file.maj02,  
                       line     LIKE type_file.num5  
                    END RECORD
   DEFINE tmp1      RECORD                          
                       maj23      LIKE maj_file.maj23,
                       maj20      LIKE type_file.chr50,
                       bal        LIKE type_file.num20_6,
                       per        LIKE type_file.num20_6,
                       maj03      LIKE maj_file.maj03,
                       maj02      LIKE maj_file.maj02,
                       line       LIKE type_file.num5
                    END RECORD
   DEFINE l_maj02_l  LIKE maj_file.maj02     
   DEFINE l_maj02_r  LIKE maj_file.maj02    
   DEFINE l_row_l    LIKE type_file.num5   
   DEFINE l_row_r    LIKE type_file.num5  
   DEFINE r,l,i      LIKE type_file.num5 

   DROP TABLE aglr011_tmp
   CREATE TEMP TABLE aglr011_tmp(
      maj23    LIKE maj_file.maj23,
      maj20    LIKE type_file.chr50,
      bal      LIKE type_file.num20_6,
      per      LIKE type_file.num20_6,
      maj03    LIKE maj_file.maj03,
      maj02    LIKE maj_file.maj02,
      line     LIKE type_file.num5)

   #帳別名稱
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01=tm.aaz641 AND aaf02=g_rlang

   CALL cl_del_data(l_table)          

   LET l_sql = "SELECT * FROM maj_file ",
               " WHERE maj01 = '",tm.a,"' ",
               "   AND maj23[1,1]='1' ",
               " ORDER BY maj02"
   PREPARE r011_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE r011_c CURSOR FOR r011_p

   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR

   FOREACH r011_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0
      IF NOT cl_null(maj.maj21) THEN
        #會計科目各期余額檔 
         LET g_sql="SELECT SUM(axh08-axh09) ",
                  #"  FROM axh_file,",g_dbs_axz03,"aag_file",                       #FUN-A50102 mark
                   "  FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),#FUN-A50102
                   " WHERE axh00 = '",tm.aaz641,"'",
                   "   AND axh00 = aag00 ",
                   "   AND axh01 = '",tm.axa01,"'",
                   "   AND axh02 = '",tm.axa02,"'",
                   "   AND axh03 = '",tm.b,"'",    
                   "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
#                  "   AND axh06 = '",tm.yy,"' AND axh07 <= '",tm.bm,"'", #FUN-A90032
                   "   AND axh06 = '",tm.yy,"' AND axh07 = '",tm.em,"'", #FUN-A90032
                   "   AND axh05 = aag01 AND aag07 !='1' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
         CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql   #FUN-A50102 	
         PREPARE sel_amt1_pre FROM g_sql
         DECLARE sel_amt1_cs CURSOR FOR sel_amt1_pre
         OPEN sel_amt1_cs 
         FETCH sel_amt1_cs INTO amt1
         IF STATUS THEN CALL cl_err('sel amt1:',STATUS,1) EXIT FOREACH END IF
         IF amt1 IS NULL THEN LET amt1 = 0 END IF
      END IF
      IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF          #匯率的轉換
      IF maj.maj03 MATCHES "[012349]" AND maj.maj08 > 0 THEN    #合計階數處理
        #CHI-A70050---modify---start---
        #FOR i = 1 TO 100 LET g_tot1[i]=g_tot1[i]+amt1 END FOR
         FOR i = 1 TO 100 
            #LET g_tot1[i]=g_tot1[i]+amt1 
             IF maj.maj09 = '-' THEN
                LET g_tot1[i] = g_tot1[i] - amt1
             ELSE
                LET g_tot1[i] = g_tot1[i] + amt1
             END IF
         END FOR
        #CHI-A70050---modify---end---
         LET k=maj.maj08  LET sr.bal1=g_tot1[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
         END IF
        #CHI-A70050---add---end---
         FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
      ELSE  
         IF maj.maj03='5' THEN                       #本行要印出,但金額不作加總
            LET sr.bal1=amt1
         ELSE
            LET sr.bal1=NULL
         END IF
      END IF
      IF maj.maj11 = 'Y' THEN                        #百分比基準科目
         LET g_basetot1=sr.bal1
         IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
         IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
         #金額單位(1.元 2.千 3.百萬)
         IF tm.d MATCHES '[23]' THEN LET g_basetot1=g_basetot1/g_unit END IF
      END IF
      IF maj.maj03='0' THEN                          #本行不印出
         CONTINUE FOREACH
      END IF
      IF (tm.c='N' OR maj.maj03='2') AND             #餘額為 0 者不列印
          maj.maj03 MATCHES "[012345]" AND sr.bal1=0 THEN
         CONTINUE FOREACH
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN            #最小階數起列印
         CONTINUE FOREACH
      END IF
      #正常餘額型態=2.貸餘,金額要乘以-1 
      IF maj.maj07='2' THEN LET sr.bal1=sr.bal1*-1 END IF
      LET sr.bal1=cl_numfor(sr.bal1,17,tm.e)
      #列印額外名稱
      IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
      LET per1 = (sr.bal1 / g_basetot1) * 100
      IF maj.maj03 = 'H' THEN 
         LET sr.bal1=NULL
         LET per1= ' '
      END IF
      #金額單位(1.元 2.千 3.百萬)
      IF tm.d MATCHES '[23]' THEN LET sr.bal1=sr.bal1/g_unit END IF
      LET maj.maj20=maj.maj05 SPACES,maj.maj20   

      IF maj.maj03='3' OR maj.maj03='4' THEN
         IF NOT cl_null(maj.maj20) THEN
            INSERT INTO aglr011_tmp VALUES
             (maj.maj23,maj.maj20,sr.bal1,per1,'1',maj.maj02,2)
         END IF
         INSERT INTO aglr011_tmp VALUES
          (maj.maj23,maj.maj20,sr.bal1,per1,maj.maj03,maj.maj02,2)
      ELSE
         INSERT INTO aglr011_tmp VALUES
          (maj.maj23,maj.maj20,sr.bal1,per1,maj.maj03,maj.maj02,2)
      END IF
      IF maj.maj04 > 0 THEN
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            INSERT INTO aglr011_tmp VALUES
             (maj.maj23,maj.maj20,0,0,maj.maj03,maj.maj02,1)
         END FOR
      END IF
   END FOREACH

   #抓報表結構裡帳戶左邊最大序號
   SELECT MAX(maj02) INTO l_maj02_l FROM aglr011_tmp WHERE maj23='11'
   #抓報表結構裡帳戶右邊最大序號
   SELECT MAX(maj02) INTO l_maj02_r FROM aglr011_tmp WHERE maj23='12'
   IF cl_null(l_maj02_l) THEN LET l_maj02_l = 0 END IF
   IF cl_null(l_maj02_r) THEN LET l_maj02_r = 0 END IF
   LET r_row = 0  LET l_row = 0
   DECLARE r011_c1 CURSOR FOR SELECT * FROM aglr011_tmp ORDER BY maj23,maj02,line #CHI-A70061 add line
   FOREACH r011_c1 INTO tmp1.*
      IF tmp1.maj23[2,2]='2' THEN     #--- 右邊(負債&業主權益)
         LET r_row=r_row+1
         LET prt_r[r_row].maj20=tmp1.maj20
         LET prt_r[r_row].bal  =tmp1.bal
         LET prt_r[r_row].per  =tmp1.per
         LET prt_r[r_row].maj03=tmp1.maj03
         LET prt_r[r_row].maj02=tmp1.maj02
         LET prt_r[r_row].line =tmp1.line
         IF l_maj02_r != 0 THEN
            IF tmp1.maj02 = l_maj02_r THEN    #判斷是不是到最後一筆
               LET l_row_r = r_row
            END IF
         END IF
      ELSE                           #--- 左邊(資產)
         LET l_row=l_row+1
         LET prt_l[l_row].maj20=tmp1.maj20
         LET prt_l[l_row].bal  =tmp1.bal
         LET prt_l[l_row].per  =tmp1.per
         LET prt_l[l_row].maj03=tmp1.maj03
         LET prt_l[l_row].maj02=tmp1.maj02
         LET prt_l[l_row].line =tmp1.line
         IF l_maj02_l != 0 THEN
            IF tmp1.maj02 = l_maj02_l THEN    #判斷是不是到最後一筆
               LET l_row_l = l_row
            END IF
         END IF
      END IF
   END FOREACH
 
   IF r_row = 0 THEN LET r_row = 1 END IF
   IF l_row = 0 THEN LET l_row = 1 END IF
   IF l_maj02_r != 0 AND l_maj02_l != 0 THEN
      IF l_row_l > l_row_r THEN
         LET l_last=l_row
         LET prt_r[l_row_l+1].* = prt_r[l_row_r+1].*
         INITIALIZE prt_r[l_row_r+1].* TO NULL
         IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
            IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
               LET prt_r[l_row_l].* = prt_r[l_row_r].*
               INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 
               LET prt_r[l_row_l-1].* = prt_r[l_row_r-1].*
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_r[l_row_r-1].* TO NULL
            ELSE
               LET prt_r[l_row_l-1].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
            END IF
         ELSE
            IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
               LET prt_l[l_row_l+1].* = prt_r[l_row_r].*
               LET prt_l[l_row_l+1].maj02=prt_l[l_row_l].maj02
               LET prt_l[l_row_l+1].maj03='1'
               LET prt_l[l_row_l+1].maj20=''
               LET prt_r[l_row_l+1].* = prt_r[l_row_r].*
               INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198
               LET prt_r[l_row_l].* = prt_r[l_row_r-1].*
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_r[l_row_r-1].* TO NULL
               LET l_last=l_row_l+1
            ELSE
               LET prt_r[l_row_l].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
            END IF
         END IF
      END IF
   
      IF l_row_l < l_row_r THEN
         LET l_last=r_row
         LET prt_l[l_row_r+1].* = prt_l[l_row_l+1].*
         INITIALIZE prt_l[l_row_l+1].* TO NULL
         IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
            IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
               LET prt_l[l_row_r].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198
               LET prt_l[l_row_r-1].* = prt_l[l_row_l-1].*
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_l[l_row_l-1].* TO NULL
            ELSE
               LET prt_l[l_row_r-1].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
            END IF
         ELSE
            IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
               LET prt_r[l_row_r+1].* = prt_l[l_row_l].*
               LET prt_r[l_row_r+1].maj02=prt_r[l_row_r].maj02
               LET prt_r[l_row_r+1].maj03='1'
               LET prt_r[l_row_r+1].maj20=''
               LET prt_l[l_row_r+1].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198
               LET prt_l[l_row_r].* = prt_l[l_row_l-1].*
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_l[l_row_l-1].* TO NULL
               LET l_last=l_row_r+1
            ELSE
               LET prt_l[l_row_r].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
            END IF
         END IF
      END IF
      IF l_row_l = l_row_r THEN 
         IF l_row > r_row THEN 
            LET l_last = l_row
         ELSE
            LET l_last = r_row
         END IF
      END IF
   ELSE
      IF l_maj02_r = 0 THEN LET l_last = r_row END IF
      IF l_maj02_l = 0 THEN LET l_last = l_row END IF
   END IF

   FOR i=1 TO l_last
      EXECUTE insert_prep USING 
         prt_l[i].maj20,prt_l[i].bal,  prt_l[i].per,
         prt_l[i].maj03,prt_l[i].maj02,prt_l[i].line,
         prt_r[i].maj20,prt_r[i].bal,  prt_r[i].per,
         prt_r[i].maj03,prt_r[i].maj02,prt_r[i].line,
         i                                             #No.MOD-B80133  add
   END FOR

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   LET l_lastday = MDY(tm.bm,'1',tm.yy)        
   LET l_lastday = s_last(l_lastday)    
   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",                
               tm.bm,";",tm.e,";",
               l_lastday,";",g_basetot1  #CHI-A70046 add g_basetot1          
   CALL cl_prt_cs3('aglr011','aglr011',g_sql,g_str) 
END FUNCTION

#FUN-A90032 --Begin
FUNCTION r011_set_entry()                                                                                                           
   CALL cl_set_comp_entry("q1,em,h1",TRUE)#FUN-A90032 add
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION r011_set_no_entry()                                                                                                        
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

#FUN-A30122 --Begin
#FUNCTION r011_getdbs()
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
#  PREPARE r011_pre_11 FROM g_sql
#  DECLARE r011_cur_11 CURSOR FOR r011_pre_11
#  OPEN r011_cur_11
#  FETCH r011_cur_11 INTO g_aaz641
#END FUNCTION	　
#FUN-A30122 --End


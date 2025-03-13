# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aglr013.4gl
# Descriptions...: 合并后全年度財務報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 10/08/11 FUN-9A0036 By vealxu 
# Modify.........: No.FUN-A30122 10/04/07 By vealxu 1、合并帳別/合并資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No:CHI-A60013 10/07/19 By Summer 在跨資料庫SQL後加入DB_LINK語法
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: NO.FUN-AB0085 11/01/26 By lixia 資產負債表為累計，損益表金額為當月異動額
# Modify.........: NO.FUN-A90032 11/03/09 By wangxin 21區追單
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
   DEFINE tm  RECORD
                rtype   LIKE type_file.chr1,     #報表結構編號  
                axa01   LIKE axa_file.axa01,     #族群編號
                axa02   LIKE axa_file.axa02,     #上層公司編號
                b       LIKE aaa_file.aaa01,     #帳別編號  
                aaz641  LIKE aaz_file.aaz641,    #合并帳別編號
                a       LIKE mai_file.mai01,     #報表結構編號 
                yy      LIKE type_file.num5,     #輸入年度    
                axa06   LIKE axa_file.axa06,     #FUN-A90032
                bm      LIKE type_file.num5,     #BEGIN 期別
                em      LIKE type_file.num5,     #End 期別    
                q1      LIKE type_file.chr1,     #FUN-A90032
                h1      LIKE type_file.chr1,     #FUN-A90032
                c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印 
                d       LIKE type_file.chr1,     #金額單位      
                e       LIKE type_file.num5,     #小數位數     
                f       LIKE type_file.num5,     #列印最小階數
                h       LIKE type_file.chr4,     #額外說明類別  
                o       LIKE type_file.chr1,     #轉換幣別否   
                p       LIKE azi_file.azi01,     #幣別
                q       LIKE azj_file.azj03,     #匯率
                r       LIKE azi_file.azi01,     #幣別
                more    LIKE type_file.chr1      #Input more condition(Y/N) 
              END RECORD,
          bdate,edate    LIKE type_file.dat,     
          i,j,k          LIKE type_file.num5,   
          g_unit         LIKE type_file.num10,   #金額單位基數   
          g_bookno       LIKE axh_file.axh00,    #帳別
          g_mai02        LIKE mai_file.mai02,
          g_mai03        LIKE mai_file.mai03,
          g_tot          ARRAY[100,12] OF LIKE type_file.num20_6,  
          bal            ARRAY[12] OF LIKE type_file.num20_6,     
          g_basetot      ARRAY[12] OF LIKE type_file.num20_6,    
          amt            LIKE axh_file.axh08,
          amt1           LIKE axh_file.axh08    #FUN-AB0085
   DEFINE g_aaa03        LIKE aaa_file.aaa03   
   DEFINE g_i            LIKE type_file.num5     #count/index for any purpose 
   DEFINE g_msg          LIKE type_file.chr1000                              
   DEFINE l_table        STRING
   DEFINE g_sql          STRING
   DEFINE g_str          STRING
   DEFINE x_aaa03        LIKE aaa_file.aaa03
   DEFINE g_aaz641       LIKE aaz_file.aaz641
   DEFINE g_axz03        LIKE axz_file.axz03
   DEFINE g_dbs_axz03    STRING
   DEFINE g_plant_axz03  LIKE type_file.chr21   #FUN-A30122 add by vealxu
   DEFINE g_axa09        LIKE axa_file.axa09
   DEFINE g_axa05        LIKE axa_file.axa05 #FUN-A90032
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET g_sql = "maj20.maj_file.maj20,",                                         
               "maj20e.maj_file.maj20e,",                                       
               "maj02.maj_file.maj02,",   #項次(排序要用的)                     
               "maj03.maj_file.maj03,",   #列印碼                               
               "bal01.axh_file.axh08,",    #期初借                               
               "bal02.axh_file.axh08,",    #期初借                               
               "bal03.axh_file.axh08,",    #期初借                               
               "bal04.axh_file.axh08,",    #期初借                               
               "bal05.axh_file.axh08,",    #期初借                               
               "bal06.axh_file.axh08,",    #期初借                               
               "bal07.axh_file.axh08,",    #期初借                               
               "bal08.axh_file.axh08,",    #期初借                               
               "bal09.axh_file.axh08,",    #期初借                               
               "bal10.axh_file.axh08,",    #期初借                               
               "bal11.axh_file.axh08,",    #期初借                               
               "bal12.axh_file.axh08,",    #期初借                               
               "bal13.axh_file.axh08,",    #期初借                               
               "line.type_file.num5"      #1:表示此筆為空行 2:表示此筆不為空    
                                                                                
   LET l_table = cl_prt_temptable('aglr013',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?  )"                                       
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
    
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.rtype= ARG_VAL(8)
   LET tm.a    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)   
   LET tm.yy   = ARG_VAL(11)
   LET tm.em   = ARG_VAL(12)
   LET tm.c    = ARG_VAL(13)
   LET tm.d    = ARG_VAL(14)
   LET tm.e    = ARG_VAL(15)
   LET tm.f    = ARG_VAL(16)
   LET tm.h    = ARG_VAL(17)
   LET tm.o    = ARG_VAL(18)
   LET tm.p    = ARG_VAL(19)
   LET tm.q    = ARG_VAL(20)
   LET tm.r    = ARG_VAL(21)  
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  

   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   IF cl_null(tm.aaz641) THEN
      LET tm.aaz641 = g_aza.aza81
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r013_tm() 
   ELSE
      CALL r013()  
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r013_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,     
          l_sw          LIKE type_file.chr1,       #重要欄位是否空白 
          l_cmd         LIKE type_file.chr1000,                     
          li_chk_bookno LIKE type_file.num5,     
          li_result     LIKE type_file.num5,     
          l_cnt         LIKE type_file.num5 
   DEFINE l_azmm02      LIKE azmm_file.azmm02      #FUN-AB0085
   DEFINE l_aaa05       LIKE aaa_file.aaa05        #FUN-A90032
   DEFINE l_aznn01      LIKE aznn_file.aznn01      #FUN-A90032
   CALL s_dsmark(g_bookno)
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r013_w AT p_row,p_col WITH FORM "agl/42f/aglr013"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition

   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0) 
   END IF

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

     # INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.b,tm.aaz641,tm.a,tm.yy,tm.em,tm.e,tm.f,  
      INPUT BY NAME tm.rtype,tm.axa01,tm.axa02,tm.b,tm.aaz641,tm.a,tm.yy,tm.e,tm.f, #FUN-AB0085
                    tm.d,tm.c,tm.h,tm.o,tm.r,
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_init()
            CALL r013_set_entry()    #FUN-A90032
            CALL r013_set_no_entry() #FUN-A90032

         ON ACTION locale
         #  LET g_action_choice = "locale"   #FUN-9A0036 mark
          CALL cl_dynamic_locale()           #FUN-9A0036
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
            SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02
#FUN-A30122 --Begin
#           CALL r013_getdbs()
            CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03       #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
            CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                #FUN-A30122 mod g_dbs_axz03->g_plant_axz03 by vealxu
#FUN-A30122 --End
            IF cl_null(g_aaz641) THEN
               CALL cl_err(g_axz03,'agl-601',1)
               NEXT FIELD axa02
            ELSE
               LET tm.aaz641= g_aaz641
               DISPLAY BY NAME tm.aaz641
            END IF
 
         AFTER FIELD a
            IF tm.a IS NULL THEN
               NEXT FIELD a
            END IF
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = tm.aaz641     
             # AND maiacti MATCHES'[Yy]'
               AND maiacti IN ('y','Y') 
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
            #--FUN-AB0085 start--
            IF cl_null(tm.rtype) THEN
                IF g_mai03 = '2' THEN LET tm.rtype = '1' END IF
                IF g_mai03 = '3' THEN LET tm.rtype = '2' END IF
            END IF
            #--FUN-AB0085 end--
      
         AFTER FIELD aaz641
          # LET g_sql ="SELECT COUNT(*) FROM ",g_dbs_axz03,"aaz_file",    #FUN-A30122 mark by vealxu
            LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_axz03,'aaz_file'),   #FUN-A30122 add by vealxu
                       " WHERE aaz641 = '",tm.aaz641,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
            CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql    #FUN-A30122 add by vealxu
            PREPARE r013_cnt_p FROM g_sql
            DECLARE r013_cnt_c CURSOR FOR r013_cnt_p
            OPEN r013_cnt_c
            FETCH r013_cnt_c INTO l_cnt
            IF cl_null(l_cnt) OR l_cnt=0 THEN
               CALL cl_err('','agl-965',1)
               NEXT FIELD aaz641
            END IF             
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c 
            END IF
      
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy 
            END IF
            #--FUN-AB0085 start--
            SELECT azmm02 INTO l_azmm02
              FROM azmm_file
             WHERE azmm00 = tm.aaz641
               AND azmm01 = tm.yy
            IF cl_null(l_azmm02) THEN LET l_azmm02 = 1 END IF
            IF l_azmm02 = 1 THEN
                LET tm.em = 12
            ELSE
                LET tm.em = 13
            END IF
            #--FUN-AB0085 end----
      
#--FUN-AB0085 mark-------------------- 
#         AFTER FIELD em
#         IF NOT cl_null(tm.em) THEN
#            SELECT azm02 INTO g_azm.azm02 FROM azm_file
#              WHERE azm01 = tm.yy
#            IF g_azm.azm02 = 1 THEN
#               IF tm.em > 12 OR tm.em < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD em
#               END IF
#            ELSE
#               IF tm.em > 13 OR tm.em < 1 THEN
#                  CALL cl_err('','agl-020',0)
#                  NEXT FIELD em
#               END IF
#            END IF
#         END IF
#            IF tm.em IS NULL THEN
#               NEXT FIELD em
#            END IF
#---FUN-AB0085 mark---
      
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]' THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
      
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
      
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0 THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
      
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h
            END IF
      
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN
               NEXT FIELD o
            END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
      
         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more 
            END IF
      
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0) 
               NEXT FIELD p
            END IF
      
         BEFORE FIELD q
            IF tm.o = 'N' THEN 
               NEXT FIELD o
            END IF
      
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.yy IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy 
               CALL cl_err('',9033,0)
            END IF
#FUN-A90032 --Begin
#            IF tm.em IS NULL THEN 
#               LET l_sw = 0 
#               DISPLAY BY NAME tm.em 
#            END IF
#FUN-A90032 --End
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
      

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask() 

         ON ACTION CONTROLP
            IF (INFIELD(axa01) OR INFIELD(axa02)) THEN         
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
            END IF 
            IF INFIELD(a) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.aaz641,"'"    #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.aaz641,"' AND mai03 NOT IN ('5','6')"   #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF

            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF

            IF INFIELD(aaz641) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form='q_aaa'
               LET g_qryparam.default1=tm.aaz641
               CALL cl_create_qry() RETURNING tm.aaz641
               DISPLAY BY NAME tm.aaz641
               NEXT FIELD aaz641
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
         LET INT_FLAG = 0
         CLOSE WINDOW r013_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr013'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr013','9031',1)   
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
                        " '",tm.b CLIPPED,"'",   
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
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
            CALL cl_cmdat('aglr013',g_time,l_cmd)    # Execute cmd at later time
         END IF

         CLOSE WINDOW r013_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      CALL cl_wait()
      CALL r013()

      ERROR ""
   END WHILE

   CLOSE WINDOW r013_w

END FUNCTION

FUNCTION r013()
   DEFINE l_name    LIKE type_file.chr20         #External(Disk) file name     
   DEFINE l_sql     LIKE type_file.chr1000       #RDSQL STATEMENT             
   DEFINE l_chr     LIKE type_file.chr1          
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_dbs     LIKE azp_file.azp03         
   DEFINE l_endy1   LIKE abb_file.abb07        
   DEFINE l_endy2   LIKE abb_file.abb07       
   DEFINE sr        RECORD
                       bal01,bal02,bal03,bal04,bal05,bal06,
                       bal07,bal08,bal09,bal10,bal11,bal12,
                       bal13   LIKE axh_file.axh08
                    END RECORD
   DEFINE l_axh07_f LIKE axh_file.axh07   #FUN-AB0085

   CALL cl_del_data(l_table)              

   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_plant 
   LET l_dbs = l_dbs CLIPPED,':'                            

   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.aaz641 AND aaf02 = g_rlang

   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE

   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r013_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r013_c CURSOR FOR r013_p

   FOR i = 1 TO 100 
      #FOR j = 1 TO 12
      FOR j = 1 TO tm.em   #FUN-AB0085 mod
         LET g_tot[i,j] = 0 
      END FOR
   END FOR

   FOREACH r013_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF

      FOR i = 1 TO 12
         LET bal[i] = 0
      END FOR
      #FOR i = 1 TO tm.em   #FUN-AB0085
      #---FUN-AB0085 start--
      LET g_sql = " SELECT UNIQUE axh07 ",
                  "  FROM axh_file",
                  " WHERE axh00 = '",tm.aaz641,"'",
                  "   AND axh01 = '",tm.axa01,"'",
                  "   AND axh02 = '",tm.axa02,"'",
                  "   AND axh03 = '",tm.b,"'",
                  "   AND axh06 = '",tm.yy,"'",
                  "   AND axh12 = '",x_aaa03,"'"
      PREPARE r013_axh_p FROM g_sql
      IF STATUS THEN
         CALL cl_err('prepare:',STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE r013_axh_c CURSOR FOR r013_axh_p
      FOREACH r013_axh_c INTO i
      #--FUN-AB0085 end---------------------

         LET amt = 0
         LET amt1 = 0   #FUN-AB0085
         IF NOT cl_null(maj.maj21) THEN
            #--FUN-AB0085 mark
            #IF tm.rtype='1' THEN
            #   LET tm.bm = 0
            #ELSE
            #   LET tm.bm = i
            #END IF
            #--FUN-AB0085 mark
            LET g_sql = " SELECT SUM(axh08-axh09) ",
                      # "  FROM axh_file,",g_dbs_axz03,"aag_file",          #FUN-A30122 add by vealxu
                      # "  FROM axh_file,",cl_get_target_table(g_plant_axz03,'aag_file'),  #FUN-A30122 add by vealxu
                        "  FROM axh_file",  #FUN-AB0085 
                        " WHERE axh00 = '",tm.aaz641,"'",
                      # "   AND axh00 = aag00 ",   #FUN-AB0085 mark
                        "   AND axh01 = '",tm.axa01,"'",
                        "   AND axh02 = '",tm.axa02,"'",
                        "   AND axh03 = '",tm.b,"'",     
                        "   AND axh05 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"'",
                        "   AND axh06 = '",tm.yy,"'",
                      # "   AND axh07 BETWEEN '",tm.bm,"' AND '",i,"'",
                        "   AND axh07 = '",i,"'",                    #FUN-AB0085 mod
                      # "   AND axh05 = aag01",                      #FUN-AB0085 mark
                      # "   AND aag07 != '1'",                       #FUN-AB0085 mark
                        "   AND axh12 = '",x_aaa03,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql #CHI-A60013 add
            CALL cl_parse_qry_sql(g_sql,g_plant_axz03 ) RETURNING g_sql  #FUN-A30122 add by vealxu
            PREPARE sel_amt_pre FROM g_sql
            DECLARE sel_amt_cs CURSOR FOR sel_amt_pre
            OPEN sel_amt_cs
            FETCH sel_amt_cs INTO amt
            IF STATUS THEN 
               CALL cl_err('sel amt:',STATUS,1)
               EXIT FOREACH 
            END IF

            IF amt IS NULL THEN LET amt = 0 END IF
            #---FUN-AB0085 start--
            IF tm.rtype = '2' THEN
                    SELECT MAX(axh07) INTO l_axh07_f
                       FROM axh_file
                      WHERE axh00 = tm.aaz641
                        AND axh01 = tm.axa01
                        AND axh02 = tm.axa02
                        AND axh03 = tm.b
                        AND axh05 BETWEEN maj.maj21 AND maj.maj22
                        AND axh06 = tm.yy
                        AND axh12 = x_aaa03
                        AND axh07 < i
                    IF NOT cl_null(l_axh07_f) THEN
                        SELECT SUM(axh08-axh09) INTO amt1
                          FROM axh_file
                         WHERE axh00 = tm.aaz641
                           AND axh01 = tm.axa01
                           AND axh02 = tm.axa02
                           AND axh03 = tm.b
                           AND axh05 BETWEEN maj.maj21 AND maj.maj22
                           AND axh06 = tm.yy
                           AND axh12 = x_aaa03
                           AND axh07 = l_axh07_f
                    END IF
                    IF amt1 IS NULL THEN LET amt1 = 0 END IF
            END IF
            LET amt = amt - amt1
            #---FUN-AB0085 end-------------
 
         END IF

         IF tm.o = 'Y' THEN   #匯率的轉換
            LET amt = amt * tm.q 
         END IF

         IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN     #合計階數處理
            FOR j=1 TO 100
               #CHI-A70050---modify---start---
               #LET g_tot[j,i] = g_tot[j,i] + amt
                IF maj.maj09 = '-' THEN
	           LET g_tot[j,i] = g_tot[j,i] - amt
                ELSE
                   LET g_tot[j,i] = g_tot[j,i] + amt
                END IF
               #CHI-A70050---modify---end---
            END FOR
            LET k = maj.maj08
            LET bal[i] = g_tot[k,i]
           #CHI-A70050---add---start---
            IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
               LET bal[i] = bal[i] *-1
            END IF
           #CHI-A70050---add---end---
            FOR j = 1 TO maj.maj08 
               LET g_tot[j,i] = 0
            END FOR
         ELSE 
            IF maj.maj03='5' THEN
               LET bal[i]=amt
            ELSE
               LET bal[i]=0
            END IF
         END IF

         IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
            LET g_basetot[i] = bal[i]
            IF maj.maj07 = '2' THEN 
               LET g_basetot[i] = g_basetot[i] * -1
            END IF
            IF g_basetot[i] = 0 THEN
               LET g_basetot[i] = NULL
            END IF
         END IF

         IF maj.maj08 = 0 THEN
            LET bal[i] = 0     
         END IF

         IF maj.maj03 = 'H' THEN
            LET bal[i] = NULL
         END IF
      #END FOR       #FUN-AB0085 mark
      END FOREACH    #FUN-AB0085 add

      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH 
      END IF #本行不印出

      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"  
         AND bal[1]=0 AND bal[2]=0 AND bal[3]=0 AND bal[4]=0
         AND bal[5]=0 AND bal[6]=0 AND bal[7]=0 AND bal[8]=0
         AND bal[9]=0 AND bal[10]=0 AND bal[11]=0 AND bal[12]=0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF

      IF tm.f > 0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF

      LET sr.bal13=bal[1]+bal[2]+bal[3]+bal[4]+bal[5]+bal[6]+
                   bal[7]+bal[8]+bal[9]+bal[10]+bal[11]+bal[12]

      IF tm.rtype = '1' THEN
         LET sr.bal13 = 0   
      END IF

      FOR i = tm.em + 1 TO 12 
         LET bal[i] = 0 
      END FOR

      LET sr.bal01=bal[1]
      LET sr.bal02=bal[2]
      LET sr.bal03=bal[3]
      LET sr.bal04=bal[4]
      LET sr.bal05=bal[5]
      LET sr.bal06=bal[6]
      LET sr.bal07=bal[7]
      LET sr.bal08=bal[8]
      LET sr.bal09=bal[9]
      LET sr.bal10=bal[10]
      LET sr.bal11=bal[11]
      LET sr.bal12=bal[12]

      IF maj.maj07='2' THEN                                                  
         LET sr.bal01 = sr.bal01 * -1                                        
         LET sr.bal02 = sr.bal02 * -1                                        
         LET sr.bal03 = sr.bal03 * -1                                        
         LET sr.bal04 = sr.bal04 * -1                                        
         LET sr.bal05 = sr.bal05 * -1                                        
         LET sr.bal06 = sr.bal06 * -1                                        
         LET sr.bal07 = sr.bal07 * -1                                        
         LET sr.bal08 = sr.bal08 * -1                                        
         LET sr.bal09 = sr.bal09 * -1                                        
         LET sr.bal10 = sr.bal10 * -1                                        
         LET sr.bal11 = sr.bal11 * -1                                        
         LET sr.bal12 = sr.bal12 * -1                                        
         LET sr.bal13 = sr.bal13 * -1                                        
      END IF                                                                 
                                                                                
      IF tm.h='Y' THEN                                                       
         LET maj.maj20 = maj.maj20e                                          
      END IF

      LET maj.maj20 = maj.maj05 SPACES,maj.maj20

      LET sr.bal01=sr.bal01/g_unit                                       
      LET sr.bal02=sr.bal02/g_unit                                       
      LET sr.bal03=sr.bal03/g_unit                                       
      LET sr.bal04=sr.bal04/g_unit                                       
      LET sr.bal05=sr.bal05/g_unit                                       
      LET sr.bal06=sr.bal06/g_unit                                       
      LET sr.bal07=sr.bal07/g_unit                                       
      LET sr.bal08=sr.bal08/g_unit                                       
      LET sr.bal09=sr.bal09/g_unit                                       
      LET sr.bal10=sr.bal10/g_unit                                       
      LET sr.bal11=sr.bal11/g_unit                                       
      LET sr.bal12=sr.bal12/g_unit                                       
      LET sr.bal13=sr.bal13/g_unit 
 
      IF maj.maj04 = 0 THEN                                                     
         EXECUTE insert_prep USING                                              
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                           
            sr.bal01,sr.bal02,sr.bal03,sr.bal04,                           
            sr.bal05,sr.bal06,sr.bal07,sr.bal08,
            sr.bal09,sr.bal10,sr.bal11,sr.bal12,
            sr.bal13,    
            '2'                                                                 
      ELSE                                                                      
         EXECUTE insert_prep USING                                              
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                           
            sr.bal01,sr.bal02,sr.bal03,sr.bal04,                                
            sr.bal05,sr.bal06,sr.bal07,sr.bal08,                                
            sr.bal09,sr.bal10,sr.bal11,sr.bal12,                                
            sr.bal13,  
            '2'                                                                 
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
         #讓空行的這筆資料排在正常的資料前面印出                                
         FOR i = 1 TO maj.maj04                                                 
            EXECUTE insert_prep USING                                           
               maj.maj20,maj.maj20e,maj.maj02,'',                               
               '0','0','0','0',                                                 
               '0','0','0','0',                                                 
               '0','0','0','0',                                                 
               '0',                                                 
               '1'                                                              
         END FOR                                                                
      END IF                                                       
   END FOREACH

   IF tm.rtype = "1" THEN                                                       
      LET l_name = 'aglr013_1'                                                  
   ELSE                                                                         
      LET l_name = 'aglr013' 
   END IF 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",
               tm.rtype,";",tm.e      
   CALL cl_prt_cs3('aglr013',l_name,g_sql,g_str)
END FUNCTION
　
#FUN-A30122 --Begin
#FUNCTION r013_getdbs()
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
#  PREPARE r013_pre_11 FROM g_sql
#  DECLARE r013_cur_11 CURSOR FOR r013_pre_11
#  OPEN r013_cur_11
#  FETCH r013_cur_11 INTO g_aaz641
#END FUNCTION	　
#FUN-A30122 --End
#FUN-9A0036　	　	　
#FUN-A90032 --Begin
FUNCTION r013_set_entry()                                                                                                           
   CALL cl_set_comp_entry("q1,em,h1",TRUE)#FUN-A90032 add
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION r013_set_no_entry()                                                                                                        
   IF tm.axa06 ="1" THEN  #月
      CALL cl_set_comp_entry("q1,h1",FALSE)
   END IF
   IF tm.axa06 ="2" THEN  #季
      CALL cl_set_comp_entry("em,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN  #半年
      CALL cl_set_comp_entry("em,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN  #年
      CALL cl_set_comp_entry("q1,em,h1",FALSE)
   END IF

END FUNCTION
#FUN-A90032 --End

# Prog. Version..: '5.30.06-13.04.17(00008)'     #
#
# Pattern name...: aglr016.4gl
# Descriptions...: 沖銷金額檢核表
# Input parameter: 
# Return code....: 
# Date & Author..: 
# Modify.........: NO:FUN-AB0043 11/01/25 BY Summer 
# Modify.........: NO:TQC-B10205 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10024 12/05/22 By minpp 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.FUN-C50059 12/12/20 By belle 修改持股比例欄位
# Modify.........: No:CHI-D40021 13/04/12 By apo axt05不使用
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm         RECORD  
                  yy        LIKE type_file.num5,   #匯入會計年度  
                  em        LIKE type_file.num5,   #截止期間     
                  axa01     LIKE axa_file.axa01,   #族群代號
                  axa02     LIKE axa_file.axa02,   #上層公司編號
                  axa03     LIKE axa_file.axa03,   #帳別
                  axa06     LIKE axa_file.axa06,  
                  q1        LIKE type_file.chr1,  
                  h1        LIKE type_file.chr1  
                  END RECORD
DEFINE g_cnt_axf09  LIKE type_file.num5  
DEFINE g_cnt_axf10  LIKE type_file.num5    
DEFINE g_dbs_axf09  LIKE azp_file.azp03   
DEFINE g_dbs_axf10  LIKE azp_file.azp03 
DEFINE g_no         LIKE type_file.num5
DEFINE g_dept        DYNAMIC ARRAY OF RECORD        
                     axa01      LIKE axa_file.axa01,  #族群代號
                     axa02      LIKE axa_file.axa02,  #上層公司
                     axa03      LIKE axa_file.axa03,  #帳別
                     axb04      LIKE axb_file.axb04,  #下層公司
                     axb05      LIKE axb_file.axb05   #帳別  
                     END RECORD
DEFINE g_aek         RECORD 
                     aek04  LIKE aek_file.aek04,
                     aek05  LIKE aek_file.aek05,
                     aek06  LIKE aek_file.aek06,
                     aek08  LIKE aek_file.aek08,
                     aek09  LIKE aek_file.aek09,
                     aek10  LIKE aek_file.aek10,
                     aek11  LIKE aek_file.aek11
                     END RECORD
DEFINE x_aaa03    LIKE aaa_file.aaa03,             #上層公司記帳幣別
       g_aaa04    LIKE aaa_file.aaa04,             #現行會計年度
       g_aaa05    LIKE aaa_file.aaa05,             #現行期別
       g_aaa07    LIKE aaa_file.aaa07,             #關帳日期
       g_bdate    LIKE type_file.dat,              #期間起始日期  
       g_edate    LIKE type_file.dat,              #期間起始日期 
       g_dbs_gl   LIKE type_file.chr21,                         
       g_bookno   LIKE aea_file.aea00,             #帳別
       g_change_lang   LIKE type_file.chr1,
       g_axk      RECORD LIKE axk_file.*,
       g_axg      RECORD LIKE axg_file.*,
       g_axf      RECORD LIKE axf_file.*
DEFINE g_sql           STRING            
DEFINE g_str           STRING #FUN-AB0043 add
DEFINE g_axa06         LIKE axa_file.axa06    
DEFINE g_type          LIKE type_file.chr1  
DEFINE g_axa05         LIKE axa_file.axa05
DEFINE g_flag          LIKE type_file.chr1
DEFINE g_aaz641        LIKE aaz_file.aaz641  
DEFINE g_dbs_axz03     LIKE type_file.chr21 
DEFINE g_axf09_axz05   LIKE axz_file.axz05
DEFINE g_axf10_axz05   LIKE axz_file.axz05
DEFINE g_axz08         LIKE axz_file.axz08
DEFINE g_axz08_axf10   LIKE axz_file.axz08
DEFINE g_low_axf09     LIKE type_file.num5
DEFINE g_up_axf09      LIKE type_file.num5
DEFINE g_low_axf10     LIKE type_file.num5
DEFINE g_up_axf10      LIKE type_file.num5
DEFINE g_axa02_axf09   LIKE axa_file.axa02
DEFINE g_axa02_axf10   LIKE axa_file.axa02
DEFINE g_axa09_axf09   LIKE axa_file.axa09
DEFINE g_axa09_axf10   LIKE axa_file.axa09
DEFINE g_axz06_axf09   LIKE axz_file.axz06
DEFINE g_axz06_axf10   LIKE axz_file.axz06
DEFINE g_aaz641_axf09  LIKE aaz_file.aaz641 
DEFINE g_aaz641_axf10  LIKE aaz_file.aaz641 
DEFINE l_rate          LIKE axp_file.axp05              #功能幣別匯率    
DEFINE l_rate1         LIKE axp_file.axp05,             #記帳幣別匯率   
       g_axt03         LIKE axt_file.axt03,             
       g_axs03         LIKE axs_file.axs03,             
       g_axu03         LIKE axu_file.axu03,             
       g_dc            LIKE axj_file.axj06,             
       g_flag_r        LIKE type_file.chr1             
DEFINE g_axk07         LIKE axk_file.axk07   
DEFINE g_aag02         LIKE aag_file.aag02
DEFINE g_con_amt       LIKE axg_file.axg08
DEFINE g_curr1         LIKE axg_file.axg12
DEFINE g_curr3         LIKE axg_file.axg12,
       g_rate          LIKE type_file.num20_6
DEFINE l_table         STRING

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
  
   LET tm.axa01 = ARG_VAL(1)
   LET tm.axa02 = ARG_VAL(2)
   LET tm.axa03 = ARG_VAL(3)
   LET tm.yy    = ARG_VAL(4)
   LET tm.axa06 = ARG_VAL(5)
   LET tm.em    = ARG_VAL(6)
   LET tm.q1    = ARG_VAL(7)
   LET tm.h1    = ARG_VAL(8)
   LET g_bgjob  = ARG_VAL(9)

   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047
   
   LET g_sql = "axk05.axk_file.axk05,",
               "aag02.aag_file.aag02,",
               "axk06.axk_file.axk06,",
               "axk07.axk_file.axk07,",
               "axk04.axk_file.axk04,",
               "curr1.axz_file.axz06,",
               "axg13.axg_file.axg13,",
               "axg12.axg_file.axg12,",
               "axg08.axg_file.axg08,",
               "curr3.axz_file.axz06,",
               "con_amt.type_file.num20_6,"
   
   LET l_table = cl_prt_temptable('aglr016',g_sql) CLIPPED # 產生TEMP TABLE
   IF l_table = -1 THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r016_tm()
     #CALL r016() #FUN-AB0043 mark
   ELSE
      CALL r016()
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r016_tm()
   DEFINE  p_row,p_col    LIKE type_file.num5,         
           l_cnt          LIKE type_file.num5,        
           l_axa03        LIKE axa_file.axa03        
   DEFINE  lc_cmd         LIKE type_file.chr1000    
   DEFINE  l_axa09        LIKE axa_file.axa09      
   DEFINE  l_aznn01       LIKE aznn_file.aznn01   
   DEFINE  l_axz03        LIKE axz_file.axz03          #TQC-B10205 add
     
   IF s_shut(0) THEN RETURN END IF
   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglr016_w AT p_row,p_col WITH FORM "agl/42f/aglr016" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07   
        FROM aaa_file 
       WHERE aaa01 = g_bookno

      SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = tm.axa02   

      LET tm.yy = g_aaa04
      LET tm.em = g_aaa05
      LET g_bgjob = 'N'       

      INPUT BY NAME tm.axa01,tm.axa02,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,g_bgjob  
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE    #NO.FUN-570145 
            EXIT INPUT                  #NO.FUN-570145 


         AFTER FIELD q1    #季
             IF cl_null(tm.q1) AND  g_axa06 = '2' THEN 
                NEXT FIELD q1 
             END IF
             IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
                NEXT FIELD q1
             END IF
 
         AFTER FIELD h1 #半年報
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
               NEXT FIELD h1
            END IF
           
         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01 #no.6155
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-11","","",0)  #No.FUN-660123
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02  #公司編號
            IF NOT cl_null(tm.axa02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02 
               END IF
               SELECT DISTINCT axa03 INTO l_axa03 FROM axa_file
                WHERE axa01=tm.axa01  
                  AND axa02=tm.axa02 
               LET tm.axa03 = l_axa03 
               DISPLAY l_axa03 TO axa03  
               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03  
               CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641          
            END IF
            DISPLAY l_axa03 TO axa03 

            SELECT axa05,axa06 
              INTO g_axa05,g_axa06  #編制合併期別 1.月 2.季 3.半年 4.年
             FROM axa_file
            WHERE axa01 = tm.axa01     #族群編號
              AND axa04 = 'Y'          #最上層公司否
            LET tm.axa06 = g_axa06
            DISPLAY BY NAME tm.axa06
            CALL r016_set_entry()    
            CALL r016_set_no_entry()

            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
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

         AFTER INPUT
            IF NOT cl_null(tm.axa06) THEN
               #TQC-B10205 add --start--
               IF tm.axa06 MATCHES '[234]' THEN
                  CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                  CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
               END IF
               #TQC-B10205 add --end--
               #TQC-B10205 mark --start--
               #CASE
               #    WHEN tm.axa06 = '2'  #季 
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.axa03
               #            AND aznn02 = tm.yy
               #            AND aznn03 = tm.q1
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.axa06 = '3'  #半年
               #         IF tm.h1 = '1' THEN  #上半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.axa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 < 3
               #         ELSE                 #下半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.axa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 >='3' #大於等於第三季
               #         END IF
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.axa06 = '4'  #年
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.axa03
               #            AND aznn02 = tm.yy
               #         LET tm.em = MONTH(l_aznn01)
               #END CASE
               #TQC-B10205 mark --end--
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
               WHEN INFIELD(axa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axz"
                  LET g_qryparam.default1 = tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         BEFORE INPUT
             CALL cl_qbe_init()
             CALL r016_set_entry()    
             CALL r016_set_no_entry() 

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                  
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglr016_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01= 'aglr016'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aglr016','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " ''",
                       " '",tm.axa01,"'", 
                       " '",tm.axa02,"'", 
                       " '",tm.axa03,"'", 
                       " '",tm.yy,"'",    
                       " '",tm.axa06,"'", 
                       " '",tm.em,"'",    
                       " '",tm.q1,"'",    
                       " '",tm.h1,"'",    
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('aglr016',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW aglr016_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    #EXIT WHILE #FUN-AB0043 mark
    CALL r016() #FUN-AB0043 add 
    ERROR ""    #FUN-AB0043 add
END WHILE
CLOSE WINDOW r016_w #FUN-AB0043 add
END FUNCTION

FUNCTION r016()
DEFINE l_axk09_o    LIKE axk_file.axk09,            
       l_axg07_m    LIKE axg_file.axg07,           
       l_axk09_o1   LIKE axk_file.axk09,          
       l_axg07_m1   LIKE axg_file.axg07,         
       l_axk07_o    LIKE axk_file.axk07,        
       l_axk07_o1   LIKE axk_file.axk07,       
       l_cnt        LIKE type_file.num5,     
       l_sql,l_sql1 STRING                 
DEFINE l_axz08      LIKE axz_file.axz08   
DEFINE l_axf09_axz05      LIKE axz_file.axz05         
DEFINE l_axf10_axz05      LIKE axz_file.axz05        
DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10  
DEFINE l_i                LIKE type_file.num5 
DEFINE l_aag04            LIKE aag_file.aag04
DEFINE l_axf01            STRING  
DEFINE l_axf02            STRING 
DEFINE i                  LIKE type_file.num5

   CALL cl_del_data(l_table)
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ? )"
   PREPARE insert_rep_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_rep_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang #FUN-AB0043 add

   #建立TempTable以便處理科目為MISC的資料
   DROP TABLE r016_tmp
   CREATE TEMP TABLE r016_tmp(
     aag02   LIKE aag_file.aag02,
     axg06   LIKE axg_file.axg06,
     axg07   LIKE axg_file.axg07,
     axg05   LIKE axg_file.axg05,
     axg02   LIKE axg_file.axg02,
     axg04   LIKE axg_file.axg04,
     axg13   LIKE axg_file.axg13,
     axg08   LIKE axg_file.axg08,
     con_amt LIKE axg_file.axg08,
     axg12   LIKE axg_file.axg12,
     axk07   LIKE axk_file.axk07,
     dc      LIKE axj_file.axj06,
     flag_r  LIKE type_file.chr1,   #要不要經過持股比例的計算
     curr1   LIKE axz_file.axz06,
     curr3   LIKE axz_file.axz06)

   DELETE FROM r016_tmp
   LET l_sql = "INSERT INTO r016_tmp VALUES(?,?,?,?,?,
                                            ?,?,?,?,?,
                                            ?,?,?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF SQLCA.SQLCODE THEN  
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET l_sql = "SELECT * ",
               "  FROM axf_file ",
               " WHERE axf13 = '",tm.axa01,"'",
               "   AND axf16 = '",tm.axa02,"'",
               "   AND axfacti='Y'",            #有效的資料
               " ORDER BY axf09,axf10,axf01,axf02,axf04"
   PREPARE r016_axf_p1 FROM l_sql
   IF STATUS THEN 
      LET g_showmsg=tm.axa01,'/',tm.axa02,'/',tm.axa03
      CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:axf_p1',STATUS,1)  
   END IF 
   DECLARE r016_axf_c1 CURSOR FOR r016_axf_p1
   FOREACH r016_axf_c1 INTO g_axf.*

       LET l_axf01 = g_axf.axf01
       LET l_axf02 = g_axf.axf02  
       LET l_axf01 = l_axf01.substring(1,4)  
       LET l_axf02 = l_axf02.substring(1,4) 
       CALL r016_process(l_axf01,l_axf02,i) 

   END FOREACH

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.yy,";",tm.em
  
   CALL cl_prt_cs3('aglr016','aglr016',g_sql,g_str)

END FUNCTION

FUNCTION r016_process(p_axf01,p_axf02,i) 
DEFINE p_axf01   STRING
DEFINE p_axf02   STRING,
       l_cnt,l_cut  LIKE type_file.num5,
       l_sql,l_sql1 STRING,            
       i,g_no       LIKE type_file.num5 
DEFINE l_axz08      LIKE axz_file.axz08 
DEFINE l_axf09_axz05      LIKE axz_file.axz05         
DEFINE l_axf10_axz05      LIKE axz_file.axz05        
DEFINE l_axk10_axk11_sum  LIKE axk_file.axk10 
DEFINE l_i                LIKE type_file.num5
DEFINE l_aag04            LIKE aag_file.aag04 
DEFINE g_dbs_axf09        LIKE azp_file.azp03  
DEFINE g_dbs_axf10        LIKE azp_file.azp03  
DEFINE l_axb02            LIKE axb_file.axb02  
DEFINE l_axt03            LIKE axt_file.axt03 
DEFINE l_axz03_axf09      LIKE axz_file.axz03 
DEFINE l_axz03_axf10      LIKE axz_file.axz03  
DEFINE l_axz06_axf16      LIKE axf_file.axf16

     DELETE FROM r016_tmp 

     SELECT axz05 INTO g_axf09_axz05  
       FROM axz_file
      WHERE axz01 = g_axf.axf09
      SELECT axz05 INTO g_axf10_axz05  
       FROM axz_file
      WHERE axz01 = g_axf.axf10

     SELECT axz08 INTO g_axz08  
       FROM axz_file
      WHERE axz01 = g_axf.axf09
      SELECT axz08 INTO g_axz08_axf10  
       FROM axz_file WHERE axz01 = g_axf.axf10
 
     #因系統目前在處理沖銷分錄時己經不再限於只有上下層公司的關係才能沖銷
     #之前的應用方式為tm.axa02上層公司輸入之後抓取的axg,axk資料都是自己本身
     #或是下層資料,但側流時不一定合併主體和來源/目的公司為同一顆tree，
     #SQL抓資料時分為以下狀況 ：
     #A.來源(目的)公司=合併主體：(順流)
     #  A1.axg02 = 自己, axg04 = 自己
     #  A2.axg02 = 不用加入此條件, axg04 = 自己
     #B.來源(目的)公司 <> 合併主體：(側流或逆流)
     #  IF 屬於上層公司
     #    1.最上層公司：條件=>axg02 = 自己, axg04 = 自己
     #    2.中間層(有上層也有下層),條件=> axg02 = 自己的上層公司,axg04 = 自己 
     #  ELSE
     #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己
     #  END IF
  
     #--先判斷g_axf.axf09(來源)/g_axf.axf10(目的)各自是否為上層公司--
     LET g_cnt_axf09 = 0
     SELECT COUNT(*) INTO g_cnt_axf09 
       FROM axa_file
      WHERE axa01 = g_axf.axf13   #群組
        AND axa02 = g_axf.axf09   #上層公司 

     LET g_cnt_axf10 = 0
     SELECT COUNT(*) INTO g_cnt_axf10 
       FROM axa_file
      WHERE axa01 = g_axf.axf13   #群組
        AND axa02 = g_axf.axf10   #上層公司

     IF g_cnt_axf09 > 0 THEN    #代表為上層公司
        #判斷是否存在下層
        SELECT COUNT(*) INTO g_low_axf09 
          FROM axb_file
         WHERE axb01 = tm.axa01
           AND axb04 = g_axf.axf09
        IF g_low_axf09 > 0 THEN    
             #--如果l_up_axf09 = 0 代表是最下層
             SELECT COUNT(*) INTO g_up_axf09
               FROM axa_file 
              WHERE axa01 = tm.axa01
                AND axa02 = g_axf.axf09
            IF g_up_axf09 <> 0 THEN         
                SELECT axb02 INTO g_axa02_axf09  
                  FROM axb_file
                 WHERE axb01 = tm.axa01
                   AND axb04 = g_axf.axf09
                #--如果g_up_axf09 = 0 代表是最下層
                SELECT COUNT(*) INTO g_up_axf09   
                  FROM axa_file 
                 WHERE axa01 = tm.axa01
                   AND axa02 = g_axf.axf09
             END IF
         END IF
     ELSE
         SELECT axb02 INTO g_axa02_axf09     
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf09
     END IF   

     IF g_cnt_axf10 > 0 THEN   #代表為上層公司
         #判斷是否存在下層
         SELECT COUNT(*) INTO g_low_axf10   
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
         IF g_low_axf10 > 0 THEN             
             #--如果l_up_axf10 = 0 代表是最下層
             SELECT COUNT(*) INTO g_up_axf10 
               FROM axa_file 
              WHERE axa01 = tm.axa01
                AND axa02 = g_axf.axf10
            IF g_up_axf10 <> 0 THEN         
                SELECT axb02 INTO g_axa02_axf10 
                  FROM axb_file
                 WHERE axb01 = tm.axa01
                   AND axb04 = g_axf.axf10
            END IF
         END IF
     ELSE
         SELECT axb02 INTO g_axa02_axf10       
           FROM axb_file
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
     END IF   

     #是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的合併帳別
     #IF 'N' -->則為當下營運中心合併帳別
     #不是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的上層公司的合併帳別
     #IF 'N' -->則為當下營運中心的合併帳別
     
     IF g_cnt_axf09 > 0 THEN   #為上層公司
         SELECT axa09 INTO g_axa09_axf09  
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = g_axf.axf09
         SELECT axz03 INTO l_axz03_axf09 
           FROM axz_file 
          WHERE axz01 = g_axf.axf09
         SELECT azp03 INTO g_dbs_axf09 FROM azp_file
          WHERE azp01 = l_axz03_axf09
         IF g_axa09_axf09 = 'Y' THEN 
             LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)
         ELSE
             LET g_dbs_axf09 = s_dbstring(g_dbs)
         END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
         SELECT axb02 INTO l_axb02
           FROM axb_file 
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf09
         SELECT axa09,axa02 INTO g_axa09_axf09,g_axa02_axf09   #FUN-A90006
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = l_axb02
         SELECT axz03 INTO l_axz03_axf09 
           FROM axz_file 
          WHERE axz01 = l_axb02
         SELECT azp03 INTO g_dbs_axf09 FROM azp_file
          WHERE azp01 = l_axz03_axf09
         IF g_axa09_axf09 = 'Y' THEN     #來源公司合併帳別    
             LET g_dbs_axf09 = s_dbstring(g_dbs_axf09)
         ELSE
             LET g_dbs_axf09 = s_dbstring(g_dbs)
         END IF
     END IF        
     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(l_axz03_axf09,'aaz_file'),
                 " WHERE aaz00 = '0'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
     CALL cl_parse_qry_sql(g_sql,l_axz03_axf09) RETURNING g_sql
     PREPARE r016_aaz_p1 FROM g_sql
     DECLARE r016_aaz_c1 CURSOR FOR r016_aaz_p1
     OPEN r016_aaz_c1
     FETCH r016_aaz_c1 INTO g_aaz641_axf09   #合併帳別
     CLOSE r016_aaz_c1

     IF g_cnt_axf10 > 0 THEN   #為上層公司
         SELECT axa09 INTO g_axa09_axf10  
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = g_axf.axf10
         SELECT axz03 INTO l_axz03_axf10 
           FROM axz_file 
          WHERE axz01 = g_axf.axf10
         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
          WHERE azp01 = l_axz03_axf10
         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別  
             LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)
         ELSE
             LET g_dbs_axf10 = s_dbstring(g_dbs)
         END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取aaz641
         SELECT axb02 INTO l_axb02
           FROM axb_file 
          WHERE axb01 = tm.axa01
            AND axb04 = g_axf.axf10
         SELECT axa09 INTO g_axa09_axf10   
           FROM axa_file 
          WHERE axa01 = tm.axa01
            AND axa02 = l_axb02
         SELECT axz03 INTO l_axz03_axf10 
           FROM axz_file 
          WHERE axz01 = l_axb02
         SELECT azp03 INTO g_dbs_axf10 FROM azp_file
          WHERE azp01 = l_axz03_axf10
         IF g_axa09_axf10 = 'Y' THEN     #來源公司合併帳別   
             LET g_dbs_axf10 = s_dbstring(g_dbs_axf10)
         ELSE
             LET g_dbs_axf10 = s_dbstring(g_dbs)
         END IF
     END IF        
     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(l_axz03_axf10,'aaz_file'),
                 " WHERE aaz00 = '0'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
     CALL cl_parse_qry_sql(g_sql,l_axz03_axf10) RETURNING g_sql
     PREPARE r016_aaz_p2 FROM g_sql
     DECLARE r016_aaz_c2 CURSOR FOR r016_aaz_p2
     OPEN r016_aaz_c2
     FETCH r016_aaz_c2 INTO g_aaz641_axf10   #合併帳別
     CLOSE r016_aaz_c2
 
     #取出來源及目的公司各自的記帳幣別供後續沖銷時轉換幣別匯率使用
     SELECT axz06 INTO g_axz06_axf09   
       FROM axz_file
      WHERE axz01 = g_axf.axf09   #來源公司記帳幣別
     SELECT axz06 INTO g_axz06_axf10    #FUN-A90006
       FROM axz_file
      WHERE axz01 = g_axf.axf10   #目的公司記帳幣別

     SELECT axz06 INTO l_axz06_axf16
         FROM axz_file
        WHERE axz01 = g_axf.axf16   #合併主體幣別

     #來源公司合併金額:
     IF g_axf.axf15 = '1' THEN        
         LET l_sql =" SELECT 'A','1',aag02,axg06,axg07,axg05,axg02,axg04,(axg13-axg14),",
                    "        (axg08-axg09),(axg08-axg09),axg12,'",g_axz08_axf10,"','2','N'," ,
                    "        axz06,'",l_axz06_axf16,"'",
                    "   FROM axg_file,aag_file,axz_file ",
                    "  WHERE axg01 ='",tm.axa01,"' ",   #群組
                    "    AND aag00 = axg00 ",
                    "    AND aag01 = axg05 ",
                    "    AND axz01 = '",g_axf.axf09,"'",
                    "    AND axg00 ='",g_aaz641_axf09,"' ",  #合併帳別   
                    "    AND axg04 ='",g_axf.axf09,"' ",      #來源公司
                    "    AND axg041='",g_axf09_axz05,"' ",    #來源帳別  
                    "    AND axg06 = ",tm.yy,                 #年度
                    "    AND axg07 = '",tm.em,"'"             

                    #A.來源公司=合併主體：(順流)
                    #  來源:axg02 = 自己(axf09), axg04 = 自己(axf09)
                    #  目的:axg02 = 不用加入此條件, axg04 = 自己(axf10)
                    #B.來源公司 <> 合併主體：(側流或逆流)
                    #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
                    #    1.最上層公司：條件=>axg02 = 自己(axf09), axg04 = 自己(axf09)
                    #    2.中間層(有上層也有下層),
                    #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf09),axg04 = 自己(axf09) 
                    #       b.關係人交易:條件=>axg02 = 自己(axf09),axg04 = 自己(axf09)
                    #  ELSE
                    #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf09)
                    #  END IF
                     IF g_axf.axf09 = g_axf.axf16 THEN
                         #-FUN-A70011
                         IF g_axf.axf14 = 'Y' THEN
                             LET l_sql = l_sql CLIPPED,
                                 "    AND axg02 = '",g_axa02_axf10,"'" 
                         ELSE
                             LET l_sql = l_sql CLIPPED,
                             "    AND axg02 = '",g_axf.axf09,"'" 
                         END IF 
                     ELSE
                         IF g_cnt_axf09 > 0 THEN
                             IF g_low_axf09 = 0 THEN #最上層 
                                 LET l_sql = l_sql CLIPPED,
                                     "    AND axg02 = '",g_axf.axf09,"'" 
                             ELSE
                                 IF g_axf.axf14 = 'Y' THEN  
                                     LET l_sql = l_sql CLIPPED,
                                         "    AND axg02 = '",g_axa02_axf09,"'"   #FUN-A90006
                                 ELSE                                            #FUN-A60099
                                     LET l_sql = l_sql CLIPPED,                  #FUN-A60099
                                         "    AND axg02 = '",g_axf.axf09,"'"     #FUN-A60099
                                 END IF                                          #FUN-A60099 
                             END IF
                         ELSE
                             LET l_sql = l_sql CLIPPED,
                             "    AND axg02 = '",g_axa02_axf09,"'"               #FUN-A90006
                         END IF  
                     END IF
     #axf15 = '2' 來源科目檔案資料來源:axk_file
     ELSE
         LET l_sql =" SELECT 'A','2',aag02,axk08,axk09,axk05,axk02,axk04,(axk18-axk19), ", 
                    " (axk10-axk11),(axk10-axk11), ",  
                    "        axk14,'",g_axz08_axf10,"','2','N',axz06,'",l_axz06_axf16,"' ",   
                    "   FROM axk_file,aag_file,axz_file ",
                    "  WHERE axk01 ='",tm.axa01,"' ",    #群組
                    "    AND aag00 = axk00 ",
                    "    AND aag01 = axk05 ",
                    "    AND axz01 = '",g_axf.axf09,"'",
                    "    AND axk00 ='",g_aaz641_axf09,"' ",   
                    "    AND axk04 ='",g_axf.axf09,"' ",       #來源公司
                    "    AND axk041='",g_axf09_axz05,"' ",     #來源帳別   
                    "    AND axk08 = ",tm.yy,                  #年度
                    "    AND axk07 = '",g_axz08_axf10 ,"'", 
                    "    AND axk09 = '",tm.em,"'"           
         #A.來源公司=合併主體：(順流)
         #  來源:axk02 = 自己(axf09), axk04 = 自己(axf09)
         #  目的:axk02 = 不用加入此條件, axk04 = 自己(axf10)
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 來源屬於上層公司(g_cnt_axf09 > 0)
         #    1.最上層公司：條件=>axk02 = 自己(axf09), axk04 = 自己(axf09)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> axk02 = 自己的上層公司(l_axa_axf09),axk04 = 自己(axf09) 
         #       b.關係人交易:條件=>axk02 = 自己(axf09),axk04 = 自己(axf09)
         #  ELSE
         #    1.最下層公司: 條件=>axk02 = 不用加入此條件, axk04 = 自己(axf09)
         #  END IF
         IF g_axf.axf09 = g_axf.axf16 THEN
             IF g_axf.axf14 = 'Y' THEN
                 LET l_sql = l_sql CLIPPED,
                 "    AND axk02 = '",g_axa02_axf09,"'"   
             ELSE
                 LET l_sql = l_sql CLIPPED,
                 "    AND axk02 = '",g_axf.axf09,"'" 
             END IF 
         ELSE
             IF g_cnt_axf09 > 0 THEN
                  IF g_low_axf09 = 0 THEN #最上層  
                     LET l_sql = l_sql CLIPPED,
                         "    AND axk02 = '",g_axf.axf09,"'" 
                 ELSE
                     IF g_axf.axf14 = 'Y' THEN     
                         LET l_sql = l_sql CLIPPED,
                             "    AND axk02 = '",g_axa02_axf09,"'" 
                     ELSE                         
                         LET l_sql = l_sql CLIPPED, 
                             "    AND axk02 = '",g_axf.axf09,"'"   
                     END IF                                       
                 END IF
             ELSE
                  LET l_sql = l_sql CLIPPED,
                  "    AND axk02 = '",g_axa02_axf09,"'"               #FUN-A90006
             END IF  
         END IF
     END IF

     IF g_axf.axf15 = '1' THEN  #判斷來源檔是否為單一科目或MISC--
         CASE 
           WHEN p_axf01 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 IN (SELECT DISTINCT axs03 FROM axs_file ",
             "                   WHERE axs00 = '",g_aaz641_axf09,"'",   
             "                     AND axs01 = '",g_axf.axf01,"'",
             "                     AND axs09 = '",g_axf.axf09,"'",
             "                     AND axs10 = '",g_axf.axf10,"'",
             "                     AND axs12 = '",g_aaz641_axf10,"'",  
             "                     AND axs13 = '",g_axf.axf13,"')" 
           WHEN p_axf01 != 'MISC'
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 = '",g_axf.axf01,"'"
         END CASE
     ELSE
         CASE WHEN p_axf01 = 'MISC' 
               LET l_sql = l_sql CLIPPED,
               "    AND axk05 IN (SELECT DISTINCT axs03 FROM axs_file ",
               "                   WHERE axs00 = '",g_aaz641_axf09,"'",  
               "                     AND axs01 = '",g_axf.axf01,"'",
               "                     AND axs09 = '",g_axf.axf09,"'",
               "                     AND axs10 = '",g_axf.axf10,"'",
               "                     AND axs12 = '",g_aaz641_axf10,"'",  
               "                     AND axs13 = '",g_axf.axf13,"')"  
              WHEN p_axf01 != 'MISC'
                LET l_sql = l_sql CLIPPED,
                "    AND axk05 = '",g_axf.axf01,"'"
         END CASE
     END IF

     #目的公司合併金額:
     IF g_axf.axf17 = '1' THEN    #目的檔案資料來源 axf17 = '1'-->axg_file
         LET l_sql = l_sql CLIPPED,   
         "  UNION ",
         " SELECT 'B','1',aag02,axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,(axg08-axg09)*-1, ",  
         "        (axg08-axg09)*-1,",                 
         "        axg12,'",g_axz08,"','1','N',axz06,'",l_axz06_axf16,"' ",    
         "   FROM axg_file,aag_file,axz_file ",
         "  WHERE axg01 ='",tm.axa01,"' ",
         "    AND aag00 = axg00 ",
         "    AND aag01 = axg05 ",
         "    AND axz01 = '",g_axf.axf10,"'",
         "    AND axg00 ='",g_aaz641_axf10,"' ",               
         "    AND axg04 ='",g_axf.axf10,"' ",                   #對沖公司
         "    AND axg041='",g_axf10_axz05,"' ",                 #對沖帳別  
         "    AND axg06 = ",tm.yy,
         "    AND axg07 = '",tm.em,"'"                         
         CASE 
           WHEN p_axf02 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 IN (SELECT DISTINCT axt03 FROM axt_file ",
             "                   WHERE axt00 = '",g_aaz641_axf09,"'", 
             "                     AND axt01 = '",g_axf.axf02,"'",
             "                     AND axt09 = '",g_axf.axf09,"'",
             "                     AND axt10 = '",g_axf.axf10,"'",
             "                     AND axt12 = '",g_aaz641_axf10,"'",  
             "                     AND axt13 = '",g_axf.axf13,"'",  
             "                     AND axt04 != 'Y') "  #是否依據公式設定
           WHEN p_axf02 != 'MISC'
             LET l_sql = l_sql CLIPPED,
             "    AND axg05 = '",g_axf.axf02,"'"
         END CASE

         #A.來源公司=合併主體：(順流)
         #  目的:axg02 = 自己的上層公司(g_axa02_axf10), axg04 = 自己
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 目的屬於上層公司
         #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
         #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
         #  ELSE
         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
         #  END IF
         IF g_cnt_axf10 > 0 THEN
             IF g_low_axf10 = 0 THEN #最上層   
                 LET l_sql = l_sql CLIPPED,
                     "    AND axg02 = '",g_axf.axf10,"'"
             ELSE
                 IF g_up_axf10 > 0 THEN    #大於0代表不是最下層   
                     IF g_axf.axf14 = 'Y' THEN             
                         LET l_sql = l_sql CLIPPED,
                             "    AND axg02 = '",g_axa02_axf10,"'" 
                     ELSE                                 
                         LET l_sql = l_sql CLIPPED,      
                             "    AND axg02 = '",g_axf.axf10,"'" 
                     END IF                                      
                 END IF                
             END IF
         ELSE
             LET l_sql = l_sql CLIPPED,
             "    AND axg02 = '",g_axa02_axf10,"'" 
         END IF
     ELSE                             #axf17 = '2' -->axk_file        
         LET l_sql = l_sql CLIPPED,       
         "  UNION ",
         " SELECT 'B','2',aag02,axk08,axk09,axk05,axk02,axk04,(axk18-axk19)*-1,(axk10-axk11)*-1, ",  
         "        (axk10-axk11)*-1,",
         "        axk14,'",g_axz08,"','1','N',axz06,'",l_axz06_axf16,"' ",                  
         "   FROM axk_file,aag_file,axz_file ",
         "  WHERE axk01 ='",tm.axa01,"' ",
         "    AND aag00 = axk00 ",
         "    AND aag01 = axk05 ",
         "    AND axz01 = '",g_axf.axf10,"'",
         "    AND axk00 ='",g_aaz641_axf10,"' ",   
         "    AND axk04 ='",g_axf.axf10,"' ",      #對沖公司
         "    AND axk041='",g_axf10_axz05,"' ",    #對沖帳別  
         "    AND axk08 = ",tm.yy,
         "    AND axk07 = '",g_axz08,"'",         
         "    AND axk09 = '",tm.em,"'"
         CASE 
           WHEN p_axf02 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axk05 IN (SELECT DISTINCT axt03 FROM axt_file ",
             "                   WHERE axt00 = '",g_aaz641_axf09,"'",   
             "                     AND axt01 = '",g_axf.axf02,"'",
             "                     AND axt09 = '",g_axf.axf09,"'",
             "                     AND axt10 = '",g_axf.axf10,"'",
             "                     AND axt12 = '",g_aaz641_axf10,"'",  
             "                     AND axt13 = '",g_axf.axf13,"'",
             "                     AND axt04 != 'Y') "    #是否依據公式設定
           WHEN p_axf02 != 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND axk05 = '",g_axf.axf02,"'"   
         END CASE
         #A.來源公司=合併主體：(順流)
         #  目的:axg02 = 不用加入此條件, axg04 = 自己
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 目的屬於上層公司
         #    1.最上層公司：條件=>axg02 = 自己(axf10), axg04 = 自己(axf10)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> axg02 = 自己的上層公司(l_axa_axf10),axg04 = 自己(axf10) 
         #       b.關係人交易:條件=>axg02 = 自己(axf10),axg04 = 自己(axf10)
         #  ELSE
         #    1.最下層公司: 條件=>axg02 = 不用加入此條件, axg04 = 自己(axf10)
         #  END IF
         IF g_cnt_axf10 > 0 THEN
             IF g_low_axf10 = 0 THEN #最上層   
                 LET l_sql = l_sql CLIPPED,
                     "    AND axk02 = '",g_axf.axf10,"'"
             ELSE
                 IF g_up_axf10 > 0 THEN 
                     IF g_axf.axf14 = 'Y' THEN 
                         LET l_sql = l_sql CLIPPED,
                             "    AND axk02 = '",g_axa02_axf10,"'"  
                     ELSE                   
                         LET l_sql = l_sql CLIPPED,                
                             "    AND axk02 = '",g_axf.axf10,"'"  
                     END IF                                      
                 END IF   
             END IF
         ELSE
             LET l_sql = l_sql CLIPPED,
                "    AND axk02 = '",g_axa02_axf10,"'"     
         END IF
     END IF

     PREPARE r016_axg_misc_p1 FROM l_sql
     IF STATUS THEN 
        LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03,"/",tm.yy                                  
        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:6',STATUS,1)  
     END IF 
     DECLARE r016_axg_misc_c1 CURSOR FOR r016_axg_misc_p1
     
     FOREACH r016_axg_misc_c1 INTO g_type,g_flag,g_aag02,g_axg.axg06,g_axg.axg07,g_axg.axg05,
                              g_axg.axg02,g_axg.axg04,g_axg.axg13,g_axg.axg08,g_con_amt,
                              g_axg.axg12,   #FUN-A30079 
                              g_axk07,g_dc,g_flag_r,g_curr1,g_curr3
       IF SQLCA.sqlcode THEN 
          LET g_showmsg=tm.axa01,"/",tm.axa01,"/",tm.axa01,"/",tm.yy                                    #NO.FUN-710023
          CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'r016_axg_misc_1',SQLCA.sqlcode,1) 
          LET g_success = 'N' 
          CONTINUE FOREACH  
       END IF
   
       IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

       #不相同時如果為損益類科目且axa05 = '1'要取子公司科餘金額:記帳-->功能-->合併主體幣別)
       SELECT axz06 INTO l_axz06_axf16 
         FROM axz_file
        WHERE axz01 = g_axf.axf16   #合併主體幣別
       IF g_axg.axg12 != l_axz06_axf16 THEN 
           SELECT aag04 INTO l_aag04
            FROM aag_file
            WHERE aag00=g_aaz641
              AND aag01=g_axg.axg05
           #依科目性質來判斷取"現時"或"平均"匯率
           IF l_aag04 = '1' THEN   
               CALL r016_getrate('1',tm.yy,tm.em,
                                 g_axg.axg12,l_axz06_axf16)  
               RETURNING l_rate
               LET g_con_amt = g_con_amt  * l_rate  
           ELSE 
               IF g_axa05 <> '1' THEN   
                   CALL r016_getrate('3',tm.yy,tm.em,
                                     g_axg.axg12,l_axz06_axf16)
                   RETURNING l_rate
                   IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
                   LET g_con_amt = g_con_amt  * l_rate 
               ELSE
                   IF g_type = 'A' THEN
                       IF g_cnt_axf09 > 0 THEN
                           CALL r016_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_con_amt
                       ELSE
                           #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                           #來源或目的/aej_file or aek_file/合併主體幣別
                           CALL r016_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_con_amt
                       END IF 
                   ELSE
                       IF g_cnt_axf10 > 0 THEN    #大於0代表不是最下層,資料來源->axkk_file or axh_file  
                           CALL r016_ins_axj1_chg1(g_type,g_flag,l_axz06_axf16) RETURNING g_con_amt
                       ELSE
                           #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                           #來源或目的/aej_file or aek_file/合併主體幣別
                           CALL r016_ins_axj1_chg(g_type,g_flag,l_axz06_axf16) RETURNING g_con_amt
                       END IF  
                   END IF   
               END IF   
           END IF
       END IF
       CALL get_rate()  
       IF g_axf.axf03='N' OR (g_axf.axf03='Y' AND g_rate=0) THEN
          LET g_con_amt=g_con_amt                           #金額
       ELSE
          IF g_flag_r='Y' THEN
             LET g_con_amt=g_con_amt*(1-g_rate)          #金額
          ELSE
             LET g_con_amt=g_con_amt                     #金額
          END IF
       END IF

       SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
       IF cl_null(l_cut) THEN LET l_cut = 0 END IF
       LET g_con_amt=cl_digcut(g_con_amt,l_cut)

       #先將資料寫進TempTable裡 
       EXECUTE insert_prep USING g_aag02,g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                 g_axg.axg02,g_axg.axg04,g_axg.axg13,g_axg.axg08,g_con_amt,
                                 g_axg.axg12,          
                                 g_axk07,g_dc,g_flag_r,g_curr1,g_curr3
     END FOREACH

     IF p_axf02 = 'MISC' THEN
         IF g_axf.axf17 = '1' THEN 
             #貸 子公司 少數股權,少數股權淨利
             #依據公式設定(對沖科目中axt04=Y)
             DECLARE r016_axt_cs1 CURSOR FOR
               #SELECT DISTINCT axt03,axt04,axt05 FROM axt_file   #CHI-D40021 mark
                SELECT DISTINCT axt03 FROM axt_file               #CHI-D40021
                 WHERE axt00 = g_aaz641_axf09 
                   AND axt01 = g_axf.axf02
                   AND axt09 = g_axf.axf09
                   AND axt10 = g_axf.axf10
                   AND axt12 =  g_aaz641_axf10
                   AND axt04 = 'Y'             #是否依據公式設定
                   AND axt13 = g_axf.axf13
             FOREACH r016_axt_cs1 INTO g_axu03
                 LET l_sql =
                 " SELECT aag02,axg06,axg07,axg05,axg02,axg04,(axg13-axg14),(axg08-axg09),",
                 "        (axg08-axg09),",     
                 "        axg12,'",g_axz08_axf10,"','2','Y',axz06,'",l_axz06_axf16,"'",               
               # "   FROM axg_file ",           #FUN-C10024
                 "   FROM axg_file,aag_file ",  #FUN-C10024
                 "  WHERE axg01 ='",tm.axa01,"' ",
                 "    AND aag00 = axg00 ",      #FUN-C10024 
                 "    AND aag01 = axg05 ",      #FUN-C10024
                 "    AND axg00 ='",g_aaz641_axf10,"' ",   
                 "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
                 "    AND axg041='",g_axf10_axz05,"' ", #對沖帳別 
                 "    AND axg06 = ",tm.yy,
                 "    AND axg07 = '",tm.em,"'"     
                 IF g_cnt_axf10 > 0 THEN
                     IF g_low_axf10 = 0 THEN #最上層   
                         LET l_sql = l_sql CLIPPED,
                             "    AND axg02 = '",g_axf.axf10,"'"
                     ELSE
                         IF g_up_axf10 > 0 THEN      
                             LET l_sql = l_sql CLIPPED,
                                 "    AND axg02 = '",g_axa02_axf10,"'"   
                         END IF
                    END IF
                 ELSE
                     LET l_sql = l_sql CLIPPED,
                     "    AND axg02 = '",g_axa02_axf10,"'"  
                 END IF
                 LET l_sql = l_sql CLIPPED,
                 "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
                 "                   WHERE axu00 = '",g_aaz641_axf09,"'",
                 "                     AND axu01 = '",g_axf.axf02,"'",
                 "                     AND axu09 = '",g_axf.axf09,"'",
                 "                     AND axu10 = '",g_axf.axf10,"'",
                 "                     AND axu12 = '",g_aaz641_axf10,"'", 
                 "                     AND axu13 = '",g_axf.axf13,"'",　
                 "                     AND axu05 = '+'",
                 "                     AND axu03 = '",g_axu03,"')"
                 LET l_sql = l_sql CLIPPED,     
                 "  UNION ",
                 " SELECT aag02,axg06,axg07,axg05,axg02,axg04,(axg13-axg14)*-1,", 
                 "        (axg08-axg09)*-1,(axg08-axg09)*-1,'",g_axz06_axf10,"','",g_axz08_axf10,"','2','Y',",
                 "        axz06,,'",l_axz06_axf16,"'",
                 "   FROM axg_file,aag_file,axz_file ",
                 "  WHERE axg01 ='",tm.axa01,"' ",
                 "    AND aag00 = axg00 ",
                 "    AND aag01 = axg05 ",
                 "    AND axz01 = '",g_axf.axf10,"'",
                 "    AND axg00 ='",g_aaz641_axf10,"' ", 
                 "    AND axg04 ='",g_axf.axf10,"' ",   #對沖公司
                 "    AND axg041='",g_axf10_axz05,"' ",   #對沖帳別  
                 "    AND axg06 = ",tm.yy,
                 "    AND axg07 = '",tm.em,"'",         
                 "    AND axg05 IN (SELECT DISTINCT axu04 FROM axu_file ",
                 "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                 "                     AND axu01 = '",g_axf.axf02,"'",
                 "                     AND axu09 = '",g_axf.axf09,"'",
                 "                     AND axu10 = '",g_axf.axf10,"'",
                 "                     AND axu12 = '",g_aaz641_axf10,"'", 
                 "                     AND axu13 = '",g_axf.axf13,"'",
                 "                     AND axu05 = '-'",
                 "                     AND axu03 = '",g_axu03,"')"
                 IF g_cnt_axf10 > 0 THEN
                     IF g_low_axf10 = 0 THEN #最上層  
                         LET l_sql = l_sql CLIPPED,
                             "    AND axg02 = '",g_axf.axf10,"'" ,
                             "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
                     ELSE
                         IF g_up_axf10 > 0 THEN      
                             LET l_sql = l_sql CLIPPED,
                                 "    AND axg02 = '",g_axa02_axf10,"'", 
                                 "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
                         END IF
                    END IF
                 ELSE
                     LET l_sql = l_sql CLIPPED,
                     "    AND axg02 = '",g_axa02_axf10,"'",  
                     "   ORDER BY axg06,axg07,axg05,axg02,axg04 "
                 END IF

                 PREPARE r016_misc_p2 FROM l_sql
                 IF STATUS THEN 
                    LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03,"/",tm.yy                                    #NO.FUN-710023
                    CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                 DECLARE r016_misc_c2 CURSOR FOR r016_misc_p2

                 FOREACH r016_misc_c2 INTO g_aag02,g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                           g_axg.axg02,g_axg.axg04,g_axg.axg13,g_axg.axg08,g_con_amt,
                                           g_axg.axg12,   
                                           g_axk07,g_dc,g_flag_r,g_curr1,g_curr3
                    IF SQLCA.sqlcode THEN 
                       LET g_showmsg=tm.axa01,"/",tm.axa01,"/",tm.axa01,"/",tm.yy                                    #NO.FUN-710023
                       CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'r016_misc_c2',SQLCA.sqlcode,1)   #NO.FUN-710023
                       LET g_success = 'N' 
                       CONTINUE FOREACH  
                    END IF
 
                    IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF
 
                    #先將資料寫進TempTable裡 
                    EXECUTE insert_prep USING g_aag02,g_axg.axg06,g_axg.axg07,g_axu03,   #將axg05改成寫入axu03
                                              g_axg.axg02,g_axg.axg04,g_axg.axg13,g_axg.axg08,g_con_amt,
                                              g_axg.axg12,  
                                              g_axk07,g_dc,g_flag_r,g_curr1,g_curr3
                 END FOREACH
             END FOREACH
         ELSE
             #貸 子公司 少數股權,少數股權淨利
             #依據公式設定(對沖科目中axt04=Y)
             DECLARE r016_axt_cs2 CURSOR FOR
               #SELECT DISTINCT axt03,axt04,axt05 FROM axt_file   #CHI-D40021 mark
                SELECT DISTINCT axt03 FROM axt_file               #CHI-D40021
                 #WHERE axt00 = g_aaz641   
                 WHERE axt00 = g_aaz641_axf09 
                   AND axt01 = g_axf.axf02
                   AND axt09 = g_axf.axf09
                   AND axt10 = g_axf.axf10
                   AND axt12 = g_aaz641_axf10  
                   AND axt04 = 'Y'             #是否依據公式設定]
                   AND axt13 = g_axf.axf13 #FUN-930117
             FOREACH r016_axt_cs2 INTO g_axu03
                 LET l_sql =
                 " SELECT aag02,axk08,axk09,axk05,axk02,axk04,(axk18-axk19),(axk10-axk11),",  
                 "        (axk10-axk11),",
                 "        axk14,'",g_axf.axf10,"','2','Y',axz06,'",l_axz06_axf16,"'",  
                 "   FROM axk_file,aag_file,axz_file ",
                 "  WHERE axk01 ='",tm.axa01,"' ",
                 "    AND aag00 = axk00 ",
                 "    AND aag01 = axk05 ",
                 "    AND axz01 = '",g_axf.axf10,"'",
                 "    AND axk00 ='",g_aaz641_axf10,"' ",  
                 "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
                 "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別  
                 "    AND axk07 = '",g_axz08,"'",    
                 "    AND axk08 = ",tm.yy,
                 "    AND axk09 = '",tm.em,"'"  
                 IF g_cnt_axf10 > 0 THEN
                     IF g_low_axf10 = 0 THEN #最上層  
                         LET l_sql = l_sql CLIPPED,
                             "    AND axk02 = '",g_axf.axf10,"'"
                     ELSE
                         IF g_up_axf10 > 0 THEN      
                             LET l_sql = l_sql CLIPPED,
                                 "    AND axk02 = '",g_axa02_axf10,"'"
                         END IF
                     END IF
                 ELSE
                     LET l_sql = l_sql CLIPPED,
                     "    AND axk02 = '",g_axa02_axf10,"'"            
                 END IF
                 LET l_sql = l_sql CLIPPED,
                 "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
                 "                   WHERE axu00 = '",g_aaz641_axf09,"'", 
                 "                     AND axu01 = '",g_axf.axf02,"'",
                 "                     AND axu09 = '",g_axf.axf09,"'",
                 "                     AND axu10 = '",g_axf.axf10,"'",
                 "                     AND axu12 = '",g_aaz641_axf10,"'", 
                 "                     AND axu13 = '",g_axf.axf13,"'",　
                 "                     AND axu05 = '+'",
                 "                     AND axu03 = '",g_axu03,"')"
                 LET l_sql = l_sql CLIPPED,                      
                 "  UNION ",
                 " SELECT aag02,axk08,axk09,axk05,axk02,axk04,(axk08-axk09)*-1,",
                        " axk14,'",g_axz08_axf10,"','2','Y',axz06,'",l_axz06_axf16,"'", 
                 "   FROM axk_file,aag_file,axz_file ",
                 "  WHERE axk01 ='",tm.axa01,"' ",
                 "    AND aag00 = axk00 ",
                 "    AND aag01 = axk05 ",
                 "    AND axz01 = '",g_axf.axf10,"'",
                 "    AND axk00 ='",g_aaz641_axf10,"' ",  
                 "    AND axk04 ='",g_axf.axf10,"' ",   #對沖公司
                 "    AND axk041='",g_axf10_axz05,"' ", #對沖帳別    
                 "    AND axk08 = ",tm.yy,
                 "    AND axk07 = '",g_axz08,"'", 
                 "    AND axk09 = '",tm.em,"'",  
                 "    AND axk05 IN (SELECT DISTINCT axu04 FROM axu_file ",
                 "                   WHERE axu00 = '",g_aaz641_axf09,"'",   
                 "                     AND axu01 = '",g_axf.axf02,"'",
                 "                     AND axu09 = '",g_axf.axf09,"'",
                 "                     AND axu10 = '",g_axf.axf10,"'",
                 "                     AND axu12 = '",g_aaz641_axf10,"'",  
                 "                     AND axu13 = '",g_axf.axf13,"'",
                 "                     AND axu05 = '-'",
                 "                     AND axu03 = '",g_axu03,"')"
                 IF g_cnt_axf10 > 0 THEN
                     IF g_low_axf10 = 0 THEN #最上層 
                         LET l_sql = l_sql CLIPPED,
                             "    AND axk02 = '",g_axf.axf10,"'" ,
                             "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
                     ELSE
                         IF g_up_axf10 > 0 THEN       
                             LET l_sql = l_sql CLIPPED,
                                 "    AND axk02 = '",g_axa02_axf10,"'", 
                                 "  ORDER BY axk08,axk09,axk05,axk02,axk04 "
                         END IF
                     END IF
                 ELSE
                     LET l_sql = l_sql CLIPPED,
                     "    AND axk02 = '",g_axa02_axf10,"'"  
                 END IF
                 PREPARE r016_misc_p3 FROM l_sql
                 IF STATUS THEN 
                    LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03,"/",tm.yy                                    #NO.FUN-710023
                    CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                 DECLARE r016_misc_c3 CURSOR FOR r016_misc_p3   #FUN-A80130
     
                 FOREACH r016_misc_c3 INTO g_aag02,g_axg.axg06,g_axg.axg07,g_axg.axg05,
                                           g_axg.axg02,g_axg.axg04,g_axg.axg13,g_axg.axg08,g_con_amt,
                                           g_axg.axg12, 
                                           g_axk07,g_dc,g_flag_r,g_curr1,g_curr3
                     IF SQLCA.sqlcode THEN 
                        LET g_showmsg=tm.axa01,"/",tm.axa01,"/",tm.axa01,"/",tm.yy                                    #NO.FUN-710023
                        CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'r016_misc_c3',SQLCA.sqlcode,1)   #NO.FUN-710023
                        LET g_success = 'N' 
                        CONTINUE FOREACH  
                     END IF

                     IF g_axg.axg08=0 THEN CONTINUE FOREACH END IF

                     CALL get_rate()  

                     IF g_axf.axf03='N' OR (g_axf.axf03='Y' AND g_rate=0) THEN
                        LET g_con_amt=g_axg.axg08                           #金額
                     ELSE
                        IF g_flag_r='Y' THEN
                           LET g_con_amt=g_axg.axg08*(1-g_rate)          #金額
                        ELSE
                           LET g_con_amt=g_axg.axg08                     #金額
                        END IF
                     END IF

                     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_axz06_axf16
                     IF cl_null(l_cut) THEN LET l_cut = 0 END IF
                     LET g_con_amt=cl_digcut(g_con_amt,l_cut)

                     #先將資料寫進TempTable裡 
                     EXECUTE insert_prep USING g_aag02,g_axg.axg06,g_axg.axg07,g_axu03,   #將axg05改成寫入axu03
                                               g_axg.axg02,g_axg.axg04,g_axg.axg13,g_axg.axg08,g_con_amt,
                                               g_axg.axg12,  
                                               g_axk07,g_dc,g_flag_r,g_curr1,g_curr3
                 END FOREACH
             END FOREACH 
         END IF    
     END IF

     DECLARE r016_tmp_cs CURSOR FOR
     SELECT aag02,axg06,axg07,axg05,axg02,axg04,SUM(axg13),SUM(axg08),
            SUM(con_amt),axg12,axk07,dc,flag_r,curr1,curr3
       FROM r016_tmp
      GROUP BY axg05,aag02,axg06,axg07,axg05,axg02,axg04,axg12,axk07,dc,flag_r,curr1,curr3
      ORDER BY axg05,aag02,axg06,axg07,axg05,axg02,axg04,axg12,axk07,dc,flag_r,curr1,curr3
                 #年    月
     FOREACH r016_tmp_cs INTO g_aag02,g_axg.axg06,g_axg.axg07,g_axg.axg05,
                              g_axg.axg02,g_axg.axg04,g_axg.axg13,g_axg.axg08,
                              g_con_amt,g_axg.axg12,
                              g_axk07,g_dc,g_flag_r,g_curr1,g_curr3
        IF SQLCA.sqlcode THEN 
           LET g_showmsg=tm.axa01,"/",tm.axa01,"/",tm.axa01,"/",tm.yy                           
           CALL s_errmsg('axk01,axk04,axk041,axk08',g_showmsg,'r016_tmp_cs',SQLCA.sqlcode,1)  
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF
        LET l_cnt = 0
        EXECUTE insert_rep_prep USING g_axg.axg05,g_aag02,'99',g_axk07,g_axg.axg04,
                                      g_curr1,g_axg.axg13,g_axg.axg12,g_axg.axg08,
                                      g_curr3,g_con_amt                                              
     END FOREACH

     LET p_axf01 = ''
     LET p_axf02 = ''
END FUNCTION

FUNCTION r016_set_entry() 
    CALL cl_set_comp_entry("q1,em,h1",TRUE) 
END FUNCTION

FUNCTION r016_set_no_entry() 

      CALL cl_set_comp_entry("axa06",FALSE) 

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

FUNCTION r016_getrate(l_value,l_axp01,l_axp02,l_axp03,l_axp04)
DEFINE l_value LIKE axe_file.axe11,
       l_axp01 LIKE axp_file.axp01,
       l_axp02 LIKE axp_file.axp02,
       l_axp03 LIKE axp_file.axp03,
       l_axp04 LIKE axp_file.axp04,
       l_axp05 LIKE axp_file.axp05,    #FUN-770069 add
       l_axp06 LIKE axp_file.axp06,    #FUN-770069 add
       l_axp07 LIKE axp_file.axp07,    #FUN-770069 add
       l_rate  LIKE axp_file.axp05     #No.FUN-680098  DECIMAL(20,6)


   SELECT axp05,axp06,axp07 
     INTO l_axp05,l_axp06,l_axp07 
     FROM axp_file
    WHERE axp01=l_axp01
      AND axp02=(SELECT max(axp02) FROM axp_file
                  WHERE axp01 = l_axp01
                    AND axp02 <=l_axp02
                    AND axp03 = l_axp03
                    AND axp04 = l_axp04)
      AND axp03=l_axp03 
      AND axp04=l_axp04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_axp05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_axp06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_axp07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION

FUNCTION r016_ins_axj1_chg(p_type,p_flag,p_axz06)
DEFINE p_axz06     LIKE axz_file.axz06
DEFINE p_axg12     LIKE axg_file.axg12
DEFINE l_axg08     LIKE axg_file.axg08
DEFINE l_axg09     LIKE axg_file.axg09
DEFINE l_axg08_b   LIKE axg_file.axg08
DEFINE l_axg09_b   LIKE axg_file.axg09
DEFINE l_month_amt LIKE axg_file.axg08
DEFINE l_tot_amt   LIKE axg_file.axg08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_axg12     LIKE axg_file.axg12   
DEFINE l_r         LIKE axp_file.axp05   
DEFINE l_r1        LIKE axp_file.axp05   
DEFINE p_type      LIKE type_file.chr1   
DEFINE l_axz07     LIKE axf_file.axf09   
DEFINE p_flag      LIKE type_file.chr1  

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)
      LET l_axg08 = 0
      LET l_axg09 = 0
      LET l_axg08_b = 0
      LET l_axg09_b = 0
      LET l_month_amt = 0
      LET l_tot_amt = 0
      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
      IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為axk_file or axg_file取各月餘額
     FOR i = 0 TO tm.em   #FUN-A90026 mod
         SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg04
         IF p_type = 'A' THEN       #來源公司 
             CASE 
                WHEN p_flag = '1'        #aej_file
                    LET l_sql =
                    " SELECT SUM(aej07-aej08),aej11",
                    "   FROM aej_file ",
                    "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
                    "    AND aej01 = '",tm.axa01,"'",        #族群
                    "    AND aej02 = '",g_axg.axg04,"'",     #公司
                    "    AND aej04 = '",g_axg.axg05,"'",
                    "    AND aej05 = '",tm.yy,"'",
                    "    AND aej06 = '",i,"'",
                    "  GROUP BY aej11 "
                WHEN p_flag = '2'        #aek_file
                    LET l_sql=
                    " SELECT SUM(aek08-aek09),aek12",
                    "   FROM aek_file",
                    "  WHERE aek00 = '",g_aaz641,"'",
                    "    AND aek01 = '",tm.axa01,"'",
                    "    AND aek02 = '",g_axg.axg04,"'",
                    "    AND aek04 = '",g_axg.axg05,"'",
                    "    AND aek05 = '",g_axk07,"'",
                    "    AND aek06 = '",tm.yy,"'",
                    "    AND aek07 = '",i,"'",
                    "  GROUP BY aek12"
            END CASE
        ELSE        #目的公司
            CASE
              WHEN p_flag = '1'        #aej_file
                 LET l_sql =
                 " SELECT SUM(aej07-aej08),aej11",
                 "   FROM aej_file ",
                 "  WHERE aej00 = '",g_aaz641,"'",        #合併帳別 
                 "    AND aej01 = '",tm.axa01,"'", #族群
                 "    AND aej02 = '",g_axg.axg04,"'",     #公司
                 "    AND aej04 = '",g_axg.axg05,"'",
                 "    AND aej05 = '",tm.yy,"'",
                 "    AND aej06 = '",i,"'",
                 "  GROUP BY aej11 "
              WHEN p_flag = '2'        #aek_file
                 LET l_sql=
                 " SELECT SUM(aek08-aek09),aek12",
                 "   FROM aek_file",
                 "  WHERE aek00 = '",g_aaz641,"'",
                 "    AND aek01 = '",tm.axa01,"'",
                 "    AND aek02 = '",g_axg.axg04,"'",
                 "    AND aek04 = '",g_axg.axg05,"'",
                 "    AND aek05 = '",g_axk07,"'",
                 "    AND aek06 = '",tm.yy,"'",
                 "    AND aek07 = '",i,"'",
                 "  GROUP BY aek12"
            END CASE
        END IF

        PREPARE r016_ins_axj1_p1 FROM l_sql
        IF STATUS THEN
           LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03,"/",tm.yy
           CALL s_errmsg('axg01,axg04,axg041,axg06',g_showmsg,'pre:ins_axj1_p1',STATUS,1)
           LET g_success = 'N'
        END IF
        DECLARE r016_ins_axj1_c1 CURSOR FOR r016_ins_axj1_p1
        FOREACH r016_ins_axj1_c1 INTO l_month_amt,l_axg12    #借-貸/幣別   #FUN-A90026 mod
            LET l_r = 1
            LET l_r1 = 1
            IF i = 0 THEN LET i = 1 END IF  #0期沒有匯率，直接取1期的匯率計算
            CALL r016_getrate('3',tm.yy,i,l_axg12,l_axz07)  #取起始月份至當下月份的匯率  #FUN-A90026
            RETURNING l_r   
            IF cl_null(l_r) THEN LET l_r = 1 END IF
            CALL r016_getrate('3',tm.yy,i,l_axz07,p_axz06) 
            RETURNING l_r1   
            IF cl_null(l_r1) THEN LET l_r1 = 1 END IF
            LET l_month_amt = l_month_amt * l_r * l_r1
            LET l_tot_amt = l_tot_amt + l_month_amt
        END FOREACH
     END FOR
     RETURN l_tot_amt 
END FUNCTION

FUNCTION r016_ins_axj1_chg1(p_type,p_flag,p_axz06)
DEFINE p_axz06     LIKE axz_file.axz06
DEFINE p_axg12     LIKE axg_file.axg12
DEFINE l_axg08     LIKE axg_file.axg08
DEFINE l_axg09     LIKE axg_file.axg09
DEFINE l_axg08_b   LIKE axg_file.axg08
DEFINE l_axg09_b   LIKE axg_file.axg09
DEFINE l_tot_amt   LIKE axg_file.axg08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_axg12     LIKE axg_file.axg12   
DEFINE l_r         LIKE axp_file.axp05   
DEFINE l_r1        LIKE axp_file.axp05   
DEFINE p_flag      LIKE type_file.chr1   
DEFINE p_type      LIKE type_file.chr1   
DEFINE l_axz07     LIKE axf_file.axf09   
DEFINE l_month     LIKE type_file.num5
DEFINE l_amt2      LIKE axh_file.axh08
DEFINE l_amt1      LIKE axh_file.axh08
DEFINE l_amt       LIKE axh_file.axh08

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)

     LET l_tot_amt = 0
     LET l_amt2 = 0
     LET l_amt1 = 0
     LET l_amt  = 0

     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_axz06
     IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為axkk_file or axh_file取各期餘額
     LET l_sql=
     " SELECT axh07,axh12",
     "   FROM axh_file ",
     "  WHERE axh00 = '",g_aaz641,"'",          #合併帳別  
     "    AND axh01 = '",tm.axa01,"'", #族群
     "    AND axh02 = '",g_axg.axg02,"'", #公司
     "    AND axh05 = '",g_axg.axg05,"'",
     "    AND axh06= '",tm.yy,"'",
     "    AND axh07 BETWEEN '0' AND '",tm.em,"'"
     PREPARE p001_axh_p3 FROM l_sql
     DECLARE p001_axh_c3 CURSOR FOR p001_axh_p3
     FOREACH p001_axh_c3 INTO l_month,l_axg12
        IF l_month = 0 THEN CONTINUE FOREACH END IF
        SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01 = g_axg.axg02
        CASE 
           WHEN p_flag = '1'        #axh_file
               SELECT SUM(axh08-axh09) INTO l_amt2
                 FROM axh_file 
                WHERE axh00 = g_aaz641        #合併帳別 
                  AND axh01 = tm.axa01        #族群
                  AND axh02 = g_axg.axg02     #公司
                  AND axh05 = g_axg.axg05
                  AND axh06 = tm.yy
                  AND axh07 = l_month
           WHEN p_flag = '2'        #axkk_file
               SELECT SUM(axkk10-axkk11) INTO l_amt2
                 FROM axkk_file
                WHERE axkk00 = g_aaz641
                  AND axkk01 = tm.axa01
                  AND axkk02 = g_axg.axg02
                  AND axkk05 = g_axg.axg05
                  AND axkk07 = g_axk07
                  AND axkk08 = tm.yy
                  AND axkk09 = l_month
        END CASE
        CASE 
           WHEN p_flag = '1'        #axh_file
               SELECT SUM(axh08-axh09) INTO l_amt1
                 FROM axh_file
                WHERE axh00 = g_aaz641        #合併帳別 
                  AND axh01 = tm.axa01        #族群
                  AND axh02 = g_axg.axg02     #公司
                  AND axh05 = g_axg.axg05
                  AND axh06 = tm.yy
                  AND axh07 = (SELECT MAX(axh07) FROM axh_file
                                WHERE axh00 = g_aaz641        #合併帳別 
                                  AND axh01 = tm.axa01        #族群
                                  AND axh02 = g_axg.axg02     #公司
                                  AND axh05 = g_axg.axg05
                                  AND axh06 = tm.yy
                                  AND axh07 < l_month)
           WHEN p_flag = '2'        #axkk_file
               SELECT SUM(axkk10-axkk11) INTO l_amt1
                 FROM axkk_file
                WHERE axkk00 = g_aaz641
                  AND axkk01 = tm.axa01
                  AND axkk02 = g_axg.axg02
                  AND axkk05 = g_axg.axg05
                  AND axkk07 = g_axk07
                  AND axkk08 = tm.yy
                  AND axkk09 = (SELECT MAX(axkk09) FROM axkk_file
                                 WHERE axkk00 = g_aaz641
                                   AND axkk01 = tm.axa01
                                   AND axkk02 = g_axg.axg02
                                   AND axkk05 = g_axg.axg05
                                   AND axkk07 = g_axk07
                                   AND axkk08 = tm.yy
                                   AND axkk09 < l_month)
        END CASE
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        LET l_amt = l_amt2 - l_amt1

        LET l_r = 1
        LET l_r1 = 1
        CALL r016_getrate('3',tm.yy,l_month,l_axg12,l_axz07)  #取起始月份至當下月份的匯率  #FUN-A90026
        RETURNING l_r   
        IF cl_null(l_r) THEN LET l_r = 1 END IF

        CALL r016_getrate('3',tm.yy,l_month,l_axz07,p_axz06) 
        RETURNING l_r1   
        IF cl_null(l_r1) THEN LET l_r1 = 1 END IF

        LET l_amt = l_amt * l_r * l_r1
        LET l_tot_amt = l_tot_amt + l_amt
     END FOREACH

     RETURN l_tot_amt 
END FUNCTION

FUNCTION get_rate()#持股比率
#DEFINE l_axb07   LIKE axb_file.axb07,   #FUN-C50059 mark
#      l_axb08    LIKE axb_file.axb08,   #FUN-C50059 mark
DEFINE l_axbb07   LIKE axbb_file.axbb07, #FUN-C50059
       l_axbb06   LIKE axbb_file.axbb06, #FUN-C50059
       l_axd07b   LIKE axd_file.axd07b,
       l_axd08b   LIKE axd_file.axd08b,
       l_count    LIKE type_file.num5,    
       l_sql      LIKE type_file.chr1000, 
       l_axz05    LIKE axz_file.axz05     

    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01=g_axf.axf10
    CALL s_ymtodate(tm.yy,tm.em,tm.yy,tm.em) RETURNING g_bdate,g_edate   #FUN-C50059
   #FUN-C50059--mark--  
   #SELECT axb07,axb08 INTO l_axb07,l_axb08 FROM axb_file 
   # WHERE axb01=tm.axa01 AND axb02=tm.axa02 AND axb03=tm.axa03
   #   AND axb04=g_axf.axf10 AND axb05=l_axz05          #MOD-A70113 add
   #FUN-C50059--mark--
   #FUN-C50059--
    SELECT axbb07,axbb06 INTO l_axbb07,l_axbb06 FROM axbb_file 
     WHERE axbb01=tm.axa01 AND axbb02=tm.axa02 AND axbb03=tm.axa03
       AND axbb04=g_axf.axf10 AND axbb05=l_axz05
       AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                      WHERE axbb01=tm.axa01 AND axbb02=tm.axa02 AND axbb03=tm.axa03
                        AND axbb04=p_axb04  AND axbb05=p_axb05  AND axbb06<g_edate)
   #FUN-C50059--
    IF STATUS THEN LET g_rate=0 RETURN END IF
   #IF g_edate >= l_axb08 OR cl_null(l_axb08) THEN LET g_rate=l_axb07/100 RETURN END IF		#FUN-C50059 mark
    IF g_edate >= l_axbb06 OR cl_null(l_axbb06) THEN LET g_rate=l_axbb07/100 RETURN END IF  #FUN-C50059
    
    LET l_count=0
    LET g_rate =0
    LET l_sql="SELECT axd07b,axd08b  FROM axd_file ",
              " WHERE axd01='",tm.axa01,"'",
              "   AND axd02='",tm.axa02,"' AND axd03='",tm.axa03,"'",
              "   AND axd04b='",g_axf.axf10,"' AND axd05b='",l_axz05,"'",    
              " ORDER BY axd08b desc"  #MOD-940010 add
    PREPARE r016_axd_p FROM l_sql
    IF STATUS THEN 
        CALL s_errmsg(' ',' ','prepare:6',STATUS,1) LET g_success = 'N'  RETURN     
    END IF
    DECLARE r016_axd_c CURSOR FOR r016_axd_p

    FOREACH r016_axd_c INTO l_axd07b,l_axd08b
       IF SQLCA.sqlcode  THEN LET g_rate=0 EXIT FOREACH END IF
       LET l_count=l_count+1
       IF g_edate>=l_axd08b THEN LET g_rate=l_axd07b/100 EXIT FOREACH END IF   
    END FOREACH       
    IF l_count=0 THEN LET g_rate=0 RETURN END IF
END FUNCTION


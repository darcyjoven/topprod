# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglg404.4gl
# Descriptions...: 記帳憑証列印
# Date & Author..: 06/10/11 By Tracy
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 報表加入打印額外名稱
# Modify.........: No.TQC-710125 07/03/16 By Ray 原來邏輯會漏打資料
# Modify.........: No.FUN-740055 07/04/12 By lora 會計科目加帳套
# Modify.........: No.FUN-7C0066 07/12/26 By baofei 報表輸出至 Crystal Reports功能  
# Modify.........: No.MOD-820168 08/02/27 By Smapmin 單別長度應依系統設定
# Modify.........: No.MOD-860252 08/07/02 By chenl   增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40092 11/05/19 By xujing 憑證類報表轉GRW
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C10036 12/01/11 By qirl MOD-B80025追單 
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改
# Modify.........: No.FUN-C10036 12/01/16 By yangtt MOD-B90243追單 
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.FUN-D10032 13/01/09 By chenying 4gl中處理單身定位點問題 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD	       	                 #Print condition RECORD
          #wc       LIKE type_f                  #Where Condiction  #NO.FUN-C10036 mark
           wc       STRING,                      #NO.FUN-C10036 add
           book_no  LIKE aba_file.aba00,         #帳別編號
           a   LIKE type_file.chr1,                          #是否列印外幣金額
           b   LIKE type_file.chr1,                          #過賬選擇
           c   LIKE type_file.chr1,                          #有效選擇
           d   LIKE type_file.chr1,                          #列印選擇
           e   LIKE type_file.chr1,                          #是否列印科目編號
           f   LIKE type_file.chr1,                          #FUN-6C0012
           h   LIKE type_file.chr1,                          #MOD-860252
           m   LIKE type_file.chr1                           #是否輸入其它特殊列印條件
           END RECORD 
 
DEFINE   g_bookno   LIKE aba_file.aba00          #帳別編號
DEFINE   g_aaa03    LIKE aaa_file.aaa03          #幣別
DEFINE   g_azi02    LIKE azi_file.azi02          #幣別名稱
DEFINE   g_i        LIKE type_file.num5                     #count/index for any purpose
DEFINE   g_cnt      LIKE type_file.num5      
#No.FUN-7C0066---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                 
#No.FUN-7C0066---End 
###GENGRE###START
TYPE sr1_t RECORD
    aba01 LIKE aba_file.aba01,
    year LIKE type_file.chr4,
    month LIKE type_file.chr2,
    day LIKE type_file.chr2,
    aba21 LIKE aba_file.aba21,
    abb02 LIKE abb_file.abb02,
    abb04 LIKE abb_file.abb04,
    abb07f LIKE abb_file.abb07f,
    abb25 LIKE abb_file.abb25,
    zx02 LIKE zx_file.zx02,
    level01 LIKE type_file.chr1000,
    level02 LIKE type_file.chr1000,
    l_abb07_l LIKE type_file.num20_6,
    l_abb07_r LIKE type_file.num20_6,
    l_pageno LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-7C0066---Begin                                                          
   LET g_sql = "aba01.aba_file.aba01,",
               "year.type_file.chr4,",
               "month.type_file.chr2,", 
               "day.type_file.chr2,", 
               "aba21.aba_file.aba21,",
               "abb02.abb_file.abb02,",    
               "abb04.abb_file.abb04,",
               "abb07f.abb_file.abb07f,",
               "abb25.abb_file.abb25,",
               "zx02.zx_file.zx02,",
               "level01.type_file.chr1000,",
               "level02.type_file.chr1000,",
               "l_abb07_l.type_file.num20_6,",
               "l_abb07_r.type_file.num20_6,",
               "l_pageno.type_file.num5"
   LET l_table = cl_prt_temptable('gglg404',g_sql) CLIPPED                      
   IF l_table = -1 THEN
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092    #FUN-C10036 mark
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092    #FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092   #FUN-C10036 mark
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092   #FUN-C10036 mark
      EXIT PROGRAM                         
   END IF  
#No.FUN-7C0066---End
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
 
   LET g_bookno   = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)		         #Get arguments from command line
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.wc      = ARG_VAL(8)
   LET tm.a       = ARG_VAL(9)
   LET tm.b       = ARG_VAL(10)
   LET tm.c       = ARG_VAL(11)
   LET tm.d       = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET tm.e       = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
 
   IF g_bookno = ' ' OR cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64                 #帳別若為空白則使用預設帳別
   END IF
   #No.FUN-740055  --Begin                                                                                                          
   IF cl_null(tm.book_no) THEN LET tm.book_no=g_aza.aza81 END IF                                                                                
   #No.FUN-740055  --Endi

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 	 #If background job sw is off
      CALL gglg404_tm()	        	         #Input print condition
   ELSE 
      CALL gglg404()			         #Read data and create out-file
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
   CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
END MAIN
 
FUNCTION gglg404_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd		LIKE type_file.chr1000
 
   CALL s_dsmark(g_bookno)
   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW gglg404_w AT p_row,p_col
        WITH FORM "ggl/42f/gglg404"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			 #Default condition
   LET tm.a = 'N'
   LET tm.b = '3'
   LET tm.c = '3'
   LET tm.d = '3'
   LET tm.e = 'Y'
   LET tm.f = 'N'  #FUN-6C0012
   LET tm.h = 'Y'  #MOD-860252
   LET tm.m = 'N'
 # LET tm.book_no = g_bookno   #No.FUN-740055
   LET tm.book_no = g_aza.aza81 #No.FUN-740055
   LET g_pdate    = g_today
   LET g_rlang    = g_lang
   LET g_bgjob    = 'N'
   LET g_copies   = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON aba01,aba02,aba06,abauser
 
       ON ACTION CONTROLP                                                                                                     
          CASE        
             WHEN INFIELD(aba01)                #傳票編號                                                                                   
                CALL cl_init_qry_var()                                                                                       
                LET g_qryparam.form ="q_aba02"                                                                                 
                LET g_qryparam.state = "c"                                                                                   
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                           
                DISPLAY g_qryparam.multiret TO aba01                                                                         
                NEXT FIELD aba01            
          END CASE                        
 
       ON ACTION locale
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controlg      
          CALL cl_cmdask()     
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW gglg404_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   INPUT BY NAME tm.book_no,tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.h,tm.m WITHOUT DEFAULTS  #FUN-6C0012  #No.MOD-860252 add tm.h
       AFTER FIELD book_no
          IF cl_null(tm.book_no) THEN NEXT FIELD book_no END IF  #No.FUN-740055 
          IF NOT cl_null(tm.book_no) THEN 
             SELECT COUNT(*) INTO g_cnt FROM aaa_file 
              WHERE aaa01 = tm.book_no
                AND aaaacti = 'Y'
             IF g_cnt = 0 THEN 
                CALL cl_err(tm.book_no,'aap-229',0)
                NEXT FIELD book_no
             END IF
          END IF
       AFTER FIELD a
          IF tm.a NOT MATCHES "[YN]" THEN NEXT FIELD a END IF
       AFTER FIELD b
          IF tm.b NOT MATCHES "[123]" THEN NEXT FIELD b END IF
       AFTER FIELD c
          IF tm.c NOT MATCHES "[123]" THEN NEXT FIELD c END IF
       AFTER FIELD d
          IF tm.d NOT MATCHES "[123]" THEN NEXT FIELD d END IF
       AFTER FIELD e
          IF tm.a NOT MATCHES "[YN]" THEN NEXT FIELD e END IF
       AFTER FIELD m
          IF tm.m NOT MATCHES "[YN]" THEN NEXT FIELD m END IF
          IF tm.m = 'Y' THEN 
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,
                       g_bgjob,g_time,g_prtway,g_copies
          END IF
 
      ON ACTION CONTROLP                
         CASE                          
            WHEN INFIELD(book_no)          
               CALL cl_init_qry_var()                   
               LET g_qryparam.form = 'q_aaa3'           
               LET g_qryparam.default1 = tm.book_no         
               CALL cl_create_qry() RETURNING tm.book_no  
               DISPLAY BY NAME tm.book_no                
               NEXT FIELD b                       
         END CASE                        
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	                 #Command execution
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
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW gglg404_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	 #get exec cmd (fglgo xxxx)
             WHERE zz01='gglg404'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglg404','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		 #(at time fglgo xxxx p1 p2 p3)
			 " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",            
                         " '",tm.e CLIPPED,"'" 
         CALL cl_cmdat('gglg404',g_time,l_cmd)	 # Execute cmd at later time
      END IF
      CLOSE WINDOW gglg404_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglg404()
   ERROR ""
END WHILE
   CLOSE WINDOW gglg404_w
END FUNCTION
 
FUNCTION gglg404()
   DEFINE l_name	LIKE type_file.chr20,		 #External(Disk) file name
         #l_sql         LIKE type_file.chr1000,      #RDSQL STATEMENT   #NO.FUN-C10036 mark
          l_sql         STRING,                      #NO.FUN-C10036 add
          l_za05	LIKE type_file.chr50,                #標題內容
          l_abauser      LIKE aba_file.abauser,       #No.FUn-7C0066                                                                               
          l_zx02         LIKE zx_file.zx02,           #No.FUN-7C0066  
          l_i           LIKE type_file.num5,
          l_temp1       LIKE type_file.num5,
          l_temp2       LIKE type_file.num5,
          year          LIKE type_file.chr4,          #No.FUN-7C0066
          month         LIKE type_file.chr2,          #No.FUN-7C0066
          day           LIKE type_file.chr2,          #No.FUN-7C0066  
          sr            RECORD
                        aba01     LIKE aba_file.aba01,#傳票編號
                        aba02     LIKE aba_file.aba02,#傳票日期
                        aba10     LIKE aba_file.aba10,
                        aba21     LIKE aba_file.aba21,#附件分數
                        abb02     LIKE abb_file.abb02,#項次
                        abb04     LIKE abb_file.abb04,#摘要
                        abb06     LIKE abb_file.abb06,
                        abb24     LIKE abb_file.abb24,
                        abb25     LIKE abb_file.abb25,
                        abb07f    LIKE abb_file.abb07f,
                        aag01     LIKE aag_file.aag01,
                        aag02     LIKE aag_file.aag02,#科目名稱
                        aag13     LIKE aag_file.aag13,#FUN-6C0012
                        aag07     LIKE aag_file.aag07,
                        aag08     LIKE aag_file.aag08,
                        abb07     LIKE abb_file.abb07,#異動金額
                        azi07     LIKE azi_file.azi07,
                        l_pageno  LIKE type_file.num5,
                        level01   LIKE type_file.chr1000,
                        level02   LIKE type_file.chr1000,        
                        l_abb07_l LIKE type_file.num20_6,
                        l_abb07_r LIKE type_file.num20_6
                        END RECORD
     CALL cl_del_data(l_table)                                   #No.FUN-7C0066
     #No.FUN-B80096--mark--Begin---
     #CALL cl_used(g_prog,g_time,1) RETURNING g_time 
     #No.FUN-B80096--mark--End-----
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-7C0066
     SELECT aaf03 INTO g_company FROM aaf_file 
      WHERE aaf01 = g_bookno
        AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglg404'
     #使用預設帳別之幣別
     SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.book_no
     IF SQLCA.sqlcode THEN CALL cl_err3("sel","aaa_file",tm.book_no,"",SQLCA.sqlcode,"","",0) END IF
     SELECT azi02,azi04,azi05 INTO g_azi02,g_azi04,g_azi05 FROM azi_file                                                            
      WHERE azi01 = g_aaa03
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                         #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                         #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc CLIPPED," AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
     LET l_sql = "SELECT aba01,aba02,aba10,aba21,abb02,abb04,abb06,",
                 "       abb24,abb25,abb07f,aag01,aag02,aag13,aag07,aag08,abb07,",  #FUN-6C0012
                 "       azi07,0,'','',0,0", 
                 "   FROM aba_file,aag_file,aac_file,abb_file LEFT OUTER JOIN azi_file ON azi01 = abb24 ",
                 "  WHERE aba00 = abb00",
                 "    AND aba00 = '",tm.book_no,"'",
                 "    AND aba00 = aag00 ",  #No.FUN-740055
                 "    AND aba01 = abb01",
                 "    AND abb03 = aag01",
                 #"    AND aba01[1,3] = aac01",   #MOD-820168
                 "    AND aba01[1,",g_doc_len,"] = aac01",    #MOD-820168   
                 "    AND aac03 IN ('0','1','2')",
                 "    AND aag07 IN ('2','3')",
                 "    AND aba19 <> 'X' ",  #CHI-C80041
                 "    AND ",tm.wc CLIPPED
     IF tm.a = 'Y' THEN LET l_sql = l_sql CLIPPED," AND aac13 = 'Y'" END IF
     CASE WHEN tm.b = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
          WHEN tm.b = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
     END CASE
     CASE WHEN tm.c = '1' LET l_sql = l_sql CLIPPED," AND abaacti = 'Y' "
          WHEN tm.c = '2' LET l_sql = l_sql CLIPPED," AND abaacti = 'N' "
     END CASE
     CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abaprno = 0 "
          WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abaprno > 0 "
     END CASE
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql CLIPPED,"  AND aag09 = 'Y'   "
     END IF
     #No.MOD-860252---end---
     IF g_aaz.aaz82 = 'Y' THEN 
        LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb06,abb02"
     ELSE 
        LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb02"   
     END IF    
     PREPARE gglg404_prepare1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
        EXIT PROGRAM
     END IF
     DECLARE gglg404_curs1 CURSOR FOR gglg404_prepare1
#No.FUN-7C0066---Begin
#     CALL cl_outnam('gglg404') RETURNING l_name
#     IF g_len = 0 OR g_len IS NULL THEN 
#        IF tm.a = 'N' THEN 
#           LET g_len = 98
#        ELSE 
#           LET g_len = 106 
#        END IF
#     END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#     LET g_pageno = 0
#     START REPORT gglg404_rep TO l_name
#     CALL cl_prt_pos_len()
#No.FUN-7C0066---End
     FOREACH gglg404_curs1 INTO sr.*
       LET sr.abb25 = sr.abb25 * 100
       IF sr.abb06 = '1' THEN
          LET sr.l_abb07_l = sr.abb07
          LET sr.l_abb07_r = null
       ELSE 
          IF sr.abb06 = '2' THEN
             LET sr.l_abb07_l = null
             LET sr.l_abb07_r = sr.abb07
          END IF
       END IF
       CALL g404_get_level(sr.aba01,sr.abb02,sr.aag01,sr.aag02,sr.aag13)  #FUN-6C0012 
         RETURNING sr.level01,sr.level02
       SELECT aba01,COUNT(*) INTO sr.aba01,sr.l_pageno FROM aba_file,abb_file
         WHERE aba00 = tm.book_no
           AND aba01 = sr.aba01
           AND aba00 = abb00
           AND aba01 = abb01
         GROUP BY aba01 ORDER BY aba01
       LET l_temp1 = sr.l_pageno/5
       LET l_temp2 = sr.l_pageno MOD 5
       IF l_temp2 > 0
         THEN LET sr.l_pageno = l_temp1 + 1
         ELSE LET sr.l_pageno = l_temp1
       END IF
#No.FUN-7C0066---Begin
      IF g_company IS NULL OR g_company = ' ' THEN                                                                                  
         LET g_company = ' '                                                                                                        
      END IF    
     SELECT abauser INTO l_abauser FROM aba_file WHERE aba01=sr.aba01  AND aba00=tm.book_no  #No.FUN-740055                         
     SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=l_abauser                                                                      
     SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file                                                                          
      WHERE azi01 = sr.abb24 
      IF cl_null(sr.l_abb07_l) THEN                                                                                            
          LET sr.l_abb07_l = 0                                                                                                  
      END IF                                                                                                                   
      IF cl_null(sr.l_abb07_r) THEN                                                                                            
          LET sr.l_abb07_r = 0                                                                                                  
      END IF      
     UPDATE aba_file SET abaprno = abaprno + 1                                                                                      
      WHERE aba01 = sr.aba01                                                                                                        
        AND aba00 = tm.book_no                                                                                                      
     IF sqlca.sqlerrd[3]=0 THEN                                                                                                     
       CALL cl_err3("upd","aba_file",tm.book_no,sr.aba01,STATUS,"","upd abaprno",0)                                                 
     END IF  
     LET year = YEAR(sr.aba02)  CLIPPED
     LET month= MONTH(sr.aba02) CLIPPED
     LET day =  DAY(sr.aba02)   CLIPPED
     EXECUTE insert_prep USING sr.aba01,year,month,day,sr.aba21,sr.abb02,sr.abb04,
                               sr.abb07f,sr.abb25,l_zx02,sr.level01,sr.level02,sr.l_abb07_l,
                               sr.l_abb07_r,sr.l_pageno
                               
#       OUTPUT TO REPORT gglg404_rep(sr.*)
#No.FUN-7C0066---End
     END FOREACH
#No.FUN-7C0066---Begin
#     FINISH REPORT gglg404_rep
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'aba01,aba02,aba06,abauser')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
###GENGRE###      LET g_str=tm.wc ,";",tm.a,";",g_company,";",
###GENGRE###                      g_azi02,";",g_azi04,";",g_azi05
                      
                                                                          
###GENGRE###   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
###GENGRE###   CALL cl_prt_cs3('gglg404','gglg404',l_sql,g_str)
    CALL gglg404_grdata()    ###GENGRE###
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#No.FUN-7C0066---End
END FUNCTION
 
FUNCTION g404_get_level(p_aba01,p_abb02,p_aag01,p_aag02,p_aag13)  #FUN-6C0012
  DEFINE p_aba01      LIKE aba_file.aba01
  DEFINE p_abb02      LIKE abb_file.abb02
  DEFINE p_aag01      LIKE aag_file.aag01
  DEFINE p_aag02      LIKE aag_file.aag02
  DEFINE p_aag13      LIKE aag_file.aag13   #FUN-6C0012
  DEFINE l_level01    LIKE type_file.chr1000
  DEFINE l_level02    LIKE type_file.chr1000
  DEFINE l_desc       LIKE type_file.chr1000
  DEFINE l_aag01      LIKE aag_file.aag01
  DEFINE l_aag01_t    LIKE aag_file.aag01
  DEFINE l_aag02      LIKE aag_file.aag02
  DEFINE l_aag02_t    LIKE aag_file.aag02
  DEFINE l_aag13      LIKE aag_file.aag13  #FUN-6C0012
  DEFINE l_aag13_t    LIKE aag_file.aag13  #FUN-6C0012 
  DEFINE l_aag08      LIKE aag_file.aag08
  DEFINE l_aag08_t    LIKE aag_file.aag08
  DEFINE l_abb05      LIKE abb_file.abb05
  DEFINE l_abb08      LIKE abb_file.abb08
  DEFINE l_abb11      LIKE abb_file.abb11
  DEFINE l_abb12      LIKE abb_file.abb12
  DEFINE l_abb13      LIKE abb_file.abb13
  DEFINE l_abb14      LIKE abb_file.abb14
  
     SELECT aag08 INTO l_aag08 FROM aag_file WHERE aag01 = p_aag01
                                               AND aag00 = tm.book_no     #No.FUN-740055
     LET l_aag01 = p_aag01
     LET l_aag02 = p_aag02
     LET l_aag13 = p_aag13 #FUN-6C0012
     IF l_aag08 = p_aag01 THEN
        IF tm.e = 'Y' THEN 
           IF tm.f = 'N' THEN  #FUN-6C0012
              LET l_level01 = '(',l_aag01,')',l_aag02 CLIPPED
           ELSE    #FUN-6C0012
              LET l_level01 = '(',l_aag01,')',l_aag13 CLIPPED   #FUN-6C0012
           END IF  #FUN-6C0012
        ELSE
           IF tm.f = 'N' THEN   #FUN-6C0012
              LET l_level01 = l_aag02 CLIPPED
           ELSE                 #FUN-6C0012
              LET l_level01 = l_aag13 CLIPPED   #FUN-6C0012
           END IF               #FUN-6C0012
        END IF 
        LET l_level02 = ''    
     ELSE 
        WHILE l_aag08 != l_aag01 AND NOT cl_null(l_aag08)
          LET l_aag01_t = l_aag01
          LET l_aag02_t = l_aag02
          LET l_aag13_t = l_aag13   #FUN-6C0012
          LET l_aag08_t = l_aag08
          SELECT aag01,aag02,aag13,aag08 INTO l_aag01,l_aag02,l_aag13,l_aag08  #FUN-6C0012
            FROM aag_file 
           WHERE aag01 = l_aag08_t
             AND aag00 = tm.book_no    #No.FUN-740055
          IF tm.e = 'Y' THEN 
             IF cl_null(l_level02) THEN
                IF tm.f = 'N' THEN  #FUN-6C0012 
                   LET l_level02 = '(',l_aag01_t,')',l_aag02_t CLIPPED
                ELSE                #FUN-6C0012
                   LET l_level02 = '(',l_aag01_t,')',l_aag13_t CLIPPED  #FUN-6C0012
                END IF                      #FUN-6C0012
             ELSE   
                IF tm.f = 'N' THEN          #FUN-6C0012 
                   LET l_level02 = '(',l_aag01_t,')',l_aag02_t CLIPPED,'-',l_level02
                ELSE                        #FUN-6C0012                                   
                   LET l_level02 = '(',l_aag01_t,')',l_aag13_t CLIPPED,'-',l_level02  #FUN
                END IF                      #FUN-6C0012
             END IF   
          ELSE
             IF cl_null(l_level02) THEN
                IF tm.f = 'N' THEN          #FUN-6C0012
                   LET l_level02 = l_aag02_t CLIPPED
                ELSE                        #FUN-6C0012                                   
                   LET l_level02 = l_aag13_t CLIPPED  #FUN-6C0012                         
                END IF                      #FUN-6C0012
             ELSE
                IF tm.f = 'N' THEN          #FUN-6C0012
                   LET l_level02 = l_aag02_t CLIPPED,'-',l_level02
                ELSE                        #FUN-6C0012
                   LET l_level02 = l_aag13_t CLIPPED,'-',l_level02 #FUN-6C0012
                END IF                      #FUN-6C0012 
             END IF
          END IF 
        END WHILE  
        IF tm.e = 'Y' THEN
           IF tm.f = 'N' THEN          #FUN-6C0012
              LET l_level01 = '(',l_aag01,')',l_aag02 CLIPPED
           ELSE                        #FUN-6C0012                                        
              LET l_level01 = '(',l_aag01,')',l_aag13 CLIPPED  #FUN-6C0012                
           END IF                      #FUN-6C0012
        ELSE
           IF tm.f = 'N' THEN          #FUN-6C0012
              LET l_level01 = l_aag02 CLIPPED   
           ELSE                        #FUN-6C0012 
              LET l_level01 = l_aag13 CLIPPED  #FUN-6C0012 
           END IF                      #FUN-6C0012 
        END IF
     END IF
     LET l_desc = ''
     SELECT abb05,abb08,abb11,abb12,abb13,abb14 
       INTO l_abb05,l_abb08,l_abb11,l_abb12,l_abb13,l_abb14
       FROM abb_file 
      WHERE abb01 = p_aba01
        AND abb00 = tm.book_no
        AND abb02 = p_abb02
     IF NOT cl_null(l_abb05) THEN 
        LET l_desc = l_desc,'/',l_abb05 CLIPPED
     END IF            
     IF NOT cl_null(l_abb08) THEN 
        LET l_desc = l_desc,'/',l_abb08 CLIPPED
     END IF            
     IF NOT cl_null(l_abb11) THEN 
        LET l_desc = l_desc,'/',l_abb11 CLIPPED
     END IF            
     IF NOT cl_null(l_abb12) THEN 
        LET l_desc = l_desc,'/',l_abb12 CLIPPED
     END IF            
     IF NOT cl_null(l_abb13) THEN 
        LET l_desc = l_desc,'/',l_abb13 CLIPPED
     END IF            
     IF NOT cl_null(l_abb14) THEN 
        LET l_desc = l_desc,'/',l_abb14 CLIPPED
     END IF            
     IF NOT cl_null(l_desc) THEN
        IF NOT cl_null(l_level02) THEN
           LET l_level02 = l_level02,l_desc
        ELSE
           LET l_level01 = l_level01,l_desc
        END IF
     END IF
     RETURN l_level01,l_level02
END FUNCTION       
#No.FUN-7C0066---Begin
#REPORT gglg404_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,
#        l_abauser      LIKE aba_file.abauser,     
#        l_zx02         LIKE zx_file.zx02,        
#        l_aac03        LIKE aac_file.aac03,
#        l_aba10        LIKE aba_file.aba10,
#        l_abb07f       LIKE abb_file.abb07f,
#        l_abb07        LIKE abb_file.abb07,
#        l_abb07_l      LIKE abb_file.abb07,
#        l_abb07_r      LIKE abb_file.abb07,
#        l_aag02        LIKE aag_file.aag02,
#        l_aag13        LIKE aag_file.aag13,  #FUN-6C0012
#        l_level01      LIKE type_file.chr30,
#        l_level02      LIKE type_file.chr1000,
#        l_t1           LIKE aba_file.aba01,
#        i              LIKE type_file.num5,
#         sr            RECORD
#                       aba01     LIKE aba_file.aba01,#傳票編號
#                       aba02     LIKE aba_file.aba02,#傳票日期
#                       aba10     LIKE aba_file.aba10,
#                       aba21     LIKE aba_file.aba21,#附件分數
#                       abb02     LIKE abb_file.abb02,#項次
#                       abb04     LIKE abb_file.abb04,#摘要
#                       abb06     LIKE abb_file.abb06,
#                       abb24     LIKE abb_file.abb24,
#                       abb25     LIKE abb_file.abb25,
#                       abb07f    LIKE abb_file.abb07f,
#                       aag01     LIKE aag_file.aag01,
#                       aag02     LIKE aag_file.aag02,#科目名稱
#                       aag13     LIKE aag_file.aag13,#FUN-6C0012
#                       aag07     LIKE aag_file.aag07,
#                       aag08     LIKE aag_file.aag08,
#                       abb07     LIKE abb_file.abb07,#異動金額
#                       azi07     LIKE azi_file.azi07,
#                       l_pageno  LIKE type_file.num5,
#                       level01   LIKE type_file.chr1000,
#                       level02   LIKE type_file.chr1000,        
#                       l_abb07_l LIKE type_file.num20_6,
#                       l_abb07_r LIKE type_file.num20_6
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN 0 BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.aba01,sr.abb02
# FORMAT
#  PAGE HEADER
#     IF g_company IS NULL OR g_company = ' ' THEN
#        LET g_company = ' ' 
#     END IF
#     LET g_pageno = g_pageno + 1
#     IF tm.a = 'N' THEN
#        PRINT '~T28X0L11;'
#        PRINT COLUMN 43,g_x[1] CLIPPED,      
#              COLUMN 78,g_x[3] CLIPPED,g_pageno USING "####",    
#              g_x[12] CLIPPED,sr.l_pageno USING "####"         
#     ELSE
#        PRINT '~T28X0L11;'
#        PRINT COLUMN 51,g_x[1] CLIPPED,          
#              COLUMN 91,g_x[3] CLIPPED,g_pageno USING "####",     
#              g_x[12] CLIPPED,sr.l_pageno USING "####"       
#     END IF
#     IF tm.a = 'N' THEN
#        PRINT COLUMN 40,YEAR(sr.aba02)  CLIPPED,
#              COLUMN 45,MONTH(sr.aba02) CLIPPED,
#              COLUMN 48,DAY(sr.aba02)   CLIPPED,
#              COLUMN 78,g_x[10],g_azi02 
#     ELSE
#        PRINT COLUMN 43,YEAR(sr.aba02)  CLIPPED,
#              COLUMN 48,MONTH(sr.aba02) CLIPPED,
#              COLUMN 49,DAY(sr.aba02)   CLIPPED,
#              COLUMN 91,g_x[10],g_azi02 
#     END IF
#     IF tm.a = 'N' THEN
#        PRINT COLUMN 1,g_x[11] CLIPPED,g_company,      
#              COLUMN 83,sr.aba01 CLIPPED
#     ELSE
#        PRINT COLUMN 1,g_x[11] CLIPPED,g_company,         
#              COLUMN 100,sr.aba01 CLIPPED
#     END IF
#     PRINT
#     PRINT
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.aba01
#    LET l_abb07_l = 0
#    LET l_abb07_r = 0
#    SKIP TO TOP OF PAGE
#     
#  ON EVERY ROW
#    SELECT abauser INTO l_abauser FROM aba_file WHERE aba01=sr.aba01  AND aba00=tm.book_no  #No.FUN-740055
#    SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=l_abauser
#    SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file
#     WHERE azi01 = sr.abb24
#    IF LINENO <= 14 THEN
#  
#       IF tm.a = 'N' THEN
#          PRINT COLUMN 1,sr.abb04 CLIPPED,
#                COLUMN 29,sr.level01[1,19],
#                COLUMN 48,sr.level02[1,19],
#                COLUMN 67,cl_numfor(sr.l_abb07_l,14,g_azi04) CLIPPED,
#                COLUMN 83,cl_numfor(sr.l_abb07_r,14,g_azi04) CLIPPED;
#          IF cl_null(sr.l_abb07_l) THEN
#             LET sr.l_abb07_l = 0
#          END IF
#          IF cl_null(sr.l_abb07_r) THEN
#             LET sr.l_abb07_r = 0
#          END IF
#          LET l_abb07_l = l_abb07_l+sr.l_abb07_l
#          LET l_abb07_r = l_abb07_r+sr.l_abb07_r
#          IF LINENO = 9 THEN
#             PRINT COLUMN 100,sr.aba21 CLIPPED
#          ELSE 
#             PRINT ' '
#          END IF
#          PRINT ''; 
#          IF LINENO = 9 THEN
#             PRINT COLUMN 100,sr.aba21 CLIPPED
#          ELSE 
#             PRINT ' '
#          END IF
#       ELSE         
#          PRINT COLUMN 1,sr.abb04 CLIPPED,
#                COLUMN 28,sr.level01[1,13],
#                COLUMN 41,sr.level02[1,21],
#                COLUMN 62,cl_numfor(sr.abb07f,14,g_azi04) CLIPPED,
#                COLUMN 75,cl_numfor(sr.abb25,5,2) CLIPPED,'%',
#                COLUMN 85,cl_numfor(sr.l_abb07_l,14,g_azi04) CLIPPED,
#                COLUMN 100,cl_numfor(sr.l_abb07_r,14,g_azi04);
#          IF cl_null(sr.l_abb07_l) THEN
#             LET sr.l_abb07_l = 0
#          END IF
#          IF cl_null(sr.l_abb07_r) THEN
#             LET sr.l_abb07_r = 0
#          END IF
#          LET l_abb07_l = l_abb07_l+sr.l_abb07_l
#          LET l_abb07_r = l_abb07_r+sr.l_abb07_r
#          IF LINENO = 11 THEN
#             PRINT COLUMN 119,sr.aba21 CLIPPED
#          ELSE 
#             PRINT ' '
#          END IF
#          PRINT ' ';
#          IF LINENO = 11 THEN
#             PRINT COLUMN 119,sr.aba21 CLIPPED
#          ELSE 
#             PRINT ' '
#          END IF
#       END IF
#    ELSE
#       IF LINENO = 16 THEN
#          IF tm.a = 'N' THEN
#             PRINT COLUMN 67,cl_numfor(l_abb07_l,14,g_azi05);
#             PRINT COLUMN 83,cl_numfor(l_abb07_r,14,g_azi05)
#             PRINT COLUMN 54,l_zx02 CLIPPED
#             SKIP TO TOP OF PAGE
#             LET l_abb07_l = 0
#             LET l_abb07_r = 0
#No.TQC-710125 --begin
#             PRINT COLUMN 1,sr.abb04 CLIPPED,
#                   COLUMN 29,sr.level01[1,19],
#                   COLUMN 48,sr.level02[1,19],
#                   COLUMN 67,cl_numfor(sr.l_abb07_l,14,g_azi04) CLIPPED,
#                   COLUMN 83,cl_numfor(sr.l_abb07_r,14,g_azi04) CLIPPED
#             PRINT
#             IF cl_null(sr.l_abb07_l) THEN
#                LET sr.l_abb07_l = 0
#             END IF
#             IF cl_null(sr.l_abb07_r) THEN
#                LET sr.l_abb07_r = 0
#             END IF
#             LET l_abb07_l = l_abb07_l+sr.l_abb07_l
#             LET l_abb07_r = l_abb07_r+sr.l_abb07_r
#No.TQC-710125 --end
#          ELSE
#             PRINT COLUMN 85,cl_numfor(l_abb07_l,14,g_azi05);
#             PRINT COLUMN 100,cl_numfor(l_abb07_r,14,g_azi05)
#             PRINT
#             PRINT COLUMN 70,l_zx02 CLIPPED
#             SKIP TO TOP OF PAGE
#             LET l_abb07_l = 0
#             LET l_abb07_r = 0
#No.TQC-710125 --begin
#             PRINT COLUMN 1,sr.abb04 CLIPPED,
#                   COLUMN 28,sr.level01[1,13],
#                   COLUMN 41,sr.level02[1,21],
#                   COLUMN 62,cl_numfor(sr.abb07f,14,g_azi04) CLIPPED,
#                   COLUMN 75,cl_numfor(sr.abb25,5,2) CLIPPED,'%',
#                   COLUMN 85,cl_numfor(sr.l_abb07_l,14,g_azi04) CLIPPED,
#                   COLUMN 100,cl_numfor(sr.l_abb07_r,14,g_azi04)
#             PRINT
#             IF cl_null(sr.l_abb07_l) THEN
#                LET sr.l_abb07_l = 0
#             END IF
#             IF cl_null(sr.l_abb07_r) THEN
#                LET sr.l_abb07_r = 0
#             END IF
#             LET l_abb07_l = l_abb07_l+sr.l_abb07_l
#             LET l_abb07_r = l_abb07_r+sr.l_abb07_r
#No.TQC-710125 --end
#          END IF
#       END IF
#    END IF
#
#  AFTER GROUP OF sr.aba01
#    SELECT abauser INTO l_abauser FROM aba_file WHERE aba01=sr.aba01 AND aba00=tm.book_no     #No.FUN-740055
#    SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=l_abauser
#    SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file
#     WHERE azi01 = sr.abb24
 
#    IF tm.a = 'N' THEN
#      IF LINENO>=8 AND LINENO<16  THEN
#         WHILE LINENO<16
#            IF LINENO>=7 AND LINENO<=8 THEN
#               PRINT 
#               IF LINENO = 9 THEN
#                  PRINT COLUMN 100,sr.aba21 CLIPPED
#               END IF
#            ELSE
#               PRINT
#            END IF
#         END WHILE
#      END IF
#      IF LINENO = 16 THEN
#         PRINT COLUMN 67,cl_numfor(l_abb07_l,14,g_azi05);
#         PRINT COLUMN 83,cl_numfor(l_abb07_r,14,g_azi05)
#         PRINT COLUMN 54,l_zx02 CLIPPED
#         LET l_abb07_l = 0
#         LET l_abb07_r = 0
#      END IF
#    ELSE  
#      IF LINENO>=8 AND LINENO<16  THEN
#         WHILE LINENO<16
#            IF LINENO>=8 AND LINENO<=10 THEN
#               PRINT 
#               IF LINENO = 11 THEN
#                  PRINT COLUMN 119,sr.aba21 CLIPPED
#               END IF
#            ELSE
#               PRINT
#            END IF
#        END WHILE
#      END IF
#      IF LINENO = 16 THEN 
#         PRINT COLUMN 85,cl_numfor(l_abb07_l,14,g_azi05);
#         PRINT COLUMN 100,cl_numfor(l_abb07_r,14,g_azi05)
#         PRINT
#         PRINT COLUMN 70,l_zx02 CLIPPED
#         LET l_abb07_l = 0
#         LET l_abb07_r = 0
#      END IF
#    END IF
#    UPDATE aba_file SET abaprno = abaprno + 1
#     WHERE aba01 = sr.aba01
#       AND aba00 = tm.book_no
#    IF sqlca.sqlerrd[3]=0 THEN
#      CALL cl_err3("upd","aba_file",tm.book_no,sr.aba01,STATUS,"","upd abaprno",0)
#    END IF
#    LET g_pageno = 0  
 
#END REPORT
#No.FUN-7C0066---End
#Patch....NO.FUN-6A0029 <001> #

###GENGRE###START
FUNCTION gglg404_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gglg404")
        IF handler IS NOT NULL THEN
            START REPORT gglg404_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY aba01"         #FUN-B40092
          
            DECLARE gglg404_datacur1 CURSOR FROM l_sql
            FOREACH gglg404_datacur1 INTO sr1.*
                OUTPUT TO REPORT gglg404_rep(sr1.*)
            END FOREACH
            FINISH REPORT gglg404_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gglg404_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr1_o sr1_t          #FUN-C10036 add
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_p4     LIKE azi_file.azi02
    DEFINE l_day    STRING
    DEFINE l_month  STRING
    DEFINE l_total_l_abb07_l LIKE abb_file.abb07
    DEFINE l_total_l_abb07_r LIKE abb_file.abb07
    DEFINE l_abb07_l_sum LIKE abb_file.abb07
    DEFINE l_abb07_r_sum LIKE abb_file.abb07
    DEFINE l_sum   LIKE abb_file.abb07
    DEFINE l_sum1  LIKE abb_file.abb07
    DEFINE l_sum_l   LIKE abb_file.abb07
    DEFINE l_sum_r   LIKE abb_file.abb07
    DEFINE l_cnt     LIKE type_file.num5
    DEFINE l_end     LIKE type_file.num5
    DEFINE l_end1    LIKE type_file.num5
    DEFINE l_abb07_l_fmt              STRING
    DEFINE l_abb07_r_fmt              STRING
    DEFINE l_total_l_abb07_l_fmt      STRING
    DEFINE l_total_l_abb07_r_fmt      STRING 
    DEFINE l_abb07f_fmt               STRING 
    DEFINE l_show    LIKE type_file.chr1
    DEFINE l_show1   LIKE type_file.chr1
    
    ORDER EXTERNAL BY sr1.aba01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aba01
            LET l_lineno = 0
            #FUN-B40092------add-------str
            LET l_day = sr1.day USING '&&'
            LET l_month = sr1.month USING '&&'
            PRINTX l_day
            PRINTX l_month
            SELECT azi02 INTO l_p4 FROM azi_file
            WHERE azi01 = g_aaa03 
            PRINTX l_p4

            LET l_abb07_l_sum = 0
            LET l_abb07_r_sum = 0
            LET l_sum_l = 0
            LET l_sum_r = 0

            #FUN-B40092------add-------end
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_abb07f_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_abb07f_fmt
            LET l_abb07_l_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_abb07_l_fmt
            LET l_abb07_r_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_abb07_r_fmt


            LET l_abb07_l_sum = sr1.l_abb07_l + l_abb07_l_sum
            LET l_abb07_r_sum = sr1.l_abb07_r + l_abb07_r_sum
            IF l_lineno mod 5 = 0 THEN
               LET l_sum = l_abb07_l_sum
               LET l_sum1 = l_abb07_r_sum
               LET l_abb07_l_sum = 0
               LET l_abb07_r_sum = 0
               IF sr1_o.aba01 != sr1.aba01 THEN
                  LET l_show = 'Y'
            #FUN-C10036---add----str---
               ELSE
                  LET l_show = 'N'
               END IF
            #FUN-C10036---add----end---
            ELSE
               LET l_show = 'N'
            END IF
            PRINTX l_show 
 
            PRINTX l_sum
            PRINTX l_sum1
  
            SELECT COUNT(*) INTO l_cnt FROM abb_file WHERE abb01 = sr1.aba01
            LET l_end = l_cnt mod 5 
            IF l_end != 0 THEN 
               LET l_end1 = l_cnt - l_end + 1
               IF l_lineno = l_end1 OR l_lineno > l_end1 THEN 
                  LET l_sum_l = sr1.l_abb07_l + l_sum_l
                  LET l_sum_r = sr1.l_abb07_r + l_sum_r
                  LET l_show1 = 'Y'
               END IF
            ELSE
               LET l_show1 = 'N'  
            END IF 
            PRINTX l_sum_l   
            PRINTX l_sum_r   
            PRINTX l_show1

            LET sr1_o.* = sr1.*  #FUN-C10036 add

            IF tm.a = 'Y' THEN LET sr1.abb07f = ' ' AND sr1.abb25 = ' ' END IF  #FUN-D10032
            PRINTX sr1.*

        AFTER GROUP OF sr1.aba01
               LET l_total_l_abb07_l = GROUP SUM(sr1.l_abb07_l)
            PRINTX l_total_l_abb07_l

               LET l_total_l_abb07_r = GROUP SUM(sr1.l_abb07_r)
            PRINTX l_total_l_abb07_r
            LET l_total_l_abb07_l_fmt = cl_gr_numfmt('abb_file','abb07',g_azi05)
            PRINTX l_total_l_abb07_l_fmt
            LET l_total_l_abb07_r_fmt = cl_gr_numfmt('abb_file','abb07',g_azi05)
            PRINTX l_total_l_abb07_r_fmt 
        ON LAST ROW

END REPORT
###GENGRE###END

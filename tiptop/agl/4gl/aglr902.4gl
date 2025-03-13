# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr902.4gl
# Descriptions...: 傳票清單
# Input parameter:
# Return code....:
# Date & Author..: 92/03/04 By Jones
# Modify.........: By Danny     l_sql 改為 OUTER 作法、新增 l_sql 程式段
# Modify.........: By Melody    新增權限判斷
# Modify.........: No.FUN-510007 05/02/17 By Nicola 報表架構修改
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  將abb31~36加組字串至l_abb11(注意此變數應為c(60))，
#                  序號38放寬至60，報表寬度修改。
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0073 06/11/21 By xufeng  修改報表
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/11 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-760105 07/06/15 By hongmei 帳別列印重復
# Modify.........: No.TQC-770057 07/07/11 By Smapmin 修正FUN-6C0012
# Modify.........: No.MOD-820170 08/02/27 By Smapmin 加入aaz82的判斷
# Modify.........: No.FUN-810069 08/02/27 By lynn 項目預算取消abb15的管控
# Modify.........: No.FUN-830104 08/04/28 By dxfwo 報表改由CR輸出
# Modify.........: No.CHI-890003 09/02/24 By Sarah 傳遞aaz82至CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0202 10/11/29 By lixia選擇“額外摘要應列印”並沒有列印出額外摘要維護的資料
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30049 12/03/13 By minpp 增加部門名稱列印 
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                      # Print condition RECORD
                 wc  STRING,              #Where Condiction  #TQC-630166
                 b   LIKE aba_file.aba06,             #排列順序 #No.FUN-680098   VARCHAR(2)
                 c   LIKE aba_file.aba06,             #排列順序  #No.FUN-680098   VARCHAR(2)
                 d   LIKE type_file.chr1,             #過帳別 (1)未過帳(2)已過帳(3)全部  #No.FUN-680098   VARCHAR(1)
                 e   LIKE type_file.chr1,             #效別   (1)有效 (2)無效 (3)全部#No.FUN-680098  VARCHAR(1)
                 f   LIKE type_file.chr1,             #額外摘要是否列印#No.FUN-680098 VARCHAR(1)
                 h   LIKE type_file.chr1,             #列印額外名稱 #FUN-6C0012
                 m   LIKE type_file.chr1,             #是否輸入其它特殊列印條件#No.FUN-680098 VARCHAR(1)
             bookno  LIKE aba_file.aba01              #No.FUN-740020
              END RECORD,
#         g_bookno  LIKE aba_file.aba00 #帳別編號#No.FUN-740020
#           bookno  LIKE aba_file.aba01          #No.FUN-740020
    g_aaa03   LIKE aaa_file.aaa03
   #No.FUN-830104---Begin                                                                                                           
   DEFINE g_sql     STRING                                                                                                          
   DEFINE g_str     STRING                                                                                                          
   DEFINE l_table1  STRING                                                                                                          
   DEFINE l_table2  STRING                                                                                                          
   #No.FUN-830104---End
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
#  LET g_bookno = ARG_VAL(1)  #No.FUN-740020  
   LET tm.bookno = ARG_VAL(1)    #No.FUN-740020
   LET g_dbs  = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)            # Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET tm.wc  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)
   LET tm.c  = ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET tm.e  = ARG_VAL(13)
   LET tm.f  = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No.FUN-570264 ---end---
   LET tm.h  = ARG_VAL(18)  #FUN-6C0012
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-830104---Begin                                                                                                              
   LET g_sql = "aba05.aba_file.aba05,aba02.aba_file.aba02,",
               "aba01.aba_file.aba01,aba06.aba_file.aba06,",
               "abaacti.aba_file.abaacti,abapost.aba_file.abapost,",
               "abb02.abb_file.abb02,abb03.abb_file.abb03,",
               "abb04.abb_file.abb04,abb05.abb_file.abb05,",
               "abb06.abb_file.abb06,abb07.abb_file.abb07,",
               "abb15.abb_file.abb15,abb08.abb_file.abb08,",
               "aag13.aag_file.aag13,aag02.aag_file.aag02,",
               "abb11.abb_file.abb11,abb12.abb_file.abb12,",
               "abb13.abb_file.abb13,abb14.abb_file.abb14,",
               "abb31.abb_file.abb31,abb32.abb_file.abb32,",
               "abb33.abb_file.abb33,abb34.abb_file.abb34,",
               "abb35.abb_file.abb35,abb36.abb_file.abb36,",
               "abb37.abb_file.abb37,aba08.aba_file.aba08,",
               "aba09.aba_file.aba09,aag09.aag_file.aag09,",
               "abb00.abb_file.abb00,abb01.abb_file.abb01,",
               "gem02.gem_file.gem02"   #CHI-C300349
   LET l_table1 = cl_prt_temptable('aglr9021',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                       
                                                                                                                                    
   LET g_sql = "abc03.abc_file.abc03,abc04.abc_file.abc04,",
               "abb00.abb_file.abb00,abb01.abb_file.abb01,",
               "abb02.abb_file.abb02 " 
   LET l_table2 = cl_prt_temptable('aglr9022',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF                                                                                       
 #No.FUN-830104---End
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
#  IF g_bookno = ' ' OR g_bookno IS NULL THEN
#     LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
#  END IF
   IF tm.bookno = ' ' OR tm.bookno IS NULL THEN   #No.FUN-740020
      LET tm.bookno = g_aza.aza81                 #No.FUN-740020   
   END IF                                         #No.FUN-740020
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN      # If background job sw is off
      CALL aglr902_tm()                         # Input print condition
   ELSE
      CALL aglr902()                            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr902_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,          #No.FUN-680098 smallint
          l_cmd            LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(400)
          l_jmp_flag LIKE type_file.chr1                 #No.FUN-680098 VARCHAR(1)
 
#  CALL s_dsmark(g_bookno)    #No.FUN-740020
   CALL s_dsmark(tm.bookno)   #No.FUN-740020
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW aglr902_w AT p_row,p_col WITH FORM "agl/42f/aglr902"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
#  CALL s_shwact(3,2,g_bookno)    #No.FUN-740020
   CALL s_shwact(3,2,tm.bookno)   #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.b = '32'
   LET tm.d = '3'
   LET tm.e = '3'
   LET tm.f = 'N'
   LET tm.h = 'N'  #FUN-6C0012
   LET tm.m = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.b[1,1]
   LET tm2.s2   = tm.b[2,2]
   LET tm2.t1   = tm.c[1,1]
   LET tm2.t2   = tm.c[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON aba05,aba02,aba01,aba06
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aglr902_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
   DISPLAY BY NAME tm.bookno,tm.d,tm.e,tm.f,tm.h,tm.m   #FUN-6C0012   #No.FUN-740020 
   INPUT BY NAME tm.bookno,tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm.d,tm.e,tm.f,tm.h,tm.m  #FUN-6C0012    #No.FUN-740020
         WITHOUT DEFAULTS
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES "[123]" THEN NEXT FIELD d END IF
 
      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES "[123]" THEN NEXT FIELD e END IF
 
      AFTER FIELD f
         IF cl_null(tm.f) OR tm.f NOT MATCHES "[YN]" THEN NEXT FIELD f END IF
 
      AFTER FIELD m
         IF tm.m NOT MATCHES "[YN]" THEN NEXT FIELD m END IF
         IF tm.m = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         #No.FUN-740020  --Begin                                                                                                    
         ON ACTION CONTROLP                                                                                                         
          CASE                                                                                                                      
            WHEN INFIELD(bookno)                                                                                                    
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = 'q_aaa'                                                                                         
              LET g_qryparam.default1 =tm.bookno                                                                                      
              CALL cl_create_qry() RETURNING tm.bookno                                                                                 
              DISPLAY BY NAME tm.bookno                                                                                                
              NEXT FIELD bookno                                                                                                     
          END CASE                                                                                                                  
         #No.FUN-740020  --End
      ON ACTION CONTROLG CALL cl_cmdask()      # Command execution
     AFTER INPUT
       LET tm.b = tm2.s1[1,1],tm2.s2[1,1]
       LET tm.c = tm2.t1,tm2.t2
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
   END INPUT
#ELSE
#  DISPLAY BY NAME tm.b,tm.c,tm.d,tm.e,tm.f,tm.m
#  INPUT BY NAME tm.b,tm.c,tm.d,tm.e,tm.f,tm.m
#        WITHOUT DEFAULTS
#
#     AFTER FIELD d
#        IF cl_null(tm.d) OR tm.d NOT MATCHES "[123]" THEN NEXT FIELD d END IF
 
#     AFTER FIELD e
#        IF cl_null(tm.e) OR tm.e NOT MATCHES "[123]" THEN NEXT FIELD e END IF
 
#     AFTER FIELD f
#        IF cl_null(tm.f) OR tm.f NOT MATCHES "[YN]" THEN NEXT FIELD f END IF
 
#     AFTER FIELD m
#        IF tm.m NOT MATCHES "[YN]" THEN NEXT FIELD m END IF
#        IF tm.m = 'Y'
#           THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                               g_bgjob,g_time,g_prtway,g_copies)
#                     RETURNING g_pdate,g_towhom,g_rlang,
#                               g_bgjob,g_time,g_prtway,g_copies
#        END IF
#
################################################################################
# START genero shell script ADD
#  ON ACTION CONTROLR
#     CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
#     ON ACTION CONTROLG CALL cl_cmdask()      # Command execution
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
#
 #     ON ACTION help          #MOD-4C0121
 #        CALL cl_show_help()  #MOD-4C0121
 
#
#         ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
#  END INPUT
#END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr902_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr902'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr902','9031',1)  
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                       " '",g_bookno CLIPPED,"'",     #No.FUN-740020
                        " '",tm.bookno CLIPPED,"'",    #No.FUN-740020
                        " '",g_dbs    CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.h CLIPPED,"'",  #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('aglr902',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr902_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr902()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr902_w
END FUNCTION
 
FUNCTION aglr902()
   DEFINE l_name      LIKE type_file.chr20,        # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#         l_time      LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       STRING,                      # RDSQL STATEMENT  #TQC-630166     
          l_cnt       LIKE type_file.num5,         #No.FUN-830104                                                                   
          l_abc03     LIKE abc_file.abc03,         #No.FUN-830104                                                                   
          l_abc04     LIKE abc_file.abc04,         #No.FUN-830104 
          l_chr       LIKE type_file.chr1,         #No.FUN-680098   VARCHAR(1)
          l_order     ARRAY[5] OF  LIKE aba_file.aba01,   #排列順序 #No.FUN-680098    VARCHAR(16)
          l_i         LIKE type_file.num5,          #No.FUN-680098   smallint
          sr          RECORD
                         order1    LIKE aba_file.aba01,  #排列順序-1#No.FUN-680098    VARCHAR(20)
                         order2    LIKE aba_file.aba01,  #排列順序-2#No.FUN-680098    VARCHAR(20)
                         aba       RECORD LIKE aba_file.*,
                         abb       RECORD LIKE abb_file.*,
                         aag02     LIKE aag_file.aag02,
                         aag13     LIKE aag_file.aag13,  #FUN-6C0012
                         aag09     LIKE aag_file.aag09,
                         gem02     LIKE gem_file.gem02   #CHI-C30049
                      END RECORD
 
#No.FUN-830104---Begin                                                                                                              
     CALL cl_del_data(l_table1)                                                                                                     
     CALL cl_del_data(l_table2)                                                                                                     
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"    #CHI-C30049 ADD ?
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
       EXIT PROGRAM                                                                            
     END IF                                                                                                                         
                                                                                                                                    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,? )        "                                                                                      
     PREPARE insert_prep1 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
                                                                                                                                    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
 #No.FUN-830104---End
 
   SELECT aaf03 INTO g_company FROM aaf_file
#   WHERE aaf01 = g_bookno    #No.FUN-740020
    WHERE aaf01 = tm.bookno   #No.FUN-740020
      AND aaf02 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT '','', aba_file.*,abb_file.*,aag02,aag13,aag09 ", #FUN-6C0012
               "  FROM aba_file,abb_file,OUTER aag_file",
#              " WHERE aba00 = '",g_bookno,"'",      #No.FUN-740020
               " WHERE aba00 = '",tm.bookno,"'",     #No.FUN-740020 
               "   AND aba00 = abb00 ",
               "   AND aba01 = abb01",
               "   AND abb_file.abb03 = aag_file.aag01",
               "   AND abb00 = aag00",               #No.TQC-760105 
               "   ANd aba19 <> 'X' ",  #CHI-C80041 
               "   AND ",tm.wc CLIPPED
   CASE
      WHEN tm.d = '1'
         LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
      WHEN tm.d = '2'
         LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
      WHEN tm.d = '3'
         LET l_sql = l_sql CLIPPED," AND (abapost ='Y' OR abapost ='N') "
      OTHERWISE EXIT CASE
   END CASE
 
   CASE
      WHEN tm.e = '1'
         LET l_sql = l_sql CLIPPED," AND abaacti = 'Y' "
      WHEN tm.e = '2'
         LET l_sql = l_sql CLIPPED," AND abaacti = 'N' "
      WHEN tm.e = '3'
         LET l_sql = l_sql CLIPPED," AND (abaacti ='Y' OR abaacti ='N') "
      OTHERWISE EXIT CASE
   END CASE
 
   #-----MOD-820170---------
   IF g_aaz.aaz82 = 'Y' THEN
      LET l_sql = l_sql CLIPPED," ORDER BY  abb06"
   ELSE
      LET l_sql = l_sql CLIPPED," ORDER BY  abb02"
   END IF
   #-----END MOD-820170-----
 
   PREPARE aglr902_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr902_curs1 CURSOR FOR aglr902_prepare1
 
   #-->額外摘要
   LET l_sql = " SELECT abc03,abc04 FROM abc_file",
               "  WHERE abc00 = ? AND abc01=?  AND abc02= ? ",
               "  ORDER BY abc03 "
   PREPARE r902_pre2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE r902_c2  CURSOR FOR r902_pre2
 
#  CALL cl_outnam('aglr902') RETURNING l_name    #No.FUN-830104
#  START REPORT aglr902_rep TO l_name            #No.FUN-830104
 
   LET g_pageno = 0
 
   FOREACH aglr902_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.FUN-830104---Begin
#     FOR l_i = 1 TO 2
#        CASE WHEN tm.b[l_i,l_i] = '1'
#                  LET l_order[l_i] = sr.aba.aba05 USING 'YYYYMMDD'
#             WHEN tm.b[l_i,l_i] = '2'
#                  LET l_order[l_i] = sr.aba.aba02 USING 'YYYYMMDD'
#             WHEN tm.b[l_i,l_i] = '3' LET l_order[l_i] = sr.aba.aba01
#             WHEN tm.b[l_i,l_i] = '4' LET l_order[l_i] = sr.aba.aba06
#             OTHERWISE LET l_order[l_i] = '-'
#        END CASE
#     END FOR
#
#     LET sr.order1 = l_order[1]
#     LET sr.order2 = l_order[2]
#
#     OUTPUT TO REPORT aglr902_rep(sr.*)
      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.abb.abb05  #CHI-C30049 add 
      EXECUTE insert_prep USING
         sr.aba.aba05,  sr.aba.aba02,sr.aba.aba01,sr.aba.aba06,sr.aba.abaacti,
         sr.aba.abapost,sr.abb.abb02,sr.abb.abb03,sr.abb.abb04,sr.abb.abb05,
         sr.abb.abb06,  sr.abb.abb07,sr.abb.abb15,sr.abb.abb08,sr.aag13,
         sr.aag02,      sr.abb.abb11,sr.abb.abb12,sr.abb.abb13,sr.abb.abb14,
         sr.abb.abb31,  sr.abb.abb32,sr.abb.abb33,sr.abb.abb34,sr.abb.abb35,
         sr.abb.abb36,  sr.abb.abb37,sr.aba.aba08,sr.aba.aba09,sr.aag09,
         sr.abb.abb00,  sr.abb.abb01,sr.gem02    #CHI-C30049 add gem02                                
                                                                                                                                    
      IF tm.f = 'Y' THEN                                                                                                   
         LET l_cnt = 0                                                                                                           
        #FOREACH r902_c2 USING sr.abb.abb00,sr.abb.abb01,sr.abb.abb02 #TQC-AB0202
         FOREACH r902_c2 USING sr.abb.abb00,sr.abb.abb01,'0'          #TQC-AB0202
                          INTO l_abc03,l_abc04                                                                                   
            IF SQLCA.sqlcode THEN                                                                                                
               CALL cl_err('r902_c2',SQLCA.sqlcode,0)                                                                            
               EXIT FOREACH                                                                                                      
            END IF                                                                                                               
            IF cl_null(l_abc04) THEN                                                                                             
               CONTINUE FOREACH                                                                                                  
            END IF                                                                                                               
            LET l_cnt = l_cnt + 1                                                                                                
            EXECUTE insert_prep1 USING
               l_abc03,l_abc04,sr.abb.abb00,sr.abb.abb01,sr.abb.abb02                                
            IF l_cnt = 2 THEN                                                                                                    
               LET l_cnt = 0
            END IF                                                                                                               
         END FOREACH                                                                                                             
      END IF
 
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                      
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED                                                           
                                                                                                                               
   LET g_str = ''                                                                                                              
   #是否列印選擇條件                                                                                                           
   IF g_zz05 = 'Y' THEN                                                                                                        
      CALL cl_wcchp(tm.wc,'aba05,aba02,aba01,aba06')                                                                           
           RETURNING g_str                                                                                                     
   END IF               
#                p1         p2              p3        p4       p5
   LET g_str = g_str,";",tm.b[1,1],";",tm.b[2,2],";",tm.h,";",tm.f,";",
#                p6          p7             p8          p9          p10
               g_azi04,";",tm.c[1,1],";",tm.c[2,2],";",tm.h,";",g_aaz.aaz82   #CHI-890003 add aaz82
   CALL cl_prt_cs3('aglr902','aglr902',g_sql,g_str)
#  FINISH REPORT aglr902_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
REPORT aglr902_rep(sr)
   DEFINE l_last_sw           LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)
          l_cnt               LIKE type_file.num5,        #No.FUN-680098    SMALLINT
          l_abc03             LIKE abc_file.abc03,
          l_abc04             LIKE abc_file.abc04,
          l_dr_tot,l_cr_tot   LIKE abb_file.abb07,
          l_dr_sum,l_cr_sum   LIKE abb_file.abb07,
          sr                  RECORD
                                 order1    LIKE aba_file.aba01,  #排列順序-1#No.FUN-680098   VARCHAR(20) 
                                 order2    LIKE aba_file.aba01,  #排列順序-2#No.FUN-680098   VARCHAR(20)
                                 aba       RECORD LIKE aba_file.*,
                                 abb       RECORD LIKE abb_file.*,
                                 aag02     LIKE aag_file.aag02,
                                 aag13     LIKE aag_file.aag13, #FUN-6C0012
                                 aag09     LIKE aag_file.aag09
                              END RECORD
  #DEFINE l_abb11             VARCHAR(30)  #FUN-5C0015
   DEFINE l_abb11             LIKE type_file.chr1000 #FUN-5C0015   #No.FUN-680098    VARCHAR(60)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   #ORDER BY sr.order1,sr.order2,sr.aba.aba01,sr.abb.abb02    #MOD-820170
   ORDER BY sr.order1,sr.order2,sr.aba.aba01    #MOD-820170
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<','/pageno'
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash     #No.TQC-6B0073
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]         #FUN-810069
               g_x[39],g_x[40],g_x[41],g_x[42]                  #FUN-810069
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.c[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.c[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.aba.aba01
         PRINT COLUMN g_c[31],sr.aba.aba05,
               COLUMN g_c[32],sr.aba.aba02,
               COLUMN g_c[33],sr.aba.aba01,
               COLUMN g_c[34],sr.aba.aba06,
               COLUMN g_c[35],sr.aba.abaacti,
               COLUMN g_c[36],sr.aba.abapost;
 
      ON EVERY ROW
         PRINT COLUMN g_c[37],sr.abb.abb02 USING "###&",
               COLUMN g_c[38],sr.abb.abb03,
               COLUMN g_c[39],sr.abb.abb05,
               COLUMN g_c[40],sr.abb.abb06,
               COLUMN g_c[41],cl_numfor(sr.abb.abb07,41,g_azi04),
#               COLUMN g_c[42],sr.abb.abb15,                #FUN-810069
#               COLUMN g_c[43],sr.abb.abb08                 #FUN-810069
               COLUMN g_c[42],sr.abb.abb08                 #FUN-810069
         #-----TQC-770057---------
         {
         IF NOT cl_null(sr.aag02) THEN
            #FUN-6C0012.....begin
            IF tm.h = 'Y' THEN
               PRINT COLUMN g_c[38],sr.aag13
            ELSE
            #FUN-6C0012.....end
               PRINT COLUMN g_c[38],sr.aag02
            END IF   #FUN-6C0012
         END IF
         }
        IF tm.h = 'Y' THEN
           PRINT COLUMN g_c[38],sr.aag13 
        ELSE
           PRINT COLUMN g_c[38],sr.aag02
        END IF
         #-----END TQC-770057-----
 
         IF NOT cl_null(sr.abb.abb11) OR NOT cl_null(sr.abb.abb12) OR
            NOT cl_null(sr.abb.abb13) OR NOT cl_null(sr.abb.abb14) THEN
            LET l_abb11 = sr.abb.abb11,' ',sr.abb.abb12,' ',sr.abb.abb13,' ',sr.abb.abb14
           #->FUN-5C0015----------------------------------------------------(S)
            LET l_abb11 = l_abb11 CLIPPED,' ',sr.abb.abb31,' ',sr.abb.abb32,' ',
                          sr.abb.abb33,' ',sr.abb.abb34,' ',sr.abb.abb35,' ',
                          sr.abb.abb36,' ',sr.abb.abb37
           #->FUN-5C0015----------------------------------------------------(E)
            PRINT COLUMN g_c[38],l_abb11 CLIPPED
         END IF
 
         IF NOT cl_null(sr.abb.abb04) THEN
            PRINT COLUMN g_c[38],sr.abb.abb04
         END IF
 
         IF tm.f = 'Y' THEN
            LET l_cnt = 0
            FOREACH r902_c2 USING sr.abb.abb00,sr.abb.abb01,sr.abb.abb02
                             INTO l_abc03,l_abc04
               IF SQLCA.sqlcode THEN
                  CALL cl_err('r902_c2',SQLCA.sqlcode,0)
                  EXIT FOREACH
               END IF
               IF cl_null(l_abc04) THEN
                  CONTINUE FOREACH
               END IF
               LET l_cnt = l_cnt + 1
               IF l_cnt = 2 THEN
                  PRINT COLUMN g_c[38],l_abc04
                  LET l_cnt = 0
               ELSE
                  PRINT COLUMN g_c[38],l_abc04;
               END IF
            END FOREACH
            IF l_cnt = 1 THEN
               PRINT ' '
            END IF
         END IF
 
      AFTER GROUP OF sr.aba.aba01
#        LET g_pageno = 0   #FUN-6C0012
         PRINT COLUMN g_c[36],g_x[10] CLIPPED,
               COLUMN g_c[38],cl_numfor(sr.aba.aba08,41,g_azi04),
               COLUMN g_c[39],g_x[11] CLIPPED,
               COLUMN g_c[41],cl_numfor(sr.aba.aba09,41,g_azi04)
         PRINT ' '
 
      AFTER GROUP OF sr.order1
         IF tm.c[1,1] = 'Y' THEN
            LET l_dr_tot = GROUP SUM(sr.abb.abb07) WHERE sr.abb.abb06 = '1'
                                                     AND sr.aag09 = 'Y'
            LET l_cr_tot = GROUP SUM(sr.abb.abb07) WHERE sr.abb.abb06 = '2'
                                                     AND sr.aag09 = 'Y'
            IF cl_null(l_dr_tot) THEN LET l_dr_tot = 0 END IF
            IF cl_null(l_cr_tot) THEN LET l_cr_tot = 0 END IF
            PRINT COLUMN g_c[36],g_x[10] CLIPPED,
                  COLUMN g_c[38],cl_numfor(l_dr_tot,41,g_azi04),
                  COLUMN g_c[39],g_x[11] CLIPPED,
                  COLUMN g_c[41],cl_numfor(l_cr_tot,41,g_azi04)
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.c[2,2] = 'Y' THEN
            LET l_dr_tot = GROUP SUM(sr.abb.abb07) WHERE sr.abb.abb06 = '1'
                                                     AND sr.aag09 = 'Y'
            LET l_cr_tot = GROUP SUM(sr.abb.abb07) WHERE sr.abb.abb06 = '2'
                                                     AND sr.aag09 = 'Y'
            IF cl_null(l_dr_tot) THEN LET l_dr_tot = 0 END IF
            IF cl_null(l_cr_tot) THEN LET l_cr_tot = 0 END IF
            PRINT COLUMN g_c[36],g_x[10] CLIPPED,
                  COLUMN g_c[38],cl_numfor(l_dr_tot,41,g_azi04),
                  COLUMN g_c[39],g_x[11] CLIPPED,
                  COLUMN g_c[41],cl_numfor(l_cr_tot,41,g_azi04)
         END IF
 
      ON LAST ROW
         LET l_dr_sum = SUM(sr.abb.abb07) WHERE sr.abb.abb06 = '1'
                                            AND sr.aag09 = 'Y'
         LET l_cr_sum = SUM(sr.abb.abb07) WHERE sr.abb.abb06 = '2'
                                            AND sr.aag09 = 'Y'
         IF cl_null(l_dr_sum) THEN LET l_dr_sum = 0 END IF
         IF cl_null(l_cr_sum) THEN LET l_cr_sum = 0 END IF
         PRINT COLUMN g_c[36],g_x[12] CLIPPED,
               COLUMN g_c[38],cl_numfor(l_dr_sum,41,g_azi04),
               COLUMN g_c[39],g_x[13] CLIPPED,
               COLUMN g_c[41],cl_numfor(l_cr_sum,41,g_azi04)
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'aba05,aba02,aba01') RETURNING tm.wc
            PRINT g_dash[1,g_len]
        #TQC-630166
        #    IF tm.wc[001,070] > ' ' THEN                  # for 80
        #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
        #             COLUMN g_c[32],tm.wc[001,070] CLIPPED
        #    END IF
        #    IF tm.wc[071,140] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
        #    END IF
        #    IF tm.wc[141,210] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
        #    END IF
        #    IF tm.wc[211,280] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
        #    END IF
         CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
#Patch....NO.TQC-610035 <001> #

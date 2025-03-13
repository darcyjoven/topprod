# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr007.4gl
# Descriptions...: 借還料明細表
# Date & Author..: 06/07/26 By Sarah
# Modify.........: No.FUN-680007 06/08/01 By Sarah 當還料是aimt308->單價抓imq11
#                                                  當還料是aimt309->單價抓imp09
# Modify.........: No.FUN-680122 06/08/31 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-750112 07/06/22 By Jackho CR報表修改
# Modify.........: No.MOD-940042 09/05/25 By Pengu 原價償還與員數償還在抓取金額時相反
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40130 10/04/27 By Carrier 少了一个引号
# Modify.........: No:MOD-A60048 10/06/07 By Sarah l_sql只抓已過帳資料
# Modify.........: No:MOD-A90019 10/09/06 By Summer 排除不計成本倉的資料
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/16 By fengrui  調整時間函數問題
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
            yy          LIKE type_file.num5,           #No.FUN-680122SMALLINT,
            mm          LIKE type_file.num5,           #No.FUN-680122SMALLINT,
            more        LIKE type_file.chr1            #No.FUN-680122CHAR(1)          # Input more condition(Y/N)
           END RECORD 
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE m_len            LIKE type_file.num5            #No.FUN-680122SMALLINT
DEFINE l_table    STRING                       ### FUN-750112 ###
DEFINE g_str      STRING                       ### FUN-750112 ###
DEFINE g_sql      STRING                       ### FUN-750112 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time        #FUN-B80056   ADD #FUN-BB0047 mark
 
   LET g_pdate    = ARG_VAL(1)        
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.yy      = ARG_VAL(7)       
   LET tm.mm      = ARG_VAL(8)        
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   
#--------------------No.FUN-750112--begin----CR(1)----------------#
    LET g_sql = "chr1.type_file.chr1,",
                "imo01.imo_file.imo01,",   
                "imp02.imp_file.imp02,",  
                "imo02.imo_file.imo02,",  
                "imo03.imo_file.imo03,",   
                "imp03.imp_file.imp03,",  
                "ima02.ima_file.ima02,",  
                "ima021.ima_file.ima021,",  
                "ima25.ima_file.ima25,",  
                "imp04.imp_file.imp04,",  
                "imp09.imp_file.imp08,",  
                "imp10.imp_file.imp10,",
                "imr00.imr_file.imr00,",  
                "imr01.imr_file.imr01,",
                "imq02.imq_file.imq02,", 
                "imr09.imr_file.imr09,",  
                "imq03.imq_file.imq03,",  
                "imq04.imq_file.imq04,", 
                "imq05.imq_file.imq05,", 
                "apb27.ima_file.ima02,",            #sr1.ima02
                "bmq021.ima_file.ima021,",          #sr1.ima021
                "chr4.ima_file.ima25,",             #sr1.ima25
                "imq07.imq_file.imq07,",  
                "imq11.imq_file.imq11,", 
                "imq12.imq_file.imq12,",            #sr1.amt 
                "chr1000.type_file.chr1000"         #l_msg
 
    LET l_table = cl_prt_temptable('axcr007',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?, ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#--------------------No.FUN-750112--end------CR (1) ------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  # If background job sw is off
      THEN CALL axcr007_tm(0,0)          # Input print condition
   ELSE
      CALL axcr007()                # Read data and create out-file
   END IF
   #TQC-610051-end
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
END MAIN
 
FUNCTION axcr007_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 38
   ELSE 
      LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr007_w AT p_row,p_col WITH FORM "axc/42f/axcr007"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy   = YEAR(g_today)
   LET tm.mm   = MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS
         ON ACTION locale
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
 
         AFTER FIELD yy
            IF tm.yy IS NULL THEN NEXT FIELD yy END IF
 
         AFTER FIELD mm
            IF tm.mm IS NULL THEN NEXT FIELD mm END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN 
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
 
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
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axcr007_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='axcr007'   #get exec cmd (fglgo xxxx)
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axcr007','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.yy CLIPPED,"'",
                            " '",tm.mm CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axcr007',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr007_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axcr007()
      ERROR ""
   END WHILE
   CLOSE WINDOW axcr007_w
END FUNCTION
 
FUNCTION axcr007()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20),       # External(Disk) file name
          l_name1   LIKE type_file.chr20,          #No.FUN-680122CHAR(20),       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     STRING,
          l_cmd     LIKE type_file.chr1000,       #No.FUN-680122CHAR(400),
          sr        RECORD
                     imo01     LIKE imo_file.imo01,   #借料單號
                     imp02     LIKE imp_file.imp02,   #項次
                     imo02     LIKE imo_file.imo02,   #日期
                     imo03     LIKE imo_file.imo03,   #廠商
                     imp03     LIKE imp_file.imp03,   #料號
                     ima02     LIKE ima_file.ima02,   #品名
                     ima021    LIKE ima_file.ima021,  #規格
                     ima25     LIKE ima_file.ima25,   #單位
                     imp04     LIKE imp_file.imp04,   #數量
                     imp09     LIKE imp_file.imp08,   #單價
                     imp10     LIKE imp_file.imp10    #金額
                    END RECORD,
          sr1       RECORD
                     imr00     LIKE imr_file.imr00,   #償還方式   #FUN-680007 add
                     imr01     LIKE imr_file.imr01,   #還料單號
                     imq02     LIKE imq_file.imq02,   #項次
                     imr09     LIKE imr_file.imr09,   #扣帳日期
                     imq03     LIKE imq_file.imq03,   #借料單號
                     imq04     LIKE imq_file.imq04,   #項次
                     imq05     LIKE imq_file.imq05,   #還料料號
                     ima02     LIKE ima_file.ima02,   #品名
                     ima021    LIKE ima_file.ima021,  #規格
                     ima25     LIKE ima_file.ima25,   #單位
                     imq07     LIKE imq_file.imq07,   #還料數量
                     imq11     LIKE imq_file.imq11,   #單價
                     amt       LIKE imq_file.imq12    #金額
                    END RECORD
   DEFINE l_str      STRING,                   #FUN-750112
          l_msg      LIKE type_file.chr1000,   #FUN-750112
          l_mm       LIKE type_file.chr2,      #FUN-750112
          l_bdate    LIKE type_file.dat,       #區間的起始日期 	#MOD-A60048 add
          l_edate    LIKE type_file.dat        #區間的截止日期 	#MOD-A60048 add
          
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   #No.FUN-BB0047--mark--End-----
#--------------------No.FUN-750112--begin----CR(2)----------------#
   CALL cl_del_data(l_table)   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#   LET m_len = 199
#   LET g_len = 221   #210   #FUN-680007 modify   
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#--------------------No.FUN-750112--end------CR(2)----------------#

   CALL s_ymtodate(tm.yy,tm.mm,tm.yy,tm.mm) RETURNING l_bdate,l_edate   #MOD-A60048 add

   #借料明細
   LET l_sql = "SELECT imo01,imp02,imo02,imo03,imp03,",
               "       ima02,ima021,ima25,imp04,imp09,imp10",
               "  FROM imo_file,imp_file,ima_file",
               " WHERE imo01=imp01",
               "   AND imp03=ima01",
              #"   AND YEAR(imo02)=",tm.yy,                              #MOD-A60048 mark
              #"   AND MONTH(imo02)=",tm.mm,                             #MOD-A60048 mark
               "   AND imo02 BETWEEN '",l_bdate,"' AND '",l_edate,"'",   #MOD-A60048
               "   AND imopost='Y'",   #MOD-A60048 add
               "   AND imp11 NOT IN (SELECT jce02 FROM jce_file)", #MOD-A90019 add
               " ORDER BY imo01,imp02"
   PREPARE r007_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   DECLARE r007_cs1 CURSOR FOR r007_p1
 
   #還料明細
  #start FUN-680007 modify
   #當還料是原數償還--aimt308(imr00='1')->單價抓imq11
   #當還料是原價償還--aimt309(imr00='2')->單價抓imp09
  #LET l_sql = "SELECT imr01,imq02,imr09,imq03,imq04,imq05,",
  #            "       ima02,ima021,ima25,imq07,imq11,imq07*imq11",
  #            "  FROM imr_file,imq_file,ima_file",
  #            " WHERE imr01=imq01",
  #            "   AND imq05=ima01",
  #            "   AND YEAR(imr09)=",tm.yy,
  #            "   AND MONTH(imr09)=",tm.mm,
  #            " ORDER BY imr01,imq02"
   LET l_sql = "SELECT imr00,imr01,imq02,imr09,imq03,imq04,imq05,",
               "       ima02,ima021,ima25,imq07,imq11,imq07*imq11",
               "  FROM imr_file,imq_file,ima_file",
               " WHERE imr01=imq01",
               "   AND imq05=ima01",
              #"   AND YEAR(imr09)=",tm.yy,                              #MOD-A60048 mark
              #"   AND MONTH(imr09)=",tm.mm,                             #MOD-A60048 mark
               "   AND imr09 BETWEEN '",l_bdate,"' AND '",l_edate,"'",   #MOD-A60048
               "   AND imrpost='Y'",   #MOD-A60048 add
              #"   AND imr00='1'",  #No.MOD-940042 mark
              #"   AND imr00='2",   #No.MOD-940042 add  #No.TQC-A40130
               "   AND imr00='2'",   #No.MOD-940042 add  #No.TQC-A40130
               "   AND imq08 NOT IN (SELECT jce02 FROM jce_file)", #MOD-A90019 add
               " UNION ",
               "SELECT imr00,imr01,imq02,imr09,imq03,imq04,imq05,",
               "       ima02,ima021,ima25,imq07,imp09,imq07*imp09",
               "  FROM imr_file,imq_file,ima_file,imp_file",
               " WHERE imr01=imq01",
               "   AND imq05=ima01",
               "   AND imq03=imp01",
               "   AND imq04=imp02",
              #"   AND YEAR(imr09)=",tm.yy,                              #MOD-A60048 mark
              #"   AND MONTH(imr09)=",tm.mm,                             #MOD-A60048 mark
               "   AND imr09 BETWEEN '",l_bdate,"' AND '",l_edate,"'",   #MOD-A60048
               "   AND imrpost='Y'",   #MOD-A60048 add
              #"   AND imr00='2'",   #No.MOD-940042 mark
               "   AND imr00='1'",   #No.MOD-940042 add
               "   AND imq08 NOT IN (SELECT jce02 FROM jce_file)", #MOD-A90019 add
               " ORDER BY imr00,imr01,imq02"
  #end FUN-680007 modify
   PREPARE r007_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   DECLARE r007_cs2 CURSOR FOR r007_p2
 
#   CALL cl_outnam('axcr007') RETURNING l_name    #FUN-750112
#   LET l_name1=l_name                            #FUN-750112
#   LET l_name1[11,11]='x'                        #FUN-750112
 
#   START REPORT axcr007_rep TO l_name            #FUN-750112  
#   START REPORT axcr007_rep1 TO l_name1          #FUN-750112
 
   FOREACH r007_cs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(sr.imp04) THEN LET sr.imp04=0 END IF
      IF cl_null(sr.imp09) THEN LET sr.imp09=0 END IF
      IF cl_null(sr.imp10) THEN LET sr.imp10=0 END IF
#--------------------No.FUN-750112--begin----CR(3)----------------#
      EXECUTE insert_prep USING 
               '0',sr.imo01,sr.imp02,sr.imo02,sr.imo03,sr.imp03,
               sr.ima02,sr.ima021,sr.ima25,sr.imp04,sr.imp09,sr.imp10,
               '','','','','','','','','','','','','',''
#      OUTPUT TO REPORT axcr007_rep(sr.*)
#--------------------No.FUN-750112--end------CR(3)----------------#
   END FOREACH
 
   LET g_len = 221   #210   #FUN-680007 modify
   FOREACH r007_cs2 INTO sr1.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(sr1.imq07) THEN LET sr1.imq07=0 END IF
      IF cl_null(sr1.imq11) THEN LET sr1.imq11=0 END IF
      IF cl_null(sr1.amt) THEN LET sr1.amt=0 END IF
#--------------------No.FUN-750112--begin----CR(3)----------------#
      CASE sr1.imr00
         WHEN '1'   #原數償還
            CALL cl_getmsg('sub-058',g_lang) RETURNING l_str
         WHEN '2'   #原價償還
            CALL cl_getmsg('sub-059',g_lang) RETURNING l_str
      END CASE
      LET l_msg = sr1.imr00,1 SPACES,l_str 
      EXECUTE insert_prep USING 
               '1','','','','','','','','','','','',
               sr1.imr00,sr1.imr01,sr1.imq02,sr1.imr09,
               sr1.imq03,sr1.imq04,sr1.imq05,sr1.ima02,
               sr1.ima021,sr1.ima25,sr1.imq07,sr1.imq11,
               sr1.amt,l_msg
#      OUTPUT TO REPORT axcr007_rep1(sr1.*)
#--------------------No.FUN-750112--end------CR(3)----------------#
   END FOREACH
#--------------------No.FUN-750112--begin----CR(4)----------------#
   IF tm.mm<'10' THEN
      LET l_mm='0',tm.mm
   ELSE
      LET l_mm=tm.mm
   END IF
   LET g_str=tm.yy,";",l_mm,";",g_ccz.ccz27,";",
             #g_azi03,";",g_azi04,";",g_azi05 #CHI-C30012 mark
             g_ccz.ccz26,";",g_ccz.ccz26,";",g_ccz.ccz26  #CHI-C30012           
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('axcr007','axcr007',l_sql,g_str)
#   FINISH REPORT axcr007_rep
#   FINISH REPORT axcr007_rep1
#   LET l_cmd = "chmod 777 ", l_name1
#   RUN l_cmd
#   LET l_sql='cat ',l_name1,'>> ',l_name
#   RUN l_sql
#   LET g_len=0 #CHI-690007 #拿掉此行會出現報表寬度錯誤
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
#--------------------No.FUN-750112--end------CR(4)----------------#
END FUNCTION
 
#--------------------No.FUN-750112--begin--------------------#
#REPORT axcr007_rep(sr)
#  DEFINE l_last_sw  LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1),
#         l_j        LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#         sr         RECORD
#                     imo01     LIKE imo_file.imo01,   #借料單號
#                     imp02     LIKE imp_file.imp02,   #項次
#                     imo02     LIKE imo_file.imo02,   #日期
#                     imo03     LIKE imo_file.imo03,   #廠商
#                     imp03     LIKE imp_file.imp03,   #料號
#                     ima02     LIKE ima_file.ima02,   #品名
#                     ima021    LIKE ima_file.ima021,  #規格
#                     ima25     LIKE ima_file.ima25,   #單位
#                     imp04     LIKE imp_file.imp04,   #數量
#                     imp09     LIKE imp_file.imp08,   #單價
#                     imp10     LIKE imp_file.imp10    #金額
#                    END RECORD 
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER EXTERNAL BY sr.imo01,sr.imp02
#
#  FORMAT
#    PAGE HEADER
#      PRINT (m_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (m_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (m_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME;
#      PRINT COLUMN m_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      LET l_j = FGL_WIDTH(g_x[9])+6+FGL_WIDTH(g_x[10])+2
#      PRINT (m_len-l_j)/2 SPACES, 
#            g_x[9] CLIPPED,tm.yy USING '&&&&', 2 SPACES,
#            g_x[10] CLIPPED,tm.mm USING '&&'
#      PRINT g_dash[1,m_len]
#      PRINT COLUMN   1,g_x[11] CLIPPED    #借料明細
#      PRINT
#      PRINT COLUMN   1,g_x[21] CLIPPED,   #借料單號
#            COLUMN  18,g_x[22] CLIPPED,   #項次
#            COLUMN  23,g_x[23] CLIPPED,   #日期
#            COLUMN  32,g_x[24] CLIPPED,   #廠商
#            COLUMN  43,g_x[25] CLIPPED,   #料號
#            COLUMN  74,g_x[26] CLIPPED,   #品名
#            COLUMN 105,g_x[27] CLIPPED,   #規格
#            COLUMN 136,g_x[28] CLIPPED,   #單位
#            COLUMN 141,g_x[29] CLIPPED,   #借料數量
#            COLUMN 161,g_x[30] CLIPPED,   #單價
#            COLUMN 181,g_x[31] CLIPPED    #金額
#      PRINT "---------------- ---- -------- ---------- ",
#            "------------------------------ ------------------------------ ------------------------------ ",
#            "---- ------------------- ------------------- -------------------"
#      LET l_last_sw = 'n'
#
#    ON EVERY ROW
#      PRINT COLUMN   1,sr.imo01 CLIPPED,
#            COLUMN  18,sr.imp02 USING '###&',
#            COLUMN  23,sr.imo02 CLIPPED,
#            COLUMN  32,sr.imo03 CLIPPED,
#            COLUMN  43,sr.imp03 CLIPPED,
#            COLUMN  74,sr.ima02 CLIPPED,
#            COLUMN 105,sr.ima021 CLIPPED,
#            COLUMN 136,sr.ima25 CLIPPED,
#            COLUMN 141,cl_numfor(sr.imp04,18,g_ccz.ccz27), #CHI-690007 3->g_ccz.ccz27
#            COLUMN 161,cl_numfor(sr.imp09,18,g_azi03),
#            COLUMN 181,cl_numfor(sr.imp10,18,g_azi04) 
#
#    ON LAST ROW
#      PRINT COLUMN 161,g_x[13] CLIPPED,
#            COLUMN 181,cl_numfor(SUM(sr.imp10),18,g_azi05)
#      PRINT g_dash[1,m_len] CLIPPED
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (m_len-9), g_x[6] CLIPPED
#
#    PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,m_len] CLIPPED
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (m_len-9), g_x[6] CLIPPED
#      ELSE 
#         SKIP 2 LINE
#      END IF
#
#END REPORT
#
#REPORT axcr007_rep1(sr1)
#  DEFINE l_last_sw  LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1),
#         l_j        LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#         l_str      STRING,   #FUN-680007 add
#         l_msg      STRING,   #FUN-680007 add
#         sr1        RECORD
#                     imr00     LIKE imr_file.imr00,   #償還方式   #FUN-680007 add
#                     imr01     LIKE imr_file.imr01,   #還料單號
#                     imq02     LIKE imq_file.imq02,   #項次
#                     imr09     LIKE imr_file.imr09,   #扣帳日期
#                     imq03     LIKE imq_file.imq03,   #借料單號
#                     imq04     LIKE imq_file.imq04,   #項次
#                     imq05     LIKE imq_file.imq05,   #還料料號
#                     ima02     LIKE ima_file.ima02,   #品名
#                     ima021    LIKE ima_file.ima021,  #規格
#                     ima25     LIKE ima_file.ima25,   #單位
#                     imq07     LIKE imq_file.imq07,   #還料數量
#                     imq11     LIKE imq_file.imq11,   #單價
#                     amt       LIKE imq_file.imq12    #金額
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER EXTERNAL BY sr1.imr00,sr1.imr01,sr1.imq02
#
#  FORMAT
#    PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME;
#      PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      LET l_j = FGL_WIDTH(g_x[9])+6+FGL_WIDTH(g_x[10])+2
#      PRINT (g_len-l_j)/2 SPACES, 
#            g_x[9] CLIPPED,tm.yy USING '&&&&', 2 SPACES,
#            g_x[10] CLIPPED,tm.mm USING '&&'
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN   1,g_x[12] CLIPPED    #還料明細
#      PRINT
#     #start FUN-680007 modify
#     #PRINT COLUMN   1,g_x[41] CLIPPED,   #還料單號
#     #      COLUMN  18,g_x[42] CLIPPED,   #項次
#     #      COLUMN  23,g_x[43] CLIPPED,   #扣帳日期
#     #      COLUMN  32,g_x[44] CLIPPED,   #借料單號
#     #      COLUMN  49,g_x[45] CLIPPED,   #項次
#     #      COLUMN  54,g_x[46] CLIPPED,   #還料料號
#     #      COLUMN  85,g_x[47] CLIPPED,   #品名
#     #      COLUMN 116,g_x[48] CLIPPED,   #規格
#     #      COLUMN 147,g_x[49] CLIPPED,   #單位
#     #      COLUMN 152,g_x[50] CLIPPED,   #還料數量
#     #      COLUMN 172,g_x[51] CLIPPED,   #單價
#     #      COLUMN 192,g_x[52] CLIPPED    #金額
#     #PRINT "---------------- ---- -------- ---------------- ---- ",
#     #      "------------------------------ ------------------------------ ------------------------------ ",
#     #      "---- ------------------- ------------------- -------------------"
#      PRINT COLUMN   1,g_x[40] CLIPPED,   #償還方式
#            COLUMN  12,g_x[41] CLIPPED,   #還料單號
#            COLUMN  29,g_x[42] CLIPPED,   #項次
#            COLUMN  34,g_x[43] CLIPPED,   #扣帳日期
#            COLUMN  43,g_x[44] CLIPPED,   #借料單號
#            COLUMN  60,g_x[45] CLIPPED,   #項次
#            COLUMN  65,g_x[46] CLIPPED,   #還料料號
#            COLUMN  96,g_x[47] CLIPPED,   #品名
#            COLUMN 127,g_x[48] CLIPPED,   #規格
#            COLUMN 158,g_x[49] CLIPPED,   #單位
#            COLUMN 163,g_x[50] CLIPPED,   #還料數量
#            COLUMN 183,g_x[51] CLIPPED,   #單價
#            COLUMN 203,g_x[52] CLIPPED    #金額
#      PRINT "---------- ---------------- ---- -------- ---------------- ---- ",
#            "------------------------------ ------------------------------ ------------------------------ ",
#            "---- ------------------- ------------------- -------------------"
#     #end FUN-680007 modify
#      LET l_last_sw = 'n'
#
#    ON EVERY ROW
#     #start FUN-680007 modify
#     #PRINT COLUMN   1,sr1.imr01 CLIPPED,
#     #      COLUMN  18,sr1.imq02 USING '###&',
#     #      COLUMN  23,sr1.imr09 CLIPPED,
#     #      COLUMN  32,sr1.imq03 CLIPPED,
#     #      COLUMN  49,sr1.imq04 USING '###&',
#     #      COLUMN  54,sr1.imq05 CLIPPED,
#     #      COLUMN  85,sr1.ima02 CLIPPED,
#     #      COLUMN 116,sr1.ima021 CLIPPED,
#     #      COLUMN 147,sr1.ima25 CLIPPED,
#     #      COLUMN 152,cl_numfor(sr1.imq07,18,3),
#     #      COLUMN 172,cl_numfor(sr1.imq11,18,g_azi03),
#     #      COLUMN 192,cl_numfor(sr1.amt,18,g_azi04) 
#      CASE sr1.imr00
#         WHEN '1'   #原數償還
#            CALL cl_getmsg('sub-058',g_lang) RETURNING l_str
#         WHEN '2'   #原價償還
#            CALL cl_getmsg('sub-059',g_lang) RETURNING l_str
#      END CASE
#      LET l_msg = sr1.imr00,1 SPACES,l_str
#      PRINT COLUMN   1,l_msg CLIPPED,
#            COLUMN  12,sr1.imr01 CLIPPED,
#            COLUMN  29,sr1.imq02 USING '###&',
#            COLUMN  34,sr1.imr09 CLIPPED,
#            COLUMN  43,sr1.imq03 CLIPPED,
#            COLUMN  60,sr1.imq04 USING '###&',
#            COLUMN  65,sr1.imq05 CLIPPED,
#            COLUMN  96,sr1.ima02 CLIPPED,
#            COLUMN 127,sr1.ima021 CLIPPED,
#            COLUMN 158,sr1.ima25 CLIPPED,
#            COLUMN 163,cl_numfor(sr1.imq07,18,g_ccz.ccz27), #CHI-690007 3->g_ccz.ccz27
#            COLUMN 183,cl_numfor(sr1.imq11,18,g_azi03),
#            COLUMN 203,cl_numfor(sr1.amt,18,g_azi04) 
#     #end FUN-680007 modify
#
#    ON LAST ROW
#     #start FUN-680007 modify
#      PRINT COLUMN 183,g_x[13] CLIPPED,
#            COLUMN 203,cl_numfor(SUM(sr1.amt),18,g_azi05)
#     #end FUN-680007 modify
#      PRINT g_dash[1,g_len] CLIPPED
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#    PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len] CLIPPED
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE 
#         SKIP 2 LINE
#      END IF
#
#END REPORT
#--------------------No.FUN-750112--end--------------------------#

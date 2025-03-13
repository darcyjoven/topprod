# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr420.4gl
# Descriptions...:預售遠期外匯溢價攤銷明細表
# Date & Author..: 99/05/10 By Iceman
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/15 By johnray 報表修改
# Modify.........: No.FUN-830133 08/04/08 By jan 報表改CR輸出
# Modify.........: No.CHI-8A0015 08/11/04 By Sarah 交割日期改為INPUT條件,組SQL時抓取gxc04<=交割日期<=gxc041的資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580010  --begin
GLOBALS
DEFINE g_zaa04_value  LIKE zaa_file.zaa04
DEFINE g_zaa10_value  LIKE zaa_file.zaa10
DEFINE g_zaa11_value  LIKE zaa_file.zaa11
DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
#No.FUN-580010  --end
 
DEFINE tm       RECORD				  # Print condition RECORD
                 wc    LIKE type_file.chr1000,    #No.FUN-680107 VARCHAR(600) #Where Condiction
                 gxc04 LIKE gxc_file.gxc04,       #CHI-8A0015 add
                 yy    LIKE type_file.num5,       #No.FUN-680107 SMALLINT  #基準日期
                 mm    LIKE type_file.num5,       #No.FUN-680107 SMALLINT  #基準日期
                 a     LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)   #交易性質
                 s     LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
                 t     LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
                 u     LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
                 more  LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)            #
                END RECORD,
       g_begin  LIKE type_file.dat,               #No.FUN-680107 DATE
       g_end    LIKE type_file.dat,               #No.FUN-680107 DATE
#      g_dash1  VARCHAR(400),	                  # Report Heading & prompt  #No.FUN-580010
       g_date   ARRAY[13] OF LIKE type_file.dat   #No.FUN-680107 ARRAY[13] OF DATE # Report Heading & prompt
DEFINE g_p      ARRAY[13] OF LIKE type_file.chr1000    #No.FUN-830133           
DEFINE g_i      LIKE type_file.num5               #count/index for any purpose #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_len     SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno  SMALLINT   #Report page no
#DEFINE   g_zz05    VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
DEFINE g_sql    STRING             #No.FUN-830133                                                                                
DEFINE l_table  STRING             #No.FUN-830133                                                                                
DEFINE g_str    STRING             #No.FUN-830133
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-830133--BEGIN--                                                                                                             
   LET g_sql="alg02.alg_file.alg02,",                                                                                               
             "gxc03.gxc_file.gxc03,",                                                                                               
             "gxc04.gxc_file.gxc04,",                                                                                               
             "gxc07.gxc_file.gxc07,",
             "amt.type_file.num20_6,",                                                                                               
             "amt1.type_file.num20_6,",                                                                                               
             "amt2.type_file.num20_6,",                                                                                               
             "amt3.type_file.num20_6,",                                                                                               
             "amt4.type_file.num20_6,",                                                                                               
             "amt5.type_file.num20_6,",                                                                                               
             "amt6.type_file.num20_6,",                                                                                               
             "amt7.type_file.num20_6,",                                                                                               
             "amt8.type_file.num20_6,",                                                                                               
             "amt9.type_file.num20_6,",                                                                                               
             "amta.type_file.num20_6,",                                                                                               
             "amtb.type_file.num20_6,",                                                                                               
             "amtc.type_file.num20_6,",                                                                                               
             "l_temp.type_file.num20_6"                                                                                               
    LET l_table=cl_prt_temptable("anmr420",g_sql) CLIPPED                                                                           
    IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
              "        ?,?,? ) "                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("insert_prep:",status,1)                                                                                         
    END IF                                                                                                                          
#No.FUN-830133--END--   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.gxc04 = ARG_VAL(8)   #CHI-8A0015 add
   LET tm.yy    = ARG_VAL(9)   #TQC-610058
   LET tm.mm    = ARG_VAL(10)  #TQC-610058
   LET tm.a     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr420_tm()	        	# Input print condition
      ELSE CALL anmr420()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr420_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,        #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,     #No.FUN-680107 VARCHAR(400)
       l_jmp_flag  LIKE type_file.chr1         #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW anmr420_w AT p_row,p_col WITH FORM "anm/42f/anmr420"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.yy = year(Today)
   LET tm.mm = month(Today)
   LET tm.a = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     #CONSTRUCT BY NAME tm.wc ON gxc03,gxc04,gxc05,gxc07   #CHI-8A0015 mark
      CONSTRUCT BY NAME tm.wc ON gxc03,gxc05,gxc07         #CHI-8A0015
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW anmr420_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
     #INPUT BY NAME tm.yy,tm.mm,tm.a,tm.more            #CHI-8A0015 mark
      INPUT BY NAME tm.gxc04,tm.yy,tm.mm,tm.a,tm.more   #CHI-8A0015
            WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        #str CHI-8A0015 add
        #從QBE條件改為INPUT條件
         AFTER FIELD gxc04   #交割日期
            IF cl_null(tm.gxc04) THEN
               NEXT FIELD gxc04
            END IF
        #end CHI-8A0015 add
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN NEXT FIELD a END IF
    
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]"
               THEN NEXT FIELD more
            END IF
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW anmr420_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
                WHERE zz01='anmr420'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmr420','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                       #" '",g_lang CLIPPED,"'",     #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'",    #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.gxc04 CLIPPED,"'",   #CHI-8A0015 add
                        " '",tm.yy CLIPPED,"'",      #TQC-610058
                        " '",tm.mm CLIPPED,"'",      #TQC-610058
                        " '",tm.a CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'", #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'", #No.FUN-570264
                        " '",g_template CLIPPED,"'", #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"  #No.FUN-7C0078
            CALL cl_cmdat('anmr420',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW anmr420_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL anmr420_fill()
      CALL anmr420()
      ERROR ""
END WHILE
   CLOSE WINDOW anmr420_w
END FUNCTION
 
FUNCTION anmr420()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #標題內容  #No.FUN-680107 VARCHAR(40)
          l_gxc03       LIKE gxc_file.gxc03,
          l_gxc04       LIKE gxc_file.gxc04,
          l_unitamt     LIKE gxc_file.gxc08,
          l_days        LIKE type_file.num10,           #No.FUN-680107 INTEGER
          l_qty         LIKE type_file.num10,           #No.FUN-680107 INTEGER
          l_i           LIKE type_file.num10,           #No.FUN-680107 INTEGER
          l_zaa02       LIKE zaa_file.zaa02,            #No.FUN-580010
          sr            RECORD
                        gxc    RECORD LIKE gxc_file.*,  #外匯交易檔
                        alg02  LIKE alg_file.alg02,     #信貸銀行簡稱
                        amt    LIKE gxc_file.gxc08,
                        amt1   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt2   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt3   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt4   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt5   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt6   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt7   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt8   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amt9   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amta   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amtb   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        amtc   LIKE type_file.num20_6,  #No.FUN-680107 DEC(20,6)
                        unitp  LIKE gxc_file.gxc08
                        END RECORD
DEFINE l_temp        LIKE type_file.num20_6     #No.FUN-830133
 
     CALL cl_del_data(l_table)     #No.FUN-830133                                                                                   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-830133
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr420'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    IF tm.a = '1' THEN LET g_len = 188 ELSE LET g_len=308 END IF
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
     LET l_sql = "SELECT gxc_file.*,alg02,0, ",
                 "  0,0,0,0,0,0,0,0,0,0,0,0,0 ",
                 "  FROM gxc_file,alg_file ",
                 " WHERE alg01 = gxc07 ",
                 "   AND gxc02 = '2' ",
                 "   AND gxc10 > gxc09 ",
                 "   AND gxc13 <> 'X' ",   #010815增
                #"   AND gxc04 >= '",g_begin,"'",   #CHI-8A0015 mark
                 "   AND ",tm.wc CLIPPED,
                 "   AND gxc04 <='",tm.gxc04,"'",   #CHI-8A0015 add
                 "   AND gxc041>='",tm.gxc04,"'"    #CHI-8A0015 add
     PREPARE anmr420_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr420_curs1 CURSOR FOR anmr420_prepare1
#No.FUN-830133--BEGIN--MARK     
#     CALL cl_outnam('anmr420') RETURNING l_name
#    #No.FUN-580010  --begin
#     IF tm.a = '1' THEN
#        LET g_zaa[41].zaa06 = 'Y'
#        LET g_zaa[42].zaa06 = 'Y'
#        LET g_zaa[43].zaa06 = 'Y'
#        LET g_zaa[44].zaa06 = 'Y'
#        LET g_zaa[45].zaa06 = 'Y'
#        LET g_zaa[46].zaa06 = 'Y'
#
#        LET g_len = 0
#        LET l_sql="SELECT zaa02 FROM zaa_file ",
#                  " WHERE zaa01 = '",g_prog CLIPPED,"' AND zaa03 = '",g_rlang,"'",
#                  "  AND zaa04= '",g_zaa04_value CLIPPED,"' AND zaa09='2'",
#                  "  AND zaa10='", g_zaa10_value CLIPPED,"' AND zaa11='",g_zaa11_value CLIPPED,
#                  "' AND zaa17='", g_zaa17_value CLIPPED,"' ORDER BY zaa07"
#        PREPARE zaa_pre FROM l_sql
#        DECLARE zaa_cur CURSOR FOR zaa_pre
#        FOREACH zaa_cur INTO l_zaa02
#              IF g_zaa[l_zaa02].zaa06 = "N" THEN
#                 LET g_len = g_len + g_zaa[l_zaa02].zaa05 + 1
#              END IF
#        END FOREACH
#        LET g_len = g_len - 1
#        LET g_dash = NULL
#        FOR l_i = 1 TO g_len
#            LET g_dash[l_i] = "="
#        END FOR
#     END IF
#     #No.FUN-580010  --end
#     START REPORT anmr420_rep TO l_name
#No.FUN-830133--END--MARK--
     LET g_pageno = 0
     FOREACH anmr420_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET sr.amt = sr.gxc.gxc08*(sr.gxc.gxc10-sr.gxc.gxc09)*sr.gxc.gxc11
       LET l_days = sr.gxc.gxc04 - sr.gxc.gxc03 +1
       LET l_unitamt = sr.amt / l_days
       LET l_gxc03 = sr.gxc.gxc03 LET l_gxc04 = sr.gxc.gxc04
       IF l_gxc03 < g_date[1] THEN LET l_gxc03 = g_date[1]-1 END IF
       LET sr.unitp = l_unitamt
       FOR l_i = 1 TO 12
           CASE
                WHEN l_gxc03 >= g_date[l_i] AND l_gxc03 <= g_date[l_i+1]
                     IF l_gxc04 < g_date[l_i+1] THEN
                        LET l_qty = l_gxc04 - l_gxc03
                        LET l_gxc03 = l_gxc04
                     ELSE
                        LET l_qty = g_date[l_i+1] - 1 - l_gxc03
                        LET l_gxc03 = g_date[l_i+1] - 1
                     END IF
                WHEN l_gxc03 < g_date[l_i] AND l_gxc04 > g_date[l_i+1]-1
                     LET l_qty = g_date[l_i+1] - 1 - l_gxc03
                     LET l_gxc03 = g_date[l_i+1] - 1
                WHEN l_gxc03 < g_date[l_i] AND l_gxc04 <= g_date[l_i+1]-1
                     LET l_qty = l_gxc04 - l_gxc03
                     LET l_gxc03 = l_gxc04
           END CASE
           CASE l_i
               WHEN 1 LET sr.amt1 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 2 LET sr.amt2 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 3 LET sr.amt3 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 4 LET sr.amt4 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 5 LET sr.amt5 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 6 LET sr.amt6 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 7 LET sr.amt7 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 8 LET sr.amt8 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 9 LET sr.amt9 = cl_digcut(l_qty*l_unitamt,0)
               WHEN 10 LET sr.amta = cl_digcut(l_qty*l_unitamt,0)
               WHEN 11 LET sr.amtb = cl_digcut(l_qty*l_unitamt,0)
               WHEN 12 LET sr.amtc = cl_digcut(l_qty*l_unitamt,0)
           END CASE
           IF l_gxc03 = l_gxc04 THEN EXIT FOR END IF
       END FOR
#No.FUN-830133--BEGIN--
      LET g_p[1] = g_date[1] USING 'YY/MM'
      LET g_p[2] = g_date[2] USING 'YY/MM'
      LET g_p[3] = g_date[3] USING 'YY/MM'
      LET g_p[4] = g_date[4] USING 'YY/MM'
      LET g_p[5] = g_date[5] USING 'YY/MM'
      LET g_p[6] = g_date[6] USING 'YY/MM'
      LET g_p[7] = g_date[7] USING 'YY/MM'
      LET g_p[8] = g_date[8] USING 'YY/MM'
      LET g_p[9] = g_date[9] USING 'YY/MM'
      LET g_p[10] = g_date[10] USING 'YY/MM'
      LET g_p[11] = g_date[11] USING 'YY/MM'
      LET g_p[12] = g_date[12] USING 'YY/MM'
      IF tm.a = '1' THEN
         LET l_temp = sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+sr.amt6
      ELSE
         LET l_temp = sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+sr.amt6
                    + sr.amt7+sr.amt8+sr.amt9+sr.amta+sr.amtb+sr.amtc
      END IF       
#     OUTPUT TO REPORT anmr420_rep(sr.*)
      EXECUTE insert_prep USING
         sr.alg02,sr.gxc.gxc03,sr.gxc.gxc04,sr.gxc.gxc07,
         sr.amt,  sr.amt1, sr.amt2, sr.amt3, sr.amt4,
         sr.amt5, sr.amt6, sr.amt7, sr.amt8, sr.amt9,
         sr.amta, sr.amtb, sr.amtc, l_temp
     END FOREACH
#    FINISH REPORT anmr420_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'gxc03,gxc05,gxc07')   #CHI-8A0015 mod
        RETURNING g_str
     END IF
     LET g_str = g_str,";",g_p[1],";",g_p[2],";",
                 g_p[3],";",g_p[4],";",g_p[5],";",
                 g_p[6],";",g_p[7],";",g_p[8],";",
                 g_p[9],";",g_p[10],";",g_p[11],";",
                 g_p[12],";",g_azi04,";",g_azi05
     IF tm.a = '1' THEN
        CALL cl_prt_cs3('anmr420','anmr420',g_sql,g_str)                                                                                
     ELSE                                                                                                                            
        CALL cl_prt_cs3('anmr420','anmr420_1',g_sql,g_str)                                                                              
     END IF
#No.FUN-830133--END
END FUNCTION
 
#No.FUN-830133--BEGIN--MARK--
#REPORT anmr420_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,                  #No.FUN-680107 VARCHAR(1)
#          l_i           LIKE type_file.num5,                  #No.FUN-680107 SMALLINT
#          l_temp        LIKE type_file.num20_6,               #No.FUN-680107 DEC(20,6)
#          l_line        LIKE type_file.num5,                  #No.FUN-680107 SMALLINT
#                        l_amt1   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amt2   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amt3   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amt4   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amt5   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amt6   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
##                        l_amt8   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amt9   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amta   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amtb   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#                        l_amtc   LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
#          sr            RECORD
#                        gxc    RECORD LIKE gxc_file.*,        #外匯交易檔
#                        alg02  LIKE alg_file.alg02,           #信貸銀行簡稱
#                        amt    LIKE gxc_file.gxc08,
#                        amt1   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6) 
#                        amt2   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amt3   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amt4   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amt5   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amt6   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amt7   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amt8   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amt9   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amta   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amtb   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        amtc   LIKE type_file.num20_6,        #No.FUN-680107 DEC(20,6)
#                        unitp  LIKE gxc_file.gxc08
#                        END RECORD,
#          l_tot                LIKE gxc_file.gxc08,
#          a_tot,b_tot,c_tot,a_amt,b_amt,c_amt LIKE gxc_file.gxc08,
##  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#  ORDER BY sr.gxc.gxc07,sr.gxc.gxc03,sr.gxc.gxc04
#  FORMAT
#   PAGE HEADER
#No.FUN-580010  -begin
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#      PRINT     #No.TQC-6A0110
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT     #No.TQC-6A0110
#      PRINT g_dash
#      FOR l_i = 1 TO 12
#          LET g_zaa[34+l_i].zaa08 = g_date[l_i] USING 'YY/MM'
#      END FOR
#No.TQC-6A0110 -- begin --
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#            g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42],
#            g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#      IF tm.a = '1' THEN
#         LET g_x[41]=g_x[47]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],                                   
#               g_x[35],g_x[36],g_x[37],g_x[38],                                   
#               g_x[39],g_x[40],g_x[41]
#      ELSE
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],                                   
#               g_x[35],g_x[36],g_x[37],g_x[38],                                   
#               g_x[39],g_x[40],g_x[41],g_x[42],                                   
#               g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#      END IF
#No.TQC-6A0110 -- end --
#      PRINT g_dash1
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash1[1,g_len]
#     PRINT COLUMN 03,g_x[11] CLIPPED,
#           COLUMN 13,g_x[12] CLIPPED,
#           COLUMN 45, ' ';
#     IF tm.a = '2' THEN
#        LET l_line=57
#        FOR l_i = 1 TO 12 PRINT COLUMN l_line,g_date[l_i] USING 'YY/MM';
#            LET l_line=l_line+20
#        END FOR
#        PRINT COLUMN 298,g_x[15]
#     ELSE
#        LET l_line=57
#        FOR l_i = 1 TO 6 PRINT COLUMN l_line,g_date[l_i] USING 'YY/MM';
#            LET l_line=l_line+20
#        END FOR
#        PRINT COLUMN 178,g_x[15]
#     END IF
#     PRINT '---------- -------- --------', COLUMN 30,'-------------------';
#     IF tm.a = '2' THEN
#        PRINT COLUMN 50,'-------------------',COLUMN 70,'-------------------',
#              COLUMN 90,'-------------------',COLUMN 110,'-------------------',
#              COLUMN 130,'-------------------',COLUMN 150,'-------------------',
#              COLUMN 170,'-------------------',COLUMN 190,'-------------------',
#              COLUMN 210,'-------------------',COLUMN 230,'-------------------',
#              COLUMN 250,'-------------------',COLUMN 270,'-------------------',
#              COLUMN 290,'-------------------'
#     ELSE
#        PRINT COLUMN 50,'-------------------',COLUMN 70,'-------------------',
#              COLUMN 90,'-------------------',COLUMN 110,'-------------------',
#              COLUMN 130,'-------------------',COLUMN 150,'-------------------',
#              COLUMN 170,'-------------------'
#     END IF
#No.FUN-580010  -end
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#     PRINT sr.alg02,
#           COLUMN 12,sr.gxc.gxc03,' ',sr.gxc.gxc04,
#           COLUMN 30,cl_numfor(sr.amt,18,g_azi05);
#     IF tm.a = '1' THEN
#        LET l_temp = sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+sr.amt6
#        PRINT COLUMN 50,cl_numfor(sr.amt1,18,g_azi04),
#              COLUMN 70,cl_numfor(sr.amt2,18,g_azi04),
#              COLUMN 90,cl_numfor(sr.amt3,18,g_azi04),
#              COLUMN 110,cl_numfor(sr.amt4,18,g_azi04),
#              COLUMN 130,cl_numfor(sr.amt5,18,g_azi04),
#              COLUMN 150,cl_numfor(sr.amt6,18,g_azi04),
#              COLUMN 170,cl_numfor(l_temp, 18,g_azi05)
#     ELSE
#        LET l_temp = sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+sr.amt6
#                   + sr.amt7+sr.amt8+sr.amt9+sr.amta+sr.amtb+sr.amtc
#        PRINT COLUMN 50 ,cl_numfor(sr.amt1,18,g_azi04),
#              COLUMN 70 ,cl_numfor(sr.amt2,18,g_azi04),
#              COLUMN 90 ,cl_numfor(sr.amt3,18,g_azi04),
#              COLUMN 110,cl_numfor(sr.amt4,18,g_azi04),
#              COLUMN 130,cl_numfor(sr.amt5,18,g_azi04),
#              COLUMN 150,cl_numfor(sr.amt6,18,g_azi04),
#              COLUMN 170,cl_numfor(sr.amt7,18,g_azi04),
#              COLUMN 190,cl_numfor(sr.amt8,18,g_azi04),
#              COLUMN 210,cl_numfor(sr.amt9,18,g_azi04),
#              COLUMN 230,cl_numfor(sr.amta,18,g_azi04),
#              COLUMN 250,cl_numfor(sr.amtb,18,g_azi04),
#              COLUMN 270,cl_numfor(sr.amtc,18,g_azi04),
#              COLUMN 290,cl_numfor(l_temp, 18,g_azi05)
#     END IF
#      IF tm.a = '1' THEN
#         LET l_temp = sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+sr.amt6
#No.TQC-6A0110 -- begin --
#         PRINT COLUMN g_c[31],sr.alg02,
#               COLUMN g_c[32],sr.gxc.gxc03,
#               COLUMN g_c[33],sr.gxc.gxc04,
#               COLUMN g_c[34],cl_numfor(sr.amt,34,g_azi05),
#               COLUMN g_c[35],cl_numfor(sr.amt1,35,g_azi04),
#               COLUMN g_c[36],cl_numfor(sr.amt2,36,g_azi04),
#               COLUMN g_c[37],cl_numfor(sr.amt3,37,g_azi04),
#               COLUMN g_c[38],cl_numfor(sr.amt4,38,g_azi04),
#               COLUMN g_c[39],cl_numfor(sr.amt5,39,g_azi04),
#               COLUMN g_c[40],cl_numfor(sr.amt6,40,g_azi04),
#              COLUMN g_c[41],cl_numfor(l_temp,47,g_azi05)
#No.TQC-6A0110 -- end --
#      ELSE
#         LET l_temp = sr.amt1+sr.amt2+sr.amt3+sr.amt4+sr.amt5+sr.amt6
#                   + sr.amt7+sr.amt8+sr.amt9+sr.amta+sr.amtb+sr.amtc
#      END IF    #No.TQC-6A0110
#         PRINT COLUMN g_c[31],sr.alg02,
#               COLUMN g_c[32],sr.gxc.gxc03,
#               COLUMN g_c[33],sr.gxc.gxc04,
#               COLUMN g_c[34],cl_numfor(sr.amt,34,g_azi05),
#               COLUMN g_c[35],cl_numfor(sr.amt1,35,g_azi04),
#               COLUMN g_c[36],cl_numfor(sr.amt2,36,g_azi04),
#               COLUMN g_c[37],cl_numfor(sr.amt3,37,g_azi04),
#               COLUMN g_c[38],cl_numfor(sr.amt4,38,g_azi04),
#               COLUMN g_c[39],cl_numfor(sr.amt5,39,g_azi04),
#               COLUMN g_c[40],cl_numfor(sr.amt6,40,g_azi04),
#               COLUMN g_c[41],cl_numfor(sr.amt7,41,g_azi04),
#               COLUMN g_c[42],cl_numfor(sr.amt8,42,g_azi04),
#               COLUMN g_c[43],cl_numfor(sr.amt9,43,g_azi04),
#               COLUMN g_c[44],cl_numfor(sr.amta,44,g_azi04),
#               COLUMN g_c[45],cl_numfor(sr.amtb,45,g_azi04),
#               COLUMN g_c[46],cl_numfor(sr.amtc,46,g_azi04),
#               COLUMN g_c[47],cl_numfor(l_temp, 47,g_azi05)
#      END IF      #No.TQC-6A0110    
#   ON LAST ROW
#     PRINT '---------- -------- --------', COLUMN 30,'-------------------';
#      LET l_amt1 = SUM(sr.amt1)
#      LET l_amt2 = SUM(sr.amt2)
#      LET l_amt3 = SUM(sr.amt3)
#      LET l_amt4 = SUM(sr.amt4)
#      LET l_amt5 = SUM(sr.amt5)
#      LET l_amt6 = SUM(sr.amt6)
#      LET l_amt7 = SUM(sr.amt7)
#      LET l_amt8 = SUM(sr.amt8)
#      LET l_amt9 = SUM(sr.amt9)
#      LET l_amta = SUM(sr.amta)
#      LET l_amtb = SUM(sr.amtb)
#      LET l_amtc = SUM(sr.amtc)
#      IF tm.a = '1' THEN
#         LET l_temp = l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6
#No.TQC-6A0110 -- begin --
#         PRINT g_dash1
#         PRINT 'Total : ',                                                         
#               COLUMN g_c[34],cl_numfor(sr.amt,34,g_azi05),                        
#               COLUMN g_c[35],cl_numfor(l_amt1,35,g_azi05),                        
#               COLUMN g_c[36],cl_numfor(l_amt2,36,g_azi05),                        
#               COLUMN g_c[37],cl_numfor(l_amt3,37,g_azi05),                        
#               COLUMN g_c[38],cl_numfor(l_amt4,38,g_azi05),                        
#               COLUMN g_c[39],cl_numfor(l_amt5,39,g_azi05),                        
#               COLUMN g_c[40],cl_numfor(l_amt6,40,g_azi05),                        
#               COLUMN g_c[41],cl_numfor(l_temp,47,g_azi05)                         
#No.TQC-6A0110 -- end --
#      ELSE
#         LET l_temp = l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6
#                    + l_amt7+l_amt8+l_amt9+l_amta+l_amtb+l_amtc
#      END IF    #No.TQC-6A0110
#         PRINT g_dash1
#         PRINT 'Total : ',
#               COLUMN g_c[34],cl_numfor(sr.amt,34,g_azi05),
#               COLUMN g_c[35],cl_numfor(l_amt1,35,g_azi05),
#              COLUMN g_c[36],cl_numfor(l_amt2,36,g_azi05),
#               COLUMN g_c[37],cl_numfor(l_amt3,37,g_azi05),
#               COLUMN g_c[38],cl_numfor(l_amt4,38,g_azi05),
#               COLUMN g_c[39],cl_numfor(l_amt5,39,g_azi05),
#               COLUMN g_c[40],cl_numfor(l_amt6,40,g_azi05),
#               COLUMN g_c[41],cl_numfor(l_amt7,41,g_azi05),
#               COLUMN g_c[42],cl_numfor(l_amt8,42,g_azi05),
#               COLUMN g_c[43],cl_numfor(l_amt9,43,g_azi05),
#               COLUMN g_c[44],cl_numfor(l_amta,44,g_azi05),
#               COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi05),
#               COLUMN g_c[46],cl_numfor(l_amtc,46,g_azi05),
#               COLUMN g_c[41],cl_numfor(l_temp,47,g_azi05)
#         PRINT g_dash1    #No.TQC-6A0110
#      END IF       #No.TQC-6A0110
#No.TQC-6A0110 -- begin --
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#No.TQC-6A0110 -- end --
#     IF tm.a = '1' THEN
#        PRINT COLUMN 50,'-------------------',COLUMN 70,'-------------------',
#              COLUMN 90,'-------------------',COLUMN 110,'-------------------',
#              COLUMN 130,'-------------------',COLUMN 150,'-------------------',
#              COLUMN 170,'-------------------'
#     PRINT 'Total : ',COLUMN 30,
#           cl_numfor(sr.amt,18,g_azi05);
#        LET l_temp = l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6
#        PRINT COLUMN 50,cl_numfor(l_amt1,18,g_azi05),
#              COLUMN 70,cl_numfor(l_amt2,18,g_azi05),
#              COLUMN 90,cl_numfor(l_amt3,18,g_azi05),
#              COLUMN 110,cl_numfor(l_amt4,18,g_azi05),
#              COLUMN 130,cl_numfor(l_amt5,18,g_azi05),
#              COLUMN 150,cl_numfor(l_amt6,18,g_azi05),
#              COLUMN 170,cl_numfor(l_temp,18,g_azi05)
#     PRINT '---------- -------- --------', COLUMN 30,'-------------------';
#        PRINT COLUMN 50,'-------------------',COLUMN 70,'-------------------',
#              COLUMN 90,'-------------------',COLUMN 110,'-------------------',
#              COLUMN 130,'-------------------',COLUMN 150,'-------------------',
#              COLUMN 170,'-------------------'
#     ELSE
#        PRINT COLUMN 50,'-------------------',COLUMN 70,'-------------------',
#              COLUMN 90,'-------------------',COLUMN 110,'-------------------',
#              COLUMN 130,'-------------------',COLUMN 150,'-------------------',
#              COLUMN 170,'-------------------',COLUMN 190,'-------------------',
#              COLUMN 210,'-------------------',COLUMN 230,'-------------------',
#              COLUMN 250,'-------------------',COLUMN 270,'-------------------',
#              COLUMN 290,'-------------------'
#        LET l_temp = l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6
#                   + l_amt7+l_amt8+l_amt9+l_amta+l_amtb+l_amtc
#        PRINT 'Total : ',COLUMN 30,
#           cl_numfor(sr.amt,18,g_azi05);
#        PRINT COLUMN 50 ,cl_numfor(l_amt1,18,g_azi05),
#              COLUMN 70 ,cl_numfor(l_amt2,18,g_azi05),
#              COLUMN 90 ,cl_numfor(l_amt3,18,g_azi05),
#              COLUMN 110,cl_numfor(l_amt4,18,g_azi05),
#              COLUMN 130,cl_numfor(l_amt5,18,g_azi05),
#              COLUMN 150,cl_numfor(l_amt6,18,g_azi05),
#              COLUMN 170,cl_numfor(l_amt7,18,g_azi05),
#              COLUMN 190,cl_numfor(l_amt8,18,g_azi05),
#              COLUMN 210,cl_numfor(l_amt9,18,g_azi05),
#              COLUMN 230,cl_numfor(l_amta,18,g_azi05),
#              COLUMN 250,cl_numfor(l_amtb,18,g_azi05),
#              COLUMN 270,cl_numfor(l_amtc,18,g_azi05),
#              COLUMN 290,cl_numfor(l_temp,18,g_azi05)
#     PRINT '---------- -------- --------', COLUMN 30,'-------------------';
#        PRINT COLUMN 50,'-------------------',COLUMN 70,'-------------------',
#              COLUMN 90,'-------------------',COLUMN 110,'-------------------',
#              COLUMN 130,'-------------------',COLUMN 150,'-------------------',
#              COLUMN 170,'-------------------',COLUMN 190,'-------------------',
#              COLUMN 210,'-------------------',COLUMN 230,'-------------------',
#              COLUMN 250,'-------------------',COLUMN 270,'-------------------',
#              COLUMN 290,'-------------------'
#     END IF
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]      
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-830133-END--MARK--
 
FUNCTION anmr420_fill()
DEFINE l_yy LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_mm LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_i  LIKE type_file.num5          #No.FUN-680107 SMALLINT
LET l_yy = tm.yy
LET l_mm = tm.mm
LET g_begin = MDY(l_mm,1,l_yy)
LET g_date[1] = g_begin
FOR l_i = 2 TO 13
    LET l_mm = l_mm + 1
    IF l_mm = 13 THEN LET l_yy = l_yy + 1 LET l_mm = 1 END IF
    LET g_date[l_i] = MDY(l_mm,1,l_yy)
END FOR
LET g_end = g_date[13] - 1
RETURN
END FUNCTION
#Patch....NO.TQC-610036 <> #

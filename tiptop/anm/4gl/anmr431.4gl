# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: anmr431.4gl
# Descriptions...: 外匯交割明細表 
# Date & Author..: 
# Modify.........: No.FUN-4C0098 05/02/01 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊                 
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-830095 08/04/21 By lutingting報表轉為使用Crystal Report輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40115 10/04/23 By Carrier 追单MOA-9A0173
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				 # Print condition RECORD
              wc    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(600)  #Where Condiction    
              a     LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)    #交易性質
              b     LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)    #資料選項
              s     LIKE type_file.chr3,         #No.FUN-680107 VARCHAR(3)
              t     LIKE type_file.chr3,         #No.FUN-680107 VARCHAR(3)
              more  LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)  
              END RECORD
 
DEFINE   g_i        LIKE type_file.num5          #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_sql      STRING                       #No.FUN-830095
DEFINE   g_str      STRING                       #No.FUN-830095
DEFINE   l_table    STRING                       #No.FUN-830095
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#No.FUN-830095---------------------------start--
   LET g_sql = "gxe01.gxe_file.gxe01,",
               "gxe011.gxe_file.gxe011,",
               "gxe04.gxe_file.gxe04,", 
               "gxe071.gxe_file.gxe071,",
               "l_nma02_1.nma_file.nma02,",
               "gxe05.gxe_file.gxe05,",
               "gxe08.gxe_file.gxe08,",
               "gxe10.gxe_file.gxe10,", 
               "gxe11.gxe_file.gxe11,", 
               "l_tot1.gxe_file.gxe08,", 
               "gxe18.gxe_file.gxe18,", 
               "gxe17.gxe_file.gxe17,", 
               "gxe07.gxe_file.gxe07,", 
               "l_nma02_2.nma_file.nma02,",
               "gxe06.gxe_file.gxe06,", 
               "gxe09.gxe_file.gxe09,", 
               "l_tot2.gxe_file.gxe08,",
               "l_nma02_3.nma_file.nma02,",
               "azi04.azi_file.azi04,", 
               "azi07.azi_file.azi07,", 
               "gxe03.gxe_file.gxe03,",
               "l_azi07.azi_file.azi07"  
   LET l_table = cl_prt_temptable('anmr431',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF 
#No.FUN-830095---------------------------end
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.s    = ARG_VAL(10)
   LET tm.t    = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr431_tm()	        	# Input print condition
      ELSE CALL anmr431()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr431_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(400)
       l_jmp_flag  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW anmr431_w AT p_row,p_col
        WITH FORM "anm/42f/anmr431" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s = '21'
   LET tm.a = '1'
   LET tm.b = '1'
   LET tm.more = 'N'    
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON gxe01,gxe04,gxe03,gxe05 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr431_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.b,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm.more 
                 WITHOUT DEFAULTS  
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN NEXT FIELD a END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.a NOT MATCHES '[123]' THEN NEXT FIELD b END IF
 
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
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         IF INT_FLAG THEN EXIT INPUT END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr431_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr431'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr431','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr431',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr431_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr431()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr431_w
END FUNCTION
 
FUNCTION anmr431()
   DEFINE l_name	LIKE type_file.chr20, 	       # External(Disk) file name       #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,	       # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,        #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[3] OF LIKE gxe_file.gxe01,#No.FUN-680107 Array[3] OF VARCHAR(20)
          sr            RECORD 
                        order1 LIKE gxe_file.gxe01,    #No.FUN-680107 VARCHAR(20) #排列順序項目
                        order2 LIKE gxe_file.gxe01,    #No.FUN-680107 VARCHAR(20) #排列順序項目
                        order3 LIKE gxe_file.gxe01,    #No.FUN-680107 VARCHAR(20) #排列順序項目
                        gxe    RECORD LIKE gxe_file.*  #外匯交割資料檔
                        END RECORD
  #No.FUN-830095--------------start--
   DEFINE   l_nma02_1,l_nma02_2,l_nma02_3 LIKE nma_file.nma02
   DEFINE   l_tot1,l_tot2 LIKE gxe_file.gxe08                
   DEFINE   t_azi03       LIKE azi_file.azi03
   DEFINE   t_azi04       LIKE azi_file.azi04
   DEFINE   t_azi05       LIKE azi_file.azi05  
   DEFINE   t_azi07       LIKE azi_file.azi07
   DEFINE   l_azi07       LIKE azi_file.azi07 
  #No.FUN-830095--------------end
 
     CALL cl_del_data(l_table)    #No.FUN-830095
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmr431'  #No.FUN-830095  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','','',gxe_file.* ",
                 "  FROM gxe_file ",
                 " WHERE gxe13 !='X' AND  ",tm.wc CLIPPED   #010816增
 
     IF tm.a = '1'
        THEN LET l_sql = l_sql CLIPPED," AND gxe02 = '1' " 
        ELSE LET l_sql = l_sql CLIPPED," AND gxe02 = '2' " 
     END IF
 
    #TQC-A40115   ---start                                                      
    #IF tm.b = '1'                                                              
    #   THEN LET l_sql = l_sql CLIPPED," AND gxe13 = 'Y' "                      
    #   ELSE LET l_sql = l_sql CLIPPED," AND gxe13 = 'N' "                      
    #END IF                                                                     
     CASE tm.b                                                                  
        WHEN '1' LET l_sql = l_sql CLIPPED," AND gxe13 = 'Y' "                  
        WHEN '2' LET l_sql = l_sql CLIPPED," AND gxe13 = 'N' "                  
     END CASE                                                                   
    #TQC-A40115   ---END 
 
     PREPARE anmr431_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr431_curs1 CURSOR FOR anmr431_prepare1
 
     #CALL cl_outnam('anmr431') RETURNING l_name  #No.FUN-830095
     #START REPORT anmr431_rep TO l_name          #No.FUN-830095
 
     LET g_pageno = 0
     FOREACH anmr431_curs1 INTO sr.*
       IF STATUS  THEN CALL cl_err('',STATUS,0) EXIT FOREACH END IF 
       #No.FUN-830095--------------start--
       #FOR g_i = 1 TO 3
       #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.gxe.gxe01
       #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.gxe.gxe04
       #                                                    using 'yyyymmdd'
       #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.gxe.gxe03
       #                                                    using 'yyyymmdd'
       #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.gxe.gxe05
       #        OTHERWISE LET l_order[g_i] = '-'
       #   END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #LET sr.order3 = l_order[3]
       #OUTPUT TO REPORT anmr431_rep(sr.*)
        
       SELECT azi03,azi04,azi05,azi07
         INTO t_azi03,t_azi04,t_azi05,t_azi07    
         FROM azi_file
        WHERE azi01=sr.gxe.gxe05
       
       SELECT azi07 INTO l_azi07 
          FROM azi_file
        WHERE azi01 = sr.gxe.gxe06      
        
       SELECT nma02 INTO l_nma02_1 FROM nma_file WHERE nma01 = sr.gxe.gxe071
       IF SQLCA.sqlcode THEN LET l_nma02_1 = ' ' END IF
       
       SELECT nma02 INTO l_nma02_2 FROM nma_file WHERE nma01 = sr.gxe.gxe07
       IF SQLCA.sqlcode THEN LET l_nma02_2 = ' ' END IF
       
       SELECT nma02 INTO l_nma02_3 FROM nma_file WHERE nma01 = sr.gxe.gxe17
       IF SQLCA.sqlcode THEN LET l_nma02_3 = ' ' END IF
       
       LET l_tot1 = sr.gxe.gxe08 * sr.gxe.gxe10 * sr.gxe.gxe11
       LET l_tot2 = sr.gxe.gxe08 * sr.gxe.gxe09 * sr.gxe.gxe11 
       EXECUTE insert_prep USING
         sr.gxe.gxe01,sr.gxe.gxe011,sr.gxe.gxe04,sr.gxe.gxe071,l_nma02_1,
         sr.gxe.gxe05,sr.gxe.gxe08,sr.gxe.gxe10,sr.gxe.gxe11,l_tot1,
         sr.gxe.gxe18,sr.gxe.gxe17,sr.gxe.gxe07,l_nma02_2,sr.gxe.gxe06,
         sr.gxe.gxe09,l_tot2,l_nma02_3,t_azi04,t_azi07,sr.gxe.gxe03,l_azi07      
      #No.FUN-830095--------------end       
     END FOREACH
 
     #No.FUN-830095---------------start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'gxe01,gxe04,gxe03,gxe05')
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                 tm.t[2,2],";",tm.t[3,3],";",tm.a,";",g_azi04,";",tm.a,";",tm.b
                 
     CALL cl_prt_cs3('anmr431','anmr431',g_sql,g_str)
     #No.FUN-830095---------------end
     #FINISH REPORT anmr431_rep  #No.FUN-830095
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-830095
END FUNCTION
 
#No.FUN-830095---------------start--
#REPORT anmr431_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
#          t_azi03       LIKE azi_file.azi03,         #NO.CHI-6A0004
#          t_azi04       LIKE azi_file.azi04,         #NO.CHI-6A0004 
#          t_azi05       LIKE azi_file.azi05,         #NO.CHI-6A0004
#          sr            RECORD 
#                        order1 LIKE gxe_file.gxe01,  #No.FUN-680107 VARCHAR(20) #排列順序項目
#                        order2 LIKE gxe_file.gxe01,  #No.FUN-680107 VARCHAR(20) #排列順序項目
#                        order3 LIKE gxe_file.gxe01,  #No.FUN-680107 VARCHAR(20) #排列順序項目
#                        gxe    RECORD LIKE gxe_file.* 
#                        END RECORD,
#          l_nma02_1,l_nma02_2,l_nma02_3 LIKE nma_file.nma02,
#          l_tot1,l_tot2 LIKE gxe_file.gxe08 
#  OUTPUT
#      TOP MARGIN g_top_margin 
#      LEFT MARGIN g_left_margin 
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      IF tm.a = '1' THEN 
#         LET g_x[1] = g_x[16] CLIPPED,g_x[1] CLIPPED
#      ELSE
#         LET g_x[1] = g_x[17] CLIPPED,g_x[1] CLIPPED
#      END IF
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#   
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#   ON EVERY ROW
#
#      SELECT azi03,azi04,azi05,azi07
#        INTO t_azi03,t_azi04,t_azi05,t_azi07    #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.gxe.gxe05
#
#      SELECT nma02 INTO l_nma02_1 FROM nma_file WHERE nma01 = sr.gxe.gxe071
#      IF SQLCA.sqlcode THEN LET l_nma02_1 = ' ' END IF
#
#      SELECT nma02 INTO l_nma02_2 FROM nma_file WHERE nma01 = sr.gxe.gxe07
#      IF SQLCA.sqlcode THEN LET l_nma02_2 = ' ' END IF
#
#      SELECT nma02 INTO l_nma02_3 FROM nma_file WHERE nma01 = sr.gxe.gxe17
#      IF SQLCA.sqlcode THEN LET l_nma02_3 = ' ' END IF
#
#      LET l_tot1 = sr.gxe.gxe08 * sr.gxe.gxe10 * sr.gxe.gxe11
#      LET l_tot2 = sr.gxe.gxe08 * sr.gxe.gxe09 * sr.gxe.gxe11
#      PRINT COLUMN g_c[31],sr.gxe.gxe01,
#            COLUMN g_c[32],sr.gxe.gxe011 using '###&', #No.TQC-5C0051 #FUN-590118
#            COLUMN g_c[33],sr.gxe.gxe04,
#            column g_c[34],sr.gxe.gxe071,
#            COLUMN g_c[35],l_nma02_1,
#            COLUMN g_c[36],sr.gxe.gxe05,
#            COLUMN g_c[37],cl_numfor(sr.gxe.gxe08,37,t_azi04), #NO.CHI-6A0004
#            column g_c[38],cl_numfor(sr.gxe.gxe10,38,t_azi07), 
#            COLUMN g_c[39],cl_numfor(sr.gxe.gxe11,39,t_azi07), 
#            COLUMN g_c[40],cl_numfor(l_tot1,40,g_azi04),
#            COLUMN g_c[41],cl_numfor(sr.gxe.gxe18,41,g_azi04),
#            COLUMN g_c[42],sr.gxe.gxe17 clipped
#      PRINT column g_c[34],sr.gxe.gxe07,
#            COLUMN g_c[35],l_nma02_2,
#            COLUMN g_c[36],sr.gxe.gxe06,
#            column g_c[38],cl_numfor(sr.gxe.gxe09,38,t_azi07),
#            column g_c[40],cl_numfor(l_tot2,40,g_azi04),
#            COLUMN g_c[42],l_nma02_3 clipped
#
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-830095---------------end

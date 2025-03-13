# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: aglx900.4gl
# Descriptions...: 傳票過帳後檢查
# Input parameter:
# Return code....:
# Date & Author..: 94/01/18 By Fiona
#                  select aba_file、abb_file 時應加入帳別條件
# Modify.........: 97/08/05 By Melody  check (5)時應剔除 'CE'類來源傳票
# Modify.........: No.A116 04/03/16 By Danny
# Modify.........: No.MOD-510169 05/01/28 By Kitty 若全部打勾執行,永遠只執行第一項
# Modify.........: No.FUN-510007 05/02/22 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-5B0097 05/11/23 By Carrier 大陸版功能時,當科目層級超過2時,比對內容出現錯誤
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By bnlent 會計科目加帳套
# Modify.........: No.FUN-750129 07/06/15 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0194 10/11/29 By lixia 檢查沒問題時彈出提示
# Modify.........: No.FUN-CA0132 12/11/01 By wangrr CR轉XtraGrid,財務報表改善,年度、期別設置默認值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
              bookno LIKE aaa_file.aaa01,       #No.FUN-740020
              yy  LIKE aah_file.aah02,  #輸入年度
              bm  LIKE aah_file.aah03,  #起始期別
              em  LIKE aah_file.aah03,  #截止期別
              a1  LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
              a2  LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
              a3  LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
              a4  LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
              a5  LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
 	      more	LIKE type_file.chr1     #Input more condition(Y/N) #No.FUN-680098  VARCHAR(1)
              END RECORD,
           temp RECORD
                account LIKE aah_file.aah01,          #No.FUN-680098   VARCHAR(24)
                d1      LIKE type_file.num20_6,       #No.FUN-680098   dec(20,6)   
                c1      LIKE type_file.num20_6,       #No.FUN-680098   dec(20,6)
                d2      LIKE type_file.num20_6,       #No.FUN-680098   dec(20,6)
                c2      LIKE type_file.num20_6        #No.FUN-680098   dec(20,6)
                END RECORD,
          #g_bookno  LIKE aah_file.aah00, #帳別     #No.FUN-740020
          m_bdate1,m_edate1  LIKE type_file.dat,    #No.FUN-680098 date
          m_bdate2,m_edate2  LIKE type_file.dat     #No.FUN-680098 date
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 smallint
DEFINE l_table   STRING  #No.FUN-750129
DEFINE g_str     STRING  #No.FUN-750129
DEFINE g_sql     STRING  #No.FUN-750129
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-750129  --Begin
   LET g_sql = " name1.type_file.chr1,",
               " name2.aah_file.aah01,",
               " name3.aah_file.aah04,",
               " name4.aah_file.aah04,",
           #FUN-CA0132--add--str--
               " str1.type_file.chr1000,", 
               " str2.type_file.chr1000,",
               " str3.type_file.chr1000,",
               " azi04.azi_file.azi04 "
           #FUN-CA0132--add--end

   LET l_table = cl_prt_temptable('aglx900',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?)  " #FUN-CA0132 add 4'?'
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
 
   LET tm.bookno = ARG_VAL(1)           #No.FUN-740020
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.bm = ARG_VAL(9)
   LET tm.em = ARG_VAL(10)   #TQC-610056
   LET tm.a1 = ARG_VAL(11)   #TQC-610056
   LET tm.a2 = ARG_VAL(12)   #TQC-610056
   LET tm.a3 = ARG_VAL(13)   #TQC-610056
   LET tm.a4 = ARG_VAL(14)   #TQC-610056
   LET tm.a5 = ARG_VAL(15)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   LET tm.em = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)  #No.FUN-7C0078
   #No.FUN-740020 --Begin
   #IF cl_null(g_bookno) THEN
   #   LET g_bookno = g_aaz.aaz64
   #END IF
    IF cl_null(tm.bookno) THEN
       LET tm.bookno = g_aza.aza81
    END IF
   #No.FUN-740020 --End
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL aglx900_tm()	        	# Input print condition
      ELSE CALL aglx900()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglx900_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_sw          LIKE type_file.chr1,          #重要欄位是否空白#No.FUN-680098    VARCHAR(1)
          l_cmd	        LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
 
   CALL s_dsmark(tm.bookno)    #No.FUN-740020
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 30
   ELSE LET p_row = 4 LET p_col = 7
   END IF
   OPEN WINDOW aglx900_w AT p_row,p_col
        WITH FORM "agl/42f/aglx900"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)     #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   #使用預設帳別之幣別
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81  END IF     #No.FUN-740020
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno    #No.FUN-740020
   IF SQLCA.sqlcode THEN 
#      CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
       CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123     #No.FUN-740020
   END IF
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file                #No.CHI-6A0004 g_azi-->t_azi
    WHERE azi01 = g_aaa03
   LET tm.more = 'N'
   LET tm.a1 = 'Y'
   LET tm.a2 = 'Y'
   LET tm.a3 = 'Y'
   LET tm.a4 = 'Y'
   LET tm.a5 = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#FUN-CA0132--add--str--
   LET tm.yy=YEAR(g_today)
   LET tm.bm='1'
   SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01 = tm.yy
   IF g_azm.azm02 = '1' THEN
      LET tm.em='12'
   ELSE
      LET tm.em='13'
   END IF
#FUN-CA0132--add--end
WHILE TRUE
   INPUT BY NAME tm.bookno,tm.yy,tm.bm,tm.em,tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.more  #No.FUN-740020
            WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      #No.FUN-740020  --Begin
      AFTER FIELD bookno
           IF cl_null(tm.bookno) THEN
              NEXT FIELD bookno 
           END IF
      #No.FUN-740020  --End
 
 
      AFTER FIELD yy    #----> 年度
           IF cl_null(tm.yy) THEN
              CALL cl_err('','mfg0037',0)
              NEXT FIELD yy
           END IF
      AFTER FIELD bm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.bm IS NULL THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#         IF tm.bm <1 OR tm.bm > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD bm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.em IS NULL THEN NEXT FIELD em END IF
#No.TQC-720032 -- begin --
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN
            CALL cl_err('',9011,0)
            NEXT FIELD bm
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
             IF INT_FLAG THEN EXIT INPUT END IF
             IF cl_null(tm.yy) THEN LET l_sw = 0
                DISPLAY BY NAME tm.yy
             END IF
             IF cl_null(tm.bm) THEN LET l_sw = 0
                DISPLAY BY NAME tm.bm
             END IF
             IF cl_null(tm.em) THEN LET l_sw = 0
                DISPLAY BY NAME tm.em
             END IF
             IF l_sw = 0 THEN
		LET l_sw = 1
		NEXT FIELD yy
		CALL cl_err('',9033,0)
             END IF
         #No.FUN-740020  --Begin
         ON ACTION CONTROLP
          CASE
            WHEN INFIELD(bookno)                                                                                                       
              CALL cl_init_qry_var()                                                                                                 
              LET g_qryparam.form = 'q_aaa'                                                                                          
              LET g_qryparam.default1 = tm.bookno                                                                                     
              CALL cl_create_qry() RETURNING tm.bookno                                                                                
              DISPLAY BY NAME tm.bookno                                                                                               
              NEXT FIELD bookno 
          END CASE
         #No.FUN-740020  --End
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglx900_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aglx900'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglx900','9031',1)  
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                     " '",tm.bookno CLIPPED,"'",      #No.FUN-740020
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.bm CLIPPED,"'",
                     " '",tm.em CLIPPED,"'",
                     " '",tm.a1 CLIPPED,"'",   #TQC-610056
                     " '",tm.a2 CLIPPED,"'",   #TQC-610056
                     " '",tm.a3 CLIPPED,"'",   #TQC-610056
                     " '",tm.a4 CLIPPED,"'",   #TQC-610056
                     " '",tm.a5 CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglx900',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW aglx900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   #----------------CREATE TEMP TABLE----------------
   IF tm.a1='Y' OR tm.a2='Y' THEN CALL temp_t() END IF
   IF tm.a3='Y' OR tm.a4='Y' THEN CALL temp_s() END IF
   IF tm.a5='Y' THEN CALL temp_v() END IF
   #-------------------------------------------------
   CALL aglx900()
   ERROR ""
END WHILE
   CLOSE WINDOW aglx900_w
END FUNCTION
 
FUNCTION aglx900()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680098   VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0073
          l_sql 	LIKE type_file.chr1000,         # RDSQL STATEMENT        #No.FUN-680098   VARCHAR(1000)
          l_chr		LIKE type_file.chr1,            #No.FUN-680098   VARCHAR(1)
          l_za05	LIKE za_file.za05,              #No.FUN-680098   VARCHAR(40)
          sr    RECORD
                name1   LIKE  aah_file.aah01,
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
                END RECORD
 
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno    #No.FUN-740020
			AND aaf02 = g_rlang
     #No.FUN-750129  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     #CALL cl_outnam('aglx900') RETURNING l_name
     #START REPORT aglx900_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-750129  --End
     LET g_cnt    = 1
   #----> 取得"起始期別"的起始與截止日期
   CALL s_azn01(tm.yy,tm.bm) RETURNING m_bdate1, m_edate1
   #----> 取得"截止期別"的起始與截止日期
   CALL s_azn01(tm.yy,tm.em) RETURNING m_bdate2, m_edate2
    #No.MOD-510169 modi
   #No.MOD-5B0097  --begin
   #CHI-710005 MARK 
  #IF g_aza.aza26 = '2' THEN
      IF tm.a1 = 'Y' THEN CALL aglx900_1_2() END IF
      IF tm.a2 = 'Y' THEN CALL aglx900_2_2() END IF
  #ELSE
  #   IF tm.a1 = 'Y' THEN CALL aglx900_1() END IF
  #   IF tm.a2 = 'Y' THEN CALL aglx900_2() END IF
  #END IF
   #CHI-710005 MARK END
   #No.MOD-5B0097  --end
   IF tm.a3 = 'Y' THEN CALL aglx900_3() END IF
   IF tm.a4 = 'Y' THEN CALL aglx900_4() END IF
   IF tm.a5 = 'Y' THEN CALL aglx900_5() END IF
   #End
 
   #No.FUN-750129  --Begin
   #FINISH REPORT aglx900_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###XtraGrid###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###XtraGrid###   LET g_str = tm.yy,";",tm.bm,";",tm.yy,";",tm.em,";",t_azi04
#   CALL cl_prt_cs3('aglx900','aglx900',g_sql,g_str)#TQC-AB0194
#TQC-AB0194--add--str--
   IF g_cnt >1 THEN
###XtraGrid###      CALL cl_prt_cs3('aglx900','aglx900',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CA0132--add--str--
    LET g_xgrid.headerinfo1=cl_getmsg('aem-002',g_lang),":",tm.yy USING '<<<<',"/",
                            tm.bm USING'&&',"-",tm.yy USING '<<<<',"/" ,tm.em USING'&&' 
#FUN-CA0132--add--end
    CALL cl_xg_view()    ###XtraGrid###
   ELSE
      CALL cl_err('','agl-049',1)
   END IF
#TQC-AB0194--add--end--
   #No.FUN-750129  --End  
END FUNCTION
 
#No.FUN-750129  --Begin
#REPORT aglx900_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-680098   VARCHAR(1)
#          sr  RECORD
#                name1   LIKE  aah_file.aah01,
#                name2   LIKE  aah_file.aah01,
#                name3   LIKE  aah_file.aah04,
#                name4   LIKE  aah_file.aah04,
#                name5   LIKE  aah_file.aah04
#              END RECORD,
#      l_cnt     LIKE type_file.num5,          #No.FUN-680098  SMALLINT
#      l_first   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)   
#      l_n       LIKE type_file.num5,          #No.FUN-680098  SMALLINT
#      l_sql     LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(200)
#      g_head1   STRING,
#      l_str     STRING
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.name1
#  FORMAT
#
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[31] CLIPPED,
#                    tm.yy USING '<<<<','/',tm.bm USING'&&','-',
#                    tm.yy USING '<<<<','/',tm.em USING'&&'
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1,g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#      LET l_first = 'Y'
#
#   BEFORE GROUP OF sr.name1
#        LET l_first = 'Y'
#
#   ON EVERY ROW
#      IF l_first = 'Y' THEN
#         CASE
#            WHEN sr.name1 = '1'
#                 LET l_str = sr.name1 USING '#',' ',g_x[15]
#                 PRINT COLUMN g_c[33],l_str,
#                       COLUMN g_c[34],sr.name2 CLIPPED,
#                       COLUMN g_c[35],g_x[16] CLIPPED,
#                       COLUMN g_c[36],cl_numfor(sr.name3,36,t_azi04),    #No.CHI-6A0004 g_azi-->t_azi
#                       COLUMN g_c[37],g_x[17] CLIPPED,
#                       COLUMN g_c[38],cl_numfor(sr.name4,38,t_azi04)       #No.CHI-6A0004 g_azi-->t_azi
#            WHEN sr.name1 = '2'
#                 LET l_str = sr.name1 USING '#',' ',g_x[15]
#                 PRINT COLUMN g_c[33],l_str,
#                       COLUMN g_c[34],sr.name2 CLIPPED,
#                       COLUMN g_c[35],g_x[19] CLIPPED,
#                       COLUMN g_c[36],cl_numfor(sr.name3,36,t_azi04),      #No.CHI-6A0004 g_azi-->t_azi
#                       COLUMN g_c[37],g_x[20] CLIPPED,
#                       COLUMN g_c[38],cl_numfor(sr.name4,38,t_azi04)       #No.CHI-6A0004 g_azi-->t_azi
#            WHEN sr.name1 = '3'
#                 LET l_str = sr.name1 USING '#',' ',g_x[21]
#                 PRINT COLUMN g_c[33],l_str,
#                       COLUMN g_c[34],sr.name2 CLIPPED,
#                       COLUMN g_c[35],g_x[22] CLIPPED,
#                       COLUMN g_c[36],cl_numfor(sr.name3,36,t_azi04),      #No.CHI-6A0004 g_azi-->t_azi
#                       COLUMN g_c[37],g_x[23] CLIPPED,
#                       COLUMN g_c[38],cl_numfor(sr.name4,38,t_azi04)        #No.CHI-6A0004 g_azi-->t_azi
#            WHEN sr.name1 = '4'
#                 LET l_str = sr.name1 USING '#',' ',g_x[21]
#                 PRINT COLUMN g_c[33],l_str,
#                       COLUMN g_c[34],sr.name2 CLIPPED,
#                       COLUMN g_c[35],g_x[24] CLIPPED,
#                       COLUMN g_c[36],cl_numfor(sr.name3,36,t_azi04),        #No.CHI-6A0004 g_azi-->t_azi
#                       COLUMN g_c[37],g_x[25] CLIPPED,
#                       COLUMN g_c[38],cl_numfor(sr.name4,38,t_azi04)         #No.CHI-6A0004 g_azi-->t_azi
#            WHEN sr.name1 = '5'
#                 IF sr.name3 = '0' THEN
#                    LET l_str = sr.name1 USING '#',' ',g_x[30]
#                    PRINT COLUMN g_c[33],l_str,
#                          COLUMN g_c[34],sr.name2 CLIPPED,
#                          COLUMN g_c[35],g_x[18] CLIPPED
#                 ELSE
#                    LET l_str = sr.name1 USING '#',' ',g_x[29]
#                    PRINT COLUMN g_c[33],l_str,
#                          COLUMN g_c[34],sr.name2 CLIPPED,
#                          COLUMN g_c[35],g_x[32] CLIPPED
#                 END IF
#         END CASE
#      END IF
#     IF l_first = 'N' THEN
#        IF sr.name1 = '1' OR sr.name1 = '2' OR sr.name1 = '3'
#           OR sr.name1 = '4'  THEN
#           PRINT COLUMN g_c[34],sr.name2 CLIPPED,
#                 COLUMN g_c[36],cl_numfor(sr.name3,36,t_azi04),           #No.CHI-6A0004 g_azi-->t_azi
#                 COLUMN g_c[38],cl_numfor(sr.name4,38,t_azi04)           #No.CHI-6A0004 g_azi-->t_azi
#        END IF
#        IF sr.name1 = '5' THEN
#           IF sr.name3 = '0' THEN
#              LET l_str = '   ',g_x[30]
#              PRINT COLUMN g_c[33],l_str,
#                    COLUMN g_c[34],sr.name2 CLIPPED,
#                    COLUMN g_c[35],g_x[18] CLIPPED
#           ELSE
#              LET l_str = '   ',g_x[29]
#              PRINT COLUMN g_c[33],l_str,
#                    COLUMN g_c[34],sr.name2 CLIPPED,
#                    COLUMN g_c[35],g_x[32] CLIPPED
#           END IF
#        END IF
#     END IF
#     LET l_first = 'N'
#
#   AFTER GROUP OF sr.name1
#      PRINT ' '
#
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-750129  --End  
 
#====(1)檢查統制科目與其明細科目月餘額不相符者=====
FUNCTION aglx900_1()
   DEFINE    l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT        #No.FUN-680098  VARCHAR(600)
          sr    RECORD
                name1   LIKE type_file.chr1,    #No.FUN-680098   VARCHAR(1)
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
           #FUN-CA0132--add--str--
               ,str1    LIKE  type_file.chr1000,
                str2    LIKE  type_file.chr1000,
                str3    LIKE  type_file.chr1000
           #FUN-CA0132--add--end
                END RECORD,
          t     RECORD
                a         LIKE type_file.chr1,    #No.FUN-680098  VARCHAR(1)
                account   LIKE aah_file.aah01,    #No.FUN-680098  VARCHAR(24)
                amt_1     LIKE type_file.num20_6, #No.FUN-680098  dec(20,6) 
                amt_2     LIKE type_file.num20_6, #No.FUN-680098  dec(20,6)
                amt_3     LIKE type_file.num20_6  #No.FUN-680098  dec(20,6) 
                END RECORD
    DEFINE l_aag08  LIKE aag_file.aag08           #No.A116
 
    INITIALIZE t.* TO NULL
    DELETE FROM t;
 
     #No.A116  取得明細所屬統制科目
    DECLARE gglx900_1_1 CURSOR FOR
     SELECT UNIQUE aag08
       FROM aah_file,aag_file
      WHERE aah01 = aag01 AND aag07 = '2'       #明細帳戶
        AND aah00 = tm.bookno      #No.FUN-740020
        AND aag00 = tm.bookno      #No.FUN-740020
        AND aah02 = tm.yy                          #年度
        AND aah03 BETWEEN tm.bm AND tm.em          #期別
    FOREACH gglx900_1_1 INTO l_aag08
       IF STATUS THEN CALL cl_err('gglx900_1_1',STATUS,1) EXIT FOREACH END IF
       IF NOT cl_null(l_aag08) THEN
          DECLARE aglx900_1 CURSOR FOR
           SELECT '1' a, aah01 account,(aah04-aah05) amt_1,0 amt_2,0 amt_3
             FROM aag_file, aah_file
            WHERE aag01 = aah01 AND aag07 = '1'        #統制帳戶
              AND aah00 = tm.bookno                   #No.FUN-740020
              AND aag00 = aah00                       #No.FUN-740020
              AND aah02 = tm.yy                          #年度
              AND aah03 BETWEEN tm.bm AND tm.em          #期別
              AND aah01 = l_aag08                        #統制科目
            UNION ALL
           SELECT '2' a,aag08 account,0 amt_1,(aah04-aah05) amt_2,0 amt_3
             FROM aah_file,aag_file
            WHERE aah01 = aag01 AND aag07 = '2'       #明細帳戶
              AND aah00 = tm.bookno         #No.FUN-740020
              AND aah00 = aag00             #No.FUN-740020
              AND aah02 = tm.yy                          #年度
              AND aah03 BETWEEN tm.bm AND tm.em          #期別
              AND aag08 = l_aag08                        #統制科目
          FOREACH aglx900_1 INTO t.*
             IF STATUS THEN
                CALL cl_err('foreach#1:',STATUS,1) EXIT FOREACH   
             END IF
             INSERT INTO t VALUES(t.*)
             IF STATUS THEN
#               CALL cl_err('ins #1:',STATUS,1) # NO.FUN-660123
                CALL cl_err3("ins","t","","",STATUS,"","ins #1:",1) # NO.FUN-660123
                EXIT FOREACH
             END IF
          END FOREACH
       END IF
    END FOREACH
    #end No.A116
 
     DECLARE aglx900_curs1 CURSOR FOR
         SELECT '1' ,account,SUM(amt_1),SUM(amt_2),0,"","","" #FUN-CA0132 add 3個""
          FROM t
          GROUP BY account
          HAVING SUM(amt_1) != SUM(amt_2)
     FOREACH aglx900_curs1 INTO sr.*
        IF STATUS THEN CALL cl_err('for-1:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-750129  --Begin
        #OUTPUT TO REPORT aglx900_rep(sr.*)
        #FUN-CA0132--add--str--
        LET sr.str1='1','  ',cl_gr_getmsg('gre-217',g_lang,'1')
        LET sr.str2=cl_gr_getmsg('gre-218',g_lang,'1')
        LET sr.str3=cl_gr_getmsg('gre-219',g_lang,'1')
        #FUN-CA0132--add--end
        EXECUTE insert_prep 
                USING sr.name1,sr.name2,sr.name3,sr.name4
                     ,sr.str1,sr.str2,sr.str3,t_azi04   #FUN-CA0132 add 
        #No.FUN-750129  --End  
        LET g_cnt = g_cnt + 1 #TQC-AB0194
     END FOREACH
END FUNCTION
 
#=====(2)檢查統制科目與其明細科目日餘額不相符者=====
FUNCTION aglx900_2()
   DEFINE    l_sql 	LIKE type_file.chr1000,	       # RDSQL STATEMENT #No.FUN-680098  VARCHAR(600)
          sr    RECORD
                name1   LIKE type_file.chr1,           #No.FUN-680098     VARCHAR(1)
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
           #FUN-CA0132--add--str--
               ,str1    LIKE  type_file.chr1000,
                str2    LIKE  type_file.chr1000,
                str3    LIKE  type_file.chr1000
           #FUN-CA0132--add--end
                END RECORD,
          t     RECORD
                a         LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(1)
                account   LIKE aah_file.aah01,           #No.FUN-680098  VARCHAR(24)
                amt_1     LIKE type_file.num20_6,        #No.FUN-680098  dec(20,6)  
                amt_2     LIKE type_file.num20_6,        #No.FUN-680098  dec(20,6)
                amt_3     LIKE type_file.num20_6         #No.FUN-680098  dec(20,6)
                END RECORD
 
    INITIALIZE t.* TO NULL
    DELETE FROM t;
 
   DECLARE aglx900_2 CURSOR FOR
   SELECT '1' a, aas01 account,(aas04-aas05) amt_1,0 amt_2,0 amt_3
          FROM aag_file, aas_file
          WHERE aag01 = aas01 AND aag07 = '1'        #統制帳戶
            AND aas00 = tm.bookno          #No.FUN-740020
            AND aas00 = aag00              #No.FUN-740020
            AND aas02 BETWEEN m_bdate1 AND m_edate2    #期別
   UNION ALL
   SELECT '2' a,aag08 account,0 amt_1,(aas04-aas05) amt_2,0 amt_3
          FROM aas_file,aag_file
          WHERE aas01 = aag01 AND aag07 = '2'
            AND aas00 = tm.bookno          #No.FUN-740020
            AND aas00 = aag00              #No.FUN-740020
            AND aas02 BETWEEN m_bdate1 AND m_edate2
    FOREACH aglx900_2 INTO t.*
      IF STATUS THEN CALL cl_err('foreach#2:',STATUS,1) EXIT FOREACH END IF
      INSERT INTO t VALUES(t.*)
      IF STATUS THEN 
#        CALL cl_err('ins #2:',STATUS,1) # NO.FUN-660123
         CALL cl_err3("ins","t","","",STATUS,"","ins #2:",1) # NO.FUN-660123    
         EXIT FOREACH
      END IF
    END FOREACH
 
   DECLARE aglx900_curs2 CURSOR FOR
      SELECT '2' ,account,SUM(amt_1),SUM(amt_2),0,"","","" #FUN-CA0132 add 3個""
          FROM t
          GROUP BY account
          HAVING SUM(amt_1) != SUM(amt_2)
 
   FOREACH aglx900_curs2 INTO sr.*
        IF STATUS THEN CALL cl_err('for-2:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-750129  --Begin
        #OUTPUT TO REPORT aglx900_rep(sr.*)
        #FUN-CA0132--add--str--
        LET sr.str1='2','  ',cl_gr_getmsg('gre-217',g_lang,'1')
        LET sr.str2=cl_gr_getmsg('gre-218',g_lang,'2')
        LET sr.str3=cl_gr_getmsg('gre-219',g_lang,'2')
        #FUN-CA0132--add--end
        EXECUTE insert_prep 
                USING sr.name1,sr.name2,sr.name3,sr.name4
                   ,sr.str1,sr.str2,sr.str3,t_azi04   #FUN-CA0132 add
        #No.FUN-750129  --End  
        LET g_cnt = g_cnt + 1 #TQC-AB0194
   END FOREACH
END FUNCTION
 
#======(3)檢查科目月餘額與傳票不相符者=====
FUNCTION aglx900_3()
   DEFINE    l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT    #No.FUN-680098  VARCHAR(600)
          sr    RECORD
                name1   LIKE type_file.chr1,    #No.FUN-680098   VARCHAR(1)
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
        #FUN-CA0132--add--str--
               ,str1    LIKE  type_file.chr1000,
                str2   LIKE  type_file.chr1000,
                str3   LIKE  type_file.chr1000
           #FUN-CA0132--add--end
                END RECORD
 
    INITIALIZE temp.* TO NULL
    DELETE FROM s;
    DECLARE aglx900_3 CURSOR FOR
    SELECT abb03,SUM(abb07) ,0 ,0 ,0
           FROM aba_file,abb_file
           WHERE aba03 = tm.yy AND aba04 BETWEEN tm.bm AND tm.em
             AND aba00 = tm.bookno AND aba00=abb00 AND aba01 = abb01   #No.FUN-740020
             AND abb06 = '1' AND abapost= 'Y'
           GROUP BY abb03,0,0,0
    UNION
    SELECT abb03,0,SUM(abb07),0,0
           FROM aba_file,abb_file
           WHERE aba03 = tm.yy AND aba04 BETWEEN tm.bm AND tm.em
             AND aba00 = tm.bookno AND aba00=abb00 AND aba01 = abb01   #No.FUN-740020
             AND abb06 = '2' AND abapost= 'Y'
           GROUP BY abb03,0,0,0
    UNION
    SELECT aah01,0,0,SUM(aah04),SUM(aah05)
           FROM aah_file,aag_file
           WHERE aah02 = tm.yy AND aah03 BETWEEN tm.bm AND tm.em
             AND aah00 = tm.bookno AND aah01 = aag01 AND aag07 IN ('2','3')    #No.FUN-740020
             AND aah00 = aag00   #No.FUN-740020
            GROUP BY aah01,0,0
    FOREACH aglx900_3 INTO temp.*
      IF STATUS THEN CALL cl_err('foreach#3:',STATUS,1) EXIT FOREACH END IF
      INSERT INTO s VALUES(temp.*)
      IF STATUS THEN 
#        CALL cl_err('ins #3:',STATUS,1) # NO.FUN-660123 
         CALL cl_err3("ins","s","","",STATUS,"","ins #3:",1) # NO.FUN-660123
         EXIT FOREACH
      END IF
    END FOREACH
 
    DROP TABLE y
    SELECT account,SUM(d1-c1) amt_1,SUM(d2-c2) amt_2
           FROM s GROUP BY account INTO temp y
 
    DECLARE aglx900_curs3 CURSOR FOR
      SELECT '3',account,amt_1,amt_2,0,"","","" #FUN-CA0132 add 3個""
          FROM y
          WHERE amt_1 != amt_2
 
    FOREACH aglx900_curs3 INTO sr.*
        IF STATUS THEN CALL cl_err('for-3:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-750129  --Begin
        #OUTPUT TO REPORT aglx900_rep(sr.*)
        #FUN-CA0132--add--str--
        LET sr.str1='3','  ',cl_gr_getmsg('gre-217',g_lang,'2')
        LET sr.str2=cl_gr_getmsg('gre-218',g_lang,'3')
        LET sr.str3=cl_gr_getmsg('gre-219',g_lang,'3')
        #FUN-CA0132--add--end
        EXECUTE insert_prep 
                USING sr.name1,sr.name2,sr.name3,sr.name4
                     ,sr.str1,sr.str2,sr.str3,t_azi04   #FUN-CA0132 add
        #No.FUN-750129  --End  
        LET g_cnt = g_cnt + 1 #TQC-AB0194
   END FOREACH
 
END FUNCTION
 
#====== (4)檢查科目日餘額與傳票不相符者=====
FUNCTION aglx900_4()
   DEFINE    l_sql LIKE type_file.chr1000,	# RDSQL STATEMENT        #No.FUN-680098   VARCHAR(600) 
          sr    RECORD
                name1   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
          #FUN-CA0132--add--str--
               ,str1    LIKE  type_file.chr1000,
                str2    LIKE  type_file.chr1000,
                str3    LIKE  type_file.chr1000
           #FUN-CA0132--add--end
                END RECORD
 
    INITIALIZE temp.* TO NULL
    DELETE FROM s;
    DECLARE aglx900_4 CURSOR FOR
    SELECT abb03,SUM(abb07) ,0 ,0 ,0
           FROM aba_file,abb_file
           WHERE aba03 = tm.yy AND aba04 BETWEEN tm.bm AND tm.em
             AND aba00 = tm.bookno AND aba00=abb00 AND aba01 = abb01   #No.FUN-740020
             AND abb06 = '1' AND abapost= 'Y'
           GROUP BY abb03,0,0,0
    UNION
    SELECT abb03,0,SUM(abb07),0,0
           FROM aba_file,abb_file
           WHERE aba03 = tm.yy AND aba04 BETWEEN tm.bm AND tm.em
             AND aba00 = tm.bookno AND aba00=abb00 AND aba01 = abb01    #No.FUN-740020
             AND abb06 = '2' AND abapost= 'Y'
           GROUP BY abb03,0,0,0
    UNION
    SELECT aas01,0,0,SUM(aas04),SUM(aas05)
           FROM aas_file,aag_file
           WHERE aas02 BETWEEN m_bdate1 AND m_edate2    #期別
             AND aas00 = tm.bookno AND aas01 = aag01 AND aag07 IN ('2','3')   #No.FUN-740020
             AND aas00 = aag00    #No.FUN-740020
           GROUP BY aas01,0,0
    FOREACH aglx900_4 INTO temp.*
      IF STATUS THEN CALL cl_err('foreach#4:',STATUS,1) EXIT FOREACH END IF
      INSERT INTO s VALUES(temp.*)
      IF STATUS THEN 
#        CALL cl_err('ins #4:',STATUS,1) # NO.FUN-660123 
         CALL cl_err3("ins","s","","",STATUS,"","ins #4:",1) # NO.FUN-660123 
         EXIT FOREACH
      END IF
    END FOREACH
 
    DROP TABLE y
    SELECT account,SUM(d1-c1) amt_1,SUM(d2-c2) amt_2
           FROM s GROUP BY account INTO temp y
 
    DECLARE aglx900_curs4 CURSOR FOR
      SELECT '4',account,amt_1,amt_2,0,"","","" #FUN-CA0132 add 3個""
          FROM y
          WHERE amt_1 != amt_2
 
    FOREACH aglx900_curs4 INTO sr.*
        IF STATUS THEN CALL cl_err('for-4:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-750129  --Begin
        #OUTPUT TO REPORT aglx900_rep(sr.*)
        #FUN-CA0132--add--str--
        LET sr.str1='4','  ',cl_gr_getmsg('gre-217',g_lang,'2')
        LET sr.str2=cl_gr_getmsg('gre-218',g_lang,'4')
        LET sr.str3=cl_gr_getmsg('gre-219',g_lang,'4')
        #FUN-CA0132--add--end
        EXECUTE insert_prep 
                USING sr.name1,sr.name2,sr.name3,sr.name4
                     ,sr.str1,sr.str2,sr.str3,t_azi04   #FUN-CA0132 add
        #No.FUN-750129  --End  
        LET g_cnt = g_cnt + 1 #TQC-AB0194
   END FOREACH
 
END FUNCTION
 
#=======(5)檢查分類帳與傳票不相符者=====
FUNCTION aglx900_5()
   DEFINE    l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT        #No.FUN-680098  VARCHAR(600)
          sr    RECORD
                name1   LIKE type_file.chr1,           #No.FUN-680098  VARCHAR(1)
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
           #FUN-CA0132--add--str--
               ,str1    LIKE  type_file.chr1000,
                str2    LIKE  type_file.chr1000,
                str3    LIKE  type_file.chr1000
           #FUN-CA0132--add--end
                END RECORD,
          v     RECORD
                a   LIKE type_file.num5,           #No.FUN-680098 smallint
                b   LIKE aba_file.aba01            #No.FUN-680098  VARCHAR(12)
                END RECORD
 
    INITIALIZE v.* TO NULL
    DELETE FROM v;
    DECLARE aglx900_5 CURSOR FOR
     SELECT 0 a, aba01 b FROM aba_file               #有傳票無分類帳
            WHERE aba00 = tm.bookno AND aba03 = tm.yy   #No.FUN-740020
            AND aba04 BETWEEN tm.bm AND tm.em
            AND abapost IN ('y','Y') AND aba06!='CE'   # 'CE'類不產生分類帳
            AND aba01 NOT IN (SELECT aea03 FROM aea_file )
            GROUP BY aba01
     UNION ALL
     SELECT 1 a,aea03 b FROM aea_file               #有分類帳無傳票
            WHERE aea00 = tm.bookno
            AND aea02 BETWEEN m_bdate1 AND m_edate2
            AND aea03 NOT IN
               (SELECT aba01 FROM aba_file WHERE abapost IN ('y','Y') )
            GROUP BY aea03
    FOREACH aglx900_5 INTO v.*
      IF STATUS THEN CALL cl_err('foreach#5:',STATUS,1) EXIT FOREACH END IF
      INSERT INTO v VALUES(v.*)
      IF STATUS THEN
#        CALL cl_err('ins #5:',STATUS,1) # NO.FUN-660123
         CALL cl_err3("ins","v","","",STATUS,"","ins #5:",1) # NO.FUN-660123  
         EXIT FOREACH
      END IF
    END FOREACH
 
     DECLARE aglx900_curs6 CURSOR FOR
        SELECT '5' , b, a,0,0,"","","" #FUN-CA0132 add 3個""
            FROM v
            GROUP BY b,a
 
     FOREACH aglx900_curs6 INTO sr.*
        IF STATUS THEN CALL cl_err('for-5:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-750129  --Begin
        #OUTPUT TO REPORT aglx900_rep(sr.*)
        #FUN-CA0132--add--str--
        IF sr.name3=0 THEN
           LET sr.str1='5','  ',cl_gr_getmsg('gre-217',g_lang,'3')
           LET sr.str2=cl_gr_getmsg('gre-218',g_lang,'5')
        ELSE
           LET sr.str1='5','  ',cl_gr_getmsg('gre-217',g_lang,'4')
           LET sr.str2=cl_gr_getmsg('agl-283',g_lang,'6')
        END IF
        #FUN-CA0132--add--end
        EXECUTE insert_prep 
                USING sr.name1,sr.name2,sr.name3,sr.name4
                     ,sr.str1,sr.str2,sr.str3,t_azi04   #FUN-CA0132 add
        #No.FUN-750129  --End  
        LET g_cnt = g_cnt + 1 #TQC-AB0194
     END FOREACH
 
END FUNCTION
 
FUNCTION temp_t()
   DROP TABLE t
#FUN-680098-BEGIN
   CREATE TEMP TABLE t(
      a      LIKE type_file.chr1,  
    account  LIKE aab_file.aab01,
    amt_1    LIKE type_file.num20_6,
    amt_2    LIKE type_file.num20_6,
    amt_3    LIKE type_file.num20_6);
#FUN-680098- END   
END FUNCTION
 
FUNCTION temp_s()
   DROP TABLE s
#FUN-680098-BEGIN
   CREATE TEMP TABLE s(
    account  LIKE aab_file.aab01,
    d1       LIKE type_file.num20_6,
    c1       LIKE type_file.num20_6,
    d2       LIKE type_file.num20_6,
    c2       LIKE type_file.num20_6);
#FUN-680098-END   
END FUNCTION
 
FUNCTION temp_v()
   DROP TABLE v
#FUN-680098-BEGIN
   CREATE TEMP TABLE v(
    a   LIKE type_file.num5,  
    b   LIKE type_file.chr1000);
#FUN-680098-EDN   
END FUNCTION
#No.MOD-5B0097  --begin
#====(1.2)大陸版時檢查統制科目與其明細科目月餘額不相符者=====
FUNCTION aglx900_1_2()
   DEFINE    l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(600)
          sr    RECORD
                name1   LIKE type_file.chr1,       #No.FUN-680098  VARCHAR(1)
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
            #FUN-CA0132--add--str--
               ,str1    LIKE  type_file.chr1000,
                str2    LIKE  type_file.chr1000,
                str3    LIKE  type_file.chr1000
           #FUN-CA0132--add--end
                END RECORD,
          t     RECORD
                a         LIKE type_file.chr1,           #No.FUN-680098    VARCHAR(1)
                account   LIKE aah_file.aah01,           #No.FUN-680098    VARCHAR(24)
                amt_1     LIKE type_file.num20_6,        #No.FUN-680098    dec(20,6)
                amt_2     LIKE type_file.num20_6,        #No.FUN-680098    dec(20,6)
                amt_3     LIKE type_file.num20_6         #No.FUN-680098    dec(20,6)
                END RECORD
    DEFINE l_aag08  LIKE aag_file.aag08           #No.A116
 
    INITIALIZE t.* TO NULL
    DELETE FROM t;
 
     #No.A116  取得明細所屬統制科目
    DECLARE gglx900_1_1_2 CURSOR FOR
     SELECT UNIQUE aag08
       FROM aah_file,aag_file
      WHERE aah01 = aag01 AND aag07 = '2'       #明細帳戶
        AND aah00 = tm.bookno                  #No.FUN-740020
        AND aah00 = aag00                      #No.FUN-740020
        AND aah02 = tm.yy                          #年度
        AND aah03 BETWEEN tm.bm AND tm.em          #期別
     UNION
     SELECT UNIQUE aag08
       FROM aah_file,aag_file
      WHERE aah01 = aag01 AND aag07 = '1'       #統治科目
        AND aag24 <> 1                          #中間層的統治科目
        AND aah00 = tm.bookno                    #No.FUN-740020 
        AND aah00 = aag00                        #No.FUN-740020 
        AND aah02 = tm.yy                          #年度
        AND aah03 BETWEEN tm.bm AND tm.em          #期別
    FOREACH gglx900_1_1_2 INTO l_aag08
       IF STATUS THEN CALL cl_err('gglx900_1_1_2',STATUS,1) EXIT FOREACH END IF
       IF NOT cl_null(l_aag08) THEN
          DECLARE aglx900_1_2 CURSOR FOR
           SELECT '1' a, aah01 account,(aah04-aah05) amt_1,0 amt_2,0 amt_3
             FROM aag_file, aah_file
            WHERE aag01 = aah01 AND aag07 = '1'        #統制帳戶
              AND aah00 = tm.bookno                      #No.FUN-740020                  
              AND aah00 = aag00                          #No.FUN-740020 
              AND aah02 = tm.yy                          #年度
              AND aah03 BETWEEN tm.bm AND tm.em          #期別
              AND aah01 = l_aag08                        #統制科目
            UNION ALL
           SELECT '2' a,aag08 account,0 amt_1,(aah04-aah05) amt_2,0 amt_3
             FROM aah_file,aag_file
            WHERE aah01 = aag01 AND aag07 = '2'       #明細帳戶
              AND aah00 = tm.bookno                      #No.FUN-740020 
              AND aah00 = aag00                          #No.FUN-740020 
              AND aah02 = tm.yy                          #年度
              AND aah03 BETWEEN tm.bm AND tm.em          #期別
              AND aag08 = l_aag08                        #統制科目
            UNION ALL
           SELECT '2' a,aag08 account,0 amt_1,(aah04-aah05) amt_2,0 amt_3
             FROM aah_file,aag_file
            WHERE aah01 = aag01 AND aag07 = '1'       #統治科目
              AND aag24 <> 1
              AND aah00 = tm.bookno                      #No.FUN-740020
              AND aah00 = aag00                          #No.FUN-740020
              AND aah02 = tm.yy                          #年度
              AND aah03 BETWEEN tm.bm AND tm.em          #期別
              AND aag08 = l_aag08                        #統制科目
          FOREACH aglx900_1_2 INTO t.*
             IF STATUS THEN
                CALL cl_err('foreach#1_2:',STATUS,1) EXIT FOREACH   
             END IF
             INSERT INTO t VALUES(t.*)
             IF STATUS THEN
#               CALL cl_err('ins #1_2:',STATUS,1) # NO.FUN-660123
                CALL cl_err3("ins","t","","",STATUS,"","ins #1_2:",1)# NO.FUN-660123
                EXIT FOREACH
             END IF
          END FOREACH
       END IF
    END FOREACH
    #end No.A116
 
     DECLARE aglx900_curs1_2 CURSOR FOR
         SELECT '1' ,account,SUM(amt_1),SUM(amt_2),0,"","","" #FUN-CA0132 add 3個""
          FROM t
          GROUP BY account
          HAVING SUM(amt_1) != SUM(amt_2)
     FOREACH aglx900_curs1_2 INTO sr.*
        IF STATUS THEN CALL cl_err('for-1_2:',STATUS,1) EXIT FOREACH END IF
           #No.FUN-750129  --Begin
           #OUTPUT TO REPORT aglx900_rep(sr.*)
           #FUN-CA0132--add--str--
           LET sr.str1='1','  ',cl_gr_getmsg('gre-217',g_lang,'1')
           LET sr.str2=cl_gr_getmsg('gre-218',g_lang,'1')
           LET sr.str3=cl_gr_getmsg('gre-219',g_lang,'1')
           #FUN-CA0132--add--end
           EXECUTE insert_prep 
                   USING sr.name1,sr.name2,sr.name3,sr.name4
                        ,sr.str1,sr.str2,sr.str3,t_azi04   #FUN-CA0132 add 
           #No.FUN-750129  --End  
           LET g_cnt = g_cnt + 1 #TQC-AB0194
     END FOREACH
END FUNCTION
 
#=====(2.2)大陸版時檢查統制科目與其明細科目日餘額不相符者=====
FUNCTION aglx900_2_2()
   DEFINE    l_sql      LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(600)
          sr    RECORD
                name1   LIKE type_file.chr1,        #No.FUN-680098   VARCHAR(1)     
                name2   LIKE  aah_file.aah01,
                name3   LIKE  aah_file.aah04,
                name4   LIKE  aah_file.aah04,
                name5   LIKE  aah_file.aah04
          #FUN-CA0132--add--str--
               ,str1    LIKE  type_file.chr1000,
                str2    LIKE  type_file.chr1000,
                str3    LIKE  type_file.chr1000
           #FUN-CA0132--add--end
                END RECORD,
          t     RECORD
                a         LIKE type_file.chr1,    #No.FUN-680098    VARCHAR(1)
                account   LIKE aah_file.aah01,    #No.FUN-680098    VARCHAR(24)
                amt_1     LIKE type_file.num20_6,  #No.FUN-680098    dec(20,6)
                amt_2     LIKE type_file.num20_6,  #No.FUN-680098    dec(20,6)
                amt_3     LIKE type_file.num20_6   #No.FUN-680098    dec(20,6)
                END RECORD
 
    INITIALIZE t.* TO NULL
    DELETE FROM t;
 
   DECLARE aglx900_2_2 CURSOR FOR
   SELECT '1' a, aas01 account,(aas04-aas05) amt_1,0 amt_2,0 amt_3
          FROM aag_file, aas_file
          WHERE aag01 = aas01 AND aag07 = '1'        #統制帳戶
            AND aas00 = tm.bookno                    #No.FUN-740020 
            AND aas00 = aag00                        #No.FUN-740020 
            AND aas02 BETWEEN m_bdate1 AND m_edate2    #期別
   UNION ALL
   SELECT '2' a,aag08 account,0 amt_1,(aas04-aas05) amt_2,0 amt_3
          FROM aas_file,aag_file
          WHERE aas01 = aag01 AND aag07 = '2'
            AND aas00 = tm.bookno               #No.FUN-740020 
            AND aas00 = aag00                   #No.FUN-740020 
            AND aas02 BETWEEN m_bdate1 AND m_edate2
   UNION ALL
   SELECT '2' a,aag08 account,0 amt_1,(aas04-aas05) amt_2,0 amt_3
          FROM aas_file,aag_file
          WHERE aas01 = aag01 AND aag07 = '1'
            AND aag24 <> 1
            AND aas00 = tm.bookno      #No.FUN-740020
            AND aas00 = aag00          #No.FUN-740020
            AND aas02 BETWEEN m_bdate1 AND m_edate2
    FOREACH aglx900_2_2 INTO t.*
      IF STATUS THEN CALL cl_err('foreach#2_2:',STATUS,1) EXIT FOREACH END IF
      INSERT INTO t VALUES(t.*)
      IF STATUS THEN
#        CALL cl_err('ins #2_2:',STATUS,1) # NO.FUN-660123
         CALL cl_err3("ins","t","","",STATUS,"","ins #2_2:",1) # NO.FUN-660123
         EXIT FOREACH END IF
    END FOREACH
 
   DECLARE aglx900_curs2_2 CURSOR FOR
      SELECT '2' ,account,SUM(amt_1),SUM(amt_2),0,"","","" #FUN-CA0132 add 3個""
          FROM t
          GROUP BY account
          HAVING SUM(amt_1) != SUM(amt_2)
 
   FOREACH aglx900_curs2_2 INTO sr.*
        IF STATUS THEN CALL cl_err('for-2_2:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-750129  --Begin
        #OUTPUT TO REPORT aglx900_rep(sr.*)
        #FUN-CA0132--add--str--
        LET sr.str1='2','  ',cl_gr_getmsg('gre-217',g_lang,'1')
        LET sr.str2=cl_gr_getmsg('gre-218',g_lang,'2')
        LET sr.str3=cl_gr_getmsg('gre-219',g_lang,'2')
        #FUN-CA0132--add--end
        EXECUTE insert_prep 
                USING sr.name1,sr.name2,sr.name3,sr.name4
                     ,sr.str1,sr.str2,sr.str3,t_azi04   #FUN-CA0132 add
        #No.FUN-750129  --End  
        LET g_cnt = g_cnt + 1 #TQC-AB0194
   END FOREACH
END FUNCTION
#No.MOD-5B0097  --end
#Patch....NO.TQC-610035 <001> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

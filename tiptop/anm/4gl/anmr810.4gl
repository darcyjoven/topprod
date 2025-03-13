# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr810.4gl
# Descriptions...: 定期存單明細表
# Date & Author..: 99/06/30 by patricia
# Modify.........: No.FUN-4C0098 05/01/05 By pengu 報表轉XML
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.MOD-670080 06/07/18 By Smapmin 排序有問題
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: NO.FUN-7A0036 07/11/09 By zhaijie改報表輸出為Crystal Report
# Modify.........: No.FUN-820022 08/04/16 By Smapmin 增加小計功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
           #  wc      VARCHAR(600),                 # Where condition
              wc      STRING,  #TQC-630166       # Where condition
              s       LIKE type_file.chr2,       #No.FUN-680107 VARCHAR(2)
              u       LIKE type_file.chr2,       #FUN-820022
              t       LIKE type_file.chr2,       #No.FUN-680107 VARCHAR(2)
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5        #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
DEFINE   l_table      STRING                     #NO.FUN-7A0036
DEFINE   g_str        STRING                     #NO.FUN-7A0036
DEFINE   g_sql        STRING                     #NO.FUN-7A0036
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#NO.FUN-7A0036---------start----------
   LET g_sql = "gxf011.gxf_file.gxf011,",
               "gxf01.gxf_file.gxf01,", 
               "gxf02.gxf_file.gxf02,",
               "gxf03.gxf_file.gxf03,",
               "gxf04.gxf_file.gxf04,",
               "gxf05.gxf_file.gxf05,",
               "gxf06.gxf_file.gxf06,",
               "gxf08.gxf_file.gxf08,",
               "gxf09.gxf_file.gxf09,",
               "gxf11.gxf_file.gxf11,",
               "gxf10.gxf_file.gxf10,",
               "gxf24.gxf_file.gxf24,",
               "gxf021.gxf_file.gxf021,",
               "l_nma02.nma_file.nma02,",
               "l_gxf04desc.type_file.chr8,",
               "l_gxf11desc.type_file.chr8,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('anmr810',g_sql) CLIPPED
   IF  l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7A0036------end-------
 
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)   #MOD-820022
   #-----END TQC-610058-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc)
      THEN CALL anmr810_tm(0,0)             # Input print condition
      ELSE CALL anmr810()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
 
FUNCTION anmr810_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,  #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000#No.FUN-680107 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW anmr810_w AT p_row,p_col
        WITH FORM "anm/42f/anmr810"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.s    = '12'
   LET tm.t    = '  '
   LET tm.u    = '  '   #MOD-820022
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]   #MOD-820022
   LET tm2.u2   = tm.u[2,2]   #MOD-820022
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF   #MOD-820022
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF   #MOD-820022
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON gxf02,gxf03,gxf05,gxf11,gxf08
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,   #MOD-820022
                 tm.more
         WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
      LET tm.u = tm2.u1,tm2.u2   #MOD-820022
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr810'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr810','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.t CLIPPED,"'" ,
                         " '",tm.u CLIPPED,"'" ,   #MOD-820022
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr810()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr810_w
END FUNCTION
 
FUNCTION anmr810()
DEFINE l_name      LIKE type_file.chr20,              # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time       LIKE type_file.chr8          #No.FUN-6A0082
       l_cmd,l_sql LIKE type_file.chr1000,            #No.FUN-680107 VARCHAR(1200)
       l_za05      LIKE type_file.chr1000,            #No.FUN-680107 VARCHAR(40)
       l_order     ARRAY[4] OF LIKE gxf_file.gxf08,   #No.FUN-680107 ARRAY[4] OF VARCHAR(20)
       sr	   RECORD
                    order1 LIKE gxf_file.gxf08,       #No.FUN-680107 VARCHAR(20)
                    order2 LIKE gxf_file.gxf08,       #No.FUN-680107 VARCHAR(20)
                    gxf011 LIKE gxf_file.gxf011,
                    gxf01  LIKE gxf_file.gxf01,
                    gxf02  LIKE gxf_file.gxf02,
                    gxf03  LIKE gxf_file.gxf03,
                    gxf04  LIKE gxf_file.gxf04,
                    gxf05  LIKE gxf_file.gxf05,
                    gxf06  LIKE gxf_file.gxf06,
                    gxf08  LIKE gxf_file.gxf08,
                    gxf09  LIKE gxf_file.gxf09,
                    gxf11  LIKE gxf_file.gxf11,
                    gxf10  LIKE gxf_file.gxf10,
                    gxf24  LIKE gxf_file.gxf24,
                    gxf021 LIKE gxf_file.gxf021
                  END RECORD
DEFINE  l_gxf04desc,l_gxf11desc  LIKE type_file.chr8    #No.FUN-680107 VARCHAR(8)
DEFINE  l_nma02    LIKE nma_file.nma02                  #銀行簡稱
     CALL cl_del_data(l_table)                        #NO.FUN-7A0036
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='anmr810'  #NO.FUN-7A0036
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND gxfuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND gxfgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND gxfgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gxfuser', 'gxfgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','',gxf011,gxf01,gxf02,gxf03,gxf04,gxf05,gxf06,",
                 " gxf08,gxf09,gxf11,gxf10 ",
                 " ,gxf24,gxf021 ",
                 " FROM gxf_file",
                 " WHERE gxf11 !='3' ",
                 " AND ",tm.wc CLIPPED
     PREPARE anmr810_prepare1 FROM l_sql
     DECLARE anmr810_curs1 CURSOR FOR anmr810_prepare1
 
#     CALL cl_outnam('anmr810') RETURNING l_name
#     START REPORT r810_rep TO l_name
 
     FOREACH anmr810_curs1 INTO  sr.*
      IF SQLCA.sqlcode THEN CALL cl_err('anmr810_curs1',STATUS,1)
        EXIT FOREACH END IF
#NO.FUN-7A0036---------start ----mark------     
{    FOR g_i = 1 TO 2
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.gxf02
               WHEN tm.s[g_i,g_i] = '2'
                    LET l_order[g_i] = sr.gxf03 USING 'YYYYMMDD'
               WHEN tm.s[g_i,g_i] = '3'
                    LET l_order[g_i] = sr.gxf05 USING 'YYYYMMDD'
               WHEN tm.s[g_i,g_i] = '4'   #MOD-670080
                    LET l_order[g_i] = sr.gxf11   #MOD-670080
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.gxf08
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]}
#NO.FUN-7A0036---------end------ mark--------
#NO.FUN-7A0036---------start--------     
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05  #NO.CHI-6A0004 
        FROM azi_file
       WHERE azi01=sr.gxf24
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.gxf02
 
      CALL s_gxf04desc(sr.gxf04) RETURNING l_gxf04desc
      CALL s_gxf11desc(sr.gxf11) RETURNING l_gxf11desc        
      EXECUTE  insert_prep USING
           sr.gxf011,sr.gxf01,sr.gxf02,sr.gxf03,sr.gxf04,sr.gxf05,sr.gxf06,
           sr.gxf08,sr.gxf09,sr.gxf11,sr.gxf10,sr.gxf24,sr.gxf021,
           l_nma02,l_gxf04desc,l_gxf11desc,t_azi04,t_azi05 
#NO.FUN-7A00363-------end----
 
#      OUTPUT TO REPORT r810_rep(sr.*)             #NO.FUN-7A0036--MARK--
 
    END FOREACH
 
#NO.FUN-7A0036-------start------
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF  g_zz05 ='Y' THEN 
       CALL cl_wcchp(tm.wc,'gxf02,gxf03,gxf05,gxf11,gxf08')
         RETURNING tm.wc
     END IF
    LET g_str=tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",
              tm.t[1,1],";",tm.t[2,2],";",t_azi04,";",t_azi05,";",
              tm.u[1,1],";",tm.u[2,2]   #MOD-820022
    CALL cl_prt_cs3('anmr810','anmr810',g_sql,g_str)
#NO.FUN-7A0036---------end---- 
#     FINISH REPORT r810_rep                       #NO.FUN-7A0036
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #NO.FUN-7A0036
END FUNCTION
#NO.FUN-7A0036------mark---start----
{REPORT r810_rep(sr)
   DEFINE    sr	    RECORD
                    order1 LIKE gxf_file.gxf08,     #No.FUN-680107 VARCHAR(20)
                    order2 LIKE gxf_file.gxf08,     #No.FUN-680107 VARCHAR(20)
                    gxf011 LIKE gxf_file.gxf011,
                    gxf01  LIKE gxf_file.gxf01,
                    gxf02  LIKE gxf_file.gxf02,
                    gxf03  LIKE gxf_file.gxf03,
                    gxf04  LIKE gxf_file.gxf04,
                    gxf05  LIKE gxf_file.gxf05,
                    gxf06  LIKE gxf_file.gxf06,
                    gxf08  LIKE gxf_file.gxf08,
                    gxf09  LIKE gxf_file.gxf09,
                    gxf11  LIKE gxf_file.gxf11,
                    gxf10  LIKE gxf_file.gxf10,
                    gxf24  LIKE gxf_file.gxf24,
                    gxf021 LIKE gxf_file.gxf021
                    END RECORD,
          l_gxf04desc,l_gxf11desc  LIKE type_file.chr8,    #No.FUN-680107 VARCHAR(8)
          l_nma02    LIKE nma_file.nma02,                  #銀行簡稱
          l_last_sw  LIKE type_file.chr1                   #No.FUN-680107 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2
  FORMAT
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED,g_x[44] CLIPPED
      PRINT g_dash1
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
 
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05  #NO.CHI-6A0004 
        FROM azi_file
       WHERE azi01=sr.gxf24
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.gxf02
 
      CALL s_gxf04desc(sr.gxf04) RETURNING l_gxf04desc
      CALL s_gxf11desc(sr.gxf11) RETURNING l_gxf11desc
      PRINT COLUMN g_c[31],sr.gxf011,
            COLUMN g_c[32],sr.gxf01,
            COLUMN g_c[33],sr.gxf02 CLIPPED,
            COLUMN g_c[34],l_nma02,
            COLUMN g_c[35],sr.gxf03 CLIPPED,
            COLUMN g_c[36],sr.gxf24  CLIPPED,
            COLUMN g_c[37],cl_numfor(sr.gxf021,37,t_azi04), #NO.CHI-6A0004
            COLUMN g_c[38],l_gxf04desc CLIPPED,
            COLUMN g_c[39],sr.gxf05 CLIPPED,
            #COLUMN g_c[40],sr.gxf06 USING '###&.###&',
            COLUMN g_c[40],sr.gxf06 USING '####&.###&', #No.TQC-5C0051
            COLUMN g_c[41],sr.gxf08 CLIPPED,
            COLUMN g_c[42],cl_numfor(sr.gxf09,42,t_azi04),  #NO.CHI-6A0004
            COLUMN g_c[43],l_gxf11desc CLIPPED,
            COLUMN g_c[44],sr.gxf10 CLIPPED
 
   ON LAST ROW
      IF g_zz05 = 'Y'# (80)-70,140,210,280   /   (132)-120,240,300
        THEN
       PRINT g_dash
  #  IF tm.wc[001,070] > ' ' THEN# for 80
  #    PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
  #  IF tm.wc[071,140] > ' ' THEN
  #     PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
  #  IF tm.wc[141,210] > ' ' THEN
  #     PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
  #  IF tm.wc[211,280] > ' ' THEN
  #      PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
 
      #TQC-630166
      CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash
             PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}
#NO.FUN-7A0036-------end----

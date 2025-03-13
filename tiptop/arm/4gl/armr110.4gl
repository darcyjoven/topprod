# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armr110.4gl
# Descriptions...: INVOICE
# Date & Author..: 98/02/24 by Sunny
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.MOD-530205 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550122 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/17 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-710082 07/03/06 By day 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30139 10/04/08 By Summer 公司名稱與地址等資訊改為抓取p_zo實際資料 
# Modify.........: No:MOD-A30169 10/04/08 By Summer 修正MOD-A30139,p_zo應抓目前語系之資料
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:TQC-C10039 12/01/14 By minpp  CR报表列印TIPTOP与EasyFlow签核图片
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)                # Input more condition
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_str      STRING   
#No.FUN-710082--end  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073    ADD #FUN-BB0047 mark
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc= ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-710082--begin
   LET g_sql ="rme08.rme_file.rme08,",
              "rme04.rme_file.rme04,",
              "occ18.occ_file.occ18,",
              "rme073.rme_file.rme073,",
              "rme074.rme_file.rme074,",
 
              "rme075.rme_file.rme075,",
              "rme011.rme_file.rme011,",
              "rms03.rms_file.rms03,",
              "rms06.rms_file.rms06,",
              "rms061.rms_file.rms061,",
 
              "rms12.rms_file.rms12,",
              "rms13.rms_file.rms13,",
              "rms14.rms_file.rms14,",
              "rms31.rms_file.rms31,",
              "rms33.rms_file.rms33,",
 
              "rms36.rms_file.rms36,",
              "occ29.occ_file.occ29,",
              "occ292.occ_file.occ292,",
              "occ261.occ_file.occ261,",
              "occ271.occ_file.occ271,",
 
              "azi03.azi_file.azi03,",
              "azi04.azi_file.azi04,",
              "azi05.azi_file.azi05,",
              "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
              "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
              "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
 
   LET l_table = cl_prt_temptable('armr110',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?,?,?) "   #TQC-C10039  ADD 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   #No.FUN-710082--end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
           CALL armr110_tm(0,0)             # Input print condition
      ELSE
           CALL armr110()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
END MAIN
 
FUNCTION armr110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW armr110_w AT p_row,p_col
        WITH FORM "arm/42f/armr110"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                        #Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rme01,rme02,rme03,rme08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
               IF INFIELD(rme03) THEN #客戶編號    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rme03
                  NEXT FIELD rme03
               END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW armr110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW armr110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armr110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr110','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('armr110',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armr110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armr110()
   ERROR ""
END WHILE
   CLOSE WINDOW armr110_w
END FUNCTION
 
FUNCTION armr110()
   DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000)
          l_zo      RECORD LIKE zo_file.*,     #MOD-A30139 add
          sr        RECORD
                    rme08       LIKE rme_file.rme08,
                    rme04       LIKE rme_file.rme04,
                    occ18       LIKE occ_file.occ18,
                    rme073      LIKE rme_file.rme073,
                    rme074      LIKE rme_file.rme074,
                    rme075      LIKE rme_file.rme075,
                    rme011      LIKE rme_file.rme011,
                    rms03       LIKE rms_file.rms03,
                    rms06       LIKE rms_file.rms06,
                    rms061      LIKE rms_file.rms061,
                    rms12       LIKE rms_file.rms12,
                    rms13       LIKE rms_file.rms13,
                    rms14       LIKE rms_file.rms14,
                    rms31       LIKE rms_file.rms31,
                    rms33       LIKE rms_file.rms33,
                    rms36       LIKE rms_file.rms36,
                    occ29       LIKE occ_file.occ29,
                    occ292      LIKE occ_file.occ292,
                    occ261      LIKE occ_file.occ261,
                    occ271      LIKE occ_file.occ271
                    END RECORD
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05     #No.CHI-6A0004
          FROM azi_file WHERE azi01 = 'USD'
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
     #End:FUN-980030
 
     LET l_sql="SELECT rme08,rme04,occ18,rme073,rme074,rme075,rme011,",
               "       rms03,rms06,rms061,rms12,rms13,rms14, ",
               "       rms31,rms33,rms36,occ29,occ292,occ261,occ271  ",
               " FROM rme_file,rms_file,OUTER occ_file ",
               " WHERE rme01 = rms01 AND rme_file.rme03=occ_file.occ01",
               "   AND rmeconf <> 'X' ",  #CHI-C80041
               "   AND rmevoid='Y' AND ",tm.wc CLIPPED,
               " ORDER BY rme08,rme04,rms03,rme011  "
 
     PREPARE armr110_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
     END IF
     DECLARE armr110_curs1 CURSOR FOR armr110_prepare1
     #No.FUN-710082--begin
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     CALL cl_del_data(l_table) 
#    CALL cl_outnam('armr110') RETURNING l_name
 
#    START REPORT armr110_rep TO l_name
 
#    LET g_pageno = 0
     FOREACH armr110_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       EXECUTE insert_prep USING sr.*,t_azi03,t_azi04,t_azi05,"",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob, "N",""
#      OUTPUT TO REPORT armr110_rep(sr.*)
     END FOREACH
 
#    FINISH REPORT armr110_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'rme01,rme02,rme03,rme08')  
        RETURNING tm.wc                                                           
     END IF                      
     SELECT * INTO l_zo.* FROM zo_file WHERE zo01=g_rlang   #MOD-A30139 add  #MOD-A30169 mod
     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",
              l_zo.zo12,";",l_zo.zo041,";",l_zo.zo042,";",  #MOD-A30139 add
              l_zo.zo05,";",l_zo.zo09,";", l_zo.zo07        #MOD-A30139 add
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "rme08"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('armr110','armr110',l_sql,l_str)    #FUN-710080 modify
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT armr110_rep(sr)
# DEFINE head1,head2,head3      LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(120)
# DEFINE l_last_sw,sw_first     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
#  DEFINE l_qty LIKE rms_file.rms12 #MOD-530205
#  DEFINE l_amt LIKE rms_file.rms14 #MOD-530205
# DEFINE l_cno  LIKE ima_file.ima26 #No.FUN-690010 DEC(15,3)
# DEFINE l_plt  LIKE ima_file.ima26 #No.FUN-690010 DEC(15,3)
# DEFINE sr                     RECORD
#                               rme08    LIKE rme_file.rme08,
#                               rme04    LIKE rme_file.rme04,
#                               occ18    LIKE occ_file.occ18,
#                               rme073   LIKE rme_file.rme073,
#                               rme074   LIKE rme_file.rme074,
#                               rme075   LIKE rme_file.rme075,
#                               rme011   LIKE rme_file.rme011,
#                               rms03    LIKE rms_file.rms03,
#                               rms06    LIKE rms_file.rms06,
#                               rms061   LIKE rms_file.rms061,
#                               rms12    LIKE rms_file.rms12,
#                               rms13    LIKE rms_file.rms13,
#                               rms14    LIKE rms_file.rms14,
#                               rms31    LIKE rms_file.rms31,
#                               rms33    LIKE rms_file.rms33,
#                               rms36    LIKE rms_file.rms36,
#                               occ29    LIKE occ_file.occ29,
#                               occ292   LIKE occ_file.occ292,
#                               occ261   LIKE occ_file.occ261,
#                               occ271   LIKE occ_file.occ271
#                               END RECORD
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN 5
#        PAGE LENGTH g_page_line
 
# ORDER BY sr.rme08,sr.rme04,sr.rme011,sr.rms31,sr.rms33,sr.rms03
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN 01,g_x[9]
#     PRINT COLUMN 01,g_x[10],COLUMN 41,g_x[11]
#     PRINT COLUMN 01,g_x[12]
#     PRINT ' '
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[13]))/2)+1 ,g_x[13] CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_x[14])-FGL_WIDTH(g_today)-4),
#           g_x[14] CLIPPED," ", g_today CLIPPED
#     PRINT COLUMN 01,g_x[15] CLIPPED," ",sr.rme08
#     PRINT COLUMN 01,g_x[16] CLIPPED," ",sr.occ18
#     PRINT COLUMN 11,sr.rme073
#     PRINT COLUMN 11,sr.rme074
#     PRINT COLUMN 11,sr.rme075
#     PRINT g_x[17] CLIPPED,' ',sr.occ29
#     PRINT g_x[18] CLIPPED,' ',sr.occ261
#     PRINT g_x[19] CLIPPED,' ',sr.occ271
#     PRINT g_dash
##No.FUN-580013 --start--
##     PRINT g_x[20],COLUMN 42,g_x[21],COLUMN 85,g_x[22] CLIPPED
##     PRINT g_dash1[1,g_len]
#     PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36], g_x[37]
#     PRINTX name = H2 g_x[38],g_x[39]
#     PRINT g_dash1
##No.FUN-580013 --end--
#     PRINT g_x[29],COLUMN 117,g_x[30] CLIPPED
 
#     LET l_last_sw = 'n'
 
 
#{ AFTER GROUP OF sr.rme08
#     PRINT COLUMN 01,"TOTAL",
#           COLUMN 31,l_qty USING '---,--&'," pcs",
#           COLUMN 58,l_amt USING '-,---,--&.--',
#           COLUMN 73,l_cno USING '-,--&',' ',l_plt USING '-,--&'
#     LET l_qty= GROUP SUM(sr.rms12)
#     LET l_amt= GROUP SUM(sr.rms14)  }
 
#  AFTER GROUP OF sr.rms31
#    IF NOT cl_null(sr.rms31) THEN
#     LET l_plt=l_plt+1
#    END IF
 
#  AFTER GROUP OF sr.rms33
#    IF NOT cl_null(sr.rms33) THEN
#     LET l_cno=l_cno+1
#    END IF
 
#  BEFORE GROUP OF sr.rme08
#     SKIP TO TOP of page
#     LET l_qty =0
#     LET l_amt =0
#     LET l_cno=0
#     LET l_plt=0
 
#  AFTER GROUP OF sr.rme08
#     PRINT g_dash
##No.FUN-580013 --start--
##     PRINT COLUMN 01,"TOTAL",
##           COLUMN 40,l_qty USING '---,--&'," pcs",
##           COLUMN 65,cl_numfor(l_amt,18,g_azi05),
##           COLUMN 81,l_cno USING '-,--&',
##           COLUMN 87,l_plt USING '-,--#'
##     PRINT COLUMN 42,"vvvvvvv",
##           COLUMN 65,"vvvvvvvvvvvvvvvvvvv"
#     PRINT COLUMN g_c[31],"TOTAL",
#           COLUMN g_c[33],l_qty USING '---,--&'," pcs",
#           COLUMN g_c[35],cl_numfor(l_amt,18,t_azi05),   #No.CHI-6A0004
#           COLUMN g_c[36],l_cno USING '-,--&',
#           COLUMN g_c[37],l_plt USING '-,--#'
#     PRINT COLUMN g_c[33],"vvvvvvvvvvv",
#           COLUMN g_c[35],"vvvvvvvvvvvvvvvvvv"
##No.FUN-580013 --end--
#     PRINT ' '
#     PRINT ' '
 
#     PRINT COLUMN 01,g_x[23],g_x[24]
#     PRINT COLUMN 01,g_x[25],g_x[26]
#    #PRINT COLUMN 01,"NO COMMERCIAL VALUE FOR CUSTOM PURPOSE ONLY."
#    #PRINT COLUMN 01,"FREE OF CHARGE FOR REPAIRING RETURNED GOOODS ONLY."
 
#  BEFORE GROUP OF sr.rme011
#     PRINT "RMA NO. ",
#           COLUMN 11,sr.rme011
 
#  ON EVERY ROW
##No.FUN-580013 --start--
##     PRINT COLUMN 01,sr.rms03,
##           COLUMN 38,sr.rms12 USING '---,--&',
##           COLUMN 48,cl_numfor(sr.rms13,15,g_azi03),
##           COLUMN 65,cl_numfor(sr.rms14,18,g_azi04),
##           COLUMN 85,sr.rms33 USING '-,--&',' ',
##           COLUMN 91,sr.rms31 USING '-,--&'
##
##     PRINT COLUMN 01, sr.rms06,' ',sr.rms061
##     PRINT COLUMN 01, sr.rms36
#     PRINTX name = D1
#           COLUMN g_c[31],sr.rms03,
#           COLUMN g_c[32],sr.rms06,
#           COLUMN g_c[33],sr.rms12 USING '---,--&',
#           COLUMN g_c[34],cl_numfor(sr.rms13,15,t_azi03),   #No.CHI-6A0004
#           COLUMN g_c[35],cl_numfor(sr.rms14,18,t_azi04),   #No.CHI-6A0004
#           COLUMN g_c[36],sr.rms33 USING '-,--&',' ',
#           COLUMN g_c[37],sr.rms31 USING '-,--&'
#     PRINTX name = D2
#           COLUMN g_c[39],sr.rms061
##No.FUN-580013 --end--
#     LET l_qty= l_qty + sr.rms12
#     LET l_amt= l_amt + sr.rms14
 
## FUN-550122
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT COLUMN (g_len-FGL_WIDTH(g_x[27] CLIPPED)),g_x[27] CLIPPED
#     SKIP 2 LINE
#     PRINT COLUMN (g_len-FGL_WIDTH(g_x[28] CLIPPED)),g_x[28] CLIPPED
#     #LET l_last_sw = 'y'
#     PRINT ''
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[20]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[20]
#            PRINT g_memo
#     END IF
## END FUN-550122
#END REPORT
##Patch....NO.TQC-610037 <> #
#No.FUN-710082--end  

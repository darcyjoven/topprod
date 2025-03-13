# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: armr105.4gl
# Descriptions...: RMA覆出隨機Packing列印
# Date & Author..: 98/05/06 By Danny
# Modi         ..: 98/06/06 By plum
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-550122 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/18 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-710085 07/03/12 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30139 10/04/07 By Summer 公司名稱與地址等資訊改為抓取p_zo實際資料 
# Modify.........: No:MOD-A30169 10/04/08 By Summer 修正MOD-A30139,p_zo應抓目前語系之資料
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)                # Input more condition
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   l_table         STRING                  #No.FUN-710085
DEFINE   g_sql           STRING                  #No.FUN-710085
DEFINE   g_str           STRING                  #No.FUN-710085
 
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
   #No.FUN-710085 --start--                                                                                                         
   LET g_sql = "rme073.rme_file.rme073,rme074.rme_file.rme074,",
               "rme075.rme_file.rme075,rme08.rme_file.rme08,",
               "rmf03.rmf_file.rmf03,rmf06.rmf_file.rmf06,",
               "rmf061.rmf_file.rmf061,rmf07.rmf_file.rmf07,",
               "rmf22.rmf_file.rmf22,rmf31.rmf_file.rmf31,",
               "rmf32.rmf_file.rmf32,rmf33.rmf_file.rmf33,",
               "rmf34.rmf_file.rmf34,rmf35.rmf_file.rmf35,",
               "occ18.occ_file.occ18,occ261.occ_file.occ261,",
               "occ271.occ_file.occ271,occ29.occ_file.occ29,",
               "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
               "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
               "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

 
   LET l_table = cl_prt_temptable('armr105',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)"  #TQC-C10039 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
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
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      CALL armr105_tm(0,0)             # Input print condition
   ELSE
      CALL armr105()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
END MAIN
 
FUNCTION armr105_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 16
   END IF
   OPEN WINDOW armr105_w AT p_row,p_col
        WITH FORM "arm/42f/armr105"
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
      LET INT_FLAG = 0 CLOSE WINDOW armr105_w
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
      LET INT_FLAG = 0 CLOSE WINDOW armr105_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armr105'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr105','9031',1)
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
         CALL cl_cmdat('armr105',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armr105_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armr105()
   ERROR ""
END WHILE
   CLOSE WINDOW armr105_w
END FUNCTION
 
FUNCTION armr105()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000)
          l_zo      RECORD LIKE zo_file.*,     #MOD-A30139 add
          sr        RECORD
                    rme03       LIKE rme_file.rme03,     #退貨客戶
                    rme04       LIKE rme_file.rme04,     #退貨客戶
                    occ18       LIKE occ_file.occ18,     #退貨客戶全名
                    rme073      LIKE rme_file.rme073,    #送貨地址
                    rme074      LIKE rme_file.rme074,    #送貨地址
                    rme075      LIKE rme_file.rme075,    #送貨地址
                    rme08       LIKE rme_file.rme08,     #Invoice
                    rmf03       LIKE rmf_file.rmf03,     #料件編號
                    rmf06       LIKE rmf_file.rmf06,     #品名
                    rmf061      LIKE rmf_file.rmf061,    #規格
                    rmf07       LIKE rmf_file.rmf07,     #RMA單號
                    rmf22       LIKE rmf_file.rmf22,     #數量
                    rmf31       LIKE rmf_file.rmf31,     #P/NO
                    rmf32       LIKE rmf_file.rmf32,     #palette dimension
                    rmf33       LIKE rmf_file.rmf33,     #C/NO
                    rmf34       LIKE rmf_file.rmf34,     #carton dimension
                    rmf35       LIKE rmf_file.rmf35,     #carton weights
                    occ29       LIKE occ_file.occ29,
                    occ292      LIKE occ_file.occ292,
                    occ261      LIKE occ_file.occ261,
                    occ271      LIKE occ_file.occ271
                    END RECORD
     DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039 
     CALL cl_del_data(l_table)  #No.FUN-710085
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
     LET l_sql="SELECT rme03,rme04,occ18,rme073,rme074,rme075,rme08,rmf03,",
               " rmf06,rmf061,rmf07,rmf22,rmf31,rmf32,rmf33,rmf34,rmf35,",
               " occ29,occ292,occ261,occ271 ",
               "  FROM rme_file,rmf_file,OUTER occ_file ",
               " WHERE rme01 = rmf01 AND rme_file.rme03=occ_file.occ01 ",
               "   AND rmeconf <> 'X' ",  #CHI-C80041
               "   AND rmevoid='Y' AND ",tm.wc CLIPPED
 
     PREPARE armr105_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
     END IF
     DECLARE armr105_curs1 CURSOR FOR armr105_prepare1
#    CALL cl_outnam('armr105') RETURNING l_name  #No.FUN-710085 mark
 
#    START REPORT armr105_rep TO l_name          #No.FUN-710085 mark
 
#    LET g_pageno = 0                            #No.FUN-710085 mark
     FOREACH armr105_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       #No.FUN-710085 --start--
       EXECUTE insert_prep USING sr.rme073,sr.rme074,sr.rme075,
                                 sr.rme08,sr.rmf03,sr.rmf06,
                                 sr.rmf061,sr.rmf07,sr.rmf22,
                                 sr.rmf31,sr.rmf32,sr.rmf33,
                                 sr.rmf34,sr.rmf35,sr.occ18,
                                 sr.occ261,sr.occ271,sr.occ29,
                                 "",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob, "N",""
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT armr105_rep(sr.*)        #No.FUN-710085 mark
     END FOREACH
 
#    FINISH REPORT armr105_rep                   #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #str MOD-A30139 mod
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'rme01,rme02,rme03,rme08')
             RETURNING tm.wc
     END IF
    #end MOD-A30139 mod
     SELECT * INTO l_zo.* FROM zo_file WHERE zo01=g_rlang   #MOD-A30139 add  #MOD-A30169 mod
     LET g_str = tm.wc,";",g_zz05,";",
                 l_zo.zo12,";",l_zo.zo041,";",l_zo.zo042,";",  #MOD-A30139 add
                 l_zo.zo05,";",l_zo.zo09,";", l_zo.zo07        #MOD-A30139 add
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "rme073|rme074|rme075"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('armr105','armr105',l_sql,g_str)   #FUN-710080 modify
     #No.FUN-710085 --end--

#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-710085 mark
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-710085 --start-- mark
{REPORT armr105_rep(sr)
  DEFINE l_last_sw   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
         sr          RECORD
                     rme03       LIKE rme_file.rme03,     #退貨客戶
                     rme04       LIKE rme_file.rme04,     #退貨客戶
                     occ18       LIKE occ_file.occ18,     #退貨客戶全名
                     rme073      LIKE rme_file.rme073,    #送貨地址
                     rme074      LIKE rme_file.rme074,    #送貨地址
                     rme075      LIKE rme_file.rme075,    #送貨地址
                     rme08       LIKE rme_file.rme08,     #Invoice
                     rmf03       LIKE rmf_file.rmf03,     #料件編號
                     rmf06       LIKE rmf_file.rmf06,     #品名
                     rmf061      LIKE rmf_file.rmf061,    #規格
                     rmf07       LIKE rmf_file.rmf07,     #RMA單號
                     rmf22       LIKE rmf_file.rmf22,     #數量
                     rmf31       LIKE rmf_file.rmf31,     #P/NO
                     rmf32       LIKE rmf_file.rmf32,     #palette dimension
                     rmf33       LIKE rmf_file.rmf33,     #C/NO
                     rmf34       LIKE rmf_file.rmf34,     #carton dimension
                     rmf35       LIKE rmf_file.rmf35,     #carton weights
                     occ29       LIKE occ_file.occ29,
                     occ292      LIKE occ_file.occ292,
                     occ261      LIKE occ_file.occ261,
                     occ271      LIKE occ_file.occ271
                     END RECORD,
         l_x         LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40),
         l_i         LIKE type_file.num5,    #No.FUN-690010 SMALLINT
         l_tot1,l_tot2 LIKE rmf_file.rmf31,
         l_qty       LIKE rmf_file.rmf22,
         l_weight    LIKE rmf_file.rmf35
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.rme08,sr.rme04,sr.rmf07,sr.rmf31,sr.rmf33
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN 01,g_x[9]
      PRINT COLUMN 01,g_x[10],g_x[11]
      PRINT COLUMN 01,g_x[12]
      PRINT ' '
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[13]))/2)+1 ,g_x[13] CLIPPED
      PRINT ' '
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[14])-10),g_x[14] CLIPPED," ",
            g_today CLIPPED
      PRINT COLUMN 01,g_x[15] CLIPPED," ",sr.rme08,"(隨機文件)"
      PRINT COLUMN 01,g_x[16] CLIPPED," ",sr.occ18
      PRINT 10 SPACES,sr.rme073
      PRINT 10 SPACES,sr.rme074
      PRINT 10 SPACES,sr.rme075
      PRINT g_x[17] CLIPPED,' ',sr.occ29
      PRINT g_x[18] CLIPPED,' ',sr.occ261
      PRINT g_x[19] CLIPPED,' ',sr.occ271
      PRINT g_dash
#No.FUN-580013 --start--
#     PRINT COLUMN 01,g_x[20],COLUMN 41,g_x[21]
#     PRINT "------------------------------------------------------",
#           "------------------------"
#     PRINT g_x[24] CLIPPED
      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                       g_x[36],g_x[37],g_x[38]
      PRINTX name = H2 g_x[39],g_x[40]
      PRINT g_dash1
      PRINT COLUMN g_c[31],g_x[24] CLIPPED
#No.FUN-580013 --end--
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.rme08   #Invoice
      SKIP TO TOP OF PAGE
      LET l_tot1 = 0    #棧板數
      LET l_tot2 = 0    #箱數
      LET l_qty  = 0
      LET l_weight = 0
 
   AFTER GROUP OF sr.rme08   #Invoice
      PRINT g_dash
#No.FUN-580013 --start--
#     PRINT 'TOTAL',
#           COLUMN 19,l_qty USING '--,---,--&',' PCS',
#           COLUMN 33,l_tot1 USING '####',
#           COLUMN 49,l_tot2 USING '####',
#           COLUMN 65,l_weight USING '####&.&&',' KGM'
      PRINT COLUMN g_c[31],"TOTAL",
            COLUMN g_c[33],l_qty USING '--,---,--&',' PCS',
            COLUMN g_c[34],l_tot1 USING '####',
            COLUMN g_c[36],l_tot2 USING '####',
            COLUMN g_c[38],l_weight USING '####&.&&',' KGM'
#No.FUN-580013 --end--
#  BEFORE GROUP OF sr.rme04   #Customer
#     SKIP TO TOP OF PAGE
#     LET l_tot1 = 0    #棧板數
#     LET l_tot2 = 0    #箱數
#     LET l_qty  = 0
#     LET l_weight = 0
 
#  AFTER GROUP OF sr.rme04   #Customer
#     PRINT g_dash
#     PRINT 'TOTAL',
#           COLUMN 19,l_qty USING '--,---,--&',' PCS',
#           COLUMN 33,l_tot1 USING '###&',
#           COLUMN 49,l_tot2 USING '###&',
#           COLUMN 65,l_weight USING '####&.&&',' KGM'
#
   BEFORE GROUP OF sr.rmf07   #RMA NO
      PRINT "RMA NO. ",COLUMN 11,sr.rmf07
 
   BEFORE GROUP OF sr.rmf33
      LET l_i = 0
 
   ON EVERY ROW
      LET l_i = l_i + 1
      LET l_qty = l_qty + sr.rmf22
#No.FUN-580013 --start--
#     PRINT sr.rmf03,
#           COLUMn 22,sr.rmf22 USING '---,--&';
      PRINTX name = D1
            COLUMN g_c[31],sr.rmf03,
            COLUMN g_c[32],sr.rmf06,
            COLUMN g_c[33],sr.rmf22 USING '--,---,--&';
#No.FUN-580013 --end--
      IF l_i = 1 THEN
#No.FUN-580013 --start--
#        PRINT COLUMN 34,sr.rmf31 USING '###',
#              COLUMN 38,sr.rmf32,
#              COLUMN 50,sr.rmf33 USING '###',
#              COLUMN 55,sr.rmf34,
#              COLUMN 67,sr.rmf35 USING '##&.&&'
         PRINTX name = D1
               COLUMN g_c[34],sr.rmf31 USING '####',
               COLUMN g_c[35],sr.rmf32,
               COLUMN g_c[36],sr.rmf33 USING '####',
               COLUMN g_c[37],sr.rmf34,
               COLUMN g_c[38],sr.rmf35 USING '####&.&&'
#No.FUN-580013 --end--
      ELSE
         PRINT ''
      END IF
#     PRINT sr.rmf06 CLIPPED,' ',sr.rmf061
      PRINTX name = D2 COLUMN g_c[40],sr.rmf061    #No.FUN-580013
   AFTER GROUP OF sr.rmf31 #plt
      IF NOT cl_null(sr.rmf31) THEN
         LET l_tot1 = l_tot1 + 1
      END IF
 
   AFTER GROUP OF sr.rmf33 #carton
      IF NOT cl_null(sr.rmf33) THEN
         LET l_tot2 = l_tot2 + 1
      END IF
      LET l_weight = l_weight + sr.rmf35
 
## FUN-550122
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[22])),g_x[22] CLIPPED
      SKIP 2 LINE
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[23])),g_x[23] CLIPPED
      PRINT ''
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[25]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[25]
             PRINT g_memo
      END IF
## END FUN-550122
 
END REPORT}
#No.FUN-710085 --end--
#Patch....NO.TQC-610037 <> #

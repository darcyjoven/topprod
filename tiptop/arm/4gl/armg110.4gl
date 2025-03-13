# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: armg110.4gl
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
# Modify.........: No.FUN-B40087 11/06/02 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-B90058 11/09/07 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C20052 12/02/09 By chenying GR調整
# Modify.........: No.FUN-C40036 12/04/11 By xujing   GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/14 By wangrr GR程式优化
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
###GENGRE###START
TYPE sr1_t RECORD
    rme08 LIKE rme_file.rme08,
    rme04 LIKE rme_file.rme04,
    occ18 LIKE occ_file.occ18,
    rme073 LIKE rme_file.rme073,
    rme074 LIKE rme_file.rme074,
    rme075 LIKE rme_file.rme075,
    rme011 LIKE rme_file.rme011,
    rms03 LIKE rms_file.rms03,
    rms06 LIKE rms_file.rms06,
    rms061 LIKE rms_file.rms061,
    rms12 LIKE rms_file.rms12,
    rms13 LIKE rms_file.rms13,
    rms14 LIKE rms_file.rms14,
    rms31 LIKE rms_file.rms31,
    rms33 LIKE rms_file.rms33,
    rms36 LIKE rms_file.rms36,
    occ29 LIKE occ_file.occ29,
    occ292 LIKE occ_file.occ292,
    occ261 LIKE occ_file.occ261,
    occ271 LIKE occ_file.occ271,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    #FUN-C40036---add---str
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000
    #FUN-C40036---add---end
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
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
              "azi05.azi_file.azi05"
              #FUN-C40036---add---str
             ,",sign_type.type_file.chr1,",
              "sign_img.type_file.blob,",   
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000"
              #FUN-C40036---add---end 

   LET l_table = cl_prt_temptable('armg110',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087 #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?,?,?) "         #FUN-C40036 add 4 ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087 #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM
   END IF
   #No.FUN-710082--end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
           CALL armg110_tm(0,0)             # Input print condition
      ELSE
           CALL armg110()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)                     #FUN-B90058  add
END MAIN
 
FUNCTION armg110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW armg110_w AT p_row,p_col
        WITH FORM "arm/42f/armg110"
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
      LET INT_FLAG = 0 CLOSE WINDOW armg110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
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
      LET INT_FLAG = 0 CLOSE WINDOW armg110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armg110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armg110','9031',1)
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
         CALL cl_cmdat('armg110',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armg110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armg110()
   ERROR ""
END WHILE
   CLOSE WINDOW armg110_w
END FUNCTION
 
FUNCTION armg110()
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
   DEFINE l_img_blob     LIKE type_file.blob   #FUN-C40036 add

   LOCATE l_img_blob    IN MEMORY              #FUN-C40036 add
 
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
              #" FROM rme_file,rms_file,OUTER occ_file ",  #FUN-C50008 mark--
              #" WHERE rme01 = rms01 AND rme_file.rme03=occ_file.occ01", #FUN-C50008 mark--
               " FROM rme_file LEFT OUTER JOIN occ_file ON rme03=occ01,rms_file ", #FUN-C50008 add LEFT OUTER
               " WHERE rme01 = rms01 ",   #FUN-C50008 add
               "   AND rmeconf <> 'X' ",  #CHI-C80041
               "   AND rmevoid='Y' AND ",tm.wc CLIPPED,
               " ORDER BY rme08,rme04,rms03,rme011  "
 
     PREPARE armg110_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE armg110_curs1 CURSOR FOR armg110_prepare1
     #No.FUN-710082--begin
     CALL cl_del_data(l_table) 
#    CALL cl_outnam('armg110') RETURNING l_name
 
#    START REPORT armg110_rep TO l_name
 
#    LET g_pageno = 0
     FOREACH armg110_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
          EXECUTE insert_prep USING sr.*,t_azi03,t_azi04,t_azi05
                                    ,"",l_img_blob,"N",""          #FUN-C40036 add
#      OUTPUT TO REPORT armg110_rep(sr.*)
     END FOREACH
 
#    FINISH REPORT armg110_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'rme01,rme02,rme03,rme08')  
        RETURNING tm.wc                                                           
     END IF                      
     SELECT * INTO l_zo.* FROM zo_file WHERE zo01=g_rlang   #MOD-A30139 add  #MOD-A30169 mod
###GENGRE###     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",
###GENGRE###              l_zo.zo12,";",l_zo.zo041,";",l_zo.zo042,";",  #MOD-A30139 add
###GENGRE###              l_zo.zo05,";",l_zo.zo09,";", l_zo.zo07        #MOD-A30139 add

###GENGRE###     CALL cl_prt_cs3('armg110','armg110',l_sql,l_str)    #FUN-710080 modify

    LET g_cr_table = l_table                   #主報表的temp table名稱  #FUN-C40036 add
    LET g_cr_apr_key_f = "rme08"       #報表主鍵欄位名稱，用"|"隔開     #FUN-C40036 add

    CALL armg110_grdata()    ###GENGRE###
#      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085  #FUN-B90058   mark
#      CALL cl_gre_drop_temptable(l_table)             #FUN-B90058   mark
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT armg110_rep(sr)
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

###GENGRE###START
FUNCTION armg110_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY   #FUN-C40036 add
    CALL cl_gre_init_apr()          #FUN-C40036 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("armg110")
        IF handler IS NOT NULL THEN
            START REPORT armg110_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       #" ORDER BY rme08,rme011"   #FUN-C20052 mark 
                        " ORDER BY rme08 desc,rme011"   #FUN-C20052 add 
          
            DECLARE armg110_datacur1 CURSOR FROM l_sql
            FOREACH armg110_datacur1 INTO sr1.*
                OUTPUT TO REPORT armg110_rep(sr1.*)
            END FOREACH
            FINISH REPORT armg110_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT armg110_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40087-------------add-----str-----
    DEFINE l_sum_rms12      LIKE rms_file.rms12
    DEFINE l_sum_rms14      LIKE rms_file.rms14
    DEFINE l_sum_rms31      LIKE rms_file.rms31
    DEFINE l_sum_rms33      LIKE rms_file.rms33
    DEFINE l_zo07           LIKE zo_file.zo07
    DEFINE l_rms13_fmt      STRING
    DEFINE l_rms14_fmt      STRING
    DEFINE l_rms14_sum_fmt  STRING
    #FUN-B40087-------------add-----end-----

    
    ORDER EXTERNAL BY sr1.rme08,sr1.rme011
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rme08 
            LET l_lineno = 0
        BEFORE GROUP OF sr1.rme011

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.rme08
           #FUN-B40087-------------add-----str-----
           LET l_rms13_fmt = cl_gr_numfmt('rms_file','rms13',sr1.azi03)
           PRINTX l_rms13_fmt
           LET l_rms14_fmt = cl_gr_numfmt('rms_file','rms13',sr1.azi04)
           PRINTX l_rms14_fmt
           LET l_rms14_sum_fmt = cl_gr_numfmt('rms_file','rms14',sr1.azi05)
           PRINTX l_rms14_sum_fmt
           LET l_sum_rms12 = GROUP SUM(sr1.rms12)
           PRINTX l_sum_rms12
           LET l_sum_rms14 = GROUP SUM(sr1.rms14)
           PRINTX l_sum_rms14
           LET l_sum_rms33 = GROUP SUM(sr1.rms33)
           PRINTX l_sum_rms33
           LET l_sum_rms31= GROUP SUM(sr1.rms31)
           PRINTX l_sum_rms31
           #FUN-B40087-------------add-----end------
        AFTER GROUP OF sr1.rme011

        
        ON LAST ROW
           #FUN-B40087-------------add-----str-----
           SELECT zo07 INTO l_zo07 FROM zo_file WHERE zo01=g_rlang
           PRINTX l_zo07
           #FUN-B40087-------------add-----end------

END REPORT
###GENGRE###END

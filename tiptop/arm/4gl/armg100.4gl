# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: armg100.4gl
# Descriptions...: INVOICE
# Date & Author..: 98/02/24 by Sunny
# Modi           : 98/04/01 by plum
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.MOD-530205 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550122 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/18 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.MOD-590502 05/10/03 By Rosayu 程式最後一行列印超出報表設定寬度造成列印前出現寬度錯誤訊息
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-710085 07/03/12 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30139 10/04/07 By Summer 公司名稱與地址等資訊改為抓取p_zo實際資料 
# Modify.........: No:MOD-A30169 10/04/08 By Summer 修正MOD-A30139,p_zo應抓目前語系之資料
# Modify.........: No.FUN-B40092 11/06/01 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C10036 12/01/11 By qirl FUN-BB0047追單
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C20052 12/02/09 By chenying GR調整
# Modify.........: No.FUN-C40036 12/04/11 By xujing   GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)                # Input more condition
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   l_table         STRING                  #No.FUN-710085
DEFINE   g_sql           STRING                  #No.FUN-710085
DEFINE   g_str           STRING                  #No.FUN-710085
 
###GENGRE###START
TYPE sr1_t RECORD
    rme011 LIKE rme_file.rme011,
    rme04 LIKE rme_file.rme04,
    rme073 LIKE rme_file.rme073,
    rme074 LIKE rme_file.rme074,
    rme075 LIKE rme_file.rme075,
    rme08 LIKE rme_file.rme08,
    rmt03 LIKE rmt_file.rmt03,
    rmt06 LIKE rmt_file.rmt06,
    rmt061 LIKE rmt_file.rmt061,
    rmt12 LIKE rmt_file.rmt12,
    rmt14 LIKE rmt_file.rmt14,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    occ261 LIKE occ_file.occ261,
    occ271 LIKE occ_file.occ271,
    occ29 LIKE occ_file.occ29,
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
 #  CALL cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-C10036 MARK
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-710085 --start--
   LET g_sql = "rme011.rme_file.rme011,rme04.rme_file.rme04,",
               "rme073.rme_file.rme073,rme074.rme_file.rme074,",
               "rme075.rme_file.rme075,rme08.rme_file.rme08,",
               "rmt03.rmt_file.rmt03,rmt06.rmt_file.rmt06,",
               "rmt061.rmt_file.rmt061,rmt12.rmt_file.rmt12,",
               "rmt14.rmt_file.rmt14,azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,azi05.azi_file.azi05,",
               "occ261.occ_file.occ261,occ271.occ_file.occ271,",
               "occ29.occ_file.occ29"
               #FUN-C40036---add---str
              ,",sign_type.type_file.chr1,sign_img.type_file.blob,", 
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" 
               #FUN-C40036---add---end
   LET l_table = cl_prt_temptable('armg100',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40092#FUN-C10036 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40092#FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"     #FUN-C40036 add 4 ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40092#FUN-C10036 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40092#FUN-C10036 mark
      EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #FUN-C10036  add
 
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
           CALL armg100_tm(0,0)             # Input print condition
      ELSE
           CALL armg100()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
END MAIN
 
FUNCTION armg100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 14
   END IF
 
   OPEN WINDOW armg100_w AT p_row,p_col
        WITH FORM "arm/42f/armg100"
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
               IF INFIELD(rme03) THEN  #客戶編號    #FUN-4B0045
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
      LET INT_FLAG = 0 CLOSE WINDOW armg100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40092
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
      LET INT_FLAG = 0 CLOSE WINDOW armg100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40092
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armg100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armg100','9031',1)
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
         CALL cl_cmdat('armg100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armg100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40092
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armg100()
   ERROR ""
END WHILE
   CLOSE WINDOW armg100_w
END FUNCTION
 
FUNCTION armg100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000)
          l_zo      RECORD LIKE zo_file.*,     #MOD-A30139 add
          sr        RECORD
                    rme08       LIKE rme_file.rme08,
                    rme03       LIKE rme_file.rme03,
                    rme04       LIKE rme_file.rme04,
                    rmt03       LIKE rmt_file.rmt03,
                    rme073      LIKE rme_file.rme073,
                    rme074      LIKE rme_file.rme074,
                    rme075      LIKE rme_file.rme075,
                    rme011      LIKE rme_file.rme011,
                    rmt06       LIKE rmt_file.rmt06,
                    rmt061      LIKE rmt_file.rmt061,
                    rmt12       LIKE rmt_file.rmt12,
                    price       LIKE rmd_file.rmd12,  #No.FUN-690010 dec(10,3),
                    rmt14       LIKE rmt_file.rmt14,
                    occ29       LIKE occ_file.occ29,
                    occ292      LIKE occ_file.occ292,
                    occ261      LIKE occ_file.occ261,
                    occ271      LIKE occ_file.occ271
                    END RECORD
   DEFINE  l_img_blob     LIKE type_file.blob

 
     CALL cl_del_data(l_table)  #No.FUN-710085
 
#       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085 #FUN-B40092 mark
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05   #No.CHI-6A0004
           FROM azi_file WHERE azi01 = 'USD'

     LOCATE l_img_blob    IN MEMORY     #FUN-C40036 add

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
 
     LET l_sql="SELECT rme08,rme03,rme04,rmt03,rme073,rme074,rme075,rme011, ",
               "       rmt06,rmt061,sum(rmt12),0,sum(rmt14),'', ",
               "       '','','' ",
               "  FROM rme_file,rmt_file ",
               "  WHERE rme01 = rmt01 AND rmevoid='Y' ",
               "  AND   rmeconf <> 'X' ",  #CHI-C80041
               "  AND ",tm.wc CLIPPED,
               "  GROUP BY rme08,rme03,rme04,rmt03,rme073,rme074,rme075,rme011,rmt06,rmt061 ",
               "  ORDER BY rme08,rme011,rmt03 "
 
     PREPARE armg100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40092
        EXIT PROGRAM
     END IF
     DECLARE armg100_curs1 CURSOR FOR armg100_prepare1
#    CALL cl_outnam('armg100') RETURNING l_name  #No.FUN-710085 mark
 
#    START REPORT armg100_rep TO l_name   #No.FUN-710085 mark
 
#    LET g_pageno = 0                     #No.FUN-710085 mark
     FOREACH armg100_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT occ29,occ292,occ261,occ271 INTO sr.occ29,sr.occ292,sr.occ261,
              sr.occ271 FROM occ_file WHERE occ01=sr.rme03
 
       #No.FUN-710085 --start--
       EXECUTE insert_prep USING sr.rme011,sr.rme04,sr.rme073,
                                 sr.rme074,sr.rme075,sr.rme08,
                                 sr.rmt03,sr.rmt06,sr.rmt061,
                                 sr.rmt12,sr.rmt14,t_azi03,
                                 t_azi04,t_azi05,sr.occ261,
                                 sr.occ271,sr.occ29
                                 #FUN-C40036---add---str
                                ,"",l_img_blob,"N",""
                                 #FUN-C40036---add---end
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT armg100_rep(sr.*) #No.FUN-710085 mark
     END FOREACH
 
#    FINISH REPORT armg100_rep            #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #str MOD-A30139 mod
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'rme01,rme02,rme03,rme08')
             RETURNING tm.wc
     END IF
    #end MOD-A30139 mod
     SELECT * INTO l_zo.* FROM zo_file WHERE zo01=g_rlang   #MOD-A30139 add  #MOD-A30169 mod
###GENGRE###     LET g_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",
###GENGRE###                 l_zo.zo12,";",l_zo.zo041,";",l_zo.zo042,";",  #MOD-A30139 add
###GENGRE###                 l_zo.zo05,";",l_zo.zo09,";", l_zo.zo07        #MOD-A30139 add
###GENGRE###     CALL cl_prt_cs3('armg100','armg100',l_sql,g_str)   #FUN-710080 modify

    LET g_cr_table = l_table                   #主報表的temp table名稱     #FUN-C40036 add
    LET g_cr_apr_key_f = "rme011"          #報表主鍵欄位名稱，用"|"隔開     #FUN-C40036 add
 
    CALL armg100_grdata()    ###GENGRE###
     #No.FUN-710085 --end--

#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-710085 mark
#       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085 #FUN-B40092 mark
END FUNCTION
 
#No.FUN-710085 --start-- mark
{REPORT armg100_rep(sr)
  DEFINE l_last_sw,sw_first    LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
   DEFINE l_qty LIKE rmt_file.rmt12 #MOD-530205
   DEFINE l_amt LIKE rmt_file.rmt12 #MOD-530205
  DEFINE sr                     RECORD
                    rme08       LIKE rme_file.rme08,
                    rme03       LIKE rme_file.rme03,
                    rme04       LIKE rme_file.rme04,
                    rmt03       LIKE rmt_file.rmt03,
                    rme073      LIKE rme_file.rme073,
                    rme074      LIKE rme_file.rme074,
                    rme075      LIKE rme_file.rme075,
                    rme011      LIKE rme_file.rme011,
                    rmt06       LIKE rmt_file.rmt06,
                    rmt061      LIKE rmt_file.rmt061,
                    rmt12       LIKE rmt_file.rmt12,
                    price       LIKE rmd_file.rmd12,  #No.FUN-690010 dec(10,3),
                    rmt14       LIKE rmt_file.rmt14,
                    occ29       LIKE occ_file.occ29,
                    occ292      LIKE occ_file.occ292,
                    occ261      LIKE occ_file.occ261,
                    occ271      LIKE occ_file.occ271
                  END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.rme08,sr.rme011,sr.rmt03
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN 01,g_x[9] CLIPPED
      PRINT COLUMN 01,g_x[10] CLIPPED,g_x[11] CLIPPED
      PRINT COLUMN 01,g_x[12] CLIPPED
      PRINT ''
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[13]))/2)+1 ,g_x[13] CLIPPED
      PRINT COLUMN (g_len-FGL_WIDTH(g_today)-FGL_WIDTH(g_x[14] CLIPPED)-2),g_x[14] CLIPPED,' ',g_today
      PRINT ''
      PRINT COLUMN 01,g_x[15] CLIPPED,sr.rme08,g_x[31] CLIPPED
      PRINT COLUMN 01,g_x[16] CLIPPED,' ',sr.rme04
      PRINT COLUMN 11,sr.rme073
      PRINT COLUMN 11,sr.rme074
      PRINT COLUMN 11,sr.rme075
      PRINT COLUMN 1,g_x[17] CLIPPED,' ',sr.occ29
      PRINT COLUMN 1,g_x[18] CLIPPED,' ',sr.occ261
      PRINT COLUMN 1,g_x[19] CLIPPED,' ',sr.occ271
      PRINT g_dash
#No.FUN-580013 --start--
#     PRINT COLUMN 01,g_x[20],COLUMN 38,g_x[21] CLIPPED
#     LET head3="-------------------------------------------------",
#               "-----------------------------"
#     PRINT head3
#     PRINT COLUMN 01,g_x[29],COLUMN 60,g_x[30] CLIPPED
      PRINTX name = H1 g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
      PRINTX name = H2 g_x[40],g_x[41]
      PRINT g_dash1
#No.FUN-580013 --end--
      LET l_last_sw = 'n'
 
 
   AFTER GROUP OF sr.rme08
      LET l_qty= GROUP SUM(sr.rmt12)
      LET l_amt= GROUP SUM(sr.rmt14)
#No.FUN-580013 --start--
#     PRINT head1
#     PRINT COLUMN 01,g_x[33] CLIPPED,
#           COLUMN 35,l_qty USING '---,--&'," pcs",
#           COLUMN 60,cl_numfor(l_amt,18,g_azi05)
#     PRINT COLUMN 35,"vvvvvvv",
#           COLUMn 60,"vvvvvvvvvvvvvvvvvvv"
#     PRINT ' '
#     PRINT ' '
#     PRINT COLUMN 01,g_x[23],COLUMN 41,g_x[24] CLIPPED
#     PRINT COLUMN 01,g_x[25],COLUMN 41,g_x[26] CLIPPED
      PRINT g_dash
      PRINT COLUMN g_c[35],g_x[33] CLIPPED,
            COLUMN g_c[37],l_qty USING '---,--&'," pcs",
            COLUMN g_c[39],cl_numfor(l_amt,18,t_azi05)   #No.CHI-6A0004
      PRINT COLUMN g_c[37],"vvvvvvvvvvv",
            COLUMN g_c[39],"vvvvvvvvvvvvvvvvvv"
#No.FUN-580013 --end--
   BEFORE GROUP OF sr.rme08
      SKIP TO TOP of page
      LET l_qty =0
      LET l_amt =0
 
   BEFORE GROUP OF sr.rme011
      PRINT g_x[32] CLIPPED, sr.rme011
 
   ON EVERY ROW
#No.FUN-580013 --start--
#     PRINT COLUMN 01, sr.rmt03,
#           COLUMN 35, sr.rmt12 USING '---,--&',
#           COLUMN 43 , cl_numfor(sr.rmt14/sr.rmt12,15,g_azi03),
#           COLUMN 60,cl_numfor(sr.rmt14,18,g_azi04)
#     PRINT COLUMN 01, sr.rmt06,' ',sr.rmt061
      PRINTX name = D1
            COLUMN g_c[35],sr.rmt03,
            COLUMN g_c[36],sr.rmt06,
            COLUMN g_c[37],sr.rmt12 USING '---,--&',
            COLUMN g_c[38],cl_numfor(sr.rmt14/sr.rmt12,15,t_azi03),   #No.CHI-6A0004
            COLUMN g_c[39],cl_numfor(sr.rmt14,18,t_azi04)     #No.CHI-6A0004
      PRINTX name = D2
            COLUMN g_c[41],sr.rmt061
#No.FUN-580013 --end--
      LET l_qty= l_qty + sr.rmt12
      LET l_amt= l_amt + sr.rmt14
 
## FUN-550122
ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      #PRINT COLUMN (g_len-FGL_WIDTH(g_x[27] CLIPPED)),5 SPACES,g_x[27] CLIPPED #MOD-590502 mark
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[27] CLIPPED)),g_x[27] CLIPPED #MOD-590502 add
      SKIP 2 LINE
      #PRINT COLUMN (g_len-FGL_WIDTH(g_x[28] CLIPPED)),5 SPACES,g_x[28] CLIPPED #MOD-590502 mark
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[28] CLIPPED)),g_x[28] CLIPPED #MOD-590502 add
     # LET l_last_sw = 'y'
 
      PRINT ''
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[34]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[34]
             PRINT g_memo
      END IF
## END FUN-550122
 
END REPORT}
#No.FUN-710085 --end--
 
#Patch....NO.TQC-610037 <> #

###GENGRE###START
FUNCTION armg100_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY #FUN-C40036 add
    CALL cl_gre_init_apr()        #FUN-C40036 add

 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("armg100")
        IF handler IS NOT NULL THEN
            START REPORT armg100_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       #" ORDER BY  rme08,rme011,rmt03"        #FUN-C20052 mark
                        " ORDER BY  rme08 desc,rme011,rmt03"   #FUN-C20052 add
            DECLARE armg100_datacur1 CURSOR FROM l_sql
            FOREACH armg100_datacur1 INTO sr1.*
                OUTPUT TO REPORT armg100_rep(sr1.*)
            END FOREACH
            FINISH REPORT armg100_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT armg100_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_rmt14_rmt12        LIKE rmt_file.rmt14
    DEFINE l_rmt14_sum          LIKE rmt_file.rmt14
    DEFINE l_rmt12_sum          LIKE rmt_file.rmt12
    DEFINE l_rem08              STRING
    DEFINE l_p3                 LIKE zo_file.zo12
    DEFINE l_p4                 LIKE zo_file.zo041
    DEFINE l_p5                 LIKE zo_file.zo042
    DEFINE l_p6                 LIKE zo_file.zo05
    DEFINE l_p7                 LIKE zo_file.zo09
    DEFINE l_p8                 LIKE zo_file.zo07
    DEFINE l_rmt14_fmt          STRING
    DEFINE l_rmt14_sum_fmt      STRING
    DEFINE l_rmt14_rmt12_fmt    STRING
    #FUN-B40092------add------end

    
    ORDER EXTERNAL BY sr1.rme08,sr1.rme011
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rme08
            #FUN-B40092------add------str
            LET l_rmt14_fmt = cl_gr_numfmt('rmt_file','rmt14',sr1.azi04)
            PRINTX l_rmt14_fmt

            LET l_rmt14_sum_fmt = cl_gr_numfmt('rmt_file','rmt14',sr1.azi05)
            PRINTX l_rmt14_sum_fmt
            LET l_rmt14_rmt12_fmt = cl_gr_numfmt('rmt_file','rmt14',sr1.azi03)
            PRINTX l_rmt14_rmt12_fmt
            SELECT zo12 INTO l_p3 FROM zo_file WHERE zo01 = g_rlang
            SELECT zo041 INTO l_p4 FROM zo_file WHERE zo01 = g_rlang
            SELECT zo042 INTO l_p5 FROM zo_file WHERE zo01 = g_rlang
            SELECT zo05 INTO l_p6 FROM zo_file WHERE zo01 = g_rlang
            SELECT zo09 INTO l_p7 FROM zo_file WHERE zo01 = g_rlang
            PRINTX l_p3
            PRINTX l_p4
            PRINTX l_p5
            PRINTX l_p6
            PRINTX l_p7
            IF cl_null(sr1.rme08) THEN
               LET l_rem08 = ' ',"Random file"
            ELSE
               LET l_rem08 =sr1.rme08,"Random file"
            END IF
            PRINTX l_rem08
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            #FUN-B40092------add------end
            LET l_lineno = 0
        BEFORE GROUP OF sr1.rme011

        
        ON EVERY ROW
            LET l_rmt14_rmt12 = sr1.rmt14 / sr1.rmt12   #FUN-B40092 add
            PRINTX l_rmt14_rmt12                        #FUN-B40092 add 
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.rme08
            LET l_rmt14_sum = GROUP SUM(sr1.rmt14)
            LET l_rmt12_sum = GROUP SUM(sr1.rmt12)
            PRINTX l_rmt14_sum
            PRINTX l_rmt12_sum
        AFTER GROUP OF sr1.rme011

        
        ON LAST ROW
            SELECT zo07 INTO l_p8 FROM zo_file WHERE zo01 = g_rlang   #FUN-B40092
            PRINTX l_p8                                               #FUN-B40092
END REPORT
###GENGRE###END

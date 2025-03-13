# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr117.4gl (06/04/10 by Kevin 客製程式納入pkg)
# Descriptions...: 成品半成品LCM評價表
# Date & Author..: 06/06/12 by kim
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-670067 06/08/07 By Jackho 報表轉template1 
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710123 07/01/23 By jamie 取成品售價的l_sql有誤
# Modify.........: No.FUN-710088 07/02/05 By Judy Crstal Report修改
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740292 07/04/24 By kim 走Run Card的客戶取不到重置成本
# Modify.........: No.FUN-7C0101 08/01/28 By shiwuying 成本改善，CR增加類別編號ccc08
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改
# Modify.........: No.TQC-970152 09/07/22 By xiaofeizhu 修改報表中費用率及毛利率的值未顯示出來的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40130 10/04/28 By Carrier FUN-9A0067 追单
# Modify.........: No:MOD-B30725 11/03/31 By sabrina 取成本售價時應排除已作廢的應收帳款單據
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:MOD-C20037 12/02/06 By ck2yuan omb05轉換成庫存單位的單價
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,
           bdate   LIKE type_file.dat,            #No.FUN-680122 DATE
           edate   LIKE type_file.dat,            #No.FUN-680122 DATE
           w1      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           w2      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           w3      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           w4      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           w5      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           w6      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           w7      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           w8      LIKE imk_file.imk02,           #No.FUN-680122 VARCHAR(10)
           yy      LIKE imk_file.imk05,           #No.FUN-680122 VARCHAR(4)
           mm      LIKE imk_file.imk06,           #No.FUN-680122 VARCHAR(2)
           type    LIKE ccc_file.ccc07,           #No.FUN-7C0101 add
           n1      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           n2      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           n3      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           n4      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           n5      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           n6      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           n7      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           n8      LIKE omb_file.omb31,           #No.FUN-680122 VARCHAR(10)
           ima12a  LIKE ima_file.ima12,  
           i1      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j1      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           ima12b  LIKE ima_file.ima12,  
           i2      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j2      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           ima12c  LIKE ima_file.ima12,  
           i3      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j3      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           ima12d  LIKE ima_file.ima12,  
           i4      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j4      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           ima12e  LIKE ima_file.ima12,  
           i5      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j5      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           ima12f  LIKE ima_file.ima12,  
           i6      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j6      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           ima12g  LIKE ima_file.ima12,  
           i7      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j7      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           ima12h  LIKE ima_file.ima12,  
           i8      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           j8      LIKE type_file.num15_3,        #LIKE cpf_file.cpf112,          #No.FUN-680122 DEC(6,2)   #TQC-B90211
           more    LIKE type_file.chr1            #No.FUN-680122 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5                    #No.FUN-680122 SMALLINT
#FUN-710088.....begin
DEFINE g_sql    STRING
DEFINE l_table  STRING
DEFINE g_str    STRING
#FUN-710088.....end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
#NO.CHI-6A0004 --START
#  SELECT azi04 INTO t_azi04
#   FROM azi_file WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
   INITIALIZE tm.* TO NULL
   LET tm.type=ARG_VAL(13)  #No.FUN-7C0101 add 
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
 
#FUN-710088.....begin
   LET g_sql = "ima12.ima_file.ima12,",
               "ima06.ima_file.ima06,",
               "ccc01.ccc_file.ccc01,",
               "ima25.ima_file.ima25,",
               "ccc08.ccc_file.ccc08,",      #No.FUN-7C0101 add
               "ccc91.ccc_file.ccc91,",
               "ccc92.ccc_file.ccc92,",
               "ccc23.ccc_file.ccc23,",
               "rebcost.ccc_file.ccc23,",
               "omb15.omb_file.omb15,",
               "omb31.omb_file.omb31,",
               "omb32.omb_file.omb32,",
               "oma02.oma_file.oma02,",
               "upcost.omb_file.omb15,",
               "downcost.omb_file.omb15,",
               "price.omb_file.omb15,",
               "tot.ccc_file.ccc92,",
               "lcm.ccc_file.ccc92,",
               "ccz27.ccz_file.ccz27,",
               "ima12a.ima_file.ima12,",                    #TQC-970152
               "ima12b.ima_file.ima12,",                    #TQC-970152
               "ima12c.ima_file.ima12,",                    #TQC-970152
               "ima12d.ima_file.ima12,",                    #TQC-970152
               "ima12e.ima_file.ima12,",                    #TQC-970152
               "ima12f.ima_file.ima12,",                    #TQC-970152
               "ima12g.ima_file.ima12,",                    #TQC-970152
               "ima12h.ima_file.ima12,",                    #TQC-970152 
               "ccz26.ccz_file.ccz26"                       #CHI-C30012               
   LET l_table = cl_prt_temptable('axcr117',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?,",                 #No.FUN-7C0101 add
               "        ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?)"            #TQC-970152 #CHI-C30012
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#FUN-710088.....end
 
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr117_tm(0,0)
      ELSE CALL axcr117()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr117_tm(p_row,p_col)
   DEFINE p_row,p_col      LIKE type_file.num5,        #No.FUN-680122 SMALLINT
          l_flag           LIKE type_file.chr1,        #No.FUN-680122 VARCHAR(1)
          l_bdate,l_edate  LIKE type_file.dat,         #No.FUN-680122 DATE
          l_cmd            LIKE type_file.chr1000      #No.FUN-680122 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr117_w AT p_row,p_col
        WITH FORM "axc/42f/axcr117" 
################################################################################
# START genero shell script ADD
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy=g_ccz.ccz01 #No.TQC-A40130 year(g_today)-->g_ccz.ccz01
   LET tm.mm=g_ccz.ccz02 #No.TQC-A40130 month(g_today)-->g_ccz.ccz02
   LET tm.type = g_ccz.ccz28     #No.FUN-7C0101 add
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
    RETURNING l_flag,l_bdate,l_edate
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima01
     ON ACTION locale
         #CALL cl_dynamic_locale()
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr117_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.w1,tm.w2,tm.w3,tm.w4,tm.w5,tm.w6,tm.w7,tm.w8, #No.FUN-7C0101 add tm.type
                 tm.bdate,tm.edate,
                 tm.n1,tm.n2,tm.n3,tm.n4,tm.n5,tm.n6,tm.n7,tm.n8,
                 tm.ima12a,tm.i1,tm.j1,tm.ima12b,tm.i2,tm.j2,
                 tm.ima12c,tm.i3,tm.j3,tm.ima12d,tm.i4,tm.j4,
                 tm.ima12e,tm.i5,tm.j5,tm.ima12f,tm.i6,tm.j6,
                 tm.ima12g,tm.i7,tm.j7,tm.ima12h,tm.i8,tm.j8,tm.more
                 
      WITHOUT DEFAULTS
 
      AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
                 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF
      
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
#No.TQC-720032 -- begin --
#         IF tm.mm > 13 OR tm.mm < 1 THEN
#            CALL cl_err('','sub-003',0)
#            NEXT FIELD mm
#         END IF
#No.TQC-720032 -- end --
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr117_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)   
             WHERE zz01='axcr117'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr117','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,           #No.FUN-7C0101 add
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
 
         CALL cl_cmdat('axcr117',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr117_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr117()
   ERROR ""
 END WHILE
 CLOSE WINDOW axcr117_w
END FUNCTION
 
FUNCTION axcr117()
   DEFINE l_name    LIKE type_file.chr20,     #No.FUN-680122 # External(Disk) file name VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     STRING,                   # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(01)
          l_za05    LIKE type_file.chr1000,   #No.FUN-680122 VARCHAR(40)
          l_imk09   LIKE imk_file.imk09,
          l_tlf06   LIKE tlf_file.tlf06,
          l_tlf13   LIKE tlf_file.tlf13,
          l_tlf905  LIKE tlf_file.tlf905,
          l_tlf906  LIKE tlf_file.tlf906 
 
  DEFINE l_omb03    LIKE omb_file.omb03 
  DEFINE l_omb04    LIKE omb_file.omb04       #MOD-C20037 add
  DEFINE l_flag     LIKE type_file.num5       #MOD-C20037 add
  DEFINE l_factor   LIKE type_file.num26_10   #MOD-C20037 add
  DEFINE l_apb02    LIKE apb_file.apb02 
  DEFINE l_apb081   LIKE apb_file.apb081,
    sr  RECORD 
        ccc    RECORD LIKE ccc_file.*,
        ima06  LIKE ima_file.ima12,
        ima12  LIKE ima_file.ima12,
        ima131 LIKE ima_file.ima131,
        ima25  LIKE ima_file.ima25,
        omb05  LIKE omb_file.omb05,
        omb15  LIKE omb_file.omb15,
        omb31  LIKE omb_file.omb31, 
        omb32  LIKE omb_file.omb32,
        oma02  LIKE oma_file.oma02,
        rebcost LIKE ccc_file.ccc23,     #No.FUN-680122 DEC(15,6)
        upcost  LIKE omb_file.omb15,     #No.FUN-680122 DEC(15,6)
        downcost LIKE omb_file.omb15,    #No.FUN-680122 DEC(15,6)
        price  LIKE omb_file.omb15,      #No.FUN-680122 DEC(15,6)
        tot    LIKE ccc_file.ccc92,      #No.FUN-680122 DEC(15,3)
        lcm    LIKE ccc_file.ccc92       #No.FUN-680122 DEC(15,6)
        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)    #FUN-710088
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr117'     #No.FUN-670067
 
     LET l_sql = "SELECT ccc_file.*,ima06,ima12,ima131,ima25, ",
                 "       '','','','','','','','','','','' ",
                 "  FROM ccc_file,ima_file",
                 " WHERE ima01 = ccc01",
                   " AND ",tm.wc CLIPPED,
                   " AND ccc02 = '",tm.yy,"' ",
                   " AND ccc03 = '",tm.mm,"' ",
                   " AND ccc07 = '",tm.type,"'",  #No.FUN-7C0101 add
                   " AND ccc91 != 0 "
     PREPARE axcr117_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr117_curs1 CURSOR FOR axcr117_prepare1
 
#    CALL cl_outnam('axcr117') RETURNING l_name    #FUN-710088 mark
#No.FUN-670067--begin
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 233 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
#No.FUN-670067--end
#    START REPORT axcr117_rep TO l_name   #FUN-710088 mark
     LET g_pageno = 0
     IF cl_null(tm.n1) THEN LET tm.n1 = ' ' END IF
     IF cl_null(tm.n2) THEN LET tm.n2 = ' ' END IF
     IF cl_null(tm.n3) THEN LET tm.n3 = ' ' END IF
     IF cl_null(tm.n4) THEN LET tm.n4 = ' ' END IF
     IF cl_null(tm.n5) THEN LET tm.n5 = ' ' END IF
     IF cl_null(tm.n6) THEN LET tm.n6 = ' ' END IF
     IF cl_null(tm.n7) THEN LET tm.n7 = ' ' END IF
     IF cl_null(tm.n8) THEN LET tm.n8 = ' ' END IF
     INITIALIZE sr.* TO NULL
     FOREACH axcr117_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#add by Kevin 060419 增加排除倉別功能
       LET l_imk09 = 0
       IF NOT cl_null(tm.w1) OR NOT cl_null(tm.w2) OR NOT cl_null(tm.w3) OR
          NOT cl_null(tm.w4) OR NOT cl_null(tm.w5) OR NOT cl_null(tm.w6) OR
          NOT cl_null(tm.w7) OR NOT cl_null(tm.w8) THEN
          SELECT SUM(imk09) INTO l_imk09 FROM imk_file
           WHERE imk01 = sr.ccc.ccc01
             AND imk05 = tm.yy AND imk06 = tm.mm
             AND (imk02 = tm.w1 OR imk02 = tm.w2 OR imk02 = tm.w3 OR
                  imk02 = tm.w4 OR imk02 = tm.w5 OR imk02 = tm.w6 OR
                  imk02 = tm.w7 OR imk02 = tm.w8)
             AND imk02 NOT IN (SELECT jce02 FROM jce_file)
          IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF
          LET sr.ccc.ccc91 = sr.ccc.ccc91 - l_imk09
          LET sr.ccc.ccc92 = sr.ccc.ccc91 * sr.ccc.ccc23
       END IF
#end add
 
#modify by Kevin 060426 改為採購入庫及工單入庫最近的一筆
        
       DECLARE max_date_price CURSOR FOR 
        SELECT tlf06,tlf13,tlf905,tlf906,tlfc21/tlf10 FROM tlf_file LEFT OUTER JOIN  tlfc_file ON tlf01=tlfc01 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf06=tlfc06 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf905=tlfc905 AND tlf906=tlfc906 AND tlf907=tlfc907 #No.FUN-7C0101 tlf21->tlfc21
         WHERE tlf06 BETWEEN tm.bdate AND tm.edate
           AND tlf01 = sr.ccc.ccc01
#add by Kevin 060419 排除委外工單(加工費)
           AND tlf62 NOT IN (SELECT sfb01 FROM sfb_file WHERE sfb02 = 7
                                 OR sfb02 = 8) 
          #AND (tlf13 = 'apmt150' OR tlf13 = 'asft6201') #TQC-740292
           AND (tlf13 = 'apmt150' OR tlf13 = 'asft6201' OR tlf13 = 'asft6231') #TQC-740292
           AND tlf902 NOT IN (SELECT jce02 FROM jce_file)  #FUN-670098 add
           AND tlfc_file.tlfctype = tm.type                          #No.FUN-7C0101 add 
           AND tlfc_file.tlfccost = sr.ccc.ccc08                     #No.FUN-7C0101 add 
           AND tlfc21 IS NOT NULL                          #No.FUN-7C0101 add 
     #     AND tlf21 IS NOT NULL                           #No.FUN-7C0101
         ORDER BY tlf06 DESC,tlf13,tlf905,tlf906
       FOREACH max_date_price INTO l_tlf06,l_tlf13,l_tlf905,l_tlf906,sr.rebcost
          IF cl_null(sr.rebcost) THEN LET sr.rebcost = 0 END IF
          IF sr.rebcost > 0 THEN 
             EXIT FOREACH
          END IF
       END FOREACH
       IF cl_null(sr.rebcost) THEN LET sr.rebcost = 0 END IF
 
#重置成本若=0,則依存貨成本
       IF sr.rebcost = 0 THEN LET sr.rebcost = sr.ccc.ccc23 END IF
       
{#
#取成品售價
#      SELECT omb05,omb15,omb31,omb32,oma02,MAX(omb03) 
#        INTO sr.omb05,sr.omb15,sr.omb31,sr.omb32,sr.oma02,l_omb03
#        FROM oma_file,omb_file
#       WHERE oma01 = omb01
#         AND oma02 BETWEEN tm.bdate AND tm.edate
#         AND omb04 = sr.ccc.ccc01
#         AND oma00 = '12'
#         AND omb15 > 0
##add by Kevin 060419 增加排除單別功能
#         AND omb31[1,3] != tm.n1 AND omb31[1,3] != tm.n2
#         AND omb31[1,3] != tm.n3 AND omb31[1,3] != tm.n4
#         AND omb31[1,3] != tm.n5 AND omb31[1,3] != tm.n6
#         AND omb31[1,3] != tm.n7 AND omb31[1,3] != tm.n8
#         AND oma02 IN (SELECT MAX(oma02) FROM oma_file,omb_file
#                        WHERE oma01 = omb01
#                          AND oma02 BETWEEN tm.bdate AND tm.edate
#                          AND omb04 = sr.ccc.ccc01
#                          AND omb15 > 0
##add by Kevin 060419 增加排除單別功能
#                          AND omb31[1,3] != tm.n1 AND omb31[1,3] != tm.n2
#                          AND omb31[1,3] != tm.n3 AND omb31[1,3] != tm.n4
#                          AND omb31[1,3] != tm.n5 AND omb31[1,3] != tm.n6
#                          AND omb31[1,3] != tm.n7 AND omb31[1,3] != tm.n8
#                          AND oma00 = '12')
#        GROUP BY omb05,omb15,omb31,omb32,oma02
}
 
#取成品售價
      #LET l_sql="SELECT omb05,omb15,omb31,omb32,oma02,MAX(omb03)",        #MOD-C20037 mark
       LET l_sql="SELECT omb04,omb05,omb15,omb31,omb32,oma02,MAX(omb03)",  #MOD-C20037 add
                 " FROM oma_file,omb_file",
                 " WHERE oma01 = omb01",
                 " AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                #" AND omb04 = sr.ccc.ccc01",         #MOD-710123 mod
                 " AND omb04 = '",sr.ccc.ccc01,"'",   #MOD-710123 mod
                 " AND oma00 = '12'",
                 " AND omaconf = 'Y' ",    #MOD-B30725 add   
                 " AND omb15 > 0",
#add by Kevin 060419 增加排除單別功能
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n1,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n2,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n3,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n4,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n5,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n6,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n7,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n8,"'",
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n1,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n2,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n3,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n4,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n5,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n6,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n7,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n8,"'",     #FUN-B40029
                 " AND oma02 IN (SELECT MAX(oma02) FROM oma_file,omb_file",
                 " WHERE oma01 = omb01",
                 " AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND omb04 = '",sr.ccc.ccc01,"'",
                 " AND omaconf = 'Y' ",    #MOD-B30725 add   
                 " AND omb15 > 0",
#add by Kevin 060419 增加排除單別功能
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n1,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n2,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n3,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n4,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n5,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n6,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n7,"'",
                #" AND SUBSTR(omb31,1,",g_doc_len,") <> '", tm.n8,"'",
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n1,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n2,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n3,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n4,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n5,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n6,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n7,"'",     #FUN-B40029
                 " AND omb31[1,",g_doc_len,"] <> '", tm.n8,"'",     #FUN-B40029
                 " AND oma00 = '12')",
                #" GROUP BY omb05,omb15,omb31,omb32,oma02"          #MOD-C20037 mark
                 " GROUP BY omb04,omb05,omb15,omb31,omb32,oma02"    #MOD-C20037 add
       PREPARE axcr117_c_p FROM l_sql
       DECLARE axcr117_c CURSOR FOR axcr117_c_p
       OPEN axcr117_c
      #FETCH axcr117_c INTO sr.omb05,sr.omb15,sr.omb31,sr.omb32,sr.oma02,l_omb03            #MOD-C20037 mark
       FETCH axcr117_c INTO l_omb04,sr.omb05,sr.omb15,sr.omb31,sr.omb32,sr.oma02,l_omb03    #MOD-C20037 add
       CLOSE axcr117_c
       IF cl_null(sr.omb15) OR sr.omb15 = 0 THEN
          LET sr.omb15 = sr.ccc.ccc23 
       END IF

       #----MOD-C20037  str add-----
       CALL s_umfchk(l_omb04,sr.omb05,sr.ima25)
            RETURNING l_flag,l_factor
       IF l_flag THEN
          LET l_factor = 1
       END IF
       LET sr.omb15 = sr.omb15 / l_factor
       #----MOD-C20037  end add-----

 
# Modify By DSC.Al 060414 ...Begin
#上限 = 售價－（售價*費用率）
#       LET sr.upcost   = sr.omb15-(sr.omb15*tm.i/100) # Al mark 060414
#下限 = 售價－（售價*(費用率+毛利率)）
#       LET sr.downcost = sr.omb15-(sr.omb15*(tm.i/100+tm.j/100)) # Al mark 060414
       CASE 
            WHEN sr.ima12 = tm.ima12a 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i1/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i1/100+tm.j1/100))
            WHEN sr.ima12 = tm.ima12b 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i2/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i2/100+tm.j2/100))
            WHEN sr.ima12 = tm.ima12c 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i3/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i3/100+tm.j3/100))
            WHEN sr.ima12 = tm.ima12d 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i4/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i4/100+tm.j4/100))
            WHEN sr.ima12 = tm.ima12e 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i5/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i5/100+tm.j5/100))
            WHEN sr.ima12 = tm.ima12f 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i6/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i6/100+tm.j6/100))
            WHEN sr.ima12 = tm.ima12g 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i7/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i7/100+tm.j7/100))
            WHEN sr.ima12 = tm.ima12h 
                 LET sr.upcost   = sr.omb15-(sr.omb15*tm.i8/100) 
                 LET sr.downcost = sr.omb15-(sr.omb15*(tm.i8/100+tm.j8/100))
            OTHERWISE EXIT CASE     
       END CASE
#市價：取重置成本,上限,下限的中間值
    
       IF sr.rebcost >= sr.upcost THEN #市價取上限
          LET sr.price = sr.upcost
       ELSE
          IF sr.rebcost < sr.downcost THEN #市價取下限
             LET sr.price = sr.downcost
          ELSE
             LET sr.price = sr.rebcost     #市價取重置成本
          END IF
       END IF
             
       LET sr.tot = sr.ccc.ccc91 * sr.price  #市價總成本
 
       LET sr.lcm = sr.tot - sr.ccc.ccc92
 
#      OUTPUT TO REPORT axcr117_rep(sr.*)   #FUN-710088 mark
       EXECUTE insert_prep USING sr.ima12,sr.ima06,sr.ccc.ccc01,sr.ima25,sr.ccc.ccc08,sr.ccc.ccc91,sr.ccc.ccc92,sr.ccc.ccc23,sr.rebcost,sr.omb15,sr.omb31,sr.omb32,sr.oma02,sr.upcost,sr.downcost,sr.price,sr.tot,sr.lcm,g_ccz.ccz27    #FUN-710088 #No.FUN-7C0101 add ccc08
                                 ,tm.ima12a,tm.ima12b,tm.ima12c,tm.ima12d,tm.ima12e,tm.ima12f,tm.ima12g,tm.ima12h,g_ccz.ccz26          #TQC-970152 #CHI-C30012
       INITIALIZE sr.* TO NULL
 
     END FOREACH
#FUN-710088.....begin
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'ima12,ima01') RETURNING tm.wc
#    LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",g_zz05,";",tm.type  #No.FUN-7C0101 add tm.type   #TQC-970152 Mark
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",g_zz05                                           #TQC-970152
            ,";",tm.i1,";",tm.i2,";",tm.i3,";",tm.i4,";",tm.i5,";",tm.i6,";",tm.i7,";",tm.i8          #TQC-970152
            ,";",tm.j1,";",tm.j2,";",tm.j3,";",tm.j4,";",tm.j5,";",tm.j6,";",tm.j7,";",tm.j8          #TQC-970152     
   # CALL cl_prt_cs3('axcr117',l_sql,g_str)        #TQC-730088
     
#No.FUN-7C0101-------------BEGIN-----------------
   #CALL cl_prt_cs3('axcr117','axcr117',l_sql,g_str)
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr117','axcr117_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr117','axcr117',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
#    FINISH REPORT axcr117_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-710088.....end
END FUNCTION
 
#No:8741
#FUN-710088.....begin mark
#REPORT axcr117_rep(sr)
# DEFINE l_last_sw   LIKE type_file.chr1,        #No.FUN-680122 VARCHAR(1)
#   sr   RECORD
#        ccc    RECORD LIKE ccc_file.*,
#        ima06  LIKE ima_file.ima06,
#        ima12  LIKE ima_file.ima12,
#        ima131 LIKE ima_file.ima131,
#        ima25  LIKE ima_file.ima25,
#        omb05  LIKE omb_file.omb05,
#        omb15  LIKE omb_file.omb15,
#        omb31  LIKE omb_file.omb31, 
#        omb32  LIKE omb_file.omb32,
#        oma02  LIKE oma_file.oma02,
#        rebcost LIKE ccc_file.ccc23,     #No.FUN-680122 DEC(15,6)
#        upcost  LIKE omb_file.omb15,     #No.FUN-680122 DEC(15,6)
#        downcost LIKE omb_file.omb15,    #No.FUN-680122 DEC(15,6)
#        price  LIKE omb_file.omb15,      #No.FUN-680122 DEC(15,6)
#        tot    LIKE ccc_file.ccc92,      #No.FUN-680122 DEC(15,6)
#        lcm    LIKE ccc_file.ccc92       #No.FUN-680122 DEC(15,6)
#        END RECORD,
#      l_chr   LIKE type_file.chr1        #No.FUN-680122 VARCHAR(1)
#  OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 6 PAGE LENGTH g_page_line
#  ORDER BY sr.ima12,sr.ccc.ccc01
#  FORMAT
#    PAGE HEADER
##NO.FUN-670067-begin  
##      PRINT (g_len-FGL_WIDTH(g_company CLIPPED ))/2 SPACES,g_company CLIPPED 
##       IF g_towhom IS NULL OR g_towhom = ' ' THEN
##          PRINT '';
##       ELSE
##          PRINT 'TO:',g_towhom;
##       END IF
##       PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##       PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#       PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED ))/2+1 ,g_company CLIPPED                                                    
#       LET g_pageno = g_pageno + 1                                                                                                  
#       LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                              
#       PRINT g_head CLIPPED,pageno_total                                                                                            
#                                                                                                                                    
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] 
# 
#      PRINT g_x[26] CLIPPED,tm.bdate,'-',tm.edate
##       PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##             COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#       PRINT g_dash[1,g_len]
##       PRINT COLUMN  01,g_x[61], # 成本分群
##             COLUMN  10,g_x[62], # 料號
##             COLUMN  41,g_x[64], # 單位
##             COLUMN  46,g_x[65], # 數量
##             COLUMN  62,g_x[66], # 期末存貨成本
##             COLUMN  78,g_x[67], # 存貨單位成本
##             COLUMN  91,g_x[68], # 重置成本
##             COLUMN 104,g_x[69], # 單位售價
##             COLUMN 117,g_x[70], # 出貨單位
##             COLUMN 134,g_x[71], # 項次
##             COLUMN 139,g_x[72], # 出貨日期
##             COLUMN 148,g_x[73], # 費用率
##             COLUMN 158,g_x[74], # 上限單位成本
##             COLUMN 171,g_x[75], # 下限單位成本
##             COLUMN 184,g_x[76], # 毛利率
##             COLUMN 190,g_x[77], # 市價
##             COLUMN 203,g_x[78], # 市價總成本
##             COLUMN 219,g_x[79]  # 溢(跌)價金額
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],                                                       
#             g_x[39],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],                                                       
#             g_x[48],g_x[49]
#      #PRINT "成本分群 料號                           單位 數量            期末存貨成本    存貨單位成本 重置成本     單位售價     出貨單號         項次 出貨日期 費用率% 上限單位成本 下限單位成本 毛利率% 市價         市價總成本      溢(跌)價金額"
##       PRINT "-------- ------------------------------ ---- --------------- --------------- ------------ ------------ ------------ ---------------- ---- -------- ------- ------------ ------------ ------- ------------ --------------- ---------------"
#      PRINT g_dash1
##No.FUN-670067-end
#       LET l_last_sw = 'n'
#
#   ON EVERY ROW
##No.FUN-670067-begin
##      PRINT COLUMN  01,sr.ima12,sr.ima06,
##            COLUMN  10,sr.ccc.ccc01,
##            COLUMN  41,sr.ima25,
##            COLUMN  46,sr.ccc.ccc91 USING '###,###,##&.&&&',
##            COLUMN  62,sr.ccc.ccc92 USING '###,###,##&.&&&',
##            COLUMN  78,sr.ccc.ccc23 USING '####&.&&&&&&',
##            COLUMN  91,sr.rebcost   USING '####&.&&&&&&',
##            COLUMN 104,sr.omb15     USING '####&.&&&&&&',
##            COLUMN 117,sr.omb31,
##            COLUMN 134,sr.omb32 USING '###&',
##            COLUMN 139,sr.oma02 USING 'YYMMDD';
#        PRINT COLUMN g_c[31],sr.ima12,sr.ima06,                                                                                       
#            COLUMN g_c[32],sr.ccc.ccc01,                                                                                            
#            COLUMN g_c[33],sr.ima25,                                                                                                
#            COLUMN g_c[34],cl_numfor(sr.ccc.ccc91,34,g_ccz.ccz27), #CHI-690007 USING '###,###,##&.&&&',                                                                    
#            COLUMN g_c[35],sr.ccc.ccc92 USING '###,###,##&.&&&',                                                                    
#            COLUMN g_c[36],sr.ccc.ccc23 USING '####&.&&&&&&',                                                                       
#            COLUMN g_c[37],sr.rebcost   USING '####&.&&&&&&',                                                                       
#            COLUMN g_c[38],sr.omb15     USING '#######&.&&&&&&',                                                                    
#            COLUMN g_c[39],sr.omb31,                                                                                                
#            COLUMN g_c[41],sr.omb32 USING '###&',                                                                                   
#            COLUMN g_c[42],sr.oma02 USING 'YYMMDD';
#            
##            CASE 
##               WHEN sr.ima12 = tm.ima12a
##                  PRINT COLUMN 132,tm.i1;
##               WHEN sr.ima12 = tm.ima12b
##                  PRINT COLUMN 132,tm.i2;
##               WHEN sr.ima12 = tm.ima12c
##                  PRINT COLUMN 132,tm.i3;
##               WHEN sr.ima12 = tm.ima12d
##                  PRINT COLUMN 132,tm.i4;
##               WHEN sr.ima12 = tm.ima12e
##                  PRINT COLUMN 132,tm.i5;
##               WHEN sr.ima12 = tm.ima12f
##                  PRINT COLUMN 132,tm.i6;
##               WHEN sr.ima12 = tm.ima12g
##                  PRINT COLUMN 132,tm.i7;
##               WHEN sr.ima12 = tm.ima12h
##                  PRINT COLUMN 132,tm.i8;
##               OTHERWISE EXIT CASE
##            END CASE
##           PRINT COLUMN 156,sr.upcost    USING '####&.&&&&&&',
##           COLUMN 163,sr.downcost  USING '####&.&&&&&&';
#            
##            CASE 
##               WHEN sr.ima12 = tm.ima12a
##                  PRINT COLUMN 142,tm.j1;
##               WHEN sr.ima12 = tm.ima12b
##                  PRINT COLUMN 142,tm.j2;
##               WHEN sr.ima12 = tm.ima12c
##                  PRINT COLUMN 142,tm.j3;
##               WHEN sr.ima12 = tm.ima12d
##                  PRINT COLUMN 142,tm.j4;
##               WHEN sr.ima12 = tm.ima12e
##                  PRINT COLUMN 142,tm.j5;
##               WHEN sr.ima12 = tm.ima12f
##                  PRINT COLUMN 142,tm.j6;
##               WHEN sr.ima12 = tm.ima12g
##                  PRINT COLUMN 142,tm.j7;
##               WHEN sr.ima12 = tm.ima12h
##                  PRINT COLUMN 142,tm.j8;
##               OTHERWISE EXIT CASE
##            END CASE
##            PRINT COLUMN 190,sr.price     USING '####&.&&&&&&',
##            COLUMN 203,sr.tot       USING '###,###,##&.&&&',
##            COLUMN 219,sr.lcm       USING '---,---,--&.&&&'
#           CASE                                                                                                                    
#               WHEN sr.ima12 = tm.ima12a                                                                                            
#                  PRINT COLUMN g_c[43],tm.i1;                                                                                       
#               WHEN sr.ima12 = tm.ima12b                                                                                            
#                  PRINT COLUMN g_c[43],tm.i2;                                                                                       
#               WHEN sr.ima12 = tm.ima12c                                                                                            
#                  PRINT COLUMN g_c[43],tm.i3;                                                                                       
#               WHEN sr.ima12 = tm.ima12d                                                                                            
#                  PRINT COLUMN g_c[43],tm.i4;                                                                                       
#               WHEN sr.ima12 = tm.ima12e                                                                                            
#                  PRINT COLUMN g_c[43],tm.i5;                                                                                       
#               WHEN sr.ima12 = tm.ima12f                                                                                            
#                  PRINT COLUMN g_c[43],tm.i6;                                                                                       
#               WHEN sr.ima12 = tm.ima12g                                                                                            
#                  PRINT COLUMN g_c[43],tm.i7;                                                                                       
#               WHEN sr.ima12 = tm.ima12h                                                                                            
#                  PRINT COLUMN g_c[43],tm.i8;                                                                                       
#               OTHERWISE EXIT CASE                                                                                                  
#            END CASE                                                                                                                
#            PRINT COLUMN g_c[44],sr.upcost    USING '####&.&&&&&&',                                                                 
#            COLUMN g_c[45],sr.downcost  USING '####&.&&&&&&'; 
#         CASE                                                                                                                    
#               WHEN sr.ima12 = tm.ima12a                                                                                            
#                  PRINT COLUMN g_c[46],tm.j1;                                                                                       
#               WHEN sr.ima12 = tm.ima12b                                                                                            
#                  PRINT COLUMN g_c[46],tm.j2;                                                                                       
#               WHEN sr.ima12 = tm.ima12c                                                                                            
#                  PRINT COLUMN g_c[46],tm.j3;                                                                                       
#               WHEN sr.ima12 = tm.ima12d                                                                                            
#                  PRINT COLUMN g_c[46],tm.j4;                                                                                       
#               WHEN sr.ima12 = tm.ima12e                                                                                            
#                  PRINT COLUMN g_c[46],tm.j5;                                                                                       
#               WHEN sr.ima12 = tm.ima12f                                                                                            
#                  PRINT COLUMN g_c[46],tm.j6;                                                                                       
#               WHEN sr.ima12 = tm.ima12g                                                                                            
#                  PRINT COLUMN g_c[46],tm.j7;                                                                                       
#               WHEN sr.ima12 = tm.ima12h                                                                                            
#                  PRINT COLUMN g_c[46],tm.j8;                                                                                       
#               OTHERWISE EXIT CASE                                                                                                  
#            END CASE                                                                                                                
#            PRINT COLUMN g_c[47],sr.price     USING '####&.&&&&&&',                                                                 
#            COLUMN g_c[48],sr.tot       USING '###,###,##&.&&&',                                                                    
#            COLUMN g_c[49],sr.lcm       USING '---,---,--&.&&&'                                                                     
##No.FUN-670067-end 
#
#   AFTER GROUP OF sr.ima12   #材料/成品小計
# 
#      PRINT COLUMN 1, g_dash2[1,g_len] CLIPPED
#      #PRINT '                                 分群碼小計：',
##No.FUN-670067-bgein  
##      PRINT COLUMN 34,g_x[80],
##            GROUP SUM(sr.ccc.ccc91) USING '###,###,##&.&&&',' ',
##            GROUP SUM(sr.ccc.ccc92) USING '###,###,##&.&&&',
##            '                        ',
##            GROUP SUM(sr.tot)       USING '###,###,##&.&&&',
##            '                        ',
##            GROUP SUM(sr.lcm)       USING '---,---,--&.&&&'
#      PRINT  COLUMN g_c[32],g_x[80],                                                                                                
#             COLUMN g_c[34],cl_numfor(GROUP SUM(sr.ccc.ccc91),34,g_ccz.ccz27), #CHI-690007 USING '###,###,##&.&&&',' ',                                                    
#             COLUMN g_c[35],GROUP SUM(sr.ccc.ccc92) USING '###,###,##&.&&&', 
#              COLUMN g_c[38],GROUP SUM(sr.tot)       USING '####,##&.&&&&&&', 
#             COLUMN g_c[42],GROUP SUM(sr.lcm)       USING '--,---,---,---,---,--&.&&&'
##No.FUN-670067-end  
#     PRINT
#  
#   ON LAST ROW
#      PRINT g_dash[1,g_len] CLIPPED
#     #PRINT '                                       總計：',
##No.FUN-670067-begin  
##     PRINT COLUMN 40,g_x[81],
##            SUM(sr.ccc.ccc91) USING '###,###,##&.&&&',' ',
##            SUM(sr.ccc.ccc92) USING '###,###,##&.&&&',
##            '                        ',
##            SUM(sr.tot)       USING '###,###,##&.&&&',
##            '                        ',
##            SUM(sr.lcm)       USING '---,---,--&.&&&'
#      PRINT COLUMN g_c[32],g_x[81],                                                                                                 
#            COLUMN g_c[34],cl_numfor(SUM(sr.ccc.ccc91),34,g_ccz.ccz27), #CHI-690007 USING '###,###,##&.&&&',' ',                                                           
#            COLUMN g_c[35],SUM(sr.ccc.ccc92) USING '###,###,##&.&&&', 
#            COLUMN g_c[38],SUM(sr.tot)       USING '####,##&.&&&&&&',
#            COLUMN g_c[42],SUM(sr.lcm)       USING '--,---,---,---,---,--&.&&&'
##No.FUN-670067-end      
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#FUN-710088.....end mark

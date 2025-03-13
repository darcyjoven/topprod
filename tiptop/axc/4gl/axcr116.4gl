# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr116.4gl (06/04/10 by Kevin 客製程式納入pkg)
# Descriptions...: 材料LCM評價表
# Date & Author..: 06/06/09 by kim  
# Modify.........: NO.FUN-670067 06/07/17 by czl  報表轉換成xml
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: NO.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710147 07/01/25 By Smapmin 市價必須轉換為庫存單位的角度來計算
# Modify.........: No.MOD-710124 07/01/30 By jamie 與MOD-710147修改同樣問題，將程式還原過單
# Modify.........: No.FUN-710088 07/02/05 By Judy Crystal Report修改
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-7C0101 08/01/28 By shiwuying 成本改善，CR增加類別編號ccc08
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40130 10/04/28 By Carrier FUN-9A0067 追单
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
#MOD-710124 add
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300)
           yy      LIKE imk_file.imk05,           #No.FUN-680122CHAR(4)
           mm      LIKE imk_file.imk06,           #No.FUN-680122CHAR(2)
           type    LIKE ccc_file.ccc07,           #No.FUN-7C0101 add
           w1      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)               
           w2      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)  
           w3      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)    
           w4      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)   
           w5      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)     
           w6      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)    
           w7      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)    
           w8      LIKE imk_file.imk02,           #No.FUN-680122CHAR(10)  
           bdate   LIKE type_file.dat,            #No.FUN-680122DATE
           edate   LIKE type_file.dat,            #No.FUN-680122DATE
           n1      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)               
           n2      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)
           n3      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)     
           n4      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)     
           n5      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)        
           n6      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)      
           n7      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)         
           n8      LIKE apb_file.apb21,           #No.FUN-680122CHAR(10)   
           more    LIKE type_file.chr1            #No.FUN-680122CHAR(01)
           END RECORD,
       g_i         LIKE type_file.num5            #No.FUN-680122 SMALLINT
#FUN-710088.....begin
DEFINE g_sql       STRING
DEFINE l_table     STRING
DEFINE g_str       STRING
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
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
#FUN-710088.....begin
   LET g_sql = "ima12.ima_file.ima12,",
               "ima06.ima_file.ima12,",
               "ccc01.ccc_file.ccc01,",
               "ima25.ima_file.ima25,",
               "ccc08.ccc_file.ccc08,",      #No.FUN-7C0101 add
               "ccc91.ccc_file.ccc91,",
               "ccc92.ccc_file.ccc92,",
               "ccc23.ccc_file.ccc23,",
               "apb081.apb_file.apb081,",
               "tot.ccc_file.ccc91,",
               "apb21.apb_file.apb21,",
               "apb22.apb_file.apb22,",
               "apa02.apa_file.apa02,",
               "lcm.ccc_file.ccc91,",
               "ccz27.ccz_file.ccz27"
   LET l_table = cl_prt_temptable('axcr116',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" #No.FUN-7C0101
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_pret:',status,1) EXIT PROGRAM
   END IF
#FUN-710088.....end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr116_tm(0,0)
      ELSE CALL axcr116()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr116_tm(p_row,p_col)
   DEFINE p_row,p_col       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag            LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_bdate,l_edate   LIKE type_file.dat,           #No.FUN-680122DATE
          l_cmd             LIKE type_file.chr1000        #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr116_w AT p_row,p_col
        WITH FORM "axc/42f/axcr116" 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr116_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.w1,tm.w2,tm.w3,tm.w4,tm.w5,tm.w6,tm.w7,tm.w8, #No.FUN-7C0101 add tm.type
                 tm.bdate,tm.edate,
                 tm.n1,tm.n2,tm.n3,tm.n4,tm.n5,tm.n6,tm.n7,tm.n8,tm.more
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr116_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr116'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr116','9031',1)   
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('axcr116',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr116_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr116()
   ERROR ""
 END WHILE
 CLOSE WINDOW axcr116_w
END FUNCTION
 
FUNCTION axcr116()
  DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time         LIKE type_file.chr8        #No.FUN-6A0146
         l_chr     LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
         l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
         l_imk09   LIKE imk_file.imk09
 
  DEFINE l_apb02    LIKE apb_file.apb02,
     sr  RECORD 
         ccc    RECORD LIKE ccc_file.*,
         ima06  LIKE ima_file.ima12,
         ima12  LIKE ima_file.ima12,
         ima131 LIKE ima_file.ima131,
         ima25  LIKE ima_file.ima25,
         apb12  LIKE apb_file.apb12,   #MOD-710147
         apb21  LIKE apb_file.apb21,
         apb22  LIKE apb_file.apb22,
         apb081 LIKE apb_file.apb081,
         apb28  LIKE apb_file.apb28,
         apa02  LIKE apa_file.apa02,
         tot    LIKE ccc_file.ccc91,           #No.FUN-680122DEC(15,3)
         lcm    LIKE ccc_file.ccc91            #No.FUN-680122DEC(15,3)
         END RECORD
  DEFINE l_sql STRING
  DEFINE l_status LIKE type_file.num5,   #MOD-710147
         l_factor LIKE imy_file.imy18   #MOD-710147
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)    #FUN-710088
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr116'   #No.FUN-670067
 
     #LET l_sql = "SELECT ccc_file.*,ima06,ima12,ima131,ima25,'','','','', ",   #MOD-710147
     LET l_sql = "SELECT ccc_file.*,ima06,ima12,ima131,ima25,'','','','','', ",   #MOD-710147
                 "       '','',''  ",
                 "  FROM ccc_file,ima_file",
                 " WHERE ima01 = ccc01",
                   " AND ",tm.wc CLIPPED,
                   " AND ccc02 = '",tm.yy,"' ",
                   " AND ccc03 = '",tm.mm,"' ",
                   " AND ccc07 = '",tm.type,"'",  #No.FUN-7C0101 add
                   " AND ccc91 != 0 "
     PREPARE axcr116_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr116_curs1 CURSOR FOR axcr116_prepare1
 
#    CALL cl_outnam('axcr116') RETURNING l_name   #FUN-710088 mark
#No.FUN-67006--begin
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 165 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR 
#No.FUN-67006--end
     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
#    START REPORT axcr116_rep TO l_name    #FUN-710088 mark
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
     FOREACH axcr116_curs1 INTO sr.*
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
 
 
#取最近採購進價(AP)
 
#       SELECT apb21,apb22,apb081,apb28,apa02,MAX(apb02)
#         INTO sr.apb21,sr.apb22,sr.apb081,sr.apb28,sr.apa02,l_apb02
#         FROM apa_file,apb_file
#        WHERE apa01 = apb01 
#          AND apb12 = sr.ccc.ccc01
#          AND apa02 BETWEEN tm.bdate AND tm.edate
#          AND apa42 != 'Y'
#          AND apa00 = '11'
#add by Kevin 060419 排除委外工單(加工費)
#          AND apb06 NOT IN (SELECT sfb01 FROM sfb_file WHERE sfb02 = 7
#                                OR sfb02 = 8)
#add by Kevin 060419 增加排除單別功能
#          AND apb21[1,3] != tm.n1 AND apb21[1,3] != tm.n2
#          AND apb21[1,3] != tm.n3 AND apb21[1,3] != tm.n4
#          AND apb21[1,3] != tm.n5 AND apb21[1,3] != tm.n6
#          AND apb21[1,3] != tm.n7 AND apb21[1,3] != tm.n8
#          AND apa02 IN (SELECT MAX(apa02) FROM apa_file,apb_file 
#                         WHERE apa01 = apb01
#                           AND apb12 = sr.ccc.ccc01
#                           AND apa02 BETWEEN tm.bdate AND tm.edate
#                           AND apa42 != 'Y'
#add by Kevin 060419 排除委外工單(加工費)
#                           AND apb06 NOT IN 
#                           (SELECT sfb01 FROM sfb_file WHERE sfb02 = 7
#                                OR sfb02 = 8)
#add by Kevin 060419 增加排除單別功能
#                           AND apb21[1,3] != tm.n1 AND apb21[1,3] != tm.n2
#                           AND apb21[1,3] != tm.n3 AND apb21[1,3] != tm.n4
#                           AND apb21[1,3] != tm.n5 AND apb21[1,3] != tm.n6
#                           AND apb21[1,3] != tm.n7 AND apb21[1,3] != tm.n8
#                           AND apa00 = '11')                           
#          GROUP BY apb21,apb22,apb081,apb28,apa02
 
 
#取最近採購進價(AP)
       #LET l_sql="SELECT apb21,apb22,apb081,apb28,apa02,MAX(apb02) ",   #MOD-710147
       LET l_sql="SELECT apb12,apb21,apb22,apb081,apb28,apa02,MAX(apb02) ",   #MOD-710147
                 " FROM apa_file,apb_file ",
                 " WHERE apa01 = apb01 ",
                 " AND apb12 = '",sr.ccc.ccc01 ,"'",
                 " AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND apa42 <> 'Y'",
                 " AND apa00 = '11'",
#add by Kevin 060419 排除委外工單(加工費)
                 " AND apb06 NOT IN (SELECT sfb01 FROM sfb_file ",
                 " WHERE sfb02 = '7' OR sfb02 = '8')",
#add by Kevin 060419 增加排除單別功能
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n1,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n2,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n3,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n4,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n5,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n6,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n7,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n8,"'",
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n1,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n2,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n3,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n4,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n5,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n6,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n7,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n8,"'",     #FUN-B40029
                 " AND apa02 IN (SELECT MAX(apa02) FROM apa_file,apb_file ",
                 " WHERE apa01 = apb01",
                 " AND apb12 = '",sr.ccc.ccc01,"'",
                 " AND apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND apa42 <> 'Y'",
#add by Kevin 060419 排除委外工單(加工費)
                 " AND apb06 NOT IN ",
                 " (SELECT sfb01 FROM sfb_file WHERE sfb02 = 7 OR sfb02 = 8)",
#add by Kevin 060419 增加排除單別功能
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n1,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n2,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n3,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n4,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n5,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n6,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n7,"'",
                #" AND SUBSTR(apb21,1,",g_doc_len,") <> '", tm.n8,"'",
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n1,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n2,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n3,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n4,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n5,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n6,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n7,"'",     #FUN-B40029
                 " AND apb21[1,",g_doc_len,"] <> '", tm.n8,"'",     #FUN-B40029
                 " AND apa00 = '11')",
                 #" GROUP BY apb21,apb22,apb081,apb28,apa02"   #MOD-710147
                 " GROUP BY apb12,apb21,apb22,apb081,apb28,apa02"   #MOD-710147
       PREPARE axcr116_c_p FROM l_sql
       DECLARE axcr116_c CURSOR FOR axcr116_c_p
       OPEN axcr116_c
       FETCH axcr116_c INTO 
                    #sr.apb21,sr.apb22,sr.apb081,sr.apb28,sr.apa02,l_apb02   #MOD-710147
                    sr.apb12,sr.apb21,sr.apb22,sr.apb081,sr.apb28,sr.apa02,l_apb02   #MOD-710147
       CLOSE axcr116_c
       #-----MOD-710147---------
       CALL s_umfchk(sr.apb12,sr.ima25,sr.apb28)
            RETURNING l_status,l_factor
       IF l_status THEN
          LET l_factor = 1
       END IF
       LET sr.apb081 = sr.apb081 * l_factor
       #-----END MOD-710147-----
 
       IF cl_null(sr.apb081) THEN LET sr.apb081 = 0   END IF
 
       IF sr.apb081 > 0 THEN  #有取到最近進價
          LET sr.tot = sr.ccc.ccc91 * sr.apb081
       ELSE                   #取不到最近進價則用成本價
          LET sr.apb081 = sr.ccc.ccc23
          LET sr.tot = sr.ccc.ccc92
       END IF
       LET sr.lcm = sr.tot - sr.ccc.ccc92
#      OUTPUT TO REPORT axcr116_rep(sr.*)   #FUN-710088
       EXECUTE insert_prep USING sr.ima12,sr.ima06,sr.ccc.ccc01,
                                 sr.ima25,sr.ccc.ccc08,sr.ccc.ccc91,sr.ccc.ccc92,#No.FUN-7C0101 add ccc08
                                 sr.ccc.ccc23,sr.apb081,sr.tot,sr.apb21,
                                 sr.apb22,sr.apa02,sr.lcm,g_ccz.ccz27       #FUN-710088
 
       INITIALIZE sr.* TO NULL
 
     END FOREACH
#FUN-710088.....begin
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED    #TQC-720088
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'ima12,ima01')  RETURNING tm.wc
     #LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",g_zz05,";",tm.type  #No.FUN-7C0101 add tm.type #CHI-C30012
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",g_zz05,";",tm.type,";",g_ccz.ccz26 #CHI-C30012
   # CALL cl_prt_cs3('axcr116',l_sql,g_str)          #TQC-730088
 
#No.FUN-7C0101-------------BEGIN-----------------
   #CALL cl_prt_cs3('axcr116','axcr116',l_sql,g_str)
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr116','axcr116_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr116','axcr116',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
#    FINISH REPORT axcr116_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-710088.....end
END FUNCTION
 
#FUN-710088.....begin mark
#REPORT axcr116_rep (sr)
# DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
#        l_azf03      LIKE azf_file.azf03,
#   sr   RECORD
#        ccc    RECORD LIKE ccc_file.*,
#        ima06  LIKE ima_file.ima12,
#        ima12  LIKE ima_file.ima12,
#        ima131 LIKE ima_file.ima131,
#        ima25  LIKE ima_file.ima25,
#        apb12  LIKE apb_file.apb12,   #MOD-710147
#        apb21  LIKE apb_file.apb21,
#        apb22  LIKE apb_file.apb22,
#        apb081 LIKE apb_file.apb081,
#        apb28  LIKE apb_file.apb28,
#        apa02  LIKE apa_file.apa02,
#        tot    LIKE ccc_file.ccc91,           #No.FUN-680122DEC(15,3)
#        lcm    LIKE ccc_file.ccc91            #No.FUN-680122DEC(15,3)
#        END RECORD,
#      l_chr    LIKE type_file.chr1            #No.FUN-680122 VARCHAR(1)
#  OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 6 PAGE LENGTH g_page_line
#  ORDER BY sr.ima12,sr.ccc.ccc01
##No.FUN-670067_begin
#  FORMAT
#    PAGE HEADER
##       PRINT (g_len-FGL_WIDTH(g_company CLIPPED ))/2 SPACES,g_company CLIPPED 
##       IF g_towhom IS NULL OR g_towhom = ' ' THEN
##          PRINT '';
##       ELSE
##          PRINT 'TO:',g_towhom;
##       END IF
##        PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##       PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#       LET g_pageno = g_pageno + 1                                              
#       LET pageno_total = PAGENO USING '<<<',"/pageno"                          
#       PRINT g_head CLIPPED,pageno_total                                        
#                                                                                
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                     
#
#       PRINT g_x[26] CLIPPED,tm.bdate,'-',tm.edate
##       PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME
##            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#       PRINT g_dash[1,g_len]
##No.FUN-670067-end
#
##No.FUN-670067-begin 
##       PRINT COLUMN 01,g_x[61], # 成本分群
##             COLUMN 10,g_x[62], # 料號
##             COLUMN 41,g_x[63], # 單位
##             COLUMN 46,g_x[64], # 數量
##             COLUMN 62,g_x[65], # 期末存貨成本
##             COLUMN 78,g_x[66], # 存貨單位成本
##             COLUMN 91,g_x[67], # 市價
##             COLUMN 104,g_x[68], # 市價總成本
##             COLUMN 120,g_x[69],# 驗收單號 
##             COLUMN 137,g_x[70],# 項次
##             COLUMN 142,g_x[71],# 驗收日期 
##             COLUMN 151,g_x[72] # 溢(跌)價金額
#
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],   
#             g_x[39],g_x[40],g_x[41],g_x[42]   
##No.FUN-670067-end 
#       
#      #PRINT "成本分群 料    號                       單位 數    量        期末存貨成本    存貨單位成本 市    價     市價總成本      驗收單號         項次 驗收日期 溢(跌)價金額"
##       PRINT "-------- ------------------------------ ---- --------------- --------------- ------------ ------------ --------------- ---------------- ---- -------- ---------------"
#        PRINT g_dash1   #No.FUN-670067 
#       LET l_last_sw = 'n'
#
##No.FUN-670067-begin 
#   ON EVERY ROW
##      PRINT COLUMN 01,sr.ima12,
##            COLUMN 05,sr.ima06,
##            COLUMN 10,sr.ccc.ccc01,
##            COLUMN 41,sr.ima25,
##            COLUMN 46,sr.ccc.ccc91 USING '###,###,##&.&&&',
##            COLUMN 62,sr.ccc.ccc92 USING '###,###,##&.&&&',
##            COLUMN 78,sr.ccc.ccc23 USING '####&.&&&&&&',
##            COLUMN 91,sr.apb081    USING '####&.&&&&&&',
##            COLUMN 104,sr.tot       USING '###,###,##&.&&&',
##            COLUMN 120,sr.apb21,
##            COLUMN 137,sr.apb22 USING '###&',
##            COLUMN 142,sr.apa02 USING 'YY/MM/DD',' ',
##            COLUMN 151,sr.lcm   USING '---,---,--&.&&&'
#
#      PRINT COLUMN g_c[31],sr.ima12,sr.ima06,                                                
#            COLUMN g_c[32],sr.ccc.ccc01,                                             
#            COLUMN g_c[33],sr.ima25,                                                 
#            COLUMN g_c[34],cl_numfor(sr.ccc.ccc91,34,g_ccz.ccz27), #CHI-690007 USING '###,###,##&.&&&',                     
#            COLUMN g_c[35],sr.ccc.ccc92 USING '###,###,##&.&&&',                     
#            COLUMN g_c[36],sr.ccc.ccc23 USING '####&.&&&&&&',                        
#            COLUMN g_c[37],sr.apb081    USING '####&.&&&&&&',                        
#            COLUMN g_c[38],sr.tot       USING '###,###,##&.&&&',                    
#            COLUMN g_c[39],sr.apb21,                                                
#            COLUMN g_c[40],sr.apb22 USING '###&',                                   
#            COLUMN g_c[41],sr.apa02 USING 'YY/MM/DD',' ',                           
#            COLUMN g_c[42],sr.lcm   USING '---,---,--&.&&&' 
##No.FUN-670067-end
#
#   AFTER GROUP OF sr.ima12   #材料/成品小計
# 
#      PRINT COLUMN 1, g_dash2[1,g_len] CLIPPED
#      #PRINT '                       分群碼小計：',
##No.FUN-670067-begin
#      PRINT COLUMN g_c[32],g_x[73],
#            COLUMN g_c[34],cl_numfor(GROUP SUM(sr.ccc.ccc91),34,g_ccz.ccz27), #CHI-690007 USING '###,###,##&.&&&',' ',  #No.FUN-670067
#            COLUMN g_c[35],GROUP SUM(sr.ccc.ccc92) USING '###,###,##&.&&&',      #No.FUN-670067
##            '                           ',                                      #No.FUN-670067
#            COLUMN g_c[38],GROUP SUM(sr.tot)       USING '###,###,##&.&&&',      #No.FUN-670067
##            '                                ',                                 #No.FUN-670067
#            COLUMN g_c[42],GROUP SUM(sr.lcm)       USING '---,---,--&.&&&'       #No.FUN-670067
#      PRINT
##No.FUN-670067-end
#  
#   ON LAST ROW
##      PRINT g_dash[1,g_len] CLIPPED
#      #PRINT '                             總計：',
##No.FUN-670067-begin
#      PRINT COLUMN g_c[32],g_x[74],
#            COLUMN g_c[34],cl_numfor(SUM(sr.ccc.ccc91),34,g_ccz.ccz27), #CHI-690007 USING '###,###,##&.&&&',' ',
#            COLUMN g_c[35],SUM(sr.ccc.ccc92) USING '###,###,##&.&&&',
##            '                           ',
#            COLUMN g_c[38],SUM(sr.tot)       USING '###,###,##&.&&&',
##            '                                 ',
#            COLUMN g_c[42],SUM(sr.lcm)       USING '---,---,--&.&&&'
##No.FUN-670067-end
#      LET l_last_sw = 'y'
#      PRINT g_dash                                              #No.FUN-670067 
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END RE

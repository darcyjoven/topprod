# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr405.4gl
# Descriptions...: 多欄式明細帳
# Date & Author..: 06/10/10 By Carrier
# Modify.........: No.FUN-6C0012 06/12/30 By Judy 報表加入打印額外名稱
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-710101 07/03/20 By wujie 不關閉程序再次打印，會導致余額與上次結果累加
# Modify.........: No.FUN-740055 07/04/12 By lora  會計科目加帳套-財務
# Modify.........: No.FUN-7C0064 07/12/27 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-8B0123 08/11/12 By Sarah 將r405_file裡的abb04欄位放大成CHAR(40)
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-860252 09/02/18 By chenl 增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C10039 12/01/16 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.MOD-C20064 12/02/09 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片还原
# Modify.........: No.TQC-C80045 12/08/06 By lujh 打印報表，報錯“ins r405_file Message number -6372 not found.”
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              a       LIKE mai_file.mai01,  #報表結構編號
              b       LIKE aaa_file.aaa01,  #帳別編號
              yy      LIKE type_file.num5,  #輸入年度
              bm      LIKE type_file.num5,  #Begin 期別
              em      LIKE type_file.num5,  # End  期別
              e       LIKE type_file.chr1,  #FUN-6C0012
              h       LIKE type_file.chr1,  #MOD-860252
              more    LIKE type_file.chr1   #Input more condition(Y/N)
              END RECORD,
          g_flag     LIKE type_file.chr1,   #最后科目所在頁
          g_flag1    LIKE type_file.chr1,   #第一科目所在頁
          g_flag2    VARCHAR(01),              #No.TQC-710101
          g_bookno   LIKE aah_file.aah00,   #帳別
          m_acc      LIKE type_file.chr1000,
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_no       LIKE type_file.num5,
          g_acc      DYNAMIC ARRAY OF RECORD 
		     maj21 LIKE maj_file.maj21, 
		     maj20 LIKE type_file.chr20,
                     maj20e LIKE type_file.chr20  #FUN-6C0012
		     END RECORD
    DEFINE l_amt1       LIKE abb_file.abb07        #No.TQC-710101   
 
DEFINE g_i           LIKE type_file.num5   #count/index for any purpose
DEFINE g_cnt         LIKE type_file.num5   #count/index for any purpose
DEFINE g_table1      STRING                #No.FUN-7C0064
DEFINE g_table2      STRING                #No.FUN-7C0064
DEFINE g_str         STRING                #No.FUN-7C0064
DEFINE g_sql         STRING                #No.FUN-7C0064
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.yy   = ARG_VAL(10)
   LET tm.bm   = ARG_VAL(11)
   LET tm.em   = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   #No.FUN-7C0064  --Begin
   LET g_sql = " aba02.aba_file.aba02,",
               " aba01.aba_file.aba01,",
               " abb04.abb_file.abb04,",
               " abb07.abb_file.abb07,",
               " abb071.abb_file.abb07,",
               " abb06.abb_file.abb06,",
               " str.type_file.chr1000,",
               " head.type_file.chr1000,",
               " l_i.type_file.num5 "
#              "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #TQC-C10039 #MOD-C20064 Mark TQC-C10039
#              "sign_show.type_file.chr1,sign_str.type_file.chr1000"    #是否顯示簽核資料(Y/N)  #TQC-C10039 #MOD-C20064 Mark TQC-C10039
 
   LET g_table1 = cl_prt_temptable('gglr4051',g_sql) CLIPPED
   IF g_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_table2 = cl_prt_temptable('gglr4052',g_sql) CLIPPED
   IF g_table2 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-7C0064  --End
 
   DROP TABLE r405_file
   #cnt 第幾張憑証
   #i   套表上的第幾張格式
   #no  每張套表上的第幾列
   CREATE TEMP TABLE r405_file(
       cnt       LIKE type_file.num5,
       i         LIKE type_file.num5,
       no        LIKE type_file.num5,
       aba02     LIKE aba_file.aba02,    #TQC-C80045  mod  LIKE type_file.dat  to  aba_file.aba02 
       aba01     LIKE aba_file.aba01,    #TQC-C80045  mod  LIKE type_file.chr12 to aba_file.aba01 
       abb04     LIKE abb_file.abb04,    #MOD-8B0123 mod #LIKE type_file.chr30,
       abb07     LIKE type_file.num20_6,
       abb06     LIKE type_file.chr1);
     
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   
   #No.FUN-740055  --Begin                                                                                                          
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF                                                                                
   #No.FUN-740055  --End                            

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r405_tm()                           # Input print condition
   ELSE
      CALL r405()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r405_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1,          #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5           #FUN-6C0068
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 4 LET p_col = 38
 
   OPEN WINDOW r405_w AT p_row,p_col WITH FORM "ggl/42f/gglr405" 
        ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
#  LET tm.b = g_bookno    #No.FUN-740055
   LET tm.b = g_aza.aza81 #No.FUN-740055
   LET tm.yy= YEAR(g_today)
   LET tm.bm= MONTH(g_today)
   LET tm.em= MONTH(g_today)
   LET tm.e = 'N'   #FUN-6C0012
   LET tm.h = 'Y'   #MOD-860252
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.e,tm.h,tm.more  #FUN-6C0012   #No.FUN-740055 #No.MOD-860252 add tm.h
		  WITHOUT DEFAULTS  
       ON ACTION locale
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
       #FUN-6C0068--begin
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
       #FUN-6C0068--end
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
          WHERE mai01 = tm.a AND maiacti IN ('Y','y')
            AND mai00 = tm.b  #No.FUN-740055
     #   IF STATUS THEN CALL cl_err('sel mai:',STATUS,0) NEXT FIELD a END IF          #No.FUN-740055  
         IF STATUS THEN CALL cl_err3("sel","mai_file",tm.a,tm.b,STATUS,"","sel mai:",0) NEXT FIELD a END IF   #No.FUN-740055
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN CALL cl_err('sel aaa:',STATUS,0) NEXT FIELD b END IF
        
      AFTER FIELD yy
         IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
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
         IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#         IF tm.bm <1 OR tm.bm > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD bm
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
         IF cl_null(tm.em) THEN NEXT FIELD em END IF
#No.TQC-720032 -- begin --
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT 
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.yy) THEN
            LET l_sw = 0 
            DISPLAY BY NAME tm.yy 
            CALL cl_err('',9033,0)
         END IF
         IF cl_null(tm.bm) THEN
            LET l_sw = 0 
            DISPLAY BY NAME tm.bm 
         END IF
         IF cl_null(tm.em) THEN
            LET l_sw = 0 
            DISPLAY BY NAME tm.em 
        END IF
        IF l_sw = 0 THEN 
            LET l_sw = 1 
            NEXT FIELD a
            CALL cl_err('',9033,0)
        END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
               LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740055
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
 
            WHEN INFIELD(b) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
               DISPLAY BY NAME tm.b
               NEXT FIELD b
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about    
         CALL cl_about()  
 
      ON ACTION help    
         CALL cl_show_help()
   
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r405_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gglr405'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglr405','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'" ,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'" 
         CALL cl_cmdat('gglr405',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r405_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r405()
   ERROR ""
END WHILE
   CLOSE WINDOW r405_w
END FUNCTION
 
FUNCTION r405()
   DEFINE l_name             LIKE type_file.chr20          # External(Disk) file name
   DEFINE l_name1            LIKE type_file.chr20          # External(Disk) file name
   DEFINE l_name2            LIKE type_file.chr20          # External(Disk) file name
   DEFINE #l_sql              LIKE type_file.chr1000        # RDSQL STATEMENT
          l_sql       STRING     #No.FUN-910082
   DEFINE l_maj21            LIKE maj_file.maj21
   DEFINE l_maj20            LIKE type_file.chr20
   DEFINE l_maj20e           LIKE type_file.chr20          #FUN-6C0012
   DEFINE l_leng,l_leng2     LIKE type_file.num5 
   DEFINE l_aba01            LIKE aba_file.aba01
   DEFINE l_aba02            LIKE aba_file.aba02
   DEFINE sr                 RECORD
                             no     LIKE type_file.num5,
                             aba02  LIKE aba_file.aba02,
                             aba01  LIKE aba_file.aba01,
                             abb04  LIKE abb_file.abb04,
                             abb07  LIKE abb_file.abb07,
                             abb071 LIKE abb_file.abb07,
                             abb06  LIKE abb_file.abb06 
                             END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5   LIKE type_file.chr12
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10  LIKE type_file.chr12
   DEFINE l_str11,l_str12,l_str13              LIKE type_file.chr12
   DEFINE l_str                                LIKE type_file.chr1000
   DEFINE l_no,l_cn,l_cnt,l_i,l_j,l_k          LIKE type_file.num5 
   DEFINE l_cmd                                LIKE type_file.chr1000
   DEFINE l_cmd1                               LIKE type_file.chr1000  
   DEFINE l_cmd2                               LIKE type_file.chr1000
   DEFINE l_maj20_o                            LIKE type_file.chr20
   DEFINE l_maj20e_o                           LIKE type_file.chr20  #FUN-60012
#   DEFINE l_img_blob     LIKE type_file.blob    #TQC-C10039 #MOD-C20064 Mark TQC-C10039

   #No.FUN-B80096--mark--Begin---
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #No.FUN-B80096--mark--End-----
   #No.FUN-7C0064  --Begin
   CALL cl_del_data(g_table1)
   CALL cl_del_data(g_table2)
#   LOCATE l_img_blob IN MEMORY    #TQC-C10039  #MOD-C20064 Mark TQC-C10039

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,g_table1 CLIPPED,
#               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)    "   #TQC-C10039 add 4? #MOD-C20064 Mark TQC-C10039
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,g_table2 CLIPPED,
#               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?)    "   #TQC-C10039 add 4?  #MOD-C20064 Mark TQC-C10039
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)" 
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-7C0064  --End
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
   #No.FUN-7C0064  --Begin
   #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr405'
   #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 250 END IF 
   #FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
 
   #CALL cl_outnam('gglr405') RETURNING l_name
   #CALL cl_outnam('gglr405_1') RETURNING l_name1       #No.TQC-710101
   #CALL cl_outnam('gglr405_2') RETURNING l_name2       #No.TQC-710101
   #No.FUN-7C0064  --End  
 
#將科目填入array------------------------------------
   LET g_no=0
   CALL g_acc.clear()
   CALL cl_prt_pos_len()
 
   DECLARE r405_bom1 CURSOR FOR
    SELECT maj21,maj20[1,20],maj20e[1,20] FROM maj_file WHERE maj01=tm.a  #FUN-6C0012
     ORDER BY 1
   FOREACH r405_bom1 INTO l_maj21,l_maj20,l_maj20e  #FUN-6C0012
     IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
     LET g_no = g_no + 1
     #第一頁僅打印6個科目,但是為了后續處理方便,故在第一頁的科目虛增至13個
     IF g_no = 7 THEN    
        FOR l_i = 7 TO 13
           LET g_acc[l_i].maj21 = NULL
           LET g_acc[l_i].maj20 = NULL
           LET g_acc[l_i].maj20e= NULL  #FUN-6C0012
        END FOR
        LET g_no = 14
     END IF
     LET g_acc[g_no].maj21 = l_maj21
     LET g_acc[g_no].maj20 = l_maj20
     LET g_acc[g_no].maj20e= l_maj20e   #FUN-6C0012
   END FOREACH
#---------------------------------------------------
 
   DECLARE r405_aba_cur CURSOR FOR
    SELECT aba02,aba01,cnt FROM r405_file
     ORDER BY aba02,aba01
 
   DELETE FROM r405_file
   LET g_cnt = 1
 
#控制一次印十三個科目---------------------------------
   IF g_no MOD 13 = 0 THEN
      LET l_cnt = g_no
   ELSE
      LET l_cnt=(13-(g_no MOD 13))+g_no     ###一行 13 個
   END IF
   FOR l_i = 13 TO l_cnt STEP 13
       #最后一頁是否滿13個科目
       IF l_i > g_no THEN
          LET l_k = g_no - (l_i - 13)
       ELSE
          LET l_k = 13
       END IF
       LET l_no = l_i - 13
       FOR l_cn = 1 TO l_k
           LET l_maj21= g_acc[l_no+l_cn].maj21
           CALL r405_process(l_i,l_cn,l_maj21)
       END FOR
   END FOR
 
   FOR l_i = 13 TO l_cnt STEP 13
       LET g_flag = 'n'
       LET g_flag1= 'n'
 
       LET m_acc = ''
       #是否為第一頁
       IF l_i = 13 THEN
          LET g_flag1 = 'y'
       END IF
 
       #最后一頁是否滿13個科目
       IF l_i > g_no THEN
          LET l_k = g_no - (l_i - 13)
       ELSE
          LET l_k = 13
       END IF
 
#       LET l_name1='r405_',l_i/13 USING '&&&','.out'
#       LET l_name2='r405_2_',l_i/13 USING '&&&','.out''
 
       #No.FUN-7C0064  --Begin
       #IF g_flag1 = 'n' THEN
       #   START REPORT r405_rep1 TO l_name1
       #ELSE
       #   START REPORT r405_rep2 TO l_name2
       #END IF
       #LET g_pageno = 0
       #No.FUN-7C0064  --End  
 
       LET l_no = l_i - 13
       FOR l_cn = 1 TO l_k
           LET l_maj20= g_acc[l_no+l_cn].maj20
           LET l_maj20e= g_acc[l_no+l_cn].maj20e  #FUN-6C0012
           LET l_leng2 = LENGTH(l_maj20_o)
           LET l_leng2 = LENGTH(l_maj20e_o)       #FUN-6C0012
           LET l_leng2 = 11 - l_leng2
           IF l_cn = 1 THEN
              IF tm.e = 'N' THEN      #FUN-6C0012 
                 LET m_acc = l_maj20
              ELSE                    #FUN-6C0012                               
                 LET m_acc = l_maj20e #FUN-6C0012                               
              END IF                  #FUN-6C0012
           ELSE 
              IF tm.e = 'N' THEN      #FUN-6C0012
                 LET m_acc = m_acc  CLIPPED,l_leng2 SPACES,1 SPACES,l_maj20
              ELSE                    #FUN-6C0012                               
                 LET m_acc = m_acc  CLIPPED,l_leng2 SPACES,1 SPACES,l_maj20e  #FUN-6C0012
              END IF                  #FUN-6C0012
           END IF
           LET l_maj20_o = l_maj20
           LET l_maj20e_o= l_maj20e   #FUN-6C0012 
       END FOR
       LET m_acc = m_acc CLIPPED
 
       #foreach 所有的憑証
       FOREACH r405_aba_cur INTO l_aba02,l_aba01,l_j  
         IF STATUS THEN 
            CALL cl_err('foreach r405_aba_cur',STATUS,1)
            EXIT FOREACH
         END IF
         INITIALIZE sr.* TO NULL
         LET sr.aba02 = l_aba02
         LET sr.aba01 = l_aba01
         SELECT abb07 INTO sr.abb071
           FROM r405_file
          WHERE cnt = l_j  
         IF cl_null(sr.abb071) THEN LET sr.abb071 = 0 END IF
         SELECT abb04,abb07,abb06,no INTO sr.abb04,sr.abb07,sr.abb06,sr.no 
           FROM r405_file
          WHERE cnt = l_j  
            AND i   = l_i
         IF cl_null(sr.abb07) THEN LET sr.abb07 = 0 END IF
       
         LET l_str1 = '' LET l_str2 = '' LET l_str3 = ''
         LET l_str4 = '' LET l_str5 = '' LET l_str6 = ''
         LET l_str7 = '' LET l_str8 = '' LET l_str9 = ''
         LET l_str10= '' LET l_str11= '' LET l_str12= '' LET l_str13= ''
         CASE sr.no
             WHEN 1  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str1
             WHEN 2  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str2
             WHEN 3  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str3
             WHEN 4  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str4
             WHEN 5  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str5
             WHEN 6  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str6
             WHEN 7  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str7
             WHEN 8  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str8
             WHEN 9  CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str9
             WHEN 10 CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str10
             WHEN 11 CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str11
             WHEN 12 CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str12
             WHEN 13 CALL cl_numfor(sr.abb07,10,g_azi04) RETURNING l_str13
         END CASE
         IF l_str1  IS NULL THEN LET l_str1 ='            ' END IF
         IF l_str2  IS NULL THEN LET l_str2 ='            ' END IF
         IF l_str3  IS NULL THEN LET l_str3 ='            ' END IF
         IF l_str4  IS NULL THEN LET l_str4 ='            ' END IF
         IF l_str5  IS NULL THEN LET l_str5 ='            ' END IF
         IF l_str6  IS NULL THEN LET l_str6 ='            ' END IF
         IF l_str7  IS NULL THEN LET l_str7 ='            ' END IF
         IF l_str8  IS NULL THEN LET l_str8 ='            ' END IF
         IF l_str9  IS NULL THEN LET l_str9 ='            ' END IF
         IF l_str10 IS NULL THEN LET l_str10='            ' END IF
         IF l_str11 IS NULL THEN LET l_str11='            ' END IF
         IF l_str12 IS NULL THEN LET l_str12='            ' END IF
         IF l_str13 IS NULL THEN LET l_str13='            ' END IF
 
         LET l_str = l_str1 ,l_str2 ,l_str3 ,
                     l_str4 ,l_str5 ,l_str6 ,
                     l_str7 ,l_str8 ,l_str9 ,
                     l_str10 
         IF g_flag1 = 'n' THEN
            LET g_flag2 ='1'                    #TQC-710101
            #No.FUN-7C0064  --Begin
            #OUTPUT TO REPORT r405_rep1(sr.aba02,sr.aba01,sr.abb04,
            #                           sr.abb07,sr.abb071,sr.abb06,l_str)
            EXECUTE insert_prep1 USING sr.aba02,sr.aba01,sr.abb04,
                    sr.abb07,sr.abb071,sr.abb06,l_str,m_acc,l_i
#                    "",l_img_blob,"N",""    #TQC-C10039 add "",l_img_blob,"N",""  #MOD-C20064 Mark TQC-C10039
            #No.FUN-7C0064  --End  
         ELSE 
            LET g_flag2 ='1'                    #TQC-710101
            #No.FUN-7C0064  --Begin
            #OUTPUT TO REPORT r405_rep2(sr.aba02,sr.aba01,sr.abb04,
            #                           sr.abb07,sr.abb071,sr.abb06,l_str)
            EXECUTE insert_prep  USING sr.aba02,sr.aba01,sr.abb04,
                    sr.abb07,sr.abb071,sr.abb06,l_str,m_acc,l_i
#                    "",l_img_blob,"N",""    #TQC-C10039 add "",l_img_blob,"N","" #MOD-C20064 Mark TQC-C10039
            #No.FUN-7C0064  --End  
         END IF
       END FOREACH
 
       #No.FUN-7C0064  --Begin
       #IF g_flag1 = 'n' THEN
       #   FINISH REPORT r405_rep1
       #ELSE
       #   FINISH REPORT r405_rep2
       #END IF
 
       ####結合報表
       #IF l_i/13 = 1 THEN
       #   LET l_cmd1='cat ',l_name1
       #   LET l_cmd2='cat ',l_name2
       #ELSE
       #   LET l_cmd1=l_cmd1 CLIPPED,' ',l_name1
       #   LET l_cmd2=l_cmd2 CLIPPED,' ',l_name2
       #END IF
       #No.FUN-7C0064  --End  
   END FOR
 
   IF NOT cl_confirm('ggl-004') THEN 
      #No.FUN-7C0064  --Begin
      #LET l_cmd2=l_cmd2 CLIPPED,' > ',l_name
      #RUN l_cmd2
      #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      #LET l_cmd1=l_cmd1 CLIPPED,' > ',l_name
      #RUN l_cmd1
      #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      CALL r405_r1()
      CALL cl_err('','ggl-005',1)
      CALL r405_r2()
      #No.FUN-7C0064  --End  
   ELSE
      IF g_flag2 ='1' THEN #No.TQC-710101
         #No.FUN-7C0064  --Begin
         #LET l_cmd2=l_cmd2 CLIPPED,' > ',l_name
         #RUN l_cmd2
         #LET l_cmd1=l_cmd1 CLIPPED,' >> ',l_name
         #RUN l_cmd1
         #CALL r405_prt_v(l_name)
         #LET l_cmd2=l_cmd2 CLIPPED,' > ',l_name
         #RUN l_cmd2
         #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
         #CALL cl_err('','ggl-005',1)
         #LET l_cmd1=l_cmd1 CLIPPED,' > ',l_name
         #RUN l_cmd1
         #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
         CALL r405_r1()
         CALL cl_err('','ggl-005',1)
         CALL r405_r2()
         #No.FUN-7C0064  --End  
      ELSE
       	 CALL cl_err('','agl-115',1) 
      END IF    #No.TQC-710101
   END IF
 
      LET l_amt1 =NULL    #No.TQC-710101 
   #No.FUN-B80096--mark--Begin---  
   #CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #No.FUN-B80096--mark--End-----
END FUNCTION
 
FUNCTION r405_prt_v(p_name)
   DEFINE p_name             LIKE type_file.chr20
   DEFINE l_cmd              STRING
 
      LET l_cmd = "p_view '" , p_name CLIPPED , "' '" , g_page_line , "' '" , g_idle_seconds , "'"
      CALL cl_cmdrun_wait(l_cmd)
END FUNCTION  
 
FUNCTION r405_process(l_i,l_cn,l_maj21)
   DEFINE #l_sql,l_sql1   LIKE type_file.chr1000
          l_sql,l_sql1       STRING     #No.FUN-910082
   DEFINE l_cn,l_i       LIKE type_file.num5 
   DEFINE maj            RECORD LIKE maj_file.*
   DEFINE l_maj21        LIKE maj_file.maj21
   DEFINE sr1            RECORD
                         aba02  LIKE aba_file.aba02,
                         aba01  LIKE aba_file.aba01,
                         abb04  LIKE abb_file.abb04,
                         abb07  LIKE abb_file.abb07,
                         abb06  LIKE abb_file.abb06 
                         END RECORD
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"' AND maj21='",l_maj21,"' ",
               "   ORDER BY maj21 "
   PREPARE r405_p FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE r405_c CURSOR FOR r405_p
 
   FOREACH r405_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF NOT cl_null(maj.maj21) THEN
         LET l_sql1 = "SELECT aba02,aba01,abb04,abb07,abb06 ",
                      "  FROM aba_file,abb_file,aag_file",
                      " WHERE aba00 = '",tm.b,"'",
                      "   AND abb03 = '",maj.maj21,"'", 
                      "   AND aba03 = ",tm.yy,
                      "   AND aba04 BETWEEN ",tm.bm," AND ",tm.em,
                      "   AND abb03 = aag01 AND aag07 IN ('2','3')",
                      "   AND aba01 = abb01 AND aba00 = abb00 ",
                      "   AND aba00 = aag00 ",        # No.FUN-740055
                      "   AND abaacti = 'Y'",
                      "   AND aba19 <> 'X' "  #CHI-C80041
         #No.MOD-860252--begin--
         IF tm.h = 'Y' THEN 
            LET l_sql = l_sql , " AND aag09='Y'  "
         END IF 
         #No.MOD-860252---end---
         PREPARE r405_sum FROM l_sql1
         DECLARE r405_sumc CURSOR FOR r405_sum
         FOREACH r405_sumc INTO sr1.*
            IF STATUS THEN CALL cl_err('fetch #1',STATUS,1) EXIT FOREACH END IF
            IF cl_null(sr1.abb07) THEN LET sr1.abb07 = 0 END IF
            IF maj.maj07 = '1' AND sr1.abb06="2" THEN
               LET sr1.abb07 = sr1.abb07 * -1
            END IF
     
            IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
            INSERT INTO r405_file VALUES(g_cnt,l_i,l_cn,sr1.aba02,sr1.aba01,
                                         sr1.abb04,sr1.abb07,sr1.abb06)
            IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('ins r405_file',STATUS,1) EXIT FOREACH
            END IF
            LET g_cnt = g_cnt + 1
         END FOREACH
      END IF
   END FOREACH
END FUNCTION
 
REPORT r405_rep1(sr)
   DEFINE l_last_sw    LIKE type_file.chr1
#  DEFINE l_amt1       LIKE abb_file.abb07      #No.TQC-710101
   DEFINE sr           RECORD
                         aba02  LIKE aba_file.aba02,
                         aba01  LIKE aba_file.aba01,
                         abb04  LIKE abb_file.abb04,
                         abb07  LIKE abb_file.abb07,
                         abb071 LIKE abb_file.abb07,
                         abb06  LIKE abb_file.abb06,
                         str    LIKE type_file.chr1000
                       END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN 0 BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aba02,sr.aba01
  FORMAT
   PAGE HEADER
      PRINT '~T28X0L19;',(172-length(g_company))/2 SPACES,g_company
      #金額單位之列印
      IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
      PRINT COLUMN 13,g_x[15] CLIPPED,tm.a,COLUMN (172-length(g_x[1]))/2,
            g_x[1] CLIPPED
      LET g_pageno = g_pageno + 1
      PRINT COLUMN 13,g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN 86,tm.yy USING '<<<<'
      PRINT COLUMN 162,g_pageno USING '<<<'
      DISPLAY "m_acc=",m_acc
         PRINT ''
         PRINT COLUMN 14,m_acc
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN 13,sr.str CLIPPED
 
END REPORT
 
REPORT r405_rep2(sr)
   DEFINE l_last_sw    LIKE type_file.chr1
#  DEFINE l_amt1       LIKE abb_file.abb07      #No.TQC-710101
   DEFINE sr           RECORD
                         aba02  LIKE aba_file.aba02,
                         aba01  LIKE aba_file.aba01,
                         abb04  LIKE abb_file.abb04,
                         abb07  LIKE abb_file.abb07,
                         abb071 LIKE abb_file.abb07,
                         abb06  LIKE abb_file.abb06,
                         str    LIKE type_file.chr1000
                       END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN 0 BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.aba02,sr.aba01
  FORMAT
   PAGE HEADER
      PRINT '~T28X0L19;',(172-length(g_company))/2 SPACES,g_company
      #金額單位之列印
      IF g_aaz.aaz77 = 'Y' THEN LET g_x[1] = g_mai02 END IF
      PRINT COLUMN 13,g_x[15] CLIPPED,tm.a,COLUMN (172-length(g_x[1]))/2,
            g_x[1] CLIPPED
      LET g_pageno = g_pageno + 1
      PRINT COLUMN 13,g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN 86,tm.yy USING '<<<<'
      PRINT COLUMN 162,g_pageno USING '<<<'
      DISPLAY "m_acc=",m_acc
         PRINT ''
         PRINT COLUMN 102,m_acc
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      IF l_amt1 IS NULL THEN LET l_amt1=0 END IF
      LET l_amt1=l_amt1+sr.abb071
         PRINT COLUMN 13,MONTH(sr.aba02) USING "&&",
               COLUMN 16,DAY(sr.aba02)   USING "&&",
               COLUMN 19,sr.aba01,
               COLUMN 32,sr.abb04 CLIPPED;
         IF sr.abb06 = '1' THEN
            PRINT COLUMN 52,cl_numfor(sr.abb071,14,g_azi04) CLIPPED;
         ELSE
            PRINT COLUMN 67,cl_numfor(sr.abb071,14,g_azi04) CLIPPED;
         END IF
         IF sr.abb071>0 THEN
            PRINT COLUMN 83,"1";
         ELSE
            PRINT COLUMN 83,"2";
         END IF
         PRINT COLUMN 85, cl_numfor(l_amt1,14,g_azi04) CLIPPED;
         PRINT COLUMN 101,sr.str CLIPPED
 
END REPORT
 
#No.FUN-7B0064  --Begin
FUNCTION r405_r1()
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,g_table1 CLIPPED
     LET g_str = ''
     LET g_str = g_azi04,";",g_aaz.aaz77,";",g_mai02,";",
                 tm.a,";",tm.yy
#     LET g_cr_table =g_table1                 #主報表的temp table名稱   #TQC-C100399  #MOD-C20064 Mark TQC-C10039
#     LET g_cr_apr_key_f = "aba01"             #報表主鍵欄位名稱   #TQC-C10039  #MOD-C20064 Mark TQC-C10039
     CALL cl_prt_cs3('gglr405','gglr405',g_sql,g_str)
END FUNCTION
 
FUNCTION r405_r2()
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,g_table2 CLIPPED
     LET g_str = ''
     LET g_str = g_azi04,";",g_aaz.aaz77,";",g_mai02,";",
                 tm.a,";",tm.yy
#     LET g_cr_table = g_table2                 #主報表的temp table名稱   #TQC-C100399  #MOD-C20064 Mark TQC-C10039
#     LET g_cr_apr_key_f = "aba01"             #報表主鍵欄位名稱   #TQC-C10039  #MOD-C20064 Mark TQC-C10039
     CALL cl_prt_cs3('gglr405','gglr405_1',g_sql,g_str)
END FUNCTION
#No.FUN-7B0064  --End  

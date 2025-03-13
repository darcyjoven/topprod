# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimr505.4gl
# Descriptions...: 料件 BIN 卡 (依單據日期,明細-負庫存)
# Date & Author..: 02/04/12 by plum
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580005 05/08/12 By day    報表轉xml
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-750110 07/06/21 By dxfwo CR報表的制作
# Modify.........: No.MOD-850106 08/05/12 By claire 選擇依單據日期列印時,只會印出一筆資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0189 09/10/30 By wujie 5.2SQL转标准语法
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
# Modify.........: No.MOD-B60094 11/06/13 By Vampire FOREACH aimr505_curs1 的 q1 和 q2 WHERE 條件加上 tlf907 <> 0
# Modify.........: No:MOD-B40229 11/07/19 By sabrina 若期初有值，但tlf無異動資料，也應該要產生報表
# Modify.........: No:MOD-C40179 12/04/23 By ck2yuan 若同一天多筆tlf使庫存變正數,那天全部tlf應不存入temp table中
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm            RECORD                           # Print condition RECORD
                     wc        LIKE type_file.chr1000,# Where condition  #No.FUN-690026 VARCHAR(500)
                     b_date    LIKE type_file.dat,    # 資料起           #No.FUN-690026 DATE
                     e_date    LIKE type_file.dat,    # 資料迄           #No.FUN-690026 DATE
                     choice    LIKE type_file.chr1,   # 資料格式:1.依單據日期  2.依明細  #No.FUN-690026 VARCHAR(1)
                     type      LIKE type_file.chr1,   # 是否只印負庫存資料#No.FUN-690026 VARCHAR(1)
                     page_skip LIKE type_file.chr1,   # 不同料號是否跳頁  #No.FUN-690026 VARCHAR(1)
                     more      LIKE type_file.chr1    # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                     END RECORD,
       g_y,g_m       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       last_y,last_m LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_start,g_end LIKE type_file.dat      #No.FUN-690026 DATE
 
DEFINE g_chr         LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   l_table     STRING                  #No.FUN-750110                                                                       
DEFINE   g_sql       STRING                  #No.FUN-750110                                                                       
DEFINE   g_str       STRING                  #No.FUN-750110
MAIN
   OPTIONS
 
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
  #No.FUN-750110--begin--                                                                                                            
  LET g_sql = " num5.type_file.num5 ,", 
              " tlf06.tlf_file.tlf06,",
              " ze03.ze_file.ze03,",
              " tlf026.tlf_file.tlf026,",                                                                                             
              " tlf036.tlf_file.tlf036,",                                                                                             
              " tlf10.tlf_file.tlf10,",                                                                                             
              " tlf11.tlf_file.tlf11,",                                                                                             
              " tlf19.tlf_file.tlf19,",                                                                                             
              " tlf034.tlf_file.tlf034,",                                                                                             
              " img01.img_file.img01,",
              " img02.img_file.img02,",
              " img03.img_file.img03,",
              " img04.img_file.img04,",
              " imk09.imk_file.imk09,",                                                                                                 
              " flag.type_file.chr1 "        #MOD-B40229 add
   LET l_table = cl_prt_temptable('aimr505',g_sql) CLIPPED                                                                           
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"       #MOD-B40229 add ?                                                                                       
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #No.FUN-750110--end-- 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b_date = ARG_VAL(8)
   LET tm.e_date = ARG_VAL(9)
   LET tm.choice = ARG_VAL(10)
   LET tm.type   = ARG_VAL(11)
   LET tm.page_skip = ARG_VAL(12)
  #LET tm.more = ARG_VAL(13)              #TQC-610072 順序順推
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF g_bgjob='Y' THEN
      CALL aimr505()
    ELSE
      CALL aimr505_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr505_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW aimr505_w AT p_row,p_col WITH FORM "/aim/42f/aimr505"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   SELECT azn02,azn04 INTO g_y,g_m FROM azn_file WHERE azn01=g_today
   CALL s_azm(g_y,g_m) RETURNING g_chr,tm.b_date,tm.e_date
   LET tm.choice = '1'
   LET tm.type   = 'Y'
   LET tm.page_skip = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   #DELETE FROM r505_tmp
   CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04,ima23,ima08
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(img01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img01
               NEXT FIELD img01
            END IF
#No.FUN-570240 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr505_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.b_date,tm.e_date,tm.choice,tm.type,tm.page_skip,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b_date
         IF cl_null(tm.b_date) THEN NEXT FIELD b_date END IF
         IF cl_null(tm.e_date) THEN
            LET tm.e_date = tm.b_date DISPLAY BY NAME tm.e_date
         END IF
      AFTER FIELD e_date
         IF cl_null(tm.e_date) THEN NEXT FIELD e_date END IF
         IF tm.e_date < tm.b_date THEN NEXT FIELD b_date END IF
      AFTER FIELD choice
         IF cl_null(tm.choice) OR tm.choice NOT MATCHES '[12]' THEN
            NEXT FIELD choice
         END IF
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[YN]' THEN
            NEXT FIELD type
         END IF
      AFTER FIELD page_skip
         IF cl_null(tm.page_skip) OR tm.page_skip NOT MATCHES '[YN]' THEN
            NEXT FIELD page_skip
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
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
   SELECT azn02,azn04 INTO g_y,g_m FROM azn_file WHERE azn01=tm.b_date
   CALL s_azm(g_y,g_m) RETURNING g_chr,g_start,g_end
   LET last_y=g_y LET last_m=g_m
   LET last_m = last_m - 1
   IF last_m = 0 THEN
      LET last_y = last_y - 1
      IF g_aza.aza02='1' THEN LET last_m = 12 ELSE LET last_m = 13 END IF
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimr505_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr505'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr505','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.b_date CLIPPED,"'" ,
                         " '",tm.e_date CLIPPED,"'" ,
                         " '",tm.choice CLIPPED,"'" ,
                         " '",tm.type   CLIPPED,"'" ,
                         " '",tm.page_skip CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr505',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr505_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr505()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr505_w
END FUNCTION
 
FUNCTION aimr505()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     LIKE type_file.chr1000,       #No.FUN-690026 VARCHAR(1000)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
#         q1,q2     LIKE ima_file.ima26,          #MOD-530179   #FUN-A20044
          q1,q2     LIKE type_file.num15_3,                     #FUN-A20044   
          l_tlf907  LIKE tlf_file.tlf907,
          l_sum     LIKE type_file.num5,          #MOD-C40179 add
          l_flag    LIKE type_file.chr1,          #MOD-B40229 add
          sr        RECORD
                    seq       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
                    img01     LIKE img_file.img01,
                    img02     LIKE img_file.img02,
                    img03     LIKE img_file.img03,
                    img04     LIKE img_file.img04,
                    ima02     LIKE ima_file.ima02,
                    imk09     LIKE imk_file.imk09,
                    tlf06     LIKE tlf_file.tlf06,
                    tlf08     LIKE tlf_file.tlf08,
                    tlf026    LIKE tlf_file.tlf026,
                    tlf036    LIKE tlf_file.tlf036,
                    tlf10     LIKE tlf_file.tlf10,
                    tlf11     LIKE tlf_file.tlf11,
                    tlf13     LIKE tlf_file.tlf13,
                    memo      LIKE ze_file.ze03,    #No.FUN-690026 VARCHAR(14)
                    tlf19     LIKE tlf_file.tlf19,
                    tlf031    LIKE tlf_file.tlf031,
                    tlf032    LIKE tlf_file.tlf032,
                    tlf033    LIKE tlf_file.tlf033,
                    tlf907    LIKE tlf_file.tlf907,
                    bal       LIKE tlf_file.tlf10
                    END RECORD
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT 0,img01,img02,img03,img04,ima02,imk09,",
               "       ' ',' ',' ',' ',0,0,' ',' ',' ',' ',' ',' ',0 ",
               "  FROM ima_file,img_file LEFT OUTER JOIN imk_file ",
               "    ON img01=imk01 AND img02=imk02",
               "   AND img03=imk03 AND img04=imk04",
               "   AND imk05=",last_y," AND imk06=",last_m,
               " WHERE ",tm.wc CLIPPED," AND img01=ima01",
#              " ORDER BY 1,2,3,4"
               " ORDER BY img01,img02,img03,img04"    #No.TQC-9A0189
     PREPARE aimr505_prepare1 FROM l_sql
     IF STATUS  THEN CALL cl_err('prep:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE aimr505_curs1 CURSOR FOR aimr505_prepare1
 
     LET l_sql="SELECT tlf06,tlf08,tlf026,tlf036,tlf10*tlf12,tlf11,tlf13,",
               "tlf19,tlf031,tlf032,tlf033,tlf907",
               " FROM  tlf_file ",
               " WHERE tlf01 =? ",
               "   AND tlf06 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
               "   AND (tlf907 <> 0 ) AND tlf902 = ? ",
               "   AND tlf903 =? AND tlf904=? ",
               " ORDER BY tlf06,tlf907 DESC"
     PREPARE r505_p2 FROM l_sql
     DECLARE r505_c2  SCROLL CURSOR FOR r505_p2

    #MOD-C40179 str add-----
     LET l_sql="SELECT SUM(tlf10*tlf12*tlf907)",
               " FROM  tlf_file ",
               " WHERE tlf01 =? ",
               "   AND tlf06 BETWEEN '",tm.b_date,"' AND ? ",
               "   AND (tlf907 <> 0 ) AND tlf902 = ? ",
               "   AND tlf903 =? AND tlf904=? "
     PREPARE r505_p3 FROM l_sql
     DECLARE r505_c3 CURSOR FOR r505_p3
    #MOD-C40179 end add-----

 
#    CALL cl_outnam('aimr505') RETURNING l_name  #No.FUN-750110
 
#    START REPORT aimr505_rep TO l_name     #No.FUN-750110
     LET g_pageno = 0                       #No.FUN-750110     
     CALL cl_del_data(l_table)              #No.FUN-750110 
    #若本月此料+倉+儲+批無異動,不列印
     FOREACH aimr505_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.imk09 IS NULL THEN LET sr.imk09=0 END IF
       IF tm.b_date > g_start THEN
          LET q1=0 LET q2=0
          SELECT SUM(tlf10*tlf12) INTO q1 FROM tlf_file
                 WHERE tlf01=sr.img01
                   AND tlf021=sr.img02 AND tlf022=sr.img03 AND tlf023=sr.img04
                   AND tlf06 >= g_start AND tlf06 < tm.b_date
                   AND tlf907 <> 0      #MOD-B60094 add 
          SELECT SUM(tlf10*tlf12) INTO q2 FROM tlf_file
                 WHERE tlf01=sr.img01
                   AND tlf031=sr.img02 AND tlf032=sr.img03 AND tlf033=sr.img04
                   AND tlf06 >= g_start AND tlf06 < tm.b_date
                   AND tlf907 <> 0      #MOD-B60094 add 
          IF q1 IS NULL THEN LET q1=0 END IF
          IF q2 IS NULL THEN LET q2=0 END IF
          LET sr.imk09=sr.imk09-q1+q2
       END IF
#      LET g_cnt=0 LET sr.bal=0  #No.FUN-750110
       LET g_cnt=1 LET sr.bal=0  #No.FUN-750110
      #MOD-B40229---add---start---
       IF sr.imk09 != 0 THEN
          LET l_flag = '1'
          IF tm.type = 'N' THEN
             EXECUTE insert_prep USING sr.seq,sr.tlf06,sr.memo,sr.tlf026,sr.tlf036,sr.tlf10,sr.tlf11, 
                                       sr.tlf19,sr.bal,sr.img01,sr.img02,sr.img03,sr.img04,    
                                       sr.imk09,l_flag                                        
          ELSE
             IF sr.imk09 < 0 THEN
                EXECUTE insert_prep USING sr.seq,sr.tlf06,sr.memo,sr.tlf026,sr.tlf036,sr.tlf10,sr.tlf11, 
                                          sr.tlf19,sr.bal,sr.img01,sr.img02,sr.img03,sr.img04,    
                                          sr.imk09,l_flag                                        
             END IF
          END IF
       END IF
      #MOD-B40229---add---end---
       WHILE TRUE                #No.FUN-750110
       OPEN r505_c2 USING sr.img01,sr.img02,sr.img03,sr.img04
       FETCH ABSOLUTE g_cnt r505_c2 INTO sr.tlf06,sr.tlf08,sr.tlf026,sr.tlf036,sr.tlf10, #No.FUN-750110
#      FOREACH r505_c2 INTO sr.tlf06,sr.tlf08,sr.tlf026,sr.tlf036,sr.tlf10,   #No.FUN-750110  FORRACH報254錯誤，改為while+FETCH 
                            sr.tlf11,sr.tlf13,sr.tlf19,
                            sr.tlf031,sr.tlf032,sr.tlf033,sr.tlf907 
         IF STATUS THEN   #No.FUN-750110
           EXIT WHILE     #No.FUN-750110
         END IF           #No.FUN-750110
         #LET g_cnt=g_cnt+1  #MOD-850106 mark
         IF sr.tlf031=sr.img02 AND sr.tlf032=sr.img03 AND sr.tlf033=sr.img04
            THEN LET sr.tlf10  = sr.tlf10 *  1
            ELSE LET sr.tlf10  = sr.tlf10 * -1
         END IF
         CALL s_command(sr.tlf13) RETURNING g_chr,sr.memo
         IF cl_null(sr.memo) THEN LET sr.memo=sr.tlf13 END IF
         IF g_cnt=1 THEN
            LET sr.bal=sr.imk09 + sr.tlf10
         ELSE
            LET sr.bal = sr.bal + sr.tlf10
         END IF
         LET g_cnt=g_cnt+1  #MOD-850106 
         LET sr.seq=g_cnt
         OPEN r505_c3 USING sr.img01,sr.tlf06,sr.img02,sr.img03,sr.img04    #MOD-C40179 add
         FETCH r505_c3 INTO l_sum                                           #MOD-C40179 add
         LET l_sum = sr.imk09 + l_sum                                       #MOD-C40179 add 當天total庫存數量
        #IF (sr.bal <0 AND tm.type='Y') OR tm.type='N' THEN                 #MOD-C40179 mark
         IF (sr.bal <0 AND tm.type='Y' AND l_sum <0) OR tm.type='N' THEN    #MOD-C40179 add 
#           OUTPUT TO REPORT aimr505_rep(sr.*)       #No.FUN-750110
         LET l_flag = '2'    #MOD-B40229 add
         EXECUTE insert_prep USING sr.seq,sr.tlf06,sr.memo,sr.tlf026,sr.tlf036,sr.tlf10,sr.tlf11, #No.FUN-750110
                                   sr.tlf19,sr.bal,sr.img01,sr.img02,sr.img03,sr.img04,    #No.FUN-750110
                                   sr.imk09,l_flag                                         #No.FUN-750110  #MOD-B40229 add l_flag
         END IF
#       END FOREACH         #No.FUN-750110    
        END WHILE           #No.FUN-750110
     END FOREACH
#    FINISH REPORT aimr505_rep                       #No.FUN-750110 
     IF g_zz05 = 'Y' THEN                            #No.FUN-750110                            
        CALL cl_wcchp(tm.wc,'img01,img02,img03,img04,ima23,ima08') #No.FUN-750110        
             RETURNING tm.wc                         #No.FUN-750110                            
        LET g_str = tm.wc                            #No.FUN-750110                                                   
     END IF                                          #No.FUN-750110 
     LET g_str = tm.wc,";",tm.b_date,";",tm.e_date,";",tm.choice,";",tm.type,";", #No.FUN-750110
                 tm.page_skip                                                     #No.FUN-750110    
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   #No.FUN-750110 
     CALL cl_prt_cs3('aimr505','aimr505',l_sql,g_str) #No.FUN-750110
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #No.FUN-750110 
END FUNCTION
 
{                            #No.FUN750110
REPORT aimr505_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,              #No.FUN-690026 VARCHAR(1)
          sr        RECORD
                    seq       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
                    img01     LIKE img_file.img01,
                    img02     LIKE img_file.img02,
                    img03     LIKE img_file.img03,
                    img04     LIKE img_file.img04,
                    ima02     LIKE ima_file.ima02,
                    imk09     LIKE imk_file.imk09,
                    tlf06     LIKE tlf_file.tlf06,
                    tlf08     LIKE tlf_file.tlf08,
                    tlf026    LIKE tlf_file.tlf026,
                    tlf036    LIKE tlf_file.tlf036,
                    tlf10     LIKE tlf_file.tlf10,
                    tlf11     LIKE tlf_file.tlf11,
                    tlf13     LIKE tlf_file.tlf13,
                    memo      LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(14)
                    tlf19     LIKE tlf_file.tlf19,
                    tlf031    LIKE tlf_file.tlf031,
                    tlf032    LIKE tlf_file.tlf032,
                    tlf033    LIKE tlf_file.tlf033,
                    tlf907    LIKE tlf_file.tlf907,
                    bal       LIKE tlf_file.tlf10
                    END RECORD,
          l_flag    LIKE type_file.chr1,              #No.FUN-690026 VARCHAR(1)
          l_tlf10,l_bal,t_bal,l_begin     LIKE tlf_file.tlf10
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.img01,sr.img02,sr.img03,sr.img04,sr.tlf06,sr.seq
#No.FUN-580005-begin
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT g_x[16] CLIPPED,tm.b_date,'-',tm.e_date
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
            g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
 
   BEFORE GROUP OF sr.img01
      IF  tm.page_skip ='Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_bal=0 LET t_bal=0
 
   BEFORE GROUP OF sr.img04
      PRINT COLUMN g_c[31],g_x[11] CLIPPED,
            COLUMN g_c[32],sr.img01 CLIPPED,  #FUN-5B0014 [1,20],
            COLUMN g_c[33],g_x[12] CLIPPED,sr.img02 CLIPPED,
            COLUMN g_c[34],g_x[13] CLIPPED,sr.img03 CLIPPED,
            COLUMN g_c[35],g_x[14] CLIPPED,sr.img04 CLIPPED,
            COLUMN g_c[37],g_x[15] CLIPPED,
            COLUMN g_c[38],cl_numfor(sr.imk09,38,3)
      PRINT
      LET t_bal=sr.imk09 LET l_bal=sr.imk09
 
   ON EVERY ROW
      IF tm.choice='2' THEN    #印明細
         PRINT COLUMN g_c[31],sr.tlf06 CLIPPED,
               COLUMN g_c[32],sr.memo CLIPPED,
               COLUMN g_c[33],sr.tlf026 CLIPPED,
               COLUMN g_c[34],sr.tlf036 CLIPPED,
               COLUMN g_c[35],cl_numfor(sr.tlf10,35,3),
               COLUMN g_c[36],sr.tlf11 CLIPPED,
               COLUMN g_c[37],sr.tlf19 CLIPPED,
               COLUMN g_c[38],cl_numfor(sr.bal,38,3)
      END IF
      LET t_bal=t_bal+sr.tlf10
 
   AFTER GROUP OF sr.img01
          PRINT g_dash2[1,g_len]
 
   AFTER GROUP OF sr.tlf06
      IF tm.choice='1' THEN
         IF (sr.bal <0 AND tm.type='Y') OR tm.type='N' THEN
         LET l_tlf10=GROUP SUM(sr.tlf10)
         IF cl_null(l_tlf10) THEN LET l_tlf10=0 END IF
         PRINT COLUMN g_c[31],sr.tlf06 CLIPPED,
               COLUMN g_c[35],cl_numfor(l_tlf10,35,3),
               COLUMN g_c[38],cl_numfor(sr.bal,38,3)
         END IF
      END IF
 
   AFTER GROUP OF sr.img04
       PRINT
 
   ON LAST ROW
      LET l_last_sw='y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
      IF l_last_sw='y'
         THEN PRINT g_x[04],COLUMN 41,g_x[05] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
         ELSE PRINT g_x[04],COLUMN 41,g_x[05] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
      END IF
END REPORT           
#No.FUN-580005-end
#Patch....NO.TQC-610036 <> # }  #No.FUN-750110

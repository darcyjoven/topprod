# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: aimr406.4gl
# Descriptions...: 倉庫庫存金額明細表
# Input parameter:
# Return code....:
# Date & Author..: 99/07/05 By Frank871
# Modify.........: No.FUN-510017 05/01/11 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-570240 05/07/26 By day   料件編號欄位加CONTROLP
# Modify.........: No.MOD-530545 05/07/12 By pengu 庫存量及庫存金額無法印出
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改。
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-710103 07/01/17 By Carol SQL移除OUTER ccc_file的相關資料,改在foreach之後再讀取
# Modify.........: No.MOD-740034 07/04/11 By pengu 單價未依據幣別取小數位數
# Modify.........: No.TQC-740338 07/04/29 By sherry 打印時接下頁長度設置不對
# Modify.........: No.TQC-790004 07/09/03 By wujie 月份欄位控管為只能輸入兩位數 
# Modify.........: No.FUN-790012 07/09/07 By zhoufeng 報表輸出改為Crystal Report
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.MOD-960208 09/06/17 By Carrier 過濾到非成本倉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9C0025 09/12/22 By jan 畫面新增type欄位
# Modify.........: No:CHI-B30022 11/03/09 By sabrina 庫存為0改為使用者勾選是否要印出到報表上
# Modify.........: N0:MOD-D20141 13/02/23 By Alberti 修改成本單價資料年度期別給預設值(yy,mm)
# Modify.........: N0:CHI-D30010 13/03/22 By bart tm.type='4'時，sr.tlfcost應=sr.tlfcost

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          #Print condition RECORD
           wc      LIKE type_file.chr1000, #Where condition  #No.FUN-690026 VARCHAR(500)
           s       LIKE type_file.chr3,    #排序  #No.FUN-690026 VARCHAR(3)
           t       LIKE type_file.chr3,    #跳頁  #No.FUN-690026 VARCHAR(3)
           u       LIKE type_file.chr3,    #合計  #No.FUN-690026 VARCHAR(3)
           yy,mm   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           p1      LIKE type_file.chr1,    #CHI-B30022 add
           type    LIKE type_file.chr1,    #CHI-9C0025
           more    LIKE type_file.chr1     #Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD,
       g_tot_amt   LIKE img_file.img10     #庫存金額總合計
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_str       STRING                  #No.FUN-790012
DEFINE g_sql       STRING                  #No.FUN-790012
DEFINE l_table     STRING                  #No.FUN-790012
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-790012 --start--
   LET g_sql="ima01.ima_file.ima01,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,ccc23.ccc_file.ccc23,",
             "img02.img_file.img02,img03.img_file.img03,img04.img_file.img04,",
             "img09.img_file.img09,img10.img_file.img10,",
             "ccc23_1.ccc_file.ccc23,ima25.ima_file.ima25,",
             "ima131.ima_file.ima131,ima08.ima_file.ima08,",
             "img01.img_file.img01,tlfcost.tlf_file.tlfcost"  #CHI-9C0025
   LET l_table = cl_prt_temptable('aimr406',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #CHI-9C0025
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-790012 --end--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.yy = ARG_VAL(11)
   LET tm.mm = ARG_VAL(12)
   LET tm.type = ARG_VAL(13)  #CHI-9C0025
   LET tm.p1 = ARG_VAL(14)       #CHI-B30022 add
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)  #CHI-B30022 modify 14->15   
   LET g_rep_clas = ARG_VAL(16)  #CHI-B30022 modify 15->16
   LET g_template = ARG_VAL(17)  #CHI-B30022 modify 16->17
   LET g_rpt_name = ARG_VAL(18)  #No:FUN-7C0078    #CHI-B30022 modify 17->18
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr406_tm(0,0)        # Input print condition
      ELSE CALL aimr406()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr406_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW aimr406_w AT p_row,p_col
        WITH FORM "aim/42f/aimr406"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #CHI-9C0025
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '345'
   LET tm.u    = 'Y'
   LET tm.more = 'N'
  #LET tm.yy   = YEAR(g_today)                   #MOD-D20141 mark
  #LET tm.mm   = MONTH(g_today)                  #MOD-D20141 mark
   SELECT ccz01,ccz02 INTO tm.yy,tm.mm FROM ccz_file     #MOD-D20140
   LET tm.type = g_ccz.ccz28  #CHI-9C0025
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.p1 = 'N'      #CHI-B30022 add
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima131,ima08,img01,img02,img03,img04
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
 
#No.FUN-570240  --start-
      ON ACTION controlp
            IF INFIELD(img01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img01
               NEXT FIELD img01
            END IF
#No.FUN-570240 --end--
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr406_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.yy,tm.mm,tm.type,tm.p1,tm.more         # Condition#CHI-9C0025  #CHI-B30022 add tm.p1
#UI
   INPUT BY NAME
            tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
            tm.yy,tm.mm,tm.type,tm.p1,tm.more WITHOUT DEFAULTS  #CHI-9C0025  #CHI-B30022 add tm.p1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
#No.TQC-790004 --begin                                                                                                              
         IF tm.mm <=0 OR tm.mm >12 THEN                                                                                             
            LET tm.mm =null                                                                                                         
            NEXT FIELD mm                                                                                                           
         END IF                                                                                                                     
#No.TQC-790004 --end 
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr406_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr406'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr406','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",                 #TQC-610072
                         " '",tm.t CLIPPED,"'",                 #TQC-610072
                         " '",tm.u CLIPPED,"'",                 #TQC-610072
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'" ,
                         " '",tm.type CLIPPED,"'" ,             #CHI-9C0025
                         " '",tm.p1 CLIPPED,"'" ,               #CHI-B30022 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr406',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr406_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr406()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr406_w
END FUNCTION
 
FUNCTION aimr406()
   DEFINE l_name    LIKE type_file.chr20,            #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#          l_time    LIKE type_file.chr8,             #Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
          l_sql     LIKE type_file.chr1000,          #RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,             #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_yy      LIKE type_file.num5,             #MOD-710103 add
          l_mm      LIKE type_file.num5,             #MOD-710103 add 
          l_order   ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD
                    order1      LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                    order2      LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                    order3      LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                    ima01       LIKE ima_file.ima01, # 料號
                    ima02       LIKE ima_file.ima02, # 品名
                    ima021      LIKE ima_file.ima021,# 品名 #FUN-510017
                    img01       LIKE img_file.img01, # 料件編號
                    img02       LIKE img_file.img02, # 倉庫
                    img03       LIKE img_file.img03, # 儲位
                    img04       LIKE img_file.img04, # 批號
                    img09       LIKE img_file.img09, # 單位
                    img10       LIKE img_file.img10, # 庫存量
                    img21       LIKE img_file.img21, # 單位換算率
                    ima131      LIKE ima_file.ima131,# 產品分類
                    ima08       LIKE ima_file.ima08, # 來源碼
                    ccc23       LIKE ccc_file.ccc23, # 單位成本
                    ima25       LIKE ima_file.ima25, # 庫存單位
                    qty         LIKE img_file.img10, # 庫存量   #MOD-530179
                    img10_ccc23 LIKE ccc_file.ccc23, # 庫存金額 #MOD-530179
                    tlfcost     LIKE tlf_file.tlfcost           #CHI-9C0025
                    END RECORD
   DEFINE l_str     LIKE type_file.chr1000           #No.FUN-790012
   DEFINE l_ima25   LIKE ima_file.ima25              #No.FUN-790012
 
     CALL cl_del_data(l_table)                       #No.FUN-790012
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
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
 
#    IF cl_prichk('$') THEN
 #--------No.MOD-530545 delete mark
         LET l_sql = "SELECT '','','',",
                 "      ima01,ima02,ima021,img01,img02,img03,img04,img09,img10,img21,",     #MOD-530545 add ima021
                 "      ima131,ima08,0,ima25, ",           #MOD-710103 ccc23 -> 0
                 "      (img10*img21),0,imd09 ",           #MOD-710103 (img10*img21*ccc23) -> 0 #CHI-9C0025 add imd09
                 "  FROM ima_file, img_file LEFT OUTER JOIN imd_file ",  #,OUTER ccc_file",   #MOD-710103 mark OUTER ccc_file#CHI-9C0025
                 "  ON img02 = imd01 ", #CHI-9C0025
                 "  WHERE img01=ima01",
                 #No.MOD-960208  --Begin
                 "    AND img02 NOT IN (SELECT jce02 FROM jce_file ) ",
                 #No.MOD-960208  --End  
                 "   AND ",tm.wc CLIPPED                       #MOD-710103 mark ,
            #    "   AND ima01 = ccc_file.ccc01 ",                      #MOD-710103 mark 
            #    "   AND ccc02 = '",tm.yy CLIPPED,"'",         #MOD-710103 mark
            #    "   AND ccc03 = '",tm.mm CLIPPED,"'"          #MOD-710103 mark
#-----------end
#    ELSE
 #-----------No.MOD-530545 mark
#         LET l_sql = "SELECT '','','',",
#                "      ima01,ima02,ima021,img01,img02,img03,img04,img09,img10,img21, ",
#                "      ima131,ima08,'',ima25 ",
#                "  FROM img_file, ima_file ",
#                " WHERE img01=ima01",
#                "   AND ",tm.wc CLIPPED
#--------------end
#    END IF
    #CHI-B30022---add---start---
     IF tm.p1 = 'N' THEN
        LET l_sql = l_sql, " AND img10 !=0 "
     END IF
    #CHI-B30022---add---end---
     PREPARE aimr406_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE aimr406_curs1 CURSOR FOR aimr406_prepare1
 
#     CALL cl_outnam('aimr406') RETURNING l_name       #No.FUN-790012
#     START REPORT aimr406_rep TO l_name               #No.FUN-790012
#     LET g_pageno = 0                                 #No.FUN-790012
     LET g_tot_amt = 0
     FOREACH aimr406_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #CHI-9C0025--begin--add--
         CASE tm.type
          WHEN '1'  LET sr.tlfcost = ' '
          WHEN '2'  LET sr.tlfcost = ' '
          WHEN '3'  LET sr.tlfcost = sr.img04
          #WHEN '4'  LET sr.tlfcost = ' '  #CHI-D30010
          WHEN '4'  LET sr.tlfcost = sr.tlfcost  #CHI-D30010
          WHEN '5'  LET sr.tlfcost = sr.tlfcost
         END CASE
       #CHI-9C0025--end--add----
 
#MOD-710103--add-----
       SELECT ccc23 INTO sr.ccc23 FROM ccc_file 
        WHERE ccc01=sr.ima01 AND ccc02=tm.yy AND ccc03=tm.mm
         #AND ccc07='1'             #No.FUN-840041  #CHI-9C0025
          AND ccc07=tm.type AND ccc08=sr.tlfcost  #CHI-9C0025
          IF (SQLCA.sqlcode) OR (sr.ccc23 IS NULL) THEN
             LET l_mm = tm.mm - 1
             LET l_yy = tm.yy
             IF l_mm = 0 THEN
                LET l_yy = tm.yy - 1
                LET l_mm = 12
             END IF
             SELECT ccc23 INTO sr.ccc23
               FROM ccc_file
              WHERE ccc01=sr.ima01 AND ccc02=l_yy AND ccc03=l_mm
               #AND ccc07='1'         #No.FUN-840041 #CHI-9C0025
                AND ccc07=tm.type AND ccc08=sr.tlfcost  #CHI-9C0025
             IF cl_null(sr.ccc23) THEN LET sr.ccc23 = 0 END IF
          END IF
          LET sr.img10_ccc23 = sr.qty * sr.ccc23
          IF cl_null(sr.img10_ccc23) THEN 
             LET sr.img10_ccc23 = 0
          END IF
#MOD-710103--end -----
       #No.FUN-790012 --mark--
       #篩選排列順序條件
#       FOR g_i = 1 TO 3
#           CASE
#               WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima131
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima08
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.img01
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.img02
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.img03
#               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.img04
#           END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#
#       OUTPUT TO REPORT aimr406_rep(sr.*)
       #No.FUN-790012 --end--
       #No.FUN-790012 --start--
       SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=sr.ima01
       EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ccc23,sr.img02,
                                 sr.img03,sr.img04,sr.img09,sr.qty,
                                 sr.img10_ccc23,l_ima25,sr.ima131,sr.ima08,
                                 sr.img01,sr.tlfcost   #CHI-9C0025
       #No.FUN-790012 --end--
     END FOREACH
 
#     FINISH REPORT aimr406_rep                   #No.FUN-790012
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-790012
     #No.FUN-790012 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ima131,ima08,img01,img02,img03,img04')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET l_str = tm.yy USING '####','/',tm.mm USING '##'
     LET g_str = g_str,";",l_str,";",g_azi03,";",g_azi04,";",g_azi05,";",
                 tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                 tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",
                 tm.u[3,3]
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('aimr406','aimr406',l_sql,g_str)
     #No.FUN-790012 --end--
END FUNCTION
#No.FUN-790012 --start-- mark
{REPORT aimr406_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_ccc23      LIKE ccc_file.ccc23,
          l_ima25      LIKE ima_file.ima25,
          l_inv_qty    LIKE img_file.img10, #庫存量
          l_inv_amt    LIKE img_file.img10, #庫存金額
          l_inv_qty_g  LIKE img_file.img10, #庫存量
          l_inv_amt_g  LIKE img_file.img10, #庫存金額
          sr           RECORD
                       order1      LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                       order2      LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                       order3      LIKE ima_file.ima01, #FUN-5B0105 24->40  #No.FUN-690026 VARCHAR(40)
                       ima01       LIKE ima_file.ima01, # 料號
                       ima02       LIKE ima_file.ima02, # 品名
                       ima021      LIKE ima_file.ima021,# 品名 #FUN-510017
                       img01       LIKE img_file.img01, # 料件編號
                       img02       LIKE img_file.img02, # 倉庫
                       img03       LIKE img_file.img03, # 儲位
                       img04       LIKE img_file.img04, # 批號
                       img09       LIKE img_file.img09, # 單位
                       img10       LIKE img_file.img10, # 庫存量
                       img21       LIKE img_file.img21, # 單位換算率
                       ima131      LIKE ima_file.ima131,# 產品分類
                       ima08       LIKE ima_file.ima08, # 來源碼
                       ccc23       LIKE ccc_file.ccc23, # 單位成本
                       ima25       LIKE ima_file.ima25, # 庫存單位
                       qty         LIKE img_file.img10, # 庫存量   #MOD-530179
                       img10_ccc23 LIKE ccc_file.ccc23  # 庫存金額 #MOD-530179
                       END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[11] CLIPPED,tm.yy USING '####','/',tm.mm USING '##'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
       IF tm.t[1,1] = 'Y' THEN
           SKIP TO TOP OF PAGE
       END IF
   BEFORE GROUP OF sr.order2
       IF tm.t[2,2] = 'Y' THEN
           SKIP TO TOP OF PAGE
       END IF
   BEFORE GROUP OF sr.order3
       IF tm.t[3,3] = 'Y' THEN
           SKIP TO TOP OF PAGE
       END IF
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima021,
            COLUMN g_c[34],cl_numfor(sr.ccc23,34,g_azi03),     #No.MOD-740034 modify
            COLUMN g_c[35],sr.img02,
            COLUMN g_c[36],sr.img03,
            COLUMN g_c[37],sr.img04,
            COLUMN g_c[38],sr.img09,
            COLUMN g_c[39],cl_numfor(sr.qty,39,g_azi04),
            COLUMN g_c[40],cl_numfor(sr.img10_ccc23,40,g_azi04)
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
          SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=sr.ima01
          LET l_inv_qty_g = GROUP SUM(sr.qty)
          LET l_inv_amt_g = GROUP SUM(sr.img10_ccc23)
          PRINT COLUMN g_c[37],g_x[20] CLIPPED,
                COLUMN g_c[38],l_ima25,
                COLUMN g_c[39],cl_numfor(l_inv_qty_g,39,g_azi04),
                COLUMN g_c[40],cl_numfor(l_inv_amt_g,40,g_azi04)
          PRINT
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
          SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=sr.ima01
          LET l_inv_qty_g = GROUP SUM(sr.qty)
          LET l_inv_amt_g = GROUP SUM(sr.img10_ccc23)
          PRINT COLUMN g_c[37],g_x[20] CLIPPED,
                COLUMN g_c[38],l_ima25,
                COLUMN g_c[39],cl_numfor(l_inv_qty_g,39,g_azi04),
                COLUMN g_c[40],cl_numfor(l_inv_amt_g,40,g_azi04)
          PRINT
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
          SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=sr.ima01
          LET l_inv_qty_g = GROUP SUM(sr.qty)
          LET l_inv_amt_g = GROUP SUM(sr.img10_ccc23)
          PRINT COLUMN g_c[37],g_x[20] CLIPPED,
                COLUMN g_c[38],l_ima25,
                 COLUMN g_c[39],cl_numfor(l_inv_qty_g,39,g_azi04),   #No.MOD-530545
                 COLUMN g_c[40],cl_numfor(l_inv_amt_g,40,g_azi04)    #No.MOD-530545
          PRINT
      END IF
 
 
 
 
   ON LAST ROW
      LET g_tot_amt = SUM(sr.img10_ccc23)
      PRINT COLUMN g_c[37],g_x[21] CLIPPED,
             COLUMN g_c[40],cl_numfor(g_tot_amt,40,g_azi05)          #No.MOD-530545
      PRINT g_dash
      LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #No.TQC-5C0005
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005     #No.TQC-740338
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[6] CLIPPED #No.TQC-5C0005
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005   #No.TQC-740338
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-790012 --end--
#Patch....NO.TQC-610036 <001> #

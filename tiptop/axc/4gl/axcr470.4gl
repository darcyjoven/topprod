# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axcr470.4gl
# Descriptions...: 库存明细账打印
# Input parameter:
# Return code....:
# Date & Author..: 10/10/21 By Elva #No.FUN-AA0025
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-C40214 12/05/08 By ck2yuan 應所有的庫存異動都要印出來,tlf10無負數 故拿掉此條件
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,        # Where condition   #TQC-630166
              bdate   LIKE type_file.dat, 
              edate   LIKE type_file.dat, 
              more    LIKE type_file.chr1    #No:FUN-690028  VARCHAR(1)         # Input more condition(Y/N)
           END RECORD,
       l_orderA      ARRAY[4] OF LIKE zaa_file.zaa08   #No:FUN-690028 VARCHAR(16)  #排序名稱     #No.FUN-550030 #FUN-AA0025
DEFINE g_i              LIKE type_file.num5    #No:FUN-690028  SMALLINT   #count/index for any purpose
DEFINE l_table          STRING                                                                             
DEFINE g_str            STRING                                                                             
DEFINE g_sql            STRING                  
DEFINE g_chr            LIKE type_file.chr1     
DEFINE g_msg            LIKE ze_file.ze03       

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80056   ADD  #No.FUN-BB0047  mark

   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
#No.FUN-750097 -----------start-----------------
   LET g_sql = " tlf06.tlf_file.tlf06,",           #单据日期
               " tlf905.tlf_file.tlf905,",         #单据编号
               " tlf13_desc.ze_file.ze03,",        #单据类型
               " tlf01.tlf_file.tlf01,",           #商品代码
               " ima02.ima_file.ima02,",           #商品名称
               " ima021.ima_file.ima021,",         #规格型号
               " ima25.ima_file.ima25,",           #单位
               " price_in.tlf_file.tlf21,",        #入库单价
               " tlf10_in.tlf_file.tlf10,",        #入库数
               " tlf21_in.tlf_file.tlf21,",        #入库金额
               " price_out.tlf_file.tlf21,",       #出库单价
               " tlf10_out.tlf_file.tlf10,",       #出库数
               " tlf21_out.tlf_file.tlf21,",       #出库金额
               " qc_num.ccc_file.ccc11,",          #期初数
               " qc_amt.ccc_file.ccc12,",          #期初金额
               " qm_num.ccc_file.ccc91,",          #期末数
               " qm_amt.ccc_file.ccc92,",          #期末金额
               " bdate.type_file.dat,",            #起始日期
               " edate.type_file.dat,"             #截止日期
   LET l_table = cl_prt_temptable('axcr470',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,  
                " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",   
                "        ?,?,?,?)"   
    PREPARE insert_prep FROM g_sql                      
    IF STATUS THEN                                        
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM  
    END IF                                               
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No:FUN-7C0078
   #No:FUN-570264 ---end---
   DROP TABLE r470_table
   CREATE TEMP TABLE r470_table(
              tlf06      LIKE  tlf_file.tlf06,           
              tlf905     LIKE  tlf_file.tlf905,          
              tlf13      LIKE  tlf_file.tlf13,           
              tlf13_desc LIKE  ze_file.ze03,             
              tlf01      LIKE  tlf_file.tlf01,           
              ima02      LIKE  ima_file.ima02,           
              ima021     LIKE  ima_file.ima021,          
              ima25      LIKE  ima_file.ima25,           
              price_in   LIKE  tlf_file.tlf21,           
              tlf10_in   LIKE  tlf_file.tlf10,           
              tlf21_in   LIKE  tlf_file.tlf21,           
              price_out  LIKE  tlf_file.tlf21,           
              tlf10_out  LIKE  tlf_file.tlf10,           
              tlf21_out  LIKE  tlf_file.tlf21,           
              qc_num     LIKE  ccc_file.ccc11,           
              qc_amt     LIKE  ccc_file.ccc12,           
              qm_num     LIKE  ccc_file.ccc91,           
              qm_amt     LIKE  ccc_file.ccc92);

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL axcr470_tm(0,0)
   ELSE
      CALL axcr470()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
END MAIN

FUNCTION axcr470_tm(p_row,p_col)
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01 
   DEFINE p_row,p_col  LIKE type_file.num5,    #No:FUN-690028  SMALLINT,
          l_cmd        LIKE type_file.chr1000  #No:FUN-690028  VARCHAR(400)

   LET p_row = 2 LET p_col = 20
   OPEN WINDOW axcr470_w AT p_row,p_col
     WITH FORM "axc/42f/axcr470"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima12,ima01,ima06

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
             END CASE

         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
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
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axcr470_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.bdate,tm.edate,tm.more  #DFUN-960055
                      WITHOUT DEFAULTS

         #No:FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No:FUN-580031 ---end---

         AFTER FIELD bdate 
            IF tm.bdate IS NULL THEN NEXT FIELD bdate END IF

         AFTER FIELD edate 
            IF tm.edate IS NULL THEN NEXT FIELD edate END IF
            IF tm.edate < tm.bdate THEN
               NEXT FIELD edate 
            END IF

         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution

         AFTER INPUT

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
         LET INT_FLAG = 0
         CLOSE WINDOW axcr470_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcr470'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axcr470','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")  #"
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No:FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                        " '",g_template CLIPPED,"'",           #No:FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No:FUN-7C0078
            CALL cl_cmdat('axcr470',g_time,l_cmd)    # Execute cmd at later time
         END IF

         CLOSE WINDOW axcr470_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
         EXIT PROGRAM
      END IF

      CALL cl_wait()
      CALL axcr470()

      ERROR ""
   END WHILE

   CLOSE WINDOW axcr470_w

END FUNCTION

FUNCTION axcr470()
   DEFINE l_date    LIKE type_file.dat
   DEFINE l_name    LIKE type_file.chr20,
          l_sql     STRING, 
          l_rvv23   LIKE rvv_file.rvv23, 
          l_chr     LIKE type_file.chr1, 
          l_order   ARRAY[5] OF  LIKE rvv_file.rvv01,
          sr        RECORD 
              tlf06      LIKE  tlf_file.tlf06,           #单据日期
              tlf905     LIKE  tlf_file.tlf905,          #单据编号
              tlf13      LIKE  tlf_file.tlf13,           #异动指令
              tlf13_desc LIKE  ze_file.ze03,             #单据类型
              tlf01      LIKE  tlf_file.tlf01,           #商品代码
              ima02      LIKE  ima_file.ima02,           #商品名称
              ima021     LIKE  ima_file.ima021,          #规格型号
              ima25      LIKE  ima_file.ima25,           #单位
              price_in   LIKE  tlf_file.tlf21,           #入库单价
              tlf10_in   LIKE  tlf_file.tlf10,           #入库数
              tlf21_in   LIKE  tlf_file.tlf21,           #入库金额
              price_out  LIKE  tlf_file.tlf21,           #出库单价
              tlf10_out  LIKE  tlf_file.tlf10,           #出库数
              tlf21_out  LIKE  tlf_file.tlf21,           #出库金额
              qc_num     LIKE  ccc_file.ccc11,           #期初数
              qc_amt     LIKE  ccc_file.ccc12,           #期初金额
              qm_num     LIKE  ccc_file.ccc91,           #期末数
              qm_amt     LIKE  ccc_file.ccc92            #期末金额
                    END RECORD
    DEFINE l_y1  LIKE type_file.num5
    DEFINE l_y2  LIKE type_file.num5
    DEFINE l_m1  LIKE type_file.num5
    DEFINE l_m2  LIKE type_file.num5
    DEFINE l_tlf10_in  LIKE tlf_file.tlf10
    DEFINE l_tlf10_out LIKE tlf_file.tlf10
    DEFINE l_tlf21_in  LIKE tlf_file.tlf21
    DEFINE l_tlf21_out LIKE tlf_file.tlf21
    DEFINE l_cnt       LIKE type_file.num5   
    DEFINE l_ccb02     LIKE ccb_file.ccb02
    DEFINE l_ccb03     LIKE type_file.chr3 
    DEFINE l_tlf01_t   LIKE tlf_file.tlf01

     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0055
     #No.FUN-BB0047--mark--End-----
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET tm.wc = tm.wc clipped," AND rvuuser = '",g_user,"'"
   END IF

   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET tm.wc = tm.wc clipped," AND rvugrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET tm.wc = tm.wc clipped," AND rvugrup IN ",cl_chk_tgrup_list()
   END IF

#  SELECT YEAR(tm.bdate)  INTO l_y1 FROM DUAL
#  SELECT YEAR(tm.edate)  INTO l_y2 FROM DUAL
#  SELECT MONTH(tm.bdate) INTO l_m1 FROM DUAL
#  SELECT MONTH(tm.edate) INTO l_m2 FROM DUAL
   LET l_y1 = YEAR(tm.bdate)
   LET l_y2 = YEAR(tm.edate)
   LET l_m1 = MONTH(tm.bdate)
   LET l_m2 = MONTH(tm.edate)

   LET l_sql = "SELECT tlf06,tlf905,tlf13,'',tlf01,ima02,ima021,ima25, ",
               " 0,SUM(tlf10*tlf907*tlf60),SUM(tlf21*tlf907*tlf60),0,0,0,0,0,0,0 ",
               "  FROM tlf_file LEFT OUTER JOIN ima_file ON tlf01=ima01 ",
               " WHERE tlf907 = 1 ",
              #"   AND tlf10 > 0 ",     #MOD-C40214 mark
               "   AND ",tm.wc CLIPPED, 
               "   AND tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               " GROUP BY tlf06,tlf905,tlf13,tlf01,ima02,ima021,ima25 ",
               " UNION ALL ",
               "SELECT tlf06,tlf905,tlf13,'',tlf01,ima02,ima021,ima25,",
               " 0,0,0,0,SUM(tlf10*tlf907*tlf60),SUM(tlf21*tlf907*tlf60),0,0,0,0 ",
               "  FROM tlf_file LEFT OUTER JOIN ima_file ON tlf01=ima01 ",
               " WHERE tlf907 = -1 ",
              #"   AND tlf10 > 0 ",     #MOD-C40214 mark
               "   AND ",tm.wc CLIPPED, 
               "   AND tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               " GROUP BY tlf06,tlf905,tlf13,tlf01,ima02,ima021,ima25",
               " UNION ALL ",
               "SELECT ccbdate,ccb04,'axct002','',ccb01 tlf01,ima02,ima021,ima25, ",           #入库成本调整，默认sr.tlf13 = 'axct002' 
               "  0,0,ccb22,0,0,0,0,0,0,0 ",
               "  FROM ccb_file LEFT OUTER JOIN ima_file ON ccb01=ima01 ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ccb02 BETWEEN '",l_y1,"' AND '",l_y2,"' ",
               "   AND ccb03 BETWEEN '",l_m1,"' AND '",l_m2,"' "
   LET l_sql=l_sql," ORDER BY tlf01,tlf06 " 
   PREPARE axcr470_prepare1 FROM l_sql
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   DECLARE axcr470_curs1 CURSOR FOR axcr470_prepare1

   LET g_pageno = 0
   LET l_tlf10_in  = 0
   LET l_tlf21_in  = 0
   LET l_tlf10_out = 0
   LET l_tlf21_out = 0
   LET l_tlf01_t = ' '
 
   DELETE FROM r470_table

   FOREACH axcr470_curs1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      CALL s_command(sr.tlf13) RETURNING g_chr,sr.tlf13_desc
      IF sr.tlf13 = 'axct002' THEN
         LET sr.tlf13_desc = '入库成本调整'
         SELECT ccb02,ccb03 INTO l_ccb02,l_ccb03
           FROM ccb_file
          WHERE ccb04 = sr.tlf905
            AND ccb01 = sr.tlf01 
         LET l_ccb03 = l_ccb03 USING '&&'
         LET l_date = MDY(l_ccb03,1,l_ccb02)
         LET sr.tlf06 = s_last(l_date)
      END IF
      INSERT INTO r470_table VALUES(sr.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","temp table",sr.tlf01,"",SQLCA.sqlcode,"","",0)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
         EXIT PROGRAM
      END IF
   END FOREACH

   LET l_sql = "SELECT * FROM r470_table ORDER BY tlf01,tlf06 "

   PREPARE axcr470_prepare2 FROM l_sql
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
      EXIT PROGRAM
   END IF
   DECLARE axcr470_curs2 CURSOR FOR axcr470_prepare2

   INITIALIZE sr.* TO NULL

   FOREACH axcr470_curs2 INTO sr.*
      IF cl_null(sr.tlf10_in) THEN LET sr.tlf10_in = 0 END IF
      IF cl_null(sr.tlf21_in) THEN LET sr.tlf21_in = 0 END IF
      IF cl_null(sr.tlf10_out) THEN LET sr.tlf10_out = 0 END IF
      IF cl_null(sr.tlf21_out) THEN LET sr.tlf21_out = 0 END IF

      LET sr.price_in  = sr.tlf21_in/sr.tlf10_in
      LET sr.price_out = sr.tlf21_out/sr.tlf10_out

      IF cl_null(sr.price_in) THEN LET sr.price_in = 0 END IF
      IF cl_null(sr.price_out) THEN LET sr.price_out = 0 END IF

      #tlf异动指令
#     CALL s_command(sr.tlf13) RETURNING g_chr,sr.tlf13_desc
#     IF sr.tlf13 = 'axct002' THEN
#        LET sr.tlf13_desc = '入库成本调整'
#        SELECT ccb02,ccb03 INTO l_ccb02,l_ccb03
#          FROM ccb_file
#         WHERE ccb04 = sr.tlf905
#           AND ccb01 = sr.tlf01 
#        LET l_ccb03 = l_ccb03 USING '&&'
#     #  SELECT last_day(to_date(l_ccb02||l_ccb03||'01','YYYYMMDD'))
#     #    INTO sr.tlf06 FROM DUAL
#        LET l_date = MDY(l_ccb03,1,l_ccb02)
#        LET sr.tlf06 = s_last(l_date)
#     END IF

      #期初
      SELECT ccc11,ccc12 INTO sr.qc_num,sr.qc_amt
        FROM ccc_file
       WHERE ccc01 = sr.tlf01
         AND ccc02 = l_y1
         AND ccc03 = l_m1
      IF cl_null(sr.qc_num) THEN LET sr.qc_num = 0 END IF
      IF cl_null(sr.qc_amt) THEN LET sr.qc_amt = 0 END IF

      IF sr.tlf01 <> l_tlf01_t THEN
         LET l_tlf10_in  = 0 
         LET l_tlf21_in  = 0 
         LET l_tlf10_out = 0 
         LET l_tlf21_out = 0 
      END IF

      #本期异动
      LET l_tlf10_in  = l_tlf10_in  + sr.tlf10_in
      LET l_tlf21_in  = l_tlf21_in  + sr.tlf21_in
      LET l_tlf10_out = l_tlf10_out + sr.tlf10_out
      LET l_tlf21_out = l_tlf21_out + sr.tlf21_out

      #期末 = 期初 + 本期入 + （-本期出）
      LET sr.qm_num = sr.qc_num + l_tlf10_in + l_tlf10_out 
      LET sr.qm_amt = sr.qc_amt + l_tlf21_in + l_tlf21_out
     
      LET l_tlf01_t = sr.tlf01 
      EXECUTE insert_prep USING sr.tlf06,sr.tlf905,sr.tlf13_desc,sr.tlf01,sr.ima02,
                                sr.ima021,sr.ima25,sr.price_in,sr.tlf10_in,sr.tlf21_in,
                                sr.price_out,sr.tlf10_out,sr.tlf21_out,sr.qc_num,sr.qc_amt,
                                sr.qm_num,sr.qm_amt,tm.bdate,tm.edate

   END FOREACH


   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
   LET g_str = ''
   #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'ima12,ima01,ima06,gem01')                                                                                                
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str = g_str,";",g_ccz.ccz27,";",g_ccz.ccz26 #CHI-C30012
     CALL cl_prt_cs3('axcr470','axcr470',l_sql,g_str)   
     #No.FUN-BB0047--mark--Begin---     
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0055
     #No.FUN-BB0047--mark--End-----
END FUNCTION

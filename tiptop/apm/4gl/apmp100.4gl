# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apmp100.4gl
# Descriptions...: 移動平均成本計算作業 (no.7231)
# Date & Author..: 2002/12/15 nick
# for 買賣業計算移動平均成本
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率改為DEC(20,10)
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modfy..........: No.FUN-610020 06/01/09 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-570138 06/03/09 By yiting 批次背景執行
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0089 06/11/09 By xumin報表添加表頭表尾
# Modify.........: No.TQC-6B0121 06/11/22 By xumin 報表添加公司名稱打印
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          diff         LIKE type_file.chr1,               #No.FUN-680136 VARCHAR(1)
          minus        LIKE type_file.chr1,               #No.FUN-680136 VARCHAR(1)
          detail       LIKE type_file.chr1,               #No.FUN-680136 VARCHAR(1)
          sales_detail LIKE type_file.chr1,               #No.FUN-680136 VARCHAR(1)
          rate         LIKE type_file.num20_6,            #No.FUN-680136 VARCHAR(1)
          edate        LIKE type_file.dat,                #No.FUN-680136 VARCHAR(1)
          plant        LIKE azp_file.azp01,               #NO.FUN-990069 VARCHAR(10)
          dbs          LIKE azp_file.azp01                #No.FUN-680136 VARCHAR(10)
          END RECORD
DEFINE l_flag          LIKE type_file.chr1,               #No.FUN-570138           #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,               #No.FUN-680136 VARCHAR(1)   #是否有做語言切換 
       ls_date         STRING                             #->No.FUN-570138
 
DEFINE yy               LIKE type_file.num5,              #No.FUN-680136 SMALLINT
       mm               LIKE type_file.num5,              #No.FUN-680136 SMALLINT
       last_yy          LIKE type_file.num5,              #No.FUN-680136 SMALLINT
       last_mm          LIKE type_file.num5,              #No.FUN-680136 SMALLINT
       g_cost_v         LIKE azi_file.azi01,              #No.FUN-680136 VARCHAR(04)
       g_misc           LIKE type_file.chr1,              #No.FUN-680136 VARCHAR(1)
       g_sql            string,                           #No.FUN-580092 HCN
       g_wc             string,                           #No.FUN-580092 HCN
       b_date           LIKE type_file.dat,               #No.FUN-680136 DATE
       g_tot            LIKE type_file.num10,             #No.FUN-680136 INTEGER
       no_tot,p1        LIKE type_file.num10,             #No.FUN-680136 INTEGER 
       no_ok,no_ok2     LIKE type_file.num10,             #No.FUN-680136 INTEGER 
       start_date       LIKE type_file.dat,               #No.FUN-680136 DATE
       start_time       LIKE aba_file.aba00,              #No.FUN-680136 VARCHAR(5)
       t_time           LIKE type_file.chr8               #No.FUN-680136 VARCHAR(8)
 
DEFINE g_msg           LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE g_flag          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570138 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.rate   = ARG_VAL(1)
   LET tm.dbs    = ARG_VAL(2)
   LET tm.plant  = ARG_VAL(3)   #FUN-990069
   LET g_wc      = ARG_VAL(4)
   LET yy        = ARG_VAL(5)
   LET mm        = ARG_VAL(6)
   LET ls_date   = ARG_VAL(7)
   LET tm.edate  = cl_batch_bg_date_convert(ls_date)
   LET tm.detail = ARG_VAL(8)
   LET tm.sales_detail= ARG_VAL(9)
   LET tm.minus  = ARG_VAL(10)
   LET tm.diff   = ARG_VAL(11)
   LET g_bgjob   = ARG_VAL(12)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570138 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

#NO.FUN-570138 mark--
#   LET tm.rate=ARG_VAL(1)
#   LET tm.dbs=ARG_VAL(2)
#   LET tm.edate=TODAY
#   LET g_bgjob='N'
 
   IF cl_null(tm.dbs) THEN
      LET tm.dbs = g_dbs
      LET tm.plant = g_plant
   ELSE
#      CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069
      CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
      CLOSE DATABASE
      DATABASE tm.dbs
#      CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
      CALL cl_ins_del_sid(1,tm.plant) #FUN-980030   #FUN-990069
   END IF
 
#   IF NOT cl_null(tm.rate) THEN
#      LET g_bgjob='Y'
#      LET tm.detail='N'
#      LET tm.sales_detail='N'
#      LET tm.minus ='N'
#      LET tm.diff  ='Y'
#      LET g_wc = ' 1=1'
#      CALL p100()
#      EXIT PROGRAM
#   END IF
 
#   LET tm.detail='Y'
#   LET tm.sales_detail='Y'
#   LET tm.minus ='Y'
#   LET tm.diff  ='Y'
#   LET tm.rate  =10
#   LET p_row = 5 LET p_col = 20
#
#   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "apm/42f/apmp100"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#  
#    CALL cl_ui_init()
#
#
#   CALL cl_opmsg('q')
#   IF g_sma.sma111='N' THEN
#      CALL cl_err('sma111=N','apm-024',1)
#      CLOSE WINDOW p100_w
#      EXIT PROGRAM
#    END IF
#
#   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
#   LET yy=g_ccz.ccz01
#   LET mm=g_ccz.ccz02
#   DISPLAY BY NAME yy,mm
#   LET b_date=MDY(mm+1,1,yy)
#
#   WHILE TRUE
#       IF s_shut(0) THEN
#         EXIT WHILE
#      END IF
#
#      LET g_flag = 'Y'
#      CALL p100_ask()
#
#      IF g_flag = 'N' THEN
#         CONTINUE WHILE
#       END IF
#
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         EXIT WHILE
#      END IF
#
#      IF cl_sure(10,10) THEN
#         LET start_date=TODAY
#          LET t_time = TIME
#         LET start_time=t_time
#         CALL cl_wait()
#         LET g_success = 'Y'
#         CALL p100()
#         IF g_success = 'Y' THEN
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#          END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#
#   END WHILE
 
#   CLOSE WINDOW p100_w
#NO.FUN-570138 mark------
 
#NO.FUN-570138 start--
   WHILE TRUE
      IF g_bgjob= "N" THEN
         IF NOT cl_null(tm.rate) THEN   #表示為有傳入值
            LET g_bgjob='Y'
            LET tm.detail='N'
            LET tm.sales_detail='N'
            LET tm.minus ='N'
            LET tm.diff  ='Y'
            LET g_wc = ' 1=1'
            CALL p100()
            EXIT PROGRAM
         END IF
         CALL p100_ask()
         IF cl_sure(18,20) THEN
            LET start_date=TODAY
            LET t_time = TIME
            LET start_time=t_time
            LET g_success = 'Y'
            CALL p100()
            IF g_success = 'Y' THEN
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p100_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p100_w
      ELSE
         LET g_success = 'Y'
         CALL p100()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570138 ---end---

     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p100_ask()
   DEFINE c             LIKE type_file.chr10            #No.FUN-680136 VARCHAR(10)  #No.TQC-6A0079
   DEFINE lc_cmd        LIKE type_file.chr1000          #No.FUN-680136 VARCHAR(500)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "apm/42f/apmp100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   IF g_sma.sma111='N' THEN
      CALL cl_err('sma111=N','apm-024',1)
      CLOSE WINDOW p100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
    END IF
 
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   LET yy=g_ccz.ccz01
   LET mm=g_ccz.ccz02
   DISPLAY BY NAME yy,mm
   LET b_date=MDY(mm+1,1,yy)
#NO.FUN-570138 end-------
   WHILE TRUE   #NO.FUN-570138
   ERROR ''
   CONSTRUCT BY NAME g_wc ON ima01,ima08,ima06,ima09,ima10,ima11,ima12
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        ON ACTION locale                    #genero
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang = TRUE                  #NO.FUN-570138
           EXIT CONSTRUCT
 
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
#NO.FUN-570138 start--
#     IF g_action_choice = "locale" THEN  #genero
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        LET g_flag = 'N'
#        RETURN
#     END IF
 
#     IF INT_FLAG THEN
#        RETURN
#     END IF
 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p100_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
#NO.FUN-570138 end----------------
 
     LET g_wc=g_wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
     LET g_bgjob = 'N' #NO.FUN-570138 
 
     INPUT BY NAME yy,mm,tm.edate,tm.detail,tm.sales_detail,tm.minus,
                   #tm.diff,tm.rate WITHOUT DEFAULTS
                   tm.diff,tm.rate,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570138 
 
           AFTER INPUT
              IF INT_FLAG THEN EXIT INPUT END IF
              IF cl_null(tm.detail) OR tm.detail NOT MATCHES '[YN]' THEN
                 NEXT FIELD detail
              END IF
              IF cl_null(tm.sales_detail)
                 OR tm.sales_detail NOT MATCHES '[YN]' THEN
                 NEXT FIELD sales_detail
              END IF
              IF cl_null(tm.minus) OR tm.minus NOT MATCHES '[YN]' THEN
                 NEXT FIELD minus
              END IF
              IF cl_null(tm.diff) OR tm.diff NOT MATCHES '[YN]' THEN
                 NEXT FIELD diff
              END IF
              IF tm.rate='Y' AND (tm.rate IS NULL OR tm.rate<=0) THEN
                 NEXT FIELD rate
              END IF
              IF cl_null(tm.edate) THEN
                 NEXT FIELD edate
              END IF
              IF yy IS NULL OR yy <=0 THEN
                 NEXT FIELD yy
              END IF
              IF mm IS NULL OR mm <=0 THEN
                 NEXT FIELD mm
              END IF
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
           ON ACTION exit  #加離開功能genero
              LET INT_FLAG = 1
              EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
#NO.FUN-570138 start--
        ON ACTION locale                    #genero
           LET g_change_lang = TRUE    
           EXIT INPUT  
#NO.FUN-570138 end---
 
     END INPUT
#NO.FUN-570138  start---
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p100_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
 
#     IF INT_FLAG THEN
#        RETURN
#     END IF
      IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp100"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp100','9031',1)
        ELSE
           LET g_wc=cl_replace_str(g_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.rate CLIPPED ,"'",
                        " '",tm.dbs CLIPPED ,"'",
                        " '",tm.plant CLIPPED ,"'", 
                        " '",g_wc CLIPPED ,"'",
                        " '",yy CLIPPED ,"'",
                        " '",mm CLIPPED ,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.detail CLIPPED,"'",
                        " '",tm.sales_detail CLIPPED,"'",
                        " '",tm.minus CLIPPED,"'",
                        " '",tm.diff CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp100',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p100_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
#->No.FUN-570138 ---end---
     EXIT WHILE
END WHILE
 
END FUNCTION
 
FUNCTION p100()
DEFINE l_ima01o LIKE ima_file.ima01
DEFINE l_tot    LIKE type_file.num10              #No.FUN-680136 INTEGER
DEFINE l_amt    LIKE type_file.num20_6            #No.FUN-680136 DECIMAL(20,6)
DEFINE l_price  LIKE ima_file.ima91               #FUN-4C0011
DEFINE l_base   LIKE ima_file.ima91               #FUN-4C0011
DEFINE l_diff   LIKE ima_file.ima91               #FUN-4C0011
DEFINE b_tot    LIKE type_file.num10              #No.FUN-680136 INTEGER
DEFINE b_amt    LIKE type_file.num20_6            #No.FUN-680136 DECIMAL(20,6)
DEFINE b_price  LIKE ima_file.ima91               #FUN-4C0011
DEFINE l_rate   LIKE type_file.num20_6            #No.FUN-680136 DECIMAL(20,6)
DEFINE l_remark LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
DEFINE l_price_o LIKE type_file.num20_6           #No.FUN-680136 DECIMAL(20,6)
DEFINE sr RECORD
          ima01     LIKE ima_file.ima01,
          u_type    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          u_date    LIKE type_file.dat,           #No.FUN-680136 DATE
          u_qty     LIKE img_file.img10,
          u_price   LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)
          u_slip    LIKE rvb_file.rvb01,          #No.FUN-680136 VARCHAR(16)
          u_ln      LIKE type_file.num5           #No.FUN-680136 SMALLINT
          END RECORD
DEFINE srb RECORD
          ima01     LIKE ima_file.ima01,
          u_type    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          u_date    LIKE type_file.dat,           #No.FUN-680136 DATE
          u_qty     LIKE img_file.img10,
          u_price   LIKE type_file.num20_6,       #No.FUN-680136 DECIMAL(20,6)
          u_slip    LIKE rvb_file.rvb01,          #No.FUN-680136 VARCHAR(16)
          u_ln      LIKE type_file.num5           #No.FUN-680136 SMALLINT
          END RECORD
DEFINE l_name       LIKE type_file.chr20,         #No.FUN-680136 VARCHAR(20)
       l_za05       LIKE za_file.za05
 
DROP TABLE x
#No.FUN-680136--begin
#CREATE TEMP TABLE x
#(
#   ima01  VARCHAR(40),    #FUN-560011
#   u_type VARCHAR(1),
#   u_date DATE,
#   u_qty  DEC(10,0),
#   u_price DEC(20,6), #FUN-4C0011
#   u_slip  VARCHAR(10),
#   u_slip    VARCHAR(16),     #No.FUN-550060
#   u_ln    SMALLINT
#);
CREATE TEMP TABLE x(
    ima01 LIKE ima_file.ima01,
    u_type LIKE type_file.chr1,  
    u_date LIKE type_file.dat,   
    u_qty  LIKE type_file.num10, 
    u_price LIKE type_file.num20_6,
    u_slip LIKE rvb_file.rvb01,
    u_ln LIKE type_file.num5);
#No.FUN-680136--end
#->No.FUN-570138 ---start---
     IF g_sma.sma111='N' THEN    #是否使用移動加權平均
        CALL cl_err('sma111=N','apm-024',1)
        CALL cl_batch_bg_javamail("N")
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
#->No.FUN-570138 ---end---
#No.CHI-6A0004-------Begin--------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004------End----------
#TQC-6A0089--begin--                                                                                                                
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmp100'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 160  END IF   #No.TMOD-5A0121 #No.FUN-5A0139 modify
    FOR g_i = 1 TO g_len                                                                                                            
       LET g_dash[g_i,g_i] = '='                                                                                                    
    END FOR                                                                                                                         
#TQC-6A0089--end--
    CALL cl_outnam('apmp100') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    START REPORT p100_rep TO l_name
 
LET g_tot=0 #count diff times
LET g_sql="SELECT cca01,'1','",MDY(mm,1,yy),"',cca11,cca23,'',''",
          " FROM cca_file,ima_file",
          " WHERE cca01=ima01",
          "  AND cca02=",yy,
          "  AND cca03=",mm,
          "  AND ",g_wc
 
   PREPARE p100_p1 FROM g_sql
   DECLARE p100_c1 CURSOR WITH HOLD FOR p100_p1
   FOREACH p100_c1 INTO sr.*
      INSERT INTO x VALUES(sr.*)
   END FOREACH
 
LET g_sql="SELECT rvb05,'2',rva06,rvb07,rvb10*rva27,rvb01,rvb02",
          " FROM rva_file,rvb_file,ima_file",
          " WHERE rvb05=ima01",
          "   AND rva01=rvb01",
          "   AND rva06<='",tm.edate,"'",
          "   AND rvaconf='Y'",
          "   AND ",g_wc
 
   PREPARE p100_p2 FROM g_sql
   DECLARE p100_c2 CURSOR WITH HOLD FOR p100_p2
   FOREACH p100_c2 INTO sr.*
      INSERT INTO x VALUES(sr.*)
   END FOREACH
 
#雜收
 
LET g_sql="SELECT inb04,'3',ina02,inb09,COALESCE(inb13,0)+COALESCE(inb132,0)
              +COALESCE(inb133,0)+COALESCE(inb134,0)+COALESCE(inb135,0)+COALESCE(inb136,0)
              +COALESCE(inb137,0)+COALESCE(inb138,0),inb01,inb03", #FUN-AB0089
          " FROM ina_file,inb_file,ima_file",
          " WHERE inb04=ima01",
          "   AND ina01=inb01",
          "   AND ina02<='",tm.edate,"'",
          "   AND inapost='Y'",
          "   AND ina00='3'",
          "   AND ina02>='",b_date,"'",
          "   AND ",g_wc
 
   PREPARE p100_p3 FROM g_sql
   DECLARE p100_c3 CURSOR WITH HOLD FOR p100_p3
   FOREACH p100_c3 INTO sr.*
      IF sr.u_price IS NULL THEN LET sr.u_price=0 END IF
      INSERT INTO x VALUES(sr.*)
   END FOREACH
 
#銷退 單價比較麻煩-->可能此刻的成本=0 :(
LET g_sql="SELECT ohb04,'4',oha02,ohb12,ohb13*oha24,ohb01,ohb03",
          " FROM oha_file,ohb_file,ima_file",
          " WHERE ohb04=ima01",
          "   AND oha02<='",tm.edate,"'",
          "   AND oha01=ohb01",
          "   AND ohaconf='Y'",
          "   AND ohb12>0  ",
          "   AND ",g_wc
 
   PREPARE p100_p4 FROM g_sql
   DECLARE p100_c4 CURSOR WITH HOLD FOR p100_p4
   FOREACH p100_c4 INTO sr.*
      #先抓該筆銷退的原始出貨成本
{      IF NOT cl_null(sr.u_slip) AND NOT cl_null(sr.u_ln) THEN
         SELECT ogb901 INTO sr.u_price
           FROM ogb_file
          WHERE ohb01=sr.u_slip AND ohb03=sr.u_ln
            AND ogb01=ohb31 AND ogb03=ohb32
      END IF
}
      IF sr.u_price IS NULL THEN LET sr.u_price=0 END IF
      INSERT INTO x VALUES(sr.*)
   END FOREACH
 
#出貨
LET g_sql="SELECT ogb04,'5',oga02,ogb12*-1,0,ogb01,ogb03",
          " FROM oga_file,ogb_file,ima_file",
          " WHERE ogb04=ima01",
          "   AND oga02<='",tm.edate,"'",
          "   AND oga01=ogb01",
          "   AND ogaconf='Y'",
          "   AND oga09 IN ('2','8') ",  #No.FUN-610020
          "   AND oga65 ='N' ",  #No.FUN-610020
          "  AND ",g_wc
 
   PREPARE p100_p5 FROM g_sql
   DECLARE p100_c5 CURSOR WITH HOLD FOR p100_p5
   FOREACH p100_c5 INTO sr.*
      INSERT INTO x VALUES(sr.*)
   END FOREACH
#雜發
LET g_sql="SELECT inb04,'6',ina02,inb09*-1,0,inb01,inb03",
          " FROM ina_file,inb_file,ima_file",
          " WHERE inb04=ima01",
          "   AND ina01=inb01",
          "   AND ina02<='",tm.edate,"'",
          "   AND inapost='Y'",
          "   AND ina00='1'",
          "  AND ",g_wc
 
   PREPARE p100_p6 FROM g_sql
   DECLARE p100_c6 CURSOR WITH HOLD FOR p100_p6
   FOREACH p100_c6 INTO sr.*
      INSERT INTO x VALUES(sr.*)
   END FOREACH
   select count(*) into g_cnt from x
   IF g_bgjob = 'N' THEN  #NO.FUN-570138
       display g_cnt to no_tot
   END IF
 
   LET g_sql="SELECT * FROM x",
             " ORDER BY ima01,u_date,u_type"
   PREPARE p100_p7 FROM g_sql
   DECLARE p100_c7 CURSOR WITH HOLD FOR p100_p7
   LET l_ima01o=' '
   FOREACH p100_c7 INTO sr.*
      IF l_ima01o<>sr.ima01 THEN
         LET l_tot=0
         LET l_amt=0
         LET l_price=0
         LET l_ima01o=sr.ima01
      END IF
      IF sr.u_type='4' AND sr.u_price=0 THEN #銷退 且無單價則以前一筆單價帶入
         LET sr.u_price=l_price
      END IF
      IF sr.u_qty>0 THEN
         LET l_price=(l_price*l_tot+sr.u_qty*sr.u_price)/(l_tot+sr.u_qty)
         IF (l_tot+sr.u_qty)=0 THEN LET l_price=sr.u_price END IF
         IF l_price <=0 THEN LET l_price =sr.u_price END IF
      END IF
      LET l_tot=l_tot+sr.u_qty
      LET l_amt=l_tot*l_price
      IF l_tot<0 AND tm.minus='Y' THEN
         LET g_msg=g_x[11] CLIPPED,sr.u_slip CLIPPED,' ',
                   g_x[12] CLIPPED,sr.u_ln USING '##&',' ',
                   g_x[13] CLIPPED,sr.ima01 CLIPPED,' ',
                   g_x[14] CLIPPED,cl_numfor(l_price,15,g_azi03),' ',
                   g_x[15] CLIPPED,l_tot USING '---,---,--&'
         OUTPUT TO REPORT p100_rep(g_msg)
      END IF
      IF sr.u_type='5' THEN #銷貨
         LET l_remark = ''
         IF l_price = 0 OR l_price IS NULL THEN
            LET l_remark = '*'
         END IF
  #????暫時mark
  #      SELECT ogb901 INTO l_price_o FROM ogb_file
  #            WHERE ogb01=sr.u_slip AND ogb03=sr.u_ln
  #      IF l_price_o IS NULL OR l_price_o=0
  #         THEN
  #         UPDATE ogb_file SET ogb901=l_price
  #            WHERE ogb01=sr.u_slip AND ogb03=sr.u_ln
  #      END IF
  #????(end)
# 把↑↑↑↑↑↑↑↑↑↑的暫時MARK掉的了人是誰，快來把代碼吞了！！jr
 
       IF tm.sales_detail='Y' THEN
         LET g_msg=g_x[16] CLIPPED,sr.u_slip,' ',
                   g_x[12] CLIPPED,sr.u_ln USING '###',' ',
                   g_x[13] CLIPPED,sr.ima01 CLIPPED,' ',
                   g_x[18] CLIPPED,sr.u_qty USING '------&.&&',' ',
                  #g_x[14] CLIPPED,l_remark,l_price  USING '###,##&.&&'
                   g_x[14] CLIPPED,cl_numfor(l_price,15,g_azi03)
         OUTPUT TO REPORT p100_rep(g_msg)
       END IF
      END IF
      IF l_price IS NULL THEN LET l_price=0 END IF
     #UPDATE ima_file SET ima91=l_price WHERE ima01=sr.ima01                    #FUN-C30315 mark
      UPDATE ima_file SET ima91=l_price,imadate = g_today WHERE ima01=sr.ima01  #FUN-C30315 add
      IF tm.detail='Y' THEN
         LET g_msg=g_x[13] CLIPPED,sr.ima01 CLIPPED,' ',
                   g_x[19] CLIPPED,sr.u_slip,' ',
                   g_x[18] CLIPPED,sr.u_qty USING '------&.&&',' ',
                  #g_x[14] CLIPPED,l_remark,l_price  USING '---,--&.&&',' ',
                   g_x[14] CLIPPED,cl_numfor(l_price,15,g_azi03),' ',
                   g_x[20] CLIPPED,l_tot    USING '------&.&&',' ',
                   g_x[21] CLIPPED,cl_numfor(l_amt,18,g_azi04)
         OUTPUT TO REPORT p100_rep(g_msg)
      END IF
### if price different too big more than tm.rate %,out the error report
         IF sr.ima01=srb.ima01 AND l_price<> b_price AND tm.diff='Y' THEN
            LET l_diff=l_price-b_price
            IF l_diff<0 THEN LET l_diff=l_diff*-1 END IF
            IF l_price>b_price THEN LET l_base=l_price ELSE LET l_base=b_price END IF
            IF l_base <0 THEN LET l_base=l_base *-1 END IF
            LET l_rate=(l_diff/l_base)*100
            IF l_rate>tm.rate THEN
               LET g_tot=g_tot+1
               LET g_msg=g_x[13] CLIPPED,srb.ima01 CLIPPED,' ',
                         g_x[19] CLIPPED,srb.u_slip,' ',
                         g_x[18] CLIPPED,srb.u_qty USING '------&.&&',' ',
                         g_x[14] CLIPPED,cl_numfor(b_price,15,g_azi03),' ',
                         g_x[20] CLIPPED,b_tot    USING '------&.&&',' ',
                         g_x[21] CLIPPED,cl_numfor(b_amt,18,g_azi04)
               OUTPUT TO REPORT p100_rep(g_msg)
               LET g_msg=g_x[13] CLIPPED,sr.ima01 CLIPPED,' ',
                         g_x[19] CLIPPED,sr.u_slip,' ',
                         g_x[18] CLIPPED,sr.u_qty USING '------&.&&',' ',
                         g_x[14] CLIPPED,cl_numfor(l_price,15,g_azi03),' ',
                         g_x[20] CLIPPED,l_tot    USING '------&.&&',' ',
                         g_x[21] CLIPPED,cl_numfor(l_amt,18,g_azi04)
               OUTPUT TO REPORT p100_rep(g_msg)
            END IF
         END IF
### if price different too big more than tm.rate %,out the error report
## store old value
         LET srb.*=sr.*
         LET b_price=l_price
         LET b_tot  =l_tot
         LET b_amt  =l_amt
## store old value
   END FOREACH
   FINISH REPORT p100_rep
   IF g_bgjob='N' THEN
      CALL cl_prt(l_name,' ','1',g_len)
   END IF
 
END FUNCTION
 
REPORT p100_rep(l_msg)
   DEFINE l_msg         LIKE ze_file.ze03        #No.FUN-680136 VARCHAR(200)
   DEFINE l_last_sw     VARCHAR(1)   #No.TQC-6A0089 add 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#   FORMAT ON EVERY ROW PRINT l_msg CLIPPED    #TQC-6A0089
#No.TQC-6A0089--BEGIN                                                                                                               
   FORMAT                                                                                                                           
    PAGE HEADER                                                                                                                     
    PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED  #MOD-                                                    
    IF g_towhom IS NULL OR g_towhom = ' ' THEN                                                                                      
        PRINT '';                                                                                                                   
    ELSE                                                                                                                            
        PRINT 'TO:',g_towhom;                                                                                                       
    END IF                                                                                                                          
    PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED                                                                 
    PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]                                                                                 
    PRINT ' '                                                                                                                       
    PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',                                                                                     
          COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'                                                                          
    PRINT g_dash[1,g_len]                                                                                                           
    LET l_last_sw = 'n'                                                                                                             
  #  PRINT g_dash_1[1,g_len]
 
    ON EVERY ROW PRINT l_msg CLIPPED                                                                                                
    ON LAST ROW                                                                                                                     
        PRINT g_dash[1,g_len]                                                                                                       
        LET l_last_sw = 'y'                                                                                                         
        PRINT g_x[4],g_x[5] CLIPPED,                                                                                                
              COLUMN (g_len-9), g_x[7] CLIPPED                                                                                      
                                                                                                                                    
    PAGE TRAILER                                                                                                                    
        IF l_last_sw = 'n' THEN                                                                                                     
            PRINT g_dash[1,g_len]                                                                                                   
            PRINT g_x[4],g_x[5] CLIPPED,                                                                                            
            COLUMN (g_len-9),g_x[6] CLIPPED                                                                                         
        ELSE                                                                                                                        
            SKIP 2 LINE                                                                                                             
        END IF                                                                                                                      
#No.TQC-6A0089---END  
END REPORT
#Patch....NO.TQC-610036 <001,002> #

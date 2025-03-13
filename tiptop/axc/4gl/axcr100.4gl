# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr100.4gl
# Descriptions...: 工單領退明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/27 By Jackson
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/27 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為dec(20,6)
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570088 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610051 06/02/13 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-610092 06/05/25 By Joe 增加庫存單位欄位
# Modify.........: No.TQC-670037 06/07/11 By Claire 數量應sum
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/08/31 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-7C0101 08/01/25 By ChenMoyan 成本改善報表部分
# Modify.........: No.MOD-820020 08/03/23 By Pengu 數量不應在乘上轉換率
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40023 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(600)      # Where condition
              yy      LIKE type_file.num5,           #No.FUN-680122SMALLINT
              mm      LIKE type_file.num5,           #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,           #No.FUN-7C0101
              detail_sw LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
              order_sw  LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)# Input more condition(Y/N)
              END RECORD,
          g_bdate LIKE type_file.dat,            #No.FUN-680122DATE
          g_edate LIKE type_file.dat,            #No.FUN-680122DATE
          g_tot_bal LIKE type_file.num20_6         #No.FUN-680122DECIMAL(20,6)     # User defined variable
   DEFINE yy,mm LIKE type_file.num5              #No.FUN-680122SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.type = ARG_VAL(15)      # No.FUN-7C0101
   #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.detail_sw = ARG_VAL(10)
   LET tm.order_sw = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr100_tm(0,0)        # Input print condition
      ELSE CALL axcr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400) 
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr100_w AT p_row,p_col
        WITH FORM "axc/42f/axcr100" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy=year(g_today)
   LET tm.mm=month(g_today)
   LET tm.type = g_ccz.ccz28          # No.FUN-7C0101
   LET tm.detail_sw='N'
   LET tm.order_sw='1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tlf62,tlf01,ima2.ima57,ima2.ima06,ima2.ima09,ima2.ima10,ima2.ima11,ima2.ima12
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
            IF INFIELD(tlf01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO tlf01                                                                                 
               NEXT FIELD tlf01                                                                                                     
            END IF  
#No.FUN-570240 --end-- 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   LET tm.wc=tm.wc CLIPPED," AND ima2.ima01 NOT MATCHES 'MISC*'"
  #INPUT BY NAME tm.yy,tm.mm,tm.detail_sw,tm.order_sw,tm.more         #No.FUN-7C0101
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.detail_sw,tm.order_sw,tm.more #No.FUN-7C0101
                 WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm
#No.FUN-7C0101 --Begin
      AFTER FIELD type
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF 
#No.FUN-7C0101 --End
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr100','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-610051-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",      #No.FUN-7C0101
                         " '",tm.detail_sw CLIPPED,"'",
                         " '",tm.order_sw CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr100()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr100_w
END FUNCTION
 
FUNCTION axcr100()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(3000)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          xxx       LIKE aab_file.aab02,         #No.FUN-680122 VARCHAR(5)       #No.FUN-550025
          u_sign    LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr1000,        #No.FUN-680122CHAR(40) #No.FUN-550025 #FUN-5B0105 16->40
          l_ima53   LIKE ima_file.ima53, 
          l_ima91   LIKE ima_file.ima91, 
          l_ima531   LIKE ima_file.ima531,
          l_smydmy1  LIKE smy_file.smydmy1,
          l_smydmy2  LIKE smy_file.smydmy2,
          l_tlf12   LIKE tlf_file.tlf12,  
          cost_code1,cost_code2	LIKE aba_file.aba18,           #No.FUN-680122
#          qty1      LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3) #FUN-A40023
          qty1      LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3) #FUN-A40023
          amt1	    LIKE type_file.num20_6,          #No.FUN-680122 DECIMAL(20,6)
          sr   RECORD 
               order1  LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 20->40
               sfb05   LIKE sfb_file.sfb05,    #成品料號
               tlf62   LIKE tlf_file.tlf62,    #工單單號
               tlf026  LIKE tlf_file.tlf026,   #單據單號
               desc    LIKE smy_file.smydesc,  #單據名稱
               tlf06   LIKE tlf_file.tlf06,    #單據日期 
               tlf10   LIKE tlf_file.tlf10,    #數量     
               ccc23   LIKE ccc_file.ccc23,    #單價     
               amt     LIKE type_file.num20_6,         #金額            #No.FUN-680122 DECIMAL(20,6)
               code    LIKE type_file.chr1,    #1:領;2:退       #No.FUN-680122CHAR(1)
               tlf01   LIKE tlf_file.tlf01     #數量     
               END RECORD
 
     CALL s_azn01(tm.yy,tm.mm) RETURNING g_bdate,g_edate
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
      LET l_sql = " SELECT '',sfb05,tlf62,tlf026,' ',tlf06,tlf10*tlf60,0,0,'1',tlf01,", #MOD-570088
                 "        tlf12,ima1.ima57,ima2.ima57",
                 "   FROM tlf_file,sfb_file,ima_file ima1,ima_file ima2 ",
                 "  WHERE tlf02 BETWEEN 50 AND 59 ",
                 "    AND tlf03 >= 60 AND tlf03 <= 69 ",
                 "    AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                 "    AND ",tm.wc CLIPPED,
                 "    AND tlf62=sfb01 AND sfb05=ima1.ima01",
                 "    AND tlf01=ima2.ima01",
                 "    AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                 "    AND tlf13 MATCHES 'asfi5*' ",#BugNO:3263 01/09/06 mandy
                 " UNION ALL ",
                  " SELECT '',sfb05,tlf62,tlf036,' ',tlf06,tlf10*tlf60,0,0,'2',tlf01,", #MOD-570088
                 "        tlf12,ima1.ima57,ima2.ima57",
                 "   FROM tlf_file,sfb_file,ima_file ima1,ima_file ima2 ",
                 "  WHERE tlf03 BETWEEN 50 AND 59 ",
                 "    AND tlf02 >= 60 AND tlf02 <= 69 ",
                 "    AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                 "    AND ",tm.wc CLIPPED,
                 "    AND tlf62=sfb01 AND sfb05=ima1.ima01",
                 "    AND tlf01=ima2.ima01",
                 "    AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                 "    AND tlf13 MATCHES 'asfi5*' " #BugNO:3263 01/09/06 mandy
 
     PREPARE axcr100_pr FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr100_cs1 CURSOR FOR axcr100_pr
 
     CALL cl_outnam('axcr100') RETURNING l_name
     START REPORT axcr100_rep TO l_name
     LET g_pageno = 0
     FOREACH axcr100_cs1 INTO sr.*,l_tlf12,cost_code1,cost_code2
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #No.FUN-550025 --start--
     #  LET xxx=sr.tlf026[1,3] 
       CALL s_get_doc_no(sr.tlf026) RETURNING xxx
     #No.FUN-550025 --end--  
       SELECT smydesc,smydmy1,smydmy2
         INTO sr.desc,l_smydmy1,l_smydmy2 FROM smy_file WHERE smyslip=xxx
       IF l_smydmy1 = 'N' THEN CONTINUE FOREACH END IF
       IF l_smydmy2 != '3' THEN CONTINUE FOREACH END IF
       SELECT ccc25,ccc26,ccc23
         INTO qty1,amt1,sr.ccc23
         FROM ccc_file 
        WHERE ccc01=sr.tlf01 AND ccc02=tm.yy AND ccc03=tm.mm
         AND ccc07=tm.type                   #No.FUN-7C0101
       IF cl_null(qty1    ) THEN LET qty1    =0 END IF
       IF cl_null(amt1    ) THEN LET amt1    =0 END IF
       IF cl_null(sr.ccc23) THEN LET sr.ccc23=0 END IF
       IF cost_code1>=cost_code2 THEN
          IF qty1 <> 0
             THEN LET sr.ccc23=amt1/qty1
             ELSE LET sr.ccc23=0
          END IF
       END IF
       IF cl_null(l_tlf12) THEN LET l_tlf12=1 END IF
      #-----------No.MOD-820020 modify
      #IF sr.code='1' THEN LET sr.amt=sr.tlf10*sr.ccc23*l_tlf12 
      #   ELSE LET sr.amt=sr.tlf10*sr.ccc23*(-1)*l_tlf12
      #        LET sr.tlf10=sr.tlf10*(-1)*l_tlf12
      #END IF
       IF sr.code='1' THEN 
          LET sr.amt=sr.tlf10*sr.ccc23 
       ELSE 
          LET sr.amt=sr.tlf10*sr.ccc23*(-1)
          LET sr.tlf10=sr.tlf10*(-1)
       END IF
      #-----------No.MOD-820020 end
       IF tm.order_sw='1'
          THEN LET sr.order1=sr.sfb05
          ELSE LET sr.order1=sr.tlf62
       END IF
       OUTPUT TO REPORT axcr100_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axcr100_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.8741
REPORT axcr100_rep(sr)
#   DEFINE qty          LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3) #FUN-A40023
   DEFINE qty          LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3) #FUN-A40023
          u_p          LIKE type_file.num20_6,          #No.FUN-680122DEC(20,6)
          amt          LIKE type_file.num20_6           #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
          l_ima02  LIKE ima_file.ima02,     #品名規格    #FUN-4C0099
          l_ima021 LIKE ima_file.ima021,    #品名規格    #FUN-4C0099
          l_ima25  LIKE ima_file.ima25,     #庫存單位    #FUN-610092
          sr   RECORD 
               order1  LIKE type_file.chr1000,        #No.FUN-680122CHAR(40) #FUN-5B0105 20->40
               sfb05   LIKE sfb_file.sfb05,    #成品料號
               tlf62   LIKE tlf_file.tlf62,    #工單單號
               tlf026  LIKE tlf_file.tlf026,   #單據單號
               desc    LIKE smy_file.smydesc,  #單據名稱
               tlf06   LIKE tlf_file.tlf06,    #單據日期 
               tlf10   LIKE tlf_file.tlf10,    #數量     
               ccc23   LIKE ccc_file.ccc23,    #單價     
               amt     LIKE type_file.num20_6,         #金額            #No.FUN-680122 DECIMAL(20,6)
               code    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)                #1:領;2:退
               tlf01   LIKE tlf_file.tlf01     #數量     
               END RECORD,
#      l_qty        LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A40023
      l_qty        LIKE type_file.num15_3,           #FUN-A40023
      l_amt        LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1, sr.tlf62,sr.code,sr.tlf026
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.yy USING '####',' ',
            g_x[10] CLIPPED,tm.mm USING '##'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
          ##g_x[36],g_x[37],g_x[38],g_x[39]          ##NO.FUN-610092
            g_x[40],g_x[36],g_x[37],g_x[38],g_x[39]  ##NO.FUN-610092
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
    IF tm.detail_sw='Y' THEN
         PRINT COLUMN g_c[35],sr.tlf01,
               COLUMN g_c[37],cl_numfor((sr.tlf10),37,g_ccz.ccz27),    #FUN-570190  #TQC-670037 14->37 #CHI-690007 g_azi03->g_ccz.ccz27
               COLUMN g_c[39],cl_numfor(sr.amt,39,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
    END IF
   AFTER GROUP OF sr.tlf026
    ##SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                ##NO.FUN-610092       
      SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file  ##NO.FUN-610092
          WHERE ima01=sr.sfb05
      IF SQLCA.sqlcode THEN 
          LET l_ima02  = NULL 
          LET l_ima021 = NULL 
          LET l_ima25  = NULL  ##NO.FUN-610092 
      END IF
      PRINT COLUMN g_c[31],sr.sfb05,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[40],l_ima25,   ##NO.FUN-610092
            COLUMN g_c[34],sr.tlf62,
            COLUMN g_c[35],sr.tlf026,
            COLUMN g_c[36],sr.desc,
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.tlf10),37,g_ccz.ccz27), #TQC-670037 add
            COLUMN g_c[38],sr.tlf06,
            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.amt),39,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
 
   AFTER GROUP OF sr.tlf62 
         PRINT COLUMN g_c[38],g_x[13] CLIPPED,
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.amt),39,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT 
   AFTER GROUP OF sr.order1 
    IF tm.order_sw='1' THEN
         PRINT COLUMN g_c[38],g_x[14] CLIPPED,
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.amt),39,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT 
    END IF
 
   ON LAST ROW
      PRINT COLUMN g_c[38],g_x[15] CLIPPED,
            COLUMN g_c[39],cl_numfor(SUM(sr.amt),39,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[39],g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[39],g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT

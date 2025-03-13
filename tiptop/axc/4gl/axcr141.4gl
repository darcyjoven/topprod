# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr141.4gl
# Descriptions...: 料件單價比較表 
# Date & Author..: 94/09/08
# Modify.........: 00/12/01 By Kammy (改可以多工廠比較)
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0064 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0099 05/01/21 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.FUN-5B0123 05/12/08 By Sarah 應排除出至境外倉部份(add oga00<>'3')
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.MOD-630112 06/03/28 By Claire 加入一個Flag判斷日期區間
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-7C0101 08/01/25 By Zhangyajun 成本改善增加成本計算類型字段(type1)
# Modify.........: No.FUN-830002 08/03/03 By dxfwo 成本改善的index之前改過后出現報表打印不出來的問題修改
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.MOD-8C0130 08/12/15 By clover r141_tmp item 欄位型態改變
# Modify.........: No.TQC-940184 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法   
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/21 By wuxj GP5.2 跨DB 報表財務類 修改
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A40130 10/04/28 By Carrier GP5.2报表追单
# Modify.........: No:MOD-B30038 11/03/07 By sabrina 營運中心、日期位置偏移
# Modify.........: No:MOD-C60010 12/06/01 By ck2yuan r141_curs1 where條件修改
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc STRING #No.TQC-A40130
   DEFINE tm  RECORD            
              ccc01   LIKE ccc_file.ccc01,
              ima12   LIKE ima_file.ima12,
              choice  LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01)      #HEAD '1'進料'2'銷售
              yy1_b,mm1_b,yy1_e,mm1_e LIKE type_file.num5,           #No.FUN-680122smallint,
              yy2_b,mm2_b,yy2_e,mm2_e LIKE type_file.num5,           #No.FUN-680122smallint,
              yy3_b,mm3_b,yy3_e,mm3_e LIKE type_file.num5,           #No.FUN-680122smallint,
              type1   LIKE type_file.chr1,           #No.FUN-7C0101CHAR(1)
              avg_amt LIKE type_file.num10,          #No.FUN-680122INTEGER
              range_amt LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
              azk01   LIKE azk_file.azk01,
              azk04   LIKE azk_file.azk04,
              plant1  LIKE azp_file.azp01,           #No.FUN-680122CHAR(10)
              plant2  LIKE azp_file.azp01,           #No.FUN-680122CHAR(10)
              plant3  LIKE azp_file.azp01,           #No.FUN-680122CHAR(10)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)
              END RECORD 
 
   DEFINE g_order ARRAY[2] OF LIKE cre_file.cre08           #No.FUN-680122CHAR(10)
   DEFINE g_bookno      LIKE aaa_file.aaa01   #No.FUN-670039
   DEFINE g_base        LIKE type_file.num10          #No.FUN-680122INTEGER
   DEFINE l_qty,qty1,qty2,qty3     LIKE ccc_file.ccc21
   DEFINE unit1,unit2,unit3  LIKE type_file.num20_6         #No.FUN-680122DEC(20,6)
   DEFINE g_bdate1,g_edate1 LIKE type_file.dat            #No.FUN-680122 DATE
   DEFINE g_bdate2,g_edate2 LIKE type_file.dat            #No.FUN-680122 DATE
   DEFINE g_bdate3,g_edate3 LIKE type_file.dat            #No.FUN-680122 DATE
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
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
 
  #TQC-610051-begin
   #LET g_bookno= ARG_VAL(1)      
   #LET g_pdate = ARG_VAL(2)      
   #LET g_towhom = ARG_VAL(3)
   #LET g_rlang = ARG_VAL(4)
   #LET g_bgjob = ARG_VAL(5)
   #LET g_prtway = ARG_VAL(6)
   #LET g_copies = ARG_VAL(7)
   #LET g_wc  = ARG_VAL(8)
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_wc    = ARG_VAL(7)
   LET tm.choice= ARG_VAL(8)
   LET tm.yy1_b = ARG_VAL(9)
   LET tm.mm1_b = ARG_VAL(10)
   LET tm.yy1_e = ARG_VAL(11)
   LET tm.mm1_e = ARG_VAL(12)
   LET tm.plant1= ARG_VAL(13)
   LET tm.yy2_b = ARG_VAL(14)
   LET tm.mm2_b = ARG_VAL(15)
   LET tm.yy2_e = ARG_VAL(16)
   LET tm.mm2_e = ARG_VAL(17)
   LET tm.plant2= ARG_VAL(18)
   LET tm.yy3_b = ARG_VAL(19)
   LET tm.mm3_b = ARG_VAL(20)
   LET tm.yy3_e = ARG_VAL(21)
   LET tm.mm3_e = ARG_VAL(22)
   LET tm.plant3= ARG_VAL(23)
   LET tm.avg_amt= ARG_VAL(24)
   LET tm.range_amt= ARG_VAL(25)
   LET tm.azk01 = ARG_VAL(26)
   LET tm.azk04 = ARG_VAL(27)
   LET g_rep_user = ARG_VAL(28)
   LET g_rep_clas = ARG_VAL(29)
   LET g_template = ARG_VAL(30)
   LET g_bookno = ARG_VAL(31)
   LET tm.type1   = ARG_VAL(32)
  #TQC-610051-end
   DROP TABLE r141_tmp
#No.FUN-680122 -- begin --
#   CREATE  TABLE r141_tmp
#   (dbs   VARCHAR(1),   #MOD-630112 
#    plant VARCHAR(10),
#    item  VARCHAR(20),
#    ym    INTEGER,
#    ima02 VARCHAR(30),
#    f1    DEC(20,6),
#    f2    DEC(20,6),
#    cur   VARCHAR(4)) #幣別
   CREATE TEMP TABLE r141_tmp
   (dbs   LIKE type_file.chr1,  
    plant LIKE azp_file.azp01,
    item  LIKE ima_file.ima01,   #MOD-8C0130
    ym    LIKE type_file.num10, 
    ima02 LIKE ima_file.ima02,
    f1    LIKE ogb_file.ogb16,   #No.MOD-950210 modify
    f2    LIKE ima_file.ima32,
    cur   LIKE azk_file.azk01,
    tlfccost LIKE tlfc_file.tlfccost)            #No.FUN-7C0101 add
#No.FUN-680122 -- end --
   CREATE INDEX tmpidx ON r141_tmp (ym);
   IF cl_null(g_bgjob) OR g_bgjob = 'N' 
      THEN CALL r141_tm(0,0)        
      ELSE CALL r141()             
   END IF
   DROP TABLE r141_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r141_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_date         LIKE type_file.dat,            #No.FUN-680122 DATE
          l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r141_w AT p_row,p_col
        WITH FORM "axc/42f/axcr141" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.choice = '1'
   LET tm.more = 'N'
   LET tm.type1 = g_ccz.ccz28      #No.FUN-7C0101 add
   LET tm.avg_amt =0
   LET tm.range_amt =0
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
WHILE TRUE
   CONSTRUCT BY NAME  g_wc ON ima01,ima12
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
            IF INFIELD(ima01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO ima01                                                                                 
               NEXT FIELD ima01                                                                                                     
            END IF  
#No.FUN-570240 --end-- 
     ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r141_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      
   DISPLAY BY NAME tm.more     
   INPUT BY NAME
			tm.choice,
			tm.yy1_b,
			tm.mm1_b,
			tm.yy1_e,
			tm.mm1_e,
                        tm.plant1,
			tm.yy2_b,
			tm.mm2_b,
			tm.yy2_e,
			tm.mm2_e,
                        tm.plant2,
			tm.yy3_b,
			tm.mm3_b,
			tm.yy3_e,
			tm.mm3_e,
                        tm.plant3,
                        tm.type1,         #No.FUN-7C0101 add tm.type1
			tm.avg_amt,
			tm.range_amt,
			tm.azk01,
			tm.azk04,
			tm.more
   WITHOUT DEFAULTS 
         AFTER FIELD azk01
#FUN-4B0064 modify
             IF NOT cl_null(tm.azk01) THEN 
                SELECT * FROM azi_file 
                WHERE azi01 = tm.azk01  
                IF STATUS != 0 THEN
#                  CALL cl_err('azk01','aap-002',1)   #No.FUN-660127
                   CALL cl_err3("sel","azi_file",tm.azk01,"","aap-002","","azk01",1)   #No.FUN-660127
                   NEXT FIELD azk01   
                END IF
 
                # azk04 賣出匯率
                SELECT MAX(azk02) INTO l_date FROM azk_file
                SELECT azk04 INTO tm.azk04 FROM azk_file
                WHERE azk01 = tm.azk01 AND azk02 =l_date
                DISPLAY BY NAME  tm.azk04
             ELSE
                LET tm.azk04 = 0
                DISPLAY BY NAME tm.azk04
             END IF
##
         BEFORE INPUT
           IF tm.yy1_b IS NULL THEN 
              LET tm.yy1_b=g_sma.sma51
              LET tm.yy2_b=g_sma.sma51
              LET tm.yy3_b=g_sma.sma51
              LET tm.yy1_e=g_sma.sma51
              LET tm.yy2_e=g_sma.sma51
              LET tm.yy3_e=g_sma.sma51
              DISPLAY BY NAME tm.yy1_b,tm.yy2_b,tm.yy3_b,
                              tm.yy1_e,tm.yy2_e,tm.yy3_e
              LET tm.mm1_b=g_sma.sma52
              LET tm.mm2_b=g_sma.sma52
              LET tm.mm3_b=g_sma.sma52
              LET tm.mm1_e=g_sma.sma52
              LET tm.mm2_e=g_sma.sma52
              LET tm.mm3_e=g_sma.sma52
              DISPLAY BY NAME tm.mm1_b,tm.mm2_b,tm.mm3_b,
                              tm.mm1_e,tm.mm2_e,tm.mm3_e
              LET tm.plant1=g_plant
              LET tm.plant2=g_plant
              LET tm.plant3=g_plant
              DISPLAY BY NAME tm.plant1,tm.plant2,tm.plant3
           END IF
         #No.FUN-580031 --start--
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy1_b
           IF tm.yy1_b <= 1911 OR cl_null(tm.yy1_b) THEN
              NEXT FIELD yy1_b
           END IF 
         AFTER FIELD yy2_b
           IF tm.yy2_b <= 1911 OR cl_null(tm.yy2_b) THEN
              NEXT FIELD yy2_b
           END IF 
         AFTER FIELD yy3_b
           IF tm.yy3_b <= 1911 OR cl_null(tm.yy3_b) THEN
              NEXT FIELD yy3_b
           END IF 
         AFTER FIELD mm1_b
           IF tm.mm1_b >12 OR tm.mm1_b <1 THEN
              NEXT FIELD mm1_b
           END IF 
         AFTER FIELD mm2_b
           IF tm.mm2_b >12 OR tm.mm2_b <1 THEN
              NEXT FIELD mm2_b
           END IF 
         AFTER FIELD mm3_b
           IF tm.mm3_b >12 OR tm.mm3_b <1 THEN
              NEXT FIELD mm3_b
           END IF 
         AFTER FIELD plant1
           IF cl_null(tm.plant1) THEN NEXT FIELD plant1 END IF
           SELECT * FROM azp_file WHERE azp01 = tm.plant1
           IF STATUS THEN
#             CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660127
              CALL cl_err3("sel","azp_file",tm.plant1,"",STATUS,"","sel azp:",0)   #No.FUN-660127
              NEXT FIELD plant1
           END IF
         AFTER FIELD plant2
           IF cl_null(tm.plant2) THEN NEXT FIELD plant2 END IF
           SELECT * FROM azp_file WHERE azp01 = tm.plant2
           IF STATUS THEN
#             CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660127
              CALL cl_err3("sel","azp_file",tm.plant2,"",STATUS,"","sel azp:",0)   #No.FUN-660127
              NEXT FIELD plant2
           END IF
         AFTER FIELD plant3
           IF cl_null(tm.plant3) THEN NEXT FIELD plant3 END IF
           SELECT * FROM azp_file WHERE azp01 = tm.plant3
           IF STATUS THEN
#             CALL cl_err('sel azp:',STATUS,0)   #No.FUN-660127
              CALL cl_err3("sel","azp_file",tm.plant3,"",STATUS,"","sel azp:",0)   #No.FUN-660127
              NEXT FIELD plant3
           END IF
         AFTER FIELD choice
           IF tm.choice NOT MATCHES '[12]' THEN
              NEXT FIELD choice
           END IF 
         #No.FUN-7C0101--start--
         AFTER FIELD type1
           IF tm.type1 IS NULL OR tm.type1 NOT MATCHES '[12345]' THEN
              NEXT FIELD type1
           END IF
         #No.FUN-7C0101---end---
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
 
          ON ACTION CONTROLP 
            CASE
                WHEN INFIELD(plant1)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_azp'
                     LET g_qryparam.default1 = tm.plant1
                     CALL cl_create_qry() RETURNING tm.plant1
                     DISPLAY BY NAME tm.plant1 NEXT FIELD plant1
                WHEN INFIELD(plant2)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_azp'
                     LET g_qryparam.default1 = tm.plant2
                     CALL cl_create_qry() RETURNING tm.plant2
                     DISPLAY BY NAME tm.plant2 NEXT FIELD plant2
                WHEN INFIELD(plant3)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_azp'
                     LET g_qryparam.default1 = tm.plant3
                     CALL cl_create_qry() RETURNING tm.plant3
                     DISPLAY BY NAME tm.plant3 NEXT FIELD plant3
#FUN-4B0064 add
                WHEN INFIELD(azk01) #幣別檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = tm.azk01
                     CALL cl_create_qry() RETURNING tm.azk01
                     DISPLAY BY NAME tm.azk01
                     NEXT FIELD azk01
                WHEN INFIELD(azk04)
                     CALL s_rate(tm.azk01,tm.azk04) RETURNING tm.azk04
                     DISPLAY BY NAME tm.azk04
                     NEXT FIELD azk04
##
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG CALL cl_cmdask()  
 
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
 
#FUN-4B0064
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(tm.azk01) THEN 
               LET tm.azk04 = 0
               DISPLAY BY NAME tm.azk04
            END IF  
##
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r141_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   #TQC-610051-begin
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr141'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr141','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.yy1_b  CLIPPED,"'",
                         " '",tm.mm1_b  CLIPPED,"'",
                         " '",tm.yy1_e  CLIPPED,"'",
                         " '",tm.mm1_e  CLIPPED,"'",
                         " '",tm.plant1 CLIPPED,"'",
                         " '",tm.yy2_b  CLIPPED,"'",
                         " '",tm.mm2_b  CLIPPED,"'",
                         " '",tm.yy2_e  CLIPPED,"'",
                         " '",tm.mm2_e  CLIPPED,"'",
                         " '",tm.plant2 CLIPPED,"'",
                         " '",tm.yy3_b  CLIPPED,"'",
                         " '",tm.mm3_b  CLIPPED,"'",
                         " '",tm.yy3_e  CLIPPED,"'",
                         " '",tm.mm3_e  CLIPPED,"'",
                         " '",tm.plant3 CLIPPED,"'",
                         " '",tm.type1 CLIPPED,"'",       #No.FUN-7C0101 add
                         " '",tm.avg_amt CLIPPED,"'",
                         " '",tm.range_amt CLIPPED,"'",
                         " '",tm.azk01  CLIPPED,"'",
                         " '",tm.azk04  CLIPPED,"'",
                         " '",g_rep_user  CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",   
                         " '",g_template  CLIPPED,"'",
                         " '",g_bookno  CLIPPED,"'"
         CALL cl_cmdat('axcr141',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr111_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   #TQC-610051-end
 
   CALL cl_wait()
#CHI-C30012---begin 
#      SELECT azi03,azi04,azi05
##       INTO g_azi03,g_azi04,g_azi05   #NO.CHI-6A0004
#        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=tm.azk01
    LET t_azi03 = g_ccz.ccz26
    LET t_azi04 = g_ccz.ccz26
    LET t_azi05 = g_ccz.ccz26
#CHI-C30012---end
   CALL r141()
   ERROR ""
END WHILE
   CLOSE WINDOW r141_w
END FUNCTION
 
FUNCTION r141()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql1    LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680122CHAR(1000)
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680122CHAR(700)
          l_ccc01   LIKE ccc_file.ccc01,
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)     
          l_a       LIKE type_file.num10,          #No.FUN-680122 integer
          l_chk     LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
          l_price   LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6),
          l_plant   LIKE azp_file.azp01,           #No.FUN-680122CHAR(10)
          i         LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_dbs,l_dbs_1,l_dbs_2,l_dbs_3 LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
          l_ym1_b,l_ym1_e,l_ym2_b,l_ym2_e,l_ym3_b,l_ym3_e LIKE type_file.num10,          #No.FUN-680122integer,
          l_ccc RECORD
            item  LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
            ym    LIKE type_file.num10,          #No.FUN-680122INTEGER
            ima02 LIKE ima_file.ima02,         #No.FUN-680122CHAR(30)
            f1    LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6)
            f2    LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6)
            cur   LIKE azk_file.azk01            #No.FUN-680122char(4) #幣別
         END RECORD,
         l_wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(200)
         sr  RECORD
              ccc01  LIKE ccc_file.ccc01,
              ima02  LIKE ima_file.ima02,
              type   LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
            #  qty    LIKE ima_file.ima26,           #No.FUN-680122dec(16,3)#FUN-A20044
              qty    LIKE type_file.num15_3,           #No.FUN-680122dec(16,3)#FUN-A20044
              amt    LIKE ima_file.ima32,           #No.FUN-680122dec(16,3)
              tlfcost LIKE tlf_file.tlfcost         #No.FUN-7C0101 VARCHAR(40)
         END RECORD
  DEFINE g   LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1) #MOD-630112
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL s_ymtodate(tm.yy1_b,tm.mm1_b,tm.yy1_e,tm.mm1_e)
     RETURNING g_bdate1,g_edate1
     CALL s_ymtodate(tm.yy2_b,tm.mm2_b,tm.yy2_e,tm.mm2_e)
     RETURNING g_bdate2,g_edate2
     CALL s_ymtodate(tm.yy3_b,tm.mm3_b,tm.yy3_e,tm.mm3_e)
     RETURNING g_bdate3,g_edate3

#FUN-A10098  ---start--- 
#    #抓取工廠所用之資料庫編號
#    SELECT azp03 INTO l_dbs_1 FROM azp_file WHERE azp01 = tm.plant1
#   #LET l_dbs_1 = l_dbs_1 CLIPPED,"."  #TQC-940184    
#    LET l_dbs_1 = s_dbstring(l_dbs_1 CLIPPED) #TQC-940184   
#    SELECT azp03 INTO l_dbs_2 FROM azp_file WHERE azp01 = tm.plant2
#   #LET l_dbs_2 = l_dbs_2 CLIPPED,"."  #TQC-940184    
#    LET l_dbs_2 = s_dbstring(l_dbs_2 CLIPPED) #TQC-940184   
#    SELECT azp03 INTO l_dbs_3 FROM azp_file WHERE azp01 = tm.plant3
#   #LET l_dbs_3 = l_dbs_3 CLIPPED,"."  #TQC-940184    
#    LET l_dbs_3 = s_dbstring(l_dbs_3 CLIPPED) #TQC-940184      
#FUN-A10098  ---end---
 
     LET l_wc =" AND ((tlf06 >= '",g_bdate1,"'  AND tlf06 <= '",g_edate1,"') ",
               " OR (tlf06 >= '",g_bdate2,"' AND tlf06 <= '",g_edate2,"' ) ",
               " OR (tlf06 >= '",g_bdate3,"' AND tlf06 <= '",g_edate3,"' )) "
          LET l_ym1_b=tm.yy1_b*12+tm.mm1_b
          LET l_ym1_e=tm.yy1_e*12+tm.mm1_e
          LET l_ym2_b=tm.yy2_b*12+tm.mm2_b
          LET l_ym2_e=tm.yy2_e*12+tm.mm2_e
          LET l_ym3_b=tm.yy3_b*12+tm.mm3_b
          LET l_ym3_e=tm.yy3_e*12+tm.mm3_e
 
  DELETE FROM r141_tmp
          
  FOR i = 1 TO 3
       #賦予要抓取的工廠編號
       CASE i 
        #FUN-A10098  ---start---
        # WHEN 1 LET l_dbs = l_dbs_1  LET l_plant = tm.plant1
        # WHEN 2 LET l_dbs = l_dbs_2  LET l_plant = tm.plant2
        # WHEN 3 LET l_dbs = l_dbs_3  LET l_plant = tm.plant3
          WHEN 1 LET l_plant = tm.plant1
          WHEN 2 LET l_plant = tm.plant2
          WHEN 3 LET l_plant = tm.plant3
        #FUN-A10098  ---end---
       END CASE
       LET g=i                 #MOD-630112
       IF tm.choice = '1' THEN #進料
          # 僅取採購入庫者 
          LET l_sql1 =
          "INSERT INTO r141_tmp",
         #MOD-630112-begin
         #" SELECT '",l_plant,"',tlf01,(YEAR(tlf06)*12+MONTH(tlf06)),ima02,",
          " SELECT '",g,"','",l_plant,"',tlf01,(YEAR(tlf06)*12+MONTH(tlf06)),ima02,",
         #MOD-630112-end
          "        tlf10*tlf907,tlfc21*tlf907,'',tlfccost ",     #No.FUN-7C0101 tlf21->tlfc21 add tlfccost
         #FUN-A10098 ----start---
         #" FROM ",l_dbs CLIPPED," tlf_file,ima_file,smy_file,OUTER tlfc_file ",   #No.FUN-7C0101 add tlfc_file
          " FROM ",cl_get_target_table(l_plant,'tlf_file'),",",
                   cl_get_target_table(l_plant,'ima_file'),",",
                   cl_get_target_table(l_plant,'smy_file'),",",
         " OUTER ",cl_get_target_table(l_plant,'tlfc_file'),
         #FUN-A10098  ---end---
          " WHERE ",g_wc CLIPPED,
          " AND tlf61 = smyslip ",
          " AND (tlf65 IS NOT NULL AND tlf65 != ' ') ",
          " AND smydmy2 = '1' ", #入
          " AND smydmy1 = 'Y' ", #成本亦要計算
          " AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
          " AND tlf01 = ima01",
          #No.TQC-A40130  --Begin
          #No.FUN-7C0101-add-start-
          " AND tlfc_file.tlfc01 = tlf01 AND tlfc_file.tlfc02 = tlf02 ",
          " AND tlfc_file.tlfc03 = tlf03 AND tlfc_file.tlfc06 = tlf06",           #No.FUN-830002
          " AND tlfc_file.tlfc13 = tlf13",                              #No.FUN-830002 
#         " AND tlfc026 = tlf026 AND tlfc027 = tlf027 ",      #No.FUN-830002
#         " AND tlfc036 = tlf036 AND tlfc037 = tlf037 ",      #No.FUN-830002 
          " AND tlfc_file.tlfc902 = tlf902 AND tlfc_file.tlfc903 = tlf903",       #No.FUN-830002                                               
          " AND tlfc_file.tlfc904 = tlf904 AND tlfc_file.tlfc905 = tlf905",       #No.FUN-830002 
          " AND tlfc_file.tlfc906 = tlf906 AND tlfc_file.tlfc907 = tlf907",
          " AND tlfc_file.tlfctype = '",tm.type1,"'"
          #No.FUN-7C0101-add--end--
          #No.TQC-A40130  --End  
       ELSE
          LET l_sql1 =
          "INSERT INTO r141_tmp",
         #MOD-630112-begin
         #" SELECT '",l_plant,"',ohb04,YEAR(oha02)*12+MONTH(oha02),ima02,",
         #-------------------No.MOD-950210 modify
         #" SELECT '",g,"','",l_plant,"',ohb04,YEAR(oha02)*12+MONTH(oha02),ima02,",
          " SELECT '",g,"','",l_plant,"',ogb04,YEAR(oga02)*12+MONTH(oga02),ima02,",
         #-------------------No.MOD-950210 end
         #MOD-630112-end
                 " ogb16,ogb14*oga24,oga23",             
        #FUN-A10098 ----start---
        # " FROM ",l_dbs CLIPPED," oga_file,ogb_file,ima_file",
          " FROM ",cl_get_target_table(l_plant,'oga_file'),",",
                   cl_get_target_table(l_plant,'ogb_file'),",",
                   cl_get_target_table(l_plant,'ima_file'),
        #FUN-A10098  ---end---
          " WHERE ",g_wc CLIPPED,
          " AND ogb04=ima01 AND oga01 = ogb01 AND oga09 IN ('2','3','8') ",  #No.FUN-610020  #No.TQC-A40130
          " AND oga65 ='N' ",  #No.FUN-610020
          " AND ogaconf = 'Y' AND ogapost = 'Y' "
        #," AND oga00 != '3'"   #FUN-5B0123   #No.MOD-950210 mark
         ," AND oga00 NOT IN ('A','3','7') "     #No.MOD-950210 add
       END IF
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
       CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1  #FUN-A10098
       PREPARE r141_preparex FROM l_sql1
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('preparex:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM 
       END IF
       EXECUTE r141_preparex
       IF tm.choice = '2' THEN #銷售
          LET l_sql1 =
          "INSERT INTO r141_tmp",
         #MOD-630112-begin
         #" SELECT '",l_plant,"',ohb04,YEAR(oha02)*12+MONTH(oha02),ima02,",
          " SELECT '",g,"','",l_plant,"',ohb04,YEAR(oha02)*12+MONTH(oha02),ima02,",
         #MOD-630112-end
                 " ohb16*-1,ohb14*oha24*-1,oha23,''",          #No.FUN-7C0101 add ''
        #FUN-A10098  ---start---
        # " FROM ",l_dbs CLIPPED," oha_file,ohb_file,ima_file",
          " FROM ",cl_get_target_table(l_plant,'oha_file'),",",
                   cl_get_target_table(l_plant,'ohb_file'),",",
                   cl_get_target_table(l_plant,'ima_file'),
        #FUN-A10098  ---end---  
          " WHERE ",g_wc CLIPPED,
          " AND ohb04=ima01 AND oha01 = ohb01 ",
          " AND ohaconf = 'Y' AND ohapost = 'Y' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
          CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1  #FUN-A10098
          PREPARE r141_preparey FROM l_sql1
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('preparey:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM 
          END IF
          EXECUTE r141_preparey
       END IF 
 
       IF NOT cl_null(tm.azk01) AND tm.azk04 != 0 THEN #進料
          UPDATE r141_tmp SET f2=f2/tm.azk04 #WHERE cur=tm.azk01
       END IF
 
  END FOR
 
       LET l_sql =
          " SELECT item,ima02,'1' c3,SUM(f1),SUM(f2)",
          " FROM r141_tmp ",
          " WHERE ym BETWEEN ", l_ym1_b," AND ",l_ym1_e,
          "   AND plant = '",tm.plant1,"'",
          "   AND dbs = '1' ",                          #MOD-C60010 add
          " GROUP BY item,ima02 "
          IF tm.mm2_e <>0 THEN LET l_sql=l_sql CLIPPED," UNION ",
          " SELECT item,ima02,'2' c3,SUM(f1),SUM(f2)",
          " FROM r141_tmp ",
          " WHERE ym BETWEEN ", l_ym2_b," AND ",l_ym2_e,
          "   AND plant = '",tm.plant2,"'",
          "   AND dbs = '2' ",                          #MOD-C60010 add
          " GROUP BY item,ima02 "
          END IF
          IF tm.mm3_e <>0 THEN LET l_sql=l_sql CLIPPED," UNION ",
          " SELECT item,ima02,'3' c3,SUM(f1),SUM(f2)",
          " FROM r141_tmp ",
          " WHERE ym BETWEEN ", l_ym3_b," AND ",l_ym3_e,
          "   AND plant = '",tm.plant3,"'",
          "   AND dbs = '3' ",                          #MOD-C60010 add
          " GROUP BY item,ima02 "
          END IF
          LET l_sql=l_sql CLIPPED," ORDER BY item,ima02,c3"
                 
	  PREPARE r141_prepare1 FROM l_sql
	  IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
             EXIT PROGRAM 
          END IF
          DECLARE r141_curs1 CURSOR FOR r141_prepare1
 
          CALL cl_outnam('axcr141') RETURNING l_name
          
          #No.FUN-7C0101--start--
         IF tm.type1 MATCHES '[12]' THEN
            LET g_zaa[34].zaa06='Y'
         END IF
         IF tm.type1 MATCHES '[345]' THEN
           LET g_zaa[34].zaa06='N'
         END IF
         #No.FUN-7C0101---end---          
          START REPORT r141_rep TO l_name
          LET g_pageno = 0
          LET l_ccc01=null
          FOREACH r141_curs1 INTO sr.*
               IF SQLCA.sqlcode != 0 THEN 
	          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
               END IF
               IF sr.type = '1' THEN 
                  LET l_price = 0 
                  IF sr.qty IS NULL OR sr.qty = 0 THEN LET l_price = 0 ELSE
                  LET l_price = sr.amt/sr.qty END IF 
                  IF l_price < tm.avg_amt THEN CONTINUE FOREACH END IF 
               END IF 
               OUTPUT TO REPORT r141_rep(sr.*)
          END FOREACH
          FINISH REPORT r141_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r141_rep(sr)
DEFINE l_last_sw  LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE l_title,l_dt STRING 
DEFINE l_ima021 LIKE ima_file.ima021
DEFINE diff_unit1,diff_unit2  LIKE type_file.num20_6        #No.FUN-680122DECIMAL(20,6)
DEFINE diff_unit1x,diff_unit2x  LIKE type_file.num20_6      #No.FUN-680122DECIMAL(20,6)
DEFINE l_amt LIKE  ccc_file.ccc22,
       l_stop LIKE type_file.chr1           #No.FUN-680122CHAR(1)
DEFINE i LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE l_row DYNAMIC ARRAY OF RECORD 
      #   qty LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
         qty LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
         amt LIKE type_file.num20_6        #No.FUN-680122 DEC(20,6)
       END RECORD 
DEFINE 
          sr  RECORD
              ccc01  LIKE ccc_file.ccc01,
              ima02  LIKE ima_file.ima02,
              type   LIKE type_file.chr1,           #No.FUN-680122char(1)
          #    qty    LIKE ima_file.ima26,           #No.FUN-680122dec(15,3)#FUN-A20044
              qty    LIKE type_file.num15_3,           #No.FUN-680122dec(15,3)#FUN-A20044
              amt    LIKE type_file.num20_6,        #No.FUN-680122 DEC(20,6)
              tlfcost LIKE tlf_file.tlfcost         #No.FUN-7C0101 VARCHAR(40)
              END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ccc01,sr.type 
  FORMAT
   PAGE HEADER
      IF tm.choice='1' THEN
         LET l_title=g_x[9] CLIPPED
      ELSE
         LET l_title=g_x[10] CLIPPED
      END IF
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(l_title))/2)+1,l_title
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = tm.azk01               #No.FUN-870151
     #PRINT g_x[11] CLIPPED,tm.azk01 clipped,'/',tm.azk04 using '<<&.&&'           #No.FUN-870151
      PRINT g_x[11] CLIPPED,tm.azk01 clipped,'/',cl_numfor(tm.azk04,4,t_azi07)     #No.FUN-870151      
      PRINT g_dash
      PRINT COLUMN r141_getStartPos(35,36,tm.plant1),
                   tm.plant1 CLIPPED,
            COLUMN r141_getStartPos(37,38,tm.plant2),
                   tm.plant2 CLIPPED,
            COLUMN r141_getStartPos(39,40,tm.plant3),
                   tm.plant3 CLIPPED
 
      LET l_dt=tm.yy1_b USING '&&&&','/',tm.mm1_b using '&&',' - ',
               tm.yy1_e USING '&&&&','/',tm.mm1_e using '&&'
      PRINT COLUMN r141_getStartPos(35,36,l_dt),l_dt CLIPPED;
 
      LET l_dt=tm.yy2_b USING '&&&&','/',tm.mm2_b using '&&',' - ',
               tm.yy2_e USING '&&&&','/',tm.mm2_e using '&&'
      PRINT COLUMN r141_getStartPos(37,38,l_dt),l_dt CLIPPED;
 
      LET l_dt=tm.yy3_b USING '&&&&','/',tm.mm3_b using '&&',' - ',
               tm.yy3_e USING '&&&&','/',tm.mm3_e using '&&'
      PRINT COLUMN r141_getStartPos(39,40,l_dt),l_dt CLIPPED
 
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42]                             #No.FUN-7C0101 add g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ccc01
      FOR i = 1 TO 3 LET l_row[i].qty =  0 LET l_row[i].amt =  0 END FOR 
 
   ON EVERY ROW
      IF sr.qty IS NULL OR sr.qty = 0 THEN LET sr.amt = 0 
      ELSE LET sr.amt = sr.amt / sr.qty END IF 
      CASE sr.type
          WHEN '1' LET l_row[1].qty = sr.qty LET l_row[1].amt = sr.amt
          WHEN '2' LET l_row[2].qty = sr.qty LET l_row[2].amt = sr.amt
          WHEN '3' LET l_row[3].qty = sr.qty LET l_row[3].amt = sr.amt
      END CASE 
 
   AFTER GROUP OF sr.ccc01
   IF l_row[1].amt != 0 OR l_row[1].qty != 0 THEN 
      LET diff_unit1=0
      LET diff_unit2=0
      LET diff_unit1=l_row[1].amt - l_row[2].amt
      LET diff_unit2=l_row[1].amt - l_row[3].amt
      IF diff_unit1 < 0 THEN LET diff_unit1x = diff_unit1 * -1 
      ELSE LET diff_unit1x = diff_unit1 END IF 
      IF diff_unit2 < 0 THEN LET diff_unit2x = diff_unit2 * -1 
      ELSE LET diff_unit2x = diff_unit2 END IF 
      IF NOT (diff_unit1x < tm.range_amt AND diff_unit2x < tm.range_amt) THEN 
       # FOR i=1 TO 3
       #     IF l_row[i].qty = 0 THEN LET l_row[i].qty = '' END IF 
       #     IF l_row[i].amt = 0 THEN LET l_row[i].amt = '' END IF 
       # END FOR
      SELECT ima021 INTO l_ima021 FROM ima_file 
          WHERE ima01=sr.ccc01
      IF SQLCA.sqlcode THEN 
          LET l_ima021 = NULL 
      END IF
 
      PRINT COLUMN g_c[31],sr.ccc01 CLIPPED,
             COLUMN g_c[32],sr.ima02 CLIPPED,  #MOD-4A0238
            COLUMN g_c[33],l_ima021 CLIPPED,  
            COLUMN g_c[34],sr.tlfcost CLIPPED, #No.FUN-7C0101
            COLUMN g_c[35],cl_numfor(l_row[1].qty,35,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[35],cl_numfor(l_row[1].amt,35,g_azi03),   #NO.CHI-6A0004
            COLUMN g_c[36],cl_numfor(l_row[1].amt,36,t_azi03),   #NO.CHI-6A0004
            COLUMN g_c[37],cl_numfor(l_row[2].qty,37,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[37],cl_numfor(l_row[2].amt,37,g_azi03),   #NO.CHI-6A0004
            COLUMN g_c[38],cl_numfor(l_row[2].amt,38,t_azi03),   #NO.CHI-6A0004
            COLUMN g_c[39],cl_numfor(l_row[3].qty,38,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#           COLUMN g_c[39],cl_numfor(l_row[3].amt,39,g_azi03),   #NO.CHI-6A0004
            COLUMN g_c[40],cl_numfor(l_row[3].amt,40,t_azi03),   #NO.CHI-6A0004
#           COLUMN g_c[40],cl_numfor(diff_unit1,40,g_azi03),     #NO.CHI-6A0004
            COLUMN g_c[41],cl_numfor(diff_unit1,41,t_azi03),     #NO.CHI-6A0004
#           COLUMN g_c[41],cl_numfor(diff_unit2,41,g_azi03)      #NO.CHI-6A0004
            COLUMN g_c[42],cl_numfor(diff_unit2,42,t_azi03)      #NO.CHI-6A0004
      END IF
      END IF
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[41], g_x[7] CLIPPED
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[41], g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT 
 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r141_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
  #MOD-B30038---modify---start---
  #LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   IF g_zaa[34].zaa06 = 'Y' THEN
      LET l_pos=l_pos+g_c[l_sta]- g_zaa[34].zaa05
   ELSE
      LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   END IF
  #MOD-B30038---modify---end---
   RETURN l_pos
END FUNCTION
 

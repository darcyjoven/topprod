# Prog. Version..: '5.30.06-13.03.12(00005)'     #
# Pattern name...: abmq621.4gl
# Descriptions...: 多階材料用量成本查詢
# Input parameter:
# Return code....:
# Date & Author..: 91/08/17 By Wu
#      Modify    : 92/05/11 By David
 # Modify.........: #No:MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4A0004 04/10/04 By Yuna 料件編號開窗
# Modify.........: No.FUN-510033 05/02/22 By Mandy 報表轉XML
# Modify.........: No:FUN-550093 05/06/03 By kim 配方BOM,特性代碼
# Modify.........: No:FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No:TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No:TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No:FUN-610092 06/05/24 By Joe 增加報表發料單位欄位
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No:FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No:CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No:TQC-6A0081 06/11/13 By baogui 報表問題修改
# Modify.........: No:TQC-6C0034 06/12/14 By Joe 將單位改為BOM單位 

DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD				# Print condition RECORD
		        wc  	  LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(500)
           		class	  LIKE type_file.chr4,     #No.FUN-680096 VARCHAR(4)
   	        	revision  LIKE type_file.chr2,     #No.FUN-680096 VARCHAR(2)
           		effective LIKE type_file.dat,      #No.FUN-680096 DATE
           		arrange   LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
           		cost      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
   	        	pur       LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
           		more	  LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_bma01_a     LIKE bma_file.bma01,    #產品結構單頭
          g_mcst        LIKE imb_file.imb111,    #材料成本
          g_imcstc      LIKE imb_file.imb121,    #下階間接材料成本
          g_labcstc     LIKE imb_file.imb121,    #下階直接人工成本
          g_fixo        LIKE imb_file.imb121,    #下階固定製費
          g_varo        LIKE imb_file.imb121,    #下階變動製費
          g_outc        LIKE imb_file.imb121,    #下階廠外加工成本
          g_outo        LIKE imb_file.imb121,    #下階廠外加工費用
          g_str1,g_str2 LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(12)
          m_total       LIKE pml_file.pml09,     #No.FUN-680096 DEC(16,8)
          g_tot         LIKE type_file.num10     #No.FUN-680096 INTEGER

DEFINE   g_cnt          LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose        #No.FUN-680096 SMALLINT

MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.class  = ARG_VAL(8)
   LET tm.revision  = ARG_VAL(9)
   LET tm.effective  = ARG_VAL(10)
   LET tm.arrange  = ARG_VAL(11)
   LET tm.cost  = ARG_VAL(12)
   LET tm.pur   = ARG_VAL(13)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No:FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL abmq621_tm(0,0)			# Input print condition
      ELSE CALL abmq621()			# Read bmata and create out-file
   END IF
END MAIN

FUNCTION abmq621_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
            l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
            l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bma01       LIKE bma_file.bma01,
            l_cmd	  LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)


   LET p_row = 4
   LET p_col = 8

   OPEN WINDOW abmq621_w AT p_row,p_col WITH FORM "abm/42f/abmq621"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    #FUN-560021................begin
    CALL cl_set_comp_visible("acode",g_sma.sma118='Y')
    #FUN-560021................end

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.arrange ='1'  #按元件料件編號遞增順序排列
   LET tm.cost ='1'   #現時成本
   LET tm.pur  ='1'   #採購成本
   LET tm.effective = g_today	#有效日期
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'

   WHILE TRUE
      LET m_total=0
      CONSTRUCT tm.wc ON bma01,ima06,bma06 FROM item,class,acode #FUN-550093

              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
 
         #--No.FUN-4A0004--------
         ON ACTION CONTROLP
           CASE WHEN INFIELD(item) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_ima3"
         	  CALL cl_create_qry() RETURNING g_qryparam.multiret
         	  DISPLAY g_qryparam.multiret TO item
         	  NEXT FIELD item
            OTHERWISE EXIT CASE
            END CASE
         #--END---------------
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW abmq621_w
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 FROM bma_file,ima_file",
             " WHERE bma01=ima01 AND ",tm.wc CLIPPED," GROUP BY bma01"
         PREPARE abmq621_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('P0:',SQLCA.sqlcode,1) EXIT PROGRAM
         END IF
         DECLARE abmq621_cnt
         CURSOR FOR abmq621_precnt
         OPEN abmq621_cnt
         FETCH abmq621_cnt INTO g_cnt,l_bma01
         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
         ELSE
            #LET g_cnt=sqlca.sqlerrd[3]
            IF g_cnt=1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF

      INPUT BY NAME tm.revision,tm.effective,tm.arrange,tm.cost,tm.pur,tm.more WITHOUT DEFAULTS

         BEFORE FIELD revision
            IF l_one='N' THEN
               NEXT FIELD effective
            END IF

         AFTER FIELD revision
            IF tm.revision IS NOT NULL THEN
               CALL s_version(l_bma01,tm.revision)
               RETURNING l_bdate,l_edate,l_flag
               LET tm.effective = l_bdate
               DISPLAY BY NAME tm.effective
            END IF

         AFTER FIELD arrange
            IF tm.arrange NOT MATCHES '[12]' THEN
               NEXT FIELD arrange
            END IF

         AFTER FIELD cost
            IF tm.cost NOT MATCHES '[1-3]' THEN
               NEXT FIELD cost
            END IF

         AFTER FIELD pur
            IF tm.pur  NOT MATCHES '[1-3]' THEN
               NEXT FIELD pur
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
            CALL cl_cmdask()	# Command execution

         ON ACTION CONTROLP
            CALL abmq621_wc()   # Input detail Where Condition
            IF INT_FLAG THEN
               EXIT INPUT
            END IF


         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW abmq621_w
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmq621'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmq621','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.class CLIPPED,"'",
                            " '",tm.revision CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.arrange CLIPPED,"'",
                            " '",tm.cost CLIPPED,"'",
                            " '",tm.pur CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
            CALL cl_cmdat('abmq621',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW abmq621_w
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abmq621()
      ERROR ""
   END WHILE
   CLOSE WINDOW abmq621_w
END FUNCTION

FUNCTION abmq621_wc()
   DEFINE l_wc    LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(500)
   OPEN WINDOW abmq621_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

    CALL cl_ui_locale("abmi600")

   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
        FROM
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
        s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb08,s_bmb[1].bmb10
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
   END CONSTRUCT
   CLOSE WINDOW abmq621_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION

#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# abmq621()      從單頭讀取合乎條件的主件資料
# abmq621_bom()  處理元件及其相關的展開資料
FUNCTION abmq621()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_use_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_ute_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40) 
          l_labcst      LIKE imb_file.imb111,   #人工成本
          l_bma01 LIKE bma_file.bma01,          #主件料件
          l_bma06 LIKE bma_file.bma06           #FUN-550093

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同部門的資料
         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     END IF

     LET l_sql = "SELECT bma01,bma06", #FUN-550093
                 " FROM bma_file, ima_file",
                 " WHERE ima01 = bma01",
                 " AND ",tm.wc
     PREPARE abmq621_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
		 CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM END IF
     DECLARE abmq621_curs1 CURSOR FOR abmq621_prepare1

     CALL cl_outnam('abmq621') RETURNING l_name
     START REPORT abmq621_rep TO l_name
#No.CHI-6A0004------Begin-----
#       SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#                      FROM azi_file WHERE azi01 =g_aza.aza17
#No.CHI-6A0004-----End------ 
     CASE tm.cost
       WHEN '1' LET g_str1 = g_x[57]
       WHEN '2' LET g_str1 = g_x[58]
       WHEN '3' LET g_str1 = g_x[59]
      END CASE
      CASE tm.pur
       WHEN '1' LET g_str2 = g_x[60]
       WHEN '2' LET g_str2 = g_x[61]
       WHEN '3' LET g_str2 = g_x[62]
      END CASE
# genero  script marked      LET g_pageno = 0
   	 LET g_tot=0
     FOREACH abmq621_curs1 INTO l_bma01,l_bma06 #FUN-550093
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01_a=l_bma01
       LET g_imcstc=0   #間接材料成本
       LET g_labcstc=0  #下階直接人工成本
       LET g_fixo=0     #下階固定製造費用
       LET g_varo=0     #下階變動製造費用
       LET g_outc=0     #下階廠外加工成本
       LET g_outo=0     #下階廠外加工費用
       CALL abmq621_bom(0,l_bma01,1,l_bma06) RETURNING g_mcst #FUN-550093
       #當下階的所有成本資料均列印後, 最後要列印主件的標準成本及
       #計算後成本資料, 表示方式, 以32700為其階層(level)
       OUTPUT TO REPORT abmq621_rep(32700,0,0,l_bma01,'',0,'','',0,0,0,0, #NO:FUN-610092
      #OUTPUT TO REPORT abmq621_rep(32700,0,0,l_bma01,'',0,'',0,0,0,0,    #NO:FUN-610092
      #OUTPUT TO REPORT abmq621_rep(32700,0,0,l_bma01,'',0,0,0,0,
            0,0,0,0,0,0,0,0,l_bma06) #FUN-550093
     END FOREACH

    #DISPLAY "" AT 2,1
     FINISH REPORT abmq621_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
END FUNCTION

FUNCTION abmq621_bom(p_level,p_key,p_total,p_acode) #FUN-550093
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total       LIKE bmb_file.bmb06,    #No.FUN-680096 DEC(16,8)
          l_total       LIKE bmb_file.bmb06,    #No.FUN-680096 DEC(16,8)
          p_acode       LIKE bma_file.bma06,    #FUN-550093
          p_key		LIKE bma_file.bma01,    #主件料件編號
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb03       LIKE bmb_file.bmb03,    #元件料號
              bmb02       LIKE bmb_file.bmb02,    #項次
              bmb06       LIKE bmb_file.bmb06,    #QPA
              bmb10       LIKE bmb_file.bmb10,    #發料單位    ## No:FUN-610092 #NO.TQC-6C0034
              bmb10_fac   LIKE bmb_file.bmb10_fac,    #發料單位
              bma01       LIKE bma_file.bma01,    #No:MOD-490217
              ima02       LIKE ima_file.ima02,    #品名規格
              ima021      LIKE ima_file.ima021,   #FUN-510033
              ima08       LIKE ima_file.ima08,    #來源
              mcsts       LIKE imb_file.imb111,   #直接材料成本
              cstmbfs     LIKE imb_file.imb112,   #間接材料
              labcsts     LIKE imb_file.imb1131,  #直接人工成本
              cstsabs     LIKE imb_file.imb114,   #固定製造費用
              cstao2s     LIKE imb_file.imb115,   #變動製造費用
              outlabs     LIKE imb_file.imb116,   #廠外加工成本
              outmbfs     LIKE imb_file.imb1171,  #廠外加工製造費用成本
              purcost     LIKE imb_file.imb118    #本階採購成本
          END RECORD,
          l_material    LIKE imb_file.imb111,     #材料成本
          l_material_t  LIKE imb_file.imb111,     #材料成本
          l_unit        LIKE bmb_file.bmb10,
          l_unit_fac    LIKE bmb_file.bmb10_fac,
          l_ima44_fac   LIKE ima_file.ima44_fac,
          l_cmd		LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
          g_sw          LIKE type_file.num5       #No.FUN-680096 SMALLINT

    LET p_level = p_level + 1
    IF p_level > 25 THEN
        CALL cl_err(p_level,'mfg2733',2)
        EXIT PROGRAM
    END IF
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
        OUTPUT TO REPORT abmq621_rep(1,0,1,sr[1].*,p_acode)	#第0階主件資料 #FUN-550093
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb03,bmb02,bmb06/bmb07,bmb10,bmb10_fac,bma01,ima02,ima021,ima08,"        #FUN-610092
         ## "SELECT bmb03,bmb02,bmb06/bmb07,bmb10_fac,bma01,ima02,ima021,ima08," #FUN-510033  #FUN-610092
        #皆以本階為主
        CASE tm.cost
           WHEN '1'
            LET l_cmd=l_cmd CLIPPED,
                "(imb211*bmb10_fac2),(imb212*bmb10_fac2),",
                "(imb2131+imb2132)*bmb10_fac2,",
                "(imb214+imb219)*bmb10_fac2,imb215*bmb10_fac2,",
                "imb216*bmb10_fac2,",
                "(imb2151+imb2171+imb2172)*bmb10_fac2,imb218*bmb10_fac2" 
           WHEN '2'
            LET l_cmd=l_cmd CLIPPED,
                "imb311*bmb10_fac2,imb312*bmb10_fac2,",
                "(imb3131+imb3132)*bmb10_fac2,",
                "(imb314+imb319)*bmb10_fac2,imb315*bmb10_fac2,",
                "imb316*bmb10_fac2,",
                "(imb3151+imb3171+imb2172)*bmb10_fac2,imb318*bmb10_fac2"
           WHEN '3'
            LET l_cmd=l_cmd CLIPPED,
                "imb111*bmb10_fac2,imb112*bmb10_fac2,",
                "(imb1131+imb1132)*bmb10_fac2,",
                "(imb114+imb119)*bmb10_fac2,imb115*bmb10_fac2,",
                "imb116*bmb10_fac2,",
                "(imb1151+imb1171+imb1172)*bmb10_fac2,imb118*bmb10_fac2"
        END CASE
        LET l_cmd=l_cmd CLIPPED,
            " FROM bmb_file,OUTER imb_file, OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
            " AND imb_file.imb01 = bmb03",
            " AND bmb03 = ima_file.ima01",
            " AND bmb03 = bma_file.bma01",
            " AND ima_file.ima08 != 'A' ",
            " AND bmb29 = '",p_acode,"'" #FUN-550093

        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
            "' OR bmb05 IS NULL)"
        END IF
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY"
        IF tm.arrange='1' THEN
            LET l_cmd=l_cmd CLIPPED," bmb03"
        ELSE
            LET l_cmd=l_cmd CLIPPED," bmb02"
        END IF
        #組完之後的句子, 將之準備成可以用的查詢命令
        PREPARE abmq621_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
			 CALL cl_err('P1:',SQLCA.sqlcode,1) EXIT PROGRAM
        END IF
        DECLARE abmq621_cur CURSOR FOR abmq621_ppp

        LET l_material_t=0
        LET l_ac = 1
        FOREACH abmq621_cur INTO sr[l_ac].*
            IF sr[l_ac].ima08 MATCHES '[PVZ]' THEN #採購件, 使用採購成本
               CASE tm.pur
                    WHEN '1'    #材料成本
                      LET sr[l_ac].mcsts=sr[l_ac].purcost
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                    WHEN '2'    #最近單價
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                    # SELECT ima53 INTO sr[l_ac].mcsts
                      SELECT ima53,ima44,ima44_fac
                        INTO sr[l_ac].mcsts,l_unit,l_ima44_fac
                        FROM ima_file WHERE ima01=sr[l_ac].bmb03
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                   ##當發料單位與採購單位不同，直接由ima44_fac 與 bmb10_fac換算
                     #CALL s_umfchk(sr[l_ac].bmb03,l_unit,sr[l_ac].bmb10)
                     #     RETURNING g_sw,l_unit_fac
                     #IF g_sw THEN LET l_unit_fac = 1 END IF
                      LET l_unit_fac = sr[l_ac].bmb10_fac / l_ima44_fac
                      LET sr[l_ac].mcsts = sr[l_ac].mcsts * l_unit_fac
 
                    WHEN '3'
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                      SELECT ima531,ima44,ima44_fac
                        INTO sr[l_ac].mcsts,l_unit,l_ima44_fac
                        FROM ima_file WHERE ima01=sr[l_ac].bmb03
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                   ##當發料單位與採購單位不同，直接由ima44_fac 與 bmb10_fac換算
                     #CALL s_umfchk(sr[l_ac].bmb03,l_unit,sr[l_ac].bmb10)
                     #     RETURNING g_sw,l_unit_fac
                     #IF g_sw THEN LET l_unit_fac = 1 END IF
                      LET l_unit_fac = sr[l_ac].bmb10_fac / l_ima44_fac
                      LET sr[l_ac].mcsts = sr[l_ac].mcsts * l_unit_fac
               END CASE
            END IF
            IF sr[l_ac].mcsts   IS NULL THEN LET sr[l_ac].mcsts=0   END IF
            IF sr[l_ac].cstmbfs IS NULL THEN LET sr[l_ac].cstmbfs=0 END IF
            IF sr[l_ac].labcsts IS NULL THEN LET sr[l_ac].labcsts=0 END IF
            IF sr[l_ac].cstsabs IS NULL THEN LET sr[l_ac].cstsabs=0 END IF
            IF sr[l_ac].cstao2s IS NULL THEN LET sr[l_ac].cstao2s=0 END IF
            IF sr[l_ac].outlabs IS NULL THEN LET sr[l_ac].outlabs=0 END IF
            IF sr[l_ac].outmbfs IS NULL THEN LET sr[l_ac].outmbfs=0 END IF
            LET l_ac = l_ac + 1
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH

        FOR i = 1 TO l_ac-1
            LET l_total=p_total*sr[i].bmb06               #元件之終階QPA
            LET sr[i].labcsts=sr[i].labcsts*l_total       #元件之本階直人成本
            LET sr[i].cstsabs=sr[i].cstsabs*l_total       #元件之本階固定製費
            LET sr[i].cstao2s=sr[i].cstao2s*l_total       #元件之本階變動製費
            LET sr[i].outlabs=sr[i].outlabs*l_total       #元件之本階加工成本
            LET sr[i].outmbfs=sr[i].outmbfs*l_total       #本階託外費用
            LET g_fixo=g_fixo+sr[i].cstsabs               #主件之下階固定成本
            LET g_varo=g_varo+sr[i].cstao2s               #主件之下階變動成本
            LET g_labcstc=g_labcstc+sr[i].labcsts         #主件之下階直人成本
            LET g_outc=g_outc+sr[i].outlabs               #主件之下階加工成本
            LET g_outo=g_outo+sr[i].outmbfs               #主件之下階加工費用
            #材料成本之算法和其他的幾個成本的計算方式不同
            IF sr[i].bma01 IS NOT NULL AND sr[i].ima08 NOT MATCHES '[PVZ]' THEN
           #IF sr[i].bma01 IS NOT NULL THEN
                CALL abmq621_bom(p_level,sr[i].bmb03,l_total,' ') #FUN-550093
                     RETURNING l_material

                #由下階所得之本階材料成本
                LET l_material_t=l_material_t+l_material

                #由下階累計之本階間接成本
                LET g_imcstc=g_imcstc+(sr[i].cstmbfs*l_total)

                #本階材料成本
                LET sr[i].mcsts=l_material+(sr[i].cstmbfs*l_total)
            ELSE #無下階之元件
                #由下階累計之下階間接成本
                LET g_imcstc=g_imcstc+(sr[i].cstmbfs*l_total)

                #由下階所得之本階材料成本
                LET l_material_t=l_material_t+(sr[i].mcsts * l_total)

                #本階材料成本
                LET sr[i].mcsts=sr[i].mcsts+(sr[i].cstmbfs * l_total)
            END IF
            OUTPUT TO REPORT abmq621_rep(p_level,i,l_total, sr[i].*,p_acode) #FUN-550093
          # IF sr[l_ac].ima08 MATCHES '[PVZ]' THEN
          #    EXIT FOR
          # END IF
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
    RETURN l_material_t
END FUNCTION

REPORT abmq621_rep(p_level,p_i,p_total,sr,p_acode) #FUN-550093
   DEFINE l_last_sw	LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
          p_level,p_i,ptcode	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total       LIKE bmb_file.bmb06,      #No.FUN-680096 DEC(16,8)
          l_total       LIKE bmb_file.bmb06,      #No.FUN-680096 DEC(16,8)
          p_acode       LIKE bma_file.bma06,      #FUN-550093
          sr  RECORD
              bmb03       LIKE bmb_file.bmb03,    #元件料號
              bmb02       LIKE bmb_file.bmb02,    #項次
              bmb06       LIKE bmb_file.bmb06,    #QPA
              bmb10       LIKE bmb_file.bmb10,    #發料單位  ## No:FUN-610092
              bmb10_fac   LIKE bmb_file.bmb10_fac,#發料單位
              bma01       LIKE bma_file.bma01,    #No:MOD-490217
              ima02       LIKE ima_file.ima02,    #品名規格
              ima021      LIKE ima_file.ima021,   #FUN-510033
              ima08       LIKE ima_file.ima08,    #來源
              mcsts       LIKE imb_file.imb111,  #直接材料成本
              cstmbfs     LIKE imb_file.imb112,  #間接材料分攤比率
              labcsts     LIKE imb_file.imb1131, #直接人工成本
              cstsabs     LIKE imb_file.imb114,  #固定製造費用
              cstao2s     LIKE imb_file.imb115,  #變動製造費用
              outlabs     LIKE imb_file.imb116,  #廠外加工成本
              outmbfs     LIKE imb_file.imb1171,  #廠外加工費用
              purcost     LIKE imb_file.imb118   #本階採購成本
          END RECORD,
          l_ima02   LIKE ima_file.ima02,    #品名規格
          l_ima021  LIKE ima_file.ima021,   #FUN-5100033
          l_ima05   LIKE ima_file.ima05,    #版本
          l_ima06   LIKE ima_file.ima06,    #分群碼
          l_ima08   LIKE ima_file.ima08,    #來源
          l_imb211  LIKE imb_file.imb211,
          l_imb212  LIKE imb_file.imb212,
          l_imb2131 LIKE imb_file.imb2131,
          l_imb2132 LIKE imb_file.imb2132,
          l_imb214  LIKE imb_file.imb214,
          l_imb219  LIKE imb_file.imb219,
          l_imb220  LIKE imb_file.imb220,
          l_imb215  LIKE imb_file.imb215,
          l_imb216  LIKE imb_file.imb216,
          l_imb2151 LIKE imb_file.imb2151,  
          l_imb2171 LIKE imb_file.imb2171,
          l_imb2172 LIKE imb_file.imb2172,
          l_imb221  LIKE imb_file.imb221,
          l_imb222  LIKE imb_file.imb222,
          l_imb2231 LIKE imb_file.imb2231,
          l_imb2232 LIKE imb_file.imb2232,
          l_imb224  LIKE imb_file.imb224,
          l_imb229  LIKE imb_file.imb229,
          l_imb225  LIKE imb_file.imb225,
          l_imb226  LIKE imb_file.imb226,
          l_imb2251 LIKE imb_file.imb2251,
          l_imb2271 LIKE imb_file.imb2271,
          l_imb2272 LIKE imb_file.imb2272,
          l_imb230  LIKE imb_file.imb230,
          l_ver     LIKE ima_file.ima05,
          l_str2       LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(10)
          l_now,l_k    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_print81    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(100)

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver

      SELECT ima02,ima021,ima05,ima06,ima08
          INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08
          FROM ima_file
          WHERE ima01=g_bma01_a
      IF SQLCA.sqlcode THEN
          LET l_ima02=''
          LET l_ima021=''
          LET l_ima05=''
          LET l_ima06=''
          LET l_ima08=''
      END IF

      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[67] clipped,g_str1
      PRINT g_x[68] clipped,g_str2
      PRINT g_dash
      PRINT COLUMN 01,g_x[10] CLIPPED,tm.effective,
            COLUMN 20,g_x[69] CLIPPED,l_ver

#--------No:TQC-5B0107 modify   #&051112
      #----
      PRINT g_x[11] CLIPPED, g_bma01_a CLIPPED,
            COLUMN 55,g_x[12] CLIPPED, l_ima05,   #No:TQC-5B0030 MODIFY
            COLUMN 66,g_x[13] CLIPPED, l_ima08,
            COLUMN 73,g_x[14] CLIPPED, l_ima06,
            COLUMN 83,g_x[17] CLIPPED, p_acode #FUN-550093
      PRINT g_x[15] CLIPPED,  l_ima02 CLIPPED
      PRINT g_x[16] CLIPPED,  l_ima021 CLIPPED
#--------No:TQC-5B0107 end
      PRINT ' '
      #----
    ##  No:FUN-610092........................................................
    ##PRINTX name=H1 g_x[81],g_x[82],g_x[83],g_x[84],g_x[85],g_x[86],g_x[87]
    ##PRINTX name=H2 g_x[88],g_x[89],g_x[90],g_x[91]
      PRINTX name=H1 g_x[81],g_x[82],g_x[92],g_x[83],g_x[84],g_x[85],g_x[86],g_x[87]
      PRINTX name=H2 g_x[88],g_x[89],g_x[93],g_x[90],g_x[91]
    ##  No:FUN-610092........................................................
      PRINT g_dash1
      LET l_last_sw = 'n'

    ON EVERY ROW
      IF p_level=32700 THEN  #處理主件的累計資料
          SKIP 1 LINES
          CASE tm.cost
          WHEN '1'        #現時成本
              SELECT imb211, imb212, imb2131,imb2132,
                     imb214, imb219, imb220, imb215,
		     imb216, imb2171,imb2172,imb221,
                     imb222, imb2231,imb2232,imb224,
                     imb229, imb225, imb226, imb2271,
                     imb2272,imb230, imb2151,imb2251  
                INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
                     l_imb214, l_imb219,  l_imb220,  l_imb215,
                     l_imb216, l_imb2171, l_imb2172, l_imb221,
                     l_imb222, l_imb2231, l_imb2232, l_imb224,
                     l_imb229, l_imb225,  l_imb226,  l_imb2271,
                     l_imb2272,l_imb230,  l_imb2151, l_imb2251    
                FROM imb_file
                WHERE imb01=sr.bmb03
          WHEN '2'        #目標成本
              SELECT imb311, imb312, imb3131, imb3132,
                     imb314, imb319, imb320,  imb315,
                     imb316, imb3171,imb3172, imb321,
                     imb322, imb3231,imb3232, imb324,
                     imb329, imb325, imb326,  imb3271,
                     imb3272,imb330, imb3151, imb3251     
                INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
                     l_imb214, l_imb219,  l_imb220,  l_imb215,
                     l_imb216, l_imb2171, l_imb2172, l_imb221,
                     l_imb222, l_imb2231, l_imb2232, l_imb224,
                     l_imb229, l_imb225,  l_imb226,  l_imb2271,
                     l_imb2272,l_imb230,  l_imb2151, l_imb2251   
                FROM imb_file
                WHERE imb01=sr.bmb03
          WHEN '3'       #標準成本
              SELECT imb111, imb112, imb1131,imb1132,
                     imb114, imb119, imb120, imb115,
	             imb116, imb1171,imb1172,imb121,
                     imb122, imb1231,imb1232,imb124,
                     imb129, imb125, imb126, imb1271,
                     imb1272,imb130, imb1151,imb2151   
                INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
                     l_imb214, l_imb219,  l_imb220,  l_imb215,
                     l_imb216, l_imb2171, l_imb2172, l_imb221,
                     l_imb222, l_imb2231, l_imb2232, l_imb224,
                     l_imb229, l_imb225,  l_imb226,  l_imb2271,
                     l_imb2272,l_imb230,  l_imb2151, l_imb2251  
                FROM imb_file
                WHERE imb01=sr.bmb03
          END CASE
          IF l_imb211 IS NULL THEN LET l_imb211=0 END IF
          IF l_imb212 IS NULL THEN LET l_imb212=0 END IF
          IF l_imb2131 IS NULL THEN LET l_imb2131=0 END IF
          IF l_imb2132 IS NULL THEN LET l_imb2132=0 END IF
          IF l_imb214 IS NULL THEN LET l_imb214=0 END IF
          IF l_imb219 IS NULL THEN LET l_imb219=0 END IF
          IF l_imb220 IS NULL THEN LET l_imb220=0 END IF
          IF l_imb215 IS NULL THEN LET l_imb215=0 END IF
          IF l_imb2151 IS NULL THEN LET l_imb2151=0 END IF  
          IF l_imb216 IS NULL THEN LET l_imb216=0 END IF
          IF l_imb2171 IS NULL THEN LET l_imb2171=0 END IF
          IF l_imb2172 IS NULL THEN LET l_imb2172=0 END IF
          IF l_imb221 IS NULL THEN LET l_imb221=0 END IF
          IF l_imb222 IS NULL THEN LET l_imb222=0 END IF
          IF l_imb2231 IS NULL THEN LET l_imb2231=0 END IF
          IF l_imb2232 IS NULL THEN LET l_imb2232=0 END IF
          IF l_imb224 IS NULL THEN LET l_imb224=0 END IF
          IF l_imb229 IS NULL THEN LET l_imb229=0 END IF
          IF l_imb225 IS NULL THEN LET l_imb225=0 END IF
          IF l_imb2251 IS NULL THEN LET l_imb2251=0 END IF
          IF l_imb226 IS NULL THEN LET l_imb226=0 END IF
          IF l_imb2271 IS NULL THEN LET l_imb2271=0 END IF
          IF l_imb2272 IS NULL THEN LET l_imb2272=0 END IF
          IF l_imb230 IS NULL THEN LET l_imb230=0 END IF

          PRINT COLUMN 60-FGL_WIDTH(g_x[31]),
                g_x[31] CLIPPED,cl_numfor(l_imb211, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[32]),
                g_x[32] CLIPPED,cl_numfor(l_imb212, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[33]),
                g_x[33] CLIPPED,cl_numfor(l_imb2131,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[65]),
                g_x[65] CLIPPED,cl_numfor(l_imb2132,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[34]),
                g_x[34] CLIPPED,cl_numfor(l_imb219, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[35]),
                g_x[35] CLIPPED,cl_numfor(l_imb214, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[36]),
                g_x[36] CLIPPED,cl_numfor(l_imb215, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[70]),  
                g_x[70] CLIPPED,cl_numfor(l_imb2151, 16,g_azi03)  
          PRINT COLUMN 60-FGL_WIDTH(g_x[37]),
                g_x[37] CLIPPED,cl_numfor(l_imb216, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[38]),
                g_x[38] CLIPPED,cl_numfor(l_imb2171,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[39]),
                g_x[39] CLIPPED,cl_numfor(l_imb2172,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[66]),
                g_x[66] CLIPPED,cl_numfor(l_imb220 ,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[40]),
                g_x[40] CLIPPED,cl_numfor(l_imb221 ,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[41]),
                g_x[41] CLIPPED,cl_numfor(l_imb222, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[42]),
                g_x[42] CLIPPED,cl_numfor(l_imb2231,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[65]),
                g_x[65] CLIPPED,cl_numfor(l_imb2232,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[43]),
                g_x[43] CLIPPED,cl_numfor(l_imb229, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[44]),
                g_x[44] CLIPPED,cl_numfor(l_imb224, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[45]),
                g_x[45] CLIPPED,cl_numfor(l_imb225, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[71]),
                g_x[71] CLIPPED,cl_numfor(l_imb2251, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[46]),
                g_x[46] CLIPPED,cl_numfor(l_imb226, 16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[47]),
                g_x[47] CLIPPED,cl_numfor(l_imb2271,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[48]),
                g_x[48] CLIPPED,cl_numfor(l_imb2272,16,g_azi03)
          PRINT COLUMN 60-FGL_WIDTH(g_x[66]),
                g_x[66] CLIPPED,cl_numfor(l_imb230, 16,g_azi03)
          PRINT COLUMN 60, '-----------------'
          #(標準/現時/預設)成本
          LET l_total= l_imb211+  l_imb212 + l_imb2131 + l_imb2132 +
                       l_imb214+  l_imb219 + l_imb220  + l_imb215  +
                       l_imb216+  l_imb2171+ l_imb2172 + l_imb221  +
                       l_imb222+  l_imb2231+ l_imb2232 + l_imb224  +
                       l_imb229+  l_imb225 + l_imb226  + l_imb2271 +
                       l_imb2272+ l_imb230 + l_imb2151 + l_imb2251    
         CASE tm.cost
			WHEN '1'
			   LET ptcode=49
			WHEN '2'
			   LET ptcode=55
			WHEN '3'
			   LET ptcode=56
          END CASE
          PRINT COLUMN 60-FGL_WIDTH(g_x[ptcode]),
#               g_x[ptcode] CLIPPED,cl_numfor(l_total,16,g_azi05)                 #TQC-6A0081
                g_x[ptcode] CLIPPED,cl_numfor(l_total,16,g_azi03)                 #TQC-6A0081
         CASE tm.cost
			WHEN '1'
			   LET ptcode=50
			WHEN '2'
			   LET ptcode=51
			WHEN '3'
			   LET ptcode=52
          END CASE
          PRINT COLUMN 60-FGL_WIDTH(g_x[ptcode]),g_x[ptcode] CLIPPED;
#         PRINT cl_numfor(m_total,16,g_azi05)  #TQC-6A0081
          PRINT cl_numfor(m_total,16,g_azi03)  #TQC-6A0081
          LET m_total=0
      ELSE
         IF p_level = 1 AND p_i = 0 THEN
            IF (PAGENO > 1 OR LINENO > 14) THEN
                SKIP TO TOP OF PAGE
            END IF
         ELSE
            LET l_str2 = ' '
            IF p_level>10 THEN LET p_level=10 END IF
           #No.+157 010530 by plum
           #IF p_level !=0 THEN
           #   FOR l_k = 1 TO p_level
            IF p_level > 1 THEN
               FOR l_k = 1 TO p_level - 1
           #No.+157..end
                LET l_str2 = l_str2 clipped,'.' clipped
               END FOR
            ELSE LET l_str2 =''
            END IF
           LET l_print81 = l_str2 clipped,sr.bmb03
           PRINTX name=D1 COLUMN g_c[81],l_print81 CLIPPED,
                          COLUMN g_c[82],sr.ima08,
                          COLUMN g_c[92],sr.bmb10,  ## No:FUN-610092
                          COLUMN g_c[83],cl_numfor(sr.bmb06,83,3),
                          COLUMN g_c[84],cl_numfor(sr.mcsts,84,g_azi03),
                          COLUMN g_c[85],cl_numfor(sr.labcsts,85,g_azi03),
                          COLUMN g_c[86],cl_numfor(sr.cstsabs+sr.cstao2s,86,g_azi03), #製造費用
                          COLUMN g_c[87],cl_numfor(sr.outlabs+sr.outmbfs,87,g_azi03)  #廠外加工
           PRINTX name=D2 COLUMN g_c[88],' ',
                          COLUMN g_c[89],' ',
                          COLUMN g_c[93],' ',   ## No:FUN-610092
                          COLUMN g_c[90],sr.ima02,
                          COLUMN g_c[91],sr.ima021
           IF p_level=1 THEN
              LET m_total=m_total+sr.bmb06*(sr.mcsts+sr.labcsts+sr.cstsabs+
                                            sr.cstao2s+sr.outlabs+sr.outmbfs)
           ELSE
              LET m_total=m_total+sr.bmb06*(sr.labcsts+sr.cstsabs+
                                            sr.cstao2s+sr.outlabs+sr.outmbfs)
           END IF
        END IF
      END IF

   ON LAST ROW
      LET l_last_sw = 'y'

   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'y'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
#Patch....NO:TQC-610035 <001> #

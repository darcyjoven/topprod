# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfr705.4gl
# Descriptions...: 標 準 工 時 一 覽 表
# Date & Author..: 98/12/28 By ching
# Modify.........: No:8096 03/09/05 Carol SQL中 "GROUP BY 2" 未轉成 "GROUP BY bma01"
# Modify.........: No.FUN-550112 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-590110 05/09/27 By day   報表轉xml
# Modify.........: NO.TQC-5B0112 05/11/12 BY Nicola 料號、品名位置修改
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A40058 10/04/26 By lilingyu bmb16增加7.規格替代的情況
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			# Print condition RECORD
       		wc  	  LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where condition
       		ecu02     LIKE ecu_file.ecu02,
       		revision  LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(18)# 版本
          	effective LIKE type_file.dat,           #No.FUN-680121 DATE# 有效日期
       		more	  LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
          g_bma01         LIKE bma_file.bma01,  #產品結構單頭
          g_bma01_a       LIKE bma_file.bma01   #產品結構單頭
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_total         LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   l_str9          STRING   #No.FUN-590110
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ecu02     = ARG_VAL(8)
   LET tm.revision  = ARG_VAL(9)
   LET tm.effective  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r705_tm(0,0)			# Input print condition
      ELSE CALL asfr705()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r705_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_flag        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_one         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#資料筆數
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bma01       LIKE bma_file.bma01,          #工程變異之生效日期
          l_cmd		LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)
          l_ima571      LIKE ima_file.ima571          #No.B567
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 6 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 30
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r705_w AT p_row,p_col WITH FORM "asf/42f/asfr705"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.effective = g_today	#有效日期
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bma01
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(bma01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bma01
               NEXT FIELD bma01
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
      LET INT_FLAG = 0 CLOSE WINDOW r705_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 ",
                 "  FROM bma_file,ima_file",
                 " WHERE bma01=ima01 AND ima08 !='A' ",
                 "   AND ",tm.wc CLIPPED,
                 " GROUP BY bma01 "    #No:8096  Modify
       PREPARE r705_cnt_p FROM l_cmd
       DECLARE r705_cnt CURSOR FOR r705_cnt_p
       IF SQLCA.sqlcode THEN
           CALL cl_err('P0:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM
              
       END IF
       LET g_cnt=0          #No.7926
       FOREACH r705_cnt INTO g_i  ,l_bma01
          LET g_cnt=g_cnt+1
       END FOREACH
       IF g_cnt=1 THEN LET l_one='Y' END IF    #No.7926 end
   END IF
 
   INPUT BY NAME tm.ecu02,tm.revision,tm.effective,tm.more
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ecu02
         IF cl_null(tm.ecu02) THEN NEXT FIELD ecu02 END IF
         SELECT COUNT(*) INTO g_cnt FROM ecu_file WHERE ecu02=tm.ecu02
         IF g_cnt =0 THEN CALL cl_err('sel ecu',100,0) NEXT FIELD ecu02 END IF
 
      BEFORE FIELD revision
         IF l_one='N' THEN
             NEXT FIELD effective
         END IF
      AFTER FIELD revision
         IF tm.revision IS NOT NULL ThEN
            CALL s_version(l_bma01,tm.revision)
            RETURNING l_bdate,l_edate,l_flag
            LET tm.effective = l_bdate
            DISPLAY BY NAME tm.effective
         END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      #No.B567 010522 BY ANN CHEN
      ON ACTION CONTROLP
         CASE WHEN INFIELD(ecu02)
#                  CALL q_ecu1(0,0,'','')
#                      RETURNING l_ima571,tm.ecu02
#                  CALL FGL_DIALOG_SETBUFFER( l_ima571 )
#                  CALL FGL_DIALOG_SETBUFFER( tm.ecu02 )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_ecu1'
    LET g_qryparam.default1 = l_ima571
    LET g_qryparam.default2 = tm.ecu02
    CALL cl_create_qry() RETURNING l_ima571,tm.ecu02
#    CALL FGL_DIALOG_SETBUFFER( l_ima571 )
#    CALL FGL_DIALOG_SETBUFFER( tm.ecu02 )
# END genero shell script ADD
################################################################################
                  DISPLAY BY NAME tm.ecu02
              OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r705_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='asfr705'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr705','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.ecu02    CLIPPED,"'",
                         " '",tm.revision CLIPPED,"'",
                         " '",tm.effective CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr705',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r705_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr705()
   ERROR ""
END WHILE
   CLOSE WINDOW r705_w
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
FUNCTION asfr705()
   DEFINE l_name	LIKE type_file.chr20,           #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0090
          l_use_flag    LIKE aba_file.aba18,            #No.FUN-680121 VARCHAR(2)
#         l_ute_flag    LIKE type_file.chr3,            #No.FUN-680121 VARCHAR(3)   #FUN-A40058 mark
          l_ute_flag    LIKE type_file.chr4,            #FUN-A40058 
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_bma01 LIKE bma_file.bma01           #主件料件
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550112
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT bma01",
                 "  FROM bma_file, ima_file,ecu_file",
                 " WHERE ima01 = bma01",
                 "   AND ecu01 = bma01",
                 "   AND ecu02 = '",tm.ecu02,"' ",
                 "   AND ima08 !='A' ",
                 "   AND bma06 = ima910 ",  #FUN-550112
                 "   AND ",tm.wc
     PREPARE r705_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
	 CALL cl_err('prepare:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   EXIT PROGRAM 
   END IF
     DECLARE r705_cs1 CURSOR FOR r705_prepare1
     CALL cl_outnam('asfr705') RETURNING l_name
#No.FUN-590110-begin
     IF g_sma.sma888[1,1] ='Y' THEN
        LET g_zaa[54].zaa06 = "N"
     ELSE
        LET g_zaa[54].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-590110-end
     START REPORT r705_rep TO l_name
     LET g_total=0
     LET g_pageno = 0
     FOREACH r705_cs1 INTO l_bma01
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01=l_bma01
       LET g_bma01_a=l_bma01
       #FUN-550112
       LET l_ima910=''
       SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_bma01
       IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
       #--
       #-->                    固定給1
       CALL r705_bom(0,l_bma01,l_ima910,1)   #FUN-550112
     END FOREACH
     FINISH REPORT r705_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION r705_bom(p_level,p_key,p_key2,p_total)   #FUN-550112
   DEFINE p_level	LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_total       LIKE csb_file.csb05,          #No.FUN-680121 DECIMAL(13,5)
          p_key		LIKE bma_file.bma01,          #主件料件編號
          p_key2	LIKE ima_file.ima910,         #FUN-550112
          l_ac,i	LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_tot,l_times LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          arrno		LIKE type_file.num5,          #No.FUN-680121 SMALLINT#BUFFER SIZE (可存筆數)
          b_seq		LIKE type_file.num5,          #No.FUN-680121 SMALLINT#當BUFFER滿時,重新讀單身之起始序號
          l_chr		LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          sr DYNAMIC ARRAY OF RECORD        #每階存放資料
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima63 LIKE ima_file.ima63,    #發料單位
              ima55 LIKE ima_file.ima55,    #生產單位
              bmb23 LIKE bmb_file.bmb23,    #選中率
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01,          #No.FUN-680121 VARCHAR(20)
#             a     LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
#             b     LIKE ima_file.ima26           #No.FUN-680121 DEC(15,3)
              a     LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
              b     LIKE type_file.num15_3  ###GP5.2  #NO.FUN-A20044
          END RECORD,
          l_cmd		LIKE type_file.chr1000    #No.FUN-680121 VARCHAR(1100)
DEFINE k      LIKE type_file.num5    #No.FUN-590110        #No.FUN-680121 SMALLINT
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
#       LET g_pageno = 0    #會導致總頁數顯示不正確，mark  #No.FUN-590110
        LET sr[1].bmb03 = p_key
        #-->                    固定給1
        OUTPUT TO REPORT r705_rep(1,0,1,sr[1].*)	#第0階主件資料
    END IF
    LET arrno = 600
    LET l_times=1
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb15,bmb16,bmb03,ima02,ima021,ima05,ima06,ima08,ima15, ",
            "       ima37,ima63,ima55,bmb23,bmb02,bmb06/bmb07,bmb08,bmb10, ",
            "       bmb18,bmb09,bmb04,bmb05,bmb14, ",
            "       bmb17,bmb11,bmb13,bma01,0 ,0  ",
            "  FROM bmb_file, OUTER ima_file, OUTER bma_file ",
            " WHERE bmb01='", p_key,"' AND bmb02 > ",b_seq,
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
            "   AND bmb_file.bmb03 = ima_file.ima01 ",
            "   AND bmb_file.bmb03 = bma_file.bma01 "
        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=
                  l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
                  "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
                  "' OR bmb05 IS NULL)"
        END IF
 
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY  bmb03 "
 
        PREPARE r705_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
	 	CALL cl_err('P1:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   EXIT PROGRAM
   
        END IF
        DECLARE r705_cur CURSOR FOR r705_ppp
 
        LET l_ac = 1
        FOREACH r705_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
    	    LET g_total=g_total+1
            #FUN-8B0035--BEGIN-- 
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END--
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
    	LET l_tot=l_ac-1
#No.FUN-590110-begin
             LET l_str9=''
             IF p_level >1 THEN
               FOR k = 2 TO p_level
                   LET l_str9=l_str9,' '
               END FOR
             END IF
#No.FUN-590110-end
        FOR i = 1 TO l_tot		# 讀BUFFER傳給REPORT
            OUTPUT TO REPORT r705_rep(p_level,i,p_total*sr[i].bmb06,sr[i].*)
            IF sr[i].bma01 IS NOT NULL THEN
                LET g_bma01=sr[i].bma01
               #CALL r705_bom(p_level,sr[i].bmb03,' ',p_total*sr[i].bmb06)   #FUN-550112#FUN-8B0035
                CALL r705_bom(p_level,sr[i].bmb03,l_ima910[i],p_total*sr[i].bmb06)   #FUN-8B0035
            END IF
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_tot].bmb02
            LET l_times=l_times+1
        END IF
    END WHILE
END FUNCTION
 
REPORT r705_rep(p_level,p_i,p_total,sr)
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_total       LIKE csb_file.csb05,          #No.FUN-680121 DECIMAL(13,5)
          l_ecb19       LIKE ecb_file.ecb19,
          l_ecb38       LIKE ecb_file.ecb38,
          sr  RECORD
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #CLASS CODE
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima63 LIKE ima_file.ima63,    #發料單位
              ima55 LIKE ima_file.ima55,    #生產單位
              bmb23 LIKE bmb_file.bmb23,    #選中率
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01,    #No.FUN-680121 VARCHAR(20)
#             a     LIKE ima_file.ima26,    #No.FUN-680121 DEC(15,3)
#             b     LIKE ima_file.ima26     #No.FUN-680121 DEC(15,3)
              a     LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
              b     LIKE type_file.num15_3  ###GP5.2  #NO.FUN-A20044              
          END RECORD,
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima02,    #品名規格
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima37 LIKE ima_file.ima37,    #補貨
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_bma02 LIKE bma_file.bma02,    #品名規格
          l_bma03 LIKE bma_file.bma03,    #品名規格
          l_bma04 LIKE bma_file.bma04,    #品名規格
          l_imz02 LIKE imz_file.imz02,    #說明內容
          l_use_flag    LIKE aba_file.aba18,          #No.FUN-680121 VARCHAR(2)
       #  l_ute_flag    LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)  #FUN-A40058
          l_ute_flag    LIKE type_file.chr4,          #FUN-A40058 
          l_bmc05 ARRAY[100] OF LIKE bmc_file.bmc05,         #No.FUN-680121 VARCHAR(10)#說明
          l_bmt06 ARRAY[200] OF LIKE type_file.chr20,        #No.FUN-680121 VARCHAR(20)#插件位置
		  l_cnt,l_cnt2 LIKE type_file.num5,          #No.FUN-680121 SMALLINT
		  l_sql1   LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(1000)
		  l_sql2   LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(1000)
		  l_pmh01  LIKE pmh_file.pmh01,
		  l_pmh02  LIKE pmh_file.pmh02,
		  l_pmh03  LIKE pmh_file.pmh03,
		  l_pmh04  LIKE pmh_file.pmh04,
		  l_pmh05  LIKE pmh_file.pmh05,
		  l_pmh12  LIKE pmh_file.pmh12,
		  l_pmh13  LIKE pmh_file.pmh13,
          l_pmc03  LIKE pmc_file.pmc03,
          l_ver    LIKE ima_file.ima05,
	  l_str    LIKE type_file.chr8,          #No.FUN-680121 VARCHAR(8)
          l_k      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_str2   LIKE type_file.chr10,         #No.FUN-680121 VARCHAR(10)
          l_bmb06,l_total LIKE bmb_file.bmb06,   #No.FUN-680121 VARCHAR(8)
          l_no            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_byte,l_len    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_bmt06_s       LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
          l_bmtstr        LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
          l_now,l_now2    LIKE type_file.num5           #No.FUN-680121 SMALLINT
  DEFINE  l_ima571        LIKE ima_file.ima571 #No.B567
  DEFINE  l_ss     LIKE type_file.chr20        #No.FUN-680121 VARCHAR(20)#No.FUN-590110
  DEFINE  l_ss1    LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(255)#No.FUN-590110
  DEFINE  i        LIKE type_file.num5         #No.FUN-590110        #No.FUN-680121 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 #ORDER BY sr.bmb01
 
#No.FUN-590110-begin
  FORMAT
   PAGE HEADER
      #公司名稱
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT
      CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
      PRINT g_x[14] CLIPPED,tm.effective,'  ',    #有效日期
            g_x[12] CLIPPED,l_ver                 #列印版本
      PRINT g_dash[1,g_len]
 
      SELECT ima02,ima021,ima05,ima06,ima08,
  #           ima37,ima63,ima55
             ima37,ima63,ima55,ima571 #No.B567
        INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
             l_ima37,l_ima63,l_ima55,l_ima571
        FROM ima_file
       WHERE ima01=g_bma01_a
      IF SQLCA.sqlcode THEN
            LET l_ima02='' LET l_ima05=''
            LET l_ima06='' LET l_ima08=''
            LET l_ima37='' LET l_ima63='' LET l_ima55=''
            LET l_ima571=''
      END IF
      SELECT bma02,bma03,bma04 INTO l_bma02,l_bma03,l_bma04 FROM bma_file
       WHERE bma01=g_bma01_a
      IF SQLCA.sqlcode THEN
            LET l_bma02='' LET l_bma03='' LET l_bma04=''
      END IF
      SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01=l_ima06
      IF SQLCA.sqlcode THEN LET l_imz02='' END IF
     #PRINT g_x[11] CLIPPED, l_ima06,' ',l_imz02
 
      PRINT g_x[13] CLIPPED, g_bma01_a CLIPPED,'    '   #No.TQC-5B0112 &051112
      PRINT g_x[15] CLIPPED, l_ima02 CLIPPED,'    '   #No.TQC-5B0112 &051112
      PRINT g_x[16] CLIPPED, tm.ecu02 CLIPPED
      PRINT g_dash2[1,g_len]
      #表頭
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                     g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
                     g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]
      PRINTX name=H3 g_x[51],g_x[52],g_x[53],g_x[54],g_x[55]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
    ON EVERY ROW
      IF p_level = 1 AND p_i = 0 THEN
           IF (PAGENO > 1 OR LINENO > 16) THEN
                SKIP TO TOP OF PAGE
           END IF
      ELSE
      #-->列印插件位置
         FOR g_cnt=1 TO 200
             LET l_bmt06[g_cnt]=NULL
         END FOR
          DECLARE r705_bmt CURSOR FOR
              SELECT bmt06 FROM bmt_file
              WHERE bmt01=g_bma01 AND bmt02=sr.bmb02 AND
                    bmt03=sr.bmb03 AND
                    (bmt04 IS NULL OR bmt04 >=sr.bmb04)
         LET l_now2=1
         LET l_len =20
         LET l_bmtstr = ''
         FOREACH r705_bmt INTO l_bmt06_s
            IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            IF l_now2 > 200 THEN CALL cl_err('','9036',1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM 
            END IF
            LET l_byte = length(l_bmt06_s) + 1
            IF l_len >= l_byte THEN
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
               LET l_len = l_len - l_byte
            ELSE
               LET l_bmt06[l_now2] = l_bmtstr
               LET l_now2 = l_now2 + 1
               LET l_len = 20
               LET l_len = l_len - l_byte
               LET l_bmtstr = ''
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
            END IF
         END FOREACH
         LET l_bmt06[l_now2] = l_bmtstr
         #說明
         FOR g_cnt=1 TO 100 LET l_bmc05[g_cnt]=NULL END FOR
         LET l_now=1
         DECLARE r705_bmc CURSOR FOR
            SELECT bmc05 FROM bmc_file
             WHERE bmc01=g_bma01 AND bmc02=sr.bmb02 AND
                   bmc021=sr.bmb03 AND (bmc03 IS NULL OR bmc03 >=sr.bmb04)
         FOREACH r705_bmc INTO l_bmc05[l_now]
             IF SQLCA.sqlcode THEN
                 CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
             END IF
             IF l_now > 100 THEN EXIT FOREACH END IF
             LET l_now=l_now+1
         END FOREACH
         LET l_now=l_now-1
         #---->改變使用特性的表示方式
         IF sr.bmb15 = 'Y' THEN LET sr.bmb15='*' ELSE LET sr.bmb15=' ' END IF
         #---->改變替代特性的表示方式
#bugno:7111 modify ................................................
         LET l_ute_flag='USTZ'        #FUN-A40058 add 'Z'
         IF sr.bmb16 MATCHES '[1257]' THEN         #FUN-A40058 add '7'
            CASE sr.bmb16
                 WHEN '1'  LET sr.bmb16=l_ute_flag[1,1]
                 WHEN '2'  LET sr.bmb16=l_ute_flag[2,2]
                 WHEN '5'  LET sr.bmb16=l_ute_flag[3,3]
                 WHEN '7'  LET sr.bmb16=l_ute_flag[4,4]    #FUN-A40058 add
                 OTHERWISE LET sr.bmb16=' '
            END CASE
         ELSE
            LET sr.bmb16=' '
         END IF
#bugno:7111 end ................................................
         #---->元件使用特性
         IF sr.bmb14 ='1' THEN LET sr.bmb14 ='O' ELSE LET sr.bmb14 = '' END IF
         #---->特性旗標
         IF sr.bmb17='Y' THEN LET sr.bmb17='F' ELSE LET sr.bmb17=' ' END IF
         #---->內縮以'.'表示
         LET l_str2 =''
         IF p_level>10 THEN LET p_level=10 END IF
         IF p_level !=0 THEN
           FOR l_k = 1 TO p_level
               LET l_str2=l_str2 clipped,'.' clipped
           END FOR
         ELSE
           LET l_str2 =''
         END IF
         NEED 2 LINES
         #---->為使用量可列印出
         CALL cl_numfor3(sr.bmb06) returning l_bmb06
         CALL cl_numfor3(p_total)  returning l_total
         #---->列印出資料
         LET l_ss=NULL    #層級項次
         LET l_ss=l_str9,sr.bmb02 USING "<<<<<"
 
         LET l_ecb19=0
         LET l_ecb38=0
         SELECT ecb19,ecb38 INTO l_ecb19,l_ecb38 FROM ecb_file
        #  WHERE ecb01=g_bma01_a AND ecb02=tm.ecu02
          WHERE ecb01=l_ima571 AND ecb02=tm.ecu02
            AND ecb03=(SELECT MIN(ecb03) FROM ecb_file
             #            WHERE ecb01=g_bma01_a AND ecb02=tm.ecu02
                        WHERE ecb01=l_ima571 AND ecb02=tm.ecu02
                           AND ecb06=sr.bmb09)   #作業編號
 
         IF cl_null(l_ecb19) THEN LET l_ecb19=0 END IF
         IF cl_null(l_ecb38) THEN LET l_ecb38=0 END IF
 
         LET sr.a=l_ecb19*l_total
         LET sr.b=l_ecb38*l_total
 
         FOR g_cnt = 1 TO l_now2
          IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' ' THEN EXIT FOR END IF
         END FOR
         IF l_now2 = 0 THEN LET l_bmt06[g_cnt]=' ' END IF
 
         #列印剩下說明
         IF l_now >= 1 THEN
            FOR g_cnt = 1 TO l_now
              STEP 2
                 LET l_ss1=l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED
            END FOR
         END IF
 
         PRINTX name=D1 COLUMN g_c[31],l_ss CLIPPED,
                        COLUMN g_c[32],sr.bmb03 CLIPPED,  #元件料件編號
                        COLUMN g_c[33],sr.ima37 CLIPPED,  #補貨策略
                        COLUMN g_c[34],cl_numfor(l_bmb06,34,0),   #組成用量（本階）
                        COLUMN g_c[35],sr.bmb04 CLIPPED,  #生效日期
                        COLUMN g_c[36],sr.bmb08 USING '-&.&&',  #耗損%
                        COLUMN g_c[37],l_bmtstr CLIPPED, #插件位置[1]
                        COLUMN g_c[38],sr.bmb14 CLIPPED, #使用特性
                        COLUMN g_c[39],sr.bmb16 CLIPPED, #取/替代特性
                        COLUMN g_c[40],cl_numfor(sr.a,40,3)   #標准工時
         PRINTX name=D2 COLUMN g_c[42],sr.ima02 CLIPPED,  #品名
                        COLUMN g_c[43],sr.ima08 CLIPPED,  #來源
                        COLUMN g_c[44],cl_numfor(l_total,44,0),   #組成用量（終階）
                        COLUMN g_c[45],sr.bmb05 CLIPPED,  #失效日期
                        COLUMN g_c[46],sr.bmb18 USING '-----',  #時距
                        COLUMN g_c[48],sr.bmb15 CLIPPED, #消耗特性
                        COLUMN g_c[49],sr.bmb17 CLIPPED, #特性旗標
                        COLUMN g_c[50],cl_numfor(sr.b,50,3)   #單位人力
         PRINTX name=D3 COLUMN g_c[52],sr.ima021 CLIPPED,  #規格
                        COLUMN g_c[53],sr.bmb10 CLIPPED,   #發料單位
                        COLUMN g_c[55],l_ss1[1,10],   #剩余說明
                        COLUMN g_c[54],sr.ima15 CLIPPED   #保稅
      END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
      PRINT g_x[10] CLIPPED,'  ',g_x[11] CLIPPED
#No.FUN-590110-end
      PRINT g_dash[1,g_len]
      IF g_pageno = 0 OR l_last_sw = 'y' THEN
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      ELSE
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
#Patch....NO.TQC-610037 <> #

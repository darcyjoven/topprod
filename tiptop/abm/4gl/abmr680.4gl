# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abmr680.4gl
# Descriptions...: 替代料件總表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/06 By Lee
#      Modify    : 92/05/28 By David
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-710038 07/01/10 By Ray 報表錯誤修改 
# Modify.........: No.FUN-850049 08/05/12 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/19 By vealxu ima26x 調整
# Modify.........: No:CHI-A70008 10/07/06 By Summer 增加顯示主件編號(bmd08)/主件品名(ima02)/主件規格(ima021)在細目的最前面
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
   		s    	LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(3)
   		t    	LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(3)
   		y    	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   		ww   	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   		more	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD
 
DEFINE   g_chr   LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_i     LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   l_table        STRING,                 ### FUN-850049 ###                                                                  
         g_sql          STRING,                 ### FUN-850049 ###                                                                  
         g_str          STRING                  ### FUN-850049 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
### *** FUN-850049 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "ima01.ima_file.ima01,",                                                                                            
                "ima02.ima_file.ima02,",                                                                                            
                "ima021.ima_file.ima021,",                                                                                          
                "ima05.ima_file.ima05,",                                                                                            
                "ima06.ima_file.ima06,",                                                                                            
                "ima09.ima_file.ima09,",                                                                                            
                "ima10.ima_file.ima10,",                                                                                            
                "ima11.ima_file.ima11,",                                                                                            
                "ima12.ima_file.ima12,",                                                                                            
                "ima08.ima_file.ima08,",                                                                                            
                "ima63.ima_file.ima63,",
                "bmd03.bmd_file.bmd03,",                                                                                            
                "item.ima_file.ima01,",
                "part.bmd_file.bmd01,",                                                                                             
                "bmd05.bmd_file.bmd05,",                                                                                            
                "bmd06.bmd_file.bmd06,",                                                                                            
                "bmd07.bmd_file.bmd07,",                                                                                            
                "l_ima02.ima_file.ima02,",                                                                                          
                "l_ima021.ima_file.ima021,",                                                                                        
                "l_ima05.ima_file.ima05,",                                                                                          
                "l_ima08.ima_file.ima08,",    #CHI-A70008 mod ,",                                                                                          
                "bmd08.bmd_file.bmd08,",      #CHI-A70008 add
                "l_ima02_h2.ima_file.ima02,", #CHI-A70008 add
                "l_ima021_h2.ima_file.ima021" #CHI-A70008 add
    LET l_table = cl_prt_temptable('abmr680',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                              
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"  #CHI-A70008                                                                           
                        #?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"   #CHI-A70008 mark                                                                          
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.y  = ARG_VAL(10)
   LET tm.ww = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r680_tm(0,0)		# Input print condition
      ELSE CALL abmr680()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r680_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_cmd		LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 1 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 9
   END IF
 
   OPEN WINDOW r680_w AT p_row,p_col
        WITH FORM "abm/42f/abmr680"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.y    = '0'
   LET tm.ww = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima08,ima06,
                       ima09,ima10,ima11,ima12,ima37
     #--No.FUN-4B0022--------
     ON ACTION CONTROLP
        CASE WHEN INFIELD(ima01)      #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima01
                 NEXT FIELD ima01
        OTHERWISE EXIT CASE
        END CASE
     #--END---------------
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
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r680_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.y,tm.ww,tm.more WITHOUT DEFAULTS
      AFTER FIELD y
          IF tm.y NOT MATCHES '[0-4]' OR tm.y  IS NULL  THEN
              NEXT FIELD y
          END IF
      AFTER FIELD ww
          IF tm.ww NOT MATCHES '[12]' OR tm.ww  IS NULL  THEN
              NEXT FIELD ww
          END IF
      AFTER FIELD more
          IF tm.more NOT MATCHES '[YN]' OR tm.more  IS NULL  THEN
              NEXT FIELD more
          END IF
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
      ON ACTION CONTROLP CALL r680_wc()   # Input detail Where Condition
          IF INT_FLAG THEN EXIT INPUT END IF
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r680_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr680'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr680','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",tm.ww CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr680',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r680_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr680()
   ERROR ""
END WHILE
   CLOSE WINDOW r680_w
END FUNCTION
 
FUNCTION r680_wc()
   DEFINE l_wc    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r680_w2 AT 2,2
        WITH FORM "aim/42f/aimi101"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi101")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
        ima01, ima05, ima08, ima02, ima03,
#        ima07, ima15, ima70, ima25, ima26, ima262,ima261,  #FUN-A20044
        ima07, ima15, ima70, ima25,                         #FUN-A20044
        ima23, ima35, ima36, ima71, ima271,ima27,
        ima28, ima29, ima30, ima73, ima74,
        ima63, ima63_fac,    ima64, ima641,
        imauser, imagrup, imamodu, imadate, imaacti
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
   CLOSE WINDOW r680_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
END FUNCTION
 
FUNCTION abmr680()
   DEFINE l_name	LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE ima_file.ima01,  #No.FUN-680096 VARCHAR(40)
          sr RECORD
             order1 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order2 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order3 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             ima01 LIKE ima_file.ima01,	       #料件編號
             ima02 LIKE ima_file.ima02,        #品名規格
             ima021 LIKE ima_file.ima021,      #FUN-510033
             ima05 LIKE ima_file.ima05,        #版本
             ima06 LIKE ima_file.ima06,        # group code
             ima09 LIKE ima_file.ima09,        # group code
             ima10 LIKE ima_file.ima10,        # group code
             ima11 LIKE ima_file.ima11,        # group code
             ima12 LIKE ima_file.ima12,        # group code
             ima08 LIKE ima_file.ima08,        #來源
             ima63 LIKE ima_file.ima63,        #來源
             bmd03 LIKE bmd_file.bmd03,        #替代順序
             item  LIKE ima_file.ima01,
             part  LIKE bmd_file.bmd01,
             bmd05 LIKE bmd_file.bmd05,        #生效日期
             bmd06 LIKE bmd_file.bmd06,        #失效日期
             bmd07 LIKE bmd_file.bmd07,        #用量 #CHI-A70008 add ,
             bmd08 LIKE bmd_file.bmd08         #CHI-A70008 add
          END RECORD
 
##No.FUN-850049-Add--Begin--#                                                                                                       
   DEFINE l_ima02 LIKE ima_file.ima02,        #品名規格                                                                             
          l_ima021 LIKE ima_file.ima021,                                                                                            
          l_ima05 LIKE ima_file.ima05,        #版本                                                                                 
          l_ima08 LIKE ima_file.ima08         #來源                                                                                 
##No.FUN-850049-Add--End--#
  #CHI-A70008 add --start--
   DEFINE l_ima02_h2  LIKE ima_file.ima02,        #品名                                                                             
          l_ima021_h2 LIKE ima_file.ima021        #規格                                                                                    
  #CHI-A70008 add --end--
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-850049 *** ##                                                      
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           #FUN-850049                                   
   #------------------------------ CR (2) ------------------------------#
 
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
 
     LET l_sql = "SELECT '','','',",
                 "ima01,ima02,ima021,ima05,ima06,ima09,", #FUN-510033 add ima021
                 "ima10,ima11,ima12,ima08,ima63,",
                 "bmd03,"
     IF tm.ww='1' THEN
         LET l_sql=l_sql CLIPPED, "bmd04,bmd01,bmd05,bmd06,bmd07,bmd08" #CHI-A70008 add bmd08
     ELSE
         LET l_sql=l_sql CLIPPED, "bmd01,bmd01,bmd05,bmd06,bmd07,bmd08" #CHI-A70008 add bmd08
     END IF
     LET l_sql=l_sql CLIPPED,
         " FROM bmd_file,ima_file",
         " WHERE bmd02='2'",
         " AND ima08!='Z'",
         " AND ",tm.wc,
         " AND bmdacti = 'Y'"                                           #CHI-910021
     IF tm.ww='1' THEN
         LET l_sql=l_sql CLIPPED, " AND ima01=bmd01"
     ELSE
         LET l_sql=l_sql CLIPPED, " AND ima01=bmd04"
     END IF
            LET INT_FLAG = 0  ######add for prompt bug
     IF INT_FLAG THEN
        LET INT_FLAG = 0
     END IF
     PREPARE r680_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r680_cs1 CURSOR FOR r680_prepare1
 
#    CALL cl_outnam('abmr680') RETURNING l_name                                    #No.FUN-850049
#    START REPORT r680_rep TO l_name                                               #No.FUN-850049
 
     LET g_pageno = 0
     FOREACH r680_cs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
       IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
       IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
       IF sr.bmd03 IS NULL THEN LET sr.bmd03 = ' ' END IF
       IF sr.item  IS NULL THEN LET sr.item  = ' ' END IF
       IF sr.bmd08 IS NULL THEN LET sr.bmd08 = ' ' END IF #CHI-A70008 add
       #在順序判斷時, 只假有當條件給原始料件時方為有效
#No.FUN-850049--Mark--Begin--#
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1'
#                    LET l_order[g_i] = sr.ima01
#              WHEN tm.s[g_i,g_i] = '2'
#                    LET l_order[g_i] = sr.ima05
#              WHEN tm.s[g_i,g_i] = '3'
#                    LET l_order[g_i] = sr.ima08
#              WHEN tm.s[g_i,g_i] = '4'
#                  CASE
#       				 WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
#       				 WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
#       				 WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
#       				 WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
#       				 WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
#                  END CASE
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r680_rep(sr.*)
#No.FUN-850049--Mark--End--#                                                                                                        
                                                                                                                                    
#No.FUN-850049--Add--Begin--#
          SELECT ima02,ima021,ima05,ima08                                                                                           
              INTO l_ima02,l_ima021,l_ima05,l_ima08                                                                                 
              FROM ima_file                                                                                                         
              WHERE ima01=sr.item                                                                                                   
          IF SQLCA.sqlcode THEN                                                                                                     
             LET l_ima02 = ' '  LET l_ima05 = ' ' LET l_ima08 = ' '                                                                 
             LET l_ima021 = ' '                                                                                                     
          END IF
          #CHI-A70008 add --start--
          SELECT ima02,ima021                                                                                           
              INTO l_ima02_h2,l_ima021_h2                                                                                 
              FROM ima_file
              WHERE ima01=sr.bmd08                                                       
          IF SQLCA.sqlcode THEN                                                                                                     
             LET l_ima02_h2 = ' '                                                                  
             LET l_ima021_h2 = ' '                                                                                                     
          END IF
          #CHI-A70008 add --end--
                                                                                                                                    
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-850049 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 sr.ima01,sr.ima02,sr.ima021,sr.ima05,sr.ima06,sr.ima09,sr.ima10,                                                   
                 sr.ima11,sr.ima12,sr.ima08,sr.ima63,sr.bmd03,sr.item,sr.part,sr.bmd05,                                                    
                 sr.bmd06,sr.bmd07,l_ima02,l_ima021,l_ima05,l_ima08,sr.bmd08,l_ima02_h2,l_ima021_h2 #CHI-A70008 add bmd08,l_ima02_h2,l_ima021_h2                                                                 
     #------------------------------ CR (3) ------------------------------#                                                         
#No.FUN-850049--Add--End--#
     END FOREACH
 
            LET INT_FLAG = 0  ######add for prompt bug
    #DISPLAY '' AT 2,1
#    FINISH REPORT r680_rep                                                           #No.FUN-850049
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                      #No.FUN-850049
 
#No.FUN-850049--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'ima01,ima05,ima08,ima06,ima09,ima10,ima11,ima12,ima37')                                               
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-850049--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-850049 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.y,";",                                                       
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.ww                                                                     
    CALL cl_prt_cs3('abmr680','abmr680',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
#No.FUN-870144
#No.FUN-850049--Mark--Begin--#
#REPORT r680_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1) 
#         l_key         LIKE ima_file.ima01,   #No.FUN-680096 VARCHAR(40)
#         l_ima01 LIKE ima_file.ima01,	       # 料件編號
#         l_ima02 LIKE ima_file.ima02,        #品名規格
#         l_ima021 LIKE ima_file.ima021,      #FUN-510033
#         l_ima05 LIKE ima_file.ima05,        #版本
#         l_ima08 LIKE ima_file.ima08,        #來源
#         l_cnt   LIKE type_file.num10,       #No.FUN-680096 INTEGER,
#         sr RECORD
#            order1 LIKE ima_file.ima01,       #No.FUN-680096 VARCHAR(40)
#            order2 LIKE ima_file.ima01,       #No.FUN-680096 VARCHAR(40)
#            order3 LIKE ima_file.ima01,       #No.FUN-680096 VARCHAR(40)
#            ima01 LIKE ima_file.ima01,	       # 料件編號
#            ima02 LIKE ima_file.ima02,        #品名規格
#            ima021 LIKE ima_file.ima021,      #FUN-510033
#            ima05 LIKE ima_file.ima05,        #版本
#            ima06 LIKE ima_file.ima06,        # group code
#            ima09 LIKE ima_file.ima09,        # group code
#            ima10 LIKE ima_file.ima10,        # group code
#            ima11 LIKE ima_file.ima11,        # group code
#            ima12 LIKE ima_file.ima12,        # group code
#            ima08 LIKE ima_file.ima08,        #來源
#            ima63 LIKE ima_file.ima63,        #發料單位
#            bmd03 LIKE bmd_file.bmd03,        #替代順序
#            item  LIKE ima_file.ima01,        #料件編號
#            part  LIKE bmd_file.bmd01,        #被取代料
#            bmd05 LIKE bmd_file.bmd05,        #生效日期
#            bmd06 LIKE bmd_file.bmd06,        #失效日期
#            bmd07 LIKE bmd_file.bmd07         #用量
#         END RECORD
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.part,sr.order1,sr.order2,sr.order3     #No.TQC-710038
# ORDER BY sr.order1,sr.order2,sr.order3,sr.part     #No.TQC-710038
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash
#     PRINT COLUMN g_c[31],g_x[16],
#           COLUMN g_c[34],g_x[17]
#     PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+1+g_w[32]+1+g_w[33]],
#           COLUMN g_c[34],g_dash2[1,g_w[34]+1+g_w[35]+1+g_w[36]+1+g_w[37]+1+g_w[38]+1+g_w[39]+1+g_w[40]+1+g_w[41]]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#     PRINTX name=H2 g_x[42],g_x[46],g_x[43]     #No.TQC-5B0030 modify
#     PRINTX name=H3 g_x[44],g_x[47],g_x[45]     #No.TQC-5B0030 modify
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  #被取代料件
#  BEFORE GROUP OF sr.part
#     IF tm.ww='1' THEN
#         PRINTX name=D1 COLUMN g_c[31],sr.part,
#                        COLUMN g_c[32],sr.ima05,
#                        COLUMN g_c[33],sr.ima08;
#     ELSE
#         SELECT ima02,ima021,ima05,ima08
#             INTO l_ima02,l_ima021,l_ima05,l_ima08
#             FROM ima_file
#             WHERE ima01=sr.item
#         IF SQLCA.sqlcode THEN
#            LET l_ima02 = ' '  LET l_ima05 = ' ' LET l_ima08 = ' '
#            LET l_ima021 = ' '
#         END IF
#         PRINTX name=D1 COLUMN g_c[31],sr.part,
#                        COLUMN g_c[32],l_ima05,
#                        COLUMN g_c[33],l_ima08;
#     END IF
#     LET l_cnt = 0
 
#  ON EVERY ROW
#     IF tm.ww='1' THEN
#         SELECT ima02,ima021,ima05,ima08
#             INTO l_ima02,l_ima021,l_ima05,l_ima08
#             FROM ima_file
#             WHERE ima01=sr.item
#         IF SQLCA.sqlcode THEN
#            LET l_ima02 = ' ' LET l_ima05 = ' ' LET l_ima08 = ' '
#            LET l_ima021 = ' '
#         END IF
#         PRINTX name=D1 COLUMN g_c[34],sr.bmd03 USING '-------&',
#                        COLUMN g_c[35],sr.item,
#                        COLUMN g_c[36],l_ima05,
#                        COLUMN g_c[37],l_ima08,
#                        COLUMN g_c[38],sr.bmd05,
#                        COLUMN g_c[39],sr.bmd06,
#                        COLUMN g_c[40],cl_numfor(sr.bmd07,40,3),
#                        COLUMN g_c[41],sr.ima63
#         IF l_cnt = 0 THEN
#            PRINTX name=D2 COLUMN g_c[42],sr.ima02;
#         END IF
#         PRINTX name=D2 COLUMN g_c[43],l_ima02
 
#         IF l_cnt = 0 THEN
#            PRINTX name=D3 COLUMN g_c[44],sr.ima021;
#         END IF
#         PRINTX name=D3 COLUMN g_c[45],l_ima021
#     ELSE
#         PRINTX name=D1 COLUMN g_c[34],sr.bmd03 USING '-------&',
#                        COLUMN g_c[35],sr.ima01,
#                        COLUMN g_c[36],sr.ima05,
#                        COLUMN g_c[37],sr.ima08,
#                        COLUMN g_c[38],sr.bmd05,
#                        COLUMN g_c[39],sr.bmd06,
#                        COLUMN g_c[40],cl_numfor(sr.bmd07,40,3),
#                        COLUMN g_c[41],sr.ima63
#         IF l_cnt = 0 THEN
#            PRINTX name=D2 COLUMN g_c[42],l_ima02;
#         END IF
#         PRINTX name=D2 COLUMN g_c[43],sr.ima02
 
#         IF l_cnt = 0 THEN
#            PRINTX name=D3 COLUMN g_c[44],l_ima021;
#         END IF
#         PRINTX name=D3 COLUMN g_c[45],sr.ima021
#     END IF
#     LET l_cnt = l_cnt + 1
 
#  ON LAST ROW
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850049--Mark--End--#

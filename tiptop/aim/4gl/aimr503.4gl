# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr503.4gl
# Descriptions...: 低於訂購點資料表
# Return code....:
# Date & Author..: 91/11/05 By Carol
#-------MODIFICATION-------MODIFICATION-------MODIFIACTION-------
# 1992/05/21 Lin: 修改程式不需分單倉及多倉, 只需針對料件主檔作列印
# 1992/10/13 Lee: 增加再補貨量的列印(ima99)
#------BugFIXED------------BugFIXED-----------BugFIXED-----------
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 將料號欄位位置放大成40碼
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-670066 06/07/19 By xumin voucher型報表轉template1
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: No.FUN-750097 07/06/05 By cheunl報表轉為CR報表
# Modify.........: No.MOD-760058 07/08/09 By pengu sr變數和sql語法撈出的資料沒有對應
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990081 09/10/09 By chenmoyan 有低于訂購點的資料則再補貨，產生請購單
# Modify.........: No:FUN-9B0023 09/11/04 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
# Modify.........: No.FUN-B70015 11/07/07 By yangxf 經營方式默認給值'1'經銷
# Modify.........: No:MOD-BA0051 11/10/07 By johung 產生請購單時 pmlplant/pmllegal/pmkplant/pmklegal未給預設值
# Modify.........: No:FUN-910088 11/11/22 By chenjing 增加數量欄位小數取位
# Modify.........: No:MOD-C10073 12/01/13 By ck2yuan 若依再補貨點  pml20應該考慮ima99
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
           wc       STRING,                 # Where condition            #TQC-630166
           c        LIKE type_file.chr1,    # 庫存是否包含不可用數量     #No.FUN-690026 VARCHAR(1)
           a        LIKE type_file.chr1,    # print(1)安全存量 (2)再補貨點  #No.FUN-690026 VARCHAR(1)
           s        LIKE type_file.chr3,    # 排列順序                   #No.FUN-690026 VARCHAR(03)
           t        LIKE type_file.chr3,    # 跳頁控制                   #No.FUN-690026 VARCHAR(02)
           y        LIKE type_file.chr1,    # group code choice          #No.FUN-690026 VARCHAR(1)
           more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i LIKE type_file.num5,     #count/index for any purpose  #No.FUN-690026 SMALLINT
       l_orderA      ARRAY[3] OF LIKE ima_file.ima23   #No.TQC-6A0088
DEFINE l_table        STRING                 #No.FUN-750097                                                                    
DEFINE g_str          STRING                 #No.FUN-750097                                                                    
DEFINE g_sql          STRING                 #No.FUN-750097
DEFINE g_flag         LIKE type_file.chr1    #No.FUN-990081
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
#No.FUN-750097 -----------start-----------------                                                    
    LET g_sql = " ima01.ima_file.ima01,", 
                " ima02.ima_file.ima02,",
                " ima05.ima_file.ima05,",
                " ima06.ima_file.ima06,",
                " ima08.ima_file.ima08,",
                " ima07.ima_file.ima07,",
                " ima37.ima_file.ima37,",
                " ima25.ima_file.ima25,",
#               " ima26.ima_file.ima26,",       #FUN-A20044
#               " ima261.ima_file.ima261,",     #FUN-A20044
#               " ima262.ima_file.ima262,",     #FUN-A20044
                " avl_stk_mpsmrp.type_file.num15_3,", #FUN-A20044
                " unavl_stk.type_file.num15_3,",      #FUN-A20044
                " avl_stk.type_file.num15_3,",        #FUN-A20044   
                " ima38.ima_file.ima38,",
                " ima27.ima_file.ima27,",
                " ima99.ima_file.ima99,",
                " ima09.ima_file.ima09,",
                " ima10.ima_file.ima10,",
                " ima11.ima_file.ima11,",
                " ima12.ima_file.ima12"
                                                                                                                                    
    LET l_table = cl_prt_temptable('aimr503',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ? , ?, ",                                                                       
                "        ?, ?, ?, ?, ?, ?, ?, ? )"                                                                                              
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF
#No.FUN-750097---------------end------------
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.c  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET tm.y  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r503_tm()	        	# Input print condition
      ELSE CALL aimr503()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r503_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW r503_w AT p_row,p_col
        WITH FORM "aim/42f/aimr503"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c    = 'Y'
   LET tm.a    = '1'
   LET tm.s    = '12'
   LET tm.y    = '0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = ''
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima06,ima09,ima10,ima11,ima12
 
#No.FUN-570240 --start
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
      LET INT_FLAG = 0 CLOSE WINDOW r503_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.c,tm.a,
                                 tm2.s1,tm2.s2, tm2.t1,tm2.t2,
				 tm.y,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]"
            THEN NEXT FIELD c
         END IF
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES "[12]"
            THEN NEXT FIELD a
         END IF
 
      AFTER FIELD y
         IF tm.y IS NULL OR tm.y NOT MATCHES "[0-4]"
            THEN NEXT FIELD y
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
      #UI
      AFTER INPUT
#        LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
#        LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
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
      LET INT_FLAG = 0 CLOSE WINDOW r503_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr503'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr503','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.y CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr503',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r503_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   LET g_flag='N'                               #No.FUN-990081
   CALL aimr503()
#No.FUN-990081 --Begin
   IF g_flag = 'Y' THEN
      IF cl_confirm('aim-159') THEN
         CALL r503_gen_pr()
      END IF
   END IF
#No.FUN-990081 --End
   ERROR ""
END WHILE
   CLOSE WINDOW r503_w
END FUNCTION
 
FUNCTION aimr503()
   DEFINE l_name	LIKE type_file.chr20, 		   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
        l_name1         LIKE type_file.chr20,
          l_sql 	STRING,    		           # RDSQL STATEMENT  #TQC-630166 
          l_chr		LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
          l_za05	LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01  LIKE ima_file.ima01, #料件編號
                               ima02  LIKE ima_file.ima02, #品名規格
                               ima05  LIKE ima_file.ima05, #版本
                               ima06  LIKE ima_file.ima06, #分群碼
                               ima08  LIKE ima_file.ima08, #來源
                               ima07  LIKE ima_file.ima07, #ABC碼
                               ima37  LIKE ima_file.ima37, #補貨策略碼
                               ima25  LIKE ima_file.ima25, #庫存單位
#                              ima26  LIKE ima_file.ima26, #MPS/MRP可用量     #FUN-A20044
#                              ima261 LIKE ima_file.ima261,#庫存不可用量      #FUN-A20044
#                              ima262 LIKE ima_file.ima262,#庫存可用量        #FUN-A20044
                               avl_stk_mpsmrp LIKE type_file.num15_3,         #FUN-A20044
                               unavl_stk      LIKE type_file.num15_3,         #FUN-A20044
                               avl_stk        LIKE type_file.num15_3,         #FUN-A20044     
                              #ima38 LIKE ima_file.ima38,  #No.FUN-670066  #No.MOD-760058 mark
                               ima27  LIKE ima_file.ima27, #安全存量/再補貨點
                               ima38 LIKE ima_file.ima38,  #No.MOD-760058 sdd
                               ima99  LIKE ima_file.ima99, #再補貨量   #No.FUN-670066
#                              total  LIKE ima_file.ima26, #庫存數量          #FUN-A20044
#                              diff   LIKE ima_file.ima26, #數量差異          #FUN-A20044
#                              diff2  LIKE ima_file.ima26, #No.FUN-670066     #FUN-A20044
                               total  LIKE type_file.num15_3,                 #FUN-A20044
                               diff   LIKE type_file.num15_3,                 #FUN-A20044
                               diff2  LIKE type_file.num15_3,                 #FUN-A20044
                               ima09  LIKE ima_file.ima09, #其他分群碼
                               ima10  LIKE ima_file.ima10, #其他分群碼
                               ima11  LIKE ima_file.ima11, #其他分群碼
                               ima12  LIKE ima_file.ima12  #其他分群碼
                            #  ima99  LIKE ima_file.ima99  #再補貨量        #No.FUN-670066
                        END RECORD
     DEFINE l_count    LIKE type_file.num5                 #No.FUN-990081
     DEFINE l_i        LIKE type_file.num5                 #No.FUN-990081
     DEFINE l_avl_stk_mpsmrp  LIKE type_file.num15_3,      #No.FUN-A20044
            l_unavl_stk       LIKE type_file.num15_3,      #No.FUN-A20044
            l_avl_stk         LIKE type_file.num15_3       #No.FUN-A20044
 
#No.FUN-750097-----------------start--------------
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                       
#No.FUN-750097-----------------end----------------
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
#No.FUN-670066-Begin
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr503'    
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF 
#   FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-670066-End
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
 
     #--->安全存量
     IF tm.a = '1' THEN
        LET l_sql = "SELECT '','', ",
                 " ima01, ima02, ima05, ima06,  ",
		 " ima08, ima07, ima37, ima25,",
           #      " ima26, ima261,ima262, ima27, 0 ,0 , ",    #No.FUN-670066
#                " ima26, ima261,ima262, ima27, 0 ,ima99,0 ,0, 0 ",  #No.FUN-670066   #FUN-A20044
                 " ' ', ' ',' ', ima27, 0 ,ima99,0 ,0, 0 ",
		 " ima09, ima10, ima11, ima12 ",
                 "  FROM ima_file",
                 " WHERE ",tm.wc CLIPPED, " AND imaacti = 'Y' "
#No.FUN-A20044 ---mark---start
#        #--->包含不可用數量
#        IF tm.c='Y' THEN
#    	   LET l_sql = l_sql CLIPPED, " AND ima27 > (ima262+ima261) "
#        ELSE
#    	   LET l_sql = l_sql CLIPPED, " AND ima27 > ima262 "
#        END IF
#No.FUN-A20044 ---mark---end 
     ELSE
        #--->再補貨點
        LET l_sql = "SELECT '','', ",
                 " ima01, ima02, ima05, ima06, ",
		 "  ima08, ima07, ima37, ima25,",
           #      " ima26, ima261,ima262, ima38, 0 ,0 , ",    #No.FUN-670066
#                " ima26, ima261,ima262,0 , ima38,ima99,0 ,0,0 ",   #No.FUN-670066  #FUN-A20044
                 " ' ', ' ',' ',0 , ima38,ima99,0 ,0,0 ",           #No.FUN-A20044 
		 " ima09, ima10, ima11, ima12 ",
                 "  FROM ima_file",
                 " WHERE ",tm.wc CLIPPED, " AND imaacti = 'Y' "

#No.FUN-A20044 ---mark ---start 
#        #--->包含不可用數量
#         IF tm.c='Y' THEN
#            LET l_sql = l_sql CLIPPED,
#                        " AND ima37='0' AND  ima38 > (ima262+ima261) "
#        ELSE
#            LET l_sql = l_sql CLIPPED, " AND ima37='0' AND ima38 > ima262 "
#        END IF
#No.FUN-A20044 ---mark---end 

     END IF
     PREPARE r503_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r503_curs1 CURSOR FOR r503_prepare1
 
#    CALL cl_outnam('aimr503') RETURNING l_name         #No.FUN-750097
#    START REPORT r503_rep TO l_name           #No.FUN-750097
     LET g_pageno = 0
#No.FUN-670066-Begin
#No.FUN-750097-Begin
    IF tm.c='Y' THEN
       LET l_name1 = 'aimr503_1'
    ELSE 
       LET l_name1 = 'aimr503'
    END IF
       
#   IF tm.a='1' THEN
#      LET g_zaa[39].zaa06='N'
#      LET g_zaa[40].zaa06='N'
#      LET g_zaa[51].zaa06='Y'
#      LET g_zaa[52].zaa06='Y'
#   ELSE
#      LET g_zaa[39].zaa06='Y'
#      LET g_zaa[40].zaa06='Y'
#      LET g_zaa[51].zaa06='N'
#      LET g_zaa[52].zaa06='N'
#   END IF
#    IF tm.c='Y' THEN                                                                                                              
#       LET g_zaa[38].zaa06='N'
#       LET g_zaa[50].zaa06='N'                                                                                                     
#     ELSE                                                                                                                          
#       LET g_zaa[38].zaa06='Y'
#       LET g_zaa[50].zaa06='Y'                                                                                                     
#     END IF
#No.FUN-750097-End--
      CALL cl_prt_pos_len()
#No.FUN-670066-End
     FOREACH r503_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

#No.FUN-A20044 --start---
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
       IF tm.a = '1' THEN
          IF tm.c = 'Y' THEN
             IF sr.ima27 <= (l_unavl_stk + l_avl_stk) THEN
                CONTINUE FOREACH
             END IF  
          ELSE
             IF sr.ima27 <= l_avl_stk  THEN
                CONTINUE FOREACH
             END IF 
          END IF 
      ELSE
         IF tm.c= 'Y'THEN
            IF sr.ima37 != 0 OR sr.ima38 <= (l_unavl_stk + l_avl_stk) THEN
               CONTINUE FOREACH
            END IF 
         ELSE
            IF sr.ima37 != 0 OR sr.ima38 <= l_avl_stk THEN
               CONTINUE FOREACH
            END IF 
         END IF 
     END IF
     LET  sr.avl_stk_mpsmrp = l_avl_stk_mpsmrp 
     LET  sr.unavl_stk = l_unavl_stk
     LET  sr.avl_stk = l_avl_stk
#No.FUN-A20044 ---end---       

       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
       IF sr.ima09 IS NULL THEN LET sr.ima09 = ' ' END IF
       IF sr.ima10 IS NULL THEN LET sr.ima10 = ' ' END IF
       IF sr.ima11 IS NULL THEN LET sr.ima11 = ' ' END IF
       IF sr.ima12 IS NULL THEN LET sr.ima12 = ' ' END IF
#No.FUN-750097 ----start-------
      #FOR g_i = 1 TO 2
      #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
      #                                 LET l_orderA[g_i] =g_x[21]    #TQC-6A0088
      #        WHEN tm.s[g_i,g_i] = '2' LET l_orderA[g_i] =g_x[22]    #TQC-6A0088
      #             CASE
      #             WHEN tm.y = '0'  LET l_order[g_i] = sr.ima06
      #             WHEN tm.y = '1'  LET l_order[g_i] = sr.ima09
      #             WHEN tm.y = '2'  LET l_order[g_i] = sr.ima10
      #             WHEN tm.y = '3'  LET l_order[g_i] = sr.ima11
      #             WHEN tm.y = '4'  LET l_order[g_i] = sr.ima12
      #        END CASE
      #        OTHERWISE LET l_order[g_i] = '-'
      #                  LET l_orderA[g_i] =''         #TQC-6A0088
      #   END CASE
      #END FOR
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
#No.FUN-750097 ----end---------
#      IF sr.ima262 IS NULL THEN LET sr.ima262 = 0 END IF   #FUN-A20044
#      IF sr.ima261 IS NULL THEN LET sr.ima261 = 0 END IF   #FUN-A20044 
#      IF sr.ima26  IS NULL THEN LET sr.ima26 = 0 END IF    #FUN-A20044
       IF sr.ima27 IS NULL THEN LET sr.ima27 = 0 END IF
       IF sr.ima38 IS NULL THEN LET sr.ima38 = 0 END IF    #No.FUN-670066
#No.FUN-750097-------------start------------------
#      IF tm.c='Y' THEN  #含不可用數量
#         LET sr.total=sr.ima262+sr.ima261
#      ELSE
#         LET sr.total=sr.ima262
#      END IF
#No.FUN-750097-------------end--------------------
       #差異數量
#No.FUN-670066-Begin
#        LET sr.diff=sr.total-sr.ima27   
#No.FUN-750097-------------start------------------
   #    IF tm.a='1' THEN
   #        LET sr.diff=sr.total-sr.ima27
   #    ELSE
   #        LET sr.diff2=sr.total-sr.ima38
   #    END IF
#No.FUN-670066-End
#      OUTPUT TO REPORT r503_rep(sr.*)
       EXECUTE insert_prep USING
               sr.ima01,sr.ima02,sr.ima05,sr.ima06,sr.ima08,sr.ima07,sr.ima37,
#              sr.ima25,sr.ima26,sr.ima261,sr.ima262,sr.ima38,sr.ima27,sr.ima99,                #FUN-A20044
               sr.ima25,sr.avl_stk_mpsmrp,sr.unavl_stk,sr.avl_stk,sr.ima38,sr.ima27,sr.ima99,   #FUN-A20044
               sr.ima09,sr.ima10,sr.ima11,sr.ima12
       LET g_flag = 'Y'              #No.FUN-990081
     END FOREACH
 
#    FINISH REPORT r503_rep  
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                       
     LET g_str = ''                                                                                                                  
     #是否列印選擇條件                                                                                                               
     IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(tm.wc,'ima01')                                                                                           
             RETURNING tm.wc                                                                                                         
        LET g_str = tm.wc                                                                                                            
     END IF                                                                                                                          
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.c,";",tm.a,";",tm.y 
     CALL cl_prt_cs3('aimr503',l_name1,l_sql,g_str)
#No.FUN-750097-------------end--------------------
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
{REPORT r503_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,               #No.FUN-690026 VARCHAR(1)
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01  LIKE ima_file.ima01, #料件編號
                               ima02  LIKE ima_file.ima02, #品名規格
                               ima05  LIKE ima_file.ima05, #版本
                               ima06  LIKE ima_file.ima06, #分群碼
                               ima08  LIKE ima_file.ima08, #來源
                               ima07  LIKE ima_file.ima07, #ABC碼
                               ima37  LIKE ima_file.ima37, #補貨策略碼
                               ima25  LIKE ima_file.ima25, #庫存單位
#                              ima26  LIKE ima_file.ima26, #MPS/MRP可用量    #FUN-A20044
#                              ima261 LIKE ima_file.ima261,#庫存不可用量     #FUN-A20044
#                              ima262 LIKE ima_file.ima262,#庫存可用量       #FUN-A20044
                               avl_stk_mpsmrp LIKE type_file.num15_3,        #FUN-A20044
                               unavl_stk      LIKE type_file.num15_3,        #FUN-A20044
                               avl_stk        LIKE type_file.num15_3,        #FUN-A20044 
                               ima27  LIKE ima_file.ima27, #安全存量/再補貨點
                               ima38  LIKE ima_file.ima38, #No.FUN-670066
                               ima99  LIKE ima_file.ima99, #再補貨量    #No.FUN-670066
#                              total  LIKE ima_file.ima26, #庫存數量         #FUN-A20044
#                              diff   LIKE ima_file.ima26, #數量差異         #FUN-A20044
#                              diff2  LIKE ima_file.ima26, #No.FUN-670066    #FUN-A20044
                               total  LIKE type_file.num15_3,                #FUN-A20044
                               diff   LIKE type_file.num15_3,                #FUN-A20044
                               diff2  LIKE type_file.num15_3,                #FUN-A20044 
                               ima09  LIKE ima_file.ima09, #其他分群碼
                               ima10  LIKE ima_file.ima10, #其他分群碼
                               ima11  LIKE ima_file.ima11, #其他分群碼
                               ima12  LIKE ima_file.ima12  #其他分群碼
                         #     ima99  LIKE ima_file.ima99  #再補貨量     #No.FUN-670066
                        END RECORD ,
                l_col   LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2
  FORMAT
   PAGE HEADER
#No.FUN-670066-Begin
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
 #      IF g_towhom IS NULL OR g_towhom = ' '
 #         THEN PRINT '';
 #         ELSE PRINT 'TO:',g_towhom;
 #      END IF
 #      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
 #      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
        PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
        LET g_pageno = g_pageno + 1
        LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                         
        PRINT g_head CLIPPED,pageno_total
        PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
   #    PRINT ''   #TQC-6A0088
        PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
                       '-',l_orderA[2] CLIPPED   #TQC-6A0088 
#No.FUN-670066-End 
       PRINT g_dash[1,g_len]
   #   PRINT g_x[11] CLIPPED,g_x[12] CLIPPED;   #No.FUN-670066
       PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[51],g_x[52]    #No.FUN-670066
#No.FUN-670066-Begin
     #start TQC-5B0019
#      IF tm.c='Y' THEN
	#PRINT COLUMN 73,g_x[15] CLIPPED;
#   	 PRINT COLUMN 94,g_x[15] CLIPPED;   
	#LET l_col=91
#      	 LET l_col=112   
#      ELSE
	#LET l_col=73
#	 LET l_col=94 
#      END IF
     #end TQC-5B0019
#      IF tm.a='1' THEN
#         PRINT COLUMN l_col,g_x[16] CLIPPED  
#      ELSE
#        PRINT COLUMN l_col,g_x[17] CLIPPED  
#      END IF
#No.FUN-670066-End
 
     #start TQC-5B0019
     # PRINT g_x[13] CLIPPED,   #No.FUN-670066
       PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]     #No.FUN-670066
     #      COLUMN 55,g_x[14] CLIPPED;
     #       COLUMN 94,g_x[14] CLIPPED;  #No.FUN-670066
     #IF tm.c='Y' THEN
     #   PRINT COLUMN 73,g_x[18] CLIPPED
     #ELSE
     #   PRINT COLUMN 73,g_x[18] CLIPPED
     #END IF
   #   PRINT COLUMN 112,g_x[18] CLIPPED  #No.FUN-670066
     #PRINT '-------------------- -- -- --- ---- ----------------- ----------------- ';
   #   PRINT '---------------------------------------- -- -- --- ---- ------------------ ----------------- '; #No.FUN-670066
      PRINT g_dash1   #No.FUN-670066
     #end TQC-5B0019
#      IF tm.c='Y' THEN
#         PRINT '----------------- ----------------- -----------------'
#      ELSE
#         PRINT '----------------- -----------------'
#      END IF
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW 
#      PRINT COLUMN  1,sr.ima01, #No.FUN-670066
       PRINTX name=D1 COLUMN g_c[31],sr.ima01,
           #start TQC-5B0019
           #COLUMN 22,sr.ima05,
           #COLUMN 25,sr.ima08,
	   #COLUMN 29,sr.ima07,
           #COLUMN 32,sr.ima25,
           #COLUMN 37,sr.ima26  USING '------------&.&&&',    
           #COLUMN 55,sr.ima262 USING '------------&.&&&';  
        
#No.FUN-670066-Begin
#            COLUMN 42,sr.ima05,
#            COLUMN 45,sr.ima08,
#            COLUMN 48,sr.ima07,
#            COLUMN 53,sr.ima25,
#            COLUMN 58,sr.ima26  USING '------------&.&&&',
#            COLUMN 76,sr.ima262 USING '------------&.&&&';
            COLUMN g_c[32],sr.ima05,                                                                                                    
            COLUMN g_c[33],sr.ima08,                                                                                                    
            COLUMN g_c[34],sr.ima07,                                                                                                    
            COLUMN g_c[35],sr.ima25,                                                                                                    
#           COLUMN g_c[36],sr.ima26  USING '-------------&.&&&',         #FUN-A20044                                                                  
#           COLUMN g_c[37],sr.ima262 USING '-------------&.&&&',         #FUN-A20044
            COLUMN g_c[36],sr.avl_stk_mpsmrp  USING '-------------&.&&&',#FUN-A20044
            COLUMN g_c[37],sr.avl_stk USING '-------------&.&&&',        #FUN-A20044  
            COLUMN g_c[38], sr.total USING '-------------&.&&&',                                                     
            COLUMN g_c[39], sr.ima27 USING '-------------&.&&&',                                                     
            COLUMN g_c[40],sr.diff  USING '-------------&.&&&',
            COLUMN g_c[51],sr.ima38  USING '-------------&.&&&',
            COLUMN g_c[52],sr.diff2  USING '-------------&.&&&'
           #end TQC-5B0019
#No.FUN-670066---Begin    
#      IF tm.c='Y' THEN  
#        #PRINT COLUMN 73,   #TQC-5B0019 mark
#         PRINT COLUMN 94,   #TQC-5B0019  
#          PRINT COLUMN g_c[38], sr.total         USING '-------------&.&&&',' ', 
#                COLUMN g_c[39], sr.ima27         USING '-------------&.&&&',' ',
#                COLUMN g_c[40],sr.diff          USING '-------------&.&&&'
#      ELSE   
#        #PRINT COLUMN 73,   #TQC-5B0019 mark
#         PRINT COLUMN 94,   #TQC-5B0019 
 
#           PRINT COLUMN g_c[39],sr.ima27         USING '-------------&.&&&',' ', 
#                 COLUMN g_c[40],sr.diff          USING '-------------&.&&&'
#      END IF  
#No.FUN-670066---End
#      PRINT COLUMN  5,sr.ima02,  
       PRINTX name=D2 COLUMN g_c[41],sr.ima02,  
 
           #start TQC-5B0019
           #COLUMN 55,sr.ima261 USING '-------------&.&&&',
           #COLUMN 73,sr.ima99  USING '-------------&.&&&'
#            COLUMN  94,sr.ima261 USING '-------------&.&&&',  
#            COLUMN 112,sr.ima99  USING '-------------&.&&&'   
#            COLUMN g_c[48],sr.ima261 USING '-------------&.&&&',           #FUN-A20044
             COLUMN g_c[48],sr.unavl_stk USING '-------------&.&&&',        #FUN-A20044                                              
             COLUMN g_c[49],sr.ima99  USING '-------------&.&&&'    
           #end TQC-5B0019
#No.FUN-670066-End
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         PRINT g_dash[1,g_len]
       #TQC-630166
       #  IF tm.wc[001,120] > ' ' THEN			# for 132
 #	    PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
 #        IF tm.wc[121,240] > ' ' THEN
 #	    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
 #        IF tm.wc[241,300] > ' ' THEN
 #	    PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
   #No.FUN-670067---Begin
        IF l_last_sw = 'n' THEN 
           PRINT g_dash[1,g_len]
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
          ELSE SKIP 2 LINE
        END IF 
   #No.FUN-670066---End 
END REPORT}
 
#Patch....NO.TQC-610036 <> #
#No.FUN-990081 --Begin
FUNCTION r503_gen_pr()
DEFINE l_count         LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_i             LIKE type_file.num5
DEFINE l_flag          LIKE type_file.chr1
DEFINE li_result       LIKE type_file.chr1
DEFINE l_slip          LIKE smy_file.smyslip
#DEFINE l_total         LIKE ima_file.ima26        #FUN-A20044
#DEFINE l_diff          LIKE ima_file.ima26        #FUN-A20044
DEFINE l_total         LIKE type_file.num15_3      #FUN-A20044
DEFINE l_diff          LIKE type_file.num15_3      #FUN-A20044  
DEFINE l_sql           LIKE type_file.chr100
DEFINE l_ima44         LIKE ima_file.ima44
DEFINE l_ima48         LIKE ima_file.ima48
DEFINE l_ima49         LIKE ima_file.ima49
DEFINE l_ima491        LIKE ima_file.ima491
DEFINE l_ima913        LIKE ima_file.ima913
DEFINE l_ima914        LIKE ima_file.ima914
DEFINE l_pmk    RECORD LIKE pmk_file.*
DEFINE l_pml    RECORD LIKE pml_file.*
DEFINE sr         RECORD
       ima01           LIKE ima_file.ima01,
       ima02           LIKE ima_file.ima02,
       ima05           LIKE ima_file.ima05,
       ima06           LIKE ima_file.ima06,
       ima08           LIKE ima_file.ima08,
       ima07           LIKE ima_file.ima07,
       ima37           LIKE ima_file.ima37,
       ima25           LIKE ima_file.ima25,
#      ima26           LIKE ima_file.ima26,      #FUN-A20044
#      ima261          LIKE ima_file.ima261,     #FUN-A20044
#      ima262          LIKE ima_file.ima262,     #FUN-A20044
       avl_stk_mpsmrp  LIKE type_file.num15_3,   #FUN-A20044
       unavl_stk       LIKE type_file.num15_3,   #FUN-A20044
       avl_stk         LIKE type_file.num15_3,   #FUN-A20044
       ima38           LIKE ima_file.ima38,
       ima27           LIKE ima_file.ima27,
       ima99           LIKE ima_file.ima99,
       ima09           LIKE ima_file.ima09,
       ima10           LIKE ima_file.ima10,
       ima11           LIKE ima_file.ima11,
       ima12           LIKE ima_file.ima12
            END RECORD
   LET l_count=0
   LET l_i=0
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE r503_p1 FROM l_sql
   DECLARE r503_cs1 CURSOR FOR r503_p1
 
   BEGIN WORK
      LET g_success = 'Y'
      FOREACH r503_cs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        IF tm.c='Y' THEN  #含不可用數量
#          LET l_total=sr.ima262+sr.ima261           #FUN-A20044
           LET l_total = sr.avl_stk + sr.unavl_stk   #FUN-A20044
        ELSE
#          LET l_total=sr.ima262                     #FUN-A20044
           LET l_total = sr.avl_stk                  #FUN-A20044 
        END IF
        #差異數量
        IF tm.a='1' THEN
            LET l_diff=l_total-sr.ima27
        ELSE
            LET l_diff=l_total-sr.ima38
        END IF
        IF l_diff<0 THEN
           IF l_count=0 THEN
              OPEN WINDOW r5031 WITH FORM "aim/42f/aimr5031"
                  ATTRIBUTE (STYLE = g_win_style CLIPPED)
              CALL cl_ui_locale("aimr5031")
              INPUT l_slip FROM slip
              ON ACTION controlp
                 CASE
                    WHEN INFIELD(slip)
                       CALL q_smy(FALSE,TRUE,l_slip,'APM','1')
                          RETURNING l_slip
                       DISPLAY l_slip TO slip
                       NEXT FIELD slip
                       OTHERWISE EXIT CASE
                 END CASE
              AFTER FIELD slip
                 IF NOT cl_null(l_slip) THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt FROM smy_file
                     WHERE smyslip = l_slip AND smysys = 'apm' AND smykind = '1'
                    IF SQLCA.sqlcode OR cl_null(l_slip) THEN
                       LET l_cnt = 0
                    END IF
                    IF l_cnt = 0 THEN
                       CALL cl_err(l_slip,'aap-010',0)
                       NEXT FIELD slip
                    END IF
                 END IF
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION help
                 CALL cl_show_help()
              ON ACTION controlg
                 CALL cl_cmdask()
              END INPUT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 ROLLBACK WORK
                 CLOSE WINDOW r5031
                 RETURN
              END IF
              CLOSE WINDOW r5031
              CALL s_auto_assign_no('apm',l_slip,g_today,"1","pmk_file","pmk01","","","")
                 RETURNING li_result,l_pmk.pmk01
              LET l_pmk.pmk02 = 'REG'
              LET l_pmk.pmk03 = '0'
              LET l_pmk.pmk04 = g_today
              LET l_pmk.pmk12 = g_user
              LET l_pmk.pmk13 = g_grup
              LET l_pmk.pmk18 = 'N'
              LET l_pmk.pmk25 = '0'
              LET l_pmk.pmk27 = g_today
              LET l_pmk.pmk30 = 'Y'
              LET l_pmk.pmk40 = 0
              LET l_pmk.pmk401= 0
              LET l_pmk.pmk42 = 1
              LET l_pmk.pmk43 = 0
              LET l_pmk.pmk45 = 'Y'
              LET l_pmk.pmk46 = '1'
              SELECT smyapr,smysign INTO l_pmk.pmkmksg,l_pmk.pmksign
                FROM smy_file WHERE smyslip = l_slip
              IF SQLCA.sqlcode OR cl_null(l_pmk.pmkmksg) THEN
                 LET l_pmk.pmkmksg = 'N'
                 LET l_pmk.pmksign = NULL
              END IF
              LET l_pmk.pmkdays = 0
              LET l_pmk.pmksseq = 0
              LET l_pmk.pmkprno = 0
              CALL signm_count(l_pmk.pmksign) RETURNING l_pmk.pmksmax
              LET l_pmk.pmkacti ='Y'
              LET l_pmk.pmkuser = g_user
              LET l_pmk.pmkgrup = g_grup
              LET l_pmk.pmkdate = g_today
              LET l_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
              LET l_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
              #MOD-BA0051 -- begin --
              LET l_pmk.pmkplant = g_plant
              LET l_pmk.pmklegal = g_legal
              #MOD-BA0051 -- end --
              INSERT INTO pmk_file VALUES(l_pmk.*)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","pmk_file",l_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
                 LET g_success='N'
              END IF
              LET l_count=1
           END IF
           SELECT ima44,ima48,ima49,ima491,ima913,ima914
             INTO l_ima44,l_ima48,l_ima49,l_ima491,l_ima913,l_ima914
             FROM ima_file
            WHERE ima01=sr.ima01
           LET l_pml.pml01 = l_pmk.pmk01
           LET l_pml.pml011= l_pmk.pmk02
           LET l_pml.pml02 = l_i + 1
           LET l_pml.pml03 = ''
           LET l_pml.pml04 = sr.ima01
           LET l_pml.pml041= sr.ima02
           LET l_pml.pml05 = ''
           LET l_pml.pml06 = ''
           LET l_pml.pml07 = l_ima44
           LET l_pml.pml08 = sr.ima25
           CALL s_umfchk(l_pml.pml04,l_pml.pml07,l_pml.pml08)
             RETURNING l_flag,l_pml.pml09
           IF l_flag THEN
              LET l_pml.pml09=1
           END IF
           LET l_pml.pml10='N'
           LET l_pml.pml11='N'
           LET l_pml.pml12=''
           LET l_pml.pml121=''
           LET l_pml.pml122=''
           LET l_pml.pml123=''
           LET l_pml.pml13=0
           LET l_pml.pml14= g_sma.sma886[1,1]
           LET l_pml.pml15= g_sma.sma886[2,2]
           LET l_pml.pml16= l_pmk.pmk25
          #MOD-C10073 str-----
          #LET l_pml.pml20= -1*l_diff
          #LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)  #FUN-910088--add--
          IF sr.ima99>0 THEN
             LET l_pml.pml20= sr.ima99
          ELSE
             LET l_pml.pml20= -1*l_diff
          END IF
          #MOD-C10073 end-----
           LET l_pml.pml21=0
           LET l_pml.pml23='Y'
           LET l_pml.pml30=0
           LET l_pml.pml31=0
           LET l_pml.pml32=0
           CALL s_aday(g_today,1,l_ima48) RETURNING l_pml.pml33
           CALL s_aday(l_pml.pml33,1,l_ima49) RETURNING l_pml.pml34
           CALL s_aday(l_pml.pml34,1,l_ima491) RETURNING l_pml.pml35
           LET l_pml.pml91=' '
           LET l_pml.pml49=' ' 
#          LET l_pml.pml50=' '     #FUN-B70015  mark
           LET l_pml.pml50='1'     #FUN-B70015
           LET l_pml.pml54='1' 
           LET l_pml.pml56=' ' 
           LET l_pml.pml38='Y'
           LET l_pml.pml42='0'
           LET l_pml.pml43=0
           LET l_pml.pml431=0
           LET l_pml.pml86=l_pml.pml07
           LET l_pml.pml87=l_pml.pml20
           LET l_pml.pml190=l_ima913
           LET l_pml.pml191=l_ima914
           LET l_pml.pml192='N'
           LET l_pml.pml92 = 'N'  #FUN-9B0023 
           LET l_pml.pml930=s_costcenter(l_pmk.pmk13)
           #MOD-BA0051 -- begin --
           LET l_pml.pmlplant = g_plant
           LET l_pml.pmllegal = g_legal
           #MOD-BA0051 -- end --
           INSERT INTO pml_file VALUES(l_pml.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","pml_file",l_pml.pml01,l_pml.pml02,SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
           END IF
           LET l_i = l_i+1
        END IF
      END FOREACH
      IF g_success='Y' THEN
         CALL cl_err(l_pmk.pmk01,'axm-559',1)
         COMMIT WORK
      ELSE
         CALL cl_err('','axm-558',1)
         ROLLBACK WORK
      END IF
  END FUNCTION
#No.FUN-990081 --End

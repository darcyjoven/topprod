# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimr304.4gl
# Desc/riptions..: 倉庫調撥單列印(只列印一@階段調撥單)
# Input parameter:
# Return code....:
# Date & Author..: 93/03/12 By Keith
# Modify.........: No.FUN-4A0051 04/10/06 By Yuna 調撥單號, 料件編號,撥入倉庫, 撥出倉庫開窗
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-550108 05/05/25 By echo 新增報表備註
# Modify.........: No.FUN-560069 05/06/14 By jackie 雙單位報表格式修改
# Modify.........: No.FUN-580005 05/08/03 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.TQC-590047 05/10/05 By kim 列印沒有公司名稱
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5C0002 05/12/02 By Sarah 補印ima021
# Modify.........: No.MOD-610032 06/01/09 By pengu  1.表單撥出(出) /撥入(入) 顯示錯誤,請對調!!!
                             #                      2.轉入數量無法列印出資料
# Modify.........: No.FUN-660029 06/06/13 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0068 06/11/15 By Ray 報表抬頭部分轉為template型寫法
# Modify.........: No.FUN-710084 07/02/01 By Judy Crystal Report修改
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-860026 08/07/17 By baofei 增加子報表-列印批序號明細
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.TQC-C10034 12/01/12 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5   #No.FUN-690026 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
DEFINE tm       RECORD                         #Print condition RECORD
                wc       STRING,               #TQC-630166
                a        STRING,               #No.FUN-860026
                more     LIKE type_file.chr1   #Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                END RECORD
DEFINE g_i      LIKE type_file.num5            #count/index for any purpose  #No.FUN-690026 SMALLINT
#FUN-710084.....begin
DEFINE  g_sql   STRING
DEFINE  l_table STRING
DEFINE  g_str   STRING
#FUN-710084.....end
DEFINE  l_table1 STRING     #No.FUN-860026
#No.FUN-580005 --start--
DEFINE g_sma115 LIKE sma_file.sma115
DEFINE g_sma116 LIKE sma_file.sma116
#No.FUN-580005 --end--
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(12)     #No.FUN-860026
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#FUN-710084.....begin
   LET g_sql = "imm02.imm_file.imm02,",
               "imm01.imm_file.imm01,",
               "imn02.imn_file.imn02,",
               "imn03.imn_file.imn03,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,",
               "imn04.imn_file.imn04,",
               "imn05.imn_file.imn05,",
               "imn06.imn_file.imn06,",
               "imn09.imn_file.imn09,",
               "imn10.imn_file.imn10,",
               "imn11.imn_file.imn11,",
               "imn15.imn_file.imn15,",
               "imn16.imn_file.imn16,",
               "imn17.imn_file.imn17,",
               "imn20.imn_file.imn20,",
               "imn22.imn_file.imn22,",
               "imn23.imn_file.imn23,",
               "imn30.imn_file.imn30,",
               "imn31.imn_file.imn31,",
               "imn32.imn_file.imn32,",
               "imn33.imn_file.imn33,",
               "imn34.imn_file.imn34,",
               "imn35.imn_file.imn35,",
               "imn40.imn_file.imn40,",
               "imn41.imn_file.imn41,",
               "imn42.imn_file.imn42,",
               "imn43.imn_file.imn43,",
               "imn44.imn_file.imn44,",
               "imn45.imn_file.imn45,",
               "l_str1.type_file.chr1000,",
#               "l_str2.type_file.chr1000"     #No.FUN-860026    
               "l_str2.type_file.chr1000,",   #No.FUN-860026
               "flag.type_file.num5,",        #No.FUN-860026 
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
   LET l_table = cl_prt_temptable('aimr304',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                         
               "rvbs04.rvbs_file.rvbs04,",                                                                                         
               "rvbs06.rvbs_file.rvbs06,",                                                                                         
               "rvbs09.rvbs_file.rvbs09,",
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ima02.ima_file.ima02,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "imn09.imn_file.imn09,",                                                                                             
               "imn10.imn_file.imn10,",                                                                                             
               "imn20.imn_file.imn20,",
               "imn22.imn_file.imn22,",
               "img09_o.img_file.img09,",
               "img09_i.img_file.img09"
   LET l_table1 = cl_prt_temptable('aimr3041',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF               
#   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
#               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
#               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#   END IF 
#No.FUN-860026---end
#FUN-710084.....end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r304_tm(0,0)		# Input print condition
      ELSE CALL aimr304()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r304_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 10 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 18
   ELSE
       LET p_row = 6 LET p_col = 10
   END IF
 
   OPEN WINDOW r304_w AT p_row,p_col
        WITH FORM "aim/42f/aimr304"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 'N'       #No.FUN-860026
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imm01,imm02,imn03,imn04,imn15
      #--No.FUN-4A0051--------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
        CASE WHEN INFIELD(imm01) #調撥單號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
       	       LET g_qryparam.form = "q_imm104"
      	       CALL cl_create_qry() RETURNING g_qryparam.multiret
      	       DISPLAY g_qryparam.multiret TO imm01
      	       NEXT FIELD imm01
             WHEN INFIELD(imn03) #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imn03
               NEXT FIELD imn03
             WHEN INFIELD(imn04) #撥入倉庫
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_imd"
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imn04
               NEXT FIELD imn04
             WHEN INFIELD(imn15) #撥出倉庫
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_imd"
                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imn15
               NEXT FIELD imn15
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
      LET INT_FLAG = 0 CLOSE WINDOW r304_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more    #No.FUN-860026 add tm.a
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#No.FUN-860026---begin
      AFTER FIELD a    #列印批序號明細                                                                                              
         IF tm.a NOT MATCHES "[YN]" OR cl_null(tm.a)                                                                                
            THEN NEXT FIELD a                                                                                                       
         END IF  
#No.FUN-860026---end
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW r304_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr304'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr304','9031',1)
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
                         " '",tm.a CLIPPED,"'",                 #No.FUN-860026 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr304',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r304_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr304()
   ERROR ""
END WHILE
   CLOSE WINDOW r304_w
END FUNCTION
 
FUNCTION aimr304()
   DEFINE l_name	LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
#FUN-710084.....begin
        l_str1          LIKE type_file.chr1000,     
        l_str2          LIKE type_file.chr1000,    
        l_ima906        LIKE ima_file.ima906,     
        l_imn45         STRING,
        l_imn42         STRING,
        l_imn35         STRING,
        l_imn32         STRING,
#FUN-710084.....end
          l_sql         STRING,                #TQC-630166	
          l_za05	LIKE za_file.za05,     #No.FUN-690026 VARCHAR(40)
          sr            RECORD
                               imm02  LIKE imm_file.imm02,
                               imm01  LIKE imm_file.imm01,
                               imn02  LIKE imn_file.imn02,
                               imn03  LIKE imn_file.imn03,
                               ima02  LIKE ima_file.ima02,
                               ima021 LIKE ima_file.ima021,   #FUN-5C0002
                               ima05  LIKE ima_file.ima05,
                               ima08  LIKE ima_file.ima08,
                               imn04  LIKE imn_file.imn04,
                               imn05  LIKE imn_file.imn05,
                               imn06  LIKE imn_file.imn06,
                               imn09  LIKE imn_file.imn09,
                               imn10  LIKE imn_file.imn10,
                               imn11  LIKE imn_file.imn11,
                               imn15  LIKE imn_file.imn15,
                               imn16  LIKE imn_file.imn16,
                               imn17  LIKE imn_file.imn17,
                               imn20  LIKE imn_file.imn20,
                               imn22  LIKE imn_file.imn22,
                               imn23  LIKE imn_file.imn23,
#No.FUN-560069 --start--
                               imn30  LIKE imn_file.imn30,
                               imn31  LIKE imn_file.imn31,
                               imn32  LIKE imn_file.imn32,
                               imn33  LIKE imn_file.imn33,
                               imn34  LIKE imn_file.imn34,
                               imn35  LIKE imn_file.imn35,
                               imn40  LIKE imn_file.imn40,
                               imn41  LIKE imn_file.imn41,
                               imn42  LIKE imn_file.imn42,
                               imn43  LIKE imn_file.imn43,
                               imn44  LIKE imn_file.imn44,
                               imn45  LIKE imn_file.imn45
#No.FUN-560069 ---end--
                        END RECORD
     DEFINE l_i,l_cnt   LIKE type_file.num5      #No.FUN-580005  #No.FUN-690026 SMALLINT
     DEFINE l_zaa02     LIKE zaa_file.zaa02      #No.FUN-580005
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,
                                  rvbs09   LIKE  rvbs_file.rvbs09,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09_o     LIKE img_file.img09 
     DEFINE        l_img09_i     LIKE img_file.img09
     DEFINE        flag          LIKE type_file.num5
#No.FUN-860026---end
     DEFINE l_img_blob           LIKE type_file.blob   #No.TQC-C10034 add
     LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang #TQC-590047
     CALL cl_del_data(l_table)   #FUN-710084
     CALL cl_del_data(l_table1)  #No.FUN-860026
#No.FUN-860026---begin
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                         
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                                                                         
#               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"   #No.FUN-860026                                                                      
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?)"  #No.FUN-860026 #No.TQC-C10034 add 4?
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM           
   END IF
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"                                                                           
     PREPARE insert_prep1 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep1:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
        EXIT PROGRAM                                                                          
     END IF                                                                            
#No.FUN-860026---end
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND immuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND immgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND immgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
     #End:FUN-980030
 
    #LET l_sql = "SELECT imm02,imm01,imn02,imn03,ima02,ima05,ima08, ",          #FUN-5C0002 mark
     LET l_sql = "SELECT imm02,imm01,imn02,imn03,ima02,ima021,ima05,ima08, ",   #FUN-5C0002
                 " imn04,imn05,imn06,imn09,imn10,imn11,",
                 " imn15,imn16,imn17,imn20,imn22,imn23, ",
                 " imn30,imn31,imn32,imn33,imn34,imn35, ", #No.FUN-560069
                 " imn40,imn41,imn42,imn43,imn44,imn45 ",  #No.FUN-560069
                 " FROM imn_file,imm_file,OUTER ima_file ",
                 " WHERE imm01 = imn01 ",
                 "   AND imn_file.imn03 = ima_file.ima01 ",
                 "   AND imm10 = '1'  ",
                #"   AND imm03 != 'X' ", #mandy #FUN-660029
                 "   AND immconf!= 'X' ", #FUN-660029 
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY imm01,imm02,imn02 "
     PREPARE r304_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r304_cs1 CURSOR FOR r304_prepare1
 
#FUN-710084.....begin mark
  #   CALL cl_outnam('aimr304') RETURNING l_name
  #   #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
  #   IF g_sma115 = "Y" THEN
  #      LET g_zaa[42].zaa06 = "N"
# #      LET g_zaa[49].zaa06 = "N"
  #   ELSE
  #      LET g_zaa[42].zaa06 = "Y"
# #      LET g_zaa[49].zaa06 = "Y"
  #   END IF
  #   CALL cl_prt_pos_len()
  #   #No.FUN-580005 --end--
  #  
#FUN-710084.....end mark
     LET g_pageno = 0
     FOREACH r304_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#FUN-710084.....begin
       SELECT ima906 INTO l_ima906 FROM ima_file
                           WHERE ima01 = sr.imn03
       LET l_str1 = ""
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          IF NOT cl_null(sr.imn45) AND sr.imn45 <> 0 THEN
             CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
             LET l_str1 = l_imn45, sr.imn43 CLIPPED
          END IF
          IF NOT cl_null(sr.imn35) AND sr.imn35 <> 0 THEN
             CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
             LET l_str2 = l_imn35, sr.imn33 CLIPPED
          END IF
          IF l_ima906 = "2" THEN
             IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
                CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                LET l_str1 = l_imn42, sr.imn40 CLIPPED
             ELSE
                IF NOT cl_null(sr.imn42) AND sr.imn42 <> 0 THEN
                   CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                   LET l_str1 = l_str1 CLIPPED,',',l_imn42, sr.imn40 CLIPPED
                END IF
             END IF
             IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
                CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                LET l_str2 = l_imn32, sr.imn30 CLIPPED
             ELSE
                IF NOT cl_null(sr.imn32) AND sr.imn32 <> 0 THEN
                   CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                   LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
                END IF
             END IF
          END IF
       END IF
#No.FUN-860026---begin                         
    LET flag = 0                                                                                      
    SELECT img09 INTO l_img09_o  FROM img_file WHERE img01 = sr.imn03                                                               
               AND img02 = sr.imn04 AND img03 = sr.imn05                                                                            
               AND img04 = sr.imn06                                                                                                 
    SELECT img09 INTO l_img09_i  FROM img_file WHERE img01 = sr.imn03                                                               
               AND img02 = sr.imn15 AND img03 = sr.imn16                                                                            
               AND img04 = sr.imn17                                                                                                 
    DECLARE r920_d  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs09,rvbs021  FROM rvbs_file                                                               
                  WHERE rvbs01 = sr.imm01 AND rvbs02 = sr.imn02                                                                     
                  ORDER BY  rvbs04                                                                                                  
    FOREACH  r920_d INTO l_rvbs.*                                                                                                   
         LET flag = 1
         EXECUTE insert_prep1 USING  sr.imm01,sr.imn02,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs09,l_rvbs.rvbs021,                                      
                                     sr.ima02,sr.ima021,sr.imn09,sr.imn10,sr.imn20,                                                 
                                     sr.imn22,l_img09_o,l_img09_i                                                                   
                                                                                                                                    
    END FOREACH                                                                                                                     
#       EXECUTE insert_prep USING sr.*,l_str1,l_str2
       EXECUTE insert_prep USING sr.*,l_str1,l_str2,flag,"",l_img_blob,"N","" #No.TQC-C10034 add "",  l_img_blob,   "N",""
#No.FUN-860026---end
#       OUTPUT TO REPORT r304_rep(sr.*)
     END FOREACH
 
#     FINISH REPORT r304_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
#      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED   #No.FUN-860026
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED    #No.FUN-860026  
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
           CALL cl_wcchp(tm.wc,'imm01,imm02,imn03,imn04,imn15')
           RETURNING tm.wc
      LET g_str = tm.wc,";",g_zz05,";",tm.a   #No.FUN-860026
    # CALL cl_prt_cs3('aimr304',l_sql,g_str)   #TQC-730088
      LET g_cr_table = l_table                 #主報表的temp table名稱 #No.TQC-C10034 add
      LET g_cr_apr_key_f = "imm01"       #報表主鍵欄位名稱，用"|"隔開  #No.TQC-C10034 add
      CALL cl_prt_cs3('aimr304','aimr304',l_sql,g_str)
#FUN-710084.....end
END FUNCTION
 
#FUN-710084.....begin mark
#REPORT r304_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
#          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#          sr            RECORD
#                                  imm02  LIKE imm_file.imm02,
#                                  imm01  LIKE imm_file.imm01,
#                                  imn02  LIKE imn_file.imn02,
#                                  imn03  LIKE imn_file.imn03,
#                                  ima02  LIKE ima_file.ima02,
#                                  ima021 LIKE ima_file.ima021,   #FUN-5C0002
#                                  ima05  LIKE ima_file.ima05,
#                                  ima08  LIKE ima_file.ima08,
#                                  imn04  LIKE imn_file.imn04,
#                                  imn05  LIKE imn_file.imn05,
#                                  imn06  LIKE imn_file.imn06,
#                                  imn09  LIKE imn_file.imn09,
#                                  imn10  LIKE imn_file.imn10,
#                                  imn11  LIKE imn_file.imn11,
#                                  imn15  LIKE imn_file.imn15,
#                                  imn16  LIKE imn_file.imn16,
#                                  imn17  LIKE imn_file.imn17,
#                                  imn20  LIKE imn_file.imn20,
#                                  imn22  LIKE imn_file.imn22,
#                                  imn23  LIKE imn_file.imn23,
##No.FUN-560069 --start--
#                                  imn30  LIKE imn_file.imn30,
#                                  imn31  LIKE imn_file.imn31,
#                                  imn32  LIKE imn_file.imn32,
#                                  imn33  LIKE imn_file.imn33,
#                                  imn34  LIKE imn_file.imn34,
#                                  imn35  LIKE imn_file.imn35,
#                                  imn40  LIKE imn_file.imn40,
#                                  imn41  LIKE imn_file.imn41,
#                                  imn42  LIKE imn_file.imn42,
#                                  imn43  LIKE imn_file.imn43,
#                                  imn44  LIKE imn_file.imn44,
#                                  imn45  LIKE imn_file.imn45
##No.FUN-560069 ---end--
#                        END RECORD
#   DEFINE l_str1        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
#          l_imn45       STRING,    #No.FUN-580005
#          l_imn42       STRING     #No.FUN-580005
#   DEFINE l_str2        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
#          l_imn35       STRING,    #No.FUN-580005
#          l_imn32       STRING     #No.FUN-580005
#   DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 7
#         PAGE LENGTH g_page_line
#  ORDER BY sr.imm02,sr.imm01,sr.imn02
#  FORMAT
#   PAGE HEADER
##No.TQC-6B0068 --begin
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##No.TQC-6B0068 --end
#      PRINT g_dash[1,g_len]
#      PRINT g_x[11] CLIPPED,sr.imm02
#      PRINT g_x[12] CLIPPED,sr.imm01
#      PRINT g_dash[1,g_len]
##No.FUN-560069 --start--
#     #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]           #FUN-5C0002 mark
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[43],g_x[34],g_x[35]   #FUN-5C0002
#      PRINTX name=H2 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
##No.FUN-560069 --end--
#      PRINT g_dash1
##No.FUN-560069 ---end--
# 
#   LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.imm01
#      IF (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
##No.FUN-560069 ---start--
#      SELECT ima906 INTO l_ima906 FROM ima_file
#                          WHERE ima01 = sr.imn03
#      LET l_str1 = ""
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         IF NOT cl_null(sr.imn45) AND sr.imn45 <> 0 THEN
#            CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
#            LET l_str1 = l_imn45, sr.imn43 CLIPPED
#         END IF
#         IF NOT cl_null(sr.imn35) AND sr.imn35 <> 0 THEN
#            CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
#            LET l_str2 = l_imn35, sr.imn33 CLIPPED
#         END IF
#         IF l_ima906 = "2" THEN
#            IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
#               CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
#               LET l_str1 = l_imn42, sr.imn40 CLIPPED
#            ELSE
#               IF NOT cl_null(sr.imn42) AND sr.imn42 <> 0 THEN
#                  CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
#                  LET l_str1 = l_str1 CLIPPED,',',l_imn42, sr.imn40 CLIPPED
#               END IF
#            END IF
#            IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
#               CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
#               LET l_str2 = l_imn32, sr.imn30 CLIPPED
#            ELSE
#               IF NOT cl_null(sr.imn32) AND sr.imn32 <> 0 THEN
#                  CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
#                  LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
#               END IF
#            END IF
#         END IF
#      END IF
#      PRINTX name=D1 COLUMN g_c[31], sr.imn02 USING '###&',
#                     COLUMN g_c[32], sr.imn03 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,
#                     COLUMN g_c[33], sr.ima02 CLIPPED,
#                     COLUMN g_c[43], sr.ima021 CLIPPED,   #FUN-5C0002
#                     COLUMN g_c[34], sr.ima05 CLIPPED,
#                     COLUMN g_c[35], sr.ima08 CLIPPED
#      PRINTX name=D2 COLUMN g_c[36], g_x[25] CLIPPED,       #No.MOD-610032 modify
#                     COLUMN g_c[37], sr.imn04 CLIPPED,
#                     COLUMN g_c[38], sr.imn05 CLIPPED,
#                     COLUMN g_c[39], sr.imn06 CLIPPED,
#                     COLUMN g_c[40], sr.imn09 CLIPPED,
#                     COLUMN g_c[41], cl_numfor(sr.imn10,41,3),
#                     COLUMN g_c[42], l_str2 CLIPPED
#      IF g_line_seq = 1 THEN             #No.FUN-580005 為了拉成一@行時正確顯示
#         PRINTX name=D1
#      END IF
#      PRINTX name=D2 COLUMN g_c[36], g_x[24] CLIPPED,        #No.MOD-610032 modify
#                     COLUMN g_c[37], sr.imn15 CLIPPED,
#                     COLUMN g_c[38], sr.imn16 CLIPPED,
#                     COLUMN g_c[39], sr.imn17 CLIPPED,
#                     COLUMN g_c[40], sr.imn20 CLIPPED,
#                     COLUMN g_c[41], cl_numfor(sr.imn22,41,3),   #No.MOD-610032 modify
#                     COLUMN g_c[42], l_str1 CLIPPED
##No.FUN-560069 ---end--
#
#ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN
#              PRINT g_dash[1,g_len]
#       #TQC-630166
#       #       IF tm.wc[001,070] > ' ' THEN			# for 80
# #	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
# #             IF tm.wc[071,140] > ' ' THEN
# # 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
# #             IF tm.wc[141,210] > ' ' THEN
# # 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
# #             IF tm.wc[211,280] > ' ' THEN
# # 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#       CALL cl_prt_pos_wc(tm.wc)
#       #END TQC-630166
#
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-10), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#    IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED
#        ELSE SKIP 2 LINES
#     END IF
### FUN-550108
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[26]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[26]
#             PRINT g_memo
#      END IF
### END FUN-550108
#
#END REPORT
#FUN-710084.....end mark
#Patch....NO.TQC-610036 <> #
 

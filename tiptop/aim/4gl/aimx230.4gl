# Prog. Version..: '5.30.07-13.05.30(00004)'     #
#
# Pattern name...: aimx230.4gl
# Descriptions...: 庫存進出日報表  
# Input parameter: 
# Return code....: 
# Date & Author..: 93/05/03 By Apple
# Modify ........: No.MOD-480134 04/08/12 By Nicola 輸入順序錯誤
# Modify.........: No.FUN-4B0001 04/11/03 By Smapmin 料件編號開窗
# Modify.........: No.FUN-510017 05/01/31 By Mandy 報表轉XML
# Modify.........: No.MOD-530790 05/04/07 By wujie sr2.no欄位放寬，項次右對齊
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.TQC-5B0142 05/11/16 By Rosayu 單據編號備註顯示未完全
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-650076 06/05/17 By Claire 將status='4'的處理取消
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-780012 07/08/16 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.MOD-890183 08/09/18 By claire 批號應以等號做判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70178 10/07/23 By Sarah 當tlf13='axmt620'時,再判斷是否為3.出至境外倉,若是的話需再依出入庫碼判斷應列為出庫或入庫
# Modify.........: No.FUN-A90024 10/12/01 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No:MOD-B10182 11/01/24 By sabrina atmt260單身為出庫，atmt261單身為入庫
# Modify.........: No:MOD-C90023 12/09/21 By Elise 修正MOD-A70178判斷條件
# Modify.........: No:FUN-CB0004 12/11/02 By dongsz CR轉XtraGrid報表 
# Modify.........: No.FUN-D30070 13/03/21 By yangtt 去除畫面檔上小計欄位，并去除4gl中grup_sum_field
# Modify.........: No.FUN-D40062 13/04/17 By chenying chr20欄位定義不夠長，導致此欄位顯示不全
# Modify.........: No:FUN-D40129 13/05/07 By yangtt ima06,ima08,stock,ware增開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm            RECORD                       # Print condition RECORD
                     wc       STRING,             # Where Condition  #TQC-630166
                     wc2      STRING,             # Where Condition  #TQC-630166
                     stock    LIKE img_file.img02,
                     ware     LIKE img_file.img03,
                     lot      LIKE img_file.img04,
                     tlf06_b  LIKE tlf_file.tlf06,    #No.FUN-690026 DATE
                     tlf06_e  LIKE tlf_file.tlf06,    #No.FUN-690026 DATE
                     tlf07_b  LIKE tlf_file.tlf07,    #No.FUN-690026 DATE
                     tlf07_e  LIKE tlf_file.tlf07,    #No.FUN-690026 DATE
                     a        LIKE type_file.chr1,    #print date         #No.FUN-690026 VARCHAR(1)
                     s        LIKE type_file.chr3,    #Order by sequence  #No.FUN-690026 VARCHAR(3)
                     t        LIKE type_file.chr3,    #Eject sw           #No.FUN-690026 VARCHAR(3)
                    #u        LIKE type_file.chr3,    #Group total sw     #No.FUN-690026 VARCHAR(3) #FUN-D30070 mark
                     b        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                     tbname   LIKE gat_file.gat01,    #table name         #No.FUN-690026 VARCHAR(10)       
                     more     LIKE type_file.chr1     #special condition  #No.FUN-690026 VARCHAR(1)
                     END RECORD,
       g_code        LIKE type_file.num5,  #No.FUN-690026 SMALLINT
       g_program     LIKE zz_file.zz01,    #No.FUN-690026 VARCHAR(10)
       g_str         LIKE ze_file.ze03,    #No.FUN-690026 VARCHAR(30)
       g_str1,g_str2 LIKE ze_file.ze03,    #No.FUN-690026 VARCHAR(10)
       g_str3,g_str4 LIKE ze_file.ze03,    #No.FUN-690026 VARCHAR(10)
       g_order       LIKE ima_file.ima01,  #No.FUN-690026 VARCHAR(40)
       g_amt         LIKE zaa_file.zaa08,  #No.FUN-690026 VARCHAR(20)
       g_date        LIKE zaa_file.zaa08   #No.FUN-690026 VARCHAR(40)
DEFINE g_gettlf      DYNAMIC ARRAY OF RECORD   
                     tbname   LIKE gat_file.gat01,   # table name        #No.FUN-690026 VARCHAR(10)
                     bdate    LIKE type_file.dat,    #Transaction begin date  #No.FUN-690026 DATE
                     edate    LIKE type_file.dat,    #Transaction end   date  #No.FUN-690026 DATE
                     p_no     LIKE type_file.num10   #Transaction count  #No.FUN-690026 INTEGER
                     END RECORD
DEFINE g_i           LIKE type_file.num5             #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_sql         STRING                          #No.FUN-780012
DEFINE l_str         STRING                          #No.FUN-780012
DEFINE l_table       STRING                          #No.FUN-780012
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-780012 --start--
  #LET g_sql="chr20.type_file.chr20,tlf07.tlf_file.tlf07,",  #FUN-D40062                     
   LET g_sql="chr20.type_file.chr50,tlf07.tlf_file.tlf07,",  #FUN-D40062                    
             "tlf021.tlf_file.tlf021,tlf022.tlf_file.tlf022,",                  
             "tlf01.tlf_file.tlf01,tlf023.tlf_file.tlf023,",                    
             "ima02.ima_file.ima02,ima021.ima_file.ima021,",                    
             "tlf11.tlf_file.tlf11,ze03.ze_file.ze03,",
            #"tlf10.tlf_file.tlf10,tlf62.tlf_file.tlf62,",           #FUN-CB0004 mark
             "tlf10.tlf_file.tlf10,tlf10_1.tlf_file.tlf10,tlf62.tlf_file.tlf62,",   #FUN-CB0004  add           
             "tlf026.tlf_file.tlf026,tlf026_1.tlf_file.tlf026,",                
             "tlf026_2.tlf_file.tlf026,tlf026_3.tlf_file.tlf026,",
             "tlf13.tlf_file.tlf13,chr1.type_file.chr1,l_pot.type_file.num5,",  #FUN-CB0004  add l_pot.type_file.num5
             "imd02.imd_file.imd02,ime03.ime_file.ime03"                        #FUN-CB0004 add   
   LET l_table = cl_prt_temptable('aimx230',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     #FUN-CB0004  add 4?
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #No.FUN-780012 --end--
 
  #LET g_program= ARG_VAL(1)   #TQC-610072
  #LET g_code   = ARG_VAL(2)   #TQC-610072    	
   LET g_pdate  = ARG_VAL(1)       		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.wc2   = ARG_VAL(8)
   LET tm.stock = ARG_VAL(9)
   LET tm.ware  = ARG_VAL(10)
   LET tm.lot   = ARG_VAL(11)
   LET tm.tlf06_b = ARG_VAL(12)
   LET tm.tlf06_e = ARG_VAL(13)
   LET tm.tlf07_b = ARG_VAL(14)
   LET tm.tlf07_e = ARG_VAL(15)
   LET tm.a     = ARG_VAL(16)
   LET tm.s     = ARG_VAL(17)
   LET tm.t     = ARG_VAL(18)
  #LET tm.u     = ARG_VAL(19)  #FUN-D30070 mark
  #FUN-D30070----mod---str--
  #LET tm.tbname= ARG_VAL(20)
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(21)
  #LET g_rep_clas = ARG_VAL(22)
  #LET g_template = ARG_VAL(23)
  #LET g_rpt_name = ARG_VAL(24)  #No.FUN-7C0078
  ##No.FUN-570264 ---end---
   LET tm.tbname= ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
  #FUN-D30070----mod---str--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL x230_tm(0,0)	        	# Input print condition
      ELSE CALL x230()			            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION x230_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_j,l_n       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 17 
   ELSE
       LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW x230_w AT p_row,p_col
        WITH FORM "aim/42f/aimx230" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a  ='1'
   LET tm.tbname='tlf_file'
   LET tm.s  = '123'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   CALL s_refer(g_code) RETURNING g_str1,g_str2,g_str3,g_str4
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
#  IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF  #FUN-D30070 mark
#  IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF  #FUN-D30070 mark
#  IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF  #FUN-D30070 mark
WHILE TRUE
   CONSTRUCT tm.wc ON tlf13,tlf01,ima08,ima06
                FROM tlf13,tlf01,ima08,ima06
      ON ACTION CONTROLP    #FUN-4B0001
         CASE WHEN INFIELD(tlf01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tlf"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf01
              NEXT FIELD tlf01
            #FUN-D40129---add---str---
            WHEN INFIELD(ima06)      #分群碼
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            WHEN INFIELD(ima08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima7"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima08
               NEXT FIELD ima08
            #FUN-D40129---add---end---
         END CASE
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
  
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 CLOSE WINDOW x230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
{
   CONSTRUCT tm.wc2 ON ima08 FROM ima08
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
      LET INT_FLAG = 0 CLOSE WINDOW x230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
         
   END IF
   LET tm.wc = tm.wc clipped,' AND ',tm.wc2 clipped 
}
#--->怕只怕 user 再重新輸入條件,因此....
   FOR l_j=1  TO 70
       initialize g_gettlf[l_j].* TO NULL
   END FOR
 
#UI
   INPUT BY NAME tm.stock,tm.ware,tm.lot,
                 tm.tlf06_b,tm.tlf06_e,tm.tlf07_b,tm.tlf07_e,
                #tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,  #FUN-D30070 mark
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,  #FUN-D30070 mark 
                  tm.a,tm.tbname,tm.more    #No.MOD-480134
                 WITHOUT DEFAULTS 
 
      AFTER FIELD tlf06_e
         IF tm.tlf06_b IS NOT NULL AND tm.tlf06_e IS NOT NULL 
         THEN IF tm.tlf06_e < tm.tlf06_b THEN 
                 NEXT FIELD tlf06_b
              END IF  
         END IF
      AFTER FIELD tlf07_e
         IF tm.tlf07_b IS NOT NULL AND tm.tlf07_e IS NOT NULL 
         THEN IF tm.tlf07_e < tm.tlf07_b THEN 
                 NEXT FIELD tlf07_b
              END IF
         END IF  
      AFTER FIELD a       #print date condition
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES '[12]'
            THEN NEXT FIELD a
         END IF
      AFTER FIELD tbname  #file name
         IF cl_null(tm.tbname) THEN NEXT FIELD tbname END IF
          #---FUN-A90024---start-----
          #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
          #目前統一用sch_file紀錄TIPTOP資料結構
          #SELECT COUNT(distinct table_name) INTO l_n FROM all_tables WHERE table_name=trim(upper(tm.tbname))
          SELECT COUNT(distinct sch01) INTO l_n FROM sch_file WHERE sch01 = tm.tbname
          #---FUN-A90024---end-------
          IF l_n <= 0 
             THEN CALL cl_err(tm.tbname,'mfg9180',0)
                 NEXT FIELD tbname
          END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
       AFTER INPUT
          IF tm.tlf06_b > tm.tlf06_e THEN NEXT FIELD tlf06_b END IF
          IF tm.tlf07_b > tm.tlf07_e THEN NEXT FIELD tlf07_b END IF
         #NO:7515 UI
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
        #LET tm.u = tm2.u1,tm2.u2,tm2.u3  #FUN-D30070 mark
         #NO:7515(END)  
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################

      #FUN-D40129---add---str---
      ON ACTION CONTROLP   
         CASE     
            WHEN INFIELD(stock)      #分群碼
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tlf021"
               LET g_qryparam.default1 = tm.stock 
               CALL cl_create_qry() RETURNING tm.stock
               DISPLAY tm.stock TO stock
               NEXT FIELD stock
            WHEN INFIELD(ware)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tlf022"
               LET g_qryparam.default1 = tm.ware 
               CALL cl_create_qry() RETURNING tm.ware
               DISPLAY tm.ware TO ware
               NEXT FIELD ware 
         END CASE
     #FUN-D40129---add---end---
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
     #No.B058 010326 by plum
     #ON ACTION CONTROLR CALL s_gettlf(0,0)  
      ON ACTION data_source 
         CALL s_gettlf(0,0)  
 
     #No.B058..end
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
      LET INT_FLAG = 0 CLOSE WINDOW x230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimx230'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimx230','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        #" '",g_code    CLIPPED,"'",  #TQC-610072 
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",
                         " '",tm.stock   CLIPPED,"'",
                         " '",tm.ware    CLIPPED,"'",
                         " '",tm.lot     CLIPPED,"'",
                         " '",tm.tlf06_b CLIPPED,"'",
                         " '",tm.tlf06_e CLIPPED,"'",
                         " '",tm.tlf07_b CLIPPED,"'",
                         " '",tm.tlf07_e CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                       # " '",tm.u CLIPPED,"'",  #FUN-D30070 mark
                         " '",tm.tbname CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimx230',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW x230_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL x230()
   ERROR ""
END WHILE
   CLOSE WINDOW x230_w
END FUNCTION
 
FUNCTION x230()
   DEFINE l_name     LIKE type_file.chr20,            #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#         l_time     LIKE type_file.chr8              #No.FUN-6A0074
          l_sql      STRING,                          #TQC-630166
          l_za05     LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr         RECORD        
                      tlf    RECORD LIKE tlf_file.*,     
                      ima02  LIKE ima_file.ima02,
                      ima021 LIKE ima_file.ima021     #FUN-510017
                     END RECORD,
          sr2        RECORD       
                      order1   LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                      order2   LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                      order3   LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                      #no      LIKE tlf_file.tlf026,  #單據編號  #No.FUN-550029 #TQC-5B0142 mark
                     #no       LIKE type_file.chr20,  #單據編號  #TQC-5B0142 add #No.FUN-690026 VARCHAR(20)  #FUN-D40062
                      no       LIKE type_file.chr50,  #單據編號  #TQC-5B0142 add #No.FUN-690026 VARCHAR(20)  #FUN-D40062
                      item     LIKE tlf_file.tlf027,  #項次     
                      date     LIKE tlf_file.tlf07,   #日期
                      stock    LIKE tlf_file.tlf021,  #倉庫編號
                      ware     LIKE tlf_file.tlf022,  #儲位
                      location LIKE tlf_file.tlf023,  #批號
                      tlf01    LIKE tlf_file.tlf01,   #料件編號
                      ima02    LIKE ima_file.ima02,   #品名規格
                      ima021   LIKE ima_file.ima021,  #FUN-510017
                      tlf11    LIKE tlf_file.tlf11,   #異動單位
                      tlf10    LIKE tlf_file.tlf10,   #異動數量
                      tlf10_1  LIKE tlf_file.tlf10,   #異動數量    #FUN-CB0004 add
                      tlf02    LIKE tlf_file.tlf02,   #來源狀況 
                      tlf03    LIKE tlf_file.tlf03,   #目的狀況
                      tlf13    LIKE tlf_file.tlf13,   #異動命令
                      tlf62    LIKE tlf_file.tlf62,   #NO
                      tlf08    LIKE tlf_file.tlf08,   #異動時間　  
                      status   LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
                      str      LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(14)
                      refer1   LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                      refer2   LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                      refer3   LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                      refer4   LIKE tlf_file.tlf026,   #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                      l_pot    LIKE type_file.num5    #FUN-CB0004 add
                     END RECORD, 
          l_code     LIKE type_file.chr1,             #No.FUN-690026 VARCHAR(1)
          l_i,l_item LIKE type_file.num5,             #No.FUN-690026 SMALLINT
          l_oga00    LIKE oga_file.oga00,             #MOD-A70178 add
          l_imd02    LIKE imd_file.imd02,             #FUN-CB0004 add
          l_ime03    LIKE ime_file.ime03              #FUN-CB0004 add 

     CALL cl_del_data(l_table)                            #No.FUN-780012
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-780012 --start-- mark
#     IF tm.a  = '1' THEN 
#          LET g_date = g_x[11] clipped,tm.tlf06_b,'-',tm.tlf06_e
#     ELSE LET g_date = g_x[12] clipped,tm.tlf07_b,'-',tm.tlf07_e
#     END IF
#     LET g_order = ' '
#     LET g_amt   = ' '
#     FOR g_i = 1 TO 3
#       CASE WHEN tm.s[g_i,g_i] = '1' 
#                LET g_order = g_order clipped,' ',g_x[19]
#            WHEN tm.s[g_i,g_i] = '2' 
#                LET g_order = g_order clipped,' ',g_x[20]
#            WHEN tm.s[g_i,g_i] = '3' 
#                LET g_order = g_order clipped,' ',g_x[21]
#            WHEN tm.s[g_i,g_i] = '4' 
#                LET g_order = g_order clipped,' ',g_x[22]
#            WHEN tm.s[g_i,g_i] = '5' 
#                LET g_order = g_order clipped,' ',g_x[23]
#            WHEN tm.s[g_i,g_i] = '6' 
#                LET g_order = g_order clipped,' ',g_x[24]
#            OTHERWISE LET g_order = g_order clipped
#       END CASE
#    END FOR
#     FOR g_i = 1 TO 3
#       CASE WHEN tm.u[g_i,g_i] = '1' 
#                LET g_amt  = g_x[19]
#            WHEN tm.s[g_i,g_i] = '2' 
#                LET g_amt  = g_x[20]
#            WHEN tm.u[g_i,g_i] = '3' 
#                LET g_amt  = g_x[21]
#            WHEN tm.u[g_i,g_i] = '4' 
#                LET g_amt  = g_x[22]
#            WHEN tm.u[g_i,g_i] = '5' 
#                LET g_amt  = g_x[23]
#            WHEN tm.u[g_i,g_i] = '6' 
#                LET g_amt  = g_x[24]
#            OTHERWISE LET g_amt = ''
#       END CASE
#    END FOR
#     CALL cl_outnam('aimx230') RETURNING l_name
#     START REPORT x230_rep TO l_name
#     LET g_pageno = 0
     #No.FUN-780012 --end--
 
#*****************************************************************************#
#------->因tlf_file 已做分割處理,因此資料來源不只是從tlf_file來<--------------#
#*****************************************************************************#
 
     IF g_gettlf[1].tbname IS NULL OR g_gettlf[1].tbname=' '
        THEN LET g_gettlf[1].tbname='tlf_file'
     END IF
     IF tm.tlf06_b IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf06 >=","'",tm.tlf06_b,"'"
     END IF
     IF tm.tlf06_e IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf06 <=","'",tm.tlf06_e,"'"
     END IF
     IF tm.tlf07_b IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf07 >=","'",tm.tlf07_b,"'"
     END IF
     IF tm.tlf07_e IS NOT NULL THEN 
        LET tm.wc = tm.wc clipped," AND tlf07 <=","'",tm.tlf07_e,"'"
     END IF
  
   FOR  l_i=1  TO 70      #最多70期
     IF g_gettlf[l_i].tbname IS NULL OR g_gettlf[l_i].tbname=' '
        THEN EXIT FOR
     END IF
 
     IF g_sma.sma12 MATCHES '[nN]'  #single warehouse
       THEN LET l_sql=
                  " SELECT ",g_gettlf[l_i].tbname CLIPPED,
                  ".*,ima02,ima021 ", #FUN-510017
                  " FROM ",g_gettlf[l_i].tbname,",ima_file",
                  " WHERE tlf01=ima01 ", 
                  "   AND ",tm.wc CLIPPED
 
        ELSE                        #multi warehouse
        #*********************************************************************#
        #    multi warehous                                                   #
        #*********************************************************************#
        LET l_sql = 
                 " SELECT ",g_gettlf[l_i].tbname CLIPPED,".*,",
                 " ima02,ima021", #FUn-510017
                 " FROM ",g_gettlf[l_i].tbname,",ima_file ",
                 " WHERE tlf01=ima01 ", 
                 "   AND ",tm.wc CLIPPED
 
        LET l_sql=l_sql clipped,
                  "   AND ",tm.wc CLIPPED , 
                  "   AND (tlf02>49 AND tlf02<60)"   #僅與庫存有關
 
        IF tm.stock IS NOT NULL AND tm.stock != ' '
        THEN  LET l_sql=l_sql CLIPPED," AND tlf021 ='",tm.stock,"'"
        END IF
        IF tm.ware  IS NOT NULL AND tm.ware  != ' '
        THEN  LET l_sql=l_sql CLIPPED," AND tlf022 ='",tm.ware,"'"
        END IF
        IF tm.lot   IS NOT NULL AND tm.lot   != ' '
        THEN  LET l_sql=l_sql CLIPPED," AND tlf023 ='",tm.lot,"'"   #MOD-890183 
       #THEN  LET l_sql=l_sql CLIPPED," AND tlf023 >='",tm.lot,"'"  #MOD-890183 mark
        END IF
 
        LET l_sql=l_sql clipped," UNION  ", 
                   " SELECT ",g_gettlf[l_i].tbname CLIPPED,".*,",
                   " ima02,ima021", #FUN-510017
                   " FROM ",g_gettlf[l_i].tbname,",ima_file ",
                   " WHERE tlf01=ima01 ", 
                   "   AND ",tm.wc CLIPPED 
 
        LET l_sql=l_sql clipped,
                  "   AND ",tm.wc CLIPPED , 
                  "   AND (tlf03>49 AND tlf03<60)"   #僅與庫存有關
 
        IF tm.stock IS NOT NULL AND tm.stock != ' '
        THEN  LET l_sql=l_sql CLIPPED," AND tlf031 ='",tm.stock,"'"
        END IF
        IF tm.ware  IS NOT NULL AND tm.ware  != ' '
        THEN  LET l_sql=l_sql CLIPPED," AND tlf032 ='",tm.ware,"'"
        END IF
        IF tm.lot   IS NOT NULL AND tm.lot   != ' '
        THEN  LET l_sql=l_sql CLIPPED," AND tlf033 ='",tm.lot,"'"   #MOD-890183
       #THEN  LET l_sql=l_sql CLIPPED," AND tlf033 >='",tm.lot,"'"  #MOD-890183 mark
        END IF
    END IF
 
     PREPARE x230_prepare1 FROM l_sql 
     IF SQLCA.sqlcode != 0 
         THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
              EXIT PROGRAM 
     END IF
     DECLARE x230_curs1 CURSOR FOR x230_prepare1
 
     FOREACH x230_curs1 INTO sr.* 
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       LET sr2.tlf11 = sr.tlf.tlf11      #異動單位
       LET sr2.tlf10 = sr.tlf.tlf10      #異動數量
       LET sr2.ima02 = sr.ima02          #品名規格
       LET sr2.ima021= sr.ima021         #品名規格 #FUN-510017
       LET sr2.tlf01 = sr.tlf.tlf01      #料號
       LET sr2.tlf02 = sr.tlf.tlf02      #來源狀況
       LET sr2.tlf03 = sr.tlf.tlf03      #目的狀況
       LET sr2.tlf13 = sr.tlf.tlf13      #異動命令
       LET sr2.tlf62 = sr.tlf.tlf62      #參考單號
 
       IF tm.a = '1' 
       THEN LET sr2.date = sr.tlf.tlf06    #單號日期
       ELSE LET sr2.date = sr.tlf.tlf07    #產生日期
       END IF
 
       CALL s_command(sr2.tlf13) RETURNING sr2.status,sr2.str        
       LET l_code='Y'
      #MOD-650076-add-begin
       #為調撥時,依出入庫碼判斷應列為出庫或入庫
        IF sr2.status = '4' THEN 
           CASE sr.tlf.tlf907
                WHEN '-1'
                    LET sr2.status = '1'   #出庫 
                WHEN '1'
                    LET sr2.status = '2'   #入庫 
           END CASE
        END IF
      #MOD-650076-add-end
      #str MOD-A70178 add
       #當tlf13='axmt620'時,再判斷是否為3.出至境外倉,若是的話需再依出入庫碼判斷應列為出庫或入庫
       IF sr2.tlf13 = 'axmt620' THEN
          LET l_oga00=''
          SELECT oga00 INTO l_oga00 FROM oga_file WHERE oga01=sr.tlf.tlf905
         #IF l_oga00 = '3' THEN  #MOD-C90023 mark
             CASE sr.tlf.tlf907
                WHEN '-1'
                    LET sr2.status = '1'   #出庫 
                WHEN '1'
                    LET sr2.status = '2'   #入庫 
             END CASE
         #END IF                 #MOD-C90023 mark 
       END IF
      #end MOD-A70178 add
      #MOD-B10182---add---start---
      #組合單單身status為出庫
       IF sr2.tlf13 ='atmt260' THEN
          CASE sr.tlf.tlf907
             WHEN '-1'
                 LET sr2.status = '1'   #出庫 
             WHEN '1'
                 LET sr2.status = '2'   #入庫 
          END CASE
       END IF
      #拆解單單身status為入庫
       IF sr2.tlf13 ='atmt261' THEN
          CASE sr.tlf.tlf907
             WHEN '-1'
                 LET sr2.status = '1'   #出庫 
             WHEN '1'
                 LET sr2.status = '2'   #入庫 
          END CASE
       END IF
      #MOD-B10182---add---end---
       CASE 
         #出庫  
         WHEN sr2.status='1' OR sr2.status='3' OR sr2.status='4'
 #NO.MOD-530790--begin                                                           
           #LET sr2.no       = sr.tlf.tlf026,'-',sr.tlf.tlf027 USING'###'#TQC-5B0142 mark        
 #NO.MOD-530790--end         
           #TQC-5B0142 add
           IF NOT cl_null(sr.tlf.tlf027) THEN
              LET sr2.no = sr.tlf.tlf026 CLIPPED,'-',sr.tlf.tlf027 CLIPPED USING'###'
           ELSE
              LET sr2.no = sr.tlf.tlf026 CLIPPED
           END IF
          #MOD-B10182---add---start---
          #拆解單單頭不應該有"-"
           IF sr2.tlf13='atmt261' AND sr2.status='1' THEN
              LET sr2.no = sr.tlf.tlf026 CLIPPED
           END IF
          #MOD-B10182---add---end---
           #TQC-5B0142 end
           LET sr2.stock    = sr.tlf.tlf021 
           LET sr2.ware     = sr.tlf.tlf022
           LET sr2.location = sr.tlf.tlf023
           LET sr2.tlf08    = sr.tlf.tlf08       
         #入庫  
         WHEN sr2.status='2'
 #NO.MOD-530790--begin                                                           
           #LET sr2.no       = sr.tlf.tlf036,'-',sr.tlf.tlf037 USING'###'#TQC-5B0142 mark        
 #NO.MOD-530790--end     
           #TQC-5B0142 add
           IF NOT cl_null(sr.tlf.tlf037) THEN
              LET sr2.no = sr.tlf.tlf036 CLIPPED,'-',sr.tlf.tlf037 CLIPPED USING'###'
           ELSE
              LET sr2.no = sr.tlf.tlf036 CLIPPED
           END IF
          #MOD-B10182---add---start---
          #組合單單頭不應該有"-"
           IF sr2.tlf13='atmt260' AND sr2.status='2' THEN
              LET sr2.no = sr.tlf.tlf036 CLIPPED
           END IF
          #MOD-B10182---add---end---
           #TQC-5B0142 end
           LET sr2.stock    = sr.tlf.tlf031 
           LET sr2.ware     = sr.tlf.tlf032
           LET sr2.location = sr.tlf.tlf033
           LET sr2.tlf08    = sr.tlf.tlf08 
         OTHERWISE LET l_code='N'
      END CASE
 
      IF sr2.status='3' AND (sr2.tlf13='aimp880' OR sr2.tlf13='aimt307') THEN
         IF sr.tlf.tlf026='CYCLE' OR sr.tlf.tlf026='Physical' THEN
 #NO.MOD-530790--begin                                                           
           #LET sr2.no       = sr.tlf.tlf036,'-',sr.tlf.tlf037 USING'###' #TQC-5B0142 mark        
 #NO.MOD-530790-end  
           #TQC-5B0142 add
           IF NOT cl_null(sr.tlf.tlf037) THEN
              LET sr2.no = sr.tlf.tlf036 CLIPPED,'-',sr.tlf.tlf037 CLIPPED USING'###'
           ELSE
              LET sr2.no = sr.tlf.tlf036 CLIPPED
           END IF
           #TQC-5B0142 end
           LET sr2.stock    = sr.tlf.tlf031 
           LET sr2.ware     = sr.tlf.tlf032
           LET sr2.location = sr.tlf.tlf033
           LET sr2.tlf08    = sr.tlf.tlf08       
         END IF
      END IF
 
      IF l_code='N' THEN 
         LET sr2.str='錯誤-',sr.tlf.tlf13
      END IF
 
       #No.FUN-780012 --start-- mark
#      #排列順序處理
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr2.no  
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr2.date  
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr2.stock
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr2.ware
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr2.tlf01
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.tlf13
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr2.order1 = l_order[1]
#      LET sr2.order2 = l_order[2]
#      LET sr2.order3 = l_order[3]
       #No.FUN-780012 --end--
 
      CALL s_refcode(sr.tlf.tlf13, sr.tlf.tlf026,sr.tlf.tlf027,
                  sr.tlf.tlf036,sr.tlf.tlf037,sr.tlf.tlf14,sr.tlf.tlf19,
                  sr.tlf.tlf021,sr.tlf.tlf022,sr.tlf.tlf023,
                  sr.tlf.tlf031,sr.tlf.tlf032,sr.tlf.tlf033)
             RETURNING sr2.refer1,sr2.refer2,
                       sr2.refer3,sr2.refer4
     #MOD-650076-begin-mark
      #為調撥時(出/入庫為同一資料,故需分兩筆資料)丟至report
      #IF sr2.status = '4' THEN 
      #   LET sr2.tlf10=sr2.tlf10*(-1)      
      #   OUTPUT TO REPORT x230_rep(sr2.*)    #先丟調撥出
      #   LET sr2.str ='調撥(一)→倉庫'
 #NO.MOD-530790--begin                                                           
      #   LET sr2.no       = sr.tlf.tlf036,'-',sr.tlf.tlf037 USING'###'          
 #NO.MOD-530790--end    
      #   LET sr2.stock    = sr.tlf.tlf031 
      #   LET sr2.ware     = sr.tlf.tlf032
      #   LET sr2.location = sr.tlf.tlf033
      #   LET sr2.status   = '2'
      #   LET sr2.tlf10=sr2.tlf10*(-1)       
      #   OUTPUT TO REPORT x230_rep(sr2.*)
      #ELSE
     #MOD-650076-end-mark
         IF sr2.status='1' THEN LET sr2.tlf10=sr2.tlf10*(-1) END IF
         IF sr2.status='3' THEN 
            IF sr2.tlf13='aimp880' OR sr2.tlf13='aimt307' THEN
               IF sr.tlf.tlf036='CYCLE' OR sr.tlf.tlf036='Physical' THEN
                  LET sr2.tlf10=sr2.tlf10*(-1)
               END IF
            END IF
         END IF
#         OUTPUT TO REPORT x230_rep(sr2.*)                 #No.FUN-780012
          #No.FUN-780012 --add--
         #FUN-CB0004--add--str---
          SELECT imd02 INTO l_imd02 FROM imd_file
           WHERE imd01 = sr2.stock
          SELECT ime03 INTO l_ime03 FROM ime_file
           WHERE ime01 = sr2.stock
             AND ime02 = sr2.ware
          IF sr2.status != '2' THEN
             LET sr2.tlf10_1 = sr2.tlf10
             LET sr2.tlf10 = 0
          ELSE 
             LET sr2.tlf10 = sr2.tlf10 
             LET sr2.tlf10_1 = 0
          END IF
          LET sr2.l_pot = 3 
         #FUN-CB0004--add--end---
          EXECUTE insert_prep USING sr2.no,sr2.date,sr2.stock,sr2.ware,     
                                    sr2.tlf01,sr2.location,sr2.ima02,sr2.ima021,    
                                    sr2.tlf11,sr2.str,sr2.tlf10,sr2.tlf10_1,sr2.tlf62,     #FUN-CB0004 add sr2.tlf10_1
                                    sr2.refer1,sr2.refer2,sr2.refer3,sr2.refer4,
                                    sr2.tlf13,sr2.status,sr2.l_pot,l_imd02,l_ime03        #FUN-CB0004 add sr2.l_pot,l_imd02,l_ime03
          #No.FUN-780012 --end-- 
     #END IF   #MOD-650076-mark
     END FOREACH
  END FOR 
#     FINISH REPORT x230_rep                               #No.FUN-780012
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #No.FUN-780012
#No.FUN-780012 --start--                                                        
    LET g_xgrid.table = l_table    ###XtraGrid###
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                    
    IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'tlf13,tlf01,ima08,ima06,tlf021,tlf022,tlf023,tlf06,tlf06,tlf07,tlf07')
           RETURNING tm.wc                                                      
      LET l_str = tm.wc                                                         
    END IF                                                                      
###XtraGrid###    LET l_str = l_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",  
###XtraGrid###                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",        
###XtraGrid###                tm.u[2,2],";",tm.u[3,3]                                
###XtraGrid###    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
###XtraGrid###    CALL cl_prt_cs3('aimx230','aimx230',l_sql,l_str)                            
   #FUN-CB0004--add--str---
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"chr20,tlf07,tlf021,tlf022,tlf01,tlf13")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"chr20,tlf07,tlf021,tlf022,tlf01,tlf13")
   #LET g_xgrid.grup_sum_field = cl_get_sum_field(tm.s,tm.u,"chr20,tlf07,tlf021,tlf022,tlf01,tlf13")  #FUN-D30070 mark
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"chr20,tlf07,tlf021,tlf022,tlf01,tlf13")
   #LET l_str = cl_wcchp(g_xgrid.order_field,"chr20,tlf07,tlf021,tlf022,tlf01,tlf13")  #FUN-D30070 mark
   #LET l_str = cl_replace_str(l_str,',','-')   #FUN-D30070 mark
   #LET g_xgrid.footerinfo1 = cl_getmsg("lib-626",g_lang),l_str   #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-780012 --end-- 
END FUNCTION
#No.FUN-780012 --start-- mark
{REPORT x230_rep(sr2)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr2        RECORD       
                     order1   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order2   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     order3   LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                     #no      LIKE tlf_file.tlf026,  #單據編號  #No.FUN-550029 #TQC-5B0142 mark
                     no       LIKE type_file.chr20,  #單據編號  #TQC-5B0142 add #No.FUN-690026 VARCHAR(20)
                     item     LIKE tlf_file.tlf027,  #項次     
                     date     LIKE tlf_file.tlf07,   #日期
                     stock    LIKE tlf_file.tlf021,  #倉庫編號
                     ware     LIKE tlf_file.tlf022,  #儲位
                     location LIKE tlf_file.tlf023,  #批號
                     tlf01    LIKE tlf_file.tlf01,   #料件編號
                     ima02    LIKE ima_file.ima02,   #品名規格
                     ima021   LIKE ima_file.ima021,  #品名規格 #FUN-510017
                     tlf11    LIKE tlf_file.tlf11,   #異動單位
                     tlf10    LIKE tlf_file.tlf10,   #異動數量
                     tlf02    LIKE tlf_file.tlf02,   #來源狀況 
                     tlf03    LIKE tlf_file.tlf03,   #目的狀況
                     tlf13    LIKE tlf_file.tlf13,   #異動命令
                     tlf62    LIKE tlf_file.tlf62,   #
                     tlf08    LIKE tlf_file.tlf08,   #異動時間
                     status   LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
                     str      LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(14)
                     refer1   LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     refer2   LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     refer3   LIKE tlf_file.tlf026,  #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     refer4   LIKE tlf_file.tlf026   #TQC-5B0142 10->16 #No.FUN-690026 VARCHAR(16)
                     END RECORD,
             l_amt_input LIKE tlf_file.tlf10,
             l_amt_out   LIKE tlf_file.tlf10
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr2.order1,sr2.order2,sr2.order3,sr2.tlf08
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
      PRINT g_x[25] clipped,g_order clipped
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
      PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48]
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr2.order1 
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr2.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr2.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      PRINTX name=D1 COLUMN g_c[31],sr2.no,
                     COLUMN g_c[32],sr2.date,
                     COLUMN g_c[33],sr2.stock,
                     COLUMN g_c[34],sr2.tlf01,
                     COLUMN g_c[35],sr2.ima02,
                     COLUMN g_c[36],sr2.tlf11,
                     COLUMN g_c[37],sr2.str;
 
      IF sr2.status = '2' THEN    #入庫
           PRINTX name=D1 COLUMN g_c[38],cl_numfor(sr2.tlf10,38,3),
                          COLUMN g_c[39],' ';
      ELSE                        #出庫(調整)
           PRINTX name=D1 COLUMN g_c[38],' ',
                          COLUMN g_c[39],cl_numfor(sr2.tlf10,38,3);
      END IF  
      PRINTX name=D1 COLUMN g_c[40],sr2.tlf62,               
                     COLUMN g_c[41],sr2.refer1 clipped,
                     COLUMN g_c[42],sr2.refer2 clipped
 
      PRINTX name=D2 COLUMN g_c[43],' ',
            COLUMN g_c[44],sr2.ware,
            COLUMN g_c[45],sr2.location,
            COLUMN g_c[46],sr2.ima021,
            COLUMN g_c[47],sr2.refer3 clipped,
            COLUMN g_c[48],sr2.refer4 clipped
 
     #IF (tm.b ='2' AND sr2.location is not null AND sr2.location != ' ') 
     #OR (tm.b = '3' AND sr2.location is not null AND sr2.location != ' ')
     #THEN PRINT column 24,sr2.location
     #END IF
 
   AFTER GROUP OF sr2.order1
     #FUN-D30070---mark---str--
     #IF tm.u[1,1] = 'Y' THEN
     #   #出庫
     #   LET l_amt_input = GROUP SUM(sr2.tlf10) 
     #                           WHERE sr2.status !='2'
     #   #入庫
     #   LET l_amt_out   = GROUP SUM(sr2.tlf10) 
     #                           WHERE sr2.status  ='2'
     #   PRINTX name=S1 COLUMN g_c[36],g_amt clipped,
     #                  COLUMN g_c[37],g_x[18] clipped,
     #                  COLUMN g_c[38],cl_numfor(l_amt_out,38,3),
     #                  COLUMN g_c[39],cl_numfor(l_amt_input,39,3)
     #END IF
     #FUN-D30070---mark---end--
 
   AFTER GROUP OF sr2.order2
     #FUN-D30070---mark---str--
     #IF tm.u[2,2] = 'Y' THEN
     #   #出庫
     #   LET l_amt_input = GROUP SUM(sr2.tlf10) 
     #                           WHERE sr2.status !='2'
     #   #入庫
     #   LET l_amt_out   = GROUP SUM(sr2.tlf10) 
     #                           WHERE sr2.status  ='2'
     #   PRINTX name=S1 COLUMN g_c[36],g_amt clipped,
     #                  COLUMN g_c[37],g_x[18] clipped,
     #                  COLUMN g_c[38],cl_numfor(l_amt_out,38,3),
     #                  COLUMN g_c[39],cl_numfor(l_amt_input,39,3)
     #END IF
     #FUN-D30070---mark---end--
 
   AFTER GROUP OF sr2.order3
     #FUN-D30070---mark---str--
     #IF tm.u[3,3] = 'Y' THEN
     #   #出庫
     #   LET l_amt_input = GROUP SUM(sr2.tlf10) 
     #                           WHERE sr2.status !='2'
     #   #入庫
     #   LET l_amt_out   = GROUP SUM(sr2.tlf10) 
     #                           WHERE sr2.status  ='2'
     #   PRINTX name=S1 COLUMN g_c[36],g_amt clipped,
     #                  COLUMN g_c[37],g_x[18] clipped,
     #                  COLUMN g_c[38],cl_numfor(l_amt_out,38,3),
     #                  COLUMN g_c[39],cl_numfor(l_amt_input,39,3)
     #END IF
     #FUN-D30070---mark---end--
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'tlf06,tlf07,tlf026,tlf021,tlf022,tlf023,tlf01')
              RETURNING tm.wc
         PRINT g_dash
       #TQC-630166
       #       IF tm.wc[001,120] > ' ' THEN            # for 132
       #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
       #       IF tm.wc[121,240] > ' ' THEN
       #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
       #       IF tm.wc[241,300] > ' ' THEN
       #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2  LINES
      END IF
END REPORT}
#No.FUN-780012 --end--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END


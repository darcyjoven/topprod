# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: gfag102.4gl
# Desc/riptions..: 固定產移轉申請表
# Date & Author..: 96/06/11 By Kitty
# Date & Modify..: 03/07/15 By Wiky #No:7808 l_sql中OUTER fap_file
#                  要拆開到FOREACH再產抓...因為ORACLE l_sql=.. OUTER fap_file
#                  l_sql產生multi OUTER 問題
# Modify.........: No.FUN-510035 05/01/18 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.FUN-5A0029 05/10/25 By Claire 報表調整可印Font10
# Modify.........: No.TQC-5B0063 05/11/08 By Claire 頁數格式放大列印
# Modify.........: No.MOD-640390 06/04/13 By Smamin  金額部份改抓faj_file
# Modify.........: No.MOD-670078 06/07/18 By Smapmin 修改SQL語法
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 打印結果中沒有‘接下頁’、‘結束’
# Modify.........: No.FUN-710083 07/01/30 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.MOD-750102 07/05/23 By Smapmin 修改新/舊位置抓取來源
# Modify.........: No.FUN-940042 09/05/06 By TSD.Wind 在CR報表列印簽核欄
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60084 10/06/12 By Carrier blob初始化
# Modify.........: No.FUN-B40092 11/05/12 By xujing 憑證報表轉GRW 

# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/07 By wangrr GR程式優化
# Modify.........: No.FUN-CC0093 12/12/20 By wangrr GR程式修改
# Modify.........: No.FUN-D10098 13/02/01 By lujh 新增gfag102

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
       	    	#wc     LIKE type_file.chr1000,		# Where condition       #No.FUN-680070 VARCHAR(1000)   #FUN-CC0093 mark
                wc      STRING,                     #FUN-CC0093 add
                a       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    	        b    	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                more    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-710083 --begin
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710083 --end
###GENGRE###START
TYPE sr1_t RECORD
    fas01 LIKE fas_file.fas01,
    fas02 LIKE fas_file.fas02,
    fas03 LIKE fas_file.fas03,
    fas04 LIKE fas_file.fas04,
    fas05 LIKE fas_file.fas05,
    fat02 LIKE fat_file.fat02,
    fat03 LIKE fat_file.fat03,
    fat031 LIKE fat_file.fat031,
    faj06 LIKE faj_file.faj06,
    faj07 LIKE faj_file.faj07,
    faj08 LIKE faj_file.faj08,
    faj17 LIKE faj_file.faj17,
    faj58 LIKE faj_file.faj58,
    faj18 LIKE faj_file.faj18,
    faj26 LIKE faj_file.faj26,
    fap19 LIKE fap_file.fap19,
    fap65 LIKE fap_file.fap65,
    faj14 LIKE faj_file.faj14,
    faj141 LIKE faj_file.faj141,
    faj59 LIKE faj_file.faj59,
    faj32 LIKE faj_file.faj32,
    faj60 LIKE faj_file.faj60,
    fap17 LIKE fap_file.fap17,
    fap18 LIKE fap_file.fap18,
    fap63 LIKE fap_file.fap63,
    fap64 LIKE fap_file.fap64,
    gen02 LIKE gen_file.gen02,
    gem02 LIKE gem_file.gem02,
    azi03 LIKE azi_file.azi03,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#No.FUN-710083 --begin
   LET g_sql ="fas01.fas_file.fas01,",
              "fas02.fas_file.fas02,",
              "fas03.fas_file.fas03,",
              "fas04.fas_file.fas04,",
              "fas05.fas_file.fas05,",
              "fat02.fat_file.fat02,",
              "fat03.fat_file.fat03,",
              "fat031.fat_file.fat031,",
              "faj06.faj_file.faj06,",
              "faj07.faj_file.faj07,",
              "faj08.faj_file.faj08,",
              "faj17.faj_file.faj17,",
              "faj58.faj_file.faj58,",
              "faj18.faj_file.faj18,",
              "faj26.faj_file.faj26,",
              "fap19.fap_file.fap19,",
              "fap65.fap_file.fap65,",
              "faj14.faj_file.faj14,",
              "faj141.faj_file.faj141,",
              "faj59.faj_file.faj59,",
              "faj32.faj_file.faj32,",
              "faj60.faj_file.faj60,",
              "fap17.fap_file.fap17,",
              "fap18.fap_file.fap18,",
              "fap63.fap_file.fap63,",
              "fap64.fap_file.fap64,",
              "gen02.gen_file.gen02,",
              "gem02.gem_file.gem02,",
              "azi03.azi_file.azi03,",
              "sign_type.type_file.chr1,",   #簽核方式   #FUN-940042
              "sign_img.type_file.blob,",    #簽核方式   #FUN-940042
              "sign_show.type_file.chr1,",     #是否顯示簽核資料(Y/N)  #FUN-940042
              "sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('gfag102',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ? )"  #FUN-940042#FUN-C40020 ADD ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
#No.FUN-710083 --end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g102_tm(0,0)		# Input print condition
      ELSE CALL gfag102()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g102_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
  
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW g102_w AT p_row,p_col WITH FORM "gfa/42f/gfag102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defaslt condition
   LET tm.a    = '2'
   LET tm.b    = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fas01,fas02,fas03,fas04,fas05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
    #FUN-CC0093--add--str--
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(fas01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_fas"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO fas01
             NEXT FIELD fas01
          WHEN INFIELD(fas03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_fas03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO fas03
             NEXT FIELD fas03
          WHEN INFIELD(fas04)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_fas04"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO fas04
             NEXT FIELD fas04  
       END CASE
    #FUN-CC0093--add--end
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
         LET INT_FLAG = 0 CLOSE WINDOW g102_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[123]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[123]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW g102_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='gfag102'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gfag102','9031',1)
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
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('gfag102',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW g102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL gfag102()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g102_w
END FUNCTION
 
FUNCTION gfag102()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_gem02       LIKE gem_file.gem02,           #部門名稱     #No.FUN-710083
          l_gen02       LIKE gen_file.gen02,           #申請人名稱     #No.FUN-710083
          #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1200)  #FUN-CC0093 mark
          l_sql     STRING,                     #FUN-CC0093 add
          l_chr		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_faspost     LIKE fas_file.faspost,  #MOD-750102
          sr   RECORD
                     fas01     LIKE fas_file.fas01,    #請修單號
                     fas02     LIKE fas_file.fas02,    #日期
                     fas03     LIKE fas_file.fas03,    #申請人
                     fas04     LIKE fas_file.fas04,    #申請部門
                     fas05     LIKE fas_file.fas05,    #申請日期
                     fat02     LIKE fat_file.fat02,    #項次
                     fat03     LIKE fat_file.fat03,    #財產編號
                     fat031    LIKE fat_file.fat031,   #附號
                     faj06     LIKE faj_file.faj06,    #品名
                     faj07     LIKE faj_file.faj07,    #英文名稱
                     faj08     LIKE faj_file.faj08,    #規格
                     faj17     LIKE faj_file.faj17,    #數量
                     faj58     LIKE faj_file.faj58,    #銷帳數量
                     faj18     LIKE faj_file.faj18,    #單位
                     faj26     LIKE faj_file.faj26,    #取得日期
                     fap19     LIKE fap_file.fap19,    #原置處所
                     fap65     LIKE fap_file.fap65,    #新置處所Q
                     #-----MOD-640390---------
                     #fap09     LIKE fap_file.fap09,    #成本
                     #fap10     LIKE fap_file.fap10,    #
                     #fap22     LIKE fap_file.fap22,    #
                     #fap11     LIKE fap_file.fap11,    #累計折舊
                     #fap23     LIKE fap_file.fap23,    #
                     faj14     LIKE faj_file.faj14,    
                     faj141    LIKE faj_file.faj141,    
                     faj59     LIKE faj_file.faj59,    
                     faj32     LIKE faj_file.faj32,    
                     faj60     LIKE faj_file.faj60,    
                     #-----END MOD-640390-----
                     fap17     LIKE fap_file.fap17,    #移出部門
                     fap18     LIKE fap_file.fap18,    #移出保管人
                     fap63     LIKE fap_file.fap63,    #移入部門
                     fap64     LIKE fap_file.fap64     #移入保管人
        END RECORD
   ###FUN-940042 START ###
   DEFINE l_img_blob     LIKE type_file.blob
 #  LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_ii           INTEGER
   #DEFINE l_sql_2       LIKE type_file.chr1000        # RDSQL STATEMENT   #FUN-CC0093 mark
   DEFINE l_sql_2        STRING                  #FUN-CC0093  add
   DEFINE l_key          RECORD                  #主鍵
             v1          LIKE fas_file.fas01
                         END RECORD
   ###FUN-940042 END ###
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)     #No.FUN-710083
     LOCATE l_img_blob IN MEMORY   #blob初始化   #MOD-A60084
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fasuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fasgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fasgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fasuser', 'fasgrup')
     #End:FUN-980030
 
 
 #No:7808(原sql)
{
     LET l_sql = "SELECT fas01,fas02,fas03,fas04,fas05,",
                 "       fat02,fat03,fat031,",
                 "       faj06,faj07,faj08,faj17,faj58,faj18,faj26,",
                 "       fap19,fap65,fap09,fap10,fap22,fap11,fap23,",
                 "       fap17,fap18,fap63,fap64",
                 "  FROM fas_file,fat_file, OUTER faj_file,OUTER fap_file ",
                 " WHERE fas01 = fat01 ",
                 "   AND fasconf !='X' ",         #010801增
                 "   AND fat_file.fat03=faj_file.faj02 ",
                 "   AND fat_file.fat031=faj_file.faj022 ",
                 "   AND fat03=fap_file.fap02 AND fat031=fap021 ",
                 "   AND fap03='3'   AND fap04=fas02 ",
                 "   AND ",tm.wc CLIPPED
}
  LET l_sql = "SELECT fas01,fas02,fas03,fas04,fas05,",
                 "       fat02,fat03,fat031,",
                 "       faj06,faj07,faj08,faj17,faj58,faj18,faj26,",
                 #"       '','',0,0,0,0,0, ",   #MOD-640390
                 "       '','',faj14,faj141,faj59,faj32,faj60, ",   #MOD-640390
                 "       '','','','' ",
               # "  FROM fas_file,fat_file, OUTER faj_file  ",  #FUN-C50008 mark--
                 "  FROM fas_file,fat_file LEFT OUTER JOIN faj_file ON (fat03=faj02 AND fat031=faj022) ",  #FUN-C50008 add LEFT OUTER
                 " WHERE fas01 = fat01 ",
                 "   AND fasconf !='X' ",         #010801增
                #"   AND fat_file.fat03=faj_file.faj02 ",  #FUN-C50008 mark--
                #"   AND fat_file.fat031=faj_file.faj022 ",#FUN-C50008 mark--
                 "   AND ",tm.wc CLIPPED
     ##
     IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fasconf='Y' " END IF
     IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fasconf='N' " END IF
     IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND faspost='Y' " END IF
     IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND faspost='N' " END IF
     PREPARE g102_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
           
     END IF
     DECLARE g102_cs1 CURSOR FOR g102_prepare1
#No.FUN-710083 --begin
#    SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#    CALL cl_outnam('gfag102') RETURNING l_name
#    START REPORT g102_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710083 --end
     FOREACH g102_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #-----MOD-750102---------
       LET l_faspost = ''
       SELECT faspost INTO l_faspost FROM fas_file WHERE fas01=sr.fas01  
       IF l_faspost = 'Y' THEN
       #-----END MOD-750102-----
          #No:7808(for ORACLE問題)
          #-----MOD-640390---------
          #SELECT fap19,fap65,fap09,fap10,fap22,fap11,
          #       fap23,fap17,fap18,fap63,fap64
          #  INTO sr.fap19,sr.fap65,sr.fap09,sr.fap10,sr.fap22,sr.fap11,
          #       sr.fap23,sr.fap17,sr.fap18,sr.fap63,sr.fap64
          SELECT fap19,fap65,fap17,fap18,fap63,fap64
            INTO sr.fap19,sr.fap65,sr.fap17,sr.fap18,sr.fap63,sr.fap64
          #-----END MOD-640390-----
            #FROM fap_file,OUTER fas_file   #MOD-670078
            FROM fap_file   #MOD-670078
           WHERE fap02=sr.fat03 AND fap021=sr.fat031
             #AND fap03='3'      AND fap04=fas_file.fas02   #MOD-670078
             AND fap03='3'      AND fap04=sr.fas02   #MOD-670078
       #-----MOD-750102---------
       ELSE
          SELECT faj19,faj20,faj21 
            INTO sr.fap18,sr.fap17,sr.fap19
            FROM faj_file
           WHERE faj02 = sr.fat03 AND faj022 = sr.fat031
          SELECT fat04,fat05,fat06
            INTO sr.fap64,sr.fap63,sr.fap65
            FROM fat_file
           WHERE fat01 = sr.fas01 AND fat02 = sr.fat02
       END IF
       #-----END MOD-750102-----
#No.FUN-710083 --begin
      LET l_gen02=' '
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fas03
      LET l_gem02=' '
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fas04
      EXECUTE insert_prep USING sr.*,l_gen02,l_gem02,g_azi03,
                                "",l_img_blob,"N",""    #FUN-940042  # No.FUN-C40020 add""
#     OUTPUT TO REPORT g102_rep(sr.*) 
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fas01,fas02,fas03,fas04,fas05')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED        #TQC-730088
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     ###FUN-940042 START ###
     LET g_cr_table = l_table                 #主報表的temp table名稱
     LET g_cr_gcx01 = "afai060"               #單別維護程式
     LET g_cr_apr_key_f = "fas01"             #報表主鍵欄位名稱，用"|"隔開 
###GENGRE###     LET l_sql_2 = "SELECT DISTINCT fas01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE key_pr FROM l_sql_2
     DECLARE key_cs CURSOR FOR key_pr
     LET l_ii = 1
     #報表主鍵值
     CALL g_cr_apr_key.clear()                #清空
     FOREACH key_cs INTO l_key.*            
        LET g_cr_apr_key[l_ii].v1 = l_key.v1
        LET l_ii = l_ii + 1
     END FOREACH
     ###FUN-940042 END ###
   # CALL cl_prt_cs3('gfag102',l_sql,g_str)              #TQC-730088
###GENGRE###     CALL cl_prt_cs3('gfag102','gfag102',l_sql,g_str)
    CALL gfag102_grdata()    ###GENGRE###
#No.FUN-710083 --end
 
#    FINISH REPORT g102_rep     #No.FUN-710083
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #No.FUN-710083
END FUNCTION
 
#No.MOD-710138 --begin
#REPORT g102_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          l_gem02       LIKE gem_file.gem02,           #部門名稱
#          l_gen02       LIKE gen_file.gen02,           #申請人名稱
#          l_gem02_1     LIKE gem_file.gem02,           #移出部門名稱
#          l_gem02_2     LIKE gem_file.gem02,           #移入部門名稱
#          l_gem01_1     LIKE gem_file.gem01,           #移出部門代號
#          l_gem01_2     LIKE gem_file.gem01,           #移入部門代號
#          l_gen02_1     LIKE gen_file.gen02,           #移出保管人
#          l_gen02_2     LIKE gen_file.gen02,           #移入保管人
#          l_a1          LIKE type_file.num5,                        #數量       #No.FUN-680070 SMALLINT
#          l_a2          LIKE type_file.num20_6,                #成本       #No.FUN-680070 DECIMAL(20,6)
#          l_a3          LIKE type_file.num20_6,                #累計折舊       #No.FUN-680070 DECIMAL(20,6)
#          l_a4          LIKE type_file.num20_6,                #帳面價值       #No.FUN-680070 DECIMAL(20,6)
#          g_head1       STRING,
#          str           STRING,
#          sr   RECORD
#                     fas01     LIKE fas_file.fas01,    #請修單號
#                     fas02     LIKE fas_file.fas02,    #日期
#                     fas03     LIKE fas_file.fas03,    #申請人
#                     fas04     LIKE fas_file.fas04,    #申請部門
#                     fas05     LIKE fas_file.fas05,    #申請日期
#                     fat02     LIKE fat_file.fat02,    #項次
#                     fat03     LIKE fat_file.fat03,    #財產編號
#                     fat031    LIKE fat_file.fat031,   #附號
#                     faj06     LIKE faj_file.faj06,    #品名
#                     faj07     LIKE faj_file.faj07,    #英文名稱
#                     faj08     LIKE faj_file.faj08,    #規格
#                     faj17     LIKE faj_file.faj17,    #數量
#                     faj58     LIKE faj_file.faj58,    #銷帳數量
#                     faj18     LIKE faj_file.faj18,    #單位
#                     faj26     LIKE faj_file.faj26,    #取得日期
#                     fap19     LIKE fap_file.fap19,    #原置處所
#                     fap65     LIKE fap_file.fap65,    #新置處所
#                     #-----MOD-640390---------
#                     #fap09     LIKE fap_file.fap09,    #成本
#                     #fap10     LIKE fap_file.fap10,    #
#                     #fap22     LIKE fap_file.fap22,    #
#                     #fap11     LIKE fap_file.fap11,    #累計折舊
#                     #fap23     LIKE fap_file.fap23,    #
#                     faj14     LIKE faj_file.faj14,    
#                     faj141    LIKE faj_file.faj141,    
#                     faj59     LIKE faj_file.faj59,    
#                     faj32     LIKE faj_file.faj32,    
#                     faj60     LIKE faj_file.faj60,    
#                     #-----END MOD-640390-----
#                     fap17     LIKE fap_file.fap17,    #移出部門
#                     fap18     LIKE fap_file.fap18,    #移出保管人
#                     fap63     LIKE fap_file.fap63,    #移入部門
#                     fap64     LIKE fap_file.fap64     #移入保管人
#        END RECORD
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.fas01,sr.fat02
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009 mark
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0009
#      #申請人,單據編號
#      LET l_gen02=' '
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fas03
#      LET g_head1 =  g_x[11] CLIPPED,sr.fas03,' ',l_gen02,'   ',
#                     g_x[9]  CLIPPED,sr.fas01
#      PRINT g_head1
#      #申請部門
#      LET l_gem02=' '
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fas04
#      LET g_head1 =  g_x[12] CLIPPED,sr.fas04,' ',l_gem02
#      PRINT g_head1
#      #申請日期,單據日期
#      LET g_head1 =  g_x[13] CLIPPED,sr.fas05,'   ',
#                     g_x[10] CLIPPED,sr.fas02
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      #FUN-5A0029-begin
#      #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#      #      g_x[39],g_x[40],g_x[41]
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34]
#      PRINTX name=H2 g_x[42],g_x[49],g_x[50],g_x[45]
#      PRINTX name=H3 g_x[43],g_x[51],g_x[52],g_x[35],g_x[48],g_x[47]
#      PRINTX name=H4 g_x[44],g_x[53],g_x[54],g_x[36],g_x[46],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#      #FUN-5A0029-end
#      PRINT g_dash1
#      LET l_last_sw='n'
# 
#BEFORE GROUP OF sr.fas01
#      # 先將第一筆之部門資料及保管人資料存入,以免有同張單據不同資料
#      LET l_gem01_1=sr.fap17
#      LET l_gem01_2=sr.fap63
#      LET l_gem02_1=' '    LET l_gem02_2=' '
#      LET l_gen02_1=' '    LET l_gen02_2=' '
#      SELECT gem02 INTO l_gem02_1 FROM gem_file WHERE gem01=sr.fap17
#      SELECT gem02 INTO l_gem02_2 FROM gem_file WHERE gem01=sr.fap63
#      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01=sr.fap18
#      SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01=sr.fap64
#      #跳頁
#      SKIP TO TOP OF PAGE
#
#ON EVERY ROW
#      LET l_a1=sr.faj17-sr.faj58            #數量
#      #-----MOD-640390---------
#      #LET l_a2=sr.fap09+sr.fap10-sr.fap22   #成本
#      #LET l_a3=sr.fap11-sr.fap23            #累計折舊
#      LET l_a2=sr.faj14+sr.faj141-sr.faj59   #成本
#      LET l_a3=sr.faj32-sr.faj60            #累計折舊
#      #-----END MOD-640390-----
#      LET l_a4=l_a2-l_a3                    #帳面價值
#      #FUN-5A0029-begin
#      #PRINT COLUMN g_c[31],sr.fat02 USING '###',
#      #      COLUMN g_c[32],sr.fat03,
#      #      COLUMN g_c[33],sr.fat031,
#      #      COLUMN g_c[34],sr.faj06,
#      #      COLUMN g_c[35],sr.faj08,
#      #      COLUMN g_c[36],l_a1 USING '######',
#      #      COLUMN g_c[37],sr.fap19,
#      #      COLUMN g_c[38],sr.fap65,
#      #      COLUMN g_c[39],sr.faj26,
#      #      COLUMN g_c[40],cl_numfor(l_a2,40,g_azi03) CLIPPED,
#      #      COLUMN g_c[41],cl_numfor(l_a4,41,g_azi03) CLIPPED
#      #PRINT COLUMN g_c[34],sr.faj07,
#      #      COLUMN g_c[36],sr.faj18,
#      #      COLUMN g_c[40],cl_numfor(l_a3,40,g_azi03) CLIPPED
#      PRINTX name=D1
#            COLUMN g_c[31],sr.fat02 USING '###&',
#            COLUMN g_c[32],sr.fat03,
#            COLUMN g_c[33],sr.fat031,
#            COLUMN g_c[34],sr.faj06
#      PRINTX name=D2
#            COLUMN g_c[45],sr.faj07
#      PRINTX name=D3
#            COLUMN g_c[35],sr.faj08,
#            COLUMN g_c[47],cl_numfor(l_a2,40,g_azi03) CLIPPED   #MOD-640390
#      PRINTX name=D4
#            COLUMN g_c[36],cl_numfor(l_a1,36,0),
#            COLUMN g_c[46],sr.faj18,
#            COLUMN g_c[37],sr.fap19,
#            COLUMN g_c[38],sr.fap65,
#            COLUMN g_c[39],sr.faj26,
#            COLUMN g_c[40],cl_numfor(l_a3,40,g_azi03) CLIPPED,   #MOD-640390
#            COLUMN g_c[41],cl_numfor(l_a4,41,g_azi03) CLIPPED
#      #FUN-5A0029-end
### FUN-550114
#ON LAST ROW
#     # PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#     # PRINT ' '
#     #PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#     #      COLUMN g_c[32],l_gem02_1,
#     #      COLUMN g_c[33],g_x[15] CLIPPED,
#     #      COLUMN g_c[34],l_gem01_1,
#     #      COLUMN g_c[35],g_x[16] CLIPPED,
#     #      COLUMN g_c[36],g_x[17] CLIPPED,
#     #      COLUMN g_c[37],l_gen02_1,
#     #      COLUMN g_c[38],g_x[18] CLIPPED
#     #PRINT ' '
#     #PRINT ' '
#     #PRINT COLUMN g_c[31],g_x[19] CLIPPED,
#     #      COLUMN g_c[32],l_gem02_2,
#     #      COLUMN g_c[33],g_x[15] CLIPPED,
#     #      COLUMN g_c[34],l_gem01_2,
#     #      COLUMN g_c[35],g_x[16] CLIPPED,
#     #      COLUMN g_c[36],g_x[17] CLIPPED,
#     #      COLUMN g_c[37],l_gen02_2,
#     #      COLUMN g_c[38],g_x[18] CLIPPED
#
#
#PAGE TRAILER
#     #IF l_last_sw= 'n' THEN
#     #   PRINT g_dash[1,g_len]
#     #   PRINT ' '
#     #   PRINT COLUMN g_c[31],g_x[14] CLIPPED,
#     #         COLUMN g_c[32],l_gem02_1,
#     #         COLUMN g_c[33],g_x[15] CLIPPED,
#     #         COLUMN g_c[34],l_gem01_1,
#     #         COLUMN g_c[35],g_x[16] CLIPPED,
#     #         COLUMN g_c[36],g_x[17] CLIPPED,
#     #         COLUMN g_c[37],l_gen02_1,
#     #         COLUMN g_c[38],g_x[18] CLIPPED
#     #   PRINT ' '
#     #   PRINT ' '
#     #   PRINT COLUMN g_c[31],g_x[19] CLIPPED,
#     #         COLUMN g_c[32],l_gem02_2,
#     #         COLUMN g_c[33],g_x[15] CLIPPED,
#     #         COLUMN g_c[34],l_gem01_2,
#     #         COLUMN g_c[35],g_x[16] CLIPPED,
#     #         COLUMN g_c[36],g_x[17] CLIPPED,
#     #         COLUMN g_c[37],l_gen02_2,
#     #         COLUMN g_c[38],g_x[18] CLIPPED
#     #ELSE
#     #  SKIP 6 LINE
#     #END IF
#      PRINT g_dash[1,g_len]
#      #No.TQC-6C0009 --start--
#      PRINT g_x[4] CLIPPED;
#      IF l_last_sw = 'y' THEN
#         PRINT COLUMN (g_len-9), g_x[7] CLIPPED
#      ELSE
#         PRINT COLUMN (g_len-9), g_x[6] CLIPPED
#      END IF
#      #No.TQC-6C0009 --end--
#      PRINT
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[14]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[14]
#             PRINT g_memo
#      END IF
### END FUN-550114
# 
#END REPORT
#No.TQC-710038 --end

###GENGRE###START
FUNCTION gfag102_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gfag102")
        IF handler IS NOT NULL THEN
            START REPORT gfag102_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY fas01,fat02"
          
            DECLARE gfag102_datacur1 CURSOR FROM l_sql
            FOREACH gfag102_datacur1 INTO sr1.*
                OUTPUT TO REPORT gfag102_rep(sr1.*)
            END FOREACH
            FINISH REPORT gfag102_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gfag102_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_fas03_gen02 STRING 
    DEFINE l_fas04_gem02 STRING
    DEFINE l_a1   LIKE faj_file.faj17
    DEFINE l_a2   LIKE faj_file.faj14
    DEFINE l_a3   LIKE faj_file.faj32
    DEFINE l_a4   LIKE faj_file.faj14
    DEFINE l_a2_fmt   STRING
    DEFINE l_a3_fmt   STRING
    DEFINE l_a4_fmt   STRING
    #FUN-B40092------add------str
    ORDER EXTERNAL BY sr1.fas01,sr1.fat02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.fas01
           #FUN-B40092------add------str
            LET l_fas03_gen02 = sr1.fas03,' ',sr1.gen02
            LET l_fas04_gem02 = sr1.fas04,' ',sr1.gem02
            LET l_lineno = 0
            PRINTX l_fas03_gen02
            PRINTX l_fas04_gem02
            #FUN-B40092------add------end
        BEFORE GROUP OF sr1.fat02

        
        ON EVERY ROW
            #FUN-B40092------add------str
            LET l_lineno = l_lineno + 1
            LET l_a1 = sr1.faj17 - sr1.faj58
            LET l_a2 = sr1.faj14 + sr1.faj141 - sr1.faj59
            LET l_a3 = sr1.faj32 - sr1.faj60
            LET l_a4 = l_a2 - l_a3
            PRINTX l_a1
            PRINTX l_a2
            PRINTX l_a3
            PRINTX l_a4

            LET l_a2_fmt = cl_gr_numfmt('faj_file','faj14',g_azi03)
            PRINTX l_a2_fmt

            LET l_a4_fmt = cl_gr_numfmt('faj_file','faj14',g_azi03)
            PRINTX l_a4_fmt

            LET l_a3_fmt = cl_gr_numfmt('faj_file','faj32',g_azi03)
            PRINTX l_a3_fmt

            #FUN-B40092------add------end
            PRINTX l_lineno
            PRINTX sr1.*

        AFTER GROUP OF sr1.fas01
        AFTER GROUP OF sr1.fat02

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-D10098

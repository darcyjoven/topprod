# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr650.4gl
# Descriptions...: 請採購預算資料表
# Date & Author..: 00/03/20 By Melody
# Modify.........: No.FUN-4C0095 04/12/28 By Mandy 報表轉XML
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0095 06/11/15 By Ray 調整“接下頁”和“結束”的位置
# Modify.........: No.FUN-730033 07/03/23 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740029 07/04/10 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-790077 07/09/19 By Carrier 預算編號/科目編號/部門編號加開窗
# Modify.........: No.FUN-810069 08/03/07 By Zhangyajun 表pnr_file/pns_file更改為afb_file/afc_file,增加key
# Modify.........: No.TQC-840049 08/04/20 By Zhangyajun 調整QBE順序
# Modify.........: No.MOD-840181 08/04/22 By Zhangyajun 調整QBE順序
# Modify.........: No.FUN-830152 08/08/01 By baofei  報表打印改為CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No.TQC-B40063 11/04/11 By lilingyu sql變量定義過短
# Modify.........: No.TQC-B60289 11/06/22 By suncx    wc定義類型錯誤   
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		#wc  	LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(500)	# Where condition
                wc      STRING,  #TQC-B60289
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  	# Input more condition(Y/N)
              END RECORD
 
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680136 SMALLINT
DEFINE g_bookno1       LIKE aza_file.aza81      #No.FUN-730033
DEFINE g_bookno2       LIKE aza_file.aza82      #No.FUN-730033
DEFINE g_flag          LIKE type_file.chr1      #No.FUN-730033
DEFINE g_afb00         LIKE afb_file.afb00      #No.FUN-B20054
DEFINE l_table        STRING,                                                                                                      
        g_str          STRING,                                                                                                      
        g_sql          STRING                                                                                                       
#No.FUN-830152---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#No.FUN-830152---Begin                                                                                                              
    LET g_sql = " afb00.afb_file.afb00,",                                                                                           
                " afb01.afb_file.afb01,",                                                                                           
                " afb02.afb_file.afb02,",                                                                                           
                " afb03.afb_file.afb03,",                                                                                           
                " afb04.afb_file.afb04,",                                                                                           
                " afb041.afb_file.afb041,",                                                                                           
                " afb042.afb_file.afb042,",                                                                                           
                " afc05.afc_file.afc05,",                                                                                           
                " afc06.afc_file.afc06,",
                " afc07.afc_file.afc07,",
                " afc08.afc_file.afc08,", 
                " afc09.afc_file.afc09,",                                                                                           
                " afa02.afa_file.afa02,",                                                                                           
                " aag02.aag_file.aag02,",                                                                                           
                " gem02.gem_file.gem02,",
                " pja02.pja_file.pja02,",
                "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
                "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
                "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
                "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039                                                                                             
   LET l_table = cl_prt_temptable('apmr650',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) "  #TQC-C10039 ADD 4?                                                                              
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830152---End       
 
#---------------No.TQC-610085 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)	
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
#---------------No.TQC-610085 end
   IF tm.wc IS NULL OR tm.wc=' '
      THEN CALL r650_tm(0,0)	
      ELSE CALL apmr650()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r650_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
    DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054

   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r650_w AT p_row,p_col WITH FORM "apm/42f/apmr650"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_afb00 = g_aza.aza81   #No.FUN-B20054
   DISPLAY g_afb00 TO afb00    #No.FUN-B20054
   DISPLAY BY NAME tm.more     #No.FUN-B20054
WHILE TRUE
#No.FUN-B20054--add-start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT g_afb00  FROM afb00 ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD afb00
              IF NOT cl_null(g_afb00) THEN
                   CALL s_check_bookno(g_afb00,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD afb00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = g_afb00
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",g_afb00,"","agl-043","","",0)
                   NEXT FIELD  afb00
                END IF
             END IF
         END INPUT

#No.FUN-B20054--add-end--

#   CONSTRUCT BY NAME tm.wc ON pnr01,pnr02,pnr03,pnr04  #No.FUN-810069 mark
#    CONSTRUCT BY NAME tm.wc ON afb00,afb03,afb01,afb02,afb041,afb042,afb04  #No.FUN-810069  #TQC-840049
#    CONSTRUCT BY NAME tm.wc ON afb00,afb03,afb041,afb01,afb02,afb042,afb04          #TQC-840049 #MOD-840181 mark   
#    CONSTRUCT BY NAME tm.wc ON afb00,afb03,afb01,afb02,afb041,afb042,afb04          #MOD-840181    #No.FUN-B20054
     CONSTRUCT BY NAME tm.wc ON afb03,afb01,afb02,afb041,afb042,afb04     #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start--     
#         ON ACTION locale
#           #CALL cl_dynamic_locale()
#            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            LET g_action_choice = "locale"
#            EXIT CONSTRUCT
#   #No.TQC-790077  --Begin
# 
#         ON ACTION controlp
#           IF INFIELD(afb01) THEN          #NO.FUN-810069 pnr01->afb01
#               CALL cl_init_qry_var()
#               LET g_qryparam.state= "c"
#               LET g_qryparam.form = "q_afa"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO afb01   #NO.FUN-810069 pnr01->afb01
#            END IF
#            IF INFIELD(afb02) THEN          #NO.FUN-810069 pnr02->afb02
#               CALL cl_init_qry_var()
#               LET g_qryparam.state= "c"
#               LET g_qryparam.form = "q_aag03"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO afb02   #NO.FUN-810069 pnr02->afb02
#            END IF
#            IF INFIELD(afb041) THEN        #NO.FUN-810069 pnr03->afb041
#               CALL cl_init_qry_var()
#               LET g_qryparam.state= "c"
#               LET g_qryparam.form = "q_gem"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO afb041   #NO.FUN-810069 pnr03->afb041          
#            END IF
#            #NO.FUN-810069--start--
#            IF INFIELD(afb042) THEN
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_pja"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO afb042
#                 NEXT FIELD afb042
#            END IF
#            IF INFIELD(afb04) THEN
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_pjb"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO afb04
#                 NEXT FIELD afb04
#            END IF
#            #No.FUN-810069---end---
#   #No.TQC-790077  --End  
# 
#   ON IDLE g_idle_seconds
#      CALL cl_on_idle()
#      CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
END CONSTRUCT
#No.FUN-B20054--mark--start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#   IF tm.wc IS NULL OR tm.wc=' ' THEN LET tm.wc=' 1=1 ' END IF
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW r650_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#      EXIT PROGRAM
#         
#   END IF
#   DISPLAY BY NAME tm.more 		# Condition
#No.FUN-B20054--mark--end--
#   INPUT BY NAME  tm.more WITHOUT DEFAULTS    #No.FUN-B20054
    INPUT BY NAME  tm.more   ATTRIBUTE(WITHOUT DEFAULTS)  #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more  NOT MATCHES '[YN]' OR tm.more IS NULL  THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.FUN-B20054--mark--start--
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
#      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end--
     END INPUT 
#No.FUN-B20054--add--start--
          ON ACTION controlp
            IF INFIELD(afb00) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = g_afb00
                  CALL cl_create_qry() RETURNING g_afb00
                  DISPLAY BY NAME g_afb00
            END IF
            IF INFIELD(afb01) THEN      
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_afa"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO afb01 
             END IF
             IF INFIELD(afb02) THEN  
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_aag03"
                LET g_qryparam.where = " aag00 = '",g_afb00 CLIPPED,"'"        
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO afb02
             END IF
             IF INFIELD(afb041) THEN     
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO afb041 
             END IF
             IF INFIELD(afb042) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pja"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afb042
                  NEXT FIELD afb042
             END IF
             IF INFIELD(afb04) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pjb"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO afb04
                  NEXT FIELD afb04
             END IF
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION accept
          EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
   END DIALOG
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

#No.FUN-B20054--addend--
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r650_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc IS NULL OR tm.wc=' ' THEN LET tm.wc=' 1=1 ' END IF    #No.FUN-B20054
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr650'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr650','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr650',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r650_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr650()
   ERROR ""
END WHILE
   CLOSE WINDOW r650_w
END FUNCTION
 
FUNCTION apmr650()
   DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job   #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)  #TQC-B40063
          l_sql 	STRING,                       #TQC-B40063
          l_za05	LIKE type_file.chr1000,       # No.FUN-680136 VARCHAR(40)
          l_afa02       LIKE afa_file.afa02,          #No.FUN-830152                                                                
          l_aag02       LIKE aag_file.aag02,          #No.FUN-830152                                                                
          l_gem02       LIKE gem_file.gem02,          #No.FUN-830152     
          l_pja02       LIKE pja_file.pja02,          #No.FUN-830152 
#          sr            RECORD
#                        pnr     RECORD LIKE pnr_file.*,
#                        pns     RECORD LIKE pns_file.*
#                        END RECORD
          #No.FUN-810069--add--
          sr            RECORD
                        afb     RECORD LIKE afb_file.*,
                        afc     RECORD LIKE afc_file.*
                        END RECORD
          #No.FUN-810069--end--
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     CALL cl_del_data(l_table)   #No.FUN-830152                                                                                     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-830152   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004--------Begin--------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#           FROM azi_file WHERE azi01=g_aza.aza17
#No.CHI-6A0004-------End----------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND afbuser = '",g_user,"'"       #No.FUN-810069 pnruser->afbuser
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND afbgrup MATCHES '",g_grup CLIPPED,"*'"  #No.FUN-810069 pnrgrup->afbgrup
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND afbgrup IN ",cl_chk_tgrup_list()    #No.FUN-810069 pnrgrup->afbgrup
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
     #End:FUN-980030
 
#     LET l_sql = " SELECT * FROM pnr_file, pns_file ",    #No.FUN-810069 mark
#                 " WHERE pnr01=pns01 AND pnr02=pns02 ",
#                 "   AND pnr03=pns03 AND pnr04=pns04 ",
#                 "   AND ",tm.wc CLIPPED
     LET l_sql = " SELECT * FROM afb_file,afc_file ",
                 " WHERE afb00 = afc00 AND afb01 = afc01",
                 "   AND afb02 = afc02 AND afb03 = afc03",
                 "   AND afb04 = afc04 AND afb041 = afc041",
                 "   AND afb042 = afc042 AND ",tm.wc CLIPPED 
     PREPARE r650_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
     END IF
     DECLARE r650_cs  CURSOR FOR r650_prepare
#     CALL cl_outnam('apmr650') RETURNING l_name      #No.FUN-830152  
#     START REPORT r650_rep TO l_name                 #No.FUN-830152  
     FOREACH r650_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-830152---Begin   
      SELECT afa02 INTO l_afa02 FROM afa_file WHERE afa01=sr.afb.afb01   #No.FUN-810069 pnr->afb                                    
                                                AND afa00=g_aza.aza81   #No.FUN-740029                                              
      #No.FUN-730033  --Begin                                                                                                       
      CALL s_get_bookno(sr.afb.afb03) RETURNING g_flag,g_bookno1,g_bookno2  #No.FUN-810069 pnr04->afb03                             
      IF g_flag =  '1' THEN  #抓不到帳別                                                                                            
         CALL cl_err(sr.afb.afb03,'aoo-081',1)   #No.FUN-810069 pnr04->afb03                                                        
      END IF                                                                                                                        
      #No.FUN-730033  --End                                                                                                         
      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb.afb02        #No.FUN-810069 pnr->afb                               
                                                AND aag00=g_bookno1  #No.FUN-730033                                                 
      EXECUTE insert_prep  USING   sr.afb.afb00,sr.afb.afb01,sr.afb.afb02,sr.afb.afb03,
                                   sr.afb.afb04,sr.afb.afb041,sr.afb.afb042,sr.afc.afc05,
                                   sr.afc.afc06,sr.afc.afc07,sr.afc.afc08,sr.afc.afc09,
                                   l_afa02,l_aag02,l_gem02,l_pja02,"",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob, "N",""                 
#No.FUN-830152---End 
#       OUTPUT TO REPORT r650_rep(sr.*)
     END FOREACH
#No.FUN-830152---Begin  
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                      
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'afb00,afb03,afb01,afb02,afb041,afb042,afb04')                                                                             
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
     LET g_str=g_azi04,";",g_azi05,";",tm.wc 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                        
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "afb00" 
     CALL cl_prt_cs3('apmr650','apmr650',l_sql,g_str)  
#     FINISH REPORT r650_rep
#     ERROR ' '
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-830152---End  
END FUNCTION
#No.FUN-830152---Begin 
#REPORT r650_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
#         l_sql         LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(1000)
#         l_afa02       LIKE afa_file.afa02,
#         l_aag02       LIKE aag_file.aag02,
#         l_gem02       LIKE gem_file.gem02,
#         l_pja02       LIKE pja_file.pja02,          #No.FUN-810069 add
##          sr            RECORD                       #No.FUN-810069 mark
##                        pnr     RECORD LIKE pnr_file.*,
##                        pns     RECORD LIKE pns_file.*
##                        END RECORD
#         #No.FUN-810069--add--
#         sr            RECORD
#                       afb     RECORD LIKE afb_file.*,
#                       afc     RECORD LIKE afc_file.*
#                       END RECORD
#         #No.FUN-810069--end--
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# #  ORDER BY sr.pnr.pnr01,sr.pnr.pnr02,sr.pnr.pnr03,sr.pnr.pnr04,sr.pns.pns05   #No.FUN-810069 mark
#  ORDER BY sr.afb.afb00,sr.afb.afb03,sr.afb.afb01,sr.afb.afb02,sr.afb.afb041,sr.afb.afb042,sr.afb.afb04,sr.afc.afc05  #No.FUN-810069
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT
#     PRINT g_dash
#     SELECT afa02 INTO l_afa02 FROM afa_file WHERE afa01=sr.afb.afb01   #No.FUN-810069 pnr->afb
#                                               AND afa00=g_aza.aza81   #No.FUN-740029           
#     #No.FUN-730033  --Begin
#     CALL s_get_bookno(sr.afb.afb03) RETURNING g_flag,g_bookno1,g_bookno2  #No.FUN-810069 pnr04->afb03
#     IF g_flag =  '1' THEN  #抓不到帳別
#        CALL cl_err(sr.afb.afb03,'aoo-081',1)   #No.FUN-810069 pnr04->afb03
#     END IF
#     #No.FUN-730033  --End  
#     SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.afb.afb02        #No.FUN-810069 pnr->afb
#                                               AND aag00=g_bookno1  #No.FUN-730033
#     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.afb.afb041        #No.FUN-810069 pnr03->afb041
#     SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01 = sr.afb.afb042     #No.FUN-810069 add
##      PRINT COLUMN 01,g_x[11] CLIPPED,sr.pnr.pnr01 CLIPPED,COLUMN 40,l_afa02  #No.FUN-810069 mark
##      PRINT COLUMN 01,g_x[12] CLIPPED,sr.pnr.pnr02 CLIPPED,COLUMN 40,l_aag02
##      PRINT COLUMN 01,g_x[13] CLIPPED,sr.pnr.pnr03 CLIPPED,COLUMN 40,l_gem02
##      PRINT COLUMN 01,g_x[14] CLIPPED,sr.pnr.pnr04
#     PRINT COLUMN 01,g_x[11] CLIPPED,sr.afb.afb00    #No.FUN-810069
#     PRINT COLUMN 01,g_x[12] CLIPPED,sr.afb.afb03
#     PRINT COLUMN 01,g_x[13] CLIPPED,sr.afb.afb01 CLIPPED,COLUMN 40,l_afa02    
#     PRINT COLUMN 01,g_x[14] CLIPPED,sr.afb.afb02 CLIPPED,COLUMN 40,l_aag02
#     PRINT COLUMN 01,g_x[15] CLIPPED,sr.afb.afb041 CLIPPED,COLUMN 40,l_gem02
#     PRINT COLUMN 01,g_x[16] CLIPPED,sr.afb.afb042 CLIPPED,COLUMN 40,l_pja02
#     PRINT COLUMN 01,g_x[17] CLIPPED,sr.afb.afb04
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
##   BEFORE GROUP  OF sr.pnr.pnr04       #No.FUN-810069 mark
#   BEFORE GROUP  OF sr.afb.afb04       #No.FUN-810069
#     SKIP TO TOP OF PAGE
#   ON EVERY ROW
##      PRINT COLUMN g_c[31],sr.pns.pns05 USING '#&',                 #No.FUN-810069 mark
##            COLUMN g_c[32],cl_numfor(sr.pns.pns06,32,g_azi04),
##            COLUMN g_c[33],cl_numfor(sr.pns.pns07,33,g_azi04),
##            COLUMN g_c[34],cl_numfor(sr.pns.pns08,34,g_azi04),
##           COLUMN g_c[35],cl_numfor(sr.pns.pns09,35,g_azi04)
 
##   AFTER GROUP OF sr.pnr.pnr04
##      PRINT g_dash1
##      PRINT COLUMN g_c[31],g_x[19] CLIPPED,
##            COLUMN g_c[32],cl_numfor(GROUP SUM(sr.pns.pns06),32,g_azi05),
##            COLUMN g_c[33],cl_numfor(GROUP SUM(sr.pns.pns07),33,g_azi05),
##            COLUMN g_c[34],cl_numfor(GROUP SUM(sr.pns.pns08),34,g_azi05),
##            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.pns.pns09),35,g_azi05)
 
#  PRINT COLUMN g_c[31],sr.afc.afc05 USING '#&',                       #No.FUN-810069
#           COLUMN g_c[32],cl_numfor(sr.afc.afc06,32,g_azi04),
#           COLUMN g_c[33],cl_numfor(sr.afc.afc08,33,g_azi04),
#           COLUMN g_c[34],cl_numfor(sr.afc.afc09,34,g_azi04),
#           COLUMN g_c[35],cl_numfor(sr.afc.afc07,35,g_azi04)
 
#  AFTER GROUP OF sr.afb.afb04
#     PRINT g_dash1
#     PRINT COLUMN g_c[31],g_x[19] CLIPPED,
#           COLUMN g_c[32],cl_numfor(GROUP SUM(sr.afc.afc06),32,g_azi05),
#  

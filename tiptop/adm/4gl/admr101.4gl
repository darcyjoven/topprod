# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: admr101.4gl
# Descriptions...: 訂單追蹤延遲警訊表(天數別)
# Input parameter:
# Date & Author..: 02/07/24 By Kitty
# Modify.........: No.FUN-550035 05/05/18 By Trisy 單據編號格式放大
# Modify.........: No.MOD-590003 05/09/05 By will 報表格式對齊
# Modify.........: No.FUN-590110 05/09/26 By jackie 報表轉XML
# Modify.........: No.FUN-660090 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-850107 08/05/22 By Cockroach報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.MOD-960252 09/06/30 By Smapmin 未抓取azi04
#                                                    條件加上oeb15 <= g_today
#                                                    應依訂單項次抓取最後出貨日
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70180 10/07/23 By Sarah 權限控管段抓取的欄位fakuser與fakgrup應改為oeauser與oeagrup
# Modify.........: No:FUN-B80016 11/08/03 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				        # Print condition RECORD
              wc      STRING,                            # Where Condition  No.TQC-630166    
              omi01   LIKE omi_file.omi01,
              a1      LIKE type_file.num5,             #No.FUN-680097 SMALLINT
              a2      LIKE type_file.num5,             #No.FUN-680097 SMALLINT
              a3      LIKE type_file.num5,             #No.FUN-680097 SMALLINT
              a4      LIKE type_file.num5,             #No.FUN-680097 SMALLINT
              a5      LIKE type_file.num5,             #No.FUN-680097 SMALLINT
              a6      LIKE type_file.num5,             #No.FUN-680097 SMALLINT 
              aa     LIKE type_file.chr1,                 # 最小延遲天數 #No.FUN-680097 VARCHAR(1)
              more   LIKE type_file.chr1                  # 特殊列印條件 #No.FUN-680097 VARCHAR(1)
              END RECORD,
          l_amt1        LIKE oeb_file.oeb14
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
#No.FUN-850107 --ADD START--
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
#No.FUN-850107 --ADD END--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-850107 --ADD START--  
 LET g_sql =         "l_day.type_file.num5,", 
                     "oea03.oea_file.oea03,", 
                     "oea032.oea_file.oea032,", 
                     "oea01.oea_file.oea01,", 
                     "oeb03.oeb_file.oeb03,", 
                     "oeb15.oeb_file.oeb15,", 
                     "oga02.oga_file.oga02,", 
                     "oeb12.oeb_file.oeb12,", 
                     "oeb24.oeb_file.oeb24,", 
                     "oeb13.oeb_file.oeb13,", 
                     "ima02.ima_file.ima02,", 
                     "ima021.ima_file.ima021,", 
                     "ogb01.ogb_file.ogb01,", 
                     "oea23.oea_file.oea23,", 
                     "curr.oea_file.oea24,", 
                     "num1.oeb_file.oeb14,", 
                     "num2.oeb_file.oeb14,",
                     "num3.oeb_file.oeb14,",
                     "num4.oeb_file.oeb14,",
                     "num5.oeb_file.oeb14,",
                     "num6.oeb_file.oeb14,",
                     "num7.oeb_file.oeb14,", 
                     "num8.oeb_file.oeb14,", 
                     "l_daychar.type_file.chr8,", 
                     "azi04.azi_file.azi04 "                     
   LET l_table = cl_prt_temptable('admr101',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-850107 --ADD END--  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.omi01  = ARG_VAL(8)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.omi01  = ARG_VAL(8)
   LET tm.a1    = ARG_VAL(9)
   LET tm.a2    = ARG_VAL(10)
   LET tm.a3    = ARG_VAL(11)
   LET tm.a4    = ARG_VAL(12)
   LET tm.a5    = ARG_VAL(13)
   LET tm.a6    = ARG_VAL(14)
   LET tm.aa    = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r101_tm(0,0)	
      ELSE CALL r101()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r101_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680097 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r101_w AT p_row,p_col
        WITH FORM "adm/42f/admr101"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.aa     = '1'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON oea03,oea14,oea15,oea02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.omi01,
       tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6,tm.aa,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
          BEFORE FIELD omi01
                SELECT MIN(omi01) INTO tm.omi01 FROM omi_file
 
          AFTER FIELD omi01
                SELECT omi11,omi12,omi13,omi14,omi15,omi16
                   INTO tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6
                   FROM omi_file
                 WHERE omi01=tm.omi01
                IF status THEN
#                       CALL cl_err('omi01','axr-256',1) #No.FUN-660090
                        CALL cl_err3("sel","omi_file",tm.omi01,"","axr-256","","omi01",1)  #No.FUN-660090
                        NEXT FIELD omi01
                END IF
                DISPLAY BY NAME tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6
          AFTER FIELD aa
            IF cl_null(tm.aa) OR tm.aa NOT MATCHES '[12]' THEN
               NEXT FIELD aa
            END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
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
      LET INT_FLAG = 0
      CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='admr101'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr101','9031',1) 
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
                         " '",tm.omi01 CLIPPED,"'",
                         " '",tm.a1 CLIPPED,"'",
                         " '",tm.a2 CLIPPED,"'",
                         " '",tm.a3 CLIPPED,"'",
                         " '",tm.a4 CLIPPED,"'",
                         " '",tm.a5 CLIPPED,"'",
                         " '",tm.a6 CLIPPED,"'",
                         " '",tm.aa CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('admr101',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r101()
   ERROR ""
END WHILE
   CLOSE WINDOW r101_w
END FUNCTION
 
FUNCTION r101()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0100
          l_sql      STRING,		# RDSQL STATEMENT    
          l_za05     LIKE type_file.chr1000,          #No.FUN-680097 VARCHAR(40)
          l_rr       LIKE type_file.num5,             #No.FUN-680097 SMALLINT
          l_oeb14    LIKE oeb_file.oeb14,
          sr         RECORD
                     l_day     LIKE type_file.num5,       #天數       #No.FUN-680097 SMALLINT
                     oea03     LIKE    oea_file.oea03,    #客戶編號
                     oea032    LIKE   oea_file.oea032,    #客戶名稱
                     oea01     LIKE    oea_file.oea01,    #訂單編號
                     oeb03     LIKE    oeb_file.oeb03,    #訂單序號
                     oeb15     LIKE    oeb_file.oeb15,    #預計出貨
                     oga02     LIKE    oga_file.oga02,    #最後出貨日
                     oeb12     LIKE    oeb_file.oeb12,    #訂單量
                     oeb24     LIKE    oeb_file.oeb24,    #已出貨量
                     oeb13     LIKE    oeb_file.oeb13,    #單價
                     ima02     LIKE    ima_file.ima02,    #品名規格
                     ima021    LIKE    ima_file.ima021,   #規格
                     ogb01     LIKE    ogb_file.ogb01,    #出貨單號
                     oea23     LIKE    oea_file.oea23,    #幣別
                     curr      LIKE    oea_file.oea24,    #匯率
                     num1      LIKE    oeb_file.oeb14,    #金額
                     num2      LIKE    oeb_file.oeb14,
                     num3      LIKE    oeb_file.oeb14,
                     num4      LIKE    oeb_file.oeb14,
                     num5      LIKE    oeb_file.oeb14,
                     num6      LIKE    oeb_file.oeb14,
                     num7      LIKE    oeb_file.oeb14,
                     num8      LIKE    oeb_file.oeb14,    #No.FUN-590110
                     l_daychar LIKE    type_file.chr8,      #No.FUN-680097 VARCHAR(7)
                     azi04     LIKE    azi_file.azi04     #
                     END RECORD
#No.FUN-850107 --ADD START--
DEFINE   l_zaa1    LIKE    type_file.chr20,
         l_zaa2    LIKE    type_file.chr20,
         l_zaa3    LIKE    type_file.chr20,
         l_zaa4    LIKE    type_file.chr20,
         l_zaa5    LIKE    type_file.chr20,
         l_zaa6    LIKE    type_file.chr20,
         l_zaa7    LIKE    type_file.chr20
#No.FUN-850107 --ADD END-- 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')  #MOD-A70180 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')  #MOD-A70180
     #End:FUN-980030
#No.FUN-850107 --ADD START--
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ", 
               "        ?, ?, ?, ?, ?                )"                                                                                                            
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80016
        EXIT PROGRAM                                                                                                                 
     END IF
#No.FUN-850107 --ADD END-- 
 
     #-----MOD-960252---------
     #LET l_sql = " SELECT 0,oea03,oea032,oea01,oeb03,oeb15,max(oga02),oeb12,oeb24,oeb13,",
     #            "        ima02,ima021,ogb01,oea23,0,0,0,0,0,0,0,1 ",
     #            " FROM oea_file,oeb_file,ima_file,azi_file,",
     #            " OUTER oga_file,OUTER ogb_file ",
     #            " WHERE oea01=oeb01 ",
     #            "  AND  oea_file.oea01=oga_file.oga16 AND oeb_file.oeb03=ogb_file.ogb32",
     #            "  AND  oeb_file.oeb01=ogb_file.ogb31 AND oeb04 = ima01 AND oea23=azi01",
     #            "  AND  oeb70='N' AND oeaconf='Y' AND (oeb12-oeb24)>0",
     #            "  AND  oga_file.ogaconf='Y' AND oga_file.ogapost='Y' AND ",tm.wc CLIPPED ,
     #            " GROUP BY oea03,oea032,oea01,oeb03,oeb15,oeb12,oeb24,",
     #            " oeb13,ima02,ima021,ogb01,oea23"
     LET l_sql = " SELECT 0,oea03,oea032,oea01,oeb03,oeb15,'',oeb12,oeb24,oeb13,",
                 "        ima02,ima021,'',oea23,0,0,0,0,0,0,0,0,0,'',azi04 ",  
                 " FROM oea_file,oeb_file,ima_file,azi_file ",
                 " WHERE oea01=oeb01 ",
                 "  AND  oeb04 = ima01 AND oea23=azi01",
                 "  AND  oeb70='N' AND oeaconf='Y' AND (oeb12-oeb24)>0",
                 "  AND  ",tm.wc CLIPPED ,
                 "  AND  oeb15 <= '",g_today,"' ",   
                 " GROUP BY oea03,oea032,oea01,oeb03,oeb15,oeb12,oeb24,",
                 " oeb13,ima02,ima021,oea23,azi04"   
     #-----END MOD-960252-----
 
 
     PREPARE r101_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
     DECLARE r101_c1 CURSOR FOR r101_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
        EXIT PROGRAM
     END IF
#     CALL cl_outnam('admr101') RETURNING l_name             #No.FUN-850107 MARK
#No.FUN-590110 --start
     IF tm.aa='1' THEN
        LET g_zaa[31].zaa06='Y'
        LET g_zaa[43].zaa06='Y'
        LET g_zaa[36].zaa06='N'
        LET g_zaa[37].zaa06='N'
        LET g_zaa[38].zaa06='N'
        LET g_zaa[39].zaa06='N'
        LET g_zaa[40].zaa06='N'
        LET g_zaa[41].zaa06='N'
        LET g_zaa[42].zaa06='N'
     ELSE
        LET g_zaa[31].zaa06='N'
        LET g_zaa[43].zaa06='N'
        LET g_zaa[36].zaa06='Y'
        LET g_zaa[37].zaa06='Y'
        LET g_zaa[38].zaa06='Y'
        LET g_zaa[39].zaa06='Y'
        LET g_zaa[40].zaa06='Y'
        LET g_zaa[41].zaa06='Y'
        LET g_zaa[42].zaa06='Y'
     END IF
     CALL cl_prt_pos_len()
 
#     START REPORT r101_rep TO l_name          #No.FUN-850107 MARK
#No.FUN-590110 --end
 
     LET l_amt1 = 0
     LET g_pageno = 0
     FOREACH r101_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #-----MOD-960252---------
       SELECT max(oga02),ogb01 INTO sr.oga02,sr.ogb01 
         FROM oga_file,ogb_file
        WHERE ogb31 = sr.oea01 AND ogb32 = sr.oeb03 
          AND ogaconf = 'Y' AND ogapost = 'Y'  
          AND oga01 = ogb01
         GROUP BY ogb01
       #-----END MOD-960252-----
       LET sr.l_day=g_today-sr.oeb15
       CALL s_curr3(sr.oea23,g_today,'B')
        RETURNING sr.curr
       #依客戶的金額判斷
       LET l_oeb14=(sr.oeb12-sr.oeb24)*sr.oeb13*sr.curr
       IF tm.aa='1' THEN
           CASE WHEN sr.l_day <=tm.a1 LET sr.num1=l_oeb14
                WHEN sr.l_day <=tm.a2 LET sr.num2=l_oeb14
                WHEN sr.l_day <=tm.a3 LET sr.num3=l_oeb14
                WHEN sr.l_day <=tm.a4 LET sr.num4=l_oeb14
                WHEN sr.l_day <=tm.a5 LET sr.num5=l_oeb14
                WHEN sr.l_day <=tm.a6 LET sr.num6=l_oeb14
                OTHERWISE            LET sr.num7=l_oeb14
           END CASE
       ELSE
           LET sr.num8=l_oeb14   #依天數別的金額
           CASE WHEN sr.l_day <=tm.a1 LET sr.l_day=tm.a1
                                      LET sr.l_daychar='0-',tm.a1 USING '###'
                WHEN sr.l_day <=tm.a2 LET sr.l_day=tm.a2
                                      LET sr.l_daychar=tm.a1+1 USING '###','-',tm.a2 USING '###'
                WHEN sr.l_day <=tm.a3 LET sr.l_day=tm.a3
                                      LET sr.l_daychar=tm.a2+1 USING '###','-',tm.a3 USING '###'
                WHEN sr.l_day <=tm.a4 LET sr.l_day=tm.a4
                                      LET sr.l_daychar=tm.a3+1 USING '###','-',tm.a4 USING '###'
                WHEN sr.l_day <=tm.a5 LET sr.l_day=tm.a5
                                      LET sr.l_daychar=tm.a4+1 USING '###','-',tm.a5 USING '###'
                WHEN sr.l_day <=tm.a6 LET sr.l_day=tm.a6
                                      LET sr.l_daychar=tm.a5+1 USING '###','-',tm.a6 USING '###'
                OTHERWISE             LET sr.l_day=tm.a6+1
                                      LET sr.l_daychar=tm.a6+1 USING '###','以上'
           END CASE
       END IF
 
#No.FUN-850107 --ADD START--  
      LET l_zaa1='0-',tm.a1 USING '###'
      LET l_zaa2=tm.a1+1 USING '###','-',tm.a2 USING '###'
      LET l_zaa3=tm.a2+1 USING '###','-',tm.a3 USING '###'
      LET l_zaa4=tm.a3+1 USING '###','-',tm.a4 USING '###'
      LET l_zaa5=tm.a4+1 USING '###','-',tm.a5 USING '###'
      LET l_zaa6=tm.a5+1 USING '###','-',tm.a6 USING '###'
      LET l_zaa7=tm.a6+1 USING '###'
 
     EXECUTE  insert_prep  USING  
     sr.l_day,sr.oea03,sr.oea032,sr.oea01,sr.oeb03,sr.oeb15,sr.oga02,
     sr.oeb12,sr.oeb24,sr.oeb13,sr.ima02,sr.ima021,sr.ogb01,sr.oea23,
     sr.curr,sr.num1,sr.num2,sr.num3,sr.num4,sr.num5,sr.num6,sr.num7,
     sr.num8,sr.l_daychar,sr.azi04 
 
   END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
   IF g_zz05 = 'Y' THEN                                                                                                            
      CALL cl_wcchp(tm.wc,'oea03,oea14,oea15,oea02')                                                                                           
           RETURNING tm.wc                                                                                                         
      LET g_str = tm.wc                                                                                                            
   END IF
   LET g_str = g_str,";",l_zaa1,";",l_zaa2,";",l_zaa3,";",l_zaa4,";",l_zaa5
                    ,";",l_zaa6,";",l_zaa7,";",tm.aa
   IF tm.aa = '1' THEN 
      CALL cl_prt_cs3('admr101','admr101',l_sql,g_str)   
   ELSE 
      CALL cl_prt_cs3('admr101','admr101_1',l_sql,g_str) 
   END IF
#No.FUN-850107 --ADD END--
 
#No.FUN-850107 --MARK START--  
##No.FUN-590110 --start
#      OUTPUT TO REPORT r101_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT r101_rep
#No.FUN-590110 --end
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r101_rep(sr)
#  DEFINE l_last_sw     LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
#         l_amt         LIKE oeb_file.oeb14,
#          sr        RECORD
#                    l_day     LIKE    type_file.num5,       #天數       #No.FUN-680097 SMALLINT
#                    oea03     LIKE    oea_file.oea03,    #客戶編號
#                    oea032    LIKE    oea_file.oea032,   #客戶名稱
#                    oea01     LIKE    oea_file.oea01,    #訂單編號
#                    oeb03     LIKE    oeb_file.oeb03,    #訂單序號
#                    oeb15     LIKE    oeb_file.oeb15,    #預計出貨
#                    oga02     LIKE    oga_file.oga02,    #最後出貨日
#                    oeb12     LIKE    oeb_file.oeb12,    #訂單量
#                    oeb24     LIKE    oeb_file.oeb24,    #已出貨量
#                    oeb13     LIKE    oeb_file.oeb13,    #單價
#                    ima02     LIKE    ima_file.ima02,    #品名規格
#                    ima021    LIKE    ima_file.ima021,   #規格
#                    ogb01     LIKE    ogb_file.ogb01,    #出貨單號
#                    oea23     LIKE    oea_file.oea23,    #幣別
#                    curr      LIKE    oea_file.oea24,    #匯率
#                    num1      LIKE    oeb_file.oeb14,    #金額
#                    num2      LIKE    oeb_file.oeb14,
#                    num3      LIKE    oeb_file.oeb14,
#                    num4      LIKE    oeb_file.oeb14,
#                    num5      LIKE    oeb_file.oeb14,
#                    num6      LIKE    oeb_file.oeb14,
#                    num7      LIKE    oeb_file.oeb14,
#                    num8      LIKE    oeb_file.oeb14,  #No.FUN-590110
#                    l_daychar LIKE    type_file.chr8,   #No.FUN-680097 
#                    azi04     LIKE    azi_file.azi04     #
#                    END RECORD
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#No.FUN-590110 --start--
# ORDER BY sr.l_day,sr.oea03,sr.oea01,sr.oeb03
#No.FUN-590110 --end--
 
# FORMAT
#  PAGE HEADER
#No.FUN-590110 --start
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED,pageno_total
 
#     LET g_zaa[36].zaa08='0-',tm.a1 USING '###'
#     LET g_zaa[37].zaa08=tm.a1+1 USING '###','-',tm.a2 USING '###'
#     LET g_zaa[38].zaa08=tm.a2+1 USING '###','-',tm.a3 USING '###'
#     LET g_zaa[39].zaa08=tm.a3+1 USING '###','-',tm.a4 USING '###'
#     LET g_zaa[40].zaa08=tm.a4+1 USING '###','-',tm.a5 USING '###'
#     LET g_zaa[41].zaa08=tm.a5+1 USING '###','-',tm.a6 USING '###'
#     LET g_zaa[42].zaa08=tm.a6+1 USING '###',g_x[23] CLIPPED
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#      PRINT g_dash1
#No.FUN-590110 --end--
#     LET l_last_sw = 'n'
 
#No.FUN-590110 --start
#  BEFORE GROUP OF sr.l_day
#   IF tm.aa<>'1' THEN
#     PRINT COLUMN g_c[31],sr.l_daychar;
#   END IF
 
#  BEFORE GROUP OF sr.oea03
#     PRINT COLUMN g_c[32],sr.oea032 CLIPPED;
 
#  BEFORE GROUP OF sr.oea01
#     PRINT COLUMN g_c[33],sr.oea01 CLIPPED;
 
#  AFTER GROUP OF sr.oeb03
#     PRINT COLUMN g_c[34], sr.oeb15,
#           COLUMN g_c[35],sr.oga02,
#           COLUMN g_c[36],cl_numfor(sr.num1,36,sr.azi04),  #金額
#           COLUMN g_c[37],cl_numfor(sr.num2,37,sr.azi04),  #金額
#           COLUMN g_c[38],cl_numfor(sr.num3,38,sr.azi04),  #金額
#           COLUMN g_c[39],cl_numfor(sr.num4,39,sr.azi04),  #金額
#           COLUMN g_c[40],cl_numfor(sr.num5,40,sr.azi04),  #金額
#           COLUMN g_c[41],cl_numfor(sr.num6,41,sr.azi04),  #金額
#           COLUMN g_c[42],cl_numfor(sr.num7,42,sr.azi04),  #金額
#           COLUMN g_c[43],cl_numfor(sr.num8,43,sr.azi04),  #金額
#           COLUMN g_c[44],sr.ima02 CLIPPED,
#           COLUMN g_c[45],sr.ima021 CLIPPED     #No.FUN-550035
 
#  AFTER GROUP OF sr.oea03
#     #No.FUN-550035 --start--
#     PRINT
#     PRINT COLUMN g_c[35],g_x[17] CLIPPED,
#           COLUMN g_c[36],cl_numfor(GROUP SUM(sr.num1),36,sr.azi04),
#           COLUMN g_c[37],cl_numfor(GROUP SUM(sr.num2),37,sr.azi04),
#           COLUMN g_c[38],cl_numfor(GROUP SUM(sr.num3),38,sr.azi04),
#           COLUMN g_c[39],cl_numfor(GROUP SUM(sr.num4),39,sr.azi04),
#           COLUMN g_c[40],cl_numfor(GROUP SUM(sr.num5),40,sr.azi04),
#           COLUMN g_c[41],cl_numfor(GROUP SUM(sr.num6),41,sr.azi04),
#           COLUMN g_c[42],cl_numfor(GROUP SUM(sr.num7),42,sr.azi04)
#     #No.FUN-550035 ---end---
 
#  AFTER GROUP OF sr.l_day
#    IF tm.aa<>'1' THEN
#     PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+1+g_w[32]+1+g_w[33]+1+g_w[34]+1+g_w[35]+1+g_w[43]]
#     PRINT COLUMN g_c[34],g_x[17] CLIPPED,        #No.FUN-550035
#           COLUMN g_c[43],cl_numfor(GROUP SUM(sr.num8),43,sr.azi04)
#    END IF
 
#  ON LAST ROW
#     #No.FUN-550035 --start--
#    IF tm.aa='1' THEN
#           COLUMN g_c[41],cl_numfor(SUM(sr.num6),41,sr.azi04),
#           COLUMN g_c[42],cl_numfor(SUM(sr.num7),42,sr.azi04)
#    ELSE
#     PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+1+g_w[32]+1+g_w[33]+1+g_w[34]+1+g_w[35]+1+g_w[43]]
#     PRINT COLUMN g_c[34],g_x[18] CLIPPED,        #No.FUN-550035
#           COLUMN g_c[43],cl_numfor(SUM(sr.num8),43,sr.azi04)
#    END IF
#No.FUN-590110 --end--
#     #No.FUN-550035 ---end---
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT g_dash[1,g_len]
#        #No.TQC-630166 --start--
#             IF tm.wc[001,80] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#        #No.TQC-630166 ---end---
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-7), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850107 MARK END
 
#Patch....NO.TQC-610035 <> #
#FUN-870144

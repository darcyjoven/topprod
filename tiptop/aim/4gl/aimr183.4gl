# Prog. Version..: '5.30.06-13.04.12(00010)'     #
#
# Pattern name...: aimr183.4gl
# Desc/riptions..: 新增料件資料狀況表
# Input parameter:
# Return code....:
# Date & Author..: 91/12/02 By MAY
#       Modify   : 92/05/23 By David
#                  By Melody   新增'建立日期範圍'欄位 QBE
# Modify.........: No.FUN-4A0039 04/10/07 By Smapmin 增加料號開窗功能
# Modify.........: No.FUN-510017 05/01/10 By Mandy 報表轉XML
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.MOD-680031 06/08/08 By 沒勾選任何跳頁，資料還是會依料號跳頁
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-750097 07/05/30 By cheunl  報表轉成CR
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.MOD-810160 08/03/06 By Carol 調整ima93資料寫入改用l_str
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0195 10/11/29 By chenying 打印條件未轉換成中文
# Modify.........: No.TQC-CC0069 12/12/11 By qirl 增加開窗
# Modify.........: No.MOD-D40072 13/04/12 By bart 料件開窗加上imaacti <>'N'
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#CHI-710051 
 
DEFINE tm     RECORD                           # Print condition RECORD
              wc       STRING,                 # Where condition      #TQC-630166
              s        LIKE type_file.chr3,    # Order by sequence    #No.FUN-690026 VARCHAR(3)
              t        LIKE type_file.chr3,    # Eject sw             #No.FUN-690026 VARCHAR(3)
              y        LIKE type_file.chr1,    # Group print seqence  #No.FUN-690026 VARCHAR(1)
              more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
              END RECORD,
       g_aza17         LIKE aza_file.aza17     # 本國幣別
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE l_table        STRING,                 #No.FUN-750097     
       g_str          STRING,                 #No.FUN-750097     
       g_sql          STRING                  #No.FUN-750097
 
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
#No.FUN-750097 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>                                                    
    LET g_sql = " ima01.ima_file.ima01,", 
                " ima02.ima_file.ima02, ", 
                " ima021.ima_file.ima021, ", 
                " ima05.ima_file.ima05, ", 
                " ima06.ima_file.ima06, ", 
                " ima09.ima_file.ima09, ", 
                " ima10.ima_file.ima10, ", 
                " ima11.ima_file.ima11, ", 
                " ima12.ima_file.ima12, ", 
                " ima08.ima_file.ima08, ", 
                " ima93.ima_file.ima93 "
                                                                                                                                    
    LET l_table = cl_prt_temptable('aimr183',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ?)"
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------  
 
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r100_tm(0,0)		# Input print condition
      ELSE CALL aimr183()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r100_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "aim/42f/aimr183"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.t    = 'Y  '
   LET tm.y    = '0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = '1'
   LET tm2.s2   = '2'
   LET tm2.s3   = '3'
   LET tm2.t1   = 'Y'
   LET tm2.t2   = 'N'
   LET tm2.t3   = 'N'
WHILE TRUE
   DISPLAY BY NAME tm.s,tm.t,tm.y,tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima06,ima09,ima10,
                              ima11,ima12,ima08,ima901
#FUN-4A0039增加料號開窗功能
#---TQC-CC0069--add--star--
        ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               #LET g_qryparam.form     = "q_ima"  #MOD-D40072
               LET g_qryparam.form     = "q_ima011"  #MOD-D40072
               LET g_qryparam.where = " imaacti <>'N' "  #MOD-D40072
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            WHEN INFIELD(ima06)
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
            WHEN INFIELD(ima09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima09_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima09
            WHEN INFIELD(ima10)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima10_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima09
               NEXT FIELD ima10
            WHEN INFIELD(ima11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima11_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima11
               NEXT FIELD ima11
            WHEN INFIELD(ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_ima12_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            OTHERWISE EXIT CASE
         END CASE
#---TQC-CC0069--add-end---
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.t,tm.y,tm.more # Condition
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm.y,tm.more
                WITHOUT DEFAULTS
      AFTER FIELD y
         IF tm.y NOT MATCHES "[0-4]" OR tm.y IS NULL
            THEN NEXT FIELD y
         END IF
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
      ON ACTION CONTROLP CALL r100_wc()       # Input detail Where Condition
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1[1,1],tm2.t2[1,1],tm2.t3[1,1]     #No.MOD-680031 add
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
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr183'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr183','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.y CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr183',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr183()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r100_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(350)
   OPEN WINDOW aimr183_w2 AT 2,2
        WITH FORM "aim/42f/aimi100"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi100")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
        ima02, ima03, ima13, ima14, ima70,
        ima57, ima15,
        ima09, ima10, ima11, ima12, ima07,
        ima37, ima38, ima51, ima52,
        ima04, ima18, ima19, ima20,
        ima21, ima22, ima34, ima42,
        ima29, imauser, imagrup,
        imamodu, imadate, imaacti
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
  CLOSE WINDOW aimr183_w2
  LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW r100_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
     EXIT PROGRAM
        
  END IF
END FUNCTION
 
FUNCTION aimr183()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	STRING,    		        # RDSQL STATEMENT  #TQC-630166
          l_za05	LIKE za_file.za05,              #No.FUN-690026 VARCHAR(40)
          i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_str         LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(20)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01  LIKE ima_file.ima01,
                               ima02  LIKE ima_file.ima02,
                               ima021 LIKE ima_file.ima021, #FUN-510017
                               ima05  LIKE ima_file.ima05,
                               ima06  LIKE ima_file.ima06,
                               ima09  LIKE ima_file.ima09,
                               ima10  LIKE ima_file.ima10,
                               ima11  LIKE ima_file.ima11,
                               ima12  LIKE ima_file.ima12,
                               ima08  LIKE ima_file.ima08,
                               ima93  LIKE ima_file.ima93,
                               ima901 LIKE ima_file.ima901
                        END RECORD
     CALL cl_del_data(l_table)                            #No.FUN-750097
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-750097
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
                 " ima01,ima02,ima021,ima05,ima06,ima09,ima10,ima11,ima12, ", #FUN-510017 add ima021
                 " ima08,ima93 ",
                 " FROM ima_file ",
                 " WHERE ", tm.wc CLIPPED ,
                 " ORDER BY ima01 "
 
     PREPARE r100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r100_cs1 CURSOR FOR r100_prepare1
#    CALL cl_outnam('aimr183') RETURNING l_name          #No.FUN-750097
#    START REPORT r100_rep TO l_name                     #No.FUN-750097
 
     FOREACH r100_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
       IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
       IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
#No.FUN-750097--------start----------------
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
#              WHEN tm.s[g_i,g_i] = '3'
#              CASE
#                  WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
#                  WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
#                  WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
#                  WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
#                  WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
#              END CASE
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima08
#              WHEN tm.s[g_i,g_i] = '5'
#                   LET l_order[g_i] = sr.ima901 USING 'yyyymmdd'
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
      IF sr.ima93 = 'YYYYYYYY' THEN 
         LET sr.ima93 = " " CLIPPED
         EXECUTE insert_prep USING                                                                                                
                 sr.ima01,sr.ima02,sr.ima021,sr.ima05,sr.ima06,
                 sr.ima09,sr.ima10,sr.ima11,sr.ima12,sr.ima08,sr.ima93
      ELSE
         FOR i = 1 TO 8
             IF sr.ima93[i,i] != 'Y' AND sr.ima93[i,i] != 'y'
                      OR sr.ima93[i,i] IS NULL THEN
                LET l_str = ' '                #MOD-810160-add
                CASE
#MOD-810160-modify
                    WHEN i = 1  LET l_str = "1" CLIPPED
                    WHEN i = 2  LET l_str = "2" CLIPPED
                    WHEN i = 3  LET l_str = "3" CLIPPED
                    WHEN i = 4  LET l_str = "4" CLIPPED
                    WHEN i = 5  LET l_str = "5" CLIPPED
                    WHEN i = 6  LET l_str = "6" CLIPPED
                    WHEN i = 7  LET l_str = "7" CLIPPED
                    WHEN i = 8  LET l_str = "8" CLIPPED
#MOD-810160-modify-end
                END CASE
                EXECUTE insert_prep USING                                                                                                
                        sr.ima01,sr.ima02,sr.ima021,sr.ima05,sr.ima06,
                        sr.ima09,sr.ima10,sr.ima11,sr.ima12,sr.ima08,l_str  #MOD-810160-modify
              END IF
          END FOR
       END IF
#      EXECUTE insert_prep USING                                                                                                
#              sr.ima01,sr.ima02,sr.ima021,sr.ima05,sr.ima06,
#              sr.ima09,sr.ima10,sr.ima11,sr.ima12,sr.ima08,sr.ima93
#      OUTPUT TO REPORT r100_rep(sr.*)
#No.FUN-750097--------end------------------
     END FOREACH
#No.FUN-750097--------------start--------------
#    FINISH REPORT r100_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET l_sql = "SELECT distinct * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     LET g_str = ''           
    #是否列印選擇條件         
    IF g_zz05 = 'Y' THEN     
#TQC-AB0195----mod--------------str---------------- 
#      CALL cl_wcchp(tm.wc,'ima12,ima75,ima76')    
       CALL cl_wcchp(tm.wc,'ima01,ima05,ima06,ima09,ima10,
                              ima11,ima12,ima08,ima901')
#TQC-AB0195----mod--------------end------------------    
            RETURNING tm.wc                  
       LET g_str = tm.wc                     
    END IF 
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",
                tm.y  
    CALL cl_prt_cs3('aimr183','aimr183',l_sql,g_str)
#No.FUN-750097--------------end----------------
END FUNCTION
 
{REPORT r100_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_str         LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(20)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr            RECORD order1 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order3 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01  LIKE ima_file.ima01,
                               ima02  LIKE ima_file.ima02,
                               ima021 LIKE ima_file.ima021, #FUN-510017
                               ima05  LIKE ima_file.ima05,
                               ima06  LIKE ima_file.ima06,
                               ima09  LIKE ima_file.ima09,
                               ima10  LIKE ima_file.ima10,
                               ima11  LIKE ima_file.ima11,
                               ima12  LIKE ima_file.ima12,
                               ima08  LIKE ima_file.ima08,
                               ima93  LIKE ima_file.ima93,
                               ima901 LIKE ima_file.ima901
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima021,
            COLUMN g_c[34],sr.ima05,
            COLUMN g_c[35],sr.ima08;
      FOR i = 1 TO 8
          IF sr.ima93[i,i] != 'Y' AND sr.ima93[i,i] != 'y'
                   OR sr.ima93[i,i] IS NULL THEN
             CASE
                 WHEN i = 1  LET l_str = g_x[14] CLIPPED
                 WHEN i = 2  LET l_str = g_x[15] CLIPPED
                 WHEN i = 3  LET l_str = g_x[16] CLIPPED
                 WHEN i = 4  LET l_str = g_x[17] CLIPPED
                 WHEN i = 5  LET l_str = g_x[18] CLIPPED
                 WHEN i = 6  LET l_str = g_x[19] CLIPPED
                 WHEN i = 7  LET l_str = g_x[20] CLIPPED
                 WHEN i = 8  LET l_str = g_x[21] CLIPPED
             END CASE
             PRINT COLUMN g_c[36],l_str CLIPPED
             LET l_str = NULL
           END IF
       END FOR
       PRINT ' '
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash
        #TQC-630166
        #      IF tm.wc[001,070] > ' ' THEN			# for 80
 	#         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #      IF tm.wc[071,140] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #      IF tm.wc[141,210] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #      IF tm.wc[211,280] > ' ' THEN
  	#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
      END IF
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}

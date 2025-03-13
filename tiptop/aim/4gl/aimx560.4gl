# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: aimx560.4gl
# Descriptions...: 料件庫存異常表
# Return code....:
# Date & Author..: 94/7/1 By Nick
#-------MODIFICATION-------MODIFICATION-------MODIFIACTION-------
#
#
#------BugFIXED------------BugFIXED-----------BugFIXED-----------
# Modify.........: No.FUN-510017 05/01/26 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-750093 06/05/25 By zhoufeng 普通報表打印轉CR報表打印
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40023 10/04/04 By vealxu ima26x 調整
# Modify.........: No.TQC-A70003 10/07/02 By huangtao 添加營運中心欄位
# Modify.........: No:MOD-B90166 11/09/26 By johung by料將所有庫存數量加總
# Modify.........: No:FUN-CB0004 12/11/02 By dongsz CR轉XtraGrid 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
           wc1    STRING,                 # Where Condition  #TQC-630166
           wc2    STRING,                #TQC-A70003
           c     LIKE type_file.chr1,    # if <0  #No.FUN-690026 VARCHAR(1)
           day   LIKE type_file.num5,    # 呆滯日期  #No.FUN-690026 SMALLINT
           high  LIKE type_file.chr1,    #  #No.FUN-690026 VARCHAR(1)
           safe  LIKE type_file.chr1,    #  #No.FUN-690026 VARCHAR(1)
           more  LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD,
       l_done LIKE type_file.num5        #No.FUN-690026 SMALLINT
DEFINE g_i    LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE l_table STRING    #FUN-A40023
DEFINE g_sql   STRING    #FUN-A40023
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING 

 
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

#No.FUN-A40023 -----------start-----------------
    LET g_sql = " ima01.ima_file.ima01,",
                " ima02.ima_file.ima02,",
                " ima021.ima_file.ima021,",
                " ima25.ima_file.ima25,",
                " avl_stk_mpsmrp.type_file.num15_3,",
                " ima27.ima_file.ima27,",
                " ima271.ima_file.ima271,",        #TQC-A70003
                " ima902.ima_file.ima902,",
                " imgplant.img_file.imgplant,",     #TQC-A70003
                " l_diff.type_file.num10,",        #FUN-CB0004 add
                " l_over.ima_file.ima271,",        #FUN-CB0004 add
                " l_short.ima_file.ima27,",        #FUN-CB0004 add
                " l_pot.type_file.num5 "           #FUN-CB0004 add

    LET l_table = cl_prt_temptable('aimx560',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) "      #TQC-A70003  #FUN-CB0004 add 4?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#No.FUN-A40023---------------end------------


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc2 = ARG_VAL(7)
   LET tm.c  = ARG_VAL(8)
   LET tm.day  = ARG_VAL(9)
   LET tm.high  = ARG_VAL(10)
   LET tm.safe = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL x560_tm()	        	# Input print condition
      ELSE CALL aimx560()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION x560_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE l_cmd         LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE tok            base.StringTokenizer 
DEFINE l_zxy03        LIKE zxy_file.zxy03 
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW x560_w AT p_row,p_col
        WITH FORM "aim/42f/aimx560"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c       = 'Y'
   LET tm.high    = 'Y'
   LET tm.safe    = 'Y'
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
#TQC-A70003 ---start
   CONSTRUCT BY NAME tm.wc1 ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         AFTER FIELD azp01 
            LET g_chk_azp01 = TRUE 
            LET g_azp01_str = get_fldbuf(azp01)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azp01_str) AND g_azp01_str <> "*" THEN
               LET g_chk_azp01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azp01_str,"|") 
               LET g_azp01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_azp01
                  IF STATUS THEN 
                     CONTINUE WHILE  
                  ELSE
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",l_zxy03,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                     END IF 
                  END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF  
            END IF 
            IF g_chk_azp01 THEN
               DECLARE x560_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH x560_zxy_cs1 INTO l_zxy03 
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF 
            END IF

            
            
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw01"     
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
            END CASE
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about          
            CALL cl_about()       
 
         ON ACTION help           
            CALL cl_show_help()   
 
         ON ACTION controlg       
            CALL cl_cmdask()     
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
            
         ON ACTION qbe_select
            CALL cl_qbe_select()
            
      END CONSTRUCT
       
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW x560_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

#      IF cl_null(tm.wc1) THEN
#         LET tm.wc1 = " azp01 = '",g_plant,"'" 
#      END IF
#TQC-A70003 ---end
   
   CONSTRUCT BY NAME tm.wc2 ON ima01    #TQC-A70003
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
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
      LET INT_FLAG = 0 CLOSE WINDOW x560_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF cl_null(tm.wc2) THEN
      LET tm.wc2 = " 1=1"
   END IF
   INPUT BY NAME tm.c,tm.high,tm.safe,tm.day,
				 tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES "[YN]"
            THEN NEXT FIELD c
         END IF
 
      AFTER FIELD day
         IF tm.day < 0
            THEN NEXT FIELD day
         END IF
 
      AFTER FIELD high
         IF cl_null(tm.high) OR tm.high NOT MATCHES "[YN]"
            THEN NEXT FIELD high
         END IF
 
      #No.B059 010322 by linda add
      AFTER FIELD safe
         IF cl_null(tm.safe) OR tm.safe NOT MATCHES "[YN]"
            THEN NEXT FIELD safe
         END IF
      #No.B059 end -----
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
	AFTER INPUT
		IF INT_FLAG THEN EXIT INPUT END IF
		IF tm.c='N'
			AND cl_null(tm.day)
            AND tm.high ='N'
			AND tm.safe ='N' THEN
			NEXT FIELD c
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
      LET INT_FLAG = 0 CLOSE WINDOW x560_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimx560'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('aimx560','9031',1)
      ELSE
         LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.day CLIPPED,"'",
                         " '",tm.high CLIPPED,"'",
                         " '",tm.safe CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimx560',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW x560_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimx560()
   ERROR ""
END WHILE
   CLOSE WINDOW x560_w
END FUNCTION
 
FUNCTION aimx560()
   DEFINE l_plant   LIKE  azp_file.azp01    #TQC-A70003
   DEFINE l_azp02   LIKE  azp_file.azp02    #TQC-A70003
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql         STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr		LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_ima271  LIKE ima_file.ima271,
          maxstk    LIKE ima_file.ima271,
          sr            RECORD
                        ima01  LIKE ima_file.ima01, #料件編號
                        ima02  LIKE ima_file.ima02, #品名規格
                        ima021 LIKE ima_file.ima021,#品名規格
                        ima25  LIKE ima_file.ima25, #庫存單位
#                       ima26  LIKE ima_file.ima26, #MPS/MRP可用量    #FUN-A40023
                        avl_stk_mpsmrp LIKE type_file.num15_3,        #FUN-A40023         
                        ima27  LIKE ima_file.ima27, #安全存量/再補貨點
                        ima271 LIKE ima_file.ima271, #最高儲存數量
                        rty13  LIKE rty_file.rty13,
                        ima902 LIKE ima_file.ima902, #呆滯日期
                        imgplant LIKE img_file.imgplant,    #TQC-A70003
                        l_diff LIKE type_file.num10,    #FUN-CB0004 add
                        l_over LIKE ima_file.ima271,    #FUN-CB0004 add
                        l_short LIKE ima_file.ima27,    #FUN-CB0004 add
                        l_pot  LIKE type_file.num5      #FUN-CB0004 add
                        END RECORD
   DEFINE g_str         STRING                      #No.FUN-750093add
      CALL cl_del_data(l_table)
    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth,
                " ORDER BY azp01 "
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 
    FOREACH sel_azp01_cs INTO l_plant,l_azp02  
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-750093
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
#    LET l_sql = "SELECT ima01, ima02, ima021 , ima25, ima26,  ",             #FUN-A40023
#     LET l_sql = "SELECT ima01, ima02, ima021 , ima25, img10*img21,  ",       #FUN-A40023 
#                 " ima27, ima271, ima902 ",                        
#                 "  FROM ima_file LEFT OUTER JOIN img_file ON ima01 = img01",  #FUN-A40023 add img_file
#                 " WHERE ",tm.wc CLIPPED, " AND imaacti = 'Y' "                  
#MOD-B90166 -- mark begin --
   #LET l_sql = " SELECT ima01, ima02, ima021 , ima25, img10*img21,  ",       
   #             " ima27, ima271,rty13,ima902 , imgplant ",                                 #TQC-A70003                      
   #             " FROM ",cl_get_target_table(l_plant,'ima_file'),
   #             " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'img_file'),
   #             " ON ima01 = img01 ",
   #             " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rty_file'),
   #             " ON (rty01 =ima01  AND rty02 = imgplant ) ",
   #             " WHERE ",tm.wc2 CLIPPED, " AND imaacti = 'Y' ",                #TQC-A70003
   #             " AND imgplant ='",l_plant,"'"
   #         
   # LET l_done=0
   # IF tm.c='Y' THEN
#  #    LET l_sql = l_sql CLIPPED, " AND ima26 < 0 "        #FUN-A40023
   #    LET l_sql = l_sql CLIPPED, " AND img10*img21 < 0 "  #FUN-A40023 
   #    LET l_done=1
   # END IF
   # IF NOT cl_null(tm.day) THEN
   #    IF l_done = 1 THEN
   #      LET l_sql = l_sql CLIPPED, " UNION SELECT ",
#  #                   " ima01, ima02, ima021 , ima25, ima26,  ",            #FUN-A40023
   #                   " ima01, ima02, ima021 , ima25, img10*img21,  ",      #FUN-A40023
   #                   " ima27, ima271,rty13,ima902, imgplant ",                #TQC-A70003  add imgplant
   #                   " FROM ",cl_get_target_table(l_plant,'ima_file'),
   #                   " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'img_file'),
   #                   " ON ima01 = img01,DUAL ",
   #                   " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rty_file'),
   #                   " ON (rty01 =ima01  AND rty02 = imgplant )",
   #                   "WHERE ",tm.wc2 CLIPPED,   #FUN-A40023 add img_file
   #                   " AND imaacti = 'Y' ",
   #                   " AND imgplant ='",l_plant,"'"
   #           
   #       LET l_sql = l_sql CLIPPED, " AND (sysdate - ima902) > ",tm.day
   #     ELSE
   #       LET l_sql = l_sql CLIPPED, " AND (sysdate - ima902) > ",tm.day
   #       LET l_done = 1
   #     END IF
   # END IF


   # IF tm.high = 'Y' THEN
   #    IF l_done = 1 THEN
   #        LET l_sql = l_sql CLIPPED, " UNION SELECT  ",
#  #                    " ima01, ima02, ima021, ima25, ima26,  ",                #FUN-A40023
   #                    " ima01, ima02, ima021, ima25, img10*img21,  ",          #FUN-A40023    
   #                    " ima27,ima271,rty13 ,ima902, imgplant ",                     #TQC-A70003  add imgplant
   #                    " FROM ", cl_get_target_table(l_plant,'ima_file'),
   #                    " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'img_file'),
   #                    " ON ima01 = img01 ",
   #                    " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rty_file'),
   #                    " ON (rty01 =ima01  AND rty02 = imgplant )",
   #                    " WHERE ",tm.wc2 CLIPPED, " AND imaacti = 'Y' ",
   #                    " AND imgplant ='",l_plant,"'"
   #               
   #      # LET l_sql = l_sql CLIPPED, " AND ima26 > ima271 "   #No.B059
#  #        LET l_sql = l_sql CLIPPED, " AND (ima26 > ima271 AND ima271>0) "      #FUN-A40023
   #        LET l_sql = l_sql CLIPPED, " AND ((img10*img21 > rty13 AND rty13>0) ", #FUN-A40023
   #                                   " OR (img10*img21 > ima271 AND ima271>0))"
   #    ELSE
   #      # LET l_sql = l_sql CLIPPED, " AND ima26 > ima271 "   #No.B059
#  #        LET l_sql = l_sql CLIPPED, " AND (ima26 > ima271 AND ima271>0) "      #FUN-A40023
   #        LET l_sql = l_sql CLIPPED, " AND ((img10*img21 > rty13 AND rty13>0) ",#FUN-A40023
   #                                    " OR (img10*img21 > ima271 AND ima271>0))"  
   #        LET l_done =1
   #    END IF
   # END IF

   # IF tm.safe = 'Y' THEN
   #    IF l_done = 1 THEN                       
   #       LET l_sql = l_sql CLIPPED, " UNION SELECT  ",
#  #                   " ima01, ima02, ima021, ima25, ima26,  ",            #FUN-A40023
   #                   " ima01, ima02, ima021, ima25,img10*img21,  ",       #FUN-A40023
   #                   " ima27,ima271,rty13, ima902, imgplant ",                 #TQC-A70003  add imgplant
   #                   " FROM  ",cl_get_target_table(l_plant,'ima_file'),
   #                   " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'img_file'),
   #                   " ON ima01 = img01 ",
   #                   " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rty_file'),
   #                   " ON (rty01 =ima01  AND rty02 = imgplant )",
   #                   " WHERE ",tm.wc2 CLIPPED, " AND imaacti = 'Y' ",
   #                   " AND imgplant ='",l_plant,"'"

   #	 # LET l_sql = l_sql CLIPPED, " AND ima26 < ima27 "   #No.B059
#  #	   LET l_sql = l_sql CLIPPED, " AND (ima26 < ima27 AND ima27 > 0)"  #FUN-A40023
   #       LET l_sql = l_sql CLIPPED, " AND (img10*img21 < ima27 AND ima27 > 0)"  #FUN-A40023
   #    ELSE
   #     # LET l_sql = l_sql CLIPPED, " AND ima26 < ima27 "   #No.B059
#  # 	   LET l_sql = l_sql CLIPPED, " AND (ima26 < ima27 AND ima27 > 0)"     #FUN-A40023
   #       LET l_sql = l_sql CLIPPED, " AND (img10*img21 < ima27 AND ima27 > 0)"  #FUN-A40023
   #    END IF
   # END IF
#MOD-B90166 -- mark end --
#MOD-B90166 -- begin --
     LET l_done = 0
     LET l_sql = "SELECT ima01,ima02,ima021,ima25,mrpqty,",
                 "ima27,ima271,rty13,ima902,imgplant",
                 "  FROM (",
                 "      SELECT ima01,ima02,ima021,ima25,SUM(img10*img21) mrpqty,",
                 "      ima27,ima271,rty13,ima902,imgplant",
                 "        FROM ",cl_get_target_table(l_plant,'ima_file'),
                 "        LEFT OUTER JOIN ",cl_get_target_table(l_plant,'img_file'),
                 "          ON ima01 = img01 ",
                 "        LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rty_file'),
                 "          ON (rty01 = imgplant  AND rty02 = img01)",
                 "       WHERE ",tm.wc2 CLIPPED, " AND imaacti = 'Y' ",
                 "         AND imgplant ='",l_plant,"'",
                 "       GROUP BY ima01,ima02,ima021,ima25,ima27,ima271,rty13,ima902,imgplant",
                 "  )"
     IF tm.c = 'Y' THEN
        LET l_sql = l_sql," WHERE (mrpqty < 0)"
        LET l_done = 1                 
     END IF 

     IF NOT cl_null(tm.day) THEN
        IF l_done = 1 THEN
           LET l_sql = l_sql," OR (sysdate - ima902) > ",tm.day
        ELSE
           LET l_sql = l_sql," WHERE (sysdate - ima902) > ",tm.day
           LET l_done = 1
        END IF
     END IF

     IF tm.high = 'Y' THEN
        IF l_done = 1 THEN
           LET l_sql = l_sql," OR (mrpqty>rty13 and rty13>0)"
        ELSE
           LET l_sql = l_sql," WHERE (mrpqty>rty13 and rty13>0)"
           LET l_done = 1
        END IF
     END IF

     IF tm.safe = 'Y' THEN
        IF l_done = 1 THEN
           LET l_sql = l_sql," OR (mrpqty<ima27 and ima27>0)"
        ELSE
           LET l_sql = l_sql," WHERE (mrpqty<ima27 and ima27>0)"
           LET l_done = 1
        END IF
     END IF
#MOD-B90166 -- end --
     LET l_sql = l_sql CLIPPED, " ORDER BY ima01"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
     PREPARE x560_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE x560_curs1 CURSOR FOR x560_prepare1
#No.FUN-A40023 ---start---
     FOREACH x560_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
#TQC-A70003 add ---------------------------------start----------------------------------------
       #FUN-CB0004--add--str---
        IF NOT cl_null(sr.ima902) THEN 
           LET sr.l_diff = g_today - sr.ima902
        ELSE 
           LET sr.l_diff = null
        END IF

        IF sr.rty13 IS NULL THEN
           IF sr.ima271 > 0 AND (sr.avl_stk_mpsmrp - sr.ima271) > 0 THEN
              LET sr.l_over = sr.avl_stk_mpsmrp - sr.ima271
           ELSE 
              LET sr.l_over = 0      
           END IF
        ELSE
           IF sr.rty13 > 0 AND (sr.avl_stk_mpsmrp - sr.rty13) > 0 THEN
              LET sr.l_over = sr.avl_stk_mpsmrp - sr.rty13
           ELSE
              LET sr.l_over = 0
           END IF
        END IF

        IF sr.ima27 > 0 AND (sr.ima27 - sr.avl_stk_mpsmrp) > 0 THEN
           LET sr.l_short = sr.ima27 - sr.avl_stk_mpsmrp
        ELSE
           LET sr.l_short = 0
        END IF

        LET sr.l_pot = 3
       #FUN-CB0004--add--end---
 
        IF sr.rty13 IS NULL THEN
        
          EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima25,sr.avl_stk_mpsmrp,
                                      sr.ima27,sr.ima271,sr.ima902,sr.imgplant,sr.l_diff,sr.l_over,sr.l_short,sr.l_pot  #FUN-CB0004 add sr.l_diff,sr.l_over,sr.l_short,sr.l_pot
        ELSE
          EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima25,sr.avl_stk_mpsmrp,
                                      sr.ima27,sr.rty13,sr.ima902,sr.imgplant,sr.l_diff,sr.l_over,sr.l_short,sr.l_pot   #FUN-CB0004 add sr.l_diff,sr.l_over,sr.l_short,sr.l_pot
        END IF
#TQC-A70003 add  -----------------------------------end----------------------------------------
     END FOREACH 
END FOREACH
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#No.FUN-A40023 ---end---

#No FUN-750093 --start--
#     CALL cl_outnam('aimx560') RETURNING l_name 
#     START REPORT x560_rep TO l_name
 
#     LET g_pageno = 0
#     FOREACH x560_curs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT x560_rep(sr.*)  #FUN-750093
#     END FOREACH
#     FINISH REPORT x560_rep   #FUN-750093
#No FUN-750093 --end--
 
    LET g_xgrid.table = l_table    ###XtraGrid###
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc2,'ima01')
             RETURNING tm.wc2
        LET g_str = tm.wc2
     END IF
###XtraGrid###     LET g_str=g_str
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len) #FUN-750093
#    CALL cl_prt_cs1('aimx560','aimx560',l_sql,g_str)   #FUN-A40023
###XtraGrid###     CALL cl_prt_cs3('aimx560','aimx560',g_sql,g_str)   #FUN-A40023
    LET g_xgrid.order_field = "imgplant,ima01"                          #FUN-CB0004 add
    LET g_xgrid.grup_field = "imgplant,ima01"                           #FUN-CB0004 add
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc2       #FUN-CB0004 add
    CALL cl_xg_view()    ###XtraGrid###
END FUNCTION
#FUN-750093 --start--
{
REPORT x560_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_qty1        LIKE ima_file.ima26,
          l_qty2        LIKE ima_file.ima26,
          sr            RECORD
                        ima01  LIKE ima_file.ima01, #料件編號
                        ima02  LIKE ima_file.ima02, #品名規格
                        ima021 LIKE ima_file.ima021,#品名規格
                        ima25  LIKE ima_file.ima25, #庫存單位
                        ima26  LIKE ima_file.ima26, #MPS/MRP可用量
                        ima27  LIKE ima_file.ima27, #安全存量/再補貨點
                        ima271 LIKE ima_file.ima271,#最高儲存數量
                        ima902 LIKE ima_file.ima902 #呆滯日期
                        END RECORD ,
          l_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINTX name=H2 g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      #No.B059 010323 by linda 最高存量=0為不控管
      IF sr.ima271 >0 THEN
         LET l_qty1 = sr.ima26 - sr.ima271
      ELSE
         LET l_qty1=0
      END IF
      IF l_qty1 <=0 THEN
         LET l_qty1=0
      END IF
      IF sr.ima27 >0 THEN
         LET l_qty2 = sr.ima27 - sr.ima26
      ELSE
         LET l_qty2=0
      END IF
      IF l_qty2 <=0 THEN
         LET l_qty2=0
      END IF
      #No.B059 end----
 
      PRINTX name=D1 COLUMN g_c[31],sr.ima01,
                     COLUMN g_c[32],sr.ima25,
                     COLUMN g_c[33],cl_numfor(sr.ima26,33,3),
	             COLUMN g_c[34],cl_numfor(g_today-sr.ima902,34,0),
                     COLUMN g_c[35],cl_numfor(sr.ima271,35,3),
                     COLUMN g_c[36],cl_numfor(l_qty1,36,3),
                     COLUMN g_c[37],cl_numfor(sr.ima27,37,3),
                     COLUMN g_c[38],cl_numfor(l_qty2,38,3)
      PRINTX name=D2 COLUMN g_c[39],sr.ima02,
                     COLUMN g_c[40],sr.ima021
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'ima01')
              RETURNING tm.wc
         LET tm.wc= tm.wc CLIPPED
         PRINT g_dash
#TQC-630166
#        IF tm.wc[001,69] > ' ' THEN            # for 132
#               PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        IF tm.wc[067,132] > ' ' THEN            # for 132
#        PRINT g_x[8] CLIPPED,tm.wc[067,132] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINES
      END IF
END REPORT
}
#No.FUN-750093 --end--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

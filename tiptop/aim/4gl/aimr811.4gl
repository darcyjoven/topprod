# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr811.4gl
# Descriptions...: 空白盤點標籤－現有庫存
# Input parameter:
# Return code....:
# Date & Author..: 92/06/03 By Apple
# Modify ........: 93/11/04 By Fiona
# Modify.........: No.FUN-550108 05/06/01 By echo 新增報表備註
# Modify.........: No.MOD-590522 05/09/28 By kim 列印料號放大
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE 
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710084 07/02/07 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加 CR 參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960065 09/11/10 By jan修改標簽別的開窗
# Modify.........: No.TQC-9B0038 09/11/10 By jan 修改程序BUG
# Modify.........: No.TQC-AB0166 10/12/03 By chenying 執行後出現"DECLARE sql_cur1 查詢時, 未發現表格中有欄位 column-name (或SLV尚未加以定義)."的錯誤訊息
# Modify.........: No.TQC-AB0166 10/12/06 By chenying 義為LIKE pib_file.pib03的變數都改成LIKE pia_file.pia01
# Modify.........: No.TQC-AC0207 10/12/16 By vealxu 拿掉標籤別﹧起始標籤﹧截止標籤 改成一個可QBE的"標籤編號"
# Modify.........: No.MOD-C10022 12/01/04 By ck2yuan 報表順序有問題,故拿掉tm.wc
# Modify.........: No.TQC-C10034 12/01/16 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C20047 12/02/10 By yuhuabao 印標籤無需簽核
# Modify.........: No.TQC-C30336 12/04/01 By SunLM chr1000--->STRING
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
           #start FUN-5A0199
           #wc       LIKE type_file.chr1000, # TQC-AC0207 
           wc       STRING,                 #TQC-C30336 add
         # bstkspc  LIKE pib_file.pib01,    # 標籤別 #FUN-660078                                       #TQC-AC0207
#          bstkno   LIKE pib_file.pib03,    # 起始流水號 #No.FUN-690026 VARCHAR(10) #TQC-AB0166 mark
         # bstkno   LIKE pia_file.pia01,    # 起始流水號 #No.FUN-690026 VARCHAR(10) #TQC-AB0166 add    #TQC-AC0207  mark
         # estkspc  LIKE pib_file.pib01,    # 標籤別 #FUN-660078                                          
#          estkno   LIKE pib_file.pib03,    # 起始流水號 #No.FUN-690026 VARCHAR(10)   #TQC-AB0166 mark 
         # estkno   LIKE pia_file.pia01,    # 起始流水號 #No.FUN-690026 VARCHAR(10)   #TQC-AB0166 add  #TQC-AC0207  mark
           #end FUN-5A0199
           c        LIKE type_file.chr1,    # 列印條碼否  #No.FUN-690026 VARCHAR(1)
           d        LIKE type_file.chr1,    # 套版否      #No.FUN-690026 VARCHAR(1)
           yearstr  LIKE type_file.chr20,   # 年度辨視    #No.FUN-690026 VARCHAR(10)
           more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
      #g_pib03    LIKE pib_file.pib03       #CHI-960065
DEFINE g_i        LIKE type_file.num5       #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE  g_str     STRING     #No.FUN-710084
DEFINE  g_t1        LIKE oay_file.oayslip  #CHI-960065
#No.TQC-C20047 ----- mark ----- begin
# DEFINE  g_sql     STRING   #No.TQC-C10034 add
# DEFINE  l_table   STRING   #No.TQC-C10034 add
#No.TQC-C20047 ----- mark ----- end
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
   LET g_copies   = ARG_VAL(6)
#TQC-AC0207 -------------mark start---------------
#  LET tm.bstkspc = ARG_VAL(7)
#  LET tm.bstkno  = ARG_VAL(8)
#  LET tm.estkspc = ARG_VAL(9)
#  LET tm.estkno  = ARG_VAL(10)
#  LET tm.c       = ARG_VAL(11)
#  LET tm.d       = ARG_VAL(12)
#  LET tm.yearstr = ARG_VAL(13)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(14)
#  LET g_rep_clas = ARG_VAL(15)
#  LET g_template = ARG_VAL(16)
#  LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
#  #No.FUN-570264 ---end---
   LET tm.wc = ARG_VAL(7)
   LET tm.c  = ARG_VAL(8)
   LET tm.d  = ARG_VAL(9)
   LET tm.yearstr = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14) 
#TQC-AC0207 -----------mod end------------------------

#No.TQC-C20047 ----- mark ----- begin
#No.TQC-C10034 ----- add ----- begin
#  LET g_sql = "pia01.pia_file.pia01,",
#              "pia02.pia_file.pia02,",
#              "pia03.pia_file.pia03,",
#              "pia04.pia_file.pia04,",
#              "pia05.pia_file.pia05,",
#              "pia08.pia_file.pia08,",
#              "pia09.pia_file.pia09,",
#              "ima02.ima_file.ima02,",
#              "ima08.ima_file.ima08,",
#              "ima15.ima_file.ima15,",
#              "stat.type_file.chr1,",
#              "gfe03.gfe_file.gfe03,",
#              "sign_type.type_file.chr1,",   #簽核方式                
#              "sign_img.type_file.blob,",    #簽核圖檔                  
#              "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)    
#              "sign_str.type_file.chr1000"   #簽核字串                  
# LET l_table = cl_prt_temptable('aimr801',g_sql) CLIPPED
# IF l_table = -1 THEN EXIT PROGRAM END IF

#  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#              " VALUES(?,?,?,?,?, ?,?,?,?,? ,?,? ,?,?,?,?)"  
#  PREPARE insert_prep FROM g_sql
#  IF STATUS THEN
#     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#  END IF
#No.TQC-C10034 ----- add ----- end
#No.TQC-C20047 ----- mark ----- end

   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r811_tm(0,0)	    	# Input print condition
      ELSE CALL r811()		            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r811_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	  l_flag        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
   DEFINE stk_len       LIKE type_file.num5      #CHI-960065
   DEFINE l_len         LIKE type_file.num5      #CHI-960065
   DEFINE li_result     LIKE type_file.num5      #CHI-960065
   DEFINE l_pia01       LIKE pia_file.pia01      #CHI-960065
#  DEFINE l_pib03       LIKE pib_file.pib03      #CHI-960065  #TQC-AB0166 mark
   DEFINE l_pib03       LIKE pia_file.pia01      #CHI-960065  #TQC-AB0166 add
 
   LET p_row = 6 LET p_col = 30
 
   OPEN WINDOW r811_w AT p_row,p_col WITH FORM "aim/42f/aimr811"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.wc = '1=1'                    #TQC-AC0207
   LET tm.c = 'N'
   LET tm.d = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   #TQC-AC0207 --------------add start----------
   CONSTRUCT tm.wc ON pia01 FROM pia01
     ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

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

      ON ACTION CONTROLP
         IF INFIELD(pia01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pia01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia01
            NEXT FIELD pia01
         END IF
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   IF cl_null(tm.wc) THEN
      LET tm.wc = '1=1'
   END IF
   #TQC-AC0207 -------------add end-------------

  #TQC-AC0207 -----------mark start--------- 
  #INPUT BY NAME tm.bstkspc, tm.bstkno , tm.estkspc, tm.estkno ,
  #              tm.yearstr,tm.c, tm.d, tm.more
  #             WITHOUT DEFAULTS
   INPUT BY NAME tm.yearstr,tm.c, tm.d, tm.more
               WITHOUT DEFAULTS
  #TQC-AC0207 ----------- mod end---------------------       
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
       AFTER FIELD yearstr          #TQC-AC0207 
          LET l_direct = 'D'        #TQC-AC0207

#TQC-AC0207 -----------------------mark start---------------------------------------
#     AFTER FIELD bstkspc
#        IF tm.bstkspc IS NULL OR tm.bstkspc =' ' THEN
#           NEXT FIELD bstkspc
#        ELSE
#CHI-960065--begin--mod----------------------------------------------
#           CALL s_check_no("aim",tm.bstkspc,"","5","pia_file","pia01","")
#           RETURNING li_result,tm.bstkspc
#           LET tm.bstkspc = s_get_doc_no(tm.bstkspc)
#           DISPLAY BY NAME tm.bstkspc
#           IF (NOT li_result) THEN                                                                                                 
#                NEXT FIELD bstkspc
#             END IF
#           LET stk_len=LENGTH(tm.bstkspc)                                                                                              
#           LET l_pia01 = '' #TQC-9B0038
#           SELECT MAX(pia01) INTO l_pia01 FROM pia_file                                                                            
#            WHERE Substr(pia01,1,stk_len) LIKE tm.bstkspc     
#           #TQC-9B0038--begin--add---                                                                                             
#           IF cl_null(l_pia01) THEN                                                                                                
#              CALL cl_err3("sel","pia_file",tm.bstkspc,"","mfg0107",                                                               
#                           "","",0)                                                                                                
#              NEXT FIELD bstkspc                                                                                                   
#           END IF                                                                                                                  
#           #TQC-9B0038--end--add------                                                                        
#           LET l_len=length(l_pia01)                                                                                               
#           LET l_pib03 = l_pia01[stk_len+2,l_len]
#           SELECT pib03 INTO g_pib03 FROM pib_file
#             WHERE pib01 = tm.bstkspc
#             IF SQLCA.sqlcode THEN
##               CALL cl_err(tm.bstkspc,'mfg0107',0) #No.FUN-660156 
#                CALL cl_err3("sel","pib_file",tm.bstkspc,"","mfg0107",
#                             "","",0)  #No.FUN-660156
#                NEXT FIELD bstkspc
#             END IF
#             LET tm.estkno = l_pib03                                                                                                  
#             DISPLAY BY NAME tm.estkno
#CHI-960065--end--mod--------------------------------
#             LET tm.estkspc = tm.bstkspc
#             DISPLAY BY NAME tm.estkspc
#        END IF
#
#     AFTER FIELD estkno
#        IF tm.estkno IS NOT NULL AND tm.bstkno IS NOT NULL
#           AND tm.estkno < tm.bstkno  THEN
#           CALL cl_err('','mfg1323',0)
#           NEXT FIELD estkno
#        END IF
#        LET l_direct = 'D'
#TQC-AC0207 ---------------------mark end--------------------------------
 
      BEFORE FIELD c    #列印條碼
         #系統參數設定未與條碼系統連線
	 IF g_sma.sma07 MATCHES '[Nn]' THEN
            IF l_direct='D' THEN
	       NEXT FIELD d
            ELSE
	     # NEXT FIELD estkno    #TQC-AC0207 mark
               NEXT FIELD yearstr   #TQC-AC0207
            END IF
         END IF
 
      AFTER FIELD c    #列印條碼
         IF tm.c NOT MATCHES "[YN]" OR tm.c IS NULL
            THEN NEXT FIELD c
         END IF
 
      AFTER FIELD d    #套版否
         IF tm.d NOT MATCHES "[YN]" OR tm.d IS NULL
            THEN NEXT FIELD d
         END IF
	 LET l_direct='U'
 
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
 
        AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT  END IF
 
#TQC-AC0207 -----------------mark start---------------------
#     ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(bstkspc)
#                 CALL q_pib(8,3,tm.bstkspc) RETURNING tm.bstkspc
#                 CALL FGL_DIALOG_SETBUFFER( tm.bstkspc )
#CHI-960065--begin--mod------------------------------------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_pib'
#                 LET g_qryparam.default1 = tm.bstkspc
#                 CALL cl_create_qry() RETURNING tm.bstkspc
##                CALL FGL_DIALOG_SETBUFFER( tm.bstkspc )
#                 LET g_t1 = s_get_doc_no(tm.bstkspc)
#                 CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
#                 LET tm.bstkspc=g_t1
#CHI-960065--end--mod-------------------------------------------------
#                 DISPLAY BY NAME tm.bstkspc
#                 NEXT FIELD bstkspc
#              OTHERWISE EXIT CASE
#           END CASE
#TQC-AC0207 -----------------mark end------------------------------------------------
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r811_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr811'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr811','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                   # " '",tm.bstkspc CLIPPED,"'",    #TQC-AC0207 mark
                   # " '",tm.bstkno CLIPPED,"'",     #TQC-AC0207 mark 
                   # " '",tm.estkspc CLIPPED,"'",    #TQC-AC0207 mark
                   # " '",tm.estkno   CLIPPED,"'",   #TQC-AC0207 mark
                     " '",tm.wc   CLIPPED,"'",       #TQC-AC0207
                     " '",tm.c   CLIPPED,"'",
                     " '",tm.d   CLIPPED,"'",
                     " '",tm.yearstr CLIPPED,"'" ,
                     " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                     " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr811',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r811_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r811()
   ERROR ""
END WHILE
   CLOSE WINDOW r811_w
END FUNCTION
 
FUNCTION r811()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          #l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_sql   STRING,                 #TQC-C30336 add
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_bno,l_eno   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_btag,l_etag LIKE pia_file.pia01,    #FUN-5A0199 10碼->16碼 #No.FUN-690026 VARCHAR(16)
          l_i           LIKE type_file.num10,   #No.FUN-690026 INTEGER
          sr            RECORD
                        pia01  LIKE pia_file.pia01
                        END RECORD
#No.TQC-C20047 ----- mark ----- begin
#No.TQC-C10034 ----- add ----- begin
#  DEFINE sr1           RECORD
#                       pia01  LIKE pia_file.pia01, #No.TQC-C10034,
#                       pia02  LIKE pia_file.pia02,
#                       pia03  LIKE pia_file.pia03,
#                       pia04  LIKE pia_file.pia04,
#                       pia05  LIKE pia_file.pia05,
#                       pia08  LIKE pia_file.pia08,
#                       pia09  LIKE pia_file.pia09,
#                       ima02  LIKE ima_file.ima02,
#                       ima08  LIKE ima_file.ima08,
#                       ima15  LIKE ima_file.ima15,
#                       stat   LIKE type_file.chr1,
#                       gfe03  LIKE gfe_file.gfe03
#                       END RECORD
#No.TQC-C10034 ----- add ----- end
#  DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
#  LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
#No.TQC-C20047 ----- mark ----- end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr811'
#    CALL cl_del_data(l_table)  #TQC-C10034 #No.TQC-C20047  mark 
#No.FUN-710084 --begin
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    CALL cl_outnam('aimr811') RETURNING l_name
#No.FUN-710084 --end
 
     LET l_sql = " UPDATE pia_file ",
                 " SET pia15=pia15+1,",
                 "     pia14='",g_today,"' " ,
                 " WHERE pia01=? "
 
     PREPARE r811_up FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
 
#No.TQC-C10034 ----- mark ----- begin
#No.TQC-C20047 ----- release ----- begin
    LET l_sql = "SELECT pia01 FROM pia_file ",
                " WHERE (pia02 IS NULL OR pia02 = ' ') "
#No.TQC-C20047 ----- release ----- end
#No.TQC-C10034 ----- mark ----- end
 
#TQC-AC0207-----------mark start----------------------------------------
#    IF tm.bstkspc IS NOT NULL AND tm.bstkspc != ' '
#       AND tm.bstkno IS NOT NULL AND tm.bstkno != ' ' THEN
#      #LET l_btag = tm.bstkspc,'-',tm.bstkno           #FUN-5A0199 mark
#       LET l_btag = tm.bstkspc CLIPPED,'-',tm.bstkno   #FUN-5A0199
#       LET l_sql = l_sql clipped," AND pia01 >='",l_btag,"'"
#    END IF
#    
#    IF tm.estkspc IS NOT NULL AND tm.estkspc != ' '
#       AND tm.estkno IS NOT NULL AND tm.estkno != ' ' THEN
#      #LET l_etag = tm.estkspc,'-',tm.estkno           #FUN-5A0199 mark
#       LET l_etag = tm.estkspc CLIPPED,'-',tm.estkno   #FUN-5A0199
#       LET l_sql = l_sql clipped," AND pia01 <='",l_etag,"'"
#    END IF
#
#    IF tm.bstkspc IS NOT NULL AND tm.bstkspc != ' '
#       AND (tm.bstkno IS NULL OR tm.bstkno = ' ') THEN
#      #LET l_sql = l_sql clipped," AND SUBSTR(pia01,1,3) like '",tm.bstkspc,"'"                       #FUN-5A0199 mark
##      LET l_sql = l_sql clipped," AND pia01[1,",g_doc_len,"] matches '",tm.bstkspc CLIPPED,"'"   #FUN-5A0199     #No.FUN-710084
##      LET l_sql = l_sql clipped," AND pia01[1,",g_doc_len,"] matches '",tm.bstkspc CLIPPED,"'"   #FUN-5A0199   #TQC-AB0166 mark 
#       LET l_sql = l_sql clipped," AND pia01 LIKE '",tm.bstkspc CLIPPED,"%'"    #TQC-AB0166 add 
##     LET l_sql = l_sql clipped," AND SUBSTRING(pia01,1,",g_doc_len,") = '",tm.bstkspc CLIPPED,"'"   #FUN-710084 #TQC-AB0166 mark
#    END IF
#TQC-AC0207 -----------------mark end-----------------------------------
     LET l_sql = l_sql CLIPPED," AND ",tm.wc CLIPPED   #TQC-AC0207  
     DISPLAY "l_sql:",l_sql
 
     PREPARE r811_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r811_curs CURSOR FOR r811_prepare
 
#    START REPORT r811_rep TO l_name     #No.FUN-710084
       FOREACH r811_curs INTO sr.pia01
        IF SQLCA.sqlcode THEN
           #CALL cl_err('','foreach error',1) #No.+045 010403 by plum
           CALL cl_err('foreach error',SQLCA.SQLCODE,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
           EXIT PROGRAM
        END IF
        EXECUTE r811_up USING sr.pia01
 
#       OUTPUT TO REPORT r811_rep(sr.pia01)     #No.FUN-710084
      END FOREACH
#No.TQC-C20047 ----- mark ----- begin
#No.TQC-C10034 ----- add ----- begin
#   LET l_sql = " SELECT pia01,pia02,pia03,pia04,pia05,pia08,pia09, ",
#               "        ima02,ima08,ima15,'',gfe03",
#               "   FROM pia_file, OUTER ima_file,OUTER gfe_file ",
#               "  WHERE pia02 = ima01 AND gfe01 = pia09 ",
#               "    AND ", tm.wc
#   PREPARE apmr811_pre FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare1:',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE apmr811_curs CURSOR FOR apmr811_pre
#    FOREACH apmr811_curs INTO sr1.*
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      EXECUTE insert_prep USING sr1.*,"",l_img_blob, "N",""
#    END FOREACH
#    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#    LET g_str = tm.c,";",tm.d,";",tm.yearstr
#    LET g_cr_table = l_table                 #主報表的temp table名稱    
#    LET g_cr_apr_key_f = "pia01"             #報表主鍵欄位名稱，用"|"隔開   
#    CALL cl_prt_cs3('aimr811','aimr811',g_sql,g_str)
#No.TQC-C10034 ----- add ----- end
#No.TQC-C20047 ----- mark ----- end

#No.TQC-C10034 ----- mark ----- begin
#No.TQC-C20047 ----- release ----- begin
  # LET g_str = tm.c,";",tm.d,";",tm.yearstr     #No.FUN-710084    #TQC-AC0207 mark
  # LET g_str = tm.wc,";",tm.c,";",tm.d,";",tm.yearstr             #TQC-AC0207       #MOD-C10022 mark
    LET g_str = tm.c,";",tm.d,";",tm.yearstr                       #MOD-C10022 add 
  # CALL cl_prt_cs1('aimr811',l_sql,g_str)           #No.FUN-710084#TQC-730088
    CALL cl_prt_cs1('aimr811','aimr811',l_sql,g_str) #No.FUN-710084
#No.TQC-C20047 ----- release ----- end
#No.TQC-C10034 ----- mark ----- end
#    FINISH REPORT r811_rep     #No.FUN-710084
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #No.FUN-710084
END FUNCTION
 
#No.FUN-710084 --begin
#REPORT r811_rep(sr)
#   DEFINE
#    l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#    sr            RECORD
#                  pia01   LIKE pia_file.pia01
#                  END RECORD,
#    l_barcode     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#    l_i,l_j,l_len LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#    l_control     LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#    l_advance     LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#    l_ff          LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#    l_c           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#    l_01          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pia01
#  FORMAT
#
#   BEFORE GROUP OF sr.pia01
#		#下列資料為條碼的控制碼資料
#		LET l_control[1]=ascii 27	#ESC
#		LET l_control[2]='*'		#*
#		LET l_control[3]=ascii 33	#33 120 dots/inch
#						#32  60 dots/inch
#						#38  90 dots/inch
#						#39 180 dots/inch
#						#40 360 dots/inch
#		LET l_ff[1]=ascii 255		#0xFF
#		LET l_ff[2]=ascii 255		#0xFF
#		LET l_ff[3]=ascii 255		#0xFF
#		LET l_advance[1]=ascii 27	#ESC
#		LET l_advance[2]='J'		#J
#		LET l_advance[3]=ascii 21	#
#
#   ON EVERY ROW
#      IF tm.d='Y' THEN               #是否使用標籤套版
#         PRINT ' '
#      ELSE
#         PRINT COLUMN 22,g_x[21] CLIPPED #MOD-590522 16->22
#      END IF
#      PRINT " "
#      PRINT " "
#      #使用套版
#      IF tm.d='N' THEN
#         PRINT g_x[11] CLIPPED;
#      END IF
#      #不列印條碼
#      IF tm.c='N' THEN
#         PRINT COLUMN 10,sr.pia01;
#      END IF
#      IF tm.d='N' THEN
#         PRINT COLUMN 28,g_x[23] CLIPPED;
#      END IF
#      PRINT COLUMN 30,tm.yearstr
# 	IF tm.c='N' THEN
#		#不使用條碼時, 則往前跳躍75/180"
#		LET l_advance[3]=ascii 90
#    	PRINT l_advance
#	ELSE
#		#使用條碼(三九碼), 則以下列方式來列印
#		#1.在單號前後各加上一個星號
#		LET l_barcode='*',sr.pia01,'*'
#		#2.將之轉換成01對應的碼
#		CALL to01(l_barcode) RETURNING l_01
#		#3.轉換成印表機的控制碼
#		LET l_len=LENGTH(l_01) - 2	#總長度要減掉最後兩個多餘的00
#		LET l_i=l_len / 256		#計算傳給印表機的資料個數
#		LET l_j=l_len-(256*l_i)		#算法:n=n2+n1*256 (n=length)
#		LET l_control[4]=ascii l_j	#n2
#		LET l_control[5]=ascii l_i	#n1
#		FOR l_j=1 TO 3			#為方便條碼機閱讀, 列印三次
#                    PRINT COLUMN 11,l_control CLIPPED;
#                    FOR l_i=1 TO l_len		#將1轉換成FF
#                    LET l_c=l_01[l_i,l_i]	#將0轉換成00
#                    IF l_c='1' THEN PRINT l_ff;
#                       ELSE PRINT FILE '/nulls' END IF
#                    END FOR
#                       PRINT l_advance CLIPPED;PRINT '          ';
#		END FOR
#		LET l_advance[3]=ascii 27
#                PRINT l_advance
#	END IF
#   IF tm.d='N' THEN   #不使用套版
#      PRINT g_x[12] CLIPPED
#           #COLUMN 35, g_x[24] CLIPPED #MOD-590522
#      PRINT g_x[13] CLIPPED
#      PRINT g_x[24] CLIPPED #MOD-590522
#      PRINT " "
#
#      PRINT g_x[14] CLIPPED,
#            COLUMN 33,g_x[25] CLIPPED
#      PRINT g_x[15] CLIPPED
#      PRINT g_x[16] CLIPPED
#      PRINT " "
#      PRINT g_x[22] CLIPPED
#      PRINT " "
#
#      PRINT COLUMN 14,g_x[17] CLIPPED #MOD-590522 11->14
#      PRINT " "
#      PRINT g_x[18] CLIPPED
#     #PRINT "          ------------    ------------     "
#      PRINT "          -----------------    -----------------     " #MOD-590522
#      PRINT " "
#      PRINT g_x[19] CLIPPED
#     #PRINT "          ------------    ------------     "
#      PRINT "          -----------------    -----------------     " #MOD-590522
#      PRINT " "
#      PRINT g_x[20] CLIPPED
#     #PRINT "          ------------    ------------     "
#      PRINT "          -----------------    -----------------     " #MOD-590522
#   ELSE
#      PRINT " "
#      PRINT " "
#      PRINT " "
#
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#      PRINT " "
#   END IF
#   ## FUN-550108
#   PRINT
#   IF l_last_sw = 'n' THEN
#      IF g_memo_pagetrailer THEN
#          PRINT g_x[9]
#          PRINT g_memo
#      ELSE
#          PRINT
#          PRINT
#      END IF
#   ELSE
#       PRINT g_x[9]
#       PRINT g_memo
#   END IF
#   SKIP 6 LINE
### END FUN-550108
#
#END REPORT
#
##將所要印的單號, 轉換成條碼
#FUNCTION to01(p_code)
#DEFINE
#	p_code       LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#	l_c          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#	l_01         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
#	l_01c        LIKE type_file.chr21,   #No.FUN-690026 VARCHAR(21)
#	l_length,l_i LIKE type_file.num5     #No.FUN-690026 SMALLINT
#
#     #決定要loop的次數
#     LET l_length=LENGTH(p_code)
#     LET l_01=' '
#	FOR l_i=1 TO l_length
#		LET l_c=UPSHIFT(p_code[l_i,l_i])
#		#三九碼所允許的字及其對應的碼別
#		CASE l_c
#			WHEN '0' LET l_01c='100100001111001111001'
#			WHEN '1' LET l_01c='111100100001001001111'
#			WHEN '2' LET l_01c='100111100001001001111'
#			WHEN '3' LET l_01c='111100111100001001001'
#			WHEN '4' LET l_01c='100100001111001001111'
#			WHEN '5' LET l_01c='111100100001111001001'
#			WHEN '6' LET l_01c='100111100001111001001'
#			WHEN '7' LET l_01c='100100001001111001111'
#			WHEN '8' LET l_01c='111100100001001111001'
#			WHEN '9' LET l_01c='100111100001001111001'
#			WHEN 'A' LET l_01c='111100100100001001111'
#			WHEN 'B' LET l_01c='100111100100001001111'
#			WHEN 'C' LET l_01c='111100111100100001001'
#			WHEN 'D' LET l_01c='100100111100001001111'
#			WHEN 'E' LET l_01c='111100100111100001001'
#			WHEN 'F' LET l_01c='100111100111100001001'
#			WHEN 'G' LET l_01c='100100100001111001111'
#			WHEN 'H' LET l_01c='111100100100001111001'
#			WHEN 'I' LET l_01c='100111100100001111001'
#			WHEN 'J' LET l_01c='100100111100001111001'
#			WHEN 'K' LET l_01c='111100100100100001111'
#			WHEN 'L' LET l_01c='100111100100100001111'
#			WHEN 'M' LET l_01c='111100111100100100001'
#			WHEN 'N' LET l_01c='100100111100100001111'
#			WHEN 'O' LET l_01c='111100100111100100001'
#			WHEN 'P' LET l_01c='100111100111100100001'
#			WHEN 'Q' LET l_01c='100100100111100001111'
#			WHEN 'R' LET l_01c='111100100100111100001'
#			WHEN 'S' LET l_01c='100111100100111100001'
#			WHEN 'T' LET l_01c='100100111100111100001'
#			WHEN 'U' LET l_01c='111100001001001001111'
#			WHEN 'V' LET l_01c='100001111001001001111'
#			WHEN 'W' LET l_01c='111100001111001001001'
#			WHEN 'X' LET l_01c='100001001111001001111'
#			WHEN 'Y' LET l_01c='111100001001111001001'
#			WHEN 'Z' LET l_01c='100001111001111001001'
#			WHEN '-' LET l_01c='100001001001111001111'
#			WHEN '.' LET l_01c='111100001001001111001'
#			WHEN ' ' LET l_01c='100001111001001111001'
#			WHEN '*' LET l_01c='100010011110011110001'
#			WHEN '$' LET l_01c='1000010000100001001'
#			WHEN '/' LET l_01c='1000010000100100001'
#			WHEN '+' LET l_01c='1000010010000100001'
#			WHEN '%' LET l_01c='1001000010000100001'
#			OTHERWISE EXIT CASE
#		END CASE
#		#將之組合起來, 並在每字後面加上'00', 以方便條碼機閱讀
#		LET l_01=l_01 CLIPPED,l_01c CLIPPED,'00'
#	END FOR
#	RETURN l_01
#END FUNCTION
#No.FUN-710084 --end
#Patch....NO.TQC-610036 <001> #

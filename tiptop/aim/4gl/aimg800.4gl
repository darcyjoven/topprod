# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aimg800.4gl
# Descriptions...: 盤點標籤列印作業－現有庫存
# Input parameter:
# Return code....:
# Date & Author..: 93/05/28 By Apple
# Modify ........: 93/11/04 By Fiona
# Modify.........: No.FUN-550108 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570082 05/07/13 By Carrier 多單位內容修改
# Modify.........: No.MOD-590522 05/09/28 By kim 調整列印料號長度
# Modify.........: No.FUN-5B0137 05/11/30 By kim 庫存數量列印放大
# Modify.........: No.MOD-5B0337 05/12/08 By kim 標籤印出時,會出現'Z'
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630037 06/03/10 By Claire 將標籤別碼數改為可變數
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710084 07/02/07 By Elva 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.MOD-840153 08/04/21 By Pengu 起始標籤號碼default錯誤
# Modify.........: No.FUN-860001 08/06/02 By Sherry 批序號-盤點
# Modify.........: No.MOD-930047 09/03/05 By Pengu 報表列印時會出現指定的表格'表格-名稱'不在資料庫中的錯誤訊息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960065 09/11/10 By jan 修改標簽別的開窗
# Modify.........: No.TQC-9B0038 09/11/10 By jan 修改程序BUG
# Modify.........: No.MOD-A30152 10/03/22 By Sarah 數量欄位取消用gfe03取位,改取位成整數
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:MOD-A60186 10/06/29 By Sarah SQL應該只抓取畫面上選擇之標籤別的資料
# Modify.........: No:TQC-AC0075 10/12/07 By Carrier l_pib03的长度太短
# Modify.........: No.TQC-AC0207 10/12/16 By vealxu 拿掉標籤別﹧起始標籤﹧截止標籤 改成一個可QBE的"標籤編號"
# Modify.........: No.FUN-B40087 11/06/09 By yangtt 憑證報表轉GRW
# Modify.........: No.FUN-C10036 12/01/12 By yangtt FUN-B70032追單
# Midify.........: No.FUN-D20064 13/02/20 By chenjing 修改全選報錯問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD	        		# Print condition RECORD
           wc        STRING,                    #TQC-AC0207
          # Prog. Version..: '5.30.06-13.03.12(05)   #TQC-AC0207 mark
           #No.TQC-AC0075  --Begin
          #bno       LIKE pib_file.pib03,       # 起始號碼 #No.FUN-690026 VARCHAR(10)
          #eno       LIKE pib_file.pib03,       # 截止號碼 #No.FUN-690026 VARCHAR(10)
          #bno       LIKE pia_file.pia01,       # 起始號碼 #No.FUN-690026 VARCHAR(10)   #TQC-AC0207 mark
          #eno       LIKE pia_file.pia01,       # 截止號碼 #No.FUN-690026 VARCHAR(10)   #TQC-AC0207 mark
           #No.TQC-AC0075  --End  
	   code      LIKE type_file.chr1,  	# 是否列印條碼  #No.FUN-690026 VARCHAR(1)
    	   size      LIKE type_file.chr1,  	# 是否套版列印  #No.FUN-690026 VARCHAR(1)
           a         LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
           e         LIKE type_file.chr1,       #No.FUN-570082  是否列印多單位標簽  #No.FUN-690026 VARCHAR(1)
           f         LIKE type_file.chr1,       #No.FUN-860001
           d         LIKE type_file.chr1,       #No.FUN-B40087
           yearstr   LIKE type_file.chr20,      # 年度辨視#No.FUN-690026 VARCHAR(10),       
           more	LIKE type_file.chr1   	        # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE    l_table     STRING,                       ### FUN-710084 ###
          g_sql       STRING                        ### FUN-710084 ###         
DEFINE    g_str       STRING                        ### FUN-710084 ### 
DEFINE    g_t1        LIKE oay_file.oayslip  #CHI-960065 
DEFINE    tm_stk_o    LIKE pib_file.pib01
DEFINE    l_table1    STRING   #FUN-C10036

###GENGRE###START
TYPE sr1_t RECORD
    pia01 LIKE pia_file.pia01,
    pia02 LIKE pia_file.pia02,
    pia03 LIKE pia_file.pia03,
    pia04 LIKE pia_file.pia04,
    pia05 LIKE pia_file.pia05,
    pia08 LIKE pia_file.pia08,
    pia09 LIKE pia_file.pia09,
    ima02 LIKE ima_file.ima02,
    ima08 LIKE ima_file.ima08,
    ima15 LIKE ima_file.ima15,
    stat LIKE type_file.chr1,
    pias06 LIKE pias_file.pias06,
    pias07 LIKE pias_file.pias07,
    ima021 LIKE ima_file.ima021    #FUN-B40087
#   piad06 LIKE piad_file.piad06,  #FUN-B40087    #FUN-C10036 mark
#   piad07 LIKE piad_file.piad07   #FUN-B40087    #FUN-C10036 mark 
END RECORD
###GENGRE###END

#FUN-C10036--------add----str---
TYPE sr2_t RECORD
     piad01 LIKE piad_file.piad01,
     piad02 LIKE piad_file.piad02,
     piad03 LIKE piad_file.piad03,
     piad04 LIKE piad_file.piad04,
     piad05 LIKE piad_file.piad05,
     piad06 LIKE piad_file.piad06,
     piad07 LIKE piad_file.piad07
END RECORD
#FUN-C10036--------add----end---

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
 
   ### FUN-710084 Start ### 
   LET g_sql =   "pia01.pia_file.pia01,pia02.pia_file.pia02,",
                 "pia03.pia_file.pia03,pia04.pia_file.pia04,",
                 "pia05.pia_file.pia05,pia08.pia_file.pia08,",
                 "pia09.pia_file.pia09,ima02.ima_file.ima02,",
                 "ima08.ima_file.ima08,ima15.ima_file.ima15,",
                 "stat.type_file.chr1,",  #MOD-A30152 mark #gfe03.gfe_file.gfe03 
                 "pias06.pias_file.pias06,pias07.pias_file.pias07,ima021.ima_file.ima021"  #FUN-860001    #FUN-B40087 add ima021.ima_file.ima021
         #       "piad06.piad_file.piad06,piad07.piad_file.piad07"   #FUN-B40087  #FUN-C10036 mark 
   LET l_table = cl_prt_temptable('aimg800',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
#  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  #FUN-860001  #MOD-A30152 remove ?   #FUN-B40087 3?   #FUN-C10036 del 2?
#  PREPARE insert_prep FROM g_sql
#  IF STATUS THEN
#     CALL cl_err('insert_prep:',status,1) 
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
#     CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
#     EXIT PROGRAM
#  END IF
   ### FUN-710084 End ### 

   #FUN-C10036 --START--
   LET g_sql = "piad01.piad_file.piad01,",
               "piad02.piad_file.piad02,",
               "piad03.piad_file.piad03,",
               "piad04.piad_file.piad04,",
               "piad05.piad_file.piad05,",
               "piad06.piad_file.piad06,",
               "piad07.piad_file.piad07"

   LET l_table1 = cl_prt_temptable('aimr800',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   #FUN-C10036 --END--
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#TQC-AC0207 -------------mod start-------------
#  LET tm.stk = ARG_VAL(7)
#  LET tm.bno = ARG_VAL(8)
#  LET tm.eno = ARG_VAL(9)
#  LET tm.code = ARG_VAL(10)
#  LET tm.size = ARG_VAL(11)
#  LET tm.a  = ARG_VAL(12)
#  LET tm.e  = ARG_VAL(13)   #TQC-610072
#  LET tm.yearstr = ARG_VAL(14)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(15)
#  LET g_rep_clas = ARG_VAL(16)
#  LET g_template = ARG_VAL(17)
#  LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
#  #No.FUN-570264 ---end---
   LET tm.wc = ARG_VAL(7)
   LET tm.code = ARG_VAL(8)
   LET tm.size = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)
#  LET tm.e  = ARG_VAL(11)    #FUN-B40087
   #FUN-B40087 mod -1 --start--
   LET tm.yearstr = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)
   #FUN-B40087 mod -1 --end--
#TQC-AC0207 --------------mod end------------------------
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g800_tm(0,0)		# Input print condition
      ELSE CALL g800()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g800_tm(p_row,p_col)
   DEFINE p_row,p_col	   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_direct,l_flag  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          #No.TQC-AC0075  --Begin
        # l_pib03          LIKE pib_file.pib03,
        # l_bno            LIKE pib_file.pib03,    #No.MOD-840153 add
          l_pib03          LIKE pia_file.pia01,
          l_bno            LIKE pia_file.pia01,    #No.MOD-840153 add
          #No.TQC-AC0075  --End  
          l_cnt            LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          stk_len          LIKE type_file.num5,    #FUN-630037   #No.FUN-690026 SMALLINT
          l_cmd		   LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
   DEFINE l_pia01          LIKE pia_file.pia01     #CHI-960065
   DEFINE stk_len_s        LIKE type_file.num5     #CHI-960065
   DEFINE stk_len_e        LIKE type_file.num5     #CHI-960065
   DEFINE li_result        LIKE type_file.num5     #CHI-960065
 
   LET p_row = 6 LET p_col = 30
 
   OPEN WINDOW g800_w AT p_row,p_col WITH FORM "aim/42f/aimg800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.stk='STK'   #CHI-960065
  #LET tm.bno='000001'                          #No.MOD-840153 mark
   LET tm.wc = '1=1'  #TQC-AC02067                          
   LET tm.code = 'N'
   LET tm.size = 'N'
   LET tm.a    = 'N'
#  LET tm.e    = 'N'   #No.FUN-570082  #FUN-B40087 mark
   LET tm.f    = 'N'   #No.FUN-860001
   LET tm.d    = 'N'   #FUN-B40087
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   #FUN-C10036 --START--
   IF NOT s_industry('icd') THEN
      CALL cl_set_comp_visible("d", FALSE)
   END IF
   #FUN-C10036 --END--

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
      LET INT_FLAG = 0 CLOSE WINDOW g800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF 
   
   IF cl_null(tm.wc) THEN 
      LET tm.wc = '1=1' 
   END IF 
   #TQC-AC0207 -------------add end-------------

   #No.FUN-570082  --begin
   #TQC-AC0207 --------------mod start----------------------- 
   #INPUT BY NAME tm.stk,tm.bno,tm.eno,tm.yearstr,tm.code,
   #             tm.size,tm.a,tm.e,tm.f,tm.more  #FUN-860001 tm.e
   #            WITHOUT DEFAULTS
#   INPUT BY NAME tm.yearstr,tm.code,tm.size,tm.a,tm.e,tm.f,tm.more     #FUN-B40087 mark
    INPUT BY NAME tm.yearstr,tm.code,tm.size,tm.a,tm.f,tm.d,tm.more     #FUN-B40087
       WITHOUT DEFAULTS
   #TQC-AC0207 --------------mod end----------------------------
      BEFORE INPUT
         #FUN-B40087------mark----str---
         #CALL cl_set_comp_entry("e",TRUE)
         #IF g_sma.sma115='N' THEN
         #   LET tm.e='N'
         #   DISPLAY BY NAME tm.e
         #   CALL cl_set_comp_entry("e",FALSE)
         #END IF
         #FUN-B40087------mark----end---
 
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
     #TQC-AC0207 ------------add start------- 
      AFTER FIELD yearstr
           LET l_direct = 'D'
     #TQC-AC0207 ------------add end------------ 

      AFTER FIELD a
          IF tm.a IS NULL OR tm.a NOT MATCHES '[YN]' THEN
             NEXT FIELD a
          END IF
 
     #FUN-B40087------mark----str---
     #AFTER FIELD e
     #    IF tm.e IS NULL OR tm.e NOT MATCHES '[YN]' THEN
     #       NEXT FIELD e
     #    END IF
     #FUN-B40087------mark----end---
      #No.FUN-570082  -end
 
      #FUN-860001
      AFTER FIELD f
          IF tm.f IS NULL OR tm.f NOT MATCHES '[YN]' THEN
             NEXT FIELD f
          END IF
      #--

      #FUN-B40087 --START--
      AFTER FIELD d
          IF tm.d IS NULL OR tm.d NOT MATCHES '[YN]' THEN
             NEXT FIELD d
          END IF
      #FUN-B40087 --END--
 
#TQC-AC0202 ------------------------mark start-----------------------------
#     AFTER FIELD stk
#        IF tm.stk IS NULL OR tm.stk =' ' THEN
#           NEXT FIELD stk
#        ELSE
##CHI-960065--begin--mod--------------------------
##          CALL s_check_no("aim",tm.stk,tm_stk_o,"5","pia_file","pia01","")  
##          RETURNING li_result,tm.stk                                         
##          LET tm.stk = s_get_doc_no(tm.stk)
##          DISPLAY BY NAME tm.stk                                             
##          IF (NOT li_result) THEN                                             
##              NEXT FIELD stk
##          END IF
##          LET l_pia01 = '' #TQC-9B0038
##          SELECT max(pia01) INTO l_pia01 FROM pia_file
##           WHERE pia01 LIKE tm.stk || '-%'
##          #TQC-9B0038--begin--add--------
##          IF cl_null(l_pia01) THEN 
##             CALL cl_err3("sel","pia_file",tm.stk,"","mfg0107", 
##                          "","",1) 
##             NEXT FIELD stk
##          END IF
##          #TQC-9B0038--end--add------
##          LET stk_len_s=length(tm.stk)+2
##          LET stk_len_e=length(l_pia01)
##          LET l_pib03 = l_pia01[stk_len_s,stk_len_e]
##          SELECT pib03 INTO l_pib03 FROM pib_file
##                        WHERE pib01 = tm.stk
##            IF SQLCA.sqlcode THEN
##                CALL cl_err(tm.stk,'mfg0107',1) #No.FUN-660156 
##               CALL cl_err3("sel","pib_file",tm.stk,"","mfg0107",
##                            "","",1)  #No.FUN-660156
##               NEXT FIELD stk
##            END IF
##            LET stk_len=0                 #FUN-630037
##            LET stk_len=length(tm.stk)    #FUN-630037
##            SELECT COUNT(*) INTO l_cnt FROM pia_file
##                            #WHERE pia01[1,3] matches tm.stk    #FUN-630037
##                             WHERE SUBSTRING(pia01,1,stk_len) LIKE tm.stk  #FUN-630037
##            IF l_cnt = 0 THEN
##               CALL cl_err(tm.stk,'mfg0112',1)
##               NEXT FIELD stk
##            END IF
##CHI-960065--end-mod-----------
#             LET tm.eno = l_pib03
#             DISPLAY BY NAME tm.eno
#        END IF
#
#    #--------------No.MOD-840153 add
#     BEFORE FIELD bno
#        IF NOT cl_null(l_pib03) THEN
#           LET l_bno = l_pib03 - l_pib03 + 1
#        END IF
#    #--------------No.MOD-840153 end
#     AFTER FIELD eno
#        IF tm.eno IS NOT NULL AND tm.eno < tm.bno  THEN
#       		CALL cl_err('','mfg1323',0)
#       		NEXT FIELD bno
#        END IF
#        LET l_direct = 'D'
#TQC-AC0207 -----------------------mark end--------------------------------------------
 
      BEFORE FIELD code    #列印條碼
    	 IF g_sma.sma07 MATCHES '[Nn]' THEN  #系統參數設定未與條碼系統連線
            IF l_direct='D' THEN
	       NEXT FIELD size
            ELSE
	     # NEXT FIELD eno     #TQC-AC0207 mark
               NEXT FIELD yearstr #TQC-AC0207
            END IF
         END IF
 
      AFTER FIELD code
         IF tm.code NOT MATCHES "[YN]" OR tm.code IS NULL
            THEN NEXT FIELD code
         END IF
 
      AFTER FIELD size
         IF tm.size IS NULL OR tm.size NOT MATCHES "[YNyn]"
            THEN NEXT FIELD size
         END IF
         LET l_direct ='U'
 
      AFTER FIELD more
         IF tm.more IS NULL OR tm.more NOT MATCHES "[YNyn]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
           #TQC-AC0207 -----------mark start----------------
           #LET l_flag = 'N'
           #IF tm.stk IS NULL OR tm.stk =' ' THEN
           #   LET l_flag = 'Y'
           #   DISPLAY BY NAME tm.stk
           #END IF
           #IF l_flag='Y' THEN
           #   CALL cl_err('','9033',0)
           #   NEXT FIELD stk
           #END IF
           #TQC-AC0207 ----------mark end------------------
 
#TQC-AC0207 -----------------mark start-------------------------
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(stk)
#              CALL q_pib(8,3,tm.stk) RETURNING tm.stk
#              CALL FGL_DIALOG_SETBUFFER( tm.stk )
#    #CHI-960065--begin--mod-------------------
#    #         CALL cl_init_qry_var()
#    #         LET g_qryparam.form = 'q_pib'
#    #         LET g_qryparam.default1 = tm.stk
#    #         CALL cl_create_qry() RETURNING tm.stk
#    #          CALL FGL_DIALOG_SETBUFFER( tm.stk )
#    #         DISPLAY BY NAME tm.stk
#    #         NEXT FIELD stk
#              LET g_t1 = s_get_doc_no(tm.stk)
#              CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
#              LET tm.stk=g_t1                                              
#              DISPLAY BY NAME tm.stk
#              NEXT FIELD stk
#     #CHI-960065--end--mod-------------------------
#
#           OTHERWISE
#              EXIT CASE
#
#           END CASE
#TQC-AC0207 --------------mark end--------------------
 
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
      LET INT_FLAG = 0 CLOSE WINDOW g800_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimg800'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimg800','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                       # " '",tm.stk CLIPPED,"'",     #TQC-AC0207 mark
                       # " '",tm.bno CLIPPED,"'",     #TQC-AC0207 mark
                       # " '",tm.eno CLIPPED,"'",     #TQC-AC0207 mark
                         " '",tm.wc CLIPPED,"'",     #TQC-AC0207 
                         " '",tm.code CLIPPED,"'",
                         " '",tm.size CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                        #" '",tm.e CLIPPED,"'",  #No.FUN-570082  #FUN-B40087 mark
                         " '",tm.yearstr CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimg800',g_time,l_cmd)
      END IF
      CLOSE WINDOW g800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g800()
   ERROR ""
END WHILE
   CLOSE WINDOW g800_w
END FUNCTION
 
FUNCTION g800()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#         l_time    LIKE type_file.chr8     #No.FUN-6A0074
    #     l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000 ) #FUN-D20064
          l_sql     STRING,                 #FUN-D20064
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_stkbno  LIKE pia_file.pia01,
          l_stkeno  LIKE pia_file.pia01,
         #l_gfe03   LIKE gfe_file.gfe03,    #FUN-710084   #MOD-A30152 mark
          sr        RECORD
                    stat   LIKE type_file.chr1,    #No.FUN-570082  0.原來 1.多單位  #No.FUN-690026 VARCHAR(1) 2.批序號
                    pia01  LIKE pia_file.pia01,
                    pia02  LIKE pia_file.pia02,
                    pia03  LIKE pia_file.pia03,
                    pia04  LIKE pia_file.pia04,
                    pia05  LIKE pia_file.pia05,
                    pia08  LIKE pia_file.pia08,
                    pia09  LIKE pia_file.pia09,
                    ima02  LIKE ima_file.ima02,
                    ima08  LIKE ima_file.ima08,
                    ima15  LIKE ima_file.ima15,
                    pias06 LIKE pias_file.pias06, #FUN-860001
                    pias07 LIKE pias_file.pias07,  #FUN-860001
                    ima021 LIKE ima_file.ima021   #FUN-B40087    
                  # piad06 LIKE piad_file.piad06,  #FUN-B40087   #FUN-C10036 mark
                  # piad07 LIKE piad_file.piad07   #FUN-B40087   #FUN-C10036 mark
                    END RECORD
   DEFINE l_ima906  LIKE ima_file.ima906  #FUN-B40087 add
   DEFINE l_piad RECORD LIKE piad_file.*  #FUN-C10036 add
 
   #FUN-C10036-------add----str---
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"  #FUN-860001  #MOD-A30152 remove ?    #CHI-B60076 add ?
   PREPARE insert_prep FROM g_sql

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?, ?,?, ?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   #FUN-C10036-------add----end---

   CALL cl_del_data(l_table)        #FUN-710084
   CALL cl_del_data(l_table1)       #FUN-C10036 add 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimg800'
 #FUN-710084  --begin
 # IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
 # FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   LET l_sql = " SELECT 0,pia01,pia02,pia03,pia04,pia05,pia08,pia09,", #No.FUN-570082
               "        ima02,ima08,ima15,'','',ima021,ima906", #FUN-860001      #FUN-B40087 add ima906,ima021    #FUN-C10036 del 2''
             # " FROM pia_file, OUTER ima_file ",  #TQC-AC0207 mark
               " FROM pia_file LEFT OUTER JOIN ima_file ",  #TQC-AC0207
               "   ON pia_file.pia02 = ima_file.ima01 ",    #TQC-AC0207 
             # " WHERE pia_file.pia02 = ima_file.ima01 ",   #TQC-AC0207 mark
             # "   AND pia01 LIKE '",tm.stk CLIPPED,"-%'"  #MOD-A60186 add   #TQC-AC0207 mark
               " WHERE ", tm.wc CLIPPED                    #TQC-AC0207 mark 
#TQC-AC0207 -------------mark start-------------
# #start FUN-5A0199
# #LET l_stkbno = tm.stk,'-',tm.bno
# #LET l_stkeno = tm.stk,'-',tm.eno
#  LET l_stkbno = tm.stk CLIPPED,'-',tm.bno
#  LET l_stkeno = tm.stk CLIPPED,'-',tm.eno
# #end FUN-5A0199
#  IF tm.bno IS NOT NULL AND tm.bno != ' ' THEN
#     LET l_sql = l_sql clipped," AND pia01 >='",l_stkbno,"'"
#  END IF
#  IF tm.eno IS NOT NULL AND tm.eno != ' ' THEN
#     LET l_sql = l_sql clipped," AND pia01 <='",l_stkeno,"'"
#  END IF
#TQC-AC0207 --------------mark end--------------
   LET l_sql = l_sql clipped," ORDER BY 1"
 
   PREPARE g800_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE g800_cs CURSOR FOR g800_prepare

   CALL cl_replace_str(tm.wc,"pia","piaa") RETURNING tm.wc    #TQC-AC0207 mark 
   #No.FUN-570082  --begin
   LET l_sql = " SELECT 1,piaa01,piaa02,piaa03,piaa04,piaa05,piaa08,piaa09,",
               "        ima02,ima08,ima15,'','',ima021,ima906 ",      #FUN-B40087 add ima906,ima021   #FUN-C10036 del 2''
             # " FROM piaa_file, OUTER ima_file ",             #TQC-AC0207 mark
               " FROM piaa_file LEFT OUTER JOIN ima_file ",    #TQC-AC0207
               "   ON piaa_file.piaa02 = ima_file.ima01 ",     #TQC-AC0207  
             # " WHERE piaa_file.piaa02 = ima_file.ima01 ",                   #TQC-AC0207
             # "   AND piaa01 LIKE '",tm.stk CLIPPED,"-%'"  #MOD-A60186 add   #TQC-AC0207
               " WHERE ",tm.wc CLIPPED                      #TQC-AC0207  
#TQC-AC0207 -----------------mark start-----------------
#  IF tm.bno IS NOT NULL AND tm.bno != ' ' THEN
#     LET l_sql = l_sql clipped," AND piaa01 >='",l_stkbno,"'"
#  END IF
#  IF tm.eno IS NOT NULL AND tm.eno != ' ' THEN
#     LET l_sql = l_sql clipped," AND piaa01 <='",l_stkeno,"'"
#  END IF
#TQC-AC0207 ---------------- mark end-------------------------
   LET l_sql = l_sql clipped," ORDER BY piaa01,piaa09"
 
   PREPARE g800_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE g800_cs1 CURSOR FOR g800_prepare1
   LET l_sql = " UPDATE piaa_file ",
               " SET piaa15=piaa15+1,",
               "     piaa14='",g_today,"' " ,
               " WHERE piaa01=? AND piaa09=?"
   PREPARE g800_up1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #No.FUN-570082  --end
 
   #No.FUN-860001  --begin
   CALL cl_replace_str(tm.wc,"piaa","pias") RETURNING tm.wc         #TQC-AC0207
   LET l_sql = " SELECT 2,pias01,pias02,pias03,pias04,pias05,pias09,pias10,",
               "        ima02,ima08,ima15,pias06,pias07,ima021 ",     #FUN-B40087 ima021,'',''   #FUN-C10036 del 2''
             # " FROM pias_file, OUTER ima_file ",                  #TQC-AC0207mark
               " FROM pias_file LEFT OUTER JOIN ima_file ",         #TQC-AC0207
               "   ON pias_file.pias02 = ima_file.ima01 ",          #TQC-AC0207
             # " WHERE pias_file.pias02 = ima_file.ima01 ",         #TQC-AC0207
             # "   AND pias01 LIKE '",tm.stk CLIPPED,"-%'"  #MOD-A60186 add #TQC-AC0207
               " WHERE ",tm.wc CLIPPED                                      #TQC-AC0207 
#TQC-AC0207 ---------mark start----------------------------
#  IF tm.bno IS NOT NULL AND tm.bno != ' ' THEN
#     LET l_sql = l_sql clipped," AND pias01 >='",l_stkbno,"'"
#  END IF
#  IF tm.eno IS NOT NULL AND tm.eno != ' ' THEN
#     LET l_sql = l_sql clipped," AND pias01 <='",l_stkeno,"'"
#  END IF
#TQC-AC0207 ------------mark end---------------------------------
   LET l_sql = l_sql clipped," ORDER BY pias01,pias06,pias07"
 
   PREPARE g800_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE g800_cs2 CURSOR FOR g800_prepare2
   #end-FUN-860001

   #FUN-C10036 --START--
   IF s_industry('icd') THEN
      CALL cl_replace_str(tm.wc,"pias","piad") RETURNING tm.wc
      LET l_sql = " SELECT piad_file.* ",
                  " FROM piad_file LEFT OUTER JOIN ima_file ",
                  "   ON piad_file.piad02 = ima_file.ima01 ",
                  " WHERE ",tm.wc CLIPPED
      LET l_sql = l_sql clipped," ORDER BY piad01,piad06,piad07"

      PREPARE g800_prepare3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
         EXIT PROGRAM
      END IF
      DECLARE g800_cs3 CURSOR FOR g800_prepare3
   END IF
   #FUN-C10036 --END-
 
 # CALL cl_outnam('aimg800') RETURNING l_name
   LET l_sql = " UPDATE pia_file ",
               " SET pia15=pia15+1,",
               "     pia14='",g_today,"' " ,
               " WHERE pia01=? "
   PREPARE g800_up FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
 # START REPORT g800_rep TO l_name
 # LET g_pageno = 0
 
   FOREACH g800_cs INTO sr.*,l_ima906  #FUN-B40087 add l_ima906
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
     #SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.pia09   #MOD-A30152 mark
      IF l_ima906 MATCHES '[13]' THEN #FUN-B40087 add
         #更新列印次數及列印日期
         EXECUTE g800_up  USING sr.pia01
         EXECUTE insert_prep USING
           sr.pia01,sr.pia02,sr.pia03,sr.pia04,
           sr.pia05,sr.pia08,sr.pia09,sr.ima02,
          #sr.ima08,sr.ima15,sr.stat,l_gfe03,' ',' ', #FUN-860001  #MOD-A30152 mark
	#  sr.ima08,sr.ima15,sr.stat,' ',' ',sr.ima021,' ',' ' #FUN-860001          #MOD-A30152    #FUN-B40087 add sr.ima021,'',''  #FUN-C10036 mark
           sr.ima08,sr.ima15,sr.stat,' ',' ',sr.ima021 #FUN-860001          #MOD-A30152    #FUN-B40087 add sr.ima021,'',''     #FUN-C10036 del 2''
      END IF #FUN-B40087 add
 #       OUTPUT TO REPORT g800_rep(sr.*)
   END FOREACH
 
   #No.FUN-570082  --begin
#  IF g_sma.sma115='Y' AND tm.e='Y' THEN   #FUN-B40087 mark
   IF g_sma.sma115='Y' THEN    #FUN-B40087
      FOREACH g800_cs1 INTO sr.*,l_ima906   #FUN-B40087 add l_ima906
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
        #SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.pia09   #MOD-A30152 mark
         IF l_ima906 = '2' THEN  #FUN-B40087
            #更新列印次數及列印日期
            EXECUTE g800_up1  USING sr.pia01,sr.pia09
            EXECUTE insert_prep USING
              sr.pia01,sr.pia02,sr.pia03,sr.pia04,
              sr.pia05,sr.pia08,sr.pia09,sr.ima02,
             #sr.ima08,sr.ima15,sr.stat,l_gfe03,' ',' ' #FUN-860001  #MOD-A30152 mark
            # sr.ima08,sr.ima15,sr.stat,' ',' ',sr.ima021,' ',' '   #FUN-860001          #MOD-A30152     #FUN-B40087 add ima021,' ',''    #FUN-C10036 mark
              sr.ima08,sr.ima15,sr.stat,' ',' ',sr.ima021   #FUN-860001          #MOD-A30152     #FUN-B40087 add ima021,' ',''    #FUN-C10036 del 2''
         END IF  #FUN-B40087
 #       OUTPUT TO REPORT g800_rep(sr.*)
      END FOREACH
   END IF
   #No.FUN-570082  --end
 
   #No.FUN-860001  --begin
   IF tm.f='Y' THEN
      FOREACH g800_cs2 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
        #SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.pia09   #MOD-A30152 mark
         EXECUTE insert_prep USING
           sr.pia01,sr.pia02,sr.pia03,sr.pia04,
           sr.pia05,sr.pia08,sr.pia09,sr.ima02,
          #sr.ima08,sr.ima15,sr.stat,l_gfe03,   #MOD-A30152 mark
           sr.ima08,sr.ima15,sr.stat,           #MOD-A30152
         # sr.pias06,sr.pias07,sr.ima021,' ',' '  #FUN-860001  #FUN-C10036 add ima021 ,' ' ,' '
           sr.pias06,sr.pias07,sr.ima021  #FUN-860001  #FUN-C10036 add ima021 ,' ' ,' '    #FUN-C10036 del 2''
 #       OUTPUT TO REPORT g800_rep(sr.*)
      END FOREACH
   END IF
   #No.FUN-860001  --end

   #FUN-B40087 --START--
   IF s_industry('icd') THEN
      IF tm.d='Y' THEN
         FOREACH g800_cs3 INTO l_piad.* 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            EXECUTE insert_prep1 USING
              l_piad.piad01,l_piad.piad02,l_piad.piad03,l_piad.piad04,
              l_piad.piad05,l_piad.piad06,l_piad.piad07
         END FOREACH
      END IF
   END IF
   #FUN-B40087 --END--
 
 # FINISH REPORT g800_rep
 
 # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
  #---------------------No.MOD-930047 modify
  #LET l_sql = "SELECT * FROM ",l_table CLIPPED
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED,"|"  #FUN-C10036 add             
  #---------------------No.MOD-930047 end
 # CALL cl_replace_str(tm.wc,"pias","pia") RETURNING tm.wc     #TQC-AC0207   #FUN-C10036 mark
   CALL cl_replace_str(tm.wc,"piad","pia") RETURNING tm.wc     #TQC-AC0207   #FUN-C10036 add
###GENGRE###   LET g_str = tm.code,";",tm.size,";",tm.yearstr,";",tm.a,";",g_sma.sma888,";",tm.f    #TQC-AC0207 add tm.wc    #FUN-C10036 del tm.wc   add tm.f
 # CALL cl_prt_cs3('aimg800',l_sql,g_str)    #TQC-730088
###GENGRE###   CALL cl_prt_cs3('aimg800','aimg800',l_sql,g_str) 
    CALL aimg800_grdata()    ###GENGRE###
 
 #FUN-710084  --end
END FUNCTION
 
#FUN-710084  --begin
#REPORT g800_rep(sr)
#DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr        RECORD
#                 stat   LIKE type_file.chr1,   #No.FUN-570082  #No.FUN-690026 VARCHAR(1)
#                 pia01  LIKE pia_file.pia01,
#                 pia02  LIKE pia_file.pia02,
#                 pia03  LIKE pia_file.pia03,
#                 pia04  LIKE pia_file.pia04,
#                 pia05  LIKE pia_file.pia05,
#                 pia08  LIKE pia_file.pia08,
#                 pia09  LIKE pia_file.pia09,
#                 ima02  LIKE ima_file.ima02,
#                 ima08  LIKE ima_file.ima08,
#                 ima15  LIKE ima_file.ima15
#                 END RECORD,
#       l_barcode     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#       l_i,l_j,l_len LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_control     LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#       l_advance     LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#       l_ff          LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#       l_c           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_gfe03       LIKE gfe_file.gfe03,    #FUN-5B0137
#       l_01          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
#	
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 0
#       # PAGE LENGTH g_page_line
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pia01,sr.stat,sr.pia09  #No.FUN-570082
#  FORMAT
#   PAGE HEADER
#      LET l_last_sw = 'n'         #FUN-550108
#
#   #No.FUN-570082  --begin
#   #BEFORE GROUP OF sr.pia01
#   BEFORE GROUP OF sr.pia09
#   #No.FUN-570082  --end
#      SKIP TO TOP OF PAGE   #No.+290 010628 add by linda
#		#下列資料為條碼的控制碼資料
#		LET l_control[1]=ascii 27	#ESC
#		LET l_control[2]='*'		#*
#		LET l_control[3]=ascii 33	#33 120 dots/inch
#		         			#32  60 dots/inch
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
#      LET l_last_sw = 'y' ## FUN-550108
#      IF tm.size='Y' THEN
#         PRINT ' '
#      ELSE
#         PRINT COLUMN 23,g_x[21] CLIPPED #MOD-590522 16->23
#      END IF
#      PRINT " "
#      PRINT " "
#      IF tm.size='N' THEN
#         PRINT g_x[11] CLIPPED,sr.pia01;
#         IF tm.yearstr IS NOT NULL THEN
#            PRINT COLUMN 25,g_x[23] CLIPPED, tm.yearstr
#         ELSE PRINT ' '
#         END IF
#      ELSE
#         PRINT COLUMN 10,sr.pia01,
#               COLUMN 30,tm.yearstr
#      END IF
#
#  	IF tm.code='N' THEN
#		#不使用條碼時, 則往前跳躍90/180"
#		LET l_advance[3]=ascii 90
#               #PRINT l_advance #MOD-5B0337 mark
#	ELSE
# 		#使用條碼(三九碼), 則以下列方式來列印
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
#		   PRINT COLUMN 11,l_control CLIPPED;
#		   FOR l_i=1 TO l_len		#將1轉換成FF
#		      LET l_c=l_01[l_i,l_i]	#將0轉換成00
#		      IF l_c='1'
#                         THEN PRINT l_ff;
#		            ELSE PRINT FILE '/nulls'
#		         #ELSE PRINT FILE '/test'
#                      END IF
#		   END FOR
#		   PRINT l_advance CLIPPED;PRINT '          ';
#		END FOR
#		LET l_advance[3]=ascii 27
#		PRINT l_advance
#	END IF
#    IF tm.size='N' THEN
#        PRINT COLUMN 01, g_x[12] CLIPPED,sr.pia02
#             #COLUMN 32, g_x[24] CLIPPED,sr.ima08 #MOD-590522
#        PRINT COLUMN 01, g_x[13] CLIPPED,sr.ima02
#        PRINT COLUMN 01, g_x[24] CLIPPED,sr.ima08 #MOD-590522
#        PRINT " "
#
#        PRINT COLUMN 01,g_x[14] CLIPPED,sr.pia03;
#        IF g_sma.sma888='Y'
#        THEN PRINT COLUMN 30,g_x[25] CLIPPED,sr.ima15
#        ELSE PRINT ' '
#        END IF
#        PRINT COLUMN 01,g_x[15] CLIPPED,sr.pia04
#        PRINT COLUMN 01,g_x[16] CLIPPED,sr.pia05
#        PRINT " "
#        #No.FUN-570082  --begin
#        IF sr.stat='0' THEN
#           PRINT COLUMN 01,g_x[22] CLIPPED,sr.pia09;  #庫存單位
#        ELSE
#           PRINT COLUMN 01,g_x[28] CLIPPED,sr.pia09;  #多庫存單位
#        END IF
#        #No.FUN-570082  --end
#        #No.B341 010416 add by linda
#        IF tm.a = 'Y' THEN
#           #FUN-5B0137...............begin
#           LET l_gfe03=0
#           SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.pia09
#           #FUN-5B0137...............end
#          #PRINT COLUMN 25,g_x[26] CLIPPED,sr.pia08 USING "--------&" #MOD-590522 20->25 #FUN-5B0137
#           PRINT COLUMN 25,g_x[26] CLIPPED,cl_numfor(sr.pia08,15,l_gfe03)   #FUN-5B0137
#        ELSE
#           PRINT " "
#        END IF
#        #No.B341 end-----
#        PRINT " "
#
#       #PRINT COLUMN 11,g_x[17] CLIPPED #MOD-590522
#        PRINT COLUMN 15,g_x[17] CLIPPED #MOD-590522
#        PRINT " "
#        PRINT COLUMN 01,g_x[18] CLIPPED
#       #PRINT "          ------------    ------------     "
#        PRINT "           -----------------    -----------------     " #MOD-590522
#        PRINT " "
#        PRINT COLUMN 01,g_x[19] CLIPPED
#       #PRINT "          ------------    ------------     "
#        PRINT "           -----------------    -----------------     " #MOD-590522
#        PRINT " "
#        PRINT COLUMN 01,g_x[20] CLIPPED
#       #PRINT "          ------------    ------------     "
#        PRINT "           -----------------    -----------------     " #MOD-590522
#        SKIP 6 LINE
#    ELSE
#        PRINT COLUMN 10,sr.pia02,
#              COLUMN 39,sr.ima08
#        PRINT COLUMN 10,sr.ima02
#        PRINT " "
#
#        PRINT COLUMN 10,sr.pia03;
#        IF g_sma.sma888 ='Y'
#        THEN PRINT COLUMN 39,sr.ima15
#        ELSE PRINT ''
#        END IF
#        PRINT COLUMN 10,sr.pia04
#        PRINT COLUMN 10,sr.pia05
#        PRINT " "
#        PRINT COLUMN 10,sr.pia09;
#        #No.B341 010416 by linda add
#        IF tm.a = 'Y' THEN
#           #FUN-5B0137...............begin
#           LET l_gfe03=0
#           SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.pia09
#           #FUN-5B0137...............end
#          #PRINT COLUMN 30,sr.pia08 USING "--------&" #FUN-5B0137
#           PRINT COLUMN 30,cl_numfor(sr.pia08,15,l_gfe03) #FUN-5B0137
#        ELSE
#           PRINT " "
#        END IF
#        #No.B341 -----
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        SKIP 6 LINE
#   END IF
#
### FUN-550108
#   PAGE TRAILER
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[27]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[27]
#             PRINT g_memo
#      END IF
### END FUN-550108
#
#END REPORT
 
#將所要印的單號, 轉換成條碼
#FUNCTION to01(p_code)
#DEFINE
#	p_code       LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#	l_c          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#	l_01         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
#	l_01c        LIKE type_file.chr21,   #No.FUN-690026 VARCHAR(21)
#	l_length,l_i LIKE type_file.num5     #No.FUN-690026 SMALLINT
#
#	#決定要loop的次數
#	LET l_length=LENGTH(p_code)
#	LET l_01=' '
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
#FUN-710084  --end
#Patch....NO.TQC-610036 <001> #

###GENGRE###START
FUNCTION aimg800_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    DEFINE sr2      sr2_t    #FUN-C10036 add

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aimg800")
        IF handler IS NOT NULL THEN
            START REPORT aimg800_rep TO XML HANDLER handler
#           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,   #FUN-C10036 mark
#                       " ORDER BY pia01"                                       #FUN-C10036 mark
            #FUN-C10036-------------add----str-----
            LET l_sql = "SELECT A.*,B.* FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " A LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
                        " ON A.pia01 = B.piad01",
                        " ORDER BY pia01"
            #FUN-C10036-------------add----end-----
          
            DECLARE aimg800_datacur1 CURSOR FROM l_sql
            FOREACH aimg800_datacur1 INTO sr1.*,sr2.*        #FUN-C10036 add sr2.*
                OUTPUT TO REPORT aimg800_rep(sr1.*,sr2.*)    #FUN-C10036 add sr2.*
            END FOREACH
            FINISH REPORT aimg800_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aimg800_rep(sr1,sr2)    #FUN-C10036 add sr2
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40087-----add------str----
    DEFINE l_pia09     STRING
    DEFINE l_stat      LIKE type_file.chr1   
    DEFINE l_gfe03     LIKE gfe_file.gfe03
    DEFINE l_pia08_fmt STRING 
    #FUN-B40087-----add------end-----
    DEFINE sr2 sr2_t     #FUN-C10036 add
    DEFINE l_sql       STRING    #FUN-C10036 add

    ORDER EXTERNAL BY sr1.pia01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_sma.sma888    #FUN-B40087 add
              
        BEFORE GROUP OF sr1.pia01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-C10036-----add---str---
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE piad01 = '",sr1.pia01 CLIPPED,"'",
                        " AND piad02 = '",sr1.pia02 CLIPPED,"'",
                        " AND piad03 = '",sr1.pia03 CLIPPED,"'",
                        " AND piad04 = '",sr1.pia04 CLIPPED,"'",
                        " AND piad05 = '",sr1.pia05 CLIPPED,"'"
            START REPORT aimg800_subrep01
            DECLARE aimg800_repcur1 CURSOR FROM l_sql
            FOREACH aimg800_repcur1 INTO sr2.*
                OUTPUT TO REPORT aimg800_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT aimg800_subrep01
            #FUN-C10036-----add---end---
            #FUN-B40087-----add------str----
            LET l_gfe03 = 0
            SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr1.pia09
            LET l_pia08_fmt = cl_gr_numfmt('pia_file','pia08',l_gfe03)
            PRINTX l_pia08_fmt
            IF sr1.stat = "0" THEN
               LET l_stat = "0"
            ELSE
               LET  l_stat = "1"
            END IF
            LET l_pia09 = cl_gr_getmsg("gre-054",g_lang,l_stat),':',sr1.pia09
            PRINTX l_pia09 
            #FUN-B40087-----add------end----

            PRINTX sr1.*
            PRINTX sr2.*    #FUN-C10036 add

        AFTER GROUP OF sr1.pia01

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C10036----add---str--
REPORT aimg800_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT
#FUN-C10036----add---end--

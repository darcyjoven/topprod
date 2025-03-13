# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: axmg559.4gl
# Descriptions...: Packing List
# Date & Author..: 96/08/13 by xujing
# Modify.........: No.FUN-CB0074 12/12/19 By lujh  CR轉GR
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm           RECORD                         # Print condition RECORD
                     wc      STRING,      # Where condition
                     a       LIKE type_file.chr1,
                     more    LIKE type_file.chr1       # 列印公司對外全名
                    END RECORD,
       l_oao06      LIKE oao_file.oao06,
       x            LIKE aba_file.aba00,     # No.FUN-680137 VARCHAR(5)
       y,z          LIKE type_file.chr1,     # No.FUN-680137 VARCHAR(1)
       tot_ctn	    LIKE type_file.num10,    # No.FUN-680137 INTEGER
       wk_i         LIKE type_file.num5,     # No.FUN-680137 SMALLINT
       wk_array     DYNAMIC ARRAY OF RECORD
                     ogd11      LIKE ogd_file.ogd11,
                     ogd12b     LIKE ogd_file.ogd12b,
                     ogd12e     LIKE ogd_file.ogd12e
          	    END        RECORD,
       g_po_no,g_ctn_no1,g_ctn_no2     LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
       g_azi02	    LIKE type_file.chr20,      # No.FUN-680137 VARCHAR(20)
       g_zo12	    LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(60)
       g_zo042      LIKE zo_file.zo042,        #FUN-810029 add
       g_zo05       LIKE zo_file.zo05,         #FUN-810029 add
       g_zo09       LIKE zo_file.zo09          #FUN-810029 add
 
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE i            LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE j            LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE l_table      STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table1     STRING
DEFINE l_table2     STRING
DEFINE l_table3     STRING
DEFINE l_table4     STRING      #No.FUN-840230
DEFINE l_sql        STRING    #FUN-CB0074  add
 
###GENGRE###START
TYPE sr1_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    ofa02 LIKE ofa_file.ofa02,
    ofa16 LIKE ofa_file.ofa16,
    ofa61 LIKE ofa_file.ofa61,
    ofa0453 LIKE ofa_file.ofa0453,
    ofa0454 LIKE ofa_file.ofa0454,
    ofa0455 LIKE ofa_file.ofa0455,
    ocf01 LIKE ocf_file.ocf01,
    ocf02 LIKE ocf_file.ocf02,
    ocf101 LIKE ocf_file.ocf101,
    ocf102 LIKE ocf_file.ocf102,
    ocf103 LIKE ocf_file.ocf103,
    ocf104 LIKE ocf_file.ocf104,
    ocf105 LIKE ocf_file.ocf105,
    ocf106 LIKE ocf_file.ocf106,
    ocf107 LIKE ocf_file.ocf107,
    ocf108 LIKE ocf_file.ocf108,
    ocf109 LIKE ocf_file.ocf109,
    ocf110 LIKE ocf_file.ocf110,
    ocf111 LIKE ocf_file.ocf111,
    ocf112 LIKE ocf_file.ocf112,
    ocf201 LIKE ocf_file.ocf201,
    ocf202 LIKE ocf_file.ocf202,
    ocf203 LIKE ocf_file.ocf203,
    ocf204 LIKE ocf_file.ocf204,
    ocf205 LIKE ocf_file.ocf205,
    ocf206 LIKE ocf_file.ocf206,
    ocf207 LIKE ocf_file.ocf207,
    ocf208 LIKE ocf_file.ocf208,
    ocf209 LIKE ocf_file.ocf209,
    ocf210 LIKE ocf_file.ocf210,
    ocf211 LIKE ocf_file.ocf211,
    ocf212 LIKE ocf_file.ocf212,
    zo042 LIKE zo_file.zo042
END RECORD

TYPE sr2_t RECORD
    ofb01 LIKE ofb_file.ofb01,
    ofb06 LIKE ofb_file.ofb06,
    ogd10 LIKE ogd_file.ogd13,
    ogd13 LIKE ogd_file.ogd13,
    obe21 LIKE obe_file.obe21,
    obe11 LIKE obe_file.obe11,
    ogd14t LIKE ogd_file.ogd14t,
    ogd15t LIKE ogd_file.ogd15t,
    ogd16t LIKE ogd_file.ogd16t
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql= "ofa01.ofa_file.ofa01,    ofa02.ofa_file.ofa02,",
              "ofa16.ofa_file.ofa16,    ofa61.ofa_file.ofa61,",
              "ofa0453.ofa_file.ofa0453,ofa0454.ofa_file.ofa0454,",
              "ofa0455.ofa_file.ofa0455,ocf01.ocf_file.ocf01,ocf02.ocf_file.ocf02,",                 
              "ocf101.ocf_file.ocf101,ocf102.ocf_file.ocf102,ocf103.ocf_file.ocf103,",
              "ocf104.ocf_file.ocf104,ocf105.ocf_file.ocf105,ocf106.ocf_file.ocf106,",
              "ocf107.ocf_file.ocf107,ocf108.ocf_file.ocf108,ocf109.ocf_file.ocf109,",
              "ocf110.ocf_file.ocf110,ocf111.ocf_file.ocf111,ocf112.ocf_file.ocf112,",
              "ocf201.ocf_file.ocf201,ocf202.ocf_file.ocf202,ocf203.ocf_file.ocf203,",
              "ocf204.ocf_file.ocf204,ocf205.ocf_file.ocf205,ocf206.ocf_file.ocf206,",
              "ocf207.ocf_file.ocf207,ocf208.ocf_file.ocf208,ocf209.ocf_file.ocf209,",
              "ocf210.ocf_file.ocf210,ocf211.ocf_file.ocf211,ocf212.ocf_file.ocf212,",
              "zo042.zo_file.zo042"     #MOD-940004 #TQC-BC0009
   LET l_table = cl_prt_temptable('axmg559',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql ="ofb01.ofb_file.ofb01,", 
              "ofb06.ofb_file.ofb06,",
              "ogd10.ogd_file.ogd13,",
              "ogd13.ogd_file.ogd13,",
              "obe21.obe_file.obe21,",
              "obe11.obe_file.obe11,",
              "ogd14t.ogd_file.ogd14t,",
              "ogd15t.ogd_file.ogd15t,",
              "ogd16t.ogd_file.ogd16t"
   LET l_table1 = cl_prt_temptable('axmg5591',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生

   LET g_zo042 = NULL 
   SELECT zo042 INTO g_zo042   
     FROM zo_file WHERE zo01= g_lang

   IF cl_null(g_zo042) THEN
      SELECT zo041 INTO g_zo042 FROM zo_file WHERE zo01= g_lang
   END IF

 
   IF cl_null(tm.wc) THEN
      CALL axmg559_tm(0,0)             # Input print condition
   ELSE 
      LET tm.wc = " ofa011='",tm.wc CLIPPED,"'"
      CALL axmg559()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmg559_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 8 LET p_col = 17
 
   OPEN WINDOW axmg559_w AT p_row,p_col WITH FORM "axm/42f/axmg559"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   CALL cl_opmsg('p')
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ofa01,ofa02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ofa01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ofa"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ofa01
                    NEXT FIELD ofa01
            END CASE
 
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmg559_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS   #FUN-5A0087   #FUN-740057 add tm.b,tm.c
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
 
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axmg559_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axmg559'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmg559','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmg559',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axmg559_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmg559()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmg559_w
END FUNCTION
 
FUNCTION axmg559()
   DEFINE l_name     LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql,l_sql1      STRING,
          sr         RECORD
                     ofa01   LIKE ofa_file.ofa01,
                     ofa02   LIKE ofa_file.ofa02,
                     ofa16   LIKE ofa_file.ofa16,
                     ofa61   LIKE ofa_file.ofa61,
                     ofa0453 LIKE ofa_file.ofa0453,
                     ofa0454 LIKE ofa_file.ofa0454,
                     ofa0455 LIKE ofa_file.ofa0455,
                     ocf01   LIKE ocf_file.ocf01,
                     ocf02   LIKE ocf_file.ocf02,
                     ocf101  LIKE ocf_file.ocf101,
                     ocf102  LIKE ocf_file.ocf102,
                     ocf103  LIKE ocf_file.ocf103,
                     ocf104  LIKE ocf_file.ocf104,
                     ocf105  LIKE ocf_file.ocf105,
                     ocf106  LIKE ocf_file.ocf106,
                     ocf107  LIKE ocf_file.ocf107,
                     ocf108  LIKE ocf_file.ocf108,
                     ocf109  LIKE ocf_file.ocf109,
                     ocf110  LIKE ocf_file.ocf110,
                     ocf111  LIKE ocf_file.ocf111,
                     ocf112  LIKE ocf_file.ocf112,
                     ocf201  LIKE ocf_file.ocf201,
                     ocf202  LIKE ocf_file.ocf202,
                     ocf203  LIKE ocf_file.ocf203,
                     ocf204  LIKE ocf_file.ocf204,
                     ocf205  LIKE ocf_file.ocf205,
                     ocf206  LIKE ocf_file.ocf206,
                     ocf207  LIKE ocf_file.ocf207,
                     ocf208  LIKE ocf_file.ocf208,
                     ocf209  LIKE ocf_file.ocf209,
                     ocf210  LIKE ocf_file.ocf210,
                     ocf211  LIKE ocf_file.ocf211,
                     ocf212  LIKE ocf_file.ocf212,
                     zo042   LIKE zo_file.zo042
                     END RECORD,
            sr1      RECORD
                     ofb01   LIKE ofb_file.ofb01,
                     ofb06   LIKE ofb_file.ofb06,
                     ogd10   LIKE ogd_file.ogd10,
                     ogd13   LIKE ogd_file.ogd13,
                     obe21   LIKE obe_file.obe21,
                     obe11   LIKE obe_file.obe11,
                     ogd14t  LIKE ogd_file.ogd14t,
                     ogd15t  LIKE ogd_file.ogd15t,
                     ogd16t  LIKE ogd_file.ogd16t
                     END RECORD,
         l_ofa10     LIKE ofa_file.ofa10,
         l_ofa45     LIKE ofa_file.ofa45,
         l_ofa46     LIKE ofa_file.ofa46
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   #------------------------------ CR (2) ------------------------------#

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"

   PREPARE insert_prep FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM                        
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM                        
   END IF
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
 

   LET l_sql="SELECT DISTINCT ofa01,ofa02,ofa16,ofa61,ofa0453,ofa0454,ofa0455,ocf_file.*,'",
             g_zo042 CLIPPED,"',ofa10,ofa45,ofa46",
             "  FROM ofa_file LEFT OUTER JOIN ocf_file ON ocf01=ofa04 AND ocf02=ofa44",
             " WHERE  ofaconf !='X' ",   #不可為作廢的資料
             "   AND ",tm.wc CLIPPED 

   PREPARE axmg559_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE axmg559_curs1 CURSOR FOR axmg559_prepare1

display time 
   FOREACH axmg559_curs1 INTO  sr.*,l_ofa10,l_ofa45,l_ofa46
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

#      LET sr.zo042 = g_zo042
      LET l_sql = "SELECT ofb01,ofb06,ogd10,ogd13,obe21,obe11,ogd14t,ogd15t,ogd16t",
                  " FROM ofb_file,ogd_file,obe_file",
                  " WHERE ofb01='",sr.ofa01 CLIPPED,"'",
                  "   AND ogd01=ofb34 AND ogd03=ofb35",       #AND ogd04='1'",
                  "   AND obe_file.obe01=ogd_file.ogd08"
      PREPARE  axmg559_prepare2 FROM l_sql
#      DECLARE  axmg559_curs2 CURSOR FOR axmg559_prepare2
      LET l_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED, 
                   " ",l_sql
      PREPARE  axmg559_prepare3 FROM l_sql1
      EXECUTE  axmg559_prepare3
{      FOREACH axmg559_curs2 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF

         EXECUTE insert_prep1 USING sr1.*
      END FOREACH 
}
      #客戶嘜頭檔
      LET g_po_no=l_ofa10 LET g_ctn_no1=l_ofa45 LET g_ctn_no2=l_ofa46 
      LET sr.ocf101=ocf_c(sr.ocf101) LET sr.ocf201=ocf_c(sr.ocf201)
      LET sr.ocf102=ocf_c(sr.ocf102) LET sr.ocf202=ocf_c(sr.ocf202)
      LET sr.ocf103=ocf_c(sr.ocf103) LET sr.ocf203=ocf_c(sr.ocf203)
      LET sr.ocf104=ocf_c(sr.ocf104) LET sr.ocf204=ocf_c(sr.ocf204)
      LET sr.ocf105=ocf_c(sr.ocf105) LET sr.ocf205=ocf_c(sr.ocf205)
      LET sr.ocf106=ocf_c(sr.ocf106) LET sr.ocf206=ocf_c(sr.ocf206)
      LET sr.ocf107=ocf_c(sr.ocf107) LET sr.ocf207=ocf_c(sr.ocf207)
      LET sr.ocf108=ocf_c(sr.ocf108) LET sr.ocf208=ocf_c(sr.ocf208)
      LET sr.ocf109=ocf_c(sr.ocf109) LET sr.ocf209=ocf_c(sr.ocf209)
      LET sr.ocf110=ocf_c(sr.ocf110) LET sr.ocf210=ocf_c(sr.ocf210)
      LET sr.ocf111=ocf_c(sr.ocf111) LET sr.ocf211=ocf_c(sr.ocf211)
      LET sr.ocf112=ocf_c(sr.ocf112) LET sr.ocf212=ocf_c(sr.ocf212)

      EXECUTE insert_prep USING sr.*
   END FOREACH   
display time 
     
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ofa01,ofa02')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF
###GENGRE###   LET g_str = tm.wc
###GENGRE###   CALL cl_prt_cs3('axmg559','axmg559',g_sql,g_str)
    CALL axmg559_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str    LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30)

  # 把麥頭內'PPPPPP'字串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (ofa.ofa46)
  LET g_ctn_no1=g_ctn_no1 USING "######"
  LET g_ctn_no2=g_ctn_no2 USING "######"
  FOR i=1 TO 25
     IF str[i,i+5]='PPPPPP' THEN LET str[i,30]=g_po_no    END IF
     IF str[i,i+5]='CCCCCC' THEN LET str[i,i+5]=g_ctn_no1 END IF
     IF str[i,i+5]='DDDDDD' THEN LET str[i,i+5]=g_ctn_no2 END IF
  END FOR
  RETURN str
END FUNCTION


###GENGRE###START
FUNCTION axmg559_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg559")
        IF handler IS NOT NULL THEN
            START REPORT axmg559_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                       ," ORDER BY ofa01"
          
            DECLARE axmg559_datacur1 CURSOR FROM l_sql
            FOREACH axmg559_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg559_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg559_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg559_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_ofa0453 LIKE ofa_file.ofa0453   #FUN-CB0074  add

    ORDER EXTERNAL BY sr1.ofa01 
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ofa01
            LET l_lineno = 0
 
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

            #FUN-CB0074--add--str--
            LET l_ofa0453 = sr1.ofa0453,'/',sr1.ofa0454,'/',sr1.ofa0455
            PRINTX l_ofa0453

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED, 
                        " WHERE ofb01= '",sr1.ofa01,"'"
            START REPORT axmg559_subrep01
            DECLARE axmg559_subrep01 CURSOR FROM l_sql
            FOREACH axmg559_subrep01 INTO sr2.*
                OUTPUT TO REPORT axmg559_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg559_subrep01
            #FUN-CB0074--add--end--


        AFTER GROUP OF sr1.ofa01        
       
        ON LAST ROW

END REPORT

#FUN-CB0074--add--str--
REPORT axmg559_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_ogd10_obe21 STRING 
    DEFINE l_ogd13_obe11 STRING 
    DEFINE l_ogd15_kgs   STRING 
    DEFINE l_ogd14_kgs   STRING 
    DEFINE l_ogd16t_cbm  STRING 
    DEFINE l_sum_ogd10   STRING 
    DEFINE l_ogd10_sum   STRING 
    DEFINE l_sum_ogd13   STRING 
    DEFINE l_ogd13_sum   STRING 
    DEFINE l_sum_ogd15t  STRING 
    DEFINE l_ogd15t_sum  STRING 
    DEFINE l_sum_ogd14t  STRING 
    DEFINE l_ogd14t_sum  STRING 
    DEFINE l_sum_ogd16t  STRING 
    DEFINE l_ogd16t_sum  STRING 
    DEFINE l_ogd13_ogd10 STRING
    DEFINE l_ogd14_NW    STRING
    DEFINE l_ogd15_GW    STRING
    DEFINE l_ogd10   STRING 
    DEFINE l_ogd13   STRING 
    DEFINE l_ogd15t  STRING 
    DEFINE l_ogd14t  STRING 
    DEFINE l_ogd16t  STRING 


    ORDER EXTERNAL BY sr2.ofb01  
    FORMAT
        ON EVERY ROW
           LET l_ogd10 = sr2.ogd10
           LET l_ogd10_obe21 = l_ogd10,sr2.obe21
           PRINTX l_ogd10_obe21

           LET l_ogd13 = sr2.ogd13
           LET l_ogd13_obe11 = l_ogd13,sr2.obe11
           PRINTX l_ogd13_obe11

           LET l_ogd15t = sr2.ogd15t
           LET l_ogd15_kgs = l_ogd15t,'KGS'
           PRINTX l_ogd15_kgs

           LET l_ogd14t = sr2.ogd14t
           LET l_ogd14_kgs = l_ogd14t,'KGS'
           PRINTX l_ogd14_kgs

           LET l_ogd16t = sr2.ogd16t
           LET l_ogd16t_cbm = l_ogd16t,'CBM'
           PRINTX l_ogd16t_cbm
           PRINTX sr2.*

        AFTER GROUP OF sr2.ofb01 
           LET l_ogd10_sum =GROUP SUM(sr2.ogd10)
           LET l_sum_ogd10 = l_ogd10_sum,sr2.obe21
           PRINTX l_sum_ogd10

           LET l_ogd13_sum =GROUP SUM(sr2.ogd13)
           LET l_sum_ogd13 = l_ogd13_sum,sr2.obe11
           PRINTX l_sum_ogd13

           LET l_ogd15t_sum =GROUP SUM(sr2.ogd15t)
           LET l_sum_ogd15t = l_ogd15t_sum,'KGS'
           PRINTX l_sum_ogd15t

           LET l_ogd14t_sum =GROUP SUM(sr2.ogd14t)
           LET l_sum_ogd14t = l_ogd14t_sum,'KGS'
           PRINTX l_sum_ogd14t

           LET l_ogd16t_sum =GROUP SUM(sr2.ogd16t)
           LET l_sum_ogd16t = l_ogd16t_sum,'CBM'
           PRINTX l_sum_ogd16t

           LET l_ogd13_ogd10 = l_sum_ogd13,'IN',l_sum_ogd10
           PRINTX l_ogd13_ogd10

           LET l_ogd14_NW = l_sum_ogd14t,'(N.W.)'
           PRINTX l_ogd14_NW

           LET l_ogd15_GW = l_sum_ogd15t,'(G.W.)'
           PRINTX l_ogd15_GW

           
END REPORT
#FUN-CB0074--add--end--
###GENGRE###END

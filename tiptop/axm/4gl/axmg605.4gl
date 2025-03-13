# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axmg605.4gl
# Descriptions...: 借貨出貨單
# Date & Author..: No.FUN-750036 07/05/09 by rainy
# Modify.........: No.MOD-850237 08/05/26 By Smapmin 修改ora檔
# Modify.........: No.MOD-870079 08/07/10 By Smapmin 多倉儲批的資料改用子報表呈現
# Modify.........: No.MOD-880025 08/08/04 By Smapmin 修改資料型態
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930060 09/09/02 By chenmoyan 列印備注
# Modify.........: No.TQC-A50044 10/05/17 By Carrier 加一行cl_del_data(l_table3)
# Modify.........: No.FUN-B50018 11/05/12 By xumm  CR轉GRW 
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No:FUN-C10036 12/01/16 By lujh FUN-B80089追單
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/04 By wangrr GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-680137 SMALLINT
END GLOBALS
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)             # Where condition
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)              # Input more condition(Y/N)
              END RECORD,
          g_m  ARRAY[40] OF LIKE oao_file.oao06,   #No.MOD-610046
          l_outbill   LIKE oga_file.oga01    # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137  VARCHAR(72)
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE l_i,l_cnt        LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oga01     LIKE oga_file.oga01,
          oga03     LIKE oga_file.oga03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE  g_oga01     LIKE oga_file.oga01   #FUN-650020
 
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  l_table3   STRING                 #FUN-930060
DEFINE  l_str      STRING
 
 
###GENGRE###START
TYPE sr1_t RECORD
    oga01 LIKE oga_file.oga01,
    oga02 LIKE oga_file.oga02,
    oga16 LIKE oga_file.oga16,
    oga021 LIKE oga_file.oga021,
    oga15 LIKE oga_file.oga15,
    gem02 LIKE gem_file.gem02,
    oga032 LIKE oga_file.oga032,
    oga033 LIKE oga_file.oga033,
    oga045 LIKE oga_file.oga45,
    oga03 LIKE oga_file.oga03,
    oga04 LIKE oga_file.oga04,
    oga14 LIKE oga_file.oga14,
    gen02 LIKE gen_file.gen02,
    occ02 LIKE occ_file.occ02,
    addr1 LIKE occ_file.occ241,
    addr2 LIKE occ_file.occ241,
    addr3 LIKE occ_file.occ241,
    addr4 LIKE occ_file.occ241,
    addr5 LIKE occ_file.occ241,
    ogb03 LIKE ogb_file.ogb03,
    ogb04 LIKE ogb_file.ogb04,
    donum LIKE type_file.chr20,
    ogb12 LIKE ogb_file.ogb12,
    ogb05 LIKE ogb_file.ogb05,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    note LIKE type_file.chr37,
    str3 LIKE type_file.chr1000,
    ogb11 LIKE ogb_file.ogb11,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD

TYPE sr2_t RECORD
    ogc01 LIKE ogc_file.ogc01,
    ogc03 LIKE ogc_file.ogc03,
    loc LIKE type_file.chr37
END RECORD

TYPE sr3_t RECORD
    oao01 LIKE oao_file.oao01,
    oao03 LIKE oao_file.oao03,
    oao04 LIKE oao_file.oao04,
    oao05 LIKE oao_file.oao05,
    oao06 LIKE oao_file.oao06
END RECORD
###GENGRE###END

MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126  #FUN-C10036   mark
 
   INITIALIZE tm.* TO NULL                # Default condition
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
 
   LET g_sql ="oga01.oga_file.oga01,",
              "oga02.oga_file.oga02,",
              "oga16.oga_file.oga16,",
              "oga021.oga_file.oga021,",
              "oga15.oga_file.oga15,",
              "gem02.gem_file.gem02,",
              "oga032.oga_file.oga032,",
              "oga033.oga_file.oga033,",
              "oga045.oga_file.oga45,",
              "oga03.oga_file.oga03,",
              "oga04.oga_file.oga04,",
              "oga14.oga_file.oga14,",
              "gen02.gen_file.gen02,",
              "occ02.occ_file.occ02,",
              "addr1.occ_file.occ241,",   #MOD-880025
              "addr2.occ_file.occ241,",   #MOD-880025
              "addr3.occ_file.occ241,",   #MOD-880025
              "addr4.occ_file.occ241,",   #MOD-880025
              "addr5.occ_file.occ241,",   #MOD-880025
              "ogb03.ogb_file.ogb03,",
              "ogb04.ogb_file.ogb04,",
              "donum.type_file.chr20,",
              "ogb12.ogb_file.ogb12,",
              "ogb05.ogb_file.ogb05,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "note.type_file.chr37,",
              "str3.type_file.chr1000,",
              "ogb11.ogb_file.ogb11,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('axmg605',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add   #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)  #FUN-B50018  add  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
 
   LET g_sql ="ogc01.ogc_file.ogc01,",
              "ogc03.ogc_file.ogc03,",   #MOD-870079
              #"i1.type_file.num5,",     #MOD-870079
              "loc.type_file.chr37"  
   LET l_table1 = cl_prt_temptable('axmg6051',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add  #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)  #FUN-B50018  add   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
   #LET g_sql ="ogc01.ogc_file.ogc01,",
   #           "i2.type_file.num5,",
   #           "ogc17.ogc_file.ogc17,",
   #           "ogc12.ogc_file.ogc12,",
   #           "ima02t.ima_file.ima02"
   #LET l_table2 = cl_prt_temptable('axmg6052',g_sql) CLIPPED
   #IF l_table2 = -1 THEN EXIT PROGRAM END IF
#No.FUN-930060--Begin
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao04.oao_file.oao04,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06"  
   LET l_table3 = cl_prt_temptable('axmg6053',g_sql) CLIPPED
   IF l_table3 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add  #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)  #FUN-B50018  add  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
#No.FUN-930060 --End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   IF cl_null(tm.wc) THEN
      CALL axmg605_tm(0,0)             # Input print condition
   ELSE
      CALL axmg605()                   # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
END MAIN
 
FUNCTION axmg605_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_oaz23     LIKE oaz_file.oaz23    #No.FUN-5C0075
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmg605_w AT p_row,p_col WITH FORM "axm/42f/axmg605"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oga01,oga02,oga03
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(oga01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga7"  #No.TQC-5B0095
                 LET g_qryparam.arg1 = 'A'   
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga01
                 NEXT FIELD oga01
              WHEN INFIELD(oga03)     #No.FUN-610064
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ3"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga03  
                   NEXT FIELD oga03  
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
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axmg605_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS   
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW axmg605_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01 = 'axmg605'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmg605','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('axmg605',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW axmg605_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL axmg605()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW axmg605_w
 
END FUNCTION
 
FUNCTION axmg605()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   #LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          #l_sql     LIKE type_file.chr1000,   
          l_sql     STRING ,      #NO.FUN-910082    
          sr        RECORD
                       oga01     LIKE oga_file.oga01,
                       oaydesc   LIKE oay_file.oaydesc,
                       oga02     LIKE oga_file.oga02,
                       oga021    LIKE oga_file.oga021,
                       oga011    LIKE oga_file.oga011,
                       oga14     LIKE oga_file.oga14,
                       oga15     LIKE oga_file.oga15,
                       oga16     LIKE oga_file.oga16,
                       oga032    LIKE oga_file.oga032,
                       oga03     LIKE oga_file.oga03,
                       oga033    LIKE oga_file.oga033,   #統一編號
                       oga45     LIKE oga_file.oga45,    #聯絡人
                       occ02     LIKE occ_file.occ02,
                       oga04     LIKE oga_file.oga04,
                       oga044    LIKE oga_file.oga044,
                       ogb03     LIKE ogb_file.ogb03,
                       ogb31     LIKE ogb_file.ogb31,
                       ogb32     LIKE ogb_file.ogb32,
                       ogb04     LIKE ogb_file.ogb04,
                       ogb092    LIKE ogb_file.ogb092,
                       ogb05     LIKE ogb_file.ogb05,
                       ogb12     LIKE ogb_file.ogb12,
                       ogb06     LIKE ogb_file.ogb06,
                       ogb11     LIKE ogb_file.ogb11,
                       ogb17     LIKE ogb_file.ogb17,
                       ogb19     LIKE ogb_file.ogb19,      #No.FUN-5C0075
                       ogb910    LIKE ogb_file.ogb910,     #No.FUN-580004
                       ogb912    LIKE ogb_file.ogb912,     #No.FUN-580004
                       ogb913    LIKE ogb_file.ogb913,     #No.FUN-580004
                       ogb915    LIKE ogb_file.ogb915,     #No.FUN-580004
                       ogb916    LIKE ogb_file.ogb916,     #No.TQC-5B0127
                       ima18     LIKE ima_file.ima18
                    END RECORD
   DEFINE l_msg    STRING    #FUN-650020
   DEFINE l_msg2   STRING    #FUN-650020
   DEFINE lc_gaq03 LIKE gaq_file.gaq03   #FUN-650020
   DEFINE  l_ogb       RECORD LIKE ogb_file.*
   DEFINE         l_addr1,l_addr2,l_addr3,l_addr4,l_addr5 LIKE occ_file.occ241
   DEFINE         l_gen02    LIKE gen_file.gen02
   DEFINE         l_oag02    LIKE oag_file.oag02
   DEFINE         l_gem02    LIKE gem_file.gem02
   DEFINE         l_ogb12    LIKE ogb_file.ogb12
   DEFINE         l_str2     STRING
   DEFINE         l_str3     LIKE type_file.chr1000
   DEFINE         l_ogc      RECORD
                          ogc09     LIKE ogc_file.ogc09,
                          ogc091    LIKE ogc_file.ogc091,
                          ogc16     LIKE ogc_file.ogc16,
                          ogc092    LIKE ogc_file.ogc092
                       END RECORD
   DEFINE         l_loc      LIKE type_file.chr37
   DEFINE         l_weight   LIKE ogb_file.ogb12
   DEFINE         l_donum    LIKE type_file.chr20
   DEFINE         l_ima906    LIKE ima_file.ima906
   DEFINE         l_ima021    LIKE ima_file.ima021  
   DEFINE         l_ima02     LIKE ima_file.ima02
   DEFINE         l_ogb915    STRING
   DEFINE         l_ogb912    STRING
   DEFINE         l_note      LIKE type_file.chr37
   DEFINE         l_oga09     LIKE oga_file.oga09
   DEFINE         l_oaz23     LIKE oaz_file.oaz23
   DEFINE         g_ogc       RECORD
                   ogc12 LIKE ogc_file.ogc12,
                   ogc17 LIKE ogc_file.ogc17
              END RECORD
#No.FUN-930060 --Begin
   DEFINE         l_oao  RECORD LIKE oao_file.*
   DEFINE         l_oga01_t     LIKE oga_file.oga01
#No.FUN-930060 --End
   INITIALIZE l_oga01_t TO NULL          #No.FUN-930060
 
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmg605'  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "# No.FUN-C40020 add 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)  #FUN-B50018  add
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED," values(?,?,?) "
   PREPARE insert1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)  #FUN-B50018  add 
      EXIT PROGRAM
   END IF   
#No.FUN-930060 --Begin
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED," values(?,?,?,?,?) "
   PREPARE insert3 FROM   g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)  #FUN-B50018  add
      EXIT PROGRAM
   END IF
#No.FUN-930060 --End
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED," values(?,?,?,?,?) "
   #PREPARE insert2 FROM g_sql
   #IF STATUS THEN
   #   CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   #END IF  
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
 
   LET l_sql="SELECT oga01,oaydesc,oga02,oga021,oga011,oga14,oga15,oga16, ",
             "       oga032,oga03,oga033,oga45,occ02,oga04,oga044,ogb03,   ",
             "       ogb31,ogb32,ogb04,ogb092,ogb05,ogb12,ogb06,ogb11,ogb17,ogb19,ogb910,ogb912,ogb913,ogb915,ogb916,ima18",        #No.FUN-580004 #TQC-5B0127 add ogb916 AND FUN-5C0075
" FROM oga_file LEFT OUTER JOIN oay_file ON oga_file.oga01 LIKE  ltrim(rtrim(oay_file.oayslip)) || '-%' LEFT OUTER JOIN occ_file ON oga_file.oga04 = occ_file.occ01,ogb_file LEFT OUTER JOIN ima_file ON ogb_file.ogb04 = ima_file.ima01 WHERE oga01 = ogb01 ", 
             "   AND oga09 = 'A' ", 
             "   AND ",tm.wc CLIPPED,
             "   AND ogaconf != 'X' " 
   LET l_sql= l_sql CLIPPED," ORDER BY oga01,ogb03 "
 
   PREPARE axmg605_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) 
      EXIT PROGRAM
   END IF
 
 
   DECLARE axmg605_curs1 CURSOR FOR axmg605_prepare1
#FUN-C50008--add--str
   DECLARE r600_oao CURSOR FOR
      SELECT * FROM oao_file
            WHERE oao01=? AND (oao05='1' OR oao05='2')
#FUN-C50008--add--end
  
   SELECT sma115 INTO g_sma115 FROM sma_file
 
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   #CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)     #No.TQC-A50044
 
   CALL g_show_msg.clear() 
   
   FOREACH axmg605_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF sr.ogb092 IS NULL THEN
         LET sr.ogb092 = ' '
      END IF
      
      SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oga14
      IF STATUS THEN
         LET l_gen02 = ''
      END IF
 
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oga15
      IF STATUS THEN
         LET l_gem02 = ''
      END IF
 
      CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
           RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5  
      IF SQLCA.SQLCODE THEN
         LET l_addr1 = ''
         LET l_addr2 = ''
         LET l_addr3 = ''
         LET l_addr4 = ''    
         LET l_addr5 = ''    
      END IF
         
 
      SELECT ima02,ima021,ima906 
        INTO l_ima02,l_ima021,l_ima906 
        FROM ima_file
       WHERE ima01=sr.ogb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                    CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                    LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                      CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                      LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                   END IF
                  END IF
            WHEN "3"
                IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                    CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                    LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    
            IF sr.ogb05  <> sr.ogb916 THEN   
               CALL cl_remove_zero(sr.ogb12) RETURNING l_ogb12
               LET l_str2 = l_str2 CLIPPED,"(",l_ogb12,sr.ogb05 CLIPPED,")"
            END IF
      END IF
      LET l_donum = sr.ogb31 CLIPPED,'-',sr.ogb32 USING'###'
      LET l_weight = sr.ogb12*sr.ima18
      LET l_note = l_str2 clipped
            CASE sr.ogb17 #多倉儲批出貨否 (Y/N)
               WHEN 'Y'
                  LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
                            " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
               WHEN 'N'
                  LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file",
                            " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
            END CASE
 
         PREPARE g605_p2 FROM l_sql
         DECLARE g605_c2 CURSOR FOR g605_p2
         LET i=1
         FOREACH g605_c2 INTO l_ogc.*
           LET l_loc = "(",l_ogc.ogc09 clipped
           IF l_ogc.ogc091 IS NOT NULL THEN
              LET l_loc = l_loc clipped,"/",l_ogc.ogc091 clipped
           END IF
           IF l_ogc.ogc092 IS NOT NULL THEN
              LET l_loc = l_loc clipped,"/",l_ogc.ogc092 clipped
           END IF
           LET l_loc = l_loc clipped,")"
           IF STATUS THEN EXIT FOREACH END IF
           #IF tm.a ='1' THEN
              #EXECUTE insert1 USING sr.oga01,i,l_loc     #MOD-870079
              EXECUTE insert1 USING sr.oga01,sr.ogb03,l_loc     #MOD-870079
           #ELSE  
           #   EXECUTE insert1 USING sr.ogb04,i,l_loc  
           #END IF
           LET i = i+1
        END FOREACH
        SELECT oaz23 INTO l_oaz23 FROM oaz_file
        #IF l_oaz23 = 'Y'  THEN
        #    LET g_sql = "SELECT ogc12,ogc17 ",
        #                "  FROM ogc_file",
        #                " WHERE ogc01 = '",sr.oga01,"'"
        # PREPARE ogc_prepare FROM g_sql
        # DECLARE ogc_cs CURSOR FOR ogc_prepare
        # LET i = 1
        # FOREACH ogc_cs INTO g_ogc.*
        #    SELECT ima02 INTO l_ima02 FROM ima_file
        #     WHERE ima01 = g_ogc.ogc17 
        #     EXECUTE insert2 USING sr.oga01,i,g_ogc.ogc17,g_ogc.ogc12,l_ima02                
        #    LET i = i+1
        # END FOREACH
        #END IF
       IF cl_null(sr.oga45) THEN LET sr.oga45 = ' ' END IF
       IF cl_null(sr.oga033) THEN LET sr.oga033 = ' ' END IF
       IF cl_null(sr.oga032) THEN LET sr.oga032 = ' ' END IF
       IF cl_null(sr.oga03) THEN LET sr.oga03 = ' ' END IF
 
       EXECUTE insert_prep USING sr.oga01,sr.oga02, sr.oga16, sr.oga021,sr.oga15, 
                                 l_gem02, sr.oga032,sr.oga033,sr.oga45, sr.oga03,
                                 sr.oga04,sr.oga14, l_gen02,  sr.occ02, l_addr1,
                                 l_addr2, l_addr3,  l_addr4,  l_addr5,  sr.ogb03,
                                 sr.ogb04,l_donum,  sr.ogb12, sr.ogb05, l_ima02,
                                 l_ima021,l_note,   l_str3,sr.ogb11,"",  l_img_blob,"N",""  # No.FUN-C40020 add
#No.FUN-930060 --Begin
       IF sr.oga01<>l_oga01_t OR cl_null(l_oga01_t) THEN
          INITIALIZE l_oao TO NULL
       #FUN-C50008--mark--str  
       #   DECLARE r600_oao CURSOR FOR
       #    SELECT * FROM oao_file
       #     WHERE oao01=sr.oga01
       #       AND (oao05='1' OR oao05='2')
       #   FOREACH r600_oao INTO l_oao.*
       #FUN-C50008--mark--end
          FOREACH r600_oao USING sr.oga01 INTO l_oao.*  #FUN-C50008 add 
             EXECUTE insert3 USING l_oao.*
             LET l_oga01_t = sr.oga01
          END FOREACH
       END IF
#No.FUN-930060 --End
   END FOREACH
 
   LET l_str = sr.oaydesc CLIPPED," ",g_x[1]
   
   IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'oga01,oga02,oga03')                                            
      RETURNING tm.wc 
      LET l_str = l_str CLIPPED,";",tm.wc
   END IF
 
###GENGRE###   LET l_str = l_str CLIPPED,";",l_oaz23 CLIPPED,";",l_oga09               
   LET g_msg=NULL
   IF g_oaz.oaz141 = "1" THEN
      CALL s_ccc_logerr() 
      LET g_oga01=sr.oga01 
      CALL s_ccc(sr.oga03,'0','') #Customer Credit Check 客戶信用查核
      IF g605_err_ana(g_showmsg) THEN
         
      END IF
      IF g_errno = 'N' THEN
         CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
      END IF
   END IF
   
   
   #-----MOD-870079---------
   #LET l_sql = " SELECT A.*,B.i1,B.loc ",
   #            "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A,OUTER ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
   #            "  WHERE A.oga01 = B.ogc01"
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED    
###GENGRE###   #-----END MOD-870079-----
###GENGRE####No.FUN-930060 --Begin
###GENGRE###          ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
###GENGRE###          ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
###GENGRE###               " WHERE oao03=0 AND oao05='1' ","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
###GENGRE###               " WHERE oao03!=0 AND oao05='1' ","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
###GENGRE###               " WHERE oao03!=0 AND oao05='2' ","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
###GENGRE###               " WHERE oao03=0 AND oao05='2' "
#No.FUN-930060 --End
###GENGRE###   CALL cl_prt_cs3('axmg605','axmg605',l_sql,l_str)    
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "oga01"                    # No.FUN-C40020 add
    CALL axmg605_grdata()    ###GENGRE###
 
 
   IF g_show_msg.getlength()>0 THEN
      CALL cl_get_feldname("oga01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("oga03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
      CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
      CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
   END IF
 
 
END FUNCTION
 
 
 
FUNCTION g605_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oga03    LIKE oga_file.oga03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5        # No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oga03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=lc_oga03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oga01   = g_oga01
   LET g_show_msg[li_newerrno].oga03   = lc_oga03
   LET g_show_msg[li_newerrno].occ02   = lc_occ02
   LET g_show_msg[li_newerrno].occ18   = lc_occ18
   LET g_show_msg[li_newerrno].ze01    = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03    = ls_showmsg.trim(),ls_tmpstr.trim()
   #kim test
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
#FUN-750036
#MOD-850237

###GENGRE###START
FUNCTION axmg605_grdata()
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
        LET handler = cl_gre_outnam("axmg605")
        IF handler IS NOT NULL THEN
            START REPORT axmg605_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY oga01,ogb03"
          
            DECLARE axmg605_datacur1 CURSOR FROM l_sql
            FOREACH axmg605_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg605_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg605_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg605_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----str-----------------
    DEFINE l_gem021    STRING
    DEFINE l_gen02     STRING
    DEFINE l_occ021    STRING
    DEFINE l_oga0321   STRING  
    DEFINE l_display1  STRING
    DEFINE l_display2  STRING
    DEFINE l_display3  STRING
    DEFINE l_sql       STRING
    DEFINE l_ogb12_sum LIKE ogb_file.ogb12
    DEFINE l_oga09     LIKE oga_file.oga09
    #FUN-B50018----add-----end-----------------
    
    ORDER EXTERNAL BY sr1.oga01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_lang
              
        BEFORE GROUP OF sr1.oga01
 
            LET l_lineno = 0

            #FUN-B50018----add-----str-----------------
            SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01=sr.oga01
            PRINTX l_oga09

            IF NOT cl_null(sr1.ima021) THEN
               LET l_display1 = 'Y'
            ELSE 
               LET l_display1 = 'N'
            END IF
            PRINTX l_display1

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oao01 = '",sr1.oga01 CLIPPED,"'",
                        " AND oao03 = 0 AND oao05='1'"
            START REPORT axmg605_subrep01
            DECLARE axmg605_repcur1 CURSOR FROM l_sql
            FOREACH axmg605_repcur1 INTO sr3.*
                OUTPUT TO REPORT axmg605_subrep01(sr3.*)
            END FOREACH
            FINISH REPORT axmg605_subrep01
            #FUN-B50018----add-----end----------------- 
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B50018----add-----str-----------------
            LET l_gem021 = sr1.oga15,' ',sr1.gem02
            PRINTX  l_gem021

            LET l_gen02 = sr1.oga14,' ',sr1.gen02
            PRINTX  l_gen02

            LET l_occ021 = sr1.occ02,'(',sr1.oga04,')'
            PRINTX  l_occ021

            LET l_oga0321 = sr1.oga032,' ',sr1.oga033,' ',sr1.oga045,'(',sr1.oga03,')'
            PRINTX  l_oga0321

            IF NOT cl_null(sr1.note) THEN
               LET l_display2 = 'Y'
            ELSE 
               LET l_display2 = 'N'
            END IF
            PRINTX l_display2

            IF NOT cl_null(sr1.str3) THEN
               LET l_display3 = 'Y'
            ELSE 
               LET l_display3 = 'N'
            END IF
            PRINTX l_display3 

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oao01 = '",sr1.oga01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ogb03, 
                        " AND oao05='1'"
            START REPORT axmg605_subrep02
            DECLARE axmg605_repcur2 CURSOR FROM l_sql
            FOREACH axmg605_repcur2 INTO sr3.*
                OUTPUT TO REPORT axmg605_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT axmg605_subrep02


            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE ogc01 ='",sr1.oga01 CLIPPED,"'",
                        " AND ogc03 = ",sr1.ogb03
            START REPORT axmg605_subrep05
            DECLARE axmg605_subrep05 CURSOR FROM l_sql   
            FOREACH axmg605_subrep05 INTO sr2.*
                 OUTPUT TO REPORT axmg605_subrep05(sr2.*)
            END FOREACH
            FINISH REPORT axmg605_subrep05 
        
            LET l_sql = "SELECT A.ogc01,A.ogc03,A.loc FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,"A",
                         g_cr_db_str CLIPPED,l_table1 CLIPPED ,"B",
                        " WHERE B.ogb01 = '",sr1.oga01 CLIPPED,"' AND B.ogb03 = ",sr1.ogb03,
                        " AND B.ogc01 = A.oga01 "
 
            START REPORT axmg605_subrep06
            DECLARE axmg605_subrep06 CURSOR FROM l_sql
            FOREACH axmg605_subrep06 INTO sr2.*
                 OUTPUT TO REPORT axmg605_subrep06(sr2.*)
            END FOREACH
            FINISH REPORT axmg605_subrep06                

            #FUN-B50018----add-----end-----------------

            PRINTX sr1.*



        AFTER GROUP OF sr1.oga01

            #FUN-B50018----add-----str----------------- 
            LET l_ogb12_sum = GROUP SUM(sr1.ogb12)
            PRINTX l_ogb12_sum

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oao01 = '",sr1.oga01 CLIPPED,"'",
                        " AND oao03 = 0 AND oao05='2'"
            START REPORT axmg605_subrep04
            DECLARE axmg605_repcur4 CURSOR FROM l_sql
            FOREACH axmg605_repcur4 INTO sr3.*

                OUTPUT TO REPORT axmg605_subrep04(sr3.*)
            END FOREACH
            FINISH REPORT axmg605_subrep04

           
            
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oao01 = '",sr1.oga01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ogb03,
                        " AND oao05='2'"
            START REPORT axmg605_subrep03
            DECLARE axmg605_repcur3 CURSOR FROM l_sql
            FOREACH axmg605_repcur3 INTO sr3.*
                OUTPUT TO REPORT axmg605_subrep03 (sr3.*)
            END FOREACH
            FINISH REPORT axmg605_subrep03
            #FUN-B50018----add-----end-----------------
        ON LAST ROW
END REPORT
#FUN-B50018----add-----str-----------------
REPORT axmg605_subrep01(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axmg605_subrep02(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axmg605_subrep03(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axmg605_subrep04(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axmg605_subrep05(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg605_subrep06(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT
#FUN-B50018----add-----end-----------------
###GENGRE###END

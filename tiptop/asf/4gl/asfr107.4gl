# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr107.4gl
# Descriptions...: 料件未發/缺料狀況表
# Date & Author..: 97/07/23  By  Sophia
# Modify.........: No:9368 04/03/22 By Melody 應不包含已結案之工單
# Modify.........: No.FUN-4A0006 04/10/02 By echo 材料料號,工單單號,部門編號,生產料號要開窗
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.FUN-530120 05/03/16 By Carol 修改報表架構轉XML
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: NO.FUN-530808 05/08/16 By wujie 憑証類報表轉xml
# Modify.........: NO.TQC-5B0023 05/11/07 By kim 將報表單頭的'品名規格'往下移一行
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-750115 07/06/25 By sherry 報表改由Crystal Report輸出
# Modify.........: No.FUN-760085 07/07/18 By sherry 增加controlg功能 
#                                                   無法打印多筆資料
# Modify.........: No.FUN-7B0052 08/05/13 By jamie 1.報表欄位[需求單號]應改為[工單單號] 2.QBE加show "預計開工日"
# Modify.........: No.MOD-940339 09/04/24 By Smapmin 勾選"欠料者應列印"與"未發者應列印"會異常
# Modify.........: No.FUN-940008 09/05/13 By hongmei 發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60027 10/06/10 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A70128 10/08/02 By lixia dateadd相關修改
# Modify.........: No:MOD-AB0182 10/11/18 By sabrina 未發數量不應包含欠料量
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-C80247 12/08/31 By bart temp table的sfa06應改掉，改為未發數量
# Modify.........: No.TQC-D40095 13/07/16 By yangtt 1.程序中加入CALL cl_show_help()函數 2.增加料表批號開窗 3.報表單身加入品名規格顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
#             wc      VARCHAR(600),   #TQC-630166
              wc      STRING,      #TQC-630166
              bdate   LIKE type_file.dat,           #No.FUN-680121 DATE
              edate   LIKE type_file.dat,           #No.FUN-680121 DATE
              c       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              d       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
              END RECORD
 
#DEFINE   g_dash          VARCHAR(400)   #Dash line           #No.FUN-530808
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)           #No.FUN-530808
#DEFINE   g_pageno        SMALLINT   #Report page no           #No.FUN-530808
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)           #No.FUN-530808
#FUN-750115--start                                                              
   DEFINE  g_sql      STRING                                                    
   DEFINE  l_table    STRING                                                    
   DEFINE  l_str      STRING                                                    
#FUN-750115--end             
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 #No.FUN-750115---Begin                                                         
   LET g_sql = "chr1000.type_file.chr1000,",
               "sfa03.sfa_file.sfa03,",
               "ima02.ima_file.ima02,",
               "ima25.ima_file.ima25,",
#              "ima262.ima_file.ima262,",
               "avl_stk.type_file.num15_3,",
               "num10.type_file.num10,",
               "sfb08.sfb_file.sfb08,",
               "sfb09.sfb_file.sfb09,",
               "sfb10.sfb_file.sfb10,",
               "sfb11.bed_file.bed07,",
               "sfb01.sfb_file.sfb01,",
               "sfb05.sfb_file.sfb05,",
               "sfb82.sfb_file.sfb82,",
               "sfb85.sfb_file.sfb85,",
               "dat.type_file.dat,",
               "sfa12.sfa_file.sfa12,",
               "sfa05.sfa_file.sfa05,",
               "sft05.sft_file.sft05,",                #MOD-C80247
               "sfa07.sfa_file.sfa07,",                
               "sfa012.sfa_file.sfa012,",              #FUN-A60027 
               "sfa013.sfa_file.sfa013,",              #FUN-A60027  
               "ima021.ima_file.ima021,",              #No.TQC-D40095   Add
               "ima02_1.ima_file.ima02,",              #No.TQC-D40095   Add
               "ima021_1.ima_file.ima021"              #No.TQC-D40095   Add
                                                                                
   LET l_table = cl_prt_temptable('asfr107',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "      #FUN-A60027 add 2?   #No.TQC-D40095 add 3?                      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
 #No.FUN-750115--END              
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r107_tm(0,0)
      ELSE CALL r107()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r107_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW r107_w AT p_row,p_col WITH FORM "asf/42f/asfr107"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.c    = 'Y'
   LET tm.d    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON sfa03,sfb01,sfb82,sfb05,sfb85,sfb13 #FUN-7B0052 add sfb13
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
 
       #### No.FUN-4A0006
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sfa03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfa03
                NEXT FIELD sfa03
 
              WHEN INFIELD(sfb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb902"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb01
                NEXT FIELD sfb01
 
              WHEN INFIELD(sfb82)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb82
                NEXT FIELD sfb82
 
              WHEN INFIELD(sfb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05
         #No.TQC-D40095 ---add--- str
          WHEN INFIELD(sfb85)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_sfb85_1"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO sfb85
             NEXT FIELD sfb85
         #No.TQC-D40095 ---add--- end
           END CASE
      ### END  No.FUN-4A0006
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      #No.FUN-760085---Begin
       ON ACTION controlg                                
          CALL cl_cmdask()  
      #No.FUN-760085---End 

      #No.TQC-D40095 ---add--- str
       ON ACTION help
          CALL cl_show_help()
      #No.TQC-D40095 ---add--- end
 
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
        EXIT WHILE
     END IF
 
     IF tm.wc = ' 1=1' THEN CONTINUE WHILE END IF
 
     INPUT BY NAME tm.bdate,tm.edate,tm.c,tm.d,tm.more
           WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
            IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN NEXT FIELD c END IF
 
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      #No.FUN-760085---Begin                                                    
         ON ACTION controlg                                                       
            CALL cl_cmdask()                                                      
      #No.FUN-760085---End                                                      
                              
 
         ON ACTION exit
             LET INT_FLAG = 1
             EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---

         #No.TQC-D40095 ---add--- str
         ON ACTION help
             CALL cl_show_help()
         #No.TQC-D40095 ---add--- end
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asfr107'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asfr107','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",
                            " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
            CALL cl_cmdat('asfr107',g_time,l_cmd)
         END IF
         CLOSE WINDOW r107_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r107()
      ERROR ""
   END WHILE
   CLOSE WINDOW r107_w
 
END FUNCTION
 
FUNCTION r107()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,          # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[4] OF LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          s_order   LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          sr        RECORD
                    order    LIKE type_file.chr1000,          #No.FUN-680121 VARCHAR(70)#FUN-5B0105 45->70
                    sfa03    LIKE sfa_file.sfa03,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,       #No.TQC-D40095   Add
                    ima25    LIKE ima_file.ima25,
#                   ima262   LIKE ima_file.ima262,
                    avl_stk  LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
                    sfl07    LIKE type_file.num10,       #No.FUN-680121 INTEGER
                    sqty     LIKE sfb_file.sfb08,        #No.FUN-680121 DEC(12,3)#在製量
                    poqty    LIKE sfb_file.sfb08,        #No.FUN-680121 DEC(12,3)#請購量
                    ppqty    LIKE sfb_file.sfb08,        #No.FUN-680121 DEC(12,3)#採購量
                    tot      LIKE bed_file.bed07,        #No.FUN-680121 DEC(12,3)#預計可用/缺料量
                    sfb01    LIKE sfb_file.sfb01,
                    sfb05    LIKE sfb_file.sfb05,
                    sfb82    LIKE sfb_file.sfb82,
                    sfb85    LIKE sfb_file.sfb85,
                    ndate    LIKE type_file.dat,         #No.FUN-680121 DATE
                    sfb13    LIKE sfb_file.sfb13,         #No.TQC-A70128
                    sfa09    LIKE sfa_file.sfa09,         #No.TQC-A70128
                    sfa12    LIKE sfa_file.sfa12,
                    sfa05    LIKE sfa_file.sfa05,
                    sfa06    LIKE sfa_file.sfa06,        #No.FUN-940008 add
                    sfa08    LIKE sfa_file.sfa08,        #No.FUN-940008 add
                    sfa27    LIKE sfa_file.sfa27,        #No.FUN-940008 add
                    sfa012   LIKE sfa_file.sfa012,       #No.FUN-A60027 add
                    sfa013   LIKE sfa_file.sfa013,       #No.FUN-A60027 add
                    qty      LIKE sfa_file.sfa07,        #No.FUN-680121 DEC(12,3)#未發量
                    sfa07    LIKE sfa_file.sfa07
                    END RECORD
   DEFINE l_short_qty   LIKE sfa_file.sfa07     #FUN-940008 add
   DEFINE l_n1          LIKE type_file.num15_3           ###GP5.2  #NO.FUN-A20044
   DEFINE l_n2          LIKE type_file.num15_3           ###GP5.2  #NO.FUN-A20044
   DEFINE l_n3          LIKE type_file.num15_3           ###GP5.2  #NO.FUN-A20044 
   DEFINE l_ima02       LIKE ima_file.ima02              #No.TQC-D40095   Add
   DEFINE l_ima021      LIKE ima_file.ima021             #No.TQC-D40095   Add

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      
     CALL cl_del_data(l_table)         #No.FUN-750115  
 
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr107'        #No.FUN-530808
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '',",
#                "sfa03,ima02,ima25,ima262,0,0,0,0,0,", #NO.FUN-A20044
                 "sfa03,ima02,ima021,ima25,0,0,0,0,0,0,",      #NO.FUN-A20044   #No.TQC-D40095   Add ima021
                 #"sfb01,sfb05,sfb82,sfb85,dateadd(dd,sfa09,sfb13),",     #TQC-A70128
                 "sfb01,sfb05,sfb82,sfb85,'',sfb13,sfa09,",               #TQC-A70128
              #  "sfa12,sfa05,sfa05-sfa06-sfa07,sfa07",  #FUN-940008 mark
                 "sfa12,sfa05,sfa06,sfa08,sfa27,sfa012,sfa013,'',''",           #FUN-940008 add   #FUN-A60027 	add sfa012,sfa013
              #  "sfa12,sfa05,sfa05-sfa06,sfa07",
                 " FROM sfb_file,sfa_file ",
                 "   LEFT OUTER JOIN ima_file ON sfa03=ima01",
                 " WHERE ", tm.wc CLIPPED,
                 #"   AND sfb01 = sfa01 AND sfb87!='X' AND sfb04 <> '8'", #No:9368 #TQC-A70128 mark
                 "   AND sfb01 = sfa01 AND sfb87!='X' AND sfb04 <> '8'"  #No:9368  #TQC-A70128 
                 #"   AND dateadd(dd,sfa09,sfb13) BETWEEN '",tm.bdate,"'",         #TQC-A70128 mark
                 #"   AND '",tm.edate,"'"                                          #TQC-A70128 mark
 
     PREPARE r107_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r107_curs1 CURSOR FOR r107_prepare1
#    CALL cl_outnam('asfr107') RETURNING l_name           #No.FUN-750115
#No.FUN-550067-begin
#No.FUN-530808--begin
#    LET g_len = 88
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-530808--end
#No.FUN-550067-end
#    START REPORT r107_rep TO l_name                      #No.FUN-750115
#    LET g_pageno = 0                                     #No.FUN-750115     
     FOREACH r107_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #TQC-A70128--add--str--
          IF cl_null(sr.sfa09) THEN
             LET sr.sfa09 = 0
          END IF
          LET sr.ndate =  sr.sfb13 + sr.sfa09
             IF sr.ndate < tm.bdate OR sr.ndate > tm.edate THEN
                CONTINUE FOREACH
             END IF           
          #TQC-A70128--add--end--
          CALL s_getstock(sr.sfa03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
          LET sr.avl_stk = l_n3
          #FUN-940008---Begin add
          CALL s_shortqty(sr.sfb01,sr.sfa03,sr.sfa08,sr.sfa12,sr.sfa27,sr.sfa012,sr.sfa013)    #FUN-A60027 add sfa012,sfa013
               RETURNING l_short_qty
          IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
         #LET sr.qty = sr.sfa05-sr.sfa06-l_short_qty      #MOD-AB0182 mark
          LET sr.qty = sr.sfa05-sr.sfa06                  #MOD-AB0182 add
          LET sr.sfa07 = l_short_qty
          #FUN-940008---End
          #----IQC 在驗量-------
           SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO sr.sfl07
             FROM rvb_file, rva_file, pmn_file
            WHERE rvb05 = sr.sfa03 AND rvb01=rva01 AND rvaconf <> 'X'
              AND rvb04 = pmn01 AND rvb03 = pmn02
              AND rvb07 > (rvb29+rvb30)
          IF sr.sfl07 IS NULL THEN LET sr.sfl07 = 0 END IF
          #SELECT SUM(sfl07) INTO sr.sfl07 FROM sfl_file
          # WHERE sfl01 = sr.sfb01
          #   AND sfl07 > 0
         #-----在製量----
          SELECT SUM(sfb08-sfb09-sfb11) INTO sr.sqty
            FROM sfb_file
           WHERE sfb05 = sr.sfa03
             AND sfb04 < '8'   #工單狀況
             AND sfb02 <> '7'               #工單狀態
             AND sfb08 > (sfb09+sfb11) AND sfb87!='X'
          IF sr.sqty IS NULL THEN LET sr.sqty = 0 END IF
         #----請購量----
          SELECT SUM((pml20-pml21)*pml09) INTO sr.poqty
            FROM pml_file,pmk_file
           WHERE pml04 = sr.sfa03  #料件編號
             AND pml01 = pmk01 AND pmk18 != 'X'
             AND pml16 <= '2'       #已核准
             AND pml20 > pml21
             AND pml011 != 'SUB'   #單據性質不為廠商加工請購
          IF sr.poqty IS NULL THEN LET sr.poqty = 0 END IF
         #----採購量----
          SELECT SUM((pmn20-pmn50)*pmn09) INTO sr.ppqty
            FROM pmn_file,pmm_file
           WHERE pmn04 = sr.sfa03
             AND pmn01 = pmm01 AND pmm18 != 'X'
             AND pmn16 <= '2'
             AND pmn20 > pmn50
             AND pmn011 <> 'SUB'
          IF sr.ppqty IS NULL THEN LET sr.ppqty = 0 END IF
#         IF sr.ima262 IS NULL THEN LET sr.ima262 = 0 END IF    #NO.FUN-A20044
          IF sr.avl_stk IS NULL THEN LET sr.avl_stk = 0 END IF  #NO.FUN-A20044
 
#         LET sr.tot = sr.ima262 + sr.sfl07 + sr.sqty + sr.poqty + sr.ppqty   #NO.FUN-A20044
          LET sr.tot = sr.avl_stk + sr.sfl07 + sr.sqty + sr.poqty + sr.ppqty  #NO.FUN-A20044
  
          #-----MOD-940339---------
          #IF tm.c = 'N' THEN   #未發者不列印
          #   IF sr.qty = 0 THEN CONTINUE FOREACH END IF
          #END IF
          #IF tm.d = 'N' THEN   #欠料者不列印
          #   IF sr.sfa07 > 0 THEN CONTINUE FOREACH END IF
          #END IF
          CASE
             WHEN tm.c = 'Y' AND tm.d = 'N'
                  IF sr.qty <=0 THEN CONTINUE FOREACH END IF
             WHEN tm.c = 'N' AND tm.d = 'Y'
                  IF sr.sfa07 <= 0 THEN CONTINUE FOREACH END IF
             WHEN tm.c = 'N' AND tm.d = 'N'
                  CONTINUE FOREACH
          END CASE
          #-----END MOD-940339-----
          LET sr.order = sr.sfb01,sr.sfb05,sr.ndate,sr.sfa12
#No.FUN-750115---Begin
#         OUTPUT TO REPORT r107_rep(sr.*)
#         EXECUTE insert_prep USING s_order,sr.sfa03,sr.ima02,sr.ima25,      #No.FUN-760085
         #No.TQC-D40095 ---add--- str
          SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = sr.sfb05
         #No.TQC-D40095 ---add--- end
          EXECUTE insert_prep USING sr.order,sr.sfa03,sr.ima02,sr.ima25,     #No.FUN-760085
#                                   sr.ima262,sr.sfl07,sr.sqty,sr.poqty,     #NO.FUN-A20044
                                    sr.avl_stk,sr.sfl07,sr.sqty,sr.poqty,    #NO.FUN-A20044
                                    sr.ppqty,sr.tot,sr.sfb01,
                                    sr.sfb05,'','',sr.ndate,
                                    sr.sfa12,sr.sfa05,sr.qty,sr.sfa07,sr.sfa012,sr.sfa013   #No.FUN-A60027 add sfa012,sfa013   
                                   ,sr.ima021,l_ima02,l_ima021   #No.TQC-D40095 add
#No.FUN-750115---End
     END FOREACH
 
#No.FUN-750115---Begin
#    FINISH REPORT r107_rep
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
 
     IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'sfa03,sfb01,sfb82,sfb05,sfb85,sfb13')    #FUN-7B0052 add sfb13                 
        RETURNING tm.wc                                                         
        LET l_str = l_str CLIPPED,";",tm.wc                                     
     END IF         
     LET l_str = tm.wc 
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    CALL cl_prt_cs3('asfr107','asfr107',l_sql,l_str)   #FUN-A60027
     #No.FUN-A60027 ------------------start----------------
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('asfr107','asfr107_1',l_sql,l_str)
     ELSE
        CALL cl_prt_cs3('asfr107','asfr107',l_sql,l_str)
     END IF 
     #No.FUN-A60027 ----------------end--------------------   

#No.FUN-750115---End
END FUNCTION
 
#No.FUN-750115---Begin
#{REPORT r107_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#          sr        RECORD
#                    order    LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(70) #FUN-5B0105 45->70
#                    sfa03    LIKE sfa_file.sfa03,
#                    ima02    LIKE ima_file.ima02,
#                    ima25    LIKE ima_file.ima25,
#                    ima262   LIKE ima_file.ima262,
#                    sfl07    LIKE type_file.num10,       #No.FUN-680121 INTEGER
#                    sqty     LIKE sfb_file.sfb08,        #No.FUN-680121 DEC(12,3)#在製量
#                    poqty    LIKE sfb_file.sfb08,        #No.FUN-680121 DEC(12,3)#請購量
#                    ppqty    LIKE sfb_file.sfb08,        #No.FUN-680121 DEC(12,3)#採購量
#                    tot      LIKE sfb_file.sfb08,        #No.FUN-680121 DEC(12,3)#預計可用/缺料量
#                    sfb01    LIKE sfb_file.sfb01,
#                    sfb05    LIKE sfb_file.sfb05,
#                    sfb82    LIKE sfb_file.sfb82,
#                    sfb85    LIKE sfb_file.sfb85,
#                    ndate    LIKE type_file.dat,         #No.FUN-680121 DATE
#                    sfa12    LIKE sfa_file.sfa12,
#                    sfa05    LIKE sfa_file.sfa05,
#                    qty      LIKE sfa_file.sfa07,        #No.FUN-680121 DEC(12,3)#未發量
#                    sfa07    LIKE sfa_file.sfa07
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.sfa03,sr.order
#  FORMAT
#   PAGE HEADER
##No.FUN-530808--begin
##      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##      IF cl_null(g_towhom)
##         THEN PRINT '';
##         ELSE PRINT 'TO:',g_towhom;
##      END IF
##      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##      PRINT ' '
##      LET g_pageno = g_pageno + 1
##      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
##No.FUN-530808--end
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.sfa03
#    # SKIP TO TOP OF PAGE
##No.FUN-550067-begin
#      PRINT g_x[11] CLIPPED,sr.sfa03 CLIPPED,
#           #COLUMN 31,g_x[12] CLIPPED,sr.ima02 CLIPPED,
#            COLUMN 71,g_x[13] CLIPPED,sr.ima25 CLIPPED
#      PRINT g_x[12] CLIPPED,sr.ima02 CLIPPED
#      PRINT
#      PRINT g_x[14] CLIPPED,
#            COLUMN 13,g_x[15] CLIPPED,
#            COLUMN 24,g_x[16] CLIPPED,
#            COLUMN 36,g_x[17] CLIPPED,
#            COLUMN 48,g_x[18] CLIPPED;
#      IF sr.tot >= 0 THEN
#         PRINT COLUMN 61,g_x[19] CLIPPED
#      ELSE
#         PRINT COLUMN 61,g_x[20] CLIPPED
#      END IF
#      PRINT ''
#      PRINT sr.ima262          USING '---------&',
#            COLUMN 14,sr.sfl07 USING '---------&',
#            COLUMN 25,sr.sqty  USING '---------&',
#            COLUMN 37,sr.poqty USING '---------&',
#            COLUMN 49,sr.ppqty USING '---------&',
#            COLUMN 61,sr.tot   USING '---------&'
#      PRINT ''
##No.FUN-530808--begin
#      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#      PRINT g_dash1
#
#   AFTER GROUP OF sr.order
#     PRINTX name = D1
#            COLUMN g_c[31],sr.sfb01 CLIPPED,
#            COLUMN g_c[32],sr.sfb05 CLIPPED,
#            COLUMN g_c[33],sr.ndate,
#            COLUMN g_c[34],sr.sfa12 CLIPPED,
#            COLUMN g_c[35],GROUP SUM(sr.sfa05) USING '--------------&',
#            COLUMN g_c[36],GROUP SUM(sr.qty)   USING '--------------&',
#            COLUMN g_c[37],GROUP SUM(sr.sfa07) USING '--------------&'
#
#   AFTER GROUP OF sr.sfa03
#      PRINTX name = S1
#            COLUMN g_c[34] CLIPPED,#g_x[21] CLIPPED,
#            COLUMN g_c[35],GROUP SUM(sr.sfa05) USING '--------------&',
#            COLUMN g_c[36],GROUP SUM(sr.qty)   USING '--------------&',
#            COLUMN g_c[37],GROUP SUM(sr.sfa07) USING '--------------&'
#      PRINT g_dash2[1,g_len]
##No.FUN-530808--end
##No.FUN-550067-end
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
#              RETURNING tm.wc
#         PRINT g_dash2[1,g_len]
##TQC-630166-start
#         CALL cl_prt_pos_wc(tm.wc) 
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##TQC-630166-end
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN   PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT}
#No.FUN-750115---End
#Patch....NO.TQC-610037 <> #

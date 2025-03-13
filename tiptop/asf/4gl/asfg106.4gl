# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: asfg106.4gl
# Descriptions...: 工單備料未發/缺料狀況表
# Date & Author..: 97/07/23  By  Sophia
# Modify.........: NO.FUN-4A0006 04/10/02 By echo 材料料號,工單單號,部門編號,生產料號要開窗
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.MOD-5A0358 05/10/25 By Claire 調整報表小計顯示中文
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.FUN-760046 07/06/20 By hellen 報表轉換成CR
# Modify.........: No.MOD-7C0013 07/12/05 By Pengu 勾選"欠料者應列印"與"未發者應列印"會異常
# Modify.........: No.FUN-940008 09/05/12 By hongmei 發料改善
# Modify.........: No.MOD-960297 09/06/25 By lilingyu 一.去掉結案的資料 二.未發數量 = sfa05(應發)-sfa06(已發)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/09 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A70128 10/08/02 By lixia dateadd相關修改
# Modify.........: No.FUN-D30025 13/03/15 By yangtt CR轉GRW    
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
#             wc      VARCHAR(600),   #TQC-630166
              wc      STRING,      #TQC-630166
              s       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              t       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              u       LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)
              bdate   LIKE type_file.dat,           #No.FUN-680121 DATE
              edate   LIKE type_file.dat,           #No.FUN-680121 DATE
              c       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              d       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
              END RECORD,
         g_ordera  ARRAY[5] OF LIKE type_file.chr1000   #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
DEFINE   g_i          LIKE type_file.num5           #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   l_table      STRING                        #No.FUN-760046   
DEFINE   g_str        STRING                        #No.FUN-760046   
DEFINE   g_sql        STRING                        #No.FUN-760046   
DEFINE   g_sql1       STRING                        #No.FUN-D30025   
DEFINE   g_sql2       STRING                        #No.FUN-D30025   
DEFINE   g_sql3       STRING                        #No.FUN-D30025   
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE sfa_file.sfa03,      #FUN-D30025
    order2 LIKE sfa_file.sfa03,      #FUN-D30025
    order3 LIKE sfa_file.sfa03,      #FUN-D30025
    order4 LIKE type_file.chr1000,
    sfa03 LIKE sfa_file.sfa03,
    sfb01 LIKE sfb_file.sfb01,
    sfb05 LIKE sfb_file.sfb05,
    sfb82 LIKE sfb_file.sfb82,
    sfb85 LIKE sfb_file.sfb85,
    ndate LIKE type_file.dat,
    sfa12 LIKE sfa_file.sfa12,
    sfa05 LIKE sfa_file.sfa05,
    sfa012 LIKE sfa_file.sfa012,
    sfa013 LIKE sfa_file.sfa013,
    qty LIKE sfa_file.sfa07,
    sfa07 LIKE sfa_file.sfa07,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021
END RECORD
###GENGRE###END

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
 
# No.FUN-760046--begin
   LET g_sql = 
               "order1.sfa_file.sfa03,",      #FUN-D30025
               "order2.sfa_file.sfa03,",      #FUN-D30025
               "order3.sfa_file.sfa03,",      #FUN-D30025
               "order4.type_file.chr1000,",
               "sfa03.sfa_file.sfa03,",
               "sfb01.sfb_file.sfb01,",
               "sfb05.sfb_file.sfb05,",
               "sfb82.sfb_file.sfb82,",
               "sfb85.sfb_file.sfb85,",
               "ndate.type_file.dat,",
               "sfa12.sfa_file.sfa12,",
               "sfa05.sfa_file.sfa05,",
               "sfa012.sfa_file.sfa012,",    #FUN-A60027
               "sfa013.sfa_file.sfa013,",    #FUN-A60027
               "qty.sfa_file.sfa07,",
               "sfa07.sfa_file.sfa07,",
#              "sfb13.sfb_file.sfb13,",
#              "sfa09.sfa_file.sfa09,",
#              "sfa06.sfa_file.sfa06,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021"         
   LET l_table = cl_prt_temptable('asfg106',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#              " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?, ?, ?, ?, ?, ?)"                #FUN-A60027 add 2?   #FUN-D30025 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) 
      EXIT PROGRAM                                                                            
   END IF   
# No.FUN-760046--end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.bdate  = ARG_VAL(11)
   LET tm.edate  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   LET tm.d  = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g106_tm(0,0)
      ELSE CALL g106()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION g106_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 4 LET p_col =20
 
   OPEN WINDOW g106_w AT p_row,p_col
        WITH FORM "asf/42f/asfg106"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.c    = 'Y'
   LET tm.d    = 'Y'
   LET tm.s    = '12 '
   LET tm.u    = 'Y  '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfa03,sfb01,sfb82,sfb05,sfb85
 
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
                LET g_qryparam.form = "q_sfb9"
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
           END CASE
      ### END  No.FUN-4A0006
 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION CONTROLG CALL cl_cmdask()   #add by hellen No.FUN-760046
 
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
 
     IF tm.wc =' 1=1' THEN CONTINUE WHILE END IF
 
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                     tm2.t1,tm2.t2,tm2.t3,
                     tm2.u1,tm2.u2,tm2.u3,
                     tm.bdate,tm.edate,tm.c,tm.d,
                     tm.more WITHOUT DEFAULTS
 
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
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        AFTER INPUT
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
           LET tm.t = tm2.t1,tm2.t2,tm2.t3
           LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
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
        EXIT WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file
               WHERE zz01='asfg106'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfg106','9031',1)
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
                           " '",tm.s CLIPPED,"'",
                           " '",tm.t CLIPPED,"'",
                           " '",tm.u CLIPPED,"'",
                           " '",tm.bdate CLIPPED,"'",
                           " '",tm.edate CLIPPED,"'",
                           " '",tm.c CLIPPED,"'",
                           " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
           CALL cl_cmdat('asfg106',g_time,l_cmd)
        END IF
        CLOSE WINDOW g106_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
 
     CALL cl_wait()
     CALL g106()
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW g106_w
END FUNCTION
 
FUNCTION g106()
   DEFINE l_name    LIKE type_file.chr20,                #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8              #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,              # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                              # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,                 #No.FUN-680121 SMALLINT
          l_order   ARRAY[4] OF LIKE sfa_file.sfa03,     #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          sr        RECORD
                    order1   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order2   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order3   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                    order4   LIKE type_file.chr1000,     #No.FUN-680121 VARCHAR(70)#FUN-5B0105 45->70
                    sfa03    LIKE sfa_file.sfa03,
                    sfb01    LIKE sfb_file.sfb01,
                    sfb05    LIKE sfb_file.sfb05,
                    sfb82    LIKE sfb_file.sfb82,
                    sfb85    LIKE sfb_file.sfb85,
                    ndate    LIKE type_file.dat,           #No.FUN-680121 DATE#需要日期 
                    sfb13    LIKE sfb_file.sfb13,         #No.TQC-A70128
                    sfa09    LIKE sfa_file.sfa09,         #No.TQC-A70128
                    sfa12    LIKE sfa_file.sfa12,
                    sfa05    LIKE sfa_file.sfa05,
                    sfa06    LIKE sfa_file.sfa06,          #No.FUN-940008 add
                    sfa08    LIKE sfa_file.sfa08,          #No.FUN-940008 add
                    sfa27    LIKE sfa_file.sfa27,          #No.FUN-940008 add
                    sfa012   LIKE sfa_file.sfa012,         #No.FUN-A60027 add
                    sfa013   LIKE sfa_file.sfa013,         #No.FUN-A60027 add    
                    qty      LIKE sfa_file.sfa07,          #No.FUN-680121 DEC(12,3)#未發
                    sfa07    LIKE sfa_file.sfa07   #欠料
                    END RECORD
   DEFINE l_short_qty   LIKE sfa_file.sfa07        #FUN-940008 add
   DEFINE l_sfa05       LIKE sfa_file.sfa05        #FUN-940008 add
   
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
# No.FUN-760046--begin                                                                                                            
     CALL cl_del_data(l_table)                                                                                                        
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                         
# No.FUN-760046--end 
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
 
     LET l_sql = "SELECT '','','','',",
                 #"sfa03,sfb01,sfb05,sfb82,sfb85,dateadd(dd,sfa09,sfb13),",  #TQC-A70128 mark
                 "sfa03,sfb01,sfb05,sfb82,sfb85,'',sfb13,sfa09,",               #TQC-A70128
             #   "sfa12,sfa05,sfa05-sfa06-sfa07,sfa07",    #FUN-940008 mark
                 "sfa12,sfa05,sfa06,sfa08,sfa27,sfa012,sfa013,'',''",    #FUN-940008 add   #FUN-A60027 add sfa012,sfa013
                 " FROM sfb_file,sfa_file",
                 " WHERE ", tm.wc CLIPPED,
                 "   AND sfb01 = sfa01 AND sfb87!='X' ",
                 #"   AND sfb04 != '8' ",                       #MOD-960297  #TQC-A70128 mark
                 "   AND sfb04 != '8' "                         #MOD-960297  #TQC-A70128
                 #"   AND dateadd(dd,sfa09,sfb13) BETWEEN '",tm.bdate,"'",   #TQC-A70128 mark
                 #"   AND '",tm.edate,"'"                                    #TQC-A70128 mark
 
     PREPARE g106_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE g106_curs1 CURSOR FOR g106_prepare1
 
# No.FUN-760046 --begin-- mark 
#    CALL cl_outnam('asfg106') RETURNING l_name
#    START REPORT g106_rep TO l_name
# No.FUN-760046 --end-- mark
 
     CALL g_ordera.clear()
 
     FOREACH g106_curs1 INTO sr.*
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
          #FUN-940008---Begin add
          CALL s_shortqty(sr.sfb01,sr.sfa03,sr.sfa08,sr.sfa12,sr.sfa27,sr.sfa012,sr.sfa013)       #FUN-A60027 add sfa012,sfa013
               RETURNING l_short_qty
          IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF 
#         LET sr.qty= sr.sfa05-sr.sfa06-l_short_qty        #MOD-960297
          LET sr.qty= sr.sfa05-sr.sfa06                    #MOD-960297
          LET sr.sfa07 = l_short_qty
          #FUN-940008---End
          IF sr.qty <=0 AND sr.sfa07 <= 0 THEN CONTINUE FOREACH END IF
         #------------------No.MOD-7C0013 modify
         #IF tm.c = 'N' THEN   #未發者不列印
         #   IF sr.qty <=0 THEN CONTINUE FOREACH END IF
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
         #------------------No.MOD-7C0013 end
# No.FUN-760046 --begin         
#         FOR g_i = 1 TO 3
#             CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.sfa03
#               #                           LET g_ordera[g_i]= g_x[10] #FUN-5A0358
#                                           LET g_ordera[g_i]= g_x[13] #FUN-5A0358
#                  WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.sfb01
#               #                           LET g_ordera[g_i]= g_x[11] #FUN-5A0358
#                                           LET g_ordera[g_i]= g_x[10] #FUN-5A0358
#                  WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.sfb82
#               #                           LET g_ordera[g_i]= g_x[12] #FUN-5A0358
#                                           LET g_ordera[g_i]= g_x[11] #FUN-5A0358
#                  WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.sfb05
#               #                           LET g_ordera[g_i]= g_x[13] #FUN-5A0358
#                                           LET g_ordera[g_i]= g_x[12] #FUN-5A0358
#               #  WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.sfb85#FUN-5A0358
#               #                           LET g_ordera[g_i]= g_x[14] #FUN-5A0358
#                  OTHERWISE LET l_order[g_i]  = '-'
#                            LET g_ordera[g_i] = ' '          #清為空白
#             END CASE
#         END FOR
#         LET sr.order1 = l_order[1]
#         LET sr.order2 = l_order[2]
#         LET sr.order3 = l_order[3]
          LET sr.order4 = sr.sfb01,sr.sfa03,sr.ndate,sr.sfa12
          
#         OUTPUT TO REPORT g106_rep(sr.*)                          #mark
 
          SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file  #add
           WHERE ima01 = sr.sfa03                                  #add

          #FUN-D30025----add----str----
          FOR g_i = 1 TO 3
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.sfa03
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.sfb01
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.sfb82
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.sfb05
                   OTHERWISE LET l_order[g_i]  = '-'
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          #FUN-D30025----add----end----
                     
          EXECUTE insert_prep USING
                  sr.order1,sr.order2,sr.order3,    #FUN-D30025
                  sr.order4,sr.sfa03,sr.sfb01,sr.sfb05,sr.sfb82,sr.sfb85,sr.ndate,
                  sr.sfa12,sr.sfa05,sr.sfa012,sr.sfa013,sr.qty,sr.sfa07,l_ima02,l_ima021  #FUN-A60027 add sfa012,sfa013
     END FOREACH
 
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(tm.wc,'sfa03,sfb01,sfb82,sfb05,sfb85')
             RETURNING tm.wc                                                                                                         
        LET g_str = tm.wc                                                                                                            
     END IF
###GENGRE###     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
    #CALL cl_prt_cs3('asfg106','asfg106',l_sql,g_str)     #FUN-A60027
    #FUN-A60027 -----------------start-------------------
    IF g_sma.sma541 = 'Y' THEN
###GENGRE###      CALL cl_prt_cs3('asfg106','asfg106_1',l_sql,g_str)
       LET g_template = 'asfg106_1'  #FUN-D30025
    CALL asfg106_grdata()    ###GENGRE###
    ELSE
###GENGRE###      CALL cl_prt_cs3('asfg106','asfg106',l_sql,g_str)
       LET g_template = 'asfg106'  #FUN-D30025
    CALL asfg106_grdata()    ###GENGRE###
    END IF 
    #FUN-A60027 ----------------end---------------------- 
 
#    FINISH REPORT g106_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
# No.FUN-760046 --end
END FUNCTION
 
# No.FUN-760046 --begin-- mark
#{
#REPORT g106_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#          l_str        LIKE sfa_file.sfa03,          #No.FUN-680121 VARCHAR(40)
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          sr        RECORD
#                    order1   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    order2   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    order3   LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                    order4   LIKE type_file.chr1000,     #No.FUN-680121 VARCHAR(40)#FUN-5B0105 45->70
#                    sfa03    LIKE sfa_file.sfa03,
#                    sfb01    LIKE sfb_file.sfb01,
#                    sfb05    LIKE sfb_file.sfb05,
#                    sfb82    LIKE sfb_file.sfb82,
#                    sfb85    LIKE sfb_file.sfb85,
#                    ndate    LIKE type_file.dat,           #No.FUN-680121 DATE
#                    sfa12    LIKE sfa_file.sfa12,
#                    sfa05    LIKE sfa_file.sfa05,
#                    qty      LIKE sfa_file.sfa07,          #No.FUN-680121 DEC(12,3)
#                    sfa07    LIKE sfa_file.sfa07
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4
#  FORMAT
#   PAGE HEADER
#
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT ''
#
#      PRINT g_dash
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         # LET l_str = g_ordera[1] CLIPPED,g_x[16] CLIPPED #FUN-5A0358
#         LET l_str = g_ordera[1] CLIPPED,g_x[14] CLIPPED #FUN-5A0358
#         PRINT COLUMN g_c[35],l_str CLIPPED,
#               COLUMN g_c[37],GROUP SUM(sr.sfa05) USING '--------------&',
#               COLUMN g_c[38],GROUP SUM(sr.qty)   USING '--------------&',
#               COLUMN g_c[39],GROUP SUM(sr.sfa07) USING '--------------&'
#      END IF
#      PRINT ''
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         # LET l_str = g_ordera[2] CLIPPED,g_x[16] CLIPPED #FUN-5A0358
#         LET l_str = g_ordera[2] CLIPPED,g_x[14] CLIPPED #FUN-5A0358
#         PRINT COLUMN g_c[35],l_str CLIPPED,
#               COLUMN g_c[37],GROUP SUM(sr.sfa05) USING '--------------&',
#               COLUMN g_c[38],GROUP SUM(sr.qty)   USING '--------------&',
#               COLUMN g_c[39],GROUP SUM(sr.sfa07) USING '--------------&'
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         # LET l_str = g_ordera[3] CLIPPED,g_x[16] CLIPPED #FUN-5A0358
#         LET l_str = g_ordera[3] CLIPPED,g_x[14] CLIPPED #FUN-5A0358
#         PRINT COLUMN g_c[35],l_str CLIPPED,
#               COLUMN g_c[37],GROUP SUM(sr.sfa05) USING '--------------&',
#               COLUMN g_c[38],GROUP SUM(sr.qty)   USING '--------------&',
#               COLUMN g_c[39],GROUP SUM(sr.sfa07) USING '--------------&'
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order4
#      LET l_ima02 = ''
#      LET l_ima021= ''
#      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
#       WHERE ima01 = sr.sfa03
#      PRINT COLUMN g_c[31],sr.sfb01,
#            COLUMN g_c[32],sr.sfa03,
#            COLUMN g_c[33],l_ima02 CLIPPED,
#            COLUMN g_c[34],l_ima021 CLIPPED,
#            COLUMN g_c[35],sr.ndate,
#            COLUMN g_c[36],sr.sfa12,
#            COLUMN g_c[37],GROUP SUM(sr.sfa05) USING '--------------&',
#            COLUMN g_c[38],GROUP SUM(sr.qty)   USING '--------------&',
#            COLUMN g_c[39],GROUP SUM(sr.sfa07) USING '--------------&'
# 
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'sfa03,sfb01,sfb82,sfb05,sfb85')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
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
#      PRINT g_dash
#      LET l_last_sw = 'y'
##     PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[7] CLIPPED     #No.TQC-710016
#      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-710016
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
##             PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[6] CLIPPED     #No.TQC-710016
#              PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-710016
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#}
## No.FUN-760046 --end-- mark
 


###GENGRE###START
FUNCTION asfg106_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    #FUN-D30025--add--str--
    LET g_sql1 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=?"
    DECLARE asfg106_repcur01 CURSOR FROM g_sql1
    LET g_sql2 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=? AND order2=?"
    DECLARE asfg106_repcur02 CURSOR FROM g_sql2
    LET g_sql3 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1=? AND order2=? AND order3=?"
    DECLARE asfg106_repcur03 CURSOR FROM g_sql3
    #FUN-D30025--add--end--

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("asfg106")
        IF handler IS NOT NULL THEN
            START REPORT asfg106_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(order1),order2,order3,order4"   #FUN-D30025
          
            DECLARE asfg106_datacur1 CURSOR FROM l_sql
            FOREACH asfg106_datacur1 INTO sr1.*
                OUTPUT TO REPORT asfg106_rep(sr1.*)
            END FOREACH
            FINISH REPORT asfg106_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asfg106_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-D30025---add---str---
    DEFINE l_order1   STRING
    DEFINE l_order2   STRING
    DEFINE l_order3   STRING
    DEFINE l_sfa05_sum_1 LIKE sfa_file.sfa05
    DEFINE l_sfa05_sum_2 LIKE sfa_file.sfa05
    DEFINE l_sfa05_sum_3 LIKE sfa_file.sfa05
    DEFINE l_sfa05_sum_4 LIKE sfa_file.sfa05
    DEFINE l_qty_sum_1   LIKE sfa_file.sfa07
    DEFINE l_qty_sum_2   LIKE sfa_file.sfa07
    DEFINE l_qty_sum_3   LIKE sfa_file.sfa07
    DEFINE l_qty_sum_4   LIKE sfa_file.sfa07
    DEFINE l_sfa07_sum_1 LIKE sfa_file.sfa07
    DEFINE l_sfa07_sum_2 LIKE sfa_file.sfa07
    DEFINE l_sfa07_sum_3 LIKE sfa_file.sfa07
    DEFINE l_sfa07_sum_4 LIKE sfa_file.sfa07
    DEFINE l_display1    LIKE type_file.chr1
    DEFINE l_display2    LIKE type_file.chr1
    DEFINE l_display3    LIKE type_file.chr1
    DEFINE l_skip1       LIKE type_file.chr1
    DEFINE l_skip2       LIKE type_file.chr1
    DEFINE l_skip3       LIKE type_file.chr1
    DEFINE l_skip_ord1   LIKE type_file.chr1
    DEFINE l_skip_ord2   LIKE type_file.chr1
    DEFINE l_skip_ord3   LIKE type_file.chr1
    DEFINE l_cnt1        LIKE type_file.num10
    DEFINE l_cnt2        LIKE type_file.num10
    DEFINE l_cnt3        LIKE type_file.num10
    DEFINE l_ord1_cnt    LIKE type_file.num10
    DEFINE l_ord2_cnt    LIKE type_file.num10
    DEFINE l_ord3_cnt    LIKE type_file.num10
    DEFINE l_cnt         LIKE type_file.num10  
    DEFINE l_cnt_tot     LIKE type_file.num10 
    DEFINE l_sql         STRING              
    #FUN-D30025---add---end---

    
   #ORDER EXTERNAL BY sr1.order4   #FUN-D30023 add
    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3,sr1.order4   #FUN-D30023 add
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
            #FUN-D30025---add---str---
            LET l_display1 = tm.u[1,1]
            LET l_display2 = tm.u[2,2]
            LET l_display3 = tm.u[3,3]
            LET l_skip1 = tm.t[1]
            LET l_skip2 = tm.t[2]
            LET l_skip3 = tm.t[3]
            PRINTX l_display1,l_display2,l_display3
            PRINTX l_skip1,l_skip2,l_skip3

            LET l_cnt_tot = 0
            LET l_cnt = 0
            LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3"
            DECLARE asfg106_cur CURSOR FROM l_sql
            FOREACH asfg106_cur INTO l_cnt END FOREACH
            #FUN-D30025---add---end---
              
        BEFORE GROUP OF sr1.order1
            #FUN-D30025---add---str---
            FOREACH asfg106_repcur01 USING sr1.order1 INTO l_cnt1 END FOREACH
            LET l_ord1_cnt = 0
            #FUN-D30025---add---end---
        BEFORE GROUP OF sr1.order2
            #FUN-D30025---add---str---
            FOREACH asfg106_repcur02 USING sr1.order1,sr1.order2 INTO l_cnt2 END FOREACH
            LET l_ord2_cnt = 0
            #FUN-D30025---add---end---
        BEFORE GROUP OF sr1.order3
            #FUN-D30025---add---str---
            FOREACH asfg106_repcur03 USING sr1.order1,sr1.order2,sr1.order3 INTO l_cnt3 END FOREACH
            LET l_ord3_cnt = 0
            #FUN-D30025---add---end---
        BEFORE GROUP OF sr1.order4

        
        ON EVERY ROW
            LET l_ord1_cnt = l_ord1_cnt + 1
            LET l_ord2_cnt = l_ord2_cnt + 1
            LET l_ord3_cnt = l_ord3_cnt + 1
            LET l_cnt_tot = l_cnt_tot + 1
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.order1    #FUN-D30025
            #FUN-D30025---add---str---
            LET l_skip_ord1 = 'N'
            IF l_cnt = l_cnt_tot THEN LET l_skip_ord1 = 'Y' END IF
            PRINTX l_skip_ord1

            LET l_order1 = cl_gr_getmsg('gre-343',g_lang,tm.s[1])
            LET l_sfa05_sum_1 = GROUP SUM(sr1.sfa05)
            LET l_qty_sum_1 = GROUP SUM(sr1.qty)
            LET l_sfa07_sum_1 = GROUP SUM(sr1.sfa07)
            PRINTX l_order1
            PRINTX l_sfa05_sum_1,l_qty_sum_1,l_sfa07_sum_1
            #FUN-D30025---add---end---
        AFTER GROUP OF sr1.order2    #FUN-D30025
            #FUN-D30025---add---str---
            IF l_ord1_cnt = l_cnt1 THEN
               LET l_skip_ord2 = 'Y'
            ELSE
               LET l_skip_ord2 = 'N'
            END IF
            PRINTX l_skip_ord2

            LET l_order2 = cl_gr_getmsg('gre-343',g_lang,tm.s[2])
            LET l_sfa05_sum_2 = GROUP SUM(sr1.sfa05)
            LET l_qty_sum_2 = GROUP SUM(sr1.qty)
            LET l_sfa07_sum_2 = GROUP SUM(sr1.sfa07)
            PRINTX l_order2
            PRINTX l_sfa05_sum_2,l_qty_sum_2,l_sfa07_sum_2
            #FUN-D30025---add---end---
        AFTER GROUP OF sr1.order3    #FUN-D30025
            #FUN-D30025---add---str---
            IF l_ord2_cnt = l_cnt2 OR l_ord1_cnt = l_cnt1 THEN
               LET l_skip_ord3 = 'Y'
            ELSE
               LET l_skip_ord3 = 'N'
            END IF
            PRINTX l_skip_ord3
            LET l_order3 = cl_gr_getmsg('gre-343',g_lang,tm.s[3])
            LET l_sfa05_sum_3 = GROUP SUM(sr1.sfa05)
            LET l_qty_sum_3 = GROUP SUM(sr1.qty)
            LET l_sfa07_sum_3 = GROUP SUM(sr1.sfa07)
            PRINTX l_order3
            PRINTX l_sfa05_sum_3,l_qty_sum_3,l_sfa07_sum_3
            #FUN-D30025---add---end---
        AFTER GROUP OF sr1.order4
            #FUN-D30025---add---str---
            LET l_sfa05_sum_4 = GROUP SUM(sr1.sfa05)
            LET l_qty_sum_4 = GROUP SUM(sr1.qty)
            LET l_sfa07_sum_4 = GROUP SUM(sr1.sfa07)
            PRINTX l_sfa05_sum_4,l_qty_sum_4,l_sfa07_sum_4
            #FUN-D30025---add---end---

        
        ON LAST ROW

END REPORT
###GENGRE###END

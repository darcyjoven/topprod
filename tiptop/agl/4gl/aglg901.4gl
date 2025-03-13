# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg901.4gl
# Desc/riptions..: 傳票過帳前檢查作業
# Date & Author..: 92/03/16 BY MAY
# Modify.........: 96/10/01 By Danny (增加傳票單號缺號檢查)
# Modify.........: 97/07/30 By Melody 增加'輸入人員'INPUT,空白表全部
# Modify.........: No.MOD-4A0102 04/10/07 By Nicola 傳票單身的異常檢查與確認碼這個選項互不相干
# Modify.........: No.FUN-510007 05/01/14 By Nicola 報表架構修改
# Modify.........: No.MOD-560137 05/07/07 By Nicola (A18)印出來的最後一行印一個I無義意
# Modify.........: No.MOD-580061 05/08/11 By Smapmin 新增檢查"單身幣別不可為空白或NULL
# Modify.........: No.MOD-5A0320 05/10/24 By Smapmin 勾選"傳票單號缺號檢查"有誤
# Modify.........: NO.TQC-5B0112 05/11/12 BY Nicola 結束位置修改
# Modify.........: NO.FUN-5C0015 06/01/03 By miki   加abb31~abb37的檢查
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/11 BY cheunl 報表格式修改
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/12 By bnlent 會計科目加帳套
# Modify.........: No.MOD-750084 07/05/17 By Smapmin 修改錯誤訊息顯示方式
# Modify.........: No.FUN-750093 07/06/01 By zhoufeng 報表輸出至CR
# Modify.........: No.MOD-840605 08/04/25 By sherry 修改報表
# Modify.........: No.MOD-850226 08/05/26 By Sarah 若傳票編號無效時,不需再show"本張單據未確認"訊息
# Modify.........: No.MOD-890052 08/09/04 By Sarah 增加abaacti='Y'條件,過濾掉無效資料
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980200 09/08/22 BY sabrina 做缺號檢查時，作廢的單子不可以挑出來 
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu  精簡程式碼 
# Modify.........: No:MOD-A40125 10/04/21 BY sabrina 在預算控制項目,判斷的欄位應是abb36不是abb15
# Modify.........: No:TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-950053 10/08/17 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.MOD-B10157 11/01/20 By wujie  aac06不再使用了
# Modify.........: No.FUN-B80161 11/09/05 By chenying 明細CR報表轉GR
# Modify.........: No.FUN-B80161 12/01/05 By qirl MOD-B90013追單
# Modify.........: NO.FUN-CB0058 12/11/26 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD
               wc      LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(200)
               bookno  LIKE aaa_file.aaa01,    #No.FUN-740020
               y1      LIKE type_file.num5,    #No.FUN-680098  smallint
               m2      LIKE type_file.num5,    #No.FUN-680098  smallint
               bdate   LIKE type_file.dat,     #No.FUN-680098  date
               edate   LIKE type_file.dat,     #No.FUN-680098  date
               b       LIKE type_file.chr1,    # print gkf_file detail(Y/N) #No.FUN-680098  VARCHAR(1)
               z       LIKE type_file.chr1,    #No.FUN-680098    VARCHAR(1)
               pers    LIKE aba_file.abauser,  #No.FUN-680098    VARCHAR(8)
               more    LIKE type_file.chr1    # Input more condition(Y/N)  #No.FUN-680098   VARCHAR(1)
           END RECORD,
       g_xx             LIKE type_file.chr1,    #No.FUN-680098   VARCHAR(1)
       g_chk            LIKE type_file.chr1,    #No.FUN-680098  VARCHAR(1)
       g_aaa            RECORD LIKE aaa_file.*,
       l_bdate,l_edate  LIKE type_file.dat     #No.FUN-680098  date
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose      #No.FUN-680098  smallint
DEFINE  g_str           STRING                 #No.FUN-750093
DEFINE  g_sql           STRING                 #No.FUN-750093
DEFINE  l_table         STRING                 #No.FUN-750093
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A70007 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A70007 add
DEFINE g_flag        LIKE type_file.chr1       #CHI-A70007 add
DEFINE g_pmc903      LIKE pmc_file.pmc903      #FUN-950053 add 
DEFINE g_occ37       LIKE occ_file.occ37       #FUN-950053 add  
 
###GENGRE###START
TYPE sr1_t RECORD
    aba02 LIKE aba_file.aba02,
    aba01 LIKE aba_file.aba01,
    aba06 LIKE aba_file.aba06,
    aba08 LIKE aba_file.aba08,
    aba09 LIKE aba_file.aba09,
    num5 LIKE type_file.num5,
    aba10 LIKE aba_file.aba10,
    abb04 LIKE abb_file.abb04,
    azi04 LIKE azi_file.azi04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_sql="aba02.aba_file.aba02,aba01.aba_file.aba01,aba06.aba_file.aba06,",
             "aba08.aba_file.aba08,aba09.aba_file.aba09,num5.type_file.num5,",
             "aba10.aba_file.aba10,abb04.abb_file.abb04,azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('aglg901',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,  #TQC-A40133 mark
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, #TQC-A40133 mod
               " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
 
   LET tm.bookno  = ARG_VAL(1)  #帳別        #No.FUN-740020
   LET g_pdate  = ARG_VAL(2)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.y1    = ARG_VAL(8)
   LET tm.m2    = ARG_VAL(9)
   LET tm.bdate = ARG_VAL(10)
   LET tm.edate = ARG_VAL(11)
   LET tm.pers = ARG_VAL(12)   #TQC-610056
   LET tm.b     = ARG_VAL(13)
   LET g_xx = ARG_VAL(14)   #TQC-610056
   LET tm.z = ARG_VAL(15)   #TQC-610056
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
 
    IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF
 
   SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.bookno    #No.FUN-740020
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g901_tm(0,0)
   ELSE
      CALL aglg901()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)   #FUN-B80161 add
END MAIN
 
FUNCTION g901_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680098 smallint
          l_flag        LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_cmd         LIKE type_file.chr1000        #No.FUN-680098  VARCHAR(400)
 
 
 
   CALL s_dsmark(tm.bookno)    #No.FUN-740020
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW g901_w AT p_row,p_col
     WITH FORM "agl/42f/aglg901"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(3,2,tm.bookno)   #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.y1   = g_aaa.aaa04
   LET tm.m2   = g_aaa.aaa05
   #CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,tm.bdate,tm.edate #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF cl_null(tm.bookno) THEN
      CALL s_get_bookno(tm.y1) RETURNING g_flag,g_bookno1,g_bookno2
   END IF
   IF g_aza.aza63 = 'Y' THEN
      IF NOT cl_null(tm.bookno) THEN
         CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,tm.bdate,tm.edate
      ELSE
         CALL s_azmm(tm.y1,tm.m2,g_plant,g_bookno1) RETURNING l_flag,tm.bdate,tm.edate
      END IF
   ELSE
      CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,tm.bdate,tm.edate
   END IF
   #CHI-A70007 add --end--
   LET tm.b    = 'Y'
   LET g_xx    = 'N'
   LET tm.z    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bookno = g_aza.aza81   #No.FUN-740020
 
   WHILE TRUE
 
      DISPLAY g_aaa.aaa04 TO FORMONLY.aaa04
      DISPLAY g_aaa.aaa05 TO FORMONLY.aaa05
      DISPLAY BY NAME tm.bookno,tm.y1,tm.m2,tm.bdate,tm.edate,tm.b,tm.pers,tm.more   #No.FUN-740020
 
      INPUT BY NAME tm.bookno,tm.y1,tm.m2,tm.bdate,tm.edate,   #MOD-5A0320    #No.FUN-740020
                    tm.pers,tm.b,g_xx,tm.z,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
         AFTER FIELD bookno
           IF cl_null(tm.bookno) THEN
              NEXT FIELD bookno
           END IF
 
 
         AFTER FIELD m2
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
            #若期別不為空,則年度必不為空
            IF (tm.m2 IS NOT NULL AND tm.m2 != ' ') AND
               (tm.y1 IS NULL OR tm.y1 = ' ' ) THEN
               CALL cl_err('','agl-037',0)
               NEXT FIELD y1
            END IF
 
            IF (tm.y1 IS NOT NULL AND tm.y1 != ' ') AND
               (tm.m2 IS NULL OR tm.m2 = ' ') THEN
               CALL cl_err('','agl-040',0)
               NEXT FIELD y1
            END IF
 
            IF tm.y1 IS NOT NULL AND tm.y1 != ' ' AND
               tm.m2 IS NOT NULL AND tm.m2 != ' ' THEN
               #CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
               #CHI-A70007 add --start--
               IF g_aza.aza63 = 'Y' THEN
                  CALL s_azmm(tm.y1,tm.m2,g_plant,tm.bookno) RETURNING l_flag,l_bdate,l_edate
               ELSE
                  CALL s_azm(tm.y1,tm.m2) RETURNING l_flag,l_bdate,l_edate
               END IF
               #CHI-A70007 add --end--
               IF l_flag = '1' THEN      #若此資料不存在會計期間參數中
                  CALL cl_err('','agl-038',0)
                  LET tm.bdate = ' '
                  LET tm.edate = ' '
                  DISPLAY BY NAME tm.bdate,tm.edate
                  NEXT FIELD y1
               ELSE
                  LET tm.bdate = l_bdate
                  LET tm.edate = l_edate
                  DISPLAY BY NAME tm.bdate,tm.edate
               END IF
            END IF
 
         AFTER FIELD bdate
            IF tm.y1 IS NOT NULL AND tm.y1 != ' ' AND
               tm.m2 IS NOT NULL AND tm.m2 != ' '  THEN
               IF tm.bdate < l_bdate OR tm.bdate >l_edate  THEN
                  CALL cl_err('','agl-041',0)  #若年度期別都有輸入則
                  NEXT FIELD bdate             #輸入起始截止必需在此區間中
               END IF
            END IF
 
         AFTER FIELD edate
            IF (tm.y1 = ' ' OR tm.y1 IS NULL) AND  #若會計年度,期別都無輸入
               (tm.m2 = ' ' OR tm.m2 IS NULL) AND  #則起始截止日期必需有ㄧ存在
               (tm.bdate IS NULL OR tm.bdate = ' ' ) THEN
               IF tm.edate IS NULL OR tm.edate = ' ' THEN
                  CALL cl_err('','agl-039',0)
                  NEXT FIELD bdate
               END IF
            END IF
 
            IF (tm.y1 IS NOT NULL AND tm.y1 != ' ') AND #若併無輸入年度期別則不用
               (tm.m2 IS NOT NULL AND tm.m2 != ' ') THEN#CHECK起始截止日期
               IF tm.edate < l_bdate OR  tm.edate > l_edate THEN
                  CALL cl_err('','agl-041',0)
                  NEXT FIELD edate
               END IF
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD bdate
               END IF
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b) THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD g_xx
            IF cl_null(g_xx) OR g_xx NOT MATCHES '[YN]' THEN
               NEXT FIELD g_xx
            END IF
 
         AFTER FIELD z
            IF cl_null(tm.z) OR tm.z NOT MATCHES "[YN]" THEN
               NEXT FIELD z
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
 
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLP
          CASE
            WHEN INFIELD(bookno)                                                                                                       
              CALL cl_init_qry_var()                                                                                                 
              LET g_qryparam.form = 'q_aaa'                                                                                          
              LET g_qryparam.default1 = tm.bookno                                                                                     
              CALL cl_create_qry() RETURNING tm.bookno                                                                                
              DISPLAY BY NAME tm.bookno                                                                                               
              NEXT FIELD bookno 
          END CASE
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g901_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)   #FUN-B80161 add
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg901'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg901','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.bookno  CLIPPED,"'",    #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.y1    CLIPPED,"'",
                        " '",tm.m2    CLIPPED,"'",
                        " '",tm.bdate CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.pers CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",g_xx CLIPPED,"'",
                        " '",tm.z CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg901',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW g901_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)   #FUN-B80161 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg901()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g901_w
 
END FUNCTION
 
FUNCTION aglg901()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
          l_sql,l_sql1  LIKE type_file.chr1000,              # RDSQL STATEMENT                 #No.FUN-680098  VARCHAR(1000)
          l_chr         LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_cmd         LIKE type_file.chr50,         #No.FUN-680098   VARCHAR(30)
          l_aba         RECORD LIKE aba_file.*,
          l_abb         RECORD LIKE abb_file.*,
          l_aag         RECORD LIKE aag_file.*,
          l_cnt         LIKE type_file.num5,    #No.FUN-680098  smallint
          l_cnt_1       LIKE type_file.num5,    #No.FUN-680098  smallint
          l_cnt_2       LIKE type_file.num5,    #No.FUN-680098  smallint
          l_abb07_1     LIKE abb_file.abb07,
          l_abb07_2     LIKE abb_file.abb07,
          l_str         LIKE type_file.chr1000, #No.FUN-680098   VARCHAR(36)
          errno         LIKE abb_file.abb04,    #No.FUN-680098   VARCHAR(30)
          l_aag01       LIKE aag_file.aag01,
          l_aag08       LIKE aag_file.aag08,
          l_no_g        LIKE aba_file.aba01,   #MOD-5A0320   #No.FUN-680098   VARCHAR(12)
          l_no_g_old    LIKE aba_file.aba01,   #MOD-5A0320   #No.FUN-680098   VARCHAR(12)
          l_bno         LIKE type_file.num5,                 #No.FUN-680098  smallint
          l_aba01       LIKE aba_file.aba01,
          l_aba01_old   LIKE aba_file.aba01,
          l_no          LIKE aba_file.aba01,     #MOD-5A0320      #No.FUN-680098   VARCHAR(16)
          l_i,l_j       LIKE type_file.num5,     #No.FUN-680098   smallint
          l_format      LIKE type_file.chr20,    #MOD-5A0320      #No.FUN-680098   VARCHAR(10)
          i             LIKE type_file.num5,     #MOD-5A0320      #No.FUN-680098   smallint
          l_no2         LIKE aba_file.aba01,     #MOD-5A0320      #No.FUN-680098   VARCHAR(16)
          g_x1,g_x2     LIKE type_file.num5,     #MOD-5A0320      #No.FUN-680098  smallint
          l_aac06       LIKE aac_file.aac06,     #MOD-5A0320
          l_aba01_2     LIKE aba_file.aba01      #MOD-5A0320
DEFINE    l_abaacti     LIKE aba_file.abaacti    #MOD-980200 add
DEFINE    l_pmc903      LIKE pmc_file.pmc903     #FUN-950053 add 
 
   CALL cl_del_data(l_table)                     #No.FUN-750093
 
   SELECT aaf03 INTO g_company FROM aaf_file
        WHERE aaf01 = tm.bookno    #No.FUN-740020
        AND aaf02 = g_lang
 
   SELECT azi04 INTO t_azi04 FROM azi_file               #No.CHI-6A0004 g_azi-->t_azi
       WHERE azi01 = g_aaa.aaa03
 
   LET l_sql = "SELECT aba_file.* FROM aba_file ",
               " WHERE aba00 = '",tm.bookno,"'",   #No.FUN-740020
               "   AND aba06 != 'CE'",
               "   AND abaacti='Y'",   #MOD-890052 add
               "   AND aba19 <> 'X' "  #CHI-C80041
 
   IF NOT cl_null(tm.pers) THEN
      LET l_sql = l_sql CLIPPED," AND abauser = '",tm.pers,"'"
   END IF
 
   #-->若有輸入年度期別
   IF NOT cl_null(tm.y1) THEN
      LET l_sql = l_sql CLIPPED," AND aba03 = '",tm.y1,"' ",
                                " AND aba04 = '",tm.m2,"'"
   END IF
 
   IF NOT cl_null(tm.bdate) THEN
      LET l_sql = l_sql CLIPPED," AND aba02 >= '",tm.bdate,"'"
   END IF
 
   IF NOT cl_null(tm.edate) THEN
      LET l_sql =  l_sql CLIPPED," AND aba02 <= '",tm.edate,"'"
   END IF
 
   LET l_sql = l_sql CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
 
 
   LET l_sql = l_sql CLIPPED," ORDER BY aba01 "
 
   DISPLAY "l_sql:",l_sql
 
   PREPARE g901_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B80161 add
      EXIT PROGRAM
   END IF
   DECLARE g901_cs1 CURSOR FOR g901_prepare1
 
   #-->CURSOR 準備
   LET l_sql1 = " SELECT abb_file.*  FROM abb_file ",
                "  WHERE abb00 = '",tm.bookno,"' AND abb01 = ? ",   #No.FUN-740020
                "  ORDER BY abb01,abb02 "
 
   PREPARE g901_prepare2 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B80161 add
      EXIT PROGRAM
   END IF
   DECLARE g901_cs2 CURSOR FOR g901_prepare2
 
   #--->科目檢查
   LET l_sql1 = " SELECT aag01,aag08 FROM aag_file ",
                "  WHERE aag07 = '3' ",
                "    AND aag00 = '",tm.bookno,"' ",   #No.FUN-740020
                "    AND (aag08 IS NULL OR aag08 = ' ' ) "
 
   PREPARE g901_prepare3 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare3:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)   #FUN-B80161 add
      EXIT PROGRAM
   END IF
   DECLARE g901_cs3 CURSOR FOR g901_prepare3
 
 
   #-->若無error則不需詢問列印方式
   LET l_cnt    = 0
   LET l_no_g_old = ' '   #MOD-5A0320
 
   FOREACH g901_cs1 INTO l_aba.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
         LET l_aba01_2 = l_aba.aba01[1,g_doc_len]
#No.MOD-B10157 --begin
#        SELECT aac06 INTO l_aac06 FROM aac_file
#               WHERE aac01=l_aba01_2
      LET l_aac06 = g_aza.aza104
#No.MOD-B10157 --end
 
      DISPLAY "1.aba01,aba02:",l_aba.aba01,"  ",l_aba.aba02
 
      #-->1.單頭借貸不等
      IF cl_null(l_aba.aba08) THEN
         LET l_aba.aba08 = 0
      END IF
 
      IF cl_null(l_aba.aba09) THEN
         LET l_aba.aba09 = 0
      END IF
 
      IF l_aba.aba08 != l_aba.aba09 THEN
         LET errno = '1'
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04
    
         LET l_cnt = l_cnt + 1
      END IF
 
      SELECT SUM(abb07),COUNT(*) INTO l_abb07_1,l_cnt_1
        FROM abb_file,aag_file
       WHERE abb00 = tm.bookno AND abb01 = l_aba.aba01    #No.FUN-740020
         AND aag00 = abb00     #No.FUN-740020
         AND abb03 = aag01 AND aag09='Y'
         AND abb06 = '1'  #單身借方總和
 
      SELECT SUM(abb07),COUNT(*) INTO l_abb07_2,l_cnt_2
        FROM abb_file,aag_file
       WHERE abb00 = tm.bookno AND abb01 = l_aba.aba01    #No.FUN-740020
         AND aag00 = abb00     #No.FUN-740020
         AND abb03 = aag01 AND aag09='Y'
         AND abb06 = '2'  #單身貸方總和
 
      IF cl_null(l_abb07_1) THEN
         LET l_abb07_1 = 0
      END IF
 
      IF cl_null(l_abb07_2) THEN
         LET l_abb07_2 = 0
      END IF
 
      #-->2.有單頭無單身
      IF (l_cnt_1 + l_cnt_2) = 0 THEN
         LET errno = '2'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
 
         LET l_cnt = l_cnt + 1
      END IF
 
      #-->3.單頭借貸不等於單身借貸總和
      IF l_abb07_1 != l_aba.aba08 OR l_abb07_2 != l_aba.aba09 THEN
         LET errno = '3'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
         LET l_cnt = l_cnt + 1
      END IF
 
      #-->4.單頭借貸為零
      IF l_aba.aba08 = 0 OR l_aba.aba09 = 0 THEN
         LET errno = '4'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
         LET l_cnt = l_cnt + 1
      END IF
 
      #-->5.單身借貸總和為零
      IF l_abb07_1 = 0 OR l_abb07_2 = 0 THEN
         LET errno = '5'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
         LET l_cnt = l_cnt + 1
      END IF
 
      #-->C.應列印未列印
      IF g_aaz.aaz80 = 'N' AND l_aba.abaprno = 0 THEN
         LET errno = 'C'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
         LET l_cnt = l_cnt + 1
      END IF
 
      #-->D.流水號空白
      IF cl_null(l_aba.aba01[g_no_sp,g_no_ep]) THEN   #MOD-5A0320
         LET errno = 'D'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
         LET l_cnt = l_cnt + 1
      END IF
 
      #-->E.傳票無效
      IF l_aba.abaacti != 'Y' THEN
         LET errno = 'E'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
         LET l_cnt = l_cnt + 1
      END IF
 
      #-->G.流水號不為數值
      LET g_chk = 'Y'
       LET g_x1 = 0
       LET g_x2 = g_no_ep
       CASE
           WHEN l_aac06='1'
                LET g_x1 = g_no_sp
           WHEN l_aac06='2'
                LET g_x1 = g_no_sp+4
           WHEN l_aac06='3'
                LET g_x1 = g_no_sp+4
           WHEN l_aac06='4'
                LET g_x1 = g_no_sp+6
       END CASE
       LET l_aba01 = l_aba.aba01[g_x1,g_x2]
       LET l_i = g_x2 - g_x1 + 1
 
 
      IF NOT cl_numchk(l_aba01,l_i) THEN
         LET errno = 'G'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04          
         LET l_cnt = l_cnt + 1
         LET g_chk = 'N'      #若流水號不為數值時,不做缺號檢查
      END IF
 
      #-->H.傳票單號缺號檢查
      IF g_xx = 'Y' AND g_chk = 'Y' THEN
         CASE
             WHEN l_aac06='1'
                  LET l_no_g = l_aba.aba01[1,g_doc_len+1]
             WHEN l_aac06='2'
                  LET l_no_g = l_aba.aba01[1,g_no_sp+3]
             WHEN l_aac06='3'
                  LET l_no_g = l_aba.aba01[1,g_no_sp+3]
             WHEN l_aac06='4'
                  LET l_no_g = l_aba.aba01[1,g_no_sp+5]
         END CASE
 
       # Prog. Version..: '5.30.06-13.03.12(01/09/03 bug no:3467)--------------#
          IF l_no_g != l_no_g_old THEN
             CASE
                 WHEN l_aac06='1'
                      LET l_no_g_old = l_aba.aba01[1,g_doc_len+1]
                      LET l_no = l_aba.aba01[1,g_doc_len+1]
                      LET l_no2 = ''
                      FOR i = g_no_sp TO g_no_ep
                          LET l_no2 = l_no2 CLIPPED,"0"
                      END FOR
                      LET l_no[g_no_sp,g_no_ep] = l_no2
                 WHEN l_aac06='2'
                      LET l_no_g_old = l_aba.aba01[1,g_no_sp+3]
                      LET l_no = l_aba.aba01[1,g_no_sp+3]
                      LET l_no2 = ''
                      FOR i = g_no_sp+4 TO g_no_ep
                          LET l_no2 = l_no2 CLIPPED,"0"
                      END FOR
                      LET l_no[g_no_sp+4,g_no_ep] = l_no2
                 WHEN l_aac06='3'
                      LET l_no_g_old = l_aba.aba01[1,g_no_sp+3]
                      LET l_no = l_aba.aba01[1,g_no_sp+3]
                      LET l_no2 = ''
                      FOR i = g_no_sp+4 TO g_no_ep
                          LET l_no2 = l_no2 CLIPPED,"0"
                      END FOR
                      LET l_no[g_no_sp+4,g_no_ep] = l_no2
                 WHEN l_aac06='4'
                      LET l_no_g_old = l_aba.aba01[1,g_no_sp+5]
                      LET l_no = l_aba.aba01[1,g_no_sp+5]
                      LET l_no2 = ''
                      FOR i = g_no_sp+6 TO g_no_ep
                          LET l_no2 = l_no2 CLIPPED,"0"
                      END FOR
                      LET l_no[g_no_sp+6,g_no_ep] = l_no2
             END CASE
          END IF
 
          IF l_no_g = l_no_g_old THEN
             CASE
                 WHEN l_aac06='1'
                      LET l_format = ''
                      FOR i = g_no_sp TO g_no_ep
                          LET l_format = l_format CLIPPED,"&"
                      END FOR
                      LET l_bno = l_no[g_no_sp,g_no_ep] + 1 USING l_format
                      LET l_no = l_no [1,g_doc_len+1],l_bno USING l_format
                 WHEN l_aac06='2'
                      LET l_format = ''
                      FOR i = g_no_sp+4 TO g_no_ep
                          LET l_format = l_format CLIPPED,"&"
                      END FOR
                      LET l_bno = l_no[g_no_sp+4,g_no_ep] + 1 USING l_format
                      LET l_no = l_no[1,g_no_sp+3],l_bno USING l_format
                 WHEN l_aac06='3'
                      LET l_format = ''
                      FOR i = g_no_sp+4 TO g_no_ep
                          LET l_format = l_format CLIPPED,"&"
                      END FOR
                      LET l_bno = l_no[g_no_sp+4,g_no_ep] + 1 USING l_format
                      LET l_no = l_no[1,g_no_sp+3],l_bno USING l_format
                 WHEN l_aac06='4'
                      LET l_format = ''
                      FOR i = g_no_sp+6 TO g_no_ep
                          LET l_format = l_format CLIPPED,"&"
                      END FOR
                      LET l_bno = l_no[g_no_sp+6,g_no_ep] + 1 USING l_format
                      LET l_no = l_no[1,g_no_sp+5],l_bno USING l_format
             END CASE
             IF l_aba.aba01 != l_no THEN
               LET l_j = 0
               LET l_aba01_old = l_aba.aba01
               WHILE TRUE
                  LET l_j = l_j + 1
                  IF l_j > 1 THEN
                     CASE
                         WHEN l_aac06='1'
                              LET l_format = ''
                              FOR i = g_no_sp TO g_no_ep
                                  LET l_format = l_format CLIPPED,"&"
                              END FOR
                              LET l_bno = l_no[g_no_sp,g_no_ep] + 1 USING l_format
                              LET l_no = l_no[1,g_doc_len+1],l_bno USING l_format
                         WHEN l_aac06='2'
                              LET l_format = ''
                              FOR i = g_no_sp+4 TO g_no_ep
                                  LET l_format = l_format CLIPPED,"&"
                              END FOR
                              LET l_bno = l_no[g_no_sp+4,g_no_ep] + 1 USING l_format
                              LET l_no = l_no[1,g_no_sp+3],l_bno USING l_format
                         WHEN l_aac06='3'
                              LET l_format = ''
                              FOR i = g_no_sp+4 TO g_no_ep
                                  LET l_format = l_format CLIPPED,"&"
                              END FOR
                              LET l_bno = l_no[g_no_sp+4,g_no_ep] + 1 USING l_format
                              LET l_no = l_no[1,g_no_sp+3],l_bno USING l_format
                         WHEN l_aac06='4'
###GENGRE###                              LET l_format = ''
                              FOR i = g_no_sp+6 TO g_no_ep
                                  LET l_format = l_format CLIPPED,"&"
                              END FOR
                              LET l_bno = l_no[g_no_sp+6,g_no_ep] + 1 USING l_format
                              LET l_no = l_no[1,g_no_sp+5],l_bno USING l_format
                     END CASE
                     IF l_no = l_aba01_old THEN
                        EXIT WHILE
                     END IF
                  END IF
 
                  INITIALIZE l_aba.* TO NULL
                  LET l_aba.aba01 = l_no
 
         SELECT abaacti INTO l_abaacti FROM aba_file
          WHERE aba01 = l_aba.aba01
            AND aba19 <> 'X'  #CHI-C80041
         IF l_abaacti != 'Y' THEN
            CONTINUE WHILE      
         END IF
         LET errno = 'H'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04    
 
                  LET l_cnt = l_cnt + 1
               END WHILE
            END IF
         END IF
 
          IF l_no_g != l_no_g_old THEN
             CASE
                 WHEN l_aac06='1'
                      LET l_no_g_old = l_aba.aba01[1,g_doc_len+1]
                      LET l_no = l_aba.aba01
                 WHEN l_aac06='2'
                      LET l_no_g_old = l_aba.aba01[1,g_no_sp+3]
                      LET l_no = l_aba.aba01
                 WHEN l_aac06='3'
                      LET l_no_g_old = l_aba.aba01[1,g_no_sp+3]
                      LET l_no = l_aba.aba01
                 WHEN l_aac06='4'
                      LET l_no_g_old = l_aba.aba01[1,g_no_sp+5]
                      LET l_no = l_aba.aba01
             END CASE
          END IF
      END IF
      #-->檢查確認否 no:3467
      IF tm.z = 'Y' THEN
         IF l_aba.aba19 = 'N' AND l_aba.abaacti = 'Y' THEN   #MOD-850226
         LET errno = 'Y'                                                        
         EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                   l_aba.aba08,l_aba.aba09,'','',errno,t_azi04    
         END IF
      END IF
 
      #-->若要CHECK傳票單身
      IF tm.b  = 'Y' THEN
         FOREACH g901_cs2 USING l_aba.aba01 INTO l_abb.*
 
            DISPLAY "  2.aba01,abb01,abb02:",l_aba.aba01,"  ",l_abb.abb01,"  ",l_abb.abb02
 
            IF SQLCA.sqlcode THEN
               CALL cl_err('g901_cs2',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
 
            SELECT aag_file.* INTO l_aag.* FROM aag_file
             WHERE aag01 = l_abb.abb03
               AND aag00 = tm.bookno       #No.FUN-740020
 
            #-->7.科目編號不存在
            IF SQLCA.sqlcode THEN
            LET errno = '7'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,
                                      l_abb.abb03,errno,t_azi04          
               INITIALIZE l_aag.* TO NULL
            END IF
 
            #-->6.科目編號無效
            IF l_aag.aagacti MATCHES '[Nn]' THEN
            LET errno = '6'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      l_abb.abb03,errno,t_azi04                            
            END IF
 
            #-->81./82./83./84異動碼需存在
            IF l_aag.aag151 MATCHES '[23]' AND cl_null(l_abb.abb11) THEN
            LET errno = '81'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
 
            IF l_aag.aag161 MATCHES '[23]' AND cl_null(l_abb.abb12) THEN
            LET errno = '82'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
 
            IF l_aag.aag171 MATCHES '[23]' AND cl_null(l_abb.abb13) THEN
            LET errno = '83'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
 
            IF l_aag.aag181 MATCHES '[23]' AND cl_null(l_abb.abb14) THEN
            LET errno = '84'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
            IF l_aag.aag311 MATCHES '[23]' AND cl_null(l_abb.abb31) THEN
            LET errno = '111'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
            IF l_aag.aag321 MATCHES '[23]' AND cl_null(l_abb.abb32) THEN
            LET errno = '112'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
            IF l_aag.aag331 MATCHES '[23]' AND cl_null(l_abb.abb33) THEN
            LET errno = '113'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
            IF l_aag.aag341 MATCHES '[23]' AND cl_null(l_abb.abb34) THEN
            LET errno = '114'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
            IF l_aag.aag351 MATCHES '[23]' AND cl_null(l_abb.abb35) THEN
            LET errno = '115'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
            IF l_aag.aag361 MATCHES '[23]' AND cl_null(l_abb.abb36) THEN
           LET errno = '116'                                                        
           EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                     l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                     '',errno,t_azi04                            
            END IF
           #FUN-950053 --------------------add start-----------------------------
            LET l_pmc903 = ' '                                               #No.MOD-B90013 add#FUN-B80161 ADD
            LET g_pmc903 = ' '                                               #No.MOD-B90013 add#FUN-B80161 ADD
            IF l_aba.aba06 = 'AP' THEN
               SELECT pmc903 INTO g_pmc903 FROM pmc_file,apa_file
                WHERE pmc01 = apa05 AND apa44 = l_aba.aba01
               IF cl_null(g_pmc903) THEN                                     #No.MOD-B90013 add#FUN-B80161 ADD
                  SELECT pmc903 INTO g_pmc903 FROM pmc_file,apf_file         #No.MOD-B90013 add#FUN-B80161 ADD
                   WHERE pmc01 = apf03 AND apf44 = l_aba.aba01               #No.MOD-B90013 add#FUN-B80161 ADD
               END IF                                                        #No.MOD-B90013 add#FUN-B80161 ADD
               LET l_pmc903 = g_pmc903 
            END IF 
            LET g_occ37 = ' '                                                #No.MOD-B90013 add#FUN-B80161 ADD
            IF l_aba.aba06 = 'AR' THEN 
               SELECT occ37 INTO g_occ37 FROM occ_file,oma_file
                WHERE occ01 =oma03 AND oma33 = l_aba.aba01
               IF cl_null(g_occ37) THEN                                      #No.MOD-B90013 add#FUN-B80161 ADD
                  SELECT occ37 INTO g_occ37 FROM occ_file,ooa_file           #No.MOD-B90013 add#FUN-B80161 ADD
                   WHERE ooc01 = ooa03 AND ooa33 = l_aba.aba01               #No.MOD-B90013 add#FUN-B80161 ADD
               END IF                                                        #No.MOD-B90013 add#FUN-B80161 ADD
               LET l_pmc903 = g_occ37
            END IF 
            IF l_pmc903 = 'Y' THEN 
               IF l_aag.aag371 MATCHES '[234]' AND cl_null(l_abb.abb37) THEN
                  LET errno = '117' 
                  EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06, 
                                            l_aba.aba08,l_aba.aba09,l_abb.abb02,
                                            '',errno,t_azi04
               END IF 
            ELSE    
           #FUN-950053 -------------add end-------------------------------------------       
               IF l_aag.aag371 MATCHES '[23]' AND cl_null(l_abb.abb37) THEN
               LET errno = '117'                                                        
               EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                         l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                         '',errno,t_azi04                            
               END IF
            END IF               #FUN-950053
            #-->9.預算控制
 
           #IF l_aag.aag21  MATCHES '[Yy]' AND cl_null(l_abb.abb15) THEN   #MOD-A40125 mark  
            IF l_aag.aag21  MATCHES '[Yy]' AND cl_null(l_abb.abb36) THEN   #MOD-A40125 add 
            LET errno = '9'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
            #-->10.單身幣別不可為空白或NULL
            IF l_abb.abb02 IS NOT NULL AND
               (l_abb.abb24 IS NULL OR l_abb.abb24 = ' ') THEN
            LET errno = '10'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      '',errno,t_azi04                            
            END IF
 
 
            #-->A.科目性質不為帳戶
            IF l_aag.aag03  != '2' THEN
            LET errno = 'A'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      l_abb.abb03,errno,t_azi04                            
            END IF
 
            #-->B.不為明細或獨立帳戶
            IF l_aag.aag07   = '1' THEN
            LET errno = 'B'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      l_abb.abb03,errno,t_azi04                            
            END IF
 
            #-->F.部門管理
            IF l_aag.aag05  = 'Y' AND cl_null(l_abb.abb05) THEN
            LET errno = 'F'                                                        
            EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                      l_aba.aba08,l_aba.aba09,l_abb.abb02,           
                                      l_abb.abb03,errno,t_azi04                            
            END IF
 
            IF not cl_null(errno) THEN
               LET l_cnt = l_cnt + 1
            END IF
         END FOREACH
      END IF
   END FOREACH
 
   #-->獨立帳戶
   INITIALIZE l_aba.* TO NULL
 
   FOREACH g901_cs3 INTO l_aag01,l_aag08
 
      DISPLAY "    3.aba01,aag01,aag08:",l_aba.aba01,"  ",l_aag01,"  ",l_aag08
 
      IF SQLCA.sqlcode THEN
         CALL cl_err('g901_cs3',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
 
      #-->I.獨立帳戶值必須有
      LET errno = 'I'
      LET l_aba.aba01 = 'I'
 
      EXECUTE insert_prep USING l_aba.aba02,l_aba.aba01,l_aba.aba06,           
                                l_aba.aba08,l_aba.aba09,'',           
                                l_aag01,errno,t_azi04              #MOD-840605應為l_aag01                   
 
      LET l_cnt = l_cnt + 1
   END FOREACH
 
   DISPLAY '' AT 2,1
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED
 
   #若無錯誤時....
   IF l_cnt > 0 THEN
###GENGRE###       CALL cl_prt_cs3('aglg901','aglg901',l_sql,'')
    CALL aglg901_grdata()    ###GENGRE###
   ELSE
     CALL cl_err('','agl-049',1)
   END IF
 
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg901_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg901")
        IF handler IS NOT NULL THEN
            START REPORT aglg901_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aglg901_datacur1 CURSOR FROM l_sql
            FOREACH aglg901_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg901_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg901_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg901_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B800161----add---------str--------
    DEFINE sr1_o       sr1_t
    DEFINE l_err       STRING  
    DEFINE l_errisi    STRING 
    DEFINE l_display   LIKE type_file.chr1 
    DEFINE l_display1  LIKE type_file.chr1 
    DEFINE l_aba08_fmt STRING 
    DEFINE l_aba09_fmt STRING 
    #FUN-B800161----add---------end--------
    #FUN-CB0058----add---str---
    DEFINE l_aba02      LIKE aba_file.aba02
    DEFINE l_aba01      LIKE aba_file.aba01
    DEFINE l_aba06      LIKE aba_file.aba06
    DEFINE l_aba08      LIKE aba_file.aba08
    DEFINE l_aba09      LIKE aba_file.aba09
    #FUN-CB0058----add---end---

    ORDER EXTERNAL BY sr1.aba01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-B80161 add g_ptime,g_used_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aba01

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
	    #FUN-B80161---add-----str------------
            IF NOT cl_null(sr1_o.aba01) THEN 
               IF sr1_o.aba01 != sr1.aba01 THEN 
                  LET l_display1 = 'Y'
                  LET l_aba02 = sr1.aba02     #FUN-CB0058
                  LET l_aba01 = sr1.aba01     #FUN-CB0058
                  LET l_aba06 = sr1.aba06     #FUN-CB0058
                  LET l_aba08 = sr1.aba08     #FUN-CB0058
                  LET l_aba09 = sr1.aba09     #FUN-CB0058
               ELSE
                  LET l_display1 = 'N'
                  LET l_aba02 = "  "          #FUN-CB0058
                  LET l_aba01 = "  "          #FUN-CB0058
                  LET l_aba06 = "  "          #FUN-CB0058
                  LET l_aba08 = NULL          #FUN-CB0058
                  LET l_aba09 = NULL          #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_aba02 = sr1.aba02     #FUN-CB0058
               LET l_aba01 = sr1.aba01     #FUN-CB0058
               LET l_aba06 = sr1.aba06     #FUN-CB0058
               LET l_aba08 = sr1.aba08     #FUN-CB0058
               LET l_aba09 = sr1.aba09     #FUN-CB0058
            END IF
            PRINTX l_display1 
            PRINTX l_aba02      #FUN-CB0058
            PRINTX l_aba01      #FUN-CB0058
            PRINTX l_aba06      #FUN-CB0058
            PRINTX l_aba08      #FUN-CB0058
            PRINTX l_aba09      #FUN-CB0058
  
            IF cl_null(sr1.num5) THEN 
               LET l_err = cl_gr_getmsg("gre-206",g_lang,sr1.abb04)
            ELSE
               LET l_err = '(',sr1.num5 USING "&",')',cl_gr_getmsg("gre-206",g_lang,sr1.abb04) 
            END IF

            IF sr1.abb04 = 'I' THEN 
               LET l_errisi = cl_gr_getmsg("gre-206",g_lang,'I'),'(',sr1.aba10,')'    #FUN-CB0058 add sr1.aba10
            END IF
            PRINTX l_err
            PRINTX l_errisi 

            IF sr1.abb04 != 'I' AND NOT cl_null(sr1.aba10) THEN 
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
            PRINTX l_display

            LET l_aba08_fmt = cl_gr_numfmt("aba_file","aba08",sr1.azi04) 
            LET l_aba09_fmt = cl_gr_numfmt("aba_file","aba09",sr1.azi04)
            PRINTX l_aba08_fmt 
            PRINTX l_aba09_fmt
            LET sr1_o.* = sr1.* 
            #FUN-B80161---add-----end------------ 

            PRINTX sr1.*

        AFTER GROUP OF sr1.aba01

        
        ON LAST ROW

END REPORT
###GENGRE###END

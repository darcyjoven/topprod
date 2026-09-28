# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmp170.4gl
# Descriptions...: 應付票據寄出作業
# Date & Author..: 92/05/28 BY MAY
# Modify.........: No.7678 03/09/02 Wiky 3.廠商簽收回單時，若一次選擇多筆資料
#                : 要在REPORT p170_rep4(sr)的ON EVERY ROW加上LET  l_str = ''
# Modify.........: No.9730 04/07/13 Nicola 超過20件時,"掛號號碼"應該連連續給號
# Modify.........: No.MOD-480248 04/08/11 Kammy 執行完成，選擇不繼續應離開程式
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin  以za_file方式取代PRINT中文字的部份
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify         : No.MOD-530872 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.MOD-580220 05/08/24 By Smapmin LET g_page_line=33
# Modify.........: No.MOD-590097 05/09/08 By will 全型報表修改
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-660123 06/06/30 By Smapmin 郵局大宗存根其收執頁與存根頁,
#                                                    其同一廠商其名稱在二頁上卻有不同結果
# Modify.........: No.MOD-660125 06/06/30 By Smapmin 掛號起始號碼若不輸入時,應直接回到原來的畫面
# Modify.........: No.FUN-680054 06/08/17 By Smapmin 增加到期日的欄位
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-6C0181 06/12/29 By Smapmin 繼續執行與否的詢問只需問一次即可
# Modify.........: No.FUN-710024 07/01/15 By Jackho 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-750134 07/05/30 By kim 查出資料後,"寄出(choice)" 應 default N
# Modify.........: No.MOD-770125 07/07/27 By Smampin LET g_page_line=66
# Modify.........: No.FUN-7C0092 08/02/16 By zhoufeng 報表打印改為Crystal Report并修改信封打印去掉tm.lino直接用中一刀打印
# Modify.........: No.FUN-840205 08/04/29 By arman 此作業操作方式不夠人性化,修改為多選列印
# Modify.........: No.MOD-870173 08/07/17 By Sarah 在進入apg_cs前,先清空l_str
# Modify.........: No.MOD-880073 08/08/14 By Sarah 畫面上資料請依廠商編號(nmd08),廠商簡稱(nmd24),票號(nmd02)排序呈現
# Modify.........: No.MOD-920099 09/02/07 By Sarah 將l_table1裡的num5_2欄位改為type_file.num10
# Modify.........: No.MOD-970055 09/07/07 By sabrina 目前陣列定義為500，此寫法當資料筆數超過500筆時，會造成程式不正常跳離
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-960301 09/09/21 By baofei 修改跨資料庫代碼  
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.TQC-A40115 10/04/23 By Carrier 多call一次s_dbstring
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A20014 10/10/04 By sabrina 同一家供應商應該只產生一個掛號號碼
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.MOD-C40174 12/04/23 By Elise tm.b2 = 'Y' 時,給予 l_no 預設值為 1,並檢核不可為 null

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD
                   pdate   LIKE type_file.dat,    #No.FUN-680107 DATE
                   c       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
                   puser   LIKE gen_file.gen01,   #No.FUN-680107 VARCHAR(8) #員工編號
                   b1      LIKE type_file.chr1,   #NO.FUN-840205
                   b2      LIKE type_file.chr1,   #NO.FUN-840205
                   b3      LIKE type_file.chr1    #No.FUN-840205
                  END RECORD,
       g_rec_b    LIKE type_file.num5,            #No.FUN-680107 SMALLINT
       g_sno2     LIKE type_file.num5,            #No.FUN-680107 SMALLINT #No:9730
       g_sno3     LIKE type_file.num5,            #No.FUN-680107 SMALLINT #No:9730
       l_cnt3     LIKE type_file.num5,            #No.FUN-680107 SMALLINT
       g_cnt3     LIKE type_file.num5,            #No.FUN-680107 SMALLINT
       l_gen02    LIKE gen_file.gen02,            #員工姓名
       l_page     LIKE type_file.num5,            #MOD-880073 add
       g_dash_1   LIKE type_file.chr1000,         #No.FUN-680107 VARCHAR(80)
       g_pagno    LIKE type_file.num5,            #No.FUN-680107 SMALLINT
       g_nmd      DYNAMIC ARRAY OF RECORD
                   choice  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
                   nmd02   LIKE nmd_file.nmd02,   #票號
                   nmd08   LIKE nmd_file.nmd08,   #廠商編號
                   nmd24   LIKE nmd_file.nmd24,   #廠商簡稱
                   nmd05   LIKE nmd_file.nmd05    #到期日 #FUN-680054
                  END RECORD
DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680107 SMALLINT
DEFINE g_cnt           LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_i             LIKE type_file.num5        #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(72)
DEFINE g_sql           STRING                     #No.FUN-7C0092
DEFINE g_str           STRING                     #No.FUN-7C0092
DEFINE l_table         STRING                     #No.FUN-7C0092
DEFINE l_table1        STRING                     #No.FUN-7C0092
DEFINE l_table2        STRING                     #No.FUN-7C0092
DEFINE l_table3        STRING                     #No.FUN-7C0092
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   LET g_sql = "nmd08.nmd_file.nmd08,nmd09.nmd_file.nmd09,",
               "pmc53.pmc_file.pmc53,pmc081.pmc_file.pmc081,",
               "pmc082.pmc_file.pmc082,nmd22.nmd_file.nmd22"
   LET l_table = cl_prt_temptable('anmp170',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "nmd08.nmd_file.nmd08,nmd09.nmd_file.nmd09,",
               "num5.type_file.num5,num5_1.type_file.num5,",
               "num5_2.type_file.num10,nmd22.nmd_file.nmd22,",  #MOD-920099 mod
               "pmc53.pmc_file.pmc53,page.type_file.num5"   #MOD-880073 add page
   LET l_table1 = cl_prt_temptable('anmp1701',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "nmd08.nmd_file.nmd08,nmd09.nmd_file.nmd09,",
               "pmc081.type_file.chr1000,nmd01.nmd_file.nmd01,",
               "nmd02.nmd_file.nmd02,nmd07.nmd_file.nmd07,",
               "nmd05.nmd_file.nmd05,nmd04.nmd_file.nmd04,",
               "nmd11.nmd_file.nmd11,nmd10.nmd_file.nmd10,",
               "azi04.azi_file.azi04,azi05.azi_file.azi05"
   LET l_table2 = cl_prt_temptable('anmp1702',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "nmd08.nmd_file.nmd08,nmd01.nmd_file.nmd01,",
               "apk03.type_file.chr1000"
   LET l_table3 = cl_prt_temptable('anmp1703',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   CALL p170_1()                         #接受選擇
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
#將資料選出, 並進行挑選
FUNCTION p170_1()
   DEFINE   l_ac       LIKE type_file.num5,    #program array no  #No.FUN-680107 SMALLINT
            l_ok       LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01) #判斷是否取得資料
            l_exit     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
            l_flag     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
            l_sl       LIKE type_file.num5,    #No.FUN-680107 SMALLINT #screen array no
            l_sl2      LIKE type_file.num5,    #No.FUN-680107 SMALLINT #screen array no
            l_cnt      LIKE type_file.num5,    #所選擇筆數  #No.FUN-680107 SMALLINT
            l_cnt1     LIKE type_file.num5,    #所選擇筆數  #No.FUN-680107 SMALLINT
            l_cnt2     LIKE type_file.num5,    #所選擇筆數  #No.FUN-680107 SMALLINT
            g_cnt1     LIKE type_file.num5,    #No.FUN-680107 SMALLINT
            l_wc       LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(100)
            l_sql      LIKE type_file.chr1000, #RDSQL STATEMENT  #No.FUN-680107 VARCHAR(300)
            l_chr      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
            l_name     LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(20)
            l_no       LIKE type_file.num10,   #No.FUN-680107 INTEGER
            l_nmd22    DYNAMIC ARRAY OF LIKE nmd_file.nmd22,        #MOD-970055 add 
            l_nmd01    DYNAMIC ARRAY OF LIKE nmd_file.nmd01,        #MOD-970055 add 
            l_nmd09    DYNAMIC ARRAY OF LIKE nmd_file.nmd09,        #MOD-970055 add 
            l_nmd04    DYNAMIC ARRAY OF LIKE nmd_file.nmd04,        #MOD-970055 add 
            l_nmd07    DYNAMIC ARRAY OF LIKE nmd_file.nmd07,        #MOD-970055 add 
            l_nmd21    DYNAMIC ARRAY OF LIKE nmd_file.nmd21,        #MOD-970055 add 
            l_nmd11    DYNAMIC ARRAY OF LIKE nmd_file.nmd11,        #MOD-970055 add 
            l_nmd10    DYNAMIC ARRAY OF LIKE nmd_file.nmd10,        #MOD-970055 add 
            l_nmd101   DYNAMIC ARRAY OF LIKE nmd_file.nmd101,       #MOD-970055 add
            l_allow_insert  LIKE type_file.num5,           #可新增否  #No.FUN-680107 SMALLINT
            l_allow_delete  LIKE type_file.num5,           #No.FUN-680107 SMALLINT
            l_za05          LIKE type_file.chr1000         #No.FUN-680107 VARCHAR(40)
   DEFINE   l_pmc081   LIKE pmc_file.pmc081,
            l_pmc082   LIKE pmc_file.pmc082,
            l_pmc53    LIKE pmc_file.pmc53,
            l_num      LIKE type_file.num10,
            l_tel      LIKE zo_file.zo05,
            l_add      LIKE zo_file.zo041,
            l_str      LIKE type_file.chr1000,
            str        LIKE type_file.chr1000,
            l_apk03    LIKE apk_file.apk03,
            l_apg03    LIKE apg_file.apg03,
            l_apg04    LIKE apg_file.apg04,
            l_azp03   LIKE azp_file.azp03
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW p170_w AT p_row,p_col WITH FORM "anm/42f/anmp170"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET tm.c = 'Y'
   LET tm.b1= 'N'       #NO.FUN-840205
   LET tm.b2= 'N'       #NO.FUN-840205
   LET tm.b3= 'N'       #NO.FUN-840205
   LET tm.pdate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_cnt2= 1
   WHILE TRUE
      IF l_cnt2 <= 1 THEN                #第一次執行
         CLEAR FORM
         CALL g_nmd.clear()
         LET l_cnt=0                        #已選筆數
         IF s_anmshut(0) THEN
            EXIT WHILE
         END IF
         LET l_exit='Y'
         CALL cl_getmsg('anm-022',g_lang)
         RETURNING g_msg
         CONSTRUCT l_wc ON nmd02,nmd08,nmd24,nmd05   #FUN-680054
              FROM s_nmd[1].nmd02,s_nmd[1].nmd08,s_nmd[1].nmd24,s_nmd[1].nmd05
 
           ON ACTION locale
              LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
              EXIT CONSTRUCT
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
              EXIT CONSTRUCT
 
           ON ACTION exit              #加離開功能genero
              LET INT_FLAG = 1
              EXIT CONSTRUCT
         END CONSTRUCT
         LET l_wc = l_wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup') #FUN-980030
 
         IF g_action_choice = "locale" THEN  #genero
            LET g_action_choice = ""
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         END IF
 
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
         END IF
 
         LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
                     " VALUES(?,?,?,?,?,?)"
         PREPARE insert_prep FROM g_sql
         IF STATUS THEN
            CALL cl_err('insert_prep:',status,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF
 
         LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table1 CLIPPED,       
                     " VALUES(?,?,?,?,?,?,?,?)"    #MOD-880073 add ?
         PREPARE insert_prep1 FROM g_sql                                         
         IF STATUS THEN                                                         
            CALL cl_err('insert_prep1:',status,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM                   
         END IF
 
         LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table2 CLIPPED,       
                     " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"                                     
         PREPARE insert_prep2 FROM g_sql                                         
         IF STATUS THEN                                                         
            CALL cl_err('insert_prep2:',status,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM                   
         END IF
 
         LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table3 CLIPPED,       
                     " VALUES(?,?,?)"                                     
         PREPARE insert_prep3 FROM g_sql                                         
         IF STATUS THEN                                                         
            CALL cl_err('insert_prep3:',status,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM                   
         END IF
         
         CALL cl_del_data(l_table)
         CALL cl_del_data(l_table1)
         CALL cl_del_data(l_table2)
         CALL cl_del_data(l_table3)
         
         LET l_num = 0
 
         LET l_cnt3 = 0
         LET g_cnt3 = 0
         LET l_page = 1   #MOD-880073 add
         LET l_sql="SELECT '',nmd02,nmd08,nmd24,nmd05,nmd22,nmd09,nmd01,",   #FUN-680054
                   "       nmd04, nmd07, nmd21,nmd11,nmd10,nmd101 ",   #FUN-680054
                   "  FROM nmd_file",
                   "  WHERE ",l_wc CLIPPED,
                   "  AND nmd02 IS NOT NULL AND nmd02 != ' ' ",  #票號
                   "  AND nmd14 = '1' ",                     #寄領方式為'1'寄出
                   "  AND nmd30 = 'Y' ",
                   "  AND nmd12 NOT IN ('6','7','9') ",
                   "  AND nmd15 IS NULL ",   #寄領日不為空白
                   " ORDER BY nmd08,nmd24,nmd02"   #MOD-880073 add
         PREPARE p170_prepare FROM l_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('PREPARE:',SQLCA.sqlcode,1)
            EXIT WHILE
         END IF
         DECLARE p170_cs CURSOR FOR p170_prepare
         CALL g_nmd.clear()
         LET g_cnt=1                                         #總選取筆數
         FOREACH p170_cs
            INTO g_nmd[g_cnt].*,l_nmd22[g_cnt],l_nmd09[g_cnt],l_nmd01[g_cnt],
                 l_nmd04[g_cnt],l_nmd07[g_cnt],l_nmd21[g_cnt],   #FUN-680054
                 l_nmd11[g_cnt],l_nmd10[g_cnt],l_nmd101[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET g_nmd[g_cnt].choice='N' #FUN-750134
            LET g_cnt = g_cnt + 1                           #累加筆數
            IF g_cnt > g_max_rec THEN                         #超過肚量了
               EXIT FOREACH
            END IF
         END FOREACH
         CALL g_nmd.deleteElement(g_cnt)   #取消 Array Element
         IF g_cnt=1 THEN                                     #沒有抓到
            CALL cl_err('','anm-050',0)                      #顯示錯誤, 並回去
            CONTINUE WHILE
         END IF
         LET g_rec_b=g_cnt-1                                   #正確的總筆數
      END IF
 
      DISPLAY g_rec_b TO FORMONLY.cnt      #應寄筆數
      LET l_cnt = 0
      DISPLAY l_cnt TO FORMONLY.cmt         #寄出筆數
 
      INPUT ARRAY g_nmd WITHOUT DEFAULTS FROM s_nmd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE ,APPEND ROW=FALSE)
 
         BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         AFTER FIELD choice
            IF NOT cl_null(g_nmd[l_ac].choice) THEN
               IF g_nmd[l_ac].choice NOT MATCHES "[YN]" THEN
                  NEXT FIELD choice
               END IF
            END IF
            LET l_cnt  = 0
            FOR g_i =1 TO g_nmd.getLength()
               IF g_nmd[g_i].choice = 'Y' AND
                  NOT cl_null(g_nmd[g_i].nmd02)  THEN
                  LET l_cnt = l_cnt + 1
               END IF
            END FOR
            DISPLAY l_cnt TO FORMONLY.cmt      #寄出筆數
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLN  #重查
            LET l_exit='N'
            LET l_cnt2 = 0
            EXIT INPUT
 
         ON ACTION mail_all  #整批
            FOR g_i = 1 TO g_nmd.getLength()     #將所有的設為選擇
               LET g_nmd[g_i].choice="Y"
            END FOR
            DISPLAY g_rec_b TO FORMONLY.cmt
            LET l_ac = ARR_CURR()
 
         ON ACTION mail_none #整批不寄出
            FOR g_i = 1 TO g_nmd.getLength()     #將所有的設為選擇
               LET g_nmd[g_i].choice="N"
            END FOR
            DISPLAY 0 TO FORMONLY.cmt
            LET l_ac = ARR_CURR()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET l_cnt2 = 0
         EXIT WHILE
      END IF
      IF l_cnt < 1 THEN                      #已選筆數超過 0筆
         CALL cl_err('','anm-058',0)
         CONTINUE WHILE
      ELSE
      DISPLAY BY NAME tm.pdate,tm.puser,tm.b1,tm.b2,tm.b3             #NO.FUN-840205                       
      INPUT BY NAME tm.pdate,tm.puser,tm.b1,tm.b2,tm.b3 WITHOUT DEFAULTS          #NO.FUN-840205       
 
         AFTER FIELD puser
            IF NOT cl_null(tm.puser) THEN
               SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01 = tm.puser
               IF SQLCA.sqlcode THEN
                  LET l_gen02 = ' '
                  CALL cl_err3("sel","gen_file",tm.puser,"","anm-053","","",0) #No.FUN-660148
                  NEXT FIELD puser
               ELSE
                  DISPLAY l_gen02 TO FORMONLY.gen02
               END IF
            END IF
         AFTER FIELD b1
            IF NOT cl_null(tm.b1) THEN
               IF tm.b1 NOT MATCHES '[YN]' THEN
                  NEXT FIELD b1
               END IF
            END IF
         AFTER FIELD b2
            IF NOT cl_null(tm.b2) THEN
               IF tm.b2 NOT MATCHES '[YN]' THEN
                  NEXT FIELD b2
               END IF
            END IF
         AFTER FIELD b3
            IF NOT cl_null(tm.b3) THEN
               IF tm.b3 NOT MATCHES '[YN]' THEN
                  NEXT FIELD b3
               END IF
            END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(puser)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = tm.puser
                  CALL cl_create_qry() RETURNING tm.puser
                  DISPLAY BY NAME tm.puser
                  NEXT FIELD puser
               OTHERWISE
                  EXIT CASE
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF l_exit = 'N' THEN
         LET INT_FLAG = 0
         CONTINUE WHILE
      END IF
      IF NOT cl_sure(20,20) THEN
         CONTINUE WHILE
      END IF
      LET g_sno2=0  #No:9730
      LET g_sno3=0  #No:9730
 
      END IF
 
      #增加輸入掛號起始號碼
      LET p_row = 10
      LET p_col = 40
      IF tm.b2 = 'Y' THEN #NO.FUN-840205

         OPEN WINDOW anmp1701_w AT p_row,p_col WITH 1 ROWS, 28 COLUMNS
         CALL cl_set_win_title("anmp1701_w")
 
         CALL cl_getmsg('anm-998',g_lang) RETURNING g_msg
         LET INT_FLAG = 0  ######add for prompt bug 
         LET l_no = 1      #MOD-C40174 add
         PROMPT g_msg CLIPPED FOR l_no
            ATTRIBUTES(WITHOUT DEFAULTS)  #MOD-C40174 add
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         END PROMPT
         CLOSE WINDOW anmp1701_w
         IF INT_FLAG THEN
            LET INT_FLAG=0
            CONTINUE WHILE
         END IF
      END IF
 
      CALL cl_wait()
      FOR l_ac = 1 TO g_cnt
         IF g_nmd[l_ac].choice MATCHES '[Yy]' THEN
               IF tm.b1 = 'Y' THEN      #NO.FUN-840205
                  SELECT pmc53 INTO l_pmc53 FROM  pmc_file WHERE pmc01 = g_nmd[l_ac].nmd08
                  IF STATUS THEN LET l_pmc53=' ' END IF
                  IF cl_null(l_nmd09[l_ac]) THEN
                     SELECT pmc081,pmc082 INTO  l_pmc081,l_pmc082
                            FROM  pmc_file WHERE pmc01 = g_nmd[l_ac].nmd08
                     IF SQLCA.sqlcode THEN 
                        LET l_pmc081 = ' '
                        LET l_pmc082 = ' '
                     END IF
                   END IF
                   EXECUTE insert_prep USING g_nmd[l_ac].nmd08,l_nmd09[l_ac],
                                             l_pmc53,l_pmc081,l_pmc082,l_nmd22[l_ac]
               END IF       #NO.FUN-840205
               IF tm.b2 = 'Y' THEN     #NO.FUN-840205
                   SELECT  zo05,zo02,zo041 INTO  l_tel,g_company,l_add
                      FROM zo_file WHERE zo01 = g_lang
                   LET l_cnt3 = l_cnt3 + 1
                   IF g_sno2=0 THEN 
                      LET l_num=l_no
                      LET g_sno2=g_sno2+1
                   ELSE
                      IF g_nmd[l_ac].nmd08 <> g_nmd[l_ac-1].nmd08 THEN      #MOD-A20014 add
                         LET l_num=l_num+1 
                      END IF                                                #MOD-A20014 add
                   END IF
                   SELECT pmc53 INTO l_pmc53 FROM  pmc_file 
                      WHERE pmc01 = g_nmd[l_ac].nmd08
                   IF SQLCA.SQLCODE THEN LET l_pmc53=' ' END IF
                   EXECUTE insert_prep1 USING
                      g_nmd[l_ac].nmd08,l_nmd09[l_ac],
                      '1',l_cnt3,l_num,l_nmd22[l_ac],l_pmc53,l_page   #MOD-880073 add l_page
                   EXECUTE insert_prep1 USING
                      g_nmd[l_ac].nmd08,l_nmd09[l_ac],
                      '2',l_cnt3,l_num,l_nmd22[l_ac],l_pmc53,l_page   #MOD-880073 add l_page
                   IF l_cnt3 >= 18 THEN    #MOD-880073 mod 20->18
                      LET l_cnt3 = 0 
                      LET l_page = l_page + 1
                   END IF
               END IF       #NO.FUN-840205
               IF tm.b3 = 'Y' THEN   #NO.FUN-840205
                  SELECT  zo05,zo07,zo041 INTO  l_tel,g_company,l_add
                     FROM zo_file WHERE zo01 = g_lang 
                  SELECT azi03, azi04, azi05 INTO t_azi03, t_azi04, t_azi05 
                     FROM azi_file WHERE azi01 = l_nmd21[l_ac]
                  IF cl_null(l_nmd09[l_ac]) THEN 
                     SELECT pmc081,pmc082 INTO  l_pmc081,l_pmc082 
                        FROM  pmc_file WHERE pmc01 = g_nmd[l_ac].nmd08
                     IF SQLCA.sqlcode THEN 
                        LET l_pmc081 = ' '
                        LET l_pmc082 = ' '
                     END IF
                  END IF
                  IF cl_null(l_nmd09[l_ac]) THEN 
                     LET str = l_pmc081,'  ',l_pmc082
                  ELSE 
                     LET str = l_nmd09[l_ac]
                  END IF
                  EXECUTE insert_prep2 USING g_nmd[l_ac].nmd08,l_nmd09[l_ac],
                                             str,l_nmd01[l_ac],g_nmd[l_ac].nmd02,
                                             l_nmd07[l_ac],g_nmd[l_ac].nmd05,
                                             l_nmd04[l_ac],l_nmd11[l_ac],
                                             l_nmd10[l_ac],t_azi04,t_azi05
                  IF NOT cl_null(l_nmd10[l_ac]) THEN
                     LET l_sql = "SELECT apg03,apg04 FROM apg_file ",
                                 " WHERE apg01 = '",l_nmd10[l_ac],"'"
                     IF NOT cl_null(l_nmd101[l_ac]) THEN
                        LET l_sql = l_sql CLIPPED," AND apg02 = ",l_nmd101[l_ac]
                     END IF
                     PREPARE apg_pre FROM l_sql
                     DECLARE apg_cs CURSOR FOR apg_pre
                     LET l_str = ''   #MOD-870173 add
                     FOREACH apg_cs INTO l_apg03,l_apg04
                         SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_apg03  #TQC-960301                                 
                     #   LET l_azp03 = s_dbstring(l_azp03)   #TQC-960301    #No.TQC-A40115
                         #LET l_sql = "SELECT apk03 FROM ",s_dbstring(l_azp03),"apk_file ",
                         LET l_sql = "SELECT apk03 FROM ",cl_get_target_table(l_apg03,'apk_file'), #FUN-A50102
                                     " WHERE apk01 = '",l_apg04,"'"
                         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-A50102							
		                 CALL cl_parse_qry_sql(l_sql,l_apg03) RETURNING l_sql #FUN-A50102            
                         PREPARE apk_pre FROM l_sql
                         DECLARE apk_cs CURSOR FOR apk_pre
                         FOREACH apk_cs INTO l_apk03
                            LET l_str = l_str CLIPPED,l_apk03 CLIPPED,','
                         END FOREACH
                     END FOREACH
                     EXECUTE insert_prep3 USING g_nmd[l_ac].nmd08,l_nmd01[l_ac],
                                                l_str
                  END IF
               END IF     #NO.FUN-840205
         END IF
      END FOR
         IF tm.b1 = 'Y' THEN  #NO.FUN-840205
            LET l_name = 'anmp170'
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            LET g_str = '' 
            CALL cl_prt_cs3('anmp170',l_name,l_sql,g_str)    #NO.FUN-840205
         END IF     #NO.FUN-840205
         IF tm.b2 = 'Y' THEN     #NO.FUN-840205
            IF tm.b1 = 'Y' THEN
               CALL cl_err('','anm-324',1)    #NO.FUN-840205
            END IF
            LET l_name = 'anmp170_1'
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
            LET g_str = YEAR(tm.pdate)-1911,";",MONTH(tm.pdate),";",
                        DAY(tm.pdate),";",l_gen02,";",l_add,";",
                        l_tel,";",g_memo
            CALL cl_prt_cs3('anmp170',l_name,l_sql,g_str)    #NO.FUN-840205
         END IF   #NO.FUN-840205
         IF tm.b3 = 'Y' THEN    #NO.FUN-840205 
           IF tm.b1 = 'Y' OR tm.b2 = 'Y' THEN
            CALL cl_err('','anm-325',1)    #NO.FUN-840205
           END IF
            LET l_name = 'anmp170_2'
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                        "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
            LET g_str = l_add
            CALL cl_prt_cs3('anmp170',l_name,l_sql,g_str)    #NO.FUN-840205
         END IF          #NO.FUN-840205
      ERROR ' '
      IF cl_confirm('anm-962') THEN
         LET g_success = 'Y'   #MOD-6C0181
         BEGIN WORK   #MOD-6C0181
         CALL s_showmsg_init()         #No.FUN-710024
         FOR l_ac = 1 TO g_rec_b
            IF g_nmd[l_ac].choice MATCHES '[yY]' THEN
               UPDATE nmd_file SET nmd15 = tm.pdate,
                                   nmd16 = tm.puser
                WHERE nmd01 = l_nmd01[l_ac]
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('nmd01',l_nmd01[l_ac],'(p170_input:nmd)',SQLCA.sqlcode,1)
               END IF
            END IF
         END FOR
         CALL s_showmsg()                 #No.FUN-710024
         IF g_success = 'Y' THEN
            CALL cl_cmmsg(1)
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            CALL cl_rbmsg(1)
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF #No.MOD-480248
      END IF
   END WHILE
   CLOSE WINDOW p170_w
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15

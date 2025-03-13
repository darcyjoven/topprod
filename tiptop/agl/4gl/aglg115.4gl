# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg115.4gl
# Descriptions...: 全年度財務報表列印
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/10 By Nora
# Modify.........: No.MOD-4A0248 04/10/18 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-510007 05/02/01 By Nicola 報表架構修改
# Modify.........: ON.MOD-5B0190 05/11/28 BY yiting
# Modify.........: No.TQC-5C0037 05/12/08 By kevin 加入頁次
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/08 By Carrier 報表格式調整
# Modify.........: No.MOD-6B0087 06/11/17 By Smapmin 最右方的合計為NULL
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/09 By sherry  會計科目加帳套
# Modify.........: No.FUN-780058 07/08/28 By sherry 報表改寫由Crystal Report產出
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法   
# Modify.........: No.MOD-870140 08/07/15 By Sarah 報表結構列印碼為H的金額還是會印出
# Modify.........: No.MOD-880120 08/08/15 By Sarah 判斷餘額為0者不列印,maj03需改為MATCHES '[0125]'
# Modify.........: No.MOD-930148 09/03/23 By Sarah 當月結方法選擇為帳結法時,報表無法產出累計/前期損益表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/20 By chells 跨DB語法改成不跨
# Modify.........: No:MOD-A30135 10/03/19 By Dido  CALL cl_dynamic_locale()   
# Modify.........: No:MOD-A40135 10/06/13 By wujie 叁考gglr112增加maj06的判断
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:MOD-AB0181 10/11/18 By Dido 計算區間應以輸入區間為主 
# Modify.........: No:TQC-AB0066 10/11/19 By Dido WHERE 條件改用 IN 
# Modify.........: No:MOD-B60201 11/06/24 By Dido 年合計應與 12月份相同 
# Modify.........: No:MOD-B70132 11/07/14 By Dido 年合計應抓取截止月份 
# Modify.........: No:FUN-B90140 11/08/12 By Polly 1.增加判斷，若maj06 = '3'或maj06 = '1'，時，則年合計抓取整年>
#                                                  2.修正當oaj06=1時，判斷期別應小於tm.bm
# Modify.........: No:FUN-B80161 11/08/26 By chenying 明細類CR轉GR
# Modify.........: No:FUN-B80161 12/01/12 By qirl MOD-B80132追單
# Modify.........: No:FUN-B80161 12/01/12 By yangtt FUN-B90140追單
# Modify.........: No:FUN-B80161 12/01/16 By xuxz MOD-BC0231追單
# Modify.........: No.FUN-B80161 12/01/16 By xuxz 程序規範修改
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.FUN-C50004 12/05/11 By nanbing GR 優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                rtype   LIKE type_file.chr1,     #報表結構編號 #No.FUN-680098 VARCHAR(1)
                a       LIKE mai_file.mai01,     #報表結構編號 #No.FUN-680098 VARCHAR(6)
                b       LIKE aaa_file.aaa01,     #帳別編號     #No.FUN-670039
                yy      LIKE type_file.num5,     #輸入年度     #No.FUN-680098 smallint
                bm      LIKE type_file.num5,     #Begin 期別   #No.FUN-680098 smallint
                em      LIKE type_file.num5,     #End 期別     #No.FUN-680098 smallint
                c       LIKE type_file.chr1,     #異動額及餘額為0者是否列印#No.FUN-680098 VARCHAR(1)  
                d       LIKE type_file.chr1,     #金額單位                 #No.FUN-680098 VARCHAR(1)
                e       LIKE type_file.num5,     #小數位數                 #No.FUN-680098 smallint
                f       LIKE type_file.num5,     #列印最小階數             #No.FUN-680098 smallint
                h       LIKE type_file.chr4,     #額外說明類別             #No.FUN-680098 VARCHAR(4)
                o       LIKE type_file.chr1,     #轉換幣別否               #No.FUN-680098 VARCHAR(1)
                p       LIKE azi_file.azi01,     #幣別
                q       LIKE azj_file.azj03,     #匯率
                r       LIKE azi_file.azi01,     #幣別
                more    LIKE type_file.chr1,     #Input more condition(Y/N)  #No.FUN-680098   VARCHAR(1)
                acc_code  LIKE type_file.chr1    #FUN-B80161 FROM FUN-B90140   Add
              END RECORD,
          bdate,edate    LIKE type_file.dat,     #No.FUN-680098  date
          i,j,k          LIKE type_file.num5,    #No.FUN-680098 smallint
          g_unit         LIKE type_file.num10,   #金額單位基數   #No.FUN-680098   integer
          g_bookno       LIKE aah_file.aah00,    #帳別
          g_mai02        LIKE mai_file.mai02,
          g_mai03        LIKE mai_file.mai03,
          g_tot          ARRAY[100,12] OF LIKE type_file.num20_6,    #No.FUN-680098   dec(20,6)
          bal            ARRAY[12] OF LIKE type_file.num20_6,        #No.FUN-680098   dec(20,6)
          g_basetot      ARRAY[12] OF LIKE type_file.num20_6,        #No.FUN-680098   dec(20,6)
          amt            LIKE aah_file.aah04
   DEFINE g_aaa03        LIKE aaa_file.aaa03   
   DEFINE g_aaa09        LIKE aaa_file.aaa09     #MOD-930148 add
   DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
   DEFINE g_msg          LIKE type_file.chr1000                                      #No.FUN-680098   VARCHAR(72)
   #No.FUN-780058---Begin                                                       
   DEFINE l_table        STRING
   DEFINE g_sql          STRING
   DEFINE g_str          STRING
   #No.FUN-780058---End    
 
###GENGRE###START
TYPE sr1_t RECORD
    maj31 LIKE maj_file.maj31,   #NO.FUN-B80158 ADD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal01 LIKE aah_file.aah04,
    bal02 LIKE aah_file.aah04,
    bal03 LIKE aah_file.aah04,
    bal04 LIKE aah_file.aah04,
    bal05 LIKE aah_file.aah04,
    bal06 LIKE aah_file.aah04,
    bal07 LIKE aah_file.aah04,
    bal08 LIKE aah_file.aah04,
    bal09 LIKE aah_file.aah04,
    bal10 LIKE aah_file.aah04,
    bal11 LIKE aah_file.aah04,
    bal12 LIKE aah_file.aah04,
    bal13 LIKE aah_file.aah04,
    line LIKE type_file.num5
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114#FUN-B80158 mark
 
   #No.FUN-780058---Begin                                                       
   LET g_sql = "maj31.maj_file.maj31,",  #FUN-B80161 FROM FUN-B90140 add maj31
               "maj20.maj_file.maj20,",                                         
               "maj20e.maj_file.maj20e,",                                       
               "maj02.maj_file.maj02,",   #項次(排序要用的)                     
               "maj03.maj_file.maj03,",   #列印碼                               
               "bal01.aah_file.aah04,",    #期初借                               
               "bal02.aah_file.aah04,",    #期初借                               
               "bal03.aah_file.aah04,",    #期初借                               
               "bal04.aah_file.aah04,",    #期初借                               
               "bal05.aah_file.aah04,",    #期初借                               
               "bal06.aah_file.aah04,",    #期初借                               
               "bal07.aah_file.aah04,",    #期初借                               
               "bal08.aah_file.aah04,",    #期初借                               
               "bal09.aah_file.aah04,",    #期初借                               
               "bal10.aah_file.aah04,",    #期初借                               
               "bal11.aah_file.aah04,",    #期初借                               
               "bal12.aah_file.aah04,",    #期初借                               
               "bal13.aah_file.aah04,",    #期初借                               
               "line.type_file.num5"      #1:表示此筆為空行 2:表示此筆不為空    
                                                                                
   LET l_table = cl_prt_temptable('aglg115',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80161 add#FUN-B80161 mark
      #CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add#FUN-B80161 mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008 
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?  )"          #FUN-B80161 FROM FUN-B90140 add 1?                             
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80161 add#FUN-B80161 mark
      #CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add#FUN-B80161 mark
      EXIT PROGRAM                         
   END IF                                                                       
   #No.FUN-780058---End     
    
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B80161 add
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.rtype= ARG_VAL(8)
   LET tm.a    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)   #TQC-610056
   LET tm.yy   = ARG_VAL(11)
   LET tm.em   = ARG_VAL(12)
   LET tm.c    = ARG_VAL(13)
   LET tm.d    = ARG_VAL(14)
   LET tm.e    = ARG_VAL(15)
   LET tm.f    = ARG_VAL(16)
   LET tm.h    = ARG_VAL(17)
   LET tm.o    = ARG_VAL(18)
   LET tm.p    = ARG_VAL(19)
   LET tm.q    = ARG_VAL(20)
   LET tm.r    = ARG_VAL(21)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
#No.FUN-740020---begin
   IF cl_null(tm.b) THEN
      LET tm.b = g_aza.aza81
   END IF
#No.FUN-740020---end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r115_tm() 
   ELSE
      CALL r115()  
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
END MAIN
 
FUNCTION r115_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,                         #No.FUN-680098 smallint
          l_sw          LIKE type_file.chr1,       #重要欄位是否空白 #No.FUN-680098 VARCHAR(1)
          l_cmd         LIKE type_file.chr1000,                      #No.FUN-680098 VARCHAR(400)
          li_chk_bookno LIKE type_file.num5,       #No.FUN-670005    #No.FUN-680098 smallint
          li_result     LIKE type_file.num5        #No.FUN-6C0068 
 
   CALL s_dsmark(g_bookno)
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r115_w AT p_row,p_col WITH FORM "agl/42f/aglg115"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
 
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file", g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
 
#  LET tm.b = g_bookno      #No.FUN-740020
   LET tm.b = g_aza.aza81   #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.acc_code = 'N'   #FUN-B80161 FROM FUN-B90140   Add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      LET l_sw = 1
 
#     INPUT BY NAME tm.rtype,tm.a,tm.b,tm.yy,tm.em,tm.e,tm.f,  #No.FUN-740020
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.yy,tm.em,tm.e,tm.f,  #No.FUN-740020 
                    tm.d,tm.acc_code,tm.c,tm.h,tm.o,tm.r,      #FUN-B80161 FROM FUN-B90140 add tm.acc_code
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()                  #MOD-A30135
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      
         AFTER FIELD a
            IF tm.a IS NULL THEN
               NEXT FIELD a
            END IF
          #FUN-6C0068--begin
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
          #FUN-6C0068--end
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a
               AND mai00 = tm.b      #No.FUN-740020
               AND maiacti IN ('Y','y')
            IF STATUS THEN
#              CALL cl_err('sel mai:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   #No.FUN-660123
               NEXT FIELD a
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF
      
         AFTER FIELD b
            IF tm.b IS NULL THEN 
               NEXT FIELD b
            END IF
            #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-670005--end
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN 
#              CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD b 
            END IF
      
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c 
            END IF
      
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy 
            END IF
      
         AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.em IS NULL THEN
               NEXT FIELD em
            END IF
#No.TQC-720032 -- begin --
#            IF tm.em < 1 OR tm.em > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD em
#            END IF
#No.TQC-720032 -- end --
      
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]' THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
      
         AFTER FIELD e
            IF tm.e < 0 THEN
               LET tm.e = 0
               DISPLAY BY NAME tm.e
            END IF
      
         AFTER FIELD f
            IF tm.f IS NULL OR tm.f < 0 THEN
               LET tm.f = 0
               DISPLAY BY NAME tm.f
               NEXT FIELD f
            END IF
      
         AFTER FIELD h
            IF tm.h NOT MATCHES "[YN]" THEN
               NEXT FIELD h
            END IF
      
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN
               NEXT FIELD o
            END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
      
         BEFORE FIELD p
            IF tm.o = 'N' THEN
               NEXT FIELD more 
            END IF
      
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.p,'agl-109',0)    #No.FUN-660123
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","",0)   #No.FUN-660123
               NEXT FIELD p
            END IF
      
         BEFORE FIELD q
            IF tm.o = 'N' THEN 
               NEXT FIELD o
            END IF
      
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.yy IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy 
               CALL cl_err('',9033,0)
            END IF
            IF tm.em IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.em 
            END IF
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
      
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask() 
 
         ON ACTION CONTROLP
            IF INFIELD(a) THEN
                #---No.MOD-4A0248
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042  Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a
               #---END----------
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF
 
            IF INFIELD(p) THEN
                #--No.MOD-4A0248
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
               #------END-----
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF
 
             #--No.MOD-4A0248---
            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form='q_aaa'
               LET g_qryparam.default1=tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF
            #--END-------------
 
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
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r115_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg115'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg115','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",   #TQC-610056
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",
                        " '",tm.h CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.p CLIPPED,"'",
                        " '",tm.q CLIPPED,"'",
                        " '",tm.r CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg115',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r115_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r115()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r115_w
 
END FUNCTION
 
FUNCTION r115()
   DEFINE l_name    LIKE type_file.chr20         # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0073
   DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT                 #No.FUN-680098   VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680098    VARCHAR(1)
   DEFINE maj       RECORD LIKE maj_file.*
#   DEFINE l_dbs     LIKE azp_file.azp03          #MOD-930148 add                  #No.FUN-A10098 ----mark
   DEFINE l_endy1   LIKE abb_file.abb07          #MOD-930148 add
   DEFINE l_endy2   LIKE abb_file.abb07          #MOD-930148 add
   DEFINE sr        RECORD
                       bal01,bal02,bal03,bal04,bal05,bal06,
                       bal07,bal08,bal09,bal10,bal11,bal12,
                       bal13   LIKE aah_file.aah04
                    END RECORD
 
   CALL cl_del_data(l_table)               #No.FUN-780058   
#No.FUN-A10098 ----mark start 
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_plant  #MOD-930148 add
#   LET l_dbs = l_dbs CLIPPED,'.'                              #MOD-930148 add
#No.FUN-A10098 ----mark end
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r115_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80161 add
      EXIT PROGRAM
   END IF
   DECLARE r115_c CURSOR FOR r115_p
 
   FOR i = 1 TO 100 
      FOR j = 1 TO 12
         LET g_tot[i,j] = 0 
      END FOR
   END FOR

   #FUN-C50004 add sta
   LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",    
               " WHERE abb00 = '",tm.b,"' ",
               "   AND aag00 = '",tm.b,"' ",
               "   AND aba00 = abb00 AND aba01 = abb01 ",
               "   AND abb03 BETWEEN ? AND ? ",
               "   AND aba06 = 'CE' AND abb06 = '1' AND aba03 = '",tm.yy,"' ",
               "   AND aba04 BETWEEN '",tm.bm,"' AND ? ",
               "   AND abapost = 'Y' ",
               "   AND abb03 = aag01 ",
               "   AND aag03 <> '4' "
   PREPARE r115_prepare3 FROM l_sql
   DECLARE r115_c3  CURSOR FOR r115_prepare3

   LET l_sql = "SELECT SUM(abb07)   FROM abb_file,aba_file,aag_file ",    
               " WHERE abb00 = '",tm.b,"' ",
               "   AND aag00 = '",tm.b,"' ",
               "   AND aba00 = abb00 AND aba01 = abb01 ",
               "   AND abb03 BETWEEN ? AND ? ",
               "   AND aba06 = 'CE' AND abb06 = '2' AND aba03 = '",tm.yy,"' ",
               "   AND aba04 BETWEEN '",tm.bm,"' AND ? ",
               "   AND abapost = 'Y' ",
               "   AND abb03 = aag01 ",
               "   AND aag03 <> '4' "
   PREPARE r115_prepare4 FROM l_sql
   DECLARE r115_c4  CURSOR FOR r115_prepare4
   #FUN-C50004 add end 
   #CALL cl_outnam('aglg115') RETURNING l_name        #No.FUN-780058
   #START REPORT r115_rep TO l_name                   #No.FUN-780058
 
   FOREACH r115_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      FOR i = 1 TO 12
         LET bal[i] = 0
      END FOR
 
      FOR i = 1 TO tm.em
         LET amt = 0
         IF NOT cl_null(maj.maj21) THEN
            IF tm.rtype='1' THEN
               LET tm.bm = 0
            ELSE
               LET tm.bm = i
            END IF
#No.MOD-A40135 --begin                                                          
            IF maj.maj06 NOT MATCHES '[12345]' THEN CONTINUE FOREACH END IF     
                                                                                
            IF maj.maj06='4' THEN      ## 借方金额                              
               IF maj.maj24 IS NULL THEN                                        
                  SELECT SUM(aah04) INTO amt                                    
                    FROM aah_file,aag_file                                      
                   WHERE aah00 = tm.b                                           
                     AND aah00 = aag00      #No:FUN-740020                      
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aah02 = tm.yy                                          
                     AND aah03 BETWEEN tm.bm AND i                              
                     AND aah01 = aag01                                          
                    #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                     AND aag07 IN ('2','3')                   #TQC-AB0066
               ELSE                                                             
                  SELECT SUM(aao05) INTO amt                                    
                    FROM aao_file,aag_file                                      
                   WHERE aao00 = tm.b                                           
                     AND aao00 = aag00       #No:FUN-740020                     
                     AND aao01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aao02 BETWEEN maj.maj24 AND maj.maj25                  
                     AND aao03 = tm.yy                                          
                     AND aao04 BETWEEN tm.bm AND i                              
                     AND aao01 = aag01                                          
                    #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                     AND aag07 IN ('2','3')                   #TQC-AB0066
               END IF                                                           
            END IF
            IF maj.maj06='5' THEN      ## 贷方金额                              
               IF maj.maj24 IS NULL THEN                                        
                  SELECT SUM(aah05) INTO amt                                    
                    FROM aah_file,aag_file                                      
                   WHERE aah00 = tm.b                                           
                     AND aah00 = aag00      #No:FUN-740020                      
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aah02 = tm.yy                                          
                     AND aah03 BETWEEN tm.bm AND i                              
                     AND aah01 = aag01                                          
                    #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                     AND aag07 IN ('2','3')                   #TQC-AB0066
               ELSE                                                             
                  SELECT SUM(aao06) INTO amt                                    
                    FROM aao_file,aag_file                                      
                   WHERE aao00 = tm.b                                           
                     AND aao00 = aag00       #No:FUN-740020                     
                     AND aao01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aao02 BETWEEN maj.maj24 AND maj.maj25                  
                     AND aao03 = tm.yy                                          
                     AND aao04 BETWEEN tm.bm AND i                              
                     AND aao01 = aag01                                          
                    #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                     AND aag07 IN ('2','3')                   #TQC-AB0066
               END IF  
            END IF                                                              
                                                                                
                                                                                
            IF maj.maj06<'4' THEN     #No.FUN-570087  --add                     
               IF maj.maj24 IS NULL THEN                                        
                  SELECT SUM(aah04-aah05) INTO amt                              
                    FROM aah_file,aag_file                                      
                   WHERE aah00 = tm.b                                           
                     AND aah00 = aag00      #No:FUN-740020                      
                     AND aah01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aah02 = tm.yy                                          
                     AND aah03 BETWEEN tm.bm AND i                              
                     AND aah01 = aag01                                          
                    #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                     AND aag07 IN ('2','3')                   #TQC-AB0066
               ELSE                                                             
                  SELECT SUM(aao05-aao06) INTO amt                              
                    FROM aao_file,aag_file                                      
                   WHERE aao00 = tm.b                                           
                     AND aao00 = aag00       #No:FUN-740020                     
                     AND aao01 BETWEEN maj.maj21 AND maj.maj22                  
                     AND aao02 BETWEEN maj.maj24 AND maj.maj25                  
                     AND aao03 = tm.yy                                          
                     AND aao04 BETWEEN tm.bm AND i
                     AND aao01 = aag01                                          
                    #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                     AND aag07 IN ('2','3')                   #TQC-AB0066
               END IF                                                           
               IF maj.maj06 ='3' THEN                                           
                  IF maj.maj24 IS NULL THEN                                     
                     SELECT SUM(aah04-aah05) INTO amt                           
                       FROM aah_file,aag_file                                   
                      WHERE aah00 = tm.b                                        
                        AND aah00 = aag00      #No:FUN-740020                   
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aah02 = tm.yy                                       
                       #AND aah03 <=tm.em                           #MOD-AB0181 mark
                        AND aah03 <=i                               #MOD-AB0181
                        AND aah01 = aag01                                       
                       #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                        AND aag07 IN ('2','3')                   #TQC-AB0066
                  ELSE                                                          
                     SELECT SUM(aao05-aao06) INTO amt                           
                       FROM aao_file,aag_file                                   
                      WHERE aao00 = tm.b                                        
                        AND aao00 = aag00       #No:FUN-740020                  
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25               
                        AND aao03 = tm.yy                                       
                       #AND aao04 <=tm.em                           #MOD-AB0181 mark
                        AND aao04 <=i                               #MOD-AB0181
                        AND aao01 = aag01                                       
                       #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                        AND aag07 IN ('2','3')                   #TQC-AB0066
                  END IF                                                        
               END IF                                                           
               IF maj.maj06 ='1' THEN                                           
                  IF maj.maj24 IS NULL THEN                                     
                     SELECT SUM(aah04-aah05) INTO amt                           
                       FROM aah_file,aag_file                                   
                      WHERE aah00 = tm.b                                        
                        AND aah00 = aag00      #No:FUN-740020                   
                        AND aah01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aah02 = tm.yy                                       
                       #AND aah03 <= i                           #FUN-B80161 mark
                        AND aah03 < tm.bm                        #FUN-B80161 add
                        AND aah01 = aag01                                       
                       #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                        AND aag07 IN ('2','3')                   #TQC-AB0066
                  ELSE                                                          
                     SELECT SUM(aao05-aao06) INTO amt                           
                       FROM aao_file,aag_file                                   
                      WHERE aao00 = tm.b                                        
                        AND aao00 = aag00       #No:FUN-740020                  
                        AND aao01 BETWEEN maj.maj21 AND maj.maj22               
                        AND aao02 BETWEEN maj.maj24 AND maj.maj25               
                        AND aao03 = tm.yy
                       #AND aao04 <= i                           #FUN-B80161 mark
                        AND aao04 < tm.bm                        #FUN-B80161 add
                        AND aao01 = aag01                                       
                       #AND aag07 MATCHES '[23]'                 #TQC-AB0066 mark  
                        AND aag07 IN ('2','3')                   #TQC-AB0066
                  END IF                                                        
               END IF                                                           
            END IF   
#            IF maj.maj24 IS NULL THEN
#               SELECT SUM(aah04-aah05) INTO amt
#                 FROM aah_file,aag_file
#                WHERE aah00 = tm.b
#                  AND aah00 = aag00      #No.FUN-740020
#                  AND aah01 BETWEEN maj.maj21 AND maj.maj22
#                  AND aah02 = tm.yy
#                  AND aah03 BETWEEN tm.bm AND i
#                  AND aah01 = aag01
#                  AND aag07 IN ('2','3')
#            ELSE
#               SELECT SUM(aao05-aao06) INTO amt
#                 FROM aao_file,aag_file
#                WHERE aao00 = tm.b
#                  AND aao00 = aag00       #No.FUN-740020 
#                  AND aao01 BETWEEN maj.maj21 AND maj.maj22
#                  AND aao02 BETWEEN maj.maj24 AND maj.maj25
#                  AND aao03 = tm.yy
#                  AND aao04 BETWEEN tm.bm AND i
#                  AND aao01 = aag01
#                  AND aag07 IN ('2','3')
#            END IF
#No.MOD-A40135 --end
 
            IF STATUS THEN 
               CALL cl_err('sel aah1:',STATUS,1)
               EXIT FOREACH 
            END IF
 
            IF amt IS NULL THEN LET amt = 0 END IF
 
           #str MOD-930148 add
            LET g_aaa09 = ''
            SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b
            IF g_aaa09 = '2' THEN   #帳結法
#No.FUN-A10098 ----mark start
#               LET l_sql = "SELECT SUM(abb07)",
#                           "  FROM ",l_dbs CLIPPED," abb_file,",
#                                     l_dbs CLIPPED," aba_file,",
#                                     l_dbs CLIPPED," aag_file ",
#No.FUN-A10098 ----mark end
              #FUN-C50004 mark sta---
              # LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",    #No.FUN-A10098 ----add
              #             " WHERE abb00 = '",tm.b,"' ",
              #             "   AND aag00 = '",tm.b,"' ",
              #             "   AND aba00 = abb00 AND aba01 = abb01 ",
              #             "   AND abb03 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
              #             "   AND aba06 = 'CE' AND abb06 = '1' AND aba03 = '",tm.yy,"' ",
              #             "   AND aba04 BETWEEN '",tm.bm,"' AND '",i,"' ",
              #             "   AND abapost = 'Y' ",
              #             "   AND abb03 = aag01 ",
              #             "   AND aag03 <> '4' "
              # PREPARE r115_prepare3 FROM l_sql
              # DECLARE r115_c3  CURSOR FOR r115_prepare3
              # OPEN r115_c3
              #FUN-C50004 mark end
              OPEN r115_c3 USING maj.maj21,maj.maj22,i #FUN-C50004 add
               FETCH r115_c3 INTO l_endy1
#No.FUN-A10098 ----mark start
#               LET l_sql = "SELECT SUM(abb07)",
#                           "  FROM ",l_dbs CLIPPED," abb_file,",
#                                     l_dbs CLIPPED," aba_file,",
#                                     l_dbs CLIPPED," aag_file ",
#No.FUN-A10098 ----mark end
                #FUN-C50004 mark sta
                #LET l_sql = "SELECT SUM(abb07)   FROM abb_file,aba_file,aag_file ",    #No.FUN-A10098 ----add
                #           " WHERE abb00 = '",tm.b,"' ",
                #           "   AND aag00 = '",tm.b,"' ",
                #           "   AND aba00 = abb00 AND aba01 = abb01 ",
                #           "   AND abb03 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
                #           "   AND aba06 = 'CE' AND abb06 = '2' AND aba03 = '",tm.yy,"' ",
                #           "   AND aba04 BETWEEN '",tm.bm,"' AND '",i,"' ",
                #           "   AND abapost = 'Y' ",
                #           "   AND abb03 = aag01 ",
                #           "   AND aag03 <> '4' "
               #PREPARE r115_prepare4 FROM l_sql
               #DECLARE r115_c4  CURSOR FOR r115_prepare4
               #OPEN r115_c4
               #FUN-C50004 mark end
               OPEN r115_c4 USING maj.maj21,maj.maj22,i #FUN-C50004 add
               FETCH r115_c4 INTO l_endy2
               IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
               IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
               LET amt = amt - (l_endy1 - l_endy2)
            END IF
           #end MOD-930148 add
         END IF
 
         IF tm.o = 'Y' THEN   #匯率的轉換
            LET amt = amt * tm.q 
         END IF
 
         IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN     #合計階數處理
            FOR j=1 TO 100
              #CHI-A70050---modify---start---
              #LET g_tot[j,i] = g_tot[j,i] + amt
               IF maj.maj09 = '-' THEN
                  LET g_tot[j,i] = g_tot[j,i] - amt
               ELSE
                  LET g_tot[j,i] = g_tot[j,i] + amt
               END IF
              #CHI-A70050---modify---end---
            END FOR
            LET k = maj.maj08
            LET bal[i] = g_tot[k,i]
           #CHI-A70050---add---start---
            IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
               LET bal[i] = bal[i] *-1
            END IF
           #CHI-A70050---add---end---
            FOR j = 1 TO maj.maj08 
               LET g_tot[j,i] = 0
            END FOR
         ELSE 
            IF maj.maj03='5' THEN
               LET bal[i]=amt
            ELSE
               LET bal[i]=0
            END IF
         END IF
 
         IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
            LET g_basetot[i] = bal[i]
            IF maj.maj07 = '2' THEN 
               LET g_basetot[i] = g_basetot[i] * -1
            END IF
            IF g_basetot[i] = 0 THEN
               LET g_basetot[i] = NULL
            END IF
         END IF
 
        #FUN-B80161--mark--str
        #IF maj.maj08 = 0 THEN
        #   #LET bal[i] = NULL    #MOD-6B0087
        #   LET bal[i] = 0    #MOD-6B0087
        #END IF
        #FUN-B80161--mark--end        
 
        #str MOD-870140 add
         IF maj.maj03 = 'H' THEN
            LET bal[i] = NULL
         END IF
        #end MOD-870140 add
      END FOR
 
      IF maj.maj03 = '0' THEN
         CONTINUE FOREACH 
      END IF #本行不印出
 
     #IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[012]"    #MOD-880120 mark
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]"   #MOD-880120
         AND bal[1]=0 AND bal[2]=0 AND bal[3]=0 AND bal[4]=0
         AND bal[5]=0 AND bal[6]=0 AND bal[7]=0 AND bal[8]=0
         AND bal[9]=0 AND bal[10]=0 AND bal[11]=0 AND bal[12]=0 THEN
         CONTINUE FOREACH                        #餘額為 0 者不列印
      END IF
 
      IF tm.f > 0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        #最小階數起列印
      END IF
 
      IF maj.maj06 NOT MATCHES "[13]" THEN                                           #FUN-B80161 add
         LET sr.bal13=bal[1]+bal[2]+bal[3]+bal[4]+bal[5]+bal[6]+   #MOD-B60201 mark  #FUN-B80161 remark
                      bal[7]+bal[8]+bal[9]+bal[10]+bal[11]+bal[12] #MOD-B60201 mark  #FUN-B80161 remark
      ELSE                                                         #FUN-B80161 add
         LET sr.bal13=bal[tm.em]    #MOD-B60201  #MOD-B70132 mod 12 -> tm.em
      END IF                                                       #FUN-B80161 add
 
      IF tm.rtype = '1' THEN
         #LET sr.bal13 = NULL
         LET sr.bal13 = 0   #NO.MOD-5B0190
      END IF
 
      FOR i = tm.em + 1 TO 12 
         #LET bal[i] = NULL
         LET bal[i] = 0 #NO.MOD-5B0190
      END FOR
 
      LET sr.bal01=bal[1]
      LET sr.bal02=bal[2]
      LET sr.bal03=bal[3]
      LET sr.bal04=bal[4]
      LET sr.bal05=bal[5]
      LET sr.bal06=bal[6]
      LET sr.bal07=bal[7]
      LET sr.bal08=bal[8]
      LET sr.bal09=bal[9]
      LET sr.bal10=bal[10]
      LET sr.bal11=bal[11]
      LET sr.bal12=bal[12]
 
      #No.FUN-780058---Begin
      IF maj.maj07='2' THEN                                                  
         LET sr.bal01 = sr.bal01 * -1                                        
         LET sr.bal02 = sr.bal02 * -1                                        
         LET sr.bal03 = sr.bal03 * -1                                        
         LET sr.bal04 = sr.bal04 * -1                                        
         LET sr.bal05 = sr.bal05 * -1                                        
         LET sr.bal06 = sr.bal06 * -1                                        
         LET sr.bal07 = sr.bal07 * -1                                        
         LET sr.bal08 = sr.bal08 * -1                                        
         LET sr.bal09 = sr.bal09 * -1                                        
         LET sr.bal10 = sr.bal10 * -1                                        
         LET sr.bal11 = sr.bal11 * -1                                        
         LET sr.bal12 = sr.bal12 * -1                                        
         LET sr.bal13 = sr.bal13 * -1                                        
      END IF                                                                 
                                                                                
      IF tm.h='Y' THEN                                                       
         LET maj.maj20 = maj.maj20e                                          
      END IF
 
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20
 
      LET sr.bal01=sr.bal01/g_unit                                       
      LET sr.bal02=sr.bal02/g_unit                                       
      LET sr.bal03=sr.bal03/g_unit                                       
      LET sr.bal04=sr.bal04/g_unit                                       
      LET sr.bal05=sr.bal05/g_unit                                       
      LET sr.bal06=sr.bal06/g_unit                                       
      LET sr.bal07=sr.bal07/g_unit                                       
      LET sr.bal08=sr.bal08/g_unit                                       
      LET sr.bal09=sr.bal09/g_unit                                       
      LET sr.bal10=sr.bal10/g_unit                                       
      LET sr.bal11=sr.bal11/g_unit                                       
      LET sr.bal12=sr.bal12/g_unit                                       
      LET sr.bal13=sr.bal13/g_unit 
 
      IF maj.maj04 = 0 THEN                                                     
         EXECUTE insert_prep USING                                              
            maj.maj31,  #FUN-B80161 FROM FUN-B90140 add maj31
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                           
            sr.bal01,sr.bal02,sr.bal03,sr.bal04,                           
            sr.bal05,sr.bal06,sr.bal07,sr.bal08,
            sr.bal09,sr.bal10,sr.bal11,sr.bal12,
            sr.bal13,    
            '2'                                                                 
      ELSE                                                                      
         EXECUTE insert_prep USING                                              
            maj.maj31,  #FUN-B80161 FROM FUN-B90140 add maj31
            maj.maj20,maj.maj20e,maj.maj02,maj.maj03,                           
            sr.bal01,sr.bal02,sr.bal03,sr.bal04,                                
            sr.bal05,sr.bal06,sr.bal07,sr.bal08,                                
            sr.bal09,sr.bal10,sr.bal11,sr.bal12,                                
            sr.bal13,  
            '2'                                                                 
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
         #讓空行的這筆資料排在正常的資料前面印出                                
         FOR i = 1 TO maj.maj04                                                 
            EXECUTE insert_prep USING                                           
               maj.maj31,  #FUN-B80161 FROM FUN-B90140 add maj31
               maj.maj20,maj.maj20e,maj.maj02,'',                               
               '0','0','0','0',                                                 
               '0','0','0','0',                                                 
               '0','0','0','0',                                                 
               '0',                                                 
               '1'                                                              
         END FOR                                                                
      END IF                                                       
      #OUTPUT TO REPORT r115_rep(maj.*, sr.*)
      #NO.FUN-780058---End
   END FOREACH
 
   #No.FUN-780058---Begin
   #FINISH REPORT r115_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   IF tm.rtype = "1" THEN                                                       
#     LET l_name = 'aglg115_1'      #FUN-B80161 mark
      LET g_template = 'aglg115_1'  #FUN-B80161 add
      CALL aglg115_grdata()         #FUN-B80161 add                                                 
   ELSE                                                                         
#     LET l_name = 'aglg115'        #FUN-B80161 mark  
      LET g_template = 'aglg115'    #FUN-B80161 add                                                
      CALL aglg115_grdata()         #FUN-B80161 add                                                 
   END IF 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",
###GENGRE###               tm.rtype,";",tm.e,";",tm.acc_code   #FUN-B80161 FROM FUN-B90140   Add tm.acc_code     
###GENGRE###   CALL cl_prt_cs3('aglg115',l_name,g_sql,g_str)
   #No.FUN-780058---End
END FUNCTION
 
#No.FUN-780058---Begin
#REPORT r115_rep(maj, sr)
#  DEFINE l_last_sw  LIKE type_file.chr1        #No.FUN-680098   VARCHAR(1)
#  DEFINE l_unit     LIKE zaa_file.zaa08        #No.FUN-680098   VARCHAR(4) 
#  DEFINE maj          RECORD LIKE maj_file.*
#  DEFINE sr           RECORD
#                         bal01,bal02,bal03,bal04,bal05,bal06,
#                         bal07,bal08,bal09,bal10,bal11,bal12,
#                         bal13     LIKE aah_file.aah04
#                      END RECORD
#  DEFINE g_head1     STRING
 
#  OUTPUT
#     TOP MARGIN g_top_margin 
#     LEFT MARGIN g_left_margin 
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY maj.maj02
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        LET g_x[1] = g_mai02
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED  #No.TQC-6A0093
#  #No.TQC-5C0037 start
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#  #No.TQC-5C0037 end
 
#    
#        #金額單位之列印
#        CASE tm.d
#             WHEN '1'  LET l_unit = g_x[13]
#             WHEN '2'  LET l_unit = g_x[14]
#             WHEN '3'  LET l_unit = g_x[15]
#             OTHERWISE LET l_unit = ' '
#        END CASE
#        LET g_head1 = g_x[9]  CLIPPED,tm.a CLIPPED,'     ', #No.TQC-6A0093
#                      g_x[12] CLIPPED,tm.p CLIPPED,'     ', #No.TQC-6A0093
#                      g_x[11] CLIPPED,l_unit CLIPPED        #No.TQC-6A0093
#        PRINT g_head1 CLIPPED
#        LET g_head1 = g_x[10] CLIPPED,tm.yy USING '&&&&'
#        PRINT g_head1 CLIPPED
#        PRINT g_dash[1,g_len]
#        IF tm.rtype = '1' THEN
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#                 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#        ELSE
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#                 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#        END IF
#        PRINT g_dash1 CLIPPED  #No.TQC-6A0093
#        LET l_last_sw = 'n'
#    
#     ON EVERY ROW
#        IF maj.maj07='2' THEN
#           LET sr.bal01 = sr.bal01 * -1
#           LET sr.bal02 = sr.bal02 * -1
#           LET sr.bal03 = sr.bal03 * -1
#           LET sr.bal04 = sr.bal04 * -1
#           LET sr.bal05 = sr.bal05 * -1
#           LET sr.bal06 = sr.bal06 * -1
#           LET sr.bal07 = sr.bal07 * -1
#           LET sr.bal08 = sr.bal08 * -1
#           LET sr.bal09 = sr.bal09 * -1
#           LET sr.bal10 = sr.bal10 * -1
#           LET sr.bal11 = sr.bal11 * -1
#           LET sr.bal12 = sr.bal12 * -1
#           LET sr.bal13 = sr.bal13 * -1
#        END IF
 
#        IF tm.h='Y' THEN
#           LET maj.maj20 = maj.maj20e 
#        END IF
 
#        CASE
#           WHEN maj.maj03 = '9'
#              SKIP TO TOP OF PAGE
#           WHEN maj.maj03 = '3'
#              PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
#                    COLUMN g_c[33],g_dash2[1,g_w[33]],
#                    COLUMN g_c[34],g_dash2[1,g_w[34]],
#                    COLUMN g_c[35],g_dash2[1,g_w[35]],
#                    COLUMN g_c[36],g_dash2[1,g_w[36]],
#                    COLUMN g_c[37],g_dash2[1,g_w[37]],
#                    COLUMN g_c[38],g_dash2[1,g_w[38]],
#                    COLUMN g_c[39],g_dash2[1,g_w[39]],
#                    COLUMN g_c[40],g_dash2[1,g_w[40]],
#                    COLUMN g_c[41],g_dash2[1,g_w[41]],
#                    COLUMN g_c[42],g_dash2[1,g_w[42]],
#                    COLUMN g_c[43],g_dash2[1,g_w[43]];
#              #NO.MOD-5B0190 START-----
#              IF tm.rtype = '2' THEN
#                  PRINT COLUMN g_c[44],g_dash2[1,g_w[44]]
#              ELSE
#                  PRINT
#              END IF
#              #NO.MOD-5B0190 END-------
#           WHEN maj.maj03 = '4'
#              PRINT g_dash2 CLIPPED  #No.TQC-6A0093
#           OTHERWISE
#              FOR i = 1 TO maj.maj04
#                 PRINT
#              END FOR
#              LET maj.maj20 = maj.maj05 SPACES,maj.maj20
#              PRINT COLUMN g_c[31],maj.maj20 CLIPPED,  #No.TQC-6A0093
#                    COLUMN g_c[32],cl_numfor(sr.bal01/g_unit,32,tm.e),
#                    COLUMN g_c[33],cl_numfor(sr.bal02/g_unit,33,tm.e),
#                    COLUMN g_c[34],cl_numfor(sr.bal03/g_unit,34,tm.e),
#                    COLUMN g_c[35],cl_numfor(sr.bal04/g_unit,35,tm.e),
#                    COLUMN g_c[36],cl_numfor(sr.bal05/g_unit,36,tm.e),
#                    COLUMN g_c[37],cl_numfor(sr.bal06/g_unit,37,tm.e),
#                    COLUMN g_c[38],cl_numfor(sr.bal07/g_unit,38,tm.e),
#                    COLUMN g_c[39],cl_numfor(sr.bal08/g_unit,39,tm.e),
#                    COLUMN g_c[40],cl_numfor(sr.bal09/g_unit,40,tm.e),
#                    COLUMN g_c[41],cl_numfor(sr.bal10/g_unit,41,tm.e),
#                    COLUMN g_c[42],cl_numfor(sr.bal11/g_unit,42,tm.e),
#                    COLUMN g_c[43],cl_numfor(sr.bal12/g_unit,43,tm.e);
#              #NO.MOD-5B0190 START-------
#              IF tm.rtype = '2' THEN
#                  PRINT COLUMN g_c[44],cl_numfor(sr.bal13/g_unit,44,tm.e)
#              ELSE
#                  PRINT
#              END IF
#              #NO.MOD-5B0190 END-------
#        END CASE
#    
#     ON LAST ROW
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-6A0093
#        LET l_last_sw = 'y'
#    
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-6A0093
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#No.FUN-780058---End

###GENGRE###START
FUNCTION aglg115_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg115")
        IF handler IS NOT NULL THEN
            START REPORT aglg115_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY maj02"   #FUN-B80161
          
            DECLARE aglg115_datacur1 CURSOR FROM l_sql
            FOREACH aglg115_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg115_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg115_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg115_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80161---add---str----------
    DEFINE l_unit      STRING     
    DEFINE l_yy        STRING      
    DEFINE l_bal_fmt   STRING       
    #FUN-B80161---add---end----------
       
 
    ORDER EXTERNAL BY sr1.maj02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name    #FUN-B80161 add g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.maj02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
           
            #FUN-B80161---add---str------------   
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d) 
            PRINTX l_unit                                   
            
            LET l_yy = tm.yy
            LET l_yy = l_yy.trimleft()
            PRINTX l_yy

            LET l_bal_fmt = cl_gr_numfmt('aah_file','aah04',tm.e)
            PRINTX l_bal_fmt
            #FUN-B80161---add---end------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.maj02

        
        ON LAST ROW

END REPORT
###GENGRE###END

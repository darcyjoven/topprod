# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg930.4gl
# Descriptions...: 部門全年度預算明細表列印作業
# Date & Author..: 96/01/24  By  Grace
# Modify.........: No.FUN-510007 05/02/23 By Nicola 報表架構修改
# Modify.........: No.MOD-570228 05/08/05 By Smapmin SQL語法錯誤
# Modify.........: No.FUN-5A0125 05/10/21 By Smapmin 輸入不存在的抬頭代號時,error message錯誤.
#　　　　　　　　　　　　　　　　　　　　　　　　　　檢核部門是否存在.
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/25 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/10 By bnlent 會計科目加帳套
# Modify.........: NO.MOD-740226 07/04/22 BY yiting 輸入完QBE條件後 無法輸入條件選項 程式會直接跑報表
# Modify.........: No.FUN-810069 08/02/26 By douzh項目預算增加key
# Modify.........: No.FUN-830139 08/04/02 By douzh項目預算去掉預算編號
# Modify.........: No.TQC-840049 08/04/02 By douzh項目預算打印無資料
# Modify.........: No.FUN-830100 08/04/07 By mike 報表輸出方式轉為Crystal Reports 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額
# Modify.........: No:CHI-A20019 10/02/25 By sabrina 取消9046錯誤訊息。QBE條件可以空白(1=1)
# Modify.........: No:FUN-AB0020 10/11/05 By chenying 畫面上新增預算項目afc01
# Modify.........: No:FUN-B80158 11/09/13 By yangtt 明細類CR轉換成GRW
 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE g_wc string  #No.FUN-580092 HCN
   DEFINE tm  RECORD
              s        LIKE type_file.chr2,       # Prog. Version..: '5.30.06-13.03.12(02)  #NO.MOD-740226
              t        LIKE type_file.chr2,       #No.FUN-680098   VARCHAR(02) 
              bookno   LIKE aaa_file.aaa01,       #No.FUN-740020   
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              yy      LIKE afc_file.afc03,         #No.FUN-680098 SMALLINT
              afc01   LIKE afc_file.afc01,         #FUN-AB0020 
#             h       LIKE afa_file.afa01,         #No.FUN-680098 VARCHAR(4)    #No.FUN-830139
              dept    LIKE gem_file.gem01,         #No.FUN-680098CHAR(10),          #部門
              choice  LIKE type_file.chr1,         #異動額及餘額為零者是否列印 #No.FUN-680098 VARCHAR(1)
              dec     LIKE type_file.chr1,         #金額單位(1)元(2)千(3)百萬  #No.FUN-680098 VARCHAR(1)
              detail  LIKE type_file.chr1,         #(1)科目明細  (2)分類彙總   #No.FUN-680098  VARCHAR(1)
              k       LIKE type_file.chr1,         #FUN-6C0012
              more    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
              END RECORD
   DEFINE g_orderA       ARRAY[2] OF LIKE type_file.chr20     #No.FUN-680098  VARCHAR(10)
   DEFINE g_bookno       LIKE aaa_file.aaa01   #No.FUN-670039
   DEFINE g_base         LIKE type_file.num10  #No.FUN-680098  integer
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5  #count/index for any purpose #No.FUN-680098smallint
DEFINE   g_msg           LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(72)
DEFINE   l_table         STRING                   #No.FUN-830100                                                                    
DEFINE   g_sql           STRING                   #No.FUN-830100                                                                    
DEFINE   g_sql1          STRING                   #No.FUN-B80158                                                                    
DEFINE   g_sql2          STRING                   #No.FUN-B80158                                                                    
DEFINE   g_str           STRING                   #No.FUN-830100  
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE aae_file.aae01,
    order2 LIKE aae_file.aae01,
    order3 LIKE aag_file.aag01,
    aag01 LIKE aag_file.aag01,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    aag223 LIKE aag_file.aag223,
    aag224 LIKE aag_file.aag224,
    aag225 LIKE aag_file.aag225,
    aag226 LIKE aag_file.aag226,
    mm LIKE type_file.num5,
    amt LIKE aah_file.aah04,
    g_msg LIKE type_file.chr1000,
    l_aae02 LIKE aae_file.aae02,
    t_azi05 LIKE azi_file.azi05,
    ll_aae02 LIKE aae_file.aae02,
    #FUN-B80158-----add----str------
    amt1   LIKE aah_file.aah04,
    amt2   LIKE aah_file.aah04,
    amt3   LIKE aah_file.aah04,
    amt4   LIKE aah_file.aah04,
    amt5   LIKE aah_file.aah04,
    amt6   LIKE aah_file.aah04,
    amt7   LIKE aah_file.aah04,
    amt8   LIKE aah_file.aah04,
    amt9   LIKE aah_file.aah04,
    amt10  LIKE aah_file.aah04,
    amt11  LIKE aah_file.aah04,
    amt12  LIKE aah_file.aah04
    #FUN-B80158-----add----end------
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
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#No.FUN-830100  --BEGIN                                                                                                             
   LET g_sql = "order1.aae_file.aae01,",                                                                                            
               "order2.aae_file.aae01,",                                                                                            
               "order3.aag_file.aag01,",                                                                                            
               "aag01.aag_file.aag01,",                                                                                             
               "aag02.aag_file.aag02,",                                                                                             
               "aag13.aag_file.aag13,",                                                                                             
               "aag223.aag_file.aag223,",                                                                                           
               "aag224.aag_file.aag224,",                                                                                           
               "aag225.aag_file.aag225,",                                                                                           
               "aag226.aag_file.aag226,",                                                                                           
               "mm.type_file.num5,",                                                                                                
               "amt.aah_file.aah04,",                                                                                               
               "g_msg.type_file.chr1000,",                                                                                          
               "l_aae02.aae_file.aae02,",                                                                                           
               "t_azi05.azi_file.azi05,",                                                                                           
               "ll_aae02.aae_file.aae02,",                                                                                            
               #FUN-B80158-----add----str------
               "amt1.aah_file.aah04,",
               "amt2.aah_file.aah04,",
               "amt3.aah_file.aah04,",
               "amt4.aah_file.aah04,",
               "amt5.aah_file.aah04,",
               "amt6.aah_file.aah04,",
               "amt7.aah_file.aah04,",
               "amt8.aah_file.aah04,",
               "amt9.aah_file.aah04,",
               "amt10.aah_file.aah04,",
               "amt11.aah_file.aah04,",
               "amt12.aah_file.aah04"
               #FUN-B80158-----add----end------
   LET l_table = cl_prt_temptable("aglg930",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"    #FUN-B80158 add 12 ?                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM    
   END IF                                                                                                                           
#No.FUN-830100  --END 
   LET tm.bookno= ARG_VAL(1)   #No.FUN-740020
   LET g_pdate = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET g_wc  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.yy = ARG_VAL(11)
   LET tm.afc01  = ARG_VAL(12)    #FUN-AB0020
#  LET tm.h  = ARG_VAL(12)    #No.FUN-830139
   LET tm.dept  = ARG_VAL(13)
   LET tm.choice  = ARG_VAL(14)
   LET tm.dec = ARG_VAL(15)
   LET tm.detail  = ARG_VAL(16)
   LET tm.azh01 = ARG_VAL(17)   #TQC-610056
   LET tm.azh02 = ARG_VAL(18)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   #No.FUN-570264 ---end---
   #No.FUN-740020  --Begin
   #IF cl_null(g_bookno) THEN
   #   LET g_bookno = g_aaz.aaz64
   #END IF
   IF cl_null(tm.bookno) THEN  LET tm.bookno = g_aza.aza81  END IF  
   #No.FUN-740020  --End
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g930_tm(0,0)
      ELSE CALL g930()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION g930_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680098 smallint
          l_cmd       LIKE  type_file.chr1000, #No.FUN-680098 VARCHAR(400)
          l_cnt       LIKE  type_file.num5     #No.FUN-680098    #FUN-5A0125 smallint
DEFINE l_azfacti     LIKE azf_file.azfacti     #FUN-AB0020  

   IF p_row = 0 THEN LET p_row = 4 LET p_col = 4 END IF
   CALL s_dsmark(tm.bookno)   #No.FUN-740020
   LET p_row = 2 LET p_col = 16
   OPEN WINDOW g930_w AT p_row,p_col
     WITH FORM "agl/42f/aglg930"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,tm.bookno)  #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   #使用預設帳別之幣別
   IF cl_null(tm.bookno) THEN  LET tm.bookno = g_aza.aza81  END IF     #No.FUN-740020 
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno     #No.FUN-740020
   IF SQLCA.sqlcode THEN
# 	  CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","",0)       # NO.FUN-660123  #No.FUN-740020
    END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = g_aaa03    #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN 
#      CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)       # NO.FUN-660123
   END IF
   IF cl_null(tm.bookno) THEN  LET tm.bookno = g_aza.aza81  END IF  #No.FUN-740020
   LET tm.s    = '12'
   LET tm.choice = 'N'
   LET tm.k    = 'N'  #FUN-6C0012
   LET tm.dec    = 2
   LET tm.detail = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_base   = 1
    #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME  g_wc ON aag223,aag224,aag225,aag226
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW g930_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
  #IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF    #CHI-A20019 mark
 
   DISPLAY BY NAME tm.k,tm.more  #FUN-6C0012
#  INPUT BY NAME tm.bookno,tm.azh01,tm.azh02,tm.yy,tm.h,tm.dept,   #No.FUN-740020  #No.FUN-830139
   INPUT BY NAME tm.bookno,tm.azh01,tm.azh02,tm.yy,tm.afc01,tm.dept,        #No.FUN-830139 #FUN-AB0020 add tm.afc01
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.dec,tm.detail,
                 tm.choice,tm.k,tm.more  #FUN-6C0012
                  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD azh01
           IF NOT cl_null(tm.azh01) THEN
              SELECT azh02
                 INTO tm.azh02
                 FROM azh_file
                 WHERE azh01 = tm.azh01
                      IF SQLCA.SQLCODE = 100 THEN
#                          CALL cl_err(tm.azh01,'mfg9307',1)    #FUN-5A0125   
#                        CALL cl_err(tm.azh01,'mfg9207',1)    #No.FUN-660123
                         CALL cl_err3("sel","azh_file",tm.azh01,"","mfg9207","","",1)   #No.FUN-660123
                         NEXT FIELD azh01
                      END IF
           END IF
         AFTER FIELD yy
           IF tm.yy <= 1911 OR cl_null(tm.yy) THEN
              NEXT FIELD yy
           END IF
 
#No.FUN-830139--begin
#        AFTER FIELD h
#           IF tm.h IS NULL THEN NEXT FIELD h END IF
## No:2578 modify 1998/10/21 ----------------
#           SELECT afa01 FROM afa_file
#            WHERE afa00 = g_bookno AND afa01 = tm.h
#            WHERE afa01 = tm.h AND afa00 = tm.bookno     #No.FUN-740020
## -
#           IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.h,'agl-005',0)   #No.FUN-660123
#              CALL cl_err3("sel","afa_file",tm.h,"","agl-005","","",0)   #No.FUN-660123
#              NEXT FIELD h
#           END IF
#No.FUN-830139--end

#FUN-AB0020--------------add--------------str--------
      AFTER FIELD afc01
        IF NOT cl_null(tm.afc01) THEN
           SELECT azf01 FROM azf_file  
             WHERE azf01 = tm.afc01 AND azf02 = '2'
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
              NEXT FIELD afc01
           ELSE
              SELECT azfacti INTO l_azfacti FROM azf_file
               WHERE azf01 = tm.afc01 AND azf02 = '2'
              IF l_azfacti = 'N' THEN
                 CALL cl_err(tm.afc01,'agl1002',0)
              END IF
           END IF                 
        END IF
#FUN-AB0020--------------add-------------end-----------

 
         AFTER FIELD dept
            IF tm.dept IS NULL THEN NEXT FIELD dept END IF
#FUN-5A0125
            SELECT COUNT(*) INTO l_cnt FROM gem_file
               WHERE gem01= tm.dept
            IF l_cnt = 0 THEN CALL cl_err('','agl-003',0) NEXT FIELD dept END IF
#END FUN-5A0125
 
         AFTER FIELD choice
           IF tm.choice NOT MATCHES '[YN]' THEN
              NEXT FIELD choice
           END IF
         AFTER FIELD dec
           IF tm.dec NOT MATCHES '[123]' THEN NEXT FIELD dec END IF
           CASE tm.dec WHEN 1 LET g_base = 1
                       WHEN 2 LET g_base = 1000
                       WHEN 3 LET g_base = 1000000
                       OTHERWISE NEXT FIELD dec
           END CASE
         AFTER FIELD detail
           IF tm.detail NOT MATCHES '[12]' THEN
              NEXT FIELD detail
           END IF
          #FUN-6C0012.....begin
           IF tm.detail = '2' THEN                                              
              CALL cl_set_comp_entry("k",FALSE)                                 
              LET tm.k = 'N'                                                    
           ELSE                                                                 
              CALL cl_set_comp_entry("k",TRUE)                                  
              LET tm.k = 'N'                                                    
           END IF
          #FUN-6C0012.....end
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
         ON ACTION CONTROLP
           CASE
         #No.FUN-740020  --Begin
            WHEN INFIELD(bookno)                                                                                                       
              CALL cl_init_qry_var()                                                                                                 
              LET g_qryparam.form = 'q_aaa'                                                                                          
              LET g_qryparam.default1 = tm.bookno                                                                                     
              CALL cl_create_qry() RETURNING tm.bookno                                                                                
              DISPLAY BY NAME tm.bookno                                                                                               
              NEXT FIELD bookno 
         #No.FUN-740020  --End
            WHEN INFIELD(azh01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_azh'
                 LET g_qryparam.default1 = tm.azh01
                 LET g_qryparam.default2 = tm.azh02
                 CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
                 DISPLAY tm.azh01, tm.azh02 TO azh01, azh02
#No.FUN-830139--begin
#           WHEN INFIELD(h)
#                CALL cl_init_qry_var()
##               LET g_qryparam.form = 'q_afa'             #No.FUN-810069
#                LET g_qryparam.form = 'q_azf'             #No.FUN-810069
#                LET g_qryparam.default1 = tm.h
#                LET g_qryparam.arg1 = '2'                 #No.FUN-810069
#                CALL cl_create_qry() RETURNING tm.h
#                DISPLAY BY NAME tm.h
#                NEXT FIELD h
#No.FUN-830139--end
#FUN-AB0020------add------str---------
            WHEN INFIELD(afc01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_azf'      
                LET g_qryparam.default1 = tm.afc01 
                LET g_qryparam.arg1 = '2'          
                CALL cl_create_qry() RETURNING tm.afc01
                DISPLAY BY NAME tm.afc01
                NEXT FIELD afc01
#FUN-AB0020------add------end---------

              OTHERWISE EXIT CASE
           END CASE
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
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
      LET INT_FLAG = 0
      CLOSE WINDOW g930_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aglg930'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg930','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",tm.bookno CLIPPED,"'",   #No.FUN-740020
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.afc01 CLIPPED,"'",             #FUN-AB0020 
#                        " '",tm.h CLIPPED,"'",                 #No.FUN-830139 
                         " '",tm.dept CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.k CLIPPED,"'",   #FUN-6C0012
                         " '",tm.dec CLIPPED,"'",
                         " '",tm.detail CLIPPED,"'",
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.azh02 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglg930',g_time,l_cmd)
      END IF
      CLOSE WINDOW g930_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g930()
   ERROR ""
END WHILE
   CLOSE WINDOW g930_w
END FUNCTION
 
FUNCTION g930()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name  #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-680098 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680098  VARCHAR(1)
          l_order   ARRAY[2] OF LIKE aag_file.aag223,  #No.FUN-680098 VARCHAR(04)
          sr               RECORD
                                  order1 LIKE aae_file.aae01,  #No.FUN-680098 VARCHAR(04),
                                  order2 LIKE aae_file.aae01,  #No.FUN-680098 VARCHAR(04),
                                  order3 LIKE aag_file.aag01,  #No.FUN-680098 VARCHAR(20),
                                  aag01  LIKE aag_file.aag01,
                                  aag02  LIKE aag_file.aag02,
                                  aag13  LIKE aag_file.aag13,  #FUN-6C0012
                                  aag223 LIKE aag_file.aag223,
                                  aag224 LIKE aag_file.aag224,
                                  aag225 LIKE aag_file.aag225,
                                  aag226 LIKE aag_file.aag226,
                                  mm     LIKE type_file.num5,   #No.FUN-680098  SMALLINT
                                  amt    LIKE aah_file.aah04,
                                  #FUN-B80158----add-----str----
                                  amt1   LIKE aah_file.aah04,
                                  amt2   LIKE aah_file.aah04,
                                  amt3   LIKE aah_file.aah04,
                                  amt4   LIKE aah_file.aah04,
                                  amt5   LIKE aah_file.aah04,
                                  amt6   LIKE aah_file.aah04,
                                  amt7   LIKE aah_file.aah04,
                                  amt8   LIKE aah_file.aah04,
                                  amt9   LIKE aah_file.aah04,
                                  amt10  LIKE aah_file.aah04,
                                  amt11  LIKE aah_file.aah04,
                                  amt12  LIKE aah_file.aah04
                                  #FUN-B80158----add-----end----
                        END RECORD
     DEFINE ll_aae02 LIKE aae_file.aae02             #No.FUN-830100                                                                 
     DEFINE l_aae02 LIKE aae_file.aae02              #No.FUN-830100                                                                 
                                                                                                                                    
     CALL cl_del_data(l_table)                       #No.FUN-830100    
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno   #No.FUN-740020
                        AND aaf02 = g_rlang
 
     #資料權限的檢查
     #NO:8525 應改成afb
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET g_wc = g_wc clipped," AND afbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET g_wc = g_wc clipped," AND afbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET g_wc = g_wc clipped," AND afbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
     #End:FUN-980030
 
     #NO:8525 end
     LET l_sql = "SELECT '','','',aag01,aag02,aag13,",   #FUN-6C0012
                 "       aag223,aag224,aag225,aag226,",
                 "       afc05,afc06,0,0,0,0,0,0,0,0,0,0,0,0",      #FUN-B80158 add 12 0 
 #                 " FROM aag_file, afc_file ",   #NO:8525   #MOD-570228
                 " FROM aag_file, afc_file,afb_file ",   #NO:8525
                 " WHERE ",g_wc CLIPPED,
                 "   AND aag00 = afc00",              #No.FUN-740020
                 "   AND aag01 = afc02",
                 "   AND afc00 = '",tm.bookno,"'",    #No.FUN-740020
#                "   AND afc01 = '",tm.h,"'",         #No.FUN-830139
                 "   AND afc03 = ",tm.yy,
                #"   AND afc04 != '@'",               #MOD-9C0100 mark
                #"   AND afc04 MATCHES '",tm.dept CLIPPED,"'",   #MOD-570228
#                "   AND afc04 = '",tm.dept CLIPPED,"'",   #MOD-570228     #No.TQC-840049
                 "   AND afc041= '",tm.dept,"'",   #No.TQC-840049
                 "   AND afc05 != 0",
                 "   AND afbacti = 'Y' ",     #TQC-630238
                 "   AND afc00 = afb00 ",     #NO:8525
                 "   AND afc01 = afb01 ",     #NO:8525
                 "   AND afc02 = afb02 ",     #NO:8525
                 "   AND afc03 = afb03 ",     #NO:8525
                 "   AND afc041= afb041 ",    #No.FUN-810069
                 "   AND afc042= afb042 ",    #No.FUN-810069
                 "   AND afc04 = afb04 "      #NO:8525
           
#FUN-AB0020------add---------str------------------
     IF NOT cl_null(tm.afc01) THEN
        LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
     END IF     
#FUN-AB0020------add---------end------------------
     PREPARE g930_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
        EXIT PROGRAM
     END IF
     DECLARE g930_curs1 CURSOR FOR g930_prepare1
#    LET l_name = 'aglg930.out'
#No.FUN-830100  --BEGIN                                                                                                             
{               
     CALL cl_outnam('aglg930') RETURNING l_name
 
     #FUN-6C0012.....begin
     IF tm.k ='Y' THEN                                                          
        LET g_zaa[32].zaa06 ='Y'                                                
        LET g_zaa[46].zaa06 ='N'                                                
     ELSE                                                                       
        LET g_zaa[32].zaa06 ='N'                                                
        LET g_zaa[46].zaa06 ='Y'                                                
     END IF                                                                     
     CALL cl_prt_pos_len()
     #FUN-6C0012.....end
     START REPORT g930_rep TO l_name
     LET g_pageno = 0
}                                                                                                                                   
#No.FUN-830100  --END 
     FOREACH g930_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF tm.choice = 'N' AND sr.amt = 0 THEN CONTINUE FOREACH END IF
          IF sr.mm IS NULL OR sr.mm = 0 THEN     CONTINUE FOREACH END IF
          FOR g_i = 1 TO 2
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.aag223
                                            #LET g_orderA[g_i]= g_x[12]  #No.FUN-830100 
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.aag224
                                            #LET g_orderA[g_i]= g_x[13]  #No.FUN-830100 
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.aag225
                                            #LET g_orderA[g_i]= g_x[14]  #No.FUN-830100  
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.aag226
                                            #LET g_orderA[g_i]= g_x[15]  #No.FUN-830100 
                   OTHERWISE LET l_order[g_i]  = '-'
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          IF tm.detail = '1'
             THEN LET sr.order3 = sr.aag01
             ELSE LET sr.order3 = sr.order2
          END IF
          #No.FUN-830100  --begin  
          #OUTPUT TO REPORT g930_rep(sr.*)
          LET g_msg = NULL                                                                                                          
          SELECT gem02 INTO g_msg FROM gem_file                                                                                     
           WHERE gem01 = tm.dept                                                                                                    
            AND gem05 = 'Y'                                                                                                         
            AND gemacti = 'Y'                                                                                                       
          LET l_aae02 = NULL                                                                                                        
          LET ll_aae02 = NULL                                                                                                       
          SELECT aae02 INTO l_aae02 FROM aae_file                                                                                   
           WHERE aae01 = sr.order1                                                                                                  
          IF SQLCA.SQLCODE THEN                                                                                                     
             LET l_aae02 = NULL                                                                                                     
          END IF                                                                                                                    
          SELECT aae02 INTO ll_aae02 FROM aae_file                                                                                  
             WHERE aae01 = sr.order3                                                                                                
            IF SQLCA.SQLCODE THEN                                                                                                   
               LET ll_aae02 = NULL                                                                                                  
            END IF                                                                                                                  

          #FUN-B80158-----add----str-------
          IF sr.mm = 1 THEN 
             LET sr.amt1 = sr.amt 
          ELSE
             LET sr.amt1 = 0
          END IF
          IF sr.mm = 2 THEN 
             LET sr.amt2 = sr.amt 
          ELSE
             LET sr.amt2 = 0
          END IF

          IF sr.mm = 3 THEN 
             LET sr.amt3 = sr.amt 
          ELSE
             LET sr.amt3 = 0
          END IF
          IF sr.mm = 4 THEN 
             LET sr.amt4 = sr.amt 
          ELSE
             LET sr.amt4 = 0
          END IF
          IF sr.mm = 5 THEN 
             LET sr.amt5 = sr.amt 
          ELSE
             LET sr.amt5 = 0
          END IF
          IF sr.mm = 6 THEN 
             LET sr.amt6 = sr.amt 
          ELSE
             LET sr.amt6 = 0
          END IF
          IF sr.mm = 7 THEN 
             LET sr.amt7 = sr.amt 
          ELSE
             LET sr.amt7 = 0
          END IF
          IF sr.mm = 8 THEN 
             LET sr.amt8 = sr.amt 
          ELSE
             LET sr.amt8 = 0
          END IF
          IF sr.mm = 9 THEN 
             LET sr.amt9 = sr.amt 
          ELSE
             LET sr.amt9 = 0
          END IF
          IF sr.mm = 10 THEN 
             LET sr.amt10 = sr.amt 
          ELSE
             LET sr.amt10 = 0
          END IF
          IF sr.mm = 11 THEN 
             LET sr.amt11 = sr.amt 
          ELSE
             LET sr.amt11 = 0
          END IF
          IF sr.mm = 12 THEN 
             LET sr.amt12 = sr.amt 
          ELSE
             LET sr.amt12 = 0
          END IF
          #FUN-B80158-----add----end-------

          EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.aag01, sr.aag02,                                               
                                    sr.aag13, sr.aag223,sr.aag224,sr.aag225,sr.aag226,                                              
                                    sr.mm,    sr.amt,   g_msg,    l_aae02,  t_azi05,                                                
                                    ll_aae02,
                                    #FUN-B80158-----add----str-----                             
                                    sr.amt1,sr.amt2,sr.amt3,sr.amt4,sr.amt5,sr.amt6,
                                    sr.amt7,sr.amt8,sr.amt9,sr.amt10,sr.amt11,sr.amt12
                                    #FUN-B80158-----add----end-----                             
        #No.FUN-830100  --end 
     END FOREACH
     #No.FUN-830100  --begin 
     #FINISH REPORT g930_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     IF g_zz05='Y' THEN                                                                                                             
        CALL cl_wcchp(g_wc,'aag223,aag224,aag225,aag226')                                                                           
        RETURNING g_wc                                                                                                              
        LET g_str=g_wc                                                                                                              
     END IF                                                                                                                         
###GENGRE###     LET g_str=g_str CLIPPED,';',tm.s[1,1],';',tm.s[2,2],';',tm.azh02,';',                                                          
###GENGRE###                                 tm.t[1,1],';',tm.t[2,2],';',tm.yy,';',tm.k,';',                                                    
###GENGRE###                                 tm.dept,';',g_base,';',tm.detail                                                                   
###GENGRE###     LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                
###GENGRE###     CALL cl_prt_cs3('aglg930','aglg930',g_sql,g_str)                                                                               
    CALL aglg930_grdata()    ###GENGRE###
     #No.FUN-830100  --end                              
END FUNCTION
 
#No.FUN-830100  --begin  
{
REPORT g930_rep(sr)
DEFINE l_last_sw        LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)
DEFINE sr               RECORD
                        order1 LIKE aag_file.aag223,    #No.FUN-680098CHAR(04)
                        order2 LIKE aag_file.aag223,    #No.FUN-680098CHAR(04)
                        order3 LIKE aag_file.aag01,     #No.FUN-680098 VARCHAR(20)
                        aag01  LIKE aag_file.aag01,
                        aag02  LIKE aag_file.aag02,
                        aag13  LIKE aag_file.aag13,    #FUN-6C0012
                        aag223 LIKE aag_file.aag223,
                        aag224 LIKE aag_file.aag224,
                        aag225 LIKE aag_file.aag225,
                        aag226 LIKE aag_file.aag226,
                        mm     LIKE type_file.num5,    #No.FUN-680098 SMALLINT,
                        amt    LIKE aah_file.aah04
                        END RECORD
DEFINE l_aae02          LIKE aae_file.aae02
DEFINE i                LIKE type_file.num5    #No.FUN-680098 SMALLINT
DEFINE amt ARRAY[13] OF LIKE aah_file.aah04    #No.FUN-680098 decimal(20,6)
DEFINE l_sum            LIKE aah_file.aah04
DEFINE g_head1          STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1, sr.order2, sr.order3,sr.mm
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         IF NOT cl_null(tm.azh02) THEN
            LET g_x[1] = tm.azh02
         ELSE
            LET g_x[1] = g_x[1]
         END IF
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
 
         LET g_head1 = g_x[10] CLIPPED,tm.yy USING '&&&&'
         PRINT g_head1
         LET g_msg = NULL
         SELECT gem02 INTO g_msg FROM gem_file
          WHERE gem01 = tm.dept
            AND gem05 = 'Y'
            AND gemacti = 'Y'
         LET g_head1 = g_x[17] CLIPPED,tm.dept CLIPPED,' ',g_msg CLIPPED
         PRINT g_head1
         LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,
                       '-',g_orderA[2] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],        #FUN-6C0012
         PRINT g_x[31],g_x[32],g_x[46],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],#FUN-6C0012
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
         SELECT aae02 INTO l_aae02 FROM aae_file
           WHERE aae01 = sr.order1
         IF SQLCA.SQLCODE THEN
            LET l_aae02 = NULL
         END IF
         PRINT COLUMN g_c[31],sr.order1,
               COLUMN g_c[32],l_aae02
         SKIP 1 LINE
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         FOR i = 1 TO 13
            LET amt[i] = 0
         END FOR
 
      AFTER GROUP OF sr.mm
         LET i = sr.mm
         LET amt[i] = GROUP SUM(sr.amt)
 
      AFTER GROUP OF sr.order3
        #FUN-6C0012.....begin  mark
        # IF tm.detail = '1' THEN
        #    IF tm.k ='N' THEN                                                   
        #       LET l_aae02 = sr.aag02                                           
        #    ELSE                                                                
        #       LET l_aae02 = sr.aag13                                           
        #    END IF
        # ELSE
        #FUN-6C0012.....end
            SELECT aae02 INTO l_aae02 FROM aae_file
             WHERE aae01 = sr.order3
            IF SQLCA.SQLCODE THEN
               LET l_aae02 = NULL
            END IF
        # END IF  #FUN-6C0012 mark
 
         PRINT COLUMN g_c[31],sr.order3 CLIPPED;
        #FUN-6C0012.....begin
         IF tm.detail = '1' THEN
            PRINT COLUMN g_c[32],sr.aag02 CLIPPED,
                  COLUMN g_c[46],sr.aag13 CLIPPED;   
         ELSE
            PRINT COLUMN g_c[32],l_aae02 CLIPPED;
         END IF
        #FUN-6C0012.....end
 
         LET l_sum = 0
         FOR i = 1 TO 12
             PRINT COLUMN g_c[32+i],cl_numfor(amt[i]/g_base,(32+i),t_azi05);         #No.CHI-6A0004 g_azi-->t_azi
             LET l_sum = l_sum + amt[i]
         END FOR
         PRINT COLUMN g_c[45],cl_numfor(l_sum/g_base,45,t_azi05)        #No.CHI-6A0004 g_azi-->t_azi
 
      AFTER GROUP OF sr.order1
         PRINT g_dash1
 
      ON LAST ROW
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]   #FUN-6C0012
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-830100  --end 
#Patch....NO.TQC-610035 <001> #

###GENGRE###START
FUNCTION aglg930_grdata()
    DEFINE l_sql    STRING
    DEFINE l_sql1   STRING   #FUN-B80158 
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    #FUN-B80158---add----str-------------
    LET g_sql1 = "SELECT COUNT(DISTINCT order2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1 = ? OR order1 IS NULL"
    DECLARE aglg930_repcur01 CURSOR FROM g_sql1
    #FUN-B80158---add----end-------------


    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg930")
        IF handler IS NOT NULL THEN
            START REPORT aglg930_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY order1,order2,order3,mm"       #FUN-B80158 add
          
            DECLARE aglg930_datacur1 CURSOR FROM l_sql
            FOREACH aglg930_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg930_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg930_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg930_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158-------add-----str----
    DEFINE l_cnt1          LIKE type_file.num10
    DEFINE l_cnt2          LIKE type_file.num10
    DEFINE l_ord1_cnt      LIKE type_file.num10
    DEFINE l_ord2_cnt      LIKE type_file.num10
    DEFINE l_skip_ord1     LIKE type_file.chr1
    DEFINE l_skip_ord2     LIKE type_file.chr1
    DEFINE l_amt1   LIKE aah_file.aah04
    DEFINE l_amt2   LIKE aah_file.aah04
    DEFINE l_amt3   LIKE aah_file.aah04
    DEFINE l_amt4   LIKE aah_file.aah04
    DEFINE l_amt5   LIKE aah_file.aah04
    DEFINE l_amt6   LIKE aah_file.aah04
    DEFINE l_amt7   LIKE aah_file.aah04
    DEFINE l_amt8   LIKE aah_file.aah04
    DEFINE l_amt9   LIKE aah_file.aah04
    DEFINE l_amt10  LIKE aah_file.aah04
    DEFINE l_amt11  LIKE aah_file.aah04
    DEFINE l_amt12  LIKE aah_file.aah04
    DEFINE l_amt_sum      LIKE aah_file.aah04
    DEFINE g_amt_sum      LIKE aah_file.aah04
    DEFINE g_amt1   LIKE aah_file.aah04
    DEFINE g_amt2   LIKE aah_file.aah04
    DEFINE g_amt3   LIKE aah_file.aah04
    DEFINE g_amt4   LIKE aah_file.aah04
    DEFINE g_amt5   LIKE aah_file.aah04
    DEFINE g_amt6   LIKE aah_file.aah04
    DEFINE g_amt7   LIKE aah_file.aah04
    DEFINE g_amt8   LIKE aah_file.aah04
    DEFINE g_amt9   LIKE aah_file.aah04
    DEFINE g_amt10  LIKE aah_file.aah04
    DEFINE g_amt11  LIKE aah_file.aah04
    DEFINE g_amt12  LIKE aah_file.aah04
    DEFINE s_amt_sum      LIKE aah_file.aah04
    DEFINE s_amt1   LIKE aah_file.aah04
    DEFINE s_amt2   LIKE aah_file.aah04
    DEFINE s_amt3   LIKE aah_file.aah04
    DEFINE s_amt4   LIKE aah_file.aah04
    DEFINE s_amt5   LIKE aah_file.aah04
    DEFINE s_amt6   LIKE aah_file.aah04
    DEFINE s_amt7   LIKE aah_file.aah04
    DEFINE s_amt8   LIKE aah_file.aah04
    DEFINE s_amt9   LIKE aah_file.aah04
    DEFINE s_amt10  LIKE aah_file.aah04
    DEFINE s_amt11  LIKE aah_file.aah04
    DEFINE s_amt12  LIKE aah_file.aah04
    DEFINE l_sum_column   STRING
    DEFINE g_c32_g_c46  LIKE aag_file.aag13
    DEFINE g_head1      STRING
    DEFINE g_head2      STRING
    DEFINE g_head3      STRING
    DEFINE g_orderA1    STRING
    DEFINE g_orderA2    STRING
    DEFINE g_x1         STRING
    DEFINE l_aae02      LIKE aae_file.aae02
    DEFINE l_ord1_skip      STRING    
    DEFINE l_ord2_skip      STRING    
    DEFINE l_amt_fmt        STRING
    DEFINE l_skip      LIKE type_file.chr1
    DEFINE l_order1_cnt LIKE type_file.num10
    DEFINE l_skip2     LIKE type_file.chr1
    DEFINE l_skip3     LIKE type_file.chr1
    DEFINE l_skip1     LIKE type_file.chr1
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE g_x32       STRING
    #FUN-B80158-------add-----end----

    
    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3,sr1.mm
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime    #FUN-B80158   add g_user_name,g_ptime
            PRINTX tm.*
            PRINTX g_wc
            #FUN-B80158------add------str----
            LET l_ord1_skip = tm.t[1]
            LET l_ord2_skip = tm.t[2]
            PRINTX l_ord1_skip,l_ord2_skip 

            LET g_orderA1 = cl_gr_getmsg("gre-203",g_lang,tm.s[1,1])
            LET g_orderA2 = cl_gr_getmsg("gre-203",g_lang,tm.s[2,2])
            LET g_head1 = cl_gr_getmsg("gre-113",g_lang,1),':',tm.yy
            LET g_head2 = cl_gr_getmsg("gre-221",g_lang,1),':',tm.dept,sr1.g_msg
            LET g_head3 = cl_gr_getmsg("gre-204",g_lang,1),':',g_orderA1,'-',g_orderA2
            PRINTX g_head1 
            PRINTX g_head2 
            PRINTX g_head3 
            IF NOT cl_null(tm.azh02) THEN
               LET g_x1 = tm.azh02
            ELSE
               LET g_x1 = cl_gr_getmsg("gre-222",g_lang,1)
            END IF
            PRINTX g_x1

            LET l_ord1_cnt = 0
            #FUN-B80158------add------end----
              
        BEFORE GROUP OF sr1.order1
            #FUN-B80158------add------str----
#           LET g_sql2 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                        " WHERE order1 = '",sr1.order1,"' OR order1 IS NULL"
#           DECLARE aglg930_repcur02 CURSOR FROM g_sql2
#           FOREACH aglg930_repcur02 INTO l_cnt1 END FOREACH
            
            IF tm.k = 'Y' THEN
               LET l_aae02 = " "
            ELSE
               LET l_aae02 = sr1.l_aae02
            END IF
            PRINTX l_aae02

            #FUN-B80158------add------end----
        BEFORE GROUP OF sr1.order2
            FOREACH aglg930_repcur01 USING sr1.order1 INTO l_cnt1 END FOREACH   #FUN-B80158 add
        BEFORE GROUP OF sr1.order3
        BEFORE GROUP OF sr1.mm

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
#           LET l_ord1_cnt = l_ord1_cnt + 1   #FUN-B80158 add

            PRINTX sr1.*

        AFTER GROUP OF sr1.order1
            #FUN-B80158------add------str----
                
             
            LET l_amt_fmt = cl_gr_numfmt("aah_file","aah04",t_azi05)
            PRINTX l_amt_fmt
            LET l_sum_column = sr1.l_aae02,cl_gr_getmsg("gre-223",g_lang,1),':'
            PRINTX l_sum_column
            LET s_amt1 = GROUP SUM(sr1.amt1) / g_base
            LET s_amt2 = GROUP SUM(sr1.amt2) / g_base
            LET s_amt3 = GROUP SUM(sr1.amt3) / g_base
            LET s_amt4 = GROUP SUM(sr1.amt4) / g_base
            LET s_amt5 = GROUP SUM(sr1.amt5) / g_base
            LET s_amt6 = GROUP SUM(sr1.amt6) / g_base
            LET s_amt7 = GROUP SUM(sr1.amt7) / g_base
            LET s_amt8 = GROUP SUM(sr1.amt8) / g_base
            LET s_amt9 = GROUP SUM(sr1.amt9) / g_base
            LET s_amt10 = GROUP SUM(sr1.amt10) / g_base
            LET s_amt12 = GROUP SUM(sr1.amt11) / g_base
            LET s_amt12 = GROUP SUM(sr1.amt12) / g_base
            PRINTX s_amt1 
            PRINTX s_amt2 
            PRINTX s_amt3 
            PRINTX s_amt4 
            PRINTX s_amt5 
            PRINTX s_amt6 
            PRINTX s_amt7 
            PRINTX s_amt8 
            PRINTX s_amt9 
            PRINTX s_amt10 
            PRINTX s_amt11 
            PRINTX s_amt12 
            LET s_amt_sum = s_amt1 + s_amt2 + s_amt3 + s_amt4 + s_amt5 + s_amt6 +
                            s_amt7 + s_amt8 + s_amt9 + s_amt10 + s_amt11 + s_amt12 
            PRINTX s_amt_sum
            #FUN-B80158------add------end----
        AFTER GROUP OF sr1.order2
            #FUN-B80158------add------str----
            IF l_ord2_cnt = l_cnt1 THEN
               LET l_skip = 'N'
               LET l_ord2_cnt = 0
            ELSE
               LET l_skip = 'Y'
            END IF
            PRINTX l_skip
            #FUN-B80158------add------end----
        AFTER GROUP OF sr1.order3
            #FUN-B80158------add------str----
            IF tm.k = 'Y' THEN
               IF tm.detail = '1' THEN
                  LET g_c32_g_c46 = sr1.aag13
               ELSE
                  LET g_c32_g_c46 = " "
               END IF
            ELSE
               IF tm.detail = '1' THEN
                  LET g_c32_g_c46 = sr1.aag02
               ELSE
                  LET g_c32_g_c46 = sr1.ll_aae02
               END IF
            END IF
            PRINTX g_c32_g_c46
            LET g_amt1 = GROUP SUM(sr1.amt1) / g_base
            LET g_amt2 = GROUP SUM(sr1.amt2) / g_base
            LET g_amt3 = GROUP SUM(sr1.amt3) / g_base
            LET g_amt4 = GROUP SUM(sr1.amt4) / g_base
            LET g_amt5 = GROUP SUM(sr1.amt5) / g_base
            LET g_amt6 = GROUP SUM(sr1.amt6) / g_base
            LET g_amt7 = GROUP SUM(sr1.amt7) / g_base
            LET g_amt8 = GROUP SUM(sr1.amt8) / g_base
            LET g_amt9 = GROUP SUM(sr1.amt9) / g_base
            LET g_amt10 = GROUP SUM(sr1.amt10) / g_base
            LET g_amt11 = GROUP SUM(sr1.amt11) / g_base
            LET g_amt12 = GROUP SUM(sr1.amt12) / g_base
            PRINTX g_amt1
            PRINTX g_amt2 
            PRINTX g_amt3
            PRINTX g_amt4
            PRINTX g_amt5
            PRINTX g_amt6
            PRINTX g_amt7
            PRINTX g_amt8
            PRINTX g_amt9
            PRINTX g_amt10
            PRINTX g_amt11
            PRINTX g_amt12

            LET g_amt_sum = g_amt1 + g_amt2 + g_amt3 + g_amt4 + g_amt5 + g_amt6 +
                            g_amt7 + g_amt8 + g_amt9 + g_amt10 + g_amt11 + g_amt12 
            PRINTX g_amt_sum
            #FUN-B80158------add------end----
        AFTER GROUP OF sr1.mm

        
        ON LAST ROW

END REPORT
###GENGRE###END

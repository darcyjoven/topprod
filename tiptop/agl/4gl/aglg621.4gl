# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg621.4gl
# Descriptions...: 全年度預算明細表列印作業
# Date & Author..: 93/10/22  By  Roger
# Modify.........: No.FUN-510007 05/02/23 By Nicola 報表架構修改
# Modify.........: No.MOD-540020 05/04/28 By ching  mark  9046
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-740020 07/04/11 By Lynn 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/18 By johnray 開窗報錯"從幣種檔(azi_file)選擇失敗",未在tm函數中賦bookno默認值
# Modify.........: no.TQC-770047 07/07/10 By judy 存放科目編號欄位過短導致顯示不完全
# Modify.........: No.FUN-760083 07/08/06 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-810069 08/02/28 By lutingting取消預算編號控管
# Modify.........: No.FUN-830139 08/04/07 By douzh 畫面上拿掉預算編號
# Modify.........: No.TQC-840049 08/04/20 By douzh 預算打印bug處理
# Modify.........: No.MOD-840652 08/05/06 By Smapmin temp table的資料沒清空
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No:FUN-AB0020 10/11/05 By chenying 畫面上新增預算項目afc01
# Modify.........: No:FUN-B80158 11/09/05 By yangtt 明細類CR轉化成GRW
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_wc STRING  #No.FUN-580092 HCN   
   DEFINE tm  RECORD
              s       LIKE type_file.chr2,      #No.FUN-680098 VARCHAR(2) 
              bookno  LIKE aag_file.aag00,      #No.FUN-740020
              t       LIKE type_file.chr2,      #No.FUN-680098 VARCHAR(2)
              azh01   LIKE azh_file.azh01,
              azh02   LIKE azh_file.azh02,
              yy      LIKE afc_file.afc03,      #No.FUN-680098  smallint
              afc01   LIKE afc_file.afc01,      #:FUN-AB0020 add    
# Prog. Version..: '5.30.06-13.03.12(04)      #No.FUN-830139
              choice  LIKE type_file.chr1,      #異動額及餘額為零者是否列印  #No.FUN-680098 VARCHAR(1)
              dec     LIKE type_file.num5,      #金額單位(1)元(2)千(3)百萬   #No.FUN-680098 smallint
              detail  LIKE type_file.chr1,      #(1)科目明細  (2)分類彙總    #No.FUN-680098   VARCHAR(1)
              d       LIKE type_file.chr1,      #額外名稱 #FUN-6C0012
              more    LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)
              END RECORD
   DEFINE g_orderA       ARRAY[2] OF LIKE  type_file.chr20        #No.FUN-680098 VARCHAR(10)
#   DEFINE g_bookno       LIKE aaa_file.aaa01     #No.FUN-670039  #No.FUN-740020
   DEFINE g_base         LIKE type_file.num10                     #No.FUN-680098 integer
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 smallint
DEFINE   g_sql           STRING                  #No.FUN-760083
DEFINE   g_sql1          STRING                  #No.FUN-B80158
DEFINE   g_sql2          STRING                  #No.FUN-B80158
DEFINE   g_sql3          STRING                  #No.FUN-B80158
DEFINE   g_str           STRING                  #No.FUN-760083
DEFINE   l_table         STRING                  #No.FUN-760083
DEFINE g_ord1_desc      STRING                   #FUN-B80158 add
DEFINE g_ord2_desc      STRING                   #FUN-B80158 add
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
    #FUN-B80158----add---str--
    amt1 LIKE aah_file.aah04,
    amt2 LIKE aah_file.aah04,
    amt3 LIKE aah_file.aah04,
    amt4 LIKE aah_file.aah04,
    amt5 LIKE aah_file.aah04,
    amt6 LIKE aah_file.aah04,
    amt7 LIKE aah_file.aah04,
    amt8 LIKE aah_file.aah04,
    amt9 LIKE aah_file.aah04,
    amt10 LIKE aah_file.aah04,
    amt11 LIKE aah_file.aah04,
    amt12 LIKE aah_file.aah04,
    #FUN-B80158----add---end--
    l_aae02 LIKE aag_file.aag13,
    l_aae02_1 LIKE aag_file.aag13
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
#No.FUN-760083  --BEGIN--
   LET g_sql="order1.aae_file.aae01,",
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
             #FUN-B80158----add---str--
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
             "amt12.aah_file.aah04,",
             #FUN-B80158----add---end--
             "l_aae02.aag_file.aag13,",
             "l_aae02_1.aag_file.aag13"
   LET  l_table=cl_prt_temptable("aglg621",g_sql)  CLIPPED
   IF l_table=-1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
    END IF
   #LET g_sql="INSERT INTO ds_report.",l_table CLIPPED,  #TQC-A40133 mark
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"    #FUN-B80158 add 12?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
       CALL cl_err("insert_prep:",status,1)
   END IF                                      
#No.FUN-760083  --END--
 
   LET tm.bookno= ARG_VAL(1)          #No.FUN-740020
   LET g_pdate = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET g_wc  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.azh01 = ARG_VAL(11)   #TQC-610056
   LET tm.azh02 = ARG_VAL(12)   #TQC-610056
   LET tm.yy = ARG_VAL(13)
   LET tm.afc01 = ARG_VAL(14)   #FUN-AB0020 add
#  LET tm.h  = ARG_VAL(14)      #No.FUN-830139
   LET tm.dec = ARG_VAL(15)
   LET tm.detail  = ARG_VAL(16)
   LET tm.choice  = ARG_VAL(17)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   #No.FUN-570264 ---end---
   LET tm.d  = ARG_VAL(21)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
 
#No.FUN-740020 ---begin
    IF cl_null(tm.bookno) THEN   #No.FUN-740020
       LET tm.bookno = g_aza.aza81
    END IF
#No.FUN-740020 ---end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g621_tm(0,0)
      ELSE CALL g621()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION g621_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680098 smallint
       l_cmd          LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(400)
DEFINE l_azfacti      LIKE azf_file.azfacti    #FUN-AB0020 
DEFINE l_combo        ui.ComboBox              #FUN-B80158 add

   IF p_row = 0 THEN LET p_row = 4 LET p_col = 4 END IF
   CALL s_dsmark(tm.bookno)
   LET p_row = 2 LET p_col = 18
   OPEN WINDOW g621_w AT p_row,p_col
     WITH FORM "agl/42f/aglg621"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,tm.bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bookno = g_aza.aza81     #No.TQC-740093
   #使用預設帳別之幣別
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno           #No.TQC-740093
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","",0)   # NO.FUN-660123   #No.FUN-740020
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = g_aaa03          #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN 
#      CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   # NO.FUN-660123
   END IF
   LET tm.s    = '12'
   LET tm.choice = 'N'
   LET tm.dec    = 2
   LET tm.detail = '1'
   LET tm.d    = 'N'   #FUN-6C0012
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
 
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW g621_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   #MOD-540020
  #IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   DISPLAY BY NAME tm.more
#  INPUT BY NAME tm.bookno,tm.azh01,tm.azh02,tm.yy,tm.h,tm.dec,tm.detail,  #No.FUN-740020
   INPUT BY NAME tm.bookno,tm.azh01,tm.azh02,tm.yy,tm.afc01,tm.dec,tm.detail,       #No.FUN-740020 #No.FUN-830139 #FUN-AB0020 add tm.afc01
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.choice,tm.d,tm.more    #FUN-6C0012
                  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
#No.FUN-740020 -- begin --                                                                                                          
         AFTER FIELD bookno                                                                                                         
            IF tm.bookno = '*' THEN                                                                                                 
               NEXT FIELD bookno                                                                                                    
            END IF                                                                                                                  
#No.FUN-740020 -- end -- 
 
         AFTER FIELD azh01
           IF NOT cl_null(tm.azh01) THEN
              SELECT azh02
                 INTO tm.azh02
                 FROM azh_file
                 WHERE azh01 = tm.azh01
                      IF SQLCA.SQLCODE = 100 THEN
                          #CALL cl_err(tm.azh01,'mfg6217',1) #No.+045 010403 plum   
#                        CALL cl_err(tm.azh01,'mfg9207',1)   #No.FUN-660123
                         CALL cl_err3("sel","azh_file",tm.azh01,"","mfg9207","","",1)   #No.FUN-660123
                         NEXT FIELD azh01
                      END IF
           END IF
         AFTER FIELD yy
           IF tm.yy <= 1911 OR cl_null(tm.yy) THEN
              NEXT FIELD yy
           END IF

#FUN-AB0020-------add-------str---------------
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
#FUN-AB0020-------add-------end---------------

#No.FUN-830139--begin
#        AFTER FIELD h
#           IF tm.h IS NULL THEN NEXT FIELD h END IF
## No:2578 modify 1998/10/21 ----------------
#           SELECT afa01 FROM afa_file
#              WHERE afa00 = tm.bookno AND afa01 = tm.h     #No.FUN-740020
#              WHERE afa01 = tm.h
#                AND afa00 = tm.bookno        #No.FUN-740020
##  
#           IF SQLCA.sqlcode THEN
##             CALL cl_err(tm.h,'agl-005',0)   #No.FUN-660123
#              CALL cl_err3("sel","afa_file",tm.h,"","agl-005","","",0)   #No.FUN-660123
#              NEXT FIELD h
#           END IF
#No.FUN-830139--begin
         AFTER FIELD choice
           IF tm.choice NOT MATCHES '[YN]' THEN
              NEXT FIELD choice
           END IF
         AFTER FIELD dec
        #   IF tm.dec NOT MATCHES '[123]' THEN NEXT FIELD dec END IF
           IF tm.dec = 1 OR tm.dec = 2 OR tm.dec =3 THEN
              CASE tm.dec WHEN 1 LET g_base = 1
                       WHEN 2 LET g_base = 1000
                       WHEN 3 LET g_base = 1000000
                       OTHERWISE NEXT FIELD dec
              END CASE
           ELSE
                NEXT FIELD dec
           END IF
         AFTER FIELD detail
           IF tm.detail NOT MATCHES '[12]' THEN
              NEXT FIELD detail
           END IF
         AFTER FIELD more
           IF tm.more = 'Y' THEN
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
         ON ACTION CONTROLP
           CASE
#No.FUN-740020  ---begin                                                                                                            
          WHEN INFIELD(bookno)                                                                                                      
             CALL cl_init_qry_var()                                                                                                 
             LET g_qryparam.form = 'q_aaa'                                                                                          
             LET g_qryparam.default1 = tm.bookno                                                                                    
             CALL cl_create_qry() RETURNING tm.bookno                                                                               
             DISPLAY BY NAME tm.bookno                                                                                              
             NEXT FIELD bookno                                                                                                      
#No.FUN-740020  ---end
               WHEN INFIELD(azh01)
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_azh'
    LET g_qryparam.default1 = tm.azh01
    LET g_qryparam.default2 = tm.azh02
    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
                    DISPLAY tm.azh01, tm.azh02 TO azh01, azh02
#No.FUN-830139--begin
#                  WHEN INFIELD(h)
#   CALL cl_init_qry_var()
#  #LET g_qryparam.form = 'q_afa'    #FUN-810069
#   LET g_qryparam.form = 'q_azf'    #FUN-810069
#   LET g_qryparam.default1 = tm.h
# # LET g_qryparam.arg1 = tm.bookno          #No.FUN-740020   #FUN-810069
#   LET g_qryparam.arg1 = '2'        #FUN-810069
#   CALL cl_create_qry() RETURNING tm.h
#                       DISPLAY BY NAME tm.h
#                       NEXT FIELD h
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

      #FUN-B80158-------add----str----
      LET l_combo = ui.ComboBox.forName("formonly.s1")
      LET g_ord1_desc = l_combo.getTextOf(tm2.s1[1])  
      LET l_combo = ui.ComboBox.forName("formonly.s2")
      LET g_ord2_desc = l_combo.getTextOf(tm2.s2[1])
      #FUN-B80158-------add----end----

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
      CLOSE WINDOW g621_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aglg621'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg621','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",tm.bookno CLIPPED,"'",      #No.FUN-740020
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.azh02 CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.afc01 CLIPPED,"'",             #FUN-AB0020 add
#                        " '",tm.h CLIPPED,"'",                 #No.FUN-830139
                         " '",tm.dec CLIPPED,"'",
                         " '",tm.detail CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'",     #FUN-6C0012
                         " '",tm.choice CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglg621',g_time,l_cmd)
      END IF
      CLOSE WINDOW g621_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g621()
   ERROR ""
END WHILE
   CLOSE WINDOW g621_w
END FUNCTION
 
FUNCTION g621()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,                 #No.FUN-680098 VARCHAR(1)
          l_order   ARRAY[2] OF LIKE aag_file.aag223,    #No.FUN-680098 VARCHAR(4)
          sr        RECORD
                       order1 LIKE aae_file.aae01,    #No.FUN-680098 VARCHAR(4)
                       order2 LIKE aae_file.aae01,    #No.FUN-680098 VARCHAR(4)
                      #order3 LIKE aae_file.aae01,    #No.FUN-680098 VARCHAR(20) #TQC-770047 mark
                       order3 LIKE aag_file.aag01,    #No.TQC-770047          
                       aag01  LIKE aag_file.aag01,
                       aag02  LIKE aag_file.aag02,
                       aag13  LIKE aag_file.aag13,    #FUN-6C0012
                       aag223 LIKE aag_file.aag223,
                       aag224 LIKE aag_file.aag224,
                       aag225 LIKE aag_file.aag225,
                       aag226 LIKE aag_file.aag226,
                       mm     LIKE type_file.num5,      #No.FUN-680098 smallint
                       amt    LIKE aah_file.aah04,
                       #FUN-B80158-------add---str---
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
                       #FUN-B80158-------add---end---
                    END RECORD
   DEFINE   l_aae02    LIKE aag_file.aag13              #No.FUN-760083
   DEFINE   l_aae02_1  LIKE aag_file.aag13              #No.FUN-760083
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno     #No.FUN-740020
                  AND aaf02 = g_rlang
   CALL cl_del_data(l_table)   #MOD-840652
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET g_wc = g_wc clipped," AND aaguser = '",g_user,"'smallint"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET g_wc = g_wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET g_wc = g_wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '','','',aag01,aag02,aag13,",    #FUN-6C0012
                 "       aag223,aag224,aag225,aag226,",
                 "       afc05,afc06,",
                 "       '','','','','','','','','','','',''",   #FUN-B80158 add 12 ''
                 " FROM aag_file, afc_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND aag01 = afc02",
                 "   AND afc00 = '",tm.bookno,"'",     #No.FUN-740020
                 "   AND afc00 = aag00",               #No.FUN-740020
#                "   AND afc01 = '",tm.h,"'",          #No.FUN-830139 
                 "   AND afc03 = '",tm.yy,"'",
#                "   AND afc04 = '@'",                  #No.TQC-840049
                 "   AND afc05 != 0"                    
#                "   AND afc041 = '' AND afc042 = '' "  #No.FUN-810069  #No.TQC-840049
#FUN-AB0020------add---------str------------------
     IF NOT cl_null(tm.afc01) THEN
        LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
     END IF     
#FUN-AB0020------add---------end------------------
     PREPARE g621_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
        EXIT PROGRAM
     END IF
     DECLARE g621_curs1 CURSOR FOR g621_prepare1
#    LET l_name = 'aglg621.out'
#No.FUN-760083  --BEGIN--
{
     CALL cl_outnam('aglg621') RETURNING l_name
 
     #No.FUN-6C0012 --start--                                                   
     IF tm.detail = '1' THEN                                                    
        IF tm.d = 'Y' THEN                                                      
           LET g_zaa[32].zaa06 = 'Y'                                            
           LET g_zaa[46].zaa06 = 'N'                                            
        ELSE                                                                    
           LET g_zaa[32].zaa06 = 'N'                                            
           LET g_zaa[46].zaa06 = 'Y'                                            
        END IF                                                                  
     ELSE                                                                       
        LET g_zaa[46].zaa06 = 'Y'                                               
     END IF                                                                     
                                                                                
     CALL cl_prt_pos_len()                                                      
     #No.FUN-6C0012 --end--                                                     
 
                       
     START REPORT g621_rep TO l_name
     LET g_pageno = 0
     LET g_str=''
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
}
#No.FUN-760083 --END--
     FOREACH g621_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF tm.choice = 'N' AND sr.amt = 0 THEN CONTINUE FOREACH END IF
          IF sr.mm IS NULL OR sr.mm = 0 THEN     CONTINUE FOREACH END IF
 
 
          FOR g_i = 1 TO 2
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.aag223
                                           #LET g_orderA[g_i]= g_x[12]   #No.FUN-760083
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.aag224
                                            #LET g_orderA[g_i]= g_x[13]  #No.FUN-760083
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.aag225
                                            #LET g_orderA[g_i]= g_x[14]  #No.FUN-760083
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.aag226
                                            #LET g_orderA[g_i]= g_x[15]  #No.FUN-760083
                   OTHERWISE LET l_order[g_i]  = '-'
              END CASE
          END FOR
          IF l_order[1] IS NULL THEN LET l_order[1] = ' ' END IF   #FUN-B80158
          IF l_order[2] IS NULL THEN LET l_order[2] = ' ' END IF   #FUN-B80158 
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          IF tm.detail = '1'
             THEN LET sr.order3 = sr.aag01
             ELSE LET sr.order3 = sr.order2
          END IF
 
 
 
          #OUTPUT TO REPORT g621_rep(sr.*)    #No.FUN-760083
 
         SELECT aae02 INTO l_aae02 FROM aae_file                                                                                    
          WHERE aae01 = sr.order1                                                                                                   
         IF SQLCA.SQLCODE THEN                                                                                                      
            LET l_aae02 = NULL                                                                                                      
         END IF                   
         IF tm.detail = '1' THEN                                                                                                    
            IF tm.d = 'Y' THEN                                                                                                      
               LET l_aae02_1 = sr.aag13                                                                                               
            ELSE                                                                                                                    
               LET l_aae02_1 = sr.aag02                                                                                               
            END IF                                                                                                     
         ELSE                                                                                                                       
            SELECT aae02 INTO l_aae02_1 FROM aae_file                                                                                 
             WHERE aae01 = sr.order3                                                                                                
            IF SQLCA.SQLCODE THEN                                                                                                   
               LET l_aae02_1 = NULL                                                                                                   
            END IF                                                                                                                  
         END IF                        
         #FUN-B80158-------add-----str------
         IF sr.mm = 1 THEN
            LET sr.amt1 = sr.amt
         END IF
         IF sr.mm = 2 THEN
            LET sr.amt2 = sr.amt
         END IF
         IF sr.mm = 3 THEN
            LET sr.amt3 = sr.amt
         END IF
         IF sr.mm = 4 THEN
            LET sr.amt4 = sr.amt
         END IF
         IF sr.mm = 5 THEN
            LET sr.amt5 = sr.amt
         END IF
         IF sr.mm = 6 THEN
            LET sr.amt6 = sr.amt
         END IF
         IF sr.mm = 7 THEN
            LET sr.amt7 = sr.amt
         END IF
         IF sr.mm = 8 THEN
            LET sr.amt8 = sr.amt
         END IF
         IF sr.mm = 9 THEN
            LET sr.amt9 = sr.amt
         END IF
         IF sr.mm = 10 THEN
            LET sr.amt10 = sr.amt
         END IF
         IF sr.mm = 11 THEN
            LET sr.amt11 = sr.amt
         END IF
         IF sr.mm = 12 THEN
            LET sr.amt12 = sr.amt
         END IF
         #FUN-B80158-------add-----end------
         EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.aag01,sr.aag02,sr.aag13,sr.aag223,sr.aag224,
                                   sr.aag225,sr.aag226,sr.mm,sr.amt,
                                   sr.amt1,sr.amt2,sr.amt3,sr.amt4,sr.amt5,     #FUN-B80158 add
                                   sr.amt6,sr.amt7,sr.amt8,sr.amt9,sr.amt10,sr.amt11,sr.amt12,    #FUN-B80158 add
                                   l_aae02,l_aae02_1
#No.FUN-760083 --end--
     END FOREACH
 
     #FINISH REPORT g621_rep   #No.FUN-760083 
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-760083 
     IF g_zz05='Y' THEN
         CALL cl_wcchp(g_wc,'aag223,aag224,aag225,aag226')
         RETURNING g_wc
     END  IF
###GENGRE###     LET g_str=g_wc,';',tm.detail,';',tm.d,';',tm.azh02,';',tm.yy,';',tm.s[1,1],';',
###GENGRE###               tm.s[2,2],';',tm.t[1,1],';',tm.t[2,2],';',g_base,';',t_azi05
###GENGRE###     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3("aglg621","aglg621",g_sql,g_str)
    CALL aglg621_grdata()    ###GENGRE###
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT g621_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
DEFINE sr           RECORD
                      order1 LIKE aae_file.aae01, #No.FUN-680098   VARCHAR(4)
                      order2 LIKE aae_file.aae01, #No.FUN-680098   VARCHAR(4)
                     #order3 LIKE aae_file.aae01, #No.FUN-680098   VARCHAR(40) #TQC-770047 mark
                      order3 LIKE aag_file.aag01, #No.TQC-770047          
                      aag01  LIKE aag_file.aag01,
                      aag02  LIKE aag_file.aag02,
                      aag13  LIKE aag_file.aag13, #FUN-6C0012
                      aag223 LIKE aag_file.aag223,
                      aag224 LIKE aag_file.aag224,
                      aag225 LIKE aag_file.aag225,
                      aag226 LIKE aag_file.aag226,
                      mm     LIKE type_file.num5,   #No.FUN-680098 smallint
                      amt    LIKE aah_file.aah04
                    END RECORD
#DEFINE l_aae02          LIKE aae_file.aae02    #FUN-6C0012
DEFINE l_aae02          LIKE aag_file.aag13     #FUN-6C0012
DEFINE i                LIKE type_file.num5          #No.FUN-680098 smallint
DEFINE amt ARRAY[13] OF LIKE aah_file.aah04          #No.FUN-680098 dec(20,6)
DEFINE l_sum            LIKE aah_file.aah04
DEFINE g_head1          STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.mm
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         IF NOT cl_null(tm.azh02) THEN
            LET g_x[1] = tm.azh02
         ELSE
            LET g_x[1] = g_x[1]
         END IF
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
 
         LET g_head1 = g_x[10] CLIPPED,tm.yy USING '&&&&'
         PRINT g_head1
         LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,
                       '-',g_orderA[2] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[46],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],  #FUN-6C0012
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
#        #FUN-6C0012.....begin
               COLUMN g_c[32],l_aae02,
               COLUMN g_c[46],l_aae02
#        #FUN-6C0012.....end
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
         IF tm.detail = '1' THEN
            #FUN-6C0012.....begin
            IF tm.d = 'Y' THEN
               LET l_aae02 = sr.aag13
            ELSE
            #FUN-6C0012.....end
               LET l_aae02 = sr.aag02
            END IF   #FUN-6C0012
         ELSE
            SELECT aae02 INTO l_aae02 FROM aae_file
             WHERE aae01 = sr.order3
            IF SQLCA.SQLCODE THEN
               LET l_aae02 = NULL
            END IF
         END IF
         PRINT COLUMN g_c[31],sr.order3 CLIPPED,
               COLUMN g_c[32],l_aae02 CLIPPED,
               COLUMN g_c[46],l_aae02 CLIPPED;
#        #FUN-6C0012.....begin
#        IF tm.d = 'N' THEN
#           PRINT COLUMN g_c[32],l_aae02 CLIPPED;
#        ELSE
#           PRINT COLUMN g_c[46],l_aae02 CLIPPED;  
#        END IF
#        #FUN-6C0012.....end
         LET l_sum = 0
         FOR i = 1 TO 12
             PRINT COLUMN g_c[32+i],cl_numfor(amt[i]/g_base,(32+i),t_azi05);    #No.CHI-6A0004 g_azi-->t_azi
             LET l_sum = l_sum + amt[i]
         END FOR
         PRINT COLUMN g_c[45],cl_numfor(l_sum/g_base,45,t_azi05)   #No.CHI-6A0004 g_azi-->t_azi 
 
      AFTER GROUP OF sr.order1
         PRINT g_dash1
 
      ON LAST ROW
         LET l_last_sw = 'y'
            PRINT g_dash[1,g_len]    #FUN-6C0012
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-760083 --end--
#Patch....NO.TQC-610035 <001> #

###GENGRE###START
FUNCTION aglg621_grdata()
    DEFINE l_sql    STRING
    DEFINE l_sql1   STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    #FUN-B80158---add----str-------------
    LET g_sql1 = "SELECT COUNT(DISTINCT order2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE order1 = ? OR order1 IS NULL" 
    DECLARE aglg621_repcur01 CURSOR FROM g_sql1
    #FUN-B80158---add----end-------------


    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg621")
        IF handler IS NOT NULL THEN
            START REPORT aglg621_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY order1 asc nulls first,order2,order3,mm"    #FUN-B80158 add
          
            DECLARE aglg621_datacur1 CURSOR FROM l_sql
            FOREACH aglg621_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg621_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg621_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg621_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158-------add-----str------
    DEFINE l_cnt1          LIKE type_file.num10
    DEFINE l_cnt2          LIKE type_file.num10
    DEFINE l_cnt3          LIKE type_file.num10
    DEFINE l_ord1_cnt      LIKE type_file.num10
    DEFINE l_ord2_cnt      LIKE type_file.num10
    DEFINE l_ord3_cnt      LIKE type_file.num10
    DEFINE l_skip_ord1     LIKE type_file.chr1
    DEFINE l_skip_ord2     LIKE type_file.chr1
    DEFINE l_skip_ord3     LIKE type_file.chr1
    DEFINE l_amt_1         LIKE aah_file.aah04
    DEFINE l_amt_2         LIKE aah_file.aah04
    DEFINE l_amt_3         LIKE aah_file.aah04
    DEFINE l_amt_4         LIKE aah_file.aah04
    DEFINE l_amt_5         LIKE aah_file.aah04
    DEFINE l_amt_6         LIKE aah_file.aah04
    DEFINE l_amt_7         LIKE aah_file.aah04
    DEFINE l_amt_8         LIKE aah_file.aah04
    DEFINE l_amt_9         LIKE aah_file.aah04
    DEFINE l_amt_10        LIKE aah_file.aah04
    DEFINE l_amt_11        LIKE aah_file.aah04
    DEFINE l_amt_12        LIKE aah_file.aah04
    DEFINE l_amt_1_base    LIKE aah_file.aah04
    DEFINE l_amt_2_base    LIKE aah_file.aah04
    DEFINE l_amt_3_base    LIKE aah_file.aah04
    DEFINE l_amt_4_base    LIKE aah_file.aah04
    DEFINE l_amt_5_base    LIKE aah_file.aah04
    DEFINE l_amt_6_base    LIKE aah_file.aah04
    DEFINE l_amt_7_base    LIKE aah_file.aah04
    DEFINE l_amt_8_base    LIKE aah_file.aah04
    DEFINE l_amt_9_base    LIKE aah_file.aah04
    DEFINE l_amt_10_base   LIKE aah_file.aah04
    DEFINE l_amt_11_base   LIKE aah_file.aah04
    DEFINE l_amt_12_base   LIKE aah_file.aah04
    DEFINE l_sum           LIKE aah_file.aah04
    DEFINE l_sum_base      LIKE aah_file.aah04
    DEFINE g_head1         STRING
    DEFINE g_head1_1       STRING
    DEFINE g_orderA1       STRING
    DEFINE g_orderA2       STRING
    DEFINE g_x1            STRING
    DEFINE l_amt_fmt       STRING
    DEFINE l_ord1_skip     STRING
    DEFINE l_ord2_skip     STRING
    DEFINE l_ord3_skip     STRING
    DEFINE l_skip          STRING
    DEFINE l_display       LIKE type_file.chr1    
    #FUN-B80158-------add-----end------

    
    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3,sr1.mm
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime   #FUN-B80158 add g_user_name,g_ptime
            PRINTX tm.*
            #FUN-B80158-------add-----str------
            PRINTX g_wc
            LET g_head1 = cl_gr_getmsg("gre-113",g_lang,1),':',tm.yy
            PRINTX g_head1
            LET g_orderA1 = cl_gr_getmsg("gre-203",g_lang,tm.s[1,1])
            LET g_orderA2 = cl_gr_getmsg("gre-203",g_lang,tm.s[2,2])
            PRINTX g_orderA1
            PRINTX g_orderA2
            LET g_head1_1 = cl_gr_getmsg("gre-204",g_lang,1),g_orderA1,'-',g_orderA2
            PRINTX g_head1_1
            IF NOT cl_null(tm.azh02) THEN
               LET g_x1 = tm.azh02
            ELSE
               LET g_x1 = cl_gr_getmsg("gre-205",g_lang,1) 
            END IF
            PRINTX g_x1

            LET l_ord1_skip = tm.t[1]    
            LET l_ord2_skip = tm.t[2] 
            PRINTX l_ord1_skip,l_ord2_skip
            #FUN-B80158-------add-----end------
              
        BEFORE GROUP OF sr1.order1
        BEFORE GROUP OF sr1.order2
            FOREACH aglg621_repcur01 USING sr1.order1 INTO l_cnt1 END FOREACH   #FUN-B80158 add
        BEFORE GROUP OF sr1.order3
        BEFORE GROUP OF sr1.mm

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.order1
        AFTER GROUP OF sr1.order2
           #FUN-B80158----add----str------------- 
           LET l_ord2_cnt = l_ord2_cnt + 1
           IF l_ord2_cnt = l_cnt1 THEN
              LET l_skip = 'N'
              LET l_ord2_cnt = 0 
           ELSE
              LET l_skip = 'Y'
           END IF
           PRINTX l_skip
           #FUN-B80158----add----end------------- 
        AFTER GROUP OF sr1.order3

           IF sr1.mm = 1 THEN
              LET sr1.amt1 = sr1.amt
           END IF
           IF sr1.mm = 2 THEN
              LET sr1.amt2 = sr1.amt
           END IF
           IF sr1.mm = 3 THEN
              LET sr1.amt3 = sr1.amt
           END IF
           IF sr1.mm = 4 THEN
              LET sr1.amt4 = sr1.amt
           END IF
           IF sr1.mm = 5 THEN
              LET sr1.amt5 = sr1.amt
           END IF
           IF sr1.mm = 6 THEN
              LET sr1.amt6 = sr1.amt
           END IF
           IF sr1.mm = 7 THEN
              LET sr1.amt7 = sr1.amt
           END IF
           IF sr1.mm = 8 THEN
              LET sr1.amt8 = sr1.amt
           END IF
           IF sr1.mm = 9 THEN
              LET sr1.amt9 = sr1.amt
           END IF
           IF sr1.mm = 10 THEN
              LET sr1.amt10 = sr1.amt
           END IF
           IF sr1.mm = 11 THEN
              LET sr1.amt11 = sr1.amt
           END IF
           IF sr1.mm = 12 THEN
              LET sr1.amt12 = sr1.amt
           END IF
           LET l_amt_1 = GROUP SUM(sr1.amt1)
           LET l_amt_2 = GROUP SUM(sr1.amt2)
           LET l_amt_3 = GROUP SUM(sr1.amt3)
           LET l_amt_4 = GROUP SUM(sr1.amt4)
           LET l_amt_5 = GROUP SUM(sr1.amt5)
           LET l_amt_6 = GROUP SUM(sr1.amt6)
           LET l_amt_7 = GROUP SUM(sr1.amt7)
           LET l_amt_8 = GROUP SUM(sr1.amt8)
           LET l_amt_9 = GROUP SUM(sr1.amt9)
           LET l_amt_10 = GROUP SUM(sr1.amt10)
           LET l_amt_11 = GROUP SUM(sr1.amt11)
           LET l_amt_12 = GROUP SUM(sr1.amt12)
           PRINTX l_amt_1
           PRINTX l_amt_2
           PRINTX l_amt_3 
           PRINTX l_amt_4
           PRINTX l_amt_5
           PRINTX l_amt_6
           PRINTX l_amt_7
           PRINTX l_amt_8
           PRINTX l_amt_9
           PRINTX l_amt_10
           PRINTX l_amt_11
           PRINTX l_amt_12

           LET l_amt_1_base = l_amt_1 / g_base 
           LET l_amt_2_base = l_amt_2 / g_base 
           LET l_amt_3_base = l_amt_3 / g_base 
           LET l_amt_4_base = l_amt_4 / g_base 
           LET l_amt_5_base = l_amt_5 / g_base 
           LET l_amt_6_base = l_amt_6 / g_base 
           LET l_amt_7_base = l_amt_7 / g_base 
           LET l_amt_8_base = l_amt_8 / g_base 
           LET l_amt_9_base = l_amt_9 / g_base 
           LET l_amt_10_base = l_amt_10 / g_base 
           LET l_amt_11_base = l_amt_11 / g_base 
           LET l_amt_12_base = l_amt_12 / g_base 
           PRINTX l_amt_1_base
           PRINTX l_amt_2_base
           PRINTX l_amt_3_base
           PRINTX l_amt_4_base
           PRINTX l_amt_5_base
           PRINTX l_amt_6_base
           PRINTX l_amt_7_base
           PRINTX l_amt_8_base
           PRINTX l_amt_9_base
           PRINTX l_amt_10_base
           PRINTX l_amt_11_base
           PRINTX l_amt_12_base
          
           LET l_sum = GROUP SUM(sr1.amt)
           LET l_sum_base = l_sum / g_base
           PRINTX l_sum_base
           LET l_amt_fmt = cl_gr_numfmt("aah_file","aah04",t_azi05)
           PRINTX l_amt_fmt
           #FUN-B80158-------add-----end------
        AFTER GROUP OF sr1.mm

        
        ON LAST ROW

END REPORT
###GENGRE###END

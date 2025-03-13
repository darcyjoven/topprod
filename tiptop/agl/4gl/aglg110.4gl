# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg110.4gl
# Descriptions...: T/B B/S I/S 
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/01 By Roger
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.MOD-510052 05/01/20 By Kitty 若為資產負債表起始月份不可輸入
# Modify.........: No.FUN-510007 05/01/28 By Nicola 報表架構修改
# Modify.........: No.TQC-620081 06/02/20 By Smapmin 當月結方法選擇為帳結法時，
#                                                    相關財務報表無法產出累計/前期損益表  
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.MOD-680002 06/08/02 By Smapmin 修正TQC-620081
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-730135 07/03/28 By Smapmin 修正TQC-620081
# Modify.........: No.FUN-740020 07/04/07 By sherry 會計科目加帳套
# Modify.........: No.FUN-780058 07/08/28 By sherry 報表改寫由Crystal Report產出 
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法  
# Modify.........: No.MOD-850004 08/05/09 By Sarah 將g_basetot1當參數傳到rpt,per1不在4gl裡計算,改到rpt再做計算
# Modify.........: No.FUN-8B0098 08/11/21 By clover 當資產負債表, 表頭出現資料日期,日期未輸入;出現當月最後一天
# Modify.........: No.FUN-8C0018 08/12/15 By jan 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.TQC-950043 09/06/04 By chenmoyan 將aag01改成aaa01
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0126 09/12/23 By chenmoyan 新增产出符合XBRL上传格式档案1.TXT 2.EXCEL 
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/20 By wuxj GP5.2 跨DB報表，財務類
# Modify.........: No.FUN-A30049 10/03/11 By lutingting GP5.2使用環境變數改為以FGL_GETENV引用
# Modify.........: No:MOD-A30135 10/03/19 By Dido  CALL cl_dynamic_locale()   
# Modify.........: NO.FUN-A50069 10/05/18 BY yiting 轉出XBRL上傳檔案時，檔案編號方式要考慮有西元年和民國年
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-A60039 10/08/22 By vealxu 由p_ze取出EXCEL工作表的名稱
# Modify.........: No:CHI-A70046 10/08/23 By Summer 百分比需依金額單位顯示
# Modify.........: NO.MOD-A70192 11/01/07 by Yiting 依之前寫的xbrl程式架構會造成產出的科目設為合計但不產出時，金額沒有被計算
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modif金額應取整數位 y.........: No:MOD-B40063 11/04/12 By Dido XBRL 
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-B60077 11/07/18 by belle 原本抓取maj21做為XBRL轉出科目，改用maj31 
# Modify.........: No.FUN-B80158 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B80057 11/08/25 By yangtt  明細類CR轉換成GRW
# Modify.........: No.FUN-B80158 12/01/05 By qirl FUN-BB0047追單
# Modify.........: No.FUN-B80158 12/01/05 By yangtt FUN-B90140追單
# Modify.........: No.FUN-B80158 12/01/16 By xuxz  MOD-BB0296,MOD-B90188追單
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.FUN-C50004 12/05/10 By nanbing GR優化
IMPORT os   #FUN-A30049
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 rtype  LIKE type_file.chr1,             #報表結構編號     #No.FUN-680098  VARCHAR(1)
               #NO.FUN-A10098  ----start---
               # bb       LIKE type_file.chr1,           #No.FUN-8C0018 VARCHAR(1)
               # b_1      LIKE type_file.chr1,           #No.FUN-8C0018 VARCHAR(1) by jan
               # p1       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10)
               # p2       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10)
               # p3       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10)
               # p4       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10) 
               # p5       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10)
               # p6       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10)
               # p7       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10)
               # p8       LIKE azp_file.azp01,           #No.FUN-8C0018 VARCHAR(10)
               #NO.FUN-A10098  ----end---
                 a      LIKE mai_file.mai01,             #報表結構編號     #No.FUN-680098  VARCHAR(6) 
                 b       LIKE aaa_file.aaa01,            #帳別編號         #No.FUN-670039  
                 yy      LIKE type_file.num5,            #輸入年度         #No.FUN-680098  smallint
                 bm      LIKE type_file.num5,            #Begin 期 別      #No.FUN-680098  smallint
                 em      LIKE type_file.num5,            # End  期別       #No.FUN-680098  smallint
                 dd      LIKE type_file.num5,            #截止日           #No.FUN-680098  smallint
                 c       LIKE type_file.chr1,            #異動額及餘額為0者是否列印     #No.FUN-680098    VARCHAR(1)
                 d       LIKE type_file.chr1,            #金額單位                      #No.FUN-680098   VARCHAR(1) 
                 e       LIKE type_file.num5,            #小數位數         #No.FUN-680098  smallint
                 f       LIKE type_file.num5,            #列印最小階數     #No.FUN-680098  smallint
                 h       LIKE type_file.chr4,            #額外說明類別     #No.FUN-680098  VARCHAR(4)
                 xbrl    LIKE type_file.chr1,            #是否产生XBRL卡   #No.FUN-9C0126  char(1)
                 exp     LIKE type_file.chr1,            #产生XBRL格式     #No.FUN-9C0126  char(1)
                 o       LIKE type_file.chr1,            #轉換幣別否       #No.FUN-680098  VARCHAR(1)
                 p       LIKE azi_file.azi01,  #幣別
                 q       LIKE azj_file.azj03,  #匯率
                 r       LIKE azi_file.azi01,  #幣別
                 more     LIKE type_file.chr1,            #Input more condition(Y/N)   #No.FUN-680098   VARCHAR(1)
                 acc_code LIKE type_file.chr1             #NO.FUN-B80158 add 
              END RECORD,
          bdate,edate     LIKE type_file.dat,                                 #No.FUN-680098  date
          i,j,k,g_mm      LIKE type_file.num5,                                #No.FUN-680098  smallint
          g_unit          LIKE type_file.num10,              #金額單位基數    #No.FUN-680098  integer
          g_bookno       LIKE aah_file.aah00, #帳別
          g_mai02        LIKE mai_file.mai02,
          g_mai03        LIKE mai_file.mai03,
          g_tot1         ARRAY[100] OF  LIKE type_file.num20_6,     #No.FUN-680098  dec(20,6)
	  g_tot2         ARRAY[100] OF  LIKE type_file.num20_6,     #MOD-A70192
          g_basetot1     LIKE aah_file.aah04
   DEFINE g_basetot2     LIKE aah_file.aah04                        #MOD-A70192
   DEFINE g_aaa03        LIKE aaa_file.aaa03   
   DEFINE g_i            LIKE type_file.num5         #count/index for any purpose    #No.FUN-680098   smallint
   DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72) 
   DEFINE g_aaa09    LIKE aaa_file.aaa09   #MOD-730135
   DEFINE l_table         STRING                                                   
   DEFINE g_sql           STRING                                                   
   DEFINE g_str           STRING                                                   
   DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8C0018 ARRAY[10] OF VARCHAR(20)
   DEFINE g_str1         LIKE type_file.chr20        #FUN-9C0126
   DEFINE g_yy           LIKE type_file.num5         #FUN-9C0126
   DEFINE g_ss           LIKE type_file.num5         #FUN-9C0126
   DEFINE g_name1        LIKE type_file.chr100       #FUN-9C0126
   DEFINE g_zo16         LIKE zo_file.zo16           #FUN-9C0126
   DEFINE g_cmd          LIKE type_file.chr100       #FUN-9C0126
   DEFINE sheet1         STRING                      #FUN-9C0126
   DEFINE sheet2         STRING                      #FUN-9C0126
   DEFINE g_r            LIKE type_file.num5         #FUN-A50069
###GENGRE###START
TYPE sr1_t RECORD
    maj31 LIKE maj_file.maj31,   #NO.FUN-B80158 ADD
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    bal1 LIKE aah_file.aah04,
    per1 LIKE rmc_file.rmc31,
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
 #  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114#FUN-B80158
 
   LET g_sql = "maj31.maj_file.maj31,",      #NO.FUN-B80158 add
               "maj20.maj_file.maj20,",                                         
               "maj20e.maj_file.maj20e,",                                       
               "maj02.maj_file.maj02,",   #項次(排序要用的)                     
               "maj03.maj_file.maj03,",   #列印碼     
               "bal1.aah_file.aah04,",    #期初借 
               "per1.rmc_file.rmc31,",
              #NO.FUN-A10098  ---start---
              #"line.type_file.num5,",    #1:表示此筆為空行 2:表示此筆不為空   
              #"plant.azp_file.azp01"     #FUN-8C0018
               "line.type_file.num5"
              #NO.FUN-A10098  ----end---
 
   LET l_table = cl_prt_temptable('aglg110',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN 
      #CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add#FUN-B80158 mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008 
               " VALUES(?,?,?,?,?, ?,?,? )"             #FUN-8C0018      #FUN-A10098 去掉1個 ?   #NO.FUN-B80158 ADD ?           
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add#FUN-B80158 mark
      EXIT PROGRAM                         
   END IF          
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B80158
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)   #TQC-610056
   LET tm.yy = ARG_VAL(11)
   LET tm.bm = ARG_VAL(12)
   LET tm.em = ARG_VAL(13)
   LET tm.dd = ARG_VAL(14)
   LET tm.c  = ARG_VAL(15)
   LET tm.d  = ARG_VAL(16)
   LET tm.e  = ARG_VAL(17)
   LET tm.f  = ARG_VAL(18)
   LET tm.h  = ARG_VAL(19)
   LET tm.o  = ARG_VAL(20)
   LET tm.p  = ARG_VAL(21)
   LET tm.q  = ARG_VAL(22)
   LET tm.r  = ARG_VAL(23)   #TQC-610056
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
 #NO.FUN-A10098  ----start---- 
 # LET tm.bb    = ARG_VAL(28)
 # LET tm.b_1   = ARG_VAL(29)   #by jan add
 # LET tm.p1    = ARG_VAL(30)
 # LET tm.p2    = ARG_VAL(31)
 # LET tm.p3    = ARG_VAL(32)
 # LET tm.p4    = ARG_VAL(33)
 # LET tm.p5    = ARG_VAL(34)
 # LET tm.p6    = ARG_VAL(35)
 # LET tm.p7    = ARG_VAL(36)
 # LET tm.p8    = ARG_VAL(37)
 # LET tm.xbrl  = ARG_VAL(38)
 # LET tm.exp   = ARG_VAL(39)
   LET tm.xbrl  = ARG_VAL(28)
   LET tm.exp   = ARG_VAL(29)
 #NO.FUN-A10098  ----end---
 
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64 
   END IF
   IF cl_null(tm.b) THEN
      LET tm.b = g_aza.aza81
   END IF 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL g110_tm()
   ELSE
      IF tm.xbrl = 'N' THEN   #FUN-9C0126
         CALL g110()
      ELSE                    #FUN-9C0126
         CALL g110_xbrl()     #FUN-9C0126
      END IF                  #FUN-9C0126
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
END MAIN
 
FUNCTION g110_tm()
   DEFINE p_row,p_col  LIKE type_file.num5,      #No.FUN-680098  smallint
          l_sw         LIKE type_file.chr1,      #重要欄位是否空白  #No.FUN-680098   VARCHAR(1) 
          l_cmd        LIKE type_file.chr1000    #No.FUN-680098      VARCHAR(400)           
   DEFINE li_chk_bookno   LIKE type_file.num5    #No.FUN-670005     #No.FUN-680098  smallint
   DEFINE li_result    LIKE type_file.num5       #No.FUN-6C0068   
   DEFINE  l_bdate,l_edate   LIKE type_file.dat   #FUN-8B0098  date
   DEFINE  l_flag     LIKE type_file.chr1         #FUN-8B0098 add
 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW g110_w AT p_row,p_col
     WITH FORM "agl/42f/aglg110"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660123
   END IF
 
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)   #No.FUN-660123
   END IF
 
   LET tm.b = g_aza.aza81    #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.f = 0
   LET tm.h = 'N'
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET tm.xbrl = 'N'
   LET tm.exp  = ' '
   LET g_unit  = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.acc_code = 'N'   #NO.FUN-B80158 add
  #NO.FUN-A10098 ----start---
  #LET tm.bb ='N'
  #LET tm.b_1 ='N'   #add by jan
  #LET tm.p1=g_plant
  #NO.FUN-A10098 ----end---
   CALL g110_set_entry_1()               
   CALL g110_set_no_entry_1()    
 
   WHILE TRUE
 
      LET l_sw = 1
 
      INPUT BY NAME tm.rtype,
                  # tm.bb,tm.b_1,tm.p1,tm.p2,tm.p3,    #FUN-8C0018  #FUN-A10098 mark
                  # tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,     #FUN-8C0018  #FUN-A10098 mark
                    tm.b,tm.a,tm.yy,tm.bm,tm.em,tm.dd,    #No.FUN-740020
                    tm.e,tm.f,tm.d,tm.acc_code,tm.c,tm.h,             #NO.FUN-B80158   Add tm.acc_code
                    tm.xbrl,tm.exp,                       #No.FUN-9C0126
                    tm.o,tm.r,
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
             CALL cl_qbe_init()
             LET tm.xbrl = 'N'                                   #No.FUN-9C0126
             LET tm.exp  = ' '                                   #No.FUN-9C0126
             DISPLAY BY NAME tm.xbrl,tm.exp                      #No.FUN-9C0126
             CALL cl_set_comp_entry("exp",FALSE)                 #No.FUN-9C0126

   #NO.FUN-A10098  ---start--- 
   #  AFTER FIELD bb
   #      IF NOT cl_null(tm.bb)  THEN
   #         IF tm.bb NOT MATCHES "[YN]" THEN
   #            NEXT FIELD bb       
   #         END IF
   #      END IF
   #NO.FUN-A10098  ---end---
          
      ON CHANGE xbrl
          LET tm.d = '2'    #XBRL限制以千为单位转入 
          DISPLAY BY NAME tm.d
          CALL g110_set_entry_1()      
          CALL g110_set_no_entry_1()                             

   #NO.FUN-A10098  ---start---                 
   #   ON CHANGE  bb
   #      LET tm.p1=g_plant
   #      LET tm.p2=NULL
   #      LET tm.p3=NULL
   #      LET tm.p4=NULL
   #      LET tm.p5=NULL
   #      LET tm.p6=NULL
   #      LET tm.p7=NULL
   #      LET tm.p8=NULL
   #      DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
   #      CALL g110_set_entry_1()      
   #      CALL g110_set_no_entry_1()
   #                                   
   #  AFTER FIELD b_1
   #      IF NOT cl_null(tm.b_1)  THEN
   #         IF tm.b_1 NOT MATCHES "[YN]" THEN
   #            NEXT FIELD b_1      
   #         END IF
   #      END IF
 
   #  AFTER FIELD p1
   #     IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
   #     SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
   #     IF STATUS THEN 
   #        CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
   #        NEXT FIELD p1 
   #     END IF
   #        CALL s_chk_demo(g_user,tm.p1) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p1
   #        END IF 
 
   #  AFTER FIELD p2
   #     IF NOT cl_null(tm.p2) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
   #           NEXT FIELD p2 
   #        END IF
   #        CALL s_chk_demo(g_user,tm.p2) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p2
   #        END IF 
   #     END IF
 
   #  AFTER FIELD p3
   #     IF NOT cl_null(tm.p3) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
   #           NEXT FIELD p3 
   #        END IF
   #        CALL s_chk_demo(g_user,tm.p3) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p3
   #        END IF 
   #     END IF
 
   #  AFTER FIELD p4
   #     IF NOT cl_null(tm.p4) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
   #           NEXT FIELD p4 
   #        END IF
   #        CALL s_chk_demo(g_user,tm.p4) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p4
   #        END IF 
   #     END IF
 
   #  AFTER FIELD p5
   #     IF NOT cl_null(tm.p5) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
   #           NEXT FIELD p5 
   #        END IF
   #        CALL s_chk_demo(g_user,tm.p5) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p5
   #        END IF 
   #     END IF
 
   #  AFTER FIELD p6
   #     IF NOT cl_null(tm.p6) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
   #           NEXT FIELD p6 
   #        END IF
   #        CALL s_chk_demo(g_user,tm.p6) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p6
   #        END IF 
   #     END IF
 
   #  AFTER FIELD p7
   #     IF NOT cl_null(tm.p7) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
   #           NEXT FIELD p7 
   #        END IF
   #        CALL s_chk_demo(g_user,tm.p7) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p7
   #        END IF 
   #     END IF
 
   #  AFTER FIELD p8
   #     IF NOT cl_null(tm.p8) THEN
   #        SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
   #        IF STATUS THEN 
   #           CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
   #           NEXT FIELD p8 
   #        END IF
   #        CALL s_chk_demo(g_user,tm.p8) RETURNING li_result
   #        IF not li_result THEN 
   #         NEXT FIELD p8
   #        END IF 
   #     END IF       
   #NO.FUN-A10098  ----end---
    
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()                  #MOD-A30135
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      
         BEFORE FIELD rtype 
            CALL g110_set_entry()  
      
         AFTER FIELD rtype 
            IF tm.rtype='1' THEN
               LET tm.bm=0
               CALL g110_set_no_entry()
            END IF
      
         #AFTER FIELD a    #FUN-A50069 mark
         ON CHANGE a       #FUN-A50069 add
            IF tm.a IS NULL THEN
               NEXT FIELD a 
            END IF
 
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
 
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
             WHERE mai01 = tm.a 
               AND mai00 = tm.b    #No.FUN-740020
               AND maiacti IN ('Y','y')
            IF STATUS THEN 
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
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN 
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
      
         BEFORE FIELD bm
            IF tm.rtype='1' THEN
               LET tm.bm = 0
               DISPLAY '' TO bm
            END IF
      
         AFTER FIELD bm
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
            IF tm.bm IS NULL THEN
               NEXT FIELD bm 
            END IF
     
         AFTER FIELD em
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
            IF tm.em IS NULL THEN
               NEXT FIELD em
            END IF
      
         AFTER FIELD dd
            IF tm.dd IS NOT NULL THEN
               #CALL s_azm(tm.yy,tm.em) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
               #CHI-A70007 add --start--
               IF g_aza.aza63 = 'Y' THEN
                  CALL s_azmm(tm.yy,tm.em,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
               ELSE
                  CALL s_azm(tm.yy,tm.em) RETURNING l_flag,l_bdate,l_edate                  
               END IF
               #CHI-A70007 add --end--
               IF tm.dd < 0 OR tm.dd > DAY(l_edate) THEN
                  CALL cl_err('','-1206',0)
                  NEXT FIELD dd
               END IF
            END IF
      
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
            IF tm.f IS NULL OR tm.f < 0  THEN
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
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p AND aziacti = 'Y'
            IF SQLCA.sqlcode THEN
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
            IF tm.bm IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm 
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
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_mai'
               LET g_qryparam.default1 = tm.a
              #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042   Mark
               LET g_qryparam.where = " mai00 = '",tm.b,"'  AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            END IF
 
            IF INFIELD(b) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b 
               DISPLAY BY NAME tm.b
               NEXT FIELD b
            END IF
 
            IF INFIELD(p) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
               DISPLAY BY NAME tm.p
               NEXT FIELD p
            END IF
            
         #NO.FUN-A10098  ----start----
         #  IF INFIELD(p1) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p1
         #     CALL cl_create_qry() RETURNING tm.p1
         #     DISPLAY BY NAME tm.p1
         #     NEXT FIELD p1
         #  END IF

         #  IF INFIELD(p2) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p2
         #     CALL cl_create_qry() RETURNING tm.p2
         #     DISPLAY BY NAME tm.p2
         #     NEXT FIELD p2
         #  END IF
         #  IF INFIELD(p3) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p3
         #     CALL cl_create_qry() RETURNING tm.p3
         #     DISPLAY BY NAME tm.p3
         #     NEXT FIELD p3
         #  END IF
         #  IF INFIELD(p4) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p4
         #     CALL cl_create_qry() RETURNING tm.p4
         #     DISPLAY BY NAME tm.p4
         #     NEXT FIELD p4
         #  END IF
         #  IF INFIELD(p5) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p5
         #     CALL cl_create_qry() RETURNING tm.p5
         #     DISPLAY BY NAME tm.p5
         #     NEXT FIELD p5
         #  END IF
         #  IF INFIELD(p6) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p6
         #     CALL cl_create_qry() RETURNING tm.p6
         #     DISPLAY BY NAME tm.p6
         #     NEXT FIELD p6
         #  END IF
         #  IF INFIELD(p7) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p7
         #     CALL cl_create_qry() RETURNING tm.p7
         #     DISPLAY BY NAME tm.p7
         #     NEXT FIELD p7
         #  END IF
         #  IF INFIELD(p8) THEN
         #     CALL cl_init_qry_var()
         #     LET g_qryparam.form = 'q_azp'
         #     LET g_qryparam.default1 = tm.p8
         #     CALL cl_create_qry() RETURNING tm.p8
         #     DISPLAY BY NAME tm.p8
         #     NEXT FIELD p8
         #  END IF            
         #NO.FUN-A10098   ---end---        
 
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
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g110_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
         EXIT PROGRAM
      END IF
      
     #-MOD-B40063-add-
      IF tm.o = 'Y' THEN  
         SELECT azi04 INTO t_azi04
           FROM azi_file 
          WHERE azi01 = tm.p 
      END IF
     #-MOD-B40063-end-

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg110'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg110','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.rtype CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",   #TQC-610056
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.dd CLIPPED,"'",
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
                         " '",g_rpt_name CLIPPED,"'"           #No.FUN-7C0078
                       #NO.FUN-A10098  ----start---
                       # " '",tm.bb CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.b_1 CLIPPED,"'" ,  #FUN-8C0018 jan
                       # " '",tm.p1 CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.p2 CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.p3 CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.p4 CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.p5 CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.p6 CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.p7 CLIPPED,"'" ,   #FUN-8C0018
                       # " '",tm.p8 CLIPPED,"'"     #FUN-8C0018
                       #NO.FUN-A10098  ---end----
            CALL cl_cmdat('aglg110',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW g110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      IF tm.xbrl='N' THEN  #FUN-9C0126
         CALL g110()
      ELSE                 #FUN-9C0126
         CALL g110_xbrl()  #FUN-9C0126
      END IF               #FUN-9C0126
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g110_w
 
END FUNCTION
 
FUNCTION g110_set_entry_1()
   #CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8,b_1",TRUE)  #by jan add b_1  #FUN-A10098 mark
    CALL cl_set_comp_entry("exp,d",TRUE)  #FUN-9C0126
END FUNCTION
FUNCTION g110_set_no_entry_1()
  #NO.FUN-A10098  ---start---
  # IF tm.bb = 'N' THEN
  #    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8,b_1",FALSE) #by jan add b_1
  #    LET tm.b_1 = 'N'
  #    DISPLAY BY NAME tm.b_1
  # END IF
  #NO.FUN-A10098  ---end---

    IF tm.xbrl = 'N' THEN
       CALL cl_set_comp_entry("exp",FALSE)
    ELSE
       CALL cl_set_comp_entry("d",FALSE)
    END IF
END FUNCTION
 
FUNCTION g110()
   DEFINE l_name    LIKE type_file.chr20     # External(Disk) file name         #No.FUN-680098  VARCHAR(20)
   DEFINE l_sql     LIKE type_file.chr1000   # RDSQL STATEMENT  #No.FUN-680098 VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1) 
   DEFINE amt1      LIKE aah_file.aah04
   DEFINE l_tmp     LIKE aah_file.aah04
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE sr        RECORD
                       bal1      LIKE aah_file.aah04
                    END RECORD
   DEFINE  l_bdate,l_edate   LIKE type_file.dat   #No.FUN-8B0098  date
   DEFINE  l_flag     LIKE type_file.chr1         #FUN-8B0098 add
 
   DEFINE l_endy1   LIKE abb_file.abb07 
   DEFINE l_endy2   LIKE abb_file.abb07
   DEFINE per1      LIKE rmc_file.rmc31    #No.FUN-780058
   DEFINE     l_azp03    LIKE azp_file.azp03
   DEFINE     l_dbs      LIKE azp_file.azp03
   DEFINE     l_i        LIKE type_file.num5
   DEFINE     i          LIKE type_file.num5
   
   CALL cl_del_data(l_table)               #No.FUN-780058
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
 
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE LET g_msg = " 1=1" 
   END CASE
 
   LET g_basetot1 = NULL   #MOD-850004 add

 #NO.FUN-A10098  ---start----   
 # FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
 # LET m_dbs[1]=tm.p1
 # LET m_dbs[2]=tm.p2
 # LET m_dbs[3]=tm.p3
 # LET m_dbs[4]=tm.p4
 # LET m_dbs[5]=tm.p5
 # LET m_dbs[6]=tm.p6
 # LET m_dbs[7]=tm.p7
 # LET m_dbs[8]=tm.p8
 # 
 # FOR l_i = 1 to 8
 #     IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
 #     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
 #     LET l_azp03 = l_dbs CLIPPED
 #     LET l_dbs = s_dbstring(l_dbs)
 
 # LET l_sql = "SELECT * FROM ",l_dbs CLIPPED," maj_file",  #FUN-8C0018
   LET l_sql = "SELECT * FROM maj_file",
 #FUN-A10098  -----end----
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g110_p FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)   
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
      EXIT PROGRAM 
   END IF
   DECLARE g110_c CURSOR FOR g110_p
 
   #-->計算至日餘額時住前減一期
   IF cl_null(tm.dd) THEN
      LET g_mm = tm.em
   ELSE
      LET g_mm = tm.em - 1
      LET bdate = MDY(tm.em,01,tm.yy)
      LET edate = MDY(tm.em,tm.dd,tm.yy)
   END IF
 
   FOR g_i = 1 TO 100
      LET g_tot1[g_i] = 0 
   END FOR
#FUN-C50004 sta
   LET l_sql = " SELECT SUM(aah04-aah05) ",
               " FROM aah_file,aag_file ",
               " WHERE aah00 = '",tm.b,"' ",
               " AND aag00 = '",tm.b,"' ",  
               " AND aah01 BETWEEN ? AND ? ",
               " AND aah02 = '",tm.yy,"' ",
               " AND aah03 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
               " AND aah01 = aag01 ",
               " AND aag07 IN ('2','3') "
  PREPARE g110_prepare1 FROM l_sql                                                                                          
  DECLARE g110_c1  CURSOR FOR g110_prepare1 

  LET l_sql = " SELECT SUM(aao05-aao06) ",
              " FROM aao_file,aag_file ",                    
              " WHERE aao00 = '",tm.b,"' ",
              " AND aag00 = '",tm.b,"' ",   
              " AND aao01 BETWEEN ? AND ? ",
              " AND aao02 BETWEEN ? AND ? ",
              " AND aao03 = '",tm.yy,"' ",
              " AND aao04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
              " AND aao01 = aag01 ",
              " AND aag07 IN ('2','3') "
  PREPARE g110_prepare2 FROM l_sql                                                                                          
  DECLARE g110_c2  CURSOR FOR g110_prepare2     

  LET l_sql = "SELECT aaa09 FROM aaa_file",
              " WHERE aaa01 = '",tm.b,"' "      
  PREPARE g110_prepare6 FROM l_sql                                                                                          
  DECLARE g110_c6  CURSOR FOR g110_prepare6                                                                                


  LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",
              " WHERE abb00 = '",tm.b,"' ",
              "   AND aag00 = '",tm.b,"' ",     
              "   AND aba00 = abb00 AND aba01 = abb01 ",
              "   AND abb03 BETWEEN ? AND ? ",
              "   AND aba06 = 'CE' AND abb06 = '1' AND aba03 = '",tm.yy,"' ",
              "   AND aba04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
              "   AND abapost = 'Y' ",
              "   AND abb03 = aag01 ", 
              "   AND aag03 <> '4' "   
  PREPARE g110_prepare3 FROM l_sql                                                                                          
  DECLARE g110_c3  CURSOR FOR g110_prepare3    

  LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",
              " WHERE abb00 = '",tm.b,"' ",
              " AND aag00 = '",tm.b,"' ",   
              " AND aba00 = abb00 AND aba01 = abb01 ",
              " AND abb03 BETWEEN ? AND ? ",
              " AND aba06 = 'CE' AND abb06 = '2' AND aba03 = '",tm.yy,"' ",
              " AND aba04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
              " AND abapost = 'Y' ",
              " AND abb03 = aag01 ",  
              " AND aag03 <> '4' "    
  PREPARE g110_prepare4 FROM l_sql                                                                                          
  DECLARE g110_c4  CURSOR FOR g110_prepare4    

  LET l_sql = "SELECT SUM(aas04-aas05) ",
              " FROM aas_file,aag_file ",
              " WHERE aas00 = '",tm.b,"' ",
              " AND aag00 = '",tm.b,"' ",  
              " AND aas01 BETWEEN ? AND ? ",
              " AND aas02 BETWEEN '",bdate,"' AND '",edate,"' ",
              " AND aas01 = aag01 ",
              " AND aag07 IN ('2','3') "
  PREPARE g110_prepare5 FROM l_sql                                                                                          
  DECLARE g110_c5  CURSOR FOR g110_prepare5                                                                                 
                                      
#FUN-C50004 end 
   FOREACH g110_c INTO maj.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
 
      LET amt1 = 0
 
      IF NOT cl_null(maj.maj21) THEN
         IF cl_null(maj.maj22) THEN
            LET maj.maj22 = maj.maj21
         END IF
         IF maj.maj24 IS NULL THEN
            #FUN-C50004 mark sta
            #LET l_sql = " SELECT SUM(aah04-aah05) ",
            #          #NO.FUN-A10098  ----start---
            #          # " FROM ",l_dbs CLIPPED," aah_file,",l_dbs CLIPPED," aag_file ",
            #            " FROM aah_file,aag_file ",
            #          #NO.FUN-A10098  ----end---
            #            " WHERE aah00 = '",tm.b,"' ",
            #            " AND aag00 = '",tm.b,"' ",  
            #            " AND aah01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
            #            " AND aah02 = '",tm.yy,"' ",
            #            " AND aah03 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
            #            " AND aah01 = aag01 ",
            #            " AND aag07 IN ('2','3') "
            #PREPARE g110_prepare1 FROM l_sql                                                                                          
            #DECLARE g110_c1  CURSOR FOR g110_prepare1                                                                                 
            #OPEN g110_c1                                
            #FUN-C50004 mark end 
            OPEN g110_c1 USING  maj.maj21,maj.maj22 #FUN-C50004 add           
            FETCH g110_c1 INTO amt1
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("sel","aah_file,aag_file",tm.b,tm.yy,STATUS,"","sel aah:",1)   #No.FUN-660123
               EXIT FOREACH 
            END IF
         ELSE
            #FUN-C50004 mark sta
            #LET l_sql = " SELECT SUM(aao05-aao06) ",
            #          #NO.FUN-A10098  ----start---
            #          # " FROM ",l_dbs CLIPPED," aao_file,",l_dbs CLIPPED," aag_file ",
            #            " FROM aao_file,aag_file ",
            #          #NO.FUN-A10098   ----end---
            #            " WHERE aao00 = '",tm.b,"' ",
            #            " AND aag00 = '",tm.b,"' ",   
            #            " AND aao01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
            #            " AND aao02 BETWEEN '",maj.maj24,"' AND '",maj.maj25,"' ",
            #            " AND aao03 = '",tm.yy,"' ",
            #            " AND aao04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
            #            " AND aao01 = aag01 ",
            #            " AND aag07 IN ('2','3') "
            #PREPARE g110_prepare2 FROM l_sql                                                                                          
            #DECLARE g110_c2  CURSOR FOR g110_prepare2                                                                                 
            #OPEN g110_c2  
            #FUN-C50004 mark end   
            OPEN g110_c2 USING maj.maj21,maj.maj22,maj.maj24,maj.maj25   #FUN-C50004 add            
            FETCH g110_c2 INTO amt1
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("sel","aao_file,aag_file",tm.yy,"",STATUS,"","sel aao:",1)   #No.FUN-660123
               EXIT FOREACH 
            END IF
         END IF
 
         IF amt1 IS NULL THEN
            LET amt1 = 0 
         END IF
 
         LET g_aaa09 = ''
        #NO.FUN-A10098  ----start---
        #LET l_sql = "SELECT aaa09 FROM ",l_dbs CLIPPED," aaa_file",
        #FUN-C50004 mark sta
         #LET l_sql = "SELECT aaa09 FROM aaa_file",
        #NO.FUN-A10098  ----end----
         #            " WHERE aaa01 = '",tm.b,"' "      #No.TQC-950043
         #PREPARE g110_prepare6 FROM l_sql                                                                                          
         #DECLARE g110_c6  CURSOR FOR g110_prepare6 
         #FUN-C50004 mark end                                                                               
         OPEN g110_c6                                                                                  
         FETCH g110_c6 INTO g_aaa09
         
         IF g_aaa09 = '2' THEN
           #NO.FUN-A10098  ---start----
           #LET l_sql = "SELECT SUM(abb07) FROM ",l_dbs CLIPPED," abb_file,",l_dbs CLIPPED," aba_file,",l_dbs CLIPPED," aag_file ",  
           #FUN-C50004 mark sta
            #LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",
           #NO.FUN-A10098  ----start---
            #            " WHERE abb00 = '",tm.b,"' ",
            #            "   AND aag00 = '",tm.b,"' ",     
            #            "   AND aba00 = abb00 AND aba01 = abb01 ",
            #            "   AND abb03 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
            #            "   AND aba06 = 'CE' AND abb06 = '1' AND aba03 = '",tm.yy,"' ",
            #            "   AND aba04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
            #            "   AND abapost = 'Y' ",
            #            "   AND abb03 = aag01 ", 
            #            "   AND aag03 <> '4' "   
            #PREPARE g110_prepare3 FROM l_sql                                                                                          
            #DECLARE g110_c3  CURSOR FOR g110_prepare3                                                                                 
            #OPEN g110_c3    
            #FUN-C50004 mark end
            OPEN g110_c3 USING maj.maj21,maj.maj22   #FUN-C50004 add               
            FETCH g110_c3 INTO l_endy1
          #NO.FUN-A10098  ----start---
          # LET l_sql = "SELECT SUM(abb07) FROM ",l_dbs CLIPPED," abb_file,",l_dbs CLIPPED," aba_file,",l_dbs CLIPPED," aag_file ", 
          #FUN-C50004 mark sta
           #LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",
          #NO.FUN-A10098  ----end---      
           #             " WHERE abb00 = '",tm.b,"' ",
           #             " AND aag00 = '",tm.b,"' ",   
           #             " AND aba00 = abb00 AND aba01 = abb01 ",
           #             " AND abb03 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
           #             " AND aba06 = 'CE' AND abb06 = '2' AND aba03 = '",tm.yy,"' ",
           #             " AND aba04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
           #             " AND abapost = 'Y' ",
           #             " AND abb03 = aag01 ",  
           #             " AND aag03 <> '4' "    
           # PREPARE g110_prepare4 FROM l_sql                                                                                          
           # DECLARE g110_c4  CURSOR FOR g110_prepare4                                                                                 
           # OPEN g110_c4   
           #FUN-C50004 mark end
            OPEN g110_c4 USING maj.maj21,maj.maj22 #FUN-C50004 add           
            FETCH g110_c4 INTO l_endy2
            
            IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
            IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
            LET amt1 = amt1 - (l_endy1 - l_endy2)
          END IF
 
         IF NOT cl_null(tm.dd) THEN
            #FUN-C50004 mark sta
            #LET l_sql = "SELECT SUM(aas04-aas05) ",
                       #NO.FUN-A10098  ---start---
                       #" FROM ",l_dbs CLIPPED," aas_file,",l_dbs CLIPPED," aag_file ",
            #            " FROM aas_file,aag_file ",
                       #NO.FUN-A10098   ----end---
            #            " WHERE aas00 = '",tm.b,"' ",
            #            " AND aag00 = '",tm.b,"' ",  
            #            " AND aas01 BETWEEN '",maj.maj21,"' AND '",maj.maj22,"' ",
            #            " AND aas02 BETWEEN '",bdate,"' AND '",edate,"' ",
            #            " AND aas01 = aag01 ",
            #            " AND aag07 IN ('2','3') "
            #PREPARE g110_prepare5 FROM l_sql                                                                                          
            #DECLARE g110_c5  CURSOR FOR g110_prepare5                                                                                 
            #OPEN g110_c5
            #FUN-C50004 mark end
            OPEN g110_c5 USING  maj.maj21,maj.maj22 #FUN-C50004 add           
            FETCH g110_c5 INTO l_tmp
            IF STATUS THEN 
               CALL cl_err3("sel","aas_file,aag_file",tm.b,"",STATUS,"","sel aas:",1)   #No.FUN-660123
               EXIT FOREACH
            END IF
            IF l_tmp IS NULL THEN 
               LET l_tmp = 0 
            END IF
            LET amt1 = amt1 + l_tmp
         END IF
      END IF
 
      #-->匯率的轉換
      IF tm.o = 'Y' THEN 
         LET amt1 = amt1 * tm.q
      END IF 
 
      #-->合計階數處理
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN
         FOR i = 1 TO 100
            IF maj.maj09 = '-' THEN               #FUN-B80158(MOD-BB0296)
               LET g_tot1[i] = g_tot1[i] - amt1   #FUN-B80158(MOD-BB0296) 
            ELSE                                  #FUN-B80158(MOD-BB0296)
               LET g_tot1[i] = g_tot1[i] + amt1
            END IF                                #FUN-B80158(MOD-BB0296)
         END FOR
 
         LET k = maj.maj08
         LET sr.bal1 = g_tot1[k]
 
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN        #FUN-B80158(MOD-B90188) add
            LET sr.bal1 = sr.bal1 * -1                      #FUN-B80158(MOD-B90188) add
         END IF                                             #FUN-B80158(MOD-B90188) add         

         FOR i = 1 TO maj.maj08
            LET g_tot1[i] = 0
         END FOR
      ELSE
         IF maj.maj03 = '5' THEN
            LET sr.bal1 = amt1
         ELSE
            LET sr.bal1 = NULL
         END IF
      END IF
 
      #-->百分比基準科目
      IF maj.maj11 = 'Y' THEN                  
         LET g_basetot1 = sr.bal1
         IF g_basetot1 = 0 THEN
            LET g_basetot1 = NULL
         END IF
         IF maj.maj07='2' THEN
            LET g_basetot1 = g_basetot1 * -1
         END IF
         LET g_basetot1=g_basetot1/g_unit #CHI-A70046 add
      END IF
 
      IF maj.maj03 = '0' THEN 
         CONTINUE FOREACH 
      END IF #本行不印出
 
      #-->餘額為 0 者不列印
      IF (tm.c='N' OR maj.maj03='2') AND maj.maj03 MATCHES "[0125]" AND sr.bal1=0 THEN
         CONTINUE FOREACH                        
      END IF
 
      #-->最小階數起列印
      IF tm.f>0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                        
      END IF
 
      IF maj.maj07 = '2' THEN                                                
         LET sr.bal1 = sr.bal1 * -1                                          
      END IF   
      IF tm.h = 'Y' THEN                                                        
         LET maj.maj20 = maj.maj20e                                             
      END IF                                                                    
      LET maj.maj20 = maj.maj05 SPACES,maj.maj20                                
      LET sr.bal1=sr.bal1/g_unit             
      LET per1 = 0                              #MOD-850004 add
 
      IF maj.maj04 = 0 THEN                                                     
         EXECUTE insert_prep USING                                              
             maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03,    #NO.FUN-B80158 add   maj.maj31                        
            sr.bal1,per1,                          
           #'2',m_dbs[l_i]            #FUN-8C0018   #FUN-A10098                                                             
            '2'                                     #FUN-A10098 
      ELSE                                                                      
         EXECUTE insert_prep USING                                              
            maj.maj31,maj.maj20,maj.maj20e,maj.maj02,maj.maj03,            #NO.FUN-B80158 add maj.maj31              
            sr.bal1,per1,                          
           #'2',m_dbs[l_i]            #FUN-8C0018   #FUN-A10098
            '2'                                     #FUN-A10098                                                              
         #空行的部份,以寫入同樣的maj20資料列進Temptable,                        
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,              
         #讓空行的這筆資料排在正常的資料前面印出                                
         FOR i = 1 TO maj.maj04                                                 
            EXECUTE insert_prep USING                                           
              maj.maj31,maj.maj20,maj.maj20e,maj.maj02,'',   #NO.FUN-B80158 add  maj.maj31                            
               '0','0',                                                 
             # '1',m_dbs[l_i]            #FUN-8C0018   #FUN-A10098
               '1'                                     #FUN-A10098
         END FOR                                                                
      END IF 
                             
   END FOREACH
 # END FOR                              #FUN-8C0018    #FUN-A10098
 
   IF cl_null(tm.dd) THEN
      #CALL s_azm(tm.yy,tm.em) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.yy,tm.em,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(tm.yy,tm.em) RETURNING l_flag,l_bdate,l_edate                  
      END IF
      #CHI-A70007 add --end--
      LET tm.dd=DAY(l_edate)
   END IF
 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",tm.bm,";",               
###GENGRE###               tm.em,";",tm.e,";",g_basetot1,";",   #MOD-850004 add g_basetot1
###GENGRE###              #NO.FUN-A10098  ---start--- 
###GENGRE###              #tm.rtype,";",tm.dd,";",              #FUN-8B0098 add
###GENGRE###              #tm.bb,";",tm.b_1                     #No.FUN-8C0018 #by jan add tm.b_1
###GENGRE###               tm.rtype,";",tm.dd
###GENGRE###   CALL cl_prt_cs3('aglg110','aglg110',g_sql,g_str)
    CALL aglg110_grdata()    ###GENGRE###
  #IF tm.bb = 'N' THEN                                                  #No.FUN-8C0018
  #   CALL cl_prt_cs3('aglg110','aglg110',g_sql,g_str)
  #ELSE                                                                #No.FUN-8C0018
  #   CALL cl_prt_cs3('aglg110','aglg110_1',g_sql,g_str)               #No.FUN-8C0018
  #END IF                
  #NO.FUN-A10098  ---end---
 
   IF cl_null(l_flag) THEN    #FUN-8B0098
      ELSE
      LET tm.dd =""
   END IF
 
END FUNCTION
 
FUNCTION g110_set_entry() 
 
   IF INFIELD(rtype) THEN
      CALL cl_set_comp_entry("bm",TRUE)
   END IF 
 
END FUNCTION
 
FUNCTION g110_set_no_entry()
 
   IF INFIELD(rtype) AND tm.rtype = '1' THEN
      CALL cl_set_comp_entry("bm",FALSE)
   END IF 
 
END FUNCTION

FUNCTION g110_xbrl()   
   DEFINE sr         RECORD
                        bal1      LIKE aah_file.aah04,
                        bal2      LIKE aah_file.aah04
                     END RECORD 
   DEFINE l_maj      RECORD LIKE maj_file.*
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_dbs      LIKE azp_file.azp03
   DEFINE l_sql      LIKE type_file.chr1000
   DEFINE l_name     LIKE type_file.chr50
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_bdate    LIKE type_file.dat
   DEFINE l_edate    LIKE type_file.dat
   DEFINE l_url      LIKE type_file.chr100
   DEFINE l_date     LIKE type_file.dat
   DEFINE l_azn02    LIKE azn_file.azn02
   DEFINE l_azn04    LIKE azn_file.azn04
   DEFINE l_azn05    LIKE azn_file.azn05
   DEFINE l_cmd      LIKE type_file.chr100
   DEFINE l_r        LIKE type_file.num5
   DEFINE li_result  LIKE type_file.num5
   DEFINE l_unixpath LIKE type_file.chr100
   DEFINE l_winpath  LIKE type_file.chr100
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_code     LIKE type_file.num10
   DEFINE l_ze03     LIKE ze_file.ze03
   DEFINE l_year     LIKE type_file.chr4  #FUN-A50069 add
   DEFINE l_month    LIKE type_file.chr4  #FUN-A50069 add
   DEFINE l_day      LIKE type_file.chr4  #FUN-A50069 add
   DEFINE l_ze03_s   STRING      #FUN-A60039
DEFINE l_amt1    LIKE aah_file.aah04      #MOD-A70192
DEFINE l_amt2    LIKE aah_file.aah04      #MOD-A70192
DEFINE l_bal1    LIKE aah_file.aah04      #MOD-A70192
DEFINE l_bal2    LIKE aah_file.aah04      #MOD-A70192

   CALL cl_del_data(l_table)              
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
#---------取报表类别                                                                                                                
   SELECT zo16 INTO g_zo16 FROM zo_file WHERE zo01=g_lang #上市（柜）公司代号                                                       
   LET g_yy = tm.yy - 1911                                #转民国年                                                                 
   LET l_date = g110_lastday()                                                                                                      
   CALL s_gactpd(l_date)                                                                                                            
        RETURNING l_flag,l_azn02,g_ss,l_azn04,l_azn05     #取季别
   LET l_date1 = g_today
   #LET l_time = g_time
   LET l_time = TIME(CURRENT)               #FUN-A50069 mod
   LET l_year = tm.yy USING '&&&&'          #FUN-A50069 add
   LET l_month = MONTH(l_date1) USING '&&'  #FUN-A50069 add
   LET l_day = DAY(l_date1) USING  '&&'     #FUN-A50069 add
   #LET l_dt   = l_date1[1,2],l_date1[4,5],l_date1[7,8], #FUN-A50069 mark
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,                    #FUN-A50069 mod
                l_time[1,2],l_time[4,5],l_time[7,8]
   IF tm.exp = '1' THEN
      IF g_mai03 <> '3' THEN
         LET g_str1 = 'A01'
      ELSE
         LET g_str1 = 'A02'
      END IF
      
      IF NOT cl_null(g_zo16) THEN
         LET g_str1[4,9] = g_zo16
      END IF
      IF NOT cl_null(g_yy) THEN
         LET g_str1[10,12] = g_yy USING '&&&'
      END IF
      IF NOT cl_null(g_ss) THEN
         LET g_str1[13,14] = g_ss USING '&&'
      END IF
      LET l_name = "aglg110",l_dt CLIPPED,".txt"
      LET g_name1 = FGL_GETENV("TEMPDIR") CLIPPED,'/',l_name
   ELSE
      SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='agl-512' AND ze02=g_lang
    # LET sheet1 = l_ze03            #FUN-A60039
      LET l_ze03_s = l_ze03          #FUN-A60039                                
      LET sheet1 = l_ze03_s.trim()   #FUN-A60039
      DISPLAY sheet1

      IF g_mai03 <> '3' THEN
        #LET l_unixpath = "$TOP/tool/report/aglg110_1.xls"   #FUN-A30049
         LET l_unixpath = os.Path.join( os.Path.join( os.Path.join(FGL_GETENV("TOP"),"tool"),"report"),"aglg110_1.xls")   #FUN-A30049
         LET l_winpath  = "C:\\TIPTOP\\aglg1101",l_dt CLIPPED,".xls"
         SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='agl-513' AND ze02=g_lang
      ELSE
        #LET l_unixpath = "$TOP/tool/report/aglg110_2.xls"   #FUN-A30049
         LET l_unixpath = os.Path.join( os.Path.join( os.Path.join(FGL_GETENV("TOP"),"tool"),"report"),"aglg110_2.xls")   #FUN-A30049
         LET l_winpath  = "C:\\TIPTOP\\aglg1102",l_dt CLIPPED,".xls"
         SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01='agl-514' AND ze02=g_lang
      END IF
    # LET sheet2 = l_ze03     #FUN-A60039 mark
      LET l_ze03_s = l_ze03   #FUN-A60039                                       
      LET sheet2 = l_ze03_s.trim()   #FUN-A60039
      LET li_result=cl_download_file(l_unixpath,l_winpath)
      IF STATUS THEN
         CALL cl_err('',"amd-021",1)
         DISPLAY "Download fail!!"
         LET g_success = 'N'
         RETURN
      END IF
      LET g_cmd = "EXCEL ",l_winpath
      CALL ui.Interface.frontCall("standard","shellexec",[g_cmd],[])
      SLEEP 10
      CALL ui.Interface.frontCall("WINDDE","DDEConnect",[g_cmd,sheet1],[li_result])
      CALL g110_checkError(li_result,"Connect DDE Sheet1")
      CALL g110_exceldata(1,' ',' ',' ',' ',' ')
      CALL ui.Interface.frontCall("WINDDE","DDEFinish",[l_cmd,sheet1],[li_result])
      CALL ui.Interface.frontCall("WINDDE","DDEConnect",[g_cmd,sheet2],[li_result])
      CALL g110_checkError(li_result,"Connect DDE Sheet2")
   END IF
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1'
        #  LET g_msg=" substr(maj23,1,1)='1'"
           LET g_msg=" maj23[1,1]='1'"   #FUN-B40029
        WHEN tm.rtype='2'
        #  LET g_msg=" substr(maj23,1,1)='2'"
            LET g_msg=" maj23[1,1]='2'"   #FUN-B40029
        OTHERWISE LET g_msg = " 1=1"
   END CASE
   LET g_basetot1 = NULL
#NO.FUN-A10098   ---start---
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4 
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
#  
#  FOR l_i = 1 to 8 
#     IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
#     SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
#     LET l_dbs = s_dbstring(l_dbs)
# 
#     LET l_sql = "SELECT * FROM ",l_dbs CLIPPED," maj_file",
      LET l_sql = "SELECT * FROM maj_file",
#NO.FUN-A10098  ----end--- 
                  " WHERE maj01 = '",tm.a,"'",
                  "   AND ",g_msg CLIPPED,
                  " ORDER BY maj02"
      PREPARE g110_pre1 FROM l_sql
      IF STATUS THEN        
         CALL cl_err('prepare:',STATUS,1)   
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
         EXIT PROGRAM  
      END IF
      DECLARE g110_curs1 CURSOR FOR g110_pre1
      FOR g_i = 1 TO 100
         LET g_tot1[g_i] = 0
      END FOR
      #--MOD-A70192 start--
      FOR g_i = 1 TO 100
         LET g_tot2[g_i] = 0
      END FOR
      #--MOD-A70192 end--
      
      #-->计算至日余额时往前减一期
      IF cl_null(tm.dd) THEN
         LET g_mm = tm.em
      ELSE 
         LET g_mm = tm.em - 1
         LET bdate = MDY(tm.em,01,tm.yy)
         LET edate = MDY(tm.em,tm.dd,tm.yy)
      END IF
      #---增加抓取会计期间落在哪一季的理---      

      #--------------------------------------                  
      #LET l_r = 0  #FUN-A50069 mark
      LET g_r = 0   #FUN-A50069 add
      FOREACH g110_curs1 INTO l_maj.*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         #--将计算金额的部份独立出来，以供後续要计算前一年金额时可以重复CALL FUNCTION---#                                           
         #CALL g110_xbrl_bal(tm.yy,l_maj.*) RETURNING sr.bal1    #今年金额    #MOD-A70192                                                          
         #CALL g110_xbrl_bal(tm.yy-1,l_maj.*) RETURNING sr.bal2  #去年金额    #MOD-A70192

         #---MOD-A70192 start--
         LET l_amt1 = 0
         LET l_amt2 = 0
         CALL g110_xbrl_bal(tm.yy,l_maj.*) RETURNING l_amt1      #今年金額  
         CALL g110_xbrl_bal(tm.yy-1,l_maj.*) RETURNING l_amt2    #去年金額 

         #--> 匯率的轉換
         IF tm.o = 'Y' THEN  
            LET l_amt1 = l_amt1 * tm.q
            LET l_amt2 = l_amt2 * tm.q
         END IF
         #-->合計階數處理
         IF l_maj.maj03 MATCHES "[012]" AND l_maj.maj08 > 0 THEN
            FOR i = 1 TO 100
               IF l_maj.maj09 = '-' THEN
                  LET g_tot1[i] = g_tot1[i] - l_amt1
                  LET g_tot2[i] = g_tot2[i] - l_amt2
               ELSE
                  LET g_tot1[i] = g_tot1[i] + l_amt1
                  LET g_tot2[i] = g_tot2[i] + l_amt2
               END IF
            END FOR
            LET k = l_maj.maj08
            LET l_bal1= g_tot1[k]
            LET l_bal2= g_tot2[k]
            IF l_maj.maj07 = '1' AND l_maj.maj09 = '-' THEN    #FUN-B80158(MOD-B90188) add
               LET l_bal1 = l_bal1 * -1                        #FUN-B80158(MOD-B90188) add
               LET l_bal2 = l_bal2 * -1                        #FUN-B80158(MOD-B90188)add
            END IF                                             #FUN-B80158(MOD-B90188) add
            FOR i = 1 TO l_maj.maj08
               LET g_tot1[i] = 0
               LET g_tot2[i] = 0
            END FOR
         ELSE
            IF l_maj.maj03 = '5' THEN
               LET l_bal1 = l_amt1
               LET l_bal2 = l_amt2
            ELSE
               LET l_bal1 = NULL
               LET l_bal2 = NULL
            END IF
         END IF
         #-->百分比基准科目
         IF l_maj.maj11 = 'Y' THEN
            LET g_basetot1 = l_bal1
            LET g_basetot2 = l_bal2
            IF g_basetot1 = 0 THEN
               LET g_basetot1 = NULL
            END IF
            IF g_basetot2 = 0 THEN
               LET g_basetot2 = NULL
            END IF

            IF l_maj.maj07='2' THEN
               LET g_basetot1 = g_basetot1 * -1
               LET g_basetot2 = g_basetot2 * -1
            END IF
         END IF

         IF l_maj.maj03 = '0' THEN 
            CONTINUE FOREACH 
         END IF #本行不印出

         #-->最小階數起列印
         IF tm.f>0 AND l_maj.maj08 < tm.f THEN
            CONTINUE FOREACH                        
         END IF

         IF l_maj.maj07 = '2' THEN
            LET l_bal1 = l_bal1 * -1
            LET l_bal2 = l_bal2 * -1
         END IF   

         IF tm.h = 'Y' THEN
            LET l_maj.maj20 = l_maj.maj20e
         END IF                 

         LET l_maj.maj20 = l_maj.maj05 SPACES,l_maj.maj20
         LET l_bal1=l_bal1/g_unit
         LET l_bal2=l_bal2/g_unit
         #---MOD-A70192 end-------
        #-MOD-B40063-add-
         IF tm.o = 'Y' THEN  
            LET l_bal1 = cl_digcut(l_bal1,t_azi04)
            LET l_bal2 = cl_digcut(l_bal2,t_azi04)
         ELSE                                        
            LET l_bal1 = cl_digcut(l_bal1,g_azi04)  
            LET l_bal2 = cl_digcut(l_bal2,g_azi04) 
         END IF
        #-MOD-B40063-end-
         #--FUN-A50069 start--
         #-->餘額為 0 者不列印
         IF (tm.c='N' OR l_maj.maj03='2') 
         AND l_maj.maj03 MATCHES "[0125]" THEN
             #IF (sr.bal1 = 0 AND sr.bal2=0) THEN
             IF (l_bal1 = 0 AND l_bal2=0) THEN  #MOD-A70192
                CONTINUE FOREACH                        
             END IF
         END IF
         #--FUN-A50069 end----

         #LET l_r = l_r +1   #FUN-A50069 mark
         LET g_r = g_r +1    #FUN-A50069 add
         #CALL g110_tofile(l_r,l_name,l_maj.maj21,l_maj.maj20,sr.bal1,sr.bal2)  #FUN-A50069 mark
         #CALL g110_tofile(g_r,l_name,l_maj.maj21,l_maj.maj20,sr.bal1,sr.bal2)  #FUN-A50069 add
         #CALL g110_tofile(g_r,l_name,l_maj.maj21,l_maj.maj20,l_bal1,l_bal2)    #MOD-A70192
         CALL g110_tofile(g_r,l_name,l_maj.maj31,l_maj.maj20,l_bal1,l_bal2)     #FUN-B60077
      END FOREACH
 # END FOR              #FUN-A10098  
   IF cl_null(tm.dd) THEN
      #CALL s_azm(tm.yy,tm.em) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.yy,tm.em,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(tm.yy,tm.em) RETURNING l_flag,l_bdate,l_edate                  
      END IF
      #CHI-A70007 add --end--
      LET tm.dd=DAY(l_edate)
   END IF
   IF cl_null(l_flag) THEN   
   ELSE             
      LET tm.dd =""    
   END IF  

   IF tm.exp = '1' THEN
      LET l_url = FGL_GETENV("FGLASIP") CLIPPED,"/tiptop/out/",l_name
      CALL ui.Interface.frontCall("standard", "shellexec", ["EXPLORER \"" || l_url || "\""],[])
   ELSE
      CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   END IF
      
END FUNCTION 

FUNCTION g110_xbrl_bal(p_yy,l_maj)
DEFINE p_yy      LIKE type_file.chr4
DEFINE l_amt1    LIKE aah_file.aah04
DEFINE g_bal     LIKE aah_file.aah04
DEFINE l_tmp     LIKE aah_file.aah04 
DEFINE l_endy1   LIKE abb_file.abb07
DEFINE l_endy2   LIKE abb_file.abb07
DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_maj RECORD LIKE maj_file.*
DEFINE l_dbs     LIKE type_file.chr10

   LET l_amt1 = 0
   IF NOT cl_null(l_maj.maj21) THEN
      IF cl_null(l_maj.maj22) THEN
         LET l_maj.maj22 = l_maj.maj21
      END IF
      IF l_maj.maj24 IS NULL THEN
         LET l_sql = " SELECT SUM(aah04-aah05) ",
                    #NO.FUN-A10098   ----start---
                    #" FROM ",l_dbs CLIPPED," aah_file,",l_dbs CLIPPED," aag_file ",
                     " FROM aah_file,aag_file ",
                    #NO.FUN-A10098  ----end---
                     " WHERE aah00 = '",tm.b,"' ",
                     " AND aag00 = '",tm.b,"' ",  
                     " AND aah01 BETWEEN '",l_maj.maj21,"' AND '",l_maj.maj22,"' ",
                     " AND aah02 = '",p_yy,"' ",
                     " AND aah03 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
                     " AND aah01 = aag01 ",
#                    " AND aag07 MATCHES '[23]' "           #No.TQC-B30100 Mark
                     " AND aag07 IN ('2','3')  "            #No.TQC-B30100 add
         PREPARE g110_pre2 FROM l_sql
         DECLARE g110_curs2  CURSOR FOR g110_pre2
         OPEN g110_curs2
         FETCH g110_curs2 INTO l_amt1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","aah_file,aag_file",tm.b,p_yy,STATUS,"","sel aah:",1) 
            RETURN 0
         END IF
      ELSE
         LET l_sql = " SELECT SUM(aao05-aao06) ",
                    #NO.FUN-A10098   ----start---
                    #" FROM ",l_dbs CLIPPED," aao_file,",l_dbs CLIPPED," aag_file ",
                     " FROM aao_file,aag_file ",
                    #NO.FUN-A10098   ---end---
                     " WHERE aao00 = '",tm.b,"' ",
                     " AND aag00 = '",tm.b,"' ",     
                     " AND aao01 BETWEEN '",l_maj.maj21,"' AND '",l_maj.maj22,"' ",
                     " AND aao02 BETWEEN '",l_maj.maj24,"' AND '",l_maj.maj25,"' ",
                     " AND aao03 = '",p_yy,"' ",
                     " AND aao04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
                     " AND aao01 = aag01 ",
#                    " AND aag07 MATCHES '[23]' "           #No.TQC-B30100 Mark
                     " AND aag07 IN ('2','3')  "            #No.TQC-B30100 add
         PREPARE g110_pre3 FROM l_sql
         DECLARE g110_curs3  CURSOR FOR g110_pre3
         OPEN g110_curs3
         FETCH g110_curs3 INTO l_amt1
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("sel","aao_file,aag_file",p_yy,"",STATUS,"","sel aao:",1)
            RETURN 0
         END IF
      END IF                      
      IF l_amt1 IS NULL THEN
         LET l_amt1 = 0  
      END IF         
      LET g_aaa09 = ''
      SELECT aaa09 INTO g_aaa09 FROM aaa_file WHERE aaa01=tm.b 
      IF g_aaa09 = '2' THEN     
        #NO.FUN-A10098   ----start---                                             
        #LET l_sql = "SELECT SUM(abb07) FROM ",l_dbs CLIPPED," abb_file,",l_dbs CLIPPED," aba_file,",l_dbs CLIPPED," aag_file ",  
         LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",
        #NO.FUN-A10098  ---end---
                     " WHERE abb00 = '",tm.b,"' ",
                     " AND aag00 = '",tm.b,"' ",    
                     " AND aba00 = abb00 AND aba01 = abb01 ",
                     " AND abb03 BETWEEN '",l_maj.maj21,"' AND '",l_maj.maj22,"' ",
                     " AND aba06 = 'CE' AND abb06 = '1' AND aba03 = '",p_yy,"' ",
                     " AND aba04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
                     " AND abapost = 'Y' ",
                     " AND abb03 = aag01 ", 
                     " AND aag03 <> '4' "    
         PREPARE g110_pre4 FROM l_sql
         DECLARE g110_curs4  CURSOR FOR g110_pre4
         OPEN g110_curs4
         FETCH g110_curs4 INTO l_endy1
        #NO.FUN-A10098   -----start---
        #LET l_sql = "SELECT SUM(abb07) FROM ",l_dbs CLIPPED," abb_file,",l_dbs CLIPPED," aba_file,",l_dbs CLIPPED," aag_file ",   
         LET l_sql = "SELECT SUM(abb07) FROM abb_file,aba_file,aag_file ",
        #NO.FUN-A10098   ----end---
                     " WHERE abb00 = '",tm.b,"' ",
                     " AND aag00 = '",tm.b,"' ",  
                     " AND aba00 = abb00 AND aba01 = abb01 ",
                     " AND abb03 BETWEEN '",l_maj.maj21,"' AND '",l_maj.maj22,"' ",
                     " AND aba06 = 'CE' AND abb06 = '2' AND aba03 = '",p_yy,"' ",
                     " AND aba04 BETWEEN '",tm.bm,"' AND '",g_mm,"' ",
                     " AND abapost = 'Y' ",
                     " AND abb03 = aag01 ",  
                     " AND aag03 <> '4' "    
         PREPARE g110_pre5 FROM l_sql

         DECLARE g110_curs5  CURSOR FOR g110_pre5
         OPEN g110_curs5
         FETCH g110_curs5 INTO l_endy2
         IF l_endy1 IS NULL THEN LET l_endy1 = 0 END IF
         IF l_endy2 IS NULL THEN LET l_endy2 = 0 END IF
         LET l_amt1 = l_amt1 - (l_endy1 - l_endy2)
       END IF
       IF NOT cl_null(tm.dd) THEN
         LET l_sql = "SELECT SUM(aas04-aas05) ",
                   #NO.FUN-A10098   -----start----
                   # " FROM ",l_dbs CLIPPED," aas_file,",l_dbs CLIPPED," aag_file ",
                     " FROM aas_file,aag_file ",
                   #NO.FUN-A10098   ----end---
                     " WHERE aas00 = '",tm.b,"' ",
                     " AND aag00 = '",tm.b,"' ",     
                     " AND aas01 BETWEEN '",l_maj.maj21,"' AND '",l_maj.maj22,"' ",
                     " AND aas02 BETWEEN '",bdate,"' AND '",edate,"' ",
                     " AND aas01 = aag01 ",
#                    " AND aag07 MATCHES '[23]' "           #No.TQC-B30100 Mark
                     " AND aag07 IN ('2','3')  "            #No.TQC-B30100 add
         PREPARE g110_pre6 FROM l_sql                                         
         DECLARE g110_curs6  CURSOR FOR g110_pre6
         OPEN g110_curs6                      
         FETCH g110_curs6 INTO l_tmp
         IF STATUS THEN 
            CALL cl_err3("sel","aas_file,aag_file",tm.b,"",STATUS,"","sel aas:",1) 
            RETURN 0
         END IF
         IF l_tmp IS NULL THEN 
            LET l_tmp = 0 
         END IF      
         LET l_amt1 = l_amt1 + l_tmp 
      END IF         
   END IF 

#--MOD-A70192 mark--
#   #--> 汇率的转换
#   IF tm.o = 'Y' THEN  
#      LET l_amt1 = l_amt1 * tm.q
#   END IF
#   #-->合计阶数处理
#   IF l_maj.maj03 MATCHES "[012]" AND l_maj.maj08 > 0 THEN
#      FOR i = 1 TO 100
#         IF l_maj.maj09 = '-' THEN
#            LET g_tot1[i] = g_tot1[i] - l_amt1
#         ELSE
#            LET g_tot1[i] = g_tot1[i] + l_amt1
#         END IF
#      END FOR
#      LET k = l_maj.maj08
#     LET g_bal= g_tot1[k]
#      FOR i = 1 TO l_maj.maj08
#         LET g_tot1[i] = 0
#      END FOR
#   ELSE
#      IF l_maj.maj03 = '5' THEN
#         LET g_bal = l_amt1
#      ELSE
#         LET g_bal = NULL
#      END IF
#   END IF
#   #-->百分比基准科目
#   IF l_maj.maj11 = 'Y' THEN
#      LET g_basetot1 = g_bal
#      IF g_basetot1 = 0 THEN
#         LET g_basetot1 = NULL
#      END IF
#      IF l_maj.maj07='2' THEN
#         LET g_basetot1 = g_basetot1 * -1
#      END IF
#   END IF
#   #--> 余额为0者不列印                                                                                                             
#   IF (tm.c='N' OR l_maj.maj03='2') AND l_maj.maj03 MATCHES "[0125]" AND g_bal=0 THEN                                               
#   END IF                                                                                                                           
#   #-->最小阶数起列印
#   IF tm.f>0 AND l_maj.maj08 < tm.f THEN
#   END IF
#   IF l_maj.maj07 = '2' THEN
#      LET g_bal = g_bal * -1
#   END IF   
#   IF tm.h = 'Y' THEN
#      LET l_maj.maj20 = l_maj.maj20e
#   END IF                 
#   LET l_maj.maj20 = l_maj.maj05 SPACES,l_maj.maj20
#   LET g_bal=g_bal/g_unit
#   RETURN g_bal
#--MOD-A70192 mark--------

    RETURN l_amt1  #MOD-A70192

END FUNCTION

#FUNCTION g110_tofile(p_r,p_name,p_maj21,p_maj20,p_bal1,p_bal2)  #FUN-B60077 mark
FUNCTION g110_tofile(p_r,p_name,p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077
DEFINE p_r          LIKE type_file.num5
DEFINE p_name       LIKE type_file.chr20
#DEFINE p_maj21      LIKE maj_file.maj21    #FUN-B60077 mark
DEFINE p_maj31      LIKE maj_file.maj31     #FUN-B60077
DEFINE p_maj20      LIKE maj_file.maj20
DEFINE p_bal1       LIKE aah_file.aah04
DEFINE p_bal2       LIKE aah_file.aah04
DEFINE l_date       LIKE type_file.dat
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_azn02      LIKE azn_file.azn02
DEFINE l_azn04      LIKE azn_file.azn04
DEFINE l_azn05      LIKE azn_file.azn05


   IF tm.exp = '1' THEN           #TXT
     #CALL g110_totxt(p_maj21,p_maj20,p_bal1,p_bal2)   #FUN-B60077 mark
      CALL g110_totxt(p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077
   ELSE
     #CALL g110_toexcel('2',p_r,p_maj21,p_maj20,p_bal1,p_bal2)   #FUN-B60077 mark
      CALL g110_toexcel('2',p_r,p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077
   END IF
END FUNCTION

#FUNCTION g110_totxt(p_maj21,p_maj20,p_bal1,p_bal2)     #FUN-B60077 mark
#DEFINE p_maj21    LIKE maj_file.maj21                  #FUN-B60077 mark
FUNCTION g110_totxt(p_maj31,p_maj20,p_bal1,p_bal2)      #FUN-B60077
DEFINE p_maj31    LIKE maj_file.maj31                   #FUN-B60077
DEFINE p_maj20    LIKE maj_file.maj20
DEFINE p_bal1     LIKE aah_file.aah04
DEFINE p_bal2     LIKE aah_file.aah04
DEFINE l_str      LIKE type_file.chr100
DEFINE l_channel1 base.Channel
DEFINE l_cmd      LIKE type_file.chr100
DEFINE l_i        LIKE type_file.num5

   LET l_channel1 = base.Channel.create()
   CALL l_channel1.openFile(g_name1,"a")
   LET l_str=g_str1

  #IF NOT cl_null(p_maj21) THEN            #FUN-B60077 mark
  #   LET l_str[15,20] = p_maj21 CLIPPED   #FUN-B60077 mark
   IF NOT cl_null(p_maj31) THEN            #FUN-B60077
      LET l_str[15,20] = p_maj31 CLIPPED   #FUN-B60077
   END IF

   IF p_bal1>=0 THEN
      LET l_str[21,21] = '+'
   ELSE
      LET l_str[21,21] = '-'
      LET p_bal1 = p_bal1 * -1
   END IF
   LET l_str[22,36] = p_bal1 USING '&&&&&&&&&&&&&&&'

   IF p_bal2>=0 THEN
      LET l_str[37,37] = '+'
   ELSE
      LET l_str[37,37] = '-'
      LET p_bal2 = p_bal2 * -1
   END IF
   LET l_str[38,52] = p_bal2 USING '&&&&&&&&&&&&&&&'
   #FOR l_i = 1 TO 52
   FOR l_i = 21 TO 52  #FUN-A50069
     IF cl_null(l_str[l_i,l_i]) THEN
        LET l_str[l_i,l_i] = '0'
     END IF
   END FOR

  #IF NOT cl_null(p_maj21) THEN    #FUN-B60077 mark
   IF NOT cl_null(p_maj31) THEN     #FUN-B60077
      CALL l_channel1.write(l_str)                                             
   END IF
   
END FUNCTION

#FUNCTION g110_toexcel(p_s,p_r,p_maj21,p_maj20,p_bal1,p_bal2)  #FUN-B60077 mark
FUNCTION g110_toexcel(p_s,p_r,p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077
DEFINE p_s        LIKE type_file.chr1
DEFINE p_r        LIKE type_file.num5
#DEFINE p_maj21    LIKE maj_file.maj21     #FUN-B60077 mark
DEFINE p_maj31    LIKE maj_file.maj31      #FUN-B60077
DEFINE p_maj20    LIKE maj_file.maj20
DEFINE p_bal1     LIKE aah_file.aah04
DEFINE p_bal2     LIKE aah_file.aah04
DEFINE l_str      LIKE type_file.chr100
DEFINE l_channel1 base.Channel
DEFINE l_cmd      LIKE type_file.chr100
DEFINE l_url      LIKE type_file.chr100
DEFINE li_result  LIKE type_file.num5


  #CALL g110_exceldata(p_s,p_r,p_maj21,p_maj20,p_bal1,p_bal2)   #FUN-B60077 mark
   CALL g110_exceldata(p_s,p_r,p_maj31,p_maj20,p_bal1,p_bal2)   #FUN-B60077
   
END FUNCTION

FUNCTION g110_lastday()
DEFINE l_yy   LIKE type_file.num5
DEFINE l_mm   LIKE type_file.num5
   IF tm.em=12 THEN
      LET l_yy = tm.yy + 1
      LET l_mm = 1
   ELSE
      LET l_yy = tm.yy
      LET l_mm = tm.em + 1
   END IF
   RETURN MDY(l_mm,1,l_yy)-1
END FUNCTION


#FUNCTION g110_exceldata(p_s,p_r,p_maj21,p_maj20,p_bal1,p_bal2)   #FUN-B60077 mark
FUNCTION g110_exceldata(p_s,p_r,p_maj31,p_maj20,p_bal1,p_bal2)    #FUN-B60077
DEFINE p_s     LIKE type_file.chr10
DEFINE p_r     LIKE type_file.num5
#DEFINE p_maj21 LIKE maj_file.maj21   #FUN-B60077 mark
DEFINE p_maj31 LIKE maj_file.maj31    #FUN-B60077
DEFINE p_maj20 LIKE maj_file.maj20
DEFINE p_bal1  LIKE aah_file.aah04
DEFINE p_bal2  LIKE aah_file.aah04
DEFINE l_c     LIKE type_file.num5
DEFINE l_ze03  LIKE ze_file.ze03
DEFINE l_str   STRING
DEFINE ls_cell STRING
DEFINE li_result LIKE type_file.num5
DEFINE l_cmd   LIKE type_file.chr100
DEFINE l_err   STRING
DEFINE l_ze03_s STRING  #FUN-A60039 

   IF p_s = "1" THEN
#公司代号
      SELECT ze03 INTO l_ze03 
        FROM ze_file 
       WHERE ze01 = 'agl-505' 
         AND ze02 = g_lang
     #LET l_str = l_ze03             #FUN-A60039 mark
      LET l_ze03_s = l_ze03          #FUN-A60039                                   
      LET l_str = l_ze03_s.trim()    #FUN-A60039 
      LET ls_cell = "R1C1"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],li_result)
      CALL g110_checkError(li_result,"DDEPoke Sheet1 R1C1")
      LET l_str = g_zo16
      LET ls_cell = "R1C2"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g110_checkError(li_result,"DDEPoke Sheet1 R1C2")
#年度
      SELECT ze03 INTO l_ze03 
        FROM ze_file 
       WHERE ze01 = 'agl-506' 
         AND ze02 = g_lang
     #LET l_str = l_ze03         #FUN-A60039
      LET l_ze03_s = l_ze03      #FUN-A60039                                    
      LET l_str = l_ze03_s.trim()  #FUN-A60039
      LET ls_cell = "R2C1"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g110_checkError(li_result,"DDEPoke Sheet1 R2C1")
      LET l_str = g_yy
      LET ls_cell = "R2C2"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g110_checkError(li_result,"DDEPoke Sheet1 R2C2")
#季别
      SELECT ze03 INTO l_ze03 
        FROM ze_file 
       WHERE ze01 = 'agl-507' 
         AND ze02 = g_lang
     #LET l_str = l_ze03       #FUN-A60039
      LET l_ze03_s = l_ze03      #FUN-A60039                                    
      LET l_str = l_ze03_s.trim()  #FUN-A60039 
      LET ls_cell = "R3C1"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g110_checkError(li_result,"DDEPoke Sheet1 R3C1")
       LET l_str = g_ss
      LET ls_cell = "R3C2"
      CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet1,ls_cell,l_str],[li_result])
      CALL g110_checkError(li_result,"DDEPoke Sheet1 R3C2")
   #ELSE   #FUN-A50069 mark
   END IF  #FUN-A50069 add
      IF p_r = 1 THEN
#科目代号
         SELECT ze03 INTO l_ze03 
           FROM ze_file 
          WHERE ze01 = 'agl-508' 
            AND ze02 = g_lang
       # LET l_str = l_ze03       #FUN-A60039
         LET l_ze03_s = l_ze03      #FUN-A60039                                 
         LET l_str = l_ze03_s.trim()  #FUN-A60039
         CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C1",l_str],[li_result])
         CALL g110_checkError(li_result,"DDEPoke Sheet2 R1C1")
#科目名称
         SELECT ze03 INTO l_ze03 
           FROM ze_file 
          WHERE ze01 = 'agl-509' 
            AND ze02 = g_lang
       # LET l_str = l_ze03          #FUN-A60039
         LET l_ze03_s = l_ze03      #FUN-A60039                                 
         LET l_str = l_ze03_s.trim()  #FUN-A60039
         CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C2",l_str],[li_result])
         CALL g110_checkError(li_result,"DDEPoke Sheet2 R1C2")
#今年数值
         SELECT ze03 INTO l_ze03 
           FROM ze_file 
          WHERE ze01 = 'agl-510'
            AND ze02 = g_lang
       # LET l_str = l_ze03           #FUN-A60039 
         let l_ze03_s = l_ze03        #FUN-A60039                                 
         let l_str = l_ze03_s.trim()  #FUN-A60039
         CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C3",l_str],[li_result])
         CALL g110_checkError(li_result,"DDEPoke Sheet2 R1C3")
#去年数值
         SELECT ze03 INTO l_ze03 
           FROM ze_file 
          WHERE ze01 = 'agl-511' 
            AND ze02 = g_lang
       # LET l_str = l_ze03          #FUN-A60039
         LET l_ze03_s = l_ze03      #FUN-A60039                                 
         LET l_str = l_ze03_s.trim()  #FUN-A60039
         CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,"R1C4",l_str],[li_result])
         CALL g110_checkError(li_result,"DDEPoke Sheet2 R1C4")
         LET g_r = g_r + 1    #FUN-A50069 add
         LET p_r = g_r        #FUN-A50069 add
     #ELSE       #FUN-A50069 mark
     END IF      #FUN-A50069 add
         FOR l_c = 1 TO 4
            LET ls_cell = "R" || p_r || "C" || l_c
            CASE l_c
               WHEN 1
                 #IF NOT cl_null(p_maj21) THEN   #FUN-B60077 mark
                 #   LET l_str = p_maj21         #FUN-B60077 mark
                  IF NOT cl_null(p_maj31) THEN   #FUN-B60077
                     LET l_str = p_maj31         #FUN-B60077
                     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                     CALL g110_checkError(li_result,"DDEPoke Sheet2 ")
                  END IF
               WHEN 2
                  IF NOT cl_null(p_maj20) THEN
                     LET l_str = p_maj20
                     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                     CALL g110_checkError(li_result,"DDEPoke Sheet2 ")
                  END IF
               WHEN 3
                 #IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj21) THEN  #FUN-B60077 mark
                  IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj31) THEN  #FUN-B60077
                     LET l_str = p_bal1
                     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                     CALL g110_checkError(li_result,"DDEPoke Sheet2 ")
                  END IF
               WHEN 4
                 #IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj21) THEN  #FUN-B60077 mark
                  IF NOT cl_null(p_bal1) AND NOT cl_null(p_maj31) THEN  #FUN-B60077
                     LET l_str = p_bal2
                     CALL ui.Interface.frontCall("WINDDE","DDEPoke",[g_cmd,sheet2,ls_cell,l_str],[li_result])
                     CALL g110_checkError(li_result,"DDEPoke Sheet2 ")
                  END IF
            END CASE
         END FOR
#      END IF    #FUN-A50069 mark
#   END IF       #FUN-A50069 mark
END FUNCTION
FUNCTION g110_checkError(p_result,p_msg)
   DEFINE   p_result   SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  SMALLINT

   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80158--add--
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add 
   EXIT PROGRAM
END FUNCTION
#No.FUN-9C0126 --End
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg110_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg110")
        IF handler IS NOT NULL THEN
            START REPORT aglg110_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY maj02,line"    #FUN-B80158 add
          
            DECLARE aglg110_datacur1 CURSOR FROM l_sql
            FOREACH aglg110_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg110_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg110_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg110_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158-------add---str-------
    DEFINE l_date_type     STRING
    DEFINE l_1             STRING 
    DEFINE l_2             STRING 
    DEFINE l_per           STRING 
    DEFINE l_unit          STRING
    DEFINE l_bal1_fmt      STRING 
    DEFINE l_title         STRING
    #FUN-B80158-------end---str-------

    
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B80158-------add---str-------
            IF tm.bm >=0 AND tm.bm < 9 THEN
               LET l_1 = tm.bm USING '&&'
            END IF 
            IF tm.em >=0 AND tm.em < 9 THEN
               LET l_2 = tm.em USING '&&'
            ELSE 
               LET l_2 = tm.em 
            END IF 
            
            IF tm.rtype = '1' AND NOT cl_null(tm.dd) THEN
               LET l_date_type = cl_gr_getmsg("gre-114",g_lang,1),':',tm.yy,'/',tm.em,'/',tm.dd
            ELSE 
               LET l_date_type = cl_gr_getmsg("gre-114",g_lang,2),':',tm.yy,'/',l_1,'-',l_2
            END IF
            PRINTX l_date_type

            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit
            #FUN-B80158-------end---str-------
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158-------add---str-------
            IF cl_null(g_mai02) THEN 
               LET l_title = g_grPageHeader.title2
            ELSE
               LET l_title = g_mai02
            END IF
            PRINTX l_title
            IF NOT cl_null(g_basetot1) THEN
               LET l_per = (sr1.bal1 / g_basetot1) * 100
               IF cl_null(l_per) THEN
                  LET l_per = " "
               ELSE
                  LET l_per = l_per,"%"
               END IF
            ELSE
               LET l_per = " "
            END IF 
            PRINTX l_per
     
            LET l_bal1_fmt = cl_gr_numfmt("aah_file","aah04",tm.e)
            PRINTX l_bal1_fmt
            #FUN-B80158-------end---str-------

            PRINTX sr1.*

        
        ON LAST ROW

END REPORT
###GENGRE###END

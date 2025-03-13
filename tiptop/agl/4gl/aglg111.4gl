# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg111.4gl
# Descriptions...: 帳戶式資產負債表
# Date & Author..: 96/09/10 By Melody 
# Modified by Thomas   maj05 跳格未作控制 97/04/09 Line 398,406
# Modified by Thomas   maj07 基準科目處理有錯 Line 456 - 459
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.FUN-510007 05/02/17 By Nicola 報表架構修改
# Modify.........: No.MOD-530363 05/03/25 By echo 帳戶式資產負債表格式沒有對齊
# Modify.........: No.MOD-580310 05/08/29 By Smapmin 加上IF r_row(l_row) = 0 THEN LET r_row(l_row) = 1 END IF
# Modify.........: No.MOD-640489 06/04/17 By Smapmin 帳戶式資產負債表格式對齊
# Modify.........: No.MOD-640490 06/04/17 By Smapmin 修正MOD-640489
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-6B0027 06/11/06 By Smapmin 帳戶式資產負債表格式對齊
# Modify.........: No.MOD-710078 07/01/11 By Smapmin 左右行數相同時,報表會印不出來
# Modify.........: No.FUN-6C0068 07/01/16 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/07 By sherry  會計科目加帳套
# Modify.........: No.TQC-740312 07/04/25 By Smapmin 以項次(maj02)取代合計階(maj08),來抓取最大項次
# Modify.........: No.FUN-780058 07/08/28 By sherry 報表改寫由Crystal Report產出
# Modify.........: No.MOD-830226 08/03/28 By Sarah 資料寫入CR Temptable時,maj03全部會寫入最後一筆序號的maj03,正確應該是寫入各筆自己的maj03
# Modify.........: No.MOD-850290 08/05/28 By Sarah 當prt_r[i].maj02為空時,判斷要抓上一筆prt_r[i-1].maj02,但當i=1時,會造成程式當出,修正為當i!=1時才這樣抓
# Modify.........: No.MOD-860306 08/07/08 By Sarah 報表結構設定要印金額底線,報表卻沒印出來
# Modify.........: No.MOD-870071 08/07/14 By Sarah 報表數字欄位(bal_l,per_l,bal_r,per_r)改成直接寫入數字,取位的動作到rpt再做
# Modify.........: No.MOD-870242 08/07/25 By Sarah 報表結構設定要印金額底線且是空行時,報表卻沒印出來
# Modify.........: No.MOD-880140 08/08/20 By Sarah maj03若為H時,不可將左右同時清空(prt_l[i].per,prt_r[i].per),應只需清空設定的一邊
# Modify.........: No.MOD-890121 08/09/17 By Sarah 當在報表結構(agli116)設定列印碼為3或4時,但科目名稱又不是空的,需將資料拆成兩筆寫入Temptable,一筆是正常資料,另一筆是列印碼為3/4
# Modify.........: No.MOD-8B0014 08/11/04 By Sarah 百分比值是(bal/g_basetot1)*100,bal有經過/g_unit的計算,g_basetot1也需同樣/g_unit
# Modify.........: No.MOD-8B0012 08/11/07 By Sarah 1.傳到CR的參數增加p8,傳遞截止日期
#                                                  2.報表左右平衡問題
# Modify.........: No.MOD-910225 09/01/21 By Sarah 報表左右平衡問題,當報表結構負債和股東權益的筆數比資產還多,那報表最後一行會消失且最後一行會不對齊
# Modify.........: No.MOD-910246 09/01/22 By Sarah 當勾選餘額為零不印報表時,當負債和股東權益的最後一筆金額為零時程式會當掉
# Modify.........: No.MOD-920028 09/02/03 By Sarah 列印碼設為0:本行不印出,但金額要作加總時,會誤印出空白行
# Modify.........: No.MOD-920278 09/02/20 By Dido  截止日期語法問題
# Modify.........: No.MOD-940424 09/04/30 By Sarah 報表左右平衡問題,當最後一筆資料列印碼是3或4時,需移動最後兩筆資料來左右平衡才對
# Modify.........: No.MOD-960080 09/06/05 By Sarah 判斷餘額為零不列印時,應判斷maj03 MATCHES "[0125]"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980142 09/08/18 By sabrina 報表列印後數字會無法轉換
# Modify.........: No.CHI-940060 09/08/21 By Sarah 當左右只有其中一方列印碼是3時,該行仍會顯示(FUNCTION g111()重寫)
# Modify.........: No.MOD-990052 09/09/07 By Sarah 修正CHI-940060,報表結構設定空格失效問題
# Modify.........: No:MOD-9C0404 09/12/25 By Dido 無法切換語言別 
# Modify.........: No:MOD-A10023 10/01/06 By Sarah 報表排序問題,CR Temptable增加l_n來排序
# Modidy.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.CHI-A40035 10/04/29 By liuxqa 追单MOD-A20080&MOD-9C0010 
# Modify.........: No:MOD-A10167 10/09/29 By sabrina 將maj20變數定義由chr50改成maj_file.maj20
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:MOD-AB0198 10/10/22 By Dido 微調清空位置 
# Modify.........: No.FUN-B80158 11/08/25 By yangtt  明細類CR轉換成GRW
# Modify.........: No.FUN-B80158 12/01/05 By qirl FUN-B90140追單 
# Modify.........: No.FUN-B80158 12/01/12 By yangtt MOD-BB0042追單 
# Modify.........: No.FUN-B80158 12/01/16 By xuxz 程序規範修改
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料
# Modify.........: No.FUN-CB0051 12/12/06 By chenying 4rp去除單身欄位定位點
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            a     LIKE mai_file.mai01,        #報表結構編號    #No.FUN-680098 VARCHAR(6)
            b     LIKE aaa_file.aaa01,        #帳別編號        #No.FUN-670039
            yy    LIKE type_file.num5,        #輸入年度        #No.FUN-680098 smallint
            bm    LIKE type_file.num5,        #Begin 期別      #No.FUN-680098 smallint
            c     LIKE type_file.chr1,        #異動額及餘額為0者是否列印   #No.FUN-680098  VARCHAR(1)
            d     LIKE type_file.chr1,        #金額單位        #No.FUN-680098 VARCHAR(1)
            e     LIKE type_file.num5,        #小數位數        #No.FUN-680098 smallint
            f     LIKE type_file.num5,        #列印最小階數    #No.FUN-680098 smallint
            h     LIKE type_file.chr4,        #額外說明類別    #No.FUN-680098 VARCHAR(4)
            o     LIKE type_file.chr1,        #轉換幣別否      #No.FUN-680098 VARCHAR(1) 
            p     LIKE azi_file.azi01,        #幣別
            q     LIKE azj_file.azj03,        #匯率
            r     LIKE azi_file.azi01,        #幣別
            more  LIKE type_file.chr1,         #Input more condition(Y/N)  #No.FUN-680098 VARCHAR(1)
            acc_code LIKE type_file.chr1      #FUN-B80158   Add
           END RECORD,
       i,j,k      LIKE type_file.num5,        #No.FUN-680098 smallint
       g_unit     LIKE type_file.num10,       #金額單位基數   #No.FUN-680098 integer
       l_row      LIKE type_file.num5,                        #No.FUN-680098 smallint
       r_row      LIKE type_file.num5,                        #No.FUN-680098 smallint
       g_bookno   LIKE aah_file.aah00,        #帳別
       g_mai02    LIKE mai_file.mai02,
       g_mai03    LIKE mai_file.mai03,
       g_tot1     ARRAY[100] OF LIKE type_file.num20_6,       #No.FUN-680098  dec(20,6)
       g_basetot1 LIKE aah_file.aah04
DEFINE g_aaa03    LIKE aaa_file.aaa03   
DEFINE g_i        LIKE type_file.num5         #count/index for any purpose   #No.FUN-680098 smallint
DEFINE l_table    STRING                      #No.FUN-780058
DEFINE g_sql      STRING                      #No.FUN-780058
DEFINE g_str      STRING                      #No.FUN-780058
 
###GENGRE###START
TYPE sr1_t RECORD
    maj31 LIKE maj_file.maj31,   #NO.FUN-B80158 ADD
    maj20_l LIKE maj_file.maj20,
    bal_l LIKE type_file.num20_6,
    per_l LIKE type_file.num20_6,
    maj03_l LIKE maj_file.maj03,
    maj02_l LIKE maj_file.maj02,
    line_l LIKE type_file.num5,
    maj31_r LIKE maj_file.maj31, #NO.FUN-B80158 ADD
    maj20_r LIKE maj_file.maj20,
    bal_r LIKE type_file.num20_6,
    per_r LIKE type_file.num20_6,
    maj03_r LIKE maj_file.maj03,
    maj02_r LIKE maj_file.maj02,
    line_r LIKE type_file.num5,
    l_n LIKE type_file.num5
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
#  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114   #FUN-B80158 mark
 
   LET g_sql = "maj31_l.maj_file.maj31,",    #FUN-B80158   Add
               "maj20_l.maj_file.maj20,",    #MOD-A10167 mod chr50->maj20
               "bal_l.type_file.num20_6,",   #MOD-870071 mod chr20->num20_6
               "per_l.type_file.num20_6,",   #MOD-870071 mod chr20->num20_6
               "maj03_l.maj_file.maj03,",
               "maj02_l.maj_file.maj02,",
               "line_l.type_file.num5,",     #MOD-890121 add
               "maj31_r.maj_file.maj31,",    #FUN-B80158   Add
               "maj20_r.maj_file.maj20,",    #MOD-A10167 mod chr50->maj20
               "bal_r.type_file.num20_6,",   #MOD-870071 mod chr20->num20_6
               "per_r.type_file.num20_6,",   #MOD-870071 mod chr20->num20_6
               "maj03_r.maj_file.maj03,",
               "maj02_r.maj_file.maj02,",
               "line_r.type_file.num5,",     #MOD-890121 add
               "l_n.type_file.num5"          #MOD-A10023 add
               
   LET l_table = cl_prt_temptable('aglg111',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table = -1 THEN 
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF                  # Temp Table產生   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #MOD-890121 add 2?  #MOD-A10023 add ?#FUN-B80158   Add ?,?
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add#FUN-B80158mark
      EXIT PROGRAM                         
   END IF                                                                       
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-B80158
  
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)   #TQC-610056
   LET tm.yy = ARG_VAL(10)
   LET tm.bm = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.f  = ARG_VAL(15)
   LET tm.h  = ARG_VAL(16)
   LET tm.o  = ARG_VAL(17)
   LET tm.p  = ARG_VAL(18)
   LET tm.q  = ARG_VAL(19)
   LET tm.r  = ARG_VAL(20)   #TQC-610056
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)  #No.FUN-7C0078
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF    #No.FUN-740020
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL g111_tm()                   # Input print condition
      ELSE CALL g111()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
END MAIN
 
FUNCTION g111_tm()
   DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-680098 smallint
   DEFINE l_sw           LIKE type_file.chr1      #重要欄位是否空白   #No.FUN-680098 VARCHAR(1)
   DEFINE l_cmd          LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5      #No.FUN-670005      #No.FUN-680098 smallint
   DEFINE li_result      LIKE type_file.num5      #No.FUN-6C0068
   DEFINE l_aaa03        LIKE aaa_file.aaa03      #MOD-980142 add
   DEFINE l_azi05        LIKE azi_file.azi05      #MOD-980142 add
 
   CALL s_dsmark(g_bookno)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 11
   END IF
 
   OPEN WINDOW g111_w AT p_row,p_col WITH FORM "agl/42f/aglg111"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
 
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
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.acc_code = 'N'   #FUN-B80158   Add 

   WHILE TRUE
      LET l_row=0
      LET r_row=0
      LET l_sw = 1
      INPUT BY NAME tm.b,tm.a,tm.yy,tm.bm,tm.e,tm.f,      #No.FUN-740020
               tm.d,tm.acc_code,tm.c,tm.h,tm.o,tm.r,         #FUN-B80158   Add tm.acc_code
               tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_dynamic_locale()                  #MOD-9C0404 remark
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
 
         AFTER FIELD a
            IF tm.a IS NULL THEN NEXT FIELD a END IF
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
            IF tm.b IS NULL THEN NEXT FIELD b END IF
            CALL s_check_bookno(tm.b,g_user,g_plant) 
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD b
            END IF 
            SELECT aaa03 INTO l_aaa03 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            SELECT azi05 INTO l_azi05 FROM azi_file where azi01=l_aaa03
            LET tm.e=l_azi05
            DISPLAY BY NAME tm.e
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD b 
            END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
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
            IF tm.bm IS NULL THEN NEXT FIELD bm END IF
 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
               NEXT FIELD d
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         AFTER FIELD e
            IF tm.e IS NULL THEN NEXT FIELD e END IF      #MOD-980142 add
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
            IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
         AFTER FIELD o
            IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
            IF tm.o = 'N' THEN 
               LET tm.p = g_aaa03 
               LET tm.q = 1
               DISPLAY g_aaa03 TO p
               DISPLAY BY NAME tm.q
            END IF
 
         BEFORE FIELD p
            IF tm.o = 'N' THEN NEXT FIELD more END IF
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel mai:",0)   #No.FUN-660123
               NEXT FIELD p
            END IF
 
         BEFORE FIELD q
            IF tm.o = 'N' THEN NEXT FIELD o END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT 
            IF INT_FLAG THEN EXIT INPUT END IF
            IF tm.yy IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy 
               CALL cl_err('',9033,0)
            END IF
            IF tm.bm IS NULL THEN 
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm 
            END IF
            IF l_sw = 0 THEN 
                LET l_sw = 1 
                NEXT FIELD a
                CALL cl_err('',9033,0)
            END IF
            IF tm.d = '1' THEN LET g_unit = 1 END IF
            IF tm.d = '2' THEN LET g_unit = 1000 END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_mai'
                  LET g_qryparam.default1 = tm.a
                 #LET g_qryparam.where = " mai00 = '",tm.b,"'"  #No.FUN-740020   #No.TQC-C50042   Mark
                  LET g_qryparam.where = " mai00 = '",tm.b,"' AND mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY BY NAME tm.a
                  NEXT FIELD a
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b 
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form =  'q_azi'
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p 
                  DISPLAY BY NAME tm.p
                  NEXT FIELD p
            END CASE
 
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
         LET INT_FLAG = 0 CLOSE WINDOW g111_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='aglg111'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglg111','9031',1)   
         ELSE
          LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                      " '",g_bookno CLIPPED,"'" ,
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",   #TQC-610056
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.bm CLIPPED,"'",
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
          CALL cl_cmdat('aglg111',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g111_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g111()
      ERROR ""
   END WHILE
   CLOSE WINDOW g111_w
END FUNCTION
 
FUNCTION g111()
   DEFINE l_name    LIKE type_file.chr20         #External(Disk) file name       #No.FUN-680098   VARCHAR(20)
   DEFINE l_sql     LIKE type_file.chr1000       #RDSQL STATEMENT                #No.FUN-680098    VARCHAR(1000)
   DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680098    VARCHAR(1)
   DEFINE amt1      LIKE aah_file.aah04
   DEFINE per1      LIKE fid_file.fid03          #No.FUN-680098  dec(8,3)
   DEFINE maj       RECORD LIKE maj_file.*
   DEFINE l_last    LIKE type_file.num5          #No.FUN-680098  smallint
   DEFINE l_lastday LIKE type_file.dat           #No.MOD-920278
   DEFINE sr        RECORD
                       bal1      LIKE aah_file.aah04
                    END RECORD
   DEFINE prt_l     DYNAMIC ARRAY OF RECORD                   #--- 陣列 for 資產類 (左)
                       maj31    LIKE maj_file.maj31,          #FUN-B80158  add
                       maj20    LIKE maj_file.maj20,          #No.FUN-680098 char(40)  #MOD-A10167 modify  chr50->maj20
                       bal      LIKE type_file.num20_6,       #No.FUN-680098 VARCHAR(20)  #MOD-870071 mod chr20->num20_6
                       per      LIKE type_file.num20_6,       #No.FUN-680098 VARCHAR(10)  #MOD-870071 mod chr20->num20_6
                       maj03    LIKE maj_file.maj03,          #No.FUN-680098 VARCHAR(1)
                       maj02    LIKE maj_file.maj02,          #MOD-830226 add
                       line     LIKE type_file.num5           #MOD-890121 add
                    END RECORD
   DEFINE prt_r     DYNAMIC ARRAY OF RECORD         #--- 陣列 for 負債&業主權益類 (右)
                       maj31    LIKE maj_file.maj31,          #FUN-B80158  add
                       maj20    LIKE maj_file.maj20,          #No.FUN-680098 char(40)  #MOD-A10167 modify  chr50->maj20
                       bal      LIKE type_file.num20_6,       #No.FUN-680098 VARCHAR(20)  #MOD-870071 mod chr20->num20_6
                       per      LIKE type_file.num20_6,       #No.FUN-680098 VARCHAR(10)  #MOD-870071 mod chr20->num20_6
                       maj03    LIKE maj_file.maj03,          #No.FUN-680098 VARCHAR(1)
                       maj02    LIKE maj_file.maj02,          #MOD-830226 add
                       line     LIKE type_file.num5           #MOD-890121 add
                    END RECORD
   DEFINE tmp1      RECORD                                    #CHI-940060 add
                       maj31    LIKE maj_file.maj31,          #FUN-B80158 add
                       maj23      LIKE maj_file.maj23,
                       maj20      LIKE maj_file.maj20,        #MOD-A10167 modify  chr50->maj20
                       bal        LIKE type_file.num20_6,
                       per        LIKE type_file.num20_6,
                       maj03      LIKE maj_file.maj03,
                       maj02      LIKE maj_file.maj02,
                       line       LIKE type_file.num5
                    END RECORD
   DEFINE l_maj02_l  LIKE maj_file.maj02      #MOD-640490
   DEFINE l_maj02_r  LIKE maj_file.maj02      #MOD-640490
   DEFINE l_row_l    LIKE type_file.num5      #MOD-640490     #No.FUN-680098  smallint
   DEFINE l_row_r    LIKE type_file.num5      #MOD-640490     #No.FUN-680098  smallint
   DEFINE r,l,i      LIKE type_file.num5      #MOD-640490     #No.FUN-680098  smallint
 
   DROP TABLE aglg111_tmp
   CREATE TEMP TABLE aglg111_tmp(
      maj31    LIKE maj_file.maj31,          #FUN-B80158 add
      maj23    LIKE maj_file.maj23,
      maj20    LIKE maj_file.maj20,        #MOD-A10167 modify  chr50->maj20
      bal      LIKE type_file.num20_6,
      per      LIKE type_file.num20_6,
      maj03    LIKE maj_file.maj03,
      maj02    LIKE maj_file.maj02,
      line     LIKE type_file.num5)
 
   #帳別名稱
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01=tm.b AND aaf02=g_rlang
 
   CALL cl_del_data(l_table)               #No.FUN-780058 
 
   LET l_sql = "SELECT * FROM maj_file ",
               " WHERE maj01 = '",tm.a,"' ",
               "   AND maj23[1,1]='1' ",
               " ORDER BY maj02"
   PREPARE g111_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-80158 add
      EXIT PROGRAM 
   END IF
   DECLARE g111_c CURSOR FOR g111_p
 
   FOR g_i = 1 TO 100 LET g_tot1[g_i] = 0 END FOR
   LET g_basetot1 = NULL                   #CHI-A40035 add 
   FOREACH g111_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET amt1 = 0
      IF NOT cl_null(maj.maj21) THEN
         IF maj.maj24 IS NULL THEN    #起始部門編號
            #會計科目各期餘額檔
            SELECT SUM(aah04-aah05) INTO amt1 FROM aah_file,aag_file
             WHERE aah00 = tm.b
               AND aag00 = tm.b   #No.FUN-740020 
               AND aah01 BETWEEN maj.maj21 AND maj.maj22
               AND aah02 = tm.yy AND aah03 <= tm.bm
               AND aah01 = aag01 AND aag07 IN ('2','3')
         ELSE
            #部門科目餘額檔
            SELECT SUM(aao05-aao06) INTO amt1 FROM aao_file,aag_file
             WHERE aao00 = tm.b
               AND aag00 = tm.b   #No.FUN-740020     
               AND aao01 BETWEEN maj.maj21 AND maj.maj22
               AND aao02 BETWEEN maj.maj24 AND maj.maj25
               AND aao03 = tm.yy AND aao04 <= tm.bm
               AND aao01 = aag01 AND aag07 IN ('2','3')
         END IF
         IF STATUS THEN CALL cl_err('sel aah:',STATUS,1) EXIT FOREACH END IF
         IF amt1 IS NULL THEN LET amt1 = 0 END IF
      END IF
      IF tm.o = 'Y' THEN LET amt1 = amt1 * tm.q END IF          #匯率的轉換
      IF maj.maj03 MATCHES "[012349]" AND maj.maj08 > 0 THEN    #合計階數處理
        #CHI-A70050---modify---start---
        #FOR i = 1 TO 100 LET g_tot1[i]=g_tot1[i]+amt1 END FOR
         FOR i = 1 TO 100 
             IF maj.maj09 = '-' THEN
                LET g_tot1[i] = g_tot1[i] - amt1
             ELSE
                LET g_tot1[i] = g_tot1[i] + amt1
             END IF
         END FOR
        #CHI-A70050---modify---end---
         LET k=maj.maj08  LET sr.bal1=g_tot1[k]
        #CHI-A70050---add---start---
         IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
            LET sr.bal1 = sr.bal1 *-1
         END IF
        #CHI-A70050---add---end---
         FOR i = 1 TO maj.maj08 LET g_tot1[i]=0 END FOR
      ELSE  
         IF maj.maj03='5' THEN                       #本行要印出,但金額不作加總
            LET sr.bal1=amt1
         ELSE
            LET sr.bal1=NULL
         END IF
      END IF
      IF maj.maj11 = 'Y' THEN                        #百分比基準科目
         LET g_basetot1=sr.bal1
         IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
         IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
         #金額單位(1.元 2.千 3.百萬)
         IF tm.d MATCHES '[23]' THEN LET g_basetot1=g_basetot1/g_unit END IF   #MOD-8B0014 add
      END IF
      IF maj.maj03='0' THEN                          #本行不印出
         CONTINUE FOREACH
      END IF
      IF (tm.c='N' OR maj.maj03='2') AND             #餘額為 0 者不列印
          maj.maj03 MATCHES "[012345]" AND sr.bal1=0 THEN
         CONTINUE FOREACH
      END IF
      IF tm.f>0 AND maj.maj08 < tm.f THEN            #最小階數起列印
         CONTINUE FOREACH
      END IF
      #正常餘額型態=2.貸餘,金額要乘以-1 
      IF maj.maj07='2' THEN LET sr.bal1=sr.bal1*-1 END IF
      LET sr.bal1=cl_numfor(sr.bal1,17,tm.e)
      #列印額外名稱
      IF tm.h='Y' THEN LET maj.maj20=maj.maj20e END IF
      LET per1 = (sr.bal1 / g_basetot1) * 100
      IF maj.maj03 = 'H' THEN 
         LET sr.bal1=NULL
         LET per1= ' '
      END IF
      #金額單位(1.元 2.千 3.百萬)
      IF tm.d MATCHES '[23]' THEN LET sr.bal1=sr.bal1/g_unit END IF
      LET maj.maj20=maj.maj05 SPACES,maj.maj20   #MOD-990052 add
 
      IF maj.maj03='3' OR maj.maj03='4' THEN
         IF NOT cl_null(maj.maj20) THEN
            INSERT INTO aglg111_tmp VALUES
             (maj.maj31,maj.maj23,maj.maj20,sr.bal1,per1,'1',maj.maj02,2)      #FUN-B80158  add  maj.maj31
         END IF
         INSERT INTO aglg111_tmp VALUES
          (maj.maj31,maj.maj23,maj.maj20,sr.bal1,per1,maj.maj03,maj.maj02,2)      #FUN-B80158  add  maj.maj31
      ELSE
         INSERT INTO aglg111_tmp VALUES
          (maj.maj31,maj.maj23,maj.maj20,sr.bal1,per1,maj.maj03,maj.maj02,2)    #FUN-B80158  add  maj.maj31
      END IF
      IF maj.maj04 > 0 THEN
         #空行的部份,以寫入同樣的maj20資料列進Temptable,
         #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
         #讓空行的這筆資料排在正常的資料前面印出
         FOR i = 1 TO maj.maj04
            INSERT INTO aglg111_tmp VALUES
             ('',maj.maj23,maj.maj20,0,0,maj.maj03,maj.maj02,1)    #FUN-B80158  add  ''
         END FOR
      END IF
   END FOREACH
 
   #抓報表結構裡帳戶左邊最大序號
   SELECT MAX(maj02) INTO l_maj02_l FROM aglg111_tmp WHERE maj23='11'
   #抓報表結構裡帳戶右邊最大序號
   SELECT MAX(maj02) INTO l_maj02_r FROM aglg111_tmp WHERE maj23='12'
   IF cl_null(l_maj02_l) THEN LET l_maj02_l = 0 END IF
   IF cl_null(l_maj02_r) THEN LET l_maj02_r = 0 END IF
   LET r_row = 0  LET l_row = 0
   DECLARE g111_c1 CURSOR FOR SELECT * FROM aglg111_tmp ORDER BY maj23,maj02,line     #CHI-A40035 add line
   FOREACH g111_c1 INTO tmp1.*
      IF tmp1.maj23[2,2]='2' THEN     #--- 右邊(負債&業主權益)
         LET r_row=r_row+1
         LET prt_r[r_row].maj31=tmp1.maj31        #FUN-B80158  add
         LET prt_r[r_row].maj20=tmp1.maj20
         LET prt_r[r_row].bal  =tmp1.bal
         LET prt_r[r_row].per  =tmp1.per
         LET prt_r[r_row].maj03=tmp1.maj03
         LET prt_r[r_row].maj02=tmp1.maj02
         LET prt_r[r_row].line =tmp1.line
         IF l_maj02_r != 0 THEN
            IF tmp1.maj02 = l_maj02_r THEN    #判斷是不是到最後一筆
               LET l_row_r = r_row
            END IF
         END IF
      ELSE                           #--- 左邊(資產)
         LET l_row=l_row+1
         LET prt_l[l_row].maj31=tmp1.maj31        #FUN-B80158  add
         LET prt_l[l_row].maj20=tmp1.maj20
         LET prt_l[l_row].bal  =tmp1.bal
         LET prt_l[l_row].per  =tmp1.per
         LET prt_l[l_row].maj03=tmp1.maj03
         LET prt_l[l_row].maj02=tmp1.maj02
         LET prt_l[l_row].line =tmp1.line
         IF l_maj02_l != 0 THEN
            IF tmp1.maj02 = l_maj02_l THEN    #判斷是不是到最後一筆
               LET l_row_l = l_row
            END IF
         END IF
      END IF
   END FOREACH
 
   IF r_row = 0 THEN LET r_row = 1 END IF
   IF l_row = 0 THEN LET l_row = 1 END IF
   IF l_maj02_r != 0 AND l_maj02_l != 0 THEN
      IF l_row_l > l_row_r THEN
         LET l_last=l_row
         LET prt_r[l_row_l+1].* = prt_r[l_row_r+1].*
         INITIALIZE prt_r[l_row_r+1].* TO NULL
         IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
            IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
               LET prt_r[l_row_l].* = prt_r[l_row_r].*
   #           INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198  #FUN-B80158 mark 
               INITIALIZE prt_r[l_row_r].* TO NULL                         #FUN-B80158 add FROM MOD-BB0042
               LET prt_r[l_row_l-1].* = prt_r[l_row_r-1].*
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_r[l_row_r-1].* TO NULL
            ELSE
               LET prt_r[l_row_l-1].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
            END IF
         ELSE
            IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
               LET prt_l[l_row_l+1].* = prt_r[l_row_r].*
               LET prt_l[l_row_l+1].maj02=prt_l[l_row_l].maj02
               LET prt_l[l_row_l+1].maj03='1'
               LET prt_l[l_row_l+1].maj31=''    #FUN-B80158  add  
               LET prt_l[l_row_l+1].maj20=''
               LET prt_r[l_row_l+1].* = prt_r[l_row_r].*
       #       INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198   #FUN-B80158 mark 
               INITIALIZE prt_r[l_row_r].* TO NULL                          #FUN-B80158  add  FROM MOD-BB0042
               LET prt_r[l_row_l].* = prt_r[l_row_r-1].*
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_r[l_row_r-1].* TO NULL
               LET l_last=l_row_l+1
            ELSE
               LET prt_r[l_row_l].* = prt_r[l_row_r].*
               INITIALIZE prt_r[l_row_r].* TO NULL
            END IF
         END IF
      END IF
   
      IF l_row_l < l_row_r THEN
         LET l_last=r_row
         LET prt_l[l_row_r+1].* = prt_l[l_row_l+1].*
         INITIALIZE prt_l[l_row_l+1].* TO NULL
         IF prt_r[l_row_r].maj03='3' OR prt_r[l_row_r].maj03='4' THEN
            IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
               LET prt_l[l_row_r].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198
               LET prt_l[l_row_r-1].* = prt_l[l_row_l-1].*
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_l[l_row_l-1].* TO NULL
            ELSE
               LET prt_l[l_row_r-1].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
            END IF
         ELSE
            IF prt_l[l_row_l].maj03='3' OR prt_l[l_row_l].maj03='4' THEN
               LET prt_r[l_row_r+1].* = prt_l[l_row_l].*
               LET prt_r[l_row_r+1].maj02=prt_r[l_row_r].maj02
               LET prt_r[l_row_r+1].maj03='1'
               LET prt_r[l_row_r+1].maj31=''              #FUN-B80158  add   FROM MOD-BB0042
               LET prt_r[l_row_r+1].maj20=''
               LET prt_l[l_row_r+1].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198
               LET prt_l[l_row_r].* = prt_l[l_row_l-1].* 
              #INITIALIZE prt_l[l_row_l].* TO NULL            #MOD-AB0198 mark
               INITIALIZE prt_l[l_row_l-1].* TO NULL
               LET l_last=l_row_r+1
            ELSE
               LET prt_l[l_row_r].* = prt_l[l_row_l].*
               INITIALIZE prt_l[l_row_l].* TO NULL
            END IF
         END IF
      END IF
      IF l_row_l = l_row_r THEN 
         IF l_row > r_row THEN 
            LET l_last = l_row
         ELSE
            LET l_last = r_row
         END IF
      END IF
   ELSE
      IF l_maj02_r = 0 THEN LET l_last = r_row END IF
      IF l_maj02_l = 0 THEN LET l_last = l_row END IF
   END IF
 
   FOR i=1 TO l_last
      EXECUTE insert_prep USING 
         prt_l[i].maj31,         #FUN-B80158  add
         prt_l[i].maj20,prt_l[i].bal,  prt_l[i].per,
         prt_l[i].maj03,prt_l[i].maj02,prt_l[i].line,
         prt_r[i].maj31,         #FUN-B80158  add
         prt_r[i].maj20,prt_r[i].bal,  prt_r[i].per,
         prt_r[i].maj03,prt_r[i].maj02,prt_r[i].line
        ,i   #MOD-A10023 add
   END FOR
 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED             
   LET l_lastday = MDY(tm.bm,'1',tm.yy)    #MOD-920278
   LET l_lastday = s_last(l_lastday)       #MOD-920278
###GENGRE###   LET g_str = g_mai02,";",tm.a,";",tm.p,";",tm.d,";",tm.yy,";",                
###GENGRE###               tm.bm,";",tm.e,";",
###GENGRE###               l_lastday,";",g_basetot1,";",tm.acc_code      #No.FUN-B80158     FROM FUN-B90140   Add tm.acc_code    #CHI-A40035 add         #MOD-920278 add
###GENGRE###   CALL cl_prt_cs3('aglg111','aglg111',g_sql,g_str) 
    CALL aglg111_grdata()    ###GENGRE###
END FUNCTION
#No.FUN-9C0072 精簡程式碼 

###GENGRE###START
FUNCTION aglg111_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg111")
        IF handler IS NOT NULL THEN
            START REPORT aglg111_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY l_n"          #FUN-B80158
          
            DECLARE aglg111_datacur1 CURSOR FROM l_sql
            FOREACH aglg111_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg111_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg111_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg111_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50158-------add-----str----
    DEFINE l_unit      STRING
    DEFINE l_per_l     STRING    
    DEFINE l_per_r     STRING    
    DEFINE l_per_l_fmt STRING    
    DEFINE l_per_r_fmt STRING    
    DEFINE l_lastday   LIKE type_file.dat
    DEFINE l_display   LIKE type_file.chr1
    #FUN-B50158-------end-----str----
    
    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-B80158 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-B50158-------add-----str----
            LET l_unit = cl_gr_getmsg("gre-115",g_lang,tm.d)
            PRINTX l_unit
            LET l_lastday = MDY(tm.bm,'1',tm.yy) 
            LET l_lastday = s_last(l_lastday) 
            PRINTX l_lastday 
            #FUN-B50158-------end-----str----
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B50158-------add-----str----
            IF NOT cl_null(g_basetot1) THEN
               LET l_per_l = (sr1.bal_l / g_basetot1) * 100
               IF NOT cl_null(l_per_l) THEN   
                  LET l_per_l = l_per_l,'%'
               END IF
            ELSE
               LET l_per_l = "" 
            END IF
            PRINTX l_per_l

            IF NOT cl_null(g_basetot1) THEN
               LET l_per_r = (sr1.bal_r / g_basetot1) * 100
               IF NOT cl_null(L_per_r) THEN
                  LET l_per_r = l_per_r,'%'
               END IF
            ELSE
               LET l_per_r = "" 
            END IF
            PRINTX l_per_r
   
            LET l_per_l_fmt = cl_gr_numfmt("type_file","num20_6",tm.e)
            PRINTX l_per_l_fmt

            LET l_per_r_fmt = cl_gr_numfmt("type_file","num20_6",tm.e)
            PRINTX l_per_r_fmt 
            
            #FUN-B50158-------end-----str----

            #FUN-CB0051--add--str--
            IF sr1.maj03_l=="3" OR sr1.maj03_l=="4" OR sr1.line_l==1  THEN 
               LET sr1.maj20_l = " "
               LET sr1.bal_l = " "
               LET l_per_l = " "
            END IF  
            IF sr1.maj03_r=="3" OR sr1.maj03_r=="4" OR sr1.line_r==1  THEN 
               LET sr1.maj20_r = " "
               LET sr1.bal_r = " "
               LET l_per_r = " "
            END IF  
            #FUN-CB0051--add--end--

            PRINTX sr1.*

        
        ON LAST ROW

END REPORT
###GENGRE###END

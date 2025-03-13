# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: agli502.4gl
# Descriptions...: 部門預算維護作業
# Date & Author..: 92/02/21 BY Nora
#       MODIFY...: 92/09/09 BY Roger
#                  By Melody    G.gen_acct_budget功能改為不須先行 QBE 即可產生
#                  By Melody    新增 afb04 部門資料開窗查詢功能
#       MODIFY...: 99/03/18 BY Carol:add g_copy_flag 的判斷
#                                    用於copy時 let 己耗預算afc07=0
# Modify.........: No.MOD-470041 04/07/19 Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-480215 04/08/09 Kammy 1.產生科目預算無trasaction 控管
#                                               2.agli6022畫面欄位應設required
# Modify.........: No.MOD-480335 04/08/19 Nicola 新增時，各期預算預設為零
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-4C0080 04/12/15 By Smapmin 判斷科目拒絕部門
# Modify.........: No.FUN-510007 05/03/03 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-530386 05/03/26 By saki 科目開窗查詢只查預算控制打勾的資料
# Modify.........: No.MOD-530371 05/03/29 By Smapmin 沒做預算控管的科目仍可輸入
# Modify.........: No.MOD-560134 05/07/07 By Nicola (A18)未檢查部門為科目拒絕部門
# Modify.........: No.MOD-580315 05/09/12 By Smapmin afc06=0 的也應該要 INSERT ,
#                  以免後續系統回寫預算之耗用數(afc07) 因為當期沒有預算, 而沒有UPDATE
# Modify.........: No.FUN-590124 05/10/05 By Dido aag02科目名稱放寬
# Modify.........: No.MOD-5A0259 05/10/28 By Smapmin 變數長度不足
# Modify.........: No.TQC-5B0045 05/11/07 By Smapmin 資料列印位置調整
# Modify.........: No.TQC-620028 06/02/22 By Smapmin 有做部門管理的科目才需CALL s_chkdept
# Modify.........: No.TQC-630059 06/03/09 By Pengu 部門預算調整後僅調整季加總預算,未調整各期預算
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.TQC-630206 06/03/30 By Smapmin 將chmod 777 不成功的錯誤訊息顯示出來
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.MOD-6C0097 06/12/18 By Smapmin 於START REPORT 一開始就chmod 777
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730070 07/04/03 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-740206 07/04/28 By Lynn 每期金額應要依照幣別取位后再合計至季與年
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/08/03 By sherry  報表改由Crystal Report輸出                                                     
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-8C0049 08/12/09 By Sarah i502_period()計算每一期預算後應馬上取位,這樣算每季的最後一個月預算時才不會有尾差
# Modify.........: No.MOD-920029 09/02/03 By wujie START REPORT之前的chmod移除 
# Modify.........: No.MOD-950004 09/05/04 By wujie afb041,afb042預設' '
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.TQC-B50111 11/05/19 By yinhy afb04改為afb041
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

IMPORT os   #No.FUN-9C0009
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    g_afb     RECORD LIKE afb_file.*,
    g_afb_t   RECORD LIKE afb_file.*,
    g_afb_o   RECORD LIKE afb_file.*,
    g_aaa     RECORD LIKE aaa_file.*,
    g_bookno  LIKE afb_file.afb00,
    g_afb00_t LIKE afb_file.afb00,  #No.FUN-730070
    g_afb01_t LIKE afb_file.afb01,
    g_afb02_t LIKE afb_file.afb02,
    g_afb03_t LIKE afb_file.afb03,
    #g_afb04_t LIKE afb_file.afb04, #No.FUN-B50111
    g_afb041_t LIKE afb_file.afb041,#No.FUN-B50111
    g_afb04_t LIKE afb_file.afb04, #No.FUN-B50111
    g_afb042_t LIKE afb_file.afb042, #No.FUN-B50111
    g_afc  RECORD
           afc06_1 LIKE afc_file.afc06,
           afc06_2 LIKE afc_file.afc06,
           afc06_3 LIKE afc_file.afc06,
           afc06_4 LIKE afc_file.afc06,
           afc06_5 LIKE afc_file.afc06,
           afc06_6 LIKE afc_file.afc06,
           afc06_7 LIKE afc_file.afc06,
           afc06_8 LIKE afc_file.afc06,
           afc06_9 LIKE afc_file.afc06,
           afc06_10 LIKE afc_file.afc06,
           afc06_11 LIKE afc_file.afc06,
           afc06_12 LIKE afc_file.afc06,
           afc06_13 LIKE afc_file.afc06
    END RECORD,
    g_afc1 RECORD
           afc07_1 LIKE afc_file.afc07,
           afc07_2 LIKE afc_file.afc07,
           afc07_3 LIKE afc_file.afc07,
           afc07_4 LIKE afc_file.afc07,
           afc07_5 LIKE afc_file.afc07,
           afc07_6 LIKE afc_file.afc07,
           afc07_7 LIKE afc_file.afc07,
           afc07_8 LIKE afc_file.afc07,
           afc07_9 LIKE afc_file.afc07,
           afc07_10 LIKE afc_file.afc07,
           afc07_11 LIKE afc_file.afc07,
           afc07_12 LIKE afc_file.afc07,
           afc07_13 LIKE afc_file.afc07
    END RECORD,
    g_afc_o  RECORD
           afc06_1 LIKE afc_file.afc06,
           afc06_2 LIKE afc_file.afc06,
           afc06_3 LIKE afc_file.afc06,
           afc06_4 LIKE afc_file.afc06,
           afc06_5 LIKE afc_file.afc06,
           afc06_6 LIKE afc_file.afc06,
           afc06_7 LIKE afc_file.afc06,
           afc06_8 LIKE afc_file.afc06,
           afc06_9 LIKE afc_file.afc06,
           afc06_10 LIKE afc_file.afc06,
           afc06_11 LIKE afc_file.afc06,
           afc06_12 LIKE afc_file.afc06,
           afc06_13 LIKE afc_file.afc06
#                  By Melody    新增 afb04 部門資料開窗查詢功能
    END RECORD,
    g_afc_t  RECORD
           afc06_1 LIKE afc_file.afc06,
           afc06_2 LIKE afc_file.afc06,
           afc06_3 LIKE afc_file.afc06,
           afc06_4 LIKE afc_file.afc06,
           afc06_5 LIKE afc_file.afc06,
           afc06_6 LIKE afc_file.afc06,
           afc06_7 LIKE afc_file.afc06,
           afc06_8 LIKE afc_file.afc06,
           afc06_9 LIKE afc_file.afc06,
           afc06_10 LIKE afc_file.afc06,
           afc06_11 LIKE afc_file.afc06,
           afc06_12 LIKE afc_file.afc06,
           afc06_13 LIKE afc_file.afc06
    END RECORD,
    l_afc06   ARRAY[13] OF LIKE afc_file.afc06,
    l_afc07   ARRAY[13] OF LIKE afc_file.afc07,
#   g_wc,g_sql          VARCHAR(300),
    g_wc,g_sql          STRING,        #TQC-630166   
    bookno              LIKE aaa_file.aaa01,          #No.FUN-730070
    budget              LIKE afb_file.afb01,         #No.FUN-680098  VARCHAR(04)
    g_copy_flag         LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(01)
    yyy                 LIKE type_file.num10,         #No.FUN-680098  SMALLINT  #No.FUN-730070
    p_p001              LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
    g_flag              LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE g_aaa03               LIKE aaa_file.aaa03
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680098 INTEGER 
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose  #No.FUN-680098   SMALLLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680098  INTEGER 
DEFINE mi_no_ask             LIKE type_file.num5          #No.FUN-680098  SMALLINT
#No.FUN-760085---Begin                                                                                                              
DEFINE   g_str           STRING                                                                                                     
DEFINE   l_sql           STRING                                                                                                     
DEFINE   l_table         STRING                                                                                                     
#No.FUN-760085---End   
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
      DEFINE
           p_row,p_col     LIKE type_file.num5           #No.FUN-680098 SMALLINT
 
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
   #No.FUN-760085---Begin
   LET g_sql = "afb00.afb_file.afb00,",
               "afb01.afb_file.afb01,",
               "afa02.afa_file.afa02,",
               "afbacti.afb_file.afbacti,", 
               "afb02.afb_file.afb02,",
               "aag02.aag_file.aag02,",
               "afb03.afb_file.afb03,",
               "afb05.afb_file.afb05,",
               #"afb04.afb_file.afb04,",  #No.TQC-B50111
               "afb041.afb_file.afb041,", #No.TQC-B50111  
               "afb04.afb_file.afb04,", #No.TQC-B50111  
               "afb042.afb_file.afb042,", #No.TQC-B50111  
               "l_afc06_1.afc_file.afc06,",
               "l_afc06_2.afc_file.afc06,",
               "l_afc06_3.afc_file.afc06,",
               "l_afc06_4.afc_file.afc06,",
               "l_afc06_5.afc_file.afc06,",
               "l_afc06_6.afc_file.afc06,",
               "l_afc06_7.afc_file.afc06,",
               "l_afc06_8.afc_file.afc06,",
               "l_afc06_9.afc_file.afc06,",
               "l_afc06_10.afc_file.afc06,",
               "l_afc06_11.afc_file.afc06,",
               "l_afc06_12.afc_file.afc06,",
               "l_afc06_13.afc_file.afc06,",
               "afb11.afb_file.afb11,",
               "afb12.afb_file.afb12,",
               "afb13.afb_file.afb13,",
               "afb14.afb_file.afb14,",
               "afb10.afb_file.afb10,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05 "
 
   LET l_table = cl_prt_temptable('agli502',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",         
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?) "         #No.TQC-B50111                                                                               
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #NO.FUN-760085---End    
   
 
    INITIALIZE g_afb.* TO NULL
    INITIALIZE g_afc.* TO NULL
    INITIALIZE g_afb_t.* TO NULL
    INITIALIZE g_afb_o.* TO NULL
    INITIALIZE g_afc_t.* TO NULL
    INITIALIZE g_afc_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM afb_file WHERE afb00 = ? AND afb01 = ? AND afb02 = ? AND afb03 = ? AND afb041 = ? AND afb04 = ? AND afb042 = ? FOR UPDATE" ##No.TQC-B50111  afb04 改為afb041  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i502_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET g_copy_flag = 'N'
    #No.FUN-730070  --Begin
    #LET g_bookno = ARG_VAL(1)
    #IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
    #SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
 
    #CALL s_dsmark(g_bookno)
    #No.FUN-730070  --End  
 
    LET p_row = 2 LET p_col = 6
 
    OPEN WINDOW i502_w AT p_row,p_col WITH FORM "agl/42f/agli502"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #CALL s_shwact(3,2,g_bookno)  #No.FUN-730070
 
    CALL i502_menu()
 
    CLOSE WINDOW i502_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i502_cs()
    CLEAR FORM
   INITIALIZE g_afb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        #afb00,   afb01   ,afb02  ,afb03  ,afb04,  afb07   , afb09  ,  #No.FUN-730070 #No.TQC-B50111
        afb00,   afb01   ,afb02  ,afb03  ,afb041,  afb07   , afb09  ,  #No.TQC-B50111
        afb05   ,afb06  , afb10 ,
        afbuser ,afbgrup,afbmodu,afbdate,afbacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON ACTION controlp
       #No.FUN-730070  --Begin
       IF INFIELD(afb00) THEN
          CALL cl_init_qry_var()
          LET g_qryparam.state = "c"
          LET g_qryparam.form ="q_aaa"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO afb00
       END IF
       #No.FUN-730070  --End   
       IF INFIELD(afb01) THEN
#         CALL q_afa(0,0,g_afb.afb01,g_bookno) RETURNING g_afb.afb01
          CALL cl_init_qry_var()
          LET g_qryparam.state = "c"
          LET g_qryparam.form ="q_afa"       
          LET g_qryparam.default1 = g_afb.afb01
          #LET g_qryparam.where = " afa00 = '",g_bookno,"'"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO afb01
       END IF
       IF INFIELD(afb02) THEN
#         CALL q_aag(0,0,g_afb.afb02,' ','24',' ') RETURNING g_afb.afb02
          CALL cl_init_qry_var()
          LET g_qryparam.state = "c"
          LET g_qryparam.form ="q_aag"
          LET g_qryparam.default1 = g_afb.afb02
           LET g_qryparam.where = " aag03 matches '[24]' AND aag21 = 'Y'"  # No.MOD-530386
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO afb02
       END IF
       #IF INFIELD(afb04) THEN  #No.TQC-B50111
       IF INFIELD(afb041) THEN  #No.TQC-B50111
#         CALL q_gem(0,0,g_afb.afb04) RETURNING g_afb.afb04
          CALL cl_init_qry_var()
          LET g_qryparam.state = "c"
          LET g_qryparam.form ="q_gem"
          #LET g_qryparam.default1 = g_afb.afb04 #No.TQC-B50111
          LET g_qryparam.default1 = g_afb.afb041 #No.TQC-B50111
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          #DISPLAY g_qryparam.multiret TO afb04  #No.TQC-B50111
          DISPLAY g_qryparam.multiret TO afb041  #No.TQC-B50111
       END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND afbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND afbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND afbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('afbuser', 'afbgrup')
    #End:FUN-980030
 
    #No.FUN-730070  --Begin
    #LET g_sql="SELECT afb00,afb01,afb02,afb03,afb04 ",   #No.TQC-B50111
    LET g_sql="SELECT afb00,afb01,afb02,afb03,afb041,afb04,afb042 ",   #No.TQC-B50111
              "  FROM afb_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED," AND afb15 = '2'",
              "   AND afbacti = 'Y' ",                       #FUN-D70090 add 
             # " ORDER BY afb00,afb01,afb04,afb02,afb03" #no.7355 #No.TQC-B50111
              " ORDER BY afb00,afb01,afb041,afb02,afb03" #no.7355 #No.TQC-B50111
    PREPARE i502_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i502_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i502_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM afb_file ",
        " WHERE ", g_wc CLIPPED," AND afb15 = '2'"
       ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
    #No.FUN-730070  --End  
    PREPARE i502_precount FROM g_sql
    DECLARE i502_count CURSOR FOR i502_precount
END FUNCTION
 
FUNCTION i502_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i502_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i502_q()
            END IF
        ON ACTION next
            CALL i502_fetch('N')
        ON ACTION previous
            CALL i502_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i502_u()
            END IF
        ON ACTION adjust
            LET g_action_choice="adjust"
            IF cl_chk_act_auth() AND g_afb.afb01 IS NOT NULL THEN
                 CALL i502_m()
            END IF
        ON ACTION gen_acct_budget
            LET g_action_choice="gen_acct_budget"
            IF cl_chk_act_auth() THEN
                 CALL i502_g()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i502_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i502_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i502_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i502_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #CKP
           CALL cl_set_field_pic("","","","","",g_afb.afbacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION jump
            CALL i502_fetch('/')
        ON ACTION first
            CALL i502_fetch('F')
        ON ACTION last
            CALL i502_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_afb.afb01 IS NOT NULL THEN
                 LET g_doc.column1 = "afb00"
                 LET g_doc.value1 = g_afb.afb00
                 LET g_doc.column2 = "afb01"
                 LET g_doc.value2 = g_afb.afb01
                 LET g_doc.column3 = "afb02"
                 LET g_doc.value3 = g_afb.afb02
                 LET g_doc.column4 = "afb03"
                 LET g_doc.value4 = g_afb.afb03
                 #LET g_doc.column5 = "afb04"     #No.TQC-B50111                 
                 #LET g_doc.value5 = g_afb.afb04  #No.TQC-B50111 
                 LET g_doc.value5 = g_afb.afb041  #No.TQC-B50111 
                 LET g_doc.column5 = "afb041"     #No.TQC-B50111
                 CALL cl_doc()
              END IF
           END IF
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i502_cs
END FUNCTION
 
 
FUNCTION i502_a()
    IF s_aglshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_afb.* LIKE afb_file.*
    LET g_afb.afb15 = '2'
    INITIALIZE g_afc.* TO NULL
    LET g_afb00_t = NULL     #No.FUN-730070
    LET g_afb01_t = NULL LET g_afb02_t = NULL
    LET g_afb03_t = NULL #LET g_afb04_t = NULL #No.TQC-B50111
    LET g_afb041_t = NULL                      #No.TQC-B50111
    CALL cl_opmsg('a')
    WHILE TRUE
#       LET g_afb.afb00 = g_bookno  #No.FUN-730070
        LET g_afb.afb07 = '1'
        LET g_afb.afb08 = '1'
        LET g_afb.afb09 = 'Y'
         #-----No.MOD-480335-----
        LET g_afc.afc06_1 = 0
        LET g_afc.afc06_2 = 0
        LET g_afc.afc06_3 = 0
        LET g_afc.afc06_4 = 0
        LET g_afc.afc06_5 = 0
        LET g_afc.afc06_6 = 0
        LET g_afc.afc06_7 = 0
        LET g_afc.afc06_8 = 0
        LET g_afc.afc06_9 = 0
        LET g_afc.afc06_10 = 0
        LET g_afc.afc06_11 = 0
        LET g_afc.afc06_12 = 0
        LET g_afc.afc06_13 = 0
        LET g_afb.afb10 = 0
        LET g_afb.afb11 = 0
        LET g_afb.afb12 = 0
        LET g_afb.afb13 = 0
        LET g_afb.afb14 = 0
        #-----END---------------
        LET g_afb.afbacti ='Y'                   #有效的資料
        LET g_afb.afbuser = g_user
        LET g_afb.afboriu = g_user #FUN-980030
        LET g_afb.afborig = g_grup #FUN-980030
        LET g_afb.afbgrup = g_grup               #使用者所屬群
        LET g_afb.afbdate = g_today
#No.MOD-950004 --begin
        #LET g_afb.afb041  = ' '   #FUN-B50111 
        LET g_afb.afb04  = ' '     #FUN-B50111
        LET g_afb.afb042  = ' '
#No.MOD-950004 --end
        INITIALIZE g_afb_o.* TO NULL
        INITIALIZE g_afc_o.* TO NULL
        CALL i502_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_afb.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_afb.afb01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        #No.FUN-730070  --Begin
        IF g_afb.afb00 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        #No.FUN-730070  --End  
        INSERT INTO afb_file VALUES(g_afb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","afb_file",g_afb.afb01,g_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        ELSE
            LET g_afb_t.* = g_afb.*                # 保存上筆資料
            LET g_afc_t.* = g_afc.*                # 保存上筆資料
            LET g_afb_o.* = g_afb.*                # 保存上筆資料
            LET g_afc_o.* = g_afc.*                # 保存上筆資料
            SELECT afb01 INTO g_afb.afb01 FROM afb_file
                WHERE afb00 = g_afb.afb00  #No.FUN-730070
                  AND afb01 = g_afb.afb01
                  AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                  #AND afb04 = g_afb.afb04  #No.TQC-B50111
                  AND afb041 = g_afb.afb041 #No.TQC-B50111
                  AND afbacti = 'Y'                         #FUN-D70090 add
           BEGIN WORK
           CALL i502_addafc('a')   #產生期預算
           COMMIT WORK
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i502_addafc(p_cmd)
    DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
#           l_sql     VARCHAR(200), 
            l_sql     STRING,        #TQC-630166   
            l_n       LIKE type_file.num5          #No.FUN-680098  SMALLINT
    IF p_cmd = 'u' OR p_cmd = 'c' THEN
       DELETE FROM afc_file WHERE afc00 = g_afb_t.afb00 AND afc01 = g_afb_t.afb01  #No.FUN-730070
                         AND afc02 = g_afb_t.afb02 AND afc03 = g_afb_t.afb03
                         AND afc04 = g_afb_t.afb04 
                         AND afc041 = g_afb_t.afb041 #No.TQC-B50111
                         AND afc042 = g_afb_t.afb042 #No.TQC-B50111
       IF SQLCA.sqlcode THEN 
#          CALL cl_err('delete:',SQLCA.sqlcode,0)  #No.FUN-660123
           CALL cl_err3("del","afc_file",g_afb_t.afb01,g_afb_t.afb02,SQLCA.sqlcode,"","delete:",1)  #No.FUN-660123
       END IF
    END IF
    LET l_afc06[1] = g_afc.afc06_1  LET l_afc06[2] = g_afc.afc06_2
    LET l_afc06[3] = g_afc.afc06_3  LET l_afc06[4] = g_afc.afc06_4
    LET l_afc06[5] = g_afc.afc06_5  LET l_afc06[6] = g_afc.afc06_6
    LET l_afc06[7] = g_afc.afc06_7  LET l_afc06[8] = g_afc.afc06_8
    LET l_afc06[9] = g_afc.afc06_9  LET l_afc06[10] = g_afc.afc06_10
    LET l_afc06[11] = g_afc.afc06_11  LET l_afc06[12] = g_afc.afc06_12
    LET l_afc06[13] = g_afc.afc06_13
    #Modify:99/04/19
    IF p_cmd = 'a' THEN
       LET l_afc07[1] = 0
       LET l_afc07[2] = 0
       LET l_afc07[3] = 0
       LET l_afc07[4] = 0
       LET l_afc07[5] = 0
       LET l_afc07[6] = 0
       LET l_afc07[7] = 0
       LET l_afc07[8] = 0
       LET l_afc07[9] = 0
       LET l_afc07[10] = 0
       LET l_afc07[11] = 0
       LET l_afc07[12] = 0
       LET l_afc07[13] = 0
    ELSE
       LET l_afc07[1] = g_afc1.afc07_1  LET l_afc07[2] = g_afc1.afc07_2
       LET l_afc07[3] = g_afc1.afc07_3  LET l_afc07[4] = g_afc1.afc07_4
       LET l_afc07[5] = g_afc1.afc07_5  LET l_afc07[6] = g_afc1.afc07_6
       LET l_afc07[7] = g_afc1.afc07_7  LET l_afc07[8] = g_afc1.afc07_8
       LET l_afc07[9] = g_afc1.afc07_9  LET l_afc07[10] = g_afc1.afc07_10
       LET l_afc07[11] = g_afc1.afc07_11  LET l_afc07[12] = g_afc1.afc07_12
       LET l_afc07[13] = g_afc1.afc07_13
    END IF
     LET l_sql = "INSERT INTO afc_file (afc00,afc01,afc02,afc03,afc041,afc05,",  #No:BUG-470041 #No.MOD-470574
                "                      afc06,afc07,afc04,afc042) ",
                " VALUES ('",g_afb.afb00,"','",g_afb.afb01,"','",  #No.FUN-730070
               # g_afb.afb02,"',",g_afb.afb03,",'",g_afb.afb04,"',", #No.TQC-B50111
                g_afb.afb02,"',",g_afb.afb03,",'",g_afb.afb041,"',", #No.TQC-B50111
                "?,?,?,'",g_afb.afb04,"','",g_afb.afb042,"')"
    PREPARE i502_p3 FROM l_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) END IF
    DECLARE i502_c3 CURSOR FOR i502_p3
    OPEN i502_c3
 
    IF g_aza.aza02 = '1' THEN
       LET g_cnt = 12
    ELSE
       LET g_cnt = 13
    END IF
    FOR l_n = 1 TO g_cnt
#MOD-580315
#        IF (l_afc06[l_n] IS NULL OR l_afc06[l_n] = 0) AND
#           (l_afc07[l_n] IS NULL OR l_afc07[l_n] = 0) THEN
#           CONTINUE FOR
#        END IF
#END MOD-580315
        IF l_afc06[l_n] IS NULL THEN LET l_afc06[l_n] = 0 END IF
        IF l_afc07[l_n] IS NULL THEN LET l_afc07[l_n] = 0 END IF
        IF g_copy_flag = 'Y'  THEN LET l_afc07[l_n] = 0 END IF
        PUT i502_c3 FROM l_n,l_afc06[l_n],l_afc07[l_n]
        IF SQLCA.sqlcode THEN
           CALL cl_err('ins_afc:',SQLCA.sqlcode,0) EXIT FOR
        END IF
    END FOR
    CLOSE i502_c3
END FUNCTION
 
FUNCTION i502_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入   #No.FUN-680098CHAR(1)
        l_dir1          LIKE type_file.chr1,          #                  #No.FUN-680098 VARCHAR(1)
        l_dir2          LIKE type_file.chr1,          #                  #No.FUN-680098 VARCHAR(1)
        l_dir3          LIKE type_file.chr1,          #                  #No.FUN-680098 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680098 SMALLINT
        l_aag21         LIKE aag_file.aag21,  #MOD-530371
        l_aag05         LIKE aag_file.aag05   #TQC-620028
 
    DISPLAY BY NAME g_afb.afbuser,g_afb.afbgrup,
        g_afb.afbdate, g_afb.afbacti
 
    INPUT BY NAME g_afb.afboriu,g_afb.afborig,
        g_afb.afb00   ,    #No.FUN-730070
#        g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb04   , #No.TQC-B50111
        g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb041   , #No.TQC-B50111
#       g_afb.afb07   ,g_afb.afb08,   g_afb.afb09   ,
        g_afb.afb07   ,g_afb.afb09   ,
        g_afb.afb05   ,g_afb.afb06   ,  g_afb.afb10   ,g_afc.afc06_1 ,
        g_afc.afc06_2 ,g_afc.afc06_3 ,g_afc.afc06_4 ,g_afc.afc06_5 ,
        g_afc.afc06_6 ,g_afc.afc06_7 ,g_afc.afc06_8 ,g_afc.afc06_9 ,
        g_afc.afc06_10,g_afc.afc06_11,g_afc.afc06_12,g_afc.afc06_13,
        g_afb.afb11   ,g_afb.afb12   ,g_afb.afb13   ,g_afb.afb14
        WITHOUT DEFAULTS
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i502_set_entry(p_cmd)
            CALL i502_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        #No.FUN-730070  --Begin
        AFTER FIELD afb00
            IF g_afb.afb00 IS NOT NULL THEN
               IF (g_afb_o.afb00 IS NULL) OR (g_afb.afb00 != g_afb_o.afb00) THEN
                  CALL i502_afb00('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_afb.afb00,g_errno,0)
                     LET g_afb.afb00 = g_afb_t.afb00
                     DISPLAY BY NAME g_afb.afb00
                     NEXT FIELD afb00
                  END IF
               END IF
               SELECT * INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_afb.afb00
               SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03
               LET g_afb_o.afb00 = g_afb.afb00
            END IF
        #No.FUN-730070  --End  
 
        AFTER FIELD afb01
            IF cl_null(g_afb.afb00) THEN NEXT FIELD afb00 END IF  #No.FUN-730070
            IF g_afb.afb01 IS NOT NULL THEN
               IF (g_afb_o.afb01 IS NULL) OR (g_afb.afb01 != g_afb_o.afb01) THEN
                  CALL i502_afb01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_afb.afb01,g_errno,0)
                     LET g_afb.afb01 = g_afb_t.afb01
                     DISPLAY BY NAME g_afb.afb01
                     NEXT FIELD afb01
                  END IF
               END IF
               LET g_afb_o.afb01 = g_afb.afb01
            END IF
 
        AFTER FIELD afb02
#Mark No.FUN-B10048
##MOD-530371
#           SELECT aag21 INTO l_aag21 FROM aag_file WHERE aag01=g_afb.afb02 
#                                                     AND aag00=g_afb.afb00 #No.FUN-730070
#           DISPLAY "g_afb.afb02=",g_afb.afb02
#           DISPLAY "l_aag21=",l_aag21
#           IF l_aag21 <> 'Y' THEN
#              CALL cl_err(g_afb.afb02,'aag-924',1)
#              NEXT FIELD afb02
#           END IF
##END MOD-530371
#End Mark No.FUN-B10048
            IF g_afb.afb02 IS NOT NULL THEN
               IF (g_afb_o.afb02 IS NULL) OR (g_afb.afb02 != g_afb_o.afb02) THEN
                  CALL i502_afb02('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_afb.afb02,g_errno,0)
                    #Mod No.FUN-B10048
                    #LET g_afb.afb02 = g_afb_o.afb02
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.construct = 'N'
                     LET g_qryparam.default1 = g_afb.afb02
                     LET g_qryparam.arg1 = g_afb.afb00
                     LET g_qryparam.where = " aag03 matches '[24]' AND aag21 = 'Y' AND aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_afb.afb02 CLIPPED,"%'"
                     CALL cl_create_qry() RETURNING g_afb.afb02
                    #End Mod No.FUN-B10048
                     DISPLAY BY NAME g_afb.afb02
                     NEXT FIELD afb02
                  END IF
               END IF
               LET g_afb_o.afb02 = g_afb.afb02
            END IF
 
        #AFTER FIELD afb04  #No.TQC-B50111
        AFTER FIELD afb041  #No.TQC-B50111   
            IF g_afb.afb04 IS NOT NULL THEN
               CALL i502_afb04('a') 
               IF NOT cl_null(g_errno) THEN
                 #No.TQC-B50111  --Begin  
                 #CALL cl_err(g_afb.afb04,g_errno,0)
                 #LET g_afb.afb04 = g_afb_o.afb04
                 #DISPLAY BY NAME g_afb.afb04
                 #NEXT FIELD afb04
                 CALL cl_err(g_afb.afb041,g_errno,0)
                 LET g_afb.afb041 = g_afb_o.afb041
                 DISPLAY BY NAME g_afb.afb041
                 NEXT FIELD afb041
                 #No.TQC-B50111  --End
               END IF
               #-----TQC-620028---------
               SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_afb.afb02 
                                                         AND aag00 =g_afb.afb00   #No.FUN-730070
               IF l_aag05 = 'Y' THEN
               #-----END TQC-620028-----
                  #-----No.MOD-560134-----
                  #CALL s_chkdept(g_aaz.aaz72,g_afb.afb02,g_afb.afb04,g_afb.afb00) RETURNING g_errno #No.FUN-730070 #No.TQC-B50111
                  CALL s_chkdept(g_aaz.aaz72,g_afb.afb02,g_afb.afb041,g_afb.afb00) RETURNING g_errno #No.FUN-730070 #No.TQC-B50111
                  IF not cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     #NEXT FIELD  afb04 #No.TQC-B50111
                     NEXT FIELD  afb041 #No.TQC-B50111
                  END IF
                  #-----No.MOD-560134 END-----
               END IF   #TQC-620028
               #No.FUN-730070  --Begin
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND (g_afb.afb00 = g_afb00_t   
                  OR  g_afb.afb01 != g_afb01_t OR  g_afb.afb02 != g_afb02_t
                  #OR  g_afb.afb03 != g_afb03_t OR  g_afb.afb04 != g_afb04_t))  #No.TQC-B50111
                  OR  g_afb.afb03 != g_afb03_t OR  g_afb.afb041 != g_afb041_t)) #No.TQC-B50111
                  THEN
                  SELECT count(*) INTO l_n FROM afb_file
                      WHERE afb00 = g_afb.afb00
                        AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02
                        #AND afb03 = g_afb.afb03 AND afb04 = g_afb.afb04   #No.TQC-B50111
                        AND afb03 = g_afb.afb03 AND afb041 = g_afb.afb041  #No.TQC-B50111
                        AND afbacti = 'Y'                         #FUN-D70090 add
                  IF l_n > 0 THEN                  # Duplicated
                      LET g_msg = g_afb.afb00 CLIPPED,'+',g_afb.afb01 CLIPPED,
                              '+',g_afb.afb02 CLIPPED,'+',g_afb.afb03 CLIPPED,
                             # '+',g_afb.afb04 CLIPPED  #No.TQC-B50111
                              '+',g_afb.afb041 CLIPPED  #No.TQC-B50111
                      CALL cl_err(g_msg,-239,0)
                      LET g_afb.afb00 = g_afb00_t
                      LET g_afb.afb01 = g_afb01_t LET g_afb.afb02 = g_afb02_t
                      #LET g_afb.afb03 = g_afb03_t LET g_afb.afb04 = g_afb04_t  #No.TQC-B50111
                      LET g_afb.afb03 = g_afb03_t LET g_afb.afb041 = g_afb041_t #No.TQC-B50111
                      DISPLAY BY NAME g_afb.afb01,g_afb.afb02,
                                      #g_afb.afb03,g_afb.afb04,g_afb.afb00  #No.TQC-B50111
                                      g_afb.afb03,g_afb.afb041,g_afb.afb00  #No.TQC-B50111
                      NEXT FIELD afb00
                  END IF
               END IF
               #No.FUN-730070  --End  
            END IF
            ##MOD-4C0080
           #SELECT COUNT(*) INTO l_n FROM aab_file
           #    WHERE aab01 = g_afb.afb02 AND aab02 = g_afb.afb04
           #IF l_n > 0 THEN
           #   CALL cl_err('','agl-300',1)
           #   NEXT FIELD afb04
           #END IF
            ##MOD-4C0080(END)
 
        AFTER FIELD afb07
            IF NOT cl_null(g_afb.afb07) THEN
               IF g_afb.afb07 NOT MATCHES '[1-3]' THEN
                  LET g_afb.afb07 = g_afb_o.afb07
                  DISPLAY BY NAME g_afb.afb07
                  NEXT FIELD afb07
               END IF
            END IF
 
        AFTER FIELD afb09
            IF NOT cl_null(g_afb.afb09) THEN
               IF g_afb.afb09 NOT MATCHES '[yYnN]' THEN
                  LET g_afb.afb09 = g_afb_o.afb09
                  DISPLAY BY NAME g_afb.afb09
                  NEXT FIELD afb09
               END IF
           END IF
 
        BEFORE FIELD afb05
            CALL i502_set_entry(p_cmd)
 
        AFTER FIELD afb05
 
           IF g_afb.afb05 IS NOT NULL THEN
              IF g_afb.afb05 NOT MATCHES '[1-3]' THEN
                 LET g_afb.afb05 = g_afb_o.afb05
                 DISPLAY BY NAME g_afb.afb05
                 NEXT FIELD afb05
              END IF
              IF g_afb_o.afb05 != g_afb.afb05 THEN
                 CASE g_afb.afb05
                      WHEN '1'  LET g_afb.afb06 = NULL   LET g_afb.afb10 = NULL
                                LET g_afb.afb11 = NULL   LET g_afb.afb12 = NULL
                                LET g_afb.afb13 = NULL   LET g_afb.afb14 = NULL
                                DISPLAY BY NAME g_afb.afb06,g_afb.afb10,
                                                g_afb.afb11,g_afb.afb12,
                                                g_afb.afb13,g_afb.afb14
                      WHEN '2'  LET g_afb.afb06 = NULL   LET g_afb.afb10 = NULL
                                INITIALIZE g_afc.* TO NULL
                                DISPLAY BY NAME g_afb.afb06,g_afb.afb10,
                                                g_afc.*
                      WHEN '3'  LET g_afb.afb11 = NULL   LET g_afb.afb12 = NULL
                                LET g_afb.afb13 = NULL   LET g_afb.afb14 = NULL
                                INITIALIZE g_afc.* TO NULL
                                DISPLAY BY NAME g_afb.afb11,g_afb.afb12,
                                                g_afb.afb13,g_afb.afb14,
                                                g_afc.*
                 END CASE
              END IF
              LET g_afb_o.afb05 = g_afb.afb05
              LET l_dir1 = 'U'
              LET l_dir2 = 'U'
              LET l_dir3 = 'U'
           END IF
           CALL i502_set_no_entry(p_cmd)
 
{
        BEFORE FIELD sfb06
            CASE g_afb.afb05
                 WHEN '1'
                     IF l_dir1 = 'U' THEN
                        NEXT FIELD afc06_1
                     END IF
                 OTHERWISE
                     IF g_aza.aza02 = '2' THEN
                        LET g_afb.afb06 = '2'
                        IF g_afb.afb05 = '2' THEN
                           IF l_dir2 = 'U' THEN
                              NEXT FIELD afb11
                           ELSE
                              NEXT FIELD afb05
                           END IF
                        ELSE
                           IF l_dir3 = 'U' THEN
                              NEXT FIELD afb11
                           ELSE
                              NEXT FIELD afb05
                           END IF
                        END IF
                        DISPLAY BY NAME g_afb.afb06
                     END IF
           END CASE
}
 
        AFTER FIELD afb06
            IF g_afb.afb06 IS NOT NULL THEN
               IF g_afb.afb06 NOT MATCHES'[12]' THEN
                  LET g_afb.afb06 = g_afb_o.afb06
                  DISPLAY BY NAME g_afb.afb06
                  NEXT FIELD afb06
               END IF
               IF g_afb.afb05 != '1' AND
                  g_afb.afb06 != g_afb_o.afb06 THEN
                  CALL i502_period('a')      #計算期預算
               END IF
               LET l_dir2 = 'U'
               LET g_afb_o.afb06 = g_afb.afb06
            END IF
{
        BEFORE FIELD afb10
            CASE g_afb.afb05
                 WHEN '2'
                     IF l_dir2 = 'U' THEN
                        NEXT FIELD afb11
                     ELSE
                        NEXT FIELD afb06
                     END IF
                 WHEN '1'
                     NEXT FIELD afb05
            END CASE
}
 
        AFTER FIELD afb10
           # CALL i502_set_no_entry('')
           #---010822增wiky
            #No.FUN-730070  --Begin
            SELECT * INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_afb.afb00
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03
            #No.FUN-730070  --End   
           #---
            LET l_dir1 = 'D'
            LET g_afb.afb11 = g_afb.afb10 * 0.25
            LET g_afb.afb12 = g_afb.afb10 * 0.25
            LET g_afb.afb13 = g_afb.afb10 * 0.25
            LET g_afb.afb14 = g_afb.afb10 -
               (g_afb.afb11 + g_afb.afb12 + g_afb.afb13)
            CALL i502_period('a')      #計算期預算
            LET l_dir3 = 'D'
            LET g_afb.afb10 = cl_numfor(g_afb.afb10,15,t_azi04)         #CHI-6A0004
            DISPLAY BY NAME g_afb.afb10
 
        AFTER FIELD afc06_1
#MOD-580315
           IF g_afc.afc06_1 IS NULL THEN
              LET  g_afc.afc06_1 = 0
               DISPLAY BY NAME g_afc.afc06_1
           END IF
#END MOD-580315
           CALL i502_afb11()          #重新計算季預算
           LET g_afc_o.afc06_1 = g_afc.afc06_1
           LET l_dir1 = 'D'
 
        AFTER FIELD afc06_2
#MOD-580315
           IF  g_afc.afc06_2 IS NULL THEN
               LET  g_afc.afc06_2 = 0
               DISPLAY BY NAME g_afc.afc06_2
           END IF
#END MOD-580315
           CALL i502_afb11()          #重新計算季預算
           LET g_afc_o.afc06_2 = g_afc.afc06_2
 
        AFTER FIELD afc06_3
#MOD-580315
           IF  g_afc.afc06_3 IS NULL THEN
               LET  g_afc.afc06_3 = 0
               DISPLAY BY NAME g_afc.afc06_3
           END IF
#END MOD-580315
           CALL i502_afb11()          #重新計算季預算
           LET g_afc_o.afc06_3 = g_afc.afc06_3
 
        AFTER FIELD afc06_4
#MOD-580315
           IF  g_afc.afc06_4 IS NULL THEN
               LET  g_afc.afc06_4 = 0
               DISPLAY BY NAME g_afc.afc06_4
           END IF
#END MOD-580315
           CALL i502_afb12()          #重新計算季預算
           LET g_afc_o.afc06_4 = g_afc.afc06_4
 
        AFTER FIELD afc06_5
#MOD-580315
           IF  g_afc.afc06_5 IS NULL THEN
               LET  g_afc.afc06_5 = 0
               DISPLAY BY NAME g_afc.afc06_5
           END IF
#END MOD-580315
           CALL i502_afb12()          #重新計算季預算
           LET g_afc_o.afc06_5 = g_afc.afc06_5
 
        AFTER FIELD afc06_6
#MOD-580315
           IF  g_afc.afc06_6 IS NULL THEN
               LET  g_afc.afc06_6 = 0
               DISPLAY BY NAME g_afc.afc06_6
           END IF
#END MOD-580315
           CALL i502_afb12()          #重新計算季預算
           LET g_afc_o.afc06_6 = g_afc.afc06_6
 
        AFTER FIELD afc06_7
#MOD-580315
           IF  g_afc.afc06_7 IS NULL THEN
               LET  g_afc.afc06_7 = 0
               DISPLAY BY NAME g_afc.afc06_7
           END IF
#END MOD-580315
           CALL i502_afb13()          #重新計算季預算
           LET g_afc_o.afc06_7 = g_afc.afc06_7
 
        AFTER FIELD afc06_8
#MOD-580315
           IF  g_afc.afc06_8 IS NULL THEN
               LET  g_afc.afc06_8 = 0
               DISPLAY BY NAME g_afc.afc06_8
           END IF
#END MOD-580315
           CALL i502_afb13()          #重新計算季預算
           LET g_afc_o.afc06_8 = g_afc.afc06_8
 
        AFTER FIELD afc06_9
#MOD-580315
           IF  g_afc.afc06_9 IS NULL THEN
               LET  g_afc.afc06_9 = 0
               DISPLAY BY NAME g_afc.afc06_9
           END IF
#END MOD-580315
           CALL i502_afb13()          #重新計算季預算
           LET g_afc_o.afc06_9 = g_afc.afc06_9
 
        AFTER FIELD afc06_10
#MOD-580315
           IF  g_afc.afc06_10 IS NULL THEN
               LET  g_afc.afc06_10 = 0
               DISPLAY BY NAME g_afc.afc06_10
           END IF
#END MOD-580315
           CALL i502_afb14()          #重新計算季預算
           LET g_afc_o.afc06_10 = g_afc.afc06_10
 
        AFTER FIELD afc06_11
#MOD-580315
           IF  g_afc.afc06_11 IS NULL THEN
               LET  g_afc.afc06_11 = 0
               DISPLAY BY NAME g_afc.afc06_11
           END IF
#END MOD-580315
           CALL i502_afb14()          #重新計算季預算
           LET g_afc_o.afc06_11 = g_afc.afc06_11
 
        AFTER FIELD afc06_12
#MOD-580315
           IF  g_afc.afc06_12 IS NULL THEN
               LET  g_afc.afc06_12 = 0
               DISPLAY BY NAME g_afc.afc06_12
           END IF
#END MOD-580315
           CALL i502_afb14()
 
        BEFORE FIELD afc06_13
           IF g_aza.aza02 = '1' THEN EXIT INPUT END IF
 
        AFTER FIELD afc06_13
#MOD-580315
           IF  g_afc.afc06_13 IS NULL THEN
               LET  g_afc.afc06_13= 0
               DISPLAY BY NAME g_afc.afc06_13
           END IF
#END MOD-580315
           CALL i502_afb14()
           LET l_dir2 = 'D'
 
        BEFORE FIELD afb11
           CASE g_afb.afb05
                WHEN '1' EXIT INPUT
           END CASE
 
 
        AFTER FIELD afb11
#MOD-580315
           IF  g_afb.afb11 IS NULL THEN
               LET  g_afb.afb11= 0
               DISPLAY BY NAME g_afb.afb11
           END IF
#END MOD-580315
           CALL i502_afb10()          #重新計算季預算
           CALL i502_period('1')
           LET g_afb_o.afb11 = g_afb.afb11
 
        AFTER FIELD afb12
#MOD-580315
           IF  g_afb.afb12 IS NULL THEN
               LET  g_afb.afb12= 0
               DISPLAY BY NAME g_afb.afb12
           END IF
#END MOD-580315
           CALL i502_afb10()          #重新計算季預算
           CALL i502_period('2')
           LET g_afb_o.afb12 = g_afb.afb12
 
        AFTER FIELD afb13
#MOD-580315
           IF  g_afb.afb13 IS NULL THEN
               LET  g_afb.afb13= 0
               DISPLAY BY NAME g_afb.afb13
           END IF
#END MOD-580315
              CALL i502_afb10()          #重新計算季預算
              CALL i502_period('3')
           LET g_afb_o.afb13 = g_afb.afb13
 
        AFTER FIELD afb14
#MOD-580315
           IF  g_afb.afb14 IS NULL THEN
               LET  g_afb.afb14= 0
               DISPLAY BY NAME g_afb.afb14
           END IF
#END MOD-580315
           CALL i502_afb10()          #重新計算季預算
           CALL i502_period('4')
           LET g_afb_o.afb14 = g_afb.afb14
 
## No:2447 modify 1998/09/28 -----
        AFTER INPUT #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_afb.afbuser = s_get_data_owner("afb_file") #FUN-C10039
           LET g_afb.afbgrup = s_get_data_group("afb_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
           { IF g_afb.afb01 IS NULL THEN
               DISPLAY BY NAME g_afb.afb01
            END IF
            IF g_afb.afb02 IS NULL THEN
               DISPLAY BY NAME g_afb.afb02
            END IF
            IF g_afb.afb03 IS NULL THEN
               DISPLAY BY NAME g_afb.afb03
            END IF
            IF g_afb.afb04 IS NULL THEN
               DISPLAY BY NAME g_afb.afb04
            END IF
               EXIT INPUT
            }
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(afb01) THEN
       #         LET g_afb.* = g_afb_t.*
       #         LET g_afc.* = g_afc_t.*
       #         DISPLAY BY NAME
       #           g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb04   ,
       #           g_afb.afb05   ,g_afb.afb06   ,g_afb.afb10   ,g_afc.afc06_1 ,
       #           g_afc.afc06_2 ,g_afc.afc06_3 ,g_afc.afc06_4 ,g_afc.afc06_5 ,
       #           g_afc.afc06_6 ,g_afc.afc06_7 ,g_afc.afc06_8 ,g_afc.afc06_9 ,
       #           g_afc.afc06_10,g_afc.afc06_11,g_afc.afc06_12,g_afc.afc06_13,
       #           g_afb.afb11   ,g_afb.afb12   ,g_afb.afb13   ,g_afb.afb14
       #         NEXT FIELD afb01
       #     END IF
        #MOD-650015 --end
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            #No.FUN-7300070  --Begin
            IF INFIELD(afb00) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = g_afb.afb00
               CALL cl_create_qry() RETURNING g_afb.afb00
               DISPLAY BY NAME g_afb.afb00
               CALL i502_afb00('d')
            END IF
            IF INFIELD(afb01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_afa"      
               LET g_qryparam.default1 = g_afb.afb01
#              LET g_qryparam.where = " afa00 = '",g_bookno,"'"
               LET g_qryparam.arg1  = g_afb.afb00     #No.MOD-950004
               CALL cl_create_qry() RETURNING g_afb.afb01
               DISPLAY BY NAME g_afb.afb01
               CALL i502_afb01('d')
            END IF
            IF INFIELD(afb02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = g_afb.afb02
               LET g_qryparam.arg1 = g_afb.afb00
               LET g_qryparam.where = " aag03 matches '[24]' AND aag21 = 'Y'"  # No.MOD-530386
               CALL cl_create_qry() RETURNING g_afb.afb02
               DISPLAY BY NAME g_afb.afb02
               CALL i502_afb02('d')
            END IF
            #No.FUN-7300070  --End  
            #IF INFIELD(afb04) THEN #No.TQC-B50111
            IF INFIELD(afb041) THEN #No.TQC-B50111
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               #LET g_qryparam.default1 = g_afb.afb04       #No.TQC-B50111
               #CALL cl_create_qry() RETURNING g_afb.afb04  #No.TQC-B50111
#               CALL FGL_DIALOG_SETBUFFER( g_afb.afb04 )
               #DISPLAY BY NAME g_afb.afb04                 #No.TQC-B50111
               LET g_qryparam.default1 = g_afb.afb041       #No.TQC-B50111
               CALL cl_create_qry() RETURNING g_afb.afb041  #No.TQC-B50111
               DISPLAY BY NAME g_afb.afb041                 #No.TQC-B50111
            END IF
 
         ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i502_afb04(p_cmd)  #會計科目
    DEFINE p_cmd  LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
           INTO l_gem02,l_gemacti
           #FROM gem_file WHERE gem01 = g_afb.afb04 AND gem05='Y' #No.TQC-B50111
           FROM gem_file WHERE gem01 = g_afb.afb041 AND gem05='Y' #No.TQC-B50111
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-003'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION
    #計算第一季預算
FUNCTION i502_afb11()
    LET g_afb.afb11 = g_afc.afc06_1 + g_afc.afc06_2
                    + g_afc.afc06_3
    LET g_afb.afb11 = cl_numfor(g_afb.afb11,15,t_azi04)     # No.FUN-740206
    DISPLAY BY NAME g_afb.afb11
END FUNCTION
 
FUNCTION i502_afb12()
    LET g_afb.afb12 = g_afc.afc06_4 + g_afc.afc06_5
                    + g_afc.afc06_6
    LET g_afb.afb12 = cl_numfor(g_afb.afb12,15,t_azi04)     # No.FUN-740206
    DISPLAY BY NAME g_afb.afb12
END FUNCTION
 
FUNCTION i502_afb13()
    LET g_afb.afb13 = g_afc.afc06_7 + g_afc.afc06_8
                    + g_afc.afc06_9
    LET g_afb.afb13 = cl_numfor(g_afb.afb13,15,t_azi04)     # No.FUN-740206
    DISPLAY BY NAME g_afb.afb13
END FUNCTION
 
FUNCTION i502_afb14()
    IF g_aza.aza02 = '1' THEN
       LET g_afb.afb14 = g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12
       LET g_afb.afb14 = cl_numfor(g_afb.afb14,15,t_azi04)  # No.FUN-740206
    ELSE
       LET g_afb.afb14 = g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12
                       + g_afc.afc06_13
       LET g_afb.afb14 = cl_numfor(g_afb.afb14,15,t_azi04)  # No.FUN-740206
    END IF
    LET g_afb.afb10 = g_afb.afb11 + g_afb.afb12 + g_afb.afb13 + g_afb.afb14
    LET g_afb.afb10 = cl_numfor(g_afb.afb10,15,t_azi04)    # No.FUN-740206   
    DISPLAY BY NAME g_afb.afb10,g_afb.afb14
END FUNCTION
 
FUNCTION i502_afb10()
    LET g_afb.afb10 = g_afb.afb11 + g_afb.afb12
                    + g_afb.afb13 + g_afb.afb14
    LET g_afb.afb10 = cl_numfor(g_afb.afb10,15,t_azi04)    # No.FUN-740206
    DISPLAY BY NAME g_afb.afb10
END FUNCTION
 
FUNCTION i502_period(p_cmd)
    DEFINE  p_cmd    LIKE type_file.chr1,                #No.FUN-680098  VARCHAR(1)
            l_fac1,l_fac2,l_fac3 LIKE type_file.num5,    #No.FUN-680098  SMALLINT
            l_tot    LIKE type_file.num5                 #No.FUN-680098  SMALLINT 
    IF g_afb.afb06 = '1' THEN
       LET l_tot  = g_aaz.aaz61+g_aaz.aaz62+g_aaz.aaz63
       LET l_fac1 = g_aaz.aaz61
       LET l_fac2 = g_aaz.aaz62
       LET l_fac3 = g_aaz.aaz63
    ELSE
       IF g_aza.aza02 = '1' THEN
          LET l_tot = 3
          LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
       ELSE
          LET l_tot = 4
          LET l_fac1 = 1  LET l_fac2 = 1  LET l_fac3 = 1
       END IF
    END IF
    CASE p_cmd
       WHEN 'a'
          LET g_afc.afc06_1= g_afb.afb11 * l_fac1 / l_tot
          LET g_afc.afc06_1= cl_numfor(g_afc.afc06_1,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_2= g_afb.afb11 * l_fac2 / l_tot
          LET g_afc.afc06_2= cl_numfor(g_afc.afc06_2,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_3= g_afb.afb11 -
                            (g_afc.afc06_1 + g_afc.afc06_2)
          LET g_afc.afc06_3= cl_numfor(g_afc.afc06_3,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_4= g_afb.afb12 * l_fac1 / l_tot
          LET g_afc.afc06_4= cl_numfor(g_afc.afc06_4,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_5= g_afb.afb12 * l_fac2 / l_tot
          LET g_afc.afc06_5= cl_numfor(g_afc.afc06_5,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_6= g_afb.afb12 -
                            (g_afc.afc06_4 + g_afc.afc06_5)
          LET g_afc.afc06_6= cl_numfor(g_afc.afc06_6,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_7= g_afb.afb13 * l_fac1 / l_tot
          LET g_afc.afc06_7= cl_numfor(g_afc.afc06_7,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_8= g_afb.afb13 * l_fac2 / l_tot
          LET g_afc.afc06_8= cl_numfor(g_afc.afc06_8,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_9= g_afb.afb13 -
                            (g_afc.afc06_7 + g_afc.afc06_8)
          LET g_afc.afc06_9= cl_numfor(g_afc.afc06_9,15,t_azi04)  #MOD-8C0049 add
          IF g_aza.aza02 = '1' THEN
             LET g_afc.afc06_10= g_afb.afb14 * l_fac1 / l_tot
             LET g_afc.afc06_10= cl_numfor(g_afc.afc06_10,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_11= g_afb.afb14 * l_fac2 / l_tot
             LET g_afc.afc06_11= cl_numfor(g_afc.afc06_11,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_12= g_afb.afb14 -
                                (g_afc.afc06_10 + g_afc.afc06_11)
             LET g_afc.afc06_12= cl_numfor(g_afc.afc06_12,15,t_azi04)  #MOD-8C0049 add
          ELSE
             LET g_afc.afc06_10= g_afb.afb14 * l_fac1 / l_tot
             LET g_afc.afc06_10= cl_numfor(g_afc.afc06_10,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_11= g_afb.afb14 * l_fac2 / l_tot
             LET g_afc.afc06_11= cl_numfor(g_afc.afc06_11,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_12= g_afb.afb14 * l_fac3 / l_tot
             LET g_afc.afc06_12= cl_numfor(g_afc.afc06_12,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_12= g_afb.afb14 -
                                (g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12)
             LET g_afc.afc06_13= cl_numfor(g_afc.afc06_13,15,t_azi04)  #MOD-8C0049 add
          END IF
       WHEN '1'
          LET g_afc.afc06_1= g_afb.afb11 * l_fac1 / l_tot
          LET g_afc.afc06_1= cl_numfor(g_afc.afc06_1,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_2= g_afb.afb11 * l_fac2 / l_tot
          LET g_afc.afc06_2= cl_numfor(g_afc.afc06_2,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_3= g_afb.afb11 -
                            (g_afc.afc06_1 + g_afc.afc06_2)
          LET g_afc.afc06_3= cl_numfor(g_afc.afc06_3,15,t_azi04)  #MOD-8C0049 add
       WHEN '2'
          LET g_afc.afc06_4= g_afb.afb12 * l_fac1 / l_tot
          LET g_afc.afc06_4= cl_numfor(g_afc.afc06_4,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_5= g_afb.afb12 * l_fac2 / l_tot
          LET g_afc.afc06_5= cl_numfor(g_afc.afc06_5,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_6= g_afb.afb12 -
                            (g_afc.afc06_4 + g_afc.afc06_5)
          LET g_afc.afc06_6= cl_numfor(g_afc.afc06_6,15,t_azi04)  #MOD-8C0049 add
       WHEN '3'
          LET g_afc.afc06_7= g_afb.afb13 * l_fac1 / l_tot
          LET g_afc.afc06_7= cl_numfor(g_afc.afc06_7,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_8= g_afb.afb13 * l_fac2 / l_tot
          LET g_afc.afc06_8= cl_numfor(g_afc.afc06_8,15,t_azi04)  #MOD-8C0049 add
          LET g_afc.afc06_9= g_afb.afb13 -
                            (g_afc.afc06_7 + g_afc.afc06_8)
          LET g_afc.afc06_9= cl_numfor(g_afc.afc06_9,15,t_azi04)  #MOD-8C0049 add
       WHEN '4'
          IF g_aza.aza02 = '1' THEN
             LET g_afc.afc06_10= g_afb.afb14 * l_fac1 / l_tot
             LET g_afc.afc06_10= cl_numfor(g_afc.afc06_10,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_11= g_afb.afb14 * l_fac2 / l_tot
             LET g_afc.afc06_11= cl_numfor(g_afc.afc06_11,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_12= g_afb.afb14 -
                               (g_afc.afc06_10 + g_afc.afc06_11)
             LET g_afc.afc06_12= cl_numfor(g_afc.afc06_12,15,t_azi04)  #MOD-8C0049 add
          ELSE
             LET g_afc.afc06_10= g_afb.afb14 * l_fac1 / l_tot
             LET g_afc.afc06_10= cl_numfor(g_afc.afc06_10,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_11= g_afb.afb14 * l_fac2 / l_tot
             LET g_afc.afc06_11= cl_numfor(g_afc.afc06_11,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_12= g_afb.afb14 * l_fac3 / l_tot
             LET g_afc.afc06_12= cl_numfor(g_afc.afc06_12,15,t_azi04)  #MOD-8C0049 add
             LET g_afc.afc06_13= g_afb.afb14 -
                                (g_afc.afc06_10 + g_afc.afc06_11 + g_afc.afc06_12)
             LET g_afc.afc06_13= cl_numfor(g_afc.afc06_13,15,t_azi04)  #MOD-8C0049 add
          END IF
    END CASE
    #--010822增
#str MOD-8C0049 mark
##CHI-6A0004---begin
#   LET g_afc.afc06_1= cl_numfor(g_afc.afc06_1,15,t_azi04)
#   LET g_afc.afc06_2= cl_numfor(g_afc.afc06_2,15,t_azi04)
#   LET g_afc.afc06_3= cl_numfor(g_afc.afc06_3,15,t_azi04)
#   LET g_afc.afc06_4= cl_numfor(g_afc.afc06_4,15,t_azi04)
#   LET g_afc.afc06_5= cl_numfor(g_afc.afc06_5,15,t_azi04)
#   LET g_afc.afc06_6= cl_numfor(g_afc.afc06_6,15,t_azi04)
#   LET g_afc.afc06_7= cl_numfor(g_afc.afc06_7,15,t_azi04)
#   LET g_afc.afc06_8= cl_numfor(g_afc.afc06_8,15,t_azi04)
#   LET g_afc.afc06_9= cl_numfor(g_afc.afc06_9,15,t_azi04)
#   LET g_afc.afc06_10=cl_numfor(g_afc.afc06_10,15,t_azi04)
#   LET g_afc.afc06_11=cl_numfor(g_afc.afc06_11,15,t_azi04)
#   LET g_afc.afc06_12=cl_numfor(g_afc.afc06_12,15,t_azi04)
#   LET g_afc.afc06_13=cl_numfor(g_afc.afc06_13,15,t_azi04)
#   LET g_afb.afb11=cl_numfor(g_afb.afb11,15,t_azi04)
#   LET g_afb.afb12=cl_numfor(g_afb.afb12,15,t_azi04)
#   LET g_afb.afb13=cl_numfor(g_afb.afb13,15,t_azi04)
#   LET g_afb.afb14=cl_numfor(g_afb.afb14,15,t_azi04)
##CHI-6A0004---end
#end MOD-8C0049 mark
    DISPLAY BY NAME g_afb.afb11,g_afb.afb12,g_afb.afb13,
                    g_afb.afb14,g_afc.*
END FUNCTION
 
FUNCTION i502_afb01(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_afa02 LIKE afa_file.afa02,
           l_afaacti LIKE afa_file.afaacti
 
    LET g_errno = ' '
    IF g_afb.afb01 IS NULL THEN
        LET l_afa02=NULL
    ELSE
## No:2577 modify 1998/10/21 -----------------
        SELECT afa02,afaacti
           INTO l_afa02,l_afaacti
#          FROM afa_file WHERE afa00 = g_bookno AND afa01 = g_afb.afb01
           FROM afa_file WHERE afa01 = g_afb.afb01 AND afa00 = g_afb.afb00  #No.FUN-730070
## -------------------------------
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-005'
            LET l_afa02 = NULL
        END IF
        IF l_afaacti='N' THEN
           LET g_errno = '9028'
        END IF
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_afa02 TO  afa02
    END IF
END FUNCTION
 
FUNCTION i502_afb02(p_cmd)
    DEFINE
           p_cmd   LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
           l_aag02 LIKE aag_file.aag02,
           l_aag07 LIKE aag_file.aag07,
           l_aagacti LIKE aag_file.aagacti
    DEFINE l_aag21   LIKE aag_file.aag21   #Add No.FUN-B10048
 
    LET g_errno = ' '
    IF g_afb.afb02 IS NULL THEN
        LET l_aag02=NULL
    ELSE
       SELECT aag02,aag07,aag21,aagacti INTO l_aag02,l_aag07,l_aag21,l_aagacti  #Mod No.FUN-B10048 add aag21
          FROM aag_file WHERE aag01=g_afb.afb02 AND aag00 = g_afb.afb00      #No.FUN-730070
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-001'
            LET l_aag02 = NULL
        END IF
        IF l_aag07 = '1' THEN #為統制科目者不可做預算
           LET g_errno = 'agl-131 '
        END IF
        IF l_aagacti='N' THEN
           LET g_errno = '9028'
        END IF
        #Add No.FUN-B10048
        IF l_aag21 <> 'Y' THEN
           LET g_errno = 'aag-924'
        END IF
        #End Add No.FUN-B10048
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_aag02 TO  aag02
    END IF
END FUNCTION
 
#No.FUN-730070  --Begin
FUNCTION i502_afb00(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,  
         p_afb00   LIKE afb_file.afb00,
         l_aaaacti LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=g_afb.afb00
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-730070  --End  
 
FUNCTION i502_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_afb.* TO NULL              #No.FUN-6B0040
    INITIALIZE g_afc.* TO NULL              #No.FUN-6B0040
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i502_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i502_count
    FETCH i502_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i502_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL
        INITIALIZE g_afc.* TO NULL
    ELSE
        CALL i502_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i502_fetch(p_flafb)
    DEFINE
        p_flafb          LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
#       l_sql            VARCHAR(600),
        l_sql            STRING,        #TQC-630166    
        l_abso           LIKE type_file.num10         #No.FUN-680098 INTEGER
 
    CASE p_flafb
        WHEN 'N' FETCH NEXT     i502_cs INTO g_afb.afb00,g_afb.afb01,  #No.FUN-730070
                                        #g_afb.afb02,g_afb.afb03,g_afb.afb04  #No.TQC-B50111
                                        g_afb.afb02,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042  #No.TQC-B50111
        WHEN 'P' FETCH PREVIOUS i502_cs INTO g_afb.afb00,g_afb.afb01,  #No.FUN-730070
                                        #g_afb.afb02,g_afb.afb03,g_afb.afb04 #No.TQC-B50111
                                        g_afb.afb02,g_afb.afb03,g_afb.afb04,g_afb.afb04,g_afb.afb042  #No.TQC-B50111
        WHEN 'F' FETCH FIRST    i502_cs INTO g_afb.afb00,g_afb.afb01,  #No.FUN-730070
                                         #g_afb.afb02,g_afb.afb03,g_afb.afb04 #No.TQC-B50111
                                         g_afb.afb02,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042 #No.TQC-B50111
        WHEN 'L' FETCH LAST     i502_cs INTO g_afb.afb00,g_afb.afb01,  #No.FUN-730070
                                         #g_afb.afb02,g_afb.afb03,g_afb.afb04 #No.TQC-B50111
                                         g_afb.afb02,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042 #No.TQC-B50111
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i502_cs INTO g_afb.afb00,g_afb.afb01,  #No.FUN-730070
                                           #g_afb.afb02,g_afb.afb03,g_afb.afb04 #No.TQC-B50111
                                           g_afb.afb02,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042 #No.TQC-B50111  
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        INITIALIZE g_afb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flafb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_afb.* FROM afb_file            # 重讀DB,因TEMP有不被更新特性
       WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03 
       #AND afb04 = g_afb.afb04   #No.TQC-B50111
       AND afb041 = g_afb.afb041  #No.TQC-B50111
       AND afb04 = g_afb.afb04  #No.TQC-B50111
       AND afb042 = g_afb.afb042  #No.TQC-B50111
       AND afbacti = 'Y'                         #FUN-D70090 add
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","afb_file",g_afb.afb01,g_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
       #No.FUN-730070  --Begin
       SELECT * INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_afb.afb00
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03
       #No.FUN-730070  --End  
       #讀取期預算                        #99/04/19
       LET l_sql = "SELECT afc06,afc07 FROM afb_file,afc_file",
                   " WHERE afc00 = '",g_afb.afb00,"'",  #No.FUN-730070
                   " AND afc01 ='",g_afb.afb01,"'",
                   " AND afc02 ='",g_afb.afb02,"'",
                   " AND afc03 =",g_afb.afb03,
                   #" AND afc04 ='",g_afb.afb04,"'",  #No.TQC-B50111
                   " AND afc041 ='",g_afb.afb041,"'", #No.TQC-B50111
                   " AND afc05 = ? ",
                   " AND afc00 = afb00 ",
                   " AND afc01 = afb01 ",
                   " AND afc02 = afb02 ",
                   " AND afc03 = afb03 ",
                   " AND afc04 = afb04 ",             #No.TQC-B50111
                   " AND afc042 = afb042 ",           #No.TQC-B50111
                   #" AND afc041 = afb041 "  CLIPPED #No.TQC-B50111
                   " AND afc041 = afb041 "  CLIPPED  #No.TQC-B50111
                  ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
       PREPARE i502_p2 FROM l_sql
       DECLARE i502_c2 CURSOR FOR i502_p2
       FOR g_cnt = 1 TO 13
           LET l_afc06[g_cnt]=NULL LET l_afc07[g_cnt]=NULL
           OPEN i502_c2 USING g_cnt
           FETCH i502_c2 INTO l_afc06[g_cnt],l_afc07[g_cnt]
       END FOR
       #Modify: 99/04/19
       IF l_afc07[1] IS NULL THEN LET l_afc07[1] = 0 END IF
       IF l_afc07[2] IS NULL THEN LET l_afc07[2] = 0 END IF
       IF l_afc07[3] IS NULL THEN LET l_afc07[3] = 0 END IF
       IF l_afc07[4] IS NULL THEN LET l_afc07[4] = 0 END IF
       IF l_afc07[5] IS NULL THEN LET l_afc07[5] = 0 END IF
       IF l_afc07[6] IS NULL THEN LET l_afc07[6] = 0 END IF
       IF l_afc07[7] IS NULL THEN LET l_afc07[7] = 0 END IF
       IF l_afc07[8] IS NULL THEN LET l_afc07[8] = 0 END IF
       IF l_afc07[9] IS NULL THEN LET l_afc07[9] = 0 END IF
       IF l_afc07[10] IS NULL THEN LET l_afc07[10] = 0 END IF
       IF l_afc07[11] IS NULL THEN LET l_afc07[11] = 0 END IF
       IF l_afc07[12] IS NULL THEN LET l_afc07[12] = 0 END IF
       LET g_afc.afc06_1 = l_afc06[1]
       LET g_afc.afc06_2 = l_afc06[2]
       LET g_afc.afc06_3 = l_afc06[3]
       LET g_afc.afc06_4 = l_afc06[4]
       LET g_afc.afc06_5 = l_afc06[5]
       LET g_afc.afc06_6 = l_afc06[6]
       LET g_afc.afc06_7 = l_afc06[7]
       LET g_afc.afc06_8 = l_afc06[8]
       LET g_afc.afc06_9 = l_afc06[9]
       LET g_afc.afc06_10 = l_afc06[10]
       LET g_afc.afc06_11 = l_afc06[11]
       LET g_afc.afc06_12 = l_afc06[12]
       LET g_afc.afc06_13 = l_afc06[13]
       LET g_afc1.afc07_1 = l_afc07[1]
       LET g_afc1.afc07_2 = l_afc07[2]
       LET g_afc1.afc07_3 = l_afc07[3]
       LET g_afc1.afc07_4 = l_afc07[4]
       LET g_afc1.afc07_5 = l_afc07[5]
       LET g_afc1.afc07_6 = l_afc07[6]
       LET g_afc1.afc07_7 = l_afc07[7]
       LET g_afc1.afc07_8 = l_afc07[8]
       LET g_afc1.afc07_9 = l_afc07[9]
       LET g_afc1.afc07_10 = l_afc07[10]
       LET g_afc1.afc07_11 = l_afc07[11]
       LET g_afc1.afc07_12 = l_afc07[12]
       LET g_afc1.afc07_13 = l_afc07[13]
       LET g_data_owner = g_afb.afbuser     #No.FUN-4C0048
       LET g_data_group = g_afb.afbgrup     #No.FUN-4C0048
       CALL i502_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i502_show()
    LET g_afb_t.* = g_afb.*
    LET g_afc_t.* = g_afc.*
    DISPLAY BY NAME g_afb.afboriu,g_afb.afborig,
        g_afb.afb00,   #No.FUN-730070
#        g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb04   , #No.TQC-B50111
        g_afb.afb01   ,g_afb.afb02   ,g_afb.afb03   ,g_afb.afb041   , #No.TQC-B50111
#       g_afb.afb07   ,g_afb.afb08   ,g_afb.afb09   ,
        g_afb.afb07   ,g_afb.afb09   ,
        g_afb.afb05   ,g_afb.afb06   ,g_afb.afb10   ,g_afc.afc06_1 ,
        g_afc.afc06_2 ,g_afc.afc06_3 ,g_afc.afc06_4 ,g_afc.afc06_5 ,
        g_afc.afc06_6 ,g_afc.afc06_7 ,g_afc.afc06_8 ,g_afc.afc06_9 ,
        g_afc.afc06_10,g_afc.afc06_11,g_afc.afc06_12,g_afc.afc06_13,
        g_afc1.afc07_2 ,g_afc1.afc07_3 ,g_afc1.afc07_4 ,g_afc1.afc07_5 ,
        g_afc1.afc07_1,g_afc1.afc07_6 ,g_afc1.afc07_7 ,g_afc1.afc07_8 ,
        g_afc1.afc07_9 ,g_afc1.afc07_10,g_afc1.afc07_11,g_afc1.afc07_12,
        g_afc1.afc07_13,
        g_afb.afb11   ,g_afb.afb12   ,g_afb.afb13   ,g_afb.afb14,
        g_afb.afbuser ,g_afb.afbgrup ,g_afb.afbmodu ,g_afb.afbdate,
        g_afb.afbacti
    #CKP
    CALL cl_set_field_pic("","","","","",g_afb.afbacti)
 
    CALL i502_afb00('d')  #No.FUN-730070
    CALL i502_afb01('d')
    CALL i502_afb02('d')
    CALL i502_afb04('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i502_u()
    IF s_aglshut(0) THEN RETURN END IF
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN  #No.FUN-730070
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_afb.* FROM afb_file WHERE afb00=g_afb.afb00  #No.FUN-730070
       AND afb01=g_afb.afb01 AND afb02=g_afb.afb02
       #AND afb03=g_afb.afb03 AND afb04=g_afb.afb04  #No.TQC-B50111
       AND afb03=g_afb.afb03 AND afb041=g_afb.afb041 #No.TQC-B50111
       AND afb04=g_afb.afb04 AND afb042=g_afb.afb042 #No.TQC-B50111
    IF g_afb.afbacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_afb.afb01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_afb01_t = g_afb.afb01
    #No.FUN-730070  --Begin
    LET g_afb00_t = g_afb.afb00
    LET g_afb02_t = g_afb.afb02
    LET g_afb03_t = g_afb.afb03
    #LET g_afb04_t = g_afb.afb04  #No.TQC-B50111
    LET g_afb041_t = g_afb.afb041 #No.TQC-B50111
    #No.FUN-730070  --End  
    LET g_afb04_t = g_afb.afb04 #No.TQC-B50111
    LET g_afb042_t = g_afb.afb042 #No.TQC-B50111
    LET g_afb_o.*=g_afb.*
    LET g_afc_o.*=g_afc.*
    BEGIN WORK
 
    #OPEN i502_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04 #No.TQC-B50111
    OPEN i502_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042 #No.TQC-B50111
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i502_cl:", STATUS, 1)
       CLOSE i502_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i502_cl INTO g_afb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_afb.afbmodu=g_user                     #修改者
    LET g_afb.afbdate = g_today                  #修改日期
    CALL i502_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i502_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_afb.*=g_afb_t.*
            LET g_afc.*=g_afc_t.*
            CALL i502_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE afb_file SET afb_file.* = g_afb.*    # 更新DB
            WHERE afb00 = g_afb00_t AND afb01 = g_afb01_t AND afb02 = g_afb02_t AND afb03 = g_afb03_t 
            #AND afb04 = g_afb04_t             # COLAUTH? #No.TQC-B50111
            AND afb041 = g_afb041_t                       #No.TQC-B50111
            AND afb04 = g_afb04_t             # COLAUTH? #No.TQC-B50111
            AND afb042 = g_afb042_t             # COLAUTH? #No.TQC-B50111
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","afb_file",g_afb01_t,g_afb02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CONTINUE WHILE
        END IF
        CALL i502_addafc('u')    #更新期預算
        EXIT WHILE
    END WHILE
    CLOSE i502_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i502_x()
    DEFINE
        l_chr    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN  #No.FUN-730070
        CALL cl_err('',-400,0)
        RETURN
    END IF
	BEGIN WORK
 
    #OPEN i502_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04 #No.TQC-B50111
    OPEN i502_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042 #No.TQC-B50111
 
    IF STATUS THEN
       CALL cl_err("OPEN i502_cl:", STATUS, 1)
       CLOSE i502_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i502_cl INTO g_afb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i502_show()
    IF cl_exp(16,21,g_afb.afbacti) THEN
        LET g_chr=g_afb.afbacti
        IF g_afb.afbacti='Y' THEN
            LET g_afb.afbacti='N'
        ELSE
            LET g_afb.afbacti='Y'
        END IF
        UPDATE afb_file
            SET afbacti=g_afb.afbacti,
               afbmodu=g_user, afbdate=g_today
            WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03 
            #AND afb04 = g_afb.afb04  #No.TQC-B50111
            AND afb041 = g_afb.afb041 #No.TQC-B50111
            AND afb04 = g_afb.afb04  #No.TQC-B50111
            AND afb042 = g_afb.afb042  #No.TQC-B50111
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("upd","afb_file",g_afb.afb01,g_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            LET g_afb.afbacti=g_chr
        END IF
        DISPLAY BY NAME g_afb.afbacti
    END IF
    CLOSE i502_cl
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic("","","","","",g_afb.afbacti)
 
END FUNCTION
 
FUNCTION i502_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN  #No.FUN-730070
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    #OPEN i502_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb04 #No.TQC-B50111
    OPEN i502_cl USING g_afb.afb00,g_afb.afb01,g_afb.afb02,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042 #No.TQC-B50111
 
    IF STATUS THEN
       CALL cl_err("OPEN i502_cl:", STATUS, 1)
       CLOSE i502_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i502_cl INTO g_afb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i502_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "afb00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_afb.afb00      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "afb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_afb.afb01      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "afb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_afb.afb02      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "afb03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_afb.afb03      #No.FUN-9B0098 10/02/24
        #LET g_doc.column5 = "afb04"         #No.FUN-9B0098 10/02/24
        #LET g_doc.value5 = g_afb.afb04      #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "afb041"         #No.TQC-B50111
        LET g_doc.value5 = g_afb.afb041      #No.TQC-B50111
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
            DELETE FROM afb_file
                 WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01  #No.FUN-730070
                   AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                   #AND afb04 = g_afb.afb04  #No.TQC-B50111
                   AND afb04 = g_afb.afb04   #No.TQC-B50111
            IF SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err(g_afb.afb01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","afb_file",g_afb.afb01,g_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            END IF
            DELETE FROM afc_file
                 WHERE afc00 = g_afb.afb00 AND afc01 = g_afb.afb01  #No.FUN-730070
                   AND afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
                   #AND afc04 = g_afb.afb04  #No.TQC-B50111
                   AND afc041 = g_afb.afb041 #No.TQC-B50111
                   AND afc04 = g_afb.afb04  #No.TQC-B50111
                   AND afc042 = g_afb.afb042  #No.TQC-B50111
            CLEAR FORM
            OPEN i502_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i502_cs
               CLOSE i502_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i502_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i502_cs
               CLOSE i502_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i502_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i502_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i502_fetch('/')
            END IF
    END IF
    CLOSE i502_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i502_copy()
#No.FUN-730070  --Begin
   DEFINE l_afb           RECORD LIKE afb_file.*,
          o_afb           RECORD LIKE afb_file.*,
          t_afb           RECORD LIKE afb_file.*
#No.FUN-730070  --End  
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN  #No.FUN-730070
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i502_set_entry('a')
    CALL i502_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    LET o_afb.* = g_afb.*  #No.FUN-730070
    #INPUT t_afb.afb00,t_afb.afb01,t_afb.afb02,t_afb.afb03,t_afb.afb04  #No.FUN-730070 #No.TQC-B50111
    INPUT t_afb.afb00,t_afb.afb01,t_afb.afb02,t_afb.afb03,t_afb.afb041  #No.TQC-B50111
     #FROM afb00,afb01,afb02,afb03,afb04  #No.FUN-730070 #No.TQC-B50111
     FROM afb00,afb01,afb02,afb03,afb041  #No.TQC-B50111
        #No.FUN-730070  --Begin
        AFTER FIELD afb00
            IF t_afb.afb00 IS NOT NULL THEN
               LET g_afb.afb00 = t_afb.afb00
               CALL i502_afb00('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(t_afb.afb00,g_errno,0)
                  NEXT FIELD afb00
               END IF
            END IF
        #No.FUN-730070  --End  
        AFTER FIELD afb01
            IF cl_null(t_afb.afb00) THEN NEXT FIELD afb00 END IF  #No.FUN-730070
            IF t_afb.afb01 IS NOT NULL THEN
               LET g_afb.afb01 = t_afb.afb01
               CALL i502_afb01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(t_afb.afb01,g_errno,0)
                  NEXT FIELD afb01
               END IF
            END IF
        AFTER FIELD afb02
            IF t_afb.afb02 IS NOT NULL THEN
               LET g_afb.afb02 = t_afb.afb02
               CALL i502_afb02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(t_afb.afb02,g_errno,0)
                  #Add No.FUN-B10048
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = t_afb.afb02
                  LET g_qryparam.where = " aag03 matches '[24]' AND aag21 = 'Y' AND aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_afb.afb02 CLIPPED,"%'"
                  LET g_qryparam.arg1 = t_afb.afb00      #No.FUN-730070
                  CALL cl_create_qry() RETURNING t_afb.afb02
                  DISPLAY BY NAME t_afb.afb02
                  #End Add No.FUN-B10048
                  NEXT FIELD afb02
               END IF
            END IF
        #No.TQC-B50111 --Begin
        #AFTER FIELD afb04
        #    IF t_afb.afb04 IS NOT NULL THEN
        #       LET g_afb.afb04 = t_afb.afb04
        #       CALL i502_afb04('a')
        #       IF NOT cl_null(g_errno) THEN
        #          CALL cl_err(t_afb.afb04,g_errno,0)
        #          NEXT FIELD afb04
        #       END IF
        #    END IF
        AFTER FIELD afb041
            IF t_afb.afb041 IS NOT NULL THEN
               LET g_afb.afb041 = t_afb.afb041
               CALL i502_afb04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(t_afb.afb041,g_errno,0)
                  NEXT FIELD afb041
               END IF
            END IF
         #No.TQC-B50111 --End
         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            #No.FUN-730070  --Begin
            IF INFIELD(afb00) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = t_afb.afb00
               CALL cl_create_qry() RETURNING t_afb.afb00
               DISPLAY BY NAME t_afb.afb00
               CALL i502_afb00('d')
            END IF
            #No.FUN-730070  --End  
            IF INFIELD(afb01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_afa"                         
               #LET g_qryparam.form ="q_azf"  #No.TQC-B50105                         
               LET g_qryparam.default1 = t_afb.afb01
#              LET g_qryparam.where = " afa00 = '",t_afb.afb00,"'"  #No.FUN-730070
               LET g_qryparam.arg1 = t_afb.afb00            
                       #No.FUN-730070 
               CALL cl_create_qry() RETURNING t_afb.afb01
               DISPLAY BY NAME t_afb.afb01
               CALL i502_afb01('d')
            END IF
            IF INFIELD(afb02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.default1 = t_afb.afb02
                LET g_qryparam.where = " aag03 matches '[24]' AND aag21 = 'Y'"  #No.MOD-530386
               LET g_qryparam.arg1 = t_afb.afb00      #No.FUN-730070
               CALL cl_create_qry() RETURNING t_afb.afb02
               DISPLAY BY NAME t_afb.afb02
               CALL i502_afb02('d')
            END IF
            #No.TQC-B50111 --Begin
            #IF INFIELD(afb04) THEN
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_gem"
            #   LET g_qryparam.default1 = t_afb.afb04
            #   CALL cl_create_qry() RETURNING t_afb.afb04
            #   DISPLAY BY NAME t_afb.afb04
            #END IF
            IF INFIELD(afb041) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = t_afb.afb041
               CALL cl_create_qry() RETURNING t_afb.afb041
               DISPLAY BY NAME t_afb.afb041
            END IF
            #No.TQC-B50111 --End
         ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        AFTER INPUT
            SELECT count(*) INTO g_cnt FROM afb_file
                WHERE afb02 = t_afb.afb02
                  AND afb03 = t_afb.afb03
                  #AND afb04 = t_afb.afb04  #No.TQC-B50111
                  AND afb041 = t_afb.afb041 #No.TQC-B50111
                  AND afb01 = t_afb.afb01
                  AND afb00 = t_afb.afb00  #No.FUN-730070
                  AND afb04 =  ' ' #No.TQC-B50111
                  AND afb042 = ' ' #No.TQC-B50111
                  AND afbacti = 'Y'                         #FUN-D70090 add
            IF g_cnt > 0 THEN
                CALL cl_err(t_afb.afb01,-239,0)  #No.FUN-730070
                NEXT FIELD afb01
            END IF
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_afb.* = o_afb.*  #No.FUN-730070
        #DISPLAY BY NAME g_afb.afb01,g_afb.afb02,g_afb.afb00,g_afb.afb03,g_afb.afb04  #No.FUN-730070 #No.TQC-B50111
        DISPLAY BY NAME g_afb.afb01,g_afb.afb02,g_afb.afb00,g_afb.afb03,g_afb.afb041,g_afb.afb04,g_afb.afb042  #No.TQC-B50111
        RETURN
    END IF
    LET g_afb.* = o_afb.*   #No.FUN-730070
    LET l_afb.* = g_afb.*
    LET l_afb.afb00  =t_afb.afb00   #No.FUN-730070
    LET l_afb.afb01  =t_afb.afb01   #資料鍵值
    LET l_afb.afb02  =t_afb.afb02   #資料鍵值
    LET l_afb.afb03  =t_afb.afb03   #資料鍵值
    LET l_afb.afb04  =' '   #資料鍵值  #No.TQC-B50111
    LET l_afb.afb041  =t_afb.afb041   #資料鍵值 #No.TQC-B50111
    LET l_afb.afb042  =' '   #資料鍵值 #No.TQC-B50111
    LET l_afb.afbuser=g_user    #資料所有者
    LET l_afb.afbgrup=g_grup    #資料所有者所屬群
    LET l_afb.afbmodu=NULL      #資料修改日期
    LET l_afb.afbdate=g_today   #資料建立日期
    LET l_afb.afbacti='Y'       #有效資料
    LET g_success = 'Y'
    BEGIN WORK
    LET l_afb.afboriu = g_user      #No.FUN-980030 10/01/04
    LET l_afb.afborig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO afb_file VALUES (l_afb.*)
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
#      CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("ins","afb_file",l_afb.afb01,l_afb.afb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       ROLLBACK WORK
    ELSE
        COMMIT WORK
        MESSAGE 'ROW(',t_afb.afb01,') O.K'  #No.FUN-730070
        #No.FUN-730070  --Begin
        SELECT afb_file.* INTO g_afb.* FROM afb_file
                WHERE afb02 = t_afb.afb02
                  AND afb03 = t_afb.afb03
                  #AND afb04 = t_afb.afb04 #No.TQC-B50111
                  AND afb041 = t_afb.afb041 #No.TQC-B50111
                  AND afb01 = t_afb.afb01
                  AND afb00 = t_afb.afb00  #No.FUN-730070
                  AND afb04 =  ' ' #No.TQC-B50111
                  AND afb042 = ' ' #No.TQC-B50111
                  AND afbacti = 'Y'                         #FUN-D70090 add
        #No.FUN-730070  --End  
        LET g_copy_flag = 'Y'
        CALL i502_u()
        LET g_copy_flag = 'N'
    END IF
        #FUN-C30027---begin
        #LET g_afb.* = o_afb.*  #No.FUN-730070
        #SELECT afb_file.* INTO g_afb.* FROM afb_file
        #        WHERE afb02 = g_afb.afb02
        #          AND afb03 = g_afb.afb03
        #          #AND afb04 = g_afb.afb04   #No.TQC-B50111
        #          AND afb041 = g_afb.afb041  #No.TQC-B50111
        #          AND afb01 = g_afb.afb01
        #          AND afb00 = g_afb.afb00  #No.FUN-730070
        #          AND afb04 =  ' ' #No.TQC-B50111
        #          AND afb042 = ' ' #No.TQC-B50111
        #FUN-C30027---end
        CALL i502_show()
END FUNCTION
 
FUNCTION i502_out()
    DEFINE
        l_i             LIKE type_file.num5,           #No.FUN-680098  SMALLINT
        l_name          LIKE type_file.chr20,          # External(Disk) file name    #No.FUN-680098  VARCHAR(20)
        l_afb   RECORD  LIKE afb_file.*,
        l_za05          LIKE za_file.za05,             #No.FUN-680098 VARCHAR(40)
        l_chr           LIKE type_file.chr1            #No.FUN-680098  VARCHAR(1)
#No.FUN-760085---Begin
DEFINE  l_afa02   LIKE afa_file.afa02,                                                                                              
        l_aag02   LIKE aag_file.aag02,                                                                                              
        l_afc06   ARRAY[13] OF LIKE afc_file.afc06
#No.FUN-760085---End
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    #CALL cl_outnam('agli502') RETURNING l_name         #No.FUN-760085
	#金額小數位數
    #No.FUN-730070  --Begin
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
#   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03     #CHI-6A0004
#   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_bookno
#		AND aaf02 = g_lang
    #No.FUN-730070  --End  
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'agli502'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 88 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #No.FUN-730070  --Begin
    LET g_sql="SELECT * FROM afb_file ",          # 組合出 SQL 指令
              " WHERE afb15='2' AND ",g_wc CLIPPED
    #No.FUN-730070  --End  
    PREPARE i502_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i502_co CURSOR FOR i502_p1
    #讀取期預算
    LET g_sql = "SELECT afc06 FROM afc_file",
                " WHERE afc00 = ? ",  #No.FUN-730070
                " AND afc01 = ? ",
                " AND afc02 = ? ",
                " AND afc03 = ? ",
                " AND afc05 = ? ",
                " AND afc041 = ? ",    #No.TQC-B10105
                " AND afc04 = ? ",
                " AND afc042 = ? "    #No.TQC-B10105
               ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
    PREPARE i502_p4 FROM g_sql
    IF SQLCA.sqlcode
    THEN CALL cl_err('p4:',SQLCA.sqlcode,1)
    END IF
    DECLARE i502_c4 CURSOR FOR i502_p4
 
    #No.FUN-760085---Begin
    #START REPORT i502_rep TO l_name
    CALL cl_del_data(l_table)                                                                                                       
    #No.FUN-760085---End   
    FOREACH i502_co INTO l_afb.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        #No.FUN-760085---Begin
        #OUTPUT TO REPORT i502_rep(l_afb.*)
        SELECT afa02 INTO l_afa02 FROM afa_file                             
                   WHERE afa01 = l_afb.afb01 AND afa00 = l_afb.afb00 
        IF SQLCA.sqlcode THEN LET l_afa02 = ' ' END IF
        SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = l_afb.afb00      
            SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file 
             WHERE azi01 = g_aaa03
        SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = l_afb.afb02 
            AND aag00 = l_afb.afb00
            IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF      
        IF g_aza.aza02 = '1' THEN                                               
           LET g_i = 12                                                         
        ELSE                                                                    
           LET g_i = 13                                                         
        END IF                                                                  
        FOR g_cnt = 1 TO g_i                                                    
            OPEN i502_c4 USING l_afb.afb00,l_afb.afb01,l_afb.afb02,l_afb.afb03,
                               #l_afb.afb04,g_cnt #No.TQC-B50111
                               l_afb.afb05, #No.TQC-B50111
                               l_afb.afb041, #No.TQC-B50111
                               l_afb.afb04, #No.TQC-B50111
                               l_afb.afb042,g_cnt #No.TQC-B50111
            FETCH i502_c4 INTO l_afc06[g_cnt]                                   
            IF SQLCA.sqlcode THEN LET l_afc06[g_cnt]=0 END IF                   
        END FOR                                   
        EXECUTE insert_prep USING l_afb.afb00,l_afb.afb01,l_afa02,l_afb.afbacti,
                                  l_afb.afb02,l_aag02,l_afb.afb03,l_afb.afb05,
                                  #l_afb.afb04,l_afc06[1],l_afc06[2],l_afc06[3], #No.TQC-B50111
                                  l_afb.afb041,l_afb.afb04,l_afb.afb042,l_afc06[1],l_afc06[2],l_afc06[3], #No.TQC-B50111
                                  l_afc06[4],l_afc06[5],l_afc06[6],l_afc06[7],
                                  l_afc06[8],l_afc06[9],l_afc06[10],l_afc06[11],
                                  l_afc06[12],l_afc06[13],l_afb.afb11,
                                  l_afb.afb12,l_afb.afb13,l_afb.afb14,
                                  l_afb.afb10,t_azi04,t_azi05
        #No.FUN-760085---End 
        
    END FOREACH
 
    #FINISH REPORT i502_rep       #No.FUN-760085
 
    CLOSE i502_co
    ERROR ""
    #No.FUN-760085---Begin
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                                                                            
       #CALL cl_wcchp(g_wc,'afb00,afb01,afb02,afb03,afb04,afb07,afb09,afb05,afb06,afb10 ')  #No.TQC-B50111     
       CALL cl_wcchp(g_wc,'afb00,afb01,afb02,afb03,afb041,afb07,afb09,afb05,afb06,afb10 ')  #No.TQC-B50111                                                                  
            RETURNING g_wc                                                                                                          
       LET g_str = g_wc                                                                                                             
    END IF                                                                                                                          
    LET g_str = g_wc                                                                                                               
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                              
    CALL cl_prt_cs3('agli502','agli502',l_sql,g_str)                                                                                
    #No.FUN-760085---End
END FUNCTION                                                                                                                        
                                                                                                                                    
#No.FUN-760085---Begin  
{
REPORT i502_rep(sr)
    DEFINE
        l_trailer_sw LIKE type_file.chr1   ,         #No.FUN-680098   VARCHAR(1)
        l_sw         LIKE type_file.chr1   ,         #No.FUN-680098   VARCHAR(1)
        sr RECORD LIKE afb_file.*,
        l_afa02   LIKE afa_file.afa02,
        l_aag02   LIKE aag_file.aag02,
        l_afc06   ARRAY[13] OF LIKE afc_file.afc06,
#       l_sql           VARCHAR(200), 
        l_sql           STRING,        #TQC-630166     
        l_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04  #No.FUN-730070
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
## No:2577 modify 1998/10/21 -----------------
            SELECT afa02 INTO l_afa02 FROM afa_file
#                  WHERE afa00 = g_bookno AND afa01 = sr.afb01
                   WHERE afa01 = sr.afb01 AND afa00 = sr.afb00  #No.FUN-730070
## ---
            IF SQLCA.sqlcode THEN LET l_afa02 = ' ' END IF
            PRINT g_x[20] CLIPPED,' ',sr.afb00,'    ';  #No.FUN-730070
            PRINT g_x[18] CLIPPED,' ',sr.afb01,'    ',
                  g_x[19] CLIPPED,' ',l_afa02 CLIPPED
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        #No.FUN-730070  --Begin
        BEFORE GROUP OF sr.afb00
            SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = sr.afb00
            SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03       #CHI-6A0004
            IF PAGENO > 1 OR LINENO > 9 THEN
               SKIP TO TOP OF PAGE
            END IF
        #No.FUN-730070  --End  
 
        BEFORE GROUP OF sr.afb01
            IF PAGENO > 1 OR LINENO > 9 THEN
               SKIP TO TOP OF PAGE
            END IF
 
        BEFORE GROUP OF sr.afb04
            IF sr.afbacti = 'N' THEN PRINT '*'; END IF
#            PRINT g_x[11],g_x[12] CLIPPED   #TQC-5B0045
            PRINT g_x[11],COLUMN 80,g_x[12] CLIPPED   #TQC-5B0045
            PRINT '  ------------------------  ------------',
#FUN-590124
                  '-------------------------------------- ----  --  ---------------'
#                 '------------------ ----  --   --'
            SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.afb02 AND aag00 = sr.afb00 #No.FUN-730070
            IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF
            PRINT COLUMN 3,sr.afb02,COLUMN 29,l_aag02,
                  COLUMN 80,sr.afb03 USING'####','  ';
#                 COLUMN 60,sr.afb03 USING'####','  ';
            CASE sr.afb05
                 WHEN '1' PRINT g_x[13] CLIPPED,COLUMN 90,sr.afb04 CLIPPED
                 WHEN '2' PRINT g_x[14] CLIPPED,COLUMN 90,sr.afb04 CLIPPED
                 WHEN '3' PRINT g_x[15] CLIPPED,COLUMN 90,sr.afb04 CLIPPED
                 OTHERWISE PRINT '  ',COLUMN 90,sr.afb04 CLIPPED
#                WHEN '1' PRINT g_x[13] CLIPPED,COLUMN 70,sr.afb04 CLIPPED
#                WHEN '2' PRINT g_x[14] CLIPPED,COLUMN 70,sr.afb04 CLIPPED
#                WHEN '3' PRINT g_x[15] CLIPPED,COLUMN 70,sr.afb04 CLIPPED
#                OTHERWISE PRINT '  ',COLUMN 70,sr.afb04 CLIPPED
            END CASE
#FUN-590124
            SKIP 1  LINE
 
        IF g_aza.aza02 = '1' THEN
           LET g_i = 12
        ELSE
           LET g_i = 13
        END IF
        FOR g_cnt = 1 TO g_i
            OPEN i502_c4 USING sr.afb00,sr.afb01,sr.afb02,sr.afb03,sr.afb04,g_cnt  #No.FUN-730070
            FETCH i502_c4 INTO l_afc06[g_cnt]
            IF SQLCA.sqlcode THEN LET l_afc06[g_cnt]=0 END IF
        END FOR
        PRINT g_x[16],'     ',g_x[16]CLIPPED
        PRINT ' -- ------------------ -- ------------------',
              ' -- ------------------ -- ------------------'
#CHI-6A0004---begin
        PRINT '  1',COLUMN 4,cl_numfor(l_afc06[1],18,t_azi04) CLIPPED,
              '  4',COLUMN 26,cl_numfor(l_afc06[4],18,t_azi04) CLIPPED,
              '  7',COLUMN 48,cl_numfor(l_afc06[7],18,t_azi04) CLIPPED,
              ' 10',COLUMN 70,cl_numfor(l_afc06[10],18,t_azi04) CLIPPED
        PRINT '  2',COLUMN 4,cl_numfor(l_afc06[2],18,t_azi04) CLIPPED,
              '  5',COLUMN 26,cl_numfor(l_afc06[5],18,t_azi04) CLIPPED,
              '  8',COLUMN 48,cl_numfor(l_afc06[8],18,t_azi04) CLIPPED,
              ' 11',COLUMN 70,cl_numfor(l_afc06[11],18,t_azi04) CLIPPED
        PRINT '  3',COLUMN 4,cl_numfor(l_afc06[3],18,t_azi04) CLIPPED,
              '  6',COLUMN 26,cl_numfor(l_afc06[6],18,t_azi04) CLIPPED,
              '  9',COLUMN 48,cl_numfor(l_afc06[9],18,t_azi04) CLIPPED,
              ' 12',COLUMN 70,cl_numfor(l_afc06[12],18,t_azi04) CLIPPED
        IF  l_afc06[13] IS NOT NULL
            THEN PRINT COLUMN 68,'13',cl_numfor(l_afc06[13],18,t_azi04) CLIPPED
        END IF
        SKIP 1  LINE
        PRINT ' ',g_x[14] CLIPPED,
                  COLUMN 4,cl_numfor(sr.afb11,18,t_azi05) CLIPPED,
                           ' ',g_x[14] CLIPPED,
                  COLUMN 26,cl_numfor(sr.afb12,18,t_azi05) CLIPPED,
              ' ',g_x[14] CLIPPED,
                  COLUMN 48,cl_numfor(sr.afb13,18,t_azi05) CLIPPED,
                            ' ',g_x[14] CLIPPED,
                  COLUMN 70,cl_numfor(sr.afb14,18,t_azi05) CLIPPED
        SKIP 1  LINE
        PRINT  COLUMN 49,g_x[17] CLIPPED,
              COLUMN 70,cl_numfor(sr.afb10,18,t_azi05) CLIPPED
        SKIP 1  LINE
#CHI-6A0004---end
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
                    #TQC-630166
                    #IF g_wc[001,080] > ' ' THEN
		    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                    #IF g_wc[071,140] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                    #IF g_wc[141,210] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)
            END IF
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-760085---End
 
FUNCTION i502_m()
DEFINE  l_percent  LIKE type_file.num15_3,      #LIKE cpf_file.cpf112,        #No.FUN-680098  DEC(6,2)   #TQC-B90211
        l_percent1 LIKE type_file.num5,         #No.FUN-680098  SMALLINT
#       l_sql      VARCHAR(200)     
        l_sql      STRING        #TQC-630166    
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_afb.afb01 IS NULL OR g_afb.afb00 IS NULL THEN  #No.FUN-730070
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_afb.afbacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_afb.afb01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
 
 
    OPEN WINDOW i502_w2 AT 10,09
         WITH FORM "agl/42f/agli6021"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("agli6021")
 
 
    INPUT l_percent1 FROM percent1
 
    AFTER FIELD percent1
          IF l_percent1 IS NULL OR l_percent1 = ' ' THEN
             LET l_percent1 = 0
             DISPLAY l_percent1 TO FORMONLY.percent1
             NEXT FIELD percent1
          ELSE
              IF l_percent1 > 100 OR l_percent1 < -100
                 OR l_percent1 = 0  THEN   #不要超過百分之百
                 NEXT FIELD percent1
              END IF
          END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    CLOSE WINDOW i502_w2
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
#將此行移到RETURN之前 Modify By Danny 95/09/23
#   OPTIONS FORM LINE FIRST + 2
    LET l_percent = l_percent1/100+1
    LET l_sql = " UPDATE afc_file SET afc06 = afc06 * ",l_percent," ",
                " WHERE afc00 = '",g_afb.afb00,"'  AND afc01 = '",g_afb.afb01,"'",  #No.FUN-730070
                " AND afc02 = '",g_afb.afb02,"' AND afc03 = ",g_afb.afb03," ",
                " AND afc04 = '",g_afb.afb04,"' AND afc05 = ? "
    PREPARE i502_pre FROM l_sql
    IF SQLCA.sqlcode
    THEN CALL cl_err('p4:',SQLCA.sqlcode,1)
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
    END IF
    IF g_aza.aza02 = '1' THEN
       LET g_i = 12
    ELSE
       LET g_i = 13
    END IF
    LET g_success = 'Y'
    BEGIN WORK
    FOR g_cnt = 1 TO g_i
        EXECUTE i502_pre USING g_cnt
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL cl_err('3:',SQLCA.sqlcode,1)
           EXIT FOR
        END IF
    END FOR
    LET g_i=g_i
{ckp#1}UPDATE afb_file SET afb10 = afb10 * l_percent,
                        afb11 = afb11 * l_percent,
                        afb12 = afb12 * l_percent,
                        afb13 = afb13 * l_percent,
                        afb14 = afb14 * l_percent
           WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01 AND  #No.FUN-730070
                 afb02 = g_afb.afb02 AND afb03 = g_afb.afb03 AND
                 afb04 = g_afb.afb04 
                
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
#      CALL cl_err('ckp#1',SQLCA.sqlcode,1) #NO.FUN-660123
       CALL cl_err3("upd","afb_file",g_afb.afb00,g_afb.afb01,SQLCA.sqlcode,"","ckp#1",1) #NO.FUN-660123  #No.FUN-730070
   END IF
    SELECT afb_file.* INTO g_afb.* FROM afb_file
                   WHERE afb00 = g_afb.afb00 AND afb01 = g_afb.afb01  #No.FUN-730070
                         AND afb02 = g_afb.afb02 AND afb03 = g_afb.afb03
                         AND afb04 = g_afb.afb04
                         AND afbacti = 'Y'                         #FUN-D70090 add
   FOR g_cnt = 1 TO 13
   #------------No.TQC-630059 modify
     #OPEN i502_c2 USING g_cnt
     #FETCH i502_c2 INTO l_afc06[g_cnt],l_afc07[g_cnt]
     #IF SQLCA.sqlcode != 100 AND SQLCA.sqlcode != 0 THEN
      #   CALL cl_err('fetch:',SQLCA.sqlcode,0)   
     #END IF
     SELECT afc06 INTO l_afc06[g_cnt] FROM afc_file 
      WHERE afc00 = g_afb.afb00  #No.FUN-730070
        AND afc01 = g_afb.afb01
        AND afc02 = g_afb.afb02 AND afc03 = g_afb.afb03
        AND afc04 = g_afb.afb04 AND afc05 =g_cnt
   #------------No.TQC-630059 end
 
   END FOR
   LET g_afc.afc06_1 = l_afc06[1]    LET g_afc.afc06_2 = l_afc06[2]
   LET g_afc.afc06_3 = l_afc06[3]    LET g_afc.afc06_4 = l_afc06[4]
   LET g_afc.afc06_5 = l_afc06[5]    LET g_afc.afc06_6 = l_afc06[6]
   LET g_afc.afc06_7 = l_afc06[7]    LET g_afc.afc06_8 = l_afc06[8]
   LET g_afc.afc06_9 = l_afc06[9]    LET g_afc.afc06_10 = l_afc06[10]
   LET g_afc.afc06_11 = l_afc06[11]  LET g_afc.afc06_12 = l_afc06[12]
   LET g_afc.afc06_13 = l_afc06[13]
   CALL i502_show()
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1) COMMIT WORK
   ELSE
      CALL cl_rbmsg(1) ROLLBACK WORK
   END IF
END FUNCTION
 
#------------------------------ 96/02/06 Add By Melody [G.gen_acct_budget] -----#
FUNCTION i502_g()
#   DEFINE l_sql1  VARCHAR(200),
#          l_sql2  VARCHAR(200),
    DEFINE l_sql1  STRING,        #TQC-630166
           l_sql2  STRING,        #TQC-630166 
           l_name,l_name2  LIKE type_file.chr20,         #No.FUN-680098 VARCHAR(20)
#       l_time           LIKE type_file.chr8      #No.FUN-6A0073
#           l_cmd   VARCHAR(30)     #MOD-5A0259   
           l_cmd   LIKE type_file.chr1000   #MOD-5A0259        #No.FUN-680098  VARCHAR(35)
    DEFINE l_exist LIKE type_file.chr1      #No.FUN-680098  VARCHAR(1)
    DEFINE sr1 RECORD LIKE afb_file.* 
    DEFINE tp RECORD LIKE afb_file.*
    DEFINE sr2 RECORD LIKE afc_file.*
    DEFINE a      LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)
    DEFINE l_afc   RECORD LIKE afc_file.*
    DEFINE l_afb   RECORD LIKE afb_file.*,
           l_tmp   RECORD
                    p001    LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1) 
                    p002    LIKE afb_file.afb02       #No.FUN-680098  VARCHAR(24)
                   END RECORD,
           l_cnt   LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
 
 
    IF s_aglshut(0) THEN RETURN END IF
    MESSAGE ""
 
 
    OPEN WINDOW i502_wg AT 8,25
         WITH FORM "agl/42f/agli6022"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("agli6022")
 
 
    INPUT bookno,budget,yyy FROM bookno,budget,yyy
 
         ON ACTION controlp
            #No.FUN-7300070  --Begin
            IF INFIELD(bookno) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = bookno
               CALL cl_create_qry() RETURNING bookno
               DISPLAY BY NAME bookno
            END IF
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        
        ON ACTION controlg      
           CALL cl_cmdask()     
        #-----END TQC-860018-----
    END INPUT
 
    IF INT_FLAG THEN LET INT_FLAG = 0
       CLOSE WINDOW i502_wg
       CALL cl_err('','9001',1)
       RETURN
    END IF
    CALL cl_wait()
   #------------------------------------------------------99/04/16-------
     CREATE TEMP TABLE tmp_file(
          p01 LIKE type_file.chr1,  
          p02 LIKE type_file.chr50);
     create unique index tmp_01 on tmp_file (p02)
 
     DECLARE judge_cur CURSOR FOR
        SELECT * FROM afb_file
         WHERE afb00=bookno AND afb01 =budget  #No.FUN-730070
           AND afb03 =yyy     AND afb04 !='@'
           AND afbacti = 'Y'   #TQC-630238
     IF SQLCA.SQLCODE THEN 
        CALL cl_err('judge',status,1)  
     END IF
     FOREACH judge_cur INTO tp.*
       if sqlca.sqlcode then call cl_err('temp_foreach',status,1) end if
        select count(*) into l_cnt from afb_file where afb00 = bookno  #No.FUN-730070
        and afb01 = budget and afb02 =tp.afb02 and afb03 = yyy and afb04 ='@'
        and afbacti = 'Y'   #TQC-630238
        if l_cnt = 0 or cl_null(l_cnt) then let l_exist ='N' else
           let l_exist ='Y' end if
        insert into tmp_file values(l_exist,tp.afb02)
      END FOREACH
      DECLARE tmp_cur CURSOR WITH HOLD FOR
         SELECT * FROM tmp_file
 
#No.MOD-920029 --begin
      CALL cl_outnam('agli502') RETURNING l_name         #No.MOD-920029
      CALL cl_outnam('agli502') RETURNING l_name2        #No.MOD-920029
#     LET l_name = 'agli5021.out'
#     LET l_name2 = 'agli5022.out'
      #-----MOD-6C0097---------
#     LET l_cmd = "chmod 777 ", l_name," ",l_name2
#     RUN l_cmd
#     IF STATUS THEN
#        CALL cl_err('chmod 777',STATUS,1)
#     END IF
#No.MOD-920029 --end
      #-----END MOD-6C0097-----
      START REPORT i502_rep1 TO l_name
      IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',STATUS,1) END IF
      START REPORT i502_rep2 TO l_name2
      IF SQLCA.SQLCODE THEN CALL cl_err('tmp_cur',status,1) END IF
 
       LET g_success = 'Y'           #No.MOD-480215
       BEGIN WORK                    #No.MOD-480215
      FOREACH tmp_cur INTO l_tmp.*
         IF SQLCA.SQLCODE THEN
             LET g_success = 'N'     #No.MOD-480215
            CALL cl_err('tmp_cur',status,1) EXIT FOREACH
         END IF
 
         #----------afb_file部份----------
          DECLARE i502_cur1 CURSOR FOR
            SELECT *  FROM afb_file
            WHERE afb00 = bookno   #帳別  #No.FUN-730070
              AND afb01 = budget   #預算
              AND afb03 = yyy      #年度
              AND afb02 = l_tmp.p002
              AND afb04 !='@'
              AND afbacti = 'Y'                         #FUN-D70090 add
             ORDER BY afb00,afb01, afb03, afb02  #No.MOD-480215
          IF SQLCA.sqlcode THEN CALL cl_err('i502_cur1',STATUS,1) END IF
          FOREACH i502_cur1 INTO l_afb.*
            IF SQLCA.sqlcode THEN
                LET g_success = 'N'              #No.MOD-480215
               CALL cl_err('i502_for1',STATUS,1)
               EXIT FOREACH
            END IF
            OUTPUT TO REPORT i502_rep1(l_afb.*,l_tmp.p001)
          END FOREACH
         #----------afc_file部份----------#
          DECLARE i502_cur2 CURSOR FOR
          SELECT * FROM afc_file                       
           WHERE afc00 = bookno  AND afc01 = budget AND afc02 =l_tmp.p002  #No.FUN-730070
             AND afc03 = yyy  AND afc04 !='@'    
            ORDER BY afc00,afc01,afc03,afc02,afc05   #No.MOD-480215
          IF SQLCA.sqlcode THEN
            LET g_success = 'N'                    #No.MOD-480215
            CALL cl_err('i502_cur2',STATUS,1)   
          END IF
          FOREACH i502_cur2 INTO l_afc.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('i502_for2',STATUS,1)
                LET g_success = 'N'                  #No.MOD-480215
               EXIT FOREACH
            END IF
            OUTPUT TO REPORT i502_rep2(l_afc.*,l_tmp.p001)
          END FOREACH
     END FOREACH
     FINISH REPORT i502_rep1
     FINISH REPORT i502_rep2
 
      #No.MOD-480215
     IF g_success = 'Y' THEN
        COMMIT WORK ELSE ROLLBACK WORK
     END IF
      #No.MOD-480215 (end)
 
#    LET l_cmd = "chmod 777 ", l_name," ",l_name2        #No.FUN-9C0009
#    RUN l_cmd                                           #No.FUN-9C0009  
     IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF    #No.FUN-9C0009
     IF os.Path.chrwx(l_name2 CLIPPED,511) THEN END IF   #No.FUN-9C0009      

     #-----TQC-630206---------
     IF STATUS THEN
        CALL cl_err('chmod 777',STATUS,1)
     END IF
     #-----END TQC-630206-----
 
    IF INT_FLAG THEN LET INT_FLAG = 0
       CLOSE WINDOW i502_wg
       RETURN
    END IF
    CLOSE i502_cur1
    CLOSE i502_cur2
    CLOSE WINDOW i502_wg
    CALL cl_end(0,0)
    drop table tmp_file
END FUNCTION
 
 
REPORT i502_rep1(sr1,p_p001)
  DEFINE sr1 RECORD LIKE afb_file.*
  DEFINE p_flag,p_p001 LIKE type_file.chr1       #No.FUN-680098   VARCHAR(1)
  DEFINE m_afb10    LIKE  type_file.num20_6,     #No.FUN-4C0009  #No.FUN-680098   DECIMAL(20,6)
         m_afb11    LIKE  type_file.num20_6,  #No.FUN-4C0009     #No.FUN-680098   DECIMAL(20,6)
         m_afb12    LIKE  type_file.num20_6,  #No.FUN-4C0009     #No.FUN-680098   DECIMAL(20,6)
         m_afb13    LIKE  type_file.num20_6,  #No.FUN-4C0009     #No.FUN-680098   DECIMAL(20,6)
         m_afb14    LIKE  type_file.num20_6   #No.FUN-4C0009     #No.FUN-680098   DECIMAL(20,6)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
   ORDER EXTERNAL BY sr1.afb00, sr1.afb01, sr1.afb03, sr1.afb02 #No.MOD-480215
 
  FORMAT
      AFTER GROUP OF sr1.afb02
         LET m_afb10=GROUP SUM(sr1.afb10)
         LET m_afb11=GROUP SUM(sr1.afb11)
         LET m_afb12=GROUP SUM(sr1.afb12)
         LET m_afb13=GROUP SUM(sr1.afb13)
         LET m_afb14=GROUP SUM(sr1.afb14)
        IF p_p001 ='Y' THEN
           UPDATE afb_file SET  afb10 = m_afb10,
                                afb11 = m_afb11,
                                afb12 = m_afb12,
                                afb13 = m_afb13,
                                afb14 = m_afb14
                   WHERE afb00 = sr1.afb00 AND afb01 = sr1.afb01
                     AND afb03 = sr1.afb03 AND afb02 = sr1.afb02
                     AND afb04 ='@'
           IF SQLCA.sqlcode THEN
#             CALL cl_err('upd afb :',SQLCA.sqlcode,1)   #No.FUN-660123
              CALL cl_err3("upd","afb_file",sr1.afb01,sr1.afb02,SQLCA.sqlcode,"","upd afb :",1)  #No.FUN-660123
               LET g_success = 'N' #No.MOD-480215
           END IF
        END IF
        IF p_p001 ='N' THEN
          INSERT INTO afb_file (afb00,afb01,afb02,afb03,afb04,afb05,afb06,  #No.MOD-470041
                               afb07,afb08,afb09,afb10,afb11,afb12,afb13,
                                afb14,afb15,afbacti,afbuser,afbgrup,        #No.MOD-480215
                               afbmodu,afbdate,afboriu,afborig)
              VALUES(sr1.afb00,sr1.afb01,sr1.afb02,sr1.afb03,'@',sr1.afb05,
                     sr1.afb06,sr1.afb07,sr1.afb08,sr1.afb09,m_afb10,m_afb11,
                     m_afb12,m_afb13,m_afb14,'1','Y',g_user,' ',g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins afb',SQLCA.sqlcode,1)   #No.FUN-660123
               CALL cl_err3("ins","afb_file",sr1.afb01,sr1.afb02,SQLCA.sqlcode,"","ins afb",1)  #No.FUN-660123
                LET g_success = 'N' #No.MOD-480215
            END IF
         END IF
END REPORT
 
REPORT i502_rep2(sr2,p_p001)
  DEFINE sr2 RECORD LIKE afc_file.*
  DEFINE p_p001    LIKE type_file.chr1     #No.FUN-680098   VARCHAR(1)
  DEFINE m_afc06   LIKE afc_file.afc06,    #No.FUN-4C0009 #No.FUN-680098  DECIMAL(20,6) 
         m_afc07   LIKE afc_file.afc07     #No.FUN-4C0009 #No.FUN-680098  DECIMAL(20,6)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
   ORDER EXTERNAL BY sr2.afc00,sr2.afc01,sr2.afc03,        #No.MOD-480215
                    sr2.afc02,sr2.afc05
 
  FORMAT
 
      AFTER GROUP OF sr2.afc05
         LET m_afc06=GROUP SUM(sr2.afc06)
         LET m_afc07=GROUP SUM(sr2.afc07)
       IF p_p001='Y'  THEN
          UPDATE afc_file SET afc06 = m_afc06
                          WHERE afc00 = sr2.afc00 AND afc01 = sr2.afc01
                            AND afc03 = sr2.afc03 AND afc04 = '@'
                            AND afc02 = sr2.afc02 AND afc05 = sr2.afc05
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd afc:',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("upd","afc_file",sr2.afc02,sr2.afc03,SQLCA.sqlcode,"","upd afc:",1)  #No.FUN-660123
             LET g_success = 'N'   #No.MOD-480215
         END IF
       END IF
       IF p_p001='N' THEN
         IF yyy != sr2.afc03 THEN #不同會計年度...已消耗預算不能代出
            LET m_afc07 = 0
         END IF
          INSERT INTO afc_file (afc00,afc01,afc02,afc03,afc04,afc05,  #No.MOD-470041
                               afc06,afc07)
              VALUES(sr2.afc00,sr2.afc01,sr2.afc02,sr2.afc03,'@',
                     sr2.afc05,m_afc06,m_afc07)
         IF SQLCA.sqlcode THEN
#           CALL cl_err('ins afc:',SQLCA.sqlcode,1)   #No.FUN-660123
            CALL cl_err3("ins","afc_file",sr2.afc02,sr2.afc03,SQLCA.sqlcode,"","ins afc:",1)  #No.FUN-660123
             LET g_success = 'N'   #No.MOD-480215
         END IF
       END IF
END REPORT
 
#genero
FUNCTION i502_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
 
      IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("afb00,afb01,afb02,afb03,afb041",TRUE)  #No.FUN-730070
      END IF
 
      IF INFIELD(afb05) OR (NOT g_before_input_done) THEN
             CALL cl_set_comp_entry("afb06,afb10,afc06_1",TRUE)
             CALL cl_set_comp_entry("afc06_2,afc06_3,afc06_4,afc06_5",TRUE)
             CALL cl_set_comp_entry("afc06_6,afc06_7,afc06_8,afc06_9",TRUE)
             CALL cl_set_comp_entry("afc06_10,afc06_11,afc06_12,afc06_13",TRUE)
             CALL cl_set_comp_entry("afb11,afb12,afb13,afb14",TRUE)
      END IF
 
END FUNCTION
#genero
FUNCTION i502_set_no_entry(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
    DEFINE   l_dir1    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
    DEFINE   l_dir2    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
    DEFINE   l_dir3    LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1) 
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("afb00,afb01,afb02,afb03,afb041",FALSE)  #No.FUN-730070
    END IF
    IF INFIELD(afb05) OR (NOT g_before_input_done) THEN
        IF g_afb.afb05 ='1' THEN
           CALL cl_set_comp_entry("afb06,afb10",FALSE)
           IF g_aza.aza02 = '1' THEN   #會計期間為12
              CALL cl_set_comp_entry("afc06_13",FALSE)
           END IF
        ELSE
           IF g_aza.aza02 = '2' THEN
              LET g_afb.afb06 = '2'
              CALL cl_set_comp_entry("afb06,afb10,afc06_1,afc06_2,afc06_3,afc06_4,afc06_5,afc06_6,afc06_7,afc06_8,afc06_9,afc06_10,afc06_11,afc06_12,afc06_13",FALSE)
              DISPLAY BY NAME g_afb.afb06
           ELSE
              CASE WHEN g_afb.afb05='2'
                        CALL cl_set_comp_entry("afb10,afc06_1,afc06_2,afc06_3,afc06_4,afc06_5,afc06_6,afc06_7,afc06_8,afc06_9,afc06_10,afc06_11,afc06_12,afc06_13",FALSE)
                   WHEN g_afb.afb05='3'
                        CALL cl_set_comp_entry("afc06_1,afc06_2,afc06_3,afc06_4,afc06_5,afc06_6,afc06_7,afc06_8,afc06_9,afc06_10,afc06_11,afc06_12,afc06_13,afb11,afb12,afb13,afb14",FALSE)
              END CASE
           END IF
        END IF
    END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <001,002> #


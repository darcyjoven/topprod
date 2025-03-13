# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimi111.4gl
# Descriptions...: 料件基本資料維護作業-採購/銷售資料
# Date & Author..: 92/01/07 By MAY
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/28 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: NO.TQC-5A0104 05/11/02 By Sarah 採購員資料輸入時,不會馬上帶出中文
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置調整
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.TQC-650004 06/05/04 By Claire check 供應商建檔否及顯示供應商簡稱
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-680034 06/08/23 By douzh 增加"費用科目二"欄位(imz1321) 
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件" 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.CHI-730031 07/04/10 By claire 加入(1)產品分類(2)費用科目(3)主要包裝的說明 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810016 08/01/24 By ve007 維護生產部位基本資料
# Modify.........: No.FUN-840052 08/09/22 By dxfwo  CR報表
# Modify.........: No.FUN-930108 09/03/23 By zhaijie添加imz926-AVL否欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10069 10/01/07 By sherry imz926賦初值
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No:MOD-AC0331 10/12/27 By lixh1 查看銷售/採購資料時,改為系統自動進入顯示狀態
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No:TQC-B20025 11/02/12 By destiny show的时候未显示oriu,orig
# Modify.........: No:MOD-B30055 11/03/07 By zhangll add cl_used
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.CHI-B70017 11/07/12 By jason ICD "PO對Blanket PO替代方式"欄位要隱藏
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No:FUN-BB0083 11/12/08 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C20048 12/02/10 By fengrui 數量欄位小數取位處理
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No:MOD-C80075 12/08/10 By ck2yuan imz51控卡應與aimi100的ima51控卡相同

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1          LIKE imz_file.imz01,
    g_imz            RECORD LIKE imz_file.*,
    g_imz_t          RECORD LIKE imz_file.*,
    g_imz_o          RECORD LIKE imz_file.*,
    g_imz01_t        LIKE imz_file.imz01,
    g_buf            LIKE oba_file.oba02,
    g_sw             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_sql       STRING                  #TQC-630166
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_table             STRING                 #No.FUN-840052                                                             
DEFINE l_sql               STRING                 #No.FUN-840052                                                             
DEFINE g_str               STRING                 #No.FUN-840052
DEFINE g_imz44_t           LIKE imz_file.imz44    #FUN-BB0083 add 
 
FUNCTION aimi111(p_argv1)
   DEFINE p_argv1         LIKE imz_file.imz01

   WHENEVER ERROR CALL cl_err_msg_log
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #Add No:MOD-B30055
   LET g_sql = " pmc03.pmc_file.pmc03,",
               " gen02.gen_file.gen02,",
               " imzacti.imz_file.imzacti,",
               " imz01.imz_file.imz01,",
               " imz02.imz_file.imz02,",
               " imz44.imz_file.imz44,",
               " imz44_fac.imz_file.imz44_fac,",
               " imz45.imz_file.imz45,",
               " imz46.imz_file.imz46,",
               " imz31.imz_file.imz31,",
               " imz31_fac.imz_file.imz31_fac,",
               " imz54.imz_file.imz54,",
               " imz43.imz_file.imz43 " 
   LET l_table = cl_prt_temptable('aimi111',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-840052---End 
 
    INITIALIZE g_imz.* TO NULL
    INITIALIZE g_imz_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imz_file WHERE imz01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi111_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 1 LET p_col = 3
    OPEN WINDOW aimi111_w AT p_row,p_col
         WITH FORM "aim/42f/aimi111"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("imz1321,aag02_2",g_aza.aza63='Y')     #FUN-680034  #CHI-730031
    #CHI-B70017 --START--
    IF s_industry('icd') THEN
       CALL cl_set_comp_visible("imz152",FALSE)
    END IF
    #CHI-B70017 --END--  
 
    LET g_argv1 = p_argv1
    IF g_argv1 IS NOT NULL AND g_argv1 !=' '
       THEN  CALL aimi111_q()
            #CALL aimi111_u()      #MOD-AC0331
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
      CALL aimi111_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi111_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #Add No:MOD-B30055
END FUNCTION
 
FUNCTION aimi111_curs()
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
    INITIALIZE g_imz.* TO NULL    #FUN-640213 add
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        imz01, imz02, imz08,imz25, imz03,
        imz43, imz44, imz44_fac,
        imz150,imz152,                           #No.FUN-810016 
        imz926,                                  #NO.FUN-930108 add imz926
        imz103,
        imz45, imz46, imz51, imz52 , imz47, imz54,
        imz88, imz89, imz90, imz50, imz48 , imz49,
        imz491,imz31, imz31_fac,imz130,imz148,imz131,
        imz132,imz1321,imz133,imz134, imz100, imz101,imz102,        #FUN-680034
        imzuser, imzgrup, imzmodu, imzdate, imzacti
        ,imzoriu,imzorig  #TQC-B90177
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(imz54)                       #供應商
#                CALL q_pmc1(0,0,g_imz.imz54) RETURNING g_imz.imz54
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.default1 = g_imz.imz54
                 #CALL cl_create_qry() RETURNING g_imz.imz54
                 #DISPLAY BY NAME g_imz.imz54
                 #CALL aimi111_imz54('d')
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz54
                 NEXT FIELD imz54
              WHEN INFIELD(imz43)                       #采購員(imz43)
#                CALL q_gen(10,3,g_imz.imz43) RETURNING g_imz.imz43
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_imz.imz43
                 #CALL cl_create_qry() RETURNING g_imz.imz43
                 #DISPLAY BY NAME g_imz.imz43
                 #CALL aimi111_peo(g_imz.imz43,'d')
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz43
                 NEXT FIELD imz43
              WHEN INFIELD(imz44)                       #采購單位(imz44)
#                CALL q_gfe(10,3,g_imz.imz44) RETURNING g_imz.imz44
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imz.imz44
                 #CALL cl_create_qry() RETURNING g_imz.imz44
                 #DISPLAY BY NAME g_imz.imz44
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz44
                 NEXT FIELD imz44
              WHEN INFIELD(imz31) #銷售單位
#                CALL q_gfe(10,21,g_imz.imz31) RETURNING g_imz.imz31
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imz.imz31
                 #CALL cl_create_qry() RETURNING g_imz.imz31
                 #DISPLAY BY NAME g_imz.imz31
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz31
                 NEXT FIELD imz31
              WHEN INFIELD(imz131)
#                CALL q_oba(10,3,g_imz.imz131) RETURNING g_imz.imz131
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_oba"
                 LET g_qryparam.default1 = g_imz.imz131
                 #CALL cl_create_qry() RETURNING g_imz.imz131
                 #DISPLAY BY NAME g_imz.imz131
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz131
                 NEXT FIELD imz131
              WHEN INFIELD(imz132)
#                CALL q_aag(10,3,g_imz.imz132,' ',' ',' ') RETURNING g_imz.imz12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_imz.imz132,' ',' ',' '
                 #CALL cl_create_qry() RETURNING g_imz.imz132
                 #DISPLAY BY NAME g_imz.imz132
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz132
                 NEXT FIELD imz132
#FUN-680034--begin                 
              WHEN INFIELD(imz1321)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_imz.imz1321,' ',' ',' '
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz1321
                 NEXT FIELD imz1321
#FUN-680034--end                 
              WHEN INFIELD(imz133)
#                CALL q_ima(10,3,g_imz.imz133) RETURNING g_imz.imz133
#FUN-AA0059 --Begin--
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_ima"
                 LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"     #FUN-AB0025
                 LET g_qryparam.default1 = g_imz.imz133
                 #CALL cl_create_qry() RETURNING g_imz.imz133
                 #DISPLAY BY NAME g_imz.imz133
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
              #  CALL q_sel_ima( TRUE, "q_ima","",g_imz.imz133,"","","","","",'')  RETURNING  g_qryparam.multiret   #FUN-AB0025 
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO imz133
                 NEXT FIELD imz133
              WHEN INFIELD(imz134)
#                CALL q_obe(10,3,g_imz.imz134) RETURNING g_imz.imz134
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_obe"
                 LET g_qryparam.default1 = g_imz.imz134
                 #CALL cl_create_qry() RETURNING g_imz.imz134
                 #DISPLAY BY NAME g_imz.imz134
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz134
                 NEXT FIELD imz134
              OTHERWISE EXIT CASE
           END CASE
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
    ELSE
      LET g_wc = " imz01 = '",g_argv1,"'"
    END IF
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #          LET g_wc = g_wc clipped," AND imzuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #          LET g_wc = g_wc clipped," AND imzgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #          LET g_wc = g_wc clipped," AND imzgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imzuser', 'imzgrup')
      #End:FUN-980030
 
    LET g_sql="SELECT imz01 FROM imz_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY imz01"
    PREPARE aimi111_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE aimi111_curs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi111_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM imz_file WHERE ",g_wc CLIPPED
    PREPARE aimi111_precount FROM g_sql
    DECLARE aimi111_count CURSOR FOR aimi111_precount
END FUNCTION
 
FUNCTION aimi111_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi111_q()
            END IF
        ON ACTION next
            CALL aimi111_fetch('N')
        ON ACTION previous
            CALL aimi111_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi111_u()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL aimi111_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_imz.imzacti)
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL aimi111_fetch('/')
        ON ACTION first
            CALL aimi111_fetch('F')
        ON ACTION last
            CALL aimi111_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-680046-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_imz.imz01 IS NOT NULL THEN
                 LET g_doc.column1 = "imz01"
                 LET g_doc.value1 = g_imz.imz01
                 CALL cl_doc()
              END IF
          END IF
       #No.FUN-680046-------add--------end---- 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END MENU
    CLOSE aimi111_curs
END FUNCTION
 
 
FUNCTION aimi111_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_imz08         LIKE imz_file.imz08,
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_imz46         LIKE imz_file.imz46,
        p_flag          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        p_imz44_fac     LIKE imz_file.imz44_fac,
        p_flag1         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        p_imz31_fac     LIKE imz_file.imz44_fac,
        l_case          STRING                  #FUN-BB0083
 
    DISPLAY BY NAME g_imz.imzuser,g_imz.imzgrup,g_imz.imzdate, g_imz.imzacti
    INPUT BY NAME
{
        imz01, imz02, imz08,imz25, imz03,
        imz43, imz44, imz44_fac,   ,imz103,
        imz45, imz46, imz51, imz52 , imz47, imz54,
        imz88, imz89, imz90, imz50, imz48     , imz49,
        imz491,imz31, imz31_fac,imz130,imz148,imz131,
        imz132, imz133,imz134, imz100, imz101,imz102,
}
      g_imz.imz43, g_imz.imz44,g_imz.imz44_fac,
      g_imz.imz150,g_imz.imz152,g_imz.imz926,           #No.FUN-810016 #FUN-930108 add imz926
      g_imz.imz103,g_imz.imz45 ,g_imz.imz46 ,
      g_imz.imz51, g_imz.imz52,
      g_imz.imz47, g_imz.imz54 ,g_imz.imz88,
      g_imz.imz89, g_imz.imz90,g_imz.imz50,
      g_imz.imz48, g_imz.imz49,g_imz.imz491   ,
      g_imz.imz31 ,g_imz.imz31_fac, g_imz.imz130 ,g_imz.imz148 ,
      g_imz.imz131,g_imz.imz132,g_imz.imz1321,g_imz.imz133, g_imz.imz134,g_imz.imz100,       #FUN-680034
      g_imz.imz101, g_imz.imz102,
      g_imz.imzuser, g_imz.imzgrup,g_imz.imzmodu,g_imz.imzdate, g_imz.imzacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i111_set_entry(p_cmd)
         CALL i111_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         #FUN-BB0083---add---str
         IF p_cmd = 'a' THEN
            LET g_imz44_t = NULL 
         ELSE
            LET g_imz44_t = g_imz.imz44
         END IF
         #FUN-BB0083---add---end
         
 
       AFTER FIELD imz54                  #主要供應商
         #TQC-650004-begin
         # IF (g_imz.imz54 != g_imz_o.imz54)
         #    OR (g_imz_o.imz54 IS NOT NULL AND g_imz.imz54 IS NULL) 
         #  THEN CALL aimi111_imz54('a')   
          CALL aimi111_imz54('a')   
         #TQC-650004-end
          IF g_chr='E' THEN
             CALL cl_err(g_imz.imz54,'mfg3001',0)
             LET g_imz.imz54 = g_imz_o.imz54
             DISPLAY BY NAME  g_imz.imz54
             NEXT FIELD imz54
          END IF
         #  END IF  #TQC-650004-mark
           LET g_imz_o.imz54 = g_imz.imz54 
 
        AFTER FIELD imz43            #採購員
            IF (g_imz.imz43 != g_imz_o.imz43)
              #OR (g_imz_o.imz43 IS NOT NULL AND g_imz.imz43 IS NULL) THEN   #TQC-5A0104 mark
               OR (g_imz_o.imz43 IS NULL AND g_imz.imz43 IS NOT NULL) THEN   #TQC-5A0104
               CALL aimi111_peo(g_imz.imz43,'a')
               IF g_chr = 'E' THEN
                  CALL cl_err(g_imz.imz43,'mfg1312',0)
                  LET g_imz.imz43 = g_imz_o.imz43
                  DISPLAY BY NAME  g_imz.imz43
                  NEXT FIELD imz43
               END IF
            END IF
            LET g_imz_o.imz43 = g_imz.imz43
 
         AFTER FIELD imz100
             IF NOT cl_null(g_imz.imz100) AND
                 g_imz.imz100 NOT MATCHES '[NTR]' THEN
                 LET g_imz.imz100 = g_imz_o.imz100
                 DISPLAY BY NAME g_imz.imz100
                 NEXT FIELD imz100
             END IF
             LET g_imz_o.imz100 = g_imz.imz100
 
          AFTER FIELD imz101
             IF NOT cl_null(g_imz.imz101) AND
                 g_imz.imz101 NOT MATCHES '[12]' THEN
                 LET g_imz.imz101 = g_imz_o.imz101
                 DISPLAY BY NAME g_imz.imz101
                 NEXT FIELD imz101
             END IF
             LET g_imz_o.imz101 = g_imz.imz101
 
           AFTER FIELD imz102
             IF NOT cl_null(g_imz.imz102) THEN
                IF g_imz.imz101='1' AND g_imz.imz102 NOT MATCHES '[123]' THEN
                    LET g_imz.imz102 = g_imz_o.imz102
                    DISPLAY BY NAME g_imz.imz102
                    NEXT FIELD imz102
                END IF
                IF g_imz.imz101='2' AND g_imz.imz102 NOT MATCHES '[1234]' THEN
                    LET g_imz.imz102 = g_imz_o.imz102
                    DISPLAY BY NAME g_imz.imz102
                    NEXT FIELD imz102
                END IF
                LET g_imz_o.imz102 = g_imz.imz102
             END IF
 
           AFTER FIELD imz103  #購料特性
             IF g_imz.imz103 IS NOT NULL THEN
                IF g_imz.imz103 not matches'[012]' THEN
                   NEXT FIELD imz103
                END IF
             END IF
 
        AFTER FIELD imz48          #採購安全期
             IF g_imz.imz48 < 0
                THEN  CALL cl_err(g_imz.imz48,'mfg0013',0)
                      LET g_imz.imz48 = g_imz_o.imz48
                      DISPLAY BY NAME  g_imz.imz48
                      NEXT FIELD imz48
             END IF
             LET g_imz_o.imz48 = g_imz.imz48
 
        AFTER FIELD imz50          #請購安全期
             IF g_imz.imz50 < 0
                THEN  CALL cl_err(g_imz.imz50,'mfg0013',0)
                      LET g_imz.imz50 = g_imz_o.imz50
                      DISPLAY BY NAME g_imz.imz50
                      NEXT FIELD imz50
             END IF
             LET g_imz_o.imz50 = g_imz.imz50
 
        AFTER FIELD imz49          #到廠前置期
             IF g_imz.imz49 < 0
                THEN  CALL cl_err(g_imz.imz49,'mfg0013',0)
                      LET g_imz.imz49 = g_imz_o.imz49
                      DISPLAY BY NAME g_imz.imz49
                      NEXT FIELD imz49
             END IF
             LET g_imz_o.imz49 = g_imz.imz49
 
        AFTER FIELD imz491          #入庫前置期
             IF g_imz.imz491 < 0
                THEN  CALL cl_err(g_imz.imz491,'mfg0013',0)
                      LET g_imz.imz491 = g_imz_o.imz491
                      DISPLAY BY NAME g_imz.imz491
                      NEXT FIELD imz491
             END IF
             LET g_imz_o.imz491 = g_imz.imz491
 
        AFTER FIELD imz88
           #FUN-BB0083---add---str
           IF NOT i111_imz88_check() THEN 
              NEXT FIELD imz88
           END IF
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           #  IF g_imz.imz88 < 0
           #     THEN  CALL cl_err(g_imz.imz88,'mfg1322',0)
           #           LET g_imz.imz88 = g_imz_o.imz88
           #           DISPLAY BY NAME g_imz.imz88
           #           NEXT FIELD imz88
           #  END IF
           #  LET g_imz_o.imz88 = g_imz.imz88
           #FUN-BB0083---mark---end 
 
        AFTER FIELD imz89
             IF NOT cl_null(g_imz.imz89) THEN
                IF g_imz.imz89 < 0 THEN
                   CALL cl_err(g_imz.imz89,'mfg0013',0)
                   LET g_imz.imz89 = g_imz_o.imz89
                   DISPLAY BY NAME g_imz.imz89
                   NEXT FIELD imz89
                END IF
             END IF
             LET g_imz_o.imz89 = g_imz.imz89
 
 
      # BEFORE FIELD imz90
      #      IF g_imz.imz37  != '5' THEN
      #         NEXT FIELD imz491
      #      END IF
 
        AFTER FIELD imz90
             IF NOT cl_null(g_imz.imz90) THEN
                IF g_imz.imz90 < 0 THEN
                   CALL cl_err(g_imz.imz90,'mfg0013',0)
                   NEXT FIELD imz90
                END IF
             END IF
 
        AFTER FIELD imz51          #經濟訂購量
           #FUN-BB0083---add---str
            IF NOT i111_imz51_check() THEN
               NEXT FIELD imz51
            END IF
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           #  IF g_imz.imz51 < 0
           #     THEN  CALL cl_err(g_imz.imz51,'mfg1322',0)
           #           LET g_imz.imz51 = g_imz_o.imz51
           #           DISPLAY BY NAME g_imz.imz51
           #           NEXT FIELD imz51
           #  END IF
           #FUN-BB0083---mark---end
        AFTER FIELD imz52          #平均訂購量
           #FUN-BB0083---add---str
            IF NOT i111_imz52_check() THEN
               NEXT FIELD imz52
            END IF
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           #  IF g_imz.imz52 < 0
           #     THEN  CALL cl_err(g_imz.imz52,'mfg1322',0)
           #           LET g_imz.imz52 = g_imz_o.imz52
           #           DISPLAY BY NAME g_imz.imz52
           #           NEXT FIELD imz52
           #  END IF
           #  LET g_imz_o.imz52 = g_imz.imz52
           #FUN-BB0083---mark---end
        AFTER FIELD imz44           #採購單位
             IF g_imz.imz44 IS NOT NULL THEN
                IF (g_imz_o.imz44 IS NULL ) OR (g_imz.imz44 != g_imz_o.imz44)
                   THEN SELECT gfe01
                          FROM gfe_file WHERE gfe01=g_imz.imz44 AND
                                              gfeacti IN ('Y','y')
                        IF SQLCA.sqlcode  THEN
#                          CALL cl_err(g_imz.imz44,'mfg1006',0)  #No.FUN-660156
                           CALL cl_err3("sel","gfe_file",g_imz.imz44,"",
                                        "mfg1006","","",1)  #No.FUN-660156
                           LET g_imz.imz44 = g_imz_o.imz44
                           DISPLAY BY NAME  g_imz.imz44
                           NEXT FIELD imz44
                       END IF
                END IF
            END IF
#--->default 轉換率 1992/10/20 by pin
            IF g_imz.imz25 IS NULL OR g_imz.imz44 IS NULL
               OR g_imz.imz25=' ' OR g_imz.imz44 =' '
               THEN LET g_imz.imz44_fac = ''
                    DISPLAY BY NAME g_imz.imz44_fac
               ELSE
                    IF g_imz.imz25 = g_imz.imz44
                       THEN LET g_imz.imz44_fac = 1
                            DISPLAY BY NAME g_imz.imz44_fac
                       ELSE
                            IF (g_imz_o.imz25 !=g_imz.imz25) OR
                               (g_imz_o.imz44 !=g_imz.imz44) OR
                               (g_imz_o.imz44 IS NULL OR g_imz_o.imz44=' ')
                              THEN CALL s_umfchk('',g_imz.imz44,g_imz.imz25)
                                       RETURNING p_flag,p_imz44_fac
                                  IF NOT p_flag
                                     THEN let g_imz.imz44_fac=p_imz44_fac
                                          DISPLAY  BY NAME g_imz.imz44_fac
                                     ELSE  CALL cl_err(g_imz.imz44,'mfg1206',0)
                                           NEXT FIELD imz44
                                  END IF
                            END IF
                    END IF
 
            END IF
            LET g_imz_o.imz44 = g_imz.imz44
            LET g_imz_o.imz44_fac = g_imz.imz44_fac
            #FUN-BB0083---add---str
               LET l_case = "" #FUN-C20048 add
               IF g_imz.imz37 != '5' THEN
                  LET g_imz.imz88 = s_digqty(g_imz.imz88,g_imz.imz44)
                  DISPLAY BY NAME g_imz.imz88  
               ELSE
                  IF NOT i111_imz88_check() THEN
                     LET l_case = "imz88"
                  END IF
               END IF
               
               IF NOT i111_imz45_check() THEN
                  LET l_case = "imz45"
               END IF
               IF NOT i111_imz46_check() THEN
                  LET l_case = "imz46"
               END IF
               IF NOT i111_imz51_check() THEN
                  LET l_case = "imz51"
               END IF
               IF NOT i111_imz52_check() THEN
                  LET l_case = "imz52"
               END IF
               LET g_imz44_t = g_imz.imz44
               CASE l_case
                  WHEN "imz45"
                     NEXT FIELD imz45
                  WHEN "imz46"
                     NEXT FIELD imz46
                  WHEN "imz51"
                     NEXT FIELD imz51
                  WHEN "imz52"
                     NEXT FIELD imz52
                  WHEN "imz88"
                     NEXT FIELD imz88
                  OTHERWISE EXIT CASE 
               END CASE 
            #FUN-BB0083---add---end 
 
        AFTER FIELD imz44_fac
          IF g_imz.imz44 IS NOT NULL AND g_imz.imz25 IS NOT NULL
            AND g_imz.imz44 !=' ' AND g_imz.imz25 !=' ' THEN
            IF g_imz.imz44_fac IS NULL OR g_imz.imz44_fac = ' '
               OR g_imz.imz44_fac <=0
                THEN  CALL cl_err(g_imz.imz44_fac,'mfg1322',0)
                      LET g_imz.imz44_fac = g_imz_o.imz44_fac
                      DISPLAY BY NAME g_imz.imz44_fac
                      NEXT FIELD imz44_fac
            END IF
          END IF
            LET g_imz_o.imz44_fac = g_imz.imz44_fac
 
        AFTER FIELD imz45          #採購單位批量
           #FUN-BB0083---add---str
            IF NOT i111_imz45_check() THEN
               NEXT FIELD imz45
            END IF
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           # IF g_imz.imz45 < 0
           #     THEN CALL cl_err(g_imz.imz45,'mfg1322',0)
           #          LET g_imz.imz45 = g_imz_o.imz45
           #          DISPLAY BY NAME g_imz.imz45
           #         NEXT FIELD imz45
           #  END IF
           #  LET g_imz_o.imz45 = g_imz.imz45
           #FUN-BB0083---mark---end 
        AFTER FIELD imz46          #最少採購數量
             #FUN-BB0083---add---str
             IF NOT i111_imz46_check() THEN
                NEXT FIELD imz46
             END IF
             #FUN-BB0083---add---end
             #FUN-BB0083---mark---str
             #IF g_imz.imz46 IS NULL OR g_imz.imz46 = ' '
             #   THEN LET g_imz.imz46=0
             #        DISPLAY BY NAME g_imz.imz46
             #END IF
             #IF g_imz.imz46 <0
             #   THEN
             #        CALL cl_err(g_imz.imz46,'mfg1322',0)
             #        LET g_imz.imz46 = g_imz_o.imz46
             #        DISPLAY BY NAME g_imz.imz46
             #        NEXT FIELD imz46
             #   ELSE
             #     IF  g_imz.imz45 >1 AND g_imz.imz46 >0
             #         THEN IF (g_imz.imz46 mod g_imz.imz45) != 0 THEN
             #                 CALL aimi111_size()
             #              END IF
             #     END IF
             #END IF
 
             #LET g_imz_o.imz46 = g_imz.imz46
             #FUN-BB0083---mark---end
        AFTER FIELD imz47          #採購損耗率
             IF g_imz.imz47 < 0
                THEN CALL cl_err(g_imz.imz47,'mfg0013',0)
                     LET g_imz.imz47 = g_imz_o.imz47
                     DISPLAY BY NAME g_imz.imz47
                     NEXT FIELD imz47
             END IF
             LET g_imz_o.imz47 = g_imz.imz47
 
        AFTER FIELD imz31           #銷售單位
          # IF  g_imz.imz31 IS NULL THEN
          #     LET g_imz.imz31 = g_imz_o.imz31
          #     DISPLAY BY NAME g_imz.imz31
          #    NEXT FIELD imz31
          # END IF
 
            IF g_imz.imz31 IS NOT NULL THEN
                IF ( g_imz_o.imz31 IS NULL ) OR ( g_imz.imz31 != g_imz_o.imz31 )
                   THEN SELECT gfe01
                          FROM gfe_file WHERE gfe01=g_imz.imz31 AND
                                              gfeacti IN ('Y','y')
                        IF SQLCA.sqlcode  THEN
#                          CALL cl_err(g_imz.imz31,'mfg1311',0)  #No.FUN-660156
                           CALL cl_err3("sel","gfe_file",g_imz.imz31,"",
                                        "mfg1311","","",1)  #No.FUN-660156
                           LET g_imz.imz31 = g_imz_o.imz31
                           DISPLAY BY NAME g_imz.imz31
                           NEXT FIELD imz31
                       END IF
                END IF
            END IF
#--->default 轉換率 1992/10/20 by pin
            IF g_imz.imz25 IS NULL OR g_imz.imz31 IS NULL
               OR g_imz.imz25=' ' OR g_imz.imz31 =' '
               THEN LET g_imz.imz31_fac = ''
                    DISPLAY BY NAME g_imz.imz31_fac
               ELSE
                    IF g_imz.imz25 = g_imz.imz31
                       THEN LET g_imz.imz31_fac = 1
                            DISPLAY BY NAME g_imz.imz31_fac
                       ELSE
                            IF (g_imz_o.imz25 !=g_imz.imz25) OR
                               (g_imz_o.imz31 !=g_imz.imz31) OR
                               (g_imz_o.imz31 IS NULL)
                              THEN CALL s_umfchk('',g_imz.imz31,g_imz.imz25)
                                       RETURNING p_flag,p_imz31_fac
                                  IF NOT p_flag
                                     THEN let g_imz.imz31_fac=p_imz31_fac
                                          DISPLAY  BY NAME g_imz.imz31_fac
                                     ELSE  CALL cl_err(g_imz.imz31,'mfg1206',0)
                                           NEXT FIELD imz31
                                  END IF
                            END IF
                    END IF
 
            END IF
            LET g_imz_o.imz31 = g_imz.imz31
            LET g_imz_o.imz31_fac = g_imz.imz31_fac
 
        AFTER FIELD imz31_fac
          IF g_imz.imz31 IS NOT NULL AND g_imz.imz25 IS NOT NULL
            AND g_imz.imz31 !=' ' AND g_imz.imz25 !=' ' THEN
            IF g_imz.imz31_fac IS NULL OR g_imz.imz31_fac = ' '
               OR g_imz.imz31_fac <= 0
               THEN CALL cl_err(g_imz.imz31_fac,'mfg1322',0)
                    LET g_imz.imz31_fac = g_imz_o.imz31_fac
                    DISPLAY BY NAME g_imz.imz31_fac
                    NEXT FIELD imz31_fac
            END IF
           END IF
            LET g_imz_o.imz31_fac = g_imz.imz31_fac
 
        AFTER FIELD imz130
            IF NOT cl_null(g_imz.imz130) AND
               g_imz.imz130 NOT MATCHES '[0123]' THEN
               NEXT FIELD imz130
            END IF
 
         AFTER FIELD imz148
            IF g_imz.imz148<0 THEN
               CALL cl_err('','aom-557',0)
               NEXT FIELD imz148
            END IF
 
        AFTER FIELD imz131
            IF NOT cl_null(g_imz.imz131) THEN   #NO:6843
               LET g_buf = NULL
               SELECT oba02 INTO g_buf FROM oba_file WHERE oba01=g_imz.imz131
               IF STATUS THEN
#              CALL cl_err('sel oba',STATUS,0) NEXT FIELD imz131
               CALL cl_err3("sel","oba_file",g_imz.imz131,"",STATUS,"","sel oba",1)   #NO.FUN-640266  #No.FUN-660156
                NEXT FIELD imz131
               END IF
              #CHI-730031-begin-add
               CALL aimi111_imz131('a')   
                  IF g_chr='E' THEN
                     CALL cl_err(g_imz.imz131,100,0)
                     LET g_imz.imz131 = g_imz_o.imz131
                     DISPLAY BY NAME  g_imz.imz131
                     NEXT FIELD imz131
                  END IF
              #CHI-730031-end-add
               MESSAGE g_buf CLIPPED
            END IF
        AFTER FIELD imz132    #NO:6843
            IF NOT cl_null(g_imz.imz132) THEN
                #FUN-B10049--begin
                #SELECT COUNT(*) INTO g_cnt FROM aag_file
                # WHERE aag01=g_imz.imz132
                #   AND aag00=g_aza.aza81  #No.FUN-730033
                #IF g_cnt=0 THEN
                #    CALL cl_err('sel aag',100,0)
                #    NEXT FIELD imz132
                #END IF
                #FUN-B10049--end
              #CHI-730031-begin-add
               CALL aimi111_imz132('a')   
                  IF g_chr='E' THEN
                     CALL cl_err(g_imz.imz132,100,0)
                     #FUN-B10049--begin
                     #LET g_imz.imz132 = g_imz_o.imz132
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_imz.imz132 
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_aza.aza81  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz132 CLIPPED,"%' "                                                                        
                     CALL cl_create_qry() RETURNING g_imz.imz132
                     #FUN-B10049--end                             
                     DISPLAY BY NAME  g_imz.imz132
                     NEXT FIELD imz132
                  END IF
              #CHI-730031-end-add
            END IF
#FUN-680034--begin
        AFTER FIELD imz1321    
            IF NOT cl_null(g_imz.imz1321) THEN
                #FUN-B10049--begin
                #SELECT COUNT(*) INTO g_cnt FROM aag_file
                # WHERE aag01=g_imz.imz1321
                #   AND aag00=g_aza.aza82  #No.FUN-730033
                #IF g_cnt=0 THEN
                #    CALL cl_err('sel aag',100,0)
                #    NEXT FIELD imz1321
                #END IF
                #FUN-B10049--end
              #CHI-730031-begin-add
               CALL aimi111_imz1321('a')   
                  IF g_chr='E' THEN
                     CALL cl_err(g_imz.imz1321,100,0)
                     #FUN-B10049--begin
                     #LET g_imz.imz1321 = g_imz_o.imz1321
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_imz.imz1321 
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_aza.aza81  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz1321 CLIPPED,"%' "                                                                        
                     CALL cl_create_qry() RETURNING g_imz.imz1321
                     #FUN-B10049--end                            
                     DISPLAY BY NAME  g_imz.imz1321
                     NEXT FIELD imz1321
                  END IF
              #CHI-730031-end-add
            END IF
#FUN-680034--end            
        AFTER FIELD imz134    #NO:6843
            IF NOT cl_null(g_imz.imz134) THEN
                SELECT COUNT(*) INTO g_cnt FROM obe_file
                 WHERE obe01=g_imz.imz134
                IF g_cnt=0 THEN
                    CALL cl_err('sel obe',100,0)
                    NEXT FIELD imz134
                END IF
              #CHI-730031-begin-add
               CALL aimi111_imz134('a')   
                  IF g_chr='E' THEN
                     CALL cl_err(g_imz.imz134,100,0)
                     LET g_imz.imz134 = g_imz_o.imz134
                     DISPLAY BY NAME  g_imz.imz134
                     NEXT FIELD imz134
                  END IF
              #CHI-730031-end-add
            END IF
 
        ON ACTION mntn_unit
                    CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
                    CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv
                    CALL cl_cmdrun("aooi103 ")
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(imz54)                       #供應商
#                CALL q_pmc1(0,0,g_imz.imz54) RETURNING g_imz.imz54
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz54 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.default1 = g_imz.imz54
                 CALL cl_create_qry() RETURNING g_imz.imz54
#                 CALL FGL_DIALOG_SETBUFFER( g_imz.imz54 )
                 DISPLAY BY NAME g_imz.imz54
                 CALL aimi111_imz54('d')
                 NEXT FIELD imz54
              WHEN INFIELD(imz43)                       #采購員(imz43)
#                CALL q_gen(10,3,g_imz.imz43) RETURNING g_imz.imz43
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz43 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_imz.imz43
                 CALL cl_create_qry() RETURNING g_imz.imz43
#                 CALL FGL_DIALOG_SETBUFFER( g_imz.imz43 )
                 DISPLAY BY NAME g_imz.imz43
                 CALL aimi111_peo(g_imz.imz43,'d')
                 NEXT FIELD imz43
              WHEN INFIELD(imz44)                       #采購單位(imz44)
#                CALL q_gfe(10,3,g_imz.imz44) RETURNING g_imz.imz44
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz44 )
                 CALL cl_init_qry_var()
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imz.imz44
                 CALL cl_create_qry() RETURNING g_imz.imz44
#                 CALL FGL_DIALOG_SETBUFFER( g_imz.imz44 )
                 DISPLAY BY NAME g_imz.imz44
                 NEXT FIELD imz44
              WHEN INFIELD(imz31) #銷售單位
#                CALL q_gfe(10,21,g_imz.imz31) RETURNING g_imz.imz31
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz31 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imz.imz31
                 CALL cl_create_qry() RETURNING g_imz.imz31
#                 CALL FGL_DIALOG_SETBUFFER( g_imz.imz31 )
                 DISPLAY BY NAME g_imz.imz31
                 NEXT FIELD imz31
              WHEN INFIELD(imz131)
#                CALL q_oba(10,3,g_imz.imz131) RETURNING g_imz.imz131
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz131 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oba"
                 LET g_qryparam.default1 = g_imz.imz131
                 CALL cl_create_qry() RETURNING g_imz.imz131
#                 CALL FGL_DIALOG_SETBUFFER( g_imz.imz131 )
                 DISPLAY BY NAME g_imz.imz131
                 CALL aimi111_imz131('d')   #CHI-730031
                 NEXT FIELD imz131
              WHEN INFIELD(imz132)
#                CALL q_aag(10,3,g_imz.imz132,' ',' ',' ') RETURNING g_imz.imz12
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz12 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_imz.imz132
                 LET g_qryparam.arg1 = g_aza.aza81   #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_imz.imz132
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz132 )
                 DISPLAY BY NAME g_imz.imz132
                 CALL aimi111_imz132('d')   #CHI-730031
                 NEXT FIELD imz132
#FUN-680034--begin                 
              WHEN INFIELD(imz1321)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_imz.imz1321
                 LET g_qryparam.arg1 = g_aza.aza82   #No.FUN-730033
                 CALL cl_create_qry() RETURNING g_imz.imz1321
                 DISPLAY BY NAME g_imz.imz1321
                 CALL aimi111_imz1321('d')   #CHI-730031
                 NEXT FIELD imz1321
#FUN-680034--end                 
              WHEN INFIELD(imz133)
#                CALL q_ima(10,3,g_imz.imz133) RETURNING g_imz.imz133
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz133 )
#FUN-AA0059 --Begin--
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ima"
                 LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AB0025
                 LET g_qryparam.default1 = g_imz.imz133
                 CALL cl_create_qry() RETURNING g_imz.imz133
#                 CALL FGL_DIALOG_SETBUFFER( g_imz.imz133 )
               # CALL q_sel_ima(FALSE, "q_ima", "", g_imz.imz133, "", "", "", "" ,"",'' )  RETURNING g_imz.imz133    #FUN-AB0025
#FUN-AA0059 --End--
                 DISPLAY BY NAME g_imz.imz133
                 NEXT FIELD imz133
              WHEN INFIELD(imz134)
#                CALL q_obe(10,3,g_imz.imz134) RETURNING g_imz.imz134
#                CALL FGL_DIALOG_SETBUFFER( g_imz.imz134 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_obe"
                 LET g_qryparam.default1 = g_imz.imz134
                 CALL cl_create_qry() RETURNING g_imz.imz134
#                 CALL FGL_DIALOG_SETBUFFER( g_imz.imz134 )
                 DISPLAY BY NAME g_imz.imz134
                 CALL aimi111_imz134('d')   #CHI-730031
                 NEXT FIELD imz134
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
 
FUNCTION i111_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF g_imz.imz37 = '5' THEN
      CALL cl_set_comp_entry("imz88,imz89,imz90",TRUE)
   END IF
END FUNCTION
 
FUNCTION i111_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF g_imz.imz37 != '5' THEN
      CALL cl_set_comp_entry("imz88,imz89,imz90",FALSE)
   END IF
END FUNCTION
 
FUNCTION aimi111_size()  #供應廠商
DEFINE
        l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_imz46         LIKE imz_file.imz46
      LET l_count = g_imz.imz46 MOD g_imz.imz45
      IF l_count != 0 THEN
        LET l_count = g_imz.imz46/ g_imz.imz45
        LET l_imz46 = ( l_count + 1 ) * g_imz.imz45
        CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
        WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT g_msg CLIPPED,'(',l_imz46,')',':' FOR g_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
#                 CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           END PROMPT
           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
        END WHILE
       IF g_chr ='Y' OR g_chr = 'y'  THEN
         LET g_imz.imz46 = l_imz46
       END IF
     DISPLAY BY NAME g_imz.imz46
   END IF
   LET g_chr = NULL
END FUNCTION
 
#CHI-730031-begin-add
FUNCTION aimi111_imz131(p_cmd)  #產品分類
    DEFINE p_cmd     LIKE type_file.chr1,
           l_oba02   LIKE oba_file.oba02 
 
    LET g_chr = ' '
    IF g_imz.imz131 IS NULL THEN
        LET l_oba02=NULL
    ELSE
        SELECT oba02
           INTO l_oba02
           FROM oba_file WHERE oba01 = g_imz.imz131
        IF SQLCA.sqlcode THEN
            LET g_chr = 'E'
            LET l_oba02 = NULL
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_oba02 TO oba02
    END IF
END FUNCTION
 
FUNCTION aimi111_imz132(p_cmd)  #費用科目
    DEFINE p_cmd     LIKE type_file.chr1,
           l_aag02   LIKE aag_file.aag02,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_chr = ' '
    IF g_imz.imz132 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aagacti
           INTO l_aag02,l_aagacti
           FROM aag_file WHERE aag01 = g_imz.imz132
                           AND aag00 = g_aza.aza81  
        IF SQLCA.sqlcode THEN
            LET g_chr = 'E'
            LET l_aag02 = NULL
        ELSE
            IF l_aagacti='N' THEN
                LET g_chr = 'E'
            END IF
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_aag02 TO aag02
    END IF
END FUNCTION
 
FUNCTION aimi111_imz1321(p_cmd)  #費用科目
    DEFINE p_cmd     LIKE type_file.chr1,
           l_aag02   LIKE aag_file.aag02,
           l_aagacti LIKE aag_file.aagacti
 
    LET g_chr = ' '
    IF g_imz.imz1321 IS NULL THEN
        LET l_aag02=NULL
    ELSE
        SELECT aag02,aagacti
           INTO l_aag02,l_aagacti
           FROM aag_file WHERE aag01 = g_imz.imz1321
                           AND aag00 = g_aza.aza81  
        IF SQLCA.sqlcode THEN
            LET g_chr = 'E'
            LET l_aag02 = NULL
        ELSE
            IF l_aagacti='N' THEN
                LET g_chr = 'E'
            END IF
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_aag02 TO aag02_2
    END IF
END FUNCTION
 
FUNCTION aimi111_imz134(p_cmd)  #主要包裝
    DEFINE p_cmd     LIKE type_file.chr1,
           l_obe02   LIKE obe_file.obe02
 
    LET g_chr = ' '
    IF g_imz.imz134 IS NULL THEN
        LET l_obe02=NULL
    ELSE
        SELECT obe02
           INTO l_obe02
           FROM obe_file WHERE obe01 = g_imz.imz134
        IF SQLCA.sqlcode THEN
            LET g_chr = 'E'
            LET l_obe02 = NULL
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_obe02 TO obe02
    END IF
END FUNCTION
#CHI-730031-end-add
 
 
FUNCTION aimi111_imz54(p_cmd)  #供應廠商
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_pmc03   LIKE pmc_file.pmc03,
           l_pmcacti LIKE pmc_file.pmcacti
 
    LET g_chr = ' '
    IF g_imz.imz54 IS NULL THEN
        LET l_pmc03=NULL
    ELSE
        SELECT pmc03,pmcacti
           INTO l_pmc03,l_pmcacti
           FROM pmc_file WHERE pmc01 = g_imz.imz54
        IF SQLCA.sqlcode THEN
            LET g_chr = 'E'
            LET l_pmc03 = NULL
        ELSE
            IF l_pmcacti='N' THEN
                LET g_chr = 'E'
            END IF
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_pmc03 TO pmc03
    END IF
END FUNCTION
 
FUNCTION aimi111_peo(p_key,p_cmd)    #人員
    DEFINE p_key     LIKE gen_file.gen01,
           p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02   LIKE gen_file.gen02
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_gen02=NULL
    ELSE
        SELECT gen02,genacti INTO l_gen02,l_genacti
          FROM gen_file
           WHERE gen01 = p_key
        IF SQLCA.sqlcode
           THEN LET l_gen02 = NULL
                LET g_chr = 'E'
           ELSE
             IF l_genacti='N' THEN
                LET g_chr = 'E'
             END IF
        END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
      THEN DISPLAY l_gen02 TO gen02
    END IF
END FUNCTION
 
FUNCTION aimi111_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi111_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi111_count
    FETCH aimi111_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi111_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL
    ELSE
        CALL aimi111_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi111_fetch(p_flimz)
    DEFINE
        p_flimz          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimz
        WHEN 'N' FETCH NEXT     aimi111_curs INTO g_imz.imz01
        WHEN 'P' FETCH PREVIOUS aimi111_curs INTO g_imz.imz01
        WHEN 'F' FETCH FIRST    aimi111_curs INTO g_imz.imz01
        WHEN 'L' FETCH LAST     aimi111_curs INTO g_imz.imz01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump aimi111_curs INTO g_imz.imz01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
       INITIALIZE g_imz.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flimz
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_imz.* FROM imz_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imz01 = g_imz.imz01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)  #No.FUN-660156
       CALL cl_err3("sel","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_imz.imzuser #FUN-4C0053
        LET g_data_group = g_imz.imzgrup #FUN-4C0053
        CALL aimi111_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi111_show()
 
    LET g_imz_t.* = g_imz.*
    DISPLAY BY NAME
        g_imz.imz01, g_imz.imz02, g_imz.imz03,g_imz.imz25,
        g_imz.imz08, g_imz.imz54, g_imz.imz43,g_imz.imz100,
        g_imz.imz101,g_imz.imz102,g_imz.imz103,g_imz.imz48,
        g_imz.imz50, g_imz.imz49, g_imz.imz491, g_imz.imz88,
        g_imz.imz89, g_imz.imz90, g_imz.imz51, g_imz.imz52,
        g_imz.imz44, g_imz.imz44_fac,
        g_imz.imz150,g_imz.imz152,g_imz.imz926,         #No.FUN-810016 #FUN-930108 add imz926
        g_imz.imz130,g_imz.imz131,
        g_imz.imz132,g_imz.imz1321,g_imz.imz133,g_imz.imz134,g_imz.imz45, g_imz.imz46,   #FUN-680034
        g_imz.imz47, g_imz.imz31,g_imz.imz31_fac, g_imz.imzuser,
        g_imz.imzgrup, g_imz.imzmodu, g_imz.imzdate,
        g_imz.imzacti,g_imz.imzoriu,g_imz.imzorig  #TQC-B20025
 
    CALL aimi111_imz54('d')
    CALL aimi111_imz131('d')   #CHI-730031
    CALL aimi111_imz132('d')   #CHI-730031
    CALL aimi111_imz1321('d')   #CHI-730031
    CALL aimi111_imz134('d')   #CHI-730031
    CALL aimi111_peo(g_imz.imz43,'d')
    CALL cl_set_field_pic("","","","","",g_imz.imzacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi111_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
  #TQC-650004-begin
   SELECT * INTO g_imz.* FROM imz_file
    WHERE imz01=g_imz.imz01
  #TQC-650004-end
 
    IF g_imz.imzacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imz.imz01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imz01_t = g_imz.imz01
    LET g_imz_o.* = g_imz.*
    BEGIN WORK
 
    OPEN aimi111_curl USING g_imz.imz01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN aimi111_curl:", STATUS, 1)
       CLOSE aimi111_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi111_curl INTO g_imz.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imz.imzmodu = g_user                   #修改者
    LET g_imz.imzdate = g_today                  #修改日期
    IF g_imz.imz926 IS NULL OR cl_null(g_imz.imz926) THEN  #TQC-A10069
       LET g_imz.imz926 = 'N'   #TQC-A10069
    END IF   #TQC-A10069
    #CHI-B70017 --START--
    IF g_imz.imz152 is NULL OR cl_null(g_imz.imz152) THEN
       LET g_imz.imz152 = '0'
    END IF
    #CHI-B70017 --END--
    CALL aimi111_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi111_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imz_t.imzdate=g_imz_o.imzdate        #TQC-C40219
            LET g_imz_t.imzmodu=g_imz_o.imzmodu        #TQC-C40219
            LET g_imz.*=g_imz_t.*     #TQC-C40155 #TQC-C40219
           #LET g_imz.*=g_imz_o.*     #TQC-C40155 #TQC-C40219
            CALL aimi111_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
#       LET g_imz.imz93[3,3] = 'Y'
        UPDATE imz_file SET imz_file.* = g_imz.*    # 更新DB
            WHERE imz01 = g_imz.imz01               # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)  #No.FUN-660156
           CALL cl_err3("upd","imz_file",g_imz_t.imz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi111_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi111_out()
    DEFINE
        sr              RECORD LIKE imz_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_pmc03         LIKE pmc_file.pmc03,    #No.FUN-840052
        l_gen02         LIKE gen_file.gen02,    #No.FUN-840052           
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
#   LET l_name = 'aimi111.out'
#   CALL cl_outnam('aimi111') RETURNING l_name  #No.FUN-840052
    CALL cl_del_data(l_table)                   #No.FUN-840052
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#No.TQC-5C0005 start
#    DECLARE aimi111_za_cur CURSOR FOR
#            SELECT za02,za05 FROM za_file
#             WHERE za01 = "aimi111" AND za03 = g_lang
#    FOREACH aimi111_za_cur INTO g_i,l_za05
#       LET g_x[g_i] = l_za05
#    END FOREACH
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimi111'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.TQC-5C0005 end
    LET g_sql="SELECT * FROM imz_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE aimi111_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi111_curo                         # CURSOR
        CURSOR FOR aimi111_p1
 
#  START REPORT aimi111_rep TO l_name             #No.FUN-840052
 
    FOREACH aimi111_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-840052---Begin
#       OUTPUT TO REPORT aimi111_rep(sr.*)
        SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.imz54
        IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.imz43
        IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
        EXECUTE insert_prep USING  l_pmc03,     l_gen02,     sr.imzacti, sr.imz01, sr.imz02,
                                   sr.imz44,    sr.imz44_fac,sr.imz45,   sr.imz46, sr.imz31,
                                   sr.imz31_fac,sr.imz54,    sr.imz43 
    END FOREACH
 
#   FINISH REPORT aimi111_rep
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'imz01, imz02, imz08,imz25, imz03,
        imz43, imz44, imz44_fac,   imz103,
        imz45, imz46, imz51, imz52 , imz47, imz54,
        imz88, imz89, imz90, imz50, imz48     , imz49,
        imz491,imz31, imz31_fac,imz130,imz148,imz131,
        imz132,imz1321,imz133,imz134, imz100, imz101,imz102')         
            RETURNING g_wc                                                                                                            
    END IF
   LET g_str = g_wc
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   
   CALL cl_prt_cs3('aimi111','aimi111',l_sql,g_str)
    CLOSE aimi111_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len) #No.TQC-5C0005
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.TQC-5C0005
#No.FUN-840052---End
END FUNCTION
 
#No.FUN-840052---Begin
#REPORT aimi111_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#        l_pmc03         LIKE pmc_file.pmc03,
#        l_gen02         LIKE gen_file.gen02,
#        sr              RECORD LIKE imz_file.*,
#        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.imz01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT
#            PRINT g_dash
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#            PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.imz54
#            IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
#            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.imz43
#            IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
#           #No.B025 010326 by plum
#            IF sr.imzacti = 'N' THEN
#                PRINTX name=D1 COLUMN g_c[31],'*';
#            ELSE
#                PRINTX name=D1 COLUMN g_c[31],' ';
#            END IF
#            PRINTX name=D1 COLUMN g_c[32],sr.imz01,
#                           COLUMN g_c[33],sr.imz02,
#                           COLUMN g_c[34],sr.imz44,
#                           COLUMN g_c[35],cl_numfor(sr.imz44_fac,35,6),
#                           COLUMN g_c[36],cl_numfor(sr.imz45,36,3),
#                           COLUMN g_c[37],cl_numfor(sr.imz46,36,3)
#            PRINTX name=D2 COLUMN g_c[38],' ',
#                           COLUMN g_c[39],sr.imz31,
#                           COLUMN g_c[40],cl_numfor(sr.imz31_fac,40,6),
#                           COLUMN g_c[41],sr.imz54,
#                           COLUMN g_c[42],l_pmc03,
#                           COLUMN g_c[43],sr.imz43,
#                           COLUMN g_c[44],l_gen02
#           #..end
#
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#            END IF
#            PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-840052---End
#FUN-BB0083---add---str
FUNCTION i111_imz45_check()
#imz45 的單位 imz44   
   IF NOT cl_null(g_imz.imz44) AND NOT cl_null(g_imz.imz45) THEN
      IF cl_null(g_imz_t.imz45) OR cl_null(g_imz44_t) OR g_imz_t.imz45 != g_imz.imz45 OR g_imz44_t != g_imz.imz44 THEN 
         LET g_imz.imz45=s_digqty(g_imz.imz45,g_imz.imz44)
         DISPLAY BY NAME g_imz.imz45  
      END IF  
   END IF
   IF g_imz.imz45 < 0
                THEN CALL cl_err(g_imz.imz45,'mfg1322',0)
                     LET g_imz.imz45 = g_imz_o.imz45
                     DISPLAY BY NAME g_imz.imz45
                     RETURN FALSE 
             END IF
             LET g_imz_o.imz45 = g_imz.imz45
RETURN TRUE 
END FUNCTION

FUNCTION i111_imz46_check()
#imz46 的單位 imz44
   IF NOT cl_null(g_imz.imz44) AND NOT cl_null(g_imz.imz46) THEN
      IF cl_null(g_imz_t.imz46) OR cl_null(g_imz44_t) OR g_imz_t.imz46 != g_imz.imz46 OR g_imz44_t != g_imz.imz44 THEN 
         LET g_imz.imz46=s_digqty(g_imz.imz46,g_imz.imz44)
         DISPLAY BY NAME g_imz.imz46  
      END IF  
   END IF
   IF g_imz.imz46 IS NULL OR g_imz.imz46 = ' '
                THEN LET g_imz.imz46=0
                     DISPLAY BY NAME g_imz.imz46
             END IF
             IF g_imz.imz46 <0
                THEN
                     CALL cl_err(g_imz.imz46,'mfg1322',0)
                     LET g_imz.imz46 = g_imz_o.imz46
                     DISPLAY BY NAME g_imz.imz46
                     RETURN FALSE
                ELSE
                  IF  g_imz.imz45 >1 AND g_imz.imz46 >0
                      THEN IF (g_imz.imz46 mod g_imz.imz45) != 0 THEN
                              CALL aimi111_size()
                           END IF
                  END IF
            END IF
 
             LET g_imz_o.imz46 = g_imz.imz46
 
RETURN TRUE
END FUNCTION

FUNCTION i111_imz51_check()
#imz51 的單位 imz44
   IF NOT cl_null(g_imz.imz44) AND NOT cl_null(g_imz.imz51) THEN
      IF cl_null(g_imz_t.imz51) OR cl_null(g_imz44_t) OR g_imz_t.imz51 != g_imz.imz51 OR g_imz44_t != g_imz.imz44 THEN 
         LET g_imz.imz51=s_digqty(g_imz.imz51,g_imz.imz44)
         DISPLAY BY NAME g_imz.imz51  
      END IF  
   END IF
  #IF g_imz.imz51 < 0      #MOD-C80075 mark
   IF g_imz.imz51 <=0      #MOD-C80075 add
                THEN  CALL cl_err(g_imz.imz51,'mfg1322',0)
                      LET g_imz.imz51 = g_imz_o.imz51
                      DISPLAY BY NAME g_imz.imz51
                      RETURN FALSE
             END IF
RETURN TRUE
END FUNCTION

FUNCTION i111_imz52_check()
#imz52 的單位 imz44
   IF NOT cl_null(g_imz.imz44) AND NOT cl_null(g_imz.imz52) THEN
      IF cl_null(g_imz_t.imz52) OR cl_null(g_imz44_t) OR g_imz_t.imz52 != g_imz.imz52 OR g_imz44_t != g_imz.imz44 THEN 
         LET g_imz.imz52=s_digqty(g_imz.imz52,g_imz.imz44)
         DISPLAY BY NAME g_imz.imz52  
      END IF  
   END IF
   IF g_imz.imz52 < 0
                THEN  CALL cl_err(g_imz.imz52,'mfg1322',0)
                      LET g_imz.imz52 = g_imz_o.imz52
                      DISPLAY BY NAME g_imz.imz52
                      RETURN FALSE
             END IF
             LET g_imz_o.imz52 = g_imz.imz52
RETURN TRUE
END FUNCTION

FUNCTION i111_imz88_check()
#imz88 的單位 imz44
   IF NOT cl_null(g_imz.imz44) AND NOT cl_null(g_imz.imz88) THEN
      IF cl_null(g_imz_t.imz88) OR cl_null(g_imz44_t) OR g_imz_t.imz88 != g_imz.imz88 OR g_imz44_t != g_imz.imz44 THEN 
         LET g_imz.imz88=s_digqty(g_imz.imz88,g_imz.imz44)
         DISPLAY BY NAME g_imz.imz88  
      END IF  
   END IF
   IF g_imz.imz88 < 0
                THEN  CALL cl_err(g_imz.imz88,'mfg1322',0)
                      LET g_imz.imz88 = g_imz_o.imz88
                      DISPLAY BY NAME g_imz.imz88
                      RETURN FALSE 
             END IF
             LET g_imz_o.imz88 = g_imz.imz88

RETURN TRUE
END FUNCTION
#FUN-BB0083---add---end

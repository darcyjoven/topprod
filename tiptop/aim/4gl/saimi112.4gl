# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimi112.4gl
# Descriptions...: 料件分群碼基本資料維護作業-生管資料
# Date & Author..: 92/01/07 By MAY
# Modify.........: No:8474 03/12/02 ching add imz571
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/02/01 By Mandy 報表轉XML
# Modify.........: NO.MOD-640200 06/04/14 by Yiting imz65/imz66取消
# Modify.........: NO.FUN-650004 06/05/03 by kim 應該增加「預設在製倉庫」、「儲位」的輸入，以與料件主檔一致。
# Modify.........: NO.TQC-650003 06/05/03 by kim GP3.0 執行aimi112,查詢任何資料後,按修改無反應(從aimi110串aimi112,同樣無法按修改)
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/26 By jamie 1.FUNCTION i112_q() 一開始應清空g_imz.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0021 06/12/05 By Judy 1.查詢時光標跳動順序                                                              
#                                                 2.累計前置時間控管                                                                
#                                                 3.三方時間有變動時，累計時間變 
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840052 08/09/22 By dxfwo  CR報表
# Modify.........: No.FUN-8C0086 08/12/16 By claire 加入imz601變動前置時間批量
# Modify.........: No.FUN-910053 09/02/12 By jan 增加欄位imz153
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A50111 10/05/18 By Sarah imz601若為NULL則default為1
# Modify.........: No:MOD-A50113 10/05/18 By Sarah 若imz571有值,imz94開窗用q_ecu101;若imz571沒值,imz94開窗用q_ecu1
# Modify.........: No:TQC-AB0409 10/12/03 By lixh1 ima136欄位開窗時只顯示wip倉資料,增加ima136 after field控管 
# Modify.........: No:MOD-AC0331 10/12/27 By lixh1 查看銷售/生管 的資料時,改為系統自動進入顯示狀態
# Modify.........: No:TQC-B20025 11/02/12 By destiny show的时候未显示oriu,orig
# Modify.........: No:MOD-B30055 11/03/07 By zhangll add cl_used
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No:FUN-BB0083 11/12/08 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C20048 12/02/09 By fengrui 數量欄位小數取位處理
# Modify.........: No:TQC-C20183 12/02/16 By xujing 小數取位修改
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1             LIKE imz_file.imz01,
    g_imz               RECORD LIKE imz_file.*,
    g_imz_t             RECORD LIKE imz_file.*,
    g_imz_o             RECORD LIKE imz_file.*,
    g_imz01_t           LIKE imz_file.imz01,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_sql          STRING  #TQC-630166
 
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql     STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr            LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_table          STRING                 #No.FUN-840052                                                             
DEFINE l_sql            STRING                 #No.FUN-840052                                                             
DEFINE g_str            STRING                 #No.FUN-840052
DEFINE g_imz55_t        LIKE imz_file.imz55    #FUN-BB0083 add
DEFINE g_imz63_t        LIKE imz_file.imz63    #FUN-BB0083 add
 
FUNCTION aimi112(p_argv1)
   DEFINE      p_argv1         LIKE imz_file.imz01

   WHENEVER ERROR CALL cl_err_msg_log

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #Add No:MOD-B30055
 
   LET g_sql = " imzacti.imz_file.imzacti,",
               " imz01.imz_file.imz01,",
               " imz02.imz_file.imz02,",
               " imz55.imz_file.imz55,",
               " imz56.imz_file.imz56,",
               " imz55_fac.imz_file.imz55_fac,",
               " imz561.imz_file.imz561,",
               " imz67.imz_file.imz67,",
               " imz63.imz_file.imz63,",
               " imz64.imz_file.imz64,",
               " imz63_fac.imz_file.imz63_fac,",
               " imz641.imz_file.imz641,",
               " gen02.gen_file.gen02,",
               " imz68.imz_file.imz68,",
               " imz69.imz_file.imz69 " 
   LET l_table = cl_prt_temptable('aimi111',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
      EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM                                                                             
   END IF
            
    INITIALIZE g_imz.* TO NULL
    INITIALIZE g_imz_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM imz_file WHERE imz01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE aimi112_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW aimi112_w AT p_row,p_col
         WITH FORM "aim/42f/aimi112"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_argv1 = p_argv1
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN CALL aimi112_q()
           #CALL aimi112_u()        #MOD-AC0331
    END IF
 
    WHILE TRUE
      LET g_action_choice=""
    CALL aimi112_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW aimi112_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #Add No:MOD-B30055
END FUNCTION
 
FUNCTION aimi112_curs()
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
    INITIALIZE g_imz.* TO NULL    #FUN-640213 add
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        imz01, imz02, imz08, imz25, imz03,imz70,  #TQC-6C0021
        imz55, imz55_fac, imz110, imz56, imz561,imz562,
        imz59, imz60, imz601, imz61, imz62, imz571,imz94, imz153,imz67, imz68, imz69    , #FUN-8C0086 add imz601 #FUN-910053 add imz153
        #imz63 ,imz63_fac, imz108, imz64, imz641, imz65, imz66,
        imz63 ,imz63_fac, imz108, imz64, imz641,  #NO.MOD-640200
        imz136,imz137, #FUN-650004
        imzuser, imzgrup, imzmodu, imzdate, imzacti
        ,imzoriu,imzorig  #TQC-B90177
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(imz67)                       #采購員(imz67)
#                CALL q_gen(9,30,g_imz.imz67) RETURNING g_imz.imz67
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_imz.imz67
                 #CALL cl_create_qry() RETURNING g_imz.imz67
                 #DISPLAY BY NAME g_imz.imz67
                 #CALL aimi112_peo(g_imz.imz67,'d')
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz67
                 NEXT FIELD imz67
              WHEN INFIELD(imz55)                       # 生產單位 (imz55)
#                CALL q_gfe(10,3,g_imz.imz55) RETURNING g_imz.imz55
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imz.imz55
                 #CALL cl_create_qry() RETURNING g_imz.imz55
                 #DISPLAY BY NAME g_imz.imz55
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz55
                 NEXT FIELD imz55
              WHEN INFIELD(imz63)                       # 發料單位 (imz63)
#                CALL q_gfe(10,3,g_imz.imz63) RETURNING g_imz.imz63
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_imz.imz63
                 #CALL cl_create_qry() RETURNING g_imz.imz63
                 #DISPLAY BY NAME g_imz.imz63
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz63
                 NEXT FIELD imz63
              WHEN INFIELD(imz571) #No:8487
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_ecu1"
                 LET g_qryparam.default1 = g_imz.imz571
                 LET g_qryparam.multiret_index = 1   #MOD-A50113 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz571
                 NEXT FIELD imz571
              WHEN INFIELD(imz94)
#                CALL q_ecu1(0,0,g_imz.imz571,g_imz.imz94)
#                     RETURNING g_imz.imz571,g_imz.imz94
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_ecu102"
                 LET g_qryparam.default1 = g_imz.imz571
                 LET g_qryparam.default2 = g_imz.imz94
                 LET g_qryparam.arg1 = g_imz.imz571
                 LET g_qryparam.arg2 = g_imz.imz94
                #LET g_qryparam.multiret_index = 1
                 LET g_qryparam.multiret_index = 2   #MOD-A50113 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz94
                 NEXT FIELD imz94
              #FUN-650004...............begin
              WHEN INFIELD(imz136)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state="c"
                 LET g_qryparam.form ="q_imd"
                 LET g_qryparam.default1 = g_imz.imz136
                #LET g_qryparam.arg1     = 'SW'        #倉庫類別  #TQC-AB0409
                 LET g_qryparam.arg1     = 'W'         #TQC-AB0409
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz136
                 NEXT FIELD imz136
              WHEN INFIELD(imz137)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state="c"
                 LET g_qryparam.form ="q_ime"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imz137
                 NEXT FIELD imz137
              #FUN-650004...............end
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
    PREPARE aimi112_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE aimi112_curs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR aimi112_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM imz_file WHERE ",g_wc CLIPPED
    PREPARE aimi112_precount FROM g_sql
    DECLARE aimi112_count CURSOR FOR aimi112_precount
END FUNCTION
 
FUNCTION aimi112_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi112_q()
            END IF
        ON ACTION next
            CALL aimi112_fetch('N')
        ON ACTION previous
            CALL aimi112_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi112_u()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL aimi112_out()
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
            CALL aimi112_fetch('/')
        ON ACTION first
            CALL aimi112_fetch('F')
        ON ACTION last
            CALL aimi112_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #相關文件#
      ON ACTION related_document                          #No.FUN-680046
          LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_imz.imz01 IS NOT NULL THEN
                  LET g_doc.column1 = "imz01"
                  LET g_doc.value1 = g_imz.imz01
                  CALL cl_doc()
              END IF
           END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END MENU
    CLOSE aimi112_curs
END FUNCTION
 
 
FUNCTION aimi112_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_cont          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_imz08         LIKE imz_file.imz08,
        p_flag          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        p_flag1         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        p_imz55_fac     LIKE imz_file.imz55_fac,
        p_imz63_fac     LIKE imz_file.imz63_fac,
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_m             LIKE imz_file.imz59,     #TQC-6C0021
        l_m_t           LIKE imz_file.imz59      #TQC-6C0021
    DEFINE  l_imd10     LIKE imd_file.imd10      #TQC-AB0409
    DEFINE  l_case      STRING                  #FUN-BB0083 add
 
    DISPLAY BY NAME g_imz.imzuser,g_imz.imzgrup,
      g_imz.imzdate, g_imz.imzacti
    INPUT BY NAME
{
        imz01, imz02, imz03, imz08, imz25,
        imz55, imz55_fac, imz110, imz56, imz561,imz562,
        imz59, imz60, imz61, imz62, imz94, imz67, imz68, imz69    ,
        imz63 ,imz63_fac, imz108, imz64, imz641, imz65, imz66,
}
 
      g_imz.imz02,  g_imz.imz03,  g_imz.imz08,
      g_imz.imz25,  g_imz.imz70 , g_imz.imz55 , g_imz.imz55_fac,
      g_imz.imz110, g_imz.imz56,  g_imz.imz561,
      g_imz.imz562, g_imz.imz59, g_imz.imz60, g_imz.imz601,   #FUN-8C0086 add imz601
      g_imz.imz61,  g_imz.imz62, g_imz.imz571,g_imz.imz94,g_imz.imz153, #No:8474  #FUN-910053 add imz153
      g_imz.imz67 , g_imz.imz68 ,
      g_imz.imz69,  g_imz.imz63,  g_imz.imz63_fac,
      g_imz.imz108, g_imz.imz64, g_imz.imz641,
      g_imz.imz136, g_imz.imz137, #FUN-650004
#      g_imz.imz65 , g_imz.imz66 ,   #NO.MOD-640200
      g_imz.imzuser, g_imz.imzgrup,
      g_imz.imzmodu,g_imz.imzdate, g_imz.imzacti
      WITHOUT DEFAULTS

      #FUN-BB0083---add---str
      BEFORE INPUT 
         IF p_cmd = 'u' THEN
            LET g_imz55_t = g_imz.imz55  #TQC-C20183
            LET g_imz63_t = g_imz.imz63  #TQC-C20183
         END IF
         IF p_cmd = 'a' THEN
            LET g_imz55_t = NULL         #TQC-C20183
            LET g_imz63_t = NULL         #TQC-C20183
         END IF
      #FUN-BB0083---add---end
 
      AFTER FIELD imz110
         IF g_imz.imz110 not matches '[1234]' THEN
            LET g_imz.imz110 = g_imz_o.imz110
            DISPLAY BY NAME g_imz.imz110
            NEXT FIELD imz110
         END IF
 
      AFTER FIELD imz67            #採購員
         IF (g_imz_o.imz67 IS NULL ) OR (g_imz.imz67 != g_imz_o.imz67)
            OR (g_imz_o.imz67 IS NOT NULL AND g_imz.imz67 IS NULL) THEN
            CALL aimi112_peo(g_imz.imz67,'a')
            IF g_chr = 'E' THEN
               CALL cl_err(g_imz.imz67,'mfg1312',0)
               LET g_imz.imz67 = g_imz_o.imz67
               DISPLAY BY NAME g_imz.imz67
               NEXT FIELD imz67
            END IF
         END IF
         LET g_imz_o.imz67 = g_imz.imz67
 
      AFTER FIELD imz68          #需求時距
         IF g_imz.imz68 < 0 THEN
            CALL cl_err(g_imz.imz68,'mfg0013',0)
            LET g_imz.imz68 = g_imz_o.imz68
            DISPLAY BY NAME g_imz.imz68
            NEXT FIELD imz68
         END IF
         LET g_imz_o.imz68 = g_imz.imz68
 
      AFTER FIELD imz69          #計劃時距
         IF g_imz.imz69 < 0 THEN
            CALL cl_err(g_imz.imz69,'mfg0013',0)
            LET g_imz.imz69 = g_imz_o.imz69
            DISPLAY BY NAME g_imz.imz69
            NEXT FIELD imz69
         END IF
         LET g_imz_o.imz69 = g_imz.imz69
 
      AFTER FIELD imz59          #固定前置時間
         IF g_imz.imz59 < 0 THEN
            CALL cl_err(g_imz.imz59,'mfg0013',0)
            LET g_imz.imz59 = g_imz_o.imz59
            DISPLAY BY NAME g_imz.imz59
            NEXT FIELD imz59
         END IF
         LET g_imz_o.imz59 = g_imz.imz59
         #TQC-6C0021.....begin                                                                                                      
         LET l_m_t = g_imz.imz62                                                                      
         LET l_m = g_imz.imz59+g_imz.imz60+g_imz.imz61                                                                              
         IF g_imz_t.imz59 <> g_imz.imz59 THEN                                                                                       
            IF l_m > l_m_t THEN                                                                                                     
               LET g_imz.imz62 = l_m                                                                                                
               DISPLAY BY NAME g_imz.imz62                                                                                          
            END IF                                                                                                                  
            LET g_imz_t.imz59 = g_imz.imz59                                                                                         
         END IF                                                                                                                     
         #TQC-6C0021.....end 
 
      AFTER FIELD imz60          #變動前置時間
         IF g_imz.imz60 < 0 THEN
            CALL cl_err(g_imz.imz60,'mfg0013',0)
            LET g_imz.imz60 = g_imz_o.imz60
            DISPLAY BY NAME g_imz.imz60
            NEXT FIELD imz60
         END IF
         LET g_imz_o.imz60 = g_imz.imz60
         #TQC-6C0021.....begin                                                                                                      
         LET l_m_t = g_imz.imz62                                                                      
         LET l_m = g_imz.imz59+g_imz.imz60+g_imz.imz61                                                                              
         IF g_imz_t.imz60 <> g_imz.imz60 THEN                                                                                       
            IF l_m > l_m_t THEN                                                                                                     
               LET g_imz.imz62 = l_m                                                                                                
               DISPLAY BY NAME g_imz.imz62                                                                                          
            END IF                                                                                                                  
            LET g_imz_t.imz60 = g_imz.imz60                                                                                         
         END IF                                                                                                                     
         #TQC-6C0021.....end 
 
      #FUN-8C0086-begin-add
      AFTER FIELD imz601          #變動前置時間批量
        #str MOD-A50111 add
         IF cl_null(g_imz.imz601) THEN
            LET g_imz.imz601 = 1
            DISPLAY BY NAME g_imz.imz601
         END IF
        #end MOD-A50111 add
         IF g_imz.imz601 < 0 THEN
            CALL cl_err(g_imz.imz601,'mfg0013',0)
            LET g_imz.imz601 = g_imz_o.imz601
            DISPLAY BY NAME g_imz.imz601
            NEXT FIELD imz601
         END IF
      #FUN-8C0086-end-add
 
      AFTER FIELD imz61          #QC前置時間
         IF g_imz.imz61 < 0 THEN
            CALL cl_err(g_imz.imz61,'mfg0013',0)
            LET g_imz.imz61 = g_imz_o.imz61
            DISPLAY BY NAME g_imz.imz61
            NEXT FIELD imz61
         END IF
         LET g_imz_o.imz61 = g_imz.imz61
         #TQC-6C0021.....begin                                                                                                      
         LET l_m_t = g_imz.imz62                                                                      
         LET l_m = g_imz.imz59+g_imz.imz60+g_imz.imz61                                                                              
         IF g_imz_t.imz61 <> g_imz.imz61 THEN                                                                                       
            IF l_m > l_m_t THEN                                                                                                     
               LET g_imz.imz62 =l_m                                                                                                 
               DISPLAY BY NAME g_imz.imz62                                                                                          
            END IF                                                                                                                  
            LET g_imz_t.imz61 = g_imz.imz61                                                                                         
         END IF                                                                                                                     
         #TQC-6C0021.....end
 
      AFTER FIELD imz62          #累計前置時間
         IF g_imz.imz62 < 0 THEN
            CALL cl_err(g_imz.imz62,'mfg0013',0)
            LET g_imz.imz62 = g_imz_o.imz62
            DISPLAY BY NAME g_imz.imz62
            NEXT FIELD imz62
         END IF
         #TQC-6C0021.....begin
         IF g_imz.imz62 < l_m THEN
            CALL cl_err(g_imz.imz62,'aim-930',0)
            DISPLAY BY NAME g_imz.imz62
            NEXT FIELD imz62
         END IF
         #TQC-6C0021.....end 
         LET g_imz_o.imz62 = g_imz.imz62  
     #FUN-910053--BEGIN--
      AFTER FIELD imz153
         IF g_imz.imz153 < 0 THEN
            CALL cl_err('','aec-020',0)
            NEXT FIELD imz153
         END IF
     #FUN-910053--END--
 
      AFTER FIELD imz55           #生產單位
{
          IF  g_imz.imz55 IS NULL
             THEN LET g_imz.imz55 = g_imz_o.imz55
                  DISPLAY BY NAME g_imz.imz55
#                 NEXT FIELD imz55
          END IF
}
         IF g_imz.imz55 IS NOT NULL THEN
            IF (g_imz_o.imz55 IS NULL) OR (g_imz.imz55 != g_imz_o.imz55) THEN
               SELECT gfe01
                 FROM gfe_file WHERE gfe01=g_imz.imz55 AND
                                     gfeacti IN ('Y','y')
               IF SQLCA.sqlcode  THEN
#                 CALL cl_err(g_imz.imz55,'mfg1325',0) #No.FUN-660156
                  CALL cl_err3("sel","gfe_file",g_imz.imz55,"","mfg1325","",
                               "",1)   #No.FUN-660156
                  LET g_imz.imz55 = g_imz_o.imz55
                  DISPLAY BY NAME g_imz.imz55
                  NEXT FIELD imz55
               END IF
            END IF
         END IF
 
#--->default 轉換率 1992/10/20 by pin
         IF g_imz.imz25 IS NULL OR g_imz.imz55 IS NULL
            OR g_imz.imz25=' ' OR g_imz.imz55 =' ' THEN
            LET g_imz.imz55_fac = ''
            DISPLAY BY NAME g_imz.imz55_fac
         ELSE
            IF g_imz.imz25 = g_imz.imz55 THEN
               LET g_imz.imz55_fac = 1
               DISPLAY BY NAME g_imz.imz55_fac
            ELSE
               IF (g_imz_o.imz25 !=g_imz.imz25) OR
                  (g_imz_o.imz55 !=g_imz.imz55) OR
                  (g_imz_o.imz55 IS NULL) THEN
                  CALL s_umfchk('',g_imz.imz55,g_imz.imz25)
                  RETURNING p_flag,p_imz55_fac
                  IF NOT p_flag THEN
                     LET g_imz.imz55_fac=p_imz55_fac
                     DISPLAY  BY NAME g_imz.imz55_fac
                  ELSE
                     CALL cl_err(g_imz.imz55,'mfg1206',0)
                     NEXT FIELD imz55
                  END IF
               END IF
            END IF
         END IF
         LET g_imz_o.imz55 = g_imz.imz55
         LET g_imz_o.imz55_fac = g_imz.imz55_fac
         #FUN-BB0083---add---str
         LET l_case = ""  #FUN-C20048 add
         IF NOT cl_null(g_imz.imz56) AND g_imz.imz56<>0 THEN  #FUN-C20048 add
            IF NOT i112_imz56_check() THEN            
               LET l_case = "imz56"
            END IF
         END IF           #FUN-C20048 add
         IF NOT cl_null(g_imz.imz561) AND g_imz.imz561<>0 THEN #FUN-C20048 add
            IF NOT i112_imz561_check() THEN             
               LET l_case = "imz561"
            END IF 
         END IF           #FUN-C20048 add
         LET g_imz55_t = g_imz.imz55
         CASE l_case
            WHEN "imz56"
               NEXT FIELD imz56
            WHEN "imz561"
               NEXT FIELD imz561
            OTHERWISE EXIT CASE
         END CASE
         #FUN-BB0083---add---end
         
 
      AFTER FIELD imz55_fac
         IF g_imz.imz55 IS NOT NULL AND g_imz.imz25 IS NOT NULL
            AND g_imz.imz55 !=' ' AND g_imz.imz25 !=' ' THEN
            IF g_imz.imz55_fac IS NULL OR g_imz.imz55_fac = ' '
               OR g_imz.imz55_fac <= 0 THEN
               CALL cl_err(g_imz.imz55_fac,'mfg1322',0)
               LET  g_imz.imz55_fac = g_imz_o.imz55_fac
               DISPLAY BY NAME g_imz.imz55_fac
               NEXT FIELD imz55_fac
            END IF
         END IF
         IF g_imz.imz25 IS NULL OR g_imz.imz55 IS NULL THEN
            LET g_imz.imz55_fac=''
            DISPLAY g_imz.imz55 TO imz55
         END IF
         LET g_imz_o.imz55_fac = g_imz.imz55_fac
 
      BEFORE FIELD imz56
         IF g_imz.imz56 IS NULL THEN LET g_imz.imz56 = 1 END IF
 
      AFTER FIELD imz56          #生產單位批數
 #若輸入為零表示不作控制。
         #FUN-BB0083---add---str
         IF NOT i112_imz56_check() THEN 
            NEXT FIELD imz56
         END IF 
         #FUN-BB0083---add---end
         #FUN-BB0083---mark---str
         #IF g_imz.imz56 IS NULL OR g_imz.imz56 = ' '
         #   OR g_imz.imz56 < 0 THEN
         #   CALL cl_err(g_imz.imz56,'mfg1322',0)
         #   LET g_imz.imz56 = g_imz_o.imz56
         #   DISPLAY BY NAME g_imz.imz56
         #   NEXT FIELD imz56
         #END IF
         #LET g_imz_o.imz56 = g_imz.imz56
         #FUN-BB0083---mark---end
 
      BEFORE FIELD imz561
         IF g_imz.imz561 IS NULL THEN LET g_imz.imz561= 0 END IF
 
      AFTER FIELD imz561          #最少生產數量
#輸入之數量應為前述採購單位批量的倍數    MAY
         #FUN-BB0083---add---str
         IF NOT i112_imz561_check() THEN 
            NEXT FIELD imz561
         END IF 
         #FUN-BB0083---add---end
         #FUN-BB0083---mark---str
         #IF g_imz.imz56 >1 AND g_imz.imz561 >0 THEN
         #   LET l_cont = (g_imz.imz561 mod g_imz.imz56)
         #   IF l_cont > 0 THEN
         #      CALL cl_err(g_imz.imz561,'mfg5005',0)
         #      NEXT FIELD imz561
         #   END IF
         #END IF
 
         #IF g_imz.imz561 IS NULL OR g_imz.imz561 = ' '
         #   OR g_imz.imz561 < 0 THEN
         #   CALL cl_err(g_imz.imz561,'mfg1322',0)
         #   LET g_imz.imz561 = g_imz_o.imz561
         #   DISPLAY BY NAME g_imz.imz561
         #   NEXT FIELD imz561
         #END IF
         #LET g_imz_o.imz561 = g_imz.imz561
         #FUN-BB0083---mark---end
 
 
      AFTER FIELD imz562          #生產時損耗率
         IF g_imz.imz562 < 0 THEN
            CALL cl_err(g_imz.imz62,'mfg0013',0)
            LET g_imz.imz562 = g_imz_o.imz562
            DISPLAY BY NAME g_imz.imz562
            NEXT FIELD imz562
         END IF
         LET g_imz_o.imz562 = g_imz.imz562
 
 
      AFTER FIELD imz70  #消耗料件
         IF g_imz.imz70 IS NOT NULL THEN
            IF g_imz.imz70 NOT MATCHES "[YN]" THEN
               CALL cl_err(g_imz.imz70,'mfg1002',0)
               LET g_imz.imz70 = g_imz_o.imz70
               DISPLAY BY NAME g_imz.imz70
               NEXT FIELD imz70
            END IF
         END IF
         LET g_imz_o.imz70 = g_imz.imz70
 
#NO.MOD-640200 mark
#      AFTER FIELD imz65          #發料安全存量
#         IF g_imz.imz65 < 0 THEN
#            CALL cl_err(g_imz.imz65,'mfg1322',0)
#            LET g_imz.imz65 = g_imz_o.imz65
#            DISPLAY BY NAME g_imz.imz65
#            NEXT FIELD imz65
#         END IF
#         LET g_imz_o.imz65 = g_imz.imz65
#NO.MOD-640200 mark
 
#TQC-650003...............begin
#     AFTER FIELD imz66          #發料安全存量
#        IF g_imz.imz66 < 0 THEN
#           CALL cl_err(g_imz.imz66,'mfg0013',0)
#           LET g_imz.imz66 = g_imz_o.imz66
#           DISPLAY BY NAME g_imz.imz66
#           NEXT FIELD imz66
#        END IF
#        LET g_imz_o.imz66 = g_imz.imz66
#TQC-650003...............end
 
      AFTER FIELD imz63           #發料單位
         IF NOT cl_null(g_imz.imz63) AND
            ((g_imz_o.imz63 IS NULL) OR (g_imz.imz63 != g_imz_o.imz63)) THEN
            SELECT gfe01
              FROM gfe_file WHERE gfe01=g_imz.imz63 AND
                                  gfeacti IN ('Y','y')
            IF SQLCA.sqlcode  THEN
#              CALL cl_err(g_imz.imz63,'mfg1326',0) #No.FUN-660156
               CALL cl_err3("sel","gfe_file",g_imz.imz63,"","mfg1326","",
                            "",1)   #No.FUN-660156
               LET g_imz.imz63 = g_imz_o.imz63
               DISPLAY BY NAME g_imz.imz63
               NEXT FIELD imz63
            END IF
         END IF
#--->default 轉換率 1992/10/20 by pin
         IF g_imz.imz25 IS NULL OR g_imz.imz63 IS NULL
            OR g_imz.imz25=' ' OR g_imz.imz63 =' ' THEN
            LET g_imz.imz63_fac = ''
            DISPLAY BY NAME g_imz.imz63_fac
         ELSE
            IF g_imz.imz25 = g_imz.imz63 THEN
               LET g_imz.imz63_fac = 1
               DISPLAY BY NAME g_imz.imz63_fac
            ELSE
               IF (g_imz_o.imz25 !=g_imz.imz25) OR
                  (g_imz_o.imz63 !=g_imz.imz63) OR
                  (g_imz_o.imz63 IS NULL) THEN
                  CALL s_umfchk('',g_imz.imz63,g_imz.imz25)
                  RETURNING p_flag1,p_imz63_fac
                  IF NOT p_flag1 THEN
                     LET g_imz.imz63_fac=p_imz63_fac
                     DISPLAY  BY NAME g_imz.imz63_fac
                  ELSE
                     CALL cl_err(g_imz.imz63,'mfg1206',0)
                     NEXT FIELD imz63
                  END IF
               END IF
            END IF
         END IF
         LET g_imz_o.imz63 = g_imz.imz63
         LET g_imz_o.imz63_fac = g_imz.imz63_fac
         #FUN-BB0083---add---str
         IF NOT i112_imz64_check() THEN
            LET l_case = "imz64"
         END IF
         IF NOT i112_imz641_check() THEN
            LET l_case = "imz641"
         END IF
         LET g_imz63_t = g_imz.imz63
         CASE l_case
            WHEN "imz64"
               NEXT FIELD imz64
            WHEN "imz641"
               NEXT FIELD imz641 
            OTHERWISE EXIT CASE
         END CASE
         #FUN-BB0083---add---end
 
 
      AFTER FIELD imz63_fac
         IF g_imz.imz63 IS NOT NULL AND g_imz.imz25 IS NOT NULL
            AND g_imz.imz63 !=' ' AND g_imz.imz25 !=' ' THEN
            IF g_imz.imz63_fac IS NULL OR g_imz.imz63_fac = ' '
               OR g_imz.imz63_fac <= 0 THEN
               CALL cl_err(g_imz.imz63_fac,'mfg1322',0)
               LET g_imz.imz63_fac = g_imz_o.imz63_fac
               DISPLAY BY NAME g_imz.imz63_fac
               NEXT FIELD imz63_fac
            END IF
         END IF
         LET g_imz_o.imz63_fac = g_imz.imz63_fac
 
 
      AFTER FIELD imz64          #發料單位批數
         #FUN-BB0083---add---str
         IF NOT i112_imz64_check() THEN 
            NEXT FIELD imz64
         END IF 
         #FUN-BB0083---add---end
         #FUN-BB0083---mark---str
         #IF g_imz.imz64 < 0 THEN
         #   CALL cl_err(g_imz.imz64,'mfg1322',0)
         #   LET g_imz.imz64 = g_imz_o.imz64
         #   DISPLAY BY NAME g_imz.imz64
         #   NEXT FIELD imz64
         #END IF
         #LET g_imz_o.imz64 = g_imz.imz64
         #FUN-BB0083---mark---end 
 
      AFTER FIELD imz641          #最少發料數量
         #FUN-BB0083---add---str
         IF NOT i112_imz641_check() THEN 
            NEXT FIELD imz641
         END IF 
         #FUN-BB0083---add---end
         #FUN-BB0083---mark---str
         #IF g_imz.imz641 < 0 THEN
         #   CALL cl_err(g_imz.imz641,'mfg1322',0)
         #   LET g_imz.imz641 = g_imz_o.imz641
         #   DISPLAY BY NAME g_imz.imz641
         #   NEXT FIELD imz641
         #END IF
         #IF g_imz.imz64 >1 AND g_imz.imz641 >0 THEN
         #   LET l_cont = (g_imz.imz641 mod g_imz.imz64)
         #   IF l_cont > 0 THEN
         #      CALL cl_err(g_imz.imz641,'mfg9044',0)
         #      NEXT FIELD imz641
         #   END IF
         #END IF
         #LET g_imz_o.imz641 = g_imz.imz641
         #FUN-BB0083---mark---end 
          
      AFTER FIELD imz108
         IF NOT cl_null(g_imz.imz108) THEN
            IF g_imz.imz108 NOT MATCHES "[YN]" THEN NEXT FIELD imz108 END IF
         END IF
         LET g_imz_o.imz108 = g_imz.imz108
 
      AFTER FIELD imz571  #No.8474
           IF NOT cl_null(g_imz.imz571) THEN
              SELECT COUNT(*) INTO g_cnt FROM ecu_file WHERE ecu01=g_imz.imz571
                 AND ecuacti = 'Y'  #CHI-C90006
              IF g_cnt =0 THEN
                 CALL cl_err(g_imz.imz571,'aec-014',0)
                 LET g_imz.imz571 = g_imz_o.imz571
                 DISPLAY BY NAME g_imz.imz571
                 NEXT FIELD imz571
              END IF
           END IF
           LET g_imz_o.imz571 = g_imz.imz571
 
      AFTER FIELD imz94
         LET g_msg=NULL
         IF g_imz.imz94 IS NOT NULL THEN
            IF NOT cl_null(g_imz.imz571) THEN
               SELECT ecu03 INTO g_msg FROM ecu_file
                WHERE ecu01=g_imz.imz571 AND ecu02=g_imz.imz94
                  AND ecuacti = 'Y'  #CHI-C90006
            ELSE
               SELECT unique ecu03 INTO g_msg FROM ecu_file
                WHERE ecu02=g_imz.imz94
                  AND ecuacti = 'Y'  #CHI-C90006
            END IF
            IF SQLCA.SQLCODE THEN
#              CALL cl_err(g_imz.imz94,'aec-014',0) #No.FUN-660156
               CALL cl_err3("sel","ecu_file",g_imz.imz94,"","aec-014","",
                            "",1)   #No.FUN-660156
               LET g_imz.imz94 = g_imz_o.imz94
               DISPLAY BY NAME g_imz.imz94
               NEXT FIELD imz94
            END IF
         END IF
         DISPLAY g_msg TO ecu03
 
       #FUN-650004...............begin
       AFTER FIELD imz136
           IF g_imz.imz136 !=' ' AND g_imz.imz136 IS NOT NULL THEN
             #SELECT * FROM imd_file WHERE imd01=g_imz.imz136 AND imdacti='Y'          #TQC-AB0409
              SELECT imd10 INTO l_imd10 FROM imd_file WHERE imd01=g_imz.imz136 AND imdacti='Y'  #TQC-AB0409
              IF SQLCA.SQLCODE THEN          
                 CALL cl_err(g_imz.imz136,SQLCA.sqlcode,0)    #TQC-AB0409
              END IF     #TQC-AB0409
              IF l_imd10 <> 'W' THEN        #TQC-AB0409
#                CALL cl_err(g_imz.imz136,'mfg1100',0) #No.FUN-660156
                 CALL cl_err3("sel","imd_file",g_imz.imz136,"","mfg1100","",
                              "",1)   #No.FUN-660156
                 LET g_imz.imz136 = g_imz_o.imz136
                 DISPLAY BY NAME g_imz.imz136
                 NEXT FIELD imz136
              END IF
           ELSE
              LET g_imz.imz136=' '
           END IF
	IF NOT s_imechk(g_imz.imz136,g_imz.imz137) THEN NEXT FIELD imz137 END IF  #FUN-D40103 add
 
       AFTER FIELD imz137
	 #FUN-D40103--mark--str--
         #  IF g_imz.imz137 !=' ' AND g_imz.imz137 IS NOT NULL THEN
         #     SELECT * FROM ime_file WHERE ime01=g_imz.imz136
         #                              AND ime02=g_imz.imz137
         #     IF SQLCA.SQLCODE THEN
#        #        CALL cl_err(g_imz.imz137,'mfg1101',0) #No.FUN-660156
         #        CALL cl_err3("sel","ime_file",g_imz.imz137,"","mfg1101","",
         #                     "",1)   #No.FUN-660156
         #        LET g_imz.imz137 = g_imz_o.imz137
         #        DISPLAY BY NAME g_imz.imz137
         #        NEXT FIELD imz137
         #     END IF
         #  ELSE
         #     LET g_imz.imz137=' '
         #  END IF
       	#FUN-D40103--mark--end--
           #FUN-D40103--add--str--
           IF cl_null(g_imz.imz137) THEN LET g_imz.imz137 = ' ' END IF 
           IF NOT s_imechk(g_imz.imz136,g_imz.imz137) THEN 
              LET g_imz.imz137 = g_imz_o.imz137
              DISPLAY BY NAME g_imz.imz137
              NEXT FIELD imz137
           END IF 
           #FUN-D40103--add--end--
       #FUN-650004...............end
 
        ON ACTION mntn_unit
                    CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
                    CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv
                    CALL cl_cmdrun("aooi103 ")
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(imz67)                       #采購員(imz67)
#              CALL q_gen(9,30,g_imz.imz67) RETURNING g_imz.imz67
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz67 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_imz.imz67
               CALL cl_create_qry() RETURNING g_imz.imz67
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz67 )
               DISPLAY BY NAME g_imz.imz67
               CALL aimi112_peo(g_imz.imz67,'d')
               NEXT FIELD imz67
            WHEN INFIELD(imz55)                       # 生產單位 (imz55)
#              CALL q_gfe(10,3,g_imz.imz55) RETURNING g_imz.imz55
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz55 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_imz.imz55
               CALL cl_create_qry() RETURNING g_imz.imz55
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz55 )
               DISPLAY BY NAME g_imz.imz55
               NEXT FIELD imz55
            WHEN INFIELD(imz63)                       # 發料單位 (imz63)
#              CALL q_gfe(10,3,g_imz.imz63) RETURNING g_imz.imz63
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz63 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_imz.imz63
               CALL cl_create_qry() RETURNING g_imz.imz63
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz63 )
               DISPLAY BY NAME g_imz.imz63
               NEXT FIELD imz63
            WHEN INFIELD(imz571) #No:8487
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ecu1"
               LET g_qryparam.default1 = g_imz.imz571
               CALL cl_create_qry() RETURNING g_imz.imz571,g_imz.imz94
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz571 )
               DISPLAY BY NAME g_imz.imz571
               NEXT FIELD imz571
            WHEN INFIELD(imz94)
#              CALL q_ecu1(0,0,g_imz.imz571,g_imz.imz94)
#                   RETURNING g_imz.imz571,g_imz.imz94
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz571 )
#              CALL FGL_DIALOG_SETBUFFER( g_imz.imz94 )
               CALL cl_init_qry_var()
              #str MOD-A50113 mod
              #LET g_qryparam.form ="q_ecu102"
              #LET g_qryparam.default1 = g_imz.imz571
              #LET g_qryparam.arg1 = g_imz.imz571
              #LET g_qryparam.arg2 = g_imz.imz94
               IF NOT cl_null(g_imz.imz571) THEN
                  LET g_qryparam.form ="q_ecu101"
               ELSE
                  LET g_qryparam.form ="q_ecu1"
               END IF
               LET g_qryparam.default1 = g_imz.imz571
               LET g_qryparam.default2 = g_imz.imz94
               IF NOT cl_null(g_imz.imz571) THEN
                  LET g_qryparam.arg1 = g_imz.imz571
               END IF
              #end MOD-A50113 mod
               CALL cl_create_qry() RETURNING g_imz.imz571,g_imz.imz94
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz571 )
#               CALL FGL_DIALOG_SETBUFFER( g_imz.imz94 )
               DISPLAY BY NAME g_imz.imz571,g_imz.imz94
               NEXT FIELD imz94
            #FUN-650004...............begin
            WHEN INFIELD(imz136)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_imd"
               LET g_qryparam.default1 = g_imz.imz136 
             # LET g_qryparam.arg1     = 'SW'        #倉庫類別 #TQC-AB0409
               LET g_qryparam.arg1     = 'W'         #TQC-AB0409
               CALL cl_create_qry() RETURNING g_imz.imz136
               DISPLAY BY NAME g_imz.imz136
               NEXT FIELD imz136
            WHEN INFIELD(imz137)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ime"
               LET g_qryparam.default1 = g_imz.imz137 
               LET g_qryparam.arg1     = g_imz.imz136 #倉庫編號
               LET g_qryparam.arg2     = 'SW'         #倉庫類別
               CALL cl_create_qry() RETURNING g_imz.imz137
               DISPLAY BY NAME g_imz.imz137
               NEXT FIELD imz137
            #FUN-650004...............end
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
 
FUNCTION aimi112_peo(p_key,p_cmd)    #人員
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
FUNCTION aimi112_imz94(p_key,p_cmd)    #人員
    DEFINE p_key     LIKE gen_file.gen01
    DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    LET g_msg=NULL
    IF g_imz.imz94 IS NOT NULL THEN
       IF g_imz.imz571 IS NULL THEN LET g_imz.imz571=' ' END IF
       SELECT ecu03 INTO g_msg FROM ecu_file
                WHERE ecu01=g_imz.imz571 AND ecu02=g_imz.imz94
    END IF
    IF g_chr = ' ' OR p_cmd = 'd' THEN
      DISPLAY g_msg TO ecu03
    END IF
END FUNCTION
 
FUNCTION aimi112_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE  g_imz.* TO NULL                  #No.FUN-680046
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi112_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi112_count
    FETCH aimi112_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi112_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL
    ELSE
        CALL aimi112_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi112_fetch(p_flimz)
    DEFINE
        p_flimz          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimz
        WHEN 'N' FETCH NEXT     aimi112_curs INTO g_imz.imz01
        WHEN 'P' FETCH PREVIOUS aimi112_curs INTO g_imz.imz01
        WHEN 'F' FETCH FIRST    aimi112_curs INTO g_imz.imz01
        WHEN 'L' FETCH LAST     aimi112_curs INTO g_imz.imz01
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
            FETCH ABSOLUTE g_jump aimi112_curs INTO g_imz.imz01
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
       CALL cl_err3("sel","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"",
                    "",1)   #No.FUN-660156
    ELSE
        LET g_data_owner = g_imz.imzuser #FUN-4C0053
        LET g_data_group = g_imz.imzgrup #FUN-4C0053
        CALL aimi112_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi112_show()
    LET g_imz_t.* = g_imz.*
    DISPLAY BY NAME
        g_imz.imz01, g_imz.imz02, g_imz.imz03, g_imz.imz25,
        g_imz.imz08, g_imz.imz110,g_imz.imz67, g_imz.imz68, g_imz.imz69,
        g_imz.imz59, g_imz.imz60, g_imz.imz601, g_imz.imz61, g_imz.imz62, #FUN-8C0086 add imz601
        g_imz.imz55, g_imz.imz55_fac, g_imz.imz56, g_imz.imz561,
        #g_imz.imz562,g_imz.imz70, g_imz.imz65, g_imz.imz66,   #NO.MOD-640200
        g_imz.imz562,g_imz.imz70,g_imz.imz153,     #FUN-910053 add imz153
        g_imz.imz63, g_imz.imz63_fac, g_imz.imz64, g_imz.imz641,
        g_imz.imz136,g_imz.imz137, #FUN-650004
        g_imz.imz108,g_imz.imz571,g_imz.imz94, #No:8474
        g_imz.imzuser, g_imz.imzgrup, g_imz.imzmodu,
        g_imz.imzdate, g_imz.imzacti
        ,g_imz.imzoriu,g_imz.imzorig #TQC-B20025 
 
    CALL aimi112_peo(g_imz.imz67,'d')
    CALL aimi112_imz94(g_imz.imz94,'d')
    CALL cl_set_field_pic("","","","","",g_imz.imzacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi112_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_imz.imzacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imz.imz01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imz01_t = g_imz.imz01
    LET g_imz_o.* = g_imz.*
    BEGIN WORK
 
    OPEN aimi112_curl USING g_imz.imz01
    IF STATUS THEN
       CALL cl_err("OPEN aimi112_curl:", STATUS, 1)
       CLOSE aimi112_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi112_curl INTO g_imz.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imz.imzmodu = g_user                   #修改者
    LET g_imz.imzdate = g_today                  #修改日期
    CALL aimi112_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi112_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imz_t.imzdate=g_imz_o.imzdate        #TQC-C40219
            LET g_imz_t.imzmodu=g_imz_o.imzmodu        #TQC-C40219
            LET g_imz.*=g_imz_t.*     #TQC-C40155 #TQC-C40219
           #LET g_imz.*=g_imz_o.*     #TQC-C40155 #TQC-C40219
            CALL aimi112_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
#       LET g_imz.imz93[4,4] = 'Y'
        #FUN-650004...............begin
        IF cl_null(g_imz.imz136) THEN
           LET g_imz.imz136=' '
        END IF
        IF cl_null(g_imz.imz137) THEN
           LET g_imz.imz137=' '
        END IF
        #FUN-650004...............end
       #str MOD-A50111 add
        IF cl_null(g_imz.imz601) THEN
           LET g_imz.imz601 = 1
        END IF
       #end MOD-A50111 add
        UPDATE imz_file SET imz_file.* = g_imz.*    # 更新DB
            WHERE imz01 = g_imz01_t               # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imz_file",g_imz_t.imz01,"",SQLCA.sqlcode,"",
                        "",1)   #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi112_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi112_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_gen02         LIKE gen_file.gen02,    #No.FUN-840052        
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
    CALL cl_wait()
#   LET l_name = 'aimi112.out'
#   CALL cl_outnam('aimi112') RETURNING l_name  #No.FUN-840052
    CALL cl_del_data(l_table)                   #No.FUN-840052  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM imz_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE aimi112_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE aimi112_curo                         # CURSOR
        CURSOR FOR aimi112_p1
 
#   START REPORT aimi112_rep TO l_name          #No.FUN-840052
 
    FOREACH aimi112_curo INTO g_imz.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-840052---Begin 
#       OUTPUT TO REPORT aimi112_rep(g_imz.*)
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.imz67
        IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
        EXECUTE insert_prep USING g_imz.imzacti,  g_imz.imz01, g_imz.imz02, g_imz.imz55, g_imz.imz56, 
                                  g_imz.imz55_fac,g_imz.imz561,g_imz.imz67, g_imz.imz63, g_imz.imz64, 
                                  g_imz.imz63_fac,g_imz.imz641,l_gen02,     g_imz.imz68, g_imz.imz69
    END FOREACH
#   FINISH REPORT aimi112_rep
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,' imz01, imz02, imz08, imz25, imz03,imz70,
        imz55, imz55_fac, imz110, imz56, imz561,imz562,
        imz59, imz60, imz601, imz61, imz62, imz571,imz94, imz67, imz68, imz69 ,  #FUN-8C0086 add imz601
        imz63_fac, imz108, imz64, imz641, imz65, imz66,
        imz63 ,imz63_fac, imz108, imz64, imz641, imz136,imz137,
        imzuser, imzgrup, imzmodu, imzdate, imzacti')         
            RETURNING g_wc                                                                                                            
    END IF
   LET g_str = g_wc
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   
   CALL cl_prt_cs3('aimi112','aimi112',l_sql,g_str)
 
    CLOSE aimi112_curo
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-840052---End
END FUNCTION
 
#No.FUN-840052---Begin
#REPORT aimi112_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#        sr              RECORD LIKE imz_file.*,
#        l_gen02         LIKE gen_file.gen02,
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
#            PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#            PRINTX name=H3 g_x[44],g_x[45],g_x[46],g_x[47]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.imz67
#            IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
#            IF sr.imzacti = 'N' THEN
#                PRINTX name=D1 COLUMN g_c[31],'*';
#            ELSE
#                PRINTX name=D1 COLUMN g_c[31],' ';
#            END IF
#            PRINTX name=D1 COLUMN g_c[32],sr.imz01,
#                           COLUMN g_c[33],sr.imz02,
#                           COLUMN g_c[34],sr.imz55,
#                           COLUMN g_c[35],cl_numfor(sr.imz56,35,3),
#                           COLUMN g_c[36],cl_numfor(sr.imz55_fac,36,3),
#                           COLUMN g_c[37],cl_numfor(g_imz.imz561,37,3)
#            PRINTX name=D2 COLUMN g_c[38],' ',
#                           COLUMN g_c[39],sr.imz67,
#                           COLUMN g_c[40],sr.imz63,
#                           COLUMN g_c[41],cl_numfor(sr.imz64,41,3),
#                           COLUMN g_c[42],cl_numfor(g_imz.imz63_fac,42,3),
#                           COLUMN g_c[43],cl_numfor(sr.imz641,43,3)
#            PRINTX name=D3 COLUMN g_c[44],' ',
#                           COLUMN g_c[45],l_gen02,
#                           COLUMN g_c[46],cl_numfor(sr.imz68,46,3),
#                           COLUMN g_c[47],cl_numfor(sr.imz69,47,3)
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

#FUN-BB0083---add---str
FUNCTION i112_imz56_check()
#imz56 的單位 imz55   
   IF NOT cl_null(g_imz.imz55) AND NOT cl_null(g_imz.imz56) THEN
      IF cl_null(g_imz_t.imz56) OR cl_null(g_imz55_t) OR g_imz_t.imz56 != g_imz.imz56 OR g_imz55_t != g_imz.imz55 THEN 
         LET g_imz.imz56=s_digqty(g_imz.imz56,g_imz.imz55)
         DISPLAY BY NAME g_imz.imz56  
      END IF  
   END IF
   IF g_imz.imz56 IS NULL OR g_imz.imz56 = ' '
      OR g_imz.imz56 < 0 THEN
      CALL cl_err(g_imz.imz56,'mfg1322',0)
      LET g_imz.imz56 = g_imz_o.imz56
      DISPLAY BY NAME g_imz.imz56
      RETURN FALSE
   END IF
   LET g_imz_o.imz56 = g_imz.imz56

RETURN TRUE 
END FUNCTION

FUNCTION i112_imz561_check()
#imz561 的單位 imz55
DEFINE l_cont          LIKE type_file.num5
   IF NOT cl_null(g_imz.imz55) AND NOT cl_null(g_imz.imz561) THEN
      IF cl_null(g_imz_t.imz561) OR cl_null(g_imz55_t) OR g_imz_t.imz561 != g_imz.imz561 OR g_imz55_t != g_imz.imz55 THEN 
         LET g_imz.imz561=s_digqty(g_imz.imz561,g_imz.imz55)
         DISPLAY BY NAME g_imz.imz561  
      END IF  
   END IF
   IF g_imz.imz56 >1 AND g_imz.imz561 >0 THEN
      LET l_cont = (g_imz.imz561 mod g_imz.imz56)
      IF l_cont > 0 THEN
         CALL cl_err(g_imz.imz561,'mfg5005',0)
         RETURN FALSE 
      END IF
   END IF

   IF g_imz.imz561 IS NULL OR g_imz.imz561 = ' '
      OR g_imz.imz561 < 0 THEN
      CALL cl_err(g_imz.imz561,'mfg1322',0)
      LET g_imz.imz561 = g_imz_o.imz561
      DISPLAY BY NAME g_imz.imz561
      RETURN FALSE
   END IF
   LET g_imz_o.imz561 = g_imz.imz561
 
RETURN TRUE
END FUNCTION

FUNCTION i112_imz64_check()
#imz64 的單位 imz63
   IF NOT cl_null(g_imz.imz63) AND NOT cl_null(g_imz.imz64) THEN
      IF cl_null(g_imz_t.imz64) OR cl_null(g_imz63_t) OR g_imz_t.imz64 != g_imz.imz64 OR g_imz63_t != g_imz.imz63 THEN 
         LET g_imz.imz64=s_digqty(g_imz.imz64,g_imz.imz63)
         DISPLAY BY NAME g_imz.imz64  
      END IF  
   END IF
   IF g_imz.imz64 < 0 THEN
      CALL cl_err(g_imz.imz64,'mfg1322',0)
      LET g_imz.imz64 = g_imz_o.imz64
      DISPLAY BY NAME g_imz.imz64
      RETURN FALSE 
   END IF
   LET g_imz_o.imz64 = g_imz.imz64
RETURN TRUE 
END FUNCTION

FUNCTION i112_imz641_check()
#imz641 的單位 imz63
DEFINE l_cont          LIKE type_file.num5
   IF NOT cl_null(g_imz.imz63) AND NOT cl_null(g_imz.imz641) THEN
      IF cl_null(g_imz_t.imz641) OR cl_null(g_imz63_t) OR g_imz_t.imz641 != g_imz.imz641 OR g_imz63_t != g_imz.imz63 THEN 
         LET g_imz.imz641=s_digqty(g_imz.imz641,g_imz.imz63)
         DISPLAY BY NAME g_imz.imz641  
      END IF  
   END IF
   IF g_imz.imz641 < 0 THEN
      CALL cl_err(g_imz.imz641,'mfg1322',0)
      LET g_imz.imz641 = g_imz_o.imz641
      DISPLAY BY NAME g_imz.imz641
      RETURN FALSE 
   END IF
   IF g_imz.imz64 >1 AND g_imz.imz641 >0 THEN
      LET l_cont = (g_imz.imz641 mod g_imz.imz64)
      IF l_cont > 0 THEN
         CALL cl_err(g_imz.imz641,'mfg9044',0)
         RETURN FALSE 
      END IF
   END IF
   LET g_imz_o.imz641 = g_imz.imz641
RETURN TRUE 
END FUNCTION
#FUN-BB0083---add---end

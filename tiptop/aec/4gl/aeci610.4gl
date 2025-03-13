# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci610.4gl
# Descriptions...: 製程資料維護作業
# Date & Author..: 91/11/01 By Nora
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置調整
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0065 06/10/27 By Ray  產品制程修改工作站時應同時更改sgc_file中的sgc04
# Modify.........: No.TQC-6C0177 06/12/28 By Ray 報表及報錯問題
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740159 07/04/22 By kim 製程資料維護後機器編號會預設為 0,且機器編號也無0的編號
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/12 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.CHI-770034 07/07/31 By kim 在Unicode版新增會當
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-810017 08/01/22 By jan 新增服飾作業
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-930075 09/03/05 By Pengu 無法修改ecb16/ecb18/ecb19/ecb20/ecb21等欄位
# Modify.........: No.TQC-930162 09/05/06 By destiny 無效資料可以刪除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60028 10/06/08 By lilingyu 平行工藝 
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-B10097 11/01/12 By Carrier ecb66赋DEFULAT值'N'
# Modify.........: No.TQC-B10097 11/01/12 By Carrier ecb66赋DEFULAT值'N'
# Modify.........: No.TQC-B10214 11/01/20 By destiny orig,oriu新增时未付值 
# Modify.........: No.TQC-B30168 11/03/26 By destiny 输入时不能录入来源码为P的料件 
# Modify.........: No.TQC-B30174 11/03/29 By destiny 复制时ecu014的值没更新  
# Modify.........: No.MOD-B50019 11/05/04 By sabrina ecb24不應強制要輸入
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:FUN-BB0086 12/01/14 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-C40008 13/01/10 By Nina 只要程式有UPDATE ecu_file 的任何一個欄位時,多加ecudate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ecb   RECORD LIKE ecb_file.*,
    g_ecu   RECORD LIKE ecu_file.*,
    g_d01   LIKE type_file.chr9,       # Prog. Version..: '5.30.06-13.03.12(09), #成本計算基准之中文description   #TQC-B90211
    g_ecb_t RECORD LIKE ecb_file.*,
    g_ecb_o RECORD LIKE ecb_file.*,
    g_ecb01_t LIKE ecb_file.ecb01,
    g_ecb012_t LIKE ecb_file.ecb012,         #FUN-A60028 add
    g_ecb02_t LIKE ecb_file.ecb02,
    g_ecb03_t LIKE ecb_file.ecb03,
   #g_wc,g_sql          VARCHAR(300),             #TQC-630166  
    g_wc,g_sql          STRING,                #TQC-630166  
    g_update        LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1),  #是否須更新[失效日期]欄位
    g_ecb01         LIKE ecb_file.ecb01,  #欲沿用之料件編號
    g_ecb012        LIKE ecb_file.ecb012,       #FUN-A60028 
    g_ecb02         LIKE ecb_file.ecb02,  #欲沿用之製程編號
    l_cmd           LIKE type_file.chr1000       #No.FUN-680073
 
DEFINE   g_row_count           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump                LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_no_ask             LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE   g_forupd_sql          STRING                       #SELECT ... FOR UPDATE SQL 
DEFINE   g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
#No.FUN-760085---Begin                                                          
DEFINE   l_table         STRING,                                                   
         g_str           STRING,                                                   
         l_sql           STRING                                                    
#No.FUN-760085---End         
DEFINE g_argv1     LIKE ecb_file.ecb02     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE g_ecu014         LIKE ecu_file.ecu014       #FUN-A60028 
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0100
    DEFINE p_Row,p_col     LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
#No.FUN-760085---Begin
   LET g_sql = "ecb01.ecb_file.ecb01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ecb02.ecb_file.ecb02,",
               "ecb03.ecb_file.ecb03,",
               "ecb06.ecb_file.ecb06,",
               "ecb15.ecb_file.ecb15,",
               "ecb16.ecb_file.ecb16,",
               "ecbacti.ecb_file.ecbacti,"
    
   LET l_table = cl_prt_temptable('aeci610',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?) "                               
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
#No.FUN-760085---End   
    INITIALIZE g_ecb.* TO NULL
    INITIALIZE g_ecb_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ecb_file WHERE ecb01 = ? AND ecb02 = ? AND ecb03 = ? AND ecb012 = ? FOR UPDATE "
                                                                                                  #FUN-A60028 add ecb012
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i610_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW aeci610_w AT p_row,p_col
        WITH FORM "aec/42f/aeci610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    
   #No.FUN-810017--Begin                                                                                                             
       CALL cl_set_comp_visible("ecbslk03",FALSE)                                                              
   #No.FUN-810017--End
 
#FUN-A60028 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("ecb012,ecu014",TRUE)
   ELSE
      CALL cl_set_comp_visible("ecb012,ecu014",FALSE)
   END IF 	   
#FUN-A60028 --end-- 
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i610_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i610_a()
            END IF
         OTHERWISE        
            CALL i610_q() 
      END CASE
   END IF
   #--
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i610_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i610_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i610_cs()
    CLEAR FORM
   INITIALIZE g_ecb.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" ecb02='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ecb01,ecb03,ecb06,ecb36,ecb07,
        ecb11,ecb13,ecb17,ecb26,ecb27,ecb28,ecb23,ecb25,
        ecb02,ecb012,ecb37,ecb08,ecb10,ecb12,ecb52,ecb14,ecb53,ecb15,    #FUN-A60028 add ecb012,ecb52,ecb53
#       ecb16,ecb18,ecb19,ecb20,ecb21,ecb22,ecb24,            #No.FUN-810017
        ecb16,
        ecb18,ecb19,ecb20,ecb21,ecb22,ecb24,   
        ecbuser,ecbgrup,ecbmodu,ecbdate,ecbacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ecb01) #料件編號
#                 CALL q_ima1(0,0,'MPXKUVRS',g_ecb.ecb01) RETURNING g_ecb.ecb01
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_ima1"
               #   LET g_qryparam.state = "c"
               #   LET g_qryparam.default1 = g_ecb.ecb01
               #   LET g_qryparam.where = "ima08 IN ('M','P','X','K','U','V','R','S')"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima1","ima08 IN ('M','P','X','K','U','V','R','S')",g_ecb.ecb01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO ecb01
                  NEXT FIELD ecb01
#FUN-A60028 --begin--
               WHEN INFIELD(ecb012)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecb012_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ecb.ecb012                 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ecb012
                  NEXT FIELD ecb012
#FUN-A60028 --end--                  
               WHEN INFIELD(ecb03) #編號
#                 CALL q_ecb1(0,0,g_ecb.ecb01) RETURNING g_ecb.ecb03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecb1"
                  LET g_qryparam.state = "c"
                  IF g_ecb.ecb01 IS NOT NULL THEN
                     LET g_qryparam.where = " ecb01= '",g_ecb.ecb01,"'"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ecb03
                  NEXT FIELD ecb03
               WHEN INFIELD(ecb06) #作業編號
#                 CALL q_ecd(0,0,g_ecb.ecb06)
#                      RETURNING g_ecb.ecb06
                 CALL q_ecd(TRUE,TRUE,g_ecb.ecb06) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ecb06
                 NEXT FIELD ecb06
               WHEN INFIELD(ecb07) #機器編號
#                 CALL q_eci(0,0,g_ecb.ecb07) RETURNING g_ecb.ecb07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_eci"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ecb.ecb07
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ecb07
                  NEXT FIELD ecb07
               WHEN INFIELD(ecb08) #工作區編號
#                 CALL q_eca(0,0,g_ecb.ecb08) RETURNING g_ecb.ecb08
                 CALL q_eca(TRUE,TRUE,g_ecb.ecb08) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ecb08
                 NEXT FIELD ecb08
               WHEN INFIELD(ecb24) #廠外加工料件
#                 CALL q_ima1(0,0,'S',g_ecb.ecb24) RETURNING g_ecb.ecb24
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima1"
                #  LET g_qryparam.state = "c"
                #  LET g_qryparam.default1 = g_ecb.ecb24
                #  LET g_qryparam.where = "ima08 IN ('S')"
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima1","ima08 IN ('S')",g_ecb.ecb24,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO ecb24
                  NEXT FIELD ecb24
               WHEN INFIELD(ecb25) #廠外加工廠商
#                 CALL q_pmc(0,0,g_ecb.ecb25) RETURNING g_ecb.ecb25
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ecb.ecb25
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ecb25
                  NEXT FIELD ecb25
               OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          EXIT CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
   END IF  #FUN-7C0050
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ecbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecbuser', 'ecbgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ecb01,ecb02,", # 組合出 SQL 指令     
              "ecb03,ecb012 FROM ecb_file ",                        #FUN-A60028 add ecb012
              " WHERE ",g_wc CLIPPED, " ORDER BY ecb01,ecb02,ecb03,ecb012 "   #FUN-A60028 add ecb012
    PREPARE i610_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i610_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i610_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ecb_file WHERE ",g_wc CLIPPED
    PREPARE i610_precount FROM g_sql
    DECLARE i610_count CURSOR FOR i610_precount
END FUNCTION
 
FUNCTION i610_menu()
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i610_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i610_q()
            END IF
        ON ACTION next
            CALL i610_fetch('N')
        ON ACTION previous
            CALL i610_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i610_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i610_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i610_r()
            END IF
       #ON ACTION 預設資料
       #    IF cl_chk_act_auth() THEN
       #       CALL i611(0,0,g_ecb.*)
       #    END IF
        ON ACTION description
           LET g_action_choice="description"
           IF cl_chk_act_auth() THEN
              LET l_cmd = 'aeci612'," '",g_ecb.ecb01 CLIPPED,"'",
                                      " '",g_ecb.ecb02 CLIPPED,"'",
                                      " '",g_ecb.ecb03 CLIPPED,"'",
                                      " '",g_ecb.ecb012 CLIPPED,"'"    #FUN-A60028 add
               CALL cl_cmdrun(l_cmd)
             END IF
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL i610_copy()
           END IF
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth()
              THEN CALL i610_out()
             END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
           LET g_action_choice = "exit"
             EXIT MENU
  
        ON ACTION jump
           CALL i610_fetch('/')
        ON ACTION first
            CALL i610_fetch('F')
        ON ACTION last
            CALL i610_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
   
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0039-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_ecb.ecb01 IS NOT NULL THEN            
                  LET g_doc.column1 = "ecb01"               
                  LET g_doc.column2 = "ecb02"     
                  LET g_doc.column3 = "ecb03"          
                  LET g_doc.column4 = "ecb012"    #FUN-A60028 add
                  LET g_doc.value1 = g_ecb.ecb01            
                  LET g_doc.value2 = g_ecb.ecb02   
                  LET g_doc.value3 = g_ecb.ecb03         
                  LET g_doc.value4 = g_ecb.ecb012     #FUN-A60028 add
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0039-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i610_cs
END FUNCTION
 
 
FUNCTION i610_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ecb.* LIKE ecb_file.*
    LET g_ecb01_t = ' '
    LET g_ecb012_t = ' '   #FUN-A60028 add
    LET g_ecb02_t = NULL
    LET g_ecb03_t = NULL
    LET g_ecb_t.*=g_ecb.*
    LET g_ecb_o.*=g_ecb.*
    LET g_ecb.ecb01 = g_ecb01        #沿用上一筆料件編號
    LET g_ecb.ecb012= g_ecb012       #FUN-A60028 
    LET g_ecb.ecb02 = g_ecb02        #沿用上一筆之製程編號
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ecb.ecbacti ='Y'                   #有效的資料
        LET g_ecb.ecbuser = g_user
        LET g_ecb.ecboriu = g_user #FUN-980030
        LET g_ecb.ecborig = g_grup #FUN-980030
        LET g_ecb.ecbgrup = g_grup               #使用者所屬群
        LET g_ecb.ecbdate = g_today
        LET g_ecb.ecb01=' '
        LET g_ecb.ecb012= ' '   #FUN-A60028 add
        LET g_ecb.ecb52 = 0    #FUN-A60028 
        LET g_ecb.ecb53 = 1    #FUN-A60028 
        LET g_ecb.ecb02=1
        LET g_ecb.ecb09='Y'
        LET g_ecb.ecb13='1'
        CALL i610_i("a")   # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ecb.ecb01 IS NULL OR g_ecb.ecb012 IS NULL THEN  # KEY 不可空白   #FUN-A60028 add g_ecb.ecb012
            CONTINUE WHILE
        END IF
        #備份上一筆之料件編號及製程編號
        LET g_ecb01 = g_ecb.ecb01
        LET g_ecb012= g_ecb.ecb012   #FUN-A60028 
        LET g_ecb02 = g_ecb.ecb02
        #預設資料Default 為標準資料
        LET g_ecb.ecb30 = g_ecb.ecb18
        LET g_ecb.ecb31 = g_ecb.ecb19
        LET g_ecb.ecb32 = g_ecb.ecb20
        LET g_ecb.ecb33 = g_ecb.ecb21
        LET g_ecb.ecb34 = g_ecb.ecb22
        LET g_ecb.ecb35 = g_ecb.ecb23
        IF cl_null(g_ecb.ecb01) THEN LET g_ecb.ecb01=' ' END IF
        IF cl_null(g_ecb.ecb012) THEN LET g_ecb.ecb012 = ' ' END IF    #FUN-A60028 
        IF cl_null(g_ecb.ecb66) THEN LET g_ecb.ecb66 = 'N' END IF   #No.TQC-B10097
        INSERT INTO ecb_file VALUES(g_ecb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,
                      '+',g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED   #FUN-A60028 add g_ecb.ecb012
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("ins","ecb_file",g_msg,"",SQLCA.sqlcode,"","",1) #FUN-660091
            CONTINUE WHILE
        ELSE
            #是否進入預設資料維護作業
            #CALL cl_getmsg('mfg4018',g_lang) RETURNING g_msg
            #IF cl_prompt(16,9,g_msg) THEN
            #   CALL i611(0,0,g_ecb.*)
            #END IF
            LET g_ecb_t.* = g_ecb.*                # 保存上筆資料
            LET g_ecb_o.* = g_ecb.*                # 保存上筆資料
            SELECT ecb01,ecb02,ecb03,ecb012             #FUN-A60028 add ecb012
              INTO g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012  #FUN-A60028 add g_ecb.ecb012
              FROM ecb_file
             WHERE ecb01 = g_ecb.ecb01 
               AND ecb02 = g_ecb.ecb02 
               AND ecb03 = g_ecb.ecb03
               AND ecb012= g_ecb.ecb012    #FUN-A60028 add
            CALL i610_chk_ecu()
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i610_i(p_cmd)
    DEFINE
        l_eca04         LIKE eca_file.eca04, #the SQLCA.sqlcode of work area
        l_eca06         LIKE eca_file.eca06, #工作站產能型態
        l_ima08         LIKE ima_file.ima08, #source code
        l_dir           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1),  #記錄游標的方向,應至[作業編號]或[失效日期]欄位
        l_dir1          LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1),  #記錄游標的方向
        l_sw            LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1),  #記錄是否有必須輸入之欄位尚未輸入
        l_update        LIKE type_file.chr1,         #No.FUN-680073 HAR(1),  #可否更改key 值
        p_cmd           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_msg           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(40)
        l_n             LIKE type_file.num5          #No.FUN-680073 SMALLINT
 DEFINE l_cnt           LIKE type_file.num5          #FUN-A60028 
 DEFINE l_ecu014        LIKE ecu_file.ecu014         #FUN-A60028
 
    IF p_cmd = 'u' THEN  #若為更改狀況時,須先select 其工作區型態及產能型態
       SELECT eca04,eca06 INTO l_eca04,l_eca06 FROM eca_file
              WHERE eca01 = g_ecb.ecb08 AND ecaacti = 'Y'
    END IF
    LET g_update = 'N'
    #若為最後規格組件製程,不能更改KEY 值
    SELECT ima08 INTO l_ima08 FROM ima_file
     WHERE ima01 = g_ecb.ecb01
    IF l_ima08 = 'T' THEN
       LET l_update = 'N'
    ELSE
       LET l_update = 'Y'
    END IF
    DISPLAY BY NAME g_ecb.ecbuser,g_ecb.ecbgrup,g_ecb.ecbdate,g_ecb.ecboriu,g_ecb.ecborig, #TQC-B10214
                    g_ecb.ecbacti,
                    g_ecb.ecb52,g_ecb.ecb53      #FUN-A60028 add 

#FUN-A60028 --begin--
    INPUT g_ecb.ecb01,g_ecb.ecb03,g_ecb.ecb06,g_ecb.ecb36,g_ecb.ecb07,g_ecb.ecb11,
          g_ecb.ecb13,g_ecb.ecb17,g_ecb.ecb26,g_ecb.ecb27,g_ecb.ecb28,g_ecb.ecb23,
          g_ecb.ecb25,g_ecb.ecb02,g_ecb.ecb012,g_ecu014,  g_ecb.ecb37,g_ecb.ecb08,
          g_ecb.ecb10,g_ecb.ecb12,g_ecb.ecb52,g_ecb.ecb14,g_ecb.ecb53,g_ecb.ecb15,
          g_ecb.ecb16,g_ecb.ecb18,g_ecb.ecb19,g_ecb.ecb20,g_ecb.ecb21,g_ecb.ecb22,
          g_ecb.ecb24
                    WITHOUT DEFAULTS
    FROM  ecb01,ecb03,ecb06,ecb36,ecb07,ecb11,
          ecb13,ecb17,ecb26,ecb27,ecb28,ecb23,
          ecb25,ecb02,ecb012,ecu014,ecb37,ecb08,
          ecb10,ecb12,ecb52,ecb14,ecb53,ecb15,ecb16,
          ecb18,ecb19,ecb20,ecb21,ecb22,ecb24                          

#FUN-A60028 --end--
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i610_set_entry(p_cmd)
           CALL i610_set_no_entry(p_cmd)
#FUN-A60028 --begin--           
           CALL cl_set_comp_entry("ecu014",TRUE)  
           SELECT COUNT(*),ecu014 INTO l_cnt,l_ecu014 FROM ecu_file
            WHERE ecu01  = g_ecb.ecb01
              AND ecu02  = g_ecb.ecb02
              AND ecu012 = g_ecb.ecb012
              AND ecuacti = 'Y'  #CHI-C90006
              GROUP BY ecu014
           IF l_cnt > 0 THEN 
              CALL cl_set_comp_entry("ecu014",FALSE)
              DISPLAY l_ecu014 TO ecu014
           ELSE
         	    CALL cl_set_comp_entry("ecu014",TRUE)   
           END IF     
#FUN-A60028 --end--                    
           LET g_before_input_done = TRUE
 
        BEFORE FIELD ecb01
            IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
               CALL cl_getmsg('mfg4088',g_lang) RETURNING l_msg
               MESSAGE l_msg
            ELSE
               CALL cl_getmsg('mfg4088',g_lang) RETURNING g_msg
              #CHI-770034...................begin
              #LET l_msg = g_msg[1,36]
              #DISPLAY  l_msg AT 1,42
              #LET l_msg = g_msg[37,72]
              #DISPLAY  l_msg  AT 2,42
               DISPLAY g_msg
              #CHI-770034...................end
            END IF
	          IF g_sma.sma60 = 'Y'		# 若須分段輸入
	             THEN CALL s_inp5(5,11,g_ecb.ecb01) RETURNING g_ecb.ecb01
	             DISPLAY BY NAME g_ecb.ecb01
    	      END IF
            IF cl_null(g_ecb.ecb01) THEN LET g_ecb.ecb01=' ' END IF
 
        AFTER FIELD ecb01
            IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
               MESSAGE ''
            ELSE
               LET g_msg = '  '
              #CHI-770034...................begin
              #DISPLAY g_msg AT 1,42
              #DISPLAY g_msg AT 2,42
              #CHI-770034...................end
            END IF
            IF cl_null(g_ecb.ecb01) THEN LET g_ecb.ecb01=' ' END IF
 
            IF g_ecb.ecb01<>' '  THEN
              #FUN-AA0059 ---------------add start-------------------
               IF NOT s_chk_item_no(g_ecb.ecb01,'') THEN
                  CALL  cl_err('',g_errno,1)
                  LET g_ecb.ecb01 = g_ecb_o.ecb01
                  DISPLAY BY NAME g_ecb.ecb01
                  NEXT FIELD ecb01
               END IF 
              #FUN-AA0059 --------------add end--------------------  
               SELECT ima08 INTO l_ima08 FROM ima_file
                WHERE ima01 = g_ecb.ecb01
              #IF SQLCA.sqlcode OR l_ima08 MATCHES'[CDAUZ]' THEN    #TQC-B30168
               IF SQLCA.sqlcode OR l_ima08 MATCHES'[CDAUZP]' THEN   #TQC-B30168
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_ecb.ecb01,'mfg1314',0) #No.FUN-660091
                     CALL cl_err3("sel","ima_file",g_ecb.ecb01,"","mfg1314","","",1) #FUN-660091
                  END IF
                 #IF l_ima08 MATCHES'[CDAUZ]' THEN                  #TQC-B30168   
                  IF l_ima08 MATCHES'[CDAUZP]' THEN                 #TQC-B30168   
#                    CALL cl_err(g_ecb.ecb01,'mfg4007',0) #No.FUN-660091
                     CALL cl_err3("sel","ima_file",g_ecb.ecb01,"","mfg4007","","",1) #FUN-660091
                  END IF
                  LET g_ecb.ecb01 = g_ecb_o.ecb01
                  DISPLAY BY NAME g_ecb.ecb01
                  NEXT FIELD ecb01
               END IF
            END IF
            LET g_ecb_o.ecb01 = g_ecb.ecb01
 
        AFTER FIELD ecb02
            IF g_ecb.ecb02 IS NULL THEN
               LET g_ecb.ecb02 = 1
               DISPLAY BY NAME g_ecb.ecb02
            ELSE
               IF g_ecb.ecb02 < 0 THEN
                  CALL cl_err(g_ecb.ecb02,'mfg4012',0)
                  LET g_ecb.ecb02 = g_ecb_o.ecb02
                  DISPLAY BY NAME g_ecb.ecb02
                  NEXT FIELD ecb02
               END IF
            END IF
            LET g_ecb_o.ecb02 = g_ecb.ecb02

#FUN-A60028 --begin--
       AFTER FIELD ecb012
         IF cl_null(g_ecb.ecb012) THEN
            LET g_ecb.ecb012 = ' ' 
         END IF 
         LET l_cnt = 0 
         LET l_ecu014 = NULL
         SELECT COUNT(*),ecu014 INTO l_cnt,l_ecu014 FROM ecu_file
          WHERE ecu01  = g_ecb.ecb01
            AND ecu02  = g_ecb.ecb02
            AND ecu012 = g_ecb.ecb012
            AND ecuacti = 'Y'  #CHI-C90006
            GROUP BY ecu014
         IF l_cnt > 0 THEN 
            CALL cl_set_comp_entry("ecu014",FALSE)
            DISPLAY l_ecu014 TO ecu014
         ELSE
         	  CALL cl_set_comp_entry("ecu014",TRUE)   
         END IF             
#FUN-A60028 --end--
 
        AFTER FIELD ecb03
          IF NOT cl_null(g_ecb.ecb03) THEN
            IF g_ecb.ecb03 < 0 THEN
               CALL cl_err(g_ecb.ecb03,'mfg4012',0)
               LET g_ecb.ecb03 = g_ecb_o.ecb03
               DISPLAY BY NAME g_ecb.ecb03
               NEXT FIELD ecb03
            END IF
            LET g_ecb_o.ecb03 = g_ecb.ecb03
            #檢查資料重複否
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_ecb.ecb01 != g_ecb01_t OR
                   g_ecb.ecb02 != g_ecb02_t OR
                   g_ecb.ecb03 != g_ecb03_t OR g_ecb.ecb012 != g_ecb012_t)) THEN   #FUN-A60028 add ecb012
              SELECT count(*) INTO l_n FROM ecb_file
               WHERE ecb01 = g_ecb.ecb01 
                 AND ecb02 = g_ecb.ecb02
                 AND ecb03 = g_ecb.ecb03
                 AND ecb012= g_ecb.ecb012     #FUN-A60028 add
               IF l_n > 0 THEN                  # Duplicated
                LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,
                    '+',g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED     #FUN-A60028 add g_ecb.ecb012
                      CALL cl_err(g_msg,-239,0)
                      LET g_ecb.ecb01 = g_ecb01_t
                      LET g_ecb.ecb02 = g_ecb02_t
                      LET g_ecb.ecb03 = g_ecb03_t
                      LET g_ecb.ecb012= g_ecb012_t   #FUN-A60028 
                      DISPLAY BY NAME g_ecb.ecb01
                      DISPLAY BY NAME g_ecb.ecb02
                      DISPLAY BY NAME g_ecb.ecb03
                      DISPLAY BY NAME g_ecb.ecb012     #FUN-A60028
                      NEXT FIELD ecb01
               END IF
            END IF
          END IF
 
 
        AFTER FIELD ecb06
            IF g_ecb.ecb06 IS NOT NULL THEN
               #若為輸入狀態或更改其作業編號時
               CALL i610_ecb06(p_cmd)
               IF g_chr = 'E' THEN
                  CALL cl_err(g_ecb.ecb06,'mfg4009',0)
                  LET g_ecb.ecb06 = g_ecb_o.ecb06
                  DISPLAY BY NAME g_ecb.ecb06
                  LET g_chr=' '
                  NEXT FIELD ecb06
               END IF
               LET g_ecb_o.ecb06 = g_ecb.ecb06
               LET l_dir = 'U'
            END IF
 
        AFTER FIELD ecb07
            IF g_ecb.ecb07 IS NULL THEN
              #LET g_ecb.ecb07 = '0'  #MOD-740159
              #DISPLAY BY NAME g_ecb.ecb07  #MOD-740159
            ELSE #若此欄位非空白,則將其相關欄位的值Default 給工作區編號
               IF (g_ecb_o.ecb07 IS NULL OR
                   g_ecb_o.ecb07 != g_ecb.ecb07) #AND
                  #g_ecb.ecb07 NOT MATCHES'0' 
                   THEN
                   CALL i610_ecb07()
                   IF g_chr = 'E' THEN
                      CALL cl_err(g_ecb.ecb07,'mfg4010',0)
                      LET g_ecb.ecb07 = g_ecb_o.ecb07
                      DISPLAY BY NAME g_ecb.ecb07
                      NEXT FIELD ecb07
                   END IF
               END IF
               CALL i610_ecb08(l_eca04,l_eca06) RETURNING l_eca04,l_eca06
            END IF
            LET g_ecb_o.ecb07 = g_ecb.ecb07
 
        AFTER FIELD ecb08
            CALL i610_ecb08(l_eca04,l_eca06) RETURNING l_eca04,l_eca06
            IF g_chr = 'E' THEN
               CALL cl_err(g_ecb.ecb08,'mfg4011',0)
               LET g_ecb.ecb08 = g_ecb_o.ecb08
               DISPLAY BY NAME g_ecb.ecb08
               NEXT FIELD ecb08
            END IF
            LET g_ecb_o.ecb08 = g_ecb.ecb08
 
        AFTER FIELD ecb10
            IF g_ecb.ecb10 IS NULL THEN
               LET g_ecb.ecb10 = 0
               DISPLAY BY NAME g_ecb.ecb10
            ELSE
               IF g_ecb.ecb10 < 0 THEN
                  CALL cl_err(g_ecb.ecb10,'mfg4012',0)
                  LET g_ecb.ecb10 = g_ecb_o.ecb10
                  DISPLAY BY NAME g_ecb.ecb10
                  NEXT FIELD ecb10
               END IF
            END IF
            LET g_ecb_o.ecb10 = g_ecb.ecb10
 
        AFTER FIELD ecb11
            IF g_ecb.ecb11 IS NULL THEN
               LET g_ecb.ecb11 = 0
               DISPLAY BY NAME g_ecb.ecb11
            ELSE
               IF g_ecb.ecb11 > 100 OR g_ecb.ecb11 < 0 THEN
                  CALL cl_err(g_ecb.ecb11,'mfg4013',0)
                  LET g_ecb.ecb11 = g_ecb_o.ecb11
                  DISPLAY BY NAME g_ecb.ecb11
                  NEXT FIELD ecb11
               END IF
            END IF
            LET g_ecb_o.ecb11 = g_ecb.ecb11
 
        AFTER FIELD ecb13
          IF g_ecb.ecb13 IS NOT NULL THEN
            IF g_ecb.ecb13 MATCHES'[12]' THEN
               CALL s_ecbsta(g_ecb.ecb13) RETURNING g_d01
               DISPLAY g_d01 TO FORMONLY.d01
               LET g_ecb_o.ecb13 = g_ecb.ecb13
            ELSE
               NEXT FIELD ecb13
            END IF
          END IF
 
        AFTER FIELD ecb14
          IF g_ecb.ecb14 IS NOT NULL THEN
               IF g_ecb.ecb14 > 100 OR g_ecb.ecb14 < 0 THEN
                  CALL cl_err(g_ecb.ecb14,'mfg4013',0)
                  LET g_ecb.ecb14 = g_ecb_o.ecb14
                  DISPLAY BY NAME g_ecb.ecb14
                  NEXT FIELD ecb14
               END IF
               LET g_ecb_o.ecb14 = g_ecb.ecb14
          END IF
 
        AFTER FIELD ecb15
            IF g_ecb.ecb15 IS NULL THEN
               LET g_ecb.ecb15 = 1
               DISPLAY BY NAME g_ecb.ecb15
            ELSE
               IF g_ecb.ecb15 < 0 THEN
                  CALL cl_err(g_ecb.ecb15,'mfg4012',0)
                  LET g_ecb.ecb15 = g_ecb_o.ecb15
                  DISPLAY BY NAME g_ecb.ecb15
                  NEXT FIELD ecb15
               END IF
            END IF
            LET l_dir1 = 'D'
            LET g_ecb_o.ecb15 = g_ecb.ecb15
 
       #---------------No.MOD-930075 mark
       #BEFORE FIELD ecb16
       #    IF l_eca06 = '2' THEN
       #       IF l_dir1 = 'D' THEN
       #          NEXT FIELD ecb17
       #       ELSE
       #          NEXT FIELD ecb15
       #       END IF
       #    END IF
       #---------------No.MOD-930075 end
 
        AFTER FIELD ecb16
            IF g_ecb.ecb16 IS NULL THEN
               LET g_ecb.ecb16 = 1
               DISPLAY BY NAME g_ecb.ecb16
            ELSE
               IF g_ecb.ecb16 < 0 THEN
                  CALL cl_err(g_ecb.ecb16,'mfg4012',0)
                  LET g_ecb.ecb16 = g_ecb_o.ecb16
                  DISPLAY BY NAME g_ecb.ecb16
                  NEXT FIELD ecb16
               END IF
            END IF
            LET g_ecb_o.ecb16 = g_ecb.ecb16
 
        AFTER FIELD ecb17
            LET l_dir1 = 'U'
 
        AFTER FIELD ecb18
            IF g_ecb.ecb18 IS NULL THEN
               LET g_ecb.ecb18 = 0
               DISPLAY BY NAME g_ecb.ecb18
            END IF
            IF g_ecb.ecb18 < 0 THEN
               CALL cl_err(g_ecb.ecb18,'mfg4012',0)
               LET g_ecb.ecb18 = g_ecb_o.ecb18
               DISPLAY BY NAME g_ecb.ecb18
               NEXT FIELD ecb18
            END IF
            LET g_ecb_o.ecb18 = g_ecb.ecb18
 
        AFTER FIELD ecb19
            IF g_ecb.ecb19 IS NULL THEN
               LET g_ecb.ecb19 = 0
               DISPLAY BY NAME g_ecb.ecb19
            END IF
            IF g_ecb.ecb19 < 0 THEN
               CALL cl_err(g_ecb.ecb19,'mfg4012',0)
               LET g_ecb.ecb19 = g_ecb_o.ecb19
               DISPLAY BY NAME g_ecb.ecb19
               NEXT FIELD ecb19
            END IF
            LET g_ecb_o.ecb19 = g_ecb.ecb19
 
       #-----------No.MOD-930075 mark
       #BEFORE FIELD ecb20
       #    IF l_eca06 = '2' THEN
       #       NEXT FIELD ecb26
       #    END IF
       #-----------No.MOD-930075 end
 
        AFTER FIELD ecb20
            IF g_ecb.ecb20 IS NULL THEN
               LET g_ecb.ecb20 = 0
               DISPLAY BY NAME g_ecb.ecb20
            END IF
            IF g_ecb.ecb20 < 0 THEN
               CALL cl_err(g_ecb.ecb20,'anm-249',0)     #No.TQC-6C0177
               LET g_ecb.ecb20 = g_ecb_o.ecb20
               DISPLAY BY NAME g_ecb.ecb20
               NEXT FIELD ecb20
            END IF
            LET g_ecb_o.ecb20 = g_ecb.ecb20
 
       #--------------No.MOD-930075 mark
       #BEFORE FIELD ecb21
       #    IF l_eca06 = '2' THEN
       #       NEXT FIELD ecb19
       #    END IF
       #--------------No.MOD-930075 end
 
        AFTER FIELD ecb21
            IF g_ecb.ecb21 IS NULL THEN
               LET g_ecb.ecb21 = 0
               DISPLAY BY NAME g_ecb.ecb21
            END IF
            IF g_ecb.ecb21 < 0 THEN
               CALL cl_err(g_ecb.ecb21,'anm-249',0)     #No.TQC-6C0177
               LET g_ecb.ecb21 = g_ecb_o.ecb21
               DISPLAY BY NAME g_ecb.ecb21
               NEXT FIELD ecb21
            END IF
            LET g_ecb_o.ecb21 = g_ecb.ecb21
 
    BEFORE FIELD ecb26
        IF l_eca04 != '0' THEN NEXT FIELD ecb22 END IF #表示為廠外加工區
 
    AFTER FIELD ecb26
        IF g_ecb.ecb26 IS NULL THEN
           LET g_ecb.ecb26 = 0
           DISPLAY BY NAME g_ecb.ecb26
        END IF
 
    BEFORE FIELD ecb27
        IF l_eca04 != '0' THEN NEXT FIELD ecb21 END IF
    
 
    BEFORE FIELD ecb22
        IF l_eca04 = '0' THEN EXIT INPUT END IF
 
    AFTER FIELD ecb22
        IF g_ecb.ecb22 IS NULL THEN
           LET g_ecb.ecb22 = 0
           DISPLAY BY NAME g_ecb.ecb22
        END IF
        IF g_ecb.ecb22 < 0 THEN
           CALL cl_err(g_ecb.ecb22,'mfg4012',0)
           DISPLAY BY NAME g_ecb_o.ecb22
           NEXT FIELD ecb22
        END IF
        LET g_ecb_o.ecb22 = g_ecb.ecb22
 
    AFTER FIELD ecb24
       #IF g_ecb.ecb24 IS NULL THEN NEXT FIELD ecb24 END IF    #MOD-B50019 mark
        LET l_ima08 = ' '
        SELECT ima08 INTO l_ima08 FROM ima_file
               WHERE ima01 = g_ecb.ecb24
        IF SQLCA.sqlcode OR l_ima08 NOT MATCHES  '[MRS]' THEN
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ecb.ecb24,'mfg1201',0) 
           ELSE
              CALL cl_err(g_ecb.ecb24,'mfg4007',0) 
           END IF
           LET g_ecb.ecb24 = g_ecb_o.ecb24
           DISPLAY BY NAME g_ecb.ecb24
           NEXT FIELD ecb24
        END IF
        LET g_ecb_o.ecb24 = g_ecb.ecb24
 
    AFTER FIELD ecb28
        IF g_ecb.ecb28 IS NULL THEN
           LET g_ecb.ecb28 = 0
           DISPLAY BY NAME g_ecb.ecb28
           NEXT FIELD ecb28
        END IF
        IF g_ecb.ecb28 < 0 THEN
           CALL cl_err(g_ecb.ecb28,'mfg4012',0)
           LET g_ecb.ecb28 = g_ecb_o.ecb28
           DISPLAY BY NAME g_ecb.ecb28
           NEXT FIELD ecb28
        END IF
        LET g_ecb_o.ecb28 = g_ecb.ecb28
 
    AFTER FIELD ecb23
        IF g_ecb.ecb23 IS NULL THEN
           LET g_ecb.ecb23 = 0
           DISPLAY BY NAME g_ecb.ecb23
           NEXT FIELD ecb23
        END IF
        IF g_ecb.ecb23 < 0 THEN
           CALL cl_err(g_ecb.ecb23,'mfg4012',0)
           LET g_ecb.ecb23 = g_ecb_o.ecb23
           DISPLAY BY NAME g_ecb.ecb23
           NEXT FIELD ecb23
        END IF
        LET g_ecb_o.ecb23 = g_ecb.ecb23
 
    AFTER FIELD ecb25
        IF g_ecb.ecb25 IS NOT NULL THEN
           SELECT pmc01 FROM pmc_file WHERE pmc01 = g_ecb.ecb25
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_ecb.ecb25,STATUS,0) #No.FUN-660091
              CALL cl_err3("sel","pmc_file",g_ecb.ecb25,"",STATUS,"","",1) #FUN-660091
              LET g_ecb.ecb25 = g_ecb_o.ecb25
              DISPLAY BY NAME g_ecb.ecb25
              NEXT FIELD ecb25
           END IF
        END IF
        LET g_ecb_o.ecb25 = g_ecb.ecb25
 
#FUN-A60028 --begin--
     AFTER FIELD ecb52
       IF NOT cl_null(g_ecb.ecb52) THEN 
          IF g_ecb.ecb52 < 0 THEN   
             CALL cl_err('','aim-223',0)
             NEXT FIELD CURRENT 
          END IF                  
          #No.FUN-BB0086--add--begin--
          LET g_ecb.ecb52 = s_digqty(g_ecb.ecb52,g_ecb.ecb45)
          DISPLAY BY NAME g_ecb.ecb52
          #No.FUN-BB0086--add--end--
       ELSE
          NEXT FIELD CURRENT 
       END IF 	
       
     AFTER FIELD ecb53 
       IF NOT cl_null(g_ecb.ecb52) THEN 
          IF g_ecb.ecb53 <= 0 THEN 
             CALL cl_err('','afa-037',0)
             NEXT FIELD CURRENT 
          END IF             
       ELSE
      	  NEXT FIELD CURRENT 
       END IF 	       
#FUN-A60028 --end-- 
        AFTER INPUT
           LET g_ecb.ecbuser = s_get_data_owner("ecb_file") #FUN-C10039
           LET g_ecb.ecbgrup = s_get_data_group("ecb_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
#FUN-A60028 --end--            
            IF p_cmd = "a" OR 
              (p_cmd = "u" AND (g_ecb.ecb01 != g_ecb01_t OR
                   g_ecb.ecb02 != g_ecb02_t OR
                   g_ecb.ecb03 != g_ecb03_t OR g_ecb.ecb012 != g_ecb012_t)) THEN   
              SELECT count(*) INTO l_n FROM ecb_file
               WHERE ecb01 = g_ecb.ecb01 
                 AND ecb02 = g_ecb.ecb02
                 AND ecb03 = g_ecb.ecb03
                 AND ecb012= g_ecb.ecb012    
               IF l_n > 0 THEN             
                  LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,
                            '+',g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED    
                   CALL cl_err(g_msg,-239,0)
                      NEXT FIELD ecb01
               END IF
            END IF
#FUN-A60028 --end--                        
            IF g_ecb.ecb06 IS NULL THEN
               DISPLAY BY NAME g_ecb.ecb06
               LET l_sw = 'Y'
            END IF
            IF g_ecb.ecb08 IS NULL THEN
               DISPLAY BY NAME g_ecb.ecb08
               LET l_sw = 'Y'
            END IF
            IF g_ecb.ecb13 IS NULL THEN
               DISPLAY BY NAME g_ecb.ecb13
               LET l_sw = 'Y'
            END IF
            IF l_sw = 'Y' THEN
               CALL cl_err('','9033',0)
               LET l_sw = 'N'
               NEXT FIELD ecb01
            END IF
           #MOD-740159...........begin
           #IF g_ecb.ecb07 IS NULL THEN
           #   LET g_ecb.ecb07 = '0'
           #   DISPLAY BY NAME g_ecb.ecb07
           #END IF
           #MOD-740159...........end
            IF g_ecb.ecb10 IS NULL THEN
               LET g_ecb.ecb10 = 0
               DISPLAY BY NAME g_ecb.ecb10
            END IF
            IF g_ecb.ecb11 IS NULL THEN
               LET g_ecb.ecb11 = 0 #MOD-740159 ecb07->ecb11
               DISPLAY BY NAME g_ecb.ecb11
            END IF
            IF g_ecb.ecb14 IS NULL THEN
               LET g_ecb.ecb14 = 0
               DISPLAY BY NAME g_ecb.ecb14
            END IF
            IF g_ecb.ecb18 IS NULL THEN
               LET g_ecb.ecb18 = 0
               DISPLAY BY NAME g_ecb.ecb18
            END IF
            IF g_ecb.ecb19 IS NULL THEN
               LET g_ecb.ecb19 = 0
               DISPLAY BY NAME g_ecb.ecb19
            END IF
            IF g_ecb.ecb20 IS NULL THEN
               LET g_ecb.ecb20 = 0 #MOD-740159 ecb07->ecb20
               DISPLAY BY NAME g_ecb.ecb20
            END IF
            IF g_ecb.ecb21 IS NULL THEN
               LET g_ecb.ecb21 = 0
               DISPLAY BY NAME g_ecb.ecb21
            END IF
            IF l_eca04 != '0' THEN
               IF g_ecb.ecb22 IS NULL THEN
                  LET g_ecb.ecb22 = 0
                  DISPLAY BY NAME g_ecb.ecb22
               END IF
               IF g_ecb.ecb23 IS NULL THEN
                  LET g_ecb.ecb23 = 0
                  DISPLAY BY NAME g_ecb.ecb23
               END IF
               IF g_ecb.ecb28 IS NULL THEN
                  LET g_ecb.ecb28 = 0
                  DISPLAY BY NAME g_ecb.ecb28
               END IF
            ELSE
               IF g_ecb.ecb26 IS NULL THEN
                  LET g_ecb.ecb26 = 0
                  DISPLAY BY NAME g_ecb.ecb26
               END IF
               IF g_ecb.ecb27 IS NULL THEN
                  LET g_ecb.ecb27 = 0
                  DISPLAY BY NAME g_ecb.ecb27
               END IF
            END IF
 
        #MOD-650015 --start 
#       ON ACTION CONTROLO                        # 沿用所有欄位
#           IF INFIELD(ecb01) THEN
#               LET g_ecb.* = g_ecb_t.*
#               DISPLAY BY NAME g_ecb.*
#               NEXT FIELD ecb01
#           END IF
        #MOD-650015 --end
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ecb01) #料件編號
#                 CALL q_ima1(0,0,'MPXKUVRS',g_ecb.ecb01) RETURNING g_ecb.ecb01
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_ima1"
               #   LET g_qryparam.default1 = g_ecb.ecb01
               #   LET g_qryparam.where = "ima08 IN ('M','P','X','K','U','V','R','S')"
               #   CALL cl_create_qry() RETURNING g_ecb.ecb01
                  CALL q_sel_ima(FALSE, "q_ima1", "ima08 IN ('M','P','X','K','U','V','R','S')", g_ecb.ecb01, "", "", "", "" ,"",'' )  RETURNING g_ecb.ecb01
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_ecb.ecb01
                  NEXT FIELD ecb01                
               WHEN INFIELD(ecb03) #編號
#                 CALL q_ecb1(0,0,g_ecb.ecb01) RETURNING g_ecb.ecb03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecb1"
                  IF g_ecb.ecb01 IS NOT NULL THEN
                     LET g_qryparam.where = " ecb01= '",g_ecb.ecb01,"'"
                  END IF
                  CALL cl_create_qry() RETURNING g_ecb.ecb03
                  DISPLAY BY NAME g_ecb.ecb03
                  NEXT FIELD ecb03
               WHEN INFIELD(ecb06) #作業編號
#                 CALL q_ecd(0,0,g_ecb.ecb06)
#                      RETURNING g_ecb.ecb06
                  CALL q_ecd(FALSE,TRUE,g_ecb.ecb06) RETURNING g_ecb.ecb06
                  DISPLAY BY NAME g_ecb.ecb06
                  CALL i610_ecb06(p_cmd)
                  NEXT FIELD ecb06
               WHEN INFIELD(ecb07) #機器編號
#                 CALL q_eci(0,0,g_ecb.ecb07) RETURNING g_ecb.ecb07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_eci"
                  LET g_qryparam.default1 = g_ecb.ecb07
                  CALL cl_create_qry() RETURNING g_ecb.ecb07
                  DISPLAY BY NAME g_ecb.ecb07
                  NEXT FIELD ecb07
               WHEN INFIELD(ecb08) #工作區編號
#                 CALL q_eca(0,0,g_ecb.ecb08) RETURNING g_ecb.ecb08
                  CALL q_eca(FALSE,TRUE,g_ecb.ecb08) RETURNING g_ecb.ecb08
                  DISPLAY BY NAME g_ecb.ecb08
                  CALL i610_ecb08(l_eca04,l_eca06) RETURNING l_eca04,l_eca06
                  NEXT FIELD ecb08
               WHEN INFIELD(ecb24) #廠外加工料件
#                 CALL q_ima1(0,0,'S',g_ecb.ecb24) RETURNING g_ecb.ecb24
#FUN-AA0059 --Begin--
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.form = "q_ima1"
              #    LET g_qryparam.default1 = g_ecb.ecb24
              #    LET g_qryparam.where = "ima08 IN ('S')"
              #    CALL cl_create_qry() RETURNING g_ecb.ecb24
                  CALL q_sel_ima(FALSE, "q_ima1", "ima08 IN ('S')", g_ecb.ecb24, "", "", "", "" ,"",'' )  RETURNING g_ecb.ecb24
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_ecb.ecb24
                  NEXT FIELD ecb24
               WHEN INFIELD(ecb25) #廠外加工廠商
#                 CALL q_pmc(0,0,g_ecb.ecb25) RETURNING g_ecb.ecb25
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.default1 = g_ecb.ecb25
                  CALL cl_create_qry() RETURNING g_ecb.ecb25
                  DISPLAY BY NAME g_ecb.ecb25
                  NEXT FIELD ecb25
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
#       ON ACTION inventory
#           CASE
#              WHEN INFIELD(ecb01) #料件編號
#                   CALL cl_cmdrun('aimi101')
#           END CASE
#       ON ACTION maintain_task_data
#           CASE
#              WHEN INFIELD(ecb06) #作業編號
#                   CALL cl_cmdrun('aeci620')
#           END CASE
#       ON ACTION maintain_machine
#           CASE
#              WHEN INFIELD(ecb07) #機器編號
#                   CALL cl_cmdrun('aeci670')
#           END CASE
#       ON ACTION maintain_work_center
#           CASE
#              WHEN INFIELD(ecb08) #工作區編號
#                   CALL cl_cmdrun('aeci600')
#           END CASE
#       ON ACTION item_master_common_data
#           CASE
#              WHEN INFIELD(ecb24) #廠外加工料件
#                 IF g_sma.sma09 = 'N' THEN
#                    CALL cl_err('','mfg2617',0)
#                 ELSE
#                    CALL cl_cmdrun('aimi100')
#                 END IF
#           END CASE
#       ON ACTION supplier_common_data
#           CASE
#              WHEN INFIELD(ecb25) #廠外加工廠商
#                   CALL cl_cmdrun('apmi600')
#              OTHERWISE EXIT CASE
#           END CASE
 
        ON ACTION CONTROLF                        # 欄位description
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
  
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
END FUNCTION
 
#作業編號須存在[作業description檔]內,若存在則須將最近日期之值Default
#給[製程資料檔]內之相關欄位,否則須重新輸入
FUNCTION i610_ecb06(p_cmd)
   DEFINE  p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF g_ecb_o.ecb06 IS NULL OR
      g_ecb_o.ecb06 != g_ecb.ecb06 THEN
      LET g_chr = ' '
     #SELECT ecd07,ecd09,ecd15  #TQC-B30109
      SELECT ecd07,ecd09,ecd02  #TQC-B30109
      INTO g_ecb.ecb08,
           g_ecb.ecb11,g_ecb.ecb17
      FROM ecd_file WHERE ecd01 = g_ecb.ecb06
       IF SQLCA.sqlcode THEN
          LET g_chr = 'E'
          RETURN
       END IF
       DISPLAY BY NAME
           g_ecb.ecb08,g_ecb.ecb11,g_ecb.ecb15
       CALL s_ecbsta(g_ecb.ecb13) RETURNING g_d01
       DISPLAY g_d01 TO FORMONLY.d01
    END IF
END FUNCTION
 
FUNCTION i610_ecb07()  #機器編號 Default 工作區編號
    LET g_chr = ' '
    SELECT eci03 INTO g_ecb.ecb08 FROM eci_file
           WHERE eci01 = g_ecb.ecb07
    IF SQLCA.sqlcode THEN
       LET g_chr = 'E'
       RETURN
    END IF
    DISPLAY BY NAME g_ecb.ecb08
END FUNCTION
 
#工作區若屬(廠外加工)則將廠外加工之相關欄位清為null
#否則將[排程設置時間] 及 [排程生產時間] 清為null
FUNCTION i610_ecb08(l_eca04,l_eca06)
    DEFINE l_eca04  LIKE eca_file.eca04,
           l_eca06  LIKE eca_file.eca06
    LET g_chr = ' '
    IF g_ecb_o.ecb08 IS NULL OR
       g_ecb_o.ecb08 != g_ecb.ecb08 THEN
       LET g_ecb_o.ecb08 = g_ecb.ecb08
       SELECT eca04,eca06 INTO l_eca04,l_eca06 FROM eca_file
              WHERE eca01 = g_ecb.ecb08 AND ecaacti = 'Y'
       IF SQLCA.sqlcode THEN
          LET g_chr = 'E'
          RETURN l_eca04,l_eca06
       END IF
       IF l_eca04 != '0' THEN
          LET g_ecb.ecb26 = 0 LET g_ecb.ecb27 = 0
          DISPLAY BY NAME g_ecb.ecb26,g_ecb.ecb27
       ELSE
          LET g_ecb.ecb22 = 0 LET g_ecb.ecb23 = 0
          LET g_ecb.ecb24 = NULL LET g_ecb.ecb25 = NULL
          LET g_ecb.ecb28 = 0
          DISPLAY BY NAME g_ecb.ecb22,g_ecb.ecb23,g_ecb.ecb24,
                          g_ecb.ecb25,g_ecb.ecb28
       END IF
       IF l_eca06 = '2' THEN
          LET g_ecb.ecb16 = 0
          LET g_ecb.ecb20 = 0  LET g_ecb.ecb21 = 0
          DISPLAY BY NAME g_ecb.ecb20,g_ecb.ecb21,g_ecb.ecb16
       END IF
    END IF
    RETURN l_eca04,l_eca06
END FUNCTION
 
 
FUNCTION i610_q()
    MESSAGE ""
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ecb.* TO NULL              #No.FUN-6A0039
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i610_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i610_count
    FETCH i610_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED       #FUN-A60028 add g_ecb.ecb012
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_ecb.* TO NULL
    ELSE
        CALL i610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i610_fetch(p_flecc)
    DEFINE
        p_flecc         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flecc
        WHEN 'N' FETCH NEXT     i610_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02, g_ecb.ecb03,g_ecb.ecb012     #FUN-A60028 add g_ecb.ecb012
        WHEN 'P' FETCH PREVIOUS i610_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02, g_ecb.ecb03,g_ecb.ecb012     #FUN-A60028 add g_ecb.ecb012
        WHEN 'F' FETCH FIRST    i610_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02, g_ecb.ecb03,g_ecb.ecb012     #FUN-A60028 add g_ecb.ecb012
        WHEN 'L' FETCH LAST     i610_cs INTO g_ecb.ecb01,
                                             g_ecb.ecb02, g_ecb.ecb03,g_ecb.ecb012     #FUN-A60028 add g_ecb.ecb012
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump i610_cs INTO g_ecb.ecb01,
                                                g_ecb.ecb02, g_ecb.ecb03,g_ecb.ecb012     #FUN-A60028 add g_ecb.ecb012
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED        #FUN-A60028 add g_ecb.ecb012
        CALL cl_err(g_msg,SQLCA.sqlcode,1)
        INITIALIZE g_ecb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flecc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ecb.* FROM ecb_file            # 重讀DB,因TEMP有不被更新特性
     WHERE ecb01 = g_ecb.ecb01 
       AND ecb02 = g_ecb.ecb02 
       AND ecb03 = g_ecb.ecb03
       AND ecb012= g_ecb.ecb012      #FUN-A60028 add
    IF SQLCA.sqlcode THEN
       LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                 g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED     #FUN-A60028 add g_ecb.ecb012
#      CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("sel","ecb_file",g_msg,"",SQLCA.sqlcode,"","",1) #FUN-660091
    ELSE
       LET g_data_owner = g_ecb.ecbuser      #FUN-4C0034
       LET g_data_group = g_ecb.ecbgrup      #FUN-4C0034
       CALL i610_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION i610_show()
DEFINE l_ecu014   LIKE ecu_file.ecu014    #FUN-A60028 add

    LET g_ecb_t.* = g_ecb.*
    LET g_ecb_o.* = g_ecb.*
    DISPLAY BY NAME g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03, g_ecb.ecboriu,g_ecb.ecborig,
                    g_ecb.ecb06,g_ecb.ecb07,g_ecb.ecb08,
                    g_ecb.ecb012,g_ecb.ecb52,g_ecb.ecb53,               #FUN-A60028 add
                    g_ecb.ecb09,g_ecb.ecb10,g_ecb.ecb11,g_ecb.ecb12,
                    g_ecb.ecb13,g_ecb.ecb14,g_ecb.ecb15,g_ecb.ecb16,
                    g_ecb.ecb17,g_ecb.ecb18,g_ecb.ecb19,g_ecb.ecb20,
                    g_ecb.ecb21,g_ecb.ecb22,g_ecb.ecb23,g_ecb.ecb24,
                    g_ecb.ecb25,g_ecb.ecb26,g_ecb.ecb27,g_ecb.ecb28,
                    g_ecb.ecb36,g_ecb.ecb37,
                    g_ecb.ecbuser,g_ecb.ecbgrup,g_ecb.ecbmodu,
                    g_ecb.ecbdate,g_ecb.ecbacti
   
#FUN-A60028  --begin--
   LET l_ecu014 = NULL
   SELECT ecu014 INTO l_ecu014 FROM ecu_file
    WHERE ecu01  = g_ecb.ecb01
      AND ecu02  = g_ecb.ecb02
      AND ecu012 = g_ecb.ecb012
   DISPLAY l_ecu014 TO ecu014      
#FUN-A60028 --end--
    
    CALL s_ecbsta(g_ecb.ecb13) RETURNING g_d01
    DISPLAY g_d01 TO FORMONLY.d01
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i610_u()
    DEFINE l_n      LIKE type_file.num5     #No.TQC-6A0065 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecb.ecb01 IS NULL OR g_ecb.ecb012 IS NULL THEN   #FUN-A60028 add g_ecb.ecb012
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
         #檢查此筆資料是否己轉為工單或尚在使用中
    IF i610_check() THEN
       CALL cl_err('','mfg4026',0)
       RETURN
    END IF
    IF g_ecb.ecbacti ='N' THEN    #檢查資料是否為無效
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED     #FUN-A60028 add g_ecb.ecb012
        CALL cl_err(g_msg,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ecb01_t = g_ecb.ecb01
    LET g_ecb012_t= g_ecb.ecb012   #FUN-A60028 
    LET g_ecb02_t = g_ecb.ecb02
    LET g_ecb03_t = g_ecb.ecb03
    BEGIN  WORK
 
    OPEN i610_cl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012     #FUN-A60028 
    IF STATUS THEN
       CALL cl_err("OPEN i610_cl:", STATUS, 1)
       CLOSE i610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i610_cl INTO g_ecb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED     #FUN-A60028 add g_ecb.ecb012
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ecb_o.* = g_ecb.*
    LET g_ecb.ecbmodu=g_user                     #修改者
    LET g_ecb.ecbdate = g_today                  #修改日期
    CALL i610_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i610_i("u")   # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ecb.*=g_ecb_t.*
            CALL i610_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        #若更改KEY 值
        IF g_ecb.ecb01 != g_ecb01_t OR g_ecb.ecb02 != g_ecb02_t OR
           g_ecb.ecb03 != g_ecb03_t OR g_ecb.ecb012 != g_ecb012_t  THEN   #FUN-A60028 add g_ecb.ecb012
           UPDATE ecw_file SET ecw01=g_ecb.ecb01,
                               ecw02=g_ecb.ecb02,
                               ecw03=g_ecb.ecb03,
                               ecw012=g_ecb.ecb012        #FUN-A60028 add
                  WHERE ecw01 = g_ecb01_t 
                    AND ecw02 = g_ecb02_t
                    AND ecw03 = g_ecb03_t
                    AND ecw012= g_ecb012_t       #FUN-A60028 add
           IF SQLCA.sqlcode THEN 
#          CALL cl_err('update:',SQLCA.sqlcode,0)  #No.FUN-660091
           CALL cl_err3("upd","ecw_file",g_ecb01_t,g_ecb02_t,SQLCA.sqlcode,"","update:",1) #FUN-660091          
           END IF
        END IF
        UPDATE ecb_file SET ecb_file.* = g_ecb.*    # 更新DB
         WHERE ecb01 = g_ecb.ecb01 AND ecb02 = g_ecb.ecb02 AND ecb03 = g_ecb.ecb03             # COLAUTH?
           AND ecb012= g_ecb.ecb012   #FUN-A60028 add
        IF SQLCA.sqlcode THEN
            LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                      g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED     #FUN-A60028 add g_ecb.ecb012   
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("upd","ecb_file",g_ecb01_t,g_ecb02_t,SQLCA.sqlcode,"","",1) #FUN-660091
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i610_cl
    COMMIT WORK
    #No.TQC-6A0065 --begin
    SELECT COUNT(*) INTO l_n FROM sgc_file
     WHERE sgc01 = g_ecb_t.ecb01
       AND sgc02 = g_ecb_t.ecb02
       AND sgc03 = g_ecb_t.ecb03
       AND sgc012= g_ecb_t.ecb012   #FUN-A60028 add
    IF l_n > 0 THEN
       UPDATE sgc_file SET sgc04 = g_ecb.ecb08
        WHERE sgc01 = g_ecb.ecb01
          AND sgc02 = g_ecb.ecb02
          AND sgc03 = g_ecb.ecb03
          AND sgc012= g_ecb.ecb012    #FUN-A60028 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                  
          CALL cl_err3("upd","sgc_file","","",SQLCA.sqlcode,"","",1)                                                  
       END IF                                                                                                         
    END IF                                                                                                            
    #No.TQC-6A0065 --end 
 
    #是否進入預設資料維護作業
    #CALL cl_getmsg('mfg4018',g_lang) RETURNING g_msg
    #IF cl_prompt(16,9,g_msg) THEN
    #   CALL i611(0,0,g_ecb.*)
    #END IF
END FUNCTION
 
FUNCTION i610_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecb.ecb01 IS NULL OR g_ecb.ecb012 IS NULL THEN   #FUN-A60028 add g_ecb.ecb012
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #檢查此筆資料是否己轉為工單或尚在使用中
    IF i610_check() THEN
       CALL cl_err('','mfg4026',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i610_cl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012    #FUN-A60028 g_ecb.ecb012
    IF STATUS THEN
       CALL cl_err("OPEN i610_cl:", STATUS, 1)
       CLOSE i610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i610_cl INTO g_ecb.*
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED     #FUN-A60028 add g_ecb.ecb012
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i610_show()
    IF cl_exp(15,21,g_ecb.ecbacti) THEN
        LET g_chr=g_ecb.ecbacti
        IF g_ecb.ecbacti='Y' THEN
            LET g_ecb.ecbacti='N'
        ELSE
            LET g_ecb.ecbacti='Y'
        END IF
        UPDATE ecb_file
           SET ecbacti=g_ecb.ecbacti,
               ecbmodu=g_user, ecbdate=g_today
         WHERE ecb01 = g_ecb.ecb01 AND ecb02 = g_ecb.ecb02 AND ecb03 = g_ecb.ecb03
           AND ecb012= g_ecb.ecb012   #FUN-A60028 add 
            
        IF SQLCA.SQLERRD[3]=0 THEN
            LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED   #FUN-A60028 add g_ecb.ecb012
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("upd","ecb_file",g_msg,"",SQLCA.sqlcode,"","",1) #FUN-660091
            LET g_ecb.ecbacti=g_chr
        END IF
        DISPLAY BY NAME g_ecb.ecbacti
    END IF
    CLOSE i610_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i610_r()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
    DEFINE l_ecbacti   LIKE ecb_file.ecbacti     #No.TQC-930162 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ecb.ecb01 IS NULL OR g_ecb.ecb012 IS NULL THEN   #FUN-A60028 add g_ecb.ecb012 
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #檢查此筆資料是否己轉為工單或尚在使用中
    IF i610_check() THEN
       CALL cl_err('','mfg4026',0)
       RETURN
    END IF
    #No.TQC-930162--begin                                                                                                           
    SELECT ecbacti INTO l_ecbacti FROM ecb_file                                                                                     
     WHERE ecb01=g_ecb.ecb01 AND ecb02=g_ecb.ecb02 AND ecb03=g_ecb.ecb03                                                            
       AND ecb012= g_ecb.ecb012   #FUN-A60028 add
    IF l_ecbacti='N' THEN                                                                                                           
       CALL cl_err('','aec-210',1)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
    #No.TQC-930162--end 
    BEGIN WORK
 
    OPEN i610_cl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012   #FUN-A60028 add g_ecb.ecb012
    IF STATUS THEN
       CALL cl_err("OPEN i610_cl:", STATUS, 1)
       CLOSE i610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i610_cl INTO g_ecb.*
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED         #FUN-A60028 add g_ecb.ecb012
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i610_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ecb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ecb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "ecb03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "ecb012"        #FUN-A60028 add 
        LET g_doc.value1 = g_ecb.ecb01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ecb.ecb02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_ecb.ecb03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_ecb.ecb012     #FUN-A60028 add
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ecb_file 
        WHERE ecb01 = g_ecb.ecb01 
          AND ecb02 = g_ecb.ecb02 
          AND ecb03 = g_ecb.ecb03
          AND ecb012= g_ecb.ecb012      #FUN-A60028 add
       CLEAR FORM
       OPEN i610_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i610_cs
          CLOSE i610_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i610_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i610_cs
          CLOSE i610_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i610_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i610_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i610_fetch('/')
       END IF
    END IF
    CLOSE i610_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i610_check()
   SELECT ecm01 FROM ecm_file WHERE ecm11 = g_ecb.ecb02
   IF NOT SQLCA.sqlcode THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION
 
FUNCTION i610_copy()
DEFINE  l_ecb_c         RECORD LIKE ecb_file.*,
        l_n             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
        l_newno1        LIKE ecb_file.ecb01,
        l_newno2        LIKE ecb_file.ecb02,
        l_newno3        LIKE ecb_file.ecb03,
        l_newno4        LIKE ecb_file.ecb012,   #FUN-A60028 add
        l_oldno1        LIKE ecb_file.ecb01,
        l_oldno2        LIKE ecb_file.ecb02,
        l_oldno3        LIKE ecb_file.ecb03,
        l_oldno4        LIKE ecb_file.ecb012    #FUN-A60028 add
DEFINE  l_ecu014        LIKE ecu_file.ecu014      #FUN-A60028
DEFINE  l_cnt           LIKE type_file.num5       #FUN-A60028
     
    IF s_shut(0) THEN RETURN END IF
    IF g_ecb.ecb01 IS NULL OR g_ecb.ecb012 IS NULL THEN   #FUN-A60028 add g_ecb.ecb012
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i610_set_entry('a')
    CALL i610_set_no_entry('a')
    LET g_before_input_done = TRUE
    LET g_ecu014 = NULL      #FUN-A60028 
 
    INPUT l_newno1,l_newno2,l_newno4,l_newno3 FROM ecb01,ecb02,ecb012,ecb03    #FUN-A60028 add l_newno4,ecb012
        BEFORE FIELD ecb01
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(5,11,l_newno1) RETURNING l_newno1
	                DISPLAY l_newno1 TO ecb01
    	    END IF
        AFTER FIELD ecb01
            IF l_newno1 IS NULL THEN
                NEXT FIELD ecb01
            END IF
            #FUN-AA0059 -----------------add start-----------
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               LET l_newno1 = NULL
               DISPLAY l_newno1 TO ecb01
               NEXT FIELD ecb01
            END IF 
            #FUN-AA0059 -----------------add end------------         
            SELECT ima01 FROM ima_file
                   WHERE ima01 = l_newno1 AND
                         ima08 IN ('M','m','R','r','X','x')
            IF SQLCA.sqlcode THEN
#              CALL cl_err(l_newno1,'mfg4007',0) #No.FUN-660091
               CALL cl_err3("sel","ima_file",l_newno1,"","mfg4007","","",1) #FUN-660091
               LET l_newno1 = NULL
               DISPLAY l_newno1 TO ecb01
               NEXT FIELD ecb01
            END IF
        AFTER FIELD ecb02
            IF l_newno2 IS NULL THEN
                NEXT FIELD ecb02
            END IF
            IF l_newno2 IS NULL THEN
               LET l_newno2 = 1
               DISPLAY l_newno2 TO ecb02
            ELSE
               IF l_newno2 < 0 THEN
                  CALL cl_err('','mfg4012',0)
                  LET l_newno2 = NULL
                  DISPLAY l_newno2 TO ecb02
                  NEXT FIELD ecb02
               END IF
            END IF
#FUN-A60028 --begin--
       AFTER FIELD ecb012
         IF l_newno4 IS NULL THEN 
            NEXT FIELD CURRENT 
         END IF    
         LET l_cnt = 0 
         LET l_ecu014 = NULL
         SELECT COUNT(*),ecu014 INTO l_cnt,l_ecu014 FROM ecu_file
          WHERE ecu01  = l_newno1
            AND ecu02  = l_newno2
            AND ecu012 = l_newno4
            AND ecuacti = 'Y'  #CHI-C90006
            GROUP BY ecu014
         IF l_cnt > 0 THEN 
            CALL cl_set_comp_entry("ecu014",FALSE)
            DISPLAY l_ecu014 TO ecu014         	      
         END IF            
#FUN-A60028 --end--            

        AFTER FIELD ecb03
            IF l_newno3 IS NULL THEN
                NEXT FIELD ecb03
            END IF
            IF l_newno3 < 0 THEN
               CALL cl_err('','mfg4012',0)
               LET l_newno3 = NULL
               DISPLAY l_newno3 TO ecb03
               NEXT FIELD ecb03
            END IF
            #檢查重複否
            SELECT count(*) INTO g_cnt FROM ecb_file
             WHERE ecb01 = l_newno1 
               AND ecb02 = l_newno2 
               AND ecb03 = l_newno3
               AND ecb012= l_newno4     #FUN-A60028 add
            IF g_cnt > 0 THEN
                LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',
                          l_newno3 CLIPPED,'+',l_newno4 CLIPPED     #FUN-A60028 
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD ecb01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM ecb_file
             WHERE ecb01 = l_newno1 
               AND ecb02 = l_newno2 
               AND ecb03 = l_newno3
               AND ecb012= l_newno4   #FUN-A60028 add
            IF g_cnt > 0 THEN
               LET g_update = 'Y'
            ELSE
               LET g_update = 'N'
            END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ecb01) #料件編號
#                 CALL q_ima1(0,0,'MPXKUVRS',g_ecb.ecb01) RETURNING g_ecb.ecb01
#                 CALL FGL_DIALOG_SETBUFFER( g_ecb.ecb01 )
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima1"
                #  LET g_qryparam.default1 = l_newno1
                #  LET g_qryparam.where = "ima08 IN ('M','P','X','K','U','V','R','S')"
                #  CALL cl_create_qry() RETURNING l_newno1
                   CALL q_sel_ima(FALSE, "q_ima1", "ima08 IN ('M','P','X','K','U','V','R','S')",l_newno1, "", "", "", "" ,"",'' )  RETURNING l_newno1 
#FUN-AA0059 --End--
#                  CALL FGL_DIALOG_SETBUFFER( l_newno1 )
                  DISPLAY BY NAME l_newno1
                  NEXT FIELD ecb01        
               WHEN INFIELD(ecb03) #編號
#                 CALL q_ecb1(0,0,g_ecb.ecb01) RETURNING g_ecb.ecb03
#                 CALL FGL_DIALOG_SETBUFFER( g_ecb.ecb03 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecb1"
                  IF g_ecb.ecb01 IS NOT NULL THEN
                     LET g_qryparam.where = " ecb01= '",l_newno1,"'"
                  END IF
                  CALL cl_create_qry() RETURNING l_newno3
#                  CALL FGL_DIALOG_SETBUFFER( l_newno3 )
                  DISPLAY BY NAME l_newno3
                  NEXT FIELD ecb03
               OTHERWISE EXIT CASE
            END CASE
 
 #FUN-A60028 --begin--
        AFTER INPUT 
          IF INT_FLAG THEN EXIT INPUT END IF 
            SELECT count(*) INTO g_cnt FROM ecb_file
             WHERE ecb01 = l_newno1 
               AND ecb02 = l_newno2 
               AND ecb03 = l_newno3
               AND ecb012= l_newno4    
            IF g_cnt > 0 THEN
                LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED,'+',
                          l_newno3 CLIPPED,'+',l_newno4 CLIPPED    
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD ecb01
            END IF           
 #FUN-A60028 --end--
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          EXIT INPUT
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ecb.ecb01
        DISPLAY BY NAME g_ecb.ecb02
        DISPLAY BY NAME g_ecb.ecb03
        DISPLAY BY NAME g_ecb.ecb012     #FUN-A60028 add
        RETURN
    END IF
    SELECT * INTO l_ecb_c.* FROM ecb_file
     WHERE ecb01 = g_ecb.ecb01 
       AND ecb02 = g_ecb.ecb02 
       AND ecb03 = g_ecb.ecb03
       AND ecb012= g_ecb.ecb012   #FUN-A60028 add
        LET l_ecb_c.ecb01=l_newno1    #資料鍵值-1
        LET l_ecb_c.ecb02=l_newno2    #資料鍵值-2
        LET l_ecb_c.ecb03=l_newno3    #資料鍵值-3
        LET l_ecb_c.ecb012= l_newno4   #FUN-A60028 
        LET l_ecb_c.ecbuser=g_user    #資料所有者
        LET l_ecb_c.ecbgrup=g_grup    #資料所有者所屬群
        LET l_ecb_c.ecbmodu=NULL      #資料修改日期
        LET l_ecb_c.ecbdate=g_today   #資料建立日期
        LET l_ecb_c.ecbacti='Y'       #有效資料
    IF cl_null(l_ecb_c.ecb01) THEN LET l_ecb_c.ecb01=' ' END IF
    IF cl_null(l_ecb_c.ecb012) THEN LET l_ecb_c.ecb012 = ' ' END IF   #FUN-A60028 
    LET l_ecb_c.ecboriu = g_user      #No.FUN-980030 10/01/04
    LET l_ecb_c.ecborig = g_grup      #No.FUN-980030 10/01/04
    IF cl_null(l_ecb_c.ecb66) THEN LET l_ecb_c.ecb66 = 'N' END IF     #No.TQC-B10097
    INSERT INTO ecb_file VALUES(l_ecb_c.*)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_ecb.ecb01 CLIPPED,'+',g_ecb.ecb02 CLIPPED,'+',
                  g_ecb.ecb03 CLIPPED,'+',g_ecb.ecb012 CLIPPED     #FUN-A60028 add g_ecb.ecb012
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.FUN-660091
        CALL cl_err3("ins","ecb_file",g_msg,"",SQLCA.sqlcode,"","",1) #FUN-660091
    ELSE
        MESSAGE 'ROW(',l_newno1 CLIPPED,') O.K'
        LET l_oldno1 = g_ecb.ecb01
        LET l_oldno2 = g_ecb.ecb02
        LET l_oldno3 = g_ecb.ecb03
        LET l_oldno4 = g_ecb.ecb012   #FUN-A60028 add
        SELECT ecb_file.* INTO g_ecb.* FROM ecb_file
         WHERE ecb01 = l_newno1 
           AND ecb02 = l_newno2 
           AND ecb03 = l_newno3
           AND ecb012= l_newno4   #FUN-A60028 add
        CALL  i610_u()
        CALL i610_show()
#TQC-B30174--begin
        SELECT COUNT(*) INTO g_cnt FROM ecu_file
         WHERE ecu01 = l_newno1 
           AND ecu02 = l_newno2
           AND ecu012= l_newno4 
           AND ecuacti = 'Y'  #CHI-C90006
        IF g_cnt=0 THEN
           INITIALIZE g_ecu.* TO NULL
           LET g_ecu.ecu01  = l_newno1
           LET g_ecu.ecu02  = l_newno2     
           LET g_ecu.ecu012 = l_newno4
           IF cl_null(g_ecu.ecu012) THEN 
              LET g_ecu.ecu012 = ' ' 
           END IF         
           LET g_ecu.ecu014 = g_ecu014
           LET g_ecu.ecuacti='Y'
           LET g_ecu.ecu10='N'   
           LET g_ecu.ecuuser=g_user
           LET g_ecu.ecugrup=g_grup
           LET g_ecu.ecudate=g_today
           LET g_ecu.ecuoriu = g_user      
           LET g_ecu.ecuorig = g_grup    
           
           INSERT INTO ecu_file VALUES(g_ecu.*)
           IF STATUS OR SQLCA.SQLERRD[3]=0
              THEN
              CALL cl_err3("ins","ecu_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","ins ecu",1) #FUN-660091
           END IF
        ELSE         
           UPDATE ecu_file SET ecu014=g_ecu014,
                               ecudate = g_today     #FUN-C40008 add
            WHERE ecu01 = l_newno1 AND ecu02=l_newno2
              AND ecu012= l_newno4   
           IF STATUS OR SQLCA.SQLERRD[3]=0
              THEN
              CALL cl_err3("upd","ecu_file",g_ecb.ecb01,g_ecb.ecb02,STATUS,"","upd ecu",1) #FUN-660091
           END IF
        END IF 
#TQC-B30174--end   
        #FUN-C30027---begin           
        #LET g_ecb.ecb01 = l_oldno1
        #LET g_ecb.ecb02 = l_oldno2
        #LET g_ecb.ecb03 = l_oldno3
        #LET g_ecb.ecb012= l_oldno4    #FUN-A60028 add
        #SELECT ecb_file.* INTO g_ecb.* FROM ecb_file
        # WHERE ecb01 = g_ecb.ecb01 
        #   AND ecb02 = g_ecb.ecb02 
        #   AND ecb03 = g_ecb.ecb03
        #   AND ecb012= g_ecb.ecb012     #FUN-A60028 add
        #FUN-C30027---end
        CALL i610_show()
        CALL i610_chk_ecu()
    END IF
    DISPLAY BY NAME g_ecb.ecb01
    DISPLAY BY NAME g_ecb.ecb02
    DISPLAY BY NAME g_ecb.ecb03
    DISPLAY BY NAME g_ecb.ecb012 #FUN-A60028 
END FUNCTION
 
FUNCTION i610_chk_ecu()
    SELECT COUNT(*) INTO g_cnt FROM ecu_file
     WHERE ecu01 = g_ecb.ecb01 
       AND ecu02 = g_ecb.ecb02
       AND ecu012= g_ecb.ecb012   #FUN-A60028 add
       AND ecuacti = 'Y'  #CHI-C90006
    IF g_cnt=0 THEN
       INITIALIZE g_ecu.* TO NULL
       LET g_ecu.ecu01  = g_ecb.ecb01
       LET g_ecu.ecu02  = g_ecb.ecb02
#FUN-A60028 --begin--       
       LET g_ecu.ecu012 = g_ecb.ecb012  
       IF cl_null(g_ecu.ecu012) THEN 
          LET g_ecu.ecu012 = ' ' 
       END IF         
       LET g_ecu.ecu014 = g_ecu014
#FUN-A60028 add       
       LET g_ecu.ecuacti='Y'
       LET g_ecu.ecu10='N'    #No.FUN-810017
       LET g_ecu.ecuuser=g_user
       LET g_ecu.ecugrup=g_grup
       LET g_ecu.ecudate=g_today
       LET g_ecu.ecuoriu = g_user      #No.FUN-980030 10/01/04
       LET g_ecu.ecuorig = g_grup      #No.FUN-980030 10/01/04
       
       INSERT INTO ecu_file VALUES(g_ecu.*)
       IF STATUS OR SQLCA.SQLERRD[3]=0
          THEN
#         CALL cl_err('ins ecu',STATUS,0) #No.FUN-660091
          CALL cl_err3("ins","ecu_file",g_ecu.ecu01,g_ecu.ecu02,STATUS,"","ins ecu",1) #FUN-660091
       END IF
    END IF
    SELECT MIN(ecb03),MAX(ecb03) INTO g_ecu.ecu04,g_ecu.ecu05
      FROM ecb_file
     WHERE ecb01 =g_ecb.ecb01 AND ecb02=g_ecb.ecb02
       AND ecb012=g_ecb.ecb012    #FUN-A60028 add
    IF g_ecu.ecu04 IS NULL THEN LET g_ecu.ecu04 = 0 END IF
    IF g_ecu.ecu05 IS NULL THEN LET g_ecu.ecu05 = 0 END IF
 
    UPDATE ecu_file SET ecu04=g_ecu.ecu04,
                        ecu05=g_ecu.ecu05,
                        ecudate = g_today     #FUN-C40008 add
     WHERE ecu01 = g_ecb.ecb01 AND ecu02=g_ecb.ecb02
       AND ecu012= g_ecb.ecb012   #FUN-A60028 add
    IF STATUS OR SQLCA.SQLERRD[3]=0
       THEN
#      CALL cl_err('upd ecu',STATUS,0) #No.FUN-660091
       CALL cl_err3("upd","ecu_file",g_ecb.ecb01,g_ecb.ecb02,STATUS,"","upd ecu",1) #FUN-660091
    END IF
END FUNCTION
 
FUNCTION i610_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680073 SMALLINT
        l_ecb    RECORD LIKE ecb_file.*,
        l_name          LIKE type_file.chr20,    #No.FUN-680073  VARCHAR(20),                # External(Disk) file name
        l_za05          LIKE type_file.chr1000,  #No.FUN-680073  VARCHAR(40)
        l_chr           LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1)
        l_ima02         LIKE ima_file.ima02,     #品名                            
        l_ima021        LIKE ima_file.ima021     #規格  
 
    IF cl_null(g_wc) THEN
       LET g_wc=" ecb01='",g_ecb.ecb01,"' AND",
                " ecb02='",g_ecb.ecb02,"' AND",
                " ecb03='",g_ecb.ecb03,"' AND",
                " ecb012= '",g_ecb.ecb012,"'"   #FUN-A60028 add
    END IF
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aeci610.out'
#   CALL cl_outnam('aeci610') RETURNING l_name     #No.FUN-760085
    CALL cl_del_data(l_table)                      #No.FUN-760085          
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aeci610' #No.FUN-760085 
    LET g_sql="SELECT * FROM ecb_file ",           # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i610_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i610_co                         # SCROLL CURSOR
        CURSOR FOR i610_p1
 
#   START REPORT i610_rep TO l_name                 #No.FUN-760085
 
    FOREACH i610_co INTO l_ecb.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    #No.FUN-760085---Begin
        SELECT ima02,ima021 INTO l_ima02,l_ima021 
          FROM ima_file WHERE ima01=l_ecb.ecb01          
    #   OUTPUT TO REPORT i610_rep(l_ecb.*)
        EXECUTE insert_prep USING l_ecb.ecb01,l_ima02,l_ima021,l_ecb.ecb02,
                                  l_ecb.ecb03,l_ecb.ecb06,l_ecb.ecb15,l_ecb.ecb16,
                                  l_ecb.ecbacti
    #No.FUN-760085---End
    END FOREACH
 
#   FINISH REPORT i610_rep        #No.FUN-760085
 
    CLOSE i610_co
    ERROR ""
#No.FUN-760085---Begin                                                          
    IF g_zz05 = 'Y' THEN        
       CALL  cl_wcchp(g_wc,'ecb01,ecb03,ecb06,ecb36,ecb07,,ecbacti')       
             RETURNING g_wc                                                        
       LET g_str = g_str CLIPPED,";", g_wc                                      
    END IF                                                                      
    LET g_str = g_wc                                                            
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
#   CALL cl_prt(l_name,' ','1',g_len)                                           
    CALL cl_prt_cs3('aeci610','aeci610',l_sql,g_str)                            
#No.FUN-760085---End           
END FUNCTION
#No.FUN-760085---Begin
{
REPORT i610_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1) 
        sr RECORD LIKE ecb_file.*,
        l_sw1,l_sw2     LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1) 
        l_ima02         LIKE ima_file.ima02,   #品名
        l_ima021        LIKE ima_file.ima021,  #規格   #FUN-5A0059
        l_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ecb01,sr.ecb02,sr.ecb03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
                 ,g_x[39] CLIPPED   #FUN-5A0059
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.ecb01
            LET l_sw1 = 'Y'
 
        BEFORE GROUP OF sr.ecb02
            LET l_sw2 = 'Y'
 
        ON EVERY ROW
           #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
            SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059
              FROM ima_file WHERE ima01=sr.ecb01
#           IF sr.ecbacti = 'N' THEN PRINT g_c[31],'*'; END IF     #No.TQC-6C0177
            IF sr.ecbacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF     #No.TQC-6C0177
            IF l_sw1 = 'Y' THEN
               PRINT COLUMN g_c[32],sr.ecb01,
                     COLUMN g_c[33],l_ima02;
               PRINT COLUMN g_c[34],l_ima021;   #FUN-5A0059
               LET l_sw1 = 'N'
            END IF
           #start FUN-5A0059
            IF l_sw2 = 'Y' THEN
               PRINT COLUMN g_c[35],sr.ecb02;
               LET l_sw2 = 'N'
            END IF
            PRINT COLUMN g_c[36],sr.ecb03 USING'###&', #FUN-590118
                  COLUMN g_c[37],sr.ecb06,
                  COLUMN g_c[38],sr.ecb15 USING'###############', #No.TQC-5C0005
                  COLUMN g_c[39],sr.ecb16 USING'###############' #No.TQC-5C0005
           #end FUN-5A0059
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               PRINT g_dash[1,g_len]
               CALL cl_prt_pos_wc(g_wc) #TQC-630166
              #IF g_wc[001,080] > ' ' THEN
	      #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
              #IF g_wc[071,140] > ' ' THEN
	      #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
              #IF g_wc[141,210] > ' ' THEN
	      #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
            END IF
            PRINT g_dash[1,g_len] #No.TQC-5C0005
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760085---End
FUNCTION i610_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ecb01,ecb02,ecb03,ecb012",TRUE)       #FUN-A60028 add ecb012
   END IF
END FUNCTION
 
FUNCTION i610_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ecb01,ecb02,ecb03,ecb012",FALSE)      #FUN-A60028 add ecb012
   END IF
END FUNCTION
 


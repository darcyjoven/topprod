# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aqct710.4gl
# Descriptions...: 倉庫檢驗申請單維護作業
# Date & Author..: 05/12/20 By yoyo
# Modify.........: No.TQC-630018 06/03/06 By Elva 數量未show
# Modify.........: No.TQC-630181 06/03/26 By ching qsa01 set input format
# Modify.........: No.FUN-630051 06/03/21 By day  增加傳參數跑多單位檢驗申請作業aqct720    
# Modify.........: No.FUN-590083 06/03/30 BY Alexstar 新增資料多語言功能    
# Modify.........: No.FUN-640193 06/04/14 By Carrier 合并aqct710/aqct720,使檢驗申請的入口程序為一支
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680010 06/08/28 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: NO.FUN-680104 06/09/19 By douzh 類型轉換
# Modify.........: No.FUN-690022 06/09/22 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/22 By jamie 判斷pmcacti
# Modify.........: Mo.FUN-6A0071 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0178 06/11/24 By kim 已經存在 aqct700 的單子,應該不能再做取消確認的動作
# Modify.........: No.TQC-710032 07/01/15 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-6A0061 07/05/28 By kim 送驗單號自動給號的功能
# Modify.........: No.TQC-750256 07/06/04 By rainy 倉庫開窗應帶出該料的倉庫就好了
#                                                  列印串到aqcr720時，不要再開QBE視窗 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/23 By TSD.Wind 自定欄位功能修改
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-950129 09/06/05 By chenmoyan 倉庫的開窗default值有誤
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980139 09/08/19 By Smapmin 調整複製段程式 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0049 10/10/21 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0078 10/11/17 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No.MOD-B50199 11/05/23 By zhangll 材料檢驗類型判斷修正 
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.TQC-B80258 11/08/31 By lilingyu 單頭狀態頁簽,有欄位不可下查詢條件
# Modify.........: No.FUN-BB0085 11/12/15 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_qsa       RECORD LIKE qsa_file.*,
       g_qsa_t     RECORD LIKE qsa_file.*,  #備份舊值
       g_qsa01_t   LIKE qsa_file.qsa01,     #Key值備份
       g_img09     LIKE img_file.img09,
       g_wc        LIKE type_file.chr1000,  #儲存 user 的查詢條件  #No.FUN-680104 VARCHAR(1000)
       g_sql       STRING                  #組 sql 用
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5    #判斷是否已執行 Before Input指令  #No.FUN-680104 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_i                   LIKE type_file.num5    #count/index for any purpose      #No.FUN-680104 SMALLINT
DEFINE g_msg                 LIKE ze_file.ze03      #No.FUN-680104 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE g_row_count           LIKE type_file.num10   #總筆數              #No.FUN-680104 INTEGER
DEFINE g_jump                LIKE type_file.num10   #查詢指定的筆數      #No.FUN-680104 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5    #是否開啟指定筆視窗  #No.FUN-680104 SMALLINT   #No.FUN-6A0071
#No.FUN-630051--begin
DEFINE g_argv1   LIKE qsa_file.qsa01 
DEFINE g_ima906  LIKE ima_file.ima906 
DEFINE g_ima907  LIKE ima_file.ima907 
DEFINE g_flag    LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
DEFINE g_change  LIKE type_file.chr1    #No.FUN-680104 VARCHAR(01)
DEFINE g_factor  LIKE qsa_file.qsa31
DEFINE g_buf     LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(40)
#No.FUN-630051--end  
DEFINE g_t1      LIKE type_file.chr5  #CHI-6A0061
DEFINE li_result LIKE type_file.num5  #TQC-980139
DEFINE g_qsa30_t LIKE qsa_file.qsa30  #FUN-BB0085
DEFINE g_qsa33_t LIKE qsa_file.qsa33  #FUN-BB0085
 
MAIN
   DEFINE
       p_row,p_col     LIKE type_file.num5   #No.FUN-680104 SMALLINT
#       l_time       LIKE type_file.chr8              #No.FUN-6A0085
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
 
   #No.FUN-640193  -Begin
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0085
   INITIALIZE g_qsa.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM qsa_file WHERE qsa01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t710_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW t710_w AT p_row,p_col WITH FORM "aqc/42f/aqct710"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL t710_ui_set()
   #No.FUN-640193  -End  
 
   LET g_action_choice = ""
   CALL t710_menu()
 
   CLOSE WINDOW t710_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0085
END MAIN
 
FUNCTION t710_curs()
DEFINE ls STRING
 
    CLEAR FORM
    INITIALIZE g_qsa.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        qsa01,qsa11,qsa02,qsa03,qsa04,qsa05,qsa10,
        qsa12,qsa06,qsa33,qsa34,qsa35,qsa30,qsa31,qsa32,qsa08,qsaspc,qsa07,  #No.FUN-630051 #FUN-680010
        qsauser,qsagrup,
        qsaoriu,qsaorig,                   #TQC-B80258
        qsamodu,qsadate,qsaacti,
        #FUN-840068   ---start---
        qsaud01,qsaud02,qsaud03,qsaud04,qsaud05,
        qsaud06,qsaud07,qsaud08,qsaud09,qsaud10,
        qsaud11,qsaud12,qsaud13,qsaud14,qsaud15
        #FUN-840068    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qsa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_qsa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa01
                 NEXT FIELD qsa01
               WHEN INFIELD(qsa02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_img9"
                 LET g_qryparam.multiret_index='1'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa02
                 NEXT FIELD qsa02
              WHEN INFIELD(qsa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_img9"
                 LET g_qryparam.multiret_index='2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa03
                 NEXT FIELD qsa03
              WHEN INFIELD(qsa04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_img9"
                 LET g_qryparam.multiret_index='3'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa04
                 NEXT FIELD qsa04
              WHEN INFIELD(qsa05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_img9"
                 LET g_qryparam.multiret_index='4'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa05
                 NEXT FIELD qsa05
              WHEN INFIELD(qsa12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa12
                 NEXT FIELD qsa12
              #No.FUN-630051--begin
              WHEN INFIELD(qsa33)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa33
                 NEXT FIELD qsa33
              WHEN INFIELD(qsa30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qsa30
                 NEXT FIELD qsa30
              #No.FUN-630051--end  
              OTHERWISE
                 EXIT CASE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND qsauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND qsagrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND qsagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qsauser', 'qsagrup')
    #End:FUN-980030
    #No.FUN-640193  --Begin
    LET g_sql="SELECT qsa01 FROM qsa_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY qsa01"
    PREPARE t710_prepare FROM g_sql
    DECLARE t710_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t710_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM qsa_file WHERE ",g_wc CLIPPED
    #No.FUN-640193  --End   
    PREPARE t710_precount FROM g_sql
    DECLARE t710_count CURSOR FOR t710_precount
END FUNCTION
 
FUNCTION t710_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-680104 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t710_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t710_q()
            END IF
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t710_y()
               CALL cl_set_field_pic(g_qsa.qsa08,"","","","",g_qsa.qsaacti)
            END IF
        ON ACTION unconfirm
            LET g_action_choice="unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t710_n()
               CALL cl_set_field_pic(g_qsa.qsa08,"","","","",g_qsa.qsaacti)
            END IF
        ON ACTION next
            CALL t710_fetch('N')
        ON ACTION previous
            CALL t710_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t710_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t710_x()
                 CALL cl_set_field_pic(g_qsa.qsa08,"","","","",g_qsa.qsaacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t710_r()
            END IF
        ON ACTION reproduce
             LET g_action_choice="reproduce"
             IF cl_chk_act_auth() THEN
                  CALL t710_copy()
             END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t710_fetch('/')
        ON ACTION first
            CALL t710_fetch('F')
        ON ACTION last
            CALL t710_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-590083 
            CALL t710_ui_set()   #TQC-710032
        ON ACTION output
            CALL t710_out()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_qsa.qsa01 IS NOT NULL THEN
                 LET g_doc.column1 = "qsa01"
                 LET g_doc.value1 = g_qsa.qsa01
                 CALL cl_doc()
              END IF
           END IF
       #FUN-680010-----start
     #@ON ACTION 拋轉至SPC
       ON ACTION trans_spc                     
          LET g_action_choice="trans_spc"
          IF cl_chk_act_auth() THEN
             CALL t710_spc()
          END IF
       #FUN-680010-----end
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t710_cs
END FUNCTION
 
 
FUNCTION t710_a()
    DEFINE li_result LIKE type_file.num5 #CHI-6A0061
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_qsa.* LIKE qsa_file.*
    LET g_qsa01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_qsa.qsauser = g_user
        LET g_qsa.qsaoriu = g_user #FUN-980030
        LET g_qsa.qsaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_qsa.qsagrup = g_grup               #使用者所屬群
        LET g_qsa.qsadate = g_today
        LET g_qsa.qsa10 = 'Y'
        LET g_qsa.qsaacti = 'Y'
        LET g_qsa.qsa08 = 'N'
        LET g_qsa.qsaspc ='0'         #FUN-680010
        LET g_qsa.qsa11 = g_today
        #No.FUN-630051--begin
        #IF g_argv1 = '1' THEN LET g_qsa.qsa14 = 1 END IF #No.FUN-640193
        #IF g_argv1 = '2' THEN LET g_qsa.qsa14 = 2 END IF #No.FUN-640193
        LET g_change = 'N'
        #No.FUN-630051--end  
        CALL t710_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_qsa.* TO NULL
            LET INT_FLAG = 0
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_qsa.qsa01 IS NULL  THEN
           CONTINUE WHILE
        END IF
        IF cl_null(g_qsa.qsa04) THEN LET g_qsa.qsa04=' ' END IF #TQC-630018
        IF cl_null(g_qsa.qsa05) THEN LET g_qsa.qsa05=' ' END IF #TQC-630018
        #CHI-6A0061#CHI-6A0061............begin 
        BEGIN WORK 
        CALL s_auto_assign_no("aqc",g_qsa.qsa01,g_qsa.qsa11,"2","qsa_file","qsa01","","","")
                    RETURNING li_result,g_qsa.qsa01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_qsa.qsa01
        #CHI-6A0061#CHI-6A0061............end
        LET g_qsa.qsalegal = g_legal #FUN-980007
        LET g_qsa.qsaplant = g_plant #FUN-980007
        INSERT INTO qsa_file VALUES(g_qsa.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("ins","qsa_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
            ROLLBACK WORK #CHI-6A0061
            CONTINUE WHILE
        ELSE
            COMMIT WORK #CHI-6A0061
            SELECT qsa01 INTO g_qsa.qsa01 FROM qsa_file
                     WHERE qsa01 = g_qsa.qsa01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t710_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
            l_flag    LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
            l_ima02   LIKE ima_file.ima02,
            l_ima021  LIKE ima_file.ima021,
            l_ima109  LIKE ima_file.ima109,
            l_ima15   LIKE ima_file.ima15,
            l_img09   LIKE img_file.img09,
            l_azf03   LIKE azf_file.azf03,
            l_img10   LIKE img_file.img10,
            l_pmc03   LIKE pmc_file.pmc03,
            l_pmh05   LIKE pmh_file.pmh05,
            l_input   LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
            l_n       LIKE type_file.num5,    #No.FUN-680104 SMALLINT
            l_edate   LIKE type_file.dat,     #No.FUN-680104 DATE
            l_bdate   LIKE type_file.dat,     #No.FUN-680104 DATE
            g_n       LIKE type_file.num5,    #No.FUN-680104 SMALLINT
            l_n1      LIKE type_file.num5     #No.FUN-680104 SMALLINT
   #No.FUN-630051--begin
   DEFINE   l_imgg10  LIKE imgg_file.imgg10    
   DEFINE   g_tot     LIKE qsa_file.qsa32      
   DEFINE   a         LIKE qsa_file.qsa32      
   DEFINE   b         LIKE qsa_file.qsa32      
   DEFINE   c         LIKE qsa_file.qsa30      
   DEFINE   d         LIKE qsa_file.qsa30      
   DEFINE   l_fac     LIKE qsa_file.qsa31      
   #No.FUN-630051--end  
   DEFINE li_result   LIKE type_file.num5 #CHI-6A0061
   DEFINE l_tf        LIKE type_file.chr1  #FUN-BB0085
 
   DISPLAY BY NAME
        g_qsa.qsa01,g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05,
        g_qsa.qsa06,g_qsa.qsa07,g_qsa.qsa08,g_qsa.qsaspc,g_qsa.qsa10,g_qsa.qsa11, #FUN-680010
        g_qsa.qsa12,g_qsa.qsauser,g_qsa.qsagrup,
        g_qsa.qsa33,g_qsa.qsa34,g_qsa.qsa35,  #No.FUN-630051
        g_qsa.qsa30,g_qsa.qsa31,g_qsa.qsa32,  #No.FUN-630051
        g_qsa.qsamodu,g_qsa.qsadate,g_qsa.qsaacti
 
   INPUT BY NAME g_qsa.qsaoriu,g_qsa.qsaorig,
        g_qsa.qsa01,g_qsa.qsa11,g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05,
        g_qsa.qsa10,g_qsa.qsa12,g_qsa.qsa06,g_qsa.qsa33,g_qsa.qsa34,g_qsa.qsa35,   #No.FUN-630051
        g_qsa.qsa30,g_qsa.qsa31,g_qsa.qsa32,g_qsa.qsa07,   #No.FUN-630051
        #FUN-840068     ---start---
        g_qsa.qsaud01,g_qsa.qsaud02,g_qsa.qsaud03,g_qsa.qsaud04,
        g_qsa.qsaud05,g_qsa.qsaud06,g_qsa.qsaud07,g_qsa.qsaud08,
        g_qsa.qsaud09,g_qsa.qsaud10,g_qsa.qsaud11,g_qsa.qsaud12,
        g_qsa.qsaud13,g_qsa.qsaud14,g_qsa.qsaud15 
        #FUN-840068     ----end----
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t710_set_entry(p_cmd)
          CALL t710_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("qsa01")  #TQC-630181
 
      AFTER FIELD qsa01
         #CHI-6A0061..............begin
         #IF NOT cl_null(g_qsa.qsa01) THEN
         #   IF p_cmd="a" OR (p_cmd="u" AND g_qsa.qsa01!=g_qsa01_t) THEN
         #      SELECT count(*) INTO g_n FROM qsa_file
         #       WHERE qsa01 = g_qsa.qsa01
         #      IF g_n>0 THEN
         #         CALL cl_err(g_qsa.qsa01,-239,1)
         #         LET g_qsa.qsa01 = g_qsa01_t
         #         DISPLAY BY NAME g_qsa.qsa01
         #         NEXT FIELD qsa01
         #      END IF
         #   END IF
         #END IF
         IF (NOT cl_null(g_qsa.qsa01)) AND 
            (g_qsa.qsa01!=g_qsa_t.qsa01 OR 
            cl_null(g_qsa_t.qsa01)) THEN
           #LET g_t1 = s_get_doc_no(g_qsa.qsa01)  #FUN-B50026 mark
           #CALL s_check_no("aqc",g_t1,"","2","qsa_file","qsa01","")
            CALL s_check_no("aqc",g_qsa.qsa01,g_qsa_t.qsa01,"2","qsa_file","qsa01","") #FUN-B50026 mod
                 RETURNING li_result,g_qsa.qsa01
            IF (NOT li_result) THEN
               NEXT FIELD qsa01
            END IF
         END IF
         #CHI-6A0061..............end
 
      #No.FUN-630051--begin
      BEFORE FIELD qsa02
         CALL t710_set_entry_1()
         CALL t710_set_no_required()
      #No.FUN-630051--end
      
      AFTER FIELD qsa02
         IF NOT cl_null(g_qsa.qsa02) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_qsa.qsa02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_qsa.qsa02= g_qsa_t.qsa02
               NEXT FIELD qsa02
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            #No.FUN-630051--begin
            IF cl_null(g_qsa_t.qsa02) OR g_qsa.qsa02 <> g_qsa_t.qsa02 THEN
               LET g_change = 'Y'
            END IF
            #No.FUN-630051--end
            SELECT count(*) INTO g_n FROM ima_file
             WHERE ima01=g_qsa.qsa02
            IF g_n=0 THEN
               CALL cl_err('','aqc-714',0)
               NEXT FIELD qsa02
            END IF
            #No.FUN-630051--begin
            LET g_ima906 = NULL LET g_ima907 = NULL
            #No.FUN-640193  --Begin
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_qsa.qsa02)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD qsa02
               END IF
               IF g_ima906 = '3' THEN
                  LET g_qsa.qsa33 = g_ima907
                  DISPLAY BY NAME g_qsa.qsa33
               END IF
            END IF
            #No.FUN-640193  --End  
            #No.FUN-630051--end  
            CALL t710_qsa02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('qsa02:',g_errno,1)
               DISPLAY BY NAME g_qsa.qsa02
               NEXT FIELD qsa02
            END IF
         END IF
         #No.FUN-630051--begin
         CALL t710_set_no_entry_1()
         CALL t710_set_required()
         #No.FUN-630051--end
         
      AFTER FIELD qsa03
         IF NOT cl_null(g_qsa.qsa03) THEN
            #No.FUN-630051--begin
            IF cl_null(g_qsa_t.qsa03) OR g_qsa_t.qsa03 <> g_qsa.qsa03 THEN
               LET g_change='Y'
            END IF
            #No.FUN-630051--end
            SELECT count(*) INTO g_n FROM imd_file
             WHERE imd01 = g_qsa.qsa03
            IF g_n = 0 THEN
               CALL cl_err('qsa03:','aqc-711',0)
               NEXT FIELD qsa03
            END IF
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(g_qsa.qsa03) THEN
               NEXT FIELD qsa03
            END IF 
            #No.FUN-AA0049--end            
         END IF
 
      AFTER FIELD qsa04
         IF g_qsa.qsa04 IS NULL THEN
            LET g_qsa.qsa04 = ' '
         END IF
         #No.FUN-630051--begin
         IF cl_null(g_qsa_t.qsa04) OR g_qsa_t.qsa04 <> g_qsa.qsa04 THEN
            LET g_change='Y'
         END IF
         #No.FUN-630051--end

      AFTER FIELD qsa05
         IF g_qsa.qsa05 IS NULL THEN
            LET g_qsa.qsa05 = ' '
         END IF
         #No.FUN-630051--begin
         IF cl_null(g_qsa_t.qsa05) OR g_qsa_t.qsa05 <> g_qsa.qsa05 THEN
            LET g_change='Y'
         END IF
         #No.FUN-630051--end
         IF (NOT cl_null(g_qsa.qsa02)) AND (NOT cl_null(g_qsa.qsa03))
             AND (g_qsa.qsa04 IS NOT NULL) AND (g_qsa.qsa05 IS NOT NULL) THEN
                SELECT count(*) INTO l_n FROM img_file
                WHERE img01 = g_qsa.qsa02
                  AND img02 = g_qsa.qsa03
                  AND img03 = g_qsa.qsa04
                  AND img04 = g_qsa.qsa05
               IF l_n = 0 THEN
                  CALL cl_err('','aqc-717',1)
                  NEXT FIELD qsa03
               END IF
               #No.FUN-630051--begin
               LET l_n = 0  
               SELECT img09,img10 INTO l_img09,l_img10 FROM img_file 
               WHERE img01 = g_qsa.qsa02
                 AND img02 = g_qsa.qsa03
                 AND img03 = g_qsa.qsa04
                 AND img04 = g_qsa.qsa05
               IF g_sma.sma115 = 'N' THEN   #No.FUN-640193
                  IF p_cmd = 'a' OR 
                    (g_qsa.qsa05 != g_qsa_t.qsa05 OR
                     g_qsa.qsa04 != g_qsa_t.qsa04 OR
                     g_qsa.qsa02 != g_qsa_t.qsa02 OR
                     g_qsa.qsa03 != g_qsa_t.qsa03)  THEN    
#No.FUN-640193--begin
                     IF cl_null(g_qsa.qsa06) THEN
                        LET g_qsa.qsa06 = l_img10
                        LET g_qsa.qsa06 = s_digqty(g_qsa.qsa06,l_img09)     #FUN-BB0085
                        DISPLAY l_img09 TO img09
                        DISPLAY BY NAME g_qsa.qsa06   #TQC-630018
                     END IF  
#No.FUN-640193--end   
                  END IF  
               END IF 
               IF g_sma.sma115 = 'Y' THEN   #No.FUN-640193
                  IF p_cmd = 'a' OR 
                     (g_qsa.qsa05 != g_qsa_t.qsa05 OR
                      g_qsa.qsa04 != g_qsa_t.qsa04 OR
                      g_qsa.qsa03 != g_qsa_t.qsa03 OR
                      g_qsa.qsa02 != g_qsa_t.qsa02) THEN
                      CALL t710_du_default(p_cmd)
                  END IF
                  DISPLAY BY NAME g_qsa.qsa33,g_qsa.qsa34,g_qsa.qsa35
                  DISPLAY BY NAME g_qsa.qsa30,g_qsa.qsa31,g_qsa.qsa32
                  #No.FUN-630051--end  
             END IF
          END IF
 
      AFTER FIELD qsa06
         #FUN-BB0085-add-str--
         IF NOT cl_null(g_qsa.qsa06) THEN
            SELECT img09 INTO l_img09  FROM img_file
             WHERE img01 = g_qsa.qsa02
               AND img02 = g_qsa.qsa03
               AND img03 = g_qsa.qsa04
               AND img04 = g_qsa.qsa05            
            LET g_qsa.qsa06 = s_digqty(g_qsa.qsa06,l_img09)
            DISPLAY BY NAME g_qsa.qsa06
         END IF  
         #FUN-BB0085-add-end--
         IF NOT cl_null(g_qsa.qsa06) THEN
            IF g_qsa.qsa06 <= 0 THEN
               LET g_qsa.qsa06 = NULL
               NEXT FIELD qsa06
            END IF
            SELECT img10 INTO l_img10  FROM img_file
             WHERE img01 = g_qsa.qsa02
               AND img02 = g_qsa.qsa03
               AND img03 = g_qsa.qsa04
               AND img04 = g_qsa.qsa05
            IF l_img10 < g_qsa.qsa06 THEN
               CALL cl_err('','aqc-712',0)
               NEXT FIELD qsa06
            END IF
         END IF
 
     #No.FUN-630051--begin
     BEFORE FIELD qsa33
        CALL t710_set_no_required()
 
     AFTER FIELD qsa33
        IF cl_null(g_qsa.qsa02) THEN NEXT FIELD qsa02 END IF
        LET l_tf = NULL #FUN-BB0085
        IF g_qsa.qsa03 IS NULL OR g_qsa.qsa04 IS NULL OR
           g_qsa.qsa05 IS NULL THEN
           NEXT FIELD qsa03 
        END IF
        IF NOT cl_null(g_qsa.qsa33) THEN                              
           SELECT gfe02 INTO g_buf FROM gfe_file                             
            WHERE gfe01=g_qsa.qsa33
              AND gfeacti='Y'                                                
           IF STATUS THEN                                                    
#             CALL cl_err('gfe:',STATUS,0)                                      #No.FUN-660115
              CALL cl_err3("sel","gfe_file",g_qsa.qsa33,"",STATUS,"","gfe",1)  #No.FUN-660115
              NEXT FIELD qsa33
           END IF  
           CALL s_du_umfchk(g_qsa.qsa02,'','','',
                            l_img09,g_qsa.qsa33,g_ima906)
                RETURNING g_errno,g_factor
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_qsa.qsa33,g_errno,0)
              NEXT FIELD qsa33
           END IF
           LET g_qsa.qsa34 = g_factor
           CALL s_chk_imgg(g_qsa.qsa02,g_qsa.qsa03,
                           g_qsa.qsa04,g_qsa.qsa05,
                           g_qsa.qsa33) RETURNING g_flag
           IF g_flag = 1 THEN
              CALL cl_err(g_qsa.qsa33,'afa-319',0)
              NEXT FIELD qsa33
           END IF
           CALL t710_qsa35_check() RETURNING l_tf   #FUN-BB0085
        END IF
        CALL t710_set_required()
        #FUN-BB0085-add-str--
        LET g_qsa33_t = g_qsa.qsa35
        IF NOT l_tf THEN 
           NEXT FIELD qsa35
        END IF 
        #FUN-BB0085-add-end--
            
     BEFORE FIELD qsa35  
        IF cl_null(g_qsa.qsa02) THEN NEXT FIELD qsa02 END IF
        IF g_qsa.qsa03 IS NULL OR g_qsa.qsa04 IS NULL OR
           g_qsa.qsa05 IS NULL THEN
           NEXT FIELD qsa05
        END IF
        IF NOT cl_null(g_qsa.qsa33) AND g_ima906 = '3' THEN
           CALL s_chk_imgg(g_qsa.qsa02,g_qsa.qsa03,
                           g_qsa.qsa04,g_qsa.qsa05,
                           g_qsa.qsa33) RETURNING g_flag
           IF g_flag = 1 THEN
              NEXT FIELD qsa02
           END IF
        END IF
        IF NOT cl_null(g_qsa.qsa33) THEN
           IF p_cmd = 'a' OR g_change='Y' THEN
              SELECT imgg10 INTO g_qsa.qsa35 FROM imgg_file
               WHERE imgg01 = g_qsa.qsa02
                 AND imgg02 = g_qsa.qsa03
                 AND imgg03 = g_qsa.qsa04
                 AND imgg04 = g_qsa.qsa05
                 AND imgg09 = g_qsa.qsa33
           END IF
        END IF
 
     AFTER FIELD qsa35
        IF NOT t710_qsa35_check() THEN NEXT FIELD qsa35 END IF     #FUN-BB0085
        #FUN-BB0085-mark--str--
        #IF NOT cl_null(g_qsa.qsa35) THEN                              
        #   IF g_qsa.qsa35 < 0 THEN                                    
        #      CALL cl_err('','aim-391',0)
        #      NEXT FIELD qsa35                                              
        #   END IF                                                            
        #   SELECT imgg10 INTO l_imgg10
        #     FROM imgg_file 
        #    WHERE imgg01 = g_qsa.qsa02
        #      AND imgg02 = g_qsa.qsa03
        #      AND imgg03 = g_qsa.qsa04
        #      AND imgg04 = g_qsa.qsa05
        #      AND imgg09 = g_qsa.qsa33
        #   IF g_qsa.qsa35 > l_imgg10 THEN
        #      CALL cl_err('','asf-375',0)
        #      NEXT FIELD qsa35
        #   END IF
        #   IF g_ima906='3' THEN
        #      IF cl_null(g_qsa.qsa32) OR g_qsa.qsa32=0 OR
        #         g_qsa.qsa35 <> g_qsa_t.qsa35 OR cl_null(g_qsa_t.qsa35) THEN
        #         LET l_fac = 1
        #         CALL s_umfchk(g_qsa.qsa02,g_qsa.qsa33,g_qsa.qsa30)
        #              RETURNING g_cnt,l_fac
        #         IF g_cnt = 1 THEN
        #            LET l_fac = 1
        #         END IF
        #         LET g_qsa.qsa32=g_qsa.qsa35*l_fac
        #         DISPLAY BY NAME g_qsa.qsa32
        #      END IF
        #   END IF
        #END IF                 
        #FUN-BB0085-mark--end-- 
 
     BEFORE FIELD qsa30
        CALL t710_set_no_required()
 
     AFTER FIELD qsa30
        IF cl_null(g_qsa.qsa02) THEN NEXT FIELD qsa02 END IF
        LET l_tf = NULL #FUN-BB0085
        IF g_qsa.qsa03 IS NULL OR g_qsa.qsa04 IS NULL OR
           g_qsa.qsa05 IS NULL THEN
           NEXT FIELD qsa05
        END IF
        IF NOT cl_null(g_qsa.qsa30) THEN                              
           SELECT gfe02 INTO g_buf FROM gfe_file                             
            WHERE gfe01=g_qsa.qsa30
              AND gfeacti='Y'                                                
           IF STATUS THEN                                                    
#             CALL cl_err('gfe:',STATUS,0)                                      #No.FUN-660115
              CALL cl_err3("sel","gfe_file",g_qsa.qsa30,"",STATUS,"","gfe",1)  #No.FUN-660115
              NEXT FIELD qsa30
           END IF      
           CALL s_du_umfchk(g_qsa.qsa02,'','','',
                            l_img09,g_qsa.qsa30,g_ima906)
                RETURNING g_errno,g_factor
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_qsa.qsa30,g_errno,0)
              NEXT FIELD qsa30
           END IF
           LET g_qsa.qsa31 = g_factor 
           IF g_ima906 = '2' THEN
              CALL s_chk_imgg(g_qsa.qsa02,g_qsa.qsa03,
                              g_qsa.qsa04,g_qsa.qsa05,
                              g_qsa.qsa30) RETURNING g_flag
              IF g_flag = 1 THEN
                 CALL cl_err(g_qsa.qsa30,'afa-319',0)
                 NEXT FIELD qsa30         
              END IF
              IF g_qsa.qsa30 != g_qsa_t.qsa30 OR cl_null(g_qsa_t.qsa30) THEN
                 SELECT imgg10 INTO g_qsa.qsa32 FROM imgg_file
                  WHERE imgg01 = g_qsa.qsa02
                    AND imgg02 = g_qsa.qsa03
                    AND imgg03 = g_qsa.qsa04
                    AND imgg04 = g_qsa.qsa05
                    AND imgg09 = g_qsa.qsa30
              END IF
           END IF
           LET l_tf = ''
           CALL t710_qsa32_check(l_img10) RETURNING l_tf       #FUN-BB0085
        END IF
        CALL t710_set_required()
        CALL cl_show_fld_cont()  
        #FUN-BB0085-add-end-- 
        LET g_qsa30_t = g_qsa.qsa30
        IF NOT l_tf THEN 
           NEXT FIELD qsa32
        END IF 
        #FUN-BB0085-add-str--
           
     AFTER FIELD qsa31  
        IF NOT cl_null(g_qsa.qsa31) THEN                              
           IF g_qsa.qsa31=0 THEN                                      
              NEXT FIELD qsa31                                               
           END IF                                                            
        END IF      
    
     #No.FUN-640193  --Begin
     BEFORE FIELD qsa32
        IF g_ima906='3' AND NOT cl_null(g_qsa.qsa33) THEN
           IF cl_null(g_qsa.qsa32) OR g_qsa.qsa32=0 OR
              g_qsa.qsa30 <> g_qsa_t.qsa30 OR p_cmd = 'a'  THEN
              LET l_fac = 1
              CALL s_umfchk(g_qsa.qsa02,g_qsa.qsa33,g_qsa.qsa30)
                   RETURNING g_cnt,l_fac
              IF g_cnt = 1 THEN
                 LET l_fac = 1
              END IF
              LET g_qsa.qsa32=g_qsa.qsa35*l_fac
              DISPLAY BY NAME g_qsa.qsa32
           END IF
        END IF
     #No.FUN-640193  --End  
 
     AFTER FIELD qsa32 
        IF NOT t710_qsa32_check(l_img10) THEN NEXT FIELD qsa32 END IF    #FUN-BB0085
        #FUN-BB0085-mark--str-- 
        #IF NOT cl_null(g_qsa.qsa32) THEN
        #   IF g_qsa.qsa32 < 0 THEN
        #      CALL cl_err('','aim-391',0)  
        #      NEXT FIELD qsa32
        #   END IF
        #END IF
        #CALL t710_du_data_to_correct()
        #IF g_ima906 = '2' THEN
        #   LET l_imgg10 = 0
        #   SELECT imgg10 INTO l_imgg10
        #     FROM imgg_file 
        #    WHERE imgg01 = g_qsa.qsa02
        #      AND imgg02 = g_qsa.qsa03
        #      AND imgg03 = g_qsa.qsa04
        #      AND imgg04 = g_qsa.qsa05
        #      AND imgg09 = g_qsa.qsa30
        #   IF g_qsa.qsa32 > l_imgg10 THEN
        #      CALL cl_err('','asf-375',0)
        #      NEXT FIELD qsa32
        #   END IF
        #END IF
        #IF g_ima906 = '3' OR g_ima906 = '1' THEN  #No.FUN-640193
        #   IF g_qsa.qsa32 * g_qsa.qsa31 > l_img10 THEN
        #      CALL cl_err('','asf-375',0)
        #      NEXT FIELD qsa32
        #   END IF
        #END IF
        #FUN-BB0085-mark--end--
     #No.FUN-630051--end  
 
      AFTER FIELD qsa12
         IF NOT cl_null(g_qsa.qsa12) THEN
            SELECT count(*) INTO g_n FROM pmc_file
             WHERE pmc01 = g_qsa.qsa12
            IF g_n=0 THEN
               CALL cl_err('','aqc-713',0)
               NEXT FIELD qsa12
            END IF
            CALL t710_qsa12('d')
         END IF
 
      #FUN-840068     ---start---
      AFTER FIELD qsaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qsaud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840068     ----end----
 
      AFTER INPUT
         LET g_qsa.qsauser = s_get_data_owner("qsa_file") #FUN-C10039
         LET g_qsa.qsagrup = s_get_data_group("qsa_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            #No.FUN-630051--begin
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_qsa.qsa02)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD qsa02
               END IF
            END IF
            SELECT img09,img10 INTO l_img09,l_img10 FROM img_file
             WHERE img01=g_qsa.qsa02
               AND img02=g_qsa.qsa03
               AND img03=g_qsa.qsa04
               AND img04=g_qsa.qsa05
            IF cl_null(l_img09) THEN
               CALL cl_err(g_qsa.qsa02,'mfg6069',0)
               NEXT FIELD qsa02
            END IF
            IF g_sma.sma115 ='Y' THEN  #No.FUN-640193
               CALL t710_du_data_to_correct()
               IF NOT cl_null(g_qsa.qsa33) THEN
                  SELECT imgg10 INTO l_imgg10
                    FROM imgg_file 
                   WHERE imgg01 = g_qsa.qsa02
                     AND imgg02 = g_qsa.qsa03
                     AND imgg03 = g_qsa.qsa04
                     AND imgg04 = g_qsa.qsa05
                     AND imgg09 = g_qsa.qsa33
                  IF l_imgg10 < g_qsa.qsa35 THEN
                     CALL cl_err('','asf-375',0)
                     NEXT FIELD qsa35
                  END IF
               END IF
               IF g_ima906 = '2' THEN
                  IF NOT cl_null(g_qsa.qsa30) THEN
                     SELECT imgg10 INTO l_imgg10
                       FROM imgg_file 
                      WHERE imgg01 = g_qsa.qsa02
                        AND imgg02 = g_qsa.qsa03
                        AND imgg03 = g_qsa.qsa04
                        AND imgg04 = g_qsa.qsa05
                        AND imgg09 = g_qsa.qsa30
                     IF g_qsa.qsa32 > l_imgg10 THEN
                        CALL cl_err('','asf-375',0)
                        NEXT FIELD qsa32
                     END IF
                  END IF
               END IF
               IF g_ima906 = '3' OR g_ima906 ='1' THEN  #No.FUN-640193
                  IF g_qsa.qsa32 * g_qsa.qsa31 > l_img10 THEN
                     CALL cl_err('','asf-375',0)
                     NEXT FIELD qsa32
                  END IF       
               END IF
               CALL t710_set_origin_field()
            END IF
 
            LET g_qsa.qsa06 = s_digqty(g_qsa.qsa06,l_img09)     #FUN-BB0085
            IF g_qsa.qsa06 > l_img10 THEN
               CALL cl_err(g_qsa.qsa06,'aqc-712',0)
               NEXT FIELD qsa06
            END IF
            #No.FUN-630051--end  
 
       #MOD-650015 --start 
     # ON ACTION CONTROLO                        # 沿用所有欄位
     #    IF INFIELD(qsa01) THEN
     #       LET g_qsa.* = g_qsa_t.*
     #       CALL t710_show()
     #       NEXT FIELD qsa01
     #    END IF
       #MOD-650015 --end
 
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(qsa01) #單號
              LET g_t1 = s_get_doc_no(g_qsa.qsa01)
              CALL q_smy(FALSE,FALSE,g_t1,'AQC','2') RETURNING g_t1
              LET g_qsa.qsa01 = g_t1
              DISPLAY BY NAME g_qsa.qsa01
              NEXT FIELD qsa01
            WHEN INFIELD(qsa02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img9"
              LET g_qryparam.default1 = g_qsa.qsa02
              LET g_qryparam.where = " imgplant ='",g_plant CLIPPED,"'"  #No.FUN-AA0049
              CALL cl_create_qry() RETURNING g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05,g_img09
              CALL t710_qsa02('a')
              DISPLAY BY NAME g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05
 
              DISPLAY g_img09 TO FORMONLY.img09
              NEXT FIELD qsa02
            WHEN INFIELD(qsa03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img9"
            #TQC-750256 begin
              IF NOT cl_null(g_qsa.qsa02) THEN 
                #LET g_qryparam.where = " img01 ='", g_qsa.qsa02 CLIPPED,"'"  #No.FUN-AA0049
                LET g_qryparam.where = " img01 ='", g_qsa.qsa02 CLIPPED,"'AND imgplant='",g_plant,"' " #No.FUN-AA0049
              ELSE 
                 LET g_qryparam.where = " imgplant ='",g_plant CLIPPED,"'"  #No.FUN-AA0049
              END IF
            #TQC-750256 end
#             LET g_qryparam.default1 = g_qsa.qsa03  #No.TQC-950129
              LET g_qryparam.default1 = g_qsa.qsa02  #No.TQC-950129
              LET g_qryparam.default2 = g_qsa.qsa03  #No.TQC-950129
              CALL cl_create_qry() RETURNING g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05,g_img09
              DISPLAY BY NAME g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05
              DISPLAY g_img09 TO FORMONLY.img09
              NEXT FIELD qsa03
            WHEN INFIELD(qsa04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img9"
              LET g_qryparam.default1 = g_qsa.qsa04
              LET g_qryparam.where = " imgplant ='",g_plant CLIPPED,"'"  #No.FUN-AA0049
              CALL cl_create_qry() RETURNING g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05,g_img09
              DISPLAY BY NAME g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05
              DISPLAY g_img09 TO FORMONLY.img09
              NEXT FIELD qsa04
            WHEN INFIELD(qsa05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img9"
              LET g_qryparam.default1 = g_qsa.qsa05
              LET g_qryparam.where = " imgplant ='",g_plant CLIPPED,"'"  #No.FUN-AA0049
              CALL cl_create_qry() RETURNING g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05,g_img09
              DISPLAY BY NAME g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04,g_qsa.qsa05
              DISPLAY g_img09 TO FORMONLY.img09
              NEXT FIELD qsa05
            WHEN INFIELD(qsa12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmc"
              LET g_qryparam.default1 = g_qsa.qsa12
              CALL cl_create_qry() RETURNING g_qsa.qsa12
              CALL t710_qsa12('a')
              DISPLAY BY NAME g_qsa.qsa12
              NEXT FIELD qsa12
            #No.FUN-630051--begin
            WHEN INFIELD(qsa33)
              CALL q_imgg1(FALSE,FALSE,g_qsa.qsa02,g_qsa.qsa03, 
                                       g_qsa.qsa04,g_qsa.qsa05)
              RETURNING g_qsa.qsa33       
              DISPLAY BY NAME g_qsa.qsa33
              NEXT FIELD qsa33
            WHEN INFIELD(qsa30)
              IF g_ima906='2' THEN
                 CALL q_imgg1(FALSE,FALSE,g_qsa.qsa02,g_qsa.qsa03, 
                                          g_qsa.qsa04,g_qsa.qsa05)
                 RETURNING g_qsa.qsa30       
                 DISPLAY BY NAME g_qsa.qsa30
                 NEXT FIELD qsa30
              ELSE
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_qsa.qsa30
                CALL cl_create_qry() RETURNING g_qsa.qsa30
                DISPLAY BY NAME g_qsa.qsa30
                NEXT FIELD qsa30
              END IF
            #No.FUN-630051--end  
           OTHERWISE
              EXIT CASE
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
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
   END INPUT
END FUNCTION
 
FUNCTION t710_qsa02(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
   l_ima02    LIKE ima_file.ima02,
   l_ima021   LIKE ima_file.ima021,
   l_ima109   LIKE ima_file.ima109,
   l_azf03    LIKE azf_file.azf03,
   l_azfacti  LIKE azf_file.azfacti,
   l_ima15    LIKE ima_file.ima15,
   l_imaacti  LIKE ima_file.imaacti
 
 
   LET g_errno=''
   SELECT ima02,ima021,ima109,ima15,imaacti
     INTO l_ima02,l_ima021,l_ima109,l_ima15,l_imaacti
     FROM ima_file
    WHERE ima01=g_qsa.qsa02
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aqc-710'
                                LET l_ima02=NULL
                                LET l_ima021=NULL
                                LET l_ima109=NULL
                                LET l_ima15=NULL
       WHEN l_imaacti='N'       LET g_errno='9028'
     #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
     #FUN-690022------mod-------
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF NOT cl_null(l_ima109) THEN  #MOD-B50199 add
     #MOD-B50199 mod
     #SELECT azf03,azfacti INTO l_azf03,l_azfacti
     #  FROM azf_file,ima_file
     # WHERE azf01=ima109
     #   AND azf02='8'
     #   AND ima01=g_qsa.qsa02
      SELECT azf03,azfacti INTO l_azf03,l_azfacti
        FROM azf_file
       WHERE azf02='8'
         AND azf01=l_ima109
     #MOD-B50199 mod--end
      CASE
          WHEN SQLCA.sqlcode=100   LET g_errno='abg-002'
                                   LET l_azf03=NULL
          WHEN l_azfacti='N'       LET g_errno='9028'
          OTHERWISE
               LET g_errno=SQLCA.sqlcode USING '------'
      END  CASE
   END IF  #MOD-B50199 add
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_ima02 TO FORMONLY.ima02
      DISPLAY l_ima021 TO FORMONLY.ima021
      DISPLAY l_ima109 TO FORMONLY.ima109
      DISPLAY l_azf03 TO FORMONLY.azf03
      DISPLAY l_ima15 TO FORMONLY.ima15
   END IF
END FUNCTION
 
FUNCTION t710_qsa12(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
   l_pmc03    LIKE pmc_file.pmc03,
   l_pmh05    LIKE pmh_file.pmh05,
   l_pmhacti  LIKE pmh_file.pmhacti,
   l_pmcacti  LIKE pmc_file.pmcacti
 
   LET g_errno=''
   SELECT pmc03,pmcacti
     INTO l_pmc03,l_pmcacti
     FROM pmc_file
    WHERE pmc01=g_qsa.qsa12
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aqc-714'
                                LET l_pmc03=NULL
       WHEN l_pmcacti='N'       LET g_errno='9028'
     #FUN-690024------mod-------
       WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
     #FUN-690024------mod-------       
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
   SELECT pmh05,pmhacti
     INTO l_pmh05,l_pmhacti
     FROM pmh_file,aza_file
    WHERE pmh01=g_qsa.qsa02
      AND pmh02=g_qsa.qsa12
      AND pmh13=aza17
      AND pmh21 = " "                                             #CHI-860042                                                       
      AND pmh22 = '1'                                             #CHI-860042
      AND pmhacti = 'Y'                                           #CHI-910021
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aqc-714'
                                LET l_pmc03=NULL
       WHEN l_pmhacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_pmh05 TO FORMONLY.pmh05
   END IF
END FUNCTION
 
FUNCTION t710_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_qsa.* TO NULL            #No.FUN-6A0160
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t710_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t710_count
    FETCH t710_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t710_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)
        INITIALIZE g_qsa.* TO NULL
    ELSE
        CALL t710_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t710_fetch(p_flqsa)
    DEFINE
        p_flqsa   LIKE type_file.chr1     #No.FUN-680104 VARCHAR(1)
 
    CASE p_flqsa
        WHEN 'N' FETCH NEXT     t710_cs INTO g_qsa.qsa01
        WHEN 'P' FETCH PREVIOUS t710_cs INTO g_qsa.qsa01
        WHEN 'F' FETCH FIRST    t710_cs INTO g_qsa.qsa01
        WHEN 'L' FETCH LAST     t710_cs INTO g_qsa.qsa01
        WHEN '/'
            IF (NOT mi_no_ask) THEN    #No.FUN-6A0071
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt mod
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                   ON ACTION about
                      CALL cl_about()
 
                   ON ACTION help
                      CALL cl_show_help()
 
                   ON ACTION controlg
                      CALL cl_cmdask()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t710_cs INTO g_qsa.qsa01
            LET mi_no_ask = FALSE    #No.FUN-6A0071
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)
        INITIALIZE g_qsa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flqsa
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_qsa.* FROM qsa_file    # 重讀DB,因TEMP有不被更新特性
       WHERE qsa01 = g_qsa.qsa01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)   #No.FUN-660115
        CALL cl_err3("sel","qsa_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
    ELSE
        LET g_data_owner=g_qsa.qsauser
        LET g_data_group=g_qsa.qsagrup
        LET g_data_plant = g_qsa.qsaplant #FUN-980030
        CALL t710_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t710_show()
DEFINE    l_img09     LIKE img_file.img09  #TQC-630018
    LET g_qsa_t.* = g_qsa.*
    DISPLAY BY NAME g_qsa.qsa01,g_qsa.qsa02,g_qsa.qsa03,g_qsa.qsa04, g_qsa.qsaoriu,g_qsa.qsaorig,
                    g_qsa.qsa05,g_qsa.qsa06,g_qsa.qsa07,g_qsa.qsa08,g_qsa.qsaspc, #FUN-680010
                    g_qsa.qsa10,g_qsa.qsa11,g_qsa.qsa12,g_qsa.qsauser,
                    g_qsa.qsagrup,g_qsa.qsamodu,g_qsa.qsadate,
                    g_qsa.qsa33,g_qsa.qsa34,g_qsa.qsa35,  #No.FUN-630051
                    g_qsa.qsa30,g_qsa.qsa31,g_qsa.qsa32,  #No.FUN-630051
                    g_qsa.qsaacti,
                    #FUN-840068     ---start---
                    g_qsa.qsaud01,g_qsa.qsaud02,g_qsa.qsaud03,g_qsa.qsaud04,
                    g_qsa.qsaud05,g_qsa.qsaud06,g_qsa.qsaud07,g_qsa.qsaud08,
                    g_qsa.qsaud09,g_qsa.qsaud10,g_qsa.qsaud11,g_qsa.qsaud12,
                    g_qsa.qsaud13,g_qsa.qsaud14,g_qsa.qsaud15 
                    #FUN-840068     ----end----
    CALL t710_qsa02('d')
    CALL t710_qsa12('d')
    #TQC-630018  --begin
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = g_qsa.qsa02
       AND img02 = g_qsa.qsa03
       AND img03 = g_qsa.qsa04
       AND img04 = g_qsa.qsa05
    DISPLAY l_img09 TO img09
    #TQC-630018  --end
    CALL cl_set_field_pic(g_qsa.qsa08,"","","","",g_qsa.qsaacti)
    CALL cl_show_fld_cont()                   #No.FUN-590083 
END FUNCTION
 
FUNCTION t710_u()
    IF (g_qsa.qsa01 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_qsa.qsaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_qsa.qsa08='Y' THEN
       CALL cl_err(g_qsa.qsa08,'aqc-715',0)
       RETURN
    END IF
 
    SELECT * INTO g_qsa.* FROM qsa_file
     WHERE qsa01 = g_qsa.qsa01
    IF g_qsa.qsaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_qsa01_t = g_qsa.qsa01
    BEGIN WORK
 
    OPEN t710_cl USING g_qsa.qsa01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_qsa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_qsa.qsamodu=g_user                  #修改者
    LET g_qsa.qsadate=g_today                 #修改日期
    CALL t710_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_qsa_t.*=g_qsa.*   #No.FUN-630051
        CALL t710_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_qsa.*=g_qsa_t.*
            CALL t710_show()
            EXIT WHILE
        END IF
        UPDATE qsa_file SET qsa_file.* = g_qsa.*    # 更新DB
            WHERE qsa01 = g_qsa01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("upd","qsa_file",g_qsa01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t710_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION t710_x()
    IF (g_qsa.qsa01 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_qsa.qsa08='Y' THEN
       CALL cl_err(g_qsa.qsa08,'aqc-715',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t710_cl USING g_qsa.qsa01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_qsa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t710_show()
    IF cl_exp(0,0,g_qsa.qsaacti) THEN
        LET g_chr=g_qsa.qsaacti
        IF g_qsa.qsaacti='Y' THEN
            LET g_qsa.qsaacti='N'
        ELSE
            LET g_qsa.qsaacti='Y'
        END IF
        UPDATE qsa_file
            SET qsaacti=g_qsa.qsaacti
            WHERE qsa01 = g_qsa.qsa01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("upd","qsa_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
            LET g_qsa.qsaacti=g_chr
        END IF
        DISPLAY BY NAME g_qsa.qsaacti
        CALL cl_set_field_pic(g_qsa.qsa08,"","","","",g_qsa.qsaacti)
    END IF
    CLOSE t710_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t710_r()
    IF (g_qsa.qsa01 IS NULL) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_qsa.qsaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_qsa.qsa08='Y' THEN
       CALL cl_err(g_qsa.qsa08,'aqc-715',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t710_cl USING g_qsa.qsa01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 0)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_qsa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t710_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "qsa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_qsa.qsa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM qsa_file
        WHERE qsa01 = g_qsa.qsa01
       CLEAR FORM
       OPEN t710_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t710_cs
          CLOSE t710_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t710_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t710_cs
          CLOSE t710_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t710_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t710_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE   #No.FUN-6A0071
          CALL t710_fetch('/')
       END IF
    END IF
    CLOSE t710_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t710_y()
DEFINE   l_n           LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE   l_qsa01       LIKE qsa_file.qsa01
DEFINE   l_qsa08       LIKE qsa_file.qsa08
 
    IF (g_qsa.qsa01 IS NULL) THEN
       RETURN
    END IF
    SELECT * INTO g_qsa.* FROM qsa_file
     WHERE qsa01 = g_qsa.qsa01
    IF g_qsa.qsaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_qsa.qsa08='Y' THEN CALL cl_err(g_qsa.qsa08,'aqc-715',0) RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
    #add FUN-AB0078
     IF NOT s_chk_ware(g_qsa.qsa03) THEN #检查仓库是否属于当前门店
      LET g_success='N'
      RETURN
     END IF
    #end FUN-AB0078
    BEGIN WORK
    OPEN t710_cl USING g_qsa.qsa01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_qsa.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t710_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET g_success= 'Y'
    UPDATE qsa_file SET qsa08='Y'
     WHERE qsa01 = g_qsa.qsa01
    IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
    END IF
    IF g_success='Y' THEN
       LET g_qsa.qsa08='Y'
       COMMIT WORK
       DISPLAY BY NAME g_qsa.qsa08
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_set_field_pic(g_qsa.qsa08,"","","","",g_qsa.qsaacti)
END FUNCTION
 
 
FUNCTION t710_n()
DEFINE   l_n           LIKE type_file.num5    #No.FUN-680104 SMALLINT
DEFINE   l_qsa01       LIKE qsa_file.qsa01
DEFINE   l_qsa08       LIKE qsa_file.qsa08
 
    IF (g_qsa.qsa01 IS NULL) THEN
       RETURN
    END IF
 
    #FUN-680010-----start
    #-->已有QC單則不可取消確認
    SELECT COUNT(*) INTO l_n FROM qcs_file
     WHERE qcs01 = g_qsa.qsa01 AND qcs00='G'  
    IF l_n > 0 THEN
       CALL cl_err(' ','aqc-118',0)
       RETURN
    END IF
    #FUN-680010-----end
 
    SELECT * INTO g_qsa.* FROM qsa_file
     WHERE qsa01 = g_qsa.qsa01
    IF g_qsa.qsaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_qsa.qsa08='N' THEN CALL cl_err(g_qsa.qsa08,'aqc-716',0) RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
    BEGIN WORK
    OPEN t710_cl USING g_qsa.qsa01
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_qsa.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t710_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET g_success='Y'
    UPDATE qsa_file SET qsa08='N'
     WHERE qsa01 = g_qsa.qsa01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
    END IF
    IF g_success='Y' THEN
       LET g_qsa.qsa08='N'
       COMMIT WORK
       DISPLAY BY NAME g_qsa.qsa08
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_set_field_pic(g_qsa.qsa08,"","","","",g_qsa.qsaacti)
END FUNCTION
 
FUNCTION t710_copy()
    DEFINE l_cnt   LIKE type_file.num10   #No.FUN-680104 INTEGER
    DEFINE
        l_newno1   LIKE qsa_file.qsa01,
        l_newdate  LIKE qsa_file.qsa11,   #TQC-980139
        l_oldno1   LIKE qsa_file.qsa01,
        p_cmd      LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
        l_flag     LIKE type_file.chr1,    #No.FUN-680104 VARCHAR(1)
        g_n        LIKE type_file.num5,    #No.FUN-680104 SMALLINT
        l_input    LIKE type_file.chr1     #No.FUN-680104 VARCHAR(1)
 
    IF (g_qsa.qsa01 IS NULL) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_qsa.qsaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t710_set_entry('a')
    LET g_before_input_done = TRUE
 
    #INPUT l_newno1 FROM qsa01   #TQC-980139
    INPUT l_newno1,l_newdate FROM qsa01,qsa11   #TQC-980139
 
        #-----TQC-980139---------
        #AFTER FIELD qsa01
        #      SELECT count(*) INTO l_cnt
        #        FROM qsa_file
        #      WHERE qsa01= l_newno1
        #      IF l_cnt > 0 THEN
        #         CALL cl_err(l_newno1,-239,0)
        #         LET l_newno1 = NULL
        #         NEXT FIELD qsa01
        #      END IF
        AFTER FIELD qsa01
           CALL s_check_no("aqc",l_newno1,"","2","qsa_file","qsa01","")
                RETURNING li_result,l_newno1
           DISPLAY l_newno1 TO qsa01
           IF (NOT li_result) THEN
              NEXT FIELD qsa01
           END IF
   
        AFTER FIELD qsa11
           IF cl_null(l_newdate) THEN NEXT FIELD qsa11 END IF
           CALL s_auto_assign_no("aqc",l_newno1,l_newdate,"2","qsa_file","qsa01","","","")
             RETURNING li_result,l_newno1
           IF (NOT li_result) THEN
              NEXT FIELD qsa01
           END IF
           DISPLAY l_newno1 TO qsa01
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(qsa01) #單號
                 LET g_t1 = s_get_doc_no(l_newno1)
                 CALL q_smy(FALSE,FALSE,g_t1,'AQC','2') RETURNING g_t1
                 LET l_newno1 = g_t1
                 DISPLAY l_newno1 TO qsa01
                 NEXT FIELD qsa01
           END CASE
        #-----END TQC-980139-----
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_qsa.qsa01
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM qsa_file
        WHERE qsa01 = g_qsa.qsa01
        INTO TEMP y
    UPDATE y
        SET qsa01=l_newno1,
            qsa11=l_newdate,  #TQC-980139
            qsaacti='Y',      #資料有效碼
            qsa08='N',
            qsauser=g_user,   #資料所有者
            qsagrup=g_grup,   #資料所有者所屬群
            qsamodu=NULL,     #資料修改日期
            qsadate=g_today   #資料建立日期
    INSERT INTO qsa_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_qsa.qsa01,SQLCA.sqlcode,0)   #No.FUN-660115
        CALL cl_err3("ins","qsa_file",l_newno1,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_qsa.qsa01
        LET g_qsa.qsa01 = l_newno1
        SELECT qsa01,qsa_file.* INTO g_qsa.qsa01,g_qsa.* FROM qsa_file
               WHERE qsa01=l_newno1
        CALL t710_u()
        #SELECT qsa01,qsa_file.* INTO g_qsa.qsa01,g_qsa.* FROM qsa_file  #FUN-C80046
        #       WHERE qsa01=l_oldno1   #FUN-C80046
    END IF
    #LET g_qsa.qsa01 = l_oldno1        #FUN-C80046
    CALL t710_show()
END FUNCTION
 
FUNCTION t710_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("qsa01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t710_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680104 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("qsa01",FALSE)
    END IF
 
END FUNCTION
 
#No.FUN-640193  --Begin
FUNCTION t710_set_entry_1()                                                     
                                                                                
IF g_sma.sma115 = 'Y' THEN
    CALL cl_set_comp_entry("qsa33,qsa35,qsa30",TRUE)                                
END IF
                                                                                
END FUNCTION                   
 
FUNCTION t710_set_no_entry_1()                                                  
                                                                                
IF g_sma.sma115 = 'Y' THEN
    IF g_ima906 = '1' THEN                                                      
       CALL cl_set_comp_entry("qsa33,qsa35,qsa30",FALSE)                     
    END IF                                                                      
    #參考單位，每個料件只有一個，所以不開放讓用戶輸入                           
    IF g_ima906 = '3' THEN                                                      
       CALL cl_set_comp_entry("qsa33,qsa30",FALSE)                                   
    END IF                                                                      
END IF
                                                                                
END FUNCTION          
 
FUNCTION t710_set_required()                                                    
                                                                                
IF g_sma.sma115 = 'Y' THEN
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入                  
  IF g_ima906 = '3' THEN                                                        
     CALL cl_set_comp_required("qsa33,qsa35,qsa30,qsa32",TRUE)              
  END IF                                                                        
  #單位不同,數量必KEY                                                    
  IF NOT cl_null(g_qsa.qsa30) THEN                                       
     CALL cl_set_comp_required("qsa32",TRUE)                                   
  END IF                                                                        
  IF NOT cl_null(g_qsa.qsa33) THEN                                       
     CALL cl_set_comp_required("qsa35",TRUE)                                   
  END IF                                                                        
END IF
                                                                                
END FUNCTION                
 
FUNCTION t710_set_no_required()
                                                                                
IF g_sma.sma115 = 'Y' THEN
  CALL cl_set_comp_required("qsa33,qsa35,qsa30,qsa32",FALSE)
END IF
                                                                               
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t710_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_img10  LIKE img_file.img10,     #img數量
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE inb_file.inb08_fac, #第二轉換率
            l_qty2   LIKE inb_file.inb09,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE inb_file.inb08_fac, #第一轉換率
            l_qty1   LIKE inb_file.inb09,     #第一數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-680104 VARCHAR(1)
            l_factor LIKE tsh_file.tsh11      #No.FUN-680104 DECIMAL(16,8)
 
    LET l_item = g_qsa.qsa02
    LET l_ware = g_qsa.qsa03
    LET l_loc  = g_qsa.qsa04
    LET l_lot  = g_qsa.qsa05
 
    IF cl_null(g_qsa.qsa02) THEN
       CALL cl_err('item',100,0)
       RETURN
    END IF
 
    SELECT ima906,ima907 INTO l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    LET l_img09 = NULL
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(l_img09) THEN 
       CALL cl_err('img09',100,0)
       RETURN 
    END IF
 
    LET l_unit2 = l_ima907
    CALL s_du_umfchk(l_item,'','','',l_img09,l_ima907,l_ima906)
         RETURNING g_errno,l_factor
    LET l_fac2 = l_factor
    LET l_img10 = 0
    SELECT imgg10 INTO l_img10 FROM imgg_file 
     WHERE imgg01 = l_item
       AND imgg02 = l_ware 
       AND imgg03 = l_loc  
       AND imgg04 = l_lot  
       AND imgg09 = l_unit2
    IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
    LET l_qty2  = l_img10
 
    LET l_unit1 = l_img09
    LET l_fac1  = 1
    LET l_img10 = 0
    IF l_ima906 = '2' THEN
       SELECT imgg10 INTO l_img10 FROM imgg_file 
        WHERE imgg01 = l_item
          AND imgg02 = l_ware 
          AND imgg03 = l_loc  
          AND imgg04 = l_lot  
          AND imgg09 = l_unit1
    ELSE
       SELECT img10 INTO l_img10 FROM img_file
        WHERE img01 = l_item
          AND img02 = l_ware
          AND img03 = l_loc
          AND img04 = l_lot
    END IF
    IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
    LET l_qty1  = l_img10
 
    IF p_cmd = 'a' OR g_change = 'Y' THEN
       LET g_qsa.qsa33=l_unit2
       LET g_qsa.qsa34=l_fac2
       LET g_qsa.qsa35=l_qty2
       LET g_qsa.qsa30=l_unit1
       LET g_qsa.qsa31=l_fac1
       LET g_qsa.qsa32=l_qty1
    END IF
    DISPLAY BY NAME g_qsa.qsa30,g_qsa.qsa33,g_qsa.qsa32,g_qsa.qsa35
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t710_du_data_to_correct()
 
   IF cl_null(g_qsa.qsa30) THEN
      LET g_qsa.qsa31 = NULL
      LET g_qsa.qsa32 = NULL
   END IF
 
   IF cl_null(g_qsa.qsa33) THEN
      LET g_qsa.qsa34 = NULL
      LET g_qsa.qsa35 = NULL
   END IF
   DISPLAY BY NAME g_qsa.qsa32,g_qsa.qsa35
 
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t710_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE ima_file.ima25,
            l_unit   LIKE ima_file.ima25,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE tsh_file.tsh11,
            l_qty2   LIKE tsh_file.tsh12,
            l_fac1   LIKE tsh_file.tsh08,
            l_fac    LIKE tsh_file.tsh08,
            l_qty1   LIKE tsh_file.tsh09,
            l_factor LIKE tsh_file.tsh11      #No.FUN-680104 DECIMAL(16,8)
 
    SELECT ima906 INTO l_ima906 FROM ima_file
     WHERE ima01=g_qsa.qsa02
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = g_qsa.qsa02
       AND img02 = g_qsa.qsa03
       AND img03 = g_qsa.qsa04
       AND img04 = g_qsa.qsa05
 
    LET l_fac = 1
    IF l_img09 <> g_qsa.qsa30 THEN
       CALL s_umfchk(g_qsa.qsa02,g_qsa.qsa30,l_img09)
            RETURNING g_cnt,l_fac
       IF g_cnt = 1 THEN
          LET l_fac = 1
       END IF
    END IF
    LET g_qsa.qsa31 = l_fac
 
    LET l_fac = 1
    IF l_img09 <> g_qsa.qsa33 THEN
       CALL s_umfchk(g_qsa.qsa02,g_qsa.qsa33,l_img09)
            RETURNING g_cnt,l_fac
       IF g_cnt = 1 THEN
          LET l_fac = 1
       END IF
    END IF
    LET g_qsa.qsa34 = l_fac
    LET l_fac2=g_qsa.qsa34
    LET l_qty2=g_qsa.qsa35
    LET l_fac1=g_qsa.qsa31
    LET l_qty1=g_qsa.qsa32
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    CASE l_ima906
       WHEN '1' LET l_tot  = l_qty1 * l_fac1
       WHEN '2' LET l_tot  = l_fac1*l_qty1+l_fac2*l_qty2
       WHEN '3' LET l_tot  = l_qty1 * l_fac1
                IF l_qty2 <> 0 THEN
                   LET g_qsa.qsa34 = l_qty1 / l_qty2
                ELSE
                   LET g_qsa.qsa34 = 0
                END IF
    END CASE
    LET l_tot = s_digqty(l_tot,l_img09)   #FUN-BB0085 
    LET g_qsa.qsa06 = l_tot 
 
END FUNCTION
 
FUNCTION t710_out()
   DEFINE l_wc,l_wc2  LIKE type_file.chr1000, #No.FUN-680104 VARCHAR(100)
          l_prog      LIKE zz_file.zz01,
          l_prtway    LIKE zz_file.zz22
   IF g_qsa.qsa01 IS NULL THEN RETURN END IF
#No.FUN-640193--begin--wujie
#  IF g_argv1 = '1' THEN
#     LET g_msg = "aqcr710 '",g_qsa.qsa01,"' "
#  ELSE
     #TQC-750256 begin
      #LET g_msg = "aqcr720 '",g_qsa.qsa01,"' "
      LET l_wc = " qsa01 = '", g_qsa.qsa01 CLIPPED,"'"
      LET l_wc = cl_replace_str(l_wc, "'", "\"")
     #LET g_msg = "aqcr720 '",g_today,"' ", #FUN-C30085 mark
      LET g_msg = "aqcg720 '",g_today,"' ", #FUN-C30085 add
                          "'",g_user,"' ",
                          "'",g_lang,"' ",
                          "'Y' ",
                          "'' '' ",
                          "'", l_wc CLIPPED,"'"
     #TQC-750256 end
#  END IF
#No.FUN-640193--end    
   CALL cl_cmdrun(g_msg)
END FUNCTION
 
FUNCTION t710_ui_set()
   CALL cl_set_comp_visible("qsa34,qsa31",FALSE)
   IF g_sma.sma115 = 'N' THEN
      CALL cl_set_comp_visible("qsa33,qsa35,qsa30,qsa32",FALSE)
   ELSE
      CALL cl_set_comp_visible("img09,qsa06",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg  #母單位
      CALL cl_set_comp_att_text("qsa33",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("qsa35",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg  #子單位
      CALL cl_set_comp_att_text("qsa30",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("qsa32",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg  #參考單位
      CALL cl_set_comp_att_text("qsa33",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("qsa35",g_msg CLIPPED)
      CALL cl_getmsg('aqc-061',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("qsa30",g_msg CLIPPED)
      CALL cl_getmsg('aqc-062',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("qsa32",g_msg CLIPPED)
   END IF
 
   #FUN-680010-----start
   IF g_aza.aza64 matches '[ Nn]' THEN
      CALL cl_set_comp_visible("qsaspc",FALSE)
      CALL cl_set_act_visible("trans_spc",FALSE)
   END IF 
   #FUN-680010-----end
 
END FUNCTION
#No.FUN-640193--End  
 
#FUN-680010-----start
FUNCTION t710_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE gaz_file.gaz01    #No.FUN-680104 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10   #No.FUN-680104 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_qsa.qsa01,g_qsa.qsaspc,g_qsa.qsa08,'')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   LET l_qc_prog = "aqct700"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_qsa.qsa01  
   IF l_cnt > 0 THEN
      CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
      CALL cl_err_msg(g_qsa.qsa01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
      LET g_success='N'
      RETURN
   END IF
  
   #需要 QC 檢驗的筆數
   LET l_qc_cnt = 1
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   display l_cmd
   LET l_cmd = l_qc_prog CLIPPED," '",g_qsa.qsa01,"' '0' '1' 'SPC' 'G'"
   CALL aws_spccli_qc(l_qc_prog,l_cmd)
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_qsa.qsa01
   IF l_cnt <> l_qc_cnt THEN
      CALL t710_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_qsa.qsa01,"'"
   PREPARE t710_qc_p FROM l_sql
   DECLARE t710_qc_c CURSOR WITH HOLD FOR t710_qc_p
   LET l_cnt = 1
   FOREACH t710_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   # CALL aws_spccli() 
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
      LET g_qsa.qsaspc = '1'
   ELSE
      LET g_qsa.qsaspc = '2'
      CALL t710_qcs_del()
   END IF
 
   UPDATE qsa_file set qsaspc = g_qsa.qsaspc WHERE qsa01 = g_qsa.qsa01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","qsa_file",g_qsa.qsa01,"",STATUS,"","upd qsaspc",1)
      IF g_qsa.qsaspc = '1' THEN
          CALL t710_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_qsa.qsaspc
  
END FUNCTION 
 
FUNCTION t710_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_qsa.qsa01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","DEL qcs_file err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_qsa.qsa01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","DEL qct_file err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_qsa.qsa01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","DEL qcstt_file err!",0)
      END IF
 
      DELETE FROM qcu_file WHERE qcu01 = g_qsa.qsa01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","DEL qcu_file err!",0)
      END IF
 
      DELETE FROM qcv_file WHERE qcv01 = g_qsa.qsa01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_qsa.qsa01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
      END IF
 
END FUNCTION 

#FUN-BB0085------add------str--------
FUNCTION t710_qsa35_check()
DEFINE l_imgg10  LIKE imgg_file.imgg10
DEFINE l_fac     LIKE qsa_file.qsa31

   IF NOT cl_null(g_qsa.qsa35) AND NOT cl_null(g_qsa.qsa33) THEN
      IF cl_null(g_qsa33_t) OR g_qsa33_t != g_qsa.qsa33 OR cl_null(g_qsa_t.qsa35) OR g_qsa_t.qsa35 != g_qsa.qsa35 THEN
         LET g_qsa.qsa35 = s_digqty(g_qsa.qsa35,g_qsa.qsa33)
         DISPLAY BY NAME g_qsa.qsa35
      END IF
   END IF

   IF NOT cl_null(g_qsa.qsa35) THEN
      IF g_qsa.qsa35 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE    
      END IF
      SELECT imgg10 INTO l_imgg10
        FROM imgg_file
       WHERE imgg01 = g_qsa.qsa02
         AND imgg02 = g_qsa.qsa03
         AND imgg03 = g_qsa.qsa04
         AND imgg04 = g_qsa.qsa05
         AND imgg09 = g_qsa.qsa33
      IF g_qsa.qsa35 > l_imgg10 THEN
         CALL cl_err('','asf-375',0)
         RETURN FALSE    
      END IF
      IF g_ima906='3' THEN
         IF cl_null(g_qsa.qsa32) OR g_qsa.qsa32=0 OR
            g_qsa.qsa35 <> g_qsa_t.qsa35 OR cl_null(g_qsa_t.qsa35) THEN
            LET l_fac = 1
            CALL s_umfchk(g_qsa.qsa02,g_qsa.qsa33,g_qsa.qsa30)
                 RETURNING g_cnt,l_fac
            IF g_cnt = 1 THEN
               LET l_fac = 1
            END IF
            LET g_qsa.qsa32=g_qsa.qsa35*l_fac
            LET g_qsa.qsa32=s_digqty(g_qsa.qsa32,g_qsa.qsa30)
            DISPLAY BY NAME g_qsa.qsa32
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION 

FUNCTION t710_qsa32_check(p_img10) 
DEFINE l_imgg10  LIKE imgg_file.imgg10
DEFINE p_img10   LIKE img_file.img10

   IF NOT cl_null(g_qsa.qsa32) AND NOT cl_null(g_qsa.qsa30) THEN 
      IF cl_null(g_qsa30_t) OR g_qsa30_t != g_qsa.qsa30 OR cl_null(g_qsa_t.qsa32) OR g_qsa_t.qsa32 != g_qsa.qsa32 THEN 
         LET g_qsa.qsa32 = s_digqty(g_qsa.qsa32,g_qsa.qsa30)
         DISPLAY BY NAME g_qsa.qsa32
      END IF
   END IF

   IF NOT cl_null(g_qsa.qsa32) THEN
      IF g_qsa.qsa32 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE    
      END IF
   END IF
   CALL t710_du_data_to_correct()
   IF g_ima906 = '2' THEN
      LET l_imgg10 = 0
      SELECT imgg10 INTO l_imgg10
        FROM imgg_file
       WHERE imgg01 = g_qsa.qsa02
         AND imgg02 = g_qsa.qsa03
         AND imgg03 = g_qsa.qsa04
         AND imgg04 = g_qsa.qsa05
         AND imgg09 = g_qsa.qsa30
      IF g_qsa.qsa32 > l_imgg10 THEN
         CALL cl_err('','asf-375',0)
         RETURN FALSE    
      END IF
   END IF
   IF g_ima906 = '3' OR g_ima906 = '1' THEN  #No.FUN-640193
      IF g_qsa.qsa32 * g_qsa.qsa31 > p_img10 THEN
         CALL cl_err('','asf-375',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION 
#FUN-BB0085------add------end--------
#FUN-680010-----end


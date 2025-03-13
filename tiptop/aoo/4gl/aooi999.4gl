# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aooi999.4gl
# Descriptions...: JavaMail參數維護作業
# Date & Author..: 03/5/29 By alex
# Modify.........: 04/07/20 MOD-470041 Nicola 修改INSERT INTO 語法
#                  04/10/06 MOD-470515 Nicola 加入"相關文件"功能
#                  04/10/13 MOD-4A0206 Echo 調整客製、gaz_file程式
#                  04/12/07 FUN-4C0044 pengu Data and Group權限控管
#                  04/12/08 MOD-4B0301 saki 增加是否檢查認證欄位
#                  05/04/29 MOD-540163 alex 改變 program 抓取方式
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0066 06/10/20 By atsea 將g_no_ask修改為mi_no_ask
# Modify.........: No.FUN-6A0015 06/10/25 By jamie FUNCTION _q() 一開始應清空key值`
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-870102 08/08/26 By tsai_yen 1.新增Action以維護"CR報表"Mail參數 2.紀錄"資料修改者" 3.動態設定欄位是否必須輸入值：自訂MailServer參數、應檢查認證
#                                                     4.查zaw_file中的資料數來決定預設值為何:檢查此程式代碼是否有設定CR報表. 有zaw資料：預設值與"CR"資料相同; 無zaw資料：預設值與"DEFAULT"資料相同
# Modify.........: No.TQC-890008 08/09/03 By tsai_yen 在Ora和Uni區正常，但是在Ifx區按Action(預設郵件主機、CR郵件主機)後，必填欄位不正常：郵件主機IP、郵件主機Port、郵件主機使用者
# Modify.........: No.FUN-8A0022 08/10/07 By kevin 選項系統寄件人(mlj09)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-940099 09/04/20 By tsai_yen 按了Action(CR郵件主機、預設郵件主機)，也可以使用複製功能
# Modify.........: No:MOD-9A0148 09/10/26 By Dido 若為預設郵件主機與CR主機密碼欄位應為必要欄位 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-CA0116 12/11/22 by zong-yi 新增SSL/TLS加密
# Modify.........: No.MOD-D90155 13/10/30 By fengmy mlj10、mlj11預設值
# Modify.........: No.MOD-D90062 13/10/30 By fengmy 程式無法新增查詢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_default03   LIKE mlj_file.mlj03,
    g_default04   LIKE mlj_file.mlj04,
    g_default05   LIKE mlj_file.mlj05,
    g_default06   LIKE mlj_file.mlj06,
    g_default07   LIKE mlj_file.mlj08,
    g_default09   LIKE mlj_file.mlj09, #FUN-8A0022
    g_default10   LIKE mlj_file.mlj10, #FUN-CA0116
    g_default11   LIKE mlj_file.mlj11, #FUN-CA0116
    g_mlj         RECORD
         mlj01    LIKE mlj_file.mlj01,
         gaz03    LIKE gaz_file.gaz03,
         mlj07    LIKE mlj_file.mlj07,
         mlj02    LIKE mlj_file.mlj02,
         def      LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
         mlj03    LIKE mlj_file.mlj03,
         mlj04    LIKE mlj_file.mlj04,
         mlj05    LIKE mlj_file.mlj05,
         mlj06    LIKE mlj_file.mlj06,
         mlj08    LIKE mlj_file.mlj08,
         mlj09    LIKE mlj_file.mlj09, #FUN-8A0022
         mlj10    LIKE mlj_file.mlj10, #FUN-CA0116
         mlj11    LIKE mlj_file.mlj11, #FUN-CA0116
         mljuser  LIKE mlj_file.mljuser,
         mljgrup  LIKE mlj_file.mljgrup,
         mljmodu  LIKE mlj_file.mljmodu,
         mljdate  LIKE mlj_file.mljdate,
         mljoriu LIKE mlj_file.mljoriu,      #No.FUN-980030 10/01/04
         mljorig LIKE mlj_file.mljorig      #No.FUN-980030 10/01/04
              END RECORD,
    g_mlj_t       RECORD
         mlj01    LIKE mlj_file.mlj01,
         gaz03    LIKE gaz_file.gaz03,
         mlj07    LIKE mlj_file.mlj07,
         mlj02    LIKE mlj_file.mlj02,
         def      LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
         mlj03    LIKE mlj_file.mlj03,
         mlj04    LIKE mlj_file.mlj04,
         mlj05    LIKE mlj_file.mlj05,
         mlj06    LIKE mlj_file.mlj06,
         mlj08    LIKE mlj_file.mlj08,
         mlj09    LIKE mlj_file.mlj09, #FUN-8A0022
         mlj10    LIKE mlj_file.mlj10, #FUN-CA0116
         mlj11    LIKE mlj_file.mlj11, #FUN-CA0116
         mljuser  LIKE mlj_file.mljuser,
         mljgrup  LIKE mlj_file.mljgrup,
         mljmodu  LIKE mlj_file.mljmodu,
         mljdate  LIKE mlj_file.mljdate,
         mljoriu LIKE mlj_file.mljoriu,      #No.FUN-980030 10/01/04
         mljorig LIKE mlj_file.mljorig      #No.FUN-980030 10/01/04
              END RECORD,
    g_mlj_o       RECORD
         mlj01    LIKE mlj_file.mlj01,
         gaz03    LIKE gaz_file.gaz03,
         mlj07    LIKE mlj_file.mlj07,
         mlj02    LIKE mlj_file.mlj02,
         def      LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
         mlj03    LIKE mlj_file.mlj03,
         mlj04    LIKE mlj_file.mlj04,
         mlj05    LIKE mlj_file.mlj05,
         mlj06    LIKE mlj_file.mlj06,
         mlj08    LIKE mlj_file.mlj08,
         mlj09    LIKE mlj_file.mlj09, #FUN-8A0022
         mlj10    LIKE mlj_file.mlj10, #FUN-CA0116
         mlj11    LIKE mlj_file.mlj11, #FUN-CA0116
         mljuser  LIKE mlj_file.mljuser,
         mljgrup  LIKE mlj_file.mljgrup,
         mljmodu  LIKE mlj_file.mljmodu,
         mljdate  LIKE mlj_file.mljdate,
         mljoriu LIKE mlj_file.mljoriu,      #No.FUN-980030 10/01/04
         mljorig LIKE mlj_file.mljorig      #No.FUN-980030 10/01/04
              END RECORD,
    g_mlj01_t     LIKE mlj_file.mlj01,
 
    g_wc,g_sql             STRING,  #No.FUN-580092 HCN 
    g_string               LIKE type_file.chr20        #No.FUN-680102CHAR(10),
 
DEFINE g_forupd_sql        STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_cnt               LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_msg               LIKE ze_file.ze03         #No.FUN-680102CHAR(72) 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680102 SMALLINT   #No.FUN-6A0066
 
MAIN
   DEFINE
       p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
#       l_time       LIKE type_file.chr8              #No.FUN-6A0081
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   INITIALIZE g_mlj.* TO NULL
   INITIALIZE g_mlj_t.* TO NULL
   INITIALIZE g_mlj_o.* TO NULL
   LET g_forupd_sql = "SELECT mlj01,'',mlj07,mlj02,'',mlj03,mlj04,mlj05,mlj06,mlj08,mlj09,mlj10,mlj11,mljuser,mljgrup,mljmodu,mljdate FROM mlj_file WHERE mlj01 = ? FOR UPDATE" #FUN-8A0022 FUN-CA0116 add mlj10 mlj11
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i999_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
   LET p_row = 5 LET p_col = 18
   OPEN WINDOW i999_w AT p_row,p_col WITH FORM "aoo/42f/aooi999"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #CALL i999_default()                      #將預設值填入 g_default0*   #FUN-870102 mark
   CALL i999_default("DEFAULT")              #預設值與mlj01='DEFAULT'的資料相同    #FUN-870102
    #WHILE TRUE      ####040512
      LET g_action_choice=""
   CALL i999_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
   CLOSE WINDOW i999_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
#FUNCTION i999_default()        #FUN-870102 mark
FUNCTION i999_default(p_mlj01)  #FUN-870102
    DEFINE p_mlj01     LIKE mlj_file.mlj01  #設定預設值的主鍵值，例如："DEFAULT"或"CR"  #FUN-870102
    
    LET g_errno  = " "
    LET g_string = " "
 
    SELECT mlj03,mlj04,mlj05,mlj06,mlj08,mlj09,mlj10,mlj11 #FUN-8A0022 add mlj10 mlj11
      INTO g_default03, g_default04, g_default05, g_default06, g_default07,g_default09,g_default10,g_default11
      FROM mlj_file
     #WHERE mlj01 = "DEFAULT" #FUN-870102 mark
     WHERE mlj01 = p_mlj01  #FUN-870102
    IF SQLCA.SQLCODE THEN
        IF SQLCA.SQLCODE = 100 THEN
#           CALL cl_err("","aoo-996",1)   #No.FUN-660131
            CALL cl_err3("sel","mlj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            #CALL i999_d() #FUN-870102 mark
            CALL i999_d2(p_mlj01) #FUN-870102
        ELSE
            LET g_errno = SQLCA.sqlcode USING "-------" SLEEP 5
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
    END IF
 
END FUNCTION
 
FUNCTION i999_curs(p_cmd)
 
    DEFINE p_cmd    LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    CLEAR FORM
 
    # 螢幕上取條件
   INITIALIZE g_mlj.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc
           ON mlj01,  mlj07,  mlj02,  mlj03,  mlj04,  mlj05, mlj06, mlj08, mlj10, mlj11, #FUN-CA0116 add mlj10 mlj11
              mljuser,mljgrup,mljmodu,mljdate
                                                 # 資料權限的檢查
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 CALL cl_set_comp_required("mlj03, mlj04, mlj05, mlj06", FALSE) #預設為非必填欄位   # TQC-890008
              #No.FUN-580031 --end--       HCN
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                          # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND mljuser = '",g_user,"'"
    #    END IF
 
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND mljgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND mljgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mljuser', 'mljgrup')
    #End:FUN-980030
 
 
    LET g_sql="SELECT mlj01 FROM mlj_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " AND mlj01 !='DEFAULT' AND mlj01 !='CR' ORDER BY mlj01"   #FUN-870102
              #" WHERE ",g_wc CLIPPED, " AND mlj01 !='DEFAULT' ORDER BY mlj01"  #FUN-870102 mark
              
    PREPARE i999_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i999_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i999_prepare
 
    LET g_sql= "SELECT COUNT(*) FROM mlj_file WHERE ",g_wc CLIPPED,
                 " AND mlj01 !='DEFAULT' AND mlj01 !='CR'" #FUN-870102
                 #" AND mlj01 !='DEFAULT' " #FUN-870102 mark
                 
    PREPARE i999_precount FROM g_sql
    DECLARE i999_count CURSOR FOR i999_precount
 
END FUNCTION
 
FUNCTION i999_menu()
    MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i999_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i999_q()
            END IF
        ON ACTION next
            CALL i999_fetch('N')
        ON ACTION previous
            CALL i999_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i999_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i999_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i999_copy()
            END IF
        #@ON ACTION 預設郵件主機
        ON ACTION define_mailserver
            LET g_action_choice="define_mailserver"
            IF cl_chk_act_auth() THEN
                 #CALL i999_d()          #FUN-870102 mark
                 CALL i999_d2("DEFAULT") #FUN-870102
            END IF
            
        ### FUN-870102 START ###
        #CR報表
        ON ACTION define_crmailserver
            LET g_action_choice="define_crmailserver"
            IF cl_chk_act_auth() THEN
                 CALL i999_d2("CR")
            END IF    
        ### FUN-870102 END ###
        
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL i999_mlj01("",g_mlj.mlj01) RETURNING g_mlj.mlj01
#           EXIT MENU

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

         ON ACTION jump
             CALL i999_fetch('/')
         ON ACTION first
             CALL i999_fetch('F')
         ON ACTION last
             CALL i999_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION related_document    #No.MOD-470515
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_mlj.mlj01 IS NOT NULL THEN
                 LET g_doc.column1 = "mlj01"
                 LET g_doc.value1 = g_mlj.mlj01
                 CALL cl_doc()
              END IF
           END IF
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i999_cs
END FUNCTION
 
 
FUNCTION i999_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
 
    CLEAR FORM                                   # 清螢幕欄位內容
 
    INITIALIZE g_mlj.* TO NULL
 
    LET g_mlj01_t = NULL
    LET g_mlj_t.* = g_mlj.*
    LET g_mlj_o.* = g_mlj.*
    CALL cl_opmsg("a")
 
    WHILE TRUE
        LET g_mlj.mljuser = g_user
        LET g_mlj.mljgrup = g_grup                # 使用者所屬群
        LET g_mlj.mljdate = today
        LET g_mlj.mlj08 = "Y"        
        #MOD-D90062---begin
        LET g_mlj.def = "N"
        LET g_mlj.mlj07 = "N"
        LET g_mlj.mlj10 = "N"
        LET g_mlj.mlj11 = "S"
        #MOD-D90062---end
 
        CALL i999_i("a")                          # 各欄位輸入
        IF INT_FLAG THEN                          # 若按了DEL鍵
            INITIALIZE g_mlj.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_mlj.mlj01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        # DISK WRITE
         INSERT INTO mlj_file (mlj01,mlj02,mlj03,mlj04,mlj05,mlj06,  #No.MOD-470041
                              mlj07,mlj08,mlj09,mlj10,mlj11,mljuser,mljgrup,mljmodu,mljdate,mljoriu,mljorig) #FUN-8A0022
             VALUES(g_mlj.mlj01,g_mlj.mlj02,g_mlj.mlj03,g_mlj.mlj04,
                    g_mlj.mlj05,g_mlj.mlj06,g_mlj.mlj07,g_mlj.mlj08,g_mlj.mlj09,  #FUN-8A0022
                    g_mlj.mlj10,g_mlj.mlj11,  #FUN-CA0116
                    g_mlj.mljuser,g_mlj.mljgrup,g_mlj.mljmodu,g_mlj.mljdate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("ins","mlj_file",g_mlj.mlj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        ELSE
            LET g_mlj_t.* = g_mlj.*                # 保存上筆資料
            LET g_mlj_o.* = g_mlj.*                # 保存上筆資料
            SELECT mlj01 INTO g_mlj.mlj01 FROM mlj_file
             WHERE mlj01 = g_mlj.mlj01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i999_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
    DEFINE l_zawcount   INTEGER   #zaw_file中的資料數，用來檢查此程式代碼是否有設定CR報表       #No.FUN-870102
        
    DISPLAY BY NAME g_mlj.mljuser,g_mlj.mljgrup, g_mlj.mljdate,
        g_mlj.mlj01, g_mlj.gaz03,  g_mlj.mlj07, g_mlj.mlj02, g_mlj.def,
        g_mlj.mlj03, g_mlj.mlj04, g_mlj.mlj05, g_mlj.mlj06, g_mlj.mlj08, g_mlj.mlj09, #FUN-8A0022
        g_mlj.mlj10, g_mlj.mlj11 #FUN-CA0116
 
    INPUT BY NAME
        g_mlj.mlj01,  g_mlj.mlj07, g_mlj.mlj02, g_mlj.def,
        g_mlj.mlj03, g_mlj.mlj04, g_mlj.mlj05, g_mlj.mlj06, g_mlj.mlj08, g_mlj.mlj09, #FUN-8A0022
        g_mlj.mlj10, g_mlj.mlj11 #FUN-CA0116 
    
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i999_set_entry(p_cmd)
            CALL i999_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            ### TQC-890008 START ###
            CALL cl_set_comp_required("mlj03, mlj04, mlj05, mlj06", FALSE) #預設為非必填欄位
            IF p_cmd = "d" OR p_cmd = "r" THEN    #Action(預設郵件主機、CR郵件主機)
               #自訂MailServer參數
              #CALL cl_set_comp_required("mlj03,mlj04,mlj05", TRUE) #動態設定欄位是否必須輸入值			#MOD-9A0148 mark
               CALL cl_set_comp_required("mlj03,mlj04,mlj05,mlj06", TRUE) #動態設定欄位是否必須輸入值		#MOD-9A0148
              #-MOD-9A0148-add-
              ##應檢查認證
              #IF g_mlj.mlj08 = "Y" THEN
              #   CALL cl_set_comp_required("mlj06", TRUE) #動態設定欄位是否必須輸入值
              #END IF
              #-MOD-9A0148-end-
            ELSE 
               ### FUN-870102 SATRT ###  
               #IF g_mlj.mlj01 != "DEFAULT" AND g_mlj.mlj01 != "CR" THEN                             # TQC-890008 mark       
                   #自訂MailServer參數
                   IF g_mlj.def = "Y" THEN
                      CALL cl_set_comp_required("mlj03,mlj04,mlj05", TRUE) #動態設定欄位是否必須輸入值
                   #ELSE     # TQC-890008 mark
                   #   CALL cl_set_comp_required("mlj03,mlj04,mlj05", FALSE)     # TQC-890008 mark
                   END IF
 
                   #應檢查認證
                   IF g_mlj.mlj08 = "Y" THEN
                       CALL cl_set_comp_required("mlj06", TRUE) #動態設定欄位是否必須輸入值
                   #ELSE     # TQC-890008 mark
                   #    CALL cl_set_comp_required("mlj06", FALSE)     # TQC-890008 mark
                   END IF
               #END IF # TQC-890008 mark
               ### FUN-870102 END ###
            END IF
            ### TQC-890008 END ###            
            
        BEFORE FIELD mlj01
            IF p_cmd = "d" THEN
                 #MOD-490349
                DISPLAY "DEFAULT" TO mlj01
                CALL i999_mlj01(p_cmd,"DEFAULT") RETURNING g_mlj.mlj01
#               CASE
#                    WHEN g_lang='0'   #中文
#                       DISPLAY "預設郵件主機維護作業" TO gaz03
#                    WHEN g_lang='2'   #簡體
#                       DISPLAY "默認郵件主機維護作業" TO gaz03
#                    OTHERWISE
#                       DISPLAY "Maintain for DEFAULT mailserver" TO gaz03
#               END CASE
                NEXT FIELD mlj03
            END IF
 
            ### FUN-870102 START ###
            IF p_cmd = "r" THEN
                DISPLAY "CR" TO mlj01
                CALL i999_mlj01(p_cmd,"CR") RETURNING g_mlj.mlj01
                NEXT FIELD mlj03
            END IF
            ### FUN-870102 END ###
            
        AFTER FIELD mlj01
            
            IF NOT cl_null(g_mlj.mlj01) THEN
            	#FUN-8A0022 start
            	IF p_cmd = "a" THEN
                   SELECT COUNT(zaw01)
                     INTO l_zawcount
                     FROM zaw_file
                    WHERE zaw01 = g_mlj.mlj01
                      
                   IF l_zawcount > 0 THEN 
               	      SELECT mlj09 INTO g_default09 FROM mlj_file WHERE mlj01='CR'                    
                   ELSE
                       LET g_default09 = "N"                   
                   END IF
                   LET g_mlj.mlj09 = g_default09
                   DISPLAY g_default09 TO mlj09
                END IF
                #FUN-8A0022 end  
                IF g_mlj.mlj01 <> g_mlj_t.mlj01 THEN
                   CALL cl_err('WARNING: CHANGING PROGRAM ID!','!',1)
                END IF
                CALL i999_mlj01(p_cmd,g_mlj.mlj01) RETURNING g_mlj.mlj01
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_mlj.mlj01,g_errno,0)
                    NEXT FIELD mlj01
                END IF
            END IF
            
 
        BEFORE FIELD mlj07
            IF cl_null(g_mlj_t.mlj07) AND cl_null(g_mlj.mlj07) THEN
                 LET g_mlj.mlj07 = "N"
            END IF
            DISPLAY g_mlj.mlj07 TO mlj07
 
        AFTER FIELD mlj07
            IF g_mlj.mlj07 NOT MATCHES '[YN]' THEN NEXT FIELD mlj07 END IF

        #FUN-CA0116 ---start---
        ON CHANGE mlj11
            IF g_mlj.mlj11 = "S" THEN
                LET g_mlj.mlj04 = "465"
            ELSE
                LET g_mlj.mlj04 = "587"
            END IF
            DISPLAY g_mlj.mlj04 TO mlj04

        ON CHANGE mlj10
           IF g_mlj.mlj10 = "Y" THEN
                CALL cl_set_comp_visible("mlj11",TRUE)
                LET g_mlj.mlj04 = "465"
           ELSE
                CALL cl_set_comp_visible("mlj11",FALSE)
                LET g_mlj.mlj04 = "25"
           END IF
           DISPLAY g_mlj.mlj04 TO mlj04
        #FUN-CA0116---END---
 
        BEFORE FIELD mlj02
            IF cl_null(g_mlj_t.mlj02) AND cl_null(g_mlj.mlj02) THEN
                 LET g_mlj.mlj02 = "2"
            END IF
            DISPLAY g_mlj.mlj02 TO mlj02
 
        AFTER FIELD mlj02
            IF g_mlj.mlj02 NOT MATCHES '[12]' THEN NEXT FIELD mlj02 END IF
 
        BEFORE FIELD def
            CALL i999_set_entry(p_cmd)
 
        ### FUN-870102 SATRT ### 
        ON CHANGE def #自訂MailServer參數
           IF g_mlj.def = "Y" THEN
              CALL cl_set_comp_required("mlj03,mlj04,mlj05", TRUE) #動態設定欄位是否必須輸入值             
           ELSE
              CALL cl_set_comp_required("mlj03,mlj04,mlj05", FALSE)
           END IF
        ### FUN-870102 END ###
            
        AFTER FIELD def
            LET l_zawcount = 0  #NO.FUN-870102
            IF NOT cl_null(g_mlj.def) THEN
            IF g_mlj.def NOT MATCHES '[YN]' THEN NEXT FIELD def END IF
            IF g_mlj.def = "N" THEN
                ### FUN-870102 START ###
                #查zaw_file中的資料數，檢查此程式代碼是否有設定CR報表
                #有zaw資料：預設值與"CR"資料相同
                #無zaw資料：預設值與"DEFAULT"資料相同
                IF NOT cl_null(g_mlj.mlj01) THEN
                   SELECT COUNT(zaw01)
                      INTO l_zawcount
                      FROM zaw_file
                      WHERE zaw01 = g_mlj.mlj01
                END IF     
                MESSAGE "l_zawcount=",l_zawcount," ,g_mlj.mlj01=",g_mlj.mlj01
                IF l_zawcount > 0 THEN
                    CALL i999_default("CR")          #預設值與"CR"資料相同                    
                ELSE
                    CALL i999_default("DEFAULT")     #預設值與"DEFAULT"資料相同
                END IF
                ### FUN-870102 END ###
                
                LET g_mlj.mlj03 = g_default03
                LET g_mlj.mlj04 = g_default04
                LET g_mlj.mlj05 = g_default05
                LET g_mlj.mlj06 = g_default06
                LET g_mlj.mlj08 = g_default07
                LET g_mlj.mlj09 = g_default09 #FUN-8A0022
                LET g_mlj.mlj10 = g_default10 #FUN-CA0116
                LET g_mlj.mlj11 = g_default11 #FUN-CA0116
                DISPLAY g_mlj.mlj03,g_mlj.mlj04,g_mlj.mlj05,g_mlj.mlj06,g_mlj.mlj08,g_mlj.mlj09,g_mlj.mlj10,g_mlj.mlj11 #FUN-8A0022
                     TO mlj03,mlj04,mlj05,mlj06,mlj08,mlj09,mlj10,mlj11 #FUN-8A0022 FUN-CA0116 add mlj10 mlj11
                NEXT FIELD mljuser
            END IF
            END IF
            CALL i999_set_no_entry(p_cmd)
 
        BEFORE FIELD mlj04
            # 如果本欄(含舊值) 皆為空或NULL,但有寫IP,則預設以port25寄送
            IF cl_null(g_mlj.mlj04) AND cl_null(g_mlj_t.mlj04) AND
               NOT cl_null(g_mlj.mlj03) THEN
                LET g_mlj.mlj04 = "25"
            END IF
 
        AFTER FIELD mlj04
            IF g_mlj.mlj04 <= 0 OR g_mlj.mlj04 > 65535 THEN
               CALL cl_err(g_mlj.mlj04,'aoo-999',0)
               LET g_mlj.mlj04 = g_mlj_o.mlj04
               DISPLAY BY NAME g_mlj.mlj04
               NEXT FIELD mlj04
            END IF
 
        ### FUN-870102 SATRT ###    
        ON CHANGE mlj08 #應檢查認證
           IF p_cmd = "d" OR p_cmd = "r" THEN    #非Action(預設郵件主機、CR郵件主機)	#MOD-9A0148
           ELSE										#MOD-9A0148
              IF g_mlj.mlj08 = "Y" THEN
                 CALL cl_set_comp_required("mlj06", TRUE) #動態設定欄位是否必須輸入值
              ELSE
                 CALL cl_set_comp_required("mlj06", FALSE)
              END IF
           END IF									#MOD-9A0148
        ### FUN-870102 END ###
        
        AFTER INPUT
           LET g_mlj.mljuser = s_get_data_owner("mlj_file") #FUN-C10039
           LET g_mlj.mljgrup = s_get_data_group("mlj_file") #FUN-C10039
            MESSAGE " "
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(mlj01) THEN
        #        LET g_mlj.* = g_mlj_t.*
        #        DISPLAY BY NAME g_mlj.*
        #        NEXT FIELD mlj01
        #    END IF
        #MOD-650015 --start 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(mlj01)
#                   CALL q_zz(g_mlj.mlj01) RETURNING g_mlj.mlj01
#                   CALL FGL_DIALOG_SETBUFFER( g_mlj.mlj01 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_gaz'
                    LET g_qryparam.default1 = g_mlj.mlj01
                    LET g_qryparam.arg1= g_lang
                    CALL cl_create_qry() RETURNING g_mlj.mlj01
#                    CALL FGL_DIALOG_SETBUFFER( g_mlj.mlj01 )
                    DISPLAY BY NAME g_mlj.mlj01
                    NEXT FIELD mlj01
                OTHERWISE EXIT CASE
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i999_mlj01(p_cmd,l_mlj01)
 
    DEFINE p_cmd    LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
           l_mlj01  LIKE mlj_file.mlj01,
           l_gaz03  LIKE gaz_file.gaz03,
           ls_msg   LIKE ze_file.ze03
    DEFINE l_cnt    LIKE type_file.num10          #No.FUN-680102INTEGER 
    LET g_errno = " "
 
    # 當若 user 端試輸入保留字時則帶出 error message
    #IF p_cmd != "d" AND l_mlj01 = "DEFAULT" THEN  #FUN-870102 mark
    IF (p_cmd != "d" AND l_mlj01 = "DEFAULT") OR (p_cmd != "r" AND l_mlj01 = "CR") THEN #FUN-870102
        LET l_mlj01 = " "
        DISPLAY l_mlj01 TO mlj01
        LET g_errno = "aoo-998" RETURN l_mlj01
    END IF
 
     #MOD-490349
    IF p_cmd = "d" AND l_mlj01 = "DEFAULT" THEN
       SELECT ze03 INTO ls_msg FROM ze_file
        WHERE ze01 = "aoo-993" AND ze02 = g_lang
       DISPLAY ls_msg CLIPPED TO gaz03
       RETURN l_mlj01
    END IF
 
    ### FUN-870102 START ###
    # CR郵件主機   
    IF p_cmd = "r" AND l_mlj01 = "CR" THEN  #CR郵件主機
       SELECT ze03 INTO ls_msg FROM ze_file
        WHERE ze01 = "aoo1000" AND ze02 = g_lang #在p_ze中設定,aoo1000:CR郵件主機維護作業
       DISPLAY ls_msg CLIPPED TO gaz03
       RETURN l_mlj01
    END IF
    ### FUN-870102 END ###
    
 ## No.MOD-4A0206
#    SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
#     WHERE gaz_file.gaz01 = l_mlj01 AND gaz_file.gaz02 = g_lang
#    IF l_cnt > 1 THEN
#       SELECT gaz03 INTO l_gaz03 FROM gaz_file
#        WHERE gaz_file.gaz01 = l_mlj01 AND gaz_file.gaz02 = g_lang AND gaz_file.gaz05='Y'
#    ELSE
#       SELECT gaz03 INTO l_gaz03 FROM gaz_file
#        WHERE gaz_file.gaz01 = l_mlj01 AND gaz_file.gaz02 = g_lang AND gaz_file.gaz05='N'
#    END IF
 ## END No.MOD-4A0206 ##
 
     #MOD-540163
    CALL cl_get_progname(l_mlj01,g_lang) RETURNING l_gaz03
 
    IF SQLCA.SQLCODE THEN
        IF SQLCA.SQLCODE = 100 THEN LET g_errno = "aoo-997"
        ELSE LET g_errno = SQLCA.sqlcode USING "-------"
        END IF
        LET l_mlj01 = " "
        LET l_gaz03 = " "
        DISPLAY l_mlj01 TO mlj01
    END IF
 
    DISPLAY l_gaz03 TO gaz03
 
    RETURN l_mlj01
 
END FUNCTION
 
FUNCTION i999_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_mlj.* TO NULL                #No.FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg("q")
    DISPLAY '   ' TO FORMONLY.cnt             #
    CALL i999_curs("q")                       # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i999_count
    FETCH i999_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i999_cs                              # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)
        INITIALIZE g_mlj.* TO NULL
    ELSE
        CALL i999_fetch("F")                      # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i999_fetch(p_flmlj)
    DEFINE
        p_flmlj          LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
        l_gaz03          LIKE gaz_file.gaz03,
        l_abso           LIKE type_file.num10         #No.FUN-680102 INTEGER
    DEFINE
        l_cnt            LIKE type_file.num10          #No.FUN-680102INTEGER 
 
    CASE p_flmlj
        WHEN 'N' FETCH NEXT     i999_cs INTO g_mlj.mlj01
        WHEN 'P' FETCH PREVIOUS i999_cs INTO g_mlj.mlj01
        WHEN 'F' FETCH FIRST    i999_cs INTO g_mlj.mlj01
        WHEN 'L' FETCH LAST     i999_cs INTO g_mlj.mlj01
        WHEN '/'
            IF (NOT mi_no_ask) THEN             #No.FUN-6A0066
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
            FETCH ABSOLUTE g_jump i999_cs INTO g_mlj.mlj01
            LET mi_no_ask = FALSE          #No.FUN-6A0066
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)
        INITIALIZE g_mlj.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmlj
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT mlj_file.mlj01, '',   mlj_file.mlj07,  mlj_file.mlj02, '',
           mlj_file.mlj03,  mlj_file.mlj04,  mlj_file.mlj05,  mlj_file.mlj06,
           mlj_file.mlj08, mlj_file.mlj09, #FUN-8A0022
           mlj_file.mlj10, mlj_file.mlj11, #FUN-CA0116
           mlj_file.mljuser,mlj_file.mljgrup,mlj_file.mljmodu,mlj_file.mljdate
      INTO g_mlj.* FROM mlj_file             # 重讀DB,因TEMP有不被更新特性
       WHERE mlj_file.mlj01 = g_mlj.mlj01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("sel","mlj_file",g_mlj.mlj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
    ELSE
 #     #MOD-540163
      CALL cl_get_progname(g_mlj.mlj01,g_lang) RETURNING g_mlj.gaz03
 
#        #因為 zz_file 有語言別的問題  所以另外做
 #    ## No.MOD-4A0206
#        SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
#         WHERE gaz01 = g_mlj.mlj01 AND gaz02 = g_lang AND gaz05 = 'Y'
#        IF l_cnt > 0 THEN
#           SELECT gaz03 INTO g_mlj.gaz03 FROM gaz_file
#            WHERE gaz01 = g_mlj.mlj01 AND gaz02 = g_lang AND gaz05='Y'
#        ELSE
#           SELECT gaz03 INTO g_mlj.gaz03 FROM gaz_file
#            WHERE gaz01 = g_mlj.mlj01 AND gaz02 = g_lang AND gaz05='N'
#        END IF
 #  ## END No.MOD-4A0206 ##
        #MOD-D90062---begin mark
        #IF SQLCA.sqlcode THEN
        #    CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)
        #ELSE                                     #FUN-4C0044權限控管
        #MOD-D90062---end
           LET g_data_owner = g_mlj.mljuser
           LET g_data_group = g_mlj.mljgrup
           CALL i999_show()                      # 重新顯示
       #END IF     #MOD-D90062
    END IF
END FUNCTION
 
FUNCTION i999_show()
    DEFINE l_zawcount   INTEGER   #zaw_file中的資料數，用來檢查此程式代碼是否有設定CR報表       #TQC-890008
    
    LET l_zawcount = 0          #在zaw_file中的資料數    #TQC-890008
    LET g_mlj_t.* = g_mlj.*
    LET g_mlj_o.* = g_mlj.*
 
    ### TQC-890008 START ###
      #查zaw_file中的資料數，檢查此程式代碼是否有設定CR報表
      #有zaw資料：預設值與"CR"資料相同
      #無zaw資料：預設值與"DEFAULT"資料相同
    IF NOT cl_null(g_mlj.mlj01) THEN
       SELECT COUNT(zaw01)
          INTO l_zawcount
          FROM zaw_file
          WHERE zaw01 = g_mlj.mlj01
    END IF     
    
    IF l_zawcount > 0 THEN
        CALL i999_default("CR")          #預設值與"CR"資料相同
    ELSE
        CALL i999_default("DEFAULT")     #預設值與"DEFAULT"資料相同
    END IF
    ### TQC-890008 END ### 
    
    IF g_mlj.mlj03 = g_default03 AND g_mlj.mlj04 = g_default04 AND
    	 g_mlj.mlj09 = g_default09 AND  #FUN-8A0022
       g_mlj.mlj05 = g_default05 THEN
 
    # 若 mail server data 與 default 同則不顯示 (g_string 可設定期望字串)
        LET g_mlj.def = "N"  # 是否自定 MailServer = "N" 採預設值
    ELSE
        LET g_mlj.def = "Y"  # 是否自定 MailServer = "Y" 採自定值
    END IF
 
    DISPLAY BY NAME g_mlj.*

    #FUN-CA0116---start---
    IF g_mlj.mlj10 = "Y" THEN
        CALL cl_set_comp_visible("mlj11",TRUE)
    ELSE
        CALL cl_set_comp_visible("mlj11",FALSE)
    END IF
    #FUN-CA0116---END---
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i999_u()
    DEFINE l_equal INTEGER           #0:不相等，1:相等   #TQC-890008
    IF s_shut(0) THEN RETURN END IF
 
    IF g_mlj.mlj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    MESSAGE ""
 
    CALL cl_opmsg('u')
    LET g_mlj01_t = g_mlj.mlj01
 
    BEGIN WORK
 
    OPEN i999_cl USING g_mlj.mlj01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN i999_cl:", STATUS, 1)
       CLOSE i999_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i999_cl INTO g_mlj.*                 # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
 #   #MOD-
#    SELECT gaz02 INTO g_mlj.gaz03 FROM gaz_file   # 因為 FETCH 不會選擇不同 table
#     WHERE gaz_file.gaz01 = g_mlj.mlj01           # 的資料  所以重選 gaz03 (可看
#       AND gaz_file.gaz02 = g_lang                # OPEN CURSOR 處
#       order by gaz05
    #LET g_mlj.mljmodu = g_user                    # 修改者   #TQC-890008 mark
    #LET g_mlj.mljdate = today                     # 修改日期  #TQC-890008 mark
    
    CALL i999_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i999_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_mlj.*=g_mlj_t.*
            CALL i999_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        
        ### TQC-890008 START ###
        #NULL不可用等號比較兩者是否相等，mlj06為非必填欄位，有可能是NULL
        LET l_equal = 0
        IF cl_null(g_mlj.mlj06) AND cl_null(g_mlj_t.mlj06) THEN   
             LET l_equal = 1
        ELSE
            IF (NOT cl_null(g_mlj.mlj06)) AND (NOT cl_null(g_mlj_t.mlj06)) THEN
                IF g_mlj.mlj06 = g_mlj_t.mlj06 THEN
                    LET l_equal = 1
                END IF
            END IF 
        END IF
 
        IF g_mlj.mlj01 = g_mlj_t.mlj01 AND g_mlj.mlj02 = g_mlj_t.mlj02 AND
           g_mlj.mlj03 = g_mlj_t.mlj03 AND g_mlj.mlj04 = g_mlj_t.mlj04 AND
           g_mlj.mlj05 = g_mlj_t.mlj05 AND g_mlj.mlj07 = g_mlj_t.mlj07 AND 
           g_mlj.mlj09 = g_mlj_t.mlj09 AND #FUN-8A0022
           g_mlj.mlj10 = g_mlj_t.mlj10 AND g_mlj.mlj11 = g_mlj_t.mlj11 AND #FUN-CA0116
           g_mlj.mlj08 = g_mlj_t.mlj08 AND l_equal = 1           
        THEN
            LET g_success="N"
            MESSAGE "UNCHANGED!"
        ELSE
            LET g_mlj.mljmodu = g_user   # 修改者
            LET g_mlj.mljdate = today    # 修改日期   #TQC-890008
        END IF
        ### TQC-890008 END ###
        
        UPDATE mlj_file SET mlj_file.mlj01 = g_mlj.mlj01,    # 更新DB
                            mlj_file.mlj02 = g_mlj.mlj02,
                            mlj_file.mlj03 = g_mlj.mlj03,
                            mlj_file.mlj04 = g_mlj.mlj04,
                            mlj_file.mlj05 = g_mlj.mlj05,
                            mlj_file.mlj06 = g_mlj.mlj06,
                            mlj_file.mlj07 = g_mlj.mlj07,
                            mlj_file.mlj08 = g_mlj.mlj08,
                            mlj_file.mlj09 = g_mlj.mlj09, #FUN-8A0022
                            mlj_file.mlj10 = g_mlj.mlj10, #FUN-CA0116
                            mlj_file.mlj11 = g_mlj.mlj11, #FUN-CA0116
                            mlj_file.mljuser = g_mlj.mljuser,
                            mlj_file.mljgrup = g_mlj.mljgrup,
                            mlj_file.mljmodu = g_mlj.mljmodu,
                            mlj_file.mljdate = g_mlj.mljdate
            WHERE mlj01 = g_mlj.mlj01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","mlj_file",g_mlj_t.mlj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_success='N'
            CONTINUE WHILE
        ELSE
            LET g_success='Y'
            CALL i999_show() #更新顯示 #TQC-890008
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i999_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i999_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_mlj.mlj01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i999_cl USING g_mlj.mlj01
 
    IF STATUS THEN
       CALL cl_err("OPEN i999_cl:", STATUS, 1)
       CLOSE i999_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i999_cl INTO g_mlj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i999_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "mlj01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_mlj.mlj01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM mlj_file WHERE mlj01=g_mlj.mlj01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("del","mlj_file",g_mlj.mlj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           LET g_success='N'
        ELSE
           CLEAR FORM
           LET g_success='Y'
           OPEN i999_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE i999_cs
              CLOSE i999_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH i999_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i999_cs
              CLOSE i999_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i999_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i999_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE    #No.FUN-6A0066
              CALL i999_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i999_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i999_copy()
    DEFINE
        l_n              LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_new_mlj01      LIKE mlj_file.mlj01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_mlj.mlj01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    CALL cl_set_comp_entry("mlj01",TRUE)   #按了Action(CR郵件主機、預設郵件主機)，也可以使用複製功能   #FUN-940099
    
    INPUT l_new_mlj01 FROM mlj01
        BEFORE FIELD mlj01
            DISPLAY " " TO gaz03
 
        AFTER FIELD mlj01
            IF NOT cl_null(l_new_mlj01) THEN
                CALL i999_mlj01("c",l_new_mlj01) RETURNING l_new_mlj01
                IF NOT cl_null(g_errno) THEN
                     CALL cl_err(l_new_mlj01, g_errno, 0)
                     LET l_new_mlj01 = " "
                     NEXT FIELD mlj01
                END IF
            ELSE
                NEXT FIELD mlj01
            END IF
 
            SELECT count(*) INTO g_cnt FROM mlj_file
             WHERE mlj01 = l_new_mlj01
 
            IF g_cnt > 0 THEN
                CALL cl_err(l_new_mlj01,-239,0)
                NEXT FIELD mlj01
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(mlj01)
#                   CALL q_zz(l_new_mlj01) RETURNING l_new_mlj01
#                   CALL FGL_DIALOG_SETBUFFER( l_new_mlj01 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_gaz'
                    LET g_qryparam.default1 = l_new_mlj01
                    LET g_qryparam.arg1= g_lang
                    CALL cl_create_qry() RETURNING l_new_mlj01
#                    CALL FGL_DIALOG_SETBUFFER( l_new_mlj01 )
                    DISPLAY l_new_mlj01 TO mlj01
                    NEXT FIELD mlj01
                OTHERWISE EXIT CASE
            END CASE
 
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
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_mlj.mlj01
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM mlj_file
        #WHERE mlj01 = g_mlj.mlj01   #FUN-940099 mark
        WHERE mlj01 = g_mlj.mlj01    #FUN-940099
        INTO TEMP x
    UPDATE x
        SET mlj01   = l_new_mlj01,# 資料鍵值
            mljuser = g_user,     # 資料所有者
            mljgrup = g_grup,     # 資料所有者所屬群
            mljmodu = NULL,       # 資料修改日期
            mljdate = today       # 資料建立日期
 
    INSERT INTO mlj_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","mlj_file",g_mlj.mlj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        RETURN
    ELSE
        MESSAGE 'ROW(',l_new_mlj01,') O.K'
    END IF
 
    # 更新 rowid 以使 update 時可抓到此筆資料
    SELECT mlj01 INTO g_mlj.mlj01 FROM mlj_file
     WHERE mlj01 = l_new_mlj01
 
    # 更新總數
    OPEN i999_count
    FETCH i999_count INTO g_cnt
    DISPLAY g_cnt TO FORMONLY.cnt
    CLOSE i999_count
 
END FUNCTION
 
FUNCTION i999_d()
 
    DEFINE l_first_sw LIKE type_file.chr1           #No.FUN-680102CHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_mlj.* TO NULL
    LET l_first_sw = "N"
 
#          mlj01,gaz03,mlj07,mlj02,def
    SELECT '','','','','',mlj03,mlj04,mlj05,mlj06,mlj08,mlj10,mlj11,mljuser,mljgrup,
           mljmodu,mljdate
      INTO g_mlj.*
      FROM mlj_file WHERE mlj01='DEFAULT'
    IF SQLCA.SQLCODE THEN
       IF SQLCA.SQLCODE = 100 THEN
          INITIALIZE g_mlj.* TO NULL
          LET g_mlj.mlj01   = "DEFAULT"
          LET g_mlj.mljuser = g_user
          LET g_mlj.mljgrup = g_grup
          LET g_mlj.mljdate = today                 #修改日期
          #MOD-D90155---begin
          LET g_mlj.def = "N"
          LET g_mlj.mlj07 = "N"
          LET g_mlj.mlj10 = "N"
          LET g_mlj.mlj11 = "S"
          #MOD-D90155---end
 
           INSERT INTO mlj_file (mlj01,mlj02,mlj03,mlj04,mlj05,mlj06,  #No.MOD-470041
                                mlj07,mlj08,mlj10,mlj11,mljuser,mljgrup,mljmodu,mljdate,mljoriu,mljorig) #FUN-CA0116 
               VALUES (g_mlj.mlj01,g_mlj.mlj02,g_mlj.mlj03,g_mlj.mlj04,
                       g_mlj.mlj05,g_mlj.mlj06,g_mlj.mlj07,g_mlj.mlj08,
                       g_mlj.mlj10,g_mlj.mlj11, #FUN-CA0116
                       g_mlj.mljuser,g_mlj.mljgrup,g_mlj.mljmodu,g_mlj.mljdate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
          LET l_first_sw = "Y"
       ELSE
          LET g_errno = SQLCA.sqlcode USING "-------"
#         CALL cl_err("Default",g_errno,0)    #No.FUN-660131
          CALL cl_err3("ins","mlj_file",g_mlj.mlj01,"",SQLCA.sqlcode,"","Default",1)  #No.FUN-660131
          RETURN
       END IF
    END IF
 
    MESSAGE ""
    CALL cl_opmsg("u")
    LET g_success="Y"
    BEGIN WORK
 
    LET g_mlj_t.* = g_mlj.*
    DISPLAY BY NAME g_mlj.*
 
    WHILE TRUE
        CALL i999_i("d")
        IF INT_FLAG THEN                          # 若按了DEL鍵
#           INITIALIZE g_mlj.* TO NULL
            LET g_success="N"
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
#           CLEAR FORM
            EXIT WHILE
        END IF
        IF g_mlj.mlj03 = g_mlj_t.mlj03 AND g_mlj.mlj04 = g_mlj_t.mlj04 AND
           g_mlj.mlj05 = g_mlj_t.mlj05 AND g_mlj.mlj06 = g_mlj_t.mlj06 AND
           g_mlj.mlj08 = g_mlj_t.mlj08
        THEN
            LET g_success="N"
            MESSAGE "UNCHANGED!"
        END IF
 
        # 更新DB
        UPDATE mlj_file SET mlj_file.mlj03 = g_mlj.mlj03,
                            mlj_file.mlj04 = g_mlj.mlj04,
                            mlj_file.mlj05 = g_mlj.mlj05,
                            mlj_file.mlj06 = g_mlj.mlj06,
                            mlj_file.mlj08 = g_mlj.mlj08,                            
                            mlj_file.mljuser = g_mlj.mljuser,
                            mlj_file.mljgrup = g_mlj.mljgrup,
                            mlj_file.mljmodu = g_mlj.mljmodu,
                            mlj_file.mljdate = g_mlj.mljdate
                      WHERE mlj_file.mlj01 = 'DEFAULT'
        IF SQLCA.sqlcode THEN
            LET g_success="N"
#           CALL cl_err(g_mlj.mlj01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","mlj_file",g_mlj_t.mlj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    IF g_success='Y' THEN
        COMMIT WORK
        LET g_default03 = g_mlj.mlj03
        LET g_default04 = g_mlj.mlj04
        LET g_default05 = g_mlj.mlj05
        LET g_default06 = g_mlj.mlj06
        LET g_default07 = g_mlj.mlj08
        LET g_default09 = g_mlj.mlj09
        IF l_first_sw = "N" THEN CALL cl_err('DEFAULT:','aoo-995',0) END IF
    ELSE
        ROLLBACK WORK
    END IF
    DISPLAY "DEFAULT" TO mlj01
     CALL i999_mlj01("d","DEFAULT") RETURNING g_mlj.mlj01         #MOD-490349
 
END FUNCTION
 
#### FUN-870102 SATRT ###
# CR郵件主機
FUNCTION i999_d2(p_mlj01)
    DEFINE p_mlj01     LIKE mlj_file.mlj01, 
           p_cmd       LIKE type_file.chr1    
    DEFINE l_first_sw  LIKE type_file.chr1              
    DEFINE l_equal INTEGER           #0:不相等，1:相等   #TQC-890008
    
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_mlj.* TO NULL
    LET l_first_sw = "N"
 
    CASE p_mlj01
      WHEN "DEFAULT"
        LET p_cmd = "d"
      WHEN "CR"
        LET p_cmd = "r"
      END CASE 
    
    SELECT '','','','','',mlj03,mlj04,mlj05,mlj06,mlj08,mlj09,mlj10,mlj11,mljuser,mljgrup, #FUN-8A0022 FUN-CA0116
           mljmodu,mljdate
      INTO g_mlj.*
      FROM mlj_file WHERE mlj01=p_mlj01
    
    
    IF SQLCA.SQLCODE THEN
       IF SQLCA.SQLCODE = 100 THEN
          INITIALIZE g_mlj.* TO NULL
          LET g_mlj.mlj01   = p_mlj01
          LET g_mlj.mljuser = g_user
          LET g_mlj.mljgrup = g_grup
          LET g_mlj.mljdate = today                 #修改日期
          #MOD-D90155---begin
          LET g_mlj.def = "N"
          LET g_mlj.mlj07 = "N"
          LET g_mlj.mlj10 = "N"
          LET g_mlj.mlj11 = "S"
          #MOD-D90155---end
 
           INSERT INTO mlj_file (mlj01,mlj02,mlj03,mlj04,mlj05,mlj06,  
                                mlj07,mlj08,mlj09,mlj10,mlj11,mljuser,mljgrup,mljmodu,mljdate,mljoriu,mljorig) #FUN-8A0022 FUN-CA0116
               VALUES (g_mlj.mlj01,g_mlj.mlj02,g_mlj.mlj03,g_mlj.mlj04,
                       g_mlj.mlj05,g_mlj.mlj06,g_mlj.mlj07,g_mlj.mlj08,g_mlj.mlj09, #FUN-8A0022
                       g_mlj.mlj10,g_mlj.mlj11,  #FUN-CA0116
                       g_mlj.mljuser,g_mlj.mljgrup,g_mlj.mljmodu,g_mlj.mljdate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
          LET l_first_sw = "Y"
       ELSE
          LET g_errno = SQLCA.sqlcode USING "-------"
          CALL cl_err3("ins","mlj_file",g_mlj.mlj01,"",SQLCA.sqlcode,"",p_mlj01,1)  
          RETURN
       END IF
    END IF
 
    ### TQC-890008 mark START ###
    #自訂MailServer參數
    #CALL cl_set_comp_required("mlj03,mlj04,mlj05", TRUE) #動態設定欄位是否必須輸入值
 
    #應檢查認證
    #IF g_mlj.mlj08 = "Y" THEN
    #   CALL cl_set_comp_required("mlj06", TRUE) #動態設定欄位是否必須輸入值
    #ELSE
    #   CALL cl_set_comp_required("mlj06", FALSE)
    #END IF
    ### TQC-890008 mark END ###
   
    #FUN-CA0116---start---
    IF g_mlj.mlj10 = "Y" THEN
        CALL cl_set_comp_visible("mlj11",TRUE)
    ELSE
        CALL cl_set_comp_visible("mlj11",FALSE)
    END IF
    #FUN-CA0116---END--- 
    
    CALL cl_opmsg("u")
    LET g_success="Y"
    BEGIN WORK
 
    LET g_mlj_t.* = g_mlj.*
    DISPLAY BY NAME g_mlj.*
 
    WHILE TRUE
        CALL i999_i(p_cmd)  
       
        IF INT_FLAG THEN                          # 若按了DEL鍵
            LET g_success="N"
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        
        ### TQC-890008 mark START ###
        #IF g_mlj.mlj03 = g_mlj_t.mlj03 AND g_mlj.mlj04 = g_mlj_t.mlj04 AND
        #   g_mlj.mlj05 = g_mlj_t.mlj05 AND g_mlj.mlj06 = g_mlj_t.mlj06 AND
        #   g_mlj.mlj08 = g_mlj_t.mlj08
        ### TQC-890008 mark END ###
        
        ### TQC-890008 START ###
        #NULL不可用等號比較兩者是否相等，mlj06為非必填欄位，有可能是NULL
        LET l_equal = 0
        IF cl_null(g_mlj.mlj06) AND cl_null(g_mlj_t.mlj06) THEN   
             LET l_equal = 1
        ELSE
            IF (NOT cl_null(g_mlj.mlj06)) AND (NOT cl_null(g_mlj_t.mlj06)) THEN
                IF g_mlj.mlj06 = g_mlj_t.mlj06 THEN
                    LET l_equal = 1
                END IF
            END IF 
        END IF
        
        IF g_mlj.mlj03 = g_mlj_t.mlj03 AND g_mlj.mlj04 = g_mlj_t.mlj04 AND
           g_mlj.mlj05 = g_mlj_t.mlj05 AND g_mlj.mlj08 = g_mlj_t.mlj08 AND
           g_mlj.mlj09 = g_mlj_t.mlj09 AND #FUN-8A0022
           g_mlj.mlj10 = g_mlj_t.mlj10 AND g_mlj.mlj11 = g_mlj_t.mlj11 AND #FUN-CA0116
           l_equal = 1
        ### TQC-890008 END ###
        THEN
            LET g_success="N"
            MESSAGE "UNCHANGED!"
        ELSE
            LET g_mlj.mljmodu = g_user   # 修改者
            LET g_mlj.mljdate = today    # 修改日期   #TQC-890008
        END IF
        
        # 更新DB
        UPDATE mlj_file SET mlj_file.mlj03 = g_mlj.mlj03,
                            mlj_file.mlj04 = g_mlj.mlj04,
                            mlj_file.mlj05 = g_mlj.mlj05,
                            mlj_file.mlj06 = g_mlj.mlj06,
                            mlj_file.mlj08 = g_mlj.mlj08,
                            mlj_file.mlj09 = g_mlj.mlj09, #FUN-8A0022
                            mlj_file.mlj10 = g_mlj.mlj10, #FUN-CA0116
                            mlj_file.mlj11 = g_mlj.mlj11, #FUN-CA0116
                            mlj_file.mljuser = g_mlj.mljuser,
                            mlj_file.mljgrup = g_mlj.mljgrup,
                            mlj_file.mljmodu = g_mlj.mljmodu,
                            mlj_file.mljdate = g_mlj.mljdate
                      WHERE mlj_file.mlj01 = p_mlj01
        IF SQLCA.sqlcode THEN
            LET g_success="N"
            CALL cl_err3("upd","mlj_file",g_mlj_t.mlj01,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    IF g_success='Y' THEN
        COMMIT WORK
        LET g_default03 = g_mlj.mlj03
        LET g_default04 = g_mlj.mlj04
        LET g_default05 = g_mlj.mlj05
        LET g_default06 = g_mlj.mlj06
        LET g_default07 = g_mlj.mlj08
        LET g_default09 = g_mlj.mlj09 #FUN-8A0022
        LET g_default10 = g_mlj.mlj10 #FUN-CA0116
        LET g_default11 = g_mlj.mlj11 #FUN-CA0116
        IF l_first_sw = "N" THEN CALL cl_err('DEFAULT:','aoo-995',0) END IF
    ELSE
        ROLLBACK WORK
    END IF
    DISPLAY p_mlj01 TO mlj01
    DISPLAY g_mlj.mljmodu TO mljmodu
    DISPLAY g_mlj.mljdate TO mljdate  #修改日期   #TQC-890008
    CALL i999_mlj01(p_cmd,p_mlj01) RETURNING g_mlj.mlj01  
 
END FUNCTION
#### FUN-870102 END ###
 
FUNCTION i999_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF INFIELD(def) OR ( NOT g_before_input_done ) THEN
         CALL cl_set_comp_entry("mlj03,mlj04,mlj05,mlj06,mlj08,mlj09,mlj10,mlj11",TRUE) #FUN-CA0116
    END IF
    IF NOT g_before_input_done THEN
         CALL cl_set_comp_entry("mlj01,mlj02,mlj07,mlj02,def",TRUE)
    END IF
END FUNCTION
 
FUNCTION i999_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
    IF INFIELD(def) OR ( NOT g_before_input_done ) THEN
       IF g_mlj.def = "N" THEN
          CALL cl_set_comp_entry("mlj03,mlj04,mlj05,mlj06,mlj08,mlj09,mlj10,mlj11",FALSE) #FUN-CA0116 
       END IF
    END IF
    IF NOT g_before_input_done THEN
       #IF p_cmd = "d" THEN   # FUN-870102 mark
       IF p_cmd = "d" OR p_cmd = "r" THEN  #r:CR郵件主機  FUN-870102
         CALL cl_set_comp_entry("mlj01,mlj02,mlj07,mlj02,def",FALSE)
       END IF
       #FUN-8A0022 start
       IF p_cmd = "d" THEN 
          CALL cl_set_comp_entry("mlj09",FALSE)
       END IF 
       #FUN-8A0022 end
    END IF
#No.FUN-570110 --start
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
       CALL cl_set_comp_entry("mlj01",FALSE)
    END IF
#No.FUN-570110 --end
 
END FUNCTION


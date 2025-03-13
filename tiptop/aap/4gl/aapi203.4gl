# Prog. Version..: '5.30.06-13.04.19(00009)'     #
#
# Pattern name...: aapi203.4gl
# Descriptions...: 應付帳款系統帳款類別科目維護作業
# Date & Author..: 92/12/16 By yen
# Modify.........: 97/04/17 By Danny (將結案科目欄位刪除)
# Modify.........: No.MOD-4B0111 04/11/12 ching copy應set_entry
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0097 04/12/22 By Nicola 報表架構修改
# Modify.........: No.MOD-530129 05/03/17 By Kitty UN-AP改為UNAP
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680029 06/08/17 By Xufeng 兩帳套AAP模塊修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/08 By baogui 結束位置調整
# Modify.........: No.FUN-6A0016 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/03/27 By sherry  會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770005 07/06/27 By ve 報表改為使用crystal report
# Modify.........: No.TQC-770012 07/07/03 By Rayven 復制時，帳款類型和部門編號欄位不能開窗
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850038 08/05/14 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.TQC-940052 09/04/22 By Cockroach 1.當資料有效碼（aptacti)='N'時，不可刪除資料！                               
#                                                      2.修改apt03,apt031錄入之后的判斷
# Modify.........: No.TQC-950008 09/05/05 By xiaofeizhu 如未使用多帳套功能，打印出的報表不應列出借方科目二，貸方科目二欄
# Modify.........: No.FUN-960140 09/07/22 By lutingting新增代銷科目(apt06)以及代銷科目二(apt061)
# Modify.........: No.TQC-970307 09/07/24 By dxfwo  i203_u()中的                                                                    
#   SELECT * INTO g_apt.* FROM apt_file                                                                                             
#    WHERE apt01=g_apt.apt01                                                                                                        
# 應加上apt02為條件，因為apt_file的key值為apt01+apt02
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0109 09/12/24 By lutingting 代銷科目只有業態為零售得時候才會顯示 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30009 10/03/03 By Carrier 更新失败
# Modify.........: No.CHI-A40017 10/04/22 By liuxqa modify sql
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版---str---
# Modify.........: No:FUN-A10066 10/01/13 By Mandy HR整合功能
# Modify.........: No:FUN-A30084 10/03/25 By Mandy HR AP對象:設定時,不可以設MISC的選項,因為例如:健保局,國稅局要區分開來設
# Modify.........: No.FUN-AA0022 10/10/13 By Mandy HR GP5.2 追版---end---
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No:FUN-B40004 11/04/13 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-BB0281 11/11/28 By Dido 當 apz13 為 'Y' 時才檢核部門科目
# Modify.........: No.FUN-BB0047 11/12/31 By fengrui 調整時間函數問題
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20251 12/03/05 By yinhy 狀態頁簽的“資料建立者”“資料建立部門”無法下查詢條件查詢資料
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C50126 12/12/22 By Abby HRM-功能改善專案:增加欄位AP單別(apt08)
# Modify.........: No:FUN-D40074 13/04/19 By Abby 當勾選HR的新流程(aza127)才顯示AP單別(apt08)，否則隱藏apt08

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_apt           RECORD LIKE apt_file.*,
   g_apt_t         RECORD LIKE apt_file.*,
   g_apt_o         RECORD LIKE apt_file.*,
   g_apt01_t       LIKE apt_file.apt01,
   g_apt02_t       LIKE apt_file.apt02,
   g_apt03_t       LIKE apt_file.apt03,
   g_apt04_t       LIKE apt_file.apt04,
   #No.FUN-680029      --Begin
   g_apt031_t      LIKE apt_file.apt031,
   g_apt041_t      LIKE apt_file.apt041,
   #No.FUN-680029      --End
   #FUN-960140--add--str--
   g_apt06_t       LIKE apt_file.apt06,
   g_apt061_t      LIKE apt_file.apt061,
   #FUN-960140--add--end
   g_aag02         LIKE aag_file.aag02,   # No.FUN-690028 VARCHAR(30),    #No:8727
  #g_wc,g_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(300)
   g_wc,g_sql      STRING

DEFINE   g_apt07_t       LIKE apt_file.apt07  #FUN-A10066 add
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   l_table        STRING                 #No.FUN-770005
DEFINE g_argv1     LIKE apt_file.apt01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0055
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055  #FUN-BB0047
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
#No.FUN-770005--begin--                                                                                                             
   LET g_sql="apt01.apt_file.apt01,",
             "apr02.apr_file.apr02,",
             "apt02.apt_file.apt02,",
             "gem02.gem_file.gem02,",
             "apt03.apt_file.apt03,",
             "aag02a.aag_file.aag02,",
             "apt04.apt_file.apt04,",
             "aag02b.aag_file.aag02,",
             "apt031.apt_file.apt031,",
             "aag02c.aag_file.aag02,",
             "apt041.apt_file.apt041,",
             "aag02d.aag_file.aag02,",
             "aptacti.apt_file.aptacti"
   LET l_table = cl_prt_temptable('aapi203',g_sql) CLIPPED                # 玻бTemp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                               # Temp Table玻б                                                       
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                  # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,          # TQC-780054                                                          
               " VALUES(?, ?, ?, ?, ?,? ,? ,?,",                                                                                    
               "        ?, ?, ?, ?,?)"                                                                                               
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-BB0047
#No.FUN-770005--end--                
   INITIALIZE g_apt.* TO NULL
   INITIALIZE g_apt_t.* TO NULL
   INITIALIZE g_apt_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM apt_file WHERE apt01 = ? AND apt02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i203_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
   
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW i203_w AT p_row,p_col
     WITH FORM "aap/42f/aapi203"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i203_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i203_a()
            END IF
         OTHERWISE        
            CALL i203_q() 
      END CASE
   END IF
   #--

   #FUN-9C0109--add--str--
   IF g_azw.azw04 = '2' THEN
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_visible("apt06,apt061,aag02_c,aag02_c1",TRUE)
      ELSE
         CALL cl_set_comp_visible("apt06,aag02_c",TRUE)
      END IF 
   ELSE
      CALL cl_set_comp_visible("apt06,apt061,aag02_c,aag02_c1",FALSE)
   END IF
   #FUN-9C0109--add--end

   #FUN-680029  --Begin--
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("apt031",FALSE)
      CALL cl_set_comp_visible("apt041",FALSE)
      CALL cl_set_comp_visible("aag02_a1",FALSE)
      CALL cl_set_comp_visible("aag02_b1",FALSE)
      #FUN-960140--add--str--
      CALL cl_set_comp_visible("apt061",FALSE)
      CALL cl_set_comp_visible("aag02_c1",FALSE) 
      #FUN-960140--add--end
   END IF   
   #FUN-680029  --End--

   #FUN-A10066--add---str---
   IF cl_null(g_aza.aza107) OR g_aza.aza107 = 'N' THEN #串HR否
     #CALL cl_set_comp_visible("apt07,pmc03",FALSE)                      #FUN-C50126 mark
      CALL cl_set_comp_visible("apt07,pmc03,apt08,apydesc,group2",FALSE) #FUN-C50126 add
   ELSE
     #FUN-C50126 mod---str----
     #CALL cl_set_comp_visible("apt07,pmc03",TRUE)
      CALL cl_set_comp_visible("apt07,pmc03,apt08,apydesc,group2",TRUE)
     #FUN-C50126 mod---end----
   END IF   
   #FUN-A10066--add---end---
 
   #FUN-D40074 add str---
   IF g_aza.aza127 = 'Y' THEN #是否走HR新流程
      CALL cl_set_comp_visible("apt08,apydesc",TRUE)
   ELSE
      CALL cl_set_comp_visible("apt08,apydesc",FALSE)
   END IF   
   #FUN-D40074 add end---

   LET g_action_choice=""
 
   CALL i203_menu()
 
   CLOSE WINDOW i203_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
END MAIN
 
FUNCTION i203_cs()
   DEFINE l_t1        LIKE oay_file.oayslip  #FUN-C50126 add 

   CLEAR FORM
   INITIALIZE g_apt.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" apt01='",g_argv1,"'"       #FUN-7C0050
   ELSE
   CONSTRUCT BY NAME g_wc ON apt01,apt02,apt03,apt04,
                             apt07,                  #FUN-A10066 add
                             apt08,                  #FUN-C50126 add
                             aptuser,aptgrup,
                             aptmodu,aptdate,aptacti,
                             aptoriu,aptorig,        #TQC-C20251
                             apt031,apt041,          #No.FUN-680029
                             apt06,apt061,           #FUN-960140
                          #FUN-850038   ---start---
                             aptud01,aptud02,aptud03,aptud04,aptud05,
                             aptud06,aptud07,aptud08,aptud09,aptud10,
                             aptud11,aptud12,aptud13,aptud14,aptud15
                          #FUN-850038    ----end----
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(apt01) #帳款類別
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apr"
               LET g_qryparam.default1 = g_apt.apt01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt01
               CALL i203_apt01('d')
               NEXT FIELD apt01
            WHEN INFIELD(apt02) #部門編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_apt.apt02
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt02
               CALL i203_apt02('d')
               NEXT FIELD apt02
            WHEN INFIELD(apt03) #借方科目
#              CALL q_aapact(TRUE,TRUE,'2',g_apt.apt03)            #No:8727
#                         RETURNING g_qryparam.multiret
               CALL q_aapact(TRUE,TRUE,'2',g_apt.apt03,g_aza.aza81)   #No.FUN-730064
                          RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt03
               CALL i203_apt03('d')
               NEXT FIELD apt03
            #No.FUN-680029           --Begin
            WHEN INFIELD(apt031) #借方科目二
#              CALL q_aapact(TRUE,TRUE,'2',g_apt.apt031)            
#                         RETURNING g_qryparam.multiret
               CALL q_aapact(TRUE,TRUE,'2',g_apt.apt031,g_aza.aza82)    #No.FUN-730064         
                          RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt031
               CALL i203_apt031('d')
               NEXT FIELD apt031
            #No.FUN-680029           --End
            WHEN INFIELD(apt04) #貸方科目
#              CALL q_aapact(TRUE,TRUE,'2',g_apt.apt04)            #No:8727
#                         RETURNING g_qryparam.multiret
               CALL q_aapact(TRUE,TRUE,'2',g_apt.apt04,g_aza.aza81) #No.FUN-730064
                          RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt04
               CALL i203_apt04('d')
               NEXT FIELD apt04
            #No.FUN-680029           --Begin
            WHEN INFIELD(apt041) #貸方科目二
#              CALL q_aapact(TRUE,TRUE,'2',g_apt.apt041)          
#                         RETURNING g_qryparam.multiret
               CALL q_aapact(TRUE,TRUE,'2',g_apt.apt041,g_aza.aza82)  #No.FUN-730064
                          RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt041
               CALL i203_apt041('d')
               NEXT FIELD apt041
            #No.FUN-680029           --End
   
            #FUN-960140--add--str--
            WHEN INFIELD(apt06)  #代銷科目
               CALL q_aapact(TRUE,TRUE,'2',g_apt.apt06,g_aza.aza81)
                          RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO apt06
               CALL i203_apt06('d')
               NEXT FIELD apt06
 
            WHEN INFIELD(apt061)  #代銷科目                                                                                          
               CALL q_aapact(TRUE,TRUE,'2',g_apt.apt061,g_aza.aza82)                                                                 
                          RETURNING g_qryparam.multiret                                                                             
               DISPLAY g_qryparam.multiret TO apt061                                                                                 
               CALL i203_apt061('d')                                                                                                 
               NEXT FIELD apt061
            #FUN-960140--add--end
            #FUN-A10066---add----str---
            WHEN INFIELD(apt07) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt07
               NEXT FIELD apt07
            #FUN-A10066---add----end---
            #FUN-C50126---add---str---
            WHEN INFIELD(apt08) #AP單別
               LET l_t1=s_get_doc_no(g_apt.apt08)
               CALL q_apy(TRUE,FALSE,l_t1,'12','AAP') RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apt08
               NEXT FIELD apt08
            #FUN-C50126---add---end---
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
  END IF  #FUN-7C0050
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND aptuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND aptgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND aptgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aptuser', 'aptgrup')
   #End:FUN-980030
 
 
   LET g_sql="SELECT apt01,apt02 FROM apt_file ", # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED, " ORDER BY apt01"
   PREPARE i203_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i203_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i203_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM apt_file WHERE ",g_wc CLIPPED
   PREPARE i203_precount FROM g_sql
   DECLARE i203_count CURSOR FOR i203_precount
 
END FUNCTION
 
FUNCTION i203_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i203_a()
         END IF
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i203_q()
         END IF
      ON ACTION next
         CALL i203_fetch('N')
      ON ACTION previous
         CALL i203_fetch('P')
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i203_u()
         END IF
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i203_x()
            CALL cl_set_field_pic("","","","","",g_apt.aptacti)
         END IF
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i203_r()
         END IF
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i203_copy()
         END IF
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth()
            THEN CALL i203_out()
         END IF
      ON ACTION help
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_apt.aptacti)
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL i203_fetch('/')
      ON ACTION first
         CALL i203_fetch('F')
      ON ACTION last
         CALL i203_fetch('L')
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
      #No.FUN-6A0016-------add--------str----
      ON ACTION related_document             #相關文件"                        
       LET g_action_choice="related_document"           
          IF cl_chk_act_auth() THEN                     
             IF g_apt.apt01 IS NOT NULL THEN
                LET g_doc.column1 = "apt01"
                LET g_doc.column2 = "apt02"
                LET g_doc.value1 = g_apt.apt01
                LET g_doc.value2 = g_apt.apt02
            CALL cl_doc()                            
             END IF                                        
          END IF                                           
       #No.FUN-6A0016-------add--------end----
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
      #FUN-810046
      &include "qry_string.4gl"
   END MENU
   CLOSE i203_cs
 
END FUNCTION
 
FUNCTION i203_a()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_apt.* LIKE apt_file.*
   LET g_apt_t.* = g_apt.*
   LET g_apt01_t = NULL
   LET g_apt02_t = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_apt.aptacti ='Y'                   #有效的資料
      LET g_apt.aptuser = g_user
      LET g_apt.aptoriu = g_user #FUN-980030
      LET g_apt.aptorig = g_grup #FUN-980030
      LET g_apt.aptgrup = g_grup               #使用者所屬群
      LET g_apt.aptdate = g_today
 
      CALL i203_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_apt.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF cl_null(g_apt.apt01) THEN                   # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF g_apz.apz13 = 'N' THEN
         LET g_apt.apt02 = ' '
      END IF
 
      INSERT INTO apt_file VALUES(g_apt.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)   #No.FUN-660122
         CALL cl_err3("ins","apt_file",g_apt.apt01,g_apt.apt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      ELSE
         LET g_apt_t.* = g_apt.*                # 保存上筆資料
         SELECT apt01,apt02 INTO g_apt.apt01,g_apt.apt02 FROM apt_file
          WHERE apt01 = g_apt.apt01
      END IF
 
      EXIT WHILE
 
   END WHILE
 
END FUNCTION
 
FUNCTION i203_i(p_cmd)
   DEFINE
      p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
      l_dir           LIKE type_file.chr1,   # No.FUN-690028 VARCHAR(1),               #判斷是否
      l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_aag05     LIKE aag_file.aag05     #No.FUN-B40004
   DEFINE li_result   LIKE type_file.num5    #FUN-C50126 add
   DEFINE l_str       LIKE type_file.chr18   #FUN-C50126 add
   DEFINE l_t1        LIKE oay_file.oayslip  #FUN-C50126 add
 
   INPUT BY NAME g_apt.aptoriu,g_apt.aptorig,g_apt.apt01,g_apt.apt02,g_apt.apt03,g_apt.apt06,g_apt.apt04,   #FUN-960140 add apt06
                 g_apt.apt031,g_apt.apt061,g_apt.apt041,                  #NO.FUN-680029   #FUN-960140 add apt061
                 g_apt.apt07,  #FUN-A10066 add apt07
                 g_apt.apt08,  #FUN-C50126 add apt08
                 g_apt.aptuser,
                 g_apt.aptgrup,g_apt.aptmodu,g_apt.aptdate,g_apt.aptacti,
                #FUN-850038     ---start---
                 g_apt.aptud01,g_apt.aptud02,g_apt.aptud03,g_apt.aptud04,
                 g_apt.aptud05,g_apt.aptud06,g_apt.aptud07,g_apt.aptud08,
                 g_apt.aptud09,g_apt.aptud10,g_apt.aptud11,g_apt.aptud12,
                 g_apt.aptud13,g_apt.aptud14,g_apt.aptud15
                #FUN-850038     ----end----
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i203_set_entry(p_cmd)
         CALL i203_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD apt01          #帳款類別:[t1] [apr02   ]
         IF NOT cl_null(g_apt.apt01) THEN
            IF cl_null(g_apt_o.apt01) OR (g_apt.apt01 != g_apt_o.apt01) THEN
               CALL i203_apt01('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apt.apt01,g_errno,0)
                  LET g_apt.apt01 = g_apt_o.apt01
                  DISPLAY BY NAME g_apt.apt01
                  NEXT FIELD apt01
               END IF
            END IF
         END IF
         LET l_dir = ' '
#        IF g_apz.apz13 = 'N' THEN                    #No.TQC-970307                                                                
         IF g_apz.apz13 = 'N' AND  p_cmd = 'a' THEN   #No.TQC-970307 
            LET l_dir = 'D'
            LET g_apt.apt02 = ' '
         END IF
 
      AFTER FIELD apt02            #部門編號
         IF g_apz.apz13 = 'Y' AND cl_null(g_apt.apt02) THEN
            NEXT FIELD apt02
         END IF
         IF NOT cl_null(g_apt.apt02) THEN
            IF cl_null(g_apt_o.apt02) OR (g_apt.apt02 != g_apt_o.apt02) THEN
               CALL i203_apt02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apt.apt02,g_errno,0)
                  LET g_apt.apt02 = g_apt_o.apt02
                  DISPLAY BY NAME g_apt.apt02
                  CALL i203_apt02('a')
                  NEXT FIELD apt02
               END IF
            END IF
         END IF
         LET l_dir = ' '
 
      BEFORE FIELD apt03   # Before apt03 = After apt04
         IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
           (p_cmd = "u" AND (g_apt.apt01 != g_apt01_t
                             OR g_apt.apt02 != g_apt02_t)) THEN
            SELECT count(*) INTO l_n FROM apt_file
             WHERE apt01 = g_apt.apt01
               AND apt02 = g_apt.apt02
            IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(g_apt.apt01,-239,0)
               LET g_apt.apt01 = g_apt01_t
               LET g_apt.apt02 = g_apt02_t
               DISPLAY BY NAME g_apt.apt01
               DISPLAY BY NAME g_apt.apt02
               NEXT FIELD apt01
            END IF
         END IF
         LET g_apt_o.apt01 = g_apt.apt01
         LET g_apt_o.apt02 = g_apt.apt02
         CALL i203_set_entry(p_cmd)     #FUN-960140                                                                                            
 
      AFTER FIELD apt03  # 會計科目, 可空白, 須存在
         LET l_dir = 'U'
#No.TQC-940052 add start--     
            IF g_apt.apt03 IS NOT NULL OR g_apt.apt03 != ' ' THEN  
               IF (g_apt_o.apt03 IS NULL) OR (g_apt.apt03 != g_apt_o.apt03) THEN  
                  CALL i203_apt03('a')     
                  IF NOT cl_null(g_errno) THEN     
                     CALL cl_err(g_apt.apt03,g_errno,0)   
                     #FUN-B20004--begin
                     CALL q_aapact(FALSE,FALSE,'2',g_apt.apt03,g_aza.aza81)       
                          RETURNING g_apt.apt03    
                     #LET g_apt.apt03 = g_apt_o.apt03   
                     #FUN-B20004--end 
                     DISPLAY BY NAME g_apt.apt03    
                     NEXT FIELD apt03      
                  END IF         
                  IF g_apz.apz13 = 'Y' THEN    #MOD-BB0281
                     #No.FUN-B40004  --Begin
                     LET l_aag05=''
                     SELECT aag05 INTO l_aag05 FROM aag_file
                      WHERE aag01 = g_apt.apt03
                        AND aag00 = g_aza.aza81
                     IF l_aag05 = 'Y' THEN
                        #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                        IF g_aaz.aaz90 !='Y' THEN
                           LET g_errno = ' '
                           CALL s_chkdept(g_aaz.aaz72,g_apt.apt03,g_apt.apt02,g_aza.aza81)
                                RETURNING g_errno
                        END IF
                     END IF
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_apt.apt03,g_errno,0)
                        DISPLAY BY NAME g_apt.apt03
                        NEXT FIELD apt03
                     END IF
                     #No.FUN-B40004  --End
                  END IF    #MOD-BB0281
               END IF  
            END IF    
         LET g_apt_o.apt03 = g_apt.apt03  
#         IF g_apt.apt03 IS NULL THEN  
#            DISPLAY "" TO aag02_a    
#         END IF           
#No.TQC-940052 add end--   
        #FUN-960140--add--str--
        IF cl_null(g_apt.apt03) OR g_apt.apt03 = 'STOCK' OR g_apt.apt03 = 'MISC' OR                                                      
           g_apt.apt03 = 'UNAP' THEN
           CALL cl_set_comp_entry("apt06",FALSE)  
           LET g_apt.apt06 = g_apt.apt03
           DISPLAY BY NAME g_apt.apt06
           CALL i203_apt06('d')
        END IF 
        #FUN-960140--add--end
 
      BEFORE FIELD apt04   # Before apt04 = After apt03
        #IF g_apt.apt03 = 'MISC' THEN
        #    CALL i203_ddd()
        #ELSE
            IF g_apt.apt03 IS NOT NULL OR g_apt.apt03 != ' ' THEN
               IF (g_apt_o.apt03 IS NULL) OR (g_apt.apt03 != g_apt_o.apt03) THEN
                  CALL i203_apt03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_apt.apt03,g_errno,0)
                     LET g_apt.apt03 = g_apt_o.apt03                                       
                     DISPLAY BY NAME g_apt.apt03
                     NEXT FIELD apt03
                  END IF
               END IF
            END IF
        #END IF
         LET g_apt_o.apt03 = g_apt.apt03
 
      AFTER FIELD apt04  #會計科目, 可空白, 須存在
         IF g_apt.apt04 IS NOT NULL THEN
            IF (g_apt_o.apt04 IS NULL) OR (g_apt.apt04 != g_apt_o.apt04) THEN
               CALL i203_apt04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apt.apt04,g_errno,0)
                  #FUN-B20004--begin
                  CALL q_aapact(FALSE,FALSE,'2',g_apt.apt04,g_aza.aza81) 
                          RETURNING g_apt.apt04
                  #LET g_apt.apt04 = g_apt_o.apt04
                  #FUN-B20004--end
                  DISPLAY BY NAME g_apt.apt04
                  NEXT FIELD apt04
               END IF
               IF g_apz.apz13 = 'Y' THEN    #MOD-BB0281
                  #No.FUN-B40004  --Begin
                  LET l_aag05=''
                  SELECT aag05 INTO l_aag05 FROM aag_file
                   WHERE aag01 = g_apt.apt04
                     AND aag00 = g_aza.aza81
                  IF l_aag05 = 'Y' THEN
                     #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                     IF g_aaz.aaz90 !='Y' THEN
                        LET g_errno = ' '
                        CALL s_chkdept(g_aaz.aaz72,g_apt.apt04,g_apt.apt02,g_aza.aza81)
                             RETURNING g_errno
                     END IF
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_apt.apt04,g_errno,0)
                     DISPLAY BY NAME g_apt.apt04
                     NEXT FIELD apt04
                  END IF
                  #No.FUN-B40004  --End
               END IF     #MOD-BB0281
            END IF
         END IF
         LET g_apt_o.apt04 = g_apt.apt04
         IF g_apt.apt04 IS NULL THEN
            DISPLAY "" TO aag02_b
         END IF 
  
      #No.FUN-680029           --Begin
      BEFORE FIELD apt031   # Before apt031 = After apt041
         IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
           (p_cmd = "u" AND (g_apt.apt01 != g_apt01_t
                             OR g_apt.apt02 != g_apt02_t)) THEN
            SELECT count(*) INTO l_n FROM apt_file
             WHERE apt01 = g_apt.apt01
               AND apt02 = g_apt.apt02
            IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(g_apt.apt01,-239,0)
               LET g_apt.apt01 = g_apt01_t
               LET g_apt.apt02 = g_apt02_t
               DISPLAY BY NAME g_apt.apt01
               DISPLAY BY NAME g_apt.apt02
               NEXT FIELD apt01
            END IF
         END IF
         LET g_apt_o.apt01 = g_apt.apt01
         LET g_apt_o.apt02 = g_apt.apt02
         CALL i203_set_entry(p_cmd)           #FUN-960140                                                                                       
 
      AFTER FIELD apt031  # 會計科目, 可空白, 須存在
         LET l_dir = 'U'
 
#No.TQC-940052 ADD START--                                                                                                          
            IF g_apt.apt031 IS NOT NULL OR g_apt.apt031 != ' ' THEN  
               IF (g_apt_o.apt031 IS NULL) OR (g_apt.apt031 != g_apt_o.apt031) THEN  
                  CALL i203_apt031('a') 
                  IF NOT cl_null(g_errno) THEN  
                     CALL cl_err(g_apt.apt031,g_errno,0) 
                     #FUN-B20004--begin
                     CALL q_aapact(FALSE,FALSE,'2',g_apt.apt031,g_aza.aza82)       
                          RETURNING g_apt.apt031 
                     #LET g_apt.apt031 = g_apt_o.apt031  
                     #FUN-B20004--end
                     DISPLAY BY NAME g_apt.apt031  
                     NEXT FIELD apt031  
                  END IF  
               END IF  
            END IF    
         LET g_apt_o.apt031 = g_apt.apt031  
#         IF g_apt.apt031 IS NULL THEN   
#            DISPLAY "" TO aag02_a1    
#         END IF   
#No.TQC-940052 ADD END--   
        #FUN-960140--add--str--                                                                                                     
        IF cl_null(g_apt.apt031) OR g_apt.apt031 = 'STOCK' OR g_apt.apt031 = 'MISC' OR                                                 
           g_apt.apt031 = 'UNAP' THEN                                                                                                
           CALL cl_set_comp_entry("apt061",FALSE)
           LET g_apt.apt061 = g_apt.apt031                                                                                            
           DISPLAY BY NAME g_apt.apt061                                                                                              
           CALL i203_apt061('d')                                                                                                     
        END IF                                                                                                                      
        #FUN-960140--add--end
 
      BEFORE FIELD apt041   # Before apt041 = After apt031
        #IF g_apt.apt031 = 'MISC' THEN
        #    CALL i203_ddd()
        #ELSE
            IF g_apt.apt031 IS NOT NULL OR g_apt.apt031 != ' ' THEN
               IF (g_apt_o.apt031 IS NULL) OR (g_apt.apt031 != g_apt_o.apt031) THEN
                  CALL i203_apt031('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_apt.apt031,g_errno,0)
                     LET g_apt.apt031 = g_apt_o.apt031
                     DISPLAY BY NAME g_apt.apt031
                     NEXT FIELD apt031
                  END IF
               END IF
            END IF
        #END IF
         LET g_apt_o.apt031 = g_apt.apt031
 
      AFTER FIELD apt041  #會計科目, 可空白, 須存在
         IF g_apt.apt041 IS NOT NULL THEN
            IF (g_apt_o.apt041 IS NULL) OR (g_apt.apt041 != g_apt_o.apt041) THEN
               CALL i203_apt041('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apt.apt041,g_errno,0)
                  #FUN-B20004--begin
                  CALL q_aapact(FALSE,FALSE,'2',g_apt.apt041,g_aza.aza82)  
                       RETURNING g_apt.apt041
                  #LET g_apt.apt041 = g_apt_o.apt041
                  #FUN-B20004--end
                  DISPLAY BY NAME g_apt.apt041
                  NEXT FIELD apt041
               END IF
            END IF
         END IF
         LET g_apt_o.apt041 = g_apt.apt041
         IF g_apt.apt041 IS NULL THEN
            DISPLAY "" TO aag02_b1
         END IF
      #No.FUN-680029              --End   
 
      #FUN-960140--add--str--
 
      AFTER FIELD apt06     #會計科目 可空白 需存在
         IF NOT cl_null(g_apt.apt06) THEN 
            IF (g_apt_o.apt06 IS NULL) OR (g_apt.apt06 != g_apt_o.apt06) THEN
               CALL i203_apt06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apt.apt06,g_errno,0)
                  #FUN-B20004--begin
                  CALL q_aapact(FALSE,FALSE,'2',g_apt.apt06,g_aza.aza81)
                       RETURNING g_apt.apt06
                  #LET g_apt.apt06 = g_apt_o.apt06
                  #FUN-B20004--end
                  DISPLAY BY NAME g_apt.apt06
                  NEXT FIELD apt06
               END IF 
            END IF 
         END IF 
         LET g_apt_o.apt06 = g_apt.apt06
         IF g_apt.apt06 IS NULL THEN
            DISPLAY "" TO aag02_c
         END IF  
 
      AFTER FIELD apt061    #會計科目 可空白 需存在
         IF NOT cl_null(g_apt.apt061) THEN
            IF (g_apt_o.apt061 IS NULL) OR (g_apt.apt061 != g_apt_o.apt061) THEN
               CALL i203_apt061('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apt.apt061,g_errno,0)
                  #FUN-B20004--begin
                  CALL q_aapact(FALSE,FALSE,'2',g_apt.apt061,g_aza.aza82)
                       RETURNING g_apt.apt061
                  #LET g_apt.apt061 = g_apt_o.apt061
                  #FUN-B20004--end
                  DISPLAY BY NAME g_apt.apt061
                  NEXT FIELD apt061
               END IF 
            END IF 
         END IF
         LET g_apt_o.apt061 = g_apt.apt061
         IF g_apt.apt061 IS NULL THEN
            DISPLAY "" TO aag02_c1
         END IF    
      #FUN-960140--add--end

      #FUN-A10066---add---str---
      AFTER FIELD apt07
         IF NOT cl_null(g_apt.apt07) THEN
            IF g_apt_o.apt07 IS NULL OR g_apt.apt07 != g_apt_o.apt07 THEN
              #FUN-A30084---add--str--
               IF g_apt.apt07 = 'MISC' THEN
                   LET g_errno = 'aap-370' #不可以設MISC
               ELSE
                   CALL i203_apt07()
               END IF
              #FUN-A30084---add--end--
              #CALL i203_apt07() #FUN-A30084 mark
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_apt.apt07,g_errno,1)
                  LET g_apt.apt07 = g_apt_o.apt07
                  DISPLAY BY NAME g_apt.apt07
                  CALL i203_apt07()
                  NEXT FIELD apt07
               END IF
               DISPLAY BY NAME g_apt.apt07
            END IF
            LET g_apt_o.apt07 = g_apt.apt07
         END IF
      #FUN-A10066---add---end---
 
      #FUN-C50126---add---str---
      AFTER FIELD apt08 #AP單別
         IF NOT cl_null(g_apt.apt08) THEN
             CALL s_check_no("aap",g_apt.apt08,g_apt_t.apt08,"12","apa_file","apa01","")
             RETURNING li_result,l_str
             IF (NOT li_result) THEN
                LET g_apt.apt08 = g_apt_o.apt08
                DISPLAY BY NAME g_apt.apt08
                NEXT FIELD apt08
             END IF
             LET g_apt_o.apt08 = g_apt.apt08
             DISPLAY g_apy.apydesc TO apydesc
         END IF
      #FUN-C50126---add---end--- 

        #FUN-850038     ---start---
        AFTER FIELD aptud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aptud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850038     ----end----
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_apt.aptuser = s_get_data_owner("apt_file") #FUN-C10039
         LET g_apt.aptgrup = s_get_data_group("apt_file") #FUN-C10039
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(g_apt.apt01) THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_apt.apt01
         END IF
         IF g_apz.apz13 = 'Y' THEN
            IF cl_null(g_apt.apt02) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_apt.apt02
            END IF
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD apt01
         END IF
 
      #-----FUN-630081---------
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(apt01) THEN
      #      LET g_apt.* = g_apt_t.*
      #      DISPLAY BY NAME g_apt.*
      #      NEXT FIELD apt01
      #   END IF
      #-----END FUN-630081-----
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(apt01) #帳款類別
#              CALL q_apr(10,3,g_apt.apt01) RETURNING g_apt.apt01
#              CALL FGL_DIALOG_SETBUFFER( g_apt.apt01 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_apr"
               LET g_qryparam.default1 = g_apt.apt01
               CALL cl_create_qry() RETURNING g_apt.apt01
#              CALL FGL_DIALOG_SETBUFFER( g_apt.apt01 )
               DISPLAY BY NAME g_apt.apt01
               CALL i203_apt01('d')
               NEXT FIELD apt01
            WHEN INFIELD(apt02) #部門編號
#              CALL q_gem(10,3,g_apt.apt02) RETURNING g_apt.apt02
#              CALL FGL_DIALOG_SETBUFFER( g_apt.apt02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_apt.apt02
               CALL cl_create_qry() RETURNING g_apt.apt02
#               CALL FGL_DIALOG_SETBUFFER( g_apt.apt02 )
               DISPLAY BY NAME g_apt.apt02
               CALL i203_apt02('d')
               NEXT FIELD apt02
            WHEN INFIELD(apt03) #借方科目
#              CALL q_aapact(FALSE,TRUE,'2',g_apt.apt03)       #No:8727
#                         RETURNING g_apt.apt03
               CALL q_aapact(FALSE,TRUE,'2',g_apt.apt03,g_aza.aza81)       
                          RETURNING g_apt.apt03                 #No.FUN-730064
#              CALL FGL_DIALOG_SETBUFFER( g_apt.apt03 )
               DISPLAY BY NAME g_apt.apt03
               CALL i203_apt03('d')
               NEXT FIELD apt03
            WHEN INFIELD(apt04) #貸方科目
#              CALL q_aapact(FALSE,TRUE,'2',g_apt.apt04)       #No:8727
#                         RETURNING g_apt.apt04
               CALL q_aapact(FALSE,TRUE,'2',g_apt.apt04,g_aza.aza81)  #No.FUN-730064
                          RETURNING g_apt.apt04
#               CALL FGL_DIALOG_SETBUFFER( g_apt.apt04 )
               DISPLAY BY NAME g_apt.apt04
               CALL i203_apt04('d')
               NEXT FIELD apt04
            #No.FUN-680029            --Begin
            WHEN INFIELD(apt031) #借方科目二
#              CALL q_aapact(FALSE,TRUE,'2',g_apt.apt031)       #No:8727
#                         RETURNING g_apt.apt031
               CALL q_aapact(FALSE,TRUE,'2',g_apt.apt031,g_aza.aza82)  #No.FUN-730064
                          RETURNING g_apt.apt031
#               CALL FGL_DIALOG_SETBUFFER( g_apt.apt031 )
               DISPLAY BY NAME g_apt.apt031
               CALL i203_apt031('d')
               NEXT FIELD apt031
            WHEN INFIELD(apt041) #貸方科目二
#              CALL q_aapact(FALSE,TRUE,'2',g_apt.apt041)       #No:8727
#                         RETURNING g_apt.apt041
               CALL q_aapact(FALSE,TRUE,'2',g_apt.apt041,g_aza.aza82)    #No.FUN-730064
                          RETURNING g_apt.apt041
#               CALL FGL_DIALOG_SETBUFFER( g_apt.apt041 )
               DISPLAY BY NAME g_apt.apt041
               CALL i203_apt041('d')
               NEXT FIELD apt041
            #No.FUN-680029           --End
            
            #FUN-960140--add--str--
            WHEN INFIELD(apt06)   #代銷科目
               CALL q_aapact(FALSE,TRUE,'2',g_apt.apt06,g_aza.aza81)
                          RETURNING g_apt.apt06
               DISPLAY BY NAME g_apt.apt06
               CALL i203_apt06('d')
               NEXT FIELD apt06
 
            WHEN INFIELD(apt061)   #代銷科目二
               CALL q_aapact(FALSE,TRUE,'2',g_apt.apt061,g_aza.aza82)
                          RETURNING g_apt.apt061
               DISPLAY BY NAME g_apt.apt061
               CALL i203_apt061('d')
               NEXT FIELD apt061
            #FUN-960140--add--end
            #FUN-A10066---add---str---
            WHEN INFIELD(apt07) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = g_apt.apt07
               CALL cl_create_qry() RETURNING g_apt.apt07
               DISPLAY BY NAME g_apt.apt07
               CALL i203_apt07()
               NEXT FIELD apt07
            #FUN-A10066---add---end---
            #FUN-C50126---add---str---
            WHEN INFIELD(apt08) #AP單別
               LET l_t1=s_get_doc_no(g_apt.apt08)
               CALL q_apy(FALSE,FALSE,l_t1,'12','AAP') RETURNING l_t1
               LET g_apt.apt08 =l_t1
               DISPLAY BY NAME g_apt.apt08
               CALL i203_apt08('d')
               NEXT FIELD apt08
            #FUN-C50126---add---end---
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
 
FUNCTION i203_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apt01",TRUE)
   END IF
 
   IF g_apz.apz13 = 'Y' OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apt02",TRUE)
   END IF
 
   CALL cl_set_comp_entry("apt06,apt061",TRUE)    #FUN-960140 
 
END FUNCTION
 
FUNCTION i203_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apt01",FALSE)
   END IF
 
   IF g_apz.apz13 = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apt02",FALSE)
   END IF
   
END FUNCTION
 
FUNCTION i203_apt01(p_cmd)  #帳款類別
   DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_apr02 LIKE apr_file.apr02,
          l_apracti LIKE apr_file.apracti
 
   LET g_errno = ' '
   SELECT apr02,apracti INTO l_apr02,l_apracti
     FROM apr_file
    WHERE apr01 = g_apt.apt01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-067'
                           LET l_apr02 = NULL
        WHEN l_apracti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_apr02 TO FORMONLY.apr02
   END IF
 
END FUNCTION
 
FUNCTION i203_apt02(p_cmd)  #部門編號
    DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
           INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = g_apt.apt02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-063'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION i203_apt03(p_cmd)  #借方科目
    DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_aag02 LIKE aag_file.aag02    #No:8727
 
    LET g_errno = ' '
    IF g_apt.apt03 = "STOCK" THEN DISPLAY "" TO aag02_a RETURN END IF
     IF g_apt.apt03 = "UNAP" THEN DISPLAY "" TO aag02_a RETURN END IF   #No.MOD-530129
#    CALL s_aapact(g_apz.apz11,g_apt.apt03) RETURNING l_aag02
     CALL s_aapact(g_apz.apz11,g_aza.aza81,g_apt.apt03) RETURNING l_aag02    #No.FUN-730064
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_aag02 TO FORMONLY.aag02_a
    END IF
END FUNCTION
 
FUNCTION i203_apt04(p_cmd)  #貸方科目
    DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_aag02 LIKE aag_file.aag02
 
    LET g_errno = ' '
    IF g_apt.apt03 = "STOCK" THEN DISPLAY "" TO aag02_a END IF
     IF g_apt.apt03 = "UNAP" THEN DISPLAY "" TO aag02_a END IF    #No.MOD-530129
#   CALL s_aapact(g_apz.apz11,g_apt.apt04) RETURNING l_aag02
    CALL s_aapact(g_apz.apz11,g_aza.aza81,g_apt.apt04) RETURNING l_aag02  #No.FUN-730064
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_aag02 TO FORMONLY.aag02_b
    END IF
END FUNCTION
 
#No.FUN-680029         --Begin
FUNCTION i203_apt031(p_cmd)  #借方科目二
    DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_aag02 LIKE aag_file.aag02    #No:8727
 
    LET g_errno = ' '
    IF g_apt.apt031 = "STOCK" THEN DISPLAY "" TO aag02_a1 RETURN END IF
     IF g_apt.apt031 = "UNAP" THEN DISPLAY "" TO aag02_a1 RETURN END IF   #No.MOD-530129
#   CALL s_aapact(g_apz.apz11,g_apt.apt031) RETURNING l_aag02
    CALL s_aapact(g_apz.apz11,g_aza.aza82,g_apt.apt031) RETURNING l_aag02  #No.FUN-730064
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_aag02 TO FORMONLY.aag02_a1
    END IF
END FUNCTION
 
FUNCTION i203_apt041(p_cmd)  #貸方科目
    DEFINE p_cmd LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_aag02 LIKE aag_file.aag02
 
    LET g_errno = ' '
    IF g_apt.apt031 = "STOCK" THEN DISPLAY "" TO aag02_a1 END IF
     IF g_apt.apt031 = "UNAP" THEN DISPLAY "" TO aag02_a1 END IF    #No.MOD-530129
#   CALL s_aapact(g_apz.apz11,g_apt.apt041) RETURNING l_aag02
    CALL s_aapact(g_apz.apz11,g_aza.aza82,g_apt.apt041) RETURNING l_aag02  #No.FUN-730064
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_aag02 TO FORMONLY.aag02_b1
    END IF
END FUNCTION
#No.FUN-680029        ---End
 
#FUN-960140--add--str
FUNCTION i203_apt06(p_cmd)   #代銷科目
   DEFINE p_cmd   LIKE type_file.chr1,
          l_aag02 LIKE aag_file.aag02
 
   LET g_errno = ' '
   CALL s_aapact(g_apz.apz11,g_aza.aza81,g_apt.apt06) RETURNING l_aag02
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_aag02 TO FORMONLY.aag02_c
   END IF
END FUNCTION 
 
FUNCTION i203_apt061(p_cmd)  #代銷科目二
   DEFINE p_cmd   LIKE type_file.chr1,
          l_aag02 LIKE aag_file.aag02
 
   LET g_errno = ' '
   CALL s_aapact(g_apz.apz11,g_aza.aza82,g_apt.apt061) RETURNING l_aag02
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_aag02 TO FORMONLY.aag02_c1
   END IF 
END FUNCTION
#FUN-960140--add--end
FUNCTION i203_ddd()
   DEFINE l_aag02         LIKE aag_file.aag02 # No.FUN-690028 VARCHAR(30)
 
   INPUT BY NAME g_apt.apt031,g_apt.apt032,g_apt.apt033,g_apt.apt034,
                 g_apt.apt035,g_apt.apt036,g_apt.apt037,g_apt.apt038,
                 g_apt.apt039 WITHOUT DEFAULTS
 
      AFTER FIELD apt031
         IF g_apt.apt031 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt031) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,g_aza.aza82,g_apt.apt031) RETURNING l_aag02   #No.FUN-730064
 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt031
            END IF
            DISPLAY l_aag02 TO aag02_1
         END IF
 
      AFTER FIELD apt032
         IF g_apt.apt032 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt032) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt032) RETURNING l_aag02 #No.FUN-730064
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt032
            END IF
            DISPLAY l_aag02 TO aag02_2
         END IF
 
      AFTER FIELD apt033
         IF g_apt.apt033 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt033) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt033) RETURNING l_aag02  #No.FUN-730064
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt033
            END IF
            DISPLAY l_aag02 TO aag02_3
         END IF
 
      AFTER FIELD apt034
         IF g_apt.apt034 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt034) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt034) RETURNING l_aag02   #No.FUN-730064
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt034
            END IF
            DISPLAY l_aag02 TO aag02_4
         END IF
 
      AFTER FIELD apt035
         IF g_apt.apt035 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt035) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt035) RETURNING l_aag02   #No.FUN-730064
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt035
            END IF
            DISPLAY l_aag02 TO aag02_5
         END IF
 
      AFTER FIELD apt036
         IF g_apt.apt036 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt036) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt036) RETURNING l_aag02   #No.FUN-730064
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt036
            END IF
            DISPLAY l_aag02 TO aag02_6
         END IF
 
      AFTER FIELD apt037
         IF g_apt.apt037 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt037) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt037) RETURNING l_aag02   #No.FUN-730064
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt037
            END IF
            DISPLAY l_aag02 TO aag02_7
         END IF
 
      AFTER FIELD apt038
         IF g_apt.apt038 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt038) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt038) RETURNING l_aag02   #No.FUN-730064 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt038
            END IF
            DISPLAY l_aag02 TO aag02_8
         END IF
 
      AFTER FIELD apt039
         IF g_apt.apt039 IS NOT NULL THEN
#           CALL s_aapact(g_apz.apz11,g_apt.apt039) RETURNING l_aag02
            CALL s_aapact(g_apz.apz11,'',g_apt.apt039) RETURNING l_aag02   #No.FUN-730064
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD apt039
            END IF
            DISPLAY l_aag02 TO aag02_9
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
 
END FUNCTION
 
FUNCTION i203_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_apt.* TO NULL              #No.FUN-6A0016
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i203_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
 
   OPEN i203_count
   FETCH i203_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i203_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)
      INITIALIZE g_apt.* TO NULL
   ELSE
      CALL i203_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ""
 
END FUNCTION
 
FUNCTION i203_fetch(p_flapt)
   DEFINE
       p_flapt          LIKE type_file.chr1   # No.FUN-690028 VARCHAR(1)
 
   CASE p_flapt
      WHEN 'N' FETCH NEXT     i203_cs INTO g_apt.apt01,g_apt.apt02
      WHEN 'P' FETCH PREVIOUS i203_cs INTO g_apt.apt01,g_apt.apt02
      WHEN 'F' FETCH FIRST    i203_cs INTO g_apt.apt01,g_apt.apt02
      WHEN 'L' FETCH LAST     i203_cs INTO g_apt.apt01,g_apt.apt02
      WHEN '/'
         IF NOT mi_no_ask THEN
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
         FETCH ABSOLUTE g_jump i203_cs INTO g_apt.apt01,g_apt.apt02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)
      INITIALIZE g_apt.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flapt
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_apt.* FROM apt_file            # 重讀DB,因TEMP有不被更新特性
    WHERE apt01 = g_apt.apt01 AND apt02 = g_apt.apt02
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)   #No.FUN-660122
      CALL cl_err3("sel","apt_file",g_apt.apt01,g_apt.apt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
   ELSE
      LET g_data_owner = g_apt.aptuser     #No.FUN-4C0047
      LET g_data_group = g_apt.aptgrup     #No.FUN-4C0047
      CALL i203_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i203_show()
   DEFINE l_aag02   LIKE aag_file.aag02 # No.FUN-690028 VARCHAR(30)
 
   LET g_apt_t.* = g_apt.*
 
   DISPLAY BY NAME g_apt.apt01,g_apt.apt02,g_apt.apt03,g_apt.apt04, g_apt.aptoriu,g_apt.aptorig,
       g_apt.aptuser,g_apt.aptgrup,g_apt.aptmodu,g_apt.aptdate,g_apt.aptacti,
       g_apt.apt031,g_apt.apt041,                   #No.FUN-680029
       g_apt.apt06,g_apt.apt061,                    #FUN-960140
       g_apt.apt07, #FUN-A10066 add apt07
       g_apt.apt08, #FUN-C50126 add apt08
      #FUN-850038     ---start---
       g_apt.aptud01,g_apt.aptud02,g_apt.aptud03,g_apt.aptud04,
       g_apt.aptud05,g_apt.aptud06,g_apt.aptud07,g_apt.aptud08,
       g_apt.aptud09,g_apt.aptud10,g_apt.aptud11,g_apt.aptud12,
       g_apt.aptud13,g_apt.aptud14,g_apt.aptud15
      #FUN-850038     ----end----
 
   CALL i203_apt01('d')
   CALL i203_apt02('d')
   CALL i203_apt03('d')
   CALL i203_apt04('d')
   #No.FUN-680029  --Begin
   CALL i203_apt031('d')
   CALL i203_apt041('d')
   #No.FUN-680029  --End
   CALL i203_apt06('d')    #FUN-960140
   CALL i203_apt061('d')   #FUN-960140
   CALL i203_apt07() #FUN-A10066 add
   CALL i203_apt08('d') #FUN-C50126 add

   CALL cl_set_field_pic("","","","","",g_apt.aptacti)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i203_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_apt.apt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_apt.* FROM apt_file
    WHERE apt01=g_apt.apt01
      AND apt02=g_apt.apt02     #No.TQC-970307 
 
   IF g_apt.aptacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_apt.apt01,'9027',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN i203_cl USING g_apt.apt01,g_apt.apt02
   IF STATUS THEN
      CALL cl_err("OPEN i203_cl:", STATUS, 1)
      CLOSE i203_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i203_cl INTO g_apt.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_apt01_t = g_apt.apt01
   LET g_apt02_t = g_apt.apt02
   LET g_apt03_t = g_apt.apt03
   LET g_apt04_t = g_apt.apt04
   #No.FUN-680029   --Begin
   LET g_apt031_t = g_apt.apt031
   LET g_apt041_t = g_apt.apt041
   #No.FUN-680029   --End
   LET g_apt06_t = g_apt.apt06     #FUN-960140
   LET g_apt061_t = g_apt.apt061   #FUN-960140
   LET g_apt07_t = g_apt.apt07 #FUN-A10066 add
   LET g_apt_o.*=g_apt.*
   LET g_apt.aptmodu=g_user                     #修改者
   LET g_apt.aptdate = g_today                  #修改日期
 
   CALL i203_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i203_i("u")                      # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_apt.*=g_apt_t.*
         CALL i203_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE apt_file SET apt_file.* = g_apt.*    # 更新DB
    #  WHERE apt01 = g_apt.apt01 AND apt02 = g_apt.apt02     #No.TQC-A30009
       WHERE apt01 = g_apt.apt01 AND apt02 = g_apt02_t       #No.TQC-A30009
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)   #No.FUN-660122
         CALL cl_err3("upd","apt_file",g_apt01_t,g_apt02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
 
   END WHILE
 
   CLOSE i203_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i203_x()
   DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_apt.apt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i203_cl USING g_apt.apt01,g_apt.apt02
   IF STATUS THEN
      CALL cl_err("OPEN i203_cl:", STATUS, 1)
      CLOSE i203_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i203_cl INTO g_apt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i203_show()
 
   IF cl_exp(15,21,g_apt.aptacti) THEN
      LET g_chr=g_apt.aptacti
      IF g_apt.aptacti='Y' THEN
         LET g_apt.aptacti='N'
      ELSE
         LET g_apt.aptacti='Y'
      END IF
      UPDATE apt_file SET aptacti = g_apt.aptacti,
                          aptmodu = g_user,
                          aptdate = g_today
       WHERE apt01 = g_apt.apt01 AND apt02 = g_apt.apt02
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)   #No.FUN-660122
         CALL cl_err3("upd","apt_file",g_apt.apt01,g_apt.apt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
         LET g_apt.aptacti=g_chr
      END IF
      DISPLAY BY NAME g_apt.aptacti
   END IF
 
   CLOSE i203_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i203_r()
   DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_apt.apt01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
#NO.TQC-940052 ADD BEGIN--  
    IF g_apt.aptacti = 'N' THEN  
       CALL cl_err('','abm-950',0)   
       RETURN  
    END IF    
#NO.TQC-940052 ADD END--    
   BEGIN WORK
 
   OPEN i203_cl USING g_apt.apt01,g_apt.apt02
   IF STATUS THEN
      CALL cl_err("OPEN i203_cl:", STATUS, 1)
      CLOSE i203_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i203_cl INTO g_apt.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i203_show()
 
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "apt01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "apt02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_apt.apt01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_apt.apt02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM apt_file WHERE apt01 = g_apt.apt01 AND apt02 = g_apt.apt02
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_apt.apt01,SQLCA.sqlcode,0)   #No.FUN-660122
         CALL cl_err3("del","apt_file",g_apt.apt01,g_apt.apt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
      ELSE
         CLEAR FORM
         INITIALIZE g_apt.* TO NULL
 
         OPEN i203_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i203_cl
            CLOSE i203_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i203_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i203_cl
            CLOSE i203_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i203_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i203_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i203_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE i203_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i203_copy()
   DEFINE l_apt           RECORD LIKE apt_file.*,
          l_apr02         LIKE apr_file.apr02,
          l_gem02         LIKE gem_file.gem02,
          l_oldno,l_newno LIKE apt_file.apt01,
          l_oldno2,l_newno2 LIKE apt_file.apt02,
          l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_apt.apt01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
    #MOD-4B0111
   LET g_before_input_done = FALSE
   CALL i203_set_entry('a')
   CALL i203_set_no_entry('a')
   LET g_before_input_done = TRUE
   #--
 
   INPUT l_newno,l_newno2 FROM apt01,apt02
 
      AFTER FIELD apt01          #帳款類別
         IF cl_null(l_newno) IS NULL THEN
            CALL cl_err('','aap-099',0)
            NEXT FIELD apt01
         END IF
 
         SELECT apr02 INTO l_apr02
           FROM apr_file
          WHERE apr01 = l_newno
            AND apracti = 'Y'
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_newno,'aap-067',0)   #No.FUN-660122
            CALL cl_err3("sel","apr_file",l_newno,"","aap-067","","",1)  #No.FUN-660122
            NEXT FIELD apt01
         END IF
         DISPLAY l_apr02 TO FORMONLY.apr02
         IF g_apz.apz13 = 'N' THEN
            LET l_newno2 = ' '
         END IF
 
      BEFORE FIELD apt02
         IF g_apz.apz13 = 'N' THEN
            CALL cl_err(g_apz.apz13,'aap-135',0)
            LET l_newno2 = ' '
            EXIT INPUT
          END IF
 
      AFTER FIELD apt02            #部門編號
         IF cl_null(l_newno2) THEN
            CALL cl_err('','aap-099',0)
            NEXT FIELD apt02
         END IF
         SELECT gem02 INTO l_gem02
           FROM gem_file
          WHERE gem01 =l_newno2
            AND gemacti = 'Y'
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_newno2,'aap-063',0)   #No.FUN-660122
            CALL cl_err3("sel","gem_file",l_newno2,"","aap-063","","",1)  #No.FUN-660122
            NEXT FIELD apt02
         END IF
         DISPLAY l_gem02 TO FORMONLY.gem02
 
      AFTER INPUT  #判斷
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         SELECT count(*) INTO l_n FROM apt_file
          WHERE apt01 = l_newno
            AND apt02 = l_newno2
         IF l_n > 0 THEN                  # Duplicated
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD apt01
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      #No.TQC-770012 --start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(apt01) #帳款類別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_apr"
               LET g_qryparam.default1 = l_newno
               CALL cl_create_qry() RETURNING l_newno
               DISPLAY BY NAME l_newno
               NEXT FIELD apt01
            WHEN INFIELD(apt02) #部門編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY BY NAME l_newno2
               NEXT FIELD apt02
            OTHERWISE EXIT CASE
         END CASE
      #No.TQC-770012 --end--
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_apt.apt01,g_apt.apt02
      RETURN
   END IF
 
   LET l_apt.* = g_apt.*
   LET l_apt.apt01  =l_newno   #資料鍵值
   LET l_apt.apt02  =l_newno2  #資料鍵值
   LET l_apt.aptuser=g_user    #資料所有者
   LET l_apt.aptgrup=g_grup    #資料所有者所屬群
   LET l_apt.aptmodu=NULL      #資料修改日期
   LET l_apt.aptdate=g_today   #資料建立日期
   LET l_apt.aptacti='Y'       #有效資料
 
   LET l_apt.aptoriu = g_user      #No.FUN-980030 10/01/04
   LET l_apt.aptorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO apt_file VALUES (l_apt.*)
   IF SQLCA.sqlcode THEN
#     CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660122
      CALL cl_err3("ins","apt_file",l_apt.apt01,l_apt.apt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      LET l_oldno = g_apt.apt01
      SELECT apt_file.* INTO g_apt.* FROM apt_file
       WHERE apt01 = l_newno
      CALL i203_u()
      #SELECT apt_file.* INTO g_apt.* FROM apt_file  #FUN-C30027
       #WHERE apt01 = l_oldno  #FUN-C30027
   END IF
 
   CALL i203_show()
 
END FUNCTION
 
FUNCTION i203_out()
   DEFINE
      l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
      l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
      l_apt   RECORD LIKE apt_file.*,
      l_gem02 LIKE gem_file.gem02,
      l_apr02 LIKE apr_file.apr02,
      l_chr           LIKE type_file.chr1,   #No.FUN-690028 VARCHAR(1)
      l_aag02_d LIKE aag_file.aag02,                                                                                                
      l_aag02_c LIKE aag_file.aag02,                                                                                                
      l_aag02_e LIKE aag_file.aag02,                                                                                                
      l_aag02_f LIKE aag_file.aag02, 
      l_sql           STRING
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
   CALL cl_del_data(l_table)
   CALL cl_wait()
#   CALL cl_outnam('aapi203') RETURNING l_name         #No.FUN-770005
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#CHI-A40017 --begin -- 
#   LET g_sql="SELECT apt_file.*,apr02,gem02",   # 組合出 SQL 指令
#             #" FROM apt_file,OUTER apr_file,OUTER gem_file ",  #CHI-A40017 mark
#             " FROM apt_file LEFT OUTER JOIN apr_file ON apt01=apr01 AND apracti = 'Y' ", #CHI-A40017 mod
#             " LEFT OUTER JOIN gem_file ON apt02 = gem01 AND gemacti = 'Y' ",   #CHI-A40017 mod
#             #" WHERE  apt01 = apr_file.apr01",  #No.FUN-770005 #CHI-A40017 mark
#            " AND apt02 = gem01 ",             #No.FUN-770005  
#             #" AND apt02 = gem_file.gem01",     #No.FUN-770005 #CHI-A40017 mark
#             #"  WHERE  gem_file.gemacti = 'Y' ",    #No.FUN-770005  #CHI-A40017 mark
#             #" AND apr_file.apracti = 'Y' ",    #No.FUN-770005 #CHI-A40017 mark
#             " WHERE ",g_wc CLIPPED   #CHI-A40017 mod
 
   LET g_sql="SELECT apt_file.*,apr02,gem02 ",   # 組合出 SQL 指令
             " FROM apt_file LEFT OUTER JOIN apr_file ON apt01=apr01 AND apracti = 'Y' ", #CHI-A40017 mod
             " LEFT OUTER JOIN gem_file ON apt02 = gem01 AND gemacti = 'Y' ",   #CHI-A40017 mod
             " WHERE ",g_wc CLIPPED   #CHI-A40017 mod
#CHI-A40017 --end 

   PREPARE i203_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i203_co CURSOR FOR i203_p1
#No.FUN-770005 --mark--
{   #FUN-680029   --Begin--
   IF g_aza.aza63= 'Y' THEN
      LET g_zaa[39].zaa06= 'N'
      LET g_zaa[40].zaa06= 'N'
      LET g_zaa[41].zaa06= 'N'
      LET g_zaa[42].zaa06= 'N'
   ELSE
      LET g_zaa[39].zaa06= 'Y'
      LET g_zaa[40].zaa06= 'Y'
      LET g_zaa[41].zaa06= 'Y'
      LET g_zaa[42].zaa06= 'Y'
   END IF  
   CALL cl_prt_pos_len()
   #FUN-680029   --End-- 
}
#No.FUN-770005 --end--
#No.FUN-770005--begin--
 
#  START REPORT i203_rep TO l_name
 
   FOREACH i203_co INTO l_apt.*,l_apr02,l_gem02
      
#        CALL s_aapact(g_apz.apz11,sr.apt03) RETURNING l_aag02_d                                                                    
#        CALL s_aapact(g_apz.apz11,sr.apt04) RETURNING l_aag02_c                                                                    
         CALL s_aapact(g_apz.apz11,g_aza.aza81,l_apt.apt03) RETURNING l_aag02_d    #No.FUN-730064                                      
         CALL s_aapact(g_apz.apz11,g_aza.aza81,l_apt.apt04) RETURNING l_aag02_c    #No.FUN-730064                                      
         #No.FUN-680029  --Begin                                                                                                    
#        CALL s_aapact(g_apz.apz11,sr.apt031) RETURNING l_aag02_e                                                                   
#        CALL s_aapact(g_apz.apz11,sr.apt041) RETURNING l_aag02_f                                                                   
         CALL s_aapact(g_apz.apz11,g_aza.aza82,l_apt.apt031) RETURNING l_aag02_e   #No.FUN-730064                                      
         CALL s_aapact(g_apz.apz11,g_aza.aza82,l_apt.apt041) RETURNING l_aag02_f   #No.FUN-730064                                      
         #No.FUN-680029  --End   
#        IF SQLCA.sqlcode THEN
#        CALL cl_err('Foreach:',SQLCA.sqlcode,1)  
#        EXIT FOREACH
#     END IF
#     OUTPUT TO REPORT i203_rep(l_apt.*,l_apr02,l_gem02)
      EXECUTE insert_prep USING
             l_apt.apt01,l_apr02,l_apt.apt02,l_gem02,l_apt.apt03,
             l_aag02_d,l_apt.apt04,l_aag02_c,l_apt.apt031,l_aag02_e,
             l_apt.apt041,l_aag02_f,l_apt.aptacti
   END FOREACH
{
   FINISH REPORT i203_rep
 
   CLOSE i203_co
   ERROR ""
 
   CALL cl_prt(l_name,' ','1',g_len)
}
   #TQC-950008--Begin--# 
   IF g_aza.aza63 = 'Y' THEN
      LET l_name='aapi203'
   ELSE 
      LET l_name='aapi203_1'
   END IF
   #TQC-950008--End--#   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'apt01,apt02,apt03,apt04,aptuser,aptgrup,           
                          aptmodu,aptdate,aptacti,                           
                          apt031,apt041')
      RETURNING g_wc
   END IF
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
   CALL cl_prt_cs3('aapi203',l_name,l_sql,g_wc)                     #TQC-950008 'aapi203'-->l_name
#No.FUN-770005--end--
END FUNCTION
#No.FUN-770005--begin--
{
REPORT i203_rep(sr,l_apr02,l_gem02)
   DEFINE
      l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      sr RECORD LIKE apt_file.*,
      l_gem02   LIKE gem_file.gem02,
      l_apr02   LIKE apr_file.apr02,
      l_aag02_d LIKE aag_file.aag02,
      l_aag02_c LIKE aag_file.aag02,
      l_aag02_e LIKE aag_file.aag02,
      l_aag02_f LIKE aag_file.aag02,
      l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.apt01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT ' '
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
#        CALL s_aapact(g_apz.apz11,sr.apt03) RETURNING l_aag02_d
#        CALL s_aapact(g_apz.apz11,sr.apt04) RETURNING l_aag02_c
         CALL s_aapact(g_apz.apz11,g_aza.aza81,sr.apt03) RETURNING l_aag02_d    #No.FUN-730064
         CALL s_aapact(g_apz.apz11,g_aza.aza81,sr.apt04) RETURNING l_aag02_c    #No.FUN-730064
         #No.FUN-680029  --Begin
#        CALL s_aapact(g_apz.apz11,sr.apt031) RETURNING l_aag02_e
#        CALL s_aapact(g_apz.apz11,sr.apt041) RETURNING l_aag02_f
         CALL s_aapact(g_apz.apz11,g_aza.aza82,sr.apt031) RETURNING l_aag02_e   #No.FUN-730064
         CALL s_aapact(g_apz.apz11,g_aza.aza82,sr.apt041) RETURNING l_aag02_f   #No.FUN-730064
         #No.FUN-680029  --End
         IF sr.aptacti = 'N' THEN
            PRINT '*';
         END IF
         PRINT COLUMN g_c[31],sr.apt01,
               COLUMN g_c[32],l_apr02,
               COLUMN g_c[33],sr.apt02,
               COLUMN g_c[34],l_gem02,
               COLUMN g_c[35],sr.apt03  CLIPPED,
               COLUMN g_c[36],l_aag02_d CLIPPED,
               COLUMN g_c[37],sr.apt04  CLIPPED,
               COLUMN g_c[38],l_aag02_c CLIPPED,
               #No.FUN-680029   --Begin
               COLUMN g_c[39],sr.apt031 CLIPPED,
               COLUMN g_c[40],l_aag02_e CLIPPED,
               COLUMN g_c[41],sr.apt041 CLIPPED,
               COLUMN g_c[42],l_aag02_f CLIPPED
               #No.FUN-680029   --End
         SKIP 1 LINE
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc,'apt01,apt02,apt03,apt04') RETURNING g_sql
            CALL cl_wcchp(g_wc,'apt01,apt02,apt31,apt041') RETURNING g_sql         #No.FUN-680029
            PRINT g_dash[1,g_len]
            #TQC-630166
            #IF g_sql[001,080] > ' ' THEN
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],g_sql[001,070] CLIPPED
            #END IF
            #IF g_sql[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],g_sql[071,140] CLIPPED
            #END IF
            #IF g_sql[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],g_sql[141,210] CLIPPED
            #END IF
             CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
     #   PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[7] CLIPPED  #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED  #TQC-6A0088
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
    #       PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[6] CLIPPED   #TQC-6A0088
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED   #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-770005--end--
#FUN-A10066---add---str---
FUNCTION i203_apt07()
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE l_pmc05   LIKE pmc_file.pmc05
   DEFINE l_pmcacti LIKE pmc_file.pmcacti

   SELECT   pmc03,  pmc05,  pmcacti
     INTO l_pmc03,l_pmc05,l_pmcacti
     FROM pmc_file 
    WHERE pmc01 = g_apt.apt07

   LET g_errno = ' '

   CASE
      WHEN l_pmcacti = 'N'            LET g_errno = '9028'
      WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'    
      WHEN l_pmc05   = '0'            LET g_errno = 'aap-032'
      WHEN STATUS=100 LET g_errno = '100'  #MOD-4B0124
      WHEN SQLCA.SQLCODE != 0
         LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   DISPLAY l_pmc03 TO pmc03
END FUNCTION
#FUN-A10066---add---end---

#FUN-C50126---add---str---
FUNCTION i203_apt08(p_cmd)  #AP單別
   DEFINE l_apydesc LIKE apy_file.apydesc,
          l_apyacti LIKE apy_file.apyacti,
          l_t1      LIKE oay_file.oayslip,
          p_cmd     LIKE type_file.chr1

   LET g_errno = ' '
   LET l_t1 = s_get_doc_no(g_apt.apt08)
   IF g_apt.apt08 IS NULL THEN
      LET g_errno = 'E'
      LET l_apydesc=NULL
   ELSE
      SELECT apydesc,apyacti
        INTO l_apydesc,l_apyacti
        FROM apy_file WHERE apyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_apydesc = NULL
      ELSE
         IF l_apyacti matches'[nN]' THEN
            LET g_errno = 'E'
         END IF
      END IF
   END IF

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_apydesc TO FORMONLY.apydesc
   END IF

END FUNCTION
#FUN-C50126---add---end---
#FUN-AA0022


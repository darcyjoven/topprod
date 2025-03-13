# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli0031.4gl
# Descriptions...: MISC來源科目設定
# Date & Author..: 07/05/21 By kim (FUN-750058)
# Note...........: 本程式目前只提供外部呼叫,沒有查詢的功能
# Modify.........: No.TQC-760100 07/06/13 By Sarah axs03開窗應開來源公司+來源帳號的一般會計科目(q_aag)
# Modify.........: No.FUN-760053 07/06/21 By Sarah axs03開窗改成開q_axe1
# Modify.........: No.TQC-770095 07/07/18 By Sarah 檢查axs03有沒有存在axe_file時,應該用axe06來當key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/01/06 By Sarah 1.開窗CALL q_axe1需多傳arg3(族群代號),arg4(合併報表帳別)
#                                                  2.增加axs13(族群代號)
# Modify.........: NO.FUN-920057 09/02/05 BY Yiting 來源科目axs03應以上層合併帳別+營運中心檢查科目 
# Modify.........: NO.FUN-950051 09/05/26 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改 
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.FUN-A30122 10/08/19 By vealxu 取合併帳別資料庫改由s_aaz641_dbs，s_get_aaz641取合併帳別
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006
#FUN-750058
DEFINE
    m_axs             RECORD LIKE axs_file.*,
    g_axs             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        axs03         LIKE axs_file.axs03,
        aag02         LIKE aag_file.aag02
                      END RECORD,
    g_axs_t           RECORD                 #程式變數 (舊值)
        axs03         LIKE axs_file.axs03,
        aag02         LIKE aag_file.aag02
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_argv1           LIKE axs_file.axs00,
    g_argv2           LIKE axs_file.axs01,
    g_argv3           LIKE axs_file.axs09,
    g_argv4           LIKE axs_file.axs10,
    g_argv5           LIKE axs_file.axs12,
    g_argv6           LIKE axs_file.axs13    #FUN-910001 add
DEFINE p_row,p_col    LIKE type_file.num5    
DEFINE g_aaz641       LIKE aaz_file.aaz641   #FUN-920057
DEFINE g_axz03        LIKE axz_file.axz03    #FUN-920057
DEFINE g_dbs_axz03    LIKE type_file.chr21   #FUN-920057
DEFINE g_plant_axz03  LIKE type_file.chr21   #FUN-A30122
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03
DEFINE   g_row_count   LIKE type_file.num10
DEFINE   g_curs_index  LIKE type_file.num10
 
MAIN
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   LET g_argv3 =ARG_VAL(3)
   LET g_argv4 =ARG_VAL(4)
   LET g_argv5 =ARG_VAL(5)
   LET g_argv6 =ARG_VAL(6)   #FUN-910001 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i0031_w WITH FORM "agl/42f/agli0031"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   #IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND 
   #        cl_null(g_argv3) AND cl_null(g_argv4) AND 
   #        cl_null(g_argv5)) THEN
   CALL i0031_q()
   #END IF
   CALL i0031_menu()
 
   CLOSE WINDOW i0031_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i0031_cs()
DEFINE l_sql STRING
#
#    IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND 
#            cl_null(g_argv3) AND cl_null(g_argv4) AND 
#            cl_null(g_argv5)) THEN
#       LET g_wc = " axs00 = '",g_argv1,"'",
#                  " AND axs01 = '",g_argv2,"'",
#                  " AND axs09 = '",g_argv3,"'",
#                  " AND axs10 = '",g_argv4,"'",
#                  " AND axs12 = '",g_argv5,"'"
#    ELSE
#       CLEAR FORM                            #清除畫面
#       CALL g_axs.clear()
#       CALL cl_set_head_visible("","YES")
# 
#       CONSTRUCT g_wc ON axs00,axs01,axs03,axs09,axs10,axs12
#          FROM axs01,axs02,s_axs[1].axs03,s_axs[1].axs04,s_axs[1].axs05,s_axs[1].axs06
#               
#       #No.FUN-580031 --start--     HCN
#       BEFORE CONSTRUCT
#          CALL cl_qbe_init()
#       #No.FUN-580031 --end--       HCN
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(axs01) #族群編號
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_axa"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axs01
#                NEXT FIELD axs01
#             WHEN INFIELD(axs02) #公司編號
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_axz"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axs02
#                NEXT FIELD axs02
#             WHEN INFIELD(axs03) #科目
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_axe"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axs03
#                NEXT FIELD axs03
#             WHEN INFIELD(axs06) #幣別
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_azi"
#                LET g_qryparam.default1 = g_axs[1].axs06
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axs06
#                NEXT FIELD axs06
#             END CASE
#          
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
#       
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
#       
#       ON ACTION help          #MOD-4C0121
#          CALL cl_show_help()  #MOD-4C0121
#       
#       ON ACTION controlg      #MOD-4C0121
#          CALL cl_cmdask()     #MOD-4C0121
# 
#       #No.FUN-580031 --start--     HCN
#       ON ACTION qbe_select
#          CALL cl_qbe_select()
#          
#       ON ACTION qbe_save
#          CALL cl_qbe_save()
#       #No.FUN-580031 --end--       HCN
#       
#       END CONSTRUCT
# 
#       IF INT_FLAG THEN
#          RETURN
#       END IF
#    END IF
#
#    IF cl_null(g_wc) THEN
#       LET g_wc="1=1"
#    END IF
#    
    LET l_sql="SELECT UNIQUE axs13,axs00,axs01,axs09,axs10,axs12 FROM axs_file ", #FUN-910001 add axs13
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY axs13,axs00,axs01,axs09,axs10,axs12"  #FUN-910001 add axs13
    PREPARE i0031_prepare FROM g_sql      #預備一下
    DECLARE i0031_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i0031_prepare
 
    DROP TABLE i0031_cnttmp
#   LET l_sql=l_sql," INTO TEMP i0031_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP i0031_cnttmp"  #No.TQC-720019
    
#   PREPARE i0031_cnttmp_pre FROM l_sql       #No.TQC-720019
    PREPARE i0031_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
    EXECUTE i0031_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i0031_cnttmp"      
    
    PREPARE i0031_precount FROM g_sql
    DECLARE i0031_count CURSOR FOR i0031_precount
# 
#    IF NOT cl_null(g_argv1) THEN
#       LET g_axs01=g_argv1
#    END IF
#
#    IF NOT cl_null(g_argv2) THEN
#       LET g_axs02=g_argv2
#    END IF
#
   #CALL i0031_show()
END FUNCTION
 
FUNCTION i0031_menu()
 
   WHILE TRUE
      CALL i0031_bp("G")
      CASE g_action_choice
        #WHEN "insert"
        #   IF cl_chk_act_auth() THEN
        #      IF cl_null(g_argv1) THEN
        #         CALL i0031_a()
        #      END IF
        #   END IF
        #WHEN "query"
        #   IF cl_chk_act_auth() THEN
        #      CALL i0031_q()
        #   END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i0031_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0031_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL i0031_out()
        #   END IF
        #WHEN "exporttoexcel"
        #   IF cl_chk_act_auth() THEN
        #      CALL cl_export_to_excel
        #      (ui.Interface.getRootNode(),base.TypeInfo.create(g_axs),'','')
        #   END IF
        #WHEN "related_document"           #相關文件
        # IF cl_chk_act_auth() THEN
        #    IF g_axs01 IS NOT NULL THEN
        #       LET g_doc.column1 = "axs01"
        #       LET g_doc.column2 = "axs02"
        #       LET g_doc.value1 = g_axs01
        #       LET g_doc.value2 = g_axs02
        #       CALL cl_doc()
        #    END IF 
        # END IF
      END CASE
   END WHILE
END FUNCTION
 
#FUNCTION i0031_a()
#   MESSAGE ""
#   CLEAR FORM
#   CALL g_axs.clear()
#   LET g_axs01_t  = NULL
#   LET g_axs02_t  = NULL
#   CALL cl_opmsg('a')
#
#   WHILE TRUE
#      CALL i0031_i("a")                   #輸入單頭
#
#      IF INT_FLAG THEN                   #使用者不玩了
#         LET g_axs01=NULL
#         LET g_axs02=NULL
#         LET INT_FLAG = 0
#         CALL cl_err('',9001,0)
#         EXIT WHILE
#      END IF
#
#      IF g_ss='N' THEN
#         CALL g_axs.clear()
#      ELSE
#         CALL i0031_b_fill('1=1')            #單身
#      END IF
#
#      CALL i0031_b()                      #輸入單身
#
#      LET g_axs01_t = g_axs01
#      LET g_axs02_t = g_axs02
#      EXIT WHILE
#   END WHILE
#
#END FUNCTION
 
#FUNCTION i0031_i(p_cmd)
#DEFINE
#    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   #No.FUN-680098 VARCHAR(1)
#    l_cnt           LIKE type_file.num10       #No.FUN-680098 INTEGER    
#
#    LET g_ss='Y'
# 
#    LET g_axs01=NULL
#    LET g_axs02=NULL
#    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
#
#    INPUT g_axs01,g_axs02 WITHOUT DEFAULTS
#        FROM axs01,axs02
# 
#       AFTER FIELD axs01
#          IF NOT cl_null(g_axs01) THEN
#             LET g_cnt=0
#             SELECT COUNT(*) INTO g_cnt FROM axa_file
#                                       WHERE axa01=g_axs01
#             IF SQLCA.sqlcode OR (g_cnt=0) THEN
#                CALL cl_err3("sel","axa_file",g_axs01,"",100,"","",1)
#                LET g_axs01=g_axs01_t
#                DISPLAY g_axs01 TO axs01
#                NEXT FIELD CURRENT
#             END IF
#          END IF
#
#       AFTER FIELD axs02
#          IF NOT cl_null(g_axs02) THEN
#             LET g_cnt=0
#             SELECT COUNT(*) INTO g_cnt FROM axz_file
#                                       WHERE axz01=g_axs02
#             IF SQLCA.sqlcode OR (g_cnt=0) THEN
#                CALL cl_err3("sel","axz_file",g_axs02,"",100,"","",1)
#                LET g_axs02=g_axs02_t
#                DISPLAY g_axs02 TO axs02
#                DISPLAY i0031_set_axz02() TO FORMONLY.axz02
#                NEXT FIELD CURRENT
#             END IF
#             DISPLAY i0031_set_axz02() TO FORMONLY.axz02
#          ELSE
#             DISPLAY NULL TO FORMONLY.axz02
#          END IF
#
#       AFTER INPUT
#          IF (NOT cl_null(g_axs01)) AND (NOT cl_null(g_axs02)) THEN
#             LET g_cnt=0
#             SELECT COUNT(*) INTO g_cnt FROM axb_file 
#                                       WHERE axb01=g_axs01
#                                         AND axb04=g_axs02
#             IF SQLCA.sqlcode THEN
#                LET g_cnt=0
#             END IF
#             IF g_cnt=0 THEN
#                CALL cl_err3("sel","axb_file",g_axs01,g_axs02,"agl-094","","",1)
#                CONTINUE INPUT
#             END IF
#          END IF
#
#         ON ACTION CONTROLG
#           CALL cl_cmdask()
#
#         ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
#
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
#
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(axs01) OR INFIELD(axs02)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form  ="q_axb4"
#                CALL cl_create_qry() RETURNING g_axs01,g_axs02
#                DISPLAY g_axs01 TO axs01
#                DISPLAY g_axs02 TO axs02
#                NEXT FIELD axs02
#          END CASE
#
#       ON ACTION CONTROLF                  #欄位說明
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
# 
#    END INPUT
#
#END FUNCTION
 
FUNCTION i0031_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE m_axs.* TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axs.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   LET g_wc = " axs00 = '",g_argv1,"'",
              " AND axs01 = '",g_argv2,"'",
              " AND axs09 = '",g_argv3,"'",
              " AND axs10 = '",g_argv4,"'",
              " AND axs12 = '",g_argv5,"'",
              " AND axs13 = '",g_argv6,"'"   #FUN-910001 add
   CALL i0031_cs()                      #取得查詢條件
  #IF INT_FLAG THEN                    #使用者不玩了
  #   LET INT_FLAG = 0
  #   INITIALIZE g_axs01,g_axs02 TO NULL
  #   RETURN
  #END IF
 
   OPEN i0031_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
     #INITIALIZE m_axs.* TO NULL 
     #外部呼叫,新增時
     LET m_axs.axs00 = g_argv1
     LET m_axs.axs01 = g_argv2
     LET m_axs.axs09 = g_argv3
     LET m_axs.axs10 = g_argv4
     LET m_axs.axs12 = g_argv5
     LET m_axs.axs13 = g_argv6   #FUN-910001 add
     DISPLAY m_axs.axs01 TO axf01
   ELSE
      OPEN i0031_count
      FETCH i0031_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i0031_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i0031_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10   #絕對的筆數  #No.FUN-680098 integer
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i0031_bcs INTO m_axs.axs13,m_axs.axs00,  #FUN-910001 add axs13
                                              m_axs.axs01,m_axs.axs09,
                                              m_axs.axs10,m_axs.axs12
       WHEN 'P' FETCH PREVIOUS i0031_bcs INTO m_axs.axs13,m_axs.axs00,  #FUN-910001 add axs13
                                              m_axs.axs01,m_axs.axs09,
                                              m_axs.axs10,m_axs.axs12
       WHEN 'F' FETCH FIRST    i0031_bcs INTO m_axs.axs13,m_axs.axs00,  #FUN-910001 add axs13
                                              m_axs.axs01,m_axs.axs09,
                                              m_axs.axs10,m_axs.axs12
       WHEN 'L' FETCH LAST     i0031_bcs INTO m_axs.axs13,m_axs.axs00,  #FUN-910001 add axs13
                                              m_axs.axs01,m_axs.axs09,
                                              m_axs.axs10,m_axs.axs12
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i0031_bcs INTO m_axs.axs13,m_axs.axs00,  #FUN-910001 add axs13
                                                 m_axs.axs01,m_axs.axs09,
                                                 m_axs.axs10,m_axs.axs12
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(m_axs.axs01,SQLCA.sqlcode,0)
      #INITIALIZE m_axs.* TO NULL
      #外部呼叫,新增時
      LET m_axs.axs00 = g_argv1
      LET m_axs.axs01 = g_argv2
      LET m_axs.axs09 = g_argv3
      LET m_axs.axs10 = g_argv4
      LET m_axs.axs12 = g_argv5
      LET m_axs.axs13 = g_argv6   #FUN-910001 add
      DISPLAY m_axs.axs01 TO axf01
   ELSE
      CALL i0031_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i0031_show()
 
   DISPLAY m_axs.axs01 TO axf01
   CALL i0031_b_fill(g_wc)                      #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i0031_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680098 smallint
   l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680098   smallint
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680098    VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,          #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5,          #可刪除否          #No.FUN-680098 SMALLINT
   l_cnt           LIKE type_file.num10,         #No.FUN-680098  INTEGER
   l_axz           RECORD LIKE axz_file.*,
   l_axa09         LIKE axa_file.axa09           #FUN-950051 add   
 
   LET g_action_choice = ""
 
   IF cl_null(m_axs.axs01) OR cl_null(m_axs.axs00) OR 
      cl_null(m_axs.axs09) OR cl_null(m_axs.axs10) OR 
      cl_null(m_axs.axs12) OR cl_null(m_axs.axs13) THEN   #FUN-910001 add axs13
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
#FUN-A30122 ----------------------------mark start------------------------------
#  #FUN-950051--mod--str--
#  SELECT axa09 INTO l_axa09 FROM axa_file 
#   WHERE axa01 = g_argv6    #±Ú¸s
#     AND axa02 = g_argv3    #¤½¥q½s¸¹
#  IF l_axa09 = 'Y' THEN
#  #FUN-950051--mod--end
#     #---FUN-920057 start---
#     #找出來源公司所在DB及agls101中aaz641設定合併帳別資料
#     #後續單身對沖科目檢查皆以此DB+合併帳別做為檢查依據及開窗資料
#   
#     #來源公司編號在agli009中所設定工廠/DB
#     SELECT axz03 INTO g_axz03 FROM axz_file
#      WHERE axz01 = g_argv3         #來源公司
#     LET g_plant_new = g_axz03      #營運中心
#     CALL s_getdbs()
#     LET g_dbs_axz03 = g_dbs_new    #上層公司所屬DB
#  
#     #上層公司所屬合併帳別
#    #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102
#     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#     PREPARE i0031_pre_01 FROM g_sql
#     DECLARE i0031_cur_01 CURSOR FOR i0031_pre_01
#     OPEN i0031_cur_01
#     FETCH i0031_cur_01 INTO g_aaz641
#     #---FUN-920057 end---
#  #FUN-950051--mod--str
#  ELSE
#     LET g_plant_new = g_plant   #TQC-9C0099
#     LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)  #當前DB
#     SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
#  END IF 
#  #FUN-950051--mod--end
#FUN-A30122 ----------------------------mark end-------------------------------------------
   CALL s_aaz641_dbs(g_argv6,g_argv3) RETURNING g_plant_axz03  #FUN-A30122 add    
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641         #FUN-A30122 add 

   LET g_forupd_sql = "SELECT axs03,'' FROM axs_file",
                      " WHERE axs00 = ? AND axs01= ?",
                      "   AND axs03 = ? AND axs09= ?",
                      "   AND axs10 = ? AND axs12= ? AND axs13=? FOR UPDATE "  #FUN-910001 add axs13
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i0031_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_axs.clear() END IF
 
   INPUT ARRAY g_axs WITHOUT DEFAULTS FROM s_axs.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_axs_t.* = g_axs[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i0031_bcl USING m_axs.axs00,m_axs.axs01,
                                 g_axs[l_ac].axs03,m_axs.axs09,
                                 m_axs.axs10,m_axs.axs12,
                                 m_axs.axs13   #FUN-910001 add
            IF STATUS THEN
               CALL cl_err("OPEN i0031_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i0031_bcl INTO g_axs[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i0031_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i0031_set_axs03(g_axs[l_ac].axs03) RETURNING g_axs[l_ac].aag02
                  LET g_axs_t.*=g_axs[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axs[l_ac].* TO NULL            #900423
         LET g_axs_t.* = g_axs[l_ac].*               #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD axs03
 
      AFTER FIELD axs03                         # check data 是否重複
         IF NOT cl_null(g_axs[l_ac].axs03) THEN
            IF g_axs[l_ac].axs03 != g_axs_t.axs03 OR g_axs_t.axs03 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM axs_file
                     WHERE axs00=m_axs.axs00
                       AND axs01=m_axs.axs01
                       AND axs03=g_axs[l_ac].axs03
                       AND axs09=m_axs.axs09
                       AND axs10=m_axs.axs10
                       AND axs12=m_axs.axs12
                       AND axs13=m_axs.axs13   #FUN-910001 add
               IF (SQLCA.sqlcode) OR (l_cnt>0) THEN
                  CALL cl_err3("sel","axs_file",g_axs[l_ac].axs03,"","-239","","",1)
                  LET g_axs[l_ac].axs03=g_axs_t.axs03
                  LET g_axs[l_ac].aag02=g_axs_t.aag02
                  DISPLAY BY NAME g_axs[l_ac].axs03,g_axs[l_ac].aag02
                  NEXT FIELD CURRENT
               END IF
               LET l_cnt=0
#--此段檢查需存在合併後財報會科中-- #FUN-920057 mark--
               #SELECT COUNT(*) INTO l_cnt FROM axe_file
               #      WHERE axe00=m_axs.axs00
               #        AND axe01=m_axs.axs09
               #        AND axe13=m_axs.axs13   #FUN-910001 add
               #       #AND axe04=g_axs[l_ac].axs03   #TQC-770095 mark
               #        AND axe06=g_axs[l_ac].axs03   #TQC-770095
               #IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
               #   CALL cl_err3("sel","axs_file",g_axs[l_ac].axs03,"",100,"","",1)
               #   LET g_axs[l_ac].axs03=g_axs_t.axs03
               #   LET g_axs[l_ac].aag02=g_axs_t.aag02
               #   DISPLAY BY NAME g_axs[l_ac].axs03,g_axs[l_ac].aag02
               #   NEXT FIELD CURRENT
               #END IF
#--FUN-920057 end---
               CALL i0031_set_axs03(g_axs[l_ac].axs03)
                          RETURNING g_axs[l_ac].aag02
               DISPLAY BY NAME g_axs[l_ac].aag02
#--FUN-920057 start--
               IF cl_null(g_axs[l_ac].aag02) THEN
                   CALL cl_err('','abg-010',0)
                   #FUN-B20004--begin
                   CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_axs[l_ac].axs03,'23',g_aaz641) #FUN-A30122 add
                        RETURNING g_axs[l_ac].axs03                   
                   #FUN-B20004--end                   
                   NEXT FIELD axs03
               END IF
#--FUN-920057 end--- 
            END IF
         ELSE
            LET g_axs[l_ac].aag02 = null
            DISPLAY BY NAME g_axs[l_ac].aag02
         END IF
 
      AFTER INSERT
         IF INT_FLAG OR cl_null(g_axs[l_ac].axs03) THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_axs[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_axs[l_ac].* TO s_axs.*
           #CALL g_axs.deleteElement(g_rec_b+1)
            ROLLBACK WORK
           #EXIT INPUT
            CANCEL INSERT
         END IF
         INSERT INTO axs_file(axs00,axs01,axs03,axs09,axs10,axs12,axs13)  #FUN-910001 add axs13
              VALUES(m_axs.axs00,m_axs.axs01,g_axs[l_ac].axs03,m_axs.axs09,
                     m_axs.axs10,m_axs.axs12,m_axs.axs13)  #FUN-910001 add axs13
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axs_file",g_axs[l_ac].axs03,'',SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_axs_t.axs03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM axs_file 
                  WHERE axs00=m_axs.axs00
                    AND axs01=m_axs.axs01
                    AND axs03=g_axs_t.axs03
                    AND axs09=m_axs.axs09
                    AND axs10=m_axs.axs10
                    AND axs12=m_axs.axs12
                    AND axs13=m_axs.axs13   #FUN-910001 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axs_file",g_axs[l_ac].axs03,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_axs[l_ac].* = g_axs_t.*
            CLOSE i0031_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axs[l_ac].axs03,-263,1)
            LET g_axs[l_ac].* = g_axs_t.*
         ELSE
            UPDATE axs_file SET axs03 = g_axs[l_ac].axs03
                          WHERE axs00=m_axs.axs00
                            AND axs01=m_axs.axs01
                            AND axs03=g_axs_t.axs03
                            AND axs09=m_axs.axs09
                            AND axs10=m_axs.axs10
                            AND axs12=m_axs.axs12
                            AND axs13=m_axs.axs13   #FUN-910001 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axs_file",g_axs[l_ac].axs03,"",SQLCA.sqlcode,"","",1)
               LET g_axs[l_ac].* = g_axs_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_axs[l_ac].* = g_axs_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_axs.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i0031_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i0031_bcl
         COMMIT WORK
         #CKP2
         #CALL g_axs.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axs03)
#--FUN-920057 start---
               #CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_axs[l_ac].axs03,'23',g_aaz641) #TQC-9C0099
               #CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axs[l_ac].axs03,'23',g_aaz641) #TQC-9C0099  #FUN-A30122 	mark
                CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_axs[l_ac].axs03,'23',g_aaz641) #FUN-A30122 add
                     RETURNING g_axs[l_ac].axs03
                DISPLAY g_axs[l_ac].axs03
                NEXT FIELD axs03
#--FUN-920057 end---
#--FUN-920057 mark--
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_axe1"     #FUN-760053 mod q_axe->q_axe1
#               LET g_qryparam.default1 = g_axs[l_ac].axs03
#               LET g_qryparam.arg1 = m_axs.axs00
#               LET g_qryparam.arg2 = m_axs.axs09
#               LET g_qryparam.arg3 = m_axs.axs13    #FUN-910001 add
#               LET g_qryparam.arg4 = g_aaz.aaz641   #FUN-910001 add
#               CALL cl_create_qry() RETURNING g_axs[l_ac].axs03
#               DISPLAY BY NAME g_axs[l_ac].axs03
#               NEXT FIELD axs03
#--FUN-920057 mark---
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axs02) AND l_ac > 1 THEN
            LET g_axs[l_ac].* = g_axs[l_ac-1].*
            LET g_axs[l_ac].axs03=null
            NEXT FIELD axs03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END INPUT
 
   CLOSE i0031_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i0031_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT axs03,''",
               " FROM axs_file ",
               " WHERE axs00 = '",m_axs.axs00,"'",
               "   AND axs01 = '",m_axs.axs01,"'",
               "   AND axs09 = '",m_axs.axs09,"'",
               "   AND axs10 = '",m_axs.axs10,"'",
               "   AND axs12 = '",m_axs.axs12,"'",
               "   AND axs13 = '",m_axs.axs13,"'",   #FUN-910001 add
               "   AND ",p_wc CLIPPED ,
               " ORDER BY axs03"
   PREPARE i0031_prepare2 FROM g_sql       #預備一下
   DECLARE axs_cs CURSOR FOR i0031_prepare2
 
   CALL g_axs.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH axs_cs INTO g_axs[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i0031_set_axs03(g_axs[g_cnt].axs03) RETURNING g_axs[g_cnt].aag02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_axs.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i0031_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axs TO s_axs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
     #ON ACTION insert
     #   LET g_action_choice="insert"
     #   EXIT DISPLAY
 
     #ON ACTION query
     #   LET g_action_choice="query"
     #   EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i0031_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i0031_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i0031_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i0031_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i0031_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
     #ON ACTION exporttoexcel
     #   LET g_action_choice = 'exporttoexcel'
     #   EXIT DISPLAY
 
     #ON ACTION related_document                #No.FUN-6B0040  相關文件
     #   LET g_action_choice="related_document"          
     #   EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i0031_set_axs03(p_axs03)
DEFINE p_axs03 LIKE axs_file.axs03,
       l_aag02 LIKE aag_file.aag02
DEFINE l_axa09         LIKE axa_file.axa09           #FUN-950051 add   
 
#--FUN-920057 mark
#   SELECT aag02 INTO l_aag02 FROM aag_file
#   #WHERE aag00=m_axs.axs00   #FUN-760053 mark
#   #WHERE aag00=g_aaz.aaz64   #FUN-760053 #¥ÎÁ`±b¹w³]±b§O(aaz64)§ì¬ì¥Ø  #FUN-910001 mark
#    WHERE aag00=g_aaz.aaz641  #FUN-760053 #¥ÎÁ`±b¹w³]±b§O(aaz64)§ì¬ì¥Ø  #FUN-910001
#      AND aag01=p_axs03
#--FUN-920057 mark--
 
#FUN-A30122 -------------------mark start---------------------
#  #FUN-950051--mod--str--
#  SELECT axa09 INTO l_axa09 FROM axa_file 
#   WHERE axa01 = g_argv6    #±Ú¸s
#     AND axa02 = g_argv3    #¤½¥q½s¸¹
#  IF l_axa09 = 'Y' THEN
##--FUN-920057 start--
#      #¨Ó·½¤½¥q½s¸¹¦bagli009¤¤©Ò³]©w¤u¼t/DB
#      SELECT axz03 INTO g_axz03 FROM axz_file
#       WHERE axz01 = g_argv3         #¨Ó·½¤½¥q
#      LET g_plant_new = g_axz03      #Àç¹B¤¤¤ß
#      CALL s_getdbs()
#      LET g_dbs_axz03 = g_dbs_new    #¤W¼h¤½¥q©ÒÄÝDB
#FUN-A30122--------------mark end---------------------------
       CALL s_aaz641_dbs(g_argv6,g_argv3) RETURNING g_plant_axz03  #FUN-A30122
       CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641         #FUN-A30122

       LET g_sql = "SELECT aag02",
                  #"  FROM ",g_dbs_axz03,"aag_file",   #FUN-A50102 
                  #"  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102  #FUN-A30122 mark
                   "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), #FUN-A30122  
                   " WHERE aag00 = '",g_argv1,"'", 
                   "   AND aag01 = '",p_axs03,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102
     # CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102  #FUN-A30122 mark
       CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql             #FUN-A30122 
       PREPARE i0031_pre_03 FROM g_sql
       DECLARE i0031_cur_03 CURSOR FOR i0031_pre_03
       OPEN i0031_cur_03
       FETCH i0031_cur_03 INTO l_aag02
#FUN-A30122 --------------------mark start---------------------
##--FUN-920057 end---
#  #FUN-950051--mod--str
#  ELSE
#     LET g_plant_new = g_plant  #TQC-9C0099
#     LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)  #·í«eDB
#     SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
#     SELECT aag02 INTO l_aag02
#       FROM aag_file
#      WHERE aag00 = g_aaz641
#        AND aag01 = p_axs03
#  END IF 
#  #FUN-950051--mod--end
#FUN-A30122 ------------------mark end-------------------------

   IF SQLCA.sqlcode THEN
      LET l_aag02=NULL
   END IF
   RETURN l_aag02
END FUNCTION
 
FUNCTION i0031_r()
   IF cl_null(m_axs.axs01) OR cl_null(m_axs.axs00) OR 
      cl_null(m_axs.axs09) OR cl_null(m_axs.axs10) OR 
      cl_null(m_axs.axs12) OR cl_null(m_axs.axs13) THEN   #FUN-910001 add axs13
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   DELETE FROM axs_file
               WHERE axs00=m_axs.axs00
                 AND axs01=m_axs.axs01
                 AND axs09=m_axs.axs09
                 AND axs10=m_axs.axs10
                 AND axs12=m_axs.axs12
                 AND axs13=m_axs.axs13   #FUN-910001 add
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","axs_file",m_axs.axs01,m_axs.axs03,SQLCA.sqlcode,"","del axs",1)
      RETURN      
   END IF   
 
   INITIALIZE m_axs.* TO NULL
   MESSAGE ""
   DROP TABLE i0031_cnttmp
   PREPARE i0031_precount_x2 FROM g_sql_tmp
   EXECUTE i0031_precount_x2
   OPEN i0031_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i0031_bcs
      CLOSE i0031_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   FETCH i0031_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i0031_bcs
      CLOSE i0031_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i0031_bcs
      CALL i0031_fetch('F') 
   ELSE
      DISPLAY m_axs.axs01 TO axf01
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_axs.clear()
      CALL i0031_menu()
   END IF                      
END FUNCTION
 
#FUNCTION i0031_out()
#    DEFINE
#        sr              RECORD LIKE axs_file.*,
#        l_i             LIKE type_file.num5,    #No.FUN-680098 SMALLINT
#        l_name          LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680098 VARCHAR(20)
#        l_za05          LIKE za_file.za05       # #No.FUN-680098 VARCHAR(40)
#   
#    IF g_wc IS NULL THEN 
#       IF (NOT cl_null(g_axs01)) AND (NOT cl_null(g_axs02)) THEN
#          LET g_wc=" axs01=",g_axs01,
#                   " AND axs02=",g_axs02
#       ELSE
#          CALL cl_err('',-400,0)
#          RETURN 
#       END IF
#    END IF
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM axs_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED,
#              " ORDER BY axs01,axs02,axs03"
#    PREPARE i0031_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i0031_co                         # SCROLL CURSOR
#         CURSOR FOR i0031_p1
#
#    CALL cl_outnam('agli0031') RETURNING l_name
#    START REPORT i0031_rep TO l_name
#
#    FOREACH i0031_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i0031_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT i0031_rep
#
#    CLOSE i0031_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
 
#REPORT i0031_rep(sr)
#    DEFINE
#        l_trailer_sw   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1),
#        sr RECORD LIKE axs_file.*,
#        l_axz02   LIKE axz_file.axz02,
#        l_aag02   LIKE aag_file.aag02
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.axs01,sr.axs02,sr.axs03
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                  g_x[36],g_x[37],g_x[38]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            SELECT axz02 INTO l_axz02 FROM axz_file WHERE axz01=sr.axs02
#            IF SQLCA.sqlcode THEN
#               LET l_axz02 =NULL
#            END IF
#            SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.axs03
#            IF SQLCA.sqlcode THEN
#               LET l_aag02 =NULL
#            END IF
#            SELECT azi04 INTO t_azi04 FROM azi_file
#                                     WHERE azi01=sr.axs04
#            PRINT COLUMN g_c[31],sr.axs01,
#                  COLUMN g_c[32],sr.axs02,                  
#                  COLUMN g_c[33],l_axz02,
#                  COLUMN g_c[34],sr.axs03,
#                  COLUMN g_c[35],l_aag02,
#                  COLUMN g_c[36],sr.axs04,
#                  COLUMN g_c[37],cl_numfor(sr.axs05,37,t_azi04),
#                  COLUMN g_c[38],sr.axs06
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
 
FUNCTION i0031_set_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("b",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i0031_set_no_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1     #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      IF a != '1' THEN
         CALL cl_set_comp_entry("b",FALSE)
      END IF
   END IF
END FUNCTION

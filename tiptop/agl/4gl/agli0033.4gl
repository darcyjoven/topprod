# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli0033.4gl
# Descriptions...: MISC對沖科目公式設定
# Date & Author..: 07/05/22 By kim (FUN-750058)
# Note...........: 本程式目前只提供外部呼叫,沒有查詢的功能
# Modify.........: No.FUN-760053 07/06/21 By Sarah axu04開窗改成開q_axe1
# Modify.........: No.TQC-770095 07/07/18 By Sarah 檢查axu04有沒有存在axe_file時,應該用axe06來當key值
# Modify.........: No.FUN-770069 07/08/24 By Sarah i0033_b()的AFTER FIELD axu04,count axe_file,應以對沖公司、帳別為key值,抓不到資料cl_err3也應顯示axe_file抓不到資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/01/06 By Sarah 1.開窗CALL q_axe1需多傳arg3(族群代號),arg4(合併報表帳別)
#                                                  2.增加axu13(族群代號)
# Modify.........: NO.FUN-920057 09/02/05 BY Yiting 科目應以上層合併帳別+營運中心檢查科目 
# Modify.........: NO.FUN-950051 09/05/26 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查會科方式修改
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A30122 10/08/20 By vealxu 取合併帳別資料庫改由s_aaz641_dbs，s_get_aaz641取合併帳別
# Modify.........: No.MOD-A80162 10/08/25 By vealxu 拿掉i0033_set_axu04(）這個FUNCTION裏面 call s_aaz641_dbs() 部分,Select aag02 INTO l_aag02的where條件取aag00 = g_aaz641 AND aag01 = p_axu04
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006 
#FUN-750058
#模組變數(Module Variables)
DEFINE
    m_axu             RECORD LIKE axu_file.*,
    g_axu             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        axu04         LIKE axu_file.axu04,
        aag02         LIKE aag_file.aag02,
        axu05         LIKE axu_file.axu05
                      END RECORD,
    g_axu_t           RECORD                 #程式變數 (舊值)
        axu04         LIKE axu_file.axu04,
        aag02         LIKE aag_file.aag02,
        axu05         LIKE axu_file.axu05
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_argv1           LIKE axu_file.axu00,
    g_argv2           LIKE axu_file.axu01,
    g_argv3           LIKE axu_file.axu09,
    g_argv4           LIKE axu_file.axu10,
    g_argv5           LIKE axu_file.axu12,
    g_argv6           LIKE axu_file.axu03,
    g_argv7           LIKE axu_file.axu13    #FUN-910001 add 
DEFINE p_row,p_col    LIKE type_file.num5    
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03
DEFINE   g_row_count   LIKE type_file.num10
DEFINE   g_curs_index  LIKE type_file.num10
DEFINE   g_aaz641       LIKE aaz_file.aaz641   #FUN-920057
DEFINE   g_axz03        LIKE axz_file.axz03    #FUN-920057
DEFINE   g_dbs_axz03    LIKE type_file.chr21   #FUN-920057
DEFINE   g_plant_axz03  LIKE type_file.chr21   #FUN-A30122
 
MAIN
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   LET g_argv3 =ARG_VAL(3)
   LET g_argv4 =ARG_VAL(4)
   LET g_argv5 =ARG_VAL(5)
   LET g_argv6 =ARG_VAL(6)
   LET g_argv7 =ARG_VAL(7)   #FUN-910001 add
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i0033_w AT p_row,p_col
     WITH FORM "agl/42f/agli0033"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   
   #IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND 
   #        cl_null(g_argv3) AND cl_null(g_argv4) AND 
   #        cl_null(g_argv5)) THEN
   CALL i0033_q()
   #END IF
   CALL i0033_menu()
 
   CLOSE WINDOW i0033_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i0033_cs()
DEFINE l_sql STRING
#
#    IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND 
#            cl_null(g_argv3) AND cl_null(g_argv4) AND 
#            cl_null(g_argv5)) THEN
#       LET g_wc = " axu00 = '",g_argv1,"'",
#                  " AND axu01 = '",g_argv2,"'",
#                  " AND axu09 = '",g_argv3,"'",
#                  " AND axu10 = '",g_argv4,"'",
#                  " AND axu12 = '",g_argv5,"'"
#    ELSE
#       CLEAR FORM                            #清除畫面
#       CALL g_axu.clear()
#       CALL cl_set_head_visible("","YES")
# 
#       CONSTRUCT g_wc ON axu00,axu01,axu03,axu09,axu10,axu12
#          FROM axu01,axu02,s_axu[1].axu03,s_axu[1].axu04,s_axu[1].axu05,s_axu[1].axu06
#               
#       #No.FUN-580031 --start--     HCN
#       BEFORE CONSTRUCT
#          CALL cl_qbe_init()
#       #No.FUN-580031 --end--       HCN
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(axu01) #族群編號
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_axa"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axu01
#                NEXT FIELD axu01
#             WHEN INFIELD(axu02) #公司編號
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_axz"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axu02
#                NEXT FIELD axu02
#             WHEN INFIELD(axu03) #科目
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_axe"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axu03
#                NEXT FIELD axu03
#             WHEN INFIELD(axu06) #幣別
#                CALL cl_init_qry_var()
#                LET g_qryparam.state = "c"
#                LET g_qryparam.form ="q_azi"
#                LET g_qryparam.default1 = g_axu[1].axu06
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO axu06
#                NEXT FIELD axu06
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
    LET l_sql="SELECT UNIQUE axu13,axu00,axu01,axu09,axu10,axu12,axu03",  #FUN-910001 add axu13
              "  FROM axu_file ",
              " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY axu13,axu00,axu01,axu09,axu10,axu12"  #FUN-910001 add axu13
    PREPARE i0033_prepare FROM g_sql      #預備一下
    DECLARE i0033_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i0033_prepare
 
    DROP TABLE i0033_cnttmp
#   LET l_sql=l_sql," INTO TEMP i0033_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP i0033_cnttmp"  #No.TQC-720019
    
#   PREPARE i0033_cnttmp_pre FROM l_sql       #No.TQC-720019
    PREPARE i0033_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
    EXECUTE i0033_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i0033_cnttmp"      
    
    PREPARE i0033_precount FROM g_sql
    DECLARE i0033_count CURSOR FOR i0033_precount
# 
#    IF NOT cl_null(g_argv1) THEN
#       LET g_axu01=g_argv1
#    END IF
#
#    IF NOT cl_null(g_argv2) THEN
#       LET g_axu02=g_argv2
#    END IF
#
   #CALL i0033_show()
END FUNCTION
 
FUNCTION i0033_menu()
 
   WHILE TRUE
      CALL i0033_bp("G")
      CASE g_action_choice
        #WHEN "insert"
        #   IF cl_chk_act_auth() THEN
        #      IF cl_null(g_argv1) THEN
        #         CALL i0033_a()
        #      END IF
        #   END IF
        #WHEN "query"
        #   IF cl_chk_act_auth() THEN
        #      CALL i0033_q()
        #   END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i0033_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0033_b()
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
        #      CALL i0033_out()
        #   END IF
        #WHEN "exporttoexcel"
        #   IF cl_chk_act_auth() THEN
        #      CALL cl_export_to_excel
        #      (ui.Interface.getRootNode(),base.TypeInfo.create(g_axu),'','')
        #   END IF
        #WHEN "related_document"           #相關文件
        # IF cl_chk_act_auth() THEN
        #    IF g_axu01 IS NOT NULL THEN
        #       LET g_doc.column1 = "axu01"
        #       LET g_doc.column2 = "axu02"
        #       LET g_doc.value1 = g_axu01
        #       LET g_doc.value2 = g_axu02
        #       CALL cl_doc()
        #    END IF 
        # END IF
      END CASE
   END WHILE
END FUNCTION
 
#FUNCTION i0033_a()
#   MESSAGE ""
#   CLEAR FORM
#   CALL g_axu.clear()
#   LET g_axu01_t  = NULL
#   LET g_axu02_t  = NULL
#   CALL cl_opmsg('a')
#
#   WHILE TRUE
#      CALL i0033_i("a")                   #輸入單頭
#
#      IF INT_FLAG THEN                   #使用者不玩了
#         LET g_axu01=NULL
#         LET g_axu02=NULL
#         LET INT_FLAG = 0
#         CALL cl_err('',9001,0)
#         EXIT WHILE
#      END IF
#
#      IF g_ss='N' THEN
#         CALL g_axu.clear()
#      ELSE
#         CALL i0033_b_fill('1=1')            #單身
#      END IF
#
#      CALL i0033_b()                      #輸入單身
#
#      LET g_axu01_t = g_axu01
#      LET g_axu02_t = g_axu02
#      EXIT WHILE
#   END WHILE
#
#END FUNCTION
 
#FUNCTION i0033_i(p_cmd)
#DEFINE
#    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改   #No.FUN-680098 VARCHAR(1)
#    l_cnt           LIKE type_file.num10       #No.FUN-680098 INTEGER    
#
#    LET g_ss='Y'
# 
#    LET g_axu01=NULL
#    LET g_axu02=NULL
#    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
#
#    INPUT g_axu01,g_axu02 WITHOUT DEFAULTS
#        FROM axu01,axu02
# 
#       AFTER FIELD axu01
#          IF NOT cl_null(g_axu01) THEN
#             LET g_cnt=0
#             SELECT COUNT(*) INTO g_cnt FROM axa_file
#                                       WHERE axa01=g_axu01
#             IF SQLCA.sqlcode OR (g_cnt=0) THEN
#                CALL cl_err3("sel","axa_file",g_axu01,"",100,"","",1)
#                LET g_axu01=g_axu01_t
#                DISPLAY g_axu01 TO axu01
#                NEXT FIELD CURRENT
#             END IF
#          END IF
#
#       AFTER FIELD axu02
#          IF NOT cl_null(g_axu02) THEN
#             LET g_cnt=0
#             SELECT COUNT(*) INTO g_cnt FROM axz_file
#                                       WHERE axz01=g_axu02
#             IF SQLCA.sqlcode OR (g_cnt=0) THEN
#                CALL cl_err3("sel","axz_file",g_axu02,"",100,"","",1)
#                LET g_axu02=g_axu02_t
#                DISPLAY g_axu02 TO axu02
#                DISPLAY i0033_set_axz02() TO FORMONLY.axz02
#                NEXT FIELD CURRENT
#             END IF
#             DISPLAY i0033_set_axz02() TO FORMONLY.axz02
#          ELSE
#             DISPLAY NULL TO FORMONLY.axz02
#          END IF
#
#       AFTER INPUT
#          IF (NOT cl_null(g_axu01)) AND (NOT cl_null(g_axu02)) THEN
#             LET g_cnt=0
#             SELECT COUNT(*) INTO g_cnt FROM axb_file 
#                                       WHERE axb01=g_axu01
#                                         AND axb04=g_axu02
#             IF SQLCA.sqlcode THEN
#                LET g_cnt=0
#             END IF
#             IF g_cnt=0 THEN
#                CALL cl_err3("sel","axb_file",g_axu01,g_axu02,"agl-094","","",1)
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
#             WHEN INFIELD(axu01) OR INFIELD(axu02)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form  ="q_axb4"
#                CALL cl_create_qry() RETURNING g_axu01,g_axu02
#                DISPLAY g_axu01 TO axu01
#                DISPLAY g_axu02 TO axu02
#                NEXT FIELD axu02
#          END CASE
#
#       ON ACTION CONTROLF                  #欄位說明
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
# 
#    END INPUT
#
#END FUNCTION
 
FUNCTION i0033_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE m_axu.* TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axu.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   LET g_wc = " axu00 = '",g_argv1,"'",
              " AND axu01 = '",g_argv2,"'",
              " AND axu09 = '",g_argv3,"'",
              " AND axu10 = '",g_argv4,"'",
              " AND axu12 = '",g_argv5,"'",
              " AND axu03 = '",g_argv6,"'",
              " AND axu13 = '",g_argv7,"'"   #FUN-910001 add
   CALL i0033_cs()                      #取得查詢條件
   
  #IF INT_FLAG THEN                    #使用者不玩了
  #   LET INT_FLAG = 0
  #   INITIALIZE g_axu01,g_axu02 TO NULL
  #   RETURN
  #END IF
 
   OPEN i0033_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
     #INITIALIZE m_axu.* TO NULL 
     #外部呼叫,新增時
     LET m_axu.axu00 = g_argv1
     LET m_axu.axu01 = g_argv2
     LET m_axu.axu09 = g_argv3
     LET m_axu.axu10 = g_argv4
     LET m_axu.axu12 = g_argv5
     LET m_axu.axu03 = g_argv6
     LET m_axu.axu13 = g_argv7   #FUN-910001 add
     DISPLAY m_axu.axu01 TO FORMONLY.axf02
     DISPLAY m_axu.axu03 TO FORMONLY.axt03
   ELSE
      OPEN i0033_count
      FETCH i0033_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i0033_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i0033_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式   #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10   #絕對的筆數  #No.FUN-680098 integer
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i0033_bcs INTO m_axu.axu13,m_axu.axu00,  #FUN-910001 add axu13
                                              m_axu.axu01,m_axu.axu09,
                                              m_axu.axu10,m_axu.axu12,
                                              m_axu.axu03
       WHEN 'P' FETCH PREVIOUS i0033_bcs INTO m_axu.axu13,m_axu.axu00,  #FUN-910001 add axu13
                                              m_axu.axu01,m_axu.axu09,
                                              m_axu.axu10,m_axu.axu12,
                                              m_axu.axu03
       WHEN 'F' FETCH FIRST    i0033_bcs INTO m_axu.axu13,m_axu.axu00,  #FUN-910001 add axu13
                                              m_axu.axu01,m_axu.axu09,
                                              m_axu.axu10,m_axu.axu12,
                                              m_axu.axu03
       WHEN 'L' FETCH LAST     i0033_bcs INTO m_axu.axu13,m_axu.axu00,  #FUN-910001 add axu13
                                              m_axu.axu01,m_axu.axu09,
                                              m_axu.axu10,m_axu.axu12,
                                              m_axu.axu03
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
            FETCH ABSOLUTE l_abso i0033_bcs INTO m_axu.axu13,m_axu.axu00,  #FUN-910001 add axu13
                                                 m_axu.axu01,m_axu.axu09,
                                                 m_axu.axu10,m_axu.axu12,
                                                 m_axu.axu03
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(m_axu.axu01,SQLCA.sqlcode,0)
      #INITIALIZE m_axu.* TO NULL
      #外部呼叫,新增時
      LET m_axu.axu00 = g_argv1
      LET m_axu.axu01 = g_argv2
      LET m_axu.axu09 = g_argv3
      LET m_axu.axu10 = g_argv4
      LET m_axu.axu12 = g_argv5
      LET m_axu.axu03 = g_argv6
      LET m_axu.axu13 = g_argv7   #FUN-910001 add
      DISPLAY m_axu.axu01 TO FORMONLY.axf02
      DISPLAY m_axu.axu03 TO FORMONLY.axt03
   ELSE
      CALL i0033_show()
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
FUNCTION i0033_show() 
   DISPLAY m_axu.axu01 TO FORMONLY.axf02
   DISPLAY m_axu.axu03 TO FORMONLY.axt03
   CALL i0033_b_fill(g_wc)                      #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i0033_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680098 smallint
   l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680098   smallint
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680098    VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,          #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5,          #可刪除否          #No.FUN-680098 SMALLINT
   l_cnt           LIKE type_file.num10          #No.FUN-680098  INTEGER
DEFINE l_axa09     LIKE axa_file.axa09           #FUN-950051 add
 
   LET g_action_choice = ""
 
   IF cl_null(m_axu.axu01) OR cl_null(m_axu.axu00) OR 
      cl_null(m_axu.axu09) OR cl_null(m_axu.axu10) OR 
      cl_null(m_axu.axu12) OR cl_null(m_axu.axu03) OR
      cl_null(m_axu.axu13) THEN   #FUN-910001 add
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
   CALL s_aaz641_dbs(g_argv7,g_argv3) RETURNING g_plant_axz03               #FUN-A30122 add 
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                        #FUN-A30122 add
 
   LET g_forupd_sql = "SELECT axu04,'',axu05 FROM axu_file",
                      " WHERE axu00 = ? AND axu01= ?",
                      "   AND axu03 = ? AND axu04= ?",
                      "   AND axu09 = ? AND axu10= ?",
                      "   AND axu12 = ? AND axu13= ? FOR UPDATE "  #FUN-910001 add axu13
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i0033_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_axu.clear() END IF
 
   INPUT ARRAY g_axu WITHOUT DEFAULTS FROM s_axu.*
 
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
            LET g_axu_t.* = g_axu[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i0033_bcl USING m_axu.axu00,m_axu.axu01,m_axu.axu03,
                                 g_axu[l_ac].axu04,m_axu.axu09,
                                 m_axu.axu10,m_axu.axu12,m_axu.axu13   #FUN-910001 add axu13
            IF STATUS THEN
               CALL cl_err("OPEN i0033_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i0033_bcl INTO g_axu[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i0033_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i0033_set_axu04(g_axu[l_ac].axu04) RETURNING g_axu[l_ac].aag02
                  LET g_axu_t.*=g_axu[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axu[l_ac].* TO NULL            #900423
         LET g_axu_t.* = g_axu[l_ac].*               #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD axu04
 
      AFTER FIELD axu04                         # check data 是否重複
         IF NOT cl_null(g_axu[l_ac].axu04) THEN
            IF g_axu[l_ac].axu04 != g_axu_t.axu04 OR g_axu_t.axu04 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM axu_file
                     WHERE axu00=m_axu.axu00
                       AND axu01=m_axu.axu01
                       AND axu03=m_axu.axu03
                       AND axu04=g_axu[l_ac].axu04
                       AND axu09=m_axu.axu09
                       AND axu10=m_axu.axu10
                       AND axu12=m_axu.axu12
                       AND axu13=m_axu.axu13   #FUN-910001 add
               IF (SQLCA.sqlcode) OR (l_cnt>0) THEN
                  CALL cl_err3("sel","axu_file",g_axu[l_ac].axu04,"","-239","","",1)
                  LET g_axu[l_ac].axu04=g_axu_t.axu04
                  LET g_axu[l_ac].aag02=g_axu_t.aag02
                  DISPLAY BY NAME g_axu[l_ac].axu04,g_axu[l_ac].aag02
                  NEXT FIELD CURRENT
               END IF
#--FUN-920057 mark---
#               LET l_cnt=0
#               SELECT COUNT(*) INTO l_cnt FROM axe_file
#                    #WHERE axe00=m_axu.axu00         #FUN-770069 mark
#                    #  AND axe01=m_axu.axu09         #FUN-770069 mark
#                     WHERE axe00=m_axu.axu12         #FUN-770069 #對沖公司
#                       AND axe01=m_axu.axu10         #FUN-770069 #對沖公司帳別
#                       AND axe13=m_axu.axu13         #FUN-910001 add
#                      #AND axe04=g_axu[l_ac].axu04   #TQC-770095 mark
#                       AND axe06=g_axu[l_ac].axu04   #TQC-770095
#               IF (SQLCA.sqlcode) OR (l_cnt=0) THEN
#                  CALL cl_err3("sel","axe_file",g_axu[l_ac].axu04,"",100,"","",1)   #FUN-770069 mod
#                  LET g_axu[l_ac].axu04=g_axu_t.axu04
#                  LET g_axu[l_ac].aag02=g_axu_t.aag02
#                  DISPLAY BY NAME g_axu[l_ac].axu04,g_axu[l_ac].aag02
#                  NEXT FIELD CURRENT
#               END IF
#--FUN-920057 mark---
               CALL i0033_set_axu04(g_axu[l_ac].axu04)
                          RETURNING g_axu[l_ac].aag02
               DISPLAY BY NAME g_axu[l_ac].aag02
#--FUN-920057 start--
               IF cl_null(g_axu[l_ac].aag02) THEN
                   CALL cl_err('','abg-010',0)
                   #FUN-B20004--begin
                    CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_axu[l_ac].axu04,'23',g_aaz641) #TQC-9C0099
                         RETURNING g_axu[l_ac].axu04
                   #FUN-B20004--end                   
                   NEXT FIELD axu04
               END IF
#--FUN-920057 end--- 
            END IF
         ELSE
            LET g_axu[l_ac].aag02 = null
            DISPLAY BY NAME g_axu[l_ac].aag02
         END IF
 
      AFTER INSERT
         IF INT_FLAG OR cl_null(g_axu[l_ac].axu04) THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_axu[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_axu[l_ac].* TO s_axu.*
           #CALL g_axu.deleteElement(g_rec_b+1)
            ROLLBACK WORK
           #EXIT INPUT
            CANCEL INSERT
         END IF
         INSERT INTO axu_file(axu00,axu01,axu03,axu04,axu05,axu09,axu10,axu12,axu13)  #FUN-910001 add axu13
              VALUES(m_axu.axu00,m_axu.axu01,m_axu.axu03,
                     g_axu[l_ac].axu04,g_axu[l_ac].axu05,
                     m_axu.axu09,m_axu.axu10,m_axu.axu12,m_axu.axu13)  #FUN-910001 add axu13
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axu_file",g_axu[l_ac].axu04,'',SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_axu_t.axu04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM axu_file 
                  WHERE axu00=m_axu.axu00
                    AND axu01=m_axu.axu01
                    AND axu03=m_axu.axu03
                    AND axu04=g_axu_t.axu04
                    AND axu09=m_axu.axu09
                    AND axu10=m_axu.axu10
                    AND axu12=m_axu.axu12
                    AND axu13=m_axu.axu13   #FUN-910001 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axu_file",g_axu[l_ac].axu04,"",SQLCA.sqlcode,"","",1)
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
            LET g_axu[l_ac].* = g_axu_t.*
            CLOSE i0033_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axu[l_ac].axu04,-263,1)
            LET g_axu[l_ac].* = g_axu_t.*
         ELSE
            UPDATE axu_file SET axu04 = g_axu[l_ac].axu04,
                                axu05 = g_axu[l_ac].axu05
                          WHERE axu00=m_axu.axu00
                            AND axu01=m_axu.axu01
                            AND axu03=m_axu.axu03
                            AND axu04=g_axu_t.axu04
                            AND axu09=m_axu.axu09
                            AND axu10=m_axu.axu10
                            AND axu12=m_axu.axu12
                            AND axu13=m_axu.axu13   #FUN-910001 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axu_file",g_axu[l_ac].axu04,"",SQLCA.sqlcode,"","",1)
               LET g_axu[l_ac].* = g_axu_t.*
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
               LET g_axu[l_ac].* = g_axu_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_axu.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i0033_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i0033_bcl
         COMMIT WORK
         #CKP2
         #CALL g_axu.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axu04)
#--FUN-920057 start---
              #CALL q_m_aag2(FALSE,TRUE,g_dbs_axz03,g_axu[l_ac].axu04,'23',g_aaz641) #TQC-9C0099
               CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axu[l_ac].axu04,'23',g_aaz641) #TQC-9C0099
                    RETURNING g_axu[l_ac].axu04
               DISPLAY BY NAME g_axu[l_ac].axu04
               NEXT FIELD axu04
#--FUN-920057 end---
#--FUN-920057 mark--
#               #開窗是開對沖帳別+對沖公司的合併後科目
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_axe1"   #FUN-760053 mod q_axe->q_axe1
#               LET g_qryparam.default1 = g_axu[l_ac].axu04
#               LET g_qryparam.arg1 = m_axu.axu12    #m_axu.axu00   #FUN-780068 mod 09/21
#               LET g_qryparam.arg2 = m_axu.axu10    #m_axu.axu09   #FUN-780068 mod 09/21
#               LET g_qryparam.arg3 = m_axu.axu13    #FUN-910001 add
#               LET g_qryparam.arg4 = g_aaz.aaz641   #FUN-910001 add
#               CALL cl_create_qry() RETURNING g_axu[l_ac].axu04
#               DISPLAY BY NAME g_axu[l_ac].axu04
#               NEXT FIELD axu04
#--FUN-920057 mark---
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axu02) AND l_ac > 1 THEN
            LET g_axu[l_ac].* = g_axu[l_ac-1].*
            LET g_axu[l_ac].axu04=null
            NEXT FIELD axu04
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
 
   CLOSE i0033_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i0033_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
 
   LET g_sql = "SELECT axu04,'',axu05",
               "  FROM axu_file ",
               " WHERE axu00 = '",m_axu.axu00,"'",
               "   AND axu01 = '",m_axu.axu01,"'",
               "   AND axu09 = '",m_axu.axu09,"'",
               "   AND axu10 = '",m_axu.axu10,"'",
               "   AND axu12 = '",m_axu.axu12,"'",
               "   AND axu03 = '",m_axu.axu03,"'",
               "   AND axu13 = '",m_axu.axu13,"'",   #FUN-910001 add
               "   AND ",p_wc CLIPPED ,
               " ORDER BY axu03"
   PREPARE i0033_prepare2 FROM g_sql       #預備一下
   DECLARE axu_cs CURSOR FOR i0033_prepare2
 
   CALL g_axu.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH axu_cs INTO g_axu[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i0033_set_axu04(g_axu[g_cnt].axu04) RETURNING g_axu[g_cnt].aag02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_axu.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i0033_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axu TO s_axu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i0033_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i0033_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i0033_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i0033_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i0033_fetch('L')
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
 
FUNCTION i0033_set_axu04(p_axu04)
DEFINE p_axu04 LIKE axu_file.axu04,
       l_aag02 LIKE aag_file.aag02
DEFINE l_axa09 LIKE axa_file.axa09   #FUN-950051 add

#--FUN-920057 mark--- 
#   SELECT aag02 INTO l_aag02 FROM aag_file
#   #WHERE aag00=m_axu.axu12   #FUN-760053 mark
#   #WHERE aag00=g_aaz.aaz64   #FUN-760053 #用總帳預設帳別(aaz64)抓科目  #FUN-910001 mark
#    WHERE aag00=g_aaz.aaz641  #FUN-760053 #用總帳預設帳別(aaz64)抓科目  #FUN-910001
#      AND aag01=p_axu04
#--FUN-920057 mark

#FUN-A30122 ----------------------mark start-----------------------------
#  #FUN-950051--mod--str--
#  SELECT axa09 INTO l_axa09 FROM axa_file
#   WHERE axa01 = g_argv7 
#     AND axa02 = g_argv3
#  IF l_axa09 = 'Y' THEN   
#  #FUN-950051--mod--end
#     #--FUN-920057 start--
#     ##來源公司編號在agli009中所設定工廠/DB
#     SELECT axz03 INTO g_axz03 FROM axz_file
#      WHERE axz01 = g_argv3      
#     LET g_plant_new = g_axz03      #營運中心
#     CALL s_getdbs()
#     LET g_dbs_axz03 = g_dbs_new    #上層公司所屬DB
#     LET g_aaz641 = g_argv5         #對衝公司合并帳別   #FUN-950051 add
#     LET g_sql = "SELECT aag02",
#                #"  FROM ",g_dbs_axz03,"aag_file",   #FUN-A50102 
#                 "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
#                 " WHERE aag00 = '",g_argv1,"'", 
#                 "   AND aag01 = '",p_axu04,"'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
#     PREPARE i0033_pre_02 FROM g_sql
#     DECLARE i0033_cur_02 CURSOR FOR i0033_pre_02
#     OPEN i0033_cur_02
#     FETCH i0033_cur_02 INTO l_aag02
#     #--FUN-920057 end---
#  #FUN-950051--mod--str--
#  ELSE
#     LET g_plant_new = g_plant   #TQC-9C0099
#     LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)  
#     SELECT aag02 INTO l_aag02 FROM aag_file 
#      WHERE aag00 = g_argv1
#        AND aag01 = p_axu04 
#     LET g_aaz641 = g_argv5
#  END IF 
#  #FUN-950051--mod--end
#FUN-A30122 ------------------------mark end------------------------------------------------

   SELECT aag02 INTO l_aag02 FROM aag_file     #MOD-A80162 add
    WHERE aag00=g_aaz.aaz641                   #MOD-A80162 add
      AND aag01=p_axu04                        #MOD-A80162 add
   IF SQLCA.sqlcode THEN
      LET l_aag02=NULL
   END IF
   RETURN l_aag02
END FUNCTION
 
FUNCTION i0033_r()
   IF cl_null(m_axu.axu01) OR cl_null(m_axu.axu00) OR 
      cl_null(m_axu.axu09) OR cl_null(m_axu.axu10) OR 
      cl_null(m_axu.axu12) OR cl_null(m_axu.axu03) OR
      cl_null(m_axu.axu13) THEN   #FUN-910001 add
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   DELETE FROM axu_file
               WHERE axu00=m_axu.axu00
                 AND axu01=m_axu.axu01
                 AND axu09=m_axu.axu09
                 AND axu10=m_axu.axu10
                 AND axu12=m_axu.axu12
                 AND axu03=m_axu.axu03
                 AND axu13=m_axu.axu13   #FUN-910001 add
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","axu_file",m_axu.axu01,m_axu.axu03,SQLCA.sqlcode,"","del axu",1)
      RETURN      
   END IF   
 
   INITIALIZE m_axu.* TO NULL
   MESSAGE ""
   DROP TABLE i0033_cnttmp
   PREPARE i0033_precount_x2 FROM g_sql_tmp
   EXECUTE i0033_precount_x2
   OPEN i0033_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i0033_bcs
      CLOSE i0033_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   FETCH i0033_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i0033_bcs
      CLOSE i0033_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i0033_bcs
      CALL i0033_fetch('F') 
   ELSE
      DISPLAY m_axu.axu01 TO FORMONLY.axf02
      DISPLAY m_axu.axu03 TO FORMONLY.axt03
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_axu.clear()
      CALL i0033_menu()
   END IF                      
END FUNCTION
 
#FUNCTION i0033_out()
#    DEFINE
#        sr              RECORD LIKE axu_file.*,
#        l_i             LIKE type_file.num5,    #No.FUN-680098 SMALLINT
#        l_name          LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680098 VARCHAR(20)
#        l_za05          LIKE za_file.za05       # #No.FUN-680098 VARCHAR(40)
#   
#    IF g_wc IS NULL THEN 
#       IF (NOT cl_null(g_axu01)) AND (NOT cl_null(g_axu02)) THEN
#          LET g_wc=" axu01=",g_axu01,
#                   " AND axu02=",g_axu02
#       ELSE
#          CALL cl_err('',-400,0)
#          RETURN 
#       END IF
#    END IF
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM axu_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED,
#              " ORDER BY axu01,axu02,axu03"
#    PREPARE i0033_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i0033_co                         # SCROLL CURSOR
#         CURSOR FOR i0033_p1
#
#    CALL cl_outnam('agli0033') RETURNING l_name
#    START REPORT i0033_rep TO l_name
#
#    FOREACH i0033_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i0033_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT i0033_rep
#
#    CLOSE i0033_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
 
#REPORT i0033_rep(sr)
#    DEFINE
#        l_trailer_sw   LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1),
#        sr RECORD LIKE axu_file.*,
#        l_axz02   LIKE axz_file.axz02,
#        l_aag02   LIKE aag_file.aag02
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.axu01,sr.axu02,sr.axu03
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
#            SELECT axz02 INTO l_axz02 FROM axz_file WHERE axz01=sr.axu02
#            IF SQLCA.sqlcode THEN
#               LET l_axz02 =NULL
#            END IF
#            SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.axu03
#            IF SQLCA.sqlcode THEN
#               LET l_aag02 =NULL
#            END IF
#            SELECT azi04 INTO t_azi04 FROM azi_file
#                                     WHERE azi01=sr.axu04
#            PRINT COLUMN g_c[31],sr.axu01,
#                  COLUMN g_c[32],sr.axu02,                  
#                  COLUMN g_c[33],l_axz02,
#                  COLUMN g_c[34],sr.axu03,
#                  COLUMN g_c[35],l_aag02,
#                  COLUMN g_c[36],sr.axu04,
#                  COLUMN g_c[37],cl_numfor(sr.axu05,37,t_azi04),
#                  COLUMN g_c[38],sr.axu06
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
 
FUNCTION i0033_set_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("b",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i0033_set_no_entry(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1     #No.FUN-680098  VARCHAR(01)
 
   IF INFIELD(a) OR ( NOT g_before_input_done ) THEN
      IF a != '1' THEN
         CALL cl_set_comp_entry("b",FALSE)
      END IF
   END IF
END FUNCTION
 
 

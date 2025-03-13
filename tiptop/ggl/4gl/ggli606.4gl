# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: ggli606.4gl (copy from agli006)
# Descriptions...: 股東權益變動事項維護作業(合併)
# Date & Author..: 07/08/10 By kim (FUN-780013)
# Modify.........: No.FUN-780068 07/09/17 By Sarah 增加"異動明細產生"ACTION
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-920123 10/08/16 By vealxu 將使用asgacti的地方mark
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B60144 11/06/29 By lixiang 呼叫sggli606.4gl
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0037

#No.FUN-B60144--mark--beatk 
##模組變數(Module Variables)
#DEFINE
#   g_atr11           LIKE atr_file.atr11,
#   g_atr11_t         LIKE atr_file.atr11,
#   g_atr12           LIKE atr_file.atr12,
#   g_atr12_t         LIKE atr_file.atr12,   
#   g_atr13           LIKE atr_file.atr13,
#   g_atr13_t         LIKE atr_file.atr13,   
#   g_atr01           LIKE atr_file.atr01,
#   g_atr01_t         LIKE atr_file.atr01,
#   g_atr02           LIKE atr_file.atr02,
#   g_atr02_t         LIKE atr_file.atr02,
#   g_atr             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
#       atr14         LIKE atr_file.atr14,
#       ats02         LIKE ats_file.ats02,
#       atr04         LIKE atr_file.atr04,
#       atr15         LIKE atr_file.atr15,
#       atn02         LIKE atn_file.atn02
#                     END RECORD,
#   g_atr_t           RECORD                 #程式變數 (舊值)
#       atr14         LIKE atr_file.atr14,
#       ats02         LIKE ats_file.ats02,
#       atr04         LIKE atr_file.atr04,
#       atr15         LIKE atr_file.atr15,
#       atn02         LIKE atn_file.atn02
#                     END RECORD,
#   a                 LIKE type_file.chr1,
#   g_wc,g_sql        STRING,
#   g_show            LIKE type_file.chr1,   
#   g_rec_b           LIKE type_file.num5,   #單身筆數
#   g_flag            LIKE type_file.chr1,   
#   g_ss              LIKE type_file.chr1,   
#   l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT
#   g_argv1           LIKE atr_file.atr11,
#   g_argv2           LIKE atr_file.atr12,
#   g_argv3           LIKE atr_file.atr13,
#   g_argv4           LIKE atr_file.atr01,
#   g_argv5           LIKE atr_file.atr02 
#No.FUN-B60144--mark--end--

DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098  SMALLINT

#No.FUN-B60144--mark--
##主程式開始
#DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
#DEFINE   g_sql_tmp    STRING   #No.TQC-720019
#DEFINE   g_before_input_done   LIKE type_file.num5
#DEFINE   g_cnt                 LIKE type_file.num10
#DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
#DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680098  INTEGER
#DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680098  INTEGER
#No.FUN-B60144--mark--

MAIN
#       l_time   LIKE type_file.chr8          #No.FUN-6A0073
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
 #No.FUN-B60144--mark--
 # LET g_argv1 =ARG_VAL(1)
 # LET g_argv2 =ARG_VAL(2)
 # LET g_argv3 =ARG_VAL(3)
 # LET g_argv4 =ARG_VAL(4)
 # LET g_argv5 =ARG_VAL(5)
 
 # LET p_row = 3 LET p_col = 16
 
 # OPEN WINDOW i007_w AT p_row,p_col
 #   WITH FORM "ggl/42f/ggli606"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
 # CALL cl_ui_init()
 
 # IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
 #    (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
 #    (NOT cl_null(g_argv5)) THEN
 #    CALL i007_q()
 # END IF   
 # CALL i007_menu()
 
 # CLOSE WINDOW i007_w                 #結束畫面

   CALL i007('1')       #No.FUN-B60144 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#No.FUN-B60144--mark-- 
##QBE 查詢資料
#FUNCTION i007_cs()
#DEFINE l_sql STRING
#
#  IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
#     (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
#     (NOT cl_null(g_argv5)) THEN
#      LET g_wc = "     atr11 = '",g_argv1,"'",
#                 " AND atr12 = '",g_argv2,"'",
#                 " AND atr13 = '",g_argv3,"'",
#                 " AND atr01 = '",g_argv4,"'",
#                 " AND atr02 = '",g_argv5,"'"
#   ELSE
#      CLEAR FORM                            #清除畫面
#      CALL g_atr.clear()
#      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
#      INITIALIZE g_atr11 TO NULL
#      INITIALIZE g_atr12 TO NULL
#      INITIALIZE g_atr13 TO NULL
#      INITIALIZE g_atr01 TO NULL
#      INITIALIZE g_atr02 TO NULL
#      CONSTRUCT g_wc ON atr11,atr12,atr13,atr01,atr02,
#                        atr14,atr04,atr15
#         FROM atr11,atr12,atr13,atr01,atr02,s_atr[1].atr14,
#              s_atr[1].atr04,s_atr[1].atr15
#          
#
#      #No.FUN-580031 --start--     HCN
#      BEFORE CONSTRUCT
#         CALL cl_qbe_init()
#      #No.FUN-580031 --end--       HCN
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(atr11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_asg"
#               LET g_qryparam.state ="c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO atr11
#               NEXT FIELD atr11
#            WHEN INFIELD(atr14)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form  = "q_ats"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_atr[1].atr14
#               NEXT FIELD atr14
#            WHEN INFIELD(atr15)
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form  = "q_atn"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO s_atr[1].atr15
#               NEXT FIELD atr15
#         END CASE
#         
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
#      
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#      
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#      
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
#
#      #No.FUN-580031 --start--     HCN
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#         
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#      #No.FUN-580031 --end--       HCN
#      
#      END CONSTRUCT
#      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('atruser', 'atrgrup') #FUN-980030
#
#      IF INT_FLAG THEN
#         RETURN
#      END IF
#   END IF
#
#   IF cl_null(g_wc) THEN
#      LET g_wc="1=1"
#   END IF
#   
#   LET l_sql="SELECT DISTINCT atr11,atr12,atr13,atr01,atr02 FROM atr_file ",
#              " WHERE ", g_wc CLIPPED
#   LET g_sql= l_sql," ORDER BY atr11,atr12,atr13,atr01,atr02"
#   PREPARE i007_prepare FROM g_sql      #預備一下
#   DECLARE i007_bcs                     #宣告成可捲動的
#       SCROLL CURSOR WITH HOLD FOR i007_prepare
#
#   DROP TABLE i007_cnttmp
#   LET l_sql=l_sql," INTO TEMP i007_cnttmp"      #No.TQC-720019
#   LET g_sql_tmp=l_sql," INTO TEMP i007_cnttmp"  #No.TQC-720019
#   
#   PREPARE i007_cnttmp_pre FROM l_sql       #No.TQC-720019
#   PREPARE i007_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
#   EXECUTE i007_cnttmp_pre    
#   
#   LET g_sql="SELECT COUNT(*) FROM i007_cnttmp"
#
#   PREPARE i007_precount FROM g_sql
#   DECLARE i007_count CURSOR FOR i007_precount
#
#   IF NOT cl_null(g_argv1) THEN
#      LET g_atr11=g_argv1
#   END IF
#
#   IF NOT cl_null(g_argv2) THEN
#      LET g_atr12=g_argv2
#   END IF
#
#   IF NOT cl_null(g_argv3) THEN
#      LET g_atr13=g_argv3
#   END IF
#
#   IF NOT cl_null(g_argv4) THEN
#      LET g_atr01=g_argv4
#   END IF
#
#   IF NOT cl_null(g_argv5) THEN
#      LET g_atr02=g_argv5
#   END IF
#   CALL i007_show()
#
#END FUNCTION
#
#FUNCTION i007_menu()
#
#  WHILE TRUE
#     CALL i007_bp("G")
#     CASE g_action_choice
#        WHEN "insert"
#           IF cl_chk_act_auth() THEN
#              CALL i007_a()
#           END IF
#        WHEN "query"
#           IF cl_chk_act_auth() THEN
#              CALL i007_q()
#           END IF
#          WHEN "delete" 
#             IF cl_chk_act_auth() THEN
#                CALL i007_r()
#             END IF
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i007_copy()
#           END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL i007_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#       #str FUN-780068 add 10/19
#        WHEN "generate"   #異動明細產生
#           IF cl_chk_act_auth() THEN
#              CALL i007_g()
#           END IF
#       #end FUN-780068 add 10/19
#        WHEN "help"
#           CALL cl_show_help()
#        WHEN "exit"
#           EXIT WHILE
#        WHEN "controlg"
#           CALL cl_cmdask()
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL i007_out()
#           END IF
#        WHEN "exporttoexcel"
#           IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel
#              (ui.Interface.getRootNode(),
#               base.TypeInfo.create(g_atr),'','')
#           END IF
#        WHEN "related_document"           #相關文件
#         IF cl_chk_act_auth() THEN
#            IF g_atr11 IS NOT NULL THEN
#               LET g_doc.column1 = "atr11"
#               LET g_doc.column2 = "atr12"
#               LET g_doc.column3 = "atr13"
#               LET g_doc.value1 = g_atr11
#               LET g_doc.value2 = g_atr12
#               LET g_doc.value3 = g_atr13
#               CALL cl_doc()
#            END IF 
#         END IF
#     END CASE
#  END WHILE
#END FUNCTION
#
#FUNCTION i007_a()
#  MESSAGE ""
#  CLEAR FORM
#  CALL g_atr.clear()
#  LET g_atr11_t  = NULL
#  LET g_atr12_t  = NULL
#  LET g_atr13_t  = NULL
#  LET g_atr01_t  = NULL
#  LET g_atr02_t  = NULL
#  CALL cl_opmsg('a')
#
#  WHILE TRUE
#     CALL i007_i("a")                   #輸入單頭
#
#     IF INT_FLAG THEN                   #使用者不玩了
#        LET g_atr11=NULL
#        LET g_atr12=NULL
#        LET g_atr13=NULL
#        LET g_atr01=NULL
#        LET g_atr02=NULL
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        EXIT WHILE
#     END IF
#
#     IF g_ss='N' THEN
#        CALL g_atr.clear()
#     ELSE
#        CALL i007_b_fill('1=1')            #單身
#     END IF
#
#     CALL i007_b()                      #輸入單身
#
#     LET g_atr11_t = g_atr11
#     LET g_atr12_t = g_atr12
#     LET g_atr13_t = g_atr13
#     LET g_atr01_t = g_atr01
#     LET g_atr02_t = g_atr02
#     EXIT WHILE
#  END WHILE
#
#END FUNCTION
# 
#FUNCTION i007_i(p_cmd)
#DEFINE
#   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
#   l_cnt           LIKE type_file.num10,
#   li_result       LIKE type_file.num5
#
#   LET g_ss='Y'
#
#   CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
#
#   INPUT g_atr11,g_atr12,g_atr13,g_atr01,g_atr02 WITHOUT DEFAULTS
#       FROM atr11,atr12,atr13,atr01,atr02
#
#      AFTER FIELD atr11
#         CALL i007_chk_atr11(g_atr11) 
#              RETURNING li_result,g_atr12,g_atr13
#         DISPLAY i007_set_asg02(g_atr11) TO FORMONLY.asg02
#         DISPLAY g_atr12 TO atr12
#         DISPLAY g_atr13 TO atr13
#         IF NOT li_result THEN
#            NEXT FIELD CURRENT
#         END IF
#      
#      AFTER FIELD atr02
#         IF (NOT cl_null(g_atr11)) OR (NOT cl_null(g_atr12)) OR
#            (NOT cl_null(g_atr13)) OR (NOT cl_null(g_atr01)) OR
#            (NOT cl_null(g_atr02)) THEN
#            LET l_cnt=0             
#            SELECT COUNT(*) INTO l_cnt FROM atr_file
#                                      WHERE atr11=g_atr11
#                                        AND atr12=g_atr12
#                                        AND atr13=g_atr13
#                                        AND atr01=g_atr01
#                                        AND atr02=g_atr02
#           IF l_cnt>0 THEN
#              CALL cl_err('','-239',1)
#              NEXT FIELD atr11
#           END IF
#         END IF
#
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(atr11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_asg"
#               CALL cl_create_qry() RETURNING g_atr11
#               DISPLAY g_atr11 TO atr11
#               NEXT FIELD atr11
#         END CASE
#      ON ACTION CONTROLG
#        CALL cl_cmdask()
#
#      ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#
#      ON ACTION CONTROLF                  #欄位說明
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#           RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#   END INPUT
#
#END FUNCTION
#
#FUNCTION i007_q()
#  LET g_row_count = 0
#  LET g_curs_index = 0
#  CALL cl_navigator_setting( g_curs_index, g_row_count )
#  INITIALIZE g_atr11,g_atr12,g_atr13,g_atr01,g_atr02 TO NULL
#  MESSAGE ""
#  CALL cl_opmsg('q')
#  CLEAR FORM
#  CALL g_atr.clear()
#  DISPLAY '' TO FORMONLY.cnt
#
#  CALL i007_cs()                      #取得查詢條件
#
#  IF INT_FLAG THEN                    #使用者不玩了
#     LET INT_FLAG = 0
#     INITIALIZE g_atr11,g_atr12,g_atr13,g_atr01,g_atr02 TO NULL
#     RETURN
#  END IF
#
#  OPEN i007_bcs                       #從DB產生合乎條件TEMP(0-30秒)
#  IF SQLCA.sqlcode THEN               #有問題
#     CALL cl_err('',SQLCA.sqlcode,0)
#     INITIALIZE g_atr11,g_atr12,g_atr13,g_atr01,g_atr02 TO NULL
#  ELSE
#     OPEN i007_count
#     FETCH i007_count INTO g_row_count
#     DISPLAY g_row_count TO FORMONLY.cnt
#     CALL i007_fetch('F')            #讀出TEMP第一筆並顯示
#  END IF
#END FUNCTION
#
##處理資料的讀取
#FUNCTION i007_fetch(p_flag)
#DEFINE
#  p_flag          LIKE type_file.chr1,   #處理方式
#  l_abso          LIKE type_file.num10   #絕對的筆數
#
#  MESSAGE ""
#  CASE p_flag
#      WHEN 'N' FETCH NEXT     i007_bcs INTO g_atr11,g_atr12,
#                                            g_atr13,g_atr01,g_atr02
#      WHEN 'P' FETCH PREVIOUS i007_bcs INTO g_atr11,g_atr12,
#                                            g_atr13,g_atr01,g_atr02
#      WHEN 'F' FETCH FIRST    i007_bcs INTO g_atr11,g_atr12,
#                                            g_atr13,g_atr01,g_atr02
#      WHEN 'L' FETCH LAST     i007_bcs INTO g_atr11,g_atr12,
#                                            g_atr13,g_atr01,g_atr02
#      WHEN '/'
#           CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#           LET INT_FLAG = 0  ######add for prompt bug
#           PROMPT g_msg CLIPPED,': ' FOR l_abso
#              ON IDLE g_idle_seconds
#                 CALL cl_on_idle()
#                  CONTINUE PROMPT
#             
#              ON ACTION about         #MOD-4C0121
#                 CALL cl_about()      #MOD-4C0121
#             
#              ON ACTION help          #MOD-4C0121
#                 CALL cl_show_help()  #MOD-4C0121
#             
#              ON ACTION controlg      #MOD-4C0121
#                 CALL cl_cmdask()     #MOD-4C0121
#             
#           END PROMPT
#           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
#           FETCH ABSOLUTE l_abso i007_bcs INTO g_atr11,g_atr12,
#                                               g_atr13,g_atr01,g_atr02
#  END CASE
#
#  IF SQLCA.sqlcode THEN                  #有麻煩
#     CALL cl_err(g_atr11,SQLCA.sqlcode,0)
#     INITIALIZE g_atr11 TO NULL
#     INITIALIZE g_atr12 TO NULL
#     INITIALIZE g_atr13 TO NULL
#     INITIALIZE g_atr01 TO NULL
#     INITIALIZE g_atr02 TO NULL
#  ELSE
#     CALL i007_show()
#     CASE p_flag
#        WHEN 'F' LET g_curs_index = 1
#        WHEN 'P' LET g_curs_index = g_curs_index - 1
#        WHEN 'N' LET g_curs_index = g_curs_index + 1
#        WHEN 'L' LET g_curs_index = g_row_count
#        WHEN '/' LET g_curs_index = l_abso
#     END CASE
#
#     CALL cl_navigator_setting( g_curs_index, g_row_count )
#  END IF
#
#END FUNCTION
#
##將資料顯示在畫面上
#FUNCTION i007_show()
#
#  DISPLAY g_atr11 TO atr11
#  DISPLAY g_atr12 TO atr12
#  DISPLAY g_atr13 TO atr13
#  DISPLAY g_atr01 TO atr01
#  DISPLAY g_atr02 TO atr02
#  DISPLAY i007_set_asg02(g_atr11) TO FORMONLY.asg02
#
#  CALL i007_b_fill(g_wc)                      #單身
#
#  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#END FUNCTION
#
##單身
#FUNCTION i007_b()
#DEFINE
#  l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT
#  l_n             LIKE type_file.num5,          #檢查重複用       
#  l_lock_sw       LIKE type_file.chr1,          #單身鎖住否       
#  p_cmd           LIKE type_file.chr1,          #處理狀態         
#  l_allow_insert  LIKE type_file.num5,          #可新增否         
#  l_allow_delete  LIKE type_file.num5,          #可刪除否         
#  l_cnt           LIKE type_file.num10          #No.FUN-680098
#
#  LET g_action_choice = ""
#
#  IF cl_null(g_atr11) OR cl_null(g_atr12) OR
#     cl_null(g_atr13) OR cl_null(g_atr01) OR
#     cl_null(g_atr02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#
#  CALL cl_opmsg('b')
#
#  LET g_forupd_sql = "SELECT atr14,'',atr04,atr15,'' FROM atr_file",
#                     "  WHERE atr11 = ? AND atr12= ? AND atr13= ? ",
#                     "   AND atr01 = ? AND atr02= ? AND atr14= ? ",
#                     "   AND atr15 = ? FOR UPDATE "
#                     
#  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#  DECLARE i007_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#  LET l_allow_insert = cl_detail_input_auth("insert")
#  LET l_allow_delete = cl_detail_input_auth("delete")
#
#  IF g_rec_b=0 THEN CALL g_atr.clear() END IF
#
#  INPUT ARRAY g_atr WITHOUT DEFAULTS FROM s_atr.*
#
#     ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#               INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#               APPEND ROW=l_allow_insert)
#
#     BEFORE INPUT
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(l_ac)
#        END IF
#
#     BEFORE ROW
#        LET p_cmd = ''
#        LET l_ac = ARR_CURR()
#        LET l_lock_sw = 'N'            #DEFAULT
#        LET l_n  = ARR_COUNT()
#        IF g_rec_b >= l_ac THEN
#           LET p_cmd='u'
#           LET g_atr_t.* = g_atr[l_ac].*  #BACKUP
#           BEGIN WORK
#           OPEN i007_bcl USING g_atr11,g_atr12,g_atr13,g_atr01,g_atr02,
#                               g_atr[l_ac].atr14,g_atr[l_ac].atr15
#           IF STATUS THEN
#              CALL cl_err("OPEN i007_bcl:", STATUS, 1)
#              LET l_lock_sw = "Y"
#           ELSE
#              FETCH i007_bcl INTO g_atr[l_ac].*
#              IF STATUS THEN
#                 CALL cl_err("OPEN i007_bcl:", STATUS, 1)
#                 LET l_lock_sw = "Y"
#              ELSE
#                 LET g_atr[l_ac].ats02=i007_set_ats02(g_atr[l_ac].atr14)
#                 LET g_atr[l_ac].atn02=i007_set_atn02(g_atr[l_ac].atr15)
#                 LET g_atr_t.*=g_atr[l_ac].*
#              END IF
#           END IF
#           CALL cl_show_fld_cont()     #FUN-550037(smin)
#        END IF
#
#     BEFORE INSERT
#        LET l_n = ARR_COUNT()
#        LET p_cmd='a'
#        INITIALIZE g_atr[l_ac].* TO NULL            #900423
#        LET g_atr_t.* = g_atr[l_ac].*               #新輸入資料
#        LET g_atr[l_ac].atr04=0
#        CALL cl_show_fld_cont()
#        NEXT FIELD atr14
#
#     AFTER FIELD atr14                         # check data 是否重複
#        IF NOT cl_null(g_atr[l_ac].atr14) THEN
#           IF NOT i007_chk_atr14() THEN
#              LET g_atr[l_ac].atr14=g_atr_t.atr14
#              LET g_atr[l_ac].ats02=i007_set_ats02(g_atr[l_ac].atr14)
#              DISPLAY BY NAME g_atr[l_ac].atr14,g_atr[l_ac].ats02
#              NEXT FIELD CURRENT
#           END IF
#           LET g_atr[l_ac].ats02=i007_set_ats02(g_atr[l_ac].atr14)
#           DISPLAY BY NAME g_atr[l_ac].ats02
#           IF g_atr[l_ac].atr14 != g_atr_t.atr14 OR 
#              g_atr_t.atr14 IS NULL THEN
#              IF NOT i007_chk_dudata() THEN
#                 LET g_atr[l_ac].atr14=g_atr_t.atr14
#                 LET g_atr[l_ac].ats02=i007_set_ats02(g_atr[l_ac].atr14)
#                 DISPLAY BY NAME g_atr[l_ac].atr14,g_atr[l_ac].ats02
#                 NEXT FIELD CURRENT
#              END IF
#           END IF
#        END IF
#        LET g_atr[l_ac].ats02=i007_set_ats02(g_atr[l_ac].atr14)
#        DISPLAY BY NAME g_atr[l_ac].ats02
#
#     AFTER FIELD atr04
#        CALL i007_set_atr04()
#        
#     AFTER FIELD atr15                         # check data 是否重複
#        IF NOT cl_null(g_atr[l_ac].atr15) THEN
#           IF NOT i007_chk_atr15() THEN
#              LET g_atr[l_ac].atr15=g_atr_t.atr15
#              LET g_atr[l_ac].atn02=i007_set_atn02(g_atr[l_ac].atr15)
#              DISPLAY BY NAME g_atr[l_ac].atr15,g_atr[l_ac].atn02
#              NEXT FIELD CURRENT
#           END IF
#           LET g_atr[l_ac].atn02=i007_set_atn02(g_atr[l_ac].atr15)
#           DISPLAY BY NAME g_atr[l_ac].atn02
#           IF g_atr[l_ac].atr15 != g_atr_t.atr15 OR 
#              g_atr_t.atr15 IS NULL THEN
#              IF NOT i007_chk_dudata() THEN
#                 LET g_atr[l_ac].atr15=g_atr_t.atr15
#                 LET g_atr[l_ac].atn02=i007_set_atn02(g_atr[l_ac].atr15)
#                 DISPLAY BY NAME g_atr[l_ac].atr15,g_atr[l_ac].atn02
#                 NEXT FIELD CURRENT
#              END IF
#           END IF
#        END IF
#        LET g_atr[l_ac].atn02=i007_set_atn02(g_atr[l_ac].atr15)
#        DISPLAY BY NAME g_atr[l_ac].atn02
#
#     AFTER INSERT
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           INITIALIZE g_atr[l_ac].* TO NULL  #重要欄位空白,無效
#           DISPLAY g_atr[l_ac].* TO s_atr.*
#           CALL g_atr.deleteElement(g_rec_b+1)
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        INSERT INTO atr_file(atr11,atr12,atr13,atr01,atr02,atr14,atr04,
#                             atr15,atroriu,atrorig)
#             VALUES(g_atr11,g_atr12,g_atr13,g_atr01,g_atr02,
#                    g_atr[l_ac].atr14,g_atr[l_ac].atr04,
#                    g_atr[l_ac].atr15, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","atr_file",g_atr[l_ac].atr14,
#                        "",SQLCA.sqlcode,"","",1)
#           CANCEL INSERT
#        ELSE
#           MESSAGE 'INSERT O.K'
#           COMMIT WORK
#           LET g_rec_b=g_rec_b+1
#           DISPLAY g_rec_b TO FORMONLY.cn2
#        END IF
#
#     BEFORE DELETE                            #是否取消單身
#        IF l_ac>0 THEN
#           IF NOT cl_delb(0,0) THEN
#              CANCEL DELETE
#           END IF
#           IF l_lock_sw = "Y" THEN
#              CALL cl_err("", -263, 1)
#              CANCEL DELETE
#           END IF
#           DELETE FROM atr_file WHERE atr11 = g_atr11
#                                  AND atr12 = g_atr12
#                                  AND atr13 = g_atr13
#                                  AND atr01 = g_atr01
#                                  AND atr02 = g_atr02
#                                  AND atr14 = g_atr_t.atr14
#                                  AND atr15 = g_atr_t.atr15
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("del","atr_file",g_atr[l_ac].atr14,
#                           g_atr[l_ac].atr15,SQLCA.sqlcode,"","",1)
#              ROLLBACK WORK
#              CANCEL DELETE
#           END IF
#           LET g_rec_b = g_rec_b-1
#           DISPLAY g_rec_b TO FORMONLY.cn2
#        END IF
#        COMMIT WORK
#
#     ON ROW CHANGE
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           LET g_atr[l_ac].* = g_atr_t.*
#           CLOSE i007_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        IF l_lock_sw = 'Y' THEN
#           CALL cl_err(g_atr[l_ac].atr14,-263,1)
#           LET g_atr[l_ac].* = g_atr_t.*
#        ELSE
#           UPDATE atr_file SET atr14 = g_atr[l_ac].atr14,
#                               atr04 = g_atr[l_ac].atr04,
#                               atr15 = g_atr[l_ac].atr15
#                                WHERE atr11 = g_atr11
#                                  AND atr12 = g_atr12
#                                  AND atr13 = g_atr13
#                                  AND atr01 = g_atr01
#                                  AND atr02 = g_atr02
#                                  AND atr14 = g_atr_t.atr14
#                                  AND atr15 = g_atr_t.atr15
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("upd","atr_file",g_atr[l_ac].atr14,
#                           g_atr[l_ac].atr15,SQLCA.sqlcode,"","",1)
#              LET g_atr[l_ac].* = g_atr_t.*
#           ELSE
#              MESSAGE 'UPDATE O.K'
#              COMMIT WORK
#           END IF
#        END IF
#
#     AFTER ROW
#        LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           IF p_cmd = 'u' THEN
#              LET g_atr[l_ac].* = g_atr_t.*
#           END IF
#           CLOSE i007_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        CLOSE i007_bcl
#        COMMIT WORK
#        #CKP2
#         CALL g_atr.deleteElement(g_rec_b+1)
#
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(atr14)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_ats"
#             LET g_qryparam.default1 = g_atr[l_ac].atr14
#             CALL cl_create_qry() RETURNING g_atr[l_ac].atr14
#             DISPLAY BY NAME g_atr[l_ac].atr14
#             NEXT FIELD atr14
#          WHEN INFIELD(atr15)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_atn"
#             LET g_qryparam.default1 = g_atr[l_ac].atr15
#             LET g_qryparam.default2 = g_atr[l_ac].atn02
#             CALL cl_create_qry() RETURNING g_atr[l_ac].atr15,
#                                            g_atr[l_ac].atn02
#             DISPLAY BY NAME g_atr[l_ac].atr15
#             DISPLAY BY NAME g_atr[l_ac].atn02
#             NEXT FIELD atr15
#        END CASE
#
#     ON ACTION CONTROLZ
#        CALL cl_show_req_fields()
#
#     ON ACTION CONTROLG
#        CALL cl_cmdask()
#
#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
#            RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
##No.FUN-6B0029--beatk                                             
#     ON ACTION controls                                        
#        CALL cl_set_head_visible("","AUTO")                    
##No.FUN-6B0029--end 
#
#  END INPUT
#
#  CLOSE i007_bcl
#  COMMIT WORK
#END FUNCTION
#
#FUNCTION i007_b_fill(p_wc)                     #BODY FILL UP
#DEFINE p_wc STRING
#
#  LET g_sql = "SELECT atr14,'',atr04,atr15,''",
#              " FROM atr_file ",
#              " WHERE atr11 = '",g_atr11,"'",
#              "   AND atr12 = '",g_atr12,"'",
#              "   AND atr13 = '",g_atr13,"'",
#              "   AND atr01 = '",g_atr01,"'",
#              "   AND atr02 = '",g_atr02,"'",
#              "   AND ",p_wc CLIPPED ,
#              " ORDER BY atr14"
#  PREPARE i007_prepare2 FROM g_sql       #預備一下
#  DECLARE atr_cs CURSOR FOR i007_prepare2
#
#  CALL g_atr.clear()
#  LET g_cnt = 1
#  LET g_rec_b = 0
#
#  FOREACH atr_cs INTO g_atr[g_cnt].*     #單身 ARRAY 填充
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     LET g_atr[g_cnt].ats02=i007_set_ats02(g_atr[g_cnt].atr14)
#     LET g_atr[g_cnt].atn02=i007_set_atn02(g_atr[g_cnt].atr15)
#     LET g_cnt = g_cnt + 1
#     IF g_cnt > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF
#  END FOREACH
#
#  CALL g_atr.deleteElement(g_cnt)
#
#  LET g_rec_b=g_cnt-1
#
#  DISPLAY g_rec_b TO FORMONLY.cn2
#  LET g_cnt = 0
#
#END FUNCTION
#
#FUNCTION i007_bp(p_ud)
#  DEFINE   p_ud   LIKE type_file.chr1
#
#  IF p_ud <> "G" OR g_action_choice = "detail" THEN
#     RETURN
#  END IF
#
#  LET g_action_choice = " "
#
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_atr TO s_atr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#     BEFORE DISPLAY
#        CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ##########################################################################
#     # Standard 4ad ACTION
#     ##########################################################################
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DISPLAY
#
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#
#     ON ACTION delete
#        LET g_action_choice="delete"
#        EXIT DISPLAY
#
#     ON ACTION first
#        CALL i007_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION previous
#        CALL i007_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION jump
#        CALL i007_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION next
#        CALL i007_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION last
#        CALL i007_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION reproduce
#        LET g_action_choice="reproduce"
#        EXIT DISPLAY
#
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#
#    #str FUN-780068 add 10/19
#     ON ACTION generate   #異動明細產生
#        LET g_action_choice="generate"
#        EXIT DISPLAY
#    #end FUN-780068 add 10/19
#
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ##########################################################################
#     # Special 4ad ACTION
#     ##########################################################################
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#     
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
#
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
#
#     ON ACTION cancel
#        LET INT_FLAG=FALSE 		#MOD-570244	mars
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION exporttoexcel
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
#
#     ON ACTION related_document                #No.FUN-6B0040  相關文件
#        LET g_action_choice="related_document"          
#        EXIT DISPLAY 
#
#     AFTER DISPLAY
#        CONTINUE DISPLAY
##No.FUN-6B0029--beatk                                             
#     ON ACTION controls                                        
#        CALL cl_set_head_visible("","AUTO")                    
##No.FUN-6B0029--end
#
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#
#FUNCTION i007_copy()
#DEFINE
#  l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
#  l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
#  l_newno1,l_oldno1  LIKE atr_file.atr11,
#  l_newno2,l_oldno2  LIKE atr_file.atr12,
#  l_newno3,l_oldno3  LIKE atr_file.atr13,
#  l_newno4,l_oldno4  LIKE atr_file.atr01,
#  l_newno5,l_oldno5  LIKE atr_file.atr02,
#  li_result       LIKE type_file.num5
#
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#
#  IF cl_null(g_atr11) OR cl_null(g_atr12) OR
#     cl_null(g_atr13) OR cl_null(g_atr01) OR
#     cl_null(g_atr02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#
#  DISPLAY NULL TO atr11
#  DISPLAY NULL TO atr12
#  DISPLAY NULL TO atr13
#  DISPLAY NULL TO atr01
#  DISPLAY NULL TO atr02
#  CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
#
#  INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno5 
#   FROM atr11,atr12,atr13,atr01,atr02
#
#      AFTER FIELD atr11
#         CALL i007_chk_atr11(l_newno1) 
#             RETURNING li_result,l_newno2,l_newno3
#         DISPLAY i007_set_asg02(l_newno1) TO FORMONLY.asg02
#         DISPLAY l_newno2 TO atr12
#         DISPLAY l_newno3 TO atr13
#         IF NOT li_result THEN
#            NEXT FIELD CURRENT
#         END IF
#
#      AFTER FIELD atr02
#         IF (NOT cl_null(l_newno1)) OR (NOT cl_null(l_newno2)) OR
#            (NOT cl_null(l_newno3)) OR (NOT cl_null(l_newno4)) OR
#            (NOT cl_null(l_newno5)) THEN
#            LET l_cnt=0             
#            SELECT COUNT(*) INTO l_cnt FROM atr_file
#                                      WHERE atr11=l_newno1
#                                        AND atr12=l_newno2
#                                        AND atr13=l_newno3
#                                        AND atr01=l_newno4
#                                        AND atr02=l_newno5
#           IF l_cnt>0 THEN
#              CALL cl_err('','-239',1)
#              NEXT FIELD atr11
#           END IF
#         END IF
#
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(atr11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_asg"
#               CALL cl_create_qry() RETURNING l_newno1
#               DISPLAY l_newno1 TO atr11
#               NEXT FIELD atr11
#         END CASE
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  END INPUT
#
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     DISPLAY g_atr11 TO atr11
#     DISPLAY g_atr12 TO atr12
#     DISPLAY g_atr13 TO atr13
#     DISPLAY g_atr01 TO atr01
#     DISPLAY g_atr02 TO atr02
#     RETURN
#  END IF
#
#  DROP TABLE i007_x
#
#  SELECT * FROM atr_file             #單身複製
#   WHERE atr11 = g_atr11
#     AND atr12 = g_atr12
#     AND atr13 = g_atr13
#     AND atr01 = g_atr01
#     AND atr02 = g_atr02
#    INTO TEMP i007_x
#  IF SQLCA.sqlcode THEN
#     LET g_msg=l_newno1 CLIPPED
#     CALL cl_err3("ins","i007_x",g_atr11,g_atr12,SQLCA.sqlcode,"","",1)
#     RETURN
#  END IF
#
#  UPDATE i007_x SET atr11=l_newno1,
#                    atr12=l_newno2,
#                    atr13=l_newno3,
#                    atr01=l_newno4,
#                    atr02=l_newno5
#
#  INSERT INTO atr_file SELECT * FROM i007_x
#  IF SQLCA.sqlcode THEN
#     LET g_msg=l_newno1 CLIPPED
#     CALL cl_err3("ins","atr_file",l_newno1,l_newno2,
#                   SQLCA.sqlcode,"",g_msg,1)
#     RETURN
#  ELSE
#     MESSAGE 'COPY O.K'
#     LET g_atr11=l_newno1
#     LET g_atr12=l_newno2
#     LET g_atr13=l_newno3
#     LET g_atr01=l_newno4
#     LET g_atr02=l_newno5
#     CALL i007_show()
#  END IF
#
#END FUNCTION
# 
#FUNCTION i007_r()
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#  IF cl_null(g_atr11) OR cl_null(g_atr12) OR
#     cl_null(g_atr13) OR cl_null(g_atr01) OR
#     cl_null(g_atr02) THEN
#     CALL cl_err('',-400,1)
#     RETURN
#  END IF
#  IF NOT cl_delh(20,16) THEN RETURN END IF
#  INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
#  LET g_doc.column1 = "atr11"      #No.FUN-9B0098 10/02/24
#  LET g_doc.column2 = "atr12"      #No.FUN-9B0098 10/02/24
#  LET g_doc.column3 = "atr13"      #No.FUN-9B0098 10/02/24
#  LET g_doc.value1 = g_atr11       #No.FUN-9B0098 10/02/24
#  LET g_doc.value2 = g_atr12       #No.FUN-9B0098 10/02/24
#  LET g_doc.value3 = g_atr13       #No.FUN-9B0098 10/02/24
#  CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
#  DELETE FROM atr_file WHERE atr11=g_atr11
#                         AND atr12=g_atr12
#                         AND atr13=g_atr13
#                         AND atr01=g_atr01
#                         AND atr02=g_atr02
#  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err3("del","atr_file",g_atr11,g_atr12,
#                  SQLCA.sqlcode,"","del atr",1)
#     RETURN      
#  END IF   
#
#  INITIALIZE g_atr11,g_atr12,g_atr13,g_atr01,g_atr02 TO NULL
#  MESSAGE ""
#  DROP TABLE i007_cnttmp                   #No.TQC-720019
#  PREPARE i007_precount_x2 FROM g_sql_tmp  #No.TQC-720019
#  EXECUTE i007_precount_x2                 #No.TQC-720019
#  OPEN i007_count
#  #FUN-B50062-add-start--
#  IF STATUS THEN
#     CLOSE i007_bcs
#     CLOSE i007_count
#     COMMIT WORK
#     RETURN
#  END IF
#  #FUN-B50062-add-end--
#  FETCH i007_count INTO g_row_count
#  #FUN-B50062-add-start--
#  IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
#     CLOSE i007_bcs
#     CLOSE i007_count
#     COMMIT WORK
#     RETURN
#  END IF
#  #FUN-B50062-add-end--
#  DISPLAY g_row_count TO FORMONLY.cnt
#  IF g_row_count>0 THEN
#     OPEN i007_bcs
#     CALL i007_fetch('F') 
#  ELSE
#     DISPLAY g_atr11 TO atr11
#     DISPLAY g_atr12 TO atr12
#     DISPLAY g_atr13 TO atr13
#     DISPLAY g_atr01 TO atr01
#     DISPLAY g_atr02 TO atr02
#     DISPLAY 0 TO FORMONLY.cn2
#     CALL g_atr.clear()
#     CALL i007_menu()
#  END IF
#END FUNCTION
#
##str FUN-780068 add 10/19
#FUNCTION i007_g()   #0期資料產生
#DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
#DEFINE l_flag      LIKE type_file.chr1
#DEFINE li_result   LIKE type_file.num5
#DEFINE tm          RECORD
#                   atr11  LIKE atr_file.atr11,   #公司編號 
#                   atr12  LIKE atr_file.atr12,   #帳別
#                   atr13  LIKE atr_file.atr13,   #幣別
#                   yy     LIKE asf_file.asf10,   #年度
#                   mm     LIKE asf_file.asf11    #期別
#                  END RECORD
#
#  OPEN WINDOW i007_g_w AT p_row,p_col WITH FORM "agl/42f/ggli606_g"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#  CALL cl_ui_locale("ggli606_g")
#
#  WHILE TRUE
#     INPUT BY NAME tm.atr11,tm.atr12,tm.atr13,tm.yy,tm.mm WITHOUT DEFAULTS
#        BEFORE INPUT
#           CALL cl_qbe_display_condition(lc_qbe_sn)   #FUN-580031 add
#           INITIALIZE tm.* TO NULL
#           LET tm.yy = YEAR(g_today)    #現行年度
#           LET tm.mm = MONTH(g_today)   #現行期別
#           DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm
#
#        AFTER FIELD atr11
#           CALL i007_chk_atr11(tm.atr11) 
#                RETURNING li_result,tm.atr12,tm.atr13
#           DISPLAY tm.atr12 TO atr12
#           DISPLAY tm.atr13 TO atr13
#           IF NOT li_result THEN
#              NEXT FIELD CURRENT
#           END IF
#      
#        AFTER FIELD yy
#           IF cl_null(tm.yy) THEN
#              CALL cl_err('','mfg5103',0)
#              NEXT FIELD yy
#           END IF
#           IF tm.yy < 0 THEN NEXT FIELD yy END IF
#
#        AFTER FIELD mm
#           IF cl_null(tm.mm) THEN
#              CALL cl_err('','mfg5103',0)
#              NEXT FIELD mm
#           END IF
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(atr11)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_asg"
#                 CALL cl_create_qry() RETURNING tm.atr11
#                 DISPLAY tm.atr11 TO atr11
#                 NEXT FIELD atr11
#           END CASE
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121
#
#        AFTER INPUT
#           IF INT_FLAG THEN EXIT INPUT END IF
#
#        #No.FUN-580031 --start--     HCN
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.FUN-580031 --end--       HCN
#     END INPUT
#     IF INT_FLAG THEN
#        LET INT_FLAG=0
#        CLOSE WINDOW i007_g_w
#        RETURN
#     END IF
#     IF NOT cl_sure(0,0) THEN
#        CLOSE WINDOW i007_g_w
#        RETURN
#     ELSE
#        BEGIN WORK
#        LET g_success='Y'
#        CALL i007_g1(tm.*)
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag
#        END IF
#        IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#     END IF
#  END WHILE
#
#  CLOSE WINDOW i007_g_w
#END FUNCTION
#
#FUNCTION i007_g1(tm)
#DEFINE tm          RECORD
#                   atr11  LIKE atr_file.atr11,   #公司編號 
#                   atr12  LIKE atr_file.atr12,   #帳別
#                   atr13  LIKE atr_file.atr13,   #幣別
#                   yy     LIKE asf_file.asf10,   #年度
#                   mm     LIKE asf_file.asf11    #期別
#                  END RECORD,
#      l_cnt       LIKE type_file.num5,
#      sr          RECORD
#                   atr11  LIKE atr_file.atr11,   #公司編號
#                   atr12  LIKE atr_file.atr12,   #帳別
#                   atr13  LIKE atr_file.atr13,   #幣別
#                   atr01  LIKE atr_file.atr01,   #年度
#                   atr02  LIKE atr_file.atr02,   #期別
#                   atr14  LIKE atr_file.atr14,   #分類代碼
#                   atr15  LIKE atr_file.atr15,   #群組代碼
#                   atr04  LIKE atr_file.atr04    #異動金額
#                  END RECORD
#
#  LET l_cnt = 0
#  SELECT COUNT(*) INTO l_cnt FROM atr_file
#   WHERE atr01=tm.yy    AND atr02=tm.mm
#     AND atr11=tm.atr11 AND atr12=tm.atr12 AND atr13=tm.atr13
#  IF l_cnt > 0 THEN
#     #先將舊資料刪除，再重新產生
#     DELETE FROM atr_file 
#      WHERE atr01=tm.yy    AND atr02=tm.mm
#        AND atr11=tm.atr11 AND atr12=tm.atr12 AND atr13=tm.atr13
#     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err3("del","atr_file",tm.atr11,tm.atr12,SQLCA.sqlcode,"","del atr",1)
#        LET g_success='N'
#        RETURN      
#     END IF
#  END IF
#
#  #異動金額：借方為 - 減少(atu11='1')
#  #          貸方為 + 增加(atu11='2')
#  DECLARE i007_atsbc_cs CURSOR FOR
#     SELECT atu01,atu02,atu03,atu04,atu05,ats01,atu13,SUM(atu12)*-1
#       FROM ats_file,att_file,atu_file
#      WHERE ats01=att01
#        AND att02=atu10
#        AND atu01=tm.atr11
#        AND atu02=tm.atr12
#        AND atu03=tm.atr13
#        AND atu04=tm.yy
#        AND atu05=tm.mm
#        AND atu11='1'   #借方
#      GROUP BY atu01,atu02,atu03,atu04,atu05,ats01,atu13
#     UNION 
#     SELECT atu01,atu02,atu03,atu04,atu05,ats01,atu13,SUM(atu12)
#       FROM ats_file,att_file,atu_file
#      WHERE ats01=att01
#        AND att02=atu10
#        AND atu01=tm.atr11
#        AND atu02=tm.atr12
#        AND atu03=tm.atr13
#        AND atu04=tm.yy
#        AND atu05=tm.mm
#        AND atu11='2'   #貸方
#      GROUP BY atu01,atu02,atu03,atu04,atu05,ats01,atu13
#
#  FOREACH i007_atsbc_cs INTO sr.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        LET g_success='N'
#        EXIT FOREACH
#     END IF
#
#     INSERT INTO atr_file(atr11,atr12,atr13,atr01,atr02,atr14,atr04,atr15,atroriu,atrorig)
#                   VALUES(sr.atr11,sr.atr12,sr.atr13,sr.atr01,sr.atr02,
#                          sr.atr14,sr.atr04,sr.atr15, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #SQLCA.SQLCODE=-239
#        UPDATE atr_file SET atr04 = atr04 + sr.atr04
#                      WHERE atr11 = sr.atr11
#                        AND atr12 = sr.atr12
#                        AND atr13 = sr.atr13
#                        AND atr01 = sr.atr01
#                        AND atr02 = sr.atr02
#                        AND atr14 = sr.atr14
#                        AND atr15 = sr.atr15
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("upd","atr_file",sr.atr14,sr.atr15,SQLCA.sqlcode,"","",1)
#           LET g_success='N'
#           EXIT FOREACH
#        END IF
#     ELSE
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","atr_file",sr.atr14,sr.atr15,SQLCA.sqlcode,"","",1)
#           LET g_success='N'
#           EXIT FOREACH
#        END IF
#     END IF
#  END FOREACH
#
#END FUNCTION
##end FUN-780068 add 10/19
#
#FUNCTION i007_chk_atr11(p_atr11)
#  DEFINE p_atr11 LIKE atr_file.atr11
#  DEFINE l_asgacti  LIKE asg_file.asgacti
#  DEFINE l_asg05 LIKE asg_file.asg05
#  DEFINE l_asg06 LIKE asg_file.asg06
#
#  LET l_asg05=NULL
#  LET l_asg06=NULL
#  IF NOT cl_null(p_atr11) THEN
#   # SELECT asgacti,asg05,asg06                              #FUN-920123 mark
#   #   INTO l_asgacti,l_asg05,l_asg06 FROM asg_file          #FUN-920123 mark
#     SELECT asg05,asg06                                      #FUN-920123
#       INTO l_asg05,l_asg06 FROM asg_file                    #FUN-920123   
#                                     WHERE asg01=p_atr11
#     CASE
#        WHEN SQLCA.sqlcode
#           CALL cl_err3("sel","atr_file",p_atr11,"",SQLCA.sqlcode,"","",1)
#           RETURN FALSE,NULL,NULL
#       #FUN-920123 -----------------mark start---------------
#       #WHEN l_asgacti='N'
#       #   CALL cl_err3("sel","atr_file",p_atr11,"",9028,"","",1)
#       #   RETURN FALSE,NULL,NULL
#       #FUN-920123 ---------------  mark end--------------- 
#     END CASE      
#  END IF
#  RETURN TRUE,l_asg05,l_asg06
#END FUNCTION
#
#FUNCTION i007_set_asg02(p_asg01)
#  DEFINE p_asg01 LIKE asg_file.asg01
#  DEFINE l_asg02 LIKE asg_file.asg02
#  
#  IF cl_null(p_asg01) THEN RETURN NULL END IF
#  LET l_asg02=''
#  SELECT asg02 INTO l_asg02 FROM asg_file
#                           WHERE asg01=p_asg01
#  RETURN l_asg02
#END FUNCTION
#
#FUNCTION i007_set_ats02(p_ats01)
#  DEFINE p_ats01 LIKE ats_file.ats01
#  DEFINE l_ats02 LIKE ats_file.ats02
#  
#  IF cl_null(p_ats01) THEN RETURN NULL END IF
#  LET l_ats02=''
#  SELECT ats02 INTO l_ats02 FROM ats_file
#                           WHERE ats01=p_ats01
#  RETURN l_ats02
#END FUNCTION
#
#FUNCTION i007_chk_atr14()
#  IF NOT cl_null(g_atr[l_ac].atr14) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM ats_file 
#                               WHERE ats01 = g_atr[l_ac].atr14
#     IF g_cnt=0 THEN
#        CALL cl_err3("sel","ats_file",g_atr[l_ac].atr14,"",100,"","",1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i007_chk_atr15()
#  IF NOT cl_null(g_atr[l_ac].atr15) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM atn_file 
#                               WHERE atn01 = g_atr[l_ac].atr15
#     IF g_cnt=0 THEN
#        CALL cl_err3("sel","atn_file",g_atr[l_ac].atr15,"",100,"","",1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i007_set_atr04()
#  IF NOT cl_null(g_atr[l_ac].atr04) THEN
#     SELECT azi04 INTO t_azi04 FROM azi_file
#                              WHERE azi01=g_atr13
#     LET g_atr[l_ac].atr04=cl_digcut(g_atr[l_ac].atr04,t_azi04)
#     DISPLAY BY NAME g_atr[l_ac].atr04
#  END IF
#END FUNCTION
#
#FUNCTION i007_chk_dudata()
#  IF (NOT cl_null(g_atr[l_ac].atr14)) AND 
#     (NOT cl_null(g_atr[l_ac].atr15)) THEN
#     LET g_cnt=0
#     SELECT COUNT(*) INTO g_cnt FROM atr_file
#                               WHERE atr11=g_atr11
#                                 AND atr12=g_atr12
#                                 AND atr13=g_atr13
#                                 AND atr01=g_atr01
#                                 AND atr02=g_atr02
#                                 AND atr14=g_atr[l_ac].atr14
#                                 AND atr15=g_atr[l_ac].atr15
#     IF g_cnt>0 THEN
#        CALL cl_err('',-239,1)
#        RETURN FALSE
#     END IF
#  END IF
#  RETURN TRUE
#END FUNCTION
#
#FUNCTION i007_out()
#  DEFINE l_wc STRING
#  IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#
#  CALL cl_wait()
#
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
#  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'ggli606'
#
#  #組合出 SQL 指令
#  LET g_sql="SELECT A.atr11,B.asg02 atr11_d,A.atr12,A.atr13,",
#            "       A.atr01,A.atr02,A.atr14,C.ats02 atr14_d,",
#            "       A.atr04,A.atr15,D.atn02 atr15_d,E.azi04,E.azi05",
#            "  FROM atr_file A,asg_file B,ats_file C,",
#            "       atn_file D,azi_file E",
#            " WHERE A.atr11=B.asg01",
#            "   AND A.atr14=C.ats01",
#            "   AND A.atr15=D.atn01",
#            "   AND A.atr13=E.azi01",
#            "   AND ",g_wc CLIPPED,
#            " ORDER BY A.atr11,A.atr12,A.atr13,A.atr01,A.atr02,",
#            "          A.atr14,A.atr15"
#  PREPARE i007_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i007_co  CURSOR FOR i007_p1
#
#  #是否列印選擇條件
#  IF g_zz05 = 'Y' THEN
#     CALL cl_wcchp(g_wc,'atr11,atr12,atr13,atr01,atr02,atr14,atr04,atr15')
#          RETURNING l_wc
#  ELSE
#     LET l_wc = ' '
#  END IF
#
#  CALL cl_prt_cs1('ggli606','ggli606',g_sql,l_wc)
#
#END FUNCTION
#
#FUNCTION i007_set_atn02(p_atn01)
#  DEFINE p_atn01 LIKE atn_file.atn01
#  DEFINE l_atn02 LIKE atn_file.atn02
#  
#  IF cl_null(p_atn01) THEN RETURN NULL END IF
#  LET l_atn02=''
#  SELECT atn02 INTO l_atn02 FROM atn_file
#                           WHERE atn01=p_atn01
#  RETURN l_atn02
#END FUNCTION
##FUN-780013

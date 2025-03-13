# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: ggli501.4gl
# Date & Author..: 01/02/01 By Wiky
 # Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/26 By Nicola 報表架構修改
# Modify.........: NO.FUN-570108 05/07/13 By Trisy key值可更改      
# Modify.........: No.FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-640004 06/04/04 By Ray 單身新加行序欄位atj05
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-790064 07/09/12 By dxfwo 行序欄位值對負數無控管
# Modify.........: No.FUN-820002 07/12/20 By lala   報表轉為使用p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B20068 11/02/25 By chenmoyan 呼叫sggli501
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植 
# Modify.........: NO.TQC-C50175 12/05/21 By lujh 新增sggli501供ggli501以及ggli5011共同調用

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-BB0037
 
#FUN-B20068 --Beatk
#DEFINE 
#    g_atj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
#       atj01           LIKE atj_file.atj01,   #群組代碼
#       atj02           LIKE atj_file.atj02,   #說明
#       atj03           LIKE atj_file.atj03,   #變動分類
#       atj04           LIKE atj_file.atj04,   #合併否
#       atj05           LIKE atj_file.atj05    #行次 #FUN-640004
#                    END RECORD,
#    g_atj_t         RECORD                 #程式變數 (舊值)
#       atj01           LIKE atj_file.atj01,   #群組代碼
#       atj02           LIKE atj_file.atj02,   #說明
#       atj03           LIKE atj_file.atj03,   #變動分類
#       atj04           LIKE atj_file.atj04,   #合併否
#       atj05           LIKE atj_file.atj05    #行次 #FUN-640004
#                    END RECORD,
#    g_wc,g_wc2,g_sql     STRING,  #No.FUN-580092 HCN
#    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680098 SMALLINT
#    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT
#DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL    
#DEFINE g_cnt        LIKE type_file.num10            #No.FUN-680098 INTEGER
#DEFINE g_i          LIKE type_file.num5     #count/index for any purpose      #No.FUN-680098 SMALLINT
#DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570108             #No.FUN-680098 SMALLINT
#FUN-B20068 --End mark
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
      DEFINE
       p_row,p_col   LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
#FUN-B20068 --Beatk
#  LET p_row = 4 LET p_col = 30
#
#  OPEN WINDOW i930_w AT p_row,p_col
#    WITH FORM "agl/42f/ggli501"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#  
#  CALL cl_ui_init()
#
#  LET g_wc2 = '1=1'
#
#  CALL i930_b_fill(g_wc2)
#
#  CALL i930_menu()
#
#  CLOSE WINDOW i930_w                 #結束畫面
#FUN-B20068 --End mark
   #CALL i930('1')   #TQC-C50175  mark
   CALL i501('1')    #TQC-C50175  add
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#FUN-B20068 --Beatk mark
#FUNCTION i930_menu()
#DEFINE l_cmd  LIKE type_file.chr1000
#   WHILE TRUE
#      CALL i930_bp("G")
#      CASE g_action_choice
#         WHEN "query" 
#            IF cl_chk_act_auth() THEN
#               CALL i930_q()
#            END IF
#         WHEN "detail" 
#            IF cl_chk_act_auth() THEN
#               CALL i930_b()
#            ELSE
#               LET g_action_choice = NULL
#            END IF
#         WHEN "output"
#            IF cl_chk_act_auth()                                                   
#               THEN CALL i930_out()                                            
#            END IF                                                                 
# 
#         WHEN "help" 
#            CALL cl_show_help()
#         WHEN "exit"
#            EXIT WHILE
#         WHEN "controlg"
#            CALL cl_cmdask()
#          WHEN "related_document"  #No.MOD-470515
#            IF cl_chk_act_auth() AND l_ac != 0 THEN  # FUN-570200
#               IF g_atj[l_ac].atj01 IS NOT NULL THEN
#                  LET g_doc.column1 = "atj01"
#                  LET g_doc.value1 = g_atj[l_ac].atj01
#                  CALL cl_doc()
#               END IF
#            END IF
#         WHEN "exporttoexcel"   #No.FUN-4B0010
#            IF cl_chk_act_auth() THEN
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_atj),'','')
#            END IF
# 
#      END CASE
#   END WHILE
# 
#END FUNCTION
# 
#FUNCTION i930_q()
# 
#   CALL i930_b_askkey()
# 
#END FUNCTION
# 
#FUNCTION i930_b()
#DEFINE l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-680098 SMALLINT
#       l_n             LIKE type_file.num5,      #檢查重複用      #No.FUN-680098 SMALLINT
#       l_lock_sw       LIKE type_file.chr1,      #單身鎖住否      #No.FUN-680098 VARCHAR(1)
#       p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680098 VARCHAR(1)
#       l_possible      LIKE type_file.num5,      #用來設定判斷重複的可能性   #No.FUN-680098 SMALLINT   
#       l_allow_insert  LIKE type_file.chr1,      #可新增否       #No.FUN-680098    VARCHAR(1)
#       l_allow_delete  LIKE type_file.chr1       #可刪除否       #No.FUN-680098    VARCHAR(1)
# 
#   IF s_shut(0) THEN RETURN END IF
# 
#   LET l_allow_insert = cl_detail_input_auth('insert')
#   LET l_allow_delete = cl_detail_input_auth('delete')
# 
#   CALL cl_opmsg('b')
# 
#   LET g_forupd_sql = " SELECT atj01,atj02,atj03,atj04,atj05 ",    #FUN-640004
#                      "   FROM atj_file ",
#                      "  WHERE atj01 = ? FOR UPDATE "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE i930_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
# 
#   INPUT ARRAY g_atj WITHOUT DEFAULTS FROM s_atj.*
#      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
# 
#      BEFORE INPUT
#         LET g_action_choice = ""
#         IF g_rec_b!=0 THEN
#            CALL fgl_set_arr_curr(l_ac)
#         END IF
# 
#      BEFORE ROW
#         LET p_cmd=''
#         LET l_ac = ARR_CURR()
#         LET l_lock_sw = 'N'            #DEFAULT
#         LET l_n  = ARR_COUNT()
#         IF g_rec_b >= l_ac THEN
##No.FUN-570108 --start--                                                        
#            LET p_cmd='u'
#            LET  g_before_input_done = FALSE                                        
#            CALL i930_set_entry(p_cmd)                                              
#            CALL i930_set_no_entry(p_cmd)                                           
#            LET  g_before_input_done = TRUE                                         
##No.FUN-570108 --end--              
#            BEGIN WORK
#            LET p_cmd='u'
#            LET g_atj_t.* = g_atj[l_ac].*  #BACKUP
#            OPEN i930_bcl USING g_atj_t.atj01
#            IF STATUS THEN
#               CALL cl_err("OPEN i930_bcl:", STATUS, 1)
#               LET l_lock_sw = "Y"
#            ELSE 
#               FETCH i930_bcl INTO g_atj[l_ac].* 
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_atj_t.atj01,SQLCA.sqlcode,1)
#                  LET l_lock_sw = "Y"
#               END IF
#            END IF
#            CALL cl_show_fld_cont()     #FUN-550037(smin)
#         END IF
# 
#      BEFORE INSERT
#         LET l_n = ARR_COUNT()
#         LET p_cmd='a'
##No.FUN-570108 --start--                                                        
#         LET  g_before_input_done = FALSE                                        
#         CALL i930_set_entry(p_cmd)                                              
#         CALL i930_set_no_entry(p_cmd)                                           
#         LET  g_before_input_done = TRUE                                         
##No.FUN-570108 --end--       
#         INITIALIZE g_atj[l_ac].* TO NULL
#         LET g_atj[l_ac].atj03 = '1'       #Body default
#         LET g_atj[l_ac].atj04 = 'N'       #Body default
#         LET g_atj[l_ac].atj05 = '1'       #Body default  #FUN-640004
#         LET g_atj_t.* = g_atj[l_ac].*     #新輸入資料
#         CALL cl_show_fld_cont()     #FUN-550037(smin)
#         NEXT FIELD atj01
# 
#      AFTER FIELD atj01                        #check 編號是否重複
#         IF g_atj[l_ac].atj01 != g_atj_t.atj01 OR
#            (g_atj[l_ac].atj01 IS NOT NULL AND g_atj_t.atj01 IS NULL) THEN
#            SELECT count(*) INTO l_n FROM atj_file
#             WHERE atj01 = g_atj[l_ac].atj01
#            IF l_n > 0 THEN
#               CALL cl_err('',-239,0)
#               LET g_atj[l_ac].atj01 = g_atj_t.atj01
#               NEXT FIELD atj01
#            END IF
#         END IF
# 
#      AFTER FIELD atj03
#         IF g_atj[l_ac].atj03 NOT MATCHES '[12345]' OR
#            cl_null(g_atj[l_ac].atj03) THEN
#            LET g_atj[l_ac].atj03 = g_atj_t.atj03
#            NEXT FIELD atj03
#         END IF
#      
#      AFTER FIELD atj04
#         IF cl_null(g_atj[l_ac].atj04) OR 
#            g_atj[l_ac].atj04 NOT MATCHES '[YyNn]' THEN
#            NEXT FIELD atj04
#         END IF
# 
##No.TQC-790064---Beatk 
#      AFTER FIELD atj05                                                                                                             
#         IF g_atj[l_ac].atj05 < 0 THEN                                                                                              
#            CALL cl_err(g_atj[l_ac].atj05,'agl-888',1)                                                                              
#            NEXT FIELD atj05                                                                                                        
#         END IF               
##No.TQC-790064---End 
# 
#      BEFORE DELETE                            #是否取消單身
#         IF g_atj_t.atj01 IS NOT NULL THEN
#            IF NOT cl_delete() THEN
#               CANCEL DELETE
#            END IF
#            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
#            LET g_doc.column1 = "atj01"               #No.FUN-9B0098 10/02/24
#            LET g_doc.value1 = g_atj[l_ac].atj01      #No.FUN-9B0098 10/02/24
#            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
#            IF l_lock_sw = "Y" THEN 
#               CALL cl_err("", -263, 1) 
#               CANCEL DELETE 
#            END IF 
#            DELETE FROM atj_file 
#             WHERE atj01 = g_atj_t.atj01
#            IF SQLCA.sqlcode THEN
##              CALL cl_err(g_atj_t.atj01,SQLCA.sqlcode,0)   #No.FUN-660123
#               CALL cl_err3("del","atj_file",g_atj_t.atj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
#               ROLLBACK WORK
#               CANCEL DELETE
#            END IF
#            LET g_rec_b=g_rec_b-1
#            DISPLAY g_rec_b TO FORMONLY.cn2  
#            COMMIT WORK 
#         END IF
# 
#      ON ROW CHANGE
#         IF INT_FLAG THEN                 #900423
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            LET g_atj[l_ac].* = g_atj_t.*
#            CLOSE i930_bcl
#            ROLLBACK WORK
#            EXIT INPUT
#         END IF
#         IF l_lock_sw = 'Y' THEN
#            CALL cl_err(g_atj[l_ac].atj01,-263,1)
#            LET g_atj[l_ac].* = g_atj_t.*
#         ELSE
#            UPDATE atj_file SET atj01 = g_atj[l_ac].atj01,
#                                atj02 = g_atj[l_ac].atj02,
#                                atj03 = g_atj[l_ac].atj03,
#                                atj04 = g_atj[l_ac].atj04,
#                                atj05 = g_atj[l_ac].atj05    #FUN-640004
#             WHERE atj01 = g_atj_t.atj01
#            IF SQLCA.sqlcode THEN
##              CALL cl_err(g_atj[l_ac].atj01,SQLCA.sqlcode,0)   #No.FUN-660123
#               CALL cl_err3("upd","atj_file",g_atj_t.atj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
#               LET g_atj[l_ac].* = g_atj_t.*
#               ROLLBACK WORK
#            ELSE
#               MESSAGE 'UPDATE O.K'
#               COMMIT WORK
#            END IF
#         END IF
# 
#      AFTER ROW
#         LET l_ac = ARR_CURR()
#         LET l_ac_t = l_ac
# 
#         IF INT_FLAG THEN                 #900423
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            IF p_cmd='u' THEN
#               LET g_atj[l_ac].* = g_atj_t.*
#            END IF
#            CLOSE i930_bcl
#            ROLLBACK WORK
#            EXIT INPUT
#         END IF
#         CLOSE i930_bcl
#         COMMIT WORK
# 
#      AFTER INSERT
#         IF INT_FLAG THEN                 #900423
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            CANCEL INSERT
#            CLOSE i930_bcl
#         END IF
#         INSERT INTO atj_file(atj01,atj02,atj03,atj04,atj05)    #FUN-640004 
#                       VALUES(g_atj[l_ac].atj01,g_atj[l_ac].atj02,
#                              g_atj[l_ac].atj03,g_atj[l_ac].atj04,g_atj[l_ac].atj05)    #FUN-640004
#         IF SQLCA.sqlcode THEN
##           CALL cl_err(g_atj[l_ac].atj01,SQLCA.sqlcode,0)   #No.FUN-660123
#            CALL cl_err3("ins","atj_file",g_atj[l_ac].atj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
#            CANCEL INSERT
#         ELSE
#            MESSAGE 'INSERT O.K'
#            LET g_rec_b = g_rec_b + 1
#            DISPLAY g_rec_b TO FORMONLY.cn2  
#         END IF
# 
#      ON ACTION CONTROLO                        #沿用所有欄位
#         IF INFIELD(atj01) AND l_ac > 1 THEN
#            LET g_atj[l_ac].* = g_atj[l_ac-1].*
#            NEXT FIELD atj01
#         END IF
# 
#      ON ACTION CONTROLZ
#         CALL cl_show_req_fields()
# 
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
# 
#      ON ACTION CONTROLF
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#        
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
#      
#       ON ACTION help          #MOD-4C0121
#          CALL cl_show_help()  #MOD-4C0121
#       
#   END INPUT
# 
#   CLOSE i930_bcl
#   COMMIT WORK 
# 
#END FUNCTION
# 
#FUNCTION i930_b_askkey()
# 
#   CLEAR FORM
#   CALL g_atj.clear()
# 
#   CONSTRUCT g_wc2 ON atj01,atj02,atj03,atj04,atj05     #FUN-640004
#        FROM s_atj[1].atj01,s_atj[1].atj02,s_atj[1].atj03,s_atj[1].atj04,s_atj[1].atj05     #FUN-640004
# 
#              #No.FUN-580031 --start--     HCN
#              BEFORE CONSTRUCT
#                 CALL cl_qbe_init()
#              #No.FUN-580031 --end--       HCN
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
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
#		#No.FUN-580031 --start--     HCN
#                 ON ACTION qbe_select
#         	   CALL cl_qbe_select() 
#                 ON ACTION qbe_save
#		   CALL cl_qbe_save()
#		#No.FUN-580031 --end--       HCN
#   END CONSTRUCT
#   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#   
##No.TQC-710076 -- beatk --
##   IF INT_FLAG THEN
##      LET INT_FLAG = 0 
##      RETURN
##   END IF
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      LET g_wc2 = NULL
#      RETURN
#   END IF
##No.TQC-710076 -- end --
#   
#   CALL i930_b_fill(g_wc2)
#   
#END FUNCTION
# 
#FUNCTION i930_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2    LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(200)
#DEFINE l_cmd  LIKE type_file.chr1000
# 
#   LET g_sql = "SELECT atj01,atj02,atj03,atj04,atj05 ",      #FUN-640004
#               " FROM atj_file",
#               " WHERE ", p_wc2 CLIPPED,                     #單身
#               " ORDER BY 1"
#   PREPARE i930_pb FROM g_sql
#   DECLARE atj_curs CURSOR FOR i930_pb
# 
#   CALL g_atj.clear()
#   LET g_cnt = 1
#   MESSAGE "Searching!" 
# 
#   FOREACH atj_curs INTO g_atj[g_cnt].*   #單身 ARRAY 填充
#      IF STATUS THEN 
#         CALL cl_err('foreach:',STATUS,1) 
#         EXIT FOREACH
#      END IF
# 
#      LET g_cnt = g_cnt + 1
# 
#      IF g_cnt > g_max_rec THEN
#         CALL cl_err( '', 9035, 0 )
#         EXIT FOREACH
#      END IF
#   END FOREACH
# 
#   CALL g_atj.deleteElement(g_cnt)
#   MESSAGE ""
#   LET g_rec_b = g_cnt-1
#   DISPLAY g_rec_b TO FORMONLY.cn2  
#   LET g_cnt = 0
# 
#END FUNCTION
# 
#FUNCTION i930_bp(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = " "
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_atj TO s_atj.* ATTRIBUTE(COUNT=g_rec_b)
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#             LET INT_FLAG=FALSE 		#MOD-570244	mars
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#   
##@    ON ACTION 相關文件  
#       ON ACTION related_document  #No.MOD-470515
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
# 
#      ON ACTION exporttoexcel   #No.FUN-4B0010
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
# 
#      # No.FUN-530067 --start--
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#      # No.FUN-530067 ---end---
# 
# 
#   END DISPLAY
# 
#   CALL cl_set_act_visible("accept,cancel", TRUE)
# 
#END FUNCTION
# 
##No.FUN-820002--start--
#FUNCTION i930_out()
##  DEFINE l_atj           RECORD LIKE atj_file.*,
##         l_i             LIKE type_file.num5,         #No.FUN-680098 SMALLINT
##         l_name          LIKE type_file.chr20         #No.FUN-680098 VARCHAR(20)
#DEFINE l_cmd  LIKE type_file.chr1000  
#   IF g_wc2 IS NULL THEN 
#      CALL cl_err('','9057',0)
#      RETURN 
#   END IF
#   LET l_cmd = 'p_query "ggli501" "',g_wc2 CLIPPED,'"'                                                                              
#   CALL cl_cmdrun(l_cmd)                                                                                                            
#   RETURN
##  CALL cl_wait()
##  CALL cl_outnam('ggli501') RETURNING l_name
##  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
##  
##  LET g_sql="SELECT * FROM atj_file ",          # 組合出 SQL 指令
##            " WHERE ",g_wc2 CLIPPED
##  PREPARE i930_p1 FROM g_sql                # RUNTIME 編譯
##  DECLARE i930_co CURSOR FOR i930_p1
# 
##  START REPORT i930_rep TO l_name
# 
##  FOREACH i930_co INTO l_atj.*
##     IF SQLCA.sqlcode THEN
##        CALL cl_err('foreach:',SQLCA.sqlcode,1)   
##        EXIT FOREACH
##     END IF
# 
##     OUTPUT TO REPORT i930_rep(l_atj.*)
# 
##  END FOREACH
# 
##  FINISH REPORT i930_rep
# 
##  CLOSE i930_co
##  ERROR ""
##  CALL cl_prt(l_name,' ','1',g_len)
# 
#END FUNCTION
# 
##REPORT i930_rep(sr)
##  DEFINE l_trailer_sw   LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1) 
##         sr RECORD LIKE atj_file.*
# 
##  OUTPUT
##     TOP MARGIN g_top_maratk
##     LEFT MARGIN g_left_maratk
##     BOTTOM MARGIN g_bottom_maratk
##     PAGE LENGTH g_page_line
# 
##  ORDER BY sr.atj01
# 
##  FORMAT
##     PAGE HEADER
##        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
##        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
##        LET g_pageno = g_pageno + 1
##        LET pageno_total = PAGENO USING '<<<',"/pageno"
##        PRINT g_head CLIPPED,pageno_total
##        PRINT
##        PRINT g_dash[1,g_len]
##        PRINT g_x[31],g_x[32],g_x[33]
##        PRINT g_dash1
##        LET l_trailer_sw = 'y'
# 
##     ON EVERY ROW
##        IF sr.atj03 = 'N' THEN
##           LET sr.atj01 = '*',sr.atj01
##        END IF
##        PRINT COLUMN g_c[31],sr.atj01 CLIPPED,
##              COLUMN g_c[32],sr.atj02 CLIPPED,
##              COLUMN g_c[33],sr.atj04 CLIPPED
# 
##     ON LAST ROW
##        PRINT g_dash[1,g_len]
##        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
##        LET l_trailer_sw = 'n'
# 
##     PAGE TRAILER
##        IF l_trailer_sw = 'y' THEN
##           PRINT g_dash[1,g_len]
##           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
##        ELSE
##           SKIP 2 LINE
##        END IF
# 
##END REPORT
##No.FUN-820002--end--
# 
##No.FUN-570108 --start--                                                        
#                                                                                
#FUNCTION i930_set_entry(p_cmd)                                                  
#  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680098    VARCHAR(1)                                                          #No.FUN-680098
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
#      CALL cl_set_comp_entry("atj01",TRUE)                                      
#   END IF                                                                       
#END FUNCTION                                                                    
#                                                                                
#                                                                                
#FUNCTION i930_set_no_entry(p_cmd)                                               
#  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680098   VARCHAR(1)                                                        #No.FUN-680098
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
#      CALL cl_set_comp_entry("atj01",FALSE)                                     
#   END IF                                                                       
#END FUNCTION                                                                    
#                                                                                
##No.FUN-570108 --end--       
#FUN-B20068 --End

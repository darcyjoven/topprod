# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: ggli504.4gl
# Descriptions...: 現金流量表揭露事項維護作業
# Date & Author..: 00/07/14  By Hamilton
 # Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/26 By Nicola 報表架構修改
# Modify.........: NO.FUN-570108 05/07/13 By Trisy key值可更改       
# Modify.........: No.FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/08/03 By sherry  報表改由p_query輸出                                                            
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B80180 11/08/30 by zhangweib 拆出sggli504.4gl
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-BB0037

#FUN-B80180   ---start   Add
DEFINE g_atm00   LIKE atm_file.atm00

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 3
   LET p_col = 18
   LET g_atm00 = "N"
   OPEN WINDOW i920_w AT p_row,p_col
     WITH FORM "ggl/42f/ggli504"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL i920(g_atm00)

   CLOSE WINDOW i920_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-B80180   ---end     Add 

#FUN-B80180   ---start   Mark
#DEFINE 
#   g_atm           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
#      atm00           LIKE atm_file.atm00,
#      atm01           LIKE atm_file.atm01,   
#      atm02           LIKE atm_file.atm02,
#      atm03           LIKE atm_file.atm03
#                   END RECORD,
#   g_atm_t         RECORD                 #程式變數 (舊值)
#       atm00          LIKE atm_file.atm00,
#       atm01          LIKE atm_file.atm01,   
#       atm02          LIKE atm_file.atm02,
#       atm03          LIKE atm_file.atm03
#                   END RECORD,
#   g_wc2,g_sql     STRING,#TQC-630166  
#   g_rec_b         LIKE type_file.num5,    #單身筆數                 #No.FUN-680098 SMALLLINT
#   l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT       #No.FUN-680098 SMALLINT
#DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
#DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680098  INTEGER
#DEFINE g_i          LIKE type_file.num5     #count/index for any purpose      #No.FUN-680098 SMALLINT
#DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570108            #No.FUN-680098 SMALLINT
#DEFINE l_cmd        LIKE type_file.chr1000  #No.FUN-780037  
#MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
#    DEFINE
#      p_row,p_col   LIKE type_file.num5           #No.FUN-680098 SMALLINT
#
#  OPTIONS                               #改變一些系統預設值
#     INPUT NO WRAP
#  DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
#
#  IF (NOT cl_user()) THEN
#     EXIT PROGRAM
#  END IF
# 
#  WHENEVER ERROR CALL cl_err_msg_log
# 
#  IF (NOT cl_setup("GGL")) THEN
#     EXIT PROGRAM
#  END IF
#  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#
#
#  LET p_row = 3 LET p_col = 18
#  OPEN WINDOW i920_w AT p_row,p_col 
#    WITH FORM "agl/42f/ggli504"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#  
#  CALL cl_ui_init()
#
#  LET g_wc2 = '1=1'
#
#  CALL i920_b_fill(g_wc2) 
#
#  CALL i920_menu()
#
#  CLOSE WINDOW i920_w                 #結束畫面
#
#  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#END MAIN
 
#FUNCTION i920_menu()
#
#  WHILE TRUE
#     CALL i920_bp("G")
#     CASE g_action_choice
#        WHEN "query"
#           IF cl_chk_act_auth() THEN
#              CALL i920_q()
#           END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL i920_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              #No.FUN-780037---Beatk                
#              #CALL i920_out()
#              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
#              LET l_cmd = 'p_query "ggli504" "',g_wc2 CLIPPED,'"'               
#              CALL cl_cmdrun(l_cmd)                                                                                                
#              #No.FUN-780037---End  
#           END IF
#        WHEN "help"
#           CALL cl_show_help()
#        WHEN "exit"
#           EXIT WHILE
#        WHEN "controlg"
#           CALL cl_cmdask()
#         WHEN "related_document"  #No.MOD-470515
#           IF cl_chk_act_auth() AND l_ac != 0 THEN   # FUN-570200
#              IF g_atm[l_ac].atm01 IS NOT NULL THEN
#                 LET g_doc.column1 = "atm00"
#                 LET g_doc.value1 = g_atm[l_ac].atm00
#                 LET g_doc.column2 = "atm01"
#                 LET g_doc.value2 = g_atm[l_ac].atm01
#                 CALL cl_doc()
#              END IF
#           END IF
#        WHEN "exporttoexcel"   #No.FUN-4B0010
#           IF cl_chk_act_auth() THEN
#             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_atm),'','')
#           END IF
#
#     END CASE
#  END WHILE
#
#END FUNCTION
 
#FUNCTION i920_q()
 
#   CALL i920_b_askkey()
 
#END FUNCTION
 
#FUNCTION i920_b()
#DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680098 SMALLINT
#      l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680098 SMALLINT
#      l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680098 VARCHAR(1)
#      p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680098 VARCHAR(1)
#      l_possible      LIKE type_file.num5,                #用來設定判斷重複的可能性    #No.FUN-680098   SMALLINT  
#      l_allow_insert  LIKE type_file.chr1,                #可新增否                    #No.FUN-680098   VARCHAR(1) 
#      l_allow_delete  LIKE type_file.chr1                 #可刪除否                    #No.FUN-680098   VARCHAR(1) 
#
#  IF s_shut(0) THEN RETURN END IF
#
#  LET l_allow_insert = cl_detail_input_auth('insert')
#  LET l_allow_delete = cl_detail_input_auth('delete')
#  CALL cl_opmsg('b')
#
#  LET g_forupd_sql = " SELECT atm00,atm01,atm02,atm03 ",
#                     "   FROM atm_file ",
#                     "   WHERE atm00 = ? ", 
#                     "    AND atm01 = ? FOR UPDATE "
#  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#  DECLARE i920_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#  INPUT ARRAY g_atm WITHOUT DEFAULTS FROM s_atm.*
#     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
#
#     BEFORE INPUT
#        LET g_action_choice = ""
#        IF g_rec_b!=0 THEN
#           CALL fgl_set_arr_curr(l_ac)
#        END IF
#
#     BEFORE ROW
#        LET p_cmd=''
#        LET l_ac = ARR_CURR()
#        LET l_lock_sw = 'N'            #DEFAULT
#        LET l_n  = ARR_COUNT()
#
#        IF g_rec_b >= l_ac THEN
#No.FUN-570108 --start--                                                        
#           LET p_cmd='u'
#           LET  g_before_input_done = FALSE                                        
#           CALL i920_set_entry(p_cmd)                                              
#           CALL i920_set_no_entry(p_cmd)                                           
#           LET  g_before_input_done = TRUE                                         
#No.FUN-570108 --end--             
#           BEGIN WORK
#           LET p_cmd='u'
#           LET g_atm_t.* = g_atm[l_ac].*  #BACKUP
#           OPEN i920_bcl USING g_atm_t.atm00,g_atm_t.atm01
#           IF STATUS THEN
#              CALL cl_err("OPEN i920_bcl:", STATUS, 1)
#              LET l_lock_sw = "Y"
#           ELSE 
#              FETCH i920_bcl INTO g_atm[l_ac].* 
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_atm_t.atm00,SQLCA.sqlcode,1)
#                 LET l_lock_sw = "Y"
#              END IF
#           END IF  
#           CALL cl_show_fld_cont()     #FUN-550037(smin)
#        END IF
#
#     BEFORE INSERT
#        LET l_n = ARR_COUNT()
#        LET p_cmd='a'
#No.FUN-570108 --start--                                                        
#        LET  g_before_input_done = FALSE                                        
#        CALL i920_set_entry(p_cmd)                                              
#        CALL i920_set_no_entry(p_cmd)                                           
#        LET  g_before_input_done = TRUE                                         
#No.FUN-570108 --end--          
#        INITIALIZE g_atm[l_ac].* TO NULL      #900423
#        LET g_atm[l_ac].atm00 = 'N'           #default
#        LET g_atm_t.* = g_atm[l_ac].*         #新輸入資料
#        CALL cl_show_fld_cont()     #FUN-550037(smin)
#        NEXT FIELD atm00
#
#     AFTER FIELD atm00                        #check 編號是否重複
#        IF NOT cl_null(g_atm[l_ac].atm00) THEN 
#           IF g_atm[l_ac].atm00 NOT MATCHES '[YN]' THEN 
#              NEXT FIELD atm00
#           END IF
#        END IF
#        IF NOT cl_null(g_atm[l_ac].atm01) THEN
#           IF g_atm[l_ac].atm00 != g_atm_t.atm00 THEN
#              SELECT count(*) INTO l_n FROM atm_file
#               WHERE atm00 = g_atm[l_ac].atm00
#                 AND atm01 = g_atm[l_ac].atm01
#              IF l_n > 0 THEN
#                 CALL cl_err('',-239,0)
#                 LET g_atm[l_ac].atm00 = g_atm_t.atm00
#                 LET g_atm[l_ac].atm01 = g_atm_t.atm01
#                 NEXT FIELD atm00
#              END IF
#           END IF
#        END IF
#
#
#     AFTER FIELD atm01                        #check 編號是否重複
#        IF NOT cl_null(g_atm[l_ac].atm01) THEN
#           IF g_atm[l_ac].atm01 != g_atm_t.atm01 OR
#              (g_atm[l_ac].atm01 IS NOT NULL AND g_atm_t.atm01 IS NULL) THEN
#              SELECT count(*) INTO l_n FROM atm_file
#               WHERE atm00 = g_atm[l_ac].atm00
#                 AND atm01 = g_atm[l_ac].atm01
#              IF l_n > 0 THEN
#                 CALL cl_err('',-239,0)
#                 LET g_atm[l_ac].atm00 = g_atm_t.atm00
#                 LET g_atm[l_ac].atm01 = g_atm_t.atm01
#                 NEXT FIELD atm00
#              END IF
#           END IF
#        END IF
#
#     BEFORE DELETE                            #是否取消單身
#        IF g_atm_t.atm01 IS NOT NULL AND g_atm_t.atm01 IS NOT NULL THEN
#           IF NOT cl_delete() THEN
#              CANCEL DELETE
#           END IF
#           INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
#           LET g_doc.column1 = "atm00"               #No.FUN-9B0098 10/02/24
#           LET g_doc.value1 = g_atm[l_ac].atm00      #No.FUN-9B0098 10/02/24
#           LET g_doc.column2 = "atm01"               #No.FUN-9B0098 10/02/24
#           LET g_doc.value2 = g_atm[l_ac].atm01      #No.FUN-9B0098 10/02/24
#           CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
#           IF l_lock_sw = "Y" THEN 
#              CALL cl_err("", -263, 1) 
#              CANCEL DELETE 
#           END IF 
#           DELETE FROM atm_file 
#            WHERE atm00 = g_atm_t.atm00 
#              AND atm01 = g_atm_t.atm01
#           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_atm_t.atm01,SQLCA.sqlcode,0)   #No.FUN-660123
#              CALL cl_err3("del","atm_file",g_atm_t.atm00,g_atm_t.atm01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
#              ROLLBACK WORK
#              CANCEL DELETE
#           END IF
#           LET g_rec_b=g_rec_b-1
#           DISPLAY g_rec_b TO FORMONLY.cn2  
#           COMMIT WORK
#        END IF
#
#     ON ROW CHANGE
#        IF INT_FLAG THEN                 #900423
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           LET g_atm[l_ac].* = g_atm_t.*
#           CLOSE i920_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        IF l_lock_sw = 'Y' THEN
#           CALL cl_err(g_atm[l_ac].atm01,-263,1)
#           LET g_atm[l_ac].* = g_atm_t.*
#        ELSE
#           UPDATE atm_file SET atm00 = g_atm[l_ac].atm00, 
#                               atm01 = g_atm[l_ac].atm01,
#                               atm02 = g_atm[l_ac].atm02, 
#                               atm03 = g_atm[l_ac].atm03
#            WHERE atm00 = g_atm_t.atm00
#              AND atm01 = g_atm_t.atm01
#           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_atm[l_ac].atm01,SQLCA.sqlcode,0)   #No.FUN-660123
#              CALL cl_err3("upd","atm_file",g_atm_t.atm00,g_atm_t.atm01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
#              LET g_atm[l_ac].* = g_atm_t.*
#              ROLLBACK WORK
#           ELSE
#              MESSAGE 'UPDATE O.K'
#              COMMIT WORK
#           END IF
#        END IF
#
#     AFTER ROW
#        LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac  
#
#        IF INT_FLAG THEN                 #900423
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           IF p_cmd='u' THEN
#              LET g_atm[l_ac].* = g_atm_t.*
#           END IF
#           CLOSE i920_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#
#        CLOSE i920_bcl
#        COMMIT WORK
#
#     AFTER INSERT
#        IF INT_FLAG THEN                 #900423
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           CLOSE i920_bcl
#           CALL g_atm.deleteElement(l_ac)
#           IF g_rec_b != 0 THEN
#              LET g_action_choice = "detail"
#              LET l_ac = l_ac_t
#           END IF
#           EXIT INPUT
#        END IF
#
#        INSERT INTO atm_file(atm00,atm01,atm02,atm03)
#                      VALUES(g_atm[l_ac].atm00,g_atm[l_ac].atm01,
#                             g_atm[l_ac].atm02,g_atm[l_ac].atm03)
#         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_atm[l_ac].atm01,SQLCA.sqlcode,0)   #No.FUN-660123
#            CALL cl_err3("ins","atm_file",g_atm[l_ac].atm00,g_atm[l_ac].atm01,SQLCA.sqlcode,"","",1)  #No.FUN-660123
#            LET g_atm[l_ac].* = g_atm_t.*
#         ELSE
#            MESSAGE 'INSERT O.K'
#            LET g_rec_b = g_rec_b + 1
#            DISPLAY g_rec_b TO FORMONLY.cn2  
#         END IF
#
#     ON ACTION CONTROLO                        #沿用所有欄位
#        IF INFIELD(atm00) AND l_ac > 1 THEN
#           LET g_atm[l_ac].* = g_atm[l_ac-1].*
#           NEXT FIELD atm00
#        END IF
#
#     ON ACTION CONTROLZ
#        CALL cl_show_req_fields()
#
#     ON ACTION CONTROLG
#        CALL cl_cmdask()
#
#     ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#       
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#     
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#
#  END INPUT
#
#  CLOSE i920_bcl
#  COMMIT WORK 
#
#END FUNCTION
 
#FUNCTION i920_b_askkey()
#
#  CLEAR FORM
#  CALL g_atm.clear()
#
#  CONSTRUCT g_wc2 ON atm00,atm01,atm02,atm03
#       FROM s_atm[1].atm00,s_atm[1].atm01,s_atm[1].atm02,s_atm[1].atm03 
#
#             #No.FUN-580031 --start--     HCN
#             BEFORE CONSTRUCT
#                CALL cl_qbe_init()
#             #No.FUN-580031 --end--       HCN
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
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
#       	#No.FUN-580031 --start--     HCN
#                ON ACTION qbe_select
#        	   CALL cl_qbe_select() 
#                ON ACTION qbe_save
#       	   CALL cl_qbe_save()
#       	#No.FUN-580031 --end--       HCN
#  END CONSTRUCT
#  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#
#No.TQC-710076 -- beatk --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN 
#   END IF
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     LET g_wc2 = NULL
#     RETURN
#  END IF
#No.TQC-710076 -- end --
#
#  CALL i920_b_fill(g_wc2)
#
#END FUNCTION
 
#FUNCTION i920_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2     LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(200)
#
#  LET g_sql = "SELECT atm00,atm01,atm02,atm03",
#              "  FROM atm_file",
#              " WHERE ", p_wc2 CLIPPED,                     #單身
#              " ORDER BY 2"
#  PREPARE i920_pb FROM g_sql
#  DECLARE atm_curs CURSOR FOR i920_pb
#
#  CALL g_atm.clear()
#  LET g_cnt = 1
#  MESSAGE "Searching!" 
#
#  FOREACH atm_curs INTO g_atm[g_cnt].*   #單身 ARRAY 填充
#     IF STATUS THEN
#        CALL cl_err('foreach:',STATUS,1)
#        EXIT FOREACH
#     END IF
#
#     LET g_cnt = g_cnt + 1
#
#     IF g_cnt > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF
#
#  END FOREACH
#
#  CALL g_atm.deleteElement(g_cnt)
#  MESSAGE ""
#  LET g_rec_b = g_cnt-1
#  DISPLAY g_rec_b TO FORMONLY.cn2  
#  LET g_cnt = 0
#
#END FUNCTION
 
#FUNCTION i920_bp(p_ud)
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
#
#
#  IF p_ud <> "G" OR g_action_choice = "detail" THEN
#     RETURN
#  END IF
#
#  LET g_action_choice = " "
#
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_atm TO s_atm.* ATTRIBUTE(COUNT=g_rec_b)
#
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION controlg 
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
#
#     ON ACTION cancel
#            LET INT_FLAG=FALSE 		#MOD-570244	mars
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
#  
#@    ON ACTION 相關文件  
#      ON ACTION related_document  #No.MOD-470515
#        LET g_action_choice="related_document"
#        EXIT DISPLAY
#
#     ON ACTION exporttoexcel   #No.FUN-4B0010
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
#
#     # No.FUN-530067 --start--
#     AFTER DISPLAY
#        CONTINUE DISPLAY
#     # No.FUN-530067 ---end---
#
#
#  END DISPLAY
#
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#
#END FUNCTION
 
#No.FUN-780037---Beatk
{
FUNCTION i920_out()
   DEFINE l_i             LIKE type_file.num5,      #No.FUN-680098 SMALLINT
          l_name          LIKE type_file.chr20,     # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
          l_atm   RECORD LIKE atm_file.*,
          l_chr           LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)
 
   IF g_wc2 IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
   CALL cl_outnam('ggli504') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   
   LET g_sql="SELECT * FROM atm_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc2 CLIPPED,
             " ORDER BY atm01 "
   PREPARE i920_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i920_co CURSOR FOR i920_p1
 
   START REPORT i920_rep TO l_name
 
   FOREACH i920_co INTO l_atm.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
 
      OUTPUT TO REPORT i920_rep(l_atm.*)
 
   END FOREACH
 
   FINISH REPORT i920_rep
 
   CLOSE i920_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
REPORT i920_rep(sr)
   DEFINE l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680098    VARCHAR(1)
          sr RECORD       LIKE atm_file.*,
          l_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_maratk
      LEFT MARGIN g_left_maratk
      BOTTOM MARGIN g_bottom_maratk
      PAGE LENGTH g_page_line
 
   ORDER BY sr.atm01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT 
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34]
         PRINT g_dash1 
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.atm00 CLIPPED,
               COLUMN g_c[32],sr.atm01 USING '###&', #FUN-590118
               COLUMN g_c[33],sr.atm02 CLIPPED,
               COLUMN g_c[34],sr.atm03 USING '###,###,###,##&.&&'
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc2,'atm00,atm01,atm02,atm03') RETURNING g_sql
            PRINT g_dash[1,g_len]
 
          #TQC-630166
         #  IF g_sql[001,080] > ' ' THEN
         #     PRINT COLUMN g_c[31],g_x[8] CLIPPED,
         #           COLUMN g_c[32],g_sql[001,070] CLIPPED
         #  END IF
         #  IF g_sql[071,140] > ' ' THEN
         #     PRINT COLUMN g_c[32],g_sql[071,140] CLIPPED 
         #  END IF
         #  IF g_sql[141,210] > ' ' THEN
         #     PRINT COLUMN g_c[32],g_sql[141,210] CLIPPED
         #  END IF
            CALL cl_prt_pos_wc(g_sql)
          #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-780037---End
#No.FUN-570108 --start--                                                        
                                                                                
#FUNCTION i920_set_entry(p_cmd)                                                  
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
#      CALL cl_set_comp_entry("atm00,atm01",TRUE)                                
#   END IF                                                                       
#END FUNCTION                                                                    
                                                                                
                                                                                
#FUNCTION i920_set_no_entry(p_cmd)                                               
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
#      CALL cl_set_comp_entry("atm00,atm01",FALSE)                               
#   END IF                                                                       
#END FUNCTION                                                                    
                                                                                
#No.FUN-570108 --end--           

#FUN-B80180   ---end     Mark

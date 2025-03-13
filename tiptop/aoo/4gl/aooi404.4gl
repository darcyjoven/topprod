# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aooi404.4gl
# Descriptions...: 年-編碼維護
# Date & Author..: No.FUN-810036 08/3/11 By Nicola
#No.MOD-840294重新過單
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.TQC-950117 09/05/19 By chenmoyan pk值是 gff01+gff02,      
#                  但程式從頭到尾都只有gff01,insert/update/delete全部因key值問題
# Modify.........: No.TQC-980261 09/09/09 By liuxqa 非負控管。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.MOD-840294重新過單
 
DEFINE 
     g_gff           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gff01       LIKE gff_file.gff01,
        gff02       LIKE gff_file.gff02,
        gff03       LIKE gff_file.gff03
                    END RECORD,
    g_gff_t         RECORD                 #程式變數 (舊值)
        gff01       LIKE gff_file.gff01,
        gff02       LIKE gff_file.gff02,
        gff03       LIKE gff_file.gff03
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
    g_account       LIKE type_file.num5      #No.FUN-680102 SMALLINT               #FUN-670032 會計維護
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110   #No.FUN-680102 SMALLINT
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE l_table           STRING            #No.FUN-760083
DEFINE g_str             STRING            #No.FUN-760083
 
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
      RETURNING g_time 
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW i404_w AT p_row,p_col WITH FORM "aoo/42f/aooi404"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
 
   CALL i404_b_fill(g_wc2)
 
   CALL i404_menu()
 
   CLOSE WINDOW i404_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間)
      RETURNING g_time 
 
END MAIN
 
FUNCTION i404_menu()
 
   WHILE TRUE
      CALL i404_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i404_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i404_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
           IF cl_chk_act_auth() AND l_ac != 0 THEN
              IF g_gff[l_ac].gff01 IS NOT NULL THEN
                 LET g_doc.column1 = "gff01"
                 LET g_doc.value1 = g_gff[l_ac].gff01
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gff),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i404_q()
 
   CALL i404_b_askkey()
 
END FUNCTION
 
FUNCTION i404_b()
   DEFINE l_ac_t          LIKE type_file.num5,
           l_n             LIKE type_file.num5,
           l_lock_sw       LIKE type_file.chr1,
           p_cmd           LIKE type_file.chr1,
           l_allow_insert  LIKE type_file.chr1,
           l_allow_delete  LIKE type_file.chr1,
           l_cnt           LIKE type_file.num10
 
   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT gff01,gff02,gff03",
#                     "  FROM gff_file WHERE gff01=? FOR UPDATE"             #No.TQC-950117
                      "  FROM gff_file WHERE gff01=? AND gff02=? FOR UPDATE" #No.TQC-950117
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i404_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gff WITHOUT DEFAULTS FROM s_gff.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gff_t.* = g_gff[l_ac].*  #BACKUP
#           OPEN i404_bcl USING g_gff_t.gff01               #No.TQC-950117        
            OPEN i404_bcl USING g_gff_t.gff01,g_gff_t.gff02 #No.TQC-950117
            IF STATUS THEN
               CALL cl_err("OPEN i404_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i404_bcl INTO g_gff[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gff_t.gff01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gff[l_ac].* TO NULL
         LET g_gff_t.* = g_gff[l_ac].* 
         CALL cl_show_fld_cont() 
         NEXT FIELD gff01
      
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i404_bcl
            CANCEL INSERT
         END IF
      
         BEGIN WORK  
      
         INSERT INTO gff_file(gff01,gff02,gff03)
                       VALUES(g_gff[l_ac].gff01,g_gff[l_ac].gff02,
                              g_gff[l_ac].gff03)
         IF SQLCA.sqlcode THEN 
#           CALL cl_err3("ins","gff_file",g_gff[l_ac].gff01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131 #No.TQC-950117
            CALL cl_err3("ins","gff_file",g_gff[l_ac].gff01,g_gff[l_ac].gff02,SQLCA.sqlcode,"","",1)  #No.TQC-950117
            CANCEL INSERT
         ELSE
            COMMIT WORK
         END IF
 
#No.TQC-980261 add --begin
      AFTER FIELD gff01
         IF NOT cl_null(g_gff[l_ac].gff01) THEN
            IF g_gff[l_ac].gff01 < 0 THEN
               CALL cl_err(g_gff[l_ac].gff01,'amm-110',0)
               NEXT FIELD gff01
            END IF
         END IF
#No.TQC-980261 add --end
 
      AFTER FIELD gff03
         IF NOT cl_null(g_gff[l_ac].gff03) THEN
            LET g_gff[l_ac].gff02 = LENGTH(g_gff[l_ac].gff03)
            DISPLAY BY NAME g_gff[l_ac].gff02
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_rec_b>=l_ac THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "gff01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_gff[l_ac].gff01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
#           DELETE FROM gff_file WHERE gff01 = g_gff_t.gff01                           #No.TQC-950117
            DELETE FROM gff_file WHERE gff01 = g_gff_t.gff01 AND gff02 = g_gff_t.gff02 #No.TQC-950117
            IF SQLCA.sqlcode THEN
#              CALL cl_err3("del","gff_file",g_gff_t.gff01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131 #No.TQC-950117
               CALL cl_err3("del","gff_file",g_gff_t.gff01,g_gff_t.gff02,SQLCA.sqlcode,"","",1)      #No.TQC-950117
               EXIT INPUT
            END IF
         ELSE
           ROLLBACK WORK
           EXIT INPUT 
         END IF 
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gff[l_ac].* = g_gff_t.*
            CLOSE i404_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_gff[l_ac].gff01,-263,0)
            LET g_gff[l_ac].* = g_gff_t.*
         ELSE
            UPDATE gff_file SET gff01=g_gff[l_ac].gff01,
                                gff02=g_gff[l_ac].gff02,
                                gff03=g_gff[l_ac].gff03
#            WHERE gff01 = g_gff_t.gff01                           #No.TQC-950117
             WHERE gff01 = g_gff_t.gff01 AND gff02 = g_gff_t.gff02 #No.TQC-950117
            IF SQLCA.sqlcode THEN
#              CALL cl_err3("upd","gff_file",g_gff[l_ac].gff01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131#No.TQC-950117
               CALL cl_err3("upd","gff_file",g_gff[l_ac].gff01,g_gff[l_ac].gff02,SQLCA.sqlcode,"","",1)  #No.TQC-950117
               LET g_gff[l_ac].* = g_gff_t.*
            END IF
         END IF
      
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
         #LET l_ac_t = l_ac            # 新增  #FUN-D40030
      
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gff[l_ac].* = g_gff_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_gff.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE i404_bcl
            ROLLBACK WORK 
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D40030
         CLOSE i404_bcl            # 新增
         COMMIT WORK
      
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gff01) AND l_ac > 1 THEN
            LET g_gff[l_ac].* = g_gff[l_ac-1].*
            NEXT FIELD gff01
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
 
      ON ACTION about   
         CALL cl_about()
      
      ON ACTION help    
         CALL cl_show_help()
    
   END INPUT
 
   CLOSE i404_bcl
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i404_b_askkey()
 
   CLEAR FORM
 
   CALL g_gff.clear()
 
   CONSTRUCT g_wc2 ON gff01,gff02,gff03
        FROM s_gff[1].gff01,s_gff[1].gff02,s_gff[1].gff03
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
      ON ACTION qbe_select
         CALL cl_qbe_select() 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i404_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i404_b_fill(p_wc2)
#   DEFINE p_wc2   LIKE type_file.chr1000 
   DEFINE p_wc2   STRING     #NO.FUN-910082
 
   LET g_sql = "SELECT gff01,gff02,gff03",
               "  FROM gff_file",
               " WHERE ", p_wc2 CLIPPED, 
               " ORDER BY gff01"
 
   PREPARE i404_pb FROM g_sql
 
   DECLARE gff_curs CURSOR FOR i404_pb
 
   CALL g_gff.clear()
 
   LET g_cnt = 1
 
   MESSAGE "Searching!" 
 
   FOREACH gff_curs INTO g_gff[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH 
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_gff.deleteElement(g_cnt)
 
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
 
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i404_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gff TO s_gff.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE             #MOD-570244      mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 

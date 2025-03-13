# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: asri020.4gl
# Descriptions...: 工作站資料維護作業
# Date & Author..: 05/12/30 kim 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/30 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7B0103 07/11/26 BY jan 報表格式修改為p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_eca      RECORD LIKE eca_file.*,
     g_eca           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        eca01   LIKE eca_file.eca01,
        eca02   LIKE eca_file.eca02,
        eca03   LIKE eca_file.eca03,
        gem02   LIKE gem_file.gem02,
        eca06   LIKE eca_file.eca06,
        eca55   LIKE eca_file.eca55,
        ecaacti LIKE eca_file.ecaacti
                    END RECORD,
    g_eca_t         RECORD                 #程式變數 (舊值)
        eca01   LIKE eca_file.eca01,
        eca02   LIKE eca_file.eca02,
        eca03   LIKE eca_file.eca03,
        gem02   LIKE gem_file.gem02,
        eca06   LIKE eca_file.eca06,
        eca55   LIKE eca_file.eca55,
        ecaacti LIKE eca_file.ecaacti
                    END RECORD,
    g_wc2,g_sql    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(300)
    g_rec_b        LIKE type_file.num5,   #單身筆數    #No.FUN-680130 SMALLINT
    l_ac           LIKE type_file.num5    #目前處理的ARRAY CNT   #No.FUN-680130 SMALLINT
 
DEFINE g_forupd_sql  STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_cnt       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_i         LIKE type_file.num5    #count/index for any purpose        #No.FUN-680130 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680130 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8          #No.FUN-6B0014
DEFINE p_row,p_col LIKE type_file.num5                        #No.FUN-680130 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)   #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i020_w AT p_row,p_col WITH FORM "asr/42f/asri020"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i020_b_fill(g_wc2)
    CALL i020_menu()
    CLOSE WINDOW i020_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
END MAIN
 
FUNCTION i020_menu()
   DEFINE l_cmd  LIKE type_file.chr1000   #No.FUN-7B0103
 
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i020_q()                                          
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
              # CALL i020_out()                                          #No.FUN-7B0103
                   IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF         #No.FUN-7B0103                                               
                   LET l_cmd = 'p_query "asri020" "',g_wc2 CLIPPED,'"'   #No.FUN-7B0103                                              
                   CALL cl_cmdrun(l_cmd)                                 #No.FUN-7BO103                                               
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_eca[l_ac].eca01 IS NOT NULL THEN
                  LET g_doc.column1 = "eca01"
                  LET g_doc.value1 = g_eca[l_ac].eca01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_eca),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i020_q()
   CALL i020_b_askkey()
END FUNCTION
 
FUNCTION i020_b()
DEFINE
   l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680130 SMALLINT
   l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680130 SMALLINT
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680130 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680130 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,   #可新增否          #No.FUN-680130 VARCHAR(1)
   l_allow_delete  LIKE type_file.chr1    #可刪除否          #No.FUN-680130 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT *  FROM eca_file WHERE eca01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_eca WITHOUT DEFAULTS FROM s_eca.*
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
             LET g_before_input_done = FALSE                                    
             CALL i020_set_entry(p_cmd)                                         
             CALL i020_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
             LET g_eca_t.* = g_eca[l_ac].*  #BACKUP
             OPEN i020_bcl USING g_eca_t.eca01
             IF STATUS THEN
                CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i020_bcl INTO m_eca.* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_eca_t.eca01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                       
          CALL i020_set_entry(p_cmd)                                            
          CALL i020_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_eca[l_ac].* TO NULL   
          LET g_eca[l_ac].eca06='1'  
          LET g_eca[l_ac].ecaacti = 'Y'       #Body default
          LET g_eca_t.* = g_eca[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD eca01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i020_bcl
             CANCEL INSERT
          END IF
          INSERT INTO eca_file(eca01,eca02,eca03,eca06,eca55,ecaacti,ecamodu,ecadate,ecagrup,ecauser,eca04,ecaoriu,ecaorig)
          VALUES(g_eca[l_ac].eca01,g_eca[l_ac].eca02,g_eca[l_ac].eca03,g_eca[l_ac].eca06,
                 g_eca[l_ac].eca55,g_eca[l_ac].ecaacti,g_user,g_today,g_grup,g_user,'0', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_eca[l_ac].eca01,SQLCA.sqlcode,0)   #No.FUN-660138
             CALL cl_err3("ins","eca_file",g_eca[l_ac].eca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD eca01                        #check 編號是否重複
          IF NOT cl_null(g_eca[l_ac].eca01) THEN
             IF g_eca[l_ac].eca01 != g_eca_t.eca01 OR
                g_eca_t.eca01 IS NULL THEN
                SELECT count(*) INTO l_n FROM eca_file
                 WHERE eca01 = g_eca[l_ac].eca01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_eca[l_ac].eca01 = g_eca_t.eca01
                   NEXT FIELD eca01
                END IF
             END IF
          ELSE
             NEXT FIELD eca01
          END IF
 
       AFTER FIELD eca03
          IF cl_null(g_eca[l_ac].eca03) THEN
            NEXT FIELD eca03
          ELSE
            IF g_eca[l_ac].eca03!=g_eca_t.eca03 OR g_eca_t.eca03 IS NULL THEN
              LET l_n=0
              SELECT count(*) INTO l_n FROM gem_file
               WHERE gem01 = g_eca[l_ac].eca03
              IF l_n = 0 THEN
                 CALL cl_err('',100,0)
                 LET g_eca[l_ac].eca03 = g_eca_t.eca03
                 NEXT FIELD eca03
              END IF
              LET g_eca[l_ac].gem02=''
              SELECT gem02 INTO g_eca[l_ac].gem02 FROM gem_file WHERE gem01=g_eca[l_ac].eca03
              DISPLAY BY NAME g_eca[l_ac].gem02
            END IF
          END IF
 
       AFTER FIELD eca55
           IF g_eca[l_ac].eca55 IS NULL THEN
              LET g_eca[l_ac].eca55 = '0'
              DISPLAY BY NAME g_eca[l_ac].eca55
           ELSE
              IF g_eca[l_ac].eca55 != '0'  AND
                 (g_eca_t.eca55 IS NULL OR
                  g_eca_t.eca55 != g_eca[l_ac].eca55) THEN
                 SELECT UNIQUE ecn01 FROM ecn_file
                        WHERE ecn01 = g_eca[l_ac].eca55
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca[l_ac].eca55,'mfg4121',0)   #No.FUN-660138
                    CALL cl_err3("sel","ecn_file",g_eca[l_ac].eca55,"","mfg4121","","",1)  #No.FUN-660138
                    LET g_eca[l_ac].eca55 = g_eca_t.eca55
                    DISPLAY BY NAME g_eca[l_ac].eca55
                    NEXT FIELD eca55
                 END IF
              END IF
           END IF
           LET g_eca_t.eca55 = g_eca[l_ac].eca55
 
       AFTER FIELD ecaacti
          IF NOT cl_null(g_eca[l_ac].ecaacti) THEN
             IF g_eca[l_ac].ecaacti NOT MATCHES '[YN]' THEN 
                LET g_eca[l_ac].ecaacti = g_eca_t.ecaacti
                NEXT FIELD ecaacti
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_eca_t.eca01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "eca01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_eca[l_ac].eca01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM eca_file WHERE eca01 = g_eca_t.eca01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_eca_t.eca01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("del","eca_file",g_eca_t.eca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_eca[l_ac].* = g_eca_t.*
             CLOSE i020_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_eca[l_ac].eca01,-263,0)
             LET g_eca[l_ac].* = g_eca_t.*
          ELSE
             UPDATE eca_file SET eca01=g_eca[l_ac].eca01,
                                 eca02=g_eca[l_ac].eca02,
                                 eca03=g_eca[l_ac].eca03,
                                 eca06=g_eca[l_ac].eca06,
                                 eca55=g_eca[l_ac].eca55,
                                 ecaacti=g_eca[l_ac].ecaacti,
                                 ecamodu=g_user,
                                 ecadate=g_today,
                                 ecagrup=g_grup
              WHERE eca01 = g_eca_t.eca01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_eca[l_ac].eca01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("upd","eca_file",g_eca[l_ac].eca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
                LET g_eca[l_ac].* = g_eca_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
#         LET l_ac_t = l_ac                # 新增    #FUN-D40030 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_eca[l_ac].* = g_eca_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_eca.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF
             CLOSE i020_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac              #FUN-D40030 add 
          CLOSE i020_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(eca01) AND l_ac > 1 THEN
             LET g_eca[l_ac].* = g_eca[l_ac-1].*
             NEXT FIELD eca01
          END IF
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(eca03) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_eca[l_ac].eca03
                 DISPLAY BY NAME g_eca[l_ac].eca03
                 NEXT FIELD eca03
             WHEN INFIELD(eca55)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecn"
                 CALL cl_create_qry() RETURNING g_eca[l_ac].eca55
                 DISPLAY BY NAME g_eca[l_ac].eca55
                 NEXT FIELD eca55
              OTHERWISE EXIT CASE
           END CASE
 
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
 
       
   END INPUT
 
   CLOSE i020_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i020_b_askkey()
 
   CLEAR FORM
   CALL g_eca.clear()
   CONSTRUCT g_wc2 ON eca01,eca02,eca03,eca06,eca55,ecaacti
        FROM s_eca[1].eca01,s_eca[1].eca02,s_eca[1].eca03,
             s_eca[1].eca06,s_eca[1].eca55,s_eca[1].ecaacti
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP     #查詢條件
          CASE
             WHEN INFIELD(eca01)
                CALL q_eca(TRUE,TRUE,g_eca[l_ac].eca01) RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO eca01
                NEXT FIELD eca01
             WHEN INFIELD(eca03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_eca[1].eca03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO eca03
               NEXT FIELD eca03
             WHEN INFIELD(eca55)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecn"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO eca55
                 NEXT FIELD eca55
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ecauser', 'ecagrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN 
#     LET INT_FLAG = 0 
#     RETURN 
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i020_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i020_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    LET g_sql =
        "SELECT eca01,eca02,eca03,'',eca06,eca55,ecaacti",
        " FROM eca_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY eca01"
    PREPARE i020_pb FROM g_sql
    DECLARE eca_curs CURSOR FOR i020_pb
 
    CALL g_eca.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH eca_curs INTO g_eca[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT 
        FOREACH END IF
        LET g_eca[g_cnt].gem02=''
        SELECT gem02 INTO g_eca[g_cnt].gem02 FROM gem_file 
          WHERE gem01=g_eca[g_cnt].eca03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_eca.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_eca TO s_eca.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
      # Specaal 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
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
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-7B0103--BEGIN
{
FUNCTION i020_out()
    DEFINE
        l_eca           RECORD 
                        eca01 LIKE eca_file.eca01, 
                        eca02 LIKE eca_file.eca02, 
                        eca03 LIKE eca_file.eca03, 
                        gem02 LIKE gem_file.gem02, 
                        eca06 LIKE eca_file.eca06, 
                        eca55 LIKE eca_file.eca55, 
                        ecaacti LIKE eca_file.ecaacti
                        END RECORD,
        l_i             LIKE type_file.num5,   #No.FUN-680130 SMALLINT
        l_name          LIKE type_file.chr20,  # External(Disk) file name   #No.FUN-680130 VARCHAR(20)
        l_za05          LIKE za_file.za05  #No.FUN-680130 VARCHAR(40)
                        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT eca01,eca02,eca03,'',eca06,eca55,ecaacti FROM eca_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i020_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i020_co                         # SCROLL CURSOR
         CURSOR FOR i020_p1
 
    CALL cl_outnam('asri020') RETURNING l_name
    START REPORT i020_rep TO l_name
 
    FOREACH i020_co INTO l_eca.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
        END IF
        LET l_eca.gem02=''
        SELECT gem02 INTO l_eca.gem02 FROM gem_file 
          WHERE gem01=l_eca.eca03
        OUTPUT TO REPORT i020_rep(l_eca.*)
    END FOREACH
 
    FINISH REPORT i020_rep
 
    CLOSE i020_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i020_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
        l_chr           LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
        sr              RECORD 
                        eca01 LIKE eca_file.eca01, 
                        eca02 LIKE eca_file.eca02, 
                        eca03 LIKE eca_file.eca03, 
                        gem02 LIKE gem_file.gem02, 
                        eca06 LIKE eca_file.eca06, 
                        eca55 LIKE eca_file.eca55, 
                        ecaacti LIKE eca_file.ecaacti
                        END RECORD
        
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.eca01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.eca01,
                  COLUMN g_c[32],sr.eca02,
                  COLUMN g_c[33],sr.eca03,
                  COLUMN g_c[34],sr.gem02,
                  COLUMN g_c[35],sr.eca06,
                  COLUMN g_c[36],sr.eca55,
                  COLUMN g_c[37],sr.ecaacti
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-7B0103--END
                                                    
FUNCTION i020_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("eca01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i020_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("eca01",FALSE)
   END IF                                                                       
END FUNCTION

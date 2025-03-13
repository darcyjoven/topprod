# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: asri010.4gl
# Descriptions...: 機器(生產線)資料維護作業
# Date & Author..: 05/12/28 kim 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/30 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7B0103 07/11/22 By jan 報表格式修改為p_query
# Modify.........: No.MOD-890198 08/09/23 By Pengu 查詢時"工作中心編號"開窗程式會擋掉
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_eci      RECORD LIKE eci_file.*,
     g_eci           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        eci01   LIKE eci_file.eci01,
        eci06   LIKE eci_file.eci06,
        eci03   LIKE eci_file.eci03,
        eca02   LIKE eca_file.eca02,
        eca06   LIKE eca_file.eca06,
        eci05   LIKE eci_file.eci05,
        eci09   LIKE eci_file.eci09,
        eciacti LIKE eci_file.eciacti
                    END RECORD,
    g_eci_t         RECORD                 #程式變數 (舊值)
        eci01   LIKE eci_file.eci01,
        eci06   LIKE eci_file.eci06,
        eci03   LIKE eci_file.eci03,
        eca02   LIKE eca_file.eca02,
        eca06   LIKE eca_file.eca06,
        eci05   LIKE eci_file.eci05,
        eci09   LIKE eci_file.eci09,
        eciacti LIKE eci_file.eciacti
                    END RECORD,
    g_wc2,g_sql    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(300)
    g_rec_b        LIKE type_file.num5,   #單身筆數        #No.FUN-680130 SMALLINT
    l_ac           LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680130 SMALLINT
 
DEFINE g_forupd_sql    STRING  #SELECT ... FOR UPDATE SQL  
DEFINE g_cnt           LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680130 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num10   #No.FUN-680130 INTEGER
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5   #No.FUN-680130 SMALLINT
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
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "asr/42f/asri010"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)
    CALL i010_menu()
    CLOSE WINDOW i010_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
END MAIN
 
FUNCTION i010_menu()
   DEFINE l_cmd  LIKE type_file.chr1000   #No.FUN-7B0103
 
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
              #CALL i010_out()                                       #No.FUN-7B0103
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF         #No.FUN-7B0103                                             
               LET l_cmd = 'p_query "asri010" "',g_wc2 CLIPPED,'"'   #No.FUN-7B0103                                             
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
               IF g_eci[l_ac].eci01 IS NOT NULL THEN
                  LET g_doc.column1 = "eci01"
                  LET g_doc.value1 = g_eci[l_ac].eci01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_eci),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION
 
FUNCTION i010_b()
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
 
   LET g_forupd_sql = "SELECT *  FROM eci_file WHERE eci01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_eci WITHOUT DEFAULTS FROM s_eci.*
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
             CALL i010_set_entry(p_cmd)                                         
             CALL i010_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
             LET g_eci_t.* = g_eci[l_ac].*  #BACKUP
             OPEN i010_bcl USING g_eci_t.eci01
             IF STATUS THEN
                CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i010_bcl INTO m_eci.* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_eci_t.eci01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
             CALL i010_eca06_switch()
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                       
          CALL i010_set_entry(p_cmd)                                            
          CALL i010_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_eci[l_ac].* TO NULL     
          LET g_eci[l_ac].eciacti = 'Y'       #Body default
          LET g_eci[l_ac].eci05=0
          LET g_eci[l_ac].eci09=0
          LET g_eci_t.* = g_eci[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD eci01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i010_bcl
             CANCEL INSERT
          END IF
          INSERT INTO eci_file(eci01,eci06,eci03,eci05,eci09,eciacti,ecimodu,ecidate,ecigrup,ecioriu,eciorig)
          VALUES(g_eci[l_ac].eci01,g_eci[l_ac].eci06,g_eci[l_ac].eci03,g_eci[l_ac].eci05,
                 g_eci[l_ac].eci09,g_eci[l_ac].eciacti,g_user,g_today,g_grup, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_eci[l_ac].eci01,SQLCA.sqlcode,0)   #No.FUN-660138
             CALL cl_err3("ins","eci_file",g_eci[l_ac].eci01,g_eci[l_ac].eci06,SQLCA.sqlcode,"","",1)  #No.FUN-660138
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD eci01                        #check 編號是否重複
          IF NOT cl_null(g_eci[l_ac].eci01) THEN
             IF g_eci[l_ac].eci01 != g_eci_t.eci01 OR
                g_eci_t.eci01 IS NULL THEN
                SELECT count(*) INTO l_n FROM eci_file
                 WHERE eci01 = g_eci[l_ac].eci01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_eci[l_ac].eci01 = g_eci_t.eci01
                   NEXT FIELD eci01
                END IF
             END IF
          END IF
 
       AFTER FIELD eci03
          IF cl_null(g_eci[l_ac].eci03) THEN
            NEXT FIELD eci03
          ELSE
            IF g_eci[l_ac].eci03!=g_eci_t.eci03 OR g_eci_t.eci03 IS NULL THEN
              CALL i010_eci03('a')
              IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                LET g_eci[l_ac].eci03=g_eci_t.eci03
                NEXT FIELD eci03
              END IF
              LET g_eci[l_ac].eca02=''
              LET g_eci[l_ac].eca06=''
              SELECT eca02,eca06 INTO g_eci[l_ac].eca02,g_eci[l_ac].eca06 FROM eca_file 
                WHERE eca01=g_eci[l_ac].eci03
              LET g_eci[l_ac].eci05=0
              LET g_eci[l_ac].eci09=0
              DISPLAY BY NAME g_eci[l_ac].eca02
              DISPLAY BY NAME g_eci[l_ac].eca06
              DISPLAY BY NAME g_eci[l_ac].eci05
              DISPLAY BY NAME g_eci[l_ac].eci09
            END IF
            CALL i010_eca06_switch()
          END IF
 
       AFTER FIELD eciacti
          IF NOT cl_null(g_eci[l_ac].eciacti) THEN
             IF g_eci[l_ac].eciacti NOT MATCHES '[YN]' THEN 
                LET g_eci[l_ac].eciacti = g_eci_t.eciacti
                NEXT FIELD eciacti
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_eci_t.eci01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "eci01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_eci[l_ac].eci01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM eci_file WHERE eci01 = g_eci_t.eci01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_eci_t.eci01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("del","eci_file",g_eci_t.eci01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
             LET g_eci[l_ac].* = g_eci_t.*
             CLOSE i010_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_eci[l_ac].eci01,-263,0)
             LET g_eci[l_ac].* = g_eci_t.*
          ELSE
             UPDATE eci_file SET eci01=g_eci[l_ac].eci01,
                                 eci06=g_eci[l_ac].eci06,
                                 eci03=g_eci[l_ac].eci03,
                                 eci05=g_eci[l_ac].eci05,
                                 eci09=g_eci[l_ac].eci09,
                                 eciacti=g_eci[l_ac].eciacti,
                                 ecimodu=g_user,
                                 ecidate=g_today,
                                 ecigrup=g_grup
              WHERE eci01 = g_eci_t.eci01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_eci[l_ac].eci01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("upd","eci_file",g_eci_t.eci01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
                LET g_eci[l_ac].* = g_eci_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
#         LET l_ac_t = l_ac                # 新增          #FUN-D40030 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_eci[l_ac].* = g_eci_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_eci.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF
             CLOSE i010_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac         #FUN-D40030 add 
          CLOSE i010_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(eci01) AND l_ac > 1 THEN
             LET g_eci[l_ac].* = g_eci[l_ac-1].*
             NEXT FIELD eci01
          END IF
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(eci03) #工作區編號
                 CALL q_eca(FALSE,TRUE,g_eci[l_ac].eci03) RETURNING g_eci[l_ac].eci03
                 DISPLAY BY NAME g_eci[l_ac].eci03
                 NEXT FIELD eci03
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
 
   CLOSE i010_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i010_b_askkey()
 
   CLEAR FORM
   CALL g_eci.clear()
   CONSTRUCT g_wc2 ON eci01,eci06,eci03,eci05,eci09,eciacti   #eca02,eca06,
        FROM s_eci[1].eci01,s_eci[1].eci06,s_eci[1].eci03, #s_eci[1].eca02,
             s_eci[1].eci05,s_eci[1].eci09,s_eci[1].eciacti #s_eci[1].eca06,
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP     #查詢條件
          CASE
             WHEN INFIELD(eci01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_eci"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_eci[1].eci01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO eci01
               NEXT FIELD eci01
             WHEN INFIELD(eci03)
               #------------No.MOD-890198 modify
               #CALL q_eca(TRUE,TRUE,g_eci[l_ac].eci03) RETURNING g_qryparam.multiret
                CALL q_eca(TRUE,TRUE,g_eci[1].eci03) RETURNING g_qryparam.multiret
               #------------No.MOD-890198 end
                DISPLAY g_qryparam.multiret TO eci03
                NEXT FIELD eci03
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('eciuser', 'ecigrup') #FUN-980030
 
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
 
   CALL i010_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    LET g_sql =
        "SELECT eci01,eci06,eci03,'','',eci05,eci09,eciacti",
        " FROM eci_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY eci01"
    PREPARE i010_pb FROM g_sql
    DECLARE eci_curs CURSOR FOR i010_pb
 
    CALL g_eci.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH eci_curs INTO g_eci[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT 
        FOREACH END IF
        LET g_eci[g_cnt].eca02=''
        LET g_eci[g_cnt].eca06=''
        SELECT eca02,eca06 INTO g_eci[g_cnt].eca02,g_eci[g_cnt].eca06 FROM eca_file 
          WHERE eca01=g_eci[g_cnt].eci03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_eci.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_eci TO s_eci.* ATTRIBUTE(COUNT=g_rec_b)
 
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
FUNCTION i010_out()
    DEFINE
        l_eci           RECORD 
                        eci01   LIKE eci_file.eci01, 
                        eci06   LIKE eci_file.eci06, 
                        eci03   LIKE eci_file.eci03, 
                        eca02   LIKE eca_file.eca02, 
                        eca06   LIKE eca_file.eca06, 
                        eci05   LIKE eci_file.eci05, 
                        eci09   LIKE eci_file.eci09, 
                        eciacti LIKE eci_file.eciacti
                        END RECORD,
        l_i             LIKE type_file.num5,   #No.FUN-680130 SMALLINT
        l_name          LIKE type_file.chr20,  # External(Disk) file name   #No.FUN-680130 VARCHAR(20)
        l_za05          LIKE za_file.za05      #No.FUN-680130 VARCHAR(40)        
                        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT eci01,eci06,eci03,'','',eci05,eci09,eciacti FROM eci_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i010_co                         # SCROLL CURSOR
         CURSOR FOR i010_p1
 
   CALL cl_outnam('asri010') RETURNING l_name  
   START REPORT i010_rep TO l_name              
 
    FOREACH i010_co INTO l_eci.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
        END IF
        SELECT eca02,eca06 INTO l_eci.eca02,l_eci.eca06 FROM eca_file 
          WHERE eca01=l_eci.eci03
        OUTPUT TO REPORT i010_rep(l_eci.*)
    END FOREACH
   FINISH REPORT i010_rep
 
   CLOSE i010_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
 
 
REPORT i010_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,  #No.FUN-680130 VARCHAR(1)
        l_chr           LIKE type_file.chr1,  #No.FUN-680130 VARCHAR(1)
        sr              RECORD 
                        eci01   LIKE eci_file.eci01, 
                        eci06   LIKE eci_file.eci06, 
                        eci03   LIKE eci_file.eci03, 
                        eca02   LIKE eca_file.eca02, 
                        eca06   LIKE eca_file.eca06, 
                        eci05   LIKE eci_file.eci05, 
                        eci09   LIKE eci_file.eci09, 
                        eciacti LIKE eci_file.eciacti
                        END RECORD
        
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.eci01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.eci01,
                  COLUMN g_c[32],sr.eci06,
                  COLUMN g_c[33],sr.eci03,
                  COLUMN g_c[34],sr.eca02,
                  COLUMN g_c[35],sr.eca06,
                  COLUMN g_c[36],sr.eci05,
                  COLUMN g_c[37],sr.eci09,
                  COLUMN g_c[38],sr.eciacti
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
                                                    
FUNCTION i010_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("eci01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i010_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("eci01",FALSE)
   END IF                                                                       
   CALL cl_set_comp_entry("eci05,eci09",FALSE)
END FUNCTION
 
FUNCTION i010_eca06_switch()
   IF cl_null(g_eci[l_ac].eca06) THEN
     CALL cl_set_comp_entry("eci05,eci09",FALSE)
   END IF
   CALL cl_set_comp_entry("eci05",g_eci[l_ac].eca06='1')
   CALL cl_set_comp_entry("eci09",g_eci[l_ac].eca06='2')
END FUNCTION
 
FUNCTION i010_eci03(p_cmd)  #工作中心
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
         l_ecaacti   LIKE eca_file.ecaacti
 
  LET g_errno = ' '
  SELECT ecaacti INTO l_ecaacti
     FROM eca_file WHERE eca01 = g_eci[l_ac].eci03
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4011'
       WHEN l_ecaacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION

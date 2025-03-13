# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: asrt3002.4gl
# Descriptions...: 報工不良原因資料維護
# Date & Author..: 06/02/08 kim 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-7C0034 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0034 07/12/12 By lala    制作CR報表
# Modify.........: No.CHI-920069 09/02/20 By jan 修改時需檢查每一筆報工單單號(srg01)是否已確認,若維已確認則卡住不可修改
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0307 10/12/06 by jan sri03檢查邏輯調整
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_sri      RECORD LIKE sri_file.*,
     g_sri01    LIKE sri_file.sri01,
     g_sri           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sri01  LIKE sri_file.sri01 ,
        sri02  LIKE sri_file.sri02 ,
        sri03  LIKE sri_file.sri03 ,
        srg03  LIKE srg_file.srg03 ,
        ima02  LIKE ima_file.ima02 ,
        ima021 LIKE ima_file.ima021,
        sri04  LIKE sri_file.sri04 ,
        azf03  LIKE azf_file.azf03 ,
        sri05  LIKE sri_file.sri05 ,
        sri06  LIKE sri_file.sri06
                    END RECORD,
    g_sri_t         RECORD                 #程式變數 (舊值)
        sri01  LIKE sri_file.sri01 ,
        sri02  LIKE sri_file.sri02 ,
        sri03  LIKE sri_file.sri03 ,
        srg03  LIKE srg_file.srg03 ,
        ima02  LIKE ima_file.ima02 ,
        ima021 LIKE ima_file.ima021,
        sri04  LIKE sri_file.sri04 ,
        azf03  LIKE azf_file.azf03 ,
        sri05  LIKE sri_file.sri05 ,
        sri06  LIKE sri_file.sri06
                    END RECORD,
    g_wc2,g_sql    LIKE type_file.chr1000, #No.FUN-7C0034 VARCHAR(300)
    g_rec_b        LIKE type_file.num5,    #單身筆數  #No.FUN-7C0034 SMALLINT
    l_ac           LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-7C0034 SMALLINT
 
DEFINE g_argv1 LIKE sri_file.sri01
DEFINE g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt           LIKE type_file.num10    #No.FUN-7C0034 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-7C0034 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-7C0034 SMALLINT
DEFINE l_table         STRING
DEFINE g_str           STRING
DEFINE l_sql           STRING
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-7C0034 SMALLINT
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
    LET l_sql="sri01.sri_file.sri01,",                           
              "sri02.sri_file.sri02,",
              "sri03.sri_file.sri03,",
              "srg03.srg_file.srg03,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "sri04.sri_file.sri04,",
              "azf03.azf_file.azf05,",
              "sri05.sri_file.sri05,",
              "sri06.sri_file.sri06"
    LET l_table =cl_prt_temptable('asrt3002',l_sql) CLIPPED
    IF  l_table =-1 THEN EXIT PROGRAM END IF
    LET l_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM l_sql
    IF STATUS THEN
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM 
    END IF
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW t3002_w AT p_row,p_col WITH FORM "asr/42f/asrt3002"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
    
    LET g_argv1=ARG_VAL(1)
    
    IF cl_null(g_argv1) THEN
       LET g_sri01=''
       LET g_wc2 = '1=1'
     ELSE
       CALL cl_set_comp_visible("sri01",FALSE)
       LET g_sri01=g_argv1
       LET g_wc2 = "sri01='",g_sri01,"'"
     END IF  
    CALL t3002_b_fill(g_wc2)
    CALL t3002_menu()
    CLOSE WINDOW t3002_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
END MAIN
 
FUNCTION t3002_menu()
 
   WHILE TRUE
      CALL t3002_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF NOT cl_null(g_argv1) THEN
               LET g_action_choice = NULL
               EXIT CASE
            END IF
            IF cl_chk_act_auth() THEN
               CALL t3002_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t3002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t3002_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_sri[l_ac].sri01 IS NOT NULL THEN
                  LET g_doc.column1 = "sri01"
                  LET g_doc.value1 = g_sri[l_ac].sri01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sri),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t3002_q()
   CALL t3002_b_askkey()
END FUNCTION
 
FUNCTION t3002_b()
DEFINE
   l_ac_t,l_cnt    LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-7C0034 SMALLINT
   l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-7C0034 SMALLINT
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-7C0034 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-7C0034 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,   #可新增否          #No.FUN-7C0034 VARCHAR(1)
   l_allow_delete  LIKE type_file.chr1    #可刪除否          #No.FUN-7C0034 VARCHAR(1)
DEFINE l_srfconf   LIKE srf_file.srfconf     #CHI-920069 
DEFINE l_flag      LIKE type_file.chr1       #CHI-920069
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
   #CHI-920069--BEGIN--
   LET l_srfconf = NULL
   IF NOT cl_null(g_sri01) THEN 
      SELECT srfconf INTO l_srfconf
        FROM srf_file
       WHERE srf01 = g_sri01  
      IF l_srfconf = 'Y' THEN 
         CALL cl_err(g_sri01,'asr-052',0)
         RETURN 
      END IF
   END IF
   #CHI-920069--END-- 
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT *  FROM sri_file WHERE sri01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_sri WITHOUT DEFAULTS FROM s_sri.*
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
             #CALL t3002_set_entry(p_cmd)                                         
             #CALL t3002_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
             LET g_sri_t.* = g_sri[l_ac].*  #BACKUP
             OPEN t3002_bcl USING g_sri_t.sri01
             IF STATUS THEN
                CALL cl_err("OPEN t3002_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t3002_bcl INTO m_sri.* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_sri_t.sri01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                #CHI-920069--BEGIN-- 
               LET l_srfconf = NULL
               IF cl_null(g_sri01) THEN 
               SELECT srfconf INTO l_srfconf 
                 FROM srf_file 
                WHERE srf01 = m_sri.sri01 
               IF l_srfconf = 'Y' THEN
                  LET l_flag = 'Y'
                  CALL cl_set_comp_entry("sri02,sri03,sri04,sri05,sri06",FALSE) 
               ELSE
                  LET l_flag = 'N'
                  CALL cl_set_comp_entry("sri02,sri03,sri04,sri05,sri06",TRUE) 
               END IF 
               END IF
               #CHI-920069--END-- 
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                       
          LET g_before_input_done = TRUE                                        
          CALL cl_set_comp_entry("sri02,sri03,sri04,sri05,sri06",TRUE) #CHI-920069 
          INITIALIZE g_sri[l_ac].* TO NULL     
          LET g_sri_t.* = g_sri[l_ac].*         #新輸入資料
          IF NOT cl_null(g_sri01) THEN
             LET g_sri[l_ac].sri01=g_sri01
          END IF   
          CALL cl_show_fld_cont()
          IF cl_null(g_sri01) THEN
            NEXT FIELD sri01
          ELSE
            NEXT FIELD sri02
          END IF
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t3002_bcl
             CANCEL INSERT
          END IF
          INSERT INTO sri_file(sri01,sri02,sri03,sri04,sri05,sri06,
                               sriplant,srilegal) #FUN-980008 add
          VALUES(g_sri[l_ac].sri01,g_sri[l_ac].sri02,g_sri[l_ac].sri03,g_sri[l_ac].sri04,
                 g_sri[l_ac].sri05,g_sri[l_ac].sri06,
                 g_plant,g_legal)   #FUN-980008 add
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_sri[l_ac].sri02,SQLCA.sqlcode,0)   #No.FUN-660138
             CALL cl_err3("ins","sri_file",g_sri[l_ac].sri01,g_sri[l_ac].sri02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD sri01
          #CHI-920069--EBGIN--  
          IF l_flag = 'Y' THEN 
             IF g_sri[l_ac].sri01!=g_sri_t.sri01 THEN 
             CALL cl_err('','asr-052',0)
             LET g_sri[l_ac].sri01 = g_sri_t.sri01
             NEXT FIELD sri01
             END IF
           END IF
          #CHI-920069--END--
          IF (NOT cl_null(g_sri[l_ac].sri01)) AND (g_sri[l_ac].sri01!=g_sri_t.sri01 OR g_sri_t.sri01 IS NULL) THEN
             #CHI-920069--EBGIN-- 
             LET l_srfconf = NULL
             SELECT srfconf INTO l_srfconf 
               FROM srf_file 
              WHERE srf01 = g_sri[l_ac].sri01
             IF l_srfconf = 'Y' THEN
                CALL cl_err('','asr-052',0)  
                NEXT FIELD sri01
             END IF
             #CHI-920069--END--  
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM srf_file WHERE srf01=g_sri[l_ac].sri01
             IF l_cnt=0 THEN
                CALL cl_err('chk sri01',100,1)
                LET g_sri[l_ac].sri01=g_sri_t.sri01
                DISPLAY BY NAME g_sri[l_ac].sri01
                NEXT FIELD sri01
             END IF
          END IF
 
       BEFORE FIELD sri02
          IF cl_null(g_sri[l_ac].sri02) AND (g_sri_t.sri02 IS NULL) THEN
             SELECT MAX(sri02) INTO g_sri[l_ac].sri02 FROM sri_file WHERE sri01=g_sri[l_ac].sri01
             IF cl_null(g_sri[l_ac].sri02) THEN
                LET g_sri[l_ac].sri02=0
             END IF
             IF g_sma.sma19>0 THEN
                LET g_sri[l_ac].sri02=g_sri[l_ac].sri02+g_sma.sma19
             ELSE
                LET g_sri[l_ac].sri02=g_sri[l_ac].sri02++1   
             END IF   
             DISPLAY BY NAME g_sri[l_ac].sri02
          END IF
 
       AFTER FIELD sri03
          IF NOT cl_null(g_sri[l_ac].sri03) THEN
            IF g_sri[l_ac].sri03!=g_sri_t.sri03 OR g_sri_t.sri03 IS NULL THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM srg_file
                WHERE srg01=g_sri[l_ac].sri01
                  AND srg02=g_sri[l_ac].sri03
              IF l_cnt=0 THEN
                CALL cl_err('chk sri03',100,1)
                LET g_sri[l_ac].srg03=''
                LET g_sri[l_ac].ima02=''
                LET g_sri[l_ac].ima021=''
                DISPLAY BY NAME g_sri[l_ac].srg03,g_sri[l_ac].ima02,g_sri[l_ac].ima021
                NEXT FIELD sri03
              END IF
              #TQC-AB0307--begin--add-----    
              IF NOT cl_null(g_sri[l_ac].sri05) THEN 
                 IF NOT t3002_chk_sri05() THEN
                    LET g_sri[l_ac].sri03=g_sri_t.sri03
                    NEXT FIELD sri03
                 END IF
              END IF
              #TQC-AB0307--end--add-------
            END IF
            CALL t3002_set_srg03(g_sri[l_ac].sri01,g_sri[l_ac].sri03)
                 RETURNING g_sri[l_ac].srg03,g_sri[l_ac].ima02,g_sri[l_ac].ima021
            DISPLAY BY NAME g_sri[l_ac].srg03,g_sri[l_ac].ima02,g_sri[l_ac].ima021     
          ELSE
            LET g_sri[l_ac].srg03=''
            LET g_sri[l_ac].ima02=''
            LET g_sri[l_ac].ima021=''
            DISPLAY BY NAME g_sri[l_ac].srg03,g_sri[l_ac].ima02,g_sri[l_ac].ima021
          END IF
 
       AFTER FIELD sri04
          IF NOT cl_null(g_sri[l_ac].sri04) THEN
            IF g_sri[l_ac].sri04!=g_sri_t.sri04 OR g_sri_t.sri04 IS NULL THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM azf_file WHERE azf01=g_sri[l_ac].sri04
                                                         AND azf02='6'
              IF l_cnt=0 THEN
                 LET g_sri[l_ac].azf03=''
                 DISPLAY BY NAME g_sri[l_ac].azf03
                 CALL cl_err('chk azf',100,1)
                 NEXT FIELD sri04
              END IF
              CALL t3002_set_sri04(g_sri[l_ac].sri04) RETURNING g_sri[l_ac].azf03
              DISPLAY BY NAME g_sri[l_ac].azf03
            END IF 
          ELSE
             LET g_sri[l_ac].azf03=''
             DISPLAY BY NAME g_sri[l_ac].azf03
          END IF   
 
       AFTER FIELD sri05
          IF (NOT cl_null(g_sri[l_ac].sri05)) AND 
             ((g_sri[l_ac].sri05!=g_sri_t.sri05) OR 
              (g_sri_t.sri05 IS NULL)) THEN
             IF NOT t3002_chk_sri05() THEN
                LET g_sri[l_ac].sri05=g_sri_t.sri05
                NEXT FIELD sri05
             END IF
          END IF
          
       BEFORE DELETE                            #是否取消單身
          #CHI-920069--BEGIN--
          IF l_flag = 'Y' THEN
             CALL cl_err('','asr-052',0) 
             CANCEL DELETE
          END IF
         #CHI-920069--END--
          IF g_sri_t.sri02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "sri01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_sri[l_ac].sri01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM sri_file WHERE sri01 = g_sri[l_ac].sri01
                                    AND sri02 = g_sri[l_ac].sri02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_sri[l_ac].sri02,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("del","sri_file",g_sri[l_ac].sri01,g_sri[l_ac].sri02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
             LET g_sri[l_ac].* = g_sri_t.*
             CLOSE t3002_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_sri[l_ac].sri01,-263,0)
             LET g_sri[l_ac].* = g_sri_t.*
          ELSE
             UPDATE sri_file SET sri01=g_sri[l_ac].sri01,
                                 sri02=g_sri[l_ac].sri02,
                                 sri03=g_sri[l_ac].sri03,
                                 sri04=g_sri[l_ac].sri04,
                                 sri05=g_sri[l_ac].sri05,
                                 sri06=g_sri[l_ac].sri06
              WHERE sri01 = g_sri_t.sri01
                AND sri02 = g_sri_t.sri02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_sri[l_ac].sri01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("upd","sri_file",g_sri[l_ac].sri01,g_sri[l_ac].sri02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
                LET g_sri[l_ac].* = g_sri_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
#         LET l_ac_t = l_ac                # 新增     #FUN-D40030 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_sri[l_ac].* = g_sri_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_sri.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF
             CLOSE t3002_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac           #FUN-D40030 add 
          CLOSE t3002_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(sri02) AND l_ac > 1 THEN
             LET g_sri[l_ac].* = g_sri[l_ac-1].*
             NEXT FIELD sri02
          END IF
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(sri01) OR INFIELD(sri03)    #查詢報工單&項次
                 CALL cl_init_qry_var()
                 IF cl_null(g_argv1) THEN
                    LET g_qryparam.form = "q_srg01"
                 ELSE
                    LET g_qryparam.form = "q_srg02"
                    LET g_qryparam.arg1 = g_argv1
                 END IF   
                 CALL cl_create_qry() RETURNING g_sri[l_ac].sri01,g_sri[l_ac].sri03
                 DISPLAY BY NAME g_sri[l_ac].sri01,g_sri[l_ac].sri03
                 IF INFIELD(sri01) THEN
                    NEXT FIELD sri01
                 END IF   
                 IF INFIELD(sri03) THEN
                    NEXT FIELD sri03
                 END IF   
              WHEN INFIELD(sri04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf"
                  LET g_qryparam.arg1 = "6"
                  CALL cl_create_qry() RETURNING g_sri[l_ac].sri04
                  DISPLAY BY NAME g_sri[l_ac].sri04
                  NEXT FIELD sri04
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
 
   CLOSE t3002_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t3002_b_askkey()
 
   CLEAR FORM
   CALL g_sri.clear()
   CONSTRUCT g_wc2 ON sri01,sri02,sri03,sri04,sri05,sri06
        FROM s_sri[1].sri01,s_sri[1].sri02,s_sri[1].sri03,
             s_sri[1].sri04,s_sri[1].sri05,s_sri[1].sri06
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP     #查詢條件
          CASE
             WHEN INFIELD(sri01)    #查詢報工單
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_srf"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sri01
                NEXT FIELD sri01
             WHEN INFIELD(sri04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.arg1 = "6"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sri04
               NEXT FIELD sri04
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
 
      ON ACTION qbe_select
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
   
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
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
 
   CALL t3002_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t3002_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-7C0034 VARCHAR(200)
 
    LET g_sql =
        "SELECT sri01,sri02,sri03,'','','',sri04,'',sri05,sri06",
        " FROM sri_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY sri01,sri02"
    PREPARE t3002_pb FROM g_sql
    DECLARE sri_curs CURSOR FOR t3002_pb
 
    CALL g_sri.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH sri_curs INTO g_sri[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT 
        FOREACH END IF
        CALL t3002_set_srg03(g_sri[g_cnt].sri01,g_sri[g_cnt].sri03)
             RETURNING g_sri[g_cnt].srg03,g_sri[g_cnt].ima02,g_sri[g_cnt].ima021
        CALL t3002_set_sri04(g_sri[g_cnt].sri04) RETURNING g_sri[g_cnt].azf03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_sri.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t3002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-7C0034 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sri TO s_sri.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      # Spsrial 4ad ACTION
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
 
FUNCTION t3002_out()
    DEFINE
        l_sri           RECORD 
                      sri01  LIKE sri_file.sri01 ,
                      sri02  LIKE sri_file.sri02 ,
                      sri03  LIKE sri_file.sri03 ,
                      srg03  LIKE srg_file.srg03 ,
                      ima02  LIKE ima_file.ima02 ,
                      ima021 LIKE ima_file.ima021,
                      sri04  LIKE sri_file.sri04 ,
                      azf03  LIKE azf_file.azf03 ,
                      sri05  LIKE sri_file.sri05 ,
                      sri06  LIKE sri_file.sri06
                        END RECORD,
        l_i             LIKE type_file.num5,     #No.FUN-7C0034 SMALLINT
        l_name          LIKE type_file.chr20,    # External(Disk) file name     #No.FUN-7C0034 VARCHAR(20)
        l_za05          LIKE za_file.za05        #No.FUN-7C0034 VARCHAR(20)
                        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='asrt3002'
    LET g_sql="SELECT sri01,sri02,sri03,'','','',sri04,'',sri05,sri06",   # 組合出 SQL 指令
              " FROM sri_file ",
              " WHERE ", g_wc2 CLIPPED
    PREPARE t3002_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t3002_co                         # SCROLL CURSOR
         CURSOR FOR t3002_p1
 
#    CALL cl_outnam('asrt3002') RETURNING l_name      #No.FUN-7C0034
#    START REPORT t3002_rep TO l_name                 #No.FUN-7C0034
 
    FOREACH t3002_co INTO l_sri.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        CALL t3002_set_srg03(l_sri.sri01,l_sri.sri03)
             RETURNING l_sri.srg03,l_sri.ima02,l_sri.ima021
        CALL t3002_set_sri04(l_sri.sri04) RETURNING l_sri.azf03
#        OUTPUT TO REPORT t3002_rep(l_sri.*)           #No.FUN-7C0034
         EXECUTE insert_prep USING
              l_sri.sri01,l_sri.sri02,l_sri.sri03,l_sri.srg03,l_sri.ima02,
              l_sri.ima021,l_sri.sri04,l_sri.azf03,l_sri.sri05,l_sri.sri06
    END FOREACH
#No.FUN-7C0034--start--
#    FINISH REPORT t3002_rep
 
#    CLOSE t3002_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-7C0034--end--
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
   IF g_zz05='Y' THEN
     CALL cl_wcchp(g_wc2,'sri01,sri02,sri03,sri04,sri05,sri06')
          RETURNING g_wc2
     ELSE
      LET g_wc2=""
    END IF 
   LET g_str=g_wc2
   CALL cl_prt_cs3('asrt3002','asrt3002',l_sql,g_str)
END FUNCTION
 
#No.FUN-7C0034--start--
#REPORT t3002_rep(sr)
 
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-7C0034 VARCHAR(1)
#        l_chr           LIKE type_file.chr1,          #No.FUN-7C0034 VARCHAR(1)
#        sr              RECORD 
#                      sri01  LIKE sri_file.sri01 ,
#                      sri02  LIKE sri_file.sri02 ,
#                      sri03  LIKE sri_file.sri03 ,
#                      srg03  LIKE srg_file.srg03 ,
#                      ima02  LIKE ima_file.ima02 ,
#                      ima021 LIKE ima_file.ima021,
#                      sri04  LIKE sri_file.sri04 ,
#                      azf03  LIKE azf_file.azf03 ,
#                      sri05  LIKE sri_file.sri05 ,
#                      sri06  LIKE sri_file.sri06
#                        END RECORD
 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.sri01,sr.sri02
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2)+1,g_company CLIPPED 
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                           g_x[36],g_x[37],g_x[38]
#            PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            PRINTX name=D1 COLUMN g_c[31],sr.sri01,
#                           COLUMN g_c[32],cl_numfor(sr.sri02,32,0),
#                           COLUMN g_c[33],cl_numfor(sr.sri03,33,0),
#                           COLUMN g_c[34],sr.srg03,
#                           COLUMN g_c[35],sr.sri04,
#                           COLUMN g_c[36],sr.azf03,
#                           COLUMN g_c[37],cl_numfor(sr.sri05,37,3),
#                           COLUMN g_c[38],sr.sri06
 
#            PRINTX name=D2 COLUMN g_c[42],sr.ima02,
#                           COLUMN g_c[43],sr.ima021                          
#        ON LAST ROW
#            PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
           
#END REPORT
#No.FUN-7C0034--end--
                                                    
FUNCTION t3002_set_srg03(p_srg01,p_srg02)
DEFINE p_srg01 LIKE srg_file.srg01
DEFINE p_srg02 LIKE srg_file.srg02
DEFINE l_srg03 LIKE srg_file.srg03
DEFINE l_ima02 LIKE ima_file.ima02
DEFINE l_ima021 LIKE ima_file.ima021
 
  LET l_srg03=''
  LET l_ima02=''
  LET l_ima021=''
  SELECT srg03 INTO l_srg03 FROM srg_file WHERE srg01=p_srg01
                                            AND srg02=p_srg02
  SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01=l_srg03
  RETURN l_srg03,l_ima02,l_ima021
END FUNCTION
 
FUNCTION t3002_set_sri04(p_sri04)
DEFINE p_sri04 LIKE sri_file.sri04
DEFINE l_azf03 LIKE azf_file.azf03
 
  LET l_azf03=''
  SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=p_sri04
                                            AND azf02='6'
  RETURN l_azf03
END FUNCTION
 
FUNCTION t3002_chk_sri05()
DEFINE t_sri05 LIKE sri_file.sri05
DEFINE l_srg06 LIKE srg_file.srg06
   
   IF cl_null(g_sri[l_ac].sri01) OR cl_null(g_sri[l_ac].sri03) OR
      cl_null(g_sri[l_ac].sri02) THEN
      RETURN TRUE
   END IF
   SELECT SUM(sri05) INTO t_sri05 FROM sri_file WHERE sri01=g_sri[l_ac].sri01
                                                  AND sri03=g_sri[l_ac].sri03
                                                  AND sri02<>g_sri[l_ac].sri02
   IF SQLCA.sqlcode OR cl_null(t_sri05) THEN
      LET t_sri05=0
   END IF
   SELECT SUM(srg06+srg07) INTO l_srg06 FROM srg_file 
                                                WHERE srg01=g_sri[l_ac].sri01
                                                  AND srg02=g_sri[l_ac].sri03
   IF SQLCA.sqlcode OR cl_null(l_srg06) THEN
      LET l_srg06=0
   END IF
   IF (t_sri05+g_sri[l_ac].sri05)>l_srg06 THEN
      CALL cl_err('','asr-035',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

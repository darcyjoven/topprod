# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: asrt3001.4gl
# Descriptions...: 報工異常/例外資料維護
# Date & Author..: 06/02/08 kim 
#
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: NO.FUN-7C0034 07/12/11 By lilingyu 制作CR報表
# Modify.........: No.CHI-920069 09/02/20 By jan 修改時需檢查每一筆報工單單號(srg01)是否已確認,若維已確認則卡住不可修改
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_srh      RECORD LIKE srh_file.*,
     g_srh01    LIKE srh_file.srh01,
     g_srh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        srh01  LIKE srh_file.srh01 ,
        srh02  LIKE srh_file.srh02 ,
        srh03  LIKE srh_file.srh03 ,
        srg03  LIKE srg_file.srg03 ,
        ima02  LIKE ima_file.ima02 ,
        ima021 LIKE ima_file.ima021,
        srh04  LIKE srh_file.srh04 ,
        sgb05  LIKE sgb_file.sgb05 ,
        srh05  LIKE srh_file.srh05 ,
        srh06  LIKE srh_file.srh06
                    END RECORD,
    g_srh_t         RECORD                 #程式變數 (舊值)
        srh01  LIKE srh_file.srh01 ,
        srh02  LIKE srh_file.srh02 ,
        srh03  LIKE srh_file.srh03 ,
        srg03  LIKE srg_file.srg03 ,
        ima02  LIKE ima_file.ima02 ,
        ima021 LIKE ima_file.ima021,
        srh04  LIKE srh_file.srh04 ,
        sgb05  LIKE sgb_file.sgb05 ,
        srh05  LIKE srh_file.srh05 ,
        srh06  LIKE srh_file.srh06
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000, #No.FUN-680130 VARCHAR(300)
    g_rec_b         LIKE type_file.num5,    #單身筆數            #No.FUN-680130 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680130 SMALLINT
 
DEFINE g_argv1 LIKE srh_file.srh01
DEFINE g_forupd_sql  STRING                  #SELECT ... FOR UPDATE SQL  
DEFINE g_cnt         LIKE type_file.num10                        #No.FUN-680130 INTEGER
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680130 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5                 #No.FUN-680130 SMALLINT
DEFINE l_table       STRING                  #暫存檔             #NO.FUN-7C0034                 
DEFINE g_str         STRING                  #用來組傳入cs3參數  #NO.FUN-7C0034
DEFINE l_sql         STRING                  #抓取暫存盤資料     #NO.FUN-7C0034
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5                         #No.FUN-680130 SMALLINT
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
    
    #NO.FUN-7C0034   --start--
    #錄入CR所需的暫存檔
    LET l_sql="srh01.srh_file.srh01,",                           
              "srh02.srh_file.srh02,",
              "srh03.srh_file.srh03,",
              "srg03.srg_file.srg03,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "srh04.srh_file.srh04,",
              "sgb05.sgb_file.sgb05,",
              "srh05.srh_file.srh05,",
              "srh06.srh_file.srh06"
    LET l_table =cl_prt_temptable('asrt3001',l_sql) CLIPPED
    IF  l_table =-1 THEN EXIT PROGRAM END IF
    LET l_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM l_sql
    IF STATUS THEN
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM 
    END IF   
    #NO.FUN-7C0034  --end--
 
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW t3001_w AT p_row,p_col WITH FORM "asr/42f/asrt3001"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
    
    LET g_argv1=ARG_VAL(1)
    
    IF cl_null(g_argv1) THEN
       LET g_srh01=''
       LET g_wc2 = '1=1'
     ELSE
       CALL cl_set_comp_visible("srh01",FALSE)
       LET g_srh01=g_argv1
       LET g_wc2 = "srh01='",g_srh01,"'"
     END IF  
    CALL t3001_b_fill(g_wc2)
    CALL t3001_menu()
    CLOSE WINDOW t3001_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
END MAIN
 
FUNCTION t3001_menu()
 
   WHILE TRUE
      CALL t3001_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF NOT cl_null(g_argv1) THEN
               LET g_action_choice = NULL
               EXIT CASE
            END IF
            IF cl_chk_act_auth() THEN
               CALL t3001_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t3001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t3001_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_srh[l_ac].srh01 IS NOT NULL THEN
                  LET g_doc.column1 = "srh01"
                  LET g_doc.value1 = g_srh[l_ac].srh01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_srh),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t3001_q()
   CALL t3001_b_askkey()
END FUNCTION
 
FUNCTION t3001_b()
DEFINE
   l_ac_t,l_cnt    LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680130 SMALLINT
   l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680130 SMALLINT
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680130 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680130 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,     #可新增否          #No.FUN-680130 VARCHAR(1)
   l_allow_delete  LIKE type_file.chr1      #可刪除否          #No.FUN-680130 VARCHAR(1)
DEFINE l_srfconf   LIKE srf_file.srfconf     #CHI-920069
DEFINE l_flag      LIKE type_file.chr1       #CHI-920069
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   #CHI-920069--BEGIN--  
   LET l_srfconf = NULL 
   IF NOT cl_null(g_srh01) THEN 
      SELECT srfconf INTO l_srfconf 
        FROM srf_file
       WHERE srf01 = g_srh01 
      IF l_srfconf = 'Y' THEN 
         CALL cl_err(g_srh01,'asr-052',0)
         RETURN 
      END IF
   END IF
   #CHI-920069--END-- 
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT *  FROM srh_file WHERE srh01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_srh WITHOUT DEFAULTS FROM s_srh.*
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
             #CALL t3001_set_entry(p_cmd)                                         
             #CALL t3001_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
             LET g_srh_t.* = g_srh[l_ac].*  #BACKUP
             OPEN t3001_bcl USING g_srh_t.srh01
             IF STATUS THEN
                CALL cl_err("OPEN t3001_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t3001_bcl INTO m_srh.* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_srh_t.srh01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                #CHI-920069--BEGIN-- 
               LET l_srfconf = NULL
               IF cl_null(g_srh01) THEN
               SELECT srfconf INTO l_srfconf 
                 FROM srf_file
                WHERE srf01 = m_srh.srh01
               IF l_srfconf = 'Y' THEN
                  LET l_flag = 'Y' 
                  CALL cl_set_comp_entry("srh02,srh03,srh04,srh05,srh06",FALSE)
               ELSE
                  LET l_flag = 'N'
                  CALL cl_set_comp_entry("srh02,srh03,srh04,srh05,srh06",TRUE)
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
          CALL cl_set_comp_entry("srh02,srh03,srh04,srh05,srh06",TRUE)  #CHI-920069  
          INITIALIZE g_srh[l_ac].* TO NULL     
          LET g_srh_t.* = g_srh[l_ac].*         #新輸入資料
          IF NOT cl_null(g_srh01) THEN
             LET g_srh[l_ac].srh01=g_srh01
          END IF   
          CALL cl_show_fld_cont()
          IF cl_null(g_srh01) THEN
            NEXT FIELD srh01
          ELSE
            NEXT FIELD srh02
          END IF
          
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t3001_bcl
             CANCEL INSERT
          END IF
          INSERT INTO srh_file(srh01,srh02,srh03,srh04,srh05,srh06, 
                               srhplant,srhlegal) #FUN-980008 add
          VALUES(g_srh[l_ac].srh01,g_srh[l_ac].srh02,g_srh[l_ac].srh03,g_srh[l_ac].srh04,
                 g_srh[l_ac].srh05,g_srh[l_ac].srh06,
                 g_plant,g_legal)    #FUN-980008 add
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_srh[l_ac].srh02,SQLCA.sqlcode,0)   #No.FUN-660138
             CALL cl_err3("ins","srh_file",g_srh[l_ac].srh01,g_srh[l_ac].srh02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD srh01
          #CHI-920069--EBGIN-- 
          IF l_flag = 'Y' THEN 
             IF g_srh[l_ac].srh01!=g_srh_t.srh01 THEN 
             CALL cl_err('','asr-052',0)
             LET g_srh[l_ac].srh01 = g_srh_t.srh01
             NEXT FIELD srh01
             END IF
           END IF
          #CHI-920069--END--
          IF (NOT cl_null(g_srh[l_ac].srh01)) AND (g_srh[l_ac].srh01!=g_srh_t.srh01 OR g_srh_t.srh01 IS NULL) THEN
             #CHI-920069--EBGIN--
             LET l_srfconf = NULL
             SELECT srfconf INTO l_srfconf
               FROM srf_file 
              WHERE srf01 = g_srh[l_ac].srh01  
             IF l_srfconf = 'Y' THEN 
                CALL cl_err('','asr-052',0)
                NEXT FIELD srh01
             END IF
             #CHI-920069--END-- 
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM srf_file WHERE srf01=g_srh[l_ac].srh01
             IF l_cnt=0 THEN
                CALL cl_err('chk srh01',100,1)
                LET g_srh[l_ac].srh01=g_srh_t.srh01
                DISPLAY BY NAME g_srh[l_ac].srh01
                NEXT FIELD srh01
             END IF
          END IF
 
       BEFORE FIELD srh02
          IF cl_null(g_srh[l_ac].srh02) AND (g_srh_t.srh02 IS NULL) THEN
             SELECT MAX(srh02) INTO g_srh[l_ac].srh02 FROM srh_file WHERE srh01=g_srh[l_ac].srh01
             IF cl_null(g_srh[l_ac].srh02) THEN
                LET g_srh[l_ac].srh02=0
             END IF
             IF g_sma.sma19>0 THEN
                LET g_srh[l_ac].srh02=g_srh[l_ac].srh02+g_sma.sma19
             ELSE
                LET g_srh[l_ac].srh02=g_srh[l_ac].srh02+1
             END IF   
             DISPLAY BY NAME g_srh[l_ac].srh02
          END IF
 
       AFTER FIELD srh03
          IF NOT cl_null(g_srh[l_ac].srh03) THEN
            IF g_srh[l_ac].srh03!=g_srh_t.srh03 OR g_srh_t.srh03 IS NULL THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM srg_file
                WHERE srg01=g_srh[l_ac].srh01
                  AND srg02=g_srh[l_ac].srh03
              IF l_cnt=0 THEN
                CALL cl_err('chk srh03',100,1)
                LET g_srh[l_ac].srg03=''
                LET g_srh[l_ac].ima02=''
                LET g_srh[l_ac].ima021=''
                DISPLAY BY NAME g_srh[l_ac].srg03,g_srh[l_ac].ima02,g_srh[l_ac].ima021
                NEXT FIELD srh03
              END IF    
            END IF
            CALL t3001_set_srg03(g_srh[l_ac].srh01,g_srh[l_ac].srh03)
                 RETURNING g_srh[l_ac].srg03,g_srh[l_ac].ima02,g_srh[l_ac].ima021
            DISPLAY BY NAME g_srh[l_ac].srg03,g_srh[l_ac].ima02,g_srh[l_ac].ima021     
          ELSE
            LET g_srh[l_ac].srg03=''
            LET g_srh[l_ac].ima02=''
            LET g_srh[l_ac].ima021=''
            DISPLAY BY NAME g_srh[l_ac].srg03,g_srh[l_ac].ima02,g_srh[l_ac].ima021
          END IF
 
       AFTER FIELD srh04
          IF NOT cl_null(g_srh[l_ac].srh04) THEN
            IF g_srh[l_ac].srh04!=g_srh_t.srh04 OR g_srh_t.srh04 IS NULL THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM sgb_file WHERE sgb01=g_srh[l_ac].srh04
              IF l_cnt=0 THEN
                 LET g_srh[l_ac].sgb05=''
                 DISPLAY BY NAME g_srh[l_ac].sgb05
                 CALL cl_err('chk sgb',100,1)
                 NEXT FIELD srh04
              END IF
              CALL t3001_set_srh04(g_srh[l_ac].srh04) RETURNING g_srh[l_ac].sgb05
              DISPLAY BY NAME g_srh[l_ac].sgb05
            END IF 
          ELSE
             LET g_srh[l_ac].sgb05=''
             DISPLAY BY NAME g_srh[l_ac].sgb05
          END IF   
          
       AFTER FIELD srh05
          IF (NOT cl_null(g_srh[l_ac].srh05)) AND 
             ((g_srh[l_ac].srh05!=g_srh_t.srh05) OR 
              (g_srh_t.srh05 IS NULL)) THEN
             IF NOT t3001_chk_srh05() THEN
                LET g_srh[l_ac].srh05=g_srh_t.srh05
                NEXT FIELD srh05
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          #CHI-920069--BEGIN--
          IF l_flag = 'Y' THEN
             CALL cl_err('','asr-052',0)
             CANCEL DELETE
          END IF 
         #CHI-920069--END--
          IF g_srh_t.srh02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "srh01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_srh[l_ac].srh01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM srh_file WHERE srh01 = g_srh[l_ac].srh01
                                    AND srh02 = g_srh[l_ac].srh02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_srh[l_ac].srh02,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("del","srh_file",g_srh[l_ac].srh01,g_srh[l_ac].srh02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
             LET g_srh[l_ac].* = g_srh_t.*
             CLOSE t3001_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_srh[l_ac].srh01,-263,0)
             LET g_srh[l_ac].* = g_srh_t.*
          ELSE
             UPDATE srh_file SET srh01=g_srh[l_ac].srh01,
                                 srh02=g_srh[l_ac].srh02,
                                 srh03=g_srh[l_ac].srh03,
                                 srh04=g_srh[l_ac].srh04,
                                 srh05=g_srh[l_ac].srh05,
                                 srh06=g_srh[l_ac].srh06
              WHERE srh01 = g_srh_t.srh01
                AND srh02 = g_srh_t.srh02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_srh[l_ac].srh01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("upd","srh_file",g_srh[l_ac].srh01,g_srh[l_ac].srh02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
                LET g_srh[l_ac].* = g_srh_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
#         LET l_ac_t = l_ac                # 新增  #FUN-D40030 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_srh[l_ac].* = g_srh_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_srh.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF
             CLOSE t3001_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac                      #FUN-D40030 add 
          CLOSE t3001_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(srh02) AND l_ac > 1 THEN
             LET g_srh[l_ac].* = g_srh[l_ac-1].*
             NEXT FIELD srh02
          END IF
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(srh01) OR INFIELD(srh03)    #查詢報工單&項次
                 CALL cl_init_qry_var()
                 IF cl_null(g_argv1) THEN
                    LET g_qryparam.form = "q_srg01"
                 ELSE
                    LET g_qryparam.form = "q_srg02"
                    LET g_qryparam.arg1 = g_argv1
                 END IF   
                 CALL cl_create_qry() RETURNING g_srh[l_ac].srh01,
                                                g_srh[l_ac].srh03
                 DISPLAY BY NAME g_srh[l_ac].srh01,g_srh[l_ac].srh03
                 IF INFIELD(srh01) THEN
                    NEXT FIELD srh01
                 END IF   
                 IF INFIELD(srh03) THEN
                    NEXT FIELD srh03
                 END IF   
              WHEN INFIELD(srh04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sgb"
                  CALL cl_create_qry() RETURNING g_srh[l_ac].srh04
                  DISPLAY BY NAME g_srh[l_ac].srh04
                  NEXT FIELD srh04
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
 
   CLOSE t3001_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t3001_b_askkey()
 
   CLEAR FORM
   CALL g_srh.clear()
   CONSTRUCT g_wc2 ON srh01,srh02,srh03,srh04,srh05,srh06
        FROM s_srh[1].srh01,s_srh[1].srh02,s_srh[1].srh03,
             s_srh[1].srh04,s_srh[1].srh05,s_srh[1].srh06
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION CONTROLP     #查詢條件
          CASE
             WHEN INFIELD(srh01)    #查詢報工單
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_srf"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srh01
                NEXT FIELD srh01
             WHEN INFIELD(srh04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sgb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO srh04
               NEXT FIELD srh04
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
 
   CALL t3001_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t3001_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    LET g_sql =
        "SELECT srh01,srh02,srh03,'','','',srh04,'',srh05,srh06",
        " FROM srh_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY srh01,srh02"
    PREPARE t3001_pb FROM g_sql
    DECLARE srh_curs CURSOR FOR t3001_pb
 
    CALL g_srh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH srh_curs INTO g_srh[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT 
        FOREACH END IF
        CALL t3001_set_srg03(g_srh[g_cnt].srh01,g_srh[g_cnt].srh03)
             RETURNING g_srh[g_cnt].srg03,g_srh[g_cnt].ima02,g_srh[g_cnt].ima021
        CALL t3001_set_srh04(g_srh[g_cnt].srh04) RETURNING g_srh[g_cnt].sgb05
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_srh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t3001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_srh TO s_srh.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      # Spsrhal 4ad ACTION
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
 
FUNCTION t3001_out()
    DEFINE
        l_srh           RECORD 
                      srh01  LIKE srh_file.srh01 ,
                      srh02  LIKE srh_file.srh02 ,
                      srh03  LIKE srh_file.srh03 ,
                      srg03  LIKE srg_file.srg03 ,
                      ima02  LIKE ima_file.ima02 ,
                      ima021 LIKE ima_file.ima021,
                      srh04  LIKE srh_file.srh04 ,
                      sgb05  LIKE sgb_file.sgb05 ,
                      srh05  LIKE srh_file.srh05 ,
                      srh06  LIKE srh_file.srh06
                        END RECORD,
        l_i             LIKE type_file.num5,          #No.FUN-680130 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680130 VARCHAR(20)
        l_za05          LIKE za_file.za05             #No.FUN-680130 VARCHAR(20)
                        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
#   CALL cl_wait()                                  #NO.FUN-7C0034
    CALL cl_del_data(l_table)                       #NO.FUN-7C0034
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='arst3001' #NO.FUN-7C0034
 
    LET g_sql="SELECT srh01,srh02,srh03,'','','',srh04,'',srh05,srh06 FROM srh_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE t3001_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t3001_co                         # SCROLL CURSOR
         CURSOR FOR t3001_p1
 
#   CALL cl_outnam('asrt3001') RETURNING l_name  #NO.FUN-7C0034
#   START REPORT t3001_rep TO l_name             #NO.FUN-7C0034  
 
    FOREACH t3001_co INTO l_srh.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        CALL t3001_set_srg03(l_srh.srh01,l_srh.srh03)
             RETURNING l_srh.srg03,l_srh.ima02,l_srh.ima021
        CALL t3001_set_srh04(l_srh.srh04) RETURNING l_srh.sgb05
#        OUTPUT TO REPORT t3001_rep(l_srh.*)    #NO.FUN-7C0034
         
         EXECUTE insert_prep USING              #NO.FUN-7C0034 
              l_srh.srh01,l_srh.srh02,                          
              l_srh.srh03,l_srh.srg03,
              l_srh.ima02,l_srh.ima021,
              l_srh.srh04,l_srh.srh05,
              l_srh.srh05,l_srh.srh06
   END FOREACH
 
#    FINISH REPORT t3001_rep                      #NO.FUN-7C0034 
 
#    CLOSE t3001_co                               #NO.FUN-7C0034 
#    ERROR ""                                     #NO.FUN-7C0034
#    CALL cl_prt(l_name,' ','1',g_len)            #NO.FUN-7C0034
 
  #NO.FUN-7C0034   --stsrt--
  LET l_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  IF g_zz05='Y' THEN
    CALL cl_wcchp(g_wc2,'srh01,srh02,srh03,srh04,srh05,srh06')
          RETURNING g_wc2
    ELSE
      LET g_wc2=""
    END IF
   
   LET g_str=g_wc2
   
   CALL cl_prt_cs3('asrt3001','asrt3001',l_sql,g_str)
  #NO.FUN-7C0034   --end--
END FUNCTION
 
#NO.FUN-7C0034  --start--
#REPORT t3001_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
#        l_chr           LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
#        sr              RECORD 
#                      srh01  LIKE srh_file.srh01 ,
#                      srh02  LIKE srh_file.srh02 ,
#                      srh03  LIKE srh_file.srh03 ,
#                      srg03  LIKE srg_file.srg03 ,
#                      ima02  LIKE ima_file.ima02 ,
#                      ima021 LIKE ima_file.ima021,
#                      srh04  LIKE srh_file.srh04 ,
#                      sgb05  LIKE sgb_file.sgb05 ,
#                      srh05  LIKE srh_file.srh05 ,
#                      srh06  LIKE srh_file.srh06
#                        END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.srh01,sr.srh02
#
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
#            PRINTX name=D1 COLUMN g_c[31],sr.srh01,
#                           COLUMN g_c[32],cl_numfor(sr.srh02,32,0),
#                           COLUMN g_c[33],cl_numfor(sr.srh03,33,0),
#                           COLUMN g_c[34],sr.srg03,
#                           COLUMN g_c[35],sr.srh04,
#                           COLUMN g_c[36],sr.sgb05,
#                           COLUMN g_c[37],cl_numfor(sr.srh05,37,3),
#                           COLUMN g_c[38],sr.srh06
#                   
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
#           
#END REPORT
#NO.FUN-7C0034  --end--
                                                    
FUNCTION t3001_set_srg03(p_srg01,p_srg02)
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
 
FUNCTION t3001_set_srh04(p_srh04)
DEFINE p_srh04 LIKE srh_file.srh04
DEFINE l_sgb05 LIKE sgb_file.sgb05
 
  LET l_sgb05=''
  SELECT sgb05 INTO l_sgb05 FROM sgb_file WHERE sgb01=p_srh04
  RETURN l_sgb05
END FUNCTION
 
FUNCTION t3001_chk_srh05()
DEFINE t_srh05 LIKE srh_file.srh05
DEFINE l_srg10 LIKE srg_file.srg10
   
   IF cl_null(g_srh[l_ac].srh01) OR cl_null(g_srh[l_ac].srh03) OR
      cl_null(g_srh[l_ac].srh02) THEN
      RETURN TRUE
   END IF
   SELECT SUM(srh05) INTO t_srh05 FROM srh_file WHERE srh01=g_srh[l_ac].srh01
                                                  AND srh03=g_srh[l_ac].srh03
                                                  AND srh02<>g_srh[l_ac].srh02
   IF SQLCA.sqlcode OR cl_null(t_srh05) THEN
      LET t_srh05=0
   END IF
   SELECT SUM(srg10) INTO l_srg10 FROM srg_file WHERE srg01=g_srh[l_ac].srh01
                                                  AND srg02=g_srh[l_ac].srh03
   IF SQLCA.sqlcode OR cl_null(l_srg10) THEN
      LET l_srg10=0
   END IF
   IF (t_srh05+g_srh[l_ac].srh05)>l_srg10 THEN
      CALL cl_err('','asr-035',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

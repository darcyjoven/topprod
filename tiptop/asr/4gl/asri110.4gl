# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: asri110.4gl
# Descriptions...: 換線時間維護作業
# Date & Author..: 06/01/05 kim 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7B0103 07/11/27 By jan 報表格式修改為crystal report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_src      RECORD LIKE src_file.*,
     g_src           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        src01   LIKE src_file.src01,  
        eci06   LIKE eci_file.eci06,  
        src02   LIKE src_file.src02,  
        ima02   LIKE ima_file.ima02,  
        ima021  LIKE ima_file.ima021, 
        src03   LIKE src_file.src03,  
        ima02b  LIKE ima_file.ima02, 
        ima021b LIKE ima_file.ima021,
        src04   LIKE src_file.src04,  
        srcacti LIKE src_file.srcacti 
                    END RECORD,      
    g_src_t         RECORD                 #程式變數 (舊值)
        src01   LIKE src_file.src01,  
        eci06   LIKE eci_file.eci06,  
        src02   LIKE src_file.src02,  
        ima02   LIKE ima_file.ima02,  
        ima021  LIKE ima_file.ima021, 
        src03   LIKE src_file.src03,  
        ima02b  LIKE ima_file.ima02, 
        ima021b LIKE ima_file.ima021,
        src04   LIKE src_file.src04,  
        srcacti LIKE src_file.srcacti 
                    END RECORD,
    g_wc2,g_sql    LIKE type_file.chr1000,    #No.FUN-680130 VARCHAR(300)
    g_rec_b        LIKE type_file.num5,       #單身筆數    #No.FUN-680130 SMALLINT
    l_ac           LIKE type_file.num5        #目前處理的ARRAY CNT    #No.FUN-680130 SMALLINT
 
DEFINE g_forupd_sql    STRING                 #SELECT ... FOR UPDATE SQL  
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose    #No.FUN-680130 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5     #No.FUN-680130 SMALLINT
DEFINE l_table               STRING          #No.FUN-7BO103                                                                         
DEFINE g_str                 STRING          #No.FUN-7B0103
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680130 SMALLINT
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
#No.FUN-7B0103--BEGIN--                                                                                                             
   LET g_sql="src01.src_file.src01,",                                                                                               
             "src02.src_file.src02,",                                                                                               
             "src03.src_file.src03,",                                                                                               
             "src04.src_file.src04,",       
             "srcacti.src_file.srcacti,",
             "eci06.eci_file.eci06,",                                                                                        
             "ima02.ima_file.ima02,",                                                                                               
             "iam021.ima_file.ima021,",                                                                                               
             "ima02b.ima_file.ima02,",                                                                                               
             "ima021b.ima_file.ima021"                                                                                             
    LET l_table=cl_prt_temptable("asri110",g_sql) CLIPPED                                                                           
    IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?,?)"                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("insert_prep:",status,1)                                                                                         
    END IF                                                                                                                          
#No.FUN-7B0013--END
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i110_w AT p_row,p_col WITH FORM "asr/42f/asri110"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i110_b_fill(g_wc2)
    CALL i110_menu()
    CLOSE WINDOW i110_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
END MAIN
 
FUNCTION i110_menu()
 
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i110_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_src[l_ac].src01 IS NOT NULL THEN
                  LET g_doc.column1 = "src01"
                  LET g_doc.value1 = g_src[l_ac].src01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_src),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i110_q()
   CALL i110_b_askkey()
END FUNCTION
 
FUNCTION i110_b()
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
 
   LET g_forupd_sql = "SELECT *  FROM src_file WHERE src01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_src WITHOUT DEFAULTS FROM s_src.*
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
             CALL i110_set_entry(p_cmd)                                         
             CALL i110_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
             LET g_src_t.* = g_src[l_ac].*  #BACKUP
             OPEN i110_bcl USING g_src_t.src01
             IF STATUS THEN
                CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i110_bcl INTO m_src.* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_src_t.src01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                       
          CALL i110_set_entry(p_cmd)                                            
          CALL i110_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_src[l_ac].* TO NULL     
          LET g_src[l_ac].src04   = 0         #Body default
          LET g_src[l_ac].srcacti = 'Y'       #Body default
          LET g_src_t.* = g_src[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD src01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i110_bcl
             CANCEL INSERT
          END IF
          INSERT INTO src_file(src01,src02,src03,src04,srcacti)
          VALUES(g_src[l_ac].src01,g_src[l_ac].src02,g_src[l_ac].src03,g_src[l_ac].src04,
                 g_src[l_ac].srcacti)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_src[l_ac].src01,SQLCA.sqlcode,0)   #No.FUN-660138
             CALL cl_err3("ins","src_file",g_src[l_ac].src01,g_src[l_ac].src02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD src01
          IF NOT cl_null(g_src[l_ac].src01) AND 
             (g_src[l_ac].src01 != g_src_t.src01 OR
             g_src_t.src01 IS NULL) THEN
             CALL i110_src01(g_src[l_ac].src01)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                LET g_src[l_ac].src01 = g_src_t.src01
                LET g_src[l_ac].eci06 = g_src_t.eci06
                DISPLAY BY NAME g_src[l_ac].src01,g_src[l_ac].eci06
                NEXT FIELD src01
             END IF
             CALL i110_setecidesc(g_src[l_ac].src01) RETURNING g_src[l_ac].eci06
             DISPLAY BY NAME g_src[l_ac].eci06
          END IF
 
       AFTER FIELD src02
          IF NOT cl_null(g_src[l_ac].src02) AND 
            (g_src[l_ac].src02!=g_src_t.src02 OR g_src_t.src02 IS NULL) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_src[l_ac].src02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_src[l_ac].src02= g_src_t.src02
               NEXT FIELD src02
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            CALL i110_src02(g_src[l_ac].src02)
            IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              LET g_src[l_ac].src02 =g_src_t.src02
              LET g_src[l_ac].ima02 =g_src_t.ima02
              LET g_src[l_ac].ima021=g_src_t.ima021
              DISPLAY BY NAME g_src[l_ac].src02
              DISPLAY BY NAME g_src[l_ac].ima02
              DISPLAY BY NAME g_src[l_ac].ima021
              NEXT FIELD src02
            END IF
            CALL i110_setimadesc(g_src[l_ac].src02) RETURNING g_src[l_ac].ima02,
                                                              g_src[l_ac].ima021
            DISPLAY BY NAME g_src[l_ac].ima02
            DISPLAY BY NAME g_src[l_ac].ima021
          END IF
 
       AFTER FIELD src03
          IF (NOT cl_null(g_src[l_ac].src03)) AND 
             (g_src[l_ac].src03!=g_src_t.src03 OR g_src_t.src03 IS NULL) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_src[l_ac].src03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_src[l_ac].src03= g_src_t.src03
               NEXT FIELD src03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            CALL i110_src02(g_src[l_ac].src03)
            IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              LET g_src[l_ac].src03  =g_src_t.src03
              LET g_src[l_ac].ima02b =g_src_t.ima02b
              LET g_src[l_ac].ima021b=g_src_t.ima021b
              DISPLAY BY NAME g_src[l_ac].src03
              DISPLAY BY NAME g_src[l_ac].ima02b
              DISPLAY BY NAME g_src[l_ac].ima021b
              NEXT FIELD src03
            END IF
            CALL i110_setimadesc(g_src[l_ac].src03) RETURNING g_src[l_ac].ima02b,
                                                              g_src[l_ac].ima021b
            DISPLAY BY NAME g_src[l_ac].ima02b
            DISPLAY BY NAME g_src[l_ac].ima021b
          END IF
 
       AFTER FIELD srcacti
          IF NOT cl_null(g_src[l_ac].srcacti) THEN
             IF g_src[l_ac].srcacti NOT MATCHES '[YN]' THEN 
                LET g_src[l_ac].srcacti = g_src_t.srcacti
                NEXT FIELD srcacti
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_src_t.src01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "src01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_src[l_ac].src01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM src_file WHERE src01 = g_src_t.src01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_src_t.src01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("del","src_file",g_src_t.src01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
             LET g_src[l_ac].* = g_src_t.*
             CLOSE i110_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_src[l_ac].src01,-263,0)
             LET g_src[l_ac].* = g_src_t.*
          ELSE
             UPDATE src_file SET src01=g_src[l_ac].src01,
                                 src02=g_src[l_ac].src02,
                                 src03=g_src[l_ac].src03,
                                 src04=g_src[l_ac].src04,
                                 srcacti=g_src[l_ac].srcacti
              WHERE src01 = g_src_t.src01
                AND src02 = g_src_t.src02
                AND src03 = g_src_t.src03
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_src[l_ac].src01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("upd","src_file",g_src[l_ac].src01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
                LET g_src[l_ac].* = g_src_t.*
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
                LET g_src[l_ac].* = g_src_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_src.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF
             CLOSE i110_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac             #FUN-D40030 add 
          CLOSE i110_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(src01) AND l_ac > 1 THEN
             LET g_src[l_ac].* = g_src[l_ac-1].*
             NEXT FIELD src01
          END IF
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(src01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_eci"
                 CALL cl_create_qry() RETURNING g_src[l_ac].src01
                 DISPLAY BY NAME g_src[l_ac].src01
              WHEN INFIELD(src02)
#FUN-AA0059---------mod------------str----------------- 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                CALL cl_create_qry() RETURNING g_src[l_ac].src02
                 CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                  RETURNING g_src[l_ac].src02  
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_src[l_ac].src02
              WHEN INFIELD(src03)
#FUN-AA0059---------mod------------str----------------- 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                CALL cl_create_qry() RETURNING g_src[l_ac].src03
                 CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' )
                  RETURNING g_src[l_ac].src03
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_src[l_ac].src03
              OTHERWISE EXIT CASE
           END CASE
 
       ON ACTION CONTROLE
           CASE
             WHEN INFIELD (src02)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oba"
                LET g_qryparam.default1 = g_src[l_ac].src02
                CALL cl_create_qry() RETURNING g_src[l_ac].src02
                DISPLAY BY NAME g_src[l_ac].src02
             WHEN INFIELD (src03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oba"
                LET g_qryparam.default1 = g_src[l_ac].src03
                CALL cl_create_qry() RETURNING g_src[l_ac].src03
	        DISPLAY BY NAME g_src[l_ac].src03
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
 
   CLOSE i110_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i110_b_askkey()
 
   CLEAR FORM
   CALL g_src.clear()
   CONSTRUCT g_wc2 ON src01,src02,src03,src04,srcacti
        FROM s_src[1].src01,s_src[1].src02,s_src[1].src03, 
             s_src[1].src04,s_src[1].srcacti
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP     #查詢條件
          CASE
              WHEN INFIELD(src01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_eci"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_src[1].src01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO src01
              WHEN INFIELD(src02)
#FUN-AA0059---------mod------------str----------------- 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.state = "c"
#                LET g_qryparam.default1 = g_src[1].src02
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_src[1].src02,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO src02
                 NEXT FIELD src02
              WHEN INFIELD(src03)
#FUN-AA0059---------mod------------str----------------- 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.state = "c"
#                LET g_qryparam.default1 = g_src[1].src03
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_src[1].src03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO src03
                 NEXT FIELD src03
             OTHERWISE EXIT CASE   
          END CASE
 
       ON ACTION CONTROLE
           CASE
             WHEN INFIELD (src02)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oba"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO src02
             WHEN INFIELD (src03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_oba"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
	        DISPLAY g_qryparam.multiret TO src03
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
 
   CALL i110_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    LET g_sql =
        "SELECT src01,'',src02,'','',src03,'','',src04,srcacti",
        " FROM src_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY src01"
    PREPARE i110_pb FROM g_sql
    DECLARE src_curs CURSOR FOR i110_pb
 
    CALL g_src.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH src_curs INTO g_src[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
       END IF
       CALL i110_setecidesc(g_src[g_cnt].src01) RETURNING g_src[g_cnt].eci06
       CALL i110_setimadesc(g_src[g_cnt].src02) RETURNING g_src[g_cnt].ima02 ,g_src[g_cnt].ima021
       CALL i110_setimadesc(g_src[g_cnt].src03) RETURNING g_src[g_cnt].ima02b,g_src[g_cnt].ima021b
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_src.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_src TO s_src.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      # Spsrcal 4ad ACTION
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
 
FUNCTION i110_out()
    DEFINE
        l_src        RECORD 
                        src01   LIKE src_file.src01,  
                        eci06   LIKE eci_file.eci06,  
                        src02   LIKE src_file.src02,  
                        ima02   LIKE ima_file.ima02,  
                        ima021  LIKE ima_file.ima021, 
                        src03   LIKE src_file.src03,  
                        ima02b  LIKE ima_file.ima02, 
                        ima021b LIKE ima_file.ima021,
                        src04   LIKE src_file.src04,  
                        srcacti LIKE src_file.srcacti 
                     END RECORD,
        l_name          LIKE type_file.chr20,       # External(Disk) file name   #No.FUN-680130 VARCHAR(20)
        l_za05          LIKE za_file.za05       #No.FUN-680130 VARCHAR(40)
                        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                                #No.FUN-7B0103                                                         
    LET g_str=''                                             #No.FUN-7B0103                                                         
    SELECT zz05 INTO g_zz05 FROM  zz_file WHERE zz01=g_prog  #No.FUN-7B0103
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT src01,'',src02,'','',src03,'','',src04,srcacti FROM 
               src_file ", " WHERE ",g_wc2 CLIPPED
    PREPARE i110_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i110_co                         # SCROLL CURSOR
         CURSOR FOR i110_p1
 
#   CALL cl_outnam('asri110') RETURNING l_name         #No.FUN-7B0103
#   START REPORT i110_rep TO l_name                    #No.FUN-7B0103
 
    FOREACH i110_co INTO l_src.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        CALL i110_setecidesc(l_src.src01) RETURNING l_src.eci06
        CALL i110_setimadesc(l_src.src02) RETURNING l_src.ima02 ,l_src.ima021
        CALL i110_setimadesc(l_src.src03) RETURNING l_src.ima02b,l_src.ima021b
#No.FUN-7B0103--BEGIN-- 
#       OUTPUT TO REPORT i110_rep(l_src.*)
        EXECUTE insert_prep USING l_src.src01,l_src.src02,l_src.src03,l_src.src04,
                                  l_src.srcacti,l_src.eci06,l_src.ima02,l_src.ima021,
                                  l_src.ima02b,l_src.ima021b
#No.FUN-7BO103--END--
    END FOREACH
 
#No.FUN-7B0103--BEGIN-- 
#   FINISH REPORT i110_rep
 
#   CLOSE i110_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                  
    IF g_zz05='Y' THEN                                                                                                              
       CALL cl_wcchp(g_wc2,'src01,src02,src03,src04,srcacti')                                                           
       RETURNING g_wc2                                                                                                              
    END IF                                                                                                                          
    LET g_str=g_wc2                                                                                                                 
    CALL cl_prt_cs3('asri110','asri110',g_sql,g_str)                                                                                
#No.FUN-7B0103--END
END FUNCTION
 
#No.FUN-7B0103--BEGIM--
{
REPORT i110_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
        l_chr           LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
        sr              RECORD 
                        src01   LIKE src_file.src01,  
                        eci06   LIKE eci_file.eci06,  
                        src02   LIKE src_file.src02,  
                        ima02   LIKE ima_file.ima02,  
                        ima021  LIKE ima_file.ima021, 
                        src03   LIKE src_file.src03,  
                        ima02b  LIKE ima_file.ima02, 
                        ima021b LIKE ima_file.ima021,
                        src04   LIKE src_file.src04,  
                        srcacti LIKE src_file.srcacti 
                        END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.src01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINTX name=H2 g_x[36],g_x[37],g_x[38]
            PRINTX name=H3 g_x[39],g_x[40],g_x[41]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINTX name=D1 COLUMN g_c[31],sr.src01,
                           COLUMN g_c[32],sr.src02,
                           COLUMN g_c[33],sr.src03,
                           COLUMN g_c[34],cl_numfor(sr.src04,34,3),
                           COLUMN g_c[35],sr.srcacti
            PRINTX name=D2 COLUMN g_c[36],sr.eci06,
                           COLUMN g_c[37],sr.ima02,
                           COLUMN g_c[38],sr.ima021
            PRINTX name=D3 COLUMN g_c[40],sr.ima02b,
                           COLUMN g_c[41],sr.ima021b
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
#No.FUN-7B0103--END--
                                                    
FUNCTION i110_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("src01,src02,src03",TRUE)
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i110_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("src01,src02,src03",FALSE)
   END IF                                                                       
END FUNCTION
 
FUNCTION i110_src01(p_src01)
  DEFINE p_src01     LIKE src_file.src01,
         l_eciacti   LIKE eci_file.eciacti
 
  LET g_errno = ''
  SELECT eciacti INTO l_eciacti
     FROM eci_file WHERE eci01 = p_src01
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_eciacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION i110_src02(p_src02) #可以是料號或產品別
   DEFINE p_src02   LIKE ima_file.ima01,
          l_imaacti LIKE ima_file.imaacti,
          l_cnt     LIKE type_file.num10          #No.FUN-680130  INTEGER
 
   LET g_errno = ''
   SELECT imaacti INTO l_imaacti
      FROM ima_file WHERE ima01 = p_src02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
      WHEN l_imaacti='N'          LET g_errno = '9028'
  #FUN-690022------mod-------
      WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------      
      WHEN SQLCA.sqlcode<>0       LET g_errno = SQLCA.SQLCODE
      OTHERWISE                   LET g_errno = NULL
   END CASE
 
   IF g_errno='100' THEN  #若不為料號,檢查是否為產品別
      SELECT COUNT(*) INTO l_cnt FROM oba_file
         WHERE oba01=p_src02
      IF (l_cnt=0) OR SQLCA.sqlcode THEN
         LET g_errno='asr-037'
      ELSE
         LET g_errno=NULL
      END IF 
   END IF
END FUNCTION
 
FUNCTION i110_setimadesc(p_value)
  DEFINE p_value     LIKE ima_file.ima01
  DEFINE l_ima02     LIKE ima_file.ima02
  DEFINE l_ima021    LIKE ima_file.ima021
 
  SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
     WHERE ima01=p_value
 
  IF SQLCA.sqlcode THEN
     LET l_ima02 =NULL
     LET l_ima021=NULL
     SELECT oba02 INTO l_ima02 FROM oba_file
        WHERE oba01=p_value
  END IF
  RETURN l_ima02,l_ima021
END FUNCTION
 
FUNCTION i110_setecidesc(p_value)
  DEFINE p_value     LIKE eci_file.eci01
  DEFINE l_eci06     LIKE eci_file.eci06
 
  LET l_eci06 =''
  SELECT eci06 INTO l_eci06 FROM eci_file
     WHERE eci01=p_value
  RETURN l_eci06
END FUNCTION

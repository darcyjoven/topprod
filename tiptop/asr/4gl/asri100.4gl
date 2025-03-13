# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asri100.4gl
# Descriptions...: 機器(生產線)資料維護作業
# Date & Author..: 06/01/04 kim 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/30 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.MOD-740233 07/04/23 By kim 加強日期檢查
# Modify.........: No.TQC-760121 07/06/15 By Sarah 進單身按F1, 會立刻先出現 '小於今日'的錯誤訊息
# Modify.........: No.FUN-7B0103 07/11/27 By jan 報表格式修改為crystal report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_srb      RECORD LIKE srb_file.*,
     g_srb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        srb01   LIKE srb_file.srb01,
        srb02   LIKE srb_file.srb02,
        eci06   LIKE eci_file.eci06,
        srb03   LIKE srb_file.srb03,
        srb04   LIKE srb_file.srb04,
        srb05   LIKE srb_file.srb05,
        srb06   LIKE srb_file.srb06,
        gen02   LIKE gen_file.gen02,
        srbacti LIKE srb_file.srbacti        
                    END RECORD,
    g_srb_t         RECORD                 #程式變數 (舊值)
        srb01   LIKE srb_file.srb01,
        srb02   LIKE srb_file.srb02,
        eci06   LIKE eci_file.eci06,
        srb03   LIKE srb_file.srb03,
        srb04   LIKE srb_file.srb04,
        srb05   LIKE srb_file.srb05,
        srb06   LIKE srb_file.srb06,
        gen02   LIKE gen_file.gen02,
        srbacti LIKE srb_file.srbacti        
                    END RECORD,
    g_wc2,g_sql,g_wc1    LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(300)
    g_rec_b              LIKE type_file.num5,   #單身筆數  #No.FUN-680130 SMALLINT
    l_ac                 LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680130 SMALLINT
 
DEFINE g_forupd_sql    STRING                   #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680130 INTEGER
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose   #No.FUN-680130 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5     #No.FUN-680130 SMALLINT
DEFINE l_table               STRING          #No.FUN-7BO103                                                                         
DEFINE g_str                 STRING          #No.FUN-7B0103
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-680130 SMALLINT
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
   LET g_sql="srb01.srb_file.srb01,",     
             "srb02.srb_file.srb02,",                                                                                          
             "eci06.eci_file.eci06,",                                                                                               
             "srb03.srb_file.srb03,",                                                                                               
             "srb04.srb_file.srb04,",                                                                                               
             "srb05.srb_file.srb05,",
             "srb06.srb_file.srb06,",
             "gen02.gen_file.gen02,",                                                                                               
             "srbacti.srb_file.srbacti"                                                                                           
    LET l_table=cl_prt_temptable("asri100",g_sql) CLIPPED                                                                            
    IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?)"                                                                                           
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err("insert_prep:",status,1)                                                                                         
    END IF                                                                                                                          
#No.FUN-7B0013--END
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i100_w AT p_row,p_col WITH FORM "asr/42f/asri100"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i100_b_fill(g_wc2)
    CALL i100_menu()
    CLOSE WINDOW i100_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gendata"
            IF cl_chk_act_auth() THEN
              CALL i100_gen()
            END IF
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_srb[l_ac].srb01 IS NOT NULL THEN
                  LET g_doc.column1 = "srb01"
                  LET g_doc.value1 = g_srb[l_ac].srb01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_srb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_q()
   CALL i100_b_askkey()
END FUNCTION
 
FUNCTION i100_b()
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
 
   LET g_forupd_sql = "SELECT *  FROM srb_file WHERE srb01= ? AND srb02= ? AND srb03= ? AND srb04= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_srb WITHOUT DEFAULTS FROM s_srb.*
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
             CALL i100_set_entry(p_cmd)                                         
             CALL i100_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
             LET g_srb_t.* = g_srb[l_ac].*  #BACKUP
             OPEN i100_bcl USING g_srb_t.srb01,g_srb_t.srb02,
                                 g_srb_t.srb03,g_srb_t.srb04
             IF STATUS THEN
                CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i100_bcl INTO m_srb.* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_srb_t.srb01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()
          END IF
       #MOD-740233..............begin
       AFTER FIELD srb01
          IF (NOT cl_null(g_srb[l_ac].srb01)) AND g_srb[l_ac].srb01<g_today THEN
             IF g_srb[l_ac].srb01 != g_srb_t.srb01 THEN   #TQC-760121 add
                CALL cl_err('','asr-049',1)
                NEXT FIELD srb01                          #TQC-760121 add
             END IF                                       #TQC-760121 add
          END IF
       #MOD-740233..............end
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                       
          CALL i100_set_entry(p_cmd)                                            
          CALL i100_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_srb[l_ac].* TO NULL
          LET g_srb[l_ac].srbacti = 'Y'       #Body default
          LET g_srb_t.* = g_srb[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()
          NEXT FIELD srb01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i100_bcl
             CANCEL INSERT
          END IF
          INSERT INTO srb_file(srb01,srb02,srb03,srb04,srb05,srb06,srbacti)
          VALUES(g_srb[l_ac].srb01,g_srb[l_ac].srb02,g_srb[l_ac].srb03,g_srb[l_ac].srb04,
                 g_srb[l_ac].srb05,g_srb[l_ac].srb06,g_srb[l_ac].srbacti)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_srb[l_ac].srb01,SQLCA.sqlcode,0)   #No.FUN-660138
             CALL cl_err3("ins","srb_file",g_srb[l_ac].srb01,g_srb[l_ac].srb02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD srb02
          IF cl_null(g_srb[l_ac].srb02) THEN
            NEXT FIELD srb02
          ELSE
            IF g_srb[l_ac].srb02!=g_srb_t.srb02 OR g_srb_t.srb02 IS NULL THEN
              CALL i100_srb02(g_srb[l_ac].srb02)
              IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                LET g_srb[l_ac].srb02=g_srb_t.srb02
                LET g_srb[l_ac].eci06=g_srb_t.eci06
                DISPLAY BY NAME g_srb[l_ac].srb02
                DISPLAY BY NAME g_srb[l_ac].eci06
                NEXT FIELD srb02
              END IF
              LET g_srb[l_ac].eci06=''
              SELECT eci06 INTO g_srb[l_ac].eci06 FROM eci_file 
                WHERE eci01=g_srb[l_ac].srb02
              DISPLAY BY NAME g_srb[l_ac].eci06
            END IF
          END IF
 
       AFTER FIELD srb03 #維修開始時間
          IF NOT cl_null(g_srb[l_ac].srb03) THEN
             CALL i100_chk_time(g_srb[l_ac].srb03)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_srb[l_ac].srb03,g_errno,1)
                LET g_srb[l_ac].srb03=g_srb_t.srb03
                DISPLAY BY NAME g_srb[l_ac].srb03
                NEXT FIELD srb03
             END IF
          END IF
 
       AFTER FIELD srb04 #維修結束時間
          IF NOT cl_null(g_srb[l_ac].srb04) THEN
             CALL i100_chk_time(g_srb[l_ac].srb04)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_srb[l_ac].srb04,g_errno,1)
                LET g_srb[l_ac].srb04=g_srb_t.srb04
                DISPLAY BY NAME g_srb[l_ac].srb04
                NEXT FIELD srb04
             END IF
          END IF
          CALL i100_cacl_time(g_srb[l_ac].srb03,g_srb[l_ac].srb04) 
             RETURNING g_srb[l_ac].srb05 
          IF NOT cl_null(g_errno) THEN
             LET g_srb[l_ac].srb04=g_srb_t.srb04
             LET g_srb[l_ac].srb05=g_srb_t.srb05
             DISPLAY BY NAME g_srb[l_ac].srb04
             DISPLAY BY NAME g_srb[l_ac].srb05
             CALL cl_err('cal time',g_errno,1)
             NEXT FIELD srb04
          END IF
          DISPLAY BY NAME g_srb[l_ac].srb05
 
       AFTER FIELD srb06
          IF NOT cl_null(g_srb[l_ac].srb06) THEN
             IF g_srb[l_ac].srb06!=g_srb_t.srb06 OR g_srb_t.srb06 IS NULL THEN
               CALL i100_srb06(g_srb[l_ac].srb06)
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 LET g_srb[l_ac].srb06=g_srb_t.srb06
                 LET g_srb[l_ac].gen02=g_srb_t.gen02
                 DISPLAY BY NAME g_srb[l_ac].srb06
                 DISPLAY BY NAME g_srb[l_ac].gen02
                 NEXT FIELD srb06
               END IF
               LET g_srb[l_ac].gen02=''
               SELECT gen02 INTO g_srb[l_ac].gen02 FROM gen_file 
                 WHERE gen01=g_srb[l_ac].srb06
               DISPLAY BY NAME g_srb[l_ac].gen02
             END IF
          END IF
              
       AFTER FIELD srbacti
          IF NOT cl_null(g_srb[l_ac].srbacti) THEN
             IF g_srb[l_ac].srbacti NOT MATCHES '[YN]' THEN 
                LET g_srb[l_ac].srbacti = g_srb_t.srbacti
                NEXT FIELD srbacti
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_srb_t.srb01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "srb01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_srb[l_ac].srb01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM srb_file WHERE srb01 = g_srb_t.srb01
                                    AND srb02 = g_srb_t.srb02
                                    AND srb03 = g_srb_t.srb03
                                    AND srb04 = g_srb_t.srb04
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_srb_t.srb01,SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("del","srb_file",g_srb_t.srb01,g_srb_t.srb02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
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
             LET g_srb[l_ac].* = g_srb_t.*
             CLOSE i100_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_srb[l_ac].srb01,-263,0)
             LET g_srb[l_ac].* = g_srb_t.*
          ELSE
             UPDATE srb_file SET srb01=g_srb[l_ac].srb01,
                                 srb02=g_srb[l_ac].srb02,
                                 srb03=g_srb[l_ac].srb03,
                                 srb04=g_srb[l_ac].srb04,
                                 srb05=g_srb[l_ac].srb05,
                                 srb06=g_srb[l_ac].srb06,
                                 srbacti=g_srb[l_ac].srbacti
              WHERE srb01 = g_srb_t.srb01
                AND srb02 = g_srb_t.srb02
                AND srb03 = g_srb_t.srb03
                AND srb04 = g_srb_t.srb04
             IF SQLCA.sqlcode THEN
#               CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("upd","srb_file",g_srb[l_ac].srb01,g_srb[l_ac].srb02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
                LET g_srb[l_ac].* = g_srb_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
#         LET l_ac_t = l_ac                # 新增   #FUN-D40030 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_srb[l_ac].* = g_srb_t.*
             #FUN-D40030---add---str---
             ELSE
                CALL g_srb.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030---add---end---
             END IF
             CLOSE i100_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac                         #FUN-D40030 add 
          CLOSE i100_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(srb01) AND l_ac > 1 THEN
             LET g_srb[l_ac].* = g_srb[l_ac-1].*
             NEXT FIELD srb01
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(srb02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_eci"
                CALL cl_create_qry() RETURNING g_srb[l_ac].srb02
                DISPLAY BY NAME g_srb[l_ac].srb02
                NEXT FIELD srb02
             WHEN INFIELD(srb06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                CALL cl_create_qry() RETURNING g_srb[l_ac].srb06
                DISPLAY BY NAME g_srb[l_ac].srb06
                NEXT FIELD srb06
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
 
   CLOSE i100_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i100_b_askkey()
 
   CLEAR FORM
   CALL g_srb.clear()
   CONSTRUCT g_wc2 ON srb01,srb02,srb03,srb04,srb05,srb06,srbacti
        FROM s_srb[1].srb01,s_srb[1].srb02,s_srb[1].srb03,
             s_srb[1].srb04,s_srb[1].srb05,s_srb[1].srb06,
             s_srb[1].srbacti
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP     #查詢條件
          CASE
             WHEN INFIELD(srb02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_eci"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_srb[1].srb02
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srb02
                NEXT FIELD srb02
             WHEN INFIELD(srb06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret 
                DISPLAY g_qryparam.multiret TO srb06
                NEXT FIELD srb06
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN 
     LET INT_FLAG = 0 
     RETURN 
   END IF
 
   CALL i100_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    LET g_sql =
        "SELECT srb01,srb02,'',srb03,srb04,srb05,srb06,'',srbacti",
        " FROM srb_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY srb02,srb01,srb03,srb04"
    PREPARE i100_pb FROM g_sql
    DECLARE srb_curs CURSOR FOR i100_pb
 
    CALL g_srb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH srb_curs INTO g_srb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT 
       FOREACH END IF
       LET g_srb[g_cnt].eci06=''
       SELECT eci06 INTO g_srb[g_cnt].eci06 FROM eci_file 
         WHERE eci01=g_srb[g_cnt].srb02
       LET g_srb[g_cnt].gen02=''  
       SELECT gen02 INTO g_srb[g_cnt].gen02 FROM gen_file
         WHERE gen01=g_srb[g_cnt].srb06
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_srb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_srb TO s_srb.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      # Spsrbal 4ad ACTION
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
 
      ON ACTION gendata
         LET g_action_choice = 'gendata'
         EXIT DISPLAY
   
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
 
FUNCTION i100_out()
    DEFINE
        l_srb           RECORD 
                          srb01   LIKE srb_file.srb01,
                          srb02   LIKE srb_file.srb02,
                          eci06   LIKE eci_file.eci06,
                          srb03   LIKE srb_file.srb03,
                          srb04   LIKE srb_file.srb04,
                          srb05   LIKE srb_file.srb05,
                          srb06   LIKE srb_file.srb06,
                          gen02   LIKE gen_file.gen02,
                          srbacti LIKE srb_file.srbacti        
                        END RECORD,
        l_i             LIKE type_file.num5,          #No.FUN-680130 SMALLINT
        l_name          LIKE type_file.chr20          # External(Disk) file name  #No.FUN-680130 VARCHAR(20)
                        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
    CALL cl_del_data(l_table)                                #No.FUN-7B0103                                                         
    LET g_str=''                                             #No.FUN-7B0103                                                         
    SELECT zz05 INTO g_zz05 FROM  zz_file WHERE zz01=g_prog  #No.FUN-7B0103
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT srb01,srb02,'',srb03,srb04,srb05,srb06,'',srbacti FROM srb_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i100_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i100_co                         # SCROLL CURSOR
         CURSOR FOR i100_p1
 
#   CALL cl_outnam('asri100') RETURNING l_name       #No.FUN-7B0103
#   START REPORT i100_rep TO l_name                  #No.FUN-7B0103
 
    FOREACH i100_co INTO l_srb.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
       LET l_srb.eci06=''
       SELECT eci06 INTO l_srb.eci06 FROM eci_file
         WHERE eci01=l_srb.srb02
       LET l_srb.gen02=''
       SELECT gen02 INTO l_srb.gen02 FROM gen_file
         WHERE gen01=l_srb.srb06
#No.FUN-7B0103--BEGIN--
#        OUTPUT TO REPORT i100_rep(l_srb.*)
         EXECUTE insert_prep USING l_srb.srb01,l_srb.srb02,l_srb.eci06,l_srb.srb03,                                                      
                                   l_srb.srb04,l_srb.srb05,l_srb.srb06,l_srb.gen02,
                                   l_srb.srbacti
#No.FUN-7BO103--END--
    END FOREACH
#No;FUN-7B0103--BEGIN--
#   FINISH REPORT i100_rep
 
#   CLOSE i100_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                  
    IF g_zz05='Y' THEN                                                                                                              
       CALL cl_wcchp(g_wc2,'srb01,srb02,srb03,srb04,srb05,srb06,srbacti')                                                             
       RETURNING g_wc2                                                                                                               
    END IF                                                                                                                          
    LET g_str=g_wc2                                                                                                                  
    CALL cl_prt_cs3('asri100','asri100',g_sql,g_str)
#No.FUN-7B0103--END
END FUNCTION
#No.FUN-7B0103--BEGIN
{
REPORT i100_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680130 VARCHAR(1)
        l_chr           LIKE type_file.chr1,    #No.FUN-680130 VARCHAR(1)
        sr              RECORD 
                          srb01   LIKE srb_file.srb01,
                          srb02   LIKE srb_file.srb02,
                          eci06   LIKE eci_file.eci06,
                          srb03   LIKE srb_file.srb03,
                          srb04   LIKE srb_file.srb04,
                          srb05   LIKE srb_file.srb05,
                          srb06   LIKE srb_file.srb06,
                          gen02   LIKE gen_file.gen02,
                          srbacti LIKE srb_file.srbacti        
                        END RECORD
        
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.srb02,sr.srb01
 
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
            PRINT COLUMN g_c[31],sr.srb01,
                  COLUMN g_c[32],sr.srb02,
                  COLUMN g_c[33],sr.eci06,
                  COLUMN g_c[34],sr.srb03,' ~ ',sr.srb04,
                  COLUMN g_c[35],cl_numfor(sr.srb05,35,3),
                  COLUMN g_c[36],sr.srb06,
                  COLUMN g_c[37],sr.gen02,
                  COLUMN g_c[38],sr.srbacti
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
                                                    
FUNCTION i100_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("srb01,srb02,srb03,srb04",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i100_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("srb01,srb02,srb03,srb04",FALSE)
   END IF                                                                       
END FUNCTION
 
FUNCTION i100_srb02(p_srb02)
  DEFINE p_srb02     LIKE srb_file.srb02,
         l_eciacti   LIKE eci_file.eciacti
 
  LET g_errno = ' '
  SELECT eciacti INTO l_eciacti
     FROM eci_file WHERE eci01 = p_srb02
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_eciacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION i100_srb06(p_srb06)
  DEFINE p_srb06   LIKE srb_file.srb06
  DEFINE l_genacti LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT genacti INTO l_genacti FROM gen_file
    WHERE gen01 = p_srb06
 
  CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
       WHEN l_genacti = 'N'     LET g_errno = '9028'
       WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
  END CASE
 
END FUNCTION
 
FUNCTION i100_chk_time(p_time)
  DEFINE p_time    LIKE type_file.chr8           #No.FUN-680130 VARCHAR(05)
  DEFINE l_str     STRING 
  DEFINE l_i LIKE type_file.num5 #MOD-740324
 
  LET g_errno=''
  IF (p_time[1,2] < 0) OR (p_time[1,2] > 23) THEN 
#     LET g_errno='apy-080'                        #CHI-B40058
     LET g_errno='asr-057'                         #CHI-B40058
  END IF
  IF (p_time[4,5] < 0) OR (p_time[4,5] > 59) THEN 
#     LET g_errno='apy-080'                        #CHI-B40058
     LET g_errno='asr-057'                         #CHI-B40058
  END IF
  LET l_str=p_time
  LET l_str=l_str.trim()
  IF Length(l_str)<5 THEN
    LET g_errno='aem-006'
  END IF
  #MOD-740324..........begin
  FOR l_i=1 TO 5
     IF l_i=3 THEN
        CONTINUE FOR
     END IF
     IF NOT (p_time[l_i,l_i] MATCHES '[0123456789]') THEN
#         LET g_errno='apy-080'      #CHI-B40058
         LET g_errno='asr-057'       #CHI-B40058 
         EXIT FOR
     END IF
  END FOR
  #MOD-740324..........end
END FUNCTION
 
FUNCTION i100_cacl_time(p_srb03,p_srb04)
  DEFINE p_srb03       LIKE srb_file.srb03
  DEFINE p_srb04,l_tot LIKE srb_file.srb04
  DEFINE l_str         STRING 
  DEFINE l_hr,l_min    LIKE type_file.num5            #No.FUN-680130 SMALLINT
 
  LET g_errno=''
  LET l_tot=0 
  LET l_str=p_srb03
  LET l_str=l_str.trim()
  IF (cl_null(l_str)) OR (l_str=':') THEN
    RETURN l_tot 
  END IF
  LET l_str=p_srb04
  LET l_str=l_str.trim()
  IF (cl_null(l_str)) OR (l_str=':') THEN
    RETURN l_tot 
  END IF
  LET l_hr=p_srb04[1,2]-p_srb03[1,2]
  IF l_hr<0 THEN
    LET l_hr=l_hr+24
  END IF
  LET l_hr=60*l_hr
 
  LET l_min=p_srb04[4,5]-p_srb03[4,5]
 
  LET l_tot=l_hr+l_min
 
  IF l_tot<0 THEN
    LET g_errno='asr-002'
    LET l_tot=0
  END IF
  
  LET l_tot=l_tot/60
  RETURN l_tot
END FUNCTION
 
FUNCTION i100_gen()
   DEFINE tm RECORD
               srb02      LIKE srb_file.srb02,    
               a2_b,a2_e  LIKE type_file.dat,        #No.FUN-680130 DATE
               a3         LIKE type_file.num5,       #No.FUN-680130 SMALLINT   
               a4         LIKE type_file.num5,       #No.FUN-680130 SMALLINT   
               srb06      LIKE srb_file.srb06,    
               srb03      LIKE srb_file.srb03,    
               srb04      LIKE srb_file.srb04,    
               srb05      LIKE srb_file.srb05
             END RECORD, 
          l_eci06      LIKE eci_file.eci06,
          l_gen02      LIKE gen_file.gen02,
          l_i        LIKE type_file.num10,         #No.FUN-680130 INTEGER
          l_dt       LIKE type_file.dat,           #No.FUN-680130 DATE
          l_str      STRING, 
          l_yy,l_mm,l_dd  LIKE type_file.dat,      #No.FUN-680130 DATE
          l_tenday   LIKE type_file.dat    #旬用   #No.FUN-680130 DATE
 
   OPEN WINDOW i100_gen AT 2,2 WITH FORM "asr/42f/asri1001" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("asri1001")
 
  #INPUT BY NAME srb02,a2_b,a2_e,a3,a4,srb06,srb03,srb04,srb05
   INPUT BY NAME tm.*
 
     AFTER FIELD srb02
        IF NOT cl_null(tm.srb02) THEN
           CALL i100_srb02(tm.srb02)
           IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,1)
             LET tm.srb02=''
             LET l_eci06=''
             DISPLAY BY NAME tm.srb02
             DISPLAY l_eci06 TO FORMONLY.eci06
             NEXT FIELD srb02
           END IF
           LET l_eci06=''
           SELECT eci06 INTO l_eci06 FROM eci_file 
             WHERE eci01=tm.srb02
           DISPLAY l_eci06 TO FORMONLY.eci06
        END IF
     AFTER FIELD srb06
        IF NOT cl_null(tm.srb06) THEN
           CALL i100_srb06(tm.srb06)
           IF NOT cl_null(g_errno) THEN
             CALL cl_err('',g_errno,1)
             LET tm.srb06=''
             LET l_gen02=''
             DISPLAY BY NAME tm.srb06
             DISPLAY l_gen02 TO FORMONLY.gen02
             NEXT FIELD srb06
           END IF
           LET l_gen02=''
           SELECT gen02 INTO l_gen02 FROM gen_file 
             WHERE gen01=l_srb06
           DISPLAY l_gen02 TO FORMONLY.gen02
        ELSE
           LET l_gen02=''
           DISPLAY l_gen02 TO FORMONLY.gen02
        END IF
     AFTER FIELD a3
        LET tm.a4=''
     AFTER FIELD a4
        CASE tm.a3
          WHEN "1"
            IF tm.a4>31 OR tm.a4<=0 THEN 
#               CALL cl_err(tm.a4,'apy-000',1)     #CHI-B40058
               CALL cl_err(tm.a4,'alm-729',1)      #CHI-B40058
               LET tm.a4=''
               DISPLAY BY NAME tm.a4
               NEXT FIELD tm.a4
            END IF
          WHEN "2"
            IF tm.a4>10 OR tm.a4<=0 THEN 
               CALL cl_err(tm.a4,'anm-005',1)
               LET tm.a4=''
               DISPLAY BY NAME tm.a4
               NEXT FIELD a4
            END IF
          WHEN "3"
            IF tm.a4>6 OR tm.a4<0 THEN 
               CALL cl_err(tm.a4,'asr-003',1)
               LET tm.a4=''
               DISPLAY BY NAME tm.a4
               NEXT FIELD a4
            END IF
          OTHERWISE
             
        END CASE
       AFTER FIELD srb03 #維修開始時間
          IF NOT cl_null(tm.srb03) THEN
             CALL i100_chk_time(tm.srb03)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(tm.srb03,g_errno,1)
                LET tm.srb03=''
                DISPLAY BY NAME tm.srb03
                NEXT FIELD srb03
             END IF
          END IF
 
       AFTER FIELD srb04 #維修結束時間
          IF NOT cl_null(tm.srb04) THEN
             CALL i100_chk_time(tm.srb04)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(tm.srb04,g_errno,1)
                LET tm.srb04=''
                DISPLAY BY NAME tm.srb04
                NEXT FIELD srb04
             END IF
          END IF
          CALL i100_cacl_time(tm.srb03,tm.srb04) 
             RETURNING tm.srb05 
          IF NOT cl_null(g_errno) THEN
             LET tm.srb04=''
             LET tm.srb05=''
             DISPLAY BY NAME tm.srb04
             DISPLAY BY NAME tm.srb05
             CALL cl_err('cal time',g_errno,1)
             NEXT FIELD srb04
          END IF
          DISPLAY BY NAME tm.srb05
     ON ACTION controlp
        CASE
           WHEN INFIELD(srb02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_eci"
              CALL cl_create_qry() RETURNING tm.srb02
              DISPLAY BY NAME tm.srb02 
              NEXT FIELD srb02
           WHEN INFIELD(srb06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              CALL cl_create_qry() RETURNING tm.srb06
              DISPLAY BY NAME tm.srb06
              NEXT FIELD srb06
           OTHERWISE EXIT CASE
        END CASE
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT 
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
   
   END INPUT
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW i100_gen
      RETURN
   END IF
   
   LET l_yy=YEAR(tm.a2_b)
   LET l_mm=MONTH(tm.a2_b)
   LET l_dd=DAY(tm.a2_b)
  #LET l_str=l_yy,'/',l_mm,'/',l_dd
   LET tm.a2_b=tm.a2_b
   LET tm.a2_e=tm.a2_e
  #LET l_dt=DATE(l_str)
   LET l_tenday=tm.a4
   IF tm.a3='3' THEN
      LET l_dt=tm.a2_b
      WHILE NOT (tm.a4=WEEKDAY(l_dt)) #FIND the first day of Week
         LET l_dt=l_dt+1 
      END WHILE 
   END IF
   LET g_success='Y'
   BEGIN WORK
   WHILE TRUE
      CASE tm.a3
        WHEN "1" #月
           LET l_dt=MDY(l_mm,tm.a4,l_yy)
           IF (cl_null(l_dt)) OR (l_dt IS NULL) THEN
             #若當月無此日期,則以當月最後一天為維修日
             LET l_dt=i100_GETLASTDAY(MDY(l_mm,1,l_yy))
 
             #LET g_success='N'
             #CALL cl_err(l_dt,-1218,1)
             #EXIT WHILE
           END IF
           LET l_mm=l_mm+1
           IF l_mm>12 THEN
              LET l_mm=1
              LET l_yy=l_yy+1
           END IF
           IF l_dt<tm.a2_b THEN
              CONTINUE WHILE
           END IF 
           IF l_dt>tm.a2_e THEN
              EXIT WHILE
           END IF
        WHEN "2" #旬
           LET l_dt=MDY(l_mm,l_tenday,l_yy)
           IF (cl_null(l_dt)) OR (l_dt IS NULL) THEN
             LET l_mm=l_mm+1
             LET l_tenday=tm.a4
             IF l_mm>12 THEN
                LET l_mm=1
                LET l_yy=l_yy+1
             END IF
             CONTINUE WHILE
           ELSE
             LET l_tenday=l_tenday+10
           END IF
           IF l_dt<tm.a2_b THEN
              CONTINUE WHILE
           END IF 
           IF l_dt>tm.a2_e THEN
              EXIT WHILE
           END IF
 
        WHEN "3" #週
           IF l_dt>tm.a2_e THEN
              EXIT WHILE
           END IF
        
        OTHERWISE
          LET g_success='N'
          EXIT WHILE 
      END CASE
      INSERT INTO srb_file (srb01,srb02,srb03,srb04,srb05,srb06,srbacti) 
           VALUES (l_dt,tm.srb02,tm.srb03,tm.srb04,tm.srb05,tm.srb06,'Y')
      IF SQLCA.sqlcode THEN
#        CALL cl_err('gen data',SQLCA.sqlcode,1)   #No.FUN-660138
         CALL cl_err3("ins","srb_file",l_dt,tm.srb02,SQLCA.sqlcode,"","gen data",1)  #No.FUN-660138
         LET g_success='N'
         EXIT WHILE
      END IF
      IF tm.a3='3' THEN
         LET l_dt=l_dt+7
      END IF 
   END WHILE
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','asr-026',1)
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE WINDOW i100_gen
END FUNCTION
 
FUNCTION i100_GETLASTDAY(p_date)
DEFINE p_date LIKE type_file.dat               #No.FUN-680130 DATE 
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
   END IF
END FUNCTION

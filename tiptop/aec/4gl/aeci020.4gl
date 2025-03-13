# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: aeci020.4gl
# Descriptions...: 異常除外代號維護作業
# Date & Author..: 99/04/28 By Iceman 
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.FUN-780037 07/07/04 By sherry 報表格式修改為p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60170 10/06/29 By Carrier aag00条件外联
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_sgb           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        sgb01       LIKE sgb_file.sgb01,   #異常代號 
        sgb05       LIKE sgb_file.sgb05,   #異常說明
        sgb04       LIKE sgb_file.sgb04,   #屬性
        sgf02       LIKE sgf_file.sgf02,   #
        sgb06       LIKE sgb_file.sgb06,   #會計科目
        aag02       LIKE aag_file.aag02    #科目名稱
                    END RECORD,
    g_sgb_t         RECORD                 #程式變數 (舊值)
        sgb01       LIKE sgb_file.sgb01,   #異常代號 
        sgb05       LIKE sgb_file.sgb05,   #異常說明
        sgb04       LIKE sgb_file.sgb04,   #屬性
        sgf02       LIKE sgf_file.sgf02,   #
        sgb06       LIKE sgb_file.sgb06,   #會計科目
        aag02       LIKE aag_file.aag02    #科目名稱
                    END RECORD,
     g_wc2,g_sql,g_wc1    STRING,  #No.FUN-580092 HCN 
    g_flag          LIKE type_file.chr1,     #判斷誤動作存入        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_za05          LIKE type_file.chr1000,  # No.FUN-680073  VARCHAR(40)
    g_rec_b         LIKE type_file.num5,     #單身筆數        #No.FUN-680073 SMALLINT
    p_row,p_col     LIKE type_file.num5,     #No.FUN-680073 SMALLINT SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110          #No.FUN-680073 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
    LET p_row = 4 LET p_col = 4 
    OPEN WINDOW i020_w AT p_row,p_col WITH FORM "aec/42f/aeci020"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i020_b_fill(g_wc2)
    ERROR ""
    CALL i020_menu()
    CLOSE WINDOW i020_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
END MAIN
 
FUNCTION i020_menu()
 
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
            #No.FUN-780037---Begin    
            # CALL i020_out() 
              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                 
              LET l_cmd = 'p_query "aeci020" "',g_wc2 CLIPPED,'"'              
              CALL cl_cmdrun(l_cmd)   
            #No.FUN-780037---End
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgb),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i020_q()
   CALL i020_b_askkey()
END FUNCTION
 
FUNCTION i020_b()
DEFINE
    l_sgb01         LIKE  sgb_file.sgb01,
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    s_acct          LIKE aab_file.aab02,     # No.FUN-680073  VARCHAR(06),   #SELECT npu_cost number880110 
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,     # No.FUN-680073  VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1      # No.FUN-680073  VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sgb01, sgb05, sgb04, '', sgb06, '' FROM sgb_file WHERE sgb01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_sgb WITHOUT DEFAULTS FROM s_sgb.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sgb_t.* = g_sgb[l_ac].*  #BACKUP
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i020_set_entry(p_cmd)                                                                                           
               CALL i020_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--  
               BEGIN WORK
               OPEN i020_bcl USING g_sgb_t.sgb01
               IF STATUS THEN
                  CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i020_bcl INTO g_sgb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_sgb_t.sgb01,STATUS,1) 
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT sgf02 INTO g_sgb[l_ac].sgf02 FROM sgf_file 
                   WHERE sgf01 = g_sgb[l_ac].sgb04 
                  SELECT aag02 INTO g_sgb[l_ac].aag02
                    FROM aag_file
                   WHERE aag01 = g_sgb[l_ac].sgb06 
                     AND aag00 = g_aza.aza81  #No.FUN-730033
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i020_set_entry(p_cmd)                                                                                           
            CALL i020_set_no_entry(p_cmd)                                                                                        
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--  
            INITIALIZE g_sgb[l_ac].* TO NULL      #900423
            LET g_sgb_t.* = g_sgb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgb01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO sgb_file(sgb01,sgb05,sgb04,sgb06)
         VALUES (
            g_sgb[l_ac].sgb01,g_sgb[l_ac].sgb05,g_sgb[l_ac].sgb04,
            g_sgb[l_ac].sgb06)
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sgb[l_ac].sgb01,SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","sgb_file",g_sgb[l_ac].sgb01,"",SQLCA.sqlcode,"","",1) #FUN-660091
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD sgb01                        # CHK 異常代號
            IF NOT cl_null(g_sgb[l_ac].sgb01) THEN
            IF g_sgb[l_ac].sgb01  IS NOT NULL AND
               (g_sgb[l_ac].sgb01 != g_sgb_t.sgb01  OR
                g_sgb_t.sgb01 IS  NULL)  THEN
               IF cl_null(g_sgb[l_ac].sgb01) THEN
                    NEXT FIELD sgb01
               END IF
              SELECT COUNT(*) INTO l_n FROM sgb_file
                            WHERE sgb01 = g_sgb[l_ac].sgb01
              IF l_n > 0 THEN 
                 CALL cl_err('','aec-007',0) NEXT FIELD sgb01
              END IF
            END IF
            END IF
 
        BEFORE FIELD sgb05 
            IF g_sgb[l_ac].sgb01 != g_sgb_t.sgb01  OR
                cl_null(g_sgb_t.sgb01)  THEN
                  SELECT COUNT(*) INTO l_n FROM  sgb_file
                   WHERE sgb01 = g_sgb[l_ac].sgb01
                    IF l_n > 0 THEN 
                       CALL cl_err('','aec-008',0) 
                       NEXT FIELD sgb01
                    END IF
            END IF
 
        AFTER FIELD sgb04                        # CHK 異常屬性
            IF NOT cl_null(g_sgb[l_ac].sgb04) THEN
            SELECT sgf02 INTO g_sgb[l_ac].sgf02 FROM sgf_file 
             WHERE sgf01 = g_sgb[l_ac].sgb04 
            IF STATUS THEN
#              CALL cl_err('sel sgf',STATUS,0) #No.FUN-660091
               CALL cl_err3("sel","sgf_file",g_sgb[l_ac].sgb04,"",STATUS,"","",1) #FUN-660091
               NEXT FIELD sgb04
            END IF
            END IF
 
        AFTER FIELD sgb06                       #會計科目 
            IF NOT cl_null(g_sgb[l_ac].sgb06) THEN 
               CALL i020_sgb06('a') 
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_sgb[l_ac].sgb06 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_sgb[l_ac].sgb06 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_sgb[l_ac].sgb06
                  DISPLAY BY NAME g_sgb[l_ac].sgb06  
                  #FUN-B10049--end                      
                  NEXT FIELD sgb06
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
             IF NOT cl_null( g_sgb_t.sgb01) THEN 
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
            DELETE FROM sgb_file
                WHERE sgb01 = g_sgb_t.sgb01
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_sgb_t.sgb01,SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("del","sgb_file",g_sgb_t.sgb01,"",SQLCA.sqlcode,"","",1) #FUN-660091
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK" 
            CLOSE i020_bcl     
            COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_sgb[l_ac].* = g_sgb_t.*
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_sgb[l_ac].sgb01,-263,1)
              LET g_sgb[l_ac].* = g_sgb_t.*
           ELSE
              UPDATE sgb_file SET sgb01=g_sgb[l_ac].sgb01,
                                  sgb05=g_sgb[l_ac].sgb05,
                                  sgb04=g_sgb[l_ac].sgb04,
                                  sgb06=g_sgb[l_ac].sgb06
              WHERE sgb01 = g_sgb_t.sgb01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err('update sgb error',SQLCA.SQLCODE,0) #No.FUN-660091
                   CALL cl_err3("upd","sgb_file",g_sgb_t.sgb01,"",SQLCA.SQLCODE,"","update sgb error",1) #FUN-660091
                   LET g_sgb[l_ac].* = g_sgb_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i020_bcl
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd='u' THEN
                  LET g_sgb[l_ac].* = g_sgb_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i020_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i020_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i020_b_askkey()
            EXIT INPUT
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgb04)  
                 CALL cl_init_qry_var()
		 LET g_qryparam.state = "i"
                 LET g_qryparam.form = "q_sgf"
                 LET g_qryparam.default1 = g_sgb[l_ac].sgb04
                 CALL cl_create_qry() RETURNING g_sgb[l_ac].sgb04
#                 CALL FGL_DIALOG_SETBUFFER( g_sgb[l_ac].sgb04 )
                 DISPLAY BY NAME g_sgb[l_ac].sgb04 
                 NEXT FIELD sgb04 
              WHEN INFIELD(sgb06)
    		 CALL cl_init_qry_var()
		 LET g_qryparam.state = "i"
   		 LET g_qryparam.form = "q_aag"
   		 LET g_qryparam.default1 = g_sgb[l_ac].sgb06 
                 LET g_qryparam.arg1 = g_aza.aza81   #No.FUN-730033
   		 CALL cl_create_qry() RETURNING g_sgb[l_ac].sgb06
   		 CALL FGL_DIALOG_SETBUFFER( g_sgb[l_ac].sgb06 )
                 DISPLAY BY NAME g_sgb[l_ac].sgb06 
                 NEXT FIELD sgb06 
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
       
        ON ACTION CONTROLO                        #沿用所有欄位
            IF  l_ac > 1 THEN
                LET g_sgb[l_ac].* = g_sgb[l_ac-1].*
                NEXT FIELD sgb01
            END IF
 
 
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
 
 
FUNCTION i020_sgb06(p_cmd)
    DEFINE   p_cmd        LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ''
    SELECT aag02,aagacti  INTO g_sgb[l_ac].aag02,l_aagacti 
    FROM   aag_file
    WHERE  aag01 = g_sgb[l_ac].sgb06 
      AND  aag00 = g_aza.aza81  #No.FUN-730033
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1004'
                                   LET g_sgb[l_ac].aag02 = NULL
         WHEN l_aagacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
END FUNCTION
 
FUNCTION i020_b_askkey()
    CLEAR FORM
    CALL g_sgb.clear()
    CONSTRUCT g_wc2 ON sgb01, sgb05, sgb04, sgb06
            FROM s_sgb[1].sgb01, s_sgb[1].sgb05, s_sgb[1].sgb04,
                 s_sgb[1].sgb06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgb04)  
                 CALL cl_init_qry_var()
		 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_sgf"
                 LET g_qryparam.default1 = g_sgb[1].sgb04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO bga04  
                 NEXT FIELD sgb04 
              WHEN INFIELD(sgb06)
    		 CALL cl_init_qry_var()
		 LET g_qryparam.state = "c"
   		 LET g_qryparam.form = "q_aag"
   		 LET g_qryparam.default1 = g_sgb[1].sgb06 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO bga06  
                 NEXT FIELD sgb06 
              OTHERWISE
                 EXIT CASE
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
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
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
    p_wc2        LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(200)
 
    #No.MOD-A60170  --Begin
    LET g_sql = " SELECT sgb01,sgb05,sgb04,sgf02,sgb06,aag02",
                "   FROM sgb_file LEFT OUTER JOIN sgf_file ON sgb_file.sgb04 = sgf_file.sgf01 ",
                "                 LEFT OUTER JOIN aag_file ON sgb_file.sgb06 = aag_file.aag01", 
                "                                         AND aag_file.aag00 = '",g_aza.aza81,"'",
                "  WHERE ", p_wc2 CLIPPED,
                "  ORDER BY sgb01"
    #No.MOD-A60170  --End  
    PREPARE i020_pb FROM g_sql
    DECLARE sgb_curs CURSOR FOR i020_pb
 
    CALL g_sgb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH sgb_curs INTO g_sgb[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_sgb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgb TO s_sgb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.MOD-A60170  --Begin
#FUNCTION i020_out()
#    DEFINE
#        l_i             LIKE type_file.num5,     #No.FUN-680073 SMALLINT
#        l_name          LIKE type_file.chr20,    # No.FUN-680073  VARCHAR(20), # External(Disk) file name 
#        l_za05          LIKE type_file.chr1000,  # No.FUN-680073  VARCHAR(40),
#        l_chr           LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1)
#        l_sgb   RECORD  LIKE  sgb_file.*,
#    sr              RECORD
#        sgb01       LIKE sgb_file.sgb01,
#        sgb05       LIKE sgb_file.sgb05,
#        sgb04       LIKE sgb_file.sgb04,
#        sgf02       LIKE sgf_file.sgf02,
#        sgb06       LIKE sgb_file.sgb06,
#        aag02       LIKE aag_file.aag02
#                    END RECORD
##No.TQC-710076 -- begin --
#   IF cl_null(g_wc2) THEN
#      CALL cl_err("","9057",0)
#      RETURN
#   END IF
##No.TQC-710076 -- end --
# 
#    CALL cl_wait()
#    CALL cl_outnam('aeci020') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql=
#        " SELECT sgb01,sgb05,sgb04,sgf02,sgb06,aag02 ",
#        " FROM   sgb_file LEFT OUTER JOIN sgf_file ON sgb_file.sgb04=sgf_file.sgf01 LEFT OUTER JOIN aag_file ON sgb_file.sgb06 = aag_file.aag01 ",
#        " WHERE ",  #No.FUN-730033
#        "    aag_file.aag00 = '",g_aza.aza81,"'",                  #No.FUN-730033
#        " ORDER BY sgb01"
#    PREPARE i020_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i020_co                         # SCROLL CURSOR
#        CURSOR FOR i020_p1
# 
#    START REPORT i020_rep TO l_name
# 
#    FOREACH i020_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i020_rep(sr.*)
#    END FOREACH
#    FINISH REPORT i020_rep
#    CLOSE i020_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
# 
#REPORT i020_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1), 
#        l_chr           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
#    sr              RECORD
#        sgb01       LIKE sgb_file.sgb01,
#        sgb05       LIKE sgb_file.sgb05,
#        sgb04       LIKE sgb_file.sgb04,
#        sgf02       LIKE sgf_file.sgf02,
#        sgb06       LIKE sgb_file.sgb06,
#        aag02       LIKE aag_file.aag02
#                    END RECORD
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.sgb01
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
# 
#     ON EVERY ROW
#            PRINT COLUMN g_c[31], sr.sgb01,
#                  COLUMN g_c[32], sr.sgb05 CLIPPED,
#                  COLUMN g_c[33], sr.sgb04, 
#                  COLUMN g_c[34], sr.sgf02 CLIPPED,
#                  COLUMN g_c[35], sr.sgb06,
#                  COLUMN g_c[36], sr.aag02 CLIPPED
#           
#     ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT COLUMN 3,g_x[4],g_x[5] CLIPPED, 
#                          COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
# 
#     PAGE TRAILER
#      IF l_trailer_sw = 'y' THEN
#        PRINT COLUMN 3,g_dash[1,g_len]
#        PRINT COLUMN 3,g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#        SKIP 2 LINE
#      END IF
#END REPORT
#No.MOD-A60170  --End  

#No.FUN-570110 --start--                                                                                                            
FUNCTION i020_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                 #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("sgb01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i020_set_no_entry(p_cmd)                                                                                                   
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                 #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("sgb01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--   

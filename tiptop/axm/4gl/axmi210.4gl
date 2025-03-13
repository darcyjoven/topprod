# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: axmi210.4gl
# Descriptions...: 客戶類別維護作業
# Date & Author..: 94/12/20 by Nick
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改   
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/23 By bnlent 增加欄位“應收帳款科目二 ”和“科目二名稱”
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6A0091 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730057 07/03/28 By sherry  會計科目加帳套 
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60170 10/06/29 By Carrier aag00条件外联
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.TQC-BC0065 11/12/08 By destiny 统制类科目不可以检查通过
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_oca           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oca01       LIKE oca_file.oca01,  
        oca02       LIKE oca_file.oca02, 
        oca03       LIKE oca_file.oca03,
        oca04       LIKE oca_file.oca04,        # No.FUN-680034
        aag02       LIKE aag_file.aag02,
        aag021      LIKE aag_file.aag02         #No.FUN-680034
                    END RECORD,
    g_oca_t         RECORD                 #程式變數 (舊值)
        oca01       LIKE oca_file.oca01,  
        oca02       LIKE oca_file.oca02, 
        oca03       LIKE oca_file.oca03, 
        oca04       LIKE oca_file.oca04,        # No.FUN-680034
        aag02       LIKE aag_file.aag02,
        aag021      LIKE aag_file.aag02         #No.FUN-680034 
                    END RECORD,
     g_wc2,g_sql    LIKE type_file.chr1000,     # No.FUN-680137 string,                #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,        # No.FUN-680137 SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5        # No.FUN-680137 SMALLINT               #目前處理的ARRAY CNT
DEFINE p_row,p_col  LIKE type_file.num5        # No.FUN-680137   SMALLINT
 
DEFINE g_forupd_sql LIKE type_file.chr1000     # No.FUN-680137 STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt       LIKE type_file.num10       # No.FUN-680137    INTEGER   
DEFINE   g_i          LIKE type_file.num5        # No.FUN-680137   SMALLINT   #count/index for any purpose
DEFINE   g_before_input_done  LIKE type_file.num5        # No.FUN-680137  SMALLINT   #No.FUN-570109  
 
MAIN
# DEFINE l_time        LIKE type_file.chr8        # No.FUN-680137 VARCHAR(8)   #計算被使用時間  #NO.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
        RETURNING g_time                 #NO.FUN-6A0094                   
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW i210_w AT p_row,p_col WITH FORM "axm/42f/axmi210"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("oca04",g_aza.aza63 ='Y')    #No.FUN-680034
    CALL cl_set_comp_visible("aag021",g_aza.aza63 ='Y')    #No.FUN-680034
        
    LET g_wc2 = '1=1' CALL i210_b_fill(g_wc2)
    CALL i210_menu()
    CLOSE WINDOW i210_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818   #NO.FUN-6A0094
        RETURNING g_time                  #NO.FUN-6A0094     
END MAIN
 
FUNCTION i210_menu()
   WHILE TRUE
      CALL i210_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i210_q() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i210_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i210_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oca),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i210_q()
   CALL i210_b_askkey()
END FUNCTION
 
FUNCTION i210_b()
DEFINE
    l_ac_t          LIKE type_file.num5,        # No.FUN-680137 SMALLINT,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,        # No.FUN-680137 SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),               #單身鎖住否
    p_cmd           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),               #處理狀態
    l_allow_insert  LIKE type_file.num5,        # No.FUN-680137 SMALLINT,              #可新增否
    l_allow_delete  LIKE type_file.num5        # No.FUN-680137 SMALLINT               #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT oca01,oca02,oca03,oca04,'','' FROM oca_file WHERE oca01=?  FOR UPDATE"       #No.FUN-680034
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i210_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_oca WITHOUT DEFAULTS FROM s_oca.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_oca_t.* = g_oca[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i210_set_entry_b(p_cmd)                                                                                         
               CALL i210_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--   
               BEGIN WORK
               OPEN i210_bcl USING g_oca_t.oca01
               IF STATUS THEN
                  CALL cl_err("OPEN i210_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i210_bcl INTO g_oca[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oca_t.oca01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL i210_oca03('d')           #for referenced field
               CALL i210_oca04('d')           #No.FUN-680034
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO oca_file(oca01,oca02,oca03,oca04)        #No.FUN-680034
            VALUES(g_oca[l_ac].oca01,g_oca[l_ac].oca02,         
                   g_oca[l_ac].oca03,g_oca[l_ac].oca04)          #No.FUN-680034
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_oca[l_ac].oca01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","oca_file",g_oca[l_ac].oca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i210_set_entry_b(p_cmd)                                                                                         
            CALL i210_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--   
            INITIALIZE g_oca[l_ac].* TO NULL      #900423
            LET g_oca_t.* = g_oca[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oca01
 
        AFTER FIELD oca01                        #check 編號是否重複
            IF g_oca[l_ac].oca01 IS NOT NULL THEN
            IF g_oca[l_ac].oca01 != g_oca_t.oca01 OR
               (g_oca[l_ac].oca01 IS NOT NULL AND g_oca_t.oca01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM oca_file
                    WHERE oca01 = g_oca[l_ac].oca01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_oca[l_ac].oca01 = g_oca_t.oca01
                    NEXT FIELD oca01
                END IF
            END IF
            END IF
 
        AFTER FIELD oca03                        
            #B292 010406 BY ANN CHEN
            IF g_oaz.oaz02='Y' THEN            
               IF cl_null(g_oca[l_ac].oca03) THEN NEXT FIELD oca03 END IF
            END IF
            IF NOT cl_null(g_oca[l_ac].oca03) THEN
               CALL i210_oca03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                 #Mod No.FUN-B10048
                 #LET g_oca[l_ac].oca03 = g_oca_t.oca03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_oca[l_ac].oca03
                  LET g_qryparam.arg1 = g_aza.aza81           #No.FUN-730057
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",g_oca[l_ac].oca03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_oca[l_ac].oca03
                  DISPLAY g_oca[l_ac].oca03 TO oca03
                 #End Mod No.FUN-B10048
                  NEXT FIELD oca03
               END IF
            END IF
 
#No.FUN-680034----Begin-----
        AFTER FIELD oca04                                                                                                           
            IF g_oaz.oaz02='Y' THEN                                                                                                 
               IF cl_null(g_oca[l_ac].oca04) THEN NEXT FIELD oca04 END IF                                                           
            END IF                                                                                                                  
            IF NOT cl_null(g_oca[l_ac].oca04) THEN                                                                                  
               CALL i210_oca04('a')                                                                                                 
               IF NOT cl_null(g_errno) THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                         
                 #Mod No.FUN-B10048
                 #LET g_oca[l_ac].oca04 = g_oca_t.oca04                                                                             
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_oca[l_ac].oca04
                  LET g_qryparam.arg1 = g_aza.aza82           #No.FUN-730057
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",g_oca[l_ac].oca04 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_oca[l_ac].oca04
                  DISPLAY g_oca[l_ac].oca04 TO oca04
                 #End Mod No.FUN-B10048
                  NEXT FIELD oca04                                                                                                  
               END IF                                                                                                               
            END IF            
#No.FUN-680034----End-----
        BEFORE DELETE                            #是否取消單身
            IF g_oca_t.oca01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM oca_file WHERE oca01 = g_oca_t.oca01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oca_t.oca01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","oca_file",g_oca_t.oca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i210_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oca[l_ac].* = g_oca_t.*
               CLOSE i210_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oca[l_ac].oca01,-263,1)
               LET g_oca[l_ac].* = g_oca_t.*
            ELSE
               UPDATE oca_file SET oca01=g_oca[l_ac].oca01,
                                   oca02=g_oca[l_ac].oca02,
                                   oca03=g_oca[l_ac].oca03,   
                                   oca04=g_oca[l_ac].oca04           #No.FUN-680034
                WHERE oca01 = g_oca_t.oca01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oca[l_ac].oca01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","oca_file",g_oca_t.oca01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_oca[l_ac].* = g_oca_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i210_bcl
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oca[l_ac].* = g_oca_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_oca.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i210_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add 
            CLOSE i210_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i210_b_askkey()
            EXIT INPUT
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(oca03)      #查詢科目代號不為統制帳戶'1'
#                CALL q_aag(10,3,g_oca[l_ac].oca03,'23','2','') 
#                     RETURNING g_oca[l_ac].oca03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_oca[l_ac].oca03
                 LET g_qryparam.arg1 = g_aza.aza81           #No.FUN-730057
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2'"
                 CALL cl_create_qry() RETURNING g_oca[l_ac].oca03
                 DISPLAY g_oca[l_ac].oca03 TO oca03
#              OTHERWISE
#                 EXIT CASE
#No.FUN-680034-----Begin---
             WHEN INFIELD(oca04)                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_aag"                                                                                       
                 LET g_qryparam.default1 = g_oca[l_ac].oca04                                                                        
                 LET g_qryparam.arg1 = g_aza.aza82           #No.FUN-730057 
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2'"                                                      
                 CALL cl_create_qry() RETURNING g_oca[l_ac].oca04                                                                   
                 DISPLAY g_oca[l_ac].oca04 TO oca04                                                                                 
              OTHERWISE                                                                                                             
                 EXIT CASE        
           END CASE
#No.FUN-680034-----End---
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oca01) AND l_ac > 1 THEN
                LET g_oca[l_ac].* = g_oca[l_ac-1].*
                NEXT FIELD oca01
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i210_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION  i210_oca03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02, aagacti
        INTO g_oca[l_ac].aag02,l_aagacti
        FROM aag_file  
        WHERE aag01 = g_oca[l_ac].oca03
          AND aag00 = g_aza.aza81               #No.FUN-730057 
          AND aag07 !='1' #TQC-BC0065 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-001'
                                   LET g_oca[l_ac].aag02 = NULL
         WHEN l_aagacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#No.FUN-680034-----Begin----
FUNCTION  i210_oca04(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02, aagacti
        INTO g_oca[l_ac].aag021,l_aagacti
        FROM aag_file  
        WHERE aag01 = g_oca[l_ac].oca04
          AND aag00 = g_aza.aza82               #No.FUN-730057    
          AND aag07 !='1' #TQC-BC0065
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-001'
                                   LET g_oca[l_ac].aag021 = NULL           
         WHEN l_aagacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#No.FUN-680034-----End----
 
FUNCTION i210_b_askkey()
    CLEAR FORM
    CALL g_oca.clear()
#No.FUN-680034-----Begin---
    CONSTRUCT g_wc2 ON oca01,oca02,oca03,oca04
            FROM s_oca[1].oca01,s_oca[1].oca02,s_oca[1].oca03,s_oca[1].oca04 
#No.FUN-680034-----End--- 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(oca03)      #查詢科目代號不為統制帳戶'1'
#                CALL q_aag(10,3,g_oca[1].oca03,'23','2','') 
#                     RETURNING g_oca[1].oca03
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_oca[1].oca03
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oca03         #No.MOD-490371
#              OTHERWISE
#                 EXIT CASE
#No.FUN-680034-----Begin--- 
              WHEN INFIELD(oca04)   
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.default1 = g_oca[1].oca04
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oca04         #No.MOD-490371
              OTHERWISE
                 EXIT CASE
#No.FUN-680034-----End--- 
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
      LET g_rec_b = 0     #No.FUN-730057
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i210_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i210_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(200)
   
    #No.MOD-A60170  --Begin
    LET g_sql = "SELECT oca01,oca02,oca03,oca04,aag02,' '",    #No.FUN-680034  
                "  FROM oca_file LEFT OUTER JOIN aag_file ON oca_file.oca03=aag_file.aag01",
                "                                        AND aag_file.aag00='",g_aza.aza81,"'",
                " WHERE ", p_wc2 CLIPPED,   #單身 #No.FUN-730057
                " ORDER BY oca01" 
    #No.MOD-A60170  --End  
    PREPARE i210_pb FROM g_sql
    DECLARE oca_curs CURSOR FOR i210_pb
 
    CALL g_oca.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH oca_curs INTO g_oca[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-680034----Begin----                                                                                                         
        SELECT aag02 INTO g_oca[g_cnt].aag021                                                                                       
        FROM  aag_file                                                                                                              
        WHERE aag01 =g_oca[g_cnt].oca04            
          AND aag00 =g_aza.aza82          #No.FUN-730057                                                                                                 
#No.FUN-680034----End----         
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_oca.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i210_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oca TO s_oca.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
   ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-7C0043--start-- 
FUNCTION i210_out()
    DEFINE
        l_oca           RECORD LIKE oca_file.*,
        l_i             LIKE type_file.num5,        # No.FUN-680137 SMALLINT,
        l_name          LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20),                # External(Disk) file name
        l_za05          LIKE ima_file.ima01      # No.FUN-680137 VARCHAR(40)                 #
    DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
                                                                                                                                    
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0) RETURN END IF                                                                                       
    LET l_cmd = 'p_query "axmi210" "',g_wc2 CLIPPED,'" "',g_aza.aza81,'"'                                                           
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN    
#   IF g_wc2 IS NULL THEN 
#      CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   LET g_sql="SELECT * FROM oca_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i210_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i210_co                         # CURSOR
#       CURSOR FOR i210_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi210') RETURNING l_name         #FUN-4C0096 add
#   START REPORT i210_rep TO l_name
 
#   FOREACH i210_co INTO l_oca.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i210_rep(l_oca.*)
#   END FOREACH
 
#   FINISH REPORT i210_rep
 
#   CLOSE i210_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i210_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),
#       l_aag02         LIKE aag_file.aag02,
#       sr RECORD LIKE oca_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.oca01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           #PRINT ''  #No.TQC-6A0091
 
#           PRINT g_dash
#           PRINT g_x[31], 
#                 g_x[32],
#                 g_x[33],
#                 g_x[34]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.oca03 
#                                                     AND aag00 = g_aza.aza81      #No.FUN-730057                             
#           IF SQLCA.sqlcode THEN LET l_aag02= ' ' END IF
#           PRINT COLUMN g_c[31],sr.oca01,
#                 COLUMN g_c[32],sr.oca02,
#                 COLUMN g_c[33],sr.oca03,
#                 COLUMN g_c[34],l_aag02 
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #No.TQC-6A0091
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0091
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end-- 
 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i210_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)                                                                                                           
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("oca01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i210_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)                                                                                                           
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("oca01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--     

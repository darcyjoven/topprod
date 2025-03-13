# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_qryset.4gl
# Descriptions...: udm_tree資料查詢 
# Date & Author..: 06/11/01 By Jack Lai    #FUN-570225
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.MOD-750003 07/05/01 By saki 砍多餘的Action
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gcm          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gcm01       LIKE gcm_file.gcm01,   #項次(Key)
        gcm02       LIKE gcm_file.gcm02,   #類別代碼
        gcm03       LIKE gcm_file.gcm03,   #表格名稱
        gcm04       LIKE gcm_file.gcm04,   #欄位名稱
        gcm11       LIKE gcm_file.gcm11,   #對應作業
        gcm05       LIKE gcm_file.gcm05,   #對應作業
        gcm06       LIKE gcm_file.gcm06,   #Key1
        gcm07       LIKE gcm_file.gcm07    #Key2
                    END RECORD,
     g_gcm_t        RECORD                 #程式變數 (舊值)
        gcm01       LIKE gcm_file.gcm01,   #項次(Key)
        gcm02       LIKE gcm_file.gcm02,   #類別代碼
        gcm03       LIKE gcm_file.gcm03,   #表格名稱
        gcm04       LIKE gcm_file.gcm04,   #欄位名稱
        gcm11       LIKE gcm_file.gcm11,   #對應作業
        gcm05       LIKE gcm_file.gcm05,   #對應作業
        gcm06       LIKE gcm_file.gcm06,   #Key1
        gcm07       LIKE gcm_file.gcm07    #Key2
                    END RECORD,
 
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680102 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_on_change  LIKE type_file.num5      #No.FUN-680102 SMALLINT   #FUN-550077
 
MAIN
    DEFINE l_time        LIKE type_file.chr8    #計算被使用時間  #No.FUN-680102 VARCHAR(8)
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   #No.FUN-570225
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
        RETURNING l_time
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW p_qryset_w AT p_row,p_col WITH FORM "azz/42f/p_qryset"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1'
    CALL p_qryset_b_fill(g_wc2)
    CALL p_qryset_menu()
    CLOSE WINDOW p_qryset_w                 #結束畫面
      CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
        RETURNING l_time
END MAIN
 
FUNCTION p_qryset_menu()
 
   WHILE TRUE
      CALL p_qryset_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_qryset_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL p_qryset_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL p_qryset_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_gcm[l_ac].gcm01 IS NOT NULL THEN
                  LET g_doc.column1 = "gcm01"
                  LET g_doc.value1 = g_gcm[l_ac].gcm01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gcm),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_qryset_q()
   CALL p_qryset_b_askkey()
END FUNCTION
 
FUNCTION p_qryset_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    v               STRING,
    ls_str          STRING,                              #取檔名前三碼用
    l_chkin         LIKE type_file.num5                  #比對欄位是否屬於檔案用
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT gcm01,gcm02,gcm03,gcm04,gcm11,gcm05,gcm06,gcm07",
                       "  FROM gcm_file WHERE gcm01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_qryset_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gcm WITHOUT DEFAULTS FROM s_gcm.*
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
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL p_qryset_set_entry(p_cmd)                                           
           CALL p_qryset_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_gcm_t.* = g_gcm[l_ac].*  #BACKUP
           OPEN p_qryset_bcl USING g_gcm_t.gcm01
           IF STATUS THEN
              CALL cl_err("OPEN p_qryset_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH p_qryset_bcl INTO g_gcm[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_gcm_t.gcm01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                        
         CALL p_qryset_set_entry(p_cmd)                                             
         CALL p_qryset_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_gcm[l_ac].* TO NULL      #900423
         
         LET g_gcm_t.* = g_gcm[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gcm01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE p_qryset_bcl
           CANCEL INSERT
        END IF
        
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO gcm_file(gcm01,gcm02,gcm03,gcm04,gcm11,gcm05,
                     gcm06,gcm07)
               VALUES(g_gcm[l_ac].gcm01,g_gcm[l_ac].gcm02,
               g_gcm[l_ac].gcm03,g_gcm[l_ac].gcm04,g_gcm[l_ac].gcm11,
               g_gcm[l_ac].gcm05,g_gcm[l_ac].gcm06,
               g_gcm[l_ac].gcm07)
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_gcm[l_ac].gcm01,SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("ins","gcm_file",g_gcm[l_ac].gcm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cn2
 
           COMMIT WORK
        END IF
        
     BEFORE FIELD gcm01                        #default 序號
           IF g_gcm[l_ac].gcm01 IS NULL OR g_gcm[l_ac].gcm01 = 0 THEN
              SELECT max(gcm01)+1
                INTO g_gcm[l_ac].gcm01
                FROM gcm_file
              IF g_gcm[l_ac].gcm01 IS NULL THEN
                 LET g_gcm[l_ac].gcm01 = 1
              END IF
           END IF   
 
     AFTER FIELD gcm01                        #check 編號是否重複
        IF NOT cl_null(g_gcm[l_ac].gcm01) THEN
           IF g_gcm[l_ac].gcm01 != g_gcm_t.gcm01 OR
              g_gcm_t.gcm01 IS NULL THEN
              SELECT count(*) INTO l_n FROM gcm_file
               WHERE gcm01 = g_gcm[l_ac].gcm01
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gcm[l_ac].gcm01 = g_gcm_t.gcm01
                  NEXT FIELD gcm01
              END IF
           END IF
        END IF
    
     AFTER FIELD gcm02                        #check 類別代碼是否在gcn01中
        IF NOT cl_null(g_gcm[l_ac].gcm02) THEN
            SELECT count(*) INTO l_n FROM gcn_file
            WHERE gcn01 = g_gcm[l_ac].gcm02
            IF l_n <= 0 THEN
               CALL cl_err('',g_errno,0)
               LET g_gcm[l_ac].gcm02 = g_gcm_t.gcm02
               NEXT FIELD gcm02
            END IF
        END IF
        
     AFTER FIELD gcm03                        #check 表格名稱是否在gat01中
        IF NOT cl_null(g_gcm[l_ac].gcm03) THEN
            #SELECT count(*) INTO l_n FROM gat_file WHERE gat01 = g_gcm[l_ac].gcm03     #No.FUN-A70082 mark
            SELECT count(*) INTO l_n FROM zta_file WHERE zta01 = g_gcm[l_ac].gcm03 AND zta02 = 'ds'     #No.FUN-A70082
            IF l_n <= 0 THEN
               CALL cl_err('',g_errno,0)
               LET g_gcm[l_ac].gcm03 = g_gcm_t.gcm03
               NEXT FIELD gcm03
            END IF
        END IF
        
     AFTER FIELD gcm04                        #check 欄位名稱是否在gaq01中
        IF NOT cl_null(g_gcm[l_ac].gcm04) THEN
            CALL p_qryset_chk_gaq01(g_gcm[l_ac].gcm04) RETURNING l_chkin
            IF l_chkin = FALSE THEN
                CALL cl_err('',g_errno,0)
                LET g_gcm[l_ac].gcm04 = g_gcm_t.gcm04
                NEXT FIELD gcm04
            END IF
        END IF
        
     AFTER FIELD gcm11                        #check 對應作業是否在zz01中
        IF NOT cl_null(g_gcm[l_ac].gcm11) THEN
            SELECT count(*) INTO l_n FROM zz_file
            WHERE zz01 = g_gcm[l_ac].gcm11
            IF l_n <= 0 THEN
               CALL cl_err('',g_errno,0)
               LET g_gcm[l_ac].gcm11 = g_gcm_t.gcm11
               NEXT FIELD gcm11
            END IF
        END IF
 
     AFTER FIELD gcm05                        #check 對應作業是否在zz01中
        IF NOT cl_null(g_gcm[l_ac].gcm05) THEN
            SELECT count(*) INTO l_n FROM zz_file
            WHERE zz01 = g_gcm[l_ac].gcm05
            IF l_n <= 0 THEN
               CALL cl_err('',g_errno,0)
               LET g_gcm[l_ac].gcm05 = g_gcm_t.gcm05
               NEXT FIELD gcm05
            END IF
        END IF
     
     AFTER FIELD gcm06                        #check KeyValue_1是否在gaq01中
        IF NOT cl_null(g_gcm[l_ac].gcm06) THEN
            CALL p_qryset_chk_gaq01(g_gcm[l_ac].gcm06) RETURNING l_chkin
            IF l_chkin = FALSE THEN
                CALL cl_err('',g_errno,0)
                LET g_gcm[l_ac].gcm06 = g_gcm_t.gcm06
                NEXT FIELD gcm06
            END IF
        END IF
        
     AFTER FIELD gcm07                        #check KeyValue_2是否在gaq01中
        IF NOT cl_null(g_gcm[l_ac].gcm07) THEN
            CALL p_qryset_chk_gaq01(g_gcm[l_ac].gcm07) RETURNING l_chkin
            IF l_chkin = FALSE THEN
                CALL cl_err('',g_errno,0)
                LET g_gcm[l_ac].gcm07 = g_gcm_t.gcm07
                NEXT FIELD gcm07
            END IF
        END IF
        
#    AFTER FIELD gcm08                        #check KeyValue_3是否在gaq01中
#       IF NOT cl_null(g_gcm[l_ac].gcm08) THEN
#           CALL p_qryset_chk_gaq01(g_gcm[l_ac].gcm08) RETURNING l_chkin
#           IF l_chkin = FALSE THEN
#               CALL cl_err('',g_errno,0)
#               LET g_gcm[l_ac].gcm08 = g_gcm_t.gcm08
#               NEXT FIELD gcm08
#           END IF
#       END IF
 
#    AFTER FIELD gcm09                        #check KeyValue_4是否在gaq01中
#       IF NOT cl_null(g_gcm[l_ac].gcm09) THEN
#           CALL p_qryset_chk_gaq01(g_gcm[l_ac].gcm09) RETURNING l_chkin
#           IF l_chkin = FALSE THEN
#               CALL cl_err('',g_errno,0)
#               LET g_gcm[l_ac].gcm09 = g_gcm_t.gcm09
#               NEXT FIELD gcm09
#           END IF
#       END IF
 
#    AFTER FIELD gcm10                        #check KeyValue_5是否在gaq01中
#       IF NOT cl_null(g_gcm[l_ac].gcm10) THEN
#           CALL p_qryset_chk_gaq01(g_gcm[l_ac].gcm10) RETURNING l_chkin
#           IF l_chkin = FALSE THEN
#               CALL cl_err('',g_errno,0)
#               LET g_gcm[l_ac].gcm10 = g_gcm_t.gcm10
#               NEXT FIELD gcm10
#           END IF
#       END IF
        
     BEFORE DELETE                            #是否取消單身
         IF g_gcm_t.gcm01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "gcm01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_gcm[l_ac].gcm01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
            DELETE FROM gcm_file WHERE gcm01 = g_gcm_t.gcm01
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_gcm_t.gcm01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("del","gcm_file",g_gcm_t.gcm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK      #FUN-680010
                CANCEL DELETE
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
          LET g_gcm[l_ac].* = g_gcm_t.*
          CLOSE p_qryset_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gcm[l_ac].gcm01,-263,0)
           LET g_gcm[l_ac].* = g_gcm_t.*
        ELSE
           UPDATE gcm_file SET gcm01=g_gcm[l_ac].gcm01,
                               gcm02=g_gcm[l_ac].gcm02,
                               gcm03=g_gcm[l_ac].gcm03,
                               gcm04=g_gcm[l_ac].gcm04,
                               gcm11=g_gcm[l_ac].gcm11,
                               gcm05=g_gcm[l_ac].gcm05,
                               gcm06=g_gcm[l_ac].gcm06,
                               gcm07=g_gcm[l_ac].gcm07
           WHERE gcm01 = g_gcm_t.gcm01
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_gcm[l_ac].gcm01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("upd","gcm_file",g_gcm_t.gcm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK    #FUN-680010
              LET g_gcm[l_ac].* = g_gcm_t.*
           ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
        #LET l_ac_t = l_ac               # 新增  #FUN-D30034
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gcm[l_ac].* = g_gcm_t.*
           #FUN-D30034--add--str--
           ELSE
              CALL g_gcm.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30034--add--end--
           END IF
           CLOSE p_qryset_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034
         CLOSE p_qryset_bcl                # 新增
         COMMIT WORK
 
   # ON ACTION CONTROLN
   #     CALL p_qryset_b_askkey()
   #     EXIT INPUT
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gcm01) AND l_ac > 1 THEN
             LET g_gcm[l_ac].* = g_gcm[l_ac-1].*
             NEXT FIELD gcm01
         END IF
 
       ON ACTION controlp
           CASE
#                WHEN INFIELD(gcm02)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_gcn"
#                     LET g_qryparam.default1 = g_gcm[l_ac].gcm02
#                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm02
#                     DISPLAY g_gcm[l_ac].gcm02 TO gcm02
                WHEN INFIELD(gcm03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gat"
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm03
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm03
                     DISPLAY g_gcm[l_ac].gcm03 TO gcm03
                WHEN INFIELD(gcm04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaq"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm04
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     LET ls_str = g_gcm[l_ac].gcm03
                     LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
                     LET g_qryparam.arg2 = ls_str
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm04
                     DISPLAY g_gcm[l_ac].gcm04 TO gcm04
                WHEN INFIELD(gcm11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zz"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm11
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm11
                     DISPLAY g_gcm[l_ac].gcm11 TO gcm11
                WHEN INFIELD(gcm05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zz"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm05
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm05
                     DISPLAY g_gcm[l_ac].gcm05 TO gcm05
                WHEN INFIELD(gcm06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaq"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm06
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     LET g_qryparam.arg2 = g_gcm[l_ac].gcm03[1,3]
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm06
                     DISPLAY g_gcm[l_ac].gcm06 TO gcm06
                WHEN INFIELD(gcm07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaq"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm07
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     LET ls_str = g_gcm[l_ac].gcm03
                     LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
                     LET g_qryparam.arg2 = ls_str
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm07
                     DISPLAY g_gcm[l_ac].gcm07 TO gcm07
#               WHEN INFIELD(gcm08)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_gaq"
#                    LET g_qryparam.default1 = g_gcm[l_ac].gcm08
#                    LET g_qryparam.arg1 = g_lang CLIPPED
#                    LET ls_str = g_gcm[l_ac].gcm03
#                    LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
#                    LET g_qryparam.arg2 = ls_str
#                    CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm08
#                    DISPLAY g_gcm[l_ac].gcm08 TO gcm08
#               WHEN INFIELD(gcm09)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_gaq"
#                    LET g_qryparam.default1 = g_gcm[l_ac].gcm09
#                    LET g_qryparam.arg1 = g_lang CLIPPED
#                    LET ls_str = g_gcm[l_ac].gcm03
#                    LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
#                    LET g_qryparam.arg2 = ls_str
#                    CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm09
#                    DISPLAY g_gcm[l_ac].gcm09 TO gcm09
#               WHEN INFIELD(gcm10)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_gaq"
#                    LET g_qryparam.default1 = g_gcm[l_ac].gcm10
#                    LET g_qryparam.arg1 = g_lang CLIPPED
#                    LET ls_str = g_gcm[l_ac].gcm03
#                    LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
#                    LET g_qryparam.arg2 = ls_str
#                    CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm10
#                    DISPLAY g_gcm[l_ac].gcm10 TO gcm10
                OTHERWISE
                     EXIT CASE
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
         
#     ON ACTION update_item   #No.MOD-750003 mark
 
    END INPUT
 
    CLOSE p_qryset_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION p_qryset_b_askkey()
    DEFINE ls_str STRING
    
    CLEAR FORM
    CALL g_gcm.clear()
 
    CONSTRUCT g_wc2 ON gcm01,gcm02,gcm03,gcm04,gcm05,gcm06,gcm07
         FROM s_gcm[1].gcm01,s_gcm[1].gcm02,s_gcm[1].gcm03,
              s_gcm[1].gcm04,s_gcm[1].gcm05,s_gcm[1].gcm06,
              s_gcm[1].gcm07
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE
#                WHEN INFIELD(gcm02)
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_gcn"
#                     LET g_qryparam.default1 = g_gcm[l_ac].gcm02
#                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm02
#                     DISPLAY g_gcm[l_ac].gcm02 TO gcm02
                WHEN INFIELD(gcm03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gat"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm03
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm03
                     DISPLAY g_gcm[l_ac].gcm03 TO gcm03
                WHEN INFIELD(gcm04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaq"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm04
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     LET ls_str = g_gcm[l_ac].gcm03
                     LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
                     LET g_qryparam.arg2 = ls_str
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm04
                     DISPLAY g_gcm[l_ac].gcm04 TO gcm04
                WHEN INFIELD(gcm11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zz"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm11
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm11
                     DISPLAY g_gcm[l_ac].gcm11 TO gcm11
                WHEN INFIELD(gcm05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zz"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm05
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm05
                     DISPLAY g_gcm[l_ac].gcm05 TO gcm05
                WHEN INFIELD(gcm06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaq"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm06
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     LET ls_str = g_gcm[l_ac].gcm03
                     LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
                     LET g_qryparam.arg2 = ls_str
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm06
                     DISPLAY g_gcm[l_ac].gcm06 TO gcm06
                WHEN INFIELD(gcm07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaq"
                     LET g_qryparam.default1 = g_gcm[l_ac].gcm07
                     LET g_qryparam.arg1 = g_lang CLIPPED
                     LET ls_str = g_gcm[l_ac].gcm03
                     LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
                     LET g_qryparam.arg2 = ls_str
                     CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm07
                     DISPLAY g_gcm[l_ac].gcm07 TO gcm07
#               WHEN INFIELD(gcm08)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_gaq"
#                    LET g_qryparam.default1 = g_gcm[l_ac].gcm08
#                    LET g_qryparam.arg1 = g_lang CLIPPED
#                    LET ls_str = g_gcm[l_ac].gcm03
#                    LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
#                    LET g_qryparam.arg2 = ls_str
#                    CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm08
#                    DISPLAY g_gcm[l_ac].gcm08 TO gcm08
#               WHEN INFIELD(gcm09)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_gaq"
#                    LET g_qryparam.default1 = g_gcm[l_ac].gcm09
#                    LET g_qryparam.arg1 = g_lang CLIPPED
#                    LET ls_str = g_gcm[l_ac].gcm03
#                    LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
#                    LET g_qryparam.arg2 = ls_str
#                    CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm09
#                    DISPLAY g_gcm[l_ac].gcm09 TO gcm09
#               WHEN INFIELD(gcm10)
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_gaq"
#                    LET g_qryparam.default1 = g_gcm[l_ac].gcm10
#                    LET g_qryparam.arg1 = g_lang CLIPPED
#                    LET ls_str = g_gcm[l_ac].gcm03
#                    LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
#                    LET g_qryparam.arg2 = ls_str
#                    CALL cl_create_qry() RETURNING g_gcm[l_ac].gcm10
#                    DISPLAY g_gcm[l_ac].gcm10 TO gcm10
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
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
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
 
    CALL p_qryset_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_qryset_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
 
    LET g_sql = "SELECT gcm01,gcm02,gcm03,gcm04,gcm11,gcm05,gcm06,gcm07",
                " FROM gcm_file",
                " WHERE ", p_wc2 CLIPPED,           #單身
                " ORDER BY 1" 
 
 
    PREPARE p_qryset_pb FROM g_sql
    DECLARE gcm_curs CURSOR FOR p_qryset_pb
 
    CALL g_gcm.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gcm_curs INTO g_gcm[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        #FUN-550077
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gcm.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_qryset_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gcm TO s_gcm.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_qryset_out()
    DEFINE
        l_gcm           RECORD LIKE gcm_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-680102 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
    #  CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'p_qryset.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gcm_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p_qryset_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_qryset_co                         # SCROLL CURSOR
        CURSOR FOR p_qryset_p1
 
    CALL cl_outnam('p_qryset') RETURNING l_name
    START REPORT p_qryset_rep TO l_name
 
    FOREACH p_qryset_co INTO l_gcm.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT p_qryset_rep(l_gcm.*)
    END FOREACH
 
    FINISH REPORT p_qryset_rep
 
    CLOSE p_qryset_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_qryset_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE gcm_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gcm01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[2] CLIPPED,g_x[3] CLIPPED,g_x[4] CLIPPED,g_x[5] CLIPPED,
                  g_x[12] CLIPPED,g_x[6] CLIPPED,g_x[7] CLIPPED,g_x[8] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            
          PRINT COLUMN g_c[2],sr.gcm01,
                COLUMN g_c[3],sr.gcm02,
                COLUMN g_c[4],sr.gcm03,
                COLUMN g_c[5],sr.gcm04,
                COLUMN g_c[12],sr.gcm11,
                COLUMN g_c[6],sr.gcm05,
                COLUMN g_c[7],sr.gcm06,
                COLUMN g_c[8],sr.gcm07
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            #PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                #PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
                SKIP 1 LINE
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
                                                      
FUNCTION p_qryset_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gcm01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION p_qryset_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gcm01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION
 
FUNCTION p_qryset_chk_gaq01(p_gaq01)
    DEFINE
        p_gaq01 STRING,                 #要檢查的欄位
        l_n     LIKE type_file.num5,    #檢查重複用
        ls_str  STRING,                 #取檔名前三碼用
        ls_str2 STRING,                 #比對欄位是否屬於檔案用
        ls_str3 LIKE gaq_file.gaq01     #比對欄位是否屬於檔案用3
    
    LET ls_str = g_gcm[l_ac].gcm03
    LET ls_str = ls_str.subString(1,ls_str.getIndexOf("_file",1) -1)
    LET ls_str2 = p_gaq01 CLIPPED
    IF ls_str2.getIndexOf(ls_str,1) == 0 THEN
        RETURN FALSE
    ELSE
        LET ls_str3 = ls_str2 CLIPPED
        SELECT count(*) INTO l_n FROM gaq_file
        WHERE gaq01 = ls_str3
        IF l_n <= 0 THEN
           RETURN FALSE
        END IF
    END IF
    RETURN TRUE
END FUNCTION

# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acoi010.4gl
# Descriptions...: 合同系統單據性質維護作業
# Date & Author..: 00/10/05 By Kammy
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-5100339 05/01/20 By pengu 報表轉XML
# Modify.........: No.FUN-550036 05/05/26 By Will 單據編號放大
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570109 05/07/15 By day   修正建檔程式key值是否可更改
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-640173 06/04/21 By pengu 宣告g_coy_t_1時錯誤照成compiler不會過
# Modify.........: No.TQC-650123 06/05/26 By Rayven 表名update錯，修正
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.TQC-670039 06/07/11 By Mandy 1.按使用者設限或部門設限會出現錯誤訊息lib-219=>您在 %1 中沒有執行 %2 的權限! (請檢查權限設定)
# Modify.........: No.TQC-670039 06/07/11 By Mandy 2.按完後會到主畫面,單別會show單據名稱
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780040 07/07/04 By zhoufeng 報表由p_query產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.FUN-B50039 11/07/06 By xianghui 增加自訂欄位
# Modify.........: No.TQC-B90159 11/09/22 By suncx 新增對應單別開窗
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_coy_1         DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        coyslip     LIKE coy_file.coyslip,
        coydesc     LIKE coy_file.coydesc,
        coyauno     LIKE coy_file.coyauno,
        #coykind     LIKE coy_file.coykind,  #FUN-A10109
        coytype     LIKE coy_file.coytype,
        coyslip2    LIKE coy_file.coyslip2,
        #FUN-B50039-add-str--
        coyud01     LIKE coy_file.coyud01,
        coyud02     LIKE coy_file.coyud02,
        coyud03     LIKE coy_file.coyud03,
        coyud04     LIKE coy_file.coyud04,
        coyud05     LIKE coy_file.coyud05,
        coyud06     LIKE coy_file.coyud06,
        coyud07     LIKE coy_file.coyud07,
        coyud08     LIKE coy_file.coyud08,
        coyud09     LIKE coy_file.coyud09,
        coyud10     LIKE coy_file.coyud10,
        coyud11     LIKE coy_file.coyud11,
        coyud12     LIKE coy_file.coyud12,
        coyud13     LIKE coy_file.coyud13,
        coyud14     LIKE coy_file.coyud14,
        coyud15     LIKE coy_file.coyud15
        #FUN-B50039-add-end--
                    END RECORD,
    g_buf           LIKE cob_file.cob01,        #No.FUN-680069 VARCHAR(40)
    g_coy_1_t         RECORD                 #程式變數 (舊值)
        coyslip     LIKE coy_file.coyslip,
        coydesc     LIKE coy_file.coydesc,
        coyauno     LIKE coy_file.coyauno,
        #coykind     LIKE coy_file.coykind,  #FUN-A10109
        coytype     LIKE coy_file.coytype,
        coyslip2    LIKE coy_file.coyslip2,
        #FUN-B50039-add-str--
        coyud01     LIKE coy_file.coyud01,
        coyud02     LIKE coy_file.coyud02,
        coyud03     LIKE coy_file.coyud03,
        coyud04     LIKE coy_file.coyud04,
        coyud05     LIKE coy_file.coyud05,
        coyud06     LIKE coy_file.coyud06,
        coyud07     LIKE coy_file.coyud07,
        coyud08     LIKE coy_file.coyud08,
        coyud09     LIKE coy_file.coyud09,
        coyud10     LIKE coy_file.coyud10,
        coyud11     LIKE coy_file.coyud11,
        coyud12     LIKE coy_file.coyud12,
        coyud13     LIKE coy_file.coyud13,
        coyud14     LIKE coy_file.coyud14,
        coyud15     LIKE coy_file.coyud15
        #FUN-B50039-add-end--
                    END RECORD,
     g_wc2,g_sql     STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL      
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109        #No.FUN-680069 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0063
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "aco/42f/acoi010"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1'
    CALL i010_b_fill(g_wc2)
    CALL i010_menu()
    CLOSE WINDOW i010_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i010_menu()
DEFINE l_cmd  LIKE type_file.chr1000      #No.FUN-780040
 
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
#              CALL i010_out()                             #No.FUN-780040
               #No.FUN-780040 --start--
               IF cl_null(g_wc2) THEN 
                  LET g_wc2 = " 1=1" 
               END IF
               LET l_cmd = 'p_query "acoi010" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)                       
               #No.FUN-780040 --end--
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_coy_1),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i010_q()
   CALL s_getgee('acoi010',g_lang,'coytype') #FUN-A10109
   CALL i010_b_askkey()
END FUNCTION
 
FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
DEFINE l_i          LIKE type_file.num5     #No.FUN-560150        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT coyslip,coydesc,coyauno,",
                      #"       coykind, ", #FUN-A10109
                       "       coytype,coyslip2,",
                       "       coyud01,coyud02,coyud03,coyud04,coyud05,coyud06,coyud07,",              #FUN-B50039
                       "       coyud08,coyud09,coyud10,coyud11,coyud12,coyud13,coyud14,coyud15 ",      #FUN-B50039
                       " FROM coy_file WHERE coyslip=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        #CKP2
        IF g_rec_b=0 THEN CALL g_coy_1.clear() END IF
        INPUT ARRAY g_coy_1 WITHOUT DEFAULTS FROM s_coy.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #NO.FUN-560150 --start--
            CALL cl_set_doctype_format("coyslip")
            CALL cl_set_doctype_format("coyslip2")
            #NO.FUN-560150 --end--
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_coy_1_t.* = g_coy_1[l_ac].*  #BACKUP
#No.FUN-570109 --start--
               LET g_before_input_done = FALSE
               CALL i010_set_entry(p_cmd)
               CALL i010_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570109 --end--
               BEGIN WORK
               OPEN i010_bcl USING g_coy_1_t.coyslip
               IF STATUS THEN
                  CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i010_bcl INTO g_coy_1[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_coy_1_t.coyslip,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD coyslip
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_coy_1[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_coy_1[l_ac].* TO s_coy.*
              CALL g_coy_1.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO coy_file(coyslip,coydesc,coyauno,#coykind, #FUN-A10109
                                 coytype,coyslip2,coyoriu,coyorig,
                                 coyud01,coyud02,coyud03,coyud04,coyud05,coyud06,coyud07,                #FUN-B50039
                                 coyud08,coyud09,coyud10,coyud11,coyud12,coyud13,coyud14,coyud15)        #FUN-B50039                      
            VALUES(g_coy_1[l_ac].coyslip,g_coy_1[l_ac].coydesc,
                   g_coy_1[l_ac].coyauno,#g_coy_1[l_ac].coykind,   #FUN-A10109
                   g_coy_1[l_ac].coytype,g_coy_1[l_ac].coyslip2, g_user, g_grup,      #No.FUN-980030 10/01/04  insert columns oriu, orig
                   g_coy_1[l_ac].coyud01,g_coy_1[l_ac].coyud02,g_coy_1[l_ac].coyud03,     #FUN-B50039
                   g_coy_1[l_ac].coyud04,g_coy_1[l_ac].coyud05,g_coy_1[l_ac].coyud06,     #FUN-B50039
                   g_coy_1[l_ac].coyud07,g_coy_1[l_ac].coyud08,g_coy_1[l_ac].coyud09,     #FUN-B50039
                   g_coy_1[l_ac].coyud10,g_coy_1[l_ac].coyud11,g_coy_1[l_ac].coyud12,     #FUN-B50039
                   g_coy_1[l_ac].coyud13,g_coy_1[l_ac].coyud14,g_coy_1[l_ac].coyud15)     #FUN-B50039
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_coy_1[l_ac].coyslip,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","coy_file",g_coy_1[l_ac].coyslip,"",SQLCA.sqlcode,"","",1)  #TQC-660045              
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               #FUN-A10109  ===S===
               CALL s_access_doc('a',g_coy_1[l_ac].coyauno,g_coy_1[l_ac].coytype,
                                 g_coy_1[l_ac].coyslip,'ACO','Y')
               #FUN-A10109  ===E===
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
#No.FUN-570109 --start--
            LET g_before_input_done = FALSE
            CALL i010_set_entry(p_cmd)
            CALL i010_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end--
            LET l_n = ARR_COUNT()
          #------------No.TQC-640173 modify
            INITIALIZE g_coy_1[l_ac].* TO NULL      #900423
            LET g_coy_1_t.* = g_coy_1[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD coyslip
          #------------No.TQC-640173 end
 
        #FUN-A10109 TSD.zeak ===S===
        BEFORE FIELD coytype 
            CALL s_getgee('acoi010',g_lang,'coytype') #FUN-A10109
        #FUN-A10109 TSD.zeak ===E===
      
        AFTER FIELD coyslip                        #check 編號是否重複
            IF g_coy_1[l_ac].coyslip IS NOT NULL THEN
               IF g_coy_1[l_ac].coyslip != g_coy_1_t.coyslip OR
                 (NOT cl_null(g_coy_1[l_ac].coyslip) AND
                  cl_null(g_coy_1_t.coyslip)) THEN
                  SELECT count(*) INTO l_n FROM coy_file
                   WHERE coyslip = g_coy_1[l_ac].coyslip
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_coy_1[l_ac].coyslip = g_coy_1_t.coyslip
                     NEXT FIELD coyslip
                  END IF
                  #NO.FUN-560150 --start--
                  FOR l_i = 1 TO g_doc_len
                     IF cl_null(g_coy_1[l_ac].coyslip[l_i,l_i]) THEN
                        CALL cl_err('','sub-146',0)
                        LET g_coy_1[l_ac].coyslip = g_coy_1_t.coyslip
                        NEXT FIELD coyslip
                     END IF
                  END FOR
                  #NO.FUN-560150 --end--
               END IF
            #NO:6842
            --#LET g_coy_1[l_ac].coyslip=fgl_dialog_getbuffer()
              IF g_coy_1[l_ac].coyslip != g_coy_1_t.coyslip THEN
                  UPDATE smv_file  SET smv01=g_coy_1[l_ac].coyslip
                   WHERE smv01=g_coy_1_t.coyslip   #NO:單別
                     #AND smv03=g_sys              #NO:系統別  #TQC-670008 reamrk
                     AND upper(smv03)='ACO'        #NO:系統別  #TQC-670008
                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('UPDATE smv_file',SQLCA.sqlcode,0) #No.TQC-660045
                      CALL cl_err3("upd","smv_file",g_coy_1_t.coyslip,g_sys,SQLCA.sqlcode,"","UPDATE smv_file",1)  #TQC-660045
                      LET l_ac_t = l_ac
                      EXIT INPUT
                   END IF
                   UPDATE smu_file  SET smu01=g_coy_1[l_ac].coyslip
                    WHERE smu01=g_coy_1_t.coyslip  #NO:單別
                      #AND smu03=g_sys             #NO:系統別  #TQC-670008 remark
                      AND upper(smu03)='ACO'       #NO:系統別  #TQC-670008
                  IF SQLCA.sqlcode THEN
#                     CALL cl_err('UPDATE smu_file',SQLCA.sqlcode,0) #No.TQC-660045
                      CALL cl_err3("upd","cmu_file",g_coy_1_t.coyslip,g_sys,SQLCA.sqlcode,"","UPDATE smu_file",1)  #TQC-660045
                      LET l_ac_t = l_ac
                      EXIT INPUT
                  END IF
              END IF
         #-NO:6842
            END IF
 
#No.FUN-550036  --start
#        AFTER FIELD coykind
#           IF NOT cl_null(g_coy[l_ac].coykind) THEN
#              IF g_coy[l_ac].coykind NOT MATCHES '[12]' THEN
#                 NEXT FIELD coykind
#              END IF
#           END IF
#No.FUN-550036  --end
 
        AFTER FIELD coytype
           IF NOT cl_null(g_coy_1[l_ac].coytype) THEN
             #FUN-A10109  START 
             #IF g_coy_1[l_ac].coytype != '00' AND g_coy_1[l_ac].coytype != '05' AND
             #   g_coy_1[l_ac].coytype NOT MATCHES '1[0-9]' THEN
             #   NEXT FIELD coytype
             #END IF
             #FUN-A10109  END
           END IF
 
        AFTER FIELD coyslip2
           IF NOT cl_null(g_coy_1[l_ac].coyslip2) THEN
              SELECT coyslip FROM coy_file
               WHERE coyslip = g_coy_1[l_ac].coyslip2 AND coytype = '05'
              IF STATUS THEN
#                CALL cl_err(g_coy_1[l_ac].coyslip2,'mfg0014',0) #No.TQC-660045
#                CALL cl_err3("sel","coy_file",g_coy_1[l_ac].coyslip2,"","mfg0014","","",1)     #TQC-660045
                 CALL cl_err3("sel","coy_file",g_coy_1[l_ac].coyslip2,"","aco-914","","",1)     #TQC-660045  #TQC-B90159
                 NEXT FIELD coyslip2
              END IF
              #NO.FUN-560150 --start--
              IF g_coy_1[l_ac].coyslip2 != g_coy_1_t.coyslip2 OR
                 cl_null(g_coy_1_t.coyslip2) THEN
                 FOR l_i = 1 TO g_doc_len
                    IF cl_null(g_coy_1[l_ac].coyslip2[l_i,l_i]) THEN
                       CALL cl_err('','sub-146',0)
                       NEXT FIELD coyslip2
                    END IF
                 END FOR
              END IF
              #NO.FUN-560150 --end--
           END IF

        #FUN-B50039-add-str--
        AFTER FIELD coyud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coyud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-B50039-add-end--

 
        BEFORE DELETE                            #是否撤銷單身
            IF g_coy_1_t.coyslip IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM coy_file WHERE coyslip = g_coy_1_t.coyslip
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_coy_1_t.coyslip,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","coy_file",g_coy_1_t.coyslip,"",SQLCA.sqlcode,"","",1)  #TQC-660045
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF

                DELETE FROM smv_file WHERE smv01 = g_coy_1_t.coyslip
                   #AND smv03=g_sys  #NO:6842 #TQC-670008 remark
                   AND upper(smv03)='ACO'     #TQC-670007
                IF SQLCA.sqlcode THEN
#                   CALL cl_err('fav_file',SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","smv_file",g_coy_1_t.coyslip,"",SQLCA.sqlcode,"","fav_file",1)  #TQC-660045                   
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM smu_file WHERE smu01 = g_coy_1_t.coyslip
                   #AND smu03=g_sys   #NO:6842  #TQC-670008 remark
                   AND upper(smu03)='ACO'       #TQC-670008
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_coy_1_t.coyslip,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","smu_file",g_coy_1_t.coyslip,"",SQLCA.sqlcode,"","",1)  #TQC-660045 
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                #FUN-A10109  ===S===
                CALL s_access_doc('r','','',g_coy_1_t.coyslip,'ACO','')
                #FUN-A10109  ===E===
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i010_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_coy_1[l_ac].* = g_coy_1_t.*
               CLOSE i010_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_coy_1[l_ac].coyslip,-263,1)
               LET g_coy_1[l_ac].* = g_coy_1_t.*
            ELSE
#              UPDATE g_coy_1_file SET coyslip = g_coy_1[l_ac].coyslip,  #No.TQC-650123 MARK
               UPDATE coy_file SET coyslip = g_coy_1[l_ac].coyslip,  #No.TQC-650123
                                   coydesc = g_coy_1[l_ac].coydesc,
                                   coyauno = g_coy_1[l_ac].coyauno,
                                   #coykind = g_coy_1[l_ac].coykind, #FUN-A10109
                                   coytype = g_coy_1[l_ac].coytype,
                                   coyslip2= g_coy_1[l_ac].coyslip2,
                                   #FUN-B50039-add-str--
                                   coyud01 = g_coy_1[l_ac].coyud01,
                                   coyud02 = g_coy_1[l_ac].coyud02,
                                   coyud03 = g_coy_1[l_ac].coyud03,
                                   coyud04 = g_coy_1[l_ac].coyud04,
                                   coyud05 = g_coy_1[l_ac].coyud05,
                                   coyud06 = g_coy_1[l_ac].coyud06,
                                   coyud07 = g_coy_1[l_ac].coyud07,
                                   coyud08 = g_coy_1[l_ac].coyud08,
                                   coyud09 = g_coy_1[l_ac].coyud09,
                                   coyud10 = g_coy_1[l_ac].coyud10,
                                   coyud11 = g_coy_1[l_ac].coyud11,
                                   coyud12 = g_coy_1[l_ac].coyud12,
                                   coyud13 = g_coy_1[l_ac].coyud13,
                                   coyud14 = g_coy_1[l_ac].coyud14,
                                   coyud15 = g_coy_1[l_ac].coyud15
                                   #FUN-B50039-add-str--
                WHERE coyslip = g_coy_1_t.coyslip
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_coy_1[l_ac].coyslip,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","coy_file",g_coy_1[l_ac].coyslip,"",SQLCA.sqlcode,"","",1)  #TQC-660045
                   LET g_coy_1[l_ac].* = g_coy_1_t.*
               ELSE
                   #FUN-A10109  ===S===
                   CALL s_access_doc('r','','',g_coy_1_t.coyslip,'ACO','')
                   CALL s_access_doc('a',g_coy_1[l_ac].coyauno,g_coy_1[l_ac].coytype,
                                     g_coy_1[l_ac].coyslip,'ACO','Y')
                   #FUN-A10109 ===E===
                   MESSAGE 'UPDATE O.K'
                   CLOSE i010_bcl
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_coy_1[l_ac].* = g_coy_1_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_coy_1.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE i010_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
          #CKP
          #LET g_coy_1_t.* = g_coy_1[l_ac].*          # 900423
            CLOSE i010_bcl
            COMMIT WORK
            #CKP2
           #CALL g_coy_1.deleteElement(g_rec_b+1)     #FUN-D30034 Mark
 
        ON ACTION CONTROLN
            CALL i010_b_askkey()
            EXIT INPUT

        #TQC-B90159 add ----begin---------------
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(coyslip2)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_coyslip2"
                 CALL cl_create_qry() RETURNING g_coy_1[l_ac].coyslip2
                 DISPLAY BY NAME g_coy_1[l_ac].coyslip2
           END CASE
        #TQC-B90159 add -----end----------------
 
        ON ACTION user_auth     #bug no:4948,NO:6842
               LET g_action_choice='user_auth'                        #TQC-670039 add
               #--#LET g_coy_1[l_ac].coyslip=fgl_dialog_getbuffer()   #TQC-670039 mark
               IF NOT cl_null(g_coy_1[l_ac].coyslip) THEN
                   IF cl_chk_act_auth() THEN
                     #CALL s_smu(g_coy_1[l_ac].coyslip,g_sys)  #TQC-660133 remark
                      CALL s_smu(g_coy_1[l_ac].coyslip,"ACO")  #TQC-660133
                   END IF
               ELSE
                   CALL cl_err('','anm-217',0)
               END IF
 
        ON ACTION dept_auth     #NO:6842
               LET g_action_choice='dept_auth'                        #TQC-670039 add
               #--#LET g_coy_1[l_ac].coyslip=fgl_dialog_getbuffer()   #TQC-670039 mark
               IF NOT cl_null(g_coy_1[l_ac].coyslip) THEN
                   IF cl_chk_act_auth() THEN
                     #CALL s_smv(g_coy_1[l_ac].coyslip,g_sys)  #TQC-660133 remark
                      CALL s_smv(g_coy_1[l_ac].coyslip,"ACO")  #TQC-660133
                   END IF
               ELSE
                   CALL cl_err('','anm-217',0)
               END IF
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(coyslip) AND l_ac > 1 THEN
                LET g_coy_1[l_ac].* = g_coy_1[l_ac-1].*
                NEXT FIELD coyslip
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
 
    CLOSE i010_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_b_askkey()
    CLEAR FORM
    CALL g_coy_1.clear()
    CONSTRUCT g_wc2 ON coyslip,coydesc,coyauno,
                       #coykind, #FUN-A10109
                       coytype,coyslip2,
                       coyud01,coyud02,coyud03,coyud04,coyud05,coyud06,coyud07,                #FUN-B50039
                       coyud08,coyud09,coyud10,coyud11,coyud12,coyud13,coyud14,coyud15         #FUN-B50039
            FROM s_coy[1].coyslip,s_coy[1].coydesc,s_coy[1].coyauno,
                 #s_coy[1].coykind, #FUN-A10109
                 s_coy[1].coytype,
                 s_coy[1].coyslip2,
                 s_coy[1].coyud01,s_coy[1].coyud02,s_coy[1].coyud03,s_coy[1].coyud04,s_coy[1].coyud05,    #FUN-B50039
                 s_coy[1].coyud06,s_coy[1].coyud07,s_coy[1].coyud08,s_coy[1].coyud09,s_coy[1].coyud10,    #FUN-B50039
                 s_coy[1].coyud11,s_coy[1].coyud12,s_coy[1].coyud13,s_coy[1].coyud14,s_coy[1].coyud15     #FUN-B50039
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN

       #TQC-B90159 add ----begin---------------
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(coyslip2)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_coyslip2"
                LET g_qryparam.state = "c"
                LET g_qryparam.default1 = g_coy_1[1].coyslip2
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO coyslip2
          END CASE
       #TQC-B90159 add -----end----------------

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
    CALL i010_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT coyslip,coydesc,coyauno,",
        #"        coykind, ",#FUN-A10109 TSD.zeak
        "       coytype,coyslip2,",
        "       coyud01,coyud02,coyud03,coyud04,coyud05,coyud06,coyud07,coyud08,",
        "       coyud09,coyud10,coyud11,coyud12,coyud13,coyud14,coyud15 ",
        " FROM coy_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY coytype,coyslip"
    PREPARE i010_pb FROM g_sql
    DECLARE coy_curs CURSOR FOR i010_pb
 
    CALL g_coy_1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH coy_curs INTO g_coy_1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_coy_1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2
        LET g_cnt = 0
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_coy_1 TO s_coy.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      # Standard 4ad ACTION
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
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-780040 --start-- mark
{FUNCTION i010_out()
    DEFINE
        l_coy           RECORD LIKE coy_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680069 VARCHAR(20) # External(Disk) file name
        l_za05          LIKE cob_file.cob01           #No.FUN-680069 VARCHAR(40)                #
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    #LET l_name = 'acoi010.out'
    CALL cl_outnam('acoi010') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM coy_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i010_co  CURSOR FOR i010_p1
 
    START REPORT i010_rep TO l_name
 
    FOREACH i010_co INTO l_coy.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i010_rep(l_coy.*)
    END FOREACH
 
    FINISH REPORT i010_rep
 
    CLOSE i010_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i010_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        sr RECORD       LIKE coy_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.coytype,sr.coyslip
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
                  LET g_pageno = g_pageno + 1
                  LET pageno_total = PAGENO USING '<<<',"/pageno"
                  PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.coyslip,
                  COLUMN g_c[32],sr.coydesc,
                  COLUMN g_c[33],sr.coyauno,
                  COLUMN g_c[34],sr.coykind,
                  COLUMN g_c[35],sr.coytype,
                  COLUMN g_c[36],sr.coyslip2
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-780040 --end--
#No.FUN-570109 --begin
FUNCTION i010_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("coyslip",TRUE)
   END IF
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("coyslip",FALSE)
   END IF
END FUNCTION
#No.FUN-570109 --end
#Patch....NO.TQC-610035 <001,002,003,004,005,006,007,008,009,011,012,014,015,016,017,018,019,020,021,022,023,024,025> #

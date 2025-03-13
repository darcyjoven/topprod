# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: axmi1101.4gl
# Descriptions...: 售货动作基本资料维护 
# Date & Author..: No.FUN-9A0036 09/10/27 By vealxu  
# Modify.........: No.FUN-A30006 10/03/02 By vealxu 
# Modify.........: No.FUN-A40047 10/05/17 By vealxu 新增時沒有進入AFTER FIELD
# Modify.........: No.FUN-A60002 10/06/07 By vealxu 功能單
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50111 10/07/01 by belle  加入有效起始(年/月) 及 有效截止(年/月)
# Modify.........: No.FUN-B70059 11/07/19 by belle 增加條件選項設定收入分類,，可單獨只設定"客戶"
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_ocs DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ocs011      LIKE ocs_file.ocs011, #FUN-A30006
        ocs012      LIKE ocs_file.ocs012, #FUN-A30006
        ocs01       LIKE ocs_file.ocs01,  #FUN-A30006
        ocs02       LIKE ocs_file.ocs02,
        ocr02       LIKE ocr_file.ocr02,
        ocs03       LIKE ocs_file.ocs03,
        aag02       LIKE aag_file.aag02,
        ocs031      LIKE ocs_file.ocs031,
        aag02_1     LIKE aag_file.aag02,
        ocs04       LIKE ocs_file.ocs04,
        ocs05       LIKE ocs_file.ocs05,
        ocs06       LIKE ocs_file.ocs06,  #FUN-B50111
        ocs07       LIKE ocs_file.ocs07,  #FUN-B50111
        ocs08       LIKE ocs_file.ocs08,  #FUN-B50111
        ocs09       LIKE ocs_file.ocs09   #FUN-B50111
                    END RECORD,
    g_ocs_t         RECORD                        #程式變數 (舊值)
        ocs011      LIKE ocs_file.ocs011, #FUN-A30006
        ocs012      LIKE ocs_file.ocs012, #FUN-A30006
        ocs01       LIKE ocs_file.ocs01,  #FUN-A30006
        ocs02       LIKE ocs_file.ocs02,
        ocr02       LIKE ocr_file.ocr02,
        ocs03       LIKE ocs_file.ocs03,
        aag02       LIKE aag_file.aag02,
        ocs031      LIKE ocs_file.ocs031,
        aag02_1     LIKE aag_file.aag02,
        ocs04       LIKE ocs_file.ocs04,
        ocs05       LIKE ocs_file.ocs05,
        ocs06       LIKE ocs_file.ocs06,  #FUN-B50111
        ocs07       LIKE ocs_file.ocs07,  #FUN-B50111
        ocs08       LIKE ocs_file.ocs08,  #FUN-B50111
        ocs09       LIKE ocs_file.ocs09   #FUN-B50111
                    END RECORD,
    g_wc2,g_sql    string,                       
    g_rec_b         LIKE type_file.num5,          #單身筆數 
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5      

DEFINE g_forupd_sql          STRING               #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt                 LIKE type_file.num10 
DEFINE g_i                   LIKE type_file.num5  #count/index for any purpose        #No.FUN-680137 SMALLINT

MAIN
   OPTIONS                               
      INPUT NO WRAP                      #輸入的方式: 不打轉 
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
        RETURNING g_time               

   LET p_row = 2 LET p_col = 3

   OPEN WINDOW i1101_w AT p_row,p_col WITH FORM "axm/42f/axmi1101"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()

   LET g_wc2 = '1=1'
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("ocs031,aag02_1",FALSE)
   ELSE
      CALL cl_set_comp_visible("ocs031,aag02_1",TRUE)
   END IF

   CALL i1101_b_fill(g_wc2)

   CALL i1101_menu()

   CLOSE WINDOW i1101_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
       RETURNING g_time              

END MAIN

FUNCTION i1101_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CALL i1101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i1101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i1101_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ocs),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION i1101_q()

   CALL i1101_b_askkey()

END FUNCTION

FUNCTION i1101_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,                #檢查重複用
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
          p_cmd           LIKE type_file.chr1,                #處理狀態
          l_allow_insert  LIKE type_file.num5,                #可新增否
          l_allow_delete  LIKE type_file.num5                 #可刪除否
   DEFINE l_i             LIKE type_file.num5
#FUN-B50111--begin
   DEFINE l_date_start    LIKE type_file.dat 
   DEFINE l_date_end      LIKE type_file.dat 
   DEFINE l_date_s        LIKE type_file.dat
   DEFINE l_date_e        LIKE type_file.dat
   DEFINE l_ocs06_temp    STRING 
   DEFINE l_ocs07_temp    STRING
   DEFINE l_ocs08_temp    STRING
   DEFINE l_ocs09_temp    STRING
   DEFINE
         l_ocs DYNAMIC ARRAY OF RECORD
           ocs01       LIKE ocs_file.ocs01,
           ocs02       LIKE ocs_file.ocs02,
           ocs011      LIKE ocs_file.ocs011,
           ocs012      LIKE ocs_file.ocs012,
           ocs06       LIKE ocs_file.ocs06,
           ocs07       LIKE ocs_file.ocs07,
           ocs08       LIKE ocs_file.ocs08,
           ocs09       LIKE ocs_file.ocs09
                END RECORD

#FUN-B50111--end
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = "  SELECT ocs011,ocs012,ocs01,",  #FUN-A30006 add
                     #"  ocs02,'',ocs03,'',ocs031,'',ocs04,ocs05 FROM ocs_file",   #FUN-B50111 mark
                     #"  WHERE ocs01=? AND ocs011=? AND ocs012=? AND ocs02=? FOR UPDATE" #FUN-B50111 mark #FUN-A30006 add ocs011,ocs012
                      "  ocs02,'',ocs03,'',ocs031,'',ocs04,ocs05,",              #FUN-B50111 add
                      "  ocs06,ocs07,ocs08,ocs09 FROM ocs_file",                 #FUN-B50111 add
                      "  WHERE ocs01=? AND ocs011=? AND ocs012=? AND ocs02=? AND ocs06= ? AND ocs07= ? AND ocs08 = ? AND ocs09 =? FOR UPDATE" #FUN-B50111 add
   CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql
   DECLARE i1101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_ocs WITHOUT DEFAULTS FROM s_ocs.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_doctype_format("ocs01")
#FUN-A40047 --Begin
#FUN-A30006 --Begin
#        IF l_ac<>0 THEN
#           CALL i1101_set_no_required(g_ocs[l_ac].ocs011)
#        END IF
#FUN-A30006 --End
#FUN-A40047 --End

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'

         IF g_rec_b >= l_ac THEN
            LET g_ocs_t.* = g_ocs[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
           #OPEN i1101_bcl USING g_ocs_t.ocs01,g_ocs_t.ocs011,g_ocs_t.ocs012,g_ocs_t.ocs02 #FUN-B50111 mark #FUN-A30006 add ocs011,ocs012
            OPEN i1101_bcl USING g_ocs_t.ocs01,g_ocs_t.ocs011,g_ocs_t.ocs012,g_ocs_t.ocs02,g_ocs_t.ocs06,g_ocs_t.ocs07,g_ocs_t.ocs08,g_ocs_t.ocs09   #FUN-B50111 add
            IF STATUS THEN
               CALL cl_err("OPEN i1101_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i1101_bcl INTO g_ocs[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ocs_t.ocs02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i1101_ocr02(g_ocs[l_ac].ocs02) 
                       RETURNING g_ocs[l_ac].ocr02
                  CALL i1101_chk_acc_entry(g_ocs[l_ac].ocs03,g_aza.aza81)
                       RETURNING g_ocs[l_ac].aag02
                  CALL i1101_chk_acc_entry(g_ocs[l_ac].ocs031,g_aza.aza82)
                       RETURNING g_ocs[l_ac].aag02_1
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i1101_set_entry(p_cmd)                                        
            CALL i1101_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ocs[l_ac].* TO NULL
         LET g_ocs_t.* = g_ocs[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                   
         CALL i1101_set_entry(p_cmd)                                        
         CALL i1101_set_no_entry(p_cmd)                                     
         LET g_before_input_done = TRUE

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_ocs[l_ac].ocs011) THEN  LET g_ocs[l_ac].ocs011=' ' END IF
         IF cl_null(g_ocs[l_ac].ocs012) THEN  LET g_ocs[l_ac].ocs012=' ' END IF
         IF cl_null(g_ocs[l_ac].ocs01) THEN  LET g_ocs[l_ac].ocs01=' ' END IF
        #FUN-B50111--begin--
         IF NOT cl_null(g_ocs[l_ac].ocs06) AND NOT cl_null(g_ocs[l_ac].ocs07) AND NOT cl_null(g_ocs[l_ac].ocs08) AND NOT cl_null(g_ocs[l_ac].ocs09) THEN
           LET l_date_start = MDY(g_ocs[l_ac].ocs07,1,g_ocs[l_ac].ocs06)
           LET l_date_end = MDY(g_ocs[l_ac].ocs09,1,g_ocs[l_ac].ocs08)
           IF l_date_start > l_date_end THEN
              CALL cl_err('','axm1042',1)   #起始年月不能小於截止年月
              NEXT FIELD ocs06
           END IF
             LET l_date_start = MDY(g_ocs[l_ac].ocs07,1,g_ocs[l_ac].ocs06)
             LET l_date_end = MDY(g_ocs[l_ac].ocs09,1,g_ocs[l_ac].ocs08)
             IF cl_null(g_ocs_t.ocs08) AND cl_null(g_ocs_t.ocs09) AND cl_null(g_ocs_t.ocs06) AND cl_null(g_ocs_t.ocs07) THEN
                LET g_sql = " SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?"
             ELSE
                LET g_sql = " SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE ",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?",
                            " MINUS ",
                            " SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?",
                            " AND ocs06 = ? AND ocs07 = ? AND ocs08 = ? AND ocs09 = ?"
             END IF
                PREPARE i1101_b1 FROM g_sql
                DECLARE i1101_b1_curs CURSOR FOR i1101_b1
             IF cl_null(g_ocs_t.ocs08) AND cl_null(g_ocs_t.ocs09) AND cl_null(g_ocs_t.ocs06) AND cl_null(g_ocs_t.ocs07) THEN
                OPEN i1101_b1_curs USING g_ocs[l_ac].ocs01,g_ocs[l_ac].ocs02,g_ocs[l_ac].ocs011,g_ocs[l_ac].ocs012
             ELSE
                OPEN i1101_b1_curs USING g_ocs_t.ocs01,g_ocs_t.ocs02,g_ocs_t.ocs011,g_ocs_t.ocs012,
                                         g_ocs_t.ocs01,g_ocs_t.ocs02,g_ocs_t.ocs011,g_ocs_t.ocs012,
                                         g_ocs_t.ocs06,g_ocs_t.ocs07,g_ocs_t.ocs08,g_ocs_t.ocs09
             END IF
             CALL l_ocs.clear()
             LET g_cnt = 1
             FOREACH i1101_b1_curs INTO l_ocs[g_cnt].*
                LET l_ocs06_temp = l_ocs[g_cnt].ocs06
                LET l_ocs06_temp = l_ocs06_temp.trim()
                LET l_ocs07_temp = l_ocs[g_cnt].ocs07
                LET l_ocs07_temp = l_ocs07_temp.trim()
                LET l_ocs08_temp = l_ocs[g_cnt].ocs08
                LET l_ocs08_temp = l_ocs08_temp.trim()
                LET l_ocs09_temp = l_ocs[g_cnt].ocs09
                LET l_ocs09_temp = l_ocs09_temp.trim()
                LET l_date_s = MDY(l_ocs07_temp,'1',l_ocs06_temp)
                LET l_date_e = MDY(l_ocs09_temp,'1',l_ocs08_temp)
                IF l_date_start >= l_date_s AND l_date_start <= l_date_e THEN
                   CALL cl_err('','axm1041',1)
                   NEXT FIELD ocs06
                   EXIT FOREACH
                END IF
                IF l_date_end >= l_date_s AND l_date_end <= l_date_e THEN
                   CALL cl_err('','axm1041',1)
                   NEXT FIELD ocs08
                   EXIT FOREACH
                END IF
                IF l_date_start >= l_date_s AND l_date_end <= l_date_e THEN
                   CALL cl_err('','axm1041',1)
                   NEXT FIELD ocs06
                   EXIT FOREACH
                END IF
                LET g_cnt = g_cnt + 1
                IF g_cnt > g_max_rec THEN
                   CALL cl_err( '', 9035, 0 )
                   EXIT FOREACH
                END IF
            END FOREACH
         END IF
        #FUN-B50111---end---
        #INSERT INTO ocs_file(ocs01,ocs011,ocs012,ocs02,ocs03,ocs031,ocs04,ocs05)  #FUN-B50111 mark  #FUN-A30006 add ocs011,ocs012
         INSERT INTO ocs_file(ocs01,ocs011,ocs012,ocs02,ocs03,ocs031,ocs04,ocs05,ocs06,ocs07,ocs08,ocs09)  #FUN-B50111 add
              VALUES(g_ocs[l_ac].ocs01,g_ocs[l_ac].ocs011, #FUN-A30006 g_argv1->ocs01
                     g_ocs[l_ac].ocs012, #FUN-A30006 add ocs011,ocs012
                     g_ocs[l_ac].ocs02,
                     g_ocs[l_ac].ocs03,g_ocs[l_ac].ocs031,
                     g_ocs[l_ac].ocs04,g_ocs[l_ac].ocs05,
                     g_ocs[l_ac].ocs06,g_ocs[l_ac].ocs07,g_ocs[l_ac].ocs08,g_ocs[l_ac].ocs09)  #FUN-B50111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ocs_file",g_ocs[l_ac].ocs01,g_ocs[l_ac].ocs02,SQLCA.sqlcode,"","",1) #FUN-A30006 g_argv1->ocs01
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
#FUN-A30006 --Begin
     AFTER FIELD ocs011
         IF NOT cl_null(g_ocs[l_ac].ocs011) THEN
            SELECT COUNT(*) INTO l_n FROM occ_file
             WHERE occ01=g_ocs[l_ac].ocs011
               AND occacti='Y'
            IF l_n=0 THEN
               CALL cl_err('','anm-045',0)
               NEXT FIELD ocs011
            END IF
         END IF      
#FUN-A30006 --Begin
     BEFORE FIELD ocs012
#FUN-A40047 --Begin
#        CALL i1101_set_required(g_ocs[l_ac].ocs011)
#        CALL i1101_set_no_required(g_ocs[l_ac].ocs011)
         CALL i1101_set_no_required()
         CALL i1101_set_required()
#FUN-A40047 --End
#FUN-A30006 --End

     AFTER FIELD ocs012  
         IF NOT cl_null(g_ocs[l_ac].ocs012) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_ocs[l_ac].ocs012,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_ocs[l_ac].ocs012= g_ocs_t.ocs012
               NEXT FIELD ocs012
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            SELECT COUNT(*) INTO l_n FROM ima_file 
             WHERE ima01=g_ocs[l_ac].ocs012
            IF l_n=0 THEN
               CALL cl_err('','-9911',0)
               NEXT FIELD ocs012
            END IF
         END IF
  ##NO.FUN-A60002 
         IF cl_null(g_ocs[l_ac].ocs012) THEN 
            LET g_ocs[l_ac].ocs012=' ' 
         END IF
  ##NO.FUN-A60002 


     AFTER FIELD ocs01
         IF NOT cl_null(g_ocs[l_ac].ocs01) THEN
            SELECT COUNT(*) INTO l_n FROM oba_file 
             WHERE oba01=g_ocs[l_ac].ocs01
            IF l_n=0 THEN
               CALL cl_err('','aim-142',0)
               NEXT FIELD ocs01
            END IF
         END IF
#FUN-A30006 --End

      AFTER FIELD ocs02 #check 是否重複 
         IF g_ocs[l_ac].ocs02 IS NOT NULL THEN
            IF g_ocs[l_ac].ocs02 != g_ocs_t.ocs02 OR
               (NOT cl_null(g_ocs[l_ac].ocs02) AND cl_null(g_ocs_t.ocs02)) THEN
               SELECT count(*) INTO l_n FROM ocs_file
                WHERE ocs01 = g_ocs[l_ac].ocs01  #FUN-A30006 g_argv1->ocs01
                  AND ocs011= g_ocs[l_ac].ocs011 #FUN-A30006
                  AND ocs012= g_ocs[l_ac].ocs012 #FUN-A30006
                  AND ocs02 = g_ocs[l_ac].ocs02
                  AND ocs06 = g_ocs[l_ac].ocs06  #FUN-B50111
                  AND ocs07 = g_ocs[l_ac].ocs07  #FUN-B50111
                  AND ocs08 = g_ocs[l_ac].ocs08  #FUN-B50111
                  AND ocs09 = g_ocs[l_ac].ocs09  #FUN-B50111
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ocs[l_ac].ocs02 = g_ocs_t.ocs02
                 #LET g_ocs[l_ac].ocs011= g_ocs_t.ocs011   #FUN-A30006 #FUN-A40047
                 #LET g_ocs[l_ac].ocs012 = g_ocs_t.ocs012  #FUN-A30006 #FUN-A40046
                  NEXT FIELD ocs02
               ELSE
                  SELECT COUNT(*) INTO l_n FROM ocr_file
                   WHERE ocr01=g_ocs[l_ac].ocs02
                  IF l_n=0 THEN
                    #CALL cl_err('','axm-136',0)             #FUN-9A0036
                     CALL cl_err('','axm-494',0)             #FUN-9A0036
                     LET g_ocs[l_ac].ocs02 = g_ocs_t.ocs02
                    #LET g_ocs[l_ac].ocs011= g_ocs_t.ocs011   #FUN-A30006
                    #LET g_ocs[l_ac].ocs012 = g_ocs_t.ocs012  #FUN-A30006
                     NEXT FIELD ocs02
                  ELSE
                     CALL i1101_ocr02(g_ocs[l_ac].ocs02) 
                         RETURNING g_ocs[l_ac].ocr02
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD ocs03
         IF NOT cl_null(g_ocs[l_ac].ocs03) THEN
            CALL i1101_chk_acc_entry(g_ocs[l_ac].ocs03,g_aza.aza81)
                 RETURNING g_ocs[l_ac].aag02
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ocs[l_ac].ocs03
               LET g_qryparam.arg1 = g_aza.aza81
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag01 LIKE '",g_ocs[l_ac].ocs03 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs03
               DISPLAY BY NAME g_ocs[l_ac].ocs03
               #End Add No.FUN-B10048
               NEXT FIELD ocs03
            END IF
         ELSE
            LET g_ocs[l_ac].aag02 = ''
         END IF
      AFTER FIELD ocs04
         IF NOT cl_null(g_ocs[l_ac].ocs04) THEN
            IF g_ocs[l_ac].ocs04 < 0 THEN
               CALL cl_err('','aec-002',0)
               NEXT FIELD ocs04
            END IF
         END IF 
         
      AFTER FIELD ocs05
         IF NOT cl_null(g_ocs[l_ac].ocs05) THEN
            IF g_ocs[l_ac].ocs05 < 0 THEN
               CALL cl_err('','aec-002',0)
               NEXT FIELD ocs05
            END IF
         END IF 

      AFTER FIELD ocs031
         IF NOT cl_null(g_ocs[l_ac].ocs031) THEN
            CALL i1101_chk_acc_entry(g_ocs[l_ac].ocs031,g_aza.aza82)
                 RETURNING g_ocs[l_ac].aag02_1
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #Add No.FUN-B10048
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_ocs[l_ac].ocs031
               LET g_qryparam.arg1 = g_aza.aza82
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' AND aag01 LIKE '",g_ocs[l_ac].ocs031 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs031
               DISPLAY BY NAME g_ocs[l_ac].ocs031
               #End Add No.FUN-B10048
               NEXT FIELD ocs031
            END IF
         ELSE
            LET g_ocs[l_ac].aag02_1 = ''
         END IF

      #FUN-B50111---begin---
       AFTER FIELD ocs07
         IF cl_null(g_ocs[l_ac].ocs011) THEN  LET g_ocs[l_ac].ocs011=' ' END IF
         IF cl_null(g_ocs[l_ac].ocs012) THEN  LET g_ocs[l_ac].ocs012=' ' END IF
         IF cl_null(g_ocs[l_ac].ocs01) THEN  LET g_ocs[l_ac].ocs01=' ' END IF
         IF NOT cl_null(g_ocs[l_ac].ocs07) THEN
            IF g_ocs[l_ac].ocs07 < 1 OR g_ocs[l_ac].ocs07> 12 THEN
               CALL cl_err('','aom-580',1)
               NEXT FIELD ocs07
            END IF
         END IF
	 #如果起訖年月四個欄位都有值
         IF NOT cl_null(g_ocs[l_ac].ocs06) AND NOT cl_null(g_ocs[l_ac].ocs07) AND NOT cl_null(g_ocs[l_ac].ocs08) AND NOT cl_null(g_ocs[l_ac].ocs09) THEN
            LET l_date_start = MDY(g_ocs[l_ac].ocs07,1,g_ocs[l_ac].ocs06)
            LET l_date_end = MDY(g_ocs[l_ac].ocs09,1,g_ocs[l_ac].ocs08)
            IF l_date_start > l_date_end THEN
               CALL cl_err('','axm1042',1)   #起始年月不能小於截止年月
               NEXT FIELD ocs06
            END IF
         END IF
         #如果起始年月有值
         IF NOT cl_null(g_ocs[l_ac].ocs06) AND NOT cl_null(g_ocs[l_ac].ocs07) THEN
             LET l_date_start = MDY(g_ocs[l_ac].ocs07,1,g_ocs[l_ac].ocs06)
             IF cl_null(g_ocs_t.ocs08) AND cl_null(g_ocs_t.ocs09) AND cl_null(g_ocs_t.ocs06) AND cl_null(g_ocs_t.ocs07) THEN 
                LET g_sql = "SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?"
             ELSE
                LET g_sql = "SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE ",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?",
                            " MINUS ",
                            " SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE ",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?",
                            " AND ocs06 = ? AND ocs07 = ? AND ocs08 = ? AND ocs09 = ?" 
             END IF
                PREPARE i1101_ocs07 FROM g_sql
                DECLARE ocs07_curs CURSOR FOR i1101_ocs07
             IF cl_null(g_ocs_t.ocs08) AND cl_null(g_ocs_t.ocs09) AND cl_null(g_ocs_t.ocs06) AND cl_null(g_ocs_t.ocs07) THEN 
                OPEN ocs07_curs USING g_ocs[l_ac].ocs01,g_ocs[l_ac].ocs02,g_ocs[l_ac].ocs011,g_ocs[l_ac].ocs012 
             ELSE
                OPEN ocs07_curs USING g_ocs_t.ocs01,g_ocs_t.ocs02,g_ocs_t.ocs011,g_ocs_t.ocs012, 
                                      g_ocs_t.ocs01,g_ocs_t.ocs02,g_ocs_t.ocs011,g_ocs_t.ocs012,
                                      g_ocs_t.ocs06,g_ocs_t.ocs07,g_ocs_t.ocs08,g_ocs_t.ocs09
             END IF
             CALL l_ocs.clear()
             LET g_cnt = 1
             FOREACH ocs07_curs INTO l_ocs[g_cnt].*
                LET l_ocs06_temp = l_ocs[g_cnt].ocs06
                LET l_ocs06_temp = l_ocs06_temp.trim()
                LET l_ocs07_temp = l_ocs[g_cnt].ocs07
                LET l_ocs07_temp = l_ocs07_temp.trim()
                LET l_ocs08_temp = l_ocs[g_cnt].ocs08
                LET l_ocs08_temp = l_ocs08_temp.trim()
                LET l_ocs09_temp = l_ocs[g_cnt].ocs09
                LET l_ocs09_temp = l_ocs09_temp.trim()
                LET l_date_s = MDY(l_ocs07_temp,'1',l_ocs06_temp)
                LET l_date_e = MDY(l_ocs09_temp,'1',l_ocs08_temp)
                IF l_date_start >= l_date_s AND l_date_start <= l_date_e THEN
                   CALL cl_err('','axm1041',1)
                   NEXT FIELD ocs06
                   EXIT FOREACH
                END IF
                LET g_cnt = g_cnt + 1 
                IF g_cnt > g_max_rec THEN
                   CALL cl_err( '', 9035, 0 )
                   EXIT FOREACH
                END IF
            END FOREACH
         END IF
      AFTER FIELD ocs09
         IF cl_null(g_ocs[l_ac].ocs011) THEN  LET g_ocs[l_ac].ocs011=' ' END IF
         IF cl_null(g_ocs[l_ac].ocs012) THEN  LET g_ocs[l_ac].ocs012=' ' END IF
         IF cl_null(g_ocs[l_ac].ocs01) THEN  LET g_ocs[l_ac].ocs01=' ' END IF
         IF NOT cl_null(g_ocs[l_ac].ocs09) THEN
            IF g_ocs[l_ac].ocs09 < 1 OR g_ocs[l_ac].ocs09 > 12 THEN
               CALL cl_err('','aom-580',1)
               NEXT FIELD ocs07
            END IF
         END IF
         IF NOT cl_null(g_ocs[l_ac].ocs06) AND NOT cl_null(g_ocs[l_ac].ocs07) AND NOT cl_null(g_ocs[l_ac].ocs08) AND NOT cl_null(g_ocs[l_ac].ocs09) THEN
            LET l_date_start = MDY(g_ocs[l_ac].ocs07,1,g_ocs[l_ac].ocs06)
            LET l_date_end = MDY(g_ocs[l_ac].ocs09,1,g_ocs[l_ac].ocs08)
            IF l_date_start > l_date_end THEN
               CALL cl_err('','axm1042',1)   #起始年月不能小於截止年月
               NEXT FIELD ocs06
            END IF
         END IF
        #如果截止年月有值
         IF (NOT cl_null(g_ocs[l_ac].ocs06) AND NOT cl_null(g_ocs[l_ac].ocs07)) THEN
             LET l_date_end = MDY(g_ocs[l_ac].ocs09,1,g_ocs[l_ac].ocs08)
             IF cl_null(g_ocs_t.ocs08) AND cl_null(g_ocs_t.ocs09) AND cl_null(g_ocs_t.ocs06) AND cl_null(g_ocs_t.ocs07) THEN 
                LET g_sql = " SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?"
            ELSE
                LET g_sql = " SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE ",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?",
                            " MINUS ",
                            " SELECT ocs01,ocs02,ocs011,ocs012,ocs06,ocs07,ocs08,ocs09 ",
                            " FROM OCS_FILE",
                            " WHERE ocs01 = ? AND ocs02 = ? AND ocs011 = ? AND ocs012 = ?",
                            " AND ocs06 = ? AND ocs07 = ? AND ocs08 = ? AND ocs09 = ?" 
             END IF
                PREPARE i1101_ocs09 FROM g_sql
                DECLARE ocs09_curs CURSOR FOR i1101_ocs09
             IF cl_null(g_ocs_t.ocs08) AND cl_null(g_ocs_t.ocs09) AND cl_null(g_ocs_t.ocs06) AND cl_null(g_ocs_t.ocs07) THEN 
                OPEN ocs09_curs USING g_ocs[l_ac].ocs01,g_ocs[l_ac].ocs02,g_ocs[l_ac].ocs011,g_ocs[l_ac].ocs012 
             ELSE
                OPEN ocs09_curs USING g_ocs_t.ocs01,g_ocs_t.ocs02,g_ocs_t.ocs011,g_ocs_t.ocs012,
                                      g_ocs_t.ocs01,g_ocs_t.ocs02,g_ocs_t.ocs011,g_ocs_t.ocs012,
                                      g_ocs_t.ocs06,g_ocs_t.ocs07,g_ocs_t.ocs08,g_ocs_t.ocs09
             END IF
             CALL l_ocs.clear()
             LET g_cnt = 1
             FOREACH ocs09_curs INTO l_ocs[g_cnt].*
                LET l_ocs06_temp = l_ocs[g_cnt].ocs06
                LET l_ocs06_temp = l_ocs06_temp.trim()
                LET l_ocs07_temp = l_ocs[g_cnt].ocs07
                LET l_ocs07_temp = l_ocs07_temp.trim()
                LET l_ocs08_temp = l_ocs[g_cnt].ocs08
                LET l_ocs08_temp = l_ocs08_temp.trim()
                LET l_ocs09_temp = l_ocs[g_cnt].ocs09
                LET l_ocs09_temp = l_ocs09_temp.trim()
                LET l_date_s = MDY(l_ocs07_temp,'1',l_ocs06_temp)
                LET l_date_e = MDY(l_ocs09_temp,'1',l_ocs08_temp)
                IF l_date_end >= l_date_s AND l_date_end <= l_date_e THEN
                   CALL cl_err('','axm1041',1)
                   NEXT FIELD ocs08
                   EXIT FOREACH
                END IF
                LET g_cnt = g_cnt + 1 
                IF g_cnt > g_max_rec THEN
                   CALL cl_err( '', 9035, 0 )
                   EXIT FOREACH
                END IF
            END FOREACH
         END IF
      #FUN-B50111---end


      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ocs01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba"
               LET g_qryparam.default1 = g_ocs[l_ac].ocs01
               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs01
               DISPLAY BY NAME g_ocs[l_ac].ocs01
              
            WHEN INFIELD(ocs011)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.default1 = g_ocs[l_ac].ocs011
               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs011
               DISPLAY BY NAME g_ocs[l_ac].ocs011

            WHEN INFIELD(ocs012)
#FUN-AA0059---------mod------------str-----------------            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.default1 = g_ocs[l_ac].ocs012
#               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs012
               CALL q_sel_ima(FALSE, "q_ima","",g_ocs[l_ac].ocs012,"","","","","",'' ) 
                RETURNING  g_ocs[l_ac].ocs012
#FUN-AA0059---------mod------------end-----------------

               DISPLAY BY NAME g_ocs[l_ac].ocs012

            WHEN INFIELD(ocs02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ocr"
               LET g_qryparam.default1 = g_ocs[l_ac].ocs02
               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs02
               DISPLAY BY NAME g_ocs[l_ac].ocs02
    
            WHEN INFIELD(ocs03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_ocs[l_ac].ocs03
               LET g_qryparam.arg1 = g_aza.aza81             
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' "
               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs03
               DISPLAY BY NAME g_ocs[l_ac].ocs03
            WHEN INFIELD(ocs031)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_ocs[l_ac].ocs031
               LET g_qryparam.arg1 = g_aza.aza82             
               LET g_qryparam.where = " aag07 MATCHES '[23]'  AND aag03 ='2' "
               CALL cl_create_qry() RETURNING g_ocs[l_ac].ocs031
               DISPLAY BY NAME g_ocs[l_ac].ocs031
         END CASE


      BEFORE DELETE                            #是否取消單身
         IF g_ocs_t.ocs02 IS NOT NULL THEN
 
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
          
            DELETE FROM ocs_file WHERE ocs01 = g_ocs_t.ocs01  #FUN-A30006 g_argv1->ocs01
                                   AND ocs02=g_ocs_t.ocs02
                                   AND ocs011= g_ocs_t.ocs011 AND ocs012=g_ocs_t.ocs012 #FUN-A30006
                                   AND ocs06= g_ocs_t.ocs06 AND ocs07=g_ocs_t.ocs07     #FUN-B50111
                                   AND ocs08= g_ocs_t.ocs08 AND ocs09=g_ocs_t.ocs09     #FUN-B50111
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ocs_file",g_ocs_t.ocs01,g_ocs_t.ocs02,SQLCA.sqlcode,"","",1) #FUN-A30006 g_argv1->ocs01
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            INITIALIZE g_ocs_t.* TO NULL           #FUN-B50111
            CLOSE i1101_bcl
            COMMIT WORK 
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ocs[l_ac].* = g_ocs_t.*
            CLOSE i1101_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ocs[l_ac].ocs02,-263,1)
            LET g_ocs[l_ac].* = g_ocs_t.*
         ELSE
            IF cl_null(g_ocs[l_ac].ocs011) THEN  LET g_ocs[l_ac].ocs011=' ' END IF
            IF cl_null(g_ocs[l_ac].ocs012) THEN  LET g_ocs[l_ac].ocs012=' ' END IF
            IF cl_null(g_ocs[l_ac].ocs01) THEN  LET g_ocs[l_ac].ocs01=' ' END IF
            UPDATE ocs_file SET
                   ocs01 =g_ocs[l_ac].ocs01,   #FUN-A30006
                   ocs011=g_ocs[l_ac].ocs011, #FUN-A30006
                   ocs012=g_ocs[l_ac].ocs012, #FUN-A30006
                   ocs02 =g_ocs[l_ac].ocs02,
                   ocs03 =g_ocs[l_ac].ocs03,ocs031=g_ocs[l_ac].ocs031,
                   ocs04 =g_ocs[l_ac].ocs04,ocs05=g_ocs[l_ac].ocs05,
                   ocs06 =g_ocs[l_ac].ocs06,ocs07=g_ocs[l_ac].ocs07,   #FUN-B50111
                   ocs08 =g_ocs[l_ac].ocs08,ocs09=g_ocs[l_ac].ocs09    #FUN-B50111
             WHERE ocs01 = g_ocs_t.ocs01                            #FUN-A30006 g_argv1->ocs01
               AND ocs02 = g_ocs_t.ocs02
               AND ocs011= g_ocs_t.ocs011 AND ocs012=g_ocs_t.ocs012 #FUN-A30006
               AND ocs06 = g_ocs_t.ocs06  AND ocs07 =g_ocs_t.ocs07  #FUN-B50111
               AND ocs08 = g_ocs_t.ocs08  AND ocs09 =g_ocs_t.ocs09  #FUN-B50111
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ocs_file",g_ocs[l_ac].ocs01,g_ocs_t.ocs02,SQLCA.sqlcode,"","",1)  #No.FUN-660167 #FUN-A30006 g_argv1->ocs01
               LET g_ocs[l_ac].* = g_ocs_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i1101_bcl
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
  ##NO.FUN-A60002   --begin  
#FUN-A30006 --Begin
#        IF NOT cl_null(g_ocs[l_ac].ocs011) AND cl_null(g_ocs[l_ac].ocs012) THEN
#           CALL cl_err('','axm-137',0)
#           NEXT FIELD ocs012
#        END IF
#FUN-A30006 --End
#FUN-B70059 --begin
#        IF NOT cl_null(g_ocs[l_ac].ocs011) THEN 
#           IF cl_null(g_ocs[l_ac].ocs012) AND cl_null(g_ocs[l_ac].ocs01) THEN
#              CALL cl_err('','axm-493',1)
#              NEXT FIELD ocs012
#           END IF
#        END IF
#FUN-B70059 --end
         IF cl_null(g_ocs[l_ac].ocs012) THEN 
            LET g_ocs[l_ac].ocs012=' ' 
         END IF
  ##NO.FUN-A60002   --end
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ocs[l_ac].* = g_ocs_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_ocs.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i1101_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE i1101_bcl
         COMMIT WORK
#FUN-A40047 --Begin mark
#FUN-A30006 --Begin
#    AFTER INPUT
#        IF NOT cl_null(g_ocs[l_ac].ocs011) AND cl_null(g_ocs[l_ac].ocs012) THEN
#           CALL cl_err('','axm-137',0)
#           NEXT FIELD ocs012
#        END IF
#FUN-A30006 --End
#FUN-A40047 --End mark


      ON ACTION CONTROLO                 
         IF INFIELD(ocs02) AND l_ac > 1 THEN
            LET g_ocs[l_ac].* = g_ocs[l_ac-1].*
            NEXT FIELD ocs02
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT

   CLOSE i1101_bcl
   COMMIT WORK

END FUNCTION


FUNCTION i1101_b_askkey()

   CLEAR FORM
   CALL g_ocs.clear()

  #CONSTRUCT g_wc2 ON ocs011,ocs012,ocs01,ocs02,ocs03,ocs031,ocs04,ocs05 #FUN-B50111 #FUN-A30006 add ocs011,ocs012,ocs01
   CONSTRUCT g_wc2 ON ocs011,ocs012,ocs01,ocs02,ocs03,ocs031,ocs04,ocs05,ocs06,ocs07,ocs08,ocs09 #FUN-B50111 add  #FUN-A30006 add ocs011,ocs012,ocs01
           FROM s_ocs[1].ocs011,s_ocs[1].ocs012,s_ocs[1].ocs01, #FUN-A30006
                s_ocs[1].ocs02,s_ocs[1].ocs03,s_ocs[1].ocs031,
                s_ocs[1].ocs04,s_ocs[1].ocs05,
                s_ocs[1].ocs06,s_ocs[1].ocs07,s_ocs[1].ocs08,s_ocs[1].ocs09  #FUN-B50111
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ocs011)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO g_ocs[l_ac].ocs011
            WHEN INFIELD(ocs012)
#FUN-AA0059---------mod------------str-----------------            
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = "c"
#               LET g_qryparam.form = "q_ima"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  
                 RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO g_ocs[l_ac].ocs012
            WHEN INFIELD(ocs01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_oba"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO g_ocs[l_ac].ocs01
            WHEN INFIELD(ocs02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ocr"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO g_ocs[l_ac].ocs02
            WHEN INFIELD(ocs03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_aag"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO g_ocs[l_ac].ocs03
            WHEN INFIELD(ocs031)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_aag"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO g_ocs[l_ac].ocs031
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
    
      ON ACTION qbe_select
         CALL cl_qbe_select() 

      ON ACTION qbe_save
	 CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

   CALL i1101_b_fill(g_wc2)

END FUNCTION

FUNCTION i1101_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000

   LET g_sql = "SELECT ocs011,ocs012,ocs01,",    #FUN-A30006
               "       ocs02,'',ocs03,'',ocs031,'',ocs04,ocs05,",
               "       ocs06,ocs07,ocs08,ocs09",  #FUN-B50111
               "  FROM ocs_file",
               " WHERE ", p_wc2 CLIPPED
#              "   AND ocs01 = '",g_argv1,"'"          #單身#FUN-A30006  
   PREPARE i1101_pb FROM g_sql
   DECLARE ocs_curs CURSOR FOR i1101_pb

   CALL g_ocs.clear()

   LET g_cnt = 1
   MESSAGE "Searching!" 

   FOREACH ocs_curs INTO g_ocs[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
    
      CALL i1101_ocr02(g_ocs[g_cnt].ocs02) RETURNING g_ocs[g_cnt].ocr02
      CALL i1101_chk_acc_entry(g_ocs[g_cnt].ocs03,g_aza.aza81)
           RETURNING g_ocs[g_cnt].aag02
      CALL i1101_chk_acc_entry(g_ocs[g_cnt].ocs031,g_aza.aza82)
           RETURNING g_ocs[g_cnt].aag02_1

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_ocs.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i1101_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ocs TO s_ocs.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

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
             LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
   
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i1101_ocr02(p_ocr01)
DEFINE p_ocr01 LIKE ocr_file.ocr01
DEFINE l_ocr02 LIKE ocr_file.ocr02
   SELECT ocr02 INTO l_ocr02 
     FROM ocr_file
    WHERE ocr01=p_ocr01
   IF SQLCA.sqlcode = 100 THEN
      LET l_ocr02 = ''
   END IF
   RETURN l_ocr02
END FUNCTION

FUNCTION i1101_chk_acc_entry(p_code,p_aag00)
DEFINE p_code     LIKE aag_file.aag01
DEFINE l_aagacti  LIKE aag_file.aagacti
DEFINE l_aag07    LIKE aag_file.aag07
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE p_aag00    LIKE aag_file.aag00
DEFINE l_aag02    LIKE aag_file.aag02
 
 SELECT aag02,aag03,aag07,aagacti
    INTO l_aag02,l_aag03,l_aag07,l_aagacti
    FROM aag_file
    WHERE aag01=p_code
    AND aag00 = p_aag00
 CASE WHEN STATUS=100         LET g_errno='agl-001'
      WHEN l_aagacti='N'      LET g_errno='9028'
       WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
       WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
      OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
 END CASE
 IF NOT cl_null(g_errno) THEN
    LET l_aag02=' '
 END IF
 RETURN l_aag02
END FUNCTION

FUNCTION i1101_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'Y' ) THEN
      #CALL cl_set_comp_entry("ocs011,ocs012,ocs01,ocs02",TRUE) #FUN-B50111 #FUN-A30006 add ocs011,ocs012,ocs01
       CALL cl_set_comp_entry("ocs011,ocs012,ocs01,ocs02,ocs06,ocs07,ocs08,ocs09",TRUE) #FUN-B50111
    END IF
END FUNCTION            

FUNCTION i1101_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      #CALL cl_set_comp_entry("ocs011,ocs012,ocs01,ocs02",FALSE) #FUN-B50111 #FUN-A30006 add ocs011,ocs012,ocs01
       CALL cl_set_comp_entry("ocs011,ocs012,ocs01,ocs02,ocs06,ocs07,ocs08,ocs09",FALSE) #FUN-B50111
    END IF                                                                                                                          
END FUNCTION            
#FUNCTION i1101_set_required(p_ocs011)           #FUN-A40047
FUNCTION i1101_set_required()                    #FUN-A40047
#DEFINE p_ocs011 LIKE ocs_file.ocs011            #FUN-A40047
#  IF NOT cl_null(p_ocs011) THEN                 #FUN-B70059  #FUN-A40047
#  IF NOT cl_null(g_ocs[l_ac].ocs011) THEN       #FUN-A40047
#     CALL cl_set_comp_required("ocs012",TRUE)   #NO.FUN-A60002 
#     CALL cl_set_comp_required("ocs012",FALSE)  #FUN-B70059  #NO.FUN-A60002 
#  END IF                                        #FUN-B70059 
END FUNCTION
#FUN-A40047 --Begin
#FUNCTION i1101_set_no_required(p_ocs011)
#DEFINE p_ocs011 LIKE ocs_file.ocs011
#   CALL cl_set_comp_required("ocs011,ocs01",FALSE)
#   IF cl_null(p_ocs011) THEN
#      CALL cl_set_comp_required("ocs012",FALSE)
#   END IF
#END FUNCTION
FUNCTION i1101_set_no_required()
#   CALL cl_set_comp_required("ocs011,ocs012,ocs01",FALSE)  #NO.FUN-A60002
    CALL cl_set_comp_required("ocs011,ocs01",FALSE)         #NO.FUN-A60002 
END FUNCTION
#FUN-A40047 --End

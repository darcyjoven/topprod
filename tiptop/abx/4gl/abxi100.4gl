# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxi100.4gl
# Descriptions...: 海關核准文號建立作業
# Date & Author..: 2006/10/18 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-770005 07/07/09 By ve  報表改為使用crystal report
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu 取消料件的管控	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-C60004 12/08/31 By pauline 將bxa02加入為PK值
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
        m_bxa       RECORD LIKE bxa_file.*,
        g_bxa       DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
           bxa01       LIKE bxa_file.bxa01,   #核准文號
           bxa02       LIKE bxa_file.bxa02,   #申請料號
           bxa03       LIKE bxa_file.bxa03,   #品名  
           bxa04       LIKE bxa_file.bxa04,   #規格  
           bxa05       LIKE bxa_file.bxa05,   #加工廠商
           pmc03          LIKE pmc_file.pmc03,
           bxa06       LIKE bxa_file.bxa06,   #起始日期
           bxa07       LIKE bxa_file.bxa07,   #截止日期
           bxa08       LIKE bxa_file.bxa08,   #核准加工數量
           bxa09       LIKE bxa_file.bxa09,   #已核銷數量
           bxa10       LIKE bxa_file.bxa10,   #備註     
           bxaacti     LIKE bxa_file.bxaacti  #有效碼  
                       END RECORD,
        g_bxa_t     RECORD                       #程式變數 (舊值)
           bxa01       LIKE bxa_file.bxa01,   #核准文號
           bxa02       LIKE bxa_file.bxa02,   #申請料號
           bxa03       LIKE bxa_file.bxa03,   #品名  
           bxa04       LIKE bxa_file.bxa04,   #規格  
           bxa05       LIKE bxa_file.bxa05,   #加工廠商
           pmc03          LIKE pmc_file.pmc03,
           bxa06       LIKE bxa_file.bxa06,   #起始日期
           bxa07       LIKE bxa_file.bxa07,   #截止日期
           bxa08       LIKE bxa_file.bxa08,   #核准加工數量
           bxa09       LIKE bxa_file.bxa09,   #已核銷數量
           bxa10       LIKE bxa_file.bxa10,   #備註       
           bxaacti     LIKE bxa_file.bxaacti  #有效碼    
                       END RECORD,
        g_bxa_o     RECORD                       #程式變數 (舊值)
           bxa01       LIKE bxa_file.bxa01,   #核准文號
           bxa02       LIKE bxa_file.bxa02,   #申請料號
           bxa03       LIKE bxa_file.bxa03,   #品名  
           bxa04       LIKE bxa_file.bxa04,   #規格  
           bxa05       LIKE bxa_file.bxa05,   #加工廠商
           pmc03          LIKE pmc_file.pmc03,
           bxa06       LIKE bxa_file.bxa06,   #起始日期
           bxa07       LIKE bxa_file.bxa07,   #截止日期
           bxa08       LIKE bxa_file.bxa08,   #核准加工數量
           bxa09       LIKE bxa_file.bxa09,   #已核銷數量
           bxa10       LIKE bxa_file.bxa10,   #備註       
           bxaacti     LIKE bxa_file.bxaacti  #有效碼    
                       END RECORD,
        g_wc,g_sql     STRING,
        g_rec_b        LIKE type_file.num5,              #單身筆數
        l_ac           LIKE type_file.num5               #目前處理的ARRAY CNT
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10   
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE l_table   STRING      #FUN-770005 
DEFINE g_str     STRING      #FUN-770005 
DEFINE g_sql1    STRING      #FUN-770005
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0062
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used('abxi100',g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間)  #FUN-B30211
#No.FUN-770005--begin--
  LET g_sql1="bxa01.bxa_file.bxa01,",
             "bxa02.bxa_file.bxa02,",
             "bxa03.bxa_file.bxa03,",
             "bxa04.bxa_file.bxa04,",
             "bxa05.bxa_file.bxa05,",
             "pmc03.pmc_file.pmc03,",
             "bxa06.bxa_file.bxa06,", 
             "bxa07.bxa_file.bxa07,", 
             "bxa08.bxa_file.bxa08,", 
             "bxa09.bxa_file.bxa09,", 
             "bxa10.bxa_file.bxa10,", 
             "bxaacti.bxa_file.bxaacti"
   LET l_table=cl_prt_temptable('abxi100',g_sql1) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
#  LET g_sql1="INSERT INTO ds_report.",l_table CLIPPED,             # TQC-780054
   LET g_sql1="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   # TQC-780054
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql1
   IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)EXIT PROGRAM
   END IF 
#No.FUN-770005--END--
   LET p_row = 3 LET p_col =10
   OPEN WINDOW i100_w AT p_row,p_col WITH FORM "abx/42f/abxi100"
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   CALL i100_menu()
   CLOSE WINDOW i100_w                    #結束畫面
  # CALL cl_used('abxi100',g_time,2) RETURNING g_time      #計算使用時間 (退出使間)   #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (進入時間)  #FUN-B30211
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
         WHEN "help"  
            CALL cl_show_help()
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bxa),'','')
            END IF
         WHEN "related_document"
           IF cl_chk_act_auth() AND l_ac != 0 THEN
              IF g_bxa[l_ac].bxa01 IS NOT NULL THEN
                 LET g_doc.column1 = "bxa01"
                 LET g_doc.value1 = g_bxa[l_ac].bxa01
                 CALL cl_doc()
              END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_q()
   CALL i100_b_askkey()
END FUNCTION
 
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                 #檢查重複用
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否
    p_cmd           LIKE type_file.chr1,               #處理狀態
    l_allow_insert  LIKE type_file.chr1,              #可新增否
    l_allow_delete  LIKE type_file.chr1               #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET g_forupd_sql = "SELECT * FROM bxa_file ",
                       " WHERE bxa01=? AND bxa02 = ?  FOR UPDATE"  #FUN-C60004 add bxa02
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql  #LOCK CURSOR
 
    INPUT ARRAY g_bxa WITHOUT DEFAULTS FROM s_bxa.* 
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           DISPLAY 'BEFORE ROW'
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_bxa_t.* = g_bxa[l_ac].*  #BACKUP
              LET g_bxa_o.* = g_bxa[l_ac].*  #BACKUP
              OPEN i100_bcl USING g_bxa_t.bxa01,g_bxa_t.bxa02 #表示更改狀態   #FUN-C60004 add bxa02
              IF STATUS THEN
                 CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                 LET l_lock_sw = 'Y' 
              ELSE
                 FETCH i100_bcl INTO m_bxa.*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bxa_t.bxa01,SQLCA.sqlcode,1)
                    LET l_lock_sw = 'Y' 
                 END IF
                 LET g_before_input_done = FALSE
                 CALL i100_set_entry_b(p_cmd)
                 CALL i100_set_no_entry_b(p_cmd)
                 LET g_before_input_done = TRUE
              END IF
           END IF
 
        BEFORE INSERT
           DISPLAY 'BEFORE INSERT'
           LET l_n = ARR_COUNT()
           LET p_cmd = 'a'
           INITIALIZE g_bxa[l_ac].* TO NULL
           INITIALIZE m_bxa.* TO NULL
           LET g_bxa[l_ac].bxa06 = g_today
           LET g_bxa[l_ac].bxa07 = g_today
           LET g_bxa[l_ac].bxa08 = 0
           LET g_bxa[l_ac].bxa09 = 0 
           LET g_bxa[l_ac].bxaacti = 'Y' 
           LET g_bxa_t.* = g_bxa[l_ac].*    
           LET g_bxa_o.* = g_bxa[l_ac].*
           LET g_before_input_done = FALSE
           CALL i100_set_entry_b(p_cmd)
           CALL i100_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           NEXT FIELD bxa01
 
        AFTER FIELD bxa01   #核准文號    check KEY值是否重複
           IF g_bxa[l_ac].bxa01 != g_bxa_t.bxa01 OR
              cl_null(g_bxa_t.bxa01) THEN
              CALL i100_bxa01()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 LET g_bxa[l_ac].bxa01 = g_bxa_o.bxa01 
                 NEXT FIELD bxa01
              END IF
           END IF
           LET g_bxa_o.bxa01 = g_bxa[l_ac].bxa01
 
        AFTER FIELD bxa02    #申請料號
           IF NOT cl_null(g_bxa[l_ac].bxa02) THEN
#FUN-AB0025 ----------------mark start----------
#             #FUN-AA0059 ----------------------------add start----------------------------
#             	IF NOT s_chk_item_no(g_bxa[l_ac].bxa02,'') THEN
#                  CALL cl_err('',g_errno,1)
#                  LET g_bxa[l_ac].bxa05 = g_bxa_o.bxa05
#                  DISPLAY BY NAME g_bxa[l_ac].bxa05
#                  NEXT FIELD bxa05
#               END IF 
#              #FUN-AA0059 ----------------------------add end---------------------------- 
#FUN-AB0025 --------------mark end-----------------------
              IF g_bxa[l_ac].bxa02 != g_bxa_o.bxa02 OR
                 cl_null(g_bxa_o.bxa02) THEN
                #FUN-C60004 add START
                 CALL i100_bxa01()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                    LET g_bxa[l_ac].bxa02 = g_bxa_o.bxa02
                    NEXT FIELD bxa02
                 END IF
                #FUN-C60004 add END
                 CALL i100_bxa02()
              END IF
           END IF
           LET g_bxa_o.bxa02 = g_bxa[l_ac].bxa02
 
        AFTER FIELD bxa05    #加工廠商
           IF NOT cl_null(g_bxa[l_ac].bxa05) THEN
              CALL i100_bxa05(l_ac)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_bxa[l_ac].bxa05 = g_bxa_o.bxa05 
                 DISPLAY BY NAME g_bxa[l_ac].bxa05
                 NEXT FIELD bxa05
              END IF
           END IF
           LET g_bxa_o.bxa05 = g_bxa[l_ac].bxa05
 
        AFTER FIELD bxa06    #起始日期
           IF NOT cl_null(g_bxa[l_ac].bxa06) AND  
              NOT cl_null(g_bxa[l_ac].bxa07) THEN 
              IF g_bxa[l_ac].bxa06 > g_bxa[l_ac].bxa07 THEN
                 CALL cl_err('','aap-100',0)
                 NEXT FIELD bxa06
              END IF
           END IF
           LET g_bxa_o.bxa06 = g_bxa[l_ac].bxa06
 
        AFTER FIELD bxa07    #截止日期
           IF NOT cl_null(g_bxa[l_ac].bxa07) AND  
              NOT cl_null(g_bxa[l_ac].bxa06) THEN 
              IF g_bxa[l_ac].bxa07 < g_bxa[l_ac].bxa06 THEN
                 CALL cl_err('','aap-100',0)
                 NEXT FIELD bxa07
              END IF
           END IF 
           LET g_bxa_o.bxa07 = g_bxa[l_ac].bxa07
 
        AFTER FIELD bxa08    #核准加工數量
           IF NOT cl_null(g_bxa[l_ac].bxa08) THEN
              IF g_bxa[l_ac].bxa08 < 0 THEN
                 CALL cl_err('','aim-391',0)
                 LET g_bxa[l_ac].bxa08 = g_bxa_o.bxa08
                 NEXT FIELD bxa08
              END IF
           END IF
           LET g_bxa_o.bxa08 = g_bxa[l_ac].bxa08
 
        AFTER FIELD bxa09    #已核銷數量
           IF g_bxa[l_ac].bxa09 IS NULL THEN
              LET g_bxa[l_ac].bxa09 = 0
              DISPLAY BY NAME g_bxa[l_ac].bxa09
           END IF
           LET g_bxa_o.bxa09 = g_bxa[l_ac].bxa09
 
        AFTER FIELD bxaacti  #有效否
           IF NOT cl_null(g_bxa[l_ac].bxaacti) THEN
              IF g_bxa[l_ac].bxaacti NOT MATCHES '[YN]' THEN
                 CALL cl_err('','aec-079',0)
                 LET g_bxa[l_ac].bxaacti = g_bxa_o.bxaacti
                 NEXT FIELD bxaacti
              END IF
           END IF
           LET g_bxa_o.bxaacti = g_bxa[l_ac].bxaacti
 
        BEFORE DELETE                            #是否取消單身
           IF NOT cl_null(g_bxa_t.bxa01) THEN
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
              LET g_doc.column1 = "bxa01"               #No.FUN-9B0098 10/02/24
              LET g_doc.value1 = g_bxa[l_ac].bxa01      #No.FUN-9B0098 10/02/24
              CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM bxa_file 
               WHERE bxa01 = g_bxa_t.bxa01
                 AND bxa02 = g_bxa_t.bxa02    #FUN-C60004 add
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
                 ROLLBACK WORK 
                 CANCEL DELETE 
              END IF
              LET g_rec_b = g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
              COMMIT WORK 
           END IF
 
        ON ROW CHANGE
           DISPLAY 'ON ROW CHANGE'
           IF INT_FLAG THEN               
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bxa[l_ac].* = g_bxa_t.*
              CLOSE i100_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_bxa[l_ac].bxa01 != g_bxa_t.bxa01 OR
              (NOT cl_null(g_bxa[l_ac].bxa01) AND cl_null(g_bxa_t.bxa01)) THEN
              CALL i100_bxa01()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 LET g_bxa[l_ac].bxa01 = g_bxa_t.bxa01
                 NEXT FIELD bxa01
              END IF
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bxa[l_ac].bxa01,-263,1)
              LET g_bxa[l_ac].* = g_bxa_t.*
           ELSE
              INITIALIZE m_bxa.* TO NULL
              LET m_bxa.bxa01 = g_bxa[l_ac].bxa01
              LET m_bxa.bxa02 = g_bxa[l_ac].bxa02
              LET m_bxa.bxa03 = g_bxa[l_ac].bxa03 
              LET m_bxa.bxa04 = g_bxa[l_ac].bxa04
              LET m_bxa.bxa05 = g_bxa[l_ac].bxa05
              LET m_bxa.bxa06 = g_bxa[l_ac].bxa06
              LET m_bxa.bxa07 = g_bxa[l_ac].bxa07 
              LET m_bxa.bxa08 = g_bxa[l_ac].bxa08
              LET m_bxa.bxa09 = g_bxa[l_ac].bxa09 
              LET m_bxa.bxa10 = g_bxa[l_ac].bxa10 
              LET m_bxa.bxaacti = g_bxa[l_ac].bxaacti
              UPDATE bxa_file SET * = m_bxa.*
               WHERE bxa01=g_bxa_t.bxa01
                 AND bxa02 = g_bxa_t.bxa02    #FUN-C60004 add
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err(g_bxa[l_ac].bxa01,SQLCA.sqlcode,0)
                 LET g_bxa[l_ac].* = g_bxa_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY 'AFTER ROW'
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN             
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_bxa[l_ac].* = g_bxa_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_bxa.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE i100_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           CLOSE i100_bcl
           COMMIT WORK
 
        AFTER INSERT
           DISPLAY 'AFTER INSERT'
           IF INT_FLAG THEN              
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i100_bcl
              CANCEL INSERT
           END IF
           CALL i100_bxa01()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              CALL g_bxa.deleteElement(l_ac)
              CANCEL INSERT
           END IF
           INITIALIZE m_bxa.* TO NULL
           LET m_bxa.bxa01 = g_bxa[l_ac].bxa01
           LET m_bxa.bxa02 = g_bxa[l_ac].bxa02
           LET m_bxa.bxa03 = g_bxa[l_ac].bxa03 
           LET m_bxa.bxa04 = g_bxa[l_ac].bxa04
           LET m_bxa.bxa05 = g_bxa[l_ac].bxa05
           LET m_bxa.bxa06 = g_bxa[l_ac].bxa06
           LET m_bxa.bxa07 = g_bxa[l_ac].bxa07 
           LET m_bxa.bxa08 = g_bxa[l_ac].bxa08
           LET m_bxa.bxa09 = g_bxa[l_ac].bxa09
           LET m_bxa.bxa10 = g_bxa[l_ac].bxa10 
           LET m_bxa.bxaacti = g_bxa[l_ac].bxaacti
           INSERT INTO bxa_file VALUES(m_bxa.*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              DISPLAY "insert bxa err"
              DISPLAY m_bxa.bxa01
              CALL cl_err(g_bxa[l_ac].bxa01,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bxa02)  #申請料號
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form = "q_ima20"
               #  CALL cl_create_qry() RETURNING g_bxa[l_ac].bxa02
                 CALL q_sel_ima(FALSE, "q_ima20", "", "" , "", "", "", "" ,"",'' )  RETURNING g_bxa[l_ac].bxa02 
#FUN-AA0059 --End--
                 DISPLAY BY NAME g_bxa[l_ac].bxa02
                 NEXT FIELD bxa02
              WHEN INFIELD(bxa05)  #加工廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc2"
                 CALL cl_create_qry() RETURNING g_bxa[l_ac].bxa05
                 DISPLAY BY NAME g_bxa[l_ac].bxa05
                 NEXT FIELD bxa05
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
    END INPUT
 
    CLOSE i100_bcl
    COMMIT WORK
END FUNCTION
 
#依申請料號帶default值
FUNCTION i100_bxa02()
   DEFINE l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021
 
   SELECT ima02,ima021 INTO l_ima02,l_ima021
      FROM ima_file
      WHERE ima01 = g_bxa[l_ac].bxa02 AND imaacti = 'Y'
   IF SQLCA.SQLCODE THEN
      LET l_ima02  = NULL
      LET l_ima021 = NULL
   END IF
   LET g_bxa[l_ac].bxa03 = l_ima02
   LET g_bxa[l_ac].bxa04 = l_ima021
   DISPLAY BY NAME g_bxa[l_ac].bxa03,g_bxa[l_ac].bxa04
END FUNCTION
 
#檢查pk值
FUNCTION i100_bxa01()
   DEFINE l_n   LIKE type_file.num10
 
   LET g_errno = ''
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM bxa_file
    WHERE bxa01 = g_bxa[l_ac].bxa01
      AND bxa02 = g_bxa[l_ac].bxa02    #FUN-C60004 add
   IF l_n IS NULL THEN LET l_n = 0 END IF
   IF l_n > 0 THEN
      LET g_errno = '-239'
   END IF
END FUNCTION
 
#檢查加工廠商
FUNCTION i100_bxa05(l_ac)
   DEFINE l_pmc03    LIKE pmc_file.pmc03,
          l_pmcacti  LIKE pmc_file.pmcacti,
          l_ac       LIKE type_file.num5 
 
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti 
      FROM pmc_file
      WHERE pmc01 = g_bxa[l_ac].bxa05 
   CASE 
      WHEN SQLCA.SQLCODE = 100 
         LET g_errno = 'mfg3001'
         LET l_pmc03 = NULL
      WHEN l_pmcacti = 'N'
         LET g_errno = '9028'
      OTHERWISE 
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE 
   IF cl_null(g_errno) THEN
      LET g_bxa[l_ac].pmc03 = l_pmc03 
   END IF
END FUNCTION
 
FUNCTION i100_b_askkey()
    CLEAR FORM
    CALL g_bxa.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON bxa01,bxa02,bxa03,bxa04,bxa05,
                      bxa06,bxa07,bxa08,bxa09,bxa10,
                      bxaacti         
              FROM s_bxa[1].bxa01,s_bxa[1].bxa02,
                   s_bxa[1].bxa03,s_bxa[1].bxa04,
                   s_bxa[1].bxa05,s_bxa[1].bxa06,
                   s_bxa[1].bxa07,s_bxa[1].bxa08,
                   s_bxa[1].bxa09,s_bxa[1].bxa10,
                   s_bxa[1].bxaacti
 
             BEFORE CONSTRUCT
                CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bxa02)  #申請料號
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.state = 'c'
              #   LET g_qryparam.form = "q_ima20"
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima20","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO bxa02 
                 NEXT FIELD bxa02
              WHEN INFIELD(bxa05)  #加工廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_pmc2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO bxa05 
                 NEXT FIELD bxa05
              OTHERWISE EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN 
#       LET INT_FLAG = 0
#       LET g_rec_b = 0
#       CALL g_bxa.clear()
#       RETURN 
#    END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_rec_b = 0
      CALL g_bxa.clear()
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i100_b_fill(g_wc)
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2        STRING
 
    LET g_sql =
        "SELECT bxa01,bxa02,bxa03,bxa04,bxa05,           ",
        "       bxa06,bxa07,bxa08,bxa09,bxa10,bxaacti ",
        "  FROM bxa_file",
        " WHERE ", p_wc2 CLIPPED,"  ",
        " ORDER BY bxa01"
    PREPARE i100_pb FROM g_sql
    DECLARE bxa_curs CURSOR FOR i100_pb
 
    CALL g_bxa.clear()   #單身 ARRAY 乾洗
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH bxa_curs INTO g_bxa[g_cnt].bxa01,g_bxa[g_cnt].bxa02,
                             g_bxa[g_cnt].bxa03,g_bxa[g_cnt].bxa04,
                             g_bxa[g_cnt].bxa05,g_bxa[g_cnt].bxa06,
                             g_bxa[g_cnt].bxa07,g_bxa[g_cnt].bxa08,
                             g_bxa[g_cnt].bxa09,g_bxa[g_cnt].bxa10,
                             g_bxa[g_cnt].bxaacti
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       CALL i100_bxa05(g_cnt)
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_bxa.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bxa TO s_bxa.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    #No.FUN-7C0050
 
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
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
#@    ON ACTION 相關文件
      ON ACTION related_document  #No.MOD-470515
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i100_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bxa01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i100_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("bxa01",FALSE)
   END IF
END FUNCTION
 
FUNCTION i100_out()
   DEFINE l_name     LIKE type_file.chr20,     # External(Disk) file name
          l_i        LIKE type_file.num10,
          l_sql      STRING,                   #FUN-770005
          sr         RECORD 
                          bxa01       LIKE bxa_file.bxa01,   #核准文號
                          bxa02       LIKE bxa_file.bxa02,   #申請料號
                          bxa03       LIKE bxa_file.bxa03,   #品名  
                          bxa04       LIKE bxa_file.bxa04,   #規格  
                          bxa05       LIKE bxa_file.bxa05,   #加工廠商
                          pmc03       LIKE pmc_file.pmc03,
                          bxa06       LIKE bxa_file.bxa06,   #起始日期
                          bxa07       LIKE bxa_file.bxa07,   #截止日期
                          bxa08       LIKE bxa_file.bxa08,   #核准加工數量
                          bxa09       LIKE bxa_file.bxa09,   #已核銷數量
                          bxa10       LIKE bxa_file.bxa10,   #備註     
                          bxaacti     LIKE bxa_file.bxaacti  #有效碼  
                     END RECORD
 
#No.TQC-710076 -- begin --
   IF cl_null(g_wc) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
     CALL cl_del_data(l_table)
     IF g_bxa.getlength()=0 THEN
        CALL cl_err('','-400',1)
        RETURN
     END IF
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#    CALL cl_outnam('abxi100') RETURNING l_name
#    START REPORT i100_rep TO l_name                    #FUN-770005
 
     LET g_pageno = 0
     FOR l_i=1 TO g_bxa.getlength()
       IF g_bxa[l_i].bxa01 IS NULL THEN
          CONTINUE FOR
       END IF
    #No.FUN-770005--begin--
      
       INITIALIZE sr.* TO NULL
       LET sr.bxa01   = g_bxa[l_i].bxa01  
       LET sr.bxa02   = g_bxa[l_i].bxa02  
       LET sr.bxa03   = g_bxa[l_i].bxa03  
       LET sr.bxa04   = g_bxa[l_i].bxa04  
       LET sr.bxa05   = g_bxa[l_i].bxa05  
       LET sr.pmc03   = g_bxa[l_i].pmc03  
       LET sr.bxa06   = g_bxa[l_i].bxa06  
       LET sr.bxa07   = g_bxa[l_i].bxa07  
       LET sr.bxa08   = g_bxa[l_i].bxa08  
       LET sr.bxa09   = g_bxa[l_i].bxa09  
       LET sr.bxa10   = g_bxa[l_i].bxa10  
       LET sr.bxaacti = g_bxa[l_i].bxaacti
#      OUTPUT TO REPORT i100_rep(sr.*)
       EXECUTE insert_prep USING
              sr.bxa01,sr.bxa02,sr.bxa03,sr.bxa04,sr.bxa05,sr.pmc03,
              sr.bxa06,sr.bxa07,sr.bxa08,sr.bxa09,sr.bxa10,sr.bxaacti
     END FOR
{
     FINISH REPORT i100_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
}
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'bxa01,bxa02,bxa03,bxa04,bxa05,                            
                      bxa06,bxa07,bxa08,bxa09,bxa10,                            
                      bxaacti')
             RETURNING g_wc 
        LET g_str = g_wc
     END IF 
     LET g_str=g_str
     CALL cl_prt_cs3("abxi100","abxi100",l_sql,g_str)
#No.FUN-770005--end--      
END FUNCTION
#No.FUN-770005--begin--
{
REPORT i100_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,
          sr         RECORD 
                          bxa01       LIKE bxa_file.bxa01,   #核准文號
                          bxa02       LIKE bxa_file.bxa02,   #申請料號
                          bxa03       LIKE bxa_file.bxa03,   #品名  
                          bxa04       LIKE bxa_file.bxa04,   #規格  
                          bxa05       LIKE bxa_file.bxa05,   #加工廠商
                          pmc03       LIKE pmc_file.pmc03,
                          bxa06       LIKE bxa_file.bxa06,   #起始日期
                          bxa07       LIKE bxa_file.bxa07,   #截止日期
                          bxa08       LIKE bxa_file.bxa08,   #核准加工數量
                          bxa09       LIKE bxa_file.bxa09,   #已核銷數量
                          bxa10       LIKE bxa_file.bxa10,   #備註     
                          bxaacti     LIKE bxa_file.bxaacti  #有效碼  
                     END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bxa01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
      PRINTX name=H2 g_x[37],g_x[38],g_x[39],g_x[42],g_x[43],g_x[44]
      PRINTX name=H3 g_x[40],g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINTX name=D1 COLUMN g_c[31],sr.bxa01,
                     COLUMN g_c[32],sr.bxa02,
                     COLUMN g_c[33],sr.bxa05,
                     COLUMN g_c[34],sr.bxa06,
                     COLUMN g_c[35],cl_numfor(sr.bxa08,35,0),
                     COLUMN g_c[36],sr.bxa10
      PRINTX name=D2 COLUMN g_c[38],sr.bxa03,
                     COLUMN g_c[39],sr.pmc03,
                     COLUMN g_c[42],sr.bxa07,
                     COLUMN g_c[43],cl_numfor(sr.bxa09,43,0),
                     COLUMN g_c[44],sr.bxaacti
      PRINTX name=D3 COLUMN g_c[41],sr.bxa04
   ON LAST ROW
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-770005--end--

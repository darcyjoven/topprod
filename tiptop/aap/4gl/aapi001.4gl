# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aapi001.4gl
# Descriptions...: 集團代收付基本資料維護作業
# Date & Author..: 06/09/28  By cl
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-760075 07/06/08 By Rayven AP類型檢測科目是否合法
# Modify.........: No.FUN-770005 07/06/26 By ve 報表改為使用crystal report
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/23 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-A50102 10/05/28 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.MOD-C30365 12/03/10 By zhangweib aqd09~aqd14單別檢查時加上單別長度的檢查
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_aqd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        aqd01       LIKE aqd_file.aqd01,
        aqd01_1     LIKE azp_file.azp02,
        aqd02       LIKE aqd_file.aqd02,
        aqd02_1     LIKE ool_file.ool02,
        aqd03       LIKE aqd_file.aqd03,
        aqd03_1     LIKE apr_file.apr02,
        aqd04       LIKE aqd_file.aqd04,
        aqd04_1     LIKE oag_file.oag02,
        aqd05       LIKE aqd_file.aqd05,
        aqd05_1     LIKE pma_file.pma02,
        aqd06       LIKE aqd_file.aqd06,
        aqd06_1     LIKE nma_file.nma02,
        aqd07       LIKE aqd_file.aqd07,
        aqd07_1     LIKE gec_file.gec02,
        aqd08       LIKE aqd_file.aqd08,
        aqd08_1     LIKE gec_file.gec02,
        aqd09       LIKE aqd_file.aqd09,
        aqd10       LIKE aqd_file.aqd10,
        aqd11       LIKE aqd_file.aqd11,
        aqd12       LIKE aqd_file.aqd12,
        aqd13       LIKE aqd_file.aqd13,
        aqd14       LIKE aqd_file.aqd14,
        aqd15       LIKE aqd_file.aqd15,
        aqd16       LIKE aqd_file.aqd16,
        aqdacti     LIKE aqd_file.aqdacti
                    END RECORD,
    g_buf           LIKE type_file.chr50, 
    g_aqd_t         RECORD                 #程式變數 (舊值)
        aqd01       LIKE aqd_file.aqd01,
        aqd01_1     LIKE azp_file.azp02,
        aqd02       LIKE aqd_file.aqd02,
        aqd02_1     LIKE ool_file.ool02,
        aqd03       LIKE aqd_file.aqd03,
        aqd03_1     LIKE apr_file.apr02,
        aqd04       LIKE aqd_file.aqd04,
        aqd04_1     LIKE oag_file.oag02,
        aqd05       LIKE aqd_file.aqd05,
        aqd05_1     LIKE pma_file.pma02,
        aqd06       LIKE aqd_file.aqd06,
        aqd06_1     LIKE nma_file.nma02,
        aqd07       LIKE aqd_file.aqd07,
        aqd07_1     LIKE gec_file.gec02,
        aqd08       LIKE aqd_file.aqd08,
        aqd08_1     LIKE gec_file.gec02,
        aqd09       LIKE aqd_file.aqd09,
        aqd10       LIKE aqd_file.aqd10,
        aqd11       LIKE aqd_file.aqd11,
        aqd12       LIKE aqd_file.aqd12,
        aqd13       LIKE aqd_file.aqd13,
        aqd14       LIKE aqd_file.aqd14,
        aqd15       LIKE aqd_file.aqd15,
        aqd16       LIKE aqd_file.aqd16,
        aqdacti     LIKE aqd_file.aqdacti   
                    END RECORD,
    g_aqd_o         RECORD                 #程式變數 (舊值)
        aqd01       LIKE aqd_file.aqd01,
        aqd01_1     LIKE azp_file.azp02,
        aqd02       LIKE aqd_file.aqd02,
        aqd02_1     LIKE ool_file.ool02,
        aqd03       LIKE aqd_file.aqd03,
        aqd03_1     LIKE apr_file.apr02,
        aqd04       LIKE aqd_file.aqd04,
        aqd04_1     LIKE oag_file.oag02,
        aqd05       LIKE aqd_file.aqd05,
        aqd05_1     LIKE pma_file.pma02,
        aqd06       LIKE aqd_file.aqd06,
        aqd06_1     LIKE nma_file.nma02,
        aqd07       LIKE aqd_file.aqd07,
        aqd07_1     LIKE gec_file.gec02,
        aqd08       LIKE aqd_file.aqd08,
        aqd08_1     LIKE gec_file.gec02,
        aqd09       LIKE aqd_file.aqd09,
        aqd10       LIKE aqd_file.aqd10,
        aqd11       LIKE aqd_file.aqd11,
        aqd12       LIKE aqd_file.aqd12,
        aqd13       LIKE aqd_file.aqd13,
        aqd14       LIKE aqd_file.aqd14,
        aqd15       LIKE aqd_file.aqd15,
        aqd16       LIKE aqd_file.aqd16,
        aqdacti     LIKE aqd_file.aqdacti   
                    END RECORD,
    g_wc2,g_sql     STRING,  
    g_rec_b         LIKE type_file.num5,              #單身筆數
    l_ac            LIKE type_file.num5               #目前處理的ARRAY CNT
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt                 LIKE type_file.num10 
DEFINE g_i                   LIKE type_file.num5      #count/index for any purpose
DEFINE l_table               STRING                   #No.FUN-770005

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-770005--begin--
   LET g_sql=" aqd01.aqd_file.aqd01,",
             " aqd02.aqd_file.aqd02,",
             " aqd03.aqd_file.aqd03,",
             " aqd04.aqd_file.aqd04,",                                                                                              
             " aqd05.aqd_file.aqd05,", 
             " aqd06.aqd_file.aqd06,",                                                                                              
             " aqd07.aqd_file.aqd07,",            
             " aqd08.aqd_file.aqd08,",                                                                                              
             " aqd09.aqd_file.aqd09,", 
             " aqd10.aqd_file.aqd10,",                                                                                              
             " aqd11.aqd_file.aqd11,",
             " aqd12.aqd_file.aqd12,",                                                                                              
             " aqd13.aqd_file.aqd13,", 
             " aqd14.aqd_file.aqd14,",                                                                                              
             " aqd15.aqd_file.aqd15,",
             " aqd16.aqd_file.aqd16,",                                                                                              
             " aqdacti.aqd_file.aqdacti,",
             " azp02.azp_file.azp02,",
             " ool02.ool_file.ool02,",
             " apr02.apr_file.apr02,",
             " oag02.oag_file.oag02,",
             " pma02.pma_file.pma02,"
   LET l_table = cl_prt_temptable('aapi001',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF                         # Temp Table玻б
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,            # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    # TQC-780054
               " VALUES(?, ?, ?, ?, ? ,? ,? ,",
               "        ? ,? ,? ,? ,? ,? ,? ,",
               "        ? , ?, ? , ?, ",
               "        ?, ?, ?, ? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW i001_w WITH FORM "aap/42f/aapi001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
   CALL i001_b_fill(g_wc2)
 
   CALL i001_menu()
 
   CLOSE WINDOW i001_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aqd),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i001_q()
 
   CALL i001_b_askkey()
 
END FUNCTION
 
FUNCTION i001_b()
   DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
          l_n             LIKE type_file.num5,              #檢查重複用
          l_lock_sw       LIKE type_file.chr1,              #單身鎖住否
          p_cmd           LIKE type_file.chr1,              #處理狀態
          l_allow_insert  LIKE type_file.num5,              #可新增否
          l_allow_delete  LIKE type_file.num5               #可刪除否
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_azp02         LIKE azp_file.azp02
   DEFINE l_azp03         LIKE azp_file.azp03
   DEFINE l_azp01         LIKE azp_file.azp01
   DEFINE l_ool01         LIKE ool_file.ool01
   DEFINE l_ool02         LIKE ool_file.ool02
   DEFINE l_apr01         LIKE apr_file.apr01
   DEFINE l_apr02         LIKE apr_file.apr02
   DEFINE l_oag01         LIKE oag_file.oag01
   DEFINE l_oag02         LIKE oag_file.oag02
   DEFINE l_nma01         LIKE nma_file.nma01
   DEFINE l_nma02         LIKE nma_file.nma02
   DEFINE l_pma01         LIKE pma_file.pma01
   DEFINE l_pma02         LIKE pma_file.pma02
   DEFINE l_nma37         LIKE nma_file.nma37
   DEFINE l_gec01         LIKE gec_file.gec01
   DEFINE l_gec02         LIKE gec_file.gec02
   DEFINE l_ooyslip       LIKE ooy_file.ooyslip
   DEFINE l_apyslip       LIKE apy_file.apyslip
   DEFINE l_nmc01         LIKE nmc_file.nmc01
  #DEFINE l_dbs           LIKE type_file.chr21    #FUN-A50102
  #DEFINE l_dbs1          LIKE type_file.chr21    #FUN-A50102
   DEFINE 
          #l_sql           LIKE type_file.chr1000
          l_sql           STRING     #NO.FUN-910082
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT aqd01,'',aqd02,'',aqd03,'',aqd04,'',aqd05,'',aqd06,'',aqd07,'',aqd08,'', ",
                      "       aqd09,aqd10,aqd11,aqd12,aqd13,aqd14,aqd15,aqd16,",
                      "       aqdacti ",
                      "  FROM aqd_file WHERE aqd01=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_aqd WITHOUT DEFAULTS FROM s_aqd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'        
 
         IF g_rec_b >= l_ac THEN
            LET g_aqd_t.* = g_aqd[l_ac].*  #BACKUP
            LET g_aqd_o.* = g_aqd[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i001_bcl USING g_aqd_t.aqd01
            IF STATUS THEN
               CALL cl_err("OPEN i001_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i001_bcl INTO g_aqd[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aqd_t.aqd01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i001_show()
            END IF
           #FUN-A50102--mark--str--
           #LET g_plant_new = g_aqd[l_ac].aqd01
           #CALL s_getdbs()
           #LET l_dbs =g_dbs_new
           #FUN-A50102--mark--end
            SELECT azp02,azp03 INTO l_azp02,l_azp03 FROM azp_file 
             WHERE azp01=g_aqd[l_ac].aqd01
           #FUN-A50102--mark--str--
           #IF NOT cl_null(l_azp03) THEN
           #   LET l_dbs1=l_azp03
           #END IF
           #FUN-A50102--mark--str--
            LET g_before_input_done = FALSE                                   
            CALL i001_set_entry(p_cmd)                                        
            CALL i001_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_aqd[l_ac].* TO NULL      
         LET g_aqd_t.* = g_aqd[l_ac].*         #新輸入資料
         LET g_aqd_o.* = g_aqd[l_ac].*         #新輸入資料
         LET g_before_input_done = FALSE                                   
         CALL i001_set_entry(p_cmd)                                        
         CALL i001_set_no_entry(p_cmd)                                     
         LET g_before_input_done = TRUE
 
         LET g_aqd[l_ac].aqdacti= 'Y' 
         CALL cl_show_fld_cont()     
         NEXT FIELD aqd01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO aqd_file(aqd01,aqd02,aqd03,aqd04,aqd05,aqd06,
                              aqd07,aqd08,aqd09,aqd10,aqd11,aqd12,
                              aqd13,aqd14,aqd15,aqd16,aqdacti,aqdoriu,aqdorig)
              VALUES(g_aqd[l_ac].aqd01,g_aqd[l_ac].aqd02,
                     g_aqd[l_ac].aqd03,g_aqd[l_ac].aqd04,
                     g_aqd[l_ac].aqd05,g_aqd[l_ac].aqd06,
                     g_aqd[l_ac].aqd07,g_aqd[l_ac].aqd08,
                     g_aqd[l_ac].aqd09,g_aqd[l_ac].aqd10,
                     g_aqd[l_ac].aqd11,g_aqd[l_ac].aqd12,
                     g_aqd[l_ac].aqd13,g_aqd[l_ac].aqd14,
                     g_aqd[l_ac].aqd15,g_aqd[l_ac].aqd16,
                     g_aqd[l_ac].aqdacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","aqd_file",g_aqd[l_ac].aqd01,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD aqd01      #營運中心代碼 
         IF NOT cl_null(g_aqd[l_ac].aqd01) THEN
            IF g_aqd[l_ac].aqd01 != g_aqd_t.aqd01 OR
               (NOT cl_null(g_aqd[l_ac].aqd01) AND cl_null(g_aqd_t.aqd01)) THEN
               SELECT count(aqd01) INTO l_n FROM aqd_file
                WHERE aqd01 = g_aqd[l_ac].aqd01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_aqd[l_ac].aqd01 = g_aqd_t.aqd01
                  NEXT FIELD aqd01
               END IF
               LET g_aqd_t.aqd01=g_aqd[l_ac].aqd01
             SELECT azp02,azp03 INTO l_azp02,l_azp03 FROM azp_file 
              WHERE azp01=g_aqd[l_ac].aqd01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","azp_file",g_aqd[l_ac].aqd01,"",SQLCA.sqlcode,"","sel azp_file",1)
                NEXT FIELD aqd01
             END IF
            #FUN-A50102--mark--str--
            #LET g_plant_new = g_aqd[l_ac].aqd01
            #CALL s_getdbs()
            #LET l_dbs=g_dbs_new
            #IF NOT cl_null(l_azp03) THEN
            #   LET l_dbs1=l_azp03 CLIPPED
            #END IF
            #FUN-A50102--mark--end
             IF NOT cl_null(l_azp02) THEN
                LET g_aqd[l_ac].aqd01_1 = l_azp02
             ELSE 
                LET g_aqd[l_ac].aqd01_1 = ' '
             END IF      
            END IF
         END IF
    
      BEFORE FIELD aqd02
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd02          #AR類型 
         IF NOT cl_null(g_aqd[l_ac].aqd02) THEN
            IF g_aqd[l_ac].aqd02 != g_aqd_t.aqd02 OR
               (NOT cl_null(g_aqd[l_ac].aqd02) AND cl_null(g_aqd_t.aqd02))  THEN
              #CALL i001_aqd02(l_dbs)   #FUN-A50102
               CALL i001_aqd02()        #FUN-A50102
                 RETURNING l_ool01,l_ool02 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd02,g_errno,1)
                  LET g_aqd[l_ac].aqd02   = g_aqd_t.aqd02
                  LET g_aqd[l_ac].aqd02_1 = g_aqd_t.aqd02_1
                  NEXT FIELD aqd02
               END IF 
               LET g_aqd[l_ac].aqd02_1 = l_ool02
               LET g_aqd_t.aqd02=g_aqd[l_ac].aqd02
            END IF
         END IF
         IF cl_null(g_aqd[l_ac].aqd02) THEN
            LET g_aqd[l_ac].aqd02_1 = ' '
         END IF
 
 
      BEFORE FIELD aqd03
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd03         #AP類型
         IF NOT cl_null(g_aqd[l_ac].aqd03) THEN
            IF g_aqd[l_ac].aqd03 != g_aqd_t.aqd03 OR
               (NOT cl_null(g_aqd[l_ac].aqd03) AND cl_null(g_aqd_t.aqd03))  THEN
              #CALL i001_aqd03(l_dbs)     #FUN-A50102
               CALL i001_aqd03()          #FUN-A50102
                 RETURNING l_apr01,l_apr02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd03,g_errno,1)
                  LET g_aqd[l_ac].aqd03   = g_aqd_t.aqd03
                  LET g_aqd[l_ac].aqd03_1 = g_aqd_t.aqd03_1
                  NEXT FIELD aqd03
               END IF 
               #No.TQC-760075 --start--
              #CALL i001_apt01(l_dbs)    #FUN-A50102
               CALL i001_apt01()         #FUN-A50102
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd03,g_errno,1)
                  LET g_aqd[l_ac].aqd03   = g_aqd_t.aqd03
                  LET g_aqd[l_ac].aqd03_1 = g_aqd_t.aqd03_1
                  NEXT FIELD aqd03
               END IF 
               #No.TQC-760075 --end--
               LET g_aqd[l_ac].aqd03_1 = l_apr02
               LET g_aqd_t.aqd03=g_aqd[l_ac].aqd03
            END IF
         END IF
         IF cl_null(g_aqd[l_ac].aqd03) THEN
            LET g_aqd[l_ac].aqd03_1 = ''
         END IF
 
      BEFORE FIELD aqd04
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd04         #收款條件
         IF NOT cl_null(g_aqd[l_ac].aqd04) THEN
            IF g_aqd[l_ac].aqd04 != g_aqd_t.aqd04 OR
               (NOT cl_null(g_aqd[l_ac].aqd04) AND cl_null(g_aqd_t.aqd04))  THEN
              #CALL i001_aqd04(l_dbs)    #FUN-A50102
               CALL i001_aqd04()         #FUN-A50102
                 RETURNING l_oag01,l_oag02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd04,g_errno,1)
                  LET g_aqd[l_ac].aqd04   = g_aqd_t.aqd04
                  LET g_aqd[l_ac].aqd04_1 = g_aqd_t.aqd04_1
                  NEXT FIELD aqd04
               END IF 
               LET g_aqd[l_ac].aqd04_1 = l_oag02
               LET g_aqd_t.aqd04=g_aqd[l_ac].aqd04
            END IF
         END IF
         IF cl_null(g_aqd[l_ac].aqd04) THEN
               LET g_aqd[l_ac].aqd04_1 = ''
         END IF
 
      BEFORE FIELD aqd05
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd05         #付款條件
         IF NOT cl_null(g_aqd[l_ac].aqd05) THEN
            IF g_aqd[l_ac].aqd05 != g_aqd_t.aqd05 OR
               (NOT cl_null(g_aqd[l_ac].aqd05) AND cl_null(g_aqd_t.aqd05))  THEN
              #CALL i001_aqd05(l_dbs)    #FUN-A50102
               CALL i001_aqd05()         #FUN-A50102
                 RETURNING l_pma01,l_pma02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd05,g_errno,1)
                  LET g_aqd[l_ac].aqd05   = g_aqd_t.aqd05
                  LET g_aqd[l_ac].aqd05_1 = g_aqd_t.aqd05_1
                  NEXT FIELD aqd05
               END IF 
               LET g_aqd[l_ac].aqd05_1 = l_pma02
               LET g_aqd_t.aqd05=g_aqd[l_ac].aqd05
            END IF
         END IF
         IF cl_null(g_aqd[l_ac].aqd05) THEN
            LET g_aqd[l_ac].aqd05_1 = ''
         END IF
 
      BEFORE FIELD aqd06
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd06         #內部結算中心 
         IF NOT cl_null(g_aqd[l_ac].aqd06) THEN
            IF g_aqd[l_ac].aqd06 != g_aqd_t.aqd06 OR
               (NOT cl_null(g_aqd[l_ac].aqd06) AND cl_null(g_aqd_t.aqd06))  THEN
              #CALL i001_aqd06(l_dbs)    #FUN-A50102
               CALL i001_aqd06()         #FUN-A50102
                 RETURNING l_nma01,l_nma02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd06,g_errno,1)
                  LET g_aqd[l_ac].aqd06   = g_aqd_t.aqd06
                  LET g_aqd[l_ac].aqd06_1 = g_aqd_t.aqd06_1
                  NEXT FIELD aqd06
               END IF 
               LET g_aqd[l_ac].aqd06_1 = l_nma02
               LET g_aqd_t.aqd06=g_aqd[l_ac].aqd06
            END IF
         END IF
         IF cl_null(g_aqd[l_ac].aqd06) THEN
            LET g_aqd[l_ac].aqd06_1 = ''
         END IF
 
      BEFORE FIELD aqd07
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd07         #AR稅種
         IF NOT cl_null(g_aqd[l_ac].aqd07) THEN
            IF g_aqd[l_ac].aqd07 != g_aqd_t.aqd07 OR
               (NOT cl_null(g_aqd[l_ac].aqd07) AND cl_null(g_aqd_t.aqd07))  THEN
              #CALL i001_aqd07(l_dbs)   #FUN-A50102
               CALL i001_aqd07()        #FUN-A50102
                 RETURNING  l_gec01,l_gec02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd07,g_errno,1)
                  LET g_aqd[l_ac].aqd07   = g_aqd_t.aqd07
                  LET g_aqd[l_ac].aqd07_1 = g_aqd_t.aqd07_1
                  NEXT FIELD aqd07
               END IF 
               LET g_aqd[l_ac].aqd07_1 = l_gec02
               LET g_aqd_t.aqd07=g_aqd[l_ac].aqd07
            END IF
         END IF
         IF cl_null(g_aqd[l_ac].aqd07) THEN
            LET g_aqd[l_ac].aqd07_1 = ''
         END IF
 
      BEFORE FIELD aqd08
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd08         #AP稅種
         IF NOT cl_null(g_aqd[l_ac].aqd08) THEN
            IF g_aqd[l_ac].aqd08 != g_aqd_t.aqd08 OR
               (NOT cl_null(g_aqd[l_ac].aqd08) AND cl_null(g_aqd_t.aqd08))  THEN
              #CALL i001_aqd08(l_dbs)   #FUN-A50102
               CALL i001_aqd08()        #FUN-A50102
                 RETURNING l_gec01,l_gec02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd08,g_errno,1)
                  LET g_aqd[l_ac].aqd08   = g_aqd_t.aqd08
                  LET g_aqd[l_ac].aqd08_1 = g_aqd_t.aqd08_1
                  NEXT FIELD aqd08
               END IF 
               LET g_aqd[l_ac].aqd08_1 = l_gec02
               LET g_aqd_t.aqd08=g_aqd[l_ac].aqd08
            END IF
         END IF
         IF cl_null(g_aqd[l_ac].aqd08) THEN
            LET g_aqd[l_ac].aqd08_1 = ''
         END IF
 
      BEFORE FIELD aqd09
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd09         #AR雜項立賬單別
         IF NOT cl_null(g_aqd[l_ac].aqd09) THEN
            IF g_aqd[l_ac].aqd09 != g_aqd_t.aqd09 OR
               (NOT cl_null(g_aqd[l_ac].aqd09) AND cl_null(g_aqd_t.aqd09))  THEN
              #CALL i001_aqd09(l_dbs)   #FUN-A50098
               CALL i001_aqd09()        #FUN-A50098
                 RETURNING l_ooyslip
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd09,g_errno,1)
                  LET g_aqd[l_ac].aqd09 = g_aqd_t.aqd09
                  NEXT FIELD aqd09
               END IF 
              #NO.MOD-C30365   ---start---   Add
               CALL i001_chk_slip(g_aqd[l_ac].aqd09)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd09,g_errno,1)
                  LET g_aqd[l_ac].aqd09 = g_aqd_t.aqd09
                  NEXT FIELD aqd09
               END IF
              #NO.MOD-C30365   ---end---     Add
               LET g_aqd_t.aqd09=g_aqd[l_ac].aqd09
            END IF
         END IF
 
      BEFORE FIELD aqd10
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd10         #AR雜項待扺單別
         IF NOT cl_null(g_aqd[l_ac].aqd10) THEN
            IF g_aqd[l_ac].aqd10 != g_aqd_t.aqd10 OR
               (NOT cl_null(g_aqd[l_ac].aqd10) AND cl_null(g_aqd_t.aqd10))  THEN
              #CALL i001_aqd10(l_dbs)    #FUN-A50102
               CALL i001_aqd10()         #FUN-A50102    
                 RETURNING l_ooyslip
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd10,g_errno,1)
                  LET g_aqd[l_ac].aqd10 = g_aqd_t.aqd10
                  NEXT FIELD aqd10
               END IF 
              #NO.MOD-C30365   ---start---   Add
               CALL i001_chk_slip(g_aqd[l_ac].aqd10)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd10,g_errno,1)
                  LET g_aqd[l_ac].aqd10 = g_aqd_t.aqd10
                  NEXT FIELD aqd10
               END IF
              #NO.MOD-C30365   ---end---     Add
               LET g_aqd_t.aqd10=g_aqd[l_ac].aqd10
            END IF
         END IF
 
      BEFORE FIELD aqd11
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd11         #AR衝賬單別
         IF NOT cl_null(g_aqd[l_ac].aqd11) THEN
            IF g_aqd[l_ac].aqd11 != g_aqd_t.aqd11 OR
               (NOT cl_null(g_aqd[l_ac].aqd11) AND cl_null(g_aqd_t.aqd11))  THEN
              #CALL i001_aqd11(l_dbs)    #FUN-A50102
               CALL i001_aqd11()         #FUN-A50102
                 RETURNING l_ooyslip
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd11,g_errno,1)
                  LET g_aqd[l_ac].aqd11 = g_aqd_t.aqd11
                  NEXT FIELD aqd11
               END IF 
              #NO.MOD-C30365   ---start---   Add
               CALL i001_chk_slip(g_aqd[l_ac].aqd11)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd11,g_errno,1)
                  LET g_aqd[l_ac].aqd11 = g_aqd_t.aqd11
                  NEXT FIELD aqd11
               END IF
              #NO.MOD-C30365   ---end---     Add
               LET g_aqd_t.aqd11=g_aqd[l_ac].aqd11
            END IF
         END IF
 
      BEFORE FIELD aqd12
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd12         #AP雜項立賬單別
         IF NOT cl_null(g_aqd[l_ac].aqd12) THEN
            IF g_aqd[l_ac].aqd12 != g_aqd_t.aqd12 OR
               (NOT cl_null(g_aqd[l_ac].aqd12) AND cl_null(g_aqd_t.aqd12))  THEN
              #CALL i001_aqd12(l_dbs)   #FUN-A50102
               CALL i001_aqd12()        #FUN-A50102
                 RETURNING l_apyslip
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd12,g_errno,1)
                  LET g_aqd[l_ac].aqd12 = g_aqd_t.aqd12
                  NEXT FIELD aqd12
               END IF 
              #NO.MOD-C30365   ---start---   Add
               CALL i001_chk_slip(g_aqd[l_ac].aqd12)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd12,g_errno,1)
                  LET g_aqd[l_ac].aqd12 = g_aqd_t.aqd12
                  NEXT FIELD aqd12
               END IF
              #NO.MOD-C30365   ---end---     Add
               LET g_aqd_t.aqd12=g_aqd[l_ac].aqd12
            END IF
         END IF
 
      BEFORE FIELD aqd13
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd13         #AP雜項待扺單別
         IF NOT cl_null(g_aqd[l_ac].aqd13) THEN
            IF g_aqd[l_ac].aqd13 != g_aqd_t.aqd13 OR
               (NOT cl_null(g_aqd[l_ac].aqd13) AND cl_null(g_aqd_t.aqd13))  THEN
              #CALL i001_aqd13(l_dbs)   #FUN-A50102
               CALL i001_aqd13()        #FUN-A50102
                 RETURNING l_apyslip
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd13,g_errno,1)
                  LET g_aqd[l_ac].aqd13 = g_aqd_t.aqd13
                  NEXT FIELD aqd13
               END IF 
              #NO.MOD-C30365   ---start---   Add
               CALL i001_chk_slip(g_aqd[l_ac].aqd13)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd13,g_errno,1)
                  LET g_aqd[l_ac].aqd13 = g_aqd_t.aqd13
                  NEXT FIELD aqd13
               END IF
              #NO.MOD-C30365   ---end---     Add
               LET g_aqd_t.aqd13=g_aqd[l_ac].aqd13
            END IF
         END IF
 
      BEFORE FIELD aqd14
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd14         #AP衝賬單別
         IF NOT cl_null(g_aqd[l_ac].aqd14) THEN
            IF g_aqd[l_ac].aqd14 != g_aqd_t.aqd14 OR
               (NOT cl_null(g_aqd[l_ac].aqd14) AND cl_null(g_aqd_t.aqd14))  THEN
              #CALL i001_aqd14(l_dbs)    #FUN-A50102
               CALL i001_aqd14()         #FUN-A50102
                 RETURNING l_apyslip
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd14,g_errno,1)
                  LET g_aqd[l_ac].aqd14 = g_aqd_t.aqd14
                  NEXT FIELD aqd14
               END IF 
              #NO.MOD-C30365   ---start---   Add
               CALL i001_chk_slip(g_aqd[l_ac].aqd14)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd14,g_errno,1)
                  LET g_aqd[l_ac].aqd14 = g_aqd_t.aqd14
                  NEXT FIELD aqd14
               END IF
              #NO.MOD-C30365   ---end---     Add
               LET g_aqd_t.aqd14=g_aqd[l_ac].aqd14
            END IF
         END IF
 
      BEFORE FIELD aqd15
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd15         #銀行存提異動碼-存碼
         IF NOT cl_null(g_aqd[l_ac].aqd15) THEN
            IF g_aqd[l_ac].aqd15 != g_aqd_t.aqd15 OR
               (NOT cl_null(g_aqd[l_ac].aqd15) AND cl_null(g_aqd_t.aqd15))  THEN
              #CALL i001_aqd15(l_dbs)   #FUN-A50102
               CALL i001_aqd15()        #FUN-A50102
                 RETURNING l_nmc01
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd15,g_errno,1)
                  LET g_aqd[l_ac].aqd15 = g_aqd_t.aqd15
                  NEXT FIELD aqd15
               END IF 
               LET g_aqd_t.aqd15=g_aqd[l_ac].aqd15
            END IF
         END IF
 
      BEFORE FIELD aqd16
         IF cl_null(g_aqd[l_ac].aqd01) THEN
            CALL cl_err("","aom-423",1)
            NEXT FIELD aqd01
         END IF
 
      AFTER FIELD aqd16         #銀行存提異動碼-提碼
         IF NOT cl_null(g_aqd[l_ac].aqd16) THEN
            IF g_aqd[l_ac].aqd16 != g_aqd_t.aqd16 OR
               (NOT cl_null(g_aqd[l_ac].aqd16) AND cl_null(g_aqd_t.aqd16))  THEN
              #CALL i001_aqd16(l_dbs)   #FUN-A50102
               CALL i001_aqd16()        #FUN-A50102
                 RETURNING l_nmc01
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqd[l_ac].aqd16,g_errno,1)
                  LET g_aqd[l_ac].aqd16 = g_aqd_t.aqd16
                  NEXT FIELD aqd16
               END IF 
               LET g_aqd_t.aqd16=g_aqd[l_ac].aqd16
            END IF
         END IF
 
 
      BEFORE DELETE                            #是否取消單身 
         IF g_aqd_t.aqd01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM aqd_file WHERE aqd01 = g_aqd_t.aqd01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aqd_file",g_aqd_t.aqd01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i001_bcl
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_aqd[l_ac].* = g_aqd_o.*
            CALL i001_show()
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_aqd[l_ac].aqd01,-263,1)
            LET g_aqd[l_ac].* = g_aqd_o.*
         ELSE
            UPDATE aqd_file SET
                   aqd01=g_aqd[l_ac].aqd01,aqd02=g_aqd[l_ac].aqd02,
                   aqd03=g_aqd[l_ac].aqd03,aqd04=g_aqd[l_ac].aqd04,
                   aqd05=g_aqd[l_ac].aqd05,aqd06=g_aqd[l_ac].aqd06,
                   aqd07=g_aqd[l_ac].aqd07,aqd08=g_aqd[l_ac].aqd08,
                   aqd09=g_aqd[l_ac].aqd09,aqd10=g_aqd[l_ac].aqd10,
                   aqd11=g_aqd[l_ac].aqd11,aqd12=g_aqd[l_ac].aqd12,
                   aqd13=g_aqd[l_ac].aqd13,aqd14=g_aqd[l_ac].aqd14,
                   aqd15=g_aqd[l_ac].aqd15,aqd16=g_aqd[l_ac].aqd16,
                   aqdacti=g_aqd[l_ac].aqdacti
             WHERE aqd01=g_aqd_t.aqd01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","aqd_file",g_aqd_t.aqd01,"",SQLCA.sqlcode,"","",1) 
               LET g_aqd[l_ac].* = g_aqd_o.*
            END IF
         END IF
      
      AFTER INPUT
        IF cl_null(g_aqd[l_ac].aqd01) THEN
           CALL cl_err("","aom-423",1)
           NEXT FIELD aqd01
        END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032       
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #FUN-D30032--add--str--
            IF p_cmd='u' THEN
               LET g_aqd[l_ac].* =  g_aqd_t.* 
            ELSE
               CALL g_aqd.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            #FUN-D30032--add--end--
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032       
         CLOSE i001_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(aqd01) AND l_ac > 1 THEN
            LET g_aqd[l_ac].* = g_aqd[l_ac-1].*
            NEXT FIELD aqd01 
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         IF INFIELD(aqd01) THEN
            CALL cl_init_qry_var()
           #LET g_qryparam.form ="q_azp"    #FUN-A50102
            LET g_qryparam.form ="q_azw"    #FUN-A50102
            LET g_qryparam.default1 = g_aqd[l_ac].aqd01
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd01
            DISPLAY BY NAME g_aqd[l_ac].aqd01
            NEXT FIELD aqd01
         END IF 
         IF INFIELD(aqd02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_ool01"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd02
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd02
            DISPLAY BY NAME g_aqd[l_ac].aqd02
            NEXT FIELD aqd02  
         END IF 
         IF INFIELD(aqd03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_apr01"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd03
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd03
            DISPLAY BY NAME g_aqd[l_ac].aqd03
            NEXT FIELD aqd03  
         END IF 
         IF INFIELD(aqd04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_oag01"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark  
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd04
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd04
            DISPLAY BY NAME g_aqd[l_ac].aqd04
            NEXT FIELD aqd04  
         END IF 
         IF INFIELD(aqd05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_pma2"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd05
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd05
            DISPLAY BY NAME g_aqd[l_ac].aqd05
            NEXT FIELD aqd05  
         END IF 
         IF INFIELD(aqd06) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_nma6"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd06
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd06
            DISPLAY BY NAME g_aqd[l_ac].aqd06
            NEXT FIELD aqd06  
         END IF 
         IF INFIELD(aqd07) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_gec5"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.arg2 = '2'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd07
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd07
            DISPLAY BY NAME g_aqd[l_ac].aqd07
            NEXT FIELD aqd07  
         END IF 
         IF INFIELD(aqd08) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_gec5"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark 
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.arg2 = '1'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd08
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd08
            DISPLAY BY NAME g_aqd[l_ac].aqd08
            NEXT FIELD aqd08  
         END IF 
         IF INFIELD(aqd09) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_ooy1"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd09
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd09
            DISPLAY BY NAME g_aqd[l_ac].aqd09
            NEXT FIELD aqd09  
         END IF 
         IF INFIELD(aqd10) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_ooy2"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark  
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd10
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd10
            DISPLAY BY NAME g_aqd[l_ac].aqd10
            NEXT FIELD aqd10  
         END IF 
         IF INFIELD(aqd11) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_ooy3"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark 
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd11
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd11
            DISPLAY BY NAME g_aqd[l_ac].aqd11
            NEXT FIELD aqd11  
         END IF 
         IF INFIELD(aqd12) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_apy5"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd12
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd12
            DISPLAY BY NAME g_aqd[l_ac].aqd12
            NEXT FIELD aqd12  
         END IF 
         IF INFIELD(aqd13) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_apy7"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark 
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd13
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd13
            DISPLAY BY NAME g_aqd[l_ac].aqd13
            NEXT FIELD aqd13  
         END IF 
         IF INFIELD(aqd14) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_apy6"
#           LET g_qryparam.arg1 = l_dbs1              #No.FUN-980025 mark
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.default1 = g_aqd[l_ac].aqd14
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd14
            DISPLAY BY NAME g_aqd[l_ac].aqd14
            NEXT FIELD aqd14  
         END IF 
         IF INFIELD(aqd15) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_nmc03"
#           LET g_qryparam.arg2 = l_dbs1              #No.FUN-980025 mark    
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.arg1 ='1'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd15
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd15
            DISPLAY BY NAME g_aqd[l_ac].aqd15
            NEXT FIELD aqd15  
         END IF 
         IF INFIELD(aqd16) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_nmc03"
#           LET g_qryparam.arg2 = l_dbs1              #No.FUN-980025 mark 
            LET g_qryparam.plant = g_aqd[l_ac].aqd01  #No.FUN-980025 add
            LET g_qryparam.arg1 ='2'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd16
            CALL cl_create_qry() RETURNING g_aqd[l_ac].aqd16
            DISPLAY BY NAME g_aqd[l_ac].aqd16
            NEXT FIELD aqd16  
         END IF 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
   CLOSE i001_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i001_b_askkey()
 
   CLEAR FORM
   CALL g_aqd.clear()
 
   CONSTRUCT g_wc2 ON aqd01,aqd02,aqd03,aqd04,aqd05, 
                      aqd06,aqd07,aqd08,aqd09,aqd10,aqd11,
                      aqd12,aqd13,aqd14,aqd15,aqd16,aqdacti
           FROM s_aqd[1].aqd01,s_aqd[1].aqd02,s_aqd[1].aqd03,
                s_aqd[1].aqd04,s_aqd[1].aqd05,               
                s_aqd[1].aqd06,s_aqd[1].aqd07,s_aqd[1].aqd08,
                s_aqd[1].aqd09,s_aqd[1].aqd10,s_aqd[1].aqd11,
                s_aqd[1].aqd12,s_aqd[1].aqd13,s_aqd[1].aqd14,  
                s_aqd[1].aqd15,s_aqd[1].aqd16,
                s_aqd[1].aqdacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      
      ON ACTION CONTROLP
         LET l_ac=1
         IF INFIELD(aqd01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
           #LET g_qryparam.form ="q_azp"    #FUN-A50102
            LET g_qryparam.form ="q_azw"    #FUN-A50102
            LET g_qryparam.default1 = g_aqd[l_ac].aqd01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret  TO aqd01
            NEXT FIELD aqd01
         END IF 
         IF INFIELD(aqd02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_ool01"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd02
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd02
            NEXT FIELD aqd02  
         END IF 
         IF INFIELD(aqd03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_apr01"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd03
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd03
            NEXT FIELD aqd03  
         END IF 
         IF INFIELD(aqd04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_oag01"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd04
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd04
            NEXT FIELD aqd04  
         END IF 
         IF INFIELD(aqd05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_pma2"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd05
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd05
            NEXT FIELD aqd05  
         END IF 
         IF INFIELD(aqd06) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_nma3"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd06
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd06
            NEXT FIELD aqd06  
         END IF 
         IF INFIELD(aqd07) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_gec5"
            LET g_qryparam.arg2 = '2'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd07
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd07
            NEXT FIELD aqd07  
         END IF 
         IF INFIELD(aqd08) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_gec5"
            LET g_qryparam.arg2 = '1'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd08
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd08
            NEXT FIELD aqd08  
         END IF 
         IF INFIELD(aqd09) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_ooy1"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd09
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd09
            NEXT FIELD aqd09  
         END IF 
         IF INFIELD(aqd10) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_ooy2"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd10
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd10
            NEXT FIELD aqd10  
         END IF 
         IF INFIELD(aqd11) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_ooy3"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd11
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd11
            NEXT FIELD aqd11  
         END IF 
         IF INFIELD(aqd12) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_apy5"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd12
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd12
            NEXT FIELD aqd12  
         END IF 
         IF INFIELD(aqd13) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_apy7"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd13
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd13
            NEXT FIELD aqd13  
         END IF 
         IF INFIELD(aqd14) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_apy6"
            LET g_qryparam.default1 = g_aqd[l_ac].aqd14
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd14
            NEXT FIELD aqd14  
         END IF 
         IF INFIELD(aqd15) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_nmc03"
            LET g_qryparam.arg1 ='1'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd15
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd15
            NEXT FIELD aqd15  
         END IF 
         IF INFIELD(aqd16) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state='c'
            LET g_qryparam.form ="q_nmc03"
            LET g_qryparam.arg1 ='2'
            LET g_qryparam.default1 = g_aqd[l_ac].aqd16
            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            DISPLAY g_qryparam.multiret TO aqd16
            NEXT FIELD aqd16  
         END IF 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('aqduser', 'aqdgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN 
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
   CALL i001_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)              #BODY FILL UP
#   DEFINE p_wc2     LIKE type_file.chr1000
   DEFINE p_wc2     STRING           #No.FUN-910082
  #DEFINE l_dbs     LIKE type_file.chr21    #FUN-A50102
   DEFINE 
          #l_sql     LIKE type_file.chr1000
          l_sql           STRING     #NO.FUN-910082
   DEFINE l_azp02   LIKE azp_file.azp02
   DEFINE l_ool02   LIKE ool_file.ool02
   DEFINE l_apr02   LIKE apr_file.apr02
   DEFINE l_oag02   LIKE oag_file.oag02
   DEFINE l_pma02   LIKE pma_file.pma02
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_gec02   LIKE gec_file.gec02
   DEFINE l_gec021  LIKE gec_file.gec02
 
   LET g_sql = "SELECT aqd01,'',aqd02,'',aqd03,'',aqd04,'',aqd05,'', ",   
               "       aqd06,'',aqd07,'',aqd08,'',aqd09,aqd10,aqd11,aqd12,aqd13,", 
               "       aqd14,aqd15,aqd16,aqdacti ",
               "  FROM aqd_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY aqd01 "
   PREPARE i001_pb FROM g_sql
   DECLARE aqd_curs CURSOR FOR i001_pb
 
   CALL g_aqd.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH aqd_curs INTO g_aqd[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
    
      IF NOT cl_null(g_aqd[g_cnt].aqd01) THEN
        #FUN-A50102--mark--str--
        #LET g_plant_new = g_aqd[g_cnt].aqd01
        #CALL s_getdbs()
        #LET l_dbs=g_dbs_new 
        #FUN-A50102--mark--end
         SELECT azp02 INTO l_azp02 FROM azp_file
          WHERE azp01=g_aqd[g_cnt].aqd01
      END IF
      IF NOT cl_null(g_aqd[g_cnt].aqd02) THEN
        #LET l_sql=" SELECT ool02 FROM ",l_dbs CLIPPED,"ool_file ",    #FUN-A50102
         LET l_sql=" SELECT ool02 FROM ",cl_get_target_table(g_aqd[g_cnt].aqd01,'ool_file'),     #FUN-A50102
                   "  WHERE ool01='",g_aqd[g_cnt].aqd02 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[g_cnt].aqd01) RETURNING l_sql    #FUN-A50102 
         PREPARE i001_b01 FROM l_sql
         DECLARE i001_01_curs CURSOR FOR i001_b01
         OPEN i001_01_curs
         FETCH i001_01_curs INTO l_ool02
      END IF
      IF NOT cl_null(g_aqd[g_cnt].aqd03) THEN
        #LET l_sql=" SELECT apr02 FROM ",l_dbs CLIPPED,"apr_file ",    #FUN-A50102
         LET l_sql=" SELECT apr02 FROM ",cl_get_target_table(g_aqd[g_cnt].aqd01,'apr_file'),     #FUN-A50102
                   "  WHERE apr01='",g_aqd[g_cnt].aqd03 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[g_cnt].aqd01) RETURNING l_sql    #FUN-A50102)
         PREPARE i001_b02 FROM l_sql
         DECLARE i001_02_curs CURSOR FOR i001_b02
         OPEN i001_02_curs
         FETCH i001_02_curs INTO l_apr02
      END IF
      IF NOT cl_null(g_aqd[g_cnt].aqd04) THEN
        #LET l_sql=" SELECT oag02 FROM ",l_dbs CLIPPED,"oag_file ",    #FUN-A50102
         LET l_sql=" SELECT oag02 FROM ",cl_get_target_table(g_aqd[g_cnt].aqd01,'oag_file'),      #FUN-A50102      
                   "  WHERE oag01='",g_aqd[g_cnt].aqd04 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[g_cnt].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_b03 FROM l_sql
         DECLARE i001_03_curs CURSOR FOR i001_b03
         OPEN i001_03_curs
         FETCH i001_03_curs INTO l_oag02
      END IF
      IF NOT cl_null(g_aqd[g_cnt].aqd05) THEN
        #LET l_sql=" SELECT pma02 FROM ",l_dbs CLIPPED,"pma_file ",   #FUN-A50102
         LET l_sql=" SELECT pma02 FROM ",cl_get_target_table(g_aqd[g_cnt].aqd01,'pma_file'),      #FUN-A50102 
                   "  WHERE pma01='",g_aqd[g_cnt].aqd05 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[g_cnt].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_b04 FROM l_sql
         DECLARE i001_04_curs CURSOR FOR i001_b04 
         OPEN i001_04_curs
         FETCH i001_04_curs INTO l_pma02
      END IF
      IF NOT cl_null(g_aqd[g_cnt].aqd06) THEN
        #LET l_sql=" SELECT nma02 FROM ",l_dbs CLIPPED,"nma_file ",    #FUN-A50102
         LET l_sql=" SELECT nma02 FROM ",cl_get_target_table(g_aqd[g_cnt].aqd01,'nma_file'),     #FUN-A50102
                   "  WHERE nma01='",g_aqd[g_cnt].aqd06 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[g_cnt].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_b05 FROM l_sql
         DECLARE i001_05_curs CURSOR FOR i001_b05
         OPEN i001_05_curs
         FETCH i001_05_curs INTO l_nma02
      END IF
      IF NOT cl_null(g_aqd[g_cnt].aqd07) THEN
        #LET l_sql=" SELECT gec02 FROM ",l_dbs CLIPPED,"gec_file ",   #FUN-A50102
         LET l_sql=" SELECT gec02 FROM ",cl_get_target_table(g_aqd[g_cnt].aqd01,'gec_file'),    #FUN-A50102
                   "  WHERE gec01='",g_aqd[g_cnt].aqd07 CLIPPED,"' AND gec011='2'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[g_cnt].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_b06 FROM l_sql
         DECLARE i001_06_curs CURSOR FOR i001_b06
         OPEN i001_06_curs
         FETCH i001_06_curs INTO l_gec02
      END IF
      IF NOT cl_null(g_aqd[g_cnt].aqd08) THEN
        #LET l_sql=" SELECT gec02 FROM ",l_dbs CLIPPED,"gec_file ",   #FUN-A50102
         LET l_sql=" SELECT gec02 FROM ",cl_get_target_table(g_aqd[g_cnt].aqd01,'gec_file'),    #FUN-A50102
                   "  WHERE gec01='",g_aqd[g_cnt].aqd08 CLIPPED,"' AND gec011='1'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[g_cnt].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_b07 FROM l_sql
         DECLARE i001_07_curs CURSOR FOR i001_b07
         OPEN i001_07_curs
         FETCH i001_07_curs INTO l_gec021
      END IF
 
      LET g_aqd[g_cnt].aqd01_1 = l_azp02
      LET g_aqd[g_cnt].aqd02_1 = l_ool02
      LET g_aqd[g_cnt].aqd03_1 = l_apr02
      LET g_aqd[g_cnt].aqd04_1 = l_oag02
      LET g_aqd[g_cnt].aqd05_1 = l_pma02
      LET g_aqd[g_cnt].aqd06_1 = l_nma02
      LET g_aqd[g_cnt].aqd07_1 = l_gec02
      LET g_aqd[g_cnt].aqd08_1 = l_gec021
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_aqd.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aqd TO s_aqd.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      ON ACTION output
         LET g_action_choice="output"
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
 
 
FUNCTION i001_out()
    DEFINE
        l_aqd           RECORD 
              aqd01     LIKE aqd_file.aqd01,
              aqd01_1   LIKE azp_file.azp02,
              aqd02     LIKE aqd_file.aqd02,
              aqd02_1   LIKE ool_file.ool02,
              aqd03     LIKE aqd_file.aqd03,
              aqd03_1   LIKE apr_file.apr02,
              aqd04     LIKE aqd_file.aqd04,
              aqd04_1   LIKE oag_file.oag02,
              aqd05     LIKE aqd_file.aqd05,
              aqd05_1   LIKE pma_file.pma02,
              aqd06     LIKE aqd_file.aqd06,
              aqd07     LIKE aqd_file.aqd07,
              aqd08     LIKE aqd_file.aqd08,
              aqd09     LIKE aqd_file.aqd09, 
              aqd10     LIKE aqd_file.aqd10, 
              aqd11     LIKE aqd_file.aqd11, 
              aqd12     LIKE aqd_file.aqd12, 
              aqd13     LIKE aqd_file.aqd13, 
              aqd14     LIKE aqd_file.aqd14, 
              aqd15     LIKE aqd_file.aqd15,
              aqd16     LIKE aqd_file.aqd16,
              aqdacti   LIKE aqd_file.aqdacti
                        END RECORD,
        l_i             LIKE type_file.num5,
        l_name          LIKE type_file.chr20,        
        #l_sql           LIKE type_file.chr1000,
        l_sql       STRING      #NO.FUN-910082
       #l_dbs           LIKE type_file.chr21     #FUN-A50102
   
#No.TQC-710076 -- begin --
#    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF cl_null(g_wc2) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL cl_wait()
    CALL cl_del_data(l_table)         #No.FUN-770005
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql=" SELECT aqd01,'',aqd02,'',aqd03,'',aqd04,'',aqd05,'',aqd06,",
              "        aqd07,aqd08,aqd09,aqd10,aqd11,aqd12,aqd13, ",
              "        aqd14,aqd15,aqd16,aqdacti                       ",
              "   FROM aqd_file ",
              "  WHERE ",g_wc2 CLIPPED,
              "  ORDER BY aqd01 "
 
    PREPARE i001_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i001_co                           # CURSOR
        CURSOR FOR i001_p1
#No.FUN-770005--begin--                                                                                                             
{  
    LET g_rlang = g_lang
    CALL cl_outnam('aapi001') RETURNING l_name   
 
     CALL cl_prt_pos_len()
 
    START REPORT i001_rep TO l_name
}
    FOREACH i001_co INTO l_aqd.*
{ 
       IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
}
#No.FUN-770005--end--
        LET l_aqd.aqd01_1 = null
        LET l_aqd.aqd02_1 = null
        LET l_aqd.aqd03_1 = null
        LET l_aqd.aqd04_1 = null
        LET l_aqd.aqd05_1 = null
        IF NOT cl_null(l_aqd.aqd01) THEN
          #FUN-A50102--mark--str--
          #LET g_plant_new = l_aqd.aqd01
          #CALL s_getdbs()
          #LET l_dbs=g_dbs_new 
          #FUN-A50102--mark--end
           SELECT azp02 INTO l_aqd.aqd01_1 FROM azp_file
            WHERE azp01=l_aqd.aqd01
        END IF
        IF NOT cl_null(l_aqd.aqd02) THEN
          #LET l_sql=" SELECT ool02 FROM ",l_dbs CLIPPED,"ool_file ",   #FUN-A50102
           LET l_sql=" SELECT ool02 FROM ",cl_get_target_table(l_aqd.aqd01,'ool_file'),   #FUN-A50102
                     "  WHERE ool01='",l_aqd.aqd02 CLIPPED,"'"
 	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_aqd.aqd01) RETURNING l_sql    #FUN-A50102
           PREPARE i001_r01 FROM l_sql
           DECLARE i001_01_cus CURSOR FOR i001_r01
           OPEN i001_01_cus
           FETCH i001_01_cus INTO l_aqd.aqd02_1
        END IF
        IF NOT cl_null(l_aqd.aqd03) THEN
          #LET l_sql=" SELECT apr02 FROM ",l_dbs CLIPPED,"apr_file ",   #FUN-A50102
           LET l_sql=" SELECT apr02 FROM ",cl_get_target_table(l_aqd.aqd01,'apr_file'),   #FUN-A50102
                     "  WHERE apr01='",l_aqd.aqd03 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_aqd.aqd01) RETURNING l_sql    #FUN-A50102
           PREPARE i001_r02 FROM l_sql
           DECLARE i001_02_cus CURSOR FOR i001_r02
           OPEN i001_02_cus
           FETCH i001_02_cus INTO l_aqd.aqd03_1
        END IF
        IF NOT cl_null(l_aqd.aqd04) THEN
          #LET l_sql=" SELECT oag02 FROM ",l_dbs CLIPPED,"oag_file ",   #FUN-A50102
           LET l_sql=" SELECT oag02 FROM ",cl_get_target_table(l_aqd.aqd01,'oag_file'),  #FUN-A50102 
                     "  WHERE oag01='",l_aqd.aqd04 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_aqd.aqd01) RETURNING l_sql    #FUN-A50102
           PREPARE i001_r03 FROM l_sql
           DECLARE i001_03_cus CURSOR FOR i001_r03
           OPEN i001_03_cus
           FETCH i001_03_cus INTO l_aqd.aqd04_1
        END IF
        IF NOT cl_null(l_aqd.aqd05) THEN
          #LET l_sql=" SELECT pma02 FROM ",l_dbs CLIPPED,"pma_file ",   #FUN-A50102
           LET l_sql=" SELECT pma02 FROM ",cl_get_target_table(l_aqd.aqd01,'pma_file'),   #FUN-A50102 
                     "  WHERE pma01='",l_aqd.aqd05 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,l_aqd.aqd01) RETURNING l_sql    #FUN-A50102
           PREPARE i001_r04 FROM l_sql
           DECLARE i001_04_cus CURSOR FOR i001_r04 
           OPEN i001_04_cus
           FETCH i001_04_cus INTO l_aqd.aqd05_1
        END IF
#No.FUN-770005--begin--
        EXECUTE insert_prep USING
             l_aqd.aqd01,l_aqd.aqd02,l_aqd.aqd03,l_aqd.aqd04,l_aqd.aqd05,
             l_aqd.aqd06,l_aqd.aqd07,l_aqd.aqd08,l_aqd.aqd09,l_aqd.aqd10,
             l_aqd.aqd11,l_aqd.aqd12,l_aqd.aqd13,l_aqd.aqd14,l_aqd.aqd15, 
             l_aqd.aqd16,l_aqd.aqdacti,l_aqd.aqd01_1,l_aqd.aqd02_1,
             l_aqd.aqd03_1,l_aqd.aqd04_1,l_aqd.aqd05_1
         # OUTPUT TO REPORT i001_rep(l_aqd.*)
      END FOREACH
 
#   FINISH REPORT i001_rep
 
#   CLOSE i001_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aapi001','aapi001',l_sql,g_wc2)
#No.FUN-770005--end--       
END FUNCTION
#No.FUN-770005--begin--
{
 REPORT i001_rep(sr)
     DEFINE l_aqd02     LIKE type_file.chr50,
            l_aqd03     LIKE type_file.chr50,
            l_aqd04     LIKE type_file.chr50,
            l_aqd05     LIKE type_file.chr50
     DEFINE
         l_trailer_sw   LIKE type_file.chr1,
         sr             RECORD 
              aqd01     LIKE aqd_file.aqd01,
              aqd01_1   LIKE azp_file.azp02,
              aqd02     LIKE aqd_file.aqd02,
              aqd02_1   LIKE ool_file.ool02,
              aqd03     LIKE aqd_file.aqd03,
              aqd03_1   LIKE apr_file.apr02,
              aqd04     LIKE aqd_file.aqd04,
              aqd04_1   LIKE oag_file.oag02,
              aqd05     LIKE aqd_file.aqd05,
              aqd05_1   LIKE pma_file.pma02,
              aqd06     LIKE aqd_file.aqd06,
              aqd07     LIKE aqd_file.aqd07,
              aqd08     LIKE aqd_file.aqd08,
              aqd09     LIKE aqd_file.aqd09, 
              aqd10     LIKE aqd_file.aqd10, 
              aqd11     LIKE aqd_file.aqd11, 
              aqd12     LIKE aqd_file.aqd12, 
              aqd13     LIKE aqd_file.aqd13, 
              aqd14     LIKE aqd_file.aqd14, 
              aqd15     LIKE aqd_file.aqd15,
              aqd16     LIKE aqd_file.aqd16,
              aqdacti   LIKE aqd_file.aqdacti
                        END RECORD
 
    OUTPUT
        TOP MARGIN g_top_margin
        LEFT MARGIN g_left_margin
        BOTTOM MARGIN g_bottom_margin
        PAGE LENGTH g_page_line
 
     ORDER BY sr.aqd01
 
     FORMAT
         PAGE HEADER
             PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
             PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
             LET g_pageno = g_pageno + 1
             LET pageno_total = PAGENO USING '<<<','/pageno'
             PRINT g_head CLIPPED, pageno_total
             PRINT ''
             PRINT g_dash
             PRINT g_x[31],                  
                   g_x[32],
                   g_x[49],
                   g_x[33],
                   g_x[50],
                   g_x[34],
                   g_x[51],
                   g_x[35],
                   g_x[52],
                   g_x[36],
                   g_x[37],
                   g_x[38],
                   g_x[39], 
                   g_x[40],
                   g_x[41],
                   g_x[42],
                   g_x[43],
                   g_x[44],
                   g_x[45], 
                   g_x[46], 
                   g_x[47], 
                   g_x[48] 
             PRINT g_dash1                                    
             LET l_trailer_sw = 'y'
 
         ON EVERY ROW
             PRINT COLUMN g_c[31],sr.aqd01 CLIPPED,
                   COLUMN g_c[32],sr.aqd01_1 CLIPPED,
                   COLUMN g_c[49],sr.aqd02 CLIPPED,
                   COLUMN g_c[33],sr.aqd02_1 CLIPPED,
                   COLUMN g_c[50],sr.aqd03 CLIPPED,
                   COLUMN g_c[34],sr.aqd03_1 CLIPPED,
                   COLUMN g_c[51],sr.aqd04 CLIPPED,  
                   COLUMN g_c[35],sr.aqd04_1 CLIPPED,  
                   COLUMN g_c[52],sr.aqd05 CLIPPED,
                   COLUMN g_c[36],sr.aqd05_1 CLIPPED,
                   COLUMN g_c[37],sr.aqd06 CLIPPED,
                   COLUMN g_c[38],sr.aqd07 CLIPPED,
                   COLUMN g_c[39],sr.aqd08 CLIPPED,
                   COLUMN g_c[40],sr.aqd09 CLIPPED,
                   COLUMN g_c[41],sr.aqd10 CLIPPED,
                   COLUMN g_c[42],sr.aqd11 CLIPPED,
                   COLUMN g_c[43],sr.aqd12 CLIPPED,
                   COLUMN g_c[44],sr.aqd13 CLIPPED,
                   COLUMN g_c[45],sr.aqd14 CLIPPED, 
                   COLUMN g_c[46],sr.aqd15 CLIPPED, 
                   COLUMN g_c[47],sr.aqd16 CLIPPED, 
                   COLUMN g_c[48],sr.aqdacti CLIPPED
 
         ON LAST ROW
             PRINT g_dash[1,g_len]
             PRINT g_x[4],
                   COLUMN (g_len-9), g_x[7] CLIPPED 
             LET l_trailer_sw = 'n'
 
         PAGE TRAILER
             IF l_trailer_sw = 'y' THEN
                 PRINT g_dash2
                 PRINT g_x[4],
                       COLUMN (g_len-9), g_x[6] CLIPPED 
             ELSE
                 SKIP 2 LINE
             END IF
 
 END REPORT
}
#No.FUN-770005--end--  
FUNCTION i001_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd='a' THEN
       CALL cl_set_comp_entry("aqd01",TRUE)
    END IF
END FUNCTION  
               
FUNCTION i001_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
    IF p_cmd='u' THEN
       CALL cl_set_comp_entry("aqd01",FALSE)
    END IF                                                                                 
END FUNCTION            
 
FUNCTION i001_show()
  #DEFINE l_dbs     LIKE type_file.chr21    #FUN-A50102
   DEFINE 
          #l_sql     LIKE type_file.chr1000
          l_sql           STRING     #NO.FUN-910082
   DEFINE l_azp02   LIKE azp_file.azp02
   DEFINE l_ool02   LIKE ool_file.ool02
   DEFINE l_apr02   LIKE apr_file.apr02
   DEFINE l_oag02   LIKE oag_file.oag02
   DEFINE l_pma02   LIKE pma_file.pma02
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_gec02   LIKE gec_file.gec02
   DEFINE l_gec021  LIKE gec_file.gec02
 
      IF NOT cl_null(g_aqd[l_ac].aqd01) THEN
        #FUN-A50102--mark--str--
        #LET g_plant_new = g_aqd[l_ac].aqd01
        #CALL s_getdbs()
        #LET l_dbs=g_dbs_new 
        #FUN-A50102--mark--end
         SELECT azp02 INTO l_azp02 FROM azp_file
          WHERE azp01=g_aqd[l_ac].aqd01
      END IF
      IF NOT cl_null(g_aqd[l_ac].aqd02) THEN
        #LET l_sql=" SELECT ool02 FROM ",l_dbs CLIPPED,"ool_file ",   #FUN-A50102
         LET l_sql=" SELECT ool02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'ool_file'),   #FUN-A50102
                   "  WHERE ool01='",g_aqd[l_ac].aqd02 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_s01 FROM l_sql
         DECLARE i001_01_curs1 CURSOR FOR i001_s01
         OPEN i001_01_curs1
         FETCH i001_01_curs1 INTO l_ool02
      END IF
      IF NOT cl_null(g_aqd[l_ac].aqd03) THEN
        #LET l_sql=" SELECT apr02 FROM ",l_dbs CLIPPED,"apr_file ",  #FUN-A50102
         LET l_sql=" SELECT apr02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'apr_file'),   #FUN-A50102
                   "  WHERE apr01='",g_aqd[l_ac].aqd03 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_s02 FROM l_sql
         DECLARE i001_02_curs1 CURSOR FOR i001_s02
         OPEN i001_02_curs1
         FETCH i001_02_curs1 INTO l_apr02
      END IF
      IF NOT cl_null(g_aqd[l_ac].aqd04) THEN
        #LET l_sql=" SELECT oag02 FROM ",l_dbs CLIPPED,"oag_file ",   #FUN-A50102
         LET l_sql=" SELECT oag02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'oag_file'),   #FUN-A50102
                   "  WHERE oag01='",g_aqd[l_ac].aqd04 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_s03 FROM l_sql
         DECLARE i001_03_curs1 CURSOR FOR i001_s03
         OPEN i001_03_curs1
         FETCH i001_03_curs1 INTO l_oag02
      END IF
      IF NOT cl_null(g_aqd[l_ac].aqd05) THEN
        #LET l_sql=" SELECT pma02 FROM ",l_dbs CLIPPED,"pma_file ",   #FUN-A50102
         LET l_sql=" SELECT pma02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'pma_file'),   #FUN-A50102
                   "  WHERE pma01='",g_aqd[l_ac].aqd05 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_s04 FROM l_sql
         DECLARE i001_04_curs1 CURSOR FOR i001_s04 
         OPEN i001_04_curs1
         FETCH i001_04_curs1 INTO l_pma02
      END IF
      IF NOT cl_null(g_aqd[l_ac].aqd06) THEN
        #LET l_sql=" SELECT nma02 FROM ",l_dbs CLIPPED,"nma_file ",   #FUN-A50102
         LET l_sql=" SELECT nma02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'nma_file'),   #FUN-A50102
                   "  WHERE nma01='",g_aqd[l_ac].aqd06 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_s05 FROM l_sql
         DECLARE i001_05_curs1 CURSOR FOR i001_s05
         OPEN i001_05_curs1
         FETCH i001_05_curs1 INTO l_nma02
      END IF
      IF NOT cl_null(g_aqd[l_ac].aqd07) THEN
        #LET l_sql=" SELECT gec02 FROM ",l_dbs CLIPPED,"gec_file ",   #FUN-A50102
         LET l_sql=" SELECT gec02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'gec_file'),   #FUN-A50102
                   "  WHERE gec01='",g_aqd[l_ac].aqd07 CLIPPED,"' AND gec011='2'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_s06 FROM l_sql
         DECLARE i001_06_curs1 CURSOR FOR i001_s06
         OPEN i001_06_curs1
         FETCH i001_06_curs1 INTO l_gec02
      END IF
      IF NOT cl_null(g_aqd[l_ac].aqd08) THEN
        #LET l_sql=" SELECT gec02 FROM ",l_dbs CLIPPED,"gec_file ",   #FUN-A50102
         LET l_sql=" SELECT gec02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'gec_file'),   #FUN-A50102
                   "  WHERE gec01='",g_aqd[l_ac].aqd08 CLIPPED,"' AND gec011='1'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
         PREPARE i001_s07 FROM l_sql
         DECLARE i001_07_curs1 CURSOR FOR i001_s07
         OPEN i001_07_curs1
         FETCH i001_07_curs1 INTO l_gec021
      END IF
 
      LET g_aqd[l_ac].aqd01_1 = l_azp02
      LET g_aqd[l_ac].aqd02_1 = l_ool02
      LET g_aqd[l_ac].aqd03_1 = l_apr02
      LET g_aqd[l_ac].aqd04_1 = l_oag02
      LET g_aqd[l_ac].aqd05_1 = l_pma02
      LET g_aqd[l_ac].aqd06_1 = l_nma02
      LET g_aqd[l_ac].aqd07_1 = l_gec02
      LET g_aqd[l_ac].aqd08_1 = l_gec021
END FUNCTION
 
#FUNCTION i001_aqd02(p_dbs)   #FUN-A50102
FUNCTION i001_aqd02()         #FUN-A50102
DEFINE 
       #l_sql   LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE p_dbs   LIKE type_file.chr21   #FUN-A50102
#DEFINE l_dbs   LIKE type_file.chr21   #FUN-A50102
DEFINE l_ool01 LIKE ool_file.ool01
DEFINE l_ool02 LIKE ool_file.ool02
 
     #LET l_dbs = p_dbs   #FUN-A50102
     LET g_errno=''
     LET l_sql = " SELECT ool01,ool02 ",
                #" FROM ",l_dbs CLIPPED ,"ool_file ",     #FUN-A50102
                 " FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'ool_file'),   #FUN-A50102
                 " WHERE ool01='",g_aqd[l_ac].aqd02 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_01 FROM l_sql
     DECLARE i001_01_cs CURSOR FOR i001_01
     OPEN i001_01_cs
     FETCH i001_01_cs INTO l_ool01,l_ool02
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
           
     CLOSE i001_01_cs
     RETURN l_ool01,l_ool02
     
END FUNCTION
 
#FUN-A50102--mod--str--
#FUNCTION i001_aqd03(p_dbs)
#DEFINE   p_dbs      LIKE type_file.chr21
#DEFINE   l_dbs      LIKE type_file.chr21
FUNCTION i001_aqd03()
#FUN-A50102--mod--end
DEFINE   
         #l_sql      LIKE type_file.chr1000
         l_sql           STRING     #NO.FUN-910082
DEFINE   l_apr01    LIKE apr_file.apr01
DEFINE   l_apr02    LIKE apr_file.apr02
DEFINE   l_apracti  LIKE apr_file.apracti
 
    #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #LET l_sql=" SELECT apr01,apr02,apracti FROM ",l_dbs CLIPPED,"apr_file ",   #FUN-A50102
     LET l_sql=" SELECT apr01,apr02,apracti ",      #FUN-A50102
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'apr_file'),   #FUN-A50102
               " WHERE apr01='",g_aqd[l_ac].aqd03,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_02 FROM l_sql
     DECLARE i001_02_cs CURSOR FOR i001_02
     OPEN i001_02_cs
     FETCH i001_02_cs INTO l_apr01,l_apr02,l_apracti
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_apracti='N'     LET g_errno='ams-106'
         OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
     CLOSE i001_02_cs
 
     RETURN l_apr01,l_apr02
END FUNCTION
 
#FUNCTION i001_aqd04(p_dbs)    #FUN-A50102
FUNCTION i001_aqd04()          #FUN-A50102
DEFINE 
       #l_sql     LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs     LIKE type_file.chr21     #FUN-A50102
#DEFINE p_dbs     LIKE type_file.chr21     #FUN-A50102
DEFINE l_oag01   LIKE oag_file.oag01
DEFINE l_oag02   LIKE oag_file.oag02
 
     #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #LET l_sql=" SELECT oag01,oag02 FROM ",l_dbs CLIPPED,"oag_file ",    #FUN-A50102
     LET l_sql=" SELECT oag01,oag02 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'oag_file'),   #FUN-A50102
               " WHERE oag01='",g_aqd[l_ac].aqd04,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_03 FROM l_sql
     DECLARE i001_03_cs CURSOR FOR i001_03
     OPEN i001_03_cs
     FETCH i001_03_cs INTO l_oag01,l_oag02
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
     CLOSE i001_03_cs
 
     RETURN l_oag01,l_oag02
END FUNCTION
 

#FUNCTION i001_aqd05(p_dbs)    #FUN-A50102
FUNCTION i001_aqd05()          #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_pma01     LIKE pma_file.pma01
DEFINE l_pma02     LIKE pma_file.pma02
DEFINE l_pmaacti   LIKE pma_file.pmaacti
 
     #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT pma01,pma02,pmaacti FROM ",l_dbs CLIPPED,"pma_file ",  
     LET l_sql=" SELECT pma01,pma02,pmaacti ",    
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'pma_file'),
    #FUN-A50102--mod--end
               "  WHERE pma01='",g_aqd[l_ac].aqd05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_04 FROM l_sql
     DECLARE i001_04_cs CURSOR FOR i001_04
     OPEN i001_04_cs
     FETCH i001_04_cs INTO l_pma01,l_pma02,l_pmaacti
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_pmaacti='N'     LET g_errno='ams-106'
         OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
     CLOSE i001_04_cs
 
     RETURN l_pma01,l_pma02
END FUNCTION
 
#FUNCTION i001_aqd06(p_dbs)    #FUN-A50102
FUNCTION i001_aqd06()          #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21   #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21   #FUN-A50102
DEFINE l_nma01     LIKE nma_file.nma01
DEFINE l_nma02     LIKE nma_file.nma02
DEFINE l_nmaacti   LIKE nma_file.nmaacti
 
    #LET l_dbs = p_dbs   #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT nma01,nma02,nmaacti FROM ",l_dbs CLIPPED,"nma_file ",
     LET l_sql=" SELECT nma01,nma02,nmaacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'nma_file'),
    #FUN-A50102--mod--end
               "  WHERE nma01='",g_aqd[l_ac].aqd06,"' AND nma37='0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_05 FROM l_sql
     DECLARE i001_05_cs CURSOR FOR i001_05
     OPEN i001_05_cs
     FETCH i001_05_cs INTO l_nma01,l_nma02,l_nmaacti
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_nmaacti='N'     LET g_errno='ams-106'
         OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
     CLOSE i001_05_cs
 
     RETURN l_nma01,l_nma02
END FUNCTION
 
#FUNCTION i001_aqd07(p_dbs)    #FUN-A50102
FUNCTION i001_aqd07()          #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_gec01     LIKE gec_file.gec01
DEFINE l_gec02     LIKE gec_file.gec02
DEFINE l_gecacti   LIKE gec_file.gecacti
 
    #LET l_dbs = p_dbs    #FUN-A50102
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT gec01,gec02 FROM ",l_dbs CLIPPED,"gec_file ",
     LET l_sql=" SELECT gec01,gec02 ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'gec_file'),
    #FUN-A50102--mod--end
               " WHERE gec01='",g_aqd[l_ac].aqd07,"'  AND gec011='2' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_06 FROM l_sql
     DECLARE i001_06_cs CURSOR FOR i001_06
     OPEN i001_06_cs
     FETCH i001_06_cs INTO l_gec01,l_gec02,l_gecacti
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_gecacti='N'     LET g_errno='ams-106'
         OTHERWISE           
              LET g_errno=SQLCA.sqlcode USING '------'                               
     END CASE
     CLOSE i001_06_cs
 
     RETURN l_gec01,l_gec02
 
END FUNCTION
 
#FUNCTION i001_aqd08(p_dbs)   #FUN-A50102
FUNCTION i001_aqd08()         #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_gec01     LIKE gec_file.gec01
DEFINE l_gec02     LIKE gec_file.gec02
DEFINE l_gecacti   LIKE gec_file.gecacti
 
    #LET l_dbs = p_dbs    #FUN-A50098
     LET g_errno=''
    #FUN-A50098--mod--str--
    #LET l_sql=" SELECT gec01,gec02,gecacti FROM ",l_dbs CLIPPED,"gec_file ",
     LET l_sql=" SELECT gec01,gec02,gecacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'gec_file'), 
    #FUN-A50098--mod--end
               " WHERE gec01='",g_aqd[l_ac].aqd08,"'   AND gec011='1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_07 FROM l_sql
     DECLARE i001_07_cs CURSOR FOR i001_07
     OPEN i001_07_cs
     FETCH i001_07_cs INTO l_gec01,l_gec02,l_gecacti
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_gecacti='N'     LET g_errno='ams-106'
         OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
     CLOSE i001_07_cs
 
     RETURN l_gec01,l_gec02
 
END FUNCTION
 
#FUNCTION i001_aqd09(p_dbs)    #FUN-A50102
FUNCTION i001_aqd09()          #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_ooyslip   LIKE ooy_file.ooyslip
DEFINE l_ooyacti   LIKE ooy_file.ooyacti
 
    #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #FUN-A50098--mod--str--
    #LET l_sql=" SELECT ooyslip,ooyacti FROM ",l_dbs CLIPPED,"ooy_file ",
     LET l_sql=" SELECT ooyslip,ooyacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'ooy_file'),
    #FUN-A50098--mod--end
               "  WHERE ooyslip='",g_aqd[l_ac].aqd09,"' AND ooytype='14' ",
               " AND ooydmy1='N'  "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_08 FROM l_sql
     DECLARE i001_08_cs CURSOR FOR i001_08
     OPEN i001_08_cs
     FETCH i001_08_cs INTO l_ooyslip,l_ooyacti
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_ooyacti='N'     LET g_errno='ams-106'
         OTHERWISE
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
     CLOSE i001_08_cs
 
     RETURN l_ooyslip
END FUNCTION
 
#FUNCTION i001_aqd10(p_dbs)    #FUN-A50098
FUNCTION i001_aqd10()          #FUN-A50098
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50098
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50098
DEFINE l_ooyslip   LIKE ooy_file.ooyslip
DEFINE l_ooyacti   LIKE ooy_file.ooyacti
 
    #LET l_dbs = p_dbs    #FUN-A50098
     LET g_errno=''
    #FUN-A50098--mod--str--
    #LET l_sql=" SELECT ooyslip,ooyacti FROM ",l_dbs CLIPPED,"ooy_file ",
     LET l_sql=" SELECT ooyslip,ooyacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'ooy_file'),
    #FUN-A50098--mod--end
               " WHERE ooyslip='",g_aqd[l_ac].aqd10,"' AND ooytype='22' ",
               " AND ooydmy1='N'  "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_09 FROM l_sql
     DECLARE i001_09_cs CURSOR FOR i001_09
     OPEN i001_09_cs
     FETCH i001_09_cs INTO l_ooyslip,l_ooyacti
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_ooyacti='N'     LET g_errno='ams-106'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
     CLOSE i001_09_cs
 
     RETURN l_ooyslip
    
END FUNCTION
 
#FUNCTION i001_aqd11(p_dbs)   #FUN-A50102
FUNCTION i001_aqd11()         #FUN-A50102 
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_ooyslip   LIKE ooy_file.ooyslip
DEFINE l_ooyacti   LIKE ooy_file.ooyacti
 
    #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT ooyslip,ooyacti FROM ",l_dbs CLIPPED,"ooy_file ",
     LET l_sql=" SELECT ooyslip,ooyacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'ooy_file'),
    #FUN-A50102--mod--end
               " WHERE ooyslip='",g_aqd[l_ac].aqd11,"' AND ooytype='30' ",
               " AND ooydmy1='Y'  "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_10 FROM l_sql
     DECLARE i001_10_cs CURSOR FOR i001_10
     OPEN i001_10_cs
     FETCH i001_10_cs INTO l_ooyslip,l_ooyacti
     CLOSE I001_10_cs
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_ooyacti='N'     LET g_errno='ams-106'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
 
     RETURN l_ooyslip
END FUNCTION
 
#FUNCTION i001_aqd12(p_dbs)    #FUN-A50102
FUNCTION i001_aqd12()         #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql       STRING      #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_apyslip   LIKE apy_file.apyslip
DEFINE l_apyacti   LIKE apy_file.apyacti
 
    #LET l_dbs = p_dbs   #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT apyslip,apyacti FROM ",l_dbs CLIPPED,"apy_file ",
     LET l_sql=" SELECT apyslip,apyacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'apy_file'),
    #FUN-A50102--mod--end
               " WHERE apyslip='",g_aqd[l_ac].aqd12,"' AND apykind='12' ",
               " AND apydmy3='N'  "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_11 FROM l_sql
     DECLARE i001_11_cs CURSOR FOR i001_11
     OPEN i001_11_cs
     FETCH i001_11_cs INTO l_apyslip,l_apyacti
     CASE 
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_apyacti='N'     LET g_errno='ams-106'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE 
     CLOSE i001_11_cs
 
     RETURN l_apyslip
 
END FUNCTION
 
#FUNCTION i001_aqd13(p_dbs)     #FUN-A50102
FUNCTION i001_aqd13()           #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_apyslip   LIKE apy_file.apyslip
DEFINE l_apyacti   LIKE apy_file.apyacti
 
    #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT apyslip,apyacti FROM ",l_dbs CLIPPED,"apy_file ",
     LET l_sql=" SELECT apyslip,apyacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'apy_file'),
    #FUN-A50102--mod--end
               " WHERE apyslip='",g_aqd[l_ac].aqd13,"' AND apykind='22' ",
               " AND apydmy3='N'  "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_12 FROM l_sql
     DECLARE i001_12_cs CURSOR FOR i001_12
     OPEN i001_12_cs
     FETCH i001_12_cs INTO l_apyslip,l_apyacti
     CASE 
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_apyacti='N'         LET g_errno='ams-106'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE 
     CLOSE i001_12_cs 
 
     RETURN l_apyslip
 
END FUNCTION
 
#FUNCTION i001_aqd14(p_dbs)    #FUN-A50102
FUNCTION i001_aqd14()          #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_apyslip   LIKE apy_file.apyslip
DEFINE l_apyacti   LIKE apy_file.apyacti
 
    #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT apyslip,apyacti FROM ",l_dbs CLIPPED,"apy_file ",
     LET l_sql=" SELECT apyslip,apyacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'apy_file'), 
    #FUN-A50102--mod--end
               " WHERE apyslip='",g_aqd[l_ac].aqd14,"' AND apykind='33' ",
               " AND apydmy3='Y'  "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_13 FROM l_sql
     DECLARE i001_13_cs CURSOR FOR i001_13
     OPEN i001_13_cs
     FETCH i001_13_cs INTO l_apyslip,l_apyacti
     CASE 
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_apyacti='N'         LET g_errno='ams-106'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE 
     CLOSE i001_13_cs
 
     RETURN l_apyslip
 
END FUNCTION
 
#FUNCTION i001_aqd15(p_dbs)    #FUN-A50102
FUNCTION i001_aqd15()          #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21     #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21     #FUN-A50102
DEFINE l_nmc01     LIKE nmc_file.nmc01
DEFINE l_nmcacti   LIKE nmc_file.nmcacti
 
    #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT nmc01,nmcacti FROM ",l_dbs CLIPPED,"nmc_file ",
     LET l_sql=" SELECT nmc01,nmcacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'nmc_file'),
    #FUN-A50102--mod--end
               " WHERE nmc01='",g_aqd[l_ac].aqd15,"' AND nmc03='1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_14 FROM l_sql
     DECLARE i001_14_cs CURSOR FOR i001_14
     OPEN i001_14_cs
     FETCH i001_14_cs INTO l_nmc01,l_nmcacti
     CASE 
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_nmcacti='N'     LET g_errno='ams-106'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE 
     CLOSE i001_14_cs
 
     RETURN l_nmc01
 
END FUNCTION
 
#FUNCTION i001_aqd16(p_dbs)    #FUN-A50102
FUNCTION i001_aqd16()          #FUN-A50102
DEFINE 
       #l_sql       LIKE type_file.chr1000
       l_sql           STRING     #NO.FUN-910082
#DEFINE l_dbs       LIKE type_file.chr21    #FUN-A50102
#DEFINE p_dbs       LIKE type_file.chr21    #FUN-A50102
DEFINE l_nmc01     LIKE nmc_file.nmc01
DEFINE l_nmcacti   LIKE nmc_file.nmcacti
 
    #LET l_dbs = p_dbs     #FUN-A50102
     LET g_errno=''
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT nmc01,nmcacti FROM ",l_dbs CLIPPED,"nmc_file ",
     LET l_sql=" SELECT nmc01,nmcacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'nmc_file'),
    #FUN-A50102--mod--end
               " WHERE nmc01='",g_aqd[l_ac].aqd16,"' AND nmc03='2' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_15 FROM l_sql
     DECLARE i001_15_cs CURSOR FOR i001_15
     OPEN i001_15_cs
     FETCH i001_15_cs INTO l_nmc01,l_nmcacti
     CASE 
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_nmcacti='N'     LET g_errno='ams-106'
         OTHERWISE 
              LET g_errno=SQLCA.sqlcode USING '------'
     END CASE 
     CLOSE i001_15_cs 
 
     RETURN l_nmc01
 
END FUNCTION
 
#No.TQC-760075 --start--
#FUN-A50102--mod--str--
#FUNCTION i001_apt01(p_dbs)
#DEFINE   p_dbs      LIKE type_file.chr21
#DEFINE   l_dbs      LIKE type_file.chr21
FUNCTION i001_apt01()
#FUN-A50102--mod--end
DEFINE   
         #l_sql      LIKE type_file.chr1000
         l_sql       STRING      #NO.FUN-910082
DEFINE   l_n        LIKE type_file.num5
DEFINE   l_aza63    LIKE aza_file.aza63
DEFINE   l_apt03    LIKE apt_file.apt03
DEFINE   l_apt04    LIKE apt_file.apt04
DEFINE   l_apt031   LIKE apt_file.apt031
DEFINE   l_apt041   LIKE apt_file.apt041
DEFINE   l_aptacti  LIKE apt_file.aptacti
 
    #LET l_dbs = p_dbs    #FUN-A50102
     LET g_errno=''
    #LET l_sql=" SELECT aza63 FROM ",l_dbs CLIPPED,"aza_file "    #FUN-A50102
     LET l_sql=" SELECT aza63 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'aza_file')    #FUN-A50102
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_aza_p FROM l_sql
     DECLARE i001_aza_c CURSOR FOR i001_aza_p
     OPEN i001_aza_c
     FETCH i001_aza_c INTO l_aza63
   
    #FUN-A50102--mod--str--
    #LET l_sql=" SELECT apt03,apt031,apt04,apt041,aptacti FROM ",l_dbs CLIPPED,"apt_file ",
     LET l_sql=" SELECT apt03,apt031,apt04,apt041,aptacti ",
               "   FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'apt_file'),
    #FUN-A50102--mod--end
               "  WHERE apt01='",g_aqd[l_ac].aqd03,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_apt_p1 FROM l_sql
     DECLARE i001_apt_c1 CURSOR FOR i001_apt_p1
     OPEN i001_apt_c1
    #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs CLIPPED,"aag_file ",   #FUN-A50102
     LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'aag_file'),   #FUN-A50102 
               "  WHERE aag01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_aqd[l_ac].aqd01) RETURNING l_sql    #FUN-A50102
     PREPARE i001_aag_p1 FROM l_sql
     DECLARE i001_aag_c1 CURSOR FOR i001_aag_p1
     FOREACH i001_apt_c1 INTO l_apt03,l_apt031,l_apt04,l_apt041,l_aptacti
        OPEN i001_aag_c1 USING l_apt03
        FETCH i001_aag_c1 INTO l_n
        IF l_n = 0 THEN
           LET g_errno='agl-950'
           EXIT FOREACH
        END IF
        OPEN i001_aag_c1 USING l_apt04
        FETCH i001_aag_c1 INTO l_n
        IF l_n = 0 THEN
           LET g_errno='agl-950'
           EXIT FOREACH
        END IF
        IF l_aza63 = 'Y' THEN
           OPEN i001_aag_c1 USING l_apt031
           FETCH i001_aag_c1 INTO l_n
           IF l_n = 0 THEN
              LET g_errno='agl-950'
              EXIT FOREACH
           END IF
           OPEN i001_aag_c1 USING l_apt041
           FETCH i001_aag_c1 INTO l_n
           IF l_n = 0 THEN
              LET g_errno='agl-950'
              EXIT FOREACH
           END IF
        END IF
     END FOREACH
     CASE
         WHEN SQLCA.sqlcode=100 LET g_errno='mfg9329'
         WHEN l_aptacti='N'     LET g_errno='ams-106'
         OTHERWISE
            IF cl_null(g_errno) THEN
               LET g_errno=SQLCA.sqlcode USING '------'
            END IF
     END CASE
 
END FUNCTION
#No.TQC-760075 --end--

#No.MOD-C30365   ---start---   Add
FUNCTION i001_chk_slip(p_slip)
   DEFINE p_slip     STRING
   DEFINE l_aza41    LIKE aza_file.aza41
   DEFINE l_cnt      LIKE type_file.num5

   LET g_sql = "SELECT aza41 FROM ",cl_get_target_table(g_aqd[l_ac].aqd01,'aza_file'),
               " WHERE aza01 = '0'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE i001_sel_aza41 FROM g_sql
   EXECUTE i001_sel_aza41 INTO l_aza41

   LET l_cnt = p_slip.GetLength()
   IF l_cnt != l_aza41 + 2 THEN
      LET g_errno = 'aap-189'
   ELSE
      LET g_errno = NULL
   END IF

END FUNCTION
#No.MOD-C30365   ---end---     Add

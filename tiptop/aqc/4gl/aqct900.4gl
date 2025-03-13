# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aqct900.4gl
# Descriptions...: 品質異常單維護作業
# Input parameter:
# Date & Author..: FUN-720041 07/03/06 BY yiting
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/22 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-950129 09/06/05 By chenmoyan 1.i()段的開窗除了單號，未給default1值。
#                                                      2.檢驗結果的「廠商/部門」開窗未給default1值。
# Modify.........: No.FUN-980007 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980138 09/08/19 By Smapmin 調整複製段程式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-960239 09/10/20 By Pengu 進單身會將資料清空
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控 
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.MOD-B60128 11/06/15 By sabrina (1)新增時不應可以修改"確認否"
#                                                    (2)確認與取消確認的checkbox相反了 
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.MOD-BB0306 11/11/28 By ck2yuan 1.新增時，確認碼給予預設值N。
#                                                    2.判斷qcr06與qcp04 若有值不可小於0 否則提示訊息
# Modify.........: No.FUN-BB0153 11/12/15 By Sakura 增加刪除及作廢功能
   
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30190 12/03/28 By tanxc 將老報表轉成CR報表
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20025 13/02/21 By chenying 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30034 13/04/15 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_qcr           RECORD LIKE qcr_file.*,    #FUN-720041
    g_qcr_t         RECORD LIKE qcr_file.*,
    g_qcr01_t       LIKE qcr_file.qcr01,      #請購單號
    g_qcp           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    qcp02   LIKE qcp_file.qcp02,
                    qcp06   LIKE qcp_file.qcp06,
                    qce03   LIKE qce_file.qce03,
                    qcp03   LIKE qcp_file.qcp03,
                    qcp04   LIKE qcp_file.qcp04, 
                    qcp05   LIKE qcp_file.qcp05,
                    #FUN-840068 --start---
                    qcpud01 LIKE qcp_file.qcpud01,
                    qcpud02 LIKE qcp_file.qcpud02,
                    qcpud03 LIKE qcp_file.qcpud03,
                    qcpud04 LIKE qcp_file.qcpud04,
                    qcpud05 LIKE qcp_file.qcpud05,
                    qcpud06 LIKE qcp_file.qcpud06,
                    qcpud07 LIKE qcp_file.qcpud07,
                    qcpud08 LIKE qcp_file.qcpud08,
                    qcpud09 LIKE qcp_file.qcpud09,
                    qcpud10 LIKE qcp_file.qcpud10,
                    qcpud11 LIKE qcp_file.qcpud11,
                    qcpud12 LIKE qcp_file.qcpud12,
                    qcpud13 LIKE qcp_file.qcpud13,
                    qcpud14 LIKE qcp_file.qcpud14,
                    qcpud15 LIKE qcp_file.qcpud15
                    #FUN-840068 --end--
                    END RECORD,
    g_qcp_t         RECORD                    #程式變數 (舊值)
                    qcp02   LIKE qcp_file.qcp02,
                    qcp06   LIKE qcp_file.qcp06,
                    qce03   LIKE qce_file.qce03,
                    qcp03   LIKE qcp_file.qcp03,
                    qcp04   LIKE qcp_file.qcp04, 
                    qcp05   LIKE qcp_file.qcp05,
                    #FUN-840068 --start---
                    qcpud01 LIKE qcp_file.qcpud01,
                    qcpud02 LIKE qcp_file.qcpud02,
                    qcpud03 LIKE qcp_file.qcpud03,
                    qcpud04 LIKE qcp_file.qcpud04,
                    qcpud05 LIKE qcp_file.qcpud05,
                    qcpud06 LIKE qcp_file.qcpud06,
                    qcpud07 LIKE qcp_file.qcpud07,
                    qcpud08 LIKE qcp_file.qcpud08,
                    qcpud09 LIKE qcp_file.qcpud09,
                    qcpud10 LIKE qcp_file.qcpud10,
                    qcpud11 LIKE qcp_file.qcpud11,
                    qcpud12 LIKE qcp_file.qcpud12,
                    qcpud13 LIKE qcp_file.qcpud13,
                    qcpud14 LIKE qcp_file.qcpud14,
                    qcpud15 LIKE qcp_file.qcpud15
                    #FUN-840068 --end--
                    END RECORD,
    g_wc,g_sql          string,              #No.FUN-580092 HCN
    g_wc2               string,              #No.FUN-580092 HCN
    g_wc3               STRING,              #No.FUN-C30190 add
    g_argv1         LIKE type_file.chr1,     #資料性質             #No.FUN-680136 VARCHAR(1)
    g_argv2         LIKE qcr_file.qcr01,     #請購單號
    g_rec_b         LIKE type_file.num5,     #單身筆數             #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    g_t1            LIKE oay_file.oayslip    #fun-720041
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #FUN-4C0056    #No.FUN-680136 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5     #FUN-4C0056    #No.FUN-680136 SMALLINT
DEFINE   li_result       LIKE type_file.num5
DEFINE   l_qcr00         LIKE qcr_file.qcrconf   #FUN-BB0153 add
DEFINE   g_chr           LIKE type_file.chr1     #FUN-BB0153 add


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_argv1 =  ARG_VAL(1)              #資料性質
    LET g_argv2 =  ARG_VAL(2)              #請購單號
    LET g_qcr01_t = NULL
    
    LET g_forupd_sql = "SELECT * FROM qcr_file WHERE qcr01 = ? FOR UPDATE" #g_qcr_rowid
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t900_w WITH FORM "aqc/42f/aqct900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
      AND g_argv2 IS NOT NULL AND g_argv2 != ' '
    THEN CALL t900_q()
         CALL t900_b()
    ELSE
         CALL t900_menu()
    END IF
    CLOSE WINDOW t900_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION t900_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_qcp.clear()
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '
 THEN
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_qcr.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
          qcr01,qcr02,qcr13,qcr03,qcr04,qcr05,qcr06,qcr07,qcrconf,
          qcruser,qcrgrup,qcrmodu,qcrdate,
          #FUN-840068   ---start---
          qcrud01,qcrud02,qcrud03,qcrud04,qcrud05,
          qcrud06,qcrud07,qcrud08,qcrud09,qcrud10,
          qcrud11,qcrud12,qcrud13,qcrud14,qcrud15
          #FUN-840068    ----end----
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(qcr01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_qcr"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO qcr01
                  NEXT FIELD qcr01
          END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
       #No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
 ELSE DISPLAY BY NAME g_qcr.qcr01
      LET g_wc = " qcr01 ='",g_qcr.qcr01,"'"
 END IF
 IF INT_FLAG THEN RETURN END IF
 #資料權限的檢查
 #Begin:FUN-980030
 # IF g_priv2='4' THEN                           #只能使用自己的資料
 #     LET g_wc = g_wc clipped," AND qcruser = '",g_user,"'"
 # END IF
 # IF g_priv3='4' THEN                           #只能使用相同群的資料
 #     LET g_wc = g_wc clipped," AND qcrgrup MATCHES '",g_grup CLIPPED,"*'"
 # END IF
 
 # IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
 #     LET g_wc = g_wc clipped," AND qcrgrup IN ",cl_chk_tgrup_list()
 # END IF
 LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcruser', 'qcrgrup')
 #End:FUN-980030
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '
 THEN
   CONSTRUCT g_wc2 ON qcp02,qcp06,qcp04,qcp05          # 螢幕上取單身條件
                      #No.FUN-840068 --start--
                      ,qcpud01,qcpud02,qcpud03,qcpud04,qcpud05
                      ,qcpud06,qcpud07,qcpud08,qcpud09,qcpud10
                      ,qcpud11,qcpud12,qcpud13,qcpud14,qcpud15
                      #No.FUN-840068 ---end---
         FROM s_qcp[1].qcp02,s_qcp[1].qcp06,s_qcp[1].qcp04,s_qcp[1].qcp05
              #No.FUN-840068 --start--
              ,s_qcp[1].qcpud01,s_qcp[1].qcpud02,s_qcp[1].qcpud03
              ,s_qcp[1].qcpud04,s_qcp[1].qcpud05,s_qcp[1].qcpud06
              ,s_qcp[1].qcpud07,s_qcp[1].qcpud08,s_qcp[1].qcpud09
              ,s_qcp[1].qcpud10,s_qcp[1].qcpud11,s_qcp[1].qcpud12
              ,s_qcp[1].qcpud13,s_qcp[1].qcpud14,s_qcp[1].qcpud15
              #No.FUN-840068 ---end---
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
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
            ON ACTION qbe_save
	       CALL cl_qbe_save()
	#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN  RETURN END IF
       ELSE LET g_wc2 = " 1=1"
   END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT qcr01 FROM qcr_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY qcr01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  qcr01 ",
                   "  FROM qcr_file, qcp_file ",
                   " WHERE qcr01 = qcp01 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY qcr01"
    END IF
 
    PREPARE t900_prepare FROM g_sql
    DECLARE t900_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t900_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM qcr_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM qcr_file,qcp_file WHERE ",
                  "qcr01=qcp01 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t900_precount FROM g_sql
    DECLARE t900_count CURSOR FOR t900_precount
END FUNCTION
 
FUNCTION t900_menu()
 
   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t900_a()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                 CALL t900_u()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t900_q()
            END IF
         #FUN-BB0153---begin add
         WHEN "delete"         #刪除
            IF cl_chk_act_auth() THEN
               CALL t900_r()
            END IF
         WHEN "void"           #作廢
            IF cl_chk_act_auth() THEN
              #CALL t900_x()   #FUN-D20025
               CALL t900_x(1)
            END IF            
         #FUN-D20025--add--str---
         WHEN "undo_void"           #取消作廢
            IF cl_chk_act_auth() THEN
               CALL t900_x(2)
            END IF            
         #FUN-D20025--add--end---
         #FUN-BB0153---end add            
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t900_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t900_u()
            END IF
         WHEN "result"
            IF cl_chk_act_auth() AND g_qcr.qcrconf <> 'X' THEN #FUN-BB0153 add qcrconf
               CALL t900_result()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t900_out()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t900_y()    
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t900_z()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcp),'','')
            END IF
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_qcr.qcr01 IS NOT NULL THEN
                 LET g_doc.column1 = "qcr01"
                 LET g_doc.value1 = g_qcr.qcr01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t900_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_qcp.clear()
   INITIALIZE g_qcr.* TO NULL
   LET g_qcr01_t = NULL
   #預設值及將數值類變數清成零
   LET g_qcr_t.* = g_qcr.*
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_qcr.qcr02 = g_today
      LET g_qcr.qcruser = g_user
      LET g_qcr.qcroriu = g_user #FUN-980030
      LET g_qcr.qcrorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_qcr.qcrgrup = g_grup
      LET g_qcr.qcrdate = g_today
      LET g_qcr.qcrconf='N'      #MOD-BB0306 add
      CALL t900_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_qcr.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_qcr.qcr01 IS NULL  THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK     #No.MOD-710117 add
      CALL s_auto_assign_no("aqc",g_qcr.qcr01,g_qcr.qcr02,"1","qcr_file","qcr01","","","")
           RETURNING li_result,g_qcr.qcr01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_qcr.qcr01
      LET g_success='Y'
      LET g_qcr.qcrplant = g_plant #FUN-980007
      LET g_qcr.qcrlegal = g_legal #FUN-980007
      INSERT INTO qcr_file VALUES(g_qcr.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","qcr_file",g_qcr.qcr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
          CONTINUE WHILE
      ELSE
          SELECT qcr01 INTO g_qcr.qcr01 FROM qcr_file
           WHERE qcr01 = g_qcr.qcr01
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
 
      LET g_qcr01_t = g_qcr.qcr01        #保留舊值
      LET g_qcr_t.* = g_qcr.*
 
      CALL g_qcp.clear()
      LET g_rec_b = 0
      CALL t900_b()                      #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t900_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_qcr.qcr01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_qcr.* FROM qcr_file
    WHERE qcr01 = g_qcr.qcr01
 
   IF g_qcr.qcrconf = 'Y' THEN 
      RETURN
   END IF

   #FUN-BB0153---begin add  
   IF g_qcr.qcrconf = 'X' THEN
      CALL cl_err(' ','9024',0)
      RETURN
   END IF   
   #FUN-BB0153---end add
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_qcr01_t = g_qcr.qcr01
   LET g_qcr_t.* = g_qcr.*
 
   BEGIN WORK
 
   OPEN t900_cl USING g_qcr.qcr01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t900_cl INTO g_qcr.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcr.qcr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t900_show()
 
   WHILE TRUE
      LET g_qcr01_t = g_qcr.qcr01
      LET g_qcr.qcrmodu = g_user
      LET g_qcr.qcrdate = g_today
 
      CALL t900_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_qcr.* = g_qcr_t.*
         CALL t900_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE qcr_file SET qcr_file.* = g_qcr.*
       WHERE qcr01 = g_qcr01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","qcr_file",g_qcr01_t,'',SQLCA.sqlcode,"","",1)  #No.FUN-660115
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE t900_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t900_i(p_cmd)
   DEFINE l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入  #No.FUN-680104 VARCHAR(1)
          l_p             LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
          p_cmd           LIKE type_file.chr1,                #a:輸入 u:更改  #No.FUN-680104 VARCHAR(1)
          l_factor        LIKE qcs_file.qcs31,       #No.TQC-630089 add
          l_cnt           LIKE type_file.num5,   #FUN-5C0114  #No.FUN-680104 SMALLINT
          l_n             LIKE type_file.num5
   DEFINE l_gfe02         LIKE gfe_file.gfe02
 
   DISPLAY BY NAME g_qcr.qcr01,g_qcr.qcr02,g_qcr.qcr13,g_qcr.qcr03,
                   g_qcr.qcr04,g_qcr.qcr05,g_qcr.qcr06,g_qcr.qcr07,
                   g_qcr.qcr08,g_qcr.qcr09,g_qcr.qcr10,g_qcr.qcr11,
                   g_qcr.qcr12,
                   g_qcr.qcruser,g_qcr.qcrgrup,
                   g_qcr.qcrmodu,g_qcr.qcrdate,g_qcr.qcrconf       #MOD-BB0306 新增g_qcr.qcrconf
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
#  INPUT BY NAME g_qcr.qcr01,g_qcr.qcr02,g_qcr.qcr13,g_qcr.qcr03,g_qcr.qcr04,g_qcr.qcr05, g_qcr.qcroriu,g_qcr.qcrorig,  #FUN-AA0059 MARK
  #INPUT BY NAME g_qcr.qcr01,g_qcr.qcr02,g_qcr.qcr13,g_qcr.qcr03,g_qcr.qcr04,g_qcr.qcr05, g_qcr.qcrconf,                #FUN-AA0059 ADD  #MOD-B60128 mark
   INPUT BY NAME g_qcr.qcr01,g_qcr.qcr02,g_qcr.qcr13,g_qcr.qcr03,g_qcr.qcr04,g_qcr.qcr05,                               #MOD-B60128 add 
                 g_qcr.qcr06,g_qcr.qcr07,
                 #FUN-840068     ---start---
                 g_qcr.qcrud01,g_qcr.qcrud02,g_qcr.qcrud03,g_qcr.qcrud04,
                 g_qcr.qcrud05,g_qcr.qcrud06,g_qcr.qcrud07,g_qcr.qcrud08,
                 g_qcr.qcrud09,g_qcr.qcrud10,g_qcr.qcrud11,g_qcr.qcrud12,
                 g_qcr.qcrud13,g_qcr.qcrud14,g_qcr.qcrud15 
                 #FUN-840068     ----end----
                 WITHOUT DEFAULTS
 
      AFTER FIELD qcr01
          IF NOT cl_null(g_qcr.qcr01) THEN
             #CALL s_check_no("AQC",g_qcr.qcr01,"","1","","","")
              CALL s_check_no("AQC",g_qcr.qcr01,g_qcr_t.qcr01,"1","","","")  #FUN-B50026 mod
              RETURNING li_result,g_qcr.qcr01
              DISPLAY BY NAME g_qcr.qcr01
              IF (NOT li_result) THEN
                  LET g_qcr.qcr01=g_qcr_t.qcr01
                  NEXT FIELD qcr01
              END IF
              DISPLAY BY NAME g_qcr.qcr01
          END IF 
 
      AFTER FIELD qcr03
          IF NOT cl_null(g_qcr.qcr03) THEN
             CALL t900_gem(g_qcr.qcr03)
             IF NOT cl_null(g_errno) THEN
                LET g_qcr.qcr03 = g_qcr_t.qcr03
                CALL cl_err(g_qcr.qcr03,g_errno,0)
                DISPLAY BY NAME g_qcr.qcr03
                NEXT FIELD qcr03
             END IF
          ELSE
             DISPLAY '' TO FORMONLY.gem02
          END IF
          LET g_qcr.qcr03 = g_qcr.qcr03
 
      AFTER FIELD qcr04
          IF NOT cl_null(g_qcr.qcr04) THEN
             CALL t900_gen(g_qcr.qcr04)
             IF NOT cl_null(g_errno) THEN
                LET g_qcr.qcr04 = g_qcr_t.qcr04
                CALL cl_err(g_qcr.qcr04,g_errno,0)
                DISPLAY BY NAME g_qcr.qcr04
                NEXT FIELD qcr04
             END IF
          ELSE
             DISPLAY '' TO FORMONLY.gen02
          END IF
          LET g_qcr_t.qcr04=g_qcr.qcr04
 
      AFTER FIELD qcr05
          IF NOT cl_null(g_qcr.qcr05) THEN
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_qcr.qcr05,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_qcr.qcr05= g_qcr_t.qcr05
                NEXT FIELD qcr05
             END IF
#FUN-AA0059 ---------------------end-------------------------------

              SELECT COUNT(*) INTO l_n FROM ima_file
               WHERE ima01=g_qcr.qcr05
              IF l_n=0 THEN
                 CALL cl_err('','aim-806',0)
                 NEXT FIELD qcr05
              END IF
              IF (g_qcr.qcr05= g_qcr_t.qcr05 OR g_qcr_t.qcr05 IS NULL) THEN
                  CALL t900_ima(g_qcr.qcr05)
                  IF NOT cl_null(g_errno) THEN #NO:6808
                     CALL cl_err(g_qcr.qcr05,g_errno,0)
                     LET g_qcr.qcr05 = g_qcr_t.qcr05
                     DISPLAY BY NAME g_qcr.qcr05
                     NEXT FIELD qcr05
                  END IF
              ELSE
                  DISPLAY '' TO FORMONLY.ima02
              END IF
              LET g_qcr_t.qcr05=g_qcr.qcr05
          END IF

         ------#MOD-BB0306 start---------

      AFTER FIELD qcr06
          IF NOT cl_null(g_qcr.qcr06) AND g_qcr.qcr06 < 0 THEN
             CALL cl_err('','aqc-090',0)
             NEXT FIELD qcr06
          END IF

         ------#MOD-BB0306 end---------- 

      AFTER FIELD qcr07       
          IF NOT cl_null(g_qcr.qcr07) THEN
             SELECT gfe02 INTO l_gfe02 FROM gfe_file
              WHERE gfe01=g_qcr.qcr07
                AND gfeacti='Y'
             IF STATUS THEN
                CALL cl_err3("sel","gfe_file",g_qcr.qcr07,"",STATUS,"","gfe:",1)  #No.FUN-660129
                NEXT FIELD qcr07
             ELSE
                DISPLAY l_gfe02 TO FORMONLY.gfe02
             END IF
          END IF
 
      #FUN-840068     ---start---
      AFTER FIELD qcrud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD qcrud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840068     ----end----
 
      AFTER INPUT
         LET g_qcr.qcruser = s_get_data_owner("qcr_file") #FUN-C10039
         LET g_qcr.qcrgrup = s_get_data_group("qcr_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(qcr01) 
                LET g_t1=s_get_doc_no(g_qcr.qcr01)       #No.FUN-550052 
                CALL q_smy(FALSE,FALSE,g_t1,'AQC','1') RETURNING g_t1    #TQC-670008
                LET g_qcr.qcr01=g_t1
                DISPLAY BY NAME g_qcr.qcr01
                NEXT FIELD qcr01
            WHEN INFIELD(qcr03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_qcr.qcr03 #TQC-950129
               CALL cl_create_qry() RETURNING g_qcr.qcr03
               DISPLAY BY NAME g_qcr.qcr03
               NEXT FIELD qcr03
            WHEN INFIELD(qcr05)
#FUN-AA0059---------mod------------str----------------- 
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima"
#              LET g_qryparam.default1 = g_qcr.qcr05 #TQC-950129
#              CALL cl_create_qry() RETURNING g_qcr.qcr05
               CALL q_sel_ima(FALSE, "q_ima","",g_qcr.qcr05,"","","","","",'' ) 
                RETURNING g_qcr.qcr05  
#FUN-AA0059---------mod------------end-----------------               
               DISPLAY BY NAME g_qcr.qcr05
               NEXT FIELD qcr05
            WHEN INFIELD(qcr04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_qcr.qcr04 #TQC-950129
               CALL cl_create_qry() RETURNING g_qcr.qcr04
               DISPLAY BY NAME g_qcr.qcr04
               NEXT FIELD qcr04
            WHEN INFIELD(qcr07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_qcr.qcr07 #TQC-950129
               CALL cl_create_qry() RETURNING g_qcr.qcr07
               DISPLAY BY NAME g_qcr.qcr07
               NEXT FIELD qcr07
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
#Query 查詢
FUNCTION t900_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_qcp.clear()
    CALL t900_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_qcr.qcr01 TO NULL
        RETURN
    END IF
    OPEN t900_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_qcr.qcr01 TO NULL
    ELSE
        CALL t900_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN t900_count
        FETCH t900_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t900_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數     #No.FUN-680136 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t900_cs INTO g_qcr.qcr01
        WHEN 'P' FETCH PREVIOUS t900_cs INTO g_qcr.qcr01
        WHEN 'F' FETCH FIRST    t900_cs INTO g_qcr.qcr01
        WHEN 'L' FETCH LAST     t900_cs INTO g_qcr.qcr01
        WHEN '/'
#FUN-4C0056 modify
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t900_cs INTO g_qcr.qcr01
            LET g_no_ask = FALSE
    END CASE
##
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_qcr.qcr01,SQLCA.sqlcode,0)
        INITIALIZE g_qcr.qcr01 TO NULL        #No.FUN-6A0162 
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump    #FUN-4C0056
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_qcr.* FROM qcr_file WHERE qcr01 = g_qcr.qcr01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","qcr_file",g_qcr.qcr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        INITIALIZE g_qcr.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_qcr.qcruser      #FUN-4C0056 add
    LET g_data_group = g_qcr.qcrgrup      #FUN-4C0056 add
    LET g_data_plant = g_qcr.qcrplant #FUN-980030
    CALL t900_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t900_show()
DEFINE l_gfe02         LIKE gfe_file.gfe02
DEFINE l_pmc03         LIKE pmc_file.pmc03
DEFINE l_gem02         LIKE gem_file.gem02
 
    LET g_qcr_t.* = g_qcr.*                #保存單頭舊值
    LET g_qcr.qcrmodu=g_user
    DISPLAY '' TO FORMONLY.gem02
    DISPLAY '' TO FORMONLY.gen02
    DISPLAY '' TO FORMONLY.pmc03   
    DISPLAY '' TO FORMONLY.ima02
 
   #DISPLAY BY NAME g_qcr.qcroriu,g_qcr.qcrorig,                              # 顯示單頭值   #MOD-B60128 mark
    DISPLAY BY NAME                                                           # 顯示單頭值   #MOD-B60128 add
        g_qcr.qcr01,g_qcr.qcr02,g_qcr.qcr13,g_qcr.qcr03,
        g_qcr.qcr04,g_qcr.qcr05,g_qcr.qcr06,g_qcr.qcr07,
        g_qcr.qcr08,g_qcr.qcr09,g_qcr.qcr10,g_qcr.qcr11,
        g_qcr.qcr12,
        g_qcr.qcrconf
        DISPLAY BY NAME g_qcr.qcruser
        DISPLAY BY NAME g_qcr.qcrgrup
        DISPLAY BY NAME g_qcr.qcrmodu
        DISPLAY BY NAME g_qcr.qcrdate,
                        #FUN-840068     ---start---
                        g_qcr.qcrud01,g_qcr.qcrud02,g_qcr.qcrud03,g_qcr.qcrud04,
                        g_qcr.qcrud05,g_qcr.qcrud06,g_qcr.qcrud07,g_qcr.qcrud08,
                        g_qcr.qcrud09,g_qcr.qcrud10,g_qcr.qcrud11,g_qcr.qcrud12,
                        g_qcr.qcrud13,g_qcr.qcrud14,g_qcr.qcrud15 
                        #FUN-840068     ----end----
    IF g_qcr.qcrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF #FUN-BB0153
    CALL cl_set_field_pic(g_qcr.qcrconf,"","","",g_chr,"") #FUN-BB0153 
    IF NOT cl_null(g_qcr.qcr03) THEN
        CALL t900_gem(g_qcr.qcr03)
    END IF
    IF NOT cl_null(g_qcr.qcr04) THEN
        CALL t900_gen(g_qcr.qcr04)
    END IF
    IF NOT cl_null(g_qcr.qcr05) THEN
        CALL t900_ima(g_qcr.qcr05)
    END IF
    SELECT gfe02 INTO l_gfe02 FROM gfe_file
     WHERE gfe01=g_qcr.qcr07
       AND gfeacti='Y'
    DISPLAY l_gfe02 TO FORMONLY.gfe02
    IF g_qcr.qcr08 = '1' THEN
        SELECT pmc03 INTO l_pmc03
          FROM pmc_file
         WHERE pmc01 = g_qcr.qcr09
        DISPLAY l_pmc03 TO FORMONLY.pmc03
    ELSE 
        SELECT gem02 INTO l_gem02
          FROM gem_file
         WHERE gem01 = g_qcr.qcr09
        DISPLAY l_gem02 TO FORMONLY.pmc03
    END IF
    CALL t900_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
#單身
FUNCTION t900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT   #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用      #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否        #No.FUN-680136 SMALLINT
DEFINE l_gfe02      LIKE gfe_file.gfe02
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_qcr.qcr01 IS NULL  THEN
        RETURN
    END IF
    IF g_qcr.qcrconf <> 'N' THEN CALL cl_err('','9022',0) RETURN END IF #FUN-BB0153 add
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql =
       "SELECT qcp02,qcp06,'',qcp03,qcp04,qcp05, ",    #No:MOD-960239 modify
       #No.FUN-840068 --start--
       "       qcpud01,qcpud02,qcpud03,qcpud04,qcpud05,",
       "       qcpud06,qcpud07,qcpud08,qcpud09,qcpud10,",
       "       qcpud11,qcpud12,qcpud13,qcpud14,qcpud15 ", 
       #No.FUN-840068 ---end---
       "FROM qcp_file ",
       " WHERE qcp01 = ?  ",
       "  AND qcp02 = ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qcp WITHOUT DEFAULTS FROM s_qcp.*
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
                LET g_qcp_t.* = g_qcp[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN t900_bcl USING g_qcr.qcr01,g_qcp_t.qcp02
                IF STATUS THEN
                    CALL cl_err("OPEN t900_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t900_bcl INTO g_qcp[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_qcp_t.qcp04,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        SELECT qce03 INTO g_qcp[l_ac].qce03 FROM qce_file
                         WHERE qce01= g_qcp[l_ac].qcp06
                        LET g_qcp_t.*=g_qcp[l_ac].*
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO qcp_file(qcp01,qcp02,qcp03,qcp04,qcp05,qcp06,
                                 #FUN-840068 --start--
                                 qcpud01,qcpud02,qcpud03,qcpud04,qcpud05,qcpud06,
                                 qcpud07,qcpud08,qcpud09,qcpud10,qcpud11,qcpud12,
                                 qcpud13,qcpud14,qcpud15,
                                 qcpplant,qcplegal)  #FUN-980007
                                 #FUN-840068 --end--
                          VALUES(g_qcr.qcr01,g_qcp[l_ac].qcp02,g_qcp[l_ac].qcp03,
                                 g_qcp[l_ac].qcp04,g_qcp[l_ac].qcp05,g_qcp[l_ac].qcp06,
                                 #FUN-840068 --start--
                                 g_qcp[l_ac].qcpud01,g_qcp[l_ac].qcpud02,
                                 g_qcp[l_ac].qcpud03,g_qcp[l_ac].qcpud04,
                                 g_qcp[l_ac].qcpud05,g_qcp[l_ac].qcpud06,
                                 g_qcp[l_ac].qcpud07,g_qcp[l_ac].qcpud08,
                                 g_qcp[l_ac].qcpud09,g_qcp[l_ac].qcpud10,
                                 g_qcp[l_ac].qcpud11,g_qcp[l_ac].qcpud12,
                                 g_qcp[l_ac].qcpud13,g_qcp[l_ac].qcpud14,
                                 g_qcp[l_ac].qcpud15,
                                 g_plant,    g_legal) #FUN-980007
                                 #FUN-840068 --end--
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","qcp_file",g_qcr.qcr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qcp[l_ac].* TO NULL      #900423
            LET g_qcp_t.* = g_qcp[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD qcp02
 
        BEFORE FIELD qcp02                        # dgeeault 序號
            IF g_qcp[l_ac].qcp02 IS NULL or g_qcp[l_ac].qcp02 = 0 THEN
                SELECT max(qcp02)+1 INTO g_qcp[l_ac].qcp02 FROM qcp_file
                    WHERE qcp01 = g_qcr.qcr01 
                IF g_qcp[l_ac].qcp02 IS NULL THEN
                    LET g_qcp[l_ac].qcp02 = 1
                END IF
            END IF
 
        AFTER FIELD qcp02                        #check 序號是否重複
            IF g_qcp[l_ac].qcp02 IS NOT NULL AND
               (g_qcp[l_ac].qcp02 != g_qcp_t.qcp02 OR
                g_qcp_t.qcp02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM qcp_file
                 WHERE qcp01 = g_qcr.qcr01 AND qcp02 = g_qcp[l_ac].qcp02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qcp[l_ac].qcp02 = g_qcp_t.qcp02
                   NEXT FIELD qcp02
                END IF
            END IF

         ------#MOD-BB0306 start---------
      
      AFTER FIELD qcp04
          IF NOT cl_null(g_qcp[l_ac].qcp04) AND g_qcp[l_ac].qcp04 < 0 THEN
             CALL cl_err('','aqc-090',0)
             NEXT FIELD qcp04
          END IF

         ------#MOD-BB0306 end----------
 
        AFTER FIELD qcp06
            IF NOT cl_null(g_qcp[l_ac].qcp06) THEN
               #SELECT sgb05 INTO g_qcp[l_ac].sgb05 FROM sgb_file
               # WHERE sgb01= g_qcp[l_ac].qcp06
               SELECT qce03 INTO g_qcp[l_ac].qce03 FROM qce_file
                WHERE qce01= g_qcp[l_ac].qcp06
               IF STATUS THEN
                  CALL cl_err3("sel","qce_file",g_qcp[l_ac].qcp06,"","aoo-018","","",1)  #No.FUN-660128
                  LET g_qcp[l_ac].qcp06 = ''
                  NEXT FIELD qcp06
               ELSE
                  DISPLAY BY NAME g_qcp[l_ac].qce03
               END IF
            END IF
           
        #No.FUN-840068 --start--
        AFTER FIELD qcpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD qcpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_qcp_t.qcp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qcp_file
                 WHERE qcp01 = g_qcr.qcr01 AND qcp02 = g_qcp_t.qcp02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","qcp_file",g_qcr.qcr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qcp[l_ac].* = g_qcp_t.*
               CLOSE t900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qcp[l_ac].qcp03,-263,1)
               LET g_qcp[l_ac].* = g_qcp_t.*
            ELSE
                UPDATE qcp_file SET
                       qcp02 = g_qcp[l_ac].qcp02,
                       qcp03 = g_qcp[l_ac].qcp03,
                       qcp04 = g_qcp[l_ac].qcp04,
                       qcp05 = g_qcp[l_ac].qcp05,
                       qcp06 = g_qcp[l_ac].qcp06,
                       #FUN-840068 --start--
                       qcpud01 = g_qcp[l_ac].qcpud01,
                       qcpud02 = g_qcp[l_ac].qcpud02,
                       qcpud03 = g_qcp[l_ac].qcpud03,
                       qcpud04 = g_qcp[l_ac].qcpud04,
                       qcpud05 = g_qcp[l_ac].qcpud05,
                       qcpud06 = g_qcp[l_ac].qcpud06,
                       qcpud07 = g_qcp[l_ac].qcpud07,
                       qcpud08 = g_qcp[l_ac].qcpud08,
                       qcpud09 = g_qcp[l_ac].qcpud09,
                       qcpud10 = g_qcp[l_ac].qcpud10,
                       qcpud11 = g_qcp[l_ac].qcpud11,
                       qcpud12 = g_qcp[l_ac].qcpud12,
                       qcpud13 = g_qcp[l_ac].qcpud13,
                       qcpud14 = g_qcp[l_ac].qcpud14,
                       qcpud15 = g_qcp[l_ac].qcpud15
                       #FUN-840068 --end-- 
                 WHERE qcp01 = g_qcr.qcr01
                   AND qcp02 = g_qcp_t.qcp02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","qcp_file",g_qcr.qcr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_qcp[l_ac].* = g_qcp_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcp[l_ac].* = g_qcp_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qcp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE t900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034
            CLOSE t900_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qcp02) AND l_ac > 1 THEN
                LET g_qcp[l_ac].* = g_qcp[l_ac-1].*
                DISPLAY g_qcp[l_ac].* TO s_qcp[l_ac].*
                NEXT FIELD qcp02
            END IF
 
        ON ACTION controlp
            CASE WHEN INFIELD(qcp06)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_qce"
                      LET g_qryparam.default1 = g_qcp[l_ac].qcp06
                      CALL cl_create_qry() RETURNING g_qcp[l_ac].qcp06
                      DISPLAY BY NAME g_qcp[l_ac].qcp06
                      NEXT FIELD qcp06
             END CASE
 
        ON ACTION CONTROLZ
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        END INPUT
 
    CLOSE t900_bcl
    COMMIT WORK
    CALL t900_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t900_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_qcr.qcr01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM qcr_file ",
                  "  WHERE qcr01 LIKE '",l_slip,"%' ",
                  "    AND qcr01 > '",g_qcr.qcr01,"'"
      PREPARE t900_pb1 FROM l_sql 
      EXECUTE t900_pb1 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t900_x()    #FUN-D20025
         CALL t900_x(1)   #FUN-D20025
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM qcr_file WHERE qcr01 = g_qcr.qcr01
         INITIALIZE g_qcr.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t900_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql =
        "SELECT qcp02,qcp06,'',qcp03,qcp04,qcp05, ",
        #No.FUN-840068 --start--
        "       qcpud01,qcpud02,qcpud03,qcpud04,qcpud05,",
        "       qcpud06,qcpud07,qcpud08,qcpud09,qcpud10,",
        "       qcpud11,qcpud12,qcpud13,qcpud14,qcpud15", 
        #No.FUN-840068 ---end---
        " FROM qcp_file",
        " WHERE qcp01 ='",g_qcr.qcr01,"'",  #單頭-1
        " AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE t900_pb FROM g_sql
    DECLARE qcp_cs                       #CURSOR
        CURSOR FOR t900_pb
 
    CALL g_qcp.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH qcp_cs INTO g_qcp[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT qce03 INTO g_qcp[g_cnt].qce03 FROM qce_file
         WHERE qce01= g_qcp[g_cnt].qcp06
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_qcp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcp TO s_qcp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#FUN-BB0153---begin add         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY         
      #FUN-D20025--add--str-- 
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY         
      #FUN-D20025--add--end-- 
#FUN-BB0153---end add         
      ON ACTION first
         CALL t900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL t900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL t900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL t900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
         IF g_qcr.qcrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF #FUN-BB0153
         CALL cl_set_field_pic(g_qcr.qcrconf,"","","",g_chr,"") #FUN-BB0153    
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION result
         LET g_action_choice="result"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
  
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t900_copy()
DEFINE
    l_newno1         LIKE qcr_file.qcr01,
    l_newdate        LIKE qcr_file.qcr02,   #TQC-980138
    l_oldno          LIKE qcr_file.qcr01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_qcr.qcr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    #INPUT l_newno1 FROM qcr01   #TQC-980138
    INPUT l_newno1,l_newdate FROM qcr01,qcr02   #TQC-980138
#No.FUN-550060 --start--
       BEFORE INPUT
         CALL cl_set_docno_format("qcr01")
#No.FUN-550060 ---end---
 
        #-----TQC-980138---------
        #AFTER FIELD qcr01
        #    IF l_newno1 IS NULL THEN
        #        NEXT FIELD qcr01
        #    ELSE
        #       SELECT qcr01 FROM qcr_file WHERE qcr01 = l_newno1
        #         IF SQLCA.sqlcode THEN
        #            CALL cl_err3("sel","qcr_file",l_newno1,"","mfg3052","","",1)  #No.FUN-660129
        #            NEXT FIELD qcr01
        #         END IF
        #    END IF
        #    SELECT count(*) INTO g_cnt FROM qcp_file
        #        WHERE qcp01=l_newno1
        #    IF g_cnt > 0 THEN
        #        LET g_msg = l_newno1 CLIPPED
        #        CALL cl_err(g_msg,-239,0)
        #        NEXT FIELD qcr01
        #    END IF
        AFTER FIELD qcr01
           CALL s_check_no("AQC",l_newno1,"","1","","","")
           RETURNING li_result,l_newno1
           DISPLAY l_newno1 TO qcr01
           IF (NOT li_result) THEN
               NEXT FIELD qcr01
           END IF
        AFTER FIELD qcr02
           IF cl_null(l_newdate) THEN NEXT FIELD qcr02 END IF
           BEGIN WORK
           CALL s_auto_assign_no("aqc",l_newno1,l_newdate,"1","qcr_file","qcr01","","","")
             RETURNING li_result,l_newno1
           IF (NOT li_result) THEN
              NEXT FIELD qcr01
           END IF
           DISPLAY l_newno1 TO cqr01
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(qcr01) 
                LET g_t1=s_get_doc_no(l_newno1)       
                CALL q_smy(FALSE,FALSE,g_t1,'AQC','1') RETURNING g_t1   
                LET l_newno1=g_t1
                DISPLAY l_newno1 TO qcr01
                NEXT FIELD qcr01
         END CASE
        #-----END TQC-980138-----
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
        DISPLAY BY NAME g_qcr.qcr01
        ROLLBACK WORK   #TQC-980138
        RETURN
    END IF
 
    #-----TQC-980138---------
    DROP TABLE y
    SELECT * FROM qcr_file
        WHERE qcr01 = g_qcr.qcr01
        INTO TEMP y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","y",'',"",SQLCA.sqlcode,"","",1) 
        ROLLBACK WORK   
        RETURN
    END IF
    UPDATE y 
        SET qcr01 = l_newno1,
            qcr02 = l_newdate,
            qcrconf = 'N',
            qcruser = g_user,   
            qcrgrup = g_grup,   
            qcrmodu = NULL,     
            qcrdate = g_today   
    INSERT INTO qcr_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","qcr_file",'',"",SQLCA.sqlcode,"","",1) 
        ROLLBACK WORK   
        RETURN
    END IF
    #-----END TQC-980138-----
 
    DROP TABLE x
    SELECT * FROM qcp_file         #單身複製
        WHERE qcp01=g_qcr.qcr01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",'',"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK   #TQC-980138  
        RETURN
    END IF
    UPDATE x
        SET qcp01=l_newno1
    INSERT INTO qcp_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","qcp_file",'',"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        ROLLBACK WORK   #TQC-980138  
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
    COMMIT WORK   #TQC-980138
 
    LET l_oldno = g_qcr.qcr01
    LET g_qcr.qcr01 = l_newno1
    CALL t900_b()
    #LET g_qcr.qcr01 = l_oldno  #FUN-C80046
    #CALL t900_show()           #FUN-C80046
    DISPLAY BY NAME g_qcr.qcr01
END FUNCTION
 
FUNCTION t900_result()
DEFINE l_pmc03 LIKE pmc_file.pmc03
DEFINE l_gem02 LIKE gem_file.gem02
 
   DISPLAY BY NAME g_qcr.qcr01,g_qcr.qcr02,g_qcr.qcr13,g_qcr.qcr03,
                   g_qcr.qcr04,g_qcr.qcr05,g_qcr.qcr06,g_qcr.qcr07,
                   g_qcr.qcr08,g_qcr.qcr09,g_qcr.qcr10,g_qcr.qcr11,
                   g_qcr.qcr12,
                   g_qcr.qcruser,g_qcr.qcrgrup,
                   g_qcr.qcrmodu,g_qcr.qcrdate
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT BY NAME g_qcr.qcr08,g_qcr.qcr09,g_qcr.qcr10,g_qcr.qcr11,g_qcr.qcr12
 
      WITHOUT DEFAULTS
 
      AFTER FIELD qcr09
          IF NOT cl_null(g_qcr.qcr09) THEN
             IF g_qcr.qcr08 = '1' THEN
                 CALL t900_pmc(g_qcr.qcr09)
             ELSE 
                 CALL t900_gem(g_qcr.qcr09)
             END IF
             IF NOT cl_null(g_errno) THEN
                LET g_qcr.qcr09 = g_qcr_t.qcr09
                CALL cl_err(g_qcr.qcr09,g_errno,0)
                DISPLAY BY NAME g_qcr.qcr09
                NEXT FIELD qcr09
             ELSE
                 IF g_qcr.qcr08 = '1' THEN
                     SELECT pmc03 INTO l_pmc03
                       FROM pmc_file
                      WHERE pmc01 = g_qcr.qcr09
                     DISPLAY l_pmc03 TO FORMONLY.pmc03
                 ELSE 
                     SELECT gem02 INTO l_gem02
                       FROM gem_file
                      WHERE gem01 = g_qcr.qcr09
                     DISPLAY l_gem02 TO FORMONLY.pmc03
                 END IF
             END IF
          ELSE
             DISPLAY '' TO FORMONLY.pmc03
          END IF
          LET g_qcr.qcr09 = g_qcr.qcr09
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(qcr09)
               CALL cl_init_qry_var()
               IF g_qcr.qcr08 = '1' THEN
                   LET g_qryparam.form = "q_pmc"
               ELSE
                   LET g_qryparam.form = "q_gem"
               END IF
               LET g_qryparam.default1 = g_qcr.qcr09 #No.TQC-950129
               CALL cl_create_qry() RETURNING g_qcr.qcr09
               DISPLAY BY NAME g_qcr.qcr09
               NEXT FIELD qcr09
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   END INPUT
 
   UPDATE qcr_file SET 
                   qcr08 = g_qcr.qcr08,
                   qcr09 = g_qcr.qcr09,
                   qcr10 = g_qcr.qcr10,
                   qcr11 = g_qcr.qcr11,
                   qcr12 = g_qcr.qcr12
    WHERE qcr01 = g_qcr.qcr01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","qcr_file",g_qcr.qcr01,'',SQLCA.sqlcode,"","",1)
    END IF
                 
END FUNCTION
 
FUNCTION t900_gem(p_gem01)
  DEFINE p_gem01   LIKE gem_file.gem01,
         p_dbs     LIKE type_file.chr21,   #No.FUN-680136 VARCHAR(21)
         l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_gemacti LIKE gem_file.gemacti,
         l_gem02   LIKE gem_file.gem02
 
  LET g_errno=' '
  SELECT gem02,gemacti 
    INTO l_gem02,l_gemacti
    FROM gem_file
   WHERE gem01 = p_gem01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4001'
                                 LET l_gemacti = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN 
      DISPLAY l_gem02 TO gem02 
  END IF
END FUNCTION
 
FUNCTION t900_gen(p_gen01)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       p_gen01    LIKE gen_file.gen01,
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = p_gen01
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno)
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION t900_pmc(p_pmc01)  #供應廠商
 DEFINE p_code    LIKE pmc_file.pmc01,
        p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
        p_pmc01   LIKE pmc_file.pmc01,
        l_pmc03   LIKE pmc_file.pmc03,
        l_pmc30   LIKE pmc_file.pmc30,
        l_pmcacti LIKE pmc_file.pmcacti
 
     LET g_errno = ' '
     SELECT pmc03,pmc30,pmcacti 
       INTO l_pmc03,l_pmc30,l_pmcacti
       FROM pmc_file
      WHERE pmc01 = p_pmc01
     CASE
        WHEN SQLCA.SQLCODE = 100
             LET g_errno = 'mfg3014'
             LET l_pmc03 = NULL
        WHEN l_pmcacti='N'
           LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'       
           LET g_errno = '9038'         #No.FUN-690024
        WHEN l_pmc30  ='2'
           LET g_errno = 'mfg3227'      #付款商
        OTHERWISE
           LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) THEN
        DISPLAY l_pmc03 TO FORMONLY.pmc03
     END IF
END FUNCTION
 
FUNCTION t900_ima(p_ima01)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           p_ima01    LIKE ima_file.ima01,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01= p_ima01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) THEN 
        DISPLAY l_ima02 TO ima02 
    END IF
 
END FUNCTION
 
FUNCTION t900_y()
DEFINE l_flag  LIKE type_file.chr1 
DEFINE l_cnt   LIKE type_file.num5   
 
  IF cl_null(g_qcr.qcr01) THEN
     CALL cl_err('','-400',1)
     LET g_success = 'N'
     RETURN
  END IF
#CHI-C30107 ------------- add ------------- begin
  IF g_qcr.qcrconf = 'Y' THEN RETURN END IF
  IF g_qcr.qcrconf = 'X' THEN
     LET g_success = 'N'
     CALL cl_err('','9024',0) #此筆資料已作廢
     RETURN
  END IF
  IF NOT cl_confirm('aim-301') THEN RETURN END IF 
  SELECT * INTO g_qcr.* FROM qcr_file WHERE qcr01 = g_qcr.qcr01
#CHI-C30107 ------------- add ------------- end
  IF g_qcr.qcrconf = 'Y' THEN RETURN END IF
  IF cl_null(g_qcr.qcr01) THEN
     CALL cl_err('','-400',1) 
     LET g_success = 'N'  
     RETURN
  END IF
 
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt
    FROM qcp_file
   WHERE qcp01=g_qcr.qcr01
  #FUN-BB0153--begin add
  IF g_qcr.qcrconf = 'X' THEN
     LET g_success = 'N'
     CALL cl_err('','9024',0) #此筆資料已作廢
     RETURN
  END IF
  #FUN-BB0153--end add     
  IF l_cnt=0 OR l_cnt IS NULL THEN
     CALL cl_err('','mfg-009',1) 
     LET g_success = 'N'  
     RETURN
  END IF
 
# IF NOT cl_confirm('aim-301') THEN RETURN END IF    #是否確定執行取消確認(Y/N) #FUN-BB0153 302-->301 #CHI-C30107 mark
  BEGIN WORK LET g_success = 'Y'
 
  OPEN t900_cl USING g_qcr.qcr01
  IF STATUS THEN
     CALL cl_err("OPEN t900_cl:", STATUS, 1)
     CLOSE t900_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t900_cl INTO g_qcr.*               # 對DB鎖定
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_qcr.qcr01,SQLCA.sqlcode,1)
     ROLLBACK WORK
     RETURN
  END IF
  UPDATE qcr_file SET qcrconf='Y'
   WHERE qcr01=g_qcr.qcr01
  IF STATUS THEN
     CALL cl_err3("upd","qcr_file",g_qcr.qcr01,"",STATUS,"","",1) 
     LET g_success = 'N' RETURN 
  END IF
 #DISPLAY BY NAME g_qcr.qcrconf     #MOD-B60128 mark
  CLOSE t900_cl
  COMMIT WORK
  SELECT * INTO g_qcr.* FROM qcr_file
    WHERE qcr01 = g_qcr.qcr01
  DISPLAY BY NAME g_qcr.qcrconf      #MOD-B60128 add
  #CALL t900_show()
  IF g_qcr.qcrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF #FUN-BB0153
  CALL cl_set_field_pic(g_qcr.qcrconf,"","","",g_chr,"") #FUN-BB0153 
END FUNCTION
 
FUNCTION t900_z()
 
  IF g_qcr.qcrconf != 'Y' THEN
      RETURN
  END IF
  IF NOT cl_confirm('aim-302') THEN RETURN END IF    #是否確定執行取消確認(Y/N)
  BEGIN WORK
  OPEN t900_cl USING g_qcr.qcr01
  IF STATUS THEN
     CALL cl_err("OPEN t900_cl:", STATUS, 1)
     CLOSE t900_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t900_cl INTO g_qcr.*               # 對DB鎖定
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_qcr.qcr01,SQLCA.sqlcode,1)
     ROLLBACK WORK
     RETURN
  END IF
  UPDATE qcr_file SET qcrconf='N'
   WHERE qcr01=g_qcr.qcr01
  IF STATUS THEN
     CALL cl_err3("upd","qcr_file",g_qcr.qcr01,"",STATUS,"","",1) 
     LET g_success = 'N' RETURN 
  END IF
 #DISPLAY BY NAME g_qcr.qcrconf           #MOD-B60128 mark
  CLOSE t900_cl
  COMMIT WORK
  SELECT * INTO g_qcr.* FROM qcr_file
    WHERE qcr01 = g_qcr.qcr01
  DISPLAY BY NAME g_qcr.qcrconf           #MOD-B60128 add
  CALL t900_show()
  IF g_qcr.qcrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF #FUN-BB0153
  CALL cl_set_field_pic(g_qcr.qcrconf,"","","",g_chr,"") #FUN-BB0153 
END FUNCTION
 
FUNCTION t900_out()
DEFINE
    l_i             LIKE type_file.num5,           #No.FUN-680136 SMALLINT
    sr              RECORD 
                    qcr01   LIKE qcr_file.qcr01,
                    qcr02   LIKE qcr_file.qcr02, 
                    qcr03   LIKE qcr_file.qcr03,
                    gem02   LIKE gem_file.gem02,
                    qcr04   LIKE qcr_file.qcr04,
                    
                    gen02   LIKE gen_file.gen02, 
                    qcr05   LIKE qcr_file.qcr05,
                    qcr06   LIKE qcr_file.qcr06,
                    qcr07   LIKE qcr_file.qcr07,
                    ima02   LIKE ima_file.ima02,
                    
                    qcr08   LIKE qcr_file.qcr08,
                    qcr09   LIKE qcr_file.qcr09,
                    qcr10   LIKE qcr_file.qcr10,
                    qcr11   LIKE qcr_file.qcr11,
                    qcr12   LIKE qcr_file.qcr12,
                    
                    qcp02   LIKE qcp_file.qcp02,
                    qcp03   LIKE qcp_file.qcp03,
                    qcp04   LIKE qcp_file.qcp04,
                    qcp05   LIKE qcp_file.qcp05,
                    qcp06   LIKE qcp_file.qcp06,
                    
                    qce03   LIKE qce_file.qce03
                    END RECORD,
    l_name          LIKE type_file.chr20,          #External(Disk) file name   #No.FUN-680136 VARCHAR(20)
    l_za05          LIKE type_file.chr1000         #No.FUN-680136 VARCHAR(40)
    #FUN-C30190--begin---
    DEFINE l_table    STRING
    DEFINE l_str      STRING

   LET g_sql = "qcr01.qcr_file.qcr01,",
               "qcr02.qcr_file.qcr02,",
               "qcr03.qcr_file.qcr03,",
               "gem02.gem_file.gem02,",
               "qcr04.qcr_file.qcr04,",
               
               "gen02.gen_file.gen02,",
               "qcr05.qcr_file.qcr05,",
               "qcr06.qcr_file.qcr06,",
               "qcr07.qcr_file.qcr07,",
               "ima02.ima_file.ima02,",

               "qcr08.qcr_file.qcr08,",
               "qcr09.qcr_file.qcr09,",
               "qcr10.qcr_file.qcr10,",
               "qcr11.qcr_file.qcr11,",
               "qcr12.qcr_file.qcr12,",
               
               "qcp02.qcp_file.qcp02,",
               "qcp03.qcp_file.qcp03,",
               "qcp04.qcp_file.qcp04,",
               "qcp05.qcp_file.qcp05,",
               "qcp06.qcp_file.qcp06,",

               "qce03.qce_file.qce03"
               
    LET l_table = cl_prt_temptable('aqct900',g_sql) CLIPPED
    IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
    END IF
    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "      VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
    END IF

    CALL cl_del_data(l_table)
    #FUN-C30190--end---
    
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    #CALL cl_outnam('aqct900') RETURNING l_name   #FUN-C30190 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
    LET g_sql="SELECT qcr01,qcr02,qcr03,'',qcr04,'',qcr05,qcr06,qcr07,'',",
              "       qcr08,qcr09,qcr10,qcr11,qcr12,",
              "       qcp02,qcp03,qcp04,qcp05,qcp06,'' ",
              "  FROM qcr_file,qcp_file ",                    #FUN-C30190 modify
              " WHERE qcr01 = '",g_qcr.qcr01,"'",
              "   AND qcr01 = qcp01"                          #FUN-C30190 add
 
    PREPARE t900_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t900_curo                         # CURSOR
        CURSOR FOR t900_p1
 
    #START REPORT t900_rep TO l_name   #FUN-C30190 mark
 
    FOREACH t900_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129
            EXIT FOREACH
        END IF
        SELECT gem02 INTO sr.gem02  
          FROM gem_file
         WHERE gem01 = sr.qcr03
        SELECT gen02 INTO sr.gen02
          FROM gen_file
         WHERE gen01 = sr.qcr04
        SELECT ima02 INTO sr.ima02
          FROM ima_file
         WHERE ima01 = sr.qcr05
        SELECT qce03 INTO sr.qce03
          FROM qce_file
         WHERE qce01= sr.qcr06
        SELECT qce03 INTO sr.qce03 FROM qce_file
         WHERE qce01= sr.qcp06
        #OUTPUT TO REPORT t900_rep(sr.*)   #FUN-C30190 mark
          #FUN-C30190--add--begin---
          EXECUTE insert_prep USING sr.qcr01,sr.qcr02,sr.qcr03,sr.gem02,sr.qcr04,
                                    sr.gen02,sr.qcr05,sr.qcr06,sr.qcr07,sr.ima02,
                                    sr.qcr08,sr.qcr09,sr.qcr10,sr.qcr11,sr.qcr12,
                                    sr.qcp02,sr.qcp03,sr.qcp04,sr.qcp05,sr.qcp06,
                                    sr.qce03
          #FUN-C30190--add--end---
    END FOREACH
 
    #FINISH REPORT t900_rep   #FUN-C30190 mark
 
    CLOSE t900_curo
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)   #FUN-C30190 mark
    #FUN-C30190--add--begin--
    CALL cl_wcchp(g_wc2,'rme01,rme02,rme03') RETURNING g_wc3
    LET l_str = g_wc3 CLIPPED   
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY qcr01,qcr02,qcp02"
    CALL cl_prt_cs3('aqct900','aqct900',g_sql,l_str)
    #FUN-C30190--add--end--
END FUNCTION

#FUN-C30190--mark--begin--
#REPORT t900_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#    sr              RECORD
#                    qcr01   LIKE qcr_file.qcr01,
#                    qcr02   LIKE qcr_file.qcr02,
#                    qcr03   LIKE qcr_file.qcr03,
#                    gem02   LIKE gem_file.gem02,
#                    qcr04   LIKE qcr_file.qcr04,
#                    gen02   LIKE gen_file.gen02, 
#                    qcr05   LIKE qcr_file.qcr05,
#                    qcr06   LIKE qcr_file.qcr06,
#                    qcr07   LIKE qcr_file.qcr07,
#                    ima02   LIKE ima_file.ima02,
#                    qcr08   LIKE qcr_file.qcr08,
#                    qcr09   LIKE qcr_file.qcr09,
#                    qcr10   LIKE qcr_file.qcr10,
#                    qcr11   LIKE qcr_file.qcr11,
#                    qcr12   LIKE qcr_file.qcr12,
#                    qcp02   LIKE qcp_file.qcp02,
#                    qcp03   LIKE qcp_file.qcp03,
#                    qcp04   LIKE qcp_file.qcp04,
#                    qcp05   LIKE qcp_file.qcp05,
#                    qcp06   LIKE qcp_file.qcp06,
#                    qce03   LIKE qce_file.qce03
#                    END RECORD
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
# 
#    ORDER BY sr.qcr01,sr.qcr02
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<' 
#            PRINT COLUMN 96,g_x[3] CLIPPED,pageno_total     
#            PRINT 
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
# 
#        BEFORE GROUP OF sr.qcr01
#            SKIP TO TOP OF PAGE
#            PRINT g_x[31],COLUMN 16,sr.qcr01
#            PRINT g_x[32],COLUMN 16,sr.qcr02
#            PRINT g_x[33],COLUMN 16,sr.qcr03, COLUMN 24,sr.gem02
#            PRINT g_x[34],COLUMN 16,sr.qcr04, COLUMN 26,sr.gen02
#            PRINT g_x[35],COLUMN 16,sr.qcr05
#            PRINT g_x[36],COLUMN 16,sr.ima02
#            PRINT g_x[37],COLUMN 16,sr.qcr06
#            PRINT g_x[38]
#            PRINT g_dash[1,g_len]
#            PRINT g_x[39] CLIPPED,
#                  COLUMN 7,g_x[40] CLIPPED,
#                  COLUMN 16,g_x[41] CLIPPED,
#                  COLUMN 57,g_x[42] CLIPPED,
#                  COLUMN 77,g_x[43] CLIPPED
#            PRINT '----- -------- ----------------------------------------',
#                  ' ------------------- ------------------------------'
#        ON EVERY ROW
#            LET g_sql =
#                "SELECT qcp02,qcp06,qcp03,qcp04,qcp05 ",
#                " FROM qcp_file",
#                " WHERE qcp01 ='",sr.qcr01,"'"
#            PREPARE t900_out_p FROM g_sql
#            DECLARE qcp_out_cs                       #CURSOR
#                CURSOR FOR t900_out_p
#            FOREACH qcp_out_cs INTO sr.qcp02,sr.qcp06,sr.qcp03,sr.qcp04,sr.qcp05
#                IF SQLCA.sqlcode THEN
#                    CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                    EXIT FOREACH
#                END IF
#                SELECT qce03 INTO sr.qce03 FROM qce_file
#                 WHERE qce01= sr.qcp06
#                PRINT sr.qcp02 USING '#####',
#                      COLUMN 7,sr.qcp06,
#                      COLUMN 16,sr.qce03 CLIPPED,
#                      COLUMN 57,sr.qcp04 USING '###,###,###,##&.###',
#                      COLUMN 77,sr.qcp03
#            END FOREACH
#        AFTER GROUP OF sr.qcr01
#            PRINT
#            PRINT g_x[45] CLIPPED
#            IF sr.qcr08 = '1' THEN
#                PRINT g_x[46] CLIPPED,sr.qcr08 CLIPPED,' ',g_x[53] CLIPPED,' ',sr.qcr09
#            ELSE
#                PRINT g_x[46] CLIPPED,sr.qcr08 CLIPPED,' ',g_x[54] CLIPPED,' ',sr.qcr09
#            END IF
#            PRINT g_x[47] CLIPPED;
#            CASE
#                WHEN sr.qcr10 = '1' 
#                    PRINT g_x[48] CLIPPED
#                WHEN sr.qcr10 = '2'
#                    PRINT g_x[49] CLIPPED
#                WHEN sr.qcr10 = '3'
#                    PRINT g_x[50] CLIPPED
#            END CASE
#            PRINT g_x[51] CLIPPED,sr.qcr11 USING '###,###,###,##&.###'
#            PRINT g_x[52] CLIPPED,sr.qcr12 USING '###,###,###,##&.###'
# 
#        PAGE TRAILER
#             PRINT g_dash[1,g_len]
#             PRINT g_x[55]
#             PRINT g_memo
#END REPORT
#FUN-C30190--mark--end--

#FUN-BB0153---begin add
FUNCTION t900_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    IF g_qcr.qcr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_qcr.* FROM qcr_file WHERE qcr01 = g_qcr.qcr01
    IF g_qcr.qcrconf = 'Y' THEN CALL cl_err('','aqc-047',0) RETURN END IF
    IF g_qcr.qcrconf = 'X' THEN CALL cl_err('','aqc-047',0) RETURN END IF
    BEGIN WORK
 
    OPEN t900_cl USING g_qcr.qcr01
    IF STATUS THEN
       CALL cl_err("OPEN t900_cl:", STATUS, 1)
       CLOSE t900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t900_cl INTO g_qcr.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_qcr.qcr01,SQLCA.sqlcode,0)
       CLOSE t900_cl 
       ROLLBACK WORK 
       RETURN
    END IF
    
    CALL t900_show()
    IF cl_delh(20,16) THEN #詢問是否刪除此筆資料
        
        DELETE FROM qcr_file WHERE qcr01 = g_qcr.qcr01
        DELETE FROM qcp_file WHERE qcp01 = g_qcr.qcr01

        CLEAR FORM
        CALL g_qcp.clear()
        OPEN t900_count

        FETCH t900_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t900_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t900_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL t900_fetch('/')
        END IF
    END IF

    CLOSE t900_cl
    COMMIT WORK
    CALL cl_flow_notify(g_qcr.qcr01,'D')
    IF g_qcr.qcrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF 
    CALL cl_set_field_pic(g_qcr.qcrconf,"","","",g_chr,"")  
END FUNCTION

#FUNCTION t900_x()       #FUN-D20025
FUNCTION t900_x(p_type)  #FUN-D20025
   DEFINE p_type    LIKE type_file.num5     #FUN-D20025
   DEFINE l_flag    LIKE type_file.chr1     #FUN-D20025
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_qcr.* FROM qcr_file WHERE qcr01=g_qcr.qcr01
   
   IF g_qcr.qcr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_qcr.qcrconf = 'Y' THEN CALL cl_err('','alm-870',0) RETURN END IF
   
   #FUN-D20025--add--str--
   IF p_type = 1 THEN 
      IF g_qcr.qcrconf='X' THEN RETURN END IF
   ELSE
      IF g_qcr.qcrconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20025--add--end--

   BEGIN WORK
 
   OPEN t900_cl USING g_qcr.qcr01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_qcr.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_qcr.qcr01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t900_cl 
      ROLLBACK WORK 
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t900_show()
   
  #IF cl_void(0,0,g_qcr.qcrconf)   THEN   #FUN-D20025
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF  #FUN-D20025
   IF cl_void(0,0,l_flag) THEN                                       #FUN-D20025
      LET l_qcr00=g_qcr.qcrconf
  #   IF g_qcr.qcrconf ='N' THEN          #FUN-D20025
      IF p_type = 1  THEN                 #FUN-D20025 
         LET g_qcr.qcrconf='X'
      ELSE
         LET g_qcr.qcrconf='N'
      END IF
 
      UPDATE qcr_file SET qcrconf = g_qcr.qcrconf,
                          qcrmodu = g_user,
                          qcrdate = g_today
                    WHERE qcr01 = g_qcr.qcr01
      IF STATUS THEN 
         CALL cl_err('upd qcrconf:',STATUS,1) 
         LET g_success='N' 
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
         IF g_qcr.qcrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF 
         CALL cl_set_field_pic(g_qcr.qcrconf,"","","",g_chr,"")          
         CALL cl_flow_notify(g_qcr.qcr01,'V')
      ELSE
         ROLLBACK WORK
      END IF
      SELECT qcrconf,qcrmodu,qcrdate INTO g_qcr.qcrconf,g_qcr.qcrmodu,g_qcr.qcrdate
        FROM qcr_file
       WHERE qcr01 = g_qcr.qcr01
      DISPLAY BY NAME g_qcr.qcrconf
   END IF
END FUNCTION
#FUN-BB0153---end add
 
 


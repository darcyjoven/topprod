# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmi300.4gl
# Descriptions...: 銷售系統信用查核比率維護作業
# Date & Author..: 06/04/03 By Nicola
# Modify.........: No.MOD-640284 06/04/10 By Nicola SCROLLGRID不提供轉excel的功能
# Modify.........: No.FUN-4C0102 06/05/24 By kim 增加複製的功能
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modfiy.........: NO.MOD-6C0009 06/12/01 BY yiting 少了UPDATE ocg12
# Modify.........: No.MOD-6C0119 06/12/25 By claire 傳參數串查
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710115 07/03/28 By Judy 1.比率可以超過100
#                                                 2.錄入后刪除，再錄入相同值時報錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No:TQC-9B0205 09/11/24 By Carrier 修改时,更新modu字段
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60125 10/08/03 By lilingyu 查詢時,ocg01--ocg10的值未顯示在畫面上
# Modify.........: No.TQC-A90064 10/10/13 By houlia 修改錄入時“狀態”頁簽未帶出默認值
# Modify.........: No.TQC-AA0115 10/10/20 By houlia 調整TQC-A90064
# Modify.........: No.TQC-AB0025 10/11/03 By chenying 新增時狀態頁簽资料建立者，资料建立部门栏位值未显示
#                                                     查詢時信用评等等相关栏位直未显示出来 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-BC0145 11/12/14 By Vampire p_zz的zz13(是否可修改key值)的選項拿掉,複製第二次時,key值就無法輸入
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_ocg           RECORD LIKE ocg_file.*,       
       g_ocg_t         RECORD LIKE ocg_file.*,      
       g_ocg01_t       LIKE ocg_file.ocg01,       
       g_och01         DYNAMIC ARRAY OF RECORD
                          och03_01   LIKE och_file.och03
                       END RECORD,
       g_och01_t       RECORD
                          och03_01   LIKE och_file.och03
                       END RECORD,
       g_och02         DYNAMIC ARRAY OF RECORD
                          och03_02   LIKE och_file.och03
                       END RECORD,
       g_och02_t       RECORD
                          och03_02   LIKE och_file.och03
                       END RECORD,
       g_och03         DYNAMIC ARRAY OF RECORD
                          och03_03   LIKE och_file.och03
                       END RECORD,
       g_och03_t       RECORD
                          och03_03   LIKE och_file.och03
                       END RECORD,
       g_och04         DYNAMIC ARRAY OF RECORD
                          och03_04   LIKE och_file.och03
                       END RECORD,
       g_och04_t       RECORD
                          och03_04   LIKE och_file.och03
                       END RECORD,
       g_och05         DYNAMIC ARRAY OF RECORD
                          och03_05   LIKE och_file.och03
                       END RECORD,
       g_och05_t       RECORD
                          och03_05   LIKE och_file.och03
                       END RECORD,
       g_och06         DYNAMIC ARRAY OF RECORD
                          och03_06   LIKE och_file.och03
                       END RECORD,
       g_och06_t       RECORD
                          och03_06   LIKE och_file.och03
                       END RECORD,
       g_och07         DYNAMIC ARRAY OF RECORD
                          och03_07   LIKE och_file.och03
                       END RECORD,
       g_och07_t       RECORD
                          och03_07   LIKE och_file.och03
                       END RECORD,
       g_och08         DYNAMIC ARRAY OF RECORD
                          och03_08   LIKE och_file.och03
                       END RECORD,
       g_och08_t       RECORD
                          och03_08   LIKE och_file.och03
                       END RECORD,
       g_och09         DYNAMIC ARRAY OF RECORD
                          och03_09   LIKE och_file.och03
                       END RECORD,
       g_och09_t       RECORD
                          och03_09   LIKE och_file.och03
                       END RECORD,
       g_och10         DYNAMIC ARRAY OF RECORD
                          och03_10   LIKE och_file.och03
                       END RECORD,
       g_och10_t       RECORD
                          och03_10   LIKE och_file.och03
                       END RECORD,
       g_och11         DYNAMIC ARRAY OF RECORD
                          och03_11   LIKE och_file.och03
                       END RECORD,
       g_och11_t       RECORD
                          och03_11   LIKE och_file.och03
                       END RECORD,
       g_och           DYNAMIC ARRAY OF RECORD
                          och03_01   LIKE och_file.och03,
                          och03_02   LIKE och_file.och03,
                          och03_03   LIKE och_file.och03,
                          och03_04   LIKE och_file.och03,
                          och03_05   LIKE och_file.och03,
                          och03_06   LIKE och_file.och03,
                          och03_07   LIKE och_file.och03,
                          och03_08   LIKE och_file.och03,
                          och03_09   LIKE och_file.och03,
                          och03_10   LIKE och_file.och03,
                          och03_11   LIKE och_file.och03
                       END RECORD,
       g_wc,g_wc2,g_sql   STRING,
       g_rec_b         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b01       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b02       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b03       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b04       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b05       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b06       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b07       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b08       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b09       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b10       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       g_rec_b11       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_ac            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_cmd           LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(200)
 
DEFINE g_forupd_sql    STRING
DEFINE g_before_input_done  LIKE type_file.num5      #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5           #No.FUN-680137 SMALLINT
DEFINE g_cnt           LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE g_i             LIKE type_file.num5           #No.FUN-680137 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(72)
DEFINE g_curs_index    LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE g_row_count     LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE g_jump          LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5           #No.FUN-680137 SMALLINT
DEFINE g_argv1         LIKE ocg_file.ocg01           #MOD-6C0119 add
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0094
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0094
 
   LET g_forupd_sql = "SELECT * FROM ocg_file WHERE ocg01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 20
   LET g_argv1      = ARG_VAL(1)          #參數值(1) Part #MOD-6C0119
 
   OPEN WINDOW i300_w AT p_row,p_col
     WITH FORM "axm/42f/axmi300"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN CALL i300_q() END IF       #MOD-6C0119 add
   CALL i300_menu()
 
   CLOSE WINDOW i300_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0094
 
END MAIN
 
FUNCTION i300_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
 #MOD-6C0119-end-add
   IF NOT cl_null(g_argv1)  THEN
      LET g_wc = "ocg01 = '",g_argv1,"'"
   ELSE 
 #MOD-6C0119-end-add
   CLEAR FORM
   CALL g_och.clear()
   CALL g_och01.clear()
   CALL g_och02.clear()
   CALL g_och03.clear()
   CALL g_och04.clear()
   CALL g_och05.clear()
   CALL g_och06.clear()
   CALL g_och07.clear()
   CALL g_och08.clear()
   CALL g_och09.clear()
   CALL g_och10.clear()
   CALL g_och11.clear()
   CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ocg.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON ocg01,ocguser,ocggrup,ocgmodu,ocgdate,ocgacti
 
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ocguser', 'ocggrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   END IF       #MOD-6C0119 add
 
   LET g_sql = "SELECT ocg01 FROM ocg_file",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ocg01"
 
   PREPARE i300_prepare FROM g_sql
   DECLARE i300_cs SCROLL CURSOR WITH HOLD FOR i300_prepare
 
   LET g_sql="SELECT COUNT(*) FROM ocg_file WHERE ",g_wc CLIPPED
   PREPARE i300_precount FROM g_sql
   DECLARE i300_count CURSOR FOR i300_precount
 
END FUNCTION
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i300_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i300_r()
            END IF
         #FUN-4C0102...............begin
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i300_copy()
            END IF
         #FUN-4C0102...............end
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i300_u()
            END IF
         WHEN "modify01" 
            IF cl_chk_act_auth() THEN
               CALL i300_b01()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify02" 
            IF cl_chk_act_auth() THEN
               CALL i300_b02()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify03" 
            IF cl_chk_act_auth() THEN
               CALL i300_b03()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify04" 
            IF cl_chk_act_auth() THEN
               CALL i300_b04()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify05" 
            IF cl_chk_act_auth() THEN
               CALL i300_b05()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify06" 
            IF cl_chk_act_auth() THEN
               CALL i300_b06()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify07" 
            IF cl_chk_act_auth() THEN
               CALL i300_b07()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify08" 
            IF cl_chk_act_auth() THEN
               CALL i300_b08()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify09" 
            IF cl_chk_act_auth() THEN
               CALL i300_b09()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify10" 
            IF cl_chk_act_auth() THEN
               CALL i300_b10()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify11" 
            IF cl_chk_act_auth() THEN
               CALL i300_b11()
               CALL i300_b_fill()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       # WHEN "exporttoexcel"   #No.MOD-640284 Mark
       #    IF cl_chk_act_auth() THEN
       #      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_och),'','')
       #    END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ocg.ocg01 IS NOT NULL THEN
                 LET g_doc.column1 = "ocg01"
                 LET g_doc.value1 = g_ocg.ocg01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i300_a()
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_och.clear()
   CALL g_och01.clear()
   CALL g_och02.clear()
   CALL g_och03.clear()
   CALL g_och04.clear()
   CALL g_och05.clear()
   CALL g_och06.clear()
   CALL g_och07.clear()
   CALL g_och08.clear()
   CALL g_och09.clear()
   CALL g_och10.clear()
   CALL g_och11.clear()
 
   INITIALIZE g_ocg.* LIKE ocg_file.*
   LET g_ocg01_t = NULL
   LET g_ocg_t.* = g_ocg.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ocg.ocg02 = 0
      LET g_ocg.ocg03 = 0
      LET g_ocg.ocg04 = 0
      LET g_ocg.ocg05 = 0
      LET g_ocg.ocg06 = 0
      LET g_ocg.ocg07 = 0
      LET g_ocg.ocg08 = 0
      LET g_ocg.ocg09 = 0
      LET g_ocg.ocg10 = 0
      LET g_ocg.ocg11 = 'Y'
      LET g_ocg.ocg12 = 'Y'
      LET g_ocg.ocgacti = 'Y'
      LET g_ocg.ocguser = g_user
      LET g_ocg.ocggrup = g_grup
      LET g_ocg.ocgdate = g_today
      #No.TQC-9B0205  --Begin
      LET g_ocg.ocgoriu = g_user
      LET g_ocg.ocgorig = g_grup
      #No.TQC-9B0205  --End  
 
      CALL i300_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_ocg.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ocg.ocg01 IS NULL THEN
         CONTINUE WHILE
      END IF
 
      INSERT INTO ocg_file VALUES(g_ocg.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,1)   #No.FUN-660167
         CALL cl_err3("ins","ocg_file",g_ocg.ocg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
         CONTINUE WHILE
      END IF
 
      LET g_ocg01_t = g_ocg.ocg01
      LET g_ocg_t.* = g_ocg.*
 
      LET g_rec_b01 = 0 
      LET g_rec_b02 = 0 
      LET g_rec_b03 = 0 
      LET g_rec_b04 = 0 
      LET g_rec_b05 = 0 
      LET g_rec_b06 = 0 
      LET g_rec_b07 = 0 
      LET g_rec_b08 = 0 
      LET g_rec_b09 = 0 
      LET g_rec_b10 = 0 
      LET g_rec_b11 = 0 
 
      CALL i300_b01()
      CALL i300_b02()
      CALL i300_b03()
      CALL i300_b04()
      CALL i300_b05()
      CALL i300_b06()
      CALL i300_b07()
      CALL i300_b08()
      CALL i300_b09()
      CALL i300_b10()
      CALL i300_b11()
      CALL i300_b_fill()
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i300_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ocg.ocg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_ocg01_t = g_ocg.ocg01
   LET g_ocg_t.* = g_ocg.*
 
   BEGIN WORK
 
   OPEN i300_cl USING g_ocg.ocg01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i300_cl INTO g_ocg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)
      CLOSE i300_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #No.TQC-9B0205  --Begin                                                      
   LET g_ocg.ocgmodu = g_user                #修改者                            
   LET g_ocg.ocgdate = g_today               #修改日期                          
   #No.TQC-9B0205  --End                                  
   CALL i300_show()
 
   WHILE TRUE
      LET g_ocg01_t = g_ocg.ocg01
 
      CALL i300_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ocg.*=g_ocg_t.*
         CALL i300_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ocg.ocg01 != g_ocg01_t THEN  
         UPDATE och_file SET och01 = g_ocg.ocg01 WHERE och01 = g_ocg01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('och',SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","och_file",g_ocg01_t,"",SQLCA.sqlcode,"","och",1)  #No.FUN-660167
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ocg_file SET ocg01 = g_ocg.ocg01,
                          ocg02 = g_ocg.ocg02, 
                          ocg03 = g_ocg.ocg03, 
                          ocg04 = g_ocg.ocg04, 
                          ocg05 = g_ocg.ocg05, 
                          ocg06 = g_ocg.ocg06, 
                          ocg07 = g_ocg.ocg07, 
                          ocg08 = g_ocg.ocg08, 
                          ocg09 = g_ocg.ocg09, 
                          ocg10 = g_ocg.ocg10, 
                          ocg11 = g_ocg.ocg11,
                          ocgmodu = g_ocg.ocgmodu,   #No.TQC-9B0205             
                          ocgdate = g_ocg.ocgdate,   #No.TQC-9B0205
                          ocg12 = g_ocg.ocg12   #MOD-6C0009 ADD
       WHERE ocg01 = g_ocg_t.ocg01
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)   #No.FUN-660167
         CALL cl_err3("upd","ocg_file",g_ocg_t.ocg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i300_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_i(p_cmd)
   DEFINE l_flag   LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_n1     LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          p_cmd    LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
 
   #No.FUN-9A0024--begin     
   #DISPLAY BY NAME g_ocg.*                
   DISPLAY BY NAME g_ocg.ocg01,g_ocg.ocg02,g_ocg.ocg03,g_ocg.ocg04,
                   g_ocg.ocg05,g_ocg.ocg06,g_ocg.ocg07,g_ocg.ocg08,
                   g_ocg.ocg09,g_ocg.ocg10,g_ocg.ocg11,g_ocg.ocg12, 
                   g_ocg.ocguser,g_ocg.ocggrup,g_ocg.ocgmodu,g_ocg.ocgdate,
#                  g_ocg.ocgacti,g_ocg.ocgoriu,g_ocg.ocgorig              #TQC-AA0115
                   g_ocg.ocgacti                                 #TQC-AA0115 
   #No.FUN-9A0024--end   
   CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
   INPUT BY NAME g_ocg.ocg01,g_ocg.ocg02,g_ocg.ocg03,g_ocg.ocg04,
                 g_ocg.ocg05,g_ocg.ocg06,g_ocg.ocg07,g_ocg.ocg08,
                 g_ocg.ocg09,g_ocg.ocg10,g_ocg.ocg11,g_ocg.ocg12 
#TQC-A90064 --add
#                g_ocg.ocguser,g_ocg.ocggrup,g_ocg.ocgmodu,g_ocg.ocgdate,
#                g_ocg.ocgacti          
#TQC-A90064 --end
                 ,g_ocg.ocguser,g_ocg.ocggrup,g_ocg.ocgacti   #TQC-AB0025 add
      WITHOUT DEFAULTS 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i300_set_entry(p_cmd)
         CALL i300_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
      
      AFTER FIELD ocg01
         IF cl_null(g_ocg.ocg01) THEN
           IF g_ocg.ocg01 != g_ocg_t.ocg01 OR cl_null(g_ocg_t.ocg01) THEN
              SELECT COUNT(*) INTO g_cnt FROM ocg_file
               WHERE ocg01=g_ocg.ocg01
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD ocg01
              END IF
           END IF
         END IF
 
      AFTER FIELD ocg02
#TQC-710115.....begin
#        IF g_ocg.ocg02 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg02 < 0 OR g_ocg.ocg02 >100 THEN    
            CALL cl_err(g_ocg.ocg02,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg02
         END IF
 
      AFTER FIELD ocg03
#TQC-710115.....begin
#        IF g_ocg.ocg03 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg03 < 0 OR g_ocg.ocg03 >100 THEN    
            CALL cl_err(g_ocg.ocg03,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg03
         END IF
 
      AFTER FIELD ocg04
#TQC-710115.....begin
#        IF g_ocg.ocg04 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg04 < 0 OR g_ocg.ocg04 >100 THEN    
            CALL cl_err(g_ocg.ocg04,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg04
         END IF
 
      AFTER FIELD ocg05
#TQC-710115.....begin
#        IF g_ocg.ocg05 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg05 < 0 OR g_ocg.ocg05 >100 THEN    
            CALL cl_err(g_ocg.ocg05,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg05
         END IF
 
      AFTER FIELD ocg06
#TQC-710115.....begin
#        IF g_ocg.ocg06 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg06 < 0 OR g_ocg.ocg06 >100 THEN    
            CALL cl_err(g_ocg.ocg06,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg06
         END IF
 
      AFTER FIELD ocg07
#TQC-710115.....begin
#        IF g_ocg.ocg07 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg07 < 0 OR g_ocg.ocg07 >100 THEN    
            CALL cl_err(g_ocg.ocg07,'axm-986',0)                                
#TQC-710115.....end 
            NEXT FIELD ocg07
         END IF
 
      AFTER FIELD ocg08
#TQC-710115......begin
#        IF g_ocg.ocg08 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg08 < 0 OR g_ocg.ocg08 >100 THEN    
            CALL cl_err(g_ocg.ocg08,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg08
         END IF
 
      AFTER FIELD ocg09
#TQC-710115.....begin
#        IF g_ocg.ocg09 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg09 < 0 OR g_ocg.ocg09 >100 THEN    
            CALL cl_err(g_ocg.ocg09,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg09
         END IF
 
      AFTER FIELD ocg10
#TQC-710115.....begin
#        IF g_ocg.ocg10 < 0 THEN
#           CALL cl_err("","mfg5034",0)
         IF g_ocg.ocg10 < 0 OR g_ocg.ocg10 >100 THEN    
            CALL cl_err(g_ocg.ocg10,'axm-986',0)                                
#TQC-710115.....end
            NEXT FIELD ocg10
         END IF
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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
    
END FUNCTION
 
FUNCTION i300_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ocg.* TO NULL               #No.FUN-6B0079  add
 
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt 
 
   CALL i300_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ocg.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! " 
 
   OPEN i300_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ocg.* TO NULL
   ELSE
      OPEN i300_count
      FETCH i300_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt 
      CALL i300_fetch('F')
   END IF
 
   MESSAGE ""
 
END FUNCTION
 
FUNCTION i300_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i300_cs INTO g_ocg.ocg01
      WHEN 'P' FETCH PREVIOUS i300_cs INTO g_ocg.ocg01
      WHEN 'F' FETCH FIRST    i300_cs INTO g_ocg.ocg01
      WHEN 'L' FETCH LAST     i300_cs INTO g_ocg.ocg01
      WHEN '/'
          IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED || ': ' FOR g_jump
 
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about
                   CALL cl_about()
            
                ON ACTION help
                   CALL cl_show_help()
            
                ON ACTION controlg
                   CALL cl_cmdask()
 
             END PROMPT
 
             IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
             END IF
          END IF
          FETCH ABSOLUTE g_jump i300_cs INTO g_ocg.ocg01
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)
      INITIALIZE g_ocg.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
   
      CALL cl_navigator_setting(g_curs_index,g_row_count)
   END IF
 
   SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01 = g_ocg.ocg01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)   #No.FUN-660167
      CALL cl_err3("sel","ocg_file",g_ocg.ocg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      INITIALIZE g_ocg.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = ''
   LET g_data_group = ''
 
   CALL i300_show()
 
END FUNCTION
 
FUNCTION i300_show()
 
   LET g_ocg_t.* = g_ocg.*
 
   #No.FUN-9A0024--begin     
   #DISPLAY BY NAME g_ocg.*     
   DISPLAY BY NAME g_ocg.ocg01,g_ocg.ocg02,g_ocg.ocg03,g_ocg.ocg04, 
                   g_ocg.ocg05,g_ocg.ocg06,g_ocg.ocg07,g_ocg.ocg08,
                   g_ocg.ocg09,g_ocg.ocg10,g_ocg.ocg11,g_ocg.ocg12, 
                   g_ocg.ocguser,g_ocg.ocggrup,g_ocg.ocgmodu,g_ocg.ocgdate,
                   g_ocg.ocgacti
            #,g_ocg.ocgoriu,g_ocg.ocgorig             #TQC-A60125
 
   #No.FUN-9A0024--end
 
   CALL i300_b_fill()
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION i300_r()
   DEFINE l_chr,l_sure LIKE type_file.chr1          #No.FUN-680137  VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ocg.ocg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i300_cl USING g_ocg.ocg01
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)
      CLOSE i300_cl 
      ROLLBACK WORK 
      RETURN 
   END IF
 
   FETCH i300_cl INTO g_ocg.*
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)
      CLOSE i300_cl 
      ROLLBACK WORK 
      RETURN 
   END IF
 
   CALL i300_show()
 
   IF cl_delh(20,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ocg01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ocg.ocg01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM ocg_file WHERE ocg01 = g_ocg.ocg01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_ocg.ocg01,SQLCA.sqlcode,0)   #No.FUN-660167
         CALL cl_err3("del","ocg_file",g_ocg.ocg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      ELSE
         CLEAR FORM
         CALL g_och.clear()
         CALL g_och01.clear()
         CALL g_och02.clear()
         CALL g_och03.clear()
         CALL g_och04.clear()
         CALL g_och05.clear()
         CALL g_och06.clear()
         CALL g_och07.clear()
         CALL g_och08.clear()
         CALL g_och09.clear()
         CALL g_och10.clear()
         CALL g_och11.clear()
         DELETE FROM och_file WHERE och01 = g_ocg.ocg01      #No.TQC-710115
         INITIALIZE g_ocg.* LIKE ocg_file.*
         OPEN i300_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i300_cs
            CLOSE i300_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i300_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i300_cs
            CLOSE i300_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i300_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i300_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i300_fetch('/')
         END IF
      END IF
#     DELETE FROM och_file WHERE och01 = g_ocg.ocg01      #No.TQC-710115
   END IF
 
   CLOSE i300_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b01()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 1 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl01 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och01 WITHOUT DEFAULTS FROM s_och01.* 
         ATTRIBUTE(COUNT=g_rec_b01,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b01 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b01 >= l_ac THEN
            LET p_cmd='u'
            LET g_och01_t.* = g_och01[l_ac].*
            OPEN i300_bcl01 USING g_ocg.ocg01,g_och01_t.och03_01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och01_t.och03_01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl01 INTO g_och01[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och01_t.och03_01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och01[l_ac].* TO NULL
         LET g_och01_t.* = g_och01[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och01[l_ac].och03_01) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,1,g_och01[l_ac].och03_01)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och01[l_ac].och03_01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och01[l_ac].och03_01,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b01 = g_rec_b01 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_01
         IF NOT cl_null(g_och01[l_ac].och03_01) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och01[l_ac].och03_01
             IF g_cnt = 0 THEN
                CALL cl_err(g_och01[l_ac].och03_01,"axm-274",0)
                NEXT FIELD och03_01
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och01_t.och03_01 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 1
               AND och03 = g_och01_t.och03_01
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och01_t.och03_01,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och01_t.och03_01,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och01[l_ac].* = g_och01_t.*
            CLOSE i300_bcl01
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och01[l_ac].och03_01,-263,1)
            LET g_och01[l_ac].* = g_och01_t.*
         ELSE
            IF cl_null(g_och01[l_ac].och03_01) THEN
               CALL cl_err("","axm-039",1)
               LET g_och01[l_ac].* = g_och01_t.*
            ELSE
               UPDATE och_file SET och03 = g_och01[l_ac].och03_01
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 1
                  AND och03 = g_och01_t.och03_01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och01[l_ac].och03_01,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och01_t.och03_01,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och01[l_ac].* = g_och01_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och01[l_ac].* = g_och01_t.*
            END IF
            CLOSE i300_bcl01
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl01
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och01[l_ac].och03_01
               CALL cl_create_qry() RETURNING g_och01[l_ac].och03_01 
               DISPLAY BY NAME g_och01[l_ac].och03_01 
               NEXT FIELD och03_01
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01","AUTO")           #No.FUN-6A0092
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl01
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b02()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 2 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl02 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och02 WITHOUT DEFAULTS FROM s_och02.* 
         ATTRIBUTE(COUNT=g_rec_b02,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b02 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b02 >= l_ac THEN
            LET p_cmd='u'
            LET g_och02_t.* = g_och02[l_ac].*
            OPEN i300_bcl02 USING g_ocg.ocg01,g_och02_t.och03_02
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och02_t.och03_02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl02 INTO g_och02[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och02_t.och03_02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och02[l_ac].* TO NULL
         LET g_och02_t.* = g_och02[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och02[l_ac].och03_02) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,2,g_och02[l_ac].och03_02)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och02[l_ac].och03_02,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och02[l_ac].och03_02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b02 = g_rec_b02 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_02
         IF NOT cl_null(g_och02[l_ac].och03_02) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och02[l_ac].och03_02
             IF g_cnt = 0 THEN
                CALL cl_err(g_och02[l_ac].och03_02,"axm-274",0)
                NEXT FIELD och03_02
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och02_t.och03_02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 2
               AND och03 = g_och02_t.och03_02
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och02_t.och03_02,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och02_t.och03_02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och02[l_ac].* = g_och02_t.*
            CLOSE i300_bcl02
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och02[l_ac].och03_02,-263,1)
            LET g_och02[l_ac].* = g_och02_t.*
         ELSE
            IF cl_null(g_och02[l_ac].och03_02) THEN
               CALL cl_err("","axm-039",1)
               LET g_och02[l_ac].* = g_och02_t.*
            ELSE
               UPDATE och_file SET och03 = g_och02[l_ac].och03_02
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 2
                  AND och03 = g_och02_t.och03_02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och02[l_ac].och03_02,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och02_t.och03_02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och02[l_ac].* = g_och02_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och02[l_ac].* = g_och02_t.*
            END IF
            CLOSE i300_bcl02
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl02
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och02[l_ac].och03_02
               CALL cl_create_qry() RETURNING g_och02[l_ac].och03_02 
               DISPLAY BY NAME g_och02[l_ac].och03_02 
               NEXT FIELD och03_02
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl02
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b03()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 3 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl03 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och03 WITHOUT DEFAULTS FROM s_och03.* 
         ATTRIBUTE(COUNT=g_rec_b03,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b03 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b03 >= l_ac THEN
            LET p_cmd='u'
            LET g_och03_t.* = g_och03[l_ac].*
            OPEN i300_bcl03 USING g_ocg.ocg01,g_och03_t.och03_03
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och03_t.och03_03,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl03 INTO g_och03[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och03_t.och03_03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och03[l_ac].* TO NULL
         LET g_och03_t.* = g_och03[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och03[l_ac].och03_03) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,3,g_och03[l_ac].och03_03)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och03[l_ac].och03_03,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och03[l_ac].och03_03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b03 = g_rec_b03 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_03
         IF NOT cl_null(g_och03[l_ac].och03_03) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och03[l_ac].och03_03
             IF g_cnt = 0 THEN
                CALL cl_err(g_och03[l_ac].och03_03,"axm-274",0)
                NEXT FIELD och03_03
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och03_t.och03_03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 3
               AND och03 = g_och03_t.och03_03
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och03_t.och03_03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och03_t.och03_03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och03[l_ac].* = g_och03_t.*
            CLOSE i300_bcl03
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och03[l_ac].och03_03,-263,1)
            LET g_och03[l_ac].* = g_och03_t.*
         ELSE
            IF cl_null(g_och03[l_ac].och03_03) THEN
               CALL cl_err("","axm-039",1)
               LET g_och03[l_ac].* = g_och03_t.*
            ELSE
               UPDATE och_file SET och03 = g_och03[l_ac].och03_03
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 3
                  AND och03 = g_och03_t.och03_03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och03[l_ac].och03_03,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och03_t.och03_03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och03[l_ac].* = g_och03_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och03[l_ac].* = g_och03_t.*
            END IF
            CLOSE i300_bcl03
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl03
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och03[l_ac].och03_03
               CALL cl_create_qry() RETURNING g_och03[l_ac].och03_03 
               DISPLAY BY NAME g_och03[l_ac].och03_03 
               NEXT FIELD och03_03
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl03
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b04()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 4 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl04 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och04 WITHOUT DEFAULTS FROM s_och04.* 
         ATTRIBUTE(COUNT=g_rec_b04,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b04 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b04 >= l_ac THEN
            LET p_cmd='u'
            LET g_och04_t.* = g_och04[l_ac].*
            OPEN i300_bcl04 USING g_ocg.ocg01,g_och04_t.och03_04
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och04_t.och03_04,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl04 INTO g_och04[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och04_t.och03_04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och04[l_ac].* TO NULL
         LET g_och04_t.* = g_och04[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och04[l_ac].och03_04) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,4,g_och04[l_ac].och03_04)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och04[l_ac].och03_04,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och04[l_ac].och03_04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b04 = g_rec_b04 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_04
         IF NOT cl_null(g_och04[l_ac].och03_04) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och04[l_ac].och03_04
             IF g_cnt = 0 THEN
                CALL cl_err(g_och04[l_ac].och03_04,"axm-274",0)
                NEXT FIELD och03_04
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och04_t.och03_04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 4
               AND och03 = g_och04_t.och03_04
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och04_t.och03_04,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och04_t.och03_04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och04[l_ac].* = g_och04_t.*
            CLOSE i300_bcl04
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och04[l_ac].och03_04,-263,1)
            LET g_och04[l_ac].* = g_och04_t.*
         ELSE
            IF cl_null(g_och04[l_ac].och03_04) THEN
               CALL cl_err("","axm-039",1)
               LET g_och04[l_ac].* = g_och04_t.*
            ELSE
               UPDATE och_file SET och03 = g_och04[l_ac].och03_04
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 4
                  AND och03 = g_och04_t.och03_04
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och04[l_ac].och03_04,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och04_t.och03_04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och04[l_ac].* = g_och04_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och04[l_ac].* = g_och04_t.*
            END IF
            CLOSE i300_bcl04
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl04
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och04[l_ac].och03_04
               CALL cl_create_qry() RETURNING g_och04[l_ac].och03_04
               DISPLAY BY NAME g_och04[l_ac].och03_04 
               NEXT FIELD och03_04
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl04
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b05()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 5 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl05 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och05 WITHOUT DEFAULTS FROM s_och05.* 
         ATTRIBUTE(COUNT=g_rec_b05,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b05 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b05 >= l_ac THEN
            LET p_cmd='u'
            LET g_och05_t.* = g_och05[l_ac].*
            OPEN i300_bcl05 USING g_ocg.ocg01,g_och05_t.och03_05
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och05_t.och03_05,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl05 INTO g_och05[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och05_t.och03_05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och05[l_ac].* TO NULL
         LET g_och05_t.* = g_och05[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_05
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och05[l_ac].och03_05) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,5,g_och05[l_ac].och03_05)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och05[l_ac].och03_05,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och05[l_ac].och03_05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b05 = g_rec_b05 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_05
         IF NOT cl_null(g_och05[l_ac].och03_05) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och05[l_ac].och03_05
             IF g_cnt = 0 THEN
                CALL cl_err(g_och05[l_ac].och03_05,"axm-274",0)
                NEXT FIELD och03_05
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och05_t.och03_05 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 5
               AND och03 = g_och05_t.och03_05
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och05_t.och03_05,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och05_t.och03_05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och05[l_ac].* = g_och05_t.*
            CLOSE i300_bcl05
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och05[l_ac].och03_05,-263,1)
            LET g_och05[l_ac].* = g_och05_t.*
         ELSE
            IF cl_null(g_och05[l_ac].och03_05) THEN
               CALL cl_err("","axm-039",1)
               LET g_och05[l_ac].* = g_och05_t.*
            ELSE
               UPDATE och_file SET och03 = g_och05[l_ac].och03_05
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 5
                  AND och03 = g_och05_t.och03_05
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och05[l_ac].och03_05,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och05_t.och03_05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och05[l_ac].* = g_och05_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och05[l_ac].* = g_och05_t.*
            END IF
            CLOSE i300_bcl05
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl05
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och05[l_ac].och03_05
               CALL cl_create_qry() RETURNING g_och05[l_ac].och03_05
               DISPLAY BY NAME g_och05[l_ac].och03_05 
               NEXT FIELD och03_05
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl05
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b06()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 6 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl06 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och06 WITHOUT DEFAULTS FROM s_och06.* 
         ATTRIBUTE(COUNT=g_rec_b06,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b06 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b06 >= l_ac THEN
            LET p_cmd='u'
            LET g_och06_t.* = g_och06[l_ac].*
            OPEN i300_bcl06 USING g_ocg.ocg01,g_och06_t.och03_06
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och06_t.och03_06,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl06 INTO g_och06[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och06_t.och03_06,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och06[l_ac].* TO NULL
         LET g_och06_t.* = g_och06[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_06
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och06[l_ac].och03_06) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,6,g_och06[l_ac].och03_06)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och06[l_ac].och03_06,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och06[l_ac].och03_06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b06 = g_rec_b06 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_06
         IF NOT cl_null(g_och06[l_ac].och03_06) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och06[l_ac].och03_06
             IF g_cnt = 0 THEN
                CALL cl_err(g_och06[l_ac].och03_06,"axm-274",0)
                NEXT FIELD och03_06
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och06_t.och03_06 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 6
               AND och03 = g_och06_t.och03_06
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och06_t.och03_06,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och06_t.och03_06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och06[l_ac].* = g_och06_t.*
            CLOSE i300_bcl06
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och06[l_ac].och03_06,-263,1)
            LET g_och06[l_ac].* = g_och06_t.*
         ELSE
            IF cl_null(g_och06[l_ac].och03_06) THEN
               CALL cl_err("","axm-039",1)
               LET g_och06[l_ac].* = g_och06_t.*
            ELSE
               UPDATE och_file SET och03 = g_och06[l_ac].och03_06
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 6
                  AND och03 = g_och06_t.och03_06
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och06[l_ac].och03_06,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och06_t.och03_06,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och06[l_ac].* = g_och06_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och06[l_ac].* = g_och06_t.*
            END IF
            CLOSE i300_bcl06
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl06
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och06[l_ac].och03_06
               CALL cl_create_qry() RETURNING g_och06[l_ac].och03_06
               DISPLAY BY NAME g_och06[l_ac].och03_06 
               NEXT FIELD och03_06
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl06
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b07()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 7 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl07 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och07 WITHOUT DEFAULTS FROM s_och07.* 
         ATTRIBUTE(COUNT=g_rec_b07,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b07 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b07 >= l_ac THEN
            LET p_cmd='u'
            LET g_och07_t.* = g_och07[l_ac].*
            OPEN i300_bcl07 USING g_ocg.ocg01,g_och07_t.och03_07
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och07_t.och03_07,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl07 INTO g_och07[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och07_t.och03_07,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och07[l_ac].* TO NULL
         LET g_och07_t.* = g_och07[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_07
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och07[l_ac].och03_07) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,7,g_och07[l_ac].och03_07)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och07[l_ac].och03_07,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och07[l_ac].och03_07,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b07 = g_rec_b07 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_07
         IF NOT cl_null(g_och07[l_ac].och03_07) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och07[l_ac].och03_07
             IF g_cnt = 0 THEN
                CALL cl_err(g_och07[l_ac].och03_07,"axm-274",0)
                NEXT FIELD och03_07
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och07_t.och03_07 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 7
               AND och03 = g_och07_t.och03_07
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och07_t.och03_07,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och07_t.och03_07,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och07[l_ac].* = g_och07_t.*
            CLOSE i300_bcl07
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och07[l_ac].och03_07,-263,1)
            LET g_och07[l_ac].* = g_och07_t.*
         ELSE
            IF cl_null(g_och07[l_ac].och03_07) THEN
               CALL cl_err("","axm-039",1)
               LET g_och07[l_ac].* = g_och07_t.*
            ELSE
               UPDATE och_file SET och03 = g_och07[l_ac].och03_07
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 7
                  AND och03 = g_och07_t.och03_07
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och07[l_ac].och03_07,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och07_t.och03_07,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och07[l_ac].* = g_och07_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och07[l_ac].* = g_och07_t.*
            END IF
            CLOSE i300_bcl07
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl07
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och07[l_ac].och03_07
               CALL cl_create_qry() RETURNING g_och07[l_ac].och03_07
               DISPLAY BY NAME g_och07[l_ac].och03_07 
               NEXT FIELD och03_07
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl07
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b08()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 8 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl08 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och08 WITHOUT DEFAULTS FROM s_och08.* 
         ATTRIBUTE(COUNT=g_rec_b08,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b08 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b08 >= l_ac THEN
            LET p_cmd='u'
            LET g_och08_t.* = g_och08[l_ac].*
            OPEN i300_bcl08 USING g_ocg.ocg01,g_och08_t.och03_08
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och08_t.och03_08,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl08 INTO g_och08[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och08_t.och03_08,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och08[l_ac].* TO NULL
         LET g_och08_t.* = g_och08[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_08
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och08[l_ac].och03_08) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,8,g_och08[l_ac].och03_08)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och08[l_ac].och03_08,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och08[l_ac].och03_08,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b08 = g_rec_b08 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_08
         IF NOT cl_null(g_och08[l_ac].och03_08) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och08[l_ac].och03_08
             IF g_cnt = 0 THEN
                CALL cl_err(g_och08[l_ac].och03_08,"axm-274",0)
                NEXT FIELD och03_08
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och08_t.och03_08 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 8
               AND och03 = g_och08_t.och03_08
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och08_t.och03_08,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och08_t.och03_08,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och08[l_ac].* = g_och08_t.*
            CLOSE i300_bcl08
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och08[l_ac].och03_08,-263,1)
            LET g_och08[l_ac].* = g_och08_t.*
         ELSE
            IF cl_null(g_och08[l_ac].och03_08) THEN
               CALL cl_err("","axm-039",1)
               LET g_och08[l_ac].* = g_och08_t.*
            ELSE
               UPDATE och_file SET och03 = g_och08[l_ac].och03_08
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 8
                  AND och03 = g_och08_t.och03_08
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och08[l_ac].och03_08,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och08_t.och03_08,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och08[l_ac].* = g_och08_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och08[l_ac].* = g_och08_t.*
            END IF
            CLOSE i300_bcl08
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl08
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och08[l_ac].och03_08
               CALL cl_create_qry() RETURNING g_och08[l_ac].och03_08
               DISPLAY BY NAME g_och08[l_ac].och03_08 
               NEXT FIELD och03_08
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl08
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b09()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 9 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl09 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och09 WITHOUT DEFAULTS FROM s_och09.* 
         ATTRIBUTE(COUNT=g_rec_b09,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b09 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b09 >= l_ac THEN
            LET p_cmd='u'
            LET g_och09_t.* = g_och09[l_ac].*
            OPEN i300_bcl09 USING g_ocg.ocg01,g_och09_t.och03_09
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och09_t.och03_09,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl09 INTO g_och09[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och09_t.och03_09,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och09[l_ac].* TO NULL
         LET g_och09_t.* = g_och09[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_09
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och09[l_ac].och03_09) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,9,g_och09[l_ac].och03_09)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och09[l_ac].och03_09,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och09[l_ac].och03_09,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b09 = g_rec_b09 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_09
         IF NOT cl_null(g_och09[l_ac].och03_09) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och09[l_ac].och03_09
             IF g_cnt = 0 THEN
                CALL cl_err(g_och09[l_ac].och03_09,"axm-274",0)
                NEXT FIELD och03_09
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och09_t.och03_09 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 9
               AND och03 = g_och09_t.och03_09
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och09_t.och03_09,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och09_t.och03_09,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och09[l_ac].* = g_och09_t.*
            CLOSE i300_bcl09
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och09[l_ac].och03_09,-263,1)
            LET g_och09[l_ac].* = g_och09_t.*
         ELSE
            IF cl_null(g_och09[l_ac].och03_09) THEN
               CALL cl_err("","axm-039",1)
               LET g_och09[l_ac].* = g_och09_t.*
            ELSE
               UPDATE och_file SET och03 = g_och09[l_ac].och03_09
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 9
                  AND och03 = g_och09_t.och03_09
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och09[l_ac].och03_09,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och09_t.och03_09,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och09[l_ac].* = g_och09_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och09[l_ac].* = g_och09_t.*
            END IF
            CLOSE i300_bcl09
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl09
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och09[l_ac].och03_09
               CALL cl_create_qry() RETURNING g_och09[l_ac].och03_09
               DISPLAY BY NAME g_och09[l_ac].och03_09 
               NEXT FIELD och03_09
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl09
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b10()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 10 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl10 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och10 WITHOUT DEFAULTS FROM s_och10.* 
         ATTRIBUTE(COUNT=g_rec_b10,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b10 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b10 >= l_ac THEN
            LET p_cmd='u'
            LET g_och10_t.* = g_och10[l_ac].*
            OPEN i300_bcl10 USING g_ocg.ocg01,g_och10_t.och03_10
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och10_t.och03_10,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl10 INTO g_och10[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och10_t.och03_10,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och10[l_ac].* TO NULL
         LET g_och10_t.* = g_och10[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_10
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och10[l_ac].och03_10) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,10,g_och10[l_ac].och03_10)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och10[l_ac].och03_10,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och10[l_ac].och03_10,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b10 = g_rec_b10 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_10
         IF NOT cl_null(g_och10[l_ac].och03_10) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och10[l_ac].och03_10
             IF g_cnt = 0 THEN
                CALL cl_err(g_och10[l_ac].och03_10,"axm-274",0)
                NEXT FIELD och03_10
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och10_t.och03_10 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 10
               AND och03 = g_och10_t.och03_10
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och10_t.och03_10,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och10_t.och03_10,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och10[l_ac].* = g_och10_t.*
            CLOSE i300_bcl10
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och10[l_ac].och03_10,-263,1)
            LET g_och10[l_ac].* = g_och10_t.*
         ELSE
            IF cl_null(g_och10[l_ac].och03_10) THEN
               CALL cl_err("","axm-039",1)
               LET g_och10[l_ac].* = g_och10_t.*
            ELSE
               UPDATE och_file SET och03 = g_och10[l_ac].och03_10
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 10
                  AND och03 = g_och10_t.och03_10
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och10[l_ac].och03_10,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och10_t.och03_10,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och10[l_ac].* = g_och10_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och10[l_ac].* = g_och10_t.*
            END IF
            CLOSE i300_bcl10
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl10
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och10[l_ac].och03_10
               CALL cl_create_qry() RETURNING g_och10[l_ac].och03_10
               DISPLAY BY NAME g_och10[l_ac].och03_10 
               NEXT FIELD och03_10
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl10
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b11()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680137 SMALLINT
 
   LET g_action_choice = ""
 
   IF g_ocg.ocg01 IS NULL THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT och03 FROM och_file ",
                      "  WHERE och01 = ? AND och02 = 11 AND och03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i300_bcl11 CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_och11 WITHOUT DEFAULTS FROM s_och11.* 
         ATTRIBUTE(COUNT=g_rec_b11,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b11 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b11 >= l_ac THEN
            LET p_cmd='u'
            LET g_och11_t.* = g_och11[l_ac].*
            OPEN i300_bcl11 USING g_ocg.ocg01,g_och11_t.och03_11
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_och11_t.och03_11,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i300_bcl11 INTO g_och11[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_och11_t.och03_11,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_och11[l_ac].* TO NULL
         LET g_och11_t.* = g_och11[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD och03_11
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_och11[l_ac].och03_11) THEN
            CANCEL INSERT
         END IF
         INSERT INTO och_file(och01,och02,och03)
                       VALUES(g_ocg.ocg01,11,g_och11[l_ac].och03_11)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_och11[l_ac].och03_11,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","och_file",g_ocg.ocg01,g_och11[l_ac].och03_11,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b11 = g_rec_b11 + 1
            MESSAGE 'INSERT O.K'
         END IF
 
      AFTER FIELD och03_11
         IF NOT cl_null(g_och11[l_ac].och03_11) THEN
            SELECT COUNT(*) INTO g_cnt FROM azp_file
             WHERE azp01 = g_och11[l_ac].och03_11
             IF g_cnt = 0 THEN
                CALL cl_err(g_och11[l_ac].och03_11,"axm-274",0)
                NEXT FIELD och03_11
             END IF
         END IF
 
      BEFORE DELETE
         IF g_och11_t.och03_11 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN 
               CANCEL DELETE
            END IF
             
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM och_file 
             WHERE och01 = g_ocg.ocg01 
               AND och02 = 11
               AND och03 = g_och11_t.och03_11
            IF SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err(g_och11_t.och03_11,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","och_file",g_ocg.ocg01,g_och11_t.och03_11,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_och11[l_ac].* = g_och11_t.*
            CLOSE i300_bcl11
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_och11[l_ac].och03_11,-263,1)
            LET g_och11[l_ac].* = g_och11_t.*
         ELSE
            IF cl_null(g_och11[l_ac].och03_11) THEN
               CALL cl_err("","axm-039",1)
               LET g_och11[l_ac].* = g_och11_t.*
            ELSE
               UPDATE och_file SET och03 = g_och11[l_ac].och03_11
                WHERE och01 = g_ocg.ocg01 
                  AND och02 = 11
                  AND och03 = g_och11_t.och03_11
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_och11[l_ac].och03_11,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","och_file",g_ocg.ocg01,g_och11_t.och03_11,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_och11[l_ac].* = g_och11_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_och11[l_ac].* = g_och11_t.*
            END IF
            CLOSE i300_bcl11
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i300_bcl11
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(och03_11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.default1 = g_och11[l_ac].och03_11
               CALL cl_create_qry() RETURNING g_och11[l_ac].och03_11
               DISPLAY BY NAME g_och11[l_ac].och03_11 
               NEXT FIELD och03_11
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
  
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i300_bcl11
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i300_b_fill()
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 1",
               " ORDER BY och03"
 
   PREPARE i300_pb01 FROM g_sql
   DECLARE och_curs01 CURSOR FOR i300_pb01
 
   CALL g_och.clear()
   CALL g_och01.clear()
   CALL g_och02.clear()
   CALL g_och03.clear()
   CALL g_och04.clear()
   CALL g_och05.clear()
   CALL g_och06.clear()
   CALL g_och07.clear()
   CALL g_och08.clear()
   CALL g_och09.clear()
   CALL g_och10.clear()
   CALL g_och11.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH och_curs01 INTO g_och[g_cnt].och03_01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och01:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och01[g_cnt].och03_01 = g_och[g_cnt].och03_01
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b01 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 2",
               " ORDER BY och03"
 
   PREPARE i300_pb02 FROM g_sql
   DECLARE och_curs02 CURSOR FOR i300_pb02
 
   LET g_cnt = 1
 
   FOREACH och_curs02 INTO g_och[g_cnt].och03_02
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och02:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och02[g_cnt].och03_02 = g_och[g_cnt].och03_02
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b02 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 3",
               " ORDER BY och03"
 
   PREPARE i300_pb03 FROM g_sql
   DECLARE och_curs03 CURSOR FOR i300_pb03
 
   LET g_cnt = 1
 
   FOREACH och_curs03 INTO g_och[g_cnt].och03_03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och03:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och03[g_cnt].och03_03 = g_och[g_cnt].och03_03
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b03 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 4",
               " ORDER BY och03"
 
   PREPARE i300_pb04 FROM g_sql
   DECLARE och_curs04 CURSOR FOR i300_pb04
 
   LET g_cnt = 1
 
   FOREACH och_curs04 INTO g_och[g_cnt].och03_04
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och04:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och04[g_cnt].och03_04 = g_och[g_cnt].och03_04
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b04 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 5",
               " ORDER BY och03"
 
   PREPARE i300_pb05 FROM g_sql
   DECLARE och_curs05 CURSOR FOR i300_pb05
 
   LET g_cnt = 1
 
   FOREACH och_curs05 INTO g_och[g_cnt].och03_05
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och05:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och05[g_cnt].och03_05 = g_och[g_cnt].och03_05
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b05 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 6",
               " ORDER BY och03"
 
   PREPARE i300_pb06 FROM g_sql
   DECLARE och_curs06 CURSOR FOR i300_pb06
 
   LET g_cnt = 1
 
   FOREACH och_curs06 INTO g_och[g_cnt].och03_06
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och06:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och06[g_cnt].och03_06 = g_och[g_cnt].och03_06
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b06 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 7",
               " ORDER BY och03"
 
   PREPARE i300_pb07 FROM g_sql
   DECLARE och_curs07 CURSOR FOR i300_pb07
 
   LET g_cnt = 1
 
   FOREACH och_curs07 INTO g_och[g_cnt].och03_07
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och07:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och07[g_cnt].och03_07 = g_och[g_cnt].och03_07
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b07 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 8",
               " ORDER BY och03"
 
   PREPARE i300_pb08 FROM g_sql
   DECLARE och_curs08 CURSOR FOR i300_pb08
 
   LET g_cnt = 1
 
   FOREACH och_curs08 INTO g_och[g_cnt].och03_08
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och08:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och08[g_cnt].och03_08 = g_och[g_cnt].och03_08
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b08 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 9",
               " ORDER BY och03"
 
   PREPARE i300_pb09 FROM g_sql
   DECLARE och_curs09 CURSOR FOR i300_pb09
 
   LET g_cnt = 1
 
   FOREACH och_curs09 INTO g_och[g_cnt].och03_09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och09:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och09[g_cnt].och03_09 = g_och[g_cnt].och03_09
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b09 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 10",
               " ORDER BY och03"
 
   PREPARE i300_pb10 FROM g_sql
   DECLARE och_curs10 CURSOR FOR i300_pb10
 
   LET g_cnt = 1
 
   FOREACH och_curs10 INTO g_och[g_cnt].och03_10
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och10:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och10[g_cnt].och03_10 = g_och[g_cnt].och03_10
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b10 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   LET g_sql = "SELECT och03 FROM och_file",
               " WHERE och01 ='",g_ocg.ocg01,"'",
               "   AND och02 = 11",
               " ORDER BY och03"
 
   PREPARE i300_pb11 FROM g_sql
   DECLARE och_curs11 CURSOR FOR i300_pb11
 
   LET g_cnt = 1
 
   FOREACH och_curs11 INTO g_och[g_cnt].och03_11
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach och11:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_och11[g_cnt].och03_11 = g_och[g_cnt].och03_11
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   
   END FOREACH
 
   LET g_rec_b11 = g_cnt -1
 
   IF g_rec_b < g_cnt THEN
      LET g_rec_b = g_cnt
   END IF
 
   CALL g_och.deleteElement(g_rec_b)
   LET g_rec_b = g_rec_b - 1
 
END FUNCTION
 
FUNCTION i300_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "modify01" 
      OR g_action_choice = "modify02" OR g_action_choice = "modify03"
      OR g_action_choice = "modify04" OR g_action_choice = "modify05"
      OR g_action_choice = "modify06" OR g_action_choice = "modify07"
      OR g_action_choice = "modify08" OR g_action_choice = "modify09"
      OR g_action_choice = "modify10" OR g_action_choice = "modify11" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_och TO s_och.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      #FUN-4C0102...............begin
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      #FUN-4C0102...............end
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL i300_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b01 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i300_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b01 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump 
         CALL i300_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b01 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i300_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b01 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last 
         CALL i300_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b01 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION modify01
         LET g_action_choice="modify01"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify02
         LET g_action_choice="modify02"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify03
         LET g_action_choice="modify03"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify04
         LET g_action_choice="modify04"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify05
         LET g_action_choice="modify05"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify06
         LET g_action_choice="modify06"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify07
         LET g_action_choice="modify07"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify08
         LET g_action_choice="modify08"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify09
         LET g_action_choice="modify09"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify10
         LET g_action_choice="modify10"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION modify11
         LET g_action_choice="modify11"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01","AUTO")           #No.FUN-6A0092
 
     #ON ACTION accept
     #   LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY
   
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
    # ON ACTION exporttoexcel   #No.MOD-640284 Mark
    #    LET g_action_choice = 'exporttoexcel'
    #    EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
 
FUNCTION i300_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ocg01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i300_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ocg01",FALSE)
   END IF
 
END FUNCTION
 
#FUN-4C0102
FUNCTION i300_copy()
   DEFINE l_new_ocg01 LIKE ocg_file.ocg01
   DEFINE l_old_ocg01 LIKE ocg_file.ocg01
 
   IF cl_null(g_ocg.ocg01) THEN 
      CALL cl_err('',-400,1)
      RETURN 
   END IF
 
   #MOD-BC0145 ----- add start -----
   LET g_before_input_done = FALSE
   CALL i300_set_entry('a')
   LET g_before_input_done = TRUE
   #MOD-BC0145 ----- add end -----

   LET l_new_ocg01=NULL
   DISPLAY l_new_ocg01 TO ocg01
   INPUT l_new_ocg01 FROM ocg01
 
      AFTER FIELD ocg01
         IF NOT cl_null(l_new_ocg01) THEN
            SELECT COUNT(*) INTO g_cnt FROM ocg_file
             WHERE ocg01=l_new_ocg01
            IF g_cnt > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD ocg01
            END IF
         END IF
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      DISPLAY g_ocg.ocg01 TO ocg01 
      RETURN
   END IF
   IF cl_null(l_new_ocg01) THEN
      DISPLAY g_ocg.ocg01 TO ocg01 
      RETURN
   END IF
 
   DROP TABLE i300_copy_a
   SELECT * FROM ocg_file WHERE ocg01=g_ocg.ocg01 INTO TEMP i300_copy_a
   
   DROP TABLE i300_copy_b
   SELECT * FROM och_file WHERE och01=g_ocg.ocg01 INTO TEMP i300_copy_b
 
   LET g_success='Y'
   BEGIN WORK
   UPDATE i300_copy_a SET ocg01=l_new_ocg01,ocgacti = 'Y',
                       ocguser = g_user,ocggrup = g_grup,
                       ocgdate = g_today
   IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
      LET g_success='N'
   END IF
   UPDATE i300_copy_b SET och01=l_new_ocg01
   IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
      LET g_success='N'
   END IF
   INSERT INTO ocg_file SELECT * FROM i300_copy_a
   IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
      LET g_success='N'
   END IF
   INSERT INTO och_file SELECT * FROM i300_copy_b
   IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('copy','asr-026',0)
      LET l_old_ocg01=g_ocg.ocg01
      SELECT * INTO g_ocg.* FROM ocg_file
                           WHERE ocg01=l_new_ocg01
      CALL i300_u()
      #SELECT * INTO g_ocg.* FROM ocg_file          #FUN-C80046
      #                     WHERE ocg01=l_old_ocg01 #FUN-C80046
   ELSE
      CALL cl_err('copy','9050',1)
      ROLLBACK WORK
   END IF
   CALL i300_show()
END FUNCTION

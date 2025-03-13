# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi140.4gl
# Descriptions...: 產品價格維護作業
# Date & Author..: 94/12/16 By Danny
#                  and obg06改為10碼 By WUPN
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0099 05/02/15 By kim 報表轉XML功能
# Modify.........: No.FUN-550091 05/05/25 By Smapmin 單身新增地區欄位
# Modify.........: No.MOD-560200 05/07/05 By Yiting 單身修改時名字會不見
# Modify.........: No.TQC-640057 06/04/08 By Echo 單頭產品分類使用開窗選擇後帶出值return後,分類名稱沒有立即display!
# Modify.........: No.TQC-640101 06/04/08 By cl   修正查詢產品編號后所帶出品名錯誤的問題,將cl_show_fld_cont() mark后，顯示正常
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-5A0060 06/06/15 By Sarah 增加列印ima021規格
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6A0160 06/12/11 By Claire 欄名誤key
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740137 07/04/21 By Carrier 輸入單位時,若輸入值為'*'時,加報錯信息
# Modify.........: No.TQC-740135 07/04/26 By arman 產品選擇分類之后，“產品編號”開窗卻可以選出不是此類的產品 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790069 07/09/12 By lumxa  打印多出一空白頁
# Modify.........: No.MOD-790123 07/09/21 By Carol 調整input 料號查詢方式 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.FUN-840020 08/04/10 By zhaijie 報表輸出改為CR
# Modify.........: NO.FUN-840108 08/04/29 By Carrier 單身客戶輸入值為非*時,將客戶慣用稅別occ41 DEFAULT給obg10
# Modify.........: No.FUN-8B0112 08/11/26 By Smapmin 單身輸入單位時,右下角增加顯示該料號的銷售單位
# Modify.........: No.TQC-930040 09/03/05 By chenyu 1.修改時單身單位輸入不存在的值，直接確定不會報錯
#                                                   2.單身定價不可以輸入負值
# Modify.........: No.FUN-950109 09/09/01 By chenmoyan 灰掉"更改"按鈕
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A40030 10/04/14 By Smapmin add obgdate
# Modify.........: No:CHI-A40047 10/05/10 By Summer 增加可以查詢單身
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao mod
# Modify.........: No:MOD-B30002 11/03/01 By Summer 將BEFORE ROW CALL cl_show_fld_cont() mark解開
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B80210 11/08/19 By johung 修正成功刪除單身卻顯示錯誤訊息
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C90158 12/09/19 By SunLM 如果选定地区，那么应该自动带出国家和区域。 
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_obf           RECORD LIKE obf_file.*,       
    g_obf_t         RECORD LIKE obf_file.*,      
    g_obf_o         RECORD LIKE obf_file.*,     
    g_obf01_t       LIKE obf_file.obf01,       
    g_obf02_t       LIKE obf_file.obf01,       
    g_oba02         LIKE oba_file.oba02,
    g_ima02         LIKE ima_file.ima02,
    g_obg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        obg03       LIKE obg_file.obg03,
        obg04       LIKE obg_file.obg04,
        obg05       LIKE obg_file.obg05,
        obg06       LIKE obg_file.obg06,
        obg22       LIKE obg_file.obg22,      #FUN-550091
        obg07       LIKE obg_file.obg07,
        obg08       LIKE obg_file.obg08,
        obg09       LIKE obg_file.obg09,
        obg10       LIKE obg_file.obg10,
        obg21       LIKE obg_file.obg21,
        obguser     LIKE obg_file.obguser,
        gen02       LIKE gen_file.gen02, 
        obgdate     LIKE obg_file.obgdate   #FUN-A40030  
                    END RECORD,
    g_obg_t         RECORD    #程式變數(Program Variables)
        obg03       LIKE obg_file.obg03,
        obg04       LIKE obg_file.obg04,
        obg05       LIKE obg_file.obg05,
        obg06       LIKE obg_file.obg06,
        obg22       LIKE obg_file.obg22,     #FUN-550091
        obg07       LIKE obg_file.obg07,
        obg08       LIKE obg_file.obg08,
        obg09       LIKE obg_file.obg09,
        obg10       LIKE obg_file.obg10,
        obg21       LIKE obg_file.obg21,
        obguser     LIKE obg_file.obguser,
        gen02       LIKE gen_file.gen02,   
        obgdate     LIKE obg_file.obgdate   #FUN-A40030  
                    END RECORD,
#    g_wc,g_wc2,g_sql    LIKE type_file.chr1000,    #NO.TQC-630166 mark     #No.FUN-680137  VARCHAR(300)
    g_wc,g_wc2,g_sql     STRING,  #NO.TQC-630166    
    g_sql_tmp       STRING,       #CHI-A40047
    g_rec_b         LIKE type_file.num5,            #單身筆數               #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,            #目前處理的ARRAY CNT    #No.FUN-680137 SMALLINT
    l_cmd           LIKE type_file.chr1000,         #No.FUN-680137  VARCHAR(200)
    g_buf           LIKE ima_file.ima01,          #No.FUN-680137  VARCHAR(40)
    g_buf1          LIKE ima_file.ima01           #No.FUN-680137  VARCHAR(40)
DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL     
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680137 SMALLINT
 
#主程式開始
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
#NO.FUN-840020---start---
DEFINE l_table        STRING
DEFINE g_str          STRING
#NO.FUN-840020---end----
MAIN
#DEFINE       l_time    LIKE type_file.chr8            #No.FUN-6A0094
 
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
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
#NO.FUN-840020---start---
   LET g_sql = "obf01.obf_file.obf01,",
               "obf02.obf_file.obf02,",
               "obg03.obg_file.obg03,",
               "obg04.obg_file.obg04,",
               "obg05.obg_file.obg05,",
               "obg06.obg_file.obg06,",
               "obg22.obg_file.obg22,",
               "obg07.obg_file.obg07,",
               "obg08.obg_file.obg08,",
               "obg09.obg_file.obg09,",
               "obg10.obg_file.obg10,",
               "gec04.gec_file.gec04,",
               "obg21.obg_file.obg21,",
               "obguser.obg_file.obguser,",
               "obgdate.obg_file.obgdate,",   #FUN-A40030
               "l_oba02.oba_file.oba02,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "t_azi03.azi_file.azi03"               
   LET l_table = cl_prt_temptable('axmi140',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               #"        ?,?,?,?,?, ?,?,?)"   #FUN-A40030
               "        ?,?,?,?,?, ?,?,?,?)"   #FUN-A40030
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF
#NO.FUN-840020---end----
    LET g_forupd_sql = "SELECT * FROM obf_file WHERE obf01 = ? AND obf02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i140_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 12
 
    OPEN WINDOW i140_w AT p_row,p_col              #顯示畫面
         WITH FORM "axm/42f/axmi140"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
 
   # SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05  #幣別檔小數位數讀取  #No.CHI-6A0004
   #   FROM azi_file                        #No.CHI-6A0004
   #  WHERE azi01=g_aza.aza17               #No.CHI-6A0004
    CALL i140_menu()
 
    CLOSE WINDOW i140_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION i140_cs()
 
    CLEAR FORM                             #清除畫面
    CALL g_obg.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_obf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON obf01,obf02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                  
           CASE
              WHEN INFIELD(obf01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oba"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obf01
                   NEXT FIELD obf01
              WHEN INFIELD(obf02)
#FUN-AA0059---------mod------------str-----------------               
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_ima"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'') 
                     RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO obf02
                   NEXT FIELD obf02
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
 
    #CHI-A40047 add --start--
    CONSTRUCT g_wc2 ON obg03,obg04,obg05,obg06,obg22,obg07,obg08,obg09,
                       obg10,obg21,obguser,obgdate
            FROM s_obg[1].obg03,s_obg[1].obg04,s_obg[1].obg05,
                 s_obg[1].obg06,s_obg[1].obg22,s_obg[1].obg07,
                 s_obg[1].obg08,s_obg[1].obg09,s_obg[1].obg10,
                 s_obg[1].obg21,s_obg[1].obguser,s_obg[1].obgdate
       BEFORE CONSTRUCT
              CALL cl_qbe_init()

       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(obg03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg03
                   NEXT FIELD obg03
             WHEN INFIELD(obg06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg06
                   NEXT FIELD obg06
             WHEN INFIELD(obg04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oab"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg04
                   NEXT FIELD obg04
              WHEN INFIELD(obg05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oah"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg05
                   NEXT FIELD obg05
              WHEN INFIELD(obg10)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gec"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg10
                   NEXT FIELD obg10
              WHEN INFIELD(obg08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gea"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg08
                   NEXT FIELD obg08
              WHEN INFIELD(obg22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_geo"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg22
                   NEXT FIELD obg22
              WHEN INFIELD(obg07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_geb"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg07
                   NEXT FIELD obg07
              WHEN INFIELD(obg09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azi"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obg09
                   NEXT FIELD obg09
              WHEN INFIELD(obguser) #人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO obguser
                   NEXT FIELD obguser
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

       ON ACTION qbe_save
          CALL cl_qbe_save()

    END CONSTRUCT

    IF INT_FLAG THEN RETURN END IF
    #CHI-A40047 add --end--

    #LET g_wc2=" 1=1"  #CHI-A40047 mark
                 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT obf01,obf02 FROM obf_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1,2"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT obf01,obf02 ",
                   "  FROM obf_file, obg_file",
                   " WHERE obf01 = obg01",
                   "   AND obf02 = obg02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1,2"
    END IF
 
    PREPARE i140_prepare FROM g_sql
    DECLARE i140_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i140_prepare
 
    #CHI-A40047 mark --start #COUNT的語法有錯
    #IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
    #    LET g_sql="SELECT COUNT(*) FROM obf_file WHERE ",g_wc CLIPPED
    #ELSE
    #    LET g_sql="SELECT COUNT(DISTINCT obf01,obf02) FROM obf_file,obg_file",
    #              " WHERE obg01=obf01 AND obg02=obf02 ",
    #              "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    #END IF
    #CHI-A40047 mark --end--

    #CHI-A40047 add --start--
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT DISTINCT obf01,obf02 FROM obf_file",
                   " WHERE ", g_wc CLIPPED
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT obf01,obf02 ",
                   "  FROM obf_file, obg_file",
                   " WHERE obf01 = obg01",
                   "   AND obf02 = obg02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF

    LET g_sql_tmp = g_sql," INTO TEMP x"  
    DROP TABLE x
    PREPARE i140_precount_x FROM g_sql_tmp 
    EXECUTE i140_precount_x

    LET g_sql="SELECT COUNT(*) FROM x "
    #CHI-A40047 add --end--

    PREPARE i140_precount FROM g_sql
    DECLARE i140_count CURSOR FOR i140_precount
END FUNCTION
 
FUNCTION i140_menu()
 
   WHILE TRUE
      CALL i140_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i140_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i140_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i140_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i140_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i140_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth()
               THEN CALL i140_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
## No:2368 modify 1998/07/16 ------------
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_obg),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_obf.obf01 IS NOT NULL THEN
                LET g_doc.column1 = "obf01"
                LET g_doc.column2 = "obf02"
                LET g_doc.value1 = g_obf.obf01
                LET g_doc.value2 = g_obf.obf02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0079-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i140_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_obg.clear()
    INITIALIZE g_obf.* LIKE obf_file.*             #DEFAULT 設定
 
    LET g_obf01_t = NULL
    LET g_obf_o.* = g_obf.*
    LET g_obf.obf01='*'
    LET g_obf.obf02='*'
 
    CALL cl_opmsg('a')
 
    WHILE TRUE
        CALL i140_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_obf.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_obf.obf01 IS NULL OR g_obf.obf02 IS NULL THEN      # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO obf_file(obf01,obf02) VALUES(g_obf.obf01,g_obf.obf02)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_obf.obf01,SQLCA.sqlcode,1)   #No.FUN-660167
            CALL cl_err3("ins","obf_file",g_obf.obf01,g_obf.obf02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        SELECT obf01,obf02 INTO g_obf.obf01,g_obf.obf02 FROM obf_file
            WHERE obf01 = g_obf.obf01
              AND obf02 = g_obf.obf02
 
        LET g_obf01_t = g_obf.obf01        #保留舊值
        LET g_obf02_t = g_obf.obf02        #保留舊值
        LET g_obf_t.* = g_obf.*
 
        CALL g_obg.clear()
        LET g_rec_b = 0 
 
        CALL i140_b()                   #輸入單身
 
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i140_u()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_obf.obf01 IS NULL OR g_obf.obf02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_obf01_t = g_obf.obf01
    LET g_obf02_t = g_obf.obf02
    LET g_obf_o.* = g_obf.*
 
    BEGIN WORK
 
    OPEN i140_cl USING g_obf.obf01,g_obf.obf02
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i140_cl ROLLBACK WORK RETURN
    END IF
 
    FETCH i140_cl INTO g_obf.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i140_cl ROLLBACK WORK RETURN
    END IF
    CALL i140_show()
    WHILE TRUE
        LET g_obf01_t = g_obf.obf01
        LET g_obf02_t = g_obf.obf02
        CALL i140_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_obf.*=g_obf_t.*
            CALL i140_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_obf.obf01 != g_obf01_t OR g_obf.obf02 != g_obf02_t THEN  
            UPDATE obg_file SET obg01 = g_obf.obf01,
                                obg02 = g_obf.obf02 
                WHERE obg01 = g_obf01_t
                  AND obg02 = g_obf02_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('obg',SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("upd","obg_file",g_obf01_t,g_obf02_t,SQLCA.sqlcode,"","obg",1)  #No.FUN-660167
                CONTINUE WHILE 
            END IF
        END IF
        UPDATE obf_file SET obf01 = g_obf.obf01,
                            obf02 = g_obf.obf02 
            WHERE obf01 = g_obf01_t AND obf02=g_obf02_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","obf_file",g_obf01_t,g_obf02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i140_cl
    COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i140_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入 #No.FUN-680137 VARCHAR(1)
    l_count         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_n1            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd           LIKE type_file.chr1           #a:輸入 u:更改          #No.FUN-680137 VARCHAR(1)
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_obf.obf01,g_obf.obf02 WITHOUT DEFAULTS 
 
        BEFORE FIELD obf01                  
          IF p_cmd = 'u' AND g_chkey = 'N' THEN RETURN END IF
 
        AFTER FIELD obf01
          IF cl_null(g_obf.obf01) THEN
             NEXT FIELD obf01
          END IF
          IF g_obf.obf01 != '*' THEN
             SELECT oba02 INTO g_buf FROM oba_file WHERE oba01=g_obf.obf01
             IF STATUS THEN 
#               CALL cl_err('select oba',STATUS,0)   #No.FUN-660167
                CALL cl_err3("sel","oba_file",g_obf.obf01,"",STATUS,"","select oba",1)  #No.FUN-660167
                NEXT FIELD obf01
             END IF
             DISPLAY g_buf TO oba02 
          END IF
          IF g_obf.obf01 = '*' THEN DISPLAY ' ' TO oba02 END IF
        AFTER FIELD obf02      
          IF cl_null(g_obf.obf02) THEN
             NEXT FIELD obf02
          END IF
          IF g_obf.obf02 !='*' THEN                #FUN-AB0025
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_obf.obf02,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_obf.obf02= g_obf02_t
                NEXT FIELD obf02
             END IF
#FUN-AA0059 ---------------------end-------------------------------
#          IF g_obf.obf02 !='*' THEN                #FUN-AB0025  mark
             SELECT ima02,ima021 INTO g_buf,g_buf1 FROM ima_file 
                  WHERE ima01=g_obf.obf02
             IF STATUS THEN
#               CALL cl_err('select ima',STATUS,0)   #No.FUN-660167
                CALL cl_err3("sel","ima_file",g_obf.obf02,"",STATUS,"","select ima",1)  #No.FUN-660167
                NEXT FIELD obf02
             END IF
             DISPLAY g_buf TO ima02 
             DISPLAY g_buf1 TO ima021 
          END IF
          IF g_obf.obf02 = '*' THEN
             DISPLAY ' ',' ' TO ima02,ima021
          END IF
          SELECT count(*) INTO g_cnt FROM obf_file
                                    WHERE obf01 = g_obf.obf01
                                      AND obf02 = g_obf.obf02
          IF g_cnt > 0 THEN   #資料重複
             CALL cl_err('select obf',-239,0)
             LET g_obf.obf01 = g_obf01_t
             LET g_obf.obf02 = g_obf02_t
             DISPLAY BY NAME g_obf.obf01 
             DISPLAY BY NAME g_obf.obf02 
             DISPLAY ' ' TO oba02
             DISPLAY ' ' TO ima02
             DISPLAY ' ' TO ima021
             NEXT FIELD obf01
          END IF
	      LET g_obf_o.obf01 = g_obf.obf01
	      LET g_obf_o.obf02 = g_obf.obf02
          IF g_obf.obf01 ='*' AND g_obf.obf02 ='*' THEN
             CALL cl_err('','axm-000',0)
             NEXT FIELD obf01
          END IF
             
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlp                  
           CASE
              WHEN INFIELD(obf01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oba"
                   LET g_qryparam.default1 = g_obf.obf01
                   CALL cl_create_qry() RETURNING g_obf.obf01
#                   CALL FGL_DIALOG_SETBUFFER( g_obf.obf01 )
                   DISPLAY BY NAME g_obf.obf01 
                   #TQC-640057
                   IF g_obf.obf01 != '*' THEN
                      SELECT oba02 INTO g_buf FROM oba_file WHERE oba01=g_obf.obf01
                      IF STATUS THEN 
#                        CALL cl_err('select oba',STATUS,0)   #No.FUN-660167
                         CALL cl_err3("sel","oba_file",g_obf.obf01,"",STATUS,"","select oba",1)  #No.FUN-660167
                         NEXT FIELD obf01
                      END IF
                   ELSE
                      LET g_buf = ' '
                   END IF
                   DISPLAY g_buf TO oba02 
                   #END TQC-640057
                   NEXT FIELD obf01
              WHEN INFIELD(obf02)
#FUN-AA0059---------mod------------str-----------------               
#                   CALL cl_init_qry_var()                             #FUN-AA0059 mark
#                   LET g_qryparam.form ="q_ima"     #NO.TQC-740135    #FUN-AA0059 mark
#MOD-790123-modify
                   IF g_obf.obf01 = '*' THEN 
#                     LET g_qryparam.form ="q_ima"                    #FUN-AA0059 mark   
                      CALL q_sel_ima(FALSE, "q_ima","",g_obf.obf02,"","","","","",'' ) #FUN-AA0059 add
                          RETURNING   g_obf.obf02                                      #FUN-AA0059 add
                   ELSE  
#                      LET g_qryparam.form ="q_ima03"   #NO.TQC-740135                 #FUN-AA0059 mark    
#                      LET g_qryparam.arg1 = g_obf.obf01 #No.TQC-740135                #FUN-AA0059 mark
                       CALL q_sel_ima(FALSE, "q_ima03","",g_obf.obf02,g_obf.obf01,"","","","",'' ) #FUN-AA0059 add
                          RETURNING   g_obf.obf02                                                  #FUN-AA0059 add
                   END IF
#MOD-790123-modify-end
#                   LET g_qryparam.default1 = g_obf.obf02              #FUN-AA0059 mark
#                   CALL cl_create_qry() RETURNING g_obf.obf02         #FUN-AA0059 mark 
#                  CALL FGL_DIALOG_SETBUFFER( g_obf.obf02 )            #FUN-AA0059 mark
#FUN-AA0059---------mod------------end-----------------
 
                   DISPLAY BY NAME g_obf.obf02 
                   NEXT FIELD obf02
            END CASE
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(obf01) THEN
       #        LET g_obf.* = g_obf_t.*
       #        DISPLAY BY NAME g_obf.* 
       #        NEXT FIELD obf01
       #     END IF
       #MOD-650015 --start
        ON ACTION CONTROLR
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
FUNCTION i140_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obf.* TO NULL              #No.FUN-6B0079 add
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i140_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_obf.* TO NULL
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
    OPEN i140_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_obf.* TO NULL
    ELSE
       OPEN i140_count
       FETCH i140_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i140_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i140_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
      WHEN 'N' FETCH NEXT     i140_cs INTO g_obf.obf01,g_obf.obf02
      WHEN 'P' FETCH PREVIOUS i140_cs INTO g_obf.obf01,g_obf.obf02
      WHEN 'F' FETCH FIRST    i140_cs INTO g_obf.obf01,g_obf.obf02
      WHEN 'L' FETCH LAST     i140_cs INTO g_obf.obf01,g_obf.obf02
      WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
           FETCH ABSOLUTE g_jump i140_cs INTO g_obf.obf01,g_obf.obf02
           LET mi_no_ask = FALSE
    END CASE
    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0)
        INITIALIZE g_obf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","obf_file",g_obf.obf01,g_obf.obf02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_obf.* TO NULL
        RETURN
    END IF
    LET g_data_owner = ''      #FUN-4C0057 add
    LET g_data_group = ''      #FUN-4C0057 add
    CALL i140_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i140_show()
 
    LET g_obf_t.* = g_obf.*                #保存單頭舊值
    DISPLAY BY NAME g_obf.obf01,g_obf.obf02 
 
    LET g_buf = NULL
    SELECT oba02 INTO g_buf FROM oba_file 
     WHERE oba01=g_obf.obf01
    DISPLAY g_buf TO oba02 
 
    LET g_buf = NULL
    SELECT ima02,ima021 INTO g_buf,g_buf1 FROM ima_file 
     WHERE ima01=g_obf.obf02   #MOD-6A0160 modify ->I
    DISPLAY g_buf TO ima02 LET g_buf = NULL
    DISPLAY g_buf1 TO ima021 LET g_buf1 = NULL
 
    CALL i140_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i140_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1       #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_obf.obf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i140_cl USING g_obf.obf01,g_obf.obf02
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i140_cl ROLLBACK WORK RETURN
    END IF
 
    FETCH i140_cl INTO g_obf.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0) 
       CLOSE i140_cl ROLLBACK WORK RETURN 
    END IF
 
    CALL i140_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "obf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "obf02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_obf.obf01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_obf.obf02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM obf_file WHERE obf01 = g_obf.obf01
                               AND obf02 = g_obf.obf02
        DELETE FROM obg_file WHERE obg01 = g_obf.obf01
                               AND obg02 = g_obf.obf02
        IF SQLCA.sqlcode   THEN 
#          CALL cl_err(g_obf.obf01,SQLCA.sqlcode,0)   #No.FUN-660167
           CALL cl_err3("del","obg_file",g_obf.obf01,g_obf.obf02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
        ELSE
           CLEAR FORM
           CALL g_obg.clear()
           INITIALIZE g_obf.* LIKE obf_file.*             #DEFAULT 設定
           OPEN i140_count
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE i140_cs
              CLOSE i140_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end--
           FETCH i140_count INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i140_cs
              CLOSE i140_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i140_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i140_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i140_fetch('/')
           END IF
        END IF
 
    END IF
 
    CLOSE i140_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i140_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否         #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態           #No.FUN-680137 VARCHAR(1)
    l_gec01         LIKE gec_file.gec01,
    l_count         LIKE type_file.num5,                                    #No.FUN-680137 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否           #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否           #No.FUN-680137 SMALLINT
DEFINE l_occ41      LIKE occ_file.occ41                 #No.FUN-840108
DEFINE l_ima31      LIKE ima_file.ima31   #FUN-8B0112
DEFINE l_msg        STRING   #FUN-8B0112
 
    LET g_action_choice = ""
    IF g_obf.obf01 IS NULL THEN RETURN END IF
 
    SELECT MIN(gec01) INTO l_gec01 FROM gec_file WHERE gec011='2'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
        #"SELECT obg03,obg04,obg05,obg06,obg07,obg08,obg09,obg10,obg21,",   #FUN-550091
        "SELECT obg03,obg04,obg05,obg06,obg22,obg07,obg08,obg09,obg10,obg21,",   #FUN-550091
        #" obguser  FROM obg_file ",   #FUN-A40030
        " obguser,'',obgdate  FROM obg_file ",   #FUN-A40030
        "  WHERE obg01 = ? AND obg02 = ? AND obg03 = ? AND obg04 = ? ",
        #"   AND obg05 = ? AND obg06 = ? AND obg07 = ? AND obg08 = ? ",   #FUN-550091
        "   AND obg05 = ? AND obg06 = ? AND obg22 = ? AND obg07 = ? AND obg08 = ? ",   #FUN-550091
        "   AND obg09 = ? AND obg10 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i140_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_obg WITHOUT DEFAULTS FROM s_obg.* 
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
               BEGIN WORK
 
               LET p_cmd='u'
               LET g_obg_t.* = g_obg[l_ac].*  #BACKUP
 
               OPEN i140_bcl USING g_obf.obf01, g_obf.obf02, g_obg_t.obg03,  
                                   g_obg_t.obg04, g_obg_t.obg05, g_obg_t.obg06, 
                                   #g_obg_t.obg07, g_obg_t.obg08, g_obg_t.obg09,    #FUN-550091
                                   g_obg_t.obg22,g_obg_t.obg07, g_obg_t.obg08, g_obg_t.obg09,    #FUN-550091
                                   g_obg_t.obg10  
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_obg_t.obg03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i140_bcl INTO g_obg[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_obg_t.obg03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
                   #MOD-560200
                  CALL i140_obguser('a',g_obg[l_ac].obguser)
                     RETURNING g_obg[l_ac].gen02
                  #-end
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_obg[l_ac].* TO NULL      #900423
            LET g_obg[l_ac].obg04='*'
            LET g_obg[l_ac].obg05='*'
            LET g_obg[l_ac].obg06='*'
            LET g_obg[l_ac].obg22='*'  #FUN-550091
            LET g_obg[l_ac].obg07='*'
            LET g_obg[l_ac].obg08='*'
            LET g_obg[l_ac].obg09=g_aza.aza17
            LET g_obg[l_ac].obg10=l_gec01
            LET g_obg[l_ac].obg21=0
            LET g_obg_t.* = g_obg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obg03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO obg_file(obg01,obg02,obg03,obg04,obg05, #No.MOD-470041
                                 #obg06,obg07,obg08,obg09,obg10,   #FUN-550091
                                 obg06,obg22,obg07,obg08,obg09,obg10,   #FUN-550091
                                 obg21,obguser,obgdate,obgoriu,obgorig) 
                          VALUES(g_obf.obf01,g_obf.obf02,
                          g_obg[l_ac].obg03,g_obg[l_ac].obg04,
                          g_obg[l_ac].obg05,g_obg[l_ac].obg06,
                          #g_obg[l_ac].obg07,g_obg[l_ac].obg08,   #FUN-550091
                          g_obg[l_ac].obg22,g_obg[l_ac].obg07,g_obg[l_ac].obg08,   #FUN-550091
                          g_obg[l_ac].obg09,g_obg[l_ac].obg10,
                          g_obg[l_ac].obg21,g_obg[l_ac].obguser,
                          #g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A40030
                          g_obg[l_ac].obgdate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig   #FUN-A40030
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_obg[l_ac].obg03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","obg_file",g_obf.obf01,g_obg[l_ac].obg03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
            END IF
 
        #-----FUN-8B0112---------
        BEFORE FIELD obg03
           SELECT ima31 INTO l_ima31 FROM ima_file
             WHERE ima01=g_obf.obf02
           LET l_msg = cl_getmsg('asm-324',g_lang),":",l_ima31
           CALL cl_msg(l_msg) 
        #-----END FUN-8B0112-----
 
        #No.TQC-930040 add --begin
        AFTER FIELD obg03
           IF NOT cl_null(g_obg[l_ac].obg03) THEN 
              IF g_obg[l_ac].obg03='*' THEN
                 CALL cl_err(g_obg[l_ac].obg03,'axm-157',0)  #No.TQC-740137
                 NEXT FIELD obg03 
              END IF
              IF g_obg[l_ac].obg03 != '*' THEN
                 SELECT COUNT(*) INTO l_count FROM gfe_file
                  WHERE gfe01=g_obg[l_ac].obg03
                 IF l_count = 0 THEN
                    CALL cl_err('select gfe',STATUS,0)
                    NEXT FIELD obg03
                 END IF
              END IF
              IF cl_null(g_obg[l_ac].obguser) THEN
                 LET g_obg[l_ac].obguser=g_user
              END IF
              DISPLAY BY NAME g_obg[l_ac].obguser 
              #-----FUN-A40030---------
              IF cl_null(g_obg[l_ac].obgdate) THEN
                 LET g_obg[l_ac].obgdate=g_today
              END IF
              DISPLAY BY NAME g_obg[l_ac].obgdate 
              #-----END FUN-A40030-----
           END IF
        #No.TQC-930040 add --end
 
        BEFORE FIELD obg04
           IF NOT cl_null(g_obg[l_ac].obg03) THEN 
              IF g_obg[l_ac].obg03='*' THEN
                 CALL cl_err(g_obg[l_ac].obg03,'axm-157',0)  #No.TQC-740137
                 NEXT FIELD obg03 
              END IF
 
              IF g_obg[l_ac].obg03 != '*' THEN
                 SELECT COUNT(*) INTO l_count FROM gfe_file
                  WHERE gfe01=g_obg[l_ac].obg03
                 IF l_count = 0 THEN
                    CALL cl_err('select gfe',STATUS,0)
                    NEXT FIELD obg03
                 END IF
              END IF
             
              IF cl_null(g_obg[l_ac].obguser) THEN
                 LET g_obg[l_ac].obguser=g_user
              END IF
              DISPLAY BY NAME g_obg[l_ac].obguser 
              #-----FUN-A40030---------
              IF cl_null(g_obg[l_ac].obgdate) THEN
                 LET g_obg[l_ac].obgdate=g_today
              END IF
              DISPLAY BY NAME g_obg[l_ac].obgdate 
              #-----END FUN-A40030-----
 
           END IF
 
        AFTER FIELD obg04
           IF NOT cl_null(g_obg[l_ac].obg04) THEN
              IF g_obg[l_ac].obg04 != '*' THEN
                 SELECT oab02 INTO g_buf FROM oab_file
                  WHERE oab01=g_obg[l_ac].obg04
                 IF SQLCA.SQLCODE THEN  #No.7926
#                   CALL cl_err('select oab',SQLCA.SQLCODE,0)   #No.FUN-660167
                    CALL cl_err3("sel","oab_file",g_obg[l_ac].obg04,"",SQLCA.SQLCODE,"","select oab",1)  #No.FUN-660167
                    NEXT FIELD obg04
                 END IF
                 MESSAGE g_buf CLIPPED 
              END IF
           END IF
 
        AFTER FIELD obg05
           IF NOT cl_null(g_obg[l_ac].obg05) THEN
              IF g_obg[l_ac].obg05 != '*' THEN
                 SELECT oah02 INTO g_buf FROM oah_file
                  WHERE oah01=g_obg[l_ac].obg05
                 IF SQLCA.SQLCODE  THEN  #No.7926
#                   CALL cl_err('select oah',SQLCA.SQLCODE,0)   #No.FUN-660167
                    CALL cl_err3("sel","oah_file",g_obg[l_ac].obg05,"",SQLCA.SQLCODE,"","select oah",1)  #No.FUN-660167
                    NEXT FIELD obg05
                 END IF
                 MESSAGE g_buf CLIPPED 
              END IF
           END IF
 
        AFTER FIELD obg06
           IF NOT cl_null(g_obg[l_ac].obg06) THEN
              IF g_obg[l_ac].obg06 != '*' THEN
                 #No.FUN-840108  --Begin
                 SELECT occ02,occ41 INTO g_buf,l_occ41 FROM occ_file
                  WHERE occ01=g_obg[l_ac].obg06 AND occacti='Y'
                 #No.FUN-840108  --End  
                 IF SQLCA.SQLCODE  THEN  #No.7926
#                   CALL cl_err('select occ',SQLCA.SQLCODE,0)   #No.FUN-660167
                    CALL cl_err3("sel","occ_file",g_obg[l_ac].obg06,"",SQLCA.SQLCODE,"","select occ",1)  #No.FUN-660167
                    NEXT FIELD obg06
                 END IF
                 MESSAGE g_buf CLIPPED 
                 #No.FUN-840108  --Begin
                 #客戶編號修改后,DEFAULT慣用稅別
                 IF l_occ41 IS NOT NULL THEN
                    IF p_cmd = 'a' OR 
                      (p_cmd = 'u' AND g_obg_t.obg06 != g_obg[l_ac].obg06) THEN
                       LET g_obg[l_ac].obg10 = l_occ41
                       DISPLAY BY NAME g_obg[l_ac].obg10 
                    END IF
                 END IF
                 #No.FUN-840108  --End
              END IF
           END IF
#FUN-550091
        AFTER FIELD obg22
           IF NOT cl_null(g_obg[l_ac].obg22) THEN
              IF g_obg[l_ac].obg22 != '*' THEN
                 SELECT geo02 INTO g_buf FROM geo_file
                  WHERE geo01=g_obg[l_ac].obg22
                 IF SQLCA.SQLCODE  THEN  #No.7926
#                   CALL cl_err('select geo',SQLCA.SQLCODE,0)   #No.FUN-660167
                    CALL cl_err3("sel","geo_file",g_obg[l_ac].obg22,"",SQLCA.SQLCODE,"","select geo",1)  #No.FUN-660167
                    NEXT FIELD obg22
                 END IF
                 MESSAGE g_buf CLIPPED 
#MOD-C90158 add beg--------
                 SELECT geo03 INTO g_obg[l_ac].obg07 FROM geo_file
                  WHERE geo01 = g_obg[l_ac].obg22 
                 IF NOT cl_null(g_obg[l_ac].obg07) AND g_obg[l_ac].obg07 != '*' THEN
                 	  SELECT geb03 INTO g_obg[l_ac].obg08  FROM geb_file
                 	   WHERE geb01 = g_obg[l_ac].obg07
                 END IF 	
                 DISPLAY BY NAME g_obg[l_ac].obg07,g_obg[l_ac].obg08
#MOD-C90158 add end--------                  
              END IF
           END IF
#END FUN-550091
        AFTER FIELD obg07
           IF NOT cl_null(g_obg[l_ac].obg07) THEN
              IF g_obg[l_ac].obg07 != '*' THEN
                 SELECT geb02 INTO g_buf FROM geb_file
                  WHERE geb01=g_obg[l_ac].obg07
                 IF SQLCA.SQLCODE  THEN  #No.7926
#                   CALL cl_err('select geb',SQLCA.SQLCODE,0)   #No.FUN-660167
                    CALL cl_err3("sel","geb_file",g_obg[l_ac].obg07,"",SQLCA.SQLCODE,"","select geb",1)  #No.FUN-660167
                    NEXT FIELD obg07
                 END IF
                 MESSAGE g_buf CLIPPED 
#MOD-C90158 add beg--------
                 SELECT geb03 INTO g_obg[l_ac].obg08  FROM geb_file
                 	WHERE geb01 = g_obg[l_ac].obg07
                 DISPLAY BY NAME g_obg[l_ac].obg07,g_obg[l_ac].obg08	
#MOD-C90158 add end--------                  
              END IF
           END IF
 
        AFTER FIELD obg08
           IF NOT cl_null(g_obg[l_ac].obg08) THEN
              IF g_obg[l_ac].obg08 != '*' THEN
                 SELECT gea02 INTO g_buf FROM gea_file
                  WHERE gea01=g_obg[l_ac].obg08
                 IF SQLCA.SQLCODE  THEN  #No.7926
#                   CALL cl_err('select gea',SQLCA.SQLCODE,0)   #No.FUN-660167
                    CALL cl_err3("sel","gea_file",g_obg[l_ac].obg08,"",SQLCA.SQLCODE,"","select gea",1)  #No.FUN-660167
                    NEXT FIELD obg08
                 END IF
                 MESSAGE g_buf CLIPPED 
              END IF
           END IF
 
        AFTER FIELD obg09
           IF NOT cl_null(g_obg[l_ac].obg09) THEN 
              IF g_obg[l_ac].obg09='*' THEN
                 NEXT FIELD obg09
              END IF
              SELECT azi02 INTO g_buf FROM azi_file WHERE azi01=g_obg[l_ac].obg09
              IF SQLCA.SQLCODE THEN  #NO.7926
#                CALL cl_err('select azi',SQLCA.SQLCODE,0)   #No.FUN-660167
                 CALL cl_err3("sel","azi_file",g_obg[l_ac].obg09,"",SQLCA.SQLCODE,"","select azi",1)  #No.FUN-660167
                 NEXT FIELD obg09
              END IF
              MESSAGE g_buf CLIPPED 
           END IF
 
        AFTER FIELD obg10
           IF NOT cl_null(g_obg[l_ac].obg10) THEN
              IF g_obg[l_ac].obg10 != '*' THEN
                 SELECT gec02 INTO g_buf FROM gec_file
                  WHERE gec01=g_obg[l_ac].obg10
                    AND gec011='2'  #銷項
                 IF STATUS THEN
#                   CALL cl_err('select gec',STATUS,0)    #No.FUN-660167
                    CALL cl_err3("sel","gec_file",g_obg[l_ac].obg10,"",STATUS,"","select gec",1)  #No.FUN-660167
                    NEXT FIELD obg10
                 END IF
              END IF 
 
              MESSAGE g_buf CLIPPED 
              IF (g_obg[l_ac].obg03 != g_obg_t.obg03) OR   #NO:4957
                 (g_obg[l_ac].obg04 != g_obg_t.obg04) OR
                 (g_obg[l_ac].obg05 != g_obg_t.obg05) OR
                 (g_obg[l_ac].obg06 != g_obg_t.obg06) OR
                 (g_obg[l_ac].obg22 != g_obg_t.obg22) OR   #FUN-550091
                 (g_obg[l_ac].obg07 != g_obg_t.obg07) OR
                 (g_obg[l_ac].obg08 != g_obg_t.obg08) OR
                 (g_obg[l_ac].obg09 != g_obg_t.obg09) OR
                 (g_obg[l_ac].obg10 != g_obg_t.obg10) OR
                  g_obg_t.obg03 IS NULL OR g_obg_t.obg04 IS NULL OR
                  g_obg_t.obg05 IS NULL OR g_obg_t.obg06 IS NULL OR
                  #g_obg_t.obg07 IS NULL OR g_obg_t.obg08 IS NULL OR   #FUN-550091
                  g_obg_t.obg22 IS NULL OR g_obg_t.obg07 IS NULL OR    #FUN-550091
                  g_obg_t.obg08 IS NULL OR   #FUN-550091
                  g_obg_t.obg09 IS NULL OR g_obg_t.obg10 IS NULL THEN
              
                  SELECT COUNT(*) INTO l_n FROM obg_file
                   WHERE obg01 = g_obf.obf01
                     AND obg02 = g_obf.obf02
                     AND obg03 = g_obg[l_ac].obg03
                     AND obg04 = g_obg[l_ac].obg04
                     AND obg05 = g_obg[l_ac].obg05
                     AND obg06 = g_obg[l_ac].obg06
                     AND obg22 = g_obg[l_ac].obg22   #FUN-550091
                     AND obg07 = g_obg[l_ac].obg07
                     AND obg08 = g_obg[l_ac].obg08
                     AND obg09 = g_obg[l_ac].obg09 
                     AND obg10 = g_obg[l_ac].obg10
                  IF l_n > 0 THEN 
                     CALL cl_err('','axm-298',0)
                     NEXT FIELD obg10
                  END IF
 
              END IF
           END IF
 
        #No.TQC-930040 add --begin
        AFTER FIELD obg21
           IF NOT cl_null(g_obg[l_ac].obg21) THEN
              IF g_obg[l_ac].obg21 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD obg21
              END IF
           END IF
        #No.TQC-930040 add --end
 
        AFTER FIELD obguser
           IF NOT cl_null(g_obg[l_ac].obguser) THEN
              CALL i140_obguser('a',g_obg[l_ac].obguser) 
                   RETURNING g_obg[l_ac].gen02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD obguser
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_obg_t.obg03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM obg_file 
                 WHERE obg01 = g_obf.obf01 
                   AND obg02 = g_obf.obf02
                   AND obg03 = g_obg_t.obg03
                   AND obg04 = g_obg_t.obg04
                   AND obg05 = g_obg_t.obg05
                   AND obg06 = g_obg_t.obg06
                   AND obg22 = g_obg_t.obg22   #FUN-550091
                   AND obg07 = g_obg_t.obg07
                   AND obg08 = g_obg_t.obg08
                   AND obg09 = g_obg_t.obg09
                   AND obg10 = g_obg_t.obg10
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                  CALL cl_err(g_obg_t.obg03,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","obg_file",g_obf.obf01,g_obg_t.obg03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
            END IF
            COMMIT WORK
            LET g_rec_b = g_rec_b - 1   #MOD-B80210 add
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obg[l_ac].* = g_obg_t.*
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
#MOD-C90158 add beg--------
            IF NOT cl_null(g_obg[l_ac].obg22) AND g_obg[l_ac].obg22 != '*' THEN 
               SELECT geo03 INTO g_obg[l_ac].obg07 FROM geo_file
                WHERE geo01 = g_obg[l_ac].obg22 
               IF cl_null(g_obg[l_ac].obg07) THEN LET g_obg[l_ac].obg07 = '*' END IF 
               IF NOT cl_null(g_obg[l_ac].obg07) AND g_obg[l_ac].obg07 != '*' THEN
               	  SELECT geb03 INTO g_obg[l_ac].obg08  FROM geb_file
               	   WHERE geb01 = g_obg[l_ac].obg07
               END IF 	
               DISPLAY BY NAME g_obg[l_ac].obg07,g_obg[l_ac].obg08
            END IF    
#MOD-C90158 add end--------             
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obg[l_ac].obg03,-263,1)
               LET g_obg[l_ac].* = g_obg_t.*
            ELSE
               UPDATE obg_file SET obg03=g_obg[l_ac].obg03,
                                   obg04=g_obg[l_ac].obg04,
                                   obg05=g_obg[l_ac].obg05,
                                   obg06=g_obg[l_ac].obg06,
                                   obg22=g_obg[l_ac].obg22,   #FUN-550091
                                   obg07=g_obg[l_ac].obg07,
                                   obg08=g_obg[l_ac].obg08,
                                   obg09=g_obg[l_ac].obg09,
                                   obg10=g_obg[l_ac].obg10,
                                   obg21=g_obg[l_ac].obg21,
                                   obguser=g_obg[l_ac].obguser,
                                   #obgdate=g_today   #FUN-A40030
                                   obgdate=g_obg[l_ac].obgdate   #FUN-A40030
               WHERE obg01 = g_obf.obf01 
                 AND obg02 = g_obf.obf02  
                 AND obg03 = g_obg_t.obg03  
                 AND obg04 = g_obg_t.obg04  
                 AND obg05 = g_obg_t.obg05  
                 AND obg06 = g_obg_t.obg06  
                 AND obg22 = g_obg_t.obg22   #FUN-550091  
                 AND obg07 = g_obg_t.obg07  
                 AND obg08 = g_obg_t.obg08  
                 AND obg09 = g_obg_t.obg09  
                 AND obg10 = g_obg_t.obg10  
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_obg[l_ac].obg03,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("upd","obg_file",g_obf.obf01,g_obg_t.obg03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 LET g_obg[l_ac].* = g_obg_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
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
                  LET g_obg[l_ac].* = g_obg_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_obg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i140_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D30034 add
            CLOSE i140_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i140_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(obg03) AND l_ac > 1 THEN
                LET g_obg[l_ac].* = g_obg[l_ac-1].*
                NEXT FIELD obg03
            END IF
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(obg03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_obg[l_ac].obg03
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg03
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg03 )
                    DISPLAY BY NAME g_obg[l_ac].obg03            #No.MOD-490371
                   NEXT FIELD obg03
             WHEN INFIELD(obg06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = g_obg[l_ac].obg06
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg06
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg06 )
                    DISPLAY BY NAME g_obg[l_ac].obg06            #No.MOD-490371
                   NEXT FIELD obg06
             WHEN INFIELD(obg04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oab"
                   LET g_qryparam.default1 = g_obg[l_ac].obg04
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg04
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg04 )
                    DISPLAY BY NAME g_obg[l_ac].obg04            #No.MOD-490371
                   NEXT FIELD obg04
              WHEN INFIELD(obg05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oah"
                   LET g_qryparam.default1 = g_obg[l_ac].obg05
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg05
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg05 )
                    DISPLAY BY NAME g_obg[l_ac].obg05            #No.MOD-490371
                   NEXT FIELD obg05
              WHEN INFIELD(obg10)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gec"
                   LET g_qryparam.default1 = g_obg[l_ac].obg10
                   LET g_qryparam.arg1 = '2'              
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg10
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg10 )
                    DISPLAY BY NAME g_obg[l_ac].obg10            #No.MOD-490371
                   NEXT FIELD obg10
              WHEN INFIELD(obg08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gea"
                   LET g_qryparam.default1 = g_obg[l_ac].obg08
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg08
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg08 )
                    DISPLAY BY NAME g_obg[l_ac].obg08            #No.MOD-490371
                   NEXT FIELD obg08
#FUN-550091
              WHEN INFIELD(obg22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_geo"
                   LET g_qryparam.default1 = g_obg[l_ac].obg22
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg22
                    DISPLAY BY NAME g_obg[l_ac].obg22            #No.MOD-490371
                   NEXT FIELD obg22
#END FUN-550091
              WHEN INFIELD(obg07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_geb"
                   LET g_qryparam.default1 = g_obg[l_ac].obg07
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg07
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg07 )
                    DISPLAY BY NAME g_obg[l_ac].obg07            #No.MOD-490371
                   NEXT FIELD obg07
              WHEN INFIELD(obg09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azi"
                   LET g_qryparam.default1 = g_obg[l_ac].obg09
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obg09
#                   CALL FGL_DIALOG_SETBUFFER( g_obg[l_ac].obg09 )
                    DISPLAY BY NAME g_obg[l_ac].obg09            #No.MOD-490371
                   NEXT FIELD obg09
              WHEN INFIELD(obguser) #人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_obg[l_ac].obguser
                   CALL cl_create_qry() RETURNING g_obg[l_ac].obguser
                    DISPLAY BY NAME g_obg[l_ac].obguser          #No.MOD-490371
                   NEXT FIELD obguser
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
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
 
    CLOSE i140_bcl
    COMMIT WORK
    CALL i140_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i140_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  obf_file
               WHERE obf01 = g_obf.obf01
                 AND obf02 = g_obf.obf02
         INITIALIZE g_obf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i140_obguser(p_cmd,p_key)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
         p_key       LIKE gen_file.gen01,
         l_gen02     LIKE gen_file.gen02,
         l_genacti   LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file WHERE gen01 = p_key
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                  LET l_gen02 = NULL
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   RETURN l_gen02
END FUNCTION 
 
FUNCTION i140_delall()
 
    SELECT COUNT(*) INTO g_cnt FROM obg_file
     WHERE obg01=g_obf.obf01
       AND obg02=g_obf.obf02
 
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
 
       DELETE FROM obf_file 
        WHERE obf01 = g_obf.obf01
          AND obf02 = g_obf.obf02
       IF SQLCA.SQLCODE THEN 
#         CALL cl_err('DEL-obf',SQLCA.SQLCODE,0)   #No.FUN-660167
          CALL cl_err3("del","obf_file",g_obf.obf01,g_obf.obf02,SQLCA.SQLCODE,"","DEL-obf",1)  #No.FUN-660167
       END IF
 
    END IF
 
END FUNCTION
 
FUNCTION i140_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    #CONSTRUCT l_wc2 ON obg03,obg04,obg05,obg06,obg07,obg08,obg09,   #FUN-550091
    CONSTRUCT l_wc2 ON obg03,obg04,obg05,obg06,obg22,obg07,obg08,obg09,   #FUN-550091
                       #obg10,obg21,obguser   #FUN-A40030
                       obg10,obg21,obguser,obgdate   #FUN-A40030
            FROM s_obg[1].obg03,s_obg[1].obg04,s_obg[1].obg05,
                 #s_obg[1].obg06,s_obg[1].obg07,s_obg[1].obg08,   #FUN-550091
                 s_obg[1].obg06,s_obg[1].obg22,s_obg[1].obg07,s_obg[1].obg08,   #FUN-550091
                 s_obg[1].obg09,s_obg[1].obg10,
                 #s_obg[1].obg21,s_obg[1].obguser   #FUN-A40030
                 s_obg[1].obg21,s_obg[1].obguser,s_obg[1].obgdate   #FUN-A40030
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i140_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i140_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        #"SELECT obg03,obg04,obg05,obg06,obg07,obg08,obg09,",   #FUN-550091
        "SELECT obg03,obg04,obg05,obg06,obg22,obg07,obg08,obg09,",   #FUN-550091
        #"       obg10,obg21,obguser,''",   #FUN-A40030
        "       obg10,obg21,obguser,'',obgdate",   #FUN-A40030
        " FROM obg_file",
        " WHERE obg01 ='",g_obf.obf01,"'",  #單頭
        "   AND obg02 ='",g_obf.obf02,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE i140_pb FROM g_sql
    DECLARE obg_curs                       #CURSOR
        CURSOR FOR i140_pb
 
    CALL g_obg.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH obg_curs INTO g_obg[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        CALL i140_obguser('a',g_obg[g_cnt].obguser)
             RETURNING g_obg[g_cnt].gen02
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
  
    END FOREACH
    CALL g_obg.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
 
END FUNCTION
 
FUNCTION i140_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obg TO s_obg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()           #TQC-640101--MARK        #No:FUN-550037 hmf #MOD-B30002 remark
 
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
#No.FUN-950109 --Begin
#     ON ACTION modify
#        LET g_action_choice="modify"
#        EXIT DISPLAY
#No.FUN-950109 --End
      ON ACTION first 
         CALL i140_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i140_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i140_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i140_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i140_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
      ON ACTION controls                          #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")      #No.FUN-6A0092 
 
 
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
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i140_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
        obf01       LIKE obf_file.obf01,
        obf02       LIKE obf_file.obf02,
        obg03       LIKE obg_file.obg03,
        obg04       LIKE obg_file.obg04,
        obg05       LIKE obg_file.obg05,
        obg06       LIKE obg_file.obg06,
        obg22       LIKE obg_file.obg22,   #FUN-550091
        obg07       LIKE obg_file.obg07,
        obg08       LIKE obg_file.obg08,
        obg09       LIKE obg_file.obg09,
        obg10       LIKE obg_file.obg10,
        gec04       LIKE gec_file.gec04,
        obg21       LIKE obg_file.obg21,
        obguser     LIKE obg_file.obguser,
        obgdate     LIKE obg_file.obgdate   #FUN-A40030
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name   #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #No.FUN-680137 VARCHAR(40)
#NO.FUN-840020---START---
DEFINE  l_oba02     LIKE oba_file.oba02
DEFINE  l_ima02     LIKE ima_file.ima02
DEFINE  l_ima021    LIKE ima_file.ima021
 
    CALL cl_del_data(l_table)                                 #NO.FUN-840020
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmi140' #NO.FUN-840020
#NO.FUN-840020---END---
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
    CALL cl_wait()
#    CALL cl_outnam('axmi140') RETURNING l_name            #NO.FUN-840020
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
## No:2608 modify 1998/10/23 -----------------------------------
    #LET g_sql="SELECT obf01,obf02,obg03,obg04,obg05,obg06,obg07,",   #FUN-550091
    LET g_sql="SELECT obf01,obf02,obg03,obg04,obg05,obg06,obg22,obg07,",   #FUN-550091
              #"       obg08,obg09,obg10,gec04,obg21,obguser",   #FUN-A40030
              "       obg08,obg09,obg10,'',obg21,obguser,obgdate",   #FUN-A40030   #FUN-A40030 del gec04
              #" FROM obf_file,obg_file LEFT OUTER JOIN gec_file ON ogb_file.ogb10=gec_file.gec01 ",   #FUN-A40030
              " FROM obf_file,obg_file ",   #FUN-A40030
              " WHERE obf01 = obg01 ",
              "   AND obf02 = obg02 ",
              #"   AND gec_file.gec011='2' ",   #FUN-A40030
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,2,3 "
## 
    PREPARE i140_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i140_co                         # CURSOR
        CURSOR FOR i140_p1
 
#    START REPORT i140_rep TO l_name                       #NO.FUN-840020
 
    FOREACH i140_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)  
           EXIT FOREACH
        END IF
#        OUTPUT TO REPORT i140_rep(sr.*)                   #NO.FUN-840020
        #-----FUN-A40030---------
        LET sr.gec04 = ''
        SELECT gec04 INTO sr.gec04 FROM gec_file
          WHERE gec01 = sr.obg10
            AND gec011 = '2'
        #-----END FUN-A40030-----
#NO.FUN-840020----START----
        SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01=sr.obf01
        IF SQLCA.SQLCODE THEN LET l_oba02=' ' END IF
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
            WHERE ima01=sr.obf02
        IF SQLCA.SQLCODE THEN 
           LET l_ima02 =' ' 
           LET l_ima021=' '
        END IF
        SELECT azi03 INTO t_azi03 FROM azi_file
            WHERE azi01 = sr.obg09
        EXECUTE insert_prep USING
          sr.obf01,sr.obf02,sr.obg03,sr.obg04,sr.obg05,sr.obg06,sr.obg22,
          sr.obg07,sr.obg08,sr.obg09,sr.obg10,sr.gec04,sr.obg21,sr.obguser,sr.obgdate,   #FUN-A40030
          l_oba02,l_ima02,l_ima021,t_azi03
#NO.FUN-840020---END---
    END FOREACH
 
#    FINISH REPORT i140_rep                                #NO.FUN-840020
#NO.FUN-840020---start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'obf01,obf02,obg03,obg04,obg05,obg06,obg22,
                            obg07,obg08,obg09,obg10,obg21,obguser,obgdate')   #FUN-A40030
           #RETURNING g_wc   #FUN-A40030
           RETURNING g_str   #FUN-A40030
     END IF
     #LET g_str = g_wc   #FUN-A40030
     CALL cl_prt_cs3('axmi140','axmi140',g_sql,g_str) 
#NO.FUN-840020---end----
    CLOSE i140_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)                     #NO.FUN-840020
END FUNCTION
#NO.FUN-840020----START--MARK-- 
#REPORT i140_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680137 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,           #No.FUN-680137 VARCHAR(1)
##    l_sql1         LIKE type_file.chr1000,        #No.FUN-680137 VARCHAR(100)
#    l_sql1          STRING,                        #NO.TQC-630166  
#    l_i             LIKE type_file.num5,           #No.FUN-680137 SMALLINT
#    l_bmg           RECORD LIKE bmg_file.*,
#    sr              RECORD
#        obf01       LIKE obf_file.obf01,
#        obf02       LIKE obf_file.obf02,
#        obg03       LIKE obg_file.obg03,
#        obg04       LIKE obg_file.obg04,
#        obg05       LIKE obg_file.obg05,
#        obg06       LIKE obg_file.obg06,
#        obg22       LIKE obg_file.obg22,   #FUN-550091
#        obg07       LIKE obg_file.obg07,
#        obg08       LIKE obg_file.obg08,
#        obg09       LIKE obg_file.obg09,
#        obg10       LIKE obg_file.obg10,
#        gec04       LIKE gec_file.gec04,
#        obg21       LIKE obg_file.obg21,
#        obguser     LIKE obg_file.obguser
#                    END RECORD,
#        l_oba02     LIKE oba_file.oba02, 
#        l_ima02     LIKE ima_file.ima02, 
#        l_ima021    LIKE ima_file.ima021   #FUN-5A0060 add
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.obf01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT 
#            PRINT g_dash
#            #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[46],g_x[35],
#                           g_x[36],g_x[37],g_x[38]
#            #PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],   #FUN-550091
#            PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[47],g_x[43],   #FUN-550091
#                           g_x[44],g_x[45]
#            PRINTX name=H3 g_x[48],g_x[49],g_x[50]   #FUN-5A0060 add
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#       
#        BEFORE GROUP OF sr.obf01
#           SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01=sr.obf01
#           IF SQLCA.SQLCODE THEN LET l_oba02=' ' END IF
#           SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file   #FUN-5A0060 add ima021
#            WHERE ima01=sr.obf02
#           IF SQLCA.SQLCODE THEN 
#              LET l_ima02 =' ' 
#              LET l_ima021=' '   #FUN-5A0060 add 
#           END IF
#           PRINTX name=D1 COLUMN g_c[31],sr.obf01,
#                          COLUMN g_c[32],l_oba02;
#           
#        LET l_i=0
#        ON EVERY ROW
#           #no.4560 依幣別取位
#           SELECT azi03 INTO t_azi03 FROM azi_file
#            WHERE azi01 = sr.obg09
#           #no.4560(end)
#           LET l_i=l_i+1
### No:2608 modify 1998/10/23 -----
#           PRINTX name=D1 COLUMN g_c[33],sr.obg03,
#                          COLUMN g_c[34],sr.obg05,
#                          COLUMN g_c[46],sr.obg22,   #FUN-550091
#                          COLUMN g_c[35],sr.obg07,
#                          COLUMN g_c[36],sr.obg09,
#                          COLUMN g_c[37],cl_numfor(sr.obg21,37,t_azi03),
#                          COLUMN g_c[38],sr.obguser
#           IF l_i=1 THEN
#              PRINTX name=D2 COLUMN g_c[39],sr.obf02;   #FUN-5A0060 modify
#                            #COLUMN g_c[40],l_ima02;    #FUN-5A0060 mark
##             PRINTX name=D3 COLUMN g_c[48],l_ima02,    #FUN-5A0060 add  #TQC-790069 mark
##                            COLUMN g_c[50],l_ima021    #FUN-5A0060 add  #TQC-790069 mark
#           END IF
#           PRINTX name=D2 COLUMN g_c[41],sr.obg04,
#                          COLUMN g_c[42],sr.obg06[1,8],
#                          COLUMN g_c[43],sr.obg08,
#                          COLUMN g_c[44],sr.obg10,
#                          COLUMN g_c[45],sr.gec04 USING '##.##'
#           IF l_i=1 THEN                              #TQC-790069
#              PRINTX name=D3 COLUMN g_c[48],l_ima02,  #TQC-790069   
#                             COLUMN g_c[50],l_ima021  #TQC-790069  
#           END IF                                     #TQC-790069 
#
#        AFTER GROUP OF sr.obf01
#           PRINT  
# 
#        ON LAST ROW
##          PRINT g_dash2
##TQC-790069 start---
 #          NEED 4 LINES
#           IF g_zz05 = 'Y' THEN                       
#              CALL cl_wcchp(g_wc,'obf01,obf02')   
#                   RETURNING g_wc   
#              PRINT g_dash[1,g_len]  
#              CALL cl_prt_pos_wc(g_wc)
#           END IF                    
#                 PRINT g_dash[1,g_len]
##TQC-790069 end---
##           IF g_zz05 = 'Y' THEN          # 80:70,140,210      132:120,240
##NO.TQC-630166 start--
##               THEN IF g_wc[001,080] > ' ' THEN
##		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
# #                   IF g_wc[071,140] > ' ' THEN
##		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
##                    IF g_wc[141,210] > ' ' THEN
##		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
##                    CALL cl_prt_pos_wc(g_wc)
##NO.TQC-630166 end- 
##                   PRINT g_dash  #TQC-790069
##           END IF                #TQC-790069
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-840020----END--MARK--

# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli120.4gl
# Descriptions...: 科目異動碼設定維護agli120
# Date & Author..: No.FUN-5C0015 BY GILL
# Modify.........: No.FUN-620023 06/03/09 By Sarah 將ahf04開窗改成q_feld,檢查點由原來檢查gae_file改成檢查gaq_file
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0061 23/10/16 By xumin g_no_ask 改為 g_no_ask
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/20 By Carrier 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770144 07/07/30 By Smapmin 修改預設欄位開窗
# Modify.........: No.FUN-760085 07/08/02 By sherry  報表改由Crystal Report輸出                                                     
# Modify.........: No.CHI-780018 07/08/13 By Smapmin 若程式代號為多角程式時,需提示"此多角程式請調整為 axrt300/aapt110
# Modify.........: No.CHI-7C0001 07/12/03 By Smapmin 增加anmt605
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9B0017 09/11/23 By Sarah 單身預設值欄位輸入非該程式代號可輸入之欄位,系統沒有卡關
# Modify.........: No.FUN-A10105 10/02/03 By wujie   缺省值字段开窗增加单身字段(aapt110,aapt330,axrt300,axrt400)
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A90076 10/09/10 by Dido g_file 變數宣告放大;開窗多單身調整 
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-B50048 11/06/16 by Dido ahf04 增加預設值開窗與檢核 
# Modify.........: No.MOD-B80146 11/08/15 By Carrier add axrt401/axrt410
# Modify.........: No.TQC-B80144 11/08/15 By Carrier add aapt1*,aapt2*,aapp1*
# Modify.........: No.MOD-C30013 12/03/08 by Polly 增加控卡，當agli1022無設定異動碼控制時，則不可設定
# Modify.........: No.MOD-C70024 12/07/03 By Carrier add aapt332/aapt335
# Modify.........: No.MOD-C70077 12/07/06 By Polly 調整維護異動碼類型為3的選項開窗
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-DB0107 13/11/01 By yinhy 增加anmt100

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_ahf01           LIKE ahf_file.ahf01,   # 科目代號 (假單頭)
         g_ahf01_t         LIKE ahf_file.ahf01,   # 科目代號 (假單頭)
         g_ahf00           LIKE ahf_file.ahf00,   # 帳別  #No.FUN-730020
         g_ahf00_t         LIKE ahf_file.ahf00,   # 帳別  #No.FUN-730020
         g_aag02           LIKE aag_file.aag02,   # 科目名稱
         g_ahf    DYNAMIC ARRAY  OF RECORD        # 程式變數
            ahf02          LIKE ahf_file.ahf02,
            gaz03          LIKE gaz_file.gaz03,
            ahf03          LIKE ahf_file.ahf03,
            ahe02          LIKE ahe_file.ahe02,
            ahf04          LIKE ahf_file.ahf04,
            gaq03          LIKE gaq_file.gaq03    #FUN-620023
                      END RECORD,
         g_ahf_t           RECORD                 # 變數舊值
            ahf02          LIKE ahf_file.ahf02,
            gaz03          LIKE gaz_file.gaz03,
            ahf03          LIKE ahf_file.ahf03,
            ahe02          LIKE ahe_file.ahe02,
            ahf04          LIKE ahf_file.ahf04,
            gaq03          LIKE gaq_file.gaq03    #FUN-620023
                      END RECORD,
         g_ahf_o           RECORD                 # 變數舊值
            ahf02          LIKE ahf_file.ahf02,
            gaz03          LIKE gaz_file.gaz03,
            ahf03          LIKE ahf_file.ahf03,
            ahe02          LIKE ahe_file.ahe02,
            ahf04          LIKE ahf_file.ahf04,
            gaq03          LIKE gaq_file.gaq03    #FUN-620023
                      END RECORD,
         g_wc                  STRING,          #TQC-630166       
         g_sql                 STRING,     
         g_rec_b               LIKE type_file.num5,                # 單身筆數               #No.FUN-680098  SMALLINT
         l_ac                  LIKE type_file.num5                 # 目前處理的ARRAY CNT    #No.FUN-680098  SMALLLINT
#DEFINE   g_file               LIKE gat_file.gat01,   #FUN-620023   #No.FUN-680098   VARCHAR(15)
DEFINE  #g_file                LIKE type_file.chr20,   #No.FUN-A10105 #MOD-A90076 mark
         g_file                LIKE type_file.chr1000,                #MOD-A90076
         g_key1,g_key2,g_key3  LIKE type_file.chr1000,  #FUN-620023   #No.FUN-680098   VARCHAR(30)
         g_length              LIKE type_file.num5,   #FUN-620023  #No.FUN-680098   SMALLINT
         g_xxx                 LIKE type_file.chr5    #FUN-620023  #No.FUN-680098   VARCHAR(5) #MOD-A90076 remark
        #g_xxx                 LIKE type_file.chr100  #No.FUN-A10105                           #MOD-A90076 mark
DEFINE   g_cnt                 LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)
DEFINE   g_forupd_sql          STRING    
DEFINE   g_curs_index          LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_row_count           LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_jump                LIKE type_file.num10         #No.FUN-680098  INGEGER
DEFINE   g_no_ask              LIKE type_file.num5          #No.FUN-680098  SMALLINT    #No.FUN-6A0061
DEFINE   g_tabname             LIKE gae_file.gae02         #No.FUN-680098  VARCHAR(10) 
DEFINE   g_tabname1            DYNAMIC ARRAY OF LIKE gae_file.gae02   #CHI-9B0017 add
DEFINE   g_str           STRING                                                                                                     
DEFINE   l_sql           STRING                                                                                                     
DEFINE   l_table         STRING                                                                                                     
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_sql = "ahf00.ahf_file.ahf00,",
               "ahf01.ahf_file.ahf01,",
               "aag02.aag_file.aag02,",
               "ahf02.ahf_file.ahf02,",
               "gaz03.gaz_file.gaz03,",
               "ahf03.ahf_file.ahf03,",
               "ahe02.ahe_file.ahe02,",
               "ahf04.ahf_file.ahf04,",
               "gaq03.gaq_file.gaq03"
 
   LET l_table = cl_prt_temptable('agli120',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?) "                                                                                
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
    
   LET g_ahf01_t = NULL
   LET g_ahf00_t = NULL  #No.FUN-730020
 
   OPEN WINDOW i120_w WITH FORM "agl/42f/agli120"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from ahf_file ",
                      "  WHERE ahf01 = ? ",
                      "   AND ahf00 = ? ",  #No.FUN-730020
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_lock_u CURSOR FROM g_forupd_sql
 
   CALL i120_menu() 
 
   CLOSE WINDOW i120_w                        # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i120_curs()                          # QBE 查詢資料
 
   CLEAR FORM                                 # 清除畫面
   CALL g_ahf.clear()
   CALL cl_set_head_visible("","YES")         #No.FUN-6B0029
 
   INITIALIZE g_ahf00 TO NULL    #No.FUN-750051
   INITIALIZE g_ahf01 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON ahf00,ahf01,ahf02,ahf03,ahf04  #No.FUN-730020
                FROM ahf00,ahf01,s_ahf[1].ahf02,s_ahf[1].ahf03,s_ahf[1].ahf04  #No.FUN-730020
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
            #No.FUN-730020  --Begin
            WHEN INFIELD(ahf00)        #帳別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahf00
               NEXT FIELD ahf00
            #No.FUN-730020  --End  
            WHEN INFIELD(ahf01)        #科目代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahf01
               NEXT FIELD ahf01
            WHEN INFIELD(ahf02)        #交易作業(程式代號)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ahf02
               NEXT FIELD ahf02
            WHEN INFIELD(ahf04)        #預設值欄位
                CALL cl_init_qry_var()
               #start FUN-620023
               #LET g_qryparam.form = "q_gae01"
               #LET g_qryparam.arg1 = g_lang
                LET g_qryparam.form = "q_feld"
#No.FUN-A10105 --begin
               #LET g_qryparam.where = g_xxx   #MOD-A90076 mark
#No.FUN-A10105 --end
                #LET g_qryparam.arg1 = g_xxx   #MOD-770144
                LET g_qryparam.arg2 = g_lang
               #end FUN-620023
                LET g_qryparam.state= "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ahf04
                NEXT FIELD ahf04
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN 
      RETURN 
   END IF
 
   LET g_sql= "SELECT UNIQUE ahf00,ahf01 FROM ahf_file ",  #No.FUN-730020
              " WHERE ", g_wc CLIPPED,
              " GROUP BY ahf00,ahf01 ORDER BY ahf00,ahf01"  #No.FUN-730020
 
   PREPARE i120_prepare FROM g_sql          # 預備一下
   DECLARE i120_b_curs                      # 宣告成可捲動的
   SCROLL CURSOR WITH HOLD FOR i120_prepare
 
END FUNCTION
 
#選出筆數直接寫入 g_row_count
FUNCTION i120_count()
   DEFINE la_ahf     DYNAMIC ARRAY of RECORD        # 程式變數
           ahf00     LIKE ahf_file.ahf00,   #No.FUN-730020
           ahf01     LIKE ahf_file.ahf01
                     END RECORD,
          li_cnt     LIKE type_file.num10,           #No.FUN-680098    INTEGER
          li_rec_b   LIKE type_file.num10            #No.FUN-680098    INTEGER
 
   LET g_sql= "SELECT UNIQUE ahf00,ahf01 FROM ahf_file ",  #No.FUN-730020
              " WHERE ", g_wc CLIPPED,
              " GROUP BY ahf00,ahf01 ORDER BY ahf00,ahf01"  #No.FUN-730020
 
   PREPARE i120_precount FROM g_sql
   DECLARE i120_count CURSOR FOR i120_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i120_count INTO g_ahf[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION i120_menu()
 
   WHILE TRUE
      CALL i120_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
           IF cl_chk_act_auth() THEN
              CALL i120_a()
           END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i120_copy()
            END IF
         WHEN "delete"                          # R.刪除
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i120_out()
           END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_ahf),'','')
            END IF
         #No.FUN-6B0040-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ahf01 IS NOT NULL THEN
                 #No.FUN-730020  --Begin
                 LET g_doc.column1 = "ahf00"
                 LET g_doc.value1 = g_ahf00
                 LET g_doc.column2 = "ahf01"
                 LET g_doc.value2 = g_ahf01
                 #No.FUN-730020  --End  
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0040-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i120_a()
   
   MESSAGE ""
   CLEAR FORM
   CALL g_ahf.clear()
  
   INITIALIZE g_ahf01 LIKE gae_file.gae01    # 預設值及將數值類變數清成零
   INITIALIZE g_aag02 LIKE aag_file.aag02    # 預設值及將數值類變數清成零
   LET g_ahf00 = NULL  #No.FUN-730020
  
   CALL cl_opmsg('a')
  
   WHILE TRUE
     CALL i120_i("a")# 輸入單頭
    
     IF INT_FLAG THEN# 使用者不玩了
        LET g_ahf01=NULL
        LET g_ahf00=NULL  #No.FUN-730020
        LET g_aag02=NULL
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
     
     LET g_rec_b = 0
     
     CALL g_ahf.clear()
     CALL i120_b_fill('1=1')             # 單身
     
     CALL i120_b()                       # 輸入單身
     LET g_ahf01_t=g_ahf01
     LET g_ahf00_t=g_ahf00  #No.FUN-730020
     EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION i120_i(p_cmd)                            # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1      # a:輸入 u:更改   #No.FUN-680098 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5      #No.FUN-680098    SMALLINT        
   DEFINE   l_aaaacti    LIKE aaa_file.aaaacti    #No.FUN-730020
   CALL cl_set_head_visible("","YES")             #No.FUN-6B0029
 
   INPUT g_ahf00,g_ahf01 WITHOUT DEFAULTS FROM ahf00,ahf01  #No.FUN-730020
 
      #No.FUN-730020  --Begin
      AFTER FIELD ahf00
         IF NOT cl_null(g_ahf00) THEN                                      
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
             WHERE aaa01=g_ahf00                                           
            IF SQLCA.SQLCODE=100 THEN                                            
               CALL cl_err3("sel","aaa_file",g_ahf00,"",100,"","",1)            
               NEXT FIELD ahf00                                                 
            END IF                                                               
            IF l_aaaacti='N' THEN                                                
               CALL cl_err(g_ahf00,"9028",1)                                    
               NEXT FIELD ahf00                                                 
            END IF                                                               
         END IF
      #No.FUN-730020  --End
 
      AFTER FIELD ahf01
         IF cl_null(g_ahf00) THEN NEXT FIELD ahf00 END IF  #No.FUN-730020
         IF NOT cl_null(g_ahf01) THEN
            IF p_cmd = 'a' OR (p_cmd ='u' AND g_ahf01 != g_ahf01_t) THEN
              #Mod No.FUN-B10048
              #LET l_count = 0 
              #SELECT COUNT(*) INTO l_count FROM aag_file
              # WHERE aag01 = g_ahf01
              #   AND aagacti='Y'
              #   AND aag00 = g_ahf00  #No.FUN-730020
              #IF l_count = 0 THEN
              #   CALL cl_err('','agl-916',1)
              #   NEXT FIELD ahf01
              #END IF
              #LET l_count = 0 
              #SELECT COUNT(*) INTO l_count FROM aag_file
              # WHERE aag01 = g_ahf01
              #   AND aag00 = g_ahf00  #No.FUN-730020
              #   AND aagacti='Y'
              #   AND aag07 = '1'
              #IF l_count > 0 THEN
              #   CALL cl_err('','agl-044',1)
              #   NEXT FIELD ahf01
              #END IF
              #LET g_aag02 = NULL
              #SELECT aag02 INTO g_aag02 FROM aag_file
              # WHERE aag01 = g_ahf01
              #   AND aag00 = g_ahf00  #No.FUN-730020
              #   AND aagacti ='Y'
              #DISPLAY g_aag02 TO aag02
               CALL i120_ahf01(g_ahf01,g_ahf00)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ahf01,g_errno,0)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag02"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_ahf00
                  LET g_qryparam.default1= g_ahf01
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_ahf01 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_ahf01
                  NEXT FIELD ahf01
               ELSE
                  DISPLAY g_aag02 TO aag02
               END IF
              #End Mod No.FUN-B10048
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            #No.FUN-730020  --Begin
            WHEN INFIELD(ahf00)  #帳別
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aaa"
                LET g_qryparam.default1= g_ahf00
                CALL cl_create_qry() RETURNING g_ahf00
                DISPLAY g_ahf00 TO ahf00
                NEXT FIELD ahf00
            #No.FUN-730020  --End  
            WHEN INFIELD(ahf01)  #科目
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag02"
               #No.FUN-730020  --Begin
#              LET g_qryparam.arg1 = g_lang
               LET g_qryparam.arg1 = g_ahf00
               #No.FUN-730020  --End  
               LET g_qryparam.default1= g_ahf01
               CALL cl_create_qry() RETURNING g_ahf01
               NEXT FIELD ahf01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
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
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
END FUNCTION
 
FUNCTION i120_r()
 
  IF s_shut(0) THEN
     RETURN
  END IF
 
  IF cl_null(g_ahf01) OR cl_null(g_ahf00) THEN  #No.FUN-730020
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  BEGIN WORK
 
  IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "ahf00"      #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_ahf00       #No.FUN-9B0098 10/02/24
      LET g_doc.column2 = "ahf01"      #No.FUN-9B0098 10/02/24
      LET g_doc.value2 = g_ahf01       #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
     DELETE FROM ahf_file WHERE ahf01 = g_ahf01
                            AND ahf00 = g_ahf00  #No.FUN-730020
     IF SQLCA.sqlcode THEN
#       CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("del","ahf_file",g_ahf00,g_ahf01,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660123  #No.FUN-730020
     ELSE
        CLEAR FORM
        CALL g_ahf.clear()
        LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        CALL i120_count()
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i120_b_curs
           CLOSE i120_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i120_b_curs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i120_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE   #No.FUN-6A0061
           CALL i120_fetch('/')
        END IF
     END IF
  END IF
  COMMIT WORK
 
END FUNCTION
 
 
 
FUNCTION i120_q()                            #Query 查詢
 
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ahf01 TO NULL               #No.FUN-6B0040
   INITIALIZE g_ahf00 TO NULL               #No.FUN-730020
   CLEAR FROM
   CALL g_ahf.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i120_curs()                         #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i120_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                    #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_ahf01 TO NULL
      INITIALIZE g_ahf00 TO NULL  #No.FUN-730020
   ELSE
#     OPEN i120_count
#     FETCH i120_count INTO g_row_count
      CALL i120_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i120_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i120_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,    #處理方式        #No.FUN-680098  VARCHAR(1)
            l_abso   LIKE type_file.num10    #絕對的筆數      #No.FUN-680098  INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i120_b_curs INTO g_ahf00,g_ahf01  #No.FUN-730020
      WHEN 'P' FETCH PREVIOUS i120_b_curs INTO g_ahf00,g_ahf01  #No.FUN-730020
      WHEN 'F' FETCH FIRST    i120_b_curs INTO g_ahf00,g_ahf01  #No.FUN-730020
      WHEN 'L' FETCH LAST     i120_b_curs INTO g_ahf00,g_ahf01  #No.FUN-730020
      WHEN '/' 
         IF (NOT g_no_ask) THEN      #No.FUN-6A0061
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i120_b_curs INTO g_ahf00,g_ahf01  #No.FUN-730020
         LET g_no_ask = FALSE   #No.FUN-6A0061 
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ahf01,SQLCA.sqlcode,0)
      INITIALIZE g_ahf01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL i120_show()
   END IF
END FUNCTION
 
FUNCTION i120_show()                         # 將資料顯示在畫面上
 
   LET g_aag02 = NULL 
   SELECT aag02 INTO g_aag02 FROM aag_file
    WHERE aag01 = g_ahf01
      AND aag00 = g_ahf00  #No.FUN-730020
      AND aagacti ='Y'
   DISPLAY g_aag02 TO aag02
   DISPLAY g_ahf01 TO ahf01
   DISPLAY g_ahf00 TO ahf00  #No.FUN-730020
 
   CALL i120_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i120_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT   #No.FUN-680098 SMALLINT
            l_n             LIKE type_file.num5,        #檢查重複用  #No.FUN-680098   SMALLINT
            l_lock_sw       LIKE type_file.chr1,        #單身鎖住否  #No.FUN-680098   VARCHAR(1)
            p_cmd           LIKE type_file.chr1,        #處理狀態    #No.FUN-680098   VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,        #No.FUN-680098 SMALLINT
            l_allow_delete  LIKE type_file.num5         #No.FUN-680098 SMALLINT
   DEFINE   l_count         LIKE type_file.num5         #No.FUN-680098 SMALLINT  
   DEFINE   l_ahe03         LIKE ahe_file.ahe03         #CHI-B50048
   DEFINE l_ahf03         LIKE type_file.chr20          #MOD-C30013 add
   DEFINE l_cnt           LIKE type_file.num5           #MOD-C30013 add
   DEFINE l_sql           STRING                        #MOD-C30013 add
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_ahf01) OR cl_null(g_ahf00) THEN   #No.FUN-730020
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT ahf02,'',ahf03,'',ahf04,'' ",
                     "  FROM ahf_file",
                     "  WHERE ahf00 = ? AND ahf01 = ? AND ahf02 = ? AND ahf03 = ? ",  #No.FUN-730020
                     "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_ahf WITHOUT DEFAULTS FROM s_ahf.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_ahf_t.* = g_ahf[l_ac].*    #BACKUP
            LET g_ahf_o.* = g_ahf[l_ac].*    #BACKUP
            OPEN i120_bcl USING g_ahf00,g_ahf01,g_ahf_t.ahf02,g_ahf_t.ahf03  #No.FUN-730020
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i120_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i120_bcl INTO g_ahf[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i120_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i120_gaz03(g_ahf[l_ac].ahf02) RETURNING g_ahf[l_ac].gaz03
               CALL i120_ahe02(g_ahf00,g_ahf01,g_ahf[l_ac].ahf03)   #No.FUN-730020
                               RETURNING g_ahf[l_ac].ahe02
              #start FUN-620023
              #CALL i120_gae04(g_ahf[l_ac].ahf02,g_ahf[l_ac].ahf04) 
              #                RETURNING g_ahf[l_ac].gae04
              #DISPLAY BY NAME g_ahf[l_ac].gaz03,g_ahf[l_ac].ahe02,
              #                g_ahf[l_ac].gae04
               CALL i120_gaq03(g_ahf[l_ac].ahf04) RETURNING g_ahf[l_ac].gaq03
               DISPLAY BY NAME g_ahf[l_ac].gaz03,g_ahf[l_ac].ahe02,
                               g_ahf[l_ac].gaq03
              #end FUN-620023
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ahf[l_ac].* TO NULL       
         LET g_ahf_t.* = g_ahf[l_ac].*          #新輸入資料
         LET g_ahf_o.* = g_ahf[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD ahf02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         CALL i120_chk_ahf04('1')
         IF g_errno THEN
            CALL g_ahf.deleteElement(l_ac)
            CANCEL INSERT
         END IF
 
         INSERT INTO ahf_file(ahf00,ahf01,ahf02,ahf03,ahf04) #No.FUN-730020
                      VALUES (g_ahf00,g_ahf01,g_ahf[l_ac].ahf02,  #No.FUN-730020
                              g_ahf[l_ac].ahf03,g_ahf[l_ac].ahf04)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ahf01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","ahf_file",g_ahf01,g_ahf[l_ac].ahf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD ahf02  #交易作業(程式代號)
        IF NOT cl_null(g_ahf[l_ac].ahf02) THEN
           IF p_cmd = 'a' OR (p_cmd='u' AND 
                              g_ahf[l_ac].ahf02!=g_ahf_o.ahf02) THEN
              LET l_n = 0 
              SELECT COUNT(*) INTO l_n FROM gaz_file
               WHERE gaz01 = g_ahf[l_ac].ahf02
                 AND gaz02 = g_lang
              IF l_n = 0 THEN
                 CALL cl_err(g_ahf[l_ac].ahf02,'lib-021',1)
                 LET g_ahf[l_ac].ahf02 = g_ahf_o.ahf02
                 NEXT FIELD ahf02
              END IF
 
              #-----CHI-780018---------
              IF g_ahf[l_ac].ahf02 = 'axmp840' OR 
                 g_ahf[l_ac].ahf02 = 'axmp880' OR
                 g_ahf[l_ac].ahf02 = 'axmp860' THEN
                 CALL cl_err(g_ahf[l_ac].ahf02,'agl-952',0)
                 NEXT FIELD ahf02
              END IF
              #-----END CHI-780018-----
 
             #-----MOD-770144---------
             {
             #start FUN-620023
              CALL s_prg_tab(g_ahf[l_ac].ahf02) 
                   RETURNING g_file,g_key1,g_key2,g_key3
              IF cl_null(g_file) OR g_file = '' THEN
                 CALL cl_err(g_ahf[l_ac].ahf02,'agl-930',1)   #此程式無相關對應主檔,請check MIS！
                 NEXT FIELD ahf02
              ELSE
                 LET g_length = LENGTH(g_file)
                 LET g_xxx = g_file[1,g_length-5]
              END IF
             #end FUN-620023
             }
             #-----END MOD-770144-----
              IF NOT cl_null(g_ahf[l_ac].ahf04) THEN
                #start FUN-620023
                #CALL i120_gae04(g_ahf[l_ac].ahf02,g_ahf[l_ac].ahf04) 
                #                RETURNING g_ahf[l_ac].gae04
                #DISPLAY BY NAME g_ahf[l_ac].gae04 
                 CALL i120_gaq03(g_ahf[l_ac].ahf04) RETURNING g_ahf[l_ac].gaq03
                 DISPLAY BY NAME g_ahf[l_ac].gaq03 
                #end FUN-620023
              END IF
              LET g_ahf_o.ahf02 = g_ahf[l_ac].ahf02
           END IF
        END IF
        CALL i120_gaz03(g_ahf[l_ac].ahf02) RETURNING g_ahf[l_ac].gaz03
        DISPLAY BY NAME g_ahf[l_ac].gaz03
 
      AFTER FIELD ahf03  #異動碼序
        IF NOT cl_null(g_ahf[l_ac].ahf03) THEN
           IF p_cmd = 'a' OR (p_cmd='u' AND 
                              g_ahf[l_ac].ahf03!=g_ahf_o.ahf03) THEN
              IF g_ahf[l_ac].ahf03 NOT MATCHES '[123456789]' AND 
                 g_ahf[l_ac].ahf03 !='10' AND g_ahf[l_ac].ahf03!='99' THEN
                 CALL cl_err(g_ahf[l_ac].ahf03,'agl-153',1)
                 LET g_ahf[l_ac].ahf03 = g_ahf_o.ahf03
                 NEXT FIELD ahf03
              END IF
             #---------------------------MOD-C30013------------------------start
              CASE
                 WHEN g_ahf[l_ac].ahf03 = '1'
                      LET l_ahf03 = 'aag151'
                 WHEN g_ahf[l_ac].ahf03 = '2'
                      LET l_ahf03 = 'aag161'
                 WHEN g_ahf[l_ac].ahf03 = '3'
                      LET l_ahf03 = 'aag171'
                 WHEN g_ahf[l_ac].ahf03 = '4'
                      LET l_ahf03 = 'aag181'
                 WHEN g_ahf[l_ac].ahf03 = '5'
                      LET l_ahf03 = 'aag311'
                 WHEN g_ahf[l_ac].ahf03 = '6'
                      LET l_ahf03 = 'aag321'
                 WHEN g_ahf[l_ac].ahf03 = '7'
                      LET l_ahf03 = 'aag331'
                 WHEN g_ahf[l_ac].ahf03 = '8'
                      LET l_ahf03 = 'aag341'
                 WHEN g_ahf[l_ac].ahf03 = '9'
                      LET l_ahf03 = 'aag351'
                 WHEN g_ahf[l_ac].ahf03 = '10'
                      LET l_ahf03 = 'aag361'
                 WHEN g_ahf[l_ac].ahf03 = '99'
                      LET l_ahf03 = 'aag371'
              END CASE
              LET l_cnt = 0
              LET l_sql = "SELECT COUNT(*) FROM aag_file ",
                          " WHERE aag01 = '",g_ahf01,"' ",
                          "   AND aag00 = '",g_ahf00,"' "
              LET l_sql = l_sql clipped," AND ",l_ahf03," IS NULL "
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              PREPARE sel_ahf_pre FROM l_sql
              EXECUTE sel_ahf_pre INTO l_cnt
              IF l_cnt > 0 THEN
                 CALL cl_err(g_ahf01,'agl-182',1)
                 NEXT FIELD ahf03
              END IF
             #---------------------------MOD-C30013--------------------------end
              LET g_ahf_o.ahf03 = g_ahf[l_ac].ahf03
           END IF
        END IF
        CALL i120_ahe02(g_ahf00,g_ahf01,g_ahf[l_ac].ahf03) RETURNING g_ahf[l_ac].ahe02  #No.FUN-730020
        IF g_errno AND NOT cl_null(g_ahf[l_ac].ahf03) THEN
           CALL cl_err(g_ahf[l_ac].ahf03,g_errno,1)
           NEXT FIELD ahf03
        END IF
        DISPLAY BY NAME g_ahf[l_ac].ahe02
 
      #-----MOD-770144--------- 
      BEFORE FIELD ahf04
        CALL s_prg_tab(g_ahf[l_ac].ahf02) 
             RETURNING g_file,g_key1,g_key2,g_key3
        IF cl_null(g_file) OR g_file = '' THEN
           CALL cl_err(g_ahf[l_ac].ahf02,'agl-930',1)   #此程式無相關對應主檔,請check MIS！
           NEXT FIELD ahf02
        ELSE
           LET g_length = LENGTH(g_file)
           LET g_xxx = g_file[1,g_length-5]    #MOD-A90076 remark
          #LET g_xxx = " gaq01 LIKE '",g_file[1,g_length-14],"%' OR gaq01 LIKE '",g_file[g_length-7,g_length-5],"%'"   #FUN-A10105 #MOD-A90076 mark
        END IF
      #-----END MOD-770144-----
 
      AFTER FIELD ahf04  #預設值欄位
        IF NOT cl_null(g_ahf[l_ac].ahf04) THEN
           IF p_cmd = 'a' OR (p_cmd='u' AND 
                              g_ahf[l_ac].ahf04!=g_ahf_o.ahf04) THEN
            #-CHI-B50048-mark- 
            # LET l_n = 0 
            ##start FUN-620023
            ##SELECT COUNT(*) INTO l_n FROM gae_file
            ## WHERE gae02 = g_ahf[l_ac].ahf04
            ##   AND gae03 = g_lang
            # SELECT COUNT(*) INTO l_n FROM gaq_file
            #  WHERE gaq01 = g_ahf[l_ac].ahf04
            #    AND gaq02 = g_lang
            ##end FUN-620023
            # IF l_n = 0 THEN
            #    CALL cl_err('','agl-056',1)
            #    LET g_ahf[l_ac].ahf04 = g_ahf_o.ahf04
            #    NEXT FIELD ahf04
            # END IF
            #-CHI-B50048-end- 
              IF NOT cl_null(g_ahf[l_ac].ahf02) THEN
                 CALL i120_chk_ahf04('1')
                 IF g_errno THEN
                    LET g_ahf[l_ac].ahf04 = g_ahf_o.ahf04
                    NEXT FIELD ahf04
                 END IF
                #start FUN-620023
                #CALL i120_gae04(g_ahf[l_ac].ahf02,g_ahf[l_ac].ahf04) 
                #                RETURNING g_ahf[l_ac].gae04
                #DISPLAY BY NAME g_ahf[l_ac].gae04 
                 CALL i120_gaq03(g_ahf[l_ac].ahf04) RETURNING g_ahf[l_ac].gaq03
                 DISPLAY BY NAME g_ahf[l_ac].gaq03 
                #end FUN-620023
              END IF
              LET g_ahf_o.ahf04 = g_ahf[l_ac].ahf04
           END IF
        END IF
 
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_ahf_t.ahf02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM ahf_file WHERE ahf01 = g_ahf01
                                   AND ahf00 = g_ahf00  #No.FUN-730020
                                   AND ahf02 = g_ahf_t.ahf02
                                   AND ahf03 = g_ahf_t.ahf03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahf_t.ahf02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","ahf_file",g_ahf01,g_ahf_t.ahf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ahf[l_ac].* = g_ahf_t.*
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ahf[l_ac].ahf02,-263,1)
            LET g_ahf[l_ac].* = g_ahf_t.*
         ELSE
 
            CALL i120_chk_ahf04('1')
            IF g_errno THEN
               LET g_ahf[l_ac].ahf04 = g_ahf_o.ahf04
               NEXT FIELD ahf04
            END IF
            UPDATE ahf_file
               SET ahf02 = g_ahf[l_ac].ahf02,
                   ahf03 = g_ahf[l_ac].ahf03,
                   ahf04 = g_ahf[l_ac].ahf04
             WHERE ahf01 = g_ahf01
               AND ahf00 = g_ahf00  #No.FUN-730020
               AND ahf02 = g_ahf_t.ahf02
               AND ahf03 = g_ahf_t.ahf03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahf[l_ac].ahf02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","ahf_file",g_ahf01,g_ahf_t.ahf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_ahf[l_ac].* = g_ahf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ahf[l_ac].* = g_ahf_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_ahf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i120_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i120_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(ahf02) AND l_ac > 1 THEN
            LET g_ahf[l_ac].* = g_ahf[l_ac-1].*
            DISPLAY BY NAME g_ahf[l_ac].*
            NEXT FIELD ahf02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ahf02) #交易作業
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaz"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.default1 = g_ahf[l_ac].ahf02
                 CALL cl_create_qry() RETURNING g_ahf[l_ac].ahf02
                 DISPLAY BY NAME g_ahf[l_ac].ahf02
                 NEXT FIELD ahf02
            WHEN INFIELD(ahf04) #預設值欄位
                #start FUN-620023
                #IF cl_null(g_ahf[l_ac].ahf02) THEN
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.form = "q_gae02"
                #   LET g_qryparam.arg1 = g_lang
                #   LET g_qryparam.default1 = g_ahf[l_ac].ahf04
                #   LET g_qryparam.default2 = g_ahf[l_ac].gae04
                #   CALL cl_create_qry() RETURNING g_ahf[l_ac].ahf04,
                #                                  g_ahf[l_ac].gae04
                #   DISPLAY BY NAME g_ahf[l_ac].gae04
                #ELSE
                #   CALL i120_chk_ahf04('2')
                #   IF cl_null(g_tabname) THEN
                #      CALL cl_init_qry_var()
                #      LET g_qryparam.form = "q_gae03"
                #      LET g_qryparam.arg1 = g_lang
                #      LET g_qryparam.arg2 = g_ahf[l_ac].ahf02
                #      LET g_qryparam.default1 = g_ahf[l_ac].ahf04
                #      LET g_qryparam.default2 = g_ahf[l_ac].gae04
                #      CALL cl_create_qry() RETURNING g_ahf[l_ac].ahf04,
                #                                     g_ahf[l_ac].gae04
                #      DISPLAY BY NAME g_ahf[l_ac].gae04
                #   ELSE
                #      CALL cl_init_qry_var()
                #      LET g_qryparam.form = "q_gae01"
                #      LET g_qryparam.arg1 = g_lang
                #      LET g_qryparam.arg2 = g_ahf[l_ac].ahf02
                #      LET g_qryparam.arg3 = g_tabname
                #      LET g_qryparam.arg4 = "ta_",g_tabname
                #      LET g_qryparam.default1 = g_ahf[l_ac].ahf04
                #      CALL cl_create_qry() RETURNING g_ahf[l_ac].ahf04
                #   END IF
                #END IF
                #DISPLAY BY NAME g_ahf[l_ac].ahf04
                 IF NOT cl_null(g_ahf[l_ac].ahf02) THEN
                    CALL cl_init_qry_var()
                    CALL i120_ahe03(g_ahf[l_ac].ahf03) RETURNING l_ahe03 #CHI-B50048 
                    CASE l_ahe03                                         #CHI-B50048
                       WHEN '1'                                          #CHI-B50048
                         #str CHI-9B0017 mod
                         #LET g_qryparam.form = "q_feld"
#No.FUN-A10105 --begin
#                         LET g_qryparam.arg1 = g_xxx
                         #LET g_qryparam.where = g_xxx
                         #LET g_qryparam.arg1 = '*'  
#No.FUN-A10105 --end
                         #LET g_qryparam.arg2 = g_lang
                          CASE 
                             WHEN g_ahf[l_ac].ahf02 = 'anmt150'
                                LET g_qryparam.form = "q_feld1"
                                LET g_qryparam.arg1 = "npm"
                                LET g_qryparam.arg2 = "nmd"
                                LET g_qryparam.arg3 = g_lang
                             WHEN g_ahf[l_ac].ahf02 = 'anmt302'
                                LET g_qryparam.form = "q_feld1"
                                LET g_qryparam.arg1 = "npk"
                                LET g_qryparam.arg2 = "nmg"
                                LET g_qryparam.arg3 = g_lang
                             WHEN g_ahf[l_ac].ahf02 = 'anmt250'
                                LET g_qryparam.form = "q_feld2"
                                LET g_qryparam.arg1 = "npo"
                                LET g_qryparam.arg2 = "nmh"
                                LET g_qryparam.arg3 = "npn"
                                LET g_qryparam.arg4 = g_lang
                             WHEN g_ahf[l_ac].ahf02 = 'afat110'
                                LET g_qryparam.form = "q_feld2"
                                LET g_qryparam.arg1 = "fbf"
                                LET g_qryparam.arg2 = "fbe"
                                LET g_qryparam.arg3 = "occ"
                                LET g_qryparam.arg4 = g_lang
#No.FUN-A10105 --begin
                             WHEN (g_ahf[l_ac].ahf02 = 'aapt110' OR g_ahf[l_ac].ahf02 = 'aapt120' OR
                                   g_ahf[l_ac].ahf02 = 'aapt121' OR g_ahf[l_ac].ahf02 = 'aapt150' OR
                                   g_ahf[l_ac].ahf02 = 'aapt151' OR g_ahf[l_ac].ahf02 = 'aapt160' OR
                                   g_ahf[l_ac].ahf02 = 'aapt210' OR g_ahf[l_ac].ahf02 = 'aapt220' OR
                                   g_ahf[l_ac].ahf02 = 'aapt260' OR g_ahf[l_ac].ahf02 = 'aapp110' OR
                                   g_ahf[l_ac].ahf02 = 'aapp111' OR g_ahf[l_ac].ahf02 = 'aapp112' OR
                                   g_ahf[l_ac].ahf02 = 'aapp115' OR g_ahf[l_ac].ahf02 = 'aapp117' OR
                                   g_ahf[l_ac].ahf02 = 'gapq600')
                                LET g_qryparam.form = "q_feld1"
                                LET g_qryparam.arg1 = "apa"
                                LET g_qryparam.arg2 = "apb"
                                LET g_qryparam.arg3 = g_lang
#No.FUN-A10105 --end     
                            #-MOD-A90076-add-
                             WHEN (g_ahf[l_ac].ahf02 = 'aapt330' OR g_ahf[l_ac].ahf02 = 'aapt331' OR g_ahf[l_ac].ahf02 = 'aapp310' OR
                                   g_ahf[l_ac].ahf02 = 'aapt332' OR g_ahf[l_ac].ahf02 = 'aapt335')   #No.MOD-C70024
                                LET g_qryparam.form = "q_feld2"
                                LET g_qryparam.arg1 = "apf"
                                LET g_qryparam.arg2 = "apg"
                                LET g_qryparam.arg3 = "aph"
                                LET g_qryparam.arg4 = g_lang
                             WHEN (g_ahf[l_ac].ahf02 = 'axrt400' OR g_ahf[l_ac].ahf02 = 'axrt401' OR g_ahf[l_ac].ahf02 = 'axrt410')  #No.MOD-B80146
                                LET g_qryparam.form = "q_feld1"
                                LET g_qryparam.arg1 = "ooa"
                                LET g_qryparam.arg2 = "oob"
                                LET g_qryparam.arg3 = g_lang
                            #-MOD-A90076-end-
                             OTHERWISE
                                LET g_qryparam.form = "q_feld"
                                LET g_qryparam.arg1 = g_xxx
                                LET g_qryparam.arg2 = g_lang
                          END CASE
                         #end CHI-9B0017 mod
                   #-CHI-B50048-add-
                       WHEN '2' 
                          LET g_qryparam.form = 'q_aee'
                          LET g_qryparam.arg1 = g_ahf01 
                          LET g_qryparam.arg2 = g_ahf[l_ac].ahf03 
                          LET g_qryparam.arg3 = g_ahf00 
                       OTHERWISE                                   #MOD-C70077 add
                          CONTINUE INPUT                           #MOD-C70077 add
                    END CASE 
                   #-CHI-B50048-end-
                    LET g_qryparam.default1 = g_ahf[l_ac].ahf04
                    CALL cl_create_qry() RETURNING g_ahf[l_ac].ahf04
                    DISPLAY BY NAME g_ahf[l_ac].ahf04
                 END IF
                #end FUN-620023
                 NEXT FIELD ahf04
 
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END INPUT
 
   CLOSE i120_bcl
   COMMIT WORK
 
END FUNCTION
 
#-CHI-B50048-add-
FUNCTION i120_ahe03(p_ahf03)
   DEFINE p_ahf03    LIKE ahf_file.ahf03 
   DEFINE l_ahe03    LIKE ahe_file.ahe03 
   DEFINE l_aag      LIKE aag_file.aag15

   CASE p_ahf03
      WHEN '1'
         LET l_aag = 'aag15'
      WHEN '2'
         LET l_aag = 'aag16'
      WHEN '3'
         LET l_aag = 'aag17'
      WHEN '4'
         LET l_aag = 'aag18'
      WHEN '5'
         LET l_aag = 'aag31'
      WHEN '6'
         LET l_aag = 'aag32'
      WHEN '7'
         LET l_aag = 'aag33'
      WHEN '8'
         LET l_aag = 'aag34'
      WHEN '9'
         LET l_aag = 'aag35'
      WHEN '10'
         LET l_aag = 'aag36'
      WHEN '99'
         LET l_aag = 'aag37'
   END CASE

   LET g_sql = " SELECT ahe03 ",
               "   FROM aag_file,ahe_file ",
               "  WHERE aag00 = '",g_ahf00,"'",
               "    AND aag01 = '",g_ahf01,"'",
               "    AND ahe01 = ",l_aag
   PREPARE i120_ahe03 FROM g_sql                                                                                                   
   EXECUTE i120_ahe03 INTO l_ahe03 

   RETURN l_ahe03

END FUNCTION
#-CHI-B50048-end-

FUNCTION i120_b_fill(p_wc)              #BODY FILL UP
#  DEFINE p_wc         VARCHAR(300)    
   DEFINE p_wc         STRING        #TQC-630166  
   DEFINE p_ac         LIKE type_file.num5          #No.FUN-680098    SMALLINT
 
    LET g_sql = "SELECT ahf02,'',ahf03,'',ahf04,'' ",
                 " FROM ahf_file ",
                " WHERE ahf01 = '",g_ahf01 CLIPPED,"' ",
                "   AND ahf00 = '",g_ahf00 CLIPPED,"' ",  #No.FUN-730020
                  " AND ",p_wc CLIPPED,
                " ORDER BY ahf02"
 
    PREPARE i120_prepare2 FROM g_sql           #預備一下
    DECLARE ahf_curs CURSOR FOR i120_prepare2
 
    CALL g_ahf.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH ahf_curs INTO g_ahf[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL i120_gaz03(g_ahf[g_cnt].ahf02) RETURNING g_ahf[g_cnt].gaz03
       CALL i120_ahe02(g_ahf00,g_ahf01,g_ahf[g_cnt].ahf03) RETURNING g_ahf[g_cnt].ahe02  #No.FUN-730020
      #start FUN-620023
      #CALL i120_gae04(g_ahf[g_cnt].ahf02,g_ahf[g_cnt].ahf04) 
      #                RETURNING g_ahf[g_cnt].gae04
      #DISPLAY BY NAME g_ahf[g_cnt].gaz03,g_ahf[g_cnt].ahe02,
      #                g_ahf[g_cnt].gae04
       CALL i120_gaq03(g_ahf[g_cnt].ahf04) RETURNING g_ahf[g_cnt].gaq03
       DISPLAY BY NAME g_ahf[g_cnt].gaz03,g_ahf[g_cnt].ahe02,
                       g_ahf[g_cnt].gaq03
      #end FUN-620023
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ahf.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_ahf TO s_ahf.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice='reproduce'
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION output                           # O.列印
         LET g_action_choice='output'
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous                         # P.上筆
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                   
 
      ON ACTION jump                             # 指定筆
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY    
 
      ON ACTION next                             # N.下筆
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY              
 
      ON ACTION last                             # 最終筆
         CALL i120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY               
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i120_copy()
   DEFINE   l_aaaacti LIKE aaa_file.aaaacti    #No.FUN-730020
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680098  SMALLINT
            l_new01   LIKE ahf_file.ahf01,
            l_old01   LIKE ahf_file.ahf01,
            l_new00   LIKE ahf_file.ahf00,   #No.FUN-730020
            l_old00   LIKE ahf_file.ahf00,   #No.FUN-730020
            l_ahf     RECORD LIKE ahf_file.*,
            l_temp    LIKE ahe_file.ahe02,
            l_count   LIKE type_file.num10     #No.FUN-680098  INTEGER
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF cl_null(g_ahf01) OR cl_null(g_ahf00) THEN  #No.FUN-730020
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")            #No.FUN-6B0029
 
   INPUT l_new00,l_new01 WITHOUT DEFAULTS FROM ahf00,ahf01  #No.FUN-730020
  
      #No.FUN-730020  --Begin
      AFTER FIELD ahf00
         IF NOT cl_null(l_new00) THEN                                      
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
             WHERE aaa01=l_new00                                           
            IF SQLCA.SQLCODE=100 THEN                                            
               CALL cl_err3("sel","aaa_file",l_new00,"",100,"","",1)            
               NEXT FIELD ahf00                                                 
            END IF                                                               
            IF l_aaaacti='N' THEN                                                
               CALL cl_err(l_new00,"9028",1)                                    
               NEXT FIELD ahf00                                                 
            END IF                                                               
         END IF
      #No.FUN-730020  --End
 
      AFTER FIELD ahf01
        IF cl_null(l_new00) THEN NEXT FIELD ahf00 END IF  #No.FUN-730020
        LET l_count = 0 
        SELECT COUNT(*) INTO l_count FROM aag_file
         WHERE aag01 = l_new01
           AND aagacti='Y'
           AND aag00 = l_new00  #No.FUN-730020
        IF l_count = 0 THEN
           CALL cl_err('','agl-916',0)   #Mod No.FUN-B10048 1->0
           #Add No.FUN-B10048
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_aag02"
           LET g_qryparam.construct = 'N'
           LET g_qryparam.arg1 = l_new00
           LET g_qryparam.default1= l_new01
           LET g_qryparam.where = " aag01 LIKE '",l_new01 CLIPPED,"%'"
           CALL cl_create_qry() RETURNING l_new01
           #End Add No.FUN-B10048
           NEXT FIELD ahf01
        END IF
        LET g_aag02 = NULL
        SELECT aag02 INTO g_aag02 FROM aag_file
         WHERE aag01 = l_new01
           AND aagacti ='Y'
           AND aag00 = l_new00  #No.FUN-730020
        DISPLAY g_aag02 TO aag02
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         #No.FUN-730020  --Begin
         IF cl_null(l_new00) THEN
            NEXT FIELD ahf00
         END IF
         #No.FUN-730020  --End  
         IF cl_null(l_new01) THEN
            NEXT FIELD ahf01
         END IF
         SELECT COUNT(*) INTO g_cnt FROM ahf_file
           WHERE ahf01 = l_new01 
             AND ahf00 = l_new00  #No.FUN-730020
         IF g_cnt > 0 THEN
            CALL cl_err_msg(NULL,"azz-110",l_new01,10)
         END IF
 
      ON ACTION CONTROLP
        CASE
          #No.FUN-730020  --Begin
          WHEN INFIELD(ahf00)  #帳別
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aaa"
              LET g_qryparam.default1= l_new00
              CALL cl_create_qry() RETURNING l_new00
              NEXT FIELD ahf00
          #No.FUN-730020  --End  
          WHEN INFIELD(ahf01)  #科目
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag02"
              #No.FUN-730020  --Begin
#             LET g_qryparam.arg1 = g_lang
              LET g_qryparam.arg1 = l_new00
              #No.FUN-730020  --End  
              LET g_qryparam.default1= l_new01
              CALL cl_create_qry() RETURNING l_new01
              NEXT FIELD ahf01
        END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ahf01 TO ahf01
      DISPLAY g_ahf00 TO ahf00  #No.FUN-730020
      RETURN
   END IF
 
   DROP TABLE x
  
   SELECT * FROM ahf_file WHERE ahf01 = g_ahf01 
                            AND ahf00 = g_ahf00  #No.FUN-730020
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_ahf01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","x",g_ahf00,g_ahf01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
      RETURN
   END IF
 
   UPDATE x
      SET ahf01 = l_new01,                       # 資料鍵值
          ahf00 = l_new00  #No.FUN-730020
 
   INSERT INTO ahf_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
#     CALL cl_err('ahf:',SQLCA.SQLCODE,0)   #No.FUN-660123
      CALL cl_err3("ins","ahf_file",l_new00,l_new01,SQLCA.sqlcode,"","ahf:",1)  #No.FUN-660123  #No.FUN-730020
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_ahf01
   LET g_ahf01 = l_new01
   LET l_old00 = g_ahf00  #No.FUN-730020
   LET g_ahf00 = l_new00  #No.FUN-730020
   CALL i120_b()
   #FUN-C30027---begin
   #LET g_ahf01 = l_old01
   #LET g_ahf00 = l_old00  #No.FUN-730020
   #CALL i120_show()
   #FUN-C30027---end
   #檢查此新科目的異動碼序是否有對應的異動碼 --START
   DECLARE i120_copy_cs CURSOR FOR SELECT * FROM x 
   FOREACH i120_copy_cs INTO l_ahf.*
     CALL i120_ahe02(l_new00,l_new01,l_ahf.ahf03) RETURNING l_temp  #No.FUN-730020
     IF g_errno THEN
        CALL cl_err(l_ahf.ahf03,g_errno,1)
        DELETE FROM ahf_file WHERE ahf01 = l_new01
                               AND ahf00 = l_new00  #No.FUN-730020
        RETURN
     END IF
   END FOREACH
   #檢查此新科目的異動碼序是否有對應的異動碼 --END  
 
END FUNCTION
 
#Add No.FUN-B10048
FUNCTION i120_ahf01(p_code,p_bookno)
   DEFINE p_code     LIKE aag_file.aag01
   DEFINE p_bookno   LIKE aag_file.aag00
   DEFINE l_aagacti  LIKE aag_file.aagacti
   DEFINE l_aag07    LIKE aag_file.aag07

   LET g_aag02 = NULL
   LET g_errno = NULL
   SELECT aag02,aag07,aagacti INTO g_aag02,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01=p_code
      AND aag00=p_bookno

    CASE WHEN STATUS=100         LET g_errno='agl-001'
         WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
END FUNCTION
#End Add No.FUN-B10048

FUNCTION i120_gaz03(p_ahf02)
   DEFINE   l_gaz03         LIKE gaz_file.gaz03,
            p_ahf02         LIKE ahf_file.ahf02 
 
   LET l_gaz03 = NULL
   SELECT gaz03 INTO l_gaz03 FROM gaz_file
    WHERE gaz01 = p_ahf02
      AND gaz02 = g_lang
      AND gaz05 = 'Y'
   IF cl_null(l_gaz03) THEN
      SELECT gaz03 INTO l_gaz03 FROM gaz_file
       WHERE gaz01=p_ahf02
         AND gaz02 = g_lang
         AND gaz05='N'
   END IF
   
   RETURN l_gaz03
 
END FUNCTION
 
FUNCTION i120_ahe02(p_ahf00,p_ahf01,p_ahf03)  #No.FUN-730020
   DEFINE l_feld1   STRING,
          l_aag15   LIKE aag_file.aag15,
          l_ahe02   LIKE ahe_file.ahe02,
          p_ahf03   LIKE ahf_file.ahf03,
          p_ahf00   LIKE ahf_file.ahf00,   #No.FUN-730020
          p_ahf01   LIKE ahf_file.ahf01
  
   LET g_errno = ''
 
   CASE 
     WHEN p_ahf03 = '1'      LET l_feld1='aag15'
     WHEN p_ahf03 = '2'      LET l_feld1='aag16'
     WHEN p_ahf03 = '3'      LET l_feld1='aag17'
     WHEN p_ahf03 = '4'      LET l_feld1='aag18'
     WHEN p_ahf03 = '5'      LET l_feld1='aag31'
     WHEN p_ahf03 = '6'      LET l_feld1='aag32'
     WHEN p_ahf03 = '7'      LET l_feld1='aag33'
     WHEN p_ahf03 = '8'      LET l_feld1='aag34'
     WHEN p_ahf03 = '9'      LET l_feld1='aag35'
     WHEN p_ahf03 = '10'     LET l_feld1='aag36'
     WHEN p_ahf03 = '99'     LET l_feld1='aag37'
   END CASE
   LET g_sql = " SELECT ",l_feld1,
               "  FROM aag_file WHERE aag01='",p_ahf01,"'",
                               "  AND aag00='",p_ahf00,"'"  #No.FUN-730020
   PREPARE i120_p1 FROM g_sql
   DECLARE i120_c1 CURSOR FOR i120_p1
   OPEN i120_c1
   FETCH i120_c1 INTO l_aag15
   CLOSE i120_c1  
   IF cl_null(l_aag15) THEN
      #此異動碼序無對應的異動碼代號!
      LET g_errno = 'agl-055'
   END IF
   LET l_ahe02 =NULL
   SELECT ahe02 INTO l_ahe02 FROM ahe_file WHERE ahe01 = l_aag15 
             
   RETURN l_ahe02
 
END FUNCTION
 
#start FUN-620023
#FUNCTION i120_gae04(p_ahf02,p_ahf04)
#   DEFINE   p_ahf02   LIKE ahf_file.ahf02,  
#            p_ahf04   LIKE ahf_file.ahf04,
#            l_gae04   LIKE gae_file.gae04
# 
#   LET l_gae04 = NULL
#   SELECT gae04 INTO l_gae04 FROM gae_file
#    WHERE gae01 = p_ahf02
#      AND gae02 = p_ahf04
#      AND gae03 = g_lang
#      AND gae11 = 'Y'
#   IF cl_null(l_gae04) THEN
#     SELECT gae04 INTO l_gae04 FROM gae_file
#      WHERE gae01 = p_ahf02
#        AND gae02 = p_ahf04
#        AND gae03 = g_lang
#        AND gae11 = 'N'
#   END IF
# 
#   RETURN l_gae04
#
#END FUNCTION
FUNCTION i120_gaq03(p_ahf04)
   DEFINE   p_ahf04   LIKE ahf_file.ahf04,  
            l_gaq03   LIKE gaq_file.gaq03
 
   LET l_gaq03 = NULL
   SELECT gaq03 INTO l_gaq03 FROM gaq_file
    WHERE gaq01 = p_ahf04
      AND gaq02 = g_lang
   RETURN l_gaq03
 
END FUNCTION
#end FUN-620023
 
FUNCTION i120_chk_ahf04(p_cmd)
  DEFINE p_cmd        LIKE type_file.chr1,     #1:欄位檢查   2:回傳controlp需要的參數     #No.FUN-680098 VARCHAR(1)
         l_n          LIKE type_file.num10,    #No.FUN-680098     INTEGER                   
        #l_gae01      LIKE gae_file.gae01      #FUN-620023 mark
         l_gaq01      LIKE gaq_file.gaq01,     #FUN-620023
         l_ahe03      LIKE ahe_file.ahe03      #CHI-B50048
 
  LET g_errno = ''
  LET g_tabname =''
 
  #檢查是否存在於p_perlang中
  IF p_cmd ='1' THEN  #要對欄位進行檢查
     LET l_n = 0 
     CALL i120_ahe03(g_ahf[l_ac].ahf03) RETURNING l_ahe03 #CHI-B50048 
     CASE l_ahe03                                         #CHI-B50048
        WHEN '1'                                          #CHI-B50048
          #start FUN-620023
          #SELECT COUNT(*) INTO l_n FROM gae_file
          # WHERE gae01 = g_ahf[l_ac].ahf02
          #   AND gae02 = g_ahf[l_ac].ahf04
          #   AND gae03 = g_lang
           SELECT COUNT(*) INTO l_n FROM gaq_file
            WHERE gaq01 = g_ahf[l_ac].ahf04
              AND gaq02 = g_lang
          #end FUN-620023
    #-CHI-B50048-add-
          IF cl_null(l_n) THEN LET l_n = 0 END IF 
        WHEN '2' 
           SELECT COUNT(*) INTO l_n 
             FROM aee_file
            WHERE aee00 = g_ahf00
              AND aee01 = g_ahf01
              AND aee02 = g_ahf[l_ac].ahf03
              AND aee03 = g_ahf[l_ac].ahf04
          IF cl_null(l_n) THEN LET l_n = 0 END IF 
     END CASE   
    #-CHI-B50048-end-
     IF l_n = 0 THEN
        LET g_errno = 'agl-054'
        #此預設值欄位不為交易作業之預設值來源，請檢查!
        CALL cl_err('',g_errno,1)
        RETURN
     END IF
  END IF
 
  CASE
    #str CHI-9B0017 mod
    #WHEN g_ahf[l_ac].ahf02 = 'aapt110'    LET g_tabname = 'apa'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt120'    LET g_tabname = 'apa'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt150'    LET g_tabname = 'apa'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt210'    LET g_tabname = 'apa'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt220'    LET g_tabname = 'apa'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt330'    LET g_tabname = 'apf'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt711'    LET g_tabname = 'ala'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt720'    LET g_tabname = 'ala'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt740'    LET g_tabname = 'ala'
    #WHEN g_ahf[l_ac].ahf02 = 'aapt741'    LET g_tabname = 'ala'
     WHEN (g_ahf[l_ac].ahf02 = 'aapt110' OR g_ahf[l_ac].ahf02 = 'aapt120' OR
           g_ahf[l_ac].ahf02 = 'aapt121' OR g_ahf[l_ac].ahf02 = 'aapt150' OR
           g_ahf[l_ac].ahf02 = 'aapt151' OR g_ahf[l_ac].ahf02 = 'aapt160' OR
           g_ahf[l_ac].ahf02 = 'aapt210' OR g_ahf[l_ac].ahf02 = 'aapt220' OR
           g_ahf[l_ac].ahf02 = 'aapt260' OR g_ahf[l_ac].ahf02 = 'aapp110' OR
           g_ahf[l_ac].ahf02 = 'aapp111' OR g_ahf[l_ac].ahf02 = 'aapp112' OR
           g_ahf[l_ac].ahf02 = 'aapp115' OR g_ahf[l_ac].ahf02 = 'aapp117' OR
           g_ahf[l_ac].ahf02 = 'gapq600')
       #LET g_tabname = 'apa'              #FUN-A10105 mark
        LET g_tabname = 'apa'              #FUN-A10105
        LET g_tabname1[1] = 'apa'          #FUN-A10105
        LET g_tabname1[2] = 'apb'          #FUN-A10105
    #WHEN (g_ahf[l_ac].ahf02 = 'aapt330' OR g_ahf[l_ac].ahf02 = 'aapt331' OR  #MOD-A90076 mark
    #      g_ahf[l_ac].ahf02 = 'aapp310')                                     #MOD-A90076 mark
    #   LET g_tabname = 'apf'                                                 #MOD-A90076 mark
     WHEN (g_ahf[l_ac].ahf02 = 'aapt711' OR g_ahf[l_ac].ahf02 = 'aapt720' OR
           g_ahf[l_ac].ahf02 = 'aapt740' OR g_ahf[l_ac].ahf02 = 'aapt741')
        LET g_tabname = 'ala'
    #end CHI-9B0017 mod
     WHEN g_ahf[l_ac].ahf02 = 'aapt810'    LET g_tabname = 'alk'
     WHEN g_ahf[l_ac].ahf02 = 'aapt820'    LET g_tabname = 'alh'
     WHEN g_ahf[l_ac].ahf02 = 'aapt900'    LET g_tabname = 'aqa'  #CHI-9B0017 mod
     WHEN g_ahf[l_ac].ahf02 = 'axrt200'    LET g_tabname = 'ola'
     WHEN g_ahf[l_ac].ahf02 = 'axrt201'    LET g_tabname = 'ole'
     WHEN g_ahf[l_ac].ahf02 = 'axrt210'    LET g_tabname = 'olc'
    #str CHI-9B0017 mod
    #WHEN g_ahf[l_ac].ahf02 = 'axrt300'    LET g_tabname = 'oma'
     WHEN (g_ahf[l_ac].ahf02 = 'axrt300' OR g_ahf[l_ac].ahf02 = 'axrp310' OR
           g_ahf[l_ac].ahf02 = 'axrp304' OR g_ahf[l_ac].ahf02 = 'axrp330' OR
           g_ahf[l_ac].ahf02 = 'gxrq600' )
        LET g_tabname = 'oma'
    #end CHI-9B0017 mod
    #WHEN g_ahf[l_ac].ahf02 = 'axrt400'    LET g_tabname = 'ooa'                #MOD-A90076 mark
     WHEN g_ahf[l_ac].ahf02 = 'anmi820'    LET g_tabname = 'gxf'
    #WHEN g_ahf[l_ac].ahf02 = 'anmt150'    LET g_tabname = 'npm'  #CHI-9B0017 mark
     WHEN g_ahf[l_ac].ahf02 = 'anmt200'    LET g_tabname = 'nmh'  #CHI-9B0017 mod
     WHEN g_ahf[l_ac].ahf02 = 'anmt100'    LET g_tabname = 'nmd'  #MOD-DB0107
    #WHEN g_ahf[l_ac].ahf02 = 'anmt250'    LET g_tabname = 'npo'  #CHI-9B0017 mark
    #WHEN g_ahf[l_ac].ahf02 = 'anmt302'    LET g_tabname = 'nmg'  #CHI-9B0017 mark
     WHEN g_ahf[l_ac].ahf02 = 'anmt400'    LET g_tabname = 'gxc'
     WHEN g_ahf[l_ac].ahf02 = 'anmt420'    LET g_tabname = 'gxe'
     WHEN g_ahf[l_ac].ahf02 = 'anmt605'    LET g_tabname = 'gsh'     #CHI-7C0001
     WHEN g_ahf[l_ac].ahf02 = 'anmt710'    LET g_tabname = 'nne'
     WHEN g_ahf[l_ac].ahf02 = 'anmt720'    LET g_tabname = 'nng'
     WHEN g_ahf[l_ac].ahf02 = 'anmt730'    LET g_tabname = 'nnm'
     WHEN g_ahf[l_ac].ahf02 = 'anmt740'    LET g_tabname = 'nni'
     WHEN g_ahf[l_ac].ahf02 = 'anmt750'    LET g_tabname = 'nnk'
     WHEN g_ahf[l_ac].ahf02 = 'anmt820'    LET g_tabname = 'gxg'
     WHEN g_ahf[l_ac].ahf02 = 'anmt830'    LET g_tabname = 'gxh'  #CHI-9B0017 add
     WHEN g_ahf[l_ac].ahf02 = 'anmt840'    LET g_tabname = 'gxi'
     WHEN g_ahf[l_ac].ahf02 = 'anmt850'    LET g_tabname = 'gxk'
     WHEN g_ahf[l_ac].ahf02 = 'anmt920'    LET g_tabname = 'nnv'  #CHI-9B0017 add
     WHEN (g_ahf[l_ac].ahf02 = 'anmt930' OR g_ahf[l_ac].ahf02 = 'anmt940')   #CHI-9B0017 add
        LET g_tabname = 'nnw'                                                #CHI-9B0017 add 
     WHEN g_ahf[l_ac].ahf02 = 'gnmq600'    LET g_tabname = 'oox'  #CHI-9B0017 add
    #str CHI-9B0017 mod
     WHEN (g_ahf[l_ac].ahf02 = 'axmt620' OR g_ahf[l_ac].ahf02 = 'axmt650')
        LET g_tabname = 'oga'
     WHEN g_ahf[l_ac].ahf02 = 'gfat120'  LET g_tabname = 'fbt'
     WHEN g_ahf[l_ac].ahf02 = 'afat101'  LET g_tabname = 'far'
     WHEN g_ahf[l_ac].ahf02 = 'afat102'  LET g_tabname = 'fat'
     WHEN g_ahf[l_ac].ahf02 = 'afat105'  LET g_tabname = 'faz'
     WHEN g_ahf[l_ac].ahf02 = 'afat106'  LET g_tabname = 'fbb'
     WHEN g_ahf[l_ac].ahf02 = 'afat107'  LET g_tabname = 'fbd'
     WHEN g_ahf[l_ac].ahf02 = 'afat108'  LET g_tabname = 'fbh'
     WHEN g_ahf[l_ac].ahf02 = 'afat109'  LET g_tabname = 'fbh'
    #WHEN g_ahf[l_ac].ahf02 = 'afat110'  LET g_tabname = 'fbf'  #CHI-9B0017 mark
    #end CHI-9B0017 mod
     WHEN g_ahf[l_ac].ahf02 = 'afap120'    LET g_tabname = 'fan'
     WHEN g_ahf[l_ac].ahf02 = 'afap520'    LET g_tabname = 'fdd'
    #str CHI-9B0017 add
     WHEN g_ahf[l_ac].ahf02 = 'anmt150'
        LET g_tabname = 'npm'
        LET g_tabname1[1] = 'npm'
        LET g_tabname1[2] = 'nmd'
     WHEN g_ahf[l_ac].ahf02 = 'anmt250'
        LET g_tabname = 'npo'
        LET g_tabname1[1] = 'npo'
        LET g_tabname1[2] = 'nmh'
        LET g_tabname1[3] = 'npn'
     WHEN g_ahf[l_ac].ahf02 = 'anmt302'
        LET g_tabname = 'npk'
        LET g_tabname1[1] = 'npk'
        LET g_tabname1[2] = 'nmg'
     WHEN g_ahf[l_ac].ahf02 = 'afat110'
        LET g_tabname = 'fbf'
        LET g_tabname1[1] = 'fbf'
        LET g_tabname1[2] = 'fbe'
        LET g_tabname1[3] = 'occ'
    #end CHI-9B0017 add
    #-MOD-A90076-add-
     WHEN (g_ahf[l_ac].ahf02 = 'aapt330' OR g_ahf[l_ac].ahf02 = 'aapt331' OR g_ahf[l_ac].ahf02 = 'aapp310' OR
           g_ahf[l_ac].ahf02 = 'aapt332' OR g_ahf[l_ac].ahf02 = 'aapt335')   #No.MOD-C70024
        LET g_tabname = 'apf'
        LET g_tabname1[1] = 'apf'
        LET g_tabname1[2] = 'apg'
        LET g_tabname1[3] = 'aph'
     WHEN (g_ahf[l_ac].ahf02 = 'axrt400' OR g_ahf[l_ac].ahf02 = 'axrt401' OR g_ahf[l_ac].ahf02 = 'axrt410') #No.MOD-B80146
        LET g_tabname = 'ooa'
        LET g_tabname1[1] = 'ooa'
        LET g_tabname1[2] = 'oob'
    #-MOD-A90076-end-
  END CASE
  
  #檢查是否為交易作業相對應的欄位
  IF p_cmd='1' AND NOT cl_null(g_tabname) THEN
    #start FUN-620023   
    #LET g_sql = " SELECT gae01 FROM gae_file ",
    #            "  WHERE gae01 = '",g_ahf[l_ac].ahf02,"'",
    #            "    AND gae02 = '",g_ahf[l_ac].ahf04,"'",
    #            "    AND gae02 LIKE '%",g_tabname,"%' ",
    #            "    AND gae03 = '",g_lang,"'"
    #PREPARE i120_gae_p FROM g_sql
    #DECLARE i120_gae_cs CURSOR FOR i120_gae_p
    #LET l_n = 0
    #FOREACH i120_gae_cs INTO l_gae01
    #  LET l_n = l_n + 1
    #END FOREACH
    #str CHI-9B0017 mod
    #LET g_sql = " SELECT gaq01 FROM gaq_file ",
    #            "  WHERE gaq01 = '",g_ahf[l_ac].ahf04,"'",
    #            "    AND gaq02 = '",g_lang,"'"
     CASE 
        WHEN g_ahf[l_ac].ahf02 = 'anmt150' OR g_ahf[l_ac].ahf02 = 'anmt302' OR g_ahf[l_ac].ahf02 = 'axrt400'  #MOD-A90076 add axrt400 
                                           OR g_ahf[l_ac].ahf02 = 'axrt401' OR g_ahf[l_ac].ahf02 = 'axrt410'  #No.MOD-B80146
                                           OR g_ahf[l_ac].ahf02 MATCHES 'aapt1*' OR g_ahf[l_ac].ahf02 MATCHES 'aapt2*' OR g_ahf[l_ac].ahf02 MATCHES 'aapp1*'   #No.TQC-B80144 add 
           LET g_sql = " SELECT gaq01 FROM gaq_file ",
                       "  WHERE gaq01 = '",g_ahf[l_ac].ahf04,"'",
                       "    AND gaq02 = '",g_lang,"'",
                       "    AND (gaq01 MATCHES '",g_tabname1[1],"*' OR ",
                       "         gaq01 MATCHES '",g_tabname1[2],"*')"
        WHEN g_ahf[l_ac].ahf02 = 'anmt250' OR g_ahf[l_ac].ahf02 = 'afat110' OR g_ahf[l_ac].ahf02 = 'aapt330' OR g_ahf[l_ac].ahf02 = 'aapt331' OR g_ahf[l_ac].ahf02 = 'aapp310' #MOD-A90076 add aapt330/aapt331/aapp310 
                                           OR g_ahf[l_ac].ahf02 = 'aapt332' OR g_ahf[l_ac].ahf02 = 'aapt335'    #No.MOD-C70024
           LET g_sql = " SELECT gaq01 FROM gaq_file ",
                       "  WHERE gaq01 = '",g_ahf[l_ac].ahf04,"'",
                       "    AND gaq02 = '",g_lang,"'",
                       "    AND (gaq01 MATCHES '",g_tabname1[1],"*' OR ",
                       "         gaq01 MATCHES '",g_tabname1[2],"*' OR ",
                       "         gaq01 MATCHES '",g_tabname1[3],"*')"
        OTHERWISE
           LET g_sql = " SELECT gaq01 FROM gaq_file ",
                       "  WHERE gaq01 = '",g_ahf[l_ac].ahf04,"'",
                       "    AND gaq02 = '",g_lang,"'",
                       "    AND gaq01 MATCHES '",g_tabname,"*' "
     END CASE
    #end CHI-9B0017 mod
     PREPARE i120_gaq_p FROM g_sql
     DECLARE i120_gaq_cs CURSOR FOR i120_gaq_p
     LET l_n = 0
     FOREACH i120_gaq_cs INTO l_gaq01
       LET l_n = l_n + 1
     END FOREACH
    #end FUN-620023   
 
    #-CHI-B50048-add-
     IF l_ahe03 = '2' THEN
        SELECT COUNT(*) INTO l_n FROM aee_file
         WHERE aee00 = g_ahf00
           AND aee01 = g_ahf01
           AND aee02 = g_ahf[l_ac].ahf03
           AND aee03 = g_ahf[l_ac].ahf04
        IF cl_null(l_n) THEN LET l_n = 0 END IF 
     END IF
    #-CHI-B50048-end-
     IF l_n = 0 THEN
        LET g_errno = 'agl-054'
        #此預設值欄位不為交易作業之預設值來源，請檢查!
        CALL cl_err('',g_errno,1)
     END IF
  END IF
 
END FUNCTION
 
FUNCTION i120_out()
    DEFINE
        l_ahf         RECORD 
            ahf00          LIKE ahf_file.ahf00,  #No.FUN-730020
            ahf01          LIKE ahf_file.ahf01,
            aag02          LIKE aag_file.aag02,
            ahf02          LIKE ahf_file.ahf02,
            gaz03          LIKE gaz_file.gaz03,
            ahf03          LIKE ahf_file.ahf03,
            ahe02          LIKE ahe_file.ahe02,
            ahf04          LIKE ahf_file.ahf04,
           #gae04          LIKE gae_file.gae04   #FUN-620023 mark
            gaq03          LIKE gaq_file.gaq03   #FUN-620023
                      END RECORD,
        l_i           LIKE type_file.num5,          #No.FUN-680098  SMALLINT
        l_name        LIKE type_file.chr20,         # External(Disk) file name    #No.FUN-680098 VARCHAR(20)
        l_za05        LIKE za_file.za05           #No.FUN-680098  VARCHAR(40)
   
    IF cl_null(g_wc) THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
    LET g_sql="SELECT ahf00,ahf01,'',ahf02,'',ahf03,'',ahf04,'' ",  #No.FUN-730020
              " FROM ahf_file ",                # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY ahf00,ahf01 "  #No.FUN-730020
 
    PREPARE i120_p FROM g_sql                   # RUNTIME 編譯
    DECLARE i120_co CURSOR FOR i120_p           # SCROLL CURSOR
 
    #No.FUN-760085---Begin  
    #CALL cl_outnam('agli120') RETURNING l_name   
    #START REPORT i120_rep TO l_name
    CALL cl_del_data(l_table)
    #No.FUN-760085---End  
    FOREACH i120_co INTO l_ahf.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        SELECT aag02 INTO l_ahf.aag02 FROM aag_file
         WHERE aag01 = l_ahf.ahf01
           AND aag00 = l_ahf.ahf00  #No.FUN-730020
           AND aagacti ='Y'
        CALL i120_gaz03(l_ahf.ahf02) RETURNING l_ahf.gaz03
        CALL i120_ahe02(l_ahf.ahf00,l_ahf.ahf01,l_ahf.ahf03) RETURNING l_ahf.ahe02  #No.FUN-730020
       #CALL i120_gae04(l_ahf.ahf02,l_ahf.ahf04) RETURNING l_ahf.gae04   #FUN-620023 mark
        CALL i120_gaq03(l_ahf.ahf04) RETURNING l_ahf.gaq03               #FUN-620023
        #No.FUN-760085---Begin        
        #OUTPUT TO REPORT i120_rep(l_ahf.*)
        EXECUTE insert_prep USING l_ahf.ahf00,l_ahf.ahf01,l_ahf.aag02,
                                  l_ahf.ahf02,l_ahf.gaz03,l_ahf.ahf03,
                                  l_ahf.ahe02,l_ahf.ahf04,
                                  l_ahf.gaq03 
        #No.FUN-760085---End 
    END FOREACH
 
    #FINISH REPORT i120_rep       #No.FUN-760085
 
    CLOSE i120_co
    ERROR ""
    #No.FUN-760085---Begin
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'ahf00,ahf01,ahf02,ahf03,ahf04')                                                              
            RETURNING g_str                                                                                                          
    END IF                                                                                                                          
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                              
    CALL cl_prt_cs3('agli120','agli120',l_sql,g_str)   
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i120_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680098   VARCHAR(1)
        sr            RECORD 
            ahf00          LIKE ahf_file.ahf00,  #No.FUN-730020
            ahf01          LIKE ahf_file.ahf01,
            aag02          LIKE aag_file.aag02,
            ahf02          LIKE ahf_file.ahf02,
            gaz03          LIKE gaz_file.gaz03,
            ahf03          LIKE ahf_file.ahf03,
            ahe02          LIKE ahe_file.ahe02,
            ahf04          LIKE ahf_file.ahf04,
           #gae04          LIKE gae_file.gae04   #FUN-620023 mark
            gaq03          LIKE gaq_file.gaq03   #FUN-620023
                      END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ahf00,sr.ahf01,sr.ahf02  #No.FUN-730020
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[10],sr.ahf00  #No.FUN-730020
            PRINT g_x[11],sr.ahf01
            PRINT g_x[12],sr.aag02
            PRINT ''
            PRINT g_x[31] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,
                  g_x[37] CLIPPED,g_x[38] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.ahf01
             SKIP TO TOP OF PAGE 
 
        ON EVERY ROW
           PRINT  COLUMN g_c[33],sr.ahf02,
                  COLUMN g_c[34],sr.gaz03,
                  COLUMN g_c[35],sr.ahf03,
                  COLUMN g_c[36],sr.ahe02,
                  COLUMN g_c[37],sr.ahf04,
                 #COLUMN g_c[38],sr.gae04   #FUN-620023 mark
                  COLUMN g_c[38],sr.gaq03   #FUN-620023
 
        ON LAST ROW
            IF g_zz05 = 'Y'          
               THEN PRINT g_dash[1,g_len]
                    #TQC-630166
                    #IF g_wc[001,080] > ' ' THEN
		    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                    #IF g_wc[071,140] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                    #IF g_wc[141,210] > ' ' THEN
		    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)
            END IF
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
#No.FUN-760085---End

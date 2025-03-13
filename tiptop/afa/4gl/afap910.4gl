# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afap910.4gl
# Descriptions...: 抵押資產解除設定作業
# Date & Author..: 96/06/11 By Star
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490344 04/09/20 By Kitty  controlp 少display
# Modify.........: No.MOD-4A0020 04/10/04 By Kitty  進入程式若沒有資料不可作確認及取消確認
# Modify.........: No.MOD-4A0248 04/10/26 By Yuna QBE開窗開不出來
#
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加
#                                                           g_rec_b初始化命令
#                                                          "LET g_rec_b =0"
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/01/19 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760105 07/06/23 By Smapmin 修改update faj_file 邏輯
# Modify.........: No.TQC-770129 07/08/02 By wujie   解除金額不能大于單頭申請編號對應的扺押金額的余額
# Modify.........: No.MOD-7C0089 07/12/17 By Smapmin 修改原因性質
# Modify.........: No.TQC-770098 08/11/24 By wujie   更改時，不用把審核碼改為'Y'
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B20180 11/02/25 By yinhy 手動新增資料，狀態頁簽的“資料建立者”“資料建立部門”欄位未帶出相應的數據。
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-BB0113 11/11/22 By xuxz      處理固資財簽二重測BUG
# Modify.........: No:TQC-C40251 12/04/26 By lujh   查詢未審核資料，下方顯示有三筆資料，刪除當前第一筆後，畫面清空，當前畫面應該顯示原第二筆資料。
# Modify.........: No:TQC-C70165 12/07/24 By lujh 輸入單身時，單身的【抵押金額】應帶入afat900中的fcd07欄位的金額，而不是申請金額fcd03
#                                                 刪除單頭單身後，單身fcg_file的資料沒有刪除，fcf_file資料刪除
# Modify.........: No.TQC-C70177 12/07/25 By lujh 已錄入抵押申請財產編號的抵押申請單作廢，則輸入完單頭，自動產生單身的afat900s、afat900a界面應不需要過濾掉
# Modify.........: No.TQC-C70190 12/07/25 By lujh fill()函數中SELECT的字段數量和g_fcg中的不一樣
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_fcf   RECORD LIKE fcf_file.*,
    g_fcf_t RECORD LIKE fcf_file.*,
    g_fcf_o RECORD LIKE fcf_file.*,
    g_fcg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    fcg02     LIKE fcg_file.fcg02,
                    fcg04     LIKE fcg_file.fcg04,
                    fcg041    LIKE fcg_file.fcg041,
                    fcg03     LIKE fcg_file.fcg03,
                    fcg031    LIKE fcg_file.fcg031,
                    faj43     LIKE faj_file.faj43,
                    faj432    LIKE faj_file.faj432,   #No:FUN-AB0088
                    fcg05     LIKE fcg_file.fcg05,
                    fcg06     LIKE fcg_file.fcg06,
                    fcg07     LIKE fcg_file.fcg07
                    END RECORD,
    g_fcg_t         RECORD
                    fcg02     LIKE fcg_file.fcg02,
                    fcg04     LIKE fcg_file.fcg04,
                    fcg041    LIKE fcg_file.fcg041,
                    fcg03     LIKE fcg_file.fcg03,
                    fcg031    LIKE fcg_file.fcg031,
                    faj43     LIKE faj_file.faj43,
                    faj432    LIKE faj_file.faj432,   #No:FUN-AB0088
                    fcg05     LIKE fcg_file.fcg05,
                    fcg06     LIKE fcg_file.fcg06,
                    fcg07     LIKE fcg_file.fcg07
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fcf01_t       LIKE fcf_file.fcf01,
    g_fcg06         LIKE fcg_file.fcg06,
   #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,#TQC-630166       #No.FUN-680070 VARCHAR(1000)
    g_wc,g_wc2,g_sql    STRING    , #TQC-630166
    g_t1                LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
    g_buf           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
 
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #查詢指定的筆數     #TQC-C40251  add
DEFINE   g_no_ask       LIKE type_file.num5         #是否開啟指定筆視窗  #TQC-C40251  add
MAIN
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE
#    l_time        LIKE type_file.chr8,                 #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
    l_sql         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
    IF INT_FLAG THEN EXIT PROGRAM END IF
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                  #NO.FUN-6A0069
 
    LET g_wc2 = ' 1=1'
    LET g_forupd_sql = "SELECT * FROM fcf_file WHERE fcf01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p910_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW p910_w AT p_row ,p_col WITH FORM "afa/42f/afap910"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

    #-----No:FUN-AB0088-----
    IF g_faa.faa31 = 'N' THEN
       CALL cl_set_comp_visible("faj432",FALSE)
    END IF
    #-----No:FUN-AB0088 END-----
 
    CALL p910_menu()
    CLOSE WINDOW p910_w                    #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #FUN-6A0069
        RETURNING g_time                  #FUN-6A0069
END MAIN
 
FUNCTION p910_cs()
    CLEAR FORM                             #清除畫面
    CALL g_fcg.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0029 
 
   INITIALIZE g_fcf.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON            # 螢幕上取單頭條件
        fcf01,fcf02,fcf03,fcf04,
        fcfconf,fcfuser,fcfgrup,fcfmodu,fcfdate,
        fcforiu,fcforig         #TQC-B20180
          #--No.MOD-4A0248--------
         ON ACTION CONTROLP
           CASE WHEN INFIELD(fcf03) #申請編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_fcf"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO fcf03
                     NEXT FIELD fcf03
           OTHERWISE EXIT CASE
           END CASE
         #--END---------------
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND fcfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND fcfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND fcfgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fcfuser', 'fcfgrup')
    #End:FUN-980030
 
    CONSTRUCT g_wc2 ON fcg02,fcg04,fcg041,fcg03,fcg031,faj43,faj432,fcg05,     #No:FUN-AB0088
                       fcg06,fcg07
            FROM       s_fcg[1].fcg02,s_fcg[1].fcg04,s_fcg[1].fcg041,
                       s_fcg[1].fcg03,s_fcg[1].fcg031,s_fcg[1].faj43,s_fcg[1].faj432,     #No:FUN-AB0088
                       s_fcg[1].fcg05,s_fcg[1].fcg06,s_fcg[1].fcg07
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT fcf01 FROM fcf_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fcf01 ",
                   "  FROM fcf_file, fcg_file",
                   " WHERE fcf01 = fcg01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE p910_prepare FROM g_sql
    DECLARE p910_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p910_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fcf_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fcf01) FROM fcf_file,fcg_file",
                  " WHERE fcg01 = fcf01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE p910_count_pre FROM g_sql
    DECLARE p910_count CURSOR FOR p910_count_pre
END FUNCTION
 
#中文的MENU
FUNCTION p910_menu()
   WHILE TRUE
      CALL p910_bp("G")
      CASE g_action_choice
           WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p910_a()
            END IF
           WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p910_q()
            END IF
           WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p910_u()
            END IF
           WHEN "delete"
            IF cl_chk_act_auth() THEN
                CALL p910_r()
            END IF
           WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL p910_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #@WHEN "Y.確認"
           WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL p910_y()
            END IF
         #@WHEN "Z.取消確認"
           WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL p910_z()
            END IF
           WHEN "help"     CALL cl_show_help()
           WHEN "exit"     EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p910_a()
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fcg.clear()
    INITIALIZE g_fcf.* TO NULL
    LET g_fcf01_t = NULL
    LET g_fcf_o.* = g_fcf.*
    
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fcf.fcf02  =g_today
        LET g_fcf.fcf04 = 0
        LET g_fcf.fcfconf='N'
        LET g_fcf.fcfprsw=0
        LET g_fcf.fcfuser=g_user
        LET g_fcf.fcfgrup=g_grup
        LET g_fcf.fcfdate=g_today
        LET g_fcf.fcflegal=g_legal      #FUN-980003 add
        LET g_fcf.fcforiu=g_user   #TQC-B20180
        LET g_fcf.fcforig=g_grup   #TQC-B20180
        BEGIN WORK
        CALL p910_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        IF g_fcf.fcf01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        {
        IF g_fah.fahauno='Y' THEN
           CALL s_afaauno(g_fcf.fcf01) RETURNING g_i,g_fcf.fcf01
           IF g_i THEN CONTINUE WHILE END IF    #有問題
           DISPLAY BY NAME g_fcf.fcf01
        END IF
        }
        IF cl_null(g_fcf.fcf03) THEN
           SELECT COUNT(*)  FROM fcd_file
            WHERE fcd01 = g_fcf.fcf03
              AND fcdconf !='X'  #010803增
             IF STATUS THEN 
#            CALL cl_err('NOT FOUND ',SQLCA.SQLCODE,0)   #No.FUN-660136
             CALL cl_err3("sel","fcd_file",g_fcf.fcf03,"",SQLCA.sqlcode,"","NOT FOUND ",0)   #No.FUN-660136
              CONTINUE WHILE
           END IF
        END IF
        LET g_fcf.fcforiu = g_user      #No.FUN-980030 10/01/04
        LET g_fcf.fcforig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO fcf_file VALUES (g_fcf.*)
        IF SQLCA.SQLCODE THEN
#          CALL cl_err('Ins:',SQLCA.SQLCODE,1)   #No.FUN-660136
           CALL cl_err3("ins","fcf_file",g_fcf.fcf01,"",SQLCA.sqlcode,"","Ins:",1)   #No.FUN-660136
           CONTINUE WHILE
        END IF
        COMMIT WORK
        FOR g_cnt = 1 TO g_fcg.getLength()
            INITIALIZE g_fcg[g_cnt].* TO NULL
        END FOR
        LET g_fcf_t.* = g_fcf.*
        LET g_fcf01_t = g_fcf.fcf01
        LET g_rec_b = 0
        IF NOT cl_null(g_fcf.fcf03) THEN
           CALL p910_g()
           CALL p910_b()
        ELSE
           CALL p910_b()
        END IF
        SELECT fcf01 INTO g_fcf.fcf01
          FROM fcf_file
         WHERE fcf01 = g_fcf.fcf01
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION p910_u()
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fcf.fcf01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_fcf.fcfconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fcf01_t = g_fcf.fcf01
    LET g_fcf_o.* = g_fcf.*
    BEGIN WORK
    OPEN p910_cl USING g_fcf.fcf01
    FETCH p910_cl INTO g_fcf.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcf.fcf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE p910_cl ROLLBACK WORK RETURN
    END IF
    CALL p910_show()
    WHILE TRUE
        LET g_fcf.fcf02  =g_today
        LET g_fcf01_t = g_fcf.fcf01
#       LET g_fcf.fcfconf='Y'              #確認碼無效   #TQC-770098
        LET g_fcf.fcfprsw=0                #列印次數
        LET g_fcf.fcfuser=g_user
        LET g_fcf.fcfgrup=g_grup
        LET g_fcf.fcfdate=g_today
        LET g_fcf.fcfmodu=g_user           #TQC-B20180
        CALL p910_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fcf.*=g_fcf_t.*
            CALL p910_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fcf.fcf01 != g_fcf_t.fcf01 THEN
           UPDATE fcg_file SET fcg01=g_fcf.fcf01 WHERE fcg01=g_fcf_t.fcf01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err('upd fcg01',SQLCA.SQLCODE,1)   #No.FUN-660136
              CALL cl_err3("upd","fcg_file",g_fcf_t.fcf01,"",SQLCA.sqlcode,"","upd fcg01",1)   #No.FUN-660136
              LET g_fcf.*=g_fcf_t.*
              CALL p910_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fcf_file SET * = g_fcf.*
         WHERE fcf01 = g_fcf01_t
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
#          CALL cl_err(g_fcf.fcf01,SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("upd","fcf_file",g_fcf_t.fcf01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660136
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE p910_cl
       COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION p910_i(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
            l_flag   LIKE type_file.chr1,                #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
            l_n1     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_occ    RECORD LIKE occ_file.*
   DEFINE   l_fcd07  LIKE fcd_file.fcd07    #No.TQC-770129                                                                          
   DEFINE   l_fcf04  LIKE fcf_file.fcf04    #No.TQC-770129  
 
   CALL cl_set_head_visible("","YES")             #No.FUN-6B0029 
 
   INPUT BY NAME
      g_fcf.fcf01,g_fcf.fcf02,g_fcf.fcf03,g_fcf.fcf04,
      g_fcf.fcfconf,g_fcf.fcfuser,g_fcf.fcfgrup,
      g_fcf.fcfmodu,g_fcf.fcfdate,
      g_fcf.fcforiu,g_fcf.fcforig   #TQC-B20180
      WITHOUT DEFAULTS
 
      BEFORE FIELD fcf01
         IF p_cmd = 'u' AND g_chkey = 'N' THEN
            NEXT FIELD fcf02
         END IF
 
      AFTER FIELD fcf01
        #IF cl_null(g_fcf.fcf01) THEN
        #   NEXT FIELD fcf01
        #END IF
         IF g_fcf.fcf01 != g_fcf_t.fcf01 OR g_fcf_t.fcf01 IS NULL THEN
            SELECT count(*) INTO g_cnt FROM fcf_file WHERE fcf01 = g_fcf.fcf01
            IF g_cnt > 0 THEN   #資料重複
               CALL cl_err(g_fcf.fcf01,-239,0)
               LET g_fcf.fcf01 = g_fcf_t.fcf01
               DISPLAY BY NAME g_fcf.fcf01
               NEXT FIELD fcf01
            END IF
         END IF
         LET g_fcf_o.fcf01 = g_fcf.fcf01
 
      AFTER FIELD fcf03
         IF NOT cl_null(g_fcf.fcf03) THEN
            SELECT count(*) INTO g_cnt FROM fce_file WHERE fce01 = g_fcf.fcf03
            IF g_cnt < 1 THEN   #資料需存在資產抵押檔中
               CALL cl_err(g_fcf.fcf03,STATUS,0)
               LET g_fcf.fcf03 = g_fcf_t.fcf03
               DISPLAY BY NAME g_fcf.fcf03
               NEXT FIELD fcf03
            END IF
         END IF
         IF cl_null(g_fcf.fcf03) THEN
            LET g_fcf.fcf03 = ' '
         END IF
 
#No.TQC-770129--begin                                                                                                               
      BEFORE FIELD fcf04                                                                                                            
         IF NOT cl_null(g_fcf.fcf03) THEN                                                                                           
            SELECT fcd07 INTO l_fcd07                                                                                               
              FROM fcd_file                                                                                                         
             WHERE fcd01 =g_fcf.fcf03                                                                                               
            IF cl_null(l_fcd07) THEN                                                                                                
               CALL cl_err('','afa-514',1)                                                                                          
               LET g_fcf.fcf03 =NULL                                                                                                
               NEXT FIELD fcf03                                                                                                     
            ELSE                                                                                                                    
               SELECT SUM(fcf04) INTO l_fcf04                                                                                       
                 FROM fcf_file                                                                                                      
                WHERE fcf03 =g_fcf.fcf03                                                                                            
               IF cl_null(l_fcf04) THEN                                                                                             
                  LET l_fcf04 =0                                                                                                    
               END IF                                                                                                               
               IF p_cmd ='a' THEN                                                                                                   
                  LET g_fcf.fcf04 =l_fcd07 -l_fcf04                                                                                 
               ELSE                                                                                                                 
                  LET g_fcf.fcf04 =l_fcd07 -l_fcf04+g_fcf_t.fcf04                                                                   
               END IF                                                                                                               
            END IF 
         END IF                                                                                                                     
                                                                                                                                    
      AFTER FIELD fcf04                                                                                                             
         IF NOT cl_null(g_fcf.fcf03) THEN                                                                                           
            SELECT fcd07 INTO l_fcd07                                                                                               
              FROM fcd_file                                                                                                         
             WHERE fcd01 =g_fcf.fcf03                                                                                               
            IF cl_null(l_fcd07) THEN                                                                                                
               CALL cl_err('','afa-514',1)                                                                                          
               LET g_fcf.fcf03 =NULL                                                                                                
               NEXT FIELD fcf03                                                                                                     
            ELSE                                                                                                                    
               SELECT SUM(fcf04) INTO l_fcf04                                                                                       
                 FROM fcf_file                                                                                                      
                WHERE fcf03 =g_fcf.fcf03                                                                                            
               IF cl_null(l_fcf04) THEN                                                                                             
                  LET l_fcf04 =0                                                                                                    
               END IF                                                                                                               
               IF p_cmd ='a' THEN                                                                                                   
                  IF g_fcf.fcf04 > (l_fcd07 -l_fcf04) THEN                                                                          
                     CALL cl_err('','afa-512',1)                                                                                    
                     LET g_fcf.fcf04 =g_fcf_t.fcf04                                                                                 
                     NEXT FIELD fcf04  
                  END IF                                                                                                            
               ELSE                                                                                                                 
                  IF g_fcf.fcf04 >(l_fcd07 -l_fcf04+g_fcf_t.fcf04) THEN                                                             
                     CALL cl_err('','afa-512',1)                                                                                    
                     LET g_fcf.fcf04 =g_fcf_t.fcf04                                                                                 
                     NEXT FIELD fcf04                                                                                               
                  END IF                                                                                                            
               END IF                                                                                                               
            END IF                                                                                                                  
         END IF                                                                                                                     
                                                                                                                                    
#No.TQC-770129--end 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(fcf03)
#              CALL q_fcd1(10,3,g_fcf.fcf03) RETURNING g_fcf.fcf03
#              CALL FGL_DIALOG_SETBUFFER( g_fcf.fcf03 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fcd1"
               LET g_qryparam.default1 = g_fcf.fcf03
               CALL cl_create_qry() RETURNING g_fcf.fcf03
#               CALL FGL_DIALOG_SETBUFFER( g_fcf.fcf03 )
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(' ',g_errno,0)
                  NEXT FIELD fcf03
               END IF
                DISPLAY BY NAME g_fcf.fcf03                #No.MOD-490344
               NEXT FIELD fcf03
            OTHERWISE
               EXIT CASE
            END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      #MOD-650015 --start 
     # ON ACTION CONTROLO                        # 沿用所有欄位
     #    IF INFIELD(fcf01) THEN
     #       LET g_fcf.* = g_fcf_t.*
     #       LET g_fcf.fcf01 = ' '
     #       LET g_fcf.fcfconf = 'N'
     #       CALL p910_show()
     #       NEXT FIELD fcf01
     #    END IF
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
 
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
 
   END INPUT
END FUNCTION
 
FUNCTION p910_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL p910_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fcf.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN p910_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fcf.* TO NULL
    ELSE
       OPEN p910_count
       FETCH p910_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
        CALL p910_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION p910_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        #TQC-C40251--mod--str--
        #WHEN 'N' FETCH NEXT     p910_cs INTO g_fcf.fcf01,g_fcf.fcf01
        #WHEN 'P' FETCH PREVIOUS p910_cs INTO g_fcf.fcf01,g_fcf.fcf01
        #WHEN 'F' FETCH FIRST    p910_cs INTO g_fcf.fcf01,g_fcf.fcf01
        #WHEN 'L' FETCH LAST     p910_cs INTO g_fcf.fcf01,g_fcf.fcf01

        WHEN 'N' FETCH NEXT     p910_cs INTO g_fcf.fcf01
        WHEN 'P' FETCH PREVIOUS p910_cs INTO g_fcf.fcf01
        WHEN 'F' FETCH FIRST    p910_cs INTO g_fcf.fcf01
        WHEN 'L' FETCH LAST     p910_cs INTO g_fcf.fcf01
        #TQC-C40251--mod--end--
        WHEN '/'
             IF (NOT g_no_ask) THEN    #TQC-C40251  add
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                #PROMPT g_msg CLIPPED,': ' FOR l_abso  #TQC-C40251  mark
                PROMPT g_msg CLIPPED,': ' FOR g_jump   #TQC-C40251  add
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
             END IF          #TQC-C40251  add
             #FETCH ABSOLUTE l_abso p910_cs INTO g_fcf.fcf01,g_fcf.fcf01   #TQC-C40251  mark
             FETCH ABSOLUTE g_jump p910_cs INTO g_fcf.fcf01     #TQC-C40251  add
             LET g_no_ask = FALSE      #TQC-C40251  add
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcf.fcf01,SQLCA.sqlcode,0)
        INITIALIZE g_fcf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          #WHEN '/' LET g_curs_index = l_abso   #TQC-C40251  mark
          WHEN '/' LET g_curs_index = g_jump    #TQC-C40251  add
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
SELECT * INTO g_fcf.* FROM fcf_file WHERE fcf01 = g_fcf.fcf01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fcf.fcf01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fcf_file",g_fcf.fcf01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660136
        INITIALIZE g_fcf.* TO NULL
        RETURN
    END IF
    CALL p910_show()
END FUNCTION
 
FUNCTION p910_show()
    LET g_fcf_t.* = g_fcf.*                #保存單頭舊值
    DISPLAY BY NAME
        g_fcf.fcf01,g_fcf.fcf02,g_fcf.fcf03,g_fcf.fcf04,
        g_fcf.fcfconf, g_fcf.fcfuser,g_fcf.fcfgrup,g_fcf.fcfmodu,g_fcf.fcfdate,
        g_fcf.fcforiu,g_fcf.fcforig      #TQC-B20180
    CALL p910_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p910_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fcf.fcf01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    IF g_fcf.fcfconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    BEGIN WORK
    OPEN p910_cl USING g_fcf.fcf01
    FETCH p910_cl INTO g_fcf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fcf.fcf01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL p910_show()
    IF cl_delh(20,16) THEN
        MESSAGE "Delete fcf,fcg!"
        CALL ui.Interface.refresh()
        DELETE FROM fcf_file WHERE fcf01 = g_fcf.fcf01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('No fcf deleted',SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("del","fcf_file",g_fcf.fcf01,"",SQLCA.sqlcode,"","No fcf deleted",0)   #No.FUN-660136
        #TQC-C70165--mark--str--
        #ELSE
        #   CLEAR FORM
        #   CALL g_fcg.clear()
        #   INITIALIZE g_fcf.* LIKE fcf_file.*
        #TQC-C70165--mark--end--
        END IF
        DELETE FROM fcg_file WHERE fcg01 = g_fcf.fcf01
        #TQC-C70165--add--str-- 
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","fcg_file",g_fcf.fcf01,"",SQLCA.sqlcode,"","No fcg deleted",0)
        ELSE
           CLEAR FORM
           CALL g_fcg.clear()
           INITIALIZE g_fcf.* LIKE fcf_file.*
        END IF       
        #TQC-C70165--add--str--

        #TQC-C40251--add--str-- 
        OPEN p910_count
        FETCH p910_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN p910_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL p910_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE                
           CALL p910_fetch('/')
        END IF
        #TQC-C40251--add--end-- 
    END IF
    CLOSE p910_cl
       COMMIT WORK
END FUNCTION
 
FUNCTION p910_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_b2            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    l_faj06         LIKE faj_file.faj06,
    l_faj18         LIKE faj_file.faj18,
    l_qty           LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(15,3)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_fcf.fcf01 IS NULL THEN RETURN END IF
    IF g_fcf.fcfconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT fcg02,fcg04,fcg041,fcg03,fcg031,'','',fcg05,fcg06,fcg07 ",#FUN-BB0113 add ,''
      "   FROM fcg_file ",
      "  WHERE fcg01 = ? ",
      "    AND fcg02 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p910_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
 
      INPUT ARRAY g_fcg WITHOUT DEFAULTS FROM s_fcg.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
#No.FUN-550034 --start--
         CALL cl_set_docno_format("fcd01")
#No.FUN-550034 ---end---
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_fcg_t.* = g_fcg[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fcg_t.* = g_fcg[l_ac].*  #BACKUP
                OPEN p910_bcl USING g_fcf.fcf01,g_fcg_t.fcg02
                IF SQLCA.sqlcode THEN
                    CALL cl_err('lock fcg',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH p910_bcl INTO g_fcg[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('lock fcg',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
          # LET g_fcg_t.* = g_fcg[l_ac].*  #BACKUP
            IF l_ac <= l_n then                   #DISPLAY NEWEST
                CALL p910_faj()
            END IF
           #NEXT FIELD fcg02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fcg[l_ac].* TO NULL      #900423
            LET g_fcg_t.* = g_fcg[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fcg02
 
        BEFORE FIELD fcg02                            #defcflt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
            IF g_fcg[l_ac].fcg02 IS NULL OR g_fcg[l_ac].fcg02 = 0 THEN
                SELECT max(fcg02)+1 INTO g_fcg[l_ac].fcg02
                   FROM fcg_file WHERE fcg01 = g_fcf.fcf01
                IF g_fcg[l_ac].fcg02 IS NULL THEN
                   LET g_fcg[l_ac].fcg02 = 1
                END IF
            END IF
            END IF
 
        AFTER FIELD fcg02                        #check 序號是否重複
            IF cl_null(g_fcg[l_ac].fcg02) THEN NEXT FIELD fcg02 END IF
            IF g_fcg[l_ac].fcg02 != g_fcg_t.fcg02 OR
               g_fcg_t.fcg02 IS NULL THEN
                SELECT count(*) INTO l_n FROM fcg_file
                 WHERE fcg01 = g_fcf.fcf01
                   AND fcg02 = g_fcg[l_ac].fcg02
                IF l_n > 0 THEN
                    LET g_fcg[l_ac].fcg02 = g_fcg_t.fcg02
                    CALL cl_err('',-239,0)
                    NEXT FIELD fcg02
                END IF
            END IF
 
        AFTER FIELD fcg04
           IF cl_null(g_fcg[l_ac].fcg04) THEN
              NEXT FIELD fcg04
           ELSE
              SELECT COUNT(*) INTO g_cnt FROM fce_file
               WHERE fce01 = g_fcg[l_ac].fcg04
                IF g_cnt = 0 THEN
### Modify:2571 98/10/20 將errror message 'afa-102' 改為 'afa-362'
                   CALL cl_err(g_fcg[l_ac].fcg04,'afa-362',0)
                   LET g_fcg[l_ac].fcg04 = g_fcg_t.fcg04
                   NEXT FIELD fcg04
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_fcg[l_ac].fcg04
                   #------MOD-5A0095 END------------
                END IF
#No.TQC-770129--begin                                                                                                               
                IF NOT cl_null(g_fcf.fcf03) THEN                                                                                    
                   IF g_fcg[l_ac].fcg04 <> g_fcf.fcf03 THEN                                                                         
                      CALL cl_err('','afa-513',1)                                                                                   
                      LET g_fcg[l_ac].fcg04 =g_fcg_t.fcg04                                                                          
                      NEXT fIELD fcg04                                                                                              
                   END IF                                                                                                           
                END IF                                                                                                              
#No.TQC-770129--end     
           END IF
 
        AFTER FIELD fcg041
           IF cl_null(g_fcg[l_ac].fcg041) THEN
              NEXT FIELD fcg041
           ELSE
              SELECT COUNT(*) INTO g_cnt FROM fce_file
               WHERE fce01 = g_fcg[l_ac].fcg04
                 AND fce02 = g_fcg[l_ac].fcg041
                IF g_cnt = 0 THEN
## Modify:2571
                   CALL cl_err(g_fcg[l_ac].fcg041,'afa-362',0)
                   LET g_fcg[l_ac].fcg041 = g_fcg_t.fcg041
                   NEXT FIELD fcg041
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_fcg[l_ac].fcg041
                   #------MOD-5A0095 END------------
                END IF
                CALL p910_fcg04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fcg[l_ac].fcg04,g_errno,0)
                  LET g_fcg[l_ac].fcg04 = g_fcg_t.fcg04
                  NEXT FIELD fcg04
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_fcg[l_ac].fcg04
                  #------MOD-5A0095 END------------
               END IF
           END IF
 
 
        AFTER FIELD fcg07
           IF cl_null(g_fcg[l_ac].fcg07) THEN
              LET g_fcg[l_ac].fcg07 = ''
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_fcg[l_ac].fcg07
              #------MOD-5A0095 END------------
           END IF
           IF NOT cl_null(g_fcg[l_ac].fcg07) THEN
              SELECT COUNT(*) INTO g_cnt FROM fag_file
              WHERE fag01 = g_fcg[l_ac].fcg07
                #AND fag02 = 'D'                  #Genero modi   #MOD-7C0089
                AND fag02 = 'F'                  #Genero modi   #MOD-7C0089
              IF g_cnt = 0 THEN
                 CALL cl_err(g_fcg[l_ac].fcg07,'afa-903',1)
                 NEXT FIELD fcg07
              END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fcg_t.fcg02 > 0 AND g_fcg_t.fcg02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fcg_file
                 WHERE fcg01 = g_fcf.fcf01
                   AND fcg02 = g_fcg_t.fcg02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fcg_t.fcg02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fcg_file",g_fcf.fcf01,g_fcg_t.fcg02,SQLCA.sqlcode,"","",0)   #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_fcg[l_ac].* = g_fcg_t.*
              CLOSE p910_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fcg[l_ac].fcg02,-263,1)
               LET g_fcg[l_ac].* = g_fcg_t.*
           ELSE
               UPDATE fcg_file SET
                      fcg01=g_fcf.fcf01,fcg02=g_fcg[l_ac].fcg02,
                      fcg03=g_fcg[l_ac].fcg03,fcg031=g_fcg[l_ac].fcg031,
                      fcg04=g_fcg[l_ac].fcg04,fcg041=g_fcg[l_ac].fcg041,
                      fcg05=g_fcg[l_ac].fcg05,fcg06=g_fcg[l_ac].fcg06,
                      fcg07=g_fcg[l_ac].fcg07
                WHERE fcg01=g_fcf.fcf01 AND fcg02=g_fcg_t.fcg02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err('upd fcg',SQLCA.sqlcode,0)   #No.FUN-660136
                  CALL cl_err3("upd","fcg_file",g_fcf.fcf01,g_fcg_t.fcg02,SQLCA.sqlcode,"","upd fcg",0)   #No.FUN-660136
                  LET g_fcg[l_ac].* = g_fcg_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                     COMMIT WORK
               END IF
           END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
             #CALL g_fcg.deleteElement(l_ac)   #取消 Array Element
             #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
             #   LET g_action_choice = "detail"
             #   LET l_ac = l_ac_t
             #END IF
             #EXIT INPUT
           END IF
 
            INSERT INTO fcg_file (fcg01,fcg02,fcg03,fcg031,fcg04,fcg041,  #No.MOD-470041
                                 fcg05,fcg06,fcg07,fcglegal) #FUN-980003 add
                VALUES(g_fcf.fcf01,g_fcg[l_ac].fcg02,g_fcg[l_ac].fcg03,
                       g_fcg[l_ac].fcg031,g_fcg[l_ac].fcg04,g_fcg[l_ac].fcg041,
                       g_fcg[l_ac].fcg05,g_fcg[l_ac].fcg06,g_fcg[l_ac].fcg07,
                       g_legal) #FUN-980003 add
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
#              CALL cl_err('ins fcg',SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fcg_file",g_fcf.fcf01,g_fcg[l_ac].fcg02,SQLCA.sqlcode,"","ins fcg",0)   #No.FUN-660136
               #LET g_fcg[l_ac].* = g_fcg_t.*
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_fcg[l_ac].* = g_fcg_t.*
              #FUN-D30032--add--begin--
              ELSE
                 CALL g_fcg.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end----
              END IF
              CLOSE p910_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30032 add  
          #LET g_fcg_t.* = g_fcg[l_ac].* #FUN-D30032 mark
           CLOSE p910_bcl
           COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL p910_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fcg02) AND l_ac > 1 THEN
                LET g_fcg[l_ac].* = g_fcg[l_ac-1].*
                LET g_fcg[l_ac].fcg02 = NULL
                NEXT FIELD fcg02
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(fcg04)
#                 CALL q_fcd1(10,3,g_fcg[l_ac].fcg04) RETURNING g_fcg[l_ac].fcg04
#                 CALL FGL_DIALOG_SETBUFFER( g_fcg[l_ac].fcg04 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fcd1"
                  LET g_qryparam.default1 = g_fcg[l_ac].fcg04
                  CALL cl_create_qry() RETURNING g_fcg[l_ac].fcg04
#                  CALL FGL_DIALOG_SETBUFFER( g_fcg[l_ac].fcg04 )
                  CALL p910_fcg04('d')
                  IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fcg04
                  END IF
                   DISPLAY BY NAME g_fcg[l_ac].fcg04              #No.MOD-490344
                  NEXT FIELD fcg04
               WHEN INFIELD(fcg07)                   #類別
#                  CALL q_fag(0,0,g_fcg[l_ac].fcg07,g_fcg[l_ac].faj43) RETURNING g_fcg[l_ac].fcg07
#                  CALL FGL_DIALOG_SETBUFFER( g_fcg[l_ac].fcg07 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_fag"
                   LET g_qryparam.default1 = g_fcg[l_ac].fcg07
                   #LET g_qryparam.arg1 = "D"   #MOD-7C0089
                   LET g_qryparam.arg1 = "F"   #MOD-7C0089
                   CALL cl_create_qry() RETURNING g_fcg[l_ac].fcg07
#                   CALL FGL_DIALOG_SETBUFFER( g_fcg[l_ac].fcg07 )
                   DISPLAY BY NAME g_fcg[l_ac].fcg07              #No.MOD-490344
                   NEXT FIELD fcg07
            OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end  
 
      END INPUT
    CLOSE p910_bcl
    COMMIT WORK
    CALL p910_delall()
END FUNCTION
 
FUNCTION p910_faj()                 #將進口編號、發票號碼、保管部門放至單身
        SELECT faj43,faj432   #No:FUN-AB0088
                  INTO g_fcg[l_ac].faj43,g_fcg[l_ac].faj432   #No:FUN-AB0088
                  FROM faj_file
                 WHERE faj02 = g_fcg[l_ac].fcg03
                   AND faj022= g_fcg[l_ac].fcg031
END FUNCTION
 
FUNCTION p910_fcg04(p_cmd)
 DEFINE   p_cmd          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_cnt          LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_fce03        LIKE fce_file.fce03,
          l_fce031       LIKE fce_file.fce031,
          l_faj43        LIKE faj_file.faj43,
          l_faj432       LIKE faj_file.faj432,   #No:FUN-AB0088
          l_fce05        LIKE fce_file.fce05,
          l_fcd11        LIKE fcd_file.fcd11,
          l_fcd07        LIKE fcd_file.fcd07    #TQC-C70165   add
 
    LET g_errno = ' '
    SELECT fce03,fce031,faj43,faj432,fce05,fcd11,fcd07         #No:FUN-AB0088     #TQC-C70165   add  fcd07
      INTO l_fce03,l_fce031,l_faj43,l_faj432,l_fce05,l_fcd11,l_fcd07    #No:FUN-AB0088   #TQC-C70165   add  fcd07
      FROM faj_file,fce_file,fcd_file
     WHERE fcd01 = g_fcg[l_ac].fcg04
       AND fce02 = g_fcg[l_ac].fcg041
       AND fcd01 = fce01
       AND fcdconf !='X'  #010803增
       AND fce03 = faj02
       AND fce031 = faj022
    CASE
## Modify:2571
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-362'
                                 LET l_fce03  = NULL
                                 LET l_fce031 = NULL
                                 LET l_faj43  = NULL
                                 LET l_faj432 = NULL   #No:FUN-AB0088
                                 LET l_fce05  = NULL
                                 LET l_fcd11  = NULL
                                 LET l_cnt    = NULL
        OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN
       LET  g_fcg[l_ac].fcg03 =  l_fce03
       LET  g_fcg[l_ac].fcg031=  l_fce031
       LET  g_fcg[l_ac].faj43 =  l_faj43
       LET  g_fcg[l_ac].faj432=  l_faj432   #No:FUN-AB0088
       #LET  g_fcg[l_ac].fcg05 =  l_fce05   #TQC-C70165   mark
       LET  g_fcg[l_ac].fcg05 =  l_fcd07    #TQC-C70165   add
       LET  g_fcg[l_ac].fcg06 =  l_fcd11
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_fcg[l_ac].fcg03
       DISPLAY BY NAME g_fcg[l_ac].fcg031
       DISPLAY BY NAME g_fcg[l_ac].faj43
       DISPLAY BY NAME g_fcg[l_ac].faj432   #No:FUN-AB0088
       DISPLAY BY NAME g_fcg[l_ac].fcg05
       DISPLAY BY NAME g_fcg[l_ac].fcg06
       #------MOD-5A0095 END------------
    END IF
 
END FUNCTION
 
FUNCTION p910_delall()
   SELECT COUNT(*) INTO g_cnt FROM fcg_file
    WHERE fcg01 = g_fcf.fcf01
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM fcf_file
       WHERE fcf01 = g_fcf.fcf01
   END IF
END FUNCTION
 
FUNCTION p910_b_askkey()
#DEFINE l_wc2           LIKE type_file.chr1000#TQC-630166       #No.FUN-680070 VARCHAR(200)
 DEFINE l_wc2           STRING    #TQC-630166
 
    CONSTRUCT l_wc2 ON fcg02,fcg04,fcg041,fcg03,fcg031,faj43,faj432,fcg05,     #No:FUN-AB0088
                       fcg06,fcg07
            FROM       s_fcg[1].fcg02,s_fcg[1].fcg04,s_fcg[1].fcg041,
                       s_fcg[1].fcg03,s_fcg[1].fcg031,s_fcg[1].faj43,s_fcg[1].faj432,  #No:FUN-AB0088           
                       s_fcg[1].fcg05,s_fcg[1].fcg06,s_fcg[1].fcg07
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL p910_b_fill(l_wc2)
END FUNCTION
 
FUNCTION p910_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2           LIKE type_file.chr1000#TQC-630166       #No.FUN-680070 VARCHAR(1000)
 DEFINE p_wc2           STRING     #TQC-630166
 
    IF cl_null(p_wc2) THEN LET p_wc2 = '1=1' END IF

    #FUN-BB0113--mark-str--
    #LET g_sql =
    #    "SELECT fcg02,fcg04,fcg041,fcg03,fcg031,faj43,faj432,fcg05,fcg06,fcg07 ",   #No:FUN-AB0088
    #    "  FROM fcg_file, faj_file ",
    #    " WHERE fcg01  ='",g_fcf.fcf01,"'",  #單頭
    #    "   AND fcg03  = faj02",
    #    "   AND fcg031 = faj022",
    #    "   AND ",p_wc2 CLIPPED,                     #單身
    #    " ORDER BY 1"
    #FUN-BB0113--mark-end --

    #FUN-BB0113--add --str
    LET g_sql =
        "SELECT fcg02,fcg04,fcg041,fcg03,fcg031,'','',fcg05,fcg06,fcg07 ",       #TQC-C70190  add  '',''
        "  FROM fcg_file ",
        " WHERE fcg01  ='",g_fcf.fcf01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    #FUN-BB0113--add --end   

    PREPARE p910_pb FROM g_sql
    DECLARE fcg_curs                       #SCROLL CURSOR
        CURSOR FOR p910_pb
 
    CALL g_fcg.clear()
    LET g_cnt = 1
    FOREACH fcg_curs INTO g_fcg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     
        #FUN-BB0113--add --str
        SELECT faj43,faj432 INTO g_fcg[g_cnt].faj43,g_fcg[g_cnt].faj432
          FROM faj_file
         WHERE faj02 = g_fcg[g_cnt].fcg03
           AND faj022 = g_fcg[g_cnt].fcg031
        #FUN-BB0113--add --end
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fcg.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p910_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fcg TO s_fcg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
          CALL p910_fetch('F')  #No.MOD-470570
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL p910_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
          CALL p910_fetch('/')  #No.MOD-470570
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL p910_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
          CALL p910_fetch('L')  #No.MOD-470570
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
{FUNCTION p910_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        fcf00       LIKE fcf_file.fcf00,   #
        fcf01       LIKE fcf_file.fcf01,   #
        fcf02       LIKE fcf_file.fcf02,   #
        fcf03       LIKE fcf_file.fcf03,   #
        fcf14       LIKE fcf_file.fcf14,   #
        fcf15       LIKE fcf_file.fcf15,   #
        fcf52       LIKE fcf_file.fcf52
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #       #No.FUN-680070 VARCHAR(40)
 
    IF g_wc IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('afap910') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afap910'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT fcf00,fcf01,fcf02,fcf03,fcf14,fcf15,fcf52",
              " FROM fcf_file",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY 1"
    PREPARE p910_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p910_co                         # SCROLL CURSOR
        CURSOR FOR p910_p1
 
    START REPORT p910_rep TO l_name
 
    FOREACH p910_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        OUTPUT TO REPORT p910_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p910_rep
 
    CLOSE p910_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p910_rep(sr)
 DEFINE
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        fcf00       LIKE fcf_file.fcf00,   #
        fcf01       LIKE fcf_file.fcf01,   #
        fcf02       LIKE fcf_file.fcf02,   #
        fcf03       LIKE fcf_file.fcf03,   #
        fcf14       LIKE fcf_file.fcf14,   #
        fcf15       LIKE fcf_file.fcf15,   #
        fcf52       LIKE fcf_file.fcf52
                    END RECORD
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
    ORDER BY sr.fcf01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT ' -----   -     ----- --------------------',
                  ' ------------------------------'
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
           PRINT sr.fcf00,' ', sr.fcf01,' ', sr.fcf02,' ', sr.fcf03,' ',
                 sr.fcf14,' ', sr.fcf15,' ', sr.fcf52
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN#IF g_wc[001,080] > ' ' THEN
                   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
                   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
                   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                    PRINT g_dash[1,g_len]
            END IF
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
 
#------ 自動將該單據未解除設定之資料[狀態碼='2'], 自動新增至單身中。 ----
FUNCTION p910_g()
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
         l_fcd11     LIKE    fcd_file.fcd11,
         l_fcd07     LIKE fcd_file.fcd07,         #TQC-C70165  add
         l_fce       RECORD
               fce01     LIKE fce_file.fce01,
               fce02     LIKE fce_file.fce02,
               fce03     LIKE fce_file.fce03,
               fce031    LIKE fce_file.fce031,
               fce04     LIKE fce_file.fce04,
               fce05     LIKE fce_file.fce05
               END RECORD,
         i               LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
      SELECT fcd11,fcd07  INTO l_fcd11,l_fcd07 FROM fcd_file      #TQC-C70165  add  fcd07
       WHERE fcd01 =  g_fcf.fcf03
        AND  fcd01 != 'X'        #增010803
      IF STATUS  OR cl_null(l_fcd11) THEN LET l_fcd11 = '' END IF
      LET l_sql ="SELECT fce01,fce02,fce03,fce031,fce04,fce05 ",
                 "  FROM fce_file",
                 " WHERE fce01 = '",g_fcf.fcf03,"'",
                 "   AND fce07 = '2' ",
                 " ORDER BY 1,2"
     PREPARE p910_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        RETURN
     END IF
     LET l_wc = ' 1=1'
     DECLARE p910_curs2 CURSOR FOR p910_prepare_g
 
     SELECT MAX(fcg02)+1 INTO i FROM fcg_file
      WHERE fcg01 = g_fcf.fcf01
     IF STATUS THEN CALL cl_err(' ',STATUS,0) END IF
     IF cl_null(i) THEN LET i = 1 END IF
     FOREACH p910_curs2 INTO l_fce.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       INSERT INTO fcg_file (fcg01,fcg02,fcg03,fcg031,fcg04,fcg041,
                             fcg05,fcg06,fcg07,fcglegal) #FUN-980003 add
                    VALUES  (g_fcf.fcf01,i,l_fce.fce03,l_fce.fce031,l_fce.fce01,
                            # l_fce.fce02,l_fce.fce05,l_fcd11,'',g_legal) #FUN-980003 add    #TQC-C70165  mark
                            l_fce.fce02,l_fcd07,l_fcd11,'',g_legal)      #TQC-C70165  add
       IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#         CALL cl_err('ins fcg',STATUS,1)   #No.FUN-660136
          CALL cl_err3("ins","fcg_file",g_fcf.fcf01,i,STATUS,"","ins fcg",1)   #No.FUN-660136
          EXIT FOREACH
       END IF
       LET i = i + 1
     END FOREACH
    CALL p910_b_fill(l_wc)
   #LET g_fcg_pageno = 0
END FUNCTION
 
FUNCTION p910_y()                       # when g_fcf.fcfconf='N' (Turn to 'Y')
 DEFINE  l_faj87    LIKE faj_file.faj87,
         s_cnt      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_fcf04    LIKE fcf_file.fcf04,         #TQC-C70177  add
         l_fcd07    LIKE fcd_file.fcd07          #TQC-C70177  add   

   IF g_fcf.fcfconf='Y' THEN RETURN END IF
    IF g_fcf.fcf01 IS NULL THEN RETURN END IF     #No.MOD-4A0020
IF cl_sure(0,0) THEN
   BEGIN WORK
   LET s_cnt = 0
   LET g_success = 'Y'
   UPDATE fcf_file SET fcfconf = 'Y' WHERE fcf01 = g_fcf.fcf01
   CALL s_showmsg_init()               #No.FUN-710028
   FOR s_cnt = 1 TO g_rec_b            #更新資產基本資料檔
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 -end
 
       #TQC-C70177--add--str--
       SELECT sum(fcf04) INTO l_fcf04 FROM fcf_file WHERE fcf03 = g_fcf.fcf03
       SELECT fcd07 INTO l_fcd07 FROM fcd_file WHERE fcd01 = g_fcf.fcf03 
       IF l_fcf04 = l_fcd07 THEN 
          UPDATE faj_file SET faj41 = '1' 
           WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
          IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_showmsg = g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031
             CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             CONTINUE FOR
          END IF 
          #----更新抵押單身檔之狀態碼[fce07]為「3.已解除」---
           UPDATE fce_file SET fce07 = '3'
            WHERE fce01 = g_fcg[s_cnt].fcg04
              AND fce03 = g_fcg[s_cnt].fcg03
              AND fce031= g_fcg[s_cnt].fcg031
           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_showmsg = g_fcg[s_cnt].fcg04,"/",g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031
              CALL s_errmsg('fce01,fce03,fce031',g_showmsg,'upd fce_file:',SQLCA.sqlcode,1)
              LET g_success = 'N'
              CONTINUE FOR
           END IF
       END IF 
       #TQC-C70177--add--end--

       SELECT faj87 INTO l_faj87 FROM faj_file
        WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
        IF SQLCA.sqlcode THEN 
           LET g_showmsg = g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031      #No.FUN-710028
           CALL s_errmsg('faj02,faj022',g_showmsg,'sel:',SQLCA.sqlcode,1) #No.FUN-710028
           LET g_success = 'N'
#          EXIT FOR     #No.FUN-710028
           CONTINUE FOR #No.FUN-710028
        END IF
        #TQC-C70177--add--str--
        IF cl_null(l_faj87) THEN
           LET l_faj87 = 0
        END IF 
        #TQC-C70177--add--end--

        #-----MOD-760105---------
        {
        IF l_faj87 = g_fcg[s_cnt].fcg05 THEN
           UPDATE faj_file SET faj41 = '1', # 未抵押
                               faj91 = g_fcf.fcf02   # Update 解除日期
           WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
        END IF
        UPDATE faj_file SET faj87 = faj87 - g_fcg[s_cnt].fcg05,
                            faj88 = '',
                            faj89 = '',
                            faj90 = '',
                            faj91 = ''
        WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
   #----更新抵押單身檔之狀態碼[fce07]為「3.已解除」---
        UPDATE fce_file SET fce07 = '3'
         WHERE fce01 = g_fcg[s_cnt].fcg04
           AND fce03 = g_fcg[s_cnt].fcg03
           AND fce031= g_fcg[s_cnt].fcg031
        IF SQLCA.sqlcode THEN 
           LET g_showmsg = g_fcg[s_cnt].fcg04,"/",g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031 #No.FUN-710028
           CALL s_errmsg('fce01,fce03,fce031',g_showmsg,'upd fce_file:',SQLCA.sqlcode,1)     #No.FUN-710028
           LET g_success = 'N'
#          EXIT FOR     #No.FUN-710028
           CONTINUE FOR #No.FUN-710028
        END IF
        }
        IF l_faj87 = g_fcg[s_cnt].fcg05 THEN
           UPDATE faj_file SET faj41 = '1', # 未抵押
                               faj88 = '',
                               faj89 = '',
                               faj90 = '',
                               faj91 = g_fcf.fcf02   # Update 解除日期
           WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_showmsg = g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031
              CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file:',SQLCA.sqlcode,1)    
              LET g_success = 'N'
              CONTINUE FOR
           END IF
           #----更新抵押單身檔之狀態碼[fce07]為「3.已解除」---
           UPDATE fce_file SET fce07 = '3'
            WHERE fce01 = g_fcg[s_cnt].fcg04
              AND fce03 = g_fcg[s_cnt].fcg03
              AND fce031= g_fcg[s_cnt].fcg031
           IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_showmsg = g_fcg[s_cnt].fcg04,"/",g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031 
              CALL s_errmsg('fce01,fce03,fce031',g_showmsg,'upd fce_file:',SQLCA.sqlcode,1)     
              LET g_success = 'N'
              CONTINUE FOR
           END IF
        END IF
        UPDATE faj_file SET faj87 = faj87 - g_fcg[s_cnt].fcg05
        WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_showmsg = g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031
           CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file:',SQLCA.sqlcode,1)    
           LET g_success = 'N'
           CONTINUE FOR
        END IF
        #-----END MOD-760105-----
   END FOR
   #-----MOD-760105--------- 
   {
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd fcfconf',STATUS,1)         #No.FUN-710028
      CALL s_errmsg('','','upd fcfconf',STATUS,1) #No.FUN-710028
      LET g_success = 'N'
      RETURN
   END IF
   }
   #-----END MOD-760105-----
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_fcf.fcfconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_fcf.fcfconf
  ELSE
      LET g_fcf.fcfconf='N'
      ROLLBACK WORK
  END IF
 END IF
END FUNCTION
 
FUNCTION p910_z()                       # when g_fcf.fcfconf='Y' (Turn to 'N')
 DEFINE  l_faj87    LIKE faj_file.faj87,
         l_fcd09    LIKE fcd_file.fcd09,
         l_fcd06    LIKE fcd_file.fcd06,
         l_fcd05    LIKE fcd_file.fcd05,
         l_fcd11    LIKE fcd_file.fcd11,
         s_cnt      LIKE type_file.num5         #No.FUN-680070 SMALLINT
   IF g_fcf.fcfconf='N' THEN RETURN END IF
    IF g_fcf.fcf01 IS NULL THEN RETURN END IF     #No.MOD-4A0020
IF cl_sure(0,0) THEN
   BEGIN WORK
   LET g_success = 'Y'
   UPDATE fcf_file SET fcfconf = 'N'
    WHERE fcf01 = g_fcf.fcf01
   CALL s_showmsg_init()    #No.FUN-710028
   FOR s_cnt = 1 TO g_rec_b            #更新資產基本資料檔
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 -end
 
        UPDATE faj_file SET faj41 = '4'    # 全部設定
         WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
        SELECT fcd09,fcd06,fcd05,fcd11
          INTO l_fcd09,l_fcd06,l_fcd05,l_fcd11
          FROM fcd_file
         WHERE fcd01 = g_fcg[s_cnt].fcg04
           AND fcdconf !='X'                #010803 增
        UPDATE faj_file SET faj41 = '4',    # 全部設定
                            faj87 = faj87 + g_fcg[s_cnt].fcg05,
                            faj88 = l_fcd09,
                            faj89 = l_fcd06,
                            faj90 = l_fcd05,
                            faj91 = NULL    # l_fcd11 表未解除
         WHERE faj02 = g_fcg[s_cnt].fcg03 AND faj022= g_fcg[s_cnt].fcg031
   #----更新抵押單身檔之狀態碼[fce07]為「2.已設定」---
        UPDATE fce_file SET fce07 = '2'
         WHERE fce01 = g_fcg[s_cnt].fcg04
           AND fce03 = g_fcg[s_cnt].fcg03
           AND fce031= g_fcg[s_cnt].fcg031
        IF SQLCA.sqlcode THEN 
           LET g_showmsg = g_fcg[s_cnt].fcg04,"/",g_fcg[s_cnt].fcg03,"/",g_fcg[s_cnt].fcg031 #No.FUN-710028
           CALL s_errmsg('fce01,fce03,fce031',g_showmsg,'upd fce_file:',SQLCA.sqlcode,1)     #No.FUN-710028
           LET g_success = 'N'
#          EXIT FOR     #No.FUN-710028
           CONTINUE FOR #No.FUN-710028
         END IF
   END FOR
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
 
   CALL s_showmsg()         #No.FUN-710028 
   IF g_success = 'Y' THEN
      LET g_fcf.fcfconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_fcf.fcfconf
   ELSE
      LET g_fcf.fcfconf='Y'
      ROLLBACK WORK
   END IF
 END IF
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002,003,004,005> #

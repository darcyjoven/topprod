# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: atmt500.4gl
# Descriptions...: 預測模擬作業
# NOTE...........: 本程式提供新增和查詢功能,功能與I類程式類似,所以本程式架構和I類程式一樣
# Date & Author..: 07/04/02 By kim (FUN-730069)
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-780002 07/08/01 By kim 修改數項規格問題
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/21 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.TQC-940094 09/05/08 By mike 無效資料不可刪除    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0162 09/10/28 By lilingyu odgorig,odgoriu兩欄位暫先MARK
# Modify.........: No.TQC-9A0188 09/10/30 By lilingyu "單價 百分比"欄位輸入負數沒有控管
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30074 10/03/15 By lilingyu 查詢時報-284的錯誤 
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.TQC-AC0098 10/12/16 By houlia A30074 調整ogd—odg
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
#FUN-730069
DEFINE g_wc,g_wc2,g_sql STRING
DEFINE g_odg RECORD LIKE odg_file.*
DEFINE g_odg_t RECORD LIKE odg_file.*
DEFINE g_odh DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        odh04         LIKE odh_file.odh04,
        odh05         LIKE odh_file.odh05,
        odh06         LIKE odh_file.odh06,
        odh07         LIKE odh_file.odh07,
        odh08         LIKE odh_file.odh08,
        odh09         LIKE odh_file.odh09
             END RECORD
DEFINE g_odh_t RECORD
        odh04         LIKE odh_file.odh04,
        odh05         LIKE odh_file.odh05,
        odh06         LIKE odh_file.odh06,
        odh07         LIKE odh_file.odh07,
        odh08         LIKE odh_file.odh08,
        odh09         LIKE odh_file.odh09
             END RECORD 
DEFINE   g_before_input_done   LIKE type_file.num5
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_row_count    LIKE type_file.num10    
DEFINE   g_jump         LIKE type_file.num10    
DEFINE   mi_no_ask       LIKE type_file.num5    
DEFINE   g_rec_b         LIKE type_file.num5                 #單身筆數        #No.FUN-680102 SMALLINT
DEFINE   l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE g_draw_day          LIKE type_file.dat              #No.FUN-680130 DATE #畫統計圖用的日期
DEFINE g_i                 LIKE type_file.num5             #No.FUN-680130 SMALLINT #縱刻度數目 =>10
DEFINE g_draw_x,g_draw_y,g_draw_dx,g_draw_dy,
       g_draw_width,g_draw_multiple LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_draw_base,g_draw_maxy      LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_draw_start_y               LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE g_argv1        LIKE odg_file.odg01
DEFINE g_argv2        LIKE odg_file.odg02
DEFINE g_str          STRING
 
MAIN
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
 
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
      RETURNING g_time    #No.FUN-6A0081
 
    LET g_argv1 =ARG_VAL(1)
    LET g_argv2 =ARG_VAL(2)
 
    LET p_row = 3 LET p_col = 4
    OPEN WINDOW t500_w AT p_row,p_col              #顯示畫面
        WITH FORM "atm/42f/atmt500.42f"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
       CALL t500_q()
    END IF   
        
    CALL cl_set_comp_visible("odh09",FALSE)
 
    LET g_forupd_sql = "SELECT * FROM odg_file WHERE odg01 = ? AND odg02 = ? AND odg03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_cl CURSOR FROM g_forupd_sql
 
    CALL t500_menu()
 
    CLOSE WINDOW t500_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
       RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION t500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) THEN
      LET g_wc = " odg01 = '",g_argv1,"'",
                 " AND odg02 = '",g_argv2,"'"
      LET g_wc2=" 1=1 "
   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_odh.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_odg.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
                odg01   ,odg02   ,odg03   ,odg04   ,odg05   ,
                odg06   ,odg061  ,odg062  ,odg063  ,
                odg0631 ,odg0632 ,odg0633 ,odg0634 ,odg0635 ,
                odg0636 ,odg0637 ,odg0638 ,odg0639 ,odg06310,
                odg06311,odg06312,odg064  ,
                odg10   ,odg11   ,odg12   ,odg07   ,odg08   ,odg09,
               #FUN-840068   ---start---
                odgud01,odgud02,odgud03,odgud04,odgud05,
                odgud06,odgud07,odgud08,odgud09,odgud10,
                odgud11,odgud12,odgud13,odgud14,odgud15
               #FUN-840068    ----end----
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION controlp
            CASE
                WHEN INFIELD(odg01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  ="q_odb"
                   LET g_qryparam.state    = "c"   #多選
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odg01
                   NEXT FIELD odg01
                WHEN INFIELD(odg02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  ="q_tqb"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO odg02
                   NEXT FIELD odg02
                WHEN INFIELD(odg03)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form  ="q_ima"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                        RETURNING  g_qryparam.multiret 
#FUN-AA0059---------mod------------end-----------------
                   DISPLAY g_qryparam.multiret TO odg03
                   NEXT FIELD odg03
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
      
      
         ON ACTION qbe_select
		      CALL cl_qbe_list() RETURNING lc_qbe_sn
		      CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      
      IF INT_FLAG THEN RETURN END IF
      
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #          LET g_wc = g_wc clipped," AND odguser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #          LET g_wc = g_wc clipped," AND odgegrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #          LET g_wc = g_wc clipped," AND odgegrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('odguser', 'odggrup')
      #End:FUN-980030
      
      CONSTRUCT g_wc2 ON odh04,odh05,odh06,odh07,odh08,odh09           # 螢幕上取單身條件
           FROM s_odh[1].odh04,s_odh[1].odh05,s_odh[1].odh06,
                s_odh[1].odh07,s_odh[1].odh08,s_odh[1].odh09
      
		   BEFORE CONSTRUCT
		      CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
         ON ACTION qbe_save
		        CALL cl_qbe_save()
      END CONSTRUCT
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT odg01,odg02,odg03 FROM odg_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY odg01,odg02,odg03"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE odg_file.odg01,odg02,odg03 ",
                  "  FROM odg_file, odh_file ",
                  " WHERE odg01 = odh01 AND odg02 = odh02 AND odg03 = odh03 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY odg01,odg02,odg03"
   END IF
 
   PREPARE t500_prepare FROM g_sql
   DECLARE t500_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t500_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM odg_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(*) FROM odg_file WHERE ",
                 "odg01||odg02||odg03 IN (SELECT DISTINCT odg01||odg02||odg03 ",
                 "FROM odg_file,odh_file WHERE ",
                 "odh01=odg01 AND odg02 = odh02 AND odg03 = odh03",
                 " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,")"
   END IF
   PREPARE t500_precount FROM g_sql
   DECLARE t500_count CURSOR FOR t500_precount
   # 2004/02/06 by Hiko : 為了上下筆資料所做的設定.
   OPEN t500_count
   FETCH t500_count INTO g_row_count
   CLOSE t500_count
 
END FUNCTION
 
FUNCTION t500_menu()
 
    WHILE TRUE
       CALL t500_bp("G")
       CASE g_action_choice
          WHEN "insert" 
             IF cl_chk_act_auth() THEN 
                CALL t500_a()
             END IF
          WHEN "query" 
             IF cl_chk_act_auth() THEN
                CALL t500_q()
             END IF
          WHEN "delete" 
             IF cl_chk_act_auth() THEN
                CALL t500_r()
             END IF
          WHEN "modify" 
             IF cl_chk_act_auth() THEN
                CALL t500_u()
             END IF
          WHEN "invalid" 
             IF cl_chk_act_auth() THEN
                CALL t500_x()
             END IF
         #WHEN "reproduce" 
         #   IF cl_chk_act_auth() THEN
         #      CALL t500_copy()
         #   END IF
          WHEN "detail" #CHI-780002
             LET g_action_choice = "" #CHI-780002 
         #   IF cl_chk_act_auth() THEN
         #      CALL t500_b()
         #   ELSE
         #      LET g_action_choice = NULL
         #   END IF
 #       #   LET g_action_choice = ""
         #WHEN "output" 
         #   IF cl_chk_act_auth()
         #      THEN CALL t500_out()
         #   END IF
          WHEN "help" 
             CALL cl_show_help()
          WHEN "exit"
             EXIT WHILE
          WHEN "controlg"
             CALL cl_cmdask()
             
          #CHI-780002...............begin
          #WHEN "page04"
          #   CALL t500_draw("page04")
          #
          #WHEN "page05"
          #   CALL t500_draw("page05")
          #CHI-780002...............end
             
          WHEN "turnforcaste"  #轉預測資料
             IF cl_chk_act_auth() THEN
                CALL t500_turn()
             END IF
             
          WHEN "maintainfactor"  #預測影響因素維護
             IF cl_chk_act_auth() THEN
                CALL t500_factor()
             END IF
 
          WHEN "maintainforcaste"  #集團銷售預測維護
             IF cl_chk_act_auth() THEN
                CALL t500_forcaste()
             END IF
          WHEN "gendetail"
             IF cl_chk_act_auth() THEN
                CALL t500_g_b()
                CALL t500_b_fill('1=1')
             END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_odg.odg01 IS NOT NULL THEN
                  LET g_doc.column1 = "odg01"
                  LET g_doc.column2 = "odg02"
                  LET g_doc.column3 = "odg03"
                  LET g_doc.value1 = g_odg.odg01
                  LET g_doc.value2 = g_odg.odg02
                  LET g_doc.value3 = g_odg.odg03
                  CALL cl_doc()
               END IF
            END IF
 
         #WHEN "exporttoexcel"   #No.FUN-4B0020
         #   IF cl_chk_act_auth() THEN
         #     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_odh),'','')
         #   END IF
 
       END CASE
    END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t500_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_odh.clear()
    INITIALIZE g_odg.* LIKE odg_file.*             #DEFAULT 設定
    LET g_odg_t.* = g_odg.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_odg.odguser=g_user
        LET g_odg.odgoriu = g_user #FUN-980030
        LET g_odg.odgorig = g_grup #FUN-980030
        LET g_odg.odgegrup=g_grup
        LET g_odg.odgdate=g_today
        LET g_odg.odgacti='Y'              #資料有效
        LET g_odg.odg12='N'
        LET g_odg.odg07='N'
        LET g_odg.odg08='N'
        LET g_odg.odg09='N'
        CALL t500_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_odg.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_odg.odg01 IS NULL OR
           g_odg.odg02 IS NULL OR
           g_odg.odg03 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO odg_file VALUES (g_odg.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_odg.odg01,SQLCA.sqlcode,1)   #No.FUN-660131
            CALL cl_err3("ins","odg_file",g_odg.odg01,g_odg.odg02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT odg01,odg02,odg03 INTO g_odg.odg01,g_odg.odg02,g_odg.odg03 FROM odg_file
            WHERE odg01 = g_odg.odg01
              AND odg02 = g_odg.odg02
              AND odg03 = g_odg.odg03
        LET g_odg_t.* = g_odg.*
 
        CALL g_odh.clear()
        LET g_rec_b = 0 
       #CALL t500_b()                   #輸入單身
        CALL t500_g_b()
        EXIT WHILE
    END WHILE
    CALL t500_b_fill("1=1")
    LET g_wc=' '
END FUNCTION
 
FUNCTION t500_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_odg.odg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF    
    SELECT * INTO g_odg.* FROM odg_file WHERE odg01=g_odg.odg01
                                          AND odg02=g_odg.odg02
                                          AND odg03=g_odg.odg03
    IF g_odg.odgacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_odg.odg01,9027,0)
       RETURN
    END IF
    IF g_odg.odg12 ='Y' THEN
       CALL cl_err("","axm-225",1)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_odg_t.* = g_odg.*
    BEGIN WORK
 
    OPEN t500_cl USING g_odg.odg01,g_odg.odg02,g_odg.odg03
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_odg.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_odg.odg01,SQLCA.sqlcode,1)      # 資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
    CALL t500_show()
    WHILE TRUE
        LET g_odg.odgmodu=g_user
        LET g_odg.odgdate=g_today
        CALL t500_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_odg.*=g_odg_t.*
            CALL t500_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
       #IF g_odg.odg01 != g_odg01_t THEN            # 更改單號
       #    UPDATE odh_file SET odh01 = g_odg.odg01
       #        WHERE odh01 = g_odg01_t
       #    IF SQLCA.sqlcode THEN
#      #        CALL cl_err('odh',SQLCA.sqlcode,0)    #No.FUN-660131
       #        CALL cl_err3("upd","odh_file",g_odg01_t,"",SQLCA.sqlcode,"","odh",1)  #No.FUN-660131
       #        CONTINUE WHILE
       #    END IF
       #END IF
          UPDATE odg_file SET odg_file.* = g_odg.*
           WHERE odg01 = g_odg_t.odg01
             AND odg02 = g_odg_t.odg02
             AND odg03 = g_odg_t.odg03
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_odg.odg01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","odg_file",g_odg.odg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t500_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t500_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
            l_cnt    LIKE type_file.num5,                        #No.FUN-680102 SMALLINT
            l_odbacti LIKE odb_file.odbacti,
            l_tqbacti LIKE tqb_file.tqbacti
            
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
      #DISPLAY BY NAME g_odg.odguser,g_odg.odgegrup,g_odg.odgdate,g_odg.odgacti
                      
      DISPLAY BY NAME g_odg.odg12,g_odg.odg07,g_odg.odg08,g_odg.odg09
 
      INPUT BY NAME g_odg.odg01   ,g_odg.odg02   ,g_odg.odg03   ,g_odg.odg04   ,g_odg.odg05   ,# g_odg.odgoriu,g_odg.odgorig,  #TQC-9A0162
                    g_odg.odg06   ,g_odg.odg061  ,g_odg.odg062  ,g_odg.odg063  ,
                    g_odg.odg0631 ,g_odg.odg0632 ,g_odg.odg0633 ,g_odg.odg0634 ,g_odg.odg0635 ,
                    g_odg.odg0636 ,g_odg.odg0637 ,g_odg.odg0638 ,g_odg.odg0639 ,g_odg.odg06310,
                    g_odg.odg06311,g_odg.odg06312,g_odg.odg064  ,
                    g_odg.odg07   ,g_odg.odg08   ,g_odg.odg09,
                   #FUN-840068     ---start---
                    g_odg.odgud01,g_odg.odgud02,g_odg.odgud03,g_odg.odgud04,
                    g_odg.odgud05,g_odg.odgud06,g_odg.odgud07,g_odg.odgud08,
                    g_odg.odgud09,g_odg.odgud10,g_odg.odgud11,g_odg.odgud12,
                    g_odg.odgud13,g_odg.odgud14,g_odg.odgud15
                   #FUN-840068     ----end----
 
                    WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t500_set_entry(p_cmd)
         CALL t500_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE         
         IF p_cmd='u' THEN
            CALL t500_control_odg06()
         END IF
 
       AFTER FIELD odg01
          IF NOT cl_null(g_odg.odg01) THEN
             SELECT odbacti INTO l_odbacti FROM odb_file
                           WHERE odb01=g_odg.odg01
             CASE
                WHEN SQLCA.sqlcode
                   CALL cl_err3("sel","odb_file",g_odg.odg01,"",100,"","",1)
                   NEXT FIELD odg01
                WHEN l_odbacti<>'Y'
                   CALL cl_err3("sel","odb_file",g_odg.odg01,"","9028","","",1)
                   NEXT FIELD odg01
             END CASE
             CALL t500_set_odb02()             
          ELSE
             DISPLAY NULL TO FROMONLY.odb02
          END IF
 
       AFTER FIELD odg02
          IF NOT cl_null(g_odg.odg02) THEN
             SELECT tqbacti INTO l_tqbacti FROM tqb_file
                           WHERE tqb01=g_odg.odg02
             CASE
                WHEN SQLCA.sqlcode
                   CALL cl_err3("sel","tqb_file",g_odg.odg02,"",100,"","",1)
                   NEXT FIELD odg02
                WHEN l_tqbacti<>'Y'
                   CALL cl_err3("sel","tqb_file",g_odg.odg02,"","9028","","",1)
                   NEXT FIELD odg02
             END CASE
             CALL t500_set_tqb02()
          ELSE
             DISPLAY NULL TO FROMONLY.tqb02
          END IF
       
       AFTER FIELD odg03
          IF NOT cl_null(g_odg.odg03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_odg.odg03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_odg.odg03= g_odg_t.odg03
               NEXT FIELD odg03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM ima_file
                            WHERE ima01=g_odg.odg03
             IF l_cnt=0 THEN
                CALL cl_err3("sel","ima_file",g_odg.odg03,"",100,"","",1)
                NEXT FIELD odg03
             END IF
             CALL t500_set_ima02()
             IF p_cmd='a' AND (NOT cl_null(g_odg.odg01)) AND 
                              (NOT cl_null(g_odg.odg02)) AND 
                              (NOT cl_null(g_odg.odg03)) THEN
                LET l_cnt=0
                SELECT COUNT(*) INTO l_cnt FROM odg_file
                               WHERE odg01=g_odg.odg01
                                 AND odg02=g_odg.odg02
                                 AND odg03=g_odg.odg03
                IF l_cnt>0 THEN
                   CALL cl_err('','-239',1)
                   NEXT FIELD odg01
                END IF
             END IF
          ELSE
             DISPLAY NULL TO FROMONLY.ima02
          END IF
 
#TQC-9A0188 --begin--
      AFTER FIELD odg04
         IF NOT cl_null(g_odg.odg04) THEN
             IF g_odg.odg04 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD odg04
             END IF 
         END IF 

      AFTER FIELD odg061
         IF NOT cl_null(g_odg.odg061) THEN
             IF g_odg.odg061 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD odg061
             END IF 
         END IF 
#TQC-9A0188 --end--

      ON CHANGE odg06
          CALL t500_control_odg06()
          LET g_odg.odg063=NULL
          DISPLAY BY NAME g_odg.odg063
          
      AFTER FIELD odg063
          IF g_odg.odg063<=0 OR g_odg.odg063>12 THEN
             CALL cl_err('','atm-503',1)
             NEXT FIELD odg063
          END IF
 
      ON CHANGE odg063
          CALL t500_control_odg06()
 
      #CHI-780002....................begin          
      AFTER FIELD odg064
          IF g_odg.odg064<=0 OR g_odg.odg064>=1 THEN
             CALL cl_err('','atm-510',1)
             NEXT FIELD odg064
          END IF
      #CHI-780002....................end
 
     #FUN-840068     ---start---
      AFTER FIELD odgud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
      AFTER FIELD odgud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
      AFTER FIELD odgud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER FIELD odgud04 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud05 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud06 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud07  
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud08 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud09 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud10 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud11 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud12 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud13 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud14 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
      AFTER FIELD odgud15 
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
     #FUN-840068     ----end----
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_odg.odguser = s_get_data_owner("odg_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
#         CALL cl_show_req_fields()
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(odg01)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_odb"
                CALL cl_create_qry() RETURNING g_odg.odg01
                DISPLAY BY NAME g_odg.odg01
                NEXT FIELD odg01
             WHEN INFIELD(odg02)
                CALL cl_init_qry_var()
                LET g_qryparam.form  ="q_tqb"
                CALL cl_create_qry() RETURNING g_odg.odg02
                DISPLAY BY NAME g_odg.odg02
                NEXT FIELD odg02
             WHEN INFIELD(odg03)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_ima"
#               CALL cl_create_qry() RETURNING g_odg.odg03
                CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                  RETURNING  g_odg.odg03  
#FUN-AA0059---------mod------------end-----------------
                DISPLAY BY NAME g_odg.odg03
                NEXT FIELD odg03
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(odg01) THEN
      #      LET g_odg.* = g_odg_t.*
      #      DISPLAY BY NAME g_odg.* 
      #      NEXT FIELD odg01
      #   END IF
        #MOD-650015 --end
 
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
 
FUNCTION t500_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("odg01,odg02,odg03",TRUE)
      END IF      
END FUNCTION
 
FUNCTION t500_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("odg01,odg02,odg03",FALSE)
   END IF
   CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",
                             FALSE)
   CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",
                             FALSE)
END FUNCTION
 
#Query 查詢     
FUNCTION t500_q()
    # 2004/02/06 by Hiko : 初始化單頭資料筆數.
--mi
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
--#    
    INITIALIZE g_odg.* TO NULL                #FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_odh.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t500_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
--mi
    OPEN t500_count
    FETCH t500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
--#
    OPEN t500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_odg.* TO NULL
    ELSE
        CALL t500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    ls_jump         LIKE ze_file.ze03
 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t500_cs INTO g_odg.odg01,g_odg.odg02,g_odg.odg03
        WHEN 'P' FETCH PREVIOUS t500_cs INTO g_odg.odg01,g_odg.odg02,g_odg.odg03
        WHEN 'F' FETCH FIRST    t500_cs INTO g_odg.odg01,g_odg.odg02,g_odg.odg03
        WHEN 'L' FETCH LAST     t500_cs INTO g_odg.odg01,g_odg.odg02,g_odg.odg03
        WHEN '/'
--mi      
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
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
            FETCH ABSOLUTE g_jump t500_cs INTO g_odg.odg01,g_odg.odg02,g_odg.odg03 --改g_jump
            LET mi_no_ask = FALSE
--#
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_odg.odg01,SQLCA.sqlcode,0)
        INITIALIZE g_odg.* TO NULL  #TQC-6B0105
        RETURN
--mi
    ELSE
         CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
--#
   #SELECT * INTO g_odg.* FROM odg_file                        #TQC-A30074
#   SELECT DISTINCT ogd_file.* INTO g_odg.* FROM odg_file      #TQC-A30074   #TQC-AC0098
    SELECT DISTINCT odg_file.* INTO g_odg.* FROM odg_file      #TQC-A30074   #TQC-AC0098
     WHERE odg01 = g_odg.odg01 AND odg02 = g_odg.odg02 AND odg03 = g_odg.odg03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_odg.odg01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("sel","odg_file",g_odg.odg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        INITIALIZE g_odg.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0044權限控管
       LET g_data_owner=g_odg.odguser       
       LET g_data_group=g_odg.odgegrup
    END IF
 
    CALL t500_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t500_show()
    DEFINE l_cnt      LIKE type_file.num5           #No.FUN-680102 SMALLINT
    LET g_odg_t.* = g_odg.*                      #保存單頭舊值
    DISPLAY BY NAME g_odg.odg01   ,g_odg.odg02   ,g_odg.odg03   ,g_odg.odg04   ,g_odg.odg05   , #g_odg.odgoriu,g_odg.odgorig, #TQC-9A0162
                    g_odg.odg06   ,g_odg.odg10   ,g_odg.odg11   ,g_odg.odg12   ,g_odg.odg07   ,
                    g_odg.odg08   ,g_odg.odg09   ,
                    g_odg.odg061  ,g_odg.odg062  ,g_odg.odg064  ,g_odg.odg063  ,g_odg.odg0631 ,
                    g_odg.odg0632 ,g_odg.odg0633 ,g_odg.odg0634 ,g_odg.odg0635 ,g_odg.odg0636 ,
                    g_odg.odg0637 ,g_odg.odg0638 ,g_odg.odg0639 ,g_odg.odg06310,g_odg.odg06311,
                    g_odg.odg06312,
                   #FUN-840068     ---start---
                    g_odg.odgud01,g_odg.odgud02,g_odg.odgud03,g_odg.odgud04,
                    g_odg.odgud05,g_odg.odgud06,g_odg.odgud07,g_odg.odgud08,
                    g_odg.odgud09,g_odg.odgud10,g_odg.odgud11,g_odg.odgud12,
                    g_odg.odgud13,g_odg.odgud14,g_odg.odgud15
                   #FUN-840068     ----end----
 
    CALL t500_b_fill(g_wc2)                 #單身
    CALL t500_set_odb02()
    CALL t500_set_tqb02()
    CALL t500_set_ima02()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    CALL t500_draw("page04")
    CALL t500_draw("page05")
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t500_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_odg.odg01 IS NULL OR
       g_odg.odg02 IS NULL OR
       g_odg.odg03 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_odg.odg12 ='Y' THEN
       CALL cl_err("","axm-225",1)
       RETURN
    END IF
#TQC-940094  --START                                                                                                                
    IF g_odg.odgacti='N' THEN                                                                                                       
       CALL cl_err("",'abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
#TQC-940094   --END   
    BEGIN WORK
 
    OPEN t500_cl USING g_odg.odg01,g_odg.odg02,g_odg.odg03
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_odg.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_odg.odg01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
    CALL t500_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "odg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "odg02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "odg03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_odg.odg01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_odg.odg02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_odg.odg03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM odh_file WHERE odh01 = g_odg.odg01
                                AND odh02 = g_odg.odg02
                                AND odh03 = g_odg.odg03
                                
         DELETE FROM odg_file WHERE odg01 = g_odg.odg01
                                AND odg02 = g_odg.odg02
                                AND odg03 = g_odg.odg03
         INITIALIZE g_odg.* TO NULL
         CLEAR FORM
         CALL g_odh.clear()
--mi
         OPEN t500_count
         FETCH t500_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t500_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t500_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t500_fetch('/')
         END IF
--#
    END IF
    CLOSE t500_cl
    COMMIT WORK
END FUNCTION
#   Change to nonactivity     
FUNCTION t500_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_odg.odg01 IS NULL OR
       g_odg.odg02 IS NULL OR
       g_odg.odg03 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_odg.odg12 ='Y' THEN
       CALL cl_err("","axm-225",1)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t500_cl USING g_odg.odg01,g_odg.odg02,g_odg.odg03
    IF STATUS THEN
       CALL cl_err("OPEN t500_cl:", STATUS, 1)
       CLOSE t500_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t500_cl INTO g_odg.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_odg.odg01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t500_cl ROLLBACK WORK RETURN
    END IF
    CALL t500_show()
    IF cl_exp(0,0,g_odg.odgacti) THEN                   #確認一下
        IF g_odg.odgacti='Y' THEN
            LET g_odg.odgacti='N'
        ELSE
            LET g_odg.odgacti='Y'
        END IF
        UPDATE odg_file                    #更改有效碼
            SET odgacti=g_odg.odgacti
            WHERE odg01=g_odg.odg01
              AND odg02=g_odg.odg02
              AND odg03=g_odg.odg03
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_odg.odg01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","odg_file",g_odg.odg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        END IF
        DISPLAY BY NAME g_odg.odgacti
    END IF
    CLOSE t500_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t500_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          LIKE type_file.chr1000       #No.FUN-680102CHAR(200)
 
    LET g_sql =
        "SELECT odh04,odh05,odh06,odh07,odh08,odh09 ",
        " FROM odh_file",
        " WHERE odh01 ='",g_odg.odg01,"' AND ",
        "       odh02 ='",g_odg.odg02,"' AND ",
        "       odh03 ='",g_odg.odg03,"' AND ",
        p_wc2 CLIPPED,                     #單身
        " ORDER BY odh04"
    PREPARE t500_pb FROM g_sql
    DECLARE odh_curs                       #SCROLL CURSOR
        CURSOR FOR t500_pb
 
#    FOR g_cnt = 1 TO g_odh.getLength()           #單身 ARRAY 乾洗
#       INITIALIZE g_odh[g_cnt].* TO NULL
#    END FOR
     CALL g_odh.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH odh_curs INTO g_odh[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
--CKP, 填充單身最後一筆為 NULL array, 故要刪掉
    CALL g_odh.deleteElement(g_cnt)
--##
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odh TO s_odh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
--mi
      BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)
--#
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
--mi
      ON ACTION first 
         CALL t500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL t500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL t500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL t500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL t500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
--#                              
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
     #ON ACTION reproduce
     #   LET g_action_choice="reproduce"
     #   EXIT DISPLAY
 
     #ON ACTION detail
     #   LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY
 
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#     ON ACTION error_test
#        CALL cl_err_msg("My Error message Test",-2014,g_user,3)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
  
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
       ON ACTION gendetail
         LET g_action_choice="gendetail"
         EXIT DISPLAY
 
#     ON ACTION exporttoexcel   #No.FUN-4B0020
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
 
      ON ACTION page04
        #LET g_action_choice="page04" #CHI-780002
        #EXIT DISPLAY #CHI-780002
        CALL t500_draw("page04")
 
      ON ACTION page05
        #LET g_action_choice="page05" #CHI-780002
        #EXIT DISPLAY #CHI-780002
        CALL t500_draw("page05")
        
#@    ON ACTION 轉預測資料
      ON ACTION turnforcaste
         LET g_action_choice="turnforcaste"
         EXIT DISPLAY
         
#@    ON ACTION 預測影響因素維護
      ON ACTION maintainfactor
         LET g_action_choice="maintainfactor"
         EXIT DISPLAY
         
#@    ON ACTION 集團銷售預測維護
      ON ACTION maintainforcaste
         LET g_action_choice="maintainforcaste"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t500_set_odb02()
  DEFINE l_odb02 LIKE odb_file.odb02
  DEFINE l_odb09 LIKE odb_file.odb09
  
  IF g_odg.odg01 IS NULL THEN
     DISPLAY NULL TO FORMONLY.odb02
     DISPLAY NULL TO FORMONLY.odb09
     RETURN
  END IF
  SELECT odb02,odb09 INTO l_odb02,l_odb09 FROM odb_file
              WHERE odb01=g_odg.odg01
  DISPLAY l_odb02 TO FORMONLY.odb02
  DISPLAY l_odb09 TO FORMONLY.odb09
END FUNCTION
 
FUNCTION t500_set_tqb02()
  DEFINE l_tqb02 LIKE tqb_file.tqb02
  IF g_odg.odg02 IS NULL THEN
     DISPLAY NULL TO FORMONLY.tqb02
     RETURN
  END IF
  SELECT tqb02 INTO l_tqb02 FROM tqb_file
              WHERE tqb01=g_odg.odg02
  DISPLAY l_tqb02 TO FORMONLY.tqb02
END FUNCTION
 
FUNCTION t500_set_ima02()
  DEFINE l_ima02 LIKE ima_file.ima02
  IF g_odg.odg03 IS NULL THEN
     DISPLAY NULL TO FORMONLY.oba02
     RETURN
  END IF
  SELECT ima02 INTO l_ima02 FROM ima_file
              WHERE ima01=g_odg.odg03
  DISPLAY l_ima02 TO FORMONLY.ima02
END FUNCTION
 
#自動產生單身
FUNCTION t500_g_b()
DEFINE
   l_mm        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #月
   l_dd        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #日
   l_yy        LIKE type_file.num5,             #No.FUN-680120 SMALLINT                  #年
   l_day1       LIKE type_file.dat,              #No.FUN-680120 DATE
   l_day2       LIKE type_file.dat,              #No.FUN-680120 DATE
   l_odb       RECORD LIKE odb_file.*,
   l_qty       LIKE ogb_file.ogb12,
   l_mny       LIKE ogb_file.ogb14,
   l_odh       RECORD LIKE odh_file.*,
   i        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   j        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   k        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
  #n        LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   l_odf    RECORD LIKE odf_file.*,
   l_odg10  LIKE odg_file.odg10,
   l_odg11  LIKE odg_file.odg11,
   l_wdg    LIKE odg_file.odg0631,
   l_sumwdg LIKE odg_file.odg0631,
   l_wdgqty LIKE ogb_file.ogb12,
   l_wdgmny LIKE ogb_file.ogb14,
   l_sumqty LIKE ogb_file.ogb12,
   l_summny LIKE ogb_file.ogb14,
   l_alpha  LIKE odg_file.odg064,  #CHI-780002
   l_l      LIKE type_file.num5,   #CHI-780002
   l_m      LIKE type_file.num5,   #CHI-780002
   l_forecast LIKE ogb_file.ogb12, #CHI-780002
   l_ima31  LIKE ima_file.ima31, #銷售單位 #CHI-780002
   l_ima31_fac  LIKE ima_file.ima31_fac, #銷售單位/庫存單位換算率 #CHI-780002
   l_gfe03  LIKE gfe_file.gfe03, #小數位數 #CHI-780002
   l_ima131 LIKE ima_file.ima131, #產品分類編號 #CHI-780002
   l_odg01  LIKE odg_file.odg01, #模擬版本,指數平滑法專用變數,決定前期的模擬版本  #CHI-780002
   l_sql    STRING               #CHI-780002
   
   IF cl_null(g_odg.odg01) OR
      cl_null(g_odg.odg02) OR
      cl_null(g_odg.odg03) THEN
      CALL cl_err("","-400",1)
      RETURN
   END IF
   IF g_odg.odg12 ='Y' THEN
      CALL cl_err("","axm-225",1)
      RETURN
   END IF
   DELETE FROM odh_file WHERE odh01=g_odg.odg01
                          AND odh02=g_odg.odg02
                          AND odh03=g_odg.odg03
   SELECT * INTO l_odb.* FROM odb_file 
                        WHERE odb01=g_odg.odg01
   #CHI-780002...............begin
   SELECT ima31,ima131,ima31_fac 
     INTO l_ima31,l_ima131,l_ima31_fac
                       FROM ima_file
                      WHERE ima01=g_odg.odg03
   IF cl_null(l_ima31_fac) OR l_ima31_fac=0 THEN
      LET l_ima31_fac=1
   END IF
   SELECT gfe03 INTO l_gfe03 FROM gfe_file
                            WHERE gfe01=l_ima31
   #決定前期的模擬版本,指數平滑法專用
   IF g_odg.odg06='4' THEN
      LET l_odg01=NULL
      LET l_sql="SELECT odb01 FROM odb_file ",
                "            WHERE odb04='",l_odb.odb04,"' ",
                "              AND odb05<'",l_odb.odb05,"' ",
                "              AND odb07='",l_odb.odb07,"' ",
                "            ORDER BY odb05 DESC"
      DECLARE t500_smooth_c CURSOR FROM l_sql
      FOREACH t500_smooth_c INTO l_odg01
         EXIT FOREACH #取得最近一筆的模擬版本
      END FOREACH
   END IF
   #CHI-780002...............end
   #金額取位
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
    WHERE azi01=l_odb.odb09
 
   IF cl_null(l_odb.odb04) THEN RETURN END IF
   CASE l_odb.odb04   #計算期數
      WHEN '1' #季
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*12+MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)/3
      WHEN '2' #月
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*12+MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)
      WHEN '3' #旬
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*365+(MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)*30)/10
      WHEN '4' #週
         LET j=((YEAR(l_odb.odb06)-YEAR(l_odb.odb05))*365+(MONTH(l_odb.odb06)-MONTH(l_odb.odb05)+1)*30)/7
      WHEN '5' #天
         LET j=l_odb.odb06-l_odb.odb05+1
   END CASE
   #CHI-780002.....................begin
   CASE g_odg.odg06  #決定基準起始日的期數
      WHEN "1" #1. 依歷史資料乘上百分比
         LET l_m=j
      WHEN "2" #2. 移動平均數
         LET l_m=g_odg.odg062
      WHEN "3" #3. 加權移動平均數
         LET l_m=g_odg.odg063
      WHEN "4" #4. 指數平滑法
         LET l_m=j
   END CASE
   #CHI-780002.....................end
   FOR i = 1 TO j
      LET l_mm = MONTH(l_odb.odb05)
      LET l_dd = DAY(l_odb.odb05)
      LET l_yy = YEAR(l_odb.odb05)
      CASE l_odb.odb04
        WHEN '1' #季
          IF i = 1 THEN
            #LET g_odh[i].odh04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odh[i].odh04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odh[i].odh04 = g_odh[i-1].odh04 + 3 UNITS MONTH
          END IF
          CASE g_odg.odg05
             WHEN "1"
                LET g_odh[i].odh09 = g_odh[i].odh04 - 1 UNITS YEAR
             WHEN "2"
                LET g_odh[i].odh09 = g_odh[i].odh04 - l_m*3 UNITS MONTH
          END CASE
        WHEN '2' #月
          IF i = 1 THEN
            #LET g_odh[i].odh04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odh[i].odh04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odh[i].odh04 = g_odh[i-1].odh04 + 1 UNITS MONTH
          END IF                  
          CASE g_odg.odg05
             WHEN "1"
                LET g_odh[i].odh09 = g_odh[i].odh04 - 1 UNITS YEAR
             WHEN "2"
                LET g_odh[i].odh09 = g_odh[i].odh04 - l_m*1 UNITS MONTH
          END CASE
        WHEN '3' #旬
          IF i = 1 THEN
            #LET g_odh[i].odh04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odh[i].odh04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odh[i].odh04 = g_odh[i-1].odh04 + 10 UNITS DAY
          END IF                  
          CASE g_odg.odg05
             WHEN "1"
                LET g_odh[i].odh09 = g_odh[i].odh04 - 1 UNITS YEAR
             WHEN "2"
                LET g_odh[i].odh09 = g_odh[i].odh04 - l_m*10 UNITS DAY
          END CASE
        WHEN '4' #週
          IF i = 1 THEN
            #LET g_odh[i].odh04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odh[i].odh04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odh[i].odh04 = g_odh[i-1].odh04 + (i-1)*7 UNITS DAY
          END IF                  
          CASE g_odg.odg05
             WHEN "1"
                LET g_odh[i].odh09 = g_odh[i].odh04 - 1 UNITS YEAR
             WHEN "2"
                LET g_odh[i].odh09 = g_odh[i].odh04 - l_m*7 UNITS DAY
          END CASE
        WHEN '5' #天
          IF i = 1 THEN
            #LET g_odh[i].odh04 = MDY(l_mm,1,l_yy) #CHI-780002
             LET g_odh[i].odh04 = MDY(l_mm,l_dd,l_yy) #CHI-780002
          ELSE
             LET g_odh[i].odh04 = g_odh[i-1].odh04 + 1 UNITS DAY
          END IF                  
          CASE g_odg.odg05
             WHEN "1"
                LET g_odh[i].odh09 = g_odh[i].odh04 - 1 UNITS YEAR
             WHEN "2"
                LET g_odh[i].odh09 = g_odh[i].odh04 - l_m UNITS DAY
          END CASE
      END CASE
   END FOR
   FOR i = 1 TO j
      #基準數量
      IF j>i THEN
         LET l_day1= g_odh[i].odh09
         LET l_day2= g_odh[i+1].odh09
      ELSE #最後一個時距
         LET l_day1= g_odh[i].odh09
         CASE l_odb.odb04
            WHEN '1' #季
               LET l_day2 = l_day1 + 3 UNITS MONTH
            WHEN '2' #月
               LET l_day2 = l_day1 + 1 UNITS MONTH
            WHEN '3' #旬
               LET l_day2 = l_day1 + 10 UNITS DAY
            WHEN '4' #週
               LET l_day2 = l_day1 + 7 UNITS DAY
            WHEN '5' #天
               LET l_day2 = l_day1 + 1 UNITS DAY
         END CASE
      END IF
      LET l_qty=0
      SELECT SUM(ogb12*ogb05_fac)/l_ima31_fac INTO l_qty
        FROM oga_file,ogb_file,occ_file
       WHERE oga01=ogb01
         AND ogb04 NOT LIKE 'MISC%'
         AND occ01=oga03 
         AND occ1005=g_odg.odg02
         AND ogb04=g_odg.odg03
         AND oga02 >=l_day1
         AND oga02 <l_day2
         AND ogaconf='Y' 
         AND ogapost='Y'
         AND oga09 IN ('2','3','4','6','8') 
      IF cl_null(l_qty) OR (SQLCA.sqlcode) THEN
         LET l_qty=0
      END IF
      LET g_odh[i].odh07=l_qty
      LET g_odh[i].odh08=l_qty*g_odg.odg04
      
      #模擬數量
      CASE g_odg.odg06
         WHEN "1"  # 1. 依歷史資料乘上百分比
            LET g_odh[i].odh05 = g_odh[i].odh07 * (g_odg.odg061/100)
            LET g_odh[i].odh06 = g_odh[i].odh08 * (g_odg.odg061/100)
         WHEN "2"  # 2. 移動平均數 =Σ(前n期銷售數字)/n 
            LET l_qty=0
            LET l_mny=0
           #CHI-780002..................begin
           #LET l_day2 = g_odh[i].odh04
            LET l_day1 = g_odh[i].odh09
            CASE l_odb.odb04
              WHEN '1' #季
                   LET l_day2 = l_day1 + 3*l_m UNITS MONTH #CHI-780002
              WHEN '2' #月
                   LET l_day2 = l_day1 + l_m UNITS MONTH #CHI-780002
              WHEN '3' #旬
                   LET l_day2 = l_day1 + 10*l_m UNITS DAY #CHI-780002
              WHEN '4' #週
                   LET l_day2 = l_day1 + 7*l_m UNITS DAY #CHI-780002
              WHEN '5' #天
                   LET l_day2 = l_day1 + l_m UNITS DAY #CHI-780002
            END CASE
           #CHI-780002..................end
            LET l_qty=0
            #CHI-780002....................begin 預測起始日以前的資料抓實際資料,預測起始日以後的抓預測資料
            LET l_forecast=0
            IF l_day2>l_odb.odb05 THEN #預測起始日以後,未發生,實際資料必為0,改抓已計算的預測數量
               FOR l_l=1 TO j-1
                  IF g_odh[l_l].odh04<l_day2 THEN
                     LET l_forecast=l_forecast+g_odh[l_l].odh05
                  ELSE
                     EXIT FOR
                  END IF
               END FOR         
               WHILE l_day2>l_odb.odb05
                  CASE l_odb.odb04
                     WHEN '1' #季
                          LET l_day2 = l_day2 - 3 UNITS MONTH
                     WHEN '2' #月
                          LET l_day2 = l_day2 - 1 UNITS MONTH
                     WHEN '3' #旬
                          LET l_day2 = l_day2 - 10 UNITS DAY
                     WHEN '4' #週
                          LET l_day2 = l_day2 - 7 UNITS DAY
                     WHEN '5' #天
                          LET l_day2 = l_day2 - 1 UNITS DAY
                  END CASE
               END WHILE
            END IF 
            #CHI-780002....................end
            SELECT SUM(ogb12*ogb05_fac)/l_ima31_fac INTO l_qty
              FROM oga_file,ogb_file,occ_file
             WHERE oga01=ogb01
               AND ogb04 NOT LIKE 'MISC%'
               AND occ01=oga03 
               AND occ1005=g_odg.odg02
               AND ogb04=g_odg.odg03
               AND oga02 >=l_day1
               AND oga02 <l_day2
               AND ogaconf='Y' 
               AND ogapost='Y'
               AND oga09 IN ('2','3','4','6','8') 
            IF cl_null(l_qty) OR (SQLCA.sqlcode) THEN
               LET l_qty=0
            END IF
            LET l_qty=l_qty+l_forecast #CHI-780002 
            LET l_mny=l_qty*g_odg.odg04
            LET g_odh[i].odh05=l_qty/l_m #CHI-780002
            LET g_odh[i].odh06=l_mny/l_m #CHI-780002
         WHEN "3"  # 3. 加權移動平均數 = Σ(期間權數*期間銷售數字)/Σ(權數)
            LET l_qty=0
            LET l_mny=0
            LET l_wdg=0 #權數
            LET l_sumwdg=0 #權數合計
            LET l_sumqty=0
            LET l_summny=0
            FOR k=1 TO l_m
               CASE k
                  WHEN "1"
                     LET l_wdg=g_odg.odg0631
                  WHEN "2"
                     LET l_wdg=g_odg.odg0632
                  WHEN "3"
                     LET l_wdg=g_odg.odg0633
                  WHEN "4"
                     LET l_wdg=g_odg.odg0634
                  WHEN "5"
                     LET l_wdg=g_odg.odg0635
                  WHEN "6"
                     LET l_wdg=g_odg.odg0636
                  WHEN "7"
                     LET l_wdg=g_odg.odg0637
                  WHEN "8"
                     LET l_wdg=g_odg.odg0638
                  WHEN "9"
                     LET l_wdg=g_odg.odg0639
                  WHEN "10"
                     LET l_wdg=g_odg.odg06310
                  WHEN "11"
                     LET l_wdg=g_odg.odg06311
                  WHEN "12"
                     LET l_wdg=g_odg.odg06312
               END CASE
               LET l_sumwdg=l_sumwdg+l_wdg
               #CHI-780002.................begin
               IF k=1 THEN
                  LET l_day1 = g_odh[i].odh09 
               ELSE
                  LET l_day1 = l_day2
               END IF
               #CHI-780002.................end
               CASE l_odb.odb04
                  WHEN '1' #季
                     LET l_day2 = l_day1 + 3 UNITS MONTH
                  WHEN '2' #月
                     LET l_day2 = l_day1 + 1 UNITS MONTH
                  WHEN '3' #旬
                     LET l_day2 = l_day1 + 10 UNITS DAY
                  WHEN '4' #週
                     LET l_day2 = l_day1 + 7 UNITS DAY
                  WHEN '5' #天
                     LET l_day2 = l_day1 + 1 UNITS DAY
               END CASE
               LET l_wdgqty=0
               #CHI-780002....................begin 預測起始日以前的資料抓實際資料,預測起始日以後的抓預測資料
               LET l_forecast=0
               IF l_day2>l_odb.odb05 THEN #預測起始日以後,未發生,實際資料必為0,改抓已計算的預測數量
                  FOR l_l=1 TO j-1
                     IF g_odh[l_l].odh04<l_day2 THEN
                        LET l_forecast=l_forecast+g_odh[l_l].odh05
                     ELSE
                        EXIT FOR
                     END IF
                  END FOR         
                  WHILE l_day2>l_odb.odb05
                     CASE l_odb.odb04
                        WHEN '1' #季
                             LET l_day2 = l_day2 - 3 UNITS MONTH
                        WHEN '2' #月
                             LET l_day2 = l_day2 - 1 UNITS MONTH
                        WHEN '3' #旬
                             LET l_day2 = l_day2 - 10 UNITS DAY
                        WHEN '4' #週
                             LET l_day2 = l_day2 - 7 UNITS DAY
                        WHEN '5' #天
                             LET l_day2 = l_day2 - 1 UNITS DAY
                     END CASE
                  END WHILE
               END IF 
               #CHI-780002....................end
               IF l_day2>l_day1 THEN
                  SELECT SUM(ogb12*ogb05_fac)/l_ima31_fac INTO l_wdgqty
                    FROM oga_file,ogb_file,occ_file
                   WHERE oga01=ogb01
                     AND ogb04 NOT LIKE 'MISC%'
                     AND occ01=oga03 
                     AND occ1005=g_odg.odg02
                     AND ogb04=g_odg.odg03
                     AND oga02 >=l_day1
                     AND oga02 <l_day2
                     AND ogaconf='Y' 
                     AND ogapost='Y'
                     AND oga09 IN ('2','3','4','6','8') 
                  IF cl_null(l_wdgqty) OR (SQLCA.sqlcode) THEN
                     LET l_wdgqty=0
                  END IF
               ELSE
                  LET l_wdgqty=0
               END IF
               LET l_wdgqty=l_wdgqty+l_forecast #CHI-780002 
               LET l_wdgmny=l_wdgqty*g_odg.odg04
               LET l_sumqty=l_sumqty+(l_wdgqty*l_wdg)
               LET l_summny=l_summny+(l_wdgmny*l_wdg)
              #LET l_day1=l_day2 #CHI-780002
            END FOR
 
            LET g_odh[i].odh05=l_sumqty/l_sumwdg
            LET g_odh[i].odh06=l_summny/l_sumwdg
         WHEN "4"  # 4. 指數平滑法 = 前期預測 + α(前期歷史數量- 前期預測數量),  α=平滑係數
           #LET n=g_odg.odg064 #CHI-780002
            LET l_alpha=g_odg.odg064 #CHI-780002            
            LET l_qty=0
            SELECT odh05 INTO l_qty FROM odh_file    #前期預測數量
                                  #WHERE odh01=g_odg.odg01 #CHI-780002
                                   WHERE odh01=l_odg01     #CHI-780002
                                     AND odh02=g_odg.odg02
                                     AND odh03=g_odg.odg03
                                     AND odh04=g_odh[i].odh09
            IF cl_null(l_qty) OR (SQLCA.sqlcode) THEN
               LET l_qty=0
            END IF
            LET l_mny=0
            SELECT odh06 INTO l_mny FROM odh_file   #前期預測金額
                                  #WHERE odh01=g_odg.odg01 #CHI-780002
                                   WHERE odh01=l_odg01     #CHI-780002
                                     AND odh02=g_odg.odg02
                                     AND odh03=g_odg.odg03
                                     AND odh04=g_odh[i].odh09
            IF cl_null(l_mny) OR (SQLCA.sqlcode) THEN
               LET l_mny=0
            END IF
           #CHI-780002.....................begin
           #CASE l_odb.odb04
           #   WHEN '1' #季
           #        LET l_day1 = g_odh[i].odh04 - 3*j UNITS MONTH
           #        LET l_day2 = l_day1 + 3 UNITS MONTH
           #   WHEN '2' #月
           #        LET l_day1 = g_odh[i].odh04 - 1*j UNITS MONTH
           #        LET l_day2 = l_day1 + 1 UNITS MONTH
           #   WHEN '3' #旬
           #        LET l_day1 = g_odh[i].odh04 - 10*j UNITS DAY
           #        LET l_day2 = l_day1 + 10 UNITS DAY
           #   WHEN '4' #週
           #        LET l_day1 = g_odh[i].odh04 - 7*j UNITS DAY
           #        LET l_day2 = l_day1 + 7 UNITS DAY
           #   WHEN '5' #天
           #        LET l_day1 = g_odh[i].odh04 - 1*j UNITS DAY
           #        LET l_day2 = l_day1 + 1 UNITS DAY
           #END CASE
 
            IF j>i THEN
               LET l_day1= g_odh[i].odh09
               LET l_day2= g_odh[i+1].odh09
            ELSE #最後一個時距
               LET l_day1= g_odh[i].odh09
               CASE l_odb.odb04
                  WHEN '1' #季
                     LET l_day2 = l_day1 + 3 UNITS MONTH
                  WHEN '2' #月
                     LET l_day2 = l_day1 + 1 UNITS MONTH
                  WHEN '3' #旬
                     LET l_day2 = l_day1 + 10 UNITS DAY
                  WHEN '4' #週
                     LET l_day2 = l_day1 + 7 UNITS DAY
                  WHEN '5' #天
                     LET l_day2 = l_day1 + 1 UNITS DAY
               END CASE
            END IF
           #CHI-780002.....................end
 
            LET l_wdgqty=0
            SELECT SUM(ogb12*ogb05_fac)/l_ima31_fac INTO l_wdgqty  #前期歷史數量
              FROM oga_file,ogb_file,occ_file
             WHERE oga01=ogb01
               AND ogb04 NOT LIKE 'MISC%'
               AND occ01=oga03 
               AND occ1005=g_odg.odg02
               AND ogb04=g_odg.odg03
               AND oga02 >=l_day1
               AND oga02 <l_day2
               AND ogaconf='Y' 
               AND ogapost='Y'
               AND oga09 IN ('2','3','4','6','8') 
            IF cl_null(l_wdgqty) OR (SQLCA.sqlcode) THEN
               LET l_wdgqty=0
            END IF
            LET l_wdgmny=l_wdgqty*g_odg.odg04    #前期歷史金額
 
            LET g_odh[i].odh05=l_qty-(l_alpha*(l_wdgqty-l_qty))
            LET g_odh[i].odh06=l_mny-(l_alpha*(l_wdgmny-l_mny))
      END CASE
      
      #考慮季節因素. 若打勾,則將算出的預測資料乘以預先設定的影響%. 市場因素, 促銷力度的算法邏輯亦同
      IF (g_odg.odg07='Y') OR
         (g_odg.odg08='Y') OR
         (g_odg.odg09='Y') THEN
         SELECT * INTO l_odf.* FROM odf_file
                              WHERE odf01=g_odg.odg01
                                AND odf02=g_odg.odg02
                               #AND odf03=g_odg.odg03 #CHI-780002
                                AND odf03=l_ima131    #CHI-780002
                                AND odf04=g_odh[i].odh04
         IF STATUS=0 THEN
            IF g_odg.odg07='Y' THEN
               LET g_odh[i].odh05 = g_odh[i].odh05 * (1+(l_odf.odf05/100))
               LET g_odh[i].odh06 = g_odh[i].odh06 * (1+(l_odf.odf05/100))
            END IF
            IF g_odg.odg08='Y' THEN
               LET g_odh[i].odh05 = g_odh[i].odh05 * (1+(l_odf.odf06/100))
               LET g_odh[i].odh06 = g_odh[i].odh06 * (1+(l_odf.odf06/100))
            END IF
            IF g_odg.odg09='Y' THEN
               LET g_odh[i].odh05 = g_odh[i].odh05 * (1+(l_odf.odf07/100))
               LET g_odh[i].odh06 = g_odh[i].odh06 * (1+(l_odf.odf07/100))
            END IF
         END IF                       
      END IF
 
      #寫入DB   
      INITIALIZE l_odh.* TO NULL
      
      #CHI-780002..................begin
      #數量取位
      LET g_odh[i].odh05=cl_digcut(g_odh[i].odh05,l_gfe03)
      LET g_odh[i].odh07=cl_digcut(g_odh[i].odh07,l_gfe03)
      #CHI-780002..................end
 
      #金額取位
      LET g_odh[i].odh06=cl_digcut(g_odh[i].odh06,t_azi04)
      LET g_odh[i].odh08=cl_digcut(g_odh[i].odh08,t_azi04)
      
      LET l_odh.odh01=g_odg.odg01
      LET l_odh.odh02=g_odg.odg02
      LET l_odh.odh03=g_odg.odg03
      LET l_odh.odh04=g_odh[i].odh04
      LET l_odh.odh05=g_odh[i].odh05
      LET l_odh.odh06=g_odh[i].odh06
      LET l_odh.odh07=g_odh[i].odh07
      LET l_odh.odh08=g_odh[i].odh08
      LET l_odh.odh09=g_odh[i].odh09
      INSERT INTO odh_file VALUES (l_odh.*)
   END FOR
   
   #平均絕對差異(Mean Absolute Deviation)= (Σ|歷史數量- 預測數量|)/ 預測期數  
   SELECT SUM(ABS(odh07-odh05))/l_m INTO l_odg10 FROM odh_file  #CHI-780002
                            WHERE odh01=g_odg.odg01
                              AND odh02=g_odg.odg02
                              AND odh03=g_odg.odg03
   IF cl_null(l_odg10) OR (SQLCA.sqlcode) THEN
      LET l_odg10=0
   END IF
   #平均方差(Mean Squared Error)= Σ[(期間銷售數字-期間預測數字)的平方]/n
   SELECT SUM((odh07-odh05)*(odh07-odh05))/l_m INTO l_odg11 FROM odh_file
                            WHERE odh01=g_odg.odg01
                              AND odh02=g_odg.odg02
                              AND odh03=g_odg.odg03
   IF cl_null(l_odg11) OR (SQLCA.sqlcode) THEN
      LET l_odg11=0
   END IF
   UPDATE odg_file SET odg10=l_odg10,odg11=l_odg11
                 WHERE odg01=g_odg.odg01
                   AND odg02=g_odg.odg02
                   AND odg03=g_odg.odg03
   IF SQLCA.sqlerrd[3]>0 THEN
      LET g_odg.odg10=l_odg10
      LET g_odg.odg11=l_odg11
      DISPLAY BY NAME g_odg.odg10
      DISPLAY BY NAME g_odg.odg11
   ELSE
      CALL cl_err('odg_file','9050',1)
   END IF
END FUNCTION
 
#取數量最大值的碼數-1
#若最大值為10萬,則回傳1萬;
#若最大值為 8888 則回傳 880
FUNCTION t500_getbase(p_action)
DEFINE l_sql,l_str        STRING
DEFINE p_action           STRING
DEFINE l_feld             LIKE type_file.chr5
DEFINE l_i,l_j,l_base     LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_odh05,l_rest,l_odh07     LIKE odh_file.odh06
 
   IF g_odh.getlength()=0 THEN
      RETURN 0
   END IF
   CASE p_action
      WHEN "page04"      
         LET l_feld="odh05"
      WHEN "page05"
         LET l_feld="odh06"
   END CASE
   LET l_sql =
       "SELECT MAX(",l_feld,")",
       " FROM odh_file",
       " WHERE odh01 ='",g_odg.odg01,"'",
       "   AND odh02 ='",g_odg.odg02,"'",
       "   AND odh03 ='",g_odg.odg03,"'",
       "   AND ",g_wc2 CLIPPED
   PREPARE t500_getbase_p FROM l_sql
   DECLARE t500_getbase_c CURSOR FOR t500_getbase_p
   OPEN t500_getbase_c
   FETCH t500_getbase_c INTO l_odh05
   IF SQLCA.sqlcode OR cl_null(l_odh05) THEN
      LET l_odh05=0
   END IF
   
   CASE p_action
      WHEN "page04"      
         LET l_feld="odh07"
      WHEN "page05"
         LET l_feld="odh08"
   END CASE
   LET l_sql =
       "SELECT MAX(",l_feld,")",
       " FROM odh_file",
       " WHERE odh01 ='",g_odg.odg01,"'",
       "   AND odh02 ='",g_odg.odg02,"'",
       "   AND odh03 ='",g_odg.odg03,"'",
       "   AND ",g_wc2 CLIPPED
   PREPARE t500_getbase_p1 FROM l_sql
   DECLARE t500_getbase_c1 CURSOR FOR t500_getbase_p1
   OPEN t500_getbase_c1
   FETCH t500_getbase_c1 INTO l_odh07
   IF SQLCA.sqlcode OR cl_null(l_odh07) THEN
      LET l_odh07=0
   END IF
   
   LET l_rest=l_odh07
   
   IF l_odh05>l_odh07 THEN
      LET l_rest=l_odh05
   END IF
   IF l_rest<=0 THEN
      RETURN 0
   END IF
   LET l_i=l_rest
   LET l_str=l_i
   LET l_str=l_str.trim()
   LET l_j=l_str.getlength()-2
   IF l_j<0 THEN
      LET l_j=1
   END IF
   LET l_base=1
   FOR l_i=1 TO l_j
      LET l_base=l_base*10
   END FOR
   LET l_i=l_rest/l_base
   LET l_i=l_i*l_base/g_i
   IF l_i<1 THEN
      LET l_i=1
   END IF
   RETURN l_i
END FUNCTION
 
FUNCTION t500_draw_axis() #座標
DEFINE id,l_h          LIKE type_file.num10   #No.FUN-680130INTEGER
DEFINE l_i             LIKE type_file.num5    #No.FUN-680130SMALLINT
DEFINE l_msg           STRING
DEFINE l_draw_multiple LIKE type_file.num10     #縱刻度一個刻度的寬度  #No.FUN-680130 INTEGER
DEFINE l_dist          LIKE type_file.num10,    #每個圖例說明的間距    #No.FUN-680130 INTEGER
       l_draw_x        LIKE type_file.num10,    #每個圖例說明的x軸位置 #No.FUN-680130 INTEGER
       l_draw_y        LIKE type_file.num10,    #每個圖例說明的y軸位置 #No.FUN-680130 INTEGER
       l_base          LIKE type_file.num10                            #No.FUN-680130 INTEGER
       
  CALL DrawFillColor("black")
  LET id=DrawRectangle(g_draw_start_y-5,60,5,940) #(橫軸)
  LET id=DrawRectangle(g_draw_start_y-5,60,850,2)  #(縱軸)
  LET l_draw_multiple=35*2.3
  LET l_h=(g_draw_start_y-5)+l_draw_multiple
  FOR l_i=1 TO g_i #(縱軸刻度)
    CALL DrawFillColor("black")
    LET id=DrawRectangle(l_h,60,8,6)
    CALL DrawFillColor("black")
    LET id=DrawText(l_h-30,30,l_i*g_draw_base)
    LET l_h=l_h+l_draw_multiple
  END FOR
 
  LET g_draw_maxy=l_h-(g_draw_start_y-5)-g_draw_y #當比例為1:1的時候,長條圖在最高刻度(g_i)的長度
  
  CALL DrawFillColor("black")
  LET id=DrawText((g_draw_start_y-5)/4-10,970,"(DATE)") #日期
  CALL DrawFillColor("black")
  LET id=DrawText(940,35,g_str) #數量
  
  #圖例
  #模擬
  LET l_dist=60
  LET l_draw_x=(g_draw_start_y-5)/4
  LET l_draw_y=g_draw_y
  CALL DrawFillColor("blue")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('atm-500',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-20,l_draw_y,l_msg)
 
  #基準
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("red")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('atm-501',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-20,l_draw_y,l_msg)
END FUNCTION
 
FUNCTION t500_draw(p_action)
DEFINE p_action STRING
DEFINE id      LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_str   STRING
DEFINE l_flag  LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE l_i     LIKE type_file.num5
DEFINE l_odb04 LIKE odb_file.odb04 #期數
DEFINE day_y,day_oy  LIKE type_file.num10
DEFINE l_x,l_y,l_dx,l_dy,l_r LIKE type_file.num10
 
  LET g_i=10 #縱刻度數目
  CASE p_action
     WHEN "page04"
        CALL drawselect("c01")
        CALL drawClear()
        LET g_draw_base=t500_getbase("page04") #縱軸刻度基數;刻度比例
        LET g_str="(QTY)"
     WHEN "page05"
        CALL drawselect("c02")
        CALL drawClear()
        LET g_draw_base=t500_getbase("page05") #縱軸刻度基數;刻度比例
        LET g_str="(AMT)"
  END CASE
 
  IF g_draw_base=0 THEN #無單身資料
     RETURN
  END IF
  
  SELECT odb04 INTO l_odb04 FROM odb_file 
                           WHERE odb01=g_odg.odg01
  LET g_draw_x=0   #起始x軸位置
  LET g_draw_y=65  #起始y軸位置
  LET g_draw_dx=0  #起始dx軸位置
  LET g_draw_dy=10 #起始dy軸位置
  CASE l_odb04  
     WHEN "5"  #日
        LET g_draw_width=15 #每條長條圖寬度
       OTHERWISE
        LET g_draw_width=(850-15)/(g_odh.getlength()+1)-60 #每條長條圖寬度
        IF g_draw_width<35 THEN
           LET g_draw_width=35
        END IF
  END CASE
 
  LET g_draw_multiple=1 #時間的放大倍數(在長條圖上的刻度比例)
  LET g_draw_start_y=120      #起始y軸位置
  CALL t500_draw_axis()
  FOR l_i=1 TO g_odh.getlength()
    LET g_draw_day=g_odh[l_i].odh04
    CALL DrawFillColor("black")
    LET day_y=g_draw_y+g_draw_width
    IF l_odb04='5' THEN
       LET id=DrawText(60,day_y,DAY(g_draw_day)) #日期
    ELSE
       LET id=DrawText(60,day_y,g_draw_day) #日期
    END IF
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
    
    IF g_odh.getlength()<=8 THEN #資料太密集,圓點會太擠,所以不畫
       #模擬
       CALL DrawFillColor("blue")
       CASE p_action
          WHEN "page04"
             LET l_x  = g_draw_start_y-5+g_odh[l_i].odh05*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))+12      
             LET l_str=g_odh[l_i].odh05
          WHEN "page05"
             LET l_x  = g_draw_start_y-5+g_odh[l_i].odh06*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))+12      
             LET l_str=g_odh[l_i].odh06
       END CASE
       
       LET l_y  = day_y-8
       LET l_r = 25
       LET id=Drawcircle(l_x,l_y,l_r)
       LET l_str=l_str.trim()
       CALL drawSetComment(id,l_str)
       
       #基準
       CALL DrawFillColor("red")
       CASE p_action
          WHEN "page04"
             LET l_x  = g_draw_start_y-5+g_odh[l_i].odh07*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))+12      
             LET l_str=g_odh[l_i].odh07
          WHEN "page05"
             LET l_x  = g_draw_start_y-5+g_odh[l_i].odh08*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))+12      
             LET l_str=g_odh[l_i].odh08
       END CASE
       
       LET l_y  = day_y-8
       LET l_r = 25
       LET id=Drawcircle(l_x,l_y,l_r)
       LET l_str=l_str.trim()
       CALL drawSetComment(id,l_str)
    END IF
    
    IF l_i>1 THEN
       #模擬
       CALL DrawFillColor("blue")
       CALL Drawlinewidth(2)
       
       CASE p_action
          WHEN "page04"
             LET l_x  = g_draw_start_y-5+g_odh[l_i-1].odh05*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
             LET l_dx = (g_odh[l_i].odh05-g_odh[l_i-1].odh05)*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
          WHEN "page05"
             LET l_x  = g_draw_start_y-5+g_odh[l_i-1].odh06*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
             LET l_dx = (g_odh[l_i].odh06-g_odh[l_i-1].odh06)*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
       END CASE
 
       LET l_y  = day_oy+8
       LET l_dy = day_y-day_oy
       LET id=Drawline(l_x,l_y,l_dx,l_dy)  
 
       #基準
       CALL DrawFillColor("red")
       CALL Drawlinewidth(2)
       
       CASE p_action
          WHEN "page04"
             LET l_x  = g_draw_start_y-5+g_odh[l_i-1].odh07*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
             LET l_dx = (g_odh[l_i].odh07-g_odh[l_i-1].odh07)*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
          WHEN "page05"
             LET l_x  = g_draw_start_y-5+g_odh[l_i-1].odh08*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
             LET l_dx = (g_odh[l_i].odh08-g_odh[l_i-1].odh08)*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))
       END CASE
 
       LET l_y  = day_oy+8
       LET l_dy = day_y-day_oy
       LET id=Drawline(l_x,l_y,l_dx,l_dy)       
 
    END IF
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
    LET g_draw_y=g_draw_y+g_draw_width
 
    LET g_draw_y=g_draw_y+g_draw_width
    LET day_oy=day_y
  END FOR
END FUNCTION
 
#轉預測資料
FUNCTION t500_turn()
   DEFINE l_odb RECORD LIKE odb_file.*
   DEFINE l_odc RECORD LIKE odc_file.*
   DEFINE l_odd RECORD LIKE odd_file.*
   DEFINE l_ode RECORD LIKE ode_file.*
   DEFINE l_odh RECORD LIKE odh_file.*
   DEFINE l_ima02 LIKE ima_file.ima02
   DEFINE l_ima021 LIKE ima_file.ima021
   DEFINE l_ima31 LIKE ima_file.ima31
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_odc12 LIKE odc_file.odc12 #確認碼
   DEFINE l_odc27 LIKE odc_file.odc27 #資料來源
   
   IF cl_null(g_odg.odg01) OR
      cl_null(g_odg.odg02) OR
      cl_null(g_odg.odg03) THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
   
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM odc_file
                             WHERE odc01=g_odg.odg01
                               AND odc02=g_odg.odg02
   IF l_cnt>0 THEN
      SELECT odc12,odc27 INTO l_odc12,l_odc27 
                         FROM odc_file
                        WHERE odc01=g_odg.odg01
                          AND odc02=g_odg.odg02
      CASE
         WHEN cl_null(l_odc27) OR l_odc27<>"4"
            CALL cl_err('','atm-509',1)
            RETURN         
         WHEN l_odc12='Y' 
            CALL cl_err('','atm-504',1)
            RETURN
      END CASE
      IF g_cnt>0 THEN
         CALL cl_err('','atm-502',1)
         RETURN
      END IF
   END IF
   
   BEGIN WORK
   INITIALIZE l_odc.* TO NULL
   INITIALIZE l_odd.* TO NULL
   INITIALIZE l_ode.* TO NULL
   
   SELECT * INTO l_odb.* FROM odb_file
                        WHERE odb01=g_odg.odg01
   LET l_odc.odc01  = g_odg.odg01
   LET l_odc.odc02  = g_odg.odg02
   LET l_odc.odc04  = l_odb.odb04
   LET l_odc.odc05  = l_odb.odb05
   LET l_odc.odc06  = l_odb.odb06
   LET l_odc.odc07  = g_user
   LET l_odc.odc08  = g_grup
   LET l_odc.odc09  = l_odb.odb09
   LET l_odc.odc10  = s_curr3(l_odb.odb09,g_today,g_apz.apz33)
   LET l_odc.odc11  = 0    
   LET l_odc.odc12  = 'N'
   LET l_odc.odc121 = 'N'
   LET l_odc.odc13  = 'N'
   LET l_odc.odc131 = 'N'
   LET l_odc.odcuser=g_user
   LET l_odc.odcgrup=g_grup
   LET l_odc.odc27  = '4'  #(資料來源:模擬資料)
 
   IF l_cnt=0 THEN
      LET l_odc.odcoriu = g_user      #No.FUN-980030 10/01/04
      LET l_odc.odcorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO odc_file VALUES (l_odc.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins odc',SQLCA.sqlcode,1)
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   LET g_cnt=0
   SELECT MAX(odd03) INTO g_cnt FROM odd_file
                               WHERE odd01=g_odg.odg01
                                 AND odd02=g_odg.odg02
   IF cl_null(g_cnt) THEN
      LET g_cnt=0
   END IF
   LET g_cnt=g_cnt+1
   SELECT ima02,ima021,ima31 INTO 
         l_ima02,l_ima021,l_ima31 FROM ima_file
                            WHERE ima01=g_odg.odg03
   LET l_odd.odd01 = g_odg.odg01       
   LET l_odd.odd02 = g_odg.odg02       
   LET l_odd.odd03 = g_cnt
   LET l_odd.odd04 = g_odg.odg03
   LET l_odd.odd07 = l_ima02
   LET l_odd.odd08 = l_ima021
   LET l_odd.odd09 = l_ima31
 
   INSERT INTO odd_file VALUES (l_odd.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins odd',SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF
   
   DECLARE t500_turn_c CURSOR FOR SELECT * FROM odh_file
                                   WHERE odh01=g_odg.odg01
                                     AND odh02=g_odg.odg02
                                     AND odh03=g_odg.odg03
   FOREACH t500_turn_c INTO l_odh.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('for odh',SQLCA.sqlcode,1)
         ROLLBACK WORK
         RETURN
      END IF
      LET l_ode.ode01  = g_odg.odg01       
      LET l_ode.ode02  = g_odg.odg02      
      LET l_ode.ode03  = l_odd.odd03
      LET l_ode.ode031 = g_odg.odg03     
      LET l_ode.ode04  = l_odh.odh04      
      LET l_ode.ode05  = l_odh.odh07      
      LET l_ode.ode06  = l_odh.odh05    
      LET l_ode.ode07  = 0      
      LET l_ode.ode071 = 0   
      LET l_ode.ode08  = 0       
      LET l_ode.ode09  = l_ode.ode06+l_ode.ode07+l_ode.ode071+l_ode.ode08
      LET l_ode.ode10  = g_odg.odg04    
      LET l_ode.ode11  = l_odh.odh06      
      LET l_ode.ode12  = 0  
      LET l_ode.ode121 = 0     
      LET l_ode.ode13  = 0    
      LET l_ode.ode14  = l_ode.ode11+l_ode.ode12+l_ode.ode121+l_ode.ode13  
      LET l_ode.ode15  = l_odh.odh08
      INSERT INTO ode_file VALUES (l_ode.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins ode',SQLCA.sqlcode,1)
         ROLLBACK WORK
         RETURN
      END IF
   END FOREACH
   LET g_odg.odg12='Y'
   UPDATE odg_file SET odg12=g_odg.odg12
                 WHERE odg01=g_odg.odg01
                   AND odg02=g_odg.odg02
                   AND odg03=g_odg.odg03
   DISPLAY BY NAME g_odg.odg12
   COMMIT WORK
   CALL cl_err('','asr-026',0)
END FUNCTION
 
#預測影響因素維護
FUNCTION t500_factor()
   DEFINE l_cmd STRING
   
   LET l_cmd= "atmi500 '",g_odg.odg01,"' '",
              g_odg.odg02,"' '",
              g_odg.odg03,"'"
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
 
#集團銷售預測維護
FUNCTION t500_forcaste()
   DEFINE l_cmd STRING
   
   LET l_cmd= "atmi161 '",g_odg.odg01,"' '",
              g_odg.odg02,"'"
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION
 
FUNCTION t500_control_odg06()
   CALL cl_set_comp_required("odg061",g_odg.odg06="1")
   CALL cl_set_comp_required("odg062",g_odg.odg06="2")
   CALL cl_set_comp_required("odg064",g_odg.odg06="4")
   CALL cl_set_comp_required("odg063",g_odg.odg06="3")
   CALL cl_set_comp_entry("odg061",g_odg.odg06="1")
   CALL cl_set_comp_entry("odg062",g_odg.odg06="2")
   CALL cl_set_comp_entry("odg064",g_odg.odg06="4")
   CALL cl_set_comp_entry("odg063",g_odg.odg06="3")
   IF (g_odg.odg06<>"3") OR (cl_null(g_odg.odg06))THEN
      CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",
                                FALSE)
      CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",
                                FALSE)
   END IF
   IF g_odg.odg06="3" THEN
      CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",FALSE) #CHI-780002
      CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",FALSE)    #CHI-780002
      CASE
         WHEN g_odg.odg063=1  CALL cl_set_comp_required("odg0631",TRUE)
                              CALL cl_set_comp_entry("odg0631",TRUE)
         WHEN g_odg.odg063=2  CALL cl_set_comp_required("odg0631,odg0632",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632",TRUE)
         WHEN g_odg.odg063=3  CALL cl_set_comp_required("odg0631,odg0632,odg0633",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633",TRUE)
         WHEN g_odg.odg063=4  CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634",TRUE)
         WHEN g_odg.odg063=5  CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635",TRUE)
         WHEN g_odg.odg063=6  CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636",TRUE)
         WHEN g_odg.odg063=7  CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637",TRUE)
         WHEN g_odg.odg063=8  CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638",TRUE)
         WHEN g_odg.odg063=9  CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639",TRUE)
         WHEN g_odg.odg063=10 CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310",TRUE)
         WHEN g_odg.odg063=11 CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311",TRUE)
         WHEN g_odg.odg063=12 CALL cl_set_comp_required("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",TRUE)
                              CALL cl_set_comp_entry("odg0631,odg0632,odg0633,odg0634,odg0635,odg0636,odg0637,odg0638,odg0639,odg06310,odg06311,odg06312",TRUE)
      END CASE
   END IF
END FUNCTION


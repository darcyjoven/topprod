# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: axmi040.4gl
# Descriptions...: 常用說明維護作業
# Date & Author..: 94/12/16 By Danny
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/08/31 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740129 07/04/20 By sherry  打印結果中，“結束”位置有誤。
# Modify.........: No.TQC-740177 07/04/22 By Judy 刪除一筆資料時，上一筆資料的單身也會被刪除
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun    老報表改成p_query 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_oae           RECORD LIKE oae_file.*,       
    g_oae_t         RECORD LIKE oae_file.*,      
    g_oae_o         RECORD LIKE oae_file.*,     
    g_oae01_t       LIKE oae_file.oae01,       
    g_oaf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        oaf02       LIKE oaf_file.oaf02,
        oaf03       LIKE oaf_file.oaf03
                    END RECORD,
    g_oaf_t         RECORD    #程式變數(Program Variables)
        oaf02       LIKE oaf_file.oaf02,
        oaf03       LIKE oaf_file.oaf03
                    END RECORD,
#    g_wc,g_wc2,g_sql    string,  #NO.TQC-630166 mark 
    g_wc,g_wc2,g_sql     string,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_cmd           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
DEFINE g_forupd_sql  string   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#主程式開始
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
MAIN
#  DEFINE     l_time    LIKE type_file.chr8            #No.FUN-6A0094
 
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
         RETURNING g_time                  #No.FUN-6A0094
 
    LET g_forupd_sql = "SELECT * FROM oae_file WHERE oae01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 20
 
    OPEN WINDOW i040_w AT p_row,p_col              #顯示畫面
         WITH FORM "axm/42f/axmi040"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
 
    CALL i040_menu()
 
    CLOSE WINDOW i040_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time               #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION i040_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_oaf.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_oae.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON oae01,oae02
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON oaf02,oaf03        # 螢幕上取單身條件
         FROM s_oaf[1].oaf02,s_oaf[1].oaf03 
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT oae01 FROM oae_file",
                   " WHERE ", g_wc CLIPPED,
                   "  "
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT  oae01 ",
                   "  FROM oae_file, oaf_file",
                   " WHERE oae01 = oaf01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "  "
    END IF
 
    PREPARE i040_prepare FROM g_sql
    DECLARE i040_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i040_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM oae_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT oae01) FROM oae_file,oaf_file WHERE ",
                  "oaf01=oae01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i040_precount FROM g_sql
    DECLARE i040_count CURSOR FOR i040_precount
 
END FUNCTION
 
FUNCTION i040_menu()
   WHILE TRUE
      CALL i040_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i040_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i040_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i040_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i040_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i040_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i040_out()                                                         #No.FUN-7C0043---del--
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oaf),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_oae.oae01 IS NOT NULL THEN
                 LET g_doc.column1 = "oae01"
                 LET g_doc.value1 = g_oae.oae01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
 
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i040_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_oaf.clear()
 
    INITIALIZE g_oae.* LIKE oae_file.*             #DEFAULT 設定
    LET g_oae01_t = NULL
    LET g_oae_t.* = g_oae.*
    LET g_oae_o.* = g_oae.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i040_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_oae.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_oae.oae01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
 
        INSERT INTO oae_file(oae01,oae02) VALUES(g_oae.oae01,g_oae.oae02)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#          CALL cl_err(g_oae.oae01,SQLCA.sqlcode,1)   #No.FUN-660167
           CALL cl_err3("ins","oae_file",g_oae.oae01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
           CONTINUE WHILE
        END IF
 
        SELECT oae01 INTO g_oae.oae01 FROM oae_file
         WHERE oae01 = g_oae.oae01
        LET g_oae01_t = g_oae.oae01        #保留舊值
        LET g_oae_t.* = g_oae.*
 
        CALL g_oaf.clear()
        LET g_rec_b = 0 
 
        CALL i040_b()                      #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i040_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_oae.oae01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_oae01_t = g_oae.oae01
    LET g_oae_o.* = g_oae.*
    LET g_oae_t.* = g_oae.*
 
    BEGIN WORK
 
    OPEN i040_cl USING g_oae.oae01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i040_cl ROLLBACK WORK RETURN
    END IF
 
    FETCH i040_cl INTO g_oae.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i040_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i040_show()
 
    WHILE TRUE
        LET g_oae01_t = g_oae.oae01
        CALL i040_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_oae.*=g_oae_t.*
            CALL i040_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        IF g_oae.oae01 != g_oae01_t THEN  
           UPDATE oaf_file SET oaf01 = g_oae.oae01 WHERE oaf01 = g_oae01_t
           IF SQLCA.sqlcode THEN
#             CALL cl_err('oaf',SQLCA.sqlcode,0)  #No.FUN-660167
              CALL cl_err3("upd","oaf_file",g_oae01_t,"",SQLCA.sqlcode,"","oaf",1)  #No.FUN-660167
              CONTINUE WHILE  
           END IF
        END IF
 
        UPDATE oae_file SET oae01 = g_oae.oae01, oae02 = g_oae.oae02 
         WHERE oae01 = g_oae.oae01
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)   #No.FUN-660167
           CALL cl_err3("upd","oae_file",g_oae01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
           CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    CLOSE i040_cl
    COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i040_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
    l_n1            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
 
    DISPLAY BY NAME g_oae.oae01,g_oae.oae02 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME
        g_oae.oae01,g_oae.oae02 WITHOUT DEFAULTS 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i040_set_entry(p_cmd)
           CALL i040_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
        
        AFTER FIELD oae01      
           IF NOT cl_null(g_oae.oae01) THEN
              IF g_oae.oae01 != g_oae01_t OR cl_null(g_oae01_t) THEN
                 SELECT count(*) INTO g_cnt FROM oae_file
                  WHERE oae01 = g_oae.oae01
                 IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_oae.oae01,-239,0)
                    LET g_oae.oae01 = g_oae01_t
                    DISPLAY BY NAME g_oae.oae01 
                    NEXT FIELD oae01
                 END IF
              END IF
              LET g_oae_o.oae01 = g_oae.oae01
           END IF
             
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
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
FUNCTION i040_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oae.* TO NULL              #FUN-6B0079
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL i040_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_oae.* TO NULL
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
 
    OPEN i040_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_oae.* TO NULL
    ELSE
       OPEN i040_count
       FETCH i040_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL i040_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i040_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i040_cs INTO g_oae.oae01
        WHEN 'P' FETCH PREVIOUS i040_cs INTO g_oae.oae01
        WHEN 'F' FETCH FIRST    i040_cs INTO g_oae.oae01
        WHEN 'L' FETCH LAST     i040_cs INTO g_oae.oae01
        WHEN '/'
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
            FETCH ABSOLUTE g_jump i040_cs INTO g_oae.oae01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)
        INITIALIZE g_oae.* TO NULL  #TQC-6B0105
        LET g_oae.oae01 = NULL      #TQC-6B0105
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
    SELECT * INTO g_oae.* FROM oae_file WHERE oae01 = g_oae.oae01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","oae_file",g_oae.oae01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_oae.* TO NULL
        RETURN
    END IF
    LET g_data_owner = ''      #FUN-4C0057 add
    LET g_data_group = ''      #FUN-4C0057 add
    CALL i040_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i040_show()
    LET g_oae_t.* = g_oae.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_oae.oae01,g_oae.oae02 
    CALL i040_b_fill(g_wc2)                 #單身
# genero  script marked     LET g_oaf_pageno = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i040_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1      #No.FUN-680137 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_oae.oae01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i040_cl USING g_oae.oae01
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)
       CLOSE i040_cl ROLLBACK WORK RETURN 
    END IF
 
    FETCH i040_cl INTO g_oae.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)
       CLOSE i040_cl ROLLBACK WORK RETURN 
    END IF
 
    CALL i040_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "oae01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_oae.oae01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM oae_file WHERE oae01 = g_oae.oae01
        DELETE FROM oaf_file WHERE oaf01 = g_oae.oae01  #TQC-740177
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_oae.oae01,SQLCA.sqlcode,0)   #No.FUN-660167
           CALL cl_err3("del","oae_file",g_oae.oae01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        ELSE
           CLEAR FORM
           CALL g_oaf.clear()
    	   INITIALIZE g_oae.* LIKE oae_file.*             #DEFAULT 設定
           OPEN i040_count
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE i040_cs
              CLOSE i040_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           FETCH i040_count INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i040_cs
              CLOSE i040_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i040_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i040_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i040_fetch('/')
           END IF
        END IF
#       DELETE FROM oaf_file WHERE oaf01 = g_oae.oae01  #TQC-740177
    END IF
 
    CLOSE i040_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i040_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_oae.oae01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT oaf02,oaf03 FROM oaf_file ",
                       "  WHERE oaf01 = ? AND oaf02 = ? AND oaf03 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_oaf WITHOUT DEFAULTS FROM s_oaf.* 
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
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_oaf_t.* = g_oaf[l_ac].*  #BACKUP
               OPEN i040_bcl USING g_oae.oae01, g_oaf_t.oaf02, g_oaf_t.oaf03  
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_oaf_t.oaf03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i040_bcl INTO g_oaf[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oaf_t.oaf03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE FIELD oaf02 
            IF cl_null(g_oaf[l_ac].oaf02) THEN
               SELECT MAX(oaf02)+1 INTO g_oaf[l_ac].oaf02 FROM oaf_file
                WHERE oaf01=g_oae.oae01
               IF cl_null(g_oaf[l_ac].oaf02) THEN 
                  LET g_oaf[l_ac].oaf02=1
               END IF
            END IF
 
        AFTER FIELD oaf02 
            IF NOT cl_null(g_oaf[l_ac].oaf02) THEN
               IF g_oaf_t.oaf02 != g_oaf[l_ac].oaf02 
                  OR cl_null(g_oaf_t.oaf02) THEN
                  SELECT COUNT(*) INTO g_cnt FROM oaf_file
                   WHERE oaf01=g_oae.oae01 AND oaf02=g_oaf[l_ac].oaf02
                  IF g_cnt >0 THEN
                     CALL cl_err(g_oae.oae01,-239,0)
                     NEXT FIELD oaf02
                  END IF
               END IF
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_oaf[l_ac].* TO NULL  #900423
            LET g_oaf_t.* = g_oaf[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oaf02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO oaf_file(oaf01,oaf02,oaf03)   #No.MOD-470041
                          VALUES(g_oae.oae01,g_oaf[l_ac].oaf02,g_oaf[l_ac].oaf03)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_oaf[l_ac].oaf03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","oaf_file",g_oae.oae01,g_oaf[l_ac].oaf02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               COMMIT WORK
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_oaf_t.oaf02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
               END IF
                
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               
               DELETE FROM oaf_file 
                WHERE oaf01 = g_oae.oae01 
                  AND oaf02 = g_oaf_t.oaf02
               IF SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err(g_oaf_t.oaf03,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("del","oaf_file",g_oae.oae01,g_oaf_t.oaf02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
 
               COMMIT WORK
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oaf[l_ac].* = g_oaf_t.*
               CLOSE i040_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oaf[l_ac].oaf02,-263,1)
               LET g_oaf[l_ac].* = g_oaf_t.*
            ELSE
               UPDATE oaf_file SET oaf02=g_oaf[l_ac].oaf02,
                                   oaf03=g_oaf[l_ac].oaf03
                WHERE oaf01 = g_oae.oae01 
                  AND oaf02 = g_oaf_t.oaf02
                  AND oaf03 = g_oaf_t.oaf03  
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_oaf[l_ac].oaf03,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","oaf_file",g_oae.oae01,g_oaf_t.oaf02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_oaf[l_ac].* = g_oaf_t.*
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
                  LET g_oaf[l_ac].* = g_oaf_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_oaf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i040_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add 
            CLOSE i040_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i040_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF l_ac > 1 THEN
               LET g_oaf[l_ac].* = g_oaf[l_ac-1].*
               NEXT FIELD oaf02
            END IF
 
        ON ACTION controls                                  #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")                #No.FUN-6A0092
   
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
 
    CLOSE i040_bcl
    COMMIT WORK
    CALL i040_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i040_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM oae_file WHERE oae01 = g_oae.oae01
         INITIALIZE g_oae.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i040_delall()
 
    SELECT COUNT(*) INTO g_cnt FROM oaf_file
     WHERE oaf01=g_oae.oae01
 
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM oae_file WHERE oae01 = g_oae.oae01
       IF SQLCA.SQLCODE THEN 
#         CALL cl_err('DEL-oae',SQLCA.SQLCODE,0)   #No.FUN-660167
          CALL cl_err3("del","oae_file",g_oae.oae01,"",SQLCA.SQLCODE,"","DEL-oae",1)  #No.FUN-660167
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i040_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200) 
 
    CONSTRUCT l_wc2 ON oaf02,oaf03
            FROM s_oaf[1].oaf02,s_oaf[1].oaf03
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
 
    CALL i040_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i040_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200) 
 
    LET g_sql =
        "SELECT oaf02,oaf03 FROM oaf_file",
        " WHERE oaf01 ='",g_oae.oae01,"'",  #單頭
        " AND ",p_wc2 CLIPPED,              #單身
        " ORDER BY 1"                       #NO:2574   
 
    PREPARE i040_pb FROM g_sql
    DECLARE oaf_curs                       #CURSOR
        CURSOR FOR i040_pb
 
    CALL g_oaf.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH oaf_curs INTO g_oaf[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    
    END FOREACH
    CALL g_oaf.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt-1               #告訴I.單身筆數
 
END FUNCTION
 
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oaf TO s_oaf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL i040_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i040_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i040_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i040_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i040_fetch('L')
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
 
      ON ACTION controls                                  #No.FUN-6A0092                                                          
         CALL cl_set_head_visible("","AUTO")                #No.FUN-6A0092  
 
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#NO.FUN-7C0043----BEGIN
FUNCTION i040_out()
#DEFINE
#   l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#   sr              RECORD
#       oae01       LIKE oae_file.oae01,
#       oae02       LIKE oae_file.oae02,
#       oaf02       LIKE oaf_file.oaf02,
#       oaf03       LIKE oaf_file.oaf03
#                   END RECORD,
#   l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#   l_za05          LIKE type_file.chr1000              #        #No.FUN-680137 VARCHAR(40)
    DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) AND NOT cl_null(g_oae.oae01) THEN                          
       LET g_wc = " oae01 = '",g_oae.oae01,"'"                                  
    END IF                                                                      
    IF g_wc  IS NULL THEN                                                       
       CALL cl_err('','9057',0)                                                 
       RETURN                                                                   
    END IF                                                                      
    IF g_wc2  IS NULL THEN                                                      
       LET g_wc2 = ' 1=1'                                                       
    END IF                                                                      
    LET l_cmd = 'p_query "axmi040" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'      
    CALL cl_cmdrun(l_cmd)
 
#   IF g_wc  IS NULL THEN 
#      CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
#   LET g_sql="SELECT oae01,oae02,oaf02,oaf03",
#             " FROM oae_file,oaf_file",
#             " WHERE oae01 = oaf01 AND ",g_wc CLIPPED,
#             " AND ",g_wc2 CLIPPED,
#             " ORDER BY 1,3 "
#   PREPARE i040_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i040_co                         # CURSOR
#       CURSOR FOR i040_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi040') RETURNING l_name
#   START REPORT i040_rep TO l_name
 
#   FOREACH i040_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i040_rep(sr.*)
 
#   END FOREACH
 
#   FINISH REPORT i040_rep
#   CLOSE i040_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i040_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#   l_sql1          LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(100)
#   l_sql1          STRING, #NO.TQC-630166  
#   l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#   l_bmg           RECORD LIKE bmg_file.*,
#   sr              RECORD
#       oae01       LIKE oae_file.oae01, 
#       oae02       LIKE oae_file.oae02, 
#       oaf02       LIKE oaf_file.oaf02,
#       oaf03       LIKE oaf_file.oaf03
#                   END RECORD 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.oae01
 
#FUN-4C0096 modify
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           PRINT ''
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31], 
#                 g_x[32],
#                 g_x[33],
#                 g_x[34]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#      
#       BEFORE GROUP OF sr.oae01
#          PRINT COLUMN g_c[31],sr.oae01,
#                COLUMN g_c[32],sr.oae02
#          
#       ON EVERY ROW
#          PRINT COLUMN g_c[33],sr.oaf02 USING '####',
#                COLUMN g_c[34],sr.oaf03
 
#       AFTER GROUP OF sr.oae01
#          PRINT ' ' 
#
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           IF g_zz05 = 'Y' THEN       # 80:70,140,210      132:120,240
#NO.TQC-630166 start--
#               IF g_wc[001,080] > ' ' THEN
#	          PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#               IF g_wc[071,140] > ' ' THEN
#	          PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#               IF g_wc[141,210] > ' ' THEN
#	          PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#               CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
#              PRINT g_dash[1,g_len]
#           END IF
#      #    PRINT g_x[4] CLIPPED, COLUMN g_c[34], g_x[7] CLIPPED
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED     #No.TQC-740129
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#       #       PRINT g_x[4] CLIPPED,COLUMN g_c[34], g_x[6] CLIPPED
#               PRINT g_x[4] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED   #No.TQC-740129
#           ELSE
#               SKIP 2 LINE
#           END IF
##
#END REPORT
#NO.FUN-7C0043--END
FUNCTION i040_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oae01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i040_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oae01",FALSE)
    END IF
 
END FUNCTION

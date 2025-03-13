# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimt505.4gl
# Descriptions...: img庫存單位維護作業(aimt505)
# Date & Author..: 03/03/03 By Wiky
# Modify.........: 05/03/29 No.FUN-530065 By Will 增加料件的開窗
# Modify.........: MOD-420449 05/07/11 BY Yiting key值可更改
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-8A0167 08/10/17 By claire 修改功能應受權限控管
# Modify.........: No.TQC-970397 09/08/06 By lilingyu 倉庫單位欄位如錄入無效值,首先需檢查該單位是否存在于gfe_file,其次再去檢查有無換算率
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-BA0056 11/10/19 By jason 新增’產生庫別資料’ACTION
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查
# Modify.........: No.TQC-DB0055 13/11/21 By wangrr 增加'規格'欄位,'倉庫'增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_img               RECORD LIKE img_file.*,
    g_img_t             RECORD LIKE img_file.*,
    g_img_o             RECORD LIKE img_file.*,
    g_img01_t           LIKE img_file.img01,
    g_img02_t           LIKE img_file.img02,
    g_img09_t           LIKE img_file.img09,
    g_wc,g_sql          string                     #No.FUN-580092 HCN
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    INITIALIZE g_img.* TO NULL
    INITIALIZE g_img_t.* TO NULL
    INITIALIZE g_img_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM img_file WHERE img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t505_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW t505_w AT p_row,p_col WITH FORM "aim/42f/aimt505"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    WHILE TRUE
      LET g_action_choice=""
    CALL t505_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t505_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION t505_cs()
    CLEAR FORM
    INITIALIZE g_img.* TO NULL   #FUN-640213 add 
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        img01,img02,img03,img04,img09,img10,img21
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
          CASE
 
              #FUN-530065
               WHEN INFIELD(img01)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.state = "c"
                 #   LET g_qryparam.default1 = g_img.img01
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","",g_img.img01,"","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO img01
                    NEXT FIELD img01
              #FUN-530065
               #TQC-DB0055--add--str--
               WHEN INFIELD(img02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_img1"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO img02
                    NEXT FIELD img02
               #TQC-DB0055--add--end
 
               WHEN INFIELD(img09) #庫存單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO img09
                    NEXT FIELD img09
               OTHERWISE EXIT CASE
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
    #資料權限的檢查
    LET g_sql="SELECT img01,img02,img03,img04",
              " FROM img_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY img01"
    PREPARE t505_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t505_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t505_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM img_file WHERE ",g_wc CLIPPED # 捉出符合QBE條件的
    PREPARE t505_precount FROM g_sql
    DECLARE t505_count CURSOR FOR t505_precount
END FUNCTION
 
FUNCTION t505_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t505_q()
            END IF
        ON ACTION next
            CALL t505_fetch('N')
        ON ACTION previous
            CALL t505_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"  #MOD-8A0167 
            IF cl_chk_act_auth() THEN     #MOD-8A0167 cancel mark
                 CALL t505_u()
            END IF                        #MOD-8A0167 cancel mark 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t505_fetch('/')
        ON ACTION first
            CALL t505_fetch('F')
        ON ACTION last
            CALL t505_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 　　　
 　　　#FUN-BA0056 --START--　
      ON ACTION gen_w_h_data   #產生庫別資料
         LET g_action_choice="gen_w_h_data"
         IF cl_chk_act_auth() THEN
            CALL t505_ins_img()
         END IF 
 　　　#FUN-BA0056 --END--
 
      #No.FUN-680046-------add--------str----
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF g_img.img01 IS NOT NULL THEN
               LET g_doc.column1 = "img01"
               LET g_doc.value1 = g_img.img01
               CALL cl_doc()
          END IF
       END IF
      #No.FUN-680046-------add--------end----
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t505_cs
END FUNCTION
 
 
FUNCTION t505_i(p_cmd)
    DEFINE
        p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_ima25     LIKE ima_file.ima25
    DEFINE l_cnt    LIKE type_file.num5     #TQC-970397
    
     #MOD-420449
    #INPUT BY NAME g_img.img09 WITHOUT DEFAULTS
    INPUT BY NAME g_img.img01,g_img.img02,
                  g_img.img03,g_img.img04,
                  g_img.img09 WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t505_set_entry(p_cmd)
        CALL t505_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
    #--END
 
{
       BEFORE FIELD img09
          IF g_img.img10 <> 0 THEN
              CALL cl_err(g_img.img01,'aim-803',0)
          END IF
 
}
       AFTER FIELD img09
          IF NOT cl_null(g_img.img09) THEN
#TQC-970397 --BEGIN--          
             SELECT COUNT(*) INTO l_cnt FROM gfe_file
              WHERE gfe01 = g_img.img09
             IF l_cnt = 0 THEN 
                CALL cl_err('','afa-319',0)
                NEXT FIELD img09
             ELSE    
#TQC-970397 --END--            
             SELECT ima25 INTO l_ima25 FROM ima_file
              WHERE g_img.img01 = ima01
               CALL s_umfchk(g_img.img01,g_img.img09,l_ima25)
                      RETURNING g_cnt,g_img.img21
             IF g_cnt = 1 THEN
                CALL cl_err('','abm-731',1)
                NEXT FIELD img09
             END IF
             DISPLAY BY NAME g_img.img21
           END IF   #TQC-970397                
          END IF
 
       ON ACTION controlp
          CASE
               WHEN INFIELD(img09) #庫存單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_img.img09
                    CALL cl_create_qry() RETURNING g_img.img09
#                    CALL FGL_DIALOG_SETBUFFER( g_img.img09 )
                    DISPLAY BY NAME g_img.img09
                    NEXT FIELD img09
               OTHERWISE EXIT CASE
            END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
 
FUNCTION t505_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t505_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t505_count
    FETCH t505_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t505_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        INITIALIZE g_img.* TO NULL
    ELSE
        CALL t505_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t505_fetch(p_flimg)
    DEFINE
        p_flimg          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flimg
        WHEN 'N' FETCH NEXT     t505_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04 
        WHEN 'P' FETCH PREVIOUS t505_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04
        WHEN 'F' FETCH FIRST    t505_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04
        WHEN 'L' FETCH LAST     t505_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
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
            END IF
            FETCH ABSOLUTE g_jump t505_cs INTO g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        INITIALIZE g_img.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flimg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_img.* FROM img_file            # 重讀DB,因TEMP有不被更新特性
       WHERE img01 = g_img.img01 AND img02 = g_img.img02 AND img03 = g_img.img03 AND img04 = g_img.img04
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_img.img01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","img_file",g_img.img01,"",SQLCA.sqlcode,"","",1) #No.FUN-660156 
    ELSE
        CALL t505_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t505_show()
    DEFINE
      d_ima02   LIKE ima_file.ima02,
      d_ima05   LIKE ima_file.ima05,
      d_ima08   LIKE ima_file.ima08,
      d_ima25   LIKE ima_file.ima25
   DEFINE l_ima021  LIKE ima_file.ima021 #TQC-DB0055
 
     LET g_img_t.* = g_img.*
     DISPLAY BY NAME g_img.img01
             ,g_img.img02,g_img.img03,g_img.img04,g_img.img09,
              g_img.img10,g_img.img21
    SELECT ima02,ima021,ima05,ima08,ima25           #TQC-DB0055 add ima021
      INTO d_ima02,l_ima021,d_ima05,d_ima08,d_ima25 #TQC-DB0055 add l_ima021
      FROM ima_file
     WHERE g_img.img01 = ima01
    DISPLAY d_ima02,l_ima021,d_ima05,d_ima08,d_ima25 #TQC-DB0055 add l_ima021 
         TO ima02,ima021,ima05,ima08,ima25           #TQC-DB0055 add ima021
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t505_u()
DEFINE       l_n    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_img.img01 IS NULL THEN     #未先查詢即選UPDATE
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM tlf_file    #check 存在tlf檔中不可異動
     WHERE tlf01 =g_img.img01
       AND tlf902=g_img.img02
       AND tlf903=g_img.img03
       AND tlf904=g_img.img04
    IF l_n>0 THEN
      CALL cl_err(g_img.img01,'aim-804',0)
      RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_img09_t = g_img.img09
    LET g_img_o.*=g_img.*  #保留舊值
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t505_cl USING g_img.img01,g_img.img02,g_img.img03,g_img.img04
    FETCH t505_cl INTO g_img.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t505_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t505_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_img.*=g_img_t.*
            CALL t505_show()
            CALL cl_err('',9001,0)
            RETURN
        END IF
        UPDATE img_file SET img09 = g_img.img09,
                            img21 = g_img.img21,
                            img20 = 1             # 更新DB
            WHERE img01 = g_img_o.img01 AND img02 = g_img_o.img02 AND img03 = g_img_o.img03 AND img04 = g_img_o.img04             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
#           CALL cl_err(g_img.img01,SQLCA.sqlcode,0) #No.FUN-660156
            CALL cl_err3("upd","img_file",g_img_t.img01,"",SQLCA.sqlcode,"","",1) #No.FUN-660156 
            CONTINUE WHILE
        END IF
        LET g_errno = TIME
        LET g_msg = 'Chg No:',g_img.img01
        INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004 add azoplant,azolegal
           VALUES ('aimt505',g_user,g_today,g_errno,g_img.img01,g_msg,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
#           CALL cl_err(g_img.img01,SQLCA.sqlcode,0) #No.FUN-660156
            CALL cl_err3("ins","azo_file",g_user,g_today,SQLCA.sqlcode,"","",1) #No.FUN-660156 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t505_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
 #MOD-420449
FUNCTION t505_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("img01,img02,img03,img04",TRUE)
   END IF
END FUNCTION
 
FUNCTION t505_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("img01,img02,img03,img04",FALSE)
   END IF
END FUNCTION
#--end

#FUN-BA0056 --START--
FUNCTION t505_ins_img()   
   DEFINE l_wc      LIKE type_file.chr1000
   DEFINE g_defstk  LIKE type_file.chr1  
   DEFINE g_stk     LIKE imf_file.imf02    
   DEFINE g_loc     LIKE imf_file.imf03
   DEFINE l_cnt     LIKE type_file.num5

   LET INT_FLAG = 0
   LET p_row = 6 LET p_col = 18
   OPEN WINDOW t505_w1 AT p_row,p_col        #顯示畫面
        WITH FORM "aim/42f/aimt5051"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("aimt5051")
   
   CONSTRUCT l_wc ON ima01,ima06,ima09,ima10,ima11,ima12
                FROM ima01,ima06,ima09,ima10,ima11,ima12              
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
		
      ON ACTION qbe_select
         CALL cl_qbe_select()
         
      ON ACTION qbe_save
		 CALL cl_qbe_save()
		
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW t505_w1 RETURN
   END IF

   LET g_defstk = 'Y'   
   LET g_stk = ' '
   LET g_loc = ' '
   
   INPUT BY NAME g_defstk,g_stk,g_loc WITHOUT DEFAULTS
     BEFORE INPUT
        CALL cl_set_comp_entry("g_stk,g_loc",g_defstk = 'N')        
     AFTER FIELD g_stk
        IF g_stk IS NOT NULL AND g_stk !=' ' THEN
           SELECT COUNT(*) INTO l_cnt FROM imd_file
            WHERE imd01=g_stk  AND imdacti = 'Y'        
           IF l_cnt=0 THEN
              CALL cl_err(g_stk,'mfg1100',0)
              NEXT FIELD g_stk
           END IF  
	IF NOT s_imechk(g_stk,g_loc) THEN NEXT FIELD g_loc END IF  #FUN-D40103 add
        END IF        
     AFTER FIELD g_loc
	#FUN-D40103--mark--str--
       # IF g_loc IS NOT NULL AND g_loc !=' ' THEN
       #   SELECT COUNT(*) INTO l_cnt FROM ime_file
       #      WHERE ime01=g_stk AND ime02=g_loc
       #   IF l_cnt=0 THEN
       #      CALL cl_err(g_loc,'mfg1101',0)
       #      NEXT FIELD g_loc
       #   END IF
       #  END IF
	#FUN-D40103--mark--end--
        IF g_loc IS NULL THEN LET g_loc=' ' END IF
	 IF NOT s_imechk(g_stk,g_loc) THEN NEXT FIELD g_loc END IF   #FUN-D40103 add
        
     ON CHANGE g_defstk        
           CALL cl_set_comp_entry("g_stk,g_loc",g_defstk = 'N')   

     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(g_stk)
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_imd"
              LET g_qryparam.default1 = g_stk
              LET g_qryparam.arg1     = 'SW'        #倉庫類別 
              CALL cl_create_qry() RETURNING g_stk
              DISPLAY BY NAME g_stk
              NEXT FIELD g_stk
           WHEN INFIELD(g_loc)              
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_ime"
              LET g_qryparam.default1 = g_loc
              LET g_qryparam.arg1     = g_stk             #倉庫編號 
              LET g_qryparam.arg2     = 'SW'              #倉庫類別 
              CALL cl_create_qry() RETURNING g_loc
              DISPLAY BY NAME g_loc
              NEXT FIELD g_loc
           OTHERWISE EXIT CASE
        END CASE
        
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t505_w1
       RETURN         
   END IF

   CALL cl_wait()
   BEGIN WORK
   LET g_success='Y'  
   CALL s_showmsg_init()
   IF NOT  t505s_ins_img(l_wc,g_stk,g_loc,g_defstk) THEN
      LET g_success = 'N' 
   END IF
   CALL s_showmsg()   
   IF g_success='Y' THEN
      MESSAGE 'Insert Ok!'
      COMMIT WORK CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK CALL cl_rbmsg(1)
   END IF   
   CLOSE WINDOW t505_w1
END FUNCTION
#FUN-BA0056 --START--
 
#Patch....NO.TQC-610036 <> #

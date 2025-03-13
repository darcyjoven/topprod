# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi640.4gl
# Descriptions...: FAS 碼別資料維護作業
# Date & Author..: 96/05/31 By Roger
# Modify.........: No.MOD-470051 04/07/21 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-580322 05/09/02 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750225 07/05/28 By arman   狀態Page不可查詢 
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.TQC-8C0043 08/12/23 By clover AFTER FIELD cbb05 調整成NEXT FIELD cbb05
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AB0041 10/12/14 By lixh1  修改刪除時單頭無法顯示的BUG及SQL修改
# Modify.........: No.TQC-B30037 11/03/04 by destiny 新增时orig,oriu没显示
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    m_cbb RECORD    LIKE cbb_file.*,       #
    g_cbbcon        LIKE cbb_file.cbbcon,  #
    g_cbb01         LIKE cbb_file.cbb01,   #
    g_cbb02         LIKE cbb_file.cbb02,   #
    g_cbb03         LIKE cbb_file.cbb03,   #
    g_cbb04         LIKE cbb_file.cbb04,   #
    g_cbbcon_t      LIKE cbb_file.cbbcon,  #
    g_cbb01_t       LIKE cbb_file.cbb01,   #
    g_cbb02_t       LIKE cbb_file.cbb02,   #
    g_cbb03_t       LIKE cbb_file.cbb03,   #
    g_cbb04_t       LIKE cbb_file.cbb04,   #
    g_cbb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cbb05       LIKE cbb_file.cbb05,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021
                    END RECORD,
    g_cbb_t         RECORD                 #程式變數 (舊值)
        cbb05       LIKE cbb_file.cbb05,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021
                    END RECORD,
     g_wc,g_wc2,g_sql    string,           #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數  #No.FUN-680096 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    g_ss            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_succ          LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_argv1         LIKE cbb_file.cbbcon,
    g_argv2         LIKE cbb_file.cbb01,
    g_argv3         LIKE cbb_file.cbb02,
    g_argv4         LIKE cbb_file.cbb03,
    g_argv5         LIKE cbb_file.cbb04,
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
 
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql   STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg        LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5     #No.FUN-680096 SMALLINT
MAIN
# DEFINE                                     #No.FUN-6A0060 
#       l_time    LIKE type_file.chr8        #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
    LET g_cbbcon = NULL                     #清除鍵值
    LET g_cbb01 = NULL                     #清除鍵值
    LET g_cbb02 = NULL                     #清除鍵值
    LET g_cbb03 = NULL                     #清除鍵值
    LET g_cbbcon_t = NULL
    LET g_cbb01_t = NULL
    LET g_cbb02_t = NULL
    LET g_cbb03_t = NULL
    #取得參數
    LET g_argv1=ARG_VAL(1)	
    IF g_argv1=' ' THEN LET g_argv1='' ELSE LET g_cbbcon=g_argv1 END IF
    LET g_argv2=ARG_VAL(2)
    IF g_argv2=' ' THEN LET g_argv2='' ELSE LET g_cbb01=g_argv2 END IF
    LET g_argv3=ARG_VAL(3)
    IF g_argv3=' ' THEN LET g_argv3='' ELSE LET g_cbb03=g_argv3 END IF
 
    LET p_row = 3 LET p_col = 8
 
    OPEN WINDOW i640_w AT  p_row,p_col            #顯示畫面
         WITH FORM "abm/42f/abmi640"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) THEN CALL i640_q() END IF
    LET g_delete='N'
    CALL i640_menu()
    CLOSE WINDOW i640_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i640_cs()
    IF cl_null(g_argv1) THEN
    	CLEAR FORM                             #清除畫面
        CALL g_cbb.clear() 
        CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_cbbcon TO NULL    #No.FUN-750051
   INITIALIZE g_cbb01 TO NULL    #No.FUN-750051
   INITIALIZE g_cbb02 TO NULL    #No.FUN-750051
    	CONSTRUCT g_wc ON cbbcon,cbb01,cbb02,cbb03,cbb04,cbb05,
                          cbbacti,cbbuser,cbbgrup,cbbmodu,cbbdate    #NO.TQC-750225
        	FROM cbbcon,cbb01,cbb02,cbb03,cbb04,s_cbb[1].cbb05,
                     cbbacti,cbbuser,cbbgrup,cbbmodu,cbbdate       #NO.TQC-750225
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cbbcon)
#                    CALL q_cba(10,3,g_cbbcon) RETURNING g_cbbcon
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_cba"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO cbbcon
                     NEXT FIELD cbbcon
                WHEN INFIELD(cbb03)
#                    CALL q_ima1(3,3,'ADE',g_cbb03) RETURNING g_cbb03
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form = "q_ima1"
                 #    LET g_qryparam.state = 'c'
                 #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima1","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO cbb03
                     NEXT FIELD cbb03
                WHEN INFIELD(cbb05)
#                    CALL q_ima(10,3,g_cbb[1].cbb05) RETURNING g_cbb[1].cbb05
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form = "q_ima"
                 #    LET g_qryparam.state = 'c'
                 #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret  
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO cbb05
                     NEXT FIELD cbb05
                OTHERWISE
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
    	IF INT_FLAG THEN RETURN END IF
      ELSE
	LET g_wc=" cbbcon='",g_argv1,"'"
	IF NOT cl_null(g_argv2) THEN
	   LET g_wc=g_wc CLIPPED," AND cbb01='",g_argv2,"'"
	END IF
	IF NOT cl_null(g_argv3) THEN
	   LET g_wc=g_wc CLIPPED," AND cbb02='",g_argv3,"'"
	END IF
    END IF
    LET g_sql="SELECT DISTINCT cbbcon,cbb01,cbb02,cbb03,cbb04 FROM cbb_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY cbbcon,cbb01,cbb02,cbb03,cbb04"
    PREPARE i640_prepare FROM g_sql      #預備一下
    IF STATUS THEN CALL cl_err('prep:',STATUS,1) END IF
    DECLARE i640_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i640_prepare
    LET g_sql="SELECT DISTINCT cbbcon,cbb01,cbb02,cbb03,cbb04 ",
              "  FROM cbb_file WHERE ", g_wc CLIPPED
    PREPARE i640_precount FROM g_sql
    DECLARE i640_count CURSOR FOR i640_precount
END FUNCTION
 
 
FUNCTION i640_menu()
 
   WHILE TRUE
      CALL i640_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i640_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i640_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i640_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i640_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_cbb01 IS NOT NULL THEN
                  LET g_doc.column1 = "cbbcon"
                  LET g_doc.value1  = g_cbbcon
                  LET g_doc.column2 = "cbb01"
                  LET g_doc.value2  = g_cbb01
                  LET g_doc.column3 = "cbb02"
                  LET g_doc.value3  = g_cbb02
                  LET g_doc.column4 = "cbb03"
                  LET g_doc.value4  = g_cbb03
                  LET g_doc.column5 = "cbb04"
                  LET g_doc.value5  = g_cbb04
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cbb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i640_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_cbb.clear()
    INITIALIZE g_cbbcon LIKE cbb_file.cbbcon
    INITIALIZE g_cbb01 LIKE cbb_file.cbb01
    INITIALIZE g_cbb02 LIKE cbb_file.cbb02
    INITIALIZE g_cbb03 LIKE cbb_file.cbb03
    INITIALIZE g_cbb04 LIKE cbb_file.cbb04
    INITIALIZE m_cbb.* TO NULL
    IF NOT cl_null(g_argv1) THEN LET g_cbbcon=g_argv1
       DISPLAY g_cbbcon TO cbbcon END IF
    IF NOT cl_null(g_argv2) THEN LET g_cbb01=g_argv2
       DISPLAY g_cbb01 TO cbb01 END IF
    IF NOT cl_null(g_argv2) THEN LET g_cbb02=g_argv3
       DISPLAY g_cbb02 TO cbb02 END IF
    IF NOT cl_null(g_argv3) THEN LET g_cbb03=g_argv4
       DISPLAY g_cbb03 TO cbb03 END IF
    IF NOT cl_null(g_argv3) THEN LET g_cbb04=g_argv5
       DISPLAY g_cbb04 TO cbb04 END IF
    LET g_cbbcon_t = NULL
    LET g_cbb01_t = NULL
    LET g_cbb02_t = NULL
    LET g_cbb03_t = NULL
    LET g_cbb04_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        LET m_cbb.cbbacti='Y'
        LET m_cbb.cbbuser=g_user
        LET m_cbb.cbbgrup=g_grup
        LET m_cbb.cbbdate=g_today
        LET m_cbb.cbboriu=g_user  #TQC-B30037
        LET m_cbb.cbborig=g_grup  #TQC-B30037
        CALL i640_i("a")                   #輸入單頭
	IF INT_FLAG THEN LET INT_FLAG=0 CALL cl_err('',9001,0)EXIT WHILE END IF
        FOR g_cnt = 1 TO g_cbb.getLength()
            INITIALIZE g_cbb[g_cnt].* TO NULL
        END FOR
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i640_b()                   #輸入單身
        LET g_cbbcon_t = g_cbbcon       #保留舊值
        LET g_cbb01_t = g_cbb01         #保留舊值
        LET g_cbb02_t = g_cbb02         #保留舊值
        LET g_cbb03_t = g_cbb03         #保留舊值
        LET g_cbb04_t = g_cbb04         #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i640_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cbbcon IS NULL OR g_cbb02 IS NULL OR g_cbb03 IS NULL
    OR g_cbb04 IS NULL  THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cbbcon_t = g_cbbcon
    LET g_cbb01_t = g_cbb01
    LET g_cbb02_t = g_cbb02
    LET g_cbb03_t = g_cbb03
    LET g_cbb04_t = g_cbb04
    WHILE TRUE
        LET m_cbb.cbbuser=g_user
        LET m_cbb.cbbdate=g_today
        CALL i640_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_cbbcon=g_cbbcon_t
            LET g_cbb01=g_cbb01_t
            LET g_cbb02=g_cbb02_t
            LET g_cbb03=g_cbb03_t
            LET g_cbb04=g_cbb04_t
            DISPLAY g_cbbcon TO cbbcon     #單頭
            DISPLAY g_cbb01 TO cbb01      #單頭
            DISPLAY g_cbb02 TO cbb02      #單頭
            DISPLAY g_cbb03 TO cbb03      #單頭
            DISPLAY g_cbb04 TO cbb04      #單頭
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cbbcon != g_cbbcon_t OR g_cbb01 != g_cbb01_t OR
           g_cbb02 != g_cbb02_t OR g_cbb03 != g_cbb03_t  OR
           g_cbb04 != g_cbb04_t
        THEN #更改單頭值
             UPDATE cbb_file SET cbbcon = g_cbbcon, #更新DB
                                 cbb01 = g_cbb01,
		                 cbb02 = g_cbb02,
		                 cbb03 = g_cbb03,
		                 cbb04 = g_cbb04
                WHERE cbbcon = g_cbbcon_t
                  AND cbb01 = g_cbb01_t
	          AND cbb02 = g_cbb02_t
	          AND cbb03 = g_cbb03_t
	          AND cbb04 = g_cbb04_t
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_cbbcon CLIPPED,' + ', g_cbb01 CLIPPED,
	                   ' + ', g_cbb02 CLIPPED,' + ', g_cbb03 CLIPPED,
	                   ' + ', g_cbb04 CLIPPED
#                CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("upd","cbb_file",g_cbbcon_t,g_cbb01,SQLCA.sqlcode,"",g_msg,1) #TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i640_i(p_cmd)
DEFINE
    l_cnt      LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    p_cmd      LIKE type_file.chr1,     #a:輸入 u:更改        #No.FUN-680096 VARCHAR(1)
    l_cbb04    LIKE cbb_file.cbb04
 
    LET g_ss='Y'
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME m_cbb.*
    DISPLAY BY NAME m_cbb.cbbcon,m_cbb.cbb01,m_cbb.cbb02,m_cbb.cbb03,m_cbb.cbb04,
                    m_cbb.cbbuser,m_cbb.cbbmodu,m_cbb.cbbacti,m_cbb.cbbgrup,m_cbb.cbbdate,
                    m_cbb.cbboriu,m_cbb.cbborig,m_cbb.cbboriu,m_cbb.cbborig                  #TQC-B30037
    #No.FUN-9A0024--end 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_cbbcon,g_cbb01,g_cbb02,g_cbb03,g_cbb04
        WITHOUT DEFAULTS
        FROM cbbcon,cbb01,cbb02,cbb03,cbb04
 
 
	BEFORE FIELD cbbcon  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
        AFTER FIELD cbbcon
            IF NOT cl_null(g_cbbcon) THEN
               #FUN-AA0059 ------------------------add start-----------------------
                IF NOT s_chk_item_no(g_cbbcon,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD cbbcon
                END IF 
               #FUN-AA0059 -----------------------add end---------------------------- 
                IF i640_cbbcon2()
                   THEN
                   NEXT FIELD cbbcon
                END IF
            END IF
 
        AFTER FIELD cbb01
            IF NOT cl_null(g_cbb01) THEN
                IF g_cbb01 > 20 OR g_cbb01 < 1 THEN
                    NEXT FIELD cbb01
                END IF
                IF g_cbbcon != g_cbbcon_t OR g_cbbcon_t IS NULL THEN
                    CALL i640_cbbcon('a')
                    IF NOT cl_null(g_errno) THEN
   	               IF g_errno='mfg9116' THEN
	            	IF NOT cl_confirm(g_errno)
	            		THEN NEXT FIELD cbbcon
	            	END IF
                       ELSE
                        	CALL cl_err(g_cbbcon,g_errno,0)
                        	LET g_cbbcon = g_cbbcon_t
                        	DISPLAY g_cbbcon TO cbbcon
                        	NEXT FIELD cbbcon
	               END IF
                    END IF
                END IF
            END IF
 
       #AFTER FIELD cbb02
       #    IF NOT cl_null(g_cbb02) THEN
       #        IF g_cbb02 < 1 THEN
       #            NEXT FIELD cbb02
       #        END IF
       #    END IF
 
        AFTER FIELD cbb03
            IF NOT cl_null(g_cbb03) THEN
               #FUN-AA0059 -----------------------------add start-------------------------
                IF NOT s_chk_item_no(g_cbb03,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD cbb03
                END IF 
               #FUN-AA0059 -----------------------------add end----------------------------          
 
                IF g_cbb03 != 'ALL' THEN
                   IF i640_cbb03()
                      THEN
                      NEXT FIELD cbb03
                   END IF
                END IF
            END IF
 
        AFTER FIELD cbb04
	    IF NOT cl_null(g_cbb04) THEN
                LET g_cnt = LENGTH(g_cbb04)
#No.MOD-580322--begin
                IF g_cnt != g_cbb02 THEN
#                  ERROR '位數不符'
                   CALL cl_err('','abm-811','1')
                   NEXT FIELD cbb04
                END IF
#No.MOD-580322--end
                IF g_cbbcon != g_cbbcon_t OR
                   g_cbb01 != g_cbb01_t OR
                   g_cbb02 != g_cbb02_t OR
                   g_cbb03 != g_cbb03_t OR
                   g_cbb04 != g_cbb04_t THEN
                   SELECT count(*) INTO g_cnt FROM cbb_file
                    WHERE cbbcon = g_cbbcon AND cbb01 = g_cbb01
                      AND cbb02 = g_cbb02 AND cbb03 = g_cbb03
                      AND cbb04 = g_cbb04
                    IF g_cnt > 0 THEN   #資料重複
	                LET g_msg = g_cbbcon CLIPPED ,'+',g_cbb01 USING '&&','+',
                                    g_cbb02 USING '&&','+',g_cbb03 CLIPPED,'+',
                                    g_cbb04 CLIPPED
                        CALL cl_err(g_msg,-239,0)                      
                        LET g_cbbcon = g_cbbcon_t
                        LET g_cbb01 = g_cbb01_t
                        LET g_cbb02 = g_cbb02_t
                        LET g_cbb03 = g_cbb03_t
                        LET g_cbb04 = g_cbb04_t
                        DISPLAY  g_cbbcon TO cbbcon
                        DISPLAY  g_cbb01  TO cbb01
                        DISPLAY  g_cbb02  TO cbb02
                        DISPLAY  g_cbb03  TO cbb03
                        DISPLAY  g_cbb04  TO cbb04
                        NEXT FIELD cbbcon
                    END IF
                END IF
            END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cbbcon)
#                    CALL q_cba(10,3,g_cbbcon) RETURNING g_cbbcon
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_cba"
                     LET g_qryparam.default1 = g_cbbcon
                     CALL cl_create_qry() RETURNING g_cbbcon
                     DISPLAY BY NAME g_cbbcon
                     IF NOT cl_null(g_cbb01) THEN
                         CALL i640_cbbcon('d')
                     END IF
                     NEXT FIELD cbbcon
                WHEN INFIELD(cbb03)
#                    CALL q_ima1(3,3,'ADE',g_cbb03) RETURNING g_cbb03
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima1"
                  #   LET g_qryparam.where = " ima08 IN ('A','D') " #No:9531
                  #   LET g_qryparam.default1 = g_cbb03
                  #   CALL cl_create_qry() RETURNING g_cbb03
                     CALL q_sel_ima(FALSE, "q_ima1", " ima08 IN ('A','D') ", g_cbb03, "", "", "", "" ,"",'' )  RETURNING g_cbb03
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_cbb03
                     NEXT FIELD cbb03
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i640_q()
  DEFINE l_cbbcon LIKE cbb_file.cbbcon,
         l_cbb01  LIKE cbb_file.cbb01,
         l_cbb02  LIKE cbb_file.cbb02,
         l_cbb03  LIKE cbb_file.cbb03,
         l_cbb04  LIKE cbb_file.cbb04,
         l_cnt    LIKE type_file.num10    #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cbbcon TO NULL           #No.FUN-6A0002
    INITIALIZE g_cbb01 TO NULL            #No.FUN-6A0002
    INITIALIZE g_cbb02 TO NULL            #No.FUN-6A0002
    INITIALIZE g_cbb03 TO NULL            #No.FUN-6A0002
    INITIALIZE g_cbb04 TO NULL            #No.FUN-6A0002
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i640_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_cbbcon TO NULL
        INITIALIZE g_cbb01 TO NULL
        INITIALIZE g_cbb02 TO NULL
        INITIALIZE g_cbb03 TO NULL
        INITIALIZE g_cbb04 TO NULL
        RETURN
    END IF
    OPEN i640_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('open cursor:',SQLCA.sqlcode,0)
        INITIALIZE g_cbbcon TO NULL
        INITIALIZE g_cbb01 TO NULL
        INITIALIZE g_cbb02 TO NULL
        INITIALIZE g_cbb03 TO NULL
        INITIALIZE g_cbb04 TO NULL
    ELSE
        FOREACH i640_count INTO l_cbbcon,l_cbb01,l_cbb02,l_cbb03,l_cbb04
          LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i640_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i640_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1     #處理方式   #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i640_bcs INTO g_cbbcon,g_cbb01,g_cbb02,
                                              g_cbb03,g_cbb04
        WHEN 'P' FETCH PREVIOUS i640_bcs INTO g_cbbcon,g_cbb01,g_cbb02,
                                              g_cbb03,g_cbb04
        WHEN 'F' FETCH FIRST    i640_bcs INTO g_cbbcon,g_cbb01,g_cbb02,
                                              g_cbb03,g_cbb04
        WHEN 'L' FETCH LAST     i640_bcs INTO g_cbbcon,g_cbb01,g_cbb02,
                                              g_cbb03,g_cbb04
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i640_bcs INTO g_cbbcon,g_cbb01,g_cbb02,
                                                g_cbb03,g_cbb04
    END CASE
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_cbb01,SQLCA.sqlcode,0)
       INITIALIZE g_cbbcon TO NULL  #TQC-6B0105
       INITIALIZE g_cbb01  TO NULL  #TQC-6B0105
       INITIALIZE g_cbb02  TO NULL  #TQC-6B0105
       INITIALIZE g_cbb03  TO NULL  #TQC-6B0105
       INITIALIZE g_cbb04  TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO m_cbb.* FROM cbb_file
     WHERE cbbcon=g_cbbcon
       AND cbb01=g_cbb01
       AND cbb02=g_cbb02
       AND cbb03=g_cbb03
       AND cbb04=g_cbb04
       AND cbb05=(SELECT MIN(cbb05) FROM cbb_file
                   WHERE cbbcon=g_cbbcon
                     AND cbb01=g_cbb01
                     AND cbb02=g_cbb02
                     AND cbb03=g_cbb03
                     AND cbb04=g_cbb04)
 
    CALL i640_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i640_show()
    DEFINE l_cnt  LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    SELECT COUNT(*) INTO l_cnt FROM cbb_file
     WHERE cbbcon=g_cbbcon AND cbb01=g_cbb01
       AND cbb02=g_cbb02 AND cbb03=g_cbb03 AND cbb04=g_cbb04
    IF l_cnt=0 THEN
       LET g_cbbcon='' LET g_cbb01='' LET g_cbb02='' LET g_cbb03='' LET g_cbb04=''
       LET m_cbb.cbbcon='' LET m_cbb.cbb01 ='' LET m_cbb.cbb02 ='' LET m_cbb.cbb03 ='' LET m_cbb.cbb04 =''
    END IF
    DISPLAY g_cbbcon TO cbbcon      #單頭
    DISPLAY g_cbb01 TO cbb01        #單頭
    DISPLAY g_cbb02 TO cbb02        #單頭
    DISPLAY g_cbb03 TO cbb03        #單頭
    DISPLAY g_cbb04 TO cbb04        #單頭
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME m_cbb.*                                                                                                        
    DISPLAY BY NAME m_cbb.cbbcon,m_cbb.cbb01,m_cbb.cbb02,m_cbb.cbb03,m_cbb.cbb04,                                                   
                    m_cbb.cbbuser,m_cbb.cbbmodu,m_cbb.cbbacti,m_cbb.cbbgrup,m_cbb.cbbdate,                                          
                    m_cbb.cbboriu,m_cbb.cbborig                                                                                     
    #No.FUN-9A0024--end 
    CALL cl_set_field_pic("","","","","",m_cbb.cbbacti)
    CALL i640_bf(g_wc)                               #單身
    CALL i640_cbbcon2() RETURNING g_i
    CALL i640_cbb03() RETURNING g_i
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i640_r()
  DEFINE l_cbbcon LIKE cbb_file.cbbcon,
         l_cbb01  LIKE cbb_file.cbb01,
         l_cbb02  LIKE cbb_file.cbb02,
         l_cbb03  LIKE cbb_file.cbb03,
         l_cbb04  LIKE cbb_file.cbb04
    IF s_shut(0) THEN RETURN END IF          #檢查權限
    IF g_cbb01 IS NULL THEN
       CALL cl_err("",-400,0)                #No.FUN-6A0002
       RETURN
    END IF
    IF cl_delh(0,0) THEN                     #確認一下
        INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cbbcon"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_cbbcon      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cbb01"       #No.FUN-9B0098 10/02/24
        LET g_doc.value2  = g_cbb01       #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "cbb02"       #No.FUN-9B0098 10/02/24
        LET g_doc.value3  = g_cbb02       #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "cbb03"       #No.FUN-9B0098 10/02/24
        LET g_doc.value4  = g_cbb03       #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "cbb04"       #No.FUN-9B0098 10/02/24
        LET g_doc.value5  = g_cbb04       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                  #No.FUN-9B0098 10/02/24
        DELETE FROM cbb_file
         WHERE cbbcon = g_cbbcon AND cbb01=g_cbb01 AND cbb02=g_cbb02
           AND cbb03=g_cbb03 AND cbb04=g_cbb04
        IF SQLCA.sqlcode THEN
#            CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #No.TQC-660046
            CALL cl_err3("del","cbb_file",g_cbbcon,g_cbb01,SQLCA.sqlcode,"","BODY DELETE",1) #TQC-660046
        ELSE
            CLEAR FORM
            CALL g_cbb.clear()
            LET g_row_count = 0
            FOREACH i640_count INTO l_cbbcon,l_cbb01,l_cbb02,l_cbb03,l_cbb04
              LET g_row_count = g_row_count + 1
            END FOREACH
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i640_bcs
               CLOSE i640_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i640_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i640_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i640_fetch('/')
            END IF
            LET g_delete='Y'
            #LET g_cbbcon= NULL                       #TQC-AB0041  
            #LET g_cbb01 = NULL   LET g_cbb02 = NULL  #TQC-AB0041
            #LET g_cbb03 = NULL   LET g_cbb04 = NULL  #TQC-AB0041
            DISPLAY g_cbbcon TO cbbcon      #單頭
            DISPLAY g_cbb01 TO cbb01        #單頭
            DISPLAY g_cbb02 TO cbb02        #單頭
            DISPLAY g_cbb03 TO cbb03        #單頭
            DISPLAY g_cbb04 TO cbb04        #單頭
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION
 
FUNCTION i640_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_cbb01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT cbb05 ",
      " FROM cbb_file ",
      "   WHERE cbbcon= ? ",
      "   AND cbb01=  ? ",
      "   AND cbb02=  ? ",
      "   AND cbb03=  ? ",
      "   AND cbb04=  ? ",
      "   AND cbb05=  ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i640_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_cbb
              WITHOUT DEFAULTS
              FROM s_cbb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_cbb_t.* = g_cbb[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
 
                OPEN i640_bcl USING g_cbbcon,g_cbb01,g_cbb02,g_cbb03,g_cbb04,g_cbb_t.cbb05
                IF STATUS THEN
                    CALL cl_err("OPEN i640_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i640_bcl INTO g_cbb[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_cbb_t.cbb05,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                        EXIT INPUT
                    END IF
                    SELECT ima02,ima021 INTO g_cbb[l_ac].ima02,g_cbb[l_ac].ima021
                      FROM ima_file WHERE ima01=g_cbb[l_ac].cbb05
                    CALL i640_cbb05('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD cbb05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO cbb_file
              (cbbcon,cbb01, cbb02, cbb03, cbb04,cbb05,cbbacti,
               cbbuser,cbbgrup,cbbmodu,cbbdate,cbboriu,cbborig)
            VALUES(g_cbbcon,g_cbb01,g_cbb02,g_cbb03,g_cbb04,
                   g_cbb[l_ac].cbb05,'Y',g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
 #               CALL cl_err(g_cbb[l_ac].cbb05,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","cbb_file",g_cbbcon,g_cbb01,SQLCA.sqlcode,"","",1) #TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cbb[l_ac].* TO NULL      #900423
            LET g_cbb_t.* = g_cbb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cbb05
 
        AFTER FIELD cbb05                        #check 序號是否重複
            #FUN-AA0059 -------------------------------add start-------------------------
            IF NOT cl_null(g_cbb[l_ac].cbb05) THEN
               IF NOT s_chk_item_no(g_cbb[l_ac].cbb05,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_cbb[l_ac].cbb05 = g_cbb_t.cbb05
                   NEXT FIELD cbb05
                END IF
            END IF 
            #FUN-AA0059 -------------------------------add end----------------------------- 
            IF g_cbb[l_ac].cbb05 != g_cbb_t.cbb05 OR
               g_cbb_t.cbb05 IS NULL THEN
                SELECT count(*) INTO l_n FROM cbb_file
                    WHERE cbbcon = g_cbbcon
                      AND cbb01 = g_cbb01
                      AND cbb02 = g_cbb02
                      AND cbb03 = g_cbb03
                      AND cbb04 = g_cbb04
                      AND cbb05 = g_cbb[l_ac].cbb05
                IF l_n > 0 THEN
                    CALL cl_err(g_cbb[l_ac].cbb05,-239,0)
                    LET g_cbb[l_ac].cbb05 = g_cbb_t.cbb05
                    NEXT FIELD cbb05
                END IF
            END IF
            IF NOT cl_null(g_cbb[l_ac].cbb05) THEN
                IF g_cbb[l_ac].cbb05 != 'ALL' THEN
                   SELECT ima02,ima021 INTO g_cbb[l_ac].ima02,g_cbb[l_ac].ima021
                     FROM ima_file
                    WHERE ima01=g_cbb[l_ac].cbb05
                   IF STATUS THEN
  #                    CALL cl_err('sel ima:',STATUS,0)  #No.TQC-660046
                       CALL cl_err3("sel","ima_file",g_cbb[l_ac].cbb05,"",STATUS,"","sel ima:",1) #TQC-660046
                       NEXT FIELD cbb05   #TQC-8C0043
                  END IF
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
               IF NOT cl_null(g_cbb_t.cbb05) THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM cbb_file
                    WHERE cbbcon = g_cbbcon
                      AND cbb01  = g_cbb01
                      AND cbb02  = g_cbb02
                      AND cbb03  = g_cbb03
                      AND cbb04  = g_cbb04
                      AND cbb05  = g_cbb_t.cbb05
                IF SQLCA.sqlcode THEN
 #                   CALL cl_err(g_cbb_t.cbb05,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","cbb_file",g_cbbcon,g_cbb01,SQLCA.sqlcode,"","",1) #TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cbb[l_ac].* = g_cbb_t.*
               CLOSE i640_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_cbb[l_ac].cbb05,-263,1)
                LET g_cbb[l_ac].* = g_cbb_t.*
            ELSE
                UPDATE cbb_file SET
                       cbb05 = g_cbb[l_ac].cbb05,
                       cbbmodu = g_user,
                       cbbdate = g_today
                 WHERE cbbcon=g_cbbcon
                   AND cbb01=g_cbb01
                   AND cbb02=g_cbb02
                   AND cbb03=g_cbb03
                   AND cbb04=g_cbb04
                   AND cbb05=g_cbb_t.cbb05
                IF SQLCA.sqlcode THEN
  #                  CALL cl_err(g_cbb[l_ac].cbb05,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","cbb_file",g_cbbcon,g_cbb01,SQLCA.sqlcode,"","",1) #TQC-660046
                    LET g_cbb[l_ac].* = g_cbb_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
	            COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_cbb[l_ac].* = g_cbb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_cbb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i640_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_cbb_t.* = g_cbb[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i640_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i640_b_askkey()
      #     EXIT INPUT
 
#       ON ACTION CONTROLO                        #沿用所有欄位
#           IF INFIELD(cbb05) AND l_ac > 1 THEN
#               LET g_cbb[l_ac].* = g_cbb[l_ac-1].*
#               NEXT FIELD cbb05
#           END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cbb05)
#                   CALL q_ima(10,3,g_cbb[l_ac].cbb05) RETURNING g_cbb[l_ac].cbb05
#                   CALL FGL_DIALOG_SETBUFFER( g_cbb[l_ac].cbb05 )
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = g_cbb[l_ac].cbb05
                 #   CALL cl_create_qry() RETURNING g_cbb[l_ac].cbb05
                     CALL q_sel_ima(FALSE, "q_ima", "", g_cbb[l_ac].cbb05, "", "", "", "" ,"",'' )  RETURNING g_cbb[l_ac].cbb05
#FUN-AA0059 --End--
#                    CALL FGL_DIALOG_SETBUFFER( g_cbb[l_ac].cbb05 )
                    DISPLAY g_cbb[l_ac].cbb05 TO cbb05
                    NEXT FIELD cbb05
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
        END INPUT
 
    #FUN-5B0043-begin
    UPDATE cbb_file SET cbbmodu = g_user,cbbdate = g_today
     WHERE cbb01 = g_cbb01
    DISPLAY g_user,g_today TO cbbmodu,cbbdate
    #FUN-5B0043-end
 
 
    CLOSE i640_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION i640_b_askkey()
DEFINE
    l_wc     LIKE type_file.chr1000      #No.FUN-680096 VARCHAR(300)
 
    CONSTRUCT l_wc ON cbb05                        #螢幕上取條件
       FROM s_cbb[1].cbb05
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
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond('cbbuser', 'cbbgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i640_bf(l_wc)
END FUNCTION
 
FUNCTION i640_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc      LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(300)
 
    LET g_sql =
       "SELECT cbb05,ima02,ima021",
     # " FROM cbb_file, OUTER ima_file",             #TQC-AB0041
       " FROM cbb_file LEFT OUTER JOIN ima_file",    #TQC-AB0041
       "   ON cbb_file.cbb05 = ima_file.ima01",      #TQC-AB0041
       " WHERE cbbcon= '",g_cbbcon,"' AND cbb01 = '",g_cbb01,"'",
       "   AND cbb02 = '",g_cbb02,"'",
       "   AND cbb03 = '",g_cbb03,"'",
       "   AND cbb04 = '",g_cbb04,"'",
     # "   AND cbb_file.cbb05 = ima_file.ima01",     #TQC-AB0041
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i640_prepare2 FROM g_sql      #預備一下
    DECLARE cbb_cs CURSOR FOR i640_prepare2
    CALL g_cbb.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH cbb_cs INTO g_cbb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_cbb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i640_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cbb TO s_cbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i640_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i640_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i640_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i640_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i640_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
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
         CALL cl_set_field_pic("","","","","",m_cbb.cbbacti)
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i640_cbbcon(p_cmd)
	 DEFINE    p_cmd      LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
                   l_cbanum   LIKE type_file.num5,     #No.FUN-680096 SMALLINT
                   l_cbaacti  like cba_file.cbaacti
	
	 LET g_errno = " "
         LET g_sql = " SELECT cba",g_cbb01 USING '&&'," FROM cba_file",
                     "  WHERE cbacon = '",g_cbbcon,"' "
 
         PREPARE i640_precbbcon   FROM g_sql
         DECLARE i640_cbbcon CURSOR FOR i640_precbbcon
         FOREACH i640_cbbcon INTO l_cbanum END FOREACH
 
	   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                          LET l_cbanum  = NULL
                                          LET l_cbaacti = NULL
		 WHEN l_cbaacti='N' LET g_errno = '9028'
		 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	   END CASE
	   IF p_cmd = 'a' THEN LET g_cbb02 = l_cbanum END IF
	   DISPLAY g_cbb02 TO cbb02
END FUNCTION
 
FUNCTION i640_cbb05(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
         l_ima02    LIKE ima_file.ima02,
         l_ima021   LIKE ima_file.ima021,
         l_imaacti  like ima_file.imaacti
 
     IF g_cbb[l_ac].cbb05 ='ALL' THEN RETURN END IF
     LET g_errno = " "
     SELECT ima02,ima021,imaacti FROM ima_file WHERE ima01 = g_cbb[l_ac].cbb05
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                      LET l_ima02  = NULL
                                      LET l_imaacti = NULL
            WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
            WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
 
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
END FUNCTION
 
FUNCTION i640_cbbcon2()
DEFINE l_ima02  LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021
 
  IF g_cbbcon='ALL' THEN DISPLAY '' TO ima02_1 RETURN 0 END IF
  SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
   WHERE ima01=g_cbbcon
     AND ima08='C'
  IF STATUS
     THEN
  #   CALL cl_err(g_cbbcon,'abm-735',0) #No.TQC-660046
     CALL cl_err3("sel","ima_file",g_cbbcon,"","abm-735","","",1) #TQC-660046
     RETURN -1
  ELSE
     DISPLAY l_ima02,l_ima021 TO FORMONLY.ima02_1,FORMONLY.ima021_1
  END IF
  RETURN 0
END FUNCTION
 
FUNCTION i640_cbb03()
DEFINE l_ima02  LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021
 
  IF g_cbb03='ALL' THEN DISPLAY '' TO ima02_2 RETURN 0 END IF
  SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
   WHERE ima01=g_cbb03
     AND ima08 IN ('A','D') #No:9531
  IF STATUS
     THEN
 #    CALL cl_err(g_cbb03,'abm-736',0) #No.TQC-660046
     CALL cl_err3("sel","ima_file",g_cbb03,"","abm-736","","",1) #TQC-660046
     RETURN -1
  ELSE
     DISPLAY l_ima02  TO FORMONLY.ima02_2
     DISPLAY l_ima021 TO FORMONLY.ima021_2
  END IF
{
  SELECT COUNT(*) INTO g_i FROM bmb_file
   WHERE bmb01=g_cbbcon
     AND bmb03=g_cbb03
  IF g_i=0
     THEN
     CALL cl_err(g_cbb03,'abm-737',0)
     RETURN -1
  END IF
 
}
  RETURN 0
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #

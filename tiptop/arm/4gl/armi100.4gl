# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armi100.4gl
# Descriptions...: RMA# 登記作業
# Modify         : 98/02/02 By patricia
# Modify         : 98/03/28 By plum
# Modify.........: No:8714 04/06/20 By Ching input err修改
# MOdify.........: No.MOD-490488 04/10/04 By Yuna 人員輸入可帶出部門,修改卻沒帶出來
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550064 05/05/26 By Trisy 單據編號加大
# Modify.........: NO.FUN-560014 05/06/08 By jackie 單據編號修改
# Modify.........: NO.MOD-570317 05/07/25 By Yiting 客訴已作廢不應輸入
# Modify.........: NO.MOD-5B0334 05/11/29 By kim 查詢時,開窗資料帶錯,不應該帶"單別"
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.MOD-640103 06/04/07 By vivien 修改rma22，rma03的欄位檢查
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810132 08/01/25 By claire 取消時,確認rmc_file是否有存在資料
# Modify.........: No.MOD-840184 08/04/20 By jamie RMA由客訴單轉入時,未確認的客訴單應不能抓入.應等客訴單確認後才可轉入RMA.
# Modify.........: No.FUN-840068 08/04/23 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-930013 09/03/03 By chenyu 取消時，說明應該根據語言別顯示不同的語言
# Modify.........: No.MOD-950060 09/05/08 By Smapmin 修改抓取幣別/匯率的邏輯
#                                                    預設覆出日期
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970028 11/05/22 By wuxj 新增客戶編號rma23
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.TQC-C20503 12/02/27 By destiny oriu,orig不能查询
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_rma        RECORD LIKE rma_file.*,
    g_rma_t      RECORD LIKE rma_file.*,
    g_buf        LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20)
     g_wc,g_sql   string,  #No.FUN-580092 HCN
    g_gen02      LIKE gen_file.gen02,
    g_gem02      LIKE gem_file.gem02,
    g_disp       LIKE type_file.chr6     #No.FUN-690010 VARCHAR(06)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1	        LIKE rma_file.rma01    #No.FUN-690010 VARCHAR(16)            #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
MAIN
    DEFINE
#       l_time        LIKE type_file.chr8              #No.FUN-6A0085
        p_row,p_col     LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
   LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
   LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
 
    INITIALIZE g_rma.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM rma_file WHERE rma01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 13
    OPEN WINDOW i100_w AT p_row,p_col
         WITH FORM "arm/42f/armi100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #No.FUN-4A0081 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i100_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i100_a()
             END IF
          OTHERWISE 
                CALL i100_q()
       END CASE
    END IF
    #No.FUN-4A0081 ---end---
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i100_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i100_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION i100_curs()
    CLEAR FORM
  IF cl_null(g_argv1) THEN   #FUN-4A0081
   INITIALIZE g_rma.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        rma01,rma09,rma22,rma03,rma04,rma05,rma23,rma08,rma02,rma06,rma13,rma14,  #FUN-970028 add rma23
        rmauser,rmagrup,rmamodu,rmadate, 
        rmaoriu,rmaorig,       #TQC-C20503
        #FUN-840068   ---start---
        rmaud01,rmaud02,rmaud03,rmaud04,rmaud05,
        rmaud06,rmaud07,rmaud08,rmaud09,rmaud10,
        rmaud11,rmaud12,rmaud13,rmaud14,rmaud15
        #FUN-840068    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP                        # 沿用所有欄位
           CASE
             WHEN INFIELD(rma01)
               #MOD-5B0334...............begin
              #LET g_t1 = g_rma.rma01[1,3]
#              #CALL q_oay2(10,3,g_t1,'*',g_sys) RETURNING g_rma.rma01
              #CALL q_oay2(TRUE,FALSE,g_t1,'*',g_sys)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rma4"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = ''
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rma01
              #DISPLAY BY NAME g_rma.rma01
               #MOD-5B0334...............end
               NEXT FIELD rma01
             WHEN INFIELD(rma03)
#              CALL q_occ(0,0,g_rma.rma03) RETURNING g_rma.rma03
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = g_rma.rma03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rma03
               NEXT FIELD rma03
             WHEN INFIELD(rma13)
#              CALL q_gen(0,0,g_rma.rma13) RETURNING g_rma.rma13
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = g_rma.rma13
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rma13
               NEXT FIELD rma13
             WHEN INFIELD(rma14)
#              CALL q_gem(0,0,g_rma.rma14) RETURNING g_rma.rma14
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = g_rma.rma14
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rma14
               NEXT FIELD rma14
             WHEN INFIELD(rma22)
#              CALL q_ohc(0,0,g_rma.rma22) RETURNING g_rma.rma22
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ohc"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = g_rma.rma22
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rma22
               NEXT FIELD rma22
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
  #FUN-4A0081
  ELSE
      LET g_wc =" rma01 = '",g_argv1,"'"    #No.FUN-4A0081
  END IF
  #--
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
    #End:FUN-980030
 
 
    LET g_sql="SELECT rma01 FROM rma_file  ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY rma01"
    PREPARE i100_prepare FROM g_sql           # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('i100_pre',STATUS,1) RETURN END IF
    DECLARE i100_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM rma_file WHERE ",g_wc CLIPPED
    PREPARE i100_precount FROM g_sql
    DECLARE i100_count CURSOR FOR i100_precount
END FUNCTION
 
FUNCTION i100_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i100_a()
           END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i100_q()
           END IF
        ON ACTION next
           CALL i100_fetch('N')
        ON ACTION previous
           CALL i100_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i100_u()
           END IF
        ON ACTION cancellation
           CALL i100_f('Y')
        ON ACTION activate
           CALL i100_f('N')
        ON ACTION query_c_com_no                       #NO:7140
           LET g_action_choice="query_c_com_no"
           IF cl_chk_act_auth() AND NOT cl_null(g_rma.rma22) THEN
              LET g_msg = "axmt710 '",g_rma.rma22,"' "
              #CALL cl_cmdrun(g_msg CLIPPED)      #FUN-660216 remark
              CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
           END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL i100_fetch('/')
        ON ACTION first
           CALL i100_fetch('F')
        ON ACTION last
           CALL i100_fetch('L')
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No.FUN-6A0018-------add--------str----
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_rma.rma01 IS NOT NULL THEN
                LET g_doc.column1 = "rma01"
                LET g_doc.value1 = g_rma.rma01
                CALL cl_doc()
             END IF
         END IF
      #No.FUN-6A0018-------add--------end---- 

        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      #No.FUN-7C0050 add

      &include "qry_string.4gl"
    END MENU
    CLOSE i100_cs
END FUNCTION
 
FUNCTION i100_a()
DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
DEFINE l_oaz52 LIKE oaz_file.oaz52
DEFINE l_chr   LIKE type_file.chr6    #No.FUN-690010 VARCHAR(06)
DEFINE l_sql   LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(100)
DEFINE l_flag  LIKE type_file.chr1   #MOD-950060
 
    MESSAGE ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_rma.*  LIKE rma_file.*
    LET g_rma_t.* = g_rma.*    #FUN-B50026 add
    LET g_rma.rma02=g_today                      #將登記日期設為系統日期
    LET g_rma.rma06=g_today                      #將登記日期設為系統日期
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_rma.rmauser = g_user
        LET g_rma.rmaoriu = g_user #FUN-980030
        LET g_rma.rmaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_rma.rmagrup = g_grup               #使用者所屬群
        LET g_rma.rmadate = g_today
        LET g_rma.rmarecv = "N"                  #確認碼
        LET g_rma.rmaconf = "N"                  #確認碼
        LET g_rma.rmavoid = "Y"                  #有效碼
#       LET g_rma.rma01[1,3] = g_rmz.rmz05
        LET g_rma.rma01[1,g_doc_len] = g_rmz.rmz05            #No.FUN-560014
        LET g_rma.rma08='1'
        LET g_rma.rma09=' '
        CALL i100_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN      # 若按了DEL鍵
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_rma.rma01 IS NULL THEN CONTINUE WHILE END IF
#       LET g_t1 = g_rma.rma01[1,3]
        LET g_t1 = s_get_doc_no(g_rma.rma01)     #No.FUN-550064
 
        SELECT * INTO g_oay.* FROM oay_file WHERE oayslip = g_t1
        BEGIN WORK  #No:7876
      #No.FUN-550064 --start--
        CALL s_auto_assign_no("ARM",g_rma.rma01,g_rma.rma02,"70","rma_file","rma01","","","")
        RETURNING li_result,g_rma.rma01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rma.rma01
 
#       IF g_oay.oayauno='Y' THEN
#          CALL s_armauno(g_rma.rma01,g_rma.rma02) RETURNING g_i,g_rma.rma01
#          IF g_i THEN CONTINUE WHILE END IF
#          DISPLAY BY NAME g_rma.rma01
#       END IF
      #No.FUN-550064 ---end---
        #-----MOD-950060---------
        ##NO:7140 Default幣別/匯率
        #SELECT occ631 INTO g_rma.rma16 FROM occ_file WHERE occ01=g_rma.rma03  #幣別DEFAULT
        #IF g_rma.rma08 = '1' THEN   #1.內銷 2.外銷
        #   SELECT oaz52 INTO l_oaz52 FROM oaz_file
        #ELSE
        #   SELECT oaz70 INTO l_oaz52 FROM oaz_file
        #END IF
        #IF NOT cl_null(g_rma.rma16) AND NOT cl_null(l_oaz52) THEN
        #   CASE WHEN l_oaz52='B'
        #             LET l_chr='azk03'
        #        WHEN l_oaz52='S'
        #             LET l_chr='azk04'
        #        WHEN l_oaz52='C'
        #             LET l_chr='azk051'
        #        WHEN l_oaz52='D'
        #             LET l_chr='azk052'
        #        WHEN l_oaz52='T'
        #             LET l_chr='azk05'
        #   END CASE
        #   LET l_sql=" SELECT ",l_chr," FROM azk_file ",
        #             " WHERE azk01 ='",g_rma.rma16,"'",
        #             "   AND azk02 ='",g_rma.rma02,"'"
        #   PREPARE azk_ex from l_sql
        #   EXECUTE azk_ex INTO g_rma.rma17
        #   IF SQLCA.SQLCODE THEN
        #       LET g_rma.rma17=0
        #   END IF
        #   IF cl_null(g_rma.rma17) THEN
        #       LET g_rma.rma17=0
        #   END IF
        #END IF
        ##NO:7140
        SELECT occ42 INTO g_rma.rma16 FROM occ_file WHERE occ01=g_rma.rma03 
        CALL s_curr3(g_rma.rma16,g_rma.rma02,g_rmz.rmz15) RETURNING g_rma.rma17
        LET g_rma.rma12 = g_rma.rma06 + g_rmz.rmz20  
        IF NOT cl_null(g_rma.rma12) THEN
            CALL s_wkday(g_rma.rma12)  RETURNING l_flag,g_rma.rma12
        END IF
        #-----END MOD-950060-----
 
        LET g_rma.rmaplant = g_plant #FUN-980007
        LET g_rma.rmalegal = g_legal #FUN-980007
        INSERT INTO rma_file VALUES(g_rma.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
  #         CALL cl_err('Add:',SQLCA.sqlcode,0)  # FUN-660111
          CALL cl_err3("ins","rma_file",g_rma.rma01,"",SQLCA.sqlcode,"","Add:",1) # FUN-660111
           ROLLBACK WORK  #No:7876
           EXIT  WHILE
        ELSE
           COMMIT WORK    #No:7876
           CALL cl_flow_notify(g_rma.rma01,'I')
        END IF
 
        LET g_rma_t.* = g_rma.*                # 保存上筆資料
        SELECT rma01 INTO g_rma.rma01 FROM rma_file WHERE rma01 = g_rma.rma01
 
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
FUNCTION i100_i(p_cmd)
    DEFINE   li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
    DEFINE p_cmd   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
           l_n     LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    INPUT BY NAME g_rma.rmaoriu,g_rma.rmaorig,
        g_rma.rma01,g_rma.rma22,g_rma.rma03,g_rma.rma04,g_rma.rma05,g_rma.rma23,    #FUN-970028 add rma23
        g_rma.rma08,g_rma.rma02, g_rma.rma06,g_rma.rma13,g_rma.rma14,
        g_rma.rmauser,g_rma.rmagrup,g_rma.rmamodu,g_rma.rmadate,
        #FUN-840068     ---start---
        g_rma.rmaud01,g_rma.rmaud02,g_rma.rmaud03,g_rma.rmaud04,
        g_rma.rmaud05,g_rma.rmaud06,g_rma.rmaud07,g_rma.rmaud08,
        g_rma.rmaud09,g_rma.rmaud10,g_rma.rmaud11,g_rma.rmaud12,
        g_rma.rmaud13,g_rma.rmaud14,g_rma.rmaud15 
        #FUN-840068     ----end----
        WITHOUT DEFAULTS       #NO:7140 add rma22,rma08
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rma01")
         CALL cl_set_docno_format("rma22")
         #No.FUN-550064 ---end---
 
        AFTER FIELD rma01
         #No.FUN-550064 --start--
            IF NOT cl_null(g_rma.rma01) THEN
           #CALL s_check_no("ARM",g_rma.rma01,"","70","","","")
            CALL s_check_no("ARM",g_rma.rma01,g_rma_t.rma01,"70","","","")  #FUN-B50026 mod
            RETURNING li_result,g_rma.rma01
            DISPLAY BY NAME g_rma.rma01
            IF (NOT li_result) THEN
               LET g_rma.rma01=g_rma_t.rma01
               NEXT FIELD rma01
            END IF
            DISPLAY BY NAME g_rma.rma01
 
#           IF NOT cl_null(g_rma.rma01) THEN
#              LET g_t1 = g_rma.rma01[1,3]
#              SELECT * INTO g_oay.* FROM oay_file WHERE oayslip = g_t1
#              IF STATUS THEN
#                 CALL cl_err('sel oay',STATUS,0) NEXT FIELD rma01
#              END IF
#              #--NO:6842
#              CALL s_axmslip(g_t1,'70',g_sys)  # 單別,單據性質(user權限)
#              IF NOT cl_null(g_errno) THEN
#                  CALL cl_err(g_t1,g_errno,0)
#                  NEXT FIELD rma01
#              END IF
#              #--NO:6842
#             #No.+298 010628 by plum
#             #IF g_oay.oaytype != '70' AND g_oay.oaytype != '60' THEN
#              IF g_oay.oaytype != '70' THEN
#             #No.+298...end
#                 CALL cl_err(g_rma.rma01,'mfg0015',0) NEXT FIELD rma01
#              END IF
#              IF p_cmd = 'a' AND
#                 cl_null(g_rma.rma01[5,10]) AND g_oay.oayauno = 'N' THEN
#                 NEXT FIELD rma01
#              END IF
#              IF p_cmd = 'a' OR
#                (p_cmd = 'u' AND g_rma.rma01 != g_rma_t.rma01) THEN
#                 IF g_oay.oayauno = 'Y' AND
#                    NOT cl_chk_data_continue(g_rma.rma01[5,10]) THEN
#                    CALL cl_err('','9056',0) NEXT FIELD rma01
#                 END IF
#                 SELECT COUNT(*) INTO l_n FROM rma_file
#                  WHERE rma01 = g_rma.rma01
#                 IF l_n > 0 THEN                  # Duplicated
#                    CALL cl_err(g_rma.rma01,-239,0)
#                    LET g_rma.rma01 = g_rma_t.rma01
#                    DISPLAY BY NAME g_rma.rma01
#                    NEXT FIELD rma01
#                 END IF
#              END IF
 
         #No.FUN-550064 ---end---
           END IF
 
     AFTER FIELD rma22
         #TQC-640103 --begin
         IF cl_null(g_rma.rma22[1,3]) THEN 
            LET g_rma.rma22=NULL
         END IF
         #TQC-640103 --end  
         IF NOT cl_null(g_rma.rma22) THEN
            IF p_cmd='a' OR
              (p_cmd='u' AND g_rma.rma22 <> g_rma_t.rma22) THEN
                #NO:7140
                SELECT COUNT(*) INTO l_n FROM ohc_file
                 WHERE ohc01=g_rma.rma22
                    AND ohcconf <> 'X'  #MOD-570317
                    AND ohcconf <> 'N'  #MOD-840184 add
                IF l_n<=0 THEN
                    CALL cl_err('','arm-004',0) NEXT FIELD rma22
                END IF
                #NO:7140
                CALL i100_ohc()
            END IF
         END IF
 
      BEFORE FIELD rma03
         CALL i100_set_entry(p_cmd)
 
      AFTER FIELD rma03
         IF NOT cl_null(g_rma.rma22) AND NOT cl_null(g_rma.rma03) THEN  #NO:7140
            SELECT COUNT(*) INTO l_n FROM ohc_file
             WHERE ohc01=g_rma.rma22
               AND ohc06=g_rma.rma03
                AND ohcconf <> 'X'  #MOD-570317
            IF l_n=0 THEN            #資料不合
               CALL cl_err(g_rma.rma03,'arm-524',1)
               NEXT FIELD rma03
            END IF
         END IF
         IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rma.rma03 != g_rma_t.rma03) THEN
            IF g_rma.rma03[1,4] != 'MISC' AND cl_null(g_rma.rma22) THEN  #No.8714
               SELECT occ02,occ04,occ11
                 INTO g_rma.rma04,g_rma.rma13,g_rma.rma05
                 FROM occ_file WHERE occ01=g_rma.rma03 AND occacti='Y'
               IF STATUS THEN
    #              CALL cl_err('sel occ',STATUS,0)   # FUN-660111
                  CALL cl_err3("sel","occ_file",g_rma.rma03,"",STATUS,"","sel occ",1) # FUN-660111
                 NEXT FIELD rma03  
               END IF
               LET g_gen02=' ' LET g_gem02=' '
               IF g_rma.rma13 IS NULL OR g_rma.rma13=' ' THEN
                  LET g_rma.rma13=g_rma_t.rma13
                  CALL i100_cust()
               ELSE
                  SELECT gen03 INTO g_rma.rma14 FROM gen_file
                         WHERE gen01 = g_rma.rma13
                  CALL i100_cust()
               END IF
               DISPLAY BY NAME g_rma.rma04,g_rma.rma05,g_rma.rma13,g_rma.rma14
            END IF
         END IF
         CALL i100_set_no_entry(p_cmd)
 
     AFTER FIELD rma05
         IF NOT cl_null(g_rma.rma05) THEN
            IF g_aza.aza21 = 'Y' AND cl_numchk(g_rma.rma05,8) THEN
               IF NOT s_chkban(g_rma.rma05) THEN
                  CALL cl_err('chkban-rma05:','aoo-080',0) NEXT FIELD rma05
               END IF
            END IF
         END IF
 
     AFTER FIELD rma08
         IF g_rma.rma08 NOT MATCHES '[12]' THEN NEXT FIELD rma08 END IF
 
     AFTER FIELD rma13
         IF NOT cl_null(g_rma.rma13) THEN
            # No.MOD-490488
           # IF cl_null(g_rma.rma14) THEN #No.8714
               SELECT gen03 INTO g_rma.rma14 FROM gen_file
                WHERE gen01 = g_rma.rma13
               IF STATUS THEN
 #                 CALL cl_err('sel gen',STATUS,0) # FUN-660111
             CALL cl_err3("sel","gen_file",g_rma.rma13,"",STATUS,"","sel gen",1) # FUN-660111
                      NEXT FIELD rma13                 
               END IF
               DISPLAY BY NAME g_rma.rma14
           # END IF
            CALL i100_cust()
         END IF
 
     AFTER FIELD rma14
         IF NOT cl_null(g_rma.rma14) THEN
            SELECT gem02 INTO g_gem02 FROM gem_file
             WHERE gem01 = g_rma.rma14 AND gemacti='Y'   #NO:6950
            IF STATUS THEN
 #              CALL cl_err('sel gem',STATUS,0)   # FUN-660111
               CALL cl_err3("sel","gem_file",g_rma.rma14,"",STATUS,"","sel gem",1) # FUN-660111 
                 NEXT FIELD rma14
            END IF
            DISPLAY g_gem02 TO gem02
         END IF
 
     AFTER FIELD rma06
         IF g_rma.rma06 < g_rma.rma02 THEN
            CALL cl_err('','arm-028',0) NEXT FIELD rma06
         END IF
 
     #FUN-840068     ---start---
     AFTER FIELD rmaud01
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud02
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud03
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud04
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud05
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud06
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud07
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud08
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud09
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud10
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud11
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud12
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud13
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud14
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud15
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     #FUN-840068     ----end----
 
     ON ACTION CONTROLP                        # 沿用所有欄位
          CASE
            WHEN INFIELD(rma01)
#             LET g_t1 = g_rma.rma01[1,3]
              LET g_t1 = s_get_doc_no(g_rma.rma01)     #No.FUN-550064
#             CALL q_oay2(10,3,g_t1,'*',g_sys) RETURNING g_rma.rma01
              #CALL q_oay2(FALSE,FALSE,g_t1,'*',g_sys) RETURNING g_rma.rma01  #TQC-670008
              CALL q_oay2(FALSE,FALSE,g_t1,'*','ARM') RETURNING g_rma.rma01   #TQC-670008
#              CALL FGL_DIALOG_SETBUFFER( g_rma.rma01 )
              DISPLAY BY NAME g_rma.rma01
              NEXT FIELD rma01
            WHEN INFIELD(rma03)
#             CALL q_occ(0,0,g_rma.rma03) RETURNING g_rma.rma03
#             CALL FGL_DIALOG_SETBUFFER( g_rma.rma03 )
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.default1 = g_rma.rma03
              CALL cl_create_qry() RETURNING g_rma.rma03
#              CALL FGL_DIALOG_SETBUFFER( g_rma.rma03 )
              DISPLAY BY NAME g_rma.rma03
              NEXT FIELD rma03
            WHEN INFIELD(rma13)
#             CALL q_gen(0,0,g_rma.rma13) RETURNING g_rma.rma13
#             CALL FGL_DIALOG_SETBUFFER( g_rma.rma13 )
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_rma.rma13
              CALL cl_create_qry() RETURNING g_rma.rma13
#              CALL FGL_DIALOG_SETBUFFER( g_rma.rma13 )
              DISPLAY BY NAME g_rma.rma13
               #No.MOD-490488
               SELECT gen03 INTO g_rma.rma14 FROM gen_file
                WHERE gen01 = g_rma.rma13
               DISPLAY BY NAME g_rma.rma14
              #--END--
              NEXT FIELD rma13
            WHEN INFIELD(rma14)
#             CALL q_gem(0,0,g_rma.rma14) RETURNING g_rma.rma14
#             CALL FGL_DIALOG_SETBUFFER( g_rma.rma14 )
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.default1 = g_rma.rma14
              CALL cl_create_qry() RETURNING g_rma.rma14
#              CALL FGL_DIALOG_SETBUFFER( g_rma.rma14 )
              DISPLAY BY NAME g_rma.rma14
              NEXT FIELD rma14
            WHEN INFIELD(rma22)
#             CALL q_ohc(0,0,g_rma.rma22) RETURNING g_rma.rma22
#             CALL FGL_DIALOG_SETBUFFER( g_rma.rma22 )
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ohc"
              LET g_qryparam.default1 = g_rma.rma22
              CALL cl_create_qry() RETURNING g_rma.rma22
#              CALL FGL_DIALOG_SETBUFFER( g_rma.rma22 )
              DISPLAY BY NAME g_rma.rma22
              NEXT FIELD rma22
          END CASE
 
         ON ACTION CONTROLF     # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
END FUNCTION
 
FUNCTION i100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rma.* TO NULL                #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i100_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i100_count
    FETCH i100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)
       INITIALIZE g_rma.* TO NULL
    ELSE
       CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i100_fetch(p_flrma)
    DEFINE   p_flrma           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
    DEFINE   l_abso            LIKE type_file.num10   #No.FUN-690010 INTEGER
 
    CASE p_flrma
        WHEN 'N' FETCH NEXT     i100_cs INTO g_rma.rma01
        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_rma.rma01
        WHEN 'F' FETCH FIRST    i100_cs INTO g_rma.rma01
        WHEN 'L' FETCH LAST     i100_cs INTO g_rma.rma01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i100_cs INTO g_rma.rma01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)
        INITIALIZE g_rma.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flrma
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_rma.* FROM rma_file            # 重讀DB,因TEMP有不被更新特性
       WHERE rma01 = g_rma.rma01
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)   # FUN-660111
        CALL cl_err3("sel","rma_file",g_rma.rma01,"",SQLCA.sqlcode,"","",1) # FUN-660111
    ELSE
        LET g_data_owner = g_rma.rmauser #FUN-4C0055
        LET g_data_group = g_rma.rmagrup #FUN-4C0055
        LET g_data_plant = g_rma.rmaplant #FUN-980030
        CALL i100_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i100_cust()
    LET g_gen02 = ' ' LET g_gem02=' '
    SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_rma.rma13
    SELECT gem02 INTO g_gem02 FROM gem_file WHERE gem01=g_rma.rma14
    DISPLAY g_gen02,g_gem02 TO gen02,gem02
END FUNCTION
 
FUNCTION i100_ohc()
    SELECT ohc06,ohc061,occ11,oga08,oga14,oga15
      INTO g_rma.rma03,g_rma.rma04,g_rma.rma05,
           g_rma.rma08,g_rma.rma13,g_rma.rma14
      FROM ohc_file LEFT JOIN occ_file ON ohc06=occ_file.occ01 LEFT JOIN oga_file ON ohc04=oga_file.oga01 
     WHERE ohc01=g_rma.rma22
        AND ohcconf <> 'X'  #MOD-570317
        AND ohcconf <> 'N'  #MOD-840184 add
    IF SQLCA.sqlcode THEN
#        CALL cl_err('ohc_file',SQLCA.sqlcode,0)  # FUN-660111	
        CALL cl_err3("sel","ohc_file",g_rma.rma22,"",SQLCA.sqlcode,"","ohc_file",1) # FUN-660111
        LET g_rma.rma03=NULL
        LET g_rma.rma04=NULL
        LET g_rma.rma05=NULL
        LET g_rma.rma08=NULL
        LET g_rma.rma13=NULL
        LET g_rma.rma14=NULL
        RETURN
    ELSE
      DISPLAY BY NAME g_rma.rma03,g_rma.rma04,g_rma.rma05,
                      g_rma.rma08,g_rma.rma13,g_rma.rma14
      CALL i100_cust()
    END IF
END FUNCTION
 
FUNCTION i100_show()
 
    LET g_rma_t.* = g_rma.*
    DISPLAY BY NAME g_rma.rma01,g_rma.rma22,g_rma.rma09,g_rma.rma03,g_rma.rma04,g_rma.rma05,g_rma.rma23, g_rma.rmaoriu,g_rma.rmaorig, #FUN-970028 add rma23
                    g_rma.rma02,g_rma.rma13,g_rma.rma14,g_rma.rma06,g_rma.rma08,
                    g_rma.rmauser,g_rma.rmagrup,g_rma.rmamodu,g_rma.rmadate,
                    #FUN-840068     ---start---
                    g_rma.rmaud01,g_rma.rmaud02,g_rma.rmaud03,g_rma.rmaud04,
                    g_rma.rmaud05,g_rma.rmaud06,g_rma.rmaud07,g_rma.rmaud08,
                    g_rma.rmaud09,g_rma.rmaud10,g_rma.rmaud11,g_rma.rmaud12,
                    g_rma.rmaud13,g_rma.rmaud14,g_rma.rmaud15 
                    #FUN-840068     ----end----
    CALL i100_cust()
    IF g_rma.rma09="6" THEN 
      #LET g_disp="Cancel"                     #No.TQC-930013 mark
       LET g_disp=cl_getmsg('arm-046',g_lang)  #No.TQC-930013 add
    ELSE 
       LET g_disp="   " 
    END IF
    DISPLAY g_disp TO FORMONLY.disp
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_u()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01=g_rma.rma01
    IF g_rma.rma01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_rma.rma09="6" THEN CALL cl_err('','arm-018',0) RETURN END IF
    IF g_rma.rmaconf='Y' THEN CALL cl_err('','aap-019',1) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rma_t.* = g_rma.*
    BEGIN WORK
    OPEN i100_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_rma.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)
       RETURN
    END IF
    LET g_rma.rmamodu= g_user                 #修改者
    LET g_rma.rmadate= g_today                #修改日期
    CALL i100_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i100_i("u")                          # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rma.*=g_rma_t.*
            CALL i100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE rma_file SET rma_file.* = g_rma.*    # 更新DB
            WHERE rma01=g_rma_t.rma01             # COLAUTH?
        IF SQLCA.sqlcode THEN
  #          CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)   #FUN-660111
            CALL cl_err3("upd","rma_file",g_rma_t.rma01,"",SQLCA.sqlcode,"","",1) # FUN-660111
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i100_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rma.rma01,'U')
 
END FUNCTION
 
FUNCTION i100_f(p_cmd)
  DEFINE g_i    LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
  IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
  SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
  IF g_rma.rmaconf='Y' THEN CALL cl_err('','aap-019',1) RETURN END IF
  IF p_cmd='Y' THEN
     IF g_rma.rma09="6" THEN CALL cl_err(g_rma.rma01,'arm-018',0) RETURN END IF
  ELSE
     IF cl_null(g_rma.rma09) THEN CALL cl_err(g_rma.rma01,'arm-026',0)
        RETURN END IF
  END IF
 
  #MOD-810132-begin-add
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM rmc_file
    WHERE rmc21 <> 0
      AND rmc01 = g_rma.rma01
   IF g_cnt > 0 THEN
      CALL cl_err(g_rma.rma01,'arm-170',1)
      RETURN
   END IF
  #MOD-810132-end-add
 
  IF cl_cont(0,0) THEN
     IF p_cmd='Y' THEN
        LET g_rma.rma09='6'                       #No.TQC-930013 add
        LET g_disp=cl_getmsg('arm-046',g_lang)    #No.TQC-930013 add 
        UPDATE rma_file SET rma09='6' WHERE rma01=g_rma.rma01
       #LET g_rma.rma09='6' LET g_disp="Cancel"   #No.TQC-930013 mark
     ELSE
        UPDATE rma_file SET rma09=' ' WHERE rma01=g_rma.rma01
        LET g_rma.rma09=' ' LET g_disp=" "
     END IF
     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err('',9051,1) RETURN
     END IF
     DISPLAY BY NAME g_rma.rma09
     DISPLAY g_disp TO FORMONLY.disp
     IF p_cmd='Y' THEN
        LET g_msg=cl_getmsg('arm-018',g_lang)
     ELSE
        LET g_msg=cl_getmsg('arm-026',g_lang)
     END IF
     CALL cl_msgany(0,0,g_msg)
  END IF
 
END FUNCTION
 
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rma01",TRUE)
   END IF
   IF INFIELD(rma03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rma04,rma05",TRUE)
   END IF
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rma01",FALSE)
   END IF
   IF INFIELD(rma03) OR (NOT g_before_input_done) THEN
      IF g_rma.rma03[1,4] != 'MISC' THEN
         CALL cl_set_comp_entry("rma04,rma05",FALSE)
      END IF
   END IF
END FUNCTION
 
 

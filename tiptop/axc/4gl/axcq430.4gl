# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcq430.4gl
# Descriptions...: 每月工單元件在製成本維護作業
# Date & Author..: 96/01/31 By Roger
# Modify.........: No.MOD-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/07 By douzh   成本改善增加cch06(成本計算類別),cch07(類別編號)和各種制費
# Modify.........: No.CHI-980066 09/08/25 By mike 用單頭的工單號碼與元件編號去select sfa的相關欄位display到畫面上對應的欄位         
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-970003 09/12/01 By jan 批次成本改善
# Modify.........: No.FUN-A70136 10/07/29 By destiny 平行工艺
# Modify.........: No.MOD-C80160 12/10/10 By yinhy 查詢時增加cch06，cch07條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1             LIKE cch_file.cch01,           #No.FUN-680122 VARCHAR(16),   #No.FUN-550025
    g_argv2             LIKE type_file.num5,           #No.FUN-680122 SMALLINT,
    g_argv3             LIKE type_file.num5,           #No.FUN-680122 SMALLINT,
    g_argv4             LIKE cch_file.cch06,           #No.FUN-7C0101
   #g_argv5             LIKE cch_file.cch07,           #No.FUN-7C0101 #TQC-970003 mark
    g_sfb38             LIKE sfb_file.sfb38,
    g_cch               RECORD LIKE cch_file.*,
    g_cch_t             RECORD LIKE cch_file.*,
    g_cch01_t           LIKE cch_file.cch01,
    g_cch02_t           LIKE cch_file.cch02,
    g_cch03_t           LIKE cch_file.cch03,
    g_cch04_t           LIKE cch_file.cch04,
    g_wc,g_sql          string,    #No.FUN-580092 HCN
    g_ima               RECORD LIKE ima_file.*,
    g_ccg               RECORD LIKE ccg_file.*
 
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72) 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0146
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)  #No.FUN-7C0101
   #LET g_argv5 = ARG_VAL(5)  #No.FUN-7C0101  #TQC-970003
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cch.* TO NULL
    INITIALIZE g_cch_t.* TO NULL
#   DECLARE t420_cl CURSOR FOR              # LOCK CURSOR
#       SELECT * FROM cch_file
#       WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03 AND cch04=g_cch.cch04
#       FOR UPDATE
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t420_w AT p_row,p_col
         WITH FORM "axc/42f/axcq430"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) THEN CALL t420_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t420_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t420_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t420_cs()
    CLEAR FORM
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " cch01='", g_argv1, "' AND ",
                  " cch02=", g_argv2, " AND cch03=",g_argv3
                 ," AND cch06='",g_argv4,"' "   #TQC-970003
#                ," AND cch06='",g_argv4,"' AND cch07='",g_argv5,"' " #No.FUN-7C0101 #TQC-970003
    ELSE
   INITIALIZE g_cch.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          ccg04, cch01, cch02, cch03,
          cch04, cch05, cch06, cch07,               #No.FUN-7C0101  add cch06,cch07
          cch51, cch52a, cch52b, cch52c, cch52d, cch52e, cch52f, cch52g, cch52h, cch52,  #No.FUN-7C0101
          cch55, cch56a, cch56b, cch56c, cch56d, cch56e, cch56f, cch56g, cch56h, cch56,  #No.FUN-7C0101
          cch53, cch54a, cch54b, cch54c, cch54d, cch54e, cch54f, cch54g, cch54h, cch54,  #No.FUN-7C0101
          cch57, cch58a, cch58b, cch58c, cch58d, cch58e, cch58f, cch58g, cch58h, cch58   #No.FUN-7C0101
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      #MOD-530850
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ccg04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_ccg.ccg04
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ccg04
            NEXT FIELD ccg04
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
    LET g_sql="SELECT cch01,cch02,cch03,cch04,cch06,cch07",     #No.FUN-7C0101
              "  FROM cch_file,ccg_file ",
              " WHERE ",g_wc CLIPPED,
              "   AND cch01=ccg01 AND cch02=ccg02 AND cch03=ccg03",
             #"   AND cch06=ccg06 AND cch07=ccg07",                 #No.FUN-7C0101 ADD #TQC-970003
              "   AND cch06=ccg06 ",                                #TQC-970003
            #  " ORDER BY ccg04,cch01,cch02,cch03,cch04"            #No.FUN-7C0101
             #" ORDER BY ccg04,cch01,cch02,cch03,cch04,cch06,cch07" #No.FUN-7C0101 #TQC-970003
              " ORDER BY ccg04,cch01,cch02,cch03,cch04,cch06" #No.FUN-7C0101 #TQC-970003
    PREPARE t420_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t420_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t420_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cch_file,ccg_file WHERE ",g_wc CLIPPED,
        "   AND cch01=ccg01 AND cch02=ccg02 AND cch03=ccg03",
      #,"   AND cch06=ccg06 AND cch07=ccg07"                 #No.FUN-7C0101#TQC-970003
        "   AND cch06=ccg06 "                  #TQC-970003
    PREPARE t420_precount FROM g_sql
    DECLARE t420_count CURSOR FOR t420_precount
END FUNCTION
 
FUNCTION t420_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t420_q()
            END IF
        ON ACTION next
            CALL t420_fetch('N')
        ON ACTION previous
            CALL t420_fetch('P')
        ON ACTION help
                     CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t420_fetch('/')
        ON ACTION first
            CALL t420_fetch('F')
        ON ACTION last
            CALL t420_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t420_cs
END FUNCTION
 
 
FUNCTION g_cch_zero()
	LET g_cch.cch51=0
	LET g_cch.cch52=0
	LET g_cch.cch52a=0
	LET g_cch.cch52b=0
	LET g_cch.cch52c=0
	LET g_cch.cch52d=0
	LET g_cch.cch52e=0
	LET g_cch.cch52f=0        #No.FUN-7C0101
	LET g_cch.cch52g=0        #No.FUN-7C0101
	LET g_cch.cch52h=0        #No.FUN-7C0101
	LET g_cch.cch55=0
	LET g_cch.cch56=0
	LET g_cch.cch56a=0
	LET g_cch.cch56b=0
	LET g_cch.cch56c=0
	LET g_cch.cch56d=0
	LET g_cch.cch56e=0
	LET g_cch.cch56f=0        #No.FUN-7C0101
	LET g_cch.cch56g=0        #No.FUN-7C0101
	LET g_cch.cch56h=0        #No.FUN-7C0101
	LET g_cch.cch53=0
	LET g_cch.cch54=0
	LET g_cch.cch54a=0
	LET g_cch.cch54b=0
	LET g_cch.cch54c=0
	LET g_cch.cch54d=0
	LET g_cch.cch54e=0
	LET g_cch.cch54f=0        #No.FUN-7C0101
	LET g_cch.cch54g=0        #No.FUN-7C0101
	LET g_cch.cch54h=0        #No.FUN-7C0101
	LET g_cch.cch57=0         
	LET g_cch.cch58=0
	LET g_cch.cch58a=0
	LET g_cch.cch58b=0
	LET g_cch.cch58c=0
	LET g_cch.cch58d=0
	LET g_cch.cch58e=0
	LET g_cch.cch58f=0        #No.FUN-7C0101
	LET g_cch.cch58g=0        #No.FUN-7C0101 
	LET g_cch.cch58h=0        #No.FUN-7C0101
END FUNCTION
 
FUNCTION t420_i(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
            l_flag   LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
            l_n      LIKE type_file.num5           #No.FUN-680122 SMALLINT
 
 
   INPUT BY NAME
      g_cch.cch01, g_cch.cch02, g_cch.cch03, g_cch.cch04, g_cch.cch05,
      g_cch.cch06, g_cch.cch07,                                   #No.FUN-7C0101
      g_cch.cch51, g_cch.cch52a,g_cch.cch52b,g_cch.cch52c,
      g_cch.cch52d,g_cch.cch52e,g_cch.cch52f,g_cch.cch52g,        #No.FUN-7C0101
      g_cch.cch52h,g_cch.cch52,                                   #No.FUN-7C0101
      g_cch.cch55, g_cch.cch56a,g_cch.cch56b,g_cch.cch56c,        
      g_cch.cch56d,g_cch.cch56e,g_cch.cch56f,                     #No.FUN-7C0101 
      g_cch.cch56g,g_cch.cch56h,g_cch.cch56,                      #No.FUN-7C0101
      g_cch.cch53, g_cch.cch54a,g_cch.cch54b,g_cch.cch54c,
      g_cch.cch54d,g_cch.cch54e,g_cch.cch54f,                     #No.FUN-7C0101
      g_cch.cch54g,g_cch.cch54h,g_cch.cch54,                      #No.FUN-7C0101
      g_cch.cch57, g_cch.cch58a,g_cch.cch58b,g_cch.cch58c,
      g_cch.cch58d,g_cch.cch58e,g_cch.cch58f,                     #No.FUN-7C0101
      g_cch.cch58g,g_cch.cch58h,g_cch.cch58                       #No.FUN-7C0101
      WITHOUT DEFAULTS
 
      BEFORE FIELD cch01,cch04
         IF g_chkey='N' and p_cmd='u' THEN
            NEXT FIELD cch05
         END IF
 
      AFTER FIELD cch01
         IF g_cch.cch01 IS NULL THEN
            NEXT FIELD cch01
         END IF
         SELECT * INTO g_ccg.* FROM ccg_file
          WHERE ccg01=g_cch.cch01 AND ccg02=g_cch.cch02 AND ccg03=g_cch.cch03
         IF STATUS THEN
#           CALL cl_err('sel ccg:',STATUS,0)    #No.FUN-660127
            CALL cl_err3("sel","ccg_file",g_cch.cch01,"g_cch.cch02",STATUS,"","sel ccg",0)   #No.FUN-660127
            NEXT FIELD cch01
         END IF
         DISPLAY BY NAME g_ccg.ccg04
         INITIALIZE g_ima.* TO NULL
         SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccg.ccg04
         DISPLAY BY NAME g_ima.ima02,g_ima.ima25
         SELECT sfb38 INTO g_sfb38 FROM sfb_file
          WHERE sfb01=g_cch.cch01
         DISPLAY g_sfb38 TO sfb38
 
#      AFTER FIELD cch02
# genero  script marked
#        IF cl_ku() THEN
#           NEXT FIELD PREVIOUS
#        END IF
#        IF g_cch.cch02 IS NULL THEN
#           NEXT FIELD cch02
#        END IF
 
      AFTER FIELD cch03
# genero  script marked
#        IF cl_ku() THEN
#           NEXT FIELD PREVIOUS
#        END IF
#        IF g_cch.cch03 IS NULL THEN
#           NEXT FIELD cch03
#        END IF
         SELECT ccg01 FROM ccg_file
          WHERE ccg01 = g_cch.cch01 AND ccg02 = g_cch.cch02
            AND ccg03 = g_cch.cch03
         IF STATUS THEN
#           CALL cl_err('sel ccg:',STATUS,0)    #No.FUN-660127
            CALL cl_err3("sel","ccg_file",g_cch.cch01,g_cch.cch02,STATUS,"","sel ccg:",0)   #No.FUN-660127
            NEXT FIELD cch03
         END IF
 
      AFTER FIELD cch04
# genero  script marked
#        IF cl_ku() THEN
#           NEXT FIELD PREVIOUS
#        END IF
#        IF g_cch.cch04 IS NULL THEN
#           NEXT FIELD cch04
#        END IF
         IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
            (p_cmd = "u" AND
            (g_cch.cch01 != g_cch01_t OR g_cch.cch01 != g_cch01_t OR
            g_cch.cch03 != g_cch03_t OR g_cch.cch04 != g_cch04_t)) THEN
            SELECT count(*) INTO l_n FROM cch_file
             WHERE cch01 = g_cch.cch01 AND cch02 = g_cch.cch02
               AND cch03 = g_cch.cch03 AND cch04 = g_cch.cch04
            IF l_n > 0 THEN                  # Duplicated
               CALL cl_err('count:',-239,0)
               NEXT FIELD cch01
            END IF
         END IF
         SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cch.cch04
         IF STATUS THEN
#           CALL cl_err('sel ccg:',STATUS,0)    #No.FUN-660127
            CALL cl_err3("sel","ima_file",g_cch.cch04,"",STATUS,"","sel ccg:",0)   #No.FUN-660127
            NEXT FIELD cch04
         END IF
         DISPLAY g_ima.ima02,g_ima.ima25 TO ima02b,ima25b
         LET g_cch.cch05 = g_ima.ima08
         DISPLAY BY NAME g_cch.cch05
         CALL q430_cch04() #CHI-980066  
      AFTER FIELD
         cch51,cch52a,cch52b,cch52c,cch52d,cch52e,cch52f,cch52g,cch52h,cch52,         #No.FUN-7C0101
         cch55,cch56a,cch56b,cch56c,cch56d,cch56e,cch56f,cch56g,cch56h,cch56,         #No.FUN-7C0101
         cch53,cch54a,cch54b,cch54c,cch54d,cch54e,cch54f,cch54g,cch54h,cch54,         #No.FUN-7C0101
         cch57,cch58a,cch58b,cch58c,cch58d,cch58e,cch58f,cch58g,cch58h,cch58          #No.FUN-7C0101
         CALL t420_u_cost()
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD cch01
         END IF
      #MOD-650015 --start
       ON ACTION CONTROLO                        # 沿用所有欄位
          IF INFIELD(cch01) THEN
             LET g_cch.* = g_cch_t.*
             #No.FUN-9A0024--begin 
             #ISPLAY BY NAME g_cch.*
             DISPLAY BY NAME g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch05,
                             g_cch.cch06,g_cch.cch07,g_cch.cch51,g_cch.cch52a,g_cch.cch52b,
                             g_cch.cch52c,g_cch.cch52d,g_cch.cch52e,g_cch.cch52f,g_cch.cch52g,
                             g_cch.cch52h,g_cch.cch52,g_cch.cch55,g_cch.cch56a,g_cch.cch56b,
                             g_cch.cch56c,g_cch.cch56d,g_cch.cch56e,g_cch.cch56f,g_cch.cch56g,
                             g_cch.cch56h,g_cch.cch56,g_cch.cch53,g_cch.cch54a,g_cch.cch54b, 
                             g_cch.cch54c,g_cch.cch54d,g_cch.cch54e,g_cch.cch54f,g_cch.cch54g,
                             g_cch.cch54h,g_cch.cch54,g_cch.cch57,g_cch.cch58a,g_cch.cch58b, 
                             g_cch.cch58c,g_cch.cch58d,g_cch.cch58e,g_cch.cch58f,g_cch.cch58g, 
                             g_cch.cch58h,g_cch.cch58    
             #No.FUN-9A0024--end                                  
             NEXT FIELD cch01
          END IF
      #MOD-650015 --end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON KEY(F1)
         NEXT FIELD cch51
      ON KEY(F2)
         NEXT FIELD cch55
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
FUNCTION t420_u_cost()
    LET g_cch.cch52=g_cch.cch52a+g_cch.cch52b+g_cch.cch52c+g_cch.cch52d                     
                                +g_cch.cch52e+g_cch.cch52f+g_cch.cch52g+g_cch.cch52h         #No.FUN-7C0101
    LET g_cch.cch56=g_cch.cch56a+g_cch.cch56b+g_cch.cch56c+g_cch.cch56d
                                +g_cch.cch56e+g_cch.cch56f+g_cch.cch56g+g_cch.cch56h         #No.FUN-7C0101 
    LET g_cch.cch54=g_cch.cch54a+g_cch.cch54b+g_cch.cch54c+g_cch.cch54d
                                +g_cch.cch54e+g_cch.cch54f+g_cch.cch54g+g_cch.cch54h         #No.FUN-7C0101
    LET g_cch.cch58=g_cch.cch58a+g_cch.cch58b+g_cch.cch58c+g_cch.cch58d 
                                +g_cch.cch58e+g_cch.cch58f+g_cch.cch58g+g_cch.cch58h         #No.FUN-7C0101  
    CALL t420_show_2()
END FUNCTION
 
FUNCTION t420_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t420_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t420_count
    FETCH t420_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t420_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t420_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cch.* TO NULL
    ELSE
        CALL t420_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t420_fetch(p_flcch)
    DEFINE
        p_flcch         LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
        l_abso          LIKE type_file.num10           #No.FUN-680122 INTEGER
 
    CASE p_flcch
        WHEN 'N' FETCH NEXT     t420_cs INTO g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch06,g_cch.cch07  #MOD-C80160
        WHEN 'P' FETCH PREVIOUS t420_cs INTO g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch06,g_cch.cch07  #MOD-C80160
        WHEN 'F' FETCH FIRST    t420_cs INTO g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch06,g_cch.cch07  #MOD-C80160
        WHEN 'L' FETCH LAST     t420_cs INTO g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch06,g_cch.cch07  #MOD-C80160
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso t420_cs INTO g_cch.cch01,g_cch.cch02,g_cch.cch03,g_cch.cch04,g_cch.cch06,g_cch.cch07  #MOD-C80160
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cch.cch01,SQLCA.sqlcode,0)
        INITIALIZE g_cch.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcch
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cch.* FROM cch_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03 AND cch04=g_cch.cch04
         AND cch06=g_cch.cch06 AND cch07=g_cch.cch07  #MOD-C80160
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cch.cch01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","cch_file",g_cch.cch01,g_cch.cch02,SQLCA.sqlcode,"","",0)   #No.FUN-660127
    ELSE
 
        CALL t420_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t420_show()
    DEFINE mccg	RECORD LIKE ccg_file.*
    DEFINE l_ima02,l_ima25	LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(30)
    DEFINE l_ima57		LIKE type_file.num5             #No.FUN-680122 SMALLINT
    INITIALIZE mccg.* TO NULL
    SELECT * INTO mccg.* FROM ccg_file
          WHERE ccg01=g_cch.cch01 AND ccg02=g_cch.cch02 AND ccg03=g_cch.cch03
    DISPLAY BY NAME mccg.ccg04
    LET g_cch_t.* = g_cch.*
    DISPLAY BY NAME
        g_cch.cch01, g_cch.cch02, g_cch.cch03, g_cch.cch04, g_cch.cch05,
        g_cch.cch06, g_cch.cch07  #FUN-7C0101
    LET l_ima02=NULL LET l_ima25=NULL
    SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57
      FROM ima_file WHERE ima01 = mccg.ccg04
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02,ima25,ima57
    LET l_ima02=NULL LET l_ima25=NULL
    SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57
      FROM ima_file WHERE ima01=g_cch.cch04
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02b,ima25b,ima57b
    CALL q430_cch04() #CHI-980066     
    SELECT sfb38 INTO g_sfb38 FROM sfb_file
     WHERE sfb01=g_cch.cch01
    DISPLAY g_sfb38 TO sfb38
    CALL t420_show_2()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#CHI-980066   ---start                                                                                                              
FUNCTION q430_cch04()                                                                                                               
DEFINE l_sfa26  LIKE sfa_file.sfa26                                                                                                 
DEFINE l_sfa27  LIKE sfa_file.sfa27                                                                                                 
DEFINE l_sfa28  LIKE sfa_file.sfa28                                                                                                 
DEFINE l_sfa16  LIKE sfa_file.sfa16                                                                                                 
DEFINE l_sfa161 LIKE sfa_file.sfa161        
   #No.FUN-A70136--begin                                                                                        
   #SELECT sfa26,sfa27,sfa28,sfa16,sfa161                                                                                            
   #  INTO l_sfa26,l_sfa27,l_sfa28,l_sfa16,l_sfa161                                                                                  
   #  FROM sfa_file                                                                                                                  
   # WHERE sfa01=g_cch.cch01                                                                                                         
   #   AND sfa03=g_cch.cch04    
   DECLARE q430_sfa CURSOR FOR
    SELECT sfa26,sfa27,sfa28,sfa16,sfa161                                                                          
      FROM sfa_file                                                                                                                  
    WHERE sfa01=g_cch.cch01                                                                                                         
      AND sfa03=g_cch.cch04   
   FOREACH q430_sfa INTO l_sfa26,l_sfa27,l_sfa28,l_sfa16,l_sfa161 
      EXIT FOREACH 
   END FOREACH 
   #No.FUN-A70136--end                                                                                                       
   DISPLAY l_sfa26,l_sfa27,l_sfa28,l_sfa16,l_sfa161 TO sfa26,sfa27,sfa28,sfa16,sfa161                                               
END FUNCTION                                                                                                                        
#CHI-980066   ---end  
 
FUNCTION t420_show_2()
    DEFINE cch52u,cch56u,cch54u,cch58u	LIKE type_file.num20_6        #No.FUN-680122 DEC(20,6)   #FUN-4C0005
    DISPLAY By NAME
        g_cch.cch51, g_cch.cch52a, g_cch.cch52b, g_cch.cch52c,
        g_cch.cch52d, g_cch.cch52e, g_cch.cch52f,                     #No.FUN-7C0101 
        g_cch.cch52g, g_cch.cch52h, g_cch.cch52,                      #No.FUN-7C0101
        g_cch.cch55, g_cch.cch56a, g_cch.cch56b, g_cch.cch56c,
        g_cch.cch56d, g_cch.cch56e, g_cch.cch56f,                     #No.FUN-7C0101 
        g_cch.cch56g, g_cch.cch56h, g_cch.cch56,                      #No.FUN-7C0101
        g_cch.cch53, g_cch.cch54a, g_cch.cch54b, g_cch.cch54c,
        g_cch.cch54d, g_cch.cch54e, g_cch.cch54f,                     #No.FUN-7C0101
        g_cch.cch54g, g_cch.cch54h, g_cch.cch54,                      #No.FUN-7C0101 
        g_cch.cch57, g_cch.cch58a, g_cch.cch58b, g_cch.cch58c,
        g_cch.cch58d, g_cch.cch58e, g_cch.cch58f,                     #No.FUN-7C0101
        g_cch.cch58g, g_cch.cch58h, g_cch.cch58                       #No.FUN-7C0101
    LET cch52u=0 LET cch56u=0 LET cch54u=0 LET cch58u=0
    IF g_cch.cch51 <> 0 THEN LET cch52u=g_cch.cch52/g_cch.cch51 END IF
    IF g_cch.cch55 <> 0 THEN LET cch56u=g_cch.cch56/g_cch.cch55 END IF
    IF g_cch.cch53 <> 0 THEN LET cch54u=g_cch.cch54/g_cch.cch53 END IF
    IF g_cch.cch57 <> 0 THEN LET cch58u=g_cch.cch58/g_cch.cch57 END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    DISPLAY BY NAME cch52u,cch56u,cch54u,cch58u
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

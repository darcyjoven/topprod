# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: anmt300.4gl
# Descriptions...: 銀行存提資料建立作業
# Date & Author..: 92/05/11 By Jones
#                : By Lynn 參考單號(nme12)應可做CONSTRUCT
# :1,$s/nme/xxx/g
# :1,$s/anm/xxx/g
# :1,$s/t300/xxxx/g
# search % to modify
# Modify.........: No.MOD-4A0252 04/10/20 By Smapmin 修改開窗功能
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0098 05/01/12 By pengu 報表轉XML
# Modify.........: No.MOD-590130 05/10/07 BY Smapmin 列印時,印原幣金額但卻依本幣取位
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/21 By Jackho 兩套帳修改
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/21 By johnray 報表修改
# Modify.........: No.MOD-710065 07/01/10 By Smapmin mark nmz41/nmz42
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/22 By Rayven 新增nme21,nme22
# Modify.........: No.FUN-730070 07/04/03 By Rayven 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940084 09/03/07 By lilingyu 若銀行日期與會計日期不同年/月份時,調節碼不可為NULL
# Modify.........: No:TQC-950038 09/05/07 By Sarah 修正MOD-940084
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A30062 10/04/13 By Carrier  1.参考单号+查询 2.各说明字段加名称显示 
# Modify.........: No.MOD-AB0175 10/11/18 By Dido 調整時更新條件應用舊值為條件 
# Modify.........: No.FUN-B40056 11/04/28 By guoch 設置現金變動嗎
# Modify.........: No.FUN-B50159 11/05/30 By lutingting 拿掉對帳功能 
# Modify.........: No.FUN-B50090 11/06/01 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.TQC-B80112 11/08/12 By lixia 對帳單已審核后做調整時銀行日期和會計日期不可修改
# Modify.........: No.FUN-B90062 11/09/07 By wujie 现金变动码维护改为sub程序 
# Modify.........: No.TQC-BB0024 11/11/14 By Carrier 台湾版时开启'對帳'功能

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C60038 12/06/04 By lujh gnmq600細項查詢不勾選時，點帳單明細查詢沒有值
# Modify.........: No:TQC-C60071 12/06/06 By lujh 現金變動碼來源=1:票據資金時隱藏nme14欄位
# Modify.........: No:TQC-C60058 12/06/21 By lujh 不點擊設置現金變動碼時，也要根據參數的設置對現金變動碼tic06進行管控
# Modify.........: No:MOD-C90038 12/09/20 By Elise 取消 AFTER FIELD nme02 aap-176 檢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nme        RECORD LIKE nme_file.*,
       g_nme_t      RECORD LIKE nme_file.*,       #程式變數舊值
       g_nme_o      RECORD LIKE nme_file.*,
       g_nma        RECORD LIKE nma_file.*,
       g_nmc03_o           LIKE nmc_file.nmc03,   #原存提別
       g_nmc03             LIKE nmc_file.nmc03,   #新存提別
       g_nme00_t           LIKE nme_file.nme00,   #電腦編號舊值   #TQC-950038 add
       g_nme01_t           LIKE nme_file.nme01,   #銀行編號舊值
       g_nme02_t           LIKE nme_file.nme02,   #存提日期舊值
       g_nme03_t           LIKE nme_file.nme03,   #異動碼舊值     #TQC-950038 add
       g_nme12_t           LIKE nme_file.nme12,   #參考單號舊值   #TQC-950038 add
       g_nme21_t           LIKE nme_file.nme21,   #參考項次舊值   #TQC-950038 add
       g_nmc02             LIKE nmc_file.nmc02,   #異動碼名稱
       g_bdate,g_edate     LIKE type_file.dat,    #No.FUN-680107 DATE
       g_dbs_gl            LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
       g_plant_gl          LIKE type_file.chr10,  #No.FUN-980025 VARCHAR(10)
       g_argv1             LIKE nme_file.nme12,
       g_argv2             LIKE nme_file.nme18,
       g_argv3             LIKE nme_file.nme12,   #TQC-C60038
       g_wc,g_sql          STRING,                #TQC-630166
       g_buf               LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(40)
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-680107 SMALLINT

MAIN
#   DEFINE l_time          LIKE type_file.chr8    #No.FUN-6A0082
    DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
    INITIALIZE g_nme.* TO NULL
    INITIALIZE g_nme_t.* TO NULL
    INITIALIZE g_nme_o.* TO NULL
    #SELECT MIN(azn01) INTO g_bdate FROM azn_file   #MOD-710065
    # WHERE azn02 = g_nmz.nmz41 AND azn04 = g_nmz.nmz42   #MOD-710065
    LET g_plant_new = g_nmz.nmz02p
    LET g_plant_gl  = g_nmz.nmz02p    #No.FUN-980025
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new

   #str TQC-950038 mod
   #LET g_forupd_sql = "SELECT * FROM nme_file WHERE rowid = ? FOR UPDATE"
    LET g_forupd_sql = "SELECT * FROM nme_file",
                       " WHERE nme00 = ? AND nme01 = ? AND nme02 = ? ",
                       "   AND nme03 = ? AND nme12 = ? AND nme21 = ? ",
                       "   FOR UPDATE"
   #end TQC-950038 mod
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    LET g_argv1  = ARG_VAL(1)
    LET g_argv2  = ARG_VAL(2)
    LET g_argv3  = ARG_VAL(3)    #TQC-C60038   add  

    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t300_w AT p_row,p_col
        WITH FORM "anm/42f/anmt300"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
#No.FUN-680034--begin
    CALL cl_set_comp_visible("nme061",g_aza.aza63='Y')                            
    CALL cl_set_comp_visible("b",g_aza.aza63='Y')                              
#No.FUN-680034--end

    #TQC-C60071--add--str--
    IF g_nmz.nmz71 = 'Y' THEN 
       IF g_nmz.nmz70 = '1' THEN 
          CALL cl_set_comp_visible("nme14,nml02",FALSE)
       END IF 
    END IF 
    #TQC-C60071--add--end--
 
    IF not cl_null(g_argv1) THEN CALL t300_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t300_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t300_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t300_cs()
    CLEAR FORM
    IF not cl_null(g_argv1) THEN
       #TQC-C60038--add--str--
       IF g_argv3 = 'N' THEN  
          LET g_wc = " nme01 ='",g_argv1,"' AND nme22 = '24'" 
       ELSE 
       #TQC-C60038--add--end--
          LET g_wc = " nme12 ='",g_argv1,"'"
       END IF    #TQC-C60038  add
       IF not cl_null(g_argv2) THEN
          LET g_wc = g_wc clipped," AND nme18 ='",g_argv2,"'"
       END IF
    ELSE
       INITIALIZE g_nme.* TO NULL      #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           nme12,nme21,nme22,nme18,nme17,nme15,nme03,nme13,nme06,nme061,  #No.FUN-680034 add nme061  #No.FUN-730032 add nme21,nme22
           nme11,nme01,nme07,nme04,nme08,nme05,
           nme02,nme16,nme14,nme09,nme20,
           #FUN-850038   ---start---
           nmeud01,nmeud02,nmeud03,nmeud04,nmeud05,
           nmeud06,nmeud07,nmeud08,nmeud09,nmeud10,
           nmeud11,nmeud12,nmeud13,nmeud14,nmeud15
           #FUN-850038    ----end----
          #No.FUN-580031 --start--     HCN
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          #No.FUN-580031 --end--       HCN
 
          ON ACTION CONTROLP
             CASE
                #No.FUN-A30062  --Begin
                WHEN INFIELD(nme12) #参考单号
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nme12"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nme.nme12
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme12
                  NEXT FIELD nme12
                #No.FUN-A30062  --End  
                WHEN INFIELD(nme01) #銀行
#                 CALL q_nma(0,0,g_nme.nme01) RETURNING g_nme.nme01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nme.nme01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme01
                  NEXT FIELD nme01
                WHEN INFIELD(nme03)
#                 CALL q_nmc(10,26,g_nme.nme03) RETURNING g_nme.nme03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nme2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nme.nme03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme03
                  NEXT FIELD nme03
                WHEN INFIELD(nme15)
#                 CALL q_gem(10,26,g_nme.nme15) RETURNING g_nme.nme15
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nme.nme15
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme15
                  NEXT FIELD nme15
                WHEN INFIELD(nme06)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nme.nme06,'23')
#                      RETURNING g_nme.nme06
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nme.nme06,'23')  #No.FUN-730070 mark
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nme.nme06,'23',g_aza.aza81)   #No.FUN-730070  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nme.nme06,'23',g_aza.aza81) #No.FUN-980025
                       RETURNING g_nme.nme06
                  DISPLAY BY NAME g_nme.nme06 NEXT FIELD nme06
#No.FUN-680034--begin
                WHEN INFIELD(nme061)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nme.nme061,'23') #No.FUN-730070 mark
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nme.nme061,'23',g_aza.aza82)   #No.FUN-730070  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nme.nme061,'23',g_aza.aza82) #No.FUN-980025
                       RETURNING g_nme.nme061
                  DISPLAY BY NAME g_nme.nme061 NEXT FIELD nme061
#No.FUN-680034--end
                WHEN INFIELD(nme11)
#                 CALL q_azf(10,26,g_nme.nme11,'2') RETURNING g_nme.nme11
                  CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_azf"    #No.FUN-930104
                  LET g_qryparam.form = "q_azf01a"  #No.FUN-930104
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_nme.nme11
#                 LET g_qryparam.arg1 = '2'        #No.FUN-930104  
                  LET g_qryparam.arg1 = '8'         #No.FUN-930104     
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme11
                  NEXT FIELD nme11
                WHEN INFIELD(nme09)
#                 CALL q_nmk(10,26,g_nme.nme09) RETURNING g_nme.nme09
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmk"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_nme.nme09
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme09
                  CALL t300_nme09('d')
                  NEXT FIELD nme09
                WHEN INFIELD(nme14)
#                 CALL q_nml(10,26,g_nme.nme14) RETURNING g_nme.nme14
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nme"  #MOD-4A0252將q_nml改為q_nme
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_nme.nme14
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nme14
                  NEXT FIELD nme14
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
    END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #    LET g_wc = g_wc clipped," AND nmeuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #    LET g_wc = g_wc clipped," AND nmegrup MATCHES '",g_grup CLIPPED,"*'"
   #END IF
   #IF g_priv3 MATCHES "[5678]" THEN             #TQC-5C0134群組權限
   #    LET g_wc = g_wc clipped," AND nmegrup IN ",cl_chk_tgrup_list()
   #END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmeuser', 'nmegrup')
   #End:FUN-980030
 
    # 組合出 SQL 指令
   #LET g_sql="SELECT rowid,nme01,nme02 ",                    #TQC-950038 mark 
    LET g_sql="SELECT nme00,nme01,nme02,nme03,nme12,nme21 ",  #TQC-950038
              "  FROM nme_file ",
              " WHERE ",g_wc CLIPPED,
             #" ORDER BY nme01,nme02"                         #TQC-950038 mark
              " ORDER BY nme00,nme01,nme02,nme03,nme12,nme21" #TQC-950038
    PREPARE t300_prepare FROM g_sql                           # RUNTIME 編譯
    DECLARE t300_cs SCROLL CURSOR WITH HOLD FOR t300_prepare  # SCROLL CURSOR
    # 捉出符合QBE條件的資料筆數
    LET g_sql="SELECT COUNT(*) FROM nme_file WHERE ",g_wc CLIPPED
    PREPARE t300_precount FROM g_sql                          # row的個數
    DECLARE t300_count CURSOR FOR t300_precount
END FUNCTION
 
FUNCTION t300_menu()
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
           CALL cl_set_act_visible("acct_checking",g_aza.aza26 <> '2')   #No.TQC-BB0024

        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL t300_q()
           END IF
        ON ACTION next
           CALL t300_fetch('N')
        ON ACTION previous
           CALL t300_fetch('P')
        ON ACTION adjust
           LET g_action_choice="adjust"
           IF cl_chk_act_auth() THEN
              CALL t300_j()
           END IF
        #No.TQC-BB0024  undo mark  --begin
        ON ACTION acct_checking
           LET g_action_choice="acct_checking"
           IF cl_chk_act_auth() THEN
              CALL t300_m()
           END IF
        #No.TQC-BB0024  undo mark  --end  
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              CALL t300_out()
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
           CALL t300_fetch('/')
        ON ACTION first
           CALL t300_fetch('F')
        ON ACTION last
           CALL t300_fetch('L')

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
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t300_cs
END FUNCTION
 
FUNCTION t300_nme01(p_code)
   DEFINE p_code  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
          l_nma02 LIKE nma_file.nma02
 
   LET l_nma02 = NULL
   LET g_nma.nma10 = NULL
   SELECT nma02,nma10 INTO l_nma02,g_nma.nma10
     FROM nma_file
    WHERE nma01 = g_nme.nme01
   DISPLAY l_nma02,g_nma.nma10 TO nma02,nma10
END FUNCTION
 
FUNCTION t300_nme02(p_code)
   DEFINE p_code  LIKE type_file.chr1   #No.FUN-680107 VARCHAR(01)
 
   CALL s_curr3(g_nma.nma10,g_nme.nme02,'S') RETURNING g_nme.nme07
   DISPLAY g_nme.nme07 TO nme07
   LET g_nme.nme08 = g_nme.nme04 * g_nme.nme07
   DISPLAY g_nme.nme08 TO nme08
END FUNCTION
 
FUNCTION t300_nme15(p_cmd)  #Dept代號
   DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_gem02   LIKE gem_file.gem02,
          l_gemacti LIKE gem_file.gemacti
 
   LET g_errno = ' '
   LET l_gem02 = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_nme.nme15
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-071'
                                  LET l_gem02 = NULL
        WHEN l_gemacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO gem02
   END IF
END FUNCTION
 
FUNCTION t300_nme03(p_code)
   DEFINE p_code  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
          l_nmc02 LIKE nmc_file.nmc02,
          l_nmc03 LIKE nmc_file.nmc03,
          l_nmc04 LIKE nmc_file.nmc04,
          l_nmc05 LIKE nmc_file.nmc05
 
   LET l_nmc02=NULL LET l_nmc03=NULL
   LET l_nmc04=NULL LET l_nmc05=NULL
   SELECT nmc02,nmc03,nmc04,nmc05 INTO l_nmc02,l_nmc03,l_nmc04,l_nmc05
     FROM nmc_file
    WHERE nmc01 = g_nme.nme03
   DISPLAY l_nmc02,l_nmc03 TO nmc02,nmc03
   IF p_code = 'a' THEN
      IF g_nme.nme06 IS NULL THEN LET g_nme.nme06 = l_nmc04 END IF
      LET g_nme.nme14 = l_nmc05
   END IF
   DISPLAY BY NAME g_nme.nme06,g_nme.nme14
END FUNCTION
 
FUNCTION t300_nme11(p_code)
   DEFINE p_code  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
          l_azf03 LIKE azf_file.azf03

   SELECT azf03 INTO l_azf03 FROM azf_file
    WHERE azf01 = g_nme.nme11 AND azf02 = '2' 
   DISPLAY l_azf03 TO azf03
END FUNCTION
 
FUNCTION t300_nme09(p_code)
   DEFINE p_code  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
          l_nmk02 LIKE nmk_file.nmk02,
          l_nmk03 LIKE nmk_file.nmk03
 
   LET l_nmk02 = NULL
   LET l_nmk03 = NULL
   IF cl_null(g_nme.nme09) THEN
      DISPLAY l_nmk02 TO FORMONLY.nmk02
      DISPLAY l_nmk03 TO FORMONLY.nmk03 RETURN
   END IF
   SELECT nmk02,nmk03 INTO l_nmk02,l_nmk03 
     FROM nmk_file
    WHERE nmk01 = g_nme.nme09
   IF SQLCA.sqlcode AND p_code='a' THEN
#     CALL cl_err(g_nme.nme09,SQLCA.sqlcode,1)   #No.FUN-660148
      CALL cl_err3("sel","nmk_file",g_nme.nme09,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   END IF
   DISPLAY l_nmk02 TO FORMONLY.nmk02
   DISPLAY l_nmk03 TO FORMONLY.nmk03
END FUNCTION
 
FUNCTION t300_j()
   DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nme.nme12 IS NULL THEN     #未先查詢即選UPDATE
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_nme.nmeacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_nme.nme12,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nme01_t = g_nme.nme01
   LET g_nme02_t = g_nme.nme02
   LET g_nme_o.*=g_nme.*  #保留舊值
   LET g_success = 'Y'
   BEGIN WORK
  #OPEN t300_cl USING g_nme_rowid                           #TQC-950038 mark
   OPEN t300_cl USING g_nme.nme00,g_nme.nme01,g_nme.nme02,  #TQC-950038
                      g_nme.nme03,g_nme.nme12,g_nme.nme21   #TQC-950038
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_nme.*                   #對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nme.nme12,SQLCA.sqlcode,0)
      RETURN
   END IF
   LET g_nme.nmemodu=g_user                     #修改者
   LET g_nme.nmedate = g_today                  #修改日期
   CALL t300_show()                             #顯示最新資料
   WHILE TRUE
      CALL t300_j_i("u")                        #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_nme.*=g_nme_t.*
         CALL t300_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE nme_file SET nme_file.* = g_nme.*  #更新DB
     # WHERE rowid=g_nme_rowid                  #COLAUTH?                   #TQC-950038 mark
      #WHERE nme00=g_nme.nme00 AND nme01=g_nme.nme01 AND nme02=g_nme.nme02  #TQC-950038 #MOD-AB0175 mark     
       WHERE nme00=g_nme.nme00 AND nme01=g_nme01_t AND nme02=g_nme02_t      #TQC-950038 #MOD-AB0175
         AND nme03=g_nme.nme03 AND nme12=g_nme.nme12 AND nme21=g_nme.nme21  #TQC-950038
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
#        CALL cl_err(g_nme.nme01,SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("upd","nme_file",g_nme.nme02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t300_cl
   IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t300_j_i(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmz70 LIKE nmz_file.nmz70   #No.FUN-B40056 add
   #TQC-C60058--add--str--
   DEFINE l_tic00 LIKE tic_file.tic00   #帳套
   DEFINE l_tic01 LIKE tic_file.tic01   #年度
   DEFINE l_tic02 LIKE tic_file.tic02   #期別
   DEFINE l_tic03 LIKE tic_file.tic03   #借貸別
   DEFINE l_tic06 LIKE tic_file.tic06 
   DEFINE l_n,i   LIKE type_file.num5
   #TQC-C60058--add--end--

   INPUT BY NAME g_nme.nme02,g_nme.nme16,g_nme.nme14,g_nme.nme09,
                 #FUN-850038     ---start---
                 g_nme.nmeud01,g_nme.nmeud02,g_nme.nmeud03,g_nme.nmeud04,
                 g_nme.nmeud05,g_nme.nmeud06,g_nme.nmeud07,g_nme.nmeud08,
                 g_nme.nmeud09,g_nme.nmeud10,g_nme.nmeud11,g_nme.nmeud12,
                 g_nme.nmeud13,g_nme.nmeud14,g_nme.nmeud15 
                 #FUN-850038     ----end----
               WITHOUT DEFAULTS
#FUN-B40056 --begin
      BEFORE INPUT
         SELECT nmz70 INTO l_nmz70 FROM nmz_file         
         CALL cl_set_act_visible("flows",l_nmz70 = '1')  
#FUN-B40056 --end 
  
  
         #TQC-B80112--add--str--
         IF g_nme.nme20 = 'Y' THEN
            CALL cl_set_comp_entry("nme02,nme16",FALSE)
            NEXT FIELD nme14
         ELSE
            CALL cl_set_comp_entry("nme02,nme16",TRUE)
         END IF
         #TQC-B80112--add--end--

      AFTER FIELD nme02
         #FUN-B50090 add begin-------------------------
         #重新抓取關帳日期
         SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
         #FUN-B50090 add -end--------------------------
        #MOD-C90038----mark----s
        #IF g_nme.nme02 <= g_nmz.nmz10 THEN  #no.5261
        #   CALL cl_err('','aap-176',1) NEXT FIELD nme02
        #END IF
        #MOD-C90038----mark----e

      AFTER FIELD nme16
         #FUN-B50090 add begin-------------------------
         #重新抓取關帳日期
         SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
         #FUN-B50090 add -end--------------------------
         IF g_nme.nme16 <= g_nmz.nmz10 THEN  #no.5261
            CALL cl_err('','aap-176',1) NEXT FIELD nme16
         END IF

      AFTER FIELD nme09		 # adjust碼
         IF NOT cl_null(g_nme.nme09) THEN
            SELECT COUNT(*) INTO g_cnt FROM nmk_file
             WHERE nmk01 = g_nme.nme09
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nme.nme09,'anm-069',0)   #No.FUN-660148
               CALL cl_err3("sel","nmk_file",g_nme.nme09,"","anm-069","","",1)  #No.FUN-660148
               NEXT FIELD nme09
            END IF
            IF g_cnt <= 0 THEN
               CALL cl_err(g_nme.nme09,'anm-069',0)
               NEXT FIELD nme09
            END IF
            CALL t300_nme09('a')
         END IF
 
      AFTER FIELD nme14		 # 現金變動碼
         IF NOT cl_null(g_nme.nme14) THEN
            SELECT nml02 INTO g_buf FROM nml_file
             WHERE nml01 = g_nme.nme14
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nme.nme14,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("sel","nml_file",g_nme.nme14,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
               NEXT FIELD nme14
            END IF
            DISPLAY g_buf TO FORMONLY.nml02
            LET g_buf = NULL
         END IF
 
      #FUN-850038     ---start---
      AFTER FIELD nmeud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmeud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-850038     ----end----
 
      AFTER INPUT
         LET g_nme.nmeuser = s_get_data_owner("nme_file") #FUN-C10039
         LET g_nme.nmegrup = s_get_data_group("nme_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT 
        #MOD-940084  --begin--                                                                                                          
         ELSE                                                                                                                        
            IF cl_null(g_nme.nme09) THEN                                                                                             
               IF NOT cl_null(g_nme.nme02) AND NOT cl_null(g_nme.nme16) THEN                                                          
                 #當兩個日期都有輸入時比較是否同一年月,不同年月才秀anm-046
                 #IF g_nme.nme02 != g_nme.nme16 THEN              #TQC-950038 mark 
                  IF YEAR(g_nme.nme02) !=YEAR(g_nme.nme16) OR     #TQC-950038
                     MONTH(g_nme.nme02)!=MONTH(g_nme.nme16) THEN  #TQC-950038
                     CALL cl_err('','anm-046',0)                                                                                        
                     NEXT FIELD nme09                                                                                                   
                  END IF                                                                                                               
               END IF                                                                                                                 
            END IF
            #TQC-C60058--add--str--
            LET l_tic01 = YEAR(g_nme.nme02) 
            LET l_tic02 = MONTH(g_nme.nme02)            #期別
            LET l_tic03 = ' '
            SELECT nmc03 INTO l_tic03
              FROM nmc_file
             WHERE nmc01 = g_nme.nme03
            LET l_tic00 = ' '
            IF g_nmz.nmz71 = 'Y' THEN
               IF g_nmz.nmz70 = '1' AND g_nmz.nmz72 = '1' THEN
                  SELECT COUNT(*) INTO l_n FROM tic_file
                   WHERE tic00 = l_tic00
                     AND tic01 = l_tic01
                     AND tic02 = l_tic02
                     AND tic03 = l_tic03
                     AND tic04 = g_nme.nme12 
                   IF l_n = 0 THEN
                      CALL cl_err('','axr-243',1)
                      NEXT FIELD nme02
                   ELSE
                      LET g_sql="SELECT tic06 FROM tic_file  ",
                                " WHERE tic00 = '",l_tic00,"'",
                                "   AND tic01 = '",l_tic01,"'",
                                "   AND tic02 = '",l_tic02,"'",
                                "   AND tic03 = '",l_tic03,"'",
                                "   AND tic04 = '",g_nme.nme12,"'"
                      PREPARE t300_pre FROM g_sql
                      DECLARE t300_tic_cs CURSOR FOR t300_pre
                      FOREACH t300_tic_cs INTO l_tic06
                         IF cl_null(l_tic06) THEN
                            CALL cl_err('','axr-243',1)
                            NEXT FIELD nme02
                         ELSE
                            LET l_n = 0
                            SELECT count(*) INTO l_n FROM nml_file WHERE nml01 = l_tic06 AND nmlacti = 'Y'
                            IF l_n = 0 THEN
                               CALL cl_err('','axr-245',0)
                               NEXT FIELD nme02
                            END IF
                         END IF 
                      END FOREACH
                   END IF
               END IF
               IF g_nmz.nmz70 = '1' AND g_nmz.nmz72 = '2' THEN
                  SELECT COUNT(*) INTO l_n FROM tic_file
                   WHERE tic00 = l_tic00
                     AND tic01 = l_tic01
                     AND tic02 = l_tic02
                     AND tic03 = l_tic03
                     AND tic04 = g_nme.nme12
                   IF l_n = 0 THEN
                      CALL cl_err('','axr-254',1)
                   ELSE
                      LET g_sql="SELECT tic06 FROM tic_file  ",
                                " WHERE tic00 = '",l_tic00,"'",
                                "   AND tic01 = '",l_tic01,"'",
                                "   AND tic02 = '",l_tic02,"'",
                                "   AND tic03 = '",l_tic03,"'",
                                "   AND tic04 = '",g_nme.nme12,"'"
                      PREPARE t300_pre1 FROM g_sql
                      DECLARE t300_tic_cs1 CURSOR FOR t300_pre1
                      FOREACH t300_tic_cs1 INTO l_tic06
                         IF cl_null(l_tic06) THEN
                            CALL cl_err('','axr-254',1)
                         END IF
                      END FOREACH
                   END IF
               END IF 
            END IF 
            #TQC-C60058--add--end--                                                                                                                         
        #MOD-940084  --end     
         END IF
 
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(nme09)
#              CALL q_nmk(10,26,g_nme.nme09) RETURNING g_nme.nme09
#              CALL FGL_DIALOG_SETBUFFER( g_nme.nme09 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmk"
               LET g_qryparam.default1 = g_nme.nme09
               CALL cl_create_qry() RETURNING g_nme.nme09
#              CALL FGL_DIALOG_SETBUFFER( g_nme.nme09 )
               DISPLAY BY NAME g_nme.nme09
               CALL t300_nme09('d')
               NEXT FIELD nme09
            WHEN INFIELD(nme14)
#              CALL q_nml(10,26,g_nme.nme14) RETURNING g_nme.nme14
#              CALL FGL_DIALOG_SETBUFFER( g_nme.nme14 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_nme.nme14
               CALL cl_create_qry() RETURNING g_nme.nme14
#              CALL FGL_DIALOG_SETBUFFER( g_nme.nme14 )
               DISPLAY BY NAME g_nme.nme14
               NEXT FIELD nme14
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
      
      #FUN-B40056--add--str--
      ON ACTION flows
         CALL s_flows_nme(g_nme.*,'0',g_plant)   #No.FUN-B90062  
#         CALL t300_flows()
      #FUN-B40056--add--end--  
 
   END INPUT
END FUNCTION
 
FUNCTION t300_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_nme.* TO NULL              #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t300_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN t300_count
   FETCH t300_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nme.nme01,SQLCA.sqlcode,0)
      INITIALIZE g_nme.* TO NULL
   ELSE
      CALL t300_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t300_fetch(p_flnme)
   DEFINE p_flnme  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_abso   LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnme
      WHEN 'N' FETCH NEXT     t300_cs INTO g_nme.nme00,g_nme.nme01,g_nme.nme02,  #TQC-950038 mod #g_nme_rowid
                                           g_nme.nme03,g_nme.nme12,g_nme.nme21   #TQC-950038 add
      WHEN 'P' FETCH PREVIOUS t300_cs INTO g_nme.nme00,g_nme.nme01,g_nme.nme02,  #TQC-950038 mod #g_nme_rowid
                                           g_nme.nme03,g_nme.nme12,g_nme.nme21   #TQC-950038 add
      WHEN 'F' FETCH FIRST    t300_cs INTO g_nme.nme00,g_nme.nme01,g_nme.nme02,  #TQC-950038 mod #g_nme_rowid
                                           g_nme.nme03,g_nme.nme12,g_nme.nme21   #TQC-950038 add
      WHEN 'L' FETCH LAST     t300_cs INTO g_nme.nme00,g_nme.nme01,g_nme.nme02,  #TQC-950038 mod #g_nme_rowid
                                           g_nme.nme03,g_nme.nme12,g_nme.nme21   #TQC-950038 add
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
           FETCH ABSOLUTE g_jump t300_cs INTO g_nme.nme00,g_nme.nme01,g_nme.nme02,  #TQC-950038 mod #g_nme_rowid
                                              g_nme.nme03,g_nme.nme12,g_nme.nme21   #TQC-950038 add
           LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nme.nme01,SQLCA.sqlcode,0)
      INITIALIZE g_nme.* TO NULL  #TQC-6B0105
     #LET g_nme_rowid = NULL      #TQC-6B0105  #TQC-950038 mark
      RETURN
   ELSE
      CASE p_flnme
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_nme.* FROM nme_file            # 重讀DB,因TEMP有不被更新特性
  # WHERE rowid=g_nme_rowid                                              #TQC-950038 mark
    WHERE nme00=g_nme.nme00 AND nme01=g_nme.nme01 AND nme02=g_nme.nme02  #TQC-950038
      AND nme03=g_nme.nme03 AND nme12=g_nme.nme12 AND nme21=g_nme.nme21  #TQC-950038
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nme.nme12,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("sel","nme_file",g_nme.nme02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_nme.nmeuser     #No.FUN-4C0063
      LET g_data_group = g_nme.nmegrup     #No.FUN-4C0063
      CALL t300_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION t300_show()
   LET g_nme_t.* = g_nme.*
   DISPLAY BY NAME
       g_nme.nme12,g_nme.nme21,g_nme.nme22,g_nme.nme18,g_nme.nme13,g_nme.nme17,g_nme.nme11, #No.FUN-730032 add nme21,nme22
       g_nme.nme01,g_nme.nme02,g_nme.nme15,g_nme.nme03,
       g_nme.nme14,g_nme.nme04,g_nme.nme07,
       g_nme.nme08,g_nme.nme05,g_nme.nme06,g_nme.nme061,                                 #No.FUN-680034 add g_nme061
       g_nme.nme09,g_nme.nme20,
       g_nme.nme16,
       #FUN-850038     ---start---
       g_nme.nmeud01,g_nme.nmeud02,g_nme.nmeud03,g_nme.nmeud04,
       g_nme.nmeud05,g_nme.nmeud06,g_nme.nmeud07,g_nme.nmeud08,
       g_nme.nmeud09,g_nme.nmeud10,g_nme.nmeud11,g_nme.nmeud12,
       g_nme.nmeud13,g_nme.nmeud14,g_nme.nmeud15 
       #FUN-850038     ----end----
   CALL t300_nme01('')
   CALL t300_nme03('')
#  CALL s_m_aag(g_dbs_gl,g_nme.nme06) RETURNING g_msg  #No.FUN-730070 mark
#  CALL s_m_aag(g_dbs_gl,g_nme.nme06,g_aza.aza81) RETURNING g_msg  #No.FUN-730070   #FUN-990069
   CALL s_m_aag(g_nmz.nmz02p,g_nme.nme06,g_aza.aza81) RETURNING g_msg  #No.FUN-730070   #FUN-990069 
   DISPLAY g_msg TO FORMONLY.a
#No.FUN-680034--begin
#  CALL s_m_aag(g_dbs_gl,g_nme.nme061) RETURNING g_msg #No.FUN-730070 mark
#  CALL s_m_aag(g_dbs_gl,g_nme.nme061,g_aza.aza82) RETURNING g_msg #No.FUN-730070   #FUN-990069
   CALL s_m_aag(g_nmz.nmz02p,g_nme.nme061,g_aza.aza82) RETURNING g_msg #No.FUN-730070   #FUN-990069 
   DISPLAY g_msg TO FORMONLY.b
#No.FUN-680034--end
   CALL t300_nme09('d')
   CALL t300_nme11('d')
   CALL t300_nme15('d')
   SELECT nml02 INTO g_buf FROM nml_file WHERE nml01=g_nme.nme14
   DISPLAY g_buf TO FORMONLY.nml02
   LET g_buf = NULL
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

#No.FUN-7C0043--start-- 
FUNCTION t300_out()
   DEFINE l_i            LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_name         LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
          l_nme   RECORD LIKE nme_file.*,
          l_za05         LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
          l_chr          LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000  #No.FUN-7C0043                                                                 
                                                                                                                                   
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                     
   LET l_cmd = 'p_query "anmt300" "',g_wc CLIPPED,'"'                                                                              
   CALL cl_cmdrun(l_cmd)                                                                                                           
   RETURN  

#  IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#  CALL cl_wait()
#  CALL cl_outnam('anmt300') RETURNING l_name
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#  LET g_sql="SELECT * FROM nme_file ",          # 組合出 SQL 指令
#            " WHERE ",g_wc CLIPPED
#  PREPARE t300_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE t300_co CURSOR FOR t300_p1
#  START REPORT t300_rep TO l_name
#  FOREACH t300_co INTO l_nme.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('Foreach:',SQLCA.sqlcode,1)  
#        EXIT FOREACH
#        END IF
#     OUTPUT TO REPORT t300_rep(l_nme.*)
#  END FOREACH
#  FINISH REPORT t300_rep
#  CLOSE t300_co
#  ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t300_rep(sr)
#   DEFINE
#       l_trailer_sw  LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
#       sr            RECORD LIKE nme_file.*,
#       l_nma02       LIKE nma_file.nma02,    #銀行簡稱
#       l_chr         LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
#       l_nma10       LIKE nma_file.nma10     #MOD-590130
#
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.nme01
#
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6A0110
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6A0110
#           PRINT
#           PRINT g_dash[1,g_len]
#         #No.B090 010502 by linda mod
#         # PRINT g_x[11] CLIPPED,COLUMN 58,g_x[12] CLIPPED
#         # PRINT COLUMN 2,g_x[13] CLIPPED,'  ',g_x[14] CLIPPED
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                 g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#           PRINT g_dash1
#         #No.B090 end---
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.nme01
#           IF sr.nmeacti = 'N' THEN PRINT g_c[31],'*'; END IF
#MOD-590130
#           SELECT nma10 INTO l_nma10 FROM nma_file WHERE nma01=sr.nme01
#           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_nma10
#END MOD-590130
#
#      #No.B090 010502 by linda mod
#      #    PRINT COLUMN 2,sr.nme01,COLUMN 10,sr.nme02,COLUMN 21,sr.nme03,
#      #          COLUMN 25,sr.nme04,COLUMN 42,sr.nme05 CLIPPED
#           PRINT COLUMN g_c[32],sr.nme01,
#                 COLUMN g_c[33],l_nma02,
#                 #COLUMN g_c[34],sr.nme02 USING "YY/MM/DD", #FUN-570250 mark
#                 COLUMN g_c[34],sr.nme02, #FUN-570250 add
#                 COLUMN g_c[35],sr.nme03,
#                  COLUMN g_c[36],cl_numfor(sr.nme04,36,g_azi04),    #MOD-590130
#                 COLUMN g_c[36],cl_numfor(sr.nme04,36,t_azi04),    #MOD-590130
#                 COLUMN g_c[37],sr.nme05 CLIPPED
#      #No.B090 end---
#       ON LAST ROW
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN PRINT g_dash[1,g_len]
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#           END IF
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--

#No.TQC-BB0024  undo mark  --Begin
FUNCTION t300_m()
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)

  IF s_anmshut(0) THEN RETURN END IF
  IF g_nme.nme12 IS NULL THEN     #未先查詢即選UPDATE
     CALL cl_err('',-400,0)
     RETURN
  END IF
  IF g_nme.nmeacti ='N' THEN    #檢查資料是否為無效
     CALL cl_err(g_nme.nme12,'9027',0)
     RETURN
  END IF
  MESSAGE ""
  CALL cl_opmsg('u')
  LET g_nme00_t = g_nme.nme00   #TQC-950038 add
  LET g_nme01_t = g_nme.nme01
  LET g_nme02_t = g_nme.nme02
  LET g_nme03_t = g_nme.nme03   #TQC-950038 add
  LET g_nme12_t = g_nme.nme12   #TQC-950038 add
  LET g_nme21_t = g_nme.nme21   #TQC-950038 add
  LET g_nme_o.* = g_nme.*       #保留舊值
  LET g_success = 'Y'
  BEGIN WORK
 #OPEN t300_cl USING g_nme_rowid                           #TQC-950038 mark
  OPEN t300_cl USING g_nme.nme00,g_nme.nme01,g_nme.nme02,  #TQC-950038
                     g_nme.nme03,g_nme.nme12,g_nme.nme21   #TQC-950038
  IF STATUS THEN
     CALL cl_err("OPEN t300_cl:", STATUS, 1)
     CLOSE t300_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t300_cl INTO g_nme.*               # 對DB鎖定
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_nme.nme12,SQLCA.sqlcode,0)
     RETURN
  END IF
  LET g_nme.nmemodu=g_user                     #修改者
  LET g_nme.nmedate = g_today                  #修改日期
  CALL t300_show()                             #顯示最新資料
  WHILE TRUE
     CALL t300_m_i("u")                       #欄位更改
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_success = 'N'
        LET g_nme.*=g_nme_t.*
        CALL t300_show()
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
     UPDATE nme_file SET nme_file.* = g_nme.*    # 更新DB
    # WHERE rowid=g_nme_rowid                  #COLAUTH?                   #TQC-950038 mark
      WHERE nme00=g_nme.nme00 AND nme01=g_nme.nme01 AND nme02=g_nme.nme02  #TQC-950038
        AND nme03=g_nme.nme03 AND nme12=g_nme.nme12 AND nme21=g_nme.nme21  #TQC-950038
     IF SQLCA.sqlcode THEN
        LET g_success = 'N'
        CALL cl_err(g_nme.nme01,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("upd","nme_file",g_nme.nme02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
        CONTINUE WHILE
     END IF
     EXIT WHILE
  END WHILE
  CLOSE t300_cl
  IF g_success = 'Y'
     THEN COMMIT WORK
     ELSE ROLLBACK WORK
  END IF
END FUNCTION

FUNCTION t300_m_i(p_cmd)
  DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)

  INPUT BY NAME g_nme.nme20 WITHOUT DEFAULTS
     AFTER FIELD nme20
        IF g_nme.nme20<>'Y' AND g_nme.nme20 IS NOT NULL AND
           g_nme.nme20<>'' THEN
           NEXT FIELD nme20
        END IF
        IF g_nme.nme20<>'Y' THEN LET g_nme.nme20=NULL END IF
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
#No.TQC-BB0024  undo mark  --End  

#No.FUN-B90062 --begin 
#FUN-B40056 --begin
#FUNCTION t300_flows()  
#   DEFINE l_flag1   LIKE type_file.chr1   
#   DEFINE l_tic00   LIKE tic_file.tic00   #帳套
#   DEFINE l_tic01   LIKE tic_file.tic01   #年度
#   DEFINE l_tic02   LIKE tic_file.tic02   #期別
#   DEFINE l_tic03   LIKE tic_file.tic03   #借貸別
#   DEFINE g_tic     DYNAMIC ARRAY OF RECORD          
#                    tic04     LIKE tic_file.tic04,  #單據編號
#                    tic05     LIKE tic_file.tic05,  #項次
#                    tic06     LIKE tic_file.tic06,  #現金變動碼
#                    tic08     LIKE tic_file.tic08,  #關係人
#                    tic07f    LIKE tic_file.tic07f, #原幣金額
#                    tic07     LIKE tic_file.tic07   #本幣金額     
#                    END RECORD,
#          g_tic_t   RECORD          
#                    tic04     LIKE tic_file.tic04,  #單據編號
#                    tic05     LIKE tic_file.tic05,  #項次
#                    tic06     LIKE tic_file.tic06,  #現金變動碼
#                    tic08     LIKE tic_file.tic08,  #關係人
#                    tic07f    LIKE tic_file.tic07f, #原幣金額
#                    tic07     LIKE tic_file.tic07   #本幣金額     
#                    END RECORD
#   DEFINE l_n,i,k               LIKE type_file.num5   
#   DEFINE l_rec_b             LIKE type_file.num5 
#   DEFINE l_allow_insert      LIKE type_file.num5
#   DEFINE l_allow_delete      LIKE type_file.num5 
#   DEFINE p_cmd               LIKE type_file.chr1 
#   DEFINE l_sum1              LIKE nme_file.nme08
#   DEFINE l_sum2              LIKE nme_file.nme04 
#   DEFINE l_nme21             LIKE nme_file.nme21
#   DEFINE l_abb37             LIKE pmc_file.pmc903
#   DEFINE l_sum_tic07         LIKE tic_file.tic07
#   DEFINE l_sum_tic07f        LIKE tic_file.tic07f
#
#   
#   OPEN WINDOW t300_f AT 10,20 WITH FORM "anm/42f/anmt300_flows"
#   ATTRIBUTE(STYLE = g_win_style CLIPPED)
#   
#   CALL cl_ui_locale("anmt300_flows")
#   
#   CALL cl_set_comp_entry("tic04,tic05",FALSE)
#   
#   LET l_tic01 = YEAR(g_nme.nme02)             #年度
#   LET l_tic02 = MONTH(g_nme.nme02)            #期別   
#   LET l_tic03 = ' '
#   
#   SELECT nmc03 INTO l_tic03
#     FROM nmc_file
#    WHERE nmc01 = g_nme.nme03
#  
#   DISPLAY l_tic01,l_tic02,l_tic03 TO tic01,tic02,tic03
#   
#   LET i=1
#   LET l_n = 0
#   SELECT COUNT(*) INTO l_n FROM tic_file
#    WHERE tic01 = l_tic01
#      AND tic02 = l_tic02
#      AND tic03 = l_tic03
#      AND tic04 = g_nme.nme12
#      
#   IF l_n <= 0 THEN
#      IF cl_null(l_tic00) THEN
#         LET l_tic00 = ' '
#      END IF
#      IF cl_null(l_tic03) THEN
#         LET l_tic03 = ' '
#      END IF
#  
#      LET g_tic[i].tic04 = g_nme.nme12
#      LET g_tic[i].tic05 = g_nme.nme21
#      LET g_tic[i].tic06 = ' '
#      LET g_tic[i].tic07 = g_nme.nme08
#      LET g_tic[i].tic07f= g_nme.nme04
#      SELECT pmc903 INTO l_abb37 FROM pmc_file
#       WHERE pmc01 = g_nme.nme25
#      IF cl_null(l_abb37) THEN
#         SELECT occ37 INTO l_abb37 FROM occ_file
#          WHERE occ01 = g_nme.nme25
#      END IF
#      LET g_tic[i].tic08 = ' '
#      
#      INSERT INTO tic_file (tic00,tic01,tic02,tic03,tic04,
#                            tic05,tic06,tic07,tic07f,tic08)
#                     VALUES(l_tic00,l_tic01,l_tic02,l_tic03,g_tic[i].tic04,
#                            g_tic[i].tic05,g_tic[i].tic06,g_tic[i].tic07,
#                            g_tic[i].tic07f,g_tic[i].tic08)
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('t300_flow',SQLCA.sqlcode,0) 
#         ROLLBACK WORK
#      ELSE 
#         COMMIT WORK
#      END IF
#   END IF
#   
#   DECLARE t300_flows_c CURSOR FOR
#    SELECT tic04,tic05,tic06,tic08,tic07f,tic07
#      FROM tic_file 
#     WHERE tic01 = l_tic01
#       AND tic02 = l_tic02
#       AND tic03 = l_tic03
#       AND tic04 = g_nme.nme12
#     ORDER BY tic04
#
#   CALL g_tic.clear()
#
#   
#   LET l_rec_b=0
#   FOREACH t300_flows_c INTO g_tic[i].*
#      IF STATUS THEN
#         CALL cl_err('foreach ogc',STATUS,0)
#         EXIT FOREACH
#      END IF
#      
#      LET i = i + 1
#   END FOREACH
#   CALL g_tic.deleteElement(i)
#   LET l_rec_b = i - 1
#
#   LET l_allow_insert = cl_detail_input_auth("insert")
#   LET l_allow_delete = cl_detail_input_auth("delete")
#   LET i = 1
#   INPUT ARRAY g_tic WITHOUT DEFAULTS FROM s_tic.*
#         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#             INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,APPEND ROW = l_allow_insert)
#             
#      BEFORE INPUT
#         IF l_rec_b != 0 THEN
#             CALL fgl_set_arr_curr(i)
#         END IF  
#  
#      BEFORE ROW
#         LET i = ARR_CURR()
#         IF l_rec_b >= i THEN
#            LET p_cmd='u'
#            LET g_tic_t.* = g_tic[i].*                                                                                             
#            BEGIN WORK                                                                                                               
#            CALL cl_show_fld_cont()
#         END IF 
#      
#      AFTER FIELD tic06
#         IF NOT cl_null(g_tic[i].tic06) THEN
#            IF cl_null(g_tic[i].tic07) THEN 
#               SELECT sum(tic07),sum(tic07f) INTO l_sum_tic07,l_sum_tic07f FROM tic_file
#                WHERE tic01 = l_tic01
#                  AND tic02 = l_tic02
#                  AND tic03 = l_tic03
#                  AND tic04 = g_nme.nme12
#                  AND tic05 = g_nme.nme21
#                  IF cl_null(l_sum_tic07) THEN
#                       LET l_sum_tic07 = 0
#                  END IF
#               IF cl_null(l_sum_tic07f) THEN
#                  LET l_sum_tic07f = 0
#               END IF
#               IF g_nme.nme04 >= l_sum_tic07f THEN
#                  LET g_tic[i].tic07f = g_nme.nme04 - l_sum_tic07f
#                  IF cl_null(g_nme.nme07) THEN
#                     LET g_tic[i].tic07 = g_tic[i].tic07f
#                  ELSE
#                     LET g_tic[i].tic07 = g_tic[i].tic07f * g_nme.nme07
#                  END IF
#               ELSE
#                  LET g_tic[i].tic07 = 0
#                  LET g_tic[i].tic07f = 0
#               END IF 
#            END IF
#         END IF
#         
#      AFTER FIELD tic07f
#         LET l_sum_tic07f = 0
#         SELECT sum(tic07f) INTO l_sum_tic07f FROM tic_file
#          WHERE tic01 = l_tic01
#            AND tic02 = l_tic02
#            AND tic03 = l_tic03
#            AND tic04 = g_nme.nme12
#            AND tic05 = g_nme.nme21
#         IF cl_null(l_sum_tic07f) THEN
#            LET l_sum_tic07f = 0
#         END IF
#         
#         IF cl_null(g_tic_t.tic07f) THEN
#            LET g_tic_t.tic07f = 0
#         END IF
#         
#         LET l_sum_tic07f = l_sum_tic07f - g_tic_t.tic07f
#         
#         IF l_sum_tic07f+g_tic[i].tic07f > g_nme.nme04 THEN
#            CALL cl_err('','anm-606',0)
#            NEXT FIELD tic07f
#         END IF
#         IF cl_null(g_nme.nme07) THEN
#            LET g_tic[i].tic07 = g_tic[i].tic07f
#         ELSE
#            LET g_tic[i].tic07 = g_tic[i].tic07f * g_nme.nme07
#         END IF
#      
#      AFTER FIELD tic07
#         LET l_sum_tic07 = 0
#         SELECT sum(tic07) INTO l_sum_tic07 FROM tic_file
#          WHERE tic01 = l_tic01
#            AND tic02 = l_tic02
#            AND tic03 = l_tic03
#            AND tic04 = g_nme.nme12
#            AND tic05 = g_nme.nme21
#         IF cl_null(l_sum_tic07) THEN
#            LET l_sum_tic07 = 0
#         END IF
#         IF cl_null(g_tic_t.tic07) THEN
#            LET g_tic_t.tic07 = 0
#         END IF
#         
#         LET l_sum_tic07 = l_sum_tic07 - g_tic_t.tic07
#         
#         LET l_sum_tic07 = l_sum_tic07
#         IF l_sum_tic07+g_tic[i].tic07 > g_nme.nme08 THEN
#            CALL cl_err('','anm-607',0)
#            NEXT FIELD tic07
#         END IF
#      AFTER FIELD tic08
#         SELECT pmc903 INTO l_abb37 FROM pmc_file
#          WHERE pmc01 = g_nme.nme25
#         IF cl_null(l_abb37) THEN
#            SELECT occ37 INTO l_abb37 FROM occ_file
#             WHERE occ01 = g_nme.nme25
#         END IF
#         IF l_abb37 = 'Y' THEN
#            IF cl_null(g_tic[i].tic08) THEN
#               CALL cl_err('','anm-608',0)
#               NEXT FIELD tic08
#            END IF
#         ELSE
#            IF cl_null(g_tic[i].tic08) THEN
#               LET g_tic[i].tic08 = ' '
#            END IF
#         END IF
#
#      
#      BEFORE INSERT 
#         LET p_cmd='a'
#         INITIALIZE g_tic[i].*  TO NULL 
#         LET g_tic[i].tic04 = g_nme.nme12
#         LET g_tic[i].tic05 = g_nme.nme21
#         LET g_tic_t.* = g_tic[i].*  
#         CALL cl_show_fld_cont()
#         NEXT FIELD tic06 
#
#      BEFORE DELETE
#         IF NOT cl_delb(0,0) THEN
#            CANCEL DELETE
#         END IF   
#         IF cl_null(l_tic00) THEN
#            LET l_tic00 = ' '
#         END IF
#         IF cl_null(l_tic03) THEN
#            LET l_tic03 = ' '
#         END IF
#         DELETE FROM tic_file 
#          WHERE tic00 = l_tic00
#            AND tic01 = l_tic01
#            AND tic02 = l_tic02
#            AND tic03 = l_tic03
#            AND tic04 = g_tic_t.tic04
#            AND tic05 = g_tic_t.tic05
#            AND tic06 = g_tic_t.tic06
#            AND tic08 = g_tic_t.tic08    
#            AND tic07 = g_tic_t.tic07
#            AND tic07f = g_tic_t.tic07f                                                                
#        IF SQLCA.sqlcode THEN                                                             
#           CALL cl_err3("del","tic_file",'',"",SQLCA.sqlcode ,"","",1)                                                       
#           ROLLBACK WORK
#           CANCEL DELETE
#        END IF
#        LET l_rec_b = l_rec_b - 1  
#     
#    
#      ON ROW CHANGE
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             LET g_tic[i].* = g_tic_t.*
#             ROLLBACK WORK
#             EXIT INPUT
#          END IF
#          IF cl_null(l_tic00) THEN
#             LET l_tic00 = ' '
#          END IF
#          UPDATE tic_file SET tic06 = g_tic[i].tic06,
#                              tic07 = g_tic[i].tic07,
#                              tic07f = g_tic[i].tic07f,    
#                              tic08 = g_tic[i].tic08      
#           WHERE tic00 = l_tic00
#             AND tic01 = l_tic01
#             AND tic02 = l_tic02
#             AND tic04 = g_tic_t.tic04
#             AND tic05 = g_tic_t.tic05
#             AND tic06 = g_tic_t.tic06
#             AND tic08 = g_tic_t.tic08
#          IF SQLCA.sqlcode THEN
#             CALL cl_err("upd tic_file",SQLCA.sqlcode,1)
#             LET g_tic[i].* = g_tic_t.*
#             ROLLBACK WORK
#          END IF
#
#      AFTER INSERT                                                                                                                   
#         IF INT_FLAG THEN                                                                                                            
#            CALL cl_err('',9001,0)                                                                                                   
#            LET INT_FLAG = 0                                                                                                       
#            CANCEL INSERT                                                                                                            
#          END IF 
#          IF cl_null(l_tic00) THEN
#             LET l_tic00 = ' '
#          END IF
#          IF cl_null(l_tic03) THEN
#             LET l_tic03 = ' '
#          END IF
#          INSERT INTO tic_file VALUES(l_tic00,l_tic01,l_tic02,l_tic03,g_tic[i].tic04,g_tic[i].tic05,
#                                      g_tic[i].tic06,g_tic[i].tic07,g_tic[i].tic07f,g_tic[i].tic08)
#          IF SQLCA.sqlcode THEN                                                                                                      
#             CALL cl_err3("ins","tic_file",g_tic[i].tic05,"",SQLCA.sqlcode,"","",1)                                                  
#             CANCEL INSERT                                                                                                         
#          ELSE
#             LET l_rec_b = l_rec_b + 1 
#          END IF   
#     
#      AFTER ROW
#         LET i = ARR_CURR()
#         IF INT_FLAG THEN
#            CALL cl_err('',9001,0)
#            LET INT_FLAG = 0
#            LET g_tic[i].* = g_tic_t.*
#            ROLLBACK WORK
#            EXIT INPUT
#         END IF         
#
#      AFTER INPUT
#         FOR k = 1 TO l_rec_b
#           IF cl_null(g_tic[k].tic06) THEN
#              LET i = k
#              CALL cl_err(k,'agl-354',0)
#              CALL fgl_set_arr_curr(k)  
#              NEXT FIELD tic06
#           END IF
#         END FOR
#         SELECT pmc903 INTO l_abb37 FROM pmc_file
#          WHERE pmc01 = g_nme.nme25
#         IF cl_null(l_abb37) THEN
#            SELECT occ37 INTO l_abb37 FROM occ_file
#             WHERE occ01 = g_nme.nme25
#         END IF
#         IF l_abb37 = 'Y' THEN
#            FOR k = 1 TO l_rec_b
#               IF cl_null(g_tic[k].tic08) THEN
#                  LET i = k
#                  CALL cl_err('','anm-608',0)
#                  CALL fgl_set_arr_curr(k)  
#                  NEXT FIELD tic08
#               END IF
#            END FOR  
#         END IF
#         COMMIT WORK
#         
#      ON ACTION controlp
#         CASE 
#            WHEN INFIELD(tic06)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_nml"
#               CALL cl_create_qry() RETURNING g_tic[i].tic06
#               DISPLAY BY NAME g_tic[i].tic06
#               NEXT FIELD tic06
#         END CASE
#         
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#      ON ACTION about        
#         CALL cl_about()    
#
#      ON ACTION help         
#         CALL cl_show_help()  
#
#      ON ACTION controlg     
#         CALL cl_cmdask()    
#   END INPUT
#
#   IF INT_FLAG THEN
#      CALL cl_err('',9001,0)
#      LET INT_FLAG = 0
#      CLOSE WINDOW t300_f
#      RETURN
#   END IF
#   
#   CLOSE WINDOW t300_f
#   RETURN 
#END FUNCTION
#FUN-B40056--end
#No.FUN-B90062 --end 


# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: agli010.4gl
# Descriptions...: 多地區科目資料維護作業
# Date & Author..: 05/08/05 BY guoeh
# Modify.........: No.FUN-5C0015 06/03/10 BY TSD.kevin
#                  增加異動碼5~10，異動關係人及相關欄位，並做相關調整
# Modify.........: No.MOD-640376 06/04/11 By Smapmin 修改轉正式科目的方式
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670032 06/07/11 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.CHI-710005 07/01/22 By Elva 不判斷aza26
# Modify.........: No.FUN-710056 07/02/05 By Carrier aza48='N'時,隱藏giu00='A'
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730070 07/04/02 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-750113 07/05/21 By Rayven FUNCTION i010_p()中SELECT COUNT(*)沒有考慮數據庫，導致跨庫拋轉時不成功
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790077 07/09/19 By Carrier 科目層級加入非負判斷
# Modify.........: No.FUN-820030 08/02/20 By sherry  資料中心功能
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920364 09/02/26 By Smapmin aag_file多增加了aag39/aag40
# Modify.........: No.MOD-930319 09/03/31 By Sarah i010_bookno()段,判斷帳別時應抓目的營運中心的帳別
# Modify.........: No.CHI-940002 09/05/04 By Sarah i010_p()段,bookno開窗改成q_aaa4
# Modify.........: No.TQC-950024 09/05/04 By xiaofeizhu 統制科目（giu08）錄入加上檢查是否存在于giu_file,且有效
# Modify.........:                                      當資料有效碼(giuacti)='N'時，不可刪除該筆資
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查 
# Modify.........: No.TQC-9B0069 09/11/18 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.MOD-9C0250 09/12/19 By Carrier insert aag fail & 上层科目检查修改
# Modify.........: No.TQC-A10060 10/01/08 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30077 10/03/23 By Carrier 增加giu42/aag42 按余额类型产生分录
# Modify.........: No.FUN-A40020 10/04/07 By Carrier 独立科目层及设置为1
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A60204 10/06/30 By Dido 增加 giu19 項次到 37 
# Modify.........: No.MOD-A70002 10/07/01 By sabrina 異動碼-關係人新增"4.必需輸入、必需檢查、非關係人必需空白"選項 
# Modify.........: No.FUN-A70002 10/09/03 By vealxu 科目異動碼5-8輸入時需控管與agls103三數設定一致
# Modify.........: No.TQC-B40176 11/04/21 By yinhy 查詢時，狀態PAGE中資料建立者，資料建立部門無法下查詢條件
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-BA0021 11/10/06 By Dido 拋轉地區與 giu00 一致 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-820030
 
DEFINE g_argv1      LIKE  giu_file.giu01,        #No.FUN-680098   VARCHAR(24)
       g_giu        RECORD LIKE giu_file.*,
       g_giu_t      RECORD LIKE giu_file.*,
       g_giu_o      RECORD LIKE giu_file.*,
       g_giu01_t    LIKE giu_file.giu01,
       g_giu00_t    LIKE giu_file.giu00,
       g_wc,g_sql   STRING,       #No.FUN-580092 HCN      
       g_cmd        LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(50)
# FUN-5C0015 06/03/10 (s)
DEFINE g_ahe        RECORD
                    ahe02_1  LIKE ahe_file.ahe02,
                    ahe02_2  LIKE ahe_file.ahe02,
                    ahe02_3  LIKE ahe_file.ahe02,
                    ahe02_4  LIKE ahe_file.ahe02,
                    ahe02_5  LIKE ahe_file.ahe02,
                    ahe02_6  LIKE ahe_file.ahe02,
                    ahe02_7  LIKE ahe_file.ahe02,
                    ahe02_8  LIKE ahe_file.ahe02,
                    ahe02_9  LIKE ahe_file.ahe02,
                    ahe02_10 LIKE ahe_file.ahe02,
                    ahe02_11 LIKE ahe_file.ahe02
                    END RECORD
# FUN-5C0015 06/03/10 (e)
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680098 SMALLINT
DEFINE g_chr                LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10      #No.FUN-680098 INTEGER
DEFINE g_msg                LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10      #No.FUN-680098 INTEGER
DEFINE g_curs_index         LIKE type_file.num10      #No.FUN-680098 INTEGER
DEFINE g_jump               LIKE type_file.num10      #No.FUN-680098 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5       #No.FUN-680098 SMALLINT
DEFINE g_dbs_gl             LIKE type_file.chr21      #MOD-930319 add
#No.FUN-820030---Begin
DEFINE  g_giux        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)    
          giu00       LIKE giu_file.giu00,                
          giu01       LIKE giu_file.giu01,
          sel         LIKE type_file.chr1                                       
                      END RECORD       
DEFINE g_gev04        LIKE gev_file.gev04 
#No.FUN-820030---End 
 
MAIN
#  DEFINE l_time          LIKE type_file.chr8          #No.FUN-6A0073
   DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
   OPTIONS
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
 
   LET g_argv1 = ARG_VAL(1)
   INITIALIZE g_giu.* TO NULL
   INITIALIZE g_giu_t.* TO NULL
   INITIALIZE g_giu_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM giu_file WHERE giu00 = ? AND giu01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i010_cl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW i010_w AT p_row,p_col
        WITH FORM "agl/42f/agli010"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #No.FUN-710056  --Begin
   IF g_aza.aza48 = 'N' THEN
      CALL i010_set_giu00()
   END IF
   #No.FUN-710056  --End
 
   CALL i010_show_field()     # FUN-5C0015 06/03/10
 
   IF NOT cl_null(g_argv1) THEN
      CALL i010_q()
   END IF
 
   LET g_action_choice=""
   CALL i010_menu()
 
   CLOSE WINDOW i010_w
 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i010_cs()
 
   CLEAR FORM
 
   IF cl_null(g_argv1) THEN
      # FUN-5C0015 06/03/10 (s)
      #CONSTRUCT BY NAME g_wc ON giu00, giu01, giu02, giu03, giu04,
      #                          giu06, giu09, giu12, giu221,giu223,
      #                          giu224,giu225,giu226,giu19, giu07,
      #                          giu08, giu24, giu05, giu21, giu23,
      #                          giu20, giu222,giu15, giu151,giu16,
      #                          giu161,giu17, giu171,giu18, giu181,
      #                          giu13, giu14, giuuser, giugrup,
      #                          giumodu, giudate, giuacti
 
   INITIALIZE g_giu.* TO NULL    #No.FUN-750051
      #CONSTRUCT BY NAME g_wc ON giu00, giu01, giu02, giu03, giu04,        #No.FUN-820030
      CONSTRUCT BY NAME g_wc ON giu00, giu01, giu02, giu39,giu03, giu04,   #No.FUN-820030  add giu39
                                giu06, giu09, giu12, giu38, giu221,giu223, #FUN-670032 add giu38
                                giu224,giu225,giu226,giu19, giu07,
                                giu08, giu24, giu05, giu21, giu23,
                                giu42,        #No.FUN-A30077
                                giu13, giu14, giu20, giu222,
                                giu15, giu151,giu16,giu161,
                                giu17, giu171,giu18,giu181,
                                giu31, giu311,giu32,giu321,
                                giu33, giu331,giu34,giu341,
                                giu35, giu351,giu36,giu361,
                                giu37, giu371,
                                giuuser, giugrup,
                                giumodu, giudate, giuacti,
                                giuoriu,giuorig                            #TQC-B40176 
      # FUN-5C0015 06/03/10 (e)
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(giu223)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_giu.giu223
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu223
                  NEXT FIELD giu223
               WHEN INFIELD(giu224)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_giu.giu224
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu224
                  NEXT FIELD giu224
               WHEN INFIELD(giu225)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_giu.giu225
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu225
                  NEXT FIELD giu225
               WHEN INFIELD(giu226)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aae"
                  LET g_qryparam.default1 = g_giu.giu226
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu226
                  NEXT FIELD giu226
               WHEN INFIELD(giu08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_giu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu08
                  NEXT FIELD giu08
               # FUN-5C0015 06/03/10 (s)
               WHEN INFIELD(giu15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu15
                  NEXT FIELD giu15
                WHEN INFIELD(giu16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu16
                  NEXT FIELD giu16
                WHEN INFIELD(giu17)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu17
                  NEXT FIELD giu17
                WHEN INFIELD(giu18)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu18
                  NEXT FIELD giu18
               WHEN INFIELD(giu31)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu31
                  NEXT FIELD giu31
               WHEN INFIELD(giu32)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu32
                  NEXT FIELD giu32
               WHEN INFIELD(giu33)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu33
                  NEXT FIELD giu33
               WHEN INFIELD(giu34)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu34
                  NEXT FIELD giu34
               WHEN INFIELD(giu35)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu35
                  NEXT FIELD giu35
                WHEN INFIELD(giu36)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu36
                  NEXT FIELD giu36
                WHEN INFIELD(giu37)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ahe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO giu37
                  NEXT FIELD giu37
               # FUN-5C0015 06/03/10 (e)
                #No.FUN-820030---Begin
                WHEN INFIELD(giu39)                                             
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.state= "c"                                     
                  LET g_qryparam.form = "q_azp"                                 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret            
                  DISPLAY g_qryparam.multiret TO giu39                          
                  NEXT FIELD giu39             
                #No.FUN-820030---End
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
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
   ELSE
      LET g_wc = " giu01 = '",g_argv1 CLIPPED,"'"
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND giuuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND giugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND giugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('giuuser', 'giugrup')
   #End:FUN-980030
 
 
   LET g_sql="SELECT giu00,giu01 FROM giu_file ",
             " WHERE ",g_wc CLIPPED, " ORDER BY giu00,giu01"
   PREPARE i010_prepare FROM g_sql
   DECLARE i010_cs SCROLL CURSOR WITH HOLD FOR i010_prepare
 
   #No.FUN-820030---Begin
   LET g_sql="SELECT giu00,giu01 FROM giu_file ",                                                                             
             " WHERE ",g_wc CLIPPED, " ORDER BY giu00,giu01"                                                                        
   PREPARE i010_prepare_list FROM g_sql                                                                                                  
   DECLARE i010_cs_list CURSOR FOR i010_prepare_list
   #No.FUN-820030---End
   LET g_sql= "SELECT COUNT(*) FROM giu_file WHERE ",g_wc CLIPPED
   PREPARE i010_precount FROM g_sql
   DECLARE i010_count CURSOR FOR i010_precount
 
END FUNCTION
 
FUNCTION i010_menu()
   DEFINE l_cmd LIKE type_file.chr1000          #No.FUN-820030
   MENU ""
      BEFORE MENU
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i010_a()
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i010_q()
         END IF
 
      ON ACTION next
         CALL i010_fetch('N')
 
      ON ACTION previous
         CALL i010_fetch('P')
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i010_u()
         END IF
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i010_x()
            CALL cl_set_field_pic("","","","","",g_giu.giuacti)
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            caLL i010_r()
         END IF
      ON ACTION trsf_in_accounts
         LET g_action_choice="trsf_in_accounts"
         IF cl_chk_act_auth() THEN
            caLL i010_p()
         END IF
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i010_copy()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_giu.giuacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU
 
      ON ACTION jump
         CALL i010_fetch('/')
 
      ON ACTION first
         CALL i010_fetch('F')
 
      ON ACTION last
         CALL i010_fetch('L')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET g_action_choice = "exit"
         EXIT MENU
 
       ON ACTION related_document    #No.MOD-470515
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF g_giu.giu01 IS NOT NULL THEN
               LET g_doc.column1 = "giu01"
               LET g_doc.value1 = g_giu.giu01
               CALL cl_doc()
            END IF
         END IF
 
       #No.FUN-820030---Begin
         ON ACTION download                                                                                                         
            LET g_action_choice = "download"                                                                                        
            IF cl_chk_act_auth() THEN                                                                                               
               CALL i010_download()                                                                                                 
            END IF                                                                                                                  
                                                                                                                                    
         ON ACTION qry_carry_history                                                                                                
            LET g_action_choice = "qry_carry_history"                                                                               
            IF cl_chk_act_auth() THEN         
               IF NOT cl_null(g_giu.giu00) AND NOT cl_null(g_giu.giu01) THEN
                  IF NOT cl_null(g_giu.giu39) THEN                                
                     SELECT gev04 INTO g_gev04 FROM gev_file                       
                      WHERE gev01 = '6' AND gev02 = g_giu.giu39                   
                  ELSE      #歷史資料,即沒有giu39的值                             
                     SELECT gev04 INTO g_gev04 FROM gev_file                       
                      WHERE gev01 = '6' AND gev02 = g_plant                        
                  END IF 
                  IF NOT cl_null(g_gev04) THEN    
                     LET l_cmd='aooq604 "',g_gev04,'" "6" "',g_prog,'" "',g_giu.giu00,'" "',g_giu.giu01,'" '                                                                                       
                     CALL cl_cmdrun(l_cmd)                                                                                             
                  END IF
               ELSE                                                             
                  CALL cl_err('',-400,0)  
               END IF                                                                                                              
            END IF     
 
         ON ACTION carry                                                     
            LET g_action_choice = "carry"                                    
            IF cl_chk_act_auth() THEN 
               CALL ui.Interface.refresh()                                          
               CALL i010_carry()
               ERROR ""                                             
            END IF                                                                                                               
                                                                                                                                    
       #No.FUN-820030---End 
   END MENU
 
   CLOSE i010_cs
 
END FUNCTION
 
FUNCTION i010_a()
 
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_giu.* TO NULL
   LET g_giu_o.*=g_giu.*
 
  #LET g_giu.giu19 = 31   #MOD-A60204 mark
   LET g_giu.giu19 = 30   #MOD-A60204	
   LET g_giu.giu21 = 'N'
   LET g_giu.giu23 = 'N'
   LET g_giu.giu42 = 'N'   #No.FUN-A30077
   LET g_giu.giu05 = 'N'
   LET g_giu.giu09 = 'Y'
   LET g_giu01_t   = NULL
   LET g_giu00_t   = NULL                     #05/08/05
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_giu.giuacti ='Y'                   #有效的資料
      LET g_giu.giuuser = g_user
      LET g_giu.giuoriu = g_user #FUN-980030
      LET g_giu.giuorig = g_grup #FUN-980030
      LET g_giu.giugrup = g_grup               #使用者所屬群
      LET g_giu.giudate = g_today
      LET g_giu.giu20   = 'N'
      LET g_giu.giu221  = 'F'
      LET g_giu.giu24   = 1
      LET g_giu.giu38   = 'N' #FUN-670032 add giu38
      LET g_giu.giu39   = g_plant     #No.FUN-820030
#FUN-990069---begin
      IF NOT s_dc_ud_flag('6',g_giu.giu39,g_plant,'a') THEN                                                                           
         CALL cl_err(g_giu.giu39,'aoo-078',1)                                                                                         
         RETURN                                                                                                                       
      END IF 
#FUN-990069---end
      CALL i010_i("a")                         # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_giu.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_giu.giu01 IS NULL OR g_giu.giu00 IS NULL THEN
         CONTINUE WHILE
      END IF
 
      INSERT INTO giu_file VALUES(g_giu.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("ins","giu_file",g_giu.giu01,g_giu.giu00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      ELSE
         LET g_giu_t.* = g_giu.*                # 保存上筆資料
         SELECT giu00 INTO g_giu.giu00 FROM giu_file
          WHERE giu01 = g_giu.giu01 AND giu00 = g_giu.giu00
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i010_i(p_cmd)
DEFINE p_cmd                       LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_cmd                       LIKE abh_file.abh11,          #No.FUN-680098 VARCHAR(30)
       l_flag                      LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680098 VARCHAR(1)
       l_num                       LIKE type_file.num5,          #No.FUN-680098  SMALLINT
       l_aaeacti                   LIKE aae_file.aaeacti,
       l_cntabb,l_cntabg,l_cntabh  LIKE type_file.num10,        #No.FUN-680098  INTEGER
       l_n                         LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE l_cnt                       LIKE type_file.num5          #No.TQC-950024
 
   DISPLAY BY NAME g_giu.giu38, #FUN-670032 add giu38
                   g_giu.giu39, #FUN-820030 add giu39
                   g_giu.giuuser,g_giu.giugrup,g_giu.giudate,g_giu.giuacti 
 
   # FUN-5C0015 06/03/10 (s)
   #INPUT BY NAME g_giu.giu00, g_giu.giu01, g_giu.giu02, g_giu.giu03,
   #              g_giu.giu04, g_giu.giu06, g_giu.giu09, g_giu.giu12,
   #              g_giu.giu221,g_giu.giu223,g_giu.giu224,g_giu.giu225,
   #              g_giu.giu226,g_giu.giu19, g_giu.giu07, g_giu.giu08,
   #              g_giu.giu24, g_giu.giu05, g_giu.giu21, g_giu.giu23,
   #              g_giu.giu20, g_giu.giu222,g_giu.giu15, g_giu.giu151,
   #              g_giu.giu16, g_giu.giu161,g_giu.giu17, g_giu.giu171,
   #              g_giu.giu18, g_giu.giu181,g_giu.giu13, g_giu.giu14
   #              WITHOUT DEFAULTS
   INPUT BY NAME g_giu.giu00, g_giu.giu01, g_giu.giu02, g_giu.giu03, g_giu.giuoriu,g_giu.giuorig,
                 g_giu.giu04, g_giu.giu06, g_giu.giu09, g_giu.giu12,g_giu.giu38, #FUN-670032 add giu38
                 g_giu.giu221,g_giu.giu223,g_giu.giu224,g_giu.giu225,
                 g_giu.giu226,g_giu.giu19, g_giu.giu07, g_giu.giu08,
                 g_giu.giu24, g_giu.giu05, g_giu.giu21, g_giu.giu23,
                 g_giu.giu42,              #No.FUN-A30077
                 g_giu.giu13, g_giu.giu14,
                 g_giu.giu20, g_giu.giu222,g_giu.giu15, g_giu.giu151,
                 g_giu.giu16, g_giu.giu161,g_giu.giu17, g_giu.giu171,
                 g_giu.giu18, g_giu.giu181,
                 g_giu.giu31, g_giu.giu311,g_giu.giu32, g_giu.giu321,
                 g_giu.giu33, g_giu.giu331,g_giu.giu34, g_giu.giu341,
                 g_giu.giu35, g_giu.giu351,g_giu.giu36, g_giu.giu361,
                 g_giu.giu37, g_giu.giu371
                 WITHOUT DEFAULTS
 
   # FUN-5C0015 06/03/10 (e)
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i010_set_entry(p_cmd)
         CALL i010_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD giu01
         IF NOT cl_null(g_giu.giu01) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_giu.giu01 != g_giu01_t) THEN
               SELECT COUNT(*) INTO l_n FROM giu_file
                WHERE giu01 = g_giu.giu01 AND giu00 = g_giu.giu00
               IF l_n > 0 THEN
                  CALL cl_err(g_giu.giu01,-239,0)
                  LET g_giu.giu01 = g_giu01_t
                  DISPLAY BY NAME g_giu.giu01
                  NEXT FIELD giu01
               END IF
            END IF
         END IF
 
      AFTER FIELD giu03
         IF NOT cl_null(g_giu.giu03) THEN
            IF g_giu.giu03 NOT MATCHES'[24]' THEN
               LET g_giu.giu03 = g_giu_o.giu03
               DISPLAY BY NAME g_giu.giu03
               NEXT FIELD giu03
            END IF
            LET g_giu_o.giu03 = g_giu.giu03
         END IF
 
      AFTER FIELD giu04
         IF NOT cl_null(g_giu.giu04) THEN
            IF g_giu.giu04 NOT MATCHES'[12]' THEN
               LET g_giu.giu04 = g_giu_o.giu04
               DISPLAY BY NAME g_giu.giu04
               NEXT FIELD giu04
            END IF
            LET g_giu_o.giu04 = g_giu.giu04
         END IF
 
      AFTER FIELD giu05
         IF NOT cl_null(g_giu.giu05) THEN
            IF g_giu.giu05 NOT MATCHES'[YN]' THEN
               LET g_giu.giu05 = g_giu_o.giu05
               NEXT FIELD giu05
            END IF
            LET g_giu_o.giu05 = g_giu.giu05
         END IF
 
      AFTER FIELD giu06
         IF NOT cl_null(g_giu.giu06) THEN
            IF g_giu.giu06 NOT MATCHES'[12]' THEN
               LET g_giu.giu06 = g_giu_o.giu06
               DISPLAY BY NAME g_giu.giu06
               NEXT FIELD giu06
            END IF
            LET g_giu_o.giu06 = g_giu.giu06
         END IF
 
      #統制明細別
      BEFORE FIELD giu07
         CALL i010_set_entry(p_cmd)
 
      AFTER FIELD giu07
         IF NOT cl_null(g_giu.giu07) THEN
            IF g_giu.giu07 NOT MATCHES'[123]' THEN
               LET g_giu.giu07 = g_giu_o.giu07
               DISPLAY BY NAME g_giu.giu07
               NEXT FIELD giu07
            END IF
           #No.FUN-A30077  --Begin                                              
            IF g_giu.giu42='Y' AND g_giu.giu07='1' THEN                         
               CALL cl_err(g_giu.giu07,'agl-196',1)                             
               LET g_giu.giu07 = g_giu_o.giu07                                  
               DISPLAY BY NAME g_giu.giu07                                      
               NEXT FIELD giu07                                                 
            END IF                                                              
           #No.FUN-A30077  --End
            IF g_giu.giu07 != '2' THEN      #no.A056
               LET g_giu.giu08 = g_giu.giu01
               DISPLAY BY NAME g_giu.giu08
            END IF
            LET g_giu_o.giu07 = g_giu.giu07
         END IF
         CALL i010_set_no_entry(p_cmd)
        #IF g_giu.giu07 MATCHES '[23]' THEN  #No.FUN-A40020                     
         IF g_giu.giu07 = '2'          THEN  #No.FUN-A40020
            LET g_giu.giu24 = 99
         ELSE
            #No.FUN-A400200  --Begin                                            
            IF g_giu.giu07 = '3' THEN                                           
               LET g_giu.giu24 = 1                                              
            ELSE                                                                
            #No.FUN-A400200  --End 
               SELECT giu24 INTO g_giu.giu24 FROM giu_file
                WHERE giu01 = g_giu.giu08
               IF cl_null(g_giu.giu24) THEN
                  LET g_giu.giu24 = 0
               END IF
               IF g_giu.giu08 != g_giu.giu01 THEN
                  LET g_giu.giu24 = g_giu.giu24 + 1
               END IF
            END IF          #No.FUN-A40020
         END IF
         DISPLAY BY NAME g_giu.giu24
 
      BEFORE FIELD giu08
        #IF g_aza.aza26 = '2' AND g_giu.giu07 = '2' THEN  #CHI-710005
         IF g_giu.giu07 = '2' THEN   #CHI-710005
            DISPLAY ' ' TO giu08
         END IF
 
      AFTER FIELD giu08
         IF NOT cl_null(g_giu.giu08) THEN
            #TQC-950024--Begin--#
            LET l_cnt = 0
            #No.MOD-9C0250 --Begin
            #SELECT COUNT(*) INTO l_cnt 
            #  FROM giu_file
            # WHERE giu08=g_giu.giu08 AND giuacti = 'Y'
            #IF l_cnt = 0 THEN
            #   CALL cl_err('','abg-010',0)
            #   NEXT FIELD giu08
            #END IF                 
            SELECT COUNT(*) INTO l_cnt 
              FROM giu_file
             WHERE giu01=g_giu.giu08 
               AND giu00=g_giu.giu00
               AND giuacti = 'Y'
            IF l_cnt = 0 AND g_giu.giu08 <> g_giu.giu01 THEN
               CALL cl_err('','abg-010',0)
               NEXT FIELD giu08
            END IF                 
            #No.MOD-9C0250 --End  
            #TQC-950024--End--#         
            IF g_giu.giu07='2' THEN
               SELECT * FROM giu_file
                WHERE giu01=g_giu.giu08 AND giu00=g_giu.giu00 AND giu07='1'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('','agl-001',0)   #No.FUN-660123
                  CALL cl_err3("sel","giu_file",g_giu.giu08,g_giu.giu00,"agl-001","","",1)  #No.FUN-660123
                  NEXT FIELD giu08
               END IF
               LET g_giu_o.giu08 = g_giu.giu08
            ELSE
               #No.FUN-A40020  --Begin                                          
               IF g_giu.giu07 = '3' THEN                                        
                   IF g_giu.giu08 <> g_giu.giu01 THEN                           
                      LET g_giu.giu08 = g_giu.giu01                             
                      DISPLAY BY NAME g_giu.giu08                               
                   END IF                                                       
               ELSE                                                             
               #No.FUN-A400200  --End
                  IF cl_null(g_giu_o.giu08) OR g_giu_o.giu08<> g_giu.giu08 THEN
                     SELECT giu24 INTO g_giu.giu24 FROM giu_file
                      WHERE giu01 = g_giu.giu08
                     IF cl_null(g_giu.giu24) THEN
                        LET g_giu.giu24 = 0
                     END IF
                     IF g_giu.giu08 != g_giu.giu01 THEN
                        LET g_giu.giu24 = g_giu.giu24 + 1
                     END IF
                  END IF
               END IF             #No.FUN-A40020
            END IF
         END IF
 
      #No.TQC-790077  --Begin
      AFTER FIELD giu24
         IF g_giu.giu24 <=0 THEN
            CALL cl_err(g_giu.giu24,'ggl-816',0)
            LET g_giu.giu24 = g_giu_o.giu24
            DISPLAY BY NAME g_giu.giu24
            NEXT FIELD giu24
         END IF
         #No.FUN-A40020  --Begin                                                
         IF NOT cl_null(g_giu.giu24) AND NOT cl_null(g_giu.giu07) THEN          
            IF g_giu.giu07 = '2' AND g_giu.giu24 <> '99' THEN                   
               LET g_giu.giu24 = '99'                                           
               NEXT FIELD giu24                                                 
            END IF                                                              
            IF g_giu.giu07 = '3' AND g_giu.giu24 <> '1' THEN                    
               LET g_giu.giu24 = '1'                                            
               NEXT FIELD giu24                                                 
            END IF                                                              
         END IF                                                                 
         #No.FUN-A40020  --End
      #No.TQC-790077  --End  
 
      AFTER FIELD giu09
         LET g_giu_o.giu09 = g_giu.giu09
 
      # FUN-5C0015 06/03/10 (s)
      AFTER FIELD giu15
        IF NOT cl_null(g_giu.giu15) THEN
           CALL i010_chk_ahe(g_giu.giu15)
           IF g_errno THEN
              NEXT FIELD giu15
           END IF
        END IF
        LET g_ahe.ahe02_1 = NULL
        CALL i010_ahe02(g_giu.giu15)
                RETURNING g_ahe.ahe02_1
        DISPLAY BY NAME g_ahe.ahe02_1
 
      AFTER FIELD giu16
        IF NOT cl_null(g_giu.giu16) THEN
           CALL i010_chk_ahe(g_giu.giu16)
           IF g_errno THEN
              NEXT FIELD giu16
           END IF
        END IF
        LET g_ahe.ahe02_2 = NULL
        CALL i010_ahe02(g_giu.giu16)
                RETURNING g_ahe.ahe02_2
        DISPLAY BY NAME g_ahe.ahe02_2
 
      AFTER FIELD giu17
        IF NOT cl_null(g_giu.giu17) THEN
           CALL i010_chk_ahe(g_giu.giu17)
           IF g_errno THEN
              NEXT FIELD giu17
           END IF
        END IF
        LET g_ahe.ahe02_3 = NULL
        CALL i010_ahe02(g_giu.giu17)
                RETURNING g_ahe.ahe02_3
        DISPLAY BY NAME g_ahe.ahe02_3
 
      AFTER FIELD giu18
        IF NOT cl_null(g_giu.giu18) THEN
           CALL i010_chk_ahe(g_giu.giu18)
           IF g_errno THEN
              NEXT FIELD giu18
           END IF
        END IF
        LET g_ahe.ahe02_4 = NULL
        CALL i010_ahe02(g_giu.giu18)
                RETURNING g_ahe.ahe02_4
        DISPLAY BY NAME g_ahe.ahe02_4
 
      AFTER FIELD giu31
        IF NOT cl_null(g_giu.giu31) THEN
           CALL i010_chk_ahe(g_giu.giu31)
           IF g_errno THEN
              NEXT FIELD giu31
           END IF
        END IF
#FUN-A70002 ---------------------add start--------------------
        IF cl_null(g_aaz.aaz121) THEN                                          
            IF NOT cl_null(g_giu.giu31) THEN                                    
                CALL cl_err(g_giu.giu31,'agl-503',1)                            
                LET g_giu.giu31 = NULL                                          
                DISPLAY BY NAME g_giu.giu31                                     
                NEXT FIELD giu31                                                
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu31 <>g_aaz.aaz121 THEN                                     
            CALL cl_err(g_giu.giu31,'agl-503',1)                                
            LET g_giu.giu31 = g_giu_t.giu31                                     
            DISPLAY BY NAME g_giu.giu31                                         
            NEXT FIELD giu31                                                    
         END IF
#FUN-A70002 ------------------add end----------------------
        LET g_ahe.ahe02_5 = NULL
        CALL i010_ahe02(g_giu.giu31)
                RETURNING g_ahe.ahe02_5
        DISPLAY BY NAME g_ahe.ahe02_5
 
      AFTER FIELD giu32
        IF NOT cl_null(g_giu.giu32) THEN
           CALL i010_chk_ahe(g_giu.giu32)
           IF g_errno THEN
              NEXT FIELD giu32
           END IF
        END IF
#FUN-A70002 ----------------add start---------------------
        IF cl_null(g_aaz.aaz122) THEN                                          
            IF NOT cl_null(g_giu.giu32) THEN                                    
                CALL cl_err(g_giu.giu32,'agl-503',1)                            
                LET g_giu.giu32 = NULL                                          
                DISPLAY BY NAME g_giu.giu32                                     
                NEXT FIELD giu32                                                
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu32 <>g_aaz.aaz122 THEN                                     
            CALL cl_err(g_giu.giu32,'agl-503',1)                                
            LET g_giu.giu32 = g_giu_t.giu32                                     
            DISPLAY BY NAME g_giu.giu32                                         
            NEXT FIELD giu32                                                    
         END IF
#FUN-A70002 ---------------add end------------------------
        LET g_ahe.ahe02_6 = NULL
        CALL i010_ahe02(g_giu.giu32)
                RETURNING g_ahe.ahe02_6
        DISPLAY BY NAME g_ahe.ahe02_6
 
      AFTER FIELD giu33
        IF NOT cl_null(g_giu.giu33) THEN
           CALL i010_chk_ahe(g_giu.giu33)
           IF g_errno THEN
              NEXT FIELD giu33
           END IF
        END IF
#FUN-A70002 --------------add start-----------------------
        IF cl_null(g_aaz.aaz123) THEN                                          
            IF NOT cl_null(g_giu.giu33) THEN                                    
                CALL cl_err(g_giu.giu33,'agl-503',1)                            
                LET g_giu.giu33 = NULL                                          
                DISPLAY BY NAME g_giu.giu33                                     
                NEXT FIELD giu33                                                
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu33 <>g_aaz.aaz123 THEN                                     
            CALL cl_err(g_giu.giu33,'agl-503',1)                                
            LET g_giu.giu33 = g_giu_t.giu33                                     
            DISPLAY BY NAME g_giu.giu33                                         
            NEXT FIELD giu33                                                    
         END IF
#FUN-A70002 ------------add end---------------------------
        LET g_ahe.ahe02_7 = NULL
        CALL i010_ahe02(g_giu.giu33)
                RETURNING g_ahe.ahe02_7
        DISPLAY BY NAME g_ahe.ahe02_7
 
      AFTER FIELD giu34
        IF NOT cl_null(g_giu.giu34) THEN
           CALL i010_chk_ahe(g_giu.giu34)
           IF g_errno THEN
              NEXT FIELD giu34
           END IF
        END IF
#FUN-A70002 ----------add start----------------------------
        IF cl_null(g_aaz.aaz124) THEN                                          
            IF NOT cl_null(g_giu.giu34) THEN                                    
                CALL cl_err(g_giu.giu34,'agl-503',1)                            
                LET g_giu.giu34 = NULL                                          
                DISPLAY BY NAME g_giu.giu34                                     
                NEXT FIELD giu34                                                
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu34 <>g_aaz.aaz124 THEN                                     
            CALL cl_err(g_giu.giu34,'agl-503',1)                                
            LET g_giu.giu34 = g_giu_t.giu34                                     
            DISPLAY BY NAME g_giu.giu34                                         
            NEXT FIELD giu34                                                    
         END IF
#FUN-A70002 ---------add end--------------------------
        LET g_ahe.ahe02_8 = NULL
        CALL i010_ahe02(g_giu.giu34)
                RETURNING g_ahe.ahe02_8
        DISPLAY BY NAME g_ahe.ahe02_8
 
      AFTER FIELD giu35
        IF NOT cl_null(g_giu.giu35) THEN
           CALL i010_chk_ahe(g_giu.giu35)
           IF g_errno THEN
              NEXT FIELD giu35
           END IF
        END IF
        LET g_ahe.ahe02_9 = NULL
        CALL i010_ahe02(g_giu.giu35)
                RETURNING g_ahe.ahe02_9
        DISPLAY BY NAME g_ahe.ahe02_9
 
      AFTER FIELD giu36
        IF NOT cl_null(g_giu.giu36) THEN
           CALL i010_chk_ahe(g_giu.giu36)
           IF g_errno THEN
              NEXT FIELD giu36
           END IF
        END IF
        LET g_ahe.ahe02_10 = NULL
        CALL i010_ahe02(g_giu.giu36)
                RETURNING g_ahe.ahe02_10
        DISPLAY BY NAME g_ahe.ahe02_10
 
      AFTER FIELD giu37
        IF NOT cl_null(g_giu.giu37) THEN
           CALL i010_chk_ahe(g_giu.giu37)
           IF g_errno THEN
              NEXT FIELD giu37
           END IF
        END IF
        LET g_ahe.ahe02_11 = NULL
        CALL i010_ahe02(g_giu.giu37)
                RETURNING g_ahe.ahe02_11
        DISPLAY BY NAME g_ahe.ahe02_11
 
      AFTER FIELD giu20
        IF NOT cl_null(g_giu.giu20) THEN
           IF g_giu.giu20 = 'Y' THEN
              CALL cl_set_comp_required("giu222",TRUE)
           ELSE
              CALL cl_set_comp_required("giu222",FALSE)
           END IF
        END IF
      # FUN-5C0015 06/03/10 (e)
 
      AFTER FIELD giu221         #費用固定變動否
         LET g_giu_o.giu221 = g_giu.giu221
 
      AFTER FIELD giu222
         IF NOT cl_null(g_giu.giu222) THEN
            IF g_giu.giu222 NOT MATCHES '[12]' THEN
               NEXT FIELD giu222
            END IF
         END IF
 
      AFTER FIELD giu223
         IF NOT cl_null(g_giu.giu223) THEN
            CALL i010_aae(p_cmd,g_giu.giu223)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_giu.giu223 = g_giu_t.giu223
               DISPLAY BY NAME g_giu.giu223
               NEXT FIELD giu223
            END IF
         END IF
 
      AFTER FIELD giu224
         IF NOT cl_null(g_giu.giu224) THEN
            CALL i010_aae(p_cmd,g_giu.giu224)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_giu.giu224 = g_giu_t.giu224
               DISPLAY BY NAME g_giu.giu224
               NEXT FIELD giu224
            END IF
         END IF
 
      AFTER FIELD giu225
         IF NOT cl_null(g_giu.giu225) THEN
            CALL i010_aae(p_cmd,g_giu.giu225)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_giu.giu225 = g_giu_t.giu225
               DISPLAY BY NAME g_giu.giu225
               NEXT FIELD giu225
            END IF
         END IF
 
      AFTER FIELD giu226
         IF NOT cl_null(g_giu.giu226) THEN
            CALL i010_aae(p_cmd,g_giu.giu226)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_giu.giu226 = g_giu_t.giu226
               DISPLAY BY NAME g_giu.giu226
               NEXT FIELD giu226
            END IF
         END IF
 
      AFTER FIELD giu151
         IF g_giu.giu151 IS NOT NULL THEN
            IF g_giu.giu151 NOT MATCHES'[123]' THEN
               NEXT FIELD giu151
            END IF
         END IF
 
      AFTER FIELD giu161
         IF g_giu.giu161 IS NOT NULL THEN
            IF g_giu.giu161 NOT MATCHES'[123]' THEN
               NEXT FIELD giu161
            END IF
         END IF
 
      AFTER FIELD giu171
         IF g_giu.giu171 IS NOT NULL THEN
            IF g_giu.giu171 NOT MATCHES'[123]' THEN
               NEXT FIELD giu171
            END IF
         END IF
 
      AFTER FIELD giu181
         IF g_giu.giu181 IS NOT NULL  THEN
            IF g_giu.giu181 NOT MATCHES'[123]' THEN
               NEXT FIELD giu181
            END IF
         END IF
         # FUN-5C0015 06/03/10 (s)
{
         #no.6621
         IF g_giu.giu20 = 'Y' THEN
            IF NOT cl_null(g_giu.giu15) THEN
               IF cl_null(g_giu.giu151) OR g_giu.giu151 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu151
               END IF
            END IF
            IF NOT cl_null(g_giu.giu16) THEN
               IF cl_null(g_giu.giu161) OR g_giu.giu161 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu161
               END IF
            END IF
            IF NOT cl_null(g_giu.giu17) THEN
               IF cl_null(g_giu.giu171) OR g_giu.giu171 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu171
               END IF
            END IF
            IF NOT cl_null(g_giu.giu18) THEN
               IF cl_null(g_giu.giu181) OR g_giu.giu181 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu181
               END IF
            END IF
         END IF
         #no.6621(end)
}
         # FUN-5C0015 06/03/10 (e)
     
      # FUN-5C0015 06/03/10 (s)
      AFTER FIELD giu311
         IF g_giu.giu311 IS NOT NULL THEN
            IF g_giu.giu311 NOT MATCHES'[123]' THEN
               NEXT FIELD giu311
            END IF
         END IF
#FUN-A70002 ---------------add start--------------------
         IF cl_null(g_aaz.aaz1211) THEN                                         
            IF NOT cl_null(g_giu.giu311) THEN                                   
                CALL cl_err(g_giu.giu311,'agl-503',1)                           
                LET g_giu.giu311 = NULL                                         
                DISPLAY BY NAME g_giu.giu311                                    
                NEXT FIELD giu311                                               
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu311 <>g_aaz.aaz1211 THEN                                   
            CALL cl_err(g_giu.giu311,'agl-503',1)                               
            NEXT FIELD giu311                                                   
         END IF
#FUN-A70002 -------------add end----------------------
      
      AFTER FIELD giu321
         IF g_giu.giu321 IS NOT NULL THEN
            IF g_giu.giu321 NOT MATCHES'[123]' THEN
               NEXT FIELD giu321
            END IF
         END IF
#FUN-A70002 -----------add start-----------------------
         IF cl_null(g_aaz.aaz1221) THEN                                         
            IF NOT cl_null(g_giu.giu321) THEN                                   
                CALL cl_err(g_giu.giu321,'agl-503',1)                           
                LET g_giu.giu321 = NULL                                         
                DISPLAY BY NAME g_giu.giu321                                    
                NEXT FIELD giu321                                               
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu321<>g_aaz.aaz1221 THEN                                    
            CALL cl_err(g_giu.giu321,'agl-503',1)                               
            NEXT FIELD giu321                                                   
         END IF
#FUN-A70002 -----------add end------------------------
      AFTER FIELD giu331
         IF g_giu.giu331 IS NOT NULL THEN
            IF g_giu.giu331 NOT MATCHES'[123]' THEN
               NEXT FIELD giu331
            END IF
         END IF
#FUN-A70002 ----------add start---------------------
         IF cl_null(g_aaz.aaz1231) THEN                                         
            IF NOT cl_null(g_giu.giu331) THEN                                   
                CALL cl_err(g_giu.giu331,'agl-503',1)                           
                LET g_giu.giu331 = NULL                                         
                DISPLAY BY NAME g_giu.giu331                                    
                NEXT FIELD giu331                                               
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu331<>g_aaz.aaz1231 THEN                                    
            CALL cl_err(g_giu.giu331,'agl-503',1)                               
            NEXT FIELD giu331                                                   
         END IF
#FUN-A70002 ----------add end-------------------------

      AFTER FIELD giu341
         IF g_giu.giu341 IS NOT NULL THEN
            IF g_giu.giu341 NOT MATCHES'[123]' THEN
               NEXT FIELD giu341
            END IF
         END IF
#FUN-A70002 ----------add start------------------------
         IF cl_null(g_aaz.aaz1241) THEN                                         
            IF NOT cl_null(g_giu.giu341) THEN                                   
                CALL cl_err(g_giu.giu341,'agl-503',1)                           
                LET g_giu.giu341 = NULL                                         
                DISPLAY BY NAME g_giu.giu341                                    
                NEXT FIELD giu341                                               
            END IF                                                              
         END IF                                                                 
         IF g_giu.giu341<>g_aaz.aaz1241 THEN                                    
            CALL cl_err(g_giu.giu341,'agl-503',1)                               
            NEXT FIELD giu341                                                   
         END IF 
#FUN-A70002 ---------add end----------------------------

      AFTER FIELD giu351
         IF g_giu.giu351 IS NOT NULL THEN
            IF g_giu.giu351 NOT MATCHES'[123]' THEN
               NEXT FIELD giu351
            END IF
         END IF
 
      AFTER FIELD giu361
         IF g_giu.giu361 IS NOT NULL THEN
            IF g_giu.giu361 NOT MATCHES'[123]' THEN
               NEXT FIELD giu361
            END IF
         END IF
 
      AFTER FIELD giu371
         IF g_giu.giu371 IS NOT NULL THEN
            IF g_giu.giu371 NOT MATCHES'[1234]' THEN      #MOD-A70002 add 4
               NEXT FIELD giu371
            END IF
         END IF
      # FUN-5C0015 06/03/10 (e)
 
     
      # FUN-5C0015 06/03/10 (s)
      #AFTER FIELD giu18
      #   IF g_giu.giu20='Y' THEN
      #      IF cl_null(g_giu.giu15) AND cl_null(g_giu.giu16) AND
      #         cl_null(g_giu.giu17) AND cl_null(g_giu.giu18) THEN
      #         CALL cl_err(g_giu.giu20,'agl-914',1)
      #         NEXT FIELD giu20
      #      END IF
      #   END IF
      # FUN-5C0015 06/03/10 (e)
 
      AFTER FIELD giu19
         IF g_giu.giu19 IS NOT NULL THEN
           #IF g_giu.giu19 <0 OR g_giu.giu19 > 31 THEN     #MOD-A60204 mark
            IF g_giu.giu19 <0 OR g_giu.giu19 > 37 THEN     #MOD-A60204
               LET g_giu.giu19 = g_giu_o.giu19
               DISPLAY BY NAME g_giu.giu19
               NEXT FIELD giu19
            END IF
            LET g_giu_o.giu19 = g_giu.giu19
         END IF
 
      AFTER FIELD giu21
         LET g_giu_o.giu21 = g_giu.giu21
 
      AFTER FIELD giu23
         LET g_giu_o.giu23 = g_giu.giu23

      #No.FUN-A30077  --Begin                                                   
      AFTER FIELD giu42                                                         
         LET g_giu_o.giu42 = g_giu.giu42                                        
      #No.FUN-A30077  --End
 
      AFTER INPUT
         LET g_giu.giuuser = s_get_data_owner("giu_file") #FUN-C10039
         LET g_giu.giugrup = s_get_data_group("giu_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF cl_null(g_giu.giu20) THEN
            NEXT FIELD giu20
         END IF
 
         IF g_giu.giu20='N' THEN
            LET g_giu.giu222 = ''
            DISPLAY BY NAME g_giu.giu222
         END IF
 
         IF g_giu.giu20='Y' THEN
            IF cl_null(g_giu.giu222) OR g_giu.giu222 NOT MATCHES '[12]' THEN
               NEXT FIELD giu222
            END IF
 
            # FUN-5C0015 06/03/10 (s)
            #IF cl_null(g_giu.giu15) AND cl_null(g_giu.giu16) AND
            #   cl_null(g_giu.giu17) AND cl_null(g_giu.giu18) THEN
            #   CALL cl_err(g_giu.giu20,'agl-914',1)
            #   NEXT FIELD giu20
            #END IF
 
            IF cl_null(g_giu.giu15) AND cl_null(g_giu.giu16) AND
               cl_null(g_giu.giu17) AND cl_null(g_giu.giu18) AND
               cl_null(g_giu.giu31) AND cl_null(g_giu.giu32) AND
               cl_null(g_giu.giu33) AND cl_null(g_giu.giu34) AND
               cl_null(g_giu.giu35) AND cl_null(g_giu.giu36) AND
               cl_null(g_giu.giu37) THEN
               CALL cl_err(g_giu.giu20,'agl-914',1)
               NEXT FIELD giu20
            END IF
            # FUN-5C0015 06/03/10 (e)
 
            #no.6621
            IF NOT cl_null(g_giu.giu15) THEN
               IF cl_null(g_giu.giu151) OR g_giu.giu151 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu151
               END IF
            END IF
 
            IF NOT cl_null(g_giu.giu16) THEN
               IF cl_null(g_giu.giu161) OR g_giu.giu161 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu161
               END IF
            END IF
 
            IF NOT cl_null(g_giu.giu17) THEN
               IF cl_null(g_giu.giu171) OR g_giu.giu171 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu171
               END IF
            END IF
 
            IF NOT cl_null(g_giu.giu18) THEN
               IF cl_null(g_giu.giu181) OR g_giu.giu181 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu181
               END IF
            END IF
 
            #FUN-5C001506/03/10 (s)
            IF NOT cl_null(g_giu.giu31) THEN
               IF cl_null(g_giu.giu311) OR g_giu.giu311 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu311
               END IF
            END IF
            IF NOT cl_null(g_giu.giu32) THEN
               IF cl_null(g_giu.giu321) OR g_giu.giu321 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu321
               END IF
            END IF
            IF NOT cl_null(g_giu.giu33) THEN
               IF cl_null(g_giu.giu331) OR g_giu.giu331 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu331
               END IF
            END IF
            IF NOT cl_null(g_giu.giu34) THEN
               IF cl_null(g_giu.giu341) OR g_giu.giu341 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu341
               END IF
            END IF
            IF NOT cl_null(g_giu.giu35) THEN
               IF cl_null(g_giu.giu351) OR g_giu.giu351 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu351
               END IF
            END IF
            IF NOT cl_null(g_giu.giu36) THEN
               IF cl_null(g_giu.giu361) OR g_giu.giu361 NOT MATCHES '[23]' THEN
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu361
               END IF
            END IF
            IF NOT cl_null(g_giu.giu37) THEN
               IF cl_null(g_giu.giu371) OR g_giu.giu371 NOT MATCHES '[234]' THEN     #MOD-A70002 add 4
                  CALL cl_err('','agl-923',1)
                  NEXT FIELD giu371
               END IF
            END IF
            #FUN-5C001506/03/10 (e)
            #no.6621
         END IF
  
         #FUN-5C001506/03/10 (s)
         #異動碼輸入控制若有值，則異動碼類型代號也要有值!
         IF NOT cl_null(g_giu.giu151) THEN
            IF cl_null(g_giu.giu15) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu15
            END IF
         END IF
         IF NOT cl_null(g_giu.giu161) THEN
            IF cl_null(g_giu.giu16) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu16
            END IF
         END IF
         IF NOT cl_null(g_giu.giu171) THEN
            IF cl_null(g_giu.giu17) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu17
            END IF
         END IF
         IF NOT cl_null(g_giu.giu181) THEN
            IF cl_null(g_giu.giu18) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu18
            END IF
         END IF
         IF NOT cl_null(g_giu.giu311) THEN
            IF cl_null(g_giu.giu31) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu31
            END IF
         END IF
         IF NOT cl_null(g_giu.giu321) THEN
            IF cl_null(g_giu.giu32) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu32
            END IF
         END IF
         IF NOT cl_null(g_giu.giu331) THEN
            IF cl_null(g_giu.giu33) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu33
            END IF
         END IF
         IF NOT cl_null(g_giu.giu341) THEN
            IF cl_null(g_giu.giu34) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu34
            END IF
         END IF
         IF NOT cl_null(g_giu.giu351) THEN
            IF cl_null(g_giu.giu35) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu35
            END IF
         END IF
         IF NOT cl_null(g_giu.giu361) THEN
            IF cl_null(g_giu.giu36) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu36
            END IF
         END IF
         IF NOT cl_null(g_giu.giu371) THEN
            IF cl_null(g_giu.giu37) THEN
               CALL cl_err('','agl-029',1)
               NEXT FIELD giu37
            END IF
         END IF
         #FUN-5C001506/03/10 (e)
        
 
         IF cl_null(g_giu.giu02) THEN
            DISPLAY BY NAME g_giu.giu02
            NEXT FIELD giu02
         END IF
 
         IF cl_null(g_giu.giu03) OR g_giu.giu03 NOT MATCHES'[24]' THEN
            DISPLAY BY NAME g_giu.giu03
            NEXT FIELD giu03
         END IF
 
         IF cl_null(g_giu.giu04) OR g_giu.giu04 NOT MATCHES'[12]' THEN
            DISPLAY BY NAME g_giu.giu04
            NEXT FIELD giu04
         END IF
 
         IF cl_null(g_giu.giu05) OR g_giu.giu05 NOT MATCHES'[YN]' THEN
            DISPLAY BY NAME g_giu.giu05
            NEXT FIELD giu05
         END IF
 
         IF cl_null(g_giu.giu06) OR g_giu.giu06 NOT MATCHES'[12]' THEN
            DISPLAY BY NAME g_giu.giu06
            NEXT FIELD giu06
         END IF
 
         IF cl_null(g_giu.giu07) THEN
            DISPLAY BY NAME g_giu.giu07
            NEXT FIELD giu07
         END IF
 
         IF g_giu.giu07='2' AND cl_null(g_giu.giu08) THEN
            NEXT FIELD giu08
         END IF
 
        #MOD-650015 --start 
     # ON ACTION CONTROLO                        # 沿用所有欄位
     #    IF INFIELD(giu01) THEN
     #       LET g_giu.* = g_giu_t.*
     #       CALL i010_show()
     #       NEXT FIELD giu01
     #    END IF
        #MOD-650015 --end 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(giu223)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_giu.giu223
               CALL cl_create_qry() RETURNING g_giu.giu223
               DISPLAY BY NAME g_giu.giu223
               NEXT FIELD giu223
            WHEN INFIELD(giu224)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_giu.giu224
               CALL cl_create_qry() RETURNING g_giu.giu224
               DISPLAY BY NAME g_giu.giu224
               NEXT FIELD giu224
            WHEN INFIELD(giu225)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_giu.giu225
               CALL cl_create_qry() RETURNING g_giu.giu225
               DISPLAY BY NAME g_giu.giu225
               NEXT FIELD giu225
            WHEN INFIELD(giu226)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aae"
               LET g_qryparam.default1 = g_giu.giu226
               CALL cl_create_qry() RETURNING g_giu.giu226
               DISPLAY BY NAME g_giu.giu226
               NEXT FIELD giu226
            WHEN INFIELD(giu08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_giu"
               LET g_qryparam.default1 = g_giu.giu08
               LET g_qryparam.where =" giu07 ='1' AND giu03 ='2'"
               CALL cl_create_qry() RETURNING g_giu.giu08
               DISPLAY BY NAME g_giu.giu08
               NEXT FIELD giu08
            # FUN-5C0015 06/03/10 (s)
            WHEN INFIELD(giu15)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu15
               CALL cl_create_qry() RETURNING g_giu.giu15
               DISPLAY BY NAME g_giu.giu15
               NEXT FIELD giu15
            WHEN INFIELD(giu16)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu16
               CALL cl_create_qry() RETURNING g_giu.giu16
               DISPLAY BY NAME g_giu.giu16
               NEXT FIELD giu16
            WHEN INFIELD(giu17)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu17
               CALL cl_create_qry() RETURNING g_giu.giu17
               DISPLAY BY NAME g_giu.giu17
               NEXT FIELD giu17
            WHEN INFIELD(giu18)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu18
               CALL cl_create_qry() RETURNING g_giu.giu18
               DISPLAY BY NAME g_giu.giu18
               NEXT FIELD giu18
            WHEN INFIELD(giu31)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu31
               CALL cl_create_qry() RETURNING g_giu.giu31
               DISPLAY BY NAME g_giu.giu31
               NEXT FIELD giu31
            WHEN INFIELD(giu32)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu32
               CALL cl_create_qry() RETURNING g_giu.giu32
               DISPLAY BY NAME g_giu.giu32
               NEXT FIELD giu32
            WHEN INFIELD(giu33)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu33
               CALL cl_create_qry() RETURNING g_giu.giu33
               DISPLAY BY NAME g_giu.giu33
               NEXT FIELD giu33
            WHEN INFIELD(giu34)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu34
               CALL cl_create_qry() RETURNING g_giu.giu34
               DISPLAY BY NAME g_giu.giu34
               NEXT FIELD giu34
            WHEN INFIELD(giu35)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu35
               CALL cl_create_qry() RETURNING g_giu.giu35
               DISPLAY BY NAME g_giu.giu35
               NEXT FIELD giu35
            WHEN INFIELD(giu36)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu36
               CALL cl_create_qry() RETURNING g_giu.giu36
               DISPLAY BY NAME g_giu.giu36
               NEXT FIELD giu36
            WHEN INFIELD(giu37)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ahe"
               LET g_qryparam.default1 = g_giu.giu37
               CALL cl_create_qry() RETURNING g_giu.giu37
               DISPLAY BY NAME g_giu.giu37
               NEXT FIELD giu37
            # FUN-5C0015 06/03/10 (e)
            OTHERWISE
               EXIT CASE
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
 
FUNCTION i010_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("giu01,giu00",TRUE)
   END IF
 
   IF INFIELD(giu07) OR ( NOT g_before_input_done ) THEN
      # FUN-5C0015 06/03/10 (s)
      #CALL cl_set_comp_entry("giu08,giu24,giu15,giu16,giu17,giu18,giu151,giu161,giu171,giu181,giu20,giu21,giu221,giu222,giu223,giu224,giu225,giu226,giu23",TRUE)
      CALL cl_set_comp_entry("giu08,giu24,giu15,giu16,giu17,giu18,giu151,giu161,giu171,giu181,giu20,giu21,giu221,giu222,giu223,giu224,giu225,giu226,giu23,giu31,giu311,giu32,giu321,giu33,giu331,giu34,giu341,giu35,giu351,giu36,giu361,giu37,giu371",TRUE)
      CALL cl_set_comp_entry("giu42",TRUE)      #No.FUN-A30077
      # FUN-5C0015 06/03/10 (e)
   END IF
 
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("giu01,giu00",FALSE)
   END IF
 
   IF INFIELD(giu07) OR ( NOT g_before_input_done ) THEN
     #CHI-710005 --begin
     #IF g_giu.giu07 MATCHES '[13]' AND g_aza.aza26 ! = '2' THEN
     #   CALL cl_set_comp_entry("giu08",FALSE)
     #END IF
     #CHI-710005 --end
      IF g_giu.giu07 = "1" THEN
         # FUN-5C0015 06/03/10 (s)
         #CALL cl_set_comp_entry("giu15,giu16,giu17,giu18,giu151,giu161,giu171,giu181,giu20,giu21,giu221,giu222,giu223,giu224,giu225,giu226,giu23",FALSE)
         CALL cl_set_comp_entry("giu15,giu16,giu17,giu18,giu151,giu161,giu171,giu181,giu20,giu21,giu221,giu222,giu223,giu224,giu225,giu226,giu23i,giu31,giu311,giu32,giu321,giu33,giu331,giu34,giu341,giu35,giu351,giu36,giu361,giu37,giu371",FALSE)
         CALL cl_set_comp_entry("giu42",FALSE)  #No.FUN-A30077
         # FUN-5C0015 06/03/10 (e)
      END IF
   END IF
 
   #CHI-710005 --begin
  #IF (NOT g_before_input_done) THEN
  #   IF g_aza.aza26 ! = '2' THEN
  #      CALL cl_set_comp_entry("giu24",FALSE)
  #   END IF
  #END IF
   #CHI-710005 --end
 
END FUNCTION
FUNCTION i010_aae(p_cmd,p_type)
DEFINE   p_cmd       LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
         p_type      LIKE giu_file.giu223,
         l_aaeacti   LIKE aae_file.aaeacti
 
   LET g_errno = ' '
 
   SELECT aaeacti INTO l_aaeacti FROM aae_file
    WHERE aae01 = p_type
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_aaeacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
END FUNCTION
 
FUNCTION i010_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_giu.* TO NULL              #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i010_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   OPEN i010_count
   FETCH i010_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i010_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)
      INITIALIZE g_giu.* TO NULL
   ELSE
      CALL i010_fetch('F')                  # 讀出TEMP第一筆并顯示
   END IF
   CALL i010_list()                         #No.FUN-820030 
 
END FUNCTION
 
#No.FUN-820030---Begin
FUNCTION i010_list()
   DEFINE l_i   LIKE  type_file.num5
   
   LET l_i = 1
 
   FOREACH i010_cs_list INTO g_giux[l_i].*                                                                                          
      IF SQLCA.sqlcode THEN                                                                                                    
         CALL cl_err('insert',SQLCA.sqlcode,2)                                                                                 
         EXIT FOREACH                                                                                                          
      END IF 
      LET g_giux[l_i].sel   = 'Y'                        
      LET l_i = l_i + 1                                                                                          
   END FOREACH
   CALL g_giux.deleteElement(l_i)
   LET l_i = l_i - 1
END FUNCTION
#No.FUN-820030---End
 
FUNCTION i010_fetch(p_flgiu)
DEFINE p_flgiu          LIKE type_file.chr1,         #No.FUN-680098  VARCHAR(1)
       l_abso           LIKE type_file.num10         #No.FUN-680098  INTEGER
 
   CASE p_flgiu
      WHEN 'N' FETCH NEXT     i010_cs INTO g_giu.giu00,g_giu.giu01
      WHEN 'P' FETCH PREVIOUS i010_cs INTO g_giu.giu00,g_giu.giu01
      WHEN 'F' FETCH FIRST    i010_cs INTO g_giu.giu00,g_giu.giu01
      WHEN 'L' FETCH LAST     i010_cs INTO g_giu.giu00,g_giu.giu01
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
         FETCH ABSOLUTE g_jump i010_cs INTO g_giu.giu00,g_giu.giu01  #05/08/05
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)
      INITIALIZE g_giu.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flgiu
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_giu.* FROM giu_file            # 重讀DB,因TEMP有不被更新特性
    WHERE giu00 = g_giu.giu00 AND giu01 = g_giu.giu01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","giu_file",g_giu.giu01,g_giu.giu00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
   ELSE
      LET g_data_owner = g_giu.giuuser     #No.FUN-4C0048
      LET g_data_group = g_giu.giugrup     #No.FUN-4C0048
 
      CALL i010_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i010_show()
 
   LET g_giu_t.* = g_giu.*
   LET g_giu_o.* = g_giu.*
 
   # FUN-5C0015 06/03/10 (s) 
   INITIALIZE g_ahe.* TO NULL
   CALL i010_ahe02(g_giu.giu15) RETURNING g_ahe.ahe02_1
   CALL i010_ahe02(g_giu.giu16) RETURNING g_ahe.ahe02_2
   CALL i010_ahe02(g_giu.giu17) RETURNING g_ahe.ahe02_3
   CALL i010_ahe02(g_giu.giu18) RETURNING g_ahe.ahe02_4
   CALL i010_ahe02(g_giu.giu31) RETURNING g_ahe.ahe02_5
   CALL i010_ahe02(g_giu.giu32) RETURNING g_ahe.ahe02_6
   CALL i010_ahe02(g_giu.giu33) RETURNING g_ahe.ahe02_7
   CALL i010_ahe02(g_giu.giu34) RETURNING g_ahe.ahe02_8
   CALL i010_ahe02(g_giu.giu35) RETURNING g_ahe.ahe02_9
   CALL i010_ahe02(g_giu.giu36) RETURNING g_ahe.ahe02_10
   CALL i010_ahe02(g_giu.giu37) RETURNING g_ahe.ahe02_11
   # FUN-5C0015 06/03/10 (s) 
 
   DISPLAY BY NAME g_giu.giu00, g_giu.giu01, g_giu.giu02, g_giu.giu03, g_giu.giuoriu,g_giu.giuorig,
                   g_giu.giu04, g_giu.giu06, g_giu.giu09, g_giu.giu12,g_giu.giu38, #FUN-670032 add giu38
                   g_giu.giu221,g_giu.giu223,g_giu.giu224,g_giu.giu225,
                   g_giu.giu226,g_giu.giu19, g_giu.giu07, g_giu.giu08,
                   g_giu.giu24, g_giu.giu05, g_giu.giu21, g_giu.giu23,
                   g_giu.giu42,              #No.FUN-A30077
                   g_giu.giu20, g_giu.giu222,g_giu.giu15, g_giu.giu151,
                   g_giu.giu16, g_giu.giu161,g_giu.giu17, g_giu.giu171,
                   g_giu.giu18, g_giu.giu181,g_giu.giu13, g_giu.giu14,
                   # FUN-5C0015 06/03/10 (s)
                   g_giu.giu31,g_giu.giu311,g_giu.giu32,g_giu.giu321,
                   g_giu.giu33,g_giu.giu331,g_giu.giu34,g_giu.giu341,
                   g_giu.giu35,g_giu.giu351,g_giu.giu36,g_giu.giu361,
                   g_giu.giu37,g_giu.giu371,
                   # FUN-5C0015 06/03/10 (e)
                   g_giu.giu39,       #No.FUN-820030 
                   g_giu.giuuser, g_giu.giugrup, g_giu.giudate,
                   g_giu.giumodu, g_giu.giuacti
 
   DISPLAY BY NAME g_ahe.*    # FUN-5C0015 06/03/10
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_ahe.*    # FUN-5C0015 06/03/10
   DISPLAY BY NAME g_ahe.ahe02_1,g_ahe.ahe02_2,g_ahe.ahe02_3,g_ahe.ahe02_4,g_ahe.ahe02_5,
                   g_ahe.ahe02_6,g_ahe.ahe02_7,g_ahe.ahe02_8,g_ahe.ahe02_9,g_ahe.ahe02_10,
                   g_ahe.ahe02_11
   #No.FUN-9A0024--end  
   CALL cl_set_field_pic("","","","","",g_giu.giuacti)
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i010_u()
 
   IF g_giu.giu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_giu.* FROM giu_file
    WHERE giu01=g_giu.giu01 AND giu00=g_giu.giu00
 
    #No.FUN-820030  --Begin                                                     
    IF NOT s_dc_ud_flag('6',g_giu.giu39,g_plant,'u') THEN                       
       CALL cl_err(g_giu.giu39,'aoo-045',1)                                     
       RETURN                                                                   
    END IF                                                                      
    #No.FUN-820030  --End    
   IF g_giu.giuacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_giu.giu01,'9027',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_giu01_t = g_giu.giu01
   LET g_giu00_t = g_giu.giu00
   LET g_giu_o.*=g_giu.*
   BEGIN WORK
 
   OPEN i010_cl USING g_giu.giu00,g_giu.giu01
   IF STATUS THEN
      CALL cl_err("OPEN i010_cl:", STATUS, 1)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i010_cl INTO g_giu.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_giu.giumodu=g_user                     #修改者
   LET g_giu.giudate = g_today                  #修改日期
 
   CALL i010_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i010_i("u")                      # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_giu.*=g_giu_t.*
         CALL i010_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
     #CHI-710005  --begin
     #IF g_aza.aza26 != '2' AND g_giu.giu07 != '2' THEN          #No.A056
     #   LET g_giu.giu08 = g_giu.giu01
     #END IF
     #CHI-710005  --end
 
      UPDATE giu_file SET giu_file.* = g_giu.*    # 更新DB
       WHERE giu00 = g_giu.giu00 AND giu01 = g_giu.giu01             # COLAUTH?
 
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","giu_file",g_giu.giu01,g_giu.giu00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i010_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i010_x()
DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF g_giu.giu01 IS NULL OR g_giu.giu00 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #No.FUN-820030  --Begin                                                     
   IF NOT s_dc_ud_flag('6',g_giu.giu39,g_plant,'u') THEN                       
      CALL cl_err(g_giu.giu39,'aoo-045',1)                                     
      RETURN                                                                   
   END IF                                                                      
   #No.FUN-820030  --End    
 
   BEGIN WORK
 
   OPEN i010_cl USING g_giu.giu00,g_giu.giu01
   IF STATUS THEN
      CALL cl_err("OPEN i010_cl:", STATUS, 1)
      CLOSE i010_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i010_cl INTO g_giu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i010_show()
 
   IF cl_exp(16,21,g_giu.giuacti) THEN        #確認一下
      LET g_chr=g_giu.giuacti
      IF g_giu.giuacti='Y' THEN
         LET g_giu.giuacti='N'
      ELSE
         LET g_giu.giuacti='Y'
      END IF
 
      UPDATE giu_file SET giuacti = g_giu.giuacti,
                          giumodu = g_user,
                          giudate = g_today
       WHERE giu00 = g_giu.giu00 AND giu01 = g_giu.giu01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","giu_file",g_giu.giu01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         LET g_giu.giuacti=g_chr
      END IF
      DISPLAY BY NAME g_giu.giuacti
   END IF
 
   CLOSE i010_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i010_r()
DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF g_giu.giu01 IS NULL OR g_giu.giu00 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_giu.giuacti = 'N' THEN CALL cl_err('','abm-950',0) RETURN END IF             #TQC-950024
 
    #No.FUN-820030  --Begin                                                     
    IF NOT s_dc_ud_flag('6',g_giu.giu39,g_plant,'r') THEN                       
       CALL cl_err(g_giu.giu39,'aoo-044',1)                                     
       RETURN                                                                   
    END IF                                                                      
    #No.FUN-820030  --End 
    BEGIN WORK
 
    OPEN i010_cl USING g_giu.giu00,g_giu.giu01
    IF STATUS THEN
       CALL cl_err("OPEN i010_cl:", STATUS, 1)
       CLOSE i010_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i010_cl INTO g_giu.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)    #資料被他人LOCK
       RETURN
    END IF
    CALL i010_show()
#.........................................................
 
    IF cl_delete() THEN                    #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "giu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_giu.giu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM giu_file WHERE giu01 = g_giu.giu01 AND giu00 = g_giu.giu00
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_giu.giu01,SQLCA.sqlcode,0)   #No.FUN-660123
          CALL cl_err3("del","giu_file",g_giu.giu01,g_giu.giu00,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       ELSE
          CLEAR FORM
       END IF
 
       OPEN i010_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end-- 
       FETCH i010_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i010_cs
          CLOSE i010_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i010_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i010_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i010_fetch('/')
       END IF
    END IF
    CLOSE i010_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_copy()
   DEFINE l_giu             RECORD LIKE giu_file.*,
          l_oldno,l_newno   LIKE giu_file.giu01,
          l_oldno1,l_newno1 LIKE giu_file.giu00
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_giu.giu01 IS NULL AND g_giu.giu00 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i010_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1,l_newno FROM giu00,giu01
 
        AFTER FIELD giu01
           IF l_newno IS NOT  NULL AND l_newno1 IS NOT NULL THEN
              SELECT COUNT(*) INTO g_cnt FROM giu_file
               WHERE giu01 = l_newno AND giu00 = l_newno1
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD giu01
              END IF
           END IF
 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_giu.giu01
       RETURN
    END IF
    LET l_giu.* = g_giu.*
    LET l_giu.giu01  = l_newno               #資料鍵值
    LET l_giu.giu00  = l_newno1
    LET l_giu.giuacti ='Y'                   #有效的資料
    LET l_giu.giuuser = g_user
    LET l_giu.giugrup = g_grup               #使用者所屬群
    LET l_giu.giudate = g_today
    LET l_giu.giu39  = g_plant               #No.FUN-820030
    LET l_giu.giuoriu = g_user      #No.FUN-980030 10/01/04
    LET l_giu.giuorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO giu_file VALUES (l_giu.*)
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("ins","giu_file",l_newno,l_newno1,SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno  = g_giu.giu01
       LET l_oldno1 = g_giu.giu00
       SELECT giu_file.* INTO g_giu.* FROM giu_file
                      WHERE giu01 = l_newno AND giu00 = l_newno1               #05/08/05
       CALL i010_u()
       #SELECT giu_file.* INTO g_giu.* FROM giu_file  #FUN-C30027
       #               WHERE giu01 = l_oldno AND giu00 = l_newno1         #05/08/05  #FUN-C30027
    END IF
    CALL i010_show()
END FUNCTION
 
#從多地區科目資料檔中轉入到正式科目檔
FUNCTION i010_p()
   DEFINE l_area        LIKE giu_file.giu00
   DEFINE l_plant       LIKE azp_file.azp01
   DEFINE l_k           LIKE type_file.chr1     #MOD-640376  #No.FUN-680098  VARCHAR(1)
   DEFINE l_bookno      LIKE aag_file.aag00     #No.FUN-730070
   DEFINE l_plant_t     LIKE azp_file.azp01
   DEFINE l_dbs_t       LIKE azp_file.azp03
   DEFINE l_dbs         LIKE azp_file.azp03
   DEFINE l_aag         RECORD LIKE aag_file.*
   DEFINE l_giu         RECORD LIKE giu_file.*
   DEFINE l_flag        LIKE type_file.num5     #No.FUN-680098   SMALLINT
   DEFINE l_zx06	LIKE zx_file.zx06
   DEFINE l_cnt         LIKE type_file.num5     #MOD-640376        #No.FUN-680098  SMALLINT
 
   LET l_plant_t=g_plant
   LET l_k = '1'   #MOD-640080
 
   OPEN WINDOW i010p_w AT 5,10
        WITH FORM "agl/42f/agli010p"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("agli010p")
 
   WHILE TRUE
       CLEAR FORM
       LET l_area =g_aza.aza26
       LET l_plant=g_plant
       LET l_bookno = g_aza.aza81  #No.FUN-730070
       DISPLAY l_area  TO FORMONLY.area
       DISPLAY l_plant TO FORMONLY.plant
       DISPLAY l_bookno TO FORMONLY.bookno  #No.FUN-730070 
       #INPUT l_plant,l_area WITHOUT DEFAULTS FROM FORMONLY.plant,FORMONLY.area   #MOD-640376
       INPUT l_plant,l_area,l_bookno,l_k WITHOUT DEFAULTS  #No.FUN-730070
        FROM FORMONLY.plant,FORMONLY.area,FORMONLY.bookno,FORMONLY.k   #MOD-640376  #No.FUN-730070
 
#         BEFORE FIELD plant
#            IF cl_null(plant) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"
#               LET g_qryparam.default1 = g_plant
#               LET g_qryparam.arg1 = g_user
#               LET g_qryparam.construct = 'N'
#               CALL cl_create_qry() RETURNING l_plant
#               DISPLAY l_plant TO FORMONLY.plant
#            END IF
 
         AFTER FIELD plant
            IF cl_null(l_plant) THEN NEXT FIELD plant END IF
            SELECT azp02 FROM azp_file WHERE azp01=l_plant
            IF STATUS THEN
#              CALL cl_err('sel azp:',STATUS,0)    #No.FUN-660123
               CALL cl_err3("sel","azp_file",l_plant,"",STATUS,"","sel azp:",1)  #No.FUN-660123
               NEXT FIELD plant
            END IF
            SELECT zx06 INTO l_zx06 FROM zx_file WHERE zx01=g_user
            IF STATUS THEN
#              CALL cl_err('sel zx06:',STATUS,0)   #No.FUN-660123
               CALL cl_err3("sel","zx_file",g_user,"",STATUS,"","sel zx06:",1)  #No.FUN-660123
            END IF
            IF l_plant_t<>l_plant THEN
               IF s_chkdbs(g_user,l_plant,l_zx06)=FALSE THEN
                  NEXT FIELD plant
               END IF
            END IF
 
         AFTER FIELD area
            IF cl_null(l_area) THEN
               NEXT FIELD area
            END IF
            IF l_area NOT MATCHES '[0123]' THEN   #MOD-BA0021 add 3
               NEXT FIELD area
            END IF
 
         #No.FUN-730070  --Begin
         AFTER FIELD bookno
            IF NOT cl_null(l_bookno) THEN
              #CALL i010_bookno('a',l_bookno)          #MOD-930319 mark
               CALL i010_bookno('a',l_bookno,l_plant)  #MOD-930319
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_bookno,g_errno,0)
                  NEXT FIELD bookno
               END IF
            END IF
         #No.FUN-730070  --End
 
         #-----MOD-640080---------
         AFTER FIELD k
            IF l_k NOT MATCHES '[12]' THEN 
               NEXT FIELD k
            END IF
         #-----END MOD-640080-----
 
         ON ACTION controlp
            CASE WHEN INFIELD(plant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zxy"
                 LET g_qryparam.arg1 = g_user
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = l_plant
                 CALL cl_create_qry() RETURNING l_plant
                 DISPLAY l_plant TO FORMONLY.plant
                 NEXT FIELD plant
            #No.FUN-730070  --Begin
            WHEN INFIELD(bookno)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa4"   #FUN-580063   #CHI-940002 q_aaa->q_aaa4
              #str CHI-940002 add
               LET l_dbs = ''
               SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_plant
#              LET g_qryparam.arg1 = l_dbs               #No.TQC-9B0069
               LET g_qryparam.plant = l_plant            #No.TQC-9B0069
              #end CHI-940002 add
               LET g_qryparam.default1 = l_bookno
               CALL cl_create_qry() RETURNING l_bookno
               DISPLAY l_bookno TO bookno 
               NEXT FIELD bookno
            #No.FUN-730070  --End  
            END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
         ON ACTION about
            CALL cl_about()
         ON ACTION help
            CALL cl_show_help()
       END INPUT
 
       IF INT_FLAG THEN                         # 若按了DEL鍵
          LET INT_FLAG = 0
          EXIT WHILE
       END IF
 
       LET g_success='Y'
       IF cl_sure(21,21) THEN
          CALL cl_wait()
          SELECT azp03 INTO l_dbs FROM azp_file
           WHERE azp01 = l_plant
          IF STATUS THEN
#            CALL cl_err('select db',SQLCA.sqlcode,2)   #No.FUN-660123
             CALL cl_err3("sel","azp_file",l_plant,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
             LET g_success='N'
             EXIT WHILE
          END IF
          BEGIN WORK
          #-----MOD-640376---------
          #LET g_sql="DELETE FROM ",l_dbs CLIPPED,".dbo.aag_file"
          #PREPARE i010_d FROM g_sql
          #EXECUTE i010_d
          #IF SQLCA.sqlcode THEN
          #   CALL cl_err('delete',SQLCA.sqlcode,2)
          #   LET g_success='N'
          #   EXIT WHILE
          #END IF
          #-----END MOD-640376-----
          DECLARE i010p_cur CURSOR FOR
           SELECT * FROM giu_file
            WHERE giu00=l_area
 
          FOREACH i010p_cur INTO l_giu.*
             IF SQLCA.sqlcode THEN
                CALL cl_err('insert',SQLCA.sqlcode,2)   
                EXIT FOREACH
             END IF
             LET l_aag.aag00 = l_bookno  #No.FUN-730070
             LET l_aag.aag01 = l_giu.giu01  LET l_aag.aag02 = l_giu.giu02
             LET l_aag.aag03 = l_giu.giu03  LET l_aag.aag04 = l_giu.giu04
             LET l_aag.aag05 = l_giu.giu05  LET l_aag.aag06 = l_giu.giu06
             LET l_aag.aag07 = l_giu.giu07  LET l_aag.aag08 = l_giu.giu08
             LET l_aag.aag09 = l_giu.giu09  LET l_aag.aag10 = l_giu.giu10
             LET l_aag.aag11 = l_giu.giu11  LET l_aag.aag12 = l_giu.giu12
             LET l_aag.aag38 = l_giu.giu38  #FUN-670032 add giu38
             LET l_aag.aag13 = l_giu.giu13  LET l_aag.aag14 = l_giu.giu14
             LET l_aag.aag15 = l_giu.giu15  LET l_aag.aag16 = l_giu.giu16
             LET l_aag.aag17 = l_giu.giu17  LET l_aag.aag18 = l_giu.giu18
             # FUN-5C0015 06/03/10 (s)
             LET l_aag.aag31 = l_giu.giu31  LET l_aag.aag32 = l_giu.giu32
             LET l_aag.aag33 = l_giu.giu33  LET l_aag.aag34 = l_giu.giu34
             LET l_aag.aag35 = l_giu.giu35  LET l_aag.aag36 = l_giu.giu36
             LET l_aag.aag37 = l_giu.giu37  
             LET l_aag.aag311= l_giu.giu311 LET l_aag.aag321= l_giu.giu321
             LET l_aag.aag331= l_giu.giu331 LET l_aag.aag341= l_giu.giu341
             LET l_aag.aag351= l_giu.giu351 LET l_aag.aag361= l_giu.giu361
             LET l_aag.aag371= l_giu.giu371 
             # FUN-5C0015 06/03/10 (e)
             LET l_aag.aag151= l_giu.giu151 LET l_aag.aag161= l_giu.giu161
             LET l_aag.aag171= l_giu.giu171 LET l_aag.aag181= l_giu.giu181
             LET l_aag.aag19 = l_giu.giu19  LET l_aag.aag20 = l_giu.giu20
             LET l_aag.aag21 = l_giu.giu21  LET l_aag.aag221= l_giu.giu221
             LET l_aag.aag222= l_giu.giu222 LET l_aag.aag223= l_giu.giu223
             LET l_aag.aag224= l_giu.giu224 LET l_aag.aag225= l_giu.giu225
             LET l_aag.aag226= l_giu.giu226 LET l_aag.aag23 = l_giu.giu23
             LET l_aag.aag42 = l_giu.giu42  #No.FUN-A30077
             LET l_aag.aag24 = l_giu.giu24  LET l_aag.aag25 = l_giu.giu25
             LET l_aag.aag26 = l_giu.giu26
             LET l_aag.aagacti = l_giu.giuacti
             LET l_aag.aaguser = l_giu.giuuser
             LET l_aag.aaggrup = l_giu.giugrup
             LET l_aag.aagmodu = l_giu.giumodu
             LET l_aag.aagdate = l_giu.giudate
             LET l_aag.aag39   = l_giu.giu39   #MOD-920364
             LET l_aag.aag40   = l_giu.giu40   #MOD-920364
             LET l_aag.aagoriu = l_giu.giuoriu #TQC-A10060 add
             LET l_aag.aagorig = l_giu.giuorig #TQC-A10060 add
             IF cl_null(l_aag.aag39) THEN LET l_aag.aag39 = ' ' END IF   #MOD-920364
             #-----MOD-640376---------
             IF l_k = '1' THEN 
                LET l_cnt = 0
#No.TQC-750113 --start--
#               SELECT COUNT(*) INTO l_cnt FROM aag_file
#                 WHERE aag01 = l_giu.giu01
#                   AND aag00 = l_bookno     #No.FUN-730070
#                LET g_sql="SELECT COUNT(*) FROM ",l_dbs CLIPPED,".dbo.aag_file",   #TQC-950003 MARK                                    
               #LET g_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbs),"aag_file",   #TQC-950003 ADD #FUN-A50102 
                LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aag_file'),  #FUN-A50102
                          " WHERE aag01='",l_giu.giu01,"'",
                          "   AND aag00='",l_bookno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
                PREPARE i010_cnt_p FROM g_sql
                DECLARE i010_cnt_c CURSOR FOR i010_cnt_p
                OPEN i010_cnt_c
                FETCH i010_cnt_c INTO l_cnt
#No.TQC-750113 --end--
                IF l_cnt > 0 THEN
#                   LET g_sql="DELETE FROM ",l_dbs CLIPPED,".dbo.aag_file",      #TQC-950003 MARK                                       
                  #LET g_sql="DELETE FROM ",s_dbstring(l_dbs),"aag_file",    #TQC-950003 ADD #FUN-A50102 
                   LET g_sql="DELETE FROM ",cl_get_target_table(l_plant,'aag_file'),   #FUN-A50102
                             " WHERE aag01='",l_giu.giu01,"'",
                             "   AND aag00='",l_bookno,"'"  #No.FUN-730070
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
                   PREPARE i010_d FROM g_sql
                   EXECUTE i010_d
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('delete aag_file',SQLCA.sqlcode,1)  
                      LET g_success='N'
                      EXIT WHILE
                   END IF
                   #LET g_sql="INSERT INTO ",l_dbs CLIPPED,".dbo.aag_file",   #TQC-950003 MARK                                          
                  #LET g_sql="INSERT INTO ",s_dbstring(l_dbs),"aag_file",   #TQC-950003 ADD #FUN-A50102 
                   LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'aag_file'),  #FUN-A50102
                             " VALUES(?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,?,?)" #TQC-A10060 add ?,?  #FUN-670032 add ?  #No.FUN-730070   #MOD-920364 多二個問號  #No.MOD-9C0250
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
                   PREPARE i010_ins_2 FROM g_sql
                   EXECUTE i010_ins_2 USING l_aag.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('insert aag',SQLCA.sqlcode,2)
                      LET g_success='N'
                      EXIT WHILE
                   END IF
                ELSE
#                  LET g_sql="INSERT INTO ",l_dbs CLIPPED,".dbo.aag_file",   #TQC-950003 MARK                                           
                  #LET g_sql="INSERT INTO ",s_dbstring(l_dbs),"aag_file",   #TQC-950003 ADD     #FUN-A50102  
                   LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'aag_file'),  #FUN-A50102
                             " VALUES(?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,?,?)" #TQC-A10060 add ?,?   #FUN-670032 add ?  #No.FUN-730070   #MOD-920364 多二個問號  #No.MOD-9C0250
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
                   PREPARE i010_ins_3 FROM g_sql
                   EXECUTE i010_ins_3 USING l_aag.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('insert aag',SQLCA.sqlcode,2)
                      LET g_success='N'
                      EXIT WHILE
                   END IF
                END IF
             ELSE
                LET l_cnt = 0
#No.TQC-750113 --start--
#               SELECT COUNT(*) INTO l_cnt FROM aag_file
#                 WHERE aag01 = l_giu.giu01
#                   AND aag00 = l_giu.giu00  #No.FUN-730070
#               LET g_sql="SELECT COUNT(*) FROM ",l_dbs CLIPPED,".dbo.aag_file",      #TQC-950003 MARK                                  
               #LET g_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbs),"aag_file",  #TQC-950003 ADD  #FUN-A50102      
                LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'aag_file'),   #FUN-A50102
                          " WHERE aag01='",l_giu.giu01,"'",
                          #"   AND aag00='",l_giu.giu00,"'"   #MOD-920364
                          "   AND aag00='",l_bookno,"'"       #MOD-920364
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
                PREPARE i010_cnt_p2 FROM g_sql
                DECLARE i010_cnt_c2 CURSOR FOR i010_cnt_p2
                OPEN i010_cnt_c2
                FETCH i010_cnt_c2 INTO l_cnt
#No.TQC-750113 --end--
                IF l_cnt = 0 THEN
             #-----MOD-640376---------
#                  LET g_sql="INSERT INTO ",l_dbs CLIPPED,".dbo.aag_file",     #TQC-950003 MARK                                         
                  #LET g_sql="INSERT INTO ",s_dbstring(l_dbs),"aag_file",  #TQC-950003 ADD 
                   LET g_sql="INSERT INTO ",cl_get_target_table(l_plant,'aag_file'),   #FUN-A50102
                             " VALUES(?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,",
                             "        ?,?,?,?,?,?,?,?,?,?,?,?)"  #TQC-A10060 add ?,?  #No.FUN-730070   #MOD-920364 多二個問號  #No.MOD-9C0250
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql   #FUN-A50102
                   PREPARE i010_ins FROM g_sql
                   EXECUTE i010_ins USING l_aag.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('insert aag',SQLCA.sqlcode,2)   
                      LET g_success='N'
                      EXIT WHILE
                   END IF
                END IF   #MOD-640376
             END IF   #MOD-640376
          END FOREACH
       ELSE
       	 EXIT WHILE
       END IF
       IF g_success='Y' THEN
          COMMIT WORK
          CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
       ELSE
          ROLLBACK WORK
          CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
       END IF
 
       IF l_flag THEN
          CLEAR FORM
          ERROR ""
          CONTINUE WHILE
       ELSE
          EXIT WHILE
       END IF
   END WHILE
 
   CLOSE WINDOW i010p_w
 
END FUNCTION
 
# FUN-5C0015 06/03/10 (s)
FUNCTION i010_ahe02(p_giu)
  DEFINE  p_giu     LIKE giu_file.giu15,
          l_ahe02   LIKE ahe_file.ahe02
 
  SELECT ahe02 INTO l_ahe02 FROM ahe_file
   WHERE ahe01 = p_giu
 
  RETURN l_ahe02
 
END FUNCTION
 
FUNCTION i010_chk_ahe(p_giu)
  DEFINE  p_giu     LIKE giu_file.giu15,
  l_n     LIKE type_file.num10         #No.FUN-680098  INTEGER
 
  LET g_errno = ''
  SELECT COUNT(*) INTO l_n FROM ahe_file
 WHERE ahe01 = p_giu
 
  IF l_n <= 0 THEN
     #無此異動碼類型代號，請重新輸入!
     LET g_errno = 'agl-028'
     CALL cl_err(p_giu,g_errno,1)
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION  i010_show_field()
#依參數決定異動碼的多寡
 
 DEFINE l_field   STRING
 
#FUN-B50105   ---start   Mark
#IF g_aaz.aaz88 = 10 THEN
#RETURN
#END IF
#
#IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "giu15,ahe02_1,giu151,",
#                   "giu16,ahe02_2,giu161,",
#                   "giu17,ahe02_3,giu171,",
#                   "giu18,ahe02_4,giu181,",
#                   "giu31,ahe02_5,giu311,",
#                   "giu32,ahe02_6,giu321,",
#                   "giu33,ahe02_7,giu331,",
#                   "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
#END IF
#
#IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "giu16,ahe02_2,giu161,",
#                   "giu17,ahe02_3,giu171,",
#                   "giu18,ahe02_4,giu181,",
#                   "giu31,ahe02_5,giu311,",
#                   "giu32,ahe02_6,giu321,",
#                   "giu33,ahe02_7,giu331,",
#                   "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
#END IF
#
#IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "giu17,ahe02_3,giu171,",
#                   "giu18,ahe02_4,giu181,",
#                   "giu31,ahe02_5,giu311,",
#                   "giu32,ahe02_6,giu321,",
#                   "giu33,ahe02_7,giu331,",
#                   "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
# END IF
#
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "giu18,ahe02_4,giu181,", 
#                   "giu31,ahe02_5,giu311,",
#                   "giu32,ahe02_6,giu321,",
#                   "giu33,ahe02_7,giu331,",
#                   "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
# END IF
#
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "giu31,ahe02_5,giu311,",
#                   "giu32,ahe02_6,giu321,",
#                   "giu33,ahe02_7,giu331,",
#                   "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
# END IF
#
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "giu32,ahe02_6,giu321,",
#                   "giu33,ahe02_7,giu331,",
#                   "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
# END IF
#
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "giu33,ahe02_7,giu331,",
#                   "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
# END IF
#
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "giu34,ahe02_8,giu341,",
#                   "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
# END IF
#
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "giu35,ahe02_9,giu351,",
#                   "giu36,ahe02_10,giu361"
# END IF
#
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "giu36,ahe02_10,giu361"
# END IF  
#FUN-B50105   ---end     Mark
 
#FUN-B50105   ---start  Add 
 IF g_aaz.aaz88 = 0 THEN
     LET l_field  = "giu15,ahe02_1,giu151,",
                    "giu16,ahe02_2,giu161,",
                    "giu17,ahe02_3,giu171,",
                    "giu18,ahe02_4,giu181,"
 END IF
 IF g_aaz.aaz88 = 1 THEN
     LET l_field  = "giu16,ahe02_2,giu161,",
                    "giu17,ahe02_3,giu171,",
                    "giu18,ahe02_4,giu181,"
 END IF

 IF g_aaz.aaz88 = 2 THEN
     LET l_field  = "giu17,ahe02_3,giu171,",
                    "giu18,ahe02_4,giu181,"
  END IF

  IF g_aaz.aaz88 = 3 THEN
     LET l_field  = "giu18,ahe02_4,giu181,"
  END IF
  
  IF g_aaz.aaz88 = 4 THEN
     LET l_field  = ""
  END IF
  
  IF NOT cl_null(l_field) THEN
     LET l_field = l_field,","
  END IF
  
  IF g_aaz.aaz125 = 5 THEN
     LET l_field  = l_field,
                    "giu32,ahe02_6,giu321,",
                    "giu33,ahe02_7,giu331,",
                    "giu34,ahe02_8,giu341,",
                    "giu35,ahe02_9,giu351,",
                    "giu36,ahe02_10,giu361"
  END IF

  IF g_aaz.aaz125 = 6 THEN
     LET l_field  = l_field,
                    "giu33,ahe02_7,giu331,",
                    "giu34,ahe02_8,giu341,",
                    "giu35,ahe02_9,giu351,",
                    "giu36,ahe02_10,giu361"
  END IF

  IF g_aaz.aaz125 = 7 THEN
     LET l_field  = l_field,
                    "giu34,ahe02_8,giu341,",
                    "giu35,ahe02_9,giu351,",
                    "giu36,ahe02_10,giu361"
  END IF

  IF g_aaz.aaz125 = 8 THEN
     LET l_field  = l_field,
                    "giu35,ahe02_9,giu351,",
                    "giu36,ahe02_10,giu361"
  END IF
#FUN-B50105   ---end    Add

  CALL cl_set_comp_visible(l_field,FALSE)
 
END FUNCTION
 
 
# FUN-5C0015 06/03/10 (e)
 
#No.FUN-710056  --Begin
FUNCTION i010_set_giu00()
  DEFINE lcbo_target ui.ComboBox
 
  LET lcbo_target = ui.ComboBox.forName("giu00")
  CALL lcbo_target.RemoveItem("A")
 
END FUNCTION
#No.FUN-710056  --End
 
#No.FUN-730070  --Begin
FUNCTION i010_bookno(p_cmd,p_bookno,p_plant)   #MOD-930319 mod
  DEFINE p_cmd      LIKE type_file.chr1,  
         p_bookno   LIKE aaa_file.aaa01,
         p_plant    LIKE azp_file.azp01,       #MOD-930319 add
         l_aaaacti  LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
   #str MOD-930319 mod
   #SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    LET g_plant_new = p_plant
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
   #LET g_sql = "SELECT aaaacti FROM ",g_dbs_gl,"aaa_file",   #FUN-A50102
    LET g_sql = "SELECT aaaacti FROM ",cl_get_target_table(g_plant_new,'aaa_file'),  #FUN-A50102 
                " WHERE aaa01='",p_bookno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
    PREPARE i010_bookno_p FROM g_sql
    DECLARE i010_bookno_c CURSOR FOR i010_bookno_p
    OPEN i010_bookno_c
    FETCH i010_bookno_c INTO l_aaaacti
   #end MOD-930319 mod
    CASE
       WHEN l_aaaacti = 'N' LET g_errno = '9028'
       WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
       OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
END FUNCTION
#No.FUN-730070  --End  
 
#No.FUN-820030  --Begin                                                         
FUNCTION i010_carry()                                                           
   DEFINE l_i       LIKE type_file.num10                                        
   DEFINE l_j       LIKE type_file.num10                                        
   DEFINE 
          #l_sql     LIKE type_file.chr1000 
          l_sql     STRING     #NO.FUN-910082
 
   IF cl_null(g_giu.giu01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
 
   IF g_giu.giuacti <> 'Y' THEN                                                 
      CALL cl_err(g_giu.giu01,'aoo-090',1)                                      
      RETURN                                                                    
   END IF                                                                                  
   #input data center                                                           
   LET g_gev04 = NULL  
 
   #是否為資料中心的拋轉DB                                                      
   SELECT gev04 INTO g_gev04 FROM gev_file 
    WHERE gev01 = '6' AND gev02 = g_plant                 
      AND gev03 = 'Y'       
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err(g_gev04,'aoo-036',1)                                          
      RETURN                                                                    
   END IF      
                                                         
   #CALL s_input_gev04('6') RETURNING g_gev04                                    
   #IF INT_FLAG THEN                                                             
   #   LET INT_FLAG=0                                                            
   #   RETURN                                                                    
   #END IF                                                                       
   IF cl_null(g_gev04) THEN RETURN END IF                                       
                                                                                
   #開窗選擇拋轉的db清單     
   LET l_sql = "SELECT COUNT(*) FROM &giu_file WHERE giu00='",g_giu.giu00,"'",
               " AND giu01 = '",g_giu.giu01,"'"
                                                     
   CALL s_dc_sel_db1(g_gev04,'6',l_sql)                                                
   IF INT_FLAG THEN                                                             
      LET INT_FLAG=0                                                            
      RETURN                                                                    
   END IF          
 
   CALL g_giux.clear()                                                          
   LET g_giux[1].sel = 'Y'
   LET g_giux[1].giu00 = g_giu.giu00       
   LET g_giux[1].giu01 = g_giu.giu01       
                                      
   FOR l_i = 1 TO g_azp1.getLength()                                            
       LET g_azp[l_i].sel   = g_azp1[l_i].sel                                   
       LET g_azp[l_i].azp01 = g_azp1[l_i].azp01                                 
       LET g_azp[l_i].azp02 = g_azp1[l_i].azp02                                 
       LET g_azp[l_i].azp03 = g_azp1[l_i].azp03                                 
   END FOR       
                                 
   CALL s_showmsg_init()                                                        
   CALL s_agli010_carry_giu(g_giux,g_azp,g_gev04,'0')                         
   CALL s_showmsg()                                                             
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i010_download()                                                        
  DEFINE l_path       LIKE ze_file.ze03            
 
    IF cl_null(g_giu.giu01) THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF                              
                                                                                
    CALL s_dc_download_path() RETURNING l_path                                  
                                                                                
    CALL i010_download_files(l_path)                                            
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i010_download_files(p_path)                                            
  DEFINE p_path            LIKE ze_file.ze03 
  DEFINE l_download_file   LIKE ze_file.ze03                                    
  DEFINE l_upload_file     LIKE ze_file.ze03                                    
  DEFINE l_status          LIKE type_file.num5                                  
  DEFINE l_tempdir         LIKE type_file.chr50                                 
  DEFINE l_n               LIKE type_file.num5                                  
  DEFINE l_i               LIKE type_file.num5                                  
                                                                                
   LET l_tempdir=FGL_GETENV("TEMPDIR")                                          
   LET l_n=LENGTH(l_tempdir)                                                    
   IF l_n>0 THEN                                                                
      IF l_tempdir[l_n,l_n]='/' THEN                                            
         LET l_tempdir[l_n,l_n]=' '                                             
      END IF                                                                    
   END IF                                                                       
   LET l_n=LENGTH(p_path)                                                       
   IF l_n>0 THEN                                                                
      IF p_path[l_n,l_n]='/' THEN                                               
         LET p_path[l_n,l_n]=' '                                                
      END IF                                                                    
   END IF                                                                       
                                                                                
   LET l_upload_file = l_tempdir CLIPPED,'/agli010_giu_file_6.txt'                
   LET l_download_file = p_path CLIPPED,"/agli010_giu_file_6.txt" 
   LET g_sql = "SELECT * FROM giu_file WHERE ",g_wc                             
   UNLOAD TO l_upload_file g_sql                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('unload',SQLCA.sqlcode,1)                                     
   END IF                                                                       
                                                                                
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status      
   IF l_status THEN                                                             
      CALL cl_err(l_upload_file,STATUS,1)                                       
      RETURN                                                                    
   END IF                                                                       
   LET g_sql = "rm ",l_upload_file CLIPPED                                      
   RUN g_sql                                                                    
                                                                                
END FUNCTION                                                                    
                                                                                
#No.FUN-820030  --End             


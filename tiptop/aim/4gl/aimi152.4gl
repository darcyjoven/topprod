# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimi152.4gl
# Descriptions...: 料件申請資料維護作業 - 銷售資料
# Date & Author..: No.FUN-670033 06/08/31 By Mandy
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time改為g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.TQC-750007 07/05/03 By Mandy #狀況=>R:送簽退回,W:抽單 也要可以修改
# Modify.........: NO.TQC-750103 07/05/21 BY yiting 當不使用流通配銷(aza50='N'),  流通配銷欄位應隱藏
# Modify.........: No.TQC-780081 07/09/20 By Pengu _u()段少了,g_imaano_t=g_imaa.imaano
# Modify.........: No.MOD-790140 07/09/27 By claire 多單位且為母子單位時，銷售單位=庫存單位且不能修改
# Modify.........: No.MOD-840175 08/04/21 By Pengu "預測料號"開窗時會出現錯誤訊息"lib-309"
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0246 09/12/19 By sherry 當預測料號/預設製程料號與申請料號一樣時就不檢查是否存在ima_file中
# Modify.........: No.MOD-9C0286 09/12/19 By Carrier 主分群码和库存单位不可修改
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  料號的開窗过滤掉商戶料號
# Modify.........: No:FUN-AB0025 10/11/10 By lixh1  開窗BUG處理
# Modify.........: No:FUN-AB0059 10/11/15 By lixh1  開窗修改
# Modify.........: No:TQC-AB0197 10/11/29 By chenying 費用科目二 欄位無管控
# Modify.........: No:TQC-AC0276 10/12/17 By destiny imaa126,imaa127,imaa128栏位未管控
# Modify.........: No.FUN-AC0083 11/01/04 By vealxu 將{}改用#
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(2)
# Modify.........: No:FUN-BB0086 12/01/16 By tanxc 增加數量欄位小數取位  

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C80034 12/08/06 By qiull 將maauser,maagrup改為imaauser,imaagrup

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_imaa                RECORD LIKE imaa_file.*,
       g_imaa_t              RECORD LIKE imaa_file.*,
       g_imaa01_t            LIKE imaa_file.imaa01,
       g_imaano_t            LIKE imaa_file.imaano,
       g_sw                  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_wc,g_sql            STRING,                 #No.FUN-580092 HCN
       g_buf                 LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(40)
       g_argv1               LIKE imaa_file.imaano
DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(72)
DEFINE i                     LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_row_count           LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_curs_index          LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_jump                LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE l_ac                  LIKE type_file.num5     #FUN-610045   #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE g_chr1                LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_chr2                LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE g_chr3                LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0074
   INITIALIZE g_imaa.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM imaa_file WHERE imaano = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i152_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i152_w WITH FORM "aim/42f/aimi152"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("imaa1321",g_aza.aza63 ='Y')   #No.FUN-680034#
   IF g_aza.aza50='N' THEN
      CALL cl_set_comp_visible("imaa1010,page06,page07",FALSE)    
   ELSE
      CALL cl_set_comp_visible("imaa1010,page06,page07",TRUE)    
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      CALL i152_q()
   END IF
 
   LET g_action_choice=""
 
   CALL i152_menu()
 
   CLOSE WINDOW i152_w
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-6A0074  #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION i152_curs()
 
   CLEAR FORM
   IF cl_null(g_argv1) THEN
      CONSTRUCT BY NAME g_wc ON 
               imaa00  ,imaano  ,imaa01  ,imaa02  ,imaa021   ,
               imaa08  ,imaa06  ,imaa25  ,imaa31  ,imaa31_fac,
               imaa03  ,imaa1010,imaa92  ,imaa1004,imaa1005  ,
               imaa1006,imaa1007,imaa1008,imaa1009,imaa130   ,                   
               imaa131 ,imaa09  ,imaa10  ,imaa11  ,imaa18    ,                   
               imaa134 ,imaa133 ,imaa132 ,imaa1321,imaa138   ,
               imaa148 ,imaa35  ,imaa36  ,imaa121 ,imaa122   ,
               imaa123 ,imaa124 ,imaa125 ,imaa126 ,imaa127   ,
               imaa128 ,imaa135 ,imaa141 ,imaa142 ,imaa143   ,
               imaa144 ,imaa145 ,imaa1024,imaa1025,imaa1026  ,
               imaa1028,imaa1027,imaa1019,imaa1020,imaa1021  ,
               imaa1023,imaa1022,imaa1017,imaa1018,
               imaauser,imaagrup,imaamodu,imaadate,imaaacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(imaa01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_imaa"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa01
                    NEXT FIELD imaa01
               WHEN INFIELD(imaa133)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                   #--------No.MOD-840175 modify
                   #LET g_qryparam.form ="q_imaa"
                    LET g_qryparam.form ="q_ima"
                   #--------No.MOD-840175 end
                    LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AA0059     #FUN-AB0025 add()
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa133
                    NEXT FIELD imaa133
 
               WHEN INFIELD(imaa25)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa25
                    NEXT FIELD imaa25
               WHEN INFIELD(imaa31)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa31
                    NEXT FIELD imaa31
               WHEN INFIELD(imaa1004)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="1"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa1004
                    NEXT FIELD imaa1004
               WHEN INFIELD(imaa1005)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="2"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa1005
                    NEXT FIELD imaa1005
               WHEN INFIELD(imaa1006)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="3"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa1006
                    NEXT FIELD imaa1006
               WHEN INFIELD(imaa1007)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="4"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa1007
                    NEXT FIELD imaa1007
               WHEN INFIELD(imaa1008)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="5"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa1008
                    NEXT FIELD imaa1008
               WHEN INFIELD(imaa1009)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="6"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa1009
                    NEXT FIELD imaa1009
               WHEN INFIELD(imaa132)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_aag"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa132
                    NEXT FIELD imaa132
              WHEN INFIELD(imaa1321)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.state = "c"                                                                                      
                    LET g_qryparam.form ="q_aag"                                                                                    
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO imaa1321                                                                           
                    NEXT FIELD imaa1321  
               WHEN INFIELD(imaa134)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_obe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa134
                    NEXT FIELD imaa134
               WHEN INFIELD(imaa131)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oba"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa131
                    NEXT FIELD imaa131
               WHEN INFIELD(imaa06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_imz"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa06
                    NEXT FIELD imaa06
               WHEN INFIELD(imaa09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = 'D'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa09
                    NEXT FIELD imaa09
               WHEN INFIELD(imaa10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = 'E'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa10
                    NEXT FIELD imaa10
               WHEN INFIELD(imaa11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = 'F'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imaa11
                    NEXT FIELD imaa11
             END CASE
 
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
   ELSE
      LET g_wc = "imaano ='",g_argv1,"'"
   END IF
 
   IF INT_FLAG THEN RETURN END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND imaauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND imaagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND imaagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #LET g_wc = g_wc CLIPPED,cl_get_extra_cond('maauser', 'maagrup')   #TQC-C80034  mark
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imaauser', 'imaagrup')  #TQC-C80034  add
   #End:FUN-980030
 
 
   LET g_sql="SELECT imaano FROM imaa_file ", # 組合出 SQL 指令
            #" WHERE ",g_wc CLIPPED, " ORDER BY imaano"                     #FUN-A90049 mark
             " WHERE ( imaa120 = '1' OR imaa120 = ' ' OR imaa120 IS NULL ) AND ",g_wc CLIPPED, " ORDER BY imaano"   #FUN-A90049 add
   PREPARE i152_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i152_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i152_prepare
 
#  LET g_sql= "SELECT COUNT(*) FROM imaa_file WHERE ",g_wc CLIPPED                           #FUN-A90049 mark
   LET g_sql= "SELECT COUNT(*) FROM imaa_file WHERE ( imaa120 = '1' OR imaa120 = ' ' OR imaa120 IS NULL ) AND ",g_wc CLIPPED         #FUN-A90049 add
   PREPARE i152_precount FROM g_sql
   DECLARE i152_count CURSOR FOR i152_precount
 
END FUNCTION
 
FUNCTION i152_menu()
 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #ON ACTION insert
     #   LET g_action_choice="insert"
     #   IF cl_chk_act_auth() THEN
     #      CALL i152_a()
     #   END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i152_q()
         END IF
 
      ON ACTION next
         CALL i152_fetch('N')
 
      ON ACTION previous
         CALL i152_fetch('P')
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i152_u()
         END IF
 
     #ON ACTION invalid
     #   LET g_action_choice="invalid"
     #   IF cl_chk_act_auth() THEN
     #      CALL i152_x()
     #   END IF
     #   #圖形顯示
#    #   CALL cl_set_field_pic("","","","","",g_imaa.imaaacti)
     #   CALL i152_show()           #No.FUN-610013  
 
      ON ACTION help
          CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #EXIT MENU
         CALL i152_show_pic() #圖形顯示
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION jump
         CALL i152_fetch('/')
 
      ON ACTION first
         CALL i152_fetch('F')
 
      ON ACTION last
         CALL i152_fetch('L')
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()     
          LET g_action_choice = "exit"
        CONTINUE MENU
        #相關文件"
 
        ON ACTION related_document                          #No.FUN-680046
           LET g_action_choice="related_document"
              IF cl_chk_act_auth() THEN
                 IF g_imaa.imaano IS NOT NULL THEN
                  LET g_doc.column1 = "imaano"
                  LET g_doc.value1 = g_imaa.imaano
                  CALL cl_doc()
              END IF
           END IF
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE                 
          LET g_action_choice = "exit"
          EXIT MENU
 
   END MENU
 
   CLOSE i152_cs
 
END FUNCTION
#FUN-AC0083 ---------mark start------- 
#{
#FUNCTION imaa_default()
#  LET g_imaa.imaa07 = 'A'
#  LET g_imaa.imaa08 = 'M'
#  LET g_imaa.imaa108='N'
#  LET g_imaa.imaa14 = 'N'
#  LET g_imaa.imaa15 = 'N'
#  LET g_imaa.imaa16 = 99
#  LET g_imaa.imaa18 = 0
#  LET g_imaa.imaa09 = ' '
#  LET g_imaa.imaa10 = ' '
#  LET g_imaa.imaa11 = ' '
#  LET g_imaa.imaa23 = ' '
#  LET g_imaa.imaa24 = 'N'
#  LET g_imaa.imaa26 = 0
#  LET g_imaa.imaa261 = 0
#  LET g_imaa.imaa262 = 0
#  LET g_imaa.imaa27 = 0
#  LET g_imaa.imaa271 = 0
#  LET g_imaa.imaa28 = 0
#  LET g_imaa.imaa30= g_today    #No:7643 新增 aimi100料號時應default imaa30=料件建立日期,以便循環盤點機制
#  LET g_imaa.imaa31_fac = 1
#  LET g_imaa.imaa32 = 0
#  LET g_imaa.imaa33 = 0      #MOD-4B0254
#  LET g_imaa.imaa37 = '0'
#  LET g_imaa.imaa38 = 0
#  LET g_imaa.imaa40 = 0
#  LET g_imaa.imaa41 = 0
#  LET g_imaa.imaa42 = '0'
#  LET g_imaa.imaa44_fac = 1
#  LET g_imaa.imaa45 = 0
#  LET g_imaa.imaa46 = 0
#  LET g_imaa.imaa47 = 0
#  LET g_imaa.imaa48 = 0
#  LET g_imaa.imaa49 = 0
#  LET g_imaa.imaa491 = 0
#  LET g_imaa.imaa50 = 0
#  LET g_imaa.imaa51 = 1
#  LET g_imaa.imaa52 = 1
#  LET g_imaa.imaa140='N'
#  LET g_imaa.imaa53 = 0
#  LET g_imaa.imaa531 = 0
#  LET g_imaa.imaa55_fac = 1
#  LET g_imaa.imaa56 = 1
#  LET g_imaa.imaa561 = 1  #最少生產數量
#  LET g_imaa.imaa562 = 0  #生產時損耗率
#  LET g_imaa.imaa57 = 0
#  LET g_imaa.imaa58 = 0
#  LET g_imaa.imaa59 = 0
#  LET g_imaa.imaa60 = 0
#  LET g_imaa.imaa61 = 0
#  LET g_imaa.imaa62 = 0
#  LET g_imaa.imaa63_fac = 1
#  LET g_imaa.imaa64 = 0
#  LET g_imaa.imaa641 = 0   #最少發料數量
#  LET g_imaa.imaa65 = 0
#  LET g_imaa.imaa66 = 0
#  LET g_imaa.imaa68 = 0
#  LET g_imaa.imaa69 = 0
#  LET g_imaa.imaa70 = 'N'
#  LET g_imaa.imaa107='N'
#  LET g_imaa.imaa71 = 0
#  LET g_imaa.imaa72 = 0
# #No.B017 010326 by plum
# #LET g_imaa.imaa75 = 0
# #LET g_imaa.imaa76 = 0
#  LET g_imaa.imaa75 = ''
#  LET g_imaa.imaa76 = ''
# #No.B017..end
#  LET g_imaa.imaa77 = 0
#  LET g_imaa.imaa78 = 0
# #LET g_imaa.imaa79 = 0   #TQC-650066 mark
#  LET g_imaa.imaa80 = 0
#  LET g_imaa.imaa81 = 0
#  LET g_imaa.imaa82 = 0
#  LET g_imaa.imaa83 = 0
#  LET g_imaa.imaa84 = 0
#  LET g_imaa.imaa85 = 0
#  LET g_imaa.imaa852= 'N'
#  LET g_imaa.imaa853= 'N'
#  LET g_imaa.imaa86_fac = 1
#  LET g_imaa.imaa871 = 0
#  LET g_imaa.imaa873 = 0
#  LET g_imaa.imaa88 = 1
#  LET g_imaa.imaa91 = 0
#  LET g_imaa.imaa92 = 'N'
#  LET g_imaa.imaa93 = "NNNNNNNN"
#  LET g_imaa.imaa94 = ' '
#  LET g_imaa.imaa95 = 0
#  LET g_imaa.imaa96 = 0
#  LET g_imaa.imaa97 = 0
#  LET g_imaa.imaa98 = 0
#  LET g_imaa.imaa33 = 0        #MOD-4B0254
#  LET g_imaa.imaa99 = 0
#  LET g_imaa.imaa100 = 'N'
#  LET g_imaa.imaa101 ='1'
#  LET g_imaa.imaa102 = '1'
#  LET g_imaa.imaa103 = '0'
#  LET g_imaa.imaa104 = '0'
#  LET g_imaa.imaa105 = 'N'
#  LET g_imaa.imaa110 = '1'
#  LET g_imaa.imaa139 = 'N'
#  LET g_imaa.imaa901 = g_today
#  LET g_imaa.imaauser = g_user
#  LET g_imaa.imaaoriu = g_user #FUN-980030
#  LET g_imaa.imaaorig = g_grup #FUN-980030
#  LET g_imaa.imaadate = g_today
#  LET g_imaa.imaagrup = g_grup
#  LET g_imaa.imaaacti = 'Y'
#產品資料
#  LET g_imaa.imaa130 = '1'
#  LET g_imaa.imaa121 = 0
#  LET g_imaa.imaa122 = 0
#  LET g_imaa.imaa123 = 0
#  LET g_imaa.imaa124 = 0
#  LET g_imaa.imaa125 = 0
#  LET g_imaa.imaa126 = 0
#  LET g_imaa.imaa127 = 0
#  LET g_imaa.imaa128 = 0
#  LET g_imaa.imaa129 = 0
#  LET g_imaa.imaa141 = '0'
#  LET g_imaa.imaa145 = 'N'
#  LET g_imaa.imaa148 = 0   #MOD-4A0101
##No.FUN-640010  --start--
##  LET g_imaa.imaa1001= ''  #No.FUN-640202                                                                                                          
##  LET g_imaa.imaa1002= ''  #No.FUN-640202                         
#  LET g_imaa.imaa1017 = 0                                                                                                            
#  LET g_imaa.imaa1018 = 0       
##No.FUN-640010  --end--
#  LET g_imaa.imaa1010= '1' #No.FUN-610013
#
#END FUNCTION
#
#FUNCTION i152_a()
#
#  MESSAGE ""
#  IF s_shut(0) THEN RETURN END IF
#  CLEAR FORM
#  INITIALIZE g_imaa.* TO NULL
#  INITIALIZE g_imaa_t.* TO NULL
#  CALL imaa_default()
#  LET g_imaa01_t = NULL
#  LET g_imaano_t = NULL
#  CALL cl_opmsg('a')
#
#  WHILE TRUE
#     CALL i152_i("a")                      # 各欄位輸入
#
#     IF INT_FLAG THEN                         # 若按了DEL鍵
#        INITIALIZE g_imaa.* TO NULL
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        CLEAR FORM
#        EXIT WHILE
#     END IF
#
#     IF g_imaa.imaano IS NULL THEN                # KEY 不可空白
#        CONTINUE WHILE
#     END IF
#
#     LET g_imaa.imaaoriu = g_user      #No.FUN-980030 10/01/04
#     LET g_imaa.imaaorig = g_grup      #No.FUN-980030 10/01/04
#     LET g_imaa.imaa120 = '1'          #No.FUN-A90049 add
#     INSERT INTO imaa_file VALUES(g_imaa.*)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
#        CONTINUE WHILE
#     ELSE
#        LET g_imaa_t.* = g_imaa.*                # 保存上筆資料
#        SELECT imaano INTO g_imaa.imaano FROM imaa_file
#         WHERE imaano = g_imaa.imaano
#     END IF
#     EXIT WHILE
#  END WHILE
#
#END FUNCTION
#}
#FUN-AC0083 ----------------mark end----------------------
 
FUNCTION i152_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,        #No.FUN-690026 VARCHAR(1)
          l_flag          LIKE type_file.chr1,        #No.FUN-690026 VARCHAR(1)
          l_smd           RECORD LIKE smd_file.*,
          l_imaa31_fac    LIKE imaa_file.imaa31_fac,  #No.FUN-640010 #No.FUN-690026 DECIMAL(16,8)
          l_n             LIKE type_file.num5         #No.FUN-690026 SMALLINT
   DEFINE lc_sma119       LIKE sma_file.sma119,       #No.FUN-560119
          li_len          LIKE type_file.num5,        #No.FUN-690026 SMALLINT
          l_cnt           LIKE type_file.num5         #No.FUN-690026 SMALLINT
 
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
 
   INPUT BY NAME g_imaa.imaaoriu,g_imaa.imaaorig,
       g_imaa.imaa00  ,g_imaa.imaano  ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa021   ,
       g_imaa.imaa08  ,g_imaa.imaa06  ,g_imaa.imaa25  ,g_imaa.imaa31  ,g_imaa.imaa31_fac,
       g_imaa.imaa03  ,g_imaa.imaa1010,g_imaa.imaa92  ,g_imaa.imaa1004,g_imaa.imaa1005  ,
       g_imaa.imaa1006,g_imaa.imaa1007,g_imaa.imaa1008,g_imaa.imaa1009,g_imaa.imaa130   ,                   
       g_imaa.imaa131 ,g_imaa.imaa09  ,g_imaa.imaa10  ,g_imaa.imaa11  ,g_imaa.imaa18    ,                   
       g_imaa.imaa134 ,g_imaa.imaa133 ,g_imaa.imaa132 ,g_imaa.imaa1321,g_imaa.imaa138   ,
       g_imaa.imaa148 ,g_imaa.imaa35  ,g_imaa.imaa36  ,g_imaa.imaa121 ,g_imaa.imaa122   ,
       g_imaa.imaa123 ,g_imaa.imaa124 ,g_imaa.imaa125 ,g_imaa.imaa126 ,g_imaa.imaa127   ,
       g_imaa.imaa128 ,g_imaa.imaa135 ,g_imaa.imaa141 ,g_imaa.imaa142 ,g_imaa.imaa143   ,
       g_imaa.imaa144 ,g_imaa.imaa145 ,g_imaa.imaa1024,g_imaa.imaa1025,g_imaa.imaa1026  ,
       g_imaa.imaa1028,g_imaa.imaa1027,g_imaa.imaa1019,g_imaa.imaa1020,g_imaa.imaa1021  ,
       g_imaa.imaa1023,g_imaa.imaa1022,g_imaa.imaa1017,g_imaa.imaa1018,
       g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti
       WITHOUT DEFAULTS
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i152_set_entry(p_cmd)
          CALL i152_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_chg_comp_att("imaa01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
 
       AFTER FIELD imaa01
          IF NOT cl_null(g_imaa.imaa01) THEN
             IF cl_null(g_imaa_t.imaa01) OR         # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_imaa.imaa01 != g_imaa_t.imaa01) THEN
                SELECT count(*) INTO l_n FROM imaa_file
                 WHERE imaa01 = g_imaa.imaa01
                IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err(g_imaa.imaa01,-239,0)
                   LET g_imaa.imaa01 = g_imaa_t.imaa01
                   DISPLAY BY NAME g_imaa.imaa01
                   NEXT FIELD imaa01
                END IF
             END IF
             IF g_imaa.imaa01[1,4]='MISC' THEN
                LET g_imaa.imaa130='2'
                DISPLAY BY NAME g_imaa.imaa130
             END IF
             IF cl_null(g_imaa.imaa133) THEN
                LET g_imaa.imaa133=g_imaa.imaa01
                DISPLAY BY NAME g_imaa.imaa133
             END IF
          END IF
 
       AFTER FIELD imaa08
          IF NOT cl_null(g_imaa.imaa08) THEN
             IF g_imaa.imaa08 NOT MATCHES "[CTDAMPXKUVRZS]" THEN
                NEXT FIELD imaa08
             END IF
          END IF
 
       AFTER FIELD imaa06
          IF NOT cl_null(g_imaa.imaa06) THEN
             LET g_buf = NULL
             SELECT imz02 INTO g_buf FROM imz_file WHERE imz01=g_imaa.imaa06
             IF STATUS THEN
                CALL cl_err3("sel","imz_file",g_imaa.imaa06,"",STATUS,"","sel imz",1)
                NEXT FIELD imaa06
             END IF
             DISPLAY g_buf TO imz02
          END IF
          IF g_imaa.imaa06 IS NOT NULL AND  g_imaa.imaa06 != ' '
             THEN  
             IF (g_imaa_t.imaa06 IS NULL) OR (g_imaa.imaa06 != g_imaa_t.imaa06) THEN
                 CALL i152_imaa06('Y') #default 預設值
             ELSE
                 CALL i152_imaa06('N') #只check 對錯,不詢問
             END IF #No:7062
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imaa.imaa06,g_errno,0)
                 LET g_imaa.imaa06 = g_imaa_t.imaa06
                 DISPLAY BY NAME g_imaa.imaa06
                 NEXT FIELD imaa06
             END IF
          END IF
          LET g_imaa_t.imaa06 = g_imaa.imaa06
 
       BEFORE FIELD imaa02
          IF g_sma.sma64='Y' AND g_imaa.imaa02 IS NULL THEN
             CALL s_desinp(6,4,g_imaa.imaa02) RETURNING g_imaa.imaa02
          END IF
 
       AFTER FIELD imaa25
          IF NOT cl_null(g_imaa.imaa25) THEN
             LET g_buf = NULL
             SELECT gfe02 INTO g_buf FROM gfe_file
              WHERE gfe01=g_imaa.imaa25
             IF STATUS THEN
                CALL cl_err3("sel","gfe_file",g_imaa.imaa25,"",STATUS,"","sel gfe",1)
                NEXT FIELD imaa25
             END IF
             MESSAGE g_buf CLIPPED
             IF cl_null(g_imaa.imaa31) THEN LET g_imaa.imaa31 = g_imaa.imaa25 END IF
             IF cl_null(g_imaa.imaa44) THEN LET g_imaa.imaa44 = g_imaa.imaa25 END IF
             IF cl_null(g_imaa.imaa55) THEN LET g_imaa.imaa55 = g_imaa.imaa25 END IF
             IF cl_null(g_imaa.imaa63) THEN LET g_imaa.imaa63 = g_imaa.imaa25 END IF
             IF cl_null(g_imaa.imaa86) THEN LET g_imaa.imaa86 = g_imaa.imaa25 END IF
           #MOD-790140 add--start
            IF g_sma.sma115 = 'Y' AND g_imaa.imaa906 ='2' THEN
               LET g_imaa.imaa31 = g_imaa.imaa25
            END IF
           #MOD-790140 add--end
             DISPLAY BY NAME g_imaa.imaa31
          END IF
 
       AFTER FIELD imaa31_fac
          MESSAGE ''
          IF NOT cl_null(g_imaa.imaa31_fac) THEN
             IF g_imaa.imaa31_fac = 0 THEN
                NEXT FIELD imaa31_fac
             END IF
 
             LET l_smd.smd01=g_imaa.imaa01
             LET l_smd.smd02=g_imaa.imaa31 LET l_smd.smd04=1
             LET l_smd.smd03=g_imaa.imaa25 LET l_smd.smd06=g_imaa.imaa31_fac
             LET l_smd.smd06 = s_digqty(l_smd.smd06,l_smd.smd03)   #No.FUN-BB0086
             LET l_smd.smdacti='Y'
 
             IF l_smd.smd02!=l_smd.smd03 THEN
                INSERT INTO smd_file VALUES(l_smd.*)
                IF STATUS THEN
                   UPDATE smd_file SET smd04=l_smd.smd04,
                                       smd06=l_smd.smd06
                    WHERE smd01=g_imaa.imaa01
                      AND smd02=l_smd.smd02
                      AND smd03=l_smd.smd03
                END IF
             END IF
          END IF
 
       AFTER FIELD imaa31
          IF NOT cl_null(g_imaa.imaa31) THEN
             LET g_buf = NULL
 
             SELECT gfe02 INTO g_buf FROM gfe_file
              WHERE gfe01=g_imaa.imaa31 AND gfeacti IN ('Y','y')
             IF STATUS THEN
                CALL cl_err3("sel","gfe_file",g_imaa.imaa31,"",STATUS,"","sel gfe",1)
                NEXT FIELD imaa31
             END IF
 
             MESSAGE g_buf CLIPPED
 
             IF g_imaa.imaa31 = g_imaa.imaa25 THEN
                LET g_imaa.imaa31_fac = 1
             ELSE
                CALL s_umfchk(g_imaa.imaa01,g_imaa.imaa31,g_imaa.imaa25)
                    RETURNING g_sw,g_imaa.imaa31_fac
                IF g_sw = '1' THEN
                   CALL cl_err(g_imaa.imaa31,'mfg1206',0)
                   DISPLAY BY NAME  g_imaa.imaa31
                   DISPLAY BY NAME  g_imaa.imaa31_fac
                   NEXT FIELD imaa31
                END IF
 
                DISPLAY BY NAME g_imaa.imaa31_fac
             END IF
 
          END IF
 
        AFTER FIELD imaa1004
            IF NOT cl_null(g_imaa.imaa1004) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_imaa.imaa1004
                  AND tqa03 = '1' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
                  CALL cl_err('','atm-125',0)
                  NEXT FIELD imaa1004
               END IF
               CALL i120_imaa(g_imaa.imaa1004,'1')
            END IF
 
        AFTER FIELD imaa1005
            IF NOT cl_null(g_imaa.imaa1005) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_imaa.imaa1005
                  AND tqa03 = '2' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
                  CALL cl_err('','atm-125',0)
                  NEXT FIELD imaa1005
               END IF
               CALL i120_imaa(g_imaa.imaa1005,'2')
            END IF
 
        AFTER FIELD imaa1006
            IF NOT cl_null(g_imaa.imaa1006) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_imaa.imaa1006
                  AND tqa03 = '3' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
                  CALL cl_err('','atm-125',0)
                  NEXT FIELD imaa1006
               END IF
               CALL i120_imaa(g_imaa.imaa1006,'3')
            END IF
 
        AFTER FIELD imaa1007
            IF NOT cl_null(g_imaa.imaa1007) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_imaa.imaa1007
                  AND tqa03 = '4' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
                  CALL cl_err('','atm-125',0)
                  NEXT FIELD imaa1007
               END IF
               CALL i120_imaa(g_imaa.imaa1007,'4')
            END IF
 
        AFTER FIELD imaa1008
            IF NOT cl_null(g_imaa.imaa1008) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_imaa.imaa1008
                  AND tqa03 = '5' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
                  CALL cl_err('','atm-125',0)
                  NEXT FIELD imaa1008
               END IF
               CALL i120_imaa(g_imaa.imaa1008,'5')
            END IF
 
        AFTER FIELD imaa1009
            IF NOT cl_null(g_imaa.imaa1009) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_imaa.imaa1009
                  AND tqa03 = '6' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
                  CALL cl_err('','atm-125',0)
                  NEXT FIELD imaa1009
               END IF
               CALL i120_imaa(g_imaa.imaa1009,'6')
            END IF                
 
        AFTER FIELD imaa1024
           IF NOT cl_null(g_imaa.imaa1024) THEN
              IF g_imaa.imaa1024 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1024
              END IF
              IF NOT cl_null(g_imaa.imaa1025) AND
                 NOT cl_null(g_imaa.imaa1026) THEN
                 LET g_imaa.imaa1027 = g_imaa.imaa1024 *
                                       g_imaa.imaa1025 * g_imaa.imaa1026
                 CALL s_umfchk(g_imaa.imaa01,g_imaa.imaa31,g_imaa.imaa25)
                     RETURNING g_sw,l_imaa31_fac
                 LET g_imaa.imaa1022 = g_imaa.imaa1027/l_imaa31_fac
                 DISPLAY g_imaa.imaa1027 TO imaa1027
                 DISPLAY g_imaa.imaa1022 TO imaa1022
              END IF
           END IF
 
        AFTER FIELD imaa1025
           IF NOT cl_null(g_imaa.imaa1025) THEN
              IF g_imaa.imaa1025 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1025
              END IF
              IF NOT cl_null(g_imaa.imaa1024) AND
                 NOT cl_null(g_imaa.imaa1026) THEN
                 LET g_imaa.imaa1027 = g_imaa.imaa1024 *
                                       g_imaa.imaa1025 * g_imaa.imaa1026
                 CALL s_umfchk(g_imaa.imaa01,g_imaa.imaa31,g_imaa.imaa25)
                     RETURNING g_sw,l_imaa31_fac
                 LET g_imaa.imaa1022 = g_imaa.imaa1027/l_imaa31_fac
                 DISPLAY g_imaa.imaa1027 TO imaa1027
                 DISPLAY g_imaa.imaa1022 TO imaa1022
              END IF
           END IF
 
        AFTER FIELD imaa1026
           IF NOT cl_null(g_imaa.imaa1026) THEN
              IF g_imaa.imaa1026 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1026
              END IF
              IF NOT cl_null(g_imaa.imaa1024) AND
                 NOT cl_null(g_imaa.imaa1025) THEN
                 LET g_imaa.imaa1027 = g_imaa.imaa1024 *
                                       g_imaa.imaa1025 * g_imaa.imaa1026
                 CALL s_umfchk(g_imaa.imaa01,g_imaa.imaa31,g_imaa.imaa25)
                     RETURNING g_sw,l_imaa31_fac
                 LET g_imaa.imaa1022 = g_imaa.imaa1027/l_imaa31_fac
                 DISPLAY g_imaa.imaa1027 TO imaa1027
                 DISPLAY g_imaa.imaa1022 TO imaa1022
              END IF
           END IF
 
        AFTER FIELD imaa1028
           IF NOT cl_null(g_imaa.imaa1028) THEN
              IF g_imaa.imaa1028<= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1028
              END IF
              LET g_imaa.imaa1023 = g_imaa.imaa1028/l_imaa31_fac
              DISPLAY g_imaa.imaa1023 TO imaa1023
           END IF
 
        AFTER FIELD imaa1027
           IF NOT cl_null(g_imaa.imaa1027) THEN
              IF g_imaa.imaa1027 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1027
              END IF
           END IF
 
        AFTER FIELD imaa1019
           IF NOT cl_null(g_imaa.imaa1019) THEN
              IF g_imaa.imaa1019 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1019
              END IF
              IF NOT cl_null(g_imaa.imaa1020) AND
                 NOT cl_null(g_imaa.imaa1021) THEN
                 LET g_imaa.imaa1022 = g_imaa.imaa1019 *
                                       g_imaa.imaa1020 * g_imaa.imaa1021
                 DISPLAY g_imaa.imaa1022 TO imaa1022
              END IF
           END IF
 
        AFTER FIELD imaa1020
           IF NOT cl_null(g_imaa.imaa1020) THEN
              IF g_imaa.imaa1020 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1020
              END IF
              IF NOT cl_null(g_imaa.imaa1019) AND
                 NOT cl_null(g_imaa.imaa1021) THEN
                 LET g_imaa.imaa1022 = g_imaa.imaa1019 *
                                       g_imaa.imaa1020 * g_imaa.imaa1021
                 DISPLAY g_imaa.imaa1022 TO imaa1022
              END IF
           END IF
 
        AFTER FIELD imaa1021
           IF NOT cl_null(g_imaa.imaa1021) THEN
              IF g_imaa.imaa1021 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1021
              END IF
              IF NOT cl_null(g_imaa.imaa1019) AND
                 NOT cl_null(g_imaa.imaa1020) THEN
                 LET g_imaa.imaa1022 = g_imaa.imaa1019 *
                                       g_imaa.imaa1020 * g_imaa.imaa1021
                 DISPLAY g_imaa.imaa1022 TO imaa1022
              END IF
           END IF
 
        AFTER FIELD imaa1022
           IF NOT cl_null(g_imaa.imaa1022) THEN
              IF g_imaa.imaa1022 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1022
              END IF
           END IF
 
        AFTER FIELD imaa1023
           IF NOT cl_null(g_imaa.imaa1023) THEN
              IF g_imaa.imaa1023 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD imaa1023
              END IF
           END IF
 
       AFTER FIELD imaa130
          IF g_imaa.imaa01[1,4]='MISC' THEN
             LET g_imaa.imaa130='2'
             DISPLAY BY NAME g_imaa.imaa130
          END IF
 
          IF NOT cl_null(g_imaa.imaa130) THEN
             IF g_imaa.imaa130 NOT MATCHES '[0123]' THEN
                NEXT FIELD imaa130
             END IF
          END IF
 
       AFTER FIELD imaa134
          IF NOT cl_null(g_imaa.imaa134) THEN
             LET g_buf = NULL
             SELECT obe02 INTO g_buf FROM obe_file
              WHERE obe01=g_imaa.imaa134
             IF STATUS THEN
                CALL cl_err3("sel","obe_file",g_imaa.imaa134,"",STATUS,"","sel obe",1)
                NEXT FIELD imaa134
             END IF
             DISPLAY g_buf TO obe02
          END IF
 
       AFTER FIELD imaa131
          IF NOT cl_null(g_imaa.imaa131) THEN
             LET g_buf = NULL
             SELECT oba02 INTO g_buf FROM oba_file
              WHERE oba01=g_imaa.imaa131
             IF STATUS THEN
                CALL cl_err3("sel","oba_file",g_imaa.imaa131,"",STATUS,"","sel oba",1)
                NEXT FIELD imaa131
             END IF
 
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD imaa18
          IF NOT cl_null(g_imaa.imaa18) THEN
             IF g_imaa.imaa18 < 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa18
             END IF
          END IF
 
       AFTER FIELD imaa09
          IF NOT cl_null(g_imaa.imaa09) THEN
             LET g_buf = NULL
             SELECT azf03 INTO g_buf FROM azf_file
              WHERE azf01=g_imaa.imaa09 AND azf02='D'
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_imaa.imaa09,"",STATUS,"","sel azf",1)
                NEXT FIELD imaa09
             END IF
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD imaa10
          IF NOT cl_null(g_imaa.imaa10) THEN
             LET g_buf = NULL
             SELECT azf03 INTO g_buf FROM azf_file
              WHERE azf01=g_imaa.imaa10 AND azf02='E'#6818
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_imaa.imaa10,"",STATUS,"","sel azf",1)
                NEXT FIELD imaa10
             END IF
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD imaa11
          IF NOT cl_null(g_imaa.imaa11) THEN
             LET g_buf = NULL
             SELECT azf03 INTO g_buf FROM azf_file
              WHERE azf01=g_imaa.imaa11 AND azf02='F'#6818
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_imaa.imaa11,"",STATUS,"","sel azf",1)
                NEXT FIELD imaa11
             END IF
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD imaa121,imaa122,imaa123,imaa124
          IF NOT cl_null(g_imaa.imaa121) THEN
             IF g_imaa.imaa121< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa121
             END IF
          END IF
 
          IF NOT cl_null(g_imaa.imaa122) THEN
             IF g_imaa.imaa122< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa122
             END IF
          END IF
 
          IF NOT cl_null(g_imaa.imaa123) THEN
             IF g_imaa.imaa123< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa123
             END IF
          END IF
 
          IF NOT cl_null(g_imaa.imaa124) THEN
             IF g_imaa.imaa124< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa124
             END IF
          END IF
 
          LET g_imaa.imaa125 = g_imaa.imaa121+ g_imaa.imaa122+ g_imaa.imaa123+
                             g_imaa.imaa124
          DISPLAY BY NAME g_imaa.imaa125
#TQC-AC0276--begin
       AFTER FIELD imaa126,imaa127,imaa128
          IF NOT cl_null(g_imaa.imaa126) THEN 
             IF g_imaa.imaa126<0 THEN 
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa126
             END IF 
          END IF   
 
          IF NOT cl_null(g_imaa.imaa127) THEN 
             IF g_imaa.imaa127<0 THEN 
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa127
             END IF 
          END IF    

          IF NOT cl_null(g_imaa.imaa128) THEN 
             IF g_imaa.imaa128<0 THEN 
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa128 
             END IF 
          END IF    
#TQC-AC0276--end 
       BEFORE FIELD imaa141
          CALL i152_set_entry(p_cmd)
 
       AFTER FIELD imaa141
          IF NOT cl_null(g_imaa.imaa141) THEN
             IF g_imaa.imaa141 NOT MATCHES '[012]' THEN
                LET g_imaa.imaa141 = g_imaa_t.imaa141
                DISPLAY BY NAME g_imaa.imaa141
                NEXT FIELD imaa141
             END IF
             IF g_imaa.imaa141 = '0' THEN
                LET g_imaa.imaa142 = NULL
                LET g_imaa.imaa143 = NULL
                LET g_imaa.imaa144 = NULL
                LET g_imaa.imaa145 = "N"   #No:7694
                DISPLAY BY NAME g_imaa.imaa142,g_imaa.imaa143,
                                g_imaa.imaa144,g_imaa.imaa145
             END IF
             CALL i152_set_no_entry(p_cmd)
          END IF
 
       AFTER FIELD imaa145
          IF NOT cl_null(g_imaa.imaa145) THEN
             IF g_imaa.imaa145 NOT MATCHES '[YN]' THEN
                LET g_imaa.imaa145 = g_imaa_t.imaa145
                DISPLAY BY NAME g_imaa.imaa145
                NEXT FIELD imaa145
             END IF
          END IF
 
       AFTER FIELD imaa132
          IF NOT cl_null(g_imaa.imaa132) THEN
             SELECT COUNT(*) INTO g_cnt FROM aag_file
              WHERE aag01=g_imaa.imaa132
                AND aag00=g_aza.aza81    #No.FUN-730020
             IF g_cnt=0 THEN
                CALL cl_err('sel aag',100,0)
                #FUN-B10049--begin
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_aag"                                   
                LET g_qryparam.default1 = g_imaa.imaa132  
                LET g_qryparam.construct = 'N'                
                LET g_qryparam.arg1 = g_aza.aza81  
                LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imaa.imaa132 CLIPPED,"%' "                                                                        
                CALL cl_create_qry() RETURNING g_imaa.imaa132
                DISPLAY BY NAME g_imaa.imaa132  
                #FUN-B10049--end                 
                NEXT FIELD imaa132
             END IF
          END IF
 
      #TQC-AB0197------------add-----------------str-------------
      AFTER FIELD imaa1321
         IF NOT cl_null(g_imaa.imaa1321) THEN
             SELECT COUNT(*) INTO g_cnt FROM aag_file
              WHERE aag01=g_imaa.imaa1321
                AND aag00=g_aza.aza82
             IF g_cnt=0 THEN
                CALL cl_err('sel aag',100,0)
                #FUN-B10049--begin
                CALL cl_init_qry_var()                                         
                LET g_qryparam.form ="q_aag"                                   
                LET g_qryparam.default1 = g_imaa.imaa1321  
                LET g_qryparam.construct = 'N'                
                LET g_qryparam.arg1 = g_aza.aza82  
                LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imaa.imaa1321 CLIPPED,"%' "                                                                        
                CALL cl_create_qry() RETURNING g_imaa.imaa1321
                DISPLAY BY NAME g_imaa.imaa1321  
                #FUN-B10049--end                         
                NEXT FIELD imaa1321
             END IF
          END IF
      #TQC-AB0197------------add-----------------end--------------


       AFTER FIELD imaa133
          IF NOT cl_null(g_imaa.imaa133) THEN
              IF p_cmd = 'a' AND g_imaa.imaa133 = g_imaa.imaa01 THEN
                  NEXT FIELD imaa132
              ELSE
                  LET l_cnt = 0
                 #--------------No.MOD-840175 modify
                 #SELECT COUNT(*) INTO l_cnt FROM imaa_file
                 # WHERE imaa01 = g_imaa.imaa133
                  SELECT COUNT(*) INTO l_cnt FROM ima_file
                   WHERE ima01 = g_imaa.imaa133
                 #--------------No.MOD-840175 end
                  #IF l_cnt = 0  THEN    #MOD-9C0246
                  IF l_cnt = 0 AND g_imaa.imaa01 <> g_imaa.imaa133 THEN  #MOD-9C0246
                      CALL cl_err('','axm-297',0)
                      NEXT FIELD imaa133
                  END IF
                  LET l_cnt = 0
              END IF  
          END IF
 
       AFTER FIELD imaa148
          IF NOT cl_null(g_imaa.imaa148) THEN
             IF g_imaa.imaa148 < 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD imaa148
             END IF
          END IF
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          LET g_imaa.imaauser = s_get_data_owner("imaa_file") #FUN-C10039
          LET g_imaa.imaagrup = s_get_data_group("imaa_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT  END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(imaa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imaa"
                  LET g_qryparam.default1 = g_imaa.imaa01
                  CALL cl_create_qry() RETURNING g_imaa.imaa01
                  DISPLAY BY NAME g_imaa.imaa01
                  NEXT FIELD imaa01
             WHEN INFIELD(imaa133)
                  CALL cl_init_qry_var()
                 #--------No.MOD-840175 modify
                 #LET g_qryparam.form ="q_imaa"
                  LET g_qryparam.form ="q_ima"
                 #--------No.MOD-840175 end
                  LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"  #FUN-AB0059
                  LET g_qryparam.default1 = g_imaa.imaa133
                  CALL cl_create_qry() RETURNING g_imaa.imaa133
                  DISPLAY BY NAME g_imaa.imaa133
                  NEXT FIELD imaa133
             WHEN INFIELD(imaa25)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa25
                  CALL cl_create_qry() RETURNING g_imaa.imaa25
                  DISPLAY BY NAME g_imaa.imaa25
                  NEXT FIELD imaa25
             WHEN INFIELD(imaa31)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa31
                  CALL cl_create_qry() RETURNING g_imaa.imaa31
                  DISPLAY BY NAME g_imaa.imaa31
                  NEXT FIELD imaa31
             WHEN INFIELD(imaa132)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa132
                  LET g_qryparam.arg1     = g_aza.aza81  #No.FUN-730020
                  CALL cl_create_qry() RETURNING g_imaa.imaa132
                  DISPLAY BY NAME g_imaa.imaa132
                  NEXT FIELD imaa132
             WHEN INFIELD(imaa1321)                                                                                                   
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_aag"                                                                                      
                  LET g_qryparam.default1 = g_imaa.imaa1321                                                                            
                  LET g_qryparam.arg1     = g_aza.aza82  #No.FUN-730020
                  CALL cl_create_qry() RETURNING g_imaa.imaa1321                                                                       
                  DISPLAY BY NAME g_imaa.imaa1321                                                                                      
                  NEXT FIELD imaa1321
             WHEN INFIELD(imaa1004)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="1"
                  LET g_qryparam.default1 = g_imaa.imaa1004
                  CALL cl_create_qry() RETURNING g_imaa.imaa1004
                  DISPLAY BY NAME g_imaa.imaa1004
                  NEXT FIELD imaa1004
             WHEN INFIELD(imaa1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="2"
                  LET g_qryparam.default1 = g_imaa.imaa1005
                  CALL cl_create_qry() RETURNING g_imaa.imaa1005
                  DISPLAY BY NAME g_imaa.imaa1005
                  NEXT FIELD imaa1005
             WHEN INFIELD(imaa1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="3"
                  LET g_qryparam.default1 = g_imaa.imaa1006
                  CALL cl_create_qry() RETURNING g_imaa.imaa1006
                  DISPLAY BY NAME g_imaa.imaa1006
                  NEXT FIELD imaa1006
             WHEN INFIELD(imaa1007)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="4"
                  LET g_qryparam.default1 = g_imaa.imaa1007
                  CALL cl_create_qry() RETURNING g_imaa.imaa1007
                  DISPLAY BY NAME g_imaa.imaa1007
                  NEXT FIELD imaa1007
             WHEN INFIELD(imaa1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="5"
                  LET g_qryparam.default1 = g_imaa.imaa1008
                  CALL cl_create_qry() RETURNING g_imaa.imaa1008
                  DISPLAY BY NAME g_imaa.imaa1008
                  NEXT FIELD imaa1008
             WHEN INFIELD(imaa1009)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="6"
                  LET g_qryparam.default1 = g_imaa.imaa1009
                  CALL cl_create_qry() RETURNING g_imaa.imaa1009
                  DISPLAY BY NAME g_imaa.imaa1009
                  NEXT FIELD imaa1009               
 
             WHEN INFIELD(imaa134)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_obe"
                  LET g_qryparam.default1 = g_imaa.imaa134
                  CALL cl_create_qry() RETURNING g_imaa.imaa134
                  DISPLAY BY NAME g_imaa.imaa134
                  NEXT FIELD imaa134
             WHEN INFIELD(imaa131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oba"
                  LET g_qryparam.default1 = g_imaa.imaa131
                  CALL cl_create_qry() RETURNING g_imaa.imaa131
                  DISPLAY BY NAME g_imaa.imaa131
                  NEXT FIELD imaa131
             WHEN INFIELD(imaa06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imz"
                  LET g_qryparam.default1 = g_imaa.imaa06
                  CALL cl_create_qry() RETURNING g_imaa.imaa06
                  DISPLAY BY NAME g_imaa.imaa06
                  NEXT FIELD imaa06
             WHEN INFIELD(imaa09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa09
                  LET g_qryparam.arg1 = 'D'
                  CALL cl_create_qry() RETURNING g_imaa.imaa09
                  DISPLAY BY NAME g_imaa.imaa09
                  NEXT FIELD imaa09
             WHEN INFIELD(imaa10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa10
                  LET g_qryparam.arg1 = 'E'
                  CALL cl_create_qry() RETURNING g_imaa.imaa10
                  DISPLAY BY NAME g_imaa.imaa10
                  NEXT FIELD imaa10
             WHEN INFIELD(imaa11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa11
                  LET g_qryparam.arg1 = 'F'
                  CALL cl_create_qry() RETURNING g_imaa.imaa11
                  DISPLAY BY NAME g_imaa.imaa11
                  NEXT FIELD imaa11
           END CASE
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
       ON ACTION CONTROLF                        # 欄位說明
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION
 
FUNCTION i152_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL i152_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
 
    OPEN i152_count
    FETCH i152_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i152_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       INITIALIZE g_imaa.* TO NULL
    ELSE
       CALL i152_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION i152_fetch(p_flimaa)
   DEFINE p_flimaa  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   CASE p_flimaa
      WHEN 'N' FETCH NEXT     i152_cs INTO g_imaa.imaano
      WHEN 'P' FETCH PREVIOUS i152_cs INTO g_imaa.imaano
      WHEN 'F' FETCH FIRST    i152_cs INTO g_imaa.imaano
      WHEN 'L' FETCH LAST     i152_cs INTO g_imaa.imaano
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
         FETCH ABSOLUTE g_jump i152_cs INTO g_imaa.imaano
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
      INITIALIZE g_imaa.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flimaa
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_imaa.* FROM imaa_file
    WHERE imaano = g_imaa.imaano
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)
   ELSE
      LET g_data_owner = g_imaa.imaauser     
      LET g_data_group = g_imaa.imaagrup    
      CALL i152_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i152_show()
   DEFINE l_smd   DYNAMIC ARRAY OF RECORD
                     smd04 LIKE smd_file.smd04,
                     smd02 LIKE smd_file.smd02,
                     smd06 LIKE smd_file.smd06,
                     smd03 LIKE smd_file.smd03
                  END RECORD
   DEFINE l_chr   LIKE type_file.chr1        #No.FUN-690026 VARCHAR(1)
   DEFINE g_chr   LIKE type_file.chr1        #No.FUN-690026 VARCHAR(1)
   DEFINE g_chr1  LIKE type_file.chr1        #No.FUN-690026 VARCHAR(1)
   LET g_imaa_t.* = g_imaa.*
 
   DISPLAY BY NAME  g_imaa.imaaoriu,g_imaa.imaaorig,
       g_imaa.imaa00  ,g_imaa.imaano  ,g_imaa.imaa01  ,g_imaa.imaa02  ,g_imaa.imaa021   ,
       g_imaa.imaa08  ,g_imaa.imaa06  ,g_imaa.imaa25  ,g_imaa.imaa31  ,g_imaa.imaa31_fac,
       g_imaa.imaa03  ,g_imaa.imaa1010,g_imaa.imaa92  ,g_imaa.imaa1004,g_imaa.imaa1005  ,
       g_imaa.imaa1006,g_imaa.imaa1007,g_imaa.imaa1008,g_imaa.imaa1009,g_imaa.imaa130   ,                   
       g_imaa.imaa131 ,g_imaa.imaa09  ,g_imaa.imaa10  ,g_imaa.imaa11  ,g_imaa.imaa18    ,                   
       g_imaa.imaa134 ,g_imaa.imaa133 ,g_imaa.imaa132 ,g_imaa.imaa1321,g_imaa.imaa138   ,
       g_imaa.imaa148 ,g_imaa.imaa35  ,g_imaa.imaa36  ,g_imaa.imaa121 ,g_imaa.imaa122   ,
       g_imaa.imaa123 ,g_imaa.imaa124 ,g_imaa.imaa125 ,g_imaa.imaa126 ,g_imaa.imaa127   ,
       g_imaa.imaa128 ,g_imaa.imaa135 ,g_imaa.imaa141 ,g_imaa.imaa142 ,g_imaa.imaa143   ,
       g_imaa.imaa144 ,g_imaa.imaa145 ,g_imaa.imaa1024,g_imaa.imaa1025,g_imaa.imaa1026  ,
       g_imaa.imaa1028,g_imaa.imaa1027,g_imaa.imaa1019,g_imaa.imaa1020,g_imaa.imaa1021  ,
       g_imaa.imaa1023,g_imaa.imaa1022,g_imaa.imaa1017,g_imaa.imaa1018,
       g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaamodu,g_imaa.imaadate,g_imaa.imaaacti
 
    IF cl_null(g_imaa.imaa1028) THEN                                                                                                  
       DISPLAY g_imaa.imaa18 TO imaa1028                                                                                               
    END IF                                                                                                                          
    IF cl_null(g_imaa.imaa1027) THEN                                                                                                  
       DISPLAY g_imaa.imaa1011 TO imaa1027                                                                                             
    END IF                                                                                                                          
                                                                                                                                    
    CALL i120_imaa(g_imaa.imaa1004,'1')                                                                                                
    CALL i120_imaa(g_imaa.imaa1005,'2')                                                                                                
    CALL i120_imaa(g_imaa.imaa1006,'3')                                                                                                
    CALL i120_imaa(g_imaa.imaa1007,'4')                                                                                                
    CALL i120_imaa(g_imaa.imaa1008,'5')                                                                                                
    CALL i120_imaa(g_imaa.imaa1009,'6')                        
 
   LET g_buf = NULL
   SELECT * INTO g_imaa.* FROM imaa_file
    WHERE imaano=g_imaa.imaano
   DISPLAY BY NAME g_imaa.imaa05,g_imaa.imaa08
 
   LET l_chr=g_imaa.imaa93[2,2]
   DISPLAY l_chr TO FORMONLY.s
 
   SELECT obe02 INTO g_buf FROM obe_file
    WHERE obe01=g_imaa.imaa134
   DISPLAY g_buf TO obe02
 
   LET g_buf = NULL
   SELECT imz02 INTO g_buf FROM imz_file
    WHERE imz01=g_imaa.imaa06
   DISPLAY g_buf TO imz02
 
#FUN-AC0083 --------mark start------
#{
#  LET g_buf = NULL
#  DECLARE i152_c3 CURSOR FOR
#   SELECT smd04,smd02,smd06,smd03 FROM smd_file
#    WHERE smd01=g_imaa.imaa01
#
#  CALL l_smd.clear()
#
#  LET i=1
#  FOREACH i152_c3 INTO l_smd[i].*
#     LET i=i+1
#     IF i > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF
#  END FOREACH
#  LET i = i - 1
#
#  DISPLAY ARRAY l_smd TO s_smd.* ATTRIBUTE(COUNT=i)
#
#     BEFORE DISPLAY
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  END DISPLAY
#
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#}
#FUN-AC0083 ---------mark end------------
 
   #圖形顯示
   LET g_doc.column1 = "imaa01"
   LET g_doc.value1 = g_imaa.imaa01
   CALL cl_get_fld_doc("imaa04")
 
    CALL i152_show_pic() #圖形顯示
    CALL cl_show_fld_cont()                   
 
END FUNCTION
 
FUNCTION i152_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_imaa.imaano IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_imaa.imaa00 = 'U' THEN
       #只有申請類別為'新增'時才能做!
       CALL cl_err(g_imaa.imaano,'aim-151',1)
       RETURN
   END IF
   #非開立狀態，不可異動！
   #TQC-750007-----mod----str---
   #IF g_imaa.imaa1010!='0' THEN CALL cl_err('','atm-046',1) RETURN END IF 
   #狀況=>R:送簽退回,W:抽單 也要可以修改
    IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN CALL cl_err('','atm-046',1) RETURN END IF 
   #TQC-750007-----mod----end---
            
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_imaa01_t = g_imaa.imaa01
   LET g_imaano_t = g_imaa.imaano      #No.TQC-780081 add
 
   BEGIN WORK
 
   OPEN i152_cl USING g_imaa.imaano
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i152_cl
      RETURN
   END IF
 
   FETCH i152_cl INTO g_imaa.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i152_cl
      RETURN
   END IF
 
   LET g_imaa_t.*=g_imaa.*
   LET g_imaa.imaamodu = g_user                #修改者
   LET g_imaa.imaadate = g_today               #修改日期
 
   CALL i152_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i152_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_imaa.*=g_imaa_t.*
         CALL i152_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_imaa.imaa93[2,2] = 'Y'
      #TQC-750007----add---str--
       IF g_imaa.imaa1010 MATCHES '[RW]' THEN
           LET g_imaa.imaa1010 = '0' #開立
       END IF
      #TQC-750007----add---end--
      UPDATE imaa_file SET * = g_imaa.*  # 更新DB
       WHERE imaano = g_imaano_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","imaa_file",g_imaano_t,"",SQLCA.sqlcode,"","",1)
          CONTINUE WHILE
      END IF
      DISPLAY 'Y' TO FORMONLY.s
 
      EXIT WHILE
   END WHILE
 
   CLOSE i152_cl
   COMMIT WORK
   #TQC-750007---add---str--
   SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
   CALL i152_show()                                            
   #TQC-750007---add---end--
 
END FUNCTION
 
#FUN-AC0083 ----------mark start-------
#{
#FUNCTION i152_r()
#  DEFINE l_str LIKE type_file.chr8    #No.FUN-690026 VARCHAR(8)
#
#  IF s_shut(0) THEN RETURN END IF
#  IF g_imaa.imaa01 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#
#  BEGIN WORK
#
#  OPEN i152_cl USING g_imaa.imaano
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_imaa.imaa01,SQLCA.sqlcode,0)
#     CLOSE i152_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  FETCH i152_cl INTO g_imaa.*
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_imaa.imaa01,SQLCA.sqlcode,0)
#     CLOSE i152_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  CALL i152_show()
#
#  IF cl_delete() THEN
#     DELETE FROM imaa_file WHERE imaa01 = g_imaa.imaa01
#     LET l_str=TIME
#     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #No.MOD-470041 #No.FUN-980004
#                  VALUES('aimi152',g_user,g_today,l_str,g_imaa.imaa01,'delete',g_plant,g_legal) #No.FUN-980004
#
#     CLEAR FORM
#
#     OPEN i152_count
#     FETCH i152_count INTO g_row_count
#     DISPLAY g_row_count TO FORMONLY.cnt
#
#     OPEN i152_cs
#     IF g_curs_index = g_row_count + 1 THEN
#        LET g_jump = g_row_count
#        CALL i152_fetch('L')
#     ELSE
#        LET g_jump = g_curs_index
#        LET mi_no_ask = TRUE
#        CALL i152_fetch('/')
#     END IF
#  END IF
#
#  CLOSE i152_cl
#  COMMIT WORK
#
#END FUNCTION
#}
#{
#FUNCTION i152_out()
#  DEFINE l_imaa   RECORD
#                    imaa01   LIKE imaa_file.imaa01,
#                    imaa02   LIKE imaa_file.imaa02,
#                    imaa021  LIKE imaa_file.imaa021,
#                    imaa31   LIKE imaa_file.imaa31,
#                    imaa131  LIKE imaa_file.imaa131,
#                    imaa06   LIKE imaa_file.imaa06,
#                    imaa130  LIKE imaa_file.imaa130
#                 END RECORD,
#         l_i     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#         l_name  LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#         l_za05  LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(40)
#
#  IF g_wc IS NULL THEN
#     CALL cl_err('','9057',0)
#     RETURN
#  END IF
#
#  CALL cl_wait()
#
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#
#  LET g_sql="SELECT imaa01,imaa02,imaa021,imaa31,imaa131,imaa06,imaa130 FROM imaa_file ",
#            " WHERE ",g_wc CLIPPED # 組合出 SQL 指令
#  PREPARE i152_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i152_co CURSOR FOR i152_p1        # CURSOR
#
#
#  LET g_rlang = g_lang                               #FUN-4C0096 add
#  CALL cl_outnam('aimi152') RETURNING l_name         #FUN-4C0096 add
#  START REPORT i152_rep TO l_name
#
#  FOREACH i152_co INTO l_imaa.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#        EXIT FOREACH
#     END IF
#     OUTPUT TO REPORT i152_rep(l_imaa.*)
#  END FOREACH
#
#  FINISH REPORT i152_rep
#
#  CLOSE i152_co
#
#  ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
#
#ND FUNCTION
#
#EPORT i152_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr           RECORD
#                       imaa01       LIKE imaa_file.imaa01,
#                       imaa02       LIKE imaa_file.imaa02,
#                       imaa021      LIKE imaa_file.imaa021,
#                       imaa31       LIKE imaa_file.imaa31,
#                       imaa131      LIKE imaa_file.imaa131,
#                       imaa06       LIKE imaa_file.imaa06,
#                       imaa130      LIKE imaa_file.imaa130
#                    END RECORD
#
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
#
#  ORDER BY sr.imaa01
#
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<','/pageno'
#        PRINT g_head CLIPPED, pageno_total
#        PRINT ''
#
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#
#     ON EVERY ROW
#        PRINT COLUMN g_c[31],sr.imaa01,
#              COLUMN g_c[32],sr.imaa02,
#              COLUMN g_c[33],sr.imaa021,
#              COLUMN g_c[34],sr.imaa31,
#              COLUMN g_c[35],sr.imaa131,
#              COLUMN g_c[36],sr.imaa06,
#              COLUMN g_c[37],sr.imaa130
#
#     ON LAST ROW
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4] CLIPPED, COLUMN (g_len-9) , g_x[7] CLIPPED #No.TQC-5B0212
#        LET l_last_sw = 'y'
#
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-9) , g_x[6] CLIPPED #No.TQC-5B0212
#        ELSE
#           SKIP 2 LINE
#        END IF
#
#END REPORT
#}
#FUN-AC0083 ----------mark end-------------

#FUN-ACV0083 -------mark start------
#{
#FUNCTION i152_copy()
#  DEFINE old_no,new_no    LIKE imaa_file.imaa01
#  DEFINE l_imaa            RECORD LIKE imaa_file.*
#
#  OPEN WINDOW i152_cw WITH FORM "aim/42f/aimi152c"
#        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#
#  CALL cl_ui_locale("aimi152c")
#
#  LET old_no=g_imaa.imaa01
#
#  INPUT BY NAME old_no,new_no WITHOUT DEFAULTS
#
#     AFTER FIELD old_no
#        IF NOT cl_null(old_no) THEN
#           SELECT * INTO l_imaa.* FROM imaa_file WHERE imaa01=old_no
#           IF STATUS THEN
#              CALL cl_err('imaa:',STATUS,0)   #No.FUN-660167
#              CALL cl_err3("sel","imaa_file",old_no,"",STATUS,"","imaa",1)  #No.FUN-660167
#              NEXT FIELD old_no
#           END IF
#        END IF
#
#     AFTER FIELD new_no
#        IF NOT cl_null(new_no) THEN
#           SELECT COUNT(*) INTO i FROM imaa_file WHERE imaa01=new_no
#           IF i > 0 THEN
#              CALL cl_err('sel imaa:','-239',0)
#              NEXT FIELD new_no
#           END IF
#        END IF
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  END INPUT
#
#  IF INT_FLAG THEN
#     LET INT_FLAG=0
#     CLOSE WINDOW i152_cw
#     RETURN
#  END IF
#
#  IF NOT cl_sure(0,0) THEN
#     CLOSE WINDOW i152_cw
#     RETURN
#  END IF
#
#  CLOSE WINDOW i152_cw
#
#  BEGIN WORK
#  LET l_imaa.*=g_imaa.*
#  LET l_imaa.imaa01=new_no
#  #010406 BY ANN CHEN
#  LET l_imaa.imaa05=NULL ##目前使用版本
#  LET l_imaa.imaa18  =0      #單位淨重
#  LET l_imaa.imaa26=0
#  LET l_imaa.imaa261=0
#  LET l_imaa.imaa262=0
#  LET l_imaa.imaa29=null
#  LET l_imaa.imaa30= g_today    #No:7643 新增 aimi100料號時應default imaa30=料件建立日期,以便循環盤點機制
#  LET l_imaa.imaa32=0     #標準售價
#  LET l_imaa.imaa33  =0         #最近售價        #MOD-4B0254
#  LET l_imaa.imaa40  =0         #累計使用數量 期間
#  LET l_imaa.imaa41  =0         #累計使用數量 年度
#  LET l_imaa.imaa47  =0         #採購損耗率
#  LET l_imaa.imaa52  =1         #平均訂購量
#  LET l_imaa.imaa140 ='N'       #phase out
#  LET l_imaa.imaa53  =0         #最近採購單價
#  LET l_imaa.imaa531 =0         #市價
#  LET l_imaa.imaa532 =NULL      #市價最近異動日期
#  LET l_imaa.imaa562 =0         #生產損耗率
#  LET l_imaa.imaa73=null
#  LET l_imaa.imaa74=null
#  LET l_imaa.imaa75  =''        #海關編號
#  LET l_imaa.imaa76  =''        #商品類別
#  LET l_imaa.imaa77  =0         #在途量
#  LET l_imaa.imaa78  =0         #在驗量
# #LET l_imaa.imaa79  =0         #缺料量      #TQC-650066 mark
#  LET l_imaa.imaa80  =0         #未耗預測量
#  LET l_imaa.imaa81  =0         #確認生產量
#  LET l_imaa.imaa82  =0         #計劃量
#  LET l_imaa.imaa83  =0         #MRP需求量
#  LET l_imaa.imaa84  =0         #OM 銷單備置量
#  LET l_imaa.imaa85  =0         #MFP銷單備置量
#  LET l_imaa.imaa881 =NULL      #期間採購最近採購日期
#  LET l_imaa.imaa91  =0         #平均採購單價
#  LET l_imaa.imaa92  ='N'       #net change status
#  LET l_imaa.imaa93  ='NNNNNNNN'#new parts status
#  LET l_imaa.imaa94  =''        #
#  LET l_imaa.imaa95=0
#  LET l_imaa.imaa96  =0         #A. T. P. 量
#  LET l_imaa.imaa97  =0         #MFG 接單量
#  LET l_imaa.imaa98  =0         #OM 接單量
#  LET l_imaa.imaa33  =0         #最近售價   #MOD-4B0254
#  LET l_imaa.imaa100 ='N'
#  LET l_imaa.imaa101 ='1'
#  LET l_imaa.imaa102 ='1'
#  LET l_imaa.imaa104 =0         #廠商分配起始量
#  LET l_imaa.imaa901 = g_today  #料件建檔日期
#  LET l_imaa.imaa139 = 'N'
##No.FUN-640010  --start--                
##  LET l_imaa.imaa1001= ''       #No.FUN-640202 
##  LET l_imaa.imaa1002= ''       #No.FUN-640202  
#  LET l_imaa.imaa1019=0                                                                                                             
#  LET l_imaa.imaa1020=0                                                                                                             
#  LET l_imaa.imaa1021=0                                                                                                             
#  LET l_imaa.imaa1022=0                                                                                                             
#  LET l_imaa.imaa1023=0                                                                                                             
#  LET l_imaa.imaa1024=0                                                                                                             
#  LET l_imaa.imaa1025=0                                                                                                             
#  LET l_imaa.imaa1026=0                                                                                                             
#  LET l_imaa.imaa1027=0                                                                                                             
#  LET l_imaa.imaa1028=0           
##No.FUN-640010  --end--               
#  LET l_imaa.imaa1010= '1'      #No.FUN-610013 
#  LET l_imaa.imaauser=g_user
#  LET l_imaa.imaagrup=g_grup
#  LET l_imaa.imaadate=g_today
#  LET l_imaa.imaamodu=NULL
#  LET l_imaa.imaaacti='Y'
#  IF l_imaa.imaa06 IS NULL THEN
#     LET l_imaa.imaa871 =0         #間接物料分攤率
#     LET l_imaa.imaa872 =''        #材料製造費用成本項目
#     LET l_imaa.imaa873 =0         #間接人工分攤率
#     LET l_imaa.imaa874 =''        #人工製造費用成本項目
#     LET l_imaa.imaa88  =0         #期間採購數量
#     LET l_imaa.imaa89  =0         #期間採購使用的期間(月)
#     LET l_imaa.imaa90  =0         #期間採購使用的期間(日)
#  END IF
#
#  IF l_imaa.imaa35 is null then let l_imaa.imaa35=' ' end if
#  IF l_imaa.imaa36 is null then let l_imaa.imaa36=' ' end if
#
#  LET l_imaa.imaaoriu = g_user      #No.FUN-980030 10/01/04
#  LET l_imaa.imaaorig = g_grup      #No.FUN-980030 10/01/04
#  LET l_imaa.imaa120 = '1'          #No.FUN-A90049 add
#  INSERT INTO imaa_file VALUES(l_imaa.*)
#  IF STATUS THEN 
#     CALL cl_err('ins imaa:',STATUS,0)  #No.FUN-660167
#     CALL cl_err3("ins","imaa_file",l_imaa.imaa01,"",STATUS,"","ins imaa",1)  #No.FUN-660167
#     ROLLBACK WORK 
#     RETURN 
#  END IF
#
#  DROP TABLE x #---------------------------------------- copy smd_file
#  SELECT * FROM smd_file WHERE smd01=old_no INTO TEMP x
#  IF STATUS THEN 
#     CALL cl_err('smd- x:',STATUS,0)   #No.FUN-660167
#     CALL cl_err3("ins","x",old_no,"",STATUS,"","smd- x",1)  #No.FUN-660167
#     ROLLBACK WORK 
#     RETURN 
#  END IF
#
#  UPDATE x SET smd01=new_no
#  INSERT INTO smd_file SELECT * FROM x
#  IF STATUS THEN 
#     CALL cl_err('ins smd:',STATUS,0)  #No.FUN-660167
#     CALL cl_err3("ins","smd_file",new_no,"",STATUS,"","ins smd",1)  #No.FUN-660167
#     ROLLBACK WORK 
#     RETURN 
#  END IF
#
#  DROP TABLE x #---------------------------------------- copy smd_file
#  SELECT * FROM imc_file WHERE imc01=old_no INTO TEMP x
#  IF STATUS THEN 
#     CALL cl_err('imc- x:',STATUS,0)  #No.FUN-660167
#     CALL cl_err3("ins","x",old_no,"",STATUS,"","imc- x",1)  #No.FUN-660167
#     ROLLBACK WORK RETURN 
#  END IF
#
#  UPDATE x SET imc01=new_no
#  INSERT INTO imc_file SELECT * FROM x
#  IF STATUS THEN 
#     CALL cl_err('ins imc:',STATUS,0)  #No.FUN-660167
#     CALL cl_err3("ins","imc_file",new_no,"",STATUS,"","ins imc",1)  #No.FUN-660167
#     ROLLBACK WORK RETURN 
#  END IF
#
#  COMMIT WORK          #---------------------------------------- commit work
#  MESSAGE "Copy Ok!"
#  SELECT imaa_file.* INTO g_imaa.* FROM imaa_file WHERE imaa01=new_no
#
#  CALL i152_show()
#
#END FUNCTION
#}
#FUN-AC0083 --------add end-----------
 
FUNCTION i152_imaa06(p_def) #MOD-490474
 DEFINE p_def         LIKE type_file.chr1,   #MOD-490474 #No.FUN-690026 VARCHAR(1)
        l_ans         LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
        l_msg         LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(57)
        l_imz02       LIKE imz_file.imz02,
        l_imzacti     LIKE imz_file.imzacti,
        l_imaaacti    LIKE imaa_file.imaaacti,
        l_imaauser    LIKE imaa_file.imaauser,
        l_imaagrup    LIKE imaa_file.imaagrup,
        l_imaamodu    LIKE imaa_file.imaamodu,
        l_imaadate    LIKE imaa_file.imaadate
 
  LET g_errno = ' '
  LET l_ans=' '
  SELECT imzacti INTO l_imzacti
    FROM imz_file
   WHERE imz01 = g_imaa.imaa06
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
       WHEN l_imzacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF SQLCA.sqlcode =0 AND cl_null(g_errno) AND p_def = 'Y' THEN #MOD-490474
     CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
     CALL cl_confirm('mfg5033') RETURNING l_ans
     IF l_ans THEN
        SELECT * INTO g_imaa.imaa06,l_imz02,g_imaa.imaa03,g_imaa.imaa04,
                      g_imaa.imaa07,g_imaa.imaa08,g_imaa.imaa09,g_imaa.imaa10,
                      g_imaa.imaa11,g_imaa.imaa12,g_imaa.imaa14,g_imaa.imaa15,
                      g_imaa.imaa17,g_imaa.imaa19,g_imaa.imaa21,
                      g_imaa.imaa23,g_imaa.imaa24,g_imaa.imaa25,g_imaa.imaa27, #No:7703
                      g_imaa.imaa28,g_imaa.imaa31,g_imaa.imaa31_fac,g_imaa.imaa34,
                      g_imaa.imaa35,g_imaa.imaa36,g_imaa.imaa37,g_imaa.imaa38,
                      g_imaa.imaa39,g_imaa.imaa42,g_imaa.imaa43,g_imaa.imaa44,
                      g_imaa.imaa44_fac,g_imaa.imaa45,g_imaa.imaa46,g_imaa.imaa47,
                      g_imaa.imaa48,g_imaa.imaa49,g_imaa.imaa491,g_imaa.imaa50,
                      g_imaa.imaa51,g_imaa.imaa52,g_imaa.imaa54,g_imaa.imaa55,
                      g_imaa.imaa55_fac,g_imaa.imaa56,g_imaa.imaa561,g_imaa.imaa562,
                      g_imaa.imaa571,
                      g_imaa.imaa59, g_imaa.imaa60,g_imaa.imaa61,g_imaa.imaa62,
                      g_imaa.imaa63, g_imaa.imaa63_fac,g_imaa.imaa64,g_imaa.imaa641,
                      g_imaa.imaa65, g_imaa.imaa66,g_imaa.imaa67,g_imaa.imaa68,
                      g_imaa.imaa69, g_imaa.imaa70,g_imaa.imaa71,g_imaa.imaa86,
                      g_imaa.imaa86_fac, g_imaa.imaa87,g_imaa.imaa871,g_imaa.imaa872,
                      g_imaa.imaa873, g_imaa.imaa874,g_imaa.imaa88,g_imaa.imaa89,
                      g_imaa.imaa90,g_imaa.imaa94,g_imaa.imaa99,g_imaa.imaa100,     #NO:6842養生
                      g_imaa.imaa101,g_imaa.imaa102,g_imaa.imaa103,g_imaa.imaa105,  #NO:6842養生
                      g_imaa.imaa106,g_imaa.imaa107,g_imaa.imaa108,g_imaa.imaa109,  #NO:6842養生
                      g_imaa.imaa110,g_imaa.imaa130,g_imaa.imaa131,g_imaa.imaa132,  #NO:6842養生
                      g_imaa.imaa1321,g_imaa.imaa133,g_imaa.imaa134,              #NO:6842養生   NO.FUN-680034
                      g_imaa.imaa147,g_imaa.imaa148,g_imaa.imaa903,
                      l_imaaacti,l_imaauser,l_imaagrup,l_imaamodu,l_imaadate,
                      g_imaa.imaa906,g_imaa.imaa907,g_imaa.imaa908,g_imaa.imaa909 #FUN-540025
          FROM imz_file
         WHERE imz01 = g_imaa.imaa06
        IF g_imaa.imaa99 IS NULL THEN LET g_imaa.imaa99 = 0 END IF
        IF g_imaa.imaa133 IS NULL THEN LET g_imaa.imaa133 = g_imaa.imaa01 END IF
        IF g_imaa.imaa01[1,4]='MISC' THEN #NO:6808(養生)
           LET g_imaa.imaa08='Z'
        END IF
        IF cl_null(g_errno)  AND l_ans ="1"  THEN    #No.MOD-490054
           CALL i152_show()
        END IF
     END IF
  END IF
END FUNCTION
 
FUNCTION i120_imaa(p_key1,p_key2)
    DEFINE p_key1   LIKE tqa_file.tqa01
    DEFINE p_key2   LIKE tqa_file.tqa03
    DEFINE l_tqa02  LIKE tqa_file.tqa02
 
    SELECT tqa02 INTO l_tqa02 FROM tqa_file
     WHERE tqa01 = p_key1 AND tqa03 = p_key2
 
    CASE p_key2
         WHEN '1'
           DISPLAY l_tqa02 TO FORMONLY.tqa02
         WHEN '2'
           DISPLAY l_tqa02 TO FORMONLY.tqa02a
         WHEN '3'
           DISPLAY l_tqa02 TO FORMONLY.tqa02b
         WHEN '4'
           DISPLAY l_tqa02 TO FORMONLY.tqa02c
         WHEN '5'
           DISPLAY l_tqa02 TO FORMONLY.tqa02d
         WHEN '6'
           DISPLAY l_tqa02 TO FORMONLY.tqa02e
    END CASE
END FUNCTION
 
FUNCTION i152_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    # CALL cl_set_comp_entry("imaa01,imaa05,imaa08,imaa02,imaa021,imaa25",TRUE)   #No.MOD-5C0001  #No.MOD-9C0286
      CALL cl_set_comp_entry("imaa01,imaa05,imaa08,imaa02,imaa021",TRUE)          #No.MOD-5C0001  #No.MOD-9C0286
   ELSE                                    #MOD-790140
     CALL cl_set_comp_entry("imaa31",TRUE) #MOD-790140
   END IF
 
   IF INFIELD(imaa141) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("imaa142,imaa143,imaa144,imaa145",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i152_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_errno LIKE type_file.chr1    #No.MOD-5C0001 #No.FUN-690026 VARCHAR(1)
 
   #库存单位和主分群码无条件noentry
   #No.MOD-9C0286  --Begin
   CALL cl_set_comp_entry("imaa06",FALSE)
   CALL cl_set_comp_entry("imaa25",FALSE)
   #No.MOD-9C0286  --End  

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("imaa01,imaa05,imaa08,imaa02,imaa021",FALSE)
   END IF
 
   IF INFIELD(imaa141) OR ( NOT g_before_input_done ) THEN
      IF g_imaa.imaa141 = '0' THEN
         CALL cl_set_comp_entry("imaa142,imaa143,imaa144,imaa145",FALSE)
      END IF
   END IF
 
   IF p_cmd='u' THEN
      CALL s_chkitmdel(g_imaa.imaa01) RETURNING l_errno
   #  CALL cl_set_comp_entry("imaa25",cl_null(l_errno))   #No.MOD-9C0286
   END IF
 
  #MOD-790140 add--start
   IF g_sma.sma115 = 'Y' AND g_imaa.imaa906='2' THEN  #多單位且為母子單位時，銷售單位=庫存單位且不能修改
     LET g_imaa.imaa31=g_imaa.imaa25
     DISPLAY BY NAME g_imaa.imaa31
     CALL cl_set_comp_entry("imaa31",FALSE)
   END IF
  #MOD-790140 add--end
 
END FUNCTION
 
FUNCTION i152_show_pic()
     SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano
     IF g_imaa.imaa1010 MATCHES '[12]' THEN 
         LET g_chr1='Y' 
         LET g_chr2='Y' 
     ELSE 
         LET g_chr1='N' 
         LET g_chr2='N' 
     END IF
     CALL cl_set_field_pic(g_chr1,g_chr2,"","","",g_imaa.imaaacti)
# Memo        	: ps_confirm 確認碼, ps_approve 核准碼, ps_post 過帳碼
#               : ps_close 結案碼, ps_void 作廢碼, ps_valid 有效碼
END FUNCTION


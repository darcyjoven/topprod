# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: arti008.4gl
# Descriptions...: 流通分群碼基本資料
# Date & Author..: NO.FUN-BC0076 11/12/21 By xumm

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_imz               RECORD LIKE imz_file.*,
       g_imz_t             RECORD LIKE imz_file.*,
       g_imz_o             RECORD LIKE imz_file.*,
       g_imz01_t           LIKE imz_file.imz01,
       g_wc,g_sql          STRING
DEFINE p_row,p_col         LIKE type_file.num5  
DEFINE g_before_input_done LIKE type_file.num5    
DEFINE g_chr               LIKE type_file.chr1    
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE type_file.chr1000 
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10  
DEFINE mi_no_ask           LIKE type_file.num5    
DEFINE l_flag1             LIKE type_file.chr1 #單位換算標誌位

 
MAIN
   DEFINE g_forupd_sql     STRING                 
 
   OPTIONS                                
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
  #IF (NOT cl_setup("AIM")) THEN
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_imz.* TO NULL
   INITIALIZE g_imz_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM imz_file WHERE imz01 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i008_curl CURSOR FROM g_forupd_sql             
 
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW arti008_w AT p_row,p_col
     WITH FORM "art/42f/arti008"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 

   LET g_action_choice=""
   CALL i008_menu()
 
   CLOSE WINDOW i008_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION i008_curs()
 
   CLEAR FORM
 
   INITIALIZE g_imz.* TO NULL   

   CONSTRUCT BY NAME g_wc ON imz01,imz02,imz08,imz131,imz25,imz44,imz31,
                             imz09,imz10,imz11,imz54,imz72,imz45,imz46,
                             imz47,imz12,imz39,imz73,imzuser,imzgrup,
                             imzoriu,imzmodu,imzdate,imzorig,imzacti
                            
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(imz01) #料件分群碼
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imz01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imz01
              NEXT FIELD imz01

         WHEN INFIELD(imz131) #產品分類
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imz131"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imz131
              NEXT FIELD imz131
              
         WHEN INFIELD(imz25) #庫存單位
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz25
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz25
            NEXT FIELD imz25

         WHEN INFIELD(imz44) #採購單位
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz44
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz44
            NEXT FIELD imz44

         WHEN INFIELD(imz31) #銷售單位
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz31
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz31
            NEXT FIELD imz31

         WHEN INFIELD(imz09) #其他分群碼一
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz09
            LET g_qryparam.arg1 = "D"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz09
            CALL i110_azf01(g_imz.imz09,'D','d')    
            NEXT FIELD imz09
            
         WHEN INFIELD(imz10) #其他分群碼二
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz10
            LET g_qryparam.arg1 = "E"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL i110_azf01(g_imz.imz10,'E','d')   
            DISPLAY g_qryparam.multiret TO imz10
            NEXT FIELD imz10
            
         WHEN INFIELD(imz11) #其他分群碼三
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz11
            LET g_qryparam.arg1 = "F"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz11
            CALL i110_azf01(g_imz.imz11,'F','d')    
            NEXT FIELD imz11

         WHEN INFIELD(imz54) #主供應商
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_imz54"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz54
            NEXT FIELD imz54

         WHEN INFIELD(imz12) #成本分群碼
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz12
            LET g_qryparam.arg1 = "G"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz12
            NEXT FIELD imz12

         WHEN INFIELD(imz39) #會計科目
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_aag02"  
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz39
            LET g_qryparam.arg1 = g_aza.aza81 
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz39
            NEXT FIELD imz39

         WHEN INFIELD(imz73) #代銷科目
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_aag02"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz73
            LET g_qryparam.arg1 = g_aza.aza81
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz73
            NEXT FIELD imz73
            
         OTHERWISE EXIT CASE
      END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
        
      ON ACTION HELP 
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     

      ON ACTION qbe_select
         CALL cl_qbe_select()
        
      ON ACTION qbe_save
         CALL cl_qbe_save()
         
   END CONSTRUCT
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imzuser', 'imzgrup')
 
   LET g_sql= "SELECT imz01 FROM imz_file ",
              " WHERE ",g_wc CLIPPED, " ORDER BY imz01"
   PREPARE i008_prepare FROM g_sql          
   DECLARE i008_curs                       
       SCROLL CURSOR WITH HOLD FOR i008_prepare
   LET g_sql= "SELECT COUNT(*) FROM imz_file WHERE ",g_wc CLIPPED
   PREPARE i008_precount FROM g_sql
   DECLARE i008_count CURSOR FOR i008_precount
   
END FUNCTION

FUNCTION i008_azf01(p_key,p_key2,p_cmd)    #類別
    DEFINE p_key     LIKE azf_file.azf01,
           p_cmd     LIKE type_file.chr1,
           p_key2    LIKE azf_file.azf02,
           l_azf03   LIKE azf_file.azf03,
           l_azfacti LIKE azf_file.azfacti
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_azf03=NULL
        LET g_chr = 'E'
    ELSE SELECT azf03,azfacti INTO l_azf03,l_azfacti
           FROM azf_file
               WHERE azf01 = p_key
                 AND azf02 = p_key2
            IF SQLCA.sqlcode THEN
                LET g_chr = 'E'
                LET l_azf03 = NULL
            ELSE
                IF l_azfacti matches'[Nn]' THEN
                    LET g_chr = 'E'
                END IF
            END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd' THEN
       CASE  p_key2
          WHEN "8"
                DISPLAY l_azf03 TO azf03
          WHEN "D"
                DISPLAY l_azf03 TO azf03_1
          WHEN "E"
                DISPLAY l_azf03 TO azf03_2
          WHEN "F"
                DISPLAY l_azf03 TO azf03_3
          OTHERWISE 
       END CASE
  END IF
END FUNCTION

FUNCTION i008_imz09()
   DEFINE l_azfacti       LIKE azf_file.azfacti

   LET g_errno = ' '
   SELECT azfacti 
     INTO l_azfacti
     FROM azf_file
    WHERE azf01=g_imz.imz09
      AND azf02='D'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
        WHEN l_azfacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i008_imz10()
   DEFINE l_azfacti       LIKE azf_file.azfacti

   LET g_errno = ' '
   SELECT azfacti  
     INTO l_azfacti
     FROM azf_file
    WHERE azf01=g_imz.imz10
      AND azf02='E'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
        WHEN l_azfacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i008_imz11()
   DEFINE l_azfacti       LIKE azf_file.azfacti

   LET g_errno = ' '
   SELECT azfacti
     INTO l_azfacti
     FROM azf_file
    WHERE azf01=g_imz.imz11
      AND azf02='F'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
        WHEN l_azfacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i008_imz12()
   DEFINE l_azfacti       LIKE azf_file.azfacti

   LET g_errno = ' '
   SELECT azfacti
     INTO l_azfacti
     FROM azf_file
    WHERE azf01=g_imz.imz12
      AND azf02='G'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
        WHEN l_azfacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i008_imz131()  
   DEFINE l_obaacti       LIKE oba_file.obaacti
          
   LET g_errno = ' '
   SELECT obaacti
     INTO l_obaacti
     FROM oba_file
    WHERE oba01 = g_imz.imz131
      AND oba14 = 0

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-040'
        WHEN l_obaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i008_imz44()
   DEFINE l_gfeacti       LIKE gfe_file.gfeacti

   LET g_errno = ' '
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_imz.imz44

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apm-047'
        WHEN l_gfeacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i008_imz31()
   DEFINE l_gfeacti       LIKE gfe_file.gfeacti

   LET g_errno = ' '
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_imz.imz31
   
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1311'
        WHEN l_gfeacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i008_imz54()
   DEFINE l_pmcacti       LIKE pmc_file.pmcacti

   LET g_errno = ' '
   SELECT pmcacti
     INTO l_pmcacti
     FROM pmc_file
    WHERE pmc01 = g_imz.imz54

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-031'
        WHEN l_pmcacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
FUNCTION i008_desc()
DEFINE l_oba02          LIKE oba_file.oba02
DEFINE l_flag1           LIKE type_file.num5
DEFINE l_flag2           LIKE type_file.num5
DEFINE l_imz44_fac      LIKE imz_file.imz44_fac
DEFINE l_imz31_fac      LIKE imz_file.imz31_fac
DEFINE l_azf03_1        LIKE azf_file.azf03
DEFINE l_azf03_2        LIKE azf_file.azf03
DEFINE l_azf03_3        LIKE azf_file.azf03

   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_imz.imz131
   DISPLAY l_oba02 TO FORMONLY.oba02
  #Mark ---
  #CALL s_umfchk(g_imz.imz01,g_imz.imz44,g_imz.imz25) RETURNING l_flag1,l_imz44_fac
  #IF l_flag1 = '0' THEN
  #   DISPLAY l_imz44_fac TO FORMONLY.imz44_fac
  #END IF
  #CALL s_umfchk(g_imz.imz01,g_imz.imz31,g_imz.imz25) RETURNING l_flag1,l_imz31_fac
  #IF l_flag1 = '0' THEN
  #   DISPLAY l_imz31_fac TO FORMONLY.imz31_fac
  #END IF
  #Mark ---
   SELECT azf03 INTO l_azf03_1 FROM azf_file WHERE azf01 = g_imz.imz09 AND azf02 = 'D'
   DISPLAY l_azf03_1 TO FORMONLY.azf03_1
   SELECT azf03 INTO l_azf03_2 FROM azf_file WHERE azf01 = g_imz.imz10 AND azf02 = 'E'
   DISPLAY l_azf03_2 TO FORMONLY.azf03_2
   SELECT azf03 INTO l_azf03_3 FROM azf_file WHERE azf01 = g_imz.imz11 AND azf02 = 'F'
   DISPLAY l_azf03_3 TO FORMONLY.azf03_3
   
END FUNCTION
 
FUNCTION i008_menu()
   DEFINE  l_cmd        LIKE type_file.chr1000  
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i008_a()
           END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i008_q()
           END IF
        ON ACTION next
           CALL i008_fetch('N')
        ON ACTION previous
           CALL i008_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL i008_u()
           END IF
        ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
              CALL i008_x()
           END IF
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL i008_r()
           END IF
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL i008_copy()
           END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont() 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL i008_fetch('/')
        ON ACTION first
           CALL i008_fetch('F')
        ON ACTION last
           CALL i008_fetch('L')
        ON ACTION controlg
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
        ON ACTION about         
           CALL cl_about() 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_imz.imz01 IS NOT NULL THEN
                 LET g_doc.column1 = "imz01"
                 LET g_doc.value1 = g_imz.imz01
                 CALL cl_doc()
              END IF
           END IF
        ON ACTION CLOSE   
           LET INT_FLAG=FALSE 	
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
    CLOSE i008_curs
END FUNCTION
 
 
FUNCTION i008_a()
    IF s_shut(0) THEN 
       RETURN 
    END IF
    
    MESSAGE ""
    CLEAR FORM                                  
    INITIALIZE g_imz.* LIKE imz_file.*
    LET g_imz01_t = NULL
    LET g_imz_t.*=g_imz.*
    LET g_wc = NULL
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i008_def()

        CALL i008_desc() 
        CALL i008_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_imz.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_imz.imz01 IS NULL OR g_imz.imz01 = ' ' THEN 
           CONTINUE WHILE
        END IF

       #單位處理
        IF cl_null(g_imz.imz31) THEN
           LET g_imz.imz31=g_imz.imz25
           LET g_imz.imz31_fac = 1
        ELSE
           CALL s_umfchk('',g_imz.imz31,g_imz.imz25) RETURNING l_flag1,g_imz.imz31_fac
           IF l_flag1 <> '0' THEN
              LET g_imz.imz31=g_imz.imz25
              LET g_imz.imz31_fac = 1
           END IF
        END IF
        IF cl_null(g_imz.imz44) THEN
           LET g_imz.imz44=g_imz.imz25
           LET g_imz.imz44_fac = 1
        ELSE
           CALL s_umfchk('',g_imz.imz44,g_imz.imz25) RETURNING l_flag1,g_imz.imz44_fac
           IF l_flag1 <> '0' THEN
              LET g_imz.imz44=g_imz.imz25
              LET g_imz.imz44_fac = 1
           END IF
        END IF
        
        INSERT INTO imz_file VALUES(g_imz.*) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        ELSE
            LET g_imz_t.* = g_imz.* 
            SELECT imz01 INTO g_imz.imz01 
              FROM imz_file
             WHERE imz01 = g_imz.imz01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i008_def()
    LET g_imz.imz07 = 'A'
    LET g_imz.imz14 = 'N'
    LET g_imz.imz15 = 'N'
    LET g_imz.imz24 = 'N'
    LET g_imz.imz27 = 0
    LET g_imz.imz28 = 0
    LET g_imz.imz37 = '0'
    LET g_imz.imz38 = 0
    LET g_imz.imz45 = 1
    LET g_imz.imz46 = 0
    LET g_imz.imz47 = 0
    LET g_imz.imz48 = 0
    LET g_imz.imz49 = 0
    LET g_imz.imz491 = 0
    LET g_imz.imz50 = 0
    LET g_imz.imz51 = 1
    LET g_imz.imz52 = 1
    LET g_imz.imz56 = 1
    LET g_imz.imz561 = 0  #最少生產數量
    LET g_imz.imz562 = 0  #生產時損耗率
    LET g_imz.imz59 = 0
    LET g_imz.imz60 = 0
    LET g_imz.imz61 = 0
    LET g_imz.imz62 = 0
    LET g_imz.imz64 = 1
    LET g_imz.imz641 = 1   #最少發料數量
    LET g_imz.imz65 = 0
    LET g_imz.imz66 = 0
    LET g_imz.imz68 = 0
    LET g_imz.imz69 = 0
    LET g_imz.imz70 = 'N'
    LET g_imz.imz71 = 0
    LET g_imz.imz72 = '0'
    LET g_imz.imz871 = 0
    LET g_imz.imz873 = 0
    LET g_imz.imz99 = 0
    LET g_imz.imz100 = 'N'
    LET g_imz.imz101 = '1'
    LET g_imz.imz102 = '1'
    LET g_imz.imz103 = '0'
    LET g_imz.imz105 = 'N'
    LET g_imz.imz107 = 'N'
    LET g_imz.imz108 = 'N'
    LET g_imz.imz110 = '1'
    LET g_imz.imz130 = '1'
    LET g_imz.imz147 = 'N'
    LET g_imz.imz148 = 0
    LET g_imz.imz150 = '0'
    LET g_imz.imz152 = '0'
    LET g_imz.imz156 = 'N'
    LET g_imz.imz158 = 'N'
    LET g_imz.imz159 = '3'
    LET g_imz.imz601 = 1
    LET g_imz.imz903 = 'N'
    LET g_imz.imz906 = '1'
    LET g_imz.imz909 = 0
    LET g_imz.imz911 = 'N'
    LET g_imz.imz918 = 'N'
    LET g_imz.imz919 = 'N'
    LET g_imz.imz921 = 'N'
    LET g_imz.imz922 = 'N'
    LET g_imz.imz924 = 'N'
    LET g_imz.imz926 = 'N'
    LET g_imz.imz928 = 'N'
    LET g_imz.imz022 = 0
    LET g_imz.imzicd04 = '9'
    LET g_imz.imzicd05 = '6'
    LET g_imz.imzicd08 = 'N'
    LET g_imz.imzicd09 = 'N'
    LET g_imz.imzicd12 = 0
    LET g_imz.imzicd14 = 0
    LET g_imz.imzicd15 = 0
    LET g_imz.imzicd17 = '3'
    LET g_imz.imz08 = 'P'
    LET g_imz.imz72 = '0'
    LET g_imz.imzacti ='Y'
    LET g_imz.imzuser = g_user
    LET g_imz.imzoriu = g_user
    LET g_imz.imzorig = g_grup
    LET g_imz.imzgrup = g_grup
    LET g_imz.imzdate = g_today
END FUNCTION

FUNCTION i008_i(p_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1,    
            l_n        LIKE type_file.num5
   
   DISPLAY BY NAME 
           g_imz.imz01,g_imz.imz02,g_imz.imz08,g_imz.imz131,
           g_imz.imz25,g_imz.imz44,g_imz.imz31,g_imz.imz09,
           g_imz.imz10,g_imz.imz11,g_imz.imz54,g_imz.imz72,
           g_imz.imz45,g_imz.imz46,g_imz.imz47,g_imz.imz12,
           g_imz.imz39,g_imz.imz73,g_imz.imzuser,g_imz.imzgrup,
           g_imz.imzoriu,g_imz.imzmodu,g_imz.imzdate,g_imz.imzorig,g_imz.imzacti
   CALL i008_desc()
   INPUT BY NAME
           g_imz.imz01,g_imz.imz02,g_imz.imz08,g_imz.imz131,
           g_imz.imz25,g_imz.imz44,g_imz.imz31,g_imz.imz09,
           g_imz.imz10,g_imz.imz11,g_imz.imz54,g_imz.imz72,
           g_imz.imz45,g_imz.imz46,g_imz.imz47,g_imz.imz12,
           g_imz.imz39,g_imz.imz73,g_imz.imzuser,g_imz.imzgrup,
           g_imz.imzoriu,g_imz.imzmodu,g_imz.imzdate,g_imz.imzorig,g_imz.imzacti
           
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD imz01
         IF NOT cl_null(g_imz.imz01) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_imz.imz01 != g_imz01_t) THEN
               SELECT count(*) INTO l_n FROM imz_file
                WHERE imz01 = g_imz.imz01
               IF l_n > 0 THEN 
                  CALL cl_err(g_imz.imz01,-239,0)
                  LET g_imz.imz01 = g_imz01_t
                  DISPLAY BY NAME g_imz.imz01
                  NEXT FIELD imz01
               END IF
            END IF
         END IF
 
      AFTER FIELD imz08  #來源碼
         IF g_imz.imz08 NOT MATCHES "[CTDAMPXKUVRZS]"
            AND g_imz.imz08 IS NOT NULL THEN
            CALL cl_err(g_imz.imz08,'mfg1001',0)
               LET g_imz.imz08 = g_imz_o.imz08
               DISPLAY BY NAME g_imz.imz08
               NEXT FIELD imz08
         END IF
         LET g_imz_o.imz08 = g_imz.imz08
 
      AFTER FIELD imz09                     #其他分群碼一
         IF g_imz.imz09 IS NOT NULL AND g_imz.imz09 != ' ' THEN
            IF (g_imz_o.imz09 IS NULL) OR (g_imz.imz09 != g_imz_o.imz09) THEN
               CALL i008_imz09()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_imz.imz09 = g_imz_o.imz09
                  DISPLAY BY NAME g_imz.imz09
                  NEXT FIELD imz09
               END IF
               CALL i008_azf01(g_imz.imz09,'D','a')  
            END IF
         END IF
         CALL i008_desc()
         LET g_imz_o.imz09 = g_imz.imz09
 
      AFTER FIELD imz10                     #其他分群碼二
         IF g_imz.imz10 IS NOT NULL AND g_imz.imz10 != ' ' THEN
            IF (g_imz_o.imz10 IS NULL) OR (g_imz.imz10 != g_imz_o.imz10) THEN
               CALL i008_imz10()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_imz.imz10 = g_imz_o.imz10
                  DISPLAY BY NAME g_imz.imz10
                  NEXT FIELD imz10
               END IF
               CALL i008_azf01(g_imz.imz10,'E','a')    
            END IF
         END IF
         CALL i008_desc()
         LET g_imz_o.imz10 = g_imz.imz10
 
      AFTER FIELD imz11                     #其他分群碼三
         IF g_imz.imz11 IS NOT NULL AND g_imz.imz11 != ' ' THEN
            IF (g_imz_o.imz11 IS NULL ) OR (g_imz_o.imz11 != g_imz.imz11) THEN
               CALL i008_imz11()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_imz.imz11 = g_imz_o.imz11
                  DISPLAY BY NAME g_imz.imz11
                  NEXT FIELD imz11
               END IF
               CALL i008_azf01(g_imz.imz11,'F','a')   
            END IF
         END IF
         CALL i008_desc()
         LET g_imz_o.imz11 = g_imz.imz11
 
      AFTER FIELD imz12                     #成本分群碼
         IF g_imz.imz12 IS NOT NULL AND g_imz.imz12 != ' ' THEN
            IF (g_imz_o.imz12 IS NULL) OR (g_imz_o.imz12 != g_imz.imz12) THEN
               CALL i008_imz12()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_imz.imz12 = g_imz_o.imz12
                  DISPLAY BY NAME g_imz.imz12
                  NEXT FIELD imz12
               END IF
            END IF
         END IF
         LET g_imz_o.imz12 = g_imz.imz12
 
      AFTER FIELD imz39  #會計科目, 可空白, 須存在
         IF g_imz.imz39 IS NOT NULL THEN
            IF g_sma.sma03='Y' THEN
               IF NOT s_actchk3(g_imz.imz39,g_aza.aza81) THEN  
                  CALL cl_err('','aim-395','0')
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imz.imz39 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz39 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imz.imz39
                  DISPLAY BY NAME g_imz.imz39  
                  NEXT FIELD imz39
               END IF
            END IF
         END IF
 
      AFTER FIELD imz73  #代銷科目, 可空白, 須存在
         IF g_imz.imz73 IS NOT NULL THEN
            IF g_sma.sma03='Y' THEN
               IF NOT s_actchk3(g_imz.imz73,g_aza.aza81) THEN
                  CALL cl_err('','aim-395','0')
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imz.imz73 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz73 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imz.imz73
                  DISPLAY BY NAME g_imz.imz73  
                  NEXT FIELD imz73
               END IF
            END IF
         END IF

      AFTER FIELD imz131
         IF NOT cl_null(g_imz.imz131) THEN
            CALL i008_imz131()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_imz.imz131 = g_imz_t.imz131
               NEXT FIELD imz131
            END IF
            CALL i008_desc()
         END IF
          
      AFTER FIELD imz25            #庫存單位
         IF g_imz.imz25 IS NOT NULL THEN
            IF (g_imz_o.imz25 IS NULL) OR (g_imz_o.imz25 != g_imz.imz25) THEN
               #當執行複製功能後,修改了庫存單位要同步更新到其他單位欄位
               IF g_action_choice="reproduce" THEN
                  LET g_imz.imz31 =g_imz.imz25        #銷售單位
                  LET g_imz.imz31_fac=1               #銷售單位/庫存單位換算率
                  LET g_imz.imz44 =g_imz.imz25        #採購單位
                  LET g_imz.imz44_fac=1               #採購單位/庫存單位換算率
                  LET g_imz.imz55 =g_imz.imz25        #生產單位
                  LET g_imz.imz55_fac=1               #生產單位/庫存單位換算率
                  LET g_imz.imz63 =g_imz.imz25        #發料單位
                  LET g_imz.imz63_fac=1               #發料單位/庫存單位換算率
                  LET g_imz.imz86 =g_imz.imz25        #成本單位
                  LET g_imz.imz86_fac=1               #成本單位/庫存單位換算率
               END IF
               SELECT gfe01 FROM gfe_file
                WHERE gfe01=g_imz.imz25 AND gfeacti IN ('y','Y')
               IF SQLCA.sqlcode THEN 
                  CALL cl_err3("sel","gfe_file",g_imz.imz25,"","mfg1200","","",1) 
                  LET g_imz.imz25 = g_imz_o.imz25
                  DISPLAY BY NAME g_imz.imz25
                  NEXT FIELD imz25
               END IF
               IF cl_null(g_imz.imz44) THEN
                  LET g_imz.imz44 = g_imz.imz25
                  LET g_imz.imz44_fac = 1
               END IF
               IF cl_null(g_imz.imz31) THEN
                  LET g_imz.imz31 = g_imz.imz25
                  LET g_imz.imz31_fac = 1
               END IF
               IF cl_null(g_imz.imz55) THEN
                  LET g_imz.imz55 = g_imz.imz25
                  LET g_imz.imz55_fac = 1
               END IF
               IF cl_null(g_imz.imz63) THEN
                  LET g_imz.imz63 = g_imz.imz25
                  LET g_imz.imz63_fac = 1
               END IF
               IF cl_null(g_imz.imz86) THEN
                  LET g_imz.imz86 = g_imz.imz25
                  LET g_imz.imz86_fac = 1
               END IF
               DISPLAY BY NAME g_imz.imz31,g_imz.imz44,g_imz.imz31_fac,g_imz.imz44_fac
            END IF
         END IF
         CALL i008_desc()

      BEFORE FIELD imz44
         IF cl_null(g_imz.imz44) THEN
            IF NOT cl_null(g_imz.imz25) THEN
               LET g_imz.imz44 = g_imz.imz25
               LET g_imz.imz44_fac = 1
               DISPLAY BY NAME g_imz.imz44,g_imz.imz44_fac
            END IF
         END IF
      
      AFTER FIELD imz44
         IF NOT cl_null(g_imz.imz44) THEN
            CALL i008_imz44()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_imz.imz44 = g_imz_t.imz44
               NEXT FIELD imz44
            END IF
            CALL s_umfchk('',g_imz.imz44,g_imz.imz25) RETURNING l_flag1,g_imz.imz44_fac
            IF l_flag1 THEN
               CALL cl_err('','art-066',0)
               NEXT FIELD imz44
            END IF
            DISPLAY BY NAME g_imz.imz44_fac
         END IF   

      BEFORE FIELD imz31
         IF cl_null(g_imz.imz31) THEN
            IF NOT cl_null(g_imz.imz25) THEN
               LET g_imz.imz31 = g_imz.imz25
               LET g_imz.imz31_fac = 1
               DISPLAY BY NAME g_imz.imz31,g_imz.imz31_fac
            END IF
         END IF
      
      AFTER FIELD imz31
         IF NOT cl_null(g_imz.imz31) THEN
            CALL i008_imz31()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_imz.imz31 = g_imz_t.imz31
               NEXT FIELD imz31
            END IF
            CALL s_umfchk('',g_imz.imz31,g_imz.imz25) RETURNING l_flag1,g_imz.imz31_fac
            IF l_flag1 THEN
               CALL cl_err('','art-066',0)
               NEXT FIELD imz31
            END IF
            DISPLAY BY NAME g_imz.imz31_fac
         END IF

      AFTER FIELD imz54
         IF NOT cl_null(g_imz.imz54) THEN
            CALL i008_imz54()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_imz.imz54 = g_imz_t.imz54
               NEXT FIELD imz54
            END IF
         END IF
    
      AFTER FIELD imz45
         IF NOT cl_null(g_imz.imz45) THEN
            IF g_imz.imz45 < 0 THEN
               CALL cl_err(g_imz.imz45,'alm-061',0)
               LET g_imz.imz45 = g_imz_t.imz45
               NEXT FIELD imz45
            END IF
         END IF

      AFTER FIELD imz46
         IF NOT cl_null(g_imz.imz46) THEN
            IF g_imz.imz46 < 0 THEN
               CALL cl_err(g_imz.imz46,'alm-061',0)
               LET g_imz.imz46 = g_imz_t.imz46
               NEXT FIELD imz46
            END IF
         END IF

      AFTER FIELD imz47
         IF NOT cl_null(g_imz.imz47) THEN
            IF g_imz.imz47 < 0 THEN
               CALL cl_err(g_imz.imz47,'alm-061',0)
               LET g_imz.imz47 = g_imz_t.imz47
               NEXT FIELD imz47
            END IF
         END IF

      AFTER INPUT
         LET g_imz.imzuser = s_get_data_owner("imz_file") #FUN-C10039
         LET g_imz.imzgrup = s_get_data_group("imz_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(imz131) #產品分類
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oba"
                LET g_qryparam.default1 = g_imz.imz131
                LET g_qryparam.where = "obaacti = 'Y' AND oba14 = '0'"
                CALL cl_create_qry() RETURNING g_imz.imz131
                DISPLAY BY NAME g_imz.imz131
                NEXT FIELD imz131
              
             WHEN INFIELD(imz09) #其他分群碼一
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz09
                LET g_qryparam.arg1 = "D"
                CALL cl_create_qry() RETURNING g_imz.imz09
                DISPLAY BY NAME g_imz.imz09
                CALL i008_azf01(g_imz.imz09,'D','d')  
                NEXT FIELD imz09
                
             WHEN INFIELD(imz10) #其他分群碼二
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz10
                LET g_qryparam.arg1 = "E"
                CALL cl_create_qry() RETURNING g_imz.imz10
                DISPLAY BY NAME g_imz.imz10
                CALL i008_azf01(g_imz.imz10,'E','d') 
                NEXT FIELD imz10
                
             WHEN INFIELD(imz11) #其他分群碼三
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz11
                LET g_qryparam.arg1 = "F"
                CALL cl_create_qry() RETURNING g_imz.imz11
                DISPLAY BY NAME g_imz.imz11
                CALL i008_azf01(g_imz.imz11,'F','d') 
                NEXT FIELD imz11
                
             WHEN INFIELD(imz12) #成本分群碼
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz12
                LET g_qryparam.arg1 = "G"
                CALL cl_create_qry() RETURNING g_imz.imz12
                DISPLAY BY NAME g_imz.imz12
                NEXT FIELD imz12
      
             WHEN INFIELD(imz39) #會計科目
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"  
                LET g_qryparam.default1 = g_imz.imz39
                LET g_qryparam.arg1 = g_aza.aza81
                CALL cl_create_qry() RETURNING g_imz.imz39
                DISPLAY BY NAME g_imz.imz39
                NEXT FIELD imz39
           
             WHEN INFIELD(imz73) #代銷科目
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.default1 = g_imz.imz73
                LET g_qryparam.arg1 = g_aza.aza81
                CALL cl_create_qry() RETURNING g_imz.imz73
                DISPLAY BY NAME g_imz.imz73
                NEXT FIELD imz73

             WHEN INFIELD(imz25) #庫存單位
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imz.imz25
                CALL cl_create_qry() RETURNING g_imz.imz25
                DISPLAY BY NAME g_imz.imz25
                NEXT FIELD imz25

             WHEN INFIELD(imz44) #採購單位
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imz.imz44
                CALL cl_create_qry() RETURNING g_imz.imz44
                DISPLAY BY NAME g_imz.imz44
                NEXT FIELD imz44

             WHEN INFIELD(imz31) #銷售單位
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imz.imz31
                CALL cl_create_qry() RETURNING g_imz.imz31
                DISPLAY BY NAME g_imz.imz31
                NEXT FIELD imz31

             WHEN INFIELD(imz54) #主供应商
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmc1"
                LET g_qryparam.default1 = g_imz.imz54
                CALL cl_create_qry() RETURNING g_imz.imz54
                DISPLAY BY NAME g_imz.imz54
                NEXT FIELD imz54
          
             OTHERWISE EXIT CASE
          END CASE
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      

      ON ACTION help        
         CALL cl_show_help()  
 
    END INPUT

END FUNCTION

FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1   
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imz01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1   
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imz01",FALSE)
   END IF
END FUNCTION
 
FUNCTION i110_azf01(p_key,p_key2,p_cmd)    #類別
    DEFINE p_key     LIKE azf_file.azf01,
           p_cmd     LIKE type_file.chr1,
           p_key2    LIKE azf_file.azf02,
           l_azf03   LIKE azf_file.azf03,
           l_azfacti LIKE azf_file.azfacti
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_azf03=NULL
        LET g_chr = 'E'
    ELSE SELECT azf03,azfacti INTO l_azf03,l_azfacti
           FROM azf_file
               WHERE azf01 = p_key
                 AND azf02 = p_key2
            IF SQLCA.sqlcode THEN
                LET g_chr = 'E'
                LET l_azf03 = NULL
            ELSE
                IF l_azfacti matches'[Nn]' THEN
                    LET g_chr = 'E'
                END IF
            END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd' THEN
       CASE  p_key2
          WHEN "8"
                DISPLAY l_azf03 TO azf03
          WHEN "D"
                DISPLAY l_azf03 TO azf03_1
          WHEN "E"
                DISPLAY l_azf03 TO azf03_2
          WHEN "F"
                DISPLAY l_azf03 TO azf03_3
          OTHERWISE 
       END CASE
  END IF
END FUNCTION
 
FUNCTION i008_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i008_curs()                        
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i008_count
    FETCH i008_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i008_curs               
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL
    ELSE
        CALL i008_fetch('F')                 
    END IF
END FUNCTION
 
FUNCTION i008_fetch(p_flimz)
    DEFINE
        p_flimz         LIKE type_file.chr1,    
        l_abso          LIKE type_file.num10  
 
    CASE p_flimz
        WHEN 'N' FETCH NEXT     i008_curs INTO g_imz.imz01
        WHEN 'P' FETCH PREVIOUS i008_curs INTO g_imz.imz01
        WHEN 'F' FETCH FIRST    i008_curs INTO g_imz.imz01
        WHEN 'L' FETCH LAST     i008_curs INTO g_imz.imz01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED || ': ' FOR g_jump  
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about        
                     CALL cl_about()      
 
                  ON ACTION HELP          
                     CALL cl_show_help()  
 
                  ON ACTION controlg     
                     CALL cl_cmdask()    
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i008_curs INTO g_imz.imz01 
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL 
        RETURN
    ELSE
       CASE p_flimz
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_imz.* FROM imz_file        
       WHERE imz01 = g_imz.imz01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","imz_file",g_imz.imz01,"",
                     SQLCA.sqlcode,"","",1)  
    ELSE
        LET g_data_owner = g_imz.imzuser 
        LET g_data_group = g_imz.imzgrup
        CALL i008_show()                      
    END IF
END FUNCTION
 
FUNCTION i008_show()
    LET g_imz_t.* = g_imz.*
    DISPLAY BY NAME 
           g_imz.imz01,g_imz.imz02,g_imz.imz08,g_imz.imz131,
           g_imz.imz25,g_imz.imz44,g_imz.imz44_fac,g_imz.imz31,g_imz.imz31_fac,g_imz.imz09,
           g_imz.imz10,g_imz.imz11,g_imz.imz54,g_imz.imz72,
           g_imz.imz45,g_imz.imz46,g_imz.imz47,g_imz.imz12,
           g_imz.imz39,g_imz.imz73,g_imz.imzuser,g_imz.imzgrup,
           g_imz.imzoriu,g_imz.imzmodu,g_imz.imzdate,g_imz.imzorig,g_imz.imzacti
    
    CALL i008_desc()       
    CALL i110_azf01(g_imz.imz09,'D','d')
    CALL i110_azf01(g_imz.imz10,'E','d')
    CALL i110_azf01(g_imz.imz11,'F','d')
    CALL i110_azf01(g_imz.imz12,'G','d')
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i008_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_imz.* FROM imz_file WHERE imz01=g_imz.imz01
    IF g_imz.imzacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imz.imz01,'mfg1000',0)
        RETURN
    END IF
    
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imz01_t = g_imz.imz01
    LET g_imz_o.* = g_imz.*
    BEGIN WORK
    OPEN i008_curl USING g_imz.imz01
    FETCH i008_curl INTO g_imz.* 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imz.imzmodu=g_user                     #修改者
    LET g_imz.imzdate = g_today                  #修改日期
 
    CALL i008_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i008_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imz.*=g_imz_t.*
            CALL i008_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        UPDATE imz_file SET imz_file.* = g_imz.*  
            WHERE imz01 = g_imz01_t 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","imz_file",g_imz_t.imz01,"",SQLCA.sqlcode,"","",1)  
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i008_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i008_x()
    DEFINE l_chr LIKE type_file.chr1   
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i008_curl USING g_imz.imz01
    FETCH i008_curl INTO g_imz.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i008_show()
    SELECT ima06 FROM ima_file WHERE ima06=g_imz.imz01
                                 AND imaacti IN ('Y','y')
    IF STATUS =0 OR STATUS=-284 THEN 
       CALL cl_err3("sel","ima_file",g_imz.imz01,"","mfg9045","","",1) 
       RETURN
    END IF
    IF cl_exp(0,0,g_imz.imzacti) THEN
        LET g_chr=g_imz.imzacti
        IF g_imz.imzacti='Y' THEN
            LET g_imz.imzacti='N'
        ELSE
            LET g_imz.imzacti='Y'
        END IF
        UPDATE imz_file
            SET imzacti=g_imz.imzacti,
                imzmodu=g_user, imzdate=g_today
            WHERE imz01=g_imz.imz01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  
           LET g_imz.imzacti=g_chr
        END IF
        DISPLAY BY NAME g_imz.imzacti
    END IF
    CLOSE i008_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i008_r()
    DEFINE l_chr LIKE type_file.chr1 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i008_curl USING g_imz.imz01
    FETCH i008_curl INTO g_imz.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0) RETURN END IF
    CALL i008_show()
    SELECT ima06 FROM ima_file
     WHERE ima06=g_imz.imz01
       AND imaacti IN ('Y','y')
    IF STATUS =0 OR STATUS =-284 THEN 
       CALL cl_err3("sel","ima_file",g_imz.imz01,"","mfg9045","","",1)  
       RETURN
    END IF
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "imz01" 
        LET g_doc.value1 = g_imz.imz01   
        CALL cl_del_doc()                                       
        DELETE FROM imz_file WHERE imz01 = g_imz.imz01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  
        ELSE
           CLEAR FORM
        END IF
    END IF
         OPEN i008_count
         IF STATUS THEN
            CLOSE i008_count
            RETURN
         END IF
         FETCH i008_count INTO g_row_count
         IF STATUS THEN
            CLOSE i008_count
            RETURN
         END IF
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i008_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i008_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i008_fetch('/')
         END IF
    CLOSE i008_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i008_copy()
    DEFINE
        l_imz           RECORD LIKE imz_file.*,
        l_n             LIKE type_file.num5,  
        l_newno,l_oldno LIKE imz_file.imz01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i110_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM imz01
        AFTER FIELD imz01
            IF l_newno IS NULL OR l_newno = ' '  THEN
                NEXT FIELD imz01
            END IF
            SELECT count(*) INTO g_cnt FROM imz_file
                WHERE imz01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD imz01
            END IF
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
        DISPLAY BY NAME g_imz.imz01
        RETURN
    END IF
    LET l_imz.* = g_imz.*
    LET l_imz.imz01  =l_newno   #資料鍵值
    LET l_imz.imzuser=g_user    #資料所有者
    LET l_imz.imzgrup=g_grup    #資料所有者所屬群
    LET l_imz.imzmodu=NULL      #資料修改日期
    LET l_imz.imzdate=g_today   #資料建立日期
    LET l_imz.imzacti='Y'       #有效資料
    LET l_imz.imzoriu = g_user  
    LET l_imz.imzorig = g_grup   
    INSERT INTO imz_file VALUES (l_imz.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_imz.imz01
        SELECT imz_file.* INTO g_imz.* FROM imz_file
                       WHERE imz01 = l_newno
        CALL i008_u()
        #SELECT imz_file.* INTO g_imz.* FROM imz_file #FUN-C80046
        #               WHERE imz01 = l_oldno         #FUN-C80046
    END IF
    CALL i008_show()
END FUNCTION


#FUN-BC0076

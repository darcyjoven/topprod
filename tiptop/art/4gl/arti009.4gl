# Prog. Version..: '5.30.06-13.03.28(00008)'     #
#
# Pattern name...: arti009.4gl
# Descriptions...: 流通產品申請作業
# Date & Author..: No.FUN-BC0076 11/12/22 By xumm
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C30032 12/03/02 By baogc 拋轉BUG修改，產品分類開窗修改
# Modify.........: No:MOD-C30107 12/03/09 By baogc 添加規格欄位
# Modify.........: No:TQC-C30172 12/03/09 By fanbj 新增時，欄位imaa26,imaa261,imaa262統一給默認值0
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C50068 12/11/07 By bart 增加imaa721欄位
# Modify.........: No:CHI-CA0073 13/01/30 By pauline 將ima1015用ima1401替代
# Modify.........: No:FUN-D30006 13/03/04 By dongsz 添加imaa1030(觸屏分類)欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_imaa              RECORD LIKE imaa_file.*,
       g_imaa_t            RECORD LIKE imaa_file.*,
       g_imaa_o            RECORD LIKE imaa_file.*,
       g_imaa01_t          LIKE imaa_file.imaa01,
       g_imaano_t          LIKE imaa_file.imaano,
       g_rec_b             LIKE type_file.num10, 
       g_d2                LIKE imaa_file.imaa26,
       g_cmd               LIKE type_file.chr1000,
       g_wc                STRING,        
       g_wc2               STRING,        
       g_sql               STRING,
       g_flag              LIKE type_file.chr1, 
       g_flag1             LIKE type_file.chr1 
DEFINE p_row,p_col         LIKE type_file.num5    
DEFINE g_chr,g_chr1        LIKE type_file.chr1    
DEFINE g_chr2              LIKE type_file.chr1    
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_forupd_sql        STRING
DEFINE g_i                 LIKE type_file.num5  
DEFINE g_msg               LIKE type_file.chr1000 
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_curs_index        LIKE type_file.num10 
DEFINE g_row_count         LIKE type_file.num10 
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5  
DEFINE g_t1                LIKE smy_file.smyslip 
DEFINE g_gev04             LIKE gev_file.gev04    
DEFINE g_show_msg          DYNAMIC ARRAY OF RECORD    
                              imabdate    LIKE imab_file.imabdate,
                              imabdb      LIKE imab_file.imabdb    
                           END RECORD,
       g_gaq03_f1          LIKE gaq_file.gaq03,
       g_gaq03_f2          LIKE gaq_file.gaq03
DEFINE  g_msg2             LIKE type_file.chr1000    
DEFINE  g_str              STRING                 
DEFINE  g_input_itemno     LIKE type_file.chr1   
DEFINE g_imad              RECORD LIKE imad_file.*,
       g_ima               RECORD LIKE ima_file.*,
       g_ima_t             RECORD LIKE ima_file.*
DEFINE g_imaa25_t          LIKE imaa_file.imaa25 
DEFINE g_n                 LIKE type_file.num5


MAIN

   OPTIONS                               
       INPUT NO WRAP
   DEFER INTERRUPT
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   IF g_aza.aza60 !='Y' THEN #不使用料件申請作業    
      #參數設定不使用申請作業,所以無法執行此支程式!
      CALL cl_err('','axm-253',1)
      EXIT PROGRAM         
   END IF

   LET g_input_itemno = 'N'
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   INITIALIZE g_imaa.* TO NULL
   INITIALIZE g_imaa_t.* TO NULL
   INITIALIZE g_imaa_o.* TO NULL
   LET g_forupd_sql = " SELECT * FROM imaa_file ",
                     " WHERE imaano = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE arti009_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 5
 
   OPEN WINDOW arti009_w AT p_row,p_col WITH FORM "art/42f/arti009"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   IF g_sma.sma120 = 'N' THEN
      CALL cl_set_comp_visible("imaa151",FALSE)
   ELSE
      CALL cl_set_comp_visible("imaa151",TRUE)
   END IF 

   IF g_sma.sma124 = 'slk' THEN
      CALL cl_set_comp_visible("imaa940,imaa941",TRUE)
   ELSE
      CALL cl_set_comp_visible("imaa940,imaa941",FALSE)
   END IF

   CALL cl_set_comp_visible("imaaag",FALSE)
   CALL cl_set_act_visible("produce_sub_parts",g_sma.sma124 = 'slk')
 
   LET g_action_choice = ""
   CALL arti009_menu()
 
   CLOSE WINDOW arti009_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION arti009_curs()
DEFINE l_imaa151  LIKE imaa_file.imaa151

   CLEAR FORM

   INITIALIZE g_imaa.* TO NULL 
   
  #CONSTRUCT BY NAME g_wc ON imaano,imaa00,imaa01,imaa02,imaa06,imaa08,imaa131,imaa1005,imaa1006,         #MOD-C30107 Mark
   CONSTRUCT BY NAME g_wc ON imaano,imaa00,imaa01,imaa02,imaa021,imaa06,imaa08,imaa131,imaa1005,imaa1006,imaa1030, #MOD-C30107 Add  #FUN-D30006 add imaa1030
                             imaa154,imaa151,
                             imaa940,imaa941,
                             imaaag,imaa120,imaa25,imaa44,imaa31,
                             imaa54,imaa12,imaa39,imaa149,imaa1010,imaa1004,imaa1007,imaa1008,
                             imaa1009,imaa915,imaa45,imaa46,imaa47,imaa09,imaa10,imaa11,imaa531,
                             imaauser,imaagrup,imaaoriu,imaamodu,imaadate,imaaorig,imaaacti
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            IF g_sma.sma124 = 'slk' THEN
               CALL cl_set_comp_visible("imaa940,imaa941",TRUE)
            ELSE
               CALL cl_set_comp_visible("imaa940,imaa941",FALSE)
            END IF
 
         AFTER FIELD imaa151
            LET l_imaa151=GET_FLDBUF(imaa151)
            IF l_imaa151="Y" THEN
               CALL cl_set_comp_visible("imaaag",TRUE)
               NEXT FIELD imaaag
            ELSE  
               CALL cl_set_comp_visible("imaaag",FALSE)
            END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(imaano)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_imaano'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaano
                  NEXT FIELD imaano
               WHEN INFIELD(imaa01) #料件編號    
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaa01"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa01
                  NEXT FIELD imaa01
               WHEN INFIELD(imaa06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imaa06"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa06
                  NEXT FIELD imaa06
               WHEN INFIELD(imaa131) #產品分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imaa131"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa131
                  NEXT FIELD imaa131
              #FUN-D30006--add--str---
               WHEN INFIELD(imaa1030) #觸屏分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rzh01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1030
                  NEXT FIELD imaa1030
              #FUN-D30006--add--end---
               WHEN INFIELD(imaa149) #代銷科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_aag02"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa149
                  LET g_qryparam.arg1 = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa149
                  NEXT FIELD imaa149
               WHEN INFIELD(imaa1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1005
                  NEXT FIELD imaa1005
               WHEN INFIELD(imaa1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1006
                  NEXT FIELD imaa1006
               WHEN INFIELD(imaa940)
                  CALL cl_init_qry_var()
                  IF GET_FLDBUF(imaa151) = 'Y' THEN
                     LET g_qryparam.form = "q_agc"
                     LET g_qryparam.where = "agc07 = '1'"
                  ELSE
                     LET g_qryparam.form = "q_agd02"
                  END IF
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa940
                  NEXT FIELD imaa940
               WHEN INFIELD(imaa941)
                  CALL cl_init_qry_var()
                  IF GET_FLDBUF(imaa151) = 'Y' THEN
                     LET g_qryparam.form = "q_agc"
                     LET g_qryparam.where = "agc07 = '2'"
                  ELSE
                     LET g_qryparam.form = "q_agd02"
                  END IF
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa941
                  NEXT FIELD imaa941
               WHEN INFIELD(imaaag)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aga"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaaag
                  NEXT FIELD imaaag
               WHEN INFIELD(imaa09) #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "D"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa09
                  NEXT FIELD imaa09
               WHEN INFIELD(imaa10) #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "E"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa10
                  NEXT FIELD imaa10
               WHEN INFIELD(imaa11) #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "F"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa11
                  NEXT FIELD imaa11
               WHEN INFIELD(imaa12) #成本分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "G"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa12
                  NEXT FIELD imaa12
               WHEN INFIELD(imaa25) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa25
                  NEXT FIELD imaa25
               WHEN INFIELD(imaa44) #採購單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa44
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa44
                  NEXT FIELD imaa44
               WHEN INFIELD(imaa31) #銷售單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imaa.imaa31
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa31
                  NEXT FIELD imaa31
               WHEN INFIELD(imaa54) #主供應商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_imaa54"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa54
                  NEXT FIELD imaa54
               WHEN INFIELD(imaa39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa39
                  NEXT FIELD imaa39
               WHEN INFIELD(imaa1004)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1004
                  NEXT FIELD imaa1004                 
               WHEN INFIELD(imaa1007)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "4"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1007
                  NEXT FIELD imaa1007
               WHEN INFIELD(imaa1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "5"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1008
                  NEXT FIELD imaa1008
               WHEN INFIELD(imaa1009)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = "6"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa1009
                  NEXT FIELD imaa1009
 
               OTHERWISE EXIT CASE
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('maauser', 'maagrup')
 
   LET g_sql = "SELECT imaano FROM imaa_file ", 
               " WHERE ",g_wc CLIPPED,
               " ORDER BY imaano"
   PREPARE arti009_prepare FROM g_sql
   DECLARE arti009_curs SCROLL CURSOR WITH HOLD FOR arti009_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM imaa_file WHERE ",g_wc CLIPPED
   PREPARE arti009_precount FROM g_sql
   DECLARE arti009_count CURSOR FOR arti009_precount
 
END FUNCTION
 
FUNCTION arti009_menu()
   DEFINE l_flowuser      LIKE type_file.chr1  
   DEFINE l_creator       LIKE type_file.chr1  
   DEFINE l_imabdate      LIKE imab_file.imabdate
   DEFINE l_cmd           LIKE type_file.chr1000 
   DEFINE l_sub_imaa01    LIKE imaa_file.imaa01,
          l_sub_imaa02    LIKE imaa_file.imaa02
   DEFINE l_imabdb        LIKE imab_file.imabdb  
   DEFINE l_gev04         LIKE gev_file.gev04
   DEFINE l_gew03         LIKE gew_file.gew03
   DEFINE l_n             LIKE type_file.num5
 
   MENU ""
 
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF NOT cl_null(g_imaa.imaa00) AND g_imaa.imaa00 = 'U' THEN
            CALL cl_set_act_visible("add_multi_attr_sub，produce_sub_parts",FALSE)
         END IF
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL arti009_a()
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL arti009_q()
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL arti009_r()
         END IF

      ON ACTION confirm           
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
             CALL i009_y_chk()      
             IF g_success = "Y" THEN
                 CALL i009_y_upd()     
             END IF
         END IF
          
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL i009_z()
         END IF
 
      #@ON ACTION 資料拋轉
      ON ACTION carry_data
          LET g_action_choice="carry_data"
           IF cl_chk_act_auth() AND NOT cl_null(g_imaa.imaa01) AND g_imaa.imaa1010 = '1' THEN 
              CALL i150_dbs(g_imaa.*)
              SELECT * INTO g_imaa.* FROM imaa_file
               WHERE imaano = g_imaa.imaano
              #當前資料已拋轉並且為母料件
              IF g_imaa.imaa1010 = '2' AND g_imaa.imaa151 = 'Y' THEN
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n 
                   FROM imaa_file 
                  WHERE imaa1010 = '1' 
                    AND imaa01 IN (SELECT imx000
                                     FROM imx_file
                                    WHERE imx00 = g_imaa.imaa01)
                 #存在未拋轉且已核准的子料件
                 IF l_n > 0 THEN
                    CALL i009_sub_dbs(g_imaa.*)
                 END IF
              END IF
           ELSE
               IF cl_null(g_imaa.imaa01) THEN #料號為空,請補上料號
                  CALL cl_err(g_imaa.imaano,'aim-157','1')
               END IF
               IF g_imaa.imaa1010 <> '1' THEN
                  CALL cl_err(g_imaa.imaa1010,'art1027','1')
               END IF
           END IF
           SELECT * INTO g_imaa.* FROM imaa_file 
            WHERE imaano = g_imaa.imaano
           CALL arti009_show() 

      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_imaa.imaa01) THEN
               SELECT gev04 INTO g_gev04 FROM gev_file
                WHERE gev01 = '1' AND gev02 = g_plant
               IF NOT cl_null(g_gev04) THEN
                  LET l_cmd='aooq604 "',g_gev04,'" "1" "',g_prog,'" "',g_imaa.imaa01,'"'
                  CALL cl_cmdrun(l_cmd)
               END IF
            ELSE
               CALL cl_err('',-400,0)
            END IF
         END IF

      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL arti009_u('u') 
         END IF

      ON ACTION first
         CALL arti009_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION previous
         CALL arti009_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION jump
         CALL arti009_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION next
         CALL arti009_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF

      ON ACTION last
         CALL arti009_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL i009_show_pic() #圖示
         CALL cl_show_fld_cont()

      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL arti009_x()
            CALL arti009_show()
         END IF

     ON ACTION reproduce
        LET g_action_choice="reproduce"
        IF cl_chk_act_auth() THEN
           CALL arti009_copy()

        END IF
        
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit
         LET g_action_choice='exit'
         EXIT MENU
 
      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
         LET g_action_choice='exit'
         CONTINUE MENU

      #新增多屬性子料件
      ON ACTION add_multi_attr_sub
         LET g_action_choice="add_multi_attr_sub" 
         IF cl_chk_act_auth() THEN
            IF cl_null(g_imaa.imaa01) THEN
               CALL cl_err('',-400,1)
            ELSE
               IF g_imaa.imaa1010 !='1' AND g_imaa.imaa1010 !='2' THEN
                  CALL cl_err(g_imaa.imaa01,'aim-450',1)
               ELSE
                  CALL sarti009(g_imaa.imaa01)
                  IF g_sma.sma124 = 'slk' THEN
                     CALL i009_upd_imaa()
                  END IF
                  SELECT gev04 INTO l_gev04 FROM gev_file
                   WHERE gev01 = '1' and gev02 = g_plant
                  SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file
                   WHERE gew01 = l_gev04
                     AND gew02 = '1'
                  IF l_gew03 = '1' THEN
                     LET l_n = 0
                     SELECT COUNT(*) INTO l_n
                       FROM imaa_file
                      WHERE imaa1010 = '1'
                        AND imaa01 IN (SELECT imx000
                                         FROM imx_file
                                        WHERE imx00 = g_imaa.imaa01)
                     #存在未拋轉且已核准的子料件
                     IF l_n > 0 THEN
                        CALL i009_sub_dbs(g_imaa.*)
                     END IF
                  END IF
                  LET INT_FLAG=0
                  CALL arti009_show()
               END IF
            END IF
         END IF
         
      #自動產生多屬性子料件
      ON ACTION produce_sub_parts
         LET g_action_choice="produce_sub_parts"
         IF cl_chk_act_auth() THEN
            IF cl_null(g_imaa.imaa01) THEN
               CALL cl_err('',-400,1)
            ELSE
               CALL i009_produce_sub_parts()
               SELECT gev04 INTO l_gev04 FROM gev_file
                WHERE gev01 = '1' and gev02 = g_plant
               SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file
                WHERE gew01 = l_gev04
                  AND gew02 = '1'
               IF l_gew03 = '1' THEN
                  LET l_n = 0
                  SELECT COUNT(*) INTO l_n
                    FROM imaa_file
                   WHERE imaa1010 = '1'
                     AND imaa01 IN (SELECT imx000
                                      FROM imx_file
                                     WHERE imx00 = g_imaa.imaa01)
                  #存在未拋轉且已核准的子料件
                  IF l_n > 0 THEN
                     CALL i009_sub_dbs(g_imaa.*)
                  END IF
               END IF
               LET INT_FLAG=0
               CALL arti009_show()
            END IF
         END IF

         
      #相關文件"
      ON ACTION related_document                          
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF g_imaa.imaano IS NOT NULL THEN
               LET g_doc.column1 = "imaano"
               LET g_doc.value1 = g_imaa.imaano
               CALL cl_doc()
            END IF
         END IF

      ON ACTION close   
         LET INT_FLAG=FALSE          
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
 
   CLOSE arti009_curs
 
END FUNCTION
 
FUNCTION arti009_carry_data()
 DEFINE l_imabdate      LIKE imab_file.imabdate                  
 DEFINE l_imabdb        LIKE imab_file.imabdb                    
 
          LET g_sql= "SELECT imabdate,imabdb ",
                     "  FROM imab_file ",
                     " WHERE imabtype= '1' ",
                     "   AND imabno= '",g_imaa.imaano CLIPPED,"'"
          
          DECLARE i009_carry_data CURSOR FROM g_sql
          OPEN i009_carry_data 
          LET g_i = 1
          FOREACH i009_carry_data INTO l_imabdate,l_imabdb 
             LET g_show_msg[g_i].imabdate = l_imabdate
             LET g_show_msg[g_i].imabdb   = l_imabdb
             LET g_i = g_i + 1
          END FOREACH
 
          LET g_msg = NULL
          LET g_msg2= NULL
          LET g_gaq03_f1 = NULL
          LET g_gaq03_f2 = NULL
          CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
          CALL cl_get_feldname('imabdate',g_lang) RETURNING g_gaq03_f1
          CALL cl_get_feldname('imabdb',g_lang) RETURNING g_gaq03_f2
          LET g_msg2 = g_gaq03_f1 CLIPPED,'|',g_gaq03_f2 CLIPPED
          CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
 
END FUNCTION
 
FUNCTION imaa_default()
 
   LET g_imaa.imaa00 ='I'   #新增
   LET g_imaa.imaa1010 ='0' #0:開立
   LET g_imaa.imaa92 ='N'   #不需簽核
   LET g_imaa.imaa07 = 'A'
   LET g_imaa.imaa08 = 'P'
   LET g_imaa.imaa108= 'N'
   LET g_imaa.imaa14 = 'N'
   LET g_imaa.imaa903= 'N' 
   LET g_imaa.imaa905= 'N'
   LET g_imaa.imaa15 = 'N'
   LET g_imaa.imaa16 = 99
   LET g_imaa.imaa18 = 0
   LET g_imaa.imaa09 = ' '
   LET g_imaa.imaa10 = ' '
   LET g_imaa.imaa11 = ' '
   LET g_imaa.imaa120 = '1'
   LET g_imaa.imaa12 = ' '
   LET g_imaa.imaa23 = ' '
   LET g_imaa.imaa24 = 'N'
   LET g_imaa.imaa911= 'N'   
   LET g_imaa.imaa022 = 0     
   LET g_imaa.imaa926= 'N'   
   LET g_imaa.imaa928= 'N'
   LET g_imaa.imaa26 = 0
   LET g_imaa.imaa261= 0
   LET g_imaa.imaa262= 0
   LET g_imaa.imaa27 = 0
   LET g_imaa.imaa271= 0
   LET g_imaa.imaa28 = 0
   LET g_imaa.imaa30 = g_today 
   LET g_imaa.imaa31_fac = 1
   LET g_imaa.imaa32 = 0
   LET g_imaa.imaa33 = 0
   LET g_imaa.imaa37 = '0'
   LET g_imaa.imaa38 = 0
   LET g_imaa.imaa40 = 0
   LET g_imaa.imaa41 = 0
   LET g_imaa.imaa42 = '0'
   LET g_imaa.imaa44_fac = 1
   LET g_imaa.imaa45 = 0
   LET g_imaa.imaa46 = 0
   LET g_imaa.imaa47 = 0
   LET g_imaa.imaa48 = 0
   LET g_imaa.imaa49 = 0
   LET g_imaa.imaa491 = 0
   LET g_imaa.imaa50 = 0
   LET g_imaa.imaa51 = 1
   LET g_imaa.imaa52 = 1
   LET g_imaa.imaa140 = 'N'
   LET g_imaa.imaa53 = 0
   LET g_imaa.imaa531 = 0
   LET g_imaa.imaa55_fac = 1
   LET g_imaa.imaa56 = 1
   LET g_imaa.imaa561 = 1  #最少生產數量
   LET g_imaa.imaa562 = 0  #生產時損耗率
   LET g_imaa.imaa57 = 0
   LET g_imaa.imaa58 = 0
   LET g_imaa.imaa59 = 0
   LET g_imaa.imaa60 = 0
   LET g_imaa.imaa601 = 0
   LET g_imaa.imaa61 = 0
   LET g_imaa.imaa62 = 0
   LET g_imaa.imaa63_fac = 1
   LET g_imaa.imaa64 = 1
   LET g_imaa.imaa641 = 1   #最少發料數量
   LET g_imaa.imaa65 = 0
   LET g_imaa.imaa66 = 0
   LET g_imaa.imaa68 = 0
   LET g_imaa.imaa69 = 0
   LET g_imaa.imaa70 = 'N'
   LET g_imaa.imaa107= 'N'
   LET g_imaa.imaa147= 'N' 
   LET g_imaa.imaa71 = 0
   LET g_imaa.imaa72 = 0
   LET g_imaa.imaa721 = 0  #CHI-C50068
   LET g_imaa.imaa75 = ''
   LET g_imaa.imaa76 = ''
   LET g_imaa.imaa77 = 0
   LET g_imaa.imaa78 = 0
   LET g_imaa.imaa80 = 0
   LET g_imaa.imaa81 = 0
   LET g_imaa.imaa82 = 0
   LET g_imaa.imaa83 = 0
   LET g_imaa.imaa84 = 0
   LET g_imaa.imaa85 = 0
   LET g_imaa.imaa852= 'N'
   LET g_imaa.imaa853= 'N'
   LET g_imaa.imaa871 = 0
   LET g_imaa.imaa86_fac = 1
   LET g_imaa.imaa873 = 0
   LET g_imaa.imaa88 = 1
   LET g_imaa.imaa91 = 0
   LET g_imaa.imaa93 = "NNNNNNNN"
   LET g_imaa.imaa94 = ''
   LET g_imaa.imaa95 = 0
   LET g_imaa.imaa96 = 0
   LET g_imaa.imaa97 = 0
   LET g_imaa.imaa98 = 0
   LET g_imaa.imaa99 = 0
   LET g_imaa.imaa100 = 'N'
   LET g_imaa.imaa101 = '1'
   LET g_imaa.imaa102 = '1'
   LET g_imaa.imaa103 = '0'
   LET g_imaa.imaa104 = 0
   LET g_imaa.imaa910 = ' '  
   LET g_imaa.imaa105 = 'N'
   LET g_imaa.imaa110 = '1'
   LET g_imaa.imaa139 = 'N'
   LET g_imaa.imaaacti= 'Y'                   #有效的資料
   LET g_imaa.imaauser= g_user
   LET g_imaa.imaaoriu = g_user 
   LET g_imaa.imaaorig = g_grup 
   LET g_imaa.imaagrup= g_grup                #使用者所屬群
   LET g_imaa.imaadate= g_today
   LET g_imaa.imaa901 = g_today               #料件建檔日期
   LET g_imaa.imaa912 = 0   
   #產品資料
   LET g_imaa.imaa130 = '1'
   LET g_imaa.imaa121 = 0
   LET g_imaa.imaa122 = 0
   LET g_imaa.imaa123 = 0
   LET g_imaa.imaa124 = 0
   LET g_imaa.imaa125 = 0
   LET g_imaa.imaa126 = 0
   LET g_imaa.imaa127 = 0
   LET g_imaa.imaa128 = 0
   LET g_imaa.imaa129 = 0
   LET g_imaa.imaa141 = '0'
   LET g_imaa.imaa1001 = ''                                                                                                           
   LET g_imaa.imaa1002 = ''                                                                             
   LET g_imaa.imaa1014 = '1' 
   LET g_imaa.imaa159 = '3'   
   LET g_imaa.imaa151 = 'N'
   LET g_imaa.imaa154 = 'N'

   IF s_industry('icd') THEN
      LET g_imaa.imaaicd04 = '9'
      LET g_imaa.imaaicd05 = '6'
      LET g_imaa.imaaicd08 = 'N'
      LET g_imaa.imaaicd09 = 'N'
      LET g_imaa.imaaicd13 = 'N'
      LET g_imaa.imaaicd14 = '0'
   END IF 
   #單位控制部分
   IF g_sma.sma115 = 'Y' THEN #使用多單位
      #sma122:1:母子單位
      #       2:參考單位
      #       3:兩者
      IF g_sma.sma122 MATCHES '[13]' THEN
         LET g_imaa.imaa906 = '2' #母子
      ELSE
         LET g_imaa.imaa906 = '3' #參考
      END IF
   ELSE
      LET g_imaa.imaa906 = '1'    #單一
   END IF
   LET g_imaa.imaa909 = 0
 
   #批/序號資料
   LET g_imaa.imaa918 = "N"
   LET g_imaa.imaa919 = "N" 
   LET g_imaa.imaa921 = "N"
   LET g_imaa.imaa922 = "N"
   LET g_imaa.imaa924 = "N"
   LET g_imaa.imaa925 = "1"
 
END FUNCTION
 
FUNCTION arti009_a()
   DEFINE li_result        LIKE type_file.num5                   

   LET g_wc = NULL
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_imaa.*   LIKE imaa_file.*
   INITIALIZE g_imaa_t.* LIKE imaa_file.*
   LET g_imaa01_t = NULL
   LET g_imaano_t = NULL
   LET g_imaa_o.*=g_imaa.* 
   CALL imaa_default()
   CALL cl_opmsg('a')
 
   WHILE TRUE
      INITIALIZE g_imaa_o.*  TO NULL
      CALL i009_desc()
      CALL arti009_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_imaa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_imaa.imaano IS NULL THEN           # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF g_imaa.imaa31 IS NULL THEN
         LET g_imaa.imaa31=g_imaa.imaa25
         LET g_imaa.imaa31_fac=1
      END IF
 
      IF g_imaa.imaa133 IS NULL THEN
         LET g_imaa.imaa133 = g_imaa.imaa01
      END IF
 
      IF g_imaa.imaa571 IS NULL THEN
         LET g_imaa.imaa571 = g_imaa.imaa01
      END IF
 
      IF g_imaa.imaa44 IS NULL OR g_imaa.imaa44=' ' THEN
         LET g_imaa.imaa44=g_imaa.imaa25   #採購單位
         LET g_imaa.imaa44_fac=1
      END IF
 
      IF g_imaa.imaa55 IS NULL OR g_imaa.imaa55=' ' THEN
         LET g_imaa.imaa55=g_imaa.imaa25   #生產單位
         LET g_imaa.imaa55_fac=1
      END IF
 
      IF g_imaa.imaa63 IS NULL OR g_imaa.imaa63=' ' THEN
         LET g_imaa.imaa63=g_imaa.imaa25   #發料單位
         LET g_imaa.imaa63_fac=1
      END IF
 
      LET g_imaa.imaa86=g_imaa.imaa25   #庫存單位=成本單位
      LET g_imaa.imaa86_fac=1

      IF g_imaa.imaa915 IS NULL THEN LET g_imaa.imaa915 = '0' END IF #TQC-C30032 Add

      BEGIN WORK    
 
      CALL s_auto_assign_no("aim",g_imaa.imaano,g_imaa.imaadate,"Z","imaa_file","imaano","","","") RETURNING li_result,g_imaa.imaano
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_imaa.imaano
      IF cl_null(g_imaa.imaa01) THEN
          LET g_imaa.imaa01 = ' '
      END IF
      LET g_imaa.imaaoriu = g_user      
      LET g_imaa.imaaorig = g_grup      
      LET g_imaa.imaa120 = '1'          

      IF cl_null(g_imaa.imaaicd04) THEN
         LET g_imaa.imaaicd04 = ' '
      END IF
      IF cl_null(g_imaa.imaaicd05) THEN
         LET g_imaa.imaaicd05 = ' '
      END IF
      IF cl_null(g_imaa.imaaicd08) THEN
         LET g_imaa.imaaicd08 = 'N'
      END IF
      IF cl_null(g_imaa.imaaicd09) THEN
         LET g_imaa.imaaicd09 = 'N'
      END IF
      IF cl_null(g_imaa.imaaicd13) THEN
         LET g_imaa.imaaicd13 = 'N'
      END IF
      IF cl_null(g_imaa.imaaicd14) THEN
         LET g_imaa.imaaicd14 = 0
      END IF
      IF cl_null(g_imaa.imaaicd15) THEN
         LET g_imaa.imaaicd15 = 0
      END IF
      IF cl_null(g_imaa.imaaicd17) THEN
         LET g_imaa.imaaicd17 = '3'
      END IF
      
      IF cl_null(g_imaa.imaa159) THEN   
         LET g_imaa.imaa159 = '3'        
      END IF                             
      INSERT INTO imaa_file VALUES(g_imaa.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,
                      "","",1)  
         ROLLBACK WORK    
         CONTINUE WHILE
      ELSE             
         LET g_imaa_t.* = g_imaa.*                # 保存上筆資料
         SELECT imaano INTO g_imaa.imaano FROM imaa_file
          WHERE imaano = g_imaa.imaano
      END IF
      CALL cl_flow_notify(g_imaa.imaano,'I')   
      COMMIT WORK
      CALL cl_err("","aim-005",0) #執行成功！
      CALL arti009_show()
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i009_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
 
   IF g_imaa.imaa00='I' THEN #新增
      CALL cl_set_comp_entry("imaa06,imaa131,imaa1005,imaa1006",TRUE)
      CALL cl_set_comp_entry("imaa154,imaa151,imaa940,imaa941,imaa120",TRUE)
      CALL cl_set_comp_entry("imaa25,imaa44,imaa31,imaa54,imaa12,imaa39,imaa149",TRUE)
   END IF

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN       
      CALL cl_set_comp_entry("imaa00,imaano,imaa01,imaa25",TRUE) 
      CALL cl_set_comp_visible("imaaag",g_ima.ima151 = 'Y' )
      IF g_sma.sma124 = 'slk' THEN
         CALL cl_set_comp_entry("imaaag",FALSE)
      END IF
   END IF

END FUNCTION
 
FUNCTION i009_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE li_count  LIKE type_file.num5
   DEFINE lc_sql    STRING  
 
   IF g_imaa.imaa00='U' OR g_input_itemno = 'Y' THEN #修改
      CALL cl_set_comp_entry("imaa06,imaa131,imaa1005,imaa1006",FALSE)
      CALL cl_set_comp_entry("imaa154,imaa151,imaa940,imaa941,imaa120",FALSE)
      CALL cl_set_comp_entry("imaa25,imaa44,imaa31,imaa54,imaa12,imaa39,imaa149",FALSE)
   END IF

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("imaa00,imaano",FALSE)
      IF g_imaa.imaa00 = 'U' THEN #申請類別U:修改時,不能改料件編號
          CALL cl_set_comp_entry("imaa01",FALSE)
      END IF
      IF g_ima.imaag ='@CHILD' THEN
         CALL cl_set_comp_entry("imaa151",FALSE)
      END IF
   END IF

   IF (p_cmd = 'u' ) AND ( g_sma.sma120 = 'Y')  THEN
      IF g_imaa.imaaag = '@CHILD' THEN
         CALL cl_set_comp_visible("imaaag",FALSE)
      ELSE
         #如果該料件已經包含了子料件則不允許修改他的屬性群組
         LET lc_sql = "SELECT COUNT(*) FROM imaa_file WHERE imaaag = '@CHILD' ",
                      "AND imaaag1 = '",g_imaa.imaaag,"' AND imaa01 LIKE '",
                       g_imaa.imaa01,"%' "
 
         DECLARE lcurs_qry_imaa CURSOR FROM lc_sql
 
         OPEN lcurs_qry_imaa
         FETCH lcurs_qry_imaa INTO li_count
         IF li_count > 0 THEN
            CALL cl_set_comp_visible("imaaag",FALSE)
         ELSE
            CALL cl_set_comp_visible("imaaag",g_imaa.imaa151 = 'Y')
         END IF
         CLOSE lcurs_qry_imaa
      END IF
   END IF
 
END FUNCTION

 
FUNCTION arti009_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,   
          l_misc          LIKE type_file.chr4,
          l_cmd           LIKE type_file.chr1000, 
          l_buf           LIKE aag_file.aag02, 
          l_n             LIKE type_file.num5
   DEFINE lc_sma119       LIKE sma_file.sma119, 
          li_len          LIKE type_file.num5 
   DEFINE li_result       LIKE type_file.num5    
   DEFINE l_imaa01        STRING 
   DEFINE l_imaano        LIKE imaa_file.imaano
   DEFINE l_ima120        LIKE ima_file.ima120 
   DEFINE l_aag02         LIKE aag_file.aag02

   IF p_cmd = 'u' THEN 
      LET g_imaa.imaadate = g_today 
   END IF

   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
 
   CALL i009_desc()
  #INPUT BY NAME  g_imaa.imaano,g_imaa.imaa00,g_imaa.imaa01,g_imaa.imaa02,g_imaa.imaa06,                #MOD-C30107 Mark
   INPUT BY NAME  g_imaa.imaano,g_imaa.imaa00,g_imaa.imaa01,g_imaa.imaa02,g_imaa.imaa021,g_imaa.imaa06, #MOD-C30107 Add
                  g_imaa.imaa08,g_imaa.imaa131,g_imaa.imaa1005,g_imaa.imaa1006,g_imaa.imaa1030,g_imaa.imaa154,  #FUN-D30006 add g_imaa.imaa1030
                  g_imaa.imaa151,
                  g_imaa.imaa940,g_imaa.imaa941,
                  g_imaa.imaaag,g_imaa.imaa120,
                  g_imaa.imaa25,g_imaa.imaa44,g_imaa.imaa31,g_imaa.imaa54,g_imaa.imaa12,
                  g_imaa.imaa39,g_imaa.imaa149,g_imaa.imaa1010,g_imaa.imaa1004,g_imaa.imaa1007,
                  g_imaa.imaa1008,g_imaa.imaa1009,g_imaa.imaa915,g_imaa.imaa45,g_imaa.imaa46,
                  g_imaa.imaa47,g_imaa.imaa09,g_imaa.imaa10,g_imaa.imaa11,g_imaa.imaa531,
                  g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaaoriu,g_imaa.imaamodu,g_imaa.imaadate,
                  g_imaa.imaaorig,g_imaa.imaaacti
         
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i009_set_entry(p_cmd)
            CALL i009_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            IF g_action_choice = "reproduce" THEN
               CALL cl_set_comp_entry("imaa01",FALSE)
            END IF
            IF p_cmd = 'u' THEN 
               LET g_imaa25_t = g_imaa.imaa25
            END IF
            IF p_cmd = 'a' THEN
               LET g_imaa25_t = NULL
            END IF
            CALL cl_set_docno_format("imaano") 
           #CALL cl_chg_comp_att("imaa01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
 
        AFTER FIELD imaa00
            IF cl_null(g_imaa.imaa00) THEN
                NEXT FIELD imaa00
            END IF
            CALL i009_set_entry(p_cmd)
            CALL i009_set_no_entry(p_cmd)
             
        #只要申請類別(I:新增 U:修改)有變,料件編號imaa01就應重key
        ON CHANGE imaa00
            LET g_imaa.imaa01  = NULL
            LET g_imaa.imaa02  = NULL
            LET g_imaa.imaa021 = NULL
            LET g_imaa_t.imaa01  = NULL
            LET g_imaa_t.imaa02  = NULL
            LET g_imaa_t.imaa021 = NULL
            DISPLAY BY NAME g_imaa.imaa01,g_imaa.imaa02,g_imaa.imaa021
 
        AFTER FIELD imaano
          IF NOT cl_null(g_imaa.imaano) THEN
             IF (p_cmd='a') OR (p_cmd='u' AND g_imaa.imaano!=g_imaa_t.imaano) THEN
                LET l_n = 0 
                SELECT COUNT(*) INTO l_n
                  FROM imaa_file 
                 WHERE imaano=g_imaa.imaano
                IF l_n > 0 THEN
                   CALL cl_err('sel imaa:','-239',0)
                   NEXT FIELD imaano
                END IF
                LET g_t1=s_get_doc_no(g_imaa.imaano)
                    CALL s_check_no('aim',g_imaa.imaano,"","Z","imaa_file","imaano","") RETURNING li_result,g_imaa.imaano 
                IF (NOT li_result) THEN
                     LET g_imaa.imaano=g_imaa_t.imaano
                     NEXT FIELD imaano
                END IF
                LET g_t1=g_imaa.imaano[1,g_doc_len]
                LET  g_imaa.imaa92 = g_smy.smyapr
                DISPLAY By NAME g_imaa.imaa92
             END IF
          END IF
 
        BEFORE FIELD imaa01
            IF g_sma.sma60 = 'Y' THEN# 若須分段輸入
               CALL s_inp5(6,14,g_imaa.imaa01) RETURNING g_imaa.imaa01
               DISPLAY BY NAME g_imaa.imaa01
            END IF
 
            IF g_imaa.imaa00 = 'I' AND cl_null(g_imaa.imaa01) THEN #新增且申請料件編號為空時,才CALL自動編號附程式
                IF g_aza.aza28 = 'Y' THEN
                   CALL s_auno(g_imaa.imaa01,'1','') RETURNING g_imaa.imaa01,g_imaa.imaa02
                   IF NOT cl_null(g_imaa_t.imaa02) THEN
                      IF g_imaa_t.imaa02 <> g_imaa_o.imaa02 THEN
                         LET g_imaa.imaa02 = g_imaa_o.imaa02
                      ELSE 
                         LET g_imaa.imaa02 = g_imaa_t.imaa02
                      END IF 
                   END IF
                END IF
            END IF
 
        AFTER FIELD imaa01
            IF NOT cl_null(g_imaa.imaa01) THEN
               IF p_cmd = "a" OR         
                 (p_cmd = "u" AND g_imaa.imaa01 != g_imaa01_t) THEN
                  IF g_imaa.imaa01[1,1] = ' ' THEN
                     CALL cl_err(g_imaa.imaa01,"aim-671",1)
                     LET g_imaa.imaa01 = g_imaa_t.imaa01
                     DISPLAY BY NAME g_imaa.imaa01
                     NEXT FIELD imaa01
                  END IF
                  IF g_imaa.imaa00 = 'I' THEN #新增
                      SELECT count(*) INTO l_n FROM ima_file
                       WHERE ima01 = g_imaa.imaa01
                      IF l_n > 0 THEN
                         SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = g_imaa.imaa01
                         IF l_ima120 = '2' THEN
                            CALL cl_err(g_imaa.imaa01,'aim-023',1)
                         ELSE
                            CALL cl_err(g_imaa.imaa01,'aim-024',1)
                         END IF
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                      SELECT count(*) INTO l_n FROM imaa_file
                       WHERE imaa01 = g_imaa.imaa01
                         AND imaa00 = 'I' #新增
                      IF l_n > 0 THEN
                         CALL cl_err(g_imaa.imaa01,-239,1) 
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                      CALL s_field_chk(g_imaa.imaa01,'1',g_plant,'ima01') RETURNING g_flag
                      IF g_flag = '0' THEN
                         CALL cl_err(g_imaa.imaa01,'aoo-043',1)
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                  ELSE
                      SELECT count(*) INTO l_n FROM ima_file
                       WHERE ima01 = g_imaa.imaa01
                         AND (ima120 = '1' OR ima120 = NULL OR ima120 = ' ')  
                      IF l_n <= 0 THEN
                         SELECT ima120 INTO l_ima120 FROM ima_file WHERE ima01 = g_imaa.imaa01
                         IF l_ima120 = '2' THEN
                            CALL cl_err(g_imaa.imaa01,'aim-025',1)
                            LET g_imaa.imaa01 = g_imaa_t.imaa01
                            DISPLAY BY NAME g_imaa.imaa01
                         ELSE
                            CALL cl_err(g_imaa.imaa01,'ams-003',1)
                            LET g_imaa.imaa01 = g_imaa_t.imaa01
                            DISPLAY BY NAME g_imaa.imaa01
                         END IF
                         NEXT FIELD imaa01
                      END IF
                      LET l_imaano = NULL
                      SELECT imaano INTO l_imaano FROM imaa_file
                       WHERE imaa01 = g_imaa.imaa01
                         AND imaa00 = 'U' #修改
                         AND imaa1010 != '2' 
                         AND imaaacti != 'N' #MOD-B40095 add
                      IF NOT cl_null(l_imaano) THEN
                         #已存在一張相同料號,但未拋轉的料件申請單!
                         CALL cl_err(l_imaano,'aim-150',1)
                         LET g_imaa.imaa01 = g_imaa_t.imaa01
                         DISPLAY BY NAME g_imaa.imaa01
                         NEXT FIELD imaa01
                      END IF
                      
                      LET g_imaa_t.imaa00  = g_imaa.imaa00
                      LET g_imaa_t.imaano  = g_imaa.imaano
                      LET g_imaa_t.imaa011 = g_imaa.imaa011
                      LET g_imaa_t.imaa92  = g_imaa.imaa92
                      LET g_imaa_t.imaa1010= g_imaa.imaa1010
                      LET g_imaa_t.imaaacti= g_imaa.imaaacti
                      LET g_imaa_t.imaauser= g_imaa.imaauser
                      LET g_imaa_t.imaagrup= g_imaa.imaagrup
                      LET g_imaa_t.imaamodu= g_imaa.imaamodu
                      LET g_imaa_t.imaadate= g_imaa.imaadate
                      SELECT 'U','@1','@2', 
                             ima01,     ima02,     ima021,   ima03,     ima04,    
                             ima05,     ima06,     ima07,    ima08,     ima09,    
                             ima10,     ima11,     ima12,    ima13,     ima14,    
                             ima15,     ima16,     ima17,    ima17_fac, ima18,    
                             ima19,     ima20,     ima21,    ima22,     ima23,    
                             #ima24,     ima25,     ima26,    ima261,    ima262,   #TQC-C30172 mark
                             ima24,     ima25,                                     #TQC-C30172 add
                             ima27,     ima271,    ima28,    ima29,     ima30,    
                             ima31,     ima31_fac, ima32,    ima33,     ima34,    
                             ima35,     ima36,     ima37,    ima38,     ima39,    
                             ima40,     ima41,     ima42,    ima43,     ima44,    
                             ima44_fac, ima45,     ima46,    ima47,     ima48,    
                             ima49,     ima491,    ima50,    ima51,     ima52,    
                             ima53,     ima531,    ima532,   ima54,     ima55,    
                             ima55_fac, ima56,     ima561,   ima562,    ima57,    
                             ima571,    ima58,     ima59,    ima60,     ima61,    
                             ima62,     ima63,     ima63_fac,ima64,     ima641,   
                             ima65,     ima66,     ima67,    ima68,     ima69,    
                             ima70,     ima71,     ima72,    ima73,     ima74,    
                             ima86,     ima86_fac, ima87,    ima871,    ima872,   
                             ima873,    ima874,    ima88,    ima881,    ima89,    
                             ima90,     ima91,     ima92,    ima93,     ima94,    
                             ima95,     ima75,     ima76,    ima77,     ima78,    
                             ima79,     ima80,     ima81,    ima82,     ima83,    
                             ima84,     ima85,     ima851,   ima852,    ima853,   
                             ima96,     ima97,     ima98,    ima99,     ima100,   
                             ima101,    ima102,    ima103,   ima104,    ima105,   
                             ima106,    ima107,    ima108,   ima109,    ima110,   
                             ima111,    ima121,    ima122,   ima123,    ima124,   
                             ima125,    ima126,    ima127,   ima128,    ima129,   
                             ima130,    ima131,    ima132,   ima133,    ima134,   
                             ima135,    ima136,    ima137,   ima138,    ima139,   
                             ima140,    ima141,    ima142,   ima143,    ima144,   
                             ima145,    ima146,    ima147,   ima148,    ima901,   
                             ima902,    ima903,    ima904,   ima905,    ima906,   
                             ima907,    ima908,    ima909,   ima910, 
                             imaaicd01,imaaicd02,imaaicd03,
                             imaaicd04,imaaicd05,imaaicd06,
                             imaaicd08,imaaicd09,imaaicd10,
                             imaaicd12,imaaicd14,
                             imaaicd15,imaaicd16, 
                             imaacti,  
                             imauser,   imagrup,   imamodu,  imadate,   imaag,    
                             imaag1,    imaud01,   imaud02,  imaud03,   imaud04,  
                             imaud05,   imaud06,   imaud07,  imaud08,   imaud09,  
                             imaud10,   imaud11,   imaud12,  imaud13,   imaud14,  
                             imaud15,   ima1001,   ima1002,  ima1003,   ima1004,  
                             ima1005,   ima1006,   ima1007,  ima1008,   ima1009,  
                             ima1010,   ima1011,   ima1012,  ima1013,   ima1014,  
                            #ima1015,   ima1016,   ima1017,  ima1018,   ima1019,   #CHI-CA0073 mark
                             ima1401,   ima1016,   ima1017,  ima1018,   ima1019,   #CHI-CA0073 add 
                             ima1020,   ima1021,   ima1022,  ima1023,   ima1024,  
                             ima1025,   ima1026,   ima1027,  ima1028,   ima1029,  
                             ima911,    ima912,    ima913,   ima914,    ima391,   
                             ima1321,   ima915,    ima918,   ima919,    ima920,   
                             ima921,    ima922,    ima923,   ima924,    ima925,   
                             ima601,    ima926,    imaoriu,  imaorig,   ima153,  
                             ima120,    ima159,    ima721,   ima1030  #CHI-C50068  #FUN-D30006 add ima1030
                        INTO g_imaa.imaa00,     g_imaa.imaano,     g_imaa.imaa011,    
                             g_imaa.imaa01,     g_imaa.imaa02,     g_imaa.imaa021,   g_imaa.imaa03,     g_imaa.imaa04,    
                             g_imaa.imaa05,     g_imaa.imaa06,     g_imaa.imaa07,    g_imaa.imaa08,     g_imaa.imaa09,    
                             g_imaa.imaa10,     g_imaa.imaa11,     g_imaa.imaa12,    g_imaa.imaa13,     g_imaa.imaa14,    
                             g_imaa.imaa15,     g_imaa.imaa16,     g_imaa.imaa17,    g_imaa.imaa17_fac, g_imaa.imaa18,    
                             g_imaa.imaa19,     g_imaa.imaa20,     g_imaa.imaa21,    g_imaa.imaa22,     g_imaa.imaa23,    
                             #g_imaa.imaa24,     g_imaa.imaa25,     g_imaa.imaa26,    g_imaa.imaa261,    g_imaa.imaa262,   #TQC-C30172 mark
                             g_imaa.imaa24,     g_imaa.imaa25,                                                             #TQC-C30172 add
                             g_imaa.imaa27,     g_imaa.imaa271,    g_imaa.imaa28,    g_imaa.imaa29,     g_imaa.imaa30,    
                             g_imaa.imaa31,     g_imaa.imaa31_fac, g_imaa.imaa32,    g_imaa.imaa33,     g_imaa.imaa34,    
                             g_imaa.imaa35,     g_imaa.imaa36,     g_imaa.imaa37,    g_imaa.imaa38,     g_imaa.imaa39,    
                             g_imaa.imaa40,     g_imaa.imaa41,     g_imaa.imaa42,    g_imaa.imaa43,     g_imaa.imaa44,    
                             g_imaa.imaa44_fac, g_imaa.imaa45,     g_imaa.imaa46,    g_imaa.imaa47,     g_imaa.imaa48,    
                             g_imaa.imaa49,     g_imaa.imaa491,    g_imaa.imaa50,    g_imaa.imaa51,     g_imaa.imaa52,    
                             g_imaa.imaa53,     g_imaa.imaa531,    g_imaa.imaa532,   g_imaa.imaa54,     g_imaa.imaa55,    
                             g_imaa.imaa55_fac, g_imaa.imaa56,     g_imaa.imaa561,   g_imaa.imaa562,    g_imaa.imaa57,    
                             g_imaa.imaa571,    g_imaa.imaa58,     g_imaa.imaa59,    g_imaa.imaa60,     g_imaa.imaa61,    
                             g_imaa.imaa62,     g_imaa.imaa63,     g_imaa.imaa63_fac,g_imaa.imaa64,     g_imaa.imaa641,   
                             g_imaa.imaa65,     g_imaa.imaa66,     g_imaa.imaa67,    g_imaa.imaa68,     g_imaa.imaa69,    
                             g_imaa.imaa70,     g_imaa.imaa71,     g_imaa.imaa72,    g_imaa.imaa73,     g_imaa.imaa74,    
                             g_imaa.imaa86,     g_imaa.imaa86_fac, g_imaa.imaa87,    g_imaa.imaa871,    g_imaa.imaa872,   
                             g_imaa.imaa873,    g_imaa.imaa874,    g_imaa.imaa88,    g_imaa.imaa881,    g_imaa.imaa89,    
                             g_imaa.imaa90,     g_imaa.imaa91,     g_imaa.imaa92,    g_imaa.imaa93,     g_imaa.imaa94,    
                             g_imaa.imaa95,     g_imaa.imaa75,     g_imaa.imaa76,    g_imaa.imaa77,     g_imaa.imaa78,    
                             g_imaa.imaa79,     g_imaa.imaa80,     g_imaa.imaa81,    g_imaa.imaa82,     g_imaa.imaa83,    
                             g_imaa.imaa84,     g_imaa.imaa85,     g_imaa.imaa851,   g_imaa.imaa852,    g_imaa.imaa853,   
                             g_imaa.imaa96,     g_imaa.imaa97,     g_imaa.imaa98,    g_imaa.imaa99,     g_imaa.imaa100,   
                             g_imaa.imaa101,    g_imaa.imaa102,    g_imaa.imaa103,   g_imaa.imaa104,    g_imaa.imaa105,   
                             g_imaa.imaa106,    g_imaa.imaa107,    g_imaa.imaa108,   g_imaa.imaa109,    g_imaa.imaa110,   
                             g_imaa.imaa111,    g_imaa.imaa121,    g_imaa.imaa122,   g_imaa.imaa123,    g_imaa.imaa124,   
                             g_imaa.imaa125,    g_imaa.imaa126,    g_imaa.imaa127,   g_imaa.imaa128,    g_imaa.imaa129,   
                             g_imaa.imaa130,    g_imaa.imaa131,    g_imaa.imaa132,   g_imaa.imaa133,    g_imaa.imaa134,   
                             g_imaa.imaa135,    g_imaa.imaa136,    g_imaa.imaa137,   g_imaa.imaa138,    g_imaa.imaa139,   
                             g_imaa.imaa140,    g_imaa.imaa141,    g_imaa.imaa142,   g_imaa.imaa143,    g_imaa.imaa144,   
                             g_imaa.imaa145,    g_imaa.imaa146,    g_imaa.imaa147,   g_imaa.imaa148,    g_imaa.imaa901,   
                             g_imaa.imaa902,    g_imaa.imaa903,    g_imaa.imaa904,   g_imaa.imaa905,    g_imaa.imaa906,   
                             g_imaa.imaa907,    g_imaa.imaa908,    g_imaa.imaa909,   g_imaa.imaa910, 
                             g_imaa.imaaicd01,g_imaa.imaaicd02,g_imaa.imaaicd03,
                             g_imaa.imaaicd04,g_imaa.imaaicd05,g_imaa.imaaicd06,
                             g_imaa.imaaicd08,g_imaa.imaaicd09,g_imaa.imaaicd10,
                             g_imaa.imaaicd12,g_imaa.imaaicd14,  
                             g_imaa.imaaicd15,g_imaa.imaaicd16,   
                             g_imaa.imaaacti,  
                             g_imaa.imaauser,   g_imaa.imaagrup,   g_imaa.imaamodu,  g_imaa.imaadate,   g_imaa.imaaag,    
                             g_imaa.imaaag1,    g_imaa.imaaud01,   g_imaa.imaaud02,  g_imaa.imaaud03,   g_imaa.imaaud04,  
                             g_imaa.imaaud05,   g_imaa.imaaud06,   g_imaa.imaaud07,  g_imaa.imaaud08,   g_imaa.imaaud09,  
                             g_imaa.imaaud10,   g_imaa.imaaud11,   g_imaa.imaaud12,  g_imaa.imaaud13,   g_imaa.imaaud14,  
                             g_imaa.imaaud15,   g_imaa.imaa1001,   g_imaa.imaa1002,  g_imaa.imaa1003,   g_imaa.imaa1004,  
                             g_imaa.imaa1005,   g_imaa.imaa1006,   g_imaa.imaa1007,  g_imaa.imaa1008,   g_imaa.imaa1009,  
                             g_imaa.imaa1010,   g_imaa.imaa1011,   g_imaa.imaa1012,  g_imaa.imaa1013,   g_imaa.imaa1014,  
                             g_imaa.imaa1015,   g_imaa.imaa1016,   g_imaa.imaa1017,  g_imaa.imaa1018,   g_imaa.imaa1019,  
                             g_imaa.imaa1020,   g_imaa.imaa1021,   g_imaa.imaa1022,  g_imaa.imaa1023,   g_imaa.imaa1024,  
                             g_imaa.imaa1025,   g_imaa.imaa1026,   g_imaa.imaa1027,  g_imaa.imaa1028,   g_imaa.imaa1029,  
                             g_imaa.imaa911,    g_imaa.imaa912,    g_imaa.imaa913,   g_imaa.imaa914,    g_imaa.imaa391,   
                             g_imaa.imaa1321,   g_imaa.imaa915,    g_imaa.imaa918,   g_imaa.imaa919,    g_imaa.imaa920,   
                             g_imaa.imaa921,    g_imaa.imaa922,    g_imaa.imaa923,   g_imaa.imaa924,    g_imaa.imaa925,   
                             g_imaa.imaa601,    g_imaa.imaa926,    g_imaa.imaaoriu,  g_imaa.imaaorig,   g_imaa.imaa153,  
                             g_imaa.imaa120,    g_imaa.imaa159,    g_imaa.imaa721,   g_imaa.imaa1030    #FUN-B50096 add imaa159 #CHI-C50068 #FUN-D30006 add g_imaa.imaa1030
                        FROM ima_file
                      LEFT OUTER JOIN imaa_file ON imaa01=ima01 
                       WHERE ima01 = g_imaa.imaa01
                      LET g_imaa.imaa00  = g_imaa_t.imaa00 
                      LET g_imaa.imaano  = g_imaa_t.imaano 
                      LET g_imaa.imaa011 = g_imaa_t.imaa011
                      LET g_imaa.imaa92  = g_imaa_t.imaa92
                      LET g_imaa.imaa1010= g_imaa_t.imaa1010
                      LET g_imaa.imaaacti= g_imaa_t.imaaacti
                      LET g_imaa.imaauser= g_imaa_t.imaauser
                      LET g_imaa.imaagrup= g_imaa_t.imaagrup
                      LET g_imaa.imaamodu= g_imaa_t.imaamodu
                      LET g_imaa.imaadate= g_imaa_t.imaadate
                      CALL arti009_show()
                  END IF
               END IF
            ELSE                             
             IF g_imaa.imaa00<>'I' THEN
               CALL cl_err('','aim-157',0)     
               DISPLAY BY NAME g_imaa.imaa01 
               NEXT FIELD imaa01             
             END IF
            END IF
 
        BEFORE FIELD imaa02
            IF g_imaa.imaa00 = 'I' THEN
                IF g_sma.sma64='Y' AND cl_null(g_imaa.imaa02) THEN
                   CALL s_desinp(6,4,g_imaa.imaa02) RETURNING g_imaa.imaa02
                   DISPLAY BY NAME g_imaa.imaa02
                END IF
            END IF
 
        AFTER FIELD imaa02                     
           LET g_imaa_o.imaa02 = g_imaa.imaa02   
 
        AFTER FIELD imaa06   #分群碼
          IF g_imaa.imaa06 IS NOT NULL AND g_imaa.imaa06 != ' ' THEN 
              CALL s_field_chk(g_imaa.imaa06,'1',g_plant,'ima06') RETURNING g_flag
              IF g_flag = '0' THEN
                 CALL cl_err(g_imaa.imaa06,'aoo-043',1)
                 LET g_imaa.imaa06 = g_imaa_o.imaa06
                 DISPLAY BY NAME g_imaa.imaa06
                 NEXT FIELD imaa06
              END IF
                   IF (g_imaa_o.imaa06 IS NULL) OR (g_imaa.imaa06 != g_imaa_o.imaa06) THEN #MOD-490474
                      IF p_cmd='u' THEN  
                         CALL s_chkitmdel(g_imaa.imaa01) RETURNING g_errno
                      ELSE
                         LET g_errno=NULL
                      END IF
 
                      IF cl_null(g_errno) THEN                  
                         CALL arti009_imaa06('Y')  
                         IF NOT i009_chk_rel_imaa06(p_cmd) THEN
                         END IF
                      ELSE
                         CALL arti009_imaa06('N')                #只check 對錯,不詢問
                      END IF
 
                   ELSE
                      CALL arti009_imaa06('N')                   #只check 對錯,不詢問
                   END IF
 
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_imaa.imaa06,g_errno,0)
                      LET g_imaa.imaa06 = g_imaa_o.imaa06
                      DISPLAY BY NAME g_imaa.imaa06
                      NEXT FIELD imaa06
                   END IF
            END IF
            CALL i009_desc()
            LET g_imaa_o.imaa06 = g_imaa.imaa06
            CALL i009_set_entry(p_cmd)   
            CALL i009_set_no_entry(p_cmd)

        ON CHANGE imaa151
          CALL cl_set_comp_visible("imaaag",g_imaa.imaa151='Y')
          IF NOT i009_chk_imaaag() THEN
              NEXT FIELD CURRENT
          END IF 

        AFTER FIELD imaa151
           IF g_imaa.imaa151="Y" THEN
              IF g_sma.sma124 = 'slk' THEN
                 CALL cl_set_comp_visible("imaa940,imaa941",TRUE)
                 IF p_cmd = 'a' OR (p_cmd = 'u' AND g_n =0 ) THEN
                    CALL cl_set_comp_entry("imaa940,imaa941",TRUE)
                 END IF
                 CALL cl_set_comp_entry("imaaag",FALSE)
                 IF g_azw.azw04 = '1'  THEN
                    CALL cl_set_comp_entry("imaa940,imaa941",FALSE)
                    IF p_cmd='a' THEN
                       CALL cl_set_comp_entry("imaaag",TRUE)
                       CALL cl_set_comp_required("imaaag",TRUE)
                    END IF
                 END IF
              END IF
           ELSE
              CALL cl_set_comp_entry("imaa940",FALSE)
              CALL cl_set_comp_entry("imaa941",FALSE)
              LET g_imaa.imaa940 = NULL
              LET g_imaa.imaa941 = NULL
              LET g_imaa.imaaag  = NULL
              DISPLAY BY NAME g_imaa.imaa940,g_imaa.imaa941,g_imaa.imaaag
           END IF

        AFTER FIELD imaa940
           IF g_azw.azw04 <> '1' THEN
              IF g_imaa.imaa940 IS NOT NULL THEN
                 IF p_cmd = "a" OR
                     (p_cmd = "u" AND g_imaa.imaa940 != g_imaa_t.imaa940) THEN
                     CALL i009_imaa940('d')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('g_imaa.imaa940:',g_errno,1)
                        LET g_imaa.imaa940 = g_imaa_t.imaa940
                        DISPLAY BY NAME g_imaa.imaa940
                        NEXT FIELD imaa940 
                     END IF 
                 END IF
              ELSE   
                 IF g_imaa.imaa151 = 'Y' THEN
                    CALL cl_err('',-1124,1)
                    NEXT FIELD imaa940
                 END IF
              END IF
           END IF

        AFTER FIELD imaa941
           IF g_azw.azw04 <> '1' THEN
              IF g_imaa.imaa941 IS NOT NULL THEN
                 IF p_cmd = "a" OR
                     (p_cmd = "u" AND g_imaa.imaa941 != g_imaa_t.imaa941) THEN
                     CALL i009_imaa941('d')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('g_imaa.imaa941:',g_errno,1)
                        LET g_imaa.imaa941 = g_imaa_t.imaa941
                        DISPLAY BY NAME g_imaa.imaa941
                        NEXT FIELD imaa941
                     END IF
                 END IF
              ELSE
                 IF g_imaa.imaa151 = 'Y' THEN
                    CALL cl_err('',-1124,1)
                    NEXT FIELD imaa941
                 END IF
              END IF
           END IF

        AFTER FIELD imaaag
            IF NOT cl_null(g_imaa.imaaag) THEN
                SELECT count(*) INTO l_n FROM aga_file
                 WHERE aga01 = g_imaa.imaaag
                IF l_n <= 0 THEN
                    CALL cl_err('','aim-910',1)
                    NEXT FIELD imaaag
                END IF
            END IF
 
        BEFORE FIELD imaa08
            CALL i009_set_entry(p_cmd)
 
        ON CHANGE imaa08  #來源碼
            IF NOT cl_null(g_imaa.imaa08) THEN
               IF g_imaa.imaa08 NOT MATCHES "[CTDAMPXKUVRZS]" 
                    OR g_imaa.imaa08 IS NULL
                  THEN CALL cl_err(g_imaa.imaa08,'mfg1001',0)
                       LET g_imaa.imaa08 = g_imaa_o.imaa08
                       DISPLAY BY NAME g_imaa.imaa08
                       NEXT FIELD imaa08
                  ELSE IF g_imaa.imaa08 != 'T' THEN
                          LET g_imaa.imaa13 = NULL
                          DISPLAY BY NAME g_imaa.imaa13
                       END IF
               END IF
               LET l_misc=g_imaa.imaa01[1,4]
               IF l_misc='MISC' AND g_imaa.imaa08 <>'Z' THEN
                   CALL cl_err('','aim-805',0)
                   NEXT FIELD imaa08
               END IF
               LET g_imaa_o.imaa08 = g_imaa.imaa08
               IF g_imaa.imaa08 NOT MATCHES "[MT]" THEN 
                   LET g_imaa.imaa903 = 'N'
                   LET g_imaa.imaa905 = 'N'
                   DISPLAY BY NAME g_imaa.imaa903,g_imaa.imaa905
               END IF
            END IF
            CALL i009_set_entry(p_cmd)
            CALL i009_set_no_entry(p_cmd)

        AFTER FIELD imaa08
            CALL i009_set_no_entry(p_cmd)

        AFTER FIELD imaa09                     #其他分群碼一
           IF g_imaa.imaa09 IS NOT NULL AND g_imaa.imaa09 != ' ' THEN
               IF NOT i009_chk_imaa09() THEN
                  NEXT FIELD imaa09
               END IF
           END IF
           LET g_imaa_o.imaa09 = g_imaa.imaa09
 
        AFTER FIELD imaa10                     #其他分群碼二
           IF g_imaa.imaa10 IS NOT NULL AND g_imaa.imaa10 != ' ' THEN
               IF NOT i009_chk_imaa10() THEN
                  NEXT FIELD imaa10
               END IF
           END IF
           LET g_imaa_o.imaa10 = g_imaa.imaa10
 
        AFTER FIELD imaa11                     #其他分群碼三
           IF g_imaa.imaa11 IS NOT NULL AND g_imaa.imaa11 != ' ' THEN
               IF NOT i009_chk_imaa11() THEN
                  NEXT FIELD imaa11
               END IF
           END IF
           LET g_imaa_o.imaa11 = g_imaa.imaa11
                                    
        AFTER FIELD imaa12                     #其他分群碼四
             IF g_imaa.imaa12 IS NOT NULL AND g_imaa.imaa12 != ' ' THEN
                 IF NOT i009_chk_imaa12() THEN
                    NEXT FIELD imaa12
                 END IF 
             END IF
             LET g_imaa_o.imaa12 = g_imaa.imaa12
 
        AFTER FIELD imaa25            #庫存單位
            IF NOT cl_null(g_imaa.imaa25) THEN
                IF NOT i009_chk_imaa25() THEN
                   NEXT FIELD imaa25
                END IF 
                IF cl_null(g_imaa.imaa44) THEN
                   LET g_imaa.imaa44 = g_imaa.imaa25
                   LET g_imaa.imaa44_fac = 1
                END IF
                IF cl_null(g_imaa.imaa31) THEN
                   LET g_imaa.imaa31 = g_imaa.imaa25
                   LET g_imaa.imaa31_fac = 1
                END IF 
                DISPLAY BY NAME g_imaa.imaa44_fac,g_imaa.imaa31_fac,g_imaa.imaa44,g_imaa.imaa31
            END IF                   
            IF NOT cl_null(g_imaa.imaa25) AND p_cmd='u' THEN
               SELECT COUNT(*) INTO l_n FROM imaa_file
                WHERE (imaa63 <> g_imaa.imaa25 OR
                       imaa31 <> g_imaa.imaa25 OR
                       imaa44 <> g_imaa.imaa25 OR  
                       imaa55 <> g_imaa.imaa25
                      )  
                  AND imaa01=g_imaa.imaa01
                  AND imaano=g_imaa.imaano
               IF l_n > 0 THEN  
                  LET g_msg=cl_getmsg('aim-020',g_lang) 
                  IF cl_prompt(0,0,g_msg) THEN     
                     CALL arti009_a_updchk()
                  END IF
               ELSE 
                  IF g_imaa.imaa25<>g_imaa_o.imaa25 THEN
                     CALL arti009_a_updchk()
                  END IF
               END IF
            END IF
           #新增時,若有修改庫存單位(ima25)也應詢問aim-020
            IF NOT cl_null(g_imaa.imaa25) AND p_cmd='a' THEN
               IF g_imaa.imaa25 <> g_imaa_o.imaa25 OR
                  g_imaa.imaa63 <> g_imaa.imaa25 OR
                  g_imaa.imaa31 <> g_imaa.imaa25 OR
                  g_imaa.imaa44 <> g_imaa.imaa25 OR
                  g_imaa.imaa55 <> g_imaa.imaa25 THEN
                  LET g_msg=cl_getmsg('aim-020',g_lang)
                  IF cl_prompt(0,0,g_msg) THEN
                     CALL arti009_a_updchk()
                  END IF
               END IF
            END IF

        BEFORE FIELD imaa44
          IF cl_null(g_imaa.imaa44) THEN
             IF NOT cl_null(g_imaa.imaa25) THEN
                LET g_imaa.imaa44 = g_imaa.imaa25
                LET g_imaa.imaa44_fac = 1
                DISPLAY BY NAME g_imaa.imaa44,g_imaa.imaa44_fac
             END IF
          END IF
        
        AFTER FIELD imaa44
          IF NOT cl_null(g_imaa.imaa44) THEN
             CALL i009_imaa44()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa44 = g_imaa_t.imaa44
                NEXT FIELD imaa44
             END IF
             CALL s_umfchk('',g_imaa.imaa44,g_imaa.imaa25) RETURNING g_flag1,g_imaa.imaa44_fac
             IF g_flag1 THEN
                CALL cl_err('','art-066',0)
                NEXT FIELD imaa44
             END IF
             DISPLAY BY NAME g_imaa.imaa44_fac
          END IF

        BEFORE FIELD imaa31
          IF cl_null(g_imaa.imaa31) THEN
             IF NOT cl_null(g_imaa.imaa25) THEN
                LET g_imaa.imaa31 = g_imaa.imaa25
                LET g_imaa.imaa31_fac = 1
                DISPLAY BY NAME g_imaa.imaa31,g_imaa.imaa31_fac
             END IF
          END IF
        
        AFTER FIELD imaa31
          IF NOT cl_null(g_imaa.imaa31) THEN
             CALL i009_imaa31()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa31 = g_imaa_t.imaa31
                NEXT FIELD imaa31
             END IF
             CALL s_umfchk('',g_imaa.imaa31,g_imaa.imaa25) RETURNING g_flag1,g_imaa.imaa31_fac
             IF g_flag1 THEN
                CALL cl_err('','art-066',0)
                NEXT FIELD imaa31
             END IF
             DISPLAY BY NAME g_imaa.imaa31_fac
          END IF

        AFTER FIELD imaa54
          IF NOT cl_null(g_imaa.imaa54) THEN
             CALL i009_imaa54()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa54 = g_imaa_t.imaa54
                NEXT FIELD imaa54
             END IF
          END IF 

        AFTER FIELD imaa131
          IF NOT cl_null(g_imaa.imaa131) THEN
             CALL i009_imaa131()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa131 = g_imaa_t.imaa131
                NEXT FIELD imaa131
             END IF
             CALL i009_desc()
          END IF

       #FUN-D30006--add--str---
        AFTER FIELD imaa1030
           IF NOT cl_null(g_imaa.imaa1030) THEN
              CALL i009_imaa1030()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_imaa.imaa1030 = g_imaa_t.imaa1030
                 NEXT FIELD imaa1030
              END IF     
           END IF  
       #FUN-D30006--add--end---

        AFTER FIELD imaa1004
          IF NOT cl_null(g_imaa.imaa1004) THEN
             CALL i009_imaa1004()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa1004  = g_imaa_t.imaa1004
                NEXT FIELD imaa1004
             END IF
          END IF

        AFTER FIELD imaa1005
          IF NOT cl_null(g_imaa.imaa1005) THEN
             CALL i009_imaa1005()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa1005  = g_imaa_t.imaa1005
                NEXT FIELD imaa1005
             END IF
          END IF

        AFTER FIELD imaa1006
          IF NOT cl_null(g_imaa.imaa1006) THEN
             CALL i009_imaa1006()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa1006  = g_imaa_t.imaa1006
                NEXT FIELD imaa1006
             END IF
          END IF

        AFTER FIELD imaa1007
          IF NOT cl_null(g_imaa.imaa1007) THEN
             CALL i009_imaa1007()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa1007  = g_imaa_t.imaa1007
                NEXT FIELD imaa1007
             END IF
          END IF

        AFTER FIELD imaa1008
          IF NOT cl_null(g_imaa.imaa1008) THEN
             CALL i009_imaa1008()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa1008  = g_imaa_t.imaa1008
                NEXT FIELD imaa1008
             END IF
          END IF

       AFTER FIELD imaa1009
          IF NOT cl_null(g_imaa.imaa1009) THEN
             CALL i009_imaa1009()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imaa.imaa1009  = g_imaa_t.imaa1009
                NEXT FIELD imaa1009
             END IF
          END IF

        AFTER FIELD imaa45
          IF NOT cl_null(g_imaa.imaa45) THEN
             IF g_imaa.imaa45 < 0 THEN
                CALL cl_err('g_imaa.imaa45','alm-061',0)
                LET g_imaa.imaa45 = g_imaa_t.imaa45
                NEXT FIELD imaa45
             END IF
          END IF

        AFTER FIELD imaa46
          IF NOT cl_null(g_imaa.imaa46) THEN
             IF g_imaa.imaa46 < 0 THEN
                CALL cl_err('g_imaa.imaa46','alm-061',0)
                LET g_imaa.imaa46 = g_imaa_t.imaa46
                NEXT FIELD imaa46
             END IF
          END IF
 
        AFTER FIELD imaa47
          IF NOT cl_null(g_imaa.imaa47) THEN
             IF g_imaa.imaa47 < 0 THEN
                CALL cl_err('g_imaa.imaa47','alm-061',0)
                LET g_imaa.imaa47 = g_imaa_t.imaa47
                NEXT FIELD imaa47
             END IF
          END IF

        AFTER FIELD imaa39
            IF NOT cl_null(g_imaa.imaa39) OR g_imaa.imaa39 != ' '  THEN
               IF NOT i009_chk_imaa39() THEN
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imaa.imaa39 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_imaa.imaa39 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imaa.imaa39
                  DISPLAY BY NAME g_imaa.imaa39  
                  #FUN-B10049--end                   
                  NEXT FIELD imaa39
               END IF 
               SELECT aag02 INTO l_buf FROM aag_file
                      WHERE aag01 = g_imaa.imaa39
                         AND aag07 != '1'  
                         AND aag00 = g_aza.aza81  #No.FUN-730020
               MESSAGE l_buf CLIPPED
            END IF
            LET g_imaa_o.imaa39 = g_imaa.imaa39

      AFTER FIELD imaa149
         IF NOT cl_null(g_imaa.imaa149) OR g_imaa.imaa149 != ' '  THEN
            IF NOT i009_chk_imaa149() THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag02"
               LET g_qryparam.default1 = g_imaa.imaa149
               LET g_qryparam.construct = 'N'
               LET g_qryparam.arg1 = g_aza.aza81
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_imaa.imaa149  CLIPPED,"%' "
               CALL cl_create_qry() RETURNING g_imaa.imaa149
               DISPLAY BY NAME g_imaa.imaa149
               NEXT FIELD imaa149
            END IF
            SELECT aag02 INTO l_aag02 FROM aag_file
             WHERE aag01 = g_imaa.imaa149
               AND aag07 != '1'
               AND aag00 = g_aza.aza81
            MESSAGE l_aag02 CLIPPED
         END IF
         LET g_imaa_o.imaa149 = g_imaa.imaa149
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_imaa.imaauser = s_get_data_owner("imaa_file") #FUN-C10039
           LET g_imaa.imaagrup = s_get_data_group("imaa_file") #FUN-C10039
            LET g_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_imaa.imaa00 = 'I' THEN #申請類別為新增 #MOD-780102 add if 判斷
               IF ( g_imaa.imaa37='0' OR g_imaa.imaa37 ='5' )
                  AND ( g_imaa.imaa08 NOT MATCHES '[MSPVZ]' )
               THEN CALL cl_err(g_imaa.imaa37,'mfg3201',1)
                    NEXT FIELD imaa01
                    DISPLAY BY NAME g_imaa.imaa37
                    DISPLAY BY NAME g_imaa.imaa08
               END IF
               IF g_sma.sma115 = 'Y' THEN
                  IF g_imaa.imaa906 IS NULL THEN
                     NEXT FIELD imaa906
                  END IF
               END IF
               IF g_sma.sma122 = '1' THEN
                  IF g_imaa.imaa906 = '3' THEN
                     CALL cl_err('','asm-322',1)
                     NEXT FIELD imaa906
                  END IF
               END IF
               IF g_sma.sma122 = '2' THEN
                  IF g_imaa.imaa906 = '2' THEN
                     CALL cl_err('','asm-323',1)
                     NEXT FIELD imaa906
                  END IF
               END IF
            ELSE
               IF cl_null(g_imaa.imaa00)  THEN 
                  DISPLAY BY NAME g_imaa.imaa01
                  NEXT FIELD imaa01
               END IF
            END IF

            IF NOT cl_null(g_imaa.imaa01) THEN
               IF p_cmd = "a" OR         
                 (p_cmd = "u" AND g_imaa.imaa01 != g_imaa01_t) THEN
                  IF g_imaa.imaa00 = 'I' THEN #新增
                     LET l_n = 0 
                     SELECT count(*) INTO l_n FROM imaa_file
                      WHERE imaa01 = g_imaa.imaa01
                     IF l_n > 0 THEN
                        CALL cl_err(g_imaa.imaa01,-239,1) 
                        LET g_imaa.imaa01 = ''
                        DISPLAY BY NAME g_imaa.imaa01
                        NEXT FIELD imaa01
                     END IF
                     LET l_n = 0 
                     SELECT count(*) INTO l_n FROM imaa_file
                      WHERE imaa01 = g_imaa.imaa01
                        AND imaa00 = 'I' #新增
                     IF l_n > 0 THEN
                        CALL cl_err(g_imaa.imaa01,-239,1) 
                        LET g_imaa.imaa01 = ''
                        DISPLAY BY NAME g_imaa.imaa01
                        NEXT FIELD imaa01
                     END IF
                  ELSE
                     LET l_imaano = NULL
                     SELECT imaano INTO l_imaano FROM imaa_file
                      WHERE imaa01 = g_imaa.imaa01
                        AND imaa00 = 'U' #修改
                        AND imaa1010 != '2' 
                        AND imaaacti != 'N' #MOD-B40095 add
                     IF NOT cl_null(l_imaano) THEN
                        #已存在一張相同料號,但未拋轉的料件申請單!
                        CALL cl_err(l_imaano,'aim-150',1)
                        LET g_imaa.imaa01 = ''
                        DISPLAY BY NAME g_imaa.imaa01
                        NEXT FIELD imaa01
                     END IF
                  END IF
               END IF
            END IF
            IF g_sma.sma124 = 'slk' THEN
               IF g_azw.azw04 <> '1' THEN
                  LET g_imaa.imaaag = g_imaa.imaa940,"-",g_imaa.imaa941
                  DISPLAY BY NAME g_imaa.imaaag
                  IF g_imaa.imaaag IS NULL OR g_imaa.imaaag = " " THEN
                      CALL cl_err('',-1124,1)
                      NEXT FIELD imaaag
                  ELSE
                      SELECT  count(*) INTO l_n FROM aga_file WHERE aga01 = g_imaa.imaaag
                      IF l_n = 0 THEN
                         CALL i009_insert310()
                      END IF
                  END IF
                  IF g_imaa.imaa151 = 'Y' THEN
                     CALL cl_set_act_visible("produce_sub_parts",TRUE)
                  ELSE
                     CALL cl_set_act_visible("produce_sub_parts",FALSE)
                  END IF
                END IF
            END IF
      
        ON ACTION controlp
            CASE
               WHEN INFIELD(imaano)
                  LET g_t1 = s_get_doc_no(g_imaa.imaano)    
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','Z') RETURNING g_t1 
                  LET g_imaa.imaano = g_t1
                  DISPLAY BY NAME g_imaa.imaano
                  NEXT FIELD imaano
               WHEN INFIELD(imaa01) #料件編號
                    IF g_imaa.imaa00='U' THEN
                        #'U':修改時查ima01
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = 'q_ima'
                        LET g_qryparam.default1 = g_imaa.imaa01
                        LET g_qryparam.where    = " ( ima120 = '1' OR ima120 IS NULL OR ima120 = ' ') "
                        CALL cl_create_qry() RETURNING g_imaa.imaa01
                        DISPLAY BY NAME g_imaa.imaa01
                        NEXT FIELD imaa01
                    END IF
               WHEN INFIELD(imaa06) #分群碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imz"
                  LET g_qryparam.default1 = g_imaa.imaa06
                  CALL cl_create_qry() RETURNING g_imaa.imaa06
                  DISPLAY BY NAME g_imaa.imaa06
                  NEXT FIELD imaa06
               WHEN INFIELD(imaa131) #產品分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oba"
                  LET g_qryparam.where = " oba14 = 0 AND obaacti = 'Y' " #TQC-C30032 Add
                  LET g_qryparam.default1 = g_imaa.imaa131
                  CALL cl_create_qry() RETURNING g_imaa.imaa131
                  DISPLAY BY NAME g_imaa.imaa131
                  NEXT FIELD imaa131
              #FUN-D30006--add--str---
               WHEN INFIELD(imaa1030) #產品分類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rzh01"
                  LET g_qryparam.default1 = g_imaa.imaa1030
                  CALL cl_create_qry() RETURNING g_imaa.imaa1030
                  DISPLAY BY NAME g_imaa.imaa1030
                  NEXT FIELD imaa1030
              #FUN-D30006--add--end---
               WHEN INFIELD(imaa149) #代銷科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag02"
                  LET g_qryparam.default1 = g_imaa.imaa149
                  LET g_qryparam.arg1 = g_aza.aza81
                  CALL cl_create_qry() RETURNING g_imaa.imaa149
                  DISPLAY BY NAME g_imaa.imaa149
                  NEXT FIELD imaa149
               WHEN INFIELD(imaa1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = "2"
                  CALL cl_create_qry() RETURNING g_imaa.imaa1005
                  NEXT FIELD imaa1005 
               WHEN INFIELD(imaa1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = "3"
                  CALL cl_create_qry() RETURNING g_imaa.imaa1006
                  NEXT FIELD imaa1006
               WHEN INFIELD(imaaag)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aga"
                  LET g_qryparam.default1 = g_imaa.imaaag
                  CALL cl_create_qry() RETURNING g_imaa.imaaag
                  DISPLAY BY NAME g_imaa.imaaag
                  NEXT FIELD imaaag
               WHEN INFIELD(imaa09) #其他分群碼一
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa09
                  LET g_qryparam.arg1     = "D"
                  CALL cl_create_qry() RETURNING g_imaa.imaa09
                  DISPLAY BY NAME g_imaa.imaa09
                  NEXT FIELD imaa09
               WHEN INFIELD(imaa10) #其他分群碼二
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa10
                  LET g_qryparam.arg1     = "E"
                  CALL cl_create_qry() RETURNING g_imaa.imaa10
                  DISPLAY BY NAME g_imaa.imaa10
                  NEXT FIELD imaa10
               WHEN INFIELD(imaa11) #其他分群碼三
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa11
                  LET g_qryparam.arg1     = "F"
                  CALL cl_create_qry() RETURNING g_imaa.imaa11 
                  DISPLAY BY NAME g_imaa.imaa11
                  NEXT FIELD imaa11
               WHEN INFIELD(imaa12) #成本分群碼
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form    = "q_azf"
                  LET g_qryparam.default1 = g_imaa.imaa12
                  LET g_qryparam.arg1     = "G"
                  CALL cl_create_qry() RETURNING g_imaa.imaa12 
                  DISPLAY BY NAME g_imaa.imaa12
                  NEXT FIELD imaa12
               WHEN INFIELD(imaa25) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa25
                  CALL cl_create_qry() RETURNING g_imaa.imaa25
                  DISPLAY BY NAME g_imaa.imaa25
                  NEXT FIELD imaa25
               WHEN INFIELD(imaa44) #採購單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa44
                  CALL cl_create_qry() RETURNING g_imaa.imaa44
                  DISPLAY BY NAME g_imaa.imaa44
                  NEXT FIELD imaa44
               WHEN INFIELD(imaa31) #銷售單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_imaa.imaa31
                  CALL cl_create_qry() RETURNING  g_imaa.imaa31
                  DISPLAY BY NAME g_imaa.imaa31
                  NEXT FIELD imaa31
               WHEN INFIELD(imaa54) #主供應商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imaa54
                  NEXT FIELD imaa54
               WHEN INFIELD(imaa39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_imaa.imaa39
                  LET g_qryparam.arg1     = g_aza.aza81  #No.FUN-730020
                  CALL cl_create_qry() RETURNING g_imaa.imaa39
                  DISPLAY BY NAME g_imaa.imaa39
                  NEXT FIELD imaa39
               WHEN INFIELD(imaa1004)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = "1"
                  CALL cl_create_qry() RETURNING g_imaa.imaa1004
                  DISPLAY g_imaa.imaa1004 TO imaa1004
                  NEXT FIELD imaa1004
               WHEN INFIELD(imaa1007)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = "4"
                  CALL cl_create_qry() RETURNING g_imaa.imaa1007
                  DISPLAY g_imaa.imaa1007 TO imaa1007
                  NEXT FIELD imaa1007
               WHEN INFIELD(imaa1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = "5"
                  CALL cl_create_qry() RETURNING g_imaa.imaa1008
                  DISPLAY g_imaa.imaa1008 TO imaa1008
                  NEXT FIELD imaa1008
               WHEN INFIELD(imaa1009)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = "6"
                  CALL cl_create_qry() RETURNING g_imaa.imaa1009
                  DISPLAY g_imaa.imaa1009 TO imaa1009
                  NEXT FIELD imaa1009
               WHEN INFIELD(imaa940)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_agc"
                  LET g_qryparam.where = "agc07 = '1'"
                  LET g_qryparam.default1 = g_imaa.imaa940
                  CALL cl_create_qry() RETURNING g_imaa.imaa940
                  DISPLAY g_imaa.imaa940 TO imaa940
                  NEXT FIELD imaa940
               WHEN INFIELD(imaa941)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_agc"
                  LET g_qryparam.where = "agc07 = '2'"
                  LET g_qryparam.default1 = g_imaa.imaa941
                  CALL cl_create_qry() RETURNING g_imaa.imaa941
                  DISPLAY g_imaa.imaa941 TO imaa941
                  NEXT FIELD imaa941
               OTHERWISE EXIT CASE
            END CASE
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION update
            IF NOT cl_null(g_imaa.imaa01) THEN
               LET g_doc.column1 = "imaa01"
               LET g_doc.value1 = g_imaa.imaa01
               CALL cl_fld_doc("imaa04")
            END IF
            
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION help          
             CALL cl_show_help()  

          ON ACTION auto_getno
            IF g_imaa.imaa00 = 'I' AND cl_null(g_imaa.imaa01) THEN #新增且申請料件編號為空時,才CALL自動編號附程式
                IF g_aza.aza28 = 'Y' THEN
                   CALL s_auno(g_imaa.imaa01,'1','') RETURNING g_imaa.imaa01,g_imaa.imaa02  #No.FUN-850100
                   IF NOT cl_null(g_imaa_t.imaa02) THEN
                      IF g_imaa_t.imaa02 <> g_imaa_o.imaa02 THEN
                         LET g_imaa.imaa02 = g_imaa_o.imaa02
                      ELSE 
                         LET g_imaa.imaa02 = g_imaa_t.imaa02
                      END IF 
                   END IF
                   DISPLAY BY NAME g_imaa.imaa01,g_imaa.imaa02
                END IF
            END IF
             
    END INPUT
    IF g_sma.sma124 = 'slk' THEN
       IF g_imaa.imaa151 = 'Y'THEN
          CALL cl_set_act_visible("produce_sub_parts",TRUE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION arti009_a_updchk()
   LET g_imaa.imaa31=g_imaa.imaa25
   LET g_imaa.imaa31_fac=1

   LET g_imaa.imaa44=g_imaa.imaa25   #採購單位
   LET g_imaa.imaa44_fac=1

   LET g_imaa.imaa55=g_imaa.imaa25   #生產單位
   LET g_imaa.imaa55_fac=1

   LET g_imaa.imaa63=g_imaa.imaa25   #發料單位
   LET g_imaa.imaa63_fac=1

   LET g_imaa.imaa86=g_imaa.imaa25   #庫存單位=成本單位
   LET g_imaa.imaa86_fac=1
END FUNCTION

FUNCTION arti009_imaa06(p_def) 
   DEFINE
               p_def          LIKE type_file.chr1,
               l_ans          LIKE type_file.chr1,
               l_msg          LIKE ze_file.ze03, 
               l_imz02        LIKE imz_file.imz02,
               l_imzacti      LIKE imz_file.imzacti,
               l_imaaacti     LIKE imaa_file.imaaacti,
               l_imaauser     LIKE imaa_file.imaauser,
               l_imaagrup     LIKE imaa_file.imaagrup,
               l_imaamodu     LIKE imaa_file.imaamodu,
               l_imaadate     LIKE imaa_file.imaadate
 
   LET g_errno = ' '
   LET l_ans=' '
    SELECT imzacti INTO l_imzacti
      FROM imz_file
     WHERE imz01 = g_imaa.imaa06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
         WHEN l_imzacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF SQLCA.sqlcode =0 AND cl_null(g_errno) AND p_def = 'Y' THEN 
      CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
      CALL cl_confirm('mfg5033') RETURNING l_ans
      IF l_ans THEN
          SELECT imz01,imz02,imz03 ,imz04,
                 imz07,imz08,imz09,imz10,
                 imz11,imz12,imz14,imz15,
                 imz17,imz19,imz21,
                 imz23,imz24,imz25,imz27,
                 imz28,imz31,imz31_fac,imz34,
                 imz35,imz36,imz37,imz38,
                 imz39,imz42,imz43,imz44,
                 imz44_fac,imz45,imz46 ,imz47,
                 imz48,imz49,imz491,imz50,
                 imz51,imz52,imz54,imz55,
                 imz55_fac,imz56,imz561,imz562,
                 imz571,
                 imz59 ,imz60,imz601,imz61,imz62, 
                 imz63,imz63_fac ,imz64,imz641,
                 imz65,imz66,imz67,imz68,
                 imz69,imz70,imz71,imz86,
                 imz86_fac ,imz87,imz871,imz872,
                 imz873,imz874,imz88,imz89,
                 imz90,imz94,imz99,imz100 ,
                 imz101,imz102 ,imz103,imz105,
                 imz106,imz107,imz108,imz109,
                 imz110,imz130,imz131,imz132,
                 imz133,imz134,
                 imz147,imz148,imz903,
                 imzacti,imzuser,imzgrup,imzmodu,imzdate,
                 imz906,imz907,imz908,imz909,
                 imz911,
                 imz918,imz919,imz920,imz921,imz922,imz923,imz924,imz925,  
                 imz928,imz929,                        
                 imz926,          
                 imz136,imz137,imz391,imz1321,
                 imz72,
                 imzicd01,imzicd04,imzicd05,imzicd16,  
                 imzicd08,imzicd09,imzicd10,        
                 imzicd12,imzicd14,imzicd15,
                 imz022,imz251,imz159           
                 INTO g_imaa.imaa06,l_imz02,g_imaa.imaa03,g_imaa.imaa04,
                      g_imaa.imaa07,g_imaa.imaa08,g_imaa.imaa09,g_imaa.imaa10,
                      g_imaa.imaa11,g_imaa.imaa12,g_imaa.imaa14,g_imaa.imaa15,
                      g_imaa.imaa17,g_imaa.imaa19,g_imaa.imaa21,
                      g_imaa.imaa23,g_imaa.imaa24,g_imaa.imaa25,g_imaa.imaa27, 
                      g_imaa.imaa28,g_imaa.imaa31,g_imaa.imaa31_fac,g_imaa.imaa34,
                      g_imaa.imaa35,g_imaa.imaa36,g_imaa.imaa37,g_imaa.imaa38,
                      g_imaa.imaa39,g_imaa.imaa42,g_imaa.imaa43,g_imaa.imaa44,
                      g_imaa.imaa44_fac,g_imaa.imaa45,g_imaa.imaa46,g_imaa.imaa47,
                      g_imaa.imaa48,g_imaa.imaa49,g_imaa.imaa491,g_imaa.imaa50,
                      g_imaa.imaa51,g_imaa.imaa52,g_imaa.imaa54,g_imaa.imaa55,
                      g_imaa.imaa55_fac,g_imaa.imaa56,g_imaa.imaa561,g_imaa.imaa562,
                      g_imaa.imaa571,
                      g_imaa.imaa59, g_imaa.imaa60,g_imaa.imaa601,g_imaa.imaa61,g_imaa.imaa62, 
                      g_imaa.imaa63, g_imaa.imaa63_fac,g_imaa.imaa64,g_imaa.imaa641,
                      g_imaa.imaa65, g_imaa.imaa66,g_imaa.imaa67,g_imaa.imaa68,
                      g_imaa.imaa69, g_imaa.imaa70,g_imaa.imaa71,g_imaa.imaa86,
                      g_imaa.imaa86_fac, g_imaa.imaa87,g_imaa.imaa871,g_imaa.imaa872,
                      g_imaa.imaa873, g_imaa.imaa874,g_imaa.imaa88,g_imaa.imaa89,
                      g_imaa.imaa90,g_imaa.imaa94,g_imaa.imaa99,g_imaa.imaa100,  
                      g_imaa.imaa101,g_imaa.imaa102,g_imaa.imaa103,g_imaa.imaa105,
                      g_imaa.imaa106,g_imaa.imaa107,g_imaa.imaa108,g_imaa.imaa109,
                      g_imaa.imaa110,g_imaa.imaa130,g_imaa.imaa131,g_imaa.imaa132,
                      g_imaa.imaa133,g_imaa.imaa134,   
                      g_imaa.imaa147,g_imaa.imaa148,g_imaa.imaa903,
                      l_imaaacti,l_imaauser,l_imaagrup,l_imaamodu,l_imaadate,
                      g_imaa.imaa906,g_imaa.imaa907,g_imaa.imaa908,g_imaa.imaa909, 
                      g_imaa.imaa911,  
                      g_imaa.imaa918,g_imaa.imaa919,g_imaa.imaa920,
                      g_imaa.imaa921,g_imaa.imaa922,g_imaa.imaa923, 
                      g_imaa.imaa924,g_imaa.imaa925, 
                      g_imaa.imaa928,g_imaa.imaa929,      
                      g_imaa.imaa926,  
                      g_imaa.imaa136,g_imaa.imaa137,
                      g_imaa.imaa391,g_imaa.imaa1321,g_imaa.imaa915,  
                      g_imaa.imaaicd01,g_imaa.imaaicd04,g_imaa.imaaicd05,g_imaa.imaaicd16,
                      g_imaa.imaaicd08,g_imaa.imaaicd09,g_imaa.imaaicd10,g_imaa.imaaicd12,
                      g_imaa.imaaicd14,g_imaa.imaaicd15, 
                      g_imaa.imaa022,g_imaa.imaa251,g_imaa.imaa159
                 FROM  imz_file
                 WHERE imz01 = g_imaa.imaa06
       IF g_imaa.imaa99 IS NULL THEN LET g_imaa.imaa99 = 0 END IF
       IF g_imaa.imaa133 IS NULL THEN LET g_imaa.imaa133 = g_imaa.imaa01 END IF
       IF g_imaa.imaa01[1,4]='MISC' THEN 
          LET g_imaa.imaa08='Z'
       END IF
       IF cl_null(g_errno)  AND l_ans ="1"  THEN   
          CALL arti009_show()
       END IF
     END IF
  END IF
END FUNCTION
 

FUNCTION arti009_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL arti009_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_imaa.* TO NULL
        INITIALIZE g_imaa_t.* TO NULL
        INITIALIZE g_imaa_o.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Searching!"
    OPEN arti009_curs          
    IF SQLCA.sqlcode THEN
        CALL cl_err('g_imaa.imaano',SQLCA.sqlcode,0)
        INITIALIZE g_imaa.* TO NULL
    ELSE
        OPEN arti009_count
        FETCH arti009_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL arti009_fetch('F')       
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION arti009_fetch(p_flimaa)
    DEFINE
        p_flimaa          LIKE type_file.chr1 
 
    CASE p_flimaa
        WHEN 'N' FETCH NEXT     arti009_curs INTO g_imaa.imaano
        WHEN 'P' FETCH PREVIOUS arti009_curs INTO g_imaa.imaano
        WHEN 'F' FETCH FIRST    arti009_curs INTO g_imaa.imaano
        WHEN 'L' FETCH LAST     arti009_curs INTO g_imaa.imaano
        WHEN '/'
            IF (NOT mi_no_ask) THEN        
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
            FETCH ABSOLUTE g_jump arti009_curs INTO g_imaa.imaano
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
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_imaa.* FROM imaa_file 
       WHERE imaano = g_imaa.imaano
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  
    ELSE
        LET g_data_owner = g_imaa.imaauser    
        LET g_data_group = g_imaa.imaagrup    
        CALL arti009_show()
    END IF
END FUNCTION
 
FUNCTION arti009_show()
 
   SELECT imaa93 INTO g_imaa.imaa93 FROM imaa_file
    WHERE imaano=g_imaa.imaano
   LET g_imaa_t.* = g_imaa.*
   LET g_d2=g_imaa.imaa262-g_imaa.imaa26
  #DISPLAY BY NAME g_imaa.imaano,g_imaa.imaa00,g_imaa.imaa01,g_imaa.imaa02,g_imaa.imaa06,                #MOD-C30107 Mark
   DISPLAY BY NAME g_imaa.imaano,g_imaa.imaa00,g_imaa.imaa01,g_imaa.imaa02,g_imaa.imaa021,g_imaa.imaa06, #MOD-C30107 Add
                 g_imaa.imaa08,g_imaa.imaa131,g_imaa.imaa1005,g_imaa.imaa1006,g_imaa.imaa1030,g_imaa.imaa154,  #FUN-D30006 add g_imaa.imaa1030
                 g_imaa.imaa151,
                 g_imaa.imaa940,g_imaa.imaa941,
                 g_imaa.imaaag,g_imaa.imaa120,
                 g_imaa.imaa25,g_imaa.imaa44,g_imaa.imaa44_fac,g_imaa.imaa31,g_imaa.imaa31_fac,g_imaa.imaa54,g_imaa.imaa12,
                 g_imaa.imaa39,g_imaa.imaa149,g_imaa.imaa1010,g_imaa.imaa1004,g_imaa.imaa1007,
                 g_imaa.imaa1008,g_imaa.imaa1009,g_imaa.imaa915,g_imaa.imaa45,g_imaa.imaa46,
                 g_imaa.imaa47,g_imaa.imaa09,g_imaa.imaa10,g_imaa.imaa11,g_imaa.imaa531,
                 g_imaa.imaauser,g_imaa.imaagrup,g_imaa.imaaoriu,g_imaa.imaamodu,g_imaa.imaadate,
                 g_imaa.imaaorig,g_imaa.imaaacti
   CALL i009_desc() 
 
   IF NOT cl_null(g_imaa.imaaag) AND g_imaa.imaaag <> '@CHILD' THEN
      CALL cl_set_act_visible("add_multi_attr_sub",TRUE)
   ELSE
      CALL cl_set_act_visible("add_multi_attr_sub",FALSE)
   END IF

   IF g_imaa.imaa151="Y" THEN
      IF g_sma.sma124 = 'slk' THEN
         CALL cl_set_act_visible("produce_sub_parts",TRUE)
         CALL cl_set_comp_visible("imaa940,imaa941",TRUE)
      ELSE
         CALL cl_set_act_visible("produce_sub_parts",FALSE)
         CALL cl_set_comp_visible("imaa940,imaa941",FALSE)
      END IF
   ELSE
      CALL cl_set_act_visible("produce_sub_parts",FALSE)
   END IF

   IF g_sma.sma120 != 'Y' THEN
      CALL cl_set_comp_visible("imaaag",FALSE)
   ELSE
      IF g_imaa.imaa151 = 'Y' THEN
         CALL cl_set_comp_visible("imaaag",TRUE)
      END IF
   END IF

   LET g_doc.column1 = "imaa01"
   LET g_doc.value1 = g_imaa.imaa01
   CALL cl_get_fld_doc("imaa04")

   CALL i009_show_pic()
   CALL cl_show_fld_cont()   
END FUNCTION
 
FUNCTION arti009_u(p_cmd)   
    DEFINE l_imzacti  LIKE imz_file.imzacti
    DEFINE p_cmd      LIKE type_file.chr1  
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
    IF g_imaa.imaaacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_imaa.imaano,'mfg1000',0)
       RETURN
    END IF
    #非開立狀態，不可異動！
    #狀況=>R:送簽退回,W:抽單 也要可以修改
    IF g_input_itemno = 'N' THEN 
        IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN 
           CALL cl_err('','atm-046',1) 
           RETURN 
        END IF 
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imaa01_t = g_imaa.imaa01
    LET g_imaano_t = g_imaa.imaano
    LET g_imaa_o.* = g_imaa.*
    LET g_imaa_t.* = g_imaa.*  

    BEGIN WORK    
 
    OPEN arti009_cl USING g_imaa.imaano
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       ROLLBACK WORK     
       RETURN
    END IF
    FETCH arti009_cl INTO g_imaa.*                  #對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       ROLLBACK WORK    
       RETURN
    END IF

    IF g_imaa.imaa151 = 'N' AND g_imaa.imaaag = '@CHILD' THEN
       CALL cl_err(g_imaa.imaa01,'-100',0)   #子料件資料不能進行修改
       RETURN
    END IF
    SELECT COUNT(*) INTO g_n FROM imx_file WHERE imx00=g_imaa.imaa01
    IF g_n > 0 AND NOT cl_null(g_n) THEN
       CALL cl_set_comp_entry("imaaag,imaa151,imaa940,imaa941",FALSE)
    END IF

    LET g_imaa.imaamodu = g_user                   #修改者
    LET g_imaa.imaadate = g_today                  #修改日期
    CALL arti009_show()                            # 顯示最新資料
    WHILE TRUE
       LET g_imaa.imaamodu = g_user               #修改者
       LET g_imaa.imaadate = g_today              #修改日期
       CALL cl_set_comp_visible("imaag",g_ima.ima151)
       CALL arti009_i("u")                        # 欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_imaa.*=g_imaa_t.*
           CALL arti009_show()
           CALL cl_err('',9001,0)
           ROLLBACK WORK       #FUN-680010
           EXIT WHILE
       END IF
       #為了擋user是使用copy,但使用的舊料件的主分群碼已無效
       IF NOT cl_null(g_imaa.imaa06) THEN
          LET g_errno=' '
          SELECT imzacti INTO l_imzacti FROM imz_file
           WHERE imz01 = g_imaa.imaa06
          CASE
             WHEN SQLCA.SQLCODE = 100
                LET g_errno = 'mfg3179'
             WHEN l_imzacti='N'
                LET g_errno = '9028'
             OTHERWISE
                LET g_errno = SQLCA.SQLCODE USING '-------'
          END CASE
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_imaa.imaa06,g_errno,1)
             DISPLAY BY NAME g_imaa.imaa06
             ROLLBACK WORK       
             BEGIN WORK         
             CONTINUE WHILE
          END IF
       END IF
       IF g_imaa.imaa1010 MATCHES '[RW]' THEN
           LET g_imaa.imaa1010 = '0' #開立
       END IF
       IF cl_null(g_imaa.imaa01) THEN
           LET g_imaa.imaa01 = ' '
       END IF
       IF p_cmd = 'a' AND g_imaa.imaa00 = 'I' THEN 
          IF cl_null(g_imaa.imaa571) THEN
             LET g_imaa.imaa571 = g_imaa.imaa01
          END IF

          IF cl_null(g_imaa.imaa133) THEN
             LET g_imaa.imaa133 = g_imaa.imaa01
          END IF
       END IF 
       UPDATE imaa_file SET imaa_file.* = g_imaa.*    # 更新DB
        WHERE imaano = g_imaano_t                     # COLAUTH?
       IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1) 
           ROLLBACK WORK
           BEGIN WORK
           CONTINUE WHILE
       ELSE           
           LET g_errno = TIME
           LET g_msg = 'Chg No:',g_imaa.imaano
           INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) 
              VALUES ('arti009',g_user,g_today,g_errno,g_imaa.imaano,g_msg,g_plant,g_legal) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","arti009","",SQLCA.sqlcode,"","",1)
              ROLLBACK WORK
              BEGIN WORK
              CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE arti009_cl
    COMMIT WORK 
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano
    CALL arti009_show()                                            
END FUNCTION
 
FUNCTION arti009_x()
    DEFINE l_chr         LIKE type_file.chr1  
    DEFINE l_n           LIKE type_file.num5   
    DEFINE l_imaano      LIKE imaa_file.imaano 
 
    LET g_errno = ''   
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #非開立狀態，不可異動！
    #狀況=>R:送簽退回,W:抽單 也要可以做無效切換
    IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN 
       CALL cl_err('','atm-046',1) 
       RETURN
    END IF 

    IF g_imaa.imaa00 = 'U' AND g_imaa.imaaacti='N' THEN
       LET l_imaano = NULL                                       
       SELECT imaano INTO l_imaano FROM imaa_file                
        WHERE imaa01 = l_newno01                             
          AND imaa00 = 'U' #修改                                 
          AND imaa1010 != '2'                                    
          AND imaaacti != 'N' 
       IF NOT cl_null(l_imaano) THEN                             
          #已存在一張相同料號,但未拋轉的料件申請單!              
          CALL cl_err(l_imaano,'aim-150',1)                      
          RETURN
       END IF               
    END IF
    
    BEGIN WORK
    OPEN arti009_cl USING g_imaa.imaano
    FETCH arti009_cl INTO g_imaa.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL arti009_show()
 
    IF cl_exp(0,0,g_imaa.imaaacti) THEN
        LET g_chr=g_imaa.imaaacti
        IF g_imaa.imaaacti='Y' THEN
            LET g_imaa.imaaacti='N'
        ELSE
            LET g_imaa.imaaacti='Y'
        END IF
        UPDATE imaa_file
            SET imaaacti=g_imaa.imaaacti,
                imaamodu=g_user, 
                imaadate=g_today,
                imaa1010 ='0' #開立 
            WHERE imaano=g_imaa.imaano
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","imaa_file",g_imaa_t.imaano,"",SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
        END IF
    END IF
    CLOSE arti009_cl
    COMMIT WORK
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
    CALL arti009_show()                                            
END FUNCTION
 
FUNCTION arti009_r()
    DEFINE l_chr    LIKE type_file.chr1 
    DEFINE l_azo06  LIKE azo_file.azo06
    DEFINE l_n       LIKE type_file.num5
    IF s_shut(0) THEN RETURN END IF
    IF g_imaa.imaano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #非開立狀態，不可異動！
    #狀況=>R:送簽退回,W:抽單 也要可以做刪除
    IF g_imaa.imaa1010 NOT MATCHES '[0RW]'  THEN 
       CALL cl_err('','atm-046',1) 
       RETURN 
    END IF 
 
    SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano=g_imaa.imaano
 
    BEGIN WORK
 
    OPEN arti009_cl USING g_imaa.imaano
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0) 
       ROLLBACK WORK 
       RETURN
    END IF
    FETCH arti009_cl INTO g_imaa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imaa.imaano,SQLCA.sqlcode,0)
       ROLLBACK WORK 
       RETURN
    END IF
    CALL arti009_show()
    CALL s_chkitmdel(g_imaa.imaano) RETURNING g_errno
    IF NOT cl_null(g_errno) THEN 
       CALL cl_err('',g_errno,0) 
       RETURN 
    END IF
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL
        LET g_doc.column1 = "imaano"
        LET g_doc.value1 = g_imaa.imaano
        CALL cl_del_doc()
        DELETE FROM imaa_file WHERE imaano = g_imaa.imaano
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  
           ROLLBACK WORK  
           RETURN        
        ELSE           
           LET g_msg=TIME
           #增加記錄料號
           LET l_azo06='R: ',g_imaa.imaano CLIPPED
           INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980004
              VALUES ('arti009',g_user,g_today,g_msg,g_imaa.imaano,l_azo06,g_plant,g_legal) #FUN-980004
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","azo_file","arti009","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              ROLLBACK WORK
              RETURN
           END IF
           CLEAR FORM 
           OPEN arti009_count
           FETCH arti009_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
 
           OPEN arti009_curs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL arti009_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE      
              CALL arti009_fetch('/')
           END IF
        END IF
    END IF
    CLOSE arti009_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION arti009_copy()
    DEFINE
        l_imaa     RECORD LIKE imaa_file.*,
        l_smd      RECORD LIKE smd_file.*,
        l_n               LIKE type_file.num5,   
        l_newno           LIKE imaa_file.imaano,
        l_oldno           LIKE imaa_file.imaano,
        l_imaano          LIKE imaa_file.imaano,
        l_newno00         LIKE imaa_file.imaa00,
        l_newno01         LIKE imaa_file.imaa01,
        l_oldno01         LIKE imaa_file.imaa01
    DEFINE  li_result     LIKE type_file.num5 
    DEFINE l_imaa92_o     LIKE imaa_file.imaa92    
    DEFINE l_smyapr       LIKE smy_file.smyapr        
    DEFINE l_ima120       LIKE ima_file.ima120 
    
    IF s_shut(0) THEN 
       RETURN 
    END IF
    IF g_imaa.imaano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i009_set_entry('a')
    LET g_before_input_done = TRUE

    SELECT imaa92 INTO l_imaa92_o FROM imaa_file
     WHERE imaano = g_imaa.imaano     
 
    INPUT l_newno,l_newno00,l_newno01 FROM imaano,imaa00,imaa01

        AFTER FIELD imaa00                                                      
            IF cl_null(l_newno00) THEN                                      
                NEXT FIELD imaa00                                               
            END IF                                                              
                                                                                
        AFTER FIELD imaano                                                      
 
          IF NOT cl_null(g_imaa.imaano) THEN                                    
             LET l_n = 0                                                        
             SELECT COUNT(*) INTO l_n                                           
               FROM imaa_file                                                   
              WHERE imaano=l_newno                                      
             IF l_n > 0 THEN                                                    
                CALL cl_err('sel imaa:','-239',0)                               
                NEXT FIELD imaano                                               
             END IF                                                             
             LET g_t1=s_get_doc_no(l_newno)                               
             CALL s_check_no('aim',l_newno,"","Z","imaa_file","imaano","")
                  RETURNING li_result,l_newno                     
             IF (NOT li_result) THEN                                            
                  LET l_newno=l_oldno                             
                  NEXT FIELD imaano                                             
             END IF                                                             
             LET g_t1=l_newno[1,g_doc_len]                                
             CALL s_auto_assign_no("aim",l_newno,g_today,"Z","imaa_file","imaano","","","") RETURNING li_result,l_newno
             IF (NOT li_result) THEN
                 NEXT FIELD imaano 
              END IF
              DISPLAY l_newno TO imaano
             SELECT smyapr INTO l_smyapr FROM smy_file
              WHERE smyslip = g_t1
            END IF  
 
        BEFORE FIELD imaa01                                                     
            IF g_sma.sma60 = 'Y' THEN# 若須分段輸入                             
               CALL s_inp5(6,14,l_newno01) RETURNING l_newno01
               DISPLAY l_newno01 TO imaa01                             
            END IF                                                              
                                                                                
            IF l_newno00 = 'I' AND cl_null(l_newno01) THEN #新增且申請料
                IF g_aza.aza28 = 'Y' THEN                                       
                   CALL s_auno(l_newno01,'1','') RETURNING l_newno01,g_imaa.imaa02
                END IF                                                          
            END IF                                                              
         
        AFTER FIELD imaa01                                                      
            IF NOT cl_null(l_newno01) THEN                                  
               IF cl_null(l_oldno01) OR ( l_newno01!= l_oldno01) THEN
                  IF l_newno01[1,1] = ' ' THEN
                     CALL cl_err(l_newno01,"aim-671",0)
                     LET l_newno01 = l_oldno01            
                     DISPLAY BY NAME l_newno01                         
                     NEXT FIELD imaa01                                      
                  END IF
                  IF g_imaa.imaa00 = 'I' THEN #新增                             
                     #申請類別為新增時，依料件性質show不同訊息
                     SELECT count(*) INTO l_n FROM ima_file
                       WHERE ima01 = l_newno01
                     IF l_n > 0 THEN
                        SELECT ima120 INTO l_ima120 FROM ima_file 
                         WHERE ima01 = g_imaa.imaa01
                        IF l_ima120 = '1' THEN
                           CALL cl_err(g_imaa.imaa01,'aim-023',0)
                        ELSE
                           IF l_ima120 = '2' THEN
                              CALL cl_err(g_imaa.imaa01,'aim-024',0)
                           END IF
                       END IF
                       LET g_imaa.imaa01 = g_imaa_t.imaa01
                       DISPLAY BY NAME g_imaa.imaa01
                       NEXT FIELD imaa01
                     END IF
                     SELECT count(*) INTO l_n FROM imaa_file                   
                      WHERE imaa01 = l_newno01                   
                        AND imaa00 = 'I' #新增                                 
                     IF l_n > 0 THEN                                           
                        CALL cl_err(l_newno01,'-239',1)                      
                        LET l_newno01 = l_oldno01         
                        DISPLAY  l_newno01  TO imaa01                 
                        NEXT FIELD imaa01                                      
                     END IF          
                  ELSE                                                          
                     SELECT count(*) INTO l_n FROM ima_file                    
                      WHERE ima01 = l_newno01                       
                        AND (ima120 = '1' OR ima120 = NULL OR ima120 = ' ')
                     IF l_n <= 0 THEN                                          
                        #無此料件編號, 請重新輸入                              
                        CALL cl_err(l_newno01,'ams-003',1)
                        LET l_newno01 = l_oldno01        
                        DISPLAY l_newno01 TO imaa01            
                        NEXT FIELD imaa01                                      
                     END IF                                                    
                     LET l_imaano = NULL                                       
                     SELECT imaano INTO l_imaano FROM imaa_file                
                      WHERE imaa01 = l_newno01                             
                        AND imaa00 = 'U' #修改                                 
                        AND imaa1010 != '2'                                    
                        AND imaaacti != 'N'
                     IF NOT cl_null(l_imaano) THEN                             
                        #已存在一張相同料號,但未拋轉的料件申請單!              
                        CALL cl_err(l_imaano,'aim-150',1)                      
                        LET l_newno01 = l_oldno01                    
                        DISPLAY l_newno01 TO imaa01                        
                        NEXT FIELD imaa01                                      
                     END IF               
                  END IF                                                                                
               END IF                  
            ELSE                             
               IF l_newno00 <> 'I' THEN
                 CALL cl_err('','aim-157',0)     
                 NEXT FIELD imaa01             
               END IF
            END IF  
                                                                              
        ON ACTION controlp                                                      
           CASE                                                                
              WHEN INFIELD(imaano)                                             
                 CALL q_smy(FALSE,FALSE,g_t1,'AIM','Z') RETURNING g_t1         
                 LET l_newno = g_t1                                      
                 DISPLAY BY NAME l_newno                                 
                 NEXT FIELD imaano                                             
              WHEN INFIELD(imaa01) #料件編號                                   
                 IF g_imaa.imaa00='U' THEN                                   
                     #'U':修改時查ima01                                      
                     CALL cl_init_qry_var()                                  
                     LET g_qryparam.form = 'q_ima'                           
                     LET g_qryparam.where    = " ( ima120 = '1' OR ima120 IS NULL OR ima120 = ' ') "  #FUN-AB0011 add
                     LET g_qryparam.default1 = l_newno01                 
                     CALL cl_create_qry() RETURNING l_newno01            
                     DISPLAY BY NAME l_newno01                           
                     NEXT FIELD imaa01                                       
                 END IF       
              OTHERWISE EXIT CASE                                                 
           END CASE 

      AFTER INPUT
         IF l_newno00 <> 'I' AND cl_null(l_newno01)  THEN 
            NEXT FIELD imaa01
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
        DISPLAY BY NAME g_imaa.imaano
        RETURN
    END IF
    IF NOT cl_confirm('mfg-065') THEN RETURN END IF
    CALL cl_err('','aim-993','0')
    IF cl_null(l_newno01) THEN
       LET l_newno01 = ' ' 
    END IF   
   
    DROP TABLE x
    
    SELECT * FROM imaa_file WHERE  imaano = g_imaa.imaano INTO TEMP x
    
    UPDATE x 
      SET imaa00 = l_newno00,
          imaano = l_newno, 
          imaa01 = l_newno01,
          imaa571 = l_newno01,       
          imaa1010 = '0',  
          imaauser=g_user,    #資料所有者
          imaagrup=g_grup,    #資料所有者所屬群
          imaamodu=NULL,      #資料修改日期
          imaadate=g_today,   #資料建立日期
          imaaacti='Y'        #有效資料

   INSERT INTO imaa_file SELECT * FROM x
   IF l_imaa92_o = 'Y' AND l_smyapr = 'N' THEN 
      UPDATE imaa_file SET imaa92 = 'N' 
       WHERE imaano = l_newno
   END IF    
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_imaa.imaano,SQLCA.sqlcode,0)
   ELSE
      CALL s_zero(l_newno)            
 
      LET l_oldno = g_imaa.imaano
     
      SELECT imaa_file.* INTO g_imaa.* 
        FROM imaa_file
       WHERE imaano = l_newno
      CALL arti009_u('u')     
 
      #SELECT imaa_file.* INTO g_imaa.* FROM imaa_file #FUN-C80046
      # WHERE imaano = l_oldno                         #FUN-C80046
   END IF
   #LET g_imaa.imaano = l_oldno                        #FUN-C80046
   CALL arti009_show()
END FUNCTION

FUNCTION i009_imaa31()
   DEFINE l_gfeacti       LIKE gfe_file.gfeacti

   LET g_errno = ' '
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_imaa.imaa31
   
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1311'
        WHEN l_gfeacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i009_imaa44()
   DEFINE l_gfeacti       LIKE gfe_file.gfeacti

   LET g_errno = ' '
   SELECT gfeacti INTO l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_imaa.imaa44

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apm-047'
        WHEN l_gfeacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
FUNCTION i009_imaa54()
   DEFINE l_pmcacti       LIKE pmc_file.pmcacti

   LET g_errno = ' '
   SELECT pmcacti
     INTO l_pmcacti
     FROM pmc_file
    WHERE pmc01 = g_imaa.imaa54

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-031'
        WHEN l_pmcacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i009_imaa131()
   DEFINE l_obaacti       LIKE oba_file.obaacti

   LET g_errno = ' '
   SELECT obaacti
     INTO l_obaacti
     FROM oba_file
    WHERE oba01 = g_imaa.imaa131
      AND oba14 = 0

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aim-142'
        WHEN l_obaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION 

#FUN-D30006--add--str---
FUNCTION i009_imaa1030()
DEFINE l_rzhacti  LIKE rzh_file.rzhacti

   LET g_errno = ''
   SELECT rzhacti INTO l_rzhacti
     FROM rzh_file
    WHERE rzh01 = g_imaa.imaa1030
      AND rzh05 = 0

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'art1127'
      WHEN l_rzhacti = 'N'
         LET g_errno = 'art1128'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------------'
   END CASE
END FUNCTION
#FUN-D30006--add--end---


FUNCTION i009_imaa1004()
   DEFINE l_tqaacti       LIKE tqa_file.tqaacti

   LET g_errno = ' '
   SELECT tqaacti
     INTO l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_imaa.imaa1004
      AND tqa03 = '1'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-248'
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i009_imaa1005()
   DEFINE l_tqaacti       LIKE tqa_file.tqaacti

   LET g_errno = ' '
   SELECT tqaacti
     INTO l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_imaa.imaa1005
      AND tqa03 = '2'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-142'
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i009_imaa1006()
   DEFINE l_tqaacti       LIKE tqa_file.tqaacti

   LET g_errno = ' '
   SELECT tqaacti
     INTO l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_imaa.imaa1006
      AND tqa03 = '3'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-143'
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION


FUNCTION i009_imaa1007()
   DEFINE l_tqaacti       LIKE tqa_file.tqaacti

   LET g_errno = ' '
   SELECT tqaacti
     INTO l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_imaa.imaa1007
      AND tqa03 = '4'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-144'
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i009_imaa1008()
   DEFINE l_tqaacti       LIKE tqa_file.tqaacti

   LET g_errno = ' '
   SELECT tqaacti
     INTO l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_imaa.imaa1008
      AND tqa03 = '5'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-145'
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION


FUNCTION i009_imaa1009()
   DEFINE l_tqaacti       LIKE tqa_file.tqaacti

   LET g_errno = ' '
   SELECT tqaacti
     INTO l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_imaa.imaa1009
      AND tqa03 = '6'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-146'
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
FUNCTION i009_desc()
DEFINE l_imz02           LIKE imz_file.imz02
DEFINE l_oba02           LIKE oba_file.oba02
DEFINE l_imaa44_fac      LIKE imaa_file.imaa44_fac
DEFINE l_imaa31_fac      LIKE imaa_file.imaa31_fac

   SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = g_imaa.imaa06
   DISPLAY l_imz02 TO FORMONLY.imz02
   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_imaa.imaa131
   DISPLAY l_oba02 TO FORMONLY.oba02
END FUNCTION

FUNCTION i009_chk_imaa09()
   IF cl_null(g_imaa.imaa09) THEN
      RETURN TRUE
   END IF
   CALL s_field_chk(g_imaa.imaa109,'1',g_plant,'ima109') RETURNING g_flag
   IF g_flag = '0' THEN
      CALL cl_err(g_imaa.imaa109,'aoo-043',1)
      LET g_imaa.imaa109 = g_imaa_o.imaa109
      DISPLAY BY NAME g_imaa.imaa109
      RETURN FALSE
   END IF
   SELECT azf01 FROM azf_file
   WHERE azf01=g_imaa.imaa09 AND azf02='D' 
     AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa09,"","mfg1306","","",1)  
      LET g_imaa.imaa09 = g_imaa_o.imaa09
      DISPLAY BY NAME g_imaa.imaa09
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa10()
   IF cl_null(g_imaa.imaa10) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
   WHERE azf01=g_imaa.imaa10 AND azf02='E' 
     AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa10,"","mfg1306","","",1)  
      LET g_imaa.imaa10 = g_imaa_o.imaa10
      DISPLAY BY NAME g_imaa.imaa10
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa11()
   IF cl_null(g_imaa.imaa11) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
      WHERE azf01=g_imaa.imaa11 AND azf02='F'
        AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa11,"","mfg1306","","",1)
      LET g_imaa.imaa11 = g_imaa_o.imaa11
      DISPLAY BY NAME g_imaa.imaa11
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa12()
   IF cl_null(g_imaa.imaa12) THEN
      RETURN TRUE
   END IF
   SELECT azf01 FROM azf_file
      WHERE azf01=g_imaa.imaa12 AND azf02='G'
        AND azfacti='Y'
   IF SQLCA.sqlcode  THEN
      CALL cl_err3("sel","azf_file",g_imaa.imaa12,"","mfg1306","","",1)
      LET g_imaa.imaa12 = g_imaa_o.imaa12
      DISPLAY BY NAME g_imaa.imaa12
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa25()
   IF cl_null(g_imaa.imaa25) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
     WHERE gfe01=g_imaa.imaa25
       AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa25,"","mfg1200","","",1)  
      DISPLAY BY NAME g_imaa.imaa25
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa31()
   IF cl_null(g_imaa.imaa31) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
   WHERE gfe01=g_imaa.imaa31
     AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa31,"","mfg1311","","",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa39()
DEFINE l_cnt LIKE type_file.num10   

   IF cl_null(g_imaa.imaa39) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt 
     FROM aag_file
    WHERE aag01 = g_imaa.imaa39
      AND aag07 != '1'  
      AND aag00 = g_aza.aza81 
   IF l_cnt=0 THEN  
      CALL cl_err(g_imaa.imaa39,"anm-001",0) 
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION i009_chk_imaa149()
DEFINE l_cnt LIKE type_file.num10

   IF cl_null(g_imaa.imaa149) THEN
      RETURN TRUE
   END IF
   SELECT count(*) INTO l_cnt
     FROM aag_file
    WHERE aag01 = g_imaa.imaa149
      AND aag07 != '1'
      AND aag00 = g_aza.aza81
   IF l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa149,"anm-001",0)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa44()
   IF cl_null(g_imaa.imaa44) THEN
      RETURN TRUE
   END IF
   SELECT gfe01 FROM gfe_file
    WHERE gfe01=g_imaa.imaa44
      AND gfeacti IN ('y','Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfe_file",g_imaa.imaa44,"","apm-047","","",1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION i009_chk_imaa54()
DEFINE l_cnt LIKE type_file.num10 
   IF cl_null(g_imaa.imaa54) THEN
      RETURN TRUE
   END IF
   SELECT COUNT(*) INTO l_cnt FROM pmc_file
      WHERE pmc01 = g_imaa.imaa54
        AND pmcacti='Y'
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      CALL cl_err(g_imaa.imaa54,'mfg3001',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION

FUNCTION i009_chk_rel_imaa06(p_cmd)
DEFINE p_cmd LIKE type_file.chr1  
   IF NOT i009_chk_imaa09() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa10() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa11() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa12() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa25() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa31() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa39() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa44() THEN
      RETURN FALSE
   END IF
   IF NOT i009_chk_imaa54() THEN
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i009_show_pic()
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
 
FUNCTION i009_y_chk()
   DEFINE l_imaa01     LIKE imaa_file.imaa01
   DEFINE l_tqo01      LIKE tqo_file.tqo01 
   DEFINE l_tqk01      LIKE tqk_file.tqk01
   DEFINE l_n          LIKE type_file.num5    
   DEFINE p_cmd        LIKE type_file.chr1  
   LET g_success = 'Y'
 
   IF (g_imaa.imaano IS NULL) THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       RETURN 
   END IF
   IF g_imaa.imaaacti='N' THEN 
       #本筆資料無效
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_imaa.imaa1010='1' THEN
       #已核准
       CALL cl_err('','mfg3212',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_imaa.imaa1010='2' THEN
       #已拋轉，不可再異動!
       CALL cl_err(g_imaa.imaano,'axm-225',1)
       LET g_success = 'N'
       RETURN
   END IF
   IF NOT i009_chk_rel_imaa06(p_cmd) THEN                                                                                           
      #相關欄位控管                                                                                                                          
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
END FUNCTION
 
FUNCTION i009_y_upd()
DEFINE l_gew03   LIKE gew_file.gew03 
DEFINE l_gev04   LIKE gev_file.gev04

   LET g_success = 'Y'
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  
   THEN 
      IF g_imaa.imaa92='Y' THEN            #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF g_imaa.imaa1010 != '1' THEN
            #此狀況碼不為「1.已核准」，不可確認!!
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN RETURN END IF  #詢問是否執行確認功能
   END IF
 
  BEGIN WORK
  OPEN arti009_cl USING g_imaa.imaano                                            
  IF STATUS THEN                                                               
      CALL cl_err("OPEN arti009_cl:", STATUS, 1)                                  
      CLOSE arti009_cl                                                            
      ROLLBACK WORK                                                            
      RETURN                                                                   
  END IF                                                                       
  FETCH arti009_cl INTO g_imaa.*                                                
  IF SQLCA.sqlcode THEN                                                        
     CALL cl_err('',SQLCA.sqlcode,1)                                           
     RETURN                                                                    
  END IF                                     
  CALL arti009_show()
  LET g_chr = g_imaa.imaa1010
  UPDATE imaa_file 
     SET imaa1010='1' #1:已核准
   WHERE imaano = g_imaa.imaano
  IF SQLCA.SQLERRD[3]=0 THEN                                                 
      CALL cl_err3("upd","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  
      LET g_imaa.imaa1010=g_chr                                              
      DISPLAY BY NAME g_imaa.imaa1010
  END IF                                                                     
  CLOSE arti009_cl      
  COMMIT WORK
   SELECT * INTO g_imaa.* FROM imaa_file
    WHERE imaano = g_imaa.imaano
  CALL arti009_show()
  IF g_success='Y' THEN
     LET g_imaa.imaa1010='1'          #執行成功, 狀態值顯示為 '1' 已核准
     COMMIT WORK
     CALL cl_flow_notify(g_imaa.imaano,'Y')
     DISPLAY BY NAME g_imaa.imaa1010
  ELSE
     LET g_success = 'N'
     ROLLBACK WORK
  END IF
 
  SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
  CALL i009_show_pic() #圖示

  SELECT gev04 INTO l_gev04 FROM gev_file
   WHERE gev01 = '1' and gev02 = g_plant
  SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file 
   WHERE gew01 = l_gev04
     AND gew02 = '1'
  IF l_gew03 = '1' THEN
     IF cl_null(g_imaa.imaa01) THEN
        CALL cl_err(g_imaa.imaano,'aim-160','1')
     ELSE
        CALL i150_dbs(g_imaa.*)
        SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano 
        CALL arti009_show()  
     END IF
  END IF
END FUNCTION
 
FUNCTION i009_z()
   DEFINE l_imaa01 LIKE imaa_file.imaa01
    
   IF (g_imaa.imaano IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   IF g_imaa.imaaacti='N' THEN 
      #本筆資料無效
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
   IF g_imaa.imaa1010 = 'S' THEN
      #送簽中, 不可修改資料!
      CALL cl_err(g_imaa.imaano,'apm-030',1)
      RETURN
   END IF
   #非審核狀態 不能取消審核
   IF g_imaa.imaa1010 !='1' THEN
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF
   
   IF NOT cl_confirm('aim-302') THEN RETURN END IF    #是否確定執行取消確認(Y/N)?
   BEGIN WORK
 
   OPEN arti009_cl USING g_imaa.imaano                                            
   IF STATUS THEN                                                               
       CALL cl_err("OPEN arti009_cl:", STATUS, 1)                                  
       CLOSE arti009_cl                                                            
       ROLLBACK WORK                                                            
       RETURN                                                                   
   END IF                                                                       
   FETCH arti009_cl INTO g_imaa.*                                                
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err('',SQLCA.sqlcode,1)                                           
      RETURN                                                                    
   END IF                                     
   CALL arti009_show()
   LET g_chr=g_imaa.imaa1010
   UPDATE imaa_file 
      SET imaa1010='0' #0:開立
    WHERE imaano = g_imaa.imaano
   IF SQLCA.SQLERRD[3]=0 THEN                                                 
       CALL cl_err3("upd","imaa_file",g_imaa.imaano,"",SQLCA.sqlcode,"","",1)  
       LET g_imaa.imaa1010=g_chr                                              
       DISPLAY BY NAME g_imaa.imaa1010
   END IF                                                                     
   CLOSE arti009_cl     
   SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano
   COMMIT WORK
   CALL arti009_show()
END FUNCTION

FUNCTION i009_chk_imaaag()
   DEFINE l_cnt LIKE type_file.num5

   IF NOT cl_null(g_imaa.imaaag) THEN
      SELECT count(*) INTO l_cnt FROM aga_file
          WHERE aga01 = g_imaa.imaaag
      IF l_cnt <= 0 THEN
          CALL cl_err('','aim-910',1)
          RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION i009_imaa940(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_agc02  LIKE agc_file.agc02
   LET g_errno = ''
   SELECT agc02 INTO l_agc02 FROM agc_file WHERE agc01 = g_imaa.imaa940 AND agc07 = '1'
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "aim-070"
         LET l_agc02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION

FUNCTION i009_imaa941(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_agc02  LIKE agc_file.agc02
   LET g_errno = ''
   SELECT agc02 INTO l_agc02 FROM agc_file WHERE agc01 = g_imaa.imaa941 AND agc07 = '2'
   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = "aim-070"
         LET l_agc02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION

FUNCTION i009_insert310()
   DEFINE l_aga02   LIKE aga_file.aga02,
          l_agc021  LIKE agc_file.agc02,
          l_agc022  LIKE agc_file.agc02
   SELECT agc02 INTO l_agc021 FROM agc_file WHERE agc01 = g_imaa.imaa940 AND agc07 = '1'
   SELECT agc02 INTO l_agc022 FROM agc_file WHERE agc01 = g_imaa.imaa941 AND agc07 = '2'
   LET l_aga02 = l_agc021,"-",l_agc022
   INSERT INTO aga_file(aga01,aga02,agauser,agadate,agagrup,agaacti) VALUES(g_imaa.imaaag,l_aga02,g_user,g_today,g_grup,'Y')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","aga_file",g_imaa.imaaag,"",SQLCA.sqlcode,"","",1)
   ELSE
      MESSAGE "INSERT O.K"
   END IF
   INSERT INTO agb_file(agb01,agb02,agb03) VALUES(g_imaa.imaaag,'1',g_imaa.imaa940)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","agb_file",g_imaa.imaa940,"",SQLCA.sqlcode,"","",1)
   ELSE
      MESSAGE "INSERT O.K"
   END IF
   INSERT INTO agb_file(agb01,agb02,agb03) VALUES(g_imaa.imaaag,'2',g_imaa.imaa941)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","agb_file",g_imaa.imaa941,"",SQLCA.sqlcode,"","",1)
   ELSE
      MESSAGE "INSERT O.K"
   END IF
END FUNCTION

FUNCTION i009_produce_sub_parts()
   DEFINE l_sql1      STRING
   DEFINE l_sql2      STRING
   DEFINE l_msg       STRING
   DEFINE l_agd021    LIKE agd_file.agd02
   DEFINE l_agd022    LIKE agd_file.agd02
   DEFINE l_agd031    LIKE agd_file.agd03
   DEFINE l_agd032    LIKE agd_file.agd03
   DEFINE l_imaa02    LIKE imaa_file.imaa02
   DEFINE l_n1        LIKE type_file.num5
   DEFINE l_n2        LIKE type_file.num5
   DEFINE l_nt        LIKE type_file.num5
   DEFINE l_nt2       LIKE type_file.num5
   DEFINE l_cmd1      LIKE type_file.num5
   DEFINE l_cmd2      LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_imaa01_t  LIKE imaa_file.imaa01
   DEFINE l_imaa02_t  LIKE imaa_file.imaa02
   DEFINE l_imaa940_t LIKE imaa_file.imaa940
   DEFINE l_imaa941_t LIKE imaa_file.imaa941
   DEFINE l_confirm   LIKE ze_file.ze03
   DEFINE l_ps        LIKE sma_file.sma46
   DEFINE l_imaaag1   LIKE imaa_file.imaaag1
   DEFINE i           LIKE type_file.num5
   DEFINE l_imaano_str STRING
   DEFINE li_result    LIKE type_file.num5

      IF g_imaa.imaa1010 <> '1' AND g_imaa.imaa1010 <> '2' THEN   #審核後才可自動產生子料件
         CALL cl_err('','aap-717',0)
         RETURN
      END IF
      SELECT * INTO g_imaa.* FROM imaa_file WHERE imaa01 = g_imaa.imaa01
      LET l_imaa940_t = g_imaa.imaa940
      LET l_imaa941_t = g_imaa.imaa941
      LET l_imaa01_t  = g_imaa.imaa01
      LET l_imaaag1   = g_imaa.imaaag
      LET l_imaa02_t  = g_imaa.imaa02
      LET l_cmd1 = 1
      LET l_cmd2 = 1
      SELECT sma46 INTO l_ps FROM sma_file
      LET l_sql1 = "SELECT agd02,agd03 FROM agd_file WHERE agd01 ='",g_imaa.imaa940,"'"
      DECLARE i009_sub_cs1 CURSOR  FROM l_sql1
      LET l_sql2 = "SELECT agd02,agd03 FROM agd_file WHERE agd01 ='",g_imaa.imaa941,"'"
      DECLARE i009_sub_cs2 CURSOR  FROM l_sql2
      SELECT count(agd02) INTO l_n1 FROM agd_file WHERE agd01 = g_imaa.imaa940
      SELECT count(agd02) INTO l_n2 FROM agd_file WHERE agd01 = g_imaa.imaa941
      LET l_nt = 0
      LET l_nt2 = 0
      IF(l_n1 = 0 OR l_n2 = 0) THEN
         CALL cl_err('','aim1102',1)
      ELSE
        IF(cl_confirm('aim1101')) THEN
           FOREACH i009_sub_cs1 INTO l_agd021,l_agd031
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              FOREACH i009_sub_cs2 INTO l_agd022,l_agd032
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET l_imaano_str = g_imaa.imaano
              LET g_imaa.imaano = l_imaano_str.subString(1,l_imaano_str.getIndexOf('-',1)-1)
              CALL s_auto_assign_no("aim",g_imaa.imaano,g_imaa.imaadate,"Z","imaa_file","imaano","","","") RETURNING li_result,g_imaa.imaano
              IF (NOT li_result) OR cl_null(g_imaa.imaano) THEN
                 CONTINUE FOREACH
              END IF
              LET g_imaa.imaa01 = l_imaa01_t,l_ps,l_agd021,l_ps,l_agd022
              LET g_imaa.imaa02 = l_imaa02_t,l_ps,l_agd031,l_ps,l_agd032
              LET g_imaa.imaaag = '@CHILD'
              LET g_imaa.imaaag1 = l_imaaag1
              LET g_imaa.imaa151 = 'N'
              LET g_imaa.imaa120 = '1'
              LET g_imaa.imaa1010 = '1'
              LET g_imaa.imaa571=g_imaa.imaa01
              LET g_imaa.imaa94 = ''
              IF g_imaa.imaa151 = 'N' THEN
                 LET g_imaa.imaa940 = l_agd021
                 LET g_imaa.imaa941 = l_agd022
              END IF
              SELECT count(*) INTO l_n FROM imaa_file WHERE imaa01 = g_imaa.imaa01
              IF l_n = 0 THEN
                #IF cl_null(g_imaa.imaa156) THEN LET g_imaa.imaa156 = 'N' END IF
                #IF cl_null(g_imaa.imaa157) THEN LET g_imaa.imaa157 = ' ' END IF
                #IF cl_null(g_imaa.imaa158) THEN LET g_imaa.imaa158 = 'N' END IF
                #LET g_imaa.imaa927 = 'N'
                 IF cl_null(g_imaa.imaa912) THEN LET g_imaa.imaa912 =  0  END IF
                 IF cl_null(g_imaa.imaa159) THEN LET g_imaa.imaa159 = '3' END IF
                 INSERT INTO imaa_file VALUES(g_imaa.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","imaa_file",g_imaa.imaa01,"",SQLCA.sqlcode,"","",1)
                 ELSE
                    INSERT INTO imx_file(imx000,imx00,imx01,imx02)
                       VALUES(g_imaa.imaa01,l_imaa01_t,g_imaa.imaa940,g_imaa.imaa941)
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("ins","imx_file",g_imaa.imaa01,"",SQLCA.sqlcode,"","",1)
                       DELETE FROM imaa_file WHERE imaa01 = g_imaa.imaa01
                       CONTINUE FOREACH
                    ELSE
                       LET l_nt = l_nt + 1
                       MESSAGE "INSERT O.K"
                    END IF
                 END IF
              ELSE 
                 LET l_nt2 = l_nt2 + 1
              END IF
            END FOREACH
          END FOREACH 
          LET g_imaa.imaa01 = l_imaa01_t
          LET g_imaa.imaa02 = l_imaa02_t
          LET g_imaa.imaa151 = 'Y'
          LET g_imaa.imaa940 = l_imaa940_t
          LET g_imaa.imaa941 = l_imaa941_t
       END IF 
       CALL l_confirm2('aim1104','aim1105',l_nt,l_nt2)
     END IF   
END FUNCTION 

FUNCTION l_confirm2(ps_msg,ps_msg2,l_nt,l_nt2)
   DEFINE   ps_msg          STRING
   DEFINE   ps_msg2         STRING
   DEFINE   l_nt            LIKE type_file.num5
   DEFINE   l_nt2           LIKE type_file.num5
   DEFINE   ls_msg          LIKE type_file.chr1000
   DEFINE   ls_msg2         LIKE type_file.chr1000
   DEFINE   lc_msg          LIKE type_file.chr1000
   DEFINE   lc_msg2         LIKE type_file.chr1000 
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   lc_title        LIKE ze_file.ze03
                 
   WHENEVER ERROR CALL cl_err_msg_log
                 
   IF (cl_null(g_lang)) THEN 
      LET g_lang = "1"
   END IF           
   IF (cl_null(ps_msg)) THEN
      LET ps_msg = ""
   END IF              
                    
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF

   LET ls_msg = ps_msg.trim()
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
   LET ls_msg2 = ps_msg2.trim()
   SELECT ze03 INTO lc_msg2 FROM ze_file WHERE ze01 = ls_msg2 AND ze02 = g_lang
   IF NOT SQLCA.SQLCODE THEN
      LET ps_msg =lc_msg CLIPPED
      LET ps_msg2 =lc_msg2 CLIPPED
      LET ps_msg =l_nt2,ps_msg,l_nt,ps_msg2
   END IF

   LET li_result = FALSE

   LET lc_title=lc_title CLIPPED,'(',ls_msg,')','(',ls_msg2,')'

   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), imaGE="question")
      ON ACTION accept
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU

   END MENU

   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
   END IF
END FUNCTION

FUNCTION i009_upd_imaa()   # 回寫子料件某些欄位
   DEFINE l_imx000 LIKE imx_file.imx000 
   DEFINE l_imx01  LIKE imx_file.imx01
   DEFINE l_imx02  LIKE imx_file.imx02
   DEFINE l_imaa571 LIKE imaa_file.imaa571
   DEFINE l_imaa94  LIKE imaa_file.imaa94
   DEFINE l_imaaag  LIKE imaa_file.imaaag

   LET l_imx000=NULL
   LET l_imx01=NULL
   LET l_imx02=NULL
   LET l_imaa571=NULL
   LET l_imaa94=NULL
   LET l_imaaag=NULL
   SELECT imaaag INTO l_imaaag FROM imaa_file WHERE imaa01=g_imaa.imaa01
   DECLARE i009_upd CURSOR FOR
      SELECT imx000,imx01,imx02 FROM imx_file WHERE imx00=g_imaa.imaa01
   FOREACH i009_upd INTO l_imx000,l_imx01,l_imx02
      IF SQLCA.sqlcode  THEN
          EXIT FOREACH
      END IF
      LET l_imaa571= l_imx000
      LET l_imaa94 = ''
      UPDATE imaa_file SET imaa940=l_imx01,imaa941=l_imx02,imaa571=l_imx000,imaa94='',imaaag1=l_imaaag
        WHERE imaa01=l_imx000
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION

##自動拋轉子料件
#FUNCTION i009_dbs()
#DEFINE l_imaano     LIKE imaa_file.imaano
#DEFINE l_imaano_t   LIKE imaa_file.imaano
#DEFINE l_n          LIKE type_file.num5
#DEFINE l_hist_tab   LIKE type_file.chr50
#DEFINE l_count      LIKE type_file.num5
#DEFINE l_imaano_str STRING
#DEFINE tok          base.StringTokenizer
#
#   LET l_imaano_t = g_imaa.imaano #備份當前單號
#   SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx00 = g_imaa.imaa01
#   IF l_n = 0 THEN RETURN END IF
#
#   IF NOT cl_confirm("art1042") THEN RETURN END IF #是否自動拋轉該母料件下的子料件
#
#   LET g_gev04 = NULL
#   #是否為資料中心的拋轉DB
#   SELECT gev04 INTO g_gev04 FROM gev_file
#    WHERE gev01 = '1' AND gev02 = g_plant
#      AND gev03 = 'Y'
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_gev04,'aoo-036',0)
#      RETURN
#   END IF
#
#   LET g_success = 'Y'
#   LET g_sql = "SELECT * ",
#               "  FROM imaa_file ",
#               " WHERE imaa01 IN (SELECT imx000 ",
#               "                    FROM imx_file ",
#               "                   WHERE imx00 = '",g_imaa.imaa01,"' )",
#               " ORDER BY imaano "
#   PREPARE sel_imaa_pre FROM g_sql
#   DECLARE sel_imaa_cs CURSOR FOR sel_imaa_pre
#   FOREACH sel_imaa_cs INTO g_imaa.*
#      IF STATUS THEN
#         CALL cl_err('foreach:',STATUS,1)
#         RETURN
#      END IF
#
#      IF g_imaa.imaa1010='2' THEN
#         #已拋轉，不可再異動!
#         CALL cl_err('','axm-225',1)
#         RETURN
#      END IF
#
#      IF g_imaa.imaa1010!='1' THEN
#         #不在確認狀態，不可異動！
#         CALL cl_err('','atm-053',1)
#         RETURN
#      END IF
#
#      IF NOT cl_null(l_imaano_str) THEN
#         LET l_imaano_str = l_imaano_str CLIPPED,"|",g_imaa.imaano CLIPPED
#      ELSE
#         LET l_imaano_str = g_imaa.imaano CLIPPED
#      END IF
#   END FOREACH
#
#   LET tok = base.StringTokenizer.create(l_imaano_str,"|")
#   WHILE tok.hasMoreTokens()
#      LET l_imaano = tok.nextToken()
#      SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = l_imaano
#      CALL i150_dbs(g_imaa.*)
#      SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano
#      IF g_imaa.imaa1010 <> '2' THEN
#         LET g_success = 'N'
#         EXIT WHILE
#      END IF
#   END WHILE
#
#   IF g_success = 'Y' THEN
#      CALL cl_err('','art1043',0) #自動拋轉子料件成功
#   ELSE
#      CALL cl_err('','art1044',0) #自動拋轉子料件失敗
#   END IF
#
#   SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = l_imaano_t
#END FUNCTION

#FUN-BC0076



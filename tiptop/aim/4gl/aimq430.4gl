# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimq430.4gl
# Descriptions...: 特性主料庫存明細查詢
# Date & Author..: No.FUN-C70068 12/07/18 By bart 

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD
                 wc       STRING,   
                 wc2      STRING
              END RECORD,
       g_ima  RECORD
                 ima01    LIKE ima_file.ima01,
                 ima02    LIKE ima_file.ima02,
                 ima021   LIKE ima_file.ima021,
                 ima25    LIKE ima_file.ima25
              END RECORD,
       g_img  DYNAMIC ARRAY OF RECORD
                 ima01    LIKE ima_file.ima01,
                 ima02    LIKE ima_file.ima02,
                 ima021   LIKE ima_file.ima021,
                 img02    LIKE img_file.img02,   #倉庫編號 
                 img03    LIKE img_file.img03,   #儲位  
                 img04    LIKE img_file.img04,   #批號  
                 img23    LIKE img_file.img23,   #是否為可用倉庫
                 img09    LIKE img_file.img09,   #庫存單位
                 img10    LIKE img_file.img10,   #庫存數量
                 at01     LIKE inj_file.inj04,
                 at02     LIKE inj_file.inj04,
                 at03     LIKE inj_file.inj04,
                 at04     LIKE inj_file.inj04,
                 at05     LIKE inj_file.inj04,
                 at06     LIKE inj_file.inj04,
                 at07     LIKE inj_file.inj04,
                 at08     LIKE inj_file.inj04,
                 at09     LIKE inj_file.inj04,
                 at10     LIKE inj_file.inj04 
              END RECORD,
       g_imgs DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                 ima01    LIKE ima_file.ima01,
                 ima02    LIKE ima_file.ima02,
                 ima021   LIKE ima_file.ima021,
                 imgs02   LIKE imgs_file.imgs02,
                 imgs03   LIKE imgs_file.imgs03,
                 imgs04   LIKE imgs_file.imgs04,
                 imgs06   LIKE imgs_file.imgs06,
                 imgs05   LIKE imgs_file.imgs05,
                 imgs09   LIKE imgs_file.imgs09,
                 imgs07   LIKE imgs_file.imgs07,
                 imgs08   LIKE imgs_file.imgs08,
                 imgs10   LIKE imgs_file.imgs10,
                 imgs11   LIKE imgs_file.imgs11, 
                 att01    LIKE inj_file.inj04,
                 att02    LIKE inj_file.inj04,
                 att03    LIKE inj_file.inj04,
                 att04    LIKE inj_file.inj04,
                 att05    LIKE inj_file.inj04,
                 att06    LIKE inj_file.inj04,
                 att07    LIKE inj_file.inj04,
                 att08    LIKE inj_file.inj04,
                 att09    LIKE inj_file.inj04,
                 att10    LIKE inj_file.inj04                
              END RECORD
DEFINE g_sql              STRING  
DEFINE g_msg              STRING 
DEFINE g_cnt              LIKE type_file.num5
DEFINE lc_qbe_sn          LIKE gbm_file.gbm01 
DEFINE g_row_count        LIKE type_file.num10   
DEFINE g_curs_index       LIKE type_file.num10  
DEFINE g_no_ask           LIKE type_file.num5
DEFINE g_jump             LIKE type_file.num10
DEFINE g_rec_b            LIKE type_file.num5
DEFINE g_rec_b1           LIKE type_file.num5
DEFINE l_ac               LIKE type_file.num5

MAIN
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q430_w AT 6,3
        WITH FORM "aim/42f/aimq430"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible('at01,at02,at03,at04,at05,at06,at07,at08,at09,at10',FALSE)
   CALL cl_set_comp_visible('att01,att02,att03,att04,att05,att06,att07,att08,att09,att10',FALSE)

   CALL q430_menu()
   CLOSE WINDOW q430_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q430_cs()
 
   CLEAR FORM                                   #清除畫面
   CALL g_img.clear()
   CALL g_imgs.clear()
   CALL cl_opmsg('q')                           # 螢幕上取單頭條件
   
   INITIALIZE g_ima.* TO NULL        
   CALL cl_set_head_visible("","YES")
   CONSTRUCT tm.wc ON a.ima01,a.ima02,a.ima021,a.ima25 
                 FROM ima01_h,ima02_h,ima021_h,ima25_h

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
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ima01_h)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imz929_1"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01_h
               NEXT FIELD ima01_h
            WHEN INFIELD(ima25_h)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima25_h
               NEXT FIELD ima25_h
         END CASE

      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)

      #ON ACTION qbe_select
      #   CALL cl_qbe_select()
         
      #ON ACTION qbe_save
	  #	 CALL cl_qbe_save()

   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   CALL q430_b_askkey()
   IF INT_FLAG THEN RETURN END IF
   MESSAGE ' WAIT '
   
   IF tm.wc2=' 1=1' OR tm.wc2 IS NULL THEN
      LET g_sql=" SELECT UNIQUE a.ima01 FROM ima_file a ",
                " WHERE ",tm.wc CLIPPED,
                "   AND a.imaacti='Y'", 
                "   AND a.ima928='Y' "
    ELSE
      LET g_sql=" SELECT UNIQUE a.ima01 ",
                "  FROM ima_file a,img_file,ima_file b ",
                " WHERE b.ima01=img_file.img01 AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND a.ima01 = b.ima929 ",
                "   AND img10<>0", 
                "   AND a.imaacti='Y'", 
                "   AND a.ima928='Y' " 
   END IF

   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q430_prepare FROM g_sql
   DECLARE q430_cs SCROLL CURSOR FOR q430_prepare
   
   IF tm.wc2=' 1=1' OR tm.wc2 IS NULL THEN
      LET g_sql=" SELECT COUNT(*) FROM ima_file a ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND a.imaacti='Y'", 
                 "   AND a.ima928='Y' " 
    ELSE
      LET g_sql = " SELECT COUNT(DISTINCT a.ima01) FROM ima_file a,img_file,ima_file b ",
                  " WHERE b.ima01=img_file.img01 AND ",tm.wc CLIPPED,
                  "   AND a.ima01 = b.ima929 ",
                  "   AND a.imaacti='Y'",
                  "   AND a.ima928='Y' ", 
                  "   AND ",tm.wc2 CLIPPED,
                  "   AND img10<>0" 
   END IF
   PREPARE q430_pp  FROM g_sql
   DECLARE q430_cnt   CURSOR FOR q430_pp
END FUNCTION
 
FUNCTION q430_b_askkey()
   CONSTRUCT tm.wc2 ON b.ima01,img02,img03,img04,img23,img09,img10
                  FROM s_img[1].ima01,s_img[1].img02,s_img[1].img03,s_img[1].img04,
                       s_img[1].img23,s_img[1].img09,s_img[1].img10
             
      BEFORE CONSTRUCT
         #CALL cl_qbe_init()
         CALL cl_qbe_display_condition(lc_qbe_sn)
             
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    

      ON ACTION controlp
         CASE
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima01_10"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            WHEN INFIELD(img09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO img09
               NEXT FIELD img09
         END CASE
 
      #ON ACTION qbe_select
      #   CALL cl_qbe_select()
         
      ON ACTION qbe_save
		 CALL cl_qbe_save()

   END CONSTRUCT
END FUNCTION
 
FUNCTION q430_menu()
 
   WHILE TRUE
      CALL q430_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q430_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
         WHEN "query_lot_data"  #查詢批/序號資料
            #LET l_ac = ARR_CURR()
            IF l_ac > 0 THEN
               CALL q430_q_imgs()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q430_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q430_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q430_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q430_cnt
       FETCH q430_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q430_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION

FUNCTION q430_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    
    l_abso          LIKE type_file.num10     #絕對的筆數  
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q430_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q430_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q430_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q430_cs INTO g_ima.ima01
        WHEN '/'

            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about        
                     CALL cl_about()      
 
                  ON ACTION help         
                     CALL cl_show_help()  
 
                  ON ACTION controlg    
                     CALL cl_cmdask()     
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q430_cs INTO g_ima.ima01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL 
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
	SELECT ima01,ima02,ima021,ima25 INTO g_ima.* FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  
       RETURN
    END IF
 
    CALL q430_show()
END FUNCTION
 
FUNCTION q430_show()
    DISPLAY g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25
         TO ima01_h,ima02_h,ima021_h,ima25_h
 
    CALL q430_b_fill() #單身
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION q430_b_fill()              #BODY FILL UP
    DEFINE l_sql                STRING 
    DEFINE ls_show              STRING
    DEFINE ls_hide              STRING
    DEFINE lc_index             STRING
    DEFINE li_i                 LIKE type_file.num5
    DEFINE li_j                 LIKE type_file.num5
    DEFINE l_inj04              LIKE inj_file.inj04
    DEFINE l_imac DYNAMIC ARRAY OF RECORD
                     imac04     LIKE imac_file.imac04,
                     ini02      LIKE ini_file.ini02
                   END RECORD
    DEFINE l_inj03 DYNAMIC ARRAY OF RECORD
                     inj03      LIKE inj_file.inj03,
                     ini02      LIKE ini_file.ini02
                   END RECORD
                   
    IF tm.wc2 IS NULL OR tm.wc2=' ' THEN LET tm.wc2=" 1=1" END IF
    LET l_sql =
        "SELECT ima01,ima02,ima021,img02,img03,img04,img23,img09,img10,''",  
        " FROM  img_file,ima_file b",
        " WHERE img01 = b.ima01 ",
        "   AND b.ima929 = '",g_ima.ima01,"'",
        "   AND img10<>0",
        "   AND ",tm.wc2, 
        " ORDER BY b.ima01,img02,img03,img04"
    PREPARE q430_pb FROM l_sql
    DECLARE q430_bcs CURSOR FOR q430_pb
    
    CALL g_img.clear()
    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH q430_bcs INTO g_img[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       DECLARE imac_cs  CURSOR FOR 
                      SELECT DISTINCT imac04,'' FROM imac_file
                       WHERE imac01 = g_img[g_cnt].ima01
                         AND imac03 = '1'
       #依料件特性資料動態顯示隱藏欄位名稱及內容
       LET ls_hide = ' '
       LET ls_show = ' '
       CALL l_imac.clear()
       LET li_i    = 1
       FOREACH imac_cs INTO l_imac[li_i].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF       

          SELECT ini02 INTO l_imac[li_i].ini02 FROM ini_file     
           WHERE ini01 = l_imac[li_i].imac04
          LET lc_index = li_i USING '&&'
          CALL cl_set_comp_att_text("at" || lc_index,l_imac[li_i].ini02)
          IF li_i = 1 THEN
             LET  ls_show = ls_show || "at" || lc_index
          ELSE
             LET  ls_show = ls_show || ",at" || lc_index
          END IF
          LET li_i = li_i + 1
       END FOREACH 
       CALL l_imac.deleteElement(li_i)
       IF li_i > 1 THEN 
          LET li_i = li_i - 1
       END IF 
       FOR li_j = li_i TO 10
          LET lc_index = li_j USING '&&'
          IF li_j = li_i THEN
             LET ls_hide = ls_hide || "at" || lc_index
          ELSE
             LET ls_hide = ls_hide || ",at" || lc_index
          END IF
       END FOR     
       CALL cl_set_comp_visible(ls_hide,FALSE)
       CALL cl_set_comp_visible(ls_show,TRUE)
        
        FOR li_j = 1 TO li_i
          LET l_inj04 = NULL
          SELECT imac05 INTO l_inj04 FROM imac_file
           WHERE imac01 = g_img[g_cnt].ima01
             AND imac03 = '1'
             AND imac04 = l_imac[li_j].imac04

            CASE li_j
               WHEN 1
                  LET g_img[g_cnt].at01 = l_inj04
               WHEN 2
                  LET g_img[g_cnt].at02 = l_inj04
               WHEN 3
                  LET g_img[g_cnt].at03 = l_inj04
               WHEN 4
                  LET g_img[g_cnt].at04 = l_inj04
               WHEN 5
                  LET g_img[g_cnt].at05 = l_inj04
               WHEN 6
                  LET g_img[g_cnt].at06 = l_inj04
               WHEN 7
                  LET g_img[g_cnt].at07 = l_inj04
               WHEN 8
                  LET g_img[g_cnt].at08 = l_inj04
               WHEN 9
                  LET g_img[g_cnt].at09 = l_inj04
               WHEN 10
                  LET g_img[g_cnt].at10 = l_inj04
            END CASE
        END FOR
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
       END IF
    END FOREACH
    CALL g_img.deleteElement(g_cnt)
    IF g_cnt = 1 THEN
       FOR li_j = 1 TO 10
          LET lc_index = li_j USING '&&'
          IF li_j = 1 THEN
             LET ls_hide = ls_hide , "at" , lc_index
          ELSE
             LET ls_hide = ls_hide , ",at" , lc_index
          END IF
       END FOR     
       CALL cl_set_comp_visible(ls_hide,FALSE)
    END IF 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    
    LET g_sql = " SELECT ima01,ima02,ima021,imgs02,imgs03,imgs04,imgs06,imgs05,imgs09,imgs07,",
                "  imgs08,imgs10,imgs11,'','','','','','','','','',''",
                "  FROM imgs_file,ima_file b,img_file ",
                "  WHERE imgs01 = b.ima01 ",
                "  AND imgs01 = img01",
                "  AND imgs02 = img02",
                "  AND imgs03 = img03",
                "  AND imgs04 = img04",
                "  AND b.ima929 = '",g_ima.ima01,"' ",
                "  AND imgs08<>0",
                "  AND ",tm.wc2, 
                "  ORDER BY b.ima01,imgs02,imgs03,imgs04 "
    PREPARE sel_imgs_pre FROM g_sql
    DECLARE imgs_curs CURSOR FOR sel_imgs_pre

    CALL g_imgs.clear()

    LET g_cnt = 1
    FOREACH imgs_curs INTO g_imgs[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

       DECLARE inj_cs1  CURSOR FOR 
                      SELECT DISTINCT inj03,'' FROM inj_file
                       WHERE inj01 = g_imgs[g_cnt].ima01
       #依料件特性資料動態顯示隱藏欄位名稱及內容
       LET ls_hide = ' '
       LET ls_show = ' '
       CALL l_inj03.clear()
       LET li_i    = 1
       FOREACH inj_cs1 INTO l_inj03[li_i].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF       

          SELECT ini02 INTO l_inj03[li_i].ini02 FROM ini_file     
           WHERE ini01 = l_inj03[li_i].inj03
          LET lc_index = li_i USING '&&'
          CALL cl_set_comp_att_text("att" || lc_index,l_inj03[li_i].ini02)
          IF li_i = 1 THEN
             LET  ls_show = ls_show || "att" || lc_index
          ELSE
             LET  ls_show = ls_show || ",att" || lc_index
          END IF
          LET li_i = li_i + 1
       END FOREACH 
       CALL l_inj03.deleteElement(li_i)
       IF li_i > 1 THEN 
          LET li_i = li_i - 1
       END IF 
       FOR li_j = li_i TO 10
          LET lc_index = li_j USING '&&'
          IF li_j = li_i THEN
             LET ls_hide = ls_hide || "att" || lc_index
          ELSE
             LET ls_hide = ls_hide || ",att" || lc_index
          END IF
       END FOR     
       CALL cl_set_comp_visible(ls_hide,FALSE)
       CALL cl_set_comp_visible(ls_show,TRUE)
        
        FOR li_j = 1 TO li_i
          LET l_inj04 = NULL
          SELECT inj04 INTO l_inj04 FROM inj_file
           WHERE inj01 = g_imgs[g_cnt].ima01
             AND inj02 = g_imgs[g_cnt].imgs06
             AND inj03 = l_inj03[li_j].inj03

            CASE li_j
               WHEN 1
                  LET g_imgs[g_cnt].att01 = l_inj04
               WHEN 2
                  LET g_imgs[g_cnt].att02 = l_inj04
               WHEN 3
                  LET g_imgs[g_cnt].att03 = l_inj04
               WHEN 4
                  LET g_imgs[g_cnt].att04 = l_inj04
               WHEN 5
                  LET g_imgs[g_cnt].att05 = l_inj04
               WHEN 6
                  LET g_imgs[g_cnt].att06 = l_inj04
               WHEN 7
                  LET g_imgs[g_cnt].att07 = l_inj04
               WHEN 8
                  LET g_imgs[g_cnt].att08 = l_inj04
               WHEN 9
                  LET g_imgs[g_cnt].att09 = l_inj04
               WHEN 10
                  LET g_imgs[g_cnt].att10 = l_inj04
            END CASE
        END FOR
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_imgs.deleteElement(g_cnt)
    IF g_cnt = 1 THEN
       FOR li_j = 1 TO 10
          LET lc_index = li_j USING '&&'
          IF li_j = 1 THEN
             LET ls_hide = ls_hide , "att" , lc_index
          ELSE
             LET ls_hide = ls_hide , ",att" , lc_index
          END IF
       END FOR     
       CALL cl_set_comp_visible(ls_hide,FALSE)
    END IF 
END FUNCTION

FUNCTION q430_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
   
      DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b)  
   
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                  

         AFTER DISPLAY 
            CONTINUE DIALOG 
      END DISPLAY

      DISPLAY ARRAY g_imgs TO s_imgs.* ATTRIBUTE(COUNT=g_rec_b1)
      
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                 

         AFTER DISPLAY 
            CONTINUE DIALOG 
      END DISPLAY
            
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
         
      ON ACTION first
         CALL q430_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DIALOG 
         EXIT DIALOG           
 
      ON ACTION previous
         CALL q430_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DIALOG                  
         EXIT DIALOG 
 
      ON ACTION jump
         CALL q430_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	     ACCEPT DIALOG                  
         EXIT DIALOG                  
 
      ON ACTION next
         CALL q430_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DIALOG                  
         EXIT DIALOG                
 
      ON ACTION last
         CALL q430_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	     ACCEPT DIALOG                  
         EXIT DIALOG                    
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG 
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 

      ON ACTION query_lot_data  #查詢批/序號資料
         LET g_action_choice = 'query_lot_data'
         EXIT DIALOG
                                                                                        
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q430_q_imgs()
   DEFINE l_imgs01  LIKE imgs_file.imgs01
   DEFINE l_imgs02  LIKE imgs_file.imgs02
   DEFINE l_imgs03  LIKE imgs_file.imgs03
   DEFINE l_imgs04  LIKE imgs_file.imgs04
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_imgs DYNAMIC ARRAY OF RECORD
                    imgs05   LIKE imgs_file.imgs05,
                    imgs06   LIKE imgs_file.imgs06,
                    imgs07   LIKE imgs_file.imgs07,
                    imgs08   LIKE imgs_file.imgs08,
                    imgs09   LIKE imgs_file.imgs09,
                    imgs10   LIKE imgs_file.imgs10,
                    imgs11   LIKE imgs_file.imgs11,
                    att01    LIKE inj_file.inj04,
                    att02    LIKE inj_file.inj04,
                    att03    LIKE inj_file.inj04,
                    att04    LIKE inj_file.inj04,
                    att05    LIKE inj_file.inj04,
                    att06    LIKE inj_file.inj04,
                    att07    LIKE inj_file.inj04,
                    att08    LIKE inj_file.inj04,
                    att09    LIKE inj_file.inj04,
                    att10    LIKE inj_file.inj04
                 END RECORD
   DEFINE l_inj03 DYNAMIC ARRAY OF RECORD
                    inj03      LIKE inj_file.inj03,
                    ini02      LIKE ini_file.ini02
                  END RECORD
  DEFINE li_i, li_j            LIKE type_file.num5
  DEFINE lc_index                     STRING
  DEFINE ls_show,ls_hide              STRING
  DEFINE l_inj04               LIKE inj_file.inj04
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = g_img[l_ac].ima01
   
   IF cl_null(l_ima918) THEN
      LET l_ima918="N"
   END IF
 
   IF cl_null(l_ima921) THEN
      LET l_ima921="N"
   END IF
 
   IF l_ima918 <> "Y" AND l_ima921 <> "Y" THEN
      RETURN
   END IF
 
   OPEN WINDOW q430_q_imgs_w AT 6,2 WITH FORM "aim/42f/aimq1026"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aimq1026")
   CALL cl_set_act_visible("cancel", FALSE)
 
   DISPLAY g_img[l_ac].ima01,g_img[l_ac].img02,g_img[l_ac].img03,g_img[l_ac].img04 
        TO imgs01,imgs02,imgs03,imgs04 
 
   DECLARE q430_q_imgs_c CURSOR FOR SELECT imgs05,imgs06,imgs07,imgs08,
                                           imgs09,imgs10,imgs11
                                           ,'','','','',''
                                           ,'','','','',''
                                      FROM imgs_file
                                     WHERE imgs01 = g_img[l_ac].ima01
                                       AND imgs02 = g_img[l_ac].img02
                                       AND imgs03 = g_img[l_ac].img03
                                       AND imgs04 = g_img[l_ac].img04
                                       AND imgs08 > 0
                                     ORDER BY imgs05,imgs06 
 
   CALL l_imgs.clear()
 
   LET g_cnt=1
 
   DECLARE inj_curs  CURSOR FOR 
                  SELECT DISTINCT inj03,'' FROM inj_file
                   WHERE inj01 = g_img[l_ac].ima01
   #依料件特性資料動態顯示隱藏欄位名稱及內容
   LET ls_hide = ' '
   LET ls_show = ' '
   LET li_i    = 1
   FOREACH inj_curs INTO l_inj03[li_i].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF       

      SELECT ini02 INTO l_inj03[li_i].ini02 FROM ini_file     
       WHERE ini01 = l_inj03[li_i].inj03
      LET lc_index = li_i USING '&&'
      CALL cl_set_comp_att_text("att" || lc_index,l_inj03[li_i].ini02)
      IF li_i = 1 THEN
         LET  ls_show = ls_show || "att" || lc_index
      ELSE
         LET  ls_show = ls_show || ",att" || lc_index
      END IF
      LET li_i = li_i + 1
   END FOREACH 
   CALL l_inj03.deleteElement(li_i)
   LET li_i = li_i - 1
   FOR li_j = li_i TO 10
       LET lc_index = li_j USING '&&'
       IF li_j = li_i THEN
          LET ls_hide = ls_hide || "att" || lc_index
       ELSE
          LET ls_hide = ls_hide || ",att" || lc_index
       END IF
   END FOR      
   CALL cl_set_comp_visible(ls_hide,FALSE)
   CALL cl_set_comp_visible(ls_show,TRUE)

   FOREACH q430_q_imgs_c INTO l_imgs[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach imgs:',STATUS,1)
         EXIT FOREACH
      END IF

      FOR li_j = 1 TO li_i
          LET l_inj04 = NULL
          SELECT inj04 INTO l_inj04 FROM inj_file
           WHERE inj01 = g_img[l_ac].ima01
             AND inj02 = l_imgs[g_cnt].imgs06
             AND inj03 = l_inj03[li_j].inj03

            CASE li_j
               WHEN 1
                  LET l_imgs[g_cnt].att01 = l_inj04
               WHEN 2
                  LET l_imgs[g_cnt].att02 = l_inj04
               WHEN 3
                  LET l_imgs[g_cnt].att03 = l_inj04
               WHEN 4
                  LET l_imgs[g_cnt].att04 = l_inj04
               WHEN 5
                  LET l_imgs[g_cnt].att05 = l_inj04
               WHEN 6
                  LET l_imgs[g_cnt].att06 = l_inj04
               WHEN 7
                  LET l_imgs[g_cnt].att07 = l_inj04
               WHEN 8
                  LET l_imgs[g_cnt].att08 = l_inj04
               WHEN 9
                  LET l_imgs[g_cnt].att09 = l_inj04
               WHEN 10
                  LET l_imgs[g_cnt].att10 = l_inj04
            END CASE
         END FOR
      LET g_cnt=g_cnt+1
 
   END FOREACH
 
   DISPLAY ARRAY l_imgs TO s_imgs.*
 
      BEFORE ROW                                                                                                                    
         #LET l_ac = ARR_CURR()                                                                                                      
         CALL cl_show_fld_cont() 
 
      #ON ACTION detail                                                                                                              
      #   LET g_action_choice="detail"                                                                                               
      #   LET l_ac = 1                                                                                                               
      #   CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
      #   LET g_action_choice="detail"                                                                                               
      #    LET l_ac = ARR_CURR()                                                                                                      
          EXIT DISPLAY    
                                                                                                                                    
      #ON ACTION CANCEL                                                                                                              
      #   LET INT_FLAG=FALSE  
      #   LET g_action_choice="exit"                                                                                                 
      #   EXIT DISPLAY
         
      ON ACTION EXIT
         #LET g_action_choice="exit"
         EXIT DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      AFTER DISPLAY 
         CONTINUE DISPLAY 
 
   END DISPLAY 
 
   CLOSE WINDOW q430_q_imgs_w
 
END FUNCTION
#FUN-C70068

# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri095.4gl
# Descriptions...: 
# Date & Author..: 08/06/13 by zhangbo


DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE  g_hrdy    RECORD LIKE hrdy_file.*
DEFINE  g_hrdy_t  RECORD LIKE hrdy_file.*
DEFINE  g_hrdya   DYNAMIC ARRAY OF RECORD
          hrdya03    LIKE   hrdya_file.hrdya03,
          hrdya04    LIKE   hrdya_file.hrdya04,
          hrdya05    LIKE   hrdya_file.hrdya05,
          hrdya06    LIKE   hrdya_file.hrdya06
                  END RECORD,
        g_rec_b,l_ac LIKE   type_file.num5
DEFINE g_hrdya_t  RECORD
          hrdya03    LIKE   hrdya_file.hrdya03,
          hrdya04    LIKE   hrdya_file.hrdya04,
          hrdya05    LIKE   hrdya_file.hrdya05,
          hrdya06    LIKE   hrdya_file.hrdya06
                  END RECORD
DEFINE  g_hrdy_b  DYNAMIC ARRAY OF RECORD
          hrdy01     LIKE   hrdy_file.hrdy01,
          hrat02     LIKE   hrat_file.hrat02,
          hrdy02     LIKE   hrdy_file.hrdy02,
          hrdy03     LIKE   hraa_file.hraa12,
          hrdy04     LIKE   hrdy_file.hrdy04,
          hrdy05     LIKE   hrdy_file.hrdy05,
          hrdy06     LIKE   hrdy_file.hrdy06,
          hrdy07     LIKE   hrdy_file.hrdy07,
          hrdy08     LIKE   hrdy_file.hrdy08,
          hrdy09     LIKE   hrdy_file.hrdy09,
          hrdy10     LIKE   hrdy_file.hrdy10
                  END RECORD,
        g_rec_b1,l_ac1 LIKE type_file.num5           
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_wc   STRING
DEFINE  g_sql  STRING
DEFINE  g_row_count  LIKE type_file.num5
DEFINE  g_curs_index LIKE type_file.num5
DEFINE  g_jump       LIKE type_file.num10
DEFINE  g_no_ask     LIKE type_file.num5
DEFINE  g_str        STRING
DEFINE  g_msg        LIKE type_file.chr1000
DEFINE  g_chr        LIKE type_file.chr1
DEFINE  g_flag       LIKE type_file.chr1
DEFINE  g_bp_flag    LIKE type_file.chr1 

MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    DEFINE l_name   STRING
    DEFINE l_items  STRING

    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   INITIALIZE g_hrdy.* TO NULL
   

   LET g_forupd_sql = "SELECT * FROM hrdy_file WHERE hrdy01 = ? AND hrdy02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i095_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i095_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri095"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   CALL cl_set_combo_items("hrdy02",NULL,NULL)
   
   #财年
   CALL i095_get_hrdy02() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdy02",l_name,l_items)   
  
   LET g_action_choice=""
   CALL i095_menu()
 
   CLOSE WINDOW i095_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i095_get_hrdy02()
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrac01     LIKE   hrac_file.hrac01
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  ORDER BY hrac01"
       PREPARE i095_get_hrdy02_pre FROM l_sql
       DECLARE i095_get_hrdy02 CURSOR FOR i095_get_hrdy02_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i095_get_hrdy02 INTO l_hrac01
             		       		 
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrac01
            LET l_items=l_hrac01
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrac01 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrac01 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items

END FUNCTION
	 

FUNCTION i095_curs()

    CLEAR FORM
    CALL g_hrdya.clear()
    CALL g_hrdy_b.clear()
    INITIALIZE g_hrdy.* TO NULL
    
    CONSTRUCT BY NAME g_wc ON                              
        hrdy01,hrdy04,hrdy02,hrdy07,hrdy05,hrdy06,hrdy08,hrdy09,hrdy10,
        hrdyuser,hrdygrup,hrdymodu,hrdydate,hrdyacti,hrdyoriu,hrdyorig

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrdy01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdy.hrdy01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdy01
                 NEXT FIELD hrdy01
                 
              WHEN INFIELD(hrdy04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdy.hrdy04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdy04
                 NEXT FIELD hrdy04

              OTHERWISE
                 EXIT CASE
           END CASE

      ON IDLE g_idle_seconds                                #
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about                                       #
         CALL cl_about()

      ON ACTION help                                        #
         CALL cl_show_help()

      ON ACTION controlg                                    #
         CALL cl_cmdask()

      ON ACTION qbe_select                                  #
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #
         CALL cl_qbe_save()
    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdyuser', 'hrdygrup')  #
    CALL cl_replace_str(g_wc,'hrdy01','hrat01') RETURNING g_wc                                                                 

    LET g_sql = "SELECT * FROM hrdy_file ",                       #
                " WHERE ",g_wc CLIPPED, " ORDER BY hrdy01,hrdy02"
    PREPARE i095_prepare FROM g_sql
    DECLARE i095_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i095_prepare

    LET g_sql = "SELECT COUNT(*) FROM ",
                "(SELECT * FROM hrdy_file WHERE ",g_wc CLIPPED,")"
    PREPARE i095_precount FROM g_sql
    DECLARE i095_count CURSOR FOR i095_precount
    
END FUNCTION 
	
FUNCTION i095_menu()
 
   WHILE TRUE
      CALL i095_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i095_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i095_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i095_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i095_u()
            END IF
 
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i095_b()
           ELSE
              LET g_action_choice = NULL
           END IF
           	
        WHEN "item_list"
           LET g_action_choice = ""
           CALL i095_b_menu()
           LET g_action_choice = ""  
           
        WHEN "invalid"
           IF cl_chk_act_auth() THEN
               CALL i095_x()
            END IF   	
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdya),'','')
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_hrdy.hrdy01 IS NOT NULL THEN
               LET g_doc.column1 = "hrdy01"
               LET g_doc.value1 = g_hrdy.hrdy01
               LET g_doc.column2 = "hrdy02"
               LET g_doc.value2 = g_hrdy.hrdy02
               CALL cl_doc()
            END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i095_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdya TO s_hrdya.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i095_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i095_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i095_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i095_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i095_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
     ON ACTION detail
        LET g_action_choice="detail"
        LET l_ac = 1
        EXIT DISPLAY
        
     ON ACTION invalid
        LET g_action_choice="invalid"
        EXIT DISPLAY
        
     ON ACTION item_list
        LET g_action_choice="item_list"
        EXIT DISPLAY      
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      #&include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i095_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000
   DEFINE   l_hratid  LIKE hrat_file.hratid


   WHILE TRUE

      CALL i095_b_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
      	 SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdy_b[l_ac1].hrdy01
         SELECT hrdy_file.* INTO g_hrdy.*
           FROM hrdy_file
          WHERE hrdy01=l_hratid 
            AND hrdy02=g_hrdy_b[l_ac1].hrdy02
      END IF

      IF g_action_choice != "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i095_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page3", TRUE)
         CALL cl_set_comp_visible("Page2", TRUE)
      END IF

      CASE g_action_choice
         WHEN "insert"
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
               CALL i095_a()
            END IF

        WHEN "query"
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i095_q()
            END IF

        WHEN "delete"
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i095_r()
            END IF

        WHEN "modify"
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i095_u()
            END IF

        WHEN "invalid"
            LET g_action_choice="invalid" 
            IF cl_chk_act_auth() THEN
               CALL i095_x()
               CALL i095_show()
            END IF     	        	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdy_b),'','')
           END IF
        
        WHEN "help"
            CALL cl_show_help()

        WHEN "controlg"
            CALL cl_cmdask()

        WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

        WHEN "exit"
            EXIT WHILE

        WHEN "g_idle_seconds"
            CALL cl_on_idle()

        WHEN "about"
            CALL cl_about()

        OTHERWISE
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION	 		


FUNCTION i095_b_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
   DEFINE   l_hratid  LIKE hrat_file.hratid

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
   
   DISPLAY ARRAY g_hrdy_b TO s_hrdy.* ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdy_b[l_ac1].hrdy01
         CALL i095_hrdya_fill(l_hratid,g_hrdy_b[l_ac1].hrdy02)
         
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i095_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL cl_set_comp_visible("Page3", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", TRUE)    #NO.FUN-840018 ADD
         #EXIT DISPLAY
         EXIT DIALOG
       
    END DISPLAY
    #
    #DISPLAY ARRAY g_hrdya TO s_hrdya.* ATTRIBUTE(COUNT=g_rec_b)
    #
    #  BEFORE DISPLAY
    #     CALL cl_navigator_setting(g_curs_index, g_row_count)
    #     IF g_rec_b != 0 THEN
    #        CALL fgl_set_arr_curr(g_curs_index)
    #     END IF
    #
    #  BEFORE ROW
    #     LET l_ac = ARR_CURR()
    #     CALL cl_show_fld_cont()
    #            
    #END DISPLAY        

      ON ACTION main
         LET g_bp_flag = 'Page1'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i095_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page3", TRUE)
         CALL cl_set_comp_visible("Page2", TRUE)
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION first
         CALL i095_fetch('F')
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION previous
         CALL i095_fetch('P')
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION jump
         CALL i095_fetch('/')
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION next
         CALL i095_fetch('N')
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION last
         CALL i095_fetch('L')
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION exit
         LET g_action_choice="exit"  #MOD-8A0193 add
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-8A0193
         LET g_action_choice="exit"  #MOD-8A0193 add
         #EXIT DISPLAY
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG

      ON ACTION about         #MOD-4C0121
         LET g_action_choice="about"  #MOD-8A0193 add
         #EXIT DISPLAY                #MOD-8A0193 add
         EXIT DIALOG

      ON ACTION insert
         LET g_action_choice="insert"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION invalid
         LET g_action_choice="invalid"
         #EXIT DISPLAY
         EXIT DIALOG

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         #EXIT DISPLAY
         EXIT DIALOG
      #No.FUN-9C0089 add -end-----------------  
   
      #AFTER DISPLAY
      #   CONTINUE DISPLAY

      #&include "qry_string.4gl"

   #END DISPLAY
   #END DIALOG
   
   
   DISPLAY ARRAY g_hrdya TO s_hrdya.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY
   
   END DIALOG 

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i095_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_hrdy      RECORD LIKE hrdy_file.*

   MESSAGE ""
   CLEAR FORM
   CALL g_hrdya.clear()
   LET g_wc = NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_hrdy.* LIKE hrdy_file.*             #DEFAULT 設定
 
   #預設值及將數值類變數清成零
   LET g_hrdy_t.* = g_hrdy.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrdy.hrdy05='Y'
      LET g_hrdy.hrdy06=0
      LET g_hrdy.hrdy09=0
      LET g_hrdy.hrdyuser=g_user
      LET g_hrdy.hrdygrup=g_grup
      LET g_hrdy.hrdyoriu=g_user
      LET g_hrdy.hrdyorig=g_grup
      LET g_hrdy.hrdyacti='Y'
      LET g_hrdy.hrdydate=g_today
 
      CALL i095_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_hrdy.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      BEGIN WORK

      LET l_hrdy.*=g_hrdy.*
      SELECT hratid INTO l_hrdy.hrdy01 FROM hrat_file WHERE hrat01=l_hrdy.hrdy01
 
      INSERT INTO hrdy_file VALUES (l_hrdy.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         ROLLBACK WORK
         CALL cl_err3("ins","hrdy_file",g_hrdy.hrdy02,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_hrdy.hrdy01,'I')
      END IF
 
      LET g_hrdy_t.* = g_hrdy.*
      
      CALL g_hrdya.clear() 
      LET g_rec_b = 0
      CALL i095_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION	
	
FUNCTION i095_b()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_i     LIKE type_file.num5
DEFINE l_hrct03    LIKE   hrct_file.hrct03       
DEFINE l_hratid    LIKE   hrat_file.hratid
DEFINE l_sum       LIKE   hrdya_file.hrdya05
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_hrdy.hrdy01) OR cl_null(g_hrdy.hrdy02) THEN
           RETURN 
        END IF
        
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
        
        SELECT * INTO g_hrdy.* FROM hrdy_file
         WHERE hrdy02=g_hrdy.hrdy02
           AND hrdy01=l_hratid
        
        CALL cl_opmsg('b')
        
        LET g_forupd_sql= "SELECT hrdya03,hrdya04,hrdya05,hrdya06 ",
                          "  FROM hrdya_file ",
                          " WHERE hrdya01 = ? ",
                          "   AND hrdya02 = ? ",
                          "   AND hrdya03 = ? ",
                          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i095_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_hrdya WITHOUT DEFAULTS FROM s_hrdya.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
           IF g_rec_b !=0 THEN 
              CALL fgl_set_arr_curr(l_ac)
           END IF
                
        BEFORE ROW
           LET p_cmd =''
           LET l_ac =ARR_CURR()
           LET l_lock_sw ='N'
           LET l_n =ARR_COUNT()
                
           BEGIN WORK 
           OPEN i095_cl USING g_hrdy.hrdy01,g_hrdy.hrdy02
           IF STATUS THEN
              CALL cl_err("OPEN i095_cl:",STATUS,1)
              CLOSE i095_cl
              ROLLBACK WORK
           END IF
           
           FETCH i095_cl INTO g_hrdy.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrdy.hrdy01,SQLCA.sqlcode,0)
              CLOSE i095_cl
              ROLLBACK WORK 
              RETURN
           END IF
           	
           IF g_rec_b>=l_ac THEN 
               LET p_cmd ='u'
               LET g_hrdya_t.*=g_hrdya[l_ac].*
               OPEN i095_bcl USING g_hrdy.hrdy01,g_hrdy.hrdy02,g_hrdya_t.hrdya03
               IF STATUS THEN
                  CALL cl_err("OPEN i095_bcl:",STATUS,1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i095_bcl INTO g_hrdya[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrdya_t.hrdya03,SQLCA.sqlcode,1)
                     LET l_lock_sw="Y"
                  END IF
                  	 	 	
               END IF
           END IF
           	
       BEFORE INSERT
           LET l_n=ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_hrdya[l_ac].* TO NULL
           SELECT MAX(hrdya03)+1 INTO g_hrdya[l_ac].hrdya03 FROM hrdya_file
            WHERE hrdya01=g_hrdy.hrdy01
              AND hrdya02=g_hrdy.hrdy02
           IF cl_null(g_hrdya[l_ac].hrdya03) THEN
              LET g_hrdya[l_ac].hrdya03=1
           END IF
           LET g_hrdya_t.*=g_hrdya[l_ac].*  	 	     
           CALL cl_show_fld_cont()
           NEXT FIELD hrdya04
                
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             CANCEL INSERT
          END IF
          INSERT INTO hrdya_file(hrdya01,hrdya02,hrdya03,
                                 hrdya04,hrdya05,hrdya06)
             VALUES(g_hrdy.hrdy01,g_hrdy.hrdy02,
                    g_hrdya[l_ac].hrdya03,g_hrdya[l_ac].hrdya04,
                    g_hrdya[l_ac].hrdya05,g_hrdya[l_ac].hrdya06)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","hrdya_file",g_hrdy.hrdy01,g_hrdya[l_ac].hrdya03,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   MESSAGE 'INSERT O.K.'
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                END IF

       
               
       AFTER FIELD hrdya04
          IF NOT cl_null(g_hrdya[l_ac].hrdya04) THEN
           	 SELECT hrat03 INTO l_hrct03 FROM hrat_file WHERE hratid=g_hrdy.hrdy01
          	 LET l_n=0 
             SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdya[l_ac].hrdya04
                                                       AND hrct03=l_hrct03
             IF l_n=0 THEN
             	  CALL cl_err('无此薪资月或者薪资月不属于此员工所属公司','!',0)
             	  NEXT FIELD hrdya04
             END IF	                                            
            	         		      
          END IF
 
       AFTER FIELD hrdya05
          IF NOT cl_null(g_hrdya[l_ac].hrdya05) THEN
           	 IF g_hrdya[l_ac].hrdya05<0 THEN
           	  	CALL cl_err('本次发放金额不能小于0','!',0)
           	    NEXT FIELD hrdya05
           	 END IF
           	 
           	 LET l_sum=0 	
           	 SELECT SUM(hrdya05) INTO l_sum FROM hrdya_file
           	  WHERE hrdya01=g_hrdy.hrdy01
           	    AND hrdya02=g_hrdy.hrdy02
           	    AND hrdya03<>g_hrdya_t.hrdya03		 
             IF cl_null(l_sum) THEN LET l_sum=0 END IF
             IF g_hrdya[l_ac].hrdya05+l_sum>g_hrdy.hrdy08 THEN
             	  CALL cl_err('发放金额合计不能大于实付奖金','！',0)
             	  NEXT FIELD hrdya05
             END IF
          
          END IF
          	   		   	
        BEFORE DELETE                      
           IF g_hrdya_t.hrdya03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM hrdya_file
               WHERE hrdya01 = g_hrdy.hrdy01
                 AND hrdya02 = g_hrdy.hrdy02
                 AND hrdya03 = g_hrdya_t.hrdya03
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","hrdya_file",g_hrdy.hrdy01,g_hrdya_t.hrdya03,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdya[l_ac].* = g_hrdya_t.*
              CLOSE i095_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_hrdya[l_ac].hrdya03,-263,1)
              LET g_hrdya[l_ac].* = g_hrdya_t.*
           ELSE
              UPDATE hrdya_file SET hrdya04 = g_hrdya[l_ac].hrdya04,
                                    hrdya05 = g_hrdya[l_ac].hrdya05,
                                    hrdya06 = g_hrdya[l_ac].hrdya06
                 WHERE hrdya01 = g_hrdy.hrdy01
                   AND hrdya02 = g_hrdy.hrdy02
                   AND hrdya03 = g_hrdya_t.hrdya03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","hrdya_file",g_hrdy.hrdy01,g_hrdya_t.hrdya03,SQLCA.sqlcode,"","",1) 
                 LET g_hrdya[l_ac].* = g_hrdya_t.*
              ELSE                
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_hrdya[l_ac].* = g_hrdya_t.*
              END IF
              CLOSE i095_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i095_bcl
           COMMIT WORK

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrdya04)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_hrct11" 		     
            LET g_qryparam.default1 = g_hrdya[l_ac].hrdya04
            CALL cl_create_qry() RETURNING g_hrdya[l_ac].hrdya04
            DISPLAY BY NAME g_hrdya[l_ac].hrdya04
            NEXT FIELD hrdya04
         END CASE 
           
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT

    CLOSE i095_bcl
    COMMIT WORK
    LET l_sum=0
    SELECT SUM(hrdya05) INTO l_sum FROM hrdya_file WHERE hrdya01=g_hrdy.hrdy01 
                                                    AND hrdya02=g_hrdy.hrdy02 
    IF cl_null(l_sum) THEN LET l_sum=0 END IF                                                 
    UPDATE hrdy_file SET hrdy09=l_sum 
     WHERE hrdy01=g_hrdy.hrdy01 
       AND hrdy02=g_hrdy.hrdy02
    CALL i095_show()
END FUNCTION 
	
FUNCTION i095_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hrat03      LIKE hrat_file.hrat03
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hrat17      LIKE hrag_file.hrag07
   DEFINE l_hrat04      LIKE hrao_file.hrao02
   DEFINE l_hrat05      LIKE hras_file.hras04
   DEFINE l_hrat22      LIKE hrag_file.hrag07
   DEFINE l_hrat42      LIKE hrai_file.hrai04
   DEFINE l_hrat06      LIKE hrat_file.hrat02
   DEFINE l_hrat25      LIKE hrat_file.hrat25
   DEFINE l_hrdxa09     LIKE hrdxa_file.hrdxa09
   DEFINE l_hrdxa12     LIKE hrdxa_file.hrdxa12
   DEFINE l_hrdxa14     LIKE hrdxa_file.hrdxa14
   DEFINE l_hrct07      LIKE hrct_file.hrct07
   DEFINE l_hrdm03      LIKE hrdm_file.hrdm03
   DEFINE l_hrdl03      LIKE hrdl_file.hrdl03
   DEFINE l_hrdl07      LIKE hrdl_file.hrdl07
   DEFINE l_js          LIKE hrcu_file.hrcu06
   DEFINE l_hrcu10      LIKE hrcu_file.hrcu10
   DEFINE l_hrcu11      LIKE hrcu_file.hrcu11
   DEFINE l_sum         LIKE hrdya_file.hrdya05
   DEFINE l_hratid      LIKE hrat_file.hratid
   
   DISPLAY BY NAME
      g_hrdy.hrdy01,g_hrdy.hrdy04,g_hrdy.hrdy02,g_hrdy.hrdy07,
      g_hrdy.hrdy05,g_hrdy.hrdy06,g_hrdy.hrdy08,g_hrdy.hrdy09,
      g_hrdy.hrdy10,g_hrdy.hrdyuser,g_hrdy.hrdygrup,g_hrdy.hrdymodu,
      g_hrdy.hrdydate,g_hrdy.hrdyacti

   INPUT BY NAME
      g_hrdy.hrdy01,g_hrdy.hrdy04,g_hrdy.hrdy02,g_hrdy.hrdy06
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          #IF cl_null(g_hrdy.hrdy01) THEN
          #	 CALL cl_set_comp_entry("hrdy04,hrdy02",FALSE)
          #ELSE
          #	 CALL cl_set_comp_entry("hrdy04,hrdy02",TRUE)
          #END IF	 	 
          LET g_before_input_done = FALSE
          CALL i095_set_entry(p_cmd)
          CALL i095_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          
          	 
      
      AFTER FIELD hrdy01
         IF NOT cl_null(g_hrdy.hrdy01) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
         	                                            AND hratconf='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工','!',0)
         	  	 NEXT FIELD hrdy01
         	  END IF
                  
                  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
                  IF g_hrdy_t.hrdy01 != l_hratid OR g_hrdy_t.hrdy01 IS NULL THEN
                     IF NOT cl_null(g_hrdy.hrdy02) THEN
                        LET l_n=0
                        SELECT COUNT(*) INTO l_n FROM hrdy_file WHERE hrdy01=l_hratid
                                                                  AND hrdy02=g_hrdy.hrdy02
                        IF l_n>0 THEN
                           CALL cl_err(-239,'',0)
                           NEXT FIELD hrdy01
                        END IF
                     END IF
         	  END IF
	
         	  SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
         	  SELECT hrag07 INTO l_hrat17 FROM hrat_file,hrag_file 
         	   WHERE hrat01=g_hrdy.hrdy01 AND hrag06=hrat17 AND hrag01='333'
         	  SELECT hrao02 INTO l_hrat04 FROM hrat_file,hrao_file
         	   WHERE hrat01=g_hrdy.hrdy01 AND hrat04=hrao01
         	  SELECT hras04 INTO l_hrat05 FROM hrat_file,hras_file
         	   WHERE hrat01=g_hrdy.hrdy01 AND hrat05=hras01
         	  SELECT hrag07 INTO l_hrat22 FROM hrat_file,hrag_file
         	   WHERE hrat01=g_hrdy.hrdy01 AND hrat22=hrag06 AND hrag01='317'
         	  SELECT hrai04 INTO l_hrat42 FROM hrat_file,hrai_file
         	   WHERE hrat01=g_hrdy.hrdy01 AND hrat42=hrai03
         	  SELECT B.hrat02 INTO l_hrat06 FROM hrat_file A,hrat_file B
         	   WHERE A.hrat01=g_hrdy.hrdy01 AND A.hrat06=B.hratid
         	  SELECT hrat25 INTO l_hrat25 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
         	  
         	  DISPLAY l_hrat02 TO hrat02
         	  DISPLAY l_hrat17 TO hrat17
         	  DISPLAY l_hrat04 TO hrat04
         	  DISPLAY l_hrat05 TO hrat05
         	  DISPLAY l_hrat22 TO hrat22
         	  DISPLAY l_hrat42 TO hrat42
         	  DISPLAY l_hrat06 TO hrat06
         	  DISPLAY l_hrat25 TO hrat25
                  SELECT hrat03 INTO g_hrdy.hrdy03 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
                  
         END IF
         	
      AFTER FIELD hrdy04
         IF NOT cl_null(g_hrdy.hrdy04) THEN
         	  IF NOT cl_null(g_hrdy.hrdy01) THEN 
         	     LET l_n=0
         	     SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
         	     SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdy.hrdy04
         	                                               AND hrct03=l_hrat03
         	                                               AND hrct06='Y'
         	     IF l_n=0 THEN
         	  	    CALL cl_err('参照薪资月所属公司与员工公司不一致或还未关帐','!',0)
         	  	    NEXT FIELD hrdy04      #for test
         	     ELSE                          #for test
         	  	   SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
         	  	   SELECT hrdxa09,hrdxa12,hrdxa14 INTO l_hrdxa09,l_hrdxa12,l_hrdxa14
         	  	     FROM hrdxa_file 
         	  	    WHERE hrdxa01=g_hrdy.hrdy04
                              AND hrdxa02=l_hratid
                           DISPLAY l_hrdxa09 TO hrdxa09
                           DISPLAY l_hrdxa12 TO hrdxa12
                           DISPLAY l_hrdxa14 TO hrdxa14
                           IF g_hrdy.hrdy06>0 THEN
                  	      SELECT hrct07 INTO l_hrct07 FROM hrct_file WHERE hrct11=g_hrdy.hrdy04
                  	      SELECT hrdm03 INTO l_hrdm03 FROM hrdm_file,hrct_file A,hrct_file B
                  	       WHERE hrdm02=l_hratid
                                 AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
                  	         AND hrdm04=A.hrct11
                  	         AND ((hrdm05=B.hrct11 AND hrdm13='N'             #mod by zhangbo130912  
                  	              AND l_hrct07 BETWEEN A.hrct07 AND B.hrct07) #mod by zhangbo130912
                                      OR (hrdm13='Y' AND l_hrct07>=A.hrct07))     #add by zhangbo130912
                  	      IF NOT cl_null(l_hrdm03) THEN
                  	 	  SELECT hrdl03,hrdl07 INTO l_hrdl03,l_hrdl07 FROM hrdl_file WHERE hrdl01=l_hrdm03
                  	 	  IF l_hrdxa14>=l_hrdl07 THEN
                  	 	  	 LET l_js=g_hrdy.hrdy06/12
                  	 	  ELSE
                  	 	  	 LET l_js=(g_hrdy.hrdy06+l_hrdxa14-l_hrdl07)/12
                  	 	  END IF
                  	 	  
                  	 	  SELECT hrcu10,hrcu11 INTO l_hrcu10,l_hrcu11 FROM hrcu_file
                  	 	   WHERE hrcu01=l_hrdl03
                  	 	     AND hrcu06<l_js
                  	 	     AND hrcu07>=l_js
                  	 	  IF cl_null(l_hrcu10) THEN LET l_hrcu10=0 END IF
                  	 	  IF cl_null(l_hrcu11) THEN LET l_hrcu10=0 END IF   
                  	 	  LET g_hrdy.hrdy07=(g_hrdy.hrdy06+l_hrdxa14-l_hrdl07)*l_hrcu10/100-l_hrcu11 
                  	 	  LET g_hrdy.hrdy08=g_hrdy.hrdy06-g_hrdy.hrdy07
                                  DISPLAY BY NAME g_hrdy.hrdy07,g_hrdy.hrdy08
                  	 	  	
                  	       END IF	  		 
                  	 	  	 	    
                           END IF	
                  	      
         	       END IF
         	     	
         	  ELSE
         	  	 CALL cl_err('请先录入员工编号','!',0)
         	  	 LET g_hrdy.hrdy04=""
         	  	 DISPLAY BY NAME g_hrdy.hrdy04
         	  	 NEXT FIELD hrdy01   	
         	  END IF	   	                                               	 		
         END IF	  			           
         	                                    	  		                                           
      AFTER FIELD hrdy02
         IF NOT cl_null(g_hrdy.hrdy02) THEN
            IF g_hrdy_t.hrdy02 != g_hrdy.hrdy02 OR g_hrdy_t.hrdy02 IS NULL THEN
              IF NOT cl_null(g_hrdy.hrdy01) THEN
                     SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
                     LET l_n=0 
                     SELECT COUNT(*) INTO l_n FROM hrdy_file WHERE hrdy01=l_hratid
                                                               AND hrdy02=g_hrdy.hrdy02
                     IF l_n>0 THEN
                        CALL cl_err(-239,'',0)
                        NEXT FIELD hrdy02
                     END IF

            	     LET l_n=0
         	     SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
         	     SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct03=l_hrat03
         	                                               AND hrct04=g_hrdy.hrdy02
         	                                               AND (hrct06='N' OR hrct06 IS NULL)
         	     IF l_n>0 THEN
         	     	  CALL cl_err('该财年对应员工公司的薪资月还未全部关帐','!',0)
         	     	  NEXT FIELD hrdy02     #for test
         	     END IF
                 
              ELSE
         	  	 CALL cl_err('请先录入员工工号','!',0)
         	  	 LET g_hrdy.hrdy02="" 
         	  	 DISPLAY BY NAME g_hrdy.hrdy02
         	  	 NEXT FIELD hrdy01
              END IF
           END IF	   		                                               	
         END IF
         	
      AFTER FIELD hrdy06
         IF NOT cl_null(g_hrdy.hrdy06) THEN
            IF g_hrdy.hrdy06<=0 THEN
            	 CALL cl_err('奖金必须大于0','!',0)
            	 NEXT FIELD hrdy06
            END IF
            	
            IF NOT cl_null(g_hrdy.hrdy01) AND NOT cl_null(g_hrdy.hrdy04) THEN
            	 SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
         	  	 SELECT hrdxa09,hrdxa12,hrdxa14 INTO l_hrdxa09,l_hrdxa12,l_hrdxa14
         	  	 	 FROM hrdxa_file 
         	  	 	WHERE hrdxa01=g_hrdy.hrdy04
                  AND hrdxa02=l_hratid
               SELECT hrct07 INTO l_hrct07 FROM hrct_file WHERE hrct11=g_hrdy.hrdy04
               SELECT hrdm03 INTO l_hrdm03 FROM hrdm_file,hrct_file A,hrct_file B
                WHERE hrdm02=l_hratid
                  AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
                  AND hrdm04=A.hrct11
                  AND ((hrdm05=B.hrct11 AND hrdm13='N'             #mod by zhangbo130912
                       AND l_hrct07 BETWEEN A.hrct07 AND B.hrct07)  #mod by zhangbo130912
                       OR (hrdm13='Y' AND l_hrct07>=A.hrct07))      #add by zhangbo130912
               IF NOT cl_null(l_hrdm03) THEN
                  SELECT hrdl03,hrdl07 INTO l_hrdl03,l_hrdl07 FROM hrdl_file WHERE hrdl01=l_hrdm03
                  IF l_hrdxa14>=l_hrdl07 THEN
                  	 LET l_js=g_hrdy.hrdy06/12
                  ELSE
                  	 LET l_js=(g_hrdy.hrdy06+l_hrdxa14-l_hrdl07)/12
                  END IF
                  	 	  
                  SELECT hrcu10,hrcu11 INTO l_hrcu10,l_hrcu11 FROM hrcu_file
                   WHERE hrcu01=l_hrdl03
                  	 AND hrcu06<l_js
                  	 AND hrcu07>=l_js
                  IF cl_null(l_hrcu10) THEN LET l_hrcu10=0 END IF
                  IF cl_null(l_hrcu11) THEN LET l_hrcu10=0 END IF   
                  LET g_hrdy.hrdy07=(g_hrdy.hrdy06+l_hrdxa14-l_hrdl07)*l_hrcu10/100-l_hrcu11 
                  LET g_hrdy.hrdy08=g_hrdy.hrdy06-g_hrdy.hrdy07
                  DISPLAY BY NAME g_hrdy.hrdy07,g_hrdy.hrdy08	 	  	
               END IF	  	
            END IF	 		   	
         END IF	  		 		
         	    	    	 		                     	  	                    	  	   	 	                                             	    		  	      	

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrdy01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrdy.hrdy01
              CALL cl_create_qry() RETURNING g_hrdy.hrdy01
              DISPLAY BY NAME g_hrdy.hrdy01
              NEXT FIELD hrdy01
           
           WHEN INFIELD(hrdy04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrdy.hrdy04
              CALL cl_create_qry() RETURNING g_hrdy.hrdy04
              DISPLAY BY NAME g_hrdy.hrdy04
              NEXT FIELD hrdy04
           
           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
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
	
FUNCTION i095_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdy.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i095_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i095_count
    FETCH i095_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i095_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdy.hrdy01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdy.* TO NULL
    ELSE
        CALL i095_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i095_hrdy_fill(g_wc)
    END IF
END FUNCTION
	
FUNCTION i095_fetch(p_flhrdy)
    DEFINE p_flhrdy         LIKE type_file.chr1

    CASE p_flhrdy
        WHEN 'N' FETCH NEXT     i095_cs INTO g_hrdy.hrdy01,g_hrdy.hrdy02
        WHEN 'P' FETCH PREVIOUS i095_cs INTO g_hrdy.hrdy01,g_hrdy.hrdy02
        WHEN 'F' FETCH FIRST    i095_cs INTO g_hrdy.hrdy01,g_hrdy.hrdy02
        WHEN 'L' FETCH LAST     i095_cs INTO g_hrdy.hrdy01,g_hrdy.hrdy02
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump i095_cs INTO g_hrdy.hrdy01,g_hrdy.hrdy02
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdy.hrdy01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdy.* TO NULL
        LET g_hrdy.hrdy01 = NULL
        LET g_hrdy.hrdy02 = NULL
        RETURN
    ELSE
      CASE p_flhrdy
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      #DISPLAY g_curs_index TO FORMONLY.idx
    END IF
    	      
    CALL i095_show()                 

END FUNCTION	
	
FUNCTION i095_show()
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hrat17      LIKE hrag_file.hrag07
   DEFINE l_hrat04      LIKE hrao_file.hrao02
   DEFINE l_hrat05      LIKE hras_file.hras04
   DEFINE l_hrat22      LIKE hrag_file.hrag07
   DEFINE l_hrat42      LIKE hrai_file.hrai04
   DEFINE l_hrat06      LIKE hrat_file.hrat02
   DEFINE l_hrat25      LIKE hrat_file.hrat25
   DEFINE l_hrdxa09     LIKE hrdxa_file.hrdxa09
   DEFINE l_hrdxa12     LIKE hrdxa_file.hrdxa12
   DEFINE l_hrdxa14     LIKE hrdxa_file.hrdxa14
    
    SELECT * INTO g_hrdy.* FROM hrdy_file WHERE hrdy01=g_hrdy.hrdy01
                                            AND hrdy02=g_hrdy.hrdy02
    LET g_hrdy_t.* = g_hrdy.*
    SELECT hrat01 INTO g_hrdy.hrdy01 FROM hrat_file WHERE hratid=g_hrdy.hrdy01
    
    DISPLAY BY NAME g_hrdy.hrdy01,g_hrdy.hrdy04,g_hrdy.hrdy02,
                    g_hrdy.hrdy07,g_hrdy.hrdy05,g_hrdy.hrdy06,
                    g_hrdy.hrdy08,g_hrdy.hrdy09,g_hrdy.hrdy10,
                    g_hrdy.hrdyuser,g_hrdy.hrdygrup,g_hrdy.hrdymodu,
                    g_hrdy.hrdydate,g_hrdy.hrdyacti,g_hrdy.hrdyorig,g_hrdy.hrdyoriu
    SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
    SELECT hrag07 INTO l_hrat17 FROM hrat_file,hrag_file 
     WHERE hrat01=g_hrdy.hrdy01 AND hrag06=hrat17 AND hrag01='333'
    SELECT hrao02 INTO l_hrat04 FROM hrat_file,hrao_file
     WHERE hrat01=g_hrdy.hrdy01 AND hrat04=hrao01
    SELECT hras04 INTO l_hrat05 FROM hrat_file,hras_file
     WHERE hrat01=g_hrdy.hrdy01 AND hrat05=hras01
    SELECT hrag07 INTO l_hrat22 FROM hrat_file,hrag_file
     WHERE hrat01=g_hrdy.hrdy01 AND hrat22=hrag06 AND hrag01='317'
    SELECT hrai04 INTO l_hrat42 FROM hrat_file,hrai_file
     WHERE hrat01=g_hrdy.hrdy01 AND hrat42=hrai03
    SELECT B.hrat02 INTO l_hrat06 FROM hrat_file A,hrat_file B
     WHERE A.hrat01=g_hrdy.hrdy01 AND A.hrat06=B.hratid
    SELECT hrat25 INTO l_hrat25 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
    SELECT hrdxa09,hrdxa12,hrdxa14 INTO l_hrdxa09,l_hrdxa12,l_hrdxa14
      FROM hrdxa_file 
     WHERE hrdxa01=g_hrdy.hrdy04
       AND hrdxa02=g_hrdy_t.hrdy01
    
    DISPLAY l_hrat02 TO hrat02
    DISPLAY l_hrat17 TO hrat17
    DISPLAY l_hrat04 TO hrat04
    DISPLAY l_hrat05 TO hrat05
    DISPLAY l_hrat22 TO hrat22      	
    DISPLAY l_hrat42 TO hrat42
    DISPLAY l_hrat06 TO hrat06
    DISPLAY l_hrat25 TO hrat25
    DISPLAY l_hrdxa09 TO hrdxa09
    DISPLAY l_hrdxa12 TO hrdxa12
    DISPLAY l_hrdxa14 TO hrdxa14                
    CALL cl_show_fld_cont()
    CALL i095_hrdya_fill(g_hrdy_t.hrdy01,g_hrdy.hrdy02)
END FUNCTION

FUNCTION i095_u()
DEFINE l_hrdy   RECORD LIKE  hrdy_file.* 	
  	
    IF g_hrdy.hrdy01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    LET l_hrdy.*=g_hrdy.*
    SELECT hratid INTO l_hrdy.hrdy01 FROM hrat_file WHERE hrat01=l_hrdy.hrdy01	
    SELECT * INTO g_hrdy.* FROM hrdy_file WHERE hrdy01=l_hrdy.hrdy01 AND hrdy02=l_hrdy.hrdy02
    
    IF g_hrdy.hrdyacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i095_cl USING l_hrdy.hrdy01,l_hrdy.hrdy02
    IF STATUS THEN
       CALL cl_err("OPEN i095_cl:", STATUS, 1)
       CLOSE i095_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i095_cl INTO g_hrdy.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdy.hrdy01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i095_show()                          
    WHILE TRUE
        CALL i095_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdy.*=g_hrdy_t.*
            CALL i095_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrdy.hrdymodu=g_user
        LET g_hrdy.hrdydate=g_today	
        SELECT hratid INTO g_hrdy.hrdy01 FROM hrat_file WHERE hrat01=g_hrdy.hrdy01
        UPDATE hrdy_file SET hrdy_file.* = g_hrdy.*    
            WHERE hrdy01 = g_hrdy_t.hrdy01
              AND hrdy02 = g_hrdy_t.hrdy02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdy_file",g_hrdy.hrdy01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i095_show()	
        EXIT WHILE
    END WHILE
    CLOSE i095_cl
    COMMIT WORK
    CALL i095_hrdy_fill(g_wc)
END FUNCTION
	
FUNCTION i095_x()
DEFINE l_hrdy    RECORD LIKE   hrdy_file.*	
	
    IF g_hrdy.hrdy01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    	
    LET l_hrdy.*=g_hrdy.*
    SELECT hratid INTO l_hrdy.hrdy01 FROM hrat_file WHERE hrat01=l_hrdy.hrdy01	
    SELECT * INTO g_hrdy.* FROM hrdy_file WHERE hrdy01=l_hrdy.hrdy01 AND hrdy02=l_hrdy.hrdy02
    	
    BEGIN WORK

    OPEN i095_cl USING l_hrdy.hrdy01,l_hrdy.hrdy02
    IF STATUS THEN
       CALL cl_err("OPEN i095_cl:", STATUS, 1)
       CLOSE i095_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i095_cl INTO g_hrdy.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdy.hrdy01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i095_show()
    IF cl_exp(0,0,g_hrdy.hrdyacti) THEN
        LET g_chr = g_hrdy.hrdyacti
        IF g_hrdy.hrdyacti='Y' THEN
            LET g_hrdy.hrdyacti='N'
        ELSE
            LET g_hrdy.hrdyacti='Y'
        END IF
        UPDATE hrdy_file
            SET hrdyacti=g_hrdy.hrdyacti
          WHERE hrdy01=g_hrdy.hrdy01
            AND hrdy02=g_hrdy.hrdy02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrdy.hrdy01,SQLCA.sqlcode,0)
            LET g_hrdy.hrdyacti = g_chr
        END IF
        DISPLAY BY NAME g_hrdy.hrdyacti
    END IF
    CLOSE i095_cl
    COMMIT WORK
    CALL i095_hrdy_fill(g_wc)
END FUNCTION
	
FUNCTION i095_r()
DEFINE  l_hrdy   RECORD  LIKE  hrdy_file.*
	
    IF g_hrdy.hrdy01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    	
    LET l_hrdy.*=g_hrdy.*
    SELECT hratid INTO l_hrdy.hrdy01 FROM hrat_file WHERE hrat01=l_hrdy.hrdy01	
    SELECT * INTO g_hrdy.* FROM hrdy_file WHERE hrdy01=l_hrdy.hrdy01 AND hrdy02=l_hrdy.hrdy02
    	
    BEGIN WORK

    OPEN i095_cl USING l_hrdy.hrdy01,l_hrdy.hrdy02
    IF STATUS THEN
       CALL cl_err("OPEN i095_cl:", STATUS, 0)
       CLOSE i095_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i095_cl INTO g_hrdy.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdy.hrdy01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i095_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdy01"
       LET g_doc.value1 = g_hrdy.hrdy01
       LET g_doc.column2 = "hrdy02"
       LET g_doc.value2 = g_hrdy.hrdy02
       CALL cl_del_doc()
       
       DELETE FROM hrdya_file WHERE hrdya01 = g_hrdy.hrdy01 AND hrdya02=g_hrdy.hrdy02
       DELETE FROM hrdy_file WHERE hrdy01 = g_hrdy.hrdy01 AND hrdy02=g_hrdy.hrdy02
       
       CLEAR FORM
       OPEN i095_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i095_cl
          CLOSE i095_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i095_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i095_cl
          CLOSE i095_count
          COMMIT WORK
          CALL i095_hrdy_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i095_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i095_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i095_fetch('/')
       END IF
    END IF
    CLOSE i095_cl
    COMMIT WORK
    CALL i095_hrdy_fill(g_wc)
END FUNCTION
	
PRIVATE FUNCTION i095_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrdy01,hrdy02",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i095_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("hrdy01,hrdy02",FALSE)
   END IF
END FUNCTION
	
FUNCTION i095_hrdya_fill(p_hrdy01,p_hrdy02)
DEFINE l_sql    STRING
DEFINE p_hrdy01 LIKE   hrdy_file.hrdy01
DEFINE p_hrdy02 LIKE   hrdy_file.hrdy02
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrdya.clear()
        
        LET l_sql=" SELECT hrdya03,hrdya04,hrdya05,hrdya06 ",
                  "   FROM hrdya_file ",
                  "  WHERE hrdya01='",p_hrdy01,"' ",
                  "    AND hrdya02='",p_hrdy02,"' ",   
                  "  ORDER BY hrdya03 "
                  
        PREPARE i095_hrdya_pre FROM l_sql
        DECLARE i095_hrdya_cs CURSOR FOR i095_hrdya_pre
        
        LET l_i=1
        
        FOREACH i095_hrdya_cs INTO g_hrdya[l_i].*
        
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrdya.deleteElement(l_i)
        LET g_rec_b = l_i - 1

END FUNCTION
	
FUNCTION i095_hrdy_fill(p_wc)
DEFINE p_wc     STRING	
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrdy_b.clear()
        
        LET l_sql=" SELECT hrdy01,'',hrdy02,hrdy03,hrdy04,hrdy05,hrdy06,hrdy07,hrdy08,hrdy09,hrdy10 ",
                  "   FROM hrdy_file ",
                  "  WHERE ",p_wc CLIPPED,   
                  "  ORDER BY hrdy01,hrdy02 "
                  
        PREPARE i095_hrdy_pre FROM l_sql
        DECLARE i095_hrdy_cs CURSOR FOR i095_hrdy_pre
        
        LET l_i=1
        
        FOREACH i095_hrdy_cs INTO g_hrdy_b[l_i].*
           
           SELECT hrat01,hrat02 INTO g_hrdy_b[l_i].hrdy01,g_hrdy_b[l_i].hrat02 
             FROM hrat_file 
            WHERE hratid=g_hrdy_b[l_i].hrdy01
           SELECT hraa12 INTO g_hrdy_b[l_i].hrdy03 FROM hraa_file
            WHERE hraa01=g_hrdy_b[l_i].hrdy03  
              
           LET l_i=l_i+1
           
        END FOREACH
        CALL g_hrdy_b.deleteElement(l_i)
        LET g_rec_b1 = l_i - 1

END FUNCTION	 	
	
											                                  

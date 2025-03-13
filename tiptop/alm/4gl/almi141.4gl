# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almi141.4gl
# Descriptions...: 攤位基本資料維護作業 
# Date & Author..: NO.FUN-870010 08/07/03 By lilingyu 
# Modify.........: No.FUN-960134 09/06/30 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/16 By shiwuying SQL后加SQLCA.SQLCODE判斷
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:TQC-AB0230 10/11/29 By huangtao 修改更改樓棟，樓層不更改的問題
# Modify.........: No:MOD-AC0254 10/12/21 By huangtao 修正TQC-AB0230的bug
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80141 11/08/24 By xumeimei 雙當改為多當 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_lmf       RECORD   LIKE lmf_file.*,  
        g_lmf_t     RECORD   LIKE lmf_file.*,					
        g_lmf_o     RECORD   LIKE lmf_file.*,    
        g_lmf01_t            LIKE lmf_file.lmf01   
            
#FUN-B80141-----------add----------str---------
DEFINE  g_lie       DYNAMIC ARRAY OF RECORD
                    lie02      LIKE lie_file.lie02,
                    lie03      LIKE lie_file.lie03,
                    lmc04_1    LIKE lmc_file.lmc04,
                    lie04      LIKE lie_file.lie04,
                    lmy04      LIKE lmy_file.lmy04,
                    lie05      LIKE lie_file.lie05,
                    lie06      LIKE lie_file.lie06,
                    lie07      LIKE lie_file.lie07,
                    lieacti    LIKE lie_file.lieacti
                    END RECORD, 

        g_lie_t     DYNAMIC ARRAY OF RECORD
                    lie02      LIKE lie_file.lie02,
                    lie03      LIKE lie_file.lie03,
                    lmc04_1    LIKE lmc_file.lmc04,
                    lie04      LIKE lie_file.lie04,
                    lmy04      LIKE lmy_file.lmy04,
                    lie05      LIKE lie_file.lie05,
                    lie06      LIKE lie_file.lie06,
                    lie07      LIKE lie_file.lie07,
                    lieacti    LIKE lie_file.lieacti
                    END RECORD
 
DEFINE  g_lml       DYNAMIC ARRAY OF RECORD
                    lml02      LIKE lml_file.lml02,
                    oba02      LIKE oba_file.oba02,
                    lml06      LIKE lml_file.lml06
                    END RECORD, 
        g_lml_t     DYNAMIC ARRAY OF RECORD
                    lml02      LIKE lml_file.lml02,
                    oba02      LIKE oba_file.oba02,
                    lml06      LIKE lml_file.lml06
                    END RECORD, 
        g_wc2                    STRING, 
        g_wc3                    STRING,
        g_rec_b                  LIKE type_file.num5, 
        g_rec_b1                 LIKE type_file.num5,         
        l_ac                     LIKE type_file.num5,
        l_ac1                    LIKE type_file.num5,
        g_b_flag                 STRING 
#FUN-B80141-----------add----------end---------
 
DEFINE g_wc                  STRING 
DEFINE g_sql                 STRING                 
DEFINE g_forupd_sql          STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10 
DEFINE g_jump                LIKE type_file.num10             
DEFINE g_no_ask              LIKE type_file.num5 
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_date                LIKE lmf_file.lmfdate
DEFINE g_modu                LIKE lmf_file.lmfmodu
 
 
MAIN
   DEFINE cb ui.ComboBox
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT          
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   LET g_forupd_sql = "SELECT * FROM lmf_file WHERE lmf01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i141_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i141_w WITH FORM "alm/42f/almi141"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
 
#   LET cb = ui.ComboBox.forname("lmf06")    #FUN-B80141 mark
#   CALL cb.removeitem("X")                  #FUN-B80141 mark
 
   LET g_action_choice = ""
   CALL i141_menu()
 
   CLOSE WINDOW i141_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i141_curs()
 
       CLEAR FORM    
       CALL g_lie.clear()    #FUN-B80141---add
       CALL g_lml.clear()    #FUN-B80141---add

#FUN-B80141--------mark------str---------
#      CONSTRUCT BY NAME g_wc ON  
#                        lmf01,lmfstore,lmflegal,lmf03,lmf04,lmf05,lmf06,
#                        lmf07,lmf08,
#                        lmfuser,lmfgrup,lmforiu,lmforig,  #No.FUN-9B0136
#                        lmfmodu,lmfdate,lmfacti,lmfcrat
#FUN-B80141--------mark------end--------

       #FUN-B80141--------add-------str--------
       DIALOG ATTRIBUTES(UNBUFFERED) 
       CONSTRUCT BY NAME g_wc ON
                         lmf01,lmf15,lmfstore,lmflegal,lmf03,lmf04,lmf09,lmf10,lmf11,
                         lmf12,lmf05,lmf06,lmf07,lmf08,lmf13,lmf14,
                         lmfuser,lmfgrup,lmforiu,lmforig,
                         lmfmodu,lmfdate,lmfacti,lmfcrat
       #FUN-B80141--------add-------end--------
                         
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(lmf01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lmf1"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " lmfstore IN ",g_auth," "  #No.FUN-A10060
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lmf01
                    NEXT FIELD lmf01                     
                
                 WHEN INFIELD(lmfstore)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lmf2"
                    LET g_qryparam.state = "c"               
                    LET g_qryparam.where = " lmfstore IN ",g_auth," "  #No.FUN-A10060
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lmfstore
                    NEXT FIELD lmfstore        
 
                 WHEN INFIELD(lmflegal)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lmflegal"
                    LET g_qryparam.state = "c" 
                    LET g_qryparam.where = " lmfstore IN ",g_auth," "  #No.FUN-A10060
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lmflegal
                    NEXT FIELD lmflegal
 
                 WHEN INFIELD(lmf03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lmf3"
                    LET g_qryparam.state = "c"             
                    LET g_qryparam.where = " lmfstore IN ",g_auth," "  #No.FUN-A10060
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lmf03
                    NEXT FIELD lmf03 
                    
                 WHEN INFIELD(lmf04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lmf4"
                    LET g_qryparam.state = "c"            
                    LET g_qryparam.where = " lmfstore IN ",g_auth," "  #No.FUN-A10060
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lmf04
                    NEXT FIELD lmf04
                 #FUN-B80141-------add-------str------                      
                 WHEN INFIELD(lmf07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lmf07"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " lmfstore IN ",g_auth," " 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lmf07
                    NEXT FIELD lmf07

                 WHEN INFIELD(lmf12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_lmf12"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " lmfstore IN ",g_auth," "  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lmf12
                    NEXT FIELD lmf12
                 #FUN-B80141-------add-------end------          
 
                 OTHERWISE
                    EXIT CASE
              END CASE
 
       END CONSTRUCT

#FUN-B80141-----add----str------
     CONSTRUCT g_wc2 ON lie02,lie03,lie04,lie05,lie06,lie07,lieacti
         FROM s_lie[1].lie02,s_lie[1].lie03,s_lie[1].lie04,s_lie[1].lie05,s_lie[1].lie06,s_lie[1].lie07,s_lie[1].lieacti
                   
 
      ON ACTION CONTROLP 
         CASE 
           WHEN INFIELD(lie02)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lie02"
              LET g_qryparam.state= "c"
              LET g_qryparam.where = " liestore IN ",g_auth," " 
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lie02
              NEXT FIELD lie02

           WHEN INFIELD(lie03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lie03"
              LET g_qryparam.state= "c"
              LET g_qryparam.where = " liestore IN ",g_auth," "
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lie03            
              NEXT FIELD lie03


           WHEN INFIELD(lie04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lie04"
              LET g_qryparam.state= "c"
              LET g_qryparam.where = " liestore IN ",g_auth," "
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lie04
              NEXT FIELD lie04

            OTHERWISE EXIT CASE
         END CASE
 
    END CONSTRUCT
   
    CONSTRUCT g_wc3 ON lml02,lml06
         FROM s_lml[1].lml02,s_lml[1].lml06

      ON ACTION CONTROLP 
         CASE 
           WHEN INFIELD(lml02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lml02_1"
               LET g_qryparam.state= "c"
               LET g_qryparam.where = " lmlstore IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lml02
               NEXT FIELD lml02
            OTHERWISE EXIT CASE
         END CASE

      END CONSTRUCT 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG    

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

          ON ACTION close
             LET INT_FLAG=1
             EXIT DIALOG 

          ON ACTION ACCEPT
             ACCEPT DIALOG
      
          ON ACTION cancel
             LET INT_FLAG = 1
             EXIT DIALOG 

       END DIALOG
#FUN-B80141-----add------end--------       
       IF INT_FLAG THEN
          RETURN
       END IF
   
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN   
    #        LET g_wc = g_wc clipped," AND lmfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND lmfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lmfgrup IN",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmfuser', 'lmfgrup')
    #End:FUN-980030
#FUN-B80141-------mark-----str-------- 
   #LET g_sql = "SELECT lmf01 FROM lmf_file ",
   #            " WHERE ",g_wc CLIPPED,
   #            " and lmfstore IN ",g_auth,   #No.FUN-A10060
   #            " ORDER BY lmf01"
 
   #PREPARE i141_prepare FROM g_sql
   #DECLARE i141_cs                                # SCROLL CURSOR
   #    SCROLL CURSOR WITH HOLD FOR i141_prepare
 
   #LET g_sql = "SELECT COUNT(*) FROM lmf_file WHERE ",g_wc CLIPPED,
   #            "   and lmfstore in ",g_auth  #No.FUN-A10060
   #      
   #PREPARE i141_precount FROM g_sql
   #DECLARE i141_count CURSOR FOR i141_precount
#FUN-B80141-------mark-----end--------
#FUN-B80141-------add------str--------
   IF cl_null(g_wc2) THEN
      LET g_wc2=' 1=1'
   END IF

   IF cl_null(g_wc3) THEN     
      LET g_wc3=' 1=1'
   END IF

   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN     
      LET g_sql = "SELECT lmf01 FROM lmf_file ",
                 " WHERE ", g_wc CLIPPED,
                 "   AND lmfstore IN ",g_auth,
                 " ORDER BY lmf01"
   ELSE           
      LET g_sql = "SELECT UNIQUE lmf01 ",
                  "  FROM lmf_file,lie_file,lml_file",
                  " WHERE lmf01 = lie01 AND lmf01 = lml01 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                  "   AND lmfstore IN ",g_auth,
                  " ORDER BY lmf01"
   END IF
 
   PREPARE i141_prepare FROM g_sql
   DECLARE i141_cs
       SCROLL CURSOR WITH HOLD FOR i141_prepare
 
   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN   
      LET g_sql="SELECT COUNT(*) FROM lmf_file WHERE ",g_wc CLIPPED,
                " and lmfstore IN ",g_auth
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lmf01) FROM lmf_file,lie_file,lml_file ",
                " WHERE lie01=lmf01 AND lmf01 = lml01 ",
                "   AND",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED, 
                "   AND lmfstore IN ",g_auth
   END IF
   PREPARE i141_precount FROM g_sql
   DECLARE i141_count CURSOR FOR i141_precount
#FUN-B80141-------add------end--------  
END FUNCTION
 
#FUN-B80141--------mark------str-----------        
# FUNCTION i141_menu()
#    
#     MENU ""
#         BEFORE MENU
#            CALL cl_navigator_setting(g_curs_index,g_row_count)
# 
#        ON ACTION insert
#           LET g_action_choice="insert"
#           IF cl_chk_act_auth() THEN
#              CALL i141_a()
#           END IF
# 
#         ON ACTION query
#            LET g_action_choice="query"
#            IF cl_chk_act_auth() THEN
#               CALL i141_q()
#            END IF
#  
#         ON ACTION next
#            CALL i141_fetch('N')
#  
#         ON ACTION previous
#            CALL i141_fetch('P')
# 
#         ON ACTION modify
#            LET g_action_choice="modify"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lmf.lmfstore,g_plant) THEN 
#                  CALL i141_u('w')
#            #  END IF    
#            END IF   
#    
#         ON ACTION invalid
#            LET g_action_choice="invalid"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lmf.lmfstore,g_plant) THEN 
#                  CALL i141_x()
#            #  END IF    
#            END IF
#  
#         ON ACTION delete
#            LET g_action_choice="delete"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lmf.lmfstore,g_plant) THEN 
#                   CALL i141_r()
#            #  END IF  
#            END IF
#  
#         ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            IF cl_chk_act_auth() THEN
#               CALL i141_copy()
#            END IF    
#            
#         ON ACTION confirm
#            LET g_action_choice="confirm"
#            IF cl_chk_act_auth() THEN
#            #  IF cl_chk_mach_auth(g_lmf.lmfstore,g_plant) THEN 
#                  CALL i141_confirm()
#            #  END IF    
#            END IF   
#            CALL i141_pic()
#                    
#         ON ACTION unconfirm
#            LET g_action_choice="unconfirm"
#            IF cl_chk_act_auth() THEN
#            # IF cl_chk_mach_auth(g_lmf.lmfstore,g_plant) THEN   
#                CALL i141_unconfirm()
#            # END IF   
#            END IF          
#            CALL i141_pic()
# 
#        #ON ACTION void 
#        #   LET g_action_choice = "void"
#        #   IF cl_chk_act_auth() THEN 
#        #   # IF cl_chk_mach_auth(g_lmf.lmfstore,g_plant) THEN   
#        #        CALL i141_v()
#        #   #  END IF  
#        #   END IF  
#        #   CALL i141_pic()
#               
#         ON ACTION help
#            CALL cl_show_help()
#  
#         ON ACTION exit
#            LET g_action_choice = "exit"
#            EXIT MENU
#  
#         ON ACTION jump
#            CALL i141_fetch('/')
#  
#         ON ACTION first
#            CALL i141_fetch('F')
#  
#         ON ACTION last
#            CALL i141_fetch('L')
#  
#         ON ACTION controlg
#            CALL cl_cmdask()
#  
#         ON ACTION locale
#            CALL cl_dynamic_locale()
#            CALL cl_show_fld_cont() 
#            CALL i141_pic()
#             
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE MENU
#  
#         ON ACTION about 
#            CALL cl_about() 
#  
#         ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
#            LET INT_FLAG = FALSE 
#            LET g_action_choice = "exit"
#            EXIT MENU
#  
#         ON ACTION related_document 
#            LET g_action_choice="related_document"
#            IF cl_chk_act_auth() THEN
#               IF NOT cl_null(g_lmf.lmf01) THEN
#                  LET g_doc.column1 = "lmf01"
#                  LET g_doc.value1 = g_lmf.lmf01
#                  CALL cl_doc()
#               END IF
#            END IF
#  
#     END MENU
#     CLOSE i141_cs
# END FUNCTION
#FUN-B80141--------mark------end---------------

#FUN-B80141--------add-------str---------------
FUNCTION i141_menu()

   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      CALL i141_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i141_q()
            END IF
 
         WHEN "help"
            CALL cl_show_help()

         WHEN "exporttoexcel"                                                   
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lie),base.TypeInfo.create(g_lml),'')
            END IF

         WHEN "related_document"
             IF cl_chk_act_auth() THEN
                IF NOT cl_null(g_lmf.lmf01) THEN
                   LET g_doc.column1 = "lmf01"
                   LET g_doc.value1 = g_lmf.lmf01
                   CALL cl_doc()
                END IF
             END IF
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

      END CASE
   END WHILE
END FUNCTION

 
FUNCTION i141_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_lie TO s_lie.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
        CALL cl_set_act_visible("accept,cancel",FALSE )  
        CALL cl_navigator_setting( g_curs_index, g_row_count )
        LET g_b_flag='1'
     BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
              
   END DISPLAY
   
   DISPLAY ARRAY g_lml TO s_lml.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_set_act_visible("accept,cancel",FALSE )  
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag='2'
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
   END DISPLAY 
   
   BEFORE DIALOG   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION first
         CALL i141_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL i141_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL i141_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL i141_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL i141_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG


      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION related_document
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_lmf.lmf01) THEN
               LET g_doc.column1 = "lmf01"
               LET g_doc.value1 = g_lmf.lmf01
               CALL cl_doc()
             END IF
         END IF
 
      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 

   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
#FUN-B80141--------add-------end---------------


#FUN-B80141--------mark------str--------------- 
# FUNCTION i141_a()
#    DEFINE l_count      LIKE type_file.num5
#    DEFINE l_n          LIKE type_file.num5
# #  DEFINE l_tqa06      LIKE tqa_file.tqa06
#  
#    ####新增時判斷是否區域或門店,若是區域則不可以新增
# #  SELECT tqa06 INTO l_tqa06 FROM tqa_file
# #   WHERE tqa03 = '14'       	 
# #     AND tqaacti = 'Y'
# #     AND tqa01 IN(SELECT tqb03 FROM tqb_file
# #    	            WHERE tqbacti = 'Y'
# #    	              AND tqb09 = '2'
# #    	              AND tqb01 = g_plant) 
# #  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
# #     CALL cl_err('','alm-600',1)
# #     RETURN 
# #  END IF 
# #  
# #  SELECT COUNT(*) INTO l_n FROM rtz_file
# #   WHERE rtz01 = g_plant
# #     AND rtz28 = 'Y'
# #   IF l_n < 1 THEN 
# #      CALL cl_err('','alm-606',1)
# #      RETURN 
# #   END IF
#  
#     MESSAGE ""
#     CLEAR FORM    
#     INITIALIZE g_lmf.*    LIKE lmf_file.*       
#     INITIALIZE g_lmf_t.*  LIKE lmf_file.*
#     INITIALIZE g_lmf_o.*  LIKE lmf_file.*     
#  
#      LET g_lmf01_t = NULL
#      LET g_wc = NULL
#      CALL cl_opmsg('a')     
#      
#      WHILE TRUE
#         LET g_lmf.lmfuser = g_user
#         LET g_lmf.lmforiu = g_user #FUN-980030
#         LET g_lmf.lmforig = g_grup #FUN-980030
#         LET g_lmf.lmfgrup = g_grup         
#         LET g_lmf.lmfcrat = g_today
#         LET g_lmf.lmfacti = 'Y'
#         LET g_lmf.lmf05   = '0'     
#         LET g_lmf.lmf06   = 'N'
#         LET g_lmf.lmfstore   = g_plant
#         LET g_lmf.lmflegal = g_legal
#        
#         CALL i141_i("a")           
#         
#         IF INT_FLAG THEN  
#            LET INT_FLAG = 0
#            INITIALIZE g_lmf.* TO NULL
#            LET g_lmf01_t = NULL
#            CALL cl_err('',9001,0)
#            CLEAR FORM
#            EXIT WHILE
#         END IF
#         IF cl_null(g_lmf.lmf01) THEN    
#            CONTINUE WHILE
#         END IF             
#          
#         INSERT INTO lmf_file VALUES(g_lmf.*)                   
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err(g_lmf.lmf01,SQLCA.SQLCODE,0)
#            CONTINUE WHILE
#         ELSE
#            SELECT * INTO g_lmf.*
#              FROM lmf_file
#             WHERE lmf01 = g_lmf.lmf01
#            LET g_lmf01_t = g_lmf.lmf01
#            #############    
#            SELECT COUNT(lmf01) INTO l_count 
#              FROM rtz_file,lmf_file 
#             WHERE rtz01 = g_lmf.lmfstore          
#               AND rtz01 = lmfstore 
#            UPDATE rtz_file 
#               SET rtz24=l_count
#             WHERE rtz01=g_lmf.lmfstore
#           #No.TQC-A30075 -BEGIN-----
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('upd_rtz',SQLCA.SQLCODE,0)
#               CONTINUE WHILE
#            END IF
#           #No.TQC-A30075 -END-------
#            ##############         
#         END IF
#         EXIT WHILE
#     END WHILE
#     LET g_wc = NULL
# END FUNCTION
#  
# FUNCTION i141_i(p_cmd)
# DEFINE   p_cmd      LIKE type_file.chr1 
# DEFINE   l_cnt      LIKE type_file.num5 
# DEFINE   l_rtz13    LIKE rtz_file.rtz13   #FUN-A80148 add
# DEFINE   l_lmb03    LIKE lmb_file.lmb03
# DEFINE   l_lmc04    LIKE lmc_file.lmc04
# DEFINE   l_lmb06    LIKE lmb_file.lmb06
# DEFINE   l_lmc07    LIKE lmc_file.lmc07 
# DEFINE   l_count    LIKE type_file.num5 
#  
#    DISPLAY BY NAME  g_lmf.lmforiu,g_lmf.lmforig,g_lmf.lmfstore,g_lmf.lmf05,g_lmf.lmf06,
#                     g_lmf.lmfuser,g_lmf.lmfgrup,g_lmf.lmfmodu,
#                     g_lmf.lmfdate,g_lmf.lmfacti,g_lmf.lmfcrat  ,
#                     g_lmf.lmflegal
#                    
#    INPUT BY NAME g_lmf.lmf01,g_lmf.lmfstore,g_lmf.lmf03,g_lmf.lmf04                 
#                  WITHOUT DEFAULTS
#  
#       BEFORE INPUT
#           LET g_before_input_done = FALSE  
#           CALL i141_set_entry(p_cmd)
#           CALL i141_set_no_entry(p_cmd)        
#           CALL i141_rtz13()
#           LET g_before_input_done = TRUE
#           
#       AFTER FIELD lmf01
#           IF NOT cl_null(g_lmf.lmf01) THEN          
#              IF p_cmd = "a" OR 
#                 (p_cmd="u" AND g_lmf.lmf01 != g_lmf01_t) THEN                       
#                  CALL i141_check_lmf01(g_lmf.lmf01) 
#                  IF g_success = 'N' THEN                                               
#                     LET g_lmf.lmf01 = g_lmf_t.lmf01                                                               
#                     DISPLAY BY NAME g_lmf.lmf01                                                                     
#                     NEXT FIELD lmf01                                                                                  
#                  END IF
#                END IF   
#             END IF         
#           
#   #    AFTER FIELD lmfstore      
#   #       CALL s_alm_valid(g_lmf.lmfstore,g_lmf.lmf03,g_lmf.lmf04,'','')
#   #         RETURNING l_rtz13,l_lmb03,l_lmc04       
#   #       IF NOT cl_null(g_errno) THEN 
#   #          CALL cl_err(g_lmf.lmfstore,g_errno,1)
#   #          NEXT FIELD lmfstore 
#   #       ELSE
#   #       	  DISPLAY l_rtz13 TO FORMONLY.rtz13
#   #       	  DISPLAY l_lmb03 TO FORMONLY.lmb03
#   #       	  DISPLAY l_lmc04 TO FORMONLY.lmc04         	  
#   #      END IF  	  
#                     
#       AFTER FIELD lmf03       
#    #       CALL s_alm_valid(g_lmf.lmfstore,g_lmf.lmf03,g_lmf.lmf04,'','')
#    #        RETURNING l_rtz13,l_lmb03,l_lmc04
#    #   IF NOT cl_null(g_errno) THEN 
#    #         CALL cl_err(g_lmf.lmf03,g_errno,1)
#    #         NEXT FIELD lmf03 
#    #      ELSE         
#    #      	  DISPLAY l_lmb03 TO FORMONLY.lmb03
#    #      	  DISPLAY l_rtz13 TO FORMONLY.rtz13
#    #      	  DISPLAY l_lmc04 TO FORMONLY.lmc04
#    #      END IF  	  
#           IF NOT cl_null(g_lmf.lmf03) THEN   
#             LET l_count  = 0 	  
#             SELECT COUNT(*) INTO l_count FROM lmb_file
#       #      WHERE lmb02 = g_lmf.lmf03                              #TQC-AB0230  mark
#              WHERE lmb02 = g_lmf.lmf03  AND lmbstore = g_lmf.lmfstore      #TQC-AB0230
#             IF l_count < 1 THEN 
#                CALL cl_err('','alm-003',1)
#                LET l_lmb03 = NULL
#                DISPLAY l_lmb03 TO FORMONLY.lmb03 
#                NEXT FIELD lmf03 
#             ELSE
#                SELECT lmb06 INTO l_lmb06 FROM lmb_file
#      #           WHERE lmb02 = g_lmf.lmf03                           #TQC-AB0230  mark
#                  WHERE lmb02 = g_lmf.lmf03 AND lmbstore = g_lmf.lmfstore      #TQC-AB0230
#                IF l_lmb06 = 'N' THEN  
#                   CALL cl_err('','alm-905',1)
#                   NEXT FIELD lmf03 
#                 ELSE
#                 	  SELECT lmb03,lmb06 INTO l_lmb03,l_lmb06
#                 	    FROM lmb_file
#                 	   WHERE lmbstore = g_lmf.lmfstore
#                 	     AND lmb02 = g_lmf.lmf03
#                 	   IF cl_null(l_lmb03) OR cl_null(l_lmb06) THEN    
#                 	      CALL cl_err('','alm-904',1)
#                 	      NEXT FIELD lmf03 
#                 	   ELSE
#                 	   	  DISPLAY l_lmb03 TO FORMONLY.lmb03 
#                 	   END IF 
#                END IF  
# #TQC-AB0230 ---------------------STA
#                IF NOT cl_null(g_lmf.lmf04) THEN                             #MOD-AC0254  add
#                   SELECT COUNT(*) INTO l_count FROM lmc_file
#                    WHERE lmc03 = g_lmf.lmf04 AND lmcstore = g_lmf.lmfstore AND lmc02 = g_lmf.lmf03
#                   IF l_count < 1 THEN
#                      CALL cl_err('','alm-847',1)
#                      NEXT FIELD lmf03
#                   END IF
#                END IF                                                       #MOD-AC0254  add
# #TQC-AB0230 ---------------------END
#             END IF   
#           ELSE
#           	  LET l_lmb03 = NULL
#           	  DISPLAY l_lmb03 TO FORMONLY.lmb03          	
#           END IF   
#       
#       BEFORE FIELD lmf04 
#         IF cl_null(g_lmf.lmf03) THEN 
#             CALL cl_err('','alm-553',1)
#             NEXT FIELD lmf03 
#          END IF 
#                                  
#       AFTER FIELD lmf04      
#          IF NOT cl_null(g_lmf.lmf04) THEN 
#            LET l_count = 0 
#            SELECT COUNT(*) INTO l_count FROM lmc_file
#  #           WHERE lmc03 = g_lmf.lmf04                      #TQC-AB0230 mark
#              WHERE lmc03 = g_lmf.lmf04 AND lmcstore = g_lmf.lmfstore AND lmc02 = g_lmf.lmf03     #TQC-AB0230
#             IF l_count < 1 THEN 
#                CALL cl_err('','alm-554',1)
#                LET l_lmc04 = NULL
#                DISPLAY l_lmc04 TO FORMONLY.lmc04 
#                NEXT FIELD lmf04 
#             ELSE
#             	 SELECT lmc04,lmc07 INTO l_lmc04,l_lmc07 FROM lmc_file
#             	  WHERE lmc03 = g_lmf.lmf04 
#                     AND lmcstore = g_lmf.lmfstore
#                     AND lmc02 = g_lmf.lmf03
#             	  IF l_lmc07 = 'N' OR l_lmc07 IS NULL THEN 
#             	     CALL cl_err('','alm-908',1)
#             	     NEXT FIELD lmf04 
#             	   ELSE
#             	       IF cl_null(l_lmc04) THEN 
#             	           CALL cl_err('','alm-907',1)
#             	           NEXT FIELD lmf04 
#             	        ELSE 
#             	           DISPLAY l_lmc04 TO FORMONLY.lmc04 
#             	        END IF            	           
#             	  END IF 
#             END IF 
#         ELSE
#         	  LET l_lmc04 = NULL
#         	  DISPLAY l_lmc04 TO FORMONLY.lmc04     
#         END IF	
#  
#      AFTER INPUT
#         IF INT_FLAG THEN
#            EXIT INPUT
#         END IF         
#   
#             
#      ON ACTION CONTROLP
#         CASE
#   #      WHEN INFIELD(lmfstore)
#   #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form = "q_lmc"  
#   #          LET g_qryparam.default1 = g_lmf.lmfstore
#   #          LET g_qryparam.default2 = g_lmf.lmf03
#   #          LET g_qryparam.default3 = g_lmf.lmf04
#   #          LET g_qryparam.default4 = l_lmc04            
#   #          LET g_qryparam.arg1 = g_plant
#   #          CALL cl_create_qry()
#   #                RETURNING g_lmf.lmfstore,g_lmf.lmf03,g_lmf.lmf04,l_lmc04
#   #          DISPLAY BY NAME g_lmf.lmfstore,g_lmf.lmf03,g_lmf.lmf04
#   #          NEXT FIELD lmfstore
#         
#         WHEN INFIELD(lmf03)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_lmc8"  
#             LET g_qryparam.arg1 = g_lmf.lmfstore
#             LET g_qryparam.default1 = g_lmf.lmf03
#             LET g_qryparam.default2 = g_lmf.lmf04
#             LET g_qryparam.default3 = l_lmc04     
#             CALL cl_create_qry()
#                   RETURNING g_lmf.lmf03,g_lmf.lmf04,l_lmc04
#             DISPLAY BY NAME g_lmf.lmf03,g_lmf.lmf04
#             NEXT FIELD lmf03
#             
#           WHEN INFIELD(lmf04)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_lmc9"  
#             LET g_qryparam.arg1 = g_lmf.lmfstore
#             LET g_qryparam.arg2 = g_lmf.lmf03
#             LET g_qryparam.default1 = g_lmf.lmf03
#             LET g_qryparam.default2 = g_lmf.lmf04
#             LET g_qryparam.default3 = l_lmc04     
#             CALL cl_create_qry()
#                   RETURNING g_lmf.lmf03,g_lmf.lmf04,l_lmc04
#             DISPLAY BY NAME g_lmf.lmf03,g_lmf.lmf04
#             NEXT FIELD lmf04          
#  
#           OTHERWISE
#             EXIT CASE
#         END CASE       
#       
#  
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
#  
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
#  
#      ON ACTION CONTROLF  
#         CALL cl_set_focus_form(ui.Interface.getRootNode())
#              RETURNING g_fld_name,g_frm_name 
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
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
#    END INPUT
# END FUNCTION
#FUN-B80141--------mark------end-----------

 
FUNCTION i141_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lmf.* TO NULL
    INITIALIZE g_lmf_t.* TO NULL
    INITIALIZE g_lmf_o.* TO NULL
    
    LET g_lmf01_t = NULL
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM                      #FUN-B80141----add
    CALL g_lie.clear()              #FUN-B80141----add
    CALL g_lml.clear()              #FUN-B80141----add
    DISPLAY '   ' TO FORMONLY.cnt
   
     
    CALL i141_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lmf.* TO NULL
       LET g_lmf01_t = NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN i141_count
    FETCH i141_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i141_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
       INITIALIZE g_lmf.* TO NULL
       LET g_lmf01_t = NULL
       LET g_wc = NULL
    ELSE
       CALL i141_fetch('F')
    END IF

END FUNCTION
 
FUNCTION i141_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     i141_cs INTO g_lmf.lmf01
        WHEN 'P' FETCH PREVIOUS i141_cs INTO g_lmf.lmf01
        WHEN 'F' FETCH FIRST    i141_cs INTO g_lmf.lmf01
        WHEN 'L' FETCH LAST     i141_cs INTO g_lmf.lmf01
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
            FETCH ABSOLUTE g_jump i141_cs INTO g_lmf.lmf01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
       INITIALIZE g_lmf.* TO NULL
       LET g_lmf01_t = NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_lmf.* FROM lmf_file  
     WHERE lmf01 = g_lmf.lmf01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lmf.lmfuser 
       LET g_data_group = g_lmf.lmfgrup
       CALL i141_show() 
    END IF
END FUNCTION
 
FUNCTION i141_show()
 
    LET g_lmf_t.* = g_lmf.*
    LET g_lmf_o.* = g_lmf.*
    LET g_lmf01_t = g_lmf.lmf01
    #FUN-B80141----mark---str-----
   #DISPLAY BY NAME g_lmf.lmf01,g_lmf.lmfstore,g_lmf.lmf03,g_lmf.lmf04,
   #                g_lmf.lmf05,g_lmf.lmf06,g_lmf.lmf07,g_lmf.lmf08,
   #                g_lmf.lmforig,g_lmf.lmfmodu,g_lmf.lmfuser,g_lmf.lmfgrup,g_lmf.lmforiu,
   #                g_lmf.lmfdate,g_lmf.lmfacti,g_lmf.lmfcrat,g_lmf.lmfstore
    #FUN-B80141----mark---end-----

    #FUN-B80141----add---str-----
    DISPLAY BY NAME g_lmf.lmf01,g_lmf.lmf15,g_lmf.lmfstore,g_lmf.lmflegal,g_lmf.lmf03,g_lmf.lmf04,
                    g_lmf.lmf09,g_lmf.lmf10,g_lmf.lmf11,g_lmf.lmf12,
                    g_lmf.lmf05,g_lmf.lmf06,g_lmf.lmf07,g_lmf.lmf08,g_lmf.lmf13,g_lmf.lmf14,  
                    g_lmf.lmfuser,g_lmf.lmfgrup,g_lmf.lmforiu,g_lmf.lmforig,g_lmf.lmfmodu,
                    g_lmf.lmfdate,g_lmf.lmfacti,g_lmf.lmfcrat
    #FUN-B80141----add---end----
    CALL i141_pic()       
    CALL cl_show_fld_cont() 
    CALL i141_bring()    
    CALL i141_rtz13()
    #FUN-B80141----add---str-----
    CALL i141_lmf()          
    CALL i141_b_fill(g_wc2)   
    CALL i141_b1_fill(g_wc3)   
    #FUN-B80141----add---end----
END FUNCTION

#FUN-B80141----add------str--------
FUNCTION i141_lmf()
 DEFINE l_gen02     LIKE gen_file.gen02
 DEFINE l_tqa02     LIKE tqa_file.tqa02

 DISPLAY '' TO FORMONLY.gen02
 DISPLAY '' TO FORMONLY.tqa02

 IF NOT cl_null(g_lmf.lmf07) THEN
    SELECT gen02 INTO l_gen02 FROM gen_file
     WHERE gen01 = g_lmf.lmf07 
    DISPLAY l_gen02 TO FORMONLY.gen02
 END IF

 IF NOT cl_null(g_lmf.lmf12) THEN
    SELECT tqa02 INTO l_tqa02 FROM tqa_file
     WHERE tqa01 = g_lmf.lmf12
       AND tqa03 = '30'
    DISPLAY l_tqa02 TO FORMONLY.tqa02
 END IF 

END FUNCTION

#FUN-B80141----add------end--------

 
FUNCTION i141_bring()
  DEFINE l_lmb03    LIKE lmb_file.lmb03
  DEFINE l_lmc04    LIKE lmc_file.lmc04
 
  DISPLAY '' TO FORMONLY.lmb03
  DISPLAY '' TO FORMONLY.lmc04
  
  IF NOT cl_null(g_lmf.lmf03) THEN 
     SELECT lmb03 INTO l_lmb03 FROM lmb_file
      WHERE lmb06 = 'Y'
        AND lmbstore = g_lmf.lmfstore
        AND lmb02 = g_lmf.lmf03
     DISPLAY l_lmb03 TO FORMONLY.lmb03   
  END IF 
  
  IF NOT cl_null(g_lmf.lmf04) THEN 
      SELECT lmc04 INTO l_lmc04 FROM lmc_file
       WHERE lmc07 = 'Y'
         AND lmcstore = g_lmf.lmfstore
         AND lmc02 = g_lmf.lmf03
         AND lmc03 = g_lmf.lmf04
      DISPLAY l_lmc04 TO FORMONLY.lmc04   
  END IF 
END FUNCTION 

#FUN-B80141-----mark-------str------------
#  FUNCTION i141_u(p_w)
#  DEFINE p_w   LIKE type_file.chr1
#   
#      IF cl_null(g_lmf.lmf01) THEN
#         CALL cl_err('',-400,0)
#         RETURN
#      END IF    
#    
#      IF g_lmf.lmf06 = 'Y' THEN
#         CALL cl_err(g_lmf.lmf01,'alm-027',1)
#         RETURN
#      END IF 
#      
#      IF g_lmf.lmf06 = 'X' THEN
#         CALL cl_err(g_lmf.lmf01,'alm-134',1)
#         RETURN
#      END IF 
#      SELECT * INTO g_lmf.* FROM lmf_file WHERE lmf01=g_lmf.lmf01
#   
#      IF g_lmf.lmfacti = 'N' THEN
#         CALL cl_err(g_lmf.lmf01,9027,0)
#         RETURN
#      END IF
#      
#      MESSAGE ""
#      CALL cl_opmsg('u')
#      LET g_lmf01_t = g_lmf.lmf01
#      BEGIN WORK
#   
#      OPEN i141_cl USING g_lmf.lmf01
#      IF STATUS THEN
#         CALL cl_err("OPEN i141_cl:",STATUS,1)
#         CLOSE i141_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#      FETCH i141_cl INTO g_lmf.*  
#      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,1)
#         CLOSE i141_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#   
#      #####記住當前的lmfdate lmfmodu，若修改資料中
#      #####突然退出修改,則即時顯示修改前的date modu
#      LET g_date = g_lmf.lmfdate
#      LET g_modu = g_lmf.lmfmodu
#      #############
#   
#      IF p_w != 'c' THEN            ###'c'代表_copy 
#         LET g_lmf.lmfmodu = g_user  
#         LET g_lmf.lmfdate = g_today 
#      ELSE
#         LET g_lmf.lmfmodu = NULL  
#         LET g_lmf.lmfdate =  NULL   
#      END IF    
#      CALL i141_show()                 
#      WHILE TRUE
#          CALL i141_i("u")          
#          IF INT_FLAG THEN
#             LET INT_FLAG = 0
#             LET g_lmf_t.lmfdate = g_date
#             LET g_lmf_t.lmfmodu = g_modu           
#             LET g_lmf.*=g_lmf_t.*
#             CALL i141_show()
#             CALL cl_err('',9001,0)        
#             EXIT WHILE
#          END IF
#   
#         UPDATE lmf_file SET lmf_file.* = g_lmf.* 
#          WHERE lmf01 = g_lmf01_t
#          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
#             CONTINUE WHILE
#          END IF
#          EXIT WHILE
#      END WHILE
#      CLOSE i141_cl
#      COMMIT WORK
#  END FUNCTION
#   
#  FUNCTION i141_x()
#      IF cl_null(g_lmf.lmf01) THEN
#         CALL cl_err('',-400,0)
#         RETURN
#      END IF
#      
#      IF g_lmf.lmf06 = 'Y' THEN 
#         CALL cl_err(g_lmf.lmf01,'alm-027',1)
#         RETURN 
#      END IF 
#      
#      IF g_lmf.lmf06 = 'X' THEN 
#         CALL cl_err(g_lmf.lmf01,'alm-134',1)
#         RETURN 
#      END IF 
#      BEGIN WORK
#   
#      OPEN i141_cl USING g_lmf.lmf01
#      IF STATUS THEN
#         CALL cl_err("OPEN i141_cl:",STATUS,1)
#         CLOSE i141_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#      FETCH i141_cl INTO g_lmf.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,1)
#         CLOSE i141_cl
#         ROLLBACK WORK  
#         RETURN
#      END IF
#      CALL i141_show()
#      IF cl_exp(0,0,g_lmf.lmfacti) THEN
#         LET g_chr=g_lmf.lmfacti
#         IF g_lmf.lmfacti='Y' THEN
#            LET g_lmf.lmfacti='N'
#            LET g_lmf.lmfmodu = g_user
#            LET g_lmf.lmfdate = g_today          
#         ELSE
#            LET g_lmf.lmfacti='Y'
#            LET g_lmf.lmfmodu = g_user
#            LET g_lmf.lmfdate = g_today
#         END IF
#         UPDATE lmf_file SET lmfacti = g_lmf.lmfacti,
#                             lmfmodu = g_lmf.lmfmodu,
#                             lmfdate = g_lmf.lmfdate
#          WHERE lmf01 = g_lmf.lmf01
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
#            LET g_lmf.lmfacti = g_chr
#            DISPLAY BY NAME g_lmf.lmfacti
#            CLOSE i141_cl
#            ROLLBACK WORK
#            RETURN 
#         END IF
#         CALL i141_pic()
#         DISPLAY BY NAME g_lmf.lmfmodu,g_lmf.lmfdate,g_lmf.lmfacti
#      END IF
#      CLOSE i141_cl
#      COMMIT WORK
#  END FUNCTION
#   
#  FUNCTION i141_r()
#  DEFINE l_count            LIKE type_file.num5 
#   
#      IF cl_null(g_lmf.lmf01) THEN
#         CALL cl_err('',-400,0)
#         RETURN
#      END IF
#      
#      IF g_lmf.lmf06 = 'Y' THEN 
#         CALL cl_err(g_lmf.lmf01,'alm-028',1)
#         RETURN 
#      END IF 
#      IF g_lmf.lmfacti = 'N' THEN 
#         CALL cl_err('','alm-147',0)
#         RETURN 
#      END IF 
#      IF g_lmf.lmf06 = 'X' THEN 
#         CALL cl_err(g_lmf.lmf01,'alm-134',1)
#         RETURN 
#      END IF 
#      BEGIN WORK
#   
#      OPEN i141_cl USING g_lmf.lmf01
#      IF STATUS THEN
#         CALL cl_err("OPEN i141_cl:",STATUS,0)
#         CLOSE i141_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#      FETCH i141_cl INTO g_lmf.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
#         CLOSE i141_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#      CALL i141_show()
#      IF cl_delete() THEN
#          INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
#          LET g_doc.column1 = "lmf01"         #No.FUN-9B0098 10/02/24
#          LET g_doc.value1 = g_lmf.lmf01      #No.FUN-9B0098 10/02/24
#          CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
#         SELECT COUNT(lmf01) INTO l_count 
#           FROM lmf_file,rtz_file
#          WHERE rtz01 = g_lmf.lmfstore
#            AND rtz01 = lmfstore
#          UPDATE rtz_file
#             SET rtz24 = l_count - 1 
#           WHERE rtz01 = g_lmf.lmfstore
#        #No.TQC-A30075 -BEGIN-----
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('upd_rtz',SQLCA.SQLCODE,0)
#            CLOSE i141_cl
#            ROLLBACK WORK
#            RETURN
#         END IF
#        #No.TQC-A30075 -END-------
#         DELETE FROM lmf_file WHERE lmf01 = g_lmf.lmf01
#         
#         CLEAR FORM
#         OPEN i141_count
#         #FUN-B50063-add-start--
#         IF STATUS THEN
#            CLOSE i141_cs
#            CLOSE i141_count
#            COMMIT WORK
#            RETURN
#         END IF
#         #FUN-B50063-add-end--
#         FETCH i141_count INTO g_row_count
#         #FUN-B50063-add-start--
#         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
#            CLOSE i141_cs
#            CLOSE i141_count
#            COMMIT WORK
#            RETURN
#         END IF
#         #FUN-B50063-add-end--
#         DISPLAY g_row_count TO FORMONLY.cnt
#         OPEN i141_cs
#         IF g_curs_index = g_row_count + 1 THEN
#            LET g_jump = g_row_count
#            CALL i141_fetch('L')
#         ELSE
#            LET g_jump = g_curs_index
#            LET g_no_ask = TRUE
#            CALL i141_fetch('/')
#         END IF
#      END IF
#      CLOSE i141_cl
#      COMMIT WORK
#  END FUNCTION
#   
#  FUNCTION i141_copy()
#  DEFINE l_newno   LIKE lmf_file.lmf01
#  DEFINE l_oldno   LIKE lmf_file.lmf01
#  DEFINE l_count   LIKE type_file.num5 
#    
#      IF cl_null(g_lmf.lmf01) THEN
#         CALL cl_err('',-400,0)
#         RETURN
#      END IF
#   
#      SELECT COUNT(*) INTO l_count FROM rtz_file
#       WHERE rtz01 = g_plant
#       IF l_count < 1 THEN 
#           CALL cl_err('','alm-559',1)
#           RETURN
#       END IF     
#   
#      LET g_before_input_done = FALSE
#      CALL i141_set_entry('a')
#      LET g_before_input_done = TRUE
#   
#      INPUT l_newno FROM lmf01
#   
#          AFTER FIELD lmf01 
#            IF NOT cl_null(l_newno) THEN
#               CALL i141_check_lmf01(l_newno)
#               IF g_success = 'N' THEN                                           
#                    LET g_lmf.lmf01 = g_lmf_t.lmf01                                       
#                    DISPLAY BY NAME g_lmf.lmf01                                                   
#                    NEXT FIELD lmf01                                                                
#               END IF  
#            ELSE 
#              CALL cl_err(l_newno,'alm-038',1)
#              NEXT FIELD lmf01    
#            END IF
#   
#         AFTER INPUT
#            IF INT_FLAG THEN
#               EXIT INPUT
#            END IF        
#          
#            
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#   
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
#   
#         ON ACTION about 
#            CALL cl_about() 
#   
#         ON ACTION help 
#            CALL cl_show_help() 
#    
#         ON ACTION controlg 
#            CALL cl_cmdask() 
#   
#   
#      END INPUT
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         DISPLAY BY NAME g_lmf.lmf01
#         RETURN
#      END IF
#   
#      DROP TABLE x
#      SELECT * FROM lmf_file
#       WHERE lmf01 = g_lmf.lmf01
#        INTO TEMP x
#      UPDATE x
#          SET lmf01  = l_newno,  
#              lmfstore  = g_plant,
#              lmfacti= 'Y',     
#              lmfuser= g_user, 
#              lmfgrup= g_grup, 
#              lmfmodu= NULL, 
#              lmfdate= NULL,
#              lmfcrat= g_today,
#              lmf06  = 'N',  
#              lmf07  = NULL,
#              lmf08  = NULL
#      INSERT INTO lmf_file SELECT * FROM x
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err(l_newno,SQLCA.sqlcode,0)
#      ELSE
#         MESSAGE 'ROW(',l_newno,') O.K'
#         LET l_oldno = g_lmf.lmf01
#         LET g_lmf.lmf01 = l_newno
#   
#         SELECT lmf_file.* INTO g_lmf.*
#           FROM lmf_file
#          WHERE lmf01 = l_newno
#   
#         CALL i141_u('c')
#   
#          UPDATE rtz_file
#             SET rtz24 = rtz24 + 1 
#           WHERE rtz01 = g_lmf.lmfstore
#         #No.TQC-A30075 -BEGIN-----
#          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err('upd_rtz',SQLCA.SQLCODE,0)
#          END IF
#         #No.TQC-A30075 -END-------
#        
#         SELECT lmf_file.* INTO g_lmf.*
#           FROM lmf_file
#          WHERE lmf01 = l_oldno
#      END IF
#      LET g_lmf.lmf01 = l_oldno
#      CALL i141_show()
#  END FUNCTION
#FUN-B80141-----mark-------end------------ 
#FUN-B80141-----add--------str------------
FUNCTION i141_b_fill(p_wc2)
 
    DEFINE p_wc2       STRING
 
 
    LET g_sql = "SELECT lie02,lie03,'',lie04,'',lie05,lie06,lie07,lieacti ",
                "  FROM lie_file ",   
                " WHERE lie01 ='",g_lmf.lmf01,"' ",
                "   AND liestore ='",g_lmf.lmfstore,"' "
 
    IF NOT cl_null(p_wc2) THEN                                                   
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED                             
    END IF                                                                       
       LET g_sql=g_sql CLIPPED," ORDER BY lie02"            
    DISPLAY g_sql             
 
    PREPARE i141_pb FROM g_sql
    DECLARE lie_cs CURSOR FOR i141_pb
 
    CALL g_lie.clear()
    LET g_rec_b=0    
    LET g_cnt = 1
 
    FOREACH lie_cs INTO g_lie[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      SELECT lmc04 INTO g_lie[g_cnt].lmc04_1 FROM lmc_file WHERE lmc02 = g_lmf.lmf03 AND lmc03 = g_lie[g_cnt].lie03 AND lmcstore = g_lmf.lmfstore
      SELECT lmy04 INTO g_lie[g_cnt].lmy04 FROM lmy_file WHERE lmy01 = g_lmf.lmf03 AND  lmy02 = g_lie[g_cnt].lie03 AND lmy03 = g_lie[g_cnt].lie04 AND lmystore = g_lmf.lmfstore
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
      END IF
    END FOREACH
    CALL g_lie.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    LET g_cnt = 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL i141_bp_refresh()
 
END FUNCTION

FUNCTION i141_bp_refresh()
  DISPLAY ARRAY g_lie TO s_lie.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION i141_b1_fill(p_wc3)             
    DEFINE p_wc3           STRING 
 
    LET g_sql = "SELECT lml02,'',lml06",
                "  FROM lml_file",
                " WHERE lml01 ='",g_lmf.lmf01,"' ",
                "   AND lmlstore = '",g_lmf.lmfstore,"' "

    IF NOT cl_null(p_wc3) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc3 CLIPPED
    END IF
       LET g_sql=g_sql CLIPPED," ORDER BY lml02"
    DISPLAY g_sql

    PREPARE i141_pd FROM g_sql
    DECLARE lml_curs CURSOR FOR i141_pd

    CALL g_lml.clear()
    LET g_rec_b1=0
    LET g_cnt = 1

    FOREACH lml_curs INTO g_lml[g_cnt].*   
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH 
        END IF
        
        SELECT oba02 INTO g_lml[g_cnt].oba02 FROM oba_file WHERE oba01 = g_lml[g_cnt].lml02 

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_lml.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn3
    CALL i141_bp1_refresh()

END FUNCTION

FUNCTION i141_bp1_refresh()
  DISPLAY ARRAY g_lml TO s_lml.* ATTRIBUTE(COUNT = g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
#FUN-B80141-----add--------end------------

FUNCTION i141_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lmf01",TRUE)
      CALL cl_set_comp_entry("lmfstore",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i141_check_lmf01(p_cmd)
 DEFINE p_cmd    LIKE lmf_file.lmf01
 DEFINE l_count  LIKE type_file.num10
 
 SELECT COUNT(lmf01) INTO l_count FROM lmf_file
  WHERE lmf01 = p_cmd
  
 IF l_count > 0 THEN
    CALL cl_err(p_cmd,'alm-037',1)
    DISPLAY '' TO lmf01 
    LET g_success = 'N'
 ELSE
 	  LET g_success = 'Y'   
 END IF 
 
END FUNCTION 
 
FUNCTION i141_set_no_entry(p_cmd)                                                       
 DEFINE   p_cmd     LIKE type_file.chr1                                                         
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN                         
       CALL cl_set_comp_entry("lmf01",FALSE)                                               
   END IF     

   IF p_cmd = 'q' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("lie03",FALSE)
   END IF                                         
END FUNCTION


#FUN-B80141------mark------str------------
#FUNCTION i141_confirm()
#   DEFINE l_lmf07         LIKE lmf_file.lmf07
#   DEFINE l_lmf08         LIKE lmf_file.lmf08 
#  
#   IF cl_null(g_lmf.lmf01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_lmf.* FROM lmf_file
#    WHERE lmf01 = g_lmf.lmf01
#   
#    LET l_lmf07 = g_lmf.lmf07
#    LET l_lmf08 = g_lmf.lmf08
#  
#   IF g_lmf.lmfacti ='N' THEN
#      CALL cl_err(g_lmf.lmf01,'alm-004',1)
#      RETURN
#   END IF
#   IF g_lmf.lmf06 = 'Y' THEN
#      CALL cl_err(g_lmf.lmf01,'alm-005',1)
#      RETURN
#   END IF
#   
#   IF g_lmf.lmf06 = 'X' THEN
#      CALL cl_err(g_lmf.lmf01,'alm-134',1)
#      RETURN
#   END IF
#   BEGIN WORK
# 
#   OPEN i141_cl USING g_lmf.lmf01
#   IF STATUS THEN
#      CALL cl_err("OPEN i141_cl:",STATUS,0)
#      CLOSE i141_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH i141_cl INTO g_lmf.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
#      CLOSE i141_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#    
#   IF NOT cl_confirm("alm-006") THEN
#       RETURN
#   ELSE
#   	  LET g_lmf.lmf06 = 'Y'
#      LET g_lmf.lmf07 = g_user
#      LET g_lmf.lmf08 = g_today
#      UPDATE lmf_file
#         SET lmf06 = g_lmf.lmf06,
#             lmf07 = g_lmf.lmf07,
#             lmf08 = g_lmf.lmf08
#       WHERE lmf01 = g_lmf.lmf01
#       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('upd lmf:',SQLCA.SQLCODE,0)
#         LET g_lmf.lmf06 = "N"
#         LET g_lmf.lmf07 = l_lmf07
#         LET g_lmf.lmf08 = l_lmf08
#         DISPLAY BY NAME g_lmf.lmf06,g_lmf.lmf07,g_lmf.lmf08
#         RETURN
#       ELSE
#         DISPLAY BY NAME g_lmf.lmf06,g_lmf.lmf07,g_lmf.lmf08
#       END IF
#    END IF 
#   CLOSE i141_cl
#   COMMIT WORK      
#END FUNCTION
# 
#FUNCTION i141_unconfirm()
#   DEFINE l_n LIKE type_file.num5
#   DEFINE l_lmf07         LIKE lmf_file.lmf07
#   DEFINE l_lmf08         LIKE lmf_file.lmf08
#   DEFINE l_count         LIKE type_file.num5
#   DEFINE l_count1        LIKE type_file.num5
#    
#   IF cl_null(g_lmf.lmf01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_lmf.* FROM lmf_file
#    WHERE lmf01 = g_lmf.lmf01
#  
#    LET l_lmf07 = g_lmf.lmf07
#    LET l_lmf08 = g_lmf.lmf08
#  
#   IF g_lmf.lmfacti ='N' THEN
#      CALL cl_err(g_lmf.lmf01,'alm-004',1)
#      RETURN
#   END IF
# 
#   IF g_lmf.lmf06 = 'N' THEN
#      CALL cl_err(g_lmf.lmf01,'alm-007',1)
#      RETURN
#   END IF
#   IF g_lmf.lmf06 = 'X' THEN
#      CALL cl_err(g_lmf.lmf01,'alm-134',1)
#      RETURN
#   END IF
#    BEGIN WORK
# 
#    OPEN i141_cl USING g_lmf.lmf01
#    IF STATUS THEN
#       CALL cl_err("OPEN i141_cl:",STATUS,0)
#       CLOSE i141_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH i141_cl INTO g_lmf.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
#       CLOSE i141_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    
#    ###################
#   SELECT COUNT(*) INTO l_count
#     FROM lmf_file,lmg_file,lmh_file
#    WHERE lmh01 = lmg01
#      AND lmh02 = g_lmf.lmf01
#      AND lmf03 = lmg04
#      AND lmf04 = lmg05
#      AND lmh03 IS NOT NULL 
#      
#   IF l_count > 0 THEN
#      CALL cl_err(g_lmf.lmf01,'alm-039',1)
#      RETURN 
#   END IF     
#   
#   SELECT COUNT(*) INTO l_count1 
#     FROM lmf_file,lml_file
#    WHERE lml01 = g_lmf.lmf01
#      AND lmfstore = lmlstore
#      AND lmf03 = lml04
#      AND lmf04 = lml05
#      AND lml02 IS NOT NULL 
#      
#   IF l_count > 0 THEN
#      CALL cl_err(g_lmf.lmf01,'alm-043',1)
#      RETURN 
#   END IF         
#   #####################  
#   IF NOT cl_confirm('alm-008') THEN
#      RETURN
#   ELSE
#       LET g_lmf.lmf06 = 'N'
#       LET g_lmf.lmf07 = NULL 
#       LET g_lmf.lmf08 = NULL
#       LET g_lmf.lmfmodu = g_user
#       LET g_lmf.lmfdate = g_today
#       UPDATE lmf_file
#          SET lmf06 = g_lmf.lmf06,
#              lmf07 = g_lmf.lmf07,
#              lmf08 = g_lmf.lmf08,
#              lmfmodu = g_lmf.lmfmodu,
#              lmfdate = g_lmf.lmfdate
#        WHERE lmf01 = g_lmf.lmf01
#        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err('upd lmf:',SQLCA.SQLCODE,0)
#          LET g_lmf.lmf06 = "Y"
#          LET g_lmf.lmf07 = l_lmf07
#          LET g_lmf.lmf08 = l_lmf08
#          DISPLAY BY NAME g_lmf.lmf06,g_lmf.lmf07,g_lmf.lmf08
#          RETURN
#         ELSE
#            DISPLAY BY NAME g_lmf.lmf06,g_lmf.lmf07,g_lmf.lmf08,g_lmf.lmfmodu,g_lmf.lmfdate
#         END IF
#   END IF  
#   CLOSE i141_cl
#   COMMIT WORK  
#END FUNCTION
#FUN-B80141-------mark-----end-------------- 
FUNCTION i141_pic()
   CASE g_lmf.lmf06
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = 'X'   #FUN-B80141 add
                LET g_void    = 'Y'   #FUN-B80141 add

#      WHEN 'X'  LET g_confirm = ''    #FUN-B80141 mark
#                LET g_void    = 'Y'   #FUN-B80141 mark
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lmf.lmfacti)
END FUNCTION
 
FUNCTION i141_v()
   IF cl_null(g_lmf.lmf01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lmf.* FROM lmf_file
    WHERE lmf01 = g_lmf.lmf01
 
   IF g_lmf.lmfacti ='N' THEN
      CALL cl_err(g_lmf.lmf01,'alm-084',0)
      RETURN
   END IF
 
   IF g_lmf.lmf06 = 'Y' THEN
      CALL cl_err(g_lmf.lmf01,'9023',0)
      RETURN
   END IF
 BEGIN WORK
 
    OPEN i141_cl USING g_lmf.lmf01
    IF STATUS THEN
       CALL cl_err("OPEN i141_cl:",STATUS,0)
       CLOSE i141_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i141_cl INTO g_lmf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmf.lmf01,SQLCA.sqlcode,0)
       CLOSE i141_cl
       ROLLBACK WORK
       RETURN
    END IF
   IF g_lmf.lmf06 != 'Y' THEN
      IF g_lmf.lmf06 = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
            LET g_lmf.lmf06 = 'N'
            LET g_lmf.lmfmodu = g_user
            LET g_lmf.lmfdate = g_today
            UPDATE lmf_file
               SET lmf06   = g_lmf.lmf06,
                   lmfmodu = g_lmf.lmfmodu,
                   lmfdate = g_lmf.lmfdate
             WHERE lmf01   = g_lmf.lmf01
 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lmf:',SQLCA.SQLCODE,0)
               LET g_lmf.lmf06 = "X"
               DISPLAY BY NAME g_lmf.lmf06
               RETURN
            ELSE
               DISPLAY BY NAME g_lmf.lmf06,g_lmf.lmfmodu,g_lmf.lmfdate
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lmf.lmf06 = 'X'
            LET g_lmf.lmfmodu = g_user
            LET g_lmf.lmfdate = g_today
            UPDATE lmf_file
               SET lmf06   = g_lmf.lmf06,
                   lmfmodu = g_lmf.lmfmodu,
                   lmfdate = g_lmf.lmfdate
             WHERE lmf01   = g_lmf.lmf01
 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lmf:',SQLCA.SQLCODE,0)
               LET g_lmf.lmf06 = "N"
               DISPLAY BY NAME g_lmf.lmf06
               RETURN
            ELSE
               DISPLAY BY NAME g_lmf.lmf06,g_lmf.lmfmodu,g_lmf.lmfdate
            END IF
         END IF
      END IF
   END IF
CLOSE i141_cl
COMMIT WORK 
END FUNCTION 
 
FUNCTION i141_rtz13()
 DEFINE l_rtz13   LIKE rtz_file.rtz13 
 DEFINE l_azt02   LIKE azt_file.azt02
 
   LET l_rtz13 = NULL 
   IF NOT cl_null(g_lmf.lmfstore) THEN 
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01 = g_lmf.lmfstore
         AND rtz28 = 'Y'
      DISPLAY l_rtz13 TO FORMONLY.rtz13   
   ELSE
      DISPLAY '' TO FORMONLY.rtz13 
   END IF 
 
   SELECT azt02 INTO l_azt02 FROM azt_file
    WHERE azt01 = g_lmf.lmflegal
   DISPLAY l_azt02 TO FORMONLY.azt02
END FUNCTION
#FUN-A60064 10/06/24 By chenls 非T/S類ta

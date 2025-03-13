# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: almq619.4gl
# Descriptions...: 
# Date & Author..: 09/10/19 By dxfwo
# Modify.........: No:FUN-960081 09/10/22 by dxfwo 栏位的添加与删除
# Modify.........: No:TQC-A10140 10/01/21 By shiwuying 去掉自動帶出單身
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsn08交易門店字段
# Modify.........: No.FUN-BC0112 12/01/05 By zhuhao 新增加值金額欄位
# Modify.........: No:FUN-BA0068 11/10/25 By pauline 刪除lsn08欄位,增加lsnlegal,lsnplant
# Modify.........: No:FUN-C40018 12/04/16 By pauline 提供儲值卡註銷串查
# Modify.........: No:FUN-C30176 12/06/16 By pauline 將'金額有效期' 欄位隱藏,欄位順序調整
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C90102 12/10/29 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代

DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-960081
DEFINE
     g_lsn          DYNAMIC ARRAY OF RECORD   
        lsn01       LIKE lsn_file.lsn01,   
        lsn10       LIKE lsn_file.lsn10,                 #FUN-C70045 add
       #lsn08       LIKE lsn_file.lsn08, #No.FUN-A70118  #FUN-BA0068 mark
        lsn02       LIKE lsn_file.lsn02,
        lsn03       LIKE lsn_file.lsn03,
        lsn05       LIKE lsn_file.lsn05,    #FUN-C30176 add
        lsn04       LIKE lsn_file.lsn04,
       #lsn05       LIKE lsn_file.lsn05,    #FUN-C30176 mark 
        lsn06       LIKE lsn_file.lsn06,
        lsn09       LIKE lsn_file.lsn09, #No.FUN-BC0112
        lsn07       LIKE lsn_file.lsn07,
       #lsnplant    LIKE lsn_file.lsnplant       #FUN-BA0068 add     #FUN-C90102 mark    
        lsnstore    LIKE lsn_file.lsnstore     #FUN-C90102 add
                    END RECORD,
    g_lsn_t         RECORD                
        lsn01       LIKE lsn_file.lsn01,   
        lsn10       LIKE lsn_file.lsn10,                 #FUN-C70045 add
       #lsn08       LIKE lsn_file.lsn08, #No.FUN-A70118  #FUN-BA0068 mark
        lsn02       LIKE lsn_file.lsn02,
        lsn03       LIKE lsn_file.lsn03,
        lsn05       LIKE lsn_file.lsn05,    #FUN-C30176 add
        lsn04       LIKE lsn_file.lsn04,
       #lsn05       LIKE lsn_file.lsn05,    #FUN-C30176 mark
        lsn06       LIKE lsn_file.lsn06,
        lsn09       LIKE lsn_file.lsn09, #No.FUN-BC0112
        lsn07       LIKE lsn_file.lsn07,
       #lsnplant    LIKE lsn_file.lsnplant       #FUN-BA0068 add   #FUN-C90102 mark 
        lsnstore    LIKE lsn_file.lsnstore   #FUN-C90102 add 
                    END RECORD,
        g_wc2,g_sql STRING,
        g_rec_b     LIKE type_file.num5, 
        l_ac        LIKE type_file.num5 

DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_cnt        LIKE type_file.num10
DEFINE  g_argv1      LIKE lsn_file.lsn01   #FUN-C40018 add
MAIN
 DEFINE p_row,p_col  LIKE type_file.num5
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

   CALL  cl_used(g_prog,g_time,1)  
         RETURNING g_time    #No.FUN-6A0081
       LET p_row = 4 LET p_col = 20
   OPEN WINDOW q619_w AT p_row,p_col WITH FORM "alm/42f/almq619"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_visible("lsn06",FALSE)   #FUN-C30176 add

   LET g_argv1 = ARG_VAL(1)   #儲值卡號  #FUN-C40018 add
 # LET g_wc2 = '1=1' CALL q619_b_fill(g_wc2) #No.TQC-A10140
  #FUN-C40018 add START
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = " lsn01 = '",g_argv1 CLIPPED,"'" 
      CALL q619_b_fill(g_wc2) 
   END IF  
  #FUN-C40018 add END
   CALL q619_menu()
   CLOSE WINDOW q619_w                
   CALL  cl_used(g_prog,g_time,2)      
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION q619_menu()
  DEFINE l_cmd STRING
   WHILE TRUE
      CALL q619_bp("G")
      CASE g_action_choice
         WHEN "query"       
            IF cl_null(g_argv1) THEN  #FUN-C40018 add
               IF cl_chk_act_auth() THEN
                  CALL q619_q()
               END IF
            END IF   #FUN-C40018 add
         WHEN "output"      
            IF cl_chk_act_auth() THEN
               #CALL q619_out()
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF
               LET l_cmd='p_query "aooq619" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"       
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO:FUN-570199
               IF g_lsn[l_ac].lsn01 IS NOT NULL THEN
                  LET g_doc.column1 = "lsn01"
                  LET g_doc.value1 = g_lsn[l_ac].lsn01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lsn),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION q619_q()
   CALL q619_b_askkey()
END FUNCTION

FUNCTION q619_b_askkey()

    CLEAR FORM
    CALL g_lsn.clear()

   #CONSTRUCT g_wc2 ON lsn01,lsn08,lsn02,lph03,lsn04,lsn05,lsn06,lsn09,lsn07 #No.FUN-A70118   #No.FUN-BC0112 add lsn09  #FUN-BA0068 mark
   #CONSTRUCT g_wc2 ON lsn01,lsn02,lph03,lsn04,lsn05,lsn06,lsn09,lsn07,lsnplant   #FUN-BA0068 add  #FUN-C40018 mark 
#   CONSTRUCT g_wc2 ON lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn09,lsn07,lsnplant   #FUN-BA0068 add  #FUN-C40018 add  #FUN-C70045 mark
   #CONSTRUCT g_wc2 ON lsn01,lsn10,lsn02,lsn03,lsn05,lsn04,lsn06,lsn09,lsn07,lsnplant  #FUN-C70045 add  #FUN-C90102 mark 
    CONSTRUCT g_wc2 ON lsn01,lsn10,lsn02,lsn03,lsn05,lsn04,lsn06,lsn09,lsn07,lsnstore    #FUN-C90102 add 
        #FROM s_lsn[1].lsn01,s_lsn[1].lsn08,s_lsn[1].lsn02,            #No.FUN-A70118  #FUN-BA0068 mark
#        FROM s_lsn[1].lsn01,s_lsn[1].lsn02,  #FUN-BA0068 add          #FUN-C70045 mark
         FROM s_lsn[1].lsn01,s_lsn[1].lsn10,s_lsn[1].lsn02,            #FUN-C70045 add 
#             s_lsn[1].lsn03,s_lsn[1].lsn04,                           #FUN-C70045 mark
#             s_lsn[1].lsn05,s_lsn[1].lsn06,                           #FUN-C70045 mark
              s_lsn[1].lsn03,s_lsn[1].lsn05,s_lsn[1].lsn04,s_lsn[1].lsn06,  #FUN-C70045 add 
              s_lsn[1].lsn09,               #No.FUN-BC0112
             #s_lsn[1].lsn07, s_lsn[1].lsnplant   #FUN-BA0068 add plant  #FUN-C90102 mark 
              s_lsn[1].lsn07, s_lsn[1].lsnstore   #FUN-BA0068 add plant  #FUN-C90102 add
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
          CASE
            WHEN INFIELD(lsn01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsn01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsn01
               NEXT FIELD lsn01   
            WHEN INFIELD(lsn03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsn03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsn03
               NEXT FIELD lsn03
       #FUN-BA0068 add START
           #FUN-C90102 mark START
           #WHEN INFIELD(lsnplant)
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.state = 'c'
           #   LET g_qryparam.form ="q_lsn04"
           #   CALL cl_create_qry() RETURNING g_qryparam.multiret
           #   DISPLAY g_qryparam.multiret TO lsnplant
           #   NEXT FIELD lsnplant
           #FUN-C90102 mark END
           #FUN-C90102 add START
            WHEN INFIELD(lsnstore)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsn04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsnstore
               NEXT FIELD lsnstore
           #FUN-C90102 add END
       #FUN-BA0068 add START
       #FUN-BA0068 mark START
       #   #No.FUN-A70118 -BEGIN-----
       #    WHEN INFIELD(lsn08)
       #       CALL cl_init_qry_var()
       #       LET g_qryparam.state = 'c'
       #       LET g_qryparam.form ="q_lsn08"
       #       CALL cl_create_qry() RETURNING g_qryparam.multiret
       #       DISPLAY g_qryparam.multiret TO lsn08
       #       NEXT FIELD lsn08
       #   #No.FUN-A70118 -END-------
       #FUN-BA0068 mark END
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('lsnuser', 'lsngrup') #FUN-980030

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

    CALL q619_b_fill(g_wc2)

END FUNCTION

FUNCTION q619_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000  
DEFINE l_sql        STRING           #FUN-BA0068 add
#DEFINE l_plant      LIKE zxy_file.zxy03  #FUN-BA0068 add  #FUN-C90102 mark 

#FUN-BA0068 add START
  CALL g_lsn.clear()
  LET g_cnt = 1
 #FUN-C90102 mark START
 #LET l_sql = " SELECT azw01 FROM azw_file WHERE azw02 = '",g_legal,"'"
 #PREPARE q619_db FROM l_sql
 #DECLARE q619_cdb CURSOR FOR q619_db
 #FOREACH q619_cdb INTO l_plant
 #FUN-C90102 mark END
#FUN-BA0068 add END

    LET g_sql =
       #"SELECT lsn01,lsn08,lsn02,lsn03,lsn04,lsn05,lsn06,lsn09,lsn07 ", #No.FUN-A70118  #No.FUN-BC0112 add lsn09  #FUN-BA0068 mark
       #"SELECT lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn09,lsn07,lsnplant ",  #FUN-BA0068 add  #FUN-C30176 mark
       #"SELECT lsn01,lsn10,lsn02,lsn03,lsn05,lsn04,lsn06,lsn09,lsn07,lsnplant ",  #FUN-C30176 add  #FUN-C70045 add lsn10  #FUN-C90102 mark 
        "SELECT lsn01,lsn10,lsn02,lsn03,lsn05,lsn04,lsn06,lsn09,lsn07,lsnstore ",  #FUN-C90102 add
       #" FROM lsn_file",  #FUN-BA0068 mark
       #" FROM ",cl_get_target_table(l_plant,'lsn_file'),  #FUN-BA0068 add  #FUN-C90102 mar 
        " FROM lsn_file ",  #FUN-C90102 add 
        " WHERE ", p_wc2 CLIPPED,                     
       #" AND (lsnplant = '",l_plant,"')",   #FUN-BA0068 add   #FUN-C90102 mark 
        " ORDER BY lsn01"
      #FUN-C90102 mark START
      #CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-BA0068 add
      #CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql      #FUN-BA0068 add
      #FUN-C90102 mark END
 
       PREPARE q619_pb FROM g_sql
       DECLARE lsn_curs CURSOR FOR q619_pb
 
      #CALL g_lsn.clear()  #FUN-BA0068 mark
      #LET g_cnt = 1       #FUN-BA0068 mark 

       MESSAGE "Searching!"
       FOREACH lsn_curs INTO g_lsn[g_cnt].* 
           IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
       END FOREACH
   #END FOREACH #FUN-BA0068 add   #FUN-C90102 mark 
  
    CALL g_lsn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q619_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     

#  IF p_ud <> "G" OR g_action_choice = "detail" THEN
#     RETURN
#  END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lsn TO s_lsn.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



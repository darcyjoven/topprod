# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almq618.4gl
# Descriptions...: 
# Date & Author..: 09/10/19 By dxfwo
# Modify.........: No:FUN-960081 09/10/22 by dxfwo 栏位的添加与删除
# Modify.........: No:TQC-A10140 10/01/21 By shiwuying 去掉自動帶出單身
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsm07交易門店字段
# Modify.........: No:FUN-B90118 12/01/05 By pauline 增加ARG_VAL
# Modify.........: No:FUN-BA0067 12/01/11 By pauline 刪除lsm07欄位,增加lsm08,lsmplant
# Modify.........: No:TQC-C30335 12/01/11 By pauline  CONSTRUNCT 欄位名稱錯置,導致利用單號查詢錯誤
# Modify.........: No:FUN-C50063 12/05/16 By pauline 查詢時依照卡號,異動日期排序
# Modify.........: No:FUN-C30176 12/06/18 By pauline 增加換卡新增欄位
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C90102 12/10/29 By pauline 將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-960081
DEFINE
     g_lsm          DYNAMIC ARRAY OF RECORD    
        lsm01       LIKE lsm_file.lsm01,   
        lsm15       LIKE lsm_file.lsm15,     #FUN-C70045 add
       #lsm07       LIKE lsm_file.lsm07, #No.FUN-A70118  #FUN-BA0067 mark
        lsm02       LIKE lsm_file.lsm02,   
        lsm03       LIKE lsm_file.lsm03,
        lsm05       LIKE lsm_file.lsm05,  #FUN-C30176 add
        lsm04       LIKE lsm_file.lsm04,
       #lsm05       LIKE lsm_file.lsm05,  #FUN-C30176 mark
        lsm06       LIKE lsm_file.lsm06,
        lsm08       LIKE lsm_file.lsm08,     #FUN-BA0067 add
        lsm09       LIKE lsm_file.lsm09,     #FUN-C30176 add
        lsm10       LIKE lsm_file.lsm10,     #FUN-C30176 add
        lsm11       LIKE lsm_file.lsm11,     #FUN-C30176 add
        lsm12       LIKE lsm_file.lsm12,     #FUN-C30176 add 
        lsm13       LIKE lsm_file.lsm13,     #FUN-C30176 add
        lsm14       LIKE lsm_file.lsm14,     #FUN-C30176 add 
       #lsmplant    LIKE lsm_file.lsmplant   #FUN-BA0067 add        FUN-C90102 mark 
        lsmstore    LIKE lsm_file.lsmstore   #FUN-C90102 add 
                    END RECORD,
    g_lsm_t         RECORD                 
        lsm01       LIKE lsm_file.lsm01,   
        lsm15       LIKE lsm_file.lsm15,     #FUN-C70045 add
       #lsm07       LIKE lsm_file.lsm07, #No.FUN-A70118  #FUN-BA0067 mark
        lsm02       LIKE lsm_file.lsm02,   
        lsm03       LIKE lsm_file.lsm03,
        lsm05       LIKE lsm_file.lsm05,     #FUN-C30176 add
        lsm04       LIKE lsm_file.lsm04,
       #lsm05       LIKE lsm_file.lsm05,     #FUN-C30176 mark
        lsm06       LIKE lsm_file.lsm06,
        lsm08       LIKE lsm_file.lsm08,     #FUN-BA0067 add
        lsm09       LIKE lsm_file.lsm09,     #FUN-C30176 add
        lsm10       LIKE lsm_file.lsm10,     #FUN-C30176 add
        lsm11       LIKE lsm_file.lsm11,     #FUN-C30176 add
        lsm12       LIKE lsm_file.lsm12,     #FUN-C30176 add
        lsm13       LIKE lsm_file.lsm13,     #FUN-C30176 add
        lsm14       LIKE lsm_file.lsm14,     #FUN-C30176 add
       #lsmplant    LIKE lsm_file.lsmplant   #FUN-BA0067 add    #FUN-C90102 mark 
        lsmstore    LIKE lsm_file.lsmstore   #FUN-C90102 add 
                    END RECORD,
        g_wc2,g_sql STRING,
        g_rec_b     LIKE type_file.num5,               
        l_ac        LIKE type_file.num5                 

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10           
DEFINE g_argv1      LIKE lsm_file.lsm01   #FUN-B90118 add

MAIN
 DEFINE p_row,p_col  LIKE type_file.num5        
    OPTIONS                                
        INPUT NO WRAP                     
    DEFER INTERRUPT                       

   LET g_argv1  = ARG_VAL(1)   #FUN-B90118 add  #卡號

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       
      RETURNING g_time

   LET p_row = 4 LET p_col = 20
   OPEN WINDOW q618_w AT p_row,p_col WITH FORM "alm/42f/almq618"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

#FUN-B90118 add
   IF NOT cl_null(g_argv1) THEN
      CALL q618_q()
   END IF
   CALL cl_set_comp_visible("lsm06", FALSE)
#FUN-B90118 add

   LET g_wc2 = '1=1'
#  CALL q618_b_fill(g_wc2) #No.TQC-A10140
   CALL q618_menu()
   CLOSE WINDOW q618_w                 
   CALL  cl_used(g_prog,g_time,2)     
         RETURNING g_time   
END MAIN

FUNCTION q618_menu()
  DEFINE l_cmd STRING       
   WHILE TRUE
      CALL q618_bp("G")
      CASE g_action_choice
         WHEN "query"      
            IF cl_chk_act_auth() THEN
               CALL q618_q()
            END IF
#        WHEN "output"      
#           IF cl_chk_act_auth() THEN
#              #CALL q618_out()                                  
#              IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF     
#              LET l_cmd='p_query "aooq618" "',g_wc2 CLIPPED,'"' 
#              CALL cl_cmdrun(l_cmd)                             
#           END IF

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"        
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lsm[l_ac].lsm01 IS NOT NULL THEN
                  LET g_doc.column1 = "lsm01"
                  LET g_doc.value1 = g_lsm[l_ac].lsm01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lsm),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION q618_q()
#FUN-B90118 add
   IF NOT cl_null(g_argv1) THEN
     LET g_wc2 = "lsm01 = '",g_argv1,"'"
     CALL q618_b_fill(g_wc2) 
   ELSE 
#FUN-B90118 add   
      CALL q618_b_askkey()
   END IF   #FUN-B90118 add
END FUNCTION

FUNCTION q618_b_askkey()

    CLEAR FORM
    CALL g_lsm.clear()
#FUN-BA0067 mark START
#   CONSTRUCT g_wc2 ON lsm01,lsm07,lsm02,lsm02,lsm04,lsm05,lsm06 #No.FUN-A70118
#        FROM s_lsm[1].lsm01,s_lsm[1].lsm07,s_lsm[1].lsm02,      #No.FUN-A70118
#             s_lsm[1].lsm03,s_lsm[1].lsm04,
#             s_lsm[1].lsm05,s_lsm[1].lsm06
#FUN-BA0067 mark END
  #FUN-C30176 mark START
  ##FUN-BA0067 add START
  ##CONSTRUCT g_wc2 ON lsm01,lsm02,lsm02,lsm04,lsm05,lsm06,lsm08,lsmplant  #TQC-C30335 mark
  # CONSTRUCT g_wc2 ON lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmplant  #TQC-C30335 add 
  #      FROM s_lsm[1].lsm01,s_lsm[1].lsm02,
  #           s_lsm[1].lsm03,s_lsm[1].lsm04,
  #           s_lsm[1].lsm05,s_lsm[1].lsm06,
  #           s_lsm[1].lsm08,s_lsm[1].lsmplant
  ##FUN-BA0067 add END
  #FUN-C30176 mark END
   #FUN-C30176 add START
#   CONSTRUCT g_wc2 ON lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsm09,lsm10,lsm11,lsm12,lsm13,lsm14,lsmplant           #FUN-C70045 mark
   #CONSTRUCT g_wc2 ON lsm01,lsm15,lsm02,lsm03,lsm05,lsm04,lsm06,lsm08,lsm09,lsm10,lsm11,lsm12,lsm13,lsm14,lsmplant     #FUN-C70045 add  #FUN-C90102 mark
    CONSTRUCT g_wc2 ON lsm01,lsm15,lsm02,lsm03,lsm05,lsm04,lsm06,lsm08,lsm09,lsm10,lsm11,lsm12,lsm13,lsm14,lsmstore     #FUN-C90102 add
#        FROM s_lsm[1].lsm01,s_lsm[1].lsm02,s_lsm[1].lsm03,s_lsm[1].lsm04,s_lsm[1].lsm05,s_lsm[1].lsm06,                      #FUN-C70045 add mark
         FROM s_lsm[1].lsm01,s_lsm[1].lsm15,s_lsm[1].lsm02,s_lsm[1].lsm03,s_lsm[1].lsm05,s_lsm[1].lsm04,s_lsm[1].lsm06,       #FUN-C70045 add
              s_lsm[1].lsm08,s_lsm[1].lsm09,s_lsm[1].lsm10,s_lsm[1].lsm11,s_lsm[1].lsm12,s_lsm[1].lsm13,
             #s_lsm[1].lsm14,s_lsm[1].lsmplant   #FUN-C90102 mark 
              s_lsm[1].lsm14,s_lsm[1].lsmstore   #FUN-C90102 add
   #FUN-C30176 add END
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
          CASE
            WHEN INFIELD(lsm01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsm01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsm01
               NEXT FIELD lsm01   
            WHEN INFIELD(lsm03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsm03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsm03
               NEXT FIELD lsm03
    #FUN-BA0067 add START
           #FUN-C90102 mark START
           #WHEN INFIELD(lsmplant)
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.state = 'c'
           #   LET g_qryparam.form ="q_lsm4"
           #   CALL cl_create_qry() RETURNING g_qryparam.multiret
           #   DISPLAY g_qryparam.multiret TO lsmplant
           #   NEXT FIELD lsmplant
           #FUN-C90102 mark END 
           #FUN-C90102 add START
            WHEN INFIELD(lsmstore)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsm4"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsmstore
               NEXT FIELD lsmstore
           #FUN-C90102 add END
    #FUN-BA0067 add END
    #FUN-BA0067 mark START
    #      #No.FUN-A70118 -BEGIN-----
    #       WHEN INFIELD(lsm07)
    #          CALL cl_init_qry_var()
    #          LET g_qryparam.state = 'c'
    #          LET g_qryparam.form ="q_lsm07"
    #          CALL cl_create_qry() RETURNING g_qryparam.multiret
    #          DISPLAY g_qryparam.multiret TO lsm07
    #          NEXT FIELD lsm07
    #      #No.FUN-A70118 -END-------
    #FUN-BA0067 mark START
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('lsmuser', 'lsmgrup') #FUN-980030

#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

    CALL q618_b_fill(g_wc2)

END FUNCTION

FUNCTION q618_b_fill(p_wc2)            
DEFINE
    p_wc2           LIKE type_file.chr1000      
DEFINE l_sql        STRING           #FUN-BA0067 add
DEFINE l_plant      LIKE zxy_file.zxy03  #FUN-BA0067 add
#FUN-BA0067 mark START
#   LET g_sql =
#       "SELECT lsm01,lsm07,lsm02,lsm03,lsm04,lsm05,lsm06 ", #No.FUN-A70118
#       " FROM lsm_file",
#       " WHERE ", p_wc2 CLIPPED                   
#FUN-BA0067 mark END
#FUN-BA0067 add START
  CALL g_lsm.clear()
  LET g_cnt = 1
 #FUN-C90102 mark START
 #LET l_sql = " SELECT azw01 FROM azw_file WHERE azw02 = '",g_legal,"'"
 #PREPARE q619_db FROM l_sql
 #DECLARE q619_cdb CURSOR FOR q619_db
 #FOREACH q619_cdb INTO l_plant
 #FUN-C90102 mark  END
    LET g_sql =
       #" SELECT lsm01,lsm02,lsm03,lsm04,lsm05,lsm06, lsm08,lsmplant ",  #FUN-C30176 mark
       #" SELECT lsm01,lsm15,lsm02,lsm03,lsm05,lsm04,lsm06, lsm08, lsm09, lsm10, lsm11, lsm12, lsm13, lsm14,lsmplant ",  #FUN-C30176 add  #FUN-C70045 add lsm15  #FUN-C90102 mark 
       #" FROM ",cl_get_target_table(l_plant,'lsm_file'),  #FUN-C90102 mark 
        " SELECT lsm01,lsm15,lsm02,lsm03,lsm05,lsm04,lsm06, lsm08, lsm09, lsm10, lsm11, lsm12, lsm13, lsm14,lsmstore ",  #FUN-C90102 add 
        " FROM lsm_file"   ,  #FUN-C90102 add 
        " WHERE ", p_wc2 CLIPPED,
       #" AND lsmplant = '",l_plant,"'",  #FUN-C90102 mark 
        "   ORDER BY lsm01, lsm05"        #FUN-C50063 add
     #FUN-C90102 mark START
     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     #CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
     #FUN-C90102 mark END
#FUN-BA0067 add END
      PREPARE q618_pb FROM g_sql
      DECLARE lsm_curs CURSOR FOR q618_pb

     #CALL g_lsm.clear() #FUN-BA0067 mark
     #LET g_cnt = 1      #FUN-BA0067 mark
      MESSAGE "Searching!"
      FOREACH lsm_curs INTO g_lsm[g_cnt].*   
          IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
      END FOREACH
   #END FOREACH #FUN-BA0067 add   #FUN-C90102 mark 
    CALL g_lsm.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q618_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    

#  IF p_ud <> "G" OR g_action_choice = "detail" THEN
#     RETURN
#  END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lsm TO s_lsm.* ATTRIBUTE(COUNT=g_rec_b)

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



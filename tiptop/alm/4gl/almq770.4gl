# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: almq770.4gl
# Descriptions...: 卡状态信息查询作业
# Date & Author..: 09/10/19 By dxfwo
# Modify.........: No:FUN-960081 09/10/22 by dxfwo 栏位的添加与删除
# Modify.........: No:FUN-9B0136 09/11/24 By shiwuying 增加會員編號
# Modify.........: No:TQC-A10142 10/01/21 By shiwuying 去掉自動帶出單身
# Modify.........: No:MOD-A30215 10/03/26 By Smapmin 單身按二下程式會hold住
# Modify.........: No:FUN-A30116 10/04/26 By Cockroach 增加已傳POS否字段
# Modify.........: No:FUN-B50042 11/04/29 by jason 已傳POS否狀態調整

DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-960081
DEFINE
     g_lpj          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        lpj03       LIKE lpj_file.lpj03,   
        lpj01       LIKE lpj_file.lpj01,       #No:FUN-9B0136
        lpj02       LIKE lpj_file.lpj02,   
        lph02       LIKE lph_file.lph02,
        lpj04       LIKE lpj_file.lpj04,
        lpj17       LIKE lpj_file.lpj17,        
        lpj05       LIKE lpj_file.lpj05,
        lpj09       LIKE lpj_file.lpj09,
        lpj16       LIKE lpj_file.lpj16,
        lpj06       LIKE lpj_file.lpj06,
        lpj08       LIKE lpj_file.lpj08,
        lpj07       LIKE lpj_file.lpj07,
        lpj15       LIKE lpj_file.lpj15,   
        lpj11       LIKE lpj_file.lpj11,
        lpj12       LIKE lpj_file.lpj12,
        lpj13       LIKE lpj_file.lpj13,
        lpj14       LIKE lpj_file.lpj14,
        lpj25       LIKE lpj_file.lpj25,
        lpj18       LIKE lpj_file.lpj18,
        lpj19       LIKE lpj_file.lpj19,
        lpj10       LIKE lpj_file.lpj10,
        lpj20       LIKE lpj_file.lpj20,
        lpj21       LIKE lpj_file.lpj21,
        lpj22       LIKE lpj_file.lpj22,
        lpj23       LIKE lpj_file.lpj23,
        lpj24       LIKE lpj_file.lpj24          
       ,lpjpos      LIKE lpj_file.lpjpos    #FUN-A30116 已傳POS否          
                    END RECORD,
    g_lpj_t         RECORD                 #程式變數 (舊值)
        lpj03       LIKE lpj_file.lpj03,   
        lpj01       LIKE lpj_file.lpj01,       #No:FUN-9B0136
        lpj02       LIKE lpj_file.lpj02,   
        lph02       LIKE lph_file.lph02,
        lpj04       LIKE lpj_file.lpj04,
        lpj17       LIKE lpj_file.lpj17,        
        lpj05       LIKE lpj_file.lpj05,
        lpj09       LIKE lpj_file.lpj09,
        lpj16       LIKE lpj_file.lpj16,
        lpj06       LIKE lpj_file.lpj06,
        lpj08       LIKE lpj_file.lpj08,
        lpj07       LIKE lpj_file.lpj07,
        lpj15       LIKE lpj_file.lpj15,   
        lpj11       LIKE lpj_file.lpj11,
        lpj12       LIKE lpj_file.lpj12,
        lpj13       LIKE lpj_file.lpj13,
        lpj14       LIKE lpj_file.lpj14,
        lpj25       LIKE lpj_file.lpj25,
        lpj18       LIKE lpj_file.lpj18,
        lpj19       LIKE lpj_file.lpj19,
        lpj10       LIKE lpj_file.lpj10,
        lpj20       LIKE lpj_file.lpj20,
        lpj21       LIKE lpj_file.lpj21,
        lpj22       LIKE lpj_file.lpj22,
        lpj23       LIKE lpj_file.lpj23,
        lpj24       LIKE lpj_file.lpj24  
       ,lpjpos      LIKE lpj_file.lpjpos    #FUN-A30116 已傳POS否          
                    END RECORD,
        g_wc2,g_sql STRING,
        g_rec_b     LIKE type_file.num5,                #單身筆數       
        l_ac        LIKE type_file.num5                 #目前處理的ARRAY CNT 

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10            
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose 
MAIN
DEFINE p_row,p_col  LIKE type_file.num5        
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    
       LET p_row = 4 LET p_col = 20
   OPEN WINDOW q770_w AT p_row,p_col WITH FORM "alm/42f/almq770"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

   CALL cl_ui_init()

   CALL cl_set_comp_visible("lpjpos",FALSE) #NO.FUN-B50042

#  LET g_wc2 = '1=1' CALL q770_b_fill(g_wc2) #No.TQC-A10142 mark
   CALL q770_menu()
   CLOSE WINDOW q770_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time   
END MAIN

FUNCTION q770_menu()
  DEFINE l_cmd STRING      
   WHILE TRUE
      CALL q770_bp("G")
      CASE g_action_choice
         WHEN "query"       # 查詢
            IF cl_chk_act_auth() THEN
               CALL q770_q()
            END IF
         WHEN "output"      # 列印
            IF cl_chk_act_auth() THEN
               #CALL q770_out()                                
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF  
               LET l_cmd='p_query "aooq770" "',g_wc2 CLIPPED,'"' 
               CALL cl_cmdrun(l_cmd)                             
            END IF

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"        # 離開
            EXIT WHILE
         WHEN "controlg"    # 執行
            CALL cl_cmdask()
#         WHEN "related_document"  # 相關文件
#            IF cl_chk_act_auth() AND l_ac != 0 THEN 
#               IF g_lpj[l_ac].lpj01 IS NOT NULL THEN
#                  LET g_doc.column1 = "lpj01"
#                  LET g_doc.value1 = g_lpj[l_ac].lpj01
#                  CALL cl_doc()
#               END IF
#            END IF
         WHEN "exporttoexcel"     # 轉Excel檔
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lpj),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION q770_q()
   CALL q770_b_askkey()
END FUNCTION

FUNCTION q770_b_askkey()

    CLEAR FORM
    CALL g_lpj.clear()

    CONSTRUCT g_wc2 ON lpj03,lpj01,lpj02,lph02,lpj04,lpj17,lpj05,lpj09,lpj16,lpj06,
                       lpj08,lpj07,lpj15,lpj11,lpj12,lpj13,lpj14,lpj25,lpj18,
                       lpj19,lpj10,lpj20,lpj21,lpj22,lpj23,lpj24    #FUN-A30116 ADD POS?
         FROM s_lpj[1].lpj03,s_lpj[1].lpj01,s_lpj[1].lpj02,s_lpj[1].lph02,s_lpj[1].lpj04,
              s_lpj[1].lpj17,s_lpj[1].lpj05,s_lpj[1].lpj09,s_lpj[1].lpj16,s_lpj[1].lpj06,
              s_lpj[1].lpj08,s_lpj[1].lpj07,s_lpj[1].lpj15,s_lpj[1].lpj11,s_lpj[1].lpj12,s_lpj[1].lpj13,      
              s_lpj[1].lpj14,s_lpj[1].lpj25,s_lpj[1].lpj18,
              s_lpj[1].lpj19,s_lpj[1].lpj10,s_lpj[1].lpj20,s_lpj[1].lpj21,
              s_lpj[1].lpj22,s_lpj[1].lpj23,s_lpj[1].lpj24   #FUN-A30116 ADD POS? #FUN-B50042 remove POS
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
          CASE
            WHEN INFIELD(lpj03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj03
               NEXT FIELD lpj03   
            WHEN INFIELD(lpj01) #No:FUN-9B0136
               CALL cl_init_qry_var() 
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj01" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj01
               NEXT FIELD lpj01
            WHEN INFIELD(lpj02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj02
               NEXT FIELD lpj02
            WHEN INFIELD(lpj01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj01
               NEXT FIELD lpj01
            WHEN INFIELD(lpj17)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj17"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj17
               NEXT FIELD lpj17                
            WHEN INFIELD(lpj19)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj19"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj19
               NEXT FIELD lpj19   
            WHEN INFIELD(lpj20)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj20"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj20
               NEXT FIELD lpj20  
            WHEN INFIELD(lpj22)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj22"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj22
               NEXT FIELD lpj22   
            WHEN INFIELD(lpj24)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lpj24"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lpj24
               NEXT FIELD lpj24                                                                         
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('lpjuser', 'lpjgrup') #FUN-980030

#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

    CALL q770_b_fill(g_wc2)

END FUNCTION

FUNCTION q770_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      

    LET g_sql =
        "SELECT lpj03,lpj01,lpj02,'',lpj04,lpj17,lpj05,lpj09,lpj16,lpj06, ",
        "       lpj08,lpj07,lpj15,lpj11,lpj12,lpj13,lpj14,lpj25,lpj18,",
        "       lpj19,lpj10,lpj20,lpj21,lpj22,lpj23,lpj24,lpjpos ",   #FUN-A30116 ADD POS?
        " FROM lpj_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY lpj03"

    PREPARE q770_pb FROM g_sql
    DECLARE lpj_curs CURSOR FOR q770_pb

    CALL g_lpj.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH lpj_curs INTO g_lpj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT lph02 INTO g_lpj[g_cnt].lph02 FROM lph_file 
         WHERE lph01 = g_lpj[g_cnt].lpj02
         DISPLAY BY NAME  g_lpj[g_cnt].lph02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lpj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q770_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 CHAR(1)

   #IF p_ud <> "G" OR g_action_choice = "detail" THEN   #MOD-A30215
   IF p_ud <> "G" THEN   #MOD-A30215
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lpj TO s_lpj.* ATTRIBUTE(COUNT=g_rec_b)

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

      #-----MOD-A30215---------
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY
      #-----END MOD-A30215-----

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

      ON ACTION exporttoexcel   #No:FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



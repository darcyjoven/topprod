# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_atmt321.4gl
# Descriptions...: atmt321 , saxmt600系列.4gl使用
# Date & Author..: 07/01/11 By kim (FUN-710016)
# Modify.........: No.FUN-710040 07/01/26 By rainy 新增action 查詢序號
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740039 07/04/11 By Ray 取消翻頁按鈕
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40015 10/04/06 By Smapmin 進入第二單身時,右邊出現多餘的action
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt600.global"
 
 
FUNCTION t321_cs2()
   DEFINE lc_qbe_sn  LIKE gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE l_type     LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
   CLEAR FORM                             #清除畫面
   CALL g_oga_b.clear()
   CALL g_ogb_c.clear()
   LET g_action_choice=" "
   
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_oga_t321.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc3 ON oga1016,oga02,ogaconf,ogapost    
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oga1016)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form  ="q_pmc8"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga1016
                 NEXT FIELD oga1016
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
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT CONSTRUCT
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT CONSTRUCT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
 
   IF INT_FLAG OR g_action_choice = "exit" THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc3 = g_wc3 clipped," AND ogauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc3 = g_wc3 clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc3 = g_wc3 clipped," AND ogagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc3 = g_wc3 CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv0) THEN
      LET g_wc3 = g_wc3 clipped," AND oga09 = '",g_argv0,"'"
   END IF
 
   LET g_sql = "SELECT DISTINCT oga1016,oga02,ogaconf,ogapost FROM oga_file",
               " WHERE ", g_wc3 CLIPPED,
               "   AND oga09='2' ",
               " ORDER BY oga1016,oga02" 
 
   PREPARE t321_prepare2 FROM g_sql
   DECLARE t321_cs2                        #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t321_prepare2
 
   LET g_sql = "SELECT COUNT(DISTINCT oga1016) FROM oga_file ",
               " WHERE ",g_wc3 CLIPPED," AND oga09='2'"
   PREPARE t321_precount2 FROM g_sql
   DECLARE t321_count2 CURSOR FOR t321_precount2
 
END FUNCTION
 
FUNCTION t321_q2()
    WHENEVER ERROR CONTINUE              #忽略一切錯誤 #FUN-710016
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_oga_t321.* TO NULL          #No.FUN-6A0020 
    MESSAGE ""
    CALL cl_opmsg('q')
    #DISPLAY '   ' TO FORMONLY.cnt #CHI-710055
    CALL t321_cs2()
    IF INT_FLAG OR g_action_choice="exit" THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_oga_t321.* TO NULL 
       RETURN 
    END IF
    LET g_oga_t321_t.* = g_oga_t321.*
    MESSAGE " SEARCHING ! "
 
    OPEN t321_cs2                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_oga_t321.* TO NULL
    ELSE
       OPEN t321_count2
       FETCH t321_count2 INTO g_row_count
       #DISPLAY g_row_count TO FORMONLY.cnt #CHI-710055
       CALL t321_fetch2('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION t321_fetch2(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t321_cs2 INTO g_oga_t321.oga1016,g_oga_t321.oga02,   
                                              g_oga_t321.ogaconf,g_oga_t321.ogapost  
        WHEN 'P' FETCH PREVIOUS t321_cs2 INTO g_oga_t321.oga1016,g_oga_t321.oga02,   
                                              g_oga_t321.ogaconf,g_oga_t321.ogapost  
        WHEN 'F' FETCH FIRST    t321_cs2 INTO g_oga_t321.oga1016,g_oga_t321.oga02,   
                                              g_oga_t321.ogaconf,g_oga_t321.ogapost  
        WHEN 'L' FETCH LAST     t321_cs2 INTO g_oga_t321.oga1016,g_oga_t321.oga02,   
                                              g_oga_t321.ogaconf,g_oga_t321.ogapost  
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump t321_cs2 INTO g_oga_t321.oga1016,g_oga_t321.oga02,  #FUN-710016   
                                               g_oga_t321.ogaconf,g_oga_t321.ogapost   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_oga.* TO NULL  #TQC-6B0105
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
    LET g_data_owner = g_oga.ogauser      #FUN-4C0057 add
    LET g_data_group = g_oga.ogagrup      #FUN-4C0057 add
    LET g_data_plant = g_oga.ogaplant #FUN-980030
    CALL t321_show_t321()
 
END FUNCTION
 
FUNCTION t321_show_t321()
   CALL t321_b1_fill_t321(g_wc3)
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t321_b1_fill_t321(l_wc3)              #BODY FILL UP
   DEFINE l_wc3  STRING
 
   LET g_sql = "SELECT oga03,oga032,oga04,occ02,oga00,oga01,oga02,",
               "       oga16,oea02,oea10,ogaconf,ogapost",
               "  FROM oga_file,occ_file,oea_file ",
               " WHERE ",l_wc3 CLIPPED,
               "   AND oga09='2' ",
               "   AND oga04 = occ01 ",
               "   AND oga16 = oea01 ",
               " ORDER BY oga03" 
   PREPARE t321_pb_b FROM g_sql
   DECLARE oga_curs_b CURSOR FOR t321_pb_b                       #CURSOR
 
   CALL g_oga_b.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH oga_curs_b INTO g_oga_b[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_oga_b.deleteElement(g_cnt)
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cntb
   LET g_cnt = 1
 
   CALL t321_b2_fill_t321(g_oga_b[g_cnt].oga01_b)
   CALL t321_bp3_refresh()
END FUNCTION
 
FUNCTION t321_b2_fill_t321(l_oga01)              #BODY FILL UP
   DEFINE l_oga01  LIKE oga_file.oga01
 
   LET g_sql = "SELECT ogb03,ogb04,ogb06,ima021,oeb15,oeb16,ogb05,ogb12 ",
               "  FROM ogb_file,ima_file,oeb_file ",
               " WHERE ogb01 = '",l_oga01,"' ",
               "   AND ogb04 = ima01 ",
               "   AND ogb31 = oeb01 AND ogb32 = oeb03 ",
               " ORDER BY ogb03"
   PREPARE t321_pb_c FROM g_sql
   DECLARE ogb_curs_c CURSOR FOR t321_pb_c                     #CURSOR
 
   CALL g_ogb_c.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH ogb_curs_c INTO g_ogb_c[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ogb_c.deleteElement(g_cnt)
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cntc
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t321_bp_t321(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
  #IF p_ud <> "G" OR g_action_choice = "detail" THEN   #TQC-690061 mark
   IF p_ud <> "G" THEN                                 #TQC-690061 
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #FUN-640181---start---
   IF g_aza.aza23 matches '[ Nn]' THEN
      CALL cl_set_act_visible("easyflow_approval,approval_status",FALSE)
   END IF
   #FUN-640181---end---
   DISPLAY ARRAY g_oga_b TO s_oga_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF l_ac != 0 THEN
            CALL t321_b2_set_oga(g_oga_b[l_ac].oga01_b)
            CALL t321_b2_fill_t321(g_oga_b[l_ac].oga01_b)
            CALL t321_bp3_refresh()
         END IF
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
#No.TQC-740039 --begin
#     ON ACTION first
#        CALL t321_fetch2('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION previous
#        CALL t321_fetch2('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
#     ON ACTION jump
#        CALL t321_fetch2('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
#     ON ACTION next
#        CALL t321_fetch2('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION last
#        CALL t321_fetch2('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#No.TQC-740039 --end
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
    #@ON ACTION Y.確認
      ON ACTION confirm_t321
         LET g_action_choice="confirm_t321"
         EXIT DISPLAY
 
    #@ON ACTION W.取消確認
      ON ACTION undo_confirm_t321
         LET g_action_choice="undo_confirm_t321"
         EXIT DISPLAY
 
    #@ON ACTION S.庫存扣帳
      ON ACTION deduct_inventory_t321
         LET g_action_choice="deduct_inventory_t321"
         EXIT DISPLAY
 
    #@ON ACTION Z.扣帳還原
      ON ACTION undo_deduct_t321
         LET g_action_choice="undo_deduct_t321"
         EXIT DISPLAY
 
    #start FUN-660087 mark
    #@ON ACTION 出貨單維護
    # ON ACTION maintain_axmt620
    #    LET g_action_choice="maintain_axmt620"
    #    EXIT DISPLAY
    #start FUN-660087 mark
 
    #start FUN-640050 add 
    #@ON ACTION 出貨日期維護
      ON ACTION maintain_delivery_date
         LET g_action_choice="maintain_delivery_date"
         EXIT DISPLAY
 
    #@ON ACTION 單身維護
      ON ACTION maintain_detail
         LET g_action_choice="maintain_detail"
         EXIT DISPLAY
 
      ON ACTION view
         LET g_action_choice = "view"
         EXIT DISPLAY
    #end FUN-640050 add 
 
   #FUN-710040--begin
#@    ON ACTION 查詢序號
     ON ACTION qry_serialno
        LET g_action_choice = "qry_serialno"
        EXIT DISPLAY
   #FUN-710040--end
 
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#start FUN-640050 add
FUNCTION t321_bp3()
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb_c TO s_ogb_c.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)

      #-----MOD-A40015---------
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
      #-----END MOD-A40015-----      
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION cancel
         LET g_action_choice="exit"
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #將focus指回單頭
      ON ACTION return
         LET g_action_choice="return"
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#end FUN-640050 add
 
#start FUN-640050 add
FUNCTION t321_upd_oga02()
   DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680137 VARCHAR(1)
   DEFINE l_lock_sw       LIKE type_file.chr1                  #單身鎖住否  #No.FUN-680137 VARCHAR(1)
   DEFINE l_yy,l_mm       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_n             LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_flag          LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ac_t          LIKE type_file.num5                 #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
 
   LET g_forupd_sql = 
       "SELECT oga03,oga032,oga04,'',oga00,oga01,oga02,",
       "       oga16,'','',ogaconf,ogapost",
       "  FROM oga_file ",
       "  WHERE oga01 = ?  ",
       "   AND oga09 ='2' ",
       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t321_bc2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_oga_b WITHOUT DEFAULTS FROM s_oga_b.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
      BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'                   #DEFAULT
          LET l_n  = ARR_COUNT()
 
          BEGIN WORK
 
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_oga_b_t.* = g_oga_b[l_ac].*  #BACKUP
 
             OPEN t321_bc2 USING g_oga_b[l_ac].oga01_b
             IF STATUS THEN
                CALL cl_err("OPEN t321_bc2:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t321_bc2 INTO g_oga_b[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('lock oga_b',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             SELECT occ02 INTO g_oga_b[l_ac].occ02_b 
               FROM occ_file 
              WHERE occ01=g_oga_b[l_ac].oga04_b
             IF STATUS THEN LET g_oga_b[l_ac].occ02_b = '' END IF
             DISPLAY BY NAME g_oga_b[l_ac].occ02_b
             SELECT oea02,oea10 INTO g_oga_b[l_ac].oea02_b,g_oga_b[l_ac].oea10_b
               FROM oea_file
              WHERE oea01=g_oga_b[l_ac].oga16_b
             IF STATUS THEN 
                LET g_oga_b[l_ac].oea02_b = '' 
                LET g_oga_b[l_ac].oea10_b = '' 
             END IF
             DISPLAY BY NAME g_oga_b[l_ac].oea02_b,g_oga_b[l_ac].oea10_b
          END IF
          IF g_oga_b[l_ac].ogaconf_b = 'X' THEN 
             CALL cl_err('',9024,0)
             EXIT INPUT
          END IF
          IF g_oga_b[l_ac].ogaconf_b = 'Y' THEN 
             CALL cl_err('',9023,0)
             EXIT INPUT
          END IF
 
      BEFORE FIELD oga02_b
          LET g_oga_b_t.* = g_oga_b[l_ac].*  #BACKUP 
 
      AFTER FIELD oga02_b
         LET l_flag = "Y"
         IF NOT cl_null(g_oga_b[l_ac].oga02_b) THEN
            IF g_oga_b[l_ac].oga02_b != g_oga_b_t.oga02_b THEN
               IF g_oga_b[l_ac].ogaconf_b = 'X' THEN 
                  LET g_oga_b[l_ac].oga02_b = g_oga_b_t.oga02_b 
                  LET l_flag = "N"
                  CALL cl_err('',9024,0)
               END IF
               IF g_oga_b[l_ac].ogaconf_b = 'Y' THEN 
                  LET g_oga_b[l_ac].oga02_b = g_oga_b_t.oga02_b 
                  LET l_flag = "N"
                  CALL cl_err('',9023,0)
               END IF
               DISPLAY BY NAME g_oga_b[l_ac].oga02_b
 
               IF l_flag = "Y" THEN
                  IF g_oga_b[l_ac].oga02_b <= g_oaz.oaz09 THEN
                     CALL cl_err('','axm-164',0) NEXT FIELD oga02_b
                  END IF
                  IF g_oaz.oaz03 = 'Y' AND
                     g_sma.sma53 IS NOT NULL AND g_oga_b[l_ac].oga02_b <= g_sma.sma53 THEN
                     LET g_oga_b[l_ac].oga02_b = g_oga_b_t.oga02_b 
                     DISPLAY BY NAME g_oga_b[l_ac].oga02_b
                     CALL cl_err('','mfg9999',0) 
                     NEXT FIELD oga02_b
                  END IF
                  CALL s_yp(g_oga_b[l_ac].oga02_b) RETURNING l_yy,l_mm
                  IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                     LET g_oga_b[l_ac].oga02_b = g_oga_b_t.oga02_b 
                     DISPLAY BY NAME g_oga_b[l_ac].oga02_b
                     CALL cl_err('','mfg6090',0)
                     NEXT FIELD oga02_b
                  END IF
               END IF
            END IF
         ELSE
            LET g_oga_b[l_ac].oga02_b = g_oga_b_t.oga02_b 
            DISPLAY BY NAME g_oga_b[l_ac].oga02_b
            CALL cl_err('','mfg5103',0)
            NEXT FIELD oga02_b
         END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_oga_b[l_ac].* = g_oga_b_t.*
             CLOSE t321_bc2
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_oga_b[l_ac].oga01_b,-263,1)
             LET g_oga_b[l_ac].* = g_oga_b_t.*
          ELSE
             IF g_oga_b[l_ac].ogaconf_b != 'X' AND 
                g_oga_b[l_ac].ogaconf_b != 'Y' AND
                g_oga_b[l_ac].ogapost_b != 'Y' THEN
                UPDATE oga_file SET oga02 = g_oga_b[l_ac].oga02_b
                 WHERE oga01 = g_oga_b[l_ac].oga01_b
                IF SQLCA.sqlcode THEN
#                  CALL cl_err('upd oga_b',SQLCA.sqlcode,0)   #No.FUN-670008
                   CALL cl_err3("upd","oga_file",g_oga_b_t.oga01_b,"",SQLCA.sqlcode,"","upd oga_b",1)  #No.FUN-670008
                   LET g_oga_b[l_ac].* = g_oga_b_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
             END IF
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION t321_bp3_refresh()
   DISPLAY ARRAY g_ogb_c TO s_ogb_c.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
 
FUNCTION t321_b2_set_oga(l_oga01)
   DEFINE l_oga01  LIKE oga_file.oga01
   DEFINE l_oga011 LIKE oga_file.oga01    #liuxqa 091021
 
   SELECT oga01 INTO l_oga011 FROM oga_file    #liuxqa 091021
    WHERE oga01 = l_oga01 AND oga09 = '2'         #liuxqa 091021
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","oga_file",l_oga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-670008
      INITIALIZE g_oga.* TO NULL
      RETURN
   ELSE
      SELECT * INTO g_oga.* FROM oga_file WHERE oga01=l_oga011     #liuxqa 091021 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-670008
         INITIALIZE g_oga.* TO NULL
         RETURN
      END IF
   END IF
 
END FUNCTION

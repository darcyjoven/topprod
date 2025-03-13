# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axmt910.4gl
# Descriptions...: 出貨單文件資料維護作業
# Date & Author..: 04/05/18 By Mandy
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE
           g_ogb           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    oga02b    LIKE oga_file.oga02,    #出貨日期
                    oga03b    LIKE oga_file.oga03,    #客戶編號
                    oga01b    LIKE oga_file.oga01,    #出貨單號
                    ogb03     LIKE ogb_file.ogb03,    #項次
                    ogb04     LIKE ogb_file.ogb04     #產品編號
                    END RECORD,
             g_wc              string,  #No.FUN-580092 HCN
             g_sql             string,  #No.FUN-580092 HCN
             g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
             l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql  STRING  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0094
      DEFINE     p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t910_w AT p_row,p_col WITH FORM "axm/42f/axmt910"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    CALL t910_menu()
    CLOSE WINDOW t910_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION t910_cs()
    CLEAR FORM                             #清除畫面
    CALL g_ogb.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        oga02,oga01,oga03,oga04
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(oga01) #查詢出貨單oga09 IN('2','3','4','6')
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oga6"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga01
                   NEXT FIELD oga01
              WHEN INFIELD(oga03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga03
                   NEXT FIELD oga03
              WHEN INFIELD(oga04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga04
                   NEXT FIELD oga04
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED," AND oga09 IN ('2','3','4','6','8') ", #No.FUN-610020
                            " AND ogaconf = 'Y'" CLIPPED
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ogauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
    #End:FUN-980030
 
END FUNCTION
 
FUNCTION t910_menu()
 
   WHILE TRUE
      CALL t910_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t910_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t910_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL t910_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE " SEARCHING ! "
    CALL t910_b_fill(g_wc) #單身
    MESSAGE ""
END FUNCTION
 
FUNCTION t910_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
    LET g_sql =
        "SELECT oga02,oga03,oga01,ogb03,ogb04 ",
        " FROM oga_file,ogb_file ",
        " WHERE oga01 = ogb01 ",
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY oga02,oga03,oga01,ogb03 "
 
    PREPARE t910_pb FROM g_sql
    DECLARE ogb_curs CURSOR FOR t910_pb
 
    CALL g_ogb.clear()
    LET g_cnt = 1
    FOREACH ogb_curs INTO g_ogb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ogb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t910_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        #文件維護
        ON ACTION maintain_text
                  LET g_msg='axmt920 "',g_ogb[l_ac].oga01b,'" ',g_ogb[l_ac].ogb03
                  CALL cl_cmdrun_wait(g_msg)
        #複製上筆明細
        ON ACTION copy_previous
            IF l_ac = 1 THEN
                #上筆無明細資料可供複製!
                CALL cl_err('','axm-911',1)
            ELSE
                CALL t910_copy()
            END IF
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
   ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#複製上筆明細
FUNCTION t910_copy()
  DEFINE l_n   LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         l_oze RECORD LIKE oze_file.*
    
    SELECT COUNT(*) INTO l_n FROM oze_file
     WHERE oze01 = g_ogb[l_ac].oga01b
       AND oze02 = g_ogb[l_ac].ogb03
    IF l_n >= 1 THEN
        #本筆已有明細資料,不可再做複製!
        CALL cl_err('','axm-910',1)
        RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM oze_file
     WHERE oze01 = g_ogb[l_ac-1].oga01b
       AND oze02 = g_ogb[l_ac-1].ogb03
    IF l_n <= 0 THEN
        #上筆無明細資料可供複製!
        CALL cl_err('','axm-911',1)
        RETURN
    END IF
 
    LET g_sql =
        "SELECT oze03,oze04,oze05,oze06,oze07,oze08,oze09,oze10,oze11 ",
        " FROM oze_file ",
        " WHERE oze01 = '",g_ogb[l_ac-1].oga01b,"'",
        "   AND oze02 =  ",g_ogb[l_ac-1].ogb03,
        " ORDER BY oze03 "
 
    PREPARE t910_p_ins_oze FROM g_sql
    DECLARE t910_ins_oze CURSOR FOR t910_p_ins_oze
 
    INITIALIZE l_oze.* TO NULL
    LET l_oze.oze01 = g_ogb[l_ac].oga01b
    LET l_oze.oze02 = g_ogb[l_ac].ogb03
    LET g_success = 'Y'
    BEGIN WORK
    FOREACH t910_ins_oze INTO l_oze.oze03,l_oze.oze04,l_oze.oze05,l_oze.oze06,
                              l_oze.oze07,l_oze.oze08,l_oze.oze09,l_oze.oze10,
                              l_oze.oze11
        IF STATUS THEN CALL cl_err('foreach t910_ins_oze',STATUS,1) EXIT FOREACH END IF
        #FUN-980010 add plant & legal 
        LET l_oze.ozeplant = g_plant 
        LET l_oze.ozelegal = g_legal 
        #FUN-980010 end plant & legal 
 
        INSERT INTO oze_file VALUES(l_oze.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err("INSERT oze_file",SQLCA.sqlcode,1)   #No.FUN-660167
            CALL cl_err3("ins","oze_file",l_oze.oze01,"",SQLCA.sqlcode,"","INSERT oze_file",1)  #No.FUN-660167
            LET g_success = 'N'
            EXIT FOREACH
        END IF
    END FOREACH
    IF g_success = 'Y' THEN
        COMMIT WORK
        MESSAGE "INSERT oze_file O.K."
    ELSE
        ROLLBACK WORK
        MESSAGE "INSERT oze_file ERROR"
    END IF
 
END FUNCTION
#Patch....NO.TQC-610037 <> #

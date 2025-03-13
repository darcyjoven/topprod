# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimq411.4gl (copy from aimq410.4gl)
# Descriptions...: 多工廠多單位料件庫存數量查詢
# Date & Author..: 06/05/24 By kim
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-7A0118 07/11/05 By Carrier 取db分隔符時call s_dbstring()
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/03 By TSD.Martin GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A50098 10/05/27 By lutingting 展子孫寫法給為不展子孫 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm            RECORD
                   wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)
                   wc2  LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)
                  END RECORD,
    g_ima         RECORD
                   ima01  LIKE ima_file.ima01, # 料件編號
                   ima02  LIKE ima_file.ima02, # 品名規格
                   ima021 LIKE ima_file.ima021,# 品名規格
                   ima05  LIKE ima_file.ima05, # 版本
                   ima06  LIKE ima_file.ima06, # 分群碼
                   ima07  LIKE ima_file.ima07, # ABC碼
                   ima08  LIKE ima_file.ima08, # 來源碼
                   ima25  LIKE ima_file.ima25, #FUN-560186
#                  ima26  LIKE ima_file.ima26, # MRP庫存可用數量     #FUN-A20044
#                  ima261 LIKE ima_file.ima261,# 庫存不可用數量      #FUN-A20044 
#                  ima262 LIKE ima_file.ima262 # 庫存可用數量        #FUN-A20044
                   avl_stk_mpsmrp LIKE type_file.num15_3,            #FUN-A20044
                   unavl_stk      LIKE type_file.num15_3,            #FUN-A20044
                   avl_stk        LIKE type_file.num15_3             #FUN-A20044           
                  END RECORD,
    g_ima37       LIKE ima_file.ima37,
    g_ima38       LIKE ima_file.ima38,
    g_img         DYNAMIC ARRAY OF RECORD
                 #plant     LIKE azp_file.azp02, #營運中心代碼       #FUN-A50098
                  plant     LIKE azp_file.azp01, #營運中心代碼       #FUN-A50098
                  img02     LIKE img_file.img02, #倉庫編號
                  img03     LIKE img_file.img03, #存放位置
                  img04     LIKE img_file.img04, #存放批號
                  img23     LIKE img_file.img23,
                  imgg10_1  LIKE imgg_file.imgg10,
                  imgg10_2  LIKE imgg_file.imgg10,
                  imgg10_3  LIKE imgg_file.imgg10,
                  imgg10_4  LIKE imgg_file.imgg10,
                  imgg10_5  LIKE imgg_file.imgg10,
                  imgg10_6  LIKE imgg_file.imgg10,
                  imgg10_7  LIKE imgg_file.imgg10,
                  imgg10_8  LIKE imgg_file.imgg10,
                  imgg10_9  LIKE imgg_file.imgg10,
                  imgg10_10 LIKE imgg_file.imgg10
                  END RECORD,
    g_imgg10      ARRAY[10] OF LIKE img_file.img09,  #No.FUN-690026 VARCHAR(04)
    g_imgg10_tot  ARRAY[10] OF LIKE img_file.img10,  #No.FUN-690026 DEC(15,3)
    l_ac          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_cc          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_wc,g_wc2,g_wc3 string,              #No.FUN-580092 HCN
    g_flag        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_argv1       LIKE ima_file.ima01,    # INPUT ARGUMENT - 1
    g_query_flag  LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  #No.FUN-690026 SMALLINT
    g_sql         string,                 #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b       LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    g_rec_b2      LIKE type_file.num5     #單身筆數  #No.FUN-690026 SMALLINT
 
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_no_ask      LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031 HCN
 
MAIN
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET g_query_flag=1
    LET g_flag=1
 
    OPEN WINDOW q411_w WITH FORM "aim/42f/aimq411"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q411_q() END IF
 
    CALL q411_menu()
    CLOSE WINDOW q411_w
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION q411_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE   l_i   LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF g_argv1 != ' '
      THEN LET g_wc = "ima01 = '",g_argv1,"'"
	   LET g_wc2=" 1=1 "
   ELSE CLEAR FORM #清除畫面
        CALL g_img.clear()
        CALL cl_opmsg('q')
        CALL cl_set_comp_visible("imgg10_1,imgg10_2,imgg10_3,imgg10_4",TRUE)
        CALL cl_set_comp_visible("imgg10_5,imgg10_6,imgg10_7,imgg10_8",TRUE)
        CALL cl_set_comp_visible("imgg10_9,imgg10_10",TRUE)
        CALL cl_set_comp_visible("imgg10_1_tot,imgg10_2_tot,imgg10_3_tot",TRUE)
        CALL cl_set_comp_visible("imgg10_4_tot,imgg10_5_tot,imgg10_6_tot",TRUE)
        CALL cl_set_comp_visible("imgg10_7_tot,imgg10_8_tot,imgg10_9_tot",TRUE)
        CALL cl_set_comp_visible("imgg10_10_tot",TRUE)
        SELECT ze03 INTO g_msg FROM ze_file
         WHERE ze01 = 'asm-100' AND ze02 = g_lang
        CALL cl_set_comp_lab_text("dummy01",g_msg CLIPPED)
        FOR l_i = 1 TO 10
            LET g_msg = NULL
            CASE l_i
               WHEN '1'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-001' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_1",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_1_tot",g_msg CLIPPED)
               WHEN '2'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-002' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_2",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_2_tot",g_msg CLIPPED)
               WHEN '3'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-003' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_3",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_3_tot",g_msg CLIPPED)
               WHEN '4'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-004' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_4",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_4_tot",g_msg CLIPPED)
               WHEN '5'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-005' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_5",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_5_tot",g_msg CLIPPED)
               WHEN '6'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-006' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_6",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_6_tot",g_msg CLIPPED)
               WHEN '7'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-007' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_7",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_7_tot",g_msg CLIPPED)
               WHEN '8'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-008' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_8",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_8_tot",g_msg CLIPPED)
               WHEN '9'  SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-009' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_9",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_9_tot",g_msg CLIPPED)
               WHEN '10' SELECT ze03 INTO g_msg FROM ze_file
                          WHERE ze01 = 'asm-010' AND ze02 = g_lang
                         CALL cl_set_comp_att_text("imgg10_10",g_msg CLIPPED)
                         CALL cl_set_comp_att_text("imgg10_10_tot",g_msg CLIPPED)
            END CASE
        END FOR
           INITIALIZE g_ima.* TO NULL		#FUN-640213 add
           CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
           CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021 # 螢幕上取單頭條件
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
              ON ACTION CONTROLP    #FUN-4B0043
                 IF INFIELD(ima01) THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima01
                    NEXT FIELD ima01
                 END IF
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
           CALL q411_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
 
      IF g_wc2=' 1=1' THEN
         LET g_sql=" SELECT ima01 FROM ima_file ",
                   " WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql=" SELECT UNIQUE ima_file.ima01 FROM ima_file,img_file ",
                   " WHERE ima01=img01",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED
      END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q411_prepare FROM g_sql
   DECLARE q411_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q411_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF g_wc2=' 1=1' THEN
      LET g_sql=" SELECT COUNT(*) FROM ima_file ",
                " WHERE ",g_wc CLIPPED
    ELSE
      LET g_sql=" SELECT COUNT(UNIQUE ima01) FROM ima_file,img_file ",
                " WHERE ima01=img01",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q411_pp  FROM g_sql
   DECLARE q411_count   CURSOR FOR q411_pp
END FUNCTION
 
FUNCTION q411_b_askkey()
   CONSTRUCT g_wc2 ON img02,img03,img04,img23 FROM
	   s_img[1].img02,s_img[1].img03,s_img[1].img04,s_img[1].img23
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION
 
FUNCTION q411_menu()
   WHILE TRUE
      CALL q411_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q411_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q411_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q411_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q411_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q411_count
       FETCH q411_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q411_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q411_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q411_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q411_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q411_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q411_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q411_cs INTO g_ima.ima01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
#       SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,ima25,ima26,ima261,ima262,ima37,ima38 #FUN-560186 add ima25   #FUN-A20044
        SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,ima25,'','','',ima37,ima38 #FUN-A20044 
	  INTO g_ima.*,g_ima37,g_ima38
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
       RETURN
    END IF
 
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING g_ima.avl_stk_mpsmrp,g_ima.unavl_stk,g_ima.avl_stk    #FUN-A20044
    CALL q411_show()
END FUNCTION
 
FUNCTION q411_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q411_b_fill(g_wc2) #單身
   DISPLAY g_imgg10_tot[01] TO FORMONLY.imgg10_1_tot
   DISPLAY g_imgg10_tot[02] TO FORMONLY.imgg10_2_tot
   DISPLAY g_imgg10_tot[03] TO FORMONLY.imgg10_3_tot
   DISPLAY g_imgg10_tot[04] TO FORMONLY.imgg10_4_tot
   DISPLAY g_imgg10_tot[05] TO FORMONLY.imgg10_5_tot
   DISPLAY g_imgg10_tot[06] TO FORMONLY.imgg10_6_tot
   DISPLAY g_imgg10_tot[07] TO FORMONLY.imgg10_7_tot
   DISPLAY g_imgg10_tot[08] TO FORMONLY.imgg10_8_tot
   DISPLAY g_imgg10_tot[09] TO FORMONLY.imgg10_9_tot
   DISPLAY g_imgg10_tot[10] TO FORMONLY.imgg10_10_tot
   IF g_ima37='0' AND g_ima38!=0 AND
#     g_ima.ima262 < g_ima38 THEN             #FUN-A20044
      g_ima.avl_stk < g_ima38 THEN            #FUN-A20044     
      CALL cl_err(g_ima.ima01,'mfg1025',0)
   END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q411_b_fill(p_wc2)              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE p_wc2     STRING
   DEFINE l_i,l_j   LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE l_type    LIKE imgg_file.imgg00
   DEFINE l_val     LIKE img_file.img10
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_ima907  LIKE ima_file.ima907
   DEFINE l_msg     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(100)
   DEFINE l_msg_tot LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(100)
   DEFINE l_chr     LIKE type_file.chr3    #No.FUN-690026 VARCHAR(03)
   DEFINE l_flag    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_img     RECORD
                    azp01   LIKE azp_file.azp01,
                   #azp02   LIKE azp_file.azp02,     #FUN-A50098
                    img02   LIKE img_file.img02,
                    img03   LIKE img_file.img03,
                    img04   LIKE img_file.img04,
                    img23   LIKE img_file.img23
                    END RECORD
   DEFINE l_plant   LIKE azp_file.azp01
  #DEFINE l_dbname  LIKE azp_file.azp02            #FUN-A50098 
  #DEFINE l_dbs     LIKE azp_file.azp03            #FUN-A50098 
  #DEFINE l_plt_list STRING        ##FUN-980091    #FUN-A50098
 
   CALL cl_set_comp_visible("imgg10_1,imgg10_2,imgg10_3,imgg10_4",TRUE)
   CALL cl_set_comp_visible("imgg10_5,imgg10_6,imgg10_7,imgg10_8",TRUE)
   CALL cl_set_comp_visible("imgg10_9,imgg10_10",TRUE)
   CALL cl_set_comp_visible("imgg10_1_tot,imgg10_2_tot,imgg10_3_tot",TRUE)
   CALL cl_set_comp_visible("imgg10_4_tot,imgg10_5_tot,imgg10_6_tot",TRUE)
   CALL cl_set_comp_visible("imgg10_7_tot,imgg10_8_tot,imgg10_9_tot",TRUE)
   CALL cl_set_comp_visible("imgg10_10_tot",TRUE)
   CALL cl_set_comp_lab_text("dummy01",' ')
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
    WHERE ima01 = g_ima.ima01
   IF l_ima906 = '2' THEN LET l_type = '1' END IF
   IF l_ima906 = '3' THEN LET l_type = '2' END IF
   CALL g_imgg10.clear()
 
   DROP TABLE q411_img_file
#FUN-A50098--mod--str--
#  SELECT azp01,azp02,azp03,img_file.* FROM azp_file,img_file 
#                                     WHERE 1=2 INTO TEMP q411_img_file
   SELECT azw01,img_file.* FROM azw_file,img_file
                          WHERE 1=2 INTO TEMP q411_img_file
#FUN-A50098--mod--end
 
   DROP TABLE q411_imgg_file
#FUN-A50098--mod--str--
#  SELECT azp01,azp02,azp03,imgg_file.* FROM azp_file,imgg_file 
#                                     WHERE 1=2 INTO TEMP q411_imgg_file
   SELECT azw01,imgg_file.* FROM azw_file,imgg_file
                           WHERE 1=2 INTO TEMP q411_imgg_file
#FUN-A50098--mod--end
   
   #FUN-980091 mark ---(S)
   #DECLARE azp_c CURSOR FOR
   #   SELECT azp01,azp02,azp03 FROM azp_file
   #      WHERE azp053 != 'N'
   #      ORDER BY azp01
   #FUN-980091 mark ---(E)

#FUN-A50098--mod--str-- 
#  #FUN-980091 add 
#  LET g_sql="SELECT DISTINCT '','',azw05  FROM azw_file,azp_file",
#            " WHERE azw05 = azp03 ",
#            "   AND azp053 != 'N' ", 
#            "   AND azp03 IS NOT NULL ",
#            "   AND azp03 <> ' '      ",
#            "   AND azw01 IN ( SELECT zxy03 FROM zxy_file ",
#            "                   WHERE zxy01 ='",g_user CLIPPED,"')",
#            " ORDER BY azw05 "
  LET g_sql = "SELECT azw01 FROM azw_file ",
              " WHERE azwacti = 'Y'",
              "   AND azw01 IN (SELECT zxy03  FROM zxy_file ",
              "                  WHERE zxy01 = '",g_user CLIPPED,"')",
              " ORDER BY azw01"
#FUN-A50098--mod--end
 
   PREPARE q411_sel_pre1 FROM g_sql
   DECLARE azp_c CURSOR FOR q411_sel_pre1
  
   #FUN-980091 end 
  #FOREACH azp_c INTO l_plant,l_dbname,l_dbs    #FUN-A50098
   FOREACH azp_c INTO l_plant                   #FUN-A50098 
 
      LET l_plant=l_plant CLIPPED
    # LET l_dbname=l_dbname CLIPPED    #FUN-A50098   跨庫只需要PLANT即可
    # LET l_dbs=l_dbs CLIPPED          #FUN-A50098
 
      #FUN-980091 modify  ---(S)
      #LET l_sql="INSERT INTO q411_img_file SELECT '",l_plant,"','",
      #          l_dbname ,"','",l_dbs ,"',",
      #          "img_file.* FROM ",s_dbstring(l_dbs CLIPPED),"img_file ",  #FUN-820017
      #          " WHERE img01='",g_ima.ima01,"'"
 
     #CALL s_getplantlist(l_dbs) RETURNING l_plt_list      #FUN-A50098 mark 
 
#FUN-A50098--mod--str--
#     LET l_sql="INSERT INTO q411_img_file SELECT imgplant,azp02",
#               ",'",l_dbs CLIPPED ,"',",
#               "img_file.* FROM ",s_dbstring(l_dbs CLIPPED),"img_file,",  #FUN-820017
#                                  s_dbstring(l_dbs CLIPPED),"azp_file ",
#               " WHERE img01='",g_ima.ima01,"'",
#               "   AND imgplant = azp01 " 
#     #FUN-980091 modify  ---(E)
      LET l_sql = "INSERT INTO q411_img_file SELECT imgplant,",
                  "img_file.* FROM ",cl_get_target_table(l_plant,"img_file"),",",
                                     cl_get_target_table(l_plant,"azw_file"),
                  " WHERE img01='",g_ima.ima01,"'",
                  "   AND imgplant = azw01 "
#FUN-A50098--mod--end
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   
     #CALL cl_bef_sel(l_sql,l_plt_list) RETURNING l_sql   #FUN-980091 add    #FUN-A50098
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                   #FUN-A50098 
      PREPARE q411_ins1_pre FROM l_sql
      EXECUTE q411_ins1_pre
 
      #FUN-980091 modify  ---(S)
      #LET l_sql="INSERT INTO q411_imgg_file SELECT '",l_plant,"','",
      #          l_dbname,"','",l_dbs,"',",
      #          "imgg_file.* FROM ",s_dbstring(l_dbs CLIPPED),"imgg_file ",   #FUN-820017
      #          " WHERE imgg01='",g_ima.ima01,"'"
#FUN-A50098--mod--str--
#     LET l_sql="INSERT INTO q411_imgg_file SELECT imggplant,azp02 ",
#               ",'",l_dbs CLIPPED ,"',",
#               "imgg_file.* FROM ",s_dbstring(l_dbs CLIPPED),"imgg_file,",   #FUN-820017
#                                   s_dbstring(l_dbs CLIPPED),"azp_file ",
#               " WHERE imgg01='",g_ima.ima01,"'",
#               "   AND imggplant = azp01 " 
#     #FUN-980091 modify  ---(E)
      LET l_sql="INSERT INTO q411_imgg_file SELECT imggplant,",
                "imgg_file.* FROM ",cl_get_target_table(l_plant,"imgg_file"),",",
                                    cl_get_target_table(l_plant,"azw_file"),
                " WHERE imgg01='",g_ima.ima01,"'",
                "   AND imggplant = azw01 "
#FUN-A50098--mod--end
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
 
     #CALL cl_bef_sel(l_sql,l_plt_list) RETURNING l_sql   #FUN-980091 add    #FUN-A50098
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                   #FUN-A50098 
 
      PREPARE q411_ins2_pre FROM l_sql
      EXECUTE q411_ins2_pre
   END FOREACH
 
   DECLARE q410_imgg09 CURSOR FOR
      SELECT UNIQUE imgg09 FROM q411_imgg_file
   LET l_i = 1
   FOREACH q410_imgg09 INTO g_imgg10[l_i]
      IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_i = l_i + 1
      IF l_i > 10 THEN #FUN-650024
         EXIT FOREACH
      END IF
   END FOREACH
   LET l_cnt = l_i - 1
   IF l_cnt > 0 THEN
      SELECT ze03 INTO g_msg FROM ze_file
       WHERE ze01 = 'asm-100' AND ze02 = g_lang
      CALL cl_set_comp_lab_text("dummy01",g_msg CLIPPED)
   END IF
   FOR l_i = 1 TO 10
       LET l_chr=l_i
       LET l_msg="imgg10_",l_chr CLIPPED
       LET l_msg_tot=l_msg CLIPPED,'_tot'
       IF NOT cl_null(g_imgg10[l_i]) THEN
          SELECT gfe02 INTO g_msg FROM gfe_file WHERE gfe01=g_imgg10[l_i]
          IF STATUS THEN LET g_msg = g_imgg10[l_i] END IF   #MOD-5A0432
          CALL cl_set_comp_att_text(l_msg,g_msg CLIPPED)
          CALL cl_set_comp_att_text(l_msg_tot,g_msg CLIPPED)
       ELSE
          CALL cl_set_comp_visible(l_msg,FALSE)
          CALL cl_set_comp_visible(l_msg_tot,FALSE)
       END IF
       LET g_imgg10_tot[l_i]=0
   END FOR
 
   CALL g_img.clear()
   LET g_rec_b=0
   LET l_i = 1
 
  #LET l_sql = "SELECT UNIQUE azp01,azp02,img02,img03,img04,img23",    #FUN-A50098
   LET l_sql = "SELECT UNIQUE azw01,img02,img03,img04,img23",          #FUN-A50098
               " FROM q411_img_file WHERE img01 = '",
               g_ima.ima01,"' AND ", p_wc2 CLIPPED,
  #            " ORDER BY azp01,azp02,img02,img03"        #FUN-A50098
               " ORDER BY azw01,img02,img03"              #FUN-A50098
    PREPARE q410_pb FROM l_sql
    DECLARE q410_bcs CURSOR FOR q410_pb
 
    FOREACH q410_bcs INTO l_img.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_img[l_i].plant = l_img.azp01
        LET g_img[l_i].img02 = l_img.img02
        LET g_img[l_i].img03 = l_img.img03
        LET g_img[l_i].img04 = l_img.img04
        LET g_img[l_i].img23 = l_img.img23
        FOR l_j = 1 TO l_cnt
            LET l_val=0
            SELECT imgg10 INTO l_val FROM q411_imgg_file
             WHERE imgg01 = g_ima.ima01
               AND imgg02 = l_img.img02
               AND imgg03 = l_img.img03
               AND imgg04 = l_img.img04
               AND imgg09 = g_imgg10[l_j]
              #AND azp01  = l_img.azp01    #FUN-A50098
               AND azw01  = l_img.azp01    #FUN-A50098 
            IF cl_null(l_val) THEN LET l_val = 0 END IF
            CASE l_j
               WHEN '1'  LET g_img[l_i].imgg10_1=l_val
               WHEN '2'  LET g_img[l_i].imgg10_2=l_val
               WHEN '3'  LET g_img[l_i].imgg10_3=l_val
               WHEN '4'  LET g_img[l_i].imgg10_4=l_val
               WHEN '5'  LET g_img[l_i].imgg10_5=l_val
               WHEN '6'  LET g_img[l_i].imgg10_6=l_val
               WHEN '7'  LET g_img[l_i].imgg10_7=l_val
               WHEN '8'  LET g_img[l_i].imgg10_8=l_val
               WHEN '9'  LET g_img[l_i].imgg10_9=l_val
               WHEN '10' LET g_img[l_i].imgg10_10=l_val
            END CASE
            LET g_imgg10_tot[l_j]=g_imgg10_tot[l_j]+l_val
        END FOR
        LET l_i = l_i + 1
        IF l_i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_img.deleteElement(l_cc)
    LET g_rec_b=(l_i-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    IF g_rec_b != 0 THEN
       CALL fgl_set_arr_curr(1)
    END IF
END FUNCTION
 
FUNCTION q411_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q411_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q411_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q411_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q411_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 

# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Pattern name...: artq700.4gl
# Descriptions...: 料件庫存數量查詢
# Date & Author..: No.FUN-870006 09/03/03 By Sunyanchun
# Memo...........: 由aimq700客制
# Modify.........: No:FUN-870007 09/08/31 By Zhangyajun 程序移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10042 10/01/07 By destiny DB取值请取实体DB
# Modify.........: No:FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:TQC-AB0025 10/12/20 By chenying Sybase調整
# Modify.........: No:MOD-B30011 11/03/01 By huangtao 修正跨庫寫法
# Modify.........: No:FUN-B40039 11/04/26 By shiwuying 传参修改
# Modify.........: No:FUN-B40094 11/05/09 By wangxin 添加訂單備置量oeb905 
# Modify.........: No:TQC-B70039 11/07/06 By pauline 拿掉avl_stk_mspmrp欄位
# Modify.........: No:FUN-B80013 11/08/02 By pauline 單頭查詢條件不可為空
# Modify.........: No:FUN-B80080 11/08/10 By pauline 新增產品條碼欄位
# Modify.........: No:FUN-B80153 11/09/05 by pauline 增加期間異動ACTION
# Modify.........: No:MOD-CC0019 13/01/31 By Elise (1) 調整將串rta_file調整為LEFT OUTER JOIN
#                                                  (2) tm.wc請調整為主SQL的where條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm            RECORD
                   wc    LIKE type_file.chr1000, # Head Where condition 
                   wc2   LIKE type_file.chr1000  # Body Where condition  
                  END RECORD,
    g_ima         RECORD
                   rta05 LIKE rta_file.rta05,          #產品條碼   #FUN-B80080 add
                   ima01  LIKE ima_file.ima01, # 料件編號
                   ima02  LIKE ima_file.ima02, # 品名規格
                   ima021 LIKE ima_file.ima021,# 品名規格
                   ima05  LIKE ima_file.ima05, # 版本
                   ima06  LIKE ima_file.ima06, # 分群碼
                   ima07  LIKE ima_file.ima07, # ABC碼
                   ima08  LIKE ima_file.ima08, # 來源碼
#                   ima26  LIKE ima_file.ima26, # MRP庫存可用數量 FUN-A20044
#                   avl_stk_mpsmrp  LIKE type_file.num15_3, # MRP庫存可用數量 FUN-A20044    #TQC-B70039
#                   ima261 LIKE ima_file.ima261,# 庫存不可用數量 FUN-A20044
                   unavl_stk  LIKE type_file.num15_3,# 庫存不可用數量 FUN-A20044
#                   ima262 LIKE ima_file.ima262 # 庫存可用數量 FUN-A20044
                  avl_stk LIKE type_file.num15_3 # 庫存可用數量 FUN-A20044
                  END RECORD,
    g_ima37       LIKE ima_file.ima37,
    g_ima38       LIKE ima_file.ima38,
    g_img         DYNAMIC ARRAY OF RECORD
                   img02   LIKE img_file.img02, #倉庫編號
                   img03   LIKE img_file.img03, #存放位置
                   img04   LIKE img_file.img04, #存放批號
                   img23   LIKE img_file.img23, #是否為可用倉庫
                   img09   LIKE img_file.img09, #庫存單位
                   img10   LIKE img_file.img10, #庫存數量
                   oeb905  LIKE oeb_file.oeb905,#已備置量 #FUn-B40094 add
                   img21   LIKE img_file.img21, #Factor
                   img37   LIKE img_file.img37,  # Expire date
                   imgplant  LIKE img_file.imgplant
                  END RECORD,
    g_cmd         LIKE type_file.chr1000,      
   #g_argv1       LIKE ima_file.ima01,          #INPUT ARGUMENT - 1 #FUN-B40039
    g_argv1       STRING,                       #FUN-B40039
    g_argv2       LIKE azw_file.azw01,          #FUN-B40039
    g_query_flag  LIKE type_file.num5,          #第一次進入程式時即進入Query之後進入next
    g_sql          string,
    g_sql1         string,
    g_sql2         string,
    g_sql3         string,
    g_dbs         LIKE azp_file.azp03,
    g_imgplant      STRING,
    g_where       LIKE type_file.chr1000,
    g_rec_b       LIKE type_file.num5           #單身筆數  
 
DEFINE p_row,p_col    LIKE type_file.num5       
DEFINE g_cnt          LIKE type_file.num10   
DEFINE g_msg          LIKE type_file.chr1000 
DEFINE g_row_count    LIKE type_file.num10  
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10      
DEFINE mi_no_ask      LIKE type_file.num5     
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
DEFINE g_zxy03        LIKE zxy_file.zxy03    #No.TQC-A10042
DEFINE g_imgplant1    LIKE img_file.imgplant 
DEFINE l_ac           LIKE type_file.num10  #FUN-B80153 add

MAIN
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1      = ARG_VAL(1)          #FUN-B40039
   LET g_argv2      = ARG_VAL(2)          #FUN-B40039

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
      RETURNING g_time    
    LET g_query_flag=1
   #LET g_argv1      = ARG_VAL(1)          #參數值(1) Part# #FUN-B40039 移到上面
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q700_w AT p_row,p_col
         WITH FORM "art/42f/artq700"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible('rta05',FALSE)    #FUN-B80080 add
 
   #FUN-B40039 Begin---
    IF NOT cl_null(g_argv2) THEN
       LET g_auth = "(",s_get_plant_tree(g_argv2),")"
       LET g_imgplant1 = g_argv2
    ELSE
       LET g_imgplant1 = g_plant
    END IF
    IF NOT cl_null(g_argv1) THEN
       CALL q700_q()
    END IF
   #FUN-B40039 End-----
    CALL q700_menu()
    CLOSE WINDOW q700_w
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION q700_cs()
   DEFINE   l_cnt    LIKE type_file.num5    #SMALLINT
#MOD-B30011 -------------STA
   DEFINE l_n LIKE type_file.num5
   DEFINE l_azw05 LIKE azw_file.azw05
   DEFINE l_azw06 LIKE azw_file.azw06
#MOD-B30011 -------------END   
   DEFINE l_where STRING #FUN-B40039
   CALL cl_set_comp_visible('rta05',TRUE)    #FUN-B80080 add   

   LET g_imgplant = ""
  #FUN-B40039 Begin---
  #IF g_argv1 != ' '
  #   THEN LET tm.wc = "ima01 = '",g_argv1,"'"
  #     	   LET tm.wc2=" 1=1 "
  #   ELSE CLEAR FORM #清除畫面
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = cl_replace_str(g_argv1,"|","','")
      LET tm.wc = " ima01 IN ","('",tm.wc CLIPPED,"')"
      LET tm.wc2= " 1=1"
   ELSE
  #FUN-B40039 End-----
   CALL g_img.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           INITIALIZE g_ima.* TO NULL   
           CALL cl_set_head_visible("","YES")
           WHILE TRUE    #FUN-B80013 add
          #   CONSTRUCT BY NAME tm.wc ON ima01,ima02,ima021 # 螢幕上取單頭條件             #FUN-B80080 mark
             CONSTRUCT BY NAME tm.wc ON rta05,ima01,ima02,ima021 # 螢幕上取單頭條件       #FUN-B80080 add
 
                BEFORE CONSTRUCT
                   CALL cl_qbe_init()
                ON ACTION CONTROLP    
                   CASE                                    #FUN-B80080 add
                #   IF INFIELD(ima01) THEN                 #FUN-B80080 mark
                   WHEN INFIELD(ima01)                     #FUN-B80080 add
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ima"
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ima01
                      NEXT FIELD ima01
                #   END IF                                 #FUN-B80080 mark
              #FUN-B80080 add  START
                     WHEN INFIELD(rta05)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = 'c'
                       LET g_qryparam.form ="q_ima_q200"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO rta05
                       NEXT FIELD rta05
                   END CASE
              #FUN-B80080 add  END 
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
  		   CALL cl_qbe_display_condition(lc_qbe_sn)
        END CONSTRUCT
        LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
        IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
        IF tm.wc != ' 1=1' THEN EXIT WHILE END IF     #未下查詢條件  #FUN-B80013 add
           CALL cl_err('',9046,0)                                    #FUN-B80013 add
      END WHILE                                                      #FUN-B80013 add
      CALL q700_b_askkey()
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql1 = NULL
   LET g_sql2 = NULL
#FUN-B40039 Begin---
#  #No.TQC-A10042--begin
#  #LET g_sql3 = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
#  #             " WHERE zxy01 = '",g_user,"' ",
#  #             "   AND zxy03 = azp01  "
#  LET g_sql3 = "SELECT DISTINCT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
#  #DROP TABLE x
#  #SELECT azp03 FROM azp_file WHERE 1=0 INTO TEMP x   
#  #PREPARE q700_p1 FROM g_sql3
#  #DECLARE q700_c1 CURSOR FOR q700_p1
#  #    
#  #FOREACH q700_c1 INTO g_zxy03 
#  #   LET g_plant_new = g_zxy03
#  #   CALL s_gettrandbs()
#  #   LET g_dbs=g_dbs_tra      
#  #   INSERT INTO x VALUES(g_dbs)   
#  #END FOREACH 
#  #LET g_sql3="SELECT DISTINCT azp03 from x " 
#  #No.TQC-A10042--end
# #FUN-B40039 Begin---
# #IF g_where IS NOT NULL THEN
# #   LET g_sql3 = g_sql3," AND azp01 IN ",g_where
# #END IF
#  IF NOT cl_null(g_imgplant) THEN
#     LET l_where = g_imgplant
#     IF l_where.getIndexOf("*",1) > 0 THEN
#        LET g_sql3 = g_sql3," AND zxy03 LIKE '",cl_replace_str(l_where,"*","%"),"'"
#     ELSE
#        CALL q700_plant() RETURNING g_where
#        IF g_where IS NOT NULL THEN
#           LET g_sql3 = g_sql3," AND zxy03 IN ",g_where
#        END IF
#     END IF
#  END IF
#  IF NOT cl_null(g_argv2) THEN
#     LET g_sql3 = g_sql3," AND zxy03 IN ",g_auth
#  END IF
# #FUN-B40039 End-----
#  PREPARE pre_sel_azp FROM g_sql3
#  DECLARE q700_DB_cs CURSOR FOR pre_sel_azp
#  #No.TQC-A10042--begin
#  #FOREACH q700_DB_cs INTO g_dbs
#  FOREACH q700_DB_cs INTO g_zxy03
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:q700_DB_cs',SQLCA.sqlcode,1)
#        LET g_success = 'N'
#        EXIT FOREACH
#     END IF
#   #FUN-B40039 Begin---
#   ##MOD-B30011 ------------------STA
#   # SELECT azw05,azw06 INTO l_azw05,l_azw06 FROM azw_file WHERE azw01 = g_zxy03
#   # IF l_azw05 <> l_azw06 THEN    #門店
#   #   SELECT COUNT(*) INTO l_n FROM azw_file
#   #    WHERE azw05 = l_azw05
#   #      AND azw05 = azw06     #總部
#   #      AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user)   #有總部的權限
#   #   IF l_n > 0 THEN
#   #      CONTINUE FOREACH
#   #   END IF
#   # END IF
#   ##MOD-B30011 ------------------END
#   #FUN-B40039 End-----
#     #FUN-A50102 ---mark---str---
#     #LET g_plant_new = g_zxy03
#     #CALL s_gettrandbs()
#     #LET g_dbs=g_dbs_tra      
#     #FUN-A50102 ---mark---end---
#  #No.TQC-A10042--end   
#    #LET g_sql=" SELECT UNIQUE ima01,imgplant ",   #TQC-AB0025 mark
#     LET g_sql=" SELECT UNIQUE ima01,imgplant ",   #TQC-AB0025 add
#               #" FROM ",s_dbstring(g_dbs),"ima_file,",s_dbstring(g_dbs),"img_file ", #FUN-A50102
#               " FROM ",cl_get_target_table(g_zxy03, 'ima_file'),",",cl_get_target_table(g_zxy03, 'img_file'), #FUN-A50102
#               " WHERE ima01=img01",
#               "   AND ",tm.wc CLIPPED,
#               "   AND ",tm.wc2 CLIPPED,
#               " AND imgplant ='",g_zxy03,"'"
#     IF g_sql1 IS NULL  THEN
#        LET g_sql1 = g_sql
#     ELSE
#        LET g_sql1 = g_sql1," UNION ALL ",g_sql
#     END IF
#  END FOREACH
# #MOD-B30011 --------------STA
#  CALL cl_replace_sqldb(g_sql1) RETURNING g_sql1
#  CALL cl_parse_qry_sql(g_sql1, g_zxy03) RETURNING g_sql1
# #MOD-B30011 --------------END
   IF cl_null(tm.wc2) THEN LET tm.wc2=" 1=1" END IF
#   LET g_sql1=" SELECT ima01 FROM ",cl_get_target_table(g_imgplant1, 'ima_file'),   #FUN-B80080 mark
#              "  WHERE ",tm.wc,                                                     #FUN-B80080 mark
#              "  ORDER BY ima01 "                                                   #FUN-B80080 mark
#FUN-B80080 add START
   LET g_sql1="SELECT DISTINCT ima01 FROM ", cl_get_target_table(g_imgplant1, 'ima_file'), 
             #" OUTER JOIN ",      #MOD-CC0019 mark
              " LEFT OUTER JOIN ", #MOD-CC0019 add
              cl_get_target_table(g_imgplant1, 'rta_file'),
             #" ON rta01 = ima01 AND",  #MOD-CC0019 mark
             #"  ",tm.wc,               #MOD-CC0019 mark
              " ON ima01 = rta01 ", #MOD-CC0019 add
              " WHERE ",tm.wc,      #MOD-CC0019 add
              " ORDER BY ima01"
#FUN-B80080 add END
#FUN-B40039 End-----
   PREPARE q700_prepare FROM g_sql1
   DECLARE q700_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q700_prepare
 
  #FUN-B40039 Begin---
  #LET g_sql2 = "SELECT COUNT(DISTINCT ima01) FROM ","(",g_sql1,")"
  # LET g_sql2 = " SELECT COUNT(*) FROM ",cl_get_target_table(g_imgplant1, 'ima_file'),  #FUN-B80080 mark
  #              "  WHERE ",tm.wc                                                        #FUN-B80080 mark
   LET g_sql2 = " SELECT COUNT(*) FROM ( " ,                                                 #FUN-B80080 add
             "SELECT DISTINCT ima01 FROM ", cl_get_target_table(g_imgplant1, 'ima_file'), #FUN-B80080 add
            #" JOIN ",                                                                    #FUN-B80080 add #MOD-CC0019 mark
             " LEFT OUTER JOIN ", #MOD-CC0019 add
             cl_get_target_table(g_imgplant1, 'rta_file'),                                #FUN-B80080 add
            #" ON rta01 = ima01 AND",                                                     #FUN-B80080 add #MOD-CC0019 mark
            #"  ",tm.wc,                                                                  #FUN-B80080 add #MOD-CC0019 mark
             " ON ima01 = rta01 ", #MOD-CC0019 add
             " WHERE ",tm.wc,      #MOD-CC0019 add
             " ORDER BY ima01 )"                                                          #FUN-B80080 add
 DISPLAY g_sql2 
 #FUN-B40039 End-----
   PREPARE q700_pp FROM g_sql2
   DECLARE q700_count CURSOR FOR q700_pp
  CALL cl_set_comp_visible('rta05',FALSE)    #FUN-B80080 add
END FUNCTION
 
FUNCTION q700_b_askkey()
   CONSTRUCT tm.wc2 ON img02,img03,img04,imgplant FROM
	   s_img[1].img02,s_img[1].img03,s_img[1].img04,s_img[1].imgplant
      BEFORE CONSTRUCT
	 CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD imgplant
        IF get_fldbuf(imgplant) IS NOT NULL THEN
           LET g_imgplant = get_fldbuf(imgplant)
        END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask() 
      ON ACTION CONTROLP 
         IF INFIELD(imgplant) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azp"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imgplant
            NEXT FIELD imgplant
         END IF
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION
 
FUNCTION q700_menu()
 
   WHILE TRUE
      CALL q700_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q700_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "du_detail"
	    LET g_cmd = "aimq410 '",g_ima.ima01,"'"
	    CALL cl_cmdrun(g_cmd CLIPPED)
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
#FUN-B80153 add START
         WHEN "period_tran"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_ima.ima01) THEN
                  CONTINUE WHILE
               END IF
               CALL s_aimq102_q1(g_ima.ima01,g_img[l_ac].imgplant,g_img[l_ac].img02,'1')
            END IF
#FUN-B80153 add END


      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q700_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_img.clear() #FUN-B40039
    CLEAR FORM         #FUN-B40039
    CALL q700_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q700_count
       FETCH q700_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q700_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
    CALL cl_set_comp_visible('rta05',FALSE)    #FUN-B80080 add
END FUNCTION
 
FUNCTION q700_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    
    l_abso          LIKE type_file.num10,    #絕對的筆數 
    l_dbs           LIKE azp_file.azp01,
    l_sql           STRING,
    l_avl_stk_mspmrp   LIKE type_file.num15_3       #TQC-B70039
    CASE p_flag
       #FUN-B40039 Begin---
       #WHEN 'N' FETCH NEXT     q700_cs INTO g_ima.ima01,g_imgplant1
       #WHEN 'P' FETCH PREVIOUS q700_cs INTO g_ima.ima01,g_imgplant1
       #WHEN 'F' FETCH FIRST    q700_cs INTO g_ima.ima01,g_imgplant1
       #WHEN 'L' FETCH LAST     q700_cs INTO g_ima.ima01,g_imgplant1
        WHEN 'N' FETCH NEXT     q700_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q700_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q700_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q700_cs INTO g_ima.ima01
       #FUN-B40039 End-----
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
           #FETCH ABSOLUTE g_jump q700_cs INTO g_ima.ima01,g_imgplant1 #FUN-B40039
            FETCH ABSOLUTE g_jump q700_cs INTO g_ima.ima01             #FUN-B40039
            LET mi_no_ask = FALSE
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

  #FUN-A50102 ---mark---str--- 
  #LET g_plant_new = g_imgplant1
  #CALL s_gettrandbs()
  #LET l_dbs=g_dbs_tra  
  #FUN-A50102 ---mark---end---
 #LET l_sql="SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,ima26,ima261,ima262,ima37,ima38 ", #FUN-A20044
  LET l_sql="SELECT '',ima01,ima02,ima021,ima05,ima06,ima07,ima08,0,0,0,ima37,ima38 ", #FUN-A20044    #FUN-B80080 add '' 
           #" FROM ",l_dbs CLIPPED,"ima_file", #FUN-A50102
            " FROM ",cl_get_target_table(g_imgplant1, 'ima_file'), #FUN-A50102
            " WHERE ima01='",g_ima.ima01,"' "
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-A50102
  CALL cl_parse_qry_sql(l_sql, g_imgplant1) RETURNING l_sql    #FUN-A50102          
  PREPARE q700_p1 FROM l_sql
  EXECUTE q700_p1 INTO g_ima.*,g_ima37,g_ima38 
 #SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,ima26,ima261,ima262,ima37,ima38
 #  INTO g_ima.*,g_ima37,g_ima38
 #  FROM ima_file
 # WHERE ima01 = g_ima.ima01
  # CALL s_getstock(g_ima.ima01,g_plant)RETURNING g_ima.avl_stk_mpsmrp,g_ima.unavl_stk,g_ima.avl_stk #FUN-A20044   #TQC-B70039
    CALL s_getstock(g_ima.ima01,g_plant)RETURNING l_avl_stk_mspmrp,g_ima.unavl_stk,g_ima.avl_stk #FUN-A20044   #TQC-B70039
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  
       RETURN
    END IF
 
    CALL q700_show()
END FUNCTION
 
FUNCTION q700_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q700_b_fill() #單身
   IF g_ima37='0' AND g_ima38!=0 AND
#      g_ima.ima262 < g_ima38 THEN #FUN-A20044
      g_ima.avl_stk < g_ima38 THEN #FUN-A20044
      CALL cl_err(g_ima.ima01,'mfg1025',0)
   END IF
   CALL cl_show_fld_cont()       
END FUNCTION
 
FUNCTION q700_plant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n             LIKE type_file.num5
 
   LET g_where = ' '
   LET g_cnt = 0
   IF g_imgplant IS NULL THEN RETURN '' END IF
   LET tok = base.StringTokenizer.createExt(g_imgplant,"|",'',TRUE)
   LET g_where = "('"
   WHILE tok.hasMoreTokens()
      LET g_cnt = g_cnt + 1
      LET l_ck = tok.nextToken()
      SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01 = l_ck
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n = 0 THEN CONTINUE WHILE END IF
      LET g_where = g_where,l_ck,"','"
   END WHILE
   LET g_where = g_where[1,LENGTH(g_where)-2],")"
   IF g_cnt = 0 THEN RETURN '' END IF
   RETURN g_where
END FUNCTION   
 
FUNCTION q700_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000 
   DEFINE tot       LIKE img_file.img10  
#MOD-B30011 ------------STA
   DEFINE l_n LIKE type_file.num5
   DEFINE l_azw05 LIKE azw_file.azw05
   DEFINE l_azw06 LIKE azw_file.azw06 
#MOD-B30011 ------------END
   DEFINE l_where STRING #FUN-B40039

   #No.TQC-A10042--begin
   #LET g_sql3 = "SELECT DISTINCT azp03 FROM azp_file,zxy_file ",
   #             " WHERE zxy01 = '",g_user,"' ",
   #             "   AND zxy03 = azp01  "
   LET g_sql = "SELECT DISTINCT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' "
   #No.TQC-A10042--end                
  #FUN-B40039 Begin---
  #IF g_where IS NOT NULL THEN
  #   LET g_sql = g_sql," AND tqb01 IN ",g_where
  #END IF
   IF NOT cl_null(g_imgplant) THEN
      LET l_where = g_imgplant
      IF l_where.getIndexOf("*",1) > 0 THEN
         LET g_sql = g_sql," AND zxy03 LIKE '",cl_replace_str(l_where,"*","%"),"'"
      ELSE
         CALL q700_plant() RETURNING g_where
         IF g_where IS NOT NULL THEN
            LET g_sql = g_sql," AND zxy03 IN ",g_where
         END IF
      END IF
   END IF
   IF NOT cl_null(g_argv2) THEN
      LET g_sql = g_sql," AND zxy03 IN ",g_auth
   END IF
  #FUN-B40039 End-----
   LET g_rec_b=0
   LET g_cnt = 1
   LET tot   = 0
   CALL g_img.clear()
   PREPARE pre_sel_tqb1 FROM g_sql
   DECLARE q700_DB_cs1 CURSOR FOR pre_sel_tqb1
   #No.TQC-A10042--begin
#   FOREACH q700_DB_cs1 INTO g_dbs
   FOREACH q700_DB_cs1 INTO g_zxy03 
      #FUN-A50102 ---mark---str---
      #LET g_plant_new = g_zxy03
      #CALL s_gettrandbs()
      #LET g_dbs=g_dbs_tra     
      #FUN-A50102 ---mark---end---
   #No.TQC-A10042--end  
#FUN-B40039 Begin---
##MOD-B30011 ----------------STA
#   SELECT azw05,azw06 INTO l_azw05,l_azw06 FROM azw_file WHERE azw01 = g_zxy03 
#     IF l_azw05 <> l_azw06 THEN    #門店
#       SELECT COUNT(*) INTO l_n FROM azw_file
#        WHERE azw05 = l_azw05
#          AND azw05 = azw06     #總部
#          AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user)   #有總部的權限
#       IF l_n > 0 THEN
#          CONTINUE FOREACH
#       END IF
#     END IF
##MOD-B30011 ----------------END
#FUN-B40039 End-----
      LET l_sql =
               "SELECT img02,img03,img04,img23,img09,img10,'',img21,img37,imgplant", #FUN-B40094 add ''
               #" FROM  ",s_dbstring(g_dbs),"img_file", #FUN-A50102
                " FROM  ",cl_get_target_table(g_zxy03, 'img_file'), #FUN-A50102
               " WHERE img01 = '",g_ima.ima01,"' AND ", tm.wc2 CLIPPED,
               " AND imgplant ='",g_zxy03,"'", #FUN-B40039
               " ORDER BY img02,img03,img09"
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql                 #FUN-A50102
     #CALL cl_parse_qry_sql(l_sql, g_zxy03) RETURNING l_sql    #FUN-A50102         
      PREPARE q700_pb FROM l_sql
      DECLARE q700_bcs CURSOR FOR q700_pb
 
      FOREACH q700_bcs INTO g_img[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #FUN-B40094 add -------STA-------
         SELECT SUM(oeb905 * oeb05_fac) INTO g_img[g_cnt].oeb905
           FROM oeb_file,oea_file
          WHERE oeb04 = g_ima.ima01 AND oeb01 = oea01 AND 				
                oea00 <> '0' AND oeb19 = 'Y' AND oeb70 = 'N' AND 				
                oeb12 > oeb24 AND  oeb09 = g_img[g_cnt].img02 AND 				
                oeb091 = g_img[g_cnt].img03 AND 				
                oeb092 = g_img[g_cnt].img04				
         IF cl_null(g_img[g_cnt].oeb905) THEN LET g_img[g_cnt].oeb905 = 0 END IF
         #FUN-B40094 add -------END-------
         LET tot   = tot + g_img[g_cnt].img10*g_img[g_cnt].img21
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
	    EXIT FOREACH
         END IF
      END FOREACH
      CALL g_img.deleteElement(g_cnt)
   END FOREACH
   LET g_rec_b=(g_cnt-1)
   DISPLAY BY NAME tot
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

    #FUN-B80153 add START
     BEFORE ROW
        LET l_ac = ARR_CURR()
    #FUN-B80153 add END
 
      BEFORE DISPLAY
         IF g_sma.sma115 = 'N' THEN
            CALL cl_set_act_visible("du_detail",FALSE)
         ELSE
            CALL cl_set_act_visible("du_detail",TRUE)
         END IF
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()         
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY         
 
 
      ON ACTION previous
         CALL q700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
 
      ON ACTION jump
         CALL q700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY           
 
 
      ON ACTION next
         CALL q700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
 
      ON ACTION last
         CALL q700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY            
 
 
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
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION du_detail  
         LET g_action_choice = 'du_detail'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    
 
#FUN-B80153 add START
      ON ACTION period_tran
         LET g_action_choice="period_tran"
         EXIT DISPLAY
#FUN-B80153 add END

 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-870007
